<?php
/**
 * copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 *
 * this file may not be redistributed in whole or significant part
 * and is subject to the JTL-Software-GmbH license.
 *
 * license: http://jtl-software.de/jtlshop3license.html
 */

require_once(PFAD_ROOT . PFAD_INCLUDES . "seite_inc.php");

$AktuelleSeite = "SEITE";

//setze seitentyp
setzeSeitenTyp(PAGE_EIGENE);

loeseHttps();

//einstellungen holen
$Einstellungen = getEinstellungen(array(CONF_GLOBAL,CONF_RSS,CONF_KUNDEN,CONF_SONSTIGES,CONF_NEWS,CONF_SITEMAP,CONF_ARTIKELUEBERSICHT,CONF_AUSWAHLASSISTENT));

//hole alle OberKategorien
$AlleOberkategorien = new KategorieListe();
$AlleOberkategorien->getAllCategoriesOnLevel(0);
$AktuelleKategorie = new Kategorie(verifyGPCDataInteger("kategorie"));
$AufgeklappteKategorien = new KategorieListe();
$AufgeklappteKategorien->getOpenCategories($AktuelleKategorie);
$startKat = new Kategorie();
$startKat->kKategorie=0;

//hole Link
$Link = holeSeitenLink($kLink);

//Besuch setzen
setzeBesuch("kLink",$Link->kLink);

if (isset($Link->nLinkart) && $Link->nLinkart==LINKTYP_EXTERNE_URL)
{
	if (session_notwendig())
		$sid="&".SID;
	if (!standardspracheAktiv(true))
	{
		$lang = "&lang=".$_SESSION["cISOSprache"];
	}
	header('Location: '.$Link->cURL.'?'.$lang.$sid);
	exit;
}

$Link->Sprache = holeSeitenLinkSprache($Link->kLink);

//url
$requestURL = baueURL($Link, URLART_SEITE);

// Canonical
if(!strstr($requestURL, ".php") || !SHOP_SEO)
	$cCanonicalURL = URL_SHOP . "/" . $requestURL;
if($Link->nLinkart == LINKTYP_STARTSEITE)	// Work Around für die Startseite
	$cCanonicalURL = URL_SHOP . "/";

$sprachURL = baueSprachURLS($Link,URLART_SEITE);

//hole aktuelle Kategorie, falls eine gesetzt

$AufgeklappteKategorien = new KategorieListe();
$startKat = new Kategorie();
$startKat->kKategorie=0;

//$GLOBALS['Link'] = $Link;

// Gehört der kLink zu einer Spezialseite?
// wenn ja, leite um
pruefeSpezialseite($Link->nLinkart);

if ($Link->nLinkart==LINKTYP_STARTSEITE)
{
	//setze seitentyp
	setzeSeitenTyp(PAGE_STARTSEITE);

	$AktuelleSeite = "STARTSEITE";
	$smarty->assign('StartseiteBoxen',gibStartBoxen());
	$smarty->assign('Navigation',createNavigation($AktuelleSeite));
    
    // Auswahlassistent
    if(function_exists("starteAuswahlAssistent"))
        starteAuswahlAssistent(AUSWAHLASSISTENT_ORT_STARTSEITE, 1, $_SESSION['kSprache'], $smarty, $Einstellungen['auswahlassistent']);
    
    if($Einstellungen['news']['news_benutzen'] == "Y")
		$smarty->assign('oNews_arr', gibNews($Einstellungen));
}
elseif ($Link->nLinkart==LINKTYP_AGB)
{
	//setze seitentyp
	setzeSeitenTyp(PAGE_AGB);

	$smarty->assign('AGB', gibAGBWRB($_SESSION['kSprache'], $_SESSION['Kundengruppe']->kKundengruppe));
}
elseif ($Link->nLinkart==LINKTYP_WRB)
{
	//setze seitentyp
	setzeSeitenTyp(PAGE_WRB);

    $smarty->assign('WRB', gibAGBWRB($_SESSION['kSprache'], $_SESSION['Kundengruppe']->kKundengruppe));
}
elseif ($Link->nLinkart == LINKTYP_VERSAND)
{
	//setze seitentyp
	setzeSeitenTyp(PAGE_VERSAND);

    if(!ermittleVersandkosten($_POST['land'], $_POST['plz']))
		$smarty->assign("fehler", $GLOBALS['oSprache']->gibWert('missingParamShippingDetermination', 'errorMessages'));
    $smarty->assign('laender', gibBelieferbareLaender($kKundengruppe));
}
elseif ($Link->nLinkart==LINKTYP_LIVESUCHE)
{
	//setze seitentyp
	setzeSeitenTyp(PAGE_LIVESUCHE);

	$smarty->assign('LivesucheTop',gibLivesucheTop($Einstellungen));
	$smarty->assign('LivesucheLast',gibLivesucheLast($Einstellungen));
}
elseif ($Link->nLinkart==LINKTYP_TAGGING)
{
	//setze seitentyp
	setzeSeitenTyp(PAGE_TAGGING);

	$smarty->assign('Tagging',gibTagging($Einstellungen));
}
elseif ($Link->nLinkart==LINKTYP_HERSTELLER)
{
	//setze seitentyp
	setzeSeitenTyp(PAGE_HERSTELLER);

	$smarty->assign('oHersteller_arr',gibHersteller($Einstellungen));
}
elseif ($Link->nLinkart==LINKTYP_NEWSLETTERARCHIV)
{
	//setze seitentyp
	setzeSeitenTyp(PAGE_NEWSLETTERARCHIV);

	$smarty->assign('oNewsletterHistory_arr',gibNewsletterHistory());
}
elseif ($Link->nLinkart==LINKTYP_NEWSARCHIV)
{
	//setze seitentyp
	setzeSeitenTyp(PAGE_NEWSARCHIV);

	if($Einstellungen['news']['news_benutzen'] == "Y")
	{
		$oNewsMonatsUebersicht = $GLOBALS['DB']->executeQuery("SELECT *
																FROM tnewsmonatsuebersicht
																WHERE kSprache=" . $_SESSION['kSprache'] . "
																	AND nMonat=" . intval(date('m')) . "
																	AND nJahr=" . intval(date('Y')). "
                                                                LIMIT 1", 1);

		header("Location: " . baueURL($oNewsMonatsUebersicht, URLART_NEWSMONAT) . "");
		exit();
	}
}
elseif ($Link->nLinkart==LINKTYP_SITEMAP)
{
    gibSeiteSitemap($Einstellungen, $smarty);
}
elseif ($Link->nLinkart==LINKTYP_GRATISGESCHENK)
{
	//setze seitentyp
	setzeSeitenTyp(PAGE_GRATISGESCHENK);

	if($Einstellungen["sonstiges"]["sonstiges_gratisgeschenk_nutzen"] == "Y")
    {
        $oArtikelGeschenk_arr = gibGratisGeschenkArtikel($Einstellungen);

        if(is_array($oArtikelGeschenk_arr) && count($oArtikelGeschenk_arr) > 0)
		    $smarty->assign("oArtikelGeschenk_arr", $oArtikelGeschenk_arr);
        else
            $cFehler .= $GLOBALS['oSprache']->gibWert('freegiftsNogifts', 'errorMessages');
    }
}
elseif($Link->nLinkart == LINKTYP_AUSWAHLASSISTENT)
{
    //setze seitentyp
	setzeSeitenTyp(PAGE_AUSWAHLASSISTENT);
    
    // Auswahlassistent
    if(function_exists("starteAuswahlAssistent"))
        starteAuswahlAssistent(AUSWAHLASSISTENT_ORT_LINK, $Link->kLink, $_SESSION['kSprache'], $smarty, $Einstellungen['auswahlassistent']);
}
else if ($Link->nLinkart == LINKTYP_404)
{
    gibSeiteSitemap($Einstellungen, $smarty);
}

// Hook
executeHook(HOOK_SEITE_PAGE_IF_LINKART);

require_once(PFAD_INCLUDES."letzterInclude.php");

if(isset($cFehler) && strlen($cFehler) > 0)
	$smarty->assign("cFehler", $cFehler);

// MetaTitle bei bFileNotFound redirect
$Navigation = "";
if (!isset($bFileNotFound))
{
    $bFileNotFound = false;
}
if($bFileNotFound)
	$Navigation = createNavigation($AktuelleSeite, 0, 0, $GLOBALS['oSprache']->gibWert('pagenotfound', 'breadcrumb'), $requestURL);
else
	$Navigation = createNavigation($AktuelleSeite, 0, 0, $Link->Sprache->cName, $requestURL, $kLink);

//spezifische assigns
$smarty->assign('Navigation', $Navigation);
$smarty->assign('Einstellungen',$Einstellungen);
$smarty->assign('Link',$Link);
$smarty->assign('requestURL',$requestURL);
$smarty->assign('sprachURL',$sprachURL);
$smarty->assign('bSeiteNichtGefunden', $bFileNotFound);

//Meta
$smarty->assign('strPrint',$GLOBALS['oSprache']->gibWert('print', 'global'));
$smarty->assign('meta_language', convertISO2ISO639($_SESSION['cISOSprache']));

$cMetaTitle = $Link->Sprache->cMetaTitle;
$cMetaDescription = $Link->Sprache->cMetaDescription;
$cMetaKeywords = $Link->Sprache->cMetaKeywords;

if (strlen($cMetaTitle) == 0 || strlen($cMetaDescription) == 0 || strlen($cMetaKeywords) == 0)
{
	$kSprache = $_SESSION['kSprache'];
	//$oGlobaleMetaAngabenAssoc_arr = holeGlobaleMetaAngaben();
	$oGlobaleMetaAngaben = (isset($oGlobaleMetaAngabenAssoc_arr[$kSprache])) ? $oGlobaleMetaAngabenAssoc_arr[$kSprache] : null;

	if (is_object($oGlobaleMetaAngaben))
	{
		if (strlen($cMetaTitle) == 0)
			$cMetaTitle = $oGlobaleMetaAngaben->Title;
		if (strlen($cMetaDescription) == 0)
			$cMetaDescription = $oGlobaleMetaAngaben->Meta_Description;
		if (strlen($cMetaKeywords) == 0)
			$cMetaKeywords = $oGlobaleMetaAngaben->Meta_Keywords;
	}
}

$smarty->assign('meta_title', $cMetaTitle);
$smarty->assign('meta_description', $cMetaDescription);
$smarty->assign('meta_keywords', $cMetaKeywords);

// Hook
executeHook(HOOK_SEITE_PAGE);

$smarty->display('seite.tpl');
?>