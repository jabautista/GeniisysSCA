/**
 * Set list of values for currency
 * @param defaultCurrencyCd - the default currencyCd
 * 
 */

function setCurrencyLov(defaultCurrencyCd){
	var selCurrency = $("selCurrency");
	var currencyObj = null;
	selCurrency.update("<option></option>");
	for(var i=0; i<objItemCurrencyLov.length; i++){
		currencyObj = objItemCurrencyLov[i];
		var currencyOption = new Element("option");
		currencyOption.innerHTML = currencyObj.desc;
		currencyOption.setAttribute("value", currencyObj.code);
		currencyOption.setAttribute("currencyCd", currencyObj.code);
		currencyOption.setAttribute("currencyRate", currencyObj.valueFloat);
		currencyOption.setAttribute("currencyDesc", currencyObj.desc);
		if(defaultCurrencyCd!=null){
			if(defaultCurrencyCd==currencyObj.code){
				currencyOption.setAttribute("selected", "selected");
				currencyOption.setAttribute("isdefault", "true");
				$("txtCurrencyRate").value = formatToNineDecimal(currencyObj.valueFloat);
			}
		}
		selCurrency.add(currencyOption,null);
	}
}