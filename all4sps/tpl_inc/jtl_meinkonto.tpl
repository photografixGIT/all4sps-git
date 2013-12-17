{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
<div id="content">
   {include file='tpl_inc/inc_breadcrumb.tpl'}
   <h1>{lang key="welcome" section="login"} {$Kunde->cAnredeLocalized} {$smarty.session.Kunde->cNachname}</h1>
   
   {if isset($smarty.get.reg)}
      <p class="box_success">{lang key="accountCreated" section="global"}</p>
   {elseif !isset($hinweis)}
      <p class="box_info">{lang key="myAccountDesc" section="login"}</p>
   {/if}
   
   {if $hinweis}
      <div class="box_info">{$hinweis}</div>
   {/if}
   {if $cFehler}
      <div class="box_error">{$cFehler}</div>
   {/if}
   
   {include file="tpl_inc/inc_extension.tpl"}
   
   <div class="settings">
      <ul class="hlist">
         <li class="p50">
            <h3 class="nospacing">{lang key="billingAdress" section="account data"}</h3>
            <p>{include file='tpl_inc/inc_rechnungsadresse.tpl'}</p>
            
            <h3>{lang key="settings" section="global"}</h3>
             
            <p><a href="jtl.php?editRechnungsadresse=1&{$SID}"><span>{lang key="modifyBillingAdress" section="global"}</span></a></p>
            <p><a href="jtl.php?pass=1&{$SID}"><span>{lang key="changePassword" section="login"}</span></a></p>
            {if $Einstellungen.kundenwerbenkunden.kwk_nutzen == "Y"}
            <p><a href="jtl.php?KwK=1&{$SID}"><span>{lang key="kwkName" section="login"}</span></a></p>
            {/if}
            <p><a href="jtl.php?del=1&{$SID}"><span>{lang key="deleteAccount" section="login"}</span></a></p>
            <p><a href="jtl.php?logout=1&{$SID}"><span>{lang key="logOut" section="global"}</span></a></p>
         {if $bRMA}
            <p><a href="rma.php"><span>{lang key="rma" section="global"}</span></a></p>
       {/if}
         </li>
         <li class="p50">
            {if count($Lieferadressen)>0}
            <b>{lang key="shippingAdresses" section="login"}</b>
            {foreach name=lieferadresse from=$Lieferadressen item=adresse}
            <p>{if $adresse->cFirma}{$adresse->cFirma},{/if} {$adresse->cVorname} {$adresse->cNachname}, {$adresse->cStrasse} {$adresse->cHausnummer}, {$adresse->cPLZ} {$adresse->cOrt}, {$adresse->angezeigtesLand}</p>
            {/foreach}
            <br />
            {/if}
            <h3 class="nospacing">{lang key="moneyOnAccount" section="login"}</h3>
            <p>{lang key="yourMoneyOnAccount" section="login"}: {$Kunde->cGuthabenLocalized}</p>         
         </li>
      </ul>
   </div>
   
   {if $Einstellungen.global.global_wunschliste_anzeigen == "Y"}
      {if $oWunschliste_arr[0]->kWunschliste > 0}
         <div id="wishlist">
            <h3>{lang key="yourWishlist" section="login"}</h3>
            <table class="tiny">
               <thead>
                  <tr>
                     <th>{lang key="wishlistName" section="login"}</th>
                     <th>{lang key="wishlistPublic" section="login"}</th>
                     <th class="tcenter">{lang key="wishlistStandard" section="login"}</th>
                     <th></th>
                  </tr>
               </thead>
               <tbody>
               {foreach name=wunschlisten from=$oWunschliste_arr item=Wunschliste}
               <tr>
                  <td><a href="jtl.php?wl={$Wunschliste->kWunschliste}&{$SID}">{$Wunschliste->cName}</a></td>
                  <td>{if $Wunschliste->nOeffentlich == 1}<a href="jtl.php?wl={$Wunschliste->kWunschliste}&{$SID}" title="{lang key="wishlistPrivat" section="login"}">{lang key="wishlistPrivat" section="login"}</a>{/if}{if $Wunschliste->nOeffentlich == 0}<a href="jtl.php?wl={$Wunschliste->kWunschliste}&{$SID}" title="{lang key="wishlistNotPrivat" section="login"}">{lang key="wishlistNotPrivat" section="login"}</a>{/if}</td>
                  <td class="tcenter">{if $Wunschliste->nStandard == 1}{lang key="active" section="global"}{/if} {if $Wunschliste->nStandard == 0}{lang key="inactive" section="global"}{/if}</td>
                  <td class="tcenter">{if $Wunschliste->nStandard != 1}<a href="jtl.php?wls={$Wunschliste->kWunschliste}&{$SID}">{lang key="wishlistStandard" section="login"}</a>{/if} <a href="jtl.php?wllo={$Wunschliste->kWunschliste}&{$SID}">{lang key="wishlisteDelete" section="login"}</a></td>
               </tr>
               {/foreach}
               </tbody>
            </table>
         </div>
      {/if}
      {if $bRMA && isset($oRMA_arr) && $oRMA_arr|@count > 0}
            {include file="tpl_inc/jtl_rma.tpl"}
      {/if}
      <div class="container">
         <form method="post" action="jtl.php" class="form">
            <fieldset>
               <legend>{lang key="wishlistAddNew" section="login"}</legend>
               <input name="wlh" type="hidden" value="1" />
               <input type="hidden" name="{$session_name}" value="{$session_id}" />
               <input name="cWunschlisteName" type="text"> <input type="submit" name="submit" value="{lang key="wishlistSaveNew" section="login"}" />
            </fieldset>
         </form>
      </div>
   {/if}
      
   {include file="tpl_inc/jtl_downloads.tpl"}
   {include file="tpl_inc/jtl_uploads.tpl"}

   {if $Bestellungen|@count > 0}
   <h3>{lang key="yourOrders" section="login"}</h3>
   
   {assign var=bDownloads value=false}
   {foreach name=bestellungen from=$Bestellungen item=Bestellung}
      {if isset($Bestellung->bDownload) && $Bestellung->bDownload > 0}
         {assign var=bDownloads value=true}
      {/if}
   {/foreach}
   
   <table class="tiny">
      <thead>
         <tr>
            <th>{lang key="orderNo" section="login"}</th>
            <th>{lang key="value" section="login"}</th>
            <th class="tcenter">{lang key="orderDate" section="login"}</th>
            <th class="tcenter">{lang key="orderStatus" section="login"}</th>
            {if $bDownloads}
               <th class="tcenter">{lang key="downloads" section="global"}</th>
            {/if}
            <th>&nbsp;</th>
         </tr>
      </thead>
      <tbody>
         {foreach name=bestellungen from=$Bestellungen item=Bestellung}
         <tr>
            <td>{$Bestellung->cBestellNr}</td>
            <td>{$Bestellung->cBestellwertLocalized}</td>
            <td class="tcenter">{$Bestellung->dBestelldatum}</td>
            <td class="tcenter">{$Bestellung->Status}</td>
            {if $bDownloads}
               <td class="tcenter">{if isset($Bestellung->bDownload) && $Bestellung->bDownload > 0}<div class="dl_active"></div>{/if}</td>
            {/if}
            <td class="tcenter"><a href="jtl.php?bestellung={$Bestellung->kBestellung}&{$SID}">{lang key="showOrder" section="login"}</a></td>
         </tr>
         {/foreach}
      </tbody>
   </table>
   {/if}
   {include file='tpl_inc/inc_seite.tpl'}
</div>

{if isset($nWarenkorb2PersMerge) && $nWarenkorb2PersMerge == 1}
<script type="text/javascript">
    var cAnwort = confirm('{lang key="basket2PersMerge" section="login"}');
    if(cAnwort)
        window.location = "jtl.php?basket2Pers=1";
</script>
{/if}