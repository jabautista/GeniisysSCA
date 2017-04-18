function supplyQuoteMCAdditional(obj){
	try{
		$("assignee").value			= obj == null ? "" : unescapeHTML2(nvl(obj.assignee, ""));
		$("acquiredFrom").value		= obj == null ? "" : unescapeHTML2(nvl(obj.acquiredFrom, ""));
		$("motorNo").value			= obj == null ? "" : unescapeHTML2(nvl(obj.motorNo, ""));
		$("origin").value			= obj == null ? "" : unescapeHTML2(nvl(obj.origin, ""));
		$("destination").value		= obj == null ? "" : unescapeHTML2(nvl(obj.destination, ""));
		$("typeOfBody").value		= obj == null ? "" : obj.typeOfBodyCd;
		$("plateNo").value			= obj == null ? "" : obj.plateNo;
		$("modelYear").value		= obj == null ? "" : obj.modelYear;
		$("carCompanyCd").value		= obj == null ? "" : obj.carCompanyCd;
		$("carCompany").value		= obj == null ? "" : unescapeHTML2(obj.carCompany);//obj.carCompanyCd;
		$("mvFileNo").value			= obj == null ? "" : obj.mvFileNo;
		$("noOfPass").value			= obj == null ? "" : obj.noOfPass;
		$("makeCd").value			= obj == null ? "" : obj.makeCd;
		$("make").value				= obj == null ? "" : unescapeHTML2(obj.make);
		$("basicColorCd").value		= obj == null ? "" : obj.basicColorCd;
		$("basicColor").value		= obj == null ? "" : unescapeHTML2(obj.basicColorCd);
		$("colorCd").value			= obj == null ? "" : obj.colorCd;
		$("color").value			= obj == null ? "" : unescapeHTML2(obj.color);
		$("seriesCd").value			= obj == null ? "" : obj.seriesCd;
		$("engineSeries").value		= obj == null ? "" : unescapeHTML2(obj.engineSeries);//obj.seriesCd;
		$("motorType").value		= obj == null ? "" : obj.motType;
		$("unladenWt").value		= obj == null ? "" : obj.unladenWt;
		$("towLimit").value			= obj == null ? "" : formatCurrency(obj.towing);
		$("serialNo").value			= obj == null ? "" : obj.serialNo;
		$("sublineType").value		= obj == null ? "" : obj.sublineTypeCd;
		//$("deductibleAmount").value	= obj == null ? "" : obj.deductibleAmount;
		$("cocType").value			= obj == null ? "" : obj.cocType;
		$("cocSerialNo").value		= obj == null ? "" : obj.cocSerialNo;
		$("cocYy").value			= obj == null ? "" : obj.cocYy;
		$("repairLimit").value		= obj == null ? "" : formatCurrency(obj.repairLim);
		$("ctv").checked			= obj == null ? false : obj.ctvTag == "Y" ? true : false;		
		//$("cocSerialSw").checked	= obj == null ? false : obj.cocSerialSw == "Y" ? true : false;
		
		//computeDeductibleAmtByItem(obj == null ? null : objCurrItem.itemNo);		
		
		//$("cocSerialSw").checked ? $("cocSerialSw").disable() : $("cocSerialSw").enable();
		//$("cocSerialSw").checked ? $("cocSerialNo").disable() : $("cocSerialNo").enable();
				
		//$("carCompany").value 	= "";
		//$("makeCd").value 		= "";
		//$("engineSeries").value = "";
		
/*		function innerFunc(){			
			(($("colorCd").childElements()).invoke("show")).invoke("removeAttribute", "disabled");				
			(($$("select#colorCd option:not([basicColorCd='" + $F("basicColor") + "'])")).invoke("hide")).invoke("setAttribute", "disabled", "disabled");

			$("colorCd").options[0].show();
			$("colorCd").options[0].disabled = false;			
		}*/
		
/*		if(obj == null){
			setMCAddlFormDefault();
			//fireEvent($("basicColor"), "change");
			$("colorCd").hide();
			$("colorCd").value = "";
			if($F("basicColor").empty()){
				$("colorCd").value = "";
				(($("colorCd").childElements()).invoke("show")).invoke("removeAttribute", "disabled");
			}else{			
				innerFunc();				
			}
			$("colorCd").show();
			//$("carCompany").selectedIndex = 0;
			//fireEvent($("carCompany"), "change");					
		}else{
			if(obj.basicColorCd != null){				
				//fireEvent($("basicColor"), "change");
				innerFunc();				
			}
			
			if(obj.seriesCd != null && !(obj.seriesCd.toString().blank())){				
				setSelectOptionsValue("engineSeries", "combinationVal", obj.carCompanyCd + "_" + obj.makeCd + "_" + obj.seriesCd);
				fireEvent($("engineSeries"), "change");			
			}else{
				$("carCompany").value 	= obj.carCompanyCd;				
				fireEvent($("carCompany"), "change");
				
				if(obj.makeCd != null){
					setSelectOptionsValue("makeCd", "combinationVal", obj.carCompanyCd + "_" + obj.makeCd);
					fireEvent($("makeCd"), "change");
				}
			}
		}*/
		//($$("div#itemInformationDiv [changed=changed]")).invoke("removeAttribute", "changed");
	}catch(e){
		showErrorMessage("supplyQuoteMCAdditional", e);
	}	
}