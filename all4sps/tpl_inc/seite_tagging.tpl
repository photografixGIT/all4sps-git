{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
<div id="tagging">
   <h2>{lang key="tags"}</h2>
   <ul class="hlist">
   {foreach name=tagging from=$Tagging item=tag}
      <li class="tag"><a href="{$tag->cURL}">{$tag->cName}</a> <em class="count">({$tag->Anzahl})</em></li>
   {/foreach}
   </ul>
</div>
