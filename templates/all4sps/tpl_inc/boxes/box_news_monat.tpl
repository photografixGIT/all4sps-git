{if isset($Boxen.News->oNewsMonatsUebersicht_arr) && $Boxen.News->oNewsMonatsUebersicht_arr|@count > 0}
<div class="sidebox" id="sidebox{$oBox->kBox}">
   <h3 class="boxtitle">{lang key="newsBoxMonthOverview" section="global"}</h3>
   <div class="sidebox_content">
      <ul>
      {foreach name=news from=$Boxen.News->oNewsMonatsUebersicht_arr item=oNewsMonatsUebersicht}
         <li><a href="{$oNewsMonatsUebersicht->cURL}">{$oNewsMonatsUebersicht->cName}</a> <em class="count">({$oNewsMonatsUebersicht->nAnzahl})</em></li>
      {/foreach}
      </ul>
   </div>
</div>
{/if}