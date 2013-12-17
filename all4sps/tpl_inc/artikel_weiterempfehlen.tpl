{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
<form action="index.php" method="post" class="form tleft">
<fieldset class="outer">
<input name="{$session_name}" type="hidden" value="{$session_id}" />
<input name="artikel_weiterempfehlen" type="hidden" value="1" />

<div id="wrapper">
    <div id="content">
        <div id="contentmid">
        
            <div class="content_head">
                    <h1>{lang key="recommendProduct" section="productDetails"}</h1>
            </div>

            <div id="sectionheader">
                   {lang key="loginDesc" section="login"}<br>
                   {lang key="redirectDesc1" section="global"} {$oRedirect->cName} {lang key="redirectDesc2" section="global"}.
            </div>

            <br>
            
            <input type="hidden" name="login" value="1" />
            <input type="hidden" name="{$session_name}" value="{$session_id}" />
            {if $oRedirect->cURL|count_characters > 0}
            {foreach name=parameter from=$oRedirect->oParameter_arr item=oParameter}
               <input type="hidden" name="{$oParameter->Name}" value="{$oParameter->Wert}" />
            {/foreach}
               <input type="hidden" name="r" value="{$oRedirect->nRedirect}" />
               <input type="hidden" name="cURL" value="{$oRedirect->cURL}" />
            {/if}

            <p class="warning">{$hinweis}</p>
            <table width="90%" cellpadding="3" cellspacing="3" border="0">
                    <tr>
                            <td>{lang key="emailadress" section="global"}:</td>
                            <td><input type="text" class="login" name="email" /></td>
                    </tr>
                    <tr>
                            <td>{lang key="password" section="account data" alt_section="global,"}:</td>
                            <td><input type="password" class="login" name="passwort" /></td>
                    </tr>
                    <tr>
                            <td></td>
                            <td><input type="submit" value="{lang key="login" section="checkout" alt_section="global,"}" class="button" />
                            &nbsp; <a href="pass.php?{$SID}" class="linkklein">{lang key="forgotPassword" section="global"}</a></td>
                    </tr>
            </table>
                
        </div>
    </div>
</div>
</fieldset>
</form>