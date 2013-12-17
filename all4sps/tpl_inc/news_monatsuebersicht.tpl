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
            <h1>{lang key="newsMonthOverview" section="news"}</h1>
         </div>
         
         {if $hinweis}
            <br />
            <div class="userNotice">
               {$hinweis}
            </div>
         {/if}
         {if $fehler}
            <br />
            <div class="userError">
               {$fehler}
            </div>
         {/if}
         <br />
         
            {if $noarchiv}
                {lang key="noNewsArchiv" section="news"}.
            {else}
             <div id="newsMonth">
                <h4 class="title"><span>{$cName}</span></h4>
                <!-- <div class="content">
                   <p>{lang key="newsArchivDesc" section="global"}</p>
                 </div> -->
             </div>
             
             {if $oNews_arr|@count > 0 && $oNews_arr}
             <div id="newsContent">      
                {foreach name=monatsuebersicht from=$oNews_arr item=oNews}
                   <div class="newsBox">
                      <div class="newsTopTitle">
                            <h2 class="newsHeadline"><a href="{$oNews->cURL}">{$oNews->cBetreff}</a></h2>
                            </div>
                       <div class="newsTime">{$oNews->dErstellt_de} | <a href="{$oNews->cURL}#comments" title="{lang key="readComments" section="news"}">{$oNews->nNewsKommentarAnzahl} {if $oNews->nNewsKommentarAnzahl == 1}{lang key="newsComment" section="news"}{else}{lang key="newsComments" section="news"}{/if}</a>
                            </div>
                               <div class="newsArchivText">
                               {if $oNews->cVorschauText|count_characters > 0}
                                  {$oNews->cVorschauText}   
                                            <div class="flt_right">
                                            {$oNews->cMehrURL}
                                            </div>
                                            <div class="clearer"> </div>                     
                               {elseif $oNews->cText|count_characters > 200}
                                  {$oNews->cText|truncate:200:$oNews->cMehrURL}
                               {else}
                                  {$oNews->cText}
                               {/if}
                               </div>
                      
                      </div>
                {/foreach}
                </div>
             {/if}
             
             {if $oNewsNavi_arr|@count > 0 && $oNewsNavi_arr}
                <div id="newsNavi">
             <h4 class="title">{lang key="newsNavi" section="global"}</h4>
             <ul>
             {foreach name=newsmonatsnavi from=$oNewsNavi_arr item=oNewsNavi}
                <li><a href="{$oNewsNavi->cURL}"><strong>{$oNewsNavi->cName}</strong></a> <span class="smallfontMerkmale">({$oNewsNavi->nAnzahl})</span></li>
             {/foreach}
                </ul>
             </div>
             {/if}
             
             <p><strong>&laquo;</strong> <a href="javascript:history.back()">{lang key="newsletterhistoryback" section="newsletter" alt_section="global,"}</a></p>
            {/if}
         
      </div>
   </div>
</div>