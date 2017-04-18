function setPackQuotationMenu(){
	/*disableMenu("bondPolicyData");
	disableMenu("quoteCarrierInfo");
	disableMenu("quoteEngineeringInfo");*/
	if(objGIPIPackQuotations.length != 0){
		for(var i=0; i<objGIPIPackQuotations.length; i++){
			var lineCd = objGIPIPackQuotations[i].lineCd;
			var menuLineCd = objGIPIPackQuotations[i].menuLineCd;
			if(lineCd == "EN" || menuLineCd == "EN"){
				enableMenu("quoteEngineeringInfo");
				disableMenu("bondPolicyData");
				disableMenu("quoteCarrierInfo");
			}else if(lineCd == "SU" || menuLineCd == "SU"){
				enableMenu("bondPolicyData");
				disableMenu("quoteCarrierInfo");
				disableMenu("quoteEngineeringInfo");
			}else if(lineCd == "MN" || menuLineCd == "MN"){
				enableMenu("quoteCarrierInfo");
				disableMenu("bondPolicyData");
				disableMenu("quoteEngineeringInfo");
			}else if(lineCd == "MH" || menuLineCd == "MH"){
				//enableMenu("quoteCarrierInfo"); commented by: Nica 06.19.2012
				disableMenu("bondPolicyData");
				disableMenu("quoteEngineeringInfo");
			}
		}
	}
}