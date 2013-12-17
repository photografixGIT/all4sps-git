{**
 * copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 *
 * this file may not be redistributed in whole or significant part
 * and is subject to the JTL-Software-GmbH license.
 *
 * license: http://jtl-software.de/jtlshop3license.html
 *}
 
{if $Products && $Products|@count > 0}
    
    <form action="index.php" method="post" id="form_bundles">
        <fieldset>
            <input type="hidden" name="a" value="{$ProductMain->kArtikel}" />
            <input type="hidden" name="addproductbundle" value="1" />
            <input type="hidden" name="aBundle" value="{$ProductKey}" />
            
            <div class="product_bundle">
            
                <div class="header">
                    {lang key="buyProductBundle" section="productDetails"}:
                </div>
                
                <div class="bundle clearall">
                    <ul>
            {foreach name=bundles from=$Products item=Product}
                    <li>
                        <a href="{$Product->cURL}">
                            <img src="{$Product->Bilder[0]->cPfadMini}" alt="{$Product->cName}" title="{$Product->cName}" />
                        </a>
                    </li>
                {if !$smarty.foreach.bundles.last}
                    <li>
                        <span class="plus">+</span>
                    </li>
                {/if}
            {/foreach}
                    </ul>
                </div>
            
                <div class="footer clearall">
                {if $smarty.session.Kundengruppe->darfPreiseSehen}
                    <div class="price">
                        <p><span class="price">{lang key="priceForAll" section="productDetails"}: {$ProduktBundle->cPriceLocalized[$NettoPreise]}</span></p>                
                    {if $ProduktBundle->fPriceDiff > 0}
                        <p><span class="discount">{lang key="youSave" section="productDetails"}: {$ProduktBundle->cPriceDiffLocalized[$NettoPreise]}</span></p>
                    {/if}
                    {if $ProductMain->cLocalizedVPE}
                        <p><small class="base_price"><b class="label">{lang key="basePrice" section="global"}: </b><span class="value">{$ProductMain->cLocalizedVPE[$NettoPreise]}</span></small></p>
                   {/if}
                        <p><span class="vat_info">{$Product->cMwstVersandText}</span></p>
                    </div>                               
                {/if}
                    <div class="basket">
                        <span><button name="inWarenkorb" type="submit" value="{lang key="addAllToCart" section="global"}" class="submit"><span>{lang key="addAllToCart" section="global"}</span></button></span>
                    </div>
                </div>
            
            </div>
        </fieldset>
    </form>
    
{/if}