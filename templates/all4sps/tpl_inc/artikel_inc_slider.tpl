{if isset($oArtikel_arr) && count($oArtikel_arr)>0}
<div class="container {if !isset($bAutoload) || !$bAutoload}carousel_loader{/if} {if isset($cClass)}{$cClass}{/if}">
   {assign var='random' value=1|rand:999999}
   <h2 class="title">{lang key=$cKey section=$cSection}</h2>
   <ul id="{if isset($cID)}{$cID}{else}flatcarousel{$random}{/if}" class="hlist articles jcarousel-skin-flat" ref="{if isset($nVisible) && $nVisible > 0}{$nVisible}{else}{if $Einstellungen.template.articledetails.article_jcarousel_visible}{$Einstellungen.template.articledetails.article_jcarousel_visible}{else}2{/if}{/if}"> 
      {foreach name=$cKey from=$oArtikel_arr item=Artikel}
         <li>
            <div class="pwrapper">
               <p class="pimage">
                  <a href="{$Artikel->cURL}">
                     <img src="{$Artikel->cVorschaubild}" class="image" alt="{$Artikel->cName|strip_tags|escape:"quotes"}" />
                  </a>
               </p>
               <h3><a href="{$Artikel->cURL}">{$Artikel->cName}</a></h3>
               
               <div class="left p40">
                  <span class="stars p{$Artikel->fDurchschnittsBewertung|replace:'.':'_'}"></span>
               </div>
               
               <div class="left p60 tright">
                  {include file="tpl_inc/artikel_preis.tpl" scope="content"}
               </div>

            </div>
         </li>
      {/foreach}
   </ul>
</div>
{/if}
