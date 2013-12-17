<script type="text/javascript" src="{$currentTemplateDir}js/jtl.billpay.js"></script>

{if $cMissing_arr|@count > 0}
   <p class="box_error">Bitte füllen Sie alle Pflichtfelder aus.</p>
{/if}

{if $billpay_message}
   <p class="box_{$billpay_message->cType}">{$billpay_message->cCustomerMessage}</p>
{/if}

<div class="container form">
   <fieldset id="billpay_form">
      <legend>Zahlungsart</legend>

      <input type="hidden" name="za_billpay_jtl" value="1" />
      <img src="{$ShopURL}/gfx/Billpay/LogoMid1_0.png" alt="Billpay" title="Billpay" class="logo" />

      <ul class="input_block">
         {if $nPaymentTypes_arr[1] || $nPaymentTypes_arr[4]}
            <li class="clear">
               <label for="billpay_paymenttype1">
                  <input type="radio" name="billpay_paymenttype" id="billpay_paymenttype1" value="1" {if ($cData_arr.billpay_paymenttype == 1 || $cData_arr.billpay_paymenttype == 4) || !isset($cData_arr.billpay_paymenttype)}checked="checked"{/if} /> Kauf auf Rechnung
               </label>
            </li>
         {/if}

         {if $nPaymentTypes_arr[2]}
            <li class="clear">
               <label for="billpay_paymenttype2">
                  <input type="radio" name="billpay_paymenttype" id="billpay_paymenttype2" value="2" {if $cData_arr.billpay_paymenttype == 2}checked="checked"{/if} /> Kauf per Lastschrift
               </label>
            </li>
         {/if}

         {if $nPaymentTypes_arr[3]}
            <li class="clear">
               <label for="billpay_paymenttype3">
                  <input type="radio" name="billpay_paymenttype" id="billpay_paymenttype3" value="3" {if $cData_arr.billpay_paymenttype == 3}checked="checked"{/if} /> Ratenkauf
               </label>
            </li>
         {/if}
      </ul>
      
      <ul class="input_block">
         {if $cAdditionalCustomer_arr|@count > 0}
            <li class="clear p100">
               <fieldset class="container">
                  <legend>Weitere Kundendaten</legend>
                  
                  {if $nPaymentTypes_arr[1] || $nPaymentTypes_arr[4]}
                     <ul class="input_block box_plain clearall" id="invoicebusiness_information">
                        {if $nPaymentTypes_arr[1]}
                           <li class="clear">
                              <label for="billpay_b2b_no">
                                 <input type="radio" name="billpay_b2b" id="billpay_b2b_no" value="0" {if $cData_arr.billpay_b2b == 0}checked="checked"{/if} /> Privatkunde
                              </label>
                           </li>
                        {/if}
               
                        {if $nPaymentTypes_arr[4]}
                           <li class="clear">
                              <label for="billpay_b2b_yes">
                                 <input type="radio" name="billpay_b2b" id="billpay_b2b_yes" value="1" {if $cData_arr.billpay_b2b == 1}checked="checked"{/if} /> Geschäftskunde
                              </label>
                           </li>
                        {/if}
                     </ul>
                  {/if}

                  <ul class="input_block {if $cData_arr.billpay_b2b == 1}hidden{/if}" id="invoicebusiness_b2c">
                     {if $cAdditionalCustomer_arr.cAnrede}
                        <li {if $cMissing_arr.cAnrede>0}class="error_block"{/if}>
                           <label for="salutation">{lang key="salutation" section="account data"}<em>*</em>:</label>
                           <select name="cAnrede" id="salutation">
                              <option value="" selected="selected">{lang key="pleaseChoose" section="global"}</option>
                              <option value="m" {if $cData_arr.cAnrede == "m"}selected="selected"{/if}>{$Anrede_m}</option>
                              <option value="w" {if $cData_arr.cAnrede == "w"}selected="selected"{/if}>{$Anrede_w}</option>
                           </select>
                           {if $cMissing_arr.cAnrede>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
                        </li>
                     {/if}

                     {if $cAdditionalCustomer_arr.dGeburtstag}
                        <li {if $cMissing_arr.dGeburtstag>0}class="error_block"{/if}>
                           <label for="dGeburtstag">{lang key="birthday" section="account data"}<em>*</em>:</label>
                           <input type="text" name="dGeburtstag" value="{$cData_arr.dGeburtstag}" id="dGeburtstag" class="birthday" />
                           {if $cMissing_arr.dGeburtstag>0}
                           <p class="error_text">
                              {if $cMissing_arr.dGeburtstag==1}
                                 {lang key="fillOut" section="global"}
                              {elseif $cMissing_arr.dGeburtstag==2}
                                 {lang key="invalidDateformat" section="global"}
                              {elseif $cMissing_arr.dGeburtstag==3}
                                 {lang key="invalidDate" section="global"}
                              {/if}
                           </p>
                           {/if}
                        </li>

                        <script type="text/javascript">
                        jQuery(document).ready(function(){ldelim}
                           $('input.birthday').simpleDatepicker({ldelim} startdate: '01.01.1900', chosendate: '{$Kunde->dGeburtstag}', x: 0, y: $('input.birthday').outerHeight(){rdelim});
                        {rdelim});
                        </script>
                     {/if}

                     {if $cAdditionalCustomer_arr.cTel}
                        <li {if $cMissing_arr.cTel>0}class="error_block"{/if} id="tel" {*if (($nPaymentTypes_arr[1] || $nPaymentTypes_arr[2]) && $cData_arr.billpay_paymenttype != 3)}style="display:none"{/if*}>
                           <label for="cTel">{lang key="tel" section="account data"}<em>*</em>:</label>
                           <input type="text" name="cTel" value="{$cData_arr.cTel}" id="cTel" />
                           {if $cMissing_arr.cTel>0}
                              <p class="error_text">{lang key="fillOut" section="global"}</p>
                           {/if}
                        </li>
                     {/if}
                  </ul>
                  
                  <ul class="input_block {if $cData_arr.billpay_b2b == 0}hidden{/if}" id="invoicebusiness_b2b">
                     <li class="clear p100">
                  
                        <ul class="input_block">
                           <li {if $cMissing_arr.cAnrede>0}class="error_block"{/if}>
                              <label for="salutation">{lang key="salutation" section="account data"}<em>*</em>:</label>
                              <select name="cAnrede" id="salutation">
                                 <option value="" selected="selected">{lang key="pleaseChoose" section="global"}</option>
                                 <option value="m" {if $cData_arr.cAnrede == "m"}selected="selected"{/if}>{$Anrede_m}</option>
                                 <option value="w" {if $cData_arr.cAnrede == "w"}selected="selected"{/if}>{$Anrede_w}</option>
                              </select>
                              {if $cMissing_arr.cAnrede>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
                           </li>
                           
                           <li {if $cMissing_arr.cInhaber>0}class="error_block"{/if}">
                              <label for="cInhaber">Inhaber:</label>
                              <input type="text" name="cInhaber" value="{$cData_arr.cInhaber}" id="cInhaber" />
                              {if $cMissing_arr.cInhaber>0}
                                 <p class="error_text">{lang key="fillOut" section="global"}</p>
                              {/if}
                           </li>
                           
                        </ul>

                        <ul class="input_block">
                        
                           <li class="clear {if $cMissing_arr.cRechtsform>0}error_block{/if}">
                              <label for="salutation">Rechtsform<em>*</em>:</label>
                              <select name="cRechtsform" id="salutation">
                                 <option value="" selected="selected">{lang key="pleaseChoose" section="global"}</option>
                                 <option value="ag" {if $cData_arr.cRechtsform == "ag"}selected="selected"{/if}>AG</option>
                                 <option value="eg" {if $cData_arr.cRechtsform == "eg"}selected="selected"{/if}>eG (eingetragene Genossenschaft)</option>
                                 <option value="einzel" {if $cData_arr.cRechtsform == "einzel"}selected="selected"{/if}>Einzelfirma</option>
                                 <option value="ek" {if $cData_arr.cRechtsform == "ek"}selected="selected"{/if}>EK (eingetragener Kaufmann)</option>
                                 <option value="e_ges" {if $cData_arr.cRechtsform == "e_ges"}selected="selected"{/if}>Einfache Gesellschaft</option>
                                 <option value="ev" {if $cData_arr.cRechtsform == "ev"}selected="selected"{/if}>e.V. (eingetragener Verein)</option>
                                 <option value="freelancer" {if $cData_arr.cRechtsform == "freelancer"}selected="selected"{/if}>Freiberufler/Kleingewerbetreibender/Handelsvertreter</option>
                                 <option value="gbr" {if $cData_arr.cRechtsform == "gbr"}selected="selected"{/if}>GbR/BGB (Gesellschaft bürgerlichen Rechts)</option>
                                 <option value="gmbh" {if $cData_arr.cRechtsform == "gmbh"}selected="selected"{/if}>GmbH (Gesellschaft mit beschränkter Haftung)</option>
                                 <option value="gmbh_ig" {if $cData_arr.cRechtsform == "gmbh_ig"}selected="selected"{/if}>GmbH in Gründung</option>
                                 <option value="gmbh_co_kg" {if $cData_arr.cRechtsform == "gmbh_co_kg"}selected="selected"{/if}>GmbH &amp; Co. KG</option>
                                 <option value="inv_kk" {if $cData_arr.cRechtsform == "inv_kk"}selected="selected"{/if}>Investmentgesellschaft für kollektive Kapitalanlagen</option>
                                 <option value="kg" {if $cData_arr.cRechtsform == "kg"}selected="selected"{/if}>KG (Kommanditgesellschaft)</option>
                                 <option value="kgaa" {if $cData_arr.cRechtsform == "kgaa"}selected="selected"{/if}>Kommanditgesellschaft auf Aktien</option>
                                 <option value="k_ges" {if $cData_arr.cRechtsform == "k_ges"}selected="selected"{/if}>Kollektivgesellschaft</option>
                                 <option value="ltd" {if $cData_arr.cRechtsform == "ltd"}selected="selected"{/if}>Limited</option>
                                 <option value="ltd_co_kg" {if $cData_arr.cRechtsform == "ltd_co_kg"}selected="selected"{/if}>Limited &amp; Co. KG</option>
                                 <option value="ohg" {if $cData_arr.cRechtsform == "ohg"}selected="selected"{/if}>OHG (offene Handelsgesellschaft)</option>
                                 <option value="public_inst" {if $cData_arr.cRechtsform == "public_inst"}selected="selected"{/if}>Öffentliche Einrichtung</option>
                                 <option value="misc_capital" {if $cData_arr.cRechtsform == "misc_capital"}selected="selected"{/if}>Sonstige Kapitalgesellschaft</option>
                                 <option value="misc" {if $cData_arr.cRechtsform == "misc"}selected="selected"{/if}>Sonstige Personengesellschaft</option>
                                 <option value="foundation" {if $cData_arr.cRechtsform == "foundation"}selected="selected"{/if}>Stiftung</option>
                                 <option value="ug" {if $cData_arr.cRechtsform == "ug"}selected="selected"{/if}>UG (Unternehmensgesellschaft haftungsbeschränkt)</option>
                              </select>
                              {if $cMissing_arr.cRechtsform>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
                           </li>
                           
                        </ul>
                        
                        <ul class="input_block">
                           
                           <li {if $cMissing_arr.cFirma>0}class="error_block"{/if}>
                              <label for="cFirma">Firmenname<em>*</em>:</label>
                              <input type="text" name="cFirma" value="{$cData_arr.cFirma}" id="cFirma" />
                              {if $cMissing_arr.cFirma>0}
                                 <p class="error_text">{lang key="fillOut" section="global"}</p>
                              {/if}
                           </li>
                           
                           <li {if $cMissing_arr.cUSTID>0}class="error_block"{/if}>
                              <label for="cUSTID">USt-IdNr.:</label>
                              <input type="text" name="cUSTID" value="{$cData_arr.cUSTID}" id="cUSTID" />
                              {if $cMissing_arr.cUSTID>0}
                                 <p class="error_text">{lang key="fillOut" section="global"}</p>
                              {/if}
                           </li>
                           
                           <li {if $cMissing_arr.cHrn>0}class="error_block"{/if}>
                              <label for="cHrn">Handelsregisternummer:</label>
                              <input type="text" name="cHrn" value="{$cData_arr.cHrn}" id="cHrn" />
                              {if $cMissing_arr.cHrn>0}
                                 <p class="error_text">{lang key="fillOut" section="global"}</p>
                              {/if}
                           </li>
                           
                        </ul>
                     </li>
                  </ul>
                  
               </fieldset>
            </li>
         {/if}

         {if $nPaymentTypes_arr[2] || $nPaymentTypes_arr[3]}
            <li class="clear p100 {if !($cData_arr.billpay_paymenttype == 2 || $cData_arr.billpay_paymenttype == 3)}hidden{/if}" id="account_information">
               <fieldset>
                  <legend>Kontodaten</legend>
                  <ul class="input_block">
                     <li class="clear {if $cMissing_arr.billpay_accountholder>0}error_block{/if}">
                        <label for="billpay_accountholder">Vor- und Zuname des Kontoinhabers<em>*</em>:</label>
                        <input type="text" name="billpay_accountholder" value="{if $cData_arr.billpay_accountholder|@count_characters == 0}{$Kunde->cVorname} {$Kunde->cNachname}{else}{$cData_arr.billpay_accountholder}{/if}" id="billpay_accountholder" maxlength="100" />
                        {if $cMissing_arr.billpay_accountholder>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
                     </li>

                     <li class="clear {if $cMissing_arr.billpay_accountnumber>0}error_block{/if}">
                        <label for="billpay_accountnumber">Kontonummer<em>*</em>:</label>
                        <input type="text" name="billpay_accountnumber" value="{$cData_arr.billpay_accountnumber}" id="billpay_accountnumber" maxlength="10" />
                        {if $cMissing_arr.billpay_accountnumber>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
                     </li>

                     <li class="clear {if $cMissing_arr.billpay_sortcode>0}error_block{/if}">
                        <label for="billpay_sortcode">Bankleitzahl<em>*</em>:</label>
                        <input type="text" name="billpay_sortcode" value="{$cData_arr.billpay_sortcode}" id="billpay_sortcode" maxlength="8" />
                        {if $cMissing_arr.billpay_sortcode>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
                     </li>
                  </ul>
               </fieldset>
            </li>
         {/if}

         {if $nPaymentTypes_arr[3]}
            <li class="clear p100 {if !($cData_arr.billpay_paymenttype == 3)}hidden{/if}" id="rate_selection">
               <fieldset>
                  <legend>Wählen Sie die Anzahl der Monatsraten</legend>
                  <div id="billpay_rate_wrapper">
                     <p class="billpay_loader">Raten werden kalkuliert</p>
                  </div>
               </fieldset>
            </li>
            {if $cData_arr.billpay_paymenttype == 3}
               <script type="text/javascript">
               jQuery(document).ready(function(){ldelim}
                  $.billpay.req();
               {rdelim});
               </script>
            {/if}
         {/if}
         
         <li class="clear p100 {if $cData_arr.billpay_paymenttype == 3}hidden{/if}" id="billpay_agb_def">
            <fieldset>
               <legend>Weitere Informationen</legend>
               <p>&bull; <a href="{$cBillpayTermsURL}" target="_blank" onclick="return open_window('{$cBillpayTermsURL}');">AGB</a></p>
               <p>&bull; <a href="{$cBillpayTermsURL}#datenschutz" target="_blank" onclick="return open_window('{$cBillpayTermsURL}#datenschutz');">Datenschutzbestimmungen</a></p>
            </fieldset>
         </li>

         <li class="clear {if $cMissing_arr.billpay_accepted}error_block{/if}">
            <label for="billpay_accepted">
               <input type="checkbox" name="billpay_accepted" id="billpay_accepted" /> Mit der &Uuml;bermittlung der f&uuml;r die Abwicklung des Rechnungskaufs und einer Identit&auml;ts
               und Bonit&auml;tspr&uuml;fung <br />erforderlichen Daten an die <a href='https://billpay.de/endkunden' target='blank'> Billpay GmbH</a> bin ich einverstanden. Es gelten die <a href="{$cBillpayTermsURL}#datenschutz" target="_blank" onclick="return open_window('{$cBillpayTermsURL}#datenschutz');">Datenschutzbestimmungen</a> von Billpay.
               {if $cMissing_arr.billpay_accepted}<p class="error_text">Bitte bestätigen</p>{/if}
            </label>
         </li>
      </ul>
   </fieldset>
</div>
