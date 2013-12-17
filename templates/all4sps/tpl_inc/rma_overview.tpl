{*
-------------------------------------------------------------------------------
    JTL-Shop 3
    File: rma_overview.tpl, smarty template inc file
    
    page for JTL-Shop 3
    
    Author: daniel.boehmer@bb-network.de
-------------------------------------------------------------------------------
*}

{if !isset($oLink)}
   <p class="box_info">{lang key="rma_nolicence" section="rma"}</p>
{elseif !isset($smarty.session.Kunde->kKunde) || $smarty.session.Kunde->kKunde == 0}
   <p class="box_info">{lang key="rma_login" section="rma"}</p>
   <form method="POST" action="jtl">
      <input name="s" type="hidden" value="{$oLink->kLink}" />
      <input name="r" type="hidden" value="19" />
      <input name="submitBTN" type="submit" class="submit" value="Jetzt einloggen" />
   </form>
{else}
<div id="rma_overview">
   {if $cHinweis}<p class="box_info">{$cHinweis}</p>{/if}
   
   <form id="rma_year_submit" method="POST" action="{$oLink->cURLFull}">
      <input name="a" type="hidden" value="changePeriodOfTime" />
      <select id="rma_year_select" name="nRMAYear">
         <option value="1"{if $smarty.session.RMA_TimePeriod->nYear == 1} selected{/if}>{lang key="rma_ordertime" section="rma"} 2 {lang key="rma_month" section="rma"}</option>
         <option value="2"{if $smarty.session.RMA_TimePeriod->nYear == 2} selected{/if}>{lang key="rma_ordertime" section="rma"} 6 {lang key="rma_month" section="rma"}</option>      
   {if $nRMAYear_arr|@count > 0}
      {foreach name=rmayears from=$nRMAYear_arr item=nRMAYear}
         <option value="{$nRMAYear}"{if $smarty.session.RMA_TimePeriod->nYear == $nRMAYear} selected{/if}>Bestellungen {$nRMAYear}</option>
       {/foreach}
   {/if}
      </select>&nbsp;<input name="rma_year_submit_btn" type="submit" class="submit" value="{lang key="rma_go" section="rma"}" />
   </form>
   
   <script>
      $("#rma_year_select").change(function() {ldelim}
         $("#rma_year_submit").submit();                      
      {rdelim});
   </script>
   {/if}
   
   <div class="howto"></div>
   
   {if $oBestellung_arr|@count > 0}
         <h3>{lang key="yourOrders" section="login"}</h3>
          
      <table>
            <tbody>
       {foreach name=bestellungen from=$oBestellung_arr item=oBestellung}       
            <tr>
               <td class="p33 vtop">
                  <strong>{lang key="orderNo" section="login"}:</strong> {$oBestellung->cBestellNr}<br />
                  <strong>{lang key="value" section="login"}:</strong> {$oBestellung->cBestellwertLocalized}<br />
                  <strong>{lang key="orderDate" section="login"}:</strong> {$oBestellung->dBestelldatum}<br />
               </td>
               <td class="p66 vtop">
                  <div style="position: relative;">
                     <div style="position: absolute; top: 0; right: 0;" align="right">
                        <form method="POST" action="{$oLink->cURLFull}">
                      <input name="a" type="hidden" value="chooseProduct" />
                      <input name="kBestellung" type="hidden" value="{$oBestellung->kBestellung}" />                     
                        <input name="rma_choose" class="submit" type="submit" value="{lang key="rma_artikelwahl" section="rma"}" />
                        </form>
                     </div>
                     <br /><strong>Artikel:</strong><br />
                     <table>
                        <tbody>
                        {foreach name=artikel from=$oBestellung->Positionen item=oPosition}
                           <tr>
                              <td>
                                 <ul>
                                    <li style="list-style-type: disc;">
                                       {$oPosition->cAnzahl}x {$oPosition->Artikel->cName}
                                       {if isset($oPosition->bRMA) && $oPosition->bRMA} <em class="rma_sent">*</em>{/if}
                                       {if isset($oPosition->cRMAArtikelQuantity)} <em class="rma_sent">* ({$oPosition->cRMAArtikelQuantity} / {$oPosition->cAnzahl})</em>{/if}                              
                                    </li>
                                 </ul>
                              </td>
                           </tr>
                        {/foreach}
                        </tbody>         
                     </table>
                  </div>
               </td>
            </tr>
      {if !$smarty.foreach.bestellungen.last}
         <tr>
            <td colspan="2"><hr size="-1" noshade="noshade" color="#C9E1F4"></td>
         <tr>
      {/if}
       {/foreach}
            </tbody>
      </table>
      <br />
      <br />
      <p><em>*</em> {lang key="rma_gekennzeichnet" section="rma"}</p>
</div>
{/if}