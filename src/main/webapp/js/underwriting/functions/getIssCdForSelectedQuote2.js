/**
 * Another version of getIssCdForSelectedQuote, using selected row from lov
 * @author andrew
 * @date 05.06.2011
 * @param process - 
 * @param row - selected quotation from lov
 */
function getIssCdForSelectedQuote2(process, row){
	try {
		$("vlineCd").value = $("linecd").value;
		var iss 	    = $("isscd");
		var quoteIssCd 	= row.issCd;
		hideAllIssourceOptions();
		moderateIssourceOptionsByLine();
		for(var y=0; y<iss.length; y++){
			if(iss[y].value == quoteIssCd){
				if(checkLineCdIssCdMatch($F("vlineCd"), iss[y].value)){
					$("isscd").selectedIndex = y;
				}else{
					setIssCdToDefault();
				}
			} else {
				setIssCdToDefault();
			}
		}
		if (process == "save"){
			showConfirmBox3("Create PAR from Quote ", "This option will automatically create a PAR record with all the information entered in the quotation. Do you want to continue?", "Yes", "Cancel", function(){turnQuoteToPAR2(row);}, "");
		} else if (process == "show"){}
	} catch(e){
		showErrorMessage("getIssCdForSelectedQuote2", e);
	}
}