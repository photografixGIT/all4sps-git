{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
{if isset($cFehler) && $cFehler|count_characters > 0}
    <p class="box_error">{$cFehler}</p>
{/if}

{include file="auswahlassistent.tpl"}

{if isset($StartseiteBoxen) && $StartseiteBoxen|@count > 0}
   {foreach name=startboxen from=$StartseiteBoxen item=Box}
      {if isset($Box->Artikel->elemente) && count($Box->Artikel->elemente)>0}
         <div class="container">
         {if $Box->name=="TopAngebot"}
            <h1 class="underline">{lang key="topOffer" section="global"}</h1>
         {elseif $Box->name=="Sonderangebote"}
            <h1 class="underline">{lang key="specialOffer" section="global"}</h1>
         {elseif $Box->name=="NeuImSortiment"}
            <h1 class="underline">{lang key="newProducts" section="global"}</h1>
         {elseif $Box->name=="Bestseller"}
            <h1 class="underline">{lang key="bestsellers" section="global"}</h1>
         {/if}
            
         <ul class="hlist articles">
         {foreach name=boxartikel from=$Box->Artikel->elemente item=Artikel}
            {counter assign=imgcounter print=0}
            <li class="p33 tcenter {if $smarty.foreach.boxartikel.index % 3 == 0}clear{/if}">
               <div>
               <p>
               {if $Box->name=="Bestseller"}
                  <a href="{$Artikel->cURL}">
                     {if isset($oSuchspecialoverlay_arr.bestseller->cBildPfad) && $oSuchspecialoverlay_arr.bestseller->cBildPfad|count_characters > 0 && $oSuchspecialoverlay_arr.bestseller->nAktiv > 0}
                        <img src="{$Artikel->cVorschaubild}" alt="{$Artikel->cName|strip_tags|escape:"quotes"|truncate:60}" class="image" id="overlay{$Artikel->kArtikel}_{$imgcounter}" />                  
                        <script type="text/javascript">
                           set_overlay('#overlay{$Artikel->kArtikel}_{$imgcounter}', '{$Artikel->oSuchspecialBild->nPosition}', '{$Artikel->oSuchspecialBild->nMargin}', '{$Artikel->oSuchspecialBild->cPfadKlein}');
                        </script>
                     {else}
                        <img src="{$Artikel->cVorschaubild}" class="image" alt="{$Artikel->cName|strip_tags|escape:"quotes"|truncate:60}" />
                     {/if}
                   </a>
               {/if}
              
               
               {if $Box->name=="TopAngebot"}
                  <a href="{$Artikel->cURL}">
                     {if isset($oSuchspecialoverlay_arr.topangebote->cPfadNormal) && $oSuchspecialoverlay_arr.topangebote->cPfadNormal|count_characters > 0 && $oSuchspecialoverlay_arr.topangebote->nAktiv > 0}
                        <img src="{$Artikel->cVorschaubild}" alt="{$Artikel->cName|strip_tags|escape:"quotes"|truncate:60}" class="image" id="overlay{$Artikel->kArtikel}_{$imgcounter}" />
                        <script type="text/javascript">
                           set_overlay('#overlay{$Artikel->kArtikel}_{$imgcounter}', '{$Artikel->oSuchspecialBild->nPosition}', '{$Artikel->oSuchspecialBild->nMargin}', '{$Artikel->oSuchspecialBild->cPfadKlein}');
                        </script>
                     {else}
                        <img src="{$Artikel->cVorschaubild}" title="{$Artikel->cName}" class="image" alt="{$Artikel->cName|strip_tags|escape:"quotes"|truncate:60}" />
                     {/if}
                  </a>
               {/if}
               
               
               {if $Box->name=="Sonderangebote"}
                  <a href="{$Artikel->cURL}">
                     {if isset($oSuchspecialoverlay_arr.sonderangebote->cBildPfad) && $oSuchspecialoverlay_arr.sonderangebote->cBildPfad|count_characters > 0 && $oSuchspecialoverlay_arr.sonderangebote->nAktiv > 0}
                        <img src="{$Artikel->cVorschaubild}" alt="{$Artikel->cName|strip_tags|escape:"quotes"|truncate:60}" class="image" id="overlay{$Artikel->kArtikel}_{$imgcounter}" />
                        <script type="text/javascript">
                           set_overlay('#overlay{$Artikel->kArtikel}_{$imgcounter}', '{$Artikel->oSuchspecialBild->nPosition}', '{$Artikel->oSuchspecialBild->nMargin}', '{$Artikel->oSuchspecialBild->cPfadKlein}');
                        </script>
                     {else}
                        <img src="{$Artikel->cVorschaubild}" class="image" alt="{$Artikel->cName|strip_tags|escape:"quotes"|truncate:60}" />
                     {/if}
                  </a>
               {/if}
               
               {if $Box->name=="NeuImSortiment"}
                  <a href="{$Artikel->cURL}">
                     {if isset($oSuchspecialoverlay_arr.neuimsortiment->cBildPfad) && $oSuchspecialoverlay_arr.neuimsortiment->cBildPfad|count_characters > 0 && $oSuchspecialoverlay_arr.neuimsortiment->nAktiv > 0}
                        <img src="{$Artikel->cVorschaubild}" alt="{$Artikel->cName|strip_tags|escape:"quotes"|truncate:60}" class="image" id="overlay{$Artikel->kArtikel}_{$imgcounter}" />
                        <script type="text/javascript">
                           set_overlay('#overlay{$Artikel->kArtikel}_{$imgcounter}', '{$Artikel->oSuchspecialBild->nPosition}', '{$Artikel->oSuchspecialBild->nMargin}', '{$Artikel->oSuchspecialBild->cPfadKlein}');
                        </script>
                     {else}
                        <img src="{$Artikel->cVorschaubild}" class="image" alt="{$Artikel->cName|strip_tags|escape:"quotes"|truncate:60}" />
                     {/if}
                  </a>
               {/if}
               </p>
               <p><a href="{$Artikel->cURL}">{$Artikel->cName}</a></p>

               {if $Box->name=="TopAngebot"}
                  {assign var="price_image" value=$Artikel->Preise->strPreisGrafik_TopboxStartseite}
               {elseif $Box->name=="NeuImSortiment"}
                  {assign var="price_image" value=$Artikel->Preise->strPreisGrafik_NeuboxStartseite}
               {elseif $Box->name=="Sonderangebote"}
                  {assign var="price_image" value=$Artikel->Preise->strPreisGrafik_SonderboxStartseite}
               {elseif $Box->name=="Bestseller"}
                  {assign var="price_image" value=$Artikel->Preise->strPreisGrafik_BestsellerboxStartseite}
               {/if}
               
               {include file="tpl_inc/artikel_preis.tpl" scope="content"}
               
               </div>
            </li>
         {/foreach}
         </ul>
         </div>
      {/if}
   {/foreach}
{/if}

{if isset($oNews_arr) && $oNews_arr|@count > 0}
<div class="container news_list">
   <h1 class="underline">{lang key="news" section="news" alt_section="global,"}</h1>
   {foreach name=news from=$oNews_arr item=oNews}
       <div class="newsitem">       		
          <h2><a href="{$oNews->cURL}">{$oNews->cBetreff}</a></h2>
          {$oNews->dErstellt_de}{if isset($Einstellungen.news.news_kommentare_nutzen) && $Einstellungen.news.news_kommentare_nutzen == "Y"} | <a href="{$oNews->cURL}#comments" title="{lang key="readComments" section="news"}">{$oNews->nNewsKommentarAnzahl} {if $oNews->nNewsKommentarAnzahl == 1}{lang key="newsComment" section="news"}{else}{lang key="newsComments" section="news"}{/if}{/if}</a>
          <div class="custom_content">
             {if $oNews->cVorschauText|count_characters > 0}
                {$oNews->cVorschauText}    
                {$oNews->cMehrURL}
             {elseif $oNews->cText|strip_tags|count_characters > 200}
                {$oNews->cText|strip_tags|truncate:200:""} {$oNews->cMehrURL}
             {else}
                {$oNews->cText}
             {/if}
          </div>
       </div>
   {/foreach}
</div>
{/if}