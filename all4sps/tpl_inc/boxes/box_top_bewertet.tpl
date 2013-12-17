{if isset($Boxen.TopBewertet->oArtikel_arr) && $Boxen.TopBewertet->oArtikel_arr|@count > 0}
<div class="sidebox" id="sidebox{$oBox->kBox}">
   <h3 class="boxtitle">{lang key="topReviews" section="global"}</h3>
   <div class="sidebox_content">
      {if $BoxenEinstellungen.boxen.boxen_topbewertet_scrollbar > 0}
         <marquee behavior="scroll" direction="{if $BoxenEinstellungen.boxen.boxen_topbewertet_scrollbar == 1}down{else}up{/if}" onmouseover="this.stop()" onmouseout="this.start()" scrollamount="2" scrolldelay="70">
      {/if}
      
      <ul>
         {foreach name=topbewertet from=$Boxen.TopBewertet->oArtikel_arr item=oArtikel}
         <li>
         <div class="container tcenter">
            <p><a href="{$oArtikel->cURL}"><img src="{$oArtikel->cVorschaubild}" alt="{$oArtikel->cName|strip_tags|escape:"quotes"|truncate:60}" class="image" /></a></p>
            <p><a href="{$oArtikel->cURL}">{$oArtikel->cName}</a></p>
            
            {include file="tpl_inc/artikel_preis.tpl" price_image=$oArtikel->Preise->strPreisGrafik_Topbox Artikel=$oArtikel scope="box"}
         </div>
         </li>
         {/foreach}
      </ul>
      
      {if $BoxenEinstellungen.boxen.boxen_topbewertet_scrollbar > 0}
         </marquee>
      {/if}
      
      <p class="tcenter">
         <a href="{$Boxen.TopBewertet->cURL}">{lang key="topReviews" section="global"}</a>
      </p>
   </div>
</div>
{/if}