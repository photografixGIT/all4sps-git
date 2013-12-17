<div class="sidebox" id="sidebox{$oBox->kBox}">
   <div>
      <h3 class="boxtitle">{lang key="yourBasket" section="global"} <span id="basket_loader"></span></h3>
   </div>
   <div class="sidebox_content">
      <a href="warenkorb.php?{$SID}" class="basket {if $WarenkorbArtikelanzahl > 0}pushed{/if}" id="basket_drag_area">
         <span id="basket_text">{$Warenkorbtext}</span>
         <span class="basket_link">{lang key="gotoBasket"}</span>
      </a>
   </div>
</div>