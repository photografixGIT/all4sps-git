{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}

<div class="differential_price">
   <ul>
      <li><strong>{lang key="differentialPrice" section="global"}</strong></li>
      {if $Artikel->Preise->fPreis1>0 && $Artikel->Preise->nAnzahl1>0}
         <li>{lang key="fromDifferential" section="productOverview"} {$Artikel->Preise->nAnzahl1} {if $Artikel->cEinheit}{$Artikel->cEinheit}{/if} &raquo; <span id="price1">{$Artikel->Preise->cPreis1Localized[$NettoPreise]}{if $Artikel->cVPE == "Y" && $Artikel->fVPEWert > 0 && $Artikel->cVPEEinheit} <small>({$Artikel->cStaffelpreisLocalizedVPE1[$NettoPreise]})</small>{/if}</span><em>*</em><p></p></li>                                          
      {/if}
      {if $Artikel->Preise->fPreis2>0 && $Artikel->Preise->nAnzahl2>0}                                             
         <li>{lang key="fromDifferential" section="productOverview"} {$Artikel->Preise->nAnzahl2} {if $Artikel->cEinheit}{$Artikel->cEinheit}{/if} &raquo; <span id="price2">{$Artikel->Preise->cPreis2Localized[$NettoPreise]}{if $Artikel->cVPE == "Y" && $Artikel->fVPEWert > 0 && $Artikel->cVPEEinheit} <small>({$Artikel->cStaffelpreisLocalizedVPE2[$NettoPreise]})</small>{/if}</span><em>*</em></li>
      {/if}
      {if $Artikel->Preise->fPreis3>0 && $Artikel->Preise->nAnzahl3>0}                                             
         <li>{lang key="fromDifferential" section="productOverview"} {$Artikel->Preise->nAnzahl3} {if $Artikel->cEinheit}{$Artikel->cEinheit}{/if} &raquo; <span id="price3">{$Artikel->Preise->cPreis3Localized[$NettoPreise]}{if $Artikel->cVPE == "Y" && $Artikel->fVPEWert > 0 && $Artikel->cVPEEinheit} <small>({$Artikel->cStaffelpreisLocalizedVPE3[$NettoPreise]})</small>{/if}</span><em>*</em></li>
      {/if}
      {if $Artikel->Preise->fPreis4>0 && $Artikel->Preise->nAnzahl4>0}                                             
         <li>{lang key="fromDifferential" section="productOverview"} {$Artikel->Preise->nAnzahl4} {if $Artikel->cEinheit}{$Artikel->cEinheit}{/if} &raquo; <span id="price4">{$Artikel->Preise->cPreis4Localized[$NettoPreise]}{if $Artikel->cVPE == "Y" && $Artikel->fVPEWert > 0 && $Artikel->cVPEEinheit} <small>({$Artikel->cStaffelpreisLocalizedVPE4[$NettoPreise]})</small>{/if}</span><em>*</em></li>
      {/if}
      {if $Artikel->Preise->fPreis5>0 && $Artikel->Preise->nAnzahl5>0}                                             
         <li>{lang key="fromDifferential" section="productOverview"} {$Artikel->Preise->nAnzahl5} {if $Artikel->cEinheit}{$Artikel->cEinheit}{/if} &raquo; <span id="price5">{$Artikel->Preise->cPreis5Localized[$NettoPreise]}{if $Artikel->cVPE == "Y" && $Artikel->fVPEWert > 0 && $Artikel->cVPEEinheit} <small>({$Artikel->cStaffelpreisLocalizedVPE5[$NettoPreise]})</small>{/if}</span><em>*</em></li>
      {/if}
      <li><small><em>*</em>{lang key="pricePerUnit" section="productDetails"} {$Artikel->cMwstVersandText}</small></li>
   </ul>
</div>