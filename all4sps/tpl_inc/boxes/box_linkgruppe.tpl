{if isset($oBox->oLinkGruppe)}
<div class="sidebox" id="sidebox{$oBox->kBox}">
   <h3 class="boxtitle">{$oBox->oLinkGruppe->cLocalizedName[$smarty.session.cISOSprache]}</h3>
   <div class="sidebox_content">
      {get_navigation type=$oBox->oLinkGruppeTemplate class="categories"}
   </div>
</div>
{/if}