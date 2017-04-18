/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	09.07.2011	mark jm			set par item form (tablegrid version)
 */
function setParItemFormTG(obj) {
	try {
		// mark jm 12.26.2011 remove changed attribute first
		($$("div#itemInformationDiv [changed=changed]")).invoke("removeAttribute", "changed");
		($$("div#additionalItemInformationDiv [changed=changed]")).invoke("removeAttribute", "changed");
		($$("div#personalAdditionalInformationInfo [changed=changed]")).invoke("removeAttribute", "changed");
		($$("div#marineHullAdditionalItemInformation [changed=changed]")).invoke("removeAttribute", "changed");
		
		var lineCd = getLineCd();
		
		objCurrItem = obj; // mark jm 07.20.2011 included in converting item modules to table grid

		setMainItemFormTG(obj);		
		
		var varIsEndtItem = isEndtItem(obj); // andrew - 02.25.2011 added this variable to determine if item is endt or not
		(obj == null || varIsEndtItem ? disableWItemButtons() : (obj.includeAddl != null) ? disableWItemButtons() : enableWItemButtons()); // andrew - 02.25.2011 - added condition for endt
		(obj == null || varIsEndtItem ? $("itemNo").removeAttribute("readonly") : $("itemNo").writeAttribute("readonly", "readonly")); // andrew - 02.25.2011 - added condition for endt
		
		var blnEnable = true;
		
		blnEnable = (obj == null ? true : (objGIPIWItemPeril.filter(function(per){	return nvl(per.recordStatus, 0) != -1 && per.itemNo == $F("itemNo");	}).length > 0 ? false : true));
		blnEnable ? $("currency").enable() : $("currency").disable();		
		blnEnable && $F("currency") != 1 ? $("rate").removeAttribute("readonly") : $("rate").setAttribute("readonly", "readonly");		
		
		var bool = (obj == null ? false : (obj.includeAddl != null || obj.includeAddl != undefined) ? ((obj.includeAddl) ? true : false) : true);
		
		if(lineCd == "MC"){			
			$("motorCoverage").value = obj == null ? "" : (obj.gipiWFireItm == undefined && objUWParList.parType == "E" ? obj.motorCoverage : (obj.gipiWVehicle == null ? "" : obj.gipiWVehicle.motorCoverage)); // andrew - 05.05.2011 added condition for endt;
			supplyMCAdditional(!bool ? null : obj.gipiWVehicle);
			if(objUWParList.parType == "E") setEndtMCAddlRequiredFields(obj == null ? "A" : obj.recFlag);
			supplyDefPerilAmtParam(lineCd, obj, (!bool ? null : obj.gipiWVehicle));	//added by Gzelle 11262014
		}else if(lineCd == "FI"){			
			supplyFIAdditional(!bool ? null : obj.gipiWFireItm);
			if(objUWParList.parType == "E") setEndtFIAddlRequiredFields(obj == null ? "A" : obj.recFlag);
			supplyDefPerilAmtParam(lineCd, obj, (!bool ? null : obj.gipiWFireItm));	//added by Gzelle 11262014
		}else if(lineCd == "MN"){			
			supplyMNAdditionalTG(!bool ? null : obj.gipiWCargo);
			if(objUWParList.parType == "E") setEndtMNAddlRequiredFields(obj == null ? "A" : obj.recFlag);
		}else if(lineCd == "CA"){			
			supplyCAAdditionalTG(!bool ? null : obj.gipiWCasualtyItem);			
		}else if(lineCd == "AC"){
			$("itmperlGroupedExists").value = (obj == null ? "" : nvl(obj.itmperlGroupedExists, ""));
			$("accidentProrateFlag").value	= (obj == null ? "2" : (nvl(obj.prorateFlag, "2")));			
			$("accidentDaysOfTravel").value = ($F("fromDate") != "" && $F("toDate") != "") ? computeNoOfDays($F("fromDate"),$F("toDate")) : "";			
			
			//if(blnEnable) {
			////if(objGIPIWItmperlGrouped.filter(function(o){	return nvl(o.recordStatus, 0) != -1 && o.itemNo == obj.itemNo; }).length > 0){
			//	$("hrefAccidentFromDate").setAttribute("onClick","showMessageBox('You cannot alter, insert or delete record in current field because changes will have an effect on the computation of TSI amount and Premium amount of the existing records in grouped item level', imgMessage.ERROR);");
			//	$("hrefAccidentToDate").setAttribute("onClick","showMessageBox('You cannot alter, insert or delete record in current field because changes will have an effect on the computation of TSI amount and Premium amount of the existing records in grouped item level', imgMessage.ERROR);");
			//} else {				
			//	$("hrefAccidentFromDate").setAttribute("onClick","scwShow($('fromDate'),this, null);");
			//	$("hrefAccidentToDate").setAttribute("onClick","scwShow($('toDate'), this, null)");
			//}
			
			$("accidentPackBenCd").value = obj == null ? "" : obj.packBenCd;
			
			$("fromDate").setAttribute("lastValidValue", $F("fromDate").blank() ? "" : $F("fromDate"));
			$("toDate").setAttribute("lastValidValue", $F("toDate").blank() ? "" : $F("toDate"));
			supplyACAdditionalTG(!bool ? null : obj.gipiWAccidentItem, obj);
			if(objUWParList.parType == "E") setEndtAHAddlRequiredFields(obj == null ? "A" : obj.recFlag);
		}else if(lineCd == "AV"){			
			supplyAVAdditional(!bool ? null : obj.gipiWAviationItem);
		}else if(lineCd == "MH") {
			supplyMHAdditional(!bool ? null : obj.gipiWItemVes);
		}
		
		//hideToolbarButtonInTG(tbgItemTable);
	} catch (e) {
		showErrorMessage("setParItemFormTG", e);
	}
}