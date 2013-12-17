{*if $Boxen.Hersteller->anzeigen=="Y"*}
<div class="sidebox" id="sidebox{$oBox->kBox}">
   <h3 class="boxtitle">{lang key="manufacturers" section="global"}</h3>
   <div class="sidebox_content">
      {tHersteller return="meineHersteller"}
     
      <ul class="categories">
         {foreach name=hersteller from=$meineHersteller item=hst}
         <li><a href="{$hst->cSeo}">{$hst->cName}</a></li>
         {/foreach}
      </ul>
   </div>

</div>
{*/if*}