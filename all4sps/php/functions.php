<?php
/**
 * copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 *
 * this file may not be redistributed in whole or significant part
 * and is subject to the JTL-Software-GmbH license.
 *
 * license: http://jtl-software.de/jtlshop3license.html
 */

$smarty->register_function("parseNewsTextSmarty", "parseNewsTextSmarty");
$smarty->register_function("gibPreisStringLocalizedSmarty", "gibPreisStringLocalizedSmarty");
$smarty->register_function("convertHTMLxHTML", "convertHTMLxHTML");
$smarty->register_function("load_boxes", "load_boxes");
$smarty->register_function("get_box_layout", "get_box_layout");
$smarty->register_function("image_size", "image_size");
$smarty->register_function("image", "get_img_tag");
$smarty->register_function("getCheckBoxForLocation", "getCheckBoxForLocation");
$smarty->register_function("hasCheckBoxForLocation", "hasCheckBoxForLocation");
$smarty->register_function("aaURLEncode", "aaURLEncode");
$smarty->register_function("get_product_list", "get_product_list");
$smarty->register_function("get_category_list", "get_category_list");
$smarty->register_function("get_navigation", "get_navigation");
$smarty->register_function("get_navigation_plain", "get_navigation_plain");
$smarty->register_function("has_navigation", "has_navigation");
$smarty->register_function("tFirma", "holeFirmaDaten");
$smarty->register_function("tHersteller", "holeHersteller");

function get_img_tag($params, &$smarty)
{
	if (empty($params['src']))
		return '';
	
	list($width, $height) = getimagesize($params['src']);
   
	$imageURL = $params['src'];
	$imageID = isset($params['id']) ? ' id="'.$params['id'].'"' : '';
	$imageALT = isset($params['alt']) ? ' alt="'.truncate($params['alt'], 75).'"' : '';
	$imageTITLE = isset($params['title']) ? ' title="'.truncate($params['title'], 75).'"' : '';
   $imageCLASS = isset($params['class']) ? ' class="'.truncate($params['class'], 75).'"' : '';
	
	if ($width > 0 && $height >0 )
		return '<img src="'.$imageURL.'" width="'.$width.'" height="'.$height.'"'.$imageID.$imageALT.$imageTITLE.$imageCLASS.' />';
	
	return '<img src="'.$imageURL.'"'.$imageID.$imageALT.$imageTITLE.$imageCLASS.' />';
}

function load_boxes($params, &$smarty)
{
   $cTplData = "";
   $cOldTplDir = "";
   $oBoxen_arr = gibBoxen();
   
   $cTemplateDir = $smarty->template_dir;
   
   if (is_array($oBoxen_arr) && isset($params['type']))
   {
      $cType = $params['type'];
      if (boxAnzeigen($cType) && isset($oBoxen_arr[$cType]) && is_array($oBoxen_arr[$cType]))
      {
         foreach ($oBoxen_arr[$cType] as $oBox)
         {
            $oPluginVar = '';
            $cTemplate = 'tpl_inc/boxes/' . $oBox->cTemplate;
            if ($oBox->eTyp == "plugin")
            {
               $oPlugin = new Plugin($oBox->kCustomID);
               if ($oPlugin->kPlugin > 0 && $oPlugin->nStatus == 2)
               {
                  $cTemplate = $oBox->cTemplate;
                  $cOldTplDir = $cTemplateDir;
                  $cTemplateDir = $oPlugin->cFrontendPfad . PFAD_PLUGIN_BOXEN;

                  $oPluginVar = 'oPlugin' . $oBox->kBox;
                  $smarty->assign($oPluginVar, $oPlugin);
               }
            }
			elseif ($oBox->eTyp == "link")
            {
               $oLinkTpl_arr = array_keys(get_object_vars($_SESSION['Linkgruppen']));
               foreach ($oLinkTpl_arr as $oLinkTpl)
               {
                  if ($_SESSION['Linkgruppen']->{$oLinkTpl}->kLinkgruppe == $oBox->kCustomID)
                  {
                     $oBox->oLinkGruppeTemplate = $oLinkTpl;
                     $oBox->oLinkGruppe = $_SESSION['Linkgruppen']->{$oLinkTpl};
                  }
               }
            }
            if (file_exists($cTemplateDir .'/'. $cTemplate))
            {
               $oBoxVar = 'oBox' . $oBox->kBox;
               $smarty->assign($oBoxVar, $oBox);
               
               // Custom Template
               global $Einstellungen;
               if ($Einstellungen['template']['general']['use_customtpl'] == 'Y')
               {
                  $cTemplatePath = pathinfo($cTemplate);
                  $cCustomTemplate = $cTemplatePath['dirname'] .'/'. $cTemplatePath['filename'] . '_custom.tpl';
                  
                  if (file_exists($cTemplateDir .'/'. $cCustomTemplate))
                     $cTemplate = $cCustomTemplate;
               }
               
               $cTemplatePath = $cTemplateDir .'/'. $cTemplate;
               
               if ($oBox->eTyp == "plugin")
                  $cTplData .= "{include file='".$cTemplatePath."' oBox=\$$oBoxVar oPlugin=\$$oPluginVar}";
               else
                  $cTplData .= "{include file='".$cTemplatePath."' oBox=\$$oBoxVar}";
			   
               if (strlen($cOldTplDir))
                  $cTemplateDir = $cOldTplDir;
            }
         }
      }     
   }
   
   if (isset($params['assign']))
   {
      $smarty->assign($params['assign'], $cTplData);
   }
   else
   {
      return $cTplData;
   }
}

function get_box_layout($params, &$smarty)
{
   $cLayout = "";
   $bExclusive = $GLOBALS['smarty']->get_template_vars('bExclusive');

	if (boxAnzeigen('left') && !$bExclusive) $cLayout .= " panel_left ";
	if (boxAnzeigen('top') && !$bExclusive) $cLayout .= " panel_top ";
	if (boxAnzeigen('right') && !$bExclusive) $cLayout .= " panel_right ";
	if (boxAnzeigen('bottom') && !$bExclusive) $cLayout .= " panel_bottom ";
   
	return trim($cLayout);
}

function image_size($params, &$smarty)
{
	if (isset($params['href']) && isset($params['type']))
	{
		list($width, $height, $type, $attr) = getimagesize($params['href']);

      $offset = 0;
      if (isset($params['offset']))
         $offset = intval($params['offset']);

		switch ($params['type'])
		{
			case 'x': case 'width': return $width + $offset;
			case 'y': case 'height': return $height + $offset;
			default: return 0;
		}
	}
	return 0;
}

function convertHTMLxHTML($params, &$smarty)
{
	 return $params['cHTML']; // erstmal komplett deaktiviert
    if(strlen($params['cHTML']) > 0)
    {
        $cHTML = $params['cHTML'];
        $cHtmlTags = $params['cHtmlTags'];
        if(empty($cHtmlTags))
            $cHtmlTags = "<br><p><img><a><b><strong><i><hr><h1><h2><h3><h4><h5><ul><ol><li><dl><dt><em><table><thead><tbody><tr><td><th><tfoot><object><span><div>";

        $cxHTML = strip_tags($cHTML, $cHtmlTags);
        $cxHTML = preg_replace_callback("|<[^>]*(\w+)\W*>|iU", create_function('$cTeffer_arr', 'return strtolower($cTeffer_arr[0]);'), $cxHTML);
        $cxHTML = preg_replace('/<p>(.*?)<\/p>/', '<p>\1</p>', $cxHTML);
        $cxHTML = preg_replace('/<br>/', '<br />', $cxHTML);
        $cxHTML = preg_replace('/<hr>/', '<hr />', $cxHTML);
        $cxHTML = preg_replace('/ & /', ' &amp; ', $cxHTML);
        $cxHTML = preg_replace('/ align=left/', '', $cxHTML);
        $cxHTML = preg_replace('/ align=right/', ' class="tright"', $cxHTML);
        $cxHTML = preg_replace('/ align=center/', ' class="tcenter"', $cxHTML);
		  $cxHTML = preg_replace('/<\/p><\/p>/', '</p>', $cxHTML);

        return $cxHTML;
    }

    return "";
}

function gibKategorienHTML($VerzweigungsKategorie, $RestArray, $tiefe, $current_cat_key, $KategorieBox=0)
{
	global $smarty;
	
	$Einstellungen = getEinstellungen(array(CONF_TEMPLATE));
	
	$currentLink = $smarty->get_template_vars('Link');
	$currentPage = $smarty->get_template_vars('AktuelleSeite');
	
	//vollen Kategoriebaum nur dann erzeugen, wenn Einstellung in template.conf gesetzt oder Link/Seite ist Sitemap oder Startseite + Sitemap zeigen
	if ($Einstellungen['template']['categories']['topnavi_categories_full_category_tree'] == "Y")
		$smarty->assign('full_category_tree', get_categories($VerzweigungsKategorie, $RestArray, $tiefe, $current_cat_key, $KategorieBox, true));
	
	//Unterkategorie-Baum nur dann erzeugen, wenn Einstellung in template.conf gesetzt ist
	if ($Einstellungen['template']['categories']['sidebox_categories_use_subcat_navi'] == "Y")
		$smarty->assign('subcat_tree', get_subcategories($VerzweigungsKategorie, $RestArray, 1, $current_cat_key));
		
	if ($Einstellungen['template']['categories']['sidebox_categories_use_subcat_navi'] == "U")
		$smarty->assign('subcat_tree', get_subcategories_only($VerzweigungsKategorie, $RestArray, 1, $current_cat_key));
	
	return get_categories($VerzweigungsKategorie, $RestArray, $tiefe, $current_cat_key, $KategorieBox);
}

function get_categories($VerzweigungsKategorie, $RestArray, $tiefe, $current_cat_key, $KategorieBox=0, $include_nonselected_subcategories=false) {
    global $smarty;
    $html='';

    // Maximal 8 Ebenen zulassen (verhindert Endlosschleifen, wenn Kategoriestruktur in WaWi falsch ist)
    if ($tiefe >= 8) return;

    $UnterKategorien = new KategorieListe();
    $UnterKategorien->getAllCategoriesOnLevel($VerzweigungsKategorie->kKategorie);
	   
	$maxKategorien = count($UnterKategorien->elemente);
	if ($maxKategorien >= 6) {
		$maxItems = (int)($maxKategorien / 3);
	}
	
	$i = 0; $curRow = $maxItems;
	
    foreach ($UnterKategorien->elemente as $Kategorie) {
        //Kategoriebox Filter
        if (!$include_nonselected_subcategories && $KategorieBox>0 && $tiefe==0) {
            if ($Kategorie->KategorieAttribute[KAT_ATTRIBUT_KATEGORIEBOX] != $KategorieBox)
                continue;
        }

        if($Kategorie->bUnterKategorien) {
            $has_subcategories = true;
        } else {
            $has_subcategories = false;
        }

        $css_classname= $Kategorie->KategorieAttribute[KAT_ATTRIBUT_CSSKLASSE];
		
        if ($css_classname!='') $css_class='class="'.$css_classname.'"';
        else $css_class='';

        if ($html == "") { $class_first = ' first'; }
        else { $class_first = ''; }

        $title='';
        //Kategorie selektiert?
        if ($RestArray[count($RestArray)-1]->kKategorie == $Kategorie->kKategorie)
		{
            //if ($Kategorie->cBeschreibung) { $title = ' title="'.truncate(strip_tags($Kategorie->cBeschreibung), 80).'"'; }
			
			$ueberschrift = '<a title="'.strip_tags($Kategorie->cName).'" href="'.$Kategorie->cURL.'" class="'.$css_classname.'"'.$title.'><span>'.$Kategorie->cName.'</span></a>';
			if ($tiefe==1 && $has_subcategories) {
				
				$ueberschrift = '<h4><a title="'.strip_tags($Kategorie->cName).'" href="'.$Kategorie->cURL.'" class="'.$css_classname.'"'.$title.'><span>'.$Kategorie->cName.'</span></a></h4>';
			}
			
            $html.='<li'.($has_subcategories?' class="node active'.$class_first.'"':' class="active'.$class_first.'"').'>'. $ueberschrift;
            if($has_subcategories) {
                $html.='<ul class="subcat-'.$tiefe.'">'.get_categories(array_pop($RestArray), $RestArray, $tiefe+1, $current_cat_key, $KategorieBox, $include_nonselected_subcategories).'</ul><!-- / subcat -->';
            }
            $html.='</li>';
        }
        else { //Nicht-selektierte Kategorie
			
			$ueberschrift = '<a title="'.strip_tags($Kategorie->cName).'" href="'.$Kategorie->cURL.'"'.$title.' '.$css_class.'><span>'.$Kategorie->cName.'</span></a>';
			if ($tiefe==1 && $has_subcategories) {
				
				$ueberschrift = '<h4><a title="'.strip_tags($Kategorie->cName).'" href="'.$Kategorie->cURL.'"'.$title.' '.$css_class.'><span>'.$Kategorie->cName.'</span></a></h4>';
			}
			
            //if ($Kategorie->cBeschreibung) { $title = ' title="'.truncate(strip_tags($Kategorie->cBeschreibung), 80).'"'; }
			
			$kategorie_id = (int)$GLOBALS["kKategorie"];
				
			$html.='<li'.($has_subcategories?' class="node'.$class_first.'"':( $class_first != "" ? ' class="'.$class_first.'"' : '')).'>' . $ueberschrift;
            
			if($include_nonselected_subcategories && $has_subcategories)
			{
			   $subhtml = get_categories($Kategorie, $RestArray, $tiefe+1, $current_cat_key, $KategorieBox, $include_nonselected_subcategories);
			   
               if( strlen($subhtml)>0 )
			   {
					$html.='<ul class="subcat-'.$tiefe.'">';
					$html.= $subhtml;
					$html.= '</ul>';
                }
            }
			
            $html.='</li>';
			
			
				
        }
		
		$i++;
    }
    return $html;
}

function get_subcategories($VerzweigungsKategorie, $RestArray, $tiefe, $current_cat_key) {
    $html='';
    $UnterKategorien = new KategorieListe();
       $UnterKategorien->getAllCategoriesOnLevel($VerzweigungsKategorie->kKategorie);

       // Maximal 8 Ebenen zulassen (verhindert Endlosschleifen, wenn Kategoriestruktur in WaWi falsch ist)
    if ($tiefe > 8) return;

    foreach ($UnterKategorien->elemente as $Kategorie) {

        $css_classname= $Kategorie->KategorieAttribute[KAT_ATTRIBUT_CSSKLASSE];
		
        if ($css_classname!='') $css_class='class="'.$css_classname.'"';
        else $css_class='';

        if($Kategorie->bUnterKategorien) {
            $has_subcategories = true;
        } else {
            $has_subcategories = false;
        }

        //Kategorie selektiert?
        if ($RestArray[count($RestArray)-1]->kKategorie == $Kategorie->kKategorie) {
            if ($tiefe>1) {
                $title='';
                if ($Kategorie->cBeschreibung) { $title = ' title="'.truncate(strip_tags($Kategorie->cBeschreibung), 80).'"'; }
                $html.='<li'.($has_subcategories?' class="node current"':' class="current"').'><a href="'.$Kategorie->cURL.'" class="current '.$css_classname.'"'.$title.'><span>'.$Kategorie->cName.'</span></a>';
                if($has_subcategories) {
                    $html.='<ul class="subcat">'.get_subcategories(array_pop($RestArray), $RestArray, $tiefe+1, $current_cat_key).'</ul><!-- / subcat -->';
                }
                $html.='</li>';
            } else {
                $html .= get_subcategories(array_pop($RestArray), $RestArray, $tiefe+1, $current_cat_key);
            }
        }
        else if ($tiefe>1){ //Nicht-selektierte Kategorie
            $title='';
            if ($Kategorie->cBeschreibung) { $title = ' title="'.truncate(strip_tags($Kategorie->cBeschreibung), 80).'"'; }
            $html.='<li'.($has_subcategories?' class="node"':'').'><a href="'.$Kategorie->cURL.'"'.$title.' '.$css_class.'><span>'.$Kategorie->cName.'</span></a>';
           if($has_subcategories) {
                $html.='<ul class="subcat">'.get_subcategories($Kategorie, $RestArray, $tiefe+1, $current_cat_key).'</ul><!-- / subcat -->';
            }
            $html.='</li>';
        }
    }
    return $html;
}

function get_subcategories_only($VerzweigungsKategorie, $RestArray, $tiefe, $current_cat_key) {
	
    $html='';
    $UnterKategorien = new KategorieListe();
    $UnterKategorien->getAllCategoriesOnLevel($current_cat_key);

       // Maximal 8 Ebenen zulassen (verhindert Endlosschleifen, wenn Kategoriestruktur in WaWi falsch ist)
    if ($tiefe > 8) return;

	if (count ($UnterKategorien->elemente)==0) {
		$UnterKategorien->getAllCategoriesOnLevel($RestArray[0]->kOberKategorie);
	}
	
    foreach ($UnterKategorien->elemente as $Kategorie) {

		$css_classname= $Kategorie->KategorieAttribute[KAT_ATTRIBUT_CSSKLASSE];
		
        if ($css_classname!='') $css_class='class="'.$css_classname.'"';
        else $css_class='';
		
        $html.='<li'.($Kategorie->kKategorie==$current_cat_key?' class="current"':'').'><a href="'.$Kategorie->cURL.'" class="current '.$css_classname.'"'.$title.'><span>'.$Kategorie->cName.'</span></a>';
        $html.='</li>';
    }
	
    return $html;
}

function truncate($text,$numb) {
    $text = html_entity_decode($text, ENT_QUOTES);
    if (strlen($text) > $numb) {
    $text = substr($text, 0, $numb);
    $text = substr($text,0,strrpos($text,' '));
        //This strips the full stop:
        if ((substr($text, -1)) == '.') {
            $text = substr($text,0,(strrpos($text,'.')));
        }
    $etc = '...';
    $text = $text.$etc;
    }
    $text = StringHandler::htmlentities($text, ENT_QUOTES);
    return $text;
}
function gibKategorienNoHTML($oVerzweigungsKategorie, $RestArray, $nTiefe, $kAktuellekKategorie, $nKategorieBox = 0)
{
    $oUnterKategorien = new KategorieListe();
    $oUnterKategorien->getAllCategoriesOnLevel($oVerzweigungsKategorie->kKategorie);
    $oKategorienNoHTML_arr = array();

    foreach ($oUnterKategorien->elemente as $oKategorie)
    {
        //Kategoriebox Filter
        if ($nKategorieBox > 0 && $nTiefe == 0)
        {
            if ($Kategorie->KategorieAttribute[KAT_ATTRIBUT_KATEGORIEBOX] != $nKategorieBox)
                continue;
        }

        if ($kAktuellekKategorie == $oKategorie->kKategorie)
        {
            //nur wenn unterkategorien enthalten sind!
            $oAktKategorie = new Kategorie($kAktuellekKategorie);
            if ($oAktKategorie->existierenUnterkategorien())
            {
                unset($oKategorienNoHTML);
                $oKategorienNoHTML->kKategorie                  = $oKategorie->kKategorie;
                $oKategorienNoHTML->cName                       = $oKategorie->cName;
                $oKategorienNoHTML->cURL                        = $oKategorie->cURL;
                $oKategorienNoHTML_arr[$oKategorie->kKategorie] = $oKategorienNoHTML;

                $oVerzweigungsKategorie = array_pop($RestArray);
                $oUnterUnterKategorien = new KategorieListe();
                $oUnterUnterKategorien->getAllCategoriesOnLevel($oVerzweigungsKategorie->kKategorie);
                foreach ($oUnterUnterKategorien->elemente as $oUKategorie)
                {
                    unset($oKategorienNoHTML);
                    $oKategorienNoHTML->kKategorie                                      = $oUKategorie->kKategorie;
                    $oKategorienNoHTML->cName                                           = $oUKategorie->cName;
                    $oKategorienNoHTML->cURL                                            = $oUKategorie->cURL;
                    $oKategorienNoHTML_arr[$oKategorie->kKategorie]->oUnterKat_arr[$oUKategorie->kKategorie]    = $oKategorienNoHTML;
                }
            }
            else
            {
                unset($oKategorienNoHTML);
                $oKategorienNoHTML->kKategorie                  = $oKategorie->kKategorie;
                $oKategorienNoHTML->cName                       = $oKategorie->cName;
                $oKategorienNoHTML->cURL                        = $oKategorie->cURL;
                $oKategorienNoHTML_arr[$oKategorie->kKategorie] = $oKategorienNoHTML;
            }
        }
        else
        {
            unset($oKategorienNoHTML);
            $oKategorienNoHTML->kKategorie                  = $oKategorie->kKategorie;
            $oKategorienNoHTML->cName                       = $oKategorie->cName;
            $oKategorienNoHTML->cURL                        = $oKategorie->cURL;
            $oKategorienNoHTML_arr[$oKategorie->kKategorie] = $oKategorienNoHTML;

            if ($RestArray[count($RestArray)-1]->kKategorie == $oKategorie->kKategorie)
                $oKategorienNoHTML_arr[$oKategorie->kKategorie]->oUnterKat_arr = gibKategorienNoHTML(array_pop($RestArray), $RestArray, $nTiefe + 1, $kAktuellekKategorie);
        }
    }

    return $oKategorienNoHTML_arr;
}

//baut die Kategorieliste mit 3 Levels in HTML auf.
function gibKategorienHTML_3level()
{
		$currentTemplateDir = $GLOBALS['smarty']->get_template_vars('currentTemplateDir');
        $html="";
        $UnterKategorien = new KategorieListe();
       	$UnterKategorien->getAllCategoriesOnLevel(0);
        foreach ($UnterKategorien->elemente as $Kategorie)
        {
        	$html.='<tr><td class="kategorie_level1" style="padding-left:'.$padding.'px;"><img src="'.$currentTemplateDir.'gfx/menu-punkt.png" width="8" height="9" border="0" alt=""> <a href="'.$Kategorie->cURL.'" class="kategorielink">'.$Kategorie->cName.'</a></td></tr>';
	        $UnterKategorien2 = new KategorieListe();
	       	$UnterKategorien2->getAllCategoriesOnLevel($Kategorie->kKategorie);
	        foreach ($UnterKategorien2->elemente as $Kategorie2)
	        {
	        	$html.='<tr><td class="kategorie_level2" style="padding-left:'.$padding.'px;"><img src="'.$currentTemplateDir.'gfx/menu-punkt.png" width="8" height="9" border="0" alt=""> <a href="'.$Kategorie2->cURL.'" class="kategorielink">'.$Kategorie2->cName.'</a></td></tr>';
		        $UnterKategorien3 = new KategorieListe();
		       	$UnterKategorien3->getAllCategoriesOnLevel($Kategorie2->kKategorie);
		        foreach ($UnterKategorien3->elemente as $Kategorie3)
		        {
		        	$html.='<tr><td class="kategorie_level3" style="padding-left:'.$padding.'px;"><img src="'.$currentTemplateDir.'gfx/menu-punkt.png" width="8" height="9" border="0" alt=""> <a href="'.$Kategorie3->cURL.'" class="kategorielink">'.$Kategorie3->cName.'</a></td></tr>';
		        }
	        }
        }
        return $html;
}

// Diese Funktion erhält einen Text als String und parsed ihn. Variablen die geparsed werden lauten wie folgt:
// $#a:ID:NAME#$ => ID = kArtikel NAME => Wunschname ... wird in eine URL (evt. SEO) zum Artikel umgewandelt.
// $#k:ID:NAME#$ => ID = kKategorie NAME => Wunschname ... wird in eine URL (evt. SEO) zur Kategorie umgewandelt.
// $#h:ID:NAME#$ => ID = kHersteller NAME => Wunschname ... wird in eine URL (evt. SEO) zum Hersteller umgewandelt.
// $#m:ID:NAME#$ => ID = kMerkmalWert NAME => Wunschname ... wird in eine URL (evt. SEO) zum MerkmalWert umgewandelt.
// $#n:ID:NAME#$ => ID = kNews NAME => Wunschname ... wird in eine URL (evt. SEO) zur News umgewandelt.
function parseNewsTextSmarty($params, &$smarty)
{
	if(strlen($params['text']) > 0)
	{
		// Parameter
		$cParameter_arr = array("a:", "k:", "h:", "m:", "n:");
		$cURLArt_arr = array(URLART_ARTIKEL, URLART_KATEGORIE, URLART_HERSTELLER, URLART_MERKMAL, URLART_NEWS);

		foreach($cParameter_arr as $i => $cParameter)
		{
			$nPos = 0;
			while($nPos <= strlen($params['text']))
			{
				$cPos = strstr($params['text'], "$#" . $cParameter);
				if($cPos === false)
					break;

				$nBis = strpos($cPos, ":", 4);

				$cKey = substr($cPos, 4, $nBis-4);
				$cName = substr($cPos, $nBis+1, strpos($cPos, "#", $nBis) - ($nBis+1));
				$nPos = strpos($cPos, "#$");

				unset($oObjekt);
				$oObjekt;
				switch($cURLArt_arr[$i])
				{
					case URLART_ARTIKEL:
						$oObjekt->kArtikel = intval($cKey);
						$oObjekt->cKey = "kArtikel";
						$cTabellenname = "tartikel";
						$cSpracheSQL = "";
						if ($_SESSION['kSprache'] > 0 && !standardspracheAktiv())
						{
							$cTabellenname = "tartikelsprache";
							$cSpracheSQL = " AND kSprache=" . $_SESSION['kSprache'];
						}
						$oArtikel = $GLOBALS['DB']->executeQuery("SELECT cSeo
																	FROM " . $cTabellenname . "
																	WHERE kArtikel=" . intval($cKey).$cSpracheSQL, 1);
						$oObjekt->cSeo = $oArtikel->cSeo;
						break;
					case URLART_KATEGORIE:
						$oObjekt->kKategorie = intval($cKey);
						$oObjekt->cKey = "kKategorie";
						$cTabellenname = "tkategorie";
						$cSpracheSQL = "";
						if ($_SESSION['kSprache'] > 0 && !standardspracheAktiv())
						{
							$cTabellenname = "tkategoriesprache";
							$cSpracheSQL = " AND kSprache=" . $_SESSION['kSprache'];
						}
						$oKategorie = $GLOBALS['DB']->executeQuery("SELECT cSeo
																	FROM " . $cTabellenname . "
																	WHERE kKategorie=" . intval($cKey).$cSpracheSQL, 1);
						$oObjekt->cSeo = $oKategorie->cSeo;
						break;
					case URLART_HERSTELLER:
						$oObjekt->kHersteller = intval($cKey);
						$oObjekt->cKey = "kHersteller";
						$oHersteller = $GLOBALS['DB']->executeQuery("SELECT cSeo
																		FROM thersteller
																		WHERE kHersteller=" . intval($cKey), 1);
						$oObjekt->cSeo = $oHersteller->cSeo;
						break;
					case URLART_MERKMAL:
						$oObjekt->kMerkmalWert = intval($cKey);
						$oObjekt->cKey = "kMerkmalWert";
						$oMerkmalWert = $GLOBALS['DB']->executeQuery("SELECT cSeo
																		FROM tmerkmalwertsprache
																		WHERE kMerkmalWert=" . intval($cKey)."
																			AND kSprache=" . $_SESSION['kSprache'], 1);
						$oObjekt->cSeo = $oMerkmalWert->cSeo;
						break;
					case URLART_NEWS:
						$oObjekt->kNews = intval($cKey);
						$oObjekt->cKey = "kNews";
						$oNews = $GLOBALS['DB']->executeQuery("SELECT cSeo
																FROM tnews
																WHERE kNews=" . intval($cKey), 1);
						$oObjekt->cSeo = $oNews->cSeo;
						break;

					case URLART_UMFRAGE:
						$oObjekt->kNews = intval($cKey);
						$oObjekt->cKey = "kUmfrage";
						$oUmfrage = $GLOBALS['DB']->executeQuery("SELECT cSeo
																	FROM tumfrage
																	WHERE kUmfrage=" . intval($cKey), 1);
						$oObjekt->cSeo = $oUmfrage->cSeo;
						break;
				}

				$cURL = baueURL($oObjekt, $cURLArt_arr[$i]);

				$params['text'] = str_replace("$#" . $cParameter . $cKey . ":" . $cName . "#$", "<a href='" . URL_SHOP . "/" . $cURL . "'>" . $cName . "</a>", $params['text']);
			}
		}
	}

	return $params['text'];
}

function gibPreisStringLocalizedSmarty($params, &$smarty)
{
    $oAufpreis;
    $cAufpreisLocalized = "";

    if(doubleval($params['fAufpreisNetto']) != 0)
    {
        $fAufpreisNetto         = doubleval($params['fAufpreisNetto']);
        $fVKNetto               = doubleval($params['fVKNetto']);
        $kSteuerklasse          = intval($params['kSteuerklasse']);
        $fVPEWert               = doubleval($params['fVPEWert']);
        $cVPEEinheit            = $params['cVPEEinheit'];
        $FunktionsAttribute_arr = $params['FunktionsAttribute'];

        $nGenauigkeit = 2;
        if(intval($FunktionsAttribute_arr[FKT_ATTRIBUT_GRUNDPREISGENAUIGKEIT]) > 0)
            $nGenauigkeit = intval($FunktionsAttribute_arr[FKT_ATTRIBUT_GRUNDPREISGENAUIGKEIT]);

        if(intval($params['nNettoPreise']) == 1)
        {
            $cAufpreisLocalized = gibPreisStringLocalized($fAufpreisNetto);
            $oAufpreis->cAufpreisLocalized = gibPreisStringLocalized($fAufpreisNetto);
            $oAufpreis->cPreisInklAufpreis = gibPreisStringLocalized($fAufpreisNetto + $fVKNetto);

            if($fAufpreisNetto > 0)
                $oAufpreis->cAufpreisLocalized = "+ ".$oAufpreis->cAufpreisLocalized;
            else
                $oAufpreis->cAufpreisLocalized = str_replace("-","- ",$oAufpreis->cAufpreisLocalized);

            if($fVPEWert > 0)
            {
                $oAufpreis->cPreisVPEWertAufpreis = gibPreisStringLocalized($fAufpreisNetto / $fVPEWert, $_SESSION['Waehrung'], 1, $nGenauigkeit) . " " . $GLOBALS['oSprache']->gibWert('vpePer', 'global') . " " . $cVPEEinheit;
                $oAufpreis->cPreisVPEWertInklAufpreis = gibPreisStringLocalized(($fAufpreisNetto + $fVKNetto) / $fVPEWert, $_SESSION['Waehrung'], 1, $nGenauigkeit) . " " . $GLOBALS['oSprache']->gibWert('vpePer', 'global') . " " . $cVPEEinheit;

                $oAufpreis->cAufpreisLocalized = $oAufpreis->cAufpreisLocalized . ", " . $oAufpreis->cPreisVPEWertAufpreis;
                $oAufpreis->cPreisInklAufpreis = $oAufpreis->cPreisInklAufpreis . ", " . $oAufpreis->cPreisVPEWertInklAufpreis;
            }
        }
        else
        {
            $cAufpreisLocalized = gibPreisStringLocalized(berechneBrutto($fAufpreisNetto, $_SESSION["Steuersatz"][$kSteuerklasse]));
            $oAufpreis->cAufpreisLocalized = gibPreisStringLocalized(berechneBrutto($fAufpreisNetto, $_SESSION["Steuersatz"][$kSteuerklasse]));
            $oAufpreis->cPreisInklAufpreis = gibPreisStringLocalized(berechneBrutto($fAufpreisNetto + $fVKNetto, $_SESSION["Steuersatz"][$kSteuerklasse]));

            if($fAufpreisNetto > 0)
                $oAufpreis->cAufpreisLocalized = "+ ".$oAufpreis->cAufpreisLocalized;
            else
                $oAufpreis->cAufpreisLocalized = str_replace("-","- ",$oAufpreis->cAufpreisLocalized);

            if($fVPEWert > 0)
            {
                $oAufpreis->cPreisVPEWertAufpreis = gibPreisStringLocalized(berechneBrutto($fAufpreisNetto / $fVPEWert, $_SESSION["Steuersatz"][$kSteuerklasse]), $_SESSION['Waehrung'], 1, $nGenauigkeit) . " " . $GLOBALS['oSprache']->gibWert('vpePer', 'global') . " " . $cVPEEinheit;
                $oAufpreis->cPreisVPEWertInklAufpreis = gibPreisStringLocalized(berechneBrutto(($fAufpreisNetto + $fVKNetto) / $fVPEWert, $_SESSION["Steuersatz"][$kSteuerklasse]), $_SESSION['Waehrung'], 1, $nGenauigkeit) . " " . $GLOBALS['oSprache']->gibWert('vpePer', 'global') . " " . $cVPEEinheit;

                $oAufpreis->cAufpreisLocalized = $oAufpreis->cAufpreisLocalized . ", " . $oAufpreis->cPreisVPEWertAufpreis;
                $oAufpreis->cPreisInklAufpreis = $oAufpreis->cPreisInklAufpreis . ", " . $oAufpreis->cPreisVPEWertInklAufpreis;
            }
        }
    }

    if(intval($params['bAufpreise']))
        return $oAufpreis->cAufpreisLocalized;
    else
        return $oAufpreis->cPreisInklAufpreis;
}

function hasCheckBoxForLocation($params, &$smarty)
{               
    require_once(PFAD_ROOT . PFAD_CLASSES . "class.JTL-Shop.CheckBox.php");
    
    $oCheckBox = new CheckBox();
    $oCheckBox_arr = $oCheckBox->getCheckBoxFrontend(intval($params['nAnzeigeOrt']), 0, true, true);
    
    $smarty->assign($params['bReturn'], count($oCheckBox_arr) > 0);
}

function getCheckBoxForLocation($params, &$smarty)
{               
    $cCheckBox = "";
    require_once(PFAD_ROOT . PFAD_CLASSES . "class.JTL-Shop.CheckBox.php");
    
    $oCheckBox = new CheckBox();
    $oCheckBox_arr = $oCheckBox->getCheckBoxFrontend(intval($params['nAnzeigeOrt']), 0, true, true);
    
    if(count($oCheckBox_arr) > 0)
    {
        foreach($oCheckBox_arr as $oCheckBox)
        {
            // Link URL bauen
            $cLinkURL = "";
            if($oCheckBox->kLink > 0)
            {
                $oLinkTMP = $GLOBALS['DB']->executeQuery("SELECT cSeo
                                                        FROM tseo
                                                        WHERE cKey = 'kLink'
                                                            AND kKey = " . $oCheckBox->kLink . "
                                                            AND kSprache = " . $_SESSION['kSprache'], 1);
                                
                if(isset($oLinkTMP->cSeo) && strlen($oLinkTMP->cSeo) > 0)
                    $oCheckBox->oLink->cLocalizedSeo[$_SESSION['cISOSprache']] = $oLinkTMP->cSeo;
                
                $cLinkURL = baueURL($oCheckBox->oLink, URLART_SEITE);
            }
            
            // Fehlende Angaben
            $bError = false;
            if($params['cPlausi_arr'][$oCheckBox->cID])
                $bError = true;
            
            if($bError)
                $cCheckBox .= '<li class="clear error_block">';
            else
                $cCheckBox .= '<li class="clear">';
            
            $cChecked = "";
            $cPost_arr = $params['cPost_arr'];
            if(isset($cPost_arr[$oCheckBox->cID]))
                $cChecked = ' checked="checked"';
            
            $cCheckBox .= '
              <label for="' . $oCheckBox->cID . '">
                 <input type="checkbox" name="' . $oCheckBox->cID . '" value="Y" id="' . $oCheckBox->cID . '"' . $cChecked . ' /> ' . $oCheckBox->oCheckBoxSprache_arr[$_SESSION['kSprache']]->cText;
            
            if(strlen($cLinkURL) > 0)
            {
                $sep = (parse_url($cLinkURL, PHP_URL_QUERY) == NULL) ? '?' : '&';
               $cLinkURL .= $sep . 'exclusive_content=1';

               $cCheckBox .= ' (<a href="#" onclick="return open_window(\'' . gibShopURL() . '/' . $cLinkURL . '\', 1100, 980)">' . $GLOBALS['oSprache']->gibWert('read', 'account data') . '</a>)';         
            }
            
            if($oCheckBox->nPflicht == 1)
                 $cCheckBox .= '<em>*</em>';
            
            if(isset($oCheckBox->oCheckBoxSprache_arr[$_SESSION['kSprache']]->cBeschreibung) && strlen($oCheckBox->oCheckBoxSprache_arr[$_SESSION['kSprache']]->cBeschreibung) > 0)
                $cCheckBox .= '
                 <a href="#" onclick="return false;" class="checkboxInfo" alt="' . $oCheckBox->oCheckBoxSprache_arr[$_SESSION['kSprache']]->cBeschreibung . '" title="' . $oCheckBox->oCheckBoxSprache_arr[$_SESSION['kSprache']]->cBeschreibung . '"></a>                    
                 ';
            
            if($bError)
                $cCheckBox .= '<p class="error_text">' . $GLOBALS['oSprache']->gibWert('pleasyAccept', 'account data') . '</p>';
                    
            $cCheckBox .= '
              </label>
           </li>';
        }
    }
    
    return $cCheckBox;
}

function aaURLEncode($params, &$smarty)
{    
    $bReset = false;
    if(isset($params['nReset']) && intval($params['nReset']) == 1)
        $bReset = true;
           
    $cURL = $_SERVER['REQUEST_URI'];
    $cParameter_arr = array("&aaParams", "?aaParams", "&aaReset", "?aaReset");
    $aaEnthalten = false;
    foreach($cParameter_arr as $cParameter)
    {
        $aaEnthalten = strpos($cURL, $cParameter);
        if($aaEnthalten !== false)
        {
            $cURL = substr($cURL, 0, $aaEnthalten);
            break;
        }
        
        $aaEnthalten = false;
    }
    
    if($aaEnthalten !== false)
        $cURL = substr($cURL, 0, $aaEnthalten);
    
    if(isset($params['bUrlOnly']) && intval($params['bUrlOnly']) == 1)
        return $cURL;
    
    $cParams = "";
    unset($params['nReset']);
    if(is_array($params) && count($params) > 0)
    {
        foreach($params as $key => $param)
            $cParams .= $key . "=" . $param . ";";
    }
    
    if(strpos($cURL, "?") !== false)
        $cURL .= $bReset ? "&aaReset=" : "&aaParams=";
    else
        $cURL .= $bReset ? "?aaReset=" : "?aaParams=";
    
    return $cURL . base64_encode($cParams);
}

function get_product_list($params, &$smarty)
{
    require_once(PFAD_ROOT . PFAD_INCLUDES . "filter_inc.php");
    
    $nLimit = intval($params['nLimit']);
    $cAssing = "oCustomArtikel_arr";
    if(isset($params['cAssign']) && strlen($params['cAssign']) > 0)
        $cAssing = $params['cAssign'];
    
    $cMerkmalFilter_arr = setzeMerkmalFilter(explode(";", $params['cMerkmalFilter']));
    $cSuchFilter_arr    = setzeSuchFilter(explode(";", $params['cSuchFilter']));
    $cTagFilter_arr     = setzeTagFilter(explode(";", $params['cTagFilter']));
    
    $cParameter_arr = array("kKategorie" => $params['kKategorie'],
                            "kHersteller" => $params['kHersteller'],
                            "kArtikel" => $params['kArtikel'],
                            "kVariKindArtikel" => $params['kVariKindArtikel'],
                            "kSeite" => $params['kSeite'],
                            "kSuchanfrage" => $params['kSuchanfrage'],
                            "kMerkmalWert" => $params['kMerkmalWert'],
                            "kTag" => $params['kTag'],
                            "kSuchspecial" => $params['kSuchspecial'],
                            "kNews" => $params['kNews'],
                            "kNewsMonatsUebersicht" => $params['kNewsMonatsUebersicht'],
                            "kNewsKategorie" => $params['kNewsKategorie'],
                            "kUmfrage" => $params['kUmfrage'],
                            "kKategorieFilter" => $params['kKategorieFilter'],
                            "kHerstellerFilter" => $params['kHerstellerFilter'],
                            "nBewertungSterneFilter" => $params['nBewertungSterneFilter'],
                            "cPreisspannenFilter" => $params['cPreisspannenFilter'],
                            "kSuchspecialFilter" => $params['kSuchspecialFilter'],
                            "nSortierung" => $params['nSortierung'],
                            "MerkmalFilter_arr" => $cMerkmalFilter_arr,
                            "TagFilter_arr" => $cTagFilter_arr,
                            "SuchFilter_arr" => $cSuchFilter_arr,                    
                            "nArtikelProSeite" => $params['nArtikelProSeite'],
                            "cSuche" => $params['cSuche'],
                            "seite" => $params['seite'],
                            "cArtAttrib" => $params['cArtAttrib']);
    
    $NaviFilter;
    $NaviFilter = baueNaviFilter($NaviFilter, $cParameter_arr);
    
    // Artikelattribut
    if(isset($cParameter_arr['cArtAttrib']) && strlen($cParameter_arr['cArtAttrib']) > 0)
        $NaviFilter->ArtikelAttributFilter->cArtAttrib = $cParameter_arr['cArtAttrib'];
    
    //Filter SQLs Objekte
    $FilterSQL = bauFilterSQL($NaviFilter);
    
    // Artikelliste
    $oArtikel_arr = gibArtikelKeys($FilterSQL, $nLimit, $NaviFilter, true);
    
    $smarty->assign($cAssing, $oArtikel_arr);
    
    if($params['bReturn'])
        return $oArtikel_arr;
}

function has_navigation($params, &$smarty)
{
   $cType = $params['type'];
   $oLink = null;
   
   if (strlen($cType) > 0)
      $oLink = $_SESSION['Linkgruppen']->{$cType};
   
   return is_object($oLink);
}

function get_navigation_plain($params, &$smarty)
{
   $cType = $params['type'];
   $cAssign = $params['assign'];
   $oLink = null;
   
   if (strlen($cType) > 0)
      $oLink = $_SESSION['Linkgruppen']->{$cType};
   
   if (!is_object($oLink) || strlen($cAssign) == 0)
      return;

   $oLink_arr = build_navigation_subs($oLink->Links);

   $smarty->assign($cAssign, $oLink_arr);
}

function get_navigation($params, &$smarty)
{
   $cType = $params['type'];
   $oLink = null;
   
   if (strlen($cType) > 0)
      $oLink = $_SESSION['Linkgruppen']->{$cType};
   
   if (!is_object($oLink))
      return;

   $oLink_arr = build_navigation_subs($oLink->Links);
   $cTemplate = build_navigation_layout($oLink_arr, $params);

   return $cTemplate;
}

function build_navigation_subs($oLink_arr, $kVaterLink = 0)
{
   $oNew_arr = array();
   foreach ($oLink_arr as &$oLink)
   {
      if ($oLink->kVaterLink == $kVaterLink)
      {
         $oLink->oSub_arr = build_navigation_subs($oLink_arr, $oLink->kLink);
         $oNew_arr[] = $oLink;
      }
   }
   return $oNew_arr;
}

function build_navigation_layout($oLink_arr, $cParam_arr = array())
{
   $cTemplate = "";
   $cISO = $_SESSION['cISOSprache'];
   foreach ($oLink_arr as $oLink)
   {
      $cClassActive = "";
      if ($GLOBALS['kLink'] == $oLink->kLink)
         $cClassActive = ' class="active"';

      $cTemplate .= "<li{$cClassActive}>";
	  $cTemplate .= "<a href='{$oLink->URL}'>{$oLink->cLocalizedName[$cISO]}</a>";
      if (count($oLink->oSub_arr) > 0)
         $cTemplate .= build_navigation_layout($oLink->oSub_arr);
      $cTemplate .= "</li>";
   }
   
   $cClass = "";
   if (isset($cParam_arr['class']))
      $cClass = " class=\"{$cParam_arr['class']}\"";
   
   $cTemplate = "<ul{$cClass}>{$cTemplate}</ul>";
   
   return $cTemplate;
}

function get_category_list($params, &$smarty)
{
    require_once(PFAD_ROOT . PFAD_CLASSES . "class.JTL-Shop.Kategorie.php");
    
    $oKategorie_arr = array();
    
    if(!isset($params['cKatAttrib']) || strlen($params['cKatAttrib']) == 0)
        return false;
    
    // Limit
    $cLimit = "";
    if(isset($params['nLimit']) && intval($params['nLimit']) > 0)
        $cLimit = " LIMIT " . intval($params['nLimit']);
    
    // Assign
    $cAssing = "oCustomKategorie_arr";
    if(isset($params['cAssign']) && strlen($params['cAssign']) > 0)
        $cAssing = $params['cAssign'];
    
    // Sprache
    $kSprache = 0;
    if(isset($params['kSprache']) && intval($params['kSprache']) > 0)
        $kSprache = intval($params['kSprache']);
    elseif(isset($_SESSION['kSprache']) && intval($_SESSION['kSprache']) > 0)
        $kSprache = intval($_SESSION['kSprache']);
    else
    {
        $oSprache = gibStandardsprache(true);
        $kSprache = $oSprache->kSprache;
    }
    
    // Kundengruppe
    $kKundengruppe = 0;
    if(isset($params['kKundengruppe']) && intval($params['kKundengruppe']) > 0)
        $kKundengruppe = intval($params['kKundengruppe']);
    elseif(isset($_SESSION['Kundengruppe']->kKundengruppe) && intval($_SESSION['kKundengruppe']->kKundengruppe) > 0)
        $kKundengruppe = intval($_SESSION['kKundengruppe']->kKundengruppe);
    else
        $kKundengruppe = gibStandardKundengruppe();
    
    $oKat_arr = $GLOBALS['DB']->executeQuery("SELECT tkategorie.kKategorie
                                                FROM tkategorie
                                                JOIN tkategorieattribut ON tkategorieattribut.kKategorie = tkategorie.kKategorie
                                                    AND tkategorieattribut.cName = '" . filterXSS($params['cKatAttrib']) . "'
                                                ORDER BY tkategorie.nSort, tkategorie.cName" . $cLimit, 2);
    
    if(is_array($oKat_arr) && count($oKat_arr) > 0)
    {
        foreach($oKat_arr as $oKat)
        {
            if($oKat->kKategorie > 0)
                $oKategorie_arr[] = new Kategorie($oKat->kKategorie, $kSprache, $kKundengruppe);
        }
    }
    
    $smarty->assign($cAssing, $oKategorie_arr);
    
    if($params['bReturn'])
        return $oKategorie_arr;
}

function holeFirmaDaten($params, &$smarty)
{
	$oFirma = $GLOBALS['DB']->executeQuery("SELECT t.* FROM tfirma as t", 1);
	
	$smarty->assign($params['return'], $oFirma);
}

function holeHersteller($params, &$smarty){
	
	$oHersteller = $GLOBALS['DB']->executeQuery("SELECT thersteller.cName, thersteller.cSeo, thersteller.cBildpfad 
														FROM thersteller
														JOIN tartikel ON thersteller.kHersteller = tartikel.kHersteller
														GROUP BY thersteller.kHersteller
														ORDER BY thersteller.cName ASC", 2);
	
	if(count($oHersteller) > 0)
		$smarty->assign($params['return'], $oHersteller);
}

?>