{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
{include file='tpl_inc/header.tpl'}

<script type="text/javascript">
{literal}
var check_active = false;
function check_position(id, value)
{
   if (check_active) return;
   if ($('#'+id).val() != value)
   {
      check_active = true;
      $('#box_refresh').slideDown('slow');
      setInterval(function() {
         if (!$('#btn_refresh').hasClass('active'))
            $('#btn_refresh').addClass('active');
         else
            $('#btn_refresh').removeClass('active');
      }, 800);
   }
}
{/literal}
</script>

<script type="text/javascript" src="{$PFAD_ART_ABNAHMEINTERVALL}artikel_abnahmeintervall.js"></script>

<form id="warenkorb_form" method="post" action="warenkorb.php" class="form">
   <div id="content">
   {include file='tpl_inc/inc_breadcrumb.tpl'}
   <div id="contentmid">
      <h2>{$Warenkorbtext}</h2>
      
      {if !$bCookieErlaubt}
      <div class="container box_error">
         <strong>{lang key="noCookieHeader" section="errorMessages"}</strong>
         <p>{lang key="noCookieDesc" section="errorMessages"}</p>
      </div>
      {/if}
      
      {include file="tpl_inc/inc_extension.tpl"}
      
      {if isset($WarenkorbVersandkostenfreiHinweis) && $WarenkorbVersandkostenfreiHinweis|@strlen > 0 && $Warenkorb->PositionenArr|@count > 0}
         <p class="box_info">
            <span title="{$WarenkorbVersandkostenfreiLaenderHinweis}" class="basket_notice">{$WarenkorbVersandkostenfreiHinweis}</span>
         </p>
      {/if}
      
      {if ($Warenkorb->PositionenArr|@count > 0)}
         {*<p class="box_info hidden" id="box_refresh">{lang key="refreshBasket" section="checkout"}</p>*}
      
         {if count($Warenkorbhinweise)>0}
            <div class="box_error">
               {foreach name=hinweise from=$Warenkorbhinweise item=Warenkorbhinweis}
                  {$Warenkorbhinweis}<br />
               {/foreach}
            </div>
         {/if}

         {if $BestellmengeHinweis|count_characters > 0}
            <div class="box_error">{$BestellmengeHinweis}</div>
         {/if}

         {if $MsgWarning|@count_characters > 0}
            <p class="box_error">{$MsgWarning}</p>
         {/if}

         {if $KuponcodeUngueltig}
            <p class="box_error">{lang key="invalidCouponCode" section="checkout"}</p>
         {/if}
         {if $nVersandfreiKuponGueltig}
            <p class="box_error">
               {lang key="couponSucc1" section="global"}
               {foreach name=lieferlaender from=$cVersandfreiKuponLieferlaender_arr item=cVersandfreiKuponLieferlaender}
                  {$cVersandfreiKuponLieferlaender}{if !$smarty.foreach.lieferlaender.last}, {/if}
               {/foreach}
            </p>
         {/if}

         <div class="basket_wrapper">
            <input type="hidden" name="wka" value="1" />
            <input type="hidden" name="{$session_name}" value="{$session_id}" />

            <table class="tiny basket">
               <thead>
                  <tr>
                     <th>{lang key="product" section="global"}</th>
                     <th></th>
                     <th></th>
                     <th class="tcenter">{lang key="quantity" section="global"}</th>
                     <th class="tright">{lang key="price" section="global"}</th>

                  </tr>
               </thead>
               <tbody>
                  {foreach name=positionen from=$Warenkorb->PositionenArr item=oPosition}
                     {if !$oPosition->istKonfigKind()}
                        <tr class="{if $smarty.foreach.positionen.index % 2 == 0}row0{else}row1{/if}">
                           <td class="img">
                              {if $oPosition->Artikel->cVorschaubild|@strlen > 0}
                              <a href="{$oPosition->Artikel->cURL}" title="{$oPosition->cName[$smarty.session.cISOSprache]}">
                                 <img src="{$oPosition->Artikel->cVorschaubild}" alt="{$oPosition->cName[$smarty.session.cISOSprache]}" width="60" class="image" />
                              </a>
                              {/if}
                           </td>
                           
                           <td>
                              <div class="box_plain">
                              {if $oPosition->nPosTyp == $C_WARENKORBPOS_TYP_ARTIKEL}
                                 <p style="font-size:1.1em;line-height:1.6em">
                                    <a href="{$oPosition->Artikel->cURL}" title="{$oPosition->cName[$smarty.session.cISOSprache]}">{$oPosition->cName[$smarty.session.cISOSprache]}</a>
                                 </p>
                                 <p style="color:#666">&bull; {lang key="productNo" section="global"}: {$oPosition->Artikel->cArtNr}</p>
                                 {if isset($oPosition->Artikel->dMHD) && isset($oPosition->Artikel->dMHD_de)}
				                     <p style="color:#666" title="{lang key='productMHDTool' section='global'}" class="best-before">&bull; {lang key="productMHD" section="global"}: {$oPosition->Artikel->dMHD_de}</p>
				                 {/if}
                                 {if $Einstellungen.kaufabwicklung.bestellvorgang_einzelpreise_anzeigen=="Y" && !$oPosition->istKonfigVater()}
                                    <p style="color:#666">&bull; {lang key="pricePerUnit" section="productDetails"}: {$oPosition->cEinzelpreisLocalized[$NettoPreise][$smarty.session.cWaehrungName]}</p>
                                 {/if}                                 
                              {else}
                                 <p>{$oPosition->cName[$smarty.session.cISOSprache]}</p>
                              {/if}
                              {if $oPosition->Artikel->cLocalizedVPE}
                                 <p class="base_price" style="color:#666">&bull; {lang key="basePrice" section="global"}: {$oPosition->Artikel->cLocalizedVPE[$NettoPreise]}</p>
                              {/if}
                              </div>
                              {if $oPosition->istKonfigVater()}
                                 <div class="config">
                                    <ul class="children">
                                    {foreach from=$Warenkorb->PositionenArr item=KonfigPos name=konfigposition}
                                       {if $oPosition->cUnique == $KonfigPos->cUnique && $KonfigPos->kKonfigitem > 0}
                                          <li>
                                             <p class="qty">{if !$KonfigPos->istKonfigVater()}{$KonfigPos->nAnzahlEinzel}{else}1{/if}x</p> 
                                             <p>{$KonfigPos->cName[$smarty.session.cISOSprache]} &raquo;
                                                <span class="price_value">{$KonfigPos->cEinzelpreisLocalized[$NettoPreise][$smarty.session.cWaehrungName]}</span>
                                             </p>
                                          </li>
                                          {if $KonfigPos->kKonfigitem > 0}
                                             <input name="anzahl[{$smarty.foreach.konfigposition.index}]" type="hidden" value="{$KonfigPos->nAnzahl}" />
                                          {/if}
                                       {/if}
                                    {/foreach}
                                    </ul>
                                 </div>
                              {/if}
                              <div class="actions">
                                 {if $oPosition->nPosTyp == $C_WARENKORBPOS_TYP_ARTIKEL}
                                    <a class="droppos" href="warenkorb.php?dropPos={$smarty.foreach.positionen.index}">{lang key="delete" section="global"}</a>
                                 {/if}
                                 {if $oPosition->istKonfigVater()}
                                    <a class="configurepos" href="index.php?a={$oPosition->kArtikel}&ek={$smarty.foreach.positionen.index}">{lang key="configure" section="global"}</a>
                                 {/if}
                              </div>
                           </td>
                           
                           <td>
                              {if ($oPosition->Artikel->nIstVater == 1 || $oPosition->Artikel->kVaterArtikel > 0 && $Einstellungen.kaufabwicklung.warenkorb_varianten_varikombi_anzeigen == "Y") || ($oPosition->Artikel->nIstVater == 0 && $oPosition->Artikel->kVaterArtikel == 0)}
                                 {foreach name=variationen from=$oPosition->WarenkorbPosEigenschaftArr item=Variation}
                                    <p>{$Variation->cEigenschaftName[$smarty.session.cISOSprache]}: <strong>{$Variation->cEigenschaftWertName[$smarty.session.cISOSprache]}</strong></p>
                                 {/foreach}
                              {/if}
                              {if $Einstellungen.kaufabwicklung.bestellvorgang_lieferstatus_anzeigen=="Y" && $oPosition->cLieferstatus[$smarty.session.cISOSprache]}
                                 <p>{lang key="shippingTime" section="global"}: <strong>{$oPosition->cLieferstatus[$smarty.session.cISOSprache]}</strong></p>
                              {/if}
                              {if $oPosition->cHinweis|strlen > 0}
                                 <p>{$oPosition->cHinweis}</p>
                              {/if}
                           </td>
                           
                           <td class="tcenter qty">                    
                              {if $oPosition->istKonfigVater()}
                                 {$oPosition->nAnzahl}
                                 <input name="anzahl[{$smarty.foreach.positionen.index}]" type="hidden" value="{$oPosition->nAnzahl}" />
                              {else}
                                 {if $oPosition->nPosTyp == $C_WARENKORBPOS_TYP_ARTIKEL}
                                 
                                    {* old version *}
                                    {* <input type="text" name="anzahl[{$smarty.foreach.positionen.index}]" class="count" autocomplete="off" value="{if $oPosition->Artikel->cTeilbar == "Y"}{$oPosition->nAnzahl|replace_delim}{else}{"%d"|sprintf:$oPosition->nAnzahl}{/if}" id="count{$oPosition->Artikel->kArtikel}" onkeyup="javascript:check_position('count{$oPosition->Artikel->kArtikel}', '{if $oPosition->Artikel->cTeilbar == "Y"}{$oPosition->nAnzahl}{else}{"%d"|sprintf:$oPosition->nAnzahl}{/if}');"{if $oPosition->Artikel->fAbnahmeintervall > 1} onblur="javascript:gibAbnahmeIntervall(this, {$oPosition->Artikel->fAbnahmeintervall});"{/if} /> *}
                                    
                                    {* new version *}
                                    <select name="anzahl[{$smarty.foreach.positionen.index}]" class="quantity_sel" ref="{$smarty.foreach.positionen.index}">
                                       {assign var=selected value=false}
                                       {section name=anzahl start=1 loop=11}
                                          {assign var=fAnzahl value=$smarty.section.anzahl.index}
                                          
                                          {if $smarty.section.anzahl.last && !$selected}
                                             {assign var=fAnzahl value=$oPosition->nAnzahl}
                                          {/if}
                                          
                                          {if $oPosition->nAnzahl == $fAnzahl}
                                             {assign var=selected value=true}
                                          {/if}
                                          
                                          <option value="{$fAnzahl}" {if $smarty.section.anzahl.last}id="quantity_lst{$smarty.foreach.positionen.index}"{/if} {if $oPosition->nAnzahl == $fAnzahl}selected="selected"{/if}>{$fAnzahl}</option>
                                       {/section}
                                          <option value="0" id="quantity_opt{$smarty.foreach.positionen.index}">{lang key="more"}...</option>
                                    </select>
                                    
                                 {elseif $oPosition->nPosTyp == $C_WARENKORBPOS_TYP_GRATISGESCHENK}
                                    <input name="anzahl[{$smarty.foreach.positionen.index}]" type="hidden" value="1" />
                                 {/if}
                              {/if}
                              {$oPosition->Artikel->cEinheit}
                           </td>
                           
                           <td class="tright price">
                              <p class="price_overall">
                              {if $oPosition->istKonfigVater()}
                                 {$oPosition->cKonfigpreisLocalized[$NettoPreise][$smarty.session.cWaehrungName]}
                              {else}
                                 {$oPosition->cGesamtpreisLocalized[$NettoPreise][$smarty.session.cWaehrungName]}
                              {/if}
                              </p>
                           </td>
                        </tr>
                     {/if}
                  {/foreach}
               </tbody>
            </table>
            
            <div id="basket_price_wrapper" class="clearall">
            
               <div class="info_base">
                  {*<button type="submit" class="refresh" id="btn_refresh"><span>{lang key="refresh" section="checkout"}</span></button>*}
               </div>
               
               <div class="total_amount">
                  <table>
                     <tr>
                        <td><span class="price_label">{lang key="totalSum" section="global"}{*lang key="gross" section="global"*}:</span></td>
                        <td><span class="price_value">{$WarensummeLocalized[0]}</span></td>
                     </tr>
                     {if $NettoPreise}
                        <tr>
                           <td><span class="tax_label">{lang key="totalSum" section="global"}:</span></td>
                           <td><span class="tax_label">{$WarensummeLocalized[$NettoPreise]}</span></td>
                        </tr>
                     {/if}
                     {if $Einstellungen.global.global_steuerpos_anzeigen != "N" && $Steuerpositionen|@count > 0}
                        {foreach name=steuerpositionen from=$Steuerpositionen item=Steuerposition}
                           <tr>
                              <td><span class="tax_label">{$Steuerposition->cName}:</span></td>
                              <td><span class="tax_label">{$Steuerposition->cPreisLocalized}</span></td>
                           </tr>
                        {/foreach}
                     {/if}
                  </table>
               </div>
            </div>
            
            {if $Schnellkaufhinweis}
               <p class="box_info">{$Schnellkaufhinweis}</p>
            {/if}
         
            <!-- uploads -->
            {include file="tpl_inc/artikel_uploads.tpl"}
               
            <div id="basket_checkout" class="tright">
               <a href="bestellvorgang.php?wk=1{$SID}" class="submit">{lang key="nextStepCheckout" section="checkout"}</a>
            </div>
            
            {if $Einstellungen.kaufabwicklung.warenkorb_kupon_anzeigen=="Y" && $KuponMoeglich==1}
               <div id="coupon" class="container">
                  <fieldset>
                     <legend>{lang key="useCoupon" section="checkout"}</legend>
                     <label for="couponCode">{lang key="couponCode" section="account data"}</label>
                     <input type="text" name="Kuponcode" id="couponCode" maxlength="20" /> 
                     <input type="submit" value="{lang key="useCoupon" section="checkout"}" />
                  </fieldset>
               </div>
            {/if}

            <!-- versand ermitteln -->
            {if $Einstellungen.kaufabwicklung.warenkorb_versandermittlung_anzeigen=="Y"}
            <fieldset>
               {if !$Versandarten}
                  <legend>{lang key="estimateShippingCostsTo" section="checkout"}</legend>
                  <ul class="input_block">
                     <li><label for="country">{lang key="country" section="account data"}</label>
                        <select name="land" id="country">
                        {foreach name=land from=$laender item=land}
                        <option value="{$land->cISO}" {if ($Einstellungen.kunden.kundenregistrierung_standardland==$land->cISO && !$smarty.session.Kunde->cLand) || $smarty.session.Kunde->cLand==$land->cISO}selected{/if}>{$land->cName}</option>
                        {/foreach}
                        </select>
                     </li>
                     <li>
                        <label for="plz">{lang key="plz" section="forgot password" alt_section="account data,"}</label>
                        <input type="text" name="plz" maxlength="20" value="{$smarty.session.Kunde->cPLZ}" id="plz" />
                        <input name="versandrechnerBTN" type="submit" value="{lang key="estimateShipping" section="checkout"}" />               
                     </li>              
                  </ul>
               {else}
                  <legend>{lang key="estimateShippingCostsTo" section="checkout"} {$Versandland}, {lang key="plz" section="forgot password"}: {$VersandPLZ}</legend>
                  {if count($ArtikelabhaengigeVersandarten)>0}
                     <table width="80%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                           <td colspan="2">{lang key="productShippingDesc" section="checkout"}:</td>
                        </tr>
                        {foreach name=artikelversandliste from=$ArtikelabhaengigeVersandarten item=artikelversand}
                        <tr>
                           <td align="left" valign="top">
                              {$artikelversand->cName[$smarty.session.cISOSprache]}
                           </td>
                           <td align="right" valign="top" width="100">
                              <strong>{$artikelversand->cPreisLocalized}</strong>
                           </td>
                        </tr>
                        {/foreach}
                     </table>
                  {/if}
                  
                  {if count($Versandarten) > 0}
                     <div class="box_plain">
                        <table width="80%" border="0" cellspacing="0" cellpadding="0">
                           {foreach name=versand from=$Versandarten item=versandart}
                           <tr id="shipment_{$versandart->kVersandart}">
                              <td align="left" valign="top">
                                 {if $versandart->cBild}
                                    <img src="{$versandart->cBild}" alt="{$versandart->angezeigterName[$smarty.session.cISOSprache]}">
                                 {else}
                                    {$versandart->angezeigterName[$smarty.session.cISOSprache]}
                                 {/if}
                                 {if $versandart->Zuschlag->fZuschlag!=0}
                                    <p><small>{$versandart->Zuschlag->angezeigterName[$smarty.session.cISOSprache]} (+{$versandart->Zuschlag->cPreisLocalized})</small></p>
                                 {/if}
                                 {if $versandart->cLieferdauer[$smarty.session.cISOSprache] && $Einstellungen.global.global_versandermittlung_lieferdauer_anzeigen == "Y"}
                                    <p><small>{lang key="shippingTimeLP" section="global"}: {$versandart->cLieferdauer[$smarty.session.cISOSprache]}</small></p>
                                 {/if}
                              </td>
                              <td align="right" valign="top" width="100">
                                 <strong>{$versandart->cPreisLocalized}</strong>
                              </td>
                           </tr>
                           {/foreach}
                        </table>
                     </div>
                     <a href="warenkorb.php?{$SID}">{lang key="newEstimation" section="checkout"}</a>
                  {else}
                     {lang key="noShippingAvailable" section="checkout"}
                  {/if}
               {/if}
               {if isset($cErrorVersandkosten) && $cErrorVersandkosten|count_characters > 0}
                  <p class="box_info">{$cErrorVersandkosten}</p>
               {/if}
            </fieldset>         
            {/if}
            <!-- // versand ermitteln -->

            <!-- gratisgeschenk -->
            {if $oArtikelGeschenk_arr|@count > 0}
            <div id="freegift" class="container">
               <form method="post" name="freegift" action="warenkorb.php">
                  <h1 class="underline">{lang key="freeGiftFromOrderValueBasket" section="global"}</h1>
                  <ul class="hlist articles">
                     {foreach name=gratisgeschenke from=$oArtikelGeschenk_arr item=oArtikelGeschenk}
                     <li class="p33 tcenter {if $smarty.foreach.gratisgeschenke.index % 3 == 0}clear{/if}">
                        <div>
                           <label for="gift{$oArtikelGeschenk->kArtikel}">
                              <img src="{$oArtikelGeschenk->Bilder[0]->cPfadKlein}" class="image" />
                              <p class="small">{lang key="freeGiftFrom1" section="global"} {$oArtikelGeschenk->cBestellwert} {lang key="freeGiftFrom2" section="global"}</p>
                              <p>{$oArtikelGeschenk->cName}<p>
                           </label>
                           <input name="gratisgeschenk" type="radio" value="{$oArtikelGeschenk->kArtikel}" id="gift{$oArtikelGeschenk->kArtikel}" />
                        </div>
                     </li>
                     {/foreach}
                     <li class="p100 tcenter clear">
                        <input type="hidden" name="{$session_name}" value="{$session_id}" />
                        <input type="hidden" name="gratis_geschenk" value="1" />
                        <input name="gratishinzufuegen" type="submit" value="{lang key="addToCart" section="global"}" class="submit" />
                     </li>
                  </ul>
               </form>
            </div>
            {/if}
            <!-- // gratisgeschenk -->

            <!-- xselling -->
            {if $xselling->Kauf && count($xselling->Kauf->Artikel) > 0}
            <div id="xselling" class="container">
               <h1 class="underline">{lang key="basketCustomerWhoBoughtXBoughtAlsoY" section="global"}</h1>
               <ul class="hlist articles">
               {foreach name=Xsell_artikel from=$xselling->Kauf->Artikel item=ArtikelXsell}
               <li class="p33 tcenter {if $smarty.foreach.Xsell_artikel.index % 3 == 0}clear{/if}">
                  <div>
                     <p><a href="{$ArtikelXsell->cURL}"><img alt="{$ArtikelXsell->cName}" src="{$ArtikelXsell->cVorschaubild}" class="image"></a></p>
                     <p><a href="{$ArtikelXsell->cURL}">{$ArtikelXsell->cName}</a></p>
                     <p>{lang key="only" section="global"} {if $ArtikelXsell->Preise->fVKNetto==0 && $Einstellungen.global.global_preis0=="N"}{lang key="priceOnApplication" section="global"}{else}<span class="price">{$ArtikelXsell->Preise->cVKLocalized[$NettoPreise]}</span>{/if}</p>
                     {if $ArtikelXsell->cLocalizedVPE}
                        <p><b><small>{lang key="basePrice" section="global"}:</b> {$ArtikelXsell->cLocalizedVPE[$NettoPreise]}</small></p>
                     {/if}
                     <p><span class="vat_info">{$ArtikelXsell->cMwstVersandText}</span></p>
                  </div>
               </li>
               {/foreach}
               </ul>
            </div>
            {/if}
            <!-- // xselling -->
         </div>
         {else}
            <a href="{$ShopURL}" class="submit">{lang key="continueShopping" section="checkout"}</a>
         {/if}
   </div>
   {include file='tpl_inc/inc_seite.tpl'}
   </div>
</form>
{include file='tpl_inc/footer.tpl'}