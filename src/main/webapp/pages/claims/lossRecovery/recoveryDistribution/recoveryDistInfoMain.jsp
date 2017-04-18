<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%
	response.setHeader("Cache-control","no-cache");
	response.setHeader("Pragma","no-cache");
%>
<div id="recoveryDistMainDiv" name="recoveryDistMainDiv" style="margin-top: 1px;">
	<form id="recoveryDistForm" name="recoveryDistForm">
		<jsp:include page="/pages/claims/subPages/claimInformation.jsp"></jsp:include>
		<jsp:include page="/pages/claims/lossRecovery/recoveryDistribution/subPages/recoveryDistInfo.jsp"></jsp:include>
		<jsp:include page="/pages/claims/lossRecovery/recoveryDistribution/subPages/recoveryDist.jsp"></jsp:include>
		<jsp:include page="/pages/claims/lossRecovery/recoveryDistribution/subPages/recoveryRIDist.jsp"></jsp:include>
		<div class="buttonsDiv" style="margin-top: 20px; margin-bottom: 30px;" align="center" >
			<input type="button" id="btnCancel" name="btnCancel"  style="width: 115px;" class="button hover"   value="Cancel" />
			<input type="button" id="btnSave" name="btnSave"  style="width: 115px;" class="button hover"   value="Save" />
		</div>
	</form>
</div>
<script type="text/javascript">
	try{
		initializeAll();
		initializeAllMoneyFields();
		initializeAccordion();
		
		objGICLS054RiDist = new Object();
		
		function saveRecoveryDist(){
			try{
				//var modRecovDist = recDistTB.getModifiedRows();
				var modRecovDist = getAddedAndModifiedJSONObjects(recDistTB.geniisysRows);
				//var modRecovRIDist = recRIDistTB.getModifiedRows();
				var delRecovDist = recDistTB.getDeletedRows();
				//var delRecovRIDist = recRIDistTB.getDeletedRows();
				
				objParameters = new Object();
				objParameters.setRecovDist = modRecovDist; 
				//objParameters.setRecovRIDist = modRecovRIDist;
				objParameters.delRecovDist = delRecovDist; 
				//objParameters.delRecovRIDist = delRecovRIDist;
				var strObjParameters = JSON.stringify(objParameters);
				
				new Ajax.Request(contextPath+"/GICLClmRecoveryDistController", {
					parameters:{
						action: "saveDistRecovery",
						parameters: strObjParameters
					},
					asynchronous: false,
					evalscripts: true,
					onComplete: function(response){
						if(checkErrorOnResponse(response)) {
							var res = response.responseText.replace(/\\/g, '\\\\');
							if (res == "SUCCESS"){
								showMessageBox(objCommonMessage.SUCCESS, "S");
								changeTag = 0;
								recRIDistTB._refreshList(); //added by jdiago 08.05.2014 : refresh tablegrid.
								recDistTB._refreshList(); //added by jdiago 08.05.2014 : refresh tablegrid.
							}else{
								showMessageBox(response.responseText, "E");
							}
						}else{
							showMessageBox(response.responseText, "E");
						}
					} 
				});
			}catch(e){
				showErrorMessage("saveRecoveryDist", e);
			}
		} 
		
		objCLM.saveRecoveryDist = saveRecoveryDist;
		observeReloadForm("reloadForm", showRecoveryDistribution);
		observeSaveForm("btnSave", function(){saveRecoveryDist();});
		//marco - 05.17.2013
		observeCancelForm("btnCancel", function(){saveRecoveryDist();}, 
			function(){
				if(objCLMGlobal.callingForm != "GICLS052"){
					showClaimListing();
				}else{
					showLossRecoveryListing($F("lineCd"));
				}
			});
		changeTag = 0;
		initializeChangeTagBehavior(function(){saveRecoveryDist();}); 
		window.scrollTo(0,0); 	
		hideNotice("");
		setModuleId("GICLS054");
		setDocumentTitle("Loss Recovery Distribution");
	}catch(e){
		showErrorMessage("Recovery Dist Info Main", e);
	}
</script>