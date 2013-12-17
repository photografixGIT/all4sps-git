<?php

/**
 * copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 *
 * this file may not be redistributed in whole or significant part
 * and is subject to the JTL-Software-GmbH license.
 *
 * license: http://jtl-software.de/jtlshop3license.html
 */
require_once (PFAD_ROOT . PFAD_INCLUDES . "suche_inc.php");
require_once (PFAD_ROOT . PFAD_INCLUDES . "filter_inc.php");

// Setze Besuch
setzeBesuchExt();
// setze seitentyp
setzeSeitenTyp(PAGE_ARTIKELLISTE);

$Einstellungen = getEinstellungen(array(
        CONF_GLOBAL,
        CONF_RSS,
        CONF_ARTIKELUEBERSICHT,
        CONF_VERGLEICHSLISTE,
        CONF_BEWERTUNG,
        CONF_NAVIGATIONSFILTER,
        CONF_BOXEN,
        CONF_ARTIKELDETAILS,
        CONF_METAANGABEN,
        CONF_SUCHSPECIAL,
        CONF_BILDER,
        CONF_PREISVERLAUF,
        CONF_AUSWAHLASSISTENT
));

$LiveSuche;
$suchanfrage = "";

// setze Kat in Session
if ($kKategorie > 0)
{
    $_SESSION['LetzteKategorie'] = $kKategorie;
    $AktuelleSeite = 'PRODUKTE';
}

// Artikelanzahl pro Seite
$nArtikelProSeite = 20;
if ($GLOBALS['Einstellungen']["artikeluebersicht"]["artikeluebersicht_artikelproseite"] > 0)
    $nArtikelProSeite = $GLOBALS['Einstellungen']["artikeluebersicht"]["artikeluebersicht_artikelproseite"];
if (isset($_SESSION["ArtikelProSeite"]) && $_SESSION["ArtikelProSeite"] > 0)
    $nArtikelProSeite = $_SESSION["ArtikelProSeite"];
    
    // Standardoptionen
$nArtikelProSeite_arr = array(
        5,
        10,
        25,
        50,
        100
);
$smarty->assign("ArtikelProSeite", $nArtikelProSeite_arr);

// Ab diesen Artikel rausholen
// $nLimitN = ($NaviFilter->nSeite - 1) * $nArtikelProSeite;
$oSuchergebnisse = new stdClass();
$oSuchergebnisse->Artikel = new ArtikelListe();
$oArtikel_arr = array();
$oSuchergebnisse->MerkmalFilter = array();
$oSuchergebnisse->Herstellerauswahl = array();
$oSuchergebnisse->Tags = array();
$oSuchergebnisse->Bewertung = array();
$oSuchergebnisse->Preisspanne = array();
$oSuchergebnisse->Suchspecial = array();
$oSuchergebnisse->SuchFilter = array();

if ($kSuchanfrage > 0)
{
    $oSuchanfrage = $GLOBALS['DB']->executeQuery("SELECT cSuche
                                                    FROM tsuchanfrage
                                                    WHERE kSuchanfrage=" . intval($kSuchanfrage), 1);
    
    if (isset($oSuchanfrage->cSuche) && strlen($oSuchanfrage->cSuche) > 0)
    {
        $NaviFilter->Suche->kSuchanfrage = $kSuchanfrage;
        $NaviFilter->Suche->cSuche = $oSuchanfrage->cSuche;
    }
}

// Suchcache beachten / erstellen
if (isset($NaviFilter->Suche->cSuche) && strlen($NaviFilter->Suche->cSuche) > 0)
    $NaviFilter->Suche->kSuchCache = bearbeiteSuchCache($NaviFilter);

$AktuelleKategorie = new stdClass();
$AufgeklappteKategorien = new stdClass();
if ($kKategorie > 0)
{
    $AktuelleKategorie = new Kategorie($kKategorie);
    $AufgeklappteKategorien = new KategorieListe();
    $AufgeklappteKategorien->getOpenCategories($AktuelleKategorie);
}
$startKat = new Kategorie();
$startKat->kKategorie = 0;

// Usersortierung
setzeUsersortierung($NaviFilter);

// Hole alle aktiven Sprachen
$NaviFilter->oSprache_arr = $GLOBALS['DB']->executeQuery("SELECT kSprache
                                                            FROM tsprache", 2);

// Filter SQL
$FilterSQL = bauFilterSQL($NaviFilter);

// Erweiterte Darstellung Artikelübersicht
gibErweiterteDarstellung($Einstellungen, $NaviFilter, $nDarstellung);

if ($_SESSION['oErweiterteDarstellung']->nAnzahlArtikel > 0)
    $nArtikelProSeite = $_SESSION['oErweiterteDarstellung']->nAnzahlArtikel;
    
    // $nArtikelProSeite auf max. 100 beschränken
if (intval($nArtikelProSeite) > 100)
    $nArtikelProSeite = 100;
    
    // Ab diesen Artikel rausholen
$nLimitN = ($NaviFilter->nSeite - 1) * $nArtikelProSeite;

baueArtikelAnzahl($FilterSQL, $oSuchergebnisse, $nArtikelProSeite, $nLimitN);

// $oSuchergebnisse->Artikel->elemente = gibArtikelKeys($FilterSQL,
// $nArtikelProSeite, $NaviFilter);
if (!isset($NaviFilter->Suche))
{
    $NaviFilter->Suche = new stdClass();
}
if (!isset($NaviFilter->Suche->cSuche))
{
    $NaviFilter->Suche->cSuche = '';
}
suchanfragenSpeichern($NaviFilter->Suche->cSuche, $oSuchergebnisse->GesamtanzahlArtikel);
$NaviFilter->Suche->kSuchanfrage = gibSuchanfrageKey($NaviFilter->Suche->cSuche, $_SESSION['kSprache']);
$oSuchergebnisse->Artikel->elemente = gibArtikelKeys($FilterSQL, $nArtikelProSeite, $NaviFilter);

// Umleiten falls SEO keine Artikel ergibt
doMainwordRedirect($NaviFilter, count($oSuchergebnisse->Artikel->elemente), $bSeo);

// Bestsellers
if (isset($GLOBALS['Einstellungen']["artikeluebersicht"]["artikelubersicht_bestseller_gruppieren"]) && $GLOBALS['Einstellungen']["artikeluebersicht"]["artikelubersicht_bestseller_gruppieren"] == "Y")
{
    $products = array();
    foreach ($oSuchergebnisse->Artikel->elemente as $product)
        $products[] = $product->kArtikel;
    
    $limit = 3;
    if (isset($GLOBALS['Einstellungen']["artikeluebersicht"]["artikeluebersicht_bestseller_anzahl"]))
        $limit = (int)$GLOBALS['Einstellungen']["artikeluebersicht"]["artikeluebersicht_bestseller_anzahl"];
    
    $minsells = 10;
    if (isset($GLOBALS['Einstellungen']["boxen"]["boxen_bestseller_minanzahl"]))
        $minsells = $GLOBALS['Einstellungen']["boxen"]["boxen_bestseller_minanzahl"];
    
    $bestsellers = Bestseller::buildBestsellers($products, $_SESSION['Kundengruppe']->kKundengruppe, $_SESSION["Kundengruppe"]->darfArtikelKategorienSehen, false, $limit, $minsells);
    Bestseller::ignoreProducts($oSuchergebnisse->Artikel->elemente, $bestsellers);
    
    $smarty->assign("oBestseller_arr", $bestsellers);
}

// Schauen ob die maximale Anzahl der Artikel >= der max. Anzahl die im Backend
// eingestellt wurde
if (intval($Einstellungen['artikeluebersicht']['suche_max_treffer']) > 0)
{
    if ($oSuchergebnisse->GesamtanzahlArtikel >= intval($Einstellungen['artikeluebersicht']['suche_max_treffer']))
        $smarty->assign("nMaxAnzahlArtikel", 1);
}

// Filteroptionen rausholen
$oSuchergebnisse->Herstellerauswahl = gibHerstellerFilterOptionen($FilterSQL, $NaviFilter);
$oSuchergebnisse->Bewertung = gibBewertungSterneFilterOptionen($FilterSQL, $NaviFilter);
$oSuchergebnisse->Tags = gibTagFilterOptionen($FilterSQL, $NaviFilter);
$oSuchergebnisse->TagsJSON = gibTagFilterJSONOptionen($FilterSQL, $NaviFilter);
$oSuchergebnisse->MerkmalFilter = gibMerkmalFilterOptionen($FilterSQL, $NaviFilter, $AktuelleKategorie, function_exists("starteAuswahlAssistent"));
$oSuchergebnisse->Preisspanne = gibPreisspannenFilterOptionen($FilterSQL, $NaviFilter, $oSuchergebnisse);
$oSuchergebnisse->Kategorieauswahl = gibKategorieFilterOptionen($FilterSQL, $NaviFilter);
$oSuchergebnisse->SuchFilter = gibSuchFilterOptionen($FilterSQL, $NaviFilter);
$oSuchergebnisse->SuchFilterJSON = gibSuchFilterJSONOptionen($FilterSQL, $NaviFilter);

if (!$kSuchspecial)
    $oSuchergebnisse->Suchspecialauswahl = gibSuchspecialFilterOptionen($FilterSQL, $NaviFilter);
    
    /*
 * if(!session_notwendig()) $oSuchergebnisse->NaviURL = gibNaviURL($NaviFilter,
 * !session_notwendig(), null) . SEP_SEITE; else $oSuchergebnisse->NaviURL =
 * gibNaviURL($NaviFilter, !session_notwendig(), null) . "&seite=";
 */
$smarty->assign("oNaviSeite_arr", baueSeitenNaviURL($NaviFilter, !session_notwendig(), $oSuchergebnisse->Seitenzahlen, $Einstellungen['artikeluebersicht']['artikeluebersicht_max_seitenzahl']));

if (verifyGPCDataInteger("zahl") > 0)
{
    $_SESSION["ArtikelProSeite"] = verifyGPCDataInteger("zahl");
    setFsession(0, 0, $_SESSION["ArtikelProSeite"]);
}

if (!isset($_SESSION["ArtikelProSeite"]) && $Einstellungen['artikeluebersicht']['artikeluebersicht_erw_darstellung'] == "N")
{
    $_SESSION["ArtikelProSeite"] = intval($Einstellungen['artikeluebersicht']['artikeluebersicht_artikelproseite']);
    if ($_SESSION["ArtikelProSeite"] > 100)
        $_SESSION["ArtikelProSeite"] = 100;
}

// $Suchinhalt = getSuchInhalt($suchanfrage);
if (isset($LiveSuche->kSuchanfrage) && $LiveSuche->kSuchanfrage > 0)
{
    if (!$Suchinhalt->GesamtanzahlArtikel)
        $GLOBALS["DB"]->executeQuery("delete from tsuchanfrage where kSuchanfrage=" . $LiveSuche->kSuchanfrage, 4);
}

// $sprachURL = gibSprachURLSuche();
// Verfügbarkeitsbenachrichtigung allgemeiner CaptchaCode
$smarty->assign('code_benachrichtigung_verfuegbarkeit', generiereCaptchaCode($Einstellungen['artikeldetails']['benachrichtigung_abfragen_captcha']));

// Verfügbarkeitsbenachrichtigung pro Artikel
if (is_array($oSuchergebnisse->Artikel->elemente))
{
    // Work Around => hole Einstellung
    // $oEinstellungFix = $GLOBALS['DB']->executeQuery("SELECT cWert FROM
    // teinstellungen WHERE cName = 'benachrichtigung_nutzen'", 1);
    // $Einstellungen['artikeldetails']['benachrichtigung_nutzen'] =
    // $oEinstellungFix->cWert;
    
    foreach ($oSuchergebnisse->Artikel->elemente as $Artikel)
    {
        $n = gibVerfuegbarkeitsformularAnzeigen($Artikel, $Einstellungen['artikeldetails']['benachrichtigung_nutzen']);
        $Artikel->verfuegbarkeitsBenachrichtigung = $n;
    }
}

if (count($oSuchergebnisse->Artikel->elemente) == 0)
{
    if ($NaviFilter->Kategorie->kKategorie > 0)
    {
        // hole alle enthaltenen Kategorien
        $KategorieInhalt->Unterkategorien = new KategorieListe();
        $KategorieInhalt->Unterkategorien->getAllCategoriesOnLevel($NaviFilter->Kategorie->kKategorie);
        
        // wenn keine eigenen Artikel in dieser Kat, Top Angebote / Bestseller
        // aus unterkats + unterunterkats rausholen und anzeigen?
        if ($GLOBALS['Einstellungen']["artikeluebersicht"]["topbest_anzeigen"] == "Top" || $GLOBALS['Einstellungen']["artikeluebersicht"]["topbest_anzeigen"] == "TopBest")
        {
            $KategorieInhalt->TopArtikel = new ArtikelListe();
            $KategorieInhalt->TopArtikel->holeTopArtikel($KategorieInhalt->Unterkategorien);
        }
        if ($GLOBALS['Einstellungen']["artikeluebersicht"]["topbest_anzeigen"] == "Bestseller" || $GLOBALS['Einstellungen']["artikeluebersicht"]["topbest_anzeigen"] == "TopBest")
        {
            $KategorieInhalt->BestsellerArtikel = new ArtikelListe();
            $KategorieInhalt->BestsellerArtikel->holeBestsellerArtikel($KategorieInhalt->Unterkategorien, $KategorieInhalt->TopArtikel);
        }
        
        $smarty->assign('KategorieInhalt', $KategorieInhalt);
    }
    else
    {
        // Suchfeld anzeigen
        $oSuchergebnisse->SucheErfolglos = 1;
    }
}

erstelleFilterLoesenURLs(!session_notwendig());

// Header bauen
$NaviFilter->cBrotNaviName = gibBrotNaviName($oSuchergebnisse);
$oSuchergebnisse->SuchausdruckWrite = gibHeaderAnzeige($oSuchergebnisse);

// Mainword NaviBilder
unset($oNavigationsinfo);
$oNavigationsinfo = new stdClass();
$oNavigationsinfo->cName = "";
$oNavigationsinfo->cBildURL = "";

// Navigation
$cBrotNavi = "";
$oMeta = new stdClass();
$oMeta->cMetaTitle = "";
$oMeta->cMetaDescription = "";
$oMeta->cMetaKeywords = "";
if ($NaviFilter->Kategorie->kKategorie > 0)
{
    $oNavigationsinfo->oKategorie = $AktuelleKategorie;
    
    if ($Einstellungen['navigationsfilter']['kategorie_bild_anzeigen'] == "Y")
        $oNavigationsinfo->cName = $AktuelleKategorie->cName;
    elseif ($Einstellungen['navigationsfilter']['kategorie_bild_anzeigen'] == "BT")
    {
        $oNavigationsinfo->cName = $AktuelleKategorie->cName;
        $oNavigationsinfo->cBildURL = $AktuelleKategorie->getKategorieBild();
    }
    elseif ($Einstellungen['navigationsfilter']['kategorie_bild_anzeigen'] == "B")
        $oNavigationsinfo->cBildURL = $AktuelleKategorie->getKategorieBild();
    
    $cBrotNavi = createNavigation("PRODUKTE", $AufgeklappteKategorien);
}
elseif ($NaviFilter->Hersteller->kHersteller > 0)
{
    $oNavigationsinfo->oHersteller = new Hersteller($NaviFilter->Hersteller->kHersteller);
    
    if ($Einstellungen['navigationsfilter']['hersteller_bild_anzeigen'] == "Y")
        $oNavigationsinfo->cName = $oNavigationsinfo->oHersteller->cName;
    elseif ($Einstellungen['navigationsfilter']['hersteller_bild_anzeigen'] == "BT")
    {
        $oNavigationsinfo->cName = $oNavigationsinfo->oHersteller->cName;
        $oNavigationsinfo->cBildURL = $oNavigationsinfo->oHersteller->cBildpfadNormal;
    }
    elseif ($Einstellungen['navigationsfilter']['hersteller_bild_anzeigen'] == "B")
        $oNavigationsinfo->cBildURL = $oNavigationsinfo->oHersteller->cBildpfadNormal;
    
    $oMeta->cMetaTitle = $oNavigationsinfo->oHersteller->cMetaTitle;
    $oMeta->cMetaDescription = $oNavigationsinfo->oHersteller->cMetaDescription;
    $oMeta->cMetaKeywords = $oNavigationsinfo->oHersteller->cMetaKeywords;
    
    $cBrotNavi = createNavigation("", "", 0, $NaviFilter->cBrotNaviName, gibNaviURL($NaviFilter, !session_notwendig(), null));
}
elseif ($NaviFilter->MerkmalWert->kMerkmalWert > 0)
{
    $oNavigationsinfo->oMerkmalWert = new MerkmalWert($NaviFilter->MerkmalWert->kMerkmalWert);
    
    if ($Einstellungen['navigationsfilter']['merkmalwert_bild_anzeigen'] == "Y")
        $oNavigationsinfo->cName = $oNavigationsinfo->oMerkmalWert->cName;
    elseif ($Einstellungen['navigationsfilter']['merkmalwert_bild_anzeigen'] == "BT")
    {
        $oNavigationsinfo->cName = $oNavigationsinfo->oMerkmalWert->cName;
        $oNavigationsinfo->cBildURL = $oNavigationsinfo->oMerkmalWert->cBildpfadNormal;
    }
    elseif ($Einstellungen['navigationsfilter']['merkmalwert_bild_anzeigen'] == "B")
        $oNavigationsinfo->cBildURL = $oNavigationsinfo->oMerkmalWert->cBildpfadNormal;
    
    $oMeta->cMetaTitle = $oNavigationsinfo->oMerkmalWert->cMetaTitle;
    $oMeta->cMetaDescription = $oNavigationsinfo->oMerkmalWert->cMetaDescription;
    $oMeta->cMetaKeywords = $oNavigationsinfo->oMerkmalWert->cMetaKeywords;
    
    $cBrotNavi = createNavigation("", "", 0, $NaviFilter->cBrotNaviName, gibNaviURL($NaviFilter, !session_notwendig(), null));
}
elseif ($NaviFilter->Tag->kTag > 0)
{
    $cBrotNavi = createNavigation("", "", 0, $NaviFilter->cBrotNaviName, gibNaviURL($NaviFilter, !session_notwendig(), null));
}
elseif ($NaviFilter->Suchspecial->kKey > 0)
{
    $cBrotNavi = createNavigation("", "", 0, $NaviFilter->cBrotNaviName, gibNaviURL($NaviFilter, !session_notwendig(), null));
}
elseif (strlen($NaviFilter->Suche->cSuche) > 0)
{
    $cBrotNavi = createNavigation("", "", 0, $GLOBALS['oSprache']->gibWert('search', 'breadcrumb') . ": " . $NaviFilter->cBrotNaviName, gibNaviURL($NaviFilter, !session_notwendig(), null));
}

// Canonical
if (!strstr(basename(gibNaviURL($NaviFilter, !session_notwendig(), null)), ".php") || !SHOP_SEO)
{
    $cSeite = "";
    if (isset($oSuchergebnisse->Seitenzahlen->AktuelleSeite) && $oSuchergebnisse->Seitenzahlen->AktuelleSeite > 1)
        $cSeite = SEP_SEITE . $oSuchergebnisse->Seitenzahlen->AktuelleSeite;
    
    $cCanonicalURL = gibNaviURL($NaviFilter, !session_notwendig(), null, 0, true) . $cSeite;
}

// Auswahlassistent
if (function_exists("starteAuswahlAssistent"))
    starteAuswahlAssistent(AUSWAHLASSISTENT_ORT_KATEGORIE, $kKategorie, $_SESSION['kSprache'], $smarty, $Einstellungen['auswahlassistent']);
    
    // Work around fürs Template
$smarty->assign("SEARCHSPECIALS_TOPREVIEWS", SEARCHSPECIALS_TOPREVIEWS);
$smarty->assign('PFAD_ART_ABNAHMEINTERVALL', PFAD_ART_ABNAHMEINTERVALL);

// spezifische assigns
$smarty->assign('Navigation', $cBrotNavi);
// $smarty->assign('Brotnavi', $cBrotNavi);
$smarty->assign('Einstellungen', $Einstellungen);
$smarty->assign('Sortierliste', gibSortierliste($Einstellungen));
$smarty->assign('Einstellungen', $Einstellungen);
$smarty->assign('Suchergebnisse', $oSuchergebnisse);
$smarty->assign('requestURL', (isset($requestURL)) ? $requestURL : null);
$smarty->assign('sprachURL', (isset($requestURL)) ? $sprachURL : null);
$smarty->assign('oNavigationsinfo', $oNavigationsinfo);

// SEO Separatoren
$smarty->assign("SEP_SEITE", SEP_SEITE);
$smarty->assign("SEP_KAT", SEP_KAT);
$smarty->assign("SEP_HST", SEP_HST);
$smarty->assign("SEP_MERKMAL", SEP_MERKMAL);
//$smarty->assign("SEP_BEWERTUNG", SEP_BEWERTUNG);
//$smarty->assign("SEP_PREISSPANNE", SEP_PREISSPANNE);

$smarty->assign("SEO", !session_notwendig());
$smarty->assign("SESSION_NOTWENDIG", session_notwendig());

require_once (PFAD_INCLUDES . "letzterInclude.php");

// Hook
executeHook(HOOK_FILTER_PAGE);

// Metas
$oGlobaleMetaAngabenAssoc_arr = holeGlobaleMetaAngaben(); // Globale Metaangaben
$oExcludedKeywordsAssoc_arr = holeExcludedKeywords(); // Excluded Meta Keywords
$smarty->assign('meta_title', gibNaviMetaTitle($oSuchergebnisse->Artikel->elemente, $NaviFilter, $oSuchergebnisse, $oGlobaleMetaAngabenAssoc_arr, explode(" ", $oExcludedKeywordsAssoc_arr[$_SESSION['cISOSprache']]->cKeywords)));
$smarty->assign('meta_description', gibNaviMetaDescription($oSuchergebnisse->Artikel->elemente, $NaviFilter, $oSuchergebnisse, $oGlobaleMetaAngabenAssoc_arr, explode(" ", $oExcludedKeywordsAssoc_arr[$_SESSION['cISOSprache']]->cKeywords)));
$smarty->assign('meta_keywords', gibNaviMetaKeywords($oSuchergebnisse->Artikel->elemente, $NaviFilter, $oSuchergebnisse, $oGlobaleMetaAngabenAssoc_arr, explode(" ", $oExcludedKeywordsAssoc_arr[$_SESSION['cISOSprache']]->cKeywords)));

// Hook
executeHook(HOOK_FILTER_ENDE);

$smarty->display('suche.tpl');
?>