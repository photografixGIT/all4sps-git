{if $bBoxenFilterNach}
   {if $NaviFilter->SuchFilter|@count > 0 && !$NaviFilter->Suche->kSuchanfrage}
   <div class="sidebox" id="sidebox{$oBox->kBox}">
      <div class="sidebox_content">
      <ul class="filter_state">
         <li class="label">{lang key="searchFilter" section="global"}</li>
         {foreach name=suchfilter from=$NaviFilter->SuchFilter item=oSuchFilter}
         {assign var=kSuchanfrage value=$oSuchFilter->kSuchanfrage}
            <li>
               <a rel="nofollow" href="{$NaviFilter->URL->cAlleSuchFilter[$kSuchanfrage]}" class="active">{$oSuchFilter->cSuche}</a>
            </li>             
         {/foreach}
      </ul>
      </div>
   </div>
   {/if}
{/if}