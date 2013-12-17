<div id="article_pushed" class="tleft">
   <h2>{lang key="basketAdded" section="messages"}</h2>
   
   <div class="clearall2">
      <div class="img">
         <a href="{$zuletztInWarenkorbGelegterArtikel->cURL}"><img src="{$zuletztInWarenkorbGelegterArtikel->Bilder[0]->cPfadNormal}" class="image" height="60" alt="" /></a>
      </div>
      <div class="info">
         <ul>
            <li><a href="{$zuletztInWarenkorbGelegterArtikel->cURL}" title="{$zuletztInWarenkorbGelegterArtikel->cName}">{$zuletztInWarenkorbGelegterArtikel->cName}</a></li>
            <li>{lang key="quantity" section="global"}: {$fAnzahl|replace_delim}{if $zuletztInWarenkorbGelegterArtikel->cEinheit != ''} {$zuletztInWarenkorbGelegterArtikel->cEinheit}{else}x{/if}</li>
            <li>{lang key="productNo"}: {$zuletztInWarenkorbGelegterArtikel->cArtNr}</li>
         </ul>
      </div>
      <div class="clear"></div>
   </div>
   
   <div class="actions">
      <button type="button" class="simplemodal-close submit">{lang key="continueShopping" section="checkout"}</button>
      <button type="button" class="submit" onclick="location.href='warenkorb.php?{$SID}'">{lang key="gotoBasket"}</button>
   </div>
     
   {if isset($Xselling->Kauf) && count($Xselling->Kauf->Artikel)>0}
      <div class="container hide_overflow">
         {include file="tpl_inc/artikel_inc_liste.tpl" cKey="customerWhoBoughtXBoughtAlsoY" cSection="productDetails" oArtikel_arr=$Xselling->Kauf->Artikel cClass="article_pushed_xseller" cID="mycarousel_pushed" bAutoload="false"}
      </div>
   {/if}
</div>