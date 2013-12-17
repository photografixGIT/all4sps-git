{assign var="nID" value=$oBox->kCustomID}
{if isset($cKategorielistenHTML_arr[$nID])}
<div class="sidebox" id="sidebox_categories{$nID}">
   <h3 class="boxtitle">{if $oBox->cTitel|count_characters > 0}{$oBox->cTitel}{else}{lang key="categories" section="global"}{/if}</h3>
   <div class="sidebox_content">
      <ul class="categories">
         {if $Einstellungen.template.categories.sidebox_categories_full_category_tree == "Y" && $nID == 0}
            {$full_category_tree}
         {else}
            {$cKategorielistenHTML_arr[$nID]}
         {/if}
      </ul>
   </div>
</div>
{/if}
