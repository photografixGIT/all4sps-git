<div id="content_footer" class="clear">
      <div class="footer_links">
         <a href="javascript:history.back()" class="back">{lang key="back" section="global"}</a>
         <a href="javascript:scroll(0,0)" class="top">{lang key="goTop" section="global"}</a>
         {if (isset($print) && $print == 'Y') || !isset($print)}
            <a href="javascript:window.print()" class="print">{lang key="printThisPage" section="global"}</a>
         {/if}
      </div>
</div>