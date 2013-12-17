{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
{include file='tpl_inc/suche_header.tpl'}
{assign var="style" value="list"}
{if isset($oErweiterteDarstellung) && isset($Einstellungen.artikeluebersicht.artikeluebersicht_erw_darstellung) && $Einstellungen.artikeluebersicht.artikeluebersicht_erw_darstellung == "Y"}
   {if $oErweiterteDarstellung->nDarstellung == 1}
      {assign var="style" value="list"}
   {elseif $oErweiterteDarstellung->nDarstellung == 2}
      {assign var="style" value="gallery"}
   {elseif $oErweiterteDarstellung->nDarstellung == 3}
      {assign var="style" value="mosaic"}
   {/if}
{/if}

<script type="text/javascript" src="{$PFAD_ART_ABNAHMEINTERVALL}artikel_abnahmeintervall.js"></script>
<ul class="styled_view">
{$Suchergebnisse->Fehler}
{foreach name=artikel from=$Suchergebnisse->Artikel->elemente item=Artikel}
<li class="{$style}">
   <div class="article_wrapper">
      <h3>
         <a href="{$Artikel->cURL}">{$Artikel->cName}</a>
      </h3>
      
	  {* A Smarty comment - ODM, 12/08/2013, Biker City & All For SPS: Do Not Show Product Number if HAN is not blank in WAWI ERP *}
			 {if $Artikel->cHAN !=""}
				<strong>{lang key="productHAN" section="global"}:</strong><span id="hanArtNr">{$Artikel->cHAN}</span><p>&nbsp;</p>
			 {else}
				<strong>{lang key="productNo" section="global"}:</strong> <span id="artnr">{$Artikel->cArtNr}</span><p>&nbsp;</p>
			{/if}
	  
      {if isset($Artikel->fDurchschnittsBewertung) && $Artikel->fDurchschnittsBewertung > 0}
         <span class="stars p{$Artikel->fDurchschnittsBewertung|replace:'.':'_'}"></span>
      {/if}
       
      <!-- image -->
      <div class="article_image">
         <div class="image_overlay_wrapper" id="image_drag_article{$Artikel->kArtikel}">
            <div class="image_overlay" id="overlay{$Artikel->kArtikel}"></div>
            <a href="{$Artikel->cURL}" {if $Einstellungen.template.articleoverview.article_image_preview == 'Y'}class="image_preview"{/if} ref="{$Artikel->Bilder[0]->cPfadNormal}">
               {counter assign=imgcounter print=0}
               <img src="{$Artikel->cVorschaubild}" alt="{$Artikel->cName|strip_tags|escape:"quotes"|truncate:60}" id="image{$Artikel->kArtikel}_{$imgcounter}" class="image" />
            </a>
            {if isset($Artikel->oSuchspecialBild)}
               <script type="text/javascript">
                  set_overlay('#image{$Artikel->kArtikel}_{$imgcounter}', '{$Artikel->oSuchspecialBild->nPosition}', '{$Artikel->oSuchspecialBild->nMargin}', '{$Artikel->oSuchspecialBild->cPfadKlein}');
               </script>
            {/if}
         </div>
      </div>
      
      <form id="buy_form{$Artikel->kArtikel}" action="navi.php" method="post">
         <fieldset class="outer">
            <input type="hidden" name="a" value="{$Artikel->kArtikel}" />
            <input type="hidden" name="wke" value="1" />
            <input type="hidden" name="overview" value="1" />
            <input type="hidden" name="Sortierung" value="{$Suchergebnisse->Sortierung}" />
            <input type="hidden" name="{$session_name}" value="{$session_id}" />
            {if $Suchergebnisse->Seitenzahlen->AktuelleSeite > 1}<input type="hidden" name="seite" value="{$Suchergebnisse->Seitenzahlen->AktuelleSeite}" />{/if}
            {if $NaviFilter->Kategorie->kKategorie > 0}<input type="hidden" name="k" value="{$NaviFilter->Kategorie->kKategorie}" />{/if}
            {if $NaviFilter->Hersteller->kHersteller > 0}<input type="hidden" name="h" value="{$NaviFilter->Hersteller->kHersteller}" />{/if}
            {if $NaviFilter->Suchanfrage->kSuchanfrage > 0}<input type="hidden" name="l" value="{$NaviFilter->Suchanfrage->kSuchanfrage}" />{/if}
            {if $NaviFilter->MerkmalWert->kMerkmalWert > 0}<input type="hidden" name="m" value="{$NaviFilter->MerkmalWert->kMerkmalWert}" />{/if}
            {if $NaviFilter->Tag->kTag > 0}<input type="hidden" name="t" value="{$NaviFilter->Tag->kTag}">{/if}
            {if $NaviFilter->KategorieFilter->kKategorie > 0}<input type="hidden" name="kf" value="{$NaviFilter->KategorieFilter->kKategorie}" />{/if}
            {if $NaviFilter->HerstellerFilter->kHersteller > 0}<input type="hidden" name="hf" value="{$NaviFilter->HerstellerFilter->kHersteller}" />{/if}
            
            {if is_array($NaviFilter->MerkmalFilter)}
               {foreach name=merkmalfilter from=$NaviFilter->MerkmalFilter item=mmfilter}
               <input type="hidden" name="mf{$smarty.foreach.merkmalfilter.iteration}" value="{$mmfilter->kMerkmalWert}" />
               {/foreach}
            {/if}
            {if is_array($NaviFilter->TagFilter)}
               {foreach name=tagfilter from=$NaviFilter->TagFilter item=tag}
               <input type="hidden" name="tf{$smarty.foreach.tagfilter.iteration}" value="{$tag->kTag}" />
               {/foreach}
            {/if}
      
            <!-- article informationen -->      
            <div class="article_info_wrapper">
               <ul class="article_info">
                  {assign var=anzeige value=$Einstellungen.artikeluebersicht.artikeluebersicht_lagerbestandsanzeige}
                  {if $Artikel->nErscheinendesProdukt}
                        <li>{lang key="productAvailable" section="global"}: <strong>{$Artikel->Erscheinungsdatum_de}</strong></li>
                     {if $Einstellungen.global.global_erscheinende_kaeuflich=="Y"}
                        <li><strong>{lang key="preorderPossible" section="global"}</strong></li>
                     {/if}
                  {elseif $Artikel->cLagerBeachten == "Y" && ($Artikel->cLagerKleinerNull == "N" || $Einstellungen.artikeluebersicht.artikeluebersicht_lagerbestandanzeige_anzeigen == 'U') && $Artikel->fLagerbestand <= 0 && $Artikel->fZulauf > 0 && isset($Artikel->dZulaufDatum_de)}
                     {assign var=cZulauf value=`$Artikel->fZulauf`:::`$Artikel->dZulaufDatum_de`}
                     <li class="clean popover">
                        <span class="signal_image a1">{lang key="productInflowing" section="productDetails" printf=$cZulauf}</span>
                        {include file="tpl_inc/artikel_warenlager.tpl"}
                     </li>
                  {elseif $Einstellungen.artikeluebersicht.artikeluebersicht_lagerbestandanzeige_anzeigen != 'N' && $Artikel->cLagerBeachten == "Y" && $Artikel->fLagerbestand <= 0 && $Artikel->fLieferantenlagerbestand > 0 && $Artikel->fLieferzeit > 0 && ($Artikel->cLagerKleinerNull == "N" || $Einstellungen.artikeluebersicht.artikeluebersicht_lagerbestandanzeige_anzeigen == 'U')}
                     <li class="clean">
                        <span class="signal_image a1">{lang key="supplierStockNotice" section="global" printf=$Artikel->fLieferzeit}</span>
                     </li>
                  {elseif $anzeige=='verfuegbarkeit' || $anzeige=='genau'}
                     <li class="clean popover">
                         <span class="signal_image a{$Artikel->Lageranzeige->nStatus}">{$Artikel->Lageranzeige->cLagerhinweis[$anzeige]}</span>
                         {include file="tpl_inc/artikel_warenlager.tpl"}
                     </li>
                  {elseif $anzeige=='ampel'}
                     <li class="clean popover">
                        <span class="signal_image a{$Artikel->Lageranzeige->nStatus}">{$Artikel->Lageranzeige->AmpelText}</span>
                        {include file="tpl_inc/artikel_warenlager.tpl"}
                     </li>
                  {/if}
                  
                  {if $Einstellungen.template.articleoverview.article_show_no == 'Y'}
                     <li>{lang key="productNo" section="global"}: <strong>{$Artikel->cArtNr}</strong></li>
                  {/if}
                  
                  {if isset($Artikel->dMHD) && isset($Artikel->dMHD_de)}
                     <li title="{lang key='productMHDTool' section='global'}" class="best-before"><strong>{lang key="productMHD" section="global"}:</strong> {$Artikel->dMHD_de}</li>
                  {/if}
                  
                  {if $Einstellungen.artikeluebersicht.artikeluebersicht_hersteller_anzeigen == "Y" && $Artikel->cName_thersteller}
                     <li>{lang key="manufacturerSingle" section="productOverview"}: {if $Artikel->cHomepage_thersteller}<a href="{$Artikel->cHomepage_thersteller}">{/if} <strong>{$Artikel->cName_thersteller}</strong> {if $Artikel->cHomepage_thersteller}</a>{/if}</li>
                  {elseif $Einstellungen.artikeluebersicht.artikeluebersicht_hersteller_anzeigen == "BT" && $Artikel->cName_thersteller && $Artikel->cBildpfad_thersteller}
                     <li>{lang key="manufacturerSingle" section="productOverview"}: {if $Artikel->cHomepage_thersteller}<a href="{$Artikel->cHomepage_thersteller}">{/if} <strong>{$Artikel->cName_thersteller}</strong> {if $Artikel->cHomepage_thersteller}</a>{/if}</li>
                     <li><a href="{$Artikel->cHomepage_thersteller}"><img src="{$Artikel->cBildpfad_thersteller}" alt="" /></a></li>
                  {elseif $Einstellungen.artikeluebersicht.artikeluebersicht_hersteller_anzeigen == "B" && $Artikel->cBildpfad_thersteller}
                     <li>{lang key="manufacturerSingle" section="productOverview"}: {if $Artikel->cHomepage_thersteller}<a href="{$Artikel->cHomepage_thersteller}">{/if} <img src="{$Artikel->cBildpfad_thersteller}" alt="" /> {if $Artikel->cHomepage_thersteller}</a>{/if}</li>
                  {/if}
                  
                  {if $Artikel->cGewicht && $Einstellungen.artikeluebersicht.artikeluebersicht_gewicht_anzeigen == "Y" && $Artikel->cGewicht > 0}
                     <li>{lang key="shippingWeight" section="global"}: <strong>{$Artikel->cGewicht} kg</strong></li>
                  {/if}
                  
                  {if $Artikel->cArtikelgewicht && $Einstellungen.artikeluebersicht.artikeluebersicht_artikelgewicht_anzeigen == "Y" && $Artikel->cArtikelgewicht > 0}
                     <li>{lang key="productWeight" section="global"}: <strong>{$Artikel->cArtikelgewicht} kg</strong></li>
                  {/if}
                  
                  {if $Einstellungen.artikeluebersicht.artikeluebersicht_artikelintervall_anzeigen == "Y" && $Artikel->fAbnahmeintervall > 0}
                     <li>{lang key="purchaseIntervall" section="productOverview"}: <strong>{$Artikel->fAbnahmeintervall} {$Artikel->cEinheit}</strong></li>
                  {/if}
               
                  {if count($Artikel->Variationen)>0}
                     <li>{lang key="variationsIn" section="productOverview"}: <strong>{foreach name=variationen from=$Artikel->Variationen item=Variation}{if !$smarty.foreach.variationen.first}, {/if}{$Variation->cName}{/foreach}</strong>
                     {if $Artikel->oVariationKombiVorschau_arr|@count > 0 && $Artikel->oVariationKombiVorschau_arr && $Einstellungen.artikeluebersicht.artikeluebersicht_varikombi_anzahl > 0}
                        <ul class="articles_combi">
                           {foreach name=varikombis from=$Artikel->oVariationKombiVorschau_arr item=oVariationKombiVorschau}
                              <li><a href="{$oVariationKombiVorschau->cURL}" onmouseover="imageSwitch('{$Artikel->kArtikel}', '{$oVariationKombiVorschau->cBildKlein}');" onmouseout="imageSwitch('{$Artikel->kArtikel}');"><img src="{$oVariationKombiVorschau->cBildMini}" alt="" /></a></li>
                           {/foreach}
                        </ul>
                     {/if}
                     </li>
                  {/if}
               
                  <li class="clean clear">
                     <ul class="actions">
                        {if $Einstellungen.artikeluebersicht.artikeluebersicht_vergleichsliste_anzeigen == "Y"}
                           <li><button name="Vergleichsliste" type="submit" class="compare"><span>{lang key="addToCompare" section="productOverview"}</span></button></li>
                        {/if}
                        {if $Einstellungen.artikeluebersicht.artikeluebersicht_wunschzettel_anzeigen == "Y"}
                           <li><button name="Wunschliste" type="submit" class="wishlist">{lang key="addToWishlist" section="productDetails"}</button></li>
                        {/if}
                        {if $Artikel->verfuegbarkeitsBenachrichtigung == 3 && (($Artikel->cLagerBeachten == 'Y' && $Artikel->cLagerKleinerNull != 'Y') || $Artikel->cLagerBeachten != 'Y')}
                           <li><button type="button" id="n{$Artikel->kArtikel}" class="popup notification">{lang key="requestNotification" section="global"}</button></li>
                        {/if}
                     </ul>
                  </li>
                  {if $Einstellungen.template.articleoverview.article_show_short_desc == 'Y' && $Artikel->cKurzBeschreibung|@count_characters > 0}
                     <li id="article_short_desc" class="clean custom_content">
                        {$Artikel->cKurzBeschreibung}
                     </li>
                  {/if}
               </ul>
               
               {if isset($Einstellungen.artikeluebersicht.artikeluebersicht_finanzierung_anzeigen) && $Einstellungen.artikeluebersicht.artikeluebersicht_finanzierung_anzeigen == "Y" && isset($Artikel->oRateMin)}
                  <div class="article_financing financing">
                     <p><strong>{lang key="fromJust" section="global"} {$Artikel->oRateMin->cRateLocalized} {lang key="monthlyPer" section="global"}</strong></p>
                     <small>{$Artikel->oRateMin->cHinweisHTML}</small>
                  </div>
               {/if}
            
               <!-- Warenkorb / Anzahl -->
               <div class="article_price">
                  <ul>
                  {if $smarty.session.Kundengruppe->darfPreiseSehen}
                     {if $Artikel->Preise->fVKNetto==0 && $Artikel->bHasKonfig}
                        <li class="price price_as_configured">{lang key="priceAsConfigured" section="productDetails"}</li>
                     {elseif $Artikel->Preise->fVKNetto==0 && $Einstellungen.global.global_preis0=="N"}
                        <li class="price">{lang key="priceOnApplication" section="global"}</li>
                     {else}
                        {if $Artikel->Preise->rabatt>0 && !$Artikel->Preise->Sonderpreis_aktiv}
                           {if $Einstellungen.artikeluebersicht.artikeluebersicht_rabattanzeige==2 || $Einstellungen.artikeluebersicht.artikeluebersicht_rabattanzeige==4}
                              <li><small>{lang key="discount" section="global"}: {$Artikel->Preise->rabatt}%</small></li>
                           {/if}
                           {if $Einstellungen.artikeluebersicht.artikeluebersicht_rabattanzeige==3 || $Einstellungen.artikeluebersicht.artikeluebersicht_rabattanzeige==4}
                              <li><small>{lang key="oldPrice" section="global"}: <del>{$Artikel->Preise->alterVKLocalized[$NettoPreise]}</del></small></li>
                           {/if}
                        {/if}
                        {if $Artikel->Preise->Sonderpreis_aktiv && $Einstellungen.artikeluebersicht.artikeluebersicht_sonderpreisanzeige==2}
                           <li><small>{lang key="insteadOf" section="global"}: <del>{$Artikel->Preise->alterVKLocalized[$NettoPreise]}</del></small></li>
                        {/if}
                        <li>
                           <span class="price_label">
                           {if $Artikel->Preise->Sonderpreis_aktiv}
                              {lang key="specialPrice" section="global"}
                           {else}
                              {if $Artikel->nVariationsAufpreisVorhanden == 1 || $Artikel->bHasKonfig}
                                 {lang key="priceStarting" section="global"}
                              {elseif $Artikel->Preise->rabatt>0}
                                 {lang key="nowOnly" section="global"}
                              {else}
                                 {lang key="only" section="global"}
                              {/if}
                           {/if}
                           </span>
                           {if $Artikel->Preise->strPreisGrafik_Suche}
                              <span class="price_image">{$Artikel->Preise->strPreisGrafik_Suche}</span>
                           {else}
                              <span class="price">{$Artikel->Preise->cVKLocalized[$NettoPreise]}</span>
                           {/if}
                        </li>
                        {if $Artikel->cLocalizedVPE}
                           <li><small><b>{lang key="basePrice" section="global"}:</b> {$Artikel->cLocalizedVPE[$NettoPreise]}</small></li>
                        {/if}
                        <li><span class="vat_info">{$Artikel->cMwstVersandText}</span></li>
                        
                        {if $Artikel->Preise->fPreis1>0 && $Artikel->Preise->nAnzahl1>0}
                           {include file='tpl_inc/staffelpreise_inc.tpl'}
                        {/if}
                        
                     {/if}
                  {else}
                     {lang key="priceHidden" section="global"}
                  {/if}
                  </ul>
                  <div class="article_buy">
                     <fieldset>
                     {if ($Artikel->inWarenkorbLegbar == 1 || ($Artikel->nErscheinendesProdukt == 1 && $Einstellungen.global.global_erscheinende_kaeuflich == "Y")) && $Artikel->nIstVater == 0 && $Artikel->Variationen|@count == 0 && !$Artikel->bHasKonfig}
                        <span><input type="text" onfocus="this.setAttribute('autocomplete', 'off');" id="quantity{$Artikel->kArtikel}" class="quantity" name="anzahl" {if $Artikel->fAbnahmeintervall}value="{$Artikel->fAbnahmeintervall}" onblur="javascript:gibAbnahmeIntervall(this, {$Artikel->fAbnahmeintervall});"{else}value="1"{/if} /></span>
                        {if $Einstellungen.artikeluebersicht.artikeluebersicht_anzahl_pfeile == "Y" || ($Einstellungen.artikeluebersicht.artikeluebersicht_anzahl_pfeile == "I" && $Artikel->fAbnahmeintervall > 1)}
                        <span class="change_quantity">
                           <a href="#" onclick="javascript:erhoeheArtikelAnzahl('quantity{$Artikel->kArtikel}', {if $Artikel->fAbnahmeintervall > 1}true, {$Artikel->fAbnahmeintervall}{else}false, 0{/if});return false;">+</a>
                           <a href="#" onclick="javascript:erniedrigeArtikelAnzahl('quantity{$Artikel->kArtikel}', {if $Artikel->fAbnahmeintervall > 1}true, {$Artikel->fAbnahmeintervall}{else}false, 0{/if});return false;">-</a>
                        </span>
                        {/if}
                        {$Artikel->cEinheit}
                        <input type="submit" id="submit{$Artikel->kArtikel}" {if $Einstellungen.template.articleoverview.article_pushed_to_basket == "Y"}onclick="return addToBasket('{$Artikel->kArtikel}', $('#quantity{$Artikel->kArtikel}').val(), '#image_drag_article'{if $Einstellungen.template.articleoverview.article_pushed_to_basket_animation == "Y"}, true{/if});"{/if} value="{lang key="addToCart" section="global"}" />
                     {else}
                        <button type="button" onclick="window.location.href='{$Artikel->cURL}'">{lang key="details"}</button>
                     {/if}
                     </fieldset>
                  </div>
               </div>
            </div>
         </fieldset>
      </form>
      
      {if $Artikel->verfuegbarkeitsBenachrichtigung==3}    
         <div id="popupn{$Artikel->kArtikel}" class="hidden">
            {include file='tpl_inc/artikel_produktverfuegbarformular.tpl' scope='artikeldetails'}
         </div>
      {/if}
      
      {if isset($Einstellungen.artikeluebersicht.artikeluebersicht_finanzierung_anzeigen) && $Einstellungen.artikeluebersicht.artikeluebersicht_finanzierung_anzeigen == "Y" && isset($Artikel->oRateMin)}
         <div id="popupf{$Artikel->kArtikel}" class="hidden">
            {include file='tpl_inc/suche_finanzierung.tpl'}
         </div>
      {/if}
      
      <div class="clear"></div>
   </div>
</li>
{/foreach}
</ul>
{include file='tpl_inc/suche_footer.tpl'}