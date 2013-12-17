{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
<h2>{lang key="topsearch" section="global"}{$Einstellungen.sonstiges.sonstiges_livesuche_all_top_count}</h2>
<ul class="hlist" id="livesearch">
{foreach name=livesuchen from=$LivesucheTop item=suche}
   <li class="tag"><a href="{$suche->cURL}">{$suche->cSuche}</a> <em class="count">({$suche->nAnzahlTreffer})</em></li>
{/foreach}
</ul>

<div class="container">
   <h2>{lang key="lastsearch" section="global"}</h2>
   <ul class="hlist">
   {foreach name=livesuchen from=$LivesucheLast item=suche}
      <li class="tag"><a href="{$suche->cURL}">{$suche->cSuche}</a> <em class="count">({$suche->nAnzahlTreffer})</em></p>
   {/foreach}
   </ul>
</div>