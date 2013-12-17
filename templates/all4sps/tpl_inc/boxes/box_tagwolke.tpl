<div class="sidebox" id="sidebox{$oBox->kBox}">
<form id="hst" action="navi.php" method="post">
    <h3 class="boxtitle">{lang key="tagcloud" section="global"}</h3>
    <div class="sidebox_content tcenter">
        {if $Einstellungen.template.boxes.box_use_flash_cloud != "Y"}
            <div class="tagbox">
                {foreach name=suchwolken from=$Boxen.Tagwolke->Tagbegriffe item=Wolke}
                   <a href="{$Wolke->cURL}" class="tag{$Wolke->Klasse}">{$Wolke->cSuche}</a>
                {/foreach}
            </div>
        {else}
            <object type="application/x-shockwave-flash" data="{$PFAD_FLASHCLOUD}tagcloud.swf" width="100%" height="100">
               <param name="movie" value="{$PFAD_FLASHCLOUD}tagcloud.swf" />
               <param name="wmode" value="transparent" />
               <param name="allowscriptaccess" value="always" />
               <param name="FlashVars" value="data_json={$Boxen.Tagwolke->TagbegriffeJSON}" />
            </object>
        {/if}
    </div>
</form>
</div>
