{if isset($oImageMap)}
    <div class="container">
        <div class="imagemap" style="background: #fff url('{$oImageMap->cBildPfad}') top left no-repeat; width:{$oImageMap->fWidth}px; height: {$oImageMap->fHeight}px;position:relative;">
            <div class="imagemap_wrapper">
                {foreach from=$oImageMap->oArea_arr item=oImageMapArea}
                    <div id="area{$oImageMapArea->kImageMapArea}" class="area {$oImageMapArea->cStyle}" style="left:{$oImageMapArea->oCoords->x}px;top:{$oImageMapArea->oCoords->y}px;width:{$oImageMapArea->oCoords->w}px;height:{$oImageMapArea->oCoords->h}px">
                        <a {if $oImageMapArea->cUrl|@strlen > 0}href="{$oImageMapArea->cUrl}"{/if} title="{$oImageMapArea->cTitel|strip_tags|escape:"html"|escape:"quotes"}"></a>
                    </div>
                    {if $oImageMapArea->cBeschreibung|strlen > 0}
                        <div id="area{$oImageMapArea->kImageMapArea}_desc" class="area_desc {$oImageMapArea->cStyle}" style="left:{$oImageMapArea->oCoords->x}px;top:{$oImageMapArea->oCoords->y+$oImageMapArea->oCoords->h}px">
                            {if $oImageMapArea->oArtikel || $oImageMapArea->cBeschreibung|@strlen > 0}
                                {assign var="oArtikel" value=$oImageMapArea->oArtikel}
                                <div class="custom_content nomargin">
                                    {if $oImageMapArea->oArtikel}
                                        <div class="photo"><a href="{$oArtikel->cURL}"><img src="{$oArtikel->cVorschaubild}" alt="{$oArtikel->cName|strip_tags|escape:"quotes"|truncate:60}" class="image" /></a></div>
                                            {/if}
                                    <strong class="title">{$oImageMapArea->cTitel}</strong>
                                    {if $oImageMapArea->oArtikel}
                                        {include file="tpl_inc/artikel_preis.tpl" Artikel=$oArtikel scope="box"}
                                    {/if}
                                    {if $oImageMapArea->cBeschreibung|@strlen > 0}
                                        <div class="description">
                                            {$oImageMapArea->cBeschreibung}
                                        </div>
                                    {/if}
                                </div>
                            {/if}
                        </div>
                    {/if}
                {/foreach}
            </div>
        </div>

        <script type="text/javascript">
            {literal}
                $(function() {
                   $('.imagemap').each(function(idx, item) {
                      // area desc
                      $(this).find('.area').each(function(idx, area) {
                         var area_id = '#' + $(area).attr('id');
                         var area_desc = $(area_id + '_desc');
                         if ($(area_desc).length > 0) {

                            $(area_id + ' > a').mouseenter(function() {
                               $(area_desc).fadeIn(500);
                            }).mouseleave(function() {
                               $(area_desc).stop(true, true);
                               $(area_desc).fadeOut(500);
                            });

                         }
                      });

                      // toggle areas
                      $(item).mouseenter(function() {
                         $(this).find('.area').each(function(idx, area) {
                            $(area).fadeIn(500);
                         });
                      }).mouseleave(function() {
                         $(this).find('.area').each(function(idx, area) {
                            $(area).stop(true, true);
                            $(area).fadeOut(500);
                         });
                      });
                   });
                });
            {/literal}
        </script>
    </div>
{/if}
{if isset($oSlider) && count($oSlider->oSlide_arr) > 0}
    <div class="slider-wrapper theme-{$oSlider->cTheme}">
        <div id="slider" class="nivoSlider">
            {foreach from=$oSlider->oSlide_arr item=oSlide}
                {if !empty($oSlide->cLink)}
                    <a href="{$oSlide->cLink}" target="_blank">
                {/if}
                <img alt="{$oSlide->cTitel}" src="{$oSlide->cBildAbsolut}" {if !empty($oSlide->cThumbnailAbsolut) && $oSlider->bThumbnail == '1'} data-thumb="{$oSlide->cThumbnailAbsolut}"{/if}{if !empty($oSlide->cTitel) || !empty($oSlide->cText)}title="{if !empty($oSlide->cTitel)}{$oSlide->cTitel|strip_tags|escape:"html"|escape:"quotes"} -{/if} {$oSlide->cText|strip_tags|escape:"html"|escape:"quotes"}"{/if}/>
                {if !empty($oSlide->cLink)}
                    </a>
                {/if}
            {/foreach}
        </div>
    </div>
    <script type="text/javascript">
		$(window).load(function() {ldelim}
            $('#slider').nivoSlider( {ldelim}
                effect: '{$oSlider->cEffects|replace:';':','}', 
                animSpeed: {$oSlider->nAnimationSpeed},
                pauseTime: {$oSlider->nPauseTime},
                directionNav: {$oSlider->bDirectionNav},
                controlNav: {$oSlider->bControlNav},
                controlNavThumbs: {$oSlider->bThumbnail},
                pauseOnHover: {$oSlider->bPauseOnHover},
                prevText: '{lang key="sliderPrev" section="media"}',
                nextText: '{lang key="sliderNext" section="media"}',
                randomStart: {$oSlider->bRandomStart}
            {rdelim});
        {rdelim});
    </script>
{/if}
