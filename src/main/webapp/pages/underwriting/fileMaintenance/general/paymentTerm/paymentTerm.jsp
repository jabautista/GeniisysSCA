<!-- 
Remarks : Payment Term
Date : 10.16.2012
Developer : Kenneth
-->

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="paymentTermMainDiv" name="paymentTermMainDiv" style="float: left; width: 100%;">
	<div id="paymentTermTableGridDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="paymentTermExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>

	<div id="paymentTermDiv">
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
				<label>Payment Term Maintenance</label>
				<span class="refreshers" style="margin-top: 0;">
					<!-- <label name="gro" style="margin-left: 5px;">Hide</label> -->
					<label id="reloadForm" name="reloadForm">Reload Form</label>
				</span>
			</div>
		</div>

		<!-- edited by gab 11.03.2015 -->
		<!-- <div class="sectionDiv" id="paymentTermSectionDiv" style="height: 575px;"> -->
		<div class="sectionDiv" id="paymentTermSectionDiv" style="height: 600px;">

			<div id="paymentTermTableDiv" style="height: 250px; padding: 10px; padding-left: 30px">
				<div id="paymentTermTable" style="height: 250px"></div>
				<div id="paymentTermInfoSectionDiv" style="width: 100%;">
					<jsp:include page="/pages/underwriting/fileMaintenance/general/paymentTerm/subPages/paymentTermInfo.jsp"></jsp:include>
				</div>
			</div>

		</div>
	</div>
	
	<div class="buttonsDiv" style="float:left; width: 100%;">
		<input type="button" class="button" id="btnCancel" name="btnCancel" value="Cancel"/>
		<input type="button" class="button" id="btnSave" name="btnSave" value="Save"/>
	</div>
</div>

<script type="text/javascript">
	setModuleId("GIISS018");
	setDocumentTitle("Payment Term Maintenance");
	selectedIndex = -1;
	initializeAll();
	initializeAccordion();
	makeInputFieldUpperCase();
	changeTag = 0;

	var delObj;
	var rowObj;
	var deleteStatus = false;
	var addStatus = false;
	var payTermDescStatus = false;
	var valuesCorrespond = false;
	var changeCounter = 0;
	var objPayTermMaintain = null;
	var exitPaymentTerm = null;
	changed = false;
	
	try {

		var row = 0;
		var objPayTermMain = [];
		var objPayTerm = new Object();
		objPayTerm.objPayTermListing = JSON.parse('${payTermMaintenance}'.replace(/\\/g, '\\\\'));
		objPayTerm.objPaymentTermMaintenance = objPayTerm.objPayTermListing.rows || [];

		var paymentTermTG = {
			url : contextPath + "/GIISPayTermController?action=getPaymentTerm",
			options : {
				width : '860px',
				height : '306px',
				onCellFocus : function(element, value, x, y, id) {
					row = y;
					objPayTermMaintain = payTermMaintenanceTableGrid.geniisysRows[y];
					payTermMaintenanceTableGrid.keys.releaseKeys();
					populatePaymentTermInfo(objPayTermMaintain);
					$("btnAdd").value = "Update";
					enableButton("btnDelete");
					disableEdit();
					$("txtLastValidNoOfPayts").value = $F("txtNoOfPayt");
					$("txtLastValidNoOfDays").value = $F("txtNoOfDays");
					$("txtLastValidPaytTermsDesc").value = $F("txtPaytTermsDesc");
					$("txtLastValidPaytDays").value = $F("txtPaytDays"); //added by gab 11.03.2015
					changed = false;
				},
				onRemoveRowFocus : function() {
					payTermMaintenanceTableGrid.keys.releaseKeys();
					clearDetails();
					formatAppearance();
					removeDisable();
					clearLastValidValueDetails();
					changed = false;
				},
				beforeSort : function() {
					if (changeTag == 1 ) {
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}
				},
				onSort : function() {
					formatAppearance();
					clearDetails();
					removeDisable();
					payTermMaintenanceTableGrid.keys.releaseKeys();
					clearLastValidValueDetails();
					changed = false;
				},
				onRefresh : function() {
					formatAppearance();
					removeDisable();
					payTermMaintenanceTableGrid.refresh();
					clearLastValidValueDetails();
					changed = false;
				},
				toolbar : {
					elements : [ MyTableGrid.REFRESH_BTN,MyTableGrid.FILTER_BTN ],
					onFilter : function() {
						formatAppearance();
						clearDetails();
						removeDisable();
						payTermMaintenanceTableGrid.keys.releaseKeys();
						clearLastValidValueDetails();
						changed = false;
					} 
				},
				prePager : function(){
					if(changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
						return false;
					}
					formatAppearance();
					clearDetails();
					removeDisable();
					payTermMaintenanceTableGrid.keys.releaseKeys();
					clearLastValidValueDetails();
					return true;
					changed = false;
				},
				checkChanges: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailValidation: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetail: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailSaveFunc: function() {
					return (changeTag == 1 ? true : false);
				},
				masterDetailNoFunc: function(){
					return (changeTag == 1 ? true : false);
				}
			},
			columnModel : [ {
				id : 'recordStatus',
				width : '0',
				visible : false,
				editor : 'checkbox'
			}, {
				id : 'divCtrId',
				width : '0',
				visible : false
			}, {
				id : 'paytTerms',
				title : 'Payment Term',
				titleAlign: 'left',
				width : '90px',
				visible : true,
				filterOption : true
			}, {
				id : 'paytTermsDesc',
				title : 'Description',
				titleAlign: 'left',
				/* width : '200px', */ //edited by gab 11.03.2015
				width : '140px',
				visible : true,
				filterOption : true
			}, {
				id : 'noOfPayt',
				title : 'No. of Payments',
				titleAlign: 'right',
				align : 'right',
				width : '120px',
				type : 'number',
				visible : true,
				filterOption : true,
				filterOptionType: 'integerNoNegative'
			}, {
				id : 'noOfDays',
				title : 'No. of Days',
				titleAlign: 'right',
				align : 'right',
				width : '105px',
				type : 'number',
				visible : true,
				filterOption : true,
				filterOptionType: 'integerNoNegative'
			}, {
				//added by gab 11.03.2015
				id : 'noPaytDays',
				title : 'No. of Payment Days',
				titleAlign: 'right',
				align : 'right',
				width : '120px',
				type : 'number',
				visible : true,
				filterOption : true,
				filterOptionType: 'integerNoNegative'
			},{
				id : 'remarks',
				title : 'Remarks',
				titleAlign: 'left',
				/* width : '245px', */ //edited by gab 11.03.2015
				width : '203px',
				align : 'left',
				visible : true,
				filterOption : true
			}, {
				id : 'onInceptTag',
				title : 'O',
				altTitle : 'On Incept Tag',
				width : '30px',
				align : 'center',
				titleAlign : 'center',
				defaultValue : false,
				otherValue : false,
				filterOption : true,
				filterOptionType: 'checkbox',
				editor : new MyTableGrid.CellCheckbox({getValueOf : function(value) {
						if (value) {
							return "Y";
						} else {
							return "N";
						}
					}
				})
			}, {
				id : 'annualSw',
				title : 'Y',
				altTitle : 'Yearly?',
				width : '30px',
				align : 'center',
				titleAlign : 'center',
				defaultValue : false,
				otherValue : false,
				filterOption : true,
				filterOptionType: 'checkbox',
				editor : new MyTableGrid.CellCheckbox({getValueOf : function(value) {
						if (value) {
							return "Y";
						} else {
							return "N";
						}
					}
				})
			}, ],
			rows : objPayTerm.objPaymentTermMaintenance
		};
		payTermMaintenanceTableGrid = new MyTableGrid(paymentTermTG);
		payTermMaintenanceTableGrid.pager = objPayTerm.objPayTermListing;
		payTermMaintenanceTableGrid.render('paymentTermTable');
		payTermMaintenanceTableGrid.afterRender = function() {
			objPayTermMain = payTermMaintenanceTableGrid.geniisysRows;
			changeTag = 0;
		};
	} catch (e) {
		showErrorMessage("Payment Term Maintenance Table Grid", e);
	}
	
	function populatePaymentTermInfo(obj) {
		try {
			$("txtPaytTerms").value = obj == null ? "" : unescapeHTML2(obj.paytTerms);
			$("txtPaytTermsDesc").value = obj == null ? "" : unescapeHTML2(obj.paytTermsDesc);
			$("txtPreviousPaytTermsDesc").value = obj == null ? "" : unescapeHTML2(obj.paytTermsDesc);
			$("txtNoOfPayt").value = obj == null ? "" : obj.noOfPayt;
			$("txtNoOfDays").value = obj == null ? "" : obj.noOfDays;
			$("txtPaytDays").value = obj == null ? "" : obj.noPaytDays; //added by gab 11.03.2015
			$("txtRemarks").value = obj == null ? "" : unescapeHTML2(obj.remarks);
			$("chkAnnualSw").checked = obj == null ? "" : obj.annualSw == 'Y' ? true : false;
			$("chkOnInceptTag").checked = obj == null ? "" : obj.onInceptTag == 'Y' ? true : false;
			$("txtUserId").value = obj == null ? "" : obj.userId;
			$("txtLastUpdate").value = obj == null ? "" : obj.lastUpdate;

		} catch (e) {
			showErrorMessage("populatePaymentTermInfo", e);
		}
	}

	function setPayTermMaintenanceTableValues(func) {
		var rowObjectPayment = new Object();

		rowObjectPayment.paytTerms = escapeHTML2($("txtPaytTerms").value);
		rowObjectPayment.paytTermsDesc = escapeHTML2($("txtPaytTermsDesc").value);
		rowObjectPayment.noOfPayt = $("txtNoOfPayt").value;
		rowObjectPayment.noOfDays = $("txtNoOfDays").value;
		rowObjectPayment.noPaytDays = $("txtPaytDays").value; //added by gab 11.03.2015
		rowObjectPayment.remarks = escapeHTML2($("txtRemarks").value);
		rowObjectPayment.annualSw = ($("chkAnnualSw").checked ? "Y" : "N");
		rowObjectPayment.onInceptTag = ($("chkOnInceptTag").checked ? "Y" : "N");
		rowObjectPayment.userId = "${PARAMETERS['USER'].userId}";
		var varLastUpdate = new Date();
		rowObjectPayment.lastUpdate = dateFormat(varLastUpdate, 'mm-dd-yyyy hh:MM:ss TT');

		rowObjectPayment.recordStatus = func == "Delete" ? -1 : func == "Add" ? 0 : 1;
		rowObjectPayment.unsavedAddStat = objPayTermMain[row].unsavedAddStat == 1 ? 1 : 0;
		return rowObjectPayment;
	}
	
	/* Updating and adding new payment term */
	function addUpdateDataInTable() {
		changeTagFunc = savePaymentTerm;
		rowObj = setPayTermMaintenanceTableValues($("btnAdd").value);
		
		if (checkAllRequiredFieldsInDiv("paymentTermInfoSectionDiv")) {
			if ($("btnAdd").value != "Add") {
				if (changed) {
					var addedSameExists = false;
					var deletedSameExists = false;	
					var column = null;
					for(var i=0; i<payTermMaintenanceTableGrid.geniisysRows.length; i++){
						if(payTermMaintenanceTableGrid.geniisysRows[i].recordStatus == 0 || payTermMaintenanceTableGrid.geniisysRows[i].recordStatus == 1){	
							if(unescapeHTML2(payTermMaintenanceTableGrid.geniisysRows[i].paytTermsDesc) == $F("txtPaytTermsDesc")){
								addedSameExists = true;	
								column = "payt_terms_desc";
							}
						} else if(payTermMaintenanceTableGrid.geniisysRows[i].recordStatus == -1){
							if(unescapeHTML2(payTermMaintenanceTableGrid.geniisysRows[i].paytTermsDesc) == $F("txtPaytTermsDesc")){
								deletedSameExists = true;
								column = "payt_terms_desc";
							}
						}
					}
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same " + column + ".", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						objPayTermMain.splice(row, 1, rowObj);
						payTermMaintenanceTableGrid.updateVisibleRowOnly(rowObj, row);
						payTermMaintenanceTableGrid.onRemoveRowFocus();
						changeTag = 1;
						changeCounter++;
						clearLastValidValueDetails();
						return;
					} 
					validateAddPaytTermsDesc();
					if (payTermDescStatus) {
						objPayTermMain.splice(row, 1, rowObj);
						payTermMaintenanceTableGrid.updateVisibleRowOnly(rowObj, row);
						payTermMaintenanceTableGrid.onRemoveRowFocus();
						changeTag = 1;
						changeCounter++;
						clearLastValidValueDetails();
					}
				}else{
					objPayTermMain.splice(row, 1, rowObj);
					payTermMaintenanceTableGrid.updateVisibleRowOnly(rowObj, row);
					payTermMaintenanceTableGrid.onRemoveRowFocus();
					changeTag = 1;
					changeCounter++;
					clearLastValidValueDetails();
				}
			} else {
				var addedSameExists = false;
				var deletedSameExists = false;	
				var column = null;
				for(var i=0; i<payTermMaintenanceTableGrid.geniisysRows.length; i++){
					if(payTermMaintenanceTableGrid.geniisysRows[i].recordStatus == 0 || payTermMaintenanceTableGrid.geniisysRows[i].recordStatus == 1){	
						if(unescapeHTML2(payTermMaintenanceTableGrid.geniisysRows[i].paytTerms) == $F("txtPaytTerms")){
							addedSameExists = true;	
							column = "payt_terms";
						}
						if(unescapeHTML2(payTermMaintenanceTableGrid.geniisysRows[i].paytTermsDesc).toUpperCase() == $F("txtPaytTermsDesc").toUpperCase()){
							addedSameExists = true;	
							column = "payt_terms_desc";
						}
					} else if(payTermMaintenanceTableGrid.geniisysRows[i].recordStatus == -1){
						if(unescapeHTML2(payTermMaintenanceTableGrid.geniisysRows[i].paytTerms) == $F("txtPaytTerms")){
							deletedSameExists = true;
							column = "payt_terms";
						}
						if(unescapeHTML2(payTermMaintenanceTableGrid.geniisysRows[i].paytTermsDesc).toUpperCase() == $F("txtPaytTermsDesc").toUpperCase()){
							deletedSameExists = true;
							column = "payt_terms_desc";
						}	
					}
				}
				if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
					showMessageBox("Record already exists with the same " + column + ".", "E");
					return;
				} else if(deletedSameExists && !addedSameExists){
					rowObj.unsavedAddStat = 1;
					objPayTermMain.push(rowObj);
					payTermMaintenanceTableGrid.addBottomRow(rowObj);
					payTermMaintenanceTableGrid.onRemoveRowFocus();
					changeTag = 1;
					changeCounter++;
					clearLastValidValueDetails();
					return;
				} 
				
				validateAddPaytTerms();
				validateAddPaytTermsDesc();
				if (addStatus && payTermDescStatus) {
					rowObj.unsavedAddStat = 1;
					objPayTermMain.push(rowObj);
					payTermMaintenanceTableGrid.addBottomRow(rowObj);
					payTermMaintenanceTableGrid.onRemoveRowFocus();
					changeTag = 1;
					changeCounter++;
					clearLastValidValueDetails();
				}
			}
		}
	}
	
	/* Deleting payment term */
	function deletePaytTerm() {
		changeTagFunc = savePaymentTerm;
		delObj = setPayTermMaintenanceTableValues($("btnDelete").value);
		validateDelete();

		if (deleteStatus) {
			objPayTermMain.splice(row, 1, delObj);
			payTermMaintenanceTableGrid.deleteVisibleRowOnly(row);
			payTermMaintenanceTableGrid.onRemoveRowFocus();

			if (changeCounter == 1 && delObj.unsavedAddStat == 1) {
				changeTag = 0;
				changeCounter = 0;
			} else {
				changeCounter++;
				changeTag = 1;
			}
		}
	}

	/* Saving */
	function savePaymentTerm() {
		var objParams = new Object();
		objParams.setRows = getAddedAndModifiedJSONObjects(objPayTermMain);
		objParams.delRows = getDeletedJSONObjects(objPayTermMain);

		new Ajax.Request(contextPath
				+ "/GIISPayTermController?action=savePaymentTerm", {
			method : "POST",
			parameters : {
				parameters : JSON.stringify(objParams)
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function() {
				showNotice("Saving Payment Term, please wait...");
			},
			onComplete : function(response) {
				hideNotice("");
				changeTag = 0;
				if (checkErrorOnResponse(response)) {
					if (response.responseText == "SUCCESS") {
						changeTagFunc = "";
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
							if(exitPaymentTerm != null) {
								exitPaymentTerm();
							} else {
								payTermMaintenanceTableGrid._refreshList();
								clearLastValidValueDetails();
							}
						});
						
					}
				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});

	}

	/* Validation(Delete): If the payment term is being used in gipi_winvoice or gipi_invoice */
	function validateDelete() {
		deleteStatus = false;

		new Ajax.Request(
				contextPath
						+ "/GIISPayTermController?action=validateDeletePaytTerm",
				{
					method : "POST",
					parameters : {
						parameters : delObj.paytTerms
					},
					asynchronous : false,
					evalScripts : true,
					onCreate : function() {
						showNotice("Validating Payment Term, please wait...");
					},
					onComplete : function(response) {
						hideNotice("");
						if (response.responseText == '1') {
							deleteStatus = true;
						} else {
							if (delObj.unsavedAddStat == 1) {
								deleteStatus = true;
							} else {
								if(response.responseText == "GIPI_WINVOICE"){
									showMessageBox("Cannot delete record from GIIS_PAYTERM while dependent record(s) in GIPI_WINVOICE exists.", imgMessage.ERROR);
								}else if(response.responseText == "GIPI_INVOICE"){
									showMessageBox("Cannot delete record from GIIS_PAYTERM while dependent record(s) in GIPI_INVOICE exists.", imgMessage.ERROR);
								}
								
							}
						}
					}
				});
	}

	/* Validation(Add): If the PAYT_TERMS is already existing in the table */
 	function validateAddPaytTerms() {
		addStatus = false;

		new Ajax.Request(contextPath
				+ "/GIISPayTermController?action=validateAddPaytTerm", {
			method : "POST",
			parameters : {
				parameters : $F("txtPaytTerms")
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response) {
				if (response.responseText == '1') {
					$("txtLastValidPaytTerms").value = $F("txtPaytTerms");
					addStatus = true;
				} else {
					customShowMessageBox("Record already exists with the same payt_terms.", imgMessage.ERROR, "txtPaytTerms");
					//$("txtPaytTerms").value = $F("txtLastValidPaytTerms");	 
					//addStatus = true;
				}
			}
		});

	}

	/* Validation(Add): If the PAYT_TERMS_DESC is already existing in the table */
	 function validateAddPaytTermsDesc() {
		payTermDescStatus = false;

		new Ajax.Request(contextPath
				+ "/GIISPayTermController?action=validateAddPaytTermDesc", {
			method : "POST",
			parameters : {
				paytTermDescToAdd : $F("txtPaytTermsDesc"),
				paytTerm : $F("txtPaytTerms")
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response) {
				if (response.responseText == '1') {
					$("txtLastValidPaytTermsDesc").value = $F("txtPaytTermsDesc");
					payTermDescStatus = true;
				} else {
					if ($F("txtPaytTermsDesc") == $F("txtPreviousPaytTermsDesc")){
						$("txtPaytTermsDesc").value = $F("txtPreviousPaytTermsDesc");
					}else {
						customShowMessageBox("Record already exists with the same payt_terms_desc.", imgMessage.ERROR, "txtPaytTermsDesc");
						//$("txtPaytTermsDesc").value = $F("txtLastValidPaytTermsDesc");
						//payTermDescStatus = true;
					}
				}
			}
		});
	}

	function formatAppearance() {
		try {
			$("btnAdd").value = "Add";
			disableButton("btnDelete");
		} catch (e) {
			showErrorMessage("formatAppearance", e);
		}
	}

	function clearDetails() {
		$("txtPaytTerms").value = "";
		$("txtPaytTermsDesc").value = "";
		$("txtNoOfPayt").value = 1;
		$("txtNoOfDays").value = "";
		$("txtPaytDays").value = ""; //added by gab 11.03.2015
		$("chkOnInceptTag").checked = true;
		$("chkAnnualSw").checked = false;
		$("txtRemarks").value = "";
		//$("txtUserId").value = "${PARAMETERS['USER'].userId}";
		//$("txtLastUpdate").value = dateFormat(new Date(), 'mm-dd-yyyy hh:M:ss TT');
		$("txtUserId").value = "";
		$("txtLastUpdate").value = "";
	}
	

	function clearLastValidValueDetails() {
		$("txtLastValidNoOfPayts").value = 1;
		$("txtLastValidNoOfDays").value = "";
		$("txtLastValidPaytTerms").value = "";
		$("txtLastValidPaytTermsDesc").value = "";
		$("txtLastValidPaytDays").value = ""; //added by gab 11.03.2015
	}
	
	function disableEdit() {
		$("txtPaytTerms").disabled = true;
	}

	function removeDisable() {
		$("txtPaytTerms").disabled = false;
	}

	$("btnAdd").observe("click", function() {
		addUpdateDataInTable();
	});

	$("btnDelete").observe("click", function() {
		deletePaytTerm();
	});

	$("btnDelete").disabled = true;
	
	/* observeCancelForm("paymentTermExit", savePaymentTerm, function() {
		payTermMaintenanceTableGrid.keys.releaseKeys();
		changeTag = 0;
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});

	observeCancelForm("btnCancel", savePaymentTerm, function() {
		payTermMaintenanceTableGrid.keys.releaseKeys();
		changeTag = 0;
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}); */

	observeReloadForm("reloadForm", showPaymentTerm);

	observeSaveForm("btnSave", savePaymentTerm);

	function exitPage(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}	
	
	function cancelGiiss018(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						exitPaymentTerm = exitPage;
						savePaymentTerm();
					}, function(){
						goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
	}
	
	$("btnCancel").observe("click", cancelGiiss018);
	$("paymentTermExit").stopObserving("click");
	$("paymentTermExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	}); 
	
	$("txtNoOfPayt").observe("change",function(){
		if ($F("txtNoOfPayt") < 1 && $F("txtNoOfPayt") != "") {
			//$("txtNoOfPayt").clear();
			customShowMessageBox("Invalid No. of Payments. Valid value should be from 1 to 99.", imgMessage.INFO, "txtNoOfPayt");
			$("txtNoOfPayt").value = $F("txtLastValidNoOfPayts");
		} else if ($F("txtNoOfPayt") != "" && isNaN($F("txtNoOfPayt"))) {
			//customShowMessageBox("Invalid No. of Payments. Valid value should be from 1 to 99.", imgMessage.INFO, "txtNoOfPayt"); --commented : kenneth L.
			$("txtNoOfPayt").value = $F("txtLastValidNoOfPayts");
		}else if($F("txtNoOfPayt") != "" && $F("txtNoOfPayt").include(".")){
			//customShowMessageBox("Invalid No. of Payments. Valid value should be from 1 to 99.", imgMessage.INFO, "txtNoOfPayt"); --commented : kenneth L.
			$("txtNoOfPayt").value = $F("txtLastValidNoOfPayts");
		}
		else{
			$("txtLastValidNoOfPayts").value = $F("txtNoOfPayt");
		}
	});

	$("txtNoOfDays").observe("change", function() {
		if ($F("txtNoOfDays") < 0) {
			//$("txtNoOfDays").clear();
			customShowMessageBox("Invalid No. of Days. Valid value should be from 0 to 999.", imgMessage.INFO, "txtNoOfDays");
			$("txtNoOfDays").value = $F("txtLastValidNoOfDays");
		} else if ($F("txtNoOfDays") != "-" && isNaN($F("txtNoOfDays"))) {
			//$("txtNoOfDays").clear();
			//customShowMessageBox("Invalid No. of Days. Valid value should be from 0 to 999.", imgMessage.INFO, "txtNoOfDays"); --commented : kenneth L.
			$("txtNoOfDays").value = $F("txtLastValidNoOfDays");
		} else if ($F("txtNoOfDays") == "-") {
			$("txtNoOfDays").value = 0;
		} else {
			$("txtLastValidNoOfDays").value = $F("txtNoOfDays");
		}
	});
	
	//added by gab 11.03.2015
	$("txtPaytDays").observe("change", function() {
		if ($F("txtPaytDays") < 0) {
			customShowMessageBox("Invalid No. of Payment Days. Valid value should be from 0 to 999.", imgMessage.INFO, "txtPaytDays");
			$("txtPaytDays").value = $F("txtLastValidPaytDays");
		} else if ($F("txtPaytDays") != "-" && isNaN($F("txtPaytDays"))) {
			$("txtPaytDays").value = $F("txtLastValidPaytDays");
		} else if ($F("txtPaytDays") == "-") {
			$("txtPaytDays").value = 0;
		} else {
			$("txtLastValidPaytDays").value = $F("txtPaytDays");
		}
	});
	
	 /* $("txtPaytTerms").observe("change",function() {
		validateAddPaytTerms();
	}); */
	
	$("txtPaytTermsDesc").observe("change",function() {
		if ($F("txtPaytTermsDesc") != $F("txtLastValidPaytTermsDesc")) {
			changed = true;
		}else {
			changed = false;
		}
	});
</script>
