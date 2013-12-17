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
require_once(PFAD_ROOT . PFAD_INCLUDES_EXT . "umfrage_inc.php");

$AktuelleSeite = "UMFRAGE";

//session starten
$session = new Session();

//erstelle $smarty
require_once(PFAD_ROOT . PFAD_INCLUDES . "smartyInlcude.php");

//url
$requestURL = baueURL($Link,URLART_SEITE);
$sprachURL = baueSprachURLS($Link,URLART_SEITE);

$cHinweis = "";
$cFehler = "";
$cCanonicalURL = "";
$step = "umfrage_uebersicht";
$nAktuelleSeite = 1;
$oUmfrageFrageTMP_arr = array();

//setze seitentyp
setzeSeitenTyp(PAGE_UMFRAGE);

$Einstellungen = getEinstellungen(array(CONF_GLOBAL,CONF_RSS,CONF_UMFRAGE));

loeseHttps();

$kLink = gibLinkKeySpecialSeite(LINKTYP_UMFRAGE);

//hole alle OberKategorien
$AlleOberkategorien = new KategorieListe();
$AlleOberkategorien->getAllCategoriesOnLevel(0);
$AktuelleKategorie = new Kategorie(verifyGPCDataInteger("kategorie"));
$AufgeklappteKategorien = new KategorieListe();
$AufgeklappteKategorien->getOpenCategories($AktuelleKategorie);
$startKat = new Kategorie();
$startKat->kKategorie=0;

// Umfrage durchführen
if(verifyGPCDataInteger('u') > 0 || $kUmfrage > 0)
{
	$step = "umfrage_uebersicht";

	// Umfrage durchführen
	if(verifyGPCDataInteger('u') > 0)
		$kUmfrage = verifyGPCDataInteger('u');

	$kUmfrage = intval($kUmfrage);

	if(($Einstellungen['umfrage']['umfrage_einloggen'] == "Y" && $_SESSION['Kunde']->kKunde > 0) || $Einstellungen['umfrage']['umfrage_einloggen'] == "N")
	{
		// Umfrage holen
		$oUmfrage = holeAktuelleUmfrage($kUmfrage);

		if($oUmfrage->kUmfrage > 0)
		{
            // Rausgenommen weil teilweise auf xxx.xxx.*.* geprüft wurde und das ist overkill
            // Nun wird auf die von tbesucher generierte cID geprüft
			//if(pruefeUserUmfrage($oUmfrage->kUmfrage, $_SESSION['Kunde']->kKunde, gibIP()))
            if(pruefeUserUmfrage($oUmfrage->kUmfrage, $_SESSION['Kunde']->kKunde, $_SESSION['oBesucher']->cID))
			//if($oUmfrage->kUmfrage > 0)
			{
				$step = "umfrage_durchfuehren";

				// Auswertung
				if(isset($_POST["end"]))
				{
					speicherFragenInSession($_POST);

					if(pruefeEingabe($_POST) > 0)
						$cFehler .= $GLOBALS['oSprache']->gibWert('pollRequired', 'errorMessages') . "<br>";
					else if($_SESSION['Umfrage']->nEnde == 0)
					{
						$step = "umfrage_ergebnis";
						$nAktuelleSeite = verifyGPCDataInteger('s');

                        // Hook
                        executeHook(HOOK_UMFRAGE_PAGE_UMFRAGEERGEBNIS);

						// Auswertung						
						bearbeiteUmfrageAuswertung($oUmfrage);
					}
					else
						$step = "umfrage_uebersicht";
				}

				if($step == "umfrage_durchfuehren")
				{				
					$oNavi_arr = array();
				
					// Durchfürhung					
					bearbeiteUmfrageDurchfuehrung($kUmfrage, $oUmfrage, $oUmfrageFrageTMP_arr, $oNavi_arr, $nAktuelleSeite);
				}

				// Canonical
				if(!strstr(baueURL($oUmfrage, URLART_UMFRAGE), ".php") == 0 && !SHOP_SEO)
					$cCanonicalURL = URL_SHOP . "/" . baueURL($oUmfrage, URLART_UMFRAGE);

				$_SESSION['Umfrage']->kUmfrage = $oUmfrage->kUmfrage;
				$smarty->assign('Navigation',createNavigation($AktuelleSeite, 0, 0, $GLOBALS['oSprache']->gibWert('umfrage', 'breadcrumb') . " - " . $oUmfrage->cName, baueURL($oUmfrage, URLART_UMFRAGE)));
				$smarty->assign("oUmfrage", $oUmfrage);
				$smarty->assign("oNavi_arr", baueSeitenNavi($oUmfrageFrageTMP_arr, $oUmfrage->nAnzahlFragen));
				$smarty->assign("nAktuelleSeite", $nAktuelleSeite);
				$smarty->assign("nAnzahlSeiten", bestimmeAnzahlSeiten($oUmfrageFrageTMP_arr));

                // Hook
                executeHook(HOOK_UMFRAGE_PAGE_DURCHFUEHRUNG);
			}
			else
				$cFehler .= $GLOBALS['oSprache']->gibWert('pollAlreadydid', 'errorMessages') . "<br>";
		}
	}
	else
	{
		header ('Location: jtl.php?u=' . $kUmfrage . "&r=" . R_LOGIN_UMFRAGE . "&" . SID);
		exit();
		//$cFehler .= $GLOBALS['oSprache']->gibWert('pollPleaselogin', 'errorMessages');
	}
}

if($step == "umfrage_uebersicht")
{
	// Umfrage Übersicht
	$oUmfrage_arr = holeUmfrageUebersicht();


	if(is_array($oUmfrage_arr) && count($oUmfrage_arr) > 0)
	{
		foreach($oUmfrage_arr as $i => $oUmfrage)
		{
			$oUmfrage_arr[$i]->cURL = baueURL($oUmfrage, URLART_UMFRAGE);
		}
	}
    else
        $cFehler .= $GLOBALS['oSprache']->gibWert('pollNopoll', 'errorMessages') . "<br />";

	// Canonical
	$cCanonicalURL = URL_SHOP . "/umfrage.php";

	$smarty->assign('Navigation',createNavigation($AktuelleSeite, 0, 0, $GLOBALS['oSprache']->gibWert('umfragen', 'breadcrumb'), "umfrage.php?".SID));
	$smarty->assign("oUmfrage_arr", $oUmfrage_arr);

    // Hook
    executeHook(HOOK_UMFRAGE_PAGE_UEBERSICHT);
}

$smarty->assign("Einstellungen", $Einstellungen);
$smarty->assign("hinweis", $cHinweis);
$smarty->assign("fehler", $cFehler);
$smarty->assign("step", $step);
$smarty->assign("SID", $sid);

require_once(PFAD_ROOT . PFAD_INCLUDES . "letzterInclude.php");

// Hook
executeHook(HOOK_UMFRAGE_PAGE);

$smarty->display('umfrage.tpl');
?>