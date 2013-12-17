{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
<fieldset id="topsearch">
<legend>{lang key="manufacturer" section="comparelist" alt_section="productDetails,global,"}</legend>
<div id="box_all">
   <ol class="topsearch_table">
      {foreach name=hersteller from=$oHersteller_arr item=Hersteller}
         <li class="topsearchKeyword">
            <a href="{$Hersteller->cURL}" class="tagwolke{$tag->Klasse}">{$Hersteller->cName}</a>
            {if $smarty.foreach.hersteller.iteration%2==0}<p class="clearer">{if $smarty.foreach.hersteller.last != 1}</p>{/if}{/if}
         </li>
      {/foreach}
        </ol>
</div>
</fieldset>