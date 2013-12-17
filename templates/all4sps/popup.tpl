{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}

{assign var=bExclusive value=true}
{include file='tpl_inc/header.tpl'}

<script type="text/javascript">
{literal}
$(document).ready(function() {
   var h = $('#popup_wrapper').outerHeight();
   window.resizeBy(0, h - $(window).height());

   $('img').load(function() {
      var h = $('#popup_wrapper').outerHeight();
      window.resizeBy(0, h - $(window).height());
   });
});
{/literal}
</script>

<div id="popup_wrapper">
   <div id="popup">
      {if $bNoData}
         <p class="box_error">{lang key="pageNotFound"}</p>
      {else}
         {if $cAction == 'download_vorschau'}
            {include file='tpl_inc/popup_download_vorschau.tpl'}
         {/if}
      {/if}
   </div>
</div>