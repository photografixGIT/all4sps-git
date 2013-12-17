{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
    {if $hinweis}
        <br>
        <div class="box_info">
            {$hinweis}
        </div>
    {/if}
    {if $fehler}
        <br>
        <div class="box_error">
            {$fehler}
        </div>
    {/if}
    <br>

{if isset($Einstellungen.global.global_versandermittlung_anzeigen) && $Einstellungen.global.global_versandermittlung_anzeigen == "Y" && isset($smarty.session.Warenkorb->PositionenArr) && $smarty.session.Warenkorb->PositionenArr|@count > 0}
    <form method="post" action="navi.php{if $bExclusive}?exclusive_content=1{/if}">
    <input type="hidden" name="{$session_name}" value="{$session_id}">
    <input type="hidden" name="s" value="{$Link->kLink}">
    <br>
    <table width="100%" border="0" cellspacing="0" cellpadding="5" style="height: 25px; border-color:#929292;border-width:1px; border-style:dotted;border-right-width:0px;border-left-width:0px;background: #F2F2F4">
    {if !isset($Versandarten)}
      <tr>
         <td>{if $MsgWarning|count_characters > 0}<p class="box_error">{$MsgWarning}</p>{/if}</td>
      </tr>
        <tr><td style="font-weight:bold;"><b>{lang key="estimateShippingCostsTo" section="checkout"}</b></td></tr>
        <tr>
            <td>
                <select name="land">        
                {foreach name=land from=$laender item=land}
                        <option value="{$land->cISO}" {if ($Einstellungen.kunden.kundenregistrierung_standardland==$land->cISO && !$smarty.session.Kunde->cLand) || $smarty.session.Kunde->cLand==$land->cISO}selected{/if}>{$land->cName}</option>
                {/foreach}
                </select>
                <span class="standard" style="padding-left:10px;"><b>{lang key="plz" section="forgot password" alt_section="account data,"}:</b></span>
                <input type="text" name="plz" maxlength="20" class="login" style="width:50px;" value="{$smarty.session.Kunde->cPLZ}"> 
                &nbsp;&nbsp;&nbsp;<input type="submit" value="{lang key="estimateShipping" section="checkout"}" class="button">
            </td>
        </tr>
    {else}
        <tr><td style="font-weight:bold;"><b>{lang key="estimateShippingCostsTo" section="checkout"} {$Versandland}, {lang key="plz" section="forgot password" alt_section="account data,"} {$VersandPLZ}</b></td></tr>
        <tr>
            <td>
            {if isset($ArtikelabhaengigeVersandarten) && $ArtikelabhaengigeVersandarten|@count > 0}
                <table width="80%" border="0" cellspacing="0" cellpadding="5">
                <tr>
                    <td colspan="2">{lang key="productShippingDesc" section="checkout"}:</td>
                </tr>
                {foreach name=artikelversandliste from=$ArtikelabhaengigeVersandarten item=artikelversand}
                    <tr>
                            <td align="left" class="standard" valign="top">
                            {$artikelversand->cName[$smarty.session.cISOSprache]}
                            </td>
                            <td align="left" class="standard" valign="top" width="100">
                                    <strong>{$artikelversand->cPreisLocalized}</strong>
                            </td>
                    </tr>
                {/foreach}
                </table>
            {/if}
            {if isset($Versandarten) && $Versandarten|@count > 0}
                <table width="80%" border="0" cellspacing="0" cellpadding="5">
                {foreach name=versand from=$Versandarten item=versandart}
                    <tr>
                            <td align="left" class="standard" valign="top">
                            {if $versandart->cBild}<img src="{$versandart->cBild}" alt="{$versandart->angezeigterName[$smarty.session.cISOSprache]}">{else}{$versandart->angezeigterName[$smarty.session.cISOSprache]}{/if}
                                                                                                                                    
                    {if $versandart->Zuschlag->fZuschlag!=0}
                    <br><span class="small">{$versandart->Zuschlag->angezeigterName[$smarty.session.cISOSprache]} (+{$versandart->Zuschlag->cPreisLocalized})</span>
                    {/if}
                    {if $versandart->cLieferdauer[$smarty.session.cISOSprache] && $Einstellungen.global.global_versandermittlung_lieferdauer_anzeigen == "Y"}
                    <br><span class="small">{lang key="shippingTimeLP" section="global"}: {$versandart->cLieferdauer[$smarty.session.cISOSprache]}</span>
                    {/if}
                            </td>
                            <td align="left" class="standard" valign="top" width="100">
                                    <strong>{$versandart->cPreisLocalized}</strong>
                            </td>
                    </tr>
                {/foreach}
                </table>
                <a href="navi.php?s={$Link->kLink}&{$SID}">{lang key="newEstimation" section="checkout"}</a>
            {else}
            {lang key="noShippingAvailable" section="checkout"}
            {/if}
            </td>
        </tr>
    {/if}
    </table>
    </form>
{else}
    {lang key="estimateShippingCostsNote" section="global"}
{/if}