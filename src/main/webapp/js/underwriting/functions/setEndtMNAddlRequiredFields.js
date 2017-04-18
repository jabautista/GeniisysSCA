/**
 * Sets the required field for endt marine cargo additional information form
 * @author andrew
 * @date 05.23.2011
 */
function setEndtMNAddlRequiredFields(recFlag){
	try {
		recFlag == "A" ? $("vesselCd").addClassName("required") : $("vesselCd").removeClassName("required");
		recFlag == "A" ? $("cargoClass").addClassName("required") : $("cargoClass").removeClassName("required");
		recFlag == "A" ? $("cargoClassDiv").addClassName("required") : $("cargoClassDiv").removeClassName("required");
		//recFlag == "A" ? $("cargoType").addClassName("required") : $("cargoType").removeClassName("required");	ROBERT 9.18.2012
		recFlag == "A" ? $("cargoTypeDesc").addClassName("required") : $("cargoTypeDesc").removeClassName("required");
		recFlag == "A" ? $("cargoTypeDiv").addClassName("required") : $("cargoTypeDiv").removeClassName("required");
		
	} catch (e){
		showErrorMessage("setEndtMNAddlRequiredFields", e);
	}
}