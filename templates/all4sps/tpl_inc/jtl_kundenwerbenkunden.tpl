{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
<div id="content">
   {include file='tpl_inc/inc_breadcrumb.tpl'}
   <h1>{lang key="kwkName" section="login"}</h1>

   {if $cHinweis}
   <p class="box_info">{$cHinweis}</p>
   {/if}
   
   {if $cFehler}
   <p class="box_error">{$cFehler}</p>
   {/if}

   {if !$cHinweis && !$cFehler}
   <p class="box_info">{lang key="kwkNameDesc" section="login"}<p>
   {/if}

   <form id="kwk" action="jtl.php" method="post" class="form">
      <fieldset>
         <ul class="input_block">
            <li>
               <label for="kwkFirstName">{lang key="kwkFirstName" section="login"}<em>*</em>:</label>
               <input type="text" name="cVorname" id="kwkFirstName" />
            </li>
            
            <li>
               <label for="kwkLastName">{lang key="kwkLastName" section="login"}<em>*</em>:</label>
               <input type="text" name="cNachname" id="kwkLastName" />
            </li>
            
            <li class="clear">
               <label for="kwkEmail">{lang key="kwkEmail" section="login"}<em>*</em>:</label>
               <input type="text" name="cEmail" id="kwkEmail" />
            </li>
            
            <li class="clear">
               <input type="hidden" name="KwK" value="1" />
               <input type="hidden" name="kunde_werben" value="1" />
               <input type="hidden" name="{$session_name}" value="{$session_id}" />
               <input type="submit" value="{lang key="kwkSend" section="login"}" class="submit" />
            </li>
         </ul>
      </fieldset>
   </form>
   {include file='tpl_inc/inc_seite.tpl'}
</div>