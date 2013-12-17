<div style="margin:10px 0;">
   {if $status == 'error'}
      <strong>{$error}</strong>
   {else}
      {lang key="saferpayDesc" section="checkout"}
      {strip}
      <div>
         <a href="{$url}">
            <img src="{$currentTemplateDir}../../gfx/Saferpay/logo.gif" alt="Saferpay Logo" />
         </a>
      </div>
      {/strip}
   {/if}
</div>