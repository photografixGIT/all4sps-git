{if $bBoxenFilterNach}
   {if $BoxenEinstellungen.navigationsfilter.preisspannenfilter_benutzen=="box"}
   {if $Suchergebnisse->Preisspanne|@count > 0}
   
   <div class="sidebox filterOption preisslider" id="boxPreisSlider">
      <h3 class="boxtitle">{lang key="rangeOfPrices" section="global"}</h3>
      <div class="sidebox_content">
         
        <div class="slider_body">
            <div class="bgslider"></div>
            <div id="slider-range"></div>
         </div>
        
        {foreach name=Preisspanne from=$Suchergebnisse->Preisspanne item=Preisspanne}
        	{if $smarty.foreach.Preisspanne.first}
            	{if isset($smarty.get.pfxmin)}
		        	<input type="hidden" id="pfmin" value="{$smarty.get.pfxmin}" />
	            {else}
			        <input type="hidden" id="pfmin" value="{$Preisspanne->nVon}" />
                {/if}
            {/if}
            {if $smarty.foreach.Preisspanne.last}
		        {if isset($smarty.get.pfxmax)}
		        	<input type="hidden" id="pfmax" value="{$smarty.get.pfxmax}" />
	            {else}
			        <input type="hidden" id="pfmax" value="{$Preisspanne->nBis}" />
                {/if}
                <input type="hidden" id="pfurl" value="{$Preisspanne->cURL|replace:"pf=":"pfold="}" />
            {/if}
        {/foreach}
        {if isset($smarty.get.pfrminold) && isset($smarty.get.pfrmaxold)}
        	<input type="hidden" id="pfminold" value="{$smarty.get.pfrminold}" />
        	<input type="hidden" id="pfmaxold" value="{$smarty.get.pfrmaxold}" />
        {elseif isset($NaviFilter->PreisspannenFilter)}
        	<input type="hidden" id="pfminold" value="{$NaviFilter->PreisspannenFilter->fVon}" />
        	<input type="hidden" id="pfmaxold" value="{$NaviFilter->PreisspannenFilter->fBis}" />
        {else}
            {foreach name=Spanne from=$Suchergebnisse->Preisspanne item=Preisspanne}
                {if $smarty.foreach.Spanne.first}
                    <input type="hidden" id="pfminold" value="{$Preisspanne->nVon}" />
                {/if}
                {if $smarty.foreach.Spanne.last}
                    <input type="hidden" id="pfmaxold" value="{$Preisspanne->nBis}" />
                {/if}
            {/foreach}
        {/if}
		
		<input type="text" id="sliamount" />
    </div>

    </div>
    
   {/if}
   {/if}
{/if}