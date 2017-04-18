<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="replacePDCMainDiv" style="font-size: 11px;" tabindex="1">
	<input type="hidden" id="pdcId" name="pdcId" value="${pdcId}" />
	<input type="hidden" id="itemNo" name="itemNo" value="${itemNo}" />
	<div id="replacePDCHdrDiv" name="replacePDCHdrDiv" style="float: left;" class="sectionDiv">
		<table align="center" border="0" style="width: 98%;">
			<tr>
				<td class="leftAligned" style="width: 15%;">Bank</td>
				<td class="rightAligned" style="width: 25%;">Check Number</td>
				<td class="rightAligned" style="width: 20%;">Amount</td>
				<td style="width: 15%;"></td>
				<td class="leftAligned" style="width: 20%;">Replace Date</td>
			</tr>
			<tr>
				<td class="leftAligned" style="width: 15%;"><input id="repPdcBank" name="repPdcBank" type="text" style="width: 95%;" disabled="disabled" value="${bank}"/></td>
				<td class="rightAligned" style="width: 25%;"><input id="repPdcCheckNo" name="repPdcCheckNo" type="text" style="width: 95%; text-align: right;" disabled="disabled" value="${checkNo}"/></td>
				<td class="rightAligned" style="width: 20%;"><input id="repPdcAmount" name="repPdcAmount" type="text" style="width: 95%; text-align: right;" disabled="disabled" value="<fmt:formatNumber pattern="#,###,##0.00" value="${amount}" />"/></td>
				<td style="width: 15%;"></td>
				<td class="leftAligned" style="width: 20%;"><input id="repPdcRepDate" name="repPdcRepDate" type="text" style="width: 95%;" disabled="disabled" value="${replaceDate}"/></td>
			</tr>
		</table>
	</div>
	<div id="gpdcRepTableDiv" name="gpdcRepTableDiv" class="sectionDiv" style="float: left; height: 220px; border: none;">
		<div id="gpdcRepTableGrid" name="gpdcRepTableGrid" style="float: left; position: relative; width: 784px; height: 200px;">
		
		</div>
	</div>
	<div id="repBtnsDiv" name="repBtnsDiv" class="sectionDiv" style="height: 50px; float: left;">
		<label style="float: left; margin-top: 17px; margin-left: 464px;">Net Total : </label>
		<input type="text" style="float: left; margin-top: 15px; margin-left: 8px; text-align: right;" readonly="readonly" id="replaceNetTotal" name="replaceNetTotal" /> 
	</div>
	<div class="sectionDiv">
		<div id="miscAmtsDiv" name="miscAmtsDiv">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
			   		<label>Miscellaneous Amount</label>
			   		<span class="refreshers" style="margin-top: 0;">
			   			<label id="showMiscAmt" name="gro" style="margin-left: 5px;">Hide</label>
			   		</span>
			   	</div>
			</div>	
			<div id="miscAmtsDtlsDiv" class="sectionDiv" style="height: 50px; width: 100%; float: left;">
				<label style="float: left; margin-left: 23px; margin-top: 13px;">Gross Amount</label><input type="text" id="repMiscGrossAmt" name="repMiscGrossAmt" class="money required" style="float: left; margin-left: 4px; margin-top: 10px; width: 140px;" />
				<label style="float: left; margin-left: 16px; margin-top: 13px;">Comm. Amount</label><input type="text" id="repMiscCommAmt" name="repMiscCommAmt" class="money required" style="float: left; margin-left: 4px; margin-top: 10px; width: 140px;" />
				<label style="float: left; margin-left: 26px; margin-top: 13px;">VAT Amount</label><input type="text" id="repMiscVatAmt" name="repMiscVatAmt" class="money required" style="float: left; margin-left: 4px; margin-top: 10px; width: 140px;"/>
			</div>
		</div>
	</div>
	<div id="sectionDiv" style="height: 50px; float: left; width: 100%;">
		<input type="button" class="button" style="margin-top: 15px; margin-left: 280px; width: 120px; float: left;" id="btnReplaceOk" name="btnReplaceOk" value="OK" />
		<input type="button" class="button" style="margin-top: 15px; margin-left: 1px; width: 120px; float: left;" id="btnReplaceCancel" name="btnReplaceCancel" value="Cancel" />
	</div>
</div>
<script><!--
	$("replacePDCMainDiv").focus();
	$("replacePDCMainDiv").observe("keypress", function (evt){
		if (evt.keyCode == Event.KEY_DOWN ||
		    evt.keyCode == Event.KEY_UP ||
		    evt.keyCode == Event.KEY_LEFT ||
		    evt.keyCode == Event.KEY_RIGHT){
			Event.stop(evt);
		}
	});

	var checkStatus = objCurrGIACApdcPaytDtl.checkStatus; //postDatedChecksTableGrid.getValueAt(postDatedChecksTableGrid.getColumnIndex('checkStatus'), selectedPDCDtlsIndex);
	var updateAllowed = true;
	var selectedPdcRepIndex = "";
	if (checkStatus != 'New' && checkStatus != 'With Details'){
		showMessageBox('You can not update this record.');
		$("repMiscGrossAmt").disable();
		$("repMiscCommAmt").disable();
		$("repMiscVatAmt").disable();
		updateAllowed = false;
	}
	
	var pdcRepDtlsObj = new Object();

	//$("repPdcRepDate").value = $F("repPdcRepDate") == "null" ? "" : dateFormat($F("repPdcRepDate"), "dd-mmm-yyyy");
	
	getPdcReplaceDtls($F("pdcId"), $F("itemNo"));
	
	function getPdcReplaceDtls(pdcId, itemNo){
		new Ajax.Request(contextPath+"/GIACAcknowledgmentReceiptsController?action=getPdcRepDtls", {
			method: "POST",
			parameters: {
				pdcId: pdcId,
				itemNo: itemNo
			},
			evalScripts: true,
			asynchronous: false,
			onCreate: function (){
				showNotice("Loading PDC replace details. Please wait...");
			},
			onSuccess: function (response){
				hideNotice("");
				if (checkErrorOnResponse(response)){
					pdcRepDtlsObj = JSON.parse(response.responseText);
					for (var i = 0; i < pdcReplaceObjectList.length; i++){
						if (pdcRepDtlsObj.pdcId == pdcReplaceObjectList[i].pdcId){
							var newTableGridRows = pdcRepDtlsObj.rows.concat(pdcReplaceObjectList[i].rows);
							pdcRepDtlsObj.rows = newTableGridRows;
						}
					}
					
					createReplaceTableGrid(pdcRepDtlsObj);
				}
			}
		});
	}

	$("btnReplaceCancel").observe("click", function (){
		Modalbox.hide();
	});

	$("btnReplaceOk").observe("click", function (){
		if (checkStatus != 'New' && checkStatus != 'With Details'){
			showMessageBox('You can not update this record.');
			return false;
		} else if (unformatCurrency("replaceNetTotal") != unformatCurrency("repPdcAmount")){
			showMessageBox('Total amount should be equal to the check amount of the PDC.', imgMessage.ERROR);
			return false;
		} else {
			showConfirmBox("Replace Check", "Please confirm replacement of check. Continue?",
						   "Yes", "No",
						   replaceCheck,
						   "");
		}
	});

	function replaceCheck(){
		var selectedPdcIndex = $F("selectedPDCIndex");
		//var exists = false;
		//var editedRow = postDatedChecksTableGrid.getRow(selectedPdcIndex);
		//var modifiedRows = postDatedChecksTableGrid.getModifiedRows();
		var replaceDate = dateFormat(new Date(), "ddd mmm dd h:MM:ss Z yyyy");
		
		replacePDC();
		postDatedChecksTableGrid.setValueAt('Replaced',postDatedChecksTableGrid.getColumnIndex('checkStatus'), selectedPdcIndex, true);
		//editedRow.checkStatus = "Replaced";
		//postDatedChecksTableGrid.setValueAt(replaceDate, postDatedChecksTableGrid.getColumnIndex('replaceDate'), selectedPDCDtlsIndex, true);
		//editedRow.replaceDate = replaceDate;
		/*
		for (var x = 0; x < modifiedRows.length; x++){
			if (modifiedRows[x].divCtrId == editedRow.divCtrId){
				modifiedRows.splice(x, 1);
				exists = true;
			}
		}
		if (!exists){
			postDatedChecksTableGrid.modifiedRows.push(editedRow);
		}*/
		//setPostDatedCheckAsEdited(editedRow);
		postDatedChecksTableGrid.setValueAt(1,postDatedChecksTableGrid.getColumnIndex('changed'),$F("selectedPDCIndex"),true);
		
		showMessageBox('PDC replaced successfully.', imgMessage.SUCCESS);
		Modalbox.hide();
	}

	function replacePDC(){
		var replaceObject = new Object();
		var replaceRows = repPdcTableGrid.getNewRowsAdded();
		replaceObject.pdcId = objCurrGIACApdcPaytDtl.pdcId; //postDatedChecksTableGrid.getRow(selectedPDCDtlsIndex).pdcId;
		replaceObject.rows = replaceRows;
		pdcReplaceObjectList.push(replaceObject);
	}

	function createReplaceTableGrid(tableGridObj){
		//var newItemNo = tableGridObj.length == 0 ? 0 : parseInt(tableGridObj.rows[tableGridObj.rows.length - 1].itemNo);
		var itemNo = 0;
		var replacePdcTableModel = {
			url: contextPath+"/GIACAcknowledgmentReceiptsController?action=refreshReplacePdcTable&pdcId="+$F("pdcId")+"&itemNo="+$F("itemNo"),
			options: {
				querySort: false,
				toolbar: {
					elements: [MyTableGrid.ADD_BTN, MyTableGrid.FILTER_BTN],

					onAdd: function (){
						if (!updateAllowed){
							showMessageBox('You cannot create records here.', imgMessage.ERROR);
							return false;
						} else {
							//postDatedChecksTableGrid.columnModel[postDatedChecksTableGrid.getColumnIndex('bankCd')].editor.list[1].value;
							itemNo++;
							var defaultPayMode = repPdcTableGrid.columnModel[repPdcTableGrid.getColumnIndex('payMode')].editor.list[1].value;
							var defaultBankCd = repPdcTableGrid.columnModel[repPdcTableGrid.getColumnIndex('bankCd')].editor.list[1].value;
							var defaultCheckClass = repPdcTableGrid.columnModel[repPdcTableGrid.getColumnIndex('checkClass')].editor.list[1].value;
							var defaultCurrencyCd = repPdcTableGrid.columnModel[repPdcTableGrid.getColumnIndex('currencyCd')].editor.list[1].value;
							repPdcTableGrid.columnModel[repPdcTableGrid.getColumnIndex('itemNo')].defaultValue = itemNo; 
							repPdcTableGrid.columnModel[repPdcTableGrid.getColumnIndex('payMode')].defaultValue = defaultPayMode; 
							repPdcTableGrid.columnModel[repPdcTableGrid.getColumnIndex('bankCd')].defaultValue = defaultBankCd; 
							repPdcTableGrid.columnModel[repPdcTableGrid.getColumnIndex('checkClass')].defaultValue = defaultCheckClass; 
							repPdcTableGrid.columnModel[repPdcTableGrid.getColumnIndex('currencyCd')].defaultValue = defaultCurrencyCd; 
						}
					}
				},
				
				onCellFocus: function (element, value, x, y, id){
					selectedPdcRepIndex = y;
					$("repMiscGrossAmt").value = formatCurrency(repPdcTableGrid.getValueAt(repPdcTableGrid.getColumnIndex('grossAmt'), y));
					$("repMiscCommAmt").value  = formatCurrency(repPdcTableGrid.getValueAt(repPdcTableGrid.getColumnIndex('commissionAmt'), y));
					$("repMiscVatAmt").value   = formatCurrency(repPdcTableGrid.getValueAt(repPdcTableGrid.getColumnIndex('vatAmt'), y));
				},

				onCellBlur: function (element, value, x, y, id){
					if (id == 'amount'){
						//var total = unformatCurrency("replaceNetTotal") + parseFloat(value);
						//$("replaceNetTotal").value = formatCurrency(total);
						var total = 0.00;
						var addedRows = repPdcTableGrid.getNewRowsAdded();
						for (var i = 0; i < addedRows.length; i++){
							total = total + parseFloat(addedRows[i].amount);
						}
						$("replaceNetTotal").value = formatCurrency(total);
					}
				},

				onRemoveRowFocus: function (element, value, x, y, id){
					selectedPdcRepIndex = "";
				}
			},
			columnModel: [
				{
					id: 'recordStatus', 	
				    title: '',
				    width: 23,
				    sortable: false,
				    editableOnAdd: true, 			
				    editor: 'checkbox' 		
				},
				{
					id: 'divCtrId',
					width: '0',
					visible: false
				},
			    {
					id: 'itemNo',
					width: 50,
					visible: true,
					title: 'Item',
					editable: false
			    },
			    {
					id: 'payMode',
					width: 60,
					visible: true,
					title: 'Pay Mode',
					editableOnAdd: true,
					editor: new MyTableGrid.SelectBox({
						list: lovListing.paymentModeLOV
					}),
					filterOption: true
			    },
			    {
					id: 'bankCd',
					width: 100,
					visible: true,
					title: 'Bank',
					editableOnAdd: true,
					editor: new MyTableGrid.SelectBox({
						list: lovListing.bankListingLOV
					}),
					filterOption: true
			    },
			    {
					id: 'checkClass',
					width: 120,
					visible: true,
					title: 'Check Class',
					editableOnAdd: true,
					editor: new MyTableGrid.SelectBox({
						list: lovListing.checkClassLOV
					}),
					filterOption: true
			    },
			    {
			    	id: 'checkNo',
					width: 85,
					visible: true,
					title: 'Chk/Crdt Card No.',
					editableOnAdd: true
			    },
			    {
			    	id: 'checkDate',
					width: 85,
					visible: true,
					title: 'Check Date',
					editableOnAdd: true,
					editor: new MyTableGrid.CellCalendar({
						validate: function (value, input){
							return true;
						}
					}),
					type: 'date',
					filterOption: true
			    },
				{
			    	id: 'amount',
					width: 120,
					visible: true,
					title: 'Local Currency Amount',
					editableOnAdd: true,
					align: 'right',
					geniisysClass: 'money',
					geniisysMinValue: '-999999999999.99',      
			        geniisysMaxValue: '999,999,999,999.99',
			        geniisysErrorMsg: 'Entered amount is invalid. Valid value is from -999,999,999,999.99 to 999,999,999,999.99.',
			        filterOption: true
				},
				{
					id: 'currencyCd',
					width: 85,
					visible: true,
					title: 'Currency',
					editableOnAdd: true,
					editor: new MyTableGrid.SelectBox({
						list: lovListing.currencyListingLOV
					}),
					filterOption: true
				},
				{
					id: 'refNo',
					width: 98,
					visible: true,
					title: 'OR No./APDC No.',
					editableOnAdd: true,
					filterOption: true
				},
				{
					id: 'grossAmt',
					width: '0',
					visible: false
				},
				{
					id: 'commissionAmt',
					width: '0',
					visible: false
				},
				{
					id: 'vatAmt',
					width: '0',
					visible: false
				}	
			],
			requiredColumns: '',
			rows: tableGridObj.rows || []
		};

		repPdcTableGrid = new MyTableGrid(replacePdcTableModel);
		repPdcTableGrid.pager = tableGridObj;
		repPdcTableGrid.render('gpdcRepTableGrid');

		var netAmount = 0.00;
		for (var i=0; i<tableGridObj.rows.length; i++){
			netAmount = netAmount + parseFloat(tableGridObj.rows[i].amount);
		}
		$("replaceNetTotal").value = formatCurrency(netAmount);
	}

	$("repMiscGrossAmt").observe("blur", function (){
		if (selectedPdcRepIndex == ""){
			showMessageBox("Please select an item.", imgMessage.ERROR);
			return false;
		} else {
			var repNetAmount = repPdcTableGrid.getValueAt(repPdcTableGrid.getColumnIndex('amount'), selectedPdcRepIndex);
			if ($F("repMiscGrossAmt") != ""){
				var repGrossAmt = unformatCurrency("repMiscGrossAmt");
				if (repGrossAmt < 0 || isNaN(repGrossAmt) || repGrossAmt > 999999999999.99){
					showMessageBox("Entered value is invalid. Gross amount should be from 0 to 999,999,999,999.99", imgMessage.ERROR);
					return false;
				} else if (repGrossAmt < repNetAmount){
					showMessageBox("Gross amount should be larger than net amount.", imgMessage.ERROR);
					return false;
				} else {
					var checkAmount = computeReplaceAmount();

					repPdcTableGrid.setValueAt(checkAmount, repPdcTableGrid.getColumnIndex('amount'), selectedPdcRepIndex, true);
					repPdcTableGrid.setValueAt(repGrossAmt, repPdcTableGrid.getColumnIndex('grossAmt'), selectedPdcRepIndex, true);
					
					$("repMiscGrossAmt").value = formatCurrency(repGrossAmt);
				}
			}
		}
	});

	$("repMiscCommAmt").observe("blur", function (){
		if (selectedPdcRepIndex == ""){
			showMessageBox("Please select an item.", imgMessage.ERROR);
			return false;
		} else {
			var repNetAmount = repPdcTableGrid.getValueAt(repPdcTableGrid.getColumnIndex('amount'), selectedPdcRepIndex);
			var repCommAmt = unformatCurrency("repMiscCommAmt");
			var repGrossAmt = unformatCurrency("repMiscGrossAmt");
			if ($F("repMiscCommAmt") != ""){
				if (repCommAmt < 0 || isNaN(repCommAmt) || repCommAmt > 999999999999.99){
					showMessageBox("Entered value is invalid. Gross amount should be from 0 to 999,999,999,999.99", imgMessage.ERROR);
					return false;
				} else if (repCommAmt > repGrossAmt){
					showMessageBox("Commission amount should not be larger than Gross amount.", imgMessage.ERROR);
					return false;
				} else {
					var checkAmount = computeReplaceAmount();

					repPdcTableGrid.setValueAt(checkAmount, repPdcTableGrid.getColumnIndex('amount'), selectedPdcRepIndex, true);
					repPdcTableGrid.setValueAt(repCommAmt, repPdcTableGrid.getColumnIndex('commissionAmt'), selectedPdcRepIndex, true);
					
					$("repMiscCommAmt").value = formatCurrency(repCommAmt);
				}
			}
		}
	});

	$("repMiscVatAmt").observe("blur", function (){
		if (selectedPdcRepIndex == ""){
			showMessageBox("Please select an item.", imgMessage.ERROR);
			return false;
		} else {
			var repNetAmount = repPdcTableGrid.getValueAt(repPdcTableGrid.getColumnIndex('amount'), selectedPdcRepIndex);
			var repVatAmt = unformatCurrency("repMiscVatAmt");
			var repCommAmt = unformatCurrency("repMiscCommAmt");
			if ($F("repMiscVatAmt") != ""){
				if (repVatAmt < 0 || isNaN(repVatAmt) || repVatAmt > 999999999999.99){
					showMessageBox("Entered value is invalid. Gross amount should be from 0 to 999,999,999,999.99", imgMessage.ERROR);
					return false;
				} else if (repVatAmt > repCommAmt){
					showMessageBox("Vat amount should not be larger than Commission amount.", imgMessage.ERROR);
					return false;
				} else {
					var checkAmount = computeReplaceAmount();

					repPdcTableGrid.setValueAt(checkAmount, repPdcTableGrid.getColumnIndex('amount'), selectedPdcRepIndex, true);
					repPdcTableGrid.setValueAt(repVatAmt, repPdcTableGrid.getColumnIndex('vatAmt'), selectedPdcRepIndex, true);
					
					$("repMiscVatAmt").value = formatCurrency(repVatAmt);
				}
			}
		}
	});

	function computeReplaceAmount(){
		var checkAmt = 0.00;
		checkAmt = unformatCurrency("repMiscGrossAmt") - nvl(unformatCurrency("repMiscCommAmt"), 0) - nvl(unformatCurrency("repMiscVatAmt"), 0);

		return checkAmt;
	}
</script>