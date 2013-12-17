{*if $Boxen.ZuletztAngesehen->anzeigen=="Y"*}
{if isset($Boxen.ZuletztAngesehen->Artikel) && $Boxen.ZuletztAngesehen->Artikel|@count > 0}
   <!--
   <script type="text/javascript" src="{$currentTemplateDir}js/jquery.jcarousel.js"></script>
   <script type="text/javascript">
      {literal}
      jQuery(document).ready(function() {
          jQuery('#s!lider').jcarousel({
              vertical: true,
              scroll: 2
          });
      });
      {/literal}
   </script>
   -->

   <div class="sidebox" id="sidebox{$oBox->kBox}">
      <h3 class="boxtitle">{lang key="lastViewed" section="global"}</h3>
      
      <div class="sidebox_content" style="position:relative;">
         <div id="slider" class="jcarousel jcarousel-skin-tango">
            <ul>
               {foreach name=zuletztangesehen from=$Boxen.ZuletztAngesehen->Artikel item=oArtikel}
               <li>
               <div class="container tcenter">
                  <p><a href="{$oArtikel->cURL}"><img src="{$oArtikel->cVorschaubild}" alt="{$oArtikel->cName|strip_tags|escape:"quotes"|truncate:60}" class="image" /></a></p>
                  <p><a href="{$oArtikel->cURL}">{$oArtikel->cName}</a></p>
                  
                  {include file="tpl_inc/artikel_preis.tpl" price_image=$oArtikel->Preise->strPreisGrafik_Zuletztbox Artikel=$oArtikel scope="box"}
               </div>
               </li>
               {/foreach}
            </ul>
         </div>
      </div>
      
   </div>
{/if}
{*/if*}