{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
{include file='tpl_inc/header.tpl'}

<div id="content">
   {assign var=nCheckAbhaengigkeit value="1"}
   <script type="text/javascript" src="{$PFAD_ART_ABNAHMEINTERVALL}artikel_abnahmeintervall.js"></script>
   <script type="text/javascript">
   /* <![CDATA[ */
   {if isset($Artikel->Variationen) && $Artikel->Variationen|@count > 0}
      var vari_bilder = new Array();
      vari_bilder[0] = {ldelim}'cBildPfadGross' : '{$Artikel->Bilder[0]->cPfadGross}', 'cBildPfad' : '{$Artikel->Bilder[0]->cPfadNormal}'{rdelim};
      {foreach name=Variationen from=$Artikel->Variationen item=Variation}
         {foreach name=Variationswerte from=$Variation->Werte item=Variationswert}
         {if $Variationswert->cBildPfad}
            vari_bilder[{$Variationswert->kEigenschaftWert}] = {ldelim}'cBildPfadGross' : '{$Variationswert->cBildPfadGross}', 'cBildPfad' : '{$Variationswert->cBildPfad}'{rdelim};
         {/if}
         {/foreach}
      {/foreach}
   {/if}
   
   function var_bild(id)
   {ldelim}
      imagePreloadedEx('0', vari_bilder[id].cBildPfad, vari_bilder[id].cBildPfadGross);
      {* image wrapper width *}
      var article_image = $('#image_wrapper div.image img');      
      if (article_image.naturalWidth() > 0 && article_image.naturalHeight() > 0)
         init_article_image(article_image);
      else {ldelim}
         article_image.load(function() {ldelim}
            init_article_image($(this));
         {rdelim});
      {rdelim}
   {rdelim}

   function var_sel(kEigenschaft) {ldelim}
      if (kEigenschaft>0) {ldelim}
         var_bild(0);
         ewert = 'eigenschaftwert_'+kEigenschaft;
         kEigenschaftWert = document.getElementById(ewert).options[document.getElementById(ewert).options.selectedIndex].value;
         {foreach name=Variationen from=$Artikel->Variationen item=Variation}
            {if $Variation->cTyp != "FREIFELD" && $Variation->cTyp != "PFLICHT-FREIFELD"}
               {foreach name=Variationswerte from=$Variation->Werte item=Variationswert}
                  if (kEigenschaftWert>0 && kEigenschaftWert=={$Variationswert->kEigenschaftWert} && {if $Variationswert->cBildPfad}true{else}false{/if})
                     var_bild(kEigenschaftWert);
               {/foreach}
            {/if}
         {/foreach}
      {rdelim}
   {rdelim}
   
   {if ($Artikel->nIstVater == 0 && $Artikel->kEigenschaftKombi == 0) && isset($Artikel->Variationen) && $Artikel->Variationen|@count > 0}
      __w = new Array();
      {foreach name=Variationen from=$Artikel->Variationen item=Variation}
         {foreach name=Variationswerte from=$Variation->Werte item=Variationswert}
            {if $Variationswert->fAufpreisNetto!=0 || $Variationswert->fGewichtDiff!=0}
               __w[{$Variationswert->kEigenschaftWert}] = {ldelim}'preis': {if $Variationswert->fAufpreis[$NettoPreise]}{$Variationswert->fAufpreis[$NettoPreise]}{else}0{/if}, 'gewicht': {$Variationswert->fGewichtDiff}{rdelim};
            {/if}
         {/foreach}
      {/foreach}
   {/if}
   
       function aktualisiereArtikelnummer(cArtNr){ldelim}
       {if $Artikel->Variationen|@count == 1}        
            if (cArtNr.length > 0)
                document.getElementById('artnr').innerHTML = cArtNr;
       {/if}
       {rdelim}

   {if ($Artikel->nIstVater == 0 && $Artikel->kEigenschaftKombi == 0) && isset($Artikel->Variationen) && $Artikel->Variationen|@count > 0}
       function aktualisiereGewicht(){ldelim}
         if (document.getElementById('weight'))
            document.getElementById('weight').innerHTML = gibGewicht(gewichtBerechnen({$Artikel->cArtikelgewicht|replace:',':'.'}));
         if (document.getElementById('shippingweight'))
            document.getElementById('shippingweight').innerHTML = gibGewicht(gewichtBerechnen({$Artikel->cGewicht|replace:',':'.'}));
      {rdelim}
      
      function gewichtBerechnen(gewicht){ldelim}
           for(i=0;i<document.getElementById('buy_form').length;i++)
           {ldelim}
               if(typeof __w != "undefined") {ldelim}
                   if(document.getElementById('buy_form').elements[i].type=="radio" && document.getElementById('buy_form').elements[i].checked)
                       if (__w[document.getElementById('buy_form').elements[i].value])
                           gewicht = gewicht + __w[document.getElementById('buy_form').elements[i].value].gewicht;
                           
                   if(document.getElementById('buy_form').elements[i].type=="select-one" && document.getElementById('buy_form').elements[i].selectedIndex>=0)
                       if (document.getElementById('buy_form').elements[i].options[document.getElementById('buy_form').elements[i].selectedIndex].value>0)
                           if (__w[document.getElementById('buy_form').elements[i].options[document.getElementById('buy_form').elements[i].selectedIndex].value])
                               gewicht = gewicht + __w[document.getElementById('buy_form').elements[i].options[document.getElementById('buy_form').elements[i].selectedIndex].value].gewicht;
               {rdelim}
           {rdelim}
           return gewicht;
      {rdelim}
      
      function gibGewicht(gewicht){ldelim}
         gewicht = gewicht.toFixed(2);
         var gewicht = gewicht.toString();
         return gewicht;
      {rdelim}

       function aktualisierePreis(){ldelim}
         {if (!$Artikel->Preise->strPreisGrafik_Detail)}
            if (document.getElementById('price'))
            {ldelim}
               document.getElementById('price').innerHTML = gibPreis(preisBerechnen({$Artikel->Preise->fVK[$NettoPreise]}));
            {rdelim}
            {if $Artikel->Preise->fPreis1>0 && $Artikel->Preise->nAnzahl1>0}document.getElementById('price1').innerHTML = gibPreis(preisBerechnen({$Artikel->Preise->fStaffelpreis1[$NettoPreise]}));{/if}
            {if $Artikel->Preise->fPreis2>0 && $Artikel->Preise->nAnzahl2>0}document.getElementById('price2').innerHTML = gibPreis(preisBerechnen({$Artikel->Preise->fStaffelpreis2[$NettoPreise]}));{/if}
            {if $Artikel->Preise->fPreis3>0 && $Artikel->Preise->nAnzahl3>0}document.getElementById('price3').innerHTML = gibPreis(preisBerechnen({$Artikel->Preise->fStaffelpreis3[$NettoPreise]}));{/if}
            {if $Artikel->Preise->fPreis4>0 && $Artikel->Preise->nAnzahl4>0}document.getElementById('price4').innerHTML = gibPreis(preisBerechnen({$Artikel->Preise->fStaffelpreis4[$NettoPreise]}));{/if}
            {if $Artikel->Preise->fPreis5>0 && $Artikel->Preise->nAnzahl5>0}document.getElementById('price5').innerHTML = gibPreis(preisBerechnen({$Artikel->Preise->fStaffelpreis5[$NettoPreise]}));{/if}
         {/if}
       {rdelim}

       function preisBerechnen(preis){ldelim}
           for(i=0;i<document.getElementById('buy_form').length;i++)
           {ldelim}
               if(typeof __w != "undefined") {ldelim}
                   if(document.getElementById('buy_form').elements[i].type=="radio" && document.getElementById('buy_form').elements[i].checked)
                       if (__w[document.getElementById('buy_form').elements[i].value])
                           preis = preis + __w[document.getElementById('buy_form').elements[i].value].preis;
                           
                   if(document.getElementById('buy_form').elements[i].type=="select-one" && document.getElementById('buy_form').elements[i].selectedIndex>=0)
                       if (document.getElementById('buy_form').elements[i].options[document.getElementById('buy_form').elements[i].selectedIndex].value>0)
                           if (__w[document.getElementById('buy_form').elements[i].options[document.getElementById('buy_form').elements[i].selectedIndex].value])
                               preis = preis + __w[document.getElementById('buy_form').elements[i].options[document.getElementById('buy_form').elements[i].selectedIndex].value].preis;
               {rdelim}
           {rdelim}
           return preis;
       {rdelim}
   {else}
       function aktualisierePreis() {ldelim}{rdelim}
       function aktualisiereGewicht() {ldelim}{rdelim}
   {/if}
   
   function gibPreis(preis){ldelim}
      preis = preis.toFixed(2);
      var po = preis.toString();
      var preisString ="";
      if (preis!=0)
      {ldelim}
      preisAbs = Math.abs(preis);
      var ln = Math.floor(Math.log(Math.floor(Math.abs(preis)))*Math.LOG10E)+1;
      var preisStr = Math.floor(Math.abs(preis)).toString();
      if (ln>3)
      {ldelim}
      for(i=0;i<ln;i++)
      {ldelim}
      if (ln%3==i%3 && i>0) preisString = preisString + "{$smarty.session.Waehrung->cTrennzeichenTausend}"; preisString = preisString + preisStr.charAt(i);
      {rdelim}{rdelim}
      else preisString = preisStr; preisString = preisString + "{$smarty.session.Waehrung->cTrennzeichenCent}" + po.charAt(po.length-2) + po.charAt(po.length-1);
      if (preis<0) preisString = "- "+preisString;
      {rdelim}
      return preisString + " " + unescape("{$smarty.session.Waehrung->cNameHTML}");
   {rdelim}

   <!-- activateVarCombiOption (aktiviert ausgegraute Varkombi Optionen) -->
   function aVC(kEigenschaftWert) {ldelim}
	  $("#kEigenschaftWert_" + kEigenschaftWert).removeClass("variation_disabled");
      $("#kEigenschaftWert_" + kEigenschaftWert).parent().removeClass("variation_disabled");
   {rdelim}
   
   function aVCGroup(kEigenschaft) {ldelim}
	  $('*[name="eigenschaftwert_' + kEigenschaft +'"]').removeClass("variation_disabled");
      $('*[name="eigenschaftwert_' + kEigenschaft +'"]').parent().removeClass("variation_disabled");
	  $('select[name="eigenschaftwert_' + kEigenschaft +'"] option[value!=0]').removeClass("variation_disabled");
   {rdelim}
   
   function checkVarCombi() {ldelim}
      {if !(($Einstellungen.artikeldetails.artikeldetails_warenkorbmatrix_anzeige == "Y" || $Artikel->FunktionsAttribute[$FKT_ATTRIBUT_WARENKORBMATRIX] == "1") && ($Artikel->VariationenOhneFreifeld|@count == 1 || $Artikel->VariationenOhneFreifeld|@count == 2) && !$Artikel->kArtikelVariKombi)}
         {if $Artikel->nIstVater == 1}
            if (!pruefeKombiAusgefuellt())
            {ldelim}
               {lang assign="selectVarCombiText" key="selectVarCombi" section="productDetails"}
               var combi = '{foreach name=vari from=$Artikel->Variationen item=Variation}{$Variation->cName}{if !$smarty.foreach.vari.last}{if ($smarty.foreach.vari.iteration+1) == $Artikel->Variationen|@count} {lang key="selectVarCombiLink" section="productDetails"} {else}, {/if}{/if}{/foreach}';
               var text = '{$selectVarCombiText|escape:"quotes"}';
               text = text.replace('%s', combi);
               alert(text);
               return false;
            {rdelim}
         {/if}
      {/if}
      return true;
   {rdelim}
   
	function setzeVarInfo(kEigenschaftWert, cText, cTyp) {ldelim}
		var text = ' <span class="a' + cTyp +'">(' + cText + ')</span>';
		var elem = $('#kEigenschaftWert_' + kEigenschaftWert);
		
		if (!$(elem).attr('rel')) {ldelim}
			switch ($(elem)[0].tagName) {ldelim}
				case 'INPUT':
					$(elem).attr('rel', $(elem).next().text());
				break;
				case 'OPTION':
					$(elem).attr('rel', $(elem).text());
				break;
			{rdelim}
		{rdelim}
		
		switch ($(elem)[0].tagName) {ldelim}
			case 'INPUT':
				$(elem).next().html($(elem).next().text() + text);
			break;
			case 'OPTION':
				$(elem).html($(elem).text() + text);
			break;
		{rdelim}
	{rdelim}
	
	function setBuyfieldMessage(cText) {ldelim}
		$('#article_buyfield .message p').text(cText);
		$('#article_buyfield .message')
			.fadeIn().wait(5000).fadeOut();
	{rdelim}
    
	function hideBuyfieldMessage() {ldelim}
		$('#article_buyfield .message').stop(true, true).fadeOut();
	{rdelim}
	
	function loescheVarInfo() {ldelim}
		$('.variations option, .variations input').each(function(i, item) {ldelim}
			var text = $(item).attr('rel');
			if (text && text.length > 0) {ldelim}
				switch ($(item)[0].tagName) {ldelim}
					case 'INPUT':
						$(item).next().text(text);
					break;
					case 'OPTION':
						$(item).text(text);
					break;
				{rdelim}
			{rdelim}
		{rdelim});
	{rdelim}
	
   {if $Artikel->nIstVater == 1}
      {include file='tpl_inc/artikel_variations_kombi.tpl'}
   {/if}
   /* ]]> */
   </script>

   {include file='tpl_inc/inc_breadcrumb.tpl'}
   {include file="tpl_inc/inc_extension.tpl"}
   
   <div id="contentmid" class="hproduct">
      {if isset($Artikel->FunktionsAttribute[$FKT_ATTRIBUT_ARTIKELDETAILS_TPL])}
         {include file='tpl_inc/'|cat:$Artikel->FunktionsAttribute[$FKT_ATTRIBUT_ARTIKELDETAILS_TPL]}
      {else}
         {include file='tpl_inc/artikel_inc.tpl'}
      {/if}
   </div>
   {include file='tpl_inc/inc_seite.tpl'}

   {if $Artikel->nIstVater == 1}
      <script type="text/javascript">
         /* <![CDATA[ */
         function setzeEigenschaftWerte(cVariationKombiKind) {ldelim}
            kEigenschaftKombi_arr = new Array();
            var kVariationKombiKind_arr = cVariationKombiKind.split(";");
               
            if(kVariationKombiKind_arr.length > 0) {ldelim}
               for(var g=0; g<kVariationKombiKind_arr.length; g++) {ldelim}
                  var kEigenschaftWert = kVariationKombiKind_arr[g].split("_")[1];
                  var kEigenschaft = kVariationKombiKind_arr[g].split("_")[0];
                  
                  document.getElementById('kEigenschaftWert_' + kEigenschaftWert).selected = true;
                  document.getElementById('kEigenschaftWert_' + kEigenschaftWert).checked = true;
                  
                  kEigenschaftKombi_arr[kEigenschaft] = kEigenschaftWert;
               {rdelim}
            {rdelim}
         {rdelim}
         
         {if $Artikel->oVariationKombi_arr|@count > 0 && $Artikel->kVariKindArtikel > 0}
            setzeEigenschaftWerte('{$Artikel->cVariationKombi}');
            graueNichtMoeglicheEigenschaftWerteAus('{$Artikel->cVariationKombi}');
            if (typeof doSwitchVarkombi == 'function')
               doSwitchVarkombi(0, 0, true);
         {/if}
       /* ]]> */
      </script>
   {/if}
</div>

{include file='tpl_inc/footer.tpl'}
