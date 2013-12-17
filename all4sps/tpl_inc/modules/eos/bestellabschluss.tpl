<div style="margin:10px 0;">
   {if $status == 'error'}
      <strong>{$error}</strong>
   {else}
      {*{lang key="eosDesc" section=""}*}
      
      {$iFrame}
   {/if}
</div>