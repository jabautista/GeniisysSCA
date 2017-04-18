/**
 * Sets the required field for endt motorcar additional information form
 * @author andrew
 * @date 05.19.2011
 */
function setEndtMCAddlRequiredFields(recFlag){
	try {
		//recFlag == "A" ? $("motorNo").addClassName("required") : $("motorNo").removeClassName("required"); - removed by Apollo Cruz 01.07.2015 - gipi_wvehicle.motor_no is not nullable
		(recFlag == "A" && objFormVariables.varVMcCompanySw == "Y") ? $("carCompany").addClassName("required") : $("carCompany").removeClassName("required"); //modified by pol cruz 01.12.2015 - requiring car copmany must be based on giisp.v('REQUIRE_MC_COMPANY') [Gzelle 05222015 SR3404 BP-002-00002 Endorsement of MOTORCAR Policy (BR-038-B)] 
		if($("carCompany").hasClassName("required")){
			($("carCompany").up("div", 0)).addClassName("required");
		}else {
			($("carCompany").up("div", 0)).removeClassName("required");
		}
	} catch (e){
		showErrorMessage("setEndtMCAddlRequiredFields", e);
	}
}