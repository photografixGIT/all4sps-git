{if isset($Boxen.NewsKategorie->oNewsKategorie_arr) && $Boxen.NewsKategorie->oNewsKategorie_arr|@count > 0}
<div class="sidebox" id="sidebox{$oBox->kBox}">
   <h3 class="boxtitle">{lang key="newsBoxCatOverview" section="global"}</h3>
   <div class="sidebox_content">
      <ul class="categories">
      {foreach name=newskategorie from=$Boxen.NewsKategorie->oNewsKategorie_arr item=oNewsKategorie}
         <li><a href="{$oNewsKategorie->cURL}" title="{$oNewsKategorie->cBeschreibung|escape:"html"}" class="tooltip">{$oNewsKategorie->cName}</a> {*<em class="count">({$oNewsKategorie->nAnzahlNews})</em>*}</li>
      {/foreach}
      </ul>
   </div>
</div>
{/if}