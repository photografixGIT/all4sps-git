{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
<div id="content">
   {include file='tpl_inc/inc_breadcrumb.tpl'}
   <h1>{lang key="umfrage" section="umfrage"}</h1>
   
   {if $hinweis}<p class="box_success">{$hinweis}</p>{/if}
   {if $fehler}<p class="box_error">{$fehler}</p>{/if}
   
   {include file="tpl_inc/inc_extension.tpl"}
   
   {if $oUmfrage_arr|@count > 0 && $oUmfrage_arr}
   <div id="voting_overview">
   {foreach name=umfrageuebersicht from=$oUmfrage_arr item=oUmfrage}
      <h3 {if $smarty.foreach.umfrageuebersicht.first}class="nospacing"{/if}><a href="{$oUmfrage->cURL}">{$oUmfrage->cName}</a></h3></td>
      <p><small>{$oUmfrage->dGueltigVon_de} | {$oUmfrage->nAnzahlFragen} {if $oUmfrage->nAnzahlFragen == 1}{lang key="umfrageQ" section="umfrage"}{else}{lang key="umfrageQs" section="umfrage"}{/if}</small></p>
      <p>{$oUmfrage->cBeschreibung}</p>
   {/foreach}
   </div>
   {/if}
   {include file='tpl_inc/inc_seite.tpl'}
</div>
