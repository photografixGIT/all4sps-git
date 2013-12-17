{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="{$meta_language}" lang="{$meta_language}">
<head>
   <title>{$meta_title}</title>
   <meta http-equiv="content-type" content="text/html; charset={$JTL_CHARSET}" />
   <meta http-equiv="content-language" content="{$meta_language}" />
   <meta name="description" content="{$meta_description|truncate:1000:"":true}" />
   <meta name="keywords" content="{$meta_keywords|truncate:255:"":true}" />
   <meta name="template" content="Southbridge Media" />
   {if $Einstellungen.template.general.viewport_device_width == 'Y'}
       <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.5" />
   {/if}
   <meta name="language" content="{$meta_language}" />
   {if $bNoIndex == true}
      <meta name="robots" content="noindex" />
   {else}
      <meta name="robots" content="index, follow" />
   {/if}
   <meta name="publisher" content="{$meta_publisher}" />
   <meta name="copyright" content="{$meta_copyright}" />

   {if isset($cCanonicalURL) && $cCanonicalURL|count_characters > 0}
      <link rel="canonical" href="{$cCanonicalURL}" />
   {/if}

   {assign var=cBaseRefURL value=$ShopURL}
   {if $smarty.server.HTTPS > 0}
      {assign var=cBaseRefURL value=$ShopURL|replace:"http://":"https://"}
   {/if}

   <base href="{$cBaseRefURL}/" />
   <link type="image/x-icon" href="{$currentTemplateDir}themes/base/images/favicon.ico" rel="shortcut icon"/>
   
   {if $nSeitenTyp == 1 && isset($Artikel)}
       <link rel="image_src" href="{$Artikel->Bilder[0]->cPfadNormal}" />
   {/if}
   {if $Einstellungen.template.general.use_minify == 'N'}    
      {foreach from=$cCSS_arr item="cCSS"}
         <link type="text/css" href="{$cCSS}" rel="stylesheet" media="screen" />
      {/foreach}
      {if $Einstellungen.template.theme.theme_default ne "tiny"}
          <link type="text/css" href="{$currentTemplateDir}themes/{$Einstellungen.template.theme.theme_default}/theme.css" rel="stylesheet" media="screen" />
      {/if}
      <link type="text/css" href="{$currentTemplateDir}themes/base/print.css" rel="stylesheet" media="print" />
      {foreach from=$cJS_arr item="cJS"}
         <script type="text/javascript" src="{$cJS}"></script>
      {/foreach}
   {else}
      <link type="text/css" href="{$PFAD_MINIFY}/index.php?g={$Einstellungen.template.theme.theme_default}.css&amp;{$nTemplateVersion}" rel="stylesheet" media="screen" />
      {if $Einstellungen.template.theme.theme_default ne "tiny"}
          <link type="text/css" href="{$currentTemplateDir}themes/{$Einstellungen.template.theme.theme_default}/theme.css" rel="stylesheet" media="screen" />
      {/if}
      <link type="text/css" href="{$PFAD_MINIFY}/index.php?g=print.css&amp;{$nTemplateVersion}" rel="stylesheet" media="print" />
      <script type="text/javascript" src="{$PFAD_MINIFY}/index.php?g=jtl3.js&amp;{$nTemplateVersion}"></script>
   {/if}
	   <link href='https://fonts.googleapis.com/css?family=Muli' rel='stylesheet' type='text/css'>
	   <link type="text/css" href="templates/all4sps/themes/base/superfish.css" rel="stylesheet" media="screen">
	   <script type="text/javascript" src="templates/all4sps/js/jquery.validate.js"></script>
	   <script type="text/javascript" src="templates/all4sps/js/additional-methods.js"></script>
	   <script src="templates/all4sps/js/superfish.js"></script>
	   <script type="text/javascript" src="templates/all4sps/js/jquery.form.js"></script>
	   <script src="templates/all4sps/js/jquery.multifile.js"></script>
	   

	  
   <!--[if lt IE 7]>
      <link type="text/css" href="{$currentTemplateDir}themes/base/iehacks.css" rel="stylesheet" />
   <![endif]-->

   {if isset($Einstellungen.rss.rss_nutzen) && $Einstellungen.rss.rss_nutzen == "Y"}
      <link rel="alternate" type="application/rss+xml" title="Newsfeed {$Einstellungen.global.global_shopname}" href="rss.xml" />
   {/if}
   
   {if $bMobilMoeglich}
   <script type="text/javascript"> 
      var message = $("<div/>").html('{lang key="switchToMobileTemplate"}');
      if (confirm(message.text()))
         window.location.href = '{$ShopURL}/index.php?mt=1';
   </script>
   {/if}
	
   {$xajax_javascript}
   
   
   
</head>
<body class="page_type_{$nSeitenTyp}{if $oBrowser->nType > 0} browser_type_{$oBrowser->cBrowser}{/if}">

<div class="main-bg">
<div id="page"{if $bExclusive} class="exclusive"{/if}>
   {if !$bExclusive}
   <div id="header_wrapper">
      {if isset($bAdminWartungsmodus) && $bAdminWartungsmodus}
         <div id="maintenance_mode">
            <p class="box_info">{lang key="adminMaintenanceMode" section="global"}</p>
         </div>
      {/if}
      
      <div id="settings">
		 <div class="page_width {if $Einstellungen.template.general.page_align == 'L'}page_left{else}page_center{/if}"">
			{* A Smarty comment - ODM, 09/2013: swap the two ul-s *} 
			{if isset($smarty.session.Linkgruppen->Kopf) && $smarty.session.Linkgruppen->Kopf || (isset($smarty.session.Kunde->kKunde) || $smarty.session.Kunde->kKunde != 0)}
			<ul>
			   {if isset($smarty.session.Kunde->kKunde) || $smarty.session.Kunde->kKunde != 0}
				  <li class="greet">
                     <span>{lang key="hello" section="global"} {$smarty.session.Kunde->cAnredeLocalized} {$smarty.session.Kunde->cNachname}!</span>
                  </li>
			   {/if}
			   {if isset($smarty.session.Linkgruppen->Kopf) && $smarty.session.Linkgruppen->Kopf}
				  {foreach name=kopflinks from=$smarty.session.Linkgruppen->Kopf->Links item=Link}
					 <li{if $smarty.foreach.kopflinks.last} class="last{if $Link->aktiv==1} current{/if}"{/if}{if $Link->aktiv==1 && !$smarty.foreach.kopflinks.first} class="current"{/if}><a href="{$Link->URL}"{if $Link->cNoFollow == "Y"} rel="nofollow"{/if}><span>{$Link->cLocalizedName[$smarty.session.cISOSprache]}</span></a></li>
				  {/foreach}
			   {/if}



			</ul>
            

			{/if}
			
			
			<ul class="right">
			   {if isset($smarty.session.Sprachen) && $smarty.session.Sprachen|@count > 1}
                  <li class="sprache">
                     {foreach name=spr from=$smarty.session.Sprachen item=Sprache}
                     <a href="{$Sprache->cURL}"{if $Sprache->kSprache == $smarty.session.kSprache} class="active" {/if}id="language" rel="nofollow">{$Sprache->cNameDeutsch|substr:0:2|upper}</a>{if !$smarty.foreach.spr.last}|{/if}
                     {/foreach}
                  </li>
               {/if}
			   <!-- currency -->
               {if isset($smarty.session.Waehrungen) && $smarty.session.Waehrungen|@count > 1}
                  <li>
                     {foreach name=curr from=$smarty.session.Waehrungen item=oWaehrung}
                     <a href="{$oWaehrung->cURL}" rel="nofollow">{$oWaehrung->cName}</a>{if !$smarty.foreach.curr.last}|{/if}
                     {/foreach}
                  </li>
               {/if}
			</ul>
			
		 </div>
      </div>

      {include file="tpl_inc/inc_header_`$Einstellungen.template.general.use_header`.tpl"}
      
   </div>
   
   <div id="bodyWrapper">
      
      {include file="tpl_inc/topnavi_custom.tpl"}
      
      {if $Boxen.TopAngebot->anzeigen=="Y" || $Boxen.Sonderangebote->anzeigen=="Y" || $Boxen.TopAngebot->anzeigen=="Y" || $Boxen.Bestseller->anzeigen=="Y" || $Boxen.ErscheinendeProdukte->anzeigen=="Y" || $Boxen.TopBewertet->anzeigen=="Y"}
      <div id="speciallinks" class="page_width {if $Einstellungen.template.general.page_align == 'L'}page_left{else}page_center{/if}">
         <ul>
         {if $Boxen.NeuImSortiment->anzeigen=="Y"}
            <li><a href="{$Boxen.NeuImSortiment->cURL|replace:"&":"&amp;"}"><span>{lang key="showAllNewProducts" section="global"}</span></a></li>
         {/if}
         {if $Boxen.Sonderangebote->anzeigen=="Y"}
            <li><a href="{$Boxen.Sonderangebote->cURL|replace:"&":"&amp;"}"><span>{lang key="showAllSpecialOffers" section="global"}</span></a></li>
         {/if}
         {if $Boxen.TopAngebot->anzeigen=="Y"}
            <li><a href="{$Boxen.TopAngebot->cURL|replace:"&":"&amp;"}"><span>{lang key="showAllTopOffers" section="global"}</span></a></li>
         {/if}
         {if $Boxen.Bestseller->anzeigen=="Y"}
            <li><a href="{$Boxen.Bestseller->cURL|replace:"&":"&amp;"}"><span>{lang key="showAllBestsellers" section="global"}</span></a></li>
         {/if}
         {if $Boxen.ErscheinendeProdukte->anzeigen=="Y"}
            <li><a href="{$Boxen.ErscheinendeProdukte->cURL|replace:"&":"&amp;"}"><span>{lang key="showAllUpcomingProducts" section="global"}</span></a></li>
         {/if}
         {if $Boxen.TopBewertet->anzeigen=="Y"}
            <li><a href="{$Boxen.TopBewertet->cURL|replace:"&":"&amp;"}"><span>{lang key="topReviews" section="global"}</span></a></li>
         {/if}
         </ul>
      </div>
      {/if}
   {/if}
   
   {if !$bExclusive}
   <div id="outer_wrapper" class="{if $Einstellungen.template.general.page_align == 'L'}page_left{else}page_center{/if} page_width">
      <div id="page_wrapper" class="{get_box_layout}">
         <div id="content_wrapper">
   {/if}