{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
{include file='tpl_inc/header.tpl'}
   <div id="wrapper">
      <div id="content">
         {include file='tpl_inc/inc_breadcrumb.tpl'}
         <div id="contentmid">
         {if $step=='formular'}
            {if isset($checkout) && $checkout == 1}                        
               <ol id="checkout_steps">
                 <li class="step2 state{$bestellschritt[1]} first">{if $bestellschritt[1]==2}<a href="{if $smarty.session.Kunde->kKunde}jtl.php{else}bestellvorgang.php{/if}?editRechnungsadresse=1&{$SID}">{if #billingAdress#}{lang key="billingAdress" section="account data" alt_section="checkout,"}{else}Rechnungsadresse{/if}</a>{else}{if #billingAdress#}{lang key="billingAdress" section="account data" alt_section="checkout,"}{else}Rechnungsadresse{/if}{/if}</li>
                 <li class="step3 state{$bestellschritt[2]}">{if $bestellschritt[2]==2}<a href="bestellvorgang.php?editLieferadresse=1&{$SID}">{if #shippingAdress#}{lang key="shippingAdress" section="account data" alt_section="checkout,"}{else}Lieferadresse{/if}</a>{else}{if #shippingAdress#}{lang key="shippingAdress" section="account data" alt_section="checkout,"}{else}Lieferadresse{/if}{/if}</li>
                 <li class="step4 state{$bestellschritt[3]}">{if $bestellschritt[3]==2}<a href="bestellvorgang.php?editVersandart=1&{$SID}">{if #shipmentMode#}{lang key="shipmentMode" section="checkout"}{else}Versandart{/if}</a>{else}{if #shipmentMode#}{lang key="shipmentMode" section="checkout"}{else}Versandart{/if}{/if}</li>
                 <li class="step5 state{$bestellschritt[4]}">{if $bestellschritt[4]==2}<a href="bestellvorgang.php?editZahlungsart=1&{$SID}">{if #paymentMethod#}{lang key="paymentMethod" section="checkout"}{else}Zahlungsart{/if}</a>{else}{if #paymentMethod#}{lang key="paymentMethod" section="checkout"}{else}Zahlungsart{/if}{/if}</li>
                 <li class="step6 state{$bestellschritt[5]}">{if #summary#}{lang key="summary" section="checkout"}{else}Zusammenfassung{/if}</li>
                </ol>
            {/if}
            
            {if $smarty.session.Kunde->kKunde > 0}
               <h1>{lang key="changeBillingAddress" section="account data"}</h1>
            {else}
               <h1>{lang key="createNewAccount" section="account data"}</h1>
            {/if}

            {include file='tpl_inc/registrieren_formular.tpl'}
            
         {elseif $step=="formular eingegangen"}
            <h1>{lang key="accountCreated" section="global"}</h1>
            <p>{lang key="activateAccountDesc" section="global"}</p><br>
         {/if}
         </div>
      </div>
   </div>
{include file='tpl_inc/footer.tpl'}