{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
 <div id="jtl_rma">
 <h3>{lang key="rma" section="global"}</h3>
    <table class="tiny">
      <thead>
         <tr>
            <th>{lang key="rma_number" section="rma"}</th>
            <th>{lang key="rma_status" section="rma"}</th>                        
              <th class="tcenter">{lang key="rma_products" section="rma"}</th>
              <th>{lang key="rma_created" section="rma"}</th>
           </tr>
      </thead>
       <tbody>
       {foreach name=rmas from=$oRMA_arr item=oRMA}
          <tr>
             <td class="p20 vtop">{$oRMA->getRMANumber()}</td>
             <td class="vtop">{$oRMA->oRMAStatus->getStatus()}</td>                           
             <td class="vtop">
               <ul>
               {foreach name=rmaartikel from=$oRMA->oRMAArtikel_arr item=oRMAArtikel}
                   <li>{$oRMAArtikel->cArtikelName}</li>
                {/foreach}
                </ul>
            </td>
             <td class="vtop">{$oRMA->getErstellt()}</td>
          </tr>
      {/foreach}
       </tbody>
   </table>
</div>