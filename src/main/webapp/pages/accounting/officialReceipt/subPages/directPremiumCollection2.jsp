<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div class="sectionDiv" style="float: left; border-top: none;" id="directPremiumCollectionDiv" name="directPremiumCollectionDiv">
	<div id="directPremiumCollectionGrid" style="height: 250px; margin: 10px; margin-bottom: 2px;"></div>	
	<div>
		<table style="margin-bottom: 5px; margin-right: 10px" align="right">
			<tr>
				<td class="rightAligned">Totals </td>
				<td class="leftAligned">
					<input type="text" id="txtTotalCollAmt" name="txtTotalCollAmt" readonly="readonly" style="width: 116px;" class="money" value="" tabindex="1001"/>
				</td>
				<td class="leftAligned">
					<input type="text" id="txtTotalPremAmt" name="txtTotalPremAmt" readonly="readonly" style="width: 116px;" class="money" value="" tabindex="1002"/>
				</td>
				<td class="leftAligned">
					<input type="text" id="txtTotalTaxAmt" name="txtTotalTaxAmt" readonly="readonly" style="width: 116px;" class="money" value="" tabindex="1003"/>
				</td>
			</tr>
		</table>
	</div>
	<div id="directPremiumForm">
		<table style="margin: 10px; float: left;" border="0">
			<tr>
				<td class="rightAligned" style="width: 20%;">Transaction Type</td>
				<td class="leftAligned" style="width: 30%;">
				<select id="tranType" name="tranType" style="width: 200px; margin-right: 70px" class="required changed gdpcRecord" tabindex="1004">
					<option value="">Select..</option>
					<c:forEach var="transactionType" items="${transactionTypeList}"
						varStatus="ctr">
						<option value="${transactionType.rvLowValue }">${transactionType.rvLowValue
						} - ${transactionType.rvMeaning }</option>
					</c:forEach>
				</select>
			</td>
			<td class="leftAligned" id="lblAssdName" width="40%"
				style="font-size: 11px;"><label>Assured Name</label></td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 20%;">Bill Number</td>
				<td class="leftAligned" style="width: 30%;">
					<div style="float: left; width: 88px; height: 21px; border: 1px solid gray; float: left; background-color: #FFFACD; margin-right: 4px;">
						<!-- 	<select id="tranSource" name="tranSource" style="width: 89px; margin-right: 70px; height: 22px; border: solid 1px gray;"
								class="required changed gdpcRecord" tabindex="1005">
							<option value="">Select..</option>
							<c:forEach var="issSource" items="${issueSourceList}" varStatus="ctr">
								<option value="${issSource.issCd}">${issSource.issCd}</option>
							</c:forEach>
						</select> replaced with LOV ::: SR-20000 : shan 08.24.2015-->
						<input style="width: 63px; border: none; height: 13px;" id="tranSource"
							name="tranSource" type="text" value=""
							class="required changed gdpcRecord upper"   reqIndex=2 tabindex="1005" maxlength="9" ignoreDelKey="1"/> <img
							style="float: right;"
							src="${pageContext.request.contextPath}/images/misc/searchIcon.png"
							id="oscmBillIssCd" name="oscmBillIssCd" alt="Go" class="required" tabindex="1028" draggable="false">
					</div>
					<div id="billCmNoDiv" style="border: 1px solid gray; width: 105px; height: 21px; float: left; background-color: #FFFACD;">
						<input style="width: 80px; border: none; height: 13px;" id="billCmNo"
							name="billCmNo" type="text" value=""  ignoreDelKey="1"
							class="required changed gdpcRecord integerNoNegativeUnformattedNoComma"   reqIndex=2 tabindex="1006" maxlength="9"/> <img
							style="float: right;"
							src="${pageContext.request.contextPath}/images/misc/searchIcon.png"
							id="oscmBillCmNo" name="oscmBillCmNo" alt="Go" class="required" tabindex="1028" draggable="false">
					</div>
				</td>
				<td class="leftAligned changed" width="40%"><input type="text"
					style="width: 270px; margin-right: 70px;" id="assdName"
					name="assdName" value="" readonly="readonly"  tabindex="1013" /></td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 20%;" for="instNo">Installment No.</td>
				<td class="leftAligned" style="width: 30%">
					<div id="instNoDiv" style="border: 1px solid gray; width: 198px; height: 21px; float: left; background-color: #FFFACD;">
						<input style="width: 173px; border: none; height: 13px;" id="instNo" name="instNo" type="text" value="" tabindex="1007" maxlength="2"
							class="required changed gdpcRecord applyWholeNosRegExp" ignoreDelKey="1" regExpPatt="pDigit02" min="0" max="99" hasOwnChange="Y" hasOwnBlur="Y" />
						<img style="float: right;"
							src="${pageContext.request.contextPath}/images/misc/searchIcon.png"
							id="oscmInstNo" name="oscmInstNo" alt="Go" class="required" tabindex="1029" draggable="false"/>
					</div>
				<td class="leftAligned" id="lblPolicy" width="40%"
					style="font-size: 11px;">Policy/Endorsement Number</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 20%;" for="premCollectionAmt">Collection Amount</td>
				<td class="leftAligned" style="width: 30%;">
					<input type="text" style="width: 192px; margin-right: 70px;" id="premCollectionAmt" name="premCollectionAmt" value="0.00" 
						class="required money acctAmt gdpcRecord" tabindex="1010" />
				</td>
				<td class="leftAligned" width="40%">
					<input type="text" style="width: 270px; margin-right: 70px;" id="polEndtNo" name="polEndtNo" value="" readonly="readonly"  tabindex="1014" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 20%;">Premium Amount</td>
				<td class="leftAligned" style="width: 30%;">
					<input type="text" style="width: 192px; margin-right: 70px;" id="directPremAmt" name="directPremAmt" value="0.00" 
						class="money acctAmt gdpcRecord" readOnly="readOnly" tabindex="1011" />
						<input type="hidden" id="premZeroRated" name="premZeroRated" value="" />
						<input type="hidden" id="premVatExempt" name="premVatExempt" value="" />
						<input type="hidden" id="premVatable" 	name="premVatable" 	 value="" />
				</td>
				<td class="leftAligned" id="lblParticulars" width="40%"
					style="font-size: 11px;">Particulars</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 20%;">Tax Amount</td>
				<td class="leftAligned" style="width: 30%;">
					<input type="text" style="width: 192px; margin-right: 70px;" id="taxAmt" name="taxAmt" value="0.00" 
						class="money acctAmt gdpcRecord" readOnly="readOnly" tabindex="1012" />
				</td>
				<td class="leftAligned" width="40%">
					<div  style="float: left; width: 275px; border: 1px solid gray; height: 20px;">
						<!-- <input type="text" style="width: 240px; float: left; border: none; height: 15px; padding-top: 0px;" id="particulars" name="particulars" value="" class="gdpcRecord" maxlength="500"  tabindex="1015" /> replaced by christian 03/13/2013-->
						<textarea style="width: 240px; float: left; border: none; height: 15px; padding-top: 0px;" id="particulars" name="particulars" value="" class="gdpcRecord" maxlength="500"  tabindex="1015"></textarea>
						<img id="editParticulars" name="searchGlAcct" alt="Go" style="float: right;" src="${pageContext.request.contextPath}/images/misc/edit.png" tabindex="1016" draggable="false">
					</div>
				</td>
			</tr>
			<tr>
				<td colspan="2" rowspan="2" width="50%" style="text-align: center;">
					<input type="button" style="width: 13px; height: 13px; margin-left: 82px; float: left;" id="btnUpdate" class="button" value=""  tabindex="1017" /> 
					<label style="margin-left: 4px; float: left;" id="lblUpdate">Update</label> 
					<!-- <input type="radio" id="radioAssd" name="payorType" style="margin-left: 20px; float: left" value="A"/>
					<label style="width: 10px;" id="lblRadioAssd">A</label>
					<input type="radio" id="radioIntm" name="payorType" style="float: left" value="I"/>
					<label style="width: 10px;" id="lblRadioIntm">I</label> -->
					<input type="button" style="width: 74px; float: left; margin-left: 117px;" id="btnAdd" status="Add" class="button" value="Add"  tabindex="1021" /> 
					<input type="button" class="button" id="btnDelete" name="btnDelete" value="Delete" style="width: 70px; float: left; margin-left: 4px;" tabindex="1022" /> 
				</td>
				<td height="20px" style="float: left; margin-left: 5px;">
					<input type="button" style="width: 110px;" id="btnForeignCurrency" class="button" value="Foreign Currency"  tabindex="1023" />
				</td>
			</tr>
			<tr>
			</tr>
			<tr>
				<td >
					<div id="choosePayorDiv" style="margin-bottom: 5px;">
						<input type="button" id="btnSpecUpdate" name="btnSpecUpdate" style="margin-left: 82px; float: left; width: 13px; height: 13px;" class="button" value="" tabindex="1018" />
						<label style="margin-left: 4px;" id="lblSpecUpdate">Specific Update</label>
					</div>
				</td>
			</tr>
			<tr>
				<td height="25px">
					<div id="choosePayorDiv" style="margin-top: 2px;">
						<input type="radio" id="radioAssd" name="payorType" style="margin-left: 82px; float: left;" value="A" tabindex="1019" />
						<label style="width: 10px;" id="lblRadioAssd">A</label>
						<input type="radio" id="radioIntm" name="payorType" style="float: left" value="I" tabindex="1020" />
						<label style="width: 10px;" id="lblRadioIntm">I</label>
					</div>
				</td>
			</tr>
			<tr>
				<td colspan="2" width="70%">
					<div style="margin-top: 2px; float: left;">
						<input type="button" style="width: 95px; margin-left: 82px;" id="btnAssured" class="button" value="Assured" tabindex="1024" /> 
						<input type="button" style="width: 95px;" id="btnPlateNo" class="button" value="Plate No."  tabindex="1025" /> 
						<input type="button" style="width: 95px;" id="btnPolicy" class="button" value="Policy" tabindex="1026" />
						<input type="button" style="width: 95px;" id="btnPdcPayts" class="button" value="PDC Payts" tabindex="1027" />
					</div>
				</td>
			</tr>
			<tr>
				<td colspan="2" width="70%">
					<div style="margin-top: 2px; float: left;">
						<input type="button" style="width: 95px; margin-left: 82px;" id="btnDatedCheck" class="button" value="Dated Checks" tabindex="1028" /> 
						<input type="button" style="width: 95px;" id="btnInvoice" class="button" value="Invoice"  tabindex="1029" /> 
						<input type="button" style="width: 95px;" id="btnPremColln" class="button" value="Prem Colln List"  tabindex="1030" />
					</div>
				</td>
			</tr>
		</table>
	</div>
</div>
<div id="breakdownInformationDiv">
	<jsp:include page="../subPages/breakdownInformation.jsp"></jsp:include>
</div>
<div class="buttonsDiv" style="float: left; width: 100%;">
	<input type="button" style="width: 80px;" id="btnCancel" name="btnCancel" class="button" value="Cancel"  tabindex="1033" /> 
	<input type="button" style="width: 80px;" id="btnSaveDirectPrem" name="btnSaveDirectPrem" class="button" value="Save"  tabindex="1034" />
</div>
<script type="text/javascript">
	objDirectPrem = JSON.parse('${gdpcTableGrid}');
	/* $("taxInformationDiv").hide();
	$("premInformationDiv").hide(); */
	
	var giacs007But = '${giacs007But}';
	objAC.checkBillDueDate = '${chkBillPremOverdue}';
	objAC.checkPremAging = '${chkPremAging}';
	objAC.taxPriorityFlag = '${taxPriority}';
	objAC.taxAllocationFlag = '${taxAllocation}';
	objAC.currDtls = eval('${currencyDetails}');
	objAC.directPremExist = ('${directPremExist}');
	objAC.allowCancelledPol = '${allowCancelledPol}';
	objAC.enterAdvPayt ='${enterAdvPayt}';
	objAC.hasCCFunction = nvl('${hasCCFunction}', 'N');
	objAC.enterAdvPayt ='${enterAdvPayt}';
	
	objAC.preChangedFlag = "Y";
	objAC.collectionFlag = 'Y';
	objAC.modalStatus = "Show";
	objAC.overdueStatusFlag = 'Y';
	objAC.payorBtn = 'A';
	objAC.formChanged = 'N';
	objAC.insertTax = 'Y';
	objAC.overideCalled = 'N';
	objAC.btnDcOk = 'N';
	objAC.paytRefNoVis = 'N';
	objAC.fromPolOk = "N";
	
	objAC.rowsToAdd = [];
	
	objAC.objGdpc = [];
	objAC.giacs7TG = true;
	initializeChangeAttribute();
	initializeAllMoneyFields();
	initializeChangeOfValuesChecker();
	initializeAll();
	newformInstance();
	
	enableButton("btnAdd");
	enableButton("btnPolicy");
	// moved sa baba
	/* if(objACGlobal.orTag == "S") {
		disableButtonOnStatus();
	}
	if (objAC.tranFlagState != 'O'){
		disableButtonOnStatus();
	} */
	
	if(giacs007But != 'Y' && giacs007But != 'y') {
		$("btnUpdate").hide();
		$("lblUpdate").hide();
		$("btnSpecUpdate").hide();
		$("lblSpecUpdate").hide();
		$("radioAssd").hide();
		$("lblRadioAssd").hide();
		$("radioIntm").setStyle("margin-left: 82px;");
	} else {
		$("radioAssd").checked = true;
	}
	
	function disableButtonOnStatus() {
		disableButton("btnAdd");
		disableButton("btnDelete");
		disableButton("btnDatedCheck");
		disableButton("btnUpdate");
		disableButton("btnSpecUpdate");
		disableButton("btnSaveDirectPrem");
		$("tranType").disabled = true;
		$("premCollectionAmt").readOnly = true;
		$("instNo").readOnly = true;
		$("billCmNo").readOnly = true;
		$("directPremAmt").readOnly = true;
		$("taxAmt").readOnly = true;
		$("tranSource").disabled = true;
		$("particulars").readOnly = true;
		$("oscmBillIssCd").hide(); // SR-20000 : shan 08.24.2015
		$("oscmBillCmNo").hide();
		$("oscmInstNo").hide();
	}
	
	function initializeChangeOfValuesChecker() {
		objAC.requery = "false";
		$$("input[type='text'].changed").each(function(m) {
			m.observe("change", function() {
				objAC.requery = "true";
			});
		});

		$$("select.changed").each(
			function(m) {
				m.observe("change", function() {

					if (m.id == "tranType") {

						$("tranSource").value = "";
						$("billCmNo").value = "";
						$("instNo").value = "";
						$("premCollectionAmt").value = "0.00";
						$("directPremAmt").value = "0.00";
						$("taxAmt").value = "0.00";
						$("assdName").value = "";
						$("polEndtNo").value = "";
						$("particulars").value = "";

					} else {

						$("billCmNo").value = "";
						$("instNo").value = "";
						$("premCollectionAmt").value = "0.00";
						$("directPremAmt").value = "0.00";
						$("taxAmt").value = "0.00";
						$("assdName").value = "";
						$("polEndtNo").value = "";
						$("particulars").value = "";
					}
					if ($("tranType").selectedIndex != 0) {
							//&& $("tranSource").selectedIndex != 0) {
						enableButton("btnInvoice");
					} else {
						disableButton("btnInvoice");
					}
				});
			});
	}
	
	function newformInstance(){
		disableButton("btnForeignCurrency");
		disableButton("btnInvoice");
		disableButton("btnDelete");
		if(nvl(giacs007But,'N' ) =='Y' && objACGlobal.tranSource == 'OR'){
			if(objACGlobal.orTag == 'S'){
				if(objACGlobal.orFlag== 'N'){
					enableButton("btnUpdate");  
					enableButton("btnSpecUpdate");
				}else{
					disableButton("btnUpdate");  
					disableButton("btnSpecUpdate");
				}
			}else{
				if(objACGlobal.orFlag== 'N' || objACGlobal.orFlag== 'P'){
					enableButton("btnUpdate");  
					enableButton("btnSpecUpdate");
				}else{
					disableButton("btnUpdate");  
					disableButton("btnSpecUpdate");
				}
			}
		}else{
			disableButton("btnUpdate");  
			disableButton("btnSpecUpdate");
		}
		if (objACGlobal.tranSource == "PDC"){
			$("btnPdcPayts").show();
		}else{
			$("btnPdcPayts").hide();
		}
	}
	
	var selectedItemInfoRow = new Object();
	var selectedItemInfo = null;
	
	var gdpcTableModel = {
		id : 1,
		url : contextPath
				+ "/GIACDirectPremCollnsController?action=loadDirectPremForm2&refresh=1&gaccTranId=" + nvl(objACGlobal.gaccTranId, 0),
		options : {
			title : '',
			pager: {}, 
			toolbar : {
				elements : [ MyTableGrid.REFRESH_BTN, , MyTableGrid.FILTER_BTN],
				onRefresh : function() {
					gdpcTableGrid.keys.releaseKeys();
					showBreakdownInfo(false);
				}
			},
			onCellFocus : function(element, value, x, y, id) {
				gdpcTableGrid.keys.removeFocus(gdpcTableGrid.keys._nCurrentFocus, true);
				gdpcTableGrid.keys.releaseKeys();
				selectedItemInfoRow = gdpcTableGrid.geniisysRows[y];
				selectedItemInfo = y;
				rowPremCollnSelectedFnTG(selectedItemInfoRow);
				//robert 12.17.12 added condition
				if (objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C"
						|| objACGlobal.orTag == "S" || (objAC.tranFlagState != undefined && objAC.tranFlagState != 'O') //05.17.2013 
						|| (objACGlobal.orFlag == "P" && nvl(objAC.tranFlagState, "") != 'O') || objACGlobal.queryOnly == "Y"){ 
					disableButton("btnDelete");
				}
				tagButtons(selectedItemInfoRow);
				showBreakdownInfo(true);
			},
			onRemoveRowFocus : function() {
				gdpcTableGrid.keys.removeFocus(gdpcTableGrid.keys._nCurrentFocus, true);
				gdpcTableGrid.keys.releaseKeys();
				rowPremCollnDeselectedFnTG();
				//robert 12.17.12 added condition
				if (objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C"
						|| objACGlobal.orTag == "S" || (objAC.tranFlagState != undefined && objAC.tranFlagState != 'O') 
						|| (objACGlobal.orFlag == "P" && objACGlobal.orTag != "*" && nvl(objAC.tranFlagState, "") != 'O') || objACGlobal.queryOnly == "Y"){ 
					disableGIACS007();
				}
				showBreakdownInfo(false);
				selectedItemInfo = null;
			},
			beforeSort: function(){
				if(objAC.formChanged == 'Y'){
					showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
							saveDirectPrem, function(){
														gdpcTableGrid._refreshList();
														objAC.formChanged = "N";
														changeTag = 0;
													}, "");	
					return false;
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
			id : 'assdName',
			title : 'Assured',
			width : '214',
			editable : false,
			filterOption : true
		}, {	
			id: 'tranType',
			title: 'Tran. Type',
			width: '60px',
			align: 'right',
			titleAlign: 'right',
			filterOption: true,
			type: 'number',
			filterOptionType: 'integerNoNegative'
		},{
			id : 'issCd',
			title : 'Iss. Cd',
			titleAlign : 'center',
			width : '60',
			align: 'center',
			editable : false,
			filterOption : true
		}, {	
			id: 'premSeqNo',
			title: 'Bill/CM No.',
			width: '100px',
			align: 'right',
			titleAlign: 'right',
			filterOption: true,
			type: 'number',
			filterOptionType: 'integerNoNegative',
			renderer : function(value){
				return lpad(value.toString(), 12, "0");					
			}
		}, {	
			id: 'instNo',
			title: 'Inst No.',
			width: '60px',
			align: 'right',
			titleAlign: 'right',
			filterOption: true,
			type: 'number',
			filterOptionType: 'integerNoNegative',
			renderer : function(value){
				return lpad(value.toString(), 2, "0");					
			}
		}, {
			id : 'collAmt',
			title : 'Collection Amount',
			titleAlign : 'right',
			type : 'number',
			width : '122px',
			geniisysClass : 'money',
			filterOption : true,
			filterOptionType : 'number'
		}, {
			id : 'premAmt',
			title : 'Premium Amount',
			titleAlign : 'right',
			type : 'number',
			width : '122px',
			geniisysClass : 'money',
			filterOption : true,
			filterOptionType : 'number'
		}, {
			id : 'taxAmt',
			title : 'Tax Amount',
			titleAlign : 'right',
			type : 'number',
			width : '122px',
			geniisysClass : 'money',
			filterOption : true,
			filterOptionType : 'number'
		},
		{	id : 'incTag', // column added by: Nica to display incTag if parameter objAC.enterAdvPayt = Y
			title: '&#160;',
            altTitle: '&#160;',
            titleAlign: 'center',
            width: objAC.enterAdvPayt == "Y" ? '22px' : '0px',
            maxlength: 1, 
            sortable: false,
            editable: false,
		   	hideSelectAllBox: true,
		   	otherValue: false,
		   	visible: objAC.enterAdvPayt == "Y" ? true : false,
		   	editor: new MyTableGrid.CellCheckbox({ 
	            getValueOf: function(value){
            		if (value){
						return "Y";
            		}else{
						return "N";	
            		}	
            	}
		   	}),	
		},
		],
		resetChangeTag: true,
		rows : objDirectPrem.rows
	};
		
	gdpcTableGrid = new MyTableGrid(gdpcTableModel);
	gdpcTableGrid.pager = objDirectPrem;
	gdpcTableGrid.render('directPremiumCollectionGrid');
	gdpcTableGrid.afterRender = function(){
		objAC.objGdpc = gdpcTableGrid.geniisysRows;
		//computeTotalAmountsGIACS7();
		rowPremCollnDeselectedFnTG();
		//robert 12.17.12 added condition
		if (objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C"
				|| objACGlobal.orTag == "S" || (objAC.tranFlagState != undefined && objAC.tranFlagState != 'O') 
				|| (objACGlobal.orFlag == "P" && objACGlobal.orTag != "*" && nvl(objAC.tranFlagState, "") != 'O') || objACGlobal.queryOnly == "Y"){
			disableGIACS007();
		}
		if (objAC.objGdpc.length == 0) { //robert 01.16.2013
			disableButton("btnUpdate");
			disableButton("btnSpecUpdate");
		}
		$("txtTotalCollAmt").value = formatCurrency(gdpcTableGrid.pager.totalCollection);
		$("txtTotalPremAmt").value = formatCurrency(gdpcTableGrid.pager.totalPremium);
		$("txtTotalTaxAmt").value = formatCurrency(gdpcTableGrid.pager.totalTax);
		//showBreakdownInfo(false);
	};
	
	function tagButtons(row){
		if (nvl(row.currCd,1) == 1){
			disableButton("btnForeignCurrency");
		}else{
			enableButton("btnForeignCurrency");
		}		
	}
	
	function setObjGdpc(func){
		var rowObjGdpc = new Object();
		rowObjGdpc.gaccTranId = objACGlobal.gaccTranId;
		rowObjGdpc.tranType = $F("tranType");
		rowObjGdpc.issCd = $F("tranSource");
		rowObjGdpc.premSeqNo = parseFloat($F("billCmNo").replace(/,/g, ""));
		rowObjGdpc.instNo = removeLeadingZero($F("instNo").replace(/,/g, ""));
		rowObjGdpc.collAmt = parseFloat($F("premCollectionAmt").replace(/,/g, ""));
		rowObjGdpc.assdName = $F("assdName");
		rowObjGdpc.policyNo = $F("polEndtNo");
		rowObjGdpc.particulars = escapeHTML2($F("particulars")); // added escapeHTML2 by robert 10.14.2013
		rowObjGdpc.premAmt = parseFloat($F("directPremAmt").replace(/,/g, ""));
		rowObjGdpc.taxAmt = parseFloat($F("taxAmt").replace(/,/g, ""));	
		
		if (func == "Add"){
			rowObjGdpc.assdNo 	= objAC.currentRecord.assdNo;			
			rowObjGdpc.currCd 	= objAC.currentRecord.currCd;							
			rowObjGdpc.currRt 	= objAC.currentRecord.currRt;
			if (objAC.currentRecord.orPrintTag) {
				rowObjGdpc.orPrintTag = objAC.currentRecord.orPrintTag;
			} else {
				rowObjGdpc.orPrintTag = "N";
			}
			rowObjGdpc.incTag 				= objAC.currentRecord.incTag == "Y" ? "Y" : "N";
			rowObjGdpc.forCurrAmt 			= rowObjGdpc.collAmt / rowObjGdpc.currRt; 
			rowObjGdpc.origPremAmt 		= objAC.currentRecord.origPremAmt;
			rowObjGdpc.origTaxAmt 		= objAC.currentRecord.origTaxAmt;
			rowObjGdpc.prevPremAmt		= nvl(objAC.currentRecord.prevPremAmt, null) == null ? unformatCurrency("directPremAmt") : objAC.currentRecord.prevPremAmt;
			rowObjGdpc.policyId 				= objAC.currentRecord.policyId;
			rowObjGdpc.lineCd 				= objAC.currentRecord.lineCd;
			rowObjGdpc.maxCollAmt			= objAC.currentRecord.maxCollAmt;
			rowObjGdpc.balanceAmtDue   = parseFloat(objAC.currentRecord.maxCollAmt) - unformatCurrencyValue(objAC.currentRecord.collAmt); 
			rowObjGdpc.premZeroRated   = objAC.currentRecord.premZeroRated;
			rowObjGdpc.premVatable 		= objAC.currentRecord.premVatable;
			//added objAC.currentRecord.premVatExempt != 0 condition by robert 11.27.2013 
			rowObjGdpc.premVatExempt 	= (nvl(objAC.currentRecord.premVatExempt, null) == null && objAC.currentRecord.premVatExempt != 0) ? unformatCurrency("directPremAmt") : objAC.currentRecord.premVatExempt;
			rowObjGdpc.revGaccTranId   	= objAC.currentRecord.revGaccTranId;

			rowObjGdpc.paramPremAmt     = nvl(objAC.currentRecord.paramPremAmt, null) == null ? objAC.currentRecord.origPremAmt : objAC.currentRecord.paramPremAmt;
			rowObjGdpc.prevPremAmt		= nvl(objAC.currentRecord.prevPremAmt, null) == null ? objAC.currentRecord.origPremAmt : objAC.currentRecord.prevPremAmt;
			rowObjGdpc.prevTaxAmt 		= nvl(objAC.currentRecord.prevTaxAmt, null) == null ? objAC.currentRecord.origTaxAmt : objAC.currentRecord.prevTaxAmt;
			
			rowObjGdpc.commPaytSw	    = 0;
			rowObjGdpc.recordStatus	= 0;
			
		} else {
			
			rowObjGdpc.orPrintTag = objAC.selectedRecord.orPrintTag;
	    	rowObjGdpc.particulars = escapeHTML2($F("particulars"));  // added escapeHTML2 by robert 10.14.2013
	    	rowObjGdpc.incTag = objAC.currentRecord.incTag == "Y" ? "Y" : "N";
	    	rowObjGdpc.policyNo = $F("polEndtNo");
	    	rowObjGdpc.assdName = $F("assdName");
	    	rowObjGdpc.currCd = objAC.selectedRecord.currCd;
	    	rowObjGdpc.currRt = objAC.selectedRecord.currRt;
	    	rowObjGdpc.forCurrAmt = objAC.selectedRecord.forCurrAmt;
	    	rowObjGdpc.origPremAmt = objAC.selectedRecord.origPremAmt;
	    	rowObjGdpc.origTaxAmt = objAC.selectedRecord.origTaxAmt;
								    	
			rowObjGdpc.paramPremAmt = objAC.selectedRecord.paramPremAmt;
	    	rowObjGdpc.prevPremAmt = objAC.selectedRecord.prevPremAmt;
	    	rowObjGdpc.prevTaxAmt = objAC.selectedRecord.prevTaxAmt;
								    	
			rowObjGdpc.premVatable = objAC.currentRecord.premVatable;
	    	rowObjGdpc.premVatExempt = objAC.currentRecord.premVatExempt;
	    	rowObjGdpc.premZeroRated = objAC.currentRecord.premZeroRated;
	    	
	    	rowObjGdpc.commPaytSw = nvl(objAC.selectedRecord.commPaytSw, null);
		}
		rowObjGdpc.recordStatus = func == "Delete" ? -1 : func == "Add" ? 0 : 1;
		return rowObjGdpc;
	}
		
	function showBreakdownInfo(show){
		try{	
			if(show){
				if(selectedItemInfoRow.taxAmt != '0'){
					/* $("taxInfoGro").innerHTML = "Hide";
					$("taxInformationMotherDiv").show();
					taxInfoTableGrid.url = contextPath+"/GIACDirectPremCollnsController?action=refreshTaxCollectionTG&gaccTranId="+objACGlobal.gaccTranId+
							"&issCd="+selectedItemInfoRow.issCd+"&premSeqNo="+selectedItemInfoRow.premSeqNo+"&instNo="+selectedItemInfoRow.instNo;
					taxInfoTableGrid._refreshList(); */ //benjo 11.03.2015 comment out
					if(objACGlobal.previousModule == 'GIACS070' && objACGlobal.hidObjGIACS003.journalEntriesRow.tranClass == 'CP'){ //added by robert SR 5239 01.05.16
						clearTableGridDetails(taxInfoTableGrid); 
						$("taxInfoGro").innerHTML = "Hide";
						$("taxInformationMotherDiv").show();
						$("txtTotalTaxAmt2").value = "0.00";
					}else{
					/* benjo 11.03.2015 GENQA-SR-5015 */
					if (selectedItemInfoRow.recordStatus===0 || selectedItemInfoRow.recordStatus === 1){ // added by robert SR 5447 03.10.16
					try {
						new Ajax.Request(contextPath+"/GIACDirectPremCollnsController?action=taxDefaultValueType", {
								method : "GET",
								parameters : {
									tranId       : objACGlobal.gaccTranId,
									tranType     : selectedItemInfoRow.tranType,
									tranSource   : selectedItemInfoRow.issCd,
									premSeqNo    : selectedItemInfoRow.premSeqNo,
									instNo       : selectedItemInfoRow.instNo,
									fundCd       : objACGlobal.fundCd,
									taxAmt       : selectedItemInfoRow.taxAmt,
									paramPremAmt : nvl(selectedItemInfoRow.paramPremAmt, null) == null ? selectedItemInfoRow.origPremAmt : selectedItemInfoRow.paramPremAmt,
									premAmt      : selectedItemInfoRow.premAmt,
									collnAmt     : selectedItemInfoRow.collAmt,
									premVatExempt: selectedItemInfoRow.premVatExempt,
									revTranId    : selectedItemInfoRow.revGaccTranId,
									taxType      : selectedItemInfoRow.tranType
								},
								evalScripts : true,
								asynchronous : false,
								onComplete : function(response) {
									if (checkErrorOnResponse(response)) {
										var result = response.responseText.toQueryParams();
										var rec = JSON.parse(result.giacTaxCollnCur);
										var sumTax = 0;
										
										$("taxInfoGro").innerHTML = "Hide";
										$("taxInformationMotherDiv").show();
										taxInfoTableGrid.empty();
										
										for(var i = 0; i < rec.length; i++){
											sumTax = sumTax + parseFloat(rec[i].taxAmt);
											taxInfoTableGrid.addBottomRow(rec[i]);
										}
										
										$("txtTotalTaxAmt2").value = formatCurrency(sumTax);
									}
								}
							});
					} catch (e) {
						showMessageBox(e.message);
					}
					}else{ // added by robert SR 5447 03.10.16
						$("taxInfoGro").innerHTML = "Hide";
						$("taxInformationMotherDiv").show();
						taxInfoTableGrid.url = contextPath+"/GIACDirectPremCollnsController?action=refreshTaxCollectionTG&gaccTranId="+objACGlobal.gaccTranId+
								"&issCd="+selectedItemInfoRow.issCd+"&premSeqNo="+selectedItemInfoRow.premSeqNo+"&instNo="+selectedItemInfoRow.instNo;
						taxInfoTableGrid._refreshList();
					}
					} //added by robert SR 5239 01.05.16
				}else{
					if($("taxInformationGrid") != null){
						clearTableGridDetails(taxInfoTableGrid); 
						$("taxInfoGro").innerHTML = "Show";
						$("taxInformationMotherDiv").hide();
						$("txtTotalTaxAmt2").value = "0.00";
					}
				}
				
				$("premInfoGro").innerHTML = "Hide";
				$("premInformationMotherDiv").show();
				premInfoTableGrid.url = contextPath+"/GIACDirectPremCollnsController?action=refreshPremCollectionTG&gaccTranId="+objACGlobal.gaccTranId+
						"&issCd="+selectedItemInfoRow.issCd+"&premSeqNo="+selectedItemInfoRow.premSeqNo;
				premInfoTableGrid._refreshList();
			}else{
				if($("taxInformationGrid") != null){
					clearTableGridDetails(taxInfoTableGrid); 
					$("taxInfoGro").innerHTML = "Show";
					$("taxInformationMotherDiv").hide();
					$("txtTotalTaxAmt2").value = "0.00";
				}
				if($("premInformationGrid") != null){
					clearTableGridDetails(premInfoTableGrid); 
					$("premInfoGro").innerHTML = "Show";
					$("premInformationMotherDiv").hide();
					$("txtTotalPremAmt2").value = "0.00";
				}
			}
		}catch(e){
			showErrorMessage("showReserveHistoryTG",e);
		}
	}
	
	function recomputeAllocation(recompPrem, recompTax) {
		try {
			new Ajax.Request(contextPath+"/GIACDirectPremCollnsController?action=taxDefaultValueType", {
				method : "GET",
				parameters : {
					tranId : objACGlobal.gaccTranId,
					tranType : $F("tranType"),
					tranSource : $F("tranSource"),
					premSeqNo : $F("billCmNo"),
					instNo : $F("instNo"),
					fundCd : objACGlobal.fundCd,
					taxAmt : recompTax /*unformatCurrencyValue(objAC.currentRecord.prevTaxAmt)*/,
					paramPremAmt : unformatCurrencyValue(""+nvl(objAC.currentRecord.paramPremAmt, 0)),
					premAmt : recompPrem /*unformatCurrencyValue(objAC.currentRecord.origPremAmt)*/,
					collnAmt : unformatCurrency("premCollectionAmt"),
					premVatExempt: unformatCurrencyValue(""+objAC.currentRecord.premVatExempt),
					revTranId: objAC.currentRecord.revGaccTranId,
					taxType : $F("tranType")
				},
				evalScripts : true,
				asynchronous : false,
				onComplete : function(response) {
					if (checkErrorOnResponse(response)) {
						
						var result = response.responseText.toQueryParams();
						
						var recomputedPrem = result.premAmt;
						var recomputedTax = result.taxAmt;
						
						 if(recomputedPrem != recompPrem || recomputedTax != recompTax) {
							showMessageBox("There is an overpayment on premium/tax found. Kindly delete and re-enter the record.");
							
							objAC.jsonTaxCollnsNew = JSON.parse(result.giacTaxCollnCur);

							objAC.sumGtaxAmt = result.taxAmt;
							$("directPremAmt").value = formatCurrency(result.premAmt);
							$("taxAmt").value = formatCurrency(result.taxAmt);
							
							if (objAC.currentRecord.otherInfo) {
								objAC.currentRecord.forCurrAmt = result.collnAmt
										* objAC.currentRecord.otherInfo.currRt;
							} else {
								objAC.currentRecord.forCurrAmt = result.collnAmt
										* objAC.currentRecord.currRt;
							}
							$("premVatExempt").value = result.premVatExempt;
							objAC.currentRecord.premVatExempt = result.premVatExempt;
							
							retrievedTaxCollns = objAC.jsonTaxCollnsNew;
							//updateJSONTaxCollection(retrievedTaxCollns);
						} 
						addGdpc();
					}
				}
			});
		} catch (e) {
			showErrorMessage("recomputeAllocation", e);
		}
		
	}
	
	function addGdpc(){
		//var rowObj = setObjGdpc($("btnAdd").value);
		getIncTagForAdvPremPayts($("tranSource").value, $("billCmNo").value); // added by Nica 04.22.2013 - to consider if bill is for advancePayment
		 if (objAC.taxAllocationFlag == "Y") { //bertongbully
			withTaxAllocation();
		} else { 
			noTaxAllocation();
		} 
		var rowObj = setObjGdpc($("btnAdd").getAttribute("status"));
		
		if($("btnAdd").getAttribute("status") == "Add"){
			objAC.objGdpc.push(rowObj);
			gdpcTableGrid.addBottomRow(rowObj);
		}else{
			if(selectedItemInfo != null){
				rowObj.recordStatus = selectedItemInfoRow.recordStatus == 0 ? 0 : rowObj.recordStatus; // Nica 04.17.2013 - added condition to retain the recordStatus 0 if record is newly added
				//rowObj.currCd 	= selectedItemInfoRow != null ? nvl(selectedItemInfoRow.otherInfo.currCd, 1) : 1;							
				//rowObj.currRt 	= selectedItemInfoRow != null ? nvl(selectedItemInfoRow.otherInfo.currRt, 1) : 1;
				//rowObj.policyId = selectedItemInfoRow != null ? selectedItemInfoRow.otherInfo.policyId : rowObj.policyId;
				rowObj.currCd 	= selectedItemInfoRow != null ? (selectedItemInfoRow.otherInfo ? nvl(selectedItemInfoRow.otherInfo.currCd, 1) : nvl(selectedItemInfoRow.currCd,1)) : 1;	
				rowObj.currRt 	= selectedItemInfoRow != null ? (selectedItemInfoRow.otherInfo ? nvl(selectedItemInfoRow.otherInfo.currRt, 1) : nvl(selectedItemInfoRow.currRt,1)) : 1;	
				rowObj.policyId = selectedItemInfoRow != null ? (selectedItemInfoRow.otherInfo ? nvl(selectedItemInfoRow.otherInfo.policyId, 1) : nvl(selectedItemInfoRow.policyId,1)) : 1;	
				rowObj.maxCollAmt = selectedItemInfoRow != null ? selectedItemInfoRow.maxCollAmt : rowObj.maxCollAmt;
			}
			objAC.objGdpc.splice(selectedItemInfo, 1, rowObj);
			gdpcTableGrid.updateVisibleRowOnly(rowObj, selectedItemInfo);
		}	
		objAC.formChanged = 'Y';
		changeTag = 1;
		computeTotalAmountsGIACS7(rowObj.collAmt, rowObj.premAmt, rowObj.taxAmt, "add");
		gdpcTableGrid.onRemoveRowFocus();
		//robert 01.16.2013
			enableButton("btnUpdate");
			enableButton("btnSpecUpdate");
		
	}
	
	function deleteGdpc(){
		if(objAC.selectedRecord.commPaytSw == 1) {
			showMessageBox("Delete first the commission payment in "+ objAC.selectedRecord.issCd+
					" - "+ objAC.selectedRecord.premSeqNo+".", imgMessage.ERROR);
			return;
		}
		
		if(nvl(objAC.selectedRecord.revGaccTranId, null) != null && (objAC.selectedRecord.tranType == 1 || objAC.selectedRecord.tranType == 3)) { //added by robert 12.27.12
			showMessageBox("There is an existing reversal payment for this record. This record cannot be deleted.", 
					imgMessage.ERROR);
			return;
		}
		
		var rowObj = setObjGdpc("Delete");
		
		objAC.objGdpc.splice(selectedItemInfo, 1, rowObj);
		gdpcTableGrid.deleteVisibleRowOnly(selectedItemInfo);
		objAC.formChanged = 'Y';
		changeTag = 1;
	
		computeTotalAmountsGIACS7(rowObj.collAmt, rowObj.premAmt, rowObj.taxAmt, "del");
		gdpcTableGrid.onRemoveRowFocus();
	}
		
	function showSearchInvoice(){
		if ($F("tranType") == "2" || $F("tranType") == "4"){
			objAC.paytRefNoVis = "Y";
		}else{
			objAC.paytRefNoVis = "N";
		}
		distDtlsOverlay = Overlay.show(contextPath+"/GIACDirectPremCollnsController", {
			asynchronous : true,
			urlContent: true,
			draggable: true,
			onCreate : showNotice("Loading, please wait..."),
			urlParameters: {
				action     		: "showInvoiceListingTg",
				issCd    		    : $F("tranSource"),
				premSeqNo	: $F("billCmNo"),
				tranType		: $F("tranType"),
				instNo			: removeLeadingZero($F("instNo"))
			},
		    title: "Invoice / Inst. No.",
		    height: 490,
		    width: 820
		});
	}
	
	function getCurrencyDetail(obj){ //modified by robert 12.27.12
		var currDesc = "";
		for (var i=0; i<objAC.currDtls.length; i++){
			if (objAC.currDtls[i].code == obj.currCd){
				currDesc = objAC.currDtls[i].desc;
			}
		}
		return currDesc;
	}
	
	function showForeignCurrDtls() {
		Effect.Appear("foreignCurrMainDiv", {
			duration : .001
		});
		if (objAC.selectedRecord.currCd) {
			$("fCurrCd").value = objAC.selectedRecord.currCd;
			$("fCurrRt").value = formatCurrency(objAC.selectedRecord.currRt);//$F("currRt");
			$("fCurrCdDesc").value = getCurrencyDetail(objAC.selectedRecord);//$F("transCurrDesc");
			$("fCurrAmt").value = formatCurrency(objAC.selectedRecord.collAmt
					/ parseFloat(objAC.selectedRecord.currRt));
		} else { //modified by robert 12.27.12
			$("fCurrCd").value = objAC.currentRecord.currCd; //objAC.selectedRecord.otherInfo.currCd;
			$("fCurrRt").value = objAC.currentRecord.currRt; //$F("currRt");//formatCurrency(objAC.selectedRecord.otherInfo.currRt);//
			$("fCurrCdDesc").value = getCurrencyDetail(objAC.currentRecord); //$F("transCurrDesc");
			$("fCurrAmt").value = formatCurrency(unformatCurrencyValue(""+objAC.currentRecord.origCollAmt)//objAC.selectedRecord.otherInfo.premCollectionAmt)
					/ parseFloat(objAC.currentRecord.currRt));//objAC.selectedRecord.otherInfo.currRt));
		}
	}
	
	function withTaxAllocation() {
		try{
			if ($F("tranType") == "1" || $F("tranType") == "4") {
				if (unformatCurrency("premCollectionAmt") < 0) {
					customShowMessageBox("Negative transactions are not accepted.",
							imgMessage.WARNING, "taxAmt");
					$("premCollectionAmt").value = formatCurrency(objAC.currentRecord.origCollAmt);
					return;
				}
			} else {
				if (unformatCurrency("premCollectionAmt") > 0) {
					customShowMessageBox("Positive transactions are not accepted.",
							imgMessage.WARNING, "taxAmt");
					$("premCollectionAmt").value = formatCurrency(objAC.currentRecord.origCollAmt);
					return;
				}
			}
			
			/* This trigger will restrict the amount being entered from    */
			/* exceeding the allowed collection/refundable amount.         */
			/* Zero amounts will also be disallowed.                       */
			if (Math.abs(unformatCurrency("premCollectionAmt")) > Math
					.abs(parseFloat(objAC.currentRecord.maxCollAmt.replace(/,/g, "")))) {
				customShowMessageBox("Collection amount should not exceed "
						+ (parseFloat(objAC.currentRecord.maxCollAmt.replace(/,/g, ""))) + ".", imgMessage.WARNING,
						"premCollectionAmt");
				$("premCollectionAmt").value = formatCurrency(objAC.currentRecord.origCollAmt);
				return;
			} else if (unformatCurrency("premCollectionAmt") == 0) {
				customShowMessageBox("Collection amount cannot be zero.",
						imgMessage.WARNING, "premCollectionAmt");
				$("premCollectionAmt").value = formatCurrency(objAC.currentRecord.origCollAmt);
				return;
			}
			
			/* Recompute premium amount and tax amount based on the collection amount entered */
			if (objAC.preChangedFlag == 'Y') {
	
				if (objAC.taxPriorityFlag == null) { //$F("taxPriorityFlag") modified by alfie 12.10.2010
					showMessageBox(
							"There is no existing PREM_TAX_PRIORITY parameter in GIAC_PARAMETERS table.",
							imgMessage.WARNING);
					return;
				}
				if (objAC.taxPriorityFlag == 'P') {
					/*
					 ** Premium amount has higher priority than tax amount
					 */
					if (unformatCurrency("premCollectionAmt") == parseFloat(objAC.currentRecord.origCollAmt)) {
						$("directPremAmt").value = formatCurrency(objAC.currentRecord.origPremAmt); //$F("origPremAmt");
						$("taxAmt").value = formatCurrency(objAC.currentRecord.origTaxAmt
								.replace(/,/g, ""));
					//} else if (Math.abs(unformatCurrency("premCollectionAmt")) <= Math.abs(unformatCurrency("directPremAmt"))) {
					} else if (Math.abs(unformatCurrency("premCollectionAmt")) <= Math.abs(unformatCurrencyValue(objAC.currentRecord.paramPremAmt))) {
						$("directPremAmt").value = $F("premCollectionAmt");
						$("taxAmt").value = formatCurrency(0);
					} else {
						$("directPremAmt").value = formatCurrency(objAC.currentRecord.origPremAmt);
						$("taxAmt").value = formatCurrency(unformatCurrency("premCollectionAmt")
								- parseFloat(objAC.currentRecord.origPremAmt
										.replace(/,/g, "")));
					}
				} else {
					/*
					 ** Tax amount has higher priority than premium amount
					 */
					if (Math.abs(unformatCurrency("premCollectionAmt")) == Math
							.abs(unformatCurrencyValue(""+objAC.currentRecord.origCollAmt))) {
						$("directPremAmt").value = formatCurrency(objAC.currentRecord.origPremAmt);
						$("taxAmt").value = formatCurrency(objAC.currentRecord.origTaxAmt
								.replace(/,/g, ""));
					} else if (Math.abs(unformatCurrency("premCollectionAmt")) <= Math
							.abs(parseFloat(unformatCurrencyValue(""+objAC.currentRecord.origTaxAmt)))) {
						$("directPremAmt").value = formatCurrency(0);
						$("taxAmt").value = $F("premCollectionAmt");
					} else {
						$("directPremAmt").value = unformatCurrency("premCollectionAmt")
								- parseFloat(unformatCurrencyValue(""+objAC.currentRecord.origTaxAmt));
						$("taxAmt").value = formatCurrency(unformatCurrencyValue(""+objAC.currentRecord.origTaxAmt));
					}
				}
				
				if (objAC.currentRecord.otherInfo) {
					objAC.currentRecord.forCurrAmt = unformatCurrencyValue($("premCollectionAmt").value)
							/ parseFloat(objAC.currentRecord.otherInfo.currRt);
				} else {
					objAC.currentRecord.forCurrAmt = unformatCurrencyValue($("premCollectionAmt").value)
							/ parseFloat(objAC.currentRecord.currRt);
				}
				objAC.currentRecord.paramPremAmt = nvl(objAC.currentRecord.maxPremVatable, null)==null ? 
						objAC.currentRecord.paramPremAmt : objAC.currentRecord.maxPremVatable; //gagamitin to sa saving :)
				objAC.currentRecord.prevPremAmt = $F("directPremAmt");
				objAC.currentRecord.prevTaxAmt = $F("taxAmt");
				// Call procedure for the tax breakdown 
				if (Math.abs(unformatCurrency("taxAmt")) == 0) {
					$("directPremAmt").value = $F("premCollectionAmt");
					$("taxAmt").value = formatCurrency(0);

					if(objAC.currentRecord.premZeroRated != 0) {
						objAC.currentRecord.premZeroRated = unformatCurrency("directPremAmt");
						//$("premVatExempt").value = objAC.currentRecord.premVatExempt; //marco - 07.25.2013 - replaced (SR #13739) 
						$("premZeroRated").value = objAC.currentRecord.premZeroRated;
					} else if (objAC.currentRecord.premVatExempt != 0){
						//objAC.currentRecord.premVatExempt = unformatCurrency("directPremAmt"); //mikel 09.01.2015; UCPBGEN 20211
						//$("premZeroRated").value = objAC.currentRecord.premZeroRated;  //marco - 07.25.2013 - replaced (SR #13739) 
						$("premVatExempt").value = objAC.currentRecord.premVatExempt;
					}
					
					//added by robert 03.13.2013	
					if(objAC.currentRecord.premZeroRated == 0) {
						if((unformatCurrency("directPremAmt") - unformatCurrency("premVatExempt")) == 0) {
							$("premVatable").value = 0;
							objAC.currentRecord.premVatable = 0;
						} else if((Math.abs(unformatCurrency("directPremAmt")) - Math.abs(unformatCurrency("premVatExempt"))) > 0) { //mikel 09.01.2015; UCPBGEN 20211 - added Abs function
							$("premVatable").value = unformatCurrency("directPremAmt") - unformatCurrency("premVatExempt");
							objAC.currentRecord.premVatable = $F("premVatable");
						}
						//mikel 09.01.2015; UCPBGEN 20211 - set premium VAT-exempt and VATABLE
						else if ($F("premCollectionAmt") != 0) {
								objAC.currentRecord.premVatExempt = unformatCurrency("directPremAmt");
								$("premVatExempt").value = objAC.currentRecord.premVatExempt;
								$("premVatable").value = 0;
								objAC.currentRecord.premVatable = 0;
						}
							//end mikel
					} else {
						objAC.currentRecord.premZeroRated = unformatCurrency("directPremAmt");
						objAC.currentRecord.premVatable = 0;
						objAC.currentRecord.premVatExempt = 0;
					}
					//end robert 03.13.2013	
				} else {
					if(selectedItemInfo != null && nvl(objAC.currentRecord.paramPremAmt, null) == null){ // added by: Nica to assign value to paramPremAmt if objAC.currentRecord.paramPremAmt is null
						objAC.currentRecord.paramPremAmt = selectedItemInfoRow.otherInfo.paramPremAmt;
					}
					
					getTaxType1($F("tranType"));
					
					if(objAC.currentRecord.premZeroRated == 0) {
						if((unformatCurrency("directPremAmt") - unformatCurrency("premVatExempt")) == 0) {
							$("premVatable").value = 0;
							objAC.currentRecord.premVatable = 0;
						} else if((unformatCurrency("directPremAmt") - unformatCurrency("premVatExempt")) != 0) { //robert 01.23.2013
							$("premVatable").value = unformatCurrency("directPremAmt") - unformatCurrency("premVatExempt");
							objAC.currentRecord.premVatable = $F("premVatable");
						}
					} else {
						objAC.currentRecord.premZeroRated = unformatCurrency("directPremAmt");
						objAC.currentRecord.premVatable = 0;
						objAC.currentRecord.premVatExempt = 0;
					}
				}
				objAC.preChangedFlag = 'N';
			}
		}catch(e){
			showErrorMessage("withTaxAllocation",e);
		}
	}
	
	function noTaxAllocation() {
		if ($F("tranType") == "1" || $F("tranType") == "4") {
			if (unformatCurrency("premCollectionAmt") < 0) {
				customShowMessageBox("Negative transactions are not accepted.",
						imgMessage.WARNING, "taxAmt");
				$("premCollectionAmt").value = objAC.currentRecord.origCollAmt;
			}
		} else {
			if (unformatCurrency("premCollectionAmt") > 0) {
				customShowMessageBox("Positive transactions are not accepted.",
						imgMessage.WARNING, "taxAmt");
				$("premCollectionAmt").value = objAC.currentRecord.origCollAmt;
			}
		}

		/* This trigger will restrict the amount being entered from    */
		/* exceeding the allowed collection/refundable amount.         */
		/* Zero amounts will also be disallowed.                       */
		if (Math.abs(unformatCurrency("premCollectionAmt")) > Math
				.abs(objAC.currentRecord.origCollAmt)) {
			customShowMessageBox("Collection amount should not exceed "
					+ objAC.currentRecord.origCollAmt + ".",
					imgMessage.WARNING, "premCollectionAmt");
			$("premCollectionAmt").value = objAC.currentRecord.origCollAmt;
			$("directPremAmt").value = objAC.currentRecord.origPremAmt;
			$("taxAmt").value = objAC.currentRecord.origTaxAmt;
		} else if (unformatCurrency("premCollectionAmt") == "0") {
			customShowMessageBox("Collection amount cannot be zero.",
					imgMessage.WARNING, "premCollectionAmt");
			$("premCollectionAmt").value = objAC.currentRecord.origCollAmt;
		}

		/* Recompute premium amount and tax amount based on the collection amount entered */
		if (objAC.preChangedFlag == 'Y') {
			if (objAC.taxPriorityFlag == null) {
				showMessageBox(
						"There is no existing PREM_TAX_PRIORITY parameter in GIAC_PARAMETERS table.",
						imgMessage.WARNING);
			}
			if (objAC.taxPriorityFlag == 'P') {
				/*
				 ** Premium amount has higher priority than tax amount
				 */
				if (unformatCurrency("premCollectionAmt") == objAC.currentRecord.origCollAmt) {
					$("directPremAmt").value = objAC.currentRecord.origPremAmt;
					$("taxAmt").value = objAC.currentRecord.origTaxAmt;
				} else if (Math.abs(unformatCurrency("premCollectionAmt")) <= Math.abs(objAC.currentRecord.origPremAmt)) {
					$("directPremAmt").value = $F("premCollectionAmt");
					$("taxAmt").value = formatCurrency(0);
				} else {
					$("directPremAmt").value = objAC.currentRecord.origPremAmt;
					$("taxAmt").value = unformatCurrency("premCollectionAmt")
							- objAC.currentRecord.origPremAmt;
				}
			} else {
					/*
					 ** Tax amount has higher priority than premium amount
					 */
				if (unformatCurrency("premCollectionAmt") == objAC.currentRecord.origCollAmt) {
					$("directPremAmt").value = unformatCurrency(objAC.currentRecord.origPremAmt);
					$("taxAmt").value = $F("origTaxAmt");
				} else if (Math.abs(unformatCurrency("premCollectionAmt")) <= Math.abs(objAC.currentRecord.origTaxAmt)) {
					$("directPremAmt").value = formatCurrency(0);
					$("taxAmt").value = $F("premCollectionAmt");
				} else {
					var directPremAmt = unformatCurrency("premCollectionAmt") - unformatCurrencyValue(objAC.currentRecord.origTaxAmt);
				    $("directPremAmt").value = formatCurrency(directPremAmt);
					$("taxAmt").value = objAC.currentRecord.origTaxAmt;
				}
			}

			//if (parseFloat(unformatCurrency("taxAmt")) != 0) {
			//	populate_tax_colln; //aayusin pa to,jutjut
			//}
			//objAC.currentRecord.origCollAmt = formatCurrency($("premCollectionAmt").value);
			//objAC.currentRecord.origTaxAmt  = formatCurrency($("taxAmt").value);
			//objAC.currentRecord.origPremAmt = formatCurrency($("directPremAmt").value);
			objAC.currentRecord.forCurrAmt = unformatCurrency("premCollectionAmt")
					/ parseFloat(objAC.currentRecord.convRate);
		}
	}
	
	function getTaxType1(taxType) {
		try {
			new Ajax.Request(contextPath+"/GIACDirectPremCollnsController?action=taxDefaultValueType", {
					method : "GET",
					parameters : {
						tranId : objACGlobal.gaccTranId,
						tranType : $F("tranType"),
						tranSource : $F("tranSource"),
						premSeqNo : $F("billCmNo"),
						instNo : removeLeadingZero($F("instNo")),
						fundCd : objACGlobal.fundCd,
						/* taxAmt : unformatCurrency("taxAmt"),//objAC.currentRecord.taxAmt,
						paramPremAmt : unformatCurrencyValue(""+objAC.currentRecord.origPremAmt),
						premAmt : unformatCurrencyValue($("directPremAmt").value),//unformatCurrency("premCollectionAmt") - objAC.currentRecord.taxAmt.replace(/,/g, "") ,
						collnAmt : unformatCurrency("premCollectionAmt"),
						premVatExempt: nvl($F("premVatExempt"), "") == "" ? 0 : unformatCurrency("premVatExempt"), */
						taxAmt : unformatCurrencyValue(""+objAC.currentRecord.prevTaxAmt),//objAC.currentRecord.taxAmt,
						paramPremAmt : unformatCurrencyValue(""+roundNumber(nvl(objAC.currentRecord.paramPremAmt, 0), 2)),
						premAmt : unformatCurrencyValue($("directPremAmt").value),//robert 01.29.2013  //unformatCurrencyValue(""+objAC.currentRecord.origPremAmt),//unformatCurrency("premCollectionAmt") - objAC.currentRecord.taxAmt.replace(/,/g, "") ,
						collnAmt : unformatCurrency("premCollectionAmt"),
						premVatExempt: unformatCurrencyValue(""+objAC.currentRecord.premVatExempt), //parameters edited 09.07.2012
						revTranId: objAC.currentRecord.revGaccTranId,
						taxType : taxType
					},
					evalScripts : true,
					asynchronous : false,
					onComplete : function(response) {
						if (checkErrorOnResponse(response)) {
							var result = response.responseText.toQueryParams();
							objAC.jsonTaxCollnsNew = JSON.parse(result.giacTaxCollnCur);
							/*
							var result = JSON.parse(response.responseText);
							objAC.jsonTaxCollnsNew = result.giacTaxCollnCur;
							*/
							objAC.sumGtaxAmt = result.taxAmt;
							//$("directPremAmt").value = formatCurrency(result.premAmt);
							//$("taxAmt").value = formatCurrency(result.taxAmt);
							$("premCollectionAmt").value = formatCurrency(result.collnAmt);
							var sumTax = 0;
							for(var i = 0; i < objAC.jsonTaxCollnsNew.length; i++){
								sumTax = sumTax + parseFloat(objAC.jsonTaxCollnsNew[i].taxAmt);
							}
							$("taxAmt").value = formatCurrency(sumTax);
							$("directPremAmt").value = formatCurrency(parseFloat(unformatCurrencyValue($F("premCollectionAmt"))) - parseFloat(unformatCurrencyValue($F("taxAmt"))));
							
							if (objAC.currentRecord.otherInfo) {
								objAC.currentRecord.forCurrAmt = result.collnAmt
										* objAC.currentRecord.otherInfo.currRt;
							} else {
								objAC.currentRecord.forCurrAmt = result.collnAmt
										* objAC.currentRecord.currRt;
							}
							$("premVatExempt").value = result.premVatExempt;
							objAC.currentRecord.premVatExempt = result.premVatExempt;
							
							retrievedTaxCollns = objAC.jsonTaxCollnsNew;
							//updateJSONTaxCollection(retrievedTaxCollns);
							//updateTaxCollectionDiv(objAC.jsonTaxCollnsNew);
						}
					}
				});
		} catch (e) {
			showMessageBox(e.message);
		}
	}
	
	var billDetailToAdd = null;
	function validateGIACS007Record(paramTranSource, paramBillCmNo,
			paramInstNo, paramTranType) {
		try{
		new Ajax.Request(
				contextPath
						+ "/GIACDirectPremCollnsController?action=validateRecord",
				{
					method : "GET",
					parameters : {
						issCd : paramTranSource,
						premSeqNo : paramBillCmNo,
						instNo : paramInstNo,
						tranType : paramTranType,
						billPremiumOverdue : objAC.checkBillDueDate,
						tranDate : $F("tranDate")
					},
					evalScripts : true,
					asynchronous : false,
					onComplete : function(response) {
						var result = eval(response.responseText);
						result.cancelledFlag = false;

						if (result[0].errorEncountered != undefined) {
							if(result[0].errorMessage == "This is a cancelled policy.") {
								result.cancelledFlag = true;
							} else {
								showMessageBox(result[0].errorMessage, imgMessage.ERROR);
								clearInvalidPrem();
							}
						}
						
						var billNoValidationDtls = result[0].billNoValidationDtls;
						if 	(billNoValidationDtls != undefined){
							if (billNoValidationDtls.currCd == '1') {
								disableButton("btnForeignCurrency");
							} else {
								enableButton("btnForeignCurrency");
							}
						}
						//var checkInstNoDtls = result[0].checkInstNoDtls;
						//if ("1,4".indexOf($F("tranType"), 1) != -1) {
						if ("1".indexOf($F("tranType"), 1) != -1) {  //edited by d.alcantara, 12.07.2012
							objAC.currentRecord.collAmt = formatCurrency(result[0].collectionAmt);
							objAC.currentRecord.origCollAmt = formatCurrency(result[0].collectionAmt);
							objAC.currentRecord.origPremAmt = formatCurrency(result[0].premAmt);
							objAC.currentRecord.origTaxAmt = formatCurrency(result[0].taxAmt);
						} else {
							objAC.currentRecord.collAmt = formatCurrency(result[0].negCollectionAmt);
							objAC.currentRecord.origCollAmt = formatCurrency(result[0].negCollectionAmt);
							objAC.currentRecord.origPremAmt = formatCurrency(result[0].negPremAmt);
							objAC.currentRecord.origTaxAmt = formatCurrency(result[0].negTaxAmt);
						}
						//var checkPremPaytForSpecialDtls = result[0].checkPremPaytForSpecialDtls;

						if(paramTranType == 2 || paramTranType == 4) {
							objAC.currentRecord.premVatable = -1*objAC.currentRecord.premVatable;
							objAC.currentRecord.premVatExempt = -1*objAC.currentRecord.premVatExempt;
							objAC.currentRecord.premZeroRated = -1*objAC.currentRecord.premZeroRated;
						} else {
							setPremTaxTranType(paramTranSource, paramBillCmNo, paramTranType, 
									paramInstNo, objAC.currentRecord.origPremAmt, 
									function(res) {
										objAC.currentRecord.premVatable = res.premVatable;
										objAC.currentRecord.premVatExempt = res.premVatExempt;
										objAC.currentRecord.premZeroRated = res.premZeroRated;
										objAC.currentRecord.maxPremVatable = res.maxPremVatable;
										$("premVatExempt").value = res.premVatExempt;
										$("premZeroRated").value = res.premZeroRated;
										$("premVatable").value = res.premVatable;
									});
						}
						
						/* if (objAC.taxAllocationFlag == "Y") {
							withTaxAllocation();
						} else { //bertongbully
							noTaxAllocation();
						} */
						//billDetailToAdd = result;
						contValidationCheckForClaim(result);
						/* if (checkPremPaytForSpecialDtls.msgAlert == "This is a Special Policy.") {
							showWaitingMessageBox(
									checkPremPaytForSpecialDtls.msgAlert,
									imgMessage.INFO,
									function() {
										if (result[0].hasClaim != "FALSE")
											contValidationCheckForClaim(result);
									});
						} else if(cancelled) {
							processPaytFromCancelled(result);
						} else {
							contValidationCheckForClaim(result);
						} */
					}
				});
		}catch(e){
			showErrorMessage("validateGIACS007Record",e);
		}
	}

	function getEnteredBillDetails(pIssCd, pPremSeqNo, pTranType, pInstNo) {
		new Ajax.Request(
				contextPath
						+ "/GIACDirectPremCollnsController?action=getEnteredBillDetails",
				{
					method : "GET",
					parameters : {
						premSeqNo : pPremSeqNo,
						issCd : pIssCd,
						tranType : pTranType,
						instNo : pInstNo
					},
					evalScripts : true,
					asynchronous : false,
					onComplete : function(response) {
						var res = JSON.parse(response.responseText);
						var bills = eval(Object.toJSON(res.bills));
						
						if(res.errorMsg != null && res.errorMsg != "") {
							//showMessageBox(res.errorMsg, "error");
							clearInvalidPrem();
							customShowMessageBox(res.errorMsg, imgMessage.WARNING, "billCmNo");
							return;
						}
						
						if(bills.length > 1) {
							fireEvent($("oscmInstNo"), "click");
							return;
						}  else if (bills.length < 1) {
							//showMessageBox("This Installment No. does not exist.");
							showMessageBox("This Bill No. is invalid for transaction type "+pTranType+".");
							return;
						}
						
						if(pTranType == 2){ //added by robert 01.31.2013
							showSearchInvoice();
						}else{
							
							var billDetails = getObjectFromArrayOfObjects(
									bills,
									"issCd premSeqNo instNo", pIssCd + pPremSeqNo
											+ pInstNo);
							
							if (!billDetails) {
								customShowMessageBox(
										"Installment doesn't exist or the bill entered was for another transaction type.",
										imgMessage.WARNING, "instNo");
								clearInvalidPrem();
							} else { 
								$("assdName").value = billDetails.assdName;
								$("polEndtNo").value = billDetails.policyNo;
								//if ("1,4".indexOf(pTranType)!= -1) {
								//if ("1".indexOf(pTranType)!= -1) {
								if(pTranType == 1) {
									$("premCollectionAmt").value = formatCurrency(billDetails.collectionAmt);
									$("directPremAmt").value = formatCurrency(billDetails.premAmt);
									$("taxAmt").value = formatCurrency(billDetails.taxAmt);
								} else {
									$("premCollectionAmt").value = formatCurrency(billDetails.collectionAmt1);
									$("directPremAmt").value = formatCurrency(billDetails.premAmt1);
									$("taxAmt").value = formatCurrency(billDetails.taxAmt1);
								}
								
								objAC.currentRecord = new Object(billDetails);
								objAC.currentRecord.collAmt = billDetails.collectionAmt;
								objAC.currentRecord.origCollAmt = billDetails.collectionAmt;
								objAC.currentRecord.origPremAmt = billDetails.premAmt;
								objAC.currentRecord.origTaxAmt = billDetails.taxAmt;
								objAC.currentRecord.paramPremAmt = billDetails.premAmt;
								objAC.currentRecord.currCd = billDetails.currCd == null ? objAC.defCurrency : billDetails.currCd;
								objAC.currentRecord.currRt = billDetails.currRt == null ? objAC.defCurrRate : billDetails.currRt;
								objAC.currentRecord.currShortName = "";
								objAC.currentRecord.currDesc = "";
								objAC.currentRecord.policyId = billDetails.policyId;
								objAC.currentRecord.lineCd = billDetails.lineCd;
								objAC.currentRecord.maxCollAmt = billDetails.collectionAmt;
								objAC.currentRecord.revGaccTranId = billDetails.revGaccTranId;
								objAC.currentRecord.premVatable = billDetails.premVatable;
								objAC.currentRecord.premVatExempt = billDetails.premVatExempt;
								objAC.currentRecord.premZeroRated = billDetails.premZeroRated;
								objAC.currentRecord.prevPremAmt = billDetails.premAmt;
								
								objAC.preChangedFlag = 'Y';
								/* setPremTaxTranType(pIssCd, pPremSeqNo, pTranType, 
										pInstNo, billDetails.premAmt, 
										function(res) {
											objAC.premVatable = res.premVatable;
											objAC.premVatExempt = res.premVatExempt;
											objAC.premZeroRated = res.premZeroRated;
											objAC.maxPremVatable = res.maxPremVatable;
										}); */
								
								if(billDetails.currCd == '1') {
									disableButton("btnForeignCurrency");
									//enableButton("btnForeignCurrency");
								} else {
									enableButton("btnForeignCurrency");
									//disableButton("btnForeignCurrency");
								}
							}
							//moved here from observe	 
							 if($("btnAdd").getAttribute("status") == "Add") {
									validateGIACS007Record($("tranSource").value, $("billCmNo").value, removeLeadingZero($F("instNo")), $("tranType").value);
							} 
						}	
					}
				});
	}
	
	function showDatedChecksOverlay(){
		datedChksOverlay = Overlay.show(contextPath+"/GIACPdcPremCollnController", {
			urlContent: true,
			draggable: true,
			urlParameters: {
				action     		: "showDatedChecksOverlay",
				gaccTranId    : objACGlobal.gaccTranId
			},
		    title: "Dated Check Details",
		    height: 320,
		    width: 550
		});
	}
	
	function checkExistInList(paramGaccTranId, paramTranSource, paramBillCmNo,
			paramInstNo, paramTranType) {
		var exist = false;
		if (getObjectFromArrayOfObjects(objAC.objGdpc,
				"gaccTranId issCd premSeqNo instNo tranType", paramGaccTranId
						+ paramTranSource + paramBillCmNo + paramInstNo
						+ paramTranType) != null) {
			exist = true;
		}
		return exist;
	}

	
	//$("btnAdd").observe("click", addGdpc);
	$("premCollectionAmt").observe("focus", function() {
		$("premCollectionAmt").setAttribute("lastValidValue", $F("premCollectionAmt"));
	});
	
	$("premCollectionAmt").observe("change", function() {
		try{
			if($F("premCollectionAmt") == "") { 
				$("premCollectionAmt").value = formatCurrency(objAC.currentRecord.origCollAmt);
				customShowMessageBox("Required fields must be entered.", "error", "premCollectionAmt");
			}
			var collnAmt = unformatCurrencyValue($("premCollectionAmt").value);
			objAC.currentRecord.paramPremAmt = nvl(objAC.currentRecord.maxPremVatable, null)==null ? 
					objAC.currentRecord.paramPremAmt : objAC.currentRecord.maxPremVatable;
			if(collnAmt != nvl(selectedItemInfoRow.collAmt,'0')){
				if (collnAmt) {
		 			if (collnAmt != objAC.currentRecord.origCollAmt) {
			  			objAC.preChangedFlag = 'Y';
						//if (!$F("instNo").empty() && objAC.overideCalled == 'N') { commented out by robert 12.19.12
						if (!$F("instNo").empty() ) {	
							if (objAC.taxAllocationFlag == "Y") {
								withTaxAllocation();
							} else {
								noTaxAllocation();
							}
						}
					} else {
						if(($F("tranType") == "1" || $F("tranType") == "4") && collnAmt < 0) {
							$("premCollectionAmt").value = $("premCollectionAmt").getAttribute("lastValidValue");
							customShowMessageBox("Negative transactions are not accepted.", imgMessage.WARNING, "premCollectionAmt");
						} else if(($F("tranType") == "2" || $F("tranType") == "3") && collnAmt > 0) {
							$("premCollectionAmt").value = $("premCollectionAmt").getAttribute("lastValidValue");
							customShowMessageBox("Positive transactions are not accepted.", imgMessage.WARNING, "premCollectionAmt");
						} else {
							$("premCollectionAmt").value = formatCurrency(collnAmt);
							$("directPremAmt").value = formatCurrency(objAC.currentRecord.origPremAmt);
							$("taxAmt").value = formatCurrency(objAC.currentRecord.origTaxAmt
									.replace(/,/g, ""));
						}
						
					}
				} else { 
			 		$("premCollectionAmt").value = formatCurrency(objAC.currentRecord.origCollAmt);
					customShowMessageBox("Invalid Collection Amount. Valid value should be from .01 to 99,999,999,999.99.", "E", "premCollectionAmt");
				} 
			}
		}catch(e){
			showErrorMessage("premCollectionAmt",e);
		}
	});
	
	$("btnAdd").observe("click", function() {
		if($F("tranType") == ""){
			customShowMessageBox("Required fields must be entered.", "E", "tranType");
		}else if($F("tranSource") == ""){
			customShowMessageBox("Required fields must be entered.", "E", "tranSource");
		}else if (checkAllRequiredFieldsInDiv("directPremiumForm")){
			if (!(checkExistInList(objACGlobal.gaccTranId, $("tranSource").value, $("billCmNo").value, removeLeadingZero($F("instNo")), $("tranType").value))) {
				/* if (objAC.taxAllocationFlag == "Y") {
					var recompPrem = unformatCurrency("directPremAmt");
					var recompTax = unformatCurrency("taxAmt");
					recomputeAllocation(recompPrem, recompTax);
				} else { */
					addGdpc();
				//} BERTONGBULLY
			}else {
				if ($("btnAdd").getAttribute("status") == "Add") {
					showMessageBox("Row exist already with same Issuing Source, Bill No., Inst No., Tran ID.", imgMessage.ERROR);
				}else {
					/* if (objAC.taxAllocationFlag == "Y") {
						var recompPrem = unformatCurrency("directPremAmt");
						var recompTax = unformatCurrency("taxAmt");
						recomputeAllocation(recompPrem, recompTax);
					} else { */
						addGdpc();
					//}
					
				}
			}
		}
	});
	
	$("btnDelete").observe("click", deleteGdpc);
	
	 // SR-20000 : shan 08.24.2015
	function showGiacs007BranchCdLOV(isIconClicked){
		try{
			var searchString = isIconClicked ? "%" : ($F("tranSource").trim() == "" ? "%" : $F("tranSource"));	
			
			LOV.show({
				controller : "AcCashReceiptsTransactionsLOVController",
				urlParameters : {
					action : "getGIACS007BranchCdLOV",
					searchString : searchString,
					moduleId: 'GIACS007',
					page : 1
				},
				title : "List of Issue Codes",
				width : 350,
				height : 386,
				columnModel : [ {
					id : "issCd",
					title : "Issue Cd",
					width : '90px',
					renderer: function(value){
						return unescapeHTML2(value);
					}
				}, {
					id : "issName",
					title : "Issue Name",
					width : '230px'
				}],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("tranSource").value = unescapeHTML2(row.issCd);
						$("tranSource").setAttribute("lastValidValue", unescapeHTML2(row.issCd));
					}
				},
				onCancel: function(){
					$("tranSource").focus();
					$("tranSource").value = $("tranSource").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("tranSource").value = $("tranSource").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "tranSource");
				} 
			});
		}catch(e){
			showErrorMessage("showGiacs007BranchCdLOV", e);
		}		
	}
	
	$("oscmBillIssCd").observe("click", function(){
		if ($("tranType").selectedIndex == 0){
			showMessageBox( "Please select a transaction type first.", imgMessage.ERROR);
			$("tranType").focus();
		}else{
			showGiacs007BranchCdLOV(true);
		}
	});
	
	$("tranSource").observe("focus", function(){
		if ($("tranType").selectedIndex == 0){
			showMessageBox( "Please select a transaction type first.", imgMessage.ERROR);
			$("tranType").focus();
		}
	});
	
	$("tranSource").observe("change", function(){
		if (this.value == ""){
			$("billCmNo").value = "";
			$("instNo").value = "";
			$("premCollectionAmt").value = "0.00";
			$("directPremAmt").value = "0.00";
			$("taxAmt").value = "0.00";
			$("assdName").value = "";
			$("polEndtNo").value = "";
			$("particulars").value = "";
			this.setAttribute("lastValidValue", "");
		}else{
			showGiacs007BranchCdLOV(false);
		}
	});	
	 // end SR-20000
	
	$("oscmBillCmNo").observe("click", function() {
		if ($("tranType").selectedIndex != 0
				&& /*$("tranSource").selectedIndex != 0*/ $F("tranSource") != "") {	// SR-20000 : shan 08.24.2015
			showSearchInvoice();
		} else {
			showMessageBox(
					"Please select a transaction type and issue source first.",
					imgMessage.ERROR);
		}
	});
	
	$("oscmInstNo").observe("click", function() {
		if ($("tranType").selectedIndex != 0
				&& /*$("tranSource").selectedIndex != 0*/ $F("tranSource") != "" // SR-20000 : shan 08.24.2015
				&& !$F("billCmNo").empty()) {
			showSearchInvoice();
		} else {
			showMessageBox(
					"Please select a transaction type, issue source and Bill No. first.",
					imgMessage.ERROR);
		}
	});
	
	$("billCmNo").observe("change", function() {
		if (/*$("tranSource").selectedIndex == 0*/ $F("tranSource") == "") {	// SR-20000 : shan 08.24.2015
			showMessageBox(
					"No issue source selected. Please select an issue source to continue.",
					imgMessage.ERROR);
			$("billCmNo").value = "";
		} else if(!isNaN($F("billCmNo")) && $F("billCmNo")!="") {
			$("instNo").value = "";
			$("premCollectionAmt").value = "0.00";
			$("directPremAmt").value = "0.00";
			$("taxAmt").value = "0.00";
			$("assdName").value = "";
			$("polEndtNo").value = "";
			$("particulars").value = "";
			objAC.usedAddButton = "Y";
			/* validatePremSeqNoGIACS007($F("tranType"), $F("tranSource"), $F("billCmNo"), null, 
					function(){ $("billCmNo").value = "";}); */
			validatePremSeqNoGIACS007($F("tranType"), $F("tranSource"), $F("billCmNo"), 
					function() {preValidateBill($F("tranSource"), $F("billCmNo"));}, clearInvalidPrem);
		}else{
			$("billCmNo").clear();
		}
	});
	
	function checkInstNo(){
		var ok = true;
		new Ajax.Request(contextPath+"/GIACDirectPremCollnsController",{
			parameters:{
				action: 	"checkInstNoGIACS007",
				issCd				: $F("tranSource"),
				premSeqNo	: $F("billCmNo"),
				instNo			: removeLeadingZero($F("instNo"))
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				if (checkErrorOnResponse(response)) {
					if(response.responseText != "" ){
						getEnteredBillDetails($("tranSource").value,
								$("billCmNo").value, $("tranType").value,
								removeLeadingZero($F("instNo")));
					}else{
						customShowMessageBox("This Installment No. does not exist.", "W", "instNo");
						$("instNo").clear();
						return false;
					}
				}
			}
		});	
		return ok;
	}
	
	function checkPreviousInst(){
		new Ajax.Request(contextPath+"/GIACDirectPremCollnsController",{
			parameters:{
				action: 	"checkPreviousInst",
				issCd		: $F("tranSource"),
				premSeqNo	: $F("billCmNo"),
				instNo		: removeLeadingZero($F("instNo"))
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				if (checkErrorOnResponse(response)) {
					if(response.responseText == "N" ){
						customShowMessageBox("Payments of installments should be sequential. Settle the previous installment first.", "I", "instNo");
						$("instNo").clear();
						return false;
					}else{
						$("premCollectionAmt").readOnly = false;
						$("instNo").value = parseInt(removeLeadingZero($F("instNo"))).toPaddedString(2);
						objAC.usedAddButton = "Y";
						checkInstNo();
					}
				}
			}
		});	
	}
	
	$("instNo").observe("change", function() {
		if ($("billCmNo").value == "") {
			showMessageBox(
					"No Bill/CM No. entered. Please enter a Bill/CM No. to continue.",
					imgMessage.ERROR);
			$("instNo").value = "";
		} else if(!isNaN($F("instNo")) && $F("instNo")!="") {
			//marco - 09.22.2014 - replaced
			//var invoiceRowId = $("tranSource").value + $("billCmNo").value + removeLeadingZero($F("instNo")) + $("tranType").value;
			//if (getObjectFromArrayOfObjects(objAC.objGdpc,  "issCd premSeqNo instNo tranType", invoiceRowId)) {
			var invoiceRowId = $("tranSource").value + $("billCmNo").value + removeLeadingZero($F("instNo"));
			if (nvl(getObjectFromArrayOfObjects(objAC.objGdpc,  "issCd premSeqNo instNo", invoiceRowId), "") != "") {
				customShowMessageBox('Row exists already with same Issuing Source, Bill No., Inst No., Tran Id.', "I","instNo");
				$("instNo").clear();
				return false;
			}else if(nvl(objAC.allowNonseqPaytInst,"Y") == "N" && $F("instNo") > 1 ){
				checkPreviousInst();
			}else{
				$("premCollectionAmt").readOnly = false;
				$("instNo").value = parseInt(removeLeadingZero($F("instNo"))).toPaddedString(2);
				objAC.usedAddButton = "Y";
				checkInstNo();
			}
		}else{
			$("instNo").clear();
		}
	});
	
	$("btnForeignCurrency").observe("click",function() {
		if ($("tranType").selectedIndex != 0
				&& /*$("tranSource").selectedIndex != 0*/ $F("tranSource") != ""	// SR-20000 : shan 08.24.2015
				&& !$F("billCmNo").empty()) {
			loadAccountingPopupOverlay(
					"/GIACDirectPremCollnsController?action=showForeignCurrDtls",
					"Foreign Currency", showForeignCurrDtls,
					400, 150, 100);
		} else {
			showMessageBox(
					"Please select a transaction type, issue source and Bill No. first.",
					imgMessage.ERROR);
		}
	});

				
	$("btnDatedCheck").observe("click", function() {
		showDatedChecksOverlay();
	});
	
	$("btnInvoice").observe("click", function() {
		if ($("tranType").selectedIndex != 0) {
				//&& $("tranSource").selectedIndex != 0) {
			showSearchInvoice();
		}
	});
	
	$("btnPremColln").observe("click", function() {
		loadAccountingPopupOverlay(
				"/GIACDirectPremCollnsController?action=printPremiumCollections",
				"Print Premium Collections",
				showPrintGenerator, 400, 150, 100);
	});
	var payorType = "";
	
	$$("input[name='payorType']").each(function(r) {
		$(r.id).observe("click", function() {
			if(r.checked == true) {
				if(r.id == "radioAssd") {
					payorType = "A";	
				} else if(r.id == "radioIntm") {
					payorType = "I";
				}
			}
		});	
	});
	
	$("btnUpdate").observe("click", function() { //modified by robert 01.10.2013
		try{
			if (objAC.objGdpc.length > 0) {
				if (objAC.formChanged == "N") {

					var params = [];
					var obj = {};
					
					if(selectedItemInfo != null)	{						
						obj.issCd = selectedItemInfoRow.issCd;
						obj.premSeqNo = selectedItemInfoRow.premSeqNo;
						obj.lineCd = selectedItemInfoRow.lineCd;
						obj.tranId = selectedItemInfoRow.gaccTranId;
						obj.policyId = selectedItemInfoRow.policyId;
						obj.payorBtn = payorType == "" ? "A" : payorType;
						params.push(obj);
					}else{
						for ( var p = 0; p < objAC.objGdpc.length; p++) {
							obj = {};
							obj.issCd = objAC.objGdpc[p].issCd;
							obj.premSeqNo = objAC.objGdpc[p].premSeqNo;
							if (objAC.objGdpc[p].lineCd==null) {
								obj.lineCd = objAC.objGdpc[p].otherInfo.lineCd;
							} else {
								obj.lineCd = objAC.objGdpc[p].lineCd;
							}
							obj.tranId = objAC.objGdpc[p].gaccTranId;
							if (objAC.objGdpc[p].policyId==null) {
								obj.policyId = objAC.objGdpc[p].otherInfo.policyId;
							} else {
								obj.policyId = objAC.objGdpc[p].policyId;
							}
							obj.payorBtn = payorType == "" ? "A" : payorType;
							params.push(obj);
							break;
						}					
					}
					
					var msg;
					 new Ajax.Request(
							"GIACDirectPremCollnsController?action=updateAllPayorIntmDtls2",
							{
								method : "POST",
								parameters : {
									premCollnsDtls : prepareJsonAsParameter(params),
									tranId		   : obj.tranId
								},
								evalScripts : true,
								asynchronous : false,
								onComplete : function(response) {
									msg = JSON.parse(response.responseText);
								}
							}); 
					//if ($$("div[name='rowPremColln']").size() > 0) {
						showMessageBox(msg.outMessage, imgMessage.INFO);
						$("payor").value = unescapeHTML2(msg.payor);	//added by christian 04/01/2013 
				} else {
					showMessageBox(
							"Please save your changes first before pressing this button.",
							imgMessage.INFO);
				}
			}
		}catch(e){
			showErrorMessage("btnUpdate button",e);
		}
	});
	
	$("btnSpecUpdate").observe("click", function() {
		if (objAC.formChanged == 'N') {
			objAC.selectedItemInfoRow = selectedItemInfoRow; //added by robert 01.10.2013
			objAC.selectedItemInfo = selectedItemInfo; //added by robert 01.10.2013
			//if ($$("div[name='rowPremColln']").size() > 0) {
				loadAccountingPopupOverlay(
						"/GIACDirectPremCollnsController?action=showSpecUpdate",
						"Update only:", showSpecUpdate, 520,
						150, 100);
			//}
		} else {
			showMessageBox(
					"Please save your changes first before pressing this button.",
					imgMessage.INFO);
		}
	});
	
	$("btnPolicy").observe("click", function() {
		/* loadAccountingPopupOverlay(
				"/GIACDirectPremCollnsController?action=showPolicyEntry",
				"Policy Entry", showPolicyEntry, 419, 150, 100); */
		//marco - 09.16.2014
		giacs007PolicyOverlay = Overlay.show(contextPath+"/GIACDirectPremCollnsController", {
			urlParameters: {
				action: "showPolicyEntry"
			},
			urlContent : true,
			draggable: true,
		    title: "Policy Entry",
		    height: 150,
		    width: 525
		});
	});
	
	function giacDirectPremCollns() {
		try{
		var giacDirectPremCollnsList = eval("[]");
		var giacDirectPremCollnss = null;
		for ( var n = 0; n < objAC.objGdpc.length; n++) {
			giacDirectPremCollnss = {};
			if (objAC.objGdpc[n].recordStatus == 0 || objAC.objGdpc[n].recordStatus == 1) {
				giacDirectPremCollnss.gaccTranId = objAC.objGdpc[n].gaccTranId;
				giacDirectPremCollnss.tranType = objAC.objGdpc[n].tranType;
				giacDirectPremCollnss.issCd = objAC.objGdpc[n].issCd;
				giacDirectPremCollnss.premSeqNo = objAC.objGdpc[n].premSeqNo;
				giacDirectPremCollnss.instNo = objAC.objGdpc[n].instNo;
				giacDirectPremCollnss.collAmt = unformatCurrencyValue(""+objAC.objGdpc[n].collAmt);
				giacDirectPremCollnss.premAmt = unformatCurrencyValue(""+objAC.objGdpc[n].premAmt);
				giacDirectPremCollnss.taxAmt = unformatCurrencyValue(""+objAC.objGdpc[n].taxAmt);
				giacDirectPremCollnss.orPrintTag = objAC.objGdpc[n].orPrintTag;
				giacDirectPremCollnss.particulars = objAC.objGdpc[n].particulars;
				giacDirectPremCollnss.premVatable = objAC.objGdpc[n].premVatable;
				giacDirectPremCollnss.premVatExempt = objAC.objGdpc[n].premVatExempt;
				giacDirectPremCollnss.premZeroRated = unformatCurrencyValue(""+objAC.objGdpc[n].premZeroRated); //modified by: Halley 09.02.2013
				giacDirectPremCollnss.revGaccTranId = objAC.objGdpc[n].revGaccTranId;
				giacDirectPremCollnss.incTag 		= objAC.objGdpc[n].incTag;
				
				if (objAC.objGdpc[n].otherInfo) {
					giacDirectPremCollnss.currCd = objAC.objGdpc[n].otherInfo.currCd;
					giacDirectPremCollnss.currRt = objAC.objGdpc[n].otherInfo.currRt;
					giacDirectPremCollnss.policyId 	= objAC.objGdpc[n].otherInfo.policyId; // added by: Nica 04.22.2013
				} else {
					giacDirectPremCollnss.currCd = objAC.objGdpc[n].currCd;
					giacDirectPremCollnss.currRt = nvl(objAC.objGdpc[n].currRt,objAC.objGdpc[n].convRate);
					giacDirectPremCollnss.policyId 	= objAC.objGdpc[n].policyId; // added by: Nica 04.22.2013
				}
				
				giacDirectPremCollnss.forCurrAmt = objAC.objGdpc[n].forCurrAmt;
				
				giacDirectPremCollnsList.splice(
						giacDirectPremCollnsList.length, 0,
						giacDirectPremCollnss);
			}
		}
		return prepareJsonAsParameter(giacDirectPremCollnsList);
		}catch(e){
			showErrorMessage("giacDirectPremCollns",e);
		}
	}

	function giacDirectPremCollnsAll() {
		try{
			var giacDirectPremCollnsAllList = eval("[]");
			var giacDirectPremCollnss = null;
	
			for ( var n = 0; n < objAC.objGdpc.length; n++) {
				if (objAC.objGdpc[n].recordStatus==0 || objAC.objGdpc[n].recordStatus == 1) {
					giacDirectPremCollnss = {};
					giacDirectPremCollnss.gaccTranId = objAC.objGdpc[n].gaccTranId;
					giacDirectPremCollnss.tranType = objAC.objGdpc[n].tranType;
					giacDirectPremCollnss.issCd = objAC.objGdpc[n].issCd;
					giacDirectPremCollnss.premSeqNo = objAC.objGdpc[n].premSeqNo;
					giacDirectPremCollnss.instNo = objAC.objGdpc[n].instNo;
					giacDirectPremCollnss.collAmt = unformatCurrencyValue(""+objAC.objGdpc[n].collAmt);
					giacDirectPremCollnss.premAmt = unformatCurrencyValue(""+objAC.objGdpc[n].premAmt);
					giacDirectPremCollnss.taxAmt = unformatCurrencyValue(""+objAC.objGdpc[n].taxAmt);
					giacDirectPremCollnss.orPrintTag = objAC.objGdpc[n].orPrintTag;
					giacDirectPremCollnss.particulars = objAC.objGdpc[n].particulars;
					giacDirectPremCollnss.premVatable = objAC.objGdpc[n].premVatable;
					giacDirectPremCollnss.premVatExempt = objAC.objGdpc[n].premVatExempt;
					giacDirectPremCollnss.premZeroRated = unformatCurrencyValue(""+objAC.objGdpc[n].premZeroRated); //modified by: Halley 09.02.2013
					if (objAC.objGdpc[n].otherInfo) {
						giacDirectPremCollnss.currCd = objAC.objGdpc[n].otherInfo.currCd;
						giacDirectPremCollnss.currRt = objAC.objGdpc[n].otherInfo.currRt;
					} else {
						giacDirectPremCollnss.currCd = objAC.objGdpc[n].currCd;
						giacDirectPremCollnss.currRt = nvl(objAC.objGdpc[n].currRt,objAC.objGdpc[n].convRate);
					}
					giacDirectPremCollnss.forCurrAmt = objAC.objGdpc[n].forCurrAmt;
					
					giacDirectPremCollnsAllList.splice(
							giacDirectPremCollnsAllList.length, 0,
							giacDirectPremCollnss);
				}
			}
			return prepareJsonAsParameter(giacDirectPremCollnsAllList);
		}catch(e){
			showErrorMessage("giacDirectPremCollnsAll",e);
		}
	}

	function taxDefaultsParam() {
		try{
		var taxDefaultParamsList = eval("[]");
		var taxDefaultParams = null;
		for ( var n = 0; n < objAC.objGdpc.length; n++) {	
			if (/* objAC.objGdpc[n].recordStatus == 0
					||  */objAC.objGdpc[n].recordStatus == 1) {
				
				taxDefaultParams = {};
				taxDefaultParams.gaccTranId = objAC.objGdpc[n].gaccTranId;
				taxDefaultParams.tranType = objAC.objGdpc[n].tranType;
				taxDefaultParams.issCd = objAC.objGdpc[n].issCd;
				taxDefaultParams.instNo = objAC.objGdpc[n].instNo;
				taxDefaultParams.premSeqNo = objAC.objGdpc[n].premSeqNo;
				taxDefaultParams.fundCd = objACGlobal.fundCd;
				taxDefaultParams.collAmt = unformatCurrencyValue(""+objAC.objGdpc[n].collAmt);
			    /* taxDefaultParams.premAmt = unformatCurrencyValue(""+objAC.objGdpc[n].premAmt);
				taxDefaultParams.taxAmt = unformatCurrencyValue(""+objAC.objGdpc[n].taxAmt);
				 */
 			 	taxDefaultParams.origTaxAmt = unformatCurrencyValue(""+objAC.objGdpc[n].origTaxAmt);
					
				taxDefaultParams.paramPremAmt = unformatCurrencyValue(""+objAC.objGdpc[n].paramPremAmt);
				taxDefaultParams.prevPremAmt = unformatCurrencyValue(""+objAC.objGdpc[n].prevPremAmt);
				taxDefaultParams.prevTaxAmt = unformatCurrencyValue(""+objAC.objGdpc[n].prevTaxAmt);
				
				if (objAC.objGdpc[n].otherInfo) {
					taxDefaultParams.origPremAmt = unformatCurrencyValue(""+objAC.objGdpc[n].otherInfo.origPremAmt);
				} else {
					taxDefaultParams.origPremAmt = unformatCurrencyValue(""+objAC.objGdpc[n].origPremAmt);
				}
				taxDefaultParams.premVatable = objAC.objGdpc[n].premVatable;
				taxDefaultParams.premVatExempt = objAC.objGdpc[n].premVatExempt;
				
				taxDefaultParams.recordStatus = objAC.objGdpc[n].recordStatus;
				taxDefaultParams.sumTaxTotal = objAC.objGdpc[n].taxAmt;
				taxDefaultParams.revGaccTranId = objAC.objGdpc[n].revGaccTranId; 

				taxDefaultParamsList.splice(taxDefaultParamsList.length, 0,
						taxDefaultParams);
				//break;
			}
		}
		return prepareJsonAsParameter(taxDefaultParamsList);
		}catch(e){
			showErrorMessage("taxDefaultsParam",e);
		}
	}
	
	function deleteDirectPremCollns() {
		try{
		var deleteDirectPremCollnsList = eval("[]");
		var deleteDirectPremCollnss = {};
		var currObj = {};
		for ( var n = 0; n < objAC.objGdpc.length; n++) {
			currObj = objAC.objGdpc[n];

			if (currObj.recordStatus) {
				if (currObj.recordStatus == -1) {
					deleteDirectPremCollnss = {};
					deleteDirectPremCollnss.gaccTranId = currObj.gaccTranId;
					deleteDirectPremCollnss.issCd = currObj.issCd;
					deleteDirectPremCollnss.premSeqNo = currObj.premSeqNo;
					deleteDirectPremCollnss.instNo = currObj.instNo;
					deleteDirectPremCollnss.tranType = currObj.tranType;
					deleteDirectPremCollnsList.splice(
							deleteDirectPremCollnsList.length, 0,
							deleteDirectPremCollnss);
				}
			}

		}
		return prepareJsonAsParameter(deleteDirectPremCollnsList);
		}catch(e){
			showErrorMessage("deleteDirectPremCollns",e);
		}
	}
	
	function getRecordCount() {
		var recCount = 0;

		for ( var r = 0; r < objAC.objGdpc.length; r++) {

			if (objAC.objGdpc[r].recordStatus != -1) {
				recCount += 1;
			}
		}
		return recCount;
	}
	
	/* benjo 11.03.2015 GENQA-SR-5015 */
	function saveTaxCollns(){
		try{
			for ( var n = 0; n < objAC.objGdpc.length; n++) {
				if ((objAC.objGdpc[n].recordStatus===0 || objAC.objGdpc[n].recordStatus === 1) && objAC.objGdpc[n].taxAmt != '0') { //changed comparison operator from "==" by robert SR 5447 03.10.16
					try {
						var paramPremAmt; // added by robert SR 5447 03.10.16
						if (objAC.objGdpc[n].otherInfo) {
							paramPremAmt = unformatCurrencyValue(nvl(nvl(objAC.objGdpc[n].otherInfo.paramPremAmt, null) == null ? objAC.objGdpc[n].otherInfo.origPremAmt : objAC.objGdpc[n].otherInfo.paramPremAmt),0);
						} else {
							paramPremAmt = unformatCurrencyValue(nvl(nvl(objAC.objGdpc[n].paramPremAmt, null) == null ? objAC.objGdpc[n].origPremAmt : objAC.objGdpc[n].paramPremAmt),0);
						}
						new Ajax.Request(contextPath+"/GIACDirectPremCollnsController?action=taxDefaultValueType", {
								method : "GET",
								parameters : {
									tranId       : objACGlobal.gaccTranId,
									tranType     : objAC.objGdpc[n].tranType,
									tranSource   : objAC.objGdpc[n].issCd,
									premSeqNo    : objAC.objGdpc[n].premSeqNo,
									instNo       : objAC.objGdpc[n].instNo,
									fundCd       : objACGlobal.fundCd,
									taxAmt       : unformatCurrencyValue(""+objAC.objGdpc[n].taxAmt), // bonok :: 3.17.2016 :: UCPB SR 21679
									paramPremAmt : paramPremAmt, // added by robert SR 5447 03.10.16
									premAmt      : unformatCurrencyValue(""+objAC.objGdpc[n].premAmt),
									collnAmt     : unformatCurrencyValue(""+objAC.objGdpc[n].collAmt),
									premVatExempt: objAC.objGdpc[n].premVatExempt,
									revTranId    : objAC.objGdpc[n].revGaccTranId,
									taxType      : objAC.objGdpc[n].tranType,
									commitTag    : "Y"
								},
								evalScripts : true,
								asynchronous : false
							});
					} catch (e) {
						showMessageBox(e.message);
					}
				}
			}
		}catch(e){
			showErrorMessage("saveTaxCollns", e);
		}
	}
	
	function saveDirectPrem(){
		if(checkAcctRecordStatus(objACGlobal.gaccTranId, "GIACS007")){ //marco - SR-5716 - 11.03.2016
			saveTaxCollns(); //benjo 11.03.2015 GENQA-SR-5015
			new Ajax.Request(
					"GIACDirectPremCollnsController?action=saveDirectPremCollnsDtls2",
					{
						method : "POST",
						parameters : {
							giacDirectPremCollns : giacDirectPremCollns(),
							listToDelete : deleteDirectPremCollns(),
							taxDefaultParams : taxDefaultsParam(),
							giacDirectPremCollnsAll : giacDirectPremCollnsAll(),
							gaccTranId : objACGlobal.gaccTranId,
							moduleName : "GIACS007",
							branchCd : objACGlobal.branchCd,
							fundCd : objACGlobal.fundCd,
							orFlag : objACGlobal.orFlag,
							tranSource : objACGlobal.tranSource,
							recCount : getRecordCount()
						},
						evalScripts : true,
						asynchronous : false,
						onComplete : function(response) {
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
								objAC.formChanged = 'N';
								if(objAC.btnDcOk == 'N'){
									showMessageBox(objCommonMessage.SUCCESS ,imgMessage.SUCCESS);
								}
							}
							changeTag = 0;
							objAC.btnDcOk = 'N';
							loadDirectPremCollnsForm(1);
						}
					});
		}
	}
	
	$("btnSaveDirectPrem").observe("click", function() {
		if (objAC.formChanged == 'N') {
			showMessageBox("No changes to save." ,imgMessage.INFO);
		}else{
			saveDirectPrem();
		}
	});
	
	$("btnCancel").observe("click", function() {
		fireEvent($("acExit"), "click");
	});
	
	$("editParticulars").observe("click", function () {
		if($("particulars").hasAttribute("readonly")){
			showOverlayEditor("particulars", 500, $("particulars").hasAttribute("readonly")); 
		}else{
			showEditor("particulars", 500);
		}
	});

	$("particulars").observe("keyup", function () {
		limitText(this, 500);
	});
	
	observeAccessibleModule(accessType.BUTTON, "GIACS214", "btnAssured",  function(){
		showGiacs214();		//shan 12.04.2013
	});
	
	observeAccessibleModule(accessType.BUTTON, "GIACS213", "btnPlateNo", function(){
		showGiacs213();		//shan 12.04.2013
	});
	
	setModuleId("GIACS007");
	setDocumentTitle("Direct Premium Collections");
	objACGlobal.calledForm = "GIACS007";
	
	function disableGIACS007(){
		try {
			disableButton("btnAdd");
			$("tranType").removeClassName("required");
			$("tranType").disable();
			$("tranSource").removeClassName("required");
			$("tranSource").disable();
			$("billCmNo").readOnly = true;
			$("billCmNo").removeClassName("required");
			$("instNo").readOnly = true;
			$("instNo").removeClassName("required");
			$("premCollectionAmt").readOnly = true;
			$("directPremAmt").readOnly = true;
			$("taxAmt").readOnly = true;
			$("premCollectionAmt").removeClassName("required");
			$("directPremAmt").removeClassName("required");
			$("instNoDiv").removeClassName("required");
			$("billCmNoDiv").removeClassName("required");
			$("taxAmt").removeClassName("required");
			$("radioAssd").disable();
			$("radioIntm").disable();
			$("particulars").readOnly = true;
			$("billCmNoDiv").style.backgroundColor = "";
			$("instNoDiv").style.backgroundColor = "";
			disableSearch("oscmBillIssCd"); // SR-20000 : shan 08.24.2015
			disableSearch("oscmBillCmNo");
			disableSearch("oscmInstNo");
			disableButton("btnAssured");
			disableButton("btnPlateNo");
			disableButton("btnSaveDirectPrem");
			disableButton("btnUpdate"); //robert 12.19.12
			disableButton("btnSpecUpdate"); //robert 12.19.12
			disableButton("btnPolicy"); //robert 12.19.12
			disableButton("btnDatedCheck"); //robert 12.19.12
		} catch(e){
			showErrorMessage("disableGIACS007", e);
		}
	}
	//added cancelOtherOR by robert 10302013
	if (objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C"
			|| objACGlobal.orTag == "S" || (objAC.tranFlagState != undefined && objAC.tranFlagState != 'O') 
			|| (objACGlobal.orFlag == "P" && objACGlobal.orTag != "*" && nvl(objAC.tranFlagState, "") != 'O') || objACGlobal.queryOnly == "Y"){ //robert 12.17.12 added condition
		disableGIACS007();
	}
	
	if(!checkUserModule('GIACS007')){
		showWaitingMessageBox('You are not allowed to access this module.', 'I', disableGIACS007);
		disableButton("btnPremColln");
	}
	
	initializeChangeTagBehavior(saveDirectPrem);
	changeTag = 0;
	objAC.overdueOverride = null;
	objAC.claimsOverride = null;
	objAC.cancelledOverride = null;
	makeInputFieldUpperCase();	// SR-20000 : shan 08.24.2015
</script>