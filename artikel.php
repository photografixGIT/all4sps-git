<?php
/**
 * copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 *
 * this file may not be redistributed in whole or significant part
 * and is subject to the JTL-Software-GmbH license.
 *
 * license: http://jtl-software.de/jtlshop3license.html
 */

require_once(PFAD_CLASSES."class.JTL-Shop.BesuchteArtikel.php");
require_once(PFAD_INCLUDES."artikel_inc.php");
require_once(PFAD_ROOT.PFAD_CLASSES_CORE."class.core.NiceMail.php");
$AktuelleSeite = "ARTIKEL";

//setze seitentyp
setzeSeitenTyp(PAGE_ARTIKEL);

$Einstellungen = "";
$Einstellungen = getEinstellungen(array(CONF_GLOBAL,CONF_NAVIGATIONSFILTER,CONF_RSS,CONF_ARTIKELDETAILS,CONF_PREISVERLAUF,CONF_BEWERTUNG,CONF_BOXEN,CONF_PREISVERLAUF,CONF_METAANGABEN));

loeseHttps();

$oGlobaleMetaAngabenAssoc_arr = holeGlobaleMetaAngaben();   // Globale Metaangaben
      
// Bewertungsguthaben
$fBelohnung = 0.0;
if(isset($_GET['fB']) && doubleval($_GET['fB']) > 0)
    $fBelohnung = doubleval($_GET['fB']);
	
// Hinweise und Fehler sammeln
// Nur wenn bisher kein Fehler gesetzt wurde!
$cHinweis = $smarty->get_template_vars('hinweis');
if (strlen($cHinweis) == 0)
	$cHinweis = mappingFehlerCode(verifyGPDataString('cHinweis'), $fBelohnung);

$cFehler = $smarty->get_template_vars('fehler');
if (strlen($cFehler) == 0)
	$cFehler = mappingFehlerCode(verifyGPDataString('cFehler'));

// Product Bundle in WK?
if (verifyGPCDataInteger("addproductbundle") == 1 && isset($_POST['a']))
{
	if (ProductBundleWK($_POST['a']))
	{
		$cHinweis = $GLOBALS['oSprache']->gibWert('basketAllAdded', 'messages');
		$kArtikel = $_POST['aBundle'];
	}
}

//hole aktuellen Artikel
$AktuellerArtikel = new Artikel();
unset($oArtikelOptionen);
$oArtikelOptionen = new stdClass;
$oArtikelOptionen->nMerkmale = 1;
$oArtikelOptionen->nAttribute = 1;
$oArtikelOptionen->nArtikelAttribute = 1;
$oArtikelOptionen->nMedienDatei = 1;
$oArtikelOptionen->nVariationKombi = 1;
$oArtikelOptionen->nVariationKombiKinder = 1;
$oArtikelOptionen->nWarenlager = 1;
//if(intval($Einstellungen['artikeldetails']['artikeldetails_varikombi_anzahl']) > 0)
	$oArtikelOptionen->nVariationDetailPreis = 1;
if($Einstellungen['artikeldetails']['artikeldetails_warenkorbmatrix_anzeige'] == "Y")   // Warenkorbmatrix nötig? => Varikinder mit Preisen holen
    $oArtikelOptionen->nWarenkorbmatrix = 1;
if($Einstellungen['artikeldetails']['artikeldetails_stueckliste_anzeigen'] == "Y")   // Stückliste nötig? => Stücklistenkomponenten  holen
    $oArtikelOptionen->nStueckliste = 1;
if($Einstellungen['artikeldetails']['artikeldetails_produktbundle_nutzen'] == "Y")
	$oArtikelOptionen->nProductBundle = 1;
$oArtikelOptionen->nFinanzierung = 1;
$oArtikelOptionen->nDownload = 1;
$oArtikelOptionen->nKonfig = 1;
$oArtikelOptionen->nMain = 1;
$AktuellerArtikel->fuelleArtikel($kArtikel, $oArtikelOptionen);
$AktuellerArtikel->holeBewertungDurchschnitt(1);

// Warenkorbmatrix Anzeigen auf Artikel Attribut pruefen und falls vorhanden setzen
if(isset($AktuellerArtikel->FunktionsAttribute['warenkorbmatrixanzeigen']) && strlen($AktuellerArtikel->FunktionsAttribute['warenkorbmatrixanzeigen']) > 0)
	$Einstellungen['artikeldetails']['artikeldetails_warenkorbmatrix_anzeige'] = $AktuellerArtikel->FunktionsAttribute['warenkorbmatrixanzeigen'];

// Warenkorbmatrix Anzeigeformat auf Artikel Attribut pruefen und falls vorhanden setzen
if(isset($AktuellerArtikel->FunktionsAttribute['warenkorbmatrixanzeigeformat']) && strlen($AktuellerArtikel->FunktionsAttribute['warenkorbmatrixanzeigeformat']) > 0)
	$Einstellungen['artikeldetails']['artikeldetails_warenkorbmatrix_anzeigeformat'] = $AktuellerArtikel->FunktionsAttribute['warenkorbmatrixanzeigeformat'];

//falls kein Artikel vorhanden, zurück zum Shop
if (!$AktuellerArtikel->kArtikel)
{
	header("HTTP/1.1 301 Moved Permanently");
	header('Location: index.php?'.SID);
	exit;
}

if(isset($AktuellerArtikel->nIstVater) && $AktuellerArtikel->nIstVater == 1 && getTemplateVersion() > 311)
{
	if(isset($_SESSION['oVarkombiAuswahl']))
		unset($_SESSION['oVarkombiAuswahl']);
	
	$_SESSION['oVarkombiAuswahl'] = new stdClass();
	$_SESSION['oVarkombiAuswahl']->kGesetzteEigeschaftWert_arr = array();
	$_SESSION['oVarkombiAuswahl']->nVariationOhneFreifeldAnzahl = $AktuellerArtikel->nVariationOhneFreifeldAnzahl;
	$_SESSION['oVarkombiAuswahl']->oKombiVater_arr = getPossibleVariationCombinations($AktuellerArtikel->kArtikel, 0, true);
	
	$smarty->assign("oKombiVater_arr", $_SESSION['oVarkombiAuswahl']->oKombiVater_arr);	
}

// Lade VariationKombiKind
if($kVariKindArtikel > 0)
{
	unset($oVariKindArtikel);
	$oVariKindArtikel = new Artikel();
	unset($oArtikelOptionen);
	$oArtikelOptionen->nMerkmale = 1;
	$oArtikelOptionen->nAttribute = 1;
	$oArtikelOptionen->nArtikelAttribute = 1;
	$oArtikelOptionen->nMedienDatei = 1;
   	$oArtikelOptionen->nKonfig = 1;
   	$oArtikelOptionen->nDownload = 1;
   	$oArtikelOptionen->nMain = 1;
   	$oArtikelOptionen->nKeinLagerbestandBeachten = 1;
   	$oArtikelOptionen->nVariationDetailPreis = 1;
   	if($Einstellungen['artikeldetails']['artikeldetails_produktbundle_nutzen'] == "Y")
   		$oArtikelOptionen->nProductBundle = 1;
   	
	$oVariKindArtikel->fuelleArtikel($kVariKindArtikel, $oArtikelOptionen);
	$AktuellerArtikel = fasseVariVaterUndKindZusammen($AktuellerArtikel, $oVariKindArtikel);
	
	// Die URL vom Vaterartikel als Canonical nutzen
    /*
	if($bSeo)
		$cCanonicalURL = URL_SHOP . "/" . $AktuellerArtikel->cVaterURL;
	else
		$cCanonicalURL = URL_SHOP . "/index.php?a=" . $AktuellerArtikel->kArtikel;
     */
        
    $bCanonicalURL = true;
    if($Einstellungen['artikeldetails']['artikeldetails_canonicalurl_varkombikind'] == "N")
        $bCanonicalURL = false;
    
    $cCanonicalURL = baueVariKombiKindCanonicalURL(SHOP_SEO, $AktuellerArtikel, $bCanonicalURL);
    $smarty->assign("a2", $kVariKindArtikel);
    $smarty->assign("reset_button", '<ul><li><button type=\'button\' class=\'submit reset_selection\' onclick=\'javascript:location.href=\"' . urlConnect(URL_SHOP, $AktuellerArtikel->cVaterURL) . '\";\'>' . $GLOBALS['oSprache']->gibWert('resetSelection', 'global') . '</button></li></ul>');
}

// Hat Artikel einen Preisverlauf?
$smarty->assign('bPreisverlauf', true);
if ($Einstellungen['preisverlauf']['preisverlauf_anzeigen'] == "Y")
{
   require_once(PFAD_CLASSES."class.JTL-Shop.Preisverlauf.php");

   $kArtikel = $kVariKindArtikel > 0 ? $kVariKindArtikel : $AktuellerArtikel->kArtikel;

   $oPreisverlauf = new Preisverlauf();
   $oPreisverlauf = $oPreisverlauf->gibPreisverlauf($kArtikel, $AktuellerArtikel->Preise->kKundengruppe, intval($Einstellungen['preisverlauf']['preisverlauf_anzahl_monate']));
   
   if (count($oPreisverlauf) < 2)
      $smarty->assign('bPreisverlauf', false);
}

// Canonical bei non SEO Shops oder wenn SEO nix rausbekommen hat

if(strlen($cCanonicalURL) == 0 && SHOP_SEO && !$kVariKindArtikel)
	$cCanonicalURL = URL_SHOP . "/" . $AktuellerArtikel->cSeo;
/*
elseif(strlen($cCanonicalURL) == 0 && $Einstellungen['artikeldetails']['artikeldetails_canonicalurl_varkombikind'] != "N" && !$bSeo)
	$cCanonicalURL = URL_SHOP . "/index.php?a=" . $kArtikel;
 */

// Gewichtoptionen beachten
//$AktuellerArtikel->fGewicht = Trennzeichen::getUnit(JTLSEPARATER_WEIGHT, $_SESSION['kSprache'], $AktuellerArtikel->fGewicht);
//$AktuellerArtikel->fArtikelgewicht = Trennzeichen::getUnit(JTLSEPARATER_WEIGHT, $_SESSION['kSprache'], $AktuellerArtikel->fArtikelgewicht);

/*
if($Einstellungen['artikeldetails']['artikeldetails_gewicht_stellenanzahl'])
    $AktuellerArtikel->fGewicht = number_format($AktuellerArtikel->fGewicht, intval($Einstellungen['artikeldetails']['artikeldetails_gewicht_stellenanzahl']), $Einstellungen['artikeldetails']['artikeldetails_zeichen_nachkommatrenner'], $Einstellungen['artikeldetails']['artikeldetails_zeichen_tausendertrenner']);
if($Einstellungen['artikeldetails']['artikeldetails_artikelgewicht_stellenanzahl'])
    $AktuellerArtikel->fArtikelgewicht =  number_format($AktuellerArtikel->fArtikelgewicht, intval($Einstellungen['artikeldetails']['artikeldetails_artikelgewicht_stellenanzahl']), $Einstellungen['artikeldetails']['artikeldetails_zeichen_nachkommatrenner'], $Einstellungen['artikeldetails']['artikeldetails_zeichen_tausendertrenner']);
*/

//Besuch setzen
setzeBesuch("kArtikel",$AktuellerArtikel->kArtikel);
$AktuellerArtikel->berechneSieSparenX($Einstellungen['artikeldetails']['sie_sparen_x_anzeigen']);
$Artikelhinweise = array();
baueArtikelhinweise();

if (isset($_POST['fragezumprodukt']) && intval($_POST['fragezumprodukt'])==1)
	bearbeiteFrageZumProdukt($AktuellerArtikel);
elseif (isset($_POST['benachrichtigung_verfuegbarkeit']) && intval($_POST['benachrichtigung_verfuegbarkeit'])==1)
	bearbeiteBenachrichtigung($AktuellerArtikel);
//elseif (intval($_POST['artikelweiterempfehlen'])==1 && $_SESSION['Kunde']->kKunde > 0)
elseif (isset($_POST['artikelweiterempfehlen']) && intval($_POST['artikelweiterempfehlen'])==1)
	bearbeiteArtikelWeiterempfehlen($AktuellerArtikel);
/*
elseif (intval($_POST['kommentarformular'])==1)
	bearbeiteKommentarFormular($AktuellerArtikel,$_SESSION['Kunde']->kKunde);
*/

//url
$requestURL = baueURL($AktuellerArtikel,URLART_ARTIKEL);
$sprachURL = baueSprachURLS($AktuellerArtikel,URLART_ARTIKEL);

//hole aktuelle Kategorie, falls eine gesetzt
$kKategorie = $AktuellerArtikel->gibKategorie();
$AktuelleKategorie = new Kategorie($kKategorie);
$AufgeklappteKategorien = new KategorieListe();
$AufgeklappteKategorien->getOpenCategories($AktuelleKategorie);
$startKat = new Kategorie();
$startKat->kKategorie=0;

$arAlleEinstellungen = array_merge($Einstellungen, $GLOBALS["GlobaleEinstellungen"]);

// Bewertungen holen
$bewertung_seite = verifyGPCDataInteger('btgseite');
$bewertung_sterne = verifyGPCDataInteger('btgsterne');
$nAnzahlBewertungen = 0;

// Sortierung der Bewertungen
$nSortierung = verifyGPCDataInteger('sortierreihenfolge');

// Dient zum aufklappen des Tabmenüs
$bewertung_anzeigen = verifyGPCDataInteger('bewertung_anzeigen');
$bAlleSprachen = verifyGPCDataInteger('moreRating');
if($bewertung_seite || $bewertung_sterne || $bewertung_anzeigen || $bAlleSprachen)
	$BewertungsTabAnzeigen = 1;

if($bewertung_seite == 0)
	$bewertung_seite = 1;

// Bewertungen holen
$AktuellerArtikel->holeBewertung($_SESSION['kSprache'], $Einstellungen['bewertung']['bewertung_anzahlseite'], $bewertung_seite, $bewertung_sterne, $Einstellungen['bewertung']['bewertung_freischalten'], $nSortierung, $bAlleSprachen);
$AktuellerArtikel->holehilfreichsteBewertung($_SESSION['kSprache']);
$AktuellerArtikel->Bewertungen->Sortierung = $nSortierung;

if($bewertung_sterne == 0)
	//$nAnzahlBewertungen = $AktuellerArtikel->Bewertungen->oBewertungGesamt->nAnzahl;
	$nAnzahlBewertungen = $AktuellerArtikel->Bewertungen->nAnzahlSprache;
else
	$nAnzahlBewertungen = $AktuellerArtikel->Bewertungen->nSterne_arr[5-$bewertung_sterne];

// Baue Blätter Navigation
$oBlaetterNavi = baueBewertungNavi($bewertung_seite, $bewertung_sterne, $nAnzahlBewertungen, $Einstellungen['bewertung']['bewertung_anzahlseite']);

// Baue Gewichte für Smarty
//$oTrennzeichen = Trennzeichen::getUnit(JTLSEPARATER_WEIGHT, $_SESSION['kSprache']);
//baueGewicht(array($AktuellerArtikel), $oTrennzeichen->getDezimalstellen(), $oTrennzeichen->getDezimalstellen());
//baueGewicht(array($AktuellerArtikel), $Einstellungen['artikeldetails']['artikeldetails_artikelgewicht_stellenanzahl'], $Einstellungen['artikeldetails']['artikeldetails_gewicht_stellenanzahl']);

// Ähnliche Artikel
if(intval($Einstellungen['artikeldetails']['artikeldetails_aehnlicheartikel_anzahl']) > 0)
	$smarty->assign("oAehnlicheArtikel_arr", holeAehnlicheArtikel($kArtikel));
   
// Konfig bearbeiten
if (hasGPCDataInteger('ek') && class_exists('Konfigitem'))
{
   $kKonfig = verifyGPCDataInteger('ek');
   if (isset($_SESSION['Warenkorb']->PositionenArr[$kKonfig]))
   {
      $oBasePosition = $_SESSION['Warenkorb']->PositionenArr[$kKonfig];
      if ($oBasePosition->istKonfigVater())
      {
         $nKonfigitem_arr = array();
         $nKonfigitemAnzahl_arr = array();
         $nKonfiggruppeAnzahl_arr = array();
         
         foreach ($_SESSION['Warenkorb']->PositionenArr as &$oPosition)
         {
            if ($oPosition->istKonfigKind() && $oPosition->cUnique == $oBasePosition->cUnique)
            {
               $oKonfigitem = new Konfigitem($oPosition->kKonfigitem);
               $nKonfigitem_arr[] = $oKonfigitem->getKonfigitem();
               $nKonfigitemAnzahl_arr[$oKonfigitem->getKonfigitem()] = $oPosition->nAnzahl / $oBasePosition->nAnzahl;
               $nKonfiggruppeAnzahl_arr[$oKonfigitem->getKonfiggruppe()] = $oPosition->nAnzahl / $oBasePosition->nAnzahl;
            }
         }
         
         $smarty->assign('fAnzahl', $oBasePosition->nAnzahl);
         $smarty->assign('kEditKonfig', $kKonfig);
         
         $smarty->assign('nKonfigitem_arr', $nKonfigitem_arr);
         $smarty->assign('nKonfigitemAnzahl_arr', $nKonfigitemAnzahl_arr);
         $smarty->assign('nKonfiggruppeAnzahl_arr', $nKonfiggruppeAnzahl_arr);
      }
   }
}
	
//spezifische assigns
$smarty->assign('Navigation',createNavigation($AktuelleSeite, $AufgeklappteKategorien, $AktuellerArtikel));
$smarty->assign('Ueberschrift',$AktuellerArtikel->cName);
$smarty->assign('UeberschriftKlein',$AktuellerArtikel->cKurzBeschreibung);
$smarty->assign('UVPlocalized',gibPreisStringLocalized($AktuellerArtikel->fUVP));
$smarty->assign('UVPBruttolocalized',gibPreisStringLocalized($AktuellerArtikel->fUVPBrutto));
$smarty->assign('Einstellungen',$arAlleEinstellungen);
$smarty->assign('Artikel',$AktuellerArtikel);
//$smarty->assign('1Artikel',$AktuellerArtikel);
$smarty->assign('Xselling',gibArtikelXSelling($AktuellerArtikel->kArtikel));
$smarty->assign('requestURL',$requestURL);
$smarty->assign('sprachURL',$sprachURL);
$smarty->assign('Artikelhinweise',$Artikelhinweise);
$smarty->assign('verfuegbarkeitsBenachrichtigung',gibVerfuegbarkeitsformularAnzeigen($AktuellerArtikel, $Einstellungen['artikeldetails']['benachrichtigung_nutzen']));
$smarty->assign('code_fragezumprodukt',generiereCaptchaCode($Einstellungen['artikeldetails']['produktfrage_abfragen_captcha']));
$smarty->assign('code_kommentarformular',(isset($Einstellungen['artikeldetails']['kommentarformular_abfragen_captcha'])) ? generiereCaptchaCode($Einstellungen['artikeldetails']['kommentarformular_abfragen_captcha']) : null);
$smarty->assign('code_benachrichtigung_verfuegbarkeit',generiereCaptchaCode($Einstellungen['artikeldetails']['benachrichtigung_abfragen_captcha']));
$smarty->assign('code_weiterempfehlen',generiereCaptchaCode($Einstellungen['artikeldetails']['artikeldetails_artikelweiterempfehlen_captcha']));
$smarty->assign('ProdukttagHinweis',bearbeiteProdukttags($AktuellerArtikel));
$smarty->assign('ProduktTagging',holeProduktTagging($AktuellerArtikel));
$smarty->assign('BlaetterNavi', $oBlaetterNavi);
$smarty->assign('BewertungsTabAnzeigen', (isset($BewertungsTabAnzeigen)) ? $BewertungsTabAnzeigen : null);
$smarty->assign('hinweis', $cHinweis);
$smarty->assign('fehler', $cFehler);
$smarty->assign('nRedirectRecommend', R_LOGIN_ARTIKELWEITEREMPFEHLEN);

//$smarty->assign('PFAD_IMAGESLIDER', URL_SHOP . "/" . PFAD_IMAGESLIDER);
$smarty->assign('PFAD_MEDIAFILES', URL_SHOP . "/" . PFAD_MEDIAFILES);
$smarty->assign('PFAD_FLASHPLAYER', URL_SHOP . "/" . PFAD_FLASHPLAYER);
//$smarty->assign('PFAD_BILDER', URL_SHOP . "/" . PFAD_BILDER);

$smarty->assign('PFAD_IMAGESLIDER', PFAD_IMAGESLIDER);
//$smarty->assign('PFAD_MEDIAFILES', PFAD_MEDIAFILES);
//$smarty->assign('PFAD_FLASHPLAYER', PFAD_FLASHPLAYER);
$smarty->assign('PFAD_BILDER', PFAD_BILDER);
$smarty->assign('PFAD_ART_ABNAHMEINTERVALL', PFAD_ART_ABNAHMEINTERVALL);
$smarty->assign('FKT_ATTRIBUT_ATTRIBUTEANHAENGEN', FKT_ATTRIBUT_ATTRIBUTEANHAENGEN);
$smarty->assign('FKT_ATTRIBUT_WARENKORBMATRIX', FKT_ATTRIBUT_WARENKORBMATRIX);
$smarty->assign('FKT_ATTRIBUT_INHALT', FKT_ATTRIBUT_INHALT);
$smarty->assign('FKT_ATTRIBUT_MAXBESTELLMENGE', FKT_ATTRIBUT_MAXBESTELLMENGE);
$smarty->assign('FKT_ATTRIBUT_ARTIKELDETAILS_TPL', FKT_ATTRIBUT_ARTIKELDETAILS_TPL);
$smarty->assign('FKT_ATTRIBUT_ARTIKELKONFIG_TPL', FKT_ATTRIBUT_ARTIKELKONFIG_TPL);
$smarty->assign('FKT_ATTRIBUT_ARTIKELKONFIG_TPL_JS', FKT_ATTRIBUT_ARTIKELKONFIG_TPL_JS);

$smarty->assign('KONFIG_ITEM_TYP_ARTIKEL', KONFIG_ITEM_TYP_ARTIKEL);
$smarty->assign('KONFIG_ITEM_TYP_SPEZIAL', KONFIG_ITEM_TYP_SPEZIAL);

$smarty->assign('KONFIG_ANZEIGE_TYP_CHECKBOX', KONFIG_ANZEIGE_TYP_CHECKBOX);
$smarty->assign('KONFIG_ANZEIGE_TYP_RADIO', KONFIG_ANZEIGE_TYP_RADIO);
$smarty->assign('KONFIG_ANZEIGE_TYP_DROPDOWN', KONFIG_ANZEIGE_TYP_DROPDOWN);
$smarty->assign('KONFIG_ANZEIGE_TYP_DROPDOWN_MULTI', KONFIG_ANZEIGE_TYP_DROPDOWN_MULTI);

$arNichtErlaubteEigenschaftswerte = array();
if ($AktuellerArtikel->Variationen)
{
	foreach ($AktuellerArtikel->Variationen as $Variation)
	{
		if ($Variation->Werte && $Variation->cTyp != "FREIFELD" && $Variation->cTyp != "PFLICHT-FREIFELD")
		{
			foreach ($Variation->Werte as $Wert)
			{
				$arNichtErlaubteEigenschaftswerte[$Wert->kEigenschaftWert] = gibNichtErlaubteEigenschaftswerte($Wert->kEigenschaftWert);
			}
		}
	}
	$smarty->assign('arNichtErlaubteEigenschaftswerte',$arNichtErlaubteEigenschaftswerte);
}

//navi blättern
if ($Einstellungen['artikeldetails']['artikeldetails_navi_blaettern']=="Y")
{
        $smarty->assign('NavigationBlaettern',gibNaviBlaettern($AktuellerArtikel->kArtikel, $AktuelleKategorie->kKategorie));
}

require_once(PFAD_INCLUDES."letzterInclude.php");

//Meta
$smarty->assign('meta_title',gibMetaTitle($AktuellerArtikel));
$smarty->assign('meta_description',gibMetaDescription($AktuellerArtikel, $AufgeklappteKategorien));
$smarty->assign('meta_keywords',gibMetaKeywords($AktuellerArtikel));

// Hook
executeHook(HOOK_ARTIKEL_PAGE);

$smarty->display('artikel.tpl');
?>