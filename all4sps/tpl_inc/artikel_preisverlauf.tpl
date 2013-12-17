{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
<object type="application/x-shockwave-flash" data="{$PFAD_FLASHCHART}open-flash-chart.swf" id="chart_wrapper" width="100%" height="250">
   <param name="movie" value="{$PFAD_FLASHCHART}open-flash-chart.swf" />
   <param name="wmode" value="transparent" />
   <param name="allowscriptaccess" value="always" />
   {*<param name="FlashVars" value="data-file={$ShopURL}/includes/preisverlaufgraph_ofc.php?kArtikel={if isset($Artikel->kVariKindArtikel)}{$Artikel->kVariKindArtikel}{else}{$Artikel->kArtikel}{/if}&kKundengruppe={$Artikel->Preise->kKundengruppe}&kSteuerklasse={$Artikel->kSteuerklasse}&fMwSt=teeeeest">*}
   <param name="FlashVars" value="data-file={$ShopURL}/includes/preisverlaufgraph_ofc.php?cOption={if isset($Artikel->kVariKindArtikel)}{$Artikel->kVariKindArtikel}{else}{$Artikel->kArtikel}{/if};{$Artikel->Preise->kKundengruppe};{$Artikel->kSteuerklasse};{$Artikel->fMwSt}">
</object>
<div id="chart_wrapper"></div>