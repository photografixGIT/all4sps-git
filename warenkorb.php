<?php
/**
 * copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 *
 * this file may not be redistributed in whole or significant part
 * and is subject to the JTL-Software-GmbH license.
 *
 * license: http://jtl-software.de/jtlshop3license.html
 */


require_once("includes/globalinclude.php");
require_once(PFAD_INCLUDES."warenkorb_inc.php");
require_once(PFAD_INCLUDES."bestellvorgang_inc.php");

$AktuelleSeite = "WARENKORB";
$MsgWarning = "";

//session starten
$session = new Session();
//einstellungen holen
$Einstellungen = getEinstellungen(array(CONF_GLOBAL,CONF_RSS,CONF_KAUFABWICKLUNG,CONF_KUNDEN,CONF_SONSTIGES));

//erstelle $smarty
require_once(PFAD_INCLUDES."smartyInlcude.php");

$Schnellkaufhinweis=checkeSchnellkauf();

pruefeHttps();

$kLink = gibLinkKeySpecialSeite(LINKTYP_WARENKORB);

//setze seitentyp
setzeSeitenTyp(PAGE_WARENKORB);

//Warenkorbaktualisierung?
uebernehmeWarenkorbAenderungen();

//validiere Konfigurationen
validiereWarenkorbKonfig();

//Versandermittlung?
if (isset($_POST['land']) && isset($_POST['plz']) && !ermittleVersandkosten($_POST['land'], $_POST['plz'], $MsgWarning))
	$MsgWarning = $GLOBALS['oSprache']->gibWert('missingParamShippingDetermination', 'errorMessages');
//Kupons bearbeiten
if (isset($_POST['Kuponcode']) && strlen($_POST['Kuponcode']) > 0 && !$_SESSION['Warenkorb']->posTypEnthalten(C_WARENKORBPOS_TYP_KUPON))
{
	// Kupon darf nicht im leeren Warenkorb eingelöst werden
	if (isset($_SESSION["Warenkorb"]) && $_SESSION["Warenkorb"]->gibAnzahlArtikelExt(array(C_WARENKORBPOS_TYP_ARTIKEL)) > 0)
	{
		$Kupon = $GLOBALS["DB"]->executeQuery("select * from tkupon where cCode='" . filterXSS($GLOBALS["DB"]->escape($_POST['Kuponcode'])) . "'", 1);        
		if (isset($Kupon->kKupon) && $Kupon->kKupon > 0 && $Kupon->cKuponTyp === "standard")
		{
			$Kuponfehler = checkeKupon($Kupon);            
			$nReturnValue = angabenKorrekt($Kuponfehler);
			// Hook
			executeHook(HOOK_WARENKORB_PAGE_KUPONANNEHMEN_PLAUSI);

			if ($nReturnValue)
			{
				kuponAnnehmen($Kupon);

				// Hook
				executeHook(HOOK_WARENKORB_PAGE_KUPONANNEHMEN);
			}
			else
				$smarty->assign('KuponcodeUngueltig',1);
		}
		elseif($Kupon->kKupon > 0 && $Kupon->cKuponTyp === "versandkupon")   // Versandfrei Kupon
		{
            $_SESSION['oVersandfreiKupon'] = $Kupon;
            $smarty->assign('cVersandfreiKuponLieferlaender_arr', explode(";", $Kupon->cLieferlaender));
            $smarty->assign('nVersandfreiKuponGueltig',1);
		}
		else $smarty->assign('KuponcodeUngueltig',1);
	}
}

// Gratis Geschenk bearbeiten
if(isset($_POST['gratis_geschenk']) && intval($_POST['gratis_geschenk']) == 1 && isset($_POST['gratishinzufuegen']))
{
	$kArtikelGeschenk = intval($_POST['gratisgeschenk']);

	// Prüfen ob der Artikel wirklich ein Gratis Geschenk ist
	$oArtikelGeschenk = $GLOBALS['DB']->executeQuery("SELECT tartikelattribut.kArtikel, tartikel.fLagerbestand, tartikel.cLagerKleinerNull, tartikel.cLagerBeachten
														FROM tartikelattribut
                                                        JOIN tartikel ON tartikel.kArtikel = tartikelattribut.kArtikel
														WHERE tartikelattribut.kArtikel=" . $kArtikelGeschenk . "
															AND tartikelattribut.cName='" . FKT_ATTRIBUT_GRATISGESCHENK . "'
															AND CAST(tartikelattribut.cWert AS DECIMAL) <= " . $_SESSION["Warenkorb"]->gibGesamtsummeWarenExt(array(C_WARENKORBPOS_TYP_ARTIKEL), true), 1);

	if(isset($oArtikelGeschenk->kArtikel) && $oArtikelGeschenk->kArtikel > 0)
	{
        if($oArtikelGeschenk->fLagerbestand <= 0 && $oArtikelGeschenk->cLagerKleinerNull == "N" && $oArtikelGeschenk->cLagerBeachten == "Y")
            $MsgWarning = $GLOBALS['oSprache']->gibWert('freegiftsNostock', 'errorMessages');
        else
        {
            // Hook
            executeHook(HOOK_WARENKORB_PAGE_GRATISGESCHENKEINFUEGEN);

		    $_SESSION["Warenkorb"]->loescheSpezialPos(C_WARENKORBPOS_TYP_GRATISGESCHENK);
		    $_SESSION["Warenkorb"]->fuegeEin($kArtikelGeschenk, 1, array(), C_WARENKORBPOS_TYP_GRATISGESCHENK);
        }
	}
}

//hole aktuelle Kategorie, falls eine gesetzt
$AktuelleKategorie = new Kategorie(verifyGPCDataInteger("kategorie"));
$AufgeklappteKategorien = new KategorieListe();
$AufgeklappteKategorien->getOpenCategories($AktuelleKategorie);
$startKat = new Kategorie();
$startKat->kKategorie=0;

if (isset($_GET["fillOut"]))
{
    if (intval($_GET["fillOut"])==9 && $_SESSION['Kundengruppe']->Attribute[KNDGRP_ATTRIBUT_MINDESTBESTELLWERT]>0 && $_SESSION["Warenkorb"]->gibGesamtsummeWaren(1,0)<$_SESSION['Kundengruppe']->Attribute[KNDGRP_ATTRIBUT_MINDESTBESTELLWERT])
        $MsgWarning = $GLOBALS['oSprache']->gibWert('minordernotreached', 'checkout').' '.gibPreisStringLocalized($_SESSION['Kundengruppe']->Attribute[KNDGRP_ATTRIBUT_MINDESTBESTELLWERT]);
    if ( intval($_GET["fillOut"])==8)
        $MsgWarning = $GLOBALS['oSprache']->gibWert('orderNotPossibleNow', 'checkout');
    if (intval($_GET["fillOut"])==3)
        $MsgWarning = $GLOBALS['oSprache']->gibWert('yourbasketisempty', 'checkout');
    if (intval($_GET["fillOut"])==10)
    {
        $MsgWarning = $GLOBALS['oSprache']->gibWert('missingProducts', 'checkout');
        loescheAlleSpezialPos();
    }
    if (intval($_GET["fillOut"])==UPLOAD_ERROR_NEED_UPLOAD)
        $MsgWarning = "Bitte laden Sie alle notwendigen Dateien hoch";
}

$kKundengruppe = $_SESSION['Kundengruppe']->kKundengruppe;
if(isset($_SESSION['Kunde']) && $_SESSION['Kunde']->kKundengruppe > 0)
	$kKundengruppe = $_SESSION['Kunde']->kKundengruppe;

// Canonical
$cCanonicalURL = gibShopURL() . "/warenkorb.php";

// Metaangaben
$oMeta = baueSpecialSiteMeta(LINKTYP_WARENKORB);
$cMetaTitle = $oMeta->cTitle;
$cMetaDescription = $oMeta->cDesc;
$cMetaKeywords = $oMeta->cKeywords;

// Uploads
if(class_exists("Upload"))
{
   $oUploadSchema_arr = Upload::gibWarenkorbUploads($_SESSION['Warenkorb']);
   if ($oUploadSchema_arr)
   {
      $nMaxSize = Upload::uploadMax();
      $smarty->assign('cSessionID', session_id());
      $smarty->assign('nMaxUploadSize', $nMaxSize);
      $smarty->assign('cMaxUploadSize', Upload::formatGroesse($nMaxSize));
      $smarty->assign('oUploadSchema_arr', $oUploadSchema_arr);
   }
}

//spezifische assigns
$smarty->assign('Navigation',createNavigation($AktuelleSeite));
$smarty->assign('Einstellungen',$Einstellungen);
$smarty->assign('MsgWarning',$MsgWarning);
//$smarty->assign('WarensummeLocalized', $_SESSION["Warenkorb"]->gibGesamtsummeWarenLocalized());
//$smarty->assign('Steuerpositionen', $_SESSION["Warenkorb"]->gibSteuerpositionen());
$smarty->assign('Schnellkaufhinweis', $Schnellkaufhinweis);
$smarty->assign('requestURL',(isset($requestURL)) ? $requestURL : null);
$smarty->assign('laender',gibBelieferbareLaender($kKundengruppe));
$smarty->assign('KuponMoeglich',kuponMoeglich());
$smarty->assign('xselling', gibXSelling());
$smarty->assign('oArtikelGeschenk_arr', gibGratisGeschenke($Einstellungen));
$smarty->assign('BestellmengeHinweis', pruefeBestellMengeUndLagerbestand($Einstellungen));
$smarty->assign('PFAD_ART_ABNAHMEINTERVALL', PFAD_ART_ABNAHMEINTERVALL);
$smarty->assign('C_WARENKORBPOS_TYP_ARTIKEL', C_WARENKORBPOS_TYP_ARTIKEL);
$smarty->assign('C_WARENKORBPOS_TYP_GRATISGESCHENK', C_WARENKORBPOS_TYP_GRATISGESCHENK);
$smarty->assign('cErrorVersandkosten', (isset($cErrorVersandkosten)) ? $cErrorVersandkosten : null);
$smarty->assign('Warenkorb', $_SESSION['Warenkorb']);

if (isset($_SESSION['Warenkorbhinweise']) && $_SESSION['Warenkorbhinweise'])
{
	$smarty->assign('Warenkorbhinweise',$_SESSION['Warenkorbhinweise']);
	unset($_SESSION['Warenkorbhinweise']);
}

require_once(PFAD_INCLUDES."letzterInclude.php");

// Hook
executeHook(HOOK_WARENKORB_PAGE);

$smarty->display('warenkorb.tpl');
?>
