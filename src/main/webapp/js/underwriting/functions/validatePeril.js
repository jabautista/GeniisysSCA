/*	Created by	: mark jm 07.28.2011
 * 	Moved from	: peril information page
 */
function validatePeril(){
	try{
		//var index		= $("perilCd").selectedIndex;
		var premRt      = 0;
		var tsiAmt      = 0;
		var premAmt     = 0;
		var annTsiAmt   = 0;
		var annPremAmt  = 0;
		var riCommRt	= $F("riCommRt").replace(/,/g, "");
		var riCommAmt  	= 0;
		var issCd 		= (objUWGlobal.packParId != null ? objCurrPackPar.issCd : $F("globalIssCd"));
		var paramName	= $F("paramName"); 
		var issCdRi		= $F("issCdRi");
		var tarfRate 	= "";
		var inputPremAmt = $F("premiumAmt").replace(/,/g, "");
		var riCommAmt  	 = 0;
		//var defaultRate	 = $("txtPerilName").getAttribute("defaultRate");	//$("perilCd").options[index].getAttribute("defaultRate"); //belle 11.09.2011
		//var defaultTsi	 = $("txtPerilName").getAttribute("defaultTsi");	//$("perilCd").options[index].getAttribute("defaultTsi");
		var prorateFlag  = parseFloat($F("prorateFlag")); 
		var premAmt		 = computePerilPremAmount(prorateFlag, $("ctplDfltTsiAmt").value, $("perilRate").value);
		
		if ($("tarfCd") != null){
			tarfRate = $("tarfCd").options[$("tarfCd").selectedIndex].getAttribute("tariffRate");
		}
		
		if (objUWParList.issCd == "RI"){
			if (!("0" == riCommRt)){
				$("perilRiCommRate").value = riCommRt;
				$("perilRiCommAmt").value = formatCurrency((parseFloat(riCommRt == "" ? 0 : riCommRt)* parseFloat(inputPremAmt == "" ? 0 : inputPremAmt))/100);
			}
		} 
			if (((0 == parseFloat($F("perilTsiAmt"))) || ("" == $F("perilTsiAmt"))) 
					&& ((0 == parseFloat($F("premiumAmt"))) || ("" == $F("premiumAmt"))) 
					&& (!(issCd == issCdRi))&& ("" == $F("compRem"))){
				if ("" != tarfRate){
					$("perilRate").value = formatToNineDecimal(tarfRate);
				}
			}
			
			/* moved before retrieval of default amounts from peril maintenance.
			 * Priority : 1. CTPL parameter 2. peril maintenance
			 * */
			if (objUWParList.issCd != "RI"){
				if (objUWGlobal.lineCd == objLineCds.MC && $("perilCd").value == $("ctplCd").value 
						&& ("" == $("perilTsiAmt").value || 0 == $("perilTsiAmt").value)) {
					$("perilTsiAmt").value = formatCurrency($("ctplDfltTsiAmt").value);
					$("premiumAmt").value  = formatCurrency((premAmt == "0.00")? "" : premAmt);
					$("perilRate").value = "";
				}
			}
			
			if (((0 == parseFloat($F("perilTsiAmt"))) || ("" == $F("perilTsiAmt"))) 
					&& ((0 == parseFloat($F("premiumAmt"))) || ("" == $F("premiumAmt")))
					&& ((0 == parseFloat($F("perilRate"))) || ("" == $F("perilRate")))
					&& (!(issCd == issCdRi)) && ("" == $F("compRem"))){ 
				if (!("" == $F("defaultRate")) || !("" == $F("defaultTsi"))){ //added defaultTsi by Jdiago 09.09.2014
					$("perilTsiAmt").value = formatCurrency($("defaultTsi").value); //added by Jdiago 09.09.2014
					$("perilRate").value = formatToNineDecimal($("defaultRate").value); //belle 11.09.2011
					$("premiumAmt").value = formatCurrency($F("defaultTsi") * $F("defaultRate")/100); //apollo 09.18.2014
				}
			}
			
		//added by robert 10.30.2014
		if ("" != $("perilTsiAmt").value){
			getPostTextTsiAmtDetails2();
		}
	}catch(e){
		showErrorMessage("validatePeril", e);
	}	
}