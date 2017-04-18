<div>
	<div style="margin-top: 10px;text-align:center">
		<input type="button" class="button" id="btnCreateNewReport" value="Create New Report" style="width:170px;"/>
		<input type="button" class="button" id="btnReviseReport" value="Revised a saved Report" style="width:170px;"/>
	</div>
	<div style="margin-top:10px;text-align:center">
		<input type="button" class="button" id="btnCreateAdditional" value="Create Additional Report" style="width:170px;"/>
		<input type="button" class="button" id="btnCancelAddOverlay" value="Cancel" style="width:170px;"/>
	</div>
</div>


<script>

	$("btnCreateAdditional").observe("click", function(){
		getForAdditionalReportList(mcMainObj);
	});
	$("btnCreateNewReport").observe("click",function(){
		showConfirmBox4("Add report?","Do you want to copy from an existing report?", "Yes", "No","Cancel", function(){
			getCopyReportLOV(nvl(mcMainObj.claimId, 0));
		}, 
		function(){
			$("dspCurrShortname").value = nvl(mcMainObj.dspCurrShortname,"");
			$("currencyRate").value = nvl(mcMainObj.currencyRate,"");
			$("newRepFlag").value = "Y";
			toggleEditableOtherDetails(true);
			genericObjOverlay.close();
			changeTag= 1;
			enableButton("btnSave");
		}
		,
		function(){
			genericObjOverlay.close();
		});
	});
	$("btnCancelAddOverlay").observe("click",function(){
		genericObjOverlay.close();
	});
	
	$("btnReviseReport").observe("click", function(){
		getForAdditionalReportList(mcMainObj,"Y");
	});
	
	function getCopyReportLOV(claimId){
		try{
			LOV.show({
				controller: "ClaimsLOVController",
				urlParameters: {action : "getCopyReportLOV",
								page : 1,
								claimId : claimId},
				title: "Copy from Existing Report",
				width: 375, 
				height: 390,
				columnModel : [
								{
									id : "evalId",
									title: "",
									width: '0px',
									visible: false
									
								},
								{
									id : "evaluationNo",
									title: "Evaluation No.",
									width: '355px'
								}
							],
				draggable: true,
				onSelect : function(row){
					$("copyDtlFlag").value = "Y";
					$("newRepFlag").value = "Y";
					$("copiedEvalId").value = row.evalId;
					toggleEditableOtherDetails(true);
					genericObjOverlay.close();
					changeTag = 1;
					enableButton("btnSave");
				}
			});	
		}catch(e){
			showErrorMessage("getCopyReportLOV", e);
		}
	}
	
	function getForAdditionalReportList(obj, param){
		try{
			LOV.show({
				controller: "ClaimsLOVController",
				urlParameters: {action : "getForAdditionalReportList",
								claimId : obj.claimId,
								plateNo: obj.plateNo,
								perilCd: obj.perilCd, 
								payeeClassCd: obj.payeeClassCd, 
								payeeNo: obj.payeeNo,
								tpSw: obj.tpSw,
								evalStatCd: 'AD',
								itemNo: obj.itemNo,
								page : 1},
				title: "Additional Report",
				width: 700,
				height: 400,
				columnModel : [
								{
									id : "evaluationNo",
									title: "Evaluation Number",
									width: '300px'
								},{
									id : "inspectDate",
									title: "Inspection Date",
									width: '100px'
								},{
									id : "inspectPlace",
									title: "Place Inspected",
									width: '100px'
								},{
									id : "adjuster",
									title: "Adjuster",
									width: '100px'
								},{
									id : "dspEvalDesc",
									title: "Status",
									width: '100px'
								}
								,{
									id : "evalId",
									title: "Status",
									width: '0px',
									visible:false
								},{
									id : "evalDate",
									title: "Status",
									width: '100px',
								    visible:false
								}
								,{
									id : "adjusterId",
									title: "Status",
									width: '100px',
								    visible:false
								}
							],
				draggable: true,
				onSelect : function(row){
					if(param == "Y"){
						showConfirmBox("Revise Report", "This will automatically create a revision for this report. Do you want to continue?","Yes","No", function(){
							$("reviseFlag").value = "Y";
							$("copiedEvalId").value = row.evalId;
							showConfirmBox("Copy Details", "Do you want to copy the details?", "Yes", "No", function(){
								$("copyDtlFlag").value = "Y";
								saveMCEvaluationReport();
							},function(){
								saveMCEvaluationReport();
							});
						},null);
					}else{
						showConfirmBox("Additional Report", "This will automatically create an additional report. Do you want to continue?","Yes","No", function(){
							createAdditionalReport(row.evalId);
							genericObjOverlay.close();
						},null);
					}
					
				}
			});	
		}catch (e) {
			showErrorMessage("getForAdditionalReportList",e);
		}
	}
</script>