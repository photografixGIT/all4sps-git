{******************************************************************
* JTL-Shop 3
* Template: JTL-Shop3 Tiny
*
* Author: JTL-Software, andreas.juetten@jtl-software.de
* http://www.jtl-software.de
*
* Copyright (c) 2010 JTL-Software
*****************************************************************}

<table class="tiny positions box_plain">
   <thead>
      <tr>
         <th colspan="2">{lang key="product" section="checkout"} <a href="warenkorb.php" class="button_edit">{lang key="modifyBasket" section="checkout"}</a></th>
         <th class="tcenter">{lang key="quantity" section="checkout"}</th>
         {if $Einstellungen.kaufabwicklung.bestellvorgang_einzelpreise_anzeigen=="Y"}
            <th class="tright">{lang key="pricePerUnit" section="checkout"}</th>
         {/if}
         <th class="tright">{lang key="merchandiseValue" section="checkout"}</th>
      </tr>
   </thead>
   <tbody>
      {foreach name=positionen from=$smarty.session.Warenkorb->PositionenArr item=Position}
         {if !$Position->istKonfigKind()}
            <tr class="type_{$Position->nPosTyp}">
               <td class="img">
                  {if $Position->Artikel->cVorschaubild|@strlen > 0}
                     <a href="{$Position->Artikel->cURL}" title="{$Position->cName[$smarty.session.cISOSprache]}"{if $Einstellungen.template.articleoverview.article_image_preview == 'Y'} class="image_preview" ref="{$Position->Artikel->Bilder[0]->cPfadNormal}"{/if}>
                        <img src="{$Position->Artikel->cVorschaubild}" alt="{$Position->cName[$smarty.session.cISOSprache]}" width="60" class="image" />
                     </a>
                  {/if}
               </td>
               <td valign="top">
               {if $Position->nPosTyp == $C_WARENKORBPOS_TYP_ARTIKEL}
                  <a href="{$Position->Artikel->cURL}" title="{$Position->cName[$smarty.session.cISOSprache]}">{$Position->cName[$smarty.session.cISOSprache]}</a>
                  
                  {*<p><small>{lang key="productNo" section="global"}: {$Position->Artikel->cArtNr}</small></p>*}
                  
                  {if isset($Position->Artikel->dMHD) && isset($Position->Artikel->dMHD_de)}
                      <p title="{lang key='productMHDTool' section='global'}" class="best-before"><small>{lang key="productMHD" section="global"}: {$Position->Artikel->dMHD_de}</small></p>
                  {/if}

                  {if $Position->Artikel->cLocalizedVPE}
                     <p><small><b>{lang key="basePrice" section="global"}:</b> {$Position->Artikel->cLocalizedVPE[$NettoPreise]}</small></p>
                  {/if}

                  {if $Position->Artikel->dErscheinungsdatum != "0000-00-00" && $Position->Artikel->nErscheinendesProdukt == 1}
                     <p><small>{lang key="dateOfIssue" section="global"} {if $smarty.session.cISOSprache == "ger"}{$Position->Artikel->Erscheinungsdatum_de}{else}{$Position->Artikel->dErscheinungsdatum}{/if}</small></p>
                  {/if}

                  {if $Position->cHinweis|strlen > 0}
                     <p><small>{$Position->cHinweis}</small></p>
                  {/if}

                  {if $Einstellungen.kaufabwicklung.bestellvorgang_lieferstatus_anzeigen=="Y" && $Position->cLieferstatus[$smarty.session.cISOSprache]}
                     <p><small><strong>{lang key="shippingTime" section="global"}:</strong> {$Position->cLieferstatus[$smarty.session.cISOSprache]}</small></p>
                  {/if}

                  {foreach name=variationen from=$Position->WarenkorbPosEigenschaftArr item=Variation}
                     <p><small><strong>{$Variation->cEigenschaftName[$smarty.session.cISOSprache]}:</strong> {$Variation->cEigenschaftWertName[$smarty.session.cISOSprache]}</small></p>
                  {/foreach}
                  
                  {if $Position->istKonfigVater()}
                     <ul class="children_ex">
                     {foreach from=$smarty.session.Warenkorb->PositionenArr item=KonfigPos}
                        {if $Position->cUnique == $KonfigPos->cUnique && $KonfigPos->kKonfigitem > 0}
                           <li>{if !($KonfigPos->cUnique|strlen > 0 && $KonfigPos->kKonfigitem == 0)}{$KonfigPos->nAnzahlEinzel}x {/if}{$KonfigPos->cName[$smarty.session.cISOSprache]} <span class="price">{$KonfigPos->cEinzelpreisLocalized[$NettoPreise][$smarty.session.cWaehrungName]}</span></li>
                        {/if}
                     {/foreach}
                     </ul>
                  {/if}
                  
                  
                  {* Buttonlösung eindeutige Merkmale *}
                  
                  {if $Position->Artikel->cHersteller}
                       <small>
                          <ul class="attributes">
                             <li>
                                <strong class="label">{lang key="manufacturer" section="productDetails"}</strong>: 
                                <span class="values">
                                   {$Position->Artikel->cHersteller}
                                </span>
                             </li>
                          </ul>
                       </small>
                  {/if}
                  
                  {if $Einstellungen.kaufabwicklung.bestellvorgang_artikelmerkmale == 'Y'}
                     {if $Position->Artikel->oMerkmale_arr}
                        <small>
                           <ul class="attributes">
                              {foreach from=$Position->Artikel->oMerkmale_arr item="oMerkmale_arr"}
                              <li>
                                 <strong class="label">{$oMerkmale_arr->cName}</strong>:
                                 <span class="values">
                                    {foreach name="merkmalwerte" from=$oMerkmale_arr->oMerkmalWert_arr item="oWert"}
                                       {if !$smarty.foreach.merkmalwerte.first}, {/if}
                                       {$oWert->cWert}
                                    {/foreach}
                                 </span>
                              </li>
                           {/foreach}
                           </ul>
                        </small>
                     {/if}
                  {/if}
                     
                  {if $Einstellungen.kaufabwicklung.bestellvorgang_artikelattribute == 'Y'}
                     {if $Position->Artikel->Attribute}
                        <small>
                           <ul class="attributes">
                              {foreach from=$Position->Artikel->Attribute item="oAttribute_arr"}
                                 <li>
                                    <strong class="label">{$oAttribute_arr->cName}</strong>:
                                    <span class="values">
                                       {$oAttribute_arr->cWert}
                                    </span>
                                 </li>
                              {/foreach}
                           </ul>
                        </small>
                     {/if}
                  {/if}
                     
                  {if $Einstellungen.kaufabwicklung.bestellvorgang_artikelkurzbeschreibung == 'Y'}
                     {if $Position->Artikel->cKurzBeschreibung}
                        <br /><p class="shortdescription"><small>{$Position->Artikel->cKurzBeschreibung}</small></p>
                     {/if}
                  {/if}

               {else}
                  <p>{$Position->cName[$smarty.session.cISOSprache]}</p>
                  {if $Position->cHinweis|strlen > 0}
                     <p><small>{$Position->cHinweis}</small></p>
                  {/if}
               {/if}
               </td>
               <td width="50" class="tcenter" valign="middle">
                  {$Position->nAnzahl|replace_delim} {$Position->Artikel->cEinheit}
               </td>
               {if $Einstellungen.kaufabwicklung.bestellvorgang_einzelpreise_anzeigen=="Y"}
                  <td width="120" class="tright" valign="middle">
                     {if $Position->istKonfigVater()}
                        <p>{$Position->cKonfigeinzelpreisLocalized[$NettoPreise][$smarty.session.cWaehrungName]}</p>
                     {else}
                        <p>{$Position->cEinzelpreisLocalized[$NettoPreise][$smarty.session.cWaehrungName]}</p>
                     {/if}
                  </td>
               {/if}
               <td width="120" class="tright" valign="middle">
                  {if $Position->istKonfigVater()}
                     <p>{$Position->cKonfigpreisLocalized[$NettoPreise][$smarty.session.cWaehrungName]}</p>
                  {else}
                     <p>{$Position->cGesamtpreisLocalized[$NettoPreise][$smarty.session.cWaehrungName]}</p>
                  {/if}
               </td>
            </tr>
         {/if}
      {/foreach}

      {if $NettoPreise}
         <tr class="sums">
            <td colspan="{if $Einstellungen.kaufabwicklung.bestellvorgang_einzelpreise_anzeigen!="Y"}3{else}4{/if}">{lang key="totalSum" section="global"}</td>
            <td>{$WarensummeLocalized[$NettoPreise]}</td>
         </tr>
      {/if}

      {if $Einstellungen.global.global_steuerpos_anzeigen!="N"}
         {foreach name=steuerpositionen from=$Steuerpositionen item=Steuerposition}
            <tr class="sums {if $smarty.foreach.steuerpositionen.first}xxx{/if}">
               <td colspan="{if $Einstellungen.kaufabwicklung.bestellvorgang_einzelpreise_anzeigen!="Y"}3{else}4{/if}">{$Steuerposition->cName}</td>
               <td>{$Steuerposition->cPreisLocalized}</td>
            </tr>
         {/foreach}
      {/if}

      {if $smarty.session.Bestellung->GuthabenNutzen==1}
         <tr class="sums">
            <td colspan="{if $Einstellungen.kaufabwicklung.bestellvorgang_einzelpreise_anzeigen!="Y"}3{else}4{/if}">{lang key="voucher" section="global"}</td>
            <td>{$smarty.session.Bestellung->GutscheinLocalized}</td>
         </tr>
      {/if}

      <tr class="sums final">
         <td colspan="{if $Einstellungen.kaufabwicklung.bestellvorgang_einzelpreise_anzeigen!="Y"}3{else}4{/if}">{lang key="totalSum" section="global"} {if $NettoPreise}{lang key="gross" section="global"}{/if}</td>
         <td>{$WarensummeLocalized[0]}</td>
      </tr>
      
      {if $smarty.session.Zahlungsart->kZahlungsart == 2 && $Lieferadresse->cLand eq "DE"}
          <tr class="additional_charges cash_on_delivery_fee_info">
               <td colspan="{if $Einstellungen.kaufabwicklung.bestellvorgang_einzelpreise_anzeigen!="Y"}4{else}5{/if}">
                    <p>{lang key="cashOnDeliveryFee" section="checkout"}</p>
               </td>
          </tr>
      {/if}
      
      {if $Einstellungen.kaufabwicklung.weitere_kosten_anzeigen == 'Y'}
          <tr class="additional_charges">
              <td colspan="{if $Einstellungen.kaufabwicklung.bestellvorgang_einzelpreise_anzeigen!="Y"}4{else}5{/if}">
                  <p>{lang key="additionalCharges" section="checkout"}</p>
              </td>
          </tr>
       {/if}
      
   </tbody>
</table>




