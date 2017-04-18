<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="batchCsrMainDiv" name="batchCsrMainDiv">
	<div id="claimListingMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="batchCsrInfoExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Batch Claim Settlement Request</label>
	   		<span class="refreshers" style="margin-top: 0;">
	   			<label name="gro" style="margin-left: 5px;">Hide</label>
		   		<label id="reloadForm" name="reloadForm">Reload Form</label>
	   		</span>
	   	</div>
	</div>
	<div id="batchCsrHeaderDiv" name="batchCsrHeaderDiv" class="sectionDiv">
		<input type="hidden" id="insertTag" name="insertTag" value=${insertTag} />
		<jsp:include page="/pages/claims/batchCsr/batchHeader.jsp"></jsp:include>
		<jsp:include page="/pages/claims/batchCsr/batchCsrDetail.jsp"></jsp:include>
	</div>
</div>

<script type="text/javascript">
	setModuleId("GICLS043");
	setDocumentTitle("Batch Claim Settlement Request");
	initializeAll();
	initializeAllMoneyFields();
	initializeAccordion();
	clearObjectValues(objBatchCsr);
	objGICLAdviceList = [];
	changeTag = 0;
	
	if(nvl($F("insertTag"), 0) == 0){
		populateBatchCsrForm(null);
		$("btnSave").hide();
		disableButton("btnGenerateBatch");
		disableButton("btnForeignCurr");
		disableButton("btnCancelBatch");
		disableButton("btnApproveBatch");
		disableButton("btnPrintBCSR");
		objBatchCsr.generateTagSw = 0;
	}else{
		$("btnGenerateBatch").hide();
		objBatchCsr = JSON.parse('${giclBatchCsrJSON}');
		objBatchCsr.generateTagSw = 0;
		populateBatchCsrForm(objBatchCsr);
		setBatchCsrButton(objBatchCsr.batchFlag);
	}
	
	$("payeeClassSpan").addClassName("required");
	$("payeeSpan").addClassName("required");
	$("particularsSpan").addClassName("required");
	showBatchCsrGiclAdviceListing($F("insertTag"), nvl(objBatchCsr.batchCsrId, 0));
	
	$("btnParticulars").observe("click", function(){
		$("particulars").setAttribute("lastValidValue", $F("particulars")); // added by j.diago 04.14.2014
		
		//showEditor("particulars", 1000);  //adjusted from 2000 to 1000 - Halley 11.06.13 removed by j.diago 04.14.2014
		showOverlayEditor("particulars", 1000, $("particulars").hasAttribute("readonly")); // added by j.diago 04.14.2014
	});
	
	$("btnPayee").observe("click", function(){
		if(nvl($F("payeeClass"), "") == ""){
			showMessageBox("Please enter payee class first.");
		}else{
			getGiisPayeesList($("payeeClass").getAttribute("payeeClassCd"));			
		}
	});
	
	$("btnPayeeClass").observe("click", function(){
		showClmPayeeClassLov2();
	});
		
	$("payeeClass").observe("focus", function(){
		enableGenerateBatchBtn();
	});
	
	$("payee").observe("focus", function(){
		enableGenerateBatchBtn();
	});
	
	$("particulars").observe("focus", function(){
		enableGenerateBatchBtn();
		
		if($F("particulars").trim() != $("particulars").readAttribute("lastValidValue")) { // added by j.diago 04.14.2014
			changeTag = 1;
		}
	});
	
	$("particulars").observe("blur", function(){
		enableGenerateBatchBtn();
	});
	
	$("btnGenerateBatch").observe("click", function(){
		validateBeforeGenerateBatch();
	});
	
	$("btnPrintBCSR").observe("click", function(){
		overlayGenericPrintDialog = Overlay.show(contextPath+"/GICLBatchCsrController", {
			urlContent : true,
			urlParameters: {action : "showPrintCsrDialog",
				            batchCsrId: nvl(objBatchCsr.batchCsrId, 0),
				            issCd: objBatchCsr.issueCode},
		    title: "Claim Settlement Request",
		    height: 160,
		    width: 450,
		    draggable: true
		});
	});
	
	$("btnCancelBatch").observe("click", function(){
		showConfirmBox("Confirmation", "This batch number will be tag as deleted. Do you really want to cancel this batch number?", 
				"Yes", "No", cancelBatch, "");
	});
	
	$("btnApproveBatch").observe("click", function(){
		if(checkBatchCsrReqFields()){
			showMessageBox("Field must be entered.", "I");
		}else{
			showConfirmBox("Confirmation", "Do you really want to approve this batch number?", "Yes", "No",
					       startBatchCsrApproval, "");
		}
	});
	
	$("btnForeignCurr").observe("click", function(){
		showForeignCurrencyCanvas();
	});
	
	$("btnAcctngEntries").observe("click", function(){
		if(nvl($("hidCurrAdviceId").value, 0)== 0 || nvl($("hidCurrClaimId").value, 0)== 0){
			showMessageBox("Please select an advice.");
		}else{
			showBatchCsrAcctEntries();
			adviceTableGrid.keys.removeFocus(adviceTableGrid.keys._nCurrentFocus, true);
			adviceTableGrid.keys.releaseKeys();
		}
	});
	
	$("btnSave").observe("click", function(){
		if(checkBatchCsrReqFields()){
			showMessageBox("Field must be entered.", "I");
			return false;
		}else if(changeTag == 0){
			showMessageBox(objCommonMessage.NO_CHANGES, imgMessage.INFO);
			return false;
		}else{
			saveBatchCsr();
		}
	});
		
	function populateBatchCsrForm(obj){
		$("batchNumber").value 	= obj == null ? "" : obj.batchCsrNo;
		$("payeeClass").value 	= obj == null ? "" : unescapeHTML2(obj.payeeClassCode + " - " + obj.payeeClassDesc);
		$("payee").value 		= obj == null ? "" : unescapeHTML2(obj.payeeCode +" - "+obj.payeeName);
		$("particulars").value 	= obj == null ? "" : unescapeHTML2(obj.particulars);
		$("paidAmount").value 	= obj == null ? "" : formatCurrency(obj.paidAmount);
		$("netAmount").value 	= obj == null ? "" : formatCurrency(obj.netAmount);
		$("adviceAmount").value = obj == null ? "" : formatCurrency(obj.adviceAmount);
		$("currency").value 	= obj == null ? "" : obj.currencyDesc;
		$("convertRate").value 	= obj == null ? "" : formatToNineDecimal(obj.convertRate);
		$("userId").value 		= obj == null ? "" : obj.userId;
		$("lastUpdate").value 	= obj == null ? "" : obj.csrLastUpdate;
		$("payee").setAttribute("payeeNo", obj == null ? "" : obj.payeeCode);
		$("payeeClass").setAttribute("payeeClassCd", obj == null ? "" : obj.payeeClassCode);
	}
	
	function enableGenerateBatchBtn(){
		if(!checkBatchCsrReqFields() && nvl(objBatchCsr.generateTagSw, 0) == 1){
			enableButton("btnGenerateBatch");
		}else{
			disableButton("btnGenerateBatch");			
		}
	}
	
	function validateBeforeGenerateBatch(){
		if(checkBatchCsrReqFields()){
			showMessageBox("Field must be entered.", "I");
		}else if(nvl(objBatchCsr.generateTagSw, 0) == 0){
			showMessageBox("No record has been selected.", "I");
		}else{
			showConfirmBox("Confirmation", "Do you really want to continue batch number generation?", "Yes", "No",
					        generateBatch, "");
		}
	}
	
	function setBatchCsrButton(batchFlag){
		if(batchFlag == "A"){
			disableButton("btnGenerateBatch");
			disableButton("btnCancelBatch");
			disableButton("btnApproveBatch");
			enableButton("btnPrintBCSR");
			$("btnPrintBCSR").value = "Final BSCR";
		}else if(batchFlag == "D"){
			disableButton("btnGenerateBatch");
			disableButton("btnCancelBatch");
			disableButton("btnApproveBatch");
			enableButton("btnPrintBCSR");
			$("btnPrintBCSR").value = "Final BSCR";
		}else{
			disableButton("btnGenerateBatch");
			enableButton("btnCancelBatch");
			enableButton("btnApproveBatch");
			enableButton("btnPrintBCSR");
			$("btnPrintBCSR").value = "Print BSCR";
		}
	}
	
	function generateBatch(){
		objBatchCsr.payeeClassCode = $("payeeClass").getAttribute("payeeClassCd");
		objBatchCsr.payeeCode = $("payee").getAttribute("payeeNo");
		objBatchCsr.batchFlag = "N";
		objBatchCsr.particulars = escapeHTML2($F("particulars"));
		
		var objParameters = new Object();
		objParameters.batchCsr = prepareJsonAsParameter(objBatchCsr);
		objParameters.adviceList = prepareJsonAsParameter(objGICLAdviceList);
		
		new Ajax.Request(contextPath + "/GICLBatchCsrController", {
			parameters:{
				action: "generateBatchNo",
				parameters: JSON.stringify(objParameters)
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: showNotice("Generating batch number..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)) {
					showWaitingMessageBox(objCommonMessage.SUCCESS, "S", function(){
						showBatchCsrPage(1, response.responseText);						
					});
				}else{
					showMessageBox(response.responseText, "E");
				}
			}
		});
	}
	
	function cancelBatch(){
		new Ajax.Request(contextPath + "/GICLBatchCsrController", {
			parameters:{
				action: "cancelBatchCsr",
				batchCsrId: objBatchCsr.batchCsrId,
				moduleId: "GICLS043"
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: showNotice("Cancelling batch CSR..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)) {
					if(response.responseText == "SUCCESS"){
						showWaitingMessageBox("This batch number has already been tagged as deleted.", "I", function(){
							goBackToBatchCsrListing();						
						});
					}
				}else{
					showMessageBox(response.responseText, "E");
				}
			}
		});
	}
	
	function saveBatchCsr(){
		objBatchCsr.payeeClassCode = $("payeeClass").getAttribute("payeeClassCd");
		objBatchCsr.payeeCode = $("payee").getAttribute("payeeNo");
		objBatchCsr.particulars = escapeHTML2($F("particulars"));
		
		var objParameters = new Object();
		objParameters.batchCsr = prepareJsonAsParameter(objBatchCsr);
		
		new Ajax.Request(contextPath + "/GICLBatchCsrController", {
			parameters:{
				action: "saveBatchCsr",
				parameters: JSON.stringify(objParameters)
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: showNotice("Saving Batch CSR..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)) {
					showMessageBox(objCommonMessage.SUCCESS, "S");
					changeTag = 0;
				}else{
					showMessageBox(response.responseText, "E");
				}
			}
		});
	}
	
	function onExitWithChanges(){
		if(nvl($F("insertTag"), 0) == 0){
			validateBeforeGenerateBatch();
		}else{
			saveBatchCsr();
		}
	}
	
	observeCancelForm("batchCsrInfoExit", onExitWithChanges, goBackToBatchCsrListing);
	observeCancelForm("btnReturn", onExitWithChanges, goBackToBatchCsrListing);
	observeReloadForm("reloadForm", function(){showBatchCsrPage(nvl($F("insertTag"), 0), objBatchCsr.batchCsrId);});
	initializeChangeTagBehavior(onExitWithChanges);
</script>