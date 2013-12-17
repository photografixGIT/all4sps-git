{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}

{if isset($Artikel->oKonfig_arr) && $Artikel->oKonfig_arr|@count > 0}
<div id="article_configuration_js">
{include file="tpl_inc/artikel_konfigurator_slider_js.tpl"}
</div>

<div id="article_configuration">
   <div id="config_slider_wrapper">
      {foreach from=$Artikel->oKonfig_arr item=oGruppe}
         {if $oGruppe->getItemCount() > 0}
            {assign var=oSprache value=$oGruppe->getSprache()}
            {assign var=kKonfiggruppe value=$oGruppe->getKonfiggruppe()}

            {if $aKonfigerror_arr[$kKonfiggruppe]}
               <p class="box_error">
                  {$aKonfigerror_arr[$kKonfiggruppe]}
               </p>
            {/if}
            
            <div class="item_wrapper">
               {foreach from=$oGruppe->oItem_arr item=oItem name=konfigitem}
                  {assign var=oArtikel value=$oItem->getArtikel()}
                  {assign var=kKonfigitem value=$oItem->getKonfigitem()}
                  {assign var=cBeschreibung value=$oItem->getBeschreibung()}
                  {assign var=oBildPfad value=$oItem->getBildPfad()}

                  <div id="item_box{$kKonfigitem}" class="item{if $aKonfigitemerror_arr[$kKonfigitem]} error{/if} clearall">
                  
                     <div class="img">
                        <img src="{$oBildPfad->cPfadKlein}" alt="{$oItem->getName()}" />
                     </div>
                     
                     <div class="desc clearall">
                     
                        <div class="slider">
                           <div class="clearall">
                              <h2>{$oItem->getName()}</h2>
                              <h2 class="slider_value" id="slider_value{$kKonfigitem}">0%</h2>
                           </div>
                           <div id="slider{$kKonfigitem}">
                              <div class="ui-slider-active"></div>
                           </div>
                           
                           <input class="hidden" type="checkbox" name="item[{$oGruppe->getKonfiggruppe()}][]" id="item{$oItem->getKonfigitem()}" value="{$oItem->getKonfigitem()}" {if $oItem->getSelektiert() && !$aKonfigerror_arr}checked="checked"{/if} />
                           <input class="hidden" type="hidden" name="item_quantity[{$oItem->getKonfigitem()}]" id="item_quantity{$oItem->getKonfigitem()}" value="0" />
                           
                        </div>
                        
                        <div class="info">
                           {if $oArtikel->cLocalizedVPE}
                              <p class="price_base">{$oArtikel->cLocalizedVPE[$NettoPreise]}</p>
                           {/if}
                           {if $cBeschreibung|@strlen > 0}
                              <p class="comp_desc">{$cBeschreibung}</p>
                           {/if}
                        </div>
                        
                     </div>
                     
                  </div> 
               {/foreach}
            </div>
         {/if}
      {/foreach}
   </div>
   <input type="hidden" name="konfig_ignore_limits" value="1" />
</div>

{if $Artikel->inWarenkorbLegbar == 1 || ($Artikel->nErscheinendesProdukt == 1 && $Einstellungen.global.global_erscheinende_kaeuflich == "Y")}
   <fieldset class="article_buyfield" id="article_buyfield_slider">
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