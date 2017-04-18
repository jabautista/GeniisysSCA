/**
 * Sets the required field for endt marine hull additional information form
 * @author andrew
 * @date 05.27.2011
 */
function setEndtMHAddlRequiredFields(recFlag){
	try {
		recFlag == "A" ? $("vesselCd").addClassName("required") : $("vesselCd").removeClassName("required");
		recFlag == "A" ? $("cargoClass").addClassName("required") : $("cargoClass").removeClassName("required");
		recFlag == "A" ? $("cargoClassDiv").addClassName("required") : $("cargoClassDiv").removeClassName("required");
		recFlag == "A" ? $("cargoType").addClassName("required") : $("cargoType").removeClassName("required");		
	} catch (e){
		showErrorMessage("setEndtMNAddlRequiredFields", e);
	}
}