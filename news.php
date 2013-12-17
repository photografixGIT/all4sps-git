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
$AktuelleSeite = "NEWS";

//session starten
$session = new Session();

//erstelle $smarty
require_once(PFAD_ROOT . PFAD_INCLUDES . "smartyInlcude.php");
require_once(PFAD_ROOT . PFAD_ADMIN . PFAD_INCLUDES . "blaetternavi.php");
require_once(PFAD_ROOT . PFAD_INCLUDES . "news_inc.php");
require_once(PFAD_ROOT . PFAD_INCLUDES . "seite_inc.php");

$cHinweis = "";
$cFehler = "";
$step = "news_uebersicht";

$cMetaTitle = "";
$cMetaDescription = "";
$cMetaKeywords = "";

$Einstellungen = getEinstellungen(array(CONF_GLOBAL,CONF_RSS,CONF_NEWS));

//setze seitentyp
setzeSeitenTyp(PAGE_NEWS);

// SSL lösen
loeseHttps();

$kLink = gibLinkKeySpecialSeite(LINKTYP_NEWS);

//hole alle OberKategorien
$AlleOberkategorien = new KategorieListe();
$AlleOberkategorien->getAllCategoriesOnLevel(0);
$AktuelleKategorie = new Kategorie(verifyGPCDataInteger("kategorie"));
$AufgeklappteKategorien = new KategorieListe();
$AufgeklappteKategorien->getOpenCategories($AktuelleKategorie);
$startKat = new Kategorie();
$startKat->kKategorie=0;

$nAktuelleSeite = 1;
$nAnzahlProSeite = 2;
if(verifyGPCDataInteger('s') > 0)
	$nAktuelleSeite = verifyGPCDataInteger('s');

$oNewsArchiv;
$oNewsUebersicht_arr = array();

// News Übersicht Filter
if(verifyGPCDataInteger("nSort") > 0)
    $_SESSION['NewsNaviFilter']->nSort = verifyGPCDataInteger("nSort");
elseif(verifyGPCDataInteger("nSort") == -1)
    $_SESSION['NewsNaviFilter']->nSort = -1;

if(verifyGPCDataInteger("nAnzahl") > 0)
    $_SESSION['NewsNaviFilter']->nAnzahl = verifyGPCDataInteger("nAnzahl");
elseif(verifyGPCDataInteger("nAnzahl") == -1)
    $_SESSION['NewsNaviFilter']->nAnzahl = -1;

if(strlen(verifyGPDataString("cDatum")) > 0)
    $_SESSION['NewsNaviFilter']->cDatum = verifyGPDataString("cDatum");
elseif(intval(verifyGPDataString("cDatum")) == -1)
    $_SESSION['NewsNaviFilter']->cDatum = -1;

if(verifyGPCDataInteger("nNewsKat") > 0)
    $_SESSION['NewsNaviFilter']->nNewsKat = verifyGPCDataInteger("nNewsKat");
elseif(verifyGPCDataInteger("nNewsKat") == -1)
    $_SESSION['NewsNaviFilter']->nNewsKat = -1;

$nAnzahlProSeite = (isset($_SESSION['NewsNaviFilter']->nAnzahl)) ? $_SESSION['NewsNaviFilter']->nAnzahl : null;

// Detailansicht anzeigen
if(verifyGPCDataInteger('n') > 0 || isset($kNews) && $kNews > 0)
{
	$AktuelleSeite = "NEWSDETAIL";
	$step = "news_detailansicht";

	if($kNews == 0)
		$kNews = verifyGPCDataInteger('n');

	$oNewsArchiv = $GLOBALS['DB']->executeQuery("SELECT tnews.kNews, tnews.kSprache, tnews.cKundengruppe, tnews.cBetreff, tnews.cText, tnews.cVorschauText, tnews.cMetaTitle,
													tnews.cMetaDescription, tnews.cMetaKeywords, tnews.nAktiv, tnews.dErstellt, tseo.cSeo,
													DATE_FORMAT(tnews.dGueltigVon, '%d.%m.%Y %H:%i') as Datum, DATE_FORMAT(tnews.dGueltigVon, '%d.%m.%Y %H:%i') as dGueltigVon_de
													FROM tnews
													LEFT JOIN tseo ON tseo.cKey = 'kNews'
														AND tseo.kKey = tnews.kNews
                                                        AND tseo.kSprache = " . $_SESSION['kSprache'] . "
													WHERE tnews.kNews=" . $kNews . "
                                                        AND tnews.kSprache = " . $_SESSION['kSprache'], 1);

	if($oNewsArchiv->kNews > 0)
	{
		$oNewsArchiv->cText = parseNewsText($oNewsArchiv->cText);

		$smarty->assign("oNewsArchiv", $oNewsArchiv);
	}

    // Metas
    $cMetaTitle = $oNewsArchiv->cMetaTitle;
    $cMetaDescription = $oNewsArchiv->cMetaDescription;
    $cMetaKeywords = $oNewsArchiv->cMetaKeywords;

	$smarty->assign("R_LOGIN_NEWSCOMMENT", R_LOGIN_NEWSCOMMENT);

	$cSQL = "";
	$oNewsKategorieKey_arr = $GLOBALS['DB']->executeQuery("SELECT kNewsKategorie
															FROM tnewskategorienews
															WHERE kNews=" . intval($kNews), 2);

	if(is_array($oNewsKategorieKey_arr) && count($oNewsKategorieKey_arr) > 0)
	{
		$cSQL = "";
		foreach($oNewsKategorieKey_arr as $i => $oNewsKategorieKey)
		{
			if($oNewsKategorieKey->kNewsKategorie > 0)
			{
				if($i > 0)
					$cSQL .= ", " . $oNewsKategorieKey->kNewsKategorie;
				else
					$cSQL .= $oNewsKategorieKey->kNewsKategorie;
			}
		}
	}

	// Newskategorie
	$oNewsKategorie_arr = $GLOBALS['DB']->executeQuery("SELECT tnewskategorie.kNewsKategorie, tnewskategorie.kSprache, tnewskategorie.cName,
														tnewskategorie.cBeschreibung, tnewskategorie.cMetaTitle, tnewskategorie.cMetaDescription,
														tnewskategorie.nSort, tnewskategorie.nAktiv, tnewskategorie.dLetzteAktualisierung, tseo.cSeo,
														DATE_FORMAT(tnewskategorie.dLetzteAktualisierung, '%d.%m.%Y %H:%i') as dLetzteAktualisierung_de
														FROM tnewskategorie
														LEFT JOIN tnewskategorienews ON tnewskategorienews.kNewsKategorie = tnewskategorie.kNewsKategorie
														LEFT JOIN tseo ON tseo.cKey = 'kNewsKategorie'
															AND tseo.kKey = tnewskategorie.kNewsKategorie
                                                            AND tseo.kSprache = " . $_SESSION['kSprache'] . "
														WHERE tnewskategorie.kSprache=" . $_SESSION['kSprache'] . "
															AND tnewskategorienews.kNewsKategorie IN (" . $cSQL . ")
															AND tnewskategorie.nAktiv=1
														GROUP BY tnewskategorie.kNewsKategorie
														ORDER BY tnewskategorie.nSort DESC", 2);

	if(is_array($oNewsKategorie_arr) && count($oNewsKategorie_arr) > 0)
	{
		foreach($oNewsKategorie_arr as $j => $oNewsKategorie)
		{
			$oNewsKategorie_arr[$j]->cURL = baueURL($oNewsKategorie, URLART_NEWSKATEGORIE);
		}
	}

	$smarty->assign("oNewsKategorie_arr", $oNewsKategorie_arr);

	$oNewsKommentarAnzahl = $GLOBALS['DB']->executeQuery("SELECT count(*) as nAnzahl
															FROM tnewskommentar
															WHERE kNews=" . $kNews . "
																AND nAktiv=1", 1);

	if($oNewsKommentarAnzahl->nAnzahl > 0)
	{
		// Baue Blätter Navigation
		$nAnzahlProSeite = 10;
		$cSQL = " LIMIT " . $nAnzahlProSeite;
		if(intval($Einstellungen['news']['news_kommentare_anzahlproseite']) > 0)
		{
			$nAnzahlProSeite = intval($Einstellungen['news']['news_kommentare_anzahlproseite']);
			$cSQL = " LIMIT " . (($nAktuelleSeite - 1) * $nAnzahlProSeite) . ", " . $nAnzahlProSeite;
		}
		$oBlaetterNavi = baueBlaetterNavi($nAktuelleSeite, $oNewsKommentarAnzahl->nAnzahl, $nAnzahlProSeite);

		$smarty->assign("oBlaetterNavi", $oBlaetterNavi);

		$oNewsKommentar_arr = $GLOBALS['DB']->executeQuery("SELECT *, DATE_FORMAT(tnewskommentar.dErstellt, '%d.%m.%Y %H:%i') as dErstellt_de
															FROM tnewskommentar
															WHERE tnewskommentar.kNews=" . $kNews . "
																AND tnewskommentar.nAktiv=1
															ORDER BY tnewskommentar.dErstellt DESC" . $cSQL, 2);

		$smarty->assign("oNewsKommentar_arr", $oNewsKommentar_arr);
	}

	// Kommentar hinzufügen
	if(intval($_POST['kommentar_einfuegen']) > 0)
	{
		// Newskommentar nutzen JA?
		if(isset($Einstellungen['news']['news_kommentare_nutzen']) && $Einstellungen['news']['news_kommentare_nutzen'] == "Y")
		{		
			// Plausi
			$nPlausiValue_arr = pruefeKundenKommentar($_POST['cKommentar'], $_POST['cName'], $_POST['cEmail'], $kNews, $Einstellungen);
		
			// Hook
			executeHook(HOOK_NEWS_PAGE_NEWSKOMMENTAR_PLAUSI);
			
			if($Einstellungen['news']['news_kommentare_eingeloggt'] == "Y" && $_SESSION['Kunde']->kKunde > 0)
			{
				if(is_array($nPlausiValue_arr) && count($nPlausiValue_arr) == 0)
				{
					unset($oNewsKommentar);
					$oNewsKommentar->kNews = intval($_POST['kNews']);
					$oNewsKommentar->kKunde = $_SESSION['Kunde']->kKunde;

					if($Einstellungen['news']['news_kommentare_freischalten'] == "Y")
						$oNewsKommentar->nAktiv = 0;
					else
						$oNewsKommentar->nAktiv = 1;

					$oNewsKommentar->cName = $_SESSION['Kunde']->cVorname . " " . substr($_SESSION['Kunde']->cNachname, 0, 1) . ".";
					$oNewsKommentar->cEmail = $_SESSION['Kunde']->cEmail;
					$oNewsKommentar->cKommentar = StringHandler::htmlentities(filterXSS($_POST['cKommentar']));
					$oNewsKommentar->dErstellt = "now()";

					// Hook
					executeHook(HOOK_NEWS_PAGE_NEWSKOMMENTAR_EINTRAGEN);

					$GLOBALS['DB']->insertRow("tnewskommentar", $oNewsKommentar);

					if($Einstellungen['news']['news_kommentare_freischalten'] == "Y")
						$cHinweis .=  $GLOBALS['oSprache']->gibWert('newscommentAddactivate', 'messages') . "<br>";
					else
						$cHinweis .=  $GLOBALS['oSprache']->gibWert('newscommentAdd', 'messages') . "<br>";
				}
				else
				{
					$cFehler .= gibNewskommentarFehler($nPlausiValue_arr);
					$smarty->assign("nPlausiValue_arr", $nPlausiValue_arr);
					$smarty->assign("cPostVar_arr", $_POST);
				}
			}
			elseif($Einstellungen['news']['news_kommentare_eingeloggt'] == "N")
			{				
				if(is_array($nPlausiValue_arr) && count($nPlausiValue_arr) == 0)
				{
					$cEmail = $_POST['cEmail'];
					if($_SESSION['Kunde']->kKunde > 0)
						$cEmail = $_SESSION['Kunde']->cMail;
						
					unset($oNewsKommentar);
					$oNewsKommentar->kNews = intval($_POST['kNews']);
					$oNewsKommentar->kKunde = $_SESSION['Kunde']->kKunde;

					if($Einstellungen['news']['news_kommentare_freischalten'] == "Y")
						$oNewsKommentar->nAktiv = 0;
					else
						$oNewsKommentar->nAktiv = 1;

					if($_SESSION['Kunde']->kKunde > 0)
					{
						$cName = $_SESSION['Kunde']->cVorname . " " . substr($_SESSION['Kunde']->cNachname, 0, 1) . ".";
						$cEmail = $_SESSION['Kunde']->cMail;
					}
					else
					{
						$cName = filterXSS($_POST['cName']);
						$cEmail = filterXSS($_POST['cEmail']);
					}

					$oNewsKommentar->cName = $cName;
					$oNewsKommentar->cEmail = $cEmail;
					$oNewsKommentar->cKommentar = StringHandler::htmlentities(filterXSS($_POST['cKommentar']));
					$oNewsKommentar->dErstellt = "now()";

					// Hook
					executeHook(HOOK_NEWS_PAGE_NEWSKOMMENTAR_EINTRAGEN);

					$GLOBALS['DB']->insertRow("tnewskommentar", $oNewsKommentar);

					if($Einstellungen['news']['news_kommentare_freischalten'] == "Y")
						$cHinweis .=  $GLOBALS['oSprache']->gibWert('newscommentAddactivate', 'messages') . "<br />";
					else
						$cHinweis .=  $GLOBALS['oSprache']->gibWert('newscommentAdd', 'messages') . "<br />";
				}
				else
				{					
					$cFehler .= gibNewskommentarFehler($nPlausiValue_arr);
					$smarty->assign("nPlausiValue_arr", $nPlausiValue_arr);
					$smarty->assign("cPostVar_arr", $_POST);
				}
			}
		}
	}

	// Canonical
	if(!strstr(baueURL($oNewsArchiv, URLART_NEWS), ".php") || !SHOP_SEO)
		$cCanonicalURL = URL_SHOP . "/" . baueURL($oNewsArchiv, URLART_NEWS);

	$smarty->assign('Navigation',createNavigation($AktuelleSeite, 0, 0, "News - " . $oNewsArchiv->cBetreff, baueURL($oNewsArchiv, URLART_NEWS)));

    // Hook
    executeHook(HOOK_NEWS_PAGE_DETAILANSICHT);
}

// NewsKategorie übersicht
elseif(verifyGPCDataInteger('nk') || isset($kNewsKategorie) && $kNewsKategorie > 0)
{
    $kNewsKategorie = intval($kNewsKategorie);
    if($kNewsKategorie == 0)
        $kNewsKategorie = verifyGPCDataInteger('nk');

	$oNewsKategorie = $GLOBALS['DB']->executeQuery("SELECT tnewskategorie.cName, tseo.cSeo
													FROM tnewskategorie
													LEFT JOIN tseo ON tseo.cKey = 'kNewsKategorie'
														AND tseo.kKey = '" . $kNewsKategorie . "'
														AND tseo.kSprache = " . $_SESSION['kSprache'] . "
													WHERE tnewskategorie.kNewsKategorie = " . $kNewsKategorie, 1);

	// Canonical
	if(isset($oNewsKategorie->cSeo) && SHOP_SEO)
	{
		$cCanonicalURL = URL_SHOP . "/" . $oNewsKategorie->cSeo;
		$smarty->assign('Navigation', createNavigation($AktuelleSeite, 0, 0, $GLOBALS['oSprache']->gibWert('newskat', 'breadcrumb') . " - " . $oNewsKategorie->cName, $cCanonicalURL));
	}
	elseif(!SHOP_SEO)
	{
		$cCanonicalURL = URL_SHOP . "/news.php?nk=" . $kNewsKategorie;
		$smarty->assign('Navigation', createNavigation($AktuelleSeite, 0, 0, $GLOBALS['oSprache']->gibWert('newskat', 'breadcrumb') . " - " . $oNewsKategorie->cName, $cCanonicalURL));
	}

    $_SESSION['NewsNaviFilter']->nNewsKat = $kNewsKategorie;
    $_SESSION['NewsNaviFilter']->cDatum = -1;
}

// Monatsuebersicht
elseif(verifyGPCDataInteger('nm') || isset($kNewsMonatsUebersicht)&& $kNewsMonatsUebersicht > 0)
{
	$kNewsMonatsUebersicht = intval($kNewsMonatsUebersicht);
	if($kNewsMonatsUebersicht == 0)
		$kNewsMonatsUebersicht = verifyGPCDataInteger('nm');

	$oNewsMonatsUebersicht = $GLOBALS['DB']->executeQuery("SELECT tnewsmonatsuebersicht.*, tseo.cSeo
															FROM tnewsmonatsuebersicht
															LEFT JOIN tseo ON tseo.cKey = 'kNewsMonatsUebersicht'
																AND tseo.kKey = '" . $kNewsMonatsUebersicht . "'
																AND tseo.kSprache = " . $_SESSION['kSprache'] . "
															WHERE tnewsmonatsuebersicht.kNewsMonatsUebersicht=" . $kNewsMonatsUebersicht, 1);

	// Canonical
	if(isset($oNewsMonatsUebersicht->cSeo) && SHOP_SEO)
	{
		$cCanonicalURL = URL_SHOP . "/" . $oNewsMonatsUebersicht->cSeo;
		$smarty->assign('Navigation', createNavigation($AktuelleSeite, 0, 0, $GLOBALS['oSprache']->gibWert('newsmonat', 'breadcrumb') . ": " . $oNewsMonatsUebersicht->cName, $cCanonicalURL));
	}
	elseif(!SHOP_SEO)
	{
		$cCanonicalURL = URL_SHOP . "/news.php?nm=" . $oNewsMonatsUebersicht->kNewsMonatsUebersicht;
		$smarty->assign('Navigation', createNavigation($AktuelleSeite, 0, 0, $GLOBALS['oSprache']->gibWert('newsmonat', 'breadcrumb') . ": " . $oNewsMonatsUebersicht->cName, $cCanonicalURL));
	}

    $_SESSION['NewsNaviFilter']->cDatum = $oNewsMonatsUebersicht->nMonat . "-" . $oNewsMonatsUebersicht->nJahr;
    $_SESSION['NewsNaviFilter']->nNewsKat = -1;
}

// Kein Newsarchiv vorhanden
elseif(verifyGPCDataInteger('noarchiv') == 1)
{
	// Breadcrump
	baueNewsKruemel();

    $step = "news_monatsuebersicht";
    $smarty->assign("noarchiv", 1);
}

// News Übersicht
if($step == "news_uebersicht")
{
	// Breadcrump
	baueNewsKruemel();

    if(!$_SESSION['NewsNaviFilter']->nSort)
        $_SESSION['NewsNaviFilter']->nSort = -1;

    if(!$_SESSION['NewsNaviFilter']->nAnzahl)
        $_SESSION['NewsNaviFilter']->nAnzahl = -1;

    if(!$_SESSION['NewsNaviFilter']->cDatum)
        $_SESSION['NewsNaviFilter']->cDatum = -1;

    if(!$_SESSION['NewsNaviFilter']->nNewsKat)
        $_SESSION['NewsNaviFilter']->nNewsKat = -1;

    // Baut den NewsNaviFilter SQL
    $oSQL = baueFilterSQL($nAktuelleSeite);

    $oNewsUebersicht_arr = $GLOBALS['DB']->executeQuery("SELECT tseo.cSeo, tnews.*, DATE_FORMAT(tnews.dGueltigVon, '%d.%m.%Y %H:%i') as dErstellt_de, count(*) AS nAnzahl, count(distinct(tnewskommentar.kNewsKommentar)) as nNewsKommentarAnzahl
                                                            FROM tnews
                                                            LEFT JOIN tseo ON tseo.cKey = 'kNews'
                                                                AND tseo.kKey = tnews.kNews
                                                                AND tseo.kSprache = " . $_SESSION['kSprache'] . "
                                                            LEFT JOIN tnewskommentar ON tnewskommentar.kNews = tnews.kNews AND tnewskommentar.nAktiv=1
                                                            " . $oSQL->cNewsKatSQL . "
                                                            WHERE tnews.nAktiv=1
                                                                AND tnews.dGueltigVon <= now()
                                                                AND (tnews.cKundengruppe LIKE '%;-1;%' OR tnews.cKundengruppe LIKE '%;" . $_SESSION['Kundengruppe']->kKundengruppe . ";%')
                                                                AND tnews.kSprache = " . $_SESSION['kSprache'] . "
                                                                " . $oSQL->cDatumSQL . "
                                                            GROUP BY tnews.kNews
                                                            " . $oSQL->cSortSQL . $oSQL->cAnzahlSQL, 2);

    $oNewsUebersichtAll = $GLOBALS['DB']->executeQuery("SELECT count(distinct(tnews.kNews)) AS nAnzahl
                                                        FROM tnews
                                                        " . $oSQL->cNewsKatSQL . "
                                                        WHERE tnews.nAktiv=1
                                                            AND tnews.dGueltigVon <= now()
                                                            AND (tnews.cKundengruppe LIKE '%;-1;%' OR tnews.cKundengruppe LIKE '%;" . $_SESSION['Kundengruppe']->kKundengruppe . ";%')
                                                            " . $oSQL->cDatumSQL . "
                                                            AND tnews.kSprache = " . $_SESSION['kSprache'], 1);

    $oDatum_arr = $GLOBALS['DB']->executeQuery("SELECT month(tnews.dGueltigVon) AS nMonat, year( tnews.dGueltigVon ) AS nJahr
                                                FROM tnews
                                                " . $oSQL->cNewsKatSQL . "
                                                WHERE tnews.nAktiv=1
                                                    AND tnews.dGueltigVon <= now()
                                                    AND (tnews.cKundengruppe LIKE '%;-1;%' OR tnews.cKundengruppe LIKE '%;" . $_SESSION['Kundengruppe']->kKundengruppe . ";%')
                                                    AND tnews.kSprache = " . $_SESSION['kSprache'] . "
                                                GROUP BY nJahr, nMonat
                                                ORDER BY dGueltigVon DESC", 2);

    $cKeywords = "";
    if(is_array($oNewsUebersicht_arr) && count($oNewsUebersicht_arr) > 0)
    {
        foreach($oNewsUebersicht_arr as $i => $oNewsUebersicht)
        {
            if($i > 0)
                $cKeywords .= ", " . $oNewsUebersicht->cBetreff;
            else
                $cKeywords .= $oNewsUebersicht->cBetreff;

            $oNewsUebersicht_arr[$i]->cText = parseNewsText($oNewsUebersicht_arr[$i]->cText);
            $oNewsUebersicht_arr[$i]->cURL = baueURL($oNewsUebersicht, URLART_NEWS);
            $oNewsUebersicht_arr[$i]->cMehrURL = "<a href='" . $oNewsUebersicht_arr[$i]->cURL . "'>" . $GLOBALS['oSprache']->gibWert('moreLink', 'news') . "</a>";
        }
    }

    $cMetaTitle = baueNewsMetaTitle($_SESSION['NewsNaviFilter'], $oNewsUebersicht_arr);
    $cMetaDescription = baueNewsMetaDescription($_SESSION['NewsNaviFilter'], $oNewsUebersicht_arr);
    $cMetaKeywords = baueNewsMetaKeywords($_SESSION['NewsNaviFilter'], $oNewsUebersicht_arr);

    // Baue Blätternavigation
    if($nAnzahlProSeite > 0)
    {
        $oBlaetterNavi = baueBlaetterNavi($nAktuelleSeite, $oNewsUebersichtAll->nAnzahl, $nAnzahlProSeite);
        $smarty->assign("oBlaetterNavi", $oBlaetterNavi);
    }

    $smarty->assign("oNewsUebersicht_arr", $oNewsUebersicht_arr);
    $smarty->assign("oNewsKategorie_arr", holeNewsKategorien($oSQL->cDatumSQL));
    $smarty->assign("oDatum_arr", baueDatum($oDatum_arr));
    $smarty->assign("nAnzahl", $_SESSION['NewsNaviFilter']->nAnzahl);
    $smarty->assign("nSort", $_SESSION['NewsNaviFilter']->nSort);
    $smarty->assign("cDatum", $_SESSION['NewsNaviFilter']->cDatum);
    $smarty->assign("nNewsKat", $_SESSION['NewsNaviFilter']->nNewsKat);

    // Hook
    executeHook(HOOK_NEWS_PAGE_NEWSUEBERSICHT);
}

//$smarty->assign('Navigation',createNavigation($AktuelleSeite, 0, 0));
$smarty->assign("Einstellungen", $Einstellungen);
$smarty->assign("hinweis", $cHinweis);
$smarty->assign("fehler", $cFehler);
$smarty->assign("step", $step);
$smarty->assign("SID", (isset($sid)) ? $sid : null);

require_once(PFAD_ROOT . PFAD_INCLUDES . "letzterInclude.php");

$smarty->assign("meta_title", $cMetaTitle);
$smarty->assign("meta_description", $cMetaDescription);
$smarty->assign("meta_keywords", $cMetaKeywords);

$smarty->display('news.tpl');

function baueNewsMetaTitle($oNewsNaviFilter, $oNewsUebersicht_arr)
{
    $cMetaTitle = baueNewsMetaStart($oNewsNaviFilter);

    if(is_array($oNewsUebersicht_arr) && count($oNewsUebersicht_arr) > 0)
    {
        $nCount = 3;
        if(count($oNewsUebersicht_arr) < $nCount)
            $nCount = count($oNewsUebersicht_arr);
        for($i = 0; $i < $nCount; $i++)
        {
            if($i > 0)
                $cMetaTitle .= " - " . $oNewsUebersicht_arr[$i]->cBetreff;
            else
                $cMetaTitle .= $oNewsUebersicht_arr[$i]->cBetreff;
        }
    }

    return $cMetaTitle;
}

function baueNewsMetaDescription($oNewsNaviFilter, $oNewsUebersicht_arr)
{
    $cMetaDescription = baueNewsMetaStart($oNewsNaviFilter);

    if(is_array($oNewsUebersicht_arr) && count($oNewsUebersicht_arr) > 0)
    {
        shuffle($oNewsUebersicht_arr);
        $nCount = 12;
        if(count($oNewsUebersicht_arr) < $nCount)
            $nCount = count($oNewsUebersicht_arr);
        for($i = 0; $i < $nCount; $i++)
        {
            if($i > 0)
                $cMetaDescription .= " - " . $oNewsUebersicht_arr[$i]->cBetreff;
            else
                $cMetaDescription .= $oNewsUebersicht_arr[$i]->cBetreff;
        }
    }

    return $cMetaDescription;
}

function baueNewsMetaKeywords($oNewsNaviFilter, $oNewsUebersicht_arr)
{
    $cMetaKeywords = baueNewsMetaStart($oNewsNaviFilter);

    if(is_array($oNewsUebersicht_arr) && count($oNewsUebersicht_arr) > 0)
    {
        $nCount = 6;
        if(count($oNewsUebersicht_arr) < $nCount)
            $nCount = count($oNewsUebersicht_arr);
        for($i = 0; $i < $nCount; $i++)
        {
            if($i > 0)
                $cMetaKeywords .= " - " . $oNewsUebersicht_arr[$i]->cBetreff;
            else
                $cMetaKeywords .= $oNewsUebersicht_arr[$i]->cBetreff;
        }
    }

    return $cMetaKeywords;
}

function baueNewsMetaStart($oNewsNaviFilter)
{
    $cMetaStart = $GLOBALS['oSprache']->gibWert('overview', 'news');

    // Datumfilter gesetzt
    if($oNewsNaviFilter->cDatum != -1)
        $cMetaStart .= " " . $oNewsNaviFilter->cDatum;

    // Kategoriefilter gesetzt
    if($oNewsNaviFilter->nNewsKat != -1)
    {
        $oNewsKat = $GLOBALS['DB']->executeQuery("SELECT cName, kNewsKategorie
                                                    FROM tnewskategorie
                                                    WHERE kNewsKategorie = " . $oNewsNaviFilter->nNewsKat . "
                                                        AND kSprache = " . $_SESSION['kSprache'], 1);

        if($oNewsKat->kNewsKategorie > 0)
            $cMetaStart .= " " . $oNewsKat->cName;
    }

    return $cMetaStart . ": ";
}

function baueNewsKruemel()
{
	global $smarty, $cCanonicalURL, $kNewsKategorie, $kNewsMonatsUebersicht;

	if(!$kNewsKategorie && !$kNewsMonatsUebersicht)
	{
		$oLink = $GLOBALS['DB']->executeQuery("SELECT kLink FROM tlink WHERE nLinkart = " . LINKTYP_NEWS, 1);

		if(isset($oLink->kLink) && $oLink->kLink > 0)
		{
			//hole Link
			$Link = holeSeitenLink($oLink->kLink);

			setzeBesuch("kLink", $Link->kLink);

			$Link->Sprache = holeSeitenLinkSprache($oLink->kLink);

			//url
			$requestURL = baueURL($Link, URLART_SEITE);
			$sprachURL = baueSprachURLS($Link, URLART_SEITE);

			// Canonical
			if(!strstr($requestURL, ".php") || !SHOP_SEO)
				$cCanonicalURL = URL_SHOP . "/" . $requestURL;
            if (!isset($AktuelleSeite))
            {
                $AktuelleSeite = null;
            }
			$smarty->assign('Navigation', createNavigation($AktuelleSeite, 0, 0, $Link->Sprache->cName, $requestURL));
		}
		else
		{
			// Canonical
			$cCanonicalURL = URL_SHOP . "/news.php";

			$smarty->assign('Navigation', createNavigation($AktuelleSeite, 0, 0, $GLOBALS['oSprache']->gibWert('news', 'breadcrumb'), "news.php"));
		}
	}
}
?>