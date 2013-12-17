<?php
/**
 * copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 *
 * this file may not be redistributed in whole or significant part
 * and is subject to the JTL-Software-GmbH license.
 *
 * license: http://jtl-software.de/jtlshop3license.html
 */

require_once('includes/globalinclude.php');

// session starten
$session = new Session();

// erstelle $smarty
require_once(PFAD_INCLUDES . 'smartyInlcude.php');

// setze seitentyp
setzeSeitenTyp(PAGE_UNBEKANNT);

// einstellungen
$Einstellungen = getEinstellungen(array(CONF_GLOBAL,CONF_RSS));

$cAction = strtolower($_GET['a']);
$kCustom = intval($_GET['k']);
$bNoData = false;

switch ($cAction)
{
   case 'download_vorschau':
   {
      if (class_exists('Download'))
      {
         $oDownload = new Download($kCustom);
         if ($oDownload->getDownload() > 0)
         {
            $smarty->assign('oDownload', $oDownload);
         }
         else
         {
            $bNoData = true;
         }
      
      }
   
      break;
   }

   default:
   {
      $bNoData = true;
      break;
   }
}

$smarty->assign('bNoData', $bNoData);
$smarty->assign('cAction', $cAction);
$smarty->assign('Einstellungen', $Einstellungen);

require_once(PFAD_INCLUDES . 'letzterInclude.php');

$smarty->display('popup.tpl');
?>