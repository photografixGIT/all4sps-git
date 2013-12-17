{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}

   {if !$bExclusive}
   </div>
      <div id="sidepanel_left">{load_boxes type="left" assign="cBoxLeft"}{eval var=$cBoxLeft}</div>
      <div id="sidepanel_right">{load_boxes type="right" assign="cBoxRight"}{eval var=$cBoxRight}</div>
   </div>
   {/if}
 
   </div>
   <div class="clear"></div>

   {if $smarty.now % 10 == 0}
      <img src="includes/cron_inc.php" width="0" height="0" alt="" />
   {/if}
   
   {if !$bExclusive}
   
   </div> {* ende bodyWrapper *}
   
   <div id="footer_wrapper">      
      {if $Einstellungen.template.general.ext_footer != "Y"}
         <div id="footer" class="page_width {if $Einstellungen.template.general.page_align == 'L'}page_left{else}page_center{/if}">
            <ul class="hlist">

               <li class="p50">
        
                  <p><small>
                  &copy; {$meta_copyright}
                  {if $smarty.session.Linkgruppen->Fuss}
                     {foreach name=fusslinks from=$smarty.session.Linkgruppen->Fuss->Links item=Link}
                        | <a href="{$Link->URL}"{if $Link->cNoFollow == "Y"} rel="nofollow"{/if} title="{$Link->cLocalizedName[$smarty.session.cISOSprache]}">{$Link->cLocalizedName[$smarty.session.cISOSprache]}</a>
                     {/foreach}
                  {/if}
                  | <a target="_blank" title="created by " href="http://www.wawi.ch">photografix.ch</a>
                  </small></p>
               </li>
               <li class="p50 tright">
                  <p class="jtl">
                     {if $Einstellungen.global.global_fusszeilehinweis|strlen > 0}{$Einstellungen.global.global_fusszeilehinweis}{/if}
                     {if $Einstellungen.global.global_fusszeilehinweis|strlen > 0 && $Einstellungen.global.global_zaehler_anzeigen=="Y"}|{/if}
                     {if $Einstellungen.global.global_zaehler_anzeigen=="Y"}{lang key="counter" section="global"}: {$Besucherzaehler}{/if}
                  </p>
               </li>
            </ul>
         </div>
      {else}
      
         {include file="tpl_inc/inc_newsletter.tpl"}
         
         <div id="footer" class="page_width {if $Einstellungen.template.general.page_align == 'L'}page_left{else}page_center{/if}">
            <ul class="hlist clearall">
               <li class="p30" style="max-width:490px;margin-right:20%;">
				  <img src="{$ShopURL}/bilder/intern/footer_map.png" border="0" style="max-width: 100%;height: auto; width: auto\9;margin-top:0px">
               </li>
               
			  
		   
               <li class="p25" id="ftr_lnkgrp">
                  <h2>{$smarty.session.Linkgruppen->Informationen->cLocalizedName[$lang]}</h2>
                  {get_navigation type="Informationen" class="lnkgroup"}
               </li>
               
               <li class="p25" id="ftr_lnkgrp">
                  <h2>{$smarty.session.Linkgruppen->Fuss->cLocalizedName[$lang]}</h2>
                  {get_navigation type="Fuss" class="lnkgroup"}
               </li>
			   
			   
                <li class="p25" id="ftr_account" style="margin-top:30px">
                  <h2>{lang key="myAccount"}</h2>
                  <ul class="lnkgroup">
                     <li><a href="jtl.php">{lang key="orderHistory"}</a></li>
                     {if $Einstellungen.global.global_wunschliste_anzeigen == "Y"}
                        <li><a href="jtl.php" rel="nofollow">{lang key="wishlist"}</a></li>
                     {/if}
                     {*if $Einstellungen.kundenwerbenkunden.kwk_nutzen == "Y"*}
                        <li><a href="jtl.php?KwK=1" rel="nofollow">{lang key="kwkName" section="login"}</a></li>
                     {*/if*}
                  </ul>
               </li>
			   
			   <li class="p25" style="margin-top:30px">

                  {tFirma return="myFirma"}
                  <h2>{$myFirma->cName}</h2>
                  <ul class="f_contact">
                    <li>{$myFirma->cStrasse}<br />{$myFirma->cPLZ} {$myFirma->cOrt}</li>
                    <li>{$myFirma->cTel}</li>
                    <li>{$myFirma->cEMail}</li>
                  </ul>
               </li>
			   
              

            </ul>
            
            <div class="master clearall">
               <div class="first">
                  {if $Einstellungen.global.global_fusszeilehinweis|strlen > 0}
                     <p class="box_info container">
                        {$Einstellungen.global.global_fusszeilehinweis}
                     </p>
                  {/if}
                  <p><em>*</em> {lang key="unsubscribeAnytime" section="newsletter"}</p>
                  <p>{if $Einstellungen.global.global_zaehler_anzeigen=="Y"}{lang key="counter" section="global"}: {$Besucherzaehler}{/if}</p>
               </div>
               <div class="last">
                  &nbsp;
               </div>
            </div>
         </div>
      {/if}
      
      <a id="back-top" class="scrollTo_top" href="#page"></a>

      {if $Einstellungen.global.global_google_analytics_id}
         <script type="text/javascript">
            var _gaq = _gaq || [];
            _gaq.push(['_setAccount', '{$Einstellungen.global.global_google_analytics_id}']);
            _gaq.push(['_gat._anonymizeIp']);
            _gaq.push(['_trackPageview']);

            (function() {ldelim}
               var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
               ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
               var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
            {rdelim})();

            {if $Bestellung->kBestellung > 0 && $nSeitenTyp == 33 && $Einstellungen.global.global_google_ecommerce == 1}
               _gaq.push(['_addTrans',
                  '{$Bestellung->cBestellNr}', 
                  '{if $Einstellungen.global.global_shopname}{$Einstellungen.global.global_shopname}{else}{$Firma->cName}{/if}', 
                  '{$Bestellung->fWarensummeNetto}', 
                  '{$Bestellung->fSteuern}', 
                  '{$Bestellung->fVersandNetto}', 
                  '{$smarty.session.Kunde->cOrt}',
                  '{$smarty.session.Kunde->cBundesland}',
                  '{$smarty.session.Kunde->cLand}'
               ]);

               {foreach name=Bestell item=order from=$Bestellung->Positionen} 
                  {if $order->nPosTyp == 1} 
                     _gaq.push(['_addItem',
                        '{$Bestellung->cBestellNr}',
                        '{$order->cArtNr}',
                        '{$order->cName}',
                        '{$order->Category}',
                        '{$order->fPreis}',
                        '{$order->nAnzahl|replace:",":"."}'
                     ]);
                  {/if} 
               {/foreach} 
               
               _gaq.push(['_trackTrans']);
            {/if}
         </script>
      {/if}
   </div>
   {/if}
{if !$bExclusive}
</div>
<div id="footer-extra-impressum"
><p><font color="#B90100">&copy; {$meta_copyright} &nbsp;&bull; </font>&nbsp; <a target="_blank" title="Atelier für Photografie, Grafik, Druck und Werbung" href="http://www.wawi.ch">created by photografix.ch</a>&nbsp;&nbsp;</p></div>
{/if}
</div>
{* ODM, 5/11/2013: had to add this hack in order to re-fire jquery's fancybox event *}

<script>
function init_article_image(obj) {ldelim}
      var nWidth = $(obj).naturalWidth() + 4;
      if (nWidth > 4) {ldelim}
         $('#article .article_image').css({ldelim}
            'width' : nWidth + 'px',
            'max-width' : nWidth + 'px'
         {rdelim});
      {rdelim}
   {rdelim}
   
   {* image wrapper width *}
      var article_image = $('#image_wrapper div.image img');      
      if (article_image.naturalWidth() > 0 && article_image.naturalHeight() > 0)
         init_article_image(article_image);
      else {ldelim}
         article_image.load(function() {ldelim}
            init_article_image($(this));
         {rdelim});
      {rdelim}
</script>

<script>
{literal}
$("a.fancy-gallery:has(img)").fancybox();
{/literal}
</script>
<script>
{* tabs *}
      {if $Einstellungen.artikeldetails.artikeldetails_tabs_nutzen != "N"}
         $("#mytabset").semantictabs({ldelim}
            panel: '.panel',
            head: 'h2.title',
            active: '{if $BewertungsTabAnzeigen == 1}#box_votes{elseif $fehlendeAngaben_benachrichtigung && $verfuegbarkeitsBenachrichtigung==1}#box_article_notification{elseif $fehlendeAngaben_fragezumprodukt && $Einstellungen.artikeldetails.artikeldetails_fragezumprodukt_anzeigen == "Y"}#box_article_question{elseif $PluginTabAnzeigen}{$PluginTabName}{else}:first{/if}',
            activate: 0
         {rdelim});
      {/if}
	  
</script>
<!-- time: {$nZeitGebraucht|truncate:6:''} seconds -->
</body>
</html>