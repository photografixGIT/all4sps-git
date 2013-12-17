<table class="matrix">
   {if $Artikel->VariationenOhneFreifeld|@count == 2}
      {if $Einstellungen.template.articledetails.show_labels == "Y"}
      <tr>
         <td>&nbsp;</td>
         <td>&nbsp;</td>
         <td colspan="{$Artikel->VariationenOhneFreifeld[0]->Werte|@count}" class="label">{$Artikel->VariationenOhneFreifeld[0]->cName}</td>
      </tr>
      {/if}
      <tr>
         <td>&nbsp;</td>
         {if $Einstellungen.template.articledetails.show_labels == "Y"}
            <td>&nbsp;</td>
         {/if}
         {foreach name="variationsboxHead" from=$Artikel->VariationenOhneFreifeld[0]->Werte item=oVariationWertHead}
            <td class="key h{$smarty.foreach.variationsboxHead.iteration} vmiddle">
               {if $Artikel->oVariBoxMatrixBild_arr|@count > 0 && (($Artikel->nIstVater == 1 && $Artikel->oVariBoxMatrixBild_arr[0]->nRichtung == 0) || $Artikel->nIstVater == 0)}
                  {foreach name="vorschaubild" from=$Artikel->oVariBoxMatrixBild_arr item=oVariBoxMatrixBild}
                     {if $oVariBoxMatrixBild->kEigenschaftWert == $oVariationWertHead->kEigenschaftWert}
                        <img src="{$oVariBoxMatrixBild->cBild}" class="vmiddle" alt="" />
                     {/if}
                  {/foreach}
               {/if}
               <p>{$oVariationWertHead->cName}</p>
            </td>
         {/foreach}
      </tr>

      {assign var=pushed value=0}
      {foreach name="variationsbox1" from=$Artikel->VariationenOhneFreifeld[1]->Werte item=oVariationWert1}
         {assign var=kEigenschaftWert1 value=`$oVariationWert1->kEigenschaftWert`}        
         <tr>
            {assign var=nRows value=$Artikel->VariationenOhneFreifeld[1]->Werte|@count}
            {if !$pushed && $Einstellungen.template.articledetails.show_labels == "Y"}
               <td rowspan="{$nRows}" class="label">
                  <div class="vtext-container">
                     {assign var=l value=$Artikel->VariationenOhneFreifeld[1]->cName|@strlen}
                     {section name="i" start=0 loop=$l step=1}                       
                        <p class="vtext">{$Artikel->VariationenOhneFreifeld[1]->cName[$smarty.section.i.index]}</p>
                     {/section}
                  </div>
               </td>
               {assign var=pushed value=1}
            {/if}
            <td class="key v{$smarty.foreach.variationsbox1.iteration} vmiddle">
               {if $Artikel->oVariBoxMatrixBild_arr|@count > 0 && (($Artikel->nIstVater == 1 && $Artikel->oVariBoxMatrixBild_arr[0]->nRichtung == 1) || $Artikel->nIstVater == 0)}
                  {foreach name="vorschaubild" from=$Artikel->oVariBoxMatrixBild_arr item=oVariBoxMatrixBild}
                     {if $oVariBoxMatrixBild->kEigenschaftWert == $oVariationWert1->kEigenschaftWert}
                        <img src="{$oVariBoxMatrixBild->cBild}" class="vmiddle" alt="" />
                     {/if}
                  {/foreach}
               {/if}
               <p>{$oVariationWert1->cName}</p>
            </td>
            {foreach name="variationsbox0" from=$Artikel->VariationenOhneFreifeld[0]->Werte item=oVariationWert0}
               {assign var=bAusblenden value=false}
               {if $Artikel->nVariationKombiNichtMoeglich_arr|@count > 0}                  
                  {foreach name="variNichtMoeglich" from=$Artikel->nVariationKombiNichtMoeglich_arr[$kEigenschaftWert1] item=kEigenschaftWertNichtMoeglich}
                     {if $kEigenschaftWertNichtMoeglich == $oVariationWert0->kEigenschaftWert && $Einstellungen.artikeldetails.artikeldetails_warenkorbmatrix_lagerbeachten != "N"}
                        {assign var=bAusblenden value=true}
                     {/if}
                  {/foreach}
               {/if}
            
               {if !$bAusblenden}
                  {assign var=cVariBox value=`$oVariationWert0->kEigenschaft`:`$oVariationWert0->kEigenschaftWert`_`$oVariationWert1->kEigenschaft`:`$oVariationWert1->kEigenschaftWert`}
                  <td class="element">
                  {if $Artikel->oVariationKombiKinderAssoc_arr[$cVariBox]->nNichtLieferbar == 1}
                     {lang key="soldout" section="global"}
                  {else}
                  {if $Artikel->fAbnahmeintervall > 1}
                     <input name="variBoxAnzahl[{$oVariationWert1->kEigenschaft}:{$oVariationWert1->kEigenschaftWert}_{$oVariationWert0->kEigenschaft}:{$oVariationWert0->kEigenschaftWert}]" type="text" value="{$smarty.session.variBoxAnzahl_arr[$cVariBox]->fAnzahl|replace_delim}" onblur="javascript:gibAbnahmeIntervall(this, {$Artikel->fAbnahmeintervall});"{if $smarty.session.variBoxAnzahl_arr[$cVariBox]->bError} style="background-color: red;"{/if} /><br />  
                  {else}
                     <input name="variBoxAnzahl[{$oVariationWert1->kEigenschaft}:{$oVariationWert1->kEigenschaftWert}_{$oVariationWert0->kEigenschaft}:{$oVariationWert0->kEigenschaftWert}]" type="text" value="{$smarty.session.variBoxAnzahl_arr[$cVariBox]->fAnzahl|replace_delim}"{if $smarty.session.variBoxAnzahl_arr[$cVariBox]->bError} style="background-color: red;"{/if} /><br />
                  {/if}
                  {if $Artikel->nIstVater == 1}
                     {if $Artikel->oVariationKombiKinderAssoc_arr[$cVariBox]->Preise->cVKLocalized[$NettoPreise] > 0}
                        <p>({$Artikel->oVariationKombiKinderAssoc_arr[$cVariBox]->Preise->cVKLocalized[$NettoPreise]}{if $Artikel->oVariationKombiKinderAssoc_arr[$cVariBox]->Preise->cPreisVPEWertInklAufpreis[$NettoPreise]|count_characters > 0}, {$Artikel->oVariationKombiKinderAssoc_arr[$cVariBox]->Preise->cPreisVPEWertInklAufpreis[$NettoPreise]}{/if})</p>
                     {elseif $Artikel->oVariationKombiKinderAssoc_arr[$cVariBox]->Preise->cVKLocalized[$NettoPreise]}
                        {assign var=cVariBox value=`$oVariationWert1->kEigenschaft`:`$oVariationWert1->kEigenschaftWert`_`$oVariationWert0->kEigenschaft`:`$oVariationWert0->kEigenschaftWert`}
                        <p>({$Artikel->oVariationKombiKinderAssoc_arr[$cVariBox]->Preise->cVKLocalized[$NettoPreise]}{if $Artikel->oVariationKombiKinderAssoc_arr[$cVariBox]->Preise->cPreisVPEWertInklAufpreis[$NettoPreise]|count_characters > 0}, {$Artikel->oVariationKombiKinderAssoc_arr[$cVariBox]->Preise->cPreisVPEWertInklAufpreis[$NettoPreise]}{/if})</p>
                     {/if}
                  {elseif $Einstellungen.artikeldetails.artikel_variationspreisanzeige==1 && ($oVariationWert0->fAufpreisNetto != 0 || $oVariationWert1->fAufpreisNetto != 0)}                            
                     {assign var=fAufpreis value=`$oVariationWert0->fAufpreis[1]+$oVariationWert1->fAufpreis[1]`}
                     <p>({gibPreisStringLocalizedSmarty bAufpreise=true fAufpreisNetto=$fAufpreis fVKNetto=$Artikel->Preise->fVKNetto kSteuerklasse=$Artikel->kSteuerklasse nNettoPreise=$NettoPreise fVPEWert=$Artikel->fVPEWert cVPEEinheit=$Artikel->cVPEEinheit FunktionsAttribute=$Artikel->FunktionsAttribute})</p>
                  {elseif $Einstellungen.artikeldetails.artikel_variationspreisanzeige==2 && ($oVariationWert0->fAufpreisNetto != 0 || $oVariationWert1->fAufpreisNetto != 0)}                                         
                     {assign var=fAufpreis value=`$oVariationWert0->fAufpreis[1]+$oVariationWert1->fAufpreis[1]`}
                     <p>({gibPreisStringLocalizedSmarty bAufpreise=false fAufpreisNetto=$fAufpreis fVKNetto=$Artikel->Preise->fVKNetto kSteuerklasse=$Artikel->kSteuerklasse nNettoPreise=$NettoPreise fVPEWert=$Artikel->fVPEWert cVPEEinheit=$Artikel->cVPEEinheit FunktionsAttribute=$Artikel->FunktionsAttribute})</p>
                  {/if}
               {/if}
               </td>                    
               {else}
                  <td>&nbsp;</td>
               {/if}
            {/foreach}
         </tr>        
      {/foreach}
   {else}
      {* QUERFORMAT *}
      {if $Einstellungen.artikeldetails.artikeldetails_warenkorbmatrix_anzeigeformat == "Q"}
         {assign var=addSpan value=1}
         {assign var=nRows value=$Artikel->VariationenOhneFreifeld[0]->Werte|@count}
         {assign var=rowSpan value=`$addSpan+$nRows`}
         {if $Einstellungen.template.articledetails.show_labels == "Y"}
         <tr>
            <td rowspan="{$rowSpan}" class="label">         
               <div class="vtext-container">
                  {assign var=l value=$Artikel->VariationenOhneFreifeld[0]->cName|@strlen}
                  {section name="i" start=0 loop=$l step=1}                       
                     <p class="vtext">{$Artikel->VariationenOhneFreifeld[0]->cName[$smarty.section.i.index]}</p>
                  {/section}
               </div>
            </td>
         </tr>
         {/if}
         {foreach name="variationsboxHead" from=$Artikel->VariationenOhneFreifeld[0]->Werte item=oVariationWertHead}
         {if $Einstellungen.global.artikeldetails_variationswertlager != 3 || $oVariationWertHead->nNichtLieferbar != 1}
         {assign var=cVariBox value=_`$oVariationWertHead->kEigenschaft`:`$oVariationWertHead->kEigenschaftWert`}
         <tr>
            <td class="key h{$smarty.foreach.variationsboxHead.iteration} vmiddle">
               {$oVariationWertHead->cName}
         
               {if $Artikel->oVariBoxMatrixBild_arr|@count > 0}
                  <br />
                  {foreach name="vorschaubild" from=$Artikel->oVariBoxMatrixBild_arr item=oVariBoxMatrixBild}
                     {if $oVariBoxMatrixBild->kEigenschaftWert == $oVariationWertHead->kEigenschaftWert}
                        <img src="{$oVariBoxMatrixBild->cBild}" alt="" />
                     {/if}
                  {/foreach}
               {/if}
            </td>        
            <td class="element">
               {if $oVariationWertHead->nNichtLieferbar != 1}
                  {if $Artikel->fAbnahmeintervall > 1}
                     <input name="variBoxAnzahl[_{$oVariationWertHead->kEigenschaft}:{$oVariationWertHead->kEigenschaftWert}]" type="text" value="{$smarty.session.variBoxAnzahl_arr[$cVariBox]->fAnzahl|replace_delim}" onblur="javascript:gibAbnahmeIntervall(this, {$Artikel->fAbnahmeintervall});"{if $smarty.session.variBoxAnzahl_arr[$cVariBox]->bError} style="background-color: red;"{/if} /> 
                  {else}
                     <input name="variBoxAnzahl[_{$oVariationWertHead->kEigenschaft}:{$oVariationWertHead->kEigenschaftWert}]" type="text" value="{$smarty.session.variBoxAnzahl_arr[$cVariBox]->fAnzahl|replace_delim}"{if $smarty.session.variBoxAnzahl_arr[$cVariBox]->bError} style="background-color: red;"{/if} /> 
                  {/if}
                  {if $Artikel->nVariationAnzahl == 1 && ($Artikel->kVaterArtikel > 0 || $Artikel->nIstVater==1)}
                     {assign var=kEigenschaftWert value=`$oVariationWertHead->kEigenschaftWert`}
                     <p>({$Artikel->oVariationDetailPreis_arr[$kEigenschaftWert]->Preise->cVKLocalized[$NettoPreise]}{if $Artikel->oVariationDetailPreis_arr[$kEigenschaftWert]->Preise->PreisecPreisVPEWertInklAufpreis[$NettoPreise]|count_characters > 0}, {$Artikel->oVariationDetailPreis_arr[$kEigenschaftWert]->Preise->PreisecPreisVPEWertInklAufpreis[$NettoPreise]}{/if})</p>
                  {elseif $Einstellungen.artikeldetails.artikel_variationspreisanzeige==1 && $oVariationWertHead->fAufpreisNetto!=0}
                     <p>({$oVariationWertHead->cAufpreisLocalized[$NettoPreise]}{if $oVariationWertHead->cPreisVPEWertAufpreis[$NettoPreise]|count_characters > 0}, {$oVariationWertHead->cPreisVPEWertAufpreis[$NettoPreise]}{/if})</p>
                  {elseif $Einstellungen.artikeldetails.artikel_variationspreisanzeige==2 && $oVariationWertHead->fAufpreisNetto!=0}
                     <p>({$oVariationWertHead->cPreisInklAufpreis[$NettoPreise]}{if $oVariationWertHead->cPreisVPEWertInklAufpreis[$NettoPreise]|count_characters > 0}, {$oVariationWertHead->cPreisVPEWertInklAufpreis[$NettoPreise]}{/if})</p>
                  {/if}
               {else}
                  {lang key="soldout" section="global"}
               {/if}
            </td>
         </tr>
         {/if}
         {/foreach}
      
      {else}
         {* HOCHFORMAT *}
         {assign var=addSpan value=1}
         {assign var=nRows value=$Artikel->VariationenOhneFreifeld[0]->Werte|@count}
         {assign var=rowSpan value=`$addSpan+$nRows`}
         {if $Einstellungen.template.articledetails.show_labels == "Y"}
         <tr>
            <td colspan="{$rowSpan}" class="label">         
               {$Artikel->VariationenOhneFreifeld[0]->cName}
            </td>
         </tr>
         {/if}
         <tr>
         {foreach name="variationsboxHead" from=$Artikel->VariationenOhneFreifeld[0]->Werte item=oVariationWertHead}
         {if $Einstellungen.global.artikeldetails_variationswertlager != 3 || $oVariationWertHead->nNichtLieferbar != 1}
         {assign var=cVariBox value=_`$oVariationWertHead->kEigenschaft`:`$oVariationWertHead->kEigenschaftWert`}
            <td class="key h{$smarty.foreach.variationsboxHead.iteration} vmiddle">
               {$oVariationWertHead->cName}
         
               {if $Artikel->oVariBoxMatrixBild_arr|@count > 0}
                  <br />
                  {foreach name="vorschaubild" from=$Artikel->oVariBoxMatrixBild_arr item=oVariBoxMatrixBild}
                     {if $oVariBoxMatrixBild->kEigenschaftWert == $oVariationWertHead->kEigenschaftWert}
                        <img src="{$oVariBoxMatrixBild->cBild}" alt="" />
                     {/if}
                  {/foreach}
               {/if}
            </td>
         {/if}
         {/foreach}
         </tr>
         <tr>
         {foreach name="variationsboxHead" from=$Artikel->VariationenOhneFreifeld[0]->Werte item=oVariationWertHead}
         {if $Einstellungen.global.artikeldetails_variationswertlager != 3 || $oVariationWertHead->nNichtLieferbar != 1}
         {assign var=cVariBox value=_`$oVariationWertHead->kEigenschaft`:`$oVariationWertHead->kEigenschaftWert`}
            <td class="element">
               {if $oVariationWertHead->nNichtLieferbar != 1}
                  {if $Artikel->fAbnahmeintervall > 1}
                     <input name="variBoxAnzahl[_{$oVariationWertHead->kEigenschaft}:{$oVariationWertHead->kEigenschaftWert}]" type="text" value="{$smarty.session.variBoxAnzahl_arr[$cVariBox]->fAnzahl|replace_delim}" onblur="javascript:gibAbnahmeIntervall(this, {$Artikel->fAbnahmeintervall});"{if $smarty.session.variBoxAnzahl_arr[$cVariBox]->bError} style="background-color: red;"{/if} /> 
                  {else}
                     <input name="variBoxAnzahl[_{$oVariationWertHead->kEigenschaft}:{$oVariationWertHead->kEigenschaftWert}]" type="text" value="{$smarty.session.variBoxAnzahl_arr[$cVariBox]->fAnzahl|replace_delim}"{if $smarty.session.variBoxAnzahl_arr[$cVariBox]->bError} style="background-color: red;"{/if} /> 
                  {/if}
                  {if $Artikel->nVariationAnzahl == 1 && ($Artikel->kVaterArtikel > 0 || $Artikel->nIstVater==1)}
                     {assign var=kEigenschaftWert value=`$oVariationWertHead->kEigenschaftWert`}
                     <p>({$Artikel->oVariationDetailPreis_arr[$kEigenschaftWert]->Preise->cVKLocalized[$NettoPreise]}{if $Artikel->oVariationDetailPreis_arr[$kEigenschaftWert]->Preise->PreisecPreisVPEWertInklAufpreis[$NettoPreise]|count_characters > 0}, {$Artikel->oVariationDetailPreis_arr[$kEigenschaftWert]->Preise->PreisecPreisVPEWertInklAufpreis[$NettoPreise]}{/if})</p>
                  {elseif $Einstellungen.artikeldetails.artikel_variationspreisanzeige==1 && $oVariationWertHead->fAufpreisNetto!=0}
                     <p>({$oVariationWertHead->cAufpreisLocalized[$NettoPreise]}{if $oVariationWertHead->cPreisVPEWertAufpreis[$NettoPreise]|count_characters > 0}, {$oVariationWertHead->cPreisVPEWertAufpreis[$NettoPreise]}{/if})</p>
                  {elseif $Einstellungen.artikeldetails.artikel_variationspreisanzeige==2 && $oVariationWertHead->fAufpreisNetto!=0}
                     <p>({$oVariationWertHead->cPreisInklAufpreis[$NettoPreise]}{if $oVariationWertHead->cPreisVPEWertInklAufpreis[$NettoPreise]|count_characters > 0}, {$oVariationWertHead->cPreisVPEWertInklAufpreis[$NettoPreise]}{/if})</p>
                  {/if}
               {else}
                  {lang key="soldout" section="global"}
               {/if}
            </td>
         {/if}
         {/foreach}
         </tr>
      {/if}
   {/if}    
   
   {assign var=addSpan value=2}
   {assign var=nRows value=$Artikel->VariationenOhneFreifeld[0]->Werte|@count}
   {assign var=rowSpan value=`$addSpan+$nRows`}
   <tr>
      <td colspan="{$rowSpan}" class="tcenter">
         {if $Artikel->inWarenkorbLegbar==1}
            <button name="inWarenkorb" type="submit" value="{lang key="addToCart" section="global"}" class="submit">{lang key="addToCart" section="global"}</button>
         {/if}
      </td>
   </tr>
</table>
<input type="hidden" name="variBox" value="1" />
