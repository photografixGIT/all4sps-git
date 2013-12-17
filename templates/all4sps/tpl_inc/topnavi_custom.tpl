
<div id="topnavi">
   <ul id="topnavi-ulsa">
   
   {if isset($smarty.session.Linkgruppen->Topnavi) && $smarty.session.Linkgruppen->Topnavi}
      {foreach name=navilinks from=$smarty.session.Linkgruppen->Topnavi->Links item=Link}
         <li {if $Link->aktiv==1 OR ($Link->cLocalizedName[$smarty.session.cISOSprache] == 'Ankauf' AND $Link->cName =='Ankauf') }class="active"{/if}><a href="{$Link->URL}"><span>{$Link->cLocalizedName[$smarty.session.cISOSprache]}</span></a></li>
      {/foreach}
   {/if}
   {if $Einstellungen.template.categories.topnavi_categories_full_category_tree == "Y" && $nID == 0}
      
   {/if}
   {if $Einstellungen.template.general.use_header != 'searchtop'}
      <li id="search">
		 <form class="search-form" id="search-form" action="navi.php" method="get">
            <fieldset>
			   <input type="text" name="suchausdruck" id="suggest" class="placeholder" title="{lang key="findProduct"}" />
			   <input type="hidden" name="{$session_name}" value="{$session_id}" />
			   <input type="submit" id="submit_search" value="{lang key="search" section="global"}" />
			</fieldset>
		 </form>
      </li>
   {/if}
   </ul>
  
{literal}
<script type="text/javascript">
// initialise plugins
		jQuery(function(){
			// main navigation init
			// but first remove what is added by jtl function php and the template css stuff
			$("#topnaviulsuperfish ul, #topnaviulsuperfish li").removeClass("subcat-0 subcat-1 first node");
			$("#topnaviulsuperfish h4").contents().unwrap();
			jQuery('ul.sf-menu').superfish({
				delay:       1000, 		// one second delay on mouseout 
				animation:   {opacity:'show',height:'show'}, // fade-in and slide-down animation
				speed:       'normal',  // faster animation speed 
				autoArrows:  true,   // generation of arrow mark-up (for submenu) 
				dropShadows: false
			});
});
</script>
{/literal}


   <ul id="topnaviulsuperfish" class="sf-menu" style="margin-left:13px;">
	{if $Einstellungen.template.categories.topnavi_categories_full_category_tree == "Y" && $nID == 0}
      {$full_category_tree}
    {/if}
   </ul>
   
   <div class="clear"></div>
</div>


