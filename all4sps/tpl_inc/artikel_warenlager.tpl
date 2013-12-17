{* nur anzeigen, wenn >1 Warenlager aktiv und Artikel ist auf Lager/im Zulauf/Überverkäufe erlaubt/beachtet kein Lager *}
{if isset($Artikel->oWarenlager_arr) && $Artikel->oWarenlager_arr|@count > 1 && ($Artikel->cLagerBeachten != "Y" || $Artikel->cLagerKleinerNull == "Y" || $Artikel->fLagerbestand > 0 || $Artikel->fZulauf > 0)}
    <div{if $scope eq "detail"} class="popover"{/if}>
        {if $scope eq "detail"}
            <p class="btn-store-availability"><i class="icon-info"></i> {lang key="availability" section="productDetails"}</p>
        {/if}
        <table class="warehouse popover-content config_overlay">
        {assign var=anzeige value=$Einstellungen.artikeldetails.artikel_lagerbestandsanzeige}
        {foreach name=warenlager from=$Artikel->oWarenlager_arr item=oWarenlager}
            <tr>
                <td class="name"><strong>{$oWarenlager->cName}</strong></td>
                <td>
                {if $Artikel->cLagerBeachten == "Y" && ($Artikel->cLagerKleinerNull == "N" || $Einstellungen.artikeldetails.artikeldetails_lieferantenbestand_anzeigen == 'U') && $oWarenlager->fBestand <= 0 && $oWarenlager->fZulauf > 0 && isset($oWarenlager->dZulaufDatum)}
                    {assign var=cZulauf value=`$oWarenlager->fZulauf`:::`$oWarenlager->dZulaufDatum_de`}
                    <span class="signal_image a1"><span>{lang key="productInflowing" section="productDetails" printf=$cZulauf}</span></span>
                {elseif $anzeige=='verfuegbarkeit'}
                    <span class="signal_image a{$oWarenlager->oLageranzeige->nStatus}">{$oWarenlager->oLageranzeige->cLagerhinweis[$anzeige]}</span>
                {else}
                    <span><span class="signal_image a{$oWarenlager->oLageranzeige->nStatus}">{$oWarenlager->oLageranzeige->AmpelText}</span></span>
                {/if}
                </td>
            </tr>
        {/foreach}
        </table>
    </div>
{/if}