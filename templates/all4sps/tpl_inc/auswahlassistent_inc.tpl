{if isset($oAuswahlAssistent->oAuswahlAssistentFrage_arr) && $oAuswahlAssistent->oAuswahlAssistentFrage_arr|@count > 0}
<script type="text/javascript">
{literal}
function aaDeleteSelectBTN()
{
    if(document.getElementsByName("aaLosBTN").length > 0)
    {
        for(var i=0; i < document.getElementsByName("aaLosBTN").length; i++)
        {
            document.getElementsByName("aaLosBTN")[i].style.display = "none";
        }
    }
}
{/literal}
</script>

    {if isset($NaviFilter->Kategorie->kKategorie) && $NaviFilter->Kategorie->kKategorie > 0}
        {assign var=kKategorie value=$NaviFilter->Kategorie->kKategorie}
    {else}
        {assign var=kKategorie value=0}
    {/if}


    {if isset($oAuswahlAssistent->cBeschreibung) && $oAuswahlAssistent->cBeschreibung|count_characters > 0}<div class="description">{$oAuswahlAssistent->cBeschreibung}</div>{/if}
    <ul>
    {foreach name=auswahlfrage from=$oAuswahlAssistent->oAuswahlAssistentFrage_arr key=nFrage item=oAuswahlAssistentFrage}
        <li id="question_{$oAuswahlAssistentFrage->kAuswahlAssistentFrage}"{if $smarty.session.AuswahlAssistent->nFrage != $nFrage}{if $Einstellungen.auswahlassistent.auswahlassistent_allefragen == "Y" || $smarty.session.AuswahlAssistent->nFrage > $nFrage} class="disabled"{elseif $Einstellungen.auswahlassistent.auswahlassistent_allefragen == "N" && $smarty.session.AuswahlAssistent->nFrage < $nFrage} class="invisible"{/if}{/if}>
            <div class="question">{$oAuswahlAssistentFrage->cFrage}</div>
            <div class="answers" id="answer_{$oAuswahlAssistentFrage->kAuswahlAssistentFrage}">
            {if $smarty.session.AuswahlAssistent->nFrage > $nFrage}
                {$smarty.session.AuswahlAssistent->oAuswahl_arr[$nFrage]->cWert}<a href="{aaURLEncode nReset=1 nFrage=$nFrage kKategorie=$kKategorie}"><span class='edit' title="{lang key='edit' section='global'}" style="display: block;"></span></a>
            {/if}
            {if $Einstellungen.auswahlassistent.auswahlassistent_anzeigeformat == "S"}
                <form method="POST" action="{aaURLEncode bUrlOnly=true}">
                    <input name="aaParams" type="hidden" value="1" />
                    <input name="kAuswahlAssistentFrage" type="hidden" value="{$oAuswahlAssistentFrage->kAuswahlAssistentFrage}" />
                    <input name="nFrage" type="hidden" value="{$nFrage}" />
                    <input name="kKategorie" type="hidden" value="{$kKategorie}" />
            {/if}
                <span>
                {if $Einstellungen.auswahlassistent.auswahlassistent_anzeigeformat == "S"}
                    <select class="suche_improve_search" name="kMerkmalWert" onChange="return setSelectionWizardAnswer(this.options[this.selectedIndex].value, {$oAuswahlAssistentFrage->kAuswahlAssistentFrage}, {$nFrage}, {$kKategorie});">
                        <option value="-1">{lang key="pleaseChoose" section="global"}</option>
                {/if}
                {foreach name=auswahlmerkmalwerte from=$oAuswahlAssistentFrage->oMerkmal->oMerkmalWert_arr item=oMerkmalWert}
                    {if $Einstellungen.auswahlassistent.auswahlassistent_anzeigeformat == "S"}
                        <option value="{$oMerkmalWert->kMerkmalWert}">{$oMerkmalWert->cWert}{if $Einstellungen.auswahlassistent.auswahlassistent_anzahl_anzeigen == "Y"} ({$oMerkmalWert->nAnzahl}){/if}</option>
                    {else}
                        <a href="{aaURLEncode kMerkmalWert=$oMerkmalWert->kMerkmalWert kAuswahlAssistentFrage=$oAuswahlAssistentFrage->kAuswahlAssistentFrage nFrage=$nFrage kKategorie=$kKategorie}" onClick="return setSelectionWizardAnswer({$oMerkmalWert->kMerkmalWert}, {$oAuswahlAssistentFrage->kAuswahlAssistentFrage}, {$nFrage}, {$kKategorie});" hidefocus="hidefocus">
                    {if $Einstellungen.auswahlassistent.auswahlassistent_anzeigeformat == "T"}
                        {$oMerkmalWert->cWert}{if $Einstellungen.auswahlassistent.auswahlassistent_anzahl_anzeigen == "Y"} <em class="count">({$oMerkmalWert->nAnzahl})</em>{/if}
                    {elseif $Einstellungen.auswahlassistent.auswahlassistent_anzeigeformat == "B"}
                        <img src="{$oMerkmalWert->cBildpfadKlein}" class="vmiddle" title="{$oMerkmalWert->cWert}" />
                    {elseif $Einstellungen.auswahlassistent.auswahlassistent_anzeigeformat == "BT"}
                        <img src="{$oMerkmalWert->cBildpfadKlein}" class="vmiddle" title="{$oMerkmalWert->cWert}" /> {$oMerkmalWert->cWert}{if $Einstellungen.auswahlassistent.auswahlassistent_anzahl_anzeigen == "Y"} <em class="count">({$oMerkmalWert->nAnzahl})</em>{/if}
                    {/if}
                        </a>
                    {/if}
                {/foreach}
                    {if $Einstellungen.auswahlassistent.auswahlassistent_anzeigeformat == "S"}
                        </select>
                    {/if}
                </span>
            {if $Einstellungen.auswahlassistent.auswahlassistent_anzeigeformat == "S"}
                    <button name="aaLosBTN" class="btn_select">{lang key="aaSelectBTN" section="global"}</button>
                </form>
            {/if}
            </div>
        </li>
    {/foreach}
    </ul>
    <script type="text/javascript">
        aaDeleteSelectBTN();
    </script>
{/if}    