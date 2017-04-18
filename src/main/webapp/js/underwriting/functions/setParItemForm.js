/*
 * Created By	: mark jm
 * Date			: 12.13.2010
 * Description	: set item form display
 * Parameter	: obj - the object/record that contains the details to be displayed
 */
function setParItemForm(obj) {
	try {
		var lineCd = getLineCd();
        
		objCurrItem = obj; // mark jm 07.20.2011 included in converting item modules to table grid

		setMainItemForm(obj);
		
		if(lineCd == "AC") {
			$("itmperlGroupedExists").value = (obj == null ? "" : nvl(obj.itmperlGroupedExists, ""));
			$("accidentProrateFlag").value	= (obj == null ? "2" : (nvl(obj.prorateFlag, "2")));
			$("deleteGroupedItemsInItem").value = (obj == null ? "N" : obj.gipiWAccidentItem == null ? "N" : nvl(obj.gipiWAccidentItem.changeNOP, "N")); //modified by jdiago 08.06.2014 : added checking of obj.gipiWAccidentItem
			if($F("fromDate") != "" && $F("toDate") != "") {
				$("accidentDaysOfTravel").value = computeNoOfDays($F("fromDate"),$F("toDate"));
			} else {
				$("accidentDaysOfTravel").value = "";
			}
		}	
		
		var varIsEndtItem = isEndtItem(obj); // andrew - 02.25.2011 added this variable to determine if item is endt or not
		(obj == null || varIsEndtItem ? disableWItemButtons() : (obj.includeAddl != null) ? disableWItemButtons() : enableWItemButtons()); // andrew - 02.25.2011 - added condition for endt
		(obj == null || varIsEndtItem ? $("itemNo").removeAttribute("readonly") : $("itemNo").writeAttribute("readonly", "readonly")); // andrew - 02.25.2011 - added condition for endt
		
		var blnEnable = true;
		
		blnEnable = (obj == null ? true : ($$('div#parItemPerilTable div[item="' + obj.itemNo + '"]').size() > 0 ? false : true));
		(objUWParList.parType == "E" && $F("recFlag") == "C") ? $("currency").disable() : 
			(blnEnable ?  $("currency").enable() : $("currency").disable());
		(objUWParList.parType == "E" && $F("recFlag") == "C") ? $("rate").setAttribute("readonly", "readonly") : 
			(blnEnable && $F("currency") != 1 ? $("rate").removeAttribute("readonly") : $("rate").setAttribute("readonly", "readonly"));
		//blnEnable ? $("rate").removeAttribute("readonly") : $("rate").setAttribute("readonly", "readonly");
		
		if(lineCd == "AH") {
			if(blnEnable) {
				//$("fromDate").enable();
				//$("toDate").enable();
				$("hrefAccidentFromDate").setAttribute("onClick","showMessageBox('You cannot alter, insert or delete record in current field because changes will have an effect on the computation of TSI amount and Premium amount of the existing records in grouped item level', imgMessage.ERROR);");
				$("hrefAccidentToDate").setAttribute("onClick","showMessageBox('You cannot alter, insert or delete record in current field because changes will have an effect on the computation of TSI amount and Premium amount of the existing records in grouped item level', imgMessage.ERROR);");
			} else {
				//$("fromDate").disable();
				//$("toDate").disable();
				$("hrefAccidentFromDate").setAttribute("onClick","scwShow($('fromDate'),this, null);");
				$("hrefAccidentToDate").setAttribute("onClick","scwShow($('toDate'), this, null)");
			}
		}

		var bool = (obj == null ? false : (obj.includeAddl != null || obj.includeAddl != undefined) ? ((obj.includeAddl) ? true : false) : true);
		
		if(lineCd == "MC"){		
			$("motorCoverage").value = obj == null ? "" : (obj.gipiWFireItm == undefined && /*$F("globalParType")*/ objUWParList.parType == "E" ? obj.motorCoverage : (obj.gipiWVehicle == null ? "" : obj.gipiWVehicle.motorCoverage)); // andrew - 05.05.2011 added condition for endt;
			supplyMCAdditional(!bool ? null : obj.gipiWVehicle);
			if(/*$F("globalParType")*/ objUWParList.parType == "E") setEndtMCAddlRequiredFields(obj == null ? "A" : obj.recFlag);
		}else if(lineCd == "FI"){		
			supplyFIAdditional(!bool ? null : obj.gipiWFireItm);
			//if(/*$F("globalParType")*/ objUWParList.parType == "E") setEndtFIAddlRequiredFields(obj == null ? "A" : obj.recFlag); -removed by Apollo Cruz 01.06.2015
		}else if(lineCd == "MN"){	
			supplyMNAdditional(!bool ? null : obj.gipiWCargo);
			if(/*$F("globalParType")*/ objUWParList.parType == "E") setEndtMNAddlRequiredFields(obj == null ? "A" : obj.recFlag);
		}else if(lineCd == "CA"){			
			supplyCAAdditional(!bool ? null : obj.gipiWCasualtyItem);			
		}else if(lineCd == "AC"){
			supplyAHAdditional(!bool ? null : obj.gipiWAccidentItem, obj);
			if(/*$F("globalParType")*/ objUWParList.parType == "E") setEndtAHAddlRequiredFields(obj == null ? "A" : obj.recFlag);
		}else if(lineCd == "AV"){
			supplyAVAdditional(!bool ? null : obj.gipiWAviationItem);
		}else if(lineCd == "MH") {
			supplyMHAdditional(!bool ? null : obj.gipiWItemVes);
		}else{
			
		}
	} catch (e) {
		showErrorMessage("setParItemForm", e);
	}
}