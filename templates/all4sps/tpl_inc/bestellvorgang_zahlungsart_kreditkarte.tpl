{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 {if $fehlendeAngaben}
   <p class="box_error">{lang key="invalidDataWarning" section=""}</p><!-- /warning -->
{else}
   <p class="box_info">{lang key="yourDataDesc" section="account data" alt_section="account data,"}</p><!-- /helptext -->
{/if}

<fieldset id="payment_creditcard">
   <legend>{lang key="paymentOptionCreditcardDesc" section="shipping payment" alt_section="shipping payment,"}</legend>
   <ul class="input_fields">
      <li class="crc_no required clear{if $fehlendeAngaben.kreditkartennr>0} error_block{/if}">
         <label for="inp_creditcardNo">{lang key="creditcardNo" section="shipping payment" alt_section="shipping payment,"}<em>*</em>:</label>
         <input type="text" name="kreditkartennr" id="inp_creditcardNo" maxlength="32" size="32" value="{$ZahlungsInfo->cKartenNr}" />
         {if $fehlendeAngaben.kreditkartennr>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
      </li>
      <li class="crc_valid required clear{if $fehlendeAngaben.gueltigkeit>0} error_block{/if}">
         <label for="inp_validity">{lang key="validity" section="shipping payment" alt_section="shipping payment,"}<em>*</em>:</label>
         <input type="text" name="gueltigkeit" id="inp_validity" maxlength="12"  size="12" value="{$ZahlungsInfo->cGueltigkeit}" />
         {if $fehlendeAngaben.gueltigkeit>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
      </li> 
      <li class="crc_cvv required clear{if $fehlendeAngaben.cvv>0} error_block{/if}">
         <label for="inp_cvv">{lang key="cvv" section="shipping payment" alt_section="shipping payment,"}<em>*</em>:</label>
         <input type="text" name="cvv" id="inp_cvv" maxlength="4" size="4" value="{$ZahlungsInfo->cCVV}" />
         {if $fehlendeAngaben.cvv>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
      </li>
      <li class="crc_type required clear{if $fehlendeAngaben.kartentyp>0} error_block{/if}">
         <label for="inp_creditcardType">{lang key="creditcardType" section="shipping payment" alt_section="shipping payment,"}<em>*</em>:</label>
         <input type="text" name="kartentyp" id="inp_creditcardType" maxlength="45" size="32" value="{$ZahlungsInfo->cKartenTyp}" />
         {if $fehlendeAngaben.kartentyp>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
      </li>
      <li class="crc_owner required clear{if $fehlendeAngaben.inhaber>0} error_block{/if}">
         <label for="inp_owner">{lang key="owner" section="shipping payment" alt_section="shipping payment,"}<em>*</em>:</label>
         <input type="text" name="inhaber" id="inp_owner" maxlength="80" size="32" value="{$ZahlungsInfo->cInhaber}" />
         {if $fehlendeAngaben.gueltigkeit>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}  
      </li>
   </ul>{*<!-- /input_fields -->*}
</fieldset>