{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}
 
{include file='tpl_inc/header.tpl'}
<div id="content">
   {include file='tpl_inc/inc_breadcrumb.tpl'}
   <h1>{lang key="productRating" section="product rating"}</h1>
   
   <form method="post"   action="bewertung.php" class="form">
   {if $BereitsBewertet == 1}
      <p class="box_error">{lang key="allreadyWroteReview" section="product rating"}</p>
   {elseif $nArtikelNichtGekauft == 1}
      <p class="box_error">{lang key="productNotBuyed" section="product rating"}</p>
   {/if}
   
   {if $smarty.session.Kunde->kKunde == 0 || !$smarty.session.Kunde->kKunde}
      <p class="box_error">{lang key="loginFirst" section="product rating"}</p>
   {elseif $BereitsBewertet == 0 && $smarty.session.Kunde->kKunde > 0 && (!$nArtikelNichtGekauft || $nArtikelNichtGekauft == 0)}
      <p class="box_info">{lang key="shareYourRatingGuidelines" section="product rating"}.</p>
      
      <div class="container vmiddle">
         {if $Artikel->Bilder[0]->cPfadMini|@strlen > 0}
            <img src="{$Artikel->Bilder[0]->cPfadMini}" class="image vmiddle" />
         {/if}
         <span class="vmiddle">{$Artikel->cName}</span>
      </div>
      
      <fieldset>
         <legend>{lang key="productRating" section="product rating"}</legend>
            
         <ul class="input_block">
            <li>
               <label for="stars">{lang key="starPlural" section="product rating" alt_section="global,"}:<em>*</em></label>
               <select name="nSterne" id="stars">
                  <option value="5">5 {lang key="starPlural" section="product rating" alt_section="global,"}</option>
                  <option value="4">4 {lang key="starPlural" section="product rating" alt_section="global,"}</option>
                  <option value="3">3 {lang key="starPlural" section="product rating" alt_section="global,"}</option>
                  <option value="2">2 {lang key="starPlural" section="product rating" alt_section="global,"}</option>
                  <option value="1">1 {lang key="starSingular" section="product rating" alt_section="global,"}</option>
               </select>
            </li>
         
            <li class="clear">
               <label for="headline">{lang key="headline" section="product rating"}:<em>*</em></label>
               <input type="text" name="cTitel" value="" id="headline" />
            </li>
            
            <li class="clear">
               <label for="comment">{lang key="comment" section="product rating" alt_section="shipping payment,productDetails,"}:<em>*</em></label>
               <textarea name="cText" class="expander" cols="80" rows="8" id="comment"></textarea>
            </li>
         </ul>
      </fieldset>
      
      <input name="bfh" type="hidden" value="1" />
      <input name="a" type="hidden" value="{$Artikel->kArtikel}" />
      <input type="hidden" name="{$session_name}" value="{$session_id}" />
      <input name="submit" type="submit" value="{lang key="submitRating" section="product rating"}" class="submit" />
   {/if}
   </form>   
</div>
{include file='tpl_inc/footer.tpl'}