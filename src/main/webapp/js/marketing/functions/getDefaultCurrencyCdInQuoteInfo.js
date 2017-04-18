/**
 * Cannot be used in other pages other than quotationInformationMain.js
 * @return
 */
function getDefaultCurrencyCdInQuoteInfo(){
	var currencyObj = null;
	var currencyOpts = $("selCurrency").options;
	for(var i=0; i<currencyOpts.length; i++){
		var opts = currencyOpts[i];
		if(opts.getAttribute("isDefault") != null && opts.getAttribute("isDefault") != ""){
			if(opts.getAttribute("isDefault") == "true"){
				currencyObj = new Object();
				currencyObj.currencyRate	= opts.getAttribute("currencyRate");
				currencyObj.currencyCd		= opts.getAttribute("currencyCd");
				currencyObj.currencyName	= opts.getAttribute("currencyDesc");
				i = currencyOpts.length; // stop loop
			}
		}
	}
	return currencyObj;
}