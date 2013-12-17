<div class="sidebox autoscroll box_config" id="sidebox{$oBox->kBox}">
  <h3 class="boxtitle">{lang key="yourConfiguration"}</h3>
  <div class="sidebox_content">
    <div id="box_config_list">
      <!-- ul itemlist -->
    </div>
    <div id="box_config_price">
      <span class="price_label">{lang key="priceAsConfigured" section="productDetails"}</span>
      <span class="price updateable"><!-- price --></span>
      {if $Artikel->cLocalizedVPE[$NettoPreise]}<small class="price_base updateable">{$Artikel->cLocalizedVPE[$NettoPreise]}</small><br />{/if}
      <span class="vat_info">{$Artikel->cMwstVersandText}</span>
      
    </div>
  </div>
</div>

{if !$Artikel->bHasKonfig}
   <script type="text/javascript">
      $(document).ready(function() {ldelim}
         $('.box_config').hide();
      {rdelim});
   </script>
{/if}