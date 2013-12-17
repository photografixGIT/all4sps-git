{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
<p class="box_info">{lang key="freeGiftFromOrderValue" section="global"}</p>

{if $oArtikelGeschenk_arr|@count > 0 && $oArtikelGeschenk_arr}
<div id="freegift" class="container">
   <ul class="hlist articles">
      {foreach name=gratisgeschenke from=$oArtikelGeschenk_arr item=oArtikelGeschenk}
      <li class="p33 tcenter {if $smarty.foreach.gratisgeschenke.index % 3 == 0}clear{/if}">
         <div>
            <a href="{$oArtikelGeschenk->cURL}">
               <img src="{$oArtikelGeschenk->Bilder[0]->cPfadKlein}" class="image" />
            </a>
            <p class="small">{lang key="freeGiftFrom1" section="global"} {$oArtikelGeschenk->cBestellwert} {lang key="freeGiftFrom2" section="global"}</p>
            <p><a href="{$oArtikelGeschenk->cURL}">{$oArtikelGeschenk->cName}</a><p>
         </div>
      </li>
      {/foreach}
   </ul>
</div>
{/if}