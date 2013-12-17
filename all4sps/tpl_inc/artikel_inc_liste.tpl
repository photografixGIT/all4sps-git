{if isset($oArtikel_arr) && count($oArtikel_arr)>0}
<div class="container {if !isset($bAutoload) || !$bAutoload}carousel_loader{/if} {if isset($cClass)}{$cClass}{/if}">
   {assign var='random' value=1|rand:999999}
   <h2>{if $headline}{$headline}{else}{lang key=$cKey section=$cSection}{/if}</h2>
   <ul id="{if isset($cID)}{$cID}{else}mycarousel{$random}{/if}" class="jcarousel-skin-tiny" ref="{if isset($nVisible) && $nVisible > 0}{$nVisible}{else}{if $Einstellungen.template.articledetails.article_jcarousel_visible}{$Einstellungen.template.articledetails.article_jcarousel_visible}{else}2{/if}{/if}"> 
      {foreach from=$oArtikel_arr item=oArtikel}
         <li>
            <div class="article_wrapper">
               <a href="{$oArtikel->cURL}" title="{$oArtikel->cName|strip_tags|escape:"quotes"}">
                  <span class="img"><img src="{$oArtikel->Bilder[0]->cPfadKlein}" class="image" height="60" alt="" /></span>
                  <span class="desc">
                     <span class="title">{$oArtikel->cName}</span><br />
                     <span class="text">
                        {if $smarty.session.Kundengruppe->darfPreiseSehen}
                           {if $oArtikel->Preise->fVKNetto==0 && $Einstellungen.global.global_preis0=="N"}
                            <span class="price_label">{lang key="priceOnApplication" section="global"}</span>
                         {else}
                             <span class="price_label">{lang key="price" section="global"}:</span> 
                             <span class="price">{$oArtikel->Preise->cVKLocalized[$NettoPreise]}</span>
                          {/if}
                      {else}
                         <span class="price_label">{lang key="priceHidden" section="global"}</span>
                      {/if}
                     </span><br />
                     <span class="text"><span class="vat_info">{$oArtikel->cMwstVersandText|strip_tags}</span></span><br />
                     {if $oArtikel->cLocalizedVPE}
                        <span class="text"><small><b>{lang key="basePrice" section="global"}:</b> {$oArtikel->cLocalizedVPE[$NettoPreise]}</small></span><br />
                     {/if}
                  </span>
               </a>
            </div>
         </li>
      {/foreach}
   </ul>
</div>
{/if}
