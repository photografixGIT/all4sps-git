{*
-------------------------------------------------------------------------------
    JTL-Shop 3
    File: rma_success.tpl, smarty template inc file
    
    page for JTL-Shop 3
    
    Author: daniel.boehmer@bb-network.de
-------------------------------------------------------------------------------
*}

<div id="rma_overview">
   {if $cHinweis}<p class="box_info">{$cHinweis}</p>{/if}
   
   {lang key="rma_success_msg_1" section="rma"}<br /><br />
   
{if isset($oRMA->oRMAArtikel_arr) && $oRMA->oRMAArtikel_arr|@count > 0}
   {foreach name=rmartikel from=$oRMA->oRMAArtikel_arr item=oRMAArtikel}
      <p>{$oRMAArtikel->cArtikelName}></p>
   {/foreach}
{/if}
   
   {lang key="rma_success_msg_2" section="rma"} {$Einstellungen.global.global_shopname}<br /><br />
   
   <strong>Empfängeradresse:</strong>
   {if isset($Einstellungen.rma.rma_receiver_name) && $Einstellungen.rma.rma_receiver_name|count_characters > 0}<p>{$Einstellungen.rma.rma_receiver_name}</p>{/if}
   {if isset($Einstellungen.rma.rma_receiver_extra) && $Einstellungen.rma.rma_receiver_extra|count_characters > 0}<p>{$Einstellungen.rma.rma_receiver_extra}</p>{/if}
   {if isset($Einstellungen.rma.rma_receiver_street) && $Einstellungen.rma.rma_receiver_street|count_characters > 0}<p>{$Einstellungen.rma.rma_receiver_street}</p>{/if}
   {if isset($Einstellungen.rma.rma_receiver_town) && $Einstellungen.rma.rma_receiver_town|count_characters > 0}<p>{$Einstellungen.rma.rma_receiver_town}</p>{/if}
   {if isset($Einstellungen.rma.rma_receiver_email) && $Einstellungen.rma.rma_receiver_email|count_characters > 0}<p>{$Einstellungen.rma.rma_receiver_email}</p>{/if}
</div>