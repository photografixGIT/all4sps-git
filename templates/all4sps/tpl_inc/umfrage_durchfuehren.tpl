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

   {if $hinweis}<p class="box_info">{$hinweis}</p>{/if}
   {if $fehler}<p class="box_error">{$fehler}</p>{/if}

   {if $oUmfrage->oUmfrageFrage_arr|@count > 0 && $oUmfrage->oUmfrageFrage_arr}
   <form method="post" action="umfrage.php" class="form">
   <input name="u" type="hidden" value="{$oUmfrage->kUmfrage}">
   <input name="{$session_name}" type="hidden" value="{$session_id}">

   {foreach name=umfragefrage from=$oUmfrage->oUmfrageFrage_arr item=oUmfrageFrage}
   {assign var=kUmfrageFrage value=`$oUmfrageFrage->kUmfrageFrage`}      
   <input name="kUmfrageFrage[]" type="hidden" value="{$oUmfrageFrage->kUmfrageFrage}">

   <div>
      <fieldset class="vote_item">
         <legend>{$oUmfrageFrage->cName}{if $oUmfrageFrage->nNotwendig == 1}<em>*</em>{/if}</legend>
         <p>{$oUmfrageFrage->cBeschreibung}</p>
         
         <div>
            {if $oUmfrageFrage->cTyp == "select_single"}
            <tr>
               <td valign="top" align="left" >
                  <select name="{$oUmfrageFrage->kUmfrageFrage}[]">
            {/if}
            
            {if $oUmfrageFrage->cTyp == "select_multi"}
            <tr>
               <td valign="top" align="left" >
                  <select name="{$oUmfrageFrage->kUmfrageFrage}[]" multiple="multiple">   
            {/if}
            
            {if $oUmfrageFrage->cTyp == "text_klein"}
               <tr>
                  <td valign="top" align="left" ><input name="{$oUmfrageFrage->kUmfrageFrage}[]" type="text" value="{$nSessionFragenWerte_arr[$kUmfrageFrage]->cUmfrageFrageAntwort_arr[0]}"></td>
               </tr>
               <tr>
                  <td>&nbsp;</td>
               </tr>
            {/if}
            
            {if $oUmfrageFrage->cTyp == "text_gross"}
               <tr>
                  <td valign="top" align="left" ><textarea name="{$oUmfrageFrage->kUmfrageFrage}[]" rows="7" cols="60">{$nSessionFragenWerte_arr[$kUmfrageFrage]->cUmfrageFrageAntwort_arr[0]}</textarea></td>
               </tr>
               <tr>
                  <td>&nbsp;</td>
               </tr>
            {/if}
            
            {if $oUmfrageFrage->cTyp == "matrix_single"}
               <tr>
                  <td>
                     <table>
                        <tr>
                           <td>&nbsp;</td>
                           {foreach name=umfragematrixoption from=$oUmfrageFrage->oUmfrageMatrixOption_arr item=oUmfrageMatrixOption}
                              <td>{$oUmfrageMatrixOption->cName}</td>
                           {/foreach}                           
                        </tr>                        
            {/if}
            
            {if $oUmfrageFrage->cTyp == "matrix_multi"}
               <tr>
                  <td>
                     <table>
                        <tr>
                           <td>&nbsp;</td>
                           {foreach name=umfragematrixoption from=$oUmfrageFrage->oUmfrageMatrixOption_arr item=oUmfrageMatrixOption}
                              <td>{$oUmfrageMatrixOption->cName}</td>
                           {/foreach}                           
                        </tr>
            {/if}
         
         {foreach name=umfragefrageantwort from=$oUmfrageFrage->oUmfrageFrageAntwort_arr item=oUmfrageFrageAntwort}
         {assign var=i value=`$smarty.foreach.umfragefrageantwort.iteration-1`}   
         
         {if $oUmfrageFrage->cTyp == "multiple_single"}
            <tr>
               <td valign="top" align="left" >
                  <label><input name="{$oUmfrageFrage->kUmfrageFrage}[]" type="radio" value="{$oUmfrageFrageAntwort->kUmfrageFrageAntwort}"
                  {foreach name="cumfragefrageantwort" from=$nSessionFragenWerte_arr[$kUmfrageFrage]->cUmfrageFrageAntwort_arr item=cUmfrageFrageAntwort}
                     {if $cUmfrageFrageAntwort == $oUmfrageFrageAntwort->kUmfrageFrageAntwort} checked="checked"{/if}
                  {/foreach}   
                  > {$oUmfrageFrageAntwort->cName}</label>
               </td>
            </tr>
            <tr>
               <td></td>
            </tr>
         {/if}
         
         {if $oUmfrageFrage->cTyp == "multiple_multi"}
            <label><input name="{$oUmfrageFrage->kUmfrageFrage}[]" type="checkbox" value="{$oUmfrageFrageAntwort->kUmfrageFrageAntwort}"
                  {foreach name=cumfragefrageantwort from=$nSessionFragenWerte_arr[$kUmfrageFrage]->cUmfrageFrageAntwort_arr item=cUmfrageFrageAntwort}
                     {if $cUmfrageFrageAntwort == $oUmfrageFrageAntwort->kUmfrageFrageAntwort} checked="checked"{/if}
                  {/foreach}   
                  > {$oUmfrageFrageAntwort->cName}</label>
         {/if}
         
         {if $oUmfrageFrage->cTyp == "select_single"}
            <option value="{$oUmfrageFrageAntwort->kUmfrageFrageAntwort}"
            {foreach name=cumfragefrageantwort from=$nSessionFragenWerte_arr[$kUmfrageFrage]->cUmfrageFrageAntwort_arr item=cUmfrageFrageAntwort}
               {if $cUmfrageFrageAntwort == $oUmfrageFrageAntwort->kUmfrageFrageAntwort} selected{/if}
            {/foreach}
            > {$oUmfrageFrageAntwort->cName}</option>
         {/if}
         
         {if $oUmfrageFrage->cTyp == "select_multi"}
            <option value="{$oUmfrageFrageAntwort->kUmfrageFrageAntwort}"
            {foreach name=cumfragefrageantwort from=$nSessionFragenWerte_arr[$kUmfrageFrage]->cUmfrageFrageAntwort_arr item=cUmfrageFrageAntwort}
               {if $cUmfrageFrageAntwort == $oUmfrageFrageAntwort->kUmfrageFrageAntwort} selected{/if}
            {/foreach}
            > {$oUmfrageFrageAntwort->cName}</option>
         {/if}
         
         {if $oUmfrageFrage->cTyp == "matrix_single"}
            <tr>
               <td>{$oUmfrageFrageAntwort->cName}</td>
            {foreach name=umfragematrixoption from=$oUmfrageFrage->oUmfrageMatrixOption_arr item=oUmfrageMatrixOption}
            {assign var=i value=`$smarty.foreach.umfragefrageantwort.iteration-1`}   
               <td>
                  <label><input name="{$oUmfrageFrage->kUmfrageFrage}_{$oUmfrageFrageAntwort->kUmfrageFrageAntwort}" type="radio" value="{$oUmfrageFrageAntwort->kUmfrageFrageAntwort}_{$oUmfrageMatrixOption->kUmfrageMatrixOption}"
                  {foreach name=cumfragefrageantwort from=$nSessionFragenWerte_arr[$kUmfrageFrage]->cUmfrageFrageAntwort_arr item=oUmfrageFrageAntwortTMP}
                     {if $oUmfrageFrageAntwortTMP->kUmfrageFrageAntwort == $oUmfrageFrageAntwort->kUmfrageFrageAntwort && $oUmfrageMatrixOption->kUmfrageMatrixOption == $oUmfrageFrageAntwortTMP->kUmfrageMatrixOption} checked{/if}
                  {/foreach}
                  ></label>
               </td>
            {/foreach}
            </tr>
         {/if}
         
         {if $oUmfrageFrage->cTyp == "matrix_multi"}
            <tr>
               <td>{$oUmfrageFrageAntwort->cName}</td>
            {foreach name=umfragematrixoption from=$oUmfrageFrage->oUmfrageMatrixOption_arr item=oUmfrageMatrixOption}
            {assign var=i value=`$smarty.foreach.umfragefrageantwort.iteration-1`}   
               <td>
                  <input name="{$oUmfrageFrage->kUmfrageFrage}[]" type="checkbox" value="{$oUmfrageFrageAntwort->kUmfrageFrageAntwort}_{$oUmfrageMatrixOption->kUmfrageMatrixOption}"
                  {foreach name=cumfragefrageantwort from=$nSessionFragenWerte_arr[$kUmfrageFrage]->cUmfrageFrageAntwort_arr item=oUmfrageFrageAntwortTMP}
                     {if $oUmfrageFrageAntwortTMP->kUmfrageFrageAntwort == $oUmfrageFrageAntwort->kUmfrageFrageAntwort && $oUmfrageMatrixOption->kUmfrageMatrixOption == $oUmfrageFrageAntwortTMP->kUmfrageMatrixOption} checked{/if}
                  {/foreach}
                  >
               </td>
            {/foreach}
            </tr>
         {/if}
         
         {/foreach}
            {if $oUmfrageFrage->cTyp == "select_single"}
                  </select>
               </td>               
            </tr>
            <tr>
               <td>&nbsp;</td>
            </tr>
            {/if}
            
            {if $oUmfrageFrage->cTyp == "select_multi"}
                  </select>
               </td>                  
            </tr>
            <tr>
               <td>&nbsp;</td>
            </tr>
            {/if}   
            
            {if $oUmfrageFrage->cTyp == "matrix_single"}
                     </table>
                  </td>
               <tr>
                  <td>&nbsp;</td>
               </tr>
               </tr>                  
            {/if}
            
            {if $oUmfrageFrage->cTyp == "matrix_multi"}
                     </table>
                  </td>
               <tr>
                  <td>&nbsp;</td>
               </tr>
               </tr>
            {/if}            
            
            {if $oUmfrageFrage->nFreifeld == 1}
               {if $oUmfrageFrage->cTyp == "multiple_single"}
                  <tr>
                     <td valign="top" align="left" >
                        <label><input name="{$oUmfrageFrage->kUmfrageFrage}[]" type="radio" value="-1"
                        {foreach name=cumfragefrageantwort from=$nSessionFragenWerte_arr[$kUmfrageFrage]->cUmfrageFrageAntwort_arr item=cUmfrageFrageAntwort}
                           {if $cUmfrageFrageAntwort == "-1"} checked{/if}
                        {/foreach}                           
                        > <input name="{$oUmfrageFrage->kUmfrageFrage}[]" type="text" value="{$nSessionFragenWerte_arr[$kUmfrageFrage]->cUmfrageFrageAntwort_arr[1]}">
                        </label>
                     </td>
                  </tr>
                  <tr>
                     <td></td>
                  </tr>
                  
               {elseif $oUmfrageFrage->cTyp == "multiple_multi"}
                  <tr>
                     <td valign="top" align="left" >
                        <input name="{$oUmfrageFrage->kUmfrageFrage}[]" type="checkbox" value="-1"
                        {foreach name=cumfragefrageantwort from=$nSessionFragenWerte_arr[$kUmfrageFrage]->cUmfrageFrageAntwort_arr item=cUmfrageFrageAntwort}
                           {if $cUmfrageFrageAntwort == "-1"} checked{/if}
                        {/foreach}
                        > <input name="{$oUmfrageFrage->kUmfrageFrage}[]" type="text" value="{$nSessionFragenWerte_arr[$kUmfrageFrage]->cUmfrageFrageAntwort_arr[1]}"></td>
                  </tr>
                  <tr>
                     <td></td>
                  </tr>      
            
               {else}
                  <tr>
                     <td valign="top" align="left" >
                        <input name="{$oUmfrageFrage->kUmfrageFrage}[]" type="text" value="{$nSessionFragenWerte_arr[$kUmfrageFrage]->cUmfrageFrageAntwort_arr[1]}"
                        {foreach name=cumfragefrageantwort from=$nSessionFragenWerte_arr[$kUmfrageFrage]->cUmfrageFrageAntwort_arr item=cUmfrageFrageAntwort}
                           {if $cUmfrageFrageAntwort == "-1"} checked{/if}
                        {/foreach}
                        >
                     </td>
                  </tr>
                  <tr>
                     <td></td>
                  </tr>
               {/if}
            {/if}
         </div>
      </fieldset>
   </div>

   {/foreach}
   {/if}
   <br>
 
   <div class="box_info">
      <ul class="hlist">
         <li class="p33">
            <b>{lang key="umfrageQPage" section="umfrage"} {$nAktuelleSeite}</b> {lang key="from" section="product rating" alt_section="login,productDetails,productOverview,global,"} {$nAnzahlSeiten}
         </li>
         <li class="p33">
            &nbsp;{if $nAktuelleSeite <= $nAnzahlSeiten && $nAktuelleSeite != 1}<button class="input" name="back" type="submit" value="back"><span>&laquo; {lang key="umfrageBack" section="umfrage"}</span></button>{/if}
            {if $nAktuelleSeite > 0 && $nAktuelleSeite < $nAnzahlSeiten}<button class="input" name="next" type="submit" value="next"><span>{lang key="umfrageNext" section="umfrage"} &raquo;</span></button>{/if}&nbsp;
         </li>
         <li class="p33 tright">
            <em>*</em> {lang key="umfrageQRequired" section="umfrage"}
         </li>
      </ul>
   </div>
   
   <input name="s" type="hidden" value="{$nAktuelleSeite}" />
   {if $nAktuelleSeite == $nAnzahlSeiten}
      <input name="end" type="submit" value="{lang key="umfrageSubmit" section="umfrage"}" class="submit" />
   {/if}
   </form>
   {include file='tpl_inc/inc_seite.tpl'}
</div>