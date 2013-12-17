{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}

{if isset($Artikel->oKonfig_arr) && $Artikel->oKonfig_arr|@count > 0}
<div id="article_configuration_js">
{include file="tpl_inc/artikel_konfigurator_js.tpl"}
</div>

<div id="article_configuration">
   <div id="config_wrapper">
      <p class="box_plain tright"><em>*</em> {lang key="mandatoryFields" section="global"}</p>
      {foreach from=$Artikel->oKonfig_arr item=oGruppe}
         {if $oGruppe->getItemCount() > 0}
            {assign var=oSprache value=$oGruppe->getSprache()}
            {assign var=cBildPfad value=$oGruppe->getBildPfad()}
            {assign var=kKonfiggruppe value=$oGruppe->getKonfiggruppe()}
            <div class="config_group">
               {if $cBildPfad|@count_characters > 0}
                  <div class="img">
                     <img src="{$oGruppe->getBildPfad()}" alt="{$oSprache->getName()}" id="img{$oGruppe->getKonfiggruppe()}" />
                  </div>
               {/if}
               <div class="group">
                  {assign var=nCmpKeys value=0}
                  {assign var=cCmpKeys value=""}
                  {foreach from=$oGruppe->oItem_arr item=oItem}
                     {assign var=oArtikel value=$oItem->getArtikel()}
                     {if $oArtikel}
                        {assign var=nCmpKeys value=$nCmpKeys+1}
                        {assign var=cCmpKeys value=$cCmpKeys|cat:$oArtikel->kArtikel|cat:";"|cat:$oItem->getKonfigitem()|cat:";"}
                     {/if}
                  {/foreach}
               
                  {if $nCmpKeys > 1 || $aKonfigerror_arr[$kKonfiggruppe]}
                     <div class="actions">
                        {if $aKonfigerror_arr[$kKonfiggruppe]}
                           <p class="error">{$aKonfigerror_arr[$kKonfiggruppe]}</p>
                        {else if $nCmpKeys > 1}
                           <a href="#" onclick="return showCompareList('{$cCmpKeys}', 0);">{lang key="compareList" section="comparelist"}</a>
                        {/if}
                     </div>
                  {/if}
               
                  <p class="title">
                     {$oSprache->getName()}{if $oGruppe->getMin() > 0}<em>*</em>{/if}
                  </p>
                  {if $oSprache->hatBeschreibung()}
                     <p class="desc">{$oSprache->getBeschreibung()}</p>
                  {/if}
                  
                  <div class="item_wrapper">
                     {foreach from=$oGruppe->oItem_arr item=oItem name=konfigitem}
                        {assign var=oArtikel value=$oItem->getArtikel()}
                        {assign var=kKonfigitem value=$oItem->getKonfigitem()}
                        {assign var=cBeschreibung value=$oItem->getBeschreibung()}
                        
                        {if $smarty.foreach.konfigitem.first}
                           {if $oGruppe->getAnzeigeTyp() == $KONFIG_ANZEIGE_TYP_DROPDOWN || $oGruppe->getAnzeigeTyp() == $KONFIG_ANZEIGE_TYP_DROPDOWN_MULTI}
                              <div class="item{if $aKonfigitemerror_arr[$kKonfigitem]} error{/if}">
                                 <select name="item[{$oGruppe->getKonfiggruppe()}][]" {if $oGruppe->getAnzeigeTyp() == $KONFIG_ANZEIGE_TYP_DROPDOWN_MULTI}multiple="multiple" size="4"{/if} ref="{$oGruppe->getKonfiggruppe()}">
                                 {if $oGruppe->getAnzeigeTyp() == $KONFIG_ANZEIGE_TYP_DROPDOWN}
                                    <option value="">{lang key="pleaseChoose"}</option>
                                 {/if}
                           {/if}
                        {/if}
                        
                        {if $oGruppe->getAnzeigeTyp() == $KONFIG_ANZEIGE_TYP_CHECKBOX || $oGruppe->getAnzeigeTyp() == $KONFIG_ANZEIGE_TYP_RADIO}
                           <div class="item{if $aKonfigitemerror_arr[$kKonfigitem]} error{/if}">
                              <label for="item{$oItem->getKonfigitem()}" id="label{$oItem->getKonfigitem()}" class="{if $cBeschreibung|strlen > 0}config_tooltip{/if}{if $oItem->getEmpfohlen()} recommended{/if}" ref="tooltip{$oItem->getKonfigitem()}">
                                 <input type="{if $oGruppe->getAnzeigeTyp() == $KONFIG_ANZEIGE_TYP_CHECKBOX}checkbox{else}radio{/if}" name="item[{$oGruppe->getKonfiggruppe()}][]" id="item{$oItem->getKonfigitem()}" value="{$oItem->getKonfigitem()}" {if $oItem->getSelektiert() && !$aKonfigerror_arr}checked="checked"{/if} />
                                 {if $oGruppe->getAnzeigeTyp() == $KONFIG_ANZEIGE_TYP_CHECKBOX}{$oItem->getInitial()}x {/if}{$oItem->getName()}
                                 <span class="price">
                                    {if $oItem->hasRabatt() && $oItem->showRabatt()}<span class="discount">{$oItem->getRabattLocalized()} {lang key="discount"}</span>{elseif $oItem->hasZuschlag() && $oItem->showZuschlag()}<span class="additional">{$oItem->getZuschlagLocalized()} {lang key="additionalCharge"}</span>{/if}{$oItem->getPreisLocalized()}
                                 </span>
                              </label>
                              {if $aKonfigitemerror_arr[$kKonfigitem]}<p class="box_error">{$aKonfigitemerror_arr[$kKonfigitem]}</p>{/if}
                              {if $cBeschreibung|strlen > 0}<div class="config_overlay" id="tooltip{$oItem->getKonfigitem()}">{$cBeschreibung}</div>{/if}
                           </div> 
                        {elseif $oGruppe->getAnzeigeTyp() == $KONFIG_ANZEIGE_TYP_DROPDOWN || $oGruppe->getAnzeigeTyp() == $KONFIG_ANZEIGE_TYP_DROPDOWN_MULTI}
                           <option value="{$oItem->getKonfigitem()}" id="item{$oItem->getKonfigitem()}" {if $oItem->getSelektiert() && !$aKonfigerror_arr}selected="selected"{/if}>
                              {if $oGruppe->getAnzeigeTyp() == $KONFIG_ANZEIGE_TYP_DROPDOWN_MULTI}{$oItem->getInitial()}x {/if}
                              {$oItem->getName()}
                              &nbsp;&nbsp;&nbsp;&nbsp;
                              {if $oItem->hasRabatt() && $oItem->showRabatt()}({$oItem->getRabattLocalized()} {lang key="discount"})&nbsp;{elseif $oItem->hasZuschlag() && $oItem->showZuschlag()}({$oItem->getZuschlagLocalized()} {lang key="additionalCharge"})&nbsp;{/if}
                              {$oItem->getPreisLocalized()}
                           </option>
                        {/if}
                        
                        {if $smarty.foreach.konfigitem.last}
                           {if $oGruppe->getAnzeigeTyp() == $KONFIG_ANZEIGE_TYP_DROPDOWN || $oGruppe->getAnzeigeTyp() == $KONFIG_ANZEIGE_TYP_DROPDOWN_MULTI}
                                 </select>
                                 {if $aKonfigitemerror_arr[$kKonfigitem]}<p class="box_error">{$aKonfigitemerror_arr[$kKonfigitem]}</p>{/if}
                              </div>
                           {/if}
                        {/if}
                     {/foreach}
                     
                     {if ($oGruppe->getAnzeigeTyp() == $KONFIG_ANZEIGE_TYP_RADIO || $oGruppe->getAnzeigeTyp() == $KONFIG_ANZEIGE_TYP_DROPDOWN)}
                        {if !$oGruppe->quantityEquals()}
                           <div class="quantity">
                              <label for="quantity{$oGruppe->getKonfiggruppe()}">{lang key="quantity" section="global"}:</label>
                              <input type="text" id="quantity{$oGruppe->getKonfiggruppe()}" name="quantity[{$oGruppe->getKonfiggruppe()}]" value="{$oGruppe->getInitQuantity()}" autocomplete="off" ref="{$oGruppe->getKonfiggruppe()}" />
                              <span class="change_quantity">
                                 <a href="#" onclick="return increaseQuantity('#quantity{$oGruppe->getKonfiggruppe()}', 0);">+</a>
                                 <a href="#" onclick="return decreaseQuantity('#quantity{$oGruppe->getKonfiggruppe()}', 0);">-</a>
                              </span>
                           </div>
                        {else}
                           <input type="hidden" id="quantity{$oGruppe->getKonfiggruppe()}" name="quantity[{$oGruppe->getKonfiggruppe()}]" value="{$oGruppe->getInitQuantity()}" ref="{$oGruppe->getKonfiggruppe()}" />
                        {/if}
                     {/if}
                  </div>
               </div>
            </div>
         {/if}
      {/foreach}
   </div>
</div>
{if $Artikel->inWarenkorbLegbar == 1 || ($Artikel->nErscheinendesProdukt == 1 && $Einstellungen.global.global_erscheinende_kaeuflich == "Y")}
   <fieldset class="article_buyfield">
      <div class="choose_quantity">
         <label for="quantity" class="quantity">
            <span>{lang key="quantity" section="global"}:</span>
            <span><input type="text" maxlength="6" onfocus="this.setAttribute('autocomplete', 'off');" id="quantity" class="quantity" name="anzahl" {if $Artikel->fAbnahmeintervall > 0}value="{$Artikel->fAbnahmeintervall}" onblur="javascript:gibAbnahmeIntervall(this, {$Artikel->fAbnahmeintervall});"{else}value="{if $fAnzahl}{$fAnzahl}{else}1{/if}"{/if} /></span>
            {if $Einstellungen.artikeldetails.artikeldetails_anzahl_pfeile == "Y" || ($Einstellungen.artikeldetails.artikeldetails_anzahl_pfeile == "I" && $Artikel->fAbnahmeintervall > 1)}
               <span class="change_quantity">
                  <a href="#" onclick="javascript:erhoeheArtikelAnzahl('quantity', {if $Artikel->fAbnahmeintervall > 1}true, {$Artikel->fAbnahmeintervall}{else}false, 0{/if});return false;">+</a>
                  <a href="#" onclick="javascript:erniedrigeArtikelAnzahl('quantity', {if $Artikel->fAbnahmeintervall > 1}true, {$Artikel->fAbnahmeintervall}{else}false, 0{/if});return false;">-</a>
               </span>
            {/if}
            <span class="quantity_unit">{$Artikel->cEinheit}</span>
         </label>
         <span>
            <button name="inWarenkorb" type="submit" value="{lang key="addToCart" section="global"}" class="submit">
               <span>
                  {if isset($kEditKonfig)}
                     {lang key="applyChanges" section="global"}
                  {else}
                     {lang key="addToCart" section="global"}
                  {/if}
               </span>
            </button>
         </span>
      </div>
   </fieldset>
   {if $Artikel->kVariKindArtikel > 0}
      <input type="hidden" name="a2" value="{$Artikel->kVariKindArtikel}" />
   {/if}
   {if isset($kEditKonfig)}
      <input type="hidden" name="kEditKonfig" value="{$kEditKonfig}" />
   {/if}
{/if}
{/if}