		 
      <div id="header" class="header_standard page_width {if $Einstellungen.template.general.page_align == 'L'}page_left{else}page_center{/if}">
         <div id="logo">
            <a href="{$ShopURL}{if $SID}/index.php?{$SID}{/if}" title="{$Einstellungen.global.global_shopname}">
               {image src=$ShopLogoURL alt=$Einstellungen.global.global_shopname}
            </a>
         </div>	
         <div id="headlinks_wrapper">
			<div id="services">
			   <ul>
				  <li class="hotline"><strong>{lang key="service_hotline" section="global"}</strong><br />{$Einstellungen.template.general.use_hotline}</li>
				  <li class="gift"><strong>{lang key="service_geschenk" section="global"}</strong><br />{lang key="service_geschenk_verpackung" section="global"}</li>
				  {*<li class="ssl"><strong>{lang key="service_sicher" section="global"}</strong><br />{lang key="service_bits" section="global"}</li>*}
			   </ul>
			</div>
            <div id="headlinks">
               <ul>
                  <li class="last {if $WarenkorbArtikelanzahl >= 1}items{/if}{if $nSeitenTyp == 3} current{/if}"><a href="warenkorb.php?{$SID}">{lang key="basket"}: {$WarenkorbWarensumme[$NettoPreise]}<span></span></a></li>
               </ul>
            </div>
         </div>
      </div>