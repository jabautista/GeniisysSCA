<!--
Remarks: For deletion
Date : 04-13-2012
Developer: M. Cadwising
Replacement : /pages/accounting/officialReceipt/otherTrans/collnsForOtherOffTableGrid.jsp
--> 
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://ajaxtags.org/tags/ajax" prefix="ajax" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div class="sectionDiv" id="collnsForOtherOffDiv" name="collnsForOtherOffDiv">
	<jsp:include page="subPages/collnsForOtherOffTable.jsp"></jsp:include>
	<table align="center" style="margin: 10px;">
		<tr>
			<td class="rightAligned" style="width: 160px;">Item No.</td>
			<td class="leftAligned">
				<input type="text" class="required" id="itemNo" maxlength="2"></input>
			</td>
			<td class="rightAligned" style="width: 160px;">Old Tran No.</td>
			<td class="leftAligned">
			<div id="divOldTransNo" style="border:none; width: 228px; height: 19px; float: left">
				<input type="text" id="tranYear"  style="width:55px;"  readonly="readonly" maxlength="4" title="Transaction year"> -
				<input type="text" id="tranMonth" style="width:40px;" readonly="readonly" maxlength="2" title="Transaction month"> -
				<input type="text" id="tranSeqNo" style="width:55px;" readonly="readonly" maxlength="5" title="Transaction Sequence No.">
				<img style="float: right; display: none;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgOldTran" name="imgSearchTranNo" alt="Go" />
			</div>
				<input type="hidden" id="hidGaccTranId" name="hidGaccTranId" value="">
				<input type="hidden" id="oldTransNo" name="oldTransNo" value="">
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 160px;">Tran Type</td>
			<td class="leftAligned">
				<select id="tranType" class="required" style="width: 230px;">
					<option value=""></option>
					<c:forEach var="tranType" items="${transType}">
						<option value="${tranType.rvLowValue}">${tranType.rvMeaning}</option>
					</c:forEach>
				</select>
				<input type="text" class="required" id="txtTranType" style="display: none; width: 222px;" value="" readonly="readonly">
			</td>
			<td class="rightAligned" style="width: 160px;">Old Fund Code</td>
			<td class="leftAligned">
				<div id="divOldFundCode" style="border: 1px solid gray; width: 228px; height: 20px; float: left; margin-right: 7px">
					<input type="text" id="oldFundCode" name="oldFundCode" style="width: 200px; border: none; float: left; height: 12px;" readonly="readonly" maxlength="3"></input>
					<img style="float: right; display: none;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgOldFundCode" name="imgSearchTranNo" alt="Go" />
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 160px;">Fund Code</td>
			<td class="leftAligned">
				<select id="fundCode" class="required" style="width: 230px;">
					<option value=""></option>
					<c:forEach var="fundList" items="${fundList}">
						<option value="${fundList.gibrGfunFundCd}">${fundList.gibrGfunFundDesc}</option>
					</c:forEach>
				</select>
				<input type="text" class="required" id="txtFundCode" style="display: none; width: 222px;" value="" readonly="readonly">
			</td>
			<td class="rightAligned" style="width: 160px;">Old Branch Code</td>
			<td class="leftAligned">
				<div id="divOldBranch" style="border: 1px solid gray; width: 228px; height: 20px; float: left; margin-right: 7px">
					<input type="text" id="oldBranch" name="oldTransNo" style="width: 200px; border: none; float: left; height: 12px;" readonly="readonly" maxlength="2"></input>
					<img style="float: right; display: none;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgOldBranch" name="imgSearchTranNo" alt="Go" />
					<input type="hidden" id="hidOldBranchName" name="hidOldBranchName" value="">
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 160px;">Branch</td>
			<td class="leftAligned">
				<select id="gibrBranch" class="required" style="width: 230px;">
					<option value=""></option>
					<c:forEach var="branch" items="${fundList}">
						<option value="${branch.gibrBranchCd}">${branch.gibrBranchName}</option>
					</c:forEach>
				</select>
				<input type="text" class="required" id="txtBranch" style="display: none; width: 222px;" value="" readonly="readonly">
			</td>
			<td class="rightAligned" style="width: 160px;">Old Item No.</td>
			<td class="leftAligned">
				<div id="divOldItemNo" style="border: 1px solid gray; width: 228px; height: 20px; float: left; margin-right: 7px">
					<input type="text" id="oldItemNo" name="oldTransNo" style="width: 200px; border: none; float: left; height: 12px;" readonly="readonly" maxlength="2"></input>
					<img style="float: right; display: none;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgOldItemNo" name="imgSearchTranNo" alt="Go" />
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 160px;">Amount</td>
			<td class="leftAligned">
				<input type="text" class="required" id="amount" style="width: 222px; text-align: right;"/>
				<input type="hidden" id="hidDefaultAmt" value="">
			</td>
			<td class="rightAligned" style="width: 160px;">Particulars</td>
			<td class="leftAligned">
				<input type="text" id="particulars" style="width: 222px;" maxlength="500"/>
			</td>
		</tr>
	</table>
	<div style="margin: 10px;">
		<input type="button" class="button" style="width: 80px;font-size: 12px;text-align: center" id="btnAdd" value="Add"/>
		<input type="button" class="disabledButton" style="width: 80px;font-size: 12px;text-align: center" id="btnDelete" value="Delete">
	</div>
</div>
<div class="buttonsDiv" style="float:left;">			
	<input type="button" style="width: 70px; font-size: 12px;" id="btnSaveCollns" 	name="btnSaveCollns"	class="button" value="Save" />
	<input type="button" style="width: 70px; font-size: 12px;" id="btnCancelCollns" name="btnCancelCollns"	class="button" value="Cancel"/>
</div>

<script type="text/javascript">
	setModuleId("GIACS012");
	var objGOFC = JSON.parse('${searchResult}'.replace(/\\/g, '\\\\'));
	var content = "";
	var currentRow = -1;
	var lastRowNo = 0;
	var pageActions = {none: 0, save: 1, cancel:2};
	var pAction = pageActions.none;
	changeTag = 0;
	
	if(objGOFC.length > 0){
		for(var i=0; i<objGOFC.length; i++){
			content = generateRow(objGOFC[i], i);
			addTableRow("row"+i, "rowOthFundOffCollns","collnsForOtherOfficeTableContainer", content, clickOthFundOffCollnsRow);
			lastRowNo = i + 1;
		}
		checkIfToResizeTable("collnsForOtherOfficeTableContainer", "rowOthFundOffCollns");
	}else{
		checkTableIfEmpty("rowOthFundOffCollns", "collnsForOtherOffTableMainDiv");
	}

	$("tranType").observe("change", function(){
		if(this.value == 1){
			resetFields();
			resetFieldBehavior();
			$("tranType").value = 1;
			
		}else if(this.value == 2){
			resetFields();
			resetFieldsForTranTypeTwo();
		}
			
	});

	$$("img[name='imgSearchTranNo']").each(function(img){
		img.observe("click", function(){
			showOldTransModalBox();
		});
	});

	$("amount").observe("blur", function(){
		var amt = $("amount").value;
		if(isNaN(amt)){
			showMessageBox("Field must be of form 99,999,999,990.99.");
			$("amount").value = "";
		}else{
			validateCollnAmount(amt);
		}
	});

	$("tranYear").observe("change", function(){
		var tranYear = $("tranYear").value;
		if(isNaN(tranYear)){
			showMessageBox("Field must be of form 0009.");
			$("tranYear").value = "";
		}else{
			$("tranYear").value = parseInt(tranYear).toPaddedString(4);
			validateOldTransactionFields();
		}
	});

	$("tranMonth").observe("change", function(){
		var tranMonth = $("tranMonth").value;
		if(isNaN(tranMonth)){
			showMessageBox("Field must be of form 09.");
			$("tranMonth").value = "";
		}else if((tranMonth <= 0) || (tranMonth >12)){
			showMessageBox("Transaction month does not exist.");
			$("tranMonth").value = "";
		}else{
			$("tranMonth").value = parseInt(tranMonth).toPaddedString(2);
			validateOldTransactionFields();
		}
	});

	$("tranSeqNo").observe("change", function(){
		var tranSeqNo = $("tranSeqNo").value;
		if(isNaN(tranSeqNo)){
			showMessageBox("Field must be of form 09999.");
			$("tranSeqNo").value = "";
		}else{
			$("tranSeqNo").value = parseInt(tranSeqNo).toPaddedString(5);
			validateOldTransactionFields();
		}
	});

	$("oldFundCode").observe("keyup", function(){
		$("oldFundCode").value = ($("oldFundCode").value).toUpperCase();
	});

	$("oldBranch").observe("keyup", function(){
		$("oldBranch").value = ($("oldBranch").value).toUpperCase();
	});

	$("oldFundCode").observe("change", function(){
		validateOldTransactionFields();
	});

	$("oldBranch").observe("change", function(){
		validateOldTransactionFields();
	});
	

	$("oldItemNo").observe("change", function(){
		var oldItem = $("oldItemNo").value;
		if(isNaN(oldItem)){
			showMessageBox("Field must be in the form 09.");
			$("oldItemNo").value = "";
		}else{
			validateOldTransactionFields();
		} 
	});
	

	$("itemNo").observe("change", function(){
		var itemNo = $("itemNo").value;
		if(isNaN(itemNo)){
			showMessageBox("Field must be in the form 09.");
			$("itemNo").value = "";
		}else{
			validateItemNo(itemNo);
		}
	});

	$("btnAdd").observe("click", function(){
		var itemNo = $("itemNo").value;
		var amt = ($("amount").value).replace(/,/g, '');

		if($("btnAdd").value == "Add"){
			if(checkRequiredFields() && validateItemNo(itemNo)&& validateCollnAmount(amt)){
				addNewGOFCRow();
				changeTag = 1;
			}
		}else if($("btnAdd").value == "Update"){
			if(checkRequiredFields() && validateCollnAmount(amt)){
				addModifiedGOFCRow();
				changeTag = 1;
			}
		}
	});

	$("btnDelete").observe("click", function(){
		if(currentRow >= 0){
			if(objGOFC[currentRow].orPrintTag == "Y"){
				showMessageBox("Delete not allowed.  This record was created before the OR was printed.",
								imgMessage.ERROR);
				return false;
			}else{
				validateDeletionOfItem();
			}
		}
	});

	$("btnCancelCollns").observe("click", function(){
		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Ok", "No", "Cancel", saveAndCancel, showCollnsForOtherOffices, "");
		}else{
			showCollnsForOtherOffices();
		}
	});

	$("btnSaveCollns").observe("click", function(){
		if(changeTag == 0){
			showMessageBox("No changes to save.");
		}else{
			pAction = pageActions.save;
			saveGIACOthFundOffCollns();
		}
	});

	function saveAndCancel(){
		pAction = pageActions.cancel;
		saveGIACOthFundOffCollns();
	}

	function generateRow(objGOFC, index){
		var rowContent = '<input type="hidden" value="'+index+'"/>' + 
		'<input type="hidden" name="orPrintTag" value="'+objGOFC.orPrintTag+'">' +
		'<input type="hidden" name="recordStatus" value="'+objGOFC.recordStatus+'">' +
		'<label style="width: 70px;font-size: 10px; text-align: center;" title="'+nvl(objGOFC.itemNo, '-')+'">'+nvl(objGOFC.itemNo, '-')+'</label>' +
		'<label style="width: 120px;font-size: 10px;" value="'+objGOFC.transactionType+'" title="'+nvl(objGOFC.transactionTypeDesc, '-')+'">' +nvl((objGOFC.transactionTypeDesc), '-').truncate(20, '...')+'</label>' +
		'<label style="width: 90px;font-size: 10px;" title="'+nvl(objGOFC.gibrGfunFundCd, '-')+'">' +nvl(objGOFC.gibrGfunFundCd, '-').truncate(15, '...')+'</label>' +
		'<label style="width: 100px;font-size: 10px;" title="'+nvl(objGOFC.gibrBranchName, '-')+'">' +nvl(objGOFC.gibrBranchName, '-').truncate(15, '...')+'</label>' +
		'<label style="width: 110px;font-size: 10px;" title="'+nvl(objGOFC.oldTransNo, '-')+'">' +nvl(objGOFC.oldTransNo, '-')+'</label>' +
		'<label style="width: 80px;font-size: 10px;" title="'+nvl(objGOFC.gofcGibrGfunFundCd, '-')+'">' +nvl(objGOFC.gofcGibrGfunFundCd, '-').truncate(15, '...')+'</label>' +
		'<label style="width: 100px;font-size: 10px;" title="'+nvl(objGOFC.gofcGibrBranchName, '-')+'">' +nvl(objGOFC.gofcGibrBranchName, '-').truncate(15, '...')+'</label>' +
		'<label style="width: 100px;font-size: 10px;" title="'+nvl(objGOFC.particulars, '-')+'">' +nvl((objGOFC.particulars), '-').truncate(15, '...')+'</label>' +
		'<label style="width: 100px;font-size: 10px; text-align: right;" title="'+nvl(formatCurrency(objGOFC.collectionAmt), '-')+'">' +nvl(formatCurrency(objGOFC.collectionAmt), '-')+'</label>';

		return rowContent;
	}

	function validateItemNo(inputItemNo){
		var isValid = true;
		$$("div[name='rowOthFundOffCollns']").each(function(row) {
			var itemNo = row.down("label", 0).innerHTML;
			if(inputItemNo == itemNo){
				showMessageBox("This Item No. already exist.", imgMessage.ERROR);
				$("itemNo").value = "";
				isValid = false;
			}
		});
		return isValid;
	}

	function validateCollnAmount(amt){
		var tranType=$("tranType").options[$("tranType").selectedIndex].value;
		var defaultAmt = $("hidDefaultAmt").value; 
		var isOk = true;
		
		if(tranType != "" && tranType != null){
			if((tranType==1 && amt<0)){
				showMessageBox("Amount should be positive (+).");
				$("amount").value= "";
				isOk = false;
			}else if((tranType==2 && amt>0)){
				showMessageBox("Amount should be negative (-).");
				$("amount").value= "";
				isOk = false;
			}else if(amt==0){
				showMessageBox("Amount should not be zero (0).");
				isOk = false;
			}else if(defaultAmt != "" && (Math.abs(amt) > Math.abs(defaultAmt)) ){
				showMessageBox("Amount should not exceed " + formatCurrency(Math.abs(defaultAmt) * -1)+ ".", imgMessage.ERROR);
				$("amount").value = "";
				isOk = false;
			}else if((tranType==1 && amt>0) || (tranType==2 && amt<0)){
				$("amount").value= formatCurrency(amt);
			}
		}else{
			showMessageBox("Please enter transaction type first.");
			$("amount").value= "";
			isOk = false;
		}
		return isOk;
	}

	function showOldTransModalBox(){
		try{
			Modalbox.show(contextPath+"/GIACCollnsForOtherOfficeController?action=showTransactionNoListing", 
				  {title: "Old Transaction No. Listing", 
				  width: 600,
				  asynchronous: false});
		}catch(e){
			showErrorMessage("showOldTransModalBox", e);
			//showMessageBox("showOldTransModalBox" + e.message);
		}
	}

	function generateItemNo(){
		var lastItemNo = 0;
		for(var i=0; i<objGOFC.length; i++){
			if((parseInt(objGOFC[i].itemNo) > lastItemNo) && (objGOFC[i].recordStatus != -1)){
				lastItemNo = parseInt(objGOFC[i].itemNo);
			}
		}
		$("itemNo").value = parseInt(lastItemNo)+ 1;
	}

	function clickOthFundOffCollnsRow(row){

		$$("div[name='rowOthFundOffCollns']").each(function(r) {
			if (row.id != r.id) {
				r.removeClassName("selectedRow");
			}
		});

		currentRow = parseInt(row.down("input", 0).value);
		var recStatus = parseInt(row.down("input", 2).value);
		
		row.toggleClassName("selectedRow");
		if(row.hasClassName("selectedRow")){
			populateCollnsForOthOffDetails(objGOFC[currentRow]);
			enableButton("btnDelete");
			
			if(isNaN(recStatus)){
				disableButton("btnAdd");

				//replace select with text fields
				$("tranType").hide();
				$("txtTranType").show();
				$("fundCode").hide();
				$("txtFundCode").show();
				$("gibrBranch").hide();
				$("txtBranch").show();
				
				$("itemNo").disable(); 
				$("tranType").readOnly = true;
				$("fundCode").readOnly = true; 
				$("gibrBranch").readOnly = true; 
				$("amount").readOnly = true;
				$("amount").disable();
				$("particulars").readOnly = true;
				$("oldFundCode").readOnly = true;
				$("oldBranch").readOnly = true;
				$("oldItemNo").readOnly = true;
				$$("img[name='imgSearchTranNo']").each(function(image){
					image.hide();
				});
				removeClassNameRequired();
				$("btnAdd").value = "Add";
			}else{
				enableButton("btnAdd");
				if($("tranType").value == 2){
					resetFieldsForTranTypeTwo();
				}else{
					resetFieldBehavior();
					populateCollnsForOthOffDetails(objGOFC[currentRow]);
				}
				$("btnAdd").value = "Update";
			} 
		}else{
			resetFields();
			resetFieldBehavior();
			generateItemNo();
			$("btnAdd").value = "Add";
			disableButton("btnDelete");
		}
	}

	function resetFieldBehavior(){
		resetFields();
		enableButton("btnAdd");
		$("tranType").show();
		$("txtTranType").hide();
		$("fundCode").show();
		$("txtFundCode").hide();
		$("gibrBranch").show();
		$("txtBranch").hide();
		$("itemNo").enable();
		$("amount").enable(); 
		$("tranType").readOnly = false;
		$("fundCode").readOnly = false; 
		$("gibrBranch").readOnly = false; 
		$("amount").readOnly = false;
		$("particulars").readOnly = false;
		$("tranYear").readOnly = true;
		$("tranMonth").readOnly = true;
		$("tranSeqNo").readOnly = true;
		$("oldFundCode").readOnly = true;
		$("oldBranch").readOnly = true;
		$("oldItemNo").readOnly = true;
		
		$$("img[name='imgSearchTranNo']").each(function(image){
			image.hide();
		});
		removeClassNameRequired();
	}

	function removeClassNameRequired(){
		$("tranYear").removeClassName("required");
		$("tranMonth").removeClassName("required");
		$("tranSeqNo").removeClassName("required");
		$("oldFundCode").removeClassName("required");
		$("oldBranch").removeClassName("required");
		$("oldItemNo").removeClassName("required");
		$("divOldTransNo").removeClassName("required");
		$("divOldFundCode").removeClassName("required");
		$("divOldBranch").removeClassName("required");
		$("divOldItemNo").removeClassName("required");
	}

	function resetFieldsForTranTypeTwo(){
		$$("img[name='imgSearchTranNo']").each(function(image){
			image.show();
		});
		
		$("tranYear").readOnly = false;
		$("tranYear").addClassName("required");
		$("tranMonth").readOnly = false;
		$("tranMonth").addClassName("required");
		$("tranSeqNo").readOnly = false;
		$("tranSeqNo").addClassName("required");
		$("oldFundCode").readOnly = false;
		$("oldFundCode").addClassName("required");
		$("divOldFundCode").addClassName("required");
		$("oldBranch").readOnly = false;
		$("oldBranch").addClassName("required");
		$("divOldBranch").addClassName("required");
		$("oldItemNo").readOnly = false;
		$("oldItemNo").addClassName("required");
		$("divOldItemNo").addClassName("required");
		$("tranType").value = 2;
	}

	function populateCollnsForOthOffDetails(objCollns){
		$("itemNo").value       	= objCollns.itemNo; 
		$("oldTransNo").value 		= objCollns.oldTransNo;
		$("tranYear").value			= objCollns.tranYear  == null || objCollns.tranYear  == "" ? "" : parseInt(objCollns.tranYear).toPaddedString(4);
		$("tranMonth").value		= objCollns.tranMonth == null || objCollns.tranMonth == "" ? "" : parseInt(objCollns.tranMonth).toPaddedString(2);
		$("tranSeqNo").value		= objCollns.tranSeqNo == null || objCollns.tranSeqNo == "" ? "" : parseInt(objCollns.tranSeqNo).toPaddedString(5);
		$("tranType").value 		= objCollns.transactionType;
		$("txtTranType").value 		= objCollns.transactionTypeDesc;
		$("oldFundCode").value 		= objCollns.gofcGibrGfunFundCd;
		$("fundCode").value 		= objCollns.gibrGfunFundCd;
		$("txtFundCode").value 		= objCollns.gibrGfunFundCd; 
		$("oldBranch").value 		= objCollns.gofcGibrBranchCd;
		$("gibrBranch").value 		= objCollns.gibrBranchCd;
		$("txtBranch").value 		= objCollns.gibrBranchName; 
		$("oldItemNo").value 		= objCollns.gofcItemNo;
		$("amount").value 			= formatCurrency(objCollns.collectionAmt);
		$("particulars").value 		= objCollns.particulars;    
	}

	function resetFields(){
		$("oldTransNo").value 		= "";
		$("tranType").value 		= "";
		$("txtTranType").value 		= "";
		$("oldFundCode").value 		= "";
		$("fundCode").value 		= "";
		$("txtFundCode").value 		= ""; 
		$("oldBranch").value 		= "";
		$("gibrBranch").value 		= "";
		$("txtBranch").value 		= ""; 
		$("oldItemNo").value 		= "";
		$("amount").value 			= "";
		$("particulars").value 		= "";
		$("hidGaccTranId").value	= "";
		$("hidOldBranchName").value	= "";
		$("tranYear").value	 		= "";
		$("tranMonth").value	 	= "";
		$("tranSeqNo").value	 	= "";
		$("hidDefaultAmt").value	= "";
	}

	function computeTotalCollection(){
		var sumColln = 0;
		var sumRefund = 0;
		$$("div[name='rowOthFundOffCollns']").each(function(row){
			var tranType = row.down("label", 1).getAttribute("value");
			var amt = parseFloat((row.down("label",8).innerHTML).replace(/,/g, ''));
			
			if(tranType == 1){
				sumColln = sumColln + amt;
			}else if(tranType == 2){
				sumRefund = sumRefund + amt;
			}
		});
		$("lblTotalCollections").innerHTML = formatCurrency(sumColln);
		$("lblTotalRefund").innerHTML = formatCurrency(sumRefund);	
	}

	function checkRequiredFields(){
		var isOk = true;
		var fields = ["itemNo", "tranType", "fundCode", "gibrBranch", "amount"];
		var msgField = ["Item No.", "Transaction Type", "Fund Code", "Branch", "Amount"];
		var refundFields = ["tranYear", "tranMonth", "tranSeqNo", "oldFundCode", "oldBranch", "oldItemNo"];
		var msgRefundFields = ["Transaction Year", "Transaction Month", "Transaction Sequence No.", 
		               		   "Old Fund Code", "Old Branch", "Old Item No."];

		for(var i=0; i<fields.length; i++){
			if($(fields[i]).value.blank()){
				showMessageBox(msgField[i] + " is required.", imgMessage.INFO);
				isOk = false;
				return false;
			}
		}

		if($("tranType").value == 2){
			for(var i=0; i<refundFields.length; i++){
				if($(refundFields[i]).value.blank()){
					showMessageBox(msgRefundFields[i] + " is required.", imgMessage.INFO);
					isOk = false;
					return false;
				}
			}
		}
		
		return isOk;
	}

	function validateOldTransactionFields(){
		var tranYear = $("tranYear").value;
		var tranMonth = $("tranMonth").value;
		var tranSeqNo = $("tranSeqNo").value;
		var oldFundCd = $("oldFundCode").value;
		var oldBranch = $("oldBranch").value;
		var oldItemNo = $("oldItemNo").value;
		
		if(tranYear != "" && tranMonth != "" && tranSeqNo != "" &&
		   oldFundCd != "" && oldBranch != "" && oldItemNo != ""){
			getDefaultAmount();
			$("oldTransNo").value = tranYear + "- " + tranMonth + "- " + tranSeqNo;
		}
	}

	function addNewGOFCRow(){
		var rowContent = "";
		var rowGOFC = setObjGOFC();
		
		objGOFC.push(rowGOFC);
		rowContent = generateRow(rowGOFC, lastRowNo);
		addTableRow("row"+ lastRowNo, "rowOthFundOffCollns","collnsForOtherOfficeTableContainer", rowContent, clickOthFundOffCollnsRow);
		lastRowNo = lastRowNo + 1;
		resetFields();
		resetFieldBehavior();
		generateItemNo();
		computeTotalCollection();
		checkIfToResizeTable("collnsForOtherOfficeTableContainer", "rowOthFundOffCollns");
		checkTableIfEmpty("rowOthFundOffCollns", "collnsForOtherOffTableMainDiv");
	}

	function addModifiedGOFCRow(){
		var modifiedGOFC = setObjGOFC();
		var rowContent = "";
		
		for(var i=0; i<objGOFC.length; i++){
			if(modifiedGOFC.itemNo == objGOFC[i].itemNo){
				objGOFC.splice(i, 1, modifiedGOFC);
				rowContent = generateRow(modifiedGOFC, i);
				$("row"+i).update(rowContent);
			}
		}

		resetFields();
		resetFieldBehavior();
		generateItemNo();
		computeTotalCollection();
		checkIfToResizeTable("collnsForOtherOfficeTableContainer", "rowOthFundOffCollns");
		checkTableIfEmpty("rowOthFundOffCollns", "collnsForOtherOffTableMainDiv");
	}

	function setObjGOFC(){
		var rowGOFC = new Object();
		rowGOFC.gaccTranId = objACGlobal.gaccTranId;
		rowGOFC.gibrGfunFundCd = $("fundCode").value;
		rowGOFC.gibrGfunFundDesc = $("fundCode").options[$("fundCode").selectedIndex].text;
		rowGOFC.gibrBranchCd = $("gibrBranch").value;
		rowGOFC.gibrBranchName = $("gibrBranch").options[$("gibrBranch").selectedIndex].text;
		rowGOFC.itemNo = $("itemNo").value;
		rowGOFC.transactionType = $("tranType").value;
		rowGOFC.transactionTypeDesc = $("tranType").options[$("tranType").selectedIndex].text;
		rowGOFC.collectionAmt = ($("amount").value).replace(/,/g, '');
		rowGOFC.gofcGaccTranId = parseInt($("hidGaccTranId").value);
		rowGOFC.gofcGibrGfunFundCd = $("oldFundCode").value;
		rowGOFC.gofcGibrGfunFundDesc = $("oldFundCode").value;
		rowGOFC.gofcGibrBranchCd = $("oldBranch").value;
		rowGOFC.gofcGibrBranchName = $("hidOldBranchName").value;
		rowGOFC.gofcItemNo = $("oldItemNo").value;
		rowGOFC.oldTransNo = $("oldTransNo").value;
		rowGOFC.tranYear   = $("tranYear").value;
		rowGOFC.tranMonth  = $("tranMonth").value;
		rowGOFC.tranSeqNo  = $("tranSeqNo").value;
		rowGOFC.orPrintTag = "N";
		rowGOFC.particulars = $("particulars").value;
		rowGOFC.recordStatus = 0;

		return rowGOFC;
	}

	function validateDeletionOfItem(){
		new Ajax.Request(contextPath+"/GIACCollnsForOtherOfficeController?action=chkGiacOthFundOffCol",{
			evalScripts: true,
			asynchronous: false,
			method: "GET",
			parameters:{
				branchCd: objGOFC[currentRow].gibrBranchCd,
				fundCd: objGOFC[currentRow].gibrGfunFundCd,
				itemNo: objGOFC[currentRow].itemNo,
				gaccTranId: objGOFC[currentRow].gaccTranId
			},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var obj = response.responseText.evalJSON();
					if(obj.message == "SUCCESS"){
						objGOFC[currentRow].recordStatus = -1;
						var row = $("row"+currentRow);
						Effect.Fade(row, {
							duration: .2,
							afterFinish: function(){
								row.remove();
								row.removeClassName("selectedRow");
								checkIfToResizeTable("collnsForOtherOfficeTableContainer", "rowOthFundOffCollns");
								checkTableIfEmpty("rowOthFundOffCollns", "collnsForOtherOffTableMainDiv");
								computeTotalCollection();
								resetFieldBehavior();
								generateItemNo();
								changeTag = 1;
							}
						});
					}else{
						showMessageBox(obj.message, imgMessage.ERROR);
					}
				}
			}
			
		});
	}

	function saveGIACOthFundOffCollns(){
		var addedRows = getAddedJSONObjects(objGOFC);
		var modifiedRows = getModifiedJSONObjects(objGOFC);
		var delRows = getDeletedJSONObjects(objGOFC);
		var setRows = addedRows.concat(modifiedRows);

		new Ajax.Request(contextPath+"/GIACCollnsForOtherOfficeController?action=saveGIACOthFundOffCollns",{
			evalScripts: true,
			asynchronous: false,
			method: "GET",
			parameters:{
						gaccTranId : objACGlobal.gaccTranId,
						tranSource : objACGlobal.tranSource,
						orFlag : objACGlobal.orFlag,
						globalBranchCd: objACGlobal.branchCd,
						globalFundCd:	objACGlobal.fundCd,
						setRows : prepareJsonAsParameter(setRows),
						delRows : prepareJsonAsParameter(delRows)
			},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					if(nvl(response.responseText, "SUCCESS") == "SUCCESS"){
						showWaitingMessageBox("Records successfully saved.", imgMessage.INFO, showCollnsForOtherOffices);							
						changeTag = 0;
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			}
		});
	}
	
	generateItemNo();
	computeTotalCollection();
	
</script>