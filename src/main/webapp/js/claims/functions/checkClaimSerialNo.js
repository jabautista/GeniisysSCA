/**
 * checkClaimPlateNo
 * Description: Checks if the serial no. is existing in the other claims 
 * @param serialNo
 * @param dspLossDate
 * @param element
 * @author Irwin Tabisora 9.19.11
 * */

function checkClaimSerialNo(serialNo,dspLossDate,element){
	try{
		dspLossDate = dateFormat(Date.parse(objCLMGlobal.strDspLossDate), "mm-dd-yyyy");
		new Ajax.Request(contextPath + "/GICLClaimsController?action=checkClaimSerialNo&dspLossDate="+dspLossDate,{
			method: "GET",
			parameters: {
				serialNo: serialNo
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
					showWaitingMessageBox("Serial Number has an existing claim, Claim Number: "+obj.claimNo+" Loss Date: "+obj.dspLossDate, imgMessage.INFO,function(){
						if(element != null){
							$(element).focus();	
						}
						
					});
				}
			}
		}); 
	}catch (e) {
		showErrorMessage("checkClaimSerialNo",e);
	}
}