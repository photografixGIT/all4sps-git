{if $smarty.session.Warenkorb->PositionenArr|@count > 0}
   <div class="articles">
      <table class="articles">
         <tbody>
         {if isset($WarenkorbVersandkostenfreiHinweis) && $WarenkorbVersandkostenfreiHinweis|@strlen > 0}
         <tr>
            <td colspan="4">
               <p class="box_info">
                  <span title="{$WarenkorbVersandkostenfreiLaenderHinweis}" class="basket_notice">{$WarenkorbVersandkostenfreiHinweis}</span>
               </p>
            </td>
         </tr>
         {/if}
               
         {foreach from=$smarty.session.Warenkorb->PositionenArr item=oPosition}
            {if $oPosition->nPosTyp == 1 && !$oPosition->istKonfigKind()}
               <tr>
                  <td class="img vmiddle"><a href="{$oPosition->Artikel->cURL}"><img src="{$oPosition->Artikel->Bilder[0]->cPfadMini}" class="image vmiddle" alt="" /></a></td>
                  <td class="nowrap">{$oPosition->nAnzahl|replace_delim}{if $oPosition->cEinheit|strlen > 0} {$oPosition->cEinheit}{else}x{/if}</td>
                  <td><a href="{$oPosition->Artikel->cURL}" title="{$oPosition->Artikel->cName}">{$oPosition->Artikel->cName}</a></td>
                  <td class="nowrap tright">
                     {if $oPosition->istKonfigVater()}
                        {$oPosition->cKonfigpreisLocalized[$NettoPreise][$smarty.session.cWaehrungName]}
                     {else}
                        {$oPosition->cEinzelpreisLocalized[$NettoPreise][$smarty.session.cWaehrungName]}
                     {/if}
                  </td>
               </tr>
            {/if}
         {/foreach}
         {if $NettoPreise}
            <tr class="bottom">
               <td colspan="2"></td>
               <td>{lang key="totalSum"}:</td>            
               <td class="nowrap tright"><strong>{$WarenkorbWarensumme[$NettoPreise]}</strong></td>
            </tr>
            {if $Einstellungen.global.global_steuerpos_anzeigen != "N" && $Steuerpositionen|@count > 0}
               {foreach name=steuerpositionen from=$Steuerpositionen item=Steuerposition}
               <tr class="bottom">
                   <td colspan="2"></td>
                   <td>{$Steuerposition->cName}</td>            
                   <td class="nowrap tright">{$Steuerposition->cPreisLocalized}</td>
               </tr>
               {/foreach}
            {/if}
         {/if}
         <tr class="bottom">
            <td colspan="2"></td>
            <td><strong>{lang key="totalSum"} {lang key="gross" section="global"}:</strong></td>
            <td class="nowrap tright"><strong>{$WarenkorbWarensumme[0]}</strong></td>
         </tr>
         <tr class="bottom">
            <td colspan="2"></td>
            <td colspan="2"><button type="button" onclick="location.href='warenkorb.php?{$SID}'">{lang key="gotoBasket"}</button> <button type="button" onclick="location.href='bestellvorgang.php?{$SID}'">{lang key="checkout" section="basketpreview"}</button></td>
         </tr>
         </tbody>
      </table>
   </div>
{/if}