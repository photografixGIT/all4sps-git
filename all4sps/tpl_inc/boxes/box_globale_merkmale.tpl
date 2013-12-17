{*if $Boxen.oGlobalMerkmal_arr|@count > 0 && $BoxenEinstellungen.navigationsfilter.allgemein_globalmerkmalfilter_benutzen=="Y"*}
{if $Boxen.oGlobalMerkmal_arr|@count > 0}
{foreach name=globalemerkmale from=$Boxen.oGlobalMerkmal_arr item=oMerkmal}    
<div class="sidebox" id="sidebox{$oBox->kBox}">
    <div class="sidebox_content">
        <ul class="filter_state">
            <li class="label">
                {if $oMerkmal->cBildpfadKlein|count_characters > 0 && $oMerkmal->cBildpfadKlein != "gfx/keinBild_kl.gif"}
                   <img src="{$oMerkmal->cBildpfadKlein}" alt="" class="vmiddle" />
                {/if}
                {$oMerkmal->cName}
            </li>
            {foreach name=globalmerkmalwert from=$oMerkmal->oMerkmalWert_arr item=oMerkmalWert}
            {if isset($NaviFilter->MerkmalWert->kMerkmalWert) && $NaviFilter->MerkmalWert->kMerkmalWert > 0 && isset($oMerkmalWert->kMerkmalWert) && $NaviFilter->MerkmalWert->kMerkmalWert == $oMerkmalWert->kMerkmalWert}
                <li>
                    <a href="{$oMerkmalWert->cURL}" class="active">
                        {if $oMerkmalWert->cBildpfadKlein|count_characters > 0 && $oMerkmalWert->cBildpfadKlein != "gfx/keinBild_kl.gif"}
                           <img src="{$oMerkmalWert->cBildpfadKlein}" alt="" class="vmiddle" />
                        {/if}
                        {$oMerkmalWert->cWert}
                    </a>
                </li>
            {else}
                <li>
                    <a href="{$oMerkmalWert->cURL}">
                        {if $oMerkmalWert->cBildpfadKlein|count_characters > 0 && $oMerkmalWert->cBildpfadKlein != "gfx/keinBild_kl.gif"}
                           <img src="{$oMerkmalWert->cBildpfadKlein}" alt="" class="vmiddle" />
                        {/if}
                        {$oMerkmalWert->cWert}
                    </a>
                </li>
            {/if}
            {/foreach}
        </ul>
    </div>
</div>
{/foreach}
{/if}