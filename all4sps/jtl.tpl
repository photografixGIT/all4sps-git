{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
  
{include file='tpl_inc/header.tpl'}

{if $step=='login'}
   {include file='tpl_inc/jtl_login.tpl'}
{elseif $step=='mein Konto'}
   {include file='tpl_inc/jtl_meinkonto.tpl'}
{elseif $step=='rechnungsdaten'}
   {include file='tpl_inc/jtl_rechnungsdaten.tpl'}
{elseif $step=='passwort aendern'}
   {include file='tpl_inc/jtl_passwort_aendern.tpl'}   
{elseif $step=='bestellung'}
   {include file='tpl_inc/jtl_bestellung.tpl'}   
{elseif $step=='account loeschen'}
   {include file='tpl_inc/jtl_account_loeschen.tpl'}
{elseif $step=='wunschliste anzeigen'}
   {include file='tpl_inc/jtl_wunschliste.tpl'}
{elseif $step=='wunschliste versenden'}
   {include file='tpl_inc/jtl_wunschliste_emailversand.tpl'}
{elseif $step=='kunden_werben_kunden'}
   {include file='tpl_inc/jtl_kundenwerbenkunden.tpl'}
{/if}

{include file='tpl_inc/footer.tpl'}