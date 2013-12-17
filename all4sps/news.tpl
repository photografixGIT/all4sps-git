{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
{include file='tpl_inc/header.tpl'}

{if $step == "news_uebersicht"}
    {include file='tpl_inc/news_uebersicht.tpl'}
{elseif $step == "news_monatsuebersicht"}
   {include file='tpl_inc/news_monatsuebersicht.tpl'}
{elseif $step == "news_kategorieuebersicht"}
   {include file='tpl_inc/news_kategorieuebersicht.tpl'}
{elseif $step == "news_detailansicht"}
   {include file='tpl_inc/news_detailansicht.tpl'}
{/if}

{include file='tpl_inc/footer.tpl'}