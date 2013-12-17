<div class="sidebox" id="sidebox{$oBox->kBox}">
   <h3 class="boxtitle">{if !$smarty.session.Kunde->kKunde}{lang key="login" section="global"}{else}{lang key="myAccount" section="global"}{/if}</h3>
   <div class="sidebox_content">
      {if !$smarty.session.Kunde->kKunde}
      <form action="{$ShopURLSSL}/jtl.php" method="post" class="form box_login">
         <fieldset class="outer">
            <input type="hidden" name="login" value="1" />
            <input type="hidden" name="{$session_name}" value="{$session_id}" />
            <input type="text" class="placeholder" name="email" title="{lang key="emailadress"}" />
            <input type="password" class="placeholder" name="passwort" title="{lang key="password"}" />
            <p>&bull; <a href="pass.php?{$SID}">{lang key="forgotPassword" section="global"}</a></p>
            <p>&bull; {lang key="newHere" section="global"} <a href="registrieren.php?{$SID}">{lang key="registerNow" section="global"}</a></p>
            <input type="submit" value="{lang key="login" section="global"}" />
         </fieldset>
      </form>
      {else}
      <p>{lang key="hello" section="global"} {$smarty.session.Kunde->cAnredeLocalized} {$smarty.session.Kunde->cNachname}</p>
      <div class="tinycontainer tleft">
         <p>&bull; <a href="jtl.php?{$SID}">{lang key="myAccount" section="global"}</a></p>
         <p>&bull; <a href="warenkorb.php?{$SID}">{lang key="basket" section="global"}</a></p>
         <p>&bull; <a href="jtl.php?logout=1&{$SID}"><span>{lang key="logOut" section="global"}</span></a></p>
      </div>      
      {/if}
   </div>
</div>