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
$AktuelleSeite = "WARTUNG";

//session starten
$session = new Session();

//einstellungen holen
$Einstellungen = getEinstellungen(array(CONF_GLOBAL,CONF_RSS,CONF_KUNDEN,CONF_KUNDENFELD,CONF_KUNDENWERBENKUNDEN,CONF_NEWSLETTER));

//erstelle $smarty
require_once(PFAD_INCLUDES."smartyInlcude.php");

//setze seitentyp
setzeSeitenTyp(PAGE_WARTUNG);

//url
$requestURL = baueURL($Link,URLART_SEITE);
$sprachURL = baueSprachURLS($Link,URLART_SEITE);

$Boxen;

//hole aktuelle Kategorie, falls eine gesetzt
$AktuelleKategorie = new Kategorie(verifyGPCDataInteger("kategorie"));
$AufgeklappteKategorien = new KategorieListe();
$AufgeklappteKategorien->getOpenCategories($AktuelleKategorie);
$startKat = new Kategorie();
$startKat->kKategorie=-1;

//spezifische assigns
$smarty->assign('Navigation',createNavigation($AktuelleSeite, 0, 0));
$smarty->assign('Einstellungen',$GLOBALS['GlobaleEinstellungen']);

require_once(PFAD_INCLUDES."letzterInclude.php");
$smarty->display('wartung.tpl');
?>
