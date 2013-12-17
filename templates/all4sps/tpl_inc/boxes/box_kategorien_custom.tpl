{assign var="nID" value=$oBox->kCustomID}
{if $subcat_tree or $Einstellungen.template.categories.sidebox_categories_use_subcat_navi == 'N'}
<div class="sidebox catbox" id="sidebox_categories{$nID}">
   <h3 class="boxtitle">{if $Einstellungen.template.categories.sidebox_categories_use_subcat_navi == 'Y' and $Brotnavi[1]->name|count_characters > 0}{$Brotnavi[1]->name}{else}{lang key="categories" section="global"}{/if}</h3>
   <div class="sidebox_content">
      <ul class="categories">
         {if $Einstellungen.template.categories.sidebox_categories_use_subcat_navi == 'Y' or $Einstellungen.template.categories.sidebox_categories_use_subcat_navi == 'U'}
            {$subcat_tree}
         {else}
            {$full_category_tree}
         {/if}
      </ul>
   </div>
</div>
{/if}

{* ORIGINAL *}
{*assign var="nID" value=$oBox->kCustomID}
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
{/if*}
