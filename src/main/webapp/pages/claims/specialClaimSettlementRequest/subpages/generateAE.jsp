<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="generateAEDiv" name="generateAEDiv" class="sectionDiv" style="width: 460px; margin: 10px 40px;" align="center">
	<div id="waitDiv" name="waitDiv" style="float:left; width:100%; margin-bottom:10px; margin-top: 10px;">	
		<label style="margin-left:20px;">Please wait...</label>
	</div>
	<div id="progressBarMainDiv" name="progressBarMainDiv" style="float:left; width:90%; margin-left:4.5%; heigth: 15px; border:1px solid #456179;">
	 	<div id="progressBarDivDummy" name="progressBarDivDummy" style="display:none; width:0%; float:left; background-color:red;">&nbsp;</div>
	 	<div id="progressBarDiv" name="progressBarDiv" style="width:0%; float:left; background-color:#456179; color:white;">&nbsp;</div>
	</div>
	<div id="statusMainDiv" name="statusMainDiv" style="float:left; width:310px; margin-left:4.5%; margin-top:5px; height:20px auto;">
		<div style="float:left; width:100%; text-align:left;">&nbsp;</div>
	</div>
	<div style="float:left; width:100%; margin-top:15px; margin-bottom:10px;">
		<input type="button" class="button" id="btnAEOk" name="btnAEOk" value="Ok" style="display:none;"/>
		<input type="button" class="button" id="btnAECancel" name="btnAECancel" value="Cancel"/>
	</div>	
</div>

<script>
	$("btnAECancel").observe("click", function(){
		generateAEOverlay.close(); // andrew - 07.15.2011
	});
	
	function generateAE(){
		try{
			var objParameters = {};
			objParameters.objNewBatchDV = objNewBatchDV;
			objParameters.issCd = nvl(specialCSR.paramBranchCd,"") == "" ? objCLMGlobal.issCd :specialCSR.paramBranchCd; 
			objParameters.objectSelectedAdviceRows = objectSelectedAdviceRows;
			var strParameters = JSON.stringify(objParameters);
			new Ajax.Request("BatchController", {
				method: "POST",
				parameters: {
					action: "generateAE",
					strParameters: strParameters
				},
				asynchronous: true,
				evalScripts: true,
				onCreate: function () {
				//	disableButton("btnGenerateAE");
				//	disableButton("btnAECancel");
				},
				onComplete: function(response) {										
					if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)) {
						var text = response.responseText;
						var arr = text.split(resultMessageDelimiter);
						
						if (arr[0] == "Generate AE Complete.") {
							updater.stop();
							$("progressBarDiv").style.width = "100%";
							$("progressBarDiv").update("100%");
							$("statusMainDiv").down("div",0).update(arr[0]);
							$("btnAECancel").hide();
							$("waitDiv").update("");
							$("btnAEOk").show();
							good("generateAEDiv");
							$("waitDiv").update("");
							$("progressBarDiv").style.background = "green";
							// adds the new batch to the object
							objGICLBatchDv = JSON.parse(arr[2]);
							specialCSR.showSpecialCSRInfo("Y");
						}  else {
							enableButton("btnAECancel");
						}			
					}
					messageTag = 1;
				}
			});
			
			try {
				updater = new Ajax.PeriodicalUpdater('progressBarDivDummy','BatchController', {
                	asynchronous:true, 
                	frequency: 1, 
                	method: "GET",
                	onSuccess: function(request) {                		
                		if(checkCustomErrorOnResponse(request) && checkErrorOnResponse(request)) {
							var text = request.responseText;
							var arr = text.split(resultMessageDelimiter);
							$("progressBarDiv").style.width = arr[0];
							$("progressBarDiv").update(((arr[0] == "0%")? "<font color='#456179'>"+arr[0]+"</font>":arr[0]));
							$("statusMainDiv").down("div",0).update((arr[1] == "") ? "&nbsp;" : arr[1]);
							
							if (nvl(arr[2],"") == ""){
								if (arr[0] == "100%") {
									$("progressBarDiv").style.width = arr[0];
									updater.stop();
								}	
							} else {
								$("statusMainDiv").down("div",0).update("<font color='red'><b>ERROR:</b></font> "+arr[1]);
								//params ? showMessageBox(arr[2], "E") :null;
								showMessageBox(arr[2], "E");
								$("progressBarDiv").style.background = "red";
								bad("generateAEDiv");
								updater.stop();
							}
							$("waitDiv").update("");							
                		} else {
                			updater.stop();
                		}
                		messageTag = 1;
					}
				});
			} catch(e) {
				showErrorMessage("Generate AE Periodical Updater", e);
	        } finally {
		        initializeAll();
	        }  
		}catch(e){
			showErrorMessage(e);
		}
	}
	generateAE();
	//$("btnGenerateAE").observe("click",generateAE);
	$("btnAEOk").observe("click", function(){
		generateAEOverlay.close();
		//showBatchCsrPage(nvl($F("insertTag"), 0), objBatchCsr.batchCsrId);
	});
	
</script>