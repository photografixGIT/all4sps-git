{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}

<div id="download_preview">
   <h1>{$oDownload->oDownloadSprache->getName()}</h1>
   <p>{$oDownload->oDownloadSprache->getBeschreibung()}</p>

   <div class="container">
   
      {assign var="height" value=71}
      {if $oDownload->getPreviewType() == 'video'}
         {assign var="height" value=300} 
      {/if}
      
      <object id="mediaplayer" width="100%" height="{$height}" classid="CLSID:6BF52A52-394A-11d3-B153-00C04F79FAA6" codebase="http://activex.microsoft.com/activex/controls/mplayer/en/nsmp2inf.cab#Version=5,1,52,701" standby="Lade Player-Plugins..." type="application/x-oleobject">
         <param name="URL" value="{$oDownload->getPreview()}" />
         <param name="Autostart" value="true" />
         <param name="ControlType" value="2" />
         <param name="AnimationatStart" value="false" />
         <param name="TransparentAtStart" value="true" />
         <param name="ShowControls" value="true" />
         <param name="ShowDisplay" value="false" />
         <param name="ShowCaptioning" value="false" />
         <param name="ShowStatusbar" value="false" />
         <param name="ShowTrackbar" value="false" />
         <param name="autosize" value="false" />
         <embed name="mediaplayer" width="100%" height="{$height}" type="application/x-mplayer2" src="{$oDownload->getPreview()}" autostart="true" showstatusbar="1" ></embed>
      </object>
      
   </div>
   
   <div id="popup_close">
      <button type="button" class="submit" onclick="window.close()">Fenster schlieﬂen</button>
   </div>
   
</div>