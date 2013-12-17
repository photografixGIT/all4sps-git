{*if $Boxen.Vergleichsliste->anzeigen=="Y" && $Boxen.Vergleichsliste->cAnzeigen == "Y"*}
{if $smarty.session.Vergleichsliste->oArtikel_arr|@count > 0 && $Boxen.Vergleichsliste->nAnzahl > 0}
    <div class="sidebox" id="sidebox{$oBox->kBox}">
        <h3 class="boxtitle">{lang key="compare" section="global"}</h3>
        <div class="sidebox_content">
            {foreach name=vergleich from=$smarty.session.Vergleichsliste->oArtikel_arr item=oArtikel}
                {if $smarty.foreach.vergleich.iteration <= $Boxen.Vergleichsliste->nAnzahl}
                    <ul class="comparelist clearall">
                        <li class="img"><a href="{$oArtikel->cURL}"><img src="{$oArtikel->Bilder[0]->cPfadMini}" class="image" alt="{$oArtikel->cName|strip_tags|escape:"quotes"|truncate:60}" /></a></li>
                        <li class="desc">
                            <p><a href="{$oArtikel->cURL}">{$oArtikel->cName|truncate:25:"..."}</a></p>
                            <a href="{$oArtikel->cURLDEL}" class="remove"></a>
                        </li>
                    </ul>
                {/if}
            {/foreach} 
            <p class="tcenter">
                {if $BoxenEinstellungen.vergleichsliste.vergleichsliste_target == "popup"}
                    <a href="index.php?vla=1&{$SID}" onclick="showCompareList();return false;">{lang key="gotToCompare" section="global"}</a>
                {else}
                    <a href="index.php?vla=1&{$SID}" target="_{$BoxenEinstellungen.vergleichsliste.vergleichsliste_target}">{lang key="gotToCompare" section="global"}</a>
                {/if}
            </p>
        </div>
    </div>
{/if}