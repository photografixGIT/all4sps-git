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
   <div class="container">
         
   {foreach name=startboxen from=$StartseiteBoxen item=Box}
      {if isset($Box->Artikel->elemente) && count($Box->Artikel->elemente)>0}
      
         {if $Box->name=="TopAngebot"}
            {assign var=hTitle value="topOffer"}
         {elseif $Box->name=="Sonderangebote"}
            {assign var=hTitle value="specialOffer"}
         {elseif $Box->name=="NeuImSortiment"}
            {assign var=hTitle value="newProducts"}
         {elseif $Box->name=="Bestseller"}
            {assign var=hTitle value="bestsellers"}
         {/if}
      {if $Einstellungen.template.articleoverview.article_show_slider=='Y' && count($Box->Artikel->elemente)>4}
         
         {include file="tpl_inc/artikel_inc_slider.tpl" cID=$hTitle cClass="start-slider" cKey=$hTitle cSection="global" oArtikel_arr=$Box->Artikel->elemente nVisible=4}
         
      {else}
      
         <h2 class="title">{lang key=$hTitle section="global"}</h2>
            
         <ul class="hlist articles">
         {foreach name=boxartikel from=$Box->Artikel->elemente item=Artikel}
            {counter assign=imgcounter print=0}
            <li class="p23 {if $smarty.foreach.boxartikel.iteration % 4 == 0}nomargin {/if}{if $smarty.foreach.boxartikel.index % 4 == 0}clear{/if}">
               <div class="pwrapper">
               <p class="pimage">
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
               <h3><a href="{$Artikel->cURL}">{$Artikel->cName}</a></h3>

               {if $Box->name=="TopAngebot"}
                  {assign var="price_image" value=$Artikel->Preise->strPreisGrafik_TopboxStartseite}
               {elseif $Box->name=="NeuImSortiment"}
                  {assign var="price_image" value=$Artikel->Preise->strPreisGrafik_NeuboxStartseite}
               {elseif $Box->name=="Sonderangebote"}
                  {assign var="price_image" value=$Artikel->Preise->strPreisGrafik_SonderboxStartseite}
               {elseif $Box->name=="Bestseller"}
                  {assign var="price_image" value=$Artikel->Preise->strPreisGrafik_BestsellerboxStartseite}
               {/if}
               
			   
               <div class="left p40">
				  <a href="{$Artikel->cURL}" title="{$Artikel->cName|strip_tags|escape:"quotes"}" class="detail_article_box_link">Details</a>
                  <!--<span class="stars p{$Artikel->fDurchschnittsBewertung|replace:'.':'_'}"></span>-->
               </div>
               
               <div class="left p60 tright">
                  {include file="tpl_inc/artikel_preis.tpl" scope="content"}
               </div>
               
               </div>
            </li>
         {/foreach}
         </ul>
         
         {/if}

      {/if}
   {/foreach}
   
   </div>
   
{/if}

{if isset($oNews_arr) && $oNews_arr|@count > 0}
<div class="spacer m40"></div>

<h2 class="title">{lang key="news" section="news" alt_section="global,"}</h2>
<div class="container news">
   <ul class="hlist articles">
   {foreach name=news from=$oNews_arr item=oNews}
      <li class="p23 {if $smarty.foreach.news.iteration % 4 == 0}nomargin {/if}{if $smarty.foreach.news.index % 4 == 0}clear{/if}">

      <h3><a href="{$oNews->cURL}">{$oNews->cBetreff}</a></h3>
      
      <div class="custom_content">
         {if $oNews->cVorschauText|count_characters > 0}
            {$oNews->cVorschauText|truncate:230:"..."}    
         {elseif $oNews->cText|strip_tags|count_characters > 120}
            {$oNews->cText|strip_tags|truncate:10:""} 
         {else}
            {$oNews->cText}
         {/if}
      </div>
         <p><em>{$oNews->dErstellt_de}{if isset($Einstellungen.news.news_kommentare_nutzen) && $Einstellungen.news.news_kommentare_nutzen == "Y"} &nbsp; ({$oNews->nNewsKommentarAnzahl} {if $oNews->nNewsKommentarAnzahl == 1}{lang key="newsComment" section="news"}{else}{lang key="newsComments" section="news"}{/if}{/if})</em></p>
         <p>{$oNews->cMehrURL}</p>
      </li>
   {/foreach}
   </ul>
   
</div> 
{/if}