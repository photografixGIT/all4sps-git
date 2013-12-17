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
require_once(PFAD_ROOT . PFAD_INCLUDES . "wunschliste_inc.php");
$AktuelleSeite = "WUNSCHLISTE";

//session starten
$session = new Session();

//erstelle $smarty
require_once(PFAD_ROOT . PFAD_INCLUDES . "smartyInlcude.php");

//setze seitentyp
setzeSeitenTyp(PAGE_WUNSCHLISTE);

$cURLID = filterXSS(verifyGPDataString('wlid'));

$Einstellungen = getEinstellungen(array(CONF_GLOBAL,CONF_RSS));

loeseHttps();

//hole alle OberKategorien
$AlleOberkategorien = new KategorieListe();
$AlleOberkategorien->getAllCategoriesOnLevel(0);
$AktuelleKategorie = new Kategorie(verifyGPCDataInteger("kategorie"));
$AufgeklappteKategorien = new KategorieListe();
$AufgeklappteKategorien->getOpenCategories($AktuelleKategorie);
$startKat = new Kategorie();
$startKat->kKategorie=0;

// Hinweise
$cHinweis = "";
if(verifyGPCDataInteger('wlidmsg') > 0)
    $cHinweis = mappeWunschlisteMSG(verifyGPCDataInteger('wlidmsg'));

// Falls Wunschliste vielleicht vorhanden aber nicht öffentlich
if(verifyGPCDataInteger("error") == 1)
{
	if(strlen($cURLID) > 0)
	{
		$oWunschliste = $GLOBALS['DB']->executeQuery("SELECT kWunschliste, nOeffentlich
														FROM twunschliste
														WHERE cURLID='" . $cURLID . "'", 1);

		if($oWunschliste->kWunschliste > 0 && $oWunschliste->nOeffentlich > 0)
		{
			$smarty->assign("cFehler", sprintf($GLOBALS['oSprache']->gibWert('nowlidWishlist', 'messages'), $cURLID));
		}
		else
			$smarty->assign("cFehler", sprintf($GLOBALS['oSprache']->gibWert('nowlidWishlist', 'messages'), $cURLID));
	}
	else
		$smarty->assign("cFehler", sprintf($GLOBALS['oSprache']->gibWert('nowlidWishlist', 'messages'), $cURLID));
}
//falls keine Wunschliste vorhanden, zurück zum Shop
else if (!$kWunschliste)
{
	header('Location: index.php?'.SID);
	exit;
}

//url
$requestURL = baueURL($Link,URLART_SEITE);
$sprachURL = baueSprachURLS($Link,URLART_SEITE);

// Wunschliste aufbauen und cPreis setzen (Artikelanzahl mit eingerechnet)
$CWunschliste = bauecPreis(new Wunschliste($kWunschliste));

// Kampagne Öffentlicher Wunschzettel
if(isset($CWunschliste->kWunschliste) && $CWunschliste->kWunschliste > 0)
{
	$oKampagne = new Kampagne(KAMPAGNE_INTERN_OEFFENTL_WUNSCHZETTEL);

	if(isset($oKampagne->kKampagne) && isset($oKampagne->cWert) && strtolower($oKampagne->cWert) == strtolower(verifyGPDataString($oKampagne->cParameter)))
	{
		$oKampagnenVorgang = new stdClass();
		$oKampagnenVorgang->kKampagne 		= $oKampagne->kKampagne;
		$oKampagnenVorgang->kKampagneDef 	= KAMPAGNE_DEF_HIT;
		$oKampagnenVorgang->kKey 			= $_SESSION['oBesucher']->kBesucher;
		$oKampagnenVorgang->fWert 			= 1.0;
		$oKampagnenVorgang->cParamWert 		= $oKampagne->cWert;
		$oKampagnenVorgang->dErstellt		= "now()";

		$GLOBALS['DB']->insertRow("tkampagnevorgang", $oKampagnenVorgang);

		// Kampagnenbesucher in die Session
		$_SESSION['Kampagnenbesucher'] = new stdClass();
		$_SESSION['Kampagnenbesucher'] = $oKampagne;
	}
}

//spezifische assigns
$smarty->assign("CWunschliste", $CWunschliste);
$smarty->assign('Navigation',createNavigation($AktuelleSeite, 0, 0, $GLOBALS['oSprache']->gibWert('wishlist', 'breadcrumb'), "index.php?wlid=" . $cURLID . "&" . SID));
$smarty->assign('Einstellungen',$GLOBALS['GlobaleEinstellungen']);
$smarty->assign('cURLID', $cURLID);
$smarty->assign("cHinweis", $cHinweis);

require_once(PFAD_ROOT . PFAD_INCLUDES . "letzterInclude.php");

$smarty->display('wunschliste.tpl');
?>
