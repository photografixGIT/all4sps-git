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
require_once(PFAD_INCLUDES."vergleichsliste_inc.php");
$AktuelleSeite = "VERGLEICHSLISTE";

//session starten
$session = new Session();

//erstelle $smarty
require_once(PFAD_INCLUDES."smartyInlcude.php");

//setze seitentyp
setzeSeitenTyp(PAGE_VERGLEICHSLISTE);

loeseHttps();

$Einstellungen_Vergleichsliste = getEinstellungen(array(CONF_VERGLEICHSLISTE,CONF_ARTIKELDETAILS));

//url
$requestURL = baueURL($Link,URLART_SEITE);
$sprachURL = baueSprachURLS($Link,URLART_SEITE);

//hole aktuelle Kategorie, falls eine gesetzt
$AktuelleKategorie = new Kategorie(verifyGPCDataInteger("kategorie"));
$AufgeklappteKategorien = new KategorieListe();
$AufgeklappteKategorien->getOpenCategories($AktuelleKategorie);
$startKat = new Kategorie();
$startKat->kKategorie=-1;

// VergleichslistePos in den Warenkorb adden 
if (intval($_GET['vlph']) == 1)
{
	$kArtikel = verifyGPCDataInteger('a');
	
	if($kArtikel > 0)
	{
		//redirekt zum artikel, um variation/en zu wählen / MBM beachten
		header ("Location: index.php?a=" . $kArtikel);
		exit();
	}
}
else 
{
	$oVergleichsliste = new Vergleichsliste();
	$oMerkVaria_arr = baueMerkmalundVariation($oVergleichsliste);
	
	if(intval($_GET['print']) == 1)
		$smarty->assign("print", 1);
	
	// Füge den Vergleich für Statistikzwecke in die DB ein
	setzeVergleich($oVergleichsliste);
	
	$cExclude = array();
	for($i=0; $i<8; $i++)
	{
		$cElement = gibMaxPrioSpalteV($cExclude, $Einstellungen_Vergleichsliste);
		if(strlen($cElement) > 1)
		{
			array_push($cExclude, $cElement);
		}
	}
}

// Spaltenbreite
$nBreiteAttribut = 100;
if(intval($Einstellungen_Vergleichsliste['vergleichsliste']['vergleichsliste_spaltengroesseattribut']) > 0)
	$nBreiteAttribut = intval($Einstellungen_Vergleichsliste['vergleichsliste']['vergleichsliste_spaltengroesseattribut']);
	
$nBreiteArtikel = 200;
if(intval($Einstellungen_Vergleichsliste['vergleichsliste']['vergleichsliste_spaltengroesse']) > 0)
	$nBreiteArtikel = intval($Einstellungen_Vergleichsliste['vergleichsliste']['vergleichsliste_spaltengroesse']);	

$nBreiteTabelle = $nBreiteArtikel * count($oVergleichsliste->oArtikel_arr) + $nBreiteAttribut;

//spezifische assigns
$smarty->assign('nBreiteTabelle', $nBreiteTabelle);
$smarty->assign('cPrioSpalten_arr', $cExclude);
$smarty->assign('oMerkmale_arr', $oMerkVaria_arr[0]);
$smarty->assign('oVariationen_arr', $oMerkVaria_arr[1]);
$smarty->assign('oVergleichsliste', $oVergleichsliste);
$smarty->assign('Navigation',createNavigation($AktuelleSeite, 0, 0));
$smarty->assign('Einstellungen',$GLOBALS['GlobaleEinstellungen']);
$smarty->assign('Einstellungen_Vergleichsliste', $Einstellungen_Vergleichsliste);

require_once(PFAD_INCLUDES."letzterInclude.php");

// Hook
executeHook(HOOK_VERGLEICHSLISTE_PAGE);

$smarty->display('vergleichsliste.tpl');
?>
