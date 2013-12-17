{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}

{if isset($a2) && $a2 > 0} 
<script type="text/javascript">
$(document).ready(function() {ldelim}
    schliesseAlleEigenschaftFelder();
{foreach from=$Artikel->oVariationKombi_arr item=oVariationKombi}
    aVC({$oVariationKombi->kEigenschaftWert});
{/foreach}
{rdelim});
</script>
{/if}
 
{if $hinweis}
   <p class="box_success">
      {$hinweis}
   </p>
{/if}

{if $fehler}
   <p class="box_error">
      {$fehler}
   </p>
{/if}

{if strlen($ProdukttagHinweis) > 0}
   <p class="box_success">{$ProdukttagHinweis}</p>
{/if}

{if count($Artikelhinweise)>0}
{foreach name=hinweise from=$Artikelhinweise item=Artikelhinweis}
   <p class="box_info">{$Artikelhinweis}</p>
{/foreach}
{/if}

<div id="article">

   {if $Einstellungen.artikeldetails.artikeldetails_navi_blaettern=="Y"}
   <div class="article_navigator">
      <span class="prev_article">
         {if $NavigationBlaettern->vorherigerArtikel->kArtikel}<a href="{$NavigationBlaettern->vorherigerArtikel->cURL}" title="{lang key="previousProduct" section="productDetails"}: {$NavigationBlaettern->vorherigerArtikel->cName}">&nbsp;</a>{/if}
      </span>
      <span class="next_article">
         {if $NavigationBlaettern->naechsterArtikel->kArtikel}<a href="{$NavigationBlaettern->naechsterArtikel->cURL}" title="{lang key="nextProduct" section="productDetails"}: {$NavigationBlaettern->naechsterArtikel->cName}">&nbsp;</a>{/if}
      </span>
   </div>
   <div class="clear"></div>
   {/if}

   <form id="buy_form" name="buy_form" method="post" action="index.php" onsubmit="return checkVarCombi();">
   <div class="outer"> 
   {* sollte enter gedrückt werden soll der Warenkorb-Button als erstes gesendet werden *}
   <input type="submit" name="inWarenkorb" value="1" class="hidden" />
   <input type="hidden" id="AktuellerkArtikel" name="a" value="{$Artikel->kArtikel}" />
   {if $Artikel->kArtikelVariKombi > 0}
   <input type="hidden" name="aK" value="{$Artikel->kArtikelVariKombi}" />
   {/if}
   <input type="hidden" name="wke" value="1" />
   <input type="hidden" name="show" value="1" />
   <input type="hidden" name="kKundengruppe" value="{$smarty.session.Kundengruppe->kKundengruppe}" />
   <input type="hidden" name="kSprache" value="{$smarty.session.kSprache}" />
   <input type="hidden" name="{$session_name}" value="{$session_id}" />

   <!-- image -->
   <div id="image_wrapper" class="article_image">
      <div class="image">
         {if $Artikel->Bilder[0]->cPfadNormal ne "gfx/keinBild.gif"}<a href="{$Artikel->Bilder[0]->cPfadGross}" class="fancy-gallery {if $Einstellungen.template.articledetails.image_zoom_method == 'Z' || $Einstellungen.template.articledetails.image_zoom_method == 'ZL'}cloud-zoom{/if}" id="zoom1" rel="title: '{lang key='clicktozoom' section='productDetails'}', adjustX: 10, adjustY: 0, smoothMove:5, zoomWidthWrapper: '.article_details'">{/if}
            <img src="{$Artikel->Bilder[0]->cPfadNormal}" id="image0" class="thumbnail photo" title="{$Artikel->cName|strip_tags|escape:"quotes"|truncate:60}" alt="" />
         {if $Artikel->Bilder[0]->cPfadNormal ne "gfx/keinBild.gif"}</a>{/if}
      </div>
      
      {if $Artikel->Bilder|@count > 1}
         <div class="article_images">
         {foreach name=article_image from=$Artikel->Bilder item=oBild}
            <a href="{$oBild->cPfadGross}" class="fancy-gallery {if $Einstellungen.template.articledetails.image_zoom_method == 'Z' || $Einstellungen.template.articledetails.image_zoom_method == 'ZL'}cloud-zoom-gallery{/if}" title="" rel="useZoom: 'zoom1', smallImage: '{$oBild->cPfadNormal}'">
               <img src="{$oBild->cPfadMini}" {if $smarty.foreach.article_image.index == 0}class="active"{/if} alt="" />
            </a>
         {/foreach}
		 <span style="float:left;margin-left:0px;max-width:300px;font-size:0.7em">{lang key="bilderHinweisTextArtikelDetail" section="global"}</span>
         </div>
	  {else}
		 <span style="float:left;margin-left:0px;max-width:300px;font-size:0.7em">{lang key="bilderHinweisTextArtikelDetail" section="global"}</span>
      {/if}
      
      <!-- variationsbilder -->
      {if $Artikel->oVariationKombiVorschau_arr|@count > 0 && $Artikel->oVariationKombiVorschau_arr}
      <div class="article_varcombi">
         <p>{$Artikel->oVariationKombiVorschauText}</p>
         <ul class="hlist">
            {foreach name=kombikindervorschau from=$Artikel->oVariationKombiVorschau_arr item=oVariationKombiVorschau}
               <li><a href="{$oVariationKombiVorschau->cURL}"><img src="{$oVariationKombiVorschau->cBildMini}" alt="" /></a></li>
            {/foreach}
         </ul>
      </div>
      {/if}
   </div>

   <!-- right -->
   <div class="article_details">
      
      
            <div class="branditem">
               {if $Artikel->cHersteller && $Einstellungen.artikeldetails.artikeldetails_hersteller_anzeigen != "N"}
               <ul class="values">   
                  {if $Einstellungen.artikeldetails.artikeldetails_hersteller_anzeigen == "Y" && $Artikel->cHersteller}
                     <li>{if $Einstellungen.artikeldetails.artikel_weitere_artikel_hersteller_anzeigen=="Y"}<span class="otherProductsFromManufacturer"><a href="{$Artikel->cHerstellerURL}">{$Artikel->cHersteller}</a></span>{/if}</li>
                  {elseif $Einstellungen.artikeldetails.artikeldetails_hersteller_anzeigen == "BT" && $Artikel->cHersteller && $Artikel->cHerstellerBildKlein}
                     <li class="vmiddle"><a href="{$Artikel->cHerstellerURL}"><img src="{$Artikel->cHerstellerBildKlein}" class="vmiddle" /> {$Artikel->cHersteller}</a></li>
                  {elseif $Einstellungen.artikeldetails.artikeldetails_hersteller_anzeigen == "B" && $Artikel->cHerstellerBildKlein}
                     <li class="vmiddle"><a href="{$Artikel->cHerstellerURL}"><img src="{$Artikel->cHerstellerBildKlein}" class="vmiddle" /></a></li>
                  {/if}
               </ul>
               {/if}
            </div>
            
      <h1 class="fn">{$Artikel->cName}</h1>

      <div class="left p50">
         <ul class="article_list">
            <p><span class="stars p{$Artikel->fDurchschnittsBewertung|replace:'.':'_'}"></span></p>
            
            {assign var=anzeige value=$Einstellungen.artikeldetails.artikel_lagerbestandsanzeige}
            {if !$Artikel->nErscheinendesProdukt}
               {if $Artikel->cLagerBeachten == "Y" && ($Artikel->cLagerKleinerNull == "N" || $Einstellungen.artikeldetails.artikeldetails_lieferantenbestand_anzeigen == 'U') && $Artikel->fLagerbestand <= 0 && $Artikel->fZulauf > 0 && isset($Artikel->dZulaufDatum_de)}
                  {assign var=cZulauf value=`$Artikel->fZulauf`:::`$Artikel->dZulaufDatum_de`}
                  <li>
                      <span class="signal_image a1">{lang key="productInflowing" section="productDetails" printf=$cZulauf}</span>
                  </li>
               {elseif $Einstellungen.artikeldetails.artikeldetails_lieferantenbestand_anzeigen != 'N' && $Artikel->cLagerBeachten == "Y" && $Artikel->fLagerbestand <= 0 && $Artikel->fLieferantenlagerbestand > 0 && $Artikel->fLieferzeit > 0 && ($Artikel->cLagerKleinerNull == "N" || $Einstellungen.artikeldetails.artikeldetails_lieferantenbestand_anzeigen == 'U')}
                  <li>
                      <span class="signal_image a1">{lang key="supplierStockNotice" section="global" printf=$Artikel->fLieferzeit}</span>
                  </li>
               {elseif $anzeige=='verfuegbarkeit' || $anzeige=='genau'}
                  <li>
                      <span class="signal_image a{$Artikel->Lageranzeige->nStatus}">{$Artikel->Lageranzeige->cLagerhinweis[$anzeige]}</span>
                  </li>
               {elseif $anzeige=='ampel'}
                  <li>
                      <span class="signal_image a{$Artikel->Lageranzeige->nStatus}">{$Artikel->Lageranzeige->AmpelText}</span>
                  </li>
               {/if}
               <li>
                   {include file="tpl_inc/artikel_warenlager.tpl" scope="detail"}
               </li>
            {/if}
            
			
			{* A Smarty comment - ODM, 12/08/2013, Biker City & All For SPS: Do Not Show Product Number if HAN is not blank in WAWI ERP *}
			 {if $Artikel->cHAN !=""}
				<li><font color="#000000"><strong>{lang key="productHAN" section="global"}:</strong> <span id="hanArtNr">{$Artikel->cHAN}</span></font></li>
			 {else}
				<li><font color="#000000"><strong>{lang key="productNo" section="global"}:</strong> <span id="artnr">{$Artikel->cArtNr}</span></font></li>
			 {/if}
            <li><strong>{lang key="Herkunftsland" section="global"}:</strong> <span id="artnr">{$Artikel->cHerkunftsland}</span></li>
            
            {if isset($Artikel->dMHD) && isset($Artikel->dMHD_de)}
               <li title="{lang key='productMHDTool' section='global'}" class="best-before"><strong>{lang key="productMHD" section="global"}:</strong> {$Artikel->dMHD_de}</li>
            {/if}
            
            {if $Artikel->FunktionsAttribute[$FKT_ATTRIBUT_INHALT]|@strlen > 0}
               <li><strong>{lang key="content" section="productDetails"}:</strong> {$Artikel->FunktionsAttribute[$FKT_ATTRIBUT_INHALT]}</li>
            {/if}
            
            {if $Einstellungen.artikeldetails.artikeldetails_packeinheit_anzeigen=='Y' && $Artikel->fPackeinheit!=1}
               <li><b>{lang key="packaging" section="productDetails"}</b>: {$Artikel->fPackeinheit|replace:".":","}</li>
            {/if}
      
            {if $Artikel->cGewicht && $Einstellungen.artikeldetails.artikeldetails_gewicht_anzeigen=='Y' && $Artikel->fGewicht > 0}
               <li><b>{lang key="shippingWeight" section="global"}</b>: <span id="shippingweight">{$Artikel->cGewicht}</span> {if #weight_unit# == "unit" && $Artikel->cEinheit!=''}{$Artikel->cEinheit}{elseif #weight_unit# != ""}{lang key="weight_unit" section=""}{else}kg{/if}</li>
            {/if}
            {if $Artikel->cArtikelgewicht && $Einstellungen.artikeldetails.artikeldetails_artikelgewicht_anzeigen=='Y' && $Artikel->fArtikelgewicht > 0}
                  <li><b>{lang key="productWeight" section="global"}</b>: <span id="weight">{$Artikel->cArtikelgewicht}</span> {if #weight_unit# == "unit" && $Artikel->cEinheit!=''}{$Artikel->cEinheit}{elseif #weight_unit# != ""}{lang key="weight_unit" section=""}{else}kg{/if}</li>
            {/if}
            {if $Artikel->cLieferstatus && ($Einstellungen.artikeldetails.artikeldetails_lieferstatus_anzeigen=='Y' || ($Einstellungen.artikeldetails.artikeldetails_lieferstatus_anzeigen=='L' && $Artikel->fLagerbestand == 0 && $Artikel->cLagerBeachten == 'Y') || ($Einstellungen.artikeldetails.artikeldetails_lieferstatus_anzeigen=='A' && ($Artikel->fLagerbestand > 0 || $Artikel->cLagerKleinerNull == 'Y' || $Artikel->cLagerBeachten != 'Y')))}
                  <li><b>{lang key="shippingTime" section="global"}</b>: {$Artikel->cLieferstatus}</li>                  
            {/if}
            {if $Artikel->fMindestbestellmenge>1}
                  <li><b>{lang key="mbm" section="productDetails"}</b>: {$Artikel->fMindestbestellmenge} {$Artikel->cEinheit}</li>
            {/if}
            {if $Einstellungen.artikeldetails.artikeldetails_artikelintervall_anzeigen == "Y" && $Artikel->fAbnahmeintervall > 1}
                  <li><b>{lang key="purchaseIntervall" section="productDetails" alt_section="productOverview,"}</b>: {$Artikel->fAbnahmeintervall} {$Artikel->cEinheit}</li>
            {/if}
            
            <li>
               <ul class="actions">
                  {assign var=kArtikel value=$Artikel->kArtikel}
                  {if $Artikel->kArtikelVariKombi > 0}
                     {assign var=kArtikel value=$Artikel->kArtikelVariKombi}
                  {/if}
                  {if $Einstellungen.artikeldetails.artikeldetails_vergleichsliste_anzeigen == "Y"}                                                                
                     <li><button name="Vergleichsliste" type="submit" class="compare" tabindex="3"><span>{lang key="addToCompare" section="productDetails"}</span></button></li>
                  {/if}
                  {if $Einstellungen.global.global_wunschliste_anzeigen == 'Y'}
                  <li><button name="Wunschliste" type="submit" class="wishlist">{lang key="addToWishlist" section="productDetails"}</button></li>
                  {/if}
                  {if $Einstellungen.artikeldetails.artikeldetails_fragezumprodukt_anzeigen=="P"}
                     <li><button type="button" id="z{$kArtikel}" class="popup question">{lang key="productQuestion" section="productDetails"}</button></li>
                  {/if}
                  {if ($verfuegbarkeitsBenachrichtigung == 2 || $verfuegbarkeitsBenachrichtigung == 3) && (($Artikel->cLagerBeachten == 'Y' && $Artikel->cLagerKleinerNull != 'Y') || $Artikel->cLagerBeachten != 'Y')}
                     <li><button type="button" id="n{$kArtikel}" class="popup notification">{lang key="requestNotification" section="global"}</button></li>
                  {/if}
                  {if $Einstellungen.artikeldetails.artikeldetails_artikelweiterempfehlen_anzeigen == "P"}
                     <li><button type="button" id="w{$kArtikel}" class="popup advise">{lang key="recommendProduct" section="productDetails"}</button></li>
                  {/if}
                  {* ie fix *}
                  <li class="hidden"><button type="submit" name="inWarenkorb" value="1" class="hidden"></button></li>
               </ul>
            </li>
         </ul>
      </div>
      <div class="left p50 tright">
         <ul class="article_list">
            {if $smarty.session.Kundengruppe->darfPreiseSehen}
               
               {if $Artikel->Preise->fVKNetto==0 && $Einstellungen.global.global_preis0=="N"}
                  <li>{lang key="priceOnApplication" section="global"}</li>
               {else}
                  {if $Artikel->Preise->rabatt>0 && !$Artikel->Preise->Sonderpreis_aktiv}
                     {if $Einstellungen.artikeldetails.artikeldetails_rabattanzeige==2 || $Einstellungen.artikeldetails.artikeldetails_rabattanzeige==4}
                     <li><small>{lang key="discount" section="global"}: {$Artikel->Preise->rabatt}%</small></li>
                     {/if}
                     {if $Einstellungen.artikeldetails.artikeldetails_rabattanzeige==3 || $Einstellungen.artikeldetails.artikeldetails_rabattanzeige==4}
                     <li><small>{lang key="oldPrice" section="global"}: <del>{$Artikel->Preise->alterVKLocalized[$NettoPreise]}</del></small></li>
                     {/if}
                  {/if}
                  {if $Artikel->Preise->Sonderpreis_aktiv && $Einstellungen.artikeldetails.artikeldetails_sonderpreisanzeige==2}
                     <li><b>{lang key="insteadOf" section="global"}:</b> <del>{$Artikel->Preise->alterVKLocalized[$NettoPreise]}</del></li>
                  {/if}        
                  <li><span class="price_label">{if $Artikel->oKonfig_arr}{lang key="priceAsConfigured" section="productDetails"}{elseif $Artikel->Preise->Sonderpreis_aktiv}{lang key="specialPrice" section="global"}{else}{lang key="ourPrice" section="productDetails"}{/if}: </span>{if $Artikel->Preise->strPreisGrafik_Detail}<span class="price_image">{$Artikel->Preise->strPreisGrafik_Detail}</span>{else}<span class="price updateable" id="price">{if $Artikel->Preise->fVKNetto==0 && $Artikel->bHasKonfig}{lang key="priceAsConfigured" section="productDetails"}{else}{$Artikel->Preise->cVKLocalized[$NettoPreise]}{/if}</span>{if $Artikel->fAbnahmeintervall > 1 && $Artikel->cEinheit}<span class="per_unit"> {lang key="vpePer" section="global"} 1 {$Artikel->cEinheit}</span>{/if}</li>{/if}
                  {if $Artikel->cLocalizedVPE}
                     <li><small><b>{lang key="basePrice" section="global"}:</b> <span class="price_base updateable">{$Artikel->cLocalizedVPE[$NettoPreise]}</span></small></li>
                  {/if}
                  <li><span class="vat_info">{$Artikel->cMwstVersandText}</span></li>
                  {if $Einstellungen.artikeldetails.artikeldetails_uvp_anzeigen=='Y' && $Artikel->fUVP>0}
                     <li><small>{lang key="suggestedPrice" section="productDetails"}: {$UVPlocalized}{if $NettoPreise} ({$UVPBruttolocalized} {lang key="gross" section="global"}){/if}</small></li>
                  {/if}
                  {if $Artikel->Preise->fPreis1>0 && $Artikel->Preise->nAnzahl1>0}
                     {include file='tpl_inc/staffelpreise_inc.tpl'}
                  {else}
                     {if $Artikel->SieSparenX->anzeigen==1 && $Artikel->SieSparenX->nProzent > 0}
                        <li><small>{lang key="youSave" section="productDetails"} {$Artikel->SieSparenX->nProzent}%, {lang key="thatIs" section="productDetails"} {$Artikel->SieSparenX->cLocalizedSparbetrag}</small></li>
                     {/if}
                  {/if}
               {/if}
            {else}
               {lang key="priceHidden" section="global"}
            {/if}
            {if isset($Einstellungen.template.general.addthis_url) && $Einstellungen.template.general.addthis_url|@strlen > 0}
            <li class="addthis">
               <p class="addthis_toolbox addthis_default_style right">
                  <a class="addthis_counter addthis_pill_style"></a>
               </p>
               <script type="text/javascript" src="{$Einstellungen.template.general.addthis_url}"></script>
            </li>
            {/if}
         </ul>
      </div>
      {literal}
      <script>
	  function setZustandWert(fooValueElement) {
		   fooAVar = $('.variation option:selected').text();
		   setTimeout(function(){verzeogereZustandsAnzeige(fooAVar)}, 10000);
		  }
		  
	  function verzeogereZustandsAnzeige(wertToPutInnerHTML) {
		  $('#zustandsWert').html(wertToPutInnerHTML);
		  var strToCheck = wertToPutInnerHTML;
		  var strMonth = '{/literal}{lang key="rma_month" section="rma"}{literal}';
		  if(strToCheck.indexOf('GEBRAUCHT') == -1) {
				  $('#garantieDauer').html('6 ' + strMonth);
			  }
		  else {
				  $('#garantieDauer').html('3 ' + strMonth);
			  }
		  }
	  </script>
      {/literal}
      
      <div class="clear"></div>

      <!-- finanzierung -->
      {if $Artikel->inWarenkorbLegbar==1}
         {if isset($Einstellungen.artikeldetails.artikeldetails_finanzierung_anzeigen) && $Einstellungen.artikeldetails.artikeldetails_finanzierung_anzeigen == "Y"}
            <div class="financing tleft" id="commerz_financing" {if !isset($Artikel->oRateMin)}style="display:none"{/if}>
               {include file="tpl_inc/artikel_finanzierung.tpl"}
            </div>
         {/if}
      {/if}
      
      <!-- warenkorb -->
      {if ($Artikel->inWarenkorbLegbar == 1 || $Artikel->nErscheinendesProdukt == 1) && !$Artikel->bHasKonfig || $Artikel->Variationen}
         <div id="article_buyfield"{if $Artikel->nErscheinendesProdukt} class="coming_soon"{/if}>
            <div class="loader">{lang key="ajaxLoading" section="global"}</div>
            <div class="message"><p></p></div>
            <fieldset class="article_buyfield">
               
               {if $Artikel->nErscheinendesProdukt}
                  <div class="{if $Einstellungen.global.global_erscheinende_kaeuflich == "Y"}box_plain{/if} tcenter">
                     {lang key="productAvailableFrom" section="global"}: <strong>{$Artikel->Erscheinungsdatum_de}</strong>
                     {if $Einstellungen.global.global_erscheinende_kaeuflich == "Y"}
                        ({lang key="preorderPossible" section="global"})
                     {/if}
                  </div>
               {/if}

               {if isset($Artikel->Variationen) && $Artikel->Variationen|@count > 0}  
                  <div class="variations">
                  {foreach name=Variationen from=$Artikel->Variationen key=i item=Variation}
                     <ul>
                        <li class="label">{$Variation->cName}</li>
                        {if $Variation->cTyp=="SELECTBOX"}
                           <li>
                              <select class="variation required" id="eigenschaftwert_{$Variation->kEigenschaft}" name="eigenschaftwert_{$Variation->kEigenschaft}" onchange="{strip}
                              	  setZustandWert(eigenschaftwert_{$Variation->kEigenschaft});
                                 {if $Artikel->nIstVater != 1}
                                    var_sel({$Variation->kEigenschaft});
                                 {/if} 
                                 {if !$Artikel->Preise->strPreisGrafik_Detail}
                                    aktualisierePreis(); 
                                    aktualisiereGewicht(); 
                                    aktualisiereArtikelnummer($(this.form.eigenschaftwert_{$Variation->kEigenschaft}.options[this.form.eigenschaftwert_{$Variation->kEigenschaft}.selectedIndex]).attr('ref'));
                                 {/if} 
                                 {if $Artikel->nIstVater == 1}
                                    xajax_checkVarkombiDependencies({$Artikel->kArtikel}, '{$Artikel->cURL}', {$Variation->kEigenschaft}, this.options[this.options.selectedIndex].value);
                                 {/if}
                                 {/strip}">
                                 <option value="0">{lang key="pleaseChooseVariation" section="productDetails"}</option>
                                 {foreach name=Variationswerte from=$Variation->Werte key=y item=Variationswert}
                                    {if ($Artikel->kVaterArtikel > 0 || $Artikel->nIstVater == 1) && $Artikel->nVariationOhneFreifeldAnzahl == 1 && $Einstellungen.global.artikeldetails_variationswertlager == 3 && $Artikel->VariationenOhneFreifeld[$i]->Werte[$y]->nNichtLieferbar == 1}
                                       {* mach nix *}
                                    {else}
                                       <option id="kEigenschaftWert_{$Variationswert->kEigenschaftWert}" value="{$Variationswert->kEigenschaftWert}" ref="{$Variationswert->cArtNr}">
                                       {$Variationswert->cName}
                                       {if ($Artikel->kVaterArtikel > 0 || $Artikel->nIstVater==1)}
                                          {if $Artikel->nVariationOhneFreifeldAnzahl == 1}
                                             {assign var=kEigenschaftWert value=`$Variationswert->kEigenschaftWert`}
                                             {if $Einstellungen.artikeldetails.artikel_variationspreisanzeige == 1}
                                                {if isset($Artikel->oVariationDetailPreis_arr[$kEigenschaftWert]->Preise->cAufpreisLocalized[$NettoPreise])}
                                                   ({$Artikel->oVariationDetailPreis_arr[$kEigenschaftWert]->Preise->cAufpreisLocalized[$NettoPreise]}
                                                {/if}
                                                {if $Artikel->oVariationDetailPreis_arr[$kEigenschaftWert]->Preise->PreisecPreisVPEWertInklAufpreis[$NettoPreise]|count_characters > 0}
                                                   , {$Artikel->oVariationDetailPreis_arr[$kEigenschaftWert]->Preise->PreisecPreisVPEWertInklAufpreis[$NettoPreise]}
                                                {/if}
                                                {if isset($Artikel->oVariationDetailPreis_arr[$kEigenschaftWert]->Preise->cAufpreisLocalized[$NettoPreise])}){/if}
                                             {elseif $Einstellungen.artikeldetails.artikel_variationspreisanzeige == 2}
                                                ({$Artikel->oVariationDetailPreis_arr[$kEigenschaftWert]->Preise->cVKLocalized[$NettoPreise]}{if $Artikel->oVariationDetailPreis_arr[$kEigenschaftWert]->Preise->PreisecPreisVPEWertInklAufpreis[$NettoPreise]|count_characters > 0}, {$Artikel->oVariationDetailPreis_arr[$kEigenschaftWert]->Preise->PreisecPreisVPEWertInklAufpreis[$NettoPreise]}{/if})
                                             {/if}
                                          {/if}   
                                       {else}
                                          {if $Einstellungen.artikeldetails.artikel_variationspreisanzeige==1 && $Variationswert->fAufpreisNetto!=0}                       
                                             ({$Variationswert->cAufpreisLocalized[$NettoPreise]}{if $Variationswert->cPreisVPEWertAufpreis[$NettoPreise]|count_characters > 0}, {$Variationswert->cPreisVPEWertAufpreis[$NettoPreise]}{/if})
                                          {elseif $Einstellungen.artikeldetails.artikel_variationspreisanzeige==2 && $Variationswert->fAufpreisNetto!=0}                       
                                             ({$Variationswert->cPreisInklAufpreis[$NettoPreise]}{if $Variationswert->cPreisVPEWertInklAufpreis[$NettoPreise]|count_characters > 0}, {$Variationswert->cPreisVPEWertInklAufpreis[$NettoPreise]}{/if})
                                          {/if}
                                       {/if}
                                       </option>
                                    {/if}
                                 {/foreach}
                                 </select>
                              </li>
                           {elseif $Variation->cTyp=="RADIO"}
                              {foreach name=Variationswerte from=$Variation->Werte key=y item=Variationswert}
                           {if ($Artikel->kVaterArtikel > 0 || $Artikel->nIstVater == 1) && $Artikel->nVariationOhneFreifeldAnzahl == 1 && $Einstellungen.global.artikeldetails_variationswertlager == 3 && $Artikel->VariationenOhneFreifeld[$i]->Werte[$y]->nNichtLieferbar == 1}
                              {* mach nix *}
                           {else}
                           <li>
                              <label class="block" for="kEigenschaftWert_{$Variationswert->kEigenschaftWert}">
                                 <input type="radio" name="eigenschaftwert_{$Variation->kEigenschaft}" id="kEigenschaftWert_{$Variationswert->kEigenschaftWert}" class="required" value="{$Variationswert->kEigenschaftWert}" onclick="{strip}
                                     {if $Variationswert->cBildPfad && $Artikel->nIstVater != 1}
                                        var_bild({$Variationswert->kEigenschaftWert});
                                     {/if} 
                                     {if $Artikel->nIstVater == 1}
                                        xajax_checkVarkombiDependencies({$Artikel->kArtikel}, '{$Artikel->cURL}', {$Variationswert->kEigenschaft}, {$Variationswert->kEigenschaftWert});
                                     {/if} 
                                     {if !$Artikel->Preise->strPreisGrafik_Detail}
                                        aktualisierePreis(); 
                                        aktualisiereGewicht(); 
                                        aktualisiereArtikelnummer('{$Variationswert->cArtNr}');
                                     {/if}
                                     {/strip}" /><span> {$Variationswert->cName}
                              {if ($Artikel->kVaterArtikel > 0 || $Artikel->nIstVater==1)}
                           {if $Artikel->nVariationOhneFreifeldAnzahl == 1}
                              {assign var=kEigenschaftWert value=`$Variationswert->kEigenschaftWert`}
                              {if $Einstellungen.artikeldetails.artikel_variationspreisanzeige == 1}
                                          {if isset($Artikel->oVariationDetailPreis_arr[$kEigenschaftWert]->Preise->cAufpreisLocalized[$NettoPreise])}
                                              &raquo; <span class="price">{$Artikel->oVariationDetailPreis_arr[$kEigenschaftWert]->Preise->cAufpreisLocalized[$NettoPreise]}</span>
                                          {/if}
                                          {if $Artikel->oVariationDetailPreis_arr[$kEigenschaftWert]->Preise->PreisecPreisVPEWertInklAufpreis[$NettoPreise]|count_characters > 0}, {$Artikel->oVariationDetailPreis_arr[$kEigenschaftWert]->Preise->PreisecPreisVPEWertInklAufpreis[$NettoPreise]}{/if}
                                      {elseif $Einstellungen.artikeldetails.artikel_variationspreisanzeige == 2}
                                          &raquo; <span class="price">{$Artikel->oVariationDetailPreis_arr[$kEigenschaftWert]->Preise->cVKLocalized[$NettoPreise]}</span>{if $Artikel->oVariationDetailPreis_arr[$kEigenschaftWert]->Preise->PreisecPreisVPEWertInklAufpreis[$NettoPreise]|count_characters > 0}, {$Artikel->oVariationDetailPreis_arr[$kEigenschaftWert]->Preise->PreisecPreisVPEWertInklAufpreis[$NettoPreise]}{/if}
                                      {/if}
                           {/if}
                        {else}
                           {if $Einstellungen.artikeldetails.artikel_variationspreisanzeige==1 && $Variationswert->fAufpreisNetto!=0}
                              &raquo; <span class="price">{$Variationswert->cAufpreisLocalized[$NettoPreise]}</span>{if $Variationswert->cPreisVPEWertAufpreis[$NettoPreise]|count_characters > 0}<small> ({$Variationswert->cPreisVPEWertAufpreis[$NettoPreise]})</small>{/if}
                           {elseif $Einstellungen.artikeldetails.artikel_variationspreisanzeige==2 && $Variationswert->fAufpreisNetto!=0}
                              &raquo; <span class="price">{$Variationswert->cPreisInklAufpreis[$NettoPreise]}</span>{if $Variationswert->cPreisVPEWertInklAufpreis[$NettoPreise]|count_characters > 0}<small> ({$Variationswert->cPreisVPEWertInklAufpreis[$NettoPreise]})</small>{/if}
                           {/if}
                         {/if}
                           </span>
                              </label>
                           </li>
                        {/if}
                           {/foreach}
                        {elseif $Variation->cTyp eq "FREIFELD" || $Variation->cTyp eq "PFLICHT-FREIFELD"}
                           <li><input type="text" name="eigenschaftwert_{$Variation->kEigenschaft}" {if $Variation->cTyp eq "PFLICHT-FREIFELD"}class="required"{/if} />{if $Variation->cTyp eq "PFLICHT-FREIFELD"} <em>*</em>{/if}</li>
                        {/if}
                     </ul>
                  {/foreach}
                  </div>
               {/if}
            
               {if ($Artikel->inWarenkorbLegbar == 1 || ($Artikel->nErscheinendesProdukt == 1 && $Einstellungen.global.global_erscheinende_kaeuflich == "Y")) && !$Artikel->oKonfig_arr}
                  {if ($Artikel->kVariKindArtikel || $Artikel->kArtikelVariKombi || $Artikel->VariationenOhneFreifeld|@count == 0 || $Artikel->VariationenOhneFreifeld|@count > 2) || ($Einstellungen.artikeldetails.artikeldetails_warenkorbmatrix_anzeige == "N" && (!isset($Artikel->FunktionsAttribute[$FKT_ATTRIBUT_WARENKORBMATRIX]) || (isset($Artikel->FunktionsAttribute[$FKT_ATTRIBUT_WARENKORBMATRIX]) && $Artikel->FunktionsAttribute[$FKT_ATTRIBUT_WARENKORBMATRIX] == "0")))}
                     <div class="choose_quantity">
                        <label for="quantity" class="quantity">
                           <span>{lang key="quantity" section="global"}:</span>
                           <span><input type="text" onfocus="this.setAttribute('autocomplete', 'off');" id="quantity" class="quantity" name="anzahl" {if $Artikel->fAbnahmeintervall > 0}value="{$Artikel->fAbnahmeintervall}" onblur="javascript:gibAbnahmeIntervall(this, {$Artikel->fAbnahmeintervall});"{else}value="1"{/if} /></span>
                           {if $Einstellungen.artikeldetails.artikeldetails_anzahl_pfeile == "Y" || ($Einstellungen.artikeldetails.artikeldetails_anzahl_pfeile == "I" && $Artikel->fAbnahmeintervall > 1)}
                              <span class="change_quantity">
                                 <a href="#" onclick="javascript:erhoeheArtikelAnzahl('quantity', {if $Artikel->fAbnahmeintervall > 1}true, {$Artikel->fAbnahmeintervall}{else}false, 0{/if});return false;">+</a>
                                 <a href="#" onclick="javascript:erniedrigeArtikelAnzahl('quantity', {if $Artikel->fAbnahmeintervall > 1}true, {$Artikel->fAbnahmeintervall}{else}false, 0{/if});return false;">-</a>
                              </span>
                           {/if}
                           <span class="quantity_unit">{$Artikel->cEinheit}</span>
                        </label>
                        <span><button name="inWarenkorb" type="submit" value="{lang key="addToCart" section="global"}" class="submit"><span>{lang key="addToCart" section="global"}</span></button></span>
                        {if $Artikel->fMindestbestellmenge > 1 || ($Artikel->fMindestbestellmenge > 0 && $Artikel->cTeilbar == "Y") || $Artikel->fAbnahmeintervall > 0 || $Artikel->cTeilbar == "Y" || (isset($Artikel->FunktionsAttribute[$FKT_ATTRIBUT_MAXBESTELLMENGE]) && $Artikel->FunktionsAttribute[$FKT_ATTRIBUT_MAXBESTELLMENGE] > 0)}
                        <div class="box_buyinfo">
                           <ul>
                              {assign var="units" value=$Artikel->cEinheit}
                              {if $Artikel->cEinheit|@count_characters == 0}
                                 {lang key="units" section="productDetails" assign="units"}
                              {/if}
                           
                              {if $Artikel->fMindestbestellmenge > 1 || ($Artikel->fMindestbestellmenge > 0 && $Artikel->cTeilbar == "Y")}
                                 {lang key="minimumPurchase" section="productDetails" assign="minimumPurchase"}
                                 <li>{$minimumPurchase|replace:"%d":$Artikel->fMindestbestellmenge|replace:"%s":$units}</li>
                              {/if}
                              {if $Artikel->fAbnahmeintervall > 0}
                                 {lang key="takeHeedOfInterval" section="productDetails" assign="takeHeedOfInterval"}
                                 <li>{$takeHeedOfInterval|replace:"%d":$Artikel->fAbnahmeintervall|replace:"%s":$units}</li>
                              {/if}
                              {if $Artikel->cTeilbar == "Y"}
                                 <li>{lang key="integralQuantities" section="productDetails"}</li>
                              {/if}
                              {if isset($Artikel->FunktionsAttribute[$FKT_ATTRIBUT_MAXBESTELLMENGE]) && $Artikel->FunktionsAttribute[$FKT_ATTRIBUT_MAXBESTELLMENGE] > 0}
                                 {lang key="maximalPurchase" section="productDetails" assign="maximalPurchase"}
                                 <li>{$maximalPurchase|replace:"%d":$Artikel->FunktionsAttribute[$FKT_ATTRIBUT_MAXBESTELLMENGE]|replace:"%s":$units}</li>
                              {/if}
                           </ul>
                        </div>
                        {/if}
                     </div>
                  {/if}
               {/if}
            </fieldset>
            {if ($Einstellungen.artikeldetails.artikeldetails_warenkorbmatrix_anzeige == "Y" || $Artikel->FunktionsAttribute[$FKT_ATTRIBUT_WARENKORBMATRIX] == "1") && ($Artikel->VariationenOhneFreifeld|@count == 1 || $Artikel->VariationenOhneFreifeld|@count == 2) && !$Artikel->kArtikelVariKombi && !$Artikel->kVariKindArtikel && !$Artikel->nErscheinendesProdukt}            
               <fieldset class="container article_matrix">               
                  {include file="tpl_inc/artikel_matrix.tpl"}               
               </fieldset>            
            {/if}
         </div>
      {/if}
   </div>
   
   {if $Einstellungen.artikeldetails.merkmale_anzeigen=="Y" || $Artikel->cHersteller && $Einstellungen.artikeldetails.artikeldetails_hersteller_anzeigen != "N" || $Einstellungen.artikeldetails.artikeldetails_kategorie_anzeigen=="Y"}
      <div id="attribute_list" class="container">           
         {*if $Artikel->cHersteller && $Einstellungen.artikeldetails.artikeldetails_hersteller_anzeigen != "N"}
            <div class="item">
               <strong class="label">{lang key="manufacturer" section="productDetails"}:</strong>
               <ul class="values">   
                  {if $Einstellungen.artikeldetails.artikeldetails_hersteller_anzeigen == "Y" && $Artikel->cHersteller}
                     <li>{if $Artikel->cHerstellerHomepage}<a href="{$Artikel->cHerstellerHomepage}" target="blank" rel="nofollow">{/if}{$Artikel->cHersteller}{if $Artikel->cHerstellerHomepage}</a>{/if} {if $Einstellungen.artikeldetails.artikel_weitere_artikel_hersteller_anzeigen=="Y"}<span class="otherProductsFromManufacturer">(<a href="{$Artikel->cHerstellerURL}">{lang key="otherProductsFromManufacturer" section="productDetails"} {$Artikel->cHersteller}</a>)</span>{/if}</li>
                  {elseif $Einstellungen.artikeldetails.artikeldetails_hersteller_anzeigen == "BT" && $Artikel->cHersteller && $Artikel->cHerstellerBildKlein}
                     <li class="vmiddle">{if $Artikel->cHerstellerHomepage}<a href="{$Artikel->cHerstellerHomepage}" onclick="this.target='blank'" rel="nofollow">{/if}<img src="{$Artikel->cHerstellerBildKlein}" class="vmiddle" />{if $Artikel->cHerstellerHomepage}</a>{/if} {if $Artikel->cHerstellerHomepage}<a href="{$Artikel->cHerstellerHomepage}" target="blank" rel="nofollow">{/if}{$Artikel->cHersteller}{if $Artikel->cHerstellerHomepage}</a>{/if} {if $Einstellungen.artikeldetails.artikel_weitere_artikel_hersteller_anzeigen=="Y"} <span class="otherProductsFromManufacturer">(<a href="{$Artikel->cHerstellerURL}">{lang key="otherProductsFromManufacturer" section="productDetails"} {$Artikel->cHersteller}</a>)</span>{/if}</li>
                  {elseif $Einstellungen.artikeldetails.artikeldetails_hersteller_anzeigen == "B" && $Artikel->cHerstellerBildKlein}
                     <li class="vmiddle">{if $Artikel->cHerstellerHomepage}<a href="{$Artikel->cHerstellerHomepage}" onclick="this.target='blank'" rel="nofollow">{/if}<img src="{$Artikel->cHerstellerBildKlein}" class="vmiddle" />{if $Artikel->cHerstellerHomepage}</a>{/if} {if $Einstellungen.artikeldetails.artikel_weitere_artikel_hersteller_anzeigen=="Y"}<span class="otherProductsFromManufacturer">(<a href="{$Artikel->cHerstellerURL}">{lang key="otherProductsFromManufacturer" section="productDetails"} {$Artikel->cHersteller}</a>)</span>{/if}</li>
                  {/if}
               </ul>
            </div>
         {/if*}
            
         {if $Einstellungen.artikeldetails.artikeldetails_kategorie_anzeigen=="Y"}
            <div class="item">
               <strong class="label">{lang key="category" section="global"}:</strong>
               <ul class="values">
                  {assign var=i_kat value=$Brotnavi|@count}{assign var=i_kat value=$i_kat-2}
                  <li><a href="{$Brotnavi[$i_kat]->url}">{$Brotnavi[$i_kat]->name}</a></li>
               </ul>
            </div>
         {/if}
		 
		 {* ODM, 21.10.2013: nicht anzeigen von Attribut-Merkmalen
         {if $Einstellungen.artikeldetails.merkmale_anzeigen=="Y"}
            {foreach from=$Artikel->oMerkmale_arr item=oMerkmal}
               <div class="item">
                  <strong class="label">
                     {if $Einstellungen.navigationsfilter.merkmal_anzeigen_als == "T"}
                        <b>{$oMerkmal->cName}:</b> 
                     {elseif $Einstellungen.navigationsfilter.merkmal_anzeigen_als == "B" && $oMerkmal->cBildpfadKlein ne 'gfx/keinBild.gif'}
                        <img src="{$oMerkmal->cBildpfadKlein}" title="{$oMerkmal->cName}" />
                     {elseif $Einstellungen.navigationsfilter.merkmal_anzeigen_als == "BT"}
                        {if $oMerkmal->cBildpfadKlein ne 'gfx/keinBild.gif'}<img src="{$oMerkmal->cBildpfadKlein}" title="{$oMerkmal->cName}" class="vmiddle" /> {/if}<b>{$oMerkmal->cName}:</b> 
                     {/if}
                  </strong>
                  <ul class="values">
                     {foreach from=$oMerkmal->oMerkmalWert_arr item=oMerkmalWert}
                        {if $oMerkmal->cTyp == "TEXT" || $oMerkmal->cTyp == "SELECTBOX" || $oMerkmal->cTyp == ""}
                           <li><a href="{$oMerkmalWert->cURL}">{$oMerkmalWert->cWert}</a></li>
                        {elseif $oMerkmal->cTyp == "BILD"}
                           <li><a href="{$oMerkmalWert->cURL}"><img src="{$oMerkmalWert->cBildpfadKlein}" title="{$oMerkmalWert->cWert}" /></a></li>
                        {elseif $oMerkmal->cTyp == "BILD-TEXT"}
                           <li><a href="{$oMerkmalWert->cURL}"><img src="{$oMerkmalWert->cBildpfadKlein}" title="{$oMerkmalWert->cWert}" /></a> <a href="{$oMerkmalWert->cURL}">{$oMerkmalWert->cWert}</a></li>
                        {/if}
                     {/foreach}
                  </ul>
               </div>
            {/foreach}
         {/if}
		 *}
         <div class="clear"></div>
      </div>
   {/if}  
   <div class="clear"></div>
   </div>

   {if isset($Artikel->FunktionsAttribute[$FKT_ATTRIBUT_ARTIKELKONFIG_TPL])}
      {include file='tpl_inc/'|cat:$Artikel->FunktionsAttribute[$FKT_ATTRIBUT_ARTIKELKONFIG_TPL]}
   {else}
      {include file="tpl_inc/artikel_konfigurator.tpl"}
   {/if}
   
   </form>
   
   {include file="tpl_inc/artikel_downloads.tpl"}
   
    {if $Artikel->cBeschreibung|count_characters > 0 || $Einstellungen.artikeldetails.artikeldetails_fragezumprodukt_anzeigen=="Y" || $Einstellungen.artikeldetails.artikeldetails_artikelweiterempfehlen_anzeigen=="Y" || 
        $Einstellungen.bewertung.bewertung_anzeigen == "Y" || $Einstellungen.preisverlauf.preisverlauf_anzeigen == "Y" && $bPreisverlauf || $verfuegbarkeitsBenachrichtigung==1 || 
        ((($Einstellungen.artikeldetails.mediendatei_anzeigen=="YM" && $Artikel->cMedienDateiAnzeige != "beschreibung") || $Artikel->cMedienDateiAnzeige == "tab") && $Artikel->cMedienTyp_arr|@count > 0 && $Artikel->cMedienTyp_arr)}

      <!-- tab menu -->
      <div id="mytabset" class="container">
         <div {if $Einstellungen.artikeldetails.artikeldetails_tabs_nutzen != "N"}class="semtabs"{/if}>
            {if $Artikel->cBeschreibung|count_characters > 0}
            <div class="panel {if $Einstellungen.artikeldetails.artikeldetails_tabs_nutzen == "N"}notab{/if}" id="description">
               <h2 class="title">{lang key="description" section="productDetails"}</h2>
			   
			   <div class="custom_content description" style="font-face: arial;font-weight:normal;font-size:12px">
                    <font style="font-weight:bold;text-transform:uppercase;letters-spacing:1.5px;">{lang key="herstellerLabel" section="global"}:</font> {$Artikel->cHersteller}
                    
                    {if $Artikel->cHAN !=""}
						<br />
						<font style="font-weight:bold;text-transform:uppercase;letters-spacing:1.5px;">{lang key="productHAN" section="global"}:</font> <span id="hanArtNr">{$Artikel->cHAN}</span>
                     {else}
						<font style="font-weight:bold;text-transform:uppercase;letters-spacing:1.5px;">{lang key="productNo" section="global"}:</font> <span id="artnr">{$Artikel->cArtNr}</span>
                    {/if}
					 <br />
					
					 {if $Einstellungen.artikeldetails.merkmale_anzeigen=="Y" || $Artikel->cHersteller && $Einstellungen.artikeldetails.artikeldetails_hersteller_anzeigen != "N" || $Einstellungen.artikeldetails.artikeldetails_kategorie_anzeigen=="Y"}         
							 {if $Einstellungen.artikeldetails.merkmale_anzeigen=="Y"}
								{foreach from=$Artikel->oMerkmale_arr item=oMerkmal}
									  
										 {if $Einstellungen.navigationsfilter.merkmal_anzeigen_als == "T"}
											<font style="font-weight:bold;text-transform:uppercase;letters-spacing:1.5px;">{$oMerkmal->cName}:</font> 
										 {elseif $Einstellungen.navigationsfilter.merkmal_anzeigen_als == "B" && $oMerkmal->cBildpfadKlein ne 'gfx/keinBild.gif'}
											<img src="{$oMerkmal->cBildpfadKlein}" title="{$oMerkmal->cName}" />
										 {elseif $Einstellungen.navigationsfilter.merkmal_anzeigen_als == "BT"}
											{if $oMerkmal->cBildpfadKlein ne 'gfx/keinBild.gif'}<img src="{$oMerkmal->cBildpfadKlein}" title="{$oMerkmal->cName}" class="vmiddle" /> {/if}<b>{$oMerkmal->cName}:</b> 
										 {/if}
									  
										 {foreach from=$oMerkmal->oMerkmalWert_arr item=oMerkmalWert}
											{if $oMerkmal->cTyp == "TEXT" || $oMerkmal->cTyp == "SELECTBOX" || $oMerkmal->cTyp == ""}
											   <font style="font-weight:normal;text-transform:uppercase;letters-spacing:1.5px;"><a href="{$oMerkmalWert->cURL}">{$oMerkmalWert->cWert}</a></font>
											   <br />
											{elseif $oMerkmal->cTyp == "BILD"}
											   <font style="font-weight:normal;text-transform:uppercase;letters-spacing:1.5px;"><a href="{$oMerkmalWert->cURL}"><img src="{$oMerkmalWert->cBildpfadKlein}" title="{$oMerkmalWert->cWert}" /></a></font>
												<br />
											{elseif $oMerkmal->cTyp == "BILD-TEXT"}
											   <font style="font-weight:normal;text-transform:uppercase;letters-spacing:1.5px;"><a href="{$oMerkmalWert->cURL}"><img src="{$oMerkmalWert->cBildpfadKlein}" title="{$oMerkmalWert->cWert}" /></a> <a href="{$oMerkmalWert->cURL}">{$oMerkmalWert->cWert}</a></font>
												<br />
											{/if}
										 {/foreach}
								{/foreach}
							 {/if}
					   {/if}
					
					
                    <font style="font-weight:bold;text-transform:uppercase;letters-spacing:1.5px;">{lang key="ZustandArt" section="global"}:</font> <span id="zustandsWert"></span>
                    <br />
					<font style="font-weight:bold;text-transform:uppercase;letters-spacing:1.5px;">{lang key="Herkunftsland" section="global"}:</font> <span id="artnr">{$Artikel->cHerkunftsland}</span>
                    <br />
					<font style="font-weight:bold;text-transform:uppercase;letters-spacing:1.5px;">{lang key="Tested" section="global"}:</font> <span id="artnr">{lang key="ja" section="global"}</span>
                    <br />
					<font style="font-weight:bold;text-transform:uppercase;letters-spacing:1.5px;">{lang key="Bearbeitungszeit" section="global"}:</font> <span id="artnr">{lang key="DauerBearbeitungszeit" section="global"}</span>
					<br />
					<font style="font-weight:bold;text-transform:uppercase;letters-spacing:1.5px;">{lang key="Garantie" section="global"}:</font> <span id="garantieDauer"></span>    
                    <br />
					
			   </div>

               {assign var=cArtikelBeschreibung value=$Artikel->cBeschreibung}
               
			   <font style="font-weight:normal;text-transform:uppercase;letters-spacing:1.5px;">{lang key="ArtikelbeschreibungLabel" section="global"}:</font><br />
                 {convertHTMLxHTML cHTML=$cArtikelBeschreibung}
                  {if $Einstellungen.artikeldetails.artikeldetails_attribute_anhaengen=="Y" || $Artikel->FunktionsAttribute[$FKT_ATTRIBUT_ATTRIBUTEANHAENGEN] == 1}
                     {if $Artikel->Attribute|@count > 0}
                        <div class="attributes">
                        {foreach name=Attribute from=$Artikel->Attribute item=Attribut}
                           <p><b>{$Attribut->cName}:</b> {$Attribut->cWert}</p>
                        {/foreach}
                        </div>
                     {/if}
                  {/if}
                  {if ($Einstellungen.artikeldetails.mediendatei_anzeigen=="YA" && $Artikel->cMedienDateiAnzeige != "tab") || $Artikel->cMedienDateiAnzeige == "beschreibung"}
                     {if $Artikel->cMedienTyp_arr|@count > 0 && $Artikel->cMedienTyp_arr}
                        {foreach name="mediendateigruppen" from=$Artikel->cMedienTyp_arr item=cMedienTyp}
                           <div class="media">{include file='tpl_inc/artikel_mediendatei.tpl'}</div>
                        {/foreach}
                     {/if}
                  {/if}
               </div>
            
            {/if}
            
            {section name=iterator start=1 loop=10}
                {assign var=tab value=tab}
                {assign var=tabname value=$tab|cat:$smarty.section.iterator.index|cat:" name"}
                {assign var=tabinhalt value=$tab|cat:$smarty.section.iterator.index|cat:" inhalt"}
                {$tab1}
                {if $Artikel->AttributeAssoc[$tabname] && $Artikel->AttributeAssoc[$tabinhalt]}
                    <div class="panel {if $Einstellungen.artikeldetails.artikeldetails_tabs_nutzen == "N"}notab{/if}">
                        <h2 class="title">{$Artikel->AttributeAssoc[$tabname]}</h2>
                        <div class="custom_content">{$Artikel->AttributeAssoc[$tabinhalt]}</div>
                    </div>
                {/if}
            {/section}
            
            {if $Einstellungen.artikeldetails.artikeldetails_fragezumprodukt_anzeigen=="Y"}
                <div class="panel {if $Einstellungen.artikeldetails.artikeldetails_tabs_nutzen == "N"}notab{/if}" id="box_article_question">
                    <h2 class="title">{lang key="productQuestion" section="productDetails"}</h2>
                    {include file='tpl_inc/artikel_fragezumproduktformular.tpl'}
                </div>
            {/if}
            
            {if $Einstellungen.artikeldetails.artikeldetails_artikelweiterempfehlen_anzeigen=="Y"}
                <div class="panel {if $Einstellungen.artikeldetails.artikeldetails_tabs_nutzen == "N"}notab{/if}">
                    <h2 class="title">{lang key="recommendProduct" section="productDetails"}</h2>
                    {include file='tpl_inc/artikel_artikelweiterempfehlenformular.tpl'}
                </div>
            {/if}
            
            {if $Einstellungen.bewertung.bewertung_anzeigen == "Y"}
                <div class="panel {if $Einstellungen.artikeldetails.artikeldetails_tabs_nutzen == "N"}notab{/if}" id="box_votes">
                    <h2 class="title">{lang key="Votes" section="global"} ({if $Artikel->Bewertungen->oBewertungGesamt->nAnzahl}{$Artikel->Bewertungen->oBewertungGesamt->nAnzahl}{else}0{/if})</h2>
                    {include file='tpl_inc/artikel_bewertung.tpl'}
                </div>
            {/if}
            
            {if $Einstellungen.preisverlauf.preisverlauf_anzeigen == "Y" && $bPreisverlauf}
                <div class="panel {if $Einstellungen.artikeldetails.artikeldetails_tabs_nutzen == "N"}notab{/if}">
                    <h2 class="title price_chart">{lang key="priceFlow" section="productDetails"}</h2>
                    {include file='tpl_inc/artikel_preisverlauf.tpl'}
                </div>
            {/if}
            
            {if $verfuegbarkeitsBenachrichtigung==1 && (($Artikel->cLagerBeachten == 'Y' && $Artikel->cLagerKleinerNull != 'Y') || $Artikel->cLagerBeachten != 'Y')}
               <div class="panel {if $Einstellungen.artikeldetails.artikeldetails_tabs_nutzen == "N"}notab{/if}" id="box_article_notification">
                  <h2 class="title">{lang key="notifyMeWhenProductAvailableAgain" section="global"}</h2>
                  {include file='tpl_inc/artikel_produktverfuegbarformular.tpl' scope='artikeldetails'}
               </div>
            {/if}
            
            {if ($Einstellungen.artikeldetails.mediendatei_anzeigen=="YM" && $Artikel->cMedienDateiAnzeige != "beschreibung") || $Artikel->cMedienDateiAnzeige == "tab"}
                {if $Artikel->cMedienTyp_arr|@count > 0 && $Artikel->cMedienTyp_arr}                
                    {foreach name="mediendateigruppen" from=$Artikel->cMedienTyp_arr item=cMedienTyp}
                        <div class="panel {if $Einstellungen.artikeldetails.artikeldetails_tabs_nutzen == "N"}notab{/if}">
                            <h2 class="title">{$cMedienTyp}</h2>
                            {include file='tpl_inc/artikel_mediendatei.tpl'}
                        </div>
                    {/foreach}
                {/if}
            {/if}
         </div>
      </div>
   {/if}

   <script type="text/javascript">
   function setBindingsArtikel() {ldelim}
      {* konfig *}
      $('.box_config').slideUp();
   
      {* global *}
      init_article();
      
      {* addthis *}
      $('li.addthis').hide();
   {rdelim}
   
   function config_price_changed(price) {ldelim}
      xajax_gibFinanzierungInfo({$Artikel->kArtikel}, price);
   {rdelim}
   
   function init_article_image(obj) {ldelim}
      var nWidth = $(obj).naturalWidth() + 4;
      if (nWidth > 4) {ldelim}
         $('#article .article_image').css({ldelim}
            'width' : nWidth + 'px',
            'max-width' : nWidth + 'px'
         {rdelim});
      {rdelim}
   {rdelim}
   
   function validate_variation() {ldelim}
      $('.required').each(function(idx, item) {ldelim}
         var elem = $(item).attr('name');
         var named = $("*[name='"+elem+"']");
         var type = named[0].tagName;
         
         switch (type) {ldelim}
            case 'INPUT':
               var input_type = $(named).attr('type');
               switch (input_type) {ldelim}
                  case 'text':
                     if ($(named).val().length == 0)
                        $(named).addClass('error');
                  break;
                  case 'radio':
                     if ($("*[name='"+elem+"']:checked").length == 0)
                        $(named).addClass('error');
                  break;
               {rdelim}
               break;
            case 'SELECT':
               if ($(named).val() == 0)
                  $(named).addClass('error');
               break;
         {rdelim}
      
      {rdelim});
   
   {rdelim}

   function init_article() {ldelim}
      {* tabs *}
      {if $Einstellungen.artikeldetails.artikeldetails_tabs_nutzen != "N"}
         $("#mytabset").semantictabs({ldelim}
            panel: '.panel',
            head: 'h2.title',
            active: '{if $BewertungsTabAnzeigen == 1}#box_votes{elseif $fehlendeAngaben_benachrichtigung && $verfuegbarkeitsBenachrichtigung==1}#box_article_notification{elseif $fehlendeAngaben_fragezumprodukt && $Einstellungen.artikeldetails.artikeldetails_fragezumprodukt_anzeigen == "Y"}#box_article_question{elseif $PluginTabAnzeigen}{$PluginTabName}{else}:first{/if}',
            activate: 0
         {rdelim});
      {/if}
      
      {* lightbox *}
      {if $Einstellungen.template.articledetails.image_zoom_method == 'L' ||
          $Einstellungen.template.articledetails.image_zoom_method == 'ZL'}
          $("a.fancy-gallery").fancybox({ldelim}          
            'titleShow': false, 
            'hideOnContentClick': true, 
            'transitionIn': 'elastic', 
            'transitionOut': 'elastic',
            'overlayShow' : true,
            'overlayColor' : '#000',
            'overlayOpacity' : 0.15,
            'autoScale' : true,
            'centerOnScroll' : true,
            'autoDimensions' : false
          {rdelim});
      {/if}
      
      {* zoom *}
      {if $Einstellungen.template.articledetails.image_zoom_method == 'Z' || $Einstellungen.template.articledetails.image_zoom_method == 'ZL'}
          $('.cloud-zoom, .cloud-zoom-gallery').CloudZoom();
      {/if}
      
       {* image wrapper width *}
      var article_image = $('#image_wrapper div.image img');      
      if (article_image.naturalWidth() > 0 && article_image.naturalHeight() > 0)
         init_article_image(article_image);
      else {ldelim}
         article_image.load(function() {ldelim}
            init_article_image($(this));
         {rdelim});
      {rdelim}
      
      {* popups *}
      register_popups();
      register_popover();

      {* tooltips *}
      $('.tooltip').tipTip();
      
      {* register_jcarousel *}
      register_jcarousel();
      
      {* validate *}
      {if $smarty.get.r == 5}
         validate_variation();
      {/if}

   {rdelim}
   
   $(document).ready(function() {ldelim}
      init_article();
   {rdelim});
   </script>

   {if $Einstellungen.artikeldetails.tagging_anzeigen=="Y"}
      <div class="container article_tags">
         <h2>{lang key="productTags" section="productDetails"}</h2>
         <form method="post" action="index.php" class="form">
            <fieldset class="border">
               <legend>{lang key="addYourTag" section="productDetails"}</legend>
               {if count($ProduktTagging) > 0}
                  <p>{lang key="productTagsDesc" section="productDetails"}</p>
                  {if $ProduktTagging|@count > 0}
                     <p class="box_plain">
                        {foreach name=produktTaggings from=$ProduktTagging item=produktTagging}
                           <a href="{$produktTagging->cURL}" title="{$produktTagging->cName}">{$produktTagging->cName}</a>{if $smarty.foreach.produktTaggings.last == false},{/if}
                        {/foreach}
                     </p>
                  {/if}
               {/if}
               {if $Einstellungen.artikeldetails.tagging_freischaltung!="N"}
                  <input type="hidden" name="a" value="{$Artikel->kArtikel}" />
                  <input type="hidden" name="produktTag" value="1" />
                  <input type="hidden" name="{$session_name}" value="{$session_id}" />
                  {if ($Einstellungen.artikeldetails.tagging_freischaltung=="Y" && $smarty.session.Kunde->kKunde > 0) || $Einstellungen.artikeldetails.tagging_freischaltung=="O"}
                     <input name="tag" type="text" /> <input name="submit" type="submit" value="{lang key="addTag" section="productDetails"}" />
                  {else}
                     <p>{lang key="tagloginnow" section="productDetails"} <input name="einloggen" type="submit" value="{lang key="taglogin" section="productDetails"}" /></p>
                  {/if}
               {/if}
            </fieldset>
         </form>
      </div>
   {/if}
      
   {if $Xselling->Standard}
      <div class="container article_xselling">
      {foreach name=Xsell_gruppen from=$Xselling->Standard->XSellGruppen item=Gruppe}
         {if count($Gruppe->Artikel)>0}
            {include file="tpl_inc/artikel_inc_rowliste.tpl" headline=$Gruppe->Name oArtikel_arr=$Gruppe->Artikel cClass="article_list_of_items"}
         {/if}
      {/foreach}
      </div>
   {/if}
   
   {if isset($Artikel->oProduktBundle_arr) && $Artikel->oProduktBundle_arr|@count > 0}
      {include file="tpl_inc/artikel_inc_bundle.tpl" ProductKey=$Artikel->kArtikel Products=$Artikel->oProduktBundle_arr ProduktBundle=$Artikel->oProduktBundlePrice ProductMain=$Artikel->oProduktBundleMain}
   {/if}
   
   {if isset($Artikel->oStueckliste_arr) && $Artikel->oStueckliste_arr|@count > 0}
      {include file="tpl_inc/artikel_inc_rowliste.tpl" cKey="listOfItems" cSection="global" oArtikel_arr=$Artikel->oStueckliste_arr cClass="article_list_of_items"}
   {/if}
   
   {if isset($Xselling->Kauf) && count($Xselling->Kauf->Artikel)>0}
      {if $Einstellungen.template.articleoverview.article_show_slider=='Y' && count($Xselling->Kauf->Artikel)>3}
         {include file="tpl_inc/artikel_inc_slider.tpl" cID="mycarousel" cKey=customerWhoBoughtXBoughtAlsoY cSection="productDetails" oArtikel_arr=$Xselling->Kauf->Artikel nVisible=3}
      {else}
         {include file="tpl_inc/artikel_inc_rowliste.tpl" cKey="customerWhoBoughtXBoughtAlsoY" cSection="productDetails" oArtikel_arr=$Xselling->Kauf->Artikel cClass="article_list_xseller"}
      {/if}
   {/if}
   
   {if isset($oAehnlicheArtikel_arr) && count($oAehnlicheArtikel_arr)>0}
      {if $Einstellungen.template.articleoverview.article_show_slider=='Y' && count($oAehnlicheArtikel_arr)>3}
         {include file="tpl_inc/artikel_inc_slider.tpl" cKey="RelatedProducts" cSection="productDetails" oArtikel_arr=$oAehnlicheArtikel_arr nVisible=3}
      {else}
         {include file="tpl_inc/artikel_inc_rowliste.tpl" cKey="RelatedProducts" cSection="productDetails" oArtikel_arr=$oAehnlicheArtikel_arr cClass="article_list_of_related_products"}
      {/if}
   {/if}
</div>

<div id="article_popups">
   {include file='tpl_inc/artikel_popups.tpl'}    
</div>