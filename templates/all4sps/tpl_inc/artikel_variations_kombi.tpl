{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
/* Variationkombi Hilfsarray (aktueller Zustand, was aktiviert sein darf) */
var kEigenschaftKombi_arr = new Array();
var nVariationsKombiNichtMoeglich_arr = new Array();
var kAlleEigenschaftKombi_arr = new Array();

{foreach name=varikombi key=key from=$Artikel->nVariationKombiNichtMoeglich_arr item=nVariationKombiNichtMoeglich}
	nVariationsKombiNichtMoeglich_arr[{$key}] = new Array();
	{foreach name=moeglich from=$nVariationKombiNichtMoeglich item=nNichtMoeglich}nVariationsKombiNichtMoeglich_arr[{$key}].push({$nNichtMoeglich});{/foreach}
{/foreach}	

{foreach name=eigenschaftkombi from=$Artikel->kEigenschaftKombi_arr item=kEigenschaftKombi}
	kAlleEigenschaftKombi_arr.push({$kEigenschaftKombi});
{/foreach}

function pruefeEigenschaftKombi(elem, nValue) {ldelim}
	kEigenschaftWert = nValue;
		
	if(kEigenschaftWert == 0) {ldelim}
		loeseAlleEigenschaftFelder(1);
	{rdelim}
	else {ldelim}
		if(kEigenschaftKombi_arr[elem.name.split("_")[1]] > 0) {ldelim}
			if(kEigenschaftKombi_arr[elem.name.split("_")[1]] != kEigenschaftWert) {ldelim}
				kEigenschaftWertLoesen = kEigenschaftKombi_arr[elem.name.split("_")[1]];
				
				for(i=0; i<nVariationsKombiNichtMoeglich_arr[kEigenschaftWertLoesen].length; i++) {ldelim}
					document.getElementById('kEigenschaftWert_' + nVariationsKombiNichtMoeglich_arr[kEigenschaftWertLoesen][i]).disabled = false;
				{rdelim}
				
				kEigenschaftKombi_arr[elem.name.split("_")[1]] = kEigenschaftWert;
			{rdelim}
		{rdelim}
		else
			kEigenschaftKombi_arr[elem.name.split("_")[1]] = kEigenschaftWert;
		
		if(kEigenschaftWert > 0) {ldelim}
			for(i=0; i<nVariationsKombiNichtMoeglich_arr[kEigenschaftWert].length; i++) {ldelim}
				document.getElementById('kEigenschaftWert_' + nVariationsKombiNichtMoeglich_arr[kEigenschaftWert][i]).disabled = true;
			{rdelim}
		{rdelim}
		
		if(pruefeKombiAusgefuellt() && kEigenschaftWert > 0) {ldelim}
         myCallback = xajax.callback.create();
         myCallback.onFailure = function(args) {ldelim}
            console.log(args); 
         {rdelim}
         xajax.call('tauscheVariationKombi', {ldelim} parameters: [xajax.getFormValues('buy_form')], callback: myCallback {rdelim} );
			return onLoading();
		{rdelim}
	{rdelim}
{rdelim}

function onLoading() {ldelim}
   $('#article_buyfield :input').each(function(idx, item) {ldelim}
      $(item).attr('disabled', true);
   {rdelim});
   $('#article_buyfield .submit').attr('disabled', true);
   $('#article_buyfield .submit').addClass('disabled');
   $('#article_buyfield .loader').fadeIn("slow");
   return false;
{rdelim}

function graueNichtMoeglicheEigenschaftWerteAus(cVariationKombiKind) {ldelim}
	var kVariationKombiKind_arr = cVariationKombiKind.split(";");

	if(kVariationKombiKind_arr.length > 0) {ldelim}
		for(var i=0; i<kVariationKombiKind_arr.length; i++) {ldelim}
			var kEigenschaftWert = kVariationKombiKind_arr[i].split("_")[1];
			
			for(var j=0; j<nVariationsKombiNichtMoeglich_arr[kEigenschaftWert].length; j++) {ldelim}
				document.getElementById('kEigenschaftWert_' + nVariationsKombiNichtMoeglich_arr[kEigenschaftWert][j]).disabled = true;
			{rdelim}
		{rdelim}
	{rdelim}
{rdelim}

function loeseAlleEigenschaftFelder(nWaehlen) {ldelim}
	var oVariationTable = document.getElementById('article_buyfield');
	
	if(typeof oVariationTable != "undefined") {ldelim}
		var oOption_arr = oVariationTable.getElementsByTagName('option');
		var oInput_arr = oVariationTable.getElementsByTagName('input');
		
		for(var i=0; i<oOption_arr.length; i++) {ldelim}
			oOption_arr[i].disabled = false;
			if(oOption_arr[i].value == 0)
				oOption_arr[i].selected = true;
		{rdelim}	
			
		for(var i=0; i<oInput_arr.length; i++) {ldelim}
			oInput_arr[i].disabled = false;
			oInput_arr[i].checked = false;
		{rdelim}
	{rdelim}
	
	kEigenschaftKombi_arr = new Array();
    
    if(nWaehlen > 0) {ldelim}
        xajax_tauscheVariationKombi(xajax.getFormValues('buy_form'), nWaehlen);
        return false;  
    {rdelim}
{rdelim}

function schliesseAlleEigenschaftFelder() {ldelim}

	var oVariationTable = document.getElementById('article_buyfield');
	
	if(oVariationTable && typeof oVariationTable != "undefined") {ldelim}
		var oOption_arr = oVariationTable.getElementsByTagName('option');
		var oInput_arr = oVariationTable.getElementsByTagName('input');
		
		for(var i=0; i<oOption_arr.length; i++) {ldelim}
			if(oOption_arr[i].id != "waehlen") {ldelim}
				$(oOption_arr[i]).addClass('variation_disabled');
				$(oOption_arr[i]).parent().addClass('variation_disabled');
				//oOption_arr[i].disabled = true;
				{rdelim}
		{rdelim}
	
		for(var i=0; i<oInput_arr.length; i++) {ldelim}
			if(oInput_arr[i].name != "waehlen" && oInput_arr[i].type != "text" && oInput_arr[i].type != "hidden") {ldelim}
				$(oInput_arr[i]).addClass('variation_disabled');
				$(oInput_arr[i]).parent().addClass('variation_disabled');
				//oInput_arr[i].disabled = true;
				{rdelim}
		{rdelim}
	{rdelim}
{rdelim}

function pruefeKombiAusgefuellt() {ldelim}
	if(typeof kAlleEigenschaftKombi_arr != "undefined" && typeof kEigenschaftKombi_arr != "undefined") {ldelim}	
		for(i=0; i < kAlleEigenschaftKombi_arr.length; i++) {ldelim}	
			if(kEigenschaftKombi_arr[kAlleEigenschaftKombi_arr[i]] == 0 || !kEigenschaftKombi_arr[kAlleEigenschaftKombi_arr[i]])
				return false;
		{rdelim}
	{rdelim}
	
	return true;
{rdelim}

function loeseEigenschaftFeld(kEigenschaft) {ldelim}
	if(document.getElementById('eigenschaftwert_' + kEigenschaft)) {ldelim}
		for(i=0; i<document.getElementById('eigenschaftwert_' + kEigenschaft).childNodes.length; i++)
			document.getElementById('eigenschaftwert_' + kEigenschaft).childNodes[i].disabled = false;
	{rdelim}
	else {ldelim}
		elem_arr = document.getElementsByName('eigenschaftwert_' + kEigenschaft);
		for(j=0; j<elem_arr.length; j++)
			elem_arr[j].disabled = false;
	{rdelim}
{rdelim}

<!-- Aktiviere alle moeglichen Kombinationen -->
{if isset($oKombiVater_arr) && $oKombiVater_arr|@count > 0}
	$(document).ready(function() {ldelim}
		schliesseAlleEigenschaftFelder();
	
		{foreach name=vaterkombioption from=$oKombiVater_arr item=oKombiVater}
			aVC({$oKombiVater->kEigenschaftWert});
		{/foreach}
	{rdelim});
{/if}

function doSwitchVarkombi(kEigenschaft, kEigenschaftWert, bSpeichern) {ldelim}
	myCallback = xajax.callback.create();
	myCallback.onFailure = function(args) {ldelim}
		console.log(args); 
	{rdelim}
	xajax.call('tauscheVariationKombi', {ldelim} parameters: [xajax.getFormValues('buy_form'), 0, kEigenschaft, kEigenschaftWert, bSpeichern], callback: myCallback {rdelim} );
		return onLoading();
{rdelim}