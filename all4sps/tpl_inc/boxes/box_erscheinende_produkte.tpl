{if isset($Boxen.ErscheinendeProdukte->Artikel->elemente) && $Boxen.ErscheinendeProdukte->Artikel->elemente|@count > 0}
<div class="sidebox" id="sidebox{$oBox->kBox}">
   <h3 class="boxtitle">{lang key="upcomingProducts" section="global"}</h3>
   <div class="sidebox_content">
      {if $BoxenEinstellungen.boxen.box_erscheinende_scrollen>0}
         <marquee behavior="scroll" direction="{if $BoxenEinstellungen.boxen.box_erscheinende_scrollen==1}down{else}up{/if}" onmouseover="this.stop()" onmouseout="this.start()" scrollamount="2" scrolldelay="70">
      {/if}
      
      <ul>
         {foreach name=inkuerzeverfuegbar from=$Boxen.ErscheinendeProdukte->Artikel->elemente item=oArtikel}
         <li>
         <div class="container tcenter">
            <p><a href="{$oArtikel->cURL}"><img src="{$oArtikel->cVorschaubild}" alt="{$oArtikel->cName|strip_tags|escape:"quotes"|truncate:60}" class="image" /></a></p>
            <p><a href="{$oArtikel->cURL}">{$oArtikel->cName}</a></p>
            
            {include file="tpl_inc/artikel_preis.tpl" Artikel=$oArtikel price_image=$oArtikel->Preise->strPreisGrafik_Baldbox scope="box"}
         </div>
         </li>
         {/foreach}
      </ul>
      
      {if $BoxenEinstellungen.boxen.box_erscheinende_scrollen>0}
         </marquee>
      {/if}
      
      <p class="tcenter">
         <a href="{$Boxen.ErscheinendeProdukte->cURL}">{lang key="showAllUpcomingProducts" section="global"}</a>
      </p>
   </div>
</div>
{/if}