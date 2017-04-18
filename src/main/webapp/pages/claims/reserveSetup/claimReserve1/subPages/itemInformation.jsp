<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Item Information</label> <span class="refreshers"
				style="margin-top: 0;"> <label name="gro"
				style="margin-left: 5px;">Hide</label>
			</span>
		</div>
	</div>
	<div class="sectionDiv" id="itemInformationTableGridSectionDiv" style="">
		<div id="itemInformation" name="itemInformation" style="width: 100%;">
			<div id="itemInformationTableGridDiv" style="padding: 10px;">
				<c:if test="${lineCd != 'SU'}">
					<div id="giclItemPerilGrid" style="height: 185px; margin: 10px; margin-bottom: 5px; width: 890px;"></div>					
				</c:if>	
				<c:if test="${grouped eq 'TRUE'}">
					<div id="groupedItemDiv"  >
						<table align="left"  style="margin: 5px;" border="0">
							<tr>
								<td class="leftAligned"  width="80px">Grouped Item</td>
								<td class="leftAligned"><input type="text" style="width: 40px;" id="txtGroupedItemNo" name="txtGroupedItemNo" readonly="readonly" value="" class="rightAligned"/></td>
								<td class="leftAligned"><input type="text" style="width: 220px;" id="txtGroupedItemTitle" name="txtGroupedItemTitle" readonly="readonly" value="" /></td>
							</tr>
						</table>	
					</div>
				</c:if>
				<c:if test="${lineCd eq 'SU'}">
					<div style="margin: 20px;">
						<table align="center" border="0">
							<tr>
								<td class="rightAligned"  width="120px">Bond Amount</td>
								<td class="leftAligned"><input type="text" style="width: 250px;" id="txtBondAmount" name="txtBondAmount" readonly="readonly" value="" class="money applyChange" /></td>
							</tr>
						</table>
					</div>			
				</c:if>	
			</div>
		</div>
	</div>
</div>
<div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Claim Reserve</label> <span class="refreshers"
				style="margin-top: 0;"> <label name="gro" id="claimReserveGro"
				style="margin-left: 5px;">Show</label>
			</span>
		</div>
	</div>
	<!-- <div  id="claimReserveSectionDiv" class="sectionDiv" changeTagAttr="true" style="display: none;"> -->
	<div  id="claimReserveSectionDiv" class="sectionDiv" changeTagAttr="true"">
		<div style="margin-top: 10px;  margin-left:80px; float: left; width: 780px;  ">
			<table align="center" border="0">
				<tr>
					<td class="rightAligned"  width="120px">Loss Reserve</td>
					<td class="leftAligned"><input type="text" style="width: 250px;" id="txtLossReserve" name="txtLossReserve" readonly="readonly" value="" class="money applyChange"  maxlength="18"/></td>
					<td id="lossCatTitle" name="lossCatTitle" class="rightAligned" width="250px">Losses Paid</td>
					<td class="leftAligned" width="150px"><input type="text" style="width: 250px;" id="txtLossesPaid" name="txtLossesPaid" readonly="readonly" value="" class="money" /></td>					
				</tr>
				<tr>
					<td class="rightAligned">Expense Reserve</td>
					<td class="leftAligned"><input type="text" style="width: 250px;" id="txtExpenseReserve" name="txtExpenseReserve" readonly="readonly" value="" class="money applyChange"  maxlength = "18" /></td>
					<td class="rightAligned"><label id="lossDateTitle" style="float: right;">Expense Paid</label></td>
					<td class="leftAligned"><input type="text" style="width: 250px;" id="txtExpensesPaid" name="txtExpensesPaid" readonly="readonly" value="" class="money" /></td>
				</tr>
				<tr>
					<td class="rightAligned">Total Reserve</td>
					<td class="leftAligned"><input type="text" style="width: 250px;" id="txtTotalReserve" name="txtTotalReserve" readonly="readonly" value="" class="money" /></td>
					<td class="rightAligned"><label id="lossDateTitle" style="float: right;">Total Claim Payment</label></td>
					<td class="leftAligned"><input type="text" style="width: 250px;" id="txtTotalClaimPayment" name="txtTotalClaimPayment" readonly="readonly" value="" class="money" /></td>
				</tr>
				<tr>
					<td colspan="6"><div style="border-top: 1.25px solid #c0c0c0; margin: 10px 0;"></div></td>
				</tr>
				<tr>
					<td class="rightAligned"  width="90px">History Number</td>
					<td class="leftAligned"><input type="text" style="width: 250px;" id="txtHistoryNumber" name="txtHistoryNumber" readonly="readonly" value="" class="rightAligned"/></td>
					<td id="lossCatTitle" name="lossCatTitle" class="rightAligned" width="150px">Booking Date</td>
					<td class="leftAligned">
						<div style="width:250px; border: none;">
							<input type="text" style="width: 140px;" id="txtBookingMonth" name="txtBookingMonth" value="" readonly="readonly" class="upper applyChange" maxlength="10"/>
							<input type="text" style="width: 65px;" id="txtBookingYear" name="txtBookingYear" value="" class="rightAligned integerNoNegativeUnformattedNoComma applyChange" readonly="readonly" maxlength="4"/>
							<input type="hidden">
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="bookDateLOV" name="bookDateLOV" alt="Go" style="margin-top: 2px; float: right;" title="Search Booking Date"/>
						</div>
					</td>					
				</tr>
				<tr>
					<td class="rightAligned">Convert Rate</td>
					<td class="leftAligned">
						<div>
							<input type="text" style="width: 100px; float: left;" id="txtConvertRate" name="txtConvertRate" readonly="readonly" value="" class="moneyRate"/>
							<label id="lblCurrency" style="float: left; font-weight: bolder; margin-top: 5px; margin-left: 2px;">&nbsp;</label>
						</div>
					</td>
					<td class="rightAligned"></td>
					<td class="leftAligned"><label id="lblDistType" style="float: right; font-weight: bolder;">&nbsp;</label></td>
				</tr>
				<tr>
					<td class="rightAligned"  width="220px">Remarks</td>
					<td class="leftAligned" colspan="3"  width="600px">
						<div style="border: 1px solid gray; height: 20px; width: 100%" changeTagAttr="true">
							<textarea onKeyDown="limitText(this,4000);" onKeyUp="limitText(this,4000);" id="txtRemarks" name="txtRemarks" style="width: 95.5%; border: none; height: 13px;" readonly="readonly"class="applyChange"></textarea>
							<img class="hover" src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" />
						</div>
					</td>
				</tr>
			</table>
		</div>
		<div id="perilInformationButtonsDiv" name="perilInformationButtonsDiv" class="buttonsDiv" style="margin-bottom: 10px;">
			<input id="btnUpdateReserve" name="btnUpdateReserve" type="button" class="button" value="Update" width="100px;">
		</div>
	</div>
</div>

<script type="text/javascript">
try{
	objGICLItemPeril = JSON.parse('${giclItemPerilList}');
	var lineCd = '${lineCd}';
	disableButton("btnUpdateReserve");
	disableSearch("bookDateLOV");
	$("editRemarks").hide();
		
	objGICLS024.hasPendingRecords = false;
	//hasPendingChildRecords = false; -- replaced by: Nica 03.21.2014 - to prevent error in UW
	withPendingChildRecords = false; 
	
	var initialBookingMonth = "";
	var initialBookingYear = "";
	var grouped = '${grouped}';
	
	var objPerilParams = new Object();
	var selectedItemInfoRow = new Object();
	var selectedItemInfo = null;
	objClmReserve = [];
	
	function getPerilStatusGICLS024() {
		try {
			new Ajax.Request(
					contextPath + "/GICLItemPerilController",
					{
						method : "GET",
						parameters : {
							action : "checkPerilStatus",
							claimId : selectedItemInfoRow.claimId,
							perilCd : selectedItemInfoRow.dspPerilCd,
							itemNo : selectedItemInfoRow.itemNo,
							groupedItemNo : selectedItemInfoRow.groupedItemNo
						},
						evalScripts : true,
						asynchronous : true,
						onComplete : function(response) {
							if (checkErrorOnResponse(response)) {
								var res = JSON.parse(response.responseText);
								objGICLS024.vars.closeFlag = res.closeFlag;
								objGICLS024.vars.closeFlag2 = res.closeFlag2;
								if (res.closeFlag != "AP") {
									showMessageBox("Loss reserve cannot be updated. Peril has been closed/withdrawn/denied.");
								}
							}
						}
					});
		} catch (e) {
			showErrorMessage("getPerilStatusGICLS024", e);
		}
	}
	
	initializeAll();
	initializeAccordion();
	initializeAllMoneyFields();
	
	function tagButtons(obj){
		if (obj != null){
			 if(nvl(obj.reserveDtlExist,"N") == "Y"){
				enableButton("reserveHistoryBtn");
			}else{
				disableButton("reserveHistoryBtn");
			}
			if(nvl(obj.paymentDtlExist,"N") == "Y"){
				enableButton("paymentHistoryBtn");
			}else{
				disableButton("paymentHistoryBtn");
			}
			enableButton("distDtlsBtn");
			enableButton("updateStatusBtn");
			enableButton("distributionDateBtn");
			enableButton("availmentsBtn");
			enableButton("btnSaveReserve");
			enableButton("btnUpdateReserve");
		}else{
			disableButton("btnUpdateReserve");
			disableButton("distDtlsBtn");
			disableButton("paymentHistoryBtn");
			disableButton("updateStatusBtn"); 
			disableButton("reserveHistoryBtn");
			disableButton("redistributeBtn");
			disableButton("distributionDateBtn");
			disableButton("availmentsBtn");
			disableButton("btnSaveReserve");
		}
	}
	
	function showRelatedDtls(y){
		selectedItemInfoRow = claimReserveTableGrid.geniisysRows[y];
		selectedItemInfo = y;
		objCurrGICLItemPeril = selectedItemInfoRow;
		//setReserveEditableProperty(objCurrGICLItemPeril);
		setReserveInfo(selectedItemInfoRow.giclClaimReserve);
		objGICLS024.setClmResHistory(selectedItemInfoRow.giclClmResHist);
		tagButtons(objCurrGICLItemPeril);
		//gro
		$("claimReserveGro").innerHTML = "Hide";
		$("claimReserveSectionDiv").show();
		if(grouped == 'TRUE'){
			$("txtGroupedItemNo").value = objCurrGICLItemPeril.groupedItemNo;
			$("txtGroupedItemTitle").value = objCurrGICLItemPeril.dspGroupedItemTitle;
		}
	}
	
	function removeRelatedDtls(){
		objCurrGICLItemPeril = {};
		setReserveInfo(null);
		objGICLS024.setClmResHistory(null);
		//setReserveEditableProperty(new Object);
		tagButtons(null);
		//gro
		$("claimReserveGro").innerHTML = "Show";
		$("claimReserveSectionDiv").hide();
		if(grouped == 'TRUE'){
			$("txtGroupedItemNo").clear();
			$("txtGroupedItemTitle").clear();
		}
	}
	
if (lineCd != 'SU') {
	var giclItemPerilTableModel = {
		id : 1,
		url : contextPath
				+ "/GICLClaimReserveController?action=refreshClaimReserveListing&claimId=" + nvl(objCLMGlobal.claimId, 0),
		options : {
			title : '',
			width : '890px',
			pager: {}, 
			hideColumnChildTitle: true,
			toolbar : {
				elements : [ MyTableGrid.REFRESH_BTN],
				onRefresh : function() {
					claimReserveTableGrid.keys.releaseKeys();
					removeRelatedDtls();
				}
			},
			onCellFocus : function(element, value, x, y, id) {
				claimReserveTableGrid.keys.removeFocus(claimReserveTableGrid.keys._nCurrentFocus, true);
				claimReserveTableGrid.keys.releaseKeys();
				if(withPendingChildRecords){
					showConfirmBox4("Save", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
							objGICLS024.preCommit,
							function(){
								withPendingChildRecords = false;
								changeTag = 0;
								showRelatedDtls(y);
							}, "");	
				}else{
					showRelatedDtls(y);
				}
			},
			onRemoveRowFocus : function() {
				claimReserveTableGrid.keys.removeFocus(claimReserveTableGrid.keys._nCurrentFocus, true);
				claimReserveTableGrid.keys.releaseKeys();
				if(withPendingChildRecords){
					showConfirmBox4("Save", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
							objGICLS024.preCommit,
							function(){
								withPendingChildRecords = false;
								changeTag = 0;
								removeRelatedDtls();
							}, "");	
				}else{
					removeRelatedDtls();
				}
			}
		},columnModel:[{
			id : 'recordStatus',
			title : '',
			width : '0',
			visible : false,
			editor : 'checkbox'
		},{
			id : 'divCtrId',
			width : '0',
			visible : false
		}, {
			id : 'groupedItemNo',
			width : '0',
			visible : false
		}, {
			id : 'itemNo dspItemTitle',
			title : 'Item',
			width : '210px',
			sortable : false,					
			children : [
				{
					id : 'itemNo',							
					width : 50,							
					sortable : false,
					editable : false,	
					align: 'right'
				},
				{
					id : 'dspItemTitle',							
					width : 170,
					sortable : false,
					editable : false
				}
			            ]					
		},	{
			id : 'perilCd dspPerilName',
			title : 'Peril',
			width : '210px',
			sortable : false,					
			children : [
				{
					id : 'perilCd',							
					width : 50,							
					sortable : false,
					editable : false,	
					align: 'right'
				},
				{
					id : 'dspPerilName',							
					width : 170,
					sortable : false,
					editable : false
				}
			            ]					
		}, {
			id : 'annTsiAmt',
			title : 'Total Sum Insured',
			titleAlign : 'center',
			type : 'number',
			width : '128px',
			geniisysClass : 'money',
			filterOption : true,
			filterOptionType : 'number'
		}, {
			id : 'lossStat',
			title : 'Loss Status',
			width : '150',
			editable : false,
			filterOption : true
		}, {
			id : 'expStat',
			title : 'Expense Status',
			width : '144',
			editable : false,
			filterOption : true
		}, {
			id : 'noOfDays',
			width : '0',
			visible : false
		}, {
			id : 'baseAmt',
			width : '0',
			visible : false
		}, {
			id : 'allowTsiAmt',
			width : '0',
			visible : false
		}],
		resetChangeTag: true,
		rows : objGICLItemPeril.rows
	};
		
	claimReserveTableGrid = new MyTableGrid(giclItemPerilTableModel);
	claimReserveTableGrid.pager = objGICLItemPeril;
	claimReserveTableGrid.render('giclItemPerilGrid');
	claimReserveTableGrid.afterRender = function(){
		objClmReserve = claimReserveTableGrid.geniisysRows;
		removeRelatedDtls();
	};
}

	function checkIfGroupedItem(){
		var tsiTotal = 0;
		var premTotal = 0;
		for(var i = 0; i < objQuote.objPeril.length; i++){
			if(objQuote.objPeril[i].recordStatus != -1){
				if(objQuote.objPeril[i].perilType == 'B'){
					tsiTotal = parseFloat(tsiTotal) + parseFloat(objQuote.objPeril[i].perilTsiAmt);
				}
				premTotal = parseFloat(premTotal) + parseFloat(objQuote.objPeril[i].perilPremAmt);
			}
		}
		$("totalTsi").value = formatCurrency(tsiTotal);
		$("totalPrem").value = formatCurrency(premTotal);
	}
		
	function clearItemInfoRelatedRecords() {
		try{
			objCurrGICLItemPeril = {};
			disableButton("paymentHistoryBtn");
		}catch(e){
			showErrorMessage("Clear Item info related records...", e);
		}
	}
	
	function recomputeTotalReserve(v1, v2, sumElement, param){ 
		var totalExpense = nvl(unformatCurrencyValue(v1) + unformatCurrencyValue(v2),0);
		if(nvl(param, "N") == "Y"){
			var annTsiAmt = unformatCurrencyValue(nvl(objCurrGICLItemPeril.allowTsiAmt, objCurrGICLItemPeril.annTsiAmt)); //move nvl inside unformatCurrencyValue function by CarloR 08.11.2016 SR 22591
			//if(annTsiAmt < totalExpense){ commented out and changed by reymon 11152013
			if(annTsiAmt < nvl(unformatCurrencyValue($F("txtLossReserve")),0)){
				$("txtExpenseReserve").value = formatCurrency(objGICLS024.vars.origExpenseReserve);
				$("txtLossReserve").value = formatCurrency(objGICLS024.vars.origLossReserve);
				showWaitingMessageBox("Loss Reserve Amount cannot exceed "+formatCurrency(annTsiAmt), "I");
				return false;
			}
			if(nvl(objGICLS024.vars.validatePayt,"Y") == "Y" && unformatCurrencyValue(v2) < unformatCurrencyValue($F("txtLossesPaid"))){
				//added condition by June Mark SR-23791 [02.08.17]
				if(unformatCurrencyValue($F("txtLossesPaid")) == "" || unformatCurrencyValue($F("txtLossesPaid")) == 0){
					showMessageBox("Invalid Losses Paid amount. Valid value should be greater than 0.","I");
				}else{
					showMessageBox("Loss Reserve cannot be less than the losses paid.", "I");
				}
				$("txtLossReserve").value = formatCurrency(objGICLS024.vars.origLossReserve);
				return false;
			}else if(nvl(objGICLS024.vars.validatePayt,"Y") == "Y" && unformatCurrencyValue(v2) <= 0){ //Added by: Jerome 030215 (unformatCurrencyValue(v2) <= 0)
				if(($F("txtLossReserve") == "" || $F("txtLossReserve") == "0.00")
						&& (unformatCurrency("txtExpenseReserve") > 0)){
					totalExpense = unformatCurrencyValue($F("txtExpenseReserve")) + unformatCurrencyValue($F("txtLossReserve"));
				}else{
					showMessageBox("Invalid Loss Reserve amount. Valid value should be greater than 0.","I");
					$("txtLossReserve").value = formatCurrency(objGICLS024.vars.origLossReserve);
					totalExpense = unformatCurrencyValue($F("txtExpenseReserve")) + unformatCurrencyValue($F("txtLossReserve"));
				}
			}
			sumElement.value = formatCurrency(totalExpense);
			objGICLClaims.lossRsrvFlag = "Y";
			objGICLS024.checkLossReserve();
			objGICLS024.claimReserveChanged =  "Y";
			objGICLClaims.redistributeSw= "Y";
		}else{
			if(nvl(objGICLS024.vars.validatePayt,"Y") == "Y" && unformatCurrencyValue(v1) < unformatCurrencyValue($F("txtExpensesPaid"))){
				//added condition by June Mark SR-23791 [02.08.17]
				if(unformatCurrencyValue($F("txtExpensesPaid")) == "" || unformatCurrencyValue($F("txtExpensesPaid")) == 0){
					showMessageBox("Invalid Expense Paid amount. Valid value should be greater than 0.","I");
				}else{
					showMessageBox("Expense Reserve cannot be less than the expenses paid.", "I");
				}
				$("txtExpenseReserve").value = formatCurrency(objGICLS024.vars.origExpenseReserve);
				return false;
			}else if(nvl(objGICLS024.vars.validatePayt,"Y") == "Y" && unformatCurrencyValue(v1) <= 0){ //Added by: Jerome 030215 (unformatCurrencyValue(v1) <= 0)
				if(($F("txtExpenseReserve") == "" || $F("txtExpenseReserve") == "0.00")
						&& (unformatCurrency("txtLossReserve") > 0)){
					totalExpense = unformatCurrencyValue($F("txtExpenseReserve")) + unformatCurrencyValue($F("txtLossReserve"));
				}else{
					showMessageBox("Invalid Expense Reserve amount. Valid value should be greater than 0.","I");
					$("txtExpenseReserve").value = formatCurrency(objGICLS024.vars.origExpenseReserve);
					totalExpense = unformatCurrencyValue($F("txtExpenseReserve")) + unformatCurrencyValue($F("txtLossReserve"));
				}
			}
			sumElement.value = formatCurrency(totalExpense);
			if(objGICLS024.vars.validateReserveLimits == "Y"){
				objGICLClaims.lossRsrvFlag = "Y";
				objGICLS024.checkLossReserve();
			}
			objGICLS024.claimReserveChanged =  "Y";
			objGICLClaims.redistributeSw = "Y";
		}
	}
	
	/*  $("txtExpenseReserve").observe("blur", function(){
		recomputeTotalReserve($F("txtExpenseReserve"), $F("txtLossReserve"), $("txtTotalReserve"),"N");
	}); */
	
	$("txtLossReserve").observe("focus", function(){
		if(!isPerilOpen(objCurrGICLItemPeril.lossStat)){
			$("txtLossReserve").setAttribute("readOnly", "readOnly");
			$("txtLossReserve").readOnly = true;
				showMessageBox("Loss reserve cannot be updated. \nPeril has been closed/withdrawn/denied.", "I");
				return false;
		}else{
			$("txtLossReserve").setAttribute("readOnly", "");
			$("txtLossReserve").readOnly = false;
		}
	});
	
	//txtLossReserve
	$("txtLossReserve").observe("blur", function(){
		if(parseFloat($F("txtLossReserve").replace(/,/g, "")) > parseFloat(999999999999.99)){
			showWaitingMessageBox("Field must be of form 999,999,999,999.99", "I", function(){
				$("txtLossReserve").value 	= formatCurrency(objCurrGICLItemPeril.giclClaimReserve.lossReserve);
				return false;
			});
		}else{
			if(objCurrGICLItemPeril.giclClaimReserve){
				if(objCurrGICLItemPeril.giclClaimReserve.lossReserve != unformatCurrencyValue($F("txtLossReserve"))){
					recomputeTotalReserve($F("txtExpenseReserve"), $F("txtLossReserve"), $("txtTotalReserve"),"Y");
				}
			}else{
				recomputeTotalReserve($F("txtExpenseReserve"), $F("txtLossReserve"), $("txtTotalReserve"),"Y");
			}
		}
	});
	
	$("txtExpenseReserve").observe("focus", function(){
		if(!isPerilOpen(objCurrGICLItemPeril.expStat)){
			$("txtExpenseReserve").setAttribute("readOnly", "readOnly");
			$("txtExpenseReserve").readOnly = true;
			showMessageBox("Expense reserve cannot be updated. \nPeril has been closed/withdrawn/denied.", "I");
				return false;
		}else{
			$("txtExpenseReserve").setAttribute("readOnly", "");
			$("txtExpenseReserve").readOnly = false;
		}
	});
	
	$("txtExpenseReserve").observe("blur", function(){
		if(parseFloat($F("txtExpenseReserve").replace(/,/g, "")) > parseFloat(999999999999.99)){
			showWaitingMessageBox("Field must be of form 999,999,999,999.99", "I", function(){
				$("txtExpenseReserve").value 	= formatCurrency(objCurrGICLItemPeril.giclClaimReserve.expenseReserve);
				return false;
			});
		}else{
			if(objCurrGICLItemPeril.giclClaimReserve){
				if(objCurrGICLItemPeril.giclClaimReserve.expenseReserve != unformatCurrencyValue($F("txtExpenseReserve"))){
					recomputeTotalReserve($F("txtExpenseReserve"), $F("txtLossReserve"), $("txtTotalReserve"),"N");
				}
			}else{
				recomputeTotalReserve($F("txtExpenseReserve"), $F("txtLossReserve"), $("txtTotalReserve"),"N");
			}
		}
		
	});
	
	$("editRemarks").observe("click", function(){
		showEditor("txtRemarks", 4000, false);
	});

	function isPerilOpen(flag){
		if(flag == "CLOSE" || flag == "DENIED" || flag == "WITHDRAWN" || flag == "CLOSED" || flag == "DENIED"){
			return false;
		}
		return true;
	}
	
	function setReserveInfo(obj){	
		var totalResAmount;
		var totalPaid;
		if(nvl(obj,null) != null){
			totalResAmount = parseFloat(nvl(obj.lossReserve,0)) + parseFloat(nvl(obj.expenseReserve,0));
			totalPaid = parseFloat(nvl(obj.lossesPaid,0)) + parseFloat(nvl(obj.expensesPaid,0));		
			if(!nvl(obj.lossReserve,"") == ""){
				enableButton("redistributeBtn");	
			}
		}else{
			disableButton("redistributeBtn");	
		}
		$("txtLossReserve").value 				= nvl(obj,null) != null ? formatCurrency(obj.lossReserve) :null;
		$("txtLossesPaid").value 					= nvl(obj,null) != null ? formatCurrency(obj.lossesPaid) :null;
		$("txtExpenseReserve").value 			= nvl(obj,null) != null ? formatCurrency(obj.expenseReserve) :null;
		$("txtExpensesPaid").value 				= nvl(obj,null) != null ? formatCurrency(obj.expensesPaid) :null;
		$("txtTotalReserve").value 				= nvl(obj,null) != null ? formatCurrency(nvl(obj.dspTotalResAmount,nvl(totalResAmount,0))) : null; 
		$("txtTotalClaimPayment").value 		= nvl(obj,null) != null ? formatCurrency(nvl(obj.dspTotalPaid,nvl(totalPaid,0))) : null;	
	}
	
	function showReserveHistoryTG(show){	
		try{	
			if(show){
				var claimId = selectedItemInfoRow.claimId;
				var itemNo = selectedItemInfoRow.itemNo;
				var perilCd = selectedItemInfoRow.perilCd;
				reserveHistTableGrid.url = contextPath+"/GICLClaimReserveController?action=getClmResHistListing&refresh=1&claimId="+claimId+
						"&itemNo="+itemNo+"&perilCd="+perilCd;
				reserveHistTableGrid._refreshList();
			}else{
				if($("reserveHistoryTGDiv") != null){
					clearTableGridDetails(reserveHistTableGrid); 
					objGICLS024.setClmResHistory(null);
				}
			}
		}catch(e){
			showErrorMessage("showReserveHistoryTG",e);
		}
	}
	
	function createItemInfoDtls(){
		try {			
			function createClaimReserve(){
				var clmRsrv 									= nvl(objCurrGICLItemPeril.giclClaimReserve, '{}');
				clmRsrv.lossReserve 					= unformatCurrencyValue($F("txtLossReserve"));
				clmRsrv.expenseReserve 			= unformatCurrencyValue($F("txtExpenseReserve"));
				clmRsrv.dspTotalResAmount 	= unformatCurrencyValue($F("txtTotalReserve"));
				return clmRsrv;
			}
			function createResHist(){
				var resHist										= nvl(objCurrGICLItemPeril.giclClmResHist, '{}');
				resHist.bookingMonth				= $F("txtBookingMonth");
				resHist.bookingYear					= $F("txtBookingYear");
				resHist.remarks							= $F("txtRemarks");
				return resHist;
			}
			var obj 								= objCurrGICLItemPeril;
			obj.recordStatus 				= 1;
			obj.giclClaimReserve      = createClaimReserve();
			obj.giclClmResHist      	= createResHist();
			return obj;
		} catch (e){
			showErrorMessage("createItemInfoDtls", e);
		}			
	}
	
	$("btnUpdateReserve").observe("click", function(){ //modified this function by June Mark SR-5816 [01.13.17]
		if (($F("txtLossReserve") == "" && $F("txtExpenseReserve") == "") 
				|| (unformatCurrency("txtLossReserve") == 0 && unformatCurrency("txtExpenseReserve") == 0)
				|| ((unformatCurrency("txtExpenseReserve") == 0 || $F("txtExpenseReserve") == "")
						&& (parseFloat($F("txtLossReserve").replace(/,/g, "")) > parseFloat(999999999999.99) 
						    || parseFloat($F("txtLossReserve").replace(/,/g, "")) < parseFloat(0.01)))
				|| ((unformatCurrency("txtLossReserve") == 0 || $F("txtLossReserve") == "")
						&& (parseFloat($F("txtExpenseReserve").replace(/,/g, "")) > parseFloat(999999999999.99) 
						    || parseFloat($F("txtExpenseReserve").replace(/,/g, "")) < parseFloat(0.01)))){
			
			showMessageBox(
					"Invalid Amount. Loss/Expense Reserve value should be from 0.01 to 99,999,999,999,999.99.",
					//"Loss Reserve Amount and Expense Reserve Amount cannot be both zero.",
					"I");
			return false;
		}
	  /* else if($F("txtBookingMonth") == ""){ //marco - 8.29.2012
			showMessageBox("Booking month cannot be null.", "I");
			return false;
		}else if($F("txtBookingYear") == ""){
			showMessageBox("Booking year cannot be null.", "I");
			return false; */
			/*} else if(){
			showMessageBox(
						"Invalid Amount. Expense Reserve value should be from 0.01 to 99,999,999,999,999.99.",
						"I");
				return false;
			
		} */
		var item = createItemInfoDtls();		
		/* if (lineCd != 'SU') {
			claimReserveTableGrid.updateRowAt(item, selectedItemInfo);
			claimReserveTableGrid.onRemoveRowFocus();
		}else{ */
			objCurrGICLItemPeril = item;
			showMessageBox("Update successful.", "S");
		/* } */
		objGICLS024.hasPendingRecords = false;
		withPendingChildRecords = true;
		changeTag = 1;
	});
	
	$("txtExpenseReserve").observe("focus", function(){
		objGICLS024.vars.origExpenseReserve = unformatCurrencyValue($F("txtExpenseReserve"));
		objGICLS024.vars.origLossReserve = unformatCurrencyValue($F("txtLossReserve"));
	});
	
	$("txtLossReserve").observe("focus", function(){
		objGICLS024.vars.origExpenseReserve = unformatCurrencyValue($F("txtExpenseReserve"));
		objGICLS024.vars.origLossReserve = unformatCurrencyValue($F("txtLossReserve"));
	});
	
	function getBookingDate(){
		try{
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getGICLS024BookingDateLOV",
					claimId : objGICLClaims.claimId,
					page : 1			
				},
				title: "Select Booking Month and Year",
				width : 360,
				height : 350,
				columnModel : [
				               {
				            	   id : "bookingMonth",
				            	   title : "Month",
				            	   width : '245px'
				               },
				               {
				            	   id : "bookingYear",
				            	   title : "Year",
				            	   width : '100px'
				               }
				              ],
				draggable : true,
				onSelect : function(row){
					$("txtBookingYear").value	= row.bookingYear;
					$("txtBookingMonth").value	= unescapeHTML2(row.bookingMonth);
				},
				onCancel: function(){
					$("txtBookingMonth").focus();
				}
			});
		}catch(e){
			showErrorMessage("getBookingDate", e);
		}
	}
	
	$("bookDateLOV").observe("click",getBookingDate);
	
	function validateBookingDate(func){
		new Ajax.Request(contextPath+"/GIACTranMmController", {
			method: "POST",
			parameters: {action : "checkBookingDate",
									   claimId : objGICLClaims.claimId,
									   bookingYear : func == "year" ? $F("txtBookingYear") : "",
									   bookingMonth : $F("txtBookingMonth").toUpperCase()},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var valid = response.responseText;
						if(func == "month"){
							if(valid=="N"){
								showWaitingMessageBox("Invalid Booking Month.", "I", function(){
									$("txtBookingMonth").value = initialBookingMonth;
									$("txtBookingMonth").focus();
								});
							}
						}else{
							if(valid=="N"){
								showWaitingMessageBox("Invalid Booking Year.", "I", function(){
									$("txtBookingYear").value = nvl(initialBookingYear, selectedItemInfoRow.giclClmResHist.bookingYear);
									$("txtBookingYear").focus();
								});
							}
						}
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	$("txtBookingMonth").observe("focus", function(){
		initialBookingMonth = this.value;
	});
	
	$("txtBookingMonth").observe("blur", function(){		
		if($("txtBookingMonth").getAttribute("readonly") != "readonly"){
			if($F("txtBookingMonth") == "" && $F("txtHistoryNumber") != ""){
				showWaitingMessageBox("Booking Month cannot be null.", "I", function(){
					$("txtBookingMonth").value = initialBookingMonth;
					$("txtBookingMonth").focus();
				});
			}else if($F("txtBookingMonth") != ""){
				validateBookingDate("month");
			}
		}
	});
	
	$("txtBookingYear").observe("focus", function(){
		if(this.value != null){
			initialBookingYear = this.value;
		}
	});
	
	$("txtBookingYear").observe("blur", function(){
		if($("txtBookingYear").getAttribute("readonly") != "readonly"){
			if($F("txtBookingYear") == "" && $F("txtHistoryNumber") != ""){
				showWaitingMessageBox("Booking Year cannot be null.", "I", function(){
					$("txtBookingYear").value = nvl(initialBookingYear, selectedItemInfoRow.giclClmResHist.bookingYear);
					$("txtBookingYear").focus();
				});
			}else if($F("txtBookingYear") != ""){
				validateBookingDate("year");
			}
		}
	});
	
	$$(".applyChange").each(function(inputElement){
		inputElement.observe("change", function(){
			objGICLS024.hasPendingRecords = true;
			changeTag = 1;
		});
	});
	
	function getSUDetails(){
		selectedItemInfoRow = objGICLS024.SU;
		objCurrGICLItemPeril = selectedItemInfoRow;
		$("txtBondAmount").value = formatCurrency(selectedItemInfoRow.annTsiAmt);
		setReserveInfo(selectedItemInfoRow.giclClaimReserve);
		objGICLS024.setClmResHistory(selectedItemInfoRow.giclClmResHist);
		tagButtons(objCurrGICLItemPeril);
	}
	
	objGICLS024.getSUDetails = getSUDetails;
	objGICLS024.getPerilStatusGICLS024 = getPerilStatusGICLS024;
	
} catch (e) {
	showErrorMessage("itemInformation page", e);
}

</script>