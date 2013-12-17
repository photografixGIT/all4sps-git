<div id="comment{$oBewertung->kBewertung}" class="hreview comment {if $Einstellungen.bewertung.bewertung_hilfreich_anzeigen == "Y" && $smarty.session.Kunde->kKunde > 0 && $smarty.session.Kunde->kKunde != $oBewertung->kKunde}use_helpful{/if} {if isset($bMostUseful) && $bMostUseful}most_useful{/if}">
   {if $oBewertung->nHilfreich > 0}
      <p class="box_notice">
         {if $oBewertung->nHilfreich > 0}
            {$oBewertung->nHilfreich}
         {else}
            {lang key="nobody" section="product rating"}
         {/if}
         {lang key="from" section="product rating"} {$oBewertung->nAnzahlHilfreich}
         {if $oBewertung->nAnzahlHilfreich > 1}
            {lang key="ratingHelpfulCount" section="product rating"}
         {else}
            {lang key="ratingHelpfulCountExt" section="product rating"}
         {/if}
      </p>
   {/if}
   <p class="title summary">
      {$oBewertung->cTitel}
      <span class="rating">
         <span class="fn">{$oBewertung->cName}.</span>, <span class="dtreviewed">{$oBewertung->Datum}</span> <span class="stars p{$oBewertung->nSterne}"><span class="rating hidden">{$oBewertung->nSterne}</span></span>
      </span>
   </p>
   <p class="text description">
      {$oBewertung->cText|nl2br}
   </p>
   {if $Einstellungen.bewertung.bewertung_hilfreich_anzeigen == "Y"}
      {if $smarty.session.Kunde->kKunde > 0 && $smarty.session.Kunde->kKunde != $oBewertung->kKunde}
         <p class="helpfully hidden vmiddle" id="help{$oBewertung->kBewertung}">
            <span>{lang key="isRatingHelpful" section="product rating"}?</span>
            <span class="button_help">
               <button class="helpful" title="{lang key="yes"}" name="hilfreich_{$oBewertung->kBewertung}" type="submit"></button> {lang key="yes"}
            </span>
            <span class="button_help">
               <button class="not_helpful" title="{lang key="no"}" name="nichthilfreich_{$oBewertung->kBewertung}" type="submit"></button> {lang key="no"}
            </span>
         </p>
      {/if}
   {/if}
</div>