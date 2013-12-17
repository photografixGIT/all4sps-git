{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}

{if isset($Artikel->oDownload_arr) && $Artikel->oDownload_arr|@count > 0}
<div class="clear"></div>
<div id="article_downloads">

   <table class="tiny">
      <thead>
         <tr>
            <th class="tcenter" width="35"></th>
            <th class="tleft" width="200">Name</th>
            <th class="tleft">Beschreibung</th>
            <th class="tcenter" width="65">Format</th>
            <th class="tcenter" width="115">Aktionen</th>
         </tr>
      </thead>
      <tbody>
         {foreach name=downloads from=$Artikel->oDownload_arr item=oDownload}
         {if isset($oDownload->oDownloadSprache)}
            <tr>
               <td class="tcenter">{$smarty.foreach.downloads.index+1}.</td>
               <td class="tleft">{$oDownload->oDownloadSprache->getName()}</td>
               <td class="tleft">{$oDownload->oDownloadSprache->getBeschreibung()}</td>
               <td class="tcenter">{$oDownload->getExtension()}</td>
               <td class="tcenter">
                  {if $oDownload->hasPreview()}
                    
                     {if $oDownload->getPreviewType() == 'music' || $oDownload->getPreviewType() == 'video'}
                        <a href="#" onclick="return open_window('{$ShopURL}/popup.php?a=download_vorschau&k={$oDownload->getDownload()}', 480, 320);" class="btn_play">x</a>
                     {elseif $oDownload->getPreviewType() == 'image'}
                       
                        {assign var=nNameLength value=50}
                        {assign var=nImageMaxWidth value=480}
                        {assign var=nImageMaxHeight value=320}
                        {assign var=nImagePreviewWidth value=35}

                        <span class="image_preview zoomcur" ref="{$oDownload->getPreview()}" maxwidth="{$nImageMaxWidth}" maxheight="{$nImageMaxHeight}" title="{$oDownload->oDownloadSprache->getName()}">
                           <img src="{$oDownload->getPreview()}" alt="{$oUpload->cName}" width="{$nImagePreviewWidth}" class="vmiddle" />
                        </span>
                     {else}
                     
                        {* nothing todo *}
                     
                     {/if}
                     
                  {/if}
               </td>
            </tr>
         {/if}
         {/foreach}
      </tbody>
   </table>
</div>
{/if}