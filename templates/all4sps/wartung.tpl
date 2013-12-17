{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
{include file='tpl_inc/header.tpl'}
   <div id="wrapper">
      <div id="content">
         {include file='tpl_inc/inc_breadcrumb.tpl'}
         <div id="contentmid">
            <div class="content_head">
               <h1>{lang key="maintainance" section="global"}</h1>
            </div>
            
            {include file="tpl_inc/inc_extension.tpl"}
            
            <div class="seite"><br><br>
            {$Einstellungen.global.wartungsmodus_hinweis}
            </div>
         </div>
      </div>
   </div>
{include file='tpl_inc/footer.tpl'}