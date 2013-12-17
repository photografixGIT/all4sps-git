{if isset($oArtikel_arr) && count($oArtikel_arr)>0}
<div class="container {if isset($cClass)}{$cClass}{/if}">

   <h2 class="title">{if $headline}{$headline}{else}{lang key=$cKey section=$cSection}{/if}</h2>
   <ul class="hlist articles">
      {foreach name=prod from=$oArtikel_arr item=oArtikel}
      <li class="p309 {if $smarty.foreach.prod.iteration % 3 == 0}nomargin {/if}{if $smarty.foreach.prod.index % 3 == 0}clear{/if}">
            <div class="pwrapper">
               <p class="pimage">
                  <a href="{$oArtikel->cURL}" title="{$oArtikel->cName|strip_tags|escape:"quotes"}">
                     <img src="{$oArtikel->Bilder[0]->cPfadKlein}" class="image" alt="{$oArtikel->cName|strip_tags}" />
                  </a>
               </p>
               <h3><a href="{$oArtikel->cURL}">{$oArtikel->cName}</a></h3>
               <div class="left p40">
                  <span class="stars p{$oArtikel->fDurchschnittsBewertung|replace:'.':'_'}"></span>
               </div>
               
               <div class="left p60 tright">
                  {if $smarty.session.Kundengruppe->darfPreiseSehen}
                  <p>
                     <span class="price_label">{lang key="only" section="global"}</span> <span class="price">{$oArtikel->Preise->cVKLocalized[$NettoPreise]}</span>
                  </p>
                  {if $oArtikel->cLocalizedVPE}
                     <p><small><b>{lang key="basePrice" section="global"}:</b> {$oArtikel->cLocalizedVPE[$NettoPreise]}</small></p>
                  {/if}
                  <p>
                     <span class="vat_info">{$Artikel->cMwstVersandText}</span>
                  </p>
                  {/if}
               </div>
               
            </div>
         </li>
      {/foreach}
   </ul>
</div>
{/if}
