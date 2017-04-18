/*	Created by	: mark jm 03.01.2011
 * 	Description	: set default values for casualty additional form
 */
function setCAAddlFormDefault(){
	var pflSublineCd = objFormParameters.paramSublineCd.split(",");
	
	try{		
	if(objFormParameters.paramOra2010Sw != "Y"){
		$("btnUpdPropertyFloater").hide();
		$("btnMaintainLocation").hide();
		$("rowLocationCd").hide();
	}else{
		for(var i = 0; i < pflSublineCd.length; i++){
			var pflSublineCd2 = pflSublineCd[i];
			if(objFormParameters.paramMenuLineCd == 'CA' && $F("globalSublineCd") == ltrim(pflSublineCd2)){
				$("rowLocationCd").show();
				$("locationCd").addClassName("required");
				break;
			}else{
				$("btnUpdPropertyFloater").hide();
				$("btnMaintainLocation").hide();
				$("rowLocationCd").hide();
				$("locationCd").removeClassName("required");
			}
		}
	}
	}catch(e){
		showErrorMessage("setCAAddlFormDefault", e);
	}
}