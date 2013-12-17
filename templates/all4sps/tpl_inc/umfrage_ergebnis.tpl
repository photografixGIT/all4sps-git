{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
<div id="wrapper">
   <div id="content">
      {include file='tpl_inc/inc_breadcrumb.tpl'}
      <div id="contentmid">
         <div class="content_head">
            <h1>{lang key="umfrage" section="umfrage"}</h1>
         </div>
         
         {if $hinweis}
            <br>
            <div class="successTip">
               {$hinweis}
            </div>
         {/if}
         {if $fehler}
            <br>
            <div class="errorTip">
               {$fehler}
            </div>
         {/if}
         <br>
         
      </div>
   </div>
</div>