<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%
	response.setHeader("Cache-control","no-cache");
	response.setHeader("Pragma","no-cache");
%>
<div id="modifyCommInvMainDiv" name="modifyCommInvMainDiv" style="margin-top: 1px;">
<!-- 	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="modifyCommInvExit">Exit</a></li>
			</ul>
		</div>
	</div> -->
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<form id="modifyCommInvForm" name="modifyCommInvForm">
		<jsp:include page="/pages/accounting/generalDisbursements/utilities/modifyCommInvoice/subPages/billInformation.jsp"></jsp:include>
		<jsp:include page="/pages/accounting/generalDisbursements/utilities/modifyCommInvoice/subPages/invCommInformation.jsp"></jsp:include>
		<jsp:include page="/pages/accounting/generalDisbursements/utilities/modifyCommInvoice/subPages/perilInformation.jsp"></jsp:include>
		<div class="buttonsDiv" style="margin-top: 10px;" align="center" >
			<input type="button" id="btnCancel" name="btnCancel"  style="width: 115px;" class="button hover"   value="Cancel" />
			<input type="button" id="btnSave" name="btnSave"  style="width: 115px;" class="button hover"   value="Save" />
		</div>
	</form>
</div>
  
<script>
	setModuleId("GIACS408");
	setDocumentTitle("Modify Commission Invoice");
	disableToolbarButton("btnToolbarEnterQuery");
	disableToolbarButton("btnToolbarExecuteQuery");
	//disableToolbarButton("btnToolbarSave");
	disableToolbarButton("btnToolbarPrint");
	//showToolbarButton("btnToolbarSave"); 
	disableButton("btnPrintReport");
	var selectedRecord = null; //koks
	/* Goodluck sa magdedebug :D */
	$("btnToolbarEnterQuery").observe("click", function(){
		if (objACGlobal.objGIACS408.piChangeTag == 1 || objACGlobal.objGIACS408.icChangeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
					function(){
						objACGlobal.objGIACS408.afterSave = showModifyCommInvoicePage;
						saveInvoiceCommission();
					},
					function(){
						showModifyCommInvoicePage();
					},
					""
			);
		}else{
			showModifyCommInvoicePage();
			//formatEnterQueryAppearance();
		}
	});
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		objACGlobal.objGIACS408.validateBillNo();
	});
	
	observeReloadForm("reloadForm", showModifyCommInvoicePage);
	
	$("btnToolbarExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
	});
	
/* 	$("modifyCommInvExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
	}); */
	
	$("btnCancel").observe("click", function(){
		objACGlobal.objGIACS408.objPerilInfoArray = [];
		objACGlobal.objGIACS408.objInvCommArray = [];
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
	});
	
/* 	$("btnPostBill").observe("click", function(){
		if(changeTag == 1){
			showMessageBox("Please save your changes first.", imgMessage.INFO);
			return false;
		}else{
			//postBill
		}
	}); */
	
	function checkUserAccess2(){
		try{
			new Ajax.Request(contextPath+"/GIACAccTransController?action=checkUserAccess2", {
				method: "POST",
				parameters: {
					moduleName: "GIACS408"
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						if(response.responseText == '2'){
							showWaitingMessageBox('You are not allowed to access this module.','E', function(){
								goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
							});
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("checkUserAccess2", e);
		}
	}
	
	function formatEnterQueryAppearance(){
		try{
			disableButton("btnPostBill");
			disableButton("btnCancelBill");
			disableButton("btnAddInvComm");
			disableButton("btnRecomputeCommRt");
			disableButton("btnRecomputeWithTax");
			disableButton("btnSave");
			$("txtPerilCommRate").readOnly = true;
			$("txtSharePercentage").readOnly = true;
			disableSearch("imgSearchIntrmdry");
			disableButton("btnDelInvComm");
		}catch(e){
			showErrorMessage("formatEnterQueryAppearance", e);
		}
	}
	
	function saveInvoiceCommission(){
		try{
			if ($F("hidTotSharePercentage") != 100){
				showMessageBox("Sum of Share Percentage should be equal to 100%.", "I");
				return;
			}
			
			objParameters = new Object();
			//objParameters.setPerilInfo = getModifiedJSONObjects(objACGlobal.objGIACS408.objPerilInfoArray);
			objParameters.setPerilInfo = getAddedAndModifiedJSONObjects(objACGlobal.objGIACS408.objPerilInfoArray);
			//objParameters.setInvComm   = getModifiedJSONObjects(objACGlobal.objGIACS408.objInvCommArray);
			objParameters.setInvComm   = getAddedAndModifiedJSONObjects(objACGlobal.objGIACS408.objInvCommArray);
			objParameters.delInvComm   = getDeletedJSONObjects(objACGlobal.objGIACS408.objInvCommArray);
			
			objParameters.fundCd	   = objACGlobal.objGIACS408.fundCd;
			objParameters.branchCd     = objACGlobal.objGIACS408.branchCd;
			objParameters.issCd        = $F("txtIssCd");
			objParameters.premSeqNo	   = $F("txtPremSeqNo");

			var strObjParameters = JSON.stringify(objParameters);

			new Ajax.Request(contextPath+"/GIACDisbursementUtilitiesController", {
				parameters:{
					action: "saveInvoiceCommission",
					parameters: strObjParameters
				},
				asynchronous: false,
				evalscripts: true,
				onComplete: function(response){
					function reset(){
						if(objACGlobal.objGIACS408.afterSave != null) {
							objACGlobal.objGIACS408.afterSave();
							objACGlobal.objGIACS408.afterSave = null;
						} else {
							if($("modifyCommInvMainDiv") != null){
								objACGlobal.objGIACS408.populateInvCommInfoDtls(null);
								objACGlobal.objGIACS408.populatePerilInfoDtls(null);
								objACGlobal.objGIACS408.enterQueryPerilInfo();
								tbgInvCommInfo._refreshList();
							}	
							objACGlobal.objGIACS408.objPerilInfoArray = [];
							objACGlobal.objGIACS408.objInvCommArray = [];
							enableButton("btnPostBill"); //added by steven 11.14.2014 base on the Business Process design by the SA
						}						
					}
					
					if(checkErrorOnResponse(response) && 
					   checkCustomErrorOnResponse(response, showModifyCommInvoicePage)) { //nieko 07272016 KB 3753, SR 22780
						var res = response.responseText.replace(/\\/g, '\\\\');
						if (res == "SUCCESS"){
							showWaitingMessageBox(objCommonMessage.SUCCESS, "S", reset);
							changeTag = 0;
							changeTagFunc = "";
							objACGlobal.objGIACS408.piChangeTag = 0;
							objACGlobal.objGIACS408.icChangeTag = 0;
							//tbgPerilInfo.refresh();
							//tbgInvCommInfo.refresh();
							//objACGlobal.objGIACS408.validateBillNo(); //reload
						}else{
							showWaitingMessageBox(response.responseText, "E", reset);
						}
					}else{
						showWaitingMessageBox(response.responseText, "E", reset);
					}
				}
			});
		}catch(e){
			showErrorMessage("saveInvoiceCommission", e);
		}
	}
	objACGlobal.objGIACS408.saveInvoiceCommission = saveInvoiceCommission;
	
	observeSaveForm("btnSave", saveInvoiceCommission);
	observeCancelForm("btnToolbarExit", saveInvoiceCommission, function(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
	});
	observeCancelForm("btnCancel", saveInvoiceCommission, function(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
	});
	
	formatEnterQueryAppearance();
	checkUserAccess2();
	initializeAll();
	initializeAllMoneyFields();
	initializeAccordion();
</script>