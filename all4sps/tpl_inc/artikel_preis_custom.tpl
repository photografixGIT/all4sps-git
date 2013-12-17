{**
 * copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 *
 * this file may not be redistributed in whole or significant part
 * and is subject to the JTL-Software-GmbH license.
 *
 * license: http://jtl-software.de/jtlshop3license.html
 *}
{if $smarty.session.Kundengruppe->darfPreiseSehen}
   <p class="price_wrapper">{strip}
   {* --- Preis auf Anfrage? --- *}
   {if $Artikel->Preise->fVKNetto==0 && $Artikel->bHasKonfig}
      <span class="price_label price_as_configured">{lang key="priceAsConfigured" section="productDetails"}</span>
   {elseif $Artikel->Preise->fVKNetto==0 && $Einstellungen.global.global_preis0=="N"}
      <span class="price_label price_on_application"{if $price_id} id="{$price_id}"{/if}>{lang key="priceOnApplication" section="global"}</span>
   {else}
         {if $Artikel->Preise->Sonderpreis_aktiv}
            <span class="price_label special">{lang key="specialPrice" section="global"}: </span>
         {else}
            {if $Artikel->nVariationsAufpreisVorhanden == 1 || $Artikel->bHasKonfig}
               <span class="price_label pricestarting">{lang key="priceStarting" section="global"} </span>
            {elseif $Artikel->Preise->rabatt>0}
               <span class="price_label nowonly">{lang key="nowOnly" section="global"} </span>
            {else}
               <span class="price_label only">{lang key="only" section="global"} </span>
            {/if}
         {/if}
         {if $price_image}
            <span class="price_img"{if $price_id} id="{$price_id}"{/if}>{$price_image}</span><!-- /price_img -->
         {else}
             <span class="price"{if $price_id} id="{$price_id}"{/if}>{$Artikel->Preise->cVKLocalized[$NettoPreise]}</span>
         {/if}
         {if $Artikel->oPreisradar}
             <br />{lang key="youSave" section="productDetails"} <span class="priceradar">{$Artikel->oPreisradar->fDiffLocalized[$NettoPreise]} ({$Artikel->oPreisradar->fProzentDiff} %)</span>
         {/if}
{*         
         {if $Artikel->cEinheit && ($Artikel->fMindestbestellmenge > 1 || $Artikel->fAbnahmeintervall > 1)}
           <span class="price_label per_unit"> {lang key="vpePer" section="global"} 1 {$Artikel->cEinheit}</span>
         {/if}
*}
       
       {* Grundpreis anzeigen? *}
       {if $Artikel->cLocalizedVPE}
          <br /><small class="base_price"><b class="label">{lang key="basePrice" section="global"}: </b><span class="value">{$Artikel->cLocalizedVPE[$NettoPreise]}</span></small>
       {/if}
       
      <br />
       <span class="price_note">
       {assign var=foo value=", "|explode:$Artikel->cMwstVersandText}
          <span class="vat_info">{$foo[0]}</span><!--<br />
		   <a href="{$Artikel->cURL}" title="{$Artikel->cName|strip_tags|escape:"quotes"}" class="detail_article_box_link">Details</a>-->
		  
{*
         {if $Artikel->Preise->Sonderpreis_aktiv && $Einstellungen.artikeldetails.artikeldetails_sonderpreisanzeige==2}
            <br /><span class="instead_of old_price"><span class="label">{lang key="oldPrice" section="global"}: </span><del><span class="value">{$Artikel->Preise->alterVKLocalized[$NettoPreise]}</span></del></span>
         {elseif !$Artikel->Preise->Sonderpreis_aktiv && $Artikel->Preise->rabatt>0}
            {if $Einstellungen.artikeldetails.artikeldetails_rabattanzeige==3 || $Einstellungen.artikeldetails.artikeldetails_rabattanzeige==4}
               <br /><span class="old_price"><span class="label">{lang key="oldPrice" section="global"}: </span><del><span class="value">{$Artikel->Preise->alterVKLocalized[$NettoPreise]}</span></del></span>
            {/if}
            {if $Einstellungen.artikeldetails.artikeldetails_rabattanzeige==2 || $Einstellungen.artikeldetails.artikeldetails_rabattanzeige==4}
               <br /><span class="discount"><span class="label">{lang key="discount" section="global"}: </span><span class="value">{$Artikel->Preise->rabatt}%</span></span>
            {/if}
         {/if}
*}
         {* --- Unverbindliche Preisempfehlung anzeigen? Nur auf Detailseite möglich --- *}
{*
         {if $show_suggested_price=='Y' && $Artikel->fUVP>0}
            <br /><span class="suggested_price"><abbr class="label" title="{lang key="suggestedPriceExpl" section="productDetails" alt_section="productDetails,"}">{lang key="suggestedPrice" section="productDetails" alt_section="productDetails,"}</abbr>: <span class="value">{$UVPlocalized}</span></span>      
         {/if}
*}
         {* --- Staffelpreise? --- *}
{*
         {if $Artikel->Preise->fPreis1>0 && $Artikel->Preise->nAnzahl1>0 && (!isset($scope) || $scope eq 'article_details') }
            <br /><span class="blockpricing">{include file='tpl_inc/staffelpreise_inc.tpl'}</span>
         {else}
            {if $Artikel->SieSparenX->anzeigen==1 && $Artikel->SieSparenX->nProzent > 0}
               <span class="yousave"><span class="label">{lang key="youSave" section="productDetails" alt_section="productDetails,"}</span> <span class="percent">{$Artikel->SieSparenX->nProzent}%</span>, {lang key="thatIs" section="productDetails" alt_section="productDetails,"} <span class="value">{$Artikel->SieSparenX->cLocalizedSparbetrag}</span></span>
            {/if}
         {/if}
*}
       </span>{* /price_note *}
   {/if}
   {/strip}</p>{* /price_wrapper *}
{else}
   {lang key="priceHidden" section="global"}
{/if}