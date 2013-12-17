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
require_once(PFAD_ROOT . PFAD_INCLUDES . "bestellabschluss_inc.php");
require_once(PFAD_ROOT . PFAD_INCLUDES . "bestellvorgang_inc.php");
require_once(PFAD_ROOT . PFAD_INCLUDES . "mailTools.php");
$AktuelleSeite = "BESTELLVORGANG";
//session starten
$session = new Session();

//einstellungen holen
$Einstellungen = getEinstellungen(array(CONF_GLOBAL,CONF_RSS,CONF_KUNDEN,CONF_KAUFABWICKLUNG,CONF_ZAHLUNGSARTEN));

//erstelle $smarty
require_once(PFAD_INCLUDES."smartyInlcude.php");

$kBestellung = intval($_REQUEST['kBestellung']);
//abfragen, ob diese Bestellung dem Kunden auch gehört
$oBestellung = $GLOBALS["DB"]->executeQuery("select kKunde from tbestellung where kBestellung=".$kBestellung, 1);
if (!$oBestellung->kKunde || ($oBestellung->kKunde != $_SESSION["Kunde"]->kKunde))
{
	header('Location: jtl.php?'.SID);
	exit;
}

$bestellung = new Bestellung($kBestellung);
$bestellung->fuelleBestellung(0);
//$bestellung->machGoogleAnalyticsReady();

$bestellid = $GLOBALS["DB"]->executeQuery("select * from tbestellid where kBestellung=".$bestellung->kBestellung,1);
$successPaymentURL = URL_SHOP;
if ($bestellid->cId)
	$successPaymentURL = URL_SHOP.'/bestellabschluss.php?i='.$bestellid->cId;

//$GLOBALS["DB"]->executeQuery("update tbesucher set kKunde=".$_SESSION["Warenkorb"]->kKunde.", kBestellung=$bestellung->kBestellung where cIP=\"".gibIP()."\"",4);

$obj->tkunde = $_SESSION["Kunde"];
$obj->tbestellung = $bestellung;

$smarty->assign('Bestellung',$bestellung);

$oZahlungsInfo = new stdClass();
if(verifyGPCDataInteger('zusatzschritt') == 1)
{			
	$bZusatzangabenDa = false;
	switch($bestellung->Zahlungsart->cModulId)
	{
		case 'za_kreditkarte_jtl':
			if ($_POST['kreditkartennr'] &&
				$_POST['gueltigkeit'] &&
				$_POST['cvv'] &&
				$_POST['kartentyp'] &&
				$_POST['inhaber'])
			{
				$_SESSION["Zahlungsart"]->ZahlungsInfo->cKartenNr = StringHandler::htmlentities(stripslashes($_POST["kreditkartennr"]), ENT_QUOTES);
				$_SESSION["Zahlungsart"]->ZahlungsInfo->cGueltigkeit = StringHandler::htmlentities(stripslashes($_POST["gueltigkeit"]), ENT_QUOTES);
				$_SESSION["Zahlungsart"]->ZahlungsInfo->cCVV = StringHandler::htmlentities(stripslashes($_POST["cvv"]), ENT_QUOTES);
				$_SESSION["Zahlungsart"]->ZahlungsInfo->cKartenTyp = StringHandler::htmlentities(stripslashes($_POST["kartentyp"]), ENT_QUOTES);
				$_SESSION["Zahlungsart"]->ZahlungsInfo->cInhaber = StringHandler::htmlentities(stripslashes($_POST["inhaber"]), ENT_QUOTES);
				$bZusatzangabenDa = true;
			}
			break;
		case 'za_lastschrift_jtl':
			if (($_POST['bankname'] &&
				$_POST['blz'] &&
				$_POST['kontonr'] &&
				$_POST['inhaber'])
				||
				($_POST['bankname'] &&
				$_POST['iban'] &&
				$_POST['bic'] &&
				$_POST['inhaber'])
				)
			{
				$_SESSION["Zahlungsart"]->ZahlungsInfo->cBankName = StringHandler::htmlentities(stripslashes($_POST["bankname"]), ENT_QUOTES);
				$_SESSION["Zahlungsart"]->ZahlungsInfo->cKontoNr = StringHandler::htmlentities(stripslashes($_POST["kontonr"]), ENT_QUOTES);
				$_SESSION["Zahlungsart"]->ZahlungsInfo->cBLZ = StringHandler::htmlentities(stripslashes($_POST["blz"]), ENT_QUOTES);
				$_SESSION["Zahlungsart"]->ZahlungsInfo->cIBAN = StringHandler::htmlentities(stripslashes($_POST["iban"]), ENT_QUOTES);
				$_SESSION["Zahlungsart"]->ZahlungsInfo->cBIC = StringHandler::htmlentities(stripslashes($_POST["bic"]), ENT_QUOTES);
				$_SESSION["Zahlungsart"]->ZahlungsInfo->cInhaber = StringHandler::htmlentities(stripslashes($_POST["inhaber"]), ENT_QUOTES);
				$bZusatzangabenDa = true;
			}
			break;
	}
	
	if($bZusatzangabenDa)
	{
		if(saveZahlungsInfo($bestellung->kKunde, $bestellung->kBestellung))
		{
			$GLOBALS['DB']->executeQuery("UPDATE tbestellung
											SET cAbgeholt = 'N'
											WHERE kBestellung = " . $bestellung->kBestellung, 3);
			unset($_SESSION['Zahlungsart']);
			header("Location: " . $successPaymentURL);
			exit();
		}
	}
	else 
		$smarty->assign('ZahlungsInfo', gibPostZahlungsInfo());
}

// Zahlungsart als Plugin
$kPlugin = gibkPluginAuscModulId($bestellung->Zahlungsart->cModulId);
if($kPlugin > 0)
{
	$oPlugin = new Plugin($kPlugin);
	
	if($oPlugin->kPlugin > 0)
	{
		require_once(PFAD_ROOT . PFAD_PLUGIN . $oPlugin->cVerzeichnis . "/" . PFAD_PLUGIN_VERSION . $oPlugin->nVersion . "/" . PFAD_PLUGIN_PAYMENTMETHOD . $oPlugin->oPluginZahlungsKlasseAssoc_arr[$bestellung->Zahlungsart->cModulId]->cClassPfad);
		$paymentMethod = new $oPlugin->oPluginZahlungsKlasseAssoc_arr[$bestellung->Zahlungsart->cModulId]->cClassName($bestellung->Zahlungsart->cModulId);
		$paymentMethod->cModulId = $bestellung->Zahlungsart->cModulId;
		$paymentMethod->preparePaymentProcess($bestellung);
		$smarty->assign("oPlugin", $oPlugin);
	}
}
elseif ($bestellung->Zahlungsart->cModulId=="za_lastschrift_jtl")
{
	// Wenn Zahlungsart = Lastschrift ist => versuche Kundenkontodaten zu holen
	$oKundenKontodaten = gibKundenKontodaten($_SESSION['Kunde']->kKunde);
	if($oKundenKontodaten->kKunde > 0)
		$smarty->assign("oKundenKontodaten", $oKundenKontodaten);
}
elseif ($bestellung->Zahlungsart->cModulId=="za_paypal_jtl")
{
	require_once(PFAD_INCLUDES_MODULES."paypal/PayPal.class.php");
	$paymentMethod = new PayPal($bestellung->Zahlungsart->cModulId);
	$paymentMethod->cModulId = $bestellung->Zahlungsart->cModulId;
	$paymentMethod->preparePaymentProcess($bestellung);
}
elseif ($bestellung->Zahlungsart->cModulId=="za_worldpay_jtl")
{
	//require_once(PFAD_INCLUDES_MODULES."worldpay/worldpay.php");
	//$smarty->assign('worldpayform',gib_worldpay_form($bestellung, ($Einstellungen['zahlungsarten']['zahlungsart_worldpay_id']), ($Einstellungen['zahlungsarten']['zahlungsart_worldpay_modus'])));
	require_once(PFAD_INCLUDES_MODULES."worldpay/WorldPay.class.php");
	$paymentMethod = new WorldPay($bestellung->Zahlungsart->cModulId);
	$paymentMethod->cModulId = $bestellung->Zahlungsart->cModulId;
	$paymentMethod->preparePaymentProcess($bestellung);
}
elseif ($bestellung->Zahlungsart->cModulId=="za_moneybookers_jtl")
{
	require_once(PFAD_INCLUDES_MODULES."moneybookers/moneybookers.php");
	$smarty->assign('moneybookersform',gib_moneybookers_form($bestellung, strtolower($Einstellungen['zahlungsarten']['zahlungsart_moneybookers_empfaengermail']), $successPaymentURL));
}
elseif ($bestellung->Zahlungsart->cModulId=="za_ipayment_jtl")
{
	//require_once(PFAD_INCLUDES_MODULES."ipayment/ipayment.php");
	//$smarty->assign('ipaymentform',gib_ipayment_form($bestellung, strtolower($Einstellungen['zahlungsarten']['zahlungsart_ipayment_account_id']), ($Einstellungen['zahlungsarten']['zahlungsart_ipayment_trxuser_id']), $Einstellungen['zahlungsarten']['zahlungsart_ipayment_trxpassword'],$successPaymentURL));
	require_once(PFAD_INCLUDES_MODULES."ipayment/iPayment.class.php");
	$paymentMethod = new iPayment($bestellung->Zahlungsart->cModulId);
	$paymentMethod->cModulId = $bestellung->Zahlungsart->cModulId;
	$paymentMethod->preparePaymentProcess($bestellung);
}
elseif ($bestellung->Zahlungsart->cModulId=="za_sofortueberweisung_jtl")
{       
	//require_once(PFAD_INCLUDES_MODULES."sofortueberweisung/sofortueberweisung.php");
	//$smarty->assign('sofortueberweisungform',gib_sofortueberweisung_form($bestellung, ($Einstellungen['zahlungsarten']['zahlungsart_sofortueberweisung_id']), ($Einstellungen['zahlungsarten']['zahlungsart_sofortueberweisung_project_id'])));
	require_once(PFAD_INCLUDES_MODULES."sofortueberweisung/SofortUeberweisung.class.php");
	$paymentMethod = new SofortUeberweisung($bestellung->Zahlungsart->cModulId);
	$paymentMethod->cModulId = $bestellung->Zahlungsart->cModulId;
	$paymentMethod->preparePaymentProcess($bestellung);
}
elseif ($bestellung->Zahlungsart->cModulId=="za_ut_stand_jtl")
{   
	//require_once(PFAD_INCLUDES_MODULES."uos/uos_cc.php");
	//$smarty->assign('uos_cc_form',gib_uos_cc_form($obj->tkunde,$bestellung,$Einstellungen['zahlungsarten']['zahlungsart_uos_cc_secretkey'],$Einstellungen['zahlungsarten']['zahlungsart_uos_cc_projectid']));
	require_once(PFAD_INCLUDES_MODULES."ut/UT.class.php");
	$paymentMethod = new UT($bestellung->Zahlungsart->cModulId);
	$paymentMethod->cModulId = $bestellung->Zahlungsart->cModulId;
	$paymentMethod->preparePaymentProcess($bestellung);
}

elseif ($bestellung->Zahlungsart->cModulId=="za_ut_dd_jtl")
{   
	//require_once(PFAD_INCLUDES_MODULES."uos/uos_cc.php");
	//$smarty->assign('uos_cc_form',gib_uos_cc_form($obj->tkunde,$bestellung,$Einstellungen['zahlungsarten']['zahlungsart_uos_cc_secretkey'],$Einstellungen['zahlungsarten']['zahlungsart_uos_cc_projectid']));
	require_once(PFAD_INCLUDES_MODULES."ut/UT.class.php");
	$paymentMethod = new UT($bestellung->Zahlungsart->cModulId);
	$paymentMethod->cModulId = $bestellung->Zahlungsart->cModulId;
	$paymentMethod->preparePaymentProcess($bestellung);
}	
elseif ($bestellung->Zahlungsart->cModulId=="za_ut_cc_jtl")
{   
	//require_once(PFAD_INCLUDES_MODULES."uos/uos_cc.php");
	//$smarty->assign('uos_cc_form',gib_uos_cc_form($obj->tkunde,$bestellung,$Einstellungen['zahlungsarten']['zahlungsart_uos_cc_secretkey'],$Einstellungen['zahlungsarten']['zahlungsart_uos_cc_projectid']));
	require_once(PFAD_INCLUDES_MODULES."ut/UT.class.php");
	$paymentMethod = new UT($bestellung->Zahlungsart->cModulId);
	$paymentMethod->cModulId = $bestellung->Zahlungsart->cModulId;
	$paymentMethod->preparePaymentProcess($bestellung);
}	
elseif ($bestellung->Zahlungsart->cModulId=="za_ut_prepaid_jtl")
{
	//require_once(PFAD_INCLUDES_MODULES."uos/uos_cc.php");
	//$smarty->assign('uos_cc_form',gib_uos_cc_form($obj->tkunde,$bestellung,$Einstellungen['zahlungsarten']['zahlungsart_uos_cc_secretkey'],$Einstellungen['zahlungsarten']['zahlungsart_uos_cc_projectid']));
	require_once(PFAD_INCLUDES_MODULES."ut/UT.class.php");
	$paymentMethod = new UT($bestellung->Zahlungsart->cModulId);
	$paymentMethod->cModulId = $bestellung->Zahlungsart->cModulId;
	$paymentMethod->preparePaymentProcess($bestellung);
}	
elseif ($bestellung->Zahlungsart->cModulId=="za_ut_gi_jtl")
{   
	//require_once(PFAD_INCLUDES_MODULES."uos/uos_cc.php");
	//$smarty->assign('uos_cc_form',gib_uos_cc_form($obj->tkunde,$bestellung,$Einstellungen['zahlungsarten']['zahlungsart_uos_cc_secretkey'],$Einstellungen['zahlungsarten']['zahlungsart_uos_cc_projectid']));
	require_once(PFAD_INCLUDES_MODULES."ut/UT.class.php");
	$paymentMethod = new UT($bestellung->Zahlungsart->cModulId);
	$paymentMethod->cModulId = $bestellung->Zahlungsart->cModulId;
	$paymentMethod->preparePaymentProcess($bestellung);
}
elseif ($bestellung->Zahlungsart->cModulId=="za_ut_ebank_jtl")
{   
	//require_once(PFAD_INCLUDES_MODULES."uos/uos_cc.php");
	//$smarty->assign('uos_cc_form',gib_uos_cc_form($obj->tkunde,$bestellung,$Einstellungen['zahlungsarten']['zahlungsart_uos_cc_secretkey'],$Einstellungen['zahlungsarten']['zahlungsart_uos_cc_projectid']));
	require_once(PFAD_INCLUDES_MODULES."ut/UT.class.php");
	$paymentMethod = new UT($bestellung->Zahlungsart->cModulId);
	$paymentMethod->cModulId = $bestellung->Zahlungsart->cModulId;
	$paymentMethod->preparePaymentProcess($bestellung);	
}
elseif ($bestellung->Zahlungsart->cModulId=="za_uos_gi_self_jtl")
{   
	//require_once(PFAD_INCLUDES_MODULES."uos/uos_cc.php");
	//$smarty->assign('uos_cc_form',gib_uos_cc_form($obj->tkunde,$bestellung,$Einstellungen['zahlungsarten']['zahlungsart_uos_cc_secretkey'],$Einstellungen['zahlungsarten']['zahlungsart_uos_cc_projectid']));
	require_once(PFAD_INCLUDES_MODULES."uos/UOS.class.php");
	$paymentMethod = new UOS($bestellung->Zahlungsart->cModulId);
	$paymentMethod->cModulId = $bestellung->Zahlungsart->cModulId;
	$paymentMethod->preparePaymentProcess($bestellung);
}	
elseif ($bestellung->Zahlungsart->cModulId=="za_uos_invoice_jtl")
{   
	//require_once(PFAD_INCLUDES_MODULES."uos/uos_cc.php");
	//$smarty->assign('uos_cc_form',gib_uos_cc_form($obj->tkunde,$bestellung,$Einstellungen['zahlungsarten']['zahlungsart_uos_cc_secretkey'],$Einstellungen['zahlungsarten']['zahlungsart_uos_cc_projectid']));
	require_once(PFAD_INCLUDES_MODULES."uos/UOS.class.php");
	$paymentMethod = new UOS($bestellung->Zahlungsart->cModulId);
	$paymentMethod->cModulId = $bestellung->Zahlungsart->cModulId;
	$paymentMethod->preparePaymentProcess($bestellung);
}
elseif ($bestellung->Zahlungsart->cModulId=="za_uos_prepaid_jtl")
{   
	//require_once(PFAD_INCLUDES_MODULES."uos/uos_cc.php");
	//$smarty->assign('uos_cc_form',gib_uos_cc_form($obj->tkunde,$bestellung,$Einstellungen['zahlungsarten']['zahlungsart_uos_cc_secretkey'],$Einstellungen['zahlungsarten']['zahlungsart_uos_cc_projectid']));
	require_once(PFAD_INCLUDES_MODULES."uos/UOS.class.php");
	$paymentMethod = new UOS($bestellung->Zahlungsart->cModulId);
	$paymentMethod->cModulId = $bestellung->Zahlungsart->cModulId;
	$paymentMethod->preparePaymentProcess($bestellung);
}
elseif ($bestellung->Zahlungsart->cModulId=="za_uos_dd_self_jtl")
{   
	//require_once(PFAD_INCLUDES_MODULES."uos/uos_cc.php");
	//$smarty->assign('uos_cc_form',gib_uos_cc_form($obj->tkunde,$bestellung,$Einstellungen['zahlungsarten']['zahlungsart_uos_cc_secretkey'],$Einstellungen['zahlungsarten']['zahlungsart_uos_cc_projectid']));
	require_once(PFAD_INCLUDES_MODULES."uos/UOS.class.php");
	$paymentMethod = new UOS($bestellung->Zahlungsart->cModulId);
	$paymentMethod->cModulId = $bestellung->Zahlungsart->cModulId;
	$paymentMethod->preparePaymentProcess($bestellung);
}
elseif ($bestellung->Zahlungsart->cModulId=="za_uos_ebank_jtl")
{   
	//require_once(PFAD_INCLUDES_MODULES."uos/uos_cc.php");
	//$smarty->assign('uos_cc_form',gib_uos_cc_form($obj->tkunde,$bestellung,$Einstellungen['zahlungsarten']['zahlungsart_uos_cc_secretkey'],$Einstellungen['zahlungsarten']['zahlungsart_uos_cc_projectid']));
	require_once(PFAD_INCLUDES_MODULES."uos/UOS.class.php");
	$paymentMethod = new UOS($bestellung->Zahlungsart->cModulId);
	$paymentMethod->cModulId = $bestellung->Zahlungsart->cModulId;
	$paymentMethod->preparePaymentProcess($bestellung);
}
elseif ($bestellung->Zahlungsart->cModulId=="za_uos_ebank_direct_jtl")
{   
	//require_once(PFAD_INCLUDES_MODULES."uos/uos_cc.php");
	//$smarty->assign('uos_cc_form',gib_uos_cc_form($obj->tkunde,$bestellung,$Einstellungen['zahlungsarten']['zahlungsart_uos_cc_secretkey'],$Einstellungen['zahlungsarten']['zahlungsart_uos_cc_projectid']));
	require_once(PFAD_INCLUDES_MODULES."uos/UOS.class.php");
	$paymentMethod = new UOS($bestellung->Zahlungsart->cModulId);
	$paymentMethod->cModulId = $bestellung->Zahlungsart->cModulId;
	$paymentMethod->preparePaymentProcess($bestellung);
}
elseif ($bestellung->Zahlungsart->cModulId=="za_uos_cc_jtl")
{   
	//require_once(PFAD_INCLUDES_MODULES."uos/uos_cc.php");
	//$smarty->assign('uos_cc_form',gib_uos_cc_form($obj->tkunde,$bestellung,$Einstellungen['zahlungsarten']['zahlungsart_uos_cc_secretkey'],$Einstellungen['zahlungsarten']['zahlungsart_uos_cc_projectid']));
	require_once(PFAD_INCLUDES_MODULES."uos/UOS.class.php");
	$paymentMethod = new UOS($bestellung->Zahlungsart->cModulId);
	$paymentMethod->cModulId = $bestellung->Zahlungsart->cModulId;
	$paymentMethod->preparePaymentProcess($bestellung);
}
elseif ($bestellung->Zahlungsart->cModulId=="za_uos_dd_jtl")
{
	//require_once(PFAD_INCLUDES_MODULES."uos/uos_dd.php");
	//$smarty->assign('uos_dd_form',gib_uos_dd_form($obj->tkunde,$bestellung,$Einstellungen['zahlungsarten']['zahlungsart_uos_dd_secretkey'],$Einstellungen['zahlungsarten']['zahlungsart_uos_dd_projectid']));
	require_once(PFAD_INCLUDES_MODULES."uos/UOS.class.php");
	$paymentMethod = new UOS($bestellung->Zahlungsart->cModulId);
	$paymentMethod->cModulId = $bestellung->Zahlungsart->cModulId;
	$paymentMethod->preparePaymentProcess($bestellung);
}
elseif ($bestellung->Zahlungsart->cModulId=="za_uos_gi_jtl")
{
	require_once(PFAD_INCLUDES_MODULES."uos/UOS.class.php");
	$paymentMethod = new UOS($bestellung->Zahlungsart->cModulId);
	$paymentMethod->cModulId = $bestellung->Zahlungsart->cModulId;
	$paymentMethod->preparePaymentProcess($bestellung);
}
elseif ($bestellung->Zahlungsart->cModulId=="za_dresdnercetelem_jtl")
{
	require_once(PFAD_INCLUDES_MODULES."dresdnercetelem/DresdnerCetelem.class.php");
	$paymentMethod = new DresdnerCetelem($bestellung->Zahlungsart->cModulId);
	$paymentMethod->cModulId = $bestellung->Zahlungsart->cModulId;
	$paymentMethod->preparePaymentProcess($bestellung);
}
elseif ($bestellung->Zahlungsart->cModulId=="za_clickpay_dd_jtl")
{
	require_once(PFAD_INCLUDES_MODULES."clickpay/clickpay_dd.php");
	$smarty->assign('clickpay_dd_form',gib_clickpay_dd_form($obj->tkunde,$bestellung,$Einstellungen['zahlungsarten']['zahlungsart_clickpay_dd_merchantid'],$Einstellungen['zahlungsarten']['zahlungsart_clickpay_dd_secrethash']));
}
elseif ($bestellung->Zahlungsart->cModulId=="za_clickpay_cc_jtl")
{
	require_once(PFAD_INCLUDES_MODULES."clickpay/clickpay_cc.php");
	$smarty->assign('clickpay_cc_form',gib_clickpay_dd_form($obj->tkunde,$bestellung,$Einstellungen['zahlungsarten']['zahlungsart_clickpay_cc_merchantid'],$Einstellungen['zahlungsarten']['zahlungsart_clickpay_cc_secrethash']));
}
elseif ($bestellung->Zahlungsart->cModulId=="za_safetypay")
{	
	require_once(PFAD_INCLUDES_MODULES."safetypay/confirmation.php");
	$smarty->assign('safetypay_form', show_confirmation($bestellung));		
}
elseif ($bestellung->Zahlungsart->cModulId=="za_heidelpay_jtl")
{
	require_once(PFAD_INCLUDES_MODULES."heidelpay/HeidelPay.class.php");
	$paymentMethod = new HeidelPay($bestellung->Zahlungsart->cModulId);
	$paymentMethod->cModulId = $bestellung->Zahlungsart->cModulId;
	$paymentMethod->preparePaymentProcess($bestellung);
}
elseif ($bestellung->Zahlungsart->cModulId=="za_wirecard_jtl")
{
	require_once(PFAD_INCLUDES_MODULES."wirecard/Wirecard.class.php");
	$paymentMethod = new Wirecard($bestellung->Zahlungsart->cModulId);
	$paymentMethod->cModulId = $bestellung->Zahlungsart->cModulId;
	$paymentMethod->preparePaymentProcess($bestellung);
}
elseif ($bestellung->Zahlungsart->cModulId=="za_postfinance_jtl")
{
	require_once(PFAD_INCLUDES_MODULES."postfinance/PostFinance.class.php");
	$paymentMethod = new PostFinance($bestellung->Zahlungsart->cModulId);
	$paymentMethod->cModulId = $bestellung->Zahlungsart->cModulId;
	$paymentMethod->preparePaymentProcess($bestellung);
}
elseif ($bestellung->Zahlungsart->cModulId=="za_iclear_jtl")
{
	require_once(PFAD_INCLUDES_MODULES."iclear/IClear.class.php");
	$paymentMethod = new IClear($bestellung->Zahlungsart->cModulId);
	$paymentMethod->cModulId = $bestellung->Zahlungsart->cModulId;
	$paymentMethod->preparePaymentProcess($bestellung);
}
elseif ($bestellung->Zahlungsart->cModulId=="za_paymentpartner_jtl")
{
	require_once(PFAD_INCLUDES_MODULES."paymentpartner/PaymentPartner.class.php");
	$paymentMethod = new PaymentPartner($bestellung->Zahlungsart->cModulId);
	$paymentMethod->cModulId = $bestellung->Zahlungsart->cModulId;
	$paymentMethod->preparePaymentProcess($bestellung);
}
elseif ($bestellung->Zahlungsart->cModulId=="za_saferpay_jtl")
{
	require_once(PFAD_INCLUDES_MODULES."saferpay/Saferpay.class.php");
	$paymentMethod = new SaferPay($bestellung->Zahlungsart->cModulId);
	$paymentMethod->cModulId = $bestellung->Zahlungsart->cModulId;
	$paymentMethod->preparePaymentProcess($bestellung);
}
elseif ($bestellung->Zahlungsart->cModulId=="za_clickandbuy_jtl")
{
	require_once(PFAD_INCLUDES_MODULES."clickandbuy/ClickandBuy.class.php");
	$paymentMethod = new ClickandBuy($bestellung->Zahlungsart->cModulId);
	$paymentMethod->cModulId = $bestellung->Zahlungsart->cModulId;
	$paymentMethod->preparePaymentProcess($bestellung);
}	
elseif (substr($bestellung->Zahlungsart->cModulId, 0, 8) == 'za_mbqc_')	
{
	require_once(PFAD_INCLUDES_MODULES."moneybookers_qc/MoneyBookersQC.class.php");
	$paymentMethod = new MoneyBookersQC($bestellung->Zahlungsart->cModulId);
	$paymentMethod->cModulId = $bestellung->Zahlungsart->cModulId;
	$paymentMethod->preparePaymentProcess($bestellung);
}
elseif ($bestellung->Zahlungsart->cModulId=="za_eos_jtl")
{
	require_once(PFAD_INCLUDES_MODULES."eos/EOS.class.php");
	$paymentMethod = new EOS($bestellung->Zahlungsart->cModulId);
	$paymentMethod->cModulId = $bestellung->Zahlungsart->cModulId;
	$paymentMethod->preparePaymentProcess($bestellung);
}

// EOS Payment Solution
elseif ($bestellung->Zahlungsart->cModulId=="za_eos_dd_jtl")    
{
	require_once(PFAD_ROOT . PFAD_INCLUDES_MODULES."eos/EOS.class.php");
	$paymentMethod = new EOS($bestellung->Zahlungsart->cModulId);
	$paymentMethod->cModulId = $bestellung->Zahlungsart->cModulId;
	$paymentMethod->preparePaymentProcess($bestellung);
}
elseif ($bestellung->Zahlungsart->cModulId=="za_eos_cc_jtl")    
{
	require_once(PFAD_ROOT . PFAD_INCLUDES_MODULES."eos/EOS.class.php");
	$paymentMethod = new EOS($bestellung->Zahlungsart->cModulId);
	$paymentMethod->cModulId = $bestellung->Zahlungsart->cModulId;
	$paymentMethod->preparePaymentProcess($bestellung);
}
elseif ($bestellung->Zahlungsart->cModulId=="za_eos_direct_jtl")    
{
	require_once(PFAD_ROOT . PFAD_INCLUDES_MODULES."eos/EOS.class.php");
	$paymentMethod = new EOS($bestellung->Zahlungsart->cModulId);
	$paymentMethod->cModulId = $bestellung->Zahlungsart->cModulId;
	$paymentMethod->preparePaymentProcess($bestellung);
}
elseif ($bestellung->Zahlungsart->cModulId=="za_eos_ewallet_jtl")    
{
	require_once(PFAD_ROOT . PFAD_INCLUDES_MODULES."eos/EOS.class.php");
	$paymentMethod = new EOS($bestellung->Zahlungsart->cModulId);
	$paymentMethod->cModulId = $bestellung->Zahlungsart->cModulId;
	$paymentMethod->preparePaymentProcess($bestellung);
}

//hole aktuelle Kategorie, falls eine gesetzt
$AktuelleKategorie = new Kategorie(verifyGPCDataInteger("kategorie"));
$AufgeklappteKategorien = new KategorieListe();
$AufgeklappteKategorien->getOpenCategories($AktuelleKategorie);
$startKat = new Kategorie();
$startKat->kKategorie=0;

$smarty->assign('Navigation',createNavigation($AktuelleSeite));
$smarty->assign('Firma',$GLOBALS["DB"]->executeQuery("select * from tfirma",1));
$smarty->assign('WarensummeLocalized', $_SESSION["Warenkorb"]->gibGesamtsummeWarenLocalized());
$smarty->assign('Einstellungen',$Einstellungen);
$smarty->assign('Bestellung',$bestellung);

//$_SESSION["Warenkorb"] = new Warenkorb();
unset($_SESSION['Zahlungsart']);
unset($_SESSION['Versandart']);
unset($_SESSION['Lieferadresse']);
unset($_SESSION['VersandKupon']);
unset($_SESSION['NeukundenKupon']);
unset($_SESSION['Kupon']);

require_once(PFAD_INCLUDES."letzterInclude.php");
$smarty->display('bestellabschluss.tpl');

function UOSErrorMapping()
{
    global $smarty;
    
	$cParams_arr = array();
	if(isset($_GET['params']) && strlen($_GET['params']) > 0)
		parse_str(base64_decode($_GET['params']), $cParams_arr);
	
    if(intval($_GET['fail']) == 1)
    {        	
        switch(intval($cParams_arr["code_1"]))
        {
            case 1:
                $cFehler = sprintf($GLOBALS['oSprache']->gibWert('uos1', 'errorMessages'), $cParams_arr["msg_1"] . " (" . $cParams_arr["param_1"] . ")");
                break;
            case 2:
                $cFehler = sprintf($GLOBALS['oSprache']->gibWert('uos2', 'errorMessages'), $cParams_arr["msg_1"] . " (" . $cParams_arr["param_1"] . ")");   
                break;
            case 3:
                $cFehler = sprintf($GLOBALS['oSprache']->gibWert('uos3', 'errorMessages'), $cParams_arr["msg_1"] . " (" . $cParams_arr["param_1"] . ")");
                break;
        }
        
        $smarty->assign("cFehler", $cFehler);

		return true;
    }
	
	return false;
}
?>
