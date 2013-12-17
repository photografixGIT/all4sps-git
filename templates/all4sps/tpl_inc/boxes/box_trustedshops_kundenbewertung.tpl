{if isset($Boxen.TrustedShopsKundenbewertung) && $Boxen.TrustedShopsKundenbewertung->anzeigen=="Y"}
<div class="sidebox" id="sidebox{$oBox->kBox}">
   <h3 class="boxtitle">{lang key="trustedshopsRating" section="global"}</h3>
   <div class="sidebox_content tcenter">
      <a href="{$Boxen.TrustedShopsKundenbewertung->cBildPfadURL}" target="_blank"><img src="{$Boxen.TrustedShopsKundenbewertung->cBildPfad}" /></a>
   </div>
</div>
{/if}