<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="acknowledgementReceiptMainDiv" style="font-size: 11px;">
	<!-- HIDDEN PARAMETERS GOES HERE // subject to transfer to object-->
	<input type="hidden" id="globalFundCd" 	name="globalFundCd" value="${branchDetails.gfunFundCd}" />
	<input type="hidden" id="globalBranchCd" name="globalBranchCd" value="${branchDetails.branchCd}" />
	<input type="hidden" id="checkFlag"		name="checkFlag"	value="" />
	<input type="hidden" id="hidFCurrAmount"	name="hidFCurrAmount"  value="" />
	<input type="hidden" id="hidForeignCurrencyAmt" name="hidForeignCurrencyAmt" value="" />
	<input type="hidden" id="deleteSw"	name="deleteSw" value="N" />
	<input type="hidden" id="cashierCd"	name="cashierCd" value="${cashierCd}" />
	<input type="hidden" id="defaultCashierCd" name="defaultCashierCd" value="" />	
	<!-- END OF HIDDEN FIELDS -->
	<div id="acknowledgementReceiptHeaderDiv" name="acknowledgementReceiptHeaderDiv">
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
		   		<label>Acknowledgment Receipt</label>
		   		<span class="refreshers" style="margin-top: 0;">		   			
		   			<label id="showAckReceipt" name="gro" style="margin-left: 5px;">Hide</label>
		   			<label id="reloadForm" name="reloadForm">Reload Form</label>
		   		</span>
		   	</div>
		</div>	
		<div id="ackReceiptHeaderDiv">
			<div class="sectionDiv" id="headerDtlsDiv" style="padding-top: 15px; width: 100%; float:left; padding-bottom: 15px;">
				<label style="margin-left: 50px; float: left; margin-top: 5px;">Company</label><input type="text" id="companyName" name="companyName" style="float: left; margin-left: 5px; width: 310px;" readonly="readonly" value="${branchDetails.gfunFundCd} - ${branchDetails.fundDesc}" />
				<label style="float: left; margin-top: 5px; margin-left: 100px;">Branch</label><input type="text" id="branchName" name="branchName" style="float: left; margin-left: 5px; width: 310px;" readonly="readonly" value="${branchDetails.branchCd} - ${branchDetails.branchName}" />
			</div>
			<jsp:include page="/pages/accounting/PDCPayment/subPages/acknowledgmentReceiptHdr.jsp"></jsp:include>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Post-Dated Check Details</label>
	   		<span class="refreshers" style="margin-top: 0;">
	   			<label id="showPostDatedCheck" name="gro" style="margin-left: 5px;">Hide</label>
	   		</span>
	   	</div>
	</div>
	<div id="pdcDtlsMainDiv">
		<div id="postDatedCheckDtlsDiv" name="postDatedCheckDtlsDiv" class="sectionDiv">
			<div id="postDatedChecksTableGridDiv">
				<jsp:include page="/pages/accounting/PDCPayment/subPages/postDatedChecks.jsp"></jsp:include>			
			</div>
		</div>
		<div id="pdcDtlsParticularsDiv">
			<jsp:include page="/pages/accounting/PDCPayment/subPages/particulars.jsp"></jsp:include>
		</div>
	</div>	
	<jsp:include page="/pages/accounting/PDCPayment/subPages/postDatedCheckDetails.jsp"></jsp:include>
	<div class="buttonsDiv">
		<input type="button" class="button" value="Cancel" id="btnCancel" name="btnCancel"  />
		<input type="button" class="button" value="Save" id="btnSave" name="btnSave" />
	</div>
</div>

<script type="text/javascript">
	var acknowledgmentReceiptsObj = new Object();
	objGIACApdcPayt.defaultCurrency = "${defaultCurrency}"; 
	var giacApdcPaytDtlObj = new Array();
	
	var deletedApdcId;
	var pdcPremUpdateObj = new Object();
	
	changeTag = 0;
	objGIACApdcPayt.pdcPremChangeTag = 0;
	
	setModuleId("GIACS090");
	setDocumentTitle("Acknowledgment Receipt");
	initializeAccordion();
	setDefaultAcknowledgmentReceiptDtls();
	getGIACS090variables();
	initializeAll();
	
	function setDefaultAcknowledgmentReceiptDtls(){
		$("overlayTitleDiv").hide();

		/* $("defaultCashierCd").value = getCashierCd();
		if ($F("defaultCashierCd") == ""){
			showMessageBox('You are not authorized to create records for this Company/Branch.', imgMessage.ERROR);
			return false;
		} */
		
		repairAccordions();
	}

	function repairAccordions(){
		$("showAckReceipt").observe("click", function (){
			var infoDiv = $("ackReceiptHeaderDiv");
			Effect.toggle(infoDiv, "blind", {duration: .3});
		});		
	}

	$("btnSave").observe("click", function (){
		initializeAcknowledgmentReceiptSaving();
	});

	function initializeAcknowledgmentReceiptSaving(){
		if(changeTag == 1){
			var recCount = postDatedCheckDetailsTableGrid.geniisysRows.filter(function(o){ return nvl(o.recordStatus, 0) != -1;}).length;
			if ($F("hdrDtlsPayor") == ""){
				customShowMessageBox('Payor must be entered.', imgMessage.ERROR, "hdrDtlsPayor");
				return false;
			} /*else if(objCurrGIACApdcPaytDtl != null  //John Dolon; 7.13.2015; SR#4487 - Baseline Testing: Total Collection Amount vs Check Amount 	
						&& (recCount > 0 && objGIACApdcPayt.pdcPremChangeTag == 1) 
						){//&& parseFloat($F("txtGrossAmt").replace(/,/g, "")) != parseFloat($F("txtTotalCollectionAmt").replace(/,/g, ""))){ 
				showWaitingMessageBox("Total Collection Amount must be equal with Check Amount.", imgMessage.INFO, function(){
					$("txtCollectionAmt").select();
					$("txtCollectionAmt").focus();
				});
				return false;
			}*/ else {
				fetchAcknowledgmentReceiptDtls();
			}
		} else {
			showMessageBox(objCommonMessage.NO_CHANGES, imgMessage.INFO);
		}
	}

	function getCashierCd(){
		var cashierCd = "";
		
		new Ajax.Request(contextPath+"/GIACAcknowledgmentReceiptsController?action=getCashierCd",{
			method: "POST",
			parameters: {
				fundCd: $F("globalFundCd"),
				branchCd: $F("globalBranchCd")
			},
			evalScripts: true,
			asynchronous: false,
			onComplete: function (response){
				if (checkErrorOnResponse(response)){
					cashierCd = response.responseText;
				}
			}
		});

		return cashierCd;
	}

	function generateApdcId(){
		var apdcId = 0;

		new Ajax.Request(contextPath+"/GIACAcknowledgmentReceiptsController?action=generateApdcId",{
			method: "POST",
			evalScripts: true,
			asynchronous: false,
			onComplete: function (response){
				if (checkErrorOnResponse(response)){
					apdcId = response.responseText;
				}
			}
		});

		return apdcId;
	}

	function fillApdcPaytObj(){
		if (objGIACApdcPayt == null || objGIACApdcPayt.apdcId == null || objGIACApdcPayt.apdcId == 0){
			objGIACApdcPayt = new Object();
			objGIACApdcPayt.apdcId = generateApdcId();
		}
		objGIACApdcPayt.fundCd 		= $F("globalFundCd");
		objGIACApdcPayt.branchCd	= $F("globalBranchCd");
		objGIACApdcPayt.apdcDate	= $F("apdcDate");
		objGIACApdcPayt.apdcPref	= $F("apdcNo1");
		objGIACApdcPayt.apdcNo		= $F("apdcNoText");
		if ($F("cashierCd") == ""){
			objGIACApdcPayt.cashierCd = $F("defaultCashierCd");
		} else {
			objGIACApdcPayt.cashierCd = $F("cashierCd");
		}
		objGIACApdcPayt.payor		= $F("hdrDtlsPayor");
		objGIACApdcPayt.apdcFlag	= $F("statusCd");
		objGIACApdcPayt.particulars = $F("payorParticulars");
		objGIACApdcPayt.refApdcNo	= $F("refApdcNo");
		objGIACApdcPayt.address1	= $F("txtApdcAddress1"); //marco - 04.15.2013 - changed from txtAddress1, 2 and 3
		objGIACApdcPayt.address2	= $F("txtApdcAddress2");
		objGIACApdcPayt.address3	= $F("txtApdcAddress3");
		
		if(objCurrGIACApdcPaytDtl != null){ //added by carloR SR-5706 10.10.2016 -start
			objCurrGIACApdcPaytDtl.checkStatus = "With Details"; 
			objCurrGIACApdcPaytDtl.checkFlag = "W";		
			postDatedChecksTableGrid.updateRowAt(objCurrGIACApdcPaytDtl, objCurrGIACApdcPaytDtl.rowIndex); 
		}//end

		return objGIACApdcPayt;
	}
	
	function fetchAcknowledgmentReceiptDtls(){
		try {
			acknowledgmentReceiptsObj.apdcPaytObj = fillApdcPaytObj();
			/* if (!postDatedCheckDetailsTableGrid.preCommit()){
				return false;
			} else { */
			var modifiedRows = postDatedChecksTableGrid.getModifiedRows();
			
			var fetchedModifiedPaytDtl = modifiedRows;
			var fetchedApdcPaytDtl = postDatedChecksTableGrid.getNewRowsAdded().concat(fetchedModifiedPaytDtl);
			
			acknowledgmentReceiptsObj.setApdcPaytDtlObj = fetchedApdcPaytDtl;
			acknowledgmentReceiptsObj.delApdcPaytDtlObj = postDatedChecksTableGrid.getDeletedRows();
			//}
			
			//giacPdcPremCollns.addedRows = giacPdcPremCollns.addedRows || [];
			//giacPdcPremCollns.updatedRows = giacPdcPremCollns.updatedRows || [];
			//acknowledgmentReceiptsObj.setPremCollnObj = giacPdcPremCollns.addedRows.concat(giacPdcPremCollns.updatedRows);
			acknowledgmentReceiptsObj.setPremCollnObj = getAddedAndModifiedJSONObjects(postDatedCheckDetailsTableGrid.geniisysRows);
			//acknowledgmentReceiptsObj.delPremCollnObj = giacPdcPremCollns.deletedRows || [];
			acknowledgmentReceiptsObj.delPremCollnObj = getDeletedJSONObjects(postDatedCheckDetailsTableGrid.geniisysRows);
			acknowledgmentReceiptsObj.pdcReplaceObjectList = pdcReplaceObjectList;
	
			saveAcknowledgmentReceipt();
		} catch (e){
			showErrorMessage("fetchAcknowledgmentReceiptDtls", e);
		}
	}	
	
	objGIACApdcPayt.clearAllTableGridFocus = function (){
		postDatedChecksTableGrid.keys.removeFocus(postDatedChecksTableGrid.keys._nCurrentFocus, true);
		postDatedChecksTableGrid.keys.releaseKeys();
		postDatedCheckDetailsTableGrid.keys.removeFocus(postDatedCheckDetailsTableGrid.keys._nCurrentFocus, true);
		postDatedCheckDetailsTableGrid.keys.releaseKeys();
	};
	objGIACApdcPayt.initializeAcknowledgmentReceiptSaving = initializeAcknowledgmentReceiptSaving;
	function saveAcknowledgmentReceipt(){
		new Ajax.Request(contextPath+"/GIACAcknowledgmentReceiptsController?action=saveGIACApdcPayt",{
			method: "POST",
			parameters: {
				parameters: JSON.stringify(acknowledgmentReceiptsObj)
			},
			evalScripts: true,
			asynchronous: false,
			onCreate: function (){
				showNotice("Saving Acknowledgment Receipt. Please wait...");
			},
			onSuccess: function (response){
				hideNotice("");
				if (checkErrorOnResponse(response)){
					if (response.responseText == "SUCCESS"){
						acknowledgmentReceiptsObj = null;
						//giacPdcPremCollns.addedRows = new Array();
						//giacPdcPremCollns.deletedRows = new Array();
						//giacPdcPremCollns.updatedRows = new Array();					
						giacPdcPremCollns.rows = new Array();
						
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
							showAcknowledgementReceipt($F("globalBranchCd"), "${moduleId}");
						});
						
						changeTag = 0;
					}
				}
			}
		});	
	}

	$$("div#miscAmtsDtlsDiv input[type='text']").invoke('setAttribute', 'disabled', 'disabled');
	$$("div#foreignCurrDtlsDiv input[type='text']").invoke('setAttribute', 'disabled', 'disabled');
	fireEvent($("showDetails"), "click");		
	
	// andrew - 10.06.2011
	observeReloadForm("reloadForm", 
		function(){
			objGIACApdcPayt.clearAllTableGridFocus();
			showAcknowledgementReceipt($F("globalBranchCd"), "${moduleId}");
		}
	);
	
	$("acExit").stopObserving("click");
	$("acExit").observe("click", function(){
		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", initializeAcknowledgmentReceiptSaving,
				function(){
					showAcknowledgementReceiptListing($F("globalBranchCd"), "${moduleId}");
				}, "");
		} else {
			showAcknowledgementReceiptListing($F("globalBranchCd"), "${moduleId}");
		}
		$("acExit").stopObserving("click");
		$("acExit").observe("click", function(){
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		});
	});
	
	// added by jdiago 03.27.2014 
	$("btnCancel").observe("click", function(){
		fireEvent($("acExit"), "click");
	});
	
	function disableInputs() {
		$$("div#acknowledgementReceiptMainDiv input[type='text'], div#acknowledgementReceiptMainDiv textarea, div#acknowledgementReceiptMainDiv select").each(
				function(input) {
					input.setAttribute("readonly", "readonly");
				});
	}
	
	function disableAPDC(){
		disableButton("btnPdcDelete");
		disableButton("btnPdcAdd");
		//disableButton("btnPdcReplace");
		disableButton("btnPdcDtlDelete");
		disableButton("btnPdcDtlAdd");
		disableButton("btnUpdate");
		disableButton("btnSpecUpdate");
						
		$$("div#otherHeaderDtlsDiv input[type='text'], div#otherHeaderDtlsDiv textarea,div#otherHeaderDtlsDiv select,div#otherHeaderDtlsDiv img").each(function (input){					
			if(input instanceof HTMLSelectElement){
				input.disabled = true;
			} else if (input instanceof HTMLImageElement){
				if(input.src.include("search")){
					disableSearch(input.id);
				} else if(input.src.include("calendar")){
					disableDate(input.id);
				}
			} else {
				input.writeAttribute("readonly", "readonly");
			}
		});
		
		$$("div#pdcDiv input[type='text'], div#pdcDiv textarea,div#pdcDiv select,div#pdcDiv img").each(function (input){					
			if(input instanceof HTMLSelectElement){
				input.disabled = true;
			} else if (input instanceof HTMLImageElement){
				if(input.src.include("search")){
					disableSearch(input.id);
				} else if(input.src.include("calendar")){
					disableDate(input.id);
				}
			} else {
				input.writeAttribute("readonly", "readonly");
			}
		});
		
		$$("div#pdcDtlsParticularsDiv input[type='text'], div#pdcDtlsParticularsDiv textarea, div#pdcDtlsParticularsDiv img").each(function (input){
			if(input instanceof HTMLSelectElement){
				input.disabled = true;
			} else if (input instanceof HTMLImageElement){
				if(input.src.include("search")){
					disableSearch(input.id);
				} else if(input.src.include("calendar")){
					disableDate(input.id);
				}
			} else {
				input.writeAttribute("readonly", "readonly");
			}
		});
		
		$$("div#premCollnFormDiv input[type='text'],div#premCollnFormDiv textarea,div#premCollnFormDiv select,div#premCollnFormDiv img").each(function (input){					
			if(input instanceof HTMLSelectElement){
				input.disabled = true;
			} else if (input instanceof HTMLImageElement){
				if(input.src.include("search")){
					disableSearch(input.id);
				} else if(input.src.include("calendar")){
					disableDate(input.id);
				}
			} else {
				input.writeAttribute("readonly", "readonly");
			}
		});		
	}
	
	if (objGIACApdcPayt != null && objGIACApdcPayt.apdcFlag == 'C') {
		//disableInputs();
		disableButton("btnPrintApdc");
		enableButton("btnCancelApdc");
		disableAPDC();
	} else if(objGIACApdcPayt != null && objGIACApdcPayt.apdcFlag == 'P'){
		disableAPDC();
	} else {
		enableButton("btnPrintApdc");
		enableButton("btnCancelApdc");
		enableButton("btnPdcAdd");
		enableButton("btnPdcDtlAdd");
		enableButton("btnUpdate");
		enableButton("btnSpecUpdate");
	}

	if(objGIACApdcPayt != null && objGIACApdcPayt.apdcId != null){
		disableDate("apdcDateCal");
	}
	
	initializeChangeTagBehavior(initializeAcknowledgmentReceiptSaving);
	
	//Apollo 5.15.2014
	if(objGIACApdcPayt.apdcId == null) {
		disableButton("btnPrintApdc");
		disableButton("btnCancelApdc");
	}
		
</script>