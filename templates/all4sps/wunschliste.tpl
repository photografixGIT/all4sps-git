{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
{include file='tpl_inc/header.tpl'}

<div id="content">
   {include file='tpl_inc/inc_breadcrumb.tpl'}
   <h1>{$CWunschliste->cName}{if isset($CWunschliste->oKunde->cVorname)} {lang key="from" section="product rating" alt_section="login,productDetails,productOverview,global,"} {$CWunschliste->oKunde->cVorname}{/if}</h1>
      
   {if isset($cHinweis) && $cHinweis|count_characters > 0}
      <p class="box_success">{$cHinweis}</p>
   {/if}
   
   {include file="tpl_inc/inc_extension.tpl"}
   
   {if isset($CWunschliste->CWunschlistePos_arr) && $CWunschliste->CWunschlistePos_arr|@count > 0}
      <input type="hidden" name="wla" value="1" />
      <input type="hidden" name="wl" value="{$CWunschliste->kWunschliste}" />
      <input type="hidden" name="{$session_name}" value="{$session_id}" />
      <table class="tiny">
         <thead>
            <tr>
               <th></th>
               <!--<th>{lang key="wishlistPosCount" section="login"}</th>-->
               <th>{lang key="wishlistProduct" section="login"}</th>
               <th>{lang key="wishlistComment" section="login"}</th>
               <!--<th>{lang key="wishlistAddedOn" section="login"}</th>-->
            </tr>
         </thead>
         <tbody>
         {foreach name=wunschlistepos from=$CWunschliste->CWunschlistePos_arr item=CWunschlistePos}
            <tr>
               <td style="width:10%"><a href="{$CWunschlistePos->Artikel->cURL}"><img src="{$CWunschlistePos->Artikel->Bilder[0]->cPfadKlein}" class="image"></a></td>
               <!--<td valign="top">{$CWunschlistePos->fAnzahl}<br>{$CWunschlistePos->Artikel->cEinheit}</td>-->
               <td valign="middle">
                  <h2><a href="{$CWunschlistePos->Artikel->cURL}">{$CWunschlistePos->cArtikelName}</a></h2>
                  <p><span class="price">{$CWunschlistePos->cPreis}</span></p>
                  {foreach name=eigenschaft from=$CWunschlistePos->CWunschlistePosEigenschaft_arr item=CWunschlistePosEigenschaft}
                     <p><b>{$CWunschlistePosEigenschaft->cEigenschaftName}:</b> {$CWunschlistePosEigenschaft->cEigenschaftWertName}{if $CWunschlistePos->CWunschlistePosEigenschaft_arr|@count > 1 && !$smarty.foreach.eigenschaft.last}</p>{/if}
                  {/foreach}
               </td>
               <td valign="middle">{$CWunschlistePos->cKommentar}</td>
               <!--<td valign="top">{$CWunschlistePos->dHinzugefuegt_de}</td>-->
            </tr>
         {/foreach}
         </tbody>
      </table>
   {else}
   {if $cFehler}
      <br>
      <div class="userError">
         {$cFehler}
      </div>
   {/if}
   <br>
   {/if}
   {include file='tpl_inc/inc_seite.tpl'}
</div>
{include file='tpl_inc/footer.tpl'}