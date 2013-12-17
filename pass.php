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
require_once(PFAD_INCLUDES."mailTools.php");
$AktuelleSeite = "PASSWORT VERGESSEN";

//session starten
$session = new Session();

//erstelle $smarty
require_once(PFAD_INCLUDES."smartyInlcude.php");

//setze seitentyp
setzeSeitenTyp(PAGE_PASSWORTVERGESSEN);

//einstellungen holen
$Einstellungen = getEinstellungen(array(CONF_GLOBAL,CONF_RSS));
pruefeHttps();

$kLink = gibLinkKeySpecialSeite(LINKTYP_PASSWORD_VERGESSEN);

//hole alle OberKategorien
$AlleOberkategorien = new KategorieListe();
$AlleOberkategorien->getAllCategoriesOnLevel(0);
$AktuelleKategorie = new Kategorie(verifyGPCDataInteger("kategorie"));
$AufgeklappteKategorien = new KategorieListe();
$AufgeklappteKategorien->getOpenCategories($AktuelleKategorie);
$startKat = new Kategorie();
$startKat->kKategorie=0;

$hinweis;

$step='formular';

//loginbenutzer?
if (intval($_POST["passwort_vergessen"])==1 && isset($_POST["email"]) && isset($_POST["plz"]))
{
	$kunde = $GLOBALS["DB"]->executeQuery("select kKunde, cSperre from tkunde where cMail=\"".$GLOBALS["DB"]->escape($_POST["email"])."\" and cPLZ=\"".$GLOBALS["DB"]->escape($_POST["plz"])."\" and nRegistriert=1",1);
	if ($kunde->kKunde > 0 && $kunde->cSperre != "Y")
	{
      $oKunde = new Kunde($kunde->kKunde);
		$step='passwort versenden';

		$cPasswortKlartext = gibUID(10, strtoupper(substr(md5($oKunde->kKunde . $oKunde->cMail . time() . $oKunde->cStrasse), 5, 8)));
		$oKunde->cPasswort = cryptPasswort($cPasswortKlartext);

		$GLOBALS["DB"]->executeQuery("UPDATE tkunde SET cPasswort = '" . $oKunde->cPasswort . "' WHERE kKunde = " . $oKunde->kKunde, 4);
		$smarty->assign('Kunde', $oKunde);

		//mail raus
      $obj = new stdClass();
		$obj->tkunde = $oKunde;
		$obj->neues_passwort = $cPasswortKlartext;
		sendeMail(MAILTEMPLATE_PASSWORT_VERGESSEN, $obj);
	}
    elseif ($kunde->kKunde > 0 && $kunde->cSperre == "Y")
        $hinweis = $GLOBALS['oSprache']->gibWert('accountLocked', 'global');    
	else
		$hinweis = $GLOBALS['oSprache']->gibWert('incorrectEmailPlz', 'global');
}

if ($step=='formular')
{
}

// Canonical
$cCanonicalURL = gibShopURL() . "/pass.php";

// Metaangaben
$oMeta = baueSpecialSiteMeta(LINKTYP_PASSWORD_VERGESSEN);
$cMetaTitle = $oMeta->cTitle;
$cMetaDescription = $oMeta->cDesc;
$cMetaKeywords = $oMeta->cKeywords;

//spezifische assigns
$smarty->assign('step',$step);
$smarty->assign('hinweis',$hinweis);
$smarty->assign('Navigation',createNavigation($AktuelleSeite));
$smarty->assign('requestURL',$requestURL);
$smarty->assign('Einstellungen',$GLOBALS['GlobaleEinstellungen']);

require_once(PFAD_INCLUDES."letzterInclude.php");
$smarty->display('passwort_vergessen.tpl');
?>