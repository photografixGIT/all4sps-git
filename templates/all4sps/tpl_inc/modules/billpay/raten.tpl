<div id="billpay_wrapper">
   <div id="billpay_rate_selection">
      <select name="billpay_rate">
         {foreach from=$nRate_arr item="nRate"}
            <option value="{$nRate}" {if $oRate->nRate == $nRate}selected="selected"{/if}>{$nRate} Raten</option>
         {/foreach}
      </select>
      <input type="hidden" name="billpay_rate_total" value="{$oRate->fBase}" />
      <button type="button" id="billpay_calc_rate" onclick="javascript:$.billpay.push();">Raten berechnen</button>

      <ul id="billpay_links">
         <li>&bull; <a href="{$cBillpayTermsURL}" target="_blank" onclick="return open_window('{$cBillpayTermsURL}');">AGB Ratenkauf</a></li>
         <li>&bull; <a href="{$cBillpayPrivacyURL}" target="_blank" onclick="return open_window('{$cBillpayPrivacyURL}');">Datenschutzbestimmungen</a></li>
         <li>&bull; <a href="{$cBillpayTermsPaymentURL}" target="_blank" onclick="return open_window('{$cBillpayTermsPaymentURL}');">Zahlungsbedingungen</a></li>
      </ul>

   </div>

   <div id="billpay_rate_info">
      <h2>Ihre Teilzahlung in {$oRate->nRate} Monatsraten</h2>
      <table class="rates">
         <tbody>
            <tr>
               <td>Warenkorbwert</td>
               <td>=</td>
               <td class="tright">{$oRate->fBaseFmt}</td>
            </tr>

            <tr>
               <td>Zinsaufschlag</td>
               <td>+</td>
               <td></td>
            </tr>

            <tr>
               <td>({$oRate->fBaseFmt} x {$oRate->fInterest} x {$oRate->nRate}) / 100</td>
               <td>=</td>
               <td class="tright">{$oRate->fSurchargeFmt}</td>
            </tr>

            <tr>
               <td>Bearbeitungsgebühr</td>
               <td>+</td>
               <td class="tright">{$oRate->fFeeFmt}</td>
            </tr>

            <tr>
               <td>weitere Gebühren (z.B. Versandgebühr)</td>
               <td>+</td>
               <td class="tright">{$oRate->fOtherSurchargeFmt}</td>
            </tr>

            <tr class="special">
               <td>Gesamtsumme</td>
               <td>=</td>
               <td class="tright">{$oRate->fTotalFmt}</td>
            </tr>

            <tr>
               <td>Geteilt durch die Anzahl der Raten</td>
               <td></td>
               <td class="tright">{$oRate->nRate} Raten</td>
            </tr>

            <tr>
               <td>Die erste Rate inkl. Gebühren beträgt</td>
               <td></td>
               <td class="tright">{$oRate->oDues_arr[0]->fAmountFmt}</td>
            </tr>

            <tr>
               <td>Jede folgende Rate beträgt</td>
               <td></td>
               <td class="tright">{$oRate->oDues_arr[1]->fAmountFmt}</td>
            </tr>

            <tr class="special">
               <td>Effektiver Jahreszins</td>
               <td>=</td>
               <td class="tright">{$oRate->fAnual|replace:'.':','} %</td>
            </tr>

         </tbody>
      </table>
   </div>
</div>
