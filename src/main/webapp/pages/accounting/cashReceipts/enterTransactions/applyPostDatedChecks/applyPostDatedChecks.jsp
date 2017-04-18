<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="ajax" uri="http://ajaxtags.org/tags/ajax" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div class="sectionDiv" id="giacs031MainDiv" changeTagAttr="true">
	<div style="width: 921px;">
		<div id="applyPDCTableDiv" style="padding-top: 10px; padding-bottom: 5px">
			<div id="applyPDCTable" style="height:224px; padding-left: 150px;"></div>
		</div>
		<table style="width: 200px; float: right; margin-right: 170px;">
		<tr>
			<td>Total</td>
			<td><input type="text" id="txtTotal" class="rightAligned" name="txtTotal" value="0.00" readonly="readonly" style="width: 150px; height: 15px;"/></td>
		</tr>
	</table>
	</div>
	<div id="pdcCollectionForm" align="center">
		<table style="margin: 10px; float: left;" border="0">
			<tr>
				<td class="rightAligned" style="width: 20%;">Transaction Type</td>
					<td class="leftAligned">
					<select id="selTranType" name="selTranType" style="width: 200px; margin-right:0px;" class="required" tabindex="1001">
						<option value="">Select..</option>
						<c:forEach var="transactionType" items="${tranTypeLOV}" varStatus="ctr">
							<option value="${transactionType.rvLowValue}">${transactionType.rvLowValue} - ${transactionType.rvMeaning}</option>
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned" width="10%">Assured Name</td>
				<td class="leftAligned changed" width="40%"><input type="text" style="width: 270px; margin-right: 70px;" id="txtAssdName" name="txtAssdName" value="" readonly="readonly"  tabindex="1008" /></td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 20%;">Bill Number</td>
				<td class="leftAligned" >
					<div style="float: left; width: 83px; height: 20px; border: none;">
							<select id="selIssCd" name="selIssCd" style="width: 80px; margin-right: 0px; height: 23px; border: solid 1px gray;" class="required" tabindex="1002">
							<option value="">Select..</option>
							<c:forEach var="issSource" items="${issueSourceList}" varStatus="ctr">
								<option value="${issSource.issCd}">${issSource.issCd}</option>
							</c:forEach>
						</select>
					</div>
					<div id="billCmNoDiv" style="border: 1px solid gray; width: 115px; height: 21px; float: left; background-color: #FFFACD;">
						<input style="width: 89px; border: none;" id="txtBillCmNo" name="txtBillCmNo" type="text" ignoreDelKey="1" value="" class="required rightAligned" tabindex="1003" maxlength="9"/> 
						<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBillCmNo" name="searchBillCmNo" alt="Go" class="required" tabindex="1004" >
					</div>
				</td>
				<td class="rightAligned" width="10%">Policy/Endorsement Number</td>
				<td class="leftAligned" width="40%">
					<input type="text" style="width: 270px; margin-right: 70px;" id="txtPolEndtNo" name="txtPolEndtNo" value="" readonly="readonly"  tabindex="1009" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 20%;" for="instNo">Installment No.</td>
				<td class="leftAligned">
					<div id="instNoDiv" style="border: 1px solid gray; width: 198px; height: 21px; float: left; background-color: #FFFACD;">
						<input style="width: 172px; border: none;" id="txtInstNo" name="txtInstNo" type="text" value="" tabindex="1005" maxlength="2" class="rightAligned required applyWholeNosRegExp" regExpPatt="pDigit02" min="0" max="99" ignoreDelKey="1"/>
						<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchInstNo" name="searchInstNo" alt="Go" class="required" tabindex="1006" />
					</div>
				</td>
				<td class="rightAligned" width="10%">Particulars</td>
				<td class="leftAligned" width="40%">
					<div  style="float: left; width: 276px; border: 1px solid gray; height: 20px;">
						<textarea style="float: left; height: 14px; width: 240px; margin-top: 0; border: none; resize: none;" id="particulars" name="particulars" maxlength="500"  onkeyup="limitText(this,500);" tabindex="1010"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editParticulars"  tabindex="1011"/>
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 20%;" for="premCollectionAmt">Collection Amount</td>
				<td class="leftAligned">
					<input type="text" style="width: 192px; margin-right: 0px;" id="txtCollectionAmt" name="txtCollectionAmt" class="required rightAligned applyDecimalRegExp2" tabindex="1007" regExpPatt="nDeci1202" min="-9999999999.99" max="9999999999.99" customLabel="Collection Amount" maxlength=""/>
				</td>
				<td class="rightAligned">User ID</td>
				<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="211"></td>
			</tr>
			<tr>
				<td class="rightAligned" width="10%"></td>
				<td class="leftAligned" width="40%">
					<div style="margin-left: 50px;">
						<input type="button" style="width: 110px;" id="btnPolicy" class="button" value="Policy"  tabindex="1012" />
					</div>
				</td>
				<td width="" class="rightAligned">Last Update</td>
				<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="212"></td>
			</tr>
			<tr>
				<td class="rightAligned" width="10%"></td>
				<td class="leftAligned" width="40%" align="center">
				</td>
				<td class="rightAligned" width="10%"></td>
				<td class="leftAligned">
					<input type="button" style="width: 110px;" id="btnForeignCurrency" class="button" value="Foreign Currency"  tabindex="1012" />
				</td>
			</tr>
		</table>
	</div>
	<div style="margin: 10px;" align="center">
		<input type="button" class="button" id="btnAdd" value="Add" tabindex="1013">
		<input type="button" class="button" id="btnDelete" value="Delete" tabindex="1014">
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="1101">
	<input type="button" class="button" id="btnSavePDC" value="Save" tabindex="1102">
</div>
<script type="text/javascript">	
	setModuleId("GIACS031");
	setDocumentTitle("PDC Payts");
	initializeAll();
	initializeAccordion();
	var rowIndex = -1;
	changeTag = 0;
	disableButton("btnForeignCurrency");
	disableButton("btnDelete");
	pdcList = JSON.parse('${jsonRecList}');
	oldIssCd = '${oldIssCd}';
	branchCd = '${branchCd}';
	due = "N";
	genAcctFlag = "N";
	
	var objGiacs031 = {};
	
	var objCurrPDC = null;
	
	var applyPDCTable = {
		url : contextPath+"/GIACPdcChecksController?action=showGiacs031&refresh=1&gaccTranId="+objACGlobal.gaccTranId,
		id: "applyPDCTable",
		options: {
			width: '630px',
			pager: {
			},
			onCellFocus : function(element, value, x, y, id) {
				rowIndex = y;
				objCurrPDC = tbgApplyPDC.geniisysRows[y];
				setFieldValues(objCurrPDC);
				tbgApplyPDC.keys.removeFocus(tbgApplyPDC.keys._nCurrentFocus, true);
				tbgApplyPDC.keys.releaseKeys();
			},
			prePager: function(){
				rowIndex = -1;
				setFieldValues(null);
				tbgApplyPDC.keys.removeFocus(tbgApplyPDC.keys._nCurrentFocus, true);
				tbgApplyPDC.keys.releaseKeys();
			},
			onRemoveRowFocus : function(element, value, x, y, id){	
				rowIndex = -1;
				setFieldValues(null);
				tbgApplyPDC.keys.removeFocus(tbgApplyPDC.keys._nCurrentFocus, true);
				tbgApplyPDC.keys.releaseKeys();
			},
			beforeSort : function(){
				if(changeTag == 1){
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
						$("btnSavePDC").focus();
					});
					return false;
				}
			},
			onSort : function(){
				rowIndex = -1;
				setFieldValues(null);
				tbgApplyPDC.keys.removeFocus(tbgApplyPDC.keys._nCurrentFocus, true);
				tbgApplyPDC.keys.releaseKeys();
			},
			onRefresh : function(){
				rowIndex = -1;
				setFieldValues(null);
				tbgApplyPDC.keys.removeFocus(tbgApplyPDC.keys._nCurrentFocus, true);
				tbgApplyPDC.keys.releaseKeys();
			},
			prePager: function(){
				if(changeTag == 1){
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
						$("btnSavePDC").focus();
					});
					return false;
				}
				rowIndex = -1;
				setFieldValues(null);
				tbgApplyPDC.keys.removeFocus(tbgApplyPDC.keys._nCurrentFocus, true);
				tbgApplyPDC.keys.releaseKeys();
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
		columnModel: [
			{
				    id: 'recordStatus',
				    title: '',
				    width: '0',
				    visible: false
				},
				{
					id: 'divCtrId',
					width: '0',
					visible: false 
				},				
				{
					id : "transactionType", 
					title: "Tran Type",
					width: '100px',
					align : "right",
					titleAlign : "right",
				},
				{
					id : "issCd", 
					title: "Issue Code",
					width: '90px',
				},
				{
					id : "premSeqNo", 
					title: "Bill/CM No.",
					width: '120px',
					align : "right",
					titleAlign : "right",
					renderer: function(value){
						return lpad(value, 12, 0);
					}
				},
				{
					id : "instNo", 
					title: "Installment No.",
					width: '120px',
					align : "right",
					titleAlign : "right",
					renderer: function(value){
						return lpad(value, 2, 0);
					}
				},
				{
					id : "collectionAmt", 
					title: "Collection Amount",
					width: '150px',
					geniisysClass : 'money',
					align : "right",
					titleAlign : "right",
					renderer: function(value){
						return formatCurrency(value);
					}
				}
		],
		rows: pdcList.rows
	};
	tbgApplyPDC = new MyTableGrid(applyPDCTable);
	tbgApplyPDC.pager = pdcList;
	tbgApplyPDC.render('applyPDCTable');
	tbgApplyPDC.afterRender = function(){
		computeTotal();
	};
	
	$("searchBillCmNo").observe("click", function(){
		if($F("selTranType") == ""  || $F("selIssCd") == ""){
			showWaitingMessageBox("Please select a Transaction Type and Issue Source first.", "E", function(){
				$("txtBillCmNo").value = "";
			});
		} else {
			checkTranType();
		}
	});
	
	function checkTranType(){
		tranType = $("selTranType").value;
		
		if(tranType == "1"){
			showBillLOV("getGiacs031BillLOV1");
		} else if(tranType == "2"){
			showBillLOV("getGiacs031BillLOV2");
		} else if(tranType == "3"){
			showBillLOV("getGiacs031BillLOV3");
		} else if(tranType == "4"){
			showBillLOV("getGiacs031BillLOV4");
		}
	}
	
	function showBillLOV(action){
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					  action : action,
					  branchCd : $F("selIssCd"),
					  search : $F("txtBillCmNo"),
						page : 1
				},
				title: "List of Invoices",
				width: 670,
				height: 400,
				columnModel: [
		 			{
						id : 'issCd',
						title: 'Issue Code',
						width : '80px',
						align: 'left'
					},
					{
						id : 'premSeqNo',
						title: 'Prem Seq No',
					    width: '100px',
					    align: 'right',
					    renderer: function(value){
					    	return lpad(value,12,0);
					    }
					},
					{
						id : 'refInvNo',
						title: 'Ref Inv No',
					    width: '100px',
					    align: 'left'
					},
					{
						id : 'refPolNo',
						title: 'Ref Pol No',
					    width: '190px',
					    align: 'left'
					},
					{
						id : 'policyNumber',
						title: 'Policy No.',
					    width: '150px',
					    align: 'left'
					},
					{
						id : 'assdName',
						title: 'Assured',
					    width: '150px',
					    align: 'left'
					},
					{
						id : 'property',
						title: 'Property',
					    width: '150px',
					    align: 'left'
					}
				],
				autoSelectOneRecord : true,
				filterText: nvl(($F("txtBillCmNo")), "%"),  
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtBillCmNo").value = lpad(row.premSeqNo,12,0) ;
						$("txtAssdName").value = unescapeHTML2(row.assdName);
						$("txtPolEndtNo").value = unescapeHTML2(row.policyNumber);
						objGiacs031.currencyCd = row.currencyCd;
						objGiacs031.currencyRt = row.currencyRt;
						objGiacs031.currencyDesc = unescapeHTML2(row.currencyDesc);
						objGiacs031.polFlag = row.polFlag;
						checkBill();
					}
				},
				onCancel: function(){
					$("txtBillCmNo").focus();
		  		},
		  		onUndefinedRow: function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtBillCmNo");
					$("txtBillCmNo").value = "";
		  		}
			});
		}catch(e){
			showErrorMessage("showBillLOV",e);
		}
	}
	
	$("searchInstNo").observe("click", function(){
		if($F("selTranType") == ""  || $F("selIssCd") == "" || $F("txtBillCmNo") == ""){
			showWaitingMessageBox("Please select a Transaction Type, Issue Source and Prem Sequence No. first.", "E", function(){
				$("txtInstNo").value = "";
			});
		} else {
			checkTranTypeInst();
		}
	});
	
	function checkTranTypeInst(){
		tranType = $("selTranType").value;
		
		if(tranType == "1"){
			showInstLOV("getGiacs031InstLOV1");
		} else if(tranType == "2"){
			showInstLOV("getGiacs031InstLOV2");
		} else if(tranType == "3"){
			showInstLOV("getGiacs031InstLOV3");
		} else if(tranType == "4"){
			showInstLOV("getGiacs031InstLOV4");
		}
	}
	
	function showInstLOV(action){
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					  action : action,
					  branchCd : $F("selIssCd"),
					  premSeqNo : $F("txtBillCmNo"),
					  gaccTranId : objACGlobal.gaccTranId,
					  filterText: nvl(($F("txtInstNo")), "%"),  
						page : 1
				},
				title: "List of Installments",
				width: 670,
				height: 400,
				columnModel: [
		 			{
						id : 'issCd',
						title: 'Issue Code',
						width : '80px',
						align: 'left'
					},
					{
						id : 'premSeqNo',
						title: 'Prem Seq No',
					    width: '100px',
					    align: 'right',
					    renderer: function(value){
					    	return lpad(value,12,0);
					    }
					},
					{
						id : 'instNo',
						title: 'Installement No.',
					    width: '150px',
					    align: 'right',
					    renderer: function(value){
					    	return lpad(value,2,0);
					    }
					},
					{
						id : 'collectionAmt',
						title: 'Collection Amount',
					    width: '150px',
					    align: 'right',
					    renderer: function(value){
					    		return formatCurrency(value);
					    }
					}
				],
				autoSelectOneRecord : true,
				filterText: nvl(($F("txtInstNo")), "%"),    
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtInstNo").value = lpad(row.instNo,2,0);
						if($F("selTranType") == 2 || $F("selTranType") == 4){
							$("txtCollectionAmt").value = formatCurrency(row.collectionAmt * -1);
						} else {
							$("txtCollectionAmt").value = formatCurrency(row.collectionAmt);
						}
						validateCollectionAmt(row.totalBalance, $F("txtCollectionAmt").replace(/,/g, ""));
					}
				},
				onCancel: function(){
					$("txtInstNo").focus();
		  		},
		  		onUndefinedRow: function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtInstNo");
		  		}
			});
		}catch(e){
			showErrorMessage("showInstLOV",e);
		}
	}
	
	$("txtBillCmNo").observe("change", function(){
		if($F("txtBillCmNo") != ""){
			if($F("selTranType") == ""  || $F("selIssCd") == ""){
				showWaitingMessageBox("Please select a Transaction Type and Issue Source first.", "E", function(){
					$("txtBillCmNo").value = "";
				});
			} else {
				$("txtAssdName").value = "";
				$("txtPolEndtNo").value = "";
				$("txtInstNo").value = "";
				$("txtCollectionAmt").value = "";
				objGiacs031.currencyCd = "";
				objGiacs031.currencyRt = "";
				objGiacs031.currencyDesc = "";
				objGiacs031.polFlag = "";
				checkTranType();
			}
		} else {
			$("txtBillCmNo").value = "";
			$("txtAssdName").value = "";
			$("txtPolEndtNo").value = "";
			$("txtInstNo").value = "";
			$("txtCollectionAmt").value = "";
			objGiacs031.currencyCd = "";
			objGiacs031.currencyRt = "";
			objGiacs031.currencyDesc = "";
			objGiacs031.polFlag = "";
		}
	});
	
	$("txtInstNo").observe("change", function(){
		if($F("txtInstNo") != ""){
			if($F("selTranType") == ""  || $F("selIssCd") == "" || $F("txtBillCmNo") == ""){
				showWaitingMessageBox("Please select a Transaction Type, Issue Source and Prem Sequence No. first.", "E", function(){
					$("txtInstNo").value = "";
				});
			} else {
				$("txtCollectionAmt").value = "";
				checkTranTypeInst();
			}
		} else {
			$("txtInstNo").value = "";
			$("txtCollectionAmt").value = "";
		}
	});
	
	$("editParticulars").observe("click",function() {
		showOverlayEditor("particulars", 500, $("particulars").hasAttribute("readonly"));
	});
	
	$("selTranType").observe("change",function() {
		$("txtBillCmNo").value = "";
		$("txtAssdName").value = "";
		$("txtPolEndtNo").value = "";
		$("txtInstNo").value = "";
		$("txtCollectionAmt").value = "";
		$("particulars").value = "";
	});
	
	function setFieldValues(rec){
		try{
			$("selTranType").value = 		(rec == null ? "" : (rec.transactionType));
			$("selIssCd").value = 			(rec == null ? "" : unescapeHTML2(rec.issCd));
			$("txtBillCmNo").value = 		(rec == null ? "" : lpad(rec.premSeqNo,12,0));
			$("txtInstNo").value = 			(rec == null ? "" : lpad(rec.instNo,2,0));
			$("txtCollectionAmt").value = 	(rec == null ? "" : formatCurrency(rec.collectionAmt));
			$("txtAssdName").value = 		(rec == null ? "" : unescapeHTML2(rec.assdName));
			$("txtPolEndtNo").value = 		(rec == null ? "" : unescapeHTML2(rec.policyNo));
			$("particulars").value = 		(rec == null ? "" : unescapeHTML2(rec.particulars));
			$("txtUserId").value = 			(rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = 		(rec == null ? "" : rec.lastUpdate);
			
			rec == null ? $("selTranType").disabled = false : $("selTranType").disabled = true;
			rec == null ? $("selIssCd").disabled = false : $("selIssCd").disabled = true;
			rec == null ? $("txtBillCmNo").readOnly = false : $("txtBillCmNo").readOnly = true;
			rec == null ? $("txtInstNo").readOnly = false : $("txtInstNo").readOnly = true;
			rec == null ? $("particulars").readOnly = false : $("particulars").readOnly = true;
			rec == null ? $("txtCollectionAmt").readOnly = false : $("txtCollectionAmt").readOnly = true;
			rec == null ? enableSearch("searchBillCmNo") : disableSearch("searchBillCmNo");
			rec == null ? enableSearch("searchInstNo") : disableSearch("searchInstNo");
			
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			rec == null ? enableButton("btnAdd") : disableButton("btnAdd");
			
			rec == null ? disableButton("btnForeignCurrency") : checkCurrencySw();
			
			objCurrPDC = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.gaccTranId = objACGlobal.gaccTranId; 
			obj.issCd = escapeHTML2($F("selIssCd"));
			obj.premSeqNo = $F("txtBillCmNo");
			obj.instNo = $F("txtInstNo");
			obj.collectionAmt = $F("txtCollectionAmt").replace(/,/g, "");
			obj.particulars = escapeHTML2($F("particulars"));
			obj.transactionType = $F("selTranType");
			obj.assdName = escapeHTML2($F("txtAssdName"));
			obj.policyNo = escapeHTML2($F("txtPolEndtNo"));
			obj.currencyCd  = objGiacs031.currencyCd;
			obj.currencyRt  = objGiacs031.currencyRt;
			obj.currencyDesc  = objGiacs031.currencyDesc;
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGiacs031;
			var pdc = setRec(objCurrPDC);
			tbgApplyPDC.addBottomRow(pdc);
			changeTag = 1;
			setFieldValues(null);
			computeTotal();
			tbgApplyPDC.keys.removeFocus(tbgApplyPDC.keys._nCurrentFocus, true);
			tbgApplyPDC.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}	
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("pdcCollectionForm")){
				var addedSameExists = false;
				var deletedSameExists = false;	
				
				for ( var i = 0; i < tbgApplyPDC.geniisysRows.length; i++) {
					if (tbgApplyPDC.geniisysRows[i].recordStatus == 0 || tbgApplyPDC.geniisysRows[i].recordStatus == 1) {
						if (tbgApplyPDC.geniisysRows[i].gaccTranId == objACGlobal.gaccTranId && tbgApplyPDC.geniisysRows[i].issCd == $F("selIssCd")
								&& tbgApplyPDC.geniisysRows[i].premSeqNo == parseInt($F("txtBillCmNo")) && tbgApplyPDC.geniisysRows[i].instNo == parseInt($F("txtInstNo"))) {
							addedSameExists = true;
						}
					} else if (tbgApplyPDC.geniisysRows[i].recordStatus == -1) {
						if (tbgApplyPDC.geniisysRows[i].gaccTranId == objACGlobal.gaccTranId && tbgApplyPDC.geniisysRows[i].issCd == $F("selIssCd")
								&& tbgApplyPDC.geniisysRows[i].premSeqNo == parseInt($F("txtBillCmNo")) && tbgApplyPDC.geniisysRows[i].instNo == parseInt($F("txtInstNo"))){
							deletedSameExists = true;
						}
					}
				}
				if ((addedSameExists && !deletedSameExists)|| (deletedSameExists && addedSameExists)) {
					showMessageBox("Record already exists with the same gacc_tran_id, iss_cd, prem_seq_no and inst_no.", "E");
					return;
				} else if (deletedSameExists && !addedSameExists) {
					addRec();
					return;
				}
				new Ajax.Request(contextPath + "/GIACPdcChecksController", {
					parameters : {
						action : "valAddRec",
						gaccTranId : objACGlobal.gaccTranId,
						issCd : $F("selIssCd"),
						premSeqNo :  $F("txtBillCmNo"),
						instNo : $F("txtInstNo")
					},
					onCreate : showNotice("Processing, please wait..."),
					onComplete : function(response) {
						hideNotice();
						if (checkErrorOnResponse(response)
								&& checkCustomErrorOnResponse(response)) {
							addRec();
						}
					}
				});
			}
		} catch (e) {
			showErrorMessage("valAddRec", e);
		}
	}
	
	function deleteRec() {
		changeTagFunc = saveGiacs031;
		objCurrPDC.recordStatus = -1;
		tbgApplyPDC.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
		computeTotal();
	}
	
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", deleteRec);
	$("btnSavePDC").observe("click", saveGiacs031);
	
	
	function saveGiacs031(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		
		//if (objACGlobal.tranSource == "OP" ||objACGlobal.tranSource == "OR") {
			//if(objACGlobal.orFlag != "P" || objACGlobal.orFlag == "N"){
				var setRows = getAddedAndModifiedJSONObjects(tbgApplyPDC.geniisysRows);
				var delRows = getDeletedJSONObjects(tbgApplyPDC.geniisysRows);
				
				new Ajax.Request(contextPath+"/GIACPdcChecksController", {
					method: "POST",
					parameters : {action : "saveGiacs031",
							 	  setRows : prepareJsonAsParameter(setRows),
							 	  delRows : prepareJsonAsParameter(delRows),
							 	  fundCd: objACGlobal.fundCd,
							 	  branchCd: objACGlobal.branchCd,
							 	  gaccTranId: objACGlobal.gaccTranId
							 	  },
					onCreate : showNotice("Processing, please wait..."),
					onComplete: function(response){
						hideNotice();
						if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
							changeTagFunc = "";
							showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
								tbgApplyPDC._refreshList();
							});
							changeTag = 0;
						}
					}
				});
			//}
		//}
	}
	
	function checkBill(){
		if(objGiacs031.polFlag == "5"){
			showWaitingMessageBox("This is a spoiled policy.", imgMessage.INFO, function(){
				$("txtBillCmNo").value = "";
				$("txtAssdName").value = "";
				$("txtPolEndtNo").value = "";
				$("txtInstNo").value = "";
				$("txtCollectionAmt").value = "";
				objGiacs031.currencyCd = "";
				objGiacs031.currencyRt = "";
				objGiacs031.currencyDesc = "";
				objGiacs031.polFlag = "";
			});
		}
	}
	
	function validateCollectionAmt(totalBalance, collectionAmt){
		if($F("selTranType") == 1 || $F("selTranType") == 4){
			if(collectionAmt < 0){
				showWaitingMessageBox("Negative transactions are not accepted.", imgMessage.INFO, function(){
					$("txtInstNo").value = "";
					$("txtCollectionAmt").value = "";
				});
			}
		} else {
			if(collectionAmt > 0){
				showWaitingMessageBox("Positive transactions are not accepted.", imgMessage.INFO, function(){
					$("txtInstNo").value = "";
					$("txtCollectionAmt").value = "";
				});
			}
		}
		if(Math.abs(collectionAmt) > Math.abs(totalBalance)){
			showWaitingMessageBox("Collection amount should not exceed "+ formatCurrency(totalBalance) + ".", imgMessage.INFO, function(){
				if($F("selTranType") == 2 || $F("selTranType") == 4){
					$("txtCollectionAmt").value = formatCurrency(totalBalance * -1);
				} else {
					$("txtCollectionAmt").value = formatCurrency(totalBalance);
				}
			});
		} else if (collectionAmt == 0){
			showWaitingMessageBox("Collection amount cannot be zero.", imgMessage.INFO, function(){
				$("txtInstNo").value = "";
				$("txtCollectionAmt").value = "";
			});
		}
	}
	
	function checkCurrencySw(){
		if(objCurrPDC.currencyRt == 1){
			disableButton("btnForeignCurrency");
		} else {
			enableButton("btnForeignCurrency");
		}
	}
	
	$("btnForeignCurrency").observe("click", showForeignCurrency);
	
	function showForeignCurrency() {
		try {
			overlayForeignCurrency = Overlay.show(contextPath
					+ "/GIACPdcChecksController", {
				urlContent : true,
				urlParameters : {
					action : "showGiacs031ForeignCurr",
					ajax : "1",
					currencyCd : objCurrPDC.currencyCd,
					currencyDesc : objCurrPDC.currencyDesc,
					currencyRt : objCurrPDC.currencyRt,
					fcurrencyAmt : objCurrPDC.fcurrencyAmt,
					},
				title : "Foreign Currency",
				 height: 150,
				 width: 403,
				draggable : true
			});   
		} catch (e) {
			showErrorMessage("showForeignCurrency", e);
		}
	}
	
	function computeTotal(){
		var total = 0.00;
		if(tbgApplyPDC.geniisysRows.length > 0){
			for(var i = 0; tbgApplyPDC.geniisysRows.length > i; i++){
				if(tbgApplyPDC.geniisysRows[i].recordStatus != -1){
					total = parseFloat(total) + parseFloat(tbgApplyPDC.geniisysRows[i].collectionAmt.replace(/,/g, ""));
				}
			}
			$("txtTotal").value = formatCurrency(total);
		} else {
			$("txtTotal").value = "0.00";
		}
	}	
	
	function showPolicy() {
		try {
			overlayPolicy = Overlay.show(contextPath
					+ "/GIACPdcChecksController", {
				urlContent : true,
				urlParameters : {
					action : "queryPolicy",
					ajax : "1"
					},
				title : "Policy Entry",
				 height: 165,
				 width: 460,
				draggable : true
			});   
		} catch (e) {
			showErrorMessage("showPolicy", e);
		}
	}
	//added by Robert SR 5189 12.22.15
	function disableGIACS031(){
		try {
			$("selTranType").disabled = true;
			$("selIssCd").disabled = true;
			$("txtBillCmNo").readOnly = true;
			$("txtInstNo").readOnly = true;
			$("particulars").readOnly = true;
			$("txtCollectionAmt").readOnly = true;
			$("selTranType").style.backgroundColor = "#EEEEEE";
			$("selIssCd").style.backgroundColor = "#EEEEEE";
			$("billCmNoDiv").style.backgroundColor = "#EEEEEE";
			$("instNoDiv").style.backgroundColor = "#EEEEEE";
			$("txtCollectionAmt").style.backgroundColor = "#EEEEEE";
			$("txtBillCmNo").style.backgroundColor = "#EEEEEE";
			$("txtInstNo").style.backgroundColor = "#EEEEEE";
			disableSearch("searchBillCmNo");
			disableSearch("searchInstNo");
			disableButton("btnDelete");
			disableButton("btnAdd");
			disableButton("btnPolicy");
			disableButton("btnSavePDC");
		} catch(e){
			showErrorMessage("disableGIACS031", e);
		}
	}
	
	if(objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C" || nvl(objACGlobal.queryOnly,"N") == "Y"){
		disableGIACS031();
	}
	//end of codes by Robert SR 5189 12.22.15
	$("btnPolicy").observe("click", showPolicy);
	$("btnCancel").observe("click", function(){
		fireEvent($("acExit"), "click");
	});
</script>		