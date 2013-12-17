{******************************************************************
* JTL-Shop 3
* Template: JTL-Shop3 Tiny
*
* Author: JTL-Software, andreas.juetten@jtl-software.de
* http://www.jtl-software.de
*
* Copyright (c) 2010 JTL-Software
*****************************************************************}

<div id="content">
   {include file='tpl_inc/inc_breadcrumb.tpl'}
   {if $hinweis}
      <p class="box_info">{$hinweis}</p>
   {/if}
   {if $fehler}
      <p class="box_error">{$fehler}</p>
   {/if}
   
   {include file="tpl_inc/inc_extension.tpl"}
   
   <div id="newsDetailContent">                
      <h2>{$oNewsArchiv->cBetreff}</h2>
      <p class="box_plain">
         {$oNewsArchiv->Datum}
         {if isset($Einstellungen.news.news_kategorie_unternewsanzeigen) && $Einstellungen.news.news_kategorie_unternewsanzeigen == "Y"}
            {if $oNewsKategorie_arr|@count > 0 && $oNewsKategorie_arr}
            | 
            {foreach name=newskategorie from=$oNewsKategorie_arr item=oNewsKategorie}
               <a href="{$oNewsKategorie->cURL}" title="{$oNewsKategorie->cBeschreibung|strip_tags|escape:"html"|truncate:60}" class="tooltip"><strong>{$oNewsKategorie->cName}</strong></a>{if !$smarty.foreach.newskategorie.last}, {/if}
            {/foreach}
            {/if}
         {/if}
         </p>
      <div id="news" class="custom_content">{$oNewsArchiv->cText}</div>
   </div>
  
   <div class="container">      
      {if $oBlaetterNavi->nAktiv == 1}
      <div>
         <p>
         {$oBlaetterNavi->nVon} - {$oBlaetterNavi->nBis} {lang key="newsNaviFrom" section="news"} {$oBlaetterNavi->nAnzahl}
         {if $oBlaetterNavi->nAktuelleSeite == 1}
         <span><strong>&laquo;</strong> {lang key="newsNaviBack" section="news"}</span>
         {else}
         <span><a href="news.php?s={$oBlaetterNavi->nVoherige}&kNews={$oNewsArchiv->kNews}&n={$oNewsArchiv->kNews}&{$SID}"><strong>&laquo;</strong> {lang key="newsNaviBack" section="news"}</a></span>
         {/if}
         
         {if $oBlaetterNavi->nAnfang != 0}<a href="news.php?s={$oBlaetterNavi->nAnfang}&kNews={$oNewsArchiv->kNews}&n={$oNewsArchiv->kNews}&{$SID}">{$oBlaetterNavi->nAnfang}</a> ... {/if}
         {foreach name=blaetternavi from=$oBlaetterNavi->nBlaetterAnzahl_arr item=Blatt}
         {if $oBlaetterNavi->nAktuelleSeite == $Blatt}[{$Blatt}]
         {else}
         <a href="news.php?s={$Blatt}&kNews={$oNewsArchiv->kNews}&n={$oNewsArchiv->kNews}&{$SID}">{$Blatt}</a>
         {/if}
         {/foreach}
         
         {if $oBlaetterNavi->nEnde != 0} ... <a href="news.php?s={$oBlaetterNavi->nEnde}&kNews={$oNewsArchiv->kNews}&n={$oNewsArchiv->kNews}&{$SID}">{$oBlaetterNavi->nEnde}</a>{/if}
         
         {if $oBlaetterNavi->nAktuelleSeite == $oBlaetterNavi->nSeiten}
         <span class="nonActiveLink">{lang key="newsNaviNext" section="news"} <strong>&raquo;</strong></span>
         {else}
         <span class="activeLink"><a href="news.php?s={$oBlaetterNavi->nNaechste}&kNews={$oNewsArchiv->kNews}&n={$oNewsArchiv->kNews}&{$SID}">{lang key="newsNaviNext" section="news"} <strong>&raquo;</strong></a></span>
         {/if}
         </p>
      </div>
      {/if}
      
      {if isset($Einstellungen.news.news_kommentare_nutzen) && $Einstellungen.news.news_kommentare_nutzen == "Y"}
         {if $oNewsKommentar_arr|@count > 0}
         <div id="comments">
            <h2>{lang key="newsComments" section="news"}</h2>
            <div class="comments">
               {foreach name=kommentare from=$oNewsKommentar_arr item=oNewsKommentar}
                  <div class="container comment">
                     <p class="author">
                        {if $oNewsKommentar->cVorname|count_characters > 0}    
                        {$oNewsKommentar->cVorname} {$oNewsKommentar->cNachname|truncate:1:""}.,
                        {else}
                        {$oNewsKommentar->cName},
                        {/if}
                        {if $smarty.session.cISOSprache == "ger"}
                        {$oNewsKommentar->dErstellt_de}
                        {else}
                        {$oNewsKommentar->dErstellt}
                        {/if}
                     </p>
                     <div class="body">{$oNewsKommentar->cKommentar}</div>
                  </div>
               {/foreach}
            </div>
         </div>
         {/if}
         
         <form method="post" action="news.php" class="form">
            <input type="hidden" name="{$session_name}" value="{$session_id}" />
            <input type="hidden" name="kNews" value="{$oNewsArchiv->kNews}" />
            <input type="hidden" name="kommentar_einfuegen" value="1" />
            <input type="hidden" name="s" value="{$oBlaetterNavi->nAktuelleSeite}" />
            <input type="hidden" name="n" value="{$oNewsArchiv->kNews}" />
         
            <div id="comments_add" class="form">            
               <h2>{lang key="newsCommentAdd" section="news"}</h2>
               {if $Einstellungen.news.news_kommentare_eingeloggt == "N"}
               <fieldset>
                  <legend>{lang key="newsCommentAdd" section="news"}</legend>
                  {if $smarty.session.Kunde->kKunde == 0}
                  <div id="commentName"{if $nPlausiValue_arr.cName} class="error_block"{/if}>
                  <label class="commentForm" for="comment-name"><strong>{lang key="newsName" section="news"}<em>*</em>:</strong></label>
                  <input id="comment-name" name="cName" type="text" value="{if $cPostVar_arr.cName}{$cPostVar_arr.cName}{/if}" />{if $nPlausiValue_arr.cName}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
                  </div>
                  <div id="commentEmail"{if $nPlausiValue_arr.cEmail} class="error_block"{/if}>
                  <br /><label class="commentForm" for="comment-email"><strong>{lang key="newsEmail" section="news"}<em>*</em>:</strong></label>
                  <input id="comment-email" name="cEmail" type="text" value="{if $cPostVar_arr.cEmail}{$cPostVar_arr.cEmail}{/if}" />{if $nPlausiValue_arr.cEmail}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
                  </div>
                  <p class="clearer" />
                  {/if}
                  <div id="commentText"{if $nPlausiValue_arr.cKommentar} class="error_block"{/if}>
                  <br /><label class="commentForm" for="comment-text"><strong>{lang key="newsComment" section="news"}<em>*</em>:</strong></label>
                  <textarea id="comment-text" class="expander" name="cKommentar" rows="10" cols="50">{if $cPostVar_arr.cKommentar}{$cPostVar_arr.cKommentar}{/if}</textarea>{if $nPlausiValue_arr.cKommentar}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
                  </div>
                  <p class="box_info"><em>*</em> {lang key="mandatoryFields" section="global"}</p>
                  <div id="commentSave"><input class="button" name="speichern" type="submit" value="{lang key="newsCommentSave" section="news"}" /></div>                    
                  {elseif $Einstellungen.news.news_kommentare_eingeloggt == "Y" && $smarty.session.Kunde->kKunde > 0}
                  <div id="commentText">
                  <label class="commentForm" for="comment-text"><strong>{lang key="newsComment" section="news"}<em>*</em>:</strong></label><br />
                  <textarea id="comment-text" class="expander" name="cKommentar" rows="10" cols="50"></textarea>
                  </div>
                  <p class="box_info"><em>*</em> {lang key="mandatoryFields" section="global"}</p>
                  <div id="commentSave"><input class="button" name="speichern" type="submit" value="{lang key="newsCommentSave" section="news"}" /></div>
               </fieldset>
               {/if}
            </div>
         </form>
      
         {if $Einstellungen.news.news_kommentare_eingeloggt == "Y" && $smarty.session.Kunde->kKunde == 0}
         <form method="post" action="jtl.php">
         <input type="hidden" name="{$session_name}" value="{$session_id}" />
         <input type="hidden" name="n" value="{$oNewsArchiv->kNews}" />
         <input type="hidden" name="s" value="{$oBlaetterNavi->nAktuelleSeite}" />
         <input type="hidden" name="r" value="{$R_LOGIN_NEWSCOMMENT}" />
         <div class="box_info">
         <p>{lang key="newsLogin" section="news"}</p>
         <p><input name="einloggen" type="submit" value="{lang key="newsLoginNow" section="news"}" /></p>
         </div>
         </form>
         {/if}
      {/if}
   </div>
</div>