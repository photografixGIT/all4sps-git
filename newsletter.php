<?php
/**
 * copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 *
 * this file may not be redistributed in whole or significant part
 * and is subject to the JTL-Software-GmbH license.
 *
 * license: http://jtl-software.de/jtlshop3license.html
 */

// Includes
require_once("includes/globalinclude.php");
require_once(PFAD_ROOT . PFAD_INCLUDES . "newsletter_inc.php");
require_once(PFAD_ROOT . PFAD_INCLUDES . "seite_inc.php");
$AktuelleSeite = "NEWSLETTER";

//session starten
$session = new Session();

//erstelle $smarty
require_once(PFAD_ROOT . PFAD_INCLUDES . "smartyInlcude.php");

//setze seitentyp
setzeSeitenTyp(PAGE_NEWSLETTER);

$oLink = $GLOBALS['DB']->executeQuery("SELECT kLink FROM tlink WHERE nLinkart = " . LINKTYP_NEWSLETTER, 1);
$kLink = $oLink->kLink;

$Link = new stdClass();
if(isset($oLink->kLink) && $oLink->kLink > 0)
{
	//hole Link
	$Link = holeSeitenLink($oLink->kLink);
	setzeBesuch("kLink", $Link->kLink);
	$Link->Sprache = holeSeitenLinkSprache($oLink->kLink);
	$smarty->assign('Navigation', createNavigation($AktuelleSeite, 0, 0, $Link->Sprache->cName, $requestURL));
}
else
	$smarty->assign('Navigation', createNavigation($AktuelleSeite, 0, 0, $GLOBALS['oSprache']->gibWert('newsletter', 'breadcrumb'), "newsletter.php"));

//url
$requestURL = baueURL($Link, URLART_SEITE);
$sprachURL = baueSprachURLS($Link, URLART_SEITE);

$cHinweis = "";
$cFehler = "";

$cCanonicalURL = "";

$Einstellungen = getEinstellungen(array(CONF_GLOBAL,CONF_RSS,CONF_NEWSLETTER));

pruefeHttps();

//hole alle OberKategorien
$AlleOberkategorien = new KategorieListe();
$AlleOberkategorien->getAllCategoriesOnLevel(0);
$AktuelleKategorie = new Kategorie(verifyGPCDataInteger("kategorie"));
$AufgeklappteKategorien = new KategorieListe();
$AufgeklappteKategorien->getOpenCategories($AktuelleKategorie);
$startKat = new Kategorie();
$startKat->kKategorie=0;

$cOption = "eintragen";

// Freischaltcode wurde übergeben
if(strlen($_GET['fc']) > 0)
{
	$cOption = "freischalten";

	$cFreischaltCode = StringHandler::htmlentities(filterXSS($GLOBALS['DB']->escape(strip_tags($_GET['fc']))));

	$oNewsletterEmpfaenger = $GLOBALS['DB']->executeQuery("SELECT *
															FROM tnewsletterempfaenger
															WHERE cOptCode='" . $cFreischaltCode . "'", 1);

	if($oNewsletterEmpfaenger->kNewsletterEmpfaenger > 0)
	{
        // Hook
        executeHook(HOOK_NEWSLETTER_PAGE_EMPFAENGERFREISCHALTEN, array("oNewsletterEmpfaenger" => $oNewsletterEmpfaenger));

		// Newsletterempfaenger freischalten
		$GLOBALS['DB']->executeQuery("UPDATE tnewsletterempfaenger
										SET nAktiv=1
										WHERE kNewsletterEmpfaenger=" . $oNewsletterEmpfaenger->kNewsletterEmpfaenger, 3);
		
		// Prüfen ob mittlerweile ein Kundenkonto existiert und wenn ja, dann kKunde in tnewsletterempfänger aktualisieren
		$GLOBALS['DB']->executeQuery("UPDATE tnewsletterempfaenger, tkunde
										SET tnewsletterempfaenger.kKunde = tkunde.kKunde
										WHERE tkunde.cMail = tnewsletterempfaenger.cEmail
											AND tnewsletterempfaenger.kKunde=0", 3);

        // Protokollieren (freigeschaltet)
        $GLOBALS['DB']->executeQuery("UPDATE tnewsletterempfaengerhistory
                                        SET dOptCode = now()
                                        WHERE cOptCode = '" . $cFreischaltCode . "'
                                            AND cAktion = 'Eingetragen'", 4);

		$cHinweis = $GLOBALS['oSprache']->gibWert('newsletterActive', 'messages');
	}
	else
	{
		$cFehler = $GLOBALS['oSprache']->gibWert('newsletterNoactive', 'errorMessages');
	}
}

// Löschcode wurde übergeben
elseif(strlen($_GET['lc']) > 0)
{
	$cOption = "loeschen";

	$cLoeschCode = StringHandler::htmlentities(filterXSS($GLOBALS['DB']->escape(strip_tags($_GET['lc']))));

	$oNewsletterEmpfaenger = $GLOBALS['DB']->executeQuery("SELECT *
															FROM tnewsletterempfaenger
															WHERE cLoeschCode='" . $cLoeschCode . "'", 1);

	if(strlen($oNewsletterEmpfaenger->cLoeschCode) > 0)
	{
        // Hook
        executeHook(HOOK_NEWSLETTER_PAGE_EMPFAENGERLOESCHEN, array("oNewsletterEmpfaenger" => $oNewsletterEmpfaenger));
        
		$GLOBALS['DB']->executeQuery("DELETE FROM tnewsletterempfaenger
										WHERE cLoeschCode='" . $cLoeschCode . "'", 3);

        unset($oNewsletterEmpfaengerHistory);
        $oNewsletterEmpfaengerHistory->kSprache     = $oNewsletterEmpfaenger->kSprache;
        $oNewsletterEmpfaengerHistory->kKunde       = $oNewsletterEmpfaenger->kKunde;
        $oNewsletterEmpfaengerHistory->cAnrede      = $oNewsletterEmpfaenger->cAnrede;
        $oNewsletterEmpfaengerHistory->cVorname     = $oNewsletterEmpfaenger->cVorname;
        $oNewsletterEmpfaengerHistory->cNachname    = $oNewsletterEmpfaenger->cNachname;
        $oNewsletterEmpfaengerHistory->cEmail       = $oNewsletterEmpfaenger->cEmail;
        $oNewsletterEmpfaengerHistory->cOptCode     = $oNewsletterEmpfaenger->cOptCode;
        $oNewsletterEmpfaengerHistory->cLoeschCode  = $oNewsletterEmpfaenger->cLoeschCode;
        $oNewsletterEmpfaengerHistory->cAktion      = "Geloescht";
        $oNewsletterEmpfaengerHistory->dEingetragen = $oNewsletterEmpfaenger->dEingetragen;
        $oNewsletterEmpfaengerHistory->dAusgetragen = "now()";
        $oNewsletterEmpfaengerHistory->dOptCode     = "0000-00-00";

        $GLOBALS['DB']->insertRow("tnewsletterempfaengerhistory", $oNewsletterEmpfaengerHistory);
        
        // Hook
        executeHook(HOOK_NEWSLETTER_PAGE_HISTORYEMPFAENGEREINTRAGEN, array("oNewsletterEmpfaengerHistory" => $oNewsletterEmpfaengerHistory));
        
        // Blacklist
        $oBlacklist = new stdClass();
        $oBlacklist->cMail = $oNewsletterEmpfaenger->cEmail;
        $oBlacklist->dErstellt = "now()";
        $GLOBALS['DB']->insertRow("tnewsletterempfaengerblacklist", $oBlacklist);

		$cHinweis = $GLOBALS['oSprache']->gibWert('newsletterDelete', 'messages');
	}
	else
	{
		$cFehler = $GLOBALS['oSprache']->gibWert('newsletterNocode', 'errorMessages');
	}
}

// Abonnieren
if(intval($_POST['abonnieren']) == 1)
{
	require_once(PFAD_ROOT . PFAD_INCLUDES . "mailTools.php");
	require_once(PFAD_ROOT . PFAD_INCLUDES . "newsletter_inc.php");

	unset($oKunde);
	$oKunde->cAnrede = filterXSS($GLOBALS['DB']->escape(strip_tags($_POST["cAnrede"])));
	$oKunde->cVorname = filterXSS($GLOBALS['DB']->escape(strip_tags($_POST["cVorname"])));
	$oKunde->cNachname = filterXSS($GLOBALS['DB']->escape(strip_tags($_POST["cNachname"])));
	$oKunde->cEmail = filterXSS($GLOBALS['DB']->escape(strip_tags($_POST["cEmail"])));

    if(!pruefeEmailblacklist($oKunde->cEmail))
    {
	    $smarty->assign("oPlausi", fuegeNewsletterEmpfaengerEin($oKunde, true));
        
        $GLOBALS['DB']->executeQuery("DELETE FROM tnewsletterempfaengerblacklist
                                      WHERE cMail = '" . $oKunde->cEmail . "'", 3);
    }
    else
        $cFehler .= $GLOBALS['oSprache']->gibWert('kwkEmailblocked', 'errorMessages') . "<br />";
    
    $smarty->assign("cPost_arr", $_POST);
}

// Abmelden
elseif(intval($_POST['abmelden']) == 1)
{
	if(valid_email($_POST["cEmail"]))
	{
		unset($oNewsletterEmpfaenger);

		// Prüfen ob Email bereits vorhanden
		$oNewsletterEmpfaenger = $GLOBALS['DB']->executeQuery("SELECT *
																FROM tnewsletterempfaenger
																WHERE cEmail='" . StringHandler::htmlentities(filterXSS($GLOBALS['DB']->escape($_POST["cEmail"]))) . "'", 1);

		if($oNewsletterEmpfaenger->kNewsletterEmpfaenger > 0)
		{
			// Hook
			executeHook(HOOK_NEWSLETTER_PAGE_EMPFAENGERLOESCHEN, array("oNewsletterEmpfaenger" => $oNewsletterEmpfaenger));
			
			// Newsletterempfaenger löschen
			$GLOBALS['DB']->executeQuery("DELETE FROM tnewsletterempfaenger
											WHERE cEmail='" . StringHandler::htmlentities(filterXSS($GLOBALS['DB']->escape($_POST["cEmail"]))) . "'", 3);

            unset($oNewsletterEmpfaengerHistory);
            $oNewsletterEmpfaengerHistory->kSprache     = $oNewsletterEmpfaenger->kSprache;
            $oNewsletterEmpfaengerHistory->kKunde       = $oNewsletterEmpfaenger->kKunde;
            $oNewsletterEmpfaengerHistory->cAnrede      = $oNewsletterEmpfaenger->cAnrede;
            $oNewsletterEmpfaengerHistory->cVorname     = $oNewsletterEmpfaenger->cVorname;
            $oNewsletterEmpfaengerHistory->cNachname    = $oNewsletterEmpfaenger->cNachname;
            $oNewsletterEmpfaengerHistory->cEmail       = $oNewsletterEmpfaenger->cEmail;
            $oNewsletterEmpfaengerHistory->cOptCode     = $oNewsletterEmpfaenger->cOptCode;
            $oNewsletterEmpfaengerHistory->cLoeschCode  = $oNewsletterEmpfaenger->cLoeschCode;
            $oNewsletterEmpfaengerHistory->cAktion      = "Geloescht";
            $oNewsletterEmpfaengerHistory->dEingetragen = $oNewsletterEmpfaenger->dEingetragen;
            $oNewsletterEmpfaengerHistory->dAusgetragen = "now()";
            $oNewsletterEmpfaengerHistory->dOptCode     = "0000-00-00";

            $GLOBALS['DB']->insertRow("tnewsletterempfaengerhistory", $oNewsletterEmpfaengerHistory);
            
            // Hook
            executeHook(HOOK_NEWSLETTER_PAGE_HISTORYEMPFAENGEREINTRAGEN, array("oNewsletterEmpfaengerHistory" => $oNewsletterEmpfaengerHistory));
            
            // Blacklist
            $oBlacklist = new stdClass();
            $oBlacklist->cMail = $oNewsletterEmpfaenger->cEmail;
            $oBlacklist->dErstellt = "now()";
            $GLOBALS['DB']->insertRow("tnewsletterempfaengerblacklist", $oBlacklist);

			$cHinweis = $GLOBALS['oSprache']->gibWert('newsletterDelete', 'messages');
		}
		else
		{
			$cFehler = $GLOBALS['oSprache']->gibWert('newsletterNoexists', 'errorMessages');
		}
	}
	else
	{
		$cFehler = $GLOBALS['oSprache']->gibWert('newsletterWrongemail', 'errorMessages');
	}
}

// History anzeigen
elseif(intval($_GET['show']) > 0)
{
	$cOption = "anzeigen";

	$kNewsletterHistory = intval($_GET['show']);
	
	$oNewsletterHistory = $GLOBALS['DB']->executeQuery("SELECT kNewsletterHistory, nAnzahl, cBetreff, DATE_FORMAT(dStart, '%d.%m.%Y %H:%i') as Datum, cHTMLStatic, cKundengruppeKey
														FROM tnewsletterhistory
														WHERE kNewsletterHistory=" . $kNewsletterHistory . "
															", 1);

	$kKundengruppe = 0;
	if(isset($_SESSION['Kunde']->kKundengruppe) && intval($_SESSION['Kunde']->kKundengruppe) > 0)
		$kKundengruppe = intval($_SESSION['Kunde']->kKundengruppe);
	
	if($oNewsletterHistory->kNewsletterHistory > 0)
	{
		// Prüfe Kundengruppe
		if(pruefeNLHistoryKundengruppe($kKundengruppe, $oNewsletterHistory->cKundengruppeKey))
			$smarty->assign("oNewsletterHistory", $oNewsletterHistory);
	}
}

// Ist Kunde eingeloggt?
if($_SESSION['Kunde']->kKunde > 0)
{
    $oKunde = new Kunde($_SESSION['Kunde']->kKunde);
    if(pruefeObBereitsAbonnent($oKunde->kKunde))
        $smarty->assign("bBereitsAbonnent", true);
    else
        $smarty->assign("bBereitsAbonnent", false);

    $smarty->assign("oKunde", $oKunde);
}

// Canonical
$cCanonicalURL = gibShopURL() . "/newsletter.php";

// Metaangaben
$oMeta = baueSpecialSiteMeta(LINKTYP_NEWSLETTER);
$cMetaTitle = $oMeta->cTitle;
$cMetaDescription = $oMeta->cDesc;
$cMetaKeywords = $oMeta->cKeywords;

//$smarty->assign('Navigation',createNavigation($AktuelleSeite, 0, 0));
$smarty->assign("hinweis", $cHinweis);
$smarty->assign("fehler", $cFehler);
$smarty->assign("cOption", $cOption);
$smarty->assign('Einstellungen', $Einstellungen);
$smarty->assign("nAnzeigeOrt", CHECKBOX_ORT_NEWSLETTERANMELDUNG);

$smarty->assign('code_newsletter', generiereCaptchaCode($Einstellungen['newsletter']['newsletter_sicherheitscode']));

require_once(PFAD_ROOT . PFAD_INCLUDES . "letzterInclude.php");

// Hook
executeHook(HOOK_NEWSLETTER_PAGE);

$smarty->display('newsletter.tpl');
?>