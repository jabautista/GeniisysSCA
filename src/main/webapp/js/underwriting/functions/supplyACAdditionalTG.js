/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	09.28.2011	mark jm			Fill-up fields with values in accident
 */
function supplyACAdditionalTG(obj, gipiWItmObj) {
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
		$("pHeight").value 			= obj == null ? "" : unescapeHTML2(obj.height);
		//$("pWeight").value			= obj == null ? "" : obj.weight;
		$("pWeight").value			= obj == null ? "" : unescapeHTML2(obj.weight); //replaced by: Mark C. 04132015 SR4302
		$("pCivilStatus").value		= obj == null ? "" : obj.civilStatus;
		$("groupPrintSw").value		= obj == null ? "" : obj.groupPrintSw;
		$("acClassCd").value		= obj == null ? "" : obj.acClassCd;
		$("levelCd").value			= obj == null ? "" : obj.levelCd;
		$("parentLevelCd").value	= obj == null ? "" : obj.patentLevelCd;
		
		$("accidentPaytTerms").value		= gipiWItmObj == null ? "" : gipiWItmObj.paytTerms;	
		$("itemWitmperlExist").value 		= obj == null ? "" : obj.itemWitmperlExist;
		$("itemWgroupedItemsExist").value 	= obj == null ? "" : obj.itemWgroupedItemsExist;
		
		$("isSaved").value	= isSaved;
		
		$("accidentShortRatePercent").value = gipiWItmObj==null ? "" : formatTo9DecimalNoParseFloat(nvl(gipiWItmObj.shortRtPercent, ""));
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
			
			//$("personalAdditionalInfoDetail").hide();
			//$("personalAdditionalInformationInfo").hide();
			//$("showPersonalAdditionalInfo").update("Show");
			//$("personalAdditionalInfoDetail").hide();
			
			$("monthlySalary").removeAttribute("readonly");
			$("salaryGrade").removeAttribute("readonly");			
		} else {
			if(obj.noOfPersons != null) {
				if (parseInt((obj.noOfPersons.toString()).replace(/,/g, "")) > 1 && !(isNaN(obj.noOfPersons.toString()))){
					disableButton("btnPersonalAddtlInfo");
					enableButton("btnGroupedItems");
					////$("personalAdditionalInfoDetail").show();
					//$("personalAdditionalInformationInfo").hide();
					//$("showPersonalAdditionalInfo").update("Show");
					////$("personalAdditionalInfoDetail").show();
					$("monthlySalary").setAttribute("readonly", "readonly");			
					$("salaryGrade").setAttribute("readonly", "readonly");
				} else {
					disableButton("btnGroupedItems");
					enableButton("btnPersonalAddtlInfo");
					$("monthlySalary").removeAttribute("readonly");
					$("salaryGrade").removeAttribute("readonly");
					//$("personalAdditionalInfoDetail").hide();
					//$("personalAdditionalInformationInfo").hide();
					//$("showPersonalAdditionalInfo").update("Show");
					//$("personalAdditionalInfoDetail").hide();
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
		
		//showACProrateSpan();
		
		//if ($F("itemWitmperlGroupedExist") == "Y"){
		if(objGIPIWItmperlGrouped.filter(function(o){	return nvl(o.recordStatus, 0) != -1 && o.itemNo == $F("itemNo"); }).length > 0){
			var dtPickerAtt = "showMessageBox('You cannot alter, insert or delete record in current field because changes will have an effect on the computation of TSI amount" +
								" and Premium amount of the existing records in grouped item level', imgMessage.ERROR);";
			$("accidentProrateFlag").disable();
			$("accidentShortRatePercent").disable();
			$("accidentCompSw").disable();
			$("accidentNoOfDays").disable();
			$("fromDate").disable();
			$("toDate").disable();
			$("hrefAccidentFromDate").setAttribute("onClick", dtPickerAtt);			
			$("hrefAccidentToDate").setAttribute("onClick", dtPickerAtt);
			$("currency").disable();
		/*
		} else if ($F("itemWitmperlExist") == "Y" && $F("itmperlGroupedExists") != "Y")	{
			$("accidentPackBenCd").disable();  
			//$("accidentShortRatePercent").disable();
			$("currency").enable();			
		} else{
			$("fromDate").enable();
			$("toDate").enable();
			$("hrefAccidentFromDate").setAttribute("onClick","scwShow($('fromDate'),this, null);");			
			$("hrefAccidentToDate").setAttribute("onClick","scwShow($('toDate'),this, null);");
			$("accidentPackBenCd").enable();
			$("currency").enable();	
		*/	
		}
		
		showACProrateSpan();
		($$("div#itemInformationDiv [changed=changed]")).invoke("removeAttribute", "changed");
	} catch(e) {
		showErrorMessage("supplyACAdditionalTG", e);		
	}
}