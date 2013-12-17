<!-- cloud -->
<div class="container clear p100">
{if $Suchergebnisse->Artikel->elemente|@count > 0}

   {if $Einstellungen.navigationsfilter.allgemein_tagfilter_benutzen == "Y"}
      {if $Suchergebnisse->Tags|@count > 0 && $Suchergebnisse->TagsJSON}
      <div class="tag_filter_wrapper">
         <fieldset class="cl">
            <legend>{lang key="productsTaggedAs" section="productOverview"}{$Einstellungen.sonstiges.sonstiges_tagging_all_count}</legend>
            {if $Einstellungen.template.articleoverview.show_flash_cloud != "Y"}
               <div class="tagbox">
               {foreach name=tagfilter from=$Suchergebnisse->Tags item=oTag}
                  <a href="{$oTag->cURL}" class="tag{$oTag->Klasse}">{$oTag->cName}</a>
               {/foreach}
               </div>
            {else}
               <object type="application/x-shockwave-flash" data="{$PFAD_FLASHCLOUD}tagcloud.swf" width="100%" height="150">
                  <param name="movie" value="{$PFAD_FLASHCLOUD}tagcloud.swf" />
                  <param name="wmode" value="transparent" />
                  <param name="allowscriptaccess" value="always" />
                  <param name="FlashVars" value="data_json={$Suchergebnisse->TagsJSON}" />
               </object>
            {/if}
         </fieldset>
      </div>
      {/if}
   {/if}
 
   {if $Einstellungen.navigationsfilter.suchtrefferfilter_nutzen == "Y"}
      {if $Suchergebnisse->SuchFilter|@count > 0 && $Suchergebnisse->SuchFilterJSON}
         {if !$NaviFilter->SuchFilter->kSuchanfrage}
         <div class="tag_filter_wrapper">
            <fieldset class="cr">
               <legend>{lang key="productsSearchTerm" section="productOverview"}{$Einstellungen.sonstiges.sonstiges_tagging_all_count}</legend>
               
               {if $Einstellungen.template.articleoverview.show_flash_cloud != "Y"}
                  <div class="tagbox">
                  {foreach name=tagfilter from=$Suchergebnisse->SuchFilter item=oSuchFilter}
                     <a href="{$oSuchFilter->cURL}" class="tag{$oSuchFilter->Klasse}">{$oSuchFilter->cSuche}</a>
                  {/foreach}
                  </div>
               {else}
                  <object type="application/x-shockwave-flash" data="{$PFAD_FLASHCLOUD}tagcloud.swf" width="100%" height="150">
                     <param name="movie" value="{$PFAD_FLASHCLOUD}tagcloud.swf" />
                     <param name="wmode" value="transparent" />
                     <param name="allowscriptaccess" value="always" />
                     <param name="FlashVars" value="data_json={$Suchergebnisse->SuchFilterJSON}" />
                  </object>
               {/if}
            </fieldset>
         </div>
         {/if}
      {/if}
   {/if}
   
   <div class="clear"></div>
   
{/if}
</div>
<!-- //cloud -->

{if $Suchergebnisse->Seitenzahlen->maxSeite>1 && isset($oNaviSeite_arr) && $oNaviSeite_arr|@count > 0}
<div class="container page_navigation">
   <div class="left">
      <ul class="pagenavi">
         {if $Suchergebnisse->Seitenzahlen->AktuelleSeite>1}
            <li class="prev">
               &laquo; <a href="{$oNaviSeite_arr.zurueck->cURL}">{lang key="previous" section="productOverview" alt_section="global,"}</a>
            </li>
         {/if}

         {foreach name=seite from=$oNaviSeite_arr item=oNaviSeite}
         {if !isset($oNaviSeite->nBTN)}
         <li class="page {if !isset($oNaviSeite->cURL) || $oNaviSeite->cURL|count_characters == 0}selected{/if}">
         {if isset($oNaviSeite->cURL) && $oNaviSeite->cURL|count_characters > 0}
            <a href="{$oNaviSeite->cURL}">{$oNaviSeite->nSeite}</a>
         {else}
            <a href="#" onclick="return false;">{$oNaviSeite->nSeite}</a>
         {/if}
         </li>
         {/if}
         {/foreach}

         {if $Suchergebnisse->Seitenzahlen->AktuelleSeite < $Suchergebnisse->Seitenzahlen->maxSeite}
         <li>
            .. {lang key="of" section="productOverview"} {$Suchergebnisse->Seitenzahlen->MaxSeiten}
         </li>
         <li class="next">
            <a href="{$oNaviSeite_arr.vor->cURL}">{lang key="next" section="productOverview" alt_section="global,"}</a> &raquo;
         </li>
         {/if}
      </ul>
   </div>
   <div class="right">
      <form action="navi.php" id="goto" method="get">
      <fieldset class="outer">
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
      </fieldset>
      </form>
   </div>
   <div class="clear"></div>
</div>
{/if}
{include file='tpl_inc/inc_seite.tpl'}
</div>
