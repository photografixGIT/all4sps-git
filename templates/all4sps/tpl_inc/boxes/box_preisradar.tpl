{if isset($Boxen.Preisradar->Artikel->elemente) && $Boxen.Preisradar->Artikel->elemente|@count > 0}
<div class="sidebox" id="sidebox{$oBox->kBox}">
    <h3 class="boxtitle">{lang key="priceRadar" section="global"}</h3>
    <div class="sidebox_content">
    {if $BoxenEinstellungen.boxen.boxen_preisradar_scrollbar > 0}
        <marquee behavior="scroll" direction="{if $BoxenEinstellungen.boxen.boxen_preisradar_scrollbar == 1}down{else}up{/if}" onmouseover="this.stop()" onmouseout="this.start()" scrollamount="2" scrolldelay="70">
    {/if}
        <ul>
        {foreach name=sonderangebote from=$Boxen.Preisradar->Artikel->elemente item=oArtikel}
            <li>
                <div class="container tcenter clearall">
                    <p><a href="{$oArtikel->cURL}"><img src="{$oArtikel->cVorschaubild}" alt="{$oArtikel->cName|strip_tags|escape:"quotes"|truncate:60}" class="image" /></a></p>
                    <p><a href="{$oArtikel->cURL}">{$oArtikel->cName}</a></p>
            
                    {lang key="oldPrice" section="global"}: <del>{$oArtikel->oPreisradar->fOldVKLocalized[$NettoPreise]}</del>
                    {include file="tpl_inc/artikel_preis.tpl" price_image=$oArtikel->Preise->strPreisGrafik_Sonderbox Artikel=$oArtikel scope="box"}
                </div>
            </li>
        {/foreach}
        </ul>
      
    {if $BoxenEinstellungen.boxen.box_sonderangebote_scrollen>0}
        </marquee>
    {/if}
    </div>
</div>
{/if}