<?php 
/**
 * copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 *
 * this file may not be redistributed in whole or significant part
 * and is subject to the JTL-Software-GmbH license.
 *
 * license: http://jtl-software.de/jtlshop3license.html
 */

require_once(dirname(__FILE__) . "/includes/globalinclude.php");
require_once(PFAD_ROOT . PFAD_CLASSES_CORE . "class.core.Nice.php");

$AktuelleSeite = "WARENRUECKSENDUNG";

//session starten
$session = new Session();

//erstelle $smarty
require_once(PFAD_ROOT . PFAD_INCLUDES . "smartyInlcude.php");

$Einstellungen = getEinstellungen(array(CONF_GLOBAL, CONF_RSS, CONF_RMA));

loeseHttps();

//setze seitentyp
setzeSeitenTyp(PAGE_RMA);

$kLink = gibLinkKeySpecialSeite(LINKTYP_RMA);
$cCanonicalURL = "";
$cFehler = "";
$cHinweis = "";

//hole alle OberKategorien
$AlleOberkategorien = new KategorieListe();
$AlleOberkategorien->getAllCategoriesOnLevel(0);
$AktuelleKategorie = new Kategorie(verifyGPCDataInteger("kategorie"));
$AufgeklappteKategorien = new KategorieListe();
$AufgeklappteKategorien->getOpenCategories($AktuelleKategorie);
$startKat = new Kategorie();
$startKat->kKategorie=0;

$cStep = "rma_overview";

$oNice = Nice::getInstance();
if($oNice->checkErweiterung(SHOP_ERWEITERUNG_RMA))
{
	require_once(PFAD_ROOT . PFAD_INCLUDES_EXT . "class.JTL-Shop.RMA.php");
	
	//$cStep = "rma_success";
	$oBesucher_arr = array();
	
	// Customer logged in?
	if(isset($_SESSION['Kunde']) && $_SESSION['Kunde']->kKunde > 0)
	{
		// ***********
		// * ACTIONS *	
		// ***********	
		
		$cAction = verifyGPDataString("a");
		switch($cAction)
		{
			// Choose product
			case "chooseProduct":
				$cStep = "rma_choose";
				break;
				
			// Submit RMA
			case "submitRMA":
				if(!is_array($_POST['kArtikel_arr']) || count($_POST['kArtikel_arr']) == 0)
				{
					$cHinweis = $GLOBALS['oSprache']->gibWert('rma_error', 'rma') . ": " . $GLOBALS['oSprache']->gibWert('rma_error_noarticle', 'rma');
					$cStep = "rma_choose";
				}				
				elseif(!RMA::isRMAAlreadySend($_SESSION['Kunde']->kKunde, verifyGPCDataInteger("kBestellung"), $_POST['kArtikel_arr'], RMA::checkPostVars($_POST)))
				{
					// Plausi
					$cPlausi_arr = RMA::checkPlausi(verifyGPCDataInteger("kBestellung"), $_POST['kArtikel_arr'], RMA::checkPostVars($_POST));
					
					if(count($cPlausi_arr) == 0)
					{
						$oReturn = RMA::insert($_SESSION['Kunde']->kKunde, verifyGPCDataInteger("kBestellung"), $_POST['kArtikel_arr'], RMA::checkPostVars($_POST), $_SESSION['kSprache']);
						if($oReturn !== false && isset($oReturn->kRMA) && $oReturn->kRMA > 0)
						{
							$cHinweis = sprintf($GLOBALS['oSprache']->gibWert('rma_info_success', 'rma'), $oReturn->cRMA);
							$cStep = "rma_success";
							
							// Email an Kunde
							RMA::sendSuccessEmail($oReturn->kRMA, $_SESSION['Kunde']->kKunde);
							$smarty->assign("oRMA", new RMA($oReturn->kRMA, true, true, $_SESSION['kSprache']));
						}
					}
					else 
					{
						$smarty->assign("cPlausi_arr", $cPlausi_arr);
						$_POST['kArtikelAssoc_arr'] = RMA::getArtikelAssocArray($_POST['kArtikel_arr']);
						$smarty->assign("cPost_arr", $_POST);
						$cFehler = $GLOBALS['oSprache']->gibWert('rma_error', 'rma') . ": " . $GLOBALS['oSprache']->gibWert('rma_error_required', 'rma');
						if(isset($cPlausi_arr[0]['fAnzahl']) && $cPlausi_arr[0]['fAnzahl'] == 1)
							$cFehler .= "<br />" . $GLOBALS['oSprache']->gibWert('rma_error_validquantity', 'rma');
						$cStep = "rma_choose";
					}
				}
				else 
					$cFehler = $GLOBALS['oSprache']->gibWert('rma_error', 'rma') . ": " . $GLOBALS['oSprache']->gibWert('rma_error_alreadysend', 'rma');
				break;
				
			// Change time
			case "changePeriodOfTime":
				RMA::setTimePeriod(verifyGPCDataInteger("nRMAYear"));
				break;
		}
		
		// *********
		// * STEPS *
		// *********		
		
		switch($cStep)
		{
			// Overview
			case "rma_overview":
				if(!isset($_SESSION['RMA_TimePeriod']))
					RMA::setTimePeriod();
					
				$smarty->assign("nRMAYear_arr", RMA::getFirstOrderTillNow());
				$smarty->assign("oBestellung_arr", RMA::getCustomerOrders());
				break;
				
			// Choose products from order
			case "rma_choose":
				$smarty->assign("oBestellung", RMA::getOrderProducts(verifyGPCDataInteger("kBestellung")));
				$smarty->assign("oRMAGrund_arr", RMAGrund::getAll($_SESSION['kSprache'], true));
				break;
		}
	}

	$smarty->assign("oLink", RMA::findCMSLinkInSession($kLink));
}

// Canonical
$cCanonicalURL = URL_SHOP . "/rma.php";

// Assign step
$smarty->assign("cStep", $cStep);
$smarty->assign("cHinweis", $cHinweis);
$smarty->assign("cFehler", $cFehler);
$smarty->assign("Einstellungen", $Einstellungen);

require_once(PFAD_ROOT . PFAD_INCLUDES . "letzterInclude.php");

$smarty->display('rma.tpl');
?>