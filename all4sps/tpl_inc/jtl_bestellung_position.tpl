{if $Position->nPosTyp==1}
	<p><a href="{$Position->Artikel->cURL}">{$Position->cName}</a></p>
	
	{* Seriennummer *}
	{if $Position->cSeriennummer|@count_characters > 0}
		<p>{lang key="serialnumber"}: {$Position->cSeriennummer}</p>
	{/if}
	
	{* MHD *}
	{if $Position->dMHD|@count_characters > 0}
		<p>{lang key="mdh"}: {$Position->dMHD_de}</p>
	{/if}
	
	{* Charge *}
	{if $Position->cChargeNr|@count_characters > 0}
		<p>{lang key="charge"}: {$Position->cChargeNr}</p>
	{/if}

	{if $Position->cUnique|strlen > 0 && $Position->kKonfigitem == 0 && $bKonfig}
		<ul class="children_ex">
			{foreach from=$Bestellung->Positionen item=KonfigPos}
				{if $Position->cUnique == $KonfigPos->cUnique}
					<li>{if !($KonfigPos->cUnique|strlen > 0 && $KonfigPos->kKonfigitem == 0)}{$KonfigPos->nAnzahlEinzel}x {/if}{$KonfigPos->cName} {if $bPreis}<span class="price">{$KonfigPos->cEinzelpreisLocalized[$NettoPreise]}{/if}</span></li>
				{/if}
			{/foreach}
		</ul>
	{/if}

	{if $Position->Artikel->cLocalizedVPE}
		<b><small>{lang key="basePrice" section="global"}:</b> {$Position->Artikel->cLocalizedVPE[$NettoPreise]}</small><br />
	{/if}

	{foreach name=variationen from=$Position->WarenkorbPosEigenschaftArr item=WKPosEigenschaft}
		<br>{$WKPosEigenschaft->cEigenschaftName}: {$WKPosEigenschaft->cEigenschaftWertName}
		{if $WKPosEigenschaft->fAufpreis && $bPreis}
			{$WKPosEigenschaft->cAufpreisLocalized[$NettoPreise]}
		{/if}
		</span>
	{/foreach}
{else}
	{$Position->cName}
	{if $Position->cHinweis|strlen > 0}
		<p><small>{$Position->cHinweis}</small></p>
	{/if}
{/if}