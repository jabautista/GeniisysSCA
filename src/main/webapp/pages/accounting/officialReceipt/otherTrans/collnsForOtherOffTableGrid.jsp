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
	<div id="collnsForOtherOffTableGridSectionDiv" class="sectionDiv" style="height: 305px; border: none; margin-bottom: 60px;">
			<div id="collnsForOtherOffTableGridDiv" style="padding: 10px;">
				<div id="collnsForOtherOffTableGrid" style="height: 250px; width: 900px;"></div>
			</div>
			<div id="collnsTotalAmt" name="collnsTotalAmt" style="margin-top: 20px; padding-left: 68%;">
				<table>
					<tr>
						<td class="rightAligned">Total Collections</td>
						<td class="leftAligned"><input type="text" id="totalCollAmt" name="totalCollAmt" readonly="readonly" value="" class="money" tabindex=201/></td>
					</tr>
					<tr>
						<td class="rightAligned">Total Refund/Reclass</td>
						<td class="leftAligned"><input type="text" id="totalRefAmt" name="totalRefAmt" readonly="readonly" value="" class="money" tabindex=202/></td>
					</tr>
				</table>
			</div>
	</div>
	<table align="center" style="margin: 10px;">
		<tr>
			<td class="rightAligned" style="width: 160px;">Item No.</td>
			<td class="leftAligned">
				<input type="text" class="required" id="itemNo" maxlength="2" tabindex=203></input>
			</td>
			<td class="rightAligned" style="width: 160px;">Old Tran No.</td>
			<td class="leftAligned">
			<div id="divOldTransNo" style="border:none; width: 228px; height: 19px; float: left">
				<input type="text" id="tranYear"  style="width:55px;"  readonly="readonly" maxlength="4" title="Transaction year" tabindex=208> -
				<input type="text" id="tranMonth" style="width:40px;" readonly="readonly" maxlength="2" title="Transaction month" tabindex=209> -
				<input type="text" id="tranSeqNo" style="width:55px;"  readonly="readonly" maxlength="5" title="Transaction Sequence No." tabindex=210>
				<img style="float: right; display: none;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgOldTran" name="imgSearchTranNo" alt="Go" tabindex=211/>
			</div>
				<input type="hidden" id="hidGaccTranId" name="hidGaccTranId" value="">
				<input type="hidden" id="oldTransNo" name="oldTransNo" value="">
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 160px;">Tran Type</td>
			<td class="leftAligned">
				<select id="tranType" class="required" style="width: 230px;" tabindex=204>
					<option value=""></option>
					<c:forEach var="tranType" items="${transType}">
						<option desc="${tranType.rvMeaning}" value="${tranType.rvLowValue}">${tranType.rvLowValue} - ${tranType.rvMeaning}</option>
					</c:forEach>
				</select>
				<input type="text" class="required" id="txtTranType" style="display: none; width: 222px;" value="" readonly="readonly" tabindex=204>
			</td>
			<td class="rightAligned" style="width: 160px;">Old Fund Code</td>
			<td class="leftAligned">
				<div id="divOldFundCode" style="border: 1px solid gray; width: 228px; height: 20px; float: left; margin-right: 7px">
					<input type="text" id="oldFundCode" name="oldFundCode" style="width: 200px; border: none; float: left; height: 12px;" readonly="readonly" maxlength="3" tabindex=212></input>
					<img style="float: right; display: none;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgOldFundCode" name="imgSearchTranNo" alt="Go" tabindex=213/>
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 160px;">Fund Code</td>
			<td class="leftAligned">
				<select id="fundCode" class="required" style="width: 230px;" tabindex=205>
					<option value=""></option>
					<c:forEach var="fundList" items="${fundCdList}">
						<option  label="${fundList.gibrBranchCd}" value="${fundList.gibrGfunFundCd}">${fundList.gibrGfunFundDesc} - ${fundList.gibrBranchName} </option>
					</c:forEach>
				</select>
				<input type="text" class="required" id="txtFundCode" style="display: none; width: 222px;" value="" readonly="readonly" tabindex=205>
			</td>
			<td class="rightAligned" style="width: 160px;">Old Branch Code</td>
			<td class="leftAligned">
				<div id="divOldBranch" style="border: 1px solid gray; width: 228px; height: 20px; float: left; margin-right: 7px">
					<input type="text" id="oldBranch" name="oldTransNo" style="width: 200px; border: none; float: left; height: 12px;" readonly="readonly" maxlength="2" tabindex=214></input>
					<img style="float: right; display: none;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgOldBranch" name="imgSearchTranNo" alt="Go" tabindex=215/>
					<input type="hidden" id="hidOldBranchName" name="hidOldBranchName" value="">
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 160px;">Branch</td>
			<td class="leftAligned">
				<select id="gibrBranch" class="required" style="width: 230px;" tabindex=206>
					<option value=""></option>
					<c:forEach var="branch" items="${fundCdList}">
						<option  label="${branch.gibrGfunFundCd}" value="${branch.gibrBranchCd}">${branch.gibrBranchName}</option>
					</c:forEach>
				</select>
				<input type="text" class="required" id="txtBranch" style="display: none; width: 222px;" value="" readonly="readonly" tabindex=206>
			</td>
			<td class="rightAligned" style="width: 160px;">Old Item No.</td>
			<td class="leftAligned">
				<div id="divOldItemNo" style="border: 1px solid gray; width: 228px; height: 20px; float: left; margin-right: 7px">
					<input type="text" id="oldItemNo" name="oldTransNo" style="width: 200px; border: none; float: left; height: 12px;" readonly="readonly" maxlength="2" tabindex=216></input>
					<img style="float: right; display: none;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgOldItemNo" name="imgSearchTranNo" alt="Go" tabindex=217/>
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 160px;">Amount</td>
			<td class="leftAligned">
				<input type="text" class="required" id="amount" style="width: 222px; text-align: right;" tabindex=207/>
				<input type="hidden" id="hidDefaultAmt" value="">
			</td>
			<td class="rightAligned" style="width: 160px;">Particulars</td>
			<td class="leftAligned">
				<input type="text" id="particulars" style="width: 222px;" maxlength="500" tabindex=218 class="txtReadOnly"/>
			</td>
		</tr>
	</table>
	<div style="margin: 10px;">
		<input type="button" class="button cancelORBtn" style="width: 80px;font-size: 12px;text-align: center" id="btnAdd" value="Add" tabindex=219/>
		<input type="button" class="disabledButton cancelORBtn" style="width: 80px;font-size: 12px;text-align: center" id="btnDelete" value="Delete" tabindex=220>
	</div>
</div>
<div id="collnsForOtherOffButtonsDiv" class="buttonsDiv" style="float:left;">			
	<input type="button" style="width: 70px; font-size: 12px;" id="btnCancelCollns" name="btnCancelCollns"	class="button" value="Cancel" tabindex=221/>
	<input type="button" style="width: 70px; font-size: 12px;" id="btnSaveCollns" 	name="btnSaveCollns"	class="button cancelORBtn" value="Save" tabindex=222/>
</div>

<script type="text/javascript">
	setModuleId("GIACS012");
	setDocumentTitle("Collections for Other Offices");
	var content = "";
	var currentRow = -1;
	var lastRowNo = 0;
	var itemNoList = JSON.parse('${itemNoList}');
	try{
		var collnsObject = new Object();
		var objCollnRows = [];
		collnsObject.collnsObjectListTableGrid = JSON.parse('${collnsJSON}'.replace(/\\/g, '\\\\'));
		collnsObject.collnsObjectList = collnsObject.collnsObjectListTableGrid.rows || [];
		
		var collnsTableModel = {
				url : contextPath+ "/GIACCollnsForOtherOfficeController?action=showCollnsForOtherOfficesTableGrid&gaccTranId="+objACGlobal.gaccTranId,
				options : {
					title : '',
					width : '900px',
					onCellFocus : function(element, value, x, y, id) {
						collnsTableGrid.keys.releaseKeys();
						selectedIndex = y;
						var obj = collnsTableGrid.geniisysRows[y];
						populateCollnsForOthOffDetails(obj);
					},
					onCellBlur : function() {
						observeChangeTagInTableGrid(collnsTableGrid);
					},
					onRemoveRowFocus : function() {
						selectedIndex = -1;
						populateCollnsForOthOffDetails(null);
					},
					onSort : function(){
						populateCollnsForOthOffDetails(null);
					},
					postPager : function(){
						populateCollnsForOthOffDetails(null);
					},
					toolbar : {
						elements : [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
						onRefresh: function(){
							populateCollnsForOthOffDetails(null);
						},
						onFilter: function(){
							populateCollnsForOthOffDetails(null);
						}
					}
				},
				columnModel : [ 
				{
					id : 'recordStatus',
					title : '',
					width : '0',
					visible : false,
					editor : 'checkbox'
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},
				{
					id : 'itemNo',
					title : 'Item No.',
					width : '50px',
					filterOption : true,
					align : 'right',
					titleAlign : 'right'
				}, 
				{
					id : 'transactionTypeAndDesc',
					title : 'Tran Type',
					width : '100px',
					filterOption : true
				}, 
				{
					id : 'gibrGfunFundCd',
					title : 'Fund Code',
					width : '100px',
					filterOption : true
				},
				{
					id : 'gibrBranchName',
					title : 'Branch',
					width : '100px',
					filterOption : true
				}, 
				{
					id : 'oldTransNo',
					title : 'Old Tran No.',
					width : '100px',
					filterOption : true
				},
				{
					id : 'gofcGibrGfunFundCd',
					title : 'Old Fund',
					width : '100px',
					filterOption : true,
					align : 'right',
					titleAlign : 'right',
					filterOption : true
				},
				{
					id : 'gofcGibrBranchName',
					title : 'Old Branch',
					width : '100px',
					filterOption : true
				},
				{
					id : 'particulars',
					title : 'Particulars',
					width : '106px',
					filterOption : true
				},
				{
					id : 'collectionAmt',
					title : 'Amount',
					width : '89px',
					filterOption : true,
					align : 'right',
					titleAlign : 'right',
					filterOption : true,
					renderer: function(value){
	            		   return formatCurrency(value);
	            	}
				},
				{
					id : 'gibrBranchCd',
					title : '',
					width : '0px',
					visible : false
				},
				{
					id : 'gibrGfunFundDesc',
					title : '',
					width : '0px',
					visible : false
				},
				{
					id : 'transactionType',
					title : '',
					width : '0px',
					visible : false
				},
				{
					id : 'transactionTypeDesc',
					title : '',
					width: '0px',
					visible : false
				}, 
				{
					id : 'gofcGaccTranId',
					title : '',
					width : '0px',
					visible : false
				},
				{
					id : 'gofcGibrGfunFundDesc',
					title : '',
					width : '0px',
					visible : false
				},
				{
					id : 'gofcGibrBranchCd',
					title : '',
					width : '0px',
					visible : false
				},
				{
					id : 'gofcItemNo',
					title : '',
					width : '0px',
					visible : false
				}
				],
				requiredColumns : '',
				resetChangeTag : true,
				rows : collnsObject.collnsObjectList
		};
		collnsTableGrid = new MyTableGrid(collnsTableModel);
		collnsTableGrid.pager = collnsObject.collnsObjectListTableGrid;
		collnsTableGrid.render('collnsForOtherOffTableGrid');
		collnsTableGrid.afterRender = function(){
			objCollnRows = collnsTableGrid.geniisysRows;
			computeTotalCollection();
		};
	}catch(e){
		showErrorMessage("collnsForOtherOffTableGrid", e);
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
	
	$("fundCode").observe("change", function(){
		if(this.value != null || this.value != ""){
			$("gibrBranch").value = this.options[this.selectedIndex].label;
		}
	});
	
	$("gibrBranch").observe("change", function(){
		if(this.value != null || this.value != ""){
			$("fundCode").value = this.options[this.selectedIndex].label;
		}
	});

	$$("img[name='imgSearchTranNo']").each(function(img){
		img.observe("click", function(){
			showOldTransModalBox();
		});
	});

	$("amount").observe("change", function(){
		if($F("btnAdd") == "Add"){
			var amt = $("amount").value;
			if(isNaN(amt)){
				showMessageBox("Invalid amount. Valid value should be from 0.01 to 999,999,999,990.99.");
				$("amount").value = "";
			}else{
				validateCollnAmount(amt);
			}
		}
	});

	$("tranYear").observe("change", function(){
		var tranYear = $F("tranYear");
		if(isNaN(tranYear)){
			showMessageBox("Invalid Transaction Year. Valid value should be from 0 to 9999.");
			$("tranYear").value = "";
		}else{
				$("tranYear").value = (tranyear == "" ? "" :  parseInt(tranYear).toPaddedString(4));
				validateOldTransactionFields();
		}
	});

	$("tranMonth").observe("change", function(){
		var tranMonth = $F("tranMonth");
		if(isNaN(tranMonth)){
			showMessageBox("Invalid Transaction Month. Valid value should be from 0 to 99.");
			$("tranMonth").value = "";
		} else{
			$("tranMonth").value = (tranMonth == "" ? "" : parseInt(tranMonth).toPaddedString(2));
			validateOldTransactionFields();
		}
	});

	$("tranSeqNo").observe("change", function(){
		var tranSeqNo = $F("tranSeqNo");
		if(isNaN(tranSeqNo)){
			showMessageBox("Invalid Transaction Seq No. Valid value should be from 0 to 99999.");
			$("tranSeqNo").value = "";
		}else{
			$("tranSeqNo").value = (tranSeqNo == "" ? "" : parseInt(tranSeqNo).toPaddedString(5));
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
			showMessageBox("Invalid Old Item Code. Valid value should be from 0 to 99.");
			$("oldItemNo").value = "";
		}else{
			validateOldTransactionFields();
		} 
	});
	

	$("itemNo").observe("change", function(){
		var itemNo = $("itemNo").value;
		if(isNaN(itemNo)){
			showMessageBox("Invalid Item No. Valid value should be from 0 to 99.");
			$("itemNo").value = "";
			//generateItemNo();
		}else{
			validateItemNo(itemNo);
		}
	});

	$("btnAdd").observe("click", function(){
		var itemNo = $("itemNo").value;
		var amt = ($("amount").value).replace(/,/g, '');

		var ok = checkRequiredFields() && validateCollnAmount(amt);
		
		if(ok){
			var rowGOFC  = new Object();
			if($F("btnAdd") == "Add"){
				if(validateItemNo(itemNo)){
					rowGOFC = setObjGOFC();
					rowGOFC.recordStatus = 0;
					objCollnRows.push(rowGOFC);
					collnsTableGrid.addBottomRow(rowGOFC);
					changeTag = 1;
					itemNoList.push(rowGOFC.itemNo);
				}
			}else{
				rowGOFC = setObjGOFC();
				for ( var i = 0; i < objCollnRows.length; i++) {
					if(objCollnRows[i].gibrBranchCd == rowGOFC.gibrBranchCd
					&& objCollnRows[i].gibrGfunFundCd == rowGOFC.gibrGfunFundCd
					&& objCollnRows[i].itemNo == rowsGOFC.itemNo
					&& objCollnRows[i].gaccTranId == rowGOFC.gaccTranId
					&& objCollnRow[i].recordStatus != -1){
						rowGOFC.recordStatus = 1;
						objCollnRows.splice(i,1,rowGOFC);
						collnsTableGrid.updateVisibleRowOnly(rowGOFC,collnsTableGrid.getCurrentPosition()[1]);
						changeTag = 1;
					}
				}
			}
 			computeTotalCollection();
			populateCollnsForOthOffDetails(null);
		}
	});

	$("btnDelete").observe("click", function(){
		var delObj = setObjGOFC();
			if(delObj.orPrintTag == "Y"){
				showMessageBox("Delete not allowed.  This record was created before the OR was printed.",
								imgMessage.ERROR);
				return false;
			}else{
				showConfirmBox(
						"Delete Collection For Other Offices Record",
						"Are you sure you want to delete record for item "
								+ delObj.itemNo + "?",
						"OK",
						"Cancel",
						function() {
								if(validateDeletionOfItem(delObj)){
									for ( var i = 0; i < itemNoList.length; i++) {
										if(itemNoList[i] == delObj.itemNo){
											itemNoList.splice(i,1);
											break;
										}
									}
									populateCollnsForOthOffDetails(null);
								}
						}, "");
			}
	 	
	});

	function validateItemNo(inputItemNo){
		var isValid = true;
		for ( var a = 0; a < itemNoList.length; a++) {
			if(itemNoList[a] == inputItemNo){
				showMessageBox("This Item No. already exist.", imgMessage.ERROR);
				$("itemNo").value = "";
				isValid = false;
			}
		}
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
		if(itemNoList.length > 0){
			lastItemNo = Math.max.apply(Math, itemNoList);
		}
		$("itemNo").value = parseInt(lastItemNo)+ 1;
	}

	function resetFieldBehavior(){
		resetFields();
		$("tranType").show();
		$("txtTranType").hide();
		$("fundCode").show();
		$("txtFundCode").hide();
		$("gibrBranch").show();
		$("txtBranch").hide();
		if ((objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR") && objAC.tranFlagState != "C"){
			enableButton("btnAdd");
			$("tranType").readOnly = false;
			$("fundCode").readOnly = false; 
			$("gibrBranch").readOnly = false; 
			$("amount").readOnly = false;
			$("particulars").readOnly = false;
			$("itemNo").enable();
			$("amount").enable(); 
		}
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
		if ((objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR") && objAC.tranFlagState != "C"){ //added by steven 8.15.2012
			$("tranYear").addClassName("required");
			$("tranMonth").addClassName("required");
			$("tranSeqNo").addClassName("required");
			$("oldFundCode").addClassName("required");
			$("divOldFundCode").addClassName("required");
			$("oldBranch").addClassName("required");
			$("divOldBranch").addClassName("required");
			$("oldItemNo").addClassName("required");
			$("divOldItemNo").addClassName("required");
			$("tranYear").readOnly = false;
			$("tranMonth").readOnly = false;
			$("tranSeqNo").readOnly = false;
			$("oldFundCode").readOnly = false;
			$("oldBranch").readOnly = false;
			$("oldItemNo").readOnly = false;
		}
		$("tranType").value = 2;
	}

	function populateCollnsForOthOffDetails(objCollns, onLoad){
		if(objCollns == null){
			resetFieldBehavior();
			generateItemNo();
			disableButton("btnDelete");
			$("btnAdd").value = "Add";
		}else{
			if(objCollns.transactionType == '2'){
				resetFieldsForTranTypeTwo();
				$$("img[name='imgSearchTranNo']").each(function(image){
					image.hide();
				});
				$("oldItemNo").readOnly = true;
			}else{
				resetFieldBehavior();
			}
			$("itemNo").value       	= objCollns.itemNo; 
			$("oldTransNo").value 		= objCollns.oldTransNo;
			$("tranYear").value			= objCollns.tranYear  == null || objCollns.tranYear  == "" ? "" : parseInt(objCollns.tranYear).toPaddedString(4);
			$("tranMonth").value		= objCollns.tranMonth == null || objCollns.tranMonth == "" ? "" : parseInt(objCollns.tranMonth).toPaddedString(2);
			$("tranSeqNo").value		= objCollns.tranSeqNo == null || objCollns.tranSeqNo == "" ? "" : parseInt(objCollns.tranSeqNo).toPaddedString(5);
			$("tranType").value 		= objCollns.transactionType;
			$("txtTranType").value 		= objCollns.transactionTypeAndDesc;
			$("oldFundCode").value 		= objCollns.gofcGibrGfunFundCd;
			$("fundCode").value 		= objCollns.gibrGfunFundCd;
			$("txtFundCode").value 		= objCollns.gibrGfunFundCd; 
			$("oldBranch").value 		= objCollns.gofcGibrBranchCd;
			$("gibrBranch").value 		= objCollns.gibrBranchCd;
			$("txtBranch").value 		= objCollns.gibrBranchName; 
			$("oldItemNo").value 		= objCollns.gofcItemNo;
			$("amount").value 			= formatCurrency(objCollns.collectionAmt);
			$("particulars").value 		= unescapeHTML2(objCollns.particulars);  
			$("btnAdd").value = "Update";
			
			//behaviors
			$("tranType").hide();
			$("txtTranType").show();
			$("fundCode").hide();
			$("txtFundCode").show();
			$("gibrBranch").hide();
			$("txtBranch").show(); 
			$("particulars").readOnly = true;
			disableButton("btnAdd");
			if ((objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR") && objAC.tranFlagState != "C"){ //added by steven 8.15.2012
				enableButton("btnDelete");
				$("itemNo").readOnly = true;
				$("amount").readOnly= true;
			}
		}
		if(objACGlobal.tranFlagState == 'C' || objACGlobal.tranFlagState == 'D' || objACGlobal.queryOnly == "Y"|| objACGlobal.tranFlagState == 'P'){//Added tranFlagState = "P" by pjsantos 01/03/2017, GENQA 5898
			if(onLoad){
				showMessageBox("Page is in query mode only. Cannot change database fields.", imgMessage.INFO);
			}
			disableButton("btnAdd");
			disableButton("btnDelete");
			disableButton("btnSaveCollns");
			$("itemNo").readOnly = true;
			$("tranType").disabled = true;
			$("fundCode").disabled = true;
			$("gibrBranch").disabled = true;
			$("amount").disabled = true;
			$("particulars").readOnly = true;
		}
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
		for ( var i = 0; i < objCollnRows.length; i++) {
			if(objCollnRows[i].recordStatus != -1){
				if(objCollnRows[i].transactionType == '1'){
					sumColln += parseFloat(objCollnRows[i].collectionAmt);
				}else{
					sumRefund += parseFloat(objCollnRows[i].collectionAmt);
				}
			}
		}
		$("totalCollAmt").value = formatCurrency(sumColln);
		$("totalRefAmt").value = formatCurrency(sumRefund);	
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
				showMessageBox("Required fields must be entered.", imgMessage.INFO);
				$(fields[i]).focus();
				isOk = false;
				return false;
			}
		}

		if($("tranType").value == 2){
			for(var i=0; i<refundFields.length; i++){
				if($(refundFields[i]).value.blank()){
					showMessageBox("Required Fields must be entered.", imgMessage.INFO);
					$(refundFields[i]).focus();
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

	function setObjGOFC(){
		var rowGOFC = new Object();
		rowGOFC.gaccTranId = objACGlobal.gaccTranId;
		rowGOFC.itemNo = $("itemNo").value;
		rowGOFC.transactionType = $("tranType").value;
		rowGOFC.transactionTypeAndDesc = $("tranType").options[$("tranType").selectedIndex].text;
		rowGOFC.transactionTypeDesc = rowGOFC.transactionTypeAndDesc.split('-')[1];
		rowGOFC.gibrGfunFundCd = $("fundCode").value;
		rowGOFC.gibrGfunFundDesc = $("fundCode").options[$("fundCode").selectedIndex].text.split('-')[0];
		rowGOFC.gibrBranchCd = $("gibrBranch").value;
		rowGOFC.gibrBranchName = $("gibrBranch").options[$("gibrBranch").selectedIndex].text;
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
		rowGOFC.particulars = escapeHTML2($("particulars").value);
		return rowGOFC;
	}

	function validateDeletionOfItem(obj){
		var isDeleted = false;
		new Ajax.Request(contextPath+"/GIACCollnsForOtherOfficeController?action=chkGiacOthFundOffCol",{
			evalScripts: true,
			asynchronous: false,
			method: "GET",
			parameters:{
				branchCd: obj.gibrBranchCd,
				fundCd: obj.gibrGfunFundCd,
				itemNo: obj.itemNo,
				gaccTranId: obj.gaccTranId
			},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var msg = response.responseText.evalJSON();
					if(msg.message == "SUCCESS"){
						for ( var i = 0; i < objCollnRows.length; i++) {
							if(objCollnRows[i].gibrBranchCd == obj.gibrBranchCd
							&& objCollnRows[i].gibrGfunFundCd == obj.gibrGfunFundCd
							&& objCollnRows[i].itemNo == obj.itemNo
							&& objCollnRows[i].gaccTranId == obj.gaccTranId
							&& objCollnRows[i].recordStatus != -1){
								obj.recordStatus = -1;
								objCollnRows.splice(i,1,obj);
								collnsTableGrid.deleteVisibleRowOnly(collnsTableGrid.getCurrentPosition()[1]);
								changeTag = 1;
								isDeleted = true;
								computeTotalCollection();
							}
						}
					}else{
						showMessageBox(msg.message, imgMessage.ERROR);
					}
				}
			}
			
		});
		return isDeleted;
	}

	function saveGIACOthFundOffCollns(){
		var delRows = getDeletedJSONObjects(objCollnRows);
		var setRows = getAddedAndModifiedJSONObjects(objCollnRows);
		
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
						showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);							
						changeTag = 0;
						populateCollnsForOthOffDetails(null);
						clearObjectRecordStatus(objCollnRows);
						computeTotalCollection();
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			}
		});
	}
	populateCollnsForOthOffDetails(null, true);
	changeTag = 0;
	initializeChangeTagBehavior(saveGIACOthFundOffCollns);
	observeCancelForm("btnCancelCollns", saveGIACOthFundOffCollns, function(){
		if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
			showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
		}else if(objACGlobal.previousModule == "GIACS002"){
			showDisbursementVoucherPage(objGIACS002.cancelDV, "getDisbVoucherInfo");
			objACGlobal.previousModule = null;
		}else if(objACGlobal.previousModule == "GIACS003"){
			if (objACGlobal.hidObjGIACS003.isCancelJV == 'Y'){
				showJournalListing("showJournalEntries","getCancelJV","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
			}else{
				showJournalListing("showJournalEntries","getJournalEntries","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
			}
			objACGlobal.previousModule = null;							
		}else if(objACGlobal.previousModule == "GIACS071"){
			updateMemoInformation(objGIAC071.cancelFlag, objACGlobal.branchCd, objACGlobal.fundCd);
			objACGlobal.previousModule = null;
		}else if(objACGlobal.previousModule == "GIACS149"){	//added by shan 08.08.2013
			showGIACS149Page(objGIACS149.intmNo, objGIACS149.gfunFundCd, objGIACS149.gibrBranchCd, objGIACS149.fromDate, objGIACS149.toDate, null);
			objACGlobal.previousModule = null;
		}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
			showGIACS070Page();
			objACGlobal.previousModule = null;
		}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
			$("giacs031MainDiv").hide();
			$("giacs032MainDiv").show();
			$("mainNav").hide();
		}else{
			editORInformation();	
		}
	} );
	
	//observeSaveForm("btnSaveCollns", saveGIACOthFundOffCollns);
	$("btnSaveCollns").observe("click", function(){
		if(changeTag == 0){
			if($F("tranType") != "" || $F("fundCode") != "" || $F("gibrBranch") != "" || $F("amount") != "" || $F("txtTranType") != ""){
				showMessageBox("You have changes in Colln for Other Offices portion. Press Add button first to apply changes." ,imgMessage.INFO);
			} else {
				showMessageBox(objCommonMessage.NO_CHANGES ,imgMessage.INFO); 
			}
			return false;
		} else {
			saveGIACOthFundOffCollns();
		}
	});
	
	//added by steven 8.15.2012
	function disableGIACS012(){
		reqDivArray = new Array("collnsForOtherOffDiv","collnsForOtherOffButtonsDiv"); 
		disableCancelORFields(reqDivArray);
	}
	//added cancelOtherOR by robert 10302013
	if (objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C" || objACGlobal.queryOnly == "Y"){
		disableGIACS012();
	}
	
	$("acExit").stopObserving("click");
	$("acExit").observe(
			"click",
			function() {
				if (changeTag == 1) {
					showConfirmBox4("CONFIRMATION",
							objCommonMessage.WITH_CHANGES, "Yes", "No",
							"Cancel", function() {
								saveGIACOthFundOffCollns();
								if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
									showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
								}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
									showGIACS070Page();
									objACGlobal.previousModule = null;
								}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
									$("giacs031MainDiv").hide();
									$("giacs032MainDiv").show();
									$("mainNav").hide();
								}else{
									editORInformation();
								}
							}, function() {
								if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
									showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
								}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
									showGIACS070Page();
									objACGlobal.previousModule = null;
								}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
									$("giacs031MainDiv").hide();
									$("giacs032MainDiv").show();
									$("mainNav").hide();
								}else{
									editORInformation();	
								}
								changeTag = 0;
							}, "");
				} else {
					if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
						showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
					}else if(objACGlobal.previousModule == "GIACS002"){
						showDisbursementVoucherPage(objGIACS002.cancelDV, "getDisbVoucherInfo");
						objACGlobal.previousModule = null;
					}else if(objACGlobal.previousModule == "GIACS003"){
						if (objACGlobal.hidObjGIACS003.isCancelJV == 'Y'){
							showJournalListing("showJournalEntries","getCancelJV","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
						}else{
							showJournalListing("showJournalEntries","getJournalEntries","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
						}
						objACGlobal.previousModule = null;							
					}else if(objACGlobal.previousModule == "GIACS071"){
						updateMemoInformation(objGIAC071.cancelFlag, objACGlobal.branchCd, objACGlobal.fundCd);
						objACGlobal.previousModule = null;
					}else if(objACGlobal.previousModule == "GIACS149"){	//added by shan 08.08.2013
						showGIACS149Page(objGIACS149.intmNo, objGIACS149.gfunFundCd, objGIACS149.gibrBranchCd, objGIACS149.fromDate, objGIACS149.toDate, null);
						objACGlobal.previousModule = null;
					}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
						showGIACS070Page();
						objACGlobal.previousModule = null;
					}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
						$("giacs031MainDiv").hide();
						$("giacs032MainDiv").show();
						$("mainNav").hide();
					}else{
						editORInformation();	
					}
				}
			});
	
</script>