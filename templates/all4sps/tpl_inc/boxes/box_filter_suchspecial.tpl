{if $bBoxenFilterNach}
   {if $Einstellungen.navigationsfilter.allgemein_suchspecialfilter_benutzen == "Y" && !$NaviFilter->SuchspecialFilter->kKey && !$NaviFilter->Suchspecial->kKey}
   {if $Suchergebnisse->Suchspecialauswahl[1]->nAnzahl > 0 ||
      $Suchergebnisse->Suchspecialauswahl[2]->nAnzahl > 0 ||
      $Suchergebnisse->Suchspecialauswahl[3]->nAnzahl > 0 ||
      $Suchergebnisse->Suchspecialauswahl[4]->nAnzahl > 0 ||
      $Suchergebnisse->Suchspecialauswahl[5]->nAnzahl > 0 ||
      $Suchergebnisse->Suchspecialauswahl[6]->nAnzahl > 0}
      <div class="sidebox" id="sidebox{$oBox->kBox}">
         <h3 class="boxtitle">{lang key="specificProducts" section="global"}</h3>
         <div class="sidebox_content">
            <ul class="filter_state">
               {if $Suchergebnisse->Suchspecialauswahl[1]->nAnzahl > 0}<li> <a href="{$Suchergebnisse->Suchspecialauswahl[1]->cURL}" rel="nofollow">{lang key="bestsellers" section="global"} <em class="count">{if !$nMaxAnzahlArtikel}({$Suchergebnisse->Suchspecialauswahl[1]->nAnzahl}){/if}</em></a></li>{/if}
               {if $Suchergebnisse->Suchspecialauswahl[2]->nAnzahl > 0}<li> <a href="{$Suchergebnisse->Suchspecialauswahl[2]->cURL}" rel="nofollow">{lang key="specialOffer" section="global"} <em class="count">{if !$nMaxAnzahlArtikel}({$Suchergebnisse->Suchspecialauswahl[2]->nAnzahl}){/if}</em></a></li>{/if}
               {if $Suchergebnisse->Suchspecialauswahl[3]->nAnzahl > 0}<li> <a href="{$Suchergebnisse->Suchspecialauswahl[3]->cURL}" rel="nofollow">{lang key="newProducts" section="global"} <em class="count">{if !$nMaxAnzahlArtikel}({$Suchergebnisse->Suchspecialauswahl[3]->nAnzahl}){/if}</em></a></li>{/if}
               {if $Suchergebnisse->Suchspecialauswahl[4]->nAnzahl > 0}<li> <a href="{$Suchergebnisse->Suchspecialauswahl[4]->cURL}" rel="nofollow">{lang key="topOffer" section="global"} <em class="count">{if !$nMaxAnzahlArtikel}({$Suchergebnisse->Suchspecialauswahl[4]->nAnzahl}){/if}</em></a></li>{/if}
               {if $Suchergebnisse->Suchspecialauswahl[5]->nAnzahl > 0}<li> <a href="{$Suchergebnisse->Suchspecialauswahl[5]->cURL}" rel="nofollow">{lang key="upcomingProducts" section="global"} <em class="count">{if !$nMaxAnzahlArtikel}({$Suchergebnisse->Suchspecialauswahl[5]->nAnzahl}){/if}</em></a></li>{/if}
               {if $Suchergebnisse->Suchspecialauswahl[6]->nAnzahl > 0}<li> <a href="{$Suchergebnisse->Suchspecialauswahl[6]->cURL}" rel="nofollow">{lang key="topReviews" section="global"} <em class="count">{if !$nMaxAnzahlArtikel}({$Suchergebnisse->Suchspecialauswahl[6]->nAnzahl}){/if}</em></a></li>{/if}
            </ul>
         </div>
      </div>
      {/if}
   {/if}
   
   {if $NaviFilter->SuchspecialFilter->kKey > 0 && $NaviFilter->Suchspecial->kKey != $NaviFilter->SuchspecialFilter->kKey}
   <div class="sidebox" id="sidebox{$oBox->kBox}">
      <h3 class="boxtitle">{lang key="specificProducts" section="global"}</h3>
      <div class="sidebox_content">
         <ul class="filter_state">
            {if $NaviFilter->SuchspecialFilter->kKey == 1}
               <li><a rel="nofollow" href="{$NaviFilter->URL->cAlleSuchspecials}" class="active">{lang key="bestsellers" section="global"}</a></li>
            {elseif $NaviFilter->SuchspecialFilter->kKey == 2}
               <li><a rel="nofollow" href="{$NaviFilter->URL->cAlleSuchspecials}" class="active">{lang key="specialOffers" section="global"}</a></li>
            {elseif $NaviFilter->SuchspecialFilter->kKey == 3}
               <li><a rel="nofollow" href="{$NaviFilter->URL->cAlleSuchspecials}" class="active">{lang key="newProducts" section="global"}</a></li>
            {elseif $NaviFilter->SuchspecialFilter->kKey == 4}
               <li><a rel="nofollow" href="{$NaviFilter->URL->cAlleSuchspecials}" class="active">{lang key="topOffers" section="global"}</a></li>
            {elseif $NaviFilter->SuchspecialFilter->kKey == 5}
               <li><a rel="nofollow" href="{$NaviFilter->URL->cAlleSuchspecials}" class="active">{lang key="upcomingProducts" section="global"}</a></li>
            {elseif $NaviFilter->SuchspecialFilter->kKey == 6}
               <li><a rel="nofollow" href="{$NaviFilter->URL->cAlleSuchspecials}" class="active">{lang key="topReviews" section="global"}</a></li>
            {/if}
         </ul>
      </div>
   </div>
   {/if}
{/if}