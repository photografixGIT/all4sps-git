{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
{if $Einstellungen.global.global_wunschliste_freunde_aktiv == "Y"}
<div id="content">
   <h1>{$CWunschliste->cName}</h1>

   {if $hinweis}
   <p class="box_info">{$hinweis}</p>
   {/if}
   
   <form method="post" action="jtl.php" name="Wunschliste">
      <input type="hidden" name="wlvm" value="1" />
      <input type="hidden" name="wl" value="{$CWunschliste->kWunschliste}" />
      <input type="hidden" name="send" value="1" />
      <input type="hidden" name="{$session_name}" value="{$session_id}" />
      <table>
      <tr>
      <th>{lang key="wishlistEmails" section="login"}{if $Einstellungen.global.global_wunschliste_max_email > 0} | {lang key="wishlistEmailCount" section="login"}: {$Einstellungen.global.global_wunschliste_max_email}{/if}</th>
      </tr>
      <tr>
      <td valign="top"><textarea name="email" rows="5" style="width:100%"></textarea></td>
      </tr>
      <tr>
      <td valign="top"><input name="abschicken" type="submit" value="{lang key="wishlistSend" section="login"}"></td>
      </tr>
      </table>
   </form>
</div>
{/if}