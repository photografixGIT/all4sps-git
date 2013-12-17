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
require_once(PFAD_INCLUDES."/bestellvorgang_inc.php");
require_once(PFAD_INCLUDES."mailTools.php");
require_once(PFAD_ROOT . PFAD_INCLUDES . "newsletter_inc.php");
require_once(PFAD_ROOT . PFAD_INCLUDES . "registrieren_inc.php");
$AktuelleSeite = "REGISTRIEREN";

//session starten
$session = new Session();

//einstellungen holen
$Einstellungen = getEinstellungen(array(CONF_GLOBAL,CONF_RSS,CONF_KUNDEN,CONF_KUNDENFELD,CONF_KUNDENWERBENKUNDEN,CONF_NEWSLETTER));

pruefeHttps();

$kLink = gibLinkKeySpecialSeite(LINKTYP_REGISTRIEREN);

//erstelle $smarty
require_once(PFAD_INCLUDES."smartyInlcude.php");

//setze seitentyp
setzeSeitenTyp(PAGE_REGISTRIERUNG);

$step = 'formular';
$hinweis="";
$knd;
$Kunde;
$cKundenattribut_arr;
$titel = $GLOBALS['oSprache']->gibWert('newAccount', 'login'); 

$editRechnungsadresse = intval($_GET['editRechnungsadresse']);
if (intval($_POST['editRechnungsadresse']))
	$editRechnungsadresse = intval($_POST['editRechnungsadresse']);

// Kunde speichern
if (intval($_POST['form'])==1)
	kundeSpeichern($_POST);

// Kunde ändern
if (intval($_GET['editRechnungsadresse'])==1)
	gibKunde();

if ($step=="formular")
	gibFormularDaten(verifyGPCDataInteger('checkout'));	

//hole aktuelle Kategorie, falls eine gesetzt
$AktuelleKategorie = new Kategorie(verifyGPCDataInteger("kategorie"));
$AufgeklappteKategorien = new KategorieListe();
$AufgeklappteKategorien->getOpenCategories($AktuelleKategorie);
$startKat = new Kategorie();
$startKat->kKategorie=0;

//spezifische assigns
$smarty->assign('Navigation',createNavigation($AktuelleSeite));
$smarty->assign('editRechnungsadresse',$editRechnungsadresse);
$smarty->assign('Ueberschrift',$titel);
$smarty->assign('Einstellungen',$Einstellungen);
$smarty->assign('hinweis',$hinweis);
$smarty->assign('step',$step);
$smarty->assign('sess',$_SESSION);
$smarty->assign('nAnzeigeOrt', CHECKBOX_ORT_REGISTRIERUNG);
$smarty->assign('code_registrieren', generiereCaptchaCode($Einstellungen['kunden']['registrieren_captcha']));

// Canonical
$cCanonicalURL = gibShopURL() . "/registrieren.php";

// Metaangaben
$oMeta = baueSpecialSiteMeta(LINKTYP_REGISTRIEREN);
$cMetaTitle = $oMeta->cTitle;
$cMetaDescription = $oMeta->cDesc;
$cMetaKeywords = $oMeta->cKeywords;

require_once(PFAD_INCLUDES."letzterInclude.php");

//Zum prüfen wie lange ein User/Bot gebraucht hat um das Registrieren-Formular auszufüllen
if(isset($GLOBALS['Einstellungen']['kunden']['kundenregistrierung_pruefen_zeit']) && $GLOBALS['Einstellungen']['kunden']['kundenregistrierung_pruefen_zeit'] == "Y") {
    $_SESSION['dRegZeit'] = time();
}

// Hook
executeHook(HOOK_REGISTRIEREN_PAGE);

$smarty->display('registrieren.tpl');
?>