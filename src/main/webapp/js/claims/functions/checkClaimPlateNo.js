/**
 * checkClaimPlateNo
 * Description: Checks if the plate no. is existing in the other claims 
 * @param plateNo
 * @param dspLossDate
 * @param element
 * @author Irwin Tabisora 9.19.11
 * */
function checkClaimPlateNo(plateNo,dspLossDate,element){
	try{
		dspLossDate = dateFormat(Date.parse(objCLMGlobal.strDspLossDate), "mm-dd-yyyy");
		new Ajax.Request(contextPath + "/GICLClaimsController?action=checkClaimPlateNo&dspLossDate="+dspLossDate,{
			method: "GET",
			parameters: {
				plateNo: plateNo
			},
			asynchrous: true,
			evalScripts: true,
			onCreate : function() {
				showNotice("Checking plate no., please wait...");
			},
			onComplete: function (response){
				hideNotice("");
				var obj = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
				if(obj.result == "Y"){
					showWaitingMessageBox("Plate Number has an existing claim, Claim Number: "+obj.claimNo+" Loss Date: "+obj.dspLossDate, imgMessage.INFO,function(){
						if(element != null){
							$(element).focus();	
						}
						
					});
				}
			}
		}); 
	}catch(e){
		showErrorMessage("checkClaimPlateNo",e);
	}
}