{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}

{if !$bAjax}
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
   <title>{$meta_title}</title>
   <meta http-equiv="content-type" content="text/html; charset={$JTL_CHARSET}">
   <META NAME="Title" CONTENT="{$meta_title}">
   <META NAME="description" CONTENT="{$meta_description|truncate:1000:"":true}">
   <META NAME="keywords" CONTENT="{$meta_keywords|truncate:255:"":true}">
   <META NAME="author" CONTENT="JTL-Software">
   <META NAME="language" CONTENT="{$meta_language}">
   <META NAME="revisit-after" CONTENT="7 days">
   <META NAME="robots" CONTENT="index, follow, all">
   <META NAME="publisher" CONTENT="{$meta_publisher}">
   <META NAME="copyright" CONTENT="{$meta_copyright}">
   <meta http-equiv="pragma" content="no-cache">
   <meta http-equiv="expires" content="now">
   <meta http-equiv="Content-Language" content="{$meta_language}">

   <link type="image/x-icon" href="{$currentTemplateDir}images/favicon.ico" rel="icon"/>
   <link type="image/x-icon" href="{$currentTemplateDir}images/favicon.ico" rel="shortcut icon"/>

   <link type="text/css" href="{$PFAD_MINIFY}/g=tiny.css&amp;{$smarty.now}" rel="stylesheet" title="tiny" media="screen" />
   <link type="text/css" href="{$PFAD_MINIFY}/g=print.css&amp;{$smarty.now}" rel="stylesheet" media="print" />
   <link type="text/css" href="{$PFAD_MINIFY}/g=tiny_blue.css&amp;{$smarty.now}" rel="alternate stylesheet" title="tiny_blue" media="screen" />

   <script type="text/javascript" src="{$PFAD_MINIFY}/g=jtl3.js&amp;debug=1"></script>


   {if $print == 1}
      <script type="text/javascript">
      window.print();
      </script>
   {/if}
</head>
<body>
{/if}
   <div class="comparelist tleft">
      <h1>{lang key="compareList" section="comparelist"}</h1>

      {if !$bAjax}
         <div class="box_plain">
            <a href="index.php?vla=1&print=1&{$SID}">{lang key="comparePrintThisPage" section="comparelist"}</a>
            {if $Einstellungen_Vergleichsliste.vergleichsliste.vergleichsliste_target == "parent"}
               | <a href="index.php?{$SID}">{lang key="back" section="comparelist"}</a>
            {/if}
         </div>
      {/if}

      <table class="tiny">
          <!-- Artikelkopf -->
            <tr>
               <td valign="top" class="attribute" style="width: {$Einstellungen_Vergleichsliste.vergleichsliste.vergleichsliste_spaltengroesseattribut}px">
                  &nbsp;
               </td>
            {foreach name=vergleich from=$oVergleichsliste->oArtikel_arr item=oArtikel}
               <td valign="top" style="width:{$Einstellungen_Vergleichsliste.vergleichsliste.vergleichsliste_spaltengroesse}px;" class="tcenter">
            <div class="image_overlay_wrapper" id="image_drag_vl_article{$oArtikel->kArtikel}">
                  <a href="{$oArtikel->cURL}">
                     {image src=$oArtikel->cVorschaubild alt=$oArtikel->cName class="image"}
                  </a>
            </div>
                  <p class="box_plain">
                     <a href="{$oArtikel->cURL}">{$oArtikel->cName}</a>
                  </p>
                  <p class="box_plain">
                     <span class="price_label">{lang key="price"}: </span>
                     <span class="price">{$oArtikel->Preise->cVKLocalized[$NettoPreise]}</span>
                     {if $oArtikel->cLocalizedVPE}
                        <br /><small><b>{lang key="basePrice" section="global"}:</b> {$oArtikel->cLocalizedVPE[$NettoPreise]}</small>
                     {/if}
                     <br /><span class="vat_info">{$oArtikel->cMwstVersandText}</span>
                  </p>
               </td>
            {/foreach}
            </tr>
            {foreach name=priospalten from=$cPrioSpalten_arr item=cPrioSpalten}
            {if $cPrioSpalten != "Merkmale" && $cPrioSpalten != "Variationen"}
               {if $smarty.foreach.priospalten.iteration % 2 == 0}
                  <tr class="first">
               {else}
                  <tr class="last">
               {/if}
            {/if}
            {if $cPrioSpalten == "cArtNr" && $Einstellungen_Vergleichsliste.vergleichsliste.vergleichsliste_artikelnummer != 0}
               <!-- Artikelnummer-->
               <td valign="top" class="attribute" style="width: {$Einstellungen_Vergleichsliste.vergleichsliste.vergleichsliste_spaltengroesseattribut}px">
                  {lang key="productNumber" section="comparelist"}
               </td>
            {/if}
            {if $cPrioSpalten == "cHersteller" && $Einstellungen_Vergleichsliste.vergleichsliste.vergleichsliste_hersteller != 0}
               <!-- Hersteller -->
               <td valign="top" class="attribute" style="width: {$Einstellungen_Vergleichsliste.vergleichsliste.vergleichsliste_spaltengroesseattribut}px">
                  {lang key="manufacturer" section="comparelist"}
               </td>
            {/if}
            {if $cPrioSpalten == "cBeschreibung" && $Einstellungen_Vergleichsliste.vergleichsliste.vergleichsliste_beschreibung != 0}
               <!-- Beschreibung -->
               <td valign="top" class="attribute" style="width: {$Einstellungen_Vergleichsliste.vergleichsliste.vergleichsliste_spaltengroesseattribut}px">
                  <div class="custom_content">
                     {lang key="description" section="comparelist"}
                  </div>
               </td>
            {/if}
            {if $cPrioSpalten == "cKurzBeschreibung" && $Einstellungen_Vergleichsliste.vergleichsliste.vergleichsliste_kurzbeschreibung != 0}
               <!-- Kurzbeschreibung -->
               <td valign="top" class="attribute" style="width: {$Einstellungen_Vergleichsliste.vergleichsliste.vergleichsliste_spaltengroesseattribut}px">
                  {lang key="shortDescription" section="comparelist"}
               </td>
            {/if}
            {if $cPrioSpalten == "fArtikelgewicht" && $Einstellungen_Vergleichsliste.vergleichsliste.vergleichsliste_artikelgewicht != 0}
               <!-- Artikelgewicht -->
               <td valign="top" class="attribute" style="width: {$Einstellungen_Vergleichsliste.vergleichsliste.vergleichsliste_spaltengroesseattribut}px">
                  {lang key="productWeight" section="comparelist"}
               </td>
            {/if}
            {if $cPrioSpalten == "fGewicht" && $Einstellungen_Vergleichsliste.vergleichsliste.vergleichsliste_versandgewicht != 0}
               <!-- Versantgewicht -->
               <td valign="top" class="attribute" style="width: {$Einstellungen_Vergleichsliste.vergleichsliste.vergleichsliste_spaltengroesseattribut}px">
                  {lang key="shippingWeight" section="comparelist"}
               </td>
            {/if}

               {if $cPrioSpalten != "Merkmale" && $cPrioSpalten != "Variationen"}
               {foreach name=vergleich from=$oVergleichsliste->oArtikel_arr item=oArtikel}
                  <td valign="top" style="width: {$Einstellungen_Vergleichsliste.vergleichsliste.vergleichsliste_spaltengroesse}px">
                     {if $oArtikel->$cPrioSpalten != ""}
                        {if $cPrioSpalten == "fArtikelgewicht" || $cPrioSpalten == "fGewicht"}
                            {$oArtikel->$cPrioSpalten} {lang key="weightUnit" section="comparelist"}
                        {else}
                            {$oArtikel->$cPrioSpalten}
                        {/if}
                     {else}
                        &nbsp;
                     {/if}
                  </td>
               {/foreach}
            </tr>
            {/if}

          {if $cPrioSpalten == "Merkmale" && $Einstellungen_Vergleichsliste.vergleichsliste.vergleichsliste_merkmale != 0}
          <!-- Merkmale -->
            {foreach name=merkmale from=$oMerkmale_arr item=oMerkmale}
            {if $smarty.foreach.merkmale.iteration % 2 == 0}
               <tr class="first">
            {else}
               <tr class="last">
            {/if}
                  <td valign="top" class="attribute" style="width: {$Einstellungen_Vergleichsliste.vergleichsliste.vergleichsliste_spaltengroesseattribut}px">
                     {$oMerkmale->cName}
                  </td>

                 {foreach name=vergleich from=$oVergleichsliste->oArtikel_arr item=oArtikel}
                 <td valign="top" style="width: {$Einstellungen_Vergleichsliste.vergleichsliste.vergleichsliste_spaltengroesse}px">
                    {if count($oArtikel->oMerkmale_arr) > 0}

                      {foreach name=merkmale from=$oArtikel->oMerkmale_arr item=oMerkmaleArtikel}
                           {if $oMerkmale->cName == $oMerkmaleArtikel->cName}

                              {foreach name=merkmalwerte from=$oMerkmaleArtikel->oMerkmalWert_arr item=oMerkmalWert}

                                {$oMerkmalWert->cWert}{if !$smarty.foreach.merkmalwerte.last}, {/if}
                              {/foreach}
                           {/if}
                      {/foreach}

                    {else}
                      &nbsp;
                    {/if}
                 </td>
                 {/foreach}

               </tr>
            {/foreach}
         {/if}

         {if $cPrioSpalten == "Variationen" && $Einstellungen_Vergleichsliste.vergleichsliste.vergleichsliste_variationen != 0}
         <!-- Variationen -->
            {foreach name=variationen from=$oVariationen_arr item=oVariationen}
            {if $smarty.foreach.variationen.iteration % 2 == 0}
               <tr class="first">
            {else}
               <tr class="last">
            {/if}
                  <td valign="top" class="attribute" style="width: {$Einstellungen_Vergleichsliste.vergleichsliste.vergleichsliste_spaltengroesseattribut}px">
                     {$oVariationen->cName}
                  </td>

                  {foreach name=vergleich from=$oVergleichsliste->oArtikel_arr item=oArtikel}
                 <td valign="top">
               {if isset($oArtikel->oVariationenNurKind_arr) && $oArtikel->oVariationenNurKind_arr|@count > 0}
                 {foreach name=variationen from=$oArtikel->oVariationenNurKind_arr item=oVariationenArtikel}
                           {if $oVariationen->cName == $oVariationenArtikel->cName}

                              {foreach name=variationswerte from=$oVariationenArtikel->Werte item=oVariationsWerte}

                                {$oVariationsWerte->cName}
                        {if $oArtikel->nVariationOhneFreifeldAnzahl == 1 && ($oArtikel->kVaterArtikel > 0 || $oArtikel->nIstVater==1)}
                           {assign var=kEigenschaftWert value=`$oVariationsWerte->kEigenschaftWert`}
                           ({$oArtikel->oVariationDetailPreisKind_arr[$kEigenschaftWert]->Preise->cVKLocalized[$NettoPreise]}{if $oArtikel->oVariationDetailPreisKind_arr[$kEigenschaftWert]->Preise->PreisecPreisVPEWertInklAufpreis[$NettoPreise]|count_characters > 0}, {$oArtikel->oVariationDetailPreisKind_arr[$kEigenschaftWert]->Preise->PreisecPreisVPEWertInklAufpreis[$NettoPreise]}{/if})
                        {/if}
                              {/foreach}
                           {/if}
                      {/foreach}
                    {elseif $oArtikel->Variationen|@count > 0}
                      {foreach name=variationen from=$oArtikel->Variationen item=oVariationenArtikel}
                           {if $oVariationen->cName == $oVariationenArtikel->cName}

                              {foreach name=variationswerte from=$oVariationenArtikel->Werte item=oVariationsWerte}

                                {$oVariationsWerte->cName}
                        {if $Einstellungen_Vergleichsliste.artikeldetails.artikel_variationspreisanzeige==1 && $oVariationsWerte->fAufpreisNetto!=0}
                           ({$oVariationsWerte->cAufpreisLocalized[$NettoPreise]}{if $oVariationsWerte->cPreisVPEWertAufpreis[$NettoPreise]|count_characters > 0}, {$oVariationsWerte->cPreisVPEWertAufpreis[$NettoPreise]}{/if})
                        {elseif $Einstellungen_Vergleichsliste.artikeldetails.artikel_variationspreisanzeige==2 && $oVariationsWerte->fAufpreisNetto!=0}
                           ({$oVariationsWerte->cPreisInklAufpreis[$NettoPreise]}{if $oVariationsWerte->cPreisVPEWertInklAufpreis[$NettoPreise]|count_characters > 0}, {$oVariationsWerte->cPreisVPEWertInklAufpreis[$NettoPreise]}{/if})
                        {/if}{if !$smarty.foreach.variationswerte.last}, {/if}
                              {/foreach}
                           {/if}
                      {/foreach}

                    {else}
                      &nbsp;
                    {/if}
                 </td>
                 {/foreach}

               </tr>
            {/foreach}
         {/if}
      {/foreach}
         {if $bWarenkorb}
            <tr>
               <td style="width: {$Einstellungen_Vergleichsliste.vergleichsliste.vergleichsliste_spaltengroesseattribut}px">
                  &nbsp;
               </td>
               {foreach name=vergleich from=$oVergleichsliste->oArtikel_arr item=oArtikel}
               <td valign="top" class="tcenter" style="width: {$Einstellungen_Vergleichsliste.vergleichsliste.vergleichsliste_spaltengroesse}px">
               <!--
                  <form action="vergleichsliste.php" method="get">
                     <input type="hidden" name="vlph" value="1" />
                     <input type="hidden" name="a" value="{$oArtikel->kArtikel}" />
                     <input type="submit" value="{lang key="addToCart" section="global"}" />
                  </form>
               -->
                  <button class="submit" onclick="window.location.href = '{$oArtikel->cURL}'">{lang key="details" section="global"}</button>
               </td>
            {/foreach}
            </tr>
         {/if}
      </table>
   </div>
{if !$bAjax}
</body>
</html>
{/if}