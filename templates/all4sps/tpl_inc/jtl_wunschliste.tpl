{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
<div id="content">
   <h1>{$CWunschliste->cName}</h1>
   
   {if $hinweis}
      <p class="box_info">{$hinweis}</p>
   {/if}

   <form method="post" action="jtl.php" name="WunschlisteSuche" class="form">
      <input type="hidden" name="wlsearch" value="1" />
      <input type="hidden" name="wl" value="{$CWunschliste->kWunschliste}" /> 
      <input type="hidden" name="{$session_name}" value="{$session_id}" />

      <fieldset>
         <legend>{lang key="wishlistSearch" section="login"}</legend>
         <input name="cSuche" type="text" value="{$wlsearch}" /> <input name="submitSuche" type="submit" value="{lang key="wishlistSearchBTN" section="login"}" />
         {if $wlsearch}
            <a href="jtl.php?wl={$CWunschliste->kWunschliste}&{$SID}" class="wishlistlink"> <strong>{lang key="wishlistRemoveSearch" section="login"}</strong></a>
         {/if}
      </fieldset>
   </form>

   <form method="post" action="jtl.php" name="Wunschliste">
      <input type="hidden" name="wla" value="1" />
      <input type="hidden" name="wl" value="{$CWunschliste->kWunschliste}" />
      <input type="hidden" name="{$session_name}" value="{$session_id}" />
      
      {if $wlsearch}
      <input type="hidden" name="wlsearch" value="1" />
      <input type="hidden" name="cSuche" value="{$wlsearch}" />
      {/if}
      
      {if $CWunschliste->CWunschlistePos_arr|@count > 0 && $CWunschliste->CWunschlistePos_arr}
      <table class="tiny">
         <thead>
            <tr>
               <th>{lang key="wishlistProduct" section="login"}</th>
               <th>{lang key="wishlistComment" section="login"}</th>
               <th class="tcenter">{lang key="wishlistPosCount" section="login"}</th>
               <th></th>
            </tr>
         </thead>
         <tbody>
            {foreach name=wunschlistepos from=$CWunschliste->CWunschlistePos_arr item=CWunschlistePos}
            <tr>
               <td valign="top">
                  <div class="article_wrapper" class="tcenter">
                     <div class="image_wrapper">
                        <a href="{$CWunschlistePos->Artikel->cURL}">
                           <img src="{$CWunschlistePos->Artikel->cVorschaubild}" width="60" class="image">
                        </a>
                     </div>
                     <div class="desc">
                        <p><a href="{$CWunschlistePos->Artikel->cURL}">{$CWunschlistePos->cArtikelName}</a></p>
                        {if $CWunschlistePos->Artikel->Preise->fVKNetto==0 && $Einstellungen.global.global_preis0=="N"}
                           <p>{lang key="priceOnApplication" section="global"}</p>
                        {else}
                           <p><b>{lang key="price"}:</b> {$CWunschlistePos->cPreis}</p>
                           
                           {if $CWunschlistePos->Artikel->cLocalizedVPE}
                             <p><small><b>{lang key="basePrice" section="global"}:</b> {$CWunschlistePos->Artikel->cLocalizedVPE[$NettoPreise]}</small></p>
                           {/if}
                           
                        {/if}
                        <p><span class="vat_info">{$CWunschlistePos->Artikel->cMwstVersandText}</span></p>
                        {foreach name=eigenschaft from=$CWunschlistePos->CWunschlistePosEigenschaft_arr item=CWunschlistePosEigenschaft}
                        {if $CWunschlistePosEigenschaft->cFreifeldWert}
                           <p><b>{$CWunschlistePosEigenschaft->cEigenschaftName}:</b> {$CWunschlistePosEigenschaft->cFreifeldWert}{if $CWunschlistePos->CWunschlistePosEigenschaft_arr|@count > 1 && !$smarty.foreach.eigenschaft.last}</p>{/if}
                        {else}
                           <p><b>{$CWunschlistePosEigenschaft->cEigenschaftName}:</b> {$CWunschlistePosEigenschaft->cEigenschaftWertName}{if $CWunschlistePos->CWunschlistePosEigenschaft_arr|@count > 1 && !$smarty.foreach.eigenschaft.last}</p>{/if}
                        {/if}
                        {/foreach}
                     </div>
                  </div>
               </td>
               <td class="tcenter"><textarea class="expander" cols="15" name="Kommentar_{$CWunschlistePos->kWunschlistePos}">{$CWunschlistePos->cKommentar}</textarea></td>
               <td class="tcenter"><input name="Anzahl_{$CWunschlistePos->kWunschlistePos}" class="wunschliste_anzahl" type="text" size="1" value="{$CWunschlistePos->fAnzahl|replace_delim}"><br />{$CWunschlistePos->Artikel->cEinheit}</td>
               <td class="tcenter">
                  <a href="jtl.php?wl={$CWunschliste->kWunschliste}&wlplo={$CWunschlistePos->kWunschlistePos}{if $wlsearch}&wlsearch=1&cSuche={$wlsearch}{/if}&{$SID}">{lang key="wishlistremoveItem" section="login"}</a>
               </td>
            </tr>
            {/foreach}
         </tbody>
      </table>
      
      <div class="container tright">
         <a href="jtl.php?wl={$CWunschliste->kWunschliste}&wldl=1&{$SID}" class="button"><span>{lang key="wishlistDelAll" section="login"}</span></a>                   
      </div>
      {/if}
      
      <div class="container box_info">
         {if $CWunschliste->nOeffentlich == 1}
         <span>{lang key="wishlistNoticePublic" section="login"}</span><br />

         <a href="jtl.php?wl={$CWunschliste->kWunschliste}&nstd=0&{$SID}" class="button"><span>{lang key="wishlistSetPrivate" section="login"}</span></a>
         
         <br /><br />
         <strong>{lang key="wishlistURL" section="login"}:</strong>
         <br />
         <input type="text" id="wunschliste_public_url" value="{$ShopURL}/index.php?wlid={$CWunschliste->cURLID}" style="width:100%" />
         <br /> <br />
         {if $Einstellungen.global.global_wunschliste_freunde_aktiv == "Y"}
         <a href="jtl.php?wl={$CWunschliste->kWunschliste}&wlvm=1&{$SID}" class="button"><span>{lang key="wishlistViaEmail" section="login"}</span></a>
         {/if}
            
         {else}
            <span>{lang key="wishlistNoticePrivate" section="login"}</span><br />
            <a href="jtl.php?wl={$CWunschliste->kWunschliste}&nstd=1&{$SID}" class="button"><span>{lang key="wishlistSetPublic" section="login"}</span></a>
         {/if}
         
      </div>
      
      <div class="form container">
         <fieldset>
            <legend>{lang key="wishlistRename" section="login"}</legend>
            <input name="WunschlisteName" type="text" value="{$CWunschliste->cName}" />
            <input type="submit" value="{lang key="wishlistUpdate" section="login"}" />
         </fieldset>
      </div>

   </form>
</div>