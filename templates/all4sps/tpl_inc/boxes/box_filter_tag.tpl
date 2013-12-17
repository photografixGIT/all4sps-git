{if $bBoxenFilterNach}
   {if $NaviFilter->TagFilter|@count > 0}
   <div class="sidebox" id="sidebox{$oBox->kBox}">
      <div class="sidebox_content">
      <ul class="filter_state">
         <li class="label">{lang key="tagFilter" section="global"}</li>
         {foreach name=tagfilter from=$NaviFilter->TagFilter item=oTagFilter}
         {assign var=kTag value=$oTagFilter->kTag}
            <li>
               <a rel="nofollow" href="{$NaviFilter->URL->cAlleTags}" class="active">{$oTagFilter->cName}</a>
            </li>             
         {/foreach}
      </ul>
      </div>
   </div>
   {/if}
{/if}