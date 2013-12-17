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
//die(print_r($_REQUEST,1));
//session starten
$session = new Session();
if (isset($_GET['logoff']) && intval($_GET['logoff'])==1)
{
	session_destroy();
	$session = new Session();
}

if (!$_SESSION["Kundengruppe"]->darfArtikelKategorienSehen)
{
    //falls Artikel/Kategorien nicht gesehen werden dürfen -> login
    header('Location: '.URL_SHOP.'/jtl.php?li=1');
    exit;
}

// Interner Parameter Handler
include(PFAD_ROOT . PFAD_INCLUDES . "parameterintern_inc.php");

// Redirect POST
// Wurde ein Kindartikel zum Vaterumgeleitet? Falls ja => Redirect POST Daten entpacken und zuweisen
if(isset($_GET['cRP']) && strlen($_GET['cRP']) > 0)
{
	$cRP_arr = explode("&", base64_decode($_GET['cRP']));
	if(is_array($cRP_arr) && count($cRP_arr) > 0)
	{
		foreach($cRP_arr as $cRP)
		{
			list($cName, $cWert) = explode("=", $cRP);
			$_POST[$cName] = $cWert;
		}
	}
}

$oSuchergebnisse = new stdClass();
$cFehler = "";

//suche
$cSuche = verifyGPDataString('suche');
if (strlen(verifyGPDataString('suchausdruck')) > 0)
	$cSuche = verifyGPDataString('suchausdruck');

// Old kLink
$kLink = $kSeite;

// Anzahl
$nArtikelProSeite = verifyGPCDataInteger("af");
setzeArtikelProSeite($nArtikelProSeite);

//misc
$vergleichsliste = verifyGPCDataInteger('vla');

// Hole alle aktiven Sprachen
if (isset($NaviFilter->oSprache_arr))
	unset($NaviFilter->oSprache_arr);

if (!isset($NaviFilter))
	$NaviFilter = new stdClass;

$NaviFilter->oSprache_arr = new stdClass;
$NaviFilter->oSprache_arr = $_SESSION['Sprachen'];

$MerkmalFilter = setzeMerkmalFilter();
$SuchFilter = setzeSuchFilter();
$TagFilter = setzeTagFilter();

$cParameter_arr = array("kKategorie" => $kKategorie,
                        "kHersteller" => $kHersteller,
                        "kArtikel" => $kArtikel,
                        "kVariKindArtikel" => $kVariKindArtikel,
                        "kSeite" => $kSeite,
                        "kLink" => $kLink,
                        "kSuchanfrage" => $kSuchanfrage,
                        "kMerkmalWert" => $kMerkmalWert,
                        "kTag" => $kTag,
                        "kSuchspecial" => $kSuchspecial,
                        "kNews" => $kNews,
                        "kNewsMonatsUebersicht" => $kNewsMonatsUebersicht,
                        "kNewsKategorie" => $kNewsKategorie,
                        "kUmfrage" => $kUmfrage,
                        "kKategorieFilter" => $kKategorieFilter,
                        "kHerstellerFilter" => $kHerstellerFilter,
                        "nBewertungSterneFilter" => $nBewertungSterneFilter,
                        "cPreisspannenFilter" => $cPreisspannenFilter,
                        "kSuchspecialFilter" => $kSuchspecialFilter,
                        "nSortierung" => $nSortierung,
                        "MerkmalFilter_arr" => $MerkmalFilter,
                        "TagFilter_arr" => $TagFilter,
                        "SuchFilter_arr" => $SuchFilter,                    
                        "nArtikelProSeite" => $nArtikelProSeite,
                        "cSuche" => $cSuche,
                        "seite" => (isset($seite))?$seite:0
    );

$NaviFilter = baueNaviFilter($NaviFilter, $cParameter_arr);

//erstelle $smarty
require_once(PFAD_INCLUDES."smartyInlcude.php");

// Hook
executeHook(HOOK_INDEX_NAVI_HEAD_POSTGET);

$Einstellungen = getEinstellungen(array(CONF_GLOBAL,CONF_RSS,CONF_VERGLEICHSLISTE,CONF_ARTIKELUEBERSICHT,CONF_BEWERTUNG,CONF_NAVIGATIONSFILTER,CONF_BOXEN,CONF_METAANGABEN,CONF_SUCHSPECIAL,CONF_BILDER,CONF_AUSWAHLASSISTENT));

// Suche prüfen
if(strlen($cSuche) > 0)
{    
    $nMindestzeichen = 3;
    if(intval($GLOBALS['Einstellungen']['artikeluebersicht']['suche_min_zeichen']) > 0)
        $nMindestzeichen = intval($GLOBALS['Einstellungen']['artikeluebersicht']['suche_min_zeichen']);
    
    preg_match("/[\wäÄüÜöÖß\-]{" . $nMindestzeichen . ",}/", $cSuche, $cTreffer_arr);
    
    if(count($cTreffer_arr) == 0)
    {
        $cSuche = "";
        $cFehler = $GLOBALS['oSprache']->gibWert('expressionHasTo', 'global') . " " . $nMindestzeichen . " " . $GLOBALS['oSprache']->gibWert('lettersDigits', 'global');
    }
}

//wurde was in den Warenkorb gelegt?
checkeWarenkorbEingang();

// Prüfe Variationskombi
if(pruefeIstVariKind($kArtikel))
{
    $kVariKindArtikel = $kArtikel;
    $kArtikel = gibkVaterArtikel($kArtikel);
}

// ToDo: Neue Funktion, Öffentliche Wunschliste
$kWunschliste = checkeWunschlisteParameter();
if(!$kWunschliste && strlen(verifyGPDataString('wlid')) > 0)
{
	header("Location: wunschliste.php?wlid=" . verifyGPDataString('wlid') . "&error=1" . SID);
	exit();
}

$smarty->assign("NaviFilter",$NaviFilter);

setzeBesuchExt();
loeseHttps();

//setze seitentyp
setzeSeitenTyp(PAGE_ARTIKELLISTE);

if ($kHersteller>0 ||
	$kSuchanfrage>0 ||
	$kMerkmalWert>0 ||
	$kTag>0 ||
	$kKategorie>0 ||
	strlen($cPreisspannenFilter) > 0 ||
	$nBewertungSterneFilter>0 ||
	$kHerstellerFilter>0 ||
	$kKategorieFilter>0 ||
	strlen($cSuche) > 0 ||
	$kSuchspecial > 0 ||
	$kSuchspecialFilter > 0 ||
	$kSuchFilter > 0)
{
	require_once(PFAD_ROOT . PFAD_INCLUDES . "suche_inc.php");
	require_once(PFAD_ROOT . PFAD_INCLUDES . "filter_inc.php");

	$LiveSuche;
	$suchanfrage = "";

	// setze Kat in Session
	if($kKategorie > 0)
		$_SESSION['LetzteKategorie'] = $kKategorie;
	
	//hole aktuelle Kategorie + bild, falls eine gesetzt
	$AktuelleKategorie = new Kategorie($kKategorie);

	//Artikelanzahl pro Seite
	if($nArtikelProSeite == 0)
	{
		$nArtikelProSeite = 20;
		if ($Einstellungen["artikeluebersicht"]["artikeluebersicht_artikelproseite"] > 0)
			$nArtikelProSeite = $Einstellungen["artikeluebersicht"]["artikeluebersicht_artikelproseite"];

		if (isset($_SESSION["ArtikelProSeite"]) && $_SESSION["ArtikelProSeite"] > 0)
			$nArtikelProSeite = $_SESSION["ArtikelProSeite"];
	}

	$oSuchergebnisse->Artikel = new ArtikelListe();
	$oArtikel_arr = array();
	$oSuchergebnisse->MerkmalFilter = array();
	$oSuchergebnisse->Herstellerauswahl = array();
	$oSuchergebnisse->Tags = array();
	$oSuchergebnisse->Bewertung = array();
	$oSuchergebnisse->Preisspanne = array();
	$oSuchergebnisse->Suchspecial = array();
	$oSuchergebnisse->SuchFilter = array();
		
	// JTL Search
	$oExtendedJTLSearchResponse = NULL;
	$bExtendedJTLSearch = false;
	
	// Hook
	executeHook(HOOK_NAVI_PRESUCHE, array("cValue" => &$NaviFilter->EchteSuche->cSuche, "bExtendedJTLSearch" => &$bExtendedJTLSearch));
			
	// Keine Suche sondern vielleicht nur ein Filter?
	if (strlen($cSuche) == 0)
		$bExtendedJTLSearch = false;
	
    // SuchFilter
    if(is_array($NaviFilter->SuchFilter) && count($NaviFilter->SuchFilter) > 0)
    {
        for ($i=0;$i<count($NaviFilter->SuchFilter);$i++)
        {
            $oSuchanfrage = $GLOBALS['DB']->executeQuery("SELECT cSuche
                                                            FROM tsuchanfrage
                                                            WHERE kSuchanfrage=" . $NaviFilter->SuchFilter[$i]->kSuchanfrage, 1);

            if(strlen($oSuchanfrage->cSuche) > 0)
            {
                // Nicht vorhandene Suchcaches werden hierdurch neu generiert
                $NaviFilter->Suche->cSuche = $oSuchanfrage->cSuche;
                $NaviFilter->SuchFilter[$i]->kSuchCache = bearbeiteSuchCache($NaviFilter);
                //$oSuchanfrage->cSuche = $NaviFilter->Suche->cSuche;
                unset($NaviFilter->Suche->cSuche);

                $NaviFilter->SuchFilter[$i]->cSuche = $oSuchanfrage->cSuche;
            }
        }
    }

	if($kSuchanfrage > 0)
	{
		$oSuchanfrage = $GLOBALS['DB']->executeQuery("SELECT cSuche
														FROM tsuchanfrage
														WHERE kSuchanfrage=" . intval($kSuchanfrage), 1);

		if(strlen($oSuchanfrage->cSuche) > 0)
        {
            $NaviFilter->Suche->kSuchanfrage = $kSuchanfrage;
			$NaviFilter->Suche->cSuche = $oSuchanfrage->cSuche;
        }
	}

	// SuchFilterWolke geklickt?
    /*
	if($kSuchFilter > 0)
	{
		//workaround über ->Suche->cSuche, um evtl. den suchcache neu zu erstellen
		$NaviFilter->Suche->cSuche = $NaviFilter->SuchFilter->cSuche;
		//in $NaviFilter->Suche->cSuche ist die cSuche vom Filter drin -> das braucht bearbeite SuchCache so
		$NaviFilter->SuchFilter->kSuchCache = bearbeiteSuchCache($NaviFilter);
		//wir wollen keine normale Suche triggern -> ist nur ein Filter!
		unset($NaviFilter->Suche->cSuche);
	}
    */

	//Suche da? Dann bearbeiten
	if(!$bExtendedJTLSearch && strlen($NaviFilter->Suche->cSuche) > 0)
	{
		//XSS abfangen
		$NaviFilter->Suche->cSuche = filterXSS($NaviFilter->Suche->cSuche, 1);
		$NaviFilter->Suche->kSuchCache = bearbeiteSuchCache($NaviFilter);
	}

	/*
	if ($NaviFilter->Suche->kSuchCache > 0 && !isset($_SESSION["nUsersortierungWahl"])) // nur bei initialsuche Sortierung zurücksetzen
    {
        $_SESSION["UsersortierungVorSuche"] = $_SESSION["Usersortierung"];
        $_SESSION["Usersortierung"] = SEARCH_SORT_STANDARD;
        //sortierung nicht auf die Einstellung setzen, da Suche!
//        if(intval($Einstellungen['artikeluebersicht']['artikeluebersicht_artikelsortierung']) > 0)
//            $_SESSION["Usersortierung"] = intval($Einstellungen['artikeluebersicht']['artikeluebersicht_artikelsortierung']);
    }
    else
    {
        $_SESSION["Usersortierung"] = $_SESSION["UsersortierungVorSuche"];
    }
	*/

	// Usersortierung
	setzeUsersortierung($NaviFilter);

    // Filter SQL
	$FilterSQL = bauFilterSQL($NaviFilter);

    // Erweiterte Darstellung Artikelübersicht
    //die(var_dump($nDarstellung));
    gibErweiterteDarstellung($Einstellungen, $NaviFilter, $nDarstellung);

    if($_SESSION['oErweiterteDarstellung']->nAnzahlArtikel > 0)
        $nArtikelProSeite = $_SESSION['oErweiterteDarstellung']->nAnzahlArtikel;

	/*
    if (verifyGPCDataInteger("Sortierung")>0)
    {
        $_SESSION["Usersortierung"] = verifyGPCDataInteger("Sortierung");
        $_SESSION["nUsersortierungWahl"] = 1;
        $oSuchergebnisse->Sortierung = $_SESSION["Usersortierung"];
        setFsession(0,$_SESSION["Usersortierung"],0);
    }
	*/

    if (verifyGPCDataInteger("af")>0)
    {
        $_SESSION["ArtikelProSeite"] = verifyGPCDataInteger("af");
        setFsession(0,0,$_SESSION["ArtikelProSeite"]);
        $nArtikelProSeite = $_SESSION["ArtikelProSeite"];

        if(isset($_SESSION['oErweiterteDarstellung']))
            $_SESSION['oErweiterteDarstellung']->nAnzahlArtikel = $_SESSION["ArtikelProSeite"];
    }

    //if (!isset($_SESSION["Usersortierung"]))
        //$_SESSION["Usersortierung"] = $Einstellungen['artikeluebersicht']['artikeluebersicht_artikelsortierung'];
    if (!isset($_SESSION["ArtikelProSeite"]) && $Einstellungen['artikeluebersicht']['artikeluebersicht_erw_darstellung'] == "N")
	{
        $_SESSION["ArtikelProSeite"] = intval($Einstellungen['artikeluebersicht']['artikeluebersicht_artikelproseite']);
		if($_SESSION["ArtikelProSeite"] > 100)
		    $_SESSION["ArtikelProSeite"] = 100;
	}

    // $nArtikelProSeite auf max. 100 beschränken
	if(intval($nArtikelProSeite) > 100)
		$nArtikelProSeite = 100;
		
	// Hook
	executeHook(HOOK_NAVI_SUCHE, array("bExtendedJTLSearch" => $bExtendedJTLSearch, "oExtendedJTLSearchResponse" => &$oExtendedJTLSearchResponse, "cValue" => &$NaviFilter->EchteSuche->cSuche, "nArtikelProSeite" => &$nArtikelProSeite, "nSeite" => &$NaviFilter->nSeite, "nSortierung" => (isset($oSuchergebnisse->Sortierung)) ? $oSuchergebnisse->Sortierung : null, "bLagerbeachten" => $Einstellungen['global']['artikel_artikelanzeigefilter'] == EINSTELLUNGEN_ARTIKELANZEIGEFILTER_LAGERNULL ? true : false));
				
    //Ab diesen Artikel rausholen
    $nLimitN = ($NaviFilter->nSeite - 1) * $nArtikelProSeite;

	// JTL Search
	if (!$bExtendedJTLSearch)
		baueArtikelAnzahl($FilterSQL, $oSuchergebnisse, $nArtikelProSeite, $nLimitN);
		
	$bEchteSuche = false;
    if (!$bExtendedJTLSearch && strlen($cSuche) > 0)
        $bEchteSuche = true;

    if (!$bExtendedJTLSearch)
    {
		suchanfragenSpeichern($NaviFilter->Suche->cSuche, $oSuchergebnisse->GesamtanzahlArtikel, $bEchteSuche);
	    $NaviFilter->Suche->kSuchanfrage = gibSuchanfrageKey($NaviFilter->Suche->cSuche, $_SESSION['kSprache']);
    }
	
    // JTL Search
    if ($bExtendedJTLSearch)
    {
    	$oSuchergebnisse->Artikel->elemente = gibArtikelKeysExtendedJTLSearch($oExtendedJTLSearchResponse);
    	buildSearchResultPage($oSuchergebnisse, $oExtendedJTLSearchResponse->oSearch->nItemFound, $nLimitN, $GLOBALS["NaviFilter"]->nSeite, $nArtikelProSeite, $Einstellungen['artikeluebersicht']['artikeluebersicht_max_seitenzahl']);
    }
    else
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
    
    $cFilterShopURL = "";
    if ($bExtendedJTLSearch)
    {
	    $cFilter_arr = JtlSearch::getFilter($_GET);
	    $cFilterShopURL = JtlSearch::buildFilterShopURL($cFilter_arr);
    }
    
	$smarty->assign("oNaviSeite_arr", baueSeitenNaviURL($NaviFilter, !session_notwendig(), $oSuchergebnisse->Seitenzahlen, $Einstellungen['artikeluebersicht']['artikeluebersicht_max_seitenzahl'], $cFilterShopURL));

    // Schauen ob die maximale Anzahl der Artikel >= der max. Anzahl die im Backend eingestellt wurde
    if(intval($Einstellungen['artikeluebersicht']['suche_max_treffer']) > 0)
    {
        if($oSuchergebnisse->GesamtanzahlArtikel >= intval($Einstellungen['artikeluebersicht']['suche_max_treffer']))
            $smarty->assign("nMaxAnzahlArtikel", 1);
    }

	/*
    $bEchteSuche = false;
    if(strlen($cSuche) > 0)
        $bEchteSuche = true;

	suchanfragenSpeichern($NaviFilter->Suche->cSuche, $oSuchergebnisse->GesamtanzahlArtikel, $bEchteSuche);
    $NaviFilter->Suche->kSuchanfrage = gibSuchanfrageKey($NaviFilter->Suche->cSuche, $_SESSION['kSprache']);
	*/

    //Filteroptionen rausholen
    if (!$bExtendedJTLSearch)
    {
	    $oSuchergebnisse->Herstellerauswahl = gibHerstellerFilterOptionen($FilterSQL, $NaviFilter);
	    $oSuchergebnisse->Bewertung = gibBewertungSterneFilterOptionen($FilterSQL, $NaviFilter);
	    $oSuchergebnisse->Tags = gibTagFilterOptionen($FilterSQL, $NaviFilter);
	    $oSuchergebnisse->TagsJSON = gibTagFilterJSONOptionen($FilterSQL, $NaviFilter);
	    $oSuchergebnisse->MerkmalFilter = gibMerkmalFilterOptionen($FilterSQL, $NaviFilter, $AktuelleKategorie, function_exists("starteAuswahlAssistent"));
	    $oSuchergebnisse->Preisspanne = gibPreisspannenFilterOptionen($FilterSQL, $NaviFilter, $oSuchergebnisse);
	    $oSuchergebnisse->Kategorieauswahl = gibKategorieFilterOptionen($FilterSQL, $NaviFilter);
	    $oSuchergebnisse->SuchFilter = gibSuchFilterOptionen($FilterSQL, $NaviFilter);
	    $oSuchergebnisse->SuchFilterJSON = gibSuchFilterJSONOptionen($FilterSQL, $NaviFilter);
    }
    
    if(!$kSuchspecial && !$kSuchspecialFilter)
        $oSuchergebnisse->Suchspecialauswahl = gibSuchspecialFilterOptionen($FilterSQL, $NaviFilter);

	//hole aktuelle Kategorie, falls eine gesetzt
	if($kKategorie > 0)
		$AktuelleKategorie = new Kategorie($kKategorie);
	elseif(verifyGPCDataInteger("kategorie") > 0)
		$AktuelleKategorie = new Kategorie(verifyGPCDataInteger("kategorie"));

    $AufgeklappteKategorien = new stdClass();
	if($AktuelleKategorie->kKategorie > 0)
	{
		$AufgeklappteKategorien = new KategorieListe();
		$AufgeklappteKategorien->getOpenCategories($AktuelleKategorie);
		$startKat = new Kategorie();
		$startKat->kKategorie=0;
		//$smarty->assign("oUnterkategorien_arr", $AufgeklappteKategorien->getUnterkategorien($AktuelleKategorie));
	}

	if (isset($LiveSuche->kSuchanfrage) && $LiveSuche->kSuchanfrage>0)
	{
		if (!$Suchinhalt->GesamtanzahlArtikel)
			$GLOBALS["DB"]->executeQuery("delete from tsuchanfrage where kSuchanfrage=".$LiveSuche->kSuchanfrage,4);
	}

	// Verfügbarkeitsbenachrichtigung allgemeiner CaptchaCode
	$smarty->assign(
		'code_benachrichtigung_verfuegbarkeit',
		(isset($Einstellungen['artikeldetails']['benachrichtigung_abfragen_captcha'])) ? generiereCaptchaCode($Einstellungen['artikeldetails']['benachrichtigung_abfragen_captcha']) : null
    );

	// Verfügbarkeitsbenachrichtigung pro Artikel
	if (is_array($oSuchergebnisse->Artikel->elemente))
	{
		// Work Around => hole Einstellung
		// $oEinstellungFix = $GLOBALS['DB']->executeQuery("SELECT cWert FROM teinstellungen WHERE cName = 'benachrichtigung_nutzen'", 1);
		// $Einstellungen['artikeldetails']['benachrichtigung_nutzen'] = $oEinstellungFix->cWert;

		foreach ($oSuchergebnisse->Artikel->elemente as $Artikel)
		{
            if (!isset($Einstellungen['artikeldetails']['benachrichtigung_nutzen']))
            {
                $Einstellungen['artikeldetails']['benachrichtigung_nutzen'] = null;
            }
			$n = gibVerfuegbarkeitsformularAnzeigen($Artikel, $Einstellungen['artikeldetails']['benachrichtigung_nutzen']);
			$Artikel->verfuegbarkeitsBenachrichtigung = $n;
		}
	}

	if(count($oSuchergebnisse->Artikel->elemente) == 0)
		if(!$NaviFilter->Kategorie->kKategorie)
            $oSuchergebnisse->SucheErfolglos = 1;

    if(count($oSuchergebnisse->Artikel->elemente) == 0)
    {
        if($NaviFilter->Kategorie->kKategorie > 0)
        {
            //hole alle enthaltenen Kategorien
            $KategorieInhalt->Unterkategorien = new KategorieListe();
            $KategorieInhalt->Unterkategorien->getAllCategoriesOnLevel($NaviFilter->Kategorie->kKategorie);

            //wenn keine eigenen Artikel in dieser Kat, Top Angebote / Bestseller aus unterkats + unterunterkats rausholen und anzeigen?
            if ($GLOBALS['Einstellungen']["artikeluebersicht"]["topbest_anzeigen"]=="Top" || $GLOBALS['Einstellungen']["artikeluebersicht"]["topbest_anzeigen"]=="TopBest")
            {
                $KategorieInhalt->TopArtikel = new ArtikelListe();
                $KategorieInhalt->TopArtikel->holeTopArtikel($KategorieInhalt->Unterkategorien);
            }
            if ($GLOBALS['Einstellungen']["artikeluebersicht"]["topbest_anzeigen"]=="Bestseller" || $GLOBALS['Einstellungen']["artikeluebersicht"]["topbest_anzeigen"]=="TopBest")
            {
                $KategorieInhalt->BestsellerArtikel = new ArtikelListe();
                $KategorieInhalt->BestsellerArtikel->holeBestsellerArtikel($KategorieInhalt->Unterkategorien, $KategorieInhalt->TopArtikel);
            }

            $smarty->assign('KategorieInhalt',$KategorieInhalt);
        }
        else
        {
            // Suchfeld anzeigen
            $oSuchergebnisse->SucheErfolglos = 1;
        }
    }

	//URLs bauen, die Filter lösen
	erstelleFilterLoesenURLs(!session_notwendig());

	// Header bauen
	$NaviFilter->cBrotNaviName = gibBrotNaviName($oSuchergebnisse);
	$oSuchergebnisse->SuchausdruckWrite = gibHeaderAnzeige($oSuchergebnisse);
	$oSuchergebnisse->cSuche = strip_tags(trim($cSuche));

	// Mainword NaviBilder
	unset($oNavigationsinfo);
    $oNavigationsinfo = new stdClass();
	$oNavigationsinfo->cName = "";
	$oNavigationsinfo->cBildURL = "";

    $AufgeklappteKategorien = new stdClass();
	if($kKategorie > 0)
	{
		$AktuelleKategorie = new Kategorie($kKategorie);
		$AufgeklappteKategorien = new KategorieListe();
		$AufgeklappteKategorien->getOpenCategories($AktuelleKategorie);
	}
	$startKat = new Kategorie();
	$startKat->kKategorie=0;

	// Navigation
	$cBrotNavi = "";
    if (!isset($oMeta))
    {
        $oMeta = new stdClass();
    }
    $oMeta->cMetaTitle = "";
    $oMeta->cMetaDescription = "";
    $oMeta->cMetaKeywords = "";

	if(isset($NaviFilter->Kategorie->kKategorie) && $NaviFilter->Kategorie->kKategorie > 0)
	{
		$oNavigationsinfo->oKategorie = $AktuelleKategorie;

		if($Einstellungen['navigationsfilter']['kategorie_bild_anzeigen'] == "Y")
			$oNavigationsinfo->cName = $AktuelleKategorie->cName;
		elseif($Einstellungen['navigationsfilter']['kategorie_bild_anzeigen'] == "BT")
		{
			$oNavigationsinfo->cName = $AktuelleKategorie->cName;
			$oNavigationsinfo->cBildURL = $AktuelleKategorie->getKategorieBild();
		}
		elseif($Einstellungen['navigationsfilter']['kategorie_bild_anzeigen'] == "B")
			$oNavigationsinfo->cBildURL = $AktuelleKategorie->getKategorieBild();

		$cBrotNavi = createNavigation("PRODUKTE", $AufgeklappteKategorien);
	}
	elseif(isset($NaviFilter->Hersteller->kHersteller ) && $NaviFilter->Hersteller->kHersteller > 0)
	{
		$oNavigationsinfo->oHersteller = new Hersteller($NaviFilter->Hersteller->kHersteller);

		if($Einstellungen['navigationsfilter']['hersteller_bild_anzeigen'] == "Y")
			$oNavigationsinfo->cName = $oNavigationsinfo->oHersteller->cName;
		elseif($Einstellungen['navigationsfilter']['hersteller_bild_anzeigen'] == "BT")
		{
			$oNavigationsinfo->cName = $oNavigationsinfo->oHersteller->cName;
			$oNavigationsinfo->cBildURL = $oNavigationsinfo->oHersteller->cBildpfadNormal;
		}
		elseif($Einstellungen['navigationsfilter']['hersteller_bild_anzeigen'] == "B")
			$oNavigationsinfo->cBildURL = $oNavigationsinfo->oHersteller->cBildpfadNormal;

        $oMeta->cMetaTitle = $oNavigationsinfo->oHersteller->cMetaTitle;
        $oMeta->cMetaDescription = $oNavigationsinfo->oHersteller->cMetaDescription;
        $oMeta->cMetaKeywords = $oNavigationsinfo->oHersteller->cMetaKeywords;

		$cBrotNavi = createNavigation("", "", 0, $NaviFilter->cBrotNaviName, gibNaviURL($NaviFilter, !session_notwendig(), null));
	}
	elseif(isset($NaviFilter->MerkmalWert->kMerkmalWert) && $NaviFilter->MerkmalWert->kMerkmalWert > 0)
	{
		$oNavigationsinfo->oMerkmalWert = new MerkmalWert($NaviFilter->MerkmalWert->kMerkmalWert);

		if($Einstellungen['navigationsfilter']['merkmalwert_bild_anzeigen'] == "Y")
			$oNavigationsinfo->cName = $oNavigationsinfo->oMerkmalWert->cName;
		elseif($Einstellungen['navigationsfilter']['merkmalwert_bild_anzeigen'] == "BT")
		{
			$oNavigationsinfo->cName = $oNavigationsinfo->oMerkmalWert->cName;
			$oNavigationsinfo->cBildURL = $oNavigationsinfo->oMerkmalWert->cBildpfadNormal;
		}
		elseif($Einstellungen['navigationsfilter']['merkmalwert_bild_anzeigen'] == "B")
			$oNavigationsinfo->cBildURL = $oNavigationsinfo->oMerkmalWert->cBildpfadNormal;

        $oMeta->cMetaTitle = $oNavigationsinfo->oMerkmalWert->cMetaTitle;
        $oMeta->cMetaDescription = $oNavigationsinfo->oMerkmalWert->cMetaDescription;
        $oMeta->cMetaKeywords = $oNavigationsinfo->oMerkmalWert->cMetaKeywords;

		$cBrotNavi = createNavigation("", "", 0, $NaviFilter->cBrotNaviName, gibNaviURL($NaviFilter, !session_notwendig(), null));
	}
	elseif(isset($NaviFilter->Tag->kTag) && $NaviFilter->Tag->kTag > 0)
	{
		$cBrotNavi = createNavigation("", "", 0, $NaviFilter->cBrotNaviName, gibNaviURL($NaviFilter, !session_notwendig(), null));
	}
	elseif(isset($NaviFilter->Suchspecial->kKey) && $NaviFilter->Suchspecial->kKey > 0)
	{
		$cBrotNavi = createNavigation("", "", 0, $NaviFilter->cBrotNaviName, gibNaviURL($NaviFilter, !session_notwendig(), null));
	}
	elseif(isset($NaviFilter->Suche->cSuche) && strlen($NaviFilter->Suche->cSuche) > 0)
	{
		$cBrotNavi = createNavigation("", "", 0, $GLOBALS['oSprache']->gibWert('search', 'breadcrumb'). ": " .$NaviFilter->cBrotNaviName, gibNaviURL($NaviFilter, !session_notwendig(), null));
	}

	// Canonical
	if(!strstr(basename(gibNaviURL($NaviFilter, !session_notwendig(), null)), ".php") || !SHOP_SEO)
	{
		$cSeite = "";
		if(isset($oSuchergebnisse->Seitenzahlen->AktuelleSeite) && $oSuchergebnisse->Seitenzahlen->AktuelleSeite > 1)
			$cSeite = SEP_SEITE . $oSuchergebnisse->Seitenzahlen->AktuelleSeite;

		$cCanonicalURL = gibNaviURL($NaviFilter, !session_notwendig(), null, 0, true) . $cSeite;
	}

    // Auswahlassistent
    if(function_exists("starteAuswahlAssistent"))
        starteAuswahlAssistent(AUSWAHLASSISTENT_ORT_KATEGORIE, $kKategorie, $_SESSION['kSprache'], $smarty, $Einstellungen['auswahlassistent']);
    
	// Work around fürs Template
	$smarty->assign("SEARCHSPECIALS_TOPREVIEWS", SEARCHSPECIALS_TOPREVIEWS);
    $smarty->assign('PFAD_ART_ABNAHMEINTERVALL', PFAD_ART_ABNAHMEINTERVALL);
    
	//spezifische assigns
	$smarty->assign('Navigation', $cBrotNavi);
	//$smarty->assign('Brotnavi', $cBrotNavi);
	$smarty->assign('Einstellungen',$Einstellungen);
	$smarty->assign('Sortierliste',gibSortierliste($Einstellungen, $bExtendedJTLSearch));
	$smarty->assign('Einstellungen',$Einstellungen);
	$smarty->assign('Suchergebnisse',$oSuchergebnisse);
	$smarty->assign('requestURL',(isset($requestURL)) ? $requestURL : null);
	$smarty->assign('sprachURL',(isset($sprachURL)) ? $sprachURL : null);
	$smarty->assign('oNavigationsinfo', $oNavigationsinfo);
	
	$smarty->assign("SEO", false);
	$smarty->assign("SESSION_NOTWENDIG", session_notwendig());

	require_once(PFAD_INCLUDES."letzterInclude.php");

	// Hook
	executeHook(HOOK_NAVI_PAGE);

    // Metas
    $oGlobaleMetaAngabenAssoc_arr = holeGlobaleMetaAngaben();   // Globale Metaangaben
    $oExcludedKeywordsAssoc_arr  = holeExcludedKeywords(); // Excluded Meta Keywords
    $smarty->assign('meta_title', gibNaviMetaTitle($oSuchergebnisse->Artikel->elemente, $NaviFilter, $oSuchergebnisse, $oGlobaleMetaAngabenAssoc_arr, explode(" ", $oExcludedKeywordsAssoc_arr[$_SESSION['cISOSprache']]->cKeywords)));
    $smarty->assign('meta_description', gibNaviMetaDescription($oSuchergebnisse->Artikel->elemente, $NaviFilter, $oSuchergebnisse, $oGlobaleMetaAngabenAssoc_arr, explode(" ", $oExcludedKeywordsAssoc_arr[$_SESSION['cISOSprache']]->cKeywords)));
    $smarty->assign('meta_keywords', gibNaviMetaKeywords($oSuchergebnisse->Artikel->elemente, $NaviFilter, $oSuchergebnisse, $oGlobaleMetaAngabenAssoc_arr, explode(" ", $oExcludedKeywordsAssoc_arr[$_SESSION['cISOSprache']]->cKeywords)));

    // Hook
    executeHook(HOOK_NAVI_ENDE);
    
	$smarty->display('suche.tpl');
}
else
{
	//Artikel
	if ($kArtikel > 0) require_once('artikel.php');
	elseif ($kWunschliste > 0) require_once('wunschliste.php');
	elseif ($vergleichsliste > 0) require_once('vergleichsliste.php');
	elseif ($kNews > 0 || $kNewsMonatsUebersicht > 0 || $kNewsKategorie > 0) require_once('news.php');
	elseif ($kUmfrage > 0) require_once('umfrage.php');
	else
	{
		if (!$kSeite)
		{
			$Link = $GLOBALS["DB"]->executeQuery("select kLink from tlink where nLinkart=".LINKTYP_STARTSEITE,1);
			$kSeite = $Link->kLink;
		}
        
		require_once('seite.php');
	}
}