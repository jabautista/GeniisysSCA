/*
 * Created By	: Andrew
 * Date			: September 29, 2010
 * Description	: Enables or disables the menus depending on par status
 * Parameters	: parStatus - status of par
 */
function setParMenusByStatus(parStatus) {
	try {
		var lineCd = getLineCd();
		var itemInfoModuleId = getItemModuleId($F("globalParType"), objUWGlobal.lineCd, objUWGlobal.menuLineCd);
		parStatus > 2 && checkUserModule(itemInfoModuleId) ? enableMenu("itemInfo") : disableMenu("itemInfo");
		parStatus > 2 && checkUserModule("GIPIS024") ? enableMenu("clauses") : disableMenu("clauses");
		//parStatus > 4 ? (($F("globalOpFlag") == "Y" && $F("globalInvoiceTag") != "1") ? disableMenu("bill") : enableMenu("bill")) : disableMenu("bill");
		//parStatus > 4 ? (($F("globalOpFlag") == "Y" && $F("globalInvoiceTag") != "1") ? disableMenu("distribution") : enableMenu("distribution")) : disableMenu("distribution");
		//parStatus < 6 && checkUserModule("GIPIS085") ? disableMenu("enterInvoiceCommission") : enableMenu("enterInvoiceCommission");
		parStatus >= 4 ? enableMenu("bill") : disableMenu("bill");
		
		//parStatus > 4 ? enableMenu("distribution") : disableMenu("distribution"); comment out by bonok :: 08.29.2012
		/*if(($F("globalOpFlag") == "Y" && $F("globalInvoiceTag") == "1")) {
			enableMenu("bill");
			enableMenu("distribution");
		} else if(($F("globalOpFlag") == "Y" && $F("globalInvoiceTag") != "1")){
			disableMenu("bill");
			disableMenu("distribution");
		}*/ // moved by: Nica 05.12.2012
		
		if(lineCd == "SU"){
			if(parStatus > 4 && objUWGlobal.enableDist == 1){ //&& $F("globalIssCd") != $F("globalIssCdRI" && $F("globalIssCd") != 'RB')){
				if($F("globalIssCd") != $F("globalIssCdRI")){
					enableMenu("enterInvoiceCommission");
				}
				enableMenu("distribution");
			}else{
				disableMenu("enterInvoiceCommission");
				disableMenu("distribution");
			}
		}
		
		//added additional condition because SU line has different module id for bill/invoice commission in par and endt. -- irwin 11.09.11
		/*if(lineCd == "SU"){ bonok 8.30.2012
			(parStatus > 5 || $F("globalInvoiceTag") == "1") && checkUserModule("GIPIS160") ? enableMenu("enterInvoiceCommission") : disableMenu("enterInvoiceCommission");
		}else{
			(parStatus > 5 || $F("globalInvoiceTag") == "1") && checkUserModule("GIPIS085") ? enableMenu("enterInvoiceCommission") : disableMenu("enterInvoiceCommission");
		}*/

		/* Previous code - irwin 
		parStatus > 5 || (lineCd == "SU" && parStatus == 5) && checkUserModule("GIPIS085") ? enableMenu("enterInvoiceCommission") : disableMenu("enterInvoiceCommission");
		*/ 
		disableMenu("lineSublineCoverages");
		if($F("globalParType") == "E"){
			if(lineCd == "SU"){ // condition for line SU added by Nica 08.23.2012 
				((parStatus > 2 && parStatus < 10)) && checkUserModule("GIPIS055")? enableMenu("post") : disableMenu("post");
				if(parStatus > 5 && objUWGlobal.enableDist == 1){ //marco - 10.09.2013 - added enableDist condition
					enableMenu("distribution");
					enableMenu("post");
				}
			}else{
				((parStatus > 2 && parStatus < 5) || parStatus == 6) && checkUserModule("GIPIS055")? enableMenu("post") : disableMenu("post");
			}
		} else {
			//parStatus == 6 && checkUserModule("GIPIS055")? enableMenu("post") : disableMenu("post");
			parStatus > 6 && checkUserModule("GIPIS055")? enableMenu("post") : disableMenu("post"); // by bonok :: 08.29.2012
		}
		if(lineCd == "SU"){
			
		}else{
			parStatus > 5 ? enableMenu("enterInvoiceCommission") : disableMenu("enterInvoiceCommission"); // by bonok :: 08.29.2012
			parStatus > 5 ? enableMenu("distribution") : disableMenu("distribution"); // by bonok :: 08.29.2012
		}
		
		if(($F("globalOpFlag") == "Y" && $F("globalInvoiceTag") == "1")) {
			enableMenu("bill");
			//enableMenu("distribution");
		} else if(($F("globalOpFlag") == "Y" && $F("globalInvoiceTag") != "1")){
			disableMenu("bill");
			disableMenu("distribution");
		} // moved here by: Nica 09.12.2012
		
	//	parStatus == 6 ? enableMenu("print") : disableMenu("print");
	} catch (e){
		showErrorMessage("setParMenusByStatus", e);
	}
}