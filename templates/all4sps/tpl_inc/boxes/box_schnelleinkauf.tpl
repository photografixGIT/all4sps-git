{if isset($Boxen.Schnellkauf) && $Boxen.Schnellkauf->anzeigen=="Y"}
<div class="sidebox" id="sidebox{$oBox->kBox}">
<form id="schnellkauf" action="warenkorb.php" method="post">
<fieldset class="outer">
   <h3 class="boxtitle">{lang key="quickBuy" section="global"}</h3>
   <div class="sidebox_content tcenter">
      <input type="hidden" name="schnellkauf" value="1" />
      <input type="hidden" name="{$session_name}" value="{$session_id}" />
      <p><label for="ean">{lang key="productNoEAN" section="global"}</label></p>
      <p><input type="text" class="schnellkaufEAN" name="ean" id="ean" /></p>
      <p><input type="submit" value="{lang key="intoBasket" section="global"}" /></p>
   </div>
</fieldset>
</form>
</div>
{/if}