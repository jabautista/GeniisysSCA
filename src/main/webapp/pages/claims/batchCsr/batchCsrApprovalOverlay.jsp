<div id="batchCsrApprovalDiv" name="batchCsrApprovalDiv" class="sectionDiv" style="width: 480px; margin: 10px;" align="center">
	<div id="waitDiv" name="waitDiv" style="float:left; width:100%; margin-bottom:10px; margin-top: 10px;">	
		<label style="margin-left:20px;">Please wait...</label>
	</div>
	<div id="progressBarMainDiv" name="progressBarMainDiv" style="float:left; width:440px; margin-left:20px; heigth: 15px; border:1px solid #456179;">
	 	<div id="progressBarDivDummy" name="progressBarDivDummy" style="display:none; width:0%; float:left; background-color:red;">&nbsp;</div>
	 	<div id="progressBarDiv" name="progressBarDiv" style="width:0%; float:left; background-color:#456179; color:white;">&nbsp;</div>
	</div>
	<div id="statusMainDiv" name="statusMainDiv" style="float:left; width:450px; margin-left:4.5%; margin-top:10px; margin-bottom:10px; height:20px auto;">
		<div style="float:left; width:100%; text-align:left;">&nbsp;</div>
	</div>
	<div style="float:left; width:100%; margin-bottom:10px;">
		<input type="button" class="button" id="btnApproveOk" name="btnApproveOk" value="Ok" style="display:none;"/>
	</div>
</div>

<script type="text/javascript">
	
	function approveBatchCsr(){
		try{
			var objParameters = new Object();
			objParameters.batchCsr = prepareJsonAsParameter(objBatchCsr);
			
			new Ajax.Request("BatchController", {
				method: "POST",
				parameters: {
					action: "approveBatchCsr",
					parameters: JSON.stringify(objParameters)
				},
				asynchronous: true,
				evalScripts: true,
				onComplete: function(response) {
					var text = response.responseText;
					var arr = text.split(resultMessageDelimiter);
					if (arr[0] == "Approving of Batch CSR successful.") {
						updater.stop();
						$("progressBarDiv").style.width = "100%";
						$("progressBarDiv").update("100%");
						$("statusMainDiv").down("div",0).update(arr[0]);
						good("batchCsrApprovalDiv");
						$("btnApproveOk").show();
						$("waitDiv").update("");
						$("progressBarDiv").style.background = "green";
						disableButton("btnGenerateBatch");
						disableButton("btnCancelBatch");
						disableButton("btnApproveBatch");
						enableButton("btnPrintBCSR");
						$("btnPrintBCSR").value = "Final BSCR";
					} 
				}
			});
			
			try {
				updater = new Ajax.PeriodicalUpdater('progressBarDivDummy','BatchController', {
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
								$("btnApproveOk").show();
								$("waitDiv").update("");
								showMessageBox("Approving of Batch CSR successful.", "S");
							}	
						} else {
							$("statusMainDiv").down("div",0).update("<font color='red'><b>ERROR:</b></font> "+arr[1]);
							//showMessageBox(arr[2], "E"); //comment out by jeffdojello							
							if(checkErrorOnResponse(request) && checkCustomErrorOnResponse(request)){ //jeffdojello 07.15.2014
								//TO DISPLAY CUSTOMERROR MESSAGE
								null;
							}
							$("progressBarDiv").style.background = "red";
							bad("batchCsrApprovalDiv");
							$("btnApproveOk").show();
							$("waitDiv").update("");
							updater.stop();
						}	
					}
				});
			} catch(e) {
				showErrorMessage("batchCsrApproval Periodical Updater", e);
	        } finally {
		        initializeAll();
	        }  
		}catch(e){
			showErrorMessage("batchCsrApproval",e);
		}
	}
	
	approveBatchCsr();
	
	$("btnApproveOk").observe("click", function(){
		overlayBatch.close();
		showBatchCsrPage(nvl($F("insertTag"), 0), objBatchCsr.batchCsrId);
	});
	
</script>