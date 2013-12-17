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
require_once(PFAD_ROOT . PFAD_CLASSES . "class.JTL-Shop.Plugin.php");

//einstellungen holen
$Einstellungen = getEinstellungen(array(CONF_GLOBAL,CONF_RSS,CONF_KUNDEN,CONF_KAUFABWICKLUNG,CONF_ZAHLUNGSARTEN,CONF_EMAILS,CONF_TRUSTEDSHOPS));

require_once(PFAD_ROOT . PFAD_INCLUDES . "plugin_inc.php");
require_once(PFAD_ROOT . PFAD_INCLUDES . "bestellabschluss_inc.php");
require_once(PFAD_ROOT . PFAD_INCLUDES . "bestellvorgang_inc.php");
require_once(PFAD_ROOT . PFAD_INCLUDES . "trustedshops_inc.php");
require_once(PFAD_ROOT . PFAD_INCLUDES . "mailTools.php");
$AktuelleSeite = "BESTELLVORGANG";
//session starten
$session = new Session();

//erstelle $smarty
require_once(PFAD_INCLUDES."smartyInlcude.php");

//setze seitentyp
setzeSeitenTyp(PAGE_BESTELLABSCHLUSS);

$bestellung;

// PayPal work around
if(isset($_GET['payer_id']) && isset($_GET['txn_id']) && isset($_GET['custom']))
	$_GET['i'] = $_GET['custom']; 

if ($_GET['i'])
{
	$bestellid = $GLOBALS["DB"]->executeQuery("select * from tbestellid where cId='".$GLOBALS['DB']->escape($_GET['i'])."'",1);
	if ($bestellid->kBestellung>0)
	{
		$bestellung = new Bestellung($bestellid->kBestellung);
		$bestellung->fuelleBestellung(0);
		$GLOBALS["DB"]->executeQuery("delete from tbestellid where kBestellung=".$bestellid->kBestellung,4);
        
        // Zahlungsanbieter
        switch($_GET['za'])
        {
            case 'eos':
                include_once(PFAD_INCLUDES_MODULES."eos/eos.php");
                eosZahlungsNachricht($bestellung);
                break;
        }
	}

	$GLOBALS["DB"]->executeQuery("delete from tbestellid where dDatum < date_sub(now(),interval 30 day)",4);
	$smarty->assign('abschlussseite',1);
}
else
{    
	$_SESSION['kommentar'] = substr(strip_tags($GLOBALS['DB']->escape($_POST['kommentar'])), 0, 1000);
	
	//ist Bestellabschluss möglich?           	
	if (!bestellungKomplett())
	{
		header('Location: bestellvorgang.php?fillOut='.gibFehlendeEingabe().'&'.SID);
		exit;
	}
	else
	{        
		//schaue, ob von jedem Artikel im WK genug auf Lager sind. Wenn nicht, WK verkleinern und Redirect zum WK
		$_SESSION["Warenkorb"]->pruefeLagerbestaende();
			
		if($_SESSION["Zahlungsart"]->nWaehrendBestellung == 0)
        {
            $bestellung = finalisiereBestellung();

            $bestellid = $GLOBALS["DB"]->executeQuery("select * from tbestellid where kBestellung=".$_SESSION['kBestellung'],1);
            $successPaymentURL = URL_SHOP;
            if ($bestellid->cId)
                $successPaymentURL = URL_SHOP.'/bestellabschluss.php?i='.$bestellid->cId;
    
            $smarty->assign('Bestellung',$bestellung);
        }
        else 
        {   
            $bestellung = fakeBestellung();
        }
		
		setzeSmartyWeiterleitung($bestellung);
	}
}

//hole aktuelle Kategorie, falls eine gesetzt
$AktuelleKategorie = new Kategorie(verifyGPCDataInteger("kategorie"));
$AufgeklappteKategorien = new KategorieListe();
$AufgeklappteKategorien->getOpenCategories($AktuelleKategorie);
$startKat = new Kategorie();
$startKat->kKategorie=0;

// Trusted Shops Käuferschutz Classic
if(isset($Einstellungen['trustedshops']['trustedshops_nutzen']) && $Einstellungen['trustedshops']['trustedshops_nutzen'] === "Y")
{
    require_once(PFAD_ROOT . PFAD_CLASSES . "class.JTL-Shop.TrustedShops.php");
    $oTrustedShops = new TrustedShops(-1, convertISO2ISO639($_SESSION['cISOSprache']));
    
    if(strlen($oTrustedShops->tsId) > 0 && $oTrustedShops->nAktiv == 1)
        $smarty->assign("oTrustedShops", $oTrustedShops);
}

$smarty->assign('Navigation',createNavigation($AktuelleSeite));
$smarty->assign('Firma',$GLOBALS["DB"]->executeQuery("select * from tfirma",1));
$smarty->assign('WarensummeLocalized', $_SESSION["Warenkorb"]->gibGesamtsummeWarenLocalized());
$smarty->assign('Einstellungen',$Einstellungen);
$smarty->assign('Bestellung',$bestellung);
$smarty->assign('Kunde',$_SESSION['Kunde']);
$smarty->assign('bOrderConf',true); 

// Plugin Zahlungsmethode beachten
$kPlugin = gibkPluginAuscModulId($bestellung->Zahlungsart->cModulId);
if($kPlugin > 0)
{
    $oPlugin = new Plugin($kPlugin);
    $smarty->assign("oPlugin", $oPlugin);
}

if($_SESSION["Zahlungsart"]->nWaehrendBestellung == 0 || isset($_GET['i']))
{	
    if($Einstellungen['trustedshops']['trustedshops_kundenbewertung_anzeigen'] == "Y")
        $smarty->assign("oTrustedShopsBewertenButton", gibTrustedShopsBewertenButton($bestellung->oRechnungsadresse->cMail, $bestellung->cBestellNr));
        
	raeumeSessionAufNachBestellung();
	require_once(PFAD_INCLUDES."letzterInclude.php");
    
    // Hook
    executeHook(HOOK_BESTELLABSCHLUSS_PAGE);
    
	$smarty->display('bestellabschluss.tpl');
}
else 
{
	require_once(PFAD_INCLUDES."letzterInclude.php");	
    
    // Hook
    executeHook(HOOK_BESTELLABSCHLUSS_PAGE_ZAHLUNGSVORGANG);
    
	$smarty->display('tpl_inc/bestellvorgang_zahlungsvorgang.tpl');
}
?>