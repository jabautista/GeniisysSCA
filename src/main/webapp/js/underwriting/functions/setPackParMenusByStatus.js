/**Enables or disables the Package PAR menus depending on Package PAR status
 * @author Veronica V. Raymundo
 * @param parStatus - Package PAR status
 * 
 */
function setPackParMenusByStatus(parStatus) {
	try {
		enableMenu("basic");
		parStatus > 2 && checkUserModule((objUWGlobal.parType  == "E" ? "GIPIS035A" : "GIPIS024A")) && objGIPIWPackLineSubline.length > 0 ? enableMenu("clauses") : disableMenu("clauses");  //added by steven 12.17.2013; (objUWGlobal.parType == "E" ? "GIPIS035A" : "GIPIS024A")
		//parStatus > 2 ? enableMenu("lineSublineCoverages"): disableMenu("lineSublineCoverages"); // andrew - 09.05.2011
		enableMenu("lineSublineCoverages");
		parStatus > 2 && objGIPIWPackLineSubline.length > 0 ? enableMenu("packagePolicyItems"): disableMenu("packagePolicyItems");
		parStatus > 4 ? enableMenu("bill") : disableMenu("bill");
		parStatus > 4 ? enableMenu("distribution") : disableMenu("distribution");
		//parStatus < 6 && checkUserModule("GIPIS085")? disableMenu("enterInvoiceCommission") : enableMenu("enterInvoiceCommission"); by bonok :: 08.30.2012
		//parStatus == 6 && checkUserModule("GIPIS055")? enableMenu("post") : disableMenu("post");
		// andrew - 09.02.2011 - modified handling of post menu
		if(objUWGlobal.parType == "E"){
			((parStatus > 2 && parStatus < 5) || parStatus == 6) && checkUserModule("GIPIS055")  && objGIPIWPackLineSubline.length > 0 ? enableMenu("post") : disableMenu("post");
		} else {
			parStatus == 6 && checkUserModule("GIPIS055") && objGIPIWPackLineSubline.length > 0 ? enableMenu("post") : disableMenu("post");
		}
		if(objUWGlobal.parType == "P"){ // by bonok start :: 08.30.2012
			if(objUWGlobal.issCd != "RI"){	// temp christian 03/08/2013
				objUWGlobal.enablePackPost == 'Y'? enableMenu("post") : disableMenu("post"); // by bonok :: 08.30.2012
			}
		}else{
			if(parStatus > 4){
				objUWGlobal.enablePackPost == 'Y' ? enableMenu("post") : disableMenu("post");
			}else if(parStatus < 5){
				enableMenu("post");
			}
		} // by bonok end :: 08.30.2012
		parStatus > 5 && objUWGlobal.issCd != "RI"? enableMenu("enterInvoiceCommission") : disableMenu("enterInvoiceCommission"); // by bonok :: 08.30.2012 //added objUWGlobal.issCd != "RI" christian 03/08/2013
		enableMenu("print");
	} catch (e){
		showErrorMessage("setPackParMenusByStatus", e);
	}
}