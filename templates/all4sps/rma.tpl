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
      <h1>{lang key="rma" section="rma"}</h1>
      
      {include file="tpl_inc/inc_extension.tpl"}
      
      {if $cStep == "rma_overview"}
          {include file='tpl_inc/rma_overview.tpl'}
      {elseif $cStep == "rma_choose"}
          {include file='tpl_inc/rma_choose.tpl'}
      {elseif $cStep == "rma_success"}
          {include file='tpl_inc/rma_success.tpl'}
      {/if}
   
      {include file='tpl_inc/inc_seite.tpl'}
   </div>
</div>

{include file='tpl_inc/footer.tpl'}