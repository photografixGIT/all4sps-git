{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
{if isset($nFullscreenTemplate) && $nFullscreenTemplate == 1}
   {include file="$cPluginTemplate"}
{else}
   {include file='tpl_inc/header.tpl'}
   <div id="content">
      {include file='tpl_inc/inc_breadcrumb.tpl'}
      
      {if $Link->Sprache->cTitle|@count_characters > 0}
		 {**
			 * ODM, 24.09.2013: had no clue where to disable the HOMEPAGE Title 
			 * @author Photografix-GmbH (www.photografix.ch)
			 *}
         <!--<h1>{$Link->Sprache->cTitle}</h1>-->
      {/if}
      
      {include file="tpl_inc/inc_extension.tpl"}
      
      {if $Link->Sprache->cContent|@count_characters > 0} 
         {**
			 * ODM, 25.09.2013: had no clue how to move the startcats.tpl plugin teasers just under the slider, so I opted to refer the class in startcats.tplö div class and to comment it out here, as there won't be custom content on the frontpage 
			 * @author Photografix-GmbH (www.photografix.ch)
			 *}
		 <div class="custom_content" style="display:;">{$Link->Sprache->cContent}</div>
      {/if} 
      
      {if $Link->nLinkart == 11}
         <div class="custom_content">
         {if $AGB->cAGBContentHtml}
            {$AGB->cAGBContentHtml}
         {elseif $AGB->cAGBContentText}
            {$AGB->cAGBContentText|nl2br}
         {/if}
         </div>
      {elseif $Link->nLinkart == 24}
         <div class="custom_content">
         {if $WRB->cWRBContentHtml}
            {$WRB->cWRBContentHtml}
         {elseif $WRB->cWRBContentText}
            {$WRB->cWRBContentText|nl2br}
         {/if}
         </div>
      {elseif $Link->nLinkart == 5}
         {include file='tpl_inc/seite_startseite.tpl'}
      {elseif $Link->nLinkart == 6}
          {include file='tpl_inc/seite_versand.tpl'}
      {elseif $Link->nLinkart == 14}
         {include file='tpl_inc/seite_tagging.tpl'}
      {elseif $Link->nLinkart == 15}
         {include file='tpl_inc/seite_livesuche.tpl'}
      {elseif $Link->nLinkart == 16}
         {include file='tpl_inc/seite_hersteller.tpl'}
      {elseif $Link->nLinkart == 18}
         {include file='tpl_inc/seite_newsletterarchiv.tpl'}
      {elseif $Link->nLinkart == 20}
         {include file='tpl_inc/seite_newsarchiv.tpl'}
      {elseif $Link->nLinkart == 21}
         {include file='tpl_inc/seite_sitemap.tpl'}
      {elseif $Link->nLinkart == 23}
         {include file='tpl_inc/seite_gratisgeschenk.tpl'}
      {elseif $Link->nLinkart == 25 && $nFullscreenTemplate == 0}
         {include file="$cPluginTemplate"}
      {elseif $Link->nLinkart == 26}
         {include file='auswahlassistent.tpl'}
      {elseif $Link->nLinkart == 29}
         {include file='tpl_inc/seite_404.tpl'}
      {/if}
      {include file='tpl_inc/inc_seite.tpl' print=$Link->cDruckButton}
   </div>
   {include file='tpl_inc/footer.tpl'}
{/if}