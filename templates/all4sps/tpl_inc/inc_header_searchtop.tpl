      <div id="header" class="header_searchtop page_width {if $Einstellungen.template.general.page_align == 'L'}page_left{else}page_center{/if}">
         <div id="logo">
            <a href="{$ShopURL}{if $SID}/index.php?{$SID}{/if}" title="{$Einstellungen.global.global_shopname}">
               {image src=$ShopLogoURL alt=$Einstellungen.global.global_shopname}
            </a>
         </div>
         <div id="headlinks_wrapper">
			<div id="services">
			   <ul>
				  <li class="hotline"><strong>{lang key="service_hotline" section="global"}</strong><br />{$Einstellungen.template.general.use_hotline}</li>
				  <li id="search">
					 <form class="search-form" id="search-form" action="navi.php" method="get">
						<fieldset>
						   <input type="text" name="suchausdruck" id="suggest" class="placeholder" title="{lang key="findProduct"}" />
						   <input type="hidden" name="{$session_name}" value="{$session_id}" />
						   <input type="submit" id="submit_search" value="{lang key="search" section="global"}" />
						</fieldset>
					 </form>
                  </li>
			   </ul>
			</div>
            <div id="headlinks">
               <ul>
                  <li class="last {if $WarenkorbArtikelanzahl >= 1}items{/if}{if $nSeitenTyp == 3} current{/if}" id="basket_drag_area"><a href="warenkorb.php?{$SID}">{lang key="basket"}: {$WarenkorbWarensumme[$NettoPreise]}<span></span></a></li>
               </ul>
            </div>
         </div>

      </div>