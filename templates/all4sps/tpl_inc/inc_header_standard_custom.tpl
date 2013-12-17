		 
      <div id="header" class="header_standard page_width {if $Einstellungen.template.general.page_align == 'L'}page_left{else}page_center{/if}">
         <div id="logo" style="z-index:20000;">
            <a href="{$ShopURL}{if $SID}/index.php?{$SID}{/if}" title="{$Einstellungen.global.global_shopname}">
               {image src=$ShopLogoURL alt=$Einstellungen.global.global_shopname}
            </a>
         </div>	
         <div id="headlinks_wrapper">
		    
			{if isset($smarty.session.Linkgruppen->All4SPSHeaderSpecials) && $smarty.session.Linkgruppen->All4SPSHeaderSpecials}
			  <div id="services">
			   <ul>
				  <li class="enquery" style="height:42px"><br /><span id="toogleEnquery" style="cursor: pointer"><strong>{lang key="service_enquery_titel" section="global"}</strong>
				  </span>
				  <ul id="hud-dropdown" style="height: auto;
position: absolute;
top: 40px;
z-index: 1000;
padding: 20px 25px;
display: none;
width: 450px;
background-color: #fff;
left: 0;
box-shadow: 0 1px 3px 0 #ccc;
border: 1px solid #333333;
border-top: 0;">
					<li>
				
		 <form method="post" action="" class="form" name="myform" id="myform" >
         <fieldset style="width:390px">
            <legend>{lang key="ankauf_anfrage" section="global"}</legend>
            <p class="box_plain">{lang key="ankaufKurzSubscribeDesc" section="custom"}</p>
            
            <ul class="input_block">
               <li>
                  <label for="cAnrede">{lang key="newslettertitle" section="newsletter"}:</label>
                  <select id="cAnrede" name="cAnrede">
                     <option value="w"{if $oPlausi->cPost_arr.cAnrede == "w" || $oKunde->cAnrede == "w"} selected="selected"{/if}>{$Anrede_w}</option>
                     <option value="m"{if $oPlausi->cPost_arr.cAnrede == "m" || $oKunde->cAnrede == "m"} selected="selected"{/if}>{$Anrede_m}</option>
                  </select>
               </li>
               <li class="clear {if $oPlausi->nPlausi_arr.cVorname}error_block{/if}">
                  <label for="newsletterfirstname">{lang key="newsletterfirstname" section="newsletter"}:</label>
                  <input type="text" name="cVorname" value="{if $oPlausi->cPost_arr.cVorname}{$oPlausi->cPost_arr.cVorname}{else}{$oKunde->cVorname}{/if}" id="newsletterfirstname" />
                  {if $oPlausi->nPlausi_arr.cVorname}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
               </li>
               <li {if $oPlausi->nPlausi_arr.cNachname}class="error_block"{/if}>
                  <label for="lastname">{lang key="newsletterlastname" section="newsletter"}<em>*</em>:</label>
                  <input type="text" name="lastname" value="{if $oPlausi->cPost_arr.cNachname}{$oPlausi->cPost_arr.cNachname}{else}{$oKunde->cNachname}{/if}" id="lastname" />
                  {if $oPlausi->nPlausi_arr.cNachname}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
               </li>
			   {if $Einstellungen.kontakt.kontakt_abfragen_firma!="N"}
               <li class="clear {if $fehlendeAngaben.firma>0}error_block{/if}">
                  <label for="firma">{lang key="firm" section="account data"}<em>*</em>:</label>
                  <input type="text" name="firma" value="{$Vorgaben->cFirma}" id="firma" required />
                  {if $fehlendeAngaben.firma>0}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
               </li>
               {/if}
               <li class="clear {if $oPlausi->nPlausi_arr.cEmail}error_block{/if}">
                  <label for="email">{lang key="newsletteremail" section="newsletter"}<em>*</em>:</label>
                  <input type="text" name="email" value="{if $oPlausi->cPost_arr.cEmail}{$oPlausi->cPost_arr.cEmail}{else}{$oKunde->cMail}{/if}" id="email" />
                  <p class="error_text" style="display:none">{lang key="fillOut" section="global"}</p>
               </li>
			   <li class="clear >
                  <label for="message">{lang key="yourquestion_enquery_explain" section="contact"}<em>*</em>:</label>
                  <textarea name="message" id="message" style="width:270px;" />
                  <p class="error_text" style="display:none">{lang key="fillOut" section="global"}</p>
               </li>
               {if isset($Einstellungen.newsletter.newsletter_sicherheitscode) && $Einstellungen.newsletter.newsletter_sicherheitscode != "N"}
                  {if $Einstellungen.newsletter.newsletter_sicherheitscode == 4}
                  <li class="clear {if $oPlausi->nPlausi_arr.captcha}error_block{/if}">
                     <label for="captcha">{lang key="code" section="global"}<em>*</em>: <b>{$code_newsletter->frage}</b></label>
                     <input type="text" name="captcha" id="captcha" />
                     {if $oPlausi->nPlausi_arr.captcha}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
                  </li>
                  {else}
                  <li class="clear {if $oPlausi->nPlausi_arr.captcha}error_block{/if}">
                     <label for="captcha"><p>{lang key="code" section="global"}<em>*</em>:</p><img src="{$code_newsletter->codeURL}" alt="{lang key="code" section="global"}" title="{lang key="code" section="global"}"></label>
                     <input type="text" name="captcha" id="captcha" />
                     {if $oPlausi->nPlausi_arr.captcha}<p class="error_text">{lang key="fillOut" section="global"}</p>{/if}
                  </li>
                  {/if}
               {/if}
                  
               {getCheckBoxForLocation nAnzeigeOrt=$nAnzeigeOrt cPlausi_arr=$oPlausi->nPlausi_arr cPost_arr=$cPost_arr}
                  
               <li class="clear">
                  <button type="submit" class="submit"><span>{lang key="sendMessage" section="contact"}</span></button>
               </li>
            </ul>         
         </fieldset>
		 <input type="hidden" name="responseText" id="responseText" value="{lang key="messageSent" section="contact"}" />
		 <input type="hidden" name="anfrageFormular_emailkonto" id="anfrageFormular_emailkonto" value="{lang key="anfrageFormular_emailkonto" section="contact"}" />
		 <input type="hidden" name="anfrageFormular_subject" id="anfrageFormular_subject" value="{lang key="anfrageFormular_subject" section="contact"}" />
      </form>
	  <div id="sent" style="display:none;height:30px;min-height:25px;" class="box_success">Success</div>
					
					</li>
				  </ul>
				  </li>
				  
				  
			   </ul>
			</div>
		    {/if}
			
            <div id="headlinks">
               <ul>
                  <li class="last {if $WarenkorbArtikelanzahl >= 1}items{/if}{if $nSeitenTyp == 3} current{/if}" id="basket_drag_area"><a href="warenkorb.php?{$SID}">{lang key="basket"}: {$WarenkorbWarensumme[$NettoPreise]}<span></span></a></li>
               </ul>
            </div>
         </div>
      </div>
	  
	  {literal}
		<script>
			$( "#toogleEnquery" ).click(function() {
			$( "#hud-dropdown" ).slideToggle( "slow" );
			});
			
			// If the user clicks anywhere outside the drop-down cart then hide the drop-down
			var mouseInside = false;
			$(".enquery").hover(function(){ 
					mouseInside = true; 
				}, function(){ 
					mouseInside = false; 
				});
				$("body").mouseup(function(){ 
					if(! mouseInside) {
						$('#hud-dropdown').slideUp('fast');
						
					}
			});
			
			jQuery(function($)
			{
			  $('#file').multifile();
			});
			
			function doResponse() {
			//alert('mach');
			$('#ankauf_anfrageformular').resetForm();
			$( ".multifile_container" ).empty();
			$("#sent_anfrageformular").show();
			//$('#sent_anfrageformular').html(data);
			}
			
			
			$(document).ready(function() {
				var options = { 
				target: '#sent_anfrageformular',   // target element(s) to be updated with server response 
				}; 
				
				$('#ankauf_anfrageformular').ajaxForm({
					target: '#sent_anfrageformular',
					beforeSubmit:  function(){
						return $('#ankauf_anfrageformular').validate().form();
					},
					success: doResponse
				});
				
				
			    $('#ankauf_anfrageformular').validate({
				
					errorElement: "p",
					errorClass: "error_text",
					rules: {
					    salutation: "required",
						firstname: "required",
						lastname: "required",
						firm: "required",
						email: {
						required: true,
						email: true
						},
						message: {
						required: true,
						minlength: 3
						}
					},
					messages: {
						vorname: "{/literal}{lang key="fillOut" section="global"}{literal}",
						nachname: "{/literal}{lang key="fillOut" section="global"}{literal}",
						email: "{/literal}{lang key="fillOut" section="global"}{literal}",
						firma: "{/literal}{lang key="fillOut" section="global"}{literal}",
						nachricht: "{/literal}{lang key="fillOut" section="global"}{literal}"
						}
					
				});
				
				$("input[type='radio']").change(function () {
					if ($(this).val() == "yes") {
						$("#angabeueberbestand_upload").show();
						$("#angabeueberbestand").hide();
					} else {
						$("#angabeueberbestand_upload").hide();
						$("#angabeueberbestand").show();
					}
				});
			
			// validate form on keyup and submit
			$("#myform").validate({
			submitHandler: function(form) {
				// This part stays the same
				$.post('/process_enquery_short.php', $("#myform").serialize(), function(data) {
					$('#sent').html(data);
				});
				//$('#myform').hide();
				document.getElementById('myform').reset();
				$('#sent').show();
			},
			errorElement: "p",
			errorClass: "error_text",
			rules: {
			lastname: "required",
			firma: "required",
			message: {
				required: true,
				minlength: 3
			},
			email: {
			required: true,
			email: true
			}
			},
			messages: {
			lastname: "{/literal}{lang key="fillOut" section="global"}{literal}",
			email: "{/literal}{lang key="fillOut" section="global"}{literal}",
			firma: "{/literal}{lang key="fillOut" section="global"}{literal}",
			message: "{/literal}{lang key="fillOut" section="global"}{literal}"
			}
			});
			});
			
			</script>	
	  {/literal}