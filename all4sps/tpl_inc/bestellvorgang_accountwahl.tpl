{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}

<form method="post" action="bestellvorgang.php" class="form" id="order_register_or_login">
   {if $hinweis}
   <p class="box_error">{$hinweis}</p>
   {/if}
   
   <fieldset id="order_choose_order_type">
      <legend>{lang key="createNewAccount" section="account data" alt_section="checkout,"}</legend>
      <div id="new_account">
         {if $Einstellungen.kaufabwicklung.bestellvorgang_unregistriert=="Y"}
         <p><a href="bestellvorgang.php?unreg=1&{$SID}" class="submit">{lang key="orderUnregistered" section="checkout"}</a></p>
         <p class="box_plain">{lang key="orderWithoutRegistrationDesc" section="checkout"}</p>
         {/if}
         <p><a href="registrieren.php?checkout=1&{$SID}" class="submit">{lang key="createNewAccount" section="account data" alt_section="checkout,"}</a></p>
         <p class="box_plain">{lang key="createNewAccountDesc" section="checkout"}</p>
      </div>
   </fieldset>

   <fieldset id="order_customer_login">
      <legend>{lang key="loginForRegisteredCustomers" section="checkout"}</legend>
      <ul class="input_block">
         <li>
            <label for="email">{lang key="emailadress" section="global"}<em>*</em>:</label>
            <input type="text" name="userLogin" id="email" />
         </li>
         <li>
            <label for="password">{lang key="password" section="account data" alt_section="global,"}<em>*</em>:</label>
            <input type="password" name="passLogin" id="password" />
         </li>
         <li class="clear">
            <input type="hidden" name="{$session_name}" value="{$session_id}" />
            <input type="hidden" name="login" value="1" />
            <input type="hidden" name="wk" value="1" />
            <input type="submit" class="submit" value="{lang key="login" section="checkout" alt_section="global,"}" />
         </li>
      </ul>
   </fieldset>
</form>