/*	Created by	: mark jm 04.14.2011
 * 	Description	: enable/disable quotation menus
 */
function refreshQuotationMenu(){
	try{
		var lineCd = getLineCdMarketing();
		(lineCd == "MN" /*|| lineCd == "MH"*/) ? (checkUserModule("GIIMM009") ? enableMenu("quoteCarrierInfo") : disableMenu("quoteCarrierInfo")) : disableMenu("quoteCarrierInfo"); // MH line commented by: Nica 06.19.2012 //added by steven 10.1.2013;checkUserModule.
		(lineCd == "SU") ? enableMenu("bondPolicyData") : disableMenu("bondPolicyData");
		//(lineCd == "EN") ? enableMenu("quoteEngineeringInfo") : disableMenu("quoteEngineeringInfo");
		(lineCd == "EN") ? (checkUserModule("GIIMM010") == true ? enableMenu("quoteEngineeringInfo") : disableMenu("quoteEngineeringInfo")) : disableMenu("quoteEngineeringInfo"); // added checking of user's access j.diago 07.03.2014 
	}catch(e){
		showErrorMessage("refreshQuotationMenu", e);
	}
}