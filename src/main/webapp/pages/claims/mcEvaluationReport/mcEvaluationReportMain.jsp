<form id="mcEvalForm" name="mcEvalForm">
	<div id="mcEvaluationReportMainDiv" name="mcEvaluationReportMainDiv">
		<div id="claimListingMenu2">
			<div id="mainNav" name="mainNav">
				<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
					<ul>
						<li><a id="exit">Exit</a></li>
					</ul>
				</div>
			</div>
		</div>
		
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
				<label>Motor Car Evaluation Report</label>
				<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label>
			 		<input type="hidden" id="lineCd" name="lineCd" value="${lineCd}"> 
			 		<label id="reloadForm" name="reloadForm">Reload Form</label>
				</span>
			</div>
		</div>
		
		<div id="mcEvaluationReportInfoDiv" class="sectionDiv"  align="center">
			<div id="parInfo" name="parInfoTop" style="margin: 10px;">
				<table align="center" border="0">
					<tr>
						<td class="rightAligned" >Policy No.</td>
						<td class="leftAligned" style="width: 320px;">
							<input type="text" id="txtLineCd" name="txtLineCd" value="" style="width: 20px;" readonly="readonly">
							<input type="text" id="txtSublineCd" name="txtSublineCd" value="" style="width: 50px;" readonly="readonly">
							<input type="text" id="txtPolIssCd" name="txtPolIssCd" value="" style="width: 40px;"  readonly="readonly">
							<input type="text" id="txtPolIssueYy" name="txtPolIssueYy" value="" style="width: 40px; text-align: right;"  readonly="readonly">
							<input type="text" id="txtPolSeqNo" name="txtPolSeqNo" value="" style="width: 50px; text-align: right;" readonly="readonly">
							<input type="text" id="txtPolRenewNo" name="txtPolRenewNo" value="" style="width: 40px; text-align: right;" readonly="readonly">
						</td>
						<td class="rightAligned" >Accident Date</td>
						<td class="leftAligned">
							<input type="text" id="txtLossDate" name="txtLossDate" value="" style="width: 292px;" readonly="readonly">
						</td>
					</tr>
					<tr>
			 			<td class="rightAligned" >Claim No.</td>
						<td class="leftAligned" colspan="3">
							<input id="txtClmLineCd" name="txtClmLineCd" type="text" style="width: 20px; float: left; margin-right: 5px; height: 13px;" value="MC" readonly="readonly" class="required"/>
				
							<div style="width: 88px; float: left; " class="withIconDiv required">
								<input type="text" id="txtClmSublineCd" name="txtClmSublineCd" value="" style="width: 61px;" class="withIcon required" readonly="readonly">
								<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtClmSublineCdIcon" name="txtClmSublineCdIcon" alt="Go" />
							</div>
							<div style="width: 45px; float: left;" class="withIconDiv required">
								<input type="text" id="txtClmIssCd" name="txtClmIssCd" value="" style="width: 20px;" class="withIcon required" maxlength="2">
								<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtClmIssCdIcon" name="txtClmIssCdIcon" alt="Go" />
							</div>
							<div style="width: 43px; float: left;" class="withIconDiv required">
								<input type="text" id="txtClmYy" name="txtClmYy" value="" style="width: 18px; text-align: right;" class="withIcon integerNoNegativeUnformattedNoComma required" maxlength="2" >
								<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtClmYyIcon" name="txtClmYyIcon" alt="Go" />
							</div>
							<div style="width: 79px; float: left;" class="withIconDiv required">
								<input type="text" id="txtClmSeqNo" name="txtClmSeqNo" value="" style="width: 54px; text-align: right;" class="withIcon integerNoNegativeUnformattedNoComma required"  >
								<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtClmSeqNoIcon" name="txtClmSeqNoIcon" alt="Go" />
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" >Assured Name</td>
						<td class="leftAligned" colspan="3">
							<input type="text" id="txtAssuredName" name="txtAssuredName" value="" style="width: 705px;" readonly="readonly">
						</td>
					</tr>
				</table>
			</div>	
			<%-- <table border="0" style="margin-top: 10px; margin-bottom: 4px; align="center" >
				<tr>
					<!-- <td class="rightAligned" >Policy No.</td> -->
					<td class="leftAligned" style="width: 420px;" colspan="2">
						<label style="float: left; text-align: right; margin-top: 6px; margin-right: 5px;">Policy No. </label>
						<input type="text" id="txtLineCd" name="txtLineCd" value="" style="width: 20px;" readonly="readonly">
						<input type="text" id="txtSublineCd" name="txtSublineCd" value="" style="width: 64px;" readonly="readonly">
						<input type="text" id="txtPolIssCd" name="txtPolIssCd" value="" style="width: 43px;"  readonly="readonly">
						<input type="text" id="txtPolIssueYy" name="txtPolIssueYy" value="" style="width: 43px;"  readonly="readonly">
						<input type="text" id="txtPolSeqNo" name="txtPolSeqNo" value="" style="width: 64px;" readonly="readonly">
						<input type="text" id="txtPolRenewNo" name="txtPolRenewNo" value="" style="width: 43px;" readonly="readonly">
					</td>
					<td class="rightAligned" >Accident Date</td>
					<td class="leftAligned">
						<input type="text" id="txtLossDate" name="txtLossDate" value="" style="width: 292px;" readonly="readonly">
					</td>
				</tr>	
				<tr>
		 			<td class="rightAligned" >Claim No.</td>
					<td class="leftAligned">
						<input id="txtClmLineCd" name="txtClmLineCd" type="text" style="width: 20px; float: left; margin-right: 5px;" value="MC" readonly="readonly" class="required"/>
			
						<div style="width: 117px; float: left;" class="withIconDiv required">
							<input type="text" id="txtClmSublineCd" name="txtClmSublineCd" value="" style="width: 92px;" class="withIcon required" readonly="readonly">
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtClmSublineCdIcon" name="txtClmSublineCdIcon" alt="Go" />
						</div>
						<div style="width: 45px; float: left;" class="withIconDiv required">
							<input type="text" id="txtClmIssCd" name="txtClmIssCd" value="" style="width: 20px;" class="withIcon required" maxlength="2">
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtClmIssCdIcon" name="txtClmIssCdIcon" alt="Go" />
						</div>
						<div style="width: 43px; float: left;" class="withIconDiv required">
							<input type="text" id="txtClmYy" name="txtClmYy" value="" style="width: 18px;" class="withIcon integerNoNegativeUnformattedNoComma required" maxlength="2" >
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtClmYyIcon" name="txtClmYyIcon" alt="Go" />
						</div>
						<div style="width: 89px; float: left;" class="withIconDiv required">
							<input type="text" id="txtClmSeqNo" name="txtClmSeqNo" value="" style="width: 64px;" class="withIcon integerNoNegativeUnformattedNoComma required"  >
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtClmSeqNoIcon" name="txtClmSeqNoIcon" alt="Go" />
						</div>
					</td>
					<td class="rightAligned" >Plate No.</td>
					<td class="leftAligned">
						<!-- <input type="text" id="txtPlateNo" name="txtPlateNo" value="" style="width: 292px;" readonly="readonly"> -->
						<div style="width: 298px; float: left;" class="withIconDiv">
							<input type="text" id="txtPlateNo" name="txtPlateNo" value="" style="width: 50%;" class="withIcon" readonly="readonly" >
							<img  style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtPlateNoIcon" name="textItemNoIcon" alt="Go"/>
						</div>
					</td>
					
				</tr>	
				<tr>
					<td class="rightAligned" >Item No.</td>
					<td class="leftAligned">
						<div style="width: 60px; float: left;" class="withIconDiv required">
							<input type="text" id="textItemNo" name="textItemNo" value="" style="width: 50%;" class="withIcon required" readonly="readonly" >
							<img  style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="textItemNoIcon" name="textItemNoIcon" alt="Go"/>
						</div>
						<!-- <input type="text" id="textItemNo" name="textItemNo" value="" style="width: 30px;" readonly="readonly"/> -->
						<input type="text" id="textItemDesc" name="textItemDesc" value="" style="width: 275px;" readonly="readonly"/>
					</td>
					
					<td class="rightAligned" >Peril Name</td>
					<td class="leftAligned">
						<div style="width: 59px; float: left;" class="withIconDiv required">
							<input type="text" id="txtPerilCd" name="txtPerilCd" value="" style="width: 34px;" class="withIcon required" readonly="readonly" >
							<img  style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtPerilCdIcon" name="txtPerilCdIcon" alt="Go" class="required"/>
						</div>
						<!-- <input type="text" id="txtPerilCd" name="txtPerilCd" value="" style="width: 30px;" readonly="readonly"/> -->
						<input type="text" id="txtPerilName" name="txtPerilName" value="" style="width: 227px;" readonly="readonly" class="required"/>
					</td>
				</tr>
			</table>
			<table border="0" margin-bottom: 10px;" align="left"style="margin-left: 18px;" >
				<tr>
					<td class="rightAligned" >Assured Name</td>
					<td class="leftAligned" >
						<input type="text" id="txtAssuredName" name="txtAssuredName" value="" style="width: 600px;" readonly="readonly">
					</td>
				</tr>
			</table> --%>
		</div>
		<%-- 	<jsp:include page="/pages/claims/mcEvaluationReport/subpages/mcEvalItemTGListing.jsp"></jsp:include> --%>
		<div class="sectionDiv"> 
			<div id="mcEvalItemTGMainDiv" style="height: 215px;"></div>
			<div>
				<table align="center" border="0">	
					<tr>
						<td class="rightAligned" >Item No.</td>
						<td class="leftAligned">
							<div style="width: 60px; float: left;" class="withIconDiv required">
								<input type="text" id="textItemNo" name="textItemNo" value="" style="width: 50%;" class="withIcon required" readonly="readonly" >
								<img  style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="textItemNoIcon" name="textItemNoIcon" alt="Go"/>
							</div>
							<!-- <input type="text" id="textItemNo" name="textItemNo" value="" style="width: 30px;" readonly="readonly"/> -->
							<input type="text" id="textItemDesc" name="textItemDesc" value="" style="width: 275px;" readonly="readonly"/>
						</td>
						<td class="rightAligned" >Plate No.</td>
						<td class="leftAligned">
							<!-- <input type="text" id="txtPlateNo" name="txtPlateNo" value="" style="width: 292px;" readonly="readonly"> -->
							<div style="width: 298px; float: left;" class="withIconDiv">
								<input type="text" id="txtPlateNo" name="txtPlateNo" value="" style="width: 50%;" class="withIcon" readonly="readonly" >
								<img  style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtPlateNoIcon" name="textItemNoIcon" alt="Go"/>
							</div>
						</td>
						
					</tr>	
					<tr>
						<td class="rightAligned" >Peril Name</td>
						<td class="leftAligned">
							<div style="width: 60px; float: left;" class="withIconDiv required">
								<input type="text" id="txtPerilCd" name="txtPerilCd" value="" style="width: 34px;" class="withIcon required" readonly="readonly" >
								<img  style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtPerilCdIcon" name="txtPerilCdIcon" alt="Go" class="required"/>
							</div>
							<!-- <input type="text" id="txtPerilCd" name="txtPerilCd" value="" style="width: 30px;" readonly="readonly"/> -->
							<input type="text" id="txtPerilName" name="txtPerilName" value="" style="width: 275px;" readonly="readonly" class="required"/>
						</td>
					</tr>
				</table>
			</div>
			<div class="buttonsDiv" style="margin-bottom: 10px">
				<input type="button" id="btnAddItem" 	name="btnAddItem" 		class="button"	value="Add" />		
			</div>
		</div>
		<div id="mcEvaluationTGMainDiv" class="sectionDiv" style="height: 250px;"></div>
		
		<jsp:include page="/pages/claims/mcEvaluationReport/subpages/mcEvaluationDetails.jsp"></jsp:include>	
		
		<div id="mcEvalButtonsDiv"  class="buttonDiv">
			<table align="left" border="0" style="margin-left: 100px;  margin-top: 10px;">
				<tr>
					<td>
						<input type="button" class="disabledButton" style="width: 150px;"  id="btnReplaceDetails" value=""/>
					</td>
					<td>
						<input type="button" class="disabledButton" style="width: 150px;" id="btnRepairDetails"	value=""/>
					</td>
					<td>
						<input type="button" class="disabledButton" style="width: 150px;" id="btnVehicleInformation" value="Vehicle Information"/>
					</td>
					<td>
						<input type="button" class="disabledButton" style="width: 150px;" id="btnCSL" value="CSL"/>
					</td>
					<td>
						<input type="button" class="disabledButton" style="width: 150px;" id="btnPostReport"	value="Post Report"/>
					</td>
				</tr>
				<tr>
					<td>
						<input type="button" class="disabledButton" style="width: 150px;"  id="btnApplyDeductibles" value="Apply Deductibles"/>
					</td>
					<td>
						<input type="button" class="disabledButton" style="width: 150px;" id="btnApplyDepreciation"	value="Apply Depreciation"/>
					</td>
					<td>
						<input type="button" class="disabledButton" style="width: 150px;" id="btnVatDetails" value="V.A.T. Details"/>
					</td>
					<td>
						<input type="button" class="disabledButton" style="width: 150px;" id="btnLOA" value="LOA"/>
					</td>
					<td>
						<input type="button" class="disabledButton" style="width: 150px;" id="btnAdditionalReport"	value="Additional Report"/>
					</td>
				</tr>
				<tr>
					<td>
						<input type="button" class="disabledButton" style="width: 150px;"  id="btnDeductibleDetails" value="Deductible Details"/>
					</td>
					<td>
						<input type="button" class="disabledButton" style="width: 150px;" id="btnDepreciationDetails"	value="Depreciation Details"/>
					</td>
					<td>
						<input type="button" class="disabledButton" style="width: 150px;" id="btnCancelReport" value="Cancel Report"/>
					</td>
					<td>
						<input type="button" class="disabledButton" style="width: 150px;" id="btnPrintEvaluationSheet" value="Print Evaluation Sheet"/>
					</td>
					<td>
						<input type="button" class="disabledButton" style="width: 150px;" id="btnReviseReport"	value="Revise Report"/>
					</td>
				</tr>
			</table>
			
		</div>
		
		<div class="sectionDiv"  style="padding-top: 5px; padding-bottom:5px;  margin-bottom:30px; border: none; " >
			<div style="text-align:center">
				<input type="button" class="disabledButton" style="width: 150px;" id="btnAddReport" value="Add Report"/>
				<input type="button" class="disabledButton" style="width: 150px;" id="btnSave" value="Save"/>
			</div>
		</div>
		<!-- <table align="center" border="0" style="margin-left: 100px; margin-bottom: 30px; margin-top: 10px;">
			<tr >
				<td>
					<input type="button" class="disabledButton" style="width: 150px;" id="btnAddReport" value="Add Report"/>
				</td>
				<td>
					<input type="button" class="disabledButton" style="width: 150px;" id="btnSave" value="Save"/>
				</td>
			</tr>
		</table> -->
	</div>
	
	<input type="hidden" id="newRepFlag" value="" />	
	<input type="hidden" id="copyDtlFlag" value="" />	
	<input type="hidden" id="reviseFlag" value="" />	
	<input type="hidden" id="additionalFlag" value=""/>
	<input type="hidden" id="editMode" value="" />
	<input type="hidden" id="copiedEvalId" value="" />
	<input type="hidden" id="hidInspectionDate" value="" />
	
	
</form>	

<script type="text/javascript">
	/***
		Author: Irwin Tabisora
		Date: 13.01.2012
	*/
	variablesObj = "${variablesObj}".toQueryParams();
	$("btnReplaceDetails").value = variablesObj.replaceLabel +" Details";
	$("btnRepairDetails").value = variablesObj.repairLabel +" Details";
	var objMcEvalItem = [];
	function printEvaluationSheet(updateSw){
		try{
			var claimNo = mcMainObj.lineCd +'-'+mcMainObj.sublineCd+'-'+mcMainObj.issCd+'-'+mcMainObj.clmYy+'-'+mcMainObj.clmSeqNo;
			var reportId = 'GICLR070';
			reportTitle='Evaluation Sheet';
			var content = contextPath+"/GICLMcEvaluationPrintController?action=printEvaluationSheet&claimId="+mcMainObj.claimId
			+"&evalId="+selectedMcEvalObj.evalId+"&updateSw="+updateSw+"&claimNo="+claimNo
			+"&reportId="+reportId+"&reportTitle="+reportTitle
			+"&printerName="+$F("selPrinter");
			
			if("screen" == $F("selDestination")){
				showPdfReport(content, reportTitle);
			}else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					parameters : {noOfCopies : $F("txtNoOfCopies")},					
					onComplete: function(response){
						hideNotice();
						checkErrorOnResponse(response);
					}
				});
			}
		}catch(e){
			showErrorMessage("printEvaluationSheet",e);
		}
	}
	
	
	
	$("btnPrintEvaluationSheet").observe("click",function(){
		var updateSw = '';
		
		
		if(selectedMcEvalObj.masterReportType == "RD"){
			showConfirmBox("Print RD Alert", "Print only revised items compared from the previous report?","Yes","No",
				function(){
					updateSw = "Y";
					showGenericPrintDialog("Print EvaluationSheet", function(){
						printEvaluationSheet(updateSw);
					});
				},function(){
					updateSw = "";
					showGenericPrintDialog("Print EvaluationSheet", function(){
						printEvaluationSheet(updateSw);
					});
				}
			);
		}else{
			updateSw = "";
			showGenericPrintDialog("Print EvaluationSheet", function(){
				printEvaluationSheet(updateSw);
			});
		}
	});
	
	$("btnReplaceDetails").observe("click",function(){
		if(checkChanges()){
			mcEvalGrid.keys.removeFocus(mcEvalGrid.keys._nCurrentFocus, true);
			mcEvalGrid.releaseKeys();
			showMcEvalReplaceDetails();
		}
	});
	
	$("btnRepairDetails").observe("click",function(){
		if(checkChanges()){
			showMcEvalRepairDetails();
		}
	});
	
	$("btnLOA").observe("click", function(){
		if(checkChanges()){
			showMcEvalLoa();
		}
	});
	
	
	$("btnCSL").observe("click", function(){
		if(checkChanges()){
			showMcEvalCsl();
		}
	});
	
	$("btnDepreciationDetails").observe("click", function(){
		if(checkChanges()){
			showMcEvalDepreciationDetails();
		}
	});
	
	$("btnApplyDepreciation").observe("click",function(){
		if(checkChanges()){
			applyDepreciation();
		}
	});
	
	$("btnVatDetails").observe("click",function(){
		if(checkChanges()){
			showMcEvalVATDetails();
		}
	});
	
	$("btnDeductibleDetails").observe("click", function(){
		if(checkChanges()){
			showMcEvalDeductibleDetails();
		}
	});
	
	$("btnApplyDeductibles").observe("click", function(){
		if(checkChanges()){
			showApplyDedDialogBox("main");
		}
	});
	
	$("btnAdditionalReport").observe("click",function(){
		showConfirmBox("Additional Report", "This will automatically create an additional report. Do you want to continue?","Yes","No", function(){
			createAdditionalReport(selectedMcEvalObj.evalId.toString());
		},null);
	});
	
	$("btnAddReport").observe("click",function(){
		if ($F("textItemNo") == "" ||$F("txtPerilCd") == ""){
			showMessageBox("No record selected", "I");
			return;
		}else{
			genericObjOverlay = Overlay.show(contextPath+"/GICLMcEvaluationController", { 
				urlContent: true,
				urlParameters: {action : "showAddNewReportOverlay",
								ajax : "1"},
				title: "Add New Report",							
			    height: 80,
			    width: 400,
			    draggable: true
			});	
		}
	});
	
	$("btnCancelReport").observe("click", function(){
		showConfirmBox("Cancel Report", "Are you sure you want to cancel this report?","Yes","No", cancelMcEvalreport,null);
	});
	
	$("btnVehicleInformation").observe("click", function(){
		if(checkChanges()){
			getVehicleInformation(mcMainObj.claimId,mcMainObj.sublineCd,selectedMcEvalObj.payeeNo, selectedMcEvalObj.payeeClassCd,selectedMcEvalObj.tpSw);
		}
	});
	
	$("btnReviseReport").observe("click", function(){
		showConfirmBox("Revise Report", "This will automatically create a revision for this report. Do you want to continue?","Yes","No", function(){
			$("reviseFlag").value = "Y";
			$("copiedEvalId").value = selectedMcEvalObj.evalId;
			showConfirmBox("Copy Details", "Do you want to copy the details?", "Yes", "No", function(){
				$("copyDtlFlag").value = "Y";
				saveMCEvaluationReport();
			},function(){
				saveMCEvaluationReport();
			});
		},null);
	});
	
	$("btnPostReport").observe("click",function(){
		
		if(selectedMcEvalObj.perilCd == "" || selectedMcEvalObj.perilCd == null){
			showMessageBox("Peril code must have a value before posting this report.","I");
		}else{
			if(changeTag == 1){
				showConfirmBox("Confirm Changes","Posting this report will automatically save the changes you have made. Do you want to continue?","Yes","No",
					validateBeforePostMap,
					null
				);
			}else{
				validateBeforePostMap();
			}	
		}
	});
	
	function checkChanges(){
		if(changeTag == 1){
			showMessageBox("Report must be saved first before you could enter details", "I");
			return false;
		}else{
			return true;
		}
	}
	
	$("inspectDate").observe("focus", function(){
		if($F("inspectDate") != "" && $F("hidInspectionDate") != $F("inspectDate")){
			changeTag = 1;
		}
	});
	
	$("txtClmSublineCdIcon").observe("click", getMcEvaluationSublineLOV);
	$("txtClmIssCdIcon").observe("click", function(){
		if($F("txtClmSublineCd") != ""){
			getMcEvaluationIssSourceLOV($F("txtClmSublineCd"));	
		}else{
			customShowMessageBox("Please select a subline first.", "I","txtClmSublineCd");
		}
		
	});
	$("txtClmYyIcon").observe("click",function(){
		if($F("txtClmSublineCd") != ""){
			if($F("txtClmIssCd") !=""){
				getMcEvaluationClmYyLOV($F("txtClmSublineCd"),$F("txtClmIssCd"));
			}else{
				customShowMessageBox("Please select a issuing source first.", "I","txtClmIssCd");
			}
		}else{
			customShowMessageBox("Please select a subline first.", "I","txtClmSublineCd");
		}
		
	});
	$("txtClmSeqNoIcon").observe("click",function(){
		if($F("txtClmSublineCd") != ""){
			if($F("txtClmIssCd") !=""){
				if($F("txtClmYy")!= ""){
					getMcEvaluationClmSeqNoLOV($F("txtClmSublineCd"),$F("txtClmIssCd"),$F("txtClmYy"));
				}else{
					customShowMessageBox("Please select a claim year first.", "I","txtClmIssCd");
				}
			}else{
				customShowMessageBox("Please select a issuing source first.", "I","txtClmIssCd");
			}
		}else{
			customShowMessageBox("Please select a subline first.", "I","txtClmSublineCd");
		}
		
	});
	
	
	$("btnSave").observe("click",function(){
		if(changeTag == 0){
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
		}else{
			saveMCEvaluationReport();
		}
	});
	
	
	$("dspAdjusterDescIcon").observe("click", function (){
		getMcEvalAdjusterListing(mcMainObj.claimId);
	});
	
	
	setModuleId("GICLS070");
	setDocumentTitle("GENIISYS - Motorcar Evaluation Report");
	initializeAccordion();
	initializeAll();
	initializeAllMoneyFields();
	
	initializeChangeTagBehavior(saveMCEvaluationReport);
	
	observeReloadForm("reloadForm",function(){
		if(mcEvalFromItemInfo == "Y"){
			showMcEvaluationReport("itemInfo");	
		}else{
			showMcEvaluationReport();	
		}
		
	});
	
	$("textItemNoIcon").observe("click",  function(){
		getEvalItemLOV(nvl(mcMainObj.claimId,"0"));
	});
	
	$("txtPerilCdIcon").observe("click", function (){
		getEvalPerilLOV(nvl(mcMainObj.claimId,"0"), nvl(mcMainObj.itemNo,"0"));
	});
	
	$("txtPlateNoIcon").observe("click", function(){
		getMcEvalPlateNoLOV(nvl(mcMainObj.claimId,"0"), nvl(mcMainObj.itemNo,"0"));
	});
	
	function setObjMcEvalItem(func){
		//marco - 05.27.2015 - GENQA SR 4484 - clone object to prevent modification of original values
		var rowObjGdpc = Object.clone(mcMainObj);
		//var rowObjGdpc = new Object();			
		//rowObjGdpc = mcMainObj;
		rowObjGdpc.itemNo = $F("textItemNo");
		rowObjGdpc.dspItemDesc = $F("textItemDesc");
		rowObjGdpc.plateNo = $F("txtPlateNo");
		rowObjGdpc.perilCd = $F("txtPerilCd");
		rowObjGdpc.dspPerilDesc = $F("txtPerilName");
		return rowObjGdpc;
	}
	
	function rowExists(){
		var exist = false;
		if ($F("txtPlateNo") == ""){
			var existing = $F("textItemNo") + $F("txtPerilCd");
			if(getObjectFromArrayOfObjects(mcEvalItemGrid.geniisysRows, "itemNo perilCd", existing)){
				exist = true;
			}	
		}else{
			var existing = $F("textItemNo") + $F("txtPerilCd") + $F("txtPlateNo");
			if(getObjectFromArrayOfObjects(mcEvalItemGrid.geniisysRows, "itemNo perilCd plateNo", existing)){
				exist = true;
			}
		}
		return exist;
	}
	
	$("btnAddItem").observe("click", function(){
		if ($F("textItemNo") == ""){
			customShowMessageBox(objCommonMessage.REQUIRED, "E", "textItemNo");
			return;
		}else if ($F("txtPerilCd") == ""){
			customShowMessageBox(objCommonMessage.REQUIRED, "E", "txtPerilCd");
			return;
		}else{
			if (rowExists()){
				showMessageBox("Peril already exists for the particular item.", "I");
				return;
			}else{
				var rowObj = setObjMcEvalItem($("btnAddItem").getAttribute("status"));
				objMcEvalItem.push(rowObj);
				mcEvalItemGrid.addBottomRow(rowObj);
				mcEvalItemGrid.onRemoveRowFocus();
			}
		}
	});
	
	function getMcEvalPlateNoLOV(claimId, itemNo){
		try{
			LOV.show({
				controller: "ClaimsLOVController",
				urlParameters: {action : "getMcEvalPlateNoLOV",
								claimId: claimId,
								itemNo: itemNo,
								page : 1},
				title: "Plate No", //changed by robert "Company Type",
				width: 480,
				height: 400,
				columnModel : [
								{
									id : "plateNo",
									title: "Plate No.",
									width: '80px'
								},{
									id : "tpSw",
									title: "TP Sw",
									width: '20px'
								},
								{
									id : "payeeName",
									title: "Payee Name",
									width: '350'
								},{
									id: "payeeNo",
									width: '0',
									visible: false
									
								},{
									id: "payeeClassCd",
									width: '0',
									visible: false
								}
							],
				draggable: true,
				onSelect : function(row){
					mcMainObj.plateNo = row.plateNo;
					mcMainObj.tpSw = row.tpSw;
					mcMainObj.payeeClassCd = row.payeeClassCd;
					mcMainObj.payeeNo = row.payeeNo;
					$("txtPlateNo").value = row.plateNo;
					$("dspPayee").value = unescapeHTML2(row.payeeName);
				}
			});	
		}catch(e){
			showErrorMessage("getMcEvalPlateNoLOV",e);
		}
	}
	
	//disableSearch("txtPerilCdIcon");
	// checks if the calling form came from item info
	if(mcEvalFromItemInfo == "Y"){
		//changeTag = 0;
		$("claimListingMenu2").hide();
		disableSearch("txtClmSublineCdIcon");
		disableSearch("txtClmIssCdIcon");
		disableSearch("txtClmYyIcon");
		disableSearch("txtClmSeqNoIcon");
	}else{
		//changeTag = 0;
		//mcMainObj = {};
		toggleEditableOtherDetails(false);
		if($F("txtClmSeqNo") == ""){ // prevents null tG after saving, updating or posting
			getMcEvalItemTG(null); //added by robert 
			getMcEvaluationTG(null);
		}
		
		$("exit").observe("click", function (){
			mcMainObj = {};
			mcEvalFromItemInfo = "N";
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
		});
	}
	
	function getEvalPerilLOV(claimId, itemNo){
		try{
			LOV.show({
				controller: "ClaimsLOVController",
				urlParameters: {action : "getEvalPerilLOV",
								claimId: claimId,
								itemNo: itemNo,
								page : 1},
				title: "Peril", //changed by robert"Company Type",
				width: 380,
				height: 400,
				columnModel : [
								{
									id : "perilCd",
									title: "Peril",
									width: '40px'
								},
								{
									id : "dspPerilDesc",
									title: "Peril Description",
									width: '350'
								}
							],
				draggable: true,
				onSelect : function(row){
					//marco - 05.27.2015 - GENQA SR 4484 - comment out
					//mcMainObj.perilCd = row.perilCd;
					//mcMainObj.dspPerilDes = row.dspPerilDesc;
					$("txtPerilCd").value = row.perilCd;
					$("txtPerilName").value = unescapeHTML2(row.dspPerilDesc);
				}
			});	
		}catch(e){
			showErrorMessage("getEvalDepCompanyTypeLOV",e);
		}
	}
</script>