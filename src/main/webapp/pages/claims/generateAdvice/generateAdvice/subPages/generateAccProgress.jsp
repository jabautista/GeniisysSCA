<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="generateAccMainDiv">
	<div id="generateAccDiv" name="generateAccDiv" class="sectionDiv" style="width: 350px; margin: 10px 5px;" align="center">
		<div style="float:left; width:100%; margin-top:10px; margin-bottom:15px;">
			<label style="margin-left:16px;" id="lblComment">Comment</b></label>
		</div>	
		<div id="progressBarMainDiv" name="progressBarMainDiv" style="float:left; width:318px; margin-left:4.5%; heigth: 15px; border:1px solid #456179;">
		 	<!-- <div id="progressBarDivDummy" name="progressBarDivDummy" style="display:none; width:0%; float:left; background-color:red;">&nbsp;</div> -->
		 	<div id="progressBarDiv" name="progressBarDiv" style="width:0%; float:left; background-color:#456179; color:white;">0%</div>
		</div>		
		<div style="float:left; width:100%; margin-top:10px; margin-bottom:15px;">
			<label style="margin-left:16px;" id="lblFile">File</b></label>
		</div>	
	</div>
	<div align="center">
		<input type="button" class="button" id="btnGenerateAccOk" value="Ok" width="60">
	</div>
</div>
<script type="text/javascript">
	function createTransferEvents(){
		var info = "CSR to Accounting " + objGICLS032.objCurrGICLAdvice.lineCd + "-" + objGICLS032.objCurrGICLAdvice.issCd +"-"+objGICLS032.objCurrGICLAdvice.adviceYear+"-"+objGICLS032.objCurrGICLAdvice.adviceSeqNo;
		new Ajax.Request(contextPath+"/GIISEventController",{
			method: "POST",
			parameters: {action: "createTransferEvent",
						 moduleId : "GICLS032",
						 eventDesc : "CSR TO ACCOUNTING",
						 colValue : objGICLS032.objCurrGICLAdvice.adviceId,
						 info : info},						 
			onComplete: function(response){
				if(response.responseText != "SUCCESS"){
					Effect.Appear("generateAccMainDiv", {
						duration: 1,
						afterFinish: function () {
							fireEvent($("btnGenerateAccOk"), "click");
							fireEvent($("btnPrintCsr"), "click");							
						}
					});
					
					var users = response.responseText.split(resultMessageDelimiter);
					for(var i=0; i<users.length-1; i++){
						$("geniisysAppletUtil").sendMessage(unescapeHTML2(objGICLS032.vars.popupDir), users[i], "${PARAMETERS['USER'].userId} assigned a new transaction. - " + info);
					}
				}
			}
		});
	};
	
	$("btnGenerateAccOk").observe("click", function(){
		overlayGenerateAcc.close();
		delete overlayGenerateAcc; 
	});
	
	try {
		var updater = new Ajax.PeriodicalUpdater('progressBarDivDummy','GICLAdviceController', {
        	asynchronous:true,         	
        	frequency: 1, 
        	method: "GET",
        	parameters : {action: "showGenerateAccProgress"},
        	onSuccess: function(response) {
        		if(checkErrorOnResponse(response)){
					var progress = JSON.parse(response.responseText);
					
					$("progressBarDiv").style.width = progress.percentStatus;
					$("progressBarDiv").update(((progress.percentStatus == "0%")? "<font color='#456179'>"+progress.percentStatus+"</font>":progress.percentStatus));
					$("lblComment").innerHTML = progress.comment;
					$("lblFile").innerHTML = progress.file;
					if(progress.genAccMessage != ""){
						bad("generateAccDiv");
						$("progressBarDiv").style.background = "red";
						showMessageBox(progress.genAccMessage, imgMessage.ERROR);
						updater.stop();
					}
					if(progress.percentStatus == "100%") {
						good("generateAccDiv");
						$("progressBarDiv").style.background = "green";
						$("progressBarDiv").style.width = progress.percentStatus;
						updater.stop();
						objGICLS032.disableEnableButtons();
						createTransferEvents();
					}
				} else {
					updater.stop();
				}
			}
		});
	} catch(e) {
		showErrorMessage("postPAR Periodical Updater", e);
    }	
</script>