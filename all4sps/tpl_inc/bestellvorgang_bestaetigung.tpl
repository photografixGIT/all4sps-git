{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}

{if $hinweis}
<p class="box_error">{$hinweis}</p>
{/if}

{if $smarty.get.fillOut > 0}
<p class="box_error">{lang key="fillOutQuestion" section="messages"}</p>
{/if}

{if $smarty.session.Zahlungsart->cModulId != 'za_billpay_jtl'}
   {include file='tpl_inc/inc_kupon_guthaben.tpl'}
{/if}

<form method="post" name="agbform" id="complete_order" action="bestellabschluss.php">

   <div class="container form">
      <ul class="hlist">
         <li class="p50">
            <fieldset style="margin: 0 5px 0 0">
               <legend>{lang key="billingAdress" section="account data" alt_section="checkout,"}</legend>
               <p class="box_plain">{include file='tpl_inc/inc_rechnungsadresse.tpl'}</p>
               <p><a href="bestellvorgang.php?editRechnungsadresse=1" class="button_edit">{lang key="modifyBillingAdress" section="global"}</a></p>
            </fieldset>
         </li>
   
         <li class="p50">
            <fieldset style="margin: 0 0 0 5px">
               <legend>{lang key="shippingAdress" section="account data" alt_section="checkout,"}</legend>
               <p class="box_plain">{include file='tpl_inc/inc_lieferadresse.tpl'}</p>
               <p><a href="bestellvorgang.php?editLieferadresse=1" class="button_edit">{lang key="modifyShippingAdress" section="checkout"}</a></p>
            </fieldset>
         </li>
      </ul>
   </div>
   
   <div class="container form">
      <ul class="hlist">
         <li class="p50">
            <fieldset style="margin: 0 5px 0 0">
               <legend>{lang key="shippingOptions" section="global"}</legend>
               <p class="box_plain">{$smarty.session.Versandart->angezeigterName[$smarty.session.cISOSprache]}</p>
               <p><a href="bestellvorgang.php?editVersandart=1" class="button_edit">{lang key="modifyShippingOption" section="checkout"}</a></p>
            </fieldset>
         </li>
         <li class="p50">
            <fieldset>
               <legend>{lang key="paymentOptions" section="global"}</legend>
               <p class="box_plain">{$smarty.session.Zahlungsart->angezeigterName[$smarty.session.cISOSprache]}</p>
               <p><a href="bestellvorgang.php?editZahlungsart=1" class="button_edit">{lang key="modifyPaymentOption" section="checkout"}</a></p>
            </fieldset>
         </li>
      </ul>
   </div>
   
   <div class="container form">
      <fieldset>
         <ul class="input_block">
               <li class="p100">{*<label for="comment">{lang key="comment" section="product rating" alt_section="shipping payment,productDetails,"}</label>*}
                  {lang assign="orderCommentsTitle" key="orderComments" section="shipping payment"}
                  <textarea class="expander placeholder p98" title="{$orderCommentsTitle|escape:"html"}" name="kommentar" cols="50" rows="3" id="comment">{$smarty.session.kommentar}</textarea>
               </li>
         </ul>
      </fieldset>
      
      <fieldset>
        {if isset($safetypay_form)}
           <p class="box_plain">{$safetypay_form}</p>
        {/if}
         <ul class="hlist">
            <input type="hidden" name="{$session_name}" value="{$session_id}" />
            <input type="hidden" name="abschluss" value="1" />
            {if $Einstellungen.kaufabwicklung.bestellvorgang_wrb_anzeigen==1}
               <li class="p100 clear">
                  {if isset($AGB->kLinkWRB) && $AGB->kLinkWRB > 0}
                     <p class="box_plain"><a href="navi.php?s={$AGB->kLinkWRB}" target="_blank">{lang key="wrb" section="checkout"}</a></p>
                  {else}
                     {if $AGB->cWRBContentHtml}
                        <div id="popupwrb" class="hidden tleft"><h1>{lang key="wrb" section="checkout"}</h1>{$AGB->cWRBContentHtml}</div>
                        <p class="box_plain"><a href="#" class="popup" id="wrb">{lang key="wrb" section="checkout"}</a></p>
                     {elseif $AGB->cWRBContentText}
                        <div id="popupwrb" class="hidden tleft"><h1>{lang key="wrb" section="checkout"}</h1>{$AGB->cWRBContentText|nl2br}</div>
                        <p class="box_plain"><a href="#" class="popup" id="wrb">{lang key="wrb" section="checkout"}</a></p>
                     {/if}
                  {/if}
               </li>
            {/if}
            <li class="p100 clear">
               {*<p class="box_info">{lang key="confirmDataDesc" section="shipping payment"}</p>*}
               {getCheckBoxForLocation nAnzeigeOrt=$nAnzeigeOrt cPlausi_arr=$smarty.session.cPlausi_arr cPost_arr=$cPost_arr}
            </li>
         </ul>
      </fieldset>
      
      {include file="tpl_inc/bestellvorgang_positionen.tpl"}
      <div class="tright">
         <input type="submit" value="{lang key="orderLiableToPay" section="checkout"}" class="submit submit_once" />
      </div>
   </div>
</form>