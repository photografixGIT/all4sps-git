{if $BoxenEinstellungen.navigationsfilter.merkmalfilter_verwenden=="box"}
   {if $Suchergebnisse->MerkmalFilter|@count > 0}
   
   <div class="sidebox" id="sidebox{$oBox->kBox}">
	  <h3 class="boxtitle">{lang key="filter" section="global"}</h3>
      <div class="sidebox_content">
         <ul class="filter_state">
            {foreach name=merkmalfilter from=$Suchergebnisse->MerkmalFilter item=Merkmal}
            {assign var=kMerkmal value=$Merkmal->kMerkmal}
               <li class="label">{$Merkmal->cName}</li>
               {if ($Merkmal->cTyp == "SELECTBOX") && $Merkmal->oMerkmalWerte_arr|@count > 1}
    			<li class="values select">
    			    <form id="filter_characteristic_{$Merkmal->kMerkmal}" class="m_form" action="navi.php" method="get">
    			        <fieldset>
                            {if $NaviFilter->Kategorie->kKategorie > 0}<input type="hidden" name="k" value="{$NaviFilter->Kategorie->kKategorie}" />{/if}
                            {if $NaviFilter->Hersteller->kHersteller > 0}<input type="hidden" name="h" value="{$NaviFilter->Hersteller->kHersteller}" />{/if}
                            {if $NaviFilter->Suchanfrage->kSuchanfrage > 0}<input type="hidden" name="l" value="{$NaviFilter->Suchanfrage->kSuchanfrage}" />{/if}
                            {if $NaviFilter->MerkmalWert->kMerkmalWert > 0}<input type="hidden" name="m" value="{$NaviFilter->MerkmalWert->kMerkmalWert}" />{/if}
                            {if $NaviFilter->Suchspecial->kKey > 0}<input type="hidden" name="q" value="{$NaviFilter->Suchspecial->kKey}" />{/if}
                            {if $NaviFilter->SuchspecialFilter->kKey > 0}<input type="hidden" name="qf" value="{$NaviFilter->SuchspecialFilter->kKey}" />{/if}
                            {if $NaviFilter->Suche->cSuche|count > 0}<input type="hidden" name="suche" value="{$NaviFilter->Suche->cSuche}" />{/if}
                            {if $NaviFilter->Tag->kTag > 0}<input type="hidden" name="t" value="{$NaviFilter->Tag->kTag}" />{/if}
                            {if is_array($NaviFilter->MerkmalFilter) && !$NaviFilter->MerkmalWert->kMerkmalWert}
                            	{foreach name=merkmalfilter from=$NaviFilter->MerkmalFilter item=mmfilter}
                            		<input type="hidden" name="mf{$smarty.foreach.merkmalfilter.iteration}" value="{$mmfilter->kMerkmalWert}" />
                            	{/foreach}
                            {/if}
                            {if is_array($NaviFilter->TagFilter)}
                            	{foreach name=tagfilter from=$NaviFilter->TagFilter item=tag}
                            		<input type="hidden" name="tf{$smarty.foreach.tagfilter.iteration}" value="{$tag->kTag}" />
                            	{/foreach}
                            {/if}
            				<select id="select_filter_attribute_{$kMerkmal}" name="mf{$kMerkmal}" onchange="javascript:document.getElementById('filter_characteristic_{$Merkmal->kMerkmal}').submit();">
            					<option value="">{lang key="pleaseChoose" section="global"}</option>
            					{foreach name=merkmalwertfilter from=$Merkmal->oMerkmalWerte_arr item=MerkmalWert}
            						<option value="{$MerkmalWert->kMerkmalWert}"{if $MerkmalWert->nAktiv} selected="selected"{/if}>{$MerkmalWert->cWert} ({$MerkmalWert->nAnzahl})</option>
            					{/foreach}
        				    </select>
        				    <noscript><input type="submit" value="{lang key="view" section="global"}" /></noscript>
    				    </fieldset>
    				</form>
    			</li>
               {else}
                   {foreach name=merkmalwertfilter from=$Merkmal->oMerkmalWerte_arr item=MerkmalWert}
                      {assign var=kMerkmalWert value=$MerkmalWert->kMerkmalWert}
                      {if $MerkmalWert->nAktiv}
                         <li class="vmiddle">
                            <a rel="nofollow" href="{$NaviFilter->URL->cAlleMerkmalWerte[$kMerkmalWert]}" class="active"{if $Merkmal->cTyp == "BILD"} title="{$MerkmalWert->cWert}"{/if}>
                               {if $MerkmalWert->cBildpfadKlein != "gfx/keinBild_kl.gif" && $Merkmal->cTyp != "TEXT"}
                                  <img src="{$MerkmalWert->cBildpfadKlein}" alt="" class="vmiddle" />
                               {/if}
                               {if $Merkmal->cTyp != "BILD"}
                                   {$MerkmalWert->cWert}
                               {/if}
                               <em class="count">({$MerkmalWert->nAnzahl})</em>
                            </a>
                         </li>
                      {else}
                         <li class="vmiddle">
                            <a rel="nofollow" href="{$MerkmalWert->cURL}"{if $Merkmal->cTyp == "BILD"} title="{$MerkmalWert->cWert}"{/if}>
                               {if $MerkmalWert->cBildpfadKlein != "gfx/keinBild_kl.gif" && $Merkmal->cTyp != "TEXT"}
                                  <img src="{$MerkmalWert->cBildpfadKlein}" alt="" class="vmiddle" />
                               {/if}
                               {if $Merkmal->cTyp != "BILD"}
                                   {$MerkmalWert->cWert}
                               {/if}
                               <em class="count">({$MerkmalWert->nAnzahl})</em>
                            </a>
                         </li>
                      {/if}
                   {/foreach}
               {/if}
               {if !$smarty.foreach.merkmalfilter.last}<li class="filter_spacer"></li>{/if}
            {/foreach}
         </ul>
      </div>
   </div>
   {/if}
{/if}