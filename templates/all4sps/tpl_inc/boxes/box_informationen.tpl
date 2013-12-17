{if isset($smarty.session.Linkgruppen->Informationen)}
<div class="sidebox" id="sidebox{$oBox->kBox}">
   <h3 class="boxtitle">{$smarty.session.Linkgruppen->Informationen->cLocalizedName[$smarty.session.cISOSprache]}</h3>
   <div class="sidebox_content">
      <ul class="categories">
         {foreach name=Informationen from=$smarty.session.Linkgruppen->Informationen->Links item=Link}
         <li><a href="{$Link->URL}"><span>{$Link->cLocalizedName[$smarty.session.cISOSprache]}</span></a></li>
         {/foreach}
      </ul>
   </div>
</div>
{/if}