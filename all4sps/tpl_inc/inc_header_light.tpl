      <div id="header" class="header_light page_width {if $Einstellungen.template.general.page_align == 'L'}page_left{else}page_center{/if}">
         <div id="logo">
            <a href="{$ShopURL}{if $SID}/index.php?{$SID}{/if}" title="{$Einstellungen.global.global_shopname}">
               {image src=$ShopLogoURL alt=$Einstellungen.global.global_shopname}
            </a>
         </div>
         <div id="headlinks_wrapper">
            <div id="headlinks">
               <ul>
                  <li class="last {if $WarenkorbArtikelanzahl >= 1}items{/if}{if $nSeitenTyp == 3} current{/if}"><a href="warenkorb.php?{$SID}">{lang key="basket"}: {$WarenkorbWarensumme[$NettoPreise]}<span></span></a></li>
               </ul>
            </div>
         </div>

      </div>