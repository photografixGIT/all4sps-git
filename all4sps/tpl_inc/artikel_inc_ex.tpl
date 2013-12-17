{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
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

   <form id="buy_form" method="post" action="index.php" onsubmit="return checkVarCombi();">
   <fieldset class="outer">
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
         {if $Artikel->Bilder[0]->cPfadNormal ne "gfx/keinBild.gif"}<a href="{$Artikel->Bilder[0]->cPfadGross}" class="fancy-gallery {if $Einstellungen.template.articledetails.image_zoom_method == 'Z' || $Einstellungen.template.articledetails.image_zoom_method == 'ZL'}cloud-zoom{/if}" id="zoom1" rel="adjustX: 10, adjustY: 0, smoothMove:5, zoomWidthWrapper: '.article_details'">{/if}
            <img src="{$Artikel->Bilder[0]->cPfadNormal}" id="image0" title="{$Artikel->cName|strip_tags|escape:"quotes"|truncate:60}" alt="" />
         {if $Artikel->Bilder[0]->cPfadNormal ne "gfx/keinBild.gif"}</a>{/if}
      </div>
      
      {if $Artikel->Bilder|@count > 1}
         <div class="article_images">
         {foreach name=article_image from=$Artikel->Bilder item=oBild}
            <a href="{$oBild->cPfadGross}" class="fancy-gallery {if $Einstellungen.template.articledetails.image_zoom_method == 'Z' || $Einstellungen.template.articledetails.image_zoom_method == 'ZL'}cloud-zoom-gallery{/if}" title="" rel="useZoom: 'zoom1', smallImage: '{$oBild->cPfadNormal}'">
               <img src="{$oBild->cPfadMini}" {if $smarty.foreach.article_image.index == 0}class="active"{/if} alt="" />
            </a>
         {/foreach}
         </div>
      {/if}

   </div>

   <!-- right -->
   <div class="article_details" style="width:300px;float:left;padding: 0 10px 0 0">
   
      <h1 style="margin:0 0 3px 0;font-size:1.4em">{$Artikel->cName}</h1>
      <p style="font-size:0.9em">{lang key="productNo" section="global"}: {$Artikel->cArtNr}</p>
      
      <p style="font-size:0.9em;margin:10px 0">{$Artikel->cKurzBeschreibung}</p>

      <div class="clear"></div>

      <!-- finanzierung -->
      {if $Artikel->inWarenkorbLegbar==1}
         {if isset($Einstellungen.artikeldetails.artikeldetails_finanzierung_anzeigen) && $Einstellungen.artikeldetails.artikeldetails_finanzierung_anzeigen == "Y" && isset($Artikel->oRateMin)}
         <div class="financing tleft">
            <p><strong>{lang key="fromJust" section="global"} {$Artikel->oRateMin->cRateLocalized} {lang key="monthlyPer" section="global"}</strong></p>
            <small>{$Artikel->oRateMin->cHinweisHTML}</small>
         </div>
         {/if}
      {/if}
      
      <!-- warenkorb -->
      <div id="article_buyfield">
         <div class="loader">{lang key="ajaxLoading" section="global"}</div>
         <fieldset class="article_buyfield" style="background-color:#fff;padding:0;">
            
            {*{if $Artikel->inWarenkorbLegbar != 1}*}
               {if $Artikel->nErscheinendesProdukt}
                  <div class="{if $Einstellungen.global.global_erscheinende_kaeuflich == "Y"}box_plain{/if} tcenter">
                     {lang key="productAvailableFrom" section="global"}: <strong>{$Artikel->Erscheinungsdatum_de}</strong>
                     {if $Einstellungen.global.global_erscheinende_kaeuflich == "Y"}
                        ({lang key="preorderPossible" section="global"})
                     {/if}
                  </div>
               {/if}
            {*{/if}*}

         {if isset($Artikel->Variationen) && $Artikel->Variationen|@count > 0}  
            <div class="variations" style="padding: 10px 0;border-top: 1px dotted #ccc">
            {foreach name=Variationen from=$Artikel->Variationen key=i item=Variation}
               <ul>
                  <li class="label" style="font-weight:normal;font-size:0.9em">{$Variation->cName}</li>
                  {if $Variation->cTyp=="SELECTBOX"}
                     <li>
                        <select style="width:220px" class="variation" id="eigenschaftwert_{$Variation->kEigenschaft}" name="eigenschaftwert_{$Variation->kEigenschaft}" onchange="{if $Artikel->nIstVater != 1}var_sel({$Variation->kEigenschaft});{/if} {if !$Artikel->Preise->strPreisGrafik_Detail}aktualisierePreis(); aktualisiereGewicht();{/if} {if $Artikel->nIstVater == 1}xajax_checkVarkombiDependencies({$Artikel->kArtikel}, '{$Artikel->cURL}', {$Variation->kEigenschaft}, this.options[this.options.selectedIndex].value);{/if}">
                           <option value="0">{lang key="pleaseChooseVariation" section="productDetails"}</option>
                           {foreach name=Variationswerte from=$Variation->Werte key=y item=Variationswert}
                              {if ($Artikel->kVaterArtikel > 0 || $Artikel->nIstVater == 1) && $Artikel->nVariationOhneFreifeldAnzahl == 1 && $Einstellungen.global.artikeldetails_variationswertlager == 3 && $Artikel->VariationenOhneFreifeld[$i]->Werte[$y]->nNichtLieferbar == 1}
                                 {* mach nix *}
                              {else}
                                 <option id="kEigenschaftWert_{$Variationswert->kEigenschaftWert}" value="{$Variationswert->kEigenschaftWert}">
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
                           <input type="radio" name="eigenschaftwert_{$Variation->kEigenschaft}" id="kEigenschaftWert_{$Variationswert->kEigenschaftWert}" value="{$Variationswert->kEigenschaftWert}" onclick="{if $Variationswert->cBildPfad && $Artikel->nIstVater != 1}var_bild({$Variationswert->kEigenschaftWert});{/if} {if $Artikel->nIstVater == 1}xajax_checkVarkombiDependencies({$Artikel->kArtikel}, '{$Artikel->cURL}', {$Variationswert->kEigenschaft}, {$Variationswert->kEigenschaftWert});{/if} {if !$Artikel->Preise->strPreisGrafik_Detail}aktualisierePreis(); aktualisiereGewicht();{/if}" /> {$Variationswert->cName}
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
                        </label>
                     </li>
                  {/if}
                     {/foreach}
                  {elseif $Variation->cTyp eq "FREIFELD" || $Variation->cTyp eq "PFLICHT-FREIFELD"}
                     <li><input type="text" name="eigenschaftwert_{$Variation->kEigenschaft}" />{if $Variation->cTyp eq "PFLICHT-FREIFELD"} <em>*</em>{/if}</li>
                  {/if}
               </ul>
            {/foreach}
            </div>
         {/if}
         
         </fieldset>
         {if ($Einstellungen.artikeldetails.artikeldetails_warenkorbmatrix_anzeige == "Y" || $Artikel->FunktionsAttribute[$FKT_ATTRIBUT_WARENKORBMATRIX] == "1") && ($Artikel->VariationenOhneFreifeld|@count == 1 || $Artikel->VariationenOhneFreifeld|@count == 2) && !$Artikel->kArtikelVariKombi && !$Artikel->kVariKindArtikel && !$Artikel->nErscheinendesProdukt}
            <fieldset class="container article_matrix">
               {include file="tpl_inc/artikel_matrix.tpl"}
            </fieldset>
         {/if}
      </div>
   </div>
   
   <!-- BOX RIGHT -->
   
   <div style="overflow:hidden;text-align:left;background-color:whiteSmoke;-webkit-border-radius:10px;padding:15px">
   
      <div class="box_plain" style="border-bottom: 1px dotted #ccc;padding: 0 0 20px 0;margin: 0 0 20px 0;">
         {if $smarty.session.Kundengruppe->darfPreiseSehen}
            {if $Artikel->Preise->fVKNetto==0 && $Einstellungen.global.global_preis0=="N"}
               <p>{lang key="priceOnApplication" section="global"}</p>
            {else}
               {if $Artikel->Preise->rabatt>0 && !$Artikel->Preise->Sonderpreis_aktiv}
                  {if $Einstellungen.artikeldetails.artikeldetails_rabattanzeige==2 || $Einstellungen.artikeldetails.artikeldetails_rabattanzeige==4}
                  <p><small>{lang key="discount" section="global"}: {$Artikel->Preise->rabatt}%</small></p>
                  {/if}
                  {if $Einstellungen.artikeldetails.artikeldetails_rabattanzeige==3 || $Einstellungen.artikeldetails.artikeldetails_rabattanzeige==4}
                  <p><small>{lang key="oldPrice" section="global"}: <del>{$Artikel->Preise->alterVKLocalized[$NettoPreise]}</del></small></p>
                  {/if}
               {/if}
               {if $Artikel->Preise->Sonderpreis_aktiv && $Einstellungen.artikeldetails.artikeldetails_sonderpreisanzeige==2}
                  <p><b>{lang key="insteadOf" section="global"}:</b> <del>{$Artikel->Preise->alterVKLocalized[$NettoPreise]}</del></p>
               {/if}
               
               <p style="font-size:0.9em;color:#666">
                  {if $Artikel->oKonfig_arr}
                     {lang key="priceAsConfigured" section="productDetails"}
                  {elseif $Artikel->Preise->Sonderpreis_aktiv}
                     {lang key="specialPrice" section="global"}
                  {else}
                     {lang key="ourPrice" section="productDetails"}
                  {/if}
               </p>
               <p>
                  {if $Artikel->Preise->strPreisGrafik_Detail}
                     <span class="price_image">{$Artikel->Preise->strPreisGrafik_Detail}</span>
                  {else}
                     <span class="price updateable" id="price" style="font-size:24px;font-family:segoe ui, arial, helvetica, clean, sans-serif;color:#222">{$Artikel->Preise->cVKLocalized[$NettoPreise]}</span>
                     {if $Artikel->fAbnahmeintervall > 1 && $Artikel->cEinheit}
                        <span class="per_unit"> {lang key="vpePer" section="global"} 1 {$Artikel->cEinheit}</span>
                     {/if}
                  {/if}
               </p>
               
               {if $Artikel->cLocalizedVPE}
                  <p><small><b>{lang key="basePrice" section="global"}:</b> <span class="price_base updateable">{$Artikel->cLocalizedVPE[$NettoPreise]}</span></small></p>
               {/if}
               <p style="padding: 2px 0 0 0"><span class="vat_info" style="">{$Artikel->cMwstVersandText}</span></p>
               {if $Einstellungen.artikeldetails.artikeldetails_uvp_anzeigen=='Y' && $Artikel->fUVP>0}
                  <p><small>{lang key="suggestedPrice" section="productDetails"}: {$UVPlocalized}</small></p>
               {/if}
               {if $Artikel->Preise->fPreis1>0 && $Artikel->Preise->nAnzahl1>0}
                  {include file='tpl_inc/staffelpreise_inc.tpl'}
               {else}
                  {if $Artikel->SieSparenX->anzeigen==1 && $Artikel->SieSparenX->nProzent > 0}
                     <p><small>{lang key="youSave" section="productDetails"} {$Artikel->SieSparenX->nProzent}%, {lang key="thatIs" section="productDetails"} {$Artikel->SieSparenX->cLocalizedSparbetrag}</small></p>
                  {/if}
               {/if}
            {/if}
         {else}
            {lang key="priceHidden" section="global"}
         {/if}
      </div>
      
     <div class="box_plain">
      {if ($Artikel->inWarenkorbLegbar == 1 || ($Artikel->nErscheinendesProdukt == 1 && $Einstellungen.global.global_erscheinende_kaeuflich == "Y")) && !$Artikel->oKonfig_arr}
         {if ($Artikel->kVariKindArtikel || $Artikel->kArtikelVariKombi || $Artikel->VariationenOhneFreifeld|@count == 0 || $Artikel->VariationenOhneFreifeld|@count > 2) || ($Einstellungen.artikeldetails.artikeldetails_warenkorbmatrix_anzeige == "N" && (!isset($Artikel->FunktionsAttribute[$FKT_ATTRIBUT_WARENKORBMATRIX]) || (isset($Artikel->FunktionsAttribute[$FKT_ATTRIBUT_WARENKORBMATRIX]) && $Artikel->FunktionsAttribute[$FKT_ATTRIBUT_WARENKORBMATRIX] == "0")))}
            <div class="choose_quantity">
               <p class="box_plain">
                  <label for="quantity" class="quantity">
                     <span>{lang key="quantity" section="global"}:</span>
                     <span><input type="text" onfocus="this.setAttribute('autocomplete', 'off');" id="quantity" class="quantity" name="anzahl" {if $Artikel->fAbnahmeintervall > 0}value="{$Artikel->fAbnahmeintervall}" onblur="javascript:gibAbnahmeIntervall(this, {$Artikel->fAbnahmeintervall});"{else}value="1"{/if} /></span>
                     <!--
                     {if $Einstellungen.artikeldetails.artikeldetails_anzahl_pfeile == "Y" || ($Einstellungen.artikeldetails.artikeldetails_anzahl_pfeile == "I" && $Artikel->fAbnahmeintervall > 1)}
                        <span class="change_quantity">
                           <a href="#" onclick="javascript:erhoeheArtikelAnzahl('quantity', {if $Artikel->fAbnahmeintervall > 1}true, {$Artikel->fAbnahmeintervall}{else}false, 0{/if});return false;">+</a>
                           <a href="#" onclick="javascript:erniedrigeArtikelAnzahl('quantity', {if $Artikel->fAbnahmeintervall > 1}true, {$Artikel->fAbnahmeintervall}{else}false, 0{/if});return false;">-</a>
                        </span>
                     {/if}
                     -->
                     <span class="quantity_unit">{$Artikel->cEinheit}</span>
                  </label>
               </p>
               <p class="tcenter">
                  <button name="inWarenkorb" type="submit" value="{lang key="addToCart" section="global"}" class="submit" style="width:100%;height:30px !important"><span>{lang key="addToCart" section="global"}</span></button>
               </p>
            </div>
         {/if}
      {/if}
     </div>
      
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

   </div>
   
   <!-- // BOX RIGHT -->
   
   <div style="clear:both"></div>
   
   <!--
   
   {if $Einstellungen.artikeldetails.merkmale_anzeigen=="Y" || $Artikel->cHersteller && $Einstellungen.artikeldetails.artikeldetails_hersteller_anzeigen != "N" || $Einstellungen.artikeldetails.artikeldetails_kategorie_anzeigen=="Y"}
      <div id="attribute_list" class="container">           
         {if $Artikel->cHersteller && $Einstellungen.artikeldetails.artikeldetails_hersteller_anzeigen != "N"}
            <div class="item">
               <strong class="label">{lang key="manufacturer" section="productDetails"}:</strong>
               <ul class="values">   
                  {if $Einstellungen.artikeldetails.artikeldetails_hersteller_anzeigen == "Y" && $Artikel->cHersteller}
                     <li>{if $Artikel->cHerstellerHomepage}<a href="{$Artikel->cHerstellerHomepage}" target="blank" rel="nofollow">{/if}{$Artikel->cHersteller}{if $Artikel->cHerstellerHomepage}</a>{/if} {if $Einstellungen.artikeldetails.artikel_weitere_artikel_hersteller_anzeigen=="Y"}(<a href="{$Artikel->cHerstellerURL}">{lang key="otherProductsFromManufacturer" section="productDetails"} {$Artikel->cHersteller}</a>){/if}</li>
                  {elseif $Einstellungen.artikeldetails.artikeldetails_hersteller_anzeigen == "BT" && $Artikel->cHersteller && $Artikel->cHerstellerBildKlein}
                     <li class="vmiddle">{if $Artikel->cHerstellerHomepage}<a href="{$Artikel->cHerstellerHomepage}" onclick="this.target='blank'" rel="nofollow">{/if}<img src="{$Artikel->cHerstellerBildKlein}" class="vmiddle" />{if $Artikel->cHerstellerHomepage}</a>{/if} {if $Artikel->cHerstellerHomepage}<a href="{$Artikel->cHerstellerHomepage}" target="blank" rel="nofollow">{/if}{$Artikel->cHersteller}{if $Artikel->cHerstellerHomepage}</a>{/if} {if $Einstellungen.artikeldetails.artikel_weitere_artikel_hersteller_anzeigen=="Y"}(<a href="{$Artikel->cHerstellerURL}">{lang key="otherProductsFromManufacturer" section="productDetails"} {$Artikel->cHersteller}</a>){/if}</li>
                  {elseif $Einstellungen.artikeldetails.artikeldetails_hersteller_anzeigen == "B" && $Artikel->cHerstellerBildKlein}
                     <li class="vmiddle">{if $Artikel->cHerstellerHomepage}<a href="{$Artikel->cHerstellerHomepage}" onclick="this.target='blank'" rel="nofollow">{/if}<img src="{$Artikel->cHerstellerBildKlein}" class="vmiddle" />{if $Artikel->cHerstellerHomepage}</a>{/if} {if $Einstellungen.artikeldetails.artikel_weitere_artikel_hersteller_anzeigen=="Y"}(<a href="{$Artikel->cHerstellerURL}">{lang key="otherProductsFromManufacturer" section="productDetails"} {$Artikel->cHersteller}</a>){/if}</li>
                  {/if}
               </ul>
            </div>
         {/if}
            
         {if $Einstellungen.artikeldetails.artikeldetails_kategorie_anzeigen=="Y"}
            <div class="item">
               <strong class="label">{lang key="category" section="global"}:</strong>
               <ul class="values">
                  {assign var=i_kat value=$Brotnavi|@count}{assign var=i_kat value=$i_kat-2}
                  <li><a href="{$Brotnavi[$i_kat]->url}">{$Brotnavi[$i_kat]->name}</a></li>
               </ul>
            </div>
         {/if}
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
         <div class="clear"></div>
      </div>
   {/if}  
   
   -->
   
   <div class="clear"></div>
   </fieldset>
   
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
               {assign var=cArtikelBeschreibung value=$Artikel->cBeschreibung}
               <div class="custom_content">
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
                    <h2 class="title">{lang key="Votes" section="global"}</h2>
                    {include file='tpl_inc/artikel_bewertung.tpl'}
                </div>
            {/if}
            
            {if $Einstellungen.preisverlauf.preisverlauf_anzeigen == "Y" && $bPreisverlauf}
                <div class="panel {if $Einstellungen.artikeldetails.artikeldetails_tabs_nutzen == "N"}notab{/if}">
                    <h2 class="title">{lang key="priceFlow" section="productDetails"}</h2>
                    {include file='tpl_inc/artikel_preisverlauf.tpl'}
                </div>
            {/if}
            
            {if $verfuegbarkeitsBenachrichtigung==1}
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
      $('#image_wrapper div.image #wrap a img').load(function() {ldelim}
         var nWidth = $(this).width() + 4;
         if (nWidth > 4) {ldelim}
            $('#article .article_image').css({ldelim}
               'width' : nWidth + 'px',
               'max-width' : nWidth + 'px'
            {rdelim});
         {rdelim}         
      {rdelim});
      
      {* popups *}
      register_popups();

      {* tooltips *}
      $('.tooltip').tipTip();
   {rdelim}
   
   $(document).ready(function() {ldelim}
      init_article();
   {rdelim});
   </script>

   {*if $Einstellungen.artikeldetails.tagging_anzeigen=="Y"}
      <div class="container article_tags">
         <h2>{lang key="productTags" section="productDetails"}</h2>
         <form method="post" action="index.php" class="form">
            <fieldset>
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
   {/if*}
      
   {if $Xselling->Standard}
      <div class="container article_xselling">
      {foreach name=Xsell_gruppen from=$Xselling->Standard->XSellGruppen item=Gruppe}
      {if count($Gruppe->Artikel)>0}
         <h2 class="underline">{$Gruppe->Name}</h2>
         <ul class="hlist articles">
         {foreach name=Xsell_artikel from=$Gruppe->Artikel item=oXSellArtikel}
            <li class="p33 tcenter {if $smarty.foreach.Xsell_artikel.index%3==0}clear{/if}">
               <div>
               <p>
                  <a href="{$oXSellArtikel->cURL}">
                     <img alt="{$oXSellArtikel->cName|strip_tags|escape:"quotes"|truncate:60}" src="{$oXSellArtikel->cVorschaubild}" class="image" id="image{$oXSellArtikel->kArtikel}" />
                     {if isset($oXSellArtikel->oSuchspecialBild)}
                        <script type="text/javascript">
                           set_overlay('#image{$oXSellArtikel->kArtikel}', '{$oXSellArtikel->oSuchspecialBild->nPosition}', '{$oXSellArtikel->oSuchspecialBild->nMargin}', '{$oXSellArtikel->oSuchspecialBild->cPfadKlein}');
                        </script>
                     {/if}
                   </a>
               </p>
               <p>
                  <a href="{$oXSellArtikel->cURL}">{$oXSellArtikel->cName}</a>
               </p>
               <p>
                  <span class="price_label">{lang key="only" section="global"}</span> <span class="price">{$oXSellArtikel->Preise->cVKLocalized[$NettoPreise]}</span>
               </p>
               
               {if $oXSellArtikel->cLocalizedVPE}
                  <p><small><strong>{lang key="basePrice" section="global"}:</strong> {$oXSellArtikel->cLocalizedVPE[$NettoPreise]}</small></p>
               {/if}
               
               <p>
                  <span class="vat_info">{$oXSellArtikel->cMwstVersandText}</span>
               </p>
               </div>
            </li>
         {/foreach}
         </ul>
      {/if}
      {/foreach}
      </div>
   {/if}
   
   
   {if isset($Artikel->oStueckliste_arr) && $Artikel->oStueckliste_arr|@count > 0}
      {include file="tpl_inc/artikel_inc_liste.tpl" cKey="listOfItems" cSection="global" oArtikel_arr=$Artikel->oStueckliste_arr cClass="article_list_of_items"}
   {/if}
   
   {if isset($Xselling->Kauf) && count($Xselling->Kauf->Artikel)>0}
      {include file="tpl_inc/artikel_inc_liste.tpl" cKey="customerWhoBoughtXBoughtAlsoY" cSection="productDetails" oArtikel_arr=$Xselling->Kauf->Artikel cClass="article_list_xseller"}
   {/if}
   
   {if isset($oAehnlicheArtikel_arr) && count($oAehnlicheArtikel_arr)>0}
      {include file="tpl_inc/artikel_inc_liste.tpl" cKey="RelatedProducts" cSection="productDetails" oArtikel_arr=$oAehnlicheArtikel_arr cClass="article_list_of_related_products"}
   {/if}
</div>

<div id="article_popups">    
   {include file='tpl_inc/artikel_popups.tpl'}    
</div>