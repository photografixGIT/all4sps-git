{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}

 

{*assign var="Brotnavi" value="Ankauf"*}


{include file='tpl_inc/header.tpl'}
<div id="content">
   {include file='tpl_inc/inc_breadcrumb.tpl'}
    <h1>{lang key="ankauf_anfrage" section="global"}</h1>
    
    {if $hinweis}
        <br>
        <div class="box_info">
            {$hinweis}
        </div>
    {/if}
    {if $fehler}
        <br>
        <div class="box_error">
            {$fehler}
        </div>
    {/if}
    <br>
    
    {include file="tpl_inc/inc_extension.tpl"}
   
   
      

      <form class="form" name="ankauf_anfrageformular" id="ankauf_anfrageformular" action="/process_enquery_long.php" method="post" enctype="multipart/form-data">
         <fieldset>
            <legend>{lang key="contact" section="global"}</legend>
            <ul class="input_block">
               {if $Einstellungen.kontakt.kontakt_abfragen_anrede!="N"}
               <li>
                  <label for="salutation">{lang key="salutation" section="account data"}{if $Einstellungen.kontakt.kontakt_abfragen_anrede=="Y"}<em>*</em>{/if}:</label>
                  <select name="anrede" id="salutation" required>
                     <option value="m" {if $Vorgaben->cAnrede == "m"}selected="selected"{/if}>{$Anrede_m}</option>
                     <option value="w" {if $Vorgaben->cAnrede == "w"}selected="selected"{/if}>{$Anrede_w}</option>
                  </select>
               </li>
               {/if}
               {if $Einstellungen.kontakt.kontakt_abfragen_vorname!="N"}
               <li class="clear {if $fehlendeAngaben.vorname>0}error_block{/if}">
                  <label for="firstName">{lang key="firstName" section="account data"}{if $Einstellungen.kontakt.kontakt_abfragen_vorname=="Y"}<em>*</em>{/if}:</label>
                  <input type="text" name="vorname" value="{$Vorgaben->cVorname}" id="firstName" required />
                  {if $fehlendeAngaben.vorname>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
               </li>
               {/if}
               {if $Einstellungen.kontakt.kontakt_abfragen_nachname!="N"}
               <li {if $fehlendeAngaben.nachname>0}class="error_block"{/if}>
                  <label for="lastName">{lang key="lastName" section="account data"}{if $Einstellungen.kontakt.kontakt_abfragen_nachname=="Y"}<em>*</em>{/if}:</label>
                  <input type="text" name="nachname" value="{$Vorgaben->cNachname}" id="lastName" required />
                  {if $fehlendeAngaben.nachname>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
               </li>
               {/if}
               {if $Einstellungen.kontakt.kontakt_abfragen_firma!="N"}
               <li class="clear {if $fehlendeAngaben.firma>0}error_block{/if}">
                  <label for="firm">{lang key="firm" section="account data"}{if $Einstellungen.kontakt.kontakt_abfragen_firma=="Y"}<em>*</em>{/if}:</label>
                  <input type="text" name="firma" value="{$Vorgaben->cFirma}" id="firm" required />
                  {if $fehlendeAngaben.firma>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
               </li>
               {/if}
               <li class="clear {if $fehlendeAngaben.email>0}error_block{/if}">
                  <label for="email">{lang key="email" section="account data"}<em>*</em>:</label>
                  <input type="text" name="email" value="{$Vorgaben->cMail}" id="email" required />
                  {if $fehlendeAngaben.email>0}<p class="error_text">{if $fehlendeAngaben.email==1}{lang key="fillOut" section="global"}{elseif $fehlendeAngaben.email==2}{lang key="invalidEmail" section="global"}{elseif $fehlendeAngaben.email==3}{lang key="blockedEmail" section="global"}{/if}</p>{/if}
               </li>
               {if $Einstellungen.kontakt.kontakt_abfragen_tel!="N"}
               <li class="clear {if $fehlendeAngaben.tel>0}error_block{/if}">
                  <label for="tel">{lang key="tel" section="account data"}{if $Einstellungen.kontakt.kontakt_abfragen_tel=="Y"}<em>*</em>{/if}:</label>
                  <input type="text" name="tel" value="{$Vorgaben->cTel}" id="tel" required />
                  {if $fehlendeAngaben.tel>0}<p class="error_text">{if $fehlendeAngaben.tel==1}{lang key="fillOut" section="global"}{elseif $fehlendeAngaben.tel==2}{lang key="invalidTel" section="global"}{/if}</p>{/if}
               </li>
               {/if}
               {if $Einstellungen.kontakt.kontakt_abfragen_mobil!="N"}
               <li {if $fehlendeAngaben.mobil>0}class="error_block"{/if}>
                  <label for="mobile">{lang key="mobile" section="account data"}{if $Einstellungen.kontakt.kontakt_abfragen_mobil=="Y"}<em>*</em>{/if}:</label>
                  <input type="text" name="mobil" value="{$Vorgaben->cMobil}" id="mobile" required />
                  {if $fehlendeAngaben.mobil>0}<p class="error_text">{if $fehlendeAngaben.mobil==1}{lang key="fillOut" section="global"}{elseif $fehlendeAngaben.mobil==2}{lang key="invalidTel" section="global"}{/if}</p>{/if}
               </li>
               {/if}
               {if $Einstellungen.kontakt.kontakt_abfragen_fax!="N"}
               <li {if $fehlendeAngaben.fax>0}class="error_block"{/if}>
                  <label for="fax">{lang key="fax" section="account data"}{if $Einstellungen.kontakt.kontakt_abfragen_fax=="Y"}<em>*</em>{/if}:</label>
                  <input type="text" name="fax" value="{$Vorgaben->cFax}" id="fax" />
                  {if $fehlendeAngaben.fax>0}<p class="error_text">{if $fehlendeAngaben.fax==1}{lang key="fillOut" section="global"}{elseif $fehlendeAngaben.fax==2}{lang key="invalidTel" section="global"}{/if}</p>{/if}
               </li>
               {/if}
               
               {getCheckBoxForLocation nAnzeigeOrt=$nAnzeigeOrt cPlausi_arr=$fehlendeAngaben cPost_arr=$cPost_arr}
               
            </ul>
         </fieldset>
         
         <fieldset>
            <legend>{lang key="message" section="contact" alt_section="global,"}</legend>
            <ul class="input_block">
               {if $betreffs}
               <li>
                  <label for="subject">{lang key="subject" section="contact"}:</label>
                  <select name="subject" id="subject">
                     {foreach name=betreffs from=$betreffs item=betreff}
                     <option value="{$betreff->kKontaktBetreff}" {if $Vorgaben->kKontaktBetreff==$betreff->kKontaktBetreff}selected{/if}>{$betreff->AngezeigterName}</option>
                     {/foreach}
                  </select>
               </li>
               {/if}
               <li class="clear {if $fehlendeAngaben.nachricht>0}error_block{/if}" id="angabeueberbestand">
                  <label for="message">{lang key="message" section="contact" alt_section="global,"}<em>*</em>:
                  <br /><pre style="font: normal 12px Arial,Helvetica,sans-serif;color: #333;">TYPENNUMMER (var backend)	BEZEICHNUNG		ANZAHL		ZUSTAND		PREIS (pro St&uuml;ck)</pre>
                  </label>
                  <textarea name="nachricht" class="frage" rows="10" cols="80" id="message" wrap="hard" required>{$Vorgaben->cNachricht}</textarea>
                  {if $fehlendeAngaben.nachricht>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
               </li>
			   
			   <li class="clear ">
		            <label for="rad">{lang key="oderwaehlensieankauf" section="contact" alt_section="global,"}</label>
		            <br>
		            <input type="radio" name="rad" value="yes" style="width:20px">&nbsp; {lang key="yes" section="global"}&nbsp;&nbsp;</input>
		            <input type="radio" name="rad" value="no"
		            style="width:20px" checked>&nbsp; {lang key="no" section="global"}</input>
			   </li>
			   
			   <li class="clear" id="angabeueberbestand_upload" style="display:none">
                  <!--<label for="file">{lang key="fileupload" section="contact" alt_section="global,"}<em>*</em>:</label>-->
				  <label for="file">Required if option above has been selected.<br /> Max. number of files allowed to upload to the server: {lang key="max_num_uploads" section="contact"} (each of which not exceeding a filesize of more than {lang key="max_file_size" section="contact"} Bytes [divide per 1024 to get the KByte value]). xls, txt, csv and image files are allowed to be sent.(<em>*</em>:</label>
                  <!--<div class="upload">-->
        			<input type="file" name="file[]" style="margina-top:10px" id="file" />
					
    			  <!--</div>-->
			   </li>
			   
               
            </ul>
         </fieldset>
         
         {if $Spezialcontent->unten|@strlen > 0}
         <div class="custom_content">
         {$Spezialcontent->unten}
         </div>
         {/if}
         
		
		 
         <input type="hidden" name="kontakt" value="1" />
		 <input type="hidden" name="shopURL" id="shopURL" value="{$ShopURL}" />
		 <input type="hidden" name="responseText" id="responseText" value="{lang key="messageSent" section="contact"}" />
		 <input type="hidden" name="max_num_uploads" id="max_num_uploads" value="{lang key="max_num_uploads" section="contact"}" />
		 <input type="hidden" name="max_file_size" id="max_file_size" value="{lang key="max_file_size" section="contact"}" />
		 <input type="hidden" name="anfrageFormular_emailkonto" id="anfrageFormular_emailkonto" value="{lang key="anfrageFormular_emailkonto" section="contact"}" />
		 <input type="hidden" name="anfrageFormular_subject" id="anfrageFormular_subject" value="{lang key="anfrageFormular_subject" section="contact"}" />
		 
		 
		 
         <input type="hidden" name="{$session_name}" value="{$session_id}" />
         <input type="hidden" name="md5" value="{$code->codemd5}" />
         
         <p class="box_info tright"><em>*</em> {lang key="mandatoryFields" section="global"}</p>
         <button type="submit" class="submit" id="overwriteFormSendAnkauf"><span>{lang key="sendMessage" section="contact"}</span></button>
      </form>
      
	  <p id="sent_anfrageformular" class="box_success" style="display:none;margin-top:15px;">{lang key="messageSent" section="contact"}</p>
	  
   
   
   {include file='tpl_inc/inc_seite.tpl'}
</div>
{include file='tpl_inc/footer.tpl'}