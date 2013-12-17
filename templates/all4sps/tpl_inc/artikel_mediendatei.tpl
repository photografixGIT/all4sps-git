{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
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

{if $Artikel->oMedienDatei_arr && $Artikel->oMedienDatei_arr|@count > 0}
   {foreach name="mediendateien" from=$Artikel->oMedienDatei_arr item=oMedienDatei}   
      {if ($cMedienTyp == $oMedienDatei->cMedienTyp && $oMedienDatei->cAttributTab|count_characters == 0) || ($oMedienDatei->cAttributTab|count_characters > 0 && $cMedienTyp == $oMedienDatei->cAttributTab)}
         {if $oMedienDatei->nErreichbar == 0}
            <p class="box_error">
               {lang key="noMediaFile" section="errorMessages"}
            </p>
         {else}
            <!-- Bilder -->
            {if $oMedienDatei->nMedienTyp == 1}
               <table>
                  <tr>
                     <td valign="top"><b>{$oMedienDatei->cName}:</b></td>
                  </tr>
                  <tr>
                     <td valign="top">{$oMedienDatei->cBeschreibung}</td>
                  </tr>
                  <tr>
                     <td>                     
                        {if $oMedienDatei->cPfad|count_characters > 0}
                           <img src="{$PFAD_MEDIAFILES}{$oMedienDatei->cPfad}">
                        {else if $oMedienDatei->cURL|count_characters > 0}
                           <img src="{$oMedienDatei->cURL}">
                        {/if}
                     </td>
                  </tr>
               </table><br>
               
            <!-- Audio -->
            {elseif $oMedienDatei->nMedienTyp == 2}            
               <table>
                  <tr>
                     <td valign="top"><b>{$oMedienDatei->cName}:</b></td>
                  </tr>
                  <tr>
                     <td valign="top">{$oMedienDatei->cBeschreibung}</td>
                  </tr>
                  <tr>
                     <td>                     
                        {if $oMedienDatei->cPfad|count_characters > 0}                     
                           <object type="application/x-shockwave-flash" data="{$PFAD_FLASHPLAYER}player_mp3_maxi.swf" width="200" height="20">
                               <param name="movie" value="{$PFAD_FLASHPLAYER}player_mp3_maxi.swf" />
                               <param name="bgcolor" value="#ffffff" />
                               <param name="FlashVars" value="mp3={$PFAD_MEDIAFILES}{$oMedienDatei->cPfad}&width=200&height=20&showvolume=1" />
                           </object>
                        {else if $oMedienDatei->cURL|count_characters > 0}                        
                           <object type="application/x-shockwave-flash" data="{$PFAD_FLASHPLAYER}player_mp3_maxi.swf" width="200" height="20">
                               <param name="movie" value="{$PFAD_FLASHPLAYER}player_mp3_maxi.swf" />
                               <param name="bgcolor" value="#ffffff" />
                               <param name="FlashVars" value="mp3={$oMedienDatei->cURL}&width=200&height=20&showvolume=1" />
                           </object>
                        {/if}                     
                     </td>
                  </tr>
               </table><br>
               
            <!-- Video -->
            {elseif $oMedienDatei->nMedienTyp == 3}
               <table>
                  <tr>
                     <td valign="top"><b>{$oMedienDatei->cName}:</b></td>
                  </tr>
                  <tr>
                     <td valign="top">{$oMedienDatei->cBeschreibung}</td>
                  </tr>
                  <tr>
                     <td>
                        {if $oMedienDatei->cPfad|count_characters > 0}                        
                           <object type="application/x-shockwave-flash" data="{$PFAD_FLASHPLAYER}player_flv_multi.swf" width="320" height="240">
                               <param name="movie" value="{$PFAD_FLASHPLAYER}player_flv_maxi.swf" />
                               <param name="allowFullScreen" value="true" />
                               <param name="FlashVars" value="flv={$PFAD_MEDIAFILES}{$oMedienDatei->cPfad}&width=320&height=240&showvolume=1&showtime=1&showfullscreen=1" />
                           </object>
                        {else if $oMedienDatei->cURL|count_characters > 0}                  
                           <object type="application/x-shockwave-flash" data="{$PFAD_FLASHPLAYER}player_flv_multi.swf" width="320" height="240">
                               <param name="movie" value="{$PFAD_FLASHPLAYER}player_flv_maxi.swf" />
                               <param name="allowFullScreen" value="true" />
                               <param name="FlashVars" value="flv={$oMedienDatei->cURL}&width=320&height=240&showvolume=1&showtime=1&showfullscreen=1" />
                           </object>
                        {/if}
                     </td>
                  </tr>
               </table><br>
               
            <!-- Sonstiges -->
            {elseif $oMedienDatei->nMedienTyp == 4}
               <table>
                  <tr>
                     <td valign="top"><b>{$oMedienDatei->cName}:</b></td>
                  </tr>
                  <tr>
                     <td valign="top">{$oMedienDatei->cBeschreibung}</td>
                  </tr>
                  <tr>
                     <td>         
                        {if $oMedienDatei->cPfad|count_characters > 0}
                           <a href="{$PFAD_MEDIAFILES}{$oMedienDatei->cPfad}" target="_blank">{$oMedienDatei->cName}</a>
                        {else if $oMedienDatei->cURL|count_characters > 0}
                           <a href="{$oMedienDatei->cURL}" target="_blank">{$oMedienDatei->cName}</a>      
                        {/if}
                     </td>
                  </tr>
               </table><br>
            
            <!-- PDF -->
            {elseif $oMedienDatei->nMedienTyp == 5}
               <table>
                  <tr>
                     <td valign="top"><b>{$oMedienDatei->cName}:</b></td>
                  </tr>
                  <tr>
                     <td valign="top">{$oMedienDatei->cBeschreibung}</td>
                  </tr>
                  <tr>
                     <td>
                        {if $oMedienDatei->cPfad|count_characters > 0}
                           <a href="{$PFAD_MEDIAFILES}{$oMedienDatei->cPfad}" target="_blank"><img src="{$PFAD_BILDER}intern/file-pdf.png" /></a><br>
                           <a href="{$PFAD_MEDIAFILES}{$oMedienDatei->cPfad}" target="_blank">{$oMedienDatei->cName}</a>
                        {else if $oMedienDatei->cURL|count_characters > 0}
                           <a href="{$oMedienDatei->cURL}" target="_blank"><img src="{$PFAD_BILDER}intern/file-pdf.png" /></a><br>
                           <a href="{$oMedienDatei->cURL}" target="_blank">{$oMedienDatei->cName}</a>
                        {/if}
                     </td>
                  </tr>
               </table><br>
            {/if}
         {/if}
      {/if}
   {/foreach}
{/if}