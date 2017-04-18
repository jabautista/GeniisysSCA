/*	Created by	: mark jm 02.04.2011
 * 	Description : set default values for motorcar additional form
 */
function setMCAddlFormDefault(){
	try{
		$("cocSerialSw").checked	= false;
		$("cocType").value			= (objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $F("globalSublineCd")) == objFormVariables.varSublineLto ? objFormVariables.varCocLto : objFormVariables.varCocNlto;
		$("cocYy").value 			= (objUWGlobal.packParId != null ? objCurrPackPar.parYy : $F("globalParYy"));
		$("plateNo").value			= nvl(objFormParameters.paramDefaultPlateNo, "");
		$("towLimit").value			= nvl(formatCurrency(objFormParameters.paramDefaultTowing), "");
		
		(objFormVariables.varVGenerateCOC == "Y") ?	$("cocSerialSw").enable() : $("cocSerialSw").disable();
		/*
		if(objFormVariables.varVGenerateCOC == "Y"){
			$("cocSerialSw").enable();
			$("cocSerialSw").checked = true;
		}else{
			$("cocSerialSw").disable();
			$("cocSerialSw").checked = false;
		}
		*/
		//(objFormParameters.paramUserAccess == "Y") ? $("cocSerialSw").enable() : $("cocSerialSw").disable();
		
		$("carCompany").addClassName(objFormVariables.varVMcCompanySw == "Y" ? "required" : "");
		
		if($("carCompany").hasClassName("required")){
			($("carCompany").up("div", 0)).addClassName("required");
		}
		
		if(checkUserModule("GIPIS211")){
			enableButton("btnMotorCarIssuance");
		}else{
			disableButton("btnMotorCarIssuance");
		}
	}catch(e){
		showErrorMessage("setMCAddlFormDefault", e);
	}	
}