{if isset($Boxen.Umfrage->oUmfrage_arr) && $Boxen.Umfrage->oUmfrage_arr|@count > 0}
<div class="sidebox" id="sidebox{$oBox->kBox}">
   <h3 class="boxtitle">{lang key="BoxPoll" section="global"}</h3>
   <div class="sidebox_content">
      <ul>
      {foreach name=tagwolken from=$Boxen.Umfrage->oUmfrage_arr item=oUmfrage}
         <li><a href="{$oUmfrage->cURL}">{$oUmfrage->cName}</a></li>
      {/foreach}
      </ul>
   </div>
</div>
{/if}