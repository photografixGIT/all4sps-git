{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
<div id="content">
{include file='tpl_inc/inc_breadcrumb.tpl'}

{if !isset($oNavigationsinfo)}
   <h1>{$Suchergebnisse->SuchausdruckWrite}</h1>
{/if}

{if isset($hinweis) && $hinweis|@count_characters > 0}
   <p class="container box_success">{$hinweis}</p>
{/if}

{if isset($fehler) && $fehler|@count_characters > 0}
   <p class="container box_error">{$fehler}</p>
{/if}

{if $Suchergebnisse->SucheErfolglos == 1}
   <p class="box_info">{lang key="noResults" section="productOverview"}</p>
   <form id="suche2" action="navi.php" method="get" class="form">
      <fieldset>
         <ul class="input_block">
            <li><label for="searchkey">Suchbegriff</label>
               <input type="text" name="suchausdruck" value="{$Suchergebnisse->cSuche|escape:'htmlall'}" id="searchkey" />
            </li>
            <li class="clear">
               {if $SESSION_NOTWENDIG}
               <input type="hidden" name="{$session_name}" value="{$session_id}" />
               {/if}
               <input type="submit" value="{lang key="searchAgain" section="productOverview"}" class="submit" />
            </li>
         </ul>
      </fieldset>
   </form>
{/if}

{include file="tpl_inc/inc_extension.tpl"}

{if isset($oNavigationsinfo)}
   <div class="category_wrapper clearall">
      <ul class="category_item">
         {if $oNavigationsinfo->cBildURL|count_characters > 0 && $oNavigationsinfo->cBildURL ne 'gfx/keinBild.gif' && $oNavigationsinfo->cBildURL ne 'gfx/keinBild_kl.gif'}
            <li class="img"><img src="{$oNavigationsinfo->cBildURL}" alt="{$oNavigationsinfo->oKategorie->cBeschreibung|strip_tags|escape:"quotes"|truncate:40}" /></li>
         {/if}
         <li class="desc">
            {if $oNavigationsinfo->cName}<div class="pageTitle"><h1>{$oNavigationsinfo->cName}</h1></div>{/if}
            {*if $Einstellungen.navigationsfilter.kategorie_beschreibung_anzeigen == "Y" && $oNavigationsinfo->oKategorie->cBeschreibung|count_characters > 0}
               <div class="item_desc custom_content">{$oNavigationsinfo->oKategorie->cBeschreibung}</div>
            {/if}
            {if $Einstellungen.navigationsfilter.hersteller_beschreibung_anzeigen == "Y" && $oNavigationsinfo->oHersteller->cBeschreibung|count_characters > 0}
               <div class="item_desc custom_content">{$oNavigationsinfo->oHersteller->cBeschreibung}</div>
            {/if}
            {if $Einstellungen.navigationsfilter.merkmalwert_beschreibung_anzeigen == "Y" && $oNavigationsinfo->oMerkmalWert->cBeschreibung|count_characters > 0}
               <div class="item_desc custom_content">{$oNavigationsinfo->oMerkmalWert->cBeschreibung}</div>
            {/if*}
         </li>
      </ul>
   </div>

   {if $oUnterKategorien_arr|@count > 0 && $Einstellungen.navigationsfilter.artikeluebersicht_bild_anzeigen != "N"}
      <ul class="category_subcategories hlist">
      {foreach name=unterkats from=$oUnterKategorien_arr item=Unterkat}
         <li class="p33 {if $smarty.foreach.unterkats.index%3==0 && $smarty.foreach.unterkats.index>0}clear{/if}">
            <div class="category_wrapper clearall child {if $smarty.foreach.unterkats.index%3==0}first{else}last{/if}">
               <ul class="category_item">
                  <li class="img">
                     {if $Einstellungen.navigationsfilter.artikeluebersicht_bild_anzeigen == "B" || $Einstellungen.navigationsfilter.artikeluebersicht_bild_anzeigen == "BT"}
                        <a href="{$Unterkat->cURL}"><img alt="{$Unterkat->cName}" src="{$Unterkat->cBildURL}" /></a>
                     {/if}
                  </li>
                  <li class="desc">
                     {if $Einstellungen.navigationsfilter.artikeluebersicht_bild_anzeigen == "Y" || $Einstellungen.navigationsfilter.artikeluebersicht_bild_anzeigen == "BT"}
                        <h2><a href="{$Unterkat->cURL}">{$Unterkat->cName}</a></h2>
                     {/if}
                     {if $Einstellungen.navigationsfilter.unterkategorien_beschreibung_anzeigen == "Y"}
                        <p class="item_desc">{$Unterkat->cBeschreibung|strip_tags|truncate:45}</p>
                     {/if}
                     {if $Einstellungen.navigationsfilter.unterkategorien_lvl2_anzeigen == "Y"}
                        {if isset($Unterkat->Unterkategorien) && $Unterkat->Unterkategorien|@count > 0}
                           {foreach from=$Unterkat->Unterkategorien item=UnterUnterKat}
                              <p>&bull; <a href="{$UnterUnterKat->cURL}">{$UnterUnterKat->cName}</a></p>
                           {/foreach}
                        {/if}
                     {/if}
                  </li>
               </ul>
            </div>
         </li>
      {/foreach}
      </ul>
   {/if}
{/if}

{* Bestseller *}
{if isset($oBestseller_arr) && $oBestseller_arr|@count > 0}
    {include file='tpl_inc/suche_bestseller.tpl'}
{/if}
   
{include file="auswahlassistent.tpl"}

{if count($Suchergebnisse->Artikel->elemente)>0}
   <form id="improve_search" action="navi.php" method="get" class="form">
   <fieldset class="outer">
   {if $SESSION_NOTWENDIG}
      <input type="hidden" name="{$session_name}" value="{$session_id}" />
   {/if}
   {if $NaviFilter->Kategorie->kKategorie > 0}<input type="hidden" name="k" value="{$NaviFilter->Kategorie->kKategorie}" />{/if}
   {if $NaviFilter->Hersteller->kHersteller > 0}<input type="hidden" name="h" value="{$NaviFilter->Hersteller->kHersteller}" />{/if}
   {if $NaviFilter->Suchanfrage->kSuchanfrage > 0}<input type="hidden" name="l" value="{$NaviFilter->Suchanfrage->kSuchanfrage}" />{/if}
   {if $NaviFilter->MerkmalWert->kMerkmalWert > 0}<input type="hidden" name="m" value="{$NaviFilter->MerkmalWert->kMerkmalWert}" />{/if}
   {if $NaviFilter->Suchspecial->kKey > 0}<input type="hidden" name="q" value="{$NaviFilter->Suchspecial->kKey}" />{/if}
   {if $NaviFilter->SuchspecialFilter->kKey > 0}<input type="hidden" name="qf" value="{$NaviFilter->SuchspecialFilter->kKey}" />{/if}
   {if $NaviFilter->Suche->cSuche|count > 0}<input type="hidden" name="suche" value="{$NaviFilter->Suche->cSuche|escape:'htmlall'}" />{/if}
   {if $NaviFilter->Tag->kTag > 0}<input type="hidden" name="t" value="{$NaviFilter->Tag->kTag}" />{/if}
   {if is_array($NaviFilter->MerkmalFilter) && !$NaviFilter->MerkmalWert->kMerkmalWert}
      {foreach name=merkmalfilter from=$NaviFilter->MerkmalFilter item=mmfilter}
         <input type="hidden" name="mf{$smarty.foreach.merkmalfilter.iteration}" value="{$mmfilter->kMerkmalWert}" />
      {/foreach}
   {/if}
   {if isset($cJTLSearchStatedFilter_arr) && $cJTLSearchStatedFilter_arr|@count > 0}
   	  {foreach name=jtlsearchstatedfilter from=$cJTLSearchStatedFilter_arr key=key item=cJTLSearchStatedFilter}
 	     <input name="fq{$key}" type="hidden" value="{$cJTLSearchStatedFilter}" />
      {/foreach}
   {/if}
   {if is_array($NaviFilter->TagFilter)}
   {foreach name=tagfilter from=$NaviFilter->TagFilter item=tag}
   <input type="hidden" name="tf{$smarty.foreach.tagfilter.iteration}" value="{$tag->kTag}" />
   {/foreach}
   {/if}
   {if is_array($NaviFilter->SuchFilter)}
      {foreach name=suchfilter from=$NaviFilter->SuchFilter item=oSuche}
         <input type="hidden" name="sf{$smarty.foreach.suchfilter.iteration}" value="{$oSuche->kSuchanfrage}">
      {/foreach}
   {/if}
   
   <div class="container nomargintop">
      <ul class="hlist">
         <li class="p50">
            {*<strong>{lang key="page" section="productOverview" alt_section="global,"} {$Suchergebnisse->Seitenzahlen->AktuelleSeite}</strong> {lang key="of" section="productOverview"} {$Suchergebnisse->Seitenzahlen->MaxSeiten}*}
            {$Suchergebnisse->GesamtanzahlArtikel} {if $Suchergebnisse->GesamtanzahlArtikel>0}{lang key="products" section="global"}{else}{lang key="product" section="global"}{/if}, {lang key="showProducts" section="global"} {$Suchergebnisse->ArtikelVon} - {$Suchergebnisse->ArtikelBis}
         </li>
            
         <li class="p50 tright">
            
{if $Suchergebnisse->Seitenzahlen->maxSeite>1 && isset($oNaviSeite_arr) && $oNaviSeite_arr|@count > 0}

 
         {if $Suchergebnisse->Seitenzahlen->AktuelleSeite>1}

               &laquo; <a href="{$oNaviSeite_arr.zurueck->cURL}">{lang key="previous" section="productOverview" alt_section="global,"}</a>

         {/if}

         {foreach name=seite from=$oNaviSeite_arr item=oNaviSeite}
         {if !isset($oNaviSeite->nBTN)}
         <span class="page {if !isset($oNaviSeite->cURL) || $oNaviSeite->cURL|count_characters == 0}selected{/if}">
         {if isset($oNaviSeite->cURL) && $oNaviSeite->cURL|count_characters > 0}
            <a href="{$oNaviSeite->cURL}">{$oNaviSeite->nSeite}</a>
         {else}
            <a href="#" onclick="return false;">{$oNaviSeite->nSeite}</a>
         {/if}
         </span>
         {/if}
         {/foreach}

         {if $Suchergebnisse->Seitenzahlen->AktuelleSeite < $Suchergebnisse->Seitenzahlen->maxSeite}

            .. {lang key="of" section="productOverview"} <span class="page">{$Suchergebnisse->Seitenzahlen->MaxSeiten}</span>

            <span class="page">
            <a href="{$oNaviSeite_arr.vor->cURL}">{lang key="next" section="productOverview" alt_section="global,"}</a> &raquo;
            </span>

         {/if}

      &nbsp;|&nbsp;
      <form action="navi.php" id="goto" method="get">

      <input type="hidden" name="{$session_name}" value="{$session_id}" />
      {if $NaviFilter->Kategorie->kKategorie > 0}<input type="hidden" name="k" value="{$NaviFilter->Kategorie->kKategorie}" />{/if}
      {if $NaviFilter->Hersteller->kHersteller > 0}<input type="hidden" name="h" value="{$NaviFilter->Hersteller->kHersteller}" />{/if}
      {if $NaviFilter->Suchanfrage->kSuchanfrage > 0}<input type="hidden" name="l" value="{$NaviFilter->Suchanfrage->kSuchanfrage}" />{/if}
      {if $NaviFilter->MerkmalWert->kMerkmalWert > 0}<input type="hidden" name="m" value="{$NaviFilter->MerkmalWert->kMerkmalWert}" />{/if}
      {if $NaviFilter->Tag->kTag > 0}<input type="hidden" name="t" value="{$NaviFilter->Tag->kTag}" />{/if}
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
      {lang key="goToPage" section="productOverview"}: {*<input type="text" name="seite" class="gehzuseite" /> <input type="submit" value="{lang key="go" section="productOverview"}" class="button" />*}

      <select name="seite" onchange="window.location.href=this.options[this.selectedIndex].value">
      {foreach name=seite from=$oNaviSeite_arr item=oNaviSeite}
      {if !isset($oNaviSeite->nBTN)}
         <option value="{$oNaviSeite->cURL}"{if $oNaviSeite->nSeite == $Suchergebnisse->Seitenzahlen->AktuelleSeite}selected="selected"{/if}>{$oNaviSeite->nSeite}</option>
      {/if}      
      {/foreach}
      </select>      

      </form>


{/if}            
            
         </li>
      </ul>
   </div>
   
   {if $Einstellungen.artikeluebersicht.suchfilter_anzeigen_ab == 0 || count($Suchergebnisse->Artikel->elemente) >= $Einstellungen.artikeluebersicht.suchfilter_anzeigen_ab}
      <fieldset id="fsetSearch">
         <legend>{lang key="improveYourSearch" section="global"}</legend>
         <div id="article_filter">
            {if $Einstellungen.navigationsfilter.allgemein_kategoriefilter_benutzen == "Y" && $Suchergebnisse->Kategorieauswahl|@count > 1}
               <select name="kf" onchange="$('#improve_search').submit();">
                  {if $NaviFilter->KategorieFilter->kKategorie > 0 || $Einstellungen.navigationsfilter.kategoriefilter_anzeigen_als == "HF" || (!$NaviFilter->Kategorie->kKategorie && !$NaviFilter->KategorieFilter->kKategorie)}
                  <option value="0">{lang key="allCategories" section="productOverview"}</option> 
                  {/if}
                  {if $NaviFilter->Kategorie->kKategorie > 0 || $NaviFilter->KategorieFilter->kKategorie > 0}
                  <option value="{$NaviFilter->KategorieFilter->kKategorie}" {if $NaviFilter->KategorieFilter->kKategorie > 0}selected="selected"{/if}>{if $Einstellungen.navigationsfilter.kategoriefilter_anzeigen_als == "HF" && $NaviFilter->KategorieFilter->kKategorie > 0}{$NaviFilter->KategorieFilter->cName}{else}{$Suchergebnisse->Kategorieauswahl[0]->cName}{/if}</option>
                  {/if}
                  {if !$NaviFilter->Kategorie->kKategorie && (!$NaviFilter->KategorieFilter->kKategorie || $Einstellungen.navigationsfilter.kategoriefilter_anzeigen_als == "HF")}    
                  {foreach name=kategorieauswahl from=$Suchergebnisse->Kategorieauswahl item=Kategorie}
                  {if $Kategorie->kKategorie != $NaviFilter->KategorieFilter->kKategorie}
                  <option value="{$Kategorie->kKategorie}">{$Kategorie->cName} {if !$nMaxAnzahlArtikel}({$Kategorie->nAnzahl}){/if}</option>
                  {/if}
                  {/foreach}
                  {/if}
               </select>
            {/if}

            {if $Einstellungen.navigationsfilter.allgemein_herstellerfilter_benutzen == "Y"}
                 <select id="hf" name="hf" class="suche_improve_search" onchange="$('#improve_search').submit();">
            {if $NaviFilter->Hersteller->kHersteller > 0 || $NaviFilter->HerstellerFilter->kHersteller > 0}
            {if $NaviFilter->HerstellerFilter->kHersteller > 0}
            <option value="0">{lang key="allManufacturers" section="global"}</option>
            {/if}
                 <option value="{$NaviFilter->HerstellerFilter->kHersteller}" {if $NaviFilter->HerstellerFilter->kHersteller > 0}selected="selected"{/if}>{$Suchergebnisse->Herstellerauswahl[0]->cName}</option>
            {else}                                
                 <option value="0">{lang key="allManufacturers" section="global"}</option>
            {foreach name=herstellerauswahl from=$Suchergebnisse->Herstellerauswahl item=Hersteller}
            <option value="{$Hersteller->kHersteller}">{$Hersteller->cName} {if !$nMaxAnzahlArtikel}({$Hersteller->nAnzahl}){/if}</option>
            {/foreach}
            {/if}
                 </select>
            {/if}
                 
            {if $Einstellungen.navigationsfilter.preisspannenfilter_benutzen == "content"}
                 <select name="pf" onchange="$('#improve_search').submit();">
                 <option value="0">{lang key="allPrices" section="global"}</option>
                 
                 {if $NaviFilter->PreisspannenFilter && $NaviFilter->PreisspannenFilter->fBis > 0}
                     <option value="{$NaviFilter->PreisspannenFilter->cWert}" selected="selected">{$NaviFilter->PreisspannenFilter->cVonLocalized} - {$NaviFilter->PreisspannenFilter->cBisLocalized}</option>
                     <option value="-1">-</option>
                 {/if}
                 
            {foreach name=preisspannenfilter from=$Suchergebnisse->Preisspanne item=oPreisspannenfilter}
                 <option value="{$oPreisspannenfilter->nVon}_{$oPreisspannenfilter->nBis}"{if $NaviFilter->PreisspannenFilter->fVon == $oPreisspannenfilter->nVon && $NaviFilter->PreisspannenFilter->fBis == $oPreisspannenfilter->nBis} selected="selected"{/if}>
                     {$oPreisspannenfilter->cVonLocalized} - {$oPreisspannenfilter->cBisLocalized} {if !$nMaxAnzahlArtikel}({$oPreisspannenfilter->nAnzahlArtikel}){/if}
                 </option>
            {/foreach}
            {if $Suchergebnisse->Preisspanne|@count == 0}
            {if $NaviFilter->PreisspannenFilter->cWert|count > 0}
                 <option value="{$NaviFilter->PreisspannenFilter->fVon}_{$NaviFilter->PreisspannenFilter->fBis}" selected="selected">
                     {$NaviFilter->PreisspannenFilter->fVon} {$smarty.session.Waehrung->cNameHTML} - {$NaviFilter->PreisspannenFilter->fBis} {$smarty.session.Waehrung->cNameHTML}
                 </option>
            {/if}
            {/if}
                 </select>
            {else}
                 {if $NaviFilter->PreisspannenFilter->fBis > 0}<input type="hidden" name="pf" value="{$NaviFilter->PreisspannenFilter->cWert}">{/if}
            {/if}

            {if $Einstellungen.navigationsfilter.bewertungsfilter_benutzen == "content"}
                 <select name="bf" onchange="$('#improve_search').submit();">
                 <option value="0">{lang key="allRatings" section="global"}</option>
            {foreach name=bewertung from=$Suchergebnisse->Bewertung item=oBewertung}
            <option value="{$oBewertung->nStern}"{if $NaviFilter->BewertungFilter->nSterne == $oBewertung->nStern} selected="selected"{/if}>{$oBewertung->nStern} {if !$nMaxAnzahlArtikel}({$oBewertung->nAnzahl}){/if}</option>
            {/foreach}
            {if $Suchergebnisse->Bewertung|@count == 0}
            {if $NaviFilter->BewertungFilter->nSterne > 0}
                 <option value="{$NaviFilter->BewertungFilter->nSterne}" selected="selected">
                     {$NaviFilter->BewertungFilter->nSterne}
                 </option>
            {/if}
            {/if}
                 </select>
            {else}
                 {if $NaviFilter->BewertungFilter->nSterne > 0}<input type="hidden" name="bf" value="{$NaviFilter->BewertungFilter->nSterne}">{/if}
            {/if}
            
            <select name="Sortierung" onchange="$('#improve_search').submit();">
               {if !$Suchergebnisse->Sortierung}<option value="0">{lang key="sorting" section="productOverview"}</option>{/if}
                  <option value="100" {if $smarty.session.Usersortierung==$Sort->value}selected="selected"{/if}>{lang key="standard" section="global"}</option>
                  {foreach name=sortierliste from=$Sortierliste item=Sort}
                     <option value="{$Sort->value}" {if $smarty.session.Usersortierung==$Sort->value}selected="selected"{/if}>{$Sort->angezeigterName}</option>
                  {/foreach}
            </select>
            <select name="af" onchange="$('#improve_search').submit();">
               <option value="0" {if $smarty.session.ArtikelProSeite == 0}selected="selected"{/if}>{lang key="productsPerPage" section="productOverview"}</option>
               <option value="10" {if $smarty.session.ArtikelProSeite == 10}selected="selected"{/if}>10 {lang key="productsPerPage" section="productOverview"}</option>
               <option value="20" {if $smarty.session.ArtikelProSeite == 20}selected="selected"{/if}>20 {lang key="productsPerPage" section="productOverview"}</option>
               <option value="50" {if $smarty.session.ArtikelProSeite == 50}selected="selected"{/if}>50 {lang key="productsPerPage" section="productOverview"}</option>
               <option value="100" {if $smarty.session.ArtikelProSeite == 100}selected="selected"{/if}>100 {lang key="productsPerPage" section="productOverview"}</option>
            </select>

            {if $Einstellungen.navigationsfilter.merkmalfilter_verwenden == "content"}
               {if $Suchergebnisse->MerkmalFilter|@count > 0 && $Suchergebnisse->Artikel->elemente|@count > 0}
               <div id="filter_group">
               
                  {if $Suchergebnisse->Suchspecialauswahl[1]->nAnzahl > 0 ||
                      $Suchergebnisse->Suchspecialauswahl[2]->nAnzahl > 0 ||
                      $Suchergebnisse->Suchspecialauswahl[3]->nAnzahl > 0 ||
                      $Suchergebnisse->Suchspecialauswahl[4]->nAnzahl > 0 ||
                      $Suchergebnisse->Suchspecialauswahl[5]->nAnzahl > 0 ||
                      $Suchergebnisse->Suchspecialauswahl[6]->nAnzahl > 0}
                  <div class="item">
                     <strong class="label">{lang key="specificProducts" section="global"}</strong>
                     <ul class="values">
                        {if $Suchergebnisse->Suchspecialauswahl[1]->nAnzahl > 0}<li> <a href="{$Suchergebnisse->Suchspecialauswahl[1]->cURL}">{lang key="bestsellers" section="global"}</a> <em class="count">{if !$nMaxAnzahlArtikel}({$Suchergebnisse->Suchspecialauswahl[1]->nAnzahl}){/if}</em></li>{/if}
                        {if $Suchergebnisse->Suchspecialauswahl[2]->nAnzahl > 0}<li> <a href="{$Suchergebnisse->Suchspecialauswahl[2]->cURL}">{lang key="specialOffer" section="global"}</a> <em class="count">{if !$nMaxAnzahlArtikel}({$Suchergebnisse->Suchspecialauswahl[2]->nAnzahl}){/if}</em></li>{/if}
                        {if $Suchergebnisse->Suchspecialauswahl[3]->nAnzahl > 0}<li> <a href="{$Suchergebnisse->Suchspecialauswahl[3]->cURL}">{lang key="newProducts" section="global"}</a> <em class="count">{if !$nMaxAnzahlArtikel}({$Suchergebnisse->Suchspecialauswahl[3]->nAnzahl}){/if}</em></li>{/if}
                        {if $Suchergebnisse->Suchspecialauswahl[4]->nAnzahl > 0}<li> <a href="{$Suchergebnisse->Suchspecialauswahl[4]->cURL}">{lang key="topOffer" section="global"}</a> <em class="count">{if !$nMaxAnzahlArtikel}({$Suchergebnisse->Suchspecialauswahl[4]->nAnzahl}){/if}</em></li>{/if}
                        {if $Suchergebnisse->Suchspecialauswahl[5]->nAnzahl > 0}<li> <a href="{$Suchergebnisse->Suchspecialauswahl[5]->cURL}">{lang key="upcomingProducts" section="global"}</a> <em class="count">{if !$nMaxAnzahlArtikel}({$Suchergebnisse->Suchspecialauswahl[5]->nAnzahl}){/if}</em></li>{/if}
                        {if $Suchergebnisse->Suchspecialauswahl[6]->nAnzahl > 0}<li> <a href="{$Suchergebnisse->Suchspecialauswahl[6]->cURL}">{lang key="topReviews" section="global"}</a> <em class="count">{if !$nMaxAnzahlArtikel}({$Suchergebnisse->Suchspecialauswahl[6]->nAnzahl}){/if}</em></li>{/if}
                     </ul>
                  </div>
                  {/if}
                  
                  {if $NaviFilter->SuchspecialFilter->kKey > 0 && $NaviFilter->Suchspecial->kKey != $NaviFilter->SuchspecialFilter->kKey}
                  <div class="item">
                     <strong class="label">{lang key="specificProducts" section="global"}</strong>
                     <ul class="values">
                        {if $NaviFilter->SuchspecialFilter->kKey == 1}
                           <li class="selected"><a href="{$NaviFilter->URL->cAlleSuchspecials}" class="active">{lang key="bestsellers" section="global"}</a></li>
                        {elseif $NaviFilter->SuchspecialFilter->kKey == 2}
                           <li class="selected"><a href="{$NaviFilter->URL->cAlleSuchspecials}" class="active">{lang key="specialOffer" section="global"}</a></li>
                        {elseif $NaviFilter->SuchspecialFilter->kKey == 3}
                           <li class="selected"><a href="{$NaviFilter->URL->cAlleSuchspecials}" class="active">{lang key="newProducts" section="global"}</a></li>
                        {elseif $NaviFilter->SuchspecialFilter->kKey == 4}
                           <li class="selected"><a href="{$NaviFilter->URL->cAlleSuchspecials}" class="active">{lang key="topOffer" section="global"}</a></li>
                        {elseif $NaviFilter->SuchspecialFilter->kKey == 5}
                           <li class="selected"><a href="{$NaviFilter->URL->cAlleSuchspecials}" class="active">{lang key="upcomingProducts" section="global"}</a></li>
                        {elseif $NaviFilter->SuchspecialFilter->kKey == 6}
                           <li class="selected"><a href="{$NaviFilter->URL->cAlleSuchspecials}" class="active">{lang key="topReviews" section="global"}</a></li>
                        {/if}
                     </ul>
                  </div>
                  {/if}
               
                  {foreach name=merkmalfilter from=$Suchergebnisse->MerkmalFilter item=Merkmal}
                     <div class="item">
                        <strong class="label">
                           {if $Einstellungen.navigationsfilter.merkmal_anzeigen_als == "T"}
                              {$Merkmal->cName}
                           {elseif $Einstellungen.navigationsfilter.merkmal_anzeigen_als == "BT"}
                              {if $Merkmal->cBildpfadKlein ne "gfx/keinBild.gif"}<img src="{$Merkmal->cBildpfadKlein}" class="vmiddle" alt="{$Merkmal->cName}" /> {/if}{$Merkmal->cName}
                           {elseif $Einstellungen.navigationsfilter.merkmal_anzeigen_als == "B"}
                              <img src="{$Merkmal->cBildpfadKlein}" class="vmiddle" alt="{$Merkmal->cName}" />
                           {/if}     
                        </strong>
                     
                        <ul class="values">
                           {if $Merkmal->cTyp == "SELECTBOX"}
                              {assign var=kMerkmalWert value=0}
                              {foreach name=merkmalwertfilter from=$Merkmal->oMerkmalWerte_arr item=MerkmalWert}
                                 {if $MerkmalWert->nAktiv}
                                    {assign var=kMerkmalWert value=$MerkmalWert->kMerkmalWert}
                                 {/if}
                              {/foreach}
                              <li>
                                 <select onChange="location.href=this.options[this.selectedIndex].value">
                                    <option value="{$NaviFilter->URL->cAlleMerkmalWerte[$kMerkmalWert]}">{lang key="showAll" section="global"}</option>
                           {/if}
                           {foreach name=merkmalwertfilter from=$Merkmal->oMerkmalWerte_arr item=MerkmalWert}
                           {if $MerkmalWert->nAktiv}
                              {assign var=kMerkmalWert value=$MerkmalWert->kMerkmalWert}
                              {if $Merkmal->cTyp == "TEXT" || $Merkmal->cTyp == ""}
                                 <li class="selected"><a href="{$NaviFilter->URL->cAlleMerkmalWerte[$kMerkmalWert]}">{$MerkmalWert->cWert}</a> <em class="count">{if !$nMaxAnzahlArtikel}({$MerkmalWert->nAnzahl}){/if}</em></li>
                              {elseif $Merkmal->cTyp == "BILD-TEXT"}
                                 <li class="selected"><a href="{$NaviFilter->URL->cAlleMerkmalWerte[$kMerkmalWert]}"><img src="{$MerkmalWert->cBildpfadKlein}" alt="{$MerkmalWert->cWert}" /> {$MerkmalWert->cWert}</a> <em class="count">{if !$nMaxAnzahlArtikel}({$MerkmalWert->nAnzahl}){/if}</em></li>
                              {elseif $Merkmal->cTyp == "BILD"}
                                 <li class="selected"><a href="{$NaviFilter->URL->cAlleMerkmalWerte[$kMerkmalWert]}"><img src="{$MerkmalWert->cBildpfadKlein}" alt="{$MerkmalWert->cWert}" /></a> <em class="count">{if !$nMaxAnzahlArtikel}({$MerkmalWert->nAnzahl}){/if}</em></li>
                              {elseif $Merkmal->cTyp == "SELECTBOX"}
                                 <option value="{$NaviFilter->URL->cAlleMerkmalWerte[$kMerkmalWert]}" selected="selected">{$MerkmalWert->cWert}</option>
                              {/if}
                           {else}
                              {if $Merkmal->cTyp == "TEXT" || $Merkmal->cTyp == ""}
                                 <li><a href="{$MerkmalWert->cURL}">{$MerkmalWert->cWert}</a> <em class="count">{if !$nMaxAnzahlArtikel}({$MerkmalWert->nAnzahl}){/if}</em></li>
                              {elseif $Merkmal->cTyp == "BILD-TEXT"}
                                 <li><a href="{$MerkmalWert->cURL}"><img src="{$MerkmalWert->cBildpfadKlein}" alt="{$MerkmalWert->cWert}" /> {$MerkmalWert->cWert}</a> <em class="count">{if !$nMaxAnzahlArtikel}({$MerkmalWert->nAnzahl}){/if}</em></li>
                              {elseif $Merkmal->cTyp == "BILD"}
                                 <li><a href="{$MerkmalWert->cURL}"><img src="{$MerkmalWert->cBildpfadKlein}" alt="{$MerkmalWert->cWert}" /></a> <em class="count">{if !$nMaxAnzahlArtikel}({$MerkmalWert->nAnzahl}){/if}</em></li>
                              {elseif $Merkmal->cTyp == "SELECTBOX"}
                                 <option value="{$MerkmalWert->cURL}">{$MerkmalWert->cWert}{if !$nMaxAnzahlArtikel} ({$MerkmalWert->nAnzahl}){/if}</option>
                              {/if}
                           {/if}
                           {/foreach}
                           {if $Merkmal->cTyp == "SELECTBOX"}
                              </select></li>
                           {/if}
                        </ul>
                     </div>
                  {/foreach}
               </div>
               {/if}
            {/if}
         </div>
      </fieldset>
   {/if}

   {if isset($oErweiterteDarstellung) && isset($Einstellungen.artikeluebersicht.artikeluebersicht_erw_darstellung) && $Einstellungen.artikeluebersicht.artikeluebersicht_erw_darstellung == "Y"}
   <fieldset id="fsetExtend">
      <div id="extended_design">
         <p class="left">{lang key="showAs" section="productOverview"}:</p>
         <a href="{$oErweiterteDarstellung->cURL_arr[1]}" id="ed_list" onclick="switchStyle('1', 'list');return false;" class="ed list {if $oErweiterteDarstellung->nDarstellung == 1}active{/if}">{lang key="list" section="productOverview"}</a>
         <a href="{$oErweiterteDarstellung->cURL_arr[2]}" id="ed_gallery" onclick="switchStyle('2', 'gallery');return false;" class="ed gallery {if $oErweiterteDarstellung->nDarstellung == 2}active{/if}">{lang key="gallery" section="productOverview"}</a>
         <a href="{$oErweiterteDarstellung->cURL_arr[3]}" id="ed_mosaic" onclick="switchStyle('3', 'mosaic');return false;" class="ed mosaic {if $oErweiterteDarstellung->nDarstellung == 3}active{/if}">{lang key="mosaic" section="productOverview"}</a>
      {if $smarty.session.nArtikelUebersichtVLKey_arr|@count > 1 && $smarty.session.nArtikelUebersichtVLKey_arr|@count <= $Einstellungen.vergleichsliste.vergleichsliste_anzahl}
       <a href="#" id="compare_showall" onclick="return showCompareList(1);" class="right">{lang key="addAllToCompareList" section="productOverview" alt_section="global,"}</a>
      {/if} 
      </div>
   </fieldset>
   {/if}
   </fieldset>
</form>
{/if}

{if $Suchergebnisse->Artikel->elemente|@count <= 0}
{if $KategorieInhalt->TopArtikel->elemente|@count >0}
   <div class="container">
      <h2 class="title">{lang key="topOffer" section="global"}</h2>
      <ul class="hlist articles">
      {foreach name=topartikel from=$KategorieInhalt->TopArtikel->elemente item=Artikel}
      {if $smarty.foreach.topartikel.index < 3}
         <li class="p309 {if $smarty.foreach.topartikel.iteration % 3 == 0}nomargin {/if}{if $smarty.foreach.topartikel.index % 3 == 0}clear{/if}">
            <div class="pwrapper">
            <p class="pimage">
               <a href="{$Artikel->cURL}">
                  <img alt="{$Artikel->cName}" src="{$Artikel->cVorschaubild}" class="image" id="image{$Artikel->kArtikel}" />
                  {if isset($Artikel->oSuchspecialBild)}
                     <script type="text/javascript">
                        set_overlay('#image{$Artikel->kArtikel}', '{$Artikel->oSuchspecialBild->nPosition}', '{$Artikel->oSuchspecialBild->nMargin}', '{$Artikel->oSuchspecialBild->cPfadKlein}');
                     </script>
                  {/if}
                </a>
            </p>
               <h3><a href="{$Artikel->cURL}">{$Artikel->cName}</a></h3>
            
               <div class="left p40">
                  <span class="stars p{$Artikel->fDurchschnittsBewertung|replace:'.':'_'}"></span>
               </div>
               
               <div class="left p60 tright">
                  {if $smarty.session.Kundengruppe->darfPreiseSehen}
                  <p>
                     <span class="price_label">{lang key="only" section="global"}</span> <span class="price">{$Artikel->Preise->cVKLocalized[$NettoPreise]}</span>
                  </p>
                  {if $Artikel->cLocalizedVPE}
                     <p><small><b>{lang key="basePrice" section="global"}:</b> {$Artikel->cLocalizedVPE[$NettoPreise]}</small></p>
                  {/if}
                  <p>
                     <span class="vat_info">{$Artikel->cMwstVersandText}</span>
                  </p>
                  {/if}
               </div>
               
            </div>
         </li>
         {/if}
      {/foreach}
      </ul>
   </div>
{/if}

{if $KategorieInhalt->BestsellerArtikel->elemente|@count >0}
   <div class="container">
      <h2 class="title">{lang key="bestsellers" section="global"}</h2>
      <ul class="hlist articles">
      {foreach name=artikel from=$KategorieInhalt->BestsellerArtikel->elemente item=Artikel}
      {if $smarty.foreach.artikel.index < 3}
         <li class="p309 {if $smarty.foreach.artikel.iteration % 3 == 0}nomargin {/if}{if $smarty.foreach.artikel.index % 3 == 0}clear{/if}">
            <div class="pwrapper">
            <p class="pimage">
               <a href="{$Artikel->cURL}">
                  <img alt="{$Artikel->cName}" src="{$Artikel->cVorschaubild}" class="image" id="image{$Artikel->kArtikel}" />
                  {if isset($Artikel->oSuchspecialBild)}
                     <script type="text/javascript">
                        set_overlay('#image{$Artikel->kArtikel}', '{$Artikel->oSuchspecialBild->nPosition}', '{$Artikel->oSuchspecialBild->nMargin}', '{$Artikel->oSuchspecialBild->cPfadKlein}');
                     </script>
                  {/if}
                </a>
            </p>
            
            <h3><a href="{$Artikel->cURL}">{$Artikel->cName}</a></h3>
            
               <div class="left p40">
                  <span class="stars p{$Artikel->fDurchschnittsBewertung|replace:'.':'_'}"></span>
               </div>
               
               <div class="left p60 tright">
                  {if $smarty.session.Kundengruppe->darfPreiseSehen}
                  <p>
                     <span class="price_label">{lang key="only" section="global"}</span> <span class="price">{$Artikel->Preise->cVKLocalized[$NettoPreise]}</span>
                  </p>
                  {if $Artikel->cLocalizedVPE}
                     <p><small><b>{lang key="basePrice" section="global"}:</b> {$Artikel->cLocalizedVPE[$NettoPreise]}</small></p>
                  {/if}
                  <p>
                     <span class="vat_info">{$Artikel->cMwstVersandText}</span>
                  </p>
                  {/if}
               </div>
               
            
            </div>
            {/if}
         </li>
      {/foreach}
      </ul>
   </div>
{/if}
{/if}