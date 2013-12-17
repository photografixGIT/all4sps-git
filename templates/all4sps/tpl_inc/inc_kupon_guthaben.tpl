{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}

{if $cKuponfehler_arr}
    {if $cKuponfehler_arr.ungueltig == 1}<p class="box_error">{lang key="couponErr1" section="global"}</p>{/if}
    {if $cKuponfehler_arr.ungueltig == 2}<p class="box_error">{lang key="couponErr2" section="global"}</p>{/if}
    {if $cKuponfehler_arr.ungueltig == 3}<p class="box_error">{lang key="couponErr3" section="global"}</p>{/if}
    {if $cKuponfehler_arr.ungueltig == 4}<p class="box_error">{lang key="couponErr4" section="global"}</p>{/if}
    {if $cKuponfehler_arr.ungueltig == 6}<p class="box_error">{lang key="couponErr6" section="global"}</p>{/if}
    {if $cKuponfehler_arr.ungueltig == 11}<p class="box_error">{lang key="invalidCouponCode" section="checkout"}</p>{/if}

    {if $cKuponfehler_arr.ungueltig != 1 && $cKuponfehler_arr.ungueltig != 2 && $cKuponfehler_arr.ungueltig != 3 && $cKuponfehler_arr.ungueltig != 4 && $cKuponfehler_arr.ungueltig != 6 && $cKuponfehler_arr.ungueltig != 11}
        <p class="box_error">{lang key="couponErr99" section="global"}</p>
    {/if}
{/if}

{if $KuponMoeglich==1 || ($Kunde->fGuthaben>0 && !$smarty.session.Bestellung->GuthabenNutzen)}
   <div class="container form">
   {if $KuponMoeglich==1}
      <form method="post" action="bestellvorgang.php">
         <fieldset>
            <legend>{lang key="coupon" section="account data"}</legend>
            <p class="box_info">{lang key="couponDesc" section="account data"}</p>
            <ul class="input_block">
               <li><label for="kupon">{lang key="couponCode" section="account data"}</label>
                  <input type="text" name="Kuponcode" value="{$Kuponcode}" id="kupon" />
               </li>
               <li class="clear">
                  <input type="hidden" name="{$session_name}" value="{$session_id}" />
                  <input type="hidden" name="pruefekupon" value="1" />
                  <input type="submit" value="{lang key="useCoupon" section="checkout"}" class="submit" />
               </li>
            </ul>
         </fieldset>
      </form>
   {/if}
   {if $Kunde->fGuthaben>0 && !$smarty.session.Bestellung->GuthabenNutzen}
      <form method="post" action="bestellvorgang.php">
         <fieldset>
            <legend>{lang key="credit" section="account data"}</legend>
            <p class="box_info">{lang key="creditDesc" section="account data"}</p>
            <p class="box_plain">{lang key="yourCreditIs" section="account data"}: {$GuthabenLocalized}</p>

            <ul class="input_block">
               <li class="clear">
                  <input type="hidden" name="{$session_name}" value="{$session_id}" />
                  <input type="hidden" name="guthabenVerrechnen" value="1" />
                  <input type="hidden" name="guthaben" value="1" />
                  <input type="submit" value="{lang key="useCredits" section="checkout"}" class="submit" />
               </li>
            </ul>
         </fieldset>
      </form>
   {/if}
   </div>
{/if}
