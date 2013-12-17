<div class="newsletterbox">
    <div class="page_width {if $Einstellungen.template.general.page_align == 'L'}page_left{else}page_center{/if}">
        <form method="post" action="newsletter.php" class="form">
            <fieldset class="newsletter">
                <input type="hidden" name="abonnieren" value="1" />
                <input type="hidden" name="{$session_name}" value="{$session_id}" />
                <ul>
                    <li class="left tleft p40 soc">
                        <strong>{lang key="socialmedia" section="global"}</strong>
                        <a class="google" href="{$Einstellungen.template.social.use_google}"></a>
                        <a class="twitter" href="{$Einstellungen.template.social.use_twitter}"></a>
                        <a class="facebook" href="{$Einstellungen.template.social.use_facebook}"></a>
                    </li>
                    <li class="left p60 tright">
                        <strong>{lang key="newsletter" section="newsletter"} {lang key="newsletterSendSubscribe" section="newsletter"}*</strong>
                        <input type="text" name="cEmail" id="email" class="placeholder" title="{lang key="emailadress"}" />
                        <input type="submit" value="{lang key="newsletterSendSubscribe" section="newsletter"}" />
                    </li>
                </ul>         
            </fieldset>
        </form>
    </div>
</div>