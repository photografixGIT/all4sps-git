{if isset($Boxen.TrustedShopsSiegelbox) && $Boxen.TrustedShopsSiegelbox->anzeigen=="Y" && $Boxen.TrustedShopsSiegelbox->cLogoURL|strlen > 0}
   <div class="sidebox" id="sidebox{$oBox->kBox}">
      <h3 class="boxtitle">{lang key="safety" section="global"}</h3>
      <div class="sidebox_content">
         <table width="100%" align="center" border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111">
            <tr valign="middle" align="center">
               <td height="70" width="164" align="center">
                  <!-- Trusted Shops Siegel -->
                  <div id="tsBox" style="font-size:80%;">
                  <div style="background-color:#FFFFFF;font-family: Verdana, Arial, Helvetica, sans-serif;background-image: url({$Boxen.TrustedShopsSiegelbox->cBGBild});background-repeat: repeat;background-position: left top;vertical-align:middle;width:150px;margin-top:0px;border:1px solid #C0C0C0;padding:2px;" id="tsInnerBox">
                  <div style="text-align:center;width:150px;float:left; border:0px solid; padding:2px;" id="tsSeal"><a target="_blank" href="{$Boxen.TrustedShopsSiegelbox->cLogoURL}"><img style="border:0px none;" src="{$Boxen.TrustedShopsSiegelbox->cBild}" title="{lang key='ts_seal_classic_title' section='global'}"></a></div>
                  <div style="text-align:center;line-height:125%;width:150px;float:left;border:0px solid; padding:2px;" id="tsText"><a style="font-weight:normal;text-decoration:none;color:#000000;" title="{lang key='ts_info_classic_title' section='global'} {$cShopName}" href="{$Boxen.TrustedShopsSiegelbox->cLogoSiegelBoxURL}" target="_blank">{$cShopName} {lang key="ts_classic_text" section="global"}</a></div>
                  <div style="clear:both;"></div>
                  </div>
                  </div> 
                  <!-- / Trusted Shops Siegel -->
               </td>
            </tr>
         </table>
      </div>
   </div>
{/if}