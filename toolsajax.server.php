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
$session = new Session();
require_once(PFAD_ROOT . PFAD_INCLUDES . "smartyInlcude.php");
require_once("toolsajax.common.php");

$cAktuelleSeite = substr(strrchr($_SERVER['HTTP_REFERER'], "/"), 1, strlen(strrchr($_SERVER['HTTP_REFERER'], "/")));
if($cAktuelleSeite == "ajaxcheckout.php?" || $cAktuelleSeite == "warenkorb.php?" || substr(strrchr($_SERVER['PHP_SELF'], "/"), 1, strlen(strrchr($_SERVER['PHP_SELF'], "/"))) == "ajaxcheckout.php")
{
	$Einstellungen = getEinstellungen(array(CONF_GLOBAL,CONF_NAVIGATIONSFILTER,CONF_RSS,CONF_KUNDEN,CONF_KAUFABWICKLUNG,CONF_KUNDENFELD,CONF_KUNDENWERBENKUNDEN,CONF_TRUSTEDSHOPS,CONF_AUSWAHLASSISTENT,CONF_METAANGABEN));
	$GlobaleEinstellungen = $Einstellungen['global'];
}

function gibFinanzierungInfo($kArtikel, $fPreis)
{
   global $smarty;   
   require_once(PFAD_ROOT . PFAD_INCLUDES_EXT . 'finanzierung_inc.php');
   
   $oArtikel = new stdClass;
   $objResponse = new xajaxResponse();
   $oArtikel->Preise = new stdClass;
   
   $oArtikel->kArtikel = $kArtikel;
   $oArtikel->Preise->fVK = array($fPreis);
   
   gibFinanzierung($oArtikel);
   
   if (isset($oArtikel->oRateMin))
   {
      $smarty->assign('Artikel', $oArtikel);
      $smarty->assign('Einstellungen', getEinstellungen(array(CONF_ARTIKELDETAILS)));
      
      $cText = $smarty->fetch('tpl_inc/artikel_finanzierung.tpl');
      $cTable = $smarty->fetch('tpl_inc/artikel_finanzierung_popup.tpl');
   
      $objResponse->assign("commerz_financing", "innerHTML", $cText);
      $objResponse->assign("popupf" . $kArtikel, "innerHTML", $cTable);
   }
   
   $objResponse->assign("commerz_financing", "style.display", isset($oArtikel->oRateMin) ? "block" : "none");
   return $objResponse;
}

function billpayRates()
{
	global $smarty;
	require_once(PFAD_ROOT . PFAD_INCLUDES_MODULES . 'PaymentMethod.class.php');

	$oAjax = new xajaxResponse();
	$oResponse = new stdClass;
	$oResponse->nType = 0;

	$oBillpay = PaymentMethod::create('za_billpay_jtl');
	if ($oBillpay)
	{
		$oRates = $oBillpay->calculateRates($_SESSION['Warenkorb']);
		if (is_object($oRates))
		{
			$oResponse->nType = 2;
			$oResponse->cRateHTML_arr = array();
			$oResponse->nRates_arr = $oRates->nAvailable_arr;

         // special link
         $cPortalHash = md5($oBillpay->getSetting('pid'));
         $cBillpayTermsURL = BILLPAY_TERMS_RATE;
         $cBillpayTermsURL = str_replace('%pidhash%', $cPortalHash, $cBillpayTermsURL);

			foreach ($oRates->aRates_arr as $oRate)
			{
				// rate
				$smarty->assign('oRate', $oRate);
				$smarty->assign('nRate_arr', $oRates->nAvailable_arr);

				// links
				$smarty->assign('cBillpayTermsURL', $cBillpayTermsURL);
				$smarty->assign('cBillpayPrivacyURL', BILLPAY_PRIVACY);
				$smarty->assign('cBillpayTermsPaymentURL', BILLPAY_TERMS_PAYMENT);

				$oResponse->cRateHTML_arr[$oRate->nRate] = utf8_encode($smarty->fetch('tpl_inc/modules/billpay/raten.tpl'));
			}
		}
		else
		{
			$oResponse->nType = 1;
		}
	}

	$oAjax->script("this.response = " . json_encode($oResponse) . ";");
	return $oAjax;
}

function gibVergleichsliste($nVLKeys = 0, $bWarenkorb = true)
{
	global $smarty;
	require_once("includes/vergleichsliste_inc.php");

	$objResponse = new xajaxResponse();

	//session starten
	$session = new Session();

	$Einstellungen_Vergleichsliste = getEinstellungen(array(CONF_VERGLEICHSLISTE,CONF_ARTIKELDETAILS));

	//url
	$requestURL = baueURL($Link,URLART_SEITE);
	$sprachURL = baueSprachURLS($Link,URLART_SEITE);

	$oVergleichsliste = new Vergleichsliste();

	// Falls $nVLKeys 1 ist, nimm die kArtikel von $_SESSION['nArtikelUebersichtVLKey_arr'] und baue eine neue TMP Vergleichsliste
	if($nVLKeys == 1 && isset($_SESSION['nArtikelUebersichtVLKey_arr']) && is_array($_SESSION['nArtikelUebersichtVLKey_arr']) && count($_SESSION['nArtikelUebersichtVLKey_arr']) > 0)
	{
		$oVergleichsliste->oArtikel_arr = array();

		foreach($_SESSION['nArtikelUebersichtVLKey_arr'] as $nArtikelUebersichtVLKey)
			$oVergleichsliste->fuegeEin($nArtikelUebersichtVLKey, false);

		// Laufe erneut die fertigen Artikel durch lösche Vaterartikel von der Vergleichsliste, da diese nicht verglichen werden dürfen
		/*
		if(count($oVergleichsliste->oArtikel_arr) > 0)
		{
			$nCount = count($oVergleichsliste->oArtikel_arr);
			for($i = 0; $i < $nCount; $i++)
			{
				if($oVergleichsliste->oArtikel_arr[$i]->nIstVater == 1)
					unset($oVergleichsliste->oArtikel_arr[$i]);
			}

			$oVergleichsliste->oArtikel_arr = array_merge($oVergleichsliste->oArtikel_arr);
		}
		*/
	}
   elseif ($nVLKeys != 0 && strlen($nVLKeys) > 0)
   {
      $nVLKey_arr = explode(';', $nVLKeys);
      if (is_array($nVLKey_arr))
      {
         for ($i = 0; $i < count($nVLKey_arr); $i+=2)
         {
            $oVergleichsliste->fuegeEin($nVLKey_arr[$i], false, $nVLKey_arr[$i+1]);
         }
      }
   }

	$oMerkVaria_arr = baueMerkmalundVariation($oVergleichsliste);

	// Füge den Vergleich für Statistikzwecke in die DB ein
	setzeVergleich($oVergleichsliste);

	$cExclude = array();
	for($i=0; $i<8; $i++)
	{
		$cElement = gibMaxPrioSpalteV($cExclude, $Einstellungen_Vergleichsliste);
		if(strlen($cElement) > 1)
		{
			array_push($cExclude, $cElement);
		}
	}

	// Spaltenbreite
	$nBreiteAttribut = 100;
	if(intval($Einstellungen_Vergleichsliste['vergleichsliste']['vergleichsliste_spaltengroesseattribut']) > 0)
		$nBreiteAttribut = intval($Einstellungen_Vergleichsliste['vergleichsliste']['vergleichsliste_spaltengroesseattribut']);

	$nBreiteArtikel = 200;
	if(intval($Einstellungen_Vergleichsliste['vergleichsliste']['vergleichsliste_spaltengroesse']) > 0)
		$nBreiteArtikel = intval($Einstellungen_Vergleichsliste['vergleichsliste']['vergleichsliste_spaltengroesse']);

	$nBreiteTabelle = $nBreiteArtikel * count($oVergleichsliste->oArtikel_arr) + $nBreiteAttribut;

	//spezifische assigns
	$smarty->assign('nBreiteTabelle', $nBreiteTabelle);
	$smarty->assign('cPrioSpalten_arr', $cExclude);
	$smarty->assign('oMerkmale_arr', $oMerkVaria_arr[0]);
	$smarty->assign('oVariationen_arr', $oMerkVaria_arr[1]);
	$smarty->assign('oVergleichsliste', $oVergleichsliste);
	$smarty->assign('Navigation',createNavigation($AktuelleSeite, 0, 0));
	$smarty->assign('Einstellungen',$GLOBALS['GlobaleEinstellungen']);
	$smarty->assign('Einstellungen_Vergleichsliste', $Einstellungen_Vergleichsliste);
	$smarty->assign("NettoPreise", $_SESSION['Kundengruppe']->nNettoPreise);
	$smarty->assign('bAjax', true);
   $smarty->assign('bWarenkorb', $bWarenkorb);

	// Hook
	executeHook(HOOK_VERGLEICHSLISTE_PAGE);

	$cHTML = $smarty->fetch('vergleichsliste.tpl');
	$cHTML = utf8_encode($cHTML); // FIX!!!
	$cHTML = json_encode($cHTML);

	//$objResponse->assign('compare_list_wrapper_ajax', 'innerHTML', $cHTML);

	$objResponse->script("this.compareHTML = ".$cHTML.";");

	return $objResponse;
}

function ermittleVersandkostenAjax($oArtikel_arr)
{
	$objResponse = new xajaxResponse();

	$oResponse = new stdClass();
	$oResponse->cText = utf8_encode(ermittleVersandkostenExt($oArtikel_arr));
	$oResponse->cText .= ' (' . $_SESSION['shipping_count']++ . ')';
	$objResponse->script("this.response = " . json_encode($oResponse).";");

	return $objResponse;
}

function loescheWarenkorbPosAjax($nPos)
{
   $objResponse = new xajaxResponse();
   require_once("classes/class.JTL-Shop.Artikel.php");

	//wurden Positionen gelöscht?
	if ($_SESSION["Warenkorb"]->PositionenArr[intval($nPos)]->nPosTyp == 1)
	{
		unset($_SESSION["Warenkorb"]->PositionenArr[intval($nPos)]);
		$_SESSION["Warenkorb"]->PositionenArr = array_merge($_SESSION["Warenkorb"]->PositionenArr);
		loescheAlleSpezialPos();

		if(!$_SESSION["Warenkorb"]->enthaltenSpezialPos(C_WARENKORBPOS_TYP_ARTIKEL))
			$_SESSION["Warenkorb"] = new Warenkorb();

		// Lösche Position aus dem WarenkorbPersPos
		if($_SESSION['Kunde']->kKunde > 0)
		{
			$oWarenkorbPers = new WarenkorbPers($_SESSION['Kunde']->kKunde);
			$oWarenkorbPers->entferneAlles();
			$oWarenkorbPers->bauePersVonSession();
		}
	}

   return $objResponse;
}

function fuegeEinInWarenkorbAjax($kArtikel, $anzahl, $oEigenschaftwerte_arr = "")
{
   global $Einstellungen, $Kunde, $smarty;

   require_once("classes/class.JTL-Shop.Artikel.php");
	require_once("classes/class.JTL-Shop.Sprache.php");

	require_once('includes/boxen.php');
	require_once('includes/artikel_inc.php');
	require_once('includes/sprachfunktionen.php');

   $oResponse = new stdClass;
   $objResponse = new xajaxResponse();

	$GLOBALS['oSprache'] = new Sprache(false);
	$GLOBALS['oSprache']->autoload();

   $kArtikel = intval($kArtikel);
	if ($anzahl>0 && $kArtikel>0)
	{
		$redirectParam = array();
		$Artikel = new Artikel();
		unset($oArtikelOptionen);
		$oArtikelOptionen->nMerkmale = 0;
		$oArtikelOptionen->nAttribute = 0;
		$oArtikelOptionen->nArtikelAttribute = 0;
        $oArtikelOptionen->nDownload = 1;
		$Artikel->fuelleArtikel($kArtikel, $oArtikelOptionen);
		$Artikel->holArtikelAttribute();

		// Falls der Artikel ein Variationskombikind ist, hole direkt seine Eigenschaften
		if(isset($Artikel->kEigenschaftKombi) && $Artikel->kEigenschaftKombi > 0)
			$oEigenschaftwerte_arr = gibVarKombiEigenschaftsWerte($Artikel->kArtikel);

      if (intval($anzahl)!=$anzahl && $Artikel->cTeilbar!="Y")
         $anzahl = max(intval($anzahl), 1);

      // Prüfung
      $redirectParam = pruefeFuegeEinInWarenkorb($Artikel, $anzahl, $oEigenschaftwerte_arr);

      if (count($redirectParam)>0)
      {
			/*
         if(isset($_SESSION['variBoxAnzahl_arr']))
         {
            $oResponse->nType = 0;
            $oResponse->cNachricht = "Weiterleitung erfolgt";
            $objResponse->script("this.response = ".json_encode($oResponse).";");
            return $objResponse;
         }
			*/

         $add = "&".SID;
         $location = "";

			$cRedirectParam = implode(',', $redirectParam);
			baueArtikelhinweise($cRedirectParam);

			$smarty->assign('cHinweis_arr', $GLOBALS['Artikelhinweise']);
			$oResponse->cPopup = utf8_encode($smarty->fetch('tpl_inc/artikel_weiterleitung.tpl'));

         //redirekt zum artikel, um variation/en zu wählen / MBM beachten
         if($Artikel->nIstVater == 1)
            $location = 'navi.php?a='.$Artikel->kArtikel."&n=".$anzahl."&r=".implode(",",$redirectParam).$add;
         else if($Artikel->kEigenschaftKombi > 0)
            $location = 'navi.php?a=' . $Artikel->kVaterArtikel . '&a2='.$Artikel->kArtikel."&n=".$anzahl."&r=".implode(",",$redirectParam).$add;
         else
            $location = 'index.php?a='.$Artikel->kArtikel."&n=".$anzahl."&r=".implode(",",$redirectParam).$add;

         $oResponse->nType = 1;
         $oResponse->cLocation = $location;
			$oResponse->oArtikel = $Artikel;
         $objResponse->script("this.response = ".json_encode($oResponse).";");
         return $objResponse;
		}

		$_SESSION["Warenkorb"]->fuegeEin($kArtikel, $anzahl, $oEigenschaftwerte_arr);
		$_SESSION['Warenkorb']->loescheSpezialPos(C_WARENKORBPOS_TYP_VERSANDPOS);
		$_SESSION['Warenkorb']->loescheSpezialPos(C_WARENKORBPOS_TYP_VERSANDZUSCHLAG);
		$_SESSION['Warenkorb']->loescheSpezialPos(C_WARENKORBPOS_TYP_VERSAND_ARTIKELABHAENGIG);
		$_SESSION['Warenkorb']->loescheSpezialPos(C_WARENKORBPOS_TYP_ZAHLUNGSART);
		$_SESSION['Warenkorb']->loescheSpezialPos(C_WARENKORBPOS_TYP_ZINSAUFSCHLAG);
		$_SESSION['Warenkorb']->loescheSpezialPos(C_WARENKORBPOS_TYP_BEARBEITUNGSGEBUEHR);
		$_SESSION['Warenkorb']->loescheSpezialPos(C_WARENKORBPOS_TYP_NEUKUNDENKUPON);
		$_SESSION['Warenkorb']->loescheSpezialPos(C_WARENKORBPOS_TYP_NACHNAHMEGEBUEHR);
		$_SESSION['Warenkorb']->loescheSpezialPos(C_WARENKORBPOS_TYP_TRUSTEDSHOPS);

		unset($_SESSION['VersandKupon']);
		unset($_SESSION['NeukundenKupon']);
		unset($_SESSION['Versandart']);
		unset($_SESSION['Zahlungsart']);
		unset($_SESSION['TrustedShops']);

		// Wenn Kupon vorhanden und prozentual auf ganzen Warenkorb,
        // dann verwerfen und neu anlegen
        altenKuponNeuBerechnen();

		setzeLinks();

		// Persistenter Warenkorb
		if(!isset($_POST["login"]))
			fuegeEinInWarenkorbPers($kArtikel, $anzahl, $oEigenschaftwerte_arr, $add);

      $smarty->assign('Boxen', $GLOBALS['Boxen']);
      $warensumme[0]=gibPreisStringLocalized($_SESSION["Warenkorb"]->gibGesamtsummeWarenExt(array(C_WARENKORBPOS_TYP_ARTIKEL),1));
      $warensumme[1]=gibPreisStringLocalized($_SESSION["Warenkorb"]->gibGesamtsummeWarenExt(array(C_WARENKORBPOS_TYP_ARTIKEL),0));
      $smarty->assign('WarenkorbWarensumme', $warensumme);

		$kKundengruppe = $_SESSION['Kundengruppe']->kKundengruppe;
		if(isset($_SESSION['Kunde']->kKundengruppe) && $_SESSION['Kunde']->kKundengruppe > 0)
			$kKundengruppe = $_SESSION['Kunde']->kKundengruppe;

		$smarty->assign('WarenkorbVersandkostenfreiHinweis', baueVersandkostenfreiString(gibVersandkostenfreiAb($kKundengruppe), $_SESSION["Warenkorb"]->gibGesamtsummeWaren(1,1)));
		$smarty->assign('WarenkorbVersandkostenfreiLaenderHinweis', baueVersandkostenfreiLaenderString(gibVersandkostenfreiAb($kKundengruppe), $_SESSION["Warenkorb"]->gibGesamtsummeWaren(1,1)));

		$smarty->assign('oArtikel', $Artikel); // deprecated 3.12
		$smarty->assign('zuletztInWarenkorbGelegterArtikel', $Artikel);
		
		$smarty->assign('fAnzahl', $anzahl);
		$smarty->assign("NettoPreise", $_SESSION['Kundengruppe']->nNettoPreise);

		$oXSelling = gibArtikelXSelling($kArtikel);
		$smarty->assign('Xselling', $oXSelling);

      $oResponse->nType = 2;
      $oResponse->cWarenkorbText = utf8_encode(lang_warenkorb_warenkorbEnthaeltXArtikel($_SESSION["Warenkorb"]));
      $oResponse->cWarenkorbLabel = utf8_encode(lang_warenkorb_warenkorbLabel($_SESSION["Warenkorb"]));
      //$oResponse->cNachricht = utf8_encode(sprintf($GLOBALS['oSprache']->gibWert('basketAjaxAdded', 'messages'), $Artikel->cName, $anzahl));
		$oResponse->cPopup = utf8_encode($smarty->fetch('tpl_inc/artikel_hinzugefuegt.tpl'));
      $oResponse->cWarenkorbMini = utf8_encode($smarty->fetch('tpl_inc/warenkorb_mini.tpl'));
      $oResponse->oArtikel = utf8_convert_recursive($Artikel, true);

      $objResponse->script("this.response = ".json_encode($oResponse).";");

		// Kampagne
		if(isset($_SESSION['Kampagnenbesucher']))
			setzeKampagnenVorgang(KAMPAGNE_DEF_WARENKORB, $kArtikel, $anzahl); // Warenkorb


		if ($GLOBALS['GlobaleEinstellungen']['global']['global_warenkorb_weiterleitung'] == "Y" && $nWeiterleitung == 0)
		{
         $add="?".SID;
         $oResponse->nType = 1;
         $oResponse->cLocation = 'warenkorb.php' . $add;
         $objResponse->script("this.response = ".json_encode($oResponse).";");
         return $objResponse;
		}
	}
   return $objResponse;
}


function setzeErweiterteDarstellung($nED)
{
   global $Einstellungen;
   $objResponse = new xajaxResponse();

   require_once("includes/filter_inc.php");

   // Hole alle aktiven Sprachen
   if (isset($NaviFilter->oSprache_arr))
      unset($NaviFilter->oSprache_arr);

   if (!isset($NaviFilter))
      $NaviFilter = new stdClass;

   $NaviFilter->oSprache_arr = new stdClass;
   $NaviFilter->oSprache_arr = $GLOBALS['DB']->executeQuery("SELECT kSprache FROM tsprache", 2);

   $NaviFilter = baueNaviFilter($NaviFilter, array());
   gibErweiterteDarstellung($Einstellungen, $NaviFilter, $nED);

   return $objResponse;
}

// Kundenformular Ajax PLZ
/*
	Params:
	$cFormValue	=> Textfeld Wert vom Kundenfomular input Feldes
	$cLandISO	=> Ausgewähltes Land in der DropDown Box
*/
function gibPLZInfo($cFormValue, $cLandISO)
{
	$objResponse = new xajaxResponse();
	$oPlz_arr = array();

	if (strlen($cFormValue) >= 4)
	{
		$oPlz_arr = $GLOBALS['DB']->executeQuery("SELECT cOrt
													FROM tplz
													WHERE cPLZ='" . StringHandler::htmlentities(filterXSS($cFormValue)) . "'
													AND cLandISO='" . StringHandler::htmlentities(filterXSS($cLandISO)) . "'", 2);
	}

	foreach ($oPlz_arr as $i => $oPlz)
		$oPlz_arr[$i]->cOrt = utf8_encode($oPlz->cOrt);

	$objResponse->script("this.plz_data = ".json_encode($oPlz_arr).";");

	// Hook
	executeHook(HOOK_TOOLSAJAXSERVER_PAGE_KUNDENFORMULARPLZ);

	return $objResponse;
}

// Kundenformular Ajax PLZ
/*
	Params:
	$cFormValue	=> Textfeld Wert vom Kundenfomular input Feldes
	$cLandISO	=> Ausgewähltes Land in der DropDown Box
*/
function aenderKundenformularPLZ($cFormValue, $cLandISO)
{
	$objResponse = new xajaxResponse();

	if(strlen($cFormValue) >= 4)
	{
		$oPlz = $GLOBALS['DB']->executeQuery("SELECT cOrt
												FROM tplz
												WHERE cPLZ='" . StringHandler::htmlentities(filterXSS($cFormValue)) . "'
													AND cLandISO='" . StringHandler::htmlentities(filterXSS($cLandISO)) . "'", 1);

		if(strlen($oPlz->cOrt) > 0)
			$objResponse->assign("kundenformular_ort", "value", $oPlz->cOrt);
	}

    // Hook
    executeHook(HOOK_TOOLSAJAXSERVER_PAGE_KUNDENFORMULARPLZ);

	return $objResponse;
}

function gibRegionzuLand($cLandIso)
{
	$objResponse = new xajaxResponse();
	
	if (strlen($cLandIso) == 2) {
      $cRegion_arr = Staat::getRegions($cLandIso);
      $cRegion_arr = utf8_convert_recursive($cRegion_arr);
		$objResponse->script("this.response = " . json_encode($cRegion_arr) . ";");
   }
	
	return $objResponse;
}

// Textfeld Ajax Suche
/*
	Params:
	$cValue 		=> Textfeld Wert (input) des Suchfeldes
	$nkeyCode 		=> Geklickter Tastenwert
	$cElemSearchID	=> Suchfeld (input)
	$cElemSuggestID	=> DIV an dem die Suchvorschläge angegeben werden
	$cElemSubmitID	=> Form die abgeschickt werden soll
*/
function suchVorschlag($cValue, $nkeyCode, $cElemSearchID, $cElemSuggestID, $cElemSubmitID)
{	
    $nkeyCode = intval($nkeyCode);
    $cValue = StringHandler::htmlentities(filterXSS($cValue));
    $cElemSearchID = StringHandler::htmlentities(filterXSS($cElemSearchID));
    $cElemSuggestID = StringHandler::htmlentities(filterXSS($cElemSuggestID));
    $cElemSubmitID = StringHandler::htmlentities(filterXSS($cElemSubmitID));

	global $Einstellungen;

	// Maximale Suchvorschläge
	$nMaxAnzahl = 10;
	if(intval($Einstellungen['artikeluebersicht']['suche_ajax_anzahl']) > 0)
		$nMaxAnzahl = intval($Einstellungen['artikeluebersicht']['suche_ajax_anzahl']);

	$objResponse = new xajaxResponse();
	$objResponse->assign($cElemSuggestID, "innerHTML", '');

	if(strlen($cValue) >= 3)
	{
		$oSuchanfrage_arr = $GLOBALS["DB"]->executeQuery("SELECT cSuche, nAnzahlTreffer
															FROM tsuchanfrage
															WHERE cSuche LIKE '" . $cValue . "%'
																AND nAktiv=1
                                                                AND kSprache = " . $_SESSION['kSprache'] . "
															ORDER BY nAnzahlGesuche DESC, cSuche
															LIMIT " . $nMaxAnzahl, 2);

		if(is_array($oSuchanfrage_arr) && count($oSuchanfrage_arr) > 0)
		{
			$cSuche = "";
			foreach($oSuchanfrage_arr as $i => $oSuchanfrage)
			{
				$onClick = 'document.getElementById("' . $cElemSearchID . '").value = "' . $oSuchanfrage->cSuche . '"; document.' . $cElemSubmitID . '.submit();';
				$cSuchwort = str_replace($cValue, '<b>' .$cValue. '</b>', $oSuchanfrage->cSuche);
				$cSuche .= "<div class='suggestions' id='" . $cElemSuggestID . $i . "' onclick='" . $onClick . "'>" . $cSuchwort . " <span class='suggestion_count'>(" . $oSuchanfrage->nAnzahlTreffer . ")</span></div>";
				$cSuche .= "<input id='" . $cElemSuggestID . "value" . $i . "' name='" . $cElemSuggestID . "value" . $i . "' type='hidden' value='" . $oSuchanfrage->cSuche . "'>";
			}

			$objResponse->assign($cElemSuggestID, "innerHTML", $cSuche);
         $objResponse->script("
               resizeContainer('" . $cElemSearchID . "', '" . $cElemSuggestID . "');
               nAnzahlSuggests = " . (count($oSuchanfrage_arr)-1) . ";");
		}
	}

    // Hook
    executeHook(HOOK_TOOLSAJAXSERVER_PAGE_SUCHVORSCHLAG, array("cValue" => &$cValue, "nkeyCode" => &$nkeyCode, "cElemSearchID" => &$cElemSearchID, "cElemSuggestID" => &$cElemSuggestID, "cElemSubmitID" => &$cElemSubmitID, "objResponse" => &$objResponse));

	return $objResponse;
}

function suggestions($cValue)
{
   global $Einstellungen;

   $cSuch_arr = array();
   $cValue = filterXSS($cValue);

	// Maximale Suchvorschläge
	$nMaxAnzahl = 10;
	if (intval($Einstellungen['artikeluebersicht']['suche_ajax_anzahl']) > 0)
		$nMaxAnzahl = intval($Einstellungen['artikeluebersicht']['suche_ajax_anzahl']);

	$objResponse = new xajaxResponse();
	if(strlen($cValue) >= 3)
	{
		$oSuchanfrage_arr = $GLOBALS["DB"]->executeQuery("SELECT cSuche, nAnzahlTreffer
															FROM tsuchanfrage
															WHERE cSuche LIKE '" . $cValue . "%'
																AND nAktiv=1
                                                AND kSprache = " . $_SESSION['kSprache'] . "
															ORDER BY nAnzahlGesuche DESC, cSuche
															LIMIT " . $nMaxAnzahl, 2);

		if(is_array($oSuchanfrage_arr) && count($oSuchanfrage_arr) > 0)
		{
			foreach($oSuchanfrage_arr as $i => $oSuchanfrage)
			{
            $cSuche = utf8_encode($oSuchanfrage->cSuche);
         
            $i = count($cSuch_arr);
            $cSuch_arr[$i]['value'] = $cSuche . ' <span class="ac_resultcount">' . $oSuchanfrage->nAnzahlTreffer . ' ' . StringHandler::htmlentities( $GLOBALS['oSprache']->gibWert('matches', 'global') ) . ' </span>';
            $cSuch_arr[$i]['result'] = $cSuche;
			}
		}
	}

   // Hook
   executeHook(HOOK_TOOLSAJAXSERVER_PAGE_SUCHVORSCHLAG, array("cValue" => &$cValue, "objResponse" => &$objResponse, "cSuch_arr" => &$cSuch_arr));

   $objResponse->script("this.ac_data = ".json_encode($cSuch_arr).";");
	return $objResponse;
}

function loescheStepAjax($nStep)
{
	loescheSession($nStep);
}

// Main Handler
function Handler($aFormValues)
{
	global $Kunde, $step, $smarty, $hinweis, $Einstellungen;

	$hinweis = "";
	$step = 'accountwahl';

	$objResponse = new xajaxResponse();

	// Login
	if (intval($aFormValues["login"])==1)
	{
		globaleAssigns();
		loescheSession(0);
		$nLoginStatus = plausiAccountwahlLogin($aFormValues["userLogin"], $aFormValues["passLogin"]);

		if($nLoginStatus == 10)
		{
			loescheSession(1);
			setzeSesssionAccountwahlLogin($Kunde);

			if($Einstellungen['kaufabwicklung']['bestellvorgang_kaufabwicklungsmethode'] == "O" || $Einstellungen['kaufabwicklung']['bestellvorgang_kaufabwicklungsmethode'] == "A")
			{
				// Ajax EinKlick prüfen
				$nAjaxEinKlickStatus = pruefeAjaxEinKlick();

				if($nAjaxEinKlickStatus > 0 && $Einstellungen['kaufabwicklung']['bestellvorgang_kaufabwicklungsmethode'] == "O")
				{
					$objResponse->script("nEnabled = " . $nAjaxEinKlickStatus . ";");
					$_SESSION['ajaxcheckout']->nEnabled = $nAjaxEinKlickStatus;
					ladeAjaxEinKlick();
					setzeSmartyAccountwahl();
					setzeSmartyRechnungsadresse(0);

					$objResponse->assign("1-content", "innerHTML", $smarty->fetch("tpl_inc/ajaxcheckout_registrieren.tpl"));
					$objResponse->assign("2-content", "innerHTML", $smarty->fetch("tpl_inc/ajaxcheckout_lieferadresse.tpl"));
					$objResponse->assign("div_boxRechnungsadresse", "style.display", "block");
					$objResponse->assign("div_rechnungsadresse_box", "innerHTML", $smarty->fetch("tpl_inc/inc_rechnungsadresse.tpl"));
					$objResponse->script("aendereStatus();");

					if($nAjaxEinKlickStatus >= 3)
					{
                        setzeSmartyLieferadresse();
                        setzeSmartyVersandart();

						$objResponse->assign("2-content", "innerHTML", $smarty->fetch("tpl_inc/ajaxcheckout_lieferadresse.tpl"));
						$objResponse->assign("div_boxLieferadresse", "style.display", "block");
						$objResponse->assign("div_lieferadresse_box", "innerHTML", $smarty->fetch("tpl_inc/inc_lieferadresse.tpl"));
						$objResponse->assign("div_boxVersandart", "style.display", "block");
					}
					if($nAjaxEinKlickStatus >= 4)
					{
                        setzeSmartyZahlungsart();

						$objResponse->assign("3-content", "innerHTML", $smarty->fetch("tpl_inc/ajaxcheckout_versandart.tpl"));
						$objResponse->assign("div_boxVersandart", "style.display", "block");
						$objResponse->assign("div_versandart_box", "innerHTML", $_SESSION['Versandart']->angezeigterName[$_SESSION['cISOSprache']]);
						$objResponse->assign("4-content", "innerHTML", $smarty->fetch("tpl_inc/ajaxcheckout_zahlung.tpl"));
					}
                    if($nAjaxEinKlickStatus == 5)
                    {
                        setzeSmartyBestaetigung();

                        $objResponse->assign("5-content", "innerHTML", $smarty->fetch("tpl_inc/ajaxcheckout_bestaetigung.tpl"));
                        $objResponse->assign("div_boxZahlungsart", "style.display", "block");
                        $objResponse->assign("div_zahlungsart_box", "innerHTML", $_SESSION['Zahlungsart']->angezeigterName[$_SESSION['cISOSprache']]);
                    }
				}
				else
				{
					$objResponse->script("nEnabled = 2;");
					$_SESSION['ajaxcheckout']->nEnabled = 2;
					loescheSession(2);
					setzeSmartyAccountwahl();
					setzeSmartyRechnungsadresse(0);
					setzeSmartyLieferadresse();
					$objResponse->assign("1-content", "innerHTML", $smarty->fetch("tpl_inc/ajaxcheckout_registrieren.tpl"));
					$objResponse->assign("2-content", "innerHTML", $smarty->fetch("tpl_inc/ajaxcheckout_lieferadresse.tpl"));
					$objResponse->assign("div_boxRechnungsadresse", "style.display", "block");
					$objResponse->assign("div_rechnungsadresse_box", "innerHTML", $smarty->fetch("tpl_inc/inc_rechnungsadresse.tpl"));
					$objResponse->script("aendereStatus();");
				}
			}
		}
		else
		{
			setzeFehlerSmartyAccountwahl($GLOBALS['oSprache']->gibWert('incorrectLogin', 'global'));
			$objResponse->script("nEnabled = 0;");
			$_SESSION['ajaxcheckout']->nEnabled = 0;
			$objResponse->assign("0-content", "innerHTML", $smarty->fetch("tpl_inc/ajaxcheckout_accountwahl.tpl"));
		}
	}

	// Kundenkonto erstellen
	else if(intval($aFormValues["neueskundenkonto"]) == 1)
	{
		globaleAssigns();
		$step = "neueskundenkonto";
		$objResponse->script("nEnabled = 1;");
		$_SESSION['ajaxcheckout']->nEnabled = 1;
		loescheSession(0);
		setzeSmartyRechnungsadresse(1);
		$objResponse->assign("1-content", "innerHTML", $smarty->fetch("tpl_inc/ajaxcheckout_registrieren.tpl"));
	}

	// Kundenkonto eintragen
	else if(intval($aFormValues["neukundeEintragen"]) == 1)
	{
		globaleAssigns();
		// NeuKunde will unregistiert bestellen ohne seinen Account zu speichern (!isset(ajaxeueskontoPassCheck))
		if(!$aFormValues['editRechnungsadresse'] && !$aFormValues['ajaxeueskontoPassCheck'] && $Einstellungen['kaufabwicklung']['bestellvorgang_unregistriert'] == "Y")
		{
			$cFehlendeEingaben_arr = plausiRechnungsadresse($aFormValues, 1);	// Plausibilitätsprüfung

			if(is_array($cFehlendeEingaben_arr) && count($cFehlendeEingaben_arr) == 0)
			{
				$objResponse->script("nEnabled = 2;");
				$_SESSION['ajaxcheckout']->nEnabled = 2;
				setzeSessionRechnungsadresse($aFormValues, $cFehlendeEingaben_arr);
				setzeSmartyRechnungsadresse(1);
				setzeSmartyLieferadresse();
				$objResponse->assign("2-content", "innerHTML", $smarty->fetch("tpl_inc/ajaxcheckout_lieferadresse.tpl"));
				$objResponse->assign("div_boxRechnungsadresse", "style.display", "block");
				$objResponse->assign("div_rechnungsadresse_box", "innerHTML", $smarty->fetch("tpl_inc/inc_rechnungsadresse.tpl"));
				$objResponse->script("aendereStatus();");
			}
			else
			{
				$objResponse->script("nEnabled = 1;");
				$_SESSION['ajaxcheckout']->nEnabled = 1;
				loescheSession(1);
				setzeFehlerSmartyRechnungsadresse($cFehlendeEingaben_arr, 1, $aFormValues);
				$objResponse->assign("1-content", "innerHTML", $smarty->fetch("tpl_inc/ajaxcheckout_registrieren.tpl"));
			}
		}
		else 	// Neukundenregistrierung mit Speicherung des Accounts
		{
			$aFormValues['ajaxcheckout_return'] = 1;
			$editRechnungsadresse = $aFormValues['editRechnungsadresse'];

			$cFehlendeEingaben_arr = kundeSpeichern($aFormValues);	// Kundenaccount speichern

			if(!is_array($cFehlendeEingaben_arr) && $cFehlendeEingaben_arr) // Alles OK
			{
				$objResponse->script("nEnabled = 2;");
				$_SESSION['ajaxcheckout']->nEnabled = 2;
				setzeSessionRechnungsadresse($aFormValues, $cFehlendeEingaben_arr);
				setzeSmartyRechnungsadresse(0);
				setzeSmartyLieferadresse();
				$objResponse->assign("2-content", "innerHTML", $smarty->fetch("tpl_inc/ajaxcheckout_lieferadresse.tpl"));
				$objResponse->assign("div_boxRechnungsadresse", "style.display", "block");
				$objResponse->assign("div_rechnungsadresse_box", "innerHTML", $smarty->fetch("tpl_inc/inc_rechnungsadresse.tpl"));
				$objResponse->script("aendereStatus();");
			}
			else
			{
				$objResponse->script("nEnabled = 1;");
				$_SESSION['ajaxcheckout']->nEnabled = 1;
				loescheSession(1);

				if($editRechnungsadresse)
				{
					$smarty->assign("step", "rechnungsdaten");
					setzeFehlerSmartyRechnungsadresse($cFehlendeEingaben_arr, 0, $aFormValues);
				}
				else
				{
					$smarty->assign("step", "formular");
					setzeFehlerSmartyRechnungsadresse($cFehlendeEingaben_arr, 1, $aFormValues);
				}

				$objResponse->assign("1-content", "innerHTML", $smarty->fetch("tpl_inc/ajaxcheckout_registrieren.tpl"));
			}
		}
	}

	// Rechnungsadresse editieren
	else if(intval($aFormValues['editRechnungsadresse']) == 1)
	{
		globaleAssigns();
		$objResponse->script("nEnabled = 1;");
		$_SESSION['ajaxcheckout']->nEnabled = 1;
		loescheSession(1);
		setzeSmartyRechnungsadresse(0);

		$objResponse->assign("1-content", "innerHTML", $smarty->fetch("tpl_inc/ajaxcheckout_registrieren.tpl"));
	}

	// Liederadresse editieren
	else if(intval($aFormValues['editLieferadresse']) == 1)
	{
		globaleAssigns();
		$objResponse->script("nEnabled = 2;");
		$_SESSION['ajaxcheckout']->nEnabled = 2;
		loescheSession(2);
		setzeSmartyRechnungsadresse(0);
		setzeSmartyLieferadresse();
		$objResponse->assign("2-content", "innerHTML", $smarty->fetch("tpl_inc/ajaxcheckout_lieferadresse.tpl"));
	}

	// Versandart abgeschickt
	else if (intval($aFormValues['versandartwahl'])==1)
	{
		globaleAssigns();
		if(plausiVersandart($aFormValues['Versandart'], $aFormValues))
		{
			$objResponse->script("nEnabled = 4;");
			$_SESSION['ajaxcheckout']->nEnabled = 4;
			loescheSession(4);
			setzeSmartyVersandart();
			setzeSmartyZahlungsart();
			$objResponse->assign("4-content", "innerHTML", $smarty->fetch("tpl_inc/ajaxcheckout_zahlung.tpl"));
			$objResponse->assign("div_boxVersandart", "style.display", "block");
			$objResponse->assign("div_versandart_box", "innerHTML", $_SESSION['Versandart']->angezeigterName[$_SESSION['cISOSprache']]);
		}
		else
		{
			loescheSession(3);
			$objResponse->script("nEnabled = 3;");
			$_SESSION['ajaxcheckout']->nEnabled = 3;
			setzeSmartyLieferadresse();
			setzeSmartyVersandart();
			setzeFehlerSmartyVersandart();
			$objResponse->assign("3-content", "innerHTML", $smarty->fetch("tpl_inc/ajaxcheckout_versandart.tpl"));
		}
	}

	// Lieferadresse abgeschickt
	else if (intval($aFormValues['lieferdaten']) == 1)
	{
		globaleAssigns();
		$cFehlendeEingaben_arr = plausiLieferadresse($aFormValues);

		if(is_array($cFehlendeEingaben_arr) && count($cFehlendeEingaben_arr) == 0)
		{
			loescheSession(3);
			$objResponse->script("nEnabled = 3;");
			$_SESSION['ajaxcheckout']->nEnabled = 3;
			setzeSessionLieferadresse($aFormValues);
			setzeSmartyLieferadresse();
			setzeSmartyVersandart();
            pruefeVersandkostenfreiKuponVorgemerkt();
			$objResponse->assign("3-content", "innerHTML", $smarty->fetch("tpl_inc/ajaxcheckout_versandart.tpl"));
			$objResponse->assign("div_boxLieferadresse", "style.display", "block");
			$objResponse->assign("div_lieferadresse_box", "innerHTML", $smarty->fetch("tpl_inc/inc_lieferadresse.tpl"));
		}
		else
		{
			$objResponse->script("nEnabled = 2;");
			$_SESSION['ajaxcheckout']->nEnabled = 2;
			loescheSession(2);
			setzeFehlerSmartyLieferadresse($cFehlendeEingaben_arr, $aFormValues);
            $objResponse->assign("2-content", "innerHTML", $smarty->fetch("tpl_inc/ajaxcheckout_lieferadresse.tpl"));
            $objResponse->script("aendereStatus(true);");
		}
	}

	// Zahlungsart abgeschickt
	else if(intval($aFormValues['zahlungsartwahl']) == 1)
	{
		globaleAssigns();
		if(intval($aFormValues['zahlungsartzusatzschritt']) == 1)
		{
			$oZahlungsart = gibZahlungsart(intval($aFormValues['Zahlungsart']));
			$cFehlendeEingaben_arr = plausiZahlungsartZusatz($oZahlungsart, $aFormValues);

			if(is_array($cFehlendeEingaben_arr) && count($cFehlendeEingaben_arr) == 0)
			{
				setzeSmartyLieferadresse();
				setzeSmartyVersandart();
				setzeSmartyZahlungsart();
				setzeSmartyBestaetigung();
				setzeSmartyZahlungsart();
				setzeSmartyBestaetigung();
				$objResponse->script("nEnabled = 5;");
				$_SESSION['ajaxcheckout']->nEnabled = 5;
				//evtl genutztes guthaben anpassen
				pruefeGuthabenNutzen();
				$objResponse->assign("5-content", "innerHTML", $smarty->fetch("tpl_inc/ajaxcheckout_bestaetigung.tpl"));
				$objResponse->assign("div_boxZahlungsart", "style.display", "block");
				$objResponse->assign("div_zahlungsart_box", "innerHTML", $_SESSION['Zahlungsart']->angezeigterName[$_SESSION['cISOSprache']]);
			}
			else
			{
				setzeSmartyZahlungsartZusatz($aFormValues, $cFehlendeEingaben_arr);
				$objResponse->assign("4-content", "innerHTML", $smarty->fetch("tpl_inc/ajaxcheckout_zahlung_zusatzschritt.tpl"));
			}
		}
		else
		{
			// Zusatzschritt?
			switch(plausiZahlungsart($aFormValues))
			{
				case 0:
					setzeSmartyZahlungsart();
					setzeFehlerSmartyZahlungsart();
					loescheSession(4);
					$objResponse->assign("4-content", "innerHTML", $smarty->fetch("tpl_inc/ajaxcheckout_zahlung.tpl"));
					break;
				case 1:
					setzeSmartyZahlungsartZusatz($aFormValues);
					$objResponse->assign("4-content", "innerHTML", $smarty->fetch("tpl_inc/ajaxcheckout_zahlung_zusatzschritt.tpl"));
					break;
				case 2:
                    $_SESSION['ajaxcheckout']->nEnabled = 5;
					setzeSmartyLieferadresse();
					setzeSmartyVersandart();
					setzeSmartyZahlungsart();
					setzeSmartyBestaetigung();
					$objResponse->script("nEnabled = 5;");
					$_SESSION['ajaxcheckout']->nEnabled = 5;
					//evtl genutztes guthaben anpassen
					pruefeGuthabenNutzen();
					$objResponse->assign("5-content", "innerHTML", $smarty->fetch("tpl_inc/ajaxcheckout_bestaetigung.tpl"));
					$objResponse->assign("div_boxZahlungsart", "style.display", "block");
					$objResponse->assign("div_zahlungsart_box", "innerHTML", $_SESSION['Zahlungsart']->angezeigterName[$_SESSION['cISOSprache']]);
					break;
			}
		}
	}

    // Kupon eingegeben
    else if (intval($aFormValues['pruefekupon']) == 1 || intval($aFormValues['guthaben']) == 1)
    {
        globaleAssigns();

        if(intval($aFormValues['pruefekupon']) == 1)
            $smarty->assign("cKuponfehler_arr", plausiKupon($aFormValues));
        else if(intval($aFormValues['guthaben']) == 1)
            plausiGuthaben($aFormValues);
        //evtl genutztes guthaben anpassen
        pruefeGuthabenNutzen();
        setzeSmartyLieferadresse();
        setzeSmartyVersandart();
        setzeSmartyZahlungsart();
        setzeSmartyBestaetigung();
        $objResponse->script("nEnabled = 5;");
        $_SESSION['ajaxcheckout']->nEnabled = 5;
        $objResponse->assign("5-content", "innerHTML", $smarty->fetch("tpl_inc/ajaxcheckout_bestaetigung.tpl"));
        $objResponse->assign("div_boxZahlungsart", "style.display", "block");
        $objResponse->assign("div_zahlungsart_box", "innerHTML", $_SESSION['Zahlungsart']->angezeigterName[$_SESSION['cISOSprache']]);
    }

	$objResponse->assign("div_rechnungsadresse_box", "innerHTML", $smarty->fetch("tpl_inc/inc_rechnungsadresse.tpl") . "<br><input type='submit' value='" .$GLOBALS['oSprache']->gibWert('ajaxcheckoutChangemethode', 'global') . "' class='button' onclick='nEnabled=1; toggleState(); xajax_loescheStepAjax(1);'>");
	$objResponse->assign("div_lieferadresse_box", "innerHTML", $smarty->fetch("tpl_inc/inc_lieferadresse.tpl") . "<br><input type='button' value='" .$GLOBALS['oSprache']->gibWert('ajaxcheckoutChangemethode', 'global') . "' class='button' onclick='nEnabled=2; toggleState(); xajax_loescheStepAjax(2);'>");
	$objResponse->assign("div_versandart_box", "innerHTML", $_SESSION['Versandart']->angezeigterName[$_SESSION['cISOSprache']] . "<br><input type='button' value='" .$GLOBALS['oSprache']->gibWert('ajaxcheckoutChangemethode', 'global') . "' class='button' onclick='nEnabled=3; toggleState(); xajax_loescheStepAjax(3);'>");
	$objResponse->assign("div_zahlungsart_box", "innerHTML", $_SESSION['Zahlungsart']->angezeigterName[$_SESSION['cISOSprache']] . "<br><input type='button' value='" .$GLOBALS['oSprache']->gibWert('ajaxcheckoutChangemethode', 'global') . "' class='button' onclick='nEnabled=4; toggleState(); xajax_loescheStepAjax(4);'>");

	$objResponse->script("toggleState();");

	return $objResponse;
}

function tauscheVariationKombi($aFormValues, $nVater=0, $kEigenschaft=0, $kEigenschaftWert=0, $bSpeichern = false)
{
    require_once(PFAD_ROOT . PFAD_INCLUDES . "artikel_inc.php");
	global $smarty;

    $GLOBALS['AktuelleSeite'] = "ARTIKEL";
	$GLOBALS['nSeitenTyp'] = PAGE_ARTIKEL;

	$objResponse = new xajaxResponse();
	$cVariationKombiKind = "";

	$Einstellungen = "";
	$Einstellungen = getEinstellungen(array(CONF_GLOBAL,CONF_NAVIGATIONSFILTER,CONF_RSS,CONF_ARTIKELDETAILS,CONF_PREISVERLAUF,CONF_BEWERTUNG,CONF_BOXEN,CONF_PREISVERLAUF,CONF_METAANGABEN));
    $GLOBALS['Einstellungen'] = $Einstellungen;
    
	//hole aktuellen Vater Artikel
	if($aFormValues['a'] > 0)
	{
        unset($oVaterArtikel);
		$oVaterArtikel = new Artikel();
		unset($oArtikelOptionen);
        if($nVater)
        {
            $oArtikelOptionen->nMerkmale = 1;
            $oArtikelOptionen->nAttribute = 1;
            $oArtikelOptionen->nArtikelAttribute = 1;
            $oArtikelOptionen->nMedienDatei = 1;
        }
		$oArtikelOptionen->nVariationKombi = 1;
        $oArtikelOptionen->nVariationKombiKinder = 1;
        $oArtikelOptionen->nDownload = 1;
        $oArtikelOptionen->nKonfig = 1;
        $oArtikelOptionen->nMain = 1;
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
		$oVaterArtikel->fuelleArtikel(intval($aFormValues['a']), $oArtikelOptionen, intval($aFormValues['kKundengruppe']), intval($aFormValues['kSprache']));
		$oVaterArtikel->holeBewertungDurchschnitt(1);

		$bKindVorhanden = false;
		
        if(!$nVater)
        {
		    if(is_array($oVaterArtikel->Variationen) && count($oVaterArtikel->Variationen) > 0)
		    {
			    $nGueltig = 1;
			    $kVariationKombi_arr = array();
			    foreach($oVaterArtikel->Variationen as $oVariation)
			    {
				    if($oVariation->cTyp != "FREIFELD" && $oVariation->cTyp != "PFLICHT-FREIFELD")
				    {
					    if(intval($aFormValues['eigenschaftwert_' . $oVariation->kEigenschaft]) > 0)
						    $kVariationKombi_arr[$oVariation->kEigenschaft] = intval($aFormValues['eigenschaftwert_' . $oVariation->kEigenschaft]);
				    }
			    }
                
                if ($bSpeichern)
                    $_SESSION['oVarkombiAuswahl']->kGesetzteEigeschaftWert_arr = $kVariationKombi_arr;

				$oArtikelTMP = gibArtikelByVariationen($oVaterArtikel->kArtikel, $kVariationKombi_arr);

				if($oArtikelTMP->kArtikel > 0)
				{
					require_once(PFAD_INCLUDES."artikel_inc.php");
					require_once(PFAD_ROOT.PFAD_CLASSES_CORE."class.core.NiceMail.php");
					$AktuelleSeite = "ARTIKEL";

					$bKindVorhanden = true;
					
					// Bewertungsguthaben
					$fBelohnung = 0.0;
					if($GLOBALS['Einstellungen']['bewertung']['bewertung_guthaben_nutzen'] == "Y")
					{
						if($GLOBALS['Einstellungen']['bewertung']['bewertung_stufe2_anzahlzeichen'] <= $_GET['strl'])
							$fBelohnung = $GLOBALS['Einstellungen']['bewertung']['bewertung_stufe2_guthaben'];
						else
							$fBelohnung = $GLOBALS['Einstellungen']['bewertung']['bewertung_stufe1_guthaben'];
					}

					// Hinweise und Fehler sammeln
					$cHinweis = mappingFehlerCode(verifyGPDataString('cHinweis'), $fBelohnung);
					$cFehler = mappingFehlerCode(verifyGPDataString('cFehler'));

					unset($oArtikel);
					unset($oArtikelOptionen);
			   
					$oArtikel = new Artikel();
			   
					$oArtikelOptionen->nMerkmale = 1;
					$oArtikelOptionen->nAttribute = 1;
					$oArtikelOptionen->nArtikelAttribute = 1;
					$oArtikelOptionen->nMedienDatei = 1;
					$oArtikelOptionen->nVariationKombi = 1;
					$oArtikelOptionen->nKeinLagerbestandBeachten = 1;
					$oArtikelOptionen->nKonfig = 1;
					$oArtikelOptionen->nDownload = 1;
					$oArtikelOptionen->nFinanzierung = 1;
					$oArtikelOptionen->nMain = 1;
					$oArtikelOptionen->nWarenlager = 1;
					
					if($Einstellungen['artikeldetails']['artikeldetails_produktbundle_nutzen'] == "Y")
						$oArtikelOptionen->nProductBundle = 1;
			   
					$oArtikel->fuelleArtikel($oArtikelTMP->kArtikel, $oArtikelOptionen, $aFormValues['kKundengruppe'], $aFormValues['kSprache']);
					$oArtikel->kArtikelVariKombi = $oArtikel->kArtikel;
					
					// Hole EigenschaftWerte zur gewählten VariationKombi
					$oVariationKombiKind_arr = $GLOBALS['DB']->executeQuery("SELECT teigenschaftkombiwert.kEigenschaftWert, teigenschaftkombiwert.kEigenschaft
																				FROM teigenschaftkombiwert
																				JOIN tartikel ON tartikel.kEigenschaftKombi = teigenschaftkombiwert.kEigenschaftKombi
																					AND tartikel.kVaterArtikel = " . $oVaterArtikel->kArtikel . "
																					AND tartikel.kArtikel = " . $oArtikel->kArtikelVariKombi . "
																				LEFT JOIN tartikelsichtbarkeit ON tartikel.kArtikel = tartikelsichtbarkeit.kArtikel
																					AND tartikelsichtbarkeit.kKundengruppe=" . $_SESSION['Kundengruppe']->kKundengruppe . "
																				WHERE tartikelsichtbarkeit.kArtikel IS NULL
																				ORDER BY tartikel.kArtikel", 2);

					$kVariationKombiKind_arr = array();
					if(is_array($oVariationKombiKind_arr) && count($oVariationKombiKind_arr) > 0)
					{
						foreach($oVariationKombiKind_arr as $f => $oVariationKombiKind)
						{
							if($f > 0)
								$cVariationKombiKind .= ";" . $oVariationKombiKind->kEigenschaft . "_" . $oVariationKombiKind->kEigenschaftWert;
							else
								$cVariationKombiKind .= $oVariationKombiKind->kEigenschaft . "_" . $oVariationKombiKind->kEigenschaftWert;
						}
					}

					$oArtikel->kArtikel = $oVaterArtikel->kArtikel;
					$oArtikel->cVaterVKLocalized = $oVaterArtikel->Preise->cVKLocalized;
					$oArtikel->nIstVater = $oVaterArtikel->nIstVater;
					//$oArtikel->Variationen = $oVaterArtikel->Variationen;
					$oArtikel->fDurchschnittsBewertung = $oVaterArtikel->fDurchschnittsBewertung;
					$oArtikel->Bewertungen = $oVaterArtikel->Bewertungen;
					$oArtikel->HilfreichsteBewertung = $oVaterArtikel->HilfreichsteBewertung;
					$oArtikel->oVariationKombiVorschau_arr = $oVaterArtikel->oVariationKombiVorschau_arr;
					$oArtikel->oVariationDetailPreis_arr = $oVaterArtikel->oVariationDetailPreis_arr;
					$oArtikel->nVariationKombiNichtMoeglich_arr = $oVaterArtikel->nVariationKombiNichtMoeglich_arr;
					$oArtikel->oVariationKombiVorschauText = $oVaterArtikel->oVariationKombiVorschauText;
					$oArtikel->cVaterURL = $oVaterArtikel->cURL;
					$oArtikel->VaterFunktionsAttribute = $oVaterArtikel->FunktionsAttribute;
					
					// Kind mit uebergeben
					$oArtikel->kVariKindArtikel = $oArtikel->kArtikelVariKombi;
					
					$xPost_arr = $_POST;
					baueArtikelDetail($oArtikel, $xPost_arr);
					
					if (isset($aFormValues['kEditKonfig']))
						$smarty->assign('kEditKonfig', $aFormValues['kEditKonfig']);
						
					$cArtikelTemplate = 'artikel_inc.tpl';
					if (isset($oArtikel->FunktionsAttribute[FKT_ATTRIBUT_ARTIKELDETAILS_TPL]))
						$cArtikelTemplate = $oArtikel->FunktionsAttribute[FKT_ATTRIBUT_ARTIKELDETAILS_TPL];

					$objResponse->assign("contentmid", "innerHTML", $smarty->fetch("tpl_inc/" . $cArtikelTemplate));
					$objResponse->assign("popUps", "innerHTML", $smarty->fetch("tpl_inc/artikel_popups.tpl"));

					
					if(isset($_SESSION['oVarkombiAuswahl']) && getTemplateVersion() > 311)
					{	
						$objResponse->script("setzeEigenschaftWerte('" . $cVariationKombiKind . "');");
					}
					
					// Hole alle Eigenschaften des Artikels
					$oEigenschaft_arr = $GLOBALS['DB']->executeQuery("SELECT * FROM teigenschaft WHERE kArtikel='{$oVaterArtikel->kArtikel}' AND (cTyp = 'RADIO' OR cTyp = 'SELECTBOX') ORDER BY nSort ASC, cName ASC", 2);
					
					// Durchlaufe alle Eigenschaften
					$oEigenschaftWert_arr = array();
					foreach ($oEigenschaft_arr as $i => $oEigenschaft)
						$oEigenschaftWert_arr[$i] = $GLOBALS['DB']->executeQuery("SELECT * FROM teigenschaftwert WHERE kEigenschaft='{$oEigenschaft->kEigenschaft}'", 2);

					// Baue mögliche Kindartikel
					$oKombiFilter_arr = gibMoeglicheVariationen($oVaterArtikel->kArtikel, $oEigenschaftWert_arr, $_SESSION['oVarkombiAuswahl']->kGesetzteEigeschaftWert_arr);

					if(is_array($oKombiFilter_arr) && count($oKombiFilter_arr) > 0)
					{
						$objResponse->script("schliesseAlleEigenschaftFelder();");
						foreach ($oKombiFilter_arr as $oKombiFilter)
							$objResponse->script("aVC(" . $oKombiFilter->kEigenschaftWert . ");");
					}

					$objResponse->script('setBindingsArtikel();');
					
					if ($oArtikel->bHasKonfig && count($oArtikel->oKonfig_arr) > 0)
					{
						$cArtikelJSTemplate = 'artikel_konfigurator_js.tpl';
						if (isset($oArtikel->FunktionsAttribute[FKT_ATTRIBUT_ARTIKELKONFIG_TPL_JS]))
							$cArtikelJSTemplate = $oArtikel->FunktionsAttribute[FKT_ATTRIBUT_ARTIKELKONFIG_TPL_JS];
					
						$cKonfigJS = $smarty->fetch("tpl_inc/" . $cArtikelJSTemplate);
						
						// remove script header
						$cKonfigJS = str_replace('<script type="text/javascript">', '', $cKonfigJS);
						$cKonfigJS = str_replace('</script>', '', $cKonfigJS);
						
						$objResponse->script($cKonfigJS);
					}

					foreach($oVariationKombiKind_arr as $f => $oVariationKombiKind)
					{
						$kNichtGesetzteEigenschaft = $oVariationKombiKind->kEigenschaft;
					
						// hole eigenschaftswerte
						$kBereitsGesetzt = array();
						$oEigenschaftWert_arr = $GLOBALS['DB']->executeQuery("SELECT * FROM teigenschaftwert WHERE kEigenschaft='{$kNichtGesetzteEigenschaft}'", 2);
						
						foreach ($oEigenschaftWert_arr as $oEigenschaftWert)
						{
							$kMoeglicheEigenschaftWert_arr = $_SESSION['oVarkombiAuswahl']->kGesetzteEigeschaftWert_arr;
							$kMoeglicheEigenschaftWert_arr[$kNichtGesetzteEigenschaft] = $oEigenschaftWert->kEigenschaftWert;
							
							$oTMPArtikel = gibArtikelByVariationen($oVaterArtikel->kArtikel, $kMoeglicheEigenschaftWert_arr);
							
							if ($oTMPArtikel && $oTMPArtikel->kArtikel > 0)
							{
								if (in_array($oTMPArtikel->kArtikel, $kBereitsGesetzt))
									continue;
									
								$kBereitsGesetzt[] = $oTMPArtikel->kArtikel;
							
								$oTestArtikel = new Artikel();
								$oArtikelOptionen->nMerkmale = 0;
								$oArtikelOptionen->nAttribute = 0;
								$oArtikelOptionen->nArtikelAttribute = 0;
								$oArtikelOptionen->nMedienDatei = 0;
								$oArtikelOptionen->nVariationKombi = 0;
								$oArtikelOptionen->nKeinLagerbestandBeachten = 1;
								$oArtikelOptionen->nKonfig = 0;
								$oArtikelOptionen->nDownload = 0;
								$oArtikelOptionen->nFinanzierung = 0;
								$oArtikelOptionen->nMain = 0;
								$oArtikelOptionen->nWarenlager = 0;
						   
								$oTestArtikel->fuelleArtikel($oTMPArtikel->kArtikel, $oArtikelOptionen, gibAktuelleKundengruppe(), $_SESSION['kSprache']);

								if ($oTestArtikel->cLagerBeachten == 'Y' && $oTestArtikel->cLagerKleinerNull != 'Y' && $oTestArtikel->fLagerbestand == 0)
									$objResponse->script("setzeVarInfo({$oEigenschaftWert->kEigenschaftWert}, '{$oTestArtikel->Lageranzeige->AmpelText}', '{$oTestArtikel->Lageranzeige->nStatus}');");
							}
						}
					}
				}
            }
		}
        
        if(!$bKindVorhanden)
        {
			$xPost_arr = $_POST;
        	baueArtikelDetail($oVaterArtikel, $xPost_arr);
            $objResponse->assign("contentmid", "innerHTML", $smarty->fetch("tpl_inc/artikel_inc.tpl"));
            $objResponse->script('setBindingsArtikel();');
			$cVariationKombiKind = "{$kEigenschaft}_{$kEigenschaftWert}";
			$objResponse->script("setzeEigenschaftWerte('" . $cVariationKombiKind . "');");

			// Kein Kind vorhanden, gesetzte Werte zurücksetzen
			$_SESSION['oVarkombiAuswahl']->kGesetzteEigeschaftWert_arr = array($kEigenschaft => $kEigenschaftWert);
			
			$kArtikel = intval($aFormValues['a']);
			//$objResponse->script("xajax_checkVarkombiDependencies({$kArtikel}, '', {$kEigenschaft}, {$kEigenschaftWert});");
			checkVarkombiDependencies($kArtikel, '', $kEigenschaft, $kEigenschaftWert, array('objResponse' => $objResponse));
			
			// Nachricht an den Benutzer
			$cMessage = $GLOBALS['oSprache']->gibWert('selectionNotAvailable', 'productDetails');
			$objResponse->script("setBuyfieldMessage('{$cMessage}');");
        }
	}

    // Hook
    executeHook(HOOK_TOOLSAJAXSERVER_PAGE_TAUSCHEVARIATIONKOMBI, array("objResponse" => &$objResponse));

	return $objResponse;
}

function baueArtikelDetail($oArtikel, $xPost_arr)
{    
    global $kKategorie, $Einstellungen, $AktuelleKategorie, $smarty;
    
    //setze seitentyp
    setzeSeitenTyp(PAGE_ARTIKEL);

    // Letzten angesehenden Artikel hinzufügen
    if($Einstellungen['boxen']['box_zuletztangesehen_anzeigen'] == "Y")
        fuegeArtikelZuletzteAngesehenEin($oArtikel->kArtikel, $Einstellungen['boxen']['box_zuletztangesehen_anzahl']);

    //$oArtikel->fGewicht = Trennzeichen::getUnit(JTLSEPARATER_WEIGHT, $_SESSION['kSprache'], $oArtikel->fGewicht);
	//$oArtikel->fArtikelgewicht = Trennzeichen::getUnit(JTLSEPARATER_WEIGHT, $_SESSION['kSprache'], $oArtikel->fArtikelgewicht);

    //Besuch setzen
    //setzeBesuch("kArtikel",$oArtikel->kArtikel);
    $oArtikel->berechneSieSparenX($Einstellungen['artikeldetails']['sie_sparen_x_anzeigen']);
    $Artikelhinweise = array();
    baueArtikelhinweise();

    if (intval($xPost_arr['fragezumprodukt'])==1)
        bearbeiteFrageZumProdukt($oArtikel);
    elseif (intval($xPost_arr['benachrichtigung_verfuegbarkeit'])==1)
        bearbeiteBenachrichtigung($oArtikel);
    elseif (intval($xPost_arr['artikelweiterempfehlen'])==1 && $_SESSION['Kunde']->kKunde > 0)
        bearbeiteArtikelWeiterempfehlen($oArtikel);
    /*
    elseif (intval($xPost_arr['kommentarformular'])==1)
        bearbeiteKommentarFormular($oArtikel,$_SESSION['Kunde']->kKunde);
    */

    //url
    $requestURL = baueURL($oArtikel,URLART_ARTIKEL);
    $sprachURL = baueSprachURLS($oArtikel,URLART_ARTIKEL);

    //hole aktuelle Kategorie, falls eine gesetzt
    $kKategorie = $oArtikel->gibKategorie();
    $AktuelleKategorie = new Kategorie($kKategorie);
    $AufgeklappteKategorien = new KategorieListe();
    $AufgeklappteKategorien->getOpenCategories($AktuelleKategorie);
    $startKat = new Kategorie();
    $startKat->kKategorie=0;

    $arAlleEinstellungen = array_merge($Einstellungen, $GLOBALS["GlobaleEinstellungen"]);

    // Bewertungen holen
    $bewertung_seite = intval(verifyGPCDataInteger('btgseite'));
    $bewertung_sterne = intval(verifyGPCDataInteger('btgsterne'));
    $nAnzahlBewertungen = 0;

   // Hat Artikel einen Preisverlauf?
   $smarty->assign('bPreisverlauf', true);
   if ($Einstellungen['preisverlauf']['preisverlauf_anzeigen'] == "Y")
   {
      require_once(PFAD_CLASSES."class.JTL-Shop.Preisverlauf.php");

      $kArtikel = $oArtikel->kVariKindArtikel > 0 ? $oArtikel->kVariKindArtikel : $oArtikel->kArtikel;

      $oPreisverlauf = new Preisverlauf();
      $oPreisverlauf = $oPreisverlauf->gibPreisverlauf($kArtikel, $oArtikel->Preise->kKundengruppe, intval($Einstellungen['preisverlauf']['preisverlauf_anzahl_monate']));

      if (count($oPreisverlauf) < 2)
         $smarty->assign('bPreisverlauf', false);
   }

    // Sortierung der Bewertungen
    $nSortierung = verifyGPCDataInteger('sortierreihenfolge');

    // Dient zum aufklappen des Tabmenüs
    $bewertung_anzeigen = intval(verifyGPCDataInteger('bewertung_anzeigen'));
    if($bewertung_seite || $bewertung_sterne || $bewertung_anzeigen)
        $BewertungsTabAnzeigen = 1;

    if($bewertung_seite == 0)
        $bewertung_seite = 1;

    // Bewertungen holen
    $oArtikel->holeBewertung($_SESSION['kSprache'], $Einstellungen['bewertung']['bewertung_anzahlseite'], $bewertung_seite, $bewertung_sterne, $Einstellungen['bewertung']['bewertung_freischalten'], $nSortierung);
    $oArtikel->holehilfreichsteBewertung($_SESSION['kSprache']);
    $oArtikel->Bewertungen->Sortierung = $nSortierung;

    if($bewertung_sterne == 0)
        //$nAnzahlBewertungen = $oArtikel->Bewertungen->oBewertungGesamt->nAnzahl;
        $nAnzahlBewertungen = $oArtikel->Bewertungen->nAnzahlSprache;
    else
        $nAnzahlBewertungen = $oArtikel->Bewertungen->nSterne_arr[5-$bewertung_sterne];

    // Baue Blätter Navigation
    $oBlaetterNavi = baueBewertungNavi($bewertung_seite, $bewertung_sterne, $nAnzahlBewertungen, $Einstellungen['bewertung']['bewertung_anzahlseite']);

    // Baue Gewichte für Smarty
    $oTrennzeichen = Trennzeichen::getUnit(JTLSEPARATER_WEIGHT, $_SESSION['kSprache']);
	baueGewicht(array($oArtikel), $oTrennzeichen->getDezimalstellen(), $oTrennzeichen->getDezimalstellen());
    //baueGewicht(array($oArtikel), $Einstellungen['artikeldetails']['artikeldetails_artikelgewicht_stellenanzahl'], $Einstellungen['artikeldetails']['artikeldetails_gewicht_stellenanzahl']);

    //spezifische assigns
    $smarty->assign('Navigation', createNavigation("ARTIKEL", $AufgeklappteKategorien, $oArtikel));
    $smarty->assign('Ueberschrift',$oArtikel->cName);
    $smarty->assign('UeberschriftKlein',$oArtikel->cKurzBeschreibung);
    $smarty->assign('UVPlocalized',gibPreisStringLocalized($oArtikel->fUVP));
    $smarty->assign('Einstellungen',$arAlleEinstellungen);
    $smarty->assign('Artikel', $oArtikel);
    //$smarty->assign('1Artikel',$oArtikel);
    $smarty->assign('Xselling',gibArtikelXSelling($oArtikel->kVariKindArtikel));
    $smarty->assign('requestURL',$requestURL);
    $smarty->assign('sprachURL',$sprachURL);
    $smarty->assign('Artikelhinweise',$Artikelhinweise);
    $smarty->assign('verfuegbarkeitsBenachrichtigung',gibVerfuegbarkeitsformularAnzeigen($oArtikel,$Einstellungen['artikeldetails']['benachrichtigung_nutzen']));
    $smarty->assign('code_fragezumprodukt',generiereCaptchaCode($Einstellungen['artikeldetails']['produktfrage_abfragen_captcha']));
    $smarty->assign('code_kommentarformular',generiereCaptchaCode($Einstellungen['global']['kommentarformular_abfragen_captcha']));
    $smarty->assign('code_benachrichtigung_verfuegbarkeit',generiereCaptchaCode($Einstellungen['artikeldetails']['benachrichtigung_abfragen_captcha']));
    $smarty->assign('ProdukttagHinweis',bearbeiteProdukttags($oArtikel));
    $smarty->assign('ProduktTagging',holeProduktTagging($oArtikel));
    $smarty->assign('BlaetterNavi', $oBlaetterNavi);
    $smarty->assign('BewertungsTabAnzeigen', $BewertungsTabAnzeigen);
    $smarty->assign('hinweis', $cHinweis);
    $smarty->assign('fehler', $cFehler);
    $smarty->assign('nRedirectRecommend', R_LOGIN_ARTIKELWEITEREMPFEHLEN);
    $smarty->assign('PFAD_IMAGESLIDER', URL_SHOP . "/" . PFAD_IMAGESLIDER);
    $smarty->assign('PFAD_MEDIAFILES', URL_SHOP . "/" . PFAD_MEDIAFILES);
    $smarty->assign('PFAD_FLASHPLAYER', URL_SHOP . "/" . PFAD_FLASHPLAYER);
    $smarty->assign('PFAD_BILDER', URL_SHOP . "/" . PFAD_BILDER);
    
    $smarty->assign('KONFIG_ITEM_TYP_ARTIKEL', KONFIG_ITEM_TYP_ARTIKEL);
    $smarty->assign('KONFIG_ITEM_TYP_SPEZIAL', KONFIG_ITEM_TYP_SPEZIAL);

    $smarty->assign('KONFIG_ANZEIGE_TYP_CHECKBOX', KONFIG_ANZEIGE_TYP_CHECKBOX);
    $smarty->assign('KONFIG_ANZEIGE_TYP_RADIO', KONFIG_ANZEIGE_TYP_RADIO);
    $smarty->assign('KONFIG_ANZEIGE_TYP_DROPDOWN', KONFIG_ANZEIGE_TYP_DROPDOWN);
    $smarty->assign('KONFIG_ANZEIGE_TYP_DROPDOWN_MULTI', KONFIG_ANZEIGE_TYP_DROPDOWN_MULTI);
    
    $smarty->assign('FKT_ATTRIBUT_ARTIKELDETAILS_TPL', FKT_ATTRIBUT_ARTIKELDETAILS_TPL);
    $smarty->assign('FKT_ATTRIBUT_ARTIKELKONFIG_TPL', FKT_ATTRIBUT_ARTIKELKONFIG_TPL);
    $smarty->assign('FKT_ATTRIBUT_ARTIKELKONFIG_TPL_JS', FKT_ATTRIBUT_ARTIKELKONFIG_TPL_JS);

    /*
    $arNichtErlaubteEigenschaftswerte = array();
    if ($oArtikel->Variationen)
    {
        foreach ($oArtikel->Variationen as $Variation)
        {
            if ($Variation->Werte && $Variation->cTyp!="FREIFELD")
            {
                foreach ($Variation->Werte as $Wert)
                {
                    $arNichtErlaubteEigenschaftswerte[$Wert->kEigenschaftWert] = gibNichtErlaubteEigenschaftswerte($Wert->kEigenschaftWert);
                }
            }
        }
        $smarty->assign('arNichtErlaubteEigenschaftswerte',$arNichtErlaubteEigenschaftswerte);
    }
    */

    //navi blättern
    if ($Einstellungen['artikeldetails']['artikeldetails_navi_blaettern']=="Y")
    {
            $smarty->assign('NavigationBlaettern',gibNaviBlaettern($oArtikel->kArtikel, $AktuelleKategorie->kKategorie));
    }

    require_once(PFAD_INCLUDES."letzterInclude.php");

    //Meta
    $smarty->assign('meta_title',gibMetaTitle($oArtikel));
    $smarty->assign('meta_description',gibMetaDescription($oArtikel, $AufgeklappteKategorien));
    $smarty->assign('meta_keywords',gibMetaKeywords($oArtikel));

    // Hook
    executeHook(HOOK_TOOLSAJAXSERVER_PAGE_ARTIKELDETAIL);
}

function setSelectionWizardAnswerAjax($kMerkmalWert, $kAuswahlAssistentFrage, $nFrage, $kKategorie)
{
    global $smarty;
    
    require_once(PFAD_ROOT . PFAD_INCLUDES_EXT . "auswahlassistent_ext_inc.php");
    
    $Einstellungen = getEinstellungen(array(CONF_GLOBAL,CONF_RSS,CONF_NAVIGATIONSFILTER,CONF_ARTIKELUEBERSICHT,CONF_AUSWAHLASSISTENT));
    
    $objResponse = new xajaxResponse();
    
    $bMerkmalFilterVorhanden = false;
    $bFragenEnde = false;
    $oSuchergebnisse;
    $NaviFilter;
    processSelectionWizard($kMerkmalWert, $nFrage, $kKategorie, $bFragenEnde, $oSuchergebnisse, $NaviFilter, $bMerkmalFilterVorhanden);
    
    if(!$bFragenEnde && $bMerkmalFilterVorhanden && $oSuchergebnisse->GesamtanzahlArtikel > 1)
    {
        // TPL Changes
        $smarty->assign('Einstellungen', $Einstellungen);
        $smarty->assign('NaviFilter', $NaviFilter);
        $smarty->assign('oAuswahlAssistent', $_SESSION['AuswahlAssistent']->oAuswahlAssistent);
        $objResponse->assign("selection_wizard", "innerHTML", $smarty->fetch("tpl_inc/auswahlassistent_inc.tpl"));
        $objResponse->script("aaDeleteSelectBTN();");
        foreach($_SESSION['AuswahlAssistent']->oAuswahl_arr as $i => $oAuswahl)
        {            
            $cAusgabe = $oAuswahl->cWert;
            if($_SESSION['AuswahlAssistent']->nFrage > $i)
                $cAusgabe .= " <div class='edit' title='" . $GLOBALS['oSprache']->gibWert('edit', 'global') . "' onClick='return resetSelectionWizardAnswer(" . $i . ", " . $kKategorie . ");'></div>";
            
            if($i != $_SESSION['AuswahlAssistent']->nFrage)
                $objResponse->assign("answer_" . $_SESSION['AuswahlAssistent']->oAuswahlAssistent->oAuswahlAssistentFrage_arr[$i]->kAuswahlAssistentFrage, "innerHTML", $cAusgabe);
        }
    }
        
    // Abbruch
    elseif(!$bFragenEnde || $oSuchergebnisse->GesamtanzahlArtikel == 1 || !$bMerkmalFilterVorhanden)
    {        
        if(!$kKategorie)
            unset($_POST["mf1"]);
        $cParameter_arr['MerkmalFilter_arr'] = setzeMerkmalFilter();
        $NaviFilter = baueNaviFilter($NaviFilter, $cParameter_arr);
        //header("Location: " . gibNaviURL($NaviFilter, false, NULL));
        $objResponse->script("window.location.href='" . StringHandler::htmlentitydecode(gibNaviURL($NaviFilter, $GLOBALS['bSeo'], NULL)) . "';");
            
        unset($_SESSION['AuswahlAssistent']);
    }
    
    return $objResponse;
}

function resetSelectionWizardAnswerAjax($nFrage, $kKategorie)
{
    global $smarty;
    
    require_once(PFAD_ROOT . PFAD_INCLUDES_EXT . "auswahlassistent_ext_inc.php");
    
    $Einstellungen = getEinstellungen(array(CONF_GLOBAL,CONF_RSS,CONF_NAVIGATIONSFILTER,CONF_ARTIKELUEBERSICHT,CONF_AUSWAHLASSISTENT));
    
    $objResponse = new xajaxResponse();
        
    $_SESSION['AuswahlAssistent']->nFrage = $nFrage;
    $_SESSION['AuswahlAssistent']->oAuswahlAssistent = AuswahlAssistent::getGroupsByLocation($_SESSION['AuswahlAssistent']->oAuswahlAssistentOrt->cKey, $_SESSION['AuswahlAssistent']->oAuswahlAssistentOrt->kKey, $_SESSION['kSprache']);
    
    // Bereits ausgewaehlte Antworten loeschen
    foreach($_SESSION['AuswahlAssistent']->oAuswahl_arr as $i => $oAuswahl)
    {
        if($i >= $nFrage)
        {
            unset($_SESSION['AuswahlAssistent']->oAuswahl_arr[$i]);
            unset($_SESSION['AuswahlAssistent']->kMerkmalGesetzt_arr[$i]);
        }
    }
    
    // Filter
    $NaviFilter;
    $FilterSQL;
    $oSuchergebnisse;
    $nArtikelProSeite;
    $nLimitN;
    baueFilterSelectionWizard($kKategorie, $NaviFilter, $FilterSQL, $oSuchergebnisse, $nArtikelProSeite, $nLimitN);
    filterSelectionWizard($oSuchergebnisse->MerkmalFilter, $bMerkmalFilterVorhanden);
    
    // TPL Changes
    $smarty->assign('Einstellungen', $Einstellungen);
    $smarty->assign('NaviFilter', $NaviFilter);
    $smarty->assign('oAuswahlAssistent', $_SESSION['AuswahlAssistent']->oAuswahlAssistent);
    $objResponse->assign("selection_wizard", "innerHTML", $smarty->fetch("tpl_inc/auswahlassistent_inc.tpl"));
    $objResponse->script("aaDeleteSelectBTN();");
    foreach($_SESSION['AuswahlAssistent']->oAuswahl_arr as $i => $oAuswahl)
    {        
        if($i < $_SESSION['AuswahlAssistent']->nFrage)
            $objResponse->assign("answer_" . $_SESSION['AuswahlAssistent']->oAuswahlAssistent->oAuswahlAssistentFrage_arr[$i]->kAuswahlAssistentFrage, "innerHTML", $oAuswahl->cWert . " <div class='edit' onClick='return resetSelectionWizardAnswer(" . $i . ", " . $kKategorie . ");'></div>");
    }
    
    return $objResponse;
}

function getValidVarkombis($kVaterArtikel, $kGesetzteEigeschaftWert_arr)
{
	$oKombiFilter_arr = $GLOBALS['DB']->executeQuery("SELECT distinct(teigenschaftkombiwert.kEigenschaftWert) as kEigenschaftWert
														FROM 
														(
															SELECT teigenschaftkombiwert.kEigenschaftKombi
															FROM tartikel
															JOIN teigenschaftkombiwert on teigenschaftkombiwert.kEigenschaftKombi = tartikel.kEigenschaftKombi
															WHERE tartikel.kVaterartikel = " . $kVaterArtikel .	"
																AND teigenschaftkombiwert.kEigenschaftWert IN (" . implode(",", $kGesetzteEigeschaftWert_arr) . ")
															GROUP BY teigenschaftkombiwert.kEigenschaftKombi
															HAVING count(*) = " . count($kGesetzteEigeschaftWert_arr) . "
														) as sub
														JOIN teigenschaftkombiwert ON teigenschaftkombiwert.kEigenschaftKombi = sub.kEigenschaftKombi", 2);
														
	return $oKombiFilter_arr;
}

function checkVarkombiDependencies($kVaterArtikel, $cVaterURL, $kEigenschaft = 0, $kEigenschaftWert = 0, $oParam_arr = array())
{			
	$objResponse;
	if(isset($oParam_arr['objResponse']))
		$objResponse = $oParam_arr['objResponse'];
	else
		$objResponse = new xajaxResponse();
	
	$kVaterArtikel 		= intval($kVaterArtikel);
	$kEigenschaft 		= intval($kEigenschaft);
	$kEigenschaftWert 	= intval($kEigenschaftWert);
	
	$objResponse->script("loescheVarInfo();");
	$objResponse->script("hideBuyfieldMessage();");
	
	if($kVaterArtikel > 0)
	{
		// Grad geklickter Eigenschaftswert in die Session aufnehmen
		if($kEigenschaft > 0 && $kEigenschaftWert > 0)
			$_SESSION['oVarkombiAuswahl']->kGesetzteEigeschaftWert_arr[$kEigenschaft] = $kEigenschaftWert;
		
		// Hole alle Eigenschaften des Artikels
		$oEigenschaft_arr = $GLOBALS['DB']->executeQuery("SELECT * FROM teigenschaft WHERE kArtikel='{$kVaterArtikel}' AND (cTyp = 'RADIO' OR cTyp = 'SELECTBOX') ORDER BY nSort ASC, cName ASC", 2);
		
		// Durchlaufe alle Eigenschaften
		$oEigenschaftWert_arr = array();
		foreach ($oEigenschaft_arr as $i => $oEigenschaft)
			$oEigenschaftWert_arr[$i] = $GLOBALS['DB']->executeQuery("SELECT * FROM teigenschaftwert WHERE kEigenschaft='{$oEigenschaft->kEigenschaft}'", 2);
		
		// Baue mögliche Kindartikel
		$oKombiFilter_arr = gibMoeglicheVariationen($kVaterArtikel, $oEigenschaftWert_arr, $_SESSION['oVarkombiAuswahl']->kGesetzteEigeschaftWert_arr);
		
		if(is_array($oKombiFilter_arr) && count($oKombiFilter_arr) > 0)
		{
			$objResponse->script("schliesseAlleEigenschaftFelder();");
			foreach ($oKombiFilter_arr as $oKombiFilter)
				$objResponse->script("aVC(" . $oKombiFilter->kEigenschaftWert . ");");
		}
		
		// Wenn nur noch eine Variation fehlt
		if ($_SESSION['oVarkombiAuswahl']->nVariationOhneFreifeldAnzahl == count($_SESSION['oVarkombiAuswahl']->kGesetzteEigeschaftWert_arr) + 1)
		{
			$oArtikel = new Artikel();
	   
			$oArtikelOptionen->nMerkmale = 0;
			$oArtikelOptionen->nAttribute = 0;
			$oArtikelOptionen->nArtikelAttribute = 0;
			$oArtikelOptionen->nMedienDatei = 0;
			$oArtikelOptionen->nVariationKombi = 1;
			$oArtikelOptionen->nKeinLagerbestandBeachten = 1;
			$oArtikelOptionen->nKonfig = 0;
			$oArtikelOptionen->nDownload = 0;
			$oArtikelOptionen->nFinanzierung = 0;
			$oArtikelOptionen->nMain = 1;
			$oArtikelOptionen->nWarenlager = 1;
	   
			$oArtikel->fuelleArtikel($kVaterArtikel, $oArtikelOptionen, gibAktuelleKundengruppe(), $_SESSION['kSprache']);
			
			$kGesetzeEigenschaft_arr = array_keys($_SESSION['oVarkombiAuswahl']->kGesetzteEigeschaftWert_arr);
			$kNichtGesetzteEigenschaft_arr = array_values(array_diff($oArtikel->kEigenschaftKombi_arr, $kGesetzeEigenschaft_arr));
			$kNichtGesetzteEigenschaft = (int) $kNichtGesetzteEigenschaft_arr[0];
			
			// hole eigenschaftswerte			
			$oEigenschaftWert_arr = $GLOBALS['DB']->executeQuery("SELECT * FROM teigenschaftwert WHERE kEigenschaft='{$kNichtGesetzteEigenschaft}'", 2);
			
			foreach ($oEigenschaftWert_arr as $oEigenschaftWert)
			{
				$kMoeglicheEigenschaftWert_arr = $_SESSION['oVarkombiAuswahl']->kGesetzteEigeschaftWert_arr;
				$kMoeglicheEigenschaftWert_arr[$kNichtGesetzteEigenschaft] = $oEigenschaftWert->kEigenschaftWert;
				
				$oTMPArtikel = gibArtikelByVariationen($kVaterArtikel, $kMoeglicheEigenschaftWert_arr);
				
				if ($oTMPArtikel && $oTMPArtikel->kArtikel > 0)
				{
					$oTestArtikel = new Artikel();
			   
					$oArtikelOptionen->nMerkmale = 0;
					$oArtikelOptionen->nAttribute = 0;
					$oArtikelOptionen->nArtikelAttribute = 0;
					$oArtikelOptionen->nMedienDatei = 0;
					$oArtikelOptionen->nVariationKombi = 0;
					$oArtikelOptionen->nKeinLagerbestandBeachten = 1;
					$oArtikelOptionen->nKonfig = 0;
					$oArtikelOptionen->nDownload = 0;
					$oArtikelOptionen->nFinanzierung = 0;
					$oArtikelOptionen->nMain = 0;
					$oArtikelOptionen->nWarenlager = 0;
			   
					$oTestArtikel->fuelleArtikel($oTMPArtikel->kArtikel, $oArtikelOptionen, gibAktuelleKundengruppe(), $_SESSION['kSprache']);

					if ($oTestArtikel->cLagerBeachten == 'Y' && $oTestArtikel->cLagerKleinerNull != 'Y' && $oTestArtikel->fLagerbestand == 0)
						$objResponse->script("setzeVarInfo({$oEigenschaftWert->kEigenschaftWert}, '{$oTestArtikel->Lageranzeige->AmpelText}', '{$oTestArtikel->Lageranzeige->nStatus}');");
				}
			}
		}

		// Alle Variationen ausgewaehlt? => Ajax Call und Kind laden
		if($_SESSION['oVarkombiAuswahl']->nVariationOhneFreifeldAnzahl == count($_SESSION['oVarkombiAuswahl']->kGesetzteEigeschaftWert_arr) && count($oParam_arr) == 0)
			$objResponse->script("doSwitchVarkombi('{$kEigenschaft}', '{$kEigenschaftWert}');");
	}

	if(count($oParam_arr) == 0)
		return $objResponse;
}

function gibMoeglicheVariationen($kVaterArtikel, $oEigenschaftWert_arr, $kGesetzteEigeschaftWert_arr)
{
	$oMoeglicheEigenschaften_arr = array();
	
	foreach($oEigenschaftWert_arr as $group) 
	{
		$i = 2;
		$cSQL = array();

		foreach($kGesetzteEigeschaftWert_arr as $kEigenschaft => $kEigenschaftWert) 
		{
			if ($group[0]->kEigenschaft != $kEigenschaft) 
			{
				$cSQL[] = "INNER JOIN teigenschaftkombiwert e{$i} ON e1.kEigenschaftKombi = e{$i}.kEigenschaftKombi AND e{$i}.kEigenschaftWert ={$kEigenschaftWert}";
				$i++;
			}
		}
		
		$cSQLStr = implode(' ', $cSQL);
		
		$oEigenschaft_arr = $GLOBALS['DB']->executeQuery("
			SELECT e1.* FROM teigenschaftkombiwert e1
			{$cSQLStr}
			WHERE e1.kEigenschaft ={$group[0]->kEigenschaft}
			GROUP BY e1.kEigenschaft, e1.kEigenschaftWert", 2);
			
		$oMoeglicheEigenschaften_arr = array_merge($oMoeglicheEigenschaften_arr, $oEigenschaft_arr);
	}
	
	return $oMoeglicheEigenschaften_arr;
}

function gibArtikelByVariationen($kArtikel, $kVariationKombi_arr)
{
	if(is_array($kVariationKombi_arr) && count($kVariationKombi_arr) > 0)
	{
		$j = 0;
		foreach($kVariationKombi_arr as $i => $kVariationKombi)
		{
			if($j > 0)
			{
				$cSQL1 .= "," . $i;
				$cSQL2 .= "," . $kVariationKombi;
			}
			else
			{
				$cSQL1 .= $i;
				$cSQL2 .= $kVariationKombi;
			}

			$j++;
		}
	}

	$oArtikelTMP = $GLOBALS['DB']->executeQuery("SELECT tartikel.kArtikel
													FROM teigenschaftkombiwert
													JOIN tartikel ON tartikel.kEigenschaftKombi = teigenschaftkombiwert.kEigenschaftKombi
													LEFT JOIN tartikelsichtbarkeit ON tartikel.kArtikel = tartikelsichtbarkeit.kArtikel
														AND tartikelsichtbarkeit.kKundengruppe=" . $_SESSION['Kundengruppe']->kKundengruppe . "
													WHERE teigenschaftkombiwert.kEigenschaft IN (" . $cSQL1 . ")
														AND teigenschaftkombiwert.kEigenschaftWert IN (" . $cSQL2 .")
														AND tartikelsichtbarkeit.kArtikel IS NULL
														AND tartikel.kVaterArtikel = " . $kArtikel . "
													GROUP BY tartikel.kArtikel
													HAVING count(*) = " . count($kVariationKombi_arr), 1);
	
	return $oArtikelTMP;
}

$xajax->processRequest();
header("Content-Type:text/html;charset:".JTL_CHARSET.";");
?>