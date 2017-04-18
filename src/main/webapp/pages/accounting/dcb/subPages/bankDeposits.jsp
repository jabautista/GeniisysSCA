<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="bankDepositDiv" name="bankDepositDiv" class="sectionDiv" style="width: 94%; margin: 3px; font-size: 11px;">
	<form id="bankDepositForm" name="bankDepositForm" style="margin: 10px;">
		<!-- Bank Deposit List -->
		
		<div class="sectionDiv" id="gbdsOuterDiv" style="border-bottom: none;" changeTagAttr="true">
			<!-- GBDS -->
			<div id="gbdsListTableGridSectionDiv" class="sectionDiv" style="height: 160px; border: none" align="center">
				<div id="gbdsListTableGridDiv" style="padding: 10px; border: none" align="center">
					<div id="gbdsListTableGrid" style="height: 120px; width: 664px; border: none" align="left"></div>
				</div>
			</div>
			
			<div class="sectionDiv" style="border-left: white; border-right: white; border-bottom: white;" id="bankDepositDiv" style="margin-top: -2px;">
				<table width="800px" align="center" cellspacing="1" border="0">
					<tr>
						<td style="width: 240px">&nbsp</td>
						<td class="rightAligned" style="width: 200px;">Local Currency Amount Total</td>
						<td class="leftAligned">
							<input type="text" id="gbdsDspTotLoc" name="gbdsDspTotLoc" style="width: 120px; text-align: right" readonly="readonly" value=""/>
						</td>
						<td style="width: 200px">&nbsp</td>
					</tr>
					<tr>
						<td style="width: 320px"></td>
						<td class="rightAligned" style="width: 200px;">Foreign Currency Amount Total</td>
						<td class="leftAligned">
							<input type="text" id="gbdsDspTotFor" name="gbdsDspTotFor" style="width: 120px; text-align: right" readonly="readonly" value=""/>
						</td>
						<td style="width: 200px">&nbsp</td>
					</tr>
				</table>
			</div>
		</div>
		
		<div class="sectionDiv" id="gbdsdOuterDiv" style="border-bottom: none;" changeTagAttr="true">
			<!-- GBDSD -->
			<div id="gbdsdListTableGridSectionDiv" class="sectionDiv" style="height: 140px; border: none" align="center">
				<div id="gbdsdListTableGridDiv" style="padding: 10px; border: none" align="center">
					<div id="gbdsdListTableGrid" style="height: 100px; width: 664px; border: none" align="left"></div>
				</div>
			</div>
			
			<div class="sectionDiv" style="border-left: white; border-right: white; border-bottom: white;" id="gbdsdDetailsDiv" style="margin-top: -2px;">
				<table width="800px" align="center" cellspacing="1" border="0">
					<tr>
						<td style="width: 240px">&nbsp</td>
						<td class="rightAligned" style="width: 200px;">Local Currency Amount Total</td>
						<td class="leftAligned">
							<input type="text" id="gbdsdDspTotal" name="gbdsdDspTotal" style="width: 120px; text-align: right" readonly="readonly" value=""/>
						</td>
						<td style="width: 200px">&nbsp</td>
					</tr>
					<tr>
						<td style="width: 320px"></td>
						<td class="rightAligned" style="width: 200px;">Foreign Currency Amount Total</td>
						<td class="leftAligned">
							<input type="text" id="gbdsdForeignCurrSumAmt" name="gbdsdForeignCurrSumAmt" style="width: 120px; text-align: right" readonly="readonly" value=""/>
						</td>
						<td style="width: 200px">&nbsp</td>
					</tr>
					<tr>
						<td style="width: 240px">&nbsp</td>
						<td class="rightAligned" style="width: 200px;">Deposit Amount Total</td>
						<td class="leftAligned">
							<input type="text" id="gbdsdDspTotDeposit" name="gbdsdDspTotDeposit" style="width: 120px; text-align: right" readonly="readonly" value=""/>
						</td>
						<td style="width: 200px">&nbsp</td>
					</tr>
				</table>
				<table align="center" cellspacing="1" border="0">
					<tr>
						<td class="rightAligned" style="width: 50px;">Payor</td>
						<td class="leftAligned" style="width: 180px;">
							<input type="text" id="gbdsdPayor" name="gbdsdPayor" style="width: 170px;" value=""/>
						</td>
						<td class="rightAligned" style="width: 120px;">OR No</td>
						<td class="leftAligned" style="width: 160px;">
							<input type="text" id="gbdsdDspORPrefSuf" name="gbdsdDspORPrefSuf" style="width: 150px;" value=""/>
						</td>
					</tr>
				</table>
				<table align="center">
					<tr>
						<td class="leftAligned"  style="width: 62px"><input type="button" class="button" id="btnOtcDetails" 		name="btnOtcDetails" 		 value="Details" style="width: 70px;" /></td>
						<td class="leftAligned"  style="width: 62px"><input type="button" class="button" id="btnBankDepositsReturn" name="btnBankDepositsReturn" value="Return"  style="width: 70px;" /></td>
					</tr>
				</table>
			</div>
		</div>
	</form>
</div>
<script type="text/JavaScript">
	var selectedGbdsRow	   = null;
	var selectedGbdsdRow   = null;

	var selectedGbdsIndex  = null;
	var selectedGbdsdIndex = null;
	var _selectedGdbdIndex = '${selectedGdbdIndex}';

	var gdbdGaccTranId	   = '${gdbdGaccTranId}';
	var gdbdItemNo		   = '${gdbdItemNo}';
	var gdbdDcbNo		   = '${gdbdDcbNo}';

	// GBDS Table Grid
	
	try {
		var objGbds = new Object();
		objGbds.objGbdsListTableGrid = JSON.parse('${gbdsListTableGrid}'.replace(/\\/g, '\\\\'));
		objGbds.objGbdsList = objGbds.objGbdsListTableGrid.rows || [];
	
		var gbdsTableModel = {
				url: contextPath+"/GIACBankDepSlipsController?action=refreshBankDepositListing&gaccTranId="+encodeURIComponent(objACGlobal.gaccTranId),
				options:{
					title: '',
					width: '664px',
					onCellFocus: function(element, value, x, y, id){
						var mtgId = gbdsListTableGrid._mtgId;
						selectedGbdsIndex = y;
						selectedGbdsdIndex = null;
						if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
							// set selected GBDS row
							selectedGbdsRow = gbdsListTableGrid.geniisysRows[y];

							refreshGbdsdBlock();
							validateGbdsShortName(getGbdsValue('currencyShortName'));
						}
						observeChangeTagInTableGrid(gbdsListTableGrid);
					},
					onRemoveRowFocus: function(element, value, x, y, id) {
						selectedGbdsRow = null;
						selectedGbdsdRow = null;
						selectedGbdsIndex = null;
						selectedGbdsdIndex = null;
						refreshGbdsdBlock();
					},
					onCellBlur: function(element, value, x, y, id){
						observeChangeTagInTableGrid(gbdsListTableGrid);
					},
					toolbar: {
						elements: [MyTableGrid.ADD_BTN, MyTableGrid.DEL_BTN, MyTableGrid.SAVE_BTN],
						onAdd: function(){
							for (var i = 0; i < gbdsListTableGrid.newRowsAdded.length; i++) {
								var index = gbdsListTableGrid.getColumnIndex('depNo');
								selectedGbdsIndex = -(i + 1);
								if (String(nvl(gbdsListTableGrid.newRowsAdded[i][index], "")).blank()) {
									selectedGbdsRow = null;
									selectedGbdsIndex = null;
									return false;
								}
							}
							
							selectedGbdsRow = null;
							selectedGbdsIndex = null;
							gbdsListTableGrid.keys.releaseKeys();
						},
						onDelete: function(){
							selectedGbdsRow = null;
							selectedGbdsIndex = null;
						},
						onSave: function() {
							for (var i = 0; i < gbdsListTableGrid.newRowsAdded.length; i++) {
								/** GBDS pre-insert trigger */
								selectedGbdsIndex = -(i + 1);
								setGbdsValue(gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('gaccTranId'), _selectedGdbdIndex), 'gaccTranId');
								setGbdsValue(gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('fundCd'), _selectedGdbdIndex), 'fundCd');
								setGbdsValue(gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('branchCd'), _selectedGdbdIndex), 'branchCd');
								setGbdsValue(gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('dcbYear'), _selectedGdbdIndex), 'dcbYear');
								setGbdsValue(gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('dcbNo'), _selectedGdbdIndex), 'dcbNo');
								setGbdsValue(gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('itemNo'), _selectedGdbdIndex), 'itemNo');
								if (String(nvl(getGbdsValue('depNo'), "")).blank()) {
									setGbdsValue(getMaxDepNo(), 'depNo');
								}

								// setting of depId moved to Saving

								/** end of GBDS pre-insert trigger */
							}
							selectedGbdsIndex = null;
						}
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
						id: 'depId',
						width: '0',
						visible: false
					},
					{	id: 'gaccTranId',
						width: '0px',
						visible: false
					},
					{	id: 'fundCd',
						width: '0px',
						visible: false
					},
					{	id: 'branchCd',
						width: '0px',
						visible: false
					},
					{	id: 'dcbYear',
						width: '0px',
						visible: false
					},
					{	id: 'dcbNo',
						width: '0px',
						visible: false
					},
					{	id: 'itemNo',
						width: '0px',
						visible: false
					},
					{
						id: 'depNo',
						title: 'Dep No',
						width: '60px',
						align: 'center',
						titleAlign: 'center'
					},
					{
						id: 'checkClass',
						title: 'Check Class',
						width: '100px',
						align: 'center',
						titleAlign: 'center',
						editable: true,
						editor: new MyTableGrid.BrowseInput({
							onClick: function() {
								showOverlayContent2(contextPath+"/GIACAccTransController?action=showCheckClassList"
										+"&block=GBDS", 
										"Check Class", 360, "");
							},
							validate: function(input, value) {
								return false;
							}
						})
					},
					{
						id: 'validationDt',
						title: 'Validation Date',
						width: '100px',
						align: 'center',
						titleAlign: 'center',
						type: 'date',
						format: 'mm-dd-yyyy',
						editable: true,
						editor: new MyTableGrid.CellCalendar({
							onClick: function() {
								var coords = gbdsListTableGrid.getCurrentPosition();
								var inputId = 'mtgInput' + gbdsListTableGrid._mtgId + '_' + coords[0] + ',' + coords[1];
								$(inputId).focus();
								scwShow($(inputId) ,this, null);
							},
							validate: function(value, input) {
								if (isDate(value)) {
									value = Date.parse(value, "mm-dd-yyyy").format('mm-dd-yyyy');
									setGbdsValue(value, 'validationDt');
									return false;
								} else {
									return false;
								}
							}
						})
					},
					{	id: 'currencyCd',
						width: '0px',
						visible: false
					},
					{
						id: 'currencyShortName',
						title: 'Currency',
						width: '80px',
						align: 'center',
						titleAlign: 'center',
						editable: true,
						editor: new MyTableGrid.BrowseInput({
							onClick: function() {
								showOverlayContent2(contextPath+"/GIISCurrencyController?action=showCurrencyShortNameList&shortName="
										+encodeURIComponent($F("gdbdShortName"))
										+"&block=GBDS", 
										"Select Currency", 560, "");
							},
							validate: function(input, value) {
								return false;
							}
						})
					},
					{
						id: 'amount',
						title: 'Local Currency Amt',
						width: '105px',
						align: 'right',
						titleAlign: 'center',
						editable: true,
						geniisysClass: 'money',
						geniisysErrorMsg: 'Field must be of form 99,999,999,999,990.00.',
						maxlength: 30,
						editor: new MyTableGrid.CellInput({
							validate: function(value, input) {
								setGbdsValue(value, 'amount');
								if (getGbdsValue('currencyShortName') == $F("varDefaultCurrency")) {
									setGbdsValue(value, 'foreignCurrAmt');
								}
								computeGbdsTotal();
								return true;
							}
						})
					},
					{
						id: 'foreignCurrAmt',
						title: 'Foreign Currency Amt',
						width: '105px',
						align: 'right',
						titleAlign: 'center',
						editable: true,
						geniisysClass: 'money',
						geniisysErrorMsg: 'Field must be of form 99,999,999,999,990.00.',
						maxlength: 14,
						editor: new MyTableGrid.CellInput({
							validate: function(value, input) {
								setGbdsValue(value, 'foreignCurrAmt');
								if (getGbdsValue('currencyShortName') != $F("varDefaultCurrency")) {
									setGbdsValue(roundNumber(parseFloat(value.replace(/,/g,"")) * parseFloat(getGbdsValue('currencyRt')), 2), 'amount');
								}
								computeGbdsTotal();
								return true;
							}
						})
					},
					{
						id: 'currencyRt',
						title: 'Currency Rate',
						width: '100px',
						align: 'right',
						titleAlign: 'center',
						geniisysClass: 'integerNoNegativeUnformattedNoComma',
						geniisysErrorMsg: 'Invalid input.'
					}
				],
				resetChangeTag: true,
				rows: objGbds.objGbdsList
		};
	
		gbdsListTableGrid = new MyTableGrid(gbdsTableModel);
		gbdsListTableGrid.pager = objGbds.objGbdsListTableGrid;
		gbdsListTableGrid.render('gbdsListTableGrid');
	
		computeGbdsTotal();
		//refreshGbdsdBlock();
	} catch(e){
		showErrorMessage("Bank Deposit - GBDS", e);
	}

	// GBDSD Table Grid
	try {
		var objGbdsd = new Object();
		objGbdsd.objGbdsdListTableGrid = JSON.parse('${gbdsdListTableGrid}'.replace(/\\/g, '\\\\'));
		objGbdsd.objGbdsdList = objGbdsd.objGbdsdListTableGrid.rows || [];
	
		var gbdsdTableModel = {
				url: contextPath+"/GIACBankDepSlipsController?action=refreshGbdsdListing&depId="
					+ ((selectedGbdsRow == null) ? "" : encodeURIComponent(selectedGbdsRow.depId))
					+ "&depNo=" + ((selectedGbdsRow == null) ? "" : encodeURIComponent(selectedGbdsRow.depNo)) ,
				options:{
					title: '',
					width: '664px',
					onCellFocus: function(element, value, x, y, id){
						var mtgId = gbdsdListTableGrid._mtgId;
						selectedGbdsdRow = null;
						selectedGbdsdIndex = y;
						if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
							// set selected GBDSD row
							selectedGbdsdRow = gbdsdListTableGrid.geniisysRows[y];
							$("gbdsdPayor").value = getGbdsdValue('payor');
							$("gbdsdDspORPrefSuf").value = getGbdsdValue('dspOrPrefSuf');
							enableButton("btnOtcDetails");
						}
						observeChangeTagInTableGrid(gbdsdListTableGrid);
					},
					onRemoveRowFocus: function(element, value, x, y, id) {
						selectedGbdsdRow  = null;
						selectedGbdsdIndex = null;
						$("gbdsdPayor").value = "";
						$("gbdsdDspORPrefSuf").value = "";
						disableButton("btnOtcDetails");
					},
					onCellBlur: function(element, value, x, y, id){
						observeChangeTagInTableGrid(gbdsdListTableGrid);
					},
					toolbar: {
						elements: [MyTableGrid.ADD_BTN, MyTableGrid.DEL_BTN, MyTableGrid.SAVE_BTN],
						onAdd: function() {
							if (nvl(getGbdsValue('checkClass'),"").blank() || String(nvl(getGbdsValue('amount'), "")).blank()
									|| nvl(getGbdsValue('currencyShortName'),"").blank()) {
								showMessageBox("Bank deposit slip must be selected before listing details of deposit slip.", imgMessage.INFO);
							} else if (String(nvl(getGbdsValue('depNo'),"")).blank()) {
								showMessageBox("Please save bank deposit slip detail first.", imgMessage.INFO);
							} else {
								showOverlayContent2(contextPath+"/GIACAccTransController?action=getGbdsdLOV"
										+ "&dcbNo=" + gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('dcbNo'), _selectedGdbdIndex)
										+ "&dcbDate=" + Date.parse(gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('dcbDate'), _selectedGdbdIndex), "mm-dd-yyyy").format('mm-dd-yyyy')
										+ "&branchCd=" + gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('branchCd'), _selectedGdbdIndex)
										+ "&payMode=" + gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('payMode'), _selectedGdbdIndex)
										+ "&depNo=" + getGbdsValue('depNo'),
										"Select GDBDS", 850, "");
							}
							return false;
						},
						onDelete: function() {
						},
						onSave: function() {
						}
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
						id: 'depId',
						width: '0',
						visible: false
					},
					{
						id: 'depNo',
						width: '0',
						visible: false
					},
					{
						id: 'currencyCd',
						width: '0',
						visible: false
					},
					{
						id: 'bankCd',
						width: '0',
						visible: false
					},
					{
						id: 'orPref',
						width: '0',
						visible: false
					},
					{
						id: 'checkNo',
						width: '0',
						visible: false
					},
					{
						id: 'dspCheckNo',
						title: 'Check No',
						width: '100px',
						align: 'center',
						titleAlign: 'center'
					},
					{
						id: 'payor',
						width: '0',
						visible: false
					},
					{
						id: 'orNo',
						width: '0',
						visible: false
					},
					{
						id: 'dspOrPrefSuf',
						width: '0',
						visible: false
					},
					{
						id: 'amount',
						title: 'Local Currency Amt',
						width: '105px',
						align: 'right',
						titleAlign: 'center',
						editable: true,
						geniisysClass: 'money',
						geniisysErrorMsg: 'Field must be of form 99,999,999,999,990.00.',
						maxlength: 30,
						editor: new MyTableGrid.CellInput({
							validate: function(value, input) {
								setGbdsdValue(value, 'amount');
								setGbdsdValue(value, 'depositedAmt');
								computeGbdsdTotalAmts();
								return true;
							}
						})
					},
					{
						id: 'currencyShortName',
						title: 'Currency',
						width: '80px',
						align: 'center',
						titleAlign: 'center',
						editable: true,
						editor: new MyTableGrid.BrowseInput({
							onClick: function() {
								showOverlayContent2(contextPath+"/GIISCurrencyController?action=showCurrencyShortNameList&shortName="
										+encodeURIComponent($F("gdbdShortName"))
										+"&block=GBDSD", 
										"Select Currency", 560, "");
							},
							validate: function(input, value) {
								return false;
							}
						})
					},
					{
						id: 'foreignCurrAmt',
						title: 'Foreign Currency Amt',
						width: '105px',
						align: 'right',
						titleAlign: 'center',
						editable: true,
						geniisysClass: 'money',
						geniisysErrorMsg: 'Field must be of form 99,999,999,999,990.00.',
						maxlength: 30,
						editor: new MyTableGrid.CellInput({
							validate: function(value, input) {
								setGbdsdValue(value, 'foreignCurrAmt');
								computeGbdsdTotalAmts();
								return true;
							}
						})
					},
					{
						id: 'currencyRt',
						title: 'Currency Rate',
						width: '100px',
						align: 'center',
						titleAlign: 'center',
						editable: true,
						geniisysClass: 'integerNoNegativeUnformattedNoComma',
						geniisysErrorMsg: 'Invalid input.'
					},
					{
						id: 'localSur',
						width: '0',
						visible: false
					},
					{
						id: 'foreignSur',
						width: '0',
						visible: false
					},
					{
						id: 'netCollnAmt',
						width: '0',
						visible: false
					},
					{
						id: 'bookTag',
						width: '0',
						visible: false
					},
					{
						id: 'depositedAmt',
						title: 'Deposited Amt',
						width: '105px',
						align: 'right',
						titleAlign: 'center',
						editable: true,
						geniisysClass: 'money',
						geniisysErrorMsg: 'Field must be of form 99,999,999,999,990.00.',
						maxlength: 30,
						editor: new MyTableGrid.CellInput({
							validate: function(value, input) {
								if (String(nvl(getGbdsdValue('amount'), "")).blank() || String(nvl(value, "")).blank()) {
									setGbdsdValue("", 'locErrorAmt');
								} else {
									setGbdsdValue(parseFloat(nvl(getGbdsdValue('amount'), "0")) - parseFloat(nvl(value, "0")), 'locErrorAmt');
								}
								setGbdsdValue(value, 'depositedAmt');
								computeGbdsdTotalAmts();
								return true;
							}
						})
					},
					{
						id: 'locErrorAmt',
						title: 'Difference',
						width: '105px',
						align: 'right',
						titleAlign: 'center',
						editable: true,
						geniisysClass: 'money',
						geniisysErrorMsg: 'Field must be of form 99,999,999,999,990.00.',
						maxlength: 30
					},
					{
						id: 'errorTag',
						title: 'E',
						width: '20px',
						align: 'center',
						titleAlign: 'center',
						editable: true,
						defaultValue: false,
						otherValue: false,
						editor: new MyTableGrid.CellCheckbox({
					        getValueOf: function(value){
				            	if (value){
									return "Y";
				            	}else{
									return "N";	
				            	}
			            	},
			            	onClick: function(value, checked) {
				            	if (value == "Y") {
				            		enableButton("btnBankDepositsReturn");
					            	$("varWithError").value = "Y";
				            	}
				            	setGbdsdValue(value, 'errorTag');
			            	}
			            })
					},
					{
						id: 'bounceTag',
						title: 'BC',
						width: '20px',
						align: 'center',
						titleAlign: 'center',
						editable: true,
						defaultValue: false,
						otherValue: false,
						editor: new MyTableGrid.CellCheckbox({
					        getValueOf: function(value){
				            	if (value){
									return "Y";
				            	}else{
									return "N";	
				            	}
			            	},
			            	onClick: function(value, checked) {
				            	//selectedGbdsdRow.otcTag = value;
				            	setGbdsdValue(value, 'bounceTag');
			            	}
			            })
					},
					{
						id: 'otcTag',
						title: 'O',
						width: '20px',
						align: 'center',
						titleAlign: 'center',
						editable: true,
						defaultValue: false,
						otherValue: false,
						editor: new MyTableGrid.CellCheckbox({
					        getValueOf: function(value){
				            	if (value){
									return "Y";
				            	}else{
									return "N";	
				            	}	
			            	},
			            	onClick: function(value, checked) {
				            	//selectedGbdsdRow.otcTag = value;
				            	if (value == "Y") {
				            		enableButton("btnBankDepositsReturn");
					            	$("varWithOTC").value = "Y";
				            	} else {
				            		$("varWithOTC").value = "N";
				            	}
				            	setGbdsdValue(value, 'otcTag');
			            	}
			            })
					}
				],
				resetChangeTag: true,
				rows: objGbdsd.objGbdsdList,
				hideRowsOnLoad: true
		};
	
		gbdsdListTableGrid = new MyTableGrid(gbdsdTableModel);
		gbdsdListTableGrid.pager = objGbdsd.objGbdsdListTableGrid;
		gbdsdListTableGrid.render('gbdsdListTableGrid');
	} catch(e){
		showErrorMessage("Bank Deposit - GBDSD", e);
	}

	/** page item triggers */
	
	$("btnOtcDetails").observe("click", function() {
		if (selectedGbdsdIndex != null) {
			if (getGbdsdValue('errorTag') == "Y") {
				// call the onHideFunc to save the edited GBDS and GBDSD rows
				Modalbox.options.onHideFunc();
				var errorBookTag = "";
				var errorRemarks = "";
				var errorRecordStatus = "QUERY";

				if (String(nvl(getGbdsdValue('depId'),"")).blank() || String(nvl(getGbdsdValue('depNo'),"")).blank()) {
					errorRecordStatus = "INSERT";
				}

				if (objACModalboxParams.errorRows != null) {
					for (var i = 0; i < objACModalboxParams.errorRows.length; i++) {
						errorBookTag = objACModalboxParams.errorRows[i]['bookTag'];
						errorRemarks = objACModalboxParams.errorRows[i]['remarks'];
					}
				}

				if (String(nvl(getGbdsdValue('locErrorAmt'),"")).blank()) {
					setGbdsdValue('N', 'errorTag');
				}
				
				Modalbox.show(contextPath+"/GIACBankDepSlipsController?action=showGbdsdErrorPage"
						+ "&itemNo=" 	+ ((selectedGbdsIndex == null) ? "" : encodeURIComponent(getGbdsValue('itemNo')))
						+ "&depId=" 	+ getGbdsdValue('depId')
						+ "&depNo=" 	+ getGbdsdValue('depNo')
						+ "&bankCd=" 	+ getGbdsdValue('bankCd')
						+ "&checkNo=" 	+ getGbdsdValue('checkNo')
						+ "&orPref=" 	+ getGbdsdValue('orPref')
						+ "&orNo=" 		+ getGbdsdValue('orNo')
						+ "&dspCheckNo=" + getGbdsdValue('dspCheckNo')
						+ "&amount=" 	+ getGbdsdValue('amount')
						+ "&currencyShortName=" + getGbdsdValue('currencyShortName')
						+ "&currencyRt=" + getGbdsdValue('currencyRt')
						+ "&dcbNo="		+ gdbdDcbNo
						+ "&bookTag="	+ errorBookTag
						+ "&remarks="	+ errorRemarks
						+ "&parameters=" + JSON.stringify(objACModalboxParams)
						+ "&recordStatus=" + errorRecordStatus
						+ "&gbdsdIndex=" + ((selectedGbdsdIndex == null) ? "" : selectedGbdsdIndex),
						{  title: "Check Deposit Analysis",
						   width: 800,
						   headerClose: false,
						   overlayClose: false});
			} else if (getGbdsdValue('otcTag') == "Y") {
				// call the onHideFunc to save the edited GBDS and GBDSD rows
				Modalbox.options.onHideFunc();
				
				Modalbox.show(contextPath+"/GIACAccTransController?action=showOtcPage"
						+ "&gaccTranId="+ encodeURIComponent(objACGlobal.gaccTranId)
						+ "&itemNo=" 	+ ((gdbdItemNo == null) ? "" : encodeURIComponent(gdbdItemNo))
						+ "&dcbNo=" 	+ ((gdbdDcbNo == null) ? "" : encodeURIComponent(gdbdDcbNo))
						+ "&dspCheckNo="+ getGbdsdValue('dspCheckNo')
						+ "&amount=" 	+ getGbdsdValue('amount')
						+ "&foreignCurrAmt=" 	+ getGbdsdValue('foreignCurrAmt')
						+ "&currencyShortName=" + getGbdsdValue('currencyShortName')
						+ "&currencyRt=" + getGbdsdValue('currencyRt')
						+ "&parameters=" + JSON.stringify(objACModalboxParams)
						+ "&depId=" + getGbdsdValue('depId'),
						{  title: "Out of Town Check Detail",
						   width: 800,
						   headerClose: false,
						   overlayClose: false});
			}
		} else {
			showMessageBox("No record selected.", imgMessage.INFO);
		}
	});
	
	$("btnBankDepositsReturn").observe("click", function() {
		/*var vDepId2 = null;
		
		if ($F("gdbdPayMode") != "CA") {
			for (var i = 0; i < gbdsListTableGrid.rows.length; i++) {
				vDepId2 = gbdsListTableGrid.rows[i][gbdsListTableGrid.getColumnIndex('depId')];
				break;
			}

			if (!String(nvl(vDepId2, "")).blank()) {
				
			}
		}*/

		new Ajax.Request(contextPath+"/GIACAccTransController?action=executeGiacs035BankDepReturnBtn", {
			method: "GET",
			evalScripts: true,
			asynchronous: false,
			parameters: {
				payMode: gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('payMode'), _selectedGdbdIndex),
				gaccTranId: gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('gaccTranId'), _selectedGdbdIndex),
				dcbNo: gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('dcbNo'), _selectedGdbdIndex),
				itemNo: gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('itemNo'), _selectedGdbdIndex),
				amount: gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('amount'), _selectedGdbdIndex),
				varWithOTC: $F("varWithOTC")
			},
			onComplete: function(response) {
				var result = response.responseText.toQueryParams();

				if (result.message != "SUCCESS") {
					showMessageBox(result.message, imgMessage.INFO);
				} else {
					$("varWithOTC").value = result.varWithOTC;
					Modalbox.hide({executeOnHideFunc : true});
				}
			}
		});
	});

	$("gbdsdPayor").observe("blur", function() {
		if (selectedGbdsdIndex != null) {
			setGbdsdValue($F("gbdsdPayor"), 'payor');
		}
	});

	$("gbdsdDspORPrefSuf").observe("blur", function() {
		if (selectedGbdsdIndex != null) {
			setGbdsdValue($F("gbdsdDspORPrefSuf"), 'dspOrPrefSuf');
		}
	});

	/** end of page item triggers */

	/** page functions */
	
	function refreshGbdsdBlock() {
		var divCtrId;
		$("gbdsdPayor").value = "";
		$("gbdsdDspORPrefSuf").value = "";
		
		for (var i = 0; i < gbdsdListTableGrid.rows.length; i++) {
			divCtrId = gbdsdListTableGrid.rows[i][gbdsdListTableGrid.getColumnIndex('divCtrId')];
			// if both depNo's are blank, comparision should yield false result
			if (nvl(gbdsdListTableGrid.rows[i][gbdsdListTableGrid.getColumnIndex('depNo')], "x") == nvl(getGbdsValue('depNo'), "y")) {
				$("mtgRow"+gbdsdListTableGrid._mtgId+"_"+divCtrId) ? $("mtgRow"+gbdsdListTableGrid._mtgId+"_"+divCtrId).show() :null;
			} else {
				$("mtgRow"+gbdsdListTableGrid._mtgId+"_"+divCtrId) ? $("mtgRow"+gbdsdListTableGrid._mtgId+"_"+divCtrId).hide() :null;
			}
		}

		for (var i = 0; i < gbdsdListTableGrid.newRowsAdded.length; i++) {
			divCtrId = gbdsdListTableGrid.newRowsAdded[i][gbdsdListTableGrid.getColumnIndex('divCtrId')];
			// if both depNo's are blank, comparision should yield false result
			if (nvl(gbdsdListTableGrid.newRowsAdded[i][gbdsdListTableGrid.getColumnIndex('depNo')], "x") == nvl(getGbdsValue('depNo'), "y")) {
				$("mtgRow"+gbdsdListTableGrid._mtgId+"_"+divCtrId) ? $("mtgRow"+gbdsdListTableGrid._mtgId+"_"+divCtrId).show() :null;
			} else {
				$("mtgRow"+gbdsdListTableGrid._mtgId+"_"+divCtrId) ? $("mtgRow"+gbdsdListTableGrid._mtgId+"_"+divCtrId).hide() :null;
			}
		}

		if (selectedGbdsIndex != null) {
			computeGbdsdTotalAmts();
		} else {
			$("gbdsdDspTotal").value = "";
			$("gbdsdForeignCurrSumAmt").value = "";
			$("gbdsdDspTotDeposit").value = "";
		}
	}

	/*
	** Gets the value of gbds record in specified column and selected row
	*/
	function getGbdsValue(column) {
		return (selectedGbdsIndex == null) ? "" : gbdsListTableGrid.getValueAt(gbdsListTableGrid.getColumnIndex(column), selectedGbdsIndex);
	}

	/*
	** Sets the value of gbds record in specified column and selected row
	*/
	function setGbdsValue(value, column) {
		if (selectedGbdsIndex != null) {
			gbdsListTableGrid.setValueAt(value, gbdsListTableGrid.getColumnIndex(column), selectedGbdsIndex);
		}
	}

	/*
	** Gets the value of gbdsd record in specified column and selected row
	*/
	function getGbdsdValue(column) {
		return (selectedGbdsdIndex == null) ? "" : gbdsdListTableGrid.getValueAt(gbdsdListTableGrid.getColumnIndex(column), selectedGbdsdIndex);
	}

	/*
	** Sets the value of gbdsd record in specified column and selected row
	*/
	function setGbdsdValue(value, column) {
		if (selectedGbdsdIndex != null) {
			gbdsdListTableGrid.setValueAt(value, gbdsdListTableGrid.getColumnIndex(column), selectedGbdsdIndex);
		}
	}

	/*
	** Calculate and set local and foreign currency amount total
	*/
	function computeGbdsTotal() {
		var totalGbdsLocalCurrAmt   = 0;
		var totalGbdsForeignCurrAmt = 0;
		var allIsNull = true;
		var lIndex = gbdsListTableGrid.getColumnIndex('amount');
		var fIndex = gbdsListTableGrid.getColumnIndex('foreignCurrAmt');
		
		for (var i = 0; i < gbdsListTableGrid.rows.length; i++) {
			totalGbdsLocalCurrAmt   = totalGbdsLocalCurrAmt   + parseFloat(gbdsListTableGrid.rows[i][lIndex]);
			totalGbdsForeignCurrAmt = totalGbdsForeignCurrAmt + parseFloat(gbdsListTableGrid.rows[i][fIndex]);

			if (!String(nvl(gbdsListTableGrid.rows[i][lIndex], "")).blank()) {
				allIsNull = false;
			}
		}

		for (var i = 0; i < gbdsListTableGrid.newRowsAdded.length; i++) {
			totalGbdsLocalCurrAmt   = totalGbdsLocalCurrAmt   + parseFloat(gbdsListTableGrid.newRowsAdded[i][lIndex]);
			totalGbdsForeignCurrAmt = totalGbdsForeignCurrAmt + parseFloat(gbdsListTableGrid.newRowsAdded[i][fIndex]);

			if (!String(nvl(gbdsListTableGrid.newRowsAdded[i][lIndex], "")).blank()) {
				allIsNull = false;
			}
		}

		if (allIsNull) {
			$("gbdsDspTotLoc").value = "";
		} else {
			$("gbdsDspTotLoc").value = formatCurrency(parseFloat(nvl(totalGbdsLocalCurrAmt, "0")));
		}
		
		$("gbdsDspTotFor").value = formatCurrency(parseFloat(nvl(totalGbdsForeignCurrAmt, "0")));
	}

	function computeGbdsdTotalAmts() {
		/* Set local and foreign currency amount total */
		var totalGbdsdLocalCurrAmt   = 0;
		var totalGbdsdForeignCurrAmt = 0;
		var totalGbdsdDepositedAmt	 = 0;
		var lIndex = gbdsdListTableGrid.getColumnIndex('amount');
		var fIndex = gbdsdListTableGrid.getColumnIndex('foreignCurrAmt');
		var dIndex = gbdsdListTableGrid.getColumnIndex('depositedAmt');

		for (var i = 0; i < gbdsdListTableGrid.rows.length; i++) {
			if (gbdsdListTableGrid.rows[i][gbdsdListTableGrid.getColumnIndex('depId')] == getGbdsValue('depId')) {
				totalGbdsdLocalCurrAmt   = totalGbdsdLocalCurrAmt   + parseFloat(gbdsdListTableGrid.rows[i][lIndex]);
				totalGbdsdForeignCurrAmt = totalGbdsdForeignCurrAmt + parseFloat(gbdsdListTableGrid.rows[i][fIndex]);
				totalGbdsdDepositedAmt	 = totalGbdsdDepositedAmt	+ parseFloat(gbdsdListTableGrid.rows[i][dIndex]);
			}
		}

		for (var i = 0; i < gbdsdListTableGrid.newRowsAdded.length; i++) {
			if (gbdsdListTableGrid.rows[i][gbdsdListTableGrid.getColumnIndex('depId')] == getGbdsValue('depId')) {
				totalGbdsdLocalCurrAmt   = totalGbdsdLocalCurrAmt   + parseFloat(gbdsdListTableGrid.newRowsAdded[i][lIndex]);
				totalGbdsdForeignCurrAmt = totalGbdsdForeignCurrAmt + parseFloat(gbdsdListTableGrid.newRowsAdded[i][fIndex]);
				totalGbdsdDepositedAmt	 = totalGbdsdDepositedAmt	+ parseFloat(gbdsdListTableGrid.rows[i][dIndex]);
			}
		}

		$("gbdsdDspTotal").value = formatCurrency(parseFloat(nvl(totalGbdsdLocalCurrAmt, "0")));
		$("gbdsdForeignCurrSumAmt").value = formatCurrency(parseFloat(nvl(totalGbdsdForeignCurrAmt, "0")));
		$("gbdsdDspTotDeposit").value = formatCurrency(parseFloat(nvl(totalGbdsdDepositedAmt, "0")));
	}

/*	function saveGbds() {
		var ok = true;
	 	var addedRows 	 = gbdsListTableGrid.getNewRowsAdded();
		var modifiedRows = gbdsListTableGrid.getModifiedRows();
		var delRows  	 = gbdsListTableGrid.getDeletedRows();
		var setRows		 = addedRows.concat(modifiedRows);
		 
		var objParameters = new Object();
		objParameters.delRows = delRows;
		objParameters.setRows = addedRows.concat(modifiedRows);
		var strParameters = JSON.stringify(objParameters);
		new Ajax.Request(contextPath+"/GIACBankDepSlipsController?action=saveGbdsBlock",{
			method: "POST",
			parameters:{
				parameters: strParameters
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				if(checkErrorOnResponse(response)) {
					if (response.responseText == "SUCCESS"){
						return true;
					}
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
					return false;
				}
			}	 
		});	
	}*/

	function validateGbdsShortName(value) {
		$("varDefaultCurrency").value = $F("defaultCurrency");
		
		if (value == "" || value == null) {
			gbdsListTableGrid.columnModel[gbdsListTableGrid.getColumnIndex('amount')].editable = true;
			gbdsListTableGrid.columnModel[gbdsListTableGrid.getColumnIndex('foreignCurrAmt')].editable = true;
		} else if (value != $F("varDefaultCurrency")) {
			gbdsListTableGrid.columnModel[gbdsListTableGrid.getColumnIndex('amount')].editable = false;
			gbdsListTableGrid.columnModel[gbdsListTableGrid.getColumnIndex('foreignCurrAmt')].editable = true;
		} else {
			gbdsListTableGrid.columnModel[gbdsListTableGrid.getColumnIndex('amount')].editable = true;
		}
	}

	function getMaxDepNo() {
		var maxDepNo = 0;
		var depNo;
		
		for (var i = 0; i < gbdsListTableGrid.rows.length; i++) {
			depNo = parseInt(nvl(gbdsListTableGrid.rows[i][gbdsListTableGrid.getColumnIndex('depNo')], "0"));
			if (depNo > maxDepNo) {
				maxDepNo = depNo;
			}
		}

		for (var i = 0; i < gbdsListTableGrid.newRowsAdded.length; i++) {
			depNo = parseInt(nvl(gbdsListTableGrid.newRowsAdded[i][gbdsListTableGrid.getColumnIndex('depNo')], "0"));
			if (depNo > maxDepNo) {
				maxDepNo = depNo;
			}
		}

		return (maxDepNo + 1);
	}

	/** end of page functions */
</script>