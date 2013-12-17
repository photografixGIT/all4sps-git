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
   <meta http-equiv="content-type" content="text/html; charset={$JTL_CHARSET}" />
   <meta http-equiv="content-language" content="{$meta_language}" />
   <meta name="description" content="{$meta_description|truncate:1000:"":true}" />
   <meta name="keywords" content="{$meta_keywords|truncate:255:"":true}" />
   
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

   <title>{$meta_title}</title>

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

<div id="page"{if $bExclusive} class="exclusive"{/if}>
   {if !$bExclusive}
   <div id="header_wrapper">
      {if isset($bAdminWartungsmodus) && $bAdminWartungsmodus}
         <div id="maintenance_mode">
            <p class="box_info">{lang key="adminMaintenanceMode" section="global"}</p>
         </div>
      {/if}
      <div id="header" class="page_width {if $Einstellungen.template.general.page_align == 'L'}page_left{else}page_center{/if}">
         <div id="logo">
            <a href="{$ShopURL}{if $SID}/index.php?{$SID}{/if}" title="{$Einstellungen.global.global_shopname}">
               {image src=$ShopLogoURL alt=$Einstellungen.global.global_shopname}
            </a>
         </div>
         <div id="headlinks_wrapper">
            <div id="headlinks">
            {if isset($smarty.session.Linkgruppen->Kopf) && $smarty.session.Linkgruppen->Kopf}
               <ul>
                  {foreach name=kopflinks from=$smarty.session.Linkgruppen->Kopf->Links item=Link}
                     <li{if $smarty.foreach.kopflinks.first} class="first{if $Link->aktiv==1} current{/if}"{/if}{if $Link->aktiv==1 && !$smarty.foreach.kopflinks.first} class="current"{/if}><a href="{$Link->URL}"{if $Link->cNoFollow == "Y"} rel="nofollow"{/if}><span>{$Link->cLocalizedName[$smarty.session.cISOSprache]}</span></a></li>
                  {/foreach}
                  <li class="basket last {if $WarenkorbArtikelanzahl >= 1}items{/if}{if $nSeitenTyp == 3} current{/if}"><a href="warenkorb.php?{$SID}"><span>{lang key="basket"} ({$WarenkorbWarensumme[$NettoPreise]})</span></a>
                     {include file="tpl_inc/warenkorb_mini.tpl"}
                  </li>
               </ul>
            {/if}
            </div>
         </div>
         
         <div id="settings">
            <ul>
               <!-- login -->
               <li>
               {if !isset($smarty.session.Kunde->kKunde) || $smarty.session.Kunde->kKunde == 0}
                  <a href="jtl.php" id="login" class="expander">{lang key="login" section="global"}</a>
                  <div id="ep_login" class="expander_box">
                     <div class="expander_inner">
                        <!-- login form -->
                        <form action="{$ShopURLSSL}/jtl.php" method="post">
                           <fieldset class="quick_login">
                              <ul class="input_block">
                                 <li>
                                    <label for="email_quick">{lang key="emailadress" section="global"}<em>*</em>:</label>
                                    <input type="text" name="email" id="email_quick" />
                                 </li>
                                 <li>
                                    <label for="password_quick">{lang key="password" section="global"}<em>*</em>:</label>
                                    <input type="password" name="passwort" id="password_quick" />
                                 </li>
                                 <li>
                                    <p>&bull; <a href="pass.php?{$SID}" rel="nofollow">{lang key="forgotPassword" section="global"}</a></p>
                                    <p>&bull; {lang key="newHere" section="global"} <a href="registrieren.php?{$SID}">{lang key="registerNow" section="global"}</a></p>
                                 </li>
                                 <li class="clear">
                                    <input type="hidden" name="login" value="1" />
                                    <input type="hidden" name="{$session_name}" value="{$session_id}" />
                                    {if $oRedirect->cURL|count_characters > 0}
                                    {foreach name=parameter from=$oRedirect->oParameter_arr item=oParameter}
                                    <input type="hidden" name="{$oParameter->Name}" value="{$oParameter->Wert}" />
                                    {/foreach}
                                    <input type="hidden" name="r" value="{$oRedirect->nRedirect}" />
                                    <input type="hidden" name="cURL" value="{$oRedirect->cURL}" />
                                    {/if}
                                    <input type="submit" class="submit" value="{lang key="login" section="global"}" />
                                 </li>
                              </ul>
                           </fieldset>
                        </form>
                        <!-- // login form -->
                     </div>
                  </div>
                  {else}
                     <span>{lang key="hello" section="global"} {$smarty.session.Kunde->cAnredeLocalized} {$smarty.session.Kunde->cNachname}</span>
                     <a href="jtl.php?{$SID}">{lang key="myAccount" section="global"}</a>
                     <a href="jtl.php?logout=1&{$SID}">{lang key="logOut" section="global"}</a>
                  {/if}
               </li>

               <!-- currency -->
               {if isset($smarty.session.Waehrungen) && $smarty.session.Waehrungen|@count > 1}
                  <li>
                     <a href="{$Waehrung->cURL}" id="currency" class="expander" rel="nofollow">{$smarty.session.Waehrung->cName}</a>
                     <div id="ep_currency" class="expander_box">
                        <div class="expander_inner">
                           <p>
                              {foreach from=$smarty.session.Waehrungen item=oWaehrung}
                                 <a href="{$oWaehrung->cURL}" rel="nofollow">{$oWaehrung->cName}</a>
                              {/foreach}
                           </p>
                        </div>
                     </div>
                  </li>
               {/if}

               <!-- language -->
               {if isset($smarty.session.Sprachen) && $smarty.session.Sprachen|@count > 1}
                  <li>
                     {foreach from=$smarty.session.Sprachen item=Sprache}
                        {if $Sprache->kSprache == $smarty.session.kSprache}
                           <a href="{$Sprache->cURL}" id="language" class="expander" rel="nofollow">
                              {*if $lang == "ger"}{$Sprache->cNameDeutsch}{else}{$Sprache->cNameEnglisch}{/if*}
                              <img src="{$currentTemplateDir}/themes/base/images/flags/{$lang}.png" height="12" class="vmiddle" alt="{if $lang == "ger"}{$Sprache->cNameDeutsch}{else}{$Sprache->cNameEnglisch}{/if}" />
                           </a>
                        {/if}
                     {/foreach}
                     <div id="ep_language" class="expander_box">
                        <div class="expander_inner">
                           {foreach from=$smarty.session.Sprachen item=oSprache}
                           {if $oSprache->kSprache != $smarty.session.kSprache}
                              <p><a href="{$oSprache->cURL}" class="link_lang {$oSprache->cISO}" rel="nofollow">{if $lang == "ger"}{$oSprache->cNameDeutsch}{else}{$oSprache->cNameEnglisch}{/if}</a></p>
                           {/if}
                           {/foreach}
                        </div>
                     </div>
                  </li>
               {/if}

            </ul>
         </div>
      </div>

      <div id="search" class="page_width {if $Einstellungen.template.general.page_align == 'L'}page_left{else}page_center{/if}">
         <form class="search-form" id="search-form" action="navi.php" method="get">
            <fieldset>
               <input type="text" name="suchausdruck" id="suggest" class="placeholder" title="{lang key="findProduct"}" />
               <input type="hidden" name="{$session_name}" value="{$session_id}" />
               <input type="submit" id="submit_search" value="{lang key="search" section="global"}" />
            </fieldset>
         </form>
      </div>
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
   </div>
   {/if}
   
   {if !$bExclusive}
   <div id="outer_wrapper" class="{if $Einstellungen.template.general.page_align == 'L'}page_left{else}page_center{/if} page_width">
      <div id="page_wrapper" class="{get_box_layout}">
         <div id="content_wrapper">
   {/if}
