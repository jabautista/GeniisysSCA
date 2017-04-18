/*	Created by	: mark jm 12.13.2010
 * 	Description	: Fill-up fields with values in Motorcar
 * 	Parameters	: obj - the object that contains the details
 */
function supplyMCAdditional(obj){
	try{
		$("assignee").value			= obj == null ? "" : unescapeHTML2(nvl(unescapeHTML2(obj.assignee), ""));
		$("acquiredFrom").value		= obj == null ? "" : unescapeHTML2(nvl(unescapeHTML2(obj.acquiredFrom), ""));
		$("motorNo").value			= obj == null ? "" : unescapeHTML2(nvl(unescapeHTML2(obj.motorNo), ""));
		$("origin").value			= obj == null ? "" : unescapeHTML2(nvl(unescapeHTML2(obj.origin), ""));
		$("destination").value		= obj == null ? "" : unescapeHTML2(nvl(unescapeHTML2(obj.destination), ""));
		$("typeOfBody").value		= obj == null ? "" : obj.typeOfBodyCd;
		$("plateNo").value			= obj == null ? "" : unescapeHTML2(nvl(unescapeHTML2(obj.plateNo), "")); //added by steve 05.10.2013
		$("modelYear").value		= obj == null ? "" : nvl(obj.modelYear, "");
		$("carCompanyCd").value		= obj == null ? "" : obj.carCompanyCd;
		$("carCompany").value		= obj == null ? "" : unescapeHTML2(nvl(unescapeHTML2(obj.carCompany), ""));//obj.carCompanyCd;
		$("mvFileNo").value			= obj == null ? "" : unescapeHTML2(nvl(unescapeHTML2(obj.mvFileNo), "")); 
		$("noOfPass").value			= obj == null ? "" : nvl(obj.noOfPass, "");
		$("makeCd").value			= obj == null ? "" : obj.makeCd;
		$("make").value				= obj == null ? "" : unescapeHTML2(nvl(unescapeHTML2(obj.make), ""));
		$("basicColorCd").value		= obj == null ? "" : obj.basicColorCd;
		$("basicColor").value		= obj == null ? "" : unescapeHTML2(nvl(unescapeHTML2(obj.basicColor), ""));
		$("colorCd").value			= obj == null ? "" : obj.colorCd;
		$("color").value			= obj == null ? "" : unescapeHTML2(nvl(unescapeHTML2(obj.color), ""));
		$("seriesCd").value			= obj == null ? "" : obj.seriesCd;
		$("engineSeries").value		= obj == null ? "" : unescapeHTML2(nvl(unescapeHTML2(obj.engineSeries), ""));//obj.seriesCd;
		$("motorType").value		= obj == null ? "" : obj.motType;
		$("unladenWt").value		= obj == null ? "" : unescapeHTML2(nvl(unescapeHTML2(obj.unladenWt), "")); 
		$("towLimit").value			= obj == null ? "" : formatCurrency(obj.towing);
		$("serialNo").value			= obj == null ? "" : unescapeHTML2(nvl(unescapeHTML2(obj.serialNo), "")); //added by steven 07.06.2012: unescapeHTML2
		$("sublineType").value		= obj == null ? "" : obj.sublineTypeCd;
		//$("deductibleAmount").value	= obj == null ? "" : obj.deductibleAmount;
		$("cocType").value			= obj == null ? "" : unescapeHTML2(nvl(unescapeHTML2(obj.cocType), ""));
		$("cocSerialNo").value		= obj == null ? "" : obj.cocSerialNo;//unescapeHTML2(nvl(unescapeHTML2(obj.cocSerialNo), "")); removed unescapeHTML2 by j.diago 05.22.2014
		$("cocYy").value			= obj == null ? "" : obj.cocYy;
		$("repairLimit").value		= obj == null ? "" : formatCurrency(obj.repairLim);
		$("ctv").checked			= obj == null ? false : obj.ctvTag == "Y" ? true : false;		
		$("cocSerialSw").checked	= obj == null ? false : obj.cocSerialSw == "Y" ? true : false;
		
		if(objUWParList != null && objUWParList.parType != 'E') {
			$("regType").value 			= obj == null ? "" : unescapeHTML2(obj.regType);
			$("mvType").value 			= obj == null ? "" : unescapeHTML2(obj.mvType);
			$("mvTypeDesc").value		= obj == null ? "" : unescapeHTML2(obj.mvTypeDesc);
			$("mvPremType").value 		= obj == null ? "" : unescapeHTML2(obj.mvPremType);
			$("mvPremTypeDesc").value 	= obj == null ? "" : unescapeHTML2(obj.mvPremTypeDesc);
		}
		
		computeDeductibleAmtByItem(obj == null ? null : (objCurrItem != undefined ? objCurrItem.itemNo : obj.itemNo)); // andrew - 05.05.2011 - added condition for endt		
		
		if(objFormVariables.varVGenerateCOC == "Y"){
			$("cocSerialSw").checked ? $("cocSerialSw").disable() : $("cocSerialSw").enable();
			$("cocSerialSw").checked ? $("cocSerialNo").disable() : $("cocSerialNo").enable();		
		}
		
		obj != null ? null : setMCAddlFormDefault();	
		
		($$("div#itemInformationDiv [changed=changed]")).invoke("removeAttribute", "changed");
	}catch(e){
		showErrorMessage("supplyMCAdditional", e);
		//showMessageBox("supplyMotorcarAdditional : " + e.message);
	}	
}