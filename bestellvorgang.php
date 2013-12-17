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
require_once("includes/bestellvorgang_inc.php");
require_once("includes/trustedshops_inc.php");
require_once(PFAD_INCLUDES_MODULES . 'PaymentMethod.class.php');

$AktuelleSeite = "BESTELLVORGANG";

//session starten
$session = new Session();

//einstellungen holen
$Einstellungen = getEinstellungen(array(CONF_GLOBAL,CONF_RSS,CONF_KUNDEN,CONF_KAUFABWICKLUNG,CONF_KUNDENFELD,CONF_TRUSTEDSHOPS));

//setze seitentyp
setzeSeitenTyp(PAGE_BESTELLVORGANG);

//erstelle $smarty
require_once(PFAD_INCLUDES."smartyInlcude.php");

$step = 'accountwahl';
$hinweis="";
$Kunde;
$Lieferadresse;

// Kill Ajaxcheckout falls vorhanden
unset($_SESSION['ajaxcheckout']);

// Loginbenutzer?
if (intval($_POST["login"])==1)
	fuehreLoginAus($_POST["userLogin"], $_POST["passLogin"]);

if(verifyGPCDataInteger('basket2Pers') == 1)
{
    require_once(PFAD_ROOT . PFAD_INCLUDES . "jtl_inc.php");
    
    setzeWarenkorbPersInWarenkorb($_SESSION['Kunde']->kKunde);
    header("Location: bestellvorgang.php?wk=1");
    exit();
}

// Ist Bestellung möglich?
if ($_SESSION["Warenkorb"]->istBestellungMoeglich() != 10)
	pruefeBestellungMoeglich();
	
// Pflicht-Uploads vorhanden?
if (class_exists("Upload"))
{
   if (!Upload::pruefeWarenkorbUploads($_SESSION['Warenkorb']))
      Upload::redirectWarenkorb(UPLOAD_ERROR_NEED_UPLOAD);
}

// Download-Artikel vorhanden?
if (class_exists("Download"))
{
   if (Download::hasDownloads($_SESSION['Warenkorb']))
   {
      // Nur registrierte Benutzer
      $Einstellungen['kaufabwicklung']['bestellvorgang_unregistriert'] = 'N';
   }
}

// oneClick?
// Darf nur einmal ausgeführt werden und nur dann, wenn man vom Warenkorb kommt.
if($Einstellungen['kaufabwicklung']['bestellvorgang_kaufabwicklungsmethode'] == "NO" && verifyGPCDataInteger("wk") == 1)
{
    $kKunde = 0;
    if (isset($_SESSION["Kunde"]->kKunde))
        $kKunde = $_SESSION["Kunde"]->kKunde;
        
    $oWarenkorbPers = new WarenkorbPers($kKunde);
    if (!(count($oWarenkorbPers->oWarenkorbPersPos_arr) > 0 && intval($_POST["login"]) == 1 && $Einstellungen['global']['warenkorbpers_nutzen'] == "Y" && $Einstellungen['kaufabwicklung']['warenkorb_warenkorb2pers_merge'] == "P"))
    	pruefeAjaxEinKlick();
}

if (verifyGPCDataInteger("wk") == 1)
    resetNeuKundenKupon();

//https? wenn erwünscht reload mit https
//bei hostEurope $_SERVER['HTTP_X_FORWARDED_HOST'] != 'ssl.webpack.de'
pruefeHttps();

if (intval($_POST['versandartwahl'])==1)
	pruefeVersandartWahl($_POST['Versandart']);

if (intval($_POST['unreg_form'])==1 && $Einstellungen['kaufabwicklung']['bestellvorgang_unregistriert'] == 'Y')
{
	$cPost_arr = $_POST;
	pruefeUnregistriertBestellen($cPost_arr);
}

if (intval($_GET['unreg'])==1 && $Einstellungen['kaufabwicklung']['bestellvorgang_unregistriert'] == 'Y')
	$step="unregistriert bestellen";

if (intval($_POST['lieferdaten'])==1)
	pruefeLieferdaten($_POST);

//autom. step ermitteln
if ($_SESSION['Kunde'])
	$step="Lieferadresse";
   
// Download-Artikel vorhanden?
if (class_exists("Download"))
{
   if (Download::hasDownloads($_SESSION['Warenkorb']))
   {
      // Falls unregistrierter Kunde bereits im Checkout war und einen Downloadartikel hinzugefügt hat
      if ((!isset($_SESSION["Kunde"]->cPasswort) || strlen($_SESSION["Kunde"]->cPasswort) == 0) && $step != 'accountwahl')
      {
         $step = 'accountwahl';
         unset($_SESSION['Kunde']);
      }
   }
}

//autom. step ermitteln
pruefeVersandkostenStep();

//autom. step ermitteln
pruefeZahlungStep();

//autom. step ermitteln
pruefeBestaetigungStep();

//sondersteps Rechnungsadresse ändern
pruefeRechnungsadresseStep($_GET);

//sondersteps Lieferadresse ändern
pruefeLieferadresseStep($_GET);

//sondersteps Versandart ändern
pruefeVersandartStep($_GET);

//sondersteps Zahlungsart ändern
pruefeZahlungsartStep($_GET);

pruefeZahlungsartwahlStep($_POST);

if ($step=="accountwahl")
	gibStepAccountwahl();

if ($step=="unregistriert bestellen")
	gibStepUnregistriertBestellen();

if ($step=="Lieferadresse")
	gibStepLieferadresse();

if ($step=="Versand")
	gibStepVersand();

if ($step=="Zahlung")
	gibStepZahlung();

if ($step=="ZahlungZusatzschritt")
	gibStepZahlungZusatzschritt($_POST);

if ($step=="Bestaetigung")
{
    plausiGuthaben($_POST);
    $smarty->assign("cKuponfehler_arr", plausiKupon($_POST));
    //evtl genutztes guthaben anpassen
    pruefeGuthabenNutzen();
	gibStepBestaetigung($_GET);
}

// SafetyPay Work Around
if($_SESSION['Zahlungsart']->cModulId=="za_safetypay" && $step=="Bestaetigung")
{
	require_once(PFAD_INCLUDES_MODULES."safetypay/safetypay.php");
	$smarty->assign('safetypay_form',gib_safetypay_form($_SESSION['Kunde'],$_SESSION['Warenkorb'],$Einstellungen['zahlungsarten']));
}

// Billpay
if ($_SESSION['Zahlungsart']->cModulId == "za_billpay_jtl" && $step == "Bestaetigung")
{
	$paymentMethod = PaymentMethod::create('za_billpay_jtl');
	$paymentMethod->handleConfirmation();
}

//hole aktuelle Kategorie, falls eine gesetzt
$AktuelleKategorie = new Kategorie(verifyGPCDataInteger("kategorie"));
$AufgeklappteKategorien = new KategorieListe();
$AufgeklappteKategorien->getOpenCategories($AktuelleKategorie);
$startKat = new Kategorie();
$startKat->kKategorie=0;

//spezifische assigns
$smarty->assign('Navigation',createNavigation($AktuelleSeite));

$smarty->assign("AGB", gibAGBWRB($_SESSION['kSprache'], $_SESSION['Kundengruppe']->kKundengruppe));
//$smarty->assign('AGB',$GLOBALS["DB"]->executeQuery("select * from ttext where kText=1 and cISOSprache=\"".$_SESSION['cISOSprache']."\"",1));
//$smarty->assign('WRB',$GLOBALS["DB"]->executeQuery("select * from ttext where kText=2 and cISOSprache=\"".$_SESSION['cISOSprache']."\"",1));

$smarty->assign('Ueberschrift',$GLOBALS['oSprache']->gibWert('orderStep0Title', 'checkout'));
$smarty->assign('UeberschriftKlein',$GLOBALS['oSprache']->gibWert('orderStep0Title2', 'checkout'));

$smarty->assign('Einstellungen',$Einstellungen);
$smarty->assign('hinweis',$hinweis);
$smarty->assign('step',$step);
$smarty->assign('WarensummeLocalized', $_SESSION["Warenkorb"]->gibGesamtsummeWarenLocalized());
$smarty->assign('Warensumme', $_SESSION["Warenkorb"]->gibGesamtsummeWaren());
$smarty->assign('Steuerpositionen', $_SESSION["Warenkorb"]->gibSteuerpositionen());
$smarty->assign('bestellschritt',gibBestellschritt($step));
$smarty->assign('requestURL',$requestURL);
$smarty->assign('C_WARENKORBPOS_TYP_ARTIKEL', C_WARENKORBPOS_TYP_ARTIKEL);
$smarty->assign('C_WARENKORBPOS_TYP_GRATISGESCHENK', C_WARENKORBPOS_TYP_GRATISGESCHENK);
require_once(PFAD_INCLUDES."letzterInclude.php");

// Hook
executeHook(HOOK_BESTELLVORGANG_PAGE);

$smarty->display('bestellvorgang.tpl');
?>
