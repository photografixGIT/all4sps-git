{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
<fieldset id="payment_debit">
   
   <legend>{lang key="paymentOptionDebitDesc" section="shipping payment" alt_section="shipping payment,"}</legend>
   <ul class="input_block">
      <li class="clear bankname required{if $fehlendeAngaben.bankname>0} error_block{/if}">
         <label for="inp_bankname">{lang key="bankname" section="shipping payment" alt_section="shipping payment,"}<em>*</em>:</label>
         <input id="inp_bankname" type="text" name="bankname" size="20" maxlength="90" value="{if $ZahlungsInfo->cBankName|count_characters > 0}{$ZahlungsInfo->cBankName}{else}{$oKundenKontodaten->cBankName}{/if}" />
         {if $fehlendeAngaben.bankname>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}  
      </li><!-- /clear -->
      
      <li class="clear blz required{if $fehlendeAngaben.blz>0} error_block{/if}">
         <label for="inp_blz">{lang key="blz" section="shipping payment" alt_section="shipping payment,checkout,checkout,"}<em>*</em>:</label>
         <input id="inp_blz" type="text" name="blz" maxlength="12" size="10" value="{if $ZahlungsInfo->cBLZ|count_characters > 0}{$ZahlungsInfo->cBLZ}{else}{$oKundenKontodaten->cBLZ}{/if}" /> 
         {if $fehlendeAngaben.blz>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
      </li><!-- /clear -->
      
      <li class="clear account_no required{if $fehlendeAngaben.kontonr>0} error_block{/if}">
         <label for="inp_account_no">{lang key="accountNo" section="shipping payment" alt_section="shipping payment,checkout,checkout,"}<em>*</em>:</label>
         <input id="inp_account_no" type="text" name="kontonr" maxlength="32" size="12" value="{if $ZahlungsInfo->cKontoNr|count_characters > 0}{$ZahlungsInfo->cKontoNr}{else}{$oKundenKontodaten->nKonto}{/if}" />
         {if $fehlendeAngaben.kontonr>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
      </li><!-- /clear -->
      
      <li class="clear iban{if $fehlendeAngaben.iban} error_block{/if}">
           <label for="inp_iban">{lang key="iban" section="shipping payment" alt_section="shipping payment,checkout,checkout,"}:</label>
           <input id="inp_iban" type="text" name="iban" maxlength="32" value="{if $ZahlungsInfo->cIBAN|count_characters > 0}{$ZahlungsInfo->cIBAN}{else}{$oKundenKontodaten->cIBAN}{/if}" size="20" />
           {if $fehlendeAngaben.iban>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
       </li><!-- /clear -->
      
      <li class="clear bic{if $fehlendeAngaben.bic>0} error_block{/if}">
         <label for="inp_bic">{lang key="bic" section="shipping payment" alt_section="shipping payment,checkout,checkout,"}:</label>
        <input id="inp_bic" type="text" name="bic" maxlength="32" size="20" value="{if $ZahlungsInfo->cBIC|count_characters > 0}{$ZahlungsInfo->cBIC}{else}{$oKundenKontodaten->cBIC}{/if}" />
         {if $fehlendeAngaben.bic>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
      </li><!-- /clear -->
   
      <li class="clear owner required{if $fehlendeAngaben.inhaber>0} error_block{/if}">
         <label for="inp_owner">{lang key="owner" section="shipping payment" alt_section="shipping payment,"}<em>*</em>:</label>
         <input id="inp_owner" type="text" name="inhaber" maxlength="32" size="32" value="{if $ZahlungsInfo->cInhaber|count_characters > 0}{$ZahlungsInfo->cInhaber}{else}{$oKundenKontodaten->cInhaber}{/if}" />
         {if $fehlendeAngaben.inhaber>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
       </li>
   </ul>
</fieldset>