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

//session starten
$session = new Session();
if (isset($_GET['logoff']) && intval($_GET['logoff'])==1)	
{
	session_destroy();
	$session = new Session();
}

if (verifyGPCDataInteger('x')==1)
{
	require_once('suche.php');
	exit;
}

loeseHttps();

// Interner Parameter Handler
include(PFAD_ROOT . PFAD_INCLUDES . "parameterintern_inc.php");

//misc
$show = verifyGPCDataInteger('show');
$vergleichsliste = verifyGPCDataInteger('vla');
$bFileNotFound = false;
$cCanonicalURL = "";

if (SHOP_SEO)
	require_once(PFAD_ROOT . PFAD_INCLUDES_EXT . 'seocheck.php');
	
// Hole alle aktiven Sprachen
if (!isset($NaviFilter))
{
    $NaviFilter = new stdClass();
}
$NaviFilter->oSprache_arr = $GLOBALS['DB']->executeQuery("SELECT kSprache FROM tsprache", 2);

// Old kLink
if(intval($kSeite) > 0)
    $kLink = $kSeite;

$MerkmalFilter = setzeMerkmalFilter();
//$SuchFilter = setzeSuchFilter();
//$TagFilter = setzeTagFilter();

$cParameter_arr = array("kKategorie" => $kKategorie,
                        "kKonfigPos" => $kKonfigPos,
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
                        "TagFilter_arr" => (isset($TagFilter)) ? $TagFilter : array(),
                        "SuchFilter_arr" => (isset($SuchFilter)) ? $SuchFilter : array(),                    
                        "nArtikelProSeite" => (isset($nArtikelProSeite)) ? $nArtikelProSeite : null,
                        "cSuche" => (isset($cSuche)) ? $cSuche : null,
                        "seite" => (isset($seite)) ? $seite : null);

$NaviFilter = baueNaviFilter($NaviFilter, $cParameter_arr);

//mobile template
checkeTemplate();

//erstelle $smarty
require_once(PFAD_ROOT . PFAD_INCLUDES . "smartyInlcude.php");

// Hook
executeHook(HOOK_INDEX_NAVI_HEAD_POSTGET);
    
//wurde was in den Warenkorb gelegt?
checkeWarenkorbEingang();

// ToDo: Neue Funktion, Öffentliche Wunschliste
$kWunschliste = checkeWunschlisteParameter();
if(!$kWunschliste && strlen(verifyGPDataString('wlid')) > 0)
{
	header("Location: wunschliste.php?wlid=" . verifyGPDataString('wlid') . "&error=1" . SID);
	exit();
}

$smarty->assign("NaviFilter",$NaviFilter);

if (($kArtikel > 0 || $kKategorie > 0) && !$_SESSION["Kundengruppe"]->darfArtikelKategorienSehen)
{
	//falls Artikel/Kategorien nicht gesehen werden dürfen -> login
	header('Location: '.URL_SHOP.'/jtl.php?li=1');
	exit;
}

setzeBesuchExt();

// Prüfe Variationskombi
if(pruefeIstVariKind($kArtikel))
{
    $kVariKindArtikel = $kArtikel;
    $kArtikel = gibkVaterArtikel($kArtikel);
}

if ((($kArtikel>0 && !$kKategorie) || ($kArtikel>0 && $kKategorie>0 && $show==1)) && !isset($suche) )
{	
	$kVaterArtikel = istVariationsKombiKind($kArtikel);	
	if($kVaterArtikel > 0)
    {
		$kArtikel = $kVaterArtikel;        
		
		// Falls ein POST vom Kindartikel abgeschickt wurde, diese Daten sichern und an den Redirect anhängen
		$cRP = "";
		if(is_array($_POST) && count($_POST) > 0)
		{
			$cMember_arr = array_keys($_POST);			
			foreach($cMember_arr as $cMember)
				$cRP .= "&" . $cMember . "=" . $_POST[$cMember];
			
			// Redirect POST
			$cRP = "&cRP=" . base64_encode($cRP);
		}
		
		header("HTTP/1.1 301 Moved Permanently");
        header("Location: " . URL_SHOP . "/navi.php?a=" . $kArtikel . $cRP);
        exit();
    }
	
	require_once(PFAD_ROOT . 'artikel.php');
}
elseif ($kHersteller>0 || $kSuchanfrage>0 || $kMerkmalWert>0 || $kTag>0 || $kKategorie>0 || (isset($cPreisspannenFilter) && $cPreisspannenFilter>0) || (isset($nBewertungSterneFilter) && $nBewertungSterneFilter>0) || $kHerstellerFilter>0 || $kKategorieFilter>0  || $kSuchspecial > 0 || $kSuchFilter > 0) require_once(PFAD_ROOT . 'filter.php');
elseif ($kWunschliste > 0) require_once(PFAD_ROOT . 'wunschliste.php');
elseif ($vergleichsliste > 0) require_once(PFAD_ROOT . 'vergleichsliste.php');
elseif ($kNews > 0 || $kNewsMonatsUebersicht > 0 || $kNewsKategorie > 0) require_once(PFAD_ROOT . 'news.php');
elseif ($kUmfrage > 0) require_once(PFAD_ROOT . 'umfrage.php');
else 
{
	if (!$kLink)
	{
        // Wurde ein SEO eingegeben aber nichts gefunden? => Redirect 301 Startseite
        if(strlen($seo) > 0)
            executeHook(HOOK_INDEX_SEO_404);

		// Pfad überprüfen
		$cPath_arr = parse_url($_SERVER['REQUEST_URI']);
		$cPath = $cPath_arr['path'];
		$cFile = basename($cPath);
		
		if ((in_array(strtolower($cFile), array('index.php', 'navi.php')) || strlen($cPath) == 0 || $cPath[strlen($cPath)-1] == '/') /*&& strlen($cPath_arr['query']) == 0*/)
		{
			$oLink = $GLOBALS["DB"]->executeQuery("select kLink from tlink where nLinkart=".LINKTYP_STARTSEITE,1);
			$kLink = $oLink->kLink;
		}
		
		if (!$kLink)
		{
			// Redirect
			$cURL = $_SERVER['REQUEST_URI'];
			
			$oRedirect = new Redirect();
            
			if(!isset($_GET['notrack'])) 
            {
                $cRedirect = $oRedirect->test($cURL);
            }
            
			if (!is_null($cRedirect))
			{
				header("HTTP/1.1 301 Moved Permanently");
				header("Location: {$cRedirect}");
				exit;
			}
			else
			{			    
				// Es wurde keine Seite gefunden
				header("HTTP/1.0 404 Not Found");
			
				if (!$oRedirect->isValid($cURL))
					exit;
				
				$bFileNotFound = true;
				executeHook(HOOK_PAGE_NOT_FOUND_PRE_INCLUDE, array("bFileNotFound" => &$bFileNotFound, "kLink" => &$kLink));
								
				if (!$kLink)
				{				    
					// Sitemap anzeigen
					//$oLink = $GLOBALS["DB"]->executeQuery("select kLink from tlink where nLinkart=".LINKTYP_SITEMAP,1);
				    $oLink = $GLOBALS["DB"]->executeQuery("SELECT kLink FROM tlink WHERE nLinkart = " . LINKTYP_404, 1);
					$kLink = $oLink->kLink;
				}
			}
		}
	}
	require_once('seite.php');
}
?>
