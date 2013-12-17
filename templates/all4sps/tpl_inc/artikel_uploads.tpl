{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}

{if $oUploadSchema_arr|@count > 0}        
<script type="text/javascript" src="{$currentTemplateDir}js/jquery.uploadify.js"></script>
<fieldset class="container">
   <legend>{lang key="uploadHeadline"}</legend>
   
   <p class="box_info">{lang key="maxUploadSize"}: <strong>{$cMaxUploadSize}</strong></p>
   
   {foreach from=$oUploadSchema_arr item=oUploadSchema name=schema}
      <table class="tiny">
         <thead>
            <th colspan="3" class="tleft">{$oUploadSchema->cName}</th>
         </thead>
         <tbody>         
         {foreach from=$oUploadSchema->oUpload_arr item=oUpload name=upload}
            <tr>
               <td>
                  <p class="upload_title">{$oUpload->cName}</p>
                  {if $oUpload->cBeschreibung|@count_characters > 0}
                     <p class="upload_desc">{$oUpload->cBeschreibung}</p>
                  {/if}
               </td>
               <td id="queue{$smarty.foreach.schema.index}{$smarty.foreach.upload.index}" class="uploadifyMsg {if $smarty.get.fillOut == 12 && ($oUpload->nPflicht && !$oUpload->bVorhanden)}uploadifyError{/if}{if $oUpload->bVorhanden}uploadifySuccess{/if}">
                  {if $smarty.get.fillOut == 12 && ($oUpload->nPflicht && !$oUpload->bVorhanden)}
                     {lang key="selectUpdateFile"}
                  {/if}
                  {if $oUpload->bVorhanden}
                     {$oUpload->cDateiname} ({$oUpload->cDateigroesse})
                  {/if}
               </td>
               <td class="tcenter" style="width:91px">
                  <input id="file_upload{$smarty.foreach.schema.index}{$smarty.foreach.upload.index}" type="file" class="hidden" />
               </td>
            </tr>
            
            <script type="text/javascript">
            $(document).ready(function() {ldelim}
              $('#file_upload{$smarty.foreach.schema.index}{$smarty.foreach.upload.index}').uploadify({ldelim}
               // swf
               'swf' : '{$ShopURL}/{$PFAD_UPLOADIFY}uploadify.swf',
              
               // callback settings
               'uploader' : '{$ShopURL}/{$PFAD_UPLOAD_CALLBACK}',
               'handler' : '{$ShopURL}/{$PFAD_UPLOAD_CALLBACK}',
               
               // autorun
               'auto' : true,
               
               // browse button
               'queueID' : 'queue{$smarty.foreach.schema.index}{$smarty.foreach.upload.index}',
               'buttonText': '{lang key="uploadBrowser"}',
               'width' : '90',
               
               // file upload settings
               'file_queue_limit' : 0,
               'fileTypeDesc' : 'Datei',
               'fileTypeExts' : '{$oUpload->cDateiListe}',
               'file_size_limit' : '{$nMaxUploadSize} B',
               
               // additional information
               'postData' : {ldelim} 'sid' : '{$cSessionID}',  'uniquename' : '{$oUpload->cUnique}' {rdelim},

               // event: upload just finished
               'onUploadComplete' : function(file, queue) {ldelim}
                  if (file.filestatus == SWFUpload.FILE_STATUS.COMPLETE)
                  {ldelim}
                     console.log(file);
                     $('#queue{$smarty.foreach.schema.index}{$smarty.foreach.upload.index}')
                        .addClass('uploadifySuccess')
                        .text(file.name + ' (' + formatSize(file.size) + ')');
                  {rdelim}
               {rdelim},

               // event: error occurred
               'onUploadError' : function(file, errorCode, errorMsg) {ldelim}
                  if (errorCode != SWFUpload.UPLOAD_ERROR.FILE_CANCELLED && errorCode != SWFUpload.UPLOAD_ERROR.UPLOAD_STOPPED)
                     $('#queue{$smarty.foreach.schema.index}{$smarty.foreach.upload.index}')
                        .addClass('uploadifyError')
                        .text('{lang key="uploadError"}');
                  else
                     $('#queue{$smarty.foreach.schema.index}{$smarty.foreach.upload.index}')
                        .addClass('uploadifyError')
                        .text('{lang key="uploadCanceled"}');
               {rdelim},
               
               // event: error after file selection
               'onSelectError' : function(file, errorCode, errorMsg) {ldelim}               
                  switch(errorCode) {ldelim}
                     case SWFUpload.QUEUE_ERROR.FILE_EXCEEDS_SIZE_LIMIT:
                        errorMsg = '{lang key="maxUploadSize"}: {$cMaxUploadSize}';
                        break;
                     case SWFUpload.QUEUE_ERROR.ZERO_BYTE_FILE:
                        errorMsg = '{lang key="uploadEmptyFile"}';
                        break;
                     case SWFUpload.QUEUE_ERROR.FILE_EXCEEDS_SIZE_LIMIT:
                        errorMsg = '{lang key="uploadInvalidFormat"} (' + this.fileTypeDesc + ').';
                        break;
                  {rdelim}
                  $('#queue{$smarty.foreach.schema.index}{$smarty.foreach.upload.index}')
                     .addClass('uploadifyError')
                     .text(errorMsg);
               {rdelim},
               
               // event: clear output
               'onSelect' : function(file) {ldelim}
                  $('#queue{$smarty.foreach.schema.index}{$smarty.foreach.upload.index}')
                     .removeClass('uploadifySuccess')
                     .removeClass('uploadifyError');
               {rdelim}                          
              {rdelim});
            {rdelim});
            </script>
            
         {/foreach}
         </tbody>
      </table>
   {/foreach}
</fieldset>
{/if}
