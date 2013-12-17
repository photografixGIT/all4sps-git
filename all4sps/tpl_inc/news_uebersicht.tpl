{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
<div id="wrapper">
    <div id="content">
      {include file='tpl_inc/inc_breadcrumb.tpl'}
        <div id="contentmid">
            <div class="content_head">
                <h1>{lang key="news" section="news"}</h1>
            </div>
            
            {if $hinweis}
                <div class="box_info">
                    {$hinweis}
                </div>
            {/if}
            
            {if $fehler}
                <div class="box_error">
                    {$fehler}
                </div>
            {/if}
            
            {include file="tpl_inc/inc_extension.tpl"}
            
            {if $oNewsUebersicht_arr|@count > 0 && $oNewsUebersicht_arr}
            <div id="suche_verfeinern">
                <form id="verfeinern" name="verfeinern" action="news.php" method="post" class="form">
                   <fieldset>
                     <legend>{lang key="improveYourSearch" section="global"}</legend>
                      <input type="hidden" name="{$session_name}" value="{$session_id}" />

                      <select name="nSort" onchange="document.getElementById('verfeinern').submit();">
                          <option value="-1"{if $nSort == -1} selected{/if}>{lang key="newsSort" section="news"}</option>
                          <option value="1"{if $nSort == 1} selected{/if}>{lang key="newsSortDateDESC" section="news"}</option>                    
                          <option value="2"{if $nSort == 2} selected{/if}>{lang key="newsSortDateASC" section="news"}</option>
                          <option value="3"{if $nSort == 3} selected{/if}>{lang key="newsSortHeadlineASC" section="news"}</option>
                          <option value="4"{if $nSort == 4} selected{/if}>{lang key="newsSortHeadlineDESC" section="news"}</option>
                          <option value="5"{if $nSort == 5} selected{/if}>{lang key="newsSortCommentsDESC" section="news"}</option>
                          <option value="6"{if $nSort == 6} selected{/if}>{lang key="newsSortCommentsASC" section="news"}</option>                    
                      </select>
                      
                      {if $oDatum_arr|@count > 0}
                      <select name="cDatum" onchange="document.getElementById('verfeinern').submit();">
                          <option value="-1"{if $cDatum == -1} selected{/if}>{lang key="newsDateFilter" section="news"}</option>
                      {foreach name="datum" from=$oDatum_arr item=oDatum}
                          <option value="{$oDatum->cWert}"{if $cDatum == $oDatum->cWert} selected{/if}>{$oDatum->cName}</option>
                      {/foreach}
                      </select>
                      {/if}
                      
                      {if $oNewsKategorie_arr|@count > 0}
                      <select name="nNewsKat" onchange="document.getElementById('verfeinern').submit();">
                          <option value="-1"{if $nNewsKat == -1} selected{/if}>{lang key="newsCategorie" section="news"}</option>
                      {foreach name="newskats" from=$oNewsKategorie_arr item=oNewsKategorie}
                          <option value="{$oNewsKategorie->kNewsKategorie}"{if $nNewsKat == $oNewsKategorie->kNewsKategorie} selected{/if}>{$oNewsKategorie->cName}</option>
                      {/foreach}
                      </select>
                      {/if}
                      
                      <select name="nAnzahl" onchange="document.getElementById('verfeinern').submit();">
                          <option value="-1"{if $nAnzahl == -1} selected{/if}>{lang key="newsPerSite" section="news"}</option>
                          <option value="2"{if $nAnzahl == 2} selected{/if}>2</option>
                          <option value="5"{if $nAnzahl == 5} selected{/if}>5</option>                    
                          <option value="10"{if $nAnzahl == 10} selected{/if}>10</option>
                          <option value="20"{if $nAnzahl == 20} selected{/if}>20</option>
                      </select>
                      
                      <input name="submitGo" type="submit" value="{lang key="filterGo" section="global"}" />
                </form>
            </div>
            {/if}
            
            {if $noarchiv}
                {lang key="noNewsArchiv" section="news"}.
            {else}
                {if $oBlaetterNavi->nAktiv == 1}
                <div class="pages">
                        <p>
                        {lang key="page" section="productOverview" alt_section="global,"} {$oBlaetterNavi->nVon} - {$oBlaetterNavi->nBis} {lang key="from" section="product rating" alt_section="login,productDetails,productOverview,global,"} {$oBlaetterNavi->nAnzahl}
                        {if $oBlaetterNavi->nAktuelleSeite > 1}
                            <a href="news.php?s={$oBlaetterNavi->nVoherige}">&laquo; {lang key="previous" section="productOverview" alt_section="global,"}</a>
                        {/if}
                        
                        {if $oBlaetterNavi->nAnfang != 0}<a href="news.php?s={$oBlaetterNavi->nAnfang}">{$oBlaetterNavi->nAnfang}</a> ... {/if}
                        {foreach name=blaetternavi from=$oBlaetterNavi->nBlaetterAnzahl_arr item=Blatt}
                            {if $oBlaetterNavi->nAktuelleSeite == $Blatt}
                                <span>{$Blatt}</span>
                            {else}
                                <a href="news.php?s={$Blatt}">{$Blatt}</a>
                            {/if}
                        {/foreach}
                        
                        {if $oBlaetterNavi->nEnde != 0} ... <a href="news.php?s={$oBlaetterNavi->nEnde}">{$oBlaetterNavi->nEnde}</a>{/if}
                        
                        {if $oBlaetterNavi->nAktuelleSeite < $oBlaetterNavi->nSeiten}
                            <a href="news.php?s={$oBlaetterNavi->nNaechste}">{lang key="next" section="productOverview" alt_section="global,"} &raquo;</a>
                        {/if}
                        
                        </p>
                </div>
                {/if}
                
                {if $oNewsUebersicht_arr|@count > 0 && $oNewsUebersicht_arr}
                <div id="newsContent">
                    {foreach name=uebersicht from=$oNewsUebersicht_arr item=oNewsUebersicht}
                        <div class="container">
                            <h2><a href="{$oNewsUebersicht->cURL}">{$oNewsUebersicht->cBetreff}</a></h2>
                            <div class="box_plain">{$oNewsUebersicht->dErstellt_de}
                        {if isset($Einstellungen.news.news_kommentare_nutzen) && $Einstellungen.news.news_kommentare_nutzen == "Y"}
                        | <a href="{$oNewsUebersicht->cURL}#comments" title="{lang key="readComments" section="news"}">{$oNewsUebersicht->nNewsKommentarAnzahl} {if $oNewsUebersicht->nNewsKommentarAnzahl == 1}{lang key="newsComment" section="news"}{else}{lang key="newsComments" section="news"}{/if}</a>                           
                        {/if}
                                    </div>
                                        <div class="newsArchivText">
                                        {if $oNewsUebersicht->cVorschauText|count_characters > 0}
                                            {$oNewsUebersicht->cVorschauText}    
                                            <div class="flt_right">
                                            {$oNewsUebersicht->cMehrURL}
                                            </div>
                                            <div class="clearer"> </div>                            
                                        {elseif $oNewsUebersicht->cText|strip_tags|count_characters > 200}
                                            {$oNewsUebersicht->cText|strip_tags|truncate:200:$oNewsUebersicht->cMehrURL}
                                        {else}
                                            {$oNewsUebersicht->cText}
                                        {/if}
                                        </div>
                            
                            </div>
                    {/foreach}
                    </div>
                {/if}
                
                {if $oBlaetterNavi->nAktiv == 1}
                <div class="pages">
                        <p>
                        {lang key="page" section="productOverview" alt_section="global,"} {$oBlaetterNavi->nVon} - {$oBlaetterNavi->nBis} {lang key="from" section="product rating" alt_section="login,productDetails,productOverview,global,"} {$oBlaetterNavi->nAnzahl}
                        {if $oBlaetterNavi->nAktuelleSeite > 1}
                            <a href="news.php?s={$oBlaetterNavi->nVoherige}">&laquo; {lang key="previous" section="productOverview" alt_section="global,"}</a>
                        {/if}
                        
                        {if $oBlaetterNavi->nAnfang != 0}<a href="news.php?s={$oBlaetterNavi->nAnfang}">{$oBlaetterNavi->nAnfang}</a> ... {/if}
                        {foreach name=blaetternavi from=$oBlaetterNavi->nBlaetterAnzahl_arr item=Blatt}
                            {if $oBlaetterNavi->nAktuelleSeite == $Blatt}
                                <span>{$Blatt}</span>
                            {else}
                                <a href="news.php?s={$Blatt}">{$Blatt}</a>
                            {/if}
                        {/foreach}
                        
                        {if $oBlaetterNavi->nEnde != 0} ... <a href="news.php?s={$oBlaetterNavi->nEnde}">{$oBlaetterNavi->nEnde}</a>{/if}
                        
                        {if $oBlaetterNavi->nAktuelleSeite < $oBlaetterNavi->nSeiten}
                            <a href="news.php?s={$oBlaetterNavi->nNaechste}">{lang key="next" section="productOverview" alt_section="global,"} &raquo;</a>
                        {/if}
                        
                        </p>
                </div>
                {/if}
            {/if}
            
        </div>
    </div>
</div>