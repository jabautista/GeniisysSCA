/**
 * @param obj
 * @return
 */
function supplyQuoteENAdditional(obj) {
	try {
		if($("inputTitle") != undefined) $("inputTitle").value = obj == null ? "" : unescapeHTML2(nvl(obj.contractProjBussTitle));
		if($("inputLocation") != undefined) $("inputLocation").value = obj == null ? "" : unescapeHTML2(nvl(obj.siteLocation, ""));
		if($("constructFrom") != undefined) { 
			$("constructFrom").value = obj == null ? "" : obj.constructStartDate == null ? "" : dateFormat(obj.constructStartDate, "mm-dd-yyyy");
		}
		if($("constructTo") != undefined) { 
			$("constructTo").value = obj == null ? "" : obj.constructEndDate == null ? "" : dateFormat(obj.constructEndDate, "mm-dd-yyyy");
		}
		if($("mainFrom") != undefined) { 
			$("mainFrom").value = obj == null ? "" : obj.maintainStartDate == null ? "" : dateFormat(obj.maintainStartDate, "mm-dd-yyyy");
		}
		if($("mainTo") != undefined) { 
			$("mainTo").value = obj == null ? "" : obj.maintainEndDate == null ? "" : dateFormat(obj.maintainEndDate, "mm-dd-yyyy");
		}
	} catch(e){
		showErrorMessage("supplyQuoteENAdditional", e);
	}
}