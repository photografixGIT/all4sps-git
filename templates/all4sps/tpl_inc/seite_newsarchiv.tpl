{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
<div id="welcome" class="post">
   <h2 class="title"><img src="{$currentTemplateDir}gfx/configTPL.png" alt="" style="vertical-align:middle" /> <span>{$cMonat}</span></h2>
   <div style="border-bottom: 1px solid #000000"></div>
   <div class="content">
      <p>{lang key="newsArchivDesc" section="global"}</p>
    </div>
</div>

{if $oNewsArchiv_arr|@count > 0}
<div class="container">               
   <table>
   {foreach name=newsarchiv from=$oNewsArchiv_arr item=oNewsArchiv}
      <tr>
         <td valign="top" align="left" style="background: #F2F2F2;width: 33%;">
         
            <table>
               <tr>
                  <td><a href="{$oNewsArchiv->cURL}"><h1><font color="#000000"><b>{$oNewsArchiv->cBetreff}</b></font></h1></a></td>
               </tr>
               <tr>
                  <td>{$oNewsArchiv->dErstellt_de} | {$oNewsArchiv->nNewsKommentarAnzahl} {if $oNewsArchiv->nNewsKommentarAnzahl == 1}{lang key="newsComment" section="news"}{else}{lang key="newsComments" section="news"}{/if}</td>
               </tr>
               <tr>
                  <td>{$oNewsArchiv->cText}</td>
               </tr>
            </table>   
         
         </td>
      </tr>
      <tr>
         <td>&nbsp;</td>
      </tr>
   {/foreach}
   </table>               
</div>
{/if}

<br>
{if $oNewsMonatNavi_arr|@count > 0}
<h2>{lang key="newsMonthOverview" section="news"}</h2>
<div style="border-bottom: 1px solid #000000"></div><br>
{foreach name=monatsnavigation from=$oNewsMonatNavi_arr item=oNewsMonatNavi}
<a href="news.php?m={$oNewsMonatNavi->nMonat}" class="artikelnamelink">{$oNewsMonatNavi->Datum} ({$oNewsMonatNavi->nAnzahl})</a><br>
{/foreach}
{/if}

<br><br>
<p><a href="javascript:history.back()">{lang key="newsletterhistoryback" section="newsletter" alt_section="global,"}</a></p>