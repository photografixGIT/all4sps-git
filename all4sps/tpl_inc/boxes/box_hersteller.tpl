{*if $Boxen.Hersteller->anzeigen=="Y"*}
<div class="sidebox" id="sidebox{$oBox->kBox}">
<form id="hst" action="navi.php" method="post">
   <h3 class="boxtitle">{lang key="manufacturers" section="global"}</h3>
   <div class="sidebox_content tcenter">
      <input type="hidden" name="{$session_name}" value="{$session_id}" />
      <select name="h" onchange="$('#hst').submit();">
         <option>{lang key="selectManufacturer" section="global"}</option>
         {foreach name=hersteller from=$smarty.session.Hersteller item=hst}
         <option value="{$hst->kHersteller}">{$hst->cName|escape:"html"|truncate:22:"..."}</option>
         {/foreach}
      </select>
      <p><input type="submit" value="{lang key="view" section="global"}" /></p>
   </div>
</form>
</div>
{*/if*}