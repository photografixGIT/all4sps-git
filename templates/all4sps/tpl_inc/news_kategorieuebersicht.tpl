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
            <h1>{lang key="newsCatOverview" section="news"}</h1>
         </div>
         
         {if $hinweis}
            <br>
            <div class="userNotice">
               {$hinweis}
            </div>
         {/if}
         {if $fehler}
            <br>
            <div class="userError">
               {$fehler}
            </div>
         {/if}
         <br>
         
         <div id="newsKatTitle">
            <h2 class="title"><span>{$oNewsKategorie->cName}</span></h2>
            <!-- <div class="content">
               <p>{lang key="newsArchivDesc" section="global"}</p>
             </div> -->
         </div>
         
         {if $oNewsKat_arr|@count > 0 && $oNewsKat_arr}
         <div id="newsContent">            
            {foreach name=kategorieuebersicht from=$oNewsKat_arr item=oNewsKat}
                  <div class="newsBox">
                  <div class="newsTopTitle">
                  <h2 class="newsHeadline"><a href="{$oNewsKat->cURL}">{$oNewsKat->cBetreff}</a></h2>
                        </div>
                   <div class="newsTime">{$oNewsKat->dErstellt_de} | <a href="{$oNewsKat->cURL}#comments" title="{lang key="readComments" section="news"}">{$oNewsKat->nNewsKommentarAnzahl} {if $oNewsKat->nNewsKommentarAnzahl == 1}{lang key="newsComment" section="news"}{else}{lang key="newsComments" section="news"}{/if}</a>
                         </div>
                           <div class="newsArchivText">
                           {if $oNewsKat->cVorschauText|count_characters > 0}
                              {$oNewsKat->cVorschauText} 
                                        <div class="flt_right">
                                        {$oNewsKat->cMehrURL}
                                        </div>
                                        <div class="clearer"> </div>                     
                           {elseif $oNewsKat->cText|count_characters > 200}
                              {$oNewsKat->cText|truncate:200:$oNewsKat->cMehrURL}
                           {else}
                              {$oNewsKat->cText}
                           {/if}
                           </div>
                  
                  </div>
                {/foreach}               
         </div>
         {/if}
         
         
         <p><strong>&laquo;</strong> <a href="javascript:history.back()">{lang key="newsletterhistoryback" section="newsletter" alt_section="global,"}</a></p>
         
      </div>
   </div>
</div>