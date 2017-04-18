/*	Created by	: d.alcantara 02.10.2011
 * 	Description	: Fill-up fields with values in Accident
 */
function supplyAHAdditional(obj, gipiWItmObj) {
	try {
		var isSaved = gipiWItmObj == null ? "0" : nvl(gipiWItmObj.isSaved, "0");
		 
		$("noOfPerson").value		= obj == null ? "" : obj.noOfPersons;
		$("positionCd").value 		= obj == null ? "" : obj.positionCd;
		$("destination").value		= obj == null ? "" : unescapeHTML2(nvl(obj.destination, ""));
		$("monthlySalary").value    = obj == null ? "" : formatCurrency(obj.monthlySalary);
		//$("salaryGrade").value		= obj == null ? "" : obj.salaryGrade;
		$("salaryGrade").value		= obj == null ? "" : unescapeHTML2(nvl(obj.salaryGrade,"")); //replaced by: Mark C. 04132015 SR4302
		
		$("pDateOfBirth").value		= obj == null ? "" : (obj.dateOfBirth == null ? "" : dateFormat(obj.dateOfBirth, "mm-dd-yyyy"));
		$("pSex").value				= obj == null ? "" : obj.sex;
		$("pAge").value				= obj == null ? "" : obj.age;
		$("pHeight").value 			= obj == null ? "" : unescapeHTML2(nvl(obj.height,"")); //added by steven 10/10/2012
		$("pWeight").value			= obj == null ? "" : unescapeHTML2(nvl(obj.weight,"")); //added by steven 10/10/2012
		$("pCivilStatus").value		= obj == null ? "" : obj.civilStatus;
		$("groupPrintSw").value		= obj == null ? "" : obj.groupPrintSw;
		$("acClassCd").value		= obj == null ? "" : obj.acClassCd;
		$("levelCd").value			= obj == null ? "" : obj.levelCd;
		$("parentLevelCd").value	= obj == null ? "" : obj.patentLevelCd;
		
		$("accidentPaytTerms").value= gipiWItmObj == null ? "" : gipiWItmObj.paytTerms;
	
		$("itemWitmperlExist").value 		= obj == null ? "" : obj.itemWitmperlExist;
		$("itemWgroupedItemsExist").value 	= obj == null ? "" : obj.itemWgroupedItemsExist;
		
		$("isSaved").value			= isSaved;
		
		$("accidentShortRatePercent").value = gipiWItmObj==null ? "" : gipiWItmObj.shortRtPercent;
		$("accidentCompSw").value	= gipiWItmObj==null ? "" : gipiWItmObj.compSw;
		
		if(gipiWItmObj != null && (gipiWItmObj.prorateFlag == "" || gipiWItmObj.prorateFlag == null || gipiWItmObj.prorateFlag == "2")) {
			$("shortRateSelectedAccident").hide();
			$("prorateSelectedAccident").hide();
			$("accidentNoOfDays").value = "";
			$("accidentShortRatePercent").value = "";
			$("accidentCompSw").selectedIndex = 2;
		} 
		if(obj == null) {
			setAHAddlFormDefault();
			
			disableButton("btnGroupedItems");
			enableButton("btnPersonalAddtlInfo");	
			
			$("personalAdditionalInfoDetail").hide();
			$("personalAdditionalInformationInfo").hide();
			$("showPersonalAdditionalInfo").update("Show");
			$("personalAdditionalInfoDetail").hide();
			
			$("monthlySalary").disable();
			$("salaryGrade").disable();
			$("monthlySalary").clear();
			$("salaryGrade").clear();
			
		} else {
			if(obj.noOfPersons != null) {
				function validateNoOfPersons(){	//added by Gzelle 10072014
					var result = "";
					new Ajax.Request(contextPath + "/GIPIWGroupedItemsController?action=validateNoOfPersons",{
						parameters : {
							lineCd    : objUWGlobal.packParId != null ? objCurrPackPar.lineCd : $F("globalLineCd"),
							sublineCd : objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $F("globalSublineCd"),
							issCd 	  : $F("globalIssCd"),
							issueYy   : $F("globalIssueYy"),
							polSeqNo  : $F("globalPolSeqNo"),
							renewNo	  : $F("globalRenewNo"),
							itemNo 	  : $F("itemNo")
						},
						asynchronous : false,
						evalScripts : true,
						onComplete : function(response){
							if(checkErrorOnResponse(response)){
								result =  response.responseText;
							}
						}
					});
					return result;
				}
				if (parseInt((obj.noOfPersons.toString()).replace(/,/g, "")) > 1 && !(isNaN(obj.noOfPersons.toString()))){
					disableButton("btnPersonalAddtlInfo");
					enableButton("btnGroupedItems");
					//$("personalAdditionalInfoDetail").show();
					$("personalAdditionalInformationInfo").hide();
					$("showPersonalAdditionalInfo").update("Show");
					//$("personalAdditionalInfoDetail").show();
					$("monthlySalary").enable();
					$("salaryGrade").enable();
				} else if (parseInt((obj.noOfPersons.toString()).replace(/,/g, "")) == 1) {
					if (validateNoOfPersons() > 1) {	//added by Gzelle 10072014
						enableButton("btnGroupedItems");
					}else {
						disableButton("btnGroupedItems");
					}
					enableButton("btnPersonalAddtlInfo");
					$("personalAdditionalInfoDetail").hide();
					$("personalAdditionalInformationInfo").hide();
					$("showPersonalAdditionalInfo").update("Show");
					$("personalAdditionalInfoDetail").hide();
				}
			} 
		}
		
		if (gipiWItmObj != null) {
			if (gipiWItmObj.prorateFlag == "2" && gipiWItmObj.fromDate != null
					&& gipiWItmObj.toDate != null){
				var fDateArray = gipiWItmObj.fromDate.split("-");
				var fmonth = fDateArray[0];
				var fdate = fDateArray[1];
				var fyear = fDateArray[2];
				var tDateArray = gipiWItmObj.toDate.split("-");
				var tmonth = tDateArray[0];
				var tdate = tDateArray[1];
				var tyear = tDateArray[2];
				
				if ((fmonth+"-"+fdate+"-"+(parseInt(fyear)+1)) == (tmonth+"-"+tdate+"-"+tyear)){
					$("accidentProrateFlag").disable();
				}
			}
		}
		//if ($F("itemWitmperlGroupedExist") == "Y"){
		if ($F("itmperlGroupedExists") == "Y"){
			$("accidentProrateFlag").disable();
			$("accidentShortRatePercent").disable();
			$("accidentCompSw").disable();
			$("accidentNoOfDays").disable();
			$("fromDate").disable();
			$("hrefAccidentFromDate").setAttribute("onClick","showMessageBox('You cannot alter, insert or delete record in current field because changes will have an effect on the computation of TSI amount and Premium amount of the existing records in grouped item level', imgMessage.ERROR);");
			$("toDate").disable();
			$("hrefAccidentToDate").setAttribute("onClick","showMessageBox('You cannot alter, insert or delete record in current field because changes will have an effect on the computation of TSI amount and Premium amount of the existing records in grouped item level', imgMessage.ERROR);");
			$("currency").disable();
			$("rate").disable();
//		} else if ($F("itemWitmperlExist") == "Y" && $F("itemWitmperlGroupedExist") != "Y")	{
		} else if ($F("itemWitmperlExist") == "Y")	{
			if($F("itmperlGroupedExists") != "Y") $("accidentPackBenCd").disable();  
			//$("accidentShortRatePercent").disable();
			/*$("currency").enable();
			if ($("currency").value == "1"){
				$("rate").disable();
			}else{
				$("rate").enable();
			}*/  //edited by d.alcantara, 04-30-2012, to always disable currency when item has peril
			$("currency").disable();
			$("rate").disable();
		} else{
			$("fromDate").enable();
			$("hrefAccidentFromDate").setAttribute("onClick","scwShow($('fromDate'),this, null);");
			$("toDate").enable();
			$("hrefAccidentToDate").setAttribute("onClick","scwShow($('toDate'),this, null);");
			$("accidentPackBenCd").enable();
			if(objUWParList.parType == "E" && $F("recFlag") == "C") {
				$("currency").disable();
			} else {
				$("currency").enable();
				if ($("currency").value == "1"){
					$("rate").disable();
				}else{
					$("rate").enable();
				}
			}
		}
		showACProrateSpan();
		($$("div#itemInformationDiv [changed=changed]")).invoke("removeAttribute", "changed");
	} catch(e) {
		showErrorMessage("supplyAHAdditional", e);
		//showMessageBox("supply Accident Additional : " + e.message);
	}
}