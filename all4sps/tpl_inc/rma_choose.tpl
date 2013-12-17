{*
-------------------------------------------------------------------------------
    JTL-Shop 3
    File: rma_l_choose.tpl, smarty template inc file
    
    page for JTL-Shop 3
    
    Author: daniel.boehmer@bb-network.de
-------------------------------------------------------------------------------
*}

{if $cFehler}<p class="box_error">{$cFehler}</p>{/if}
{if $cHinweis}<p class="box_info">{$cHinweis}</p>{/if}

{if isset($oBestellung->kBestellung) && $oBestellung->kBestellung > 0}
<div id="rma_choose">
   <form method="POST" action="{$oLink->cURLFull}">
      <input name="a" type="hidden" value="submitRMA" />
      <input name="kBestellung" type="hidden" value="{$oBestellung->kBestellung}" />
      <table class="tiny">
            <thead>
               <tr>
                  <th>{lang key="orderNo" section="login"}</th>
                  <th>{lang key="value" section="login"}</th>
                  <th class="tcenter">{lang key="orderDate" section="login"}</th>
              </tr>
            </thead>
            <tbody>
               <tr>
                  <td>{$oBestellung->cBestellNr}</td>
                  <td>{$oBestellung->cBestellwertLocalized}</td>
                  <td class="tcenter">{$oBestellung->dErstelldatum_de}</td>
              </tr>
            </tbody>
      </table>
      
      <br />
       <table class="tiny">
            <thead>
               <tr>
                  <th class="p90">{lang key="products" section="global"}</th>
                  <th class="p10">&nbsp;</th>
              </tr>
            </thead>
            <tbody>
            {foreach name=products from=$oBestellung->Positionen item=oPosition}
               {assign var=kArtikel value=`$oPosition->Artikel->kArtikel`}
               <tr>
                  <td class="p90">
                     <strong>{$oPosition->cAnzahl}x {$oPosition->Artikel->cName}</strong>
                  {if isset($oPosition->cRMAArtikelQuantity)}
                     <br /><em class="rma_sent">* * ({$oPosition->cRMAArtikelQuantity} / {$oPosition->cAnzahl})</em>
                  {/if}
                  {if isset($oRMAGrund_arr) && $oRMAGrund_arr|@count > 0}                  
                     <div id="rma_comment_{$oPosition->Artikel->kArtikel}" class="special_info">
                        <br />
                        <label>{lang key="rma_reason" section="rma"} <em>*</em>:</label>               
                        <select id="cGrund_{$oPosition->Artikel->kArtikel}" name="cGrund_{$oPosition->Artikel->kArtikel}"{if isset($cPlausi_arr[$kArtikel].cGrund)} class="fillout"{/if}>
                           <option value="-1">{lang key="rma_comment_choose" section="rma"}</option>
                     {foreach name=grund from=$oRMAGrund_arr item=oRMAGrund}
                        {assign var=cGrundPost value=cGrund_`$oPosition->Artikel->kArtikel`}
                           <option id="sel_{$oPosition->Artikel->kArtikel}_{$oRMAGrund->getRMAGrund()}" value="{$oRMAGrund->getRMAGrund()}"{if isset($cPost_arr[$cGrundPost]) && $cPost_arr[$cGrundPost] != "-1" && $cPost_arr[$cGrundPost] == $oRMAGrund->getRMAGrund()} selected{/if}>{$oRMAGrund->getGrund()}</option>                                                   
                     {/foreach}
                        </select>                     
                        <br />
                        <br />
                     {foreach name=grund from=$oRMAGrund_arr item=oRMAGrund}
                        <div id="div_sel_{$oPosition->Artikel->kArtikel}_{$oRMAGrund->getRMAGrund()}" class="special_comment div_cmt_{$oPosition->Artikel->kArtikel}">
                           {lang key="rma_quantity" section="rma"} <em>*</em>:<br />
                           {assign var=kRMAGrund value=$oRMAGrund->getRMAGrund()}                           
                           {assign var=fAnzahlPost value=fAnzahl_`$oPosition->Artikel->kArtikel`_`$kRMAGrund`}                           
                           <input id="anzahl_sel_{$oPosition->Artikel->kArtikel}_{$oRMAGrund->getRMAGrund()}" name="fAnzahl_{$oPosition->Artikel->kArtikel}_{$oRMAGrund->getRMAGrund()}" type="text" value="{if isset($cPost_arr[$fAnzahlPost])}{$cPost_arr[$fAnzahlPost]}{else}1{/if}" class="quantity{if isset($cPlausi_arr[$kArtikel].fAnzahl[$kRMAGrund])} fillout{/if}" />
                           <br />
                           {$oRMAGrund->getKommentar()}<br />
                           {assign var=cKommentarPost value=cKommentar_`$oPosition->Artikel->kArtikel`_`$kRMAGrund`}
                           <textarea id="kommentar_sel_{$oPosition->Artikel->kArtikel}_{$oRMAGrund->getRMAGrund()}" name="cKommentar_{$oPosition->Artikel->kArtikel}_{$oRMAGrund->getRMAGrund()}" class="comment">{if isset($cPost_arr[$cKommentarPost])}{$cPost_arr[$cKommentarPost]}{/if}</textarea>
                        </div>
                     {assign var=cGrundPost value=cGrund_`$oPosition->Artikel->kArtikel`}
                     {if isset($cPost_arr[$cGrundPost]) && $cPost_arr[$cGrundPost] != "-1"}
                        <script>
                        $(document).ready(function() {ldelim}
                           $("#div_sel_{$oPosition->Artikel->kArtikel}_{$cPost_arr[$cGrundPost]}").css("display", "block");
                        {rdelim});   
                        </script>
                     {/if}
                     {/foreach}        
                     </div>
                     <script>
                        $("#cGrund_{$oPosition->Artikel->kArtikel}").change(function() {ldelim}                           
                           $(".div_cmt_{$oPosition->Artikel->kArtikel}").css("display", "none");
                           $("#div_" + $("#cGrund_{$oPosition->Artikel->kArtikel} option:selected").attr('id')).css("display", "block");                        
                        {rdelim});
                  
                     {if isset($cPost_arr.kArtikelAssoc_arr[$kArtikel])}
                        $(document).ready(function() {ldelim}
                           $("#rma_checkbox_{$oPosition->Artikel->kArtikel}").attr("checked", "checked");
                           $("#rma_comment_{$oPosition->Artikel->kArtikel}").slideDown("slow");
                        {rdelim});
                     {/if}   
                     </script> 
                  {/if}
                  </td>
                  <td class="p10">
                  {if isset($oPosition->bRMA) && !$oPosition->bRMA}
                     <input id="rma_checkbox_{$oPosition->Artikel->kArtikel}" name="kArtikel_arr[]" type="checkbox" value="{$oPosition->Artikel->kArtikel}" />
                  {elseif isset($oPosition->bRMA) && $oPosition->bRMA} 
                     <em>* *</em>
                  {/if}
                  </td>
              </tr>
              <script>
                 $("#rma_checkbox_{$oPosition->Artikel->kArtikel}").click(function () {ldelim} 
                    var checked = $(this).attr("checked"); 
                    if(checked) 
                        $("#rma_comment_{$oPosition->Artikel->kArtikel}").slideDown("slow");
                    else
                       $("#rma_comment_{$oPosition->Artikel->kArtikel}").slideUp("slow");                      
                 {rdelim});
              </script>
           {/foreach}
            </tbody>
      </table>
      <br />
      <p class="required1"><em>*</em> {lang key="rma_required" section="rma"}</p>
      <p class="required2"><em>* *</em> {lang key="rma_gekennzeichnet" section="rma"}</p>
      <br />
      <p><input name="submitRMA" type="submit" class="submit" value="{lang key="rma_ruecksenden" section="rma"}" /></p>
   </form>
   <br />
   <br />
   <form method="POST" action="{$oLink->cURLFull}">
      <p><input name="submitRMA" type="submit" class="submit" value="{lang key="rma_back" section="rma"}" /></p>
   </form>
</div>
{/if}