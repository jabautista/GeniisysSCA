<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>

<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="cashDepositDiv" name="cashDepositDiv" class="sectionDiv" style="width: 770px; margin: 10px; font-size: 11px;">
	<form id="cashDepositForm" name="cashDepositForm" style="margin: 10px;">
		
		<!-- Cash Deposit List -->
		<!-- 
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
				<label>Cash Deposit</label>
			</div>
		</div> -->
		
		<div class="sectionDiv" id="gbds2OuterDiv" style="border-bottom: none;" changeTagAttr="true">
			<!-- GBDS2 -->
			<div id="gbds2ListTableGridSectionDiv" class="sectionDiv" style="height: 180px; border: none" align="center">
				<div id="gbds2ListTableGridDiv" style="padding: 10px; border: none" align="center">
					<div id="gbds2ListTableGrid" style="height: 140px; width: 564px; border: none" align="left"></div>
				</div>
			</div>
			
			<div class="sectionDiv" style="border-left: white; border-right: white; border-bottom: white;" id="cashDepositDiv" style="margin-top: -2px;">
				<table width="800px" align="center" cellspacing="1" border="0">
					<tr>
						<td style="width: 240px">&nbsp</td>
						<td class="rightAligned" style="width: 200px;">Local Currency Amount Total</td>
						<td class="leftAligned">
							<input type="text" id="gbds2DspTotLoc" name="gbds2DspTotLoc" style="width: 120px; text-align: right" readonly="readonly" value=""/>
						</td>
						<td style="width: 200px">&nbsp</td>
					</tr>
					<tr>
						<td style="width: 320px"></td>
						<td class="rightAligned" style="width: 200px;">Foreign Currency Amount Total</td>
						<td class="leftAligned">
							<input type="text" id="gbds2DspTotFor" name="gbds2DspTotFor" style="width: 120px; text-align: right" readonly="readonly" value=""/>
						</td>
						<td style="width: 200px">&nbsp</td>
					</tr>
				</table>
			</div>
		</div>
		
		<div class="sectionDiv" id="gcddOuterDiv" style="border-bottom: none;" changeTagAttr="true">
			<!-- GCDD -->
			<div id="gcddListTableGridSectionDiv" class="sectionDiv" style="height: 140px; border: none" align="center">
				<div id="gcddListTableGridDiv" style="padding: 10px; border: none" align="center">
					<div id="gcddListTableGrid" style="height: 100px; width: 634px; border: none" align="left"></div>
				</div>
			</div>
			
			<div class="sectionDiv" style="border-left: white; border-right: white; border-bottom: white;" id="gcddDetailsDiv" style="margin-top: -2px;">
				<table width="900px" align="center" cellspacing="1" border="0">
					<tr>
						<td style="width: 70px;">&nbsp</td>
						<td class="rightAligned" style="width: 80px;">Remarks</td>
						<td class="leftAligned">
							<div style="border: 1px solid gray; width: 450px; height: 21px; float: left;">
								<input style="width: 400px; float: left; border: none;" id="gcddRemarks" name="gcddRemarks" type="text" value="" maxlength="4000"/>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editGcddRemarks" />
							</div>
						</td>
						<td style="width: 70px;">&nbsp</td>
					</tr>
				</table>
				<table style="margin-left: 106px;">
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 175px;" readonly="readonly" tabindex=""></td>
						<td width="" class="rightAligned" style="padding-left: 10px;">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 175px;" readonly="readonly" tabindex=""></td>
					</tr>	
				</table>
				<table align="center">
					<tr>
						<td class="leftAligned" style="width: 62px"><input type="button" class="button" id="btnCashDepositsReturn" name="btnCashDepositsReturn" value="Return" style="width: 60px;" /></td>
				 	<!-- <td class="rightAligned" style="width: 62px;"><input type="button" class="button" id="btnSaveCashDeposits" name="btnSaveCashDeposits" value="Save" style="width: 60px;" /></td>
					 -->	
					</tr>
				</table>
			</div>
		</div>
	</form>
</div>
<script type="text/JavaScript">
	// Rows
	var selectedGbds2Row	   = null;
	var selectedGcddRow		   = null;

	// Index
	var _selectedGdbdIndex	   = '${selectedGdbdIndex}';
	var selectedGbds2Index     = null;
	var selectedGcddIndex      = null;

	// Block Objects
	var strGcddRows = '${gcddBlockRows}';
	var depId = 0;

	// GBDS2 Table Grid
	var xIndex = null;
	var notEqualTag = 'N';
	
	try {
		var objGbds2 = new Object();
		objGbds2.objGbds2ListTableGrid = JSON.parse('${gbds2ListTableGrid}'.replace(/\\/g, '\\\\'));
		objGbds2.objGbds2List = objGbds2.objGbds2ListTableGrid.rows || [];

		var objGcdd = new Object();
		
		var gbds2TableModel = {
				id : 1,
				url: contextPath+"/GIACBankDepSlipsController?action=refreshCashDepositListing&gaccTranId="+encodeURIComponent(objACGlobal.gaccTranId),
				options:{
					title: '',
					width: '564px',
					onCellFocus: function(element, value, x, y, id){
						var mtgId = gbds2ListTableGrid._mtgId;
						selectedGbds2Index = y;
						xIndex = x;
						if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
							// set selected GBDS2 row
							selectedGbds2Row = gbds2ListTableGrid.geniisysRows[y];
							
							//refreshGcddBlock();
							validateGbds2ShortName(getGbds2Value('currencyShortName'));
						}
						observeChangeTagInTableGrid(gbds2ListTableGrid);
					},
					onRemoveRowFocus: function(element, value, x, y, id) {
						// Added by J. Diago 11.11.2013 - In case hindi kumagat yung validate in validation date column sa table grid.
						var inputId = 'mtgInput' + gbds2ListTableGrid._mtgId + '_11,' + y;
						var value = null;
						if (xIndex == 11){
							if (isDate($(inputId).value)) {
								value = Date.parse($(inputId).value, "mm-dd-yyyy").format('mm-dd-yyyy');
								setGbds2Value2(value, 'validationDt');
							}
						}
						
						
						selectedGbds2Row = null;
						selectedGbds2Index = null;
						validateGbds2ShortName("");
						//refreshGcddBlock();
					},
					onCellBlur: function(element, value, x, y, id){
						observeChangeTagInTableGrid(gbds2ListTableGrid);
					},
					toolbar: {
						elements: [MyTableGrid.ADD_BTN, MyTableGrid.DEL_BTN, MyTableGrid.SAVE_BTN],
						onAdd: function(){
							for (var i = 0; i < gbds2ListTableGrid.newRowsAdded.length; i++) {
								var index = gbds2ListTableGrid.getColumnIndex('depNo');
								selectedGbds2Index = -(i + 1);
								if (String(nvl(gbds2ListTableGrid.newRowsAdded[i][index], "")).blank()) {
									selectedGbds2Row = null;
									selectedGbds2Index = null;
									return false;
								}
							}
							
							selectedGbds2Row = null;
							selectedGbds2Index = null;
							gbds2ListTableGrid.keys.releaseKeys();
						},
						onDelete: function() {
							selectedGbds2Row = null;
							selectedGbds2Index = null;
						},
						onSave: function() {
							if(notEqualTag == "Y"){
								saveGbds2();
							}
							for (var i = 0; i < gbds2ListTableGrid.newRowsAdded.length; i++) {
								/** GBDS2 pre-insert trigger */
								selectedGbds2Index = -(i + 1);
								setGbds2Value(gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('gaccTranId'), _selectedGdbdIndex), 'gaccTranId');
								setGbds2Value(gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('fundCd'), _selectedGdbdIndex), 'fundCd');
								setGbds2Value(gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('branchCd'), _selectedGdbdIndex), 'branchCd');
								setGbds2Value(gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('dcbYear'), _selectedGdbdIndex), 'dcbYear');
								setGbds2Value(gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('dcbNo'), _selectedGdbdIndex), 'dcbNo');
								setGbds2Value(gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('itemNo'), _selectedGdbdIndex), 'itemNo');
								if (nvl(getGbds2Value('depNo'), "").blank()) {
									setGbds2Value(getMaxDepNo(), 'depNo');
								}
								
								checkCashDepositSave();
								// setting of depId moved to Saving

								/** end of GBDS2 pre-insert trigger */
							}
							selectedGbds2Index = null;
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
					{	id: 'checkClass',
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
						id: 'validationDt',
						title: 'Validation Date',
						width: '100px',
						align: 'center',
						titleAlign: 'center',
						type: 'date',
						format: 'mm-dd-yyyy',
						editable: true,
						editableOnAdd: true,
						editor: new MyTableGrid.CellCalendar({
							onClick: function() {
								var coords = gbds2ListTableGrid.getCurrentPosition();
								var inputId = 'mtgInput' + gbds2ListTableGrid._mtgId + '_' + coords[0] + ',' + coords[1];
								$(inputId).focus();
								scwShow($(inputId) ,this, null);
							},
							validate: function(value, input) {
								if (isDate(value)) {
									value = Date.parse(value, "mm-dd-yyyy").format('mm-dd-yyyy');
									//input.value = value;
									setGbds2Value(value, 'validationDt');
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
										+"&block=GBDS2", 
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
						maxlength: 14,
						editor: new MyTableGrid.CellInput({
							validate: function(value, input) {
								setGbds2Value(value, 'amount');
								if (getGbds2Value('currencyShortName') == $F("varDefaultCurrency")) {
									setGbds2Value(value, 'foreignCurrAmt');
								}
								computeGbds2Total();
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
								setGbds2Value(value, 'foreignCurrAmt');
								if (getGbds2Value('currencyShortName') != $F("varDefaultCurrency")) {
									setGbds2Value(roundNumber(parseFloat(value.replace(/,/g,"")) * parseFloat(getGbds2Value('currencyRt')), 2), 'amount');
								}
								computeGbds2Total();
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
				rows: objGbds2.objGbds2List
		};
	
		gbds2ListTableGrid = new MyTableGrid(gbds2TableModel);
		gbds2ListTableGrid.pager = objGbds2.objGbds2ListTableGrid;
		gbds2ListTableGrid.render('gbds2ListTableGrid');

		computeGbds2Total();
	} catch(e){
		showErrorMessage("Cash Deposit", e);
	}

	// GCDD Table Grid
	try {
		var objGcdd = new Object();
		objGcdd.objGcddListTableGrid = JSON.parse('${gcddListTableGrid}'.replace(/\\/g, '\\\\'));
		objGcdd.objGcddList = objGcdd.objGcddListTableGrid.rows || [];
	
		var gcddTableModel = {
				url: contextPath+"/GIACBankDepSlipsController?action=refreshGcddListing&gaccTranId="+encodeURIComponent(objACGlobal.gaccTranId)
					+ "&itemNo=" + ((selectedGbds2Row == null) ? "" : encodeURIComponent(selectedGbds2Row.itemNo)) ,
				options:{
					title: '',
					width: '634px',
					onCellFocus: function(element, value, x, y, id){
						var mtgId = gcddListTableGrid._mtgId;
						selectedGcddRow = null;
						selectedGcddIndex = y;
						if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
							// set selected GCDD row
							selectedGcddRow = gcddListTableGrid.geniisysRows[y];
						}
						$("gcddRemarks").value = getGcddValue('remarks');
						observeChangeTagInTableGrid(gcddListTableGrid);
					},
					onRemoveRowFocus: function(element, value, x, y, id) {
						selectedGcddRow  = null;
						selectedGcddIndex = null;						
						$("gcddRemarks").value = "";
					},
					onCellBlur: function(element, value, x, y, id){
						observeChangeTagInTableGrid(gcddListTableGrid);
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
					{	id: 'currencyCd',
						width: '0px',
						visible: false
					},
					{
						id: 'amount',
						title: 'Collection Amt',
						width: '105px',
						align: 'center',
						titleAlign: 'center',
						editable: true,
						geniisysClass: 'money',
						geniisysErrorMsg: 'Field must be of form 99,999,999,999,990.00.',
						maxlength: 30,
						editor: new MyTableGrid.CellInput({
							validate: function(value, input) {
								if(nvl(getGcddValue('currencyShortName')) == $F("varDefaultCurrency")) {
									setGcddValue(value, 'foreignCurrAmt');
								} else {
									gcddListTableGrid.columnModel[gcddListTableGrid.getColumnIndex('foreignCurrAmt')].editable = true;
								}
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
										+encodeURIComponent((selectedGbds2Index == null) ? "" : getGbds2Value('currencyShortName'))
										+"&block=GCDD", 
										"Select Currency", 560, "");
							},
							validate: function(value, input) {
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
						maxlength: 14,
						editor: new MyTableGrid.CellInput({
							validate: function(value, input) {
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
						geniisysErrorMsg: 'Invalid input.',
						maxlength: 12
					},
					{
						id: 'netDeposit',
						title: 'Deposited Amt',
						width: '105px',
						align: 'right',
						titleAlign: 'center',
						geniisysClass: 'money',
						maxlength: 14,
						editable: true,
						editor: new MyTableGrid.CellInput({
							validate: function(value, input) {
								setGcddValue(parseFloat(nvl(getGcddValue('amount').replace(/,/g,""), "0")) - parseFloat(nvl(value, "0").replace(/,/g,"")),'shortOver');
							}
						})
					},
					{
						id: 'shortOver',
						title: 'Cash Short/Over',
						width: '105px',
						align: 'right',
						titleAlign: 'center',
						geniisysClass: 'money',
						maxlength: 14,
						editable: true
					},
					{	id: 'remarks',
						width: '0px',
						visible: false
					},
					{
						id: 'bookTag',
						title: 'B',
						width: '20px',
						align: 'center',
						titleAlign: 'center',
						editable: true,
						defaultValue: true,
						otherValue: true,
						editor: new MyTableGrid.CellCheckbox({
					        getValueOf: function(value){
				            	if (value){
									return "Y";
				            	}else{
									return "N";	
				            	}	
			            	}
			            })
					}
				],
				resetChangeTag: true,
				rows: objGcdd.objGcddList
		};
	
		gcddListTableGrid = new MyTableGrid(gcddTableModel);
		gcddListTableGrid.pager = objGcdd.objGcddListTableGrid;
		gcddListTableGrid.render('gcddListTableGrid');
	} catch(e){
		showErrorMessage("Cash Deposit", e);
	}

	/** page item triggers */
	
	$("editGcddRemarks").observe("click", function() {
		showEditor("gcddRemarks", 4000);
	});

	$("gcddRemarks").observe("blur", function() {
		if (selectedGcddIndex != null) {
			setGcddValue($F("gcddRemarks"), 'remarks');
		}
	});

	$("btnCashDepositsReturn").observe("click", function() {
		if (gcddListTableGrid.rows.length > 1 && selectedGcddIndex == null) {
			selectedGcddIndex = 0;
		}
		new Ajax.Request(contextPath+"/GIACAccTransController?action=getGcddCollectionAndDeposit", {
			method: "GET",
			asynchronous: false,
			evalScripts: false,
			parameters: {
				gaccTranId: (selectedGcddIndex == null) ? "" : getGcddValue('gaccTranId'),
				fundCd: (selectedGcddIndex == null) ? "" : getGcddValue('fundCd'),
				branchCd: (selectedGcddIndex == null) ? "" : getGcddValue('branchCd'),
				dcbYear: (selectedGcddIndex == null) ? "" : getGcddValue('dcbYear'),
				dcbNo: (selectedGcddIndex == null) ? "" : getGcddValue('dcbNo'),
				itemNo: (selectedGcddIndex == null) ? "" : getGcddValue('itemNo')
			},
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					var result = response.responseText.toQueryParams();
					var gdbdAmount = parseFloat(gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('amount'), _selectedGdbdIndex).replace(/,/g,""));
					if (parseFloat($F("gbds2DspTotLoc").replace(/,/g,"")) != gdbdAmount &&
						parseFloat(result.vDepositDtl) == parseFloat($F("gbds2DspTotLoc").replace(/,/g,"")) &&
						parseFloat(gdbdAmount) ==  parseFloat(result.vCollection)) {
						//Modalbox.hide({executeOnHideFunc: true});
						//acctOverlay.close({executeOnHideFunc: true});
						acctOverlay.close();
					} else if (parseFloat($F("gbds2DspTotLoc").replace(/,/g,"")) == gdbdAmount) {
						//Modalbox.hide({executeOnHideFunc: true});
						//acctOverlay.close({executeOnHideFunc: true});
						acctOverlay.close();
					} else if ($F("gbds2DspTotLoc").blank()) {
						//saveGbds2();
						//Modalbox.hide({executeOnHideFunc: true});
						acctOverlay.close();
					}
				} else {
					showMessageBox("An error has occured: " + response.responseText, imgMessage.ERROR);
				}
			}
		});
		//saveGbds2();
		//Modalbox.hide({executeOnHideFunc: true});
		//acctOverlay.close({executeOnHideFunc: true});
		acctOverlay.close();
		delete acctOverlay;
	});

	/** end of page item triggers */
	
	/** page functions */
	
	function refreshGcddBlock() {
		$("gcddRemarks").value = "";
		
		// change the url of the table model
		gcddListTableGrid.url = contextPath+"/GIACBankDepSlipsController?action=refreshGcddListing&gaccTranId="+encodeURIComponent(objACGlobal.gaccTranId)
			+ "&itemNo=" + ((selectedGbds2Index == null) ? "" : encodeURIComponent(getGbds2Value('itemNo')));

		// refresh
		gcddListTableGrid.refresh();
	}

	/*
	** Gets the value of GBDS2 record in specified column and selected row
	*/
	function getGbds2Value(column) {
		return (selectedGbds2Index == null) ? "" : gbds2ListTableGrid.getValueAt(gbds2ListTableGrid.getColumnIndex(column), selectedGbds2Index);
	}

	/*
	** Sets the value of GBDS2 record in specified column and selected row
	*/
	function setGbds2Value(value, column) {
		if (selectedGbds2Index != null) {
			gbds2ListTableGrid.setValueAt(value, gbds2ListTableGrid.getColumnIndex(column), selectedGbds2Index);
		}
	}
	
	function setGbds2Value2(value, column) {
		gbds2ListTableGrid.setValueAt(value, gbds2ListTableGrid.getColumnIndex(column), selectedGbds2Index);
	}

	/*
	** Gets the value of GCDD record in specified column and selected row
	*/
	function getGcddValue(column) {
		return (selectedGcddIndex == null) ? "" : gcddListTableGrid.getValueAt(gcddListTableGrid.getColumnIndex(column), selectedGcddIndex);
	}

	/*
	** Sets the value of GCDD record in specified column and selected row
	*/
	function setGcddValue(value, column) {
		if(selectedIndex == null || selectedIndex == "") selectedIndex = 0;
		if (selectedGcddIndex != null) {
			gcddListTableGrid.setValueAt(value, gcddListTableGrid.getColumnIndex(column), selectedGcddIndex);
		}
	}
	
	function setGcddValue2(value, column) {
		if(selectedIndex == null || selectedIndex == "") selectedIndex = 0;
		gcddListTableGrid.setValueAt(value, gcddListTableGrid.getColumnIndex(column), 0);
	}

	/* :GBDS2.SHORT_NAME when-validate-item */
	function validateGbds2ShortName(value) {
		$("varDefaultCurrency").value = $F("defaultCurrency");
		
		if (value == "" || value == null) {
			gbds2ListTableGrid.columnModel[gbds2ListTableGrid.getColumnIndex('amount')].editable = true;
			gbds2ListTableGrid.columnModel[gbds2ListTableGrid.getColumnIndex('foreignCurrAmt')].editable = true;
		} else if (value != $F("varDefaultCurrency")) {
			gbds2ListTableGrid.columnModel[gbds2ListTableGrid.getColumnIndex('amount')].editable = false;
			gbds2ListTableGrid.columnModel[gbds2ListTableGrid.getColumnIndex('foreignCurrAmt')].editable = true;
		} else {
			gbds2ListTableGrid.columnModel[gbds2ListTableGrid.getColumnIndex('amount')].editable = true;
		}
	}
	/* end of :GBDS2.SHORT_NAME when-validate-item */
	
	/*
	** Calculate and set local and foreign currency amount total
	*/
	function computeGbds2Total() {
		var totalGbds2LocalCurrAmt   = 0;
		var totalGbds2ForeignCurrAmt = 0;
		var allIsNull = true;
		var lIndex = gbds2ListTableGrid.getColumnIndex('amount');
		var fIndex = gbds2ListTableGrid.getColumnIndex('foreignCurrAmt');
		
		for (var i = 0; i < gbds2ListTableGrid.rows.length; i++) {
			totalGbds2LocalCurrAmt   = totalGbds2LocalCurrAmt   + parseFloat(gbds2ListTableGrid.rows[i][lIndex]);
			totalGbds2ForeignCurrAmt = totalGbds2ForeignCurrAmt + parseFloat(gbds2ListTableGrid.rows[i][fIndex]);

			if (!nvl(gbds2ListTableGrid.rows[i][lIndex], "").blank()) {
				allIsNull = false;
			}
		}

		for (var i = 0; i < gbds2ListTableGrid.newRowsAdded.length; i++) {
			totalGbds2LocalCurrAmt   = totalGbds2LocalCurrAmt   + parseFloat(gbds2ListTableGrid.newRowsAdded[i][lIndex]);
			totalGbds2ForeignCurrAmt = totalGbds2ForeignCurrAmt + parseFloat(gbds2ListTableGrid.newRowsAdded[i][fIndex]);

			if (!nvl(gbds2ListTableGrid.newRowsAdded[i][lIndex], "").blank()) {
				allIsNull = false;
			}
		}

		if (allIsNull) {
			$("gbds2DspTotLoc").value = "";
		} else {
			$("gbds2DspTotLoc").value = formatCurrency(parseFloat(nvl(totalGbds2LocalCurrAmt, "0")));
		}
		
		$("gbds2DspTotFor").value = formatCurrency(parseFloat(nvl(totalGbds2ForeignCurrAmt, "0")));
	}


	function saveGbds2() {
		var ok = true;
	 	var addedRows 	 = gbds2ListTableGrid.getNewRowsAdded();
		var modifiedRows = gbds2ListTableGrid.getModifiedRows();
		var delRows  	 = gbds2ListTableGrid.getDeletedRows();
		var setRows		 = addedRows.concat(modifiedRows);
		 
		var objParameters = new Object();
		objParameters.delRows = delRows;
		objParameters.setRows = addedRows.concat(modifiedRows);

		addedRows = gcddListTableGrid.getNewRowsAdded();
		delRows   = gcddListTableGrid.getDeletedRows();

		objParameters.delGcddRows = delRows;
		objParameters.setGcddRows = addedRows.concat(gcddListTableGrid.getModifiedRows());
		
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
						showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
						xIndex = null;
						notEqualTag = "N";
						return true;
					}
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
					return false;
				}
			}	 
		});
	}

	function getMaxDepNo() {
		var maxDepNo = 0;
		var depNo;
		
		for (var i = 0; i < gbds2ListTableGrid.rows.length; i++) {
			depNo = parseInt(nvl(gbds2ListTableGrid.rows[i][gbds2ListTableGrid.getColumnIndex('depNo')], "0"));
			if (depNo > maxDepNo) {
				maxDepNo = depNo;
			}
		}

		for (var i = 0; i < gbds2ListTableGrid.newRowsAdded.length; i++) {
			depNo = parseInt(nvl(gbds2ListTableGrid.newRowsAdded[i][gbds2ListTableGrid.getColumnIndex('depNo')], "0"));
			if (depNo > maxDepNo) {
				maxDepNo = depNo;
			}
		}

		return (maxDepNo + 1);
	}

	function checkCashDepositSave() {
		try {
			var gbds2DspTotLoc = unformatCurrencyValue($F("gbds2DspTotLoc"));//:gbds2.dsp_tot_loc
			var gdbdAmt = unformatCurrencyValue($F("selectedGdbdAmt"));//:gdbd.amount
			var gbdb2DspTotFor = unformatCurrencyValue($F("gbds2DspTotFor")); //:gbds2.dsp_tot_for
			var gbdbForeignCurrAmt = unformatCurrencyValue($F("selectedGdbdForCurrAmt")); //:gdbd.foreign_curr_amt
			//showMessageBox(gbds2DspTotLoc+"/"+gdbdAmt+"/"+gbdb2DspTotFor+"/"+gbdbForeignCurrAmt);
			var gcddRow = gcddListTableGrid.geniisysRows[0];
			var shortOver = (gdbdAmt - gbds2DspTotLoc);
			
			if(gbds2DspTotLoc != gdbdAmt || gbdb2DspTotFor != gbdbForeignCurrAmt) {
				showMessageBox("Total deposits should be equal to the amount per item_no in Close DCB.", imgMessage.ERROR);
				//assign values to gcdd table grid
				setGcddValue2(gdbdAmt, 'amount');
				setGcddValue2(gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('currencyCd'), _selectedGdbdIndex), 'currencyCd');
				setGcddValue2(gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('dspCurrSname'), _selectedGdbdIndex), 'currencyShortName');
				setGcddValue2(gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('currencyRt'), _selectedGdbdIndex), 'currencyRt');
				setGcddValue2(gbds2DspTotLoc, 'netDeposit');
				setGcddValue2(shortOver, 'shortOver');
				setGcddValue2(gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('foreignCurrAmt'), _selectedGdbdIndex), 'foreignCurrAmt');
				setGcddValue2("Y", 'bookTag');
				setGcddValue2(gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('fundCd'), _selectedGdbdIndex), 'fundCd');
				setGcddValue2(gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('branchCd'), _selectedGdbdIndex), 'branchCd');
				setGcddValue2(gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('dcbYear'), _selectedGdbdIndex), 'dcbYear');
				setGcddValue2(gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('dcbNo'), _selectedGdbdIndex), 'dcbNo');
				notEqualTag = "Y";
				/* if(selectedGbds2Row != null) {
					
					setGcddValue(selectedGbds2Row.amount, 'amount');
					setGcddValue(selectedGbds2Row.currencyCd, 'currencyCd');
					setGcddValue(selectedGbds2Row.currencyShortName, 'currencyShortName');
					setGcddValue(selectedGbds2Row.currencyRt, 'currencyRt');
					setGcddValue(selectedGbds2Row.netDeposit, 'netDeposit');
					setGcddValue(selectedGbds2Row.shortOver, 'shortOver');
					setGcddValue(selectedGbds2Row.foreignCurrAmt, 'foreignCurrAmt');
					
					gcddListTableGrid.modifiedRows.push(selectedGbds2Row);
				} */
			} /* else if (gcddRow == null){ */
			  else if (gcddRow.netDeposit != null && gbds2DspTotLoc != gcddRow.netDeposit){
				var difference = gbds2DspTotLoc - gdbdAmt;
				if(parseInt(difference) == 0) {
					//delete from giac_cash_dep_dtl
					gcddListTableGrid.deletedRows.push(selectedGbds2Row);
					gcddListTableGrid.clear();
					selectedGcddRow = null;
				} else {
					/* setGcddValue(selectedGbds2Row.amount, 'amount');
					setGcddValue(selectedGbds2Row.currencyCd, 'currencyCd');
					setGcddValue(selectedGbds2Row.currencyShortName, 'currencyShortName');
					setGcddValue(selectedGbds2Row.currencyRt, 'currencyRt');
					setGcddValue(selectedGbds2Row.netDeposit, 'netDeposit');
					setGcddValue(selectedGbds2Row.shortOver, 'shortOver');
					setGcddValue(selectedGbds2Row.foreignCurrAmt, 'foreignCurrAmt');

					gcddListTableGrid.modifiedRows.push(selectedGbds2Row); */
					
					setGcddValue2(gdbdAmt, 'amount');
					setGcddValue2(gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('currencyCd'), _selectedGdbdIndex), 'currencyCd');
					setGcddValue2(gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('dspCurrSname'), _selectedGdbdIndex), 'currencyShortName');
					setGcddValue2(gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('currencyRt'), _selectedGdbdIndex), 'currencyRt');
					setGcddValue(gbds2DspTotLoc, 'netDeposit');
					setGcddValue((gdbdAmt - gbds2DspTotLoc), 'shortOver');
					setGcddValue2(gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('foreignCurrAmt'), _selectedGdbdIndex), 'foreignCurrAmt');
					setGcddValue2("Y", 'bookTag');
					setGcddValue2(gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('fundCd'), _selectedGdbdIndex), 'fundCd');
					setGcddValue2(gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('branchCd'), _selectedGdbdIndex), 'branchCd');
					setGcddValue2(gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('dcbYear'), _selectedGdbdIndex), 'dcbYear');
					setGcddValue2(gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('dcbNo'), _selectedGdbdIndex), 'dcbNo');
					notEqualTag = "Y";
				}
			} else {
				saveGbds2();
			}
		} catch(e) {
			showErrorMessage("checkCashDepositSave", e);
		}
	}
	/** end of page functions */
</script>