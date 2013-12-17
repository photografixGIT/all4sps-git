<div style="margin:10px 0;">
   {if $status == 'error'}
      <strong>{$error}</strong>
   {else}
      {strip}
      <div style="margin:10px 0;">
         <iframe src="{$url}" width="600" height="400" name="MoneyBookersFrame">
            {lang key="moneybookersQCDesc" section=""}
            {if $imageSource}
               <a href="{$url}">
                  <img src="{$imageSource}" alt="Logo {$caption}" />
               </a>
            {else}
               <form method="get" action="{$url}">
                  <input type="submit" value="{$caption}"/>
               </form>   
            {/if}
         </iframe>
      </div>
      {/strip}
   {/if}
</div>