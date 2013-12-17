{if $bBoxenFilterNach}
   {if $BoxenEinstellungen.navigationsfilter.preisspannenfilter_benutzen=="box"}
   {if $Suchergebnisse->Preisspanne|@count > 0}
   <div class="sidebox" id="sidebox{$oBox->kBox}">
      <h3 class="boxtitle">{lang key="rangeOfPrices" section="global"}</h3>
      <div class="sidebox_content">   
            <ul class="filter_state">

               {if $NaviFilter->PreisspannenFilter->cWert}
                  {if $NaviFilter->PreisspannenFilter->fVon >= 0 && $NaviFilter->PreisspannenFilter->fBis > 0}
                     <li>
                        <a href="{$NaviFilter->URL->cAllePreisspannen}" rel="nofollow" class="active">{$NaviFilter->PreisspannenFilter->cVonLocalized} - {$NaviFilter->PreisspannenFilter->cBisLocalized}</a>
                     </li>
                  {/if}
               {else}
                  {foreach name=preisspannen from=$Suchergebnisse->Preisspanne item=oPreisspannenfilter}
                     <li>
                        <a href="{$oPreisspannenfilter->cURL}" rel="nofollow">{$oPreisspannenfilter->cVonLocalized} - {$oPreisspannenfilter->cBisLocalized} <em class="count">({$oPreisspannenfilter->nAnzahlArtikel})</em></a>
                     </li>
                  {/foreach}
               {/if}
            </ul>
      </div>
   </div>
   {/if}
   {/if}
{/if}
