{if isset($Einstellungen.artikeluebersicht.artikeluebersicht_finanzierung_anzeigen) && $Einstellungen.artikeluebersicht.artikeluebersicht_finanzierung_anzeigen == "Y" && isset($Artikel->fRateLocalized_arr) && $Artikel->fRateLocalized_arr|@count > 0}

<div style="text-align: center;">
   <table style="width: 100%; border: 1px solid lightyellow;">
      <tr>
         <td align="center"><strong>{lang key="financingDuration" section="global"}</strong></td>
         <td align="center"><strong>{lang key="financingHoldback" section="global"}</strong></td>
         <td align="center"><strong>{lang key="financingBorrowingRate" section="global"}<strong></td>
         <td align="center"><strong>{lang key="financingAnnualRate" section="global"} *</strong></td>
      </tr>
   
   {foreach name=ratenfinanzierung from=$Artikel->fRateLocalized_arr key=nLaufrate item=fRateLocalized}
      <tr>
         <td align="center">{$nLaufrate}</td>
         <td align="center">{$fRateLocalized}</td>
         <td align="center">{$Artikel->cSollzinsenLocalized_arr[$nLaufrate]}</td>
         <td align="center">9,9 %</td>
      </tr>
   {/foreach}
   
   </table>
   
    <br /><br />
    *{lang key="financingIncludesProcessingFee" section="global"}
    
    {*
   <br /><br />
   
   <strong>{lang key="financingRateTable" section="global"}:</strong><br />
   <table style="width: 100%" cellspacing="1">
      <tr style="background-color: #DDDDDD ! important;">
         <td><strong>{lang key="financingDuration" section="global"}:</strong></td>
         <td>6</td>
         <td>12</td>
         <td>18</td>
         <td>24</td>
         <td>30</td>
         <td>36</td>
         <td>42</td>
         <td>48</td>
         <td>54</td>
         <td>60</td>
         <td>66</td>
         <td>72</td>
      </tr>
      
      <tr style="background-color: #CCCCCC ! important;">
         <td><strong>{lang key="financingBorrowingRate" section="global"}:</strong></td>
         <td>2,62 %</td>
         <td>5,75 %</td>
         <td>6,90 %</td>
         <td>6,54 %</td>
         <td>7,09 %</td>
         <td>7,46 %</td>
         <td>7,73 %</td>
         <td>7,93 %</td>
         <td>8,08 %</td>
         <td>8,21 %</td>
         <td>8,31 %</td>
         <td>8,40 %</td>
      </tr>
   </table>
    *}
</div>
   
{/if}