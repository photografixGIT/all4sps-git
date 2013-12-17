{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}

{if $Bestellung->oDownload_arr|@count > 0}
   <h3>{lang key="yourDownloads" section="global"}</h3>   
   <table class="tiny" id="jtl_downloads">
      <thead>
         <tr>
         <th>{lang key="downloadFile" section="global"}</th>
         <th class="tcenter">{lang key="downloadLimit" section="global"}</th>
         <th class="tcenter">{lang key="validUntil" section="global"}</th>
         <th class="tcenter">{lang key="download" section="global"}</th>
         </tr>
      </thead>

      <tbody>
      {foreach name=downloads from=$Bestellung->oDownload_arr item=oDownload}
      <form method="POST" action="jtl.php">
      <input name="a" type="hidden" value="getdl" />
      <input name="bestellung" type="hidden" value="{$Bestellung->kBestellung}" />
         <tr>
            <td class="p40 dl_name" valign="middle">{$oDownload->oDownloadSprache->getName()}</td>
            <td class="tcenter dl_limit" valign="middle">{if isset($oDownload->cLimit)}{$oDownload->cLimit}{else}{lang key="unlimited" section="global"}{/if}</td>
            <td class="tcenter dl_validuntil" valign="middle">{if isset($oDownload->dGueltigBis)}{$oDownload->dGueltigBis}{else}{lang key="unlimited" section="global"}{/if}</td>
            <td class="tcenter dl_download" valign="middle">
               {if $Bestellung->cStatus == $BESTELLUNG_STATUS_BEZAHLT || $Bestellung->cStatus == $BESTELLUNG_STATUS_VERSANDT}
                  <input name="dl" type="hidden" value="{$oDownload->getDownload()}" /><button></button>
               {else}
                  {lang key="downloadPending"}
               {/if}
            </td>
         </tr> 
      </form>
      {/foreach}
      </tbody>
   </table>
   </form>
   
{elseif $oDownload_arr|@count > 0}
   <h3>{lang key="yourDownloads" section="global"}</h3>   
   <table class="tiny" id="jtl_downloads">
      <thead>
         <tr>
         <th>{lang key="downloadFile" section="global"}</th>
         <th class="tcenter">{lang key="downloadLimit" section="global"}</th>
         <th class="tcenter">{lang key="validUntil" section="global"}</th>
         <th class="tcenter">{lang key="download" section="global"}</th>
         </tr>
      </thead>

      <tbody>
      {foreach name=downloads from=$oDownload_arr item=oDownload}
      <form method="POST" action="jtl.php">
      <input name="kBestellung" type="hidden" value="{$oDownload->kBestellung}" />
      <input name="kKunde" type="hidden" value="{$smarty.session.Kunde->kKunde}" />
         <tr>
            <td class="p40 dl_name" valign="middle">{$oDownload->oDownloadSprache->getName()}</td>
            <td class="tcenter dl_limit" valign="middle">{if isset($oDownload->cLimit)}{$oDownload->cLimit}{else}{lang key="unlimited" section="global"}{/if}</td>
            <td class="tcenter dl_validuntil" valign="middle">{if isset($oDownload->dGueltigBis)}{$oDownload->dGueltigBis}{else}{lang key="unlimited" section="global"}{/if}</td>
            <td class="tcenter dl_download" valign="middle">
               {assign var=cStatus value=$BESTELLUNG_STATUS_OFFEN}
               {foreach from=$Bestellungen item=Bestellung}
                  {if $Bestellung->kBestellung == $oDownload->kBestellung}
                     {assign var=cStatus value=$Bestellung->cStatus}                     
                  {/if}
               {/foreach}
               {if $cStatus == $BESTELLUNG_STATUS_BEZAHLT || $cStatus == $BESTELLUNG_STATUS_VERSANDT}
                  <input name="dl" type="hidden" value="{$oDownload->getDownload()}" /><button></button>
               {else}
                  {lang key="downloadPending"}
               {/if}
            </td>
         </tr> 
      </form>
      {/foreach}
      </tbody>
   </table>
   </form>
{/if}