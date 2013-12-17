<?php
require_once("includes/globalinclude.php");
require_once(PFAD_ROOT . PFAD_CLASSES . "class.JTL-Shop.News.php");
require_once(PFAD_ROOT . PFAD_CLASSES . "class.JTL-Shop.NewsJson.php");

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

$xEinstellung_arr = getEinstellungen(array(CONF_GLOBAL));
$nLimit = (isset($_REQUEST["limit"]) && intval($_REQUEST["limit"]) > 0) ? intval($_REQUEST["limit"]) : 100;

// Load News
$oNews_arr = News::loadAll(true, null, $nLimit);

if ($oNews_arr !== null)
{
    if (isset($_REQUEST["notimeline"]) && intval($_REQUEST["notimeline"]) == 1)
        echo json_encode(utf8_convert_recursive($oNews_arr, true));
    else
    {
	    $oNewsJson = new NewsJson("{$xEinstellung_arr['global_shopname']} News", "Es war einmal...", date("Y,m,d"), $oNews_arr);
	    echo $oNewsJson->toJson();
    }
}
else
    echo json_encode(array());
?>