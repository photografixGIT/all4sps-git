{if $bBoxenFilterNach}
   <!-- bewertungsfilter -->
   {if $BoxenEinstellungen.navigationsfilter.bewertungsfilter_benutzen=="box"}
   {if $Suchergebnisse->Bewertung|@count > 0}
   <div class="sidebox" id="sidebox{$oBox->kBox}">
      <h3 class="boxtitle">{lang key="Votes" section="global"}</h3>
      <div class="sidebox_content">
            <ul class="filter_state">
               {foreach name=bewertungen from=$Suchergebnisse->Bewertung item=oBewertung}
                  {if $Suchergebnisse->GesamtanzahlArtikel > $oBewertung->nAnzahl}
                     {if $NaviFilter->BewertungFilter->nSterne == $oBewertung->nStern}
                        <li><a rel="nofollow" href="{$NaviFilter->URL->cAlleBewertungen}" class="active" title="{$oBewertung->nStern} {if $oBewertung->nStern > 0}{lang key="starPlural"}{else}{lang key="starSingular"}{/if}"><span class="stars p{$oBewertung->nStern} vmiddle"></span> {if $NaviFilter->BewertungFilter->nSterne < 5}<em class="count">&amp; mehr</em>{/if} <em class="count">({$oBewertung->nAnzahl})</em></a></li>
                     {else}
                        <li><a rel="nofollow" href="{$oBewertung->cURL}" title="{$oBewertung->nStern} {if $oBewertung->nStern > 0}{lang key="starPlural"}{else}{lang key="starSingular"}{/if}"><span class="stars p{$oBewertung->nStern} vmiddle"></span> {if $oBewertung->nStern < 5}<em class="count">&amp; {lang key="more"}</em>{/if} <em class="count">({$oBewertung->nAnzahl})</em></a></li>
                     {/if}
                  {/if}
               {/foreach}
            </ul>
      </div>
   </div>
   {/if}
   {/if}
{/if}
