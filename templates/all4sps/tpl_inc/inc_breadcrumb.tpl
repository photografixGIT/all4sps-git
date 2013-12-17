{if $Brotnavi|@count > 1}
   <div id="breadcrumb">
      {*lang key="youarehere" section="breadcrumb"*}
      {foreach name=navi from=$Brotnavi item=oItem}<a href="{$oItem->url}" title='{$oItem->name|escape:"quotes"}'>{$oItem->name}</a>{if !$smarty.foreach.navi.last} &raquo; {/if}{/foreach}
   </div>
{/if}
