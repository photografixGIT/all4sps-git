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
$AktuelleSeite = "MEIN KONTO";

//session starten
$session = new Session();

//erstelle $smarty
require_once(PFAD_INCLUDES."smartyInlcude.php");

$Einstellungen = getEinstellungen(array(CONF_GLOBAL));

pruefeHttps();

if (strlen($_GET['uid'])==40)
{
	$status = $GLOBALS["DB"]->executeQuery("select kBestellung from tbestellstatus where dDatum>=date_sub(now(),INTERVAL 30 DAY) and cUID=\"".$GLOBALS["DB"]->escape($_GET['uid'])."\"",1);
	if (!$status->kBestellung)
	{
		header('Location: jtl.php');
		exit;
	}
	else
	{
		$bestellung = new Bestellung($status->kBestellung);
		$bestellung->fuelleBestellung();
		//$Kunde = $GLOBALS["DB"]->executeQuery("select * from tkunde where kKunde=".$bestellung->kKunde,1);
		//$Kunde->angezeigtesLand = ISO2land($Kunde->cLand);
        $Kunde = new Kunde($bestellung->kKunde);
		$smarty->assign('Bestellung', $bestellung);
		$smarty->assign('Kunde', $Kunde);
		$smarty->assign('Lieferadresse', $bestellung->Lieferadresse);
	}
}

$step='bestellung';
$Einstellungen = getEinstellungen(array(CONF_GLOBAL,CONF_RSS,CONF_KUNDEN,CONF_KAUFABWICKLUNG));
//hole alle OberKategorien
$AlleOberkategorien = new KategorieListe();
$AlleOberkategorien->getAllCategoriesOnLevel(0);
$AktuelleKategorie = new Kategorie(verifyGPCDataInteger("kategorie"));
$AufgeklappteKategorien = new KategorieListe();
$AufgeklappteKategorien->getOpenCategories($AktuelleKategorie);
$startKat = new Kategorie();
$startKat->kKategorie=0;

$hinweis;

//spezifische assigns
$smarty->assign('step',$step);
$smarty->assign('hinweis',$hinweis);
$smarty->assign('Navigation',createNavigation($AktuelleSeite));
$smarty->assign('requestURL',$requestURL);
$smarty->assign('Einstellungen',$Einstellungen);

require_once(PFAD_INCLUDES."letzterInclude.php");
$smarty->display('jtl.tpl');
?>