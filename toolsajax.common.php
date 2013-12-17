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
$xajax = new xajax("toolsajax.server.php");

$cAktuelleSeite = "";
if(isset($_SERVER['HTTP_REFERER']))
    //$cAktuelleSeite = substr(strrchr($_SERVER['HTTP_REFERER'], "/"), 1, strlen(strrchr($_SERVER['HTTP_REFERER'], "/")));
	$cAktuelleSeite = basename($_SERVER['HTTP_REFERER']);

if(($cAktuelleSeite == "ajaxcheckout.php" || $cAktuelleSeite == "ajaxcheckout.php?") || substr(strrchr($_SERVER['PHP_SELF'], "/"), 1, strlen(strrchr($_SERVER['PHP_SELF'], "/"))) == "ajaxcheckout.php")
{
	require_once("includes/globalinclude.php");

	//require_once(PFAD_XAJAX . "xajax_core/xajax.inc.php");
	require_once(PFAD_SMARTY."Smarty.class.php");
	require_once(PFAD_ROOT . PFAD_INCLUDES . "bestellvorgang_inc.php");
	require_once(PFAD_ROOT . PFAD_INCLUDES . "mailTools.php");
	require_once(PFAD_ROOT . PFAD_INCLUDES . "newsletter_inc.php");
	require_once(PFAD_ROOT . PFAD_INCLUDES . "registrieren_inc.php");
	require_once(PFAD_ROOT . PFAD_INCLUDES . "bestellabschluss_inc.php");
    require_once(PFAD_ROOT . PFAD_INCLUDES . "trustedshops_inc.php");

	$session = new Session();

	$Einstellungen = getEinstellungen(array(CONF_GLOBAL,CONF_RSS,CONF_KUNDEN,CONF_KAUFABWICKLUNG,CONF_KUNDENFELD,CONF_KUNDENWERBENKUNDEN,CONF_ARTIKELDETAILS,CONF_TRUSTEDSHOPS));
	$GlobaleEinstellungen = $Einstellungen['global'];

	require_once(PFAD_ROOT . PFAD_INCLUDES . "smartyInlcude.php");
}

// Funtionen registrieren
$xajax->registerFunction("aenderKundenformularPLZ");
$xajax->registerFunction("suchVorschlag");
$xajax->registerFunction("tauscheVariationKombi");
$xajax->registerFunction("suggestions");
$xajax->registerFunction("setzeErweiterteDarstellung");
$xajax->registerFunction("fuegeEinInWarenkorbAjax");
$xajax->registerFunction("loescheWarenkorbPosAjax");
$xajax->registerFunction("gibVergleichsliste");
$xajax->registerFunction("gibPLZInfo");
$xajax->registerFunction("ermittleVersandkostenAjax");
$xajax->registerFunction("billpayRates");
$xajax->registerFunction("setSelectionWizardAnswerAjax");
$xajax->registerFunction("resetSelectionWizardAnswerAjax");
$xajax->registerFunction("checkVarkombiDependencies");
$xajax->registerFunction("gibFinanzierungInfo");
$xajax->registerFunction("gibRegionzuLand");

if(($cAktuelleSeite == "ajaxcheckout.php" || $cAktuelleSeite == "ajaxcheckout.php?") || substr(strrchr($_SERVER['PHP_SELF'], "/"), 1, strlen(strrchr($_SERVER['PHP_SELF'], "/"))) == "ajaxcheckout.php")
{
	$xajax->registerFunction("Handler");
	$xajax->registerFunction("loescheStepAjax");

	$step;
	$hinweis;
	$Kunde;
	$Lieferadresse;
	$editRechnungsadresse;
	$knd;
	$cKundenattribut_arr;

	$smarty->assign("Einstellungen", $Einstellungen);

	require_once(PFAD_ROOT . PFAD_INCLUDES . "letzterInclude.php");
}

//$xajax->setCharEncoding('UTF-8');
$xajax->setCharEncoding(JTL_CHARSET);
$xajax->setFlag("decodeUTF8Input", true);
?>
