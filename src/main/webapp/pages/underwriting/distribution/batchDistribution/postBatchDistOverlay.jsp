<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="postBatchDistDiv" name="postBatchDistDiv" class="sectionDiv" style="width: 480px; margin: 10px;" align="center">
	<div id="statusMainDiv" name="statusMainDiv" style="float:left; width:310px; margin-left:4.5%; margin-top:15px; margin-bottom:10px; height:20px auto;">
		<div style="float:left; width:100%; text-align:left;">&nbsp;</div>
	</div>
	<div id="progressBarMainDiv" name="progressBarMainDiv" style="float:left; width:440px; margin-left:20px; heigth: 15px; border:1px solid #456179;">
	 	<div id="progressBarDivDummy" name="progressBarDivDummy" style="display:none; width:0%; float:left; background-color:red;">&nbsp;</div>
	 	<div id="progressBarDiv" name="progressBarDiv" style="width:0%; float:left; background-color:#456179; color:white;">&nbsp;</div>
	</div>
	<div style="float:left; width:100%; margin-top:10px; margin-bottom:15px;">	
		<label id="dspPolicyTitle" style="margin-left:20px;">Policy No :</label>
		<label id="dspPolicyNo" style="margin-left:10px; font-weight: bolder;"></label>
	</div>
</div>

<script type="text/javascript">
	var batchId = nvl(objUW.hidObjGIUWS015.selectedGiuwPolDistPolbasicV.batchId, "");
	postDistribution("postBatchDistribution", batchId);
	
	function postDistribution(action, batchId){
		try{
			new Ajax.Request("PostDistributionController", {
				method: "POST",
				parameters: {
					action: action,
					batchId: batchId
				},
				asynchronous: true,
				evalScripts: true,
				onCreate: function () {
					disableButton("btnPostDist");
				},
				onComplete: function(response) {
					var text = response.responseText;
					var arr = text.split(resultMessageDelimiter);
					if (arr[1] == "Posting distribution Successful.") {
						updater.stop();
						$("progressBarDiv").style.width = "100%";
						$("progressBarDiv").update("100%");
						$("statusMainDiv").down("div",0).update(arr[0]);
						good("postParDiv");
						$("progressBarDiv").style.background = "green";
					} 			
				}
			});
			
			try {
				updater = new Ajax.PeriodicalUpdater('progressBarDivDummy','PostDistributionController', {
	            	asynchronous:true, 
	            	frequency: 1, 
	            	method: "GET",
	            	onSuccess: function(request) {
						var text = request.responseText;
						var arr = text.split(resultMessageDelimiter);
						$("progressBarDiv").style.width = arr[0];
						$("progressBarDiv").update(((arr[0] == "0%")? "<font color='#456179'>"+arr[0]+"</font>":arr[0]));
						$("statusMainDiv").down("div",0).update((arr[1] == "") ? "&nbsp;" : arr[1]);
						if (nvl(arr[2],"") == ""){
							if (arr[0] == "100%") {
								$("progressBarDiv").style.width = arr[0];
								updater.stop();
								overlayBatchPost.close();
								showWaitingMessageBox("Posting Distribution Successful.", "S", 
										              function(){
						              					//Modalbox.hide();	// replaced by code below : shan 08.12.2014
						              					overlayBatchDistShare.close();
						              					giuwPolDistPolbasicVTableGrid.clear();
						    							giuwPolDistPolbasicVTableGrid.refresh();
						    							disableButton("btnDistribute");//edgar 11/4/2014 to disable redistributing of already posted batch records
										              });
							}	
						} else {
							updater.stop();
							$("statusMainDiv").down("div",0).update("<font color='red'><b>ERROR:</b></font> "+arr[1]);
							showWaitingMessageBox(arr[2], "E", function(){overlayBatchPost.close();});
							$("progressBarDiv").style.background = "red";
							bad("postParDiv");
						}	
					}
				});
			} catch(e) {
				showErrorMessage("postDistribution Periodical Updater", e);
	        } finally {
		        initializeAll();
	        }  
		}catch(e){
			showErrorMessage("postDistribution",e);
		}
}	

</script>