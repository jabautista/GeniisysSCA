<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="invoiceCommMainDiv" name="invoiceCommMainDiv" style="margin-top: 1px;">
	<jsp:include page="subPages/bondParInformation2.jsp"></jsp:include>
		
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Invoice Information</label>
			<span class="refreshers" style="margin-top: 0;">
				<label name="gro" style="margin-left: 5px;">Hide</label>
			</span>
		</div>
	</div>
	
	<div class="sectionDiv" id="InvoiceInfoDiv" name="InvoiceInfoDiv">
		<div style="margin: 10px;">
			<table align="center">
				<tr>
					<td class="rightAligned">Take Up</td>
					<td class="leftAligned">
						<select id="txtTakeupSeqNo" name="txtTakeupSeqNo" style="width: 120px; margin-right: 80px;">
							<option value=""></option>
						</select>
					</td>
					<td class="rightAligned">Booking Date</td>
					<td class="leftAligned">
						<input type="text" style="width: 119px;" id="txtMultiBookingYY" name="txtMultiBookingYY" readonly="readonly" value="" />
						<input type="text" style="width: 119px;" id="txtMultiBookingMM" name="txtMultiBookingMM" readonly="readonly" value="" />
					</td>	
				</tr>
			</table>
		</div>
	</div>
	
	<div id="basicInfoDiv" name="intmInfoDiv" style="display: none;">
	</div>
	
	<form id="intmInfoForm" name="intmInfoForm">
		<input type="hidden" id="txtB240NbEndtYy" name="txtB240NbEndtYy" value="${varEndtYy}"/>
		<input type="hidden" id="txtB240ParId" 	name="txtB240ParId"  value=""/>
		<input type="hidden" id="txtB240AssdNo" name="txtB240AssdNo" value=""/>
		<input type="hidden" id="txtB240LineCd" name="txtB240LineCd" value=""/>
		
		<!-- Other variables, used in underwriting.js -->
		<input type="hidden" id="isIntmOkForValidation" 	name="isIntmOkForValidation" 			value="N"/> <!-- used for checking if intm is ok for validation -->
		
		<jsp:include page="subPages/bondInvCommission.jsp"></jsp:include>
		
		<div id="mainInvoicePerilDiv">
			<jsp:include page="subPages/bondCommInvoicePerils.jsp"></jsp:include>
		</div>
		<div id="bancaDtlDiv" style="display: none">
			<jsp:include page="subPages/bancaDetails.jsp"></jsp:include>
		</div>
	</form>
	
	<div class="buttonsDiv" id="wcButtonsDiv">
		<input type="button" class="button" style="width: 90px;" id="btnCancel" name="btnCancel" value="Cancel" />
		<input type="button" class="button" style="width: 90px;" id="btnSave" name="btnSave" value="Save" />
	</div>
</div>

<script type="text/javascript">
	initializeAccordion();
	initializeAll();
	initializeAllMoneyFields();
	/** VARIABLES **/
	// Lists/Data Blocks 
	var b240 = JSON.parse('${parlist}'.replace(/\\/g, '\\\\'));
	var b450 = eval('${winvoices}'); 
	//var wcominv = eval('${wcommInvoices}'); //belle 06.04.12 replaced by wComInvIntmNo 
	//var wComInvIntmNo = eval('${wComInvIntmNo}'); edited by gab 11.05.2015
	var wComInvIntmNo = "${wComInvIntmNo}";
	var wcominvper = eval('${wcommInvoicePerils}');
	var wcominvIntmNoLov = "${vWcominvIntmLov}"; // the current LOV name of the Intm No LOV. LOV Names are: cgfk$wcominvDspIntmName5 (Unfiltered/Default), cgfk$wcominvDspIntmName (Filtered), and cgfk$wcominvDspIntmName3
	var bancaB = eval('${bancaB}');

	// page variables
	var selectedWcominvRow = null;
	var selectedWcominvIndex = null;
	var prevSharePercentage = 0;
	var currentBancaBRowNo = -1; 				// row no of current BANCA_B record selected. -1 when no rows are selected
	var selectedBancaBRow = null;				// the selected BANCA_B row, used for updating
	var bancaBLastNo = 0; 						// last row no of WCOMINV
	var prevTakeupSeqNo = null;
	var selectedOrigSharePercentage = 0;
	var selectedOrigComputedCommRate = 0;       // For newly inserted records - Irwin. 10.28.11 // as per mam grace, kahit na saved ang record, dapat validate parin sa original computed rate nya. -- 11.02.11 
		
	// FMB Variables
	var varOverrideWhtax = "${varOverrideWhtax}";
	var vOra2010Sw = ('${vOra2010Sw }');
	var vValidateBanca = ('${vValidateBanca }');
	var vAllowApplySlComm = ('${vAllowApplySlComm }');
	var varBancRateSw = "${varBancRateSw}";
	var varTaxAmt = 0;
	var varMissingPerils = "";
	var varPerilCd;
	var varIssCd;
	var globalCancelTag = ('${globalCancelTag }');
	var varUserCommUpdateTag = "${varUserCommUpdateTag}";
	var varVParamShowComm = "${varVParamShowComm}";
	
	/* benjo 09.07.2016 SR-5604 */
	var reqDfltIntmPerAssd = '${reqDfltIntmPerAssd}'; 
	var allowUpdIntmPerAssd = '${allowUpdIntmPerAssd}';
	var overrideUser = '${userId}';
	var override = "N";
	/* end SR-5604 */
	
	// Record Group
	var rgWtRate = new Array();	

	var varSharePercentage = "";	// shan 11.15.2013

	/** Fill up text fields **/ 
	
	// b240
	$("parNo").value = b240.drvParSeqNo;
	$("assuredName").value = unescapeHTML2(b240.dspAssdName);
	//belle 06.01.12 
	$("txtB240AssdNo").value = b240.assdNo;
	$("txtB240LineCd").value = b240.lineCd;
	$("txtB240ParId").value = b240.parId;
	//end belle
	
	// b450
	populateTakeupSeqNoList();
	
	if (b450.length > 0) {
		$("txtMultiBookingMM").value = b450[0].multiBookingMM;
		$("txtMultiBookingYY").value = b450[0].multiBookingYY;
	}

	/** initialization **/
	for (var i = 0; i < wcominvper.length; i++) {
		// POST-QUERY for WCOMINVPER
		wcominvper[i].nbtCommissionRtComputed = null; 
		wcominvper[i].netCommission = parseFloat(nvl(wcominvper[i].commissionAmount, "0")) - parseFloat(nvl(wcominvper[i].withholdingTax, "0"));
		wcominvper[i].recordStatus = null;
	}
	
	setModuleId("GIPIS160");
	setDocumentTitle("Invoice Commission");

	executeB450whenNewBlockInstance();

	// BANCA_B
	if (bancaB.length > 0) {
		for (var i = 0; i < bancaB.length; i++) {
			var content = generateBancTypeDtlContent(bancaB[i], i);
			bancaB[i].recordStatus = null;
			addTableRow("row"+i, "rowBancTypeDtl", "bancTypeDtlTableContainer", content, clickBancTypeDtlRow);
			bancaBLastNo = bancaBLastNo + 1;
		}
		checkIfToResizeTable("bancTypeDtlTableContainer", "rowBancTypeDtl");
	} else {
		checkTableIfEmpty("rowBancTypeDtl", "bancTypeDtlTableMainDiv");
	}

	if (vOra2010Sw == "Y" && objGIPIWPolbas.bancassuranceSw =="Y") { // added objGIPIWPolbas.bancassuranceSw  // added by irwin 10.26.11
		$("chkBancaCheck").style.display = "inline";
		$("banacassureCheckText").innerHTML = "Bancassurance";
		$("chkBancaCheck").checked = true; //belle 06.06.12
	} else {
		$("chkBancaCheck").style.display = "none";
		$("banacassureCheckText").innerHTML = "";
	}
	
	

	/** Table Grid **/
	
	try {
		var objWcominvArray = [];
		var objWcominv = new Object();
		objWcominv.objWcominvListTableGrid = JSON.parse('${wcominvListTableGrid}'.replace(/\\/g, '\\\\'));
		objWcominv.objWcominvList = objWcominv.objWcominvListTableGrid.rows || [];

		var wcominvTableModel = {
				options:{
					title: '',
					width: '800px',
					onCellFocus: function(element, value, x, y, id){
						wcominvListTableGrid.keys.removeFocus(wcominvListTableGrid.keys._nCurrentFocus, true);
						wcominvListTableGrid.keys.releaseKeys();
						var mtgId = wcominvListTableGrid._mtgId;
						
						if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
							selectedWcominvRow = 'mtgRow'+mtgId+'_'+y;
							selectedWcominvIndex = y;
						}
						
						// clear fields first
						populateWcominvFields(null);
						populateWcominvperFields(null);
						
						if (y >= 0) {
							populateWcominvFields(wcominvListTableGrid.rows[y]);
							populateWcominvperFields(wcominvListTableGrid.rows[y]);
						} else {
							y = Math.abs(y) - 1;
							populateWcominvFields(wcominvListTableGrid.newRowsAdded[y]);
							populateWcominvperFields(wcominvListTableGrid.newRowsAdded[y]);
						}
						observeChangeTagInTableGrid(wcominvListTableGrid);

						//buttons
						$("btnSaveIntm").value = "Update";
						enableButton($("btnDeleteIntm"));

						//other variables
						prevSharePercentage = 0;

						if(objGIPIWPolbas.polFlag == 4){// added by Irwin 11.3.11
							$("txtSharePercentage").readOnly = true;
							$("txtPerilCommissionRate").readOnly = true;
							$("txtPerilCommissionAmt").readOnly = true;
						}else{
							$("txtSharePercentage").removeAttribute("readonly");
							$("txtPerilCommissionRate").removeAttribute("readonly");
							$("txtPerilCommissionAmt").removeAttribute("readonly");
						}	

						if(varUserCommUpdateTag == "N"){
							$("txtPerilCommissionRate").readOnly = true;
							$("txtPerilCommissionAmt").readOnly = true;
						}
					},
					onRemoveRowFocus: function(element, value, x, y, id) {
						wcominvListTableGrid.keys.removeFocus(wcominvListTableGrid.keys._nCurrentFocus, true);
						wcominvListTableGrid.keys.releaseKeys();
						removeWcominvRowFocus();
						$("txtPerilCommissionRate").setAttribute("readonly","readonly");
						$("txtPerilCommissionAmt").setAttribute("readonly","readonly");
						
						// added for share percentage total value -irwin
						$("txtSharePercentage").value = formatToNthDecimal(100 - getTotalSharePercentage($F("txtTakeupSeqNo")),7);
						$("selectedNbtCommissionRtComputed").value = "";   
					},
					onCellBlur: function(){
						observeChangeTagInTableGrid(wcominvListTableGrid);
					},
					afterRender: function(){
						if (b450.length > 0) {
							var mtgId = wcominvListTableGrid._mtgId;
							
							for (var i = 0; i < wcominvListTableGrid.rows.length; i++) {
								if (b450[0].takeupSeqNo != getWcominvObjValue(i, 'takeupSeqNo')) {
									$('mtgRow'+mtgId+'_'+i).hide();
								}
								wcominvListTableGrid.rows[i][wcominvListTableGrid.getColumnIndex('nbtIntmType')] = "";
							}
						}
						wcominvListTableGrid.pagerDiv.hide();
					}
				},
				columnModel: [
					{
						id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
						title: '&#160;D',
					 	altTitle: 'Delete?',
					 	titleAlign: 'center',
						width: 19,
						sortable: false,
					 	editable: true, 			// if 'editable: false,' and 'sortable: false,' and editor is checkbox or instanceof CellCheckbox then hide the 'Select all' checkbox button in header
					  	//editableOnAdd: true,		// if 'editable: false,' you can use 'editableOnAdd: true,' to enable the checkbox on newly added row
					 	//defaultValue: true,		// if 'defaultValue' is not available, default is false for checkbox on adding new row
							editor: 'checkbox',
					 	hideSelectAllBox: true,
					 	visible: false 
					},
					{
						id: 'divCtrId',
						width: '0',
						visible: false
					},
					{
						id: 'intermediaryName',
						title: 'Intermediary Name',
						width: '217px', 
						filterOption: true,
						sortable: false,
						align: 'left',
						titleAlign: 'left' 
					},
					{
						id: 'sharePercentage',
						title: 'Share Percentage',
						width: '110px',
						filterOption: true,
						sortable: false,
						align: 'right', 
						titleAlign: 'center',
						renderer: function(val){
							return formatToNthDecimal(val, 7);
						}
					},
					{
						id: 'premiumAmount',
						title: 'Share Premium',
						width: '90px', 
						filterOption: true,
						sortable: false,
						align: 'right',
						geniisysClass: 'money',
						titleAlign: 'center'
					},
					{
						id: 'commissionAmount',
						title: 'Total Commission',
						width: '108px', 
						filterOption: true,
						sortable: false,
						align: 'right',
						geniisysClass: 'money',
						titleAlign: 'center'
					},
					{
						id: 'netCommission',
						title: 'Net Commission',
						width: '100px', 
						filterOption: true,
						sortable: false,
						align: 'right',
						geniisysClass: 'money',
						titleAlign: 'center'
					},
					{
						id: 'withholdingTax',
						title: 'Total Withholding Tax',
						width: '120px',
						filterOption: true,
						sortable: false,
						align: 'right',
						geniisysClass: 'money',
						titleAlign: 'center'
					},
					{
						id: 'intermediaryNo',
						width: '0',
						visible: false
					},
					{
						id: 'parentIntermediaryNo',
						width: '0',
						visible: false
					},
					{
						id: 'parentIntermediaryName',
						width: '0',
						visible: false
					},
					{
						id: 'parId',
						width: '0',
						visible: false
					},
					{
						id: 'itemGroup',
						width: '0',
						visible: false
					},
					{
						id: 'takeupSeqNo',
						width: '0',
						visible: false
					},
					{
						id: 'nbtIntmType',
						width: '0',
						visible: false
					},
					{
						id: 'intmNoNbt',
						width: '0',
						visible: false
					},
					{
						id: 'sharePercentageNbt',
						width: '0',
						visible: false
					},
					{
						id: 'parentIntmLicTag',
						width: '0',
						visible: false
					},
					{
						id: 'parentIntmSpecialRate',
						width: '0',
						visible: false
					},
					{
						id: 'licTag',
						width: '0',
						visible: false
					},
					{
						id: 'specialRate',
						width: '0',
						visible: false
					}
				],
				resetChangeTag: true,
				rows: objWcominv.objWcominvList
		};

		wcominvListTableGrid = new MyTableGrid(wcominvTableModel);
		wcominvListTableGrid.pager = objWcominv.objWcominvListTableGrid;
		wcominvListTableGrid.render('wcominvListTableGrid');
		wcominvListTableGrid.afterRender = function(){
			objWcominvArray = wcominvListTableGrid.geniisysRows;
		};
	} catch(e){
		showErrorMessage("Bond Invoice Commission", e);
	}

	/** Page Functions **/
	
	// get column value of specified index of wcominv table grid
	function getWcominvObjValue(index, column) {
		if (index < 0) { // new rows
			var newRows = wcominvListTableGrid.getNewRowsAdded();
			//return wcominvListTableGrid.newRowsAdded[Math.abs(index) - 1][wcominvListTableGrid.getColumnIndex(column)],"";
			return nvl(newRows[Math.abs(index) - 1][column],"");
		} else {
			return wcominvListTableGrid.rows[index][wcominvListTableGrid.getColumnIndex(column)];
		}
	}
	
	// get total share percentage value
	function getTotalSharePercentage(takeupSeqNo) {
		try{
			var total = 0;
			var newRows = wcominvListTableGrid.getNewRowsAdded();
			for (var i = 0; i < wcominvListTableGrid.rows.length; i++) {
				if (takeupSeqNo == getWcominvObjValue(i, 'takeupSeqNo')
					&& !isWcominvRowDeleted(wcominvListTableGrid.rows[i])) {
					//&& (getWcominvObjValue(i, 'recordStatus') == null || getWcominvObjValue(i, 'recordStatus') >= 0)) {
					total = total + parseFloat(nvl(getWcominvObjValue(i, 'sharePercentage')), "0");
				}
			}
			for (var i = 0; i < newRows.length; i++) {
				if (takeupSeqNo == getWcominvObjValue(-(i + 1), 'takeupSeqNo')) {
					total = total + parseFloat(nvl(getWcominvObjValue(-(i + 1), 'sharePercentage')), "0");
				}
			}

			return total;
		}catch(e){
			showErrorMessage("getTotalSharePercentage", e);
		}	
		
	}

	// gets the :WCOMINV.v_share_percentage value
	function getWcominvVSharePercentage(intmNo) {
		var vSharePercentage = 0;

		for (var i = 0; i < wcominvListTableGrid.rows.length; i++) {
			if (getWcominvObjValue(i, 'takeupSeqNo') == parseInt(nvl($F("txtTakeupSeqNo"), "0"))
					&& getWcominvObjValue(i, 'intermediaryNo') == intmNo
					&& !isWcominvRowDeleted(wcominvListTableGrid.rows[i])) {
					//&& (getWcominvObjValue(i, 'recordStatus') == null || getWcominvObjValue(i, 'recordStatus') >= 0)) {
				vSharePercentage = vSharePercentage + parseFloat(getWcominvObjValue(i, 'sharePercentage'));
			}
		}

		for (var i = 0; i < wcominvListTableGrid.newRowsAdded.length; i++) {
			if(wcominvListTableGrid.newRowsAdded[i] != null){
				if (getWcominvObjValue(-(i + 1), 'takeupSeqNo') == parseInt(nvl($F("txtTakeupSeqNo"), "0"))
						&& getWcominvObjValue(-(i + 1), 'intermediaryNo') == intmNo) {
					vSharePercentage = vSharePercentage + parseFloat(getWcominvObjValue(-(i + 1), 'sharePercentage'));
				}
			}
		}

		return 100 - vSharePercentage;
	}

	// the WHEN-VALIDATE-ITEM trigger of WCOMINVPER.COMMISSION_RT
	// accepts a WCOMINVPER parameter and updates fields based on the changed commission rate
	function validateWcominvperCommissionRate(wcommInvoicePeril) {
		wcommInvoicePeril.commissionAmount = roundNumber(parseFloat(nvl(wcommInvoicePeril.premiumAmount, "0")) * parseFloat(nvl(wcommInvoicePeril.commissionRate, "0")) / 100, 2);
		if (b240.parType == "P") {
			varTaxAmt = getDefaultTaxRate(wcommInvoicePeril.intermediaryIntmNo);
		}

		wcommInvoicePeril.withholdingTax = roundNumber(roundNumber(parseFloat(nvl(wcommInvoicePeril.commissionAmount, "0")), 2) * parseFloat(nvl(varTaxAmt, "0")) / 100, 2);
		wcommInvoicePeril.netCommission = roundNumber(parseFloat(nvl(wcommInvoicePeril.commissionAmount, "0")), 2) - roundNumber(parseFloat(nvl(wcommInvoicePeril.withholdingTax, "0")), 2);
		if (wcommInvoicePeril.nbtCommissionRtComputed == null || !String(wcommInvoicePeril.nbtCommissionRtComputed).blank()) {
			return;
		} else if (parseFloat(nvl(wcommInvoicePeril.commissionRate, "0")) < parseFloat(nvl(wcommInvoicePeril.nbtCommissionRtComputed, "0"))) {
			showMessageBox("Commission Rate is lower than the Computed Commission Rate of " + wcommInvoicePeril.nbtCommissionRtComputed + "%", imgMessage.INFO);
		}
	}

	// The procedure GET_ADJUST_INTMDRY_RATE. Returns the intermediary rate
	function getAdjustIntmdryRate(wcommInvoice, perilCd) {
		var intmdryRate = 0;

		new Ajax.Request(contextPath+"/GIPIWCommInvoiceController?action=getAdjustIntmdryRate", {
			method: "GET",
			asynchronous: false,
			evalScripts: true,
			parameters: {
				intrmdryIntmNo: wcommInvoice.intermediaryNo,
				parId: b240.parId,
				perilCd: perilCd
			},
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					if (!response.responseText.blank()) {
						intmdryRate = parseFloat(response.responseText);
					}
				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});

		return intmdryRate;
	}

	// The procedure GET_INTMDRY_RATE. Returns the intermediary rate
	function getIntmdryRate(wcommInvoice, perilCd) {
		var intmdryRate = 0;

		new Ajax.Request(contextPath+"/GIPIWCommInvoiceController?action=getIntmdryRate", {
			method: "GET",
			asynchronous: false,
			evalScripts: true,
			parameters: {
				parId: b240.parId,
				b240ParType: b240.parType,
				b240LineCd: b240.lineCd,
				b240IssCd: b240.issCd,
				intmNo: wcommInvoice.intermediaryNo,
				nbtRetOrig: $("chkNbtRetOrig").checked ? "Y" : "N",
				varPerilCd: perilCd,
				nbtIntmType: wcommInvoice.nbtIntmType,
				globalCancelTag: globalCancelTag,
				itemGrp: wcommInvoice.itemGroup
			},
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					if (!response.responseText.blank()) {
						intmdryRate = parseFloat(response.responseText);
					}
				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
		return intmdryRate;
	}

	// display wcominv rows of selected takeup seq no
	function displayWcominvRecords(takeupSeqNo) {
		var mtgId = wcominvListTableGrid._mtgId;
		
		for (var i = 0; i < wcominvListTableGrid.rows.length; i++) {
			if (takeupSeqNo == getWcominvObjValue(i, 'takeupSeqNo')
				&& !isWcominvRowDeleted(wcominvListTableGrid.rows[i])) {
				$('mtgRow'+mtgId+'_'+i).show();
			} else {
				$('mtgRow'+mtgId+'_'+i).hide();
			}
		}
		
		for (var i = 0; i < wcominvListTableGrid.newRowsAdded.length; i++) {
			if (takeupSeqNo != getWcominvObjValue(-(i + 1), 'takeupSeqNo')) {
				$('mtgRow'+mtgId+'_'+(-(i + 1))).hide();
			} else {
				$('mtgRow'+mtgId+'_'+(-(i + 1))).show();
			}
		}
	}
	
	// function called when focus on a WCOMINV row is removed
	function removeWcominvRowFocus() {
		try{
			if (selectedWcominvRow != null) {
				$(selectedWcominvRow).removeClassName("selectedRow");
			}
			selectedWcominvIndex = null;
			populateWcominvFields(null);
			populateWcominvperFields(null);
			selectedWcominvRow = null;
			//buttons
			$("btnSaveIntm").value = "Add";
			disableButton($("btnDeleteIntm"));
			$("txtPerilCommissionRate").setAttribute("readonly","readonly");
			$("txtPerilCommissionAmt").setAttribute("readonly","readonly");
		}catch(e){
			showErrorMessage("removeWcominvRowFocus",e);
		}	
		
	}
	
	// validates takeup seq no, accepts index as parameter
	function validateTakeupSeqNo(index) {
		try{
			if (getTotalSharePercentage(prevTakeupSeqNo) != 100) { 
				showMessageBox("Total share percentage should be equal to 100%", imgMessage.INFO);
				$("txtTakeupSeqNo").value = prevTakeupSeqNo;
			} else if (nvl(index, -1) >= 0) {
				$("txtMultiBookingMM").value = $("txtTakeupSeqNo").options[index].readAttribute("multiBookingMM");
				$("txtMultiBookingYY").value = $("txtTakeupSeqNo").options[index].readAttribute("multiBookingYY");
				prevTakeupSeqNo = $F("txtTakeupSeqNo");
			}
			//checkTakeUpSeqsPercentage();
		}catch(e){
			showErrorMessage("validateTakeupSeqNo",e);
		}		

	}

	
	function populateTakeupSeqNoList() {
		$("txtTakeupSeqNo").innerHTML = "";

		for (var i = 0; i < b450.length; i++) {
			var newOption = new Element("option");
			newOption.text = b450[i].takeupSeqNo;
			newOption.value = b450[i].takeupSeqNo;
			newOption.setAttribute("itemGrp", b450[i].itemGrp);
			newOption.setAttribute("takeupSeqNo", b450[i].takeupSeqNo);
			newOption.setAttribute("multiBookingMM", b450[i].multiBookingMM);
			newOption.setAttribute("multiBookingYY", b450[i].multiBookingYY);
			newOption.setAttribute("insured", b450[i].insured);

			try {
			    $("txtTakeupSeqNo").add(newOption, null); // standards compliant; doesn't work in IE
			  }
			catch(ex) {
			    $("txtTakeupSeqNo").add(newOption); // IE only
			}
		}

		$("txtTakeupSeqNo").stopObserving();
		$("txtTakeupSeqNo").observe("change", function() {
			validateTakeupSeqNo($("txtTakeupSeqNo").selectedIndex); // seq observe

			/*wcominvListTableGrid.url = contextPath+"/GIPIWCommInvoiceController?action=refreshWcominvListing&parId="+b240.parId+
											"&itemGrp="+$("txtTakeupSeqNo").options[$("txtTakeupSeqNo").selectedIndex].readAttribute("itemGrp")+
											"&takeupSeqNo="+$("txtTakeupSeqNo").options[$("txtTakeupSeqNo").selectedIndex].readAttribute("takeupSeqNo");
			wcominvListTableGrid.refresh();*/

			displayWcominvRecords($F("txtTakeupSeqNo"));
			removeWcominvRowFocus();
			$("txtSharePercentage").value = formatToNthDecimal((100 - getTotalSharePercentage($F("txtTakeupSeqNo"))), 7);
		});

		if (b450.length > 0) {
			prevTakeupSeqNo = $F("txtTakeupSeqNo");
		}
	}

	// populates WCOMINV fields. if parameter is null, clear the fields instead
	function populateWcominvFields(objWcominvRow) {
		var parentIntmNo 		= (objWcominvRow == null) ? "" : nvl(objWcominvRow[wcominvListTableGrid.getColumnIndex('parentIntermediaryNo')], objWcominvRow[wcominvListTableGrid.getColumnIndex('intermediaryNo')]);
		var parentIntmName 		= (objWcominvRow == null) ? "" : nvl(objWcominvRow[wcominvListTableGrid.getColumnIndex('parentIntermediaryName')], objWcominvRow[wcominvListTableGrid.getColumnIndex('intermediaryName')]);
		var sharePercentage		= (objWcominvRow == null) ? 0  : nvl(objWcominvRow[wcominvListTableGrid.getColumnIndex('sharePercentage')], 0);
		
		$("txtIntmNo").value = (objWcominvRow == null) ? 0 : objWcominvRow[wcominvListTableGrid.getColumnIndex('intermediaryNo')];
		$("txtIntmName").value = (objWcominvRow == null) ? "" : unescapeHTML2(objWcominvRow[wcominvListTableGrid.getColumnIndex('intermediaryName')].replace(/\\/g, '\\\\'));
		$("txtParentIntmNo").value = parentIntmNo;		
		$("txtParentIntmName").value = parentIntmName == null ? "" : parentIntmName;
		$("txtDspIntmName").value 		= (objWcominvRow == null) ? "" : unescapeHTML2(objWcominvRow[wcominvListTableGrid.getColumnIndex('intermediaryNo')] + " - " + objWcominvRow[wcominvListTableGrid.getColumnIndex('intermediaryName')]);; //belle 08.01.2012 unesc
		$("txtDspParentIntmName").value = (objWcominvRow == null) ? "" : unescapeHTML2(parentIntmNo + " - " + parentIntmName); //belle 08.01.2012 unesc
		$("txtSharePercentage").value	= (objWcominvRow == null) ? "" : formatToNthDecimal(sharePercentage, 7);

		$("txtNbtIntmType").value = (objWcominvRow == null) ? "" : objWcominvRow[wcominvListTableGrid.getColumnIndex('nbtIntmType')];
		$("txtIntmNoNbt").value = (objWcominvRow == null) ? "" : objWcominvRow[wcominvListTableGrid.getColumnIndex('intmNoNbt')];
		$("txtSharePercentageNbt").value = (objWcominvRow == null) ? "0.00" : formatToNthDecimal(nvl(objWcominvRow[wcominvListTableGrid.getColumnIndex('sharePercentageNbt')], "0"), 7);
		
		$("txtParentIntmLicTag").value = (objWcominvRow == null) ? "" : objWcominvRow.parentIntmLicTag;
		$("txtParentIntmSpecialRate").value = (objWcominvRow == null) ? "" : objWcominvRow.parentIntmSpecialRate;
		// for rate and commission validation - irwin 10.13.11
		selectedOrigSharePercentage = (objWcominvRow == null) ? 0  : parseFloat(nvl(objWcominvRow[wcominvListTableGrid.getColumnIndex('sharePercentage')], 0),2);
		
		$("chkLovTag").checked = false;
		
		if($F("globalParType") == "E" || objGIPIWPolbas.polFlag == 2){
			for(var i = 0; i < dfltIntms.length; i++){
				if($F("txtIntmNo") == dfltIntms[i]){
					$("chkLovTag").checked = true;
					break;
				}
			}
		} else {
			if($F("txtIntmNo") == '${dfltIntmNo}' && objWcominvRow != null)
				$("chkLovTag").checked = true;
		}
		
		//benjo 09.07.2016 SR-5604
		if(reqDfltIntmPerAssd == "Y"){
			if(allowUpdIntmPerAssd == "N"){
				$("chkLovTag").value = "FILTERED";
				$("chkLovTag").checked = true;
				$("chkLovTag").disabled = true;
			}else if(allowUpdIntmPerAssd == "O" && override == "Y"){
				$("chkLovTag").value = "FILTERED";
				$("chkLovTag").checked = true;
			}
		}
	}

	// populates WCOMINVPER fields. if parameter is null, clear the fields instead
	function populateWcominvperFields(objWcominvRow) {
		if (objWcominvRow == null) {
			$("txtPerilPremiumAmt").value 		= "";
			$("txtPerilCommissionRate").value 	= "";
			$("txtPerilWholdingTax").value		= "";
			$("txtPerilCommissionAmt").value	= "";
			$("txtPerilNbtCommissionAmt").value = "";
			return;
		}
		
		var itemGrp 		= (objWcominvRow == null) ? 0 : nvl(objWcominvRow[wcominvListTableGrid.getColumnIndex('itemGroup')], 0);
		var takeupSeqNo 	= (objWcominvRow == null) ? 0 : nvl(objWcominvRow[wcominvListTableGrid.getColumnIndex('takeupSeqNo')], 0);
		var intmNo			= (objWcominvRow == null) ? 0 : nvl(objWcominvRow[wcominvListTableGrid.getColumnIndex('intermediaryNo')], 0);
		
		for (var i = 0; i < wcominvper.length; i++) {
			if (wcominvper[i].intermediaryIntmNo == parseInt(intmNo) &&
					wcominvper[i].itemGroup == parseInt(itemGrp) &&
					wcominvper[i].takeupSeqNo == parseInt(takeupSeqNo)) {
				$("txtPerilPremiumAmt").value 		= formatCurrency(nvl(wcominvper[i].premiumAmount, 0));
				$("txtPerilCommissionRate").value 	= formatToNthDecimal(nvl(wcominvper[i].commissionRate, 0), 7);  //belle 06.15.12
				$("txtPerilWholdingTax").value		= formatCurrency(nvl(wcominvper[i].withholdingTax, 0));
				$("txtPerilCommissionAmt").value	= formatCurrency(nvl(wcominvper[i].commissionAmount, 0));
				$("txtPerilNbtCommissionAmt").value = formatCurrency(nvl(wcominvper[i].netCommission, 0));

				 //$("selectedNbtCommissionRtComputed").value = wcominvper[i].nbtCommissionRtComputed; // removing the value of this field is done in the removeRowFocus of tablegrid
				 $("selectedNbtCommissionRtComputed").value = objUWGlobal.selectedNbtCommissionRtComputed; //belle 06.13.12 replaced by objUWGlobal.selectedNbtCommissionRtComputed after saving null na ung value nung wcominvper[i].nbtCommissionRtComputed
			}
		}
	}

	function executeB450whenNewBlockInstance() {
		if (vOra2010Sw == "Y" && vValidateBanca == "Y") {
			//if (wcominv.length == 0) { belle 06.04.12 replaced by codes below
			if (wComInvIntmNo == null){
				showWaitingMessageBox("This is a bancassurance record. Please check the list of intermediaries.", imgMessage.INFO,
						function(){
							showBancaDetails();
						});
			}
		} else {
			$("btnBancaBut").style.display = "none";
		}
	}

	// get default tax rate (for varTaxAmt) for specified intermediary
	function getDefaultTaxRate(intmNo) {
		var wtaxRate = 0;
		
		new Ajax.Request(contextPath+"/GIISIntermediaryController?action=getDefaultTaxRate", {
			method: "GET",
			asynchronous: false,
			evalScripts: true,
			parameters: {
				intmNo: nvl(intmNo, "0")
			},
			onComplete: function(response) {
				if (checkErrorOnResponse) {
					if (response.responseText.blank() || !isNaN(response.responseText)) {
						wtaxRate = parseFloat(response.responseText);
					} else {
						wtaxRate = 0;
					}
				}
			}
		});

		return wtaxRate;
	}

	function cancelFuncWcommInvoice() {
		try {
			Effect.Fade("parInfoDiv", {
				duration: .001,
				afterFinish: function () {
					if ($("parListingMainDiv").down("div", 0).next().innerHTML.blank()) {
						if($F("globalParType") == "E"){
							showEndtParListing();
						}else{
							showParListing();
						}
					} else {
						$("parInfoMenu").hide();
						Effect.Appear("parListingMainDiv", {duration: .001});
					}
					$("parListingMenu").show();
				}
			});
		} catch (e) {
			showErrorMessage("cancelFuncWcommInvoice", e);
		}
	}

	// Executes SHOW_TAX_RATES procedure
	function showTaxRates() {
		var vBool = false;
		
		showWaitingMessageBox("There were changes made to the withholding tax rate, please choose which rate will be used.", imgMessage.INFO,
				function() {
					
					
					if (vBool) {
					} else {
						showWaitingMessageBox("No witholding tax rate chosen, will now exit form.", imgMessage.INFO,
								cancelFuncWcommInvoice);
						return false;
					}
				});
	}

	// the procedure UPDATE_WCOMM_INV_PERILS
	function updateWcommInvPerils(wcommInvoice) {
		var count = 0;
		
		for (var i = 0; i < wcominvper.length; i++) {
			if (wcominvper[i].itemGroup == parseInt(nvl($("txtTakeupSeqNo").options[$("txtTakeupSeqNo").selectedIndex].readAttribute("itemGrp"), "0")) && wcominvper[i].takeupSeqNo == parseInt(nvl($F("txtTakeupSeqNo"), "0"))
					&& wcominvper[i].intermediaryIntmNo == wcommInvoice.intermediaryNo
					&& wcominvper[i].parId == parseInt(nvl(b240.parId, "0"))
					&& (wcominvper[i].recordStatus == null || wcominvper[i].recordStatus >= 0)) {
				count = count + 1;
			}
		}
		
		if (count > 0) {
			var vOtherPrem = 0;
			var vPremiumAmt;
			var cnt = 0;

			for (var c = 0; c < wcominvper.length; c++) {
				//var c = row.down("input", 0).value;	// shan 11.15.2013

				vPremiumAmt = parseFloat(nvl(wcominvper[c].premiumAmount, "0")) * 100 / parseFloat(nvl(varSharePercentage, "0"));

				if (parseFloat(nvl(wcommInvoice.sharePercentage, "0")) == parseFloat(nvl(varSharePercentage, "0"))) {
					if (cnt == 0 && parseFloat(nvl(wcominvper.premiumAmount, "0")) != 0) {
						vOtherPrem = getVOtherPrem(wcominvper[c].perilCd);
					} else if (cnt > 0) {
						vOtherPrem = getVOtherPrem(wcominvper[c].perilCd);
					}

					wcominvper[c].premiumAmount = vPremiumAmt - vOtherPrem;
				} else {
					wcominvper[c].premiumAmount = vPremiumAmt * parseFloat(nvl(wcommInvoice.sharePercentage, "0")) / 100;
				}

				wcominvper[c].withholdingTax = roundNumber(parseFloat(nvl(wcominvper[c].commissionAmount, "0")), 2) * parseFloat(nvl(varTaxAmt, "0")) / 100;

				// will be tagged as updated only if current recordStatus != -1
				wcominvper[c].recordStatus = wcominvper[c].recordStatus != -1 ? 1 : wcominvper[c].recordStatus;
			}
			//displayWcominvperRecords($F("txtItemGrp"), $F("txtTakeupSeqNo"), wcommInvoice.intermediaryNo);
		}
	}

	// deletes a WCOMINV record of specified WCOMINV record
	function deleteWcominvperRow(index) {
		// tag the record as deleted. if previously added, mark as -2
		if (wcominvper[index].recordStatus == 0 || wcominvper[index].recordStatus == -2) {
			wcominvper[index].recordStatus = -2;
		} else {
			wcominvper[index].recordStatus = -1;
		}
	}

	// deletes all WcominvperRecord of selected item grp, takeup seq no, and specified intermediary no
	// removes all displayed WCMINVPER record afterwards
	function deleteAllWcominvperRecords(intmNo) {
		if (wcominvper.length > 0) {
			for (var i = 0; i < wcominvper.length; i++) {
				if (wcominvper[i].itemGroup == parseInt(nvl($("txtTakeupSeqNo").options[$("txtTakeupSeqNo").selectedIndex].readAttribute("itemGrp"), "0")) && wcominvper[i].takeupSeqNo == parseInt(nvl($F("txtTakeupSeqNo"), "0"))
						&& wcominvper[i].intermediaryIntmNo == parseInt(nvl(intmNo, "0"))
						&& wcominvper[i].parId == parseInt(nvl(b240.parId, "0"))
						&& (wcominvper[i].recordStatus == null || wcominvper[i].recordStatus >= 0)) {
					deleteWcominvperRow(i);
				}
			}
		}
	}

	// add WCOMINVPER record to the obj array
	function addWcominvperRecord(wcommInvoicePeril) {
		var exists = false;
		var index = 0;
		var status = "";
		
		if (wcominvper.length > 0) {
			for (var i = 0; i < wcominvper.length; i++) {
				if (wcominvper[i].itemGroup == parseInt(nvl($("txtTakeupSeqNo").options[$("txtTakeupSeqNo").selectedIndex].readAttribute("itemGrp"), "0")) && wcominvper[i].takeupSeqNo == parseInt(nvl($F("txtTakeupSeqNo"), "0"))
						&& wcominvper[i].intermediaryIntmNo == parseInt(nvl(wcommInvoicePeril.intermediaryIntmNo, "0"))
						&& wcominvper[i].parId == parseInt(nvl(b240.parId, "0"))
						&& wcominvper[i].perilCd == wcommInvoicePeril.perilCd && !wcominvper[i].fromBanca) {
					exists = true;
					index = i;
					status = wcominvper[i].recordStatus;
					break;
				}
			}
		}
		
		if (exists) {
			if (status = -1 || status == null) {
				wcommInvoicePeril.recordStatus = 1;
			} else if (status == 0 || status == -2) {
				wcommInvoicePeril.recordStatus = 0;
			}
			wcominvper[index] = wcommInvoicePeril;
		} else {
			wcommInvoicePeril.recordStatus = 0;
			wcominvper.push(wcommInvoicePeril); //dito na irwin
		}
	}

	// The procedure POPULATE_WCOMM_INV_PERILS
	function populateWcommInvPerils(wcommInvoice) {
		new Ajax.Request(contextPath+"/GIPIWCommInvoiceController?action=populateWcommInvPerils", {
			method: "GET",
			asynchronous: false,
			evalScripts: true,
			parameters: {
				parId: b240.parId,
				lineCd: b240.lineCd,
				itemGrp: wcommInvoice.itemGroup
			},
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					var result = response.responseText.toQueryParams();
					if (result.message == "POPULATE_WCOMM_INV_PERILS") {
						
						new Ajax.Request(contextPath+"/GIPIWCommInvoiceController?action=populateWcommInvPerils2", {
							method: "GET",
							asynchronous: false,
							evalScripts: true,
							parameters: {
								parId: b240.parId,
								itemGrp: wcommInvoice.itemGroup,
								takeupSeqNo: wcommInvoice.takeupSeqNo,
								lineCd: b240.lineCd
							},
							onComplete: function(response2) {
								if (checkErrorOnResponse(response2)) {
									var gipiWinvperlList = eval(response2.responseText);
									var vOtherPrem = 0;
									var varRate = 0;

									for (var i = 0; i < gipiWinvperlList.length; i++) {
										var wcommInvoicePeril = new Object(); // the new WCOMINVPER record to be added
										var premAmt = (gipiWinvperlList[i].premAmt == null) ? 0 : parseFloat(gipiWinvperlList[i].premAmt);
										varPerilCd = gipiWinvperlList[i].perilCd;
										wcommInvoicePeril.parId = b240.parId;
										wcommInvoicePeril.itemGroup = parseInt(nvl($("txtTakeupSeqNo").options[$("txtTakeupSeqNo").selectedIndex].readAttribute("itemGrp"), "0")); //formerlly $F("txtItemGrp"). The element itself is non existing
										wcommInvoicePeril.takeupSeqNo = $F("txtTakeupSeqNo");
										wcommInvoicePeril.intermediaryIntmNo = wcommInvoice.intermediaryNo;
										wcommInvoicePeril.recordStatus = 0; // newly added
										if (result.varIssCd.blank()) {
											showMessageBox("Parameter HO does not exist in giis parameters.", imgMessage.ERROR);
											return;
										}
										varIssCd = result.varIssCd;
										
										var slidingComm = "Y";
										
										if (vOra2010Sw == "Y" && vValidateBanca == "Y" && varBancRateSw == "Y") {
											varRate = parseFloat(nvl($F("txtBancRate").replace(/,/g,""), "0"));
										} else {
											var intmdryRate = 0;											
											var appRes;
											// Get independent applyComm and Rate. added by irwin. 10.13.11
											new Ajax.Request(contextPath+"/GIPIWCommInvoiceController?action=applySlidingCommission", {
												method: "GET",
												asynchronous: false,
												evalScripts: true,
												parameters: {
													parId: b240.parId,
													lineCd: b240.lineCd,
													sublineCd: b240.sublineCd,
													perilCd: varPerilCd
												},
												onComplete: function(r) {
													if (checkErrorOnResponse(r)) {
														if (!r.responseText.blank()) {
															appRes = r.responseText.toQueryParams();
															slidingComm = appRes.slidingComm;
															varRate = appRes.rate;
															//intmdryRate = parseFloat(response.responseText);
														}
													} else {
														showMessageBox(r.responseText, imgMessage.ERROR);
													}
												}
											});
											
											//put allow_apply_sliding_comm procedure code here when found (emman 01.20.2010)
											if (vAllowApplySlComm == "Y") { // vAllowApplySlComm
												if(slidingComm =="Y"){
													varRate = getIntmdryRate(wcommInvoice, varPerilCd);
												}else{
													// retain varRate value
												}
											} else {
												varRate = getIntmdryRate(wcommInvoice, varPerilCd);
											}
											
											if ((!$("chkNbtRetOrig").checked && slidingComm == "Y") && !($F("globalParType") == "E" && $F("txtIntmNo") == '${dfltIntmNo}')) {	
												varRate = parseFloat(varRate) + getAdjustIntmdryRate(wcommInvoice, varPerilCd);
											}
										}										
										
										wcommInvoicePeril.nbtCommissionRtComputed = varRate;
										objUWGlobal.selectedNbtCommissionRtComputed = varRate; //belle 06.13.12
										if (!(nvl(String(varRate), "0").blank())) {
											
											wcommInvoicePeril.perilCd = gipiWinvperlList[i].perilCd;
											wcommInvoicePeril.perilName = gipiWinvperlList[i].perilName;

											/* if(parseFloat(nvl(wcommInvoice.sharePercentage, "0")) == getWcominvVSharePercentage(wcommInvoice.intermediaryNo)
												&& parseFloat(wcommInvoice.sharePercentage) != 100) {
												vOtherPrem = getVOtherPrem(gipiWinvperlList[i].perilCd);
												wcommInvoicePeril.premiumAmount = premAmt - vOtherPrem;
											} else {
												wcommInvoicePeril.premiumAmount = premAmt * (parseFloat(nvl(wcommInvoice.sharePercentage), "0")) / 100;
											} */
											
											wcommInvoicePeril.premiumAmount = premAmt * (parseFloat(nvl(wcommInvoice.sharePercentage), "0")) / 100;
											
											wcommInvoicePeril.commissionRate = roundNumber(parseFloat(nvl(varRate, "0")), 7);
											validateWcominvperCommissionRate(wcommInvoicePeril);
										}
										if(wcommInvoicePeril != null) {
											//wcommInvoicePeril.nbtCommissionRtComputed = null;  //removed null assignment so that original rate computed will remain in the object -- irwin
											addWcominvperRecord(wcommInvoicePeril); // dito nag populate ng bagong values
										}
									}
								} else {
									showMessageBox(response2.responseText, imgMessage.ERROR);
								}
							}
						});
					} else if (result.message = "POPULATE_PACKAGE_PERILS") {
						new Ajax.Request(contextPath+"/GIPIWCommInvoiceController?action=populatePackagePerils", {
							method: "GET",
							asynchronous: false,
							evalScripts: true,
							parameters: {
								parId: b240.parId,
								itemGrp: wcommInvoice.itemGroup
							},
							onComplete: function(response2) {
								if (checkErrorOnResponse(response2)) {
									var wcommInvoicePeril = new Object(); // the new WCOMINVPER record to be added
									var gipiWitmperlList = eval(response2.responseText);
									var vOtherPrem = 0;

									for (var i = 0; i < gipiWitmperlList.length; i++) {
										var premAmt = (gipiWitmperlList[i] == null) ? 0 : parseFloat(gipiWitmperlList[i].premAmt);
										varPerilCd = gipiWitmperlList[i].perilCd;

										wcommInvoicePeril.parId = b240.parId;
										wcommInvoicePeril.takeupSeqNo = $F("txtTakeupSeqNo");
										wcommInvoicePeril.intermediaryIntmNo = wcommInvoice.intermediaryNo;
										wcommInvoicePeril.recordStatus = 0; // newly added

										if (result.varIssCd.blank()) {
											showMessageBox("Parameter HO does not exist in giis parameters.", imgMessage.ERROR);
											return;
										}

										varIssCd = result.varIssCd;

										varRate = getPackageIntmRate(gipiWitmperlList[i].itemNo, gipiWitmperlList[i].packLineCd, gipiWitmperlList[i].perilCd, wcommInvoices.intermediaryNo);

										if(!String(varRate).blank()) {
											wcommInvoicePeril.itemGrp = gipiWitmperlList[i].itemNo;
											wcommInvoicePeril.perilCd = gipiWitmperlList[i].perilCd;
											wcommInvoicePeril.perilName = gipiWitmperlList[i].perilName;
											wcommInvoicePeril.premiumAmount = gipiWitmperlList[i].premAmt * parseFloat(nvl(wcommInvoice.sharePercentage, "0")) /100;
											wcommInvoicePeril.commissionRate = varRate;
											validateWcominvperCommissionRate(wcommInvoicePeril);
										}

										if(wcommInvoicePeril != null) {
											addWcominvperRecord(wcommInvoicePeril);
										}
									}
								} else {
									showMessageBox(response2.responseText, imgMessage.ERROR);
								}
							}
						});
					} else {
						showMessageBox(result.message, imgMessage.INFO);
					}
				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}

	// The procedure DELETE_WCOMM_INV_PERILS
	function deleteWcommInvPerils(intmNo) {
		if (wcominvper.length > 0) {
			for (var i = 0; i < wcominvper.length; i++) {
				if (wcominvper[i].itemGroup == parseInt(nvl($("txtTakeupSeqNo").options[$("txtTakeupSeqNo").selectedIndex].readAttribute("itemGrp"), "0")) && wcominvper[i].takeupSeqNo == parseInt(nvl($F("txtTakeupSeqNo"), "0"))
						&& wcominvper[i].intermediaryIntmNo == parseInt(nvl(intmNo, "0"))
						&& wcominvper[i].parId == parseInt(nvl(b240.parId, "0"))
						&& (wcominvper[i].recordStatus == null || wcominvper[i].recordStatus >= 0)) {
					deleteWcominvperRow(i);
				}
			}
		}
	}

	// the procedure COMPUTE_TOT_COM
	function computeTotCom(wcommInvoice) {
		var commissionAmount = 0;
		var withholdingTax = 0;
		var netCommission = 0;
		var premiumAmount = 0;
		if (wcominvper.length > 0) {
			for (var i = 0; i < wcominvper.length; i++) {
				if (wcominvper[i].itemGroup == parseInt(nvl($("txtTakeupSeqNo").options[$("txtTakeupSeqNo").selectedIndex].readAttribute("itemGrp"), "0")) && wcominvper[i].takeupSeqNo == parseInt(nvl($F("txtTakeupSeqNo"), "0"))
						&& wcominvper[i].intermediaryIntmNo == parseInt(nvl(String(wcommInvoice.intermediaryNo), "0"))
						&& wcominvper[i].parId == parseInt(nvl(b240.parId, "0"))
						&& (wcominvper[i].recordStatus == null || wcominvper[i].recordStatus >= 0)) {
					
					commissionAmount = commissionAmount + roundNumber(parseFloat(nvl(wcominvper[i].commissionAmount, "0")), 2);
					withholdingTax = withholdingTax + roundNumber(parseFloat(nvl(wcominvper[i].withholdingTax, "0")), 2);
					netCommission = netCommission + roundNumber(parseFloat(nvl(wcominvper[i].netCommission, "0")), 2);
					premiumAmount = premiumAmount + roundNumber(parseFloat(nvl(wcominvper[i].premiumAmount, "0")), 2);
				}
			}
			
		} 

		wcommInvoice.commissionAmount = commissionAmount;
		wcommInvoice.withholdingTax = withholdingTax;
		wcommInvoice.netCommission = netCommission;
		wcommInvoice.premiumAmount = premiumAmount;
	}
	
	// Executes BANCASSURANCE.get_default_tax_rt function, for enhancement
	function executeBancassuranceGetDefaultTaxRt(wcommInvoice, wcommInvoicePerils, recordStatus) {
		
		try{
			var invoicePeril = (wcommInvoicePerils == null) ? null : ((wcommInvoicePerils.length == 0) ? null : wcommInvoicePerils[0]);
			var ok = true;
			new Ajax.Request(contextPath+"/GIPIWCommInvoiceController?action=executeBancassuranceGetDefaultTaxRt", {
				method: "GET",
				asynchronous: false,
				evalScripts: true,
				parameters: {
					parId: b240.parId,
					parType: b240.parType,
					wcomInvParId: b240.parId,
					intrmdryIntmNo: wcommInvoice.intermediaryNo,
					intrmdryIntmNoNbt: wcommInvoice.intmNoNbt,
					sharePercentage: wcommInvoice.sharePercentage,
					sharePercentageNbt: wcommInvoice.sharePercentageNbt,
					perilCommissionAmount: (invoicePeril == null) ? "" : invoicePeril.commissionAmount,
					takeupSeqNo: $F("txtTakeupSeqNo"),
					systemRecordStatus: recordStatus,
					itemGrp: wcommInvoice.itemGroup,
					globalCancelTag: globalCancelTag,
					vPolicyId: ""
				},
				onCreate: function() {
				},
				onComplete: function(response) {
					if (checkErrorOnResponse(response)) {
						var result = response.responseText.toQueryParams();
						if (result.vRgId == "Y") {
							rgWtRate.splice(0, rgWtRate.length);
						}
						
						if (result.vOv == "Y") {
							new Ajax.Request(contextPath+"/GIACDirectPremCollnsController?action=validateUserFunc", {
								method: "GET",
								asynchronous: false,
								evalScripts: false,
								parameters: {
									funcCode: "OV",
									moduleName: "GIPIS160"
								},
								onComplete: function(response2) {
									if (checkErrorOnResponse(response2)) {
										if (response2.responseText == "TRUE") {
											showTaxRates();
										}
									} else {
										showMessageBox(response2.responseText, imgMessage.ERROR);
									}
								}
							});
						}
						if (result.vAddGroupRow == "Y") {
							var wtRate = new Object();
							wtRate.rec = rgWtRate.length + 1;
							wtRate.pol = varTaxAmt;

							new Ajax.Request(contextPath+"/GIPIPolbasicController?action=getPolicyNo", {
								method: "GET",
								asynchronous: false,
								evalScripts: false,
								parameters: {
									policyId: result.vPolicyId
								},
								onComplete: function(response2) {
									if (checkErrorOnResponse(response2)) {
										wtRate.wtr = response2.responseText;

										rgWtRate.push(wtRate);
									} else {
										showMessageBox(response2.responseText, imgMessage.INFO);
									}
								}
							});
						}
						if (result.vCheckCommPeril == "Y") {
							new Ajax.Request(contextPath+"/GIACDirectPremCollnsController?action=checkPerilCommRate", {
								method: "GET",
								asynchronous: false,
								evalScripts: false,
								parameters: {
									intrmdryIntmNo: "OV",
									parId: "GIPIS160",
									itemGrp: wcommInvoice.itemGroup,
									takeupSeqNo: wcommInvoice.takeupSeqNo,
									lineCd: b240.lineCd,
									issCd: b240.issCd,
									nbtIntmType: wcommInvoice.nbtIntmType					
								},
								onComplete: function(response2) {
									if (checkErrorOnResponse(response2)) {
										varMissingPerils = response2.responseText;
										if (!response2.responseText.blank()) {
											showMessageBox("Please check intermediary commission rates for the following perils: " + response2.responseText, imgMessage.ERROR);
											ok = false;
										}
									} else {
										showMessageBox(response2.responseText, imgMessage.ERROR);
									}
								}
							});
						}
						if (!ok) {
							return;
						}
						if (result.vMsgAlert1 == "Y") {
							showMessageBox("Intermediary is required.", imgMessage.INFO);
							return false;
						}
						if (result.vUpdWcommInvPerils == "Y") {
							updateWcommInvPerils(wcommInvoice); // irwin2
							populateWcommInvPerils(wcommInvoice);	// UCPBGEN-Phase 3 SR-586 : shan 11.15.2013
						}
						
						if (result.vPopWcommInvPerils == "Y" || $("chkNbtRetOrig").checked) {
							deleteAllWcominvperRecords(wcommInvoice.intermediaryNo);
							populateWcommInvPerils(wcommInvoice);
						}
						if (result.vDelWcommInvPerils == "Y") {
							populateWcommInvPerils(wcommInvoice); //belle 06.13.12
							deleteWcommInvPerils(wcommInvoice.intermediaryNo);
						}

						if (result.vMsgAlert2 == "Y") {
							showMessageBox("No data found on giac_parameters for parameter 'SHOW_COMM_AMT'", imgMessage.INFO);
							ok = false;
							return;
						}
						if (result.vComputeTotCom == "Y") {
							computeTotCom(wcommInvoice);
						}
					} else {
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});

			return ok;
		}catch(e){
			showErrorMessage("executeBancassuranceGetDefaultTaxRt",e);	
		}
		
	}

	// updates the table grid row of specified wcominv
	function updateWcominvRow(index, wcommInvoice) {
		wcominvListTableGrid.setValueAt(wcommInvoice.commissionAmount, wcominvListTableGrid.getColumnIndex('commissionAmount'), index,true);
		wcominvListTableGrid.setValueAt(wcommInvoice.netCommission, wcominvListTableGrid.getColumnIndex('netCommission'), index,true);
		wcominvListTableGrid.setValueAt(wcommInvoice.premiumAmount, wcominvListTableGrid.getColumnIndex('premiumAmount'), index,true);
		wcominvListTableGrid.setValueAt(wcommInvoice.sharePercentage, wcominvListTableGrid.getColumnIndex('sharePercentage'), index,true);
		wcominvListTableGrid.setValueAt(wcommInvoice.withholdingTax, wcominvListTableGrid.getColumnIndex('withholdingTax'), index,true);
		wcominvListTableGrid.setValueAt(wcommInvoice.intmNoNbt, wcominvListTableGrid.getColumnIndex('intmNoNbt'), index,true);
		wcominvListTableGrid.setValueAt(wcommInvoice.sharePercentageNbt, wcominvListTableGrid.getColumnIndex('sharePercentageNbt'), index,true);
		wcominvListTableGrid.setValueAt(wcommInvoice.nbtIntmType, wcominvListTableGrid.getColumnIndex('nbtIntmType'), index,true);
		wcominvListTableGrid.setValueAt(wcommInvoice.intermediaryName, wcominvListTableGrid.getColumnIndex('intermediaryName'), index,true);
		wcominvListTableGrid.setValueAt(wcommInvoice.intermediaryNo, wcominvListTableGrid.getColumnIndex('intermediaryNo'), index,true);
		wcominvListTableGrid.setValueAt(wcommInvoice.parentIntermediaryName, wcominvListTableGrid.getColumnIndex('parentIntermediaryName'), index,true);
		wcominvListTableGrid.setValueAt(wcommInvoice.parentIntermediaryNo, wcominvListTableGrid.getColumnIndex('parentIntermediaryNo'), index,true);
		//wcominvListTableGrid.setValueAt(wcommInvoice.recordStatus, wcominvListTableGrid.getColumnIndex('recordStatus'), index);
	}

	/**
	* Checks the Take up seq numbers if it has comm invoices
	* create by: Irwin Tabisora
	*/
	function checkTakeUpSeqs(){
		try{
			var existing;
			var seqArr = $("txtTakeupSeqNo");

			for(var a = 0; a < seqArr.length; a++){
				existing = false;
				for (var i = 0; i < wcominvListTableGrid.rows.length; i++) {
					if (seqArr[a].value == getWcominvObjValue(i, 'takeupSeqNo')
						&& !isWcominvRowDeleted(wcominvListTableGrid.rows[i])) {
						existing = true;
						break;
					} 
				}
				
				for (var i = 0; i < wcominvListTableGrid.newRowsAdded.length; i++) {
					if (seqArr[a].value == getWcominvObjValue(-(i + 1), 'takeupSeqNo')) {
						existing = true;
						break;
					} 
				}
				if(!existing){
					return false;
				}
			}	

			return true;
		}catch(e){
			showErrorMessage("checkTakeUpSeqs",e);
		}
	}
	function saveWcommInvoice() {
		var rcrCnt = wcominvListTableGrid.getNewRowsAdded().length + wcominvListTableGrid.getModifiedRows().length;
		var noRec = false;
		if(rcrCnt == 0){
			saveWcommInvoice2();
		}else{
			var result = checkTakeUpSeqs();
			
			if (getTotalSharePercentage($F("txtTakeupSeqNo")) < 100 ) { // && rcrCnt != 0 added rcrCnt = To proceed with delete if there are no records existing. -irwin
				showMessageBox("Total Share percentage group must be equal to 100%.", imgMessage.INFO);
				return false;
			}else if(!result){
				showMessageBox("Item Group without Intermediary No. still exists.", imgMessage.INFO);
				$("txtTakeupSeqNo").value = prevTakeupSeqNo;
			}else {
			
				saveWcommInvoice2();
			}
		}
	}
	
	function saveWcommInvoice2(){
		var objParameters = new Object();
		var delWcominv = [];
		var delWcominvper = [];
		var strParam;

		// wcominv
		var addedWcominvRows = wcominvListTableGrid.getNewRowsAdded();
		var modifiedWcominvRows = wcominvListTableGrid.getModifiedRows();
		var delWcominvRows = wcominvListTableGrid.getDeletedRows();
		var setWcominvRows = addedWcominvRows.concat(modifiedWcominvRows);
		
		// wcominvper
		var addedWcominvperRows = getAddedJSONObjects(wcominvper);
		var modifiedWcominvperRows = getModifiedJSONObjects(wcominvper);
		var delWcominvperRows = getDeletedJSONObjects(wcominvper);
		var setWcominvperRows = addedWcominvperRows.concat(modifiedWcominvperRows);
		objParameters.setWcominvRows = setWcominvRows;
		objParameters.setWcominvperRows = setWcominvperRows;
		objParameters.delWcominvRows = delWcominvRows; //objParameters.delWcominvRows = delWcominvRows.concat(modifiedWcominvperRows); hindi ko alam bat naka concat to dito
		objParameters.delWcominvperRows = delWcominvperRows;

		objParameters.parId = $F("txtB240ParId");	//added by Gzelle 10012014
		
		strParam = JSON.stringify(objParameters);
		
		new Ajax.Request(contextPath+"/GIPIWCommInvoiceController?action=saveWcommInvoice", {
			evalScripts: true,
			asynchronous: false,
			parameters: {
				strParameters: strParam
			},
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);						
					//updateParParameters(); // commented by tonio 07/15/2011 andrew - 05.16.2011
					//Added by Tonio 07-11-2011
					if (($F("globalPackParId") != "" || $F("globalPackParId") != null) && $F("globalPackParId") > 0){
						updatePackParParameters();
					}else{
						updateParParameters();
					}
					
					parameters = "";
					
					/*for (var i = 0; i < wcominv.length; i++) {
						if (wcominv[i].recordStatus == 0 || wcominv[i].recordStatus == 1) {
							wcominv[i].recordStatus = null;
						} else if (wcominv[i].recordStatus == -1) {
							wcominv[i].recordStatus = -2;
						}
					}

					for (var i = 0; i < wcominvper.length; i++) {
						if (wcominvper[i].recordStatus == 0 || wcominvper[i].recordStatus == 1) {
							wcominvper[i].recordStatus = null;
						} else if (wcominvper[i].recordStatus == -1) {
							wcominvper[i].recordStatus = -2;
						}
					}*/
					
					changeTag = 0;
					showInvoiceCommissionPage();
				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}

	function isWcominvRowDeleted(obj) {
		var exists = false;

		if (obj == null) {
			return false;
		}
		
		for (var i = 0; i < wcominvListTableGrid.deletedRows.length; i++) {
			if(wcominvListTableGrid.deletedRows[i].itemGroup == obj[wcominvListTableGrid.getColumnIndex('itemGroup')]
				&&	wcominvListTableGrid.deletedRows[i].takeupSeqNo == obj[wcominvListTableGrid.getColumnIndex('takeupSeqNo')]
				&&	wcominvListTableGrid.deletedRows[i].intermediaryNo == obj[wcominvListTableGrid.getColumnIndex('intermediaryNo')]) {
				exists = true;
				break;
			}
		}

		return exists;
	}

	function showBancaDetails() {
		$("showBancaDetails").innerHTML = "Hide";
		$("bancaDtlDiv").style.display = "block";
		$("bancaDetailsInfo").show();
		$("txtBancTypeCd").focus();
		$("txtBancTypeCd").scrollTo(); 
	}

	function hideBancaDetails() {
		$("showBancaDetails").innerHTML = "Show";
		$("bancaDtlDiv").style.display = "none";
		$("bancaDetailsInfo").hide();
		$("txtIntmNo").focus();
		$("txtIntmNo").scrollTo();
	}

	function generateBancTypeDtlContent(bancTypeDtl, rowNum) {
		var content = "";

		var itemNo = bancTypeDtl.itemNo == null ? "---" : bancTypeDtl.itemNo;
		var intmNo = bancTypeDtl.intmNo == null ? "---" : bancTypeDtl.intmNo;
		var intmName = bancTypeDtl.intmName == null ? "---" : bancTypeDtl.intmName;
		var intmType = bancTypeDtl.intmTypeDesc == null ? "---" : bancTypeDtl.intmTypeDesc;
		var fixedTag = bancTypeDtl.fixedTag == null ? "" : (bancTypeDtl.fixedTag == "Y" ? "<img name='checkedImg' src='${pageContext.request.contextPath}/images/misc/ok.jpg' style='width: 10px;'/>" : "");

		content = 
			'<label style="width:  90px;font-size: 10px; text-align: center;">'+intmNo+'</label>' +
			'<label style="width:  90px;font-size: 10px; text-align: center;">'+itemNo+'</label>' +
			'<label style="width: 300px;font-size: 10px; text-align:   left;">'+intmName.truncate(50, "...")+'</label>' +
			'<label style="width: 280px;font-size: 10px; text-align: center;">'+intmType+'</label>' +
			'<label style="width:  20px;font-size: 10px; text-align: center;">'+fixedTag+'</label>' +
			'<input type="hidden"	id="bancaBCount"		name="bancaBCount"	value="'+rowNum+'" />';

		return content;
	}

	// Populates input fields of Banca details
	// @param - rowNum: the array index of the BancTypeDtl record to be displayed
	function populateBancaDetails(rowNum) {
		var bancaDtl = bancaB[rowNum];

		// main details
		$("txtBancaItemNo").value = bancaDtl.itemNo;
		$("txtBancaIntmNo").value = bancaDtl.intmNo;
		$("txtBancaIntmName").value = changeSingleAndDoubleQuotes(bancaDtl.intmName);
		$("txtBancaDrvIntmName").value = changeSingleAndDoubleQuotes(bancaDtl.intmName);
		$("txtBancaIntmType").value = changeSingleAndDoubleQuotes(bancaDtl.intmType);
		$("txtBancaIntmTypeDesc").value = changeSingleAndDoubleQuotes(bancaDtl.intmTypeDesc);
		$("txtBancaSharePercentage").value = bancaDtl.sharePercentage;
		$("chkBancaFixedTag").checked = bancaDtl.fixedTag == "Y" ? true : false;
	}

	// Clear banca detail fields
	function resetBancaFields() {
		$("txtBancaItemNo").value = "";
		$("txtBancaIntmNo").value = "";
		$("txtBancaIntmName").value = "";
		$("txtBancaDrvIntmName").value = "";
		$("txtBancaIntmType").value = "";
		$("txtBancaIntmTypeDesc").value = "";
		$("txtBancaSharePercentage").value = "";
		$("chkBancaFixedTag").checked = false;
	}

	$("btnBancaBut").observe("click", function() {
		if ($("bancaDtlDiv").style.display == "none") {
			showBancaDetails();
		} else {
			hideBancaDetails();
		}
	});

	function clickBancTypeDtlRow(row) {
		$$("div#bancTypeDtlTable div[name='rowBancTypeDtl']").each(function(r) {
			if (row.id != r.id) {
				r.removeClassName("selectedRow");
			}
		});

		row.toggleClassName("selectedRow");

		if (row.hasClassName("selectedRow")) {
			currentBancaBRowNo = row.down("input", 0).value;
			selectedBancaBRow = row;
			populateBancaDetails(currentBancaBRowNo);
		} else {
			currentBancaBRowNo = -1;
			selectedBancaBRow = null;
			resetBancaFields();
		}
	}

	// removes all displayed WCMINV record afterwards
	function deleteAllWcominvRecords() {
		/* for (var i = 0; i < wcominvListTableGrid.rows.length; i++) {
			if (getWcominvObjValue(i, 'itemGroup') == parseInt(nvl($("txtTakeupSeqNo").options[$("txtTakeupSeqNo").selectedIndex].readAttribute("itemGrp"), "0"))
					&& getWcominvObjValue(i, 'takeupSeqNo') == parseInt(nvl($F("txtTakeupSeqNo"), "0"))
					&& !isWcominvRowDeleted(wcominvListTableGrid.rows[i])) {
				wcominvListTableGrid.deleteRow(i);
			}
		} */
		
		for(var i = 0; i < wcominvListTableGrid.rows.length; i++){
			wcominvListTableGrid.deleteRow(i);
			wcominvListTableGrid.rows[i].recordStatus = -1;
		}
	}

	// deletes a WCOMINV record of specified WCOMINV record
	function deleteWcominvperRow(index) {
		// tag the record as deleted. if previously added, mark as -2
		if (wcominvper[index].recordStatus == 0 || wcominvper[index].recordStatus == -2) {
			wcominvper[index].recordStatus = -2;
		} else {
			wcominvper[index].recordStatus = -1;
		}
	}

	// deletes all WcominvperRecord of selected item grp and takeup seq no
	function deleteAllWcominvperRecords2() {		
		for (var i = 0; i < wcominvper.length; i++) {
			wcominvper[i].recordStatus = -1;
			wcominvper[i].fromBanca = true;
		}		
	}

	function validateIntmNo(wcommInvoice) {
		var ok = ""; //true;
		
		new Ajax.Request(contextPath+"/GIPIWCommInvoiceController?action=validateGipis085IntmNo", {
			method: "GET",
			asynchronous: false, 
			evalScripts: true,
			parameters: {
				parId: b240.parId,
				intmNo: wcommInvoice.intermediaryNo,
				nbtIntmType: wcommInvoice.nbtIntmType, 
				assdNo: b240.assdNo,
				lineCd: b240.lineCd,
				parType: b240.parType,
				drvParSeqNo: b240.drvParSeqNo,
				vLovTag: $("chkLovTag").value
			},
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					var result = response.responseText.toQueryParams();

					$("chkLovTag").value = result.vLovTag;
					wcommInvoice.nbtIntmType = result.nbtIntmType;

					if ($("chkLovTag").value == "FILTERED") {
						$("chkLovTag").checked = true;
					} else {
						$("chkLovTag").checked = false;
					}
				
					if (result.msgAlert == "INTNO_NOT_IN_LOV") {
						
						showConfirmBox("", "Intermediary No. " + result.intmNo +" is not included in the list of default intermediaries for this assured/policy. Continue?",
								"Yes", "No",
								function() {
									$("chkLovTag").value = "UNFILTERED";
									$("chkLovTag").checked = false;
									 //belle 06.04.12 copied from onclick of btnSaveIntm	
									wcominvListTableGrid.createNewRow(wcommInvoice); 
									populateWcominvFields(null);
									populateWcominvperFields(null); 
									$("txtSharePercentage").value = formatToNthDecimal((100 - getTotalSharePercentage($F("txtTakeupSeqNo"))), 7); 			
								},
								function() {
									ok = false;
									populateWcominvFields(null);
									wcommInvoice = {}; //belle 06.07.12 to clear previous record
									wcominvper = [];
									$("txtSharePercentage").value = formatToNthDecimal((100 - getTotalSharePercentage($F("txtTakeupSeqNo"))), 7); //belle 06.05.12
									//checkAndDeleteWcominvIfExisting(wcommInvoice.intermediaryNo);
								});
					} else if (result.msgAlert == "ISS_CD_NOT_MATCH") {
						showConfirmBox("", "The issuing source of this intermediary is '" + result.issName + ". Do you want to continue?",
								"Yes", "No",
								function() {
									ok = true;
									wcominvListTableGrid.createNewRow(wcommInvoice); 
									populateWcominvFields(null);
									populateWcominvperFields(null); 
									$("txtSharePercentage").value = formatToNthDecimal((100 - getTotalSharePercentage($F("txtTakeupSeqNo"))), 7); 			
								},
								function() {
									ok = false;
									populateWcominvFields(null);
									//checkAndDeleteWcominvIfExisting(wcommInvoice.intermediaryNo);
								});
					}else{//belle 06.07.12
						
						ok = true; 
					}
				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
					ok = false;
				}
			}
		});

		return ok;
		
	}

	/** end of Page Functions **/
	
	/** Page Item Events **/
		
	$("oscmIntm").observe("click", function() {
		if (selectedWcominvRow == null && !nvl($F("txtTakeupSeqNo"),"").blank()) {
			//belle 06.01.12
			if ($("chkLovTag").checked == true){
				$("chkLovTag").value = "FILTERED";
				wcominvIntmNoLov = "cgfk$wcominvDspIntmName"; 	
			}else{
				$("chkLovTag").value = "UNFILTERED";
				wcominvIntmNoLov = "cgfk$wcominvDspIntmName5";
			} //end belle
			
			/* Modalbox.show(contextPath+"/GIISIntermediaryController?action=openSearchGipis085IntmListing&intmLOVName="+wcominvIntmNoLov, 
					  {title: "List of Intermediary", 
					  width: 921,
					  asynchronous: false}); */
					  
			var parId = $F("txtB240ParId") == null ? objGIPIWPolbas.parId: $F("txtB240ParId");
			var assdNo = $F("txtB240AssdNo") == null ? objGIPIWPolbas.assdNo: $F("txtB240AssdNo");
			var lineCd = $F("txtB240LineCd")== null ? objGIPIWPolbas.lineCd: $F("txtB240LineCd");
			var parType = objUWParList.parType;
			var defaultIntm = $("chkLovTag").checked;
			var polFlag = objUWParList.packParId == null ? $F("globalPolFlag"): objUWGlobal.polFlag;
			
			var notIn = "";
			var withPrevious = false;
			for(var i=0; i<objWcominvArray.length; i++) {
				if(withPrevious) notIn += ",";
				notIn += objWcominvArray[i].intermediaryNo;
				withPrevious = true;
			}
			notIn = notIn != "" ? "("+notIn+")" : 0;
			
			showGIPIS085IntermediaryLOV(parId, assdNo, lineCd, parType, defaultIntm, notIn, polFlag);
		}
	});
	
	$("chkLovTag").observe("change", function() {
		/* benjo 09.07.2016 SR-5604 */
		if(reqDfltIntmPerAssd == "Y" && override == "Y"){
			showConfirmBox("Confirmation", "Update of default intermediary is not allowed. Would you like to override?", "Yes", "No", 
					function(){
						showGenericOverride("GIPIS160", "OV",
								function(ovr, userId, result){
									if(result == "FALSE"){
										showMessageBox(userId + " is not allowed to Override.", imgMessage.ERROR);
										$("txtOverrideUserName").clear();
										$("txtOverridePassword").clear();
										return false;
									}else if(result == "TRUE"){
										override = "N";
										ovr.close();
										delete ovr;
										
										if($F("btnSaveIntm") == "Update"){
											$("chkLovTag").checked = !$("chkLovTag").checked;
											return;
										}
										
										if ($("chkLovTag").checked) {
											$("chkLovTag").value = "FILTERED";
											wcominvIntmNoLov = "cgfk$wcominvDspIntmName";
										} else {
											$("chkLovTag").value = "UNFILTERED";
											wcominvIntmNoLov = "cgfk$wcominvDspIntmName5";
										}
									}
								},
								function(){
									$("chkLovTag").checked = !$("chkLovTag").checked;
									return;
								},
								null);
					},
					function(){
						$("chkLovTag").checked = !$("chkLovTag").checked;
						return;
					},
					"");
		}else{
			if($F("btnSaveIntm") == "Update"){
				$("chkLovTag").checked = !$("chkLovTag").checked;
				return;
			}
			
			if ($("chkLovTag").checked) {
				$("chkLovTag").value = "FILTERED";
				wcominvIntmNoLov = "cgfk$wcominvDspIntmName";
			} else {
				$("chkLovTag").value = "UNFILTERED";
				wcominvIntmNoLov = "cgfk$wcominvDspIntmName5";
			}
		}
	});

	$("txtSharePercentage").observe("focus", function() {
		prevSharePercentage = parseFloat(nvl($F("txtSharePercentage").replace(/,/g,""), 0));
	});

	$("txtDspIntmName").observe("focus", function() {
		if ($F("isIntmOkForValidation") == "Y") {
			var intmNo = parseInt(nvl($F("txtIntmNo"), "0"));
			var exists = false;
			
			$("isIntmOkForValidation").value = "N";
			
			for (var i = 0; i < wcominvListTableGrid.rows.length; i++) {
				if (getWcominvObjValue(i, 'itemGroup') == parseInt(nvl($("txtTakeupSeqNo").options[$("txtTakeupSeqNo").selectedIndex].readAttribute("itemGrp"), "0"))
						&& getWcominvObjValue(i, 'takeupSeqNo') == parseInt(nvl($F("txtTakeupSeqNo"), "0"))
						&& getWcominvObjValue(i, 'intermediaryNo') == intmNo
						&& !isWcominvRowDeleted(wcominvListTableGrid.rows[i])) {
					exists = true;
					break;
				}
			}

			for (var i = 0; i < wcominvListTableGrid.newRowsAdded.length; i++) {
				if(wcominvListTableGrid.newRowsAdded[i] != null){
					if (getWcominvObjValue(-(i + 1), 'itemGroup') == parseInt(nvl($("txtTakeupSeqNo").options[$("txtTakeupSeqNo").selectedIndex].readAttribute("itemGrp"), "0"))
							&& getWcominvObjValue(-(i + 1), 'takeupSeqNo') == parseInt(nvl($F("txtTakeupSeqNo"), "0"))
							&& getWcominvObjValue(-(i + 1), 'intermediaryNo') == intmNo) {
						exists = true;
						break;
					}
				}
			}

			if (exists) {
				showMessageBox("Intermediary must be unique.", imgMessage.INFO);
				populateWcominvFields(null);
				return;
			}

			varSwitchNo = "Y";

			// create WCOMINV object first
			var wcommInvoice = new Object();
			wcommInvoice.intermediaryNo = $F("txtIntmNo");
			wcommInvoice.nbtIntmType = $F("txtNbtIntmType");
			
			//validateIntmNo(wcommInvoice); //belle 06.04.12 moved validation in Intm to include default intm in validation

			// save nbtIntmType value to text
			$("txtNbtIntmType").value = wcommInvoice.nbtIntmType;
		}
	});

	$("txtSharePercentage").observe("change", function() {
		/*var vSharePercentage = getWcominvVSharePercentage(getWcominvObjValue(selectedWcominvIndex, 'intermediaryNo'));
		if (parseFloat(nvl($F("txtSharePercentage"), "0")) > vSharePercentage) {
			$("txtSharePercentage").value = formatToNthDecimal(prevSharePercentage, 7);
			showMessageBox("Share Percentage should not exceed " + vSharePercentage + "% !", imgMessage.ERROR);
		} else{
			prevSharePercentage = $F("txtSharePercentage");
		}*/
	
		if ($F("txtSharePercentage") == ""){
			showMessageBox("Required fields must be entered.", imgMessage.ERROR);
			$("txtSharePercentage").value = formatToNthDecimal(prevSharePercentage, 7);
		}else if(isNaN($F("txtSharePercentage").replace(/,/g,""))) {
			showMessageBox("Invalid Share Percentage. Value must be from 0.000000001 to 100.000000000.", imgMessage.ERROR);
			$("txtSharePercentage").value = formatToNthDecimal(prevSharePercentage, 7);
		} else {
			var shareVal = 0;
			var totalPercentage = getTotalSharePercentage($F("txtTakeupSeqNo"));
			var sharePercentage = parseFloat(nvl($F("txtSharePercentage").replace(/,/g,""), "0"));

			if ($("btnSaveIntm").value == "Add") {
				shareVal = 100 - totalPercentage;
			} else if ($("btnSaveIntm").value == "Update") {
				shareVal = 100 - totalPercentage + parseFloat(nvl(getWcominvObjValue(selectedWcominvIndex, 'sharePercentage'), "0"));
			}
			if ($("btnSaveIntm").value == "Add" && totalPercentage == 100) { // changed to shareVal == 0 from totalPercentage == 100, 11.13.11
				showMessageBox("Share percentage is already 100%!", imgMessage.ERROR);			
				//$("txtSharePercentage").value = formatToNthDecimal(sharePercentage, 7); 
				$("txtSharePercentage").value = formatToNthDecimal(prevSharePercentage, 7);
				populateWcominvFields(null); //belle 06.06.12 to disallow adding of intm if total share percentage is already 100
				return;
			} else if(sharePercentage > 100){
				showMessageBox("Invalid Share Percentage. Value must be from 0.000000001 to 100.000000000.", imgMessage.ERROR);
				$("txtSharePercentage").value = formatToNthDecimal(prevSharePercentage, 7);
			}else if(sharePercentage > shareVal) {
				showMessageBox("Share Percentage should not exceed " + parseFloat(shareVal) + "%!", imgMessage.ERROR);			
				$("txtSharePercentage").value = formatToNthDecimal(shareVal, 7);
				return;
			} else if(sharePercentage <= 0) {
				showMessageBox("Invalid Share Percentage. Value must be from 0.000000001 to 100.000000000.", imgMessage.ERROR);
				$("txtSharePercentage").value = formatToNthDecimal(prevSharePercentage, 7);
				return;
			} else {
				var temp = formatToNthDecimal($F("txtSharePercentage").replace(/,/g,""), 7);
				$("txtSharePercentage").value = temp;
				prevSharePercentage = parseFloat(nvl($F("txtSharePercentage").replace(/,/g,""), 0));
				//checkRequiredWcominvFieldsBeforeSaving();
			}
		}
	});

	$("chkNbtRetOrig").observe("change", function() {
		if ($("chkNbtRetOrig").checked) {
			$("chkNbtRetOrig").value = "Y";
		} else {
			$("chkNbtRetOrig").value = "N";
		}
	});

	$("btnSaveIntm").observe("click", function() {
		if ( $F("txtDspIntmName").blank()|| $F("txtSharePercentage").blank()) {// Having problems with $F("txtIntmNo").blank()
			showMessageBox("Required fields must be entered.", imgMessage.ERROR);
			return;
	    //belle 06.06.12 to disallow adding of intm if total share percentage is already 100
		}else if ($("txtSharePercentage").value == 0){
			showMessageBox("Share percentage is already 100%!", imgMessage.ERROR);			
			populateWcominvFields(null);
			return;
		} else if (checkAllRequiredFieldsInDiv("perilInfoDiv")){// end belle
			var objWcominvRow = (selectedWcominvIndex == null) ? null : wcominvListTableGrid.rows[selectedWcominvIndex];
			var wcommInvoice = {};
			var wcommInvoicePerils = new Array(); // this will contain the current list of WCOMINVPER records for selected/new WCOMINV record
			var count = 0;
			var recordStatus = (selectedWcominvIndex == null) ? "INSERT" : "CHANGED";
			wcommInvoice.intermediaryName = changeSingleAndDoubleQuotes2($F("txtIntmName"));
			wcommInvoice.sharePercentage = $F("txtSharePercentage").blank() ? 0 : parseFloat($F("txtSharePercentage").replace(/,/g,""));
			wcommInvoice.premiumAmount = (objWcominvRow == null) ? 0 : parseFloat(nvl(objWcominvRow[wcominvListTableGrid.getColumnIndex('premiumAmount')], 0));
			wcommInvoice.commissionAmount = (objWcominvRow == null) ? 0 : parseFloat(nvl(objWcominvRow[wcominvListTableGrid.getColumnIndex('commissionAmount')], 0));
			wcommInvoice.netCommission = (objWcominvRow == null) ? 0 : parseFloat(nvl(objWcominvRow[wcominvListTableGrid.getColumnIndex('netCommission')], 0));
			wcommInvoice.withholdingTax = (objWcominvRow == null) ? 0 : parseFloat(nvl(objWcominvRow[wcominvListTableGrid.getColumnIndex('withholdingTax')], 0));
			wcommInvoice.intermediaryNo = parseInt(nvl($F("txtIntmNo"), "0"));
			wcommInvoice.parentIntermediaryNo = $F("txtParentIntmNo").blank() ? wcommInvoice.intermediaryNo : parseInt($F("txtParentIntmNo")); //parent Intm no is intmno when parent intm no is blank
			wcommInvoice.parentIntermediaryName = $F("txtParentIntmName").blank() ? null : changeSingleAndDoubleQuotes2($F("txtParentIntmName"));			
			wcommInvoice.parId = b240.parId;
			wcommInvoice.itemGroup = $("txtTakeupSeqNo").options[$("txtTakeupSeqNo").selectedIndex].readAttribute("itemGrp");
			wcommInvoice.takeupSeqNo = parseInt(nvl($F("txtTakeupSeqNo"), "0"));
			wcommInvoice.nbtIntmType = $F("txtNbtIntmType");
			wcommInvoice.intmNoNbt = parseInt(nvl($F("txtIntmNoNbt"), "0"));
			wcommInvoice.sharePercentageNbt = $F("txtSharePercentageNbt").blank() ? 0 : parseFloat($F("txtSharePercentageNbt").replace(/,/g,""));
			wcommInvoice.parentIntmLicTag = $F("txtParentIntmLicTag");
			wcommInvoice.parentIntmSpecialRate = $F("txtParentIntmSpecialRate");
			
			wcommInvoice.licTag = $F("txtLicTag");
			wcommInvoice.specialRate = $F("txtSpecialRate");
			
			if (wcominvper.length > 0 && selectedWcominvIndex != null) {
				for (var i = 0; i < wcominvper.length; i++) {
					if (wcominvper[i].takeupSeqNo == parseInt(nvl($F("txtTakeupSeqNo"), "0"))
							&& wcominvper[i].intermediaryIntmNo == parseInt(nvl(wcommInvoice.intermediaryNo, "0"))
							&& wcominvper[i].parId == parseInt(nvl(b240.parId, "0"))
							&& (wcominvper[i].recordStatus == null || wcominvper[i].recordStatus >= 0)) {
						wcommInvoicePerils[count] = wcominvper[i];
						count++;
					}
				}
			}

			// added by emman - to check if record is still recently added (do not change recordStatus to "CHANGED") 04.14.2011
			if ($("btnSaveIntm").value == "Update") { 
				if(selectedWcominvIndex < 0 ){
					recordStatus = "INSERT";
				}
				/*// this code doesn't work, changed  - irwin 11.2.11 
				if (objWcominvRow != null) {
					if (!nvl(objWcominvRow[wcominvListTableGrid.getColumnIndex('recordStatus')], true)) {
						recordStatus = "INSERT";
					}
				}*/
			}

			// set default tax rate (emman 09.09.2011)
			if (nvl(wcommInvoice.intermediaryNo, null) != null) {
				varTaxAmt = getDefaultTaxRate(wcommInvoice.intermediaryNo);
			}
			// it seems pag edit lang ng rate at comm, di na need mag validate ulit. Pag pinalitan lang ang share percentage, dun kelangan mag validate at query. -irwin
			if ($("btnSaveIntm").value == "Add") {
				if (executeBancassuranceGetDefaultTaxRt(wcommInvoice, wcommInvoicePerils, recordStatus)) {
					/* if ($("btnSaveIntm").value == "Update") {
						//tag record as update/modified
						/*if (getWcominvObjValue(selectedWcominvIndex, 'recordStatus') == 0) {
							wcommInvoice.recordStatus = 0;
						} else {
							wcommInvoice.recordStatus = 1;
						}
						if (selectedWcominvIndex != null) {
							updateWcominvRow(selectedWcominvIndex, wcommInvoice);
						}
						populateWcominvFields(wcominvListTableGrid.rows[selectedWcominvIndex]);
					} else if ($("btnSaveIntm").value == "Add") { 
						wcominvListTableGrid.createNewRow(wcommInvoice); 
						populateWcominvFields(null);
						populateWcominvperFields(null); 
						$("txtSharePercentage").value = formatToNthDecimal((100 - getTotalSharePercentage($F("txtTakeupSeqNo"))), 7); 
				    } *///belle 06.07.12 replaced by these codes to include default intm in validation and hindi naman na need yung sa update button dito
				    intmNoOk = validateIntmNo(wcommInvoice); 
					if (intmNoOk){
						wcominvListTableGrid.createNewRow(wcommInvoice); 
						objWcominvArray.push(wcommInvoice); //christian 07.11.2012 
						populateWcominvFields(null);
						populateWcominvperFields(null); 
						$("txtSharePercentage").value = formatToNthDecimal((100 - getTotalSharePercentage($F("txtTakeupSeqNo"))), 7);
					}
				}
			}else {   
				if(selectedOrigSharePercentage != parseFloat(nvl($F("txtSharePercentage").replace(/,/g,""), "0"),7) || $("chkNbtRetOrig").checked){ //condition to check if the share percentage has been changed || added $("chkNbtRetOrig").checked - apollo cruz 
					if (executeBancassuranceGetDefaultTaxRt(wcommInvoice, wcommInvoicePerils, recordStatus)) {
						if ($("btnSaveIntm").value == "Update") {
							if (selectedWcominvIndex != null) {
								updateWcominvRow(selectedWcominvIndex, wcommInvoice);
							}
							populateWcominvFields(wcominvListTableGrid.rows[selectedWcominvIndex]);
						} /* else if ($("btnSaveIntm").value == "Add") {
							
							wcominvListTableGrid.createNewRow(wcommInvoice);

							populateWcominvFields(null);
							populateWcominvperFields(null);
							$("txtSharePercentage").value = formatToNthDecimal((100 - getTotalSharePercentage($F("txtTakeupSeqNo"))), 7);
						} */ //belle 06.13.12 ndi na need dito
					}
				}else{ // Updates the Rate and Commission only. - irwin wcominvListTableGrid.rows
					//updates the wcominvList
					wcominvListTableGrid.setValueAt(nvl($F("txtPerilCommissionAmt"),0), wcominvListTableGrid.getColumnIndex('commissionAmount'), selectedWcominvIndex,true);
					wcominvListTableGrid.setValueAt(nvl($F("txtPerilNbtCommissionAmt"),0), wcominvListTableGrid.getColumnIndex('netCommission'), selectedWcominvIndex,true);
					wcominvListTableGrid.setValueAt(nvl($F("txtPerilWholdingTax"),0), wcominvListTableGrid.getColumnIndex('withholdingTax'), selectedWcominvIndex,true); //belle 06.14.12 
					
					//updates the wcominvper
					var itemGrp 		= wcominvListTableGrid.getValueAt(wcominvListTableGrid.getColumnIndex('itemGroup'), selectedWcominvIndex); 
					var takeupSeqNo 	= wcominvListTableGrid.getValueAt(wcominvListTableGrid.getColumnIndex('takeupSeqNo'), selectedWcominvIndex); 
					var intmNo			= wcominvListTableGrid.getValueAt(wcominvListTableGrid.getColumnIndex('intermediaryNo'), selectedWcominvIndex); 
					
					for (var i = 0; i < wcominvper.length; i++) {
						if (wcominvper[i].intermediaryIntmNo == parseInt(intmNo) &&
								wcominvper[i].itemGroup == parseInt(itemGrp) &&
								wcominvper[i].takeupSeqNo == parseInt(takeupSeqNo)) {
								
							wcominvper[i].commissionRate = parseFloat($F("txtPerilCommissionRate"));
							wcominvper[i].netCommission = parseFloat($F("txtPerilNbtCommissionAmt").replace(/,/g,"")); //belle 06.15.12 
							wcominvper[i].commissionAmount = parseFloat($F("txtPerilCommissionAmt").replace(/,/g,""));
							wcominvper[i].withholdingTax = parseFloat($F("txtPerilWholdingTax").replace(/,/g,"")); //belle 06.14.12
							wcominvper[i].recordStatus = 1;
						}
					}
					
					//wcominvListTableGrid.setValueAt(nvl($F("txtPerilCommissionRate"),0), wcominvListTableGrid.getColumnIndex('commissionRate'), selectedWcominvIndex);
					//wcominvListTableGrid.setValueAt(wcommInvoice.sharePercentageNbt, wcominvListTableGrid.getColumnIndex('sharePercentageNbt'), index);
				} 
				
				//$(selectedWcominvRow).removeClassName("selectedRow");
				//selectedWcominvRow = null;
				//removeWcominvRowFocus();	
				wcominvListTableGrid.keys.removeFocus(wcominvListTableGrid.keys._nCurrentFocus, true);
				wcominvListTableGrid.keys.releaseKeys();
				//removeWcominvRowFocus(); //epal
				wcominvListTableGrid.onRemoveRowFocus();
				
				/*$("txtPerilCommissionRate").setAttribute("readonly","readonly");
				$("txtPerilCommissionAmt").setAttribute("readonly","readonly");
				
				// added for share percentage total value -irwin
				$("txtSharePercentage").value = formatToNthDecimal(100 - getTotalSharePercentage($F("txtTakeupSeqNo")),7);
				$("selectedNbtCommissionRtComputed").value = "";*/
			}
			
		}
		changeTag = 1;
		$("chkLovTag").checked = false;
		$("chkNbtRetOrig").checked = false;
	});

	$("btnDeleteIntm").observe("click", function() {
		try{
			if (selectedWcominvIndex != null) {
				//wcominvListTableGrid.deleteRow(selectedWcominvIndex);
				wcominvListTableGrid.deleteAnyRows('divCtrId', selectedWcominvIndex);
				
				//added for delete wcominvper -irwin
				//updates the wcominvper
				if(selectedWcominvIndex > -1){
					var itemGrp 		= wcominvListTableGrid.getValueAt(wcominvListTableGrid.getColumnIndex('itemGroup'), selectedWcominvIndex); 
					var takeupSeqNo 	= wcominvListTableGrid.getValueAt(wcominvListTableGrid.getColumnIndex('takeupSeqNo'), selectedWcominvIndex); 
					var intmNo			= wcominvListTableGrid.getValueAt(wcominvListTableGrid.getColumnIndex('intermediaryNo'), selectedWcominvIndex); 
					for (var i = 0; i < wcominvper.length; i++) {
						if (wcominvper[i].intermediaryIntmNo == parseInt(intmNo) &&
								wcominvper[i].itemGroup == parseInt(itemGrp) &&
								wcominvper[i].takeupSeqNo == parseInt(takeupSeqNo)) {
							wcominvper[i].recordStatus = -1;
						}
					}
				}
				
				removeWcominvRowFocus();
				changeTag = 1;
				$("txtSharePercentage").value = formatToNthDecimal((100 - getTotalSharePercentage($F("txtTakeupSeqNo"))), 7);
			}
		}catch(e){ 
			showErrorMessage("btnDeleteIntm",e);
		}
		
	});

	$("btnSave").observe("click", function() {
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES ,imgMessage.INFO);
			return;
		} else {
			saveWcommInvoice();
		}
	});

	/* $("reloadForm").observe("click", function(){
		if(changeTag == 1) {
			showConfirmBox("Confirmation", objCommonMessage.RELOAD_WCHANGES, "Yes", "No", 
					function(){saveWcommInvoice(); if (changeTag == 0){showInvoiceCommissionPage();}}, showInvoiceCommissionPage);
		} else {
			showInvoiceCommissionPage();
		}
	}); */
	observeReloadForm("reloadForm", showInvoiceCommissionPage); // Irwin. 11.13.11
	// BANCA
	
	//apollo cruz 10.27.2014
	function applyBancassurance(){
		var index = 0;
		var wcommInvoice = new Object();
		
		function start(){
				
			if (index < bancaB.length){
				wcommInvoice = {};				
				wcommInvoice.parId = b240.parId;
				wcommInvoice.intermediaryNo = bancaB[index].intmNo;
				wcommInvoice.intermediaryName = bancaB[index].intmName;
				wcommInvoice.parentIntermediaryNo = bancaB[index].parentIntmNo;
				wcommInvoice.parentIntermediaryName = bancaB[index].parentIntmName;
				wcommInvoice.sharePercentage = (bancaB[index].sharePercentage == null) ? null : parseFloat(bancaB[index].sharePercentage);
				wcommInvoice.premiumAmount = 0;
				wcommInvoice.commissionAmount = 0;
				wcommInvoice.netCommission = 0;
				wcommInvoice.withholdingTax = 0;
				wcommInvoice.nbtIntmType = null;
				wcommInvoice.intmNoNbt = parseInt(nvl(bancaB[index].intmNo, "0"));
				wcommInvoice.sharePercentageNbt = (bancaB[index].sharePercentage == null) ? null : parseFloat(bancaB[index].sharePercentage);
				wcommInvoice.itemGroup =parseInt(nvl(b450[0].itemGrp), 0);
				wcommInvoice.takeupSeqNo = parseInt(nvl($F("txtTakeupSeqNo"), "0"));
				wcommInvoice.recordStatus = 0;
				validate(wcommInvoice);		
			} else {
				done();
			}
		}
		
		function add(){
			if (executeBancassuranceGetDefaultTaxRt(wcommInvoice, null, "INSERT")) {
				wcominvListTableGrid.createNewRow(wcommInvoice);
				index++;
				start();
			}
		}
		
		function done(){
			displayWcominvRecords($F("txtTakeupSeqNo"));
			populateWcominvFields(null);
			populateWcominvperFields(null);
			hideBancaDetails();
		}
		
		function validate(wcommInvoice) {
			new Ajax.Request(contextPath+"/GIPIWCommInvoiceController?action=validateGipis085IntmNo", {
				method: "GET",
				asynchronous: false, 
				evalScripts: true,
				parameters: {
					parId: b240.parId,
					intmNo: wcommInvoice.intermediaryNo,
					nbtIntmType: wcommInvoice.nbtIntmType, 
					assdNo: b240.assdNo,
					lineCd: b240.lineCd,
					parType: b240.parType,
					drvParSeqNo: b240.drvParSeqNo,
					vLovTag: ""
				},
				onComplete: function(response) {
					if (checkErrorOnResponse(response)) {
						var result = response.responseText.toQueryParams();						
						if (result.msgAlert == "ISS_CD_NOT_MATCH") {						
							showConfirmBox("", "The issuing source of this intermediary is '" + result.issName + ". Do you want to continue?",
								"Yes", "No", add, function(){
													index++;
													start();
												}
							);
						} else
							add();
					} else {
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		}
		
		start();
	}
	
	$("btnBancaApply").observe("click", function() {		
		var isIntmComplete = true;
		
		for (var i = 0; i < bancaB.length; i++) {
			if(bancaB[i].intmNo == null || bancaB[i].intmNo == ""){
				isIntmComplete = false;
				break;
			}				
		}
		
		if(!isIntmComplete){
			showMessageBox("Item Group without Intermediary still exists.", imgMessage.INFO);
			return;
		}
		
		deleteAllWcominvRecords();
		deleteAllWcominvperRecords2();
		varBancRateSw = "Y";
		
		if(wcominvListTableGrid.newRowsAdded.length > 0){
			wcominvListTableGrid.newRowsAdded = [];
			wcominvListTableGrid.pager.total = 0;
			wcominvListTableGrid.recreateRows();
		}		
		
		applyBancassurance();
		
	});
	
	/* $("btnBancaApply").observe("click", function() {
		deleteAllWcominvRecords();
		deleteAllWcominvperRecords2();
		varBancRateSw = "Y";
		var intmNoOk = true;
		
		 for (var i = 0; i < bancaB.length; i++) {
			var wcommInvoice = new Object();
			var count = 0;
			var recordStatus = "INSERT";
			wcommInvoice.parId = b240.parId;
			wcommInvoice.intermediaryNo = bancaB[i].intmNo;
			wcommInvoice.intermediaryName = bancaB[i].intmName;
			wcommInvoice.parentIntermediaryNo = bancaB[i].parentIntmNo;
			wcommInvoice.parentIntermediaryName = bancaB[i].parentIntmName;
			wcommInvoice.sharePercentage = (bancaB[i].sharePercentage == null) ? null : parseFloat(bancaB[i].sharePercentage);
			wcommInvoice.premiumAmount = 0;
			wcommInvoice.commissionAmount = 0;
			wcommInvoice.netCommission = 0;
			wcommInvoice.withholdingTax = 0;
			wcommInvoice.nbtIntmType = null;
			wcommInvoice.intmNoNbt = parseInt(nvl(bancaB[i].intmNo, "0"));
			wcommInvoice.sharePercentageNbt = (bancaB[i].sharePercentage == null) ? null : parseFloat(bancaB[i].sharePercentage);
			//wcommInvoice.itemGroup = parseInt(nvl($F("txtItemGrp"), "0")); //belle 06.07.12 not existing replaced by b450.itemGroup
			wcommInvoice.itemGroup =parseInt(nvl(b450[0].itemGrp), 0);
			wcommInvoice.takeupSeqNo = parseInt(nvl($F("txtTakeupSeqNo"), "0"));
			
			intmNoOk = validateIntmNo(wcommInvoice);
			
			 if (intmNoOk) {
				
				if (executeBancassuranceGetDefaultTaxRt(wcommInvoice, null, recordStatus)) {
					var index = 0; //tag record as added
					wcommInvoice.recordStatus = 0;
					wcominvListTableGrid.createNewRow(wcommInvoice); //belle 06.07.12
				}
			} 
		} 

		displayWcominvRecords($F("txtTakeupSeqNo"));
		populateWcominvFields(null);
		populateWcominvperFields(null);
		hideBancaDetails(); //belle 06.06.12
	}); */

	// this is for the banca_details intermediary
	$("oscmIntermediary").observe("click", function ()	{
		if (currentBancaBRowNo >= 0) {
			if (!$("chkBancaFixedTag").checked) {
				openSearchBancaIntermediary();
			} else {
				showMessageBox("This item may not be updated.", imgMessage.INFO);
			}
		}
	});

	$("txtBancaDrvIntmName").observe("focus", function() {
		if ($F("isBancaIntmOkForValidation") == "Y") {
			var content = "";
			$("isBancaIntmOkForValidation").value = "N";

			bancaB[currentBancaBRowNo].intmNo = parseInt(nvl($F("txtBancaIntmNo"), "0"));
			bancaB[currentBancaBRowNo].intmName = changeSingleAndDoubleQuotes2($F("txtBancaIntmName"));
			
			content = generateBancTypeDtlContent(bancaB[currentBancaBRowNo], currentBancaBRowNo);
			
			selectedBancaBRow.update(content);
		}
	});
	
	/** end of Page Item Events **/
	
	/* $("txtPerilCommissionRate").observe("blur",function(){
	
		//var varRate = parseFloat($F("txtPerilCommissionRate").replace(/,/g,""));
		//var premiumAmount =  parseFloat(nvl($F("txtPerilPremiumAmt").replace(/,/g,""), "0"));
		//var wHoldingTax = parseFloat(nvl($F("txtPerilWholdingTax").replace(/,/g,""), "0"));
		//var commAmount = (varRate/100)  * premiumAmount;

		if($F("txtPerilCommissionRate") == ""){
			$("txtPerilCommissionRate").value =  formatToNthDecimal("0",2);
			$("txtPerilCommissionAmt").value  = formatToNthDecimal("0",2);//roundNumber(parseFloat(commissionAmount),2);
			$("txtPerilNbtCommissionAmt").value = formatToNthDecimal("0",2);
			showMessageBox("Required fields must be entered.", imgMessage.ERROR);
			
			//return false;
		}else{
			var varRate = parseFloat($F("txtPerilCommissionRate").replace(/,/g,""));
			var premiumAmount =  parseFloat(nvl($F("txtPerilPremiumAmt").replace(/,/g,""), "0"));
			var wHoldingTax = parseFloat(nvl($F("txtPerilWholdingTax").replace(/,/g,""), "0"));
			//var commAmount = (varRate/100)  * premiumAmount;
			var commAmount = parseFloat(nvl( (varRate/100)  * premiumAmount, "0"));
			if(isNaN(varRate)){
				customShowMessageBox("Invalid value for rate.",imgMessage.ERROR,"txtPerilCommissionRate");
				return false;		
			}else if(varRate >= 100){
				customShowMessageBox("Commission Amount must be lower than Premium Amount.",imgMessage.ERROR,"txtPerilCommissionRate");
				return false;
			}else{
				if (varRate < parseFloat(nvl($F("selectedNbtCommissionRtComputed"), "0"))) { //Temp removed. move on to other major bugs
					showMessageBox("Commission Rate is lower than the Computed Commission Rate of " + $F("selectedNbtCommissionRtComputed") + "%", imgMessage.INFO);
				}
				$("txtPerilCommissionRate").value = formatToNthDecimal(parseFloat(varRate),2);
				$("txtPerilCommissionAmt").value  = formatCurrency(commAmount);
				$("txtPerilNbtCommissionAmt").value = formatCurrency(commAmount - wHoldingTax);
				//$("txtPerilCommissionAmt").value  =formatCurrency( formatToNthDecimal(commAmount,2));//roundNumber(parseFloat(commissionAmount),2);
				//$("txtPerilNbtCommissionAmt").value = formatCurrency( formatToNthDecimal(commAmount - wHoldingTax),2);	
			}
		}		parseFloat(nvl($F("txtPerilCommissionAmt").replace(/,/g,""), "0"));
		
		
		/* if (varRate < parseFloat(nvl(wcommInvoicePeril.nbtCommissionRtComputed, "0"))) { Temp removed. move on to other major bugs
			showMessageBox("Commission Rate is lower than the Computed Commission Rate of " + wcommInvoicePeril.nbtCommissionRtComputed + "%", imgMessage.INFO);
			return false;
		}else{
			$("txtPerilCommissionAmt").value  = formatToNthDecimal(commAmount,2);//roundNumber(parseFloat(commissionAmount),2);
			$("txtPerilNbtCommissionAmt").value = commAmount - wHoldingTax;			
		} 
	}); */ //belle 06.13.12 replaced by codes below
	
	/*$("txtPerilCommissionRate").observe("blur",function(){
		 if (parseFloat($F("txtPerilCommissionAmt").replace(/,/g,"")) >= parseFloat($F("txtPerilPremiumAmt").replace(/,/g,""))){
			customShowMessageBox("Commission Amount must be lower than Premium Amount.",imgMessage.ERROR, "txtPerilCommissionRate");
			return false;
		 }else if (parseFloat($F("txtPerilCommissionRate").replace(/,/g,"")) < parseFloat(nvl($F("selectedNbtCommissionRtComputed").replace(/,/g,""), "0"))) { 
			customShowMessageBox("Commission Rate is lower than the Computed Commission Rate of " + $F("selectedNbtCommissionRtComputed") + "%", imgMessage.ERROR,"txtPerilCommissionRate");
			return false; 
		 } 
	});*///commented out by christian 02/05/2013

	$("txtPerilCommissionRate").observe("focus",function(){
		$("txtPerilCommissionRate").setAttribute("lastValidValue", this.value);
		$("txtPerilCommissionAmt").setAttribute("lastValidValue", $("txtPerilCommissionAmt").value);
	});
	
	$("txtPerilCommissionRate").observe("change",function(){
		var varRate = parseFloat($F("txtPerilCommissionRate").replace(/,/g,""));
		var premiumAmount =  parseFloat(nvl($F("txtPerilPremiumAmt").replace(/,/g,""), "0"));
		var commAmount = parseFloat(nvl( (varRate/100)  * premiumAmount, "0"));
		var wHoldingTax = nvl(getDefaultTaxRate(wcominvListTableGrid.getValueAt(wcominvListTableGrid.getColumnIndex("intermediaryNo"), selectedWcominvIndex)), 0);
		var wHoldingTaxAmt = (wHoldingTax/100) * commAmount;		
		
		if(isNaN($F("txtPerilCommissionRate").replace(/,/g,""))) {
			customShowMessageBox("Field must be of form 990.9999999.", imgMessage.ERROR, "txtPerilCommissionRate");
			$("txtPerilCommissionRate").value = formatToNthDecimal($("txtPerilCommissionRate").getAttribute("lastValidValue"), 7);
			return false;
		}else if(($F("txtPerilCommissionRate").replace(/,/g,"") < 0.00 || $F("txtPerilCommissionRate").replace(/,/g,"") > 100.0000000)){
			customShowMessageBox("Field must be of form 990.9999999.", imgMessage.ERROR, "txtPerilCommissionRate");
			$("txtPerilCommissionRate").value = formatToNthDecimal($("txtPerilCommissionRate").getAttribute("lastValidValue"), 7);
			return false;
		}
		
		$("txtPerilCommissionRate").value = formatToNthDecimal(varRate, 7);
		$("txtPerilCommissionAmt").value = formatCurrency(commAmount);
		
		if(parseFloat($F("txtPerilCommissionAmt").replace(/,/g,"")) != 0 && parseFloat($F("txtPerilPremiumAmt").replace(/,/g,"")) != 0){
			if (Math.abs(parseFloat($F("txtPerilCommissionAmt").replace(/,/g,""))) > Math.abs(parseFloat($F("txtPerilPremiumAmt").replace(/,/g,"")))){
				customShowMessageBox("Commission Amount must not be greater than Premium Amount.",imgMessage.ERROR, "txtPerilCommissionAmt");
				$("txtPerilCommissionAmt").value = formatCurrency($("txtPerilCommissionAmt").getAttribute("lastValidValue"));
				$("txtPerilCommissionRate").value = formatToNthDecimal($("txtPerilCommissionRate").getAttribute("lastValidValue"), 7);
				return false;
			} /*else if (parseFloat($F("txtPerilCommissionRate").replace(/,/g,"")) < parseFloat(nvl($F("selectedNbtCommissionRtComputed").replace(/,/g,""), "0"))) { 
				customShowMessageBox("Commission Rate is lower than the Computed Commission Rate of " + $F("selectedNbtCommissionRtComputed") + "%", imgMessage.INFO, "txtPerilCommissionAmt");
				$("txtPerilCommissionAmt").value = formatCurrency($("txtPerilCommissionAmt").getAttribute("lastValidValue"));
				$("txtPerilCommissionRate").value = formatToNthDecimal($("txtPerilCommissionRate").getAttribute("lastValidValue"), 7);
				return false;
			} */
			
			if(!valCommRate())
				return;
		}
		
		$("txtPerilWholdingTax").value = formatCurrency(wHoldingTaxAmt);
		$("txtPerilNbtCommissionAmt").value = formatCurrency(commAmount - wHoldingTaxAmt);
		$("txtPerilCommissionRate").setAttribute("lastValidValue", this.value);
		$("txtPerilCommissionAmt").setAttribute("lastValidValue", $("txtPerilCommissionAmt").value);
	});
		
	/*$("txtPerilCommissionRate").observe("focus",function(){
		checkPercentage();
	});*/ // commented by: Nica 06.25.2012
	
	/*$("txtPerilCommissionAmt").observe("blur",function(){
		var varRate = parseFloat(nvl($F("txtPerilCommissionRate").replace(/,/g,""), "0"));
		var premiumAmount =  parseFloat(nvl($F("txtPerilPremiumAmt").replace(/,/g,""), "0"));
		var commAmount = parseFloat(nvl($F("txtPerilCommissionAmt").replace(/,/g,""), "0"));
		var wHoldingTax = parseFloat(nvl($F("txtPerilWholdingTax").replace(/,/g,""), "0"));
		var finalRate = formatToNthDecimal((commAmount/premiumAmount) * 100 , 2);
		
		if(commAmount != 0){
			if( Math.abs(premiumAmount)<= Math.abs(commAmount)){
				customShowMessageBox("Commission Amount must be lower than Premium Amount.",imgMessage.INFO,"txtPerilCommissionAmt");
				return false;
			}else{
				$("txtPerilCommissionRate").value = finalRate;
				$("txtPerilCommissionAmt").value = formatCurrency(formatToNthDecimal(commAmount,2));
				$("txtPerilNbtCommissionAmt").value = formatCurrency(formatToNthDecimal(commAmount - wHoldingTax,2));	
				
				if ($("txtPerilCommissionRate").value  < parseFloat(nvl($F("selectedNbtCommissionRtComputed"), "0"))) { //belle 06.11.12
					customShowMessageBox("Commission Rate is lower than the Computed Commission Rate of " +$F("selectedNbtCommissionRtComputed")+ "%.", imgMessage.INFO,"txtPerilCommissionAmt");
					return false;
				}
			}
		}
	}); */ //belle 06.14.12 replaced by codes below
	
	/*$("txtPerilCommissionAmt").observe("blur",function(){
		if (parseFloat($F("txtPerilCommissionAmt").replace(/,/g,"")) >= parseFloat($F("txtPerilPremiumAmt").replace(/,/g,""))){
			customShowMessageBox("Commission Amount must be lower than Premium Amount.",imgMessage.ERROR,"txtPerilCommissionAmt");
			return false;
		}else if (parseFloat($F("txtPerilCommissionRate").replace(/,/g,"")) < parseFloat(nvl($F("selectedNbtCommissionRtComputed").replace(/,/g,""), "0"))) { 
			customShowMessageBox("Commission Rate is lower than the Computed Commission Rate of " + $F("selectedNbtCommissionRtComputed") + "%", imgMessage.ERROR,"txtPerilCommissionAmt");
			return false;
		}
	});*///commented out by christian 02/05/2013 
	$("txtPerilCommissionAmt").observe("focus",function(){
		$("txtPerilCommissionAmt").setAttribute("lastValidValue", this.value);
		$("txtPerilCommissionRate").setAttribute("lastValidValue", $("txtPerilCommissionRate").value);
	});

	$("txtPerilCommissionAmt").observe("change",function(){
		var premiumAmount =  parseFloat($F("txtPerilPremiumAmt").replace(/,/g,""));
		var commAmount = parseFloat(nvl($F("txtPerilCommissionAmt").replace(/,/g,""), "0"));
		var wHoldingTax = nvl(getDefaultTaxRate(wcominvListTableGrid.getValueAt(wcominvListTableGrid.getColumnIndex("intermediaryNo"), selectedWcominvIndex)), 0);
		var wHoldingTaxAmt = (wHoldingTax/100) * commAmount;	
		var varRate = formatToNthDecimal((commAmount/premiumAmount) * 100 , 7);
		
		if(isNaN($F("txtPerilCommissionAmt").replace(/,/g,""))){
			customShowMessageBox("Field must be of form 999,999,990.00.", imgMessage.ERROR, "txtPerilCommissionAmt");
			$("txtPerilCommissionAmt").value = formatCurrency($("txtPerilCommissionAmt").getAttribute("lastValidValue"));
			return false;
		}else if(Math.abs($F("txtPerilCommissionAmt").replace(/,/g,"") > 9999999999.99)){
			customShowMessageBox("Field must be of form 999,999,990.00.", imgMessage.ERROR, "txtPerilCommissionAmt");
			$("txtPerilCommissionAmt").value = formatCurrency($("txtPerilCommissionAmt").getAttribute("lastValidValue"));
			return false;
		}
		
		$("txtPerilCommissionRate").value = formatToNthDecimal(varRate, 7);
		$("txtPerilCommissionAmt").value = formatCurrency(commAmount);
		
		if (parseFloat($F("txtPerilCommissionAmt").replace(/,/g,"")) != 0 && parseFloat($F("txtPerilPremiumAmt").replace(/,/g,"")) != 0){
			if (Math.abs(parseFloat($F("txtPerilCommissionAmt").replace(/,/g,""))) > Math.abs(parseFloat($F("txtPerilPremiumAmt").replace(/,/g,"")))){
				customShowMessageBox("Commission Amount must not be greater than Premium Amount.",imgMessage.ERROR, "txtPerilCommissionAmt");
				$("txtPerilCommissionAmt").value = formatCurrency($("txtPerilCommissionAmt").getAttribute("lastValidValue"));
				$("txtPerilCommissionRate").value = formatToNthDecimal($("txtPerilCommissionRate").getAttribute("lastValidValue"), 7);
				return false;
			}/* else if (parseFloat($F("txtPerilCommissionRate").replace(/,/g,"")) < parseFloat(nvl($F("selectedNbtCommissionRtComputed").replace(/,/g,""), "0"))) { 
				customShowMessageBox("Commission Rate is lower than the Computed Commission Rate of " + $F("selectedNbtCommissionRtComputed") + "%", imgMessage.ERROR, "txtPerilCommissionAmt");
				//$("txtPerilCommissionAmt").value = formatCurrency($("txtPerilCommissionAmt").getAttribute("lastValidValue"));
				//$("txtPerilCommissionRate").value = formatToNthDecimal($("txtPerilCommissionRate").getAttribute("lastValidValue"), 7);
				//return false;
			} */
			
			if(!valCommRate())
				return;
		}
		
		$("txtPerilWholdingTax").value = formatCurrency(wHoldingTaxAmt);
		$("txtPerilNbtCommissionAmt").value = formatCurrency(commAmount - wHoldingTaxAmt);
		$("txtPerilCommissionAmt").setAttribute("lastValidValue", this.value);
		$("txtPerilCommissionRate").setAttribute("lastValidValue", $("txtPerilCommissionRate").value);
	});
	
	/*$("txtPerilCommissionAmt").observe("focus",function(){
		checkPercentage();
	});*/ // commented by: Nica 06.25.2012
	
	function checkPercentage(){
		var varPercentage = parseFloat(nvl($F("txtSharePercentage").replace(/,/g,""), "0"),7);
		if(varPercentage != selectedOrigSharePercentage){
			showMessageBox("Please update the record first.", imgMessage.info);
			return false;
		}
	}
	
	// set default share percentage
	function setDefaultSharePercentage(){
		if(wcominvper.length == 0){
			$("txtSharePercentage").value = formatToNthDecimal(100,7);
		}
		//$("txtSharePercentage").value = formatToNthDecimal(getTotalSharePercentage($F("txtTakeupSeqNo")));
	}
	
	if(wcominvListTableGrid.geniisysRows.length == 0
		&& !(vOra2010Sw == "Y" && objGIPIWPolbas.bancassuranceSw =="Y")
		/*&& $F("globalParType") != "E" && objGIPIWPolbas.polFlag != 2*/) //benjo 09.07.2016 SR-5604
		populateDefaultIntm();
	
	function populateDefaultIntm() {
		var valid = false;
		
		//$("txtDspIntmName").value = unescapeHTML2('${dfltIntmNo}' + " - "+ '${dfltIntmName}'); //added by christian 03/16/2013 -- commented out by robert 09.13.2013
		
		if (('${dfltParentIntmNo}' == null || '${dfltParentIntmNo}' == "")
				&& ('${dfltIntmNo}' != null && '${dfltIntmNo}' != "")) {
			//replaced txtDspIntmName with txtDspParentIntmName christian 03/16/2013
			$("txtDspIntmName").value = unescapeHTML2('${dfltIntmNo}' + " - "+ '${dfltIntmName}'); //added by robert 09.13.2013
			$("txtDspParentIntmName").value = unescapeHTML2('${dfltIntmNo}' + " - "+ '${dfltIntmName}'); //robert 02.11.2013 added unescapeHTML2
			valid = true;
		} else if ('${dfltParentIntmNo}' != null && '${dfltParentIntmNo}' != "") {
			$("txtDspIntmName").value = unescapeHTML2('${dfltIntmNo}' + " - "+ '${dfltIntmName}'); //added by robert 09.13.2013
			$("txtDspParentIntmName").value = unescapeHTML2('${dfltParentIntmNo}'+ " - " + '${dfltParentIntmName}');//robert 02.11.2013 added unescapeHTML2
			valid = true;
		}

		if ('${dfltParentIntmNo}' == '${dfltIntmNo}') {
			$("txtDspParentIntmName").value = "";
		}

		if (valid) {
			$("chkLovTag").checked = true;
			$("chkLovTag").value = "FILTERED"; //belle 06.04.12
			$("txtIntmNo").value = '${dfltIntmNo}';
			$("txtIntmName").value = '${dfltIntmName}';
			$("txtParentIntmNo").value = '${dfltParentIntmNo}';
			$("txtParentIntmName").value = '${dfltParentIntmName}';
		}
	}
	
	var dfltIntms;
	
	if($F("globalParType") == "E" || objGIPIWPolbas.polFlag == 2){//for renewal or endorsement - apollo cruz
		$("chkLovTag").value = "FILTERED";
		$("chkLovTag").checked = true;	
		dfltIntms = eval('${dfltIntms}');
	}
	
	observeCancelForm("btnCancel",saveWcommInvoice, goBackToParListing);

	if(objGIPIWPolbas.polFlag == 4){// added by Irwin 11.3.11
		showMessageBox("This is a cancellation type of endorsement, update/s of any details will not be allowed.", imgMessage.INFO);
		$("txtSharePercentage").readOnly = true;
		$("txtPerilCommissionRate").readOnly = true;
		$("txtPerilCommissionAmt").readOnly = true;
	}
	
	if(varUserCommUpdateTag == "N"){
		$("txtPerilCommissionRate").readOnly = true;
		$("txtPerilCommissionAmt").readOnly = true;
	}	
	
	$("txtSharePercentage").observe("focus", function() {
		prevSharePercentage = parseFloat(nvl($F("txtSharePercentage").replace(/,/g,""), 0));
		if (!$F("txtIntmNo").blank()) {
			varSharePercentage = $F("txtSharePercentage");
			$("txtSharePercentageNbt").value = $F("txtSharePercentage");
		}
	});
	
	function valCommRate (obj) {
		var bool = true;
		new Ajax.Request(contextPath+"/GIISIntermediaryController", {
			method: "GET",
			asynchronous: false,
			evalScripts: true,
			parameters: {
				action : "valCommRate",
				intmNo: $F("txtIntmNo"),
				lineCd : $F("globalLineCd"),
				sublineCd : $F("globalSublineCd"),
				issCd : $F("globalIssCd"),
				perilCd : varPerilCd,
				commRate : unformatCurrencyValue($F("txtPerilCommissionRate"))
			},
			onCreate : function(){
				showNotice("Validating Rate, please wait...");
			},
			onComplete: function(response) {
				hideNotice();
				if(response.responseText != "SUCCESS"){					
					if(response.responseText.include("Error")){
						bool = false;
						var message = response.responseText.split("#");
						showWaitingMessageBox(message[1], "E", function(){
							$("txtPerilCommissionRate").value = formatToNthDecimal($("txtPerilCommissionRate").getAttribute("lastValidValue"), 7);
							$("txtPerilCommissionAmt").value = formatCurrency(nvl($("txtPerilCommissionAmt").getAttribute("lastValidValue"), "0"));
						});
					} else {
						showMessageBox(response.responseText, "I");
					}
				}
			}
		});
		
		return bool;
	}
	
	//added by gab 11.05.2015
	if (vValidateBanca != "Y" && wComInvIntmNo.length == 0 && objGIPIWPolbas.polFlag != 2){
		$("txtIntmNo").value = '${dfltIntmNo}';
		$("txtIntmName").value = '${dfltIntmName}'.replace(/\\/g, '\\\\');
		$("txtDspIntmName").value = '${dfltIntmNo}' + (String(nvl('${dfltIntmNo}', '')).blank() || nvl('${dfltIntmName}').blank() ? '' : ' - ') + '${dfltIntmName}'.replace(/\\/g, '\\\\');
		$("txtParentIntmNo").value = '${dfltParentIntmNo}';
		$("txtParentIntmName").value = '${dfltParentIntmName}'.replace(/\\/g, '\\\\');
		$("txtDspParentIntmName").value = '${dfltParentIntmNo}' + (nvl(String('${dfltParentIntmNo}'), '').blank() || nvl('${dfltParentIntmName}', '').blank() ? '' : ' - ') + '${dfltParentIntmName}'.replace(/\\/g, '\\\\');
	}
	
	/* benjo 09.07.2016 SR-5604 */
	if(reqDfltIntmPerAssd == "Y"){
		if(String(nvl('${maintainedDfltIntmNo}', '')).blank() || nvl('${maintainedDfltIntmNo}').blank()){
			//showWaitingMessageBox("No default intermediary maintained for this assured. Please contact MIS for the set-up of intermediary", imgMessage.INFO, cancelFuncWcommInvoice); //benjo 03.07.2017 SR-5893
			showMessageBox("No default intermediary maintained for this assured. Please contact MIS for the set-up of intermediary.", imgMessage.INFO); //benjo 03.07.2017 SR-5893
		}else{
			if(allowUpdIntmPerAssd == "N"){
				$("chkLovTag").value = "FILTERED";
				$("chkLovTag").checked = true;
				$("chkLovTag").disabled = true;
			}else if(allowUpdIntmPerAssd == "O"){
				if(validateUserFunc3(overrideUser, "OV", "GIPIS160")==true){
					override = "N";
				}else{
					$("chkLovTag").value = "FILTERED";
					$("chkLovTag").checked = true;
					override = "Y";
				}
			}
			if((objGIPIWPolbas.polFlag == 2 || objUWParList.parType == "E") && '${maintainedDfltIntmNo}' != $F("txtIntmNo")){
				showMessageBox("Policy Intermediary is not the same as the default Intermediary for the assured.", imgMessage.INFO);
			}
		}
	}
	
	setDefaultSharePercentage();
	changeTag = 0;
	initializeChangeTagBehavior(saveWcommInvoice);
	initializeChangeAttribute();
</script>