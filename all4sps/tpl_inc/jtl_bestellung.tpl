{**
* @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
* @author JTL-Software-GmbH (www.jtl-software.de)
*
* use is subject to license terms
* http://jtl-software.de/jtlshop3license.html
*}

<script type="text/javascript">
    if (top.location != self.location)
        top.location = self.location.href;
</script>

<div id="content">
    {include file='tpl_inc/inc_breadcrumb.tpl'}

    {if $cFehler}
        <div class="box_error">{$cFehler}</div>
    {/if} 

    {include file="tpl_inc/inc_extension.tpl"}

    <h1>{lang key="orderDetails" section="login"} {$Bestellung->cBestellNr} {lang key="from" section="login" alt_section="login,productDetails,productOverview,global,"} {$Bestellung->dErstelldatum_de}</h1>

    <div class="container form">
        <ul class="hlist autoheight">
            <li class="p50">
                <fieldset class="resize first">
                    <legend>{lang key="billingAdress" section="checkout"}</legend>
                    {include file='tpl_inc/inc_rechnungsadresse.tpl'}
                </fieldset>
            </li>
            <li class="p50">
                <fieldset class="resize last">
                    {if $Lieferadresse->kLieferadresse>0}
						<legend>{lang key="shippingAdress" section="checkout"}</legend>
                        {include file='tpl_inc/inc_lieferadresse.tpl'}
                    {else}
                        <legend>{lang key="shippingAdressEqualBillingAdress" section="account data"}</legend>
						{include file='tpl_inc/inc_rechnungsadresse.tpl'}
                    {/if}
                </fieldset>
            </li>
        </ul>
        </fieldset>
    </div>

    <div class="container">
        <ul class="hlist autoheight">
            <li class="p33">
                <div class="form">
                    <fieldset class="resize">
                        <legend>Status</legend>
                        {$Bestellung->Status}
                    </fieldset>
                </div>
            </li>
            <li class="p33">
                <div class="form middle">
                    <fieldset class="resize">
                        <legend>{lang key="paymentOptions" section="global"}: {$Bestellung->cZahlungsartName}</legend>
                        {if $Bestellung->cStatus>=3}
                            {if $Bestellung->dBezahldatum_de ne '00.00.0000'}
                                {lang key="payedOn" section="login"} {$Bestellung->dBezahldatum_de}
							{else}
								{lang key="notPayedYet" section="login"}
                            {/if}
                        {else}
							{if ($Bestellung->cStatus == 1 || $Bestellung->cStatus == 2) && ($Bestellung->Zahlungsart->cModulId != "za_ueberweisung_jtl" && $Bestellung->Zahlungsart->cModulId != "za_nachnahme_jtl" && $Bestellung->Zahlungsart->cModulId != "za_rechnung_jtl" && $Bestellung->Zahlungsart->cModulId != "za_barzahlung_jtl" && $Bestellung->Zahlungsart->cModulId != "za_billpay_jtl" || $Bestellung->Zahlungsart->bPayAgain)}
								<a href="bestellab_again.php?kBestellung={$Bestellung->kBestellung}">{lang key="payNow" section="global"}</a>
							{else}
								{lang key="notPayedYet" section="login"}
							{/if}
                        {/if}
                        </fieldset>
                    </div>
                </li>
                <li class="p33">
                    <div class="form">
                        <fieldset class="resize">
                            <legend>{lang key="shippingOptions" section="global"}: {$Bestellung->cVersandartName}</legend>
							{if $Bestellung->cStatus==4}
								{lang key="shippedOn" section="login"} {$Bestellung->dVersanddatum_de}
							{elseif $Bestellung->cStatus==5}
								{$Bestellung->Status}
							{else}
								{lang key="notShippedYet" section="login"}
							{/if}
                </fieldset>
            </div>
        </li>
    </ul>
</div>

<div class="container">
	<h2>{lang key="basket"}</h2>
    <table class="tiny basket" id="customerorder">
        <thead>
            <tr>
                <th>{lang key="product" section="global"}</th>
				<th class="tcenter">{lang key="shippingStatus" section="login"}</th>
                <th class="tcenter">{lang key="quantity" section="checkout"}</th>
                <th class="tright">{lang key="merchandiseValue" section="checkout"}</th>
				
            </tr>
        </thead>
        <tbody>
            {foreach name=positionen from=$Bestellung->Positionen item=Position}
                {if !($Position->cUnique|strlen > 0 && $Position->kKonfigitem > 0)}
                    <tr>
                        <td valign="top">
                            {include file="tpl_inc/jtl_bestellung_position.tpl" Position=$Position bPreis=true bKonfig=true}
                        </td>
						<td class="tcenter">
							{if $Position->nPosTyp == 1}
								{if $Position->bAusgeliefert}
									<span class="signal_image nopad tooltip a2" title="{lang key="statusShipped" section="order"}">&nbsp;</span>
								{elseif $Position->nAusgeliefert > 0}
									<span class="signal_image nopad tooltip a1" title="{if $Position->cUnique|strlen == 0}{lang key="statusShipped" section="order"}: {$Position->nAusgeliefertGesamt}{else}{lang key="statusPartialShipped" section="order"}{/if}">&nbsp;</span>
								{else}
									<span class="signal_image nopad tooltip a0" title="{lang key="notShippedYet" section="login"}">&nbsp;</span>
								{/if}
							{/if}
						</td>
                        <td width="50" class="tcenter" valign="middle">
                            {$Position->nAnzahl|replace_delim}
                        </td>
                        <td width="90" class="tright" valign="middle">
                            {if $Position->cUnique|strlen > 0 && $Position->kKonfigitem == 0}
                                <p>{$Position->cKonfigpreisLocalized[$NettoPreise]}</p>
                            {else}
                                <p>{$Position->cGesamtpreisLocalized[$NettoPreise]}</p>
                            {/if}
                        </td>
                    </tr>
                {/if}
            {/foreach}
        </tbody>
		<tfoot>
			{if $Bestellung->GuthabenNutzen == 1}
				<tr>
					
					<td colspan="3" class="tright"><span class="price_label">{lang key="voucher" section="global"}:</span></td>
					<td class="tright">{$Bestellung->GutscheinLocalized}</span></td>
				</tr>
			{/if}
			{if $NettoPreise}
				<tr>
					<td colspan="3" class="tright"><span class="price_label">{lang key="totalSum" section="global"}:</span></td>
					<td class="tright"><span>{$Bestellung->WarensummeLocalized[$NettoPreise]}</span></td>
				</tr>
			{/if} 
			<tr>
				<td colspan="3" class="tright"><span class="price_label">{lang key="totalSum" section="global"}{if $NettoPreise} {lang key="gross" section="global"}{/if}:</span></td>
				<td class="tright"><span class="price">{$Bestellung->WarensummeLocalized[0]}</span></td>
			</tr>
			{if $Einstellungen.global.global_steuerpos_anzeigen!="N"}
				{foreach name=steuerpositionen from=$Bestellung->Steuerpositionen item=Steuerposition}
					<tr>
						<td colspan="3" class="tright">{$Steuerposition->cName}</td>
						<td class="tright">{$Steuerposition->cPreisLocalized}</td>
					</tr>
				{/foreach}
			{/if}
		</tfoot>
    </table>

    {include file="tpl_inc/jtl_downloads.tpl"}
    {include file="tpl_inc/jtl_uploads.tpl"}
</div>

{if $Bestellung->oLieferschein_arr|@count > 0}
	<div class="container">
		<h2>{if $Bestellung->cStatus == '5'}{lang key="partialShipped" section="order"}{else}{lang key="shipped" section="order"}{/if}</h2>
		<table class="tiny basket">
		<thead>
			<tr>
				<th>{lang key="shippingOrder" section="order"}</th>
				<th class="tcenter">{lang key="shippedOn" section="login"}</th>
				<th class="tright" width="200">{lang key="packageTracking" section="order"}</th>
			</tr>
		</thead>
		<tbody>
		{foreach from=$Bestellung->oLieferschein_arr item="oLieferschein"}
			<tr>
				<td><a class="popup" id="{$oLieferschein->getLieferschein()}" href="#">{$oLieferschein->getLieferscheinNr()}</a></td>
				<td class="tcenter">{$oLieferschein->getErstellt()|date_format:"%d.%m.%Y %H:%M"}</td>
				<td class="tright">{foreach from=$oLieferschein->oVersand_arr name="versand" item="oVersand"}{if $oVersand->getIdentCode()}<p><a href="{$oVersand->getLogistikVarUrl()}" target="_blank" class="shipment tooltip" title="{$oVersand->getIdentCode()}">{lang key="packageTracking" section="order"}</a></p>{/if}{/foreach}</td>
			</tr>
		{/foreach}
		</tbody>
		</table>
	</div>
	
	{* Lieferschein Popups *}
	{foreach from=$Bestellung->oLieferschein_arr item="oLieferschein"}
		<div id="popup{$oLieferschein->getLieferschein()}" class="hidden">
			<div class="container tleft" style="width: 600px;">
				<h1>{lang key="partialShipped" section="order"}</h1>
				<div class="box_plain">
					<strong class="label">{lang key="shippingOrder" section="order"}</strong>: {$oLieferschein->getLieferscheinNr()}<br />
					<strong class="label">{lang key="shippedOn" section="login"}</strong>: {$oLieferschein->getErstellt()|date_format:"%d.%m.%Y %H:%M"}<br />
				</div>
                
                {if $oLieferschein->getHinweis()|@count_characters > 0}
                    <div class="box_info">
                        {$oLieferschein->getHinweis()}
                    </div>
                {/if}
				
				<div class="box_plain">
					{foreach from=$oLieferschein->oVersand_arr name="versand" item="oVersand"}{if $oVersand->getIdentCode()}<p><a href="{$oVersand->getLogistikVarUrl()}" target="_blank" class="shipment tooltip" title="{$oVersand->getIdentCode()}">{lang key="packageTracking" section="order"}</a></p>{/if}{/foreach}
				</div>
				
				<div class="box_plain">
					<table class="tiny basket">
						<thead>
							<tr>
								<th>{lang key="partialShippedPosition" section="order"}</th>
								<th class="tcenter" width="100">{lang key="partialShippedCount" section="order"}</th>
							</tr>
						</thead>
						<tbody>
							{foreach from=$oLieferschein->oLieferscheinPos_arr item=oLieferscheinpos}
								<tr>
									<td>{include file="tpl_inc/jtl_bestellung_position.tpl" Position=$oLieferscheinpos->oPosition bPreis=false bKonfig=false}</td>
									<td class="tcenter">{$oLieferscheinpos->getAnzahl()}</td>
								</tr>
							{/foreach}
						</tbody>
					</table>
				</div>
			</div>
		</div>
	{/foreach}
{/if}

{if $Bestellung->cKommentar}
    <div class="container form">
        <fieldset>
            <legend>{lang key="yourOrderComment" section="login"}</legend>
            <p>{$Bestellung->cKommentar}</p>
        </fieldset>
    </div>
{/if}

{if $oTrustedShopsBewertenButton->cPicURL|count_characters > 0}
    <div class="container">
        <a href="{$oTrustedShopsBewertenButton->cURL}" target="_blank"><img src="{$oTrustedShopsBewertenButton->cPicURL}" /></a>
    </div>
{/if}
{include file='tpl_inc/inc_seite.tpl'}
</div>