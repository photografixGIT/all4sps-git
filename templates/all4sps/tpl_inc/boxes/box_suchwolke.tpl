{if $Boxen.Suchwolke->Suchbegriffe|@count > 0}
   <div class="sidebox" id="sidebox{$oBox->kBox}">
      <h3 class="boxtitle">{lang key="searchcloud" section="global"}</h3>
      <div class="sidebox_content">
         {if $Einstellungen.template.boxes.box_use_flash_cloud != "Y"}
            <div class="tagbox">
            {foreach name=suchwolken from=$Boxen.Suchwolke->Suchbegriffe item=Suchwolken}
               <a href="{$Suchwolken->cURL}" class="tag{$Suchwolken->Klasse}">{$Suchwolken->cSuche}</a>
            {/foreach}
            </div>
         {else}
            <object type="application/x-shockwave-flash" data="{$PFAD_FLASHCLOUD}tagcloud.swf" width="100%" height="100">
               <param name="movie" value="{$PFAD_FLASHCLOUD}tagcloud.swf" />
               <param name="wmode" value="transparent" />
               <param name="allowscriptaccess" value="always" />
               <param name="FlashVars" value="data_json={$Boxen.Suchwolke->SuchbegriffeJSON}" />
            </object>
         {/if}
      </div>
   </div>
{/if}

<!--
   boxen_tagging_count
-->
