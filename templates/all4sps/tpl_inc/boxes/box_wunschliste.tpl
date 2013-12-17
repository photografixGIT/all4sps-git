{if $Boxen.Wunschliste->anzeigen=="Y" && $smarty.session.Kunde->kKunde && $Boxen.Wunschliste->CWunschlistePos_arr|@count > 0}
<div class="sidebox" id="sidebox{$oBox->kBox}">
   <h3 class="boxtitle">{lang key="wishlist" section="global"}</h3>
   <div class="sidebox_content">
   
      <ul class="comparelist">
         {foreach name=wunschzettel from=$Boxen.Wunschliste->CWunschlistePos_arr item=oWunschlistePos}
            {if $smarty.foreach.wunschzettel.iteration <= $Boxen.Wunschliste->nAnzeigen}
               {if $Boxen.Wunschliste->nBilderAnzeigen == "Y"}
               <li class="img"><a href="{$oWunschlistePos->Artikel->cURL}" class="imgb"><img alt="" src="{$oWunschlistePos->Artikel->Bilder[0]->cPfadMini}" class="image" /></a></li>
               {/if}
               <li class="desc">
                  <p><a href="{$oWunschlistePos->Artikel->cURL}"><b>{$oWunschlistePos->fAnzahl|replace_delim}x</b> {$oWunschlistePos->cArtikelName|truncate:25:"..."}</a></p>
                  <a class="remove" href="{$oWunschlistePos->cURL}"></a>
               </li>
               <li class="clear"></li>
            {/if}
         {/foreach}
      </ul>
      
      <p class="tcenter">
         <a href="jtl.php?wl={$Boxen.Wunschliste->CWunschlistePos_arr[0]->kWunschliste}&{$SID}" class="artikelnamelink">{lang key="goToWishlist" section="global"}</a>
      </p>
   </div>
</div>
{/if}  