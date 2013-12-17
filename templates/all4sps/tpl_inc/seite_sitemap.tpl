{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}

{if $Einstellungen.sitemap.sitemap_seiten_anzeigen == "Y"}
<h2>{lang key="sitemapSites" section="global"}</h2>

<ul class="hlist">
{foreach name=linkgruppen from=$smarty.session.Linkgruppen item=oLinkgruppe}
    <li class="p33">
    {get_navigation type=$oLinkgruppe->cName class="vlist" classhead="linkhead"}
    </li>
{/foreach}
</ul>

{/if}

{if $Einstellungen.sitemap.sitemap_kategorien_anzeigen == "Y"}
{if $oKategorieliste->elemente|@count > 0}
<div class="container">
<h2>{lang key="sitemapKats" section="global"}</h2>
   <ul class="hlist">
      {foreach name=kategorien from=$oKategorieliste->elemente item=oKategorie}
         {if $oKategorie->children|@count > 0}
         <li class="p33">
            <ul class="vlist">
               <li><a href="{$oKategorie->cURL}" title="{$oKategorie->cName}"><strong>{$oKategorie->cName}</strong></a></li>
               {foreach name=Subkategorien from=$oKategorie->children item=oSubKategorie}
                  <li>&nbsp;&nbsp;<a href="{$oSubKategorie->cURL}" title="{$oKategorie->cName}">{$oSubKategorie->cName}</a></li>
                  {if $oSubKategorie->children|@count > 0}
                  <ul class="vlist">
                  {foreach name=SubSubkategorien from=$oSubKategorie->children item=oSubSubKategorie}
                     <li>&nbsp;&nbsp;&nbsp;&nbsp;<a href="{$oSubSubKategorie->cURL}" title="{$oKategorie->cName}">{$oSubSubKategorie->cName}</a></li>
                  {/foreach}
                  </ul>
                  {/if}
               {/foreach}
            </ul>
         </li>
         {/if}
      {/foreach}
   
      <li class="p33">
         <ul class="vlist">
            <li><b>{lang key="otherCategories" section="global"}</b></li>
            {foreach name=kategorien from=$oKategorieliste->elemente item=oKategorie}
               {if $oKategorie->children|@count == 0}
               <li>&nbsp;&nbsp;<a href="{$oKategorie->cURL}" title="{$oKategorie->cName}">{$oKategorie->cName}</a></li>
               {/if}
            {/foreach}
         </ul>
      </li>
   </ul>
</div>
{/if}
{/if}

{if $Einstellungen.sitemap.sitemap_globalemerkmale_anzeigen == "Y"}
{if $oGlobaleMerkmale_arr|@count > 0}
<div class="container">
<h2>{lang key="sitemapGlobalAttributes" section="global"}</h2>
   {foreach name=globalemerkmale from=$oGlobaleMerkmale_arr item=oGlobaleMerkmale}
      <ul class="vlist">
         <strong>{$oGlobaleMerkmale->cName}</strong>
      {foreach name=globalemerkmalwerte from=$oGlobaleMerkmale->oMerkmalWert_arr item=oGlobaleMerkmaleWerte}
         <li class="p33">
            <a href="{$oGlobaleMerkmaleWerte->cURL}">{$oGlobaleMerkmaleWerte->cWert}</a>
         </li>
      {/foreach}
      
      </ul>
   {/foreach}
</div>
{/if}
{/if}

{if $Einstellungen.sitemap.sitemap_hersteller_anzeigen == "Y"}
{if $oHersteller_arr|@count > 0}
<div class="container">
<h2>{lang key="sitemapNanufacturer" section="global"}</h2>
   <ul class="vlist">
   {foreach name=hersteller from=$oHersteller_arr item=oHersteller}
      <li><a href="{$oHersteller->cURL}">{$oHersteller->cName}</a></li>
   {/foreach}
   </ul>
</div>
{/if}
{/if}

{if $Einstellungen.sitemap.sitemap_news_anzeigen == "Y"}
{if $oNewsMonatsUebersicht_arr|@count > 0}
<div class="container">
<h2>{lang key="sitemapNews" section="global"}</h2>
   {foreach name=newsmonatsuebersicht from=$oNewsMonatsUebersicht_arr item=oNewsMonatsUebersicht}
   {if $oNewsMonatsUebersicht->oNews_arr|@count > 0}
   {assign var="i" value=`$smarty.foreach.newsmonatsuebersicht.iteration-1`}
      <ul class="vlist">
         <b><a href="{$oNewsMonatsUebersicht->cURL}">{$oNewsMonatsUebersicht->cName}</a></b>
         {foreach name=news from=$oNewsMonatsUebersicht->oNews_arr item=oNews}
         <li>&nbsp;&nbsp;<a href="{$oNews->cURL}">{$oNews->cBetreff}</a></li>
         {/foreach}
      </ul>
   {/if}
   {/foreach}
</div>
{/if}
{/if}

{if $Einstellungen.sitemap.sitemap_newskategorien_anzeigen == "Y"}
{if $oNewsKategorie_arr|@count > 0}
<div class="container">
<h2>{lang key="sitemapNewsCats" section="global"}</h2>
   {foreach name=newskategorie from=$oNewsKategorie_arr item=oNewsKategorie}
   {if $oNewsKategorie->oNews_arr|@count > 0}
      <ul class="vlist">
         <b><a href="{$oNewsKategorie->cURL}">{$oNewsKategorie->cName}</a></b>
         {foreach name=news from=$oNewsKategorie->oNews_arr item=oNews}
         <li>&nbsp;&nbsp;<a href="{$oNews->cURL}">{$oNews->cBetreff}</a></li>
         {/foreach}
      </ul>
   {/if}
   {/foreach}
</div>
{/if}
{/if}