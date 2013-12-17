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
require_once(PFAD_INCLUDES."bewertung_inc.php");
$AktuelleSeite = "BEWERTUNG";

//session starten
$session = new Session();

//erstelle $smarty
require_once(PFAD_INCLUDES."smartyInlcude.php");

$kArtikel = verifyGPCDataInteger('a');

$Einstellungen = getEinstellungen(array(CONF_GLOBAL, CONF_RSS,CONF_BEWERTUNG));

// Bewertung in die Datenbank speichern
if(intval($_POST['bfh']) == 1)
{
	$kArtikel = verifyGPCDataInteger('a');
	$nSterne = verifyGPCDataInteger('nSterne');
	
	if(pruefeKundeArtikelBewertet($kArtikel, $_SESSION['Kunde']->kKunde))
	{
		header('Location: index.php?a=' . $kArtikel . '&bewertung_anzeigen=1&cFehler=f02' . SID);
		exit();
	}
	else
	{
		// Versuche die Bewertung zu speichern
		speicherBewertung($kArtikel, $_SESSION['Kunde']->kKunde, $_SESSION['kSprache'], verifyGPDataString('cTitel'), verifyGPDataString('cText'), $nSterne);
	}
}
// Hilfreich abspeichern
else if(intval($_POST['bhjn']) == 1)
{
	// Bewertungen holen
	$bewertung_seite = intval(verifyGPCDataInteger('btgseite'));
	$bewertung_sterne = intval(verifyGPCDataInteger('btgsterne'));

	speicherHilfreich($kArtikel, $_SESSION['Kunde']->kKunde, $_SESSION['kSprache'], $bewertung_seite, $bewertung_sterne);
}
else if(intval(verifyGPCDataInteger('bfa')) == 1)
{	
	// Prüfe ob Kunde eingeloggt
	if(!$_SESSION['Kunde']->kKunde)
	{
		header ('Location: jtl.php?a=' . intval($_POST['a']) . "&bfa=1&r=" . R_LOGIN_BEWERTUNG . "&" . SID);
		exit();
	}
	
	$nSortierung = verifyGPCDataInteger('sortierreihenfolge');
	
	//hole aktuellen Artikel
	$AktuellerArtikel = new Artikel();
	unset($oArtikelOptionen);
	$oArtikelOptionen->nMerkmale = 1;
	$oArtikelOptionen->nAttribute = 1;
	$oArtikelOptionen->nArtikelAttribute = 1;
	$AktuellerArtikel->fuelleArtikel($kArtikel, $oArtikelOptionen);
	//falls kein Artikel vorhanden, zurück zum Shop
	if (!$AktuellerArtikel->kArtikel)
	{
		header('Location: index.php?'.SID);
		exit;
	}
	
	//hole aktuelle Kategorie, falls eine gesetzt
	$AufgeklappteKategorien = new KategorieListe();
	$startKat = new Kategorie();
	$startKat->kKategorie=0;	
	
	$smarty->assign("BereitsBewertet", 0);
	
	$AktuellerArtikel->holeBewertung($_SESSION['kSprache'], $Einstellungen['bewertung']['bewertung_anzahlseite'], 0, -1, $Einstellungen['bewertung']['bewertung_freischalten'], $nSortierung);
	$AktuellerArtikel->holehilfreichsteBewertung($_SESSION['kSprache']);
		
	$smarty->assign("BereitsBewertet", pruefeKundeArtikelBewertet($AktuellerArtikel->kArtikel, $_SESSION['Kunde']->kKunde));
    
    if($Einstellungen['bewertung']['bewertung_artikel_gekauft'] == "Y")
        $smarty->assign("nArtikelNichtGekauft", pruefeKundeArtikelGekauft($AktuellerArtikel->kArtikel, $_SESSION['Kunde']->kKunde));
	
	//spezifische assigns
	$smarty->assign('Navigation', createNavigation($AktuelleSeite, 0, 0, $GLOBALS['oSprache']->gibWert('bewertung', 'breadcrumb'), "bewertung.php?a=" . $AktuellerArtikel->kArtikel . "&bfa=1"));
	$smarty->assign('Einstellungen', $Einstellungen);
	$smarty->assign('Artikel', $AktuellerArtikel);
	$smarty->assign('requestURL',$requestURL);
	$smarty->assign('sprachURL',$sprachURL);
	
	require_once(PFAD_INCLUDES."letzterInclude.php");
	$smarty->display('bewertung_formular.tpl');
} 
?>