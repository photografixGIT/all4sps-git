{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
<form method="post" action="bewertung.php" id="article_rating">
   <fieldset class="outer">
   <div class="clearall">
      <div id="article_votes">
         <ul>
         {if $Artikel->Bewertungen->nSterne_arr|@count > 0}
            {foreach name=sterne from=$Artikel->Bewertungen->nSterne_arr item=nSterne key=i}
            {assign var=int1 value=5}
            {assign var=schluessel value=`$int1-$i`}
            {assign var=int2 value=100}
            {assign var=percent value=`$nSterne/$Artikel->Bewertungen->oBewertungGesamt->nAnzahl*$int2`}
            {* {$divbreite|round}px *}
               <li class="vote_item">
                  <div class="title">
                  {if $nSterne > 0}
                     <a href="index.php?a={$Artikel->kArtikel}&btgsterne={$schluessel}&{$SID}">{$schluessel} {if $i >= 4}{lang key="starSingular" section="product rating"}{else}{lang key="starPlural" section="product rating"}{/if}</a>
                  {else}
                     {$schluessel} {if $i >= 4}{lang key="starSingular" section="product rating"}{else}{lang key="starPlural" section="product rating"}{/if}
                  {/if}
                  </div>
                  <div class="colored">
                     <div class="inner" style="width:{$percent|round}%"></div>
                  </div>
                  <div class="count">
                     {$nSterne}
                  </div>
                  <div class="clear"></div>
               </li>
            {/foreach}
         {/if}
         </ul>
      </div>
      <div id="article_information">
         <p><strong>{lang key="averageProductRating" section="product rating"}</strong>: {if $Artikel->Bewertungen->oBewertungGesamt->fDurchschnitt} <span class="stars p{$Artikel->Bewertungen->oBewertungGesamt->fDurchschnitt|replace:'.':'_'}"></span>{/if}</p>
         <p class="box_plain"><small>({lang key="maxProduct1" section="product rating"} <strong>{if $Artikel->Bewertungen->oBewertungGesamt->nAnzahl > 0}{$Artikel->Bewertungen->oBewertungGesamt->nAnzahl}{else}{lang key="maxProductNull" section="product rating"}{/if}</strong> {lang key="maxProduct2" section="product rating"})</small></p>
         <p class="box_plain">{lang key="shareYourExperience" section="product rating"}</p>
         <input name="bfa" type="hidden" value="1" />
         <input name="a" type="hidden" value="{$Artikel->kArtikel}" />
         <input type="hidden" name="{$session_name}" value="{$session_id}" />
         <input name="bewerten" type="submit" value="{lang key="productAssess" section="product rating"}" class="submit" />
      </div>
   </div>
   </fieldset>
</form>

{if $Artikel->HilfreichsteBewertung->oBewertung_arr|@count > 0 && $Artikel->HilfreichsteBewertung->oBewertung_arr[0]->nHilfreich > 0}
   <form method="post" action="bewertung.php">
      <fieldset class="outer">
         <input name="bhjn" type="hidden" value="1" />
         <input name="a" type="hidden" value="{$Artikel->kArtikel}" />
         <input name="btgsterne" type="hidden" value="{$BlaetterNavi->nSterne}" />
         <input name="btgseite" type="hidden" value="{$BlaetterNavi->nAktuelleSeite}" />
         <input type="hidden" name="{$session_name}" value="{$session_id}" />         
         <h2>{lang key="theMostUsefulRating" section="product rating"}</h2>
         {foreach name=artikelhilfreichstebewertungen from=$Artikel->HilfreichsteBewertung->oBewertung_arr item=oBewertung}
            {include file="tpl_inc/artikel_bewertung_kommentar.tpl" oBewertung=$oBewertung bMostUseful=true}
         {/foreach}
      </fieldset>
   </form>   
{/if}

{if $Artikel->Bewertungen->oBewertung_arr|@count > 0}

   {if $Artikel->HilfreichsteBewertung->oBewertung_arr|@count > 0 && $Artikel->HilfreichsteBewertung->oBewertung_arr[0]->nHilfreich > 0}
      <h2>{lang key="moreProductRatings" section="product rating"} {if $BlaetterNavi->nSterne > 0}({lang key="evaluatedWith" section="product rating"} {$BlaetterNavi->nSterne} {if $BlaetterNavi->nSterne == 1}{lang key="starSingular" section="product rating" alt_section="global,"}{else}{lang key="starPluralEvaluated" section="product rating"}{/if}){/if}</h2>
   {/if}

   <form id="sortierenID" method="get" action="index.php" class="form">
      <fieldset>
         <div class="pages">
            <strong>{lang key="page" section="productOverview"} {if $BlaetterNavi->nAktiv == 1}{$BlaetterNavi->nAktuelleSeite}{else}1{/if} </strong> {lang key="of" section="productOverview"} {if $BlaetterNavi->nAktiv == 1}{$BlaetterNavi->nSeiten}{else}1{/if}
         </div>
         
         <div class="sortorder">
            <input name="a" type="hidden" value="{$Artikel->kArtikel}" />
            <input name="btgsterne" type="hidden" value="{$BlaetterNavi->nSterne}" />
            <input name="btgseite" type="hidden" value="{$BlaetterNavi->nAktuelleSeite}" />
            <input type="hidden" name="{$session_name}" value="{$session_id}" />
         
            {lang key="reviewsSortedBy" section="product rating"} 
            <select name="sortierreihenfolge" onchange="$('#sortierenID').submit();">
               <option value="2"{if $Artikel->Bewertungen->Sortierung == 2} selected{/if}>{lang key="recentReviewFirst" section="product rating"}</option>
               <option value="3"{if $Artikel->Bewertungen->Sortierung == 3} selected{/if}>{lang key="latestReviewFirst" section="product rating"}</option>
               <option value="4"{if $Artikel->Bewertungen->Sortierung == 4} selected{/if}>{lang key="highestReviewFirst" section="product rating"}</option>
               <option value="5"{if $Artikel->Bewertungen->Sortierung == 5} selected{/if}>{lang key="lowestReviewFirst" section="product rating"}</option>
               <option value="6"{if $Artikel->Bewertungen->Sortierung == 6} selected{/if}>{lang key="usefulClassifiedReviewFirst" section="product rating"}</option>
               <option value="7"{if $Artikel->Bewertungen->Sortierung == 7} selected{/if}>{lang key="unusefulClassifiedReviewFirst" section="product rating"}</option>
            </select>
            <input name="submit__" type="submit" value="{lang key="goButton" section="product rating"}" />
         </div>
      </fieldset>
   </form>
      
   <form method="post" action="bewertung.php">
      <fieldset class="outer">
         <input name="bhjn" type="hidden" value="1" />
         <input name="a" type="hidden" value="{$Artikel->kArtikel}" />
         <input name="btgsterne" type="hidden" value="{$BlaetterNavi->nSterne}" />
         <input name="btgseite" type="hidden" value="{$BlaetterNavi->nAktuelleSeite}" />
         <input type="hidden" name="{$session_name}" value="{$session_id}" />
         {foreach name=artikelbewertungen from=$Artikel->Bewertungen->oBewertung_arr item=oBewertung}
            {if $Artikel->HilfreichsteBewertung->oBewertung_arr[0]->nHilfreich > 0 && $Artikel->HilfreichsteBewertung->oBewertung_arr[0]->kBewertung == $oBewertung->kBewertung}
            {else}
               {include file="tpl_inc/artikel_bewertung_kommentar.tpl" oBewertung=$oBewertung}
            {/if}
         {/foreach}
      </fieldset>
   </form>
   
   {if $Artikel->Bewertungen->nAnzahlSprache > $Einstellungen.bewertung.bewertung_anzahlseite}
      <div class="navi tright">
      {if $BlaetterNavi->nAktiv == 1}
         <ul class="pagenavi">
            <li class="prev">
               {if $BlaetterNavi->nAktuelleSeite > 1}
                  <a href="index.php?a={$Artikel->kArtikel}&btgsterne={$BlaetterNavi->nSterne}&btgseite={$BlaetterNavi->nVoherige}&{$SID}">&laquo; {lang key="previous" section="productOverview"}</a>
               {/if}
               
               {if $BlaetterNavi->nAnfang != 0}<a href="index.php?a={$Artikel->kArtikel}&btgsterne={$BlaetterNavi->nSterne}&btgseite={$BlaetterNavi->nAnfang}&{$SID}">{$BlaetterNavi->nAnfang}</a> ... {/if}
            </li>

            {foreach name=blaetter from=$BlaetterNavi->nBlaetterAnzahl_arr item=Blatt key=i}
               <li class="page {if $BlaetterNavi->nAktuelleSeite == $Blatt}selected{/if}">
                  <a href="index.php?a={$Artikel->kArtikel}&btgsterne={$BlaetterNavi->nSterne}&btgseite={$Blatt}&{$SID}">{$Blatt}</a>
               </li>
            {/foreach}

            <li>
               .. {lang key="of" section="productOverview"} {$BlaetterNavi->nSeiten}
            </li>
            
            <li class="next">
               {if $BlaetterNavi->nAktuelleSeite < $BlaetterNavi->nSeiten}
                  <a href="index.php?a={$Artikel->kArtikel}&btgsterne={$BlaetterNavi->nSterne}&btgseite={$BlaetterNavi->nNaechste}&{$SID}">{lang key="next" section="productOverview" alt_section="global,"} &raquo;</a>
               {/if}
            </li>
         </ul>
      {/if}   
      </div>   
   {/if}
   
{/if}