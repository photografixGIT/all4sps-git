<?php
/**
 * copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 *
 * this file may not be redistributed in whole or significant part
 * and is subject to the JTL-Software-GmbH license.
 *
 * license: http://jtl-software.de/jtlshop3license.html
 */

require_once("includes/globalinclude.php");
require_once("includes/kontakt_inc.php");
require_once(PFAD_INCLUDES."mailTools.php");
$AktuelleSeite = "Ankauf";


//session starten
$session = new Session();

//erstelle $smarty
require_once(PFAD_INCLUDES."smartyInlcude.php");

//setze seitentyp
//setzeSeitenTyp(PAGE_KONTAKT);
$nSeitenTyp = "";

$Einstellungen = getEinstellungen(array(CONF_GLOBAL,CONF_RSS,CONF_KONTAKTFORMULAR));

$kLink = "test";

//hole alle OberKategorien
$AlleOberkategorien = new KategorieListe();
$AlleOberkategorien->getAllCategoriesOnLevel(0);
$AktuelleKategorie = new Kategorie(verifyGPCDataInteger("kategorie"));
$AufgeklappteKategorien = new KategorieListe();
$AufgeklappteKategorien->getOpenCategories($AktuelleKategorie);
$startKat = new Kategorie();
$startKat->kKategorie=0;

$cCanonicalURL = "";

// SSL?
pruefeHttps();

if(pruefeBetreffVorhanden())
{
    $step = "formular";
    $fehlendeAngaben = array();
    if (isset($_POST['kontakt']) && intval($_POST['kontakt'])==1)
    {
        $fehlendeAngaben = gibFehlendeEingabenKontaktformular();

        require_once(PFAD_ROOT . PFAD_INCLUDES . "tools.Global.php");
        $kKundengruppe = gibAktuelleKundengruppe();

        // CheckBox Plausi
        require_once(PFAD_ROOT . PFAD_CLASSES . "class.JTL-Shop.CheckBox.php");
        $oCheckBox = new CheckBox();
        $fehlendeAngaben = array_merge($fehlendeAngaben, $oCheckBox->validateCheckBox(CHECKBOX_ORT_KONTAKT, $kKundengruppe, $_POST, true));

        $nReturnValue = eingabenKorrekt($fehlendeAngaben);
        $smarty->assign('cPost_arr', $_POST);

        // Hook
        executeHook(HOOK_KONTAKT_PAGE_PLAUSI);

        if ($nReturnValue)
        {
            if (!floodSchutz($Einstellungen['kontakt']['kontakt_sperre_minuten']))
            {
                $oNachricht = baueFormularVorgaben();

                 // CheckBox Spezialfunktion ausführen
                $oCheckBox->triggerSpecialFunction(CHECKBOX_ORT_KONTAKT, $kKundengruppe, true, $_POST, array("oKunde" => $oNachricht, "oNachricht" => $oNachricht));
                $oCheckBox->checkLogging(CHECKBOX_ORT_KONTAKT, $kKundengruppe, $_POST, true);

                bearbeiteNachricht();
                $step = "nachricht versendet";
            }
            else
                $step = "floodschutz";
        }
        else
            $smarty->assign('fehlendeAngaben', $fehlendeAngaben);
    }

    $lang = $_SESSION['cISOSprache'];
    $Contents = $GLOBALS["DB"]->executeQuery("select * from tspezialcontentsprache where nSpezialContent=\"".SC_KONTAKTFORMULAR."\" AND cISOSprache = '$lang'",2);
    $SpezialContent = new stdClass();
    foreach ($Contents as $Content)
    {
        $SpezialContent->{$Content->cTyp} = $Content->cContent;
    }

    $betreffs = $GLOBALS["DB"]->executeQuery("select * from tkontaktbetreff where (cKundengruppen=0 or cKundengruppen like \"".$_SESSION['Kundengruppe']->kKundengruppe.";\") order by nSort",2);
    for ($i=0;$i<count($betreffs);$i++)
    {
        if ($betreffs[$i]->kKontaktBetreff>0)
        {
            $betreffSprache = $GLOBALS["DB"]->executeQuery("select * from tkontaktbetreffsprache where kKontaktBetreff=".$betreffs[$i]->kKontaktBetreff." and cISOSprache=\"".$_SESSION['cISOSprache']."\"",1);
            $betreffs[$i]->AngezeigterName= $betreffSprache->cName;
        }
    }

    $Vorgaben = baueFormularVorgaben();

    // Canonical
    $cCanonicalURL = gibShopURL() . "/ankauf_anfrageformular.php";

    // Metaangaben
    $oMeta = baueSpecialSiteMeta(LINKTYP_KONTAKT, $lang);
    $cMetaTitle = $oMeta->cTitle;
    $cMetaDescription = $oMeta->cDesc;
    $cMetaKeywords = $oMeta->cKeywords;

    //spezifische assigns
    $smarty->assign('step',$step);
    $smarty->assign('code',generiereCaptchaCode($Einstellungen['kontakt']['kontakt_abfragen_captcha']));
    $smarty->assign('betreffs',$betreffs);
    $smarty->assign('hinweis',(isset($hinweis)) ? $hinweis : null);
    $smarty->assign('Vorgaben',$Vorgaben);
    $smarty->assign('fehlendeAngaben',$fehlendeAngaben);    
    $smarty->assign('nAnzeigeOrt', CHECKBOX_ORT_KONTAKT);
}
else
{
    Jtllog::writeLog("Kein Kontaktbetreff vorhanden! Bitte im Backend unter Einstellungen -> Kontaktformular -> Betreffs einen Betreff hinzufügen.", JTLLOG_LEVEL_ERROR); // Logging
    $smarty->assign('hinweis', $GLOBALS['oSprache']->gibWert('noSubjectAvailable', 'contact'));
}
   
$smarty->assign('Navigation',createNavigation($AktuelleSeite));
$smarty->assign('Spezialcontent',$SpezialContent);
$smarty->assign('requestURL',(isset($requestURL))?$requestURL:null);
$smarty->assign('Einstellungen',$Einstellungen);

require_once(PFAD_INCLUDES."letzterInclude.php");

// Hook
executeHook(HOOK_KONTAKT_PAGE);

$smarty->display('ankauf_anfrageformular.tpl');
//print_r($_SESSION['Kunde']);
?>