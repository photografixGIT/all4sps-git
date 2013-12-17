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
require_once(PFAD_ROOT.PFAD_CLASSES."class.JTL-Shop.Bestellung.php");
require_once(PFAD_INCLUDES."mailTools.php");
$session = new Session();
require_once(PFAD_INCLUDES."smartyInlcude.php");

$strHTML    = "";
$strErrDesc = "";

//Clickpay
$arResultResponseCode = array(
	"0"   => "Funktion fehlerfrei durchgeführt",
	"2"   => "Zahlung abgelehnt",
	"3"   => "Unzulässige Händlernummer",
	"4"   => "Verwendete Karte ist nicht zugelassen",
	"5"   => "Bankleitzahl gesperrt / keine Genehmigung (bei Kreditkarte)",
	"12"  => "Transaktion ungültig (z. B. Währung nicht zulässig)",
	"13"  => "Verfügbarer Betrag überschritten",
	"14"  => "Karte ungültig",
	"21"  => "Storno nicht durchgeführt, zugehörige Autorisierung nicht gefunden",
	"30"  => "Formatfehler",
	"31"  => "Kartenherausgeber nicht zugelassen",
	"33"  => "Verfalldatum der Karte überschritten",
	"34"  => "Manipulationsverdacht",
	"40"  => "Erbetene Funktion wird nicht unterstützt",
	"43"  => "Gestohlene Karte",
	"55"  => "Falsche persönliche Identifikationsnummer",
	"56"  => "Karte nicht in Datenbank des Autorisierers",
	"58"  => "Unbekannte Terminal ID",
	"62"  => "Karte gesperrt",
	"64"  => "Transaktionsbetrag ist abweichend von der Autorisierung",
	"77"  => "PIN – Eingabe notwendig",
	"80"  => "Betrag nicht länger verfügbar",
	"81"  => "Initialisierung fehlerhaft (Warnung); Wiederholung erforderlich",
	"82"  => "Initialisierung unzulässig (Terminal gesperrt)",
	"85"  => "Ablehnung vom Kreditkarteninstitut",
	"86"  => "Stammdaten unbekannt",
	"87"  => "Terminal unbekannt",
	"91"  => "Kartenherausgeber oder Netz nicht verfügbar",
	"92"  => "AS stellt falsches Routing fest",
	"96"  => "AS-Verarbeitung z.Zt. nicht möglich",
	"98"  => "Aufforderung zur erweiterten Diagnose",
	"-1"  => "Allgemeiner Systemfehler",
	"-01" => "HostedDataID existiert bereits ohne PAN/ExpiryDate (Data Storage)",
	"-02" => "HostedDataID existiert bereits mit PAN/ExpiryDate (Data Storage)",
	"-30" => "Fehler beim Lesen der Karte",
	"-31" => "Karte ungültig",
	"-40" => "Softpay: Ordernummer bereits vergeben",
	"-56" => "Fehler bei Konfiguration des Customized Wallet (Dateityp)",
	"-57" => "Fehler bei Konfiguration des Customized Wallet (Dateigröße in Pixel)",
	"-58" => "Fehler bei Konfiguration des Customized Wallet (Dateigröße in Bytes)",
	"-59" => "Konfigurationsfehler",
	"-61" => "Mobilfunknummer falsch",
	"-62" => "Kontonummer und/oder BLZ sind falsch",
	"-63" => "Gültigkeitsdatum falsch/überschritten",
	"-64" => "Kartennummer falsch",
	"-65" => "Unbekannte Kartenart",
	"-66" => "Zahlung für diese TransactionID wurde schon erfolgreich verbucht, Zahlung	wird nicht nochmal eingereicht",
	"-67" => "Zahlung für diese TransactionID läuft gerade, Zahlung wird nicht nochmal eingereicht",
	"-68" => "Die Authentifizierung über Online Secure ist fehlgeschlagen",
	"-78" => "Transaktion wurde nicht autorisiert (giropay)",
	"-79" => "Die angegebene HostedDataID existiert nicht (Data Storage)",
	"-80" => "Stapelverarbeitungsdatei nicht gültig oder nicht vorhanden!",
	"-81" => "Kein freies Terminal verfügbar (reserviert)",
	"-83" => "Daten nicht ermittelbar",
	"-85" => "Protokoll nicht verfügbar",
	"-86" => "Stapelverarbeitung nicht verfügbar",
	"-87" => "Datenmanipulation",
	"-88" => "Keine Details verfügbar",
	"-89" => "Transaktion nicht möglich",
	"-90" => "Transaktion mit SequenceNo nicht vorhanden",
	"-91" => "Terminal nicht verfügbar",
	"-92" => "Unbekannte Mobilfunkkartenart",
	"-93" => "Zahlung nicht verfügbar",
	"-94" => "Parameter falsch oder Datensatz unvollständig. Eventuell haben Sie Felder bei der Eingabe der Daten leer gelassen.",
	"-95" => "Authentifizierung schlug fehl/benötigte Benutzerrolle fehlt",
	"-96" => "Transaktion nicht verfügbar",
	"-97" => "Online Konverter nicht verfügbar",
	"-98" => "System nicht verfügbar",
	"-99" => "Zahlung mit Test-Kreditkartennummer (nur auf Demo-System)",
);
$strResultCode = $_GET['tcphResultCode'];
$strResultResponseCode = $_GET['tcphResultResponseCode'];
$strErrDesc = $arResultResponseCode[$strResultResponseCode];

$strHTML.= "<div style=\"font-family:arial,helvetica;text-align:middle;\"><br /><br /><br />";

switch ($strResultCode)
{
	case "OK":
		$strHTML.= "<p>Ihre Transaktion mit Click & Pay easy war erfolgreich und wurde als bezahlt markiert. Ihre Bestellung wird nun so schnell wie möglich verschickt.</p>";
		break;
	case "FAILURE":
	case "ERROR":
		$strHTML.= "<p>Es ist ein Fehler bei der Transaktion aufgetreten.<br /><br />";
		$strHTML.= "$strErrDesc (Fehlercode: $strResultResponseCode)<br /></p>";
		break;
}

switch($strResultResponseCode)
{
	case "-94":
	case "-64":
	case "-63":
	case "-62":
		//Zurück zur WalletPage (vorherige Seite)
		$strHTML.=
			"<p>Sie können mit dem \"Zurück\ Button Ihres Browsers die Eingaben in dem Formular wiederholen.</p>";
		break;
}

$strHTML.= "<p>In Kürze werden Sie automatisch zurück zum Shop geleitet.</p>";

if ($_REQUEST['i'] > 0)
{
	$strHTML.= "<p><a href=\"".URL_SHOP."/bestellabschluss.php?i=".$_REQUEST['i']."\">".
		"Zurück zum Shop</a></p>";
}
else
{
	$strHTML.=
		"<p><a href=\"".URL_SHOP."\">".
		"Zurück zum Shop</a></p>";
}

$strHTML.= "</div>";

$strURL = URL_SHOP;

if ($_REQUEST['i']) {
	$url = $strURL."/bestellabschluss.php?i=".$_REQUEST['i'];
} else {
	$url = $strURL."/bestellabschluss.php";
}
$headerscript =
	"<script type=\"text/javascript\">".
	"	function loadshop()".
	"	{".
	"     setTimeout(\"window.location.href = '$url'\",4000);".
	"	}".
	"</script>";

$smarty->assign('headerscript',$headerscript);
$smarty->assign('onload',"onload=\"loadshop();\"");

//$smarty->assign('currentTemplateDir',$server_address);
$smarty->assign('inhalt',$strHTML);
$smarty->display('status_transaktion.tpl');
?>