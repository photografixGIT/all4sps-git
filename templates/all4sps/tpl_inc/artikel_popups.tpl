{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
{assign var=kArtikel value=$Artikel->kArtikel}
{if $Artikel->kArtikelVariKombi > 0}
   {assign var=kArtikel value=$Artikel->kArtikelVariKombi}
{/if}

{if $Einstellungen.artikeldetails.artikeldetails_fragezumprodukt_anzeigen=="P"}
<div id="popupz{$kArtikel}" class="hidden">
   {include file='tpl_inc/artikel_fragezumproduktformular.tpl'}
</div>
{/if}

{if $Einstellungen.artikeldetails.artikeldetails_artikelweiterempfehlen_anzeigen=="P"}
<div id="popupw{$kArtikel}" class="hidden">
   {include file='tpl_inc/artikel_artikelweiterempfehlenformular.tpl'}
</div>
{/if}

{if ($verfuegbarkeitsBenachrichtigung == 2 || $verfuegbarkeitsBenachrichtigung == 3) && (($Artikel->cLagerBeachten == 'Y' && $Artikel->cLagerKleinerNull != 'Y') || $Artikel->cLagerBeachten != 'Y')}
<div id="popupn{$kArtikel}" class="hidden">
   {include file='tpl_inc/artikel_produktverfuegbarformular.tpl' scope='artikeldetails'}
</div>
{/if}

{if isset($Einstellungen.artikeldetails.artikeldetails_finanzierung_anzeigen) && $Einstellungen.artikeldetails.artikeldetails_finanzierung_anzeigen == "Y"}

<div id="popupf{$kArtikel}" class="hidden">
   {include file='tpl_inc/artikel_finanzierung_popup.tpl'}
</div>
{/if}

{if isset($bWarenkorbHinzugefuegt) && $bWarenkorbHinzugefuegt && $Einstellungen.template.articledetails.article_pushed_to_basket == 'Y'}
<div id="popupa{$kArtikel}" class="hidden">
   {include file='tpl_inc/artikel_hinzugefuegt.tpl' oArtikel=$Artikel fAnzahl=$bWarenkorbAnzahl}
</div>
{/if}

<script type="text/javascript" defer="defer">
{if isset($fehlendeAngaben_benachrichtigung) && count($fehlendeAngaben_benachrichtigung) > 0 && ($verfuegbarkeitsBenachrichtigung == 2 || $verfuegbarkeitsBenachrichtigung == 3) && (($Artikel->cLagerBeachten == 'Y' && $Artikel->cLagerKleinerNull != 'Y') || $Artikel->cLagerBeachten != 'Y')}
   show_popup('n{$kArtikel}');
{/if}

{if isset($fehlendeAngaben_fragezumprodukt) && $fehlendeAngaben_fragezumprodukt|@count > 0 && $Einstellungen.artikeldetails.artikeldetails_fragezumprodukt_anzeigen == "P"}
   show_popup('z{$kArtikel}');
{/if}

{if isset($fehlendeAngaben_artikelweiterempfehlen) && $fehlendeAngaben_artikelweiterempfehlen|@count > 0 && $Einstellungen.artikeldetails.artikeldetails_artikelweiterempfehlen_anzeigen == "P"}
   show_popup('w{$kArtikel}');
{/if}

{if isset($bWarenkorbHinzugefuegt) && $bWarenkorbHinzugefuegt && $Einstellungen.template.articledetails.article_pushed_to_basket == 'Y'}
   show_popup('a{$kArtikel}', false, false, function() {ldelim}
      jQuery(document).ready(function(){ldelim}
         jQuery('#mycarousel_pushed').jcarousel({ldelim}
            scroll: 1,
            visible: 1,
            wrap: 'last'
         {rdelim});
      {rdelim});
   {rdelim});
{/if}
</script>