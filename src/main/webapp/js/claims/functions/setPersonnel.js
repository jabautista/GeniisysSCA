/**
 * @author rey
 * @date 03-08-2012
 */
function setPersonnel(){
	try{
		new Ajax.Request(contextPath+"/GICLCasualtyDtlController",{
			asynchronous: false,
			parameters:{
				action: "setPersonnel",
				claimId: nvl(objCLMGlobal.claimId, 0),
				itemNo: nvl($F("txtItemNo").value,0),
				personnelNo: nvl($F("txtPerNo"),0),
				name:	nvl($F("txtPersonnel"),null),
				includeTag: "Y",
				lastUpdate: "",
				capacityCd: null,
				amountCovered: nvl($F("txtCoverage").value,null)
			},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					setClaimGlobals(obj);
				}else{
					showMessageBox(response.responseText, "E");
				}
			}
		});
		
	}
	catch(e){
		showErrorMessage("setPersonnel",e);
	}
}