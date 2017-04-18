/*	Created by	: mark jm 01.05.2011
 * 	Description	: set the default values in item form
 */
function setDefaultItemForm(){
	try{
		var lineCd = getLineCd();
		
		$("itemNo").value 				= /*$F("globalParType")*/ objUWParList.parType == "E" ? "" : getNextItemNoFromObj(); // andrew - 04.20.2011 - added condtion for par //getNextItemNo("itemTable", "row", "label", 0);
		$("currency").value				= objFormParameters.paramDefaultCurrency;
		$("rate").readOnly 				= $("currency").value == 1 ? true : false;
		$("coverage").value				= nvl(objFormParameters.paramDfltCoverage, "");
		$("region").value				= objFormParameters.paramDefaultRegion;
		$("cgCtrlIncludeSw").checked	= false;
		
		getRates();	
		
		switch(lineCd){
			case "MC"	: setMCAddlFormDefault(); break;
			case "FI"	: setFIAddlFormDefault(); break;
			case "AC"	: setAHAddlFormDefault(); break;
			case "CA"	: setCAAddlFormDefault(); break;
			case "MN"	: setMNAddlFormDefault(); break;
		}
	}catch(e){
		showErrorMessage("setDefaultItemForm", e);
	}	
}