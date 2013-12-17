{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
<div id="toptags">{lang key="newsletterhistory" section="global"}</div>

<table class="newsletter">
   <tr class="head">
      <th>{lang key="newsletterhistorysubject" section="global"}</th>
      <th>{lang key="newsletterhistorydate" section="global"}</th>
   </tr>
   {foreach name=newsletterhistory from=$oNewsletterHistory_arr item=oNewsletterHistory}
   <tr class="content_{$smarty.foreach.newsletterhistory.iteration%2}">
      <td class="left_td"><a href="newsletter.php?show={$oNewsletterHistory->kNewsletterHistory}&{$SID}">{$oNewsletterHistory->cBetreff}</a></td>
      <td class="right_td">{$oNewsletterHistory->Datum}</td>
   {/foreach}
   </tr>
</table>