<!-- 
Remarks: For deletion
Date : 01-02-2012
Developer: andrew robes
Replacement : /pages/accounting/PDCPayment/postDatedCheckDetails.jsp
-->
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<script type="text/javascript">
//if (('${postDatedChecksObjTableGrid}') != ""){
	var postDatedChecksObj = new Object();
	var pdcPremCollnObj = new Object();
	var selectedRow = new Object();
	var selectedRowIndex = "";
	var lastPremSeqNo = "";
	var lastTransactionType = "";
	postDatedChecksObj.pdcDtlsTableGrid = {};//JSON.parse('${postDatedChecksObjTableGrid}'.replace(/\\/g, '\\\\'));
	postDatedChecksObj.pdcDtls = postDatedChecksObj.pdcDtlsTableGrid.rows || [];
	var pdcId = postDatedChecksObj.pdcDtlsTableGrid.pdcId;

	for (var i = 0; i < giacPdcPremCollns.addedRows.length; i++){
		if (giacPdcPremCollns.addedRows[i].pdcId == pdcId){
			postDatedChecksObj.pdcDtls.push(giacPdcPremCollns.addedRows[i]);
			//postDatedCheckDetailsTableGrid.newRowsAdded.push(giacPdcPremCollns.addedRows[i]);
		}
	}
	
	var postDatedCheckDetailsTableModel = {
		url: contextPath+"/GIACAcknowledgmentReceiptsController?action=refreshPostDatedChecksDetailsTable&pdcId="+pdcId,
		options: {
			querySort: false,
			pager: {},
 			toolbar: {
				elements: []
				/*
				onAdd: function (){
					if ($F("statusCd") == "C"){
						showMessageBox('You can not create records here.', imgMessage.ERROR);
						return false;
					} else if ($F("selectedPDCIndex") == ""){
						showMessageBox('Please select a post-dated check.', imgMessage.ERROR);
						return false;
					} else if (!postDatedChecksTableGrid.preCommit()){
						return false;
					} else {
						var currentStatus = postDatedChecksTableGrid.getValueAt(postDatedChecksTableGrid.getColumnIndex('checkStatus'), selectedPDCDtlsIndex);
						if (currentStatus == 'Cancelled' || currentStatus == 'Applied'){
							showMessageBox('You can not create records here.', imgMessage.ERROR);
							return false;
						} else {
							//var exists = false;
							//var modifiedRows = postDatedChecksTableGrid.getModifiedRows();
							//var editedRow = postDatedChecksTableGrid.getRow(selectedPDCDtlsIndex);

							postDatedChecksTableGrid.setValueAt("With Details", postDatedChecksTableGrid.getColumnIndex('checkStatus'), selectedPDCDtlsIndex, true);
							//editedRow.checkStatus = "With Details";
							/*
							for (var x = 0; x < modifiedRows.length; x++){
								if (modifiedRows[x].divCtrId == editedRow.divCtrId){
									modifiedRows.splice(x, 1);
									exists = true;
								}
							}
							if (!exists){
								postDatedChecksTableGrid.modifiedRows.push(editedRow);
							}/
							//setPostDatedCheckAsEdited(editedRow);
							postDatedChecksTableGrid.setValueAt(1,postDatedChecksTableGrid.getColumnIndex('changed'),$F("selectedPDCIndex"),true);

							clearAllPostDatedChecksDtls();
							var defaultTranType = postDatedCheckDetailsTableGrid.columnModel[postDatedCheckDetailsTableGrid.getColumnIndex('tranType')].editor.list[1].value;
							postDatedCheckDetailsTableGrid.columnModel[postDatedCheckDetailsTableGrid.getColumnIndex('tranType')].defaultValue = defaultTranType;
							postDatedCheckDetailsTableGrid.columnModel[postDatedCheckDetailsTableGrid.getColumnIndex('pdcId')].defaultValue = pdcId;

							if (typeof(breakdownDtlsTableGrid) != "undefined"){
								breakdownDtlsTableGrid.addNewRow();
							}

							var row = 'mtgRow'+postDatedChecksTableGrid.getId()+'_'+selectedPDCDtlsIndex;
							$(row).addClassName("selectedRow");
							
						} 
					}
				}*/
			}, 
			
			onCellFocus:  function (element, value, x, y, id){
/* 				if (element.hasClassName("selectedRow")){
					selectedPremCollnIndex = y;
					selectedRow = getSelectedRow(y);

					//selectedRow = postDatedCheckDetailsTableGrid.getRow(y);
					lastPremSeqNo = selectedRow.premSeqNo;
					lastTransactionType = selectedRow.tranType;
					completePostDatedChecksDtls(selectedRow.issCd, selectedRow.premSeqNo);

					$("detailsAssdName").value = postDatedChecksDtlsObj.assdName;
					$("detailsPolEndtNo").value = postDatedChecksDtlsObj.policyNo;

					for (var x = 0; x < $("dtlsFcurrency").length; x++){
						if ($("dtlsFcurrency").options[x].value == postDatedChecksDtlsObj.currencyCd){
							$("dtlsFcurrency").options.selectedIndex = x;
						}
					}

					for (var i = 0; i < tempChkClassObj.currencyListingLOV.length; i++){
						if (tempChkClassObj.currencyListingLOV[i].code == $F("dtlsFcurrency")){
							$("dtlsRate").value = formatToNineDecimal(tempChkClassObj.currencyListingLOV[i].valueFloat);
						}
					}

					$("dtlsAmount").value = formatCurrency(selectedRow.collnAmt * $F("dtlsRate"));
					$("hidFCurrAmount").value = selectedRow.collnAmt * $F("dtlsRate");
					/*
					if (typeof(breakdownDtlsTableGrid) != "undefined"){
						for (var z = 0; z < breakdownDtlsTableGrid.rows.length; z++){
							if (z == y){
								$("mtgRow" + breakdownDtlsTableGrid.getId() + "_" + z).addClassName("selectedRow");
							} else {
								$("mtgRow" + breakdownDtlsTableGrid.getId() + "_" + z).removeClassName("selectedRow");	
							}
						}
					}*/
					//breakdownDtlsTableGrid.focus();

					/*
					if (typeof(breakdownDtlsTableGrid) != "undefined"){
						var row = 'mtgRow'+breakdownDtlsTableGrid.getId()+'_'+y;
						$(row).addClassName("selectedRow");
						for (var i = 0; i < breakdownDtlsTableGrid.rows.length; i++){
							var row = 'mtgRow'+breakdownDtlsTableGrid.getId()+'_'+i;
							if ($(row).hasClassName("selectedRow")){
								if (i != selectedRow.divCtrId){
									$(row).removeClassName("selectedRow");
								} 
							}
						}
					}/
				} */ 
			},

			onCellBlur: function (element, value, x, y, id){
				/* //selectedPDCDtlsIndex = y; 
				if (id == 'premSeqNo'){
					if (value != null && value != "" && pdcPremCollnObj.instNo != null){
						var instNo = pdcPremCollnObj.instNo.toPaddedString(2);
						var collnAmt = pdcPremCollnObj.collnAmt;
						var taxAmt = pdcPremCollnObj.taxAmt;
						var premiumAmt = pdcPremCollnObj.premiumAmt;

						//postDatedCheckDetailsTableGrid.setValueAt(premSeqNo,postDatedCheckDetailsTableGrid.getIndexOf('premSeqNo'),y,true);
						postDatedCheckDetailsTableGrid.setValueAt(instNo,postDatedCheckDetailsTableGrid.getIndexOf('instNo'),y,true);
						postDatedCheckDetailsTableGrid.setValueAt(collnAmt,postDatedCheckDetailsTableGrid.getIndexOf('collnAmt'),y,true);
						postDatedCheckDetailsTableGrid.setValueAt(taxAmt,postDatedCheckDetailsTableGrid.getIndexOf('taxAmt'),y,true);
						postDatedCheckDetailsTableGrid.setValueAt(premiumAmt,postDatedCheckDetailsTableGrid.getIndexOf('premAmt'),y,true);

						//giacPdcPremCollns.addedRows.push(postDatedCheckDetailsTableGrid.getRow(y));
						
						if (typeof(breakdownDtlsTableGrid) != "undefined"){
							breakdownDtlsTableGrid.setValueAt(premiumAmt,breakdownDtlsTableGrid.getIndexOf('premAmt'),y,true);
							breakdownDtlsTableGrid.setValueAt(taxAmt,breakdownDtlsTableGrid.getIndexOf('taxAmt'),y,true);
						}

						var currentRow = postDatedCheckDetailsTableGrid.getRow(y);
						if (currentRow.divCtrId < 0){
							var exist = false;
							if (giacPdcPremCollns.addedRows.length != 0){
								for (var i = 0; i < giacPdcPremCollns.addedRows.length; i++){
									if (currentRow.divCtrId == giacPdcPremCollns.addedRows[i].divCtrId &&
										currentRow.pdcId == giacPdcPremCollns.addedRows[i].pdcId){
										giacPdcPremCollns.addedRows.splice(i, 1);
										exist = true;
									} /* else {
										giacPdcPremCollns.addedRows.push(currentRow);
									}/
								}
							}
							if (!exist){
								giacPdcPremCollns.addedRows.push(currentRow);
							}
						} else {
							currentRow.lastPremSeqNo = lastPremSeqNo;
							currentRow.lastTransactionType = lastTransactionType;
							giacPdcPremCollns.updatedRows.push(currentRow);
						}
					}
				} else if (id == 'collnAmt'){
					setPremAndTaxAmount(value, y);
				} */ 
			},

			onRemoveRowFocus: function (){
				clearAllPostDatedChecksDtls();
				if (typeof(breakdownDtlsTableGrid) != "undefined"){
					var row = 'mtgRow'+breakdownDtlsTableGrid.getId()+'_'+selectedRow.divCtrId;
					$(row).removeClassName("selectedRow");
				}
			},

			onDelete: function(){
				
			}
		},
		columnModel: [
            {
            	id: 'recordStatus', 	
 			    title: '',
 			    width: 23,
 			    sortable: false,
 			    editable: true, 			
 			    editor: 'checkbox' 		
            },
			{
				id: 'divCtrId',
				width: '0',
				visible: false
			},
			{
				id: 'tranType',
				width: 60,
				visible: true,
				maxlength: 1,
				align: 'center',
				title: 'Tran Type',
				editor: new MyTableGrid.SelectBox({
					list: lovListing.transactionTypeLOV
				}),
				editable: true,
				filterOption: true
			},
			{
				id: 'issCd',
				width: 60,
				visible: true,
				maxlength: 2,
				align: 'center',
				title: 'Iss Code',
				editable: true,
				filterOption: true
			},
			{
				id: 'premSeqNo',
				width: 160,
				visible: true,
				maxlength: 12,
				align: 'right',
				renderer: function (value){
					return parseInt(nvl(value, 0)).toPaddedString(12);
				},
				title: 'Bill/CM No.',
				editable: true,
				editor: new MyTableGrid.CellInput({
					validate: function (value, input){
						var issCd = selectedRow.issCd;
						var pdcId = selectedRow.pdcId;
						var tranType = selectedRow.tranType;
						if (validateBill(value, issCd, pdcId, tranType)){
							return !(sameRowExists(pdcPremCollnObj));
						}
					}	
				})
			},
			{
				id: 'instNo',
				width: 100,
				visible: true,
				maxlength: 2,
				align: 'right',
				renderer: function (value){
					return parseInt(nvl(value, 0)).toPaddedString(2);
				},
				title: 'Inst No.'
			},
			{
				id: 'collnAmt',
				width: 110,
				visible: true,
				maxlength: 18,
				title: 'Collection Amt',
				align: 'right',
				geniisysClass: 'money',
				geniisysMinValue: '-999999999999.99',      
		        geniisysMaxValue: '999,999,999,999.99',
		        geniisysErrorMsg: 'Entered amount is invalid. Valid value is from -999,999,999,999.99 to 999,999,999,999.99.',
		        editable: true,
		        filterOption: true
			},
			{
				id: 'premAmt',
				width: "0",
				visible: false
			},
			{
				id: 'taxAmt',
				width: "0",
				visible: false
			},
			{
				id: 'currCd',
				width: "0",
				visible: false
			},
			{
				id: 'currRt',
				width: "0",
				visible: false
			},
			{
				id: 'fCurrAmt',
				width: "0",
				visible: false
			},
			{
				id: 'pdcId',
				width: '0',
				visible: false
			}
		],
		requiredColumns: 'issCd premSeqNo collnAmt',
		rows: []//postDatedChecksObj.pdcDtls
	};

	postDatedCheckDetailsTableGrid = new MyTableGrid(postDatedCheckDetailsTableModel);
	postDatedCheckDetailsTableGrid.pager = postDatedChecksObj.pdcDtlsTableGrid;
	postDatedCheckDetailsTableGrid.render('postDatedChecksDtlsTable');

	setEditables();
//}

function getSelectedRow(divCtrId){
	var selectedRow = new Object();

	/*
	var propertyArray = ['recordStatus', 'divCtrId', 'tranType', 'issCd', 'premSeqNo', 'instNo',
	                 	 'collnAmt', 'premAmt', 'taxAmt', 'currCd', 'currRt', 'fCurrAmt', 'pdcId'];
	for (var prop = 0; prop < propertyArray.length; prop++){
		var property = propertyArray[prop];
		selectedRow[property] = postDatedCheckDetailsTableGrid.rows[divCtrId][postDatedCheckDetailsTableGrid.getColumnIndex(property)];
	}*/
	var added = giacPdcPremCollns.addedRows;
	if (divCtrId < 0){
		if (added.length > 0){
			var exist = false;
			var pdcId = postDatedChecksTableGrid.getValueAt(postDatedChecksTableGrid.getColumnIndex('pdcId'), selectedPDCDtlsIndex);
			for (var i = 0; i < added.length; i++){
				if (added[i].divCtrId == divCtrId && added[i].pdcId == pdcId){
					selectedRow = added[i];
					exist = true;
				}
			}
			if (!exist){
				selectedRow = postDatedCheckDetailsTableGrid.getRow(divCtrId);
			}
		} else {
			selectedRow = postDatedCheckDetailsTableGrid.getRow(divCtrId);
		}
	} else {
		selectedRow = postDatedCheckDetailsTableGrid.getRow(divCtrId);
	}

	return selectedRow;
}

function sameRowExists(pdcPremCollnObj){
	var exists = false;
	var savedTableGridRows = postDatedChecksObj.pdcDtlsTableGrid.rows;

	var currentTableGridRows = savedTableGridRows.concat(postDatedCheckDetailsTableGrid.getNewRowsAdded());

	for (var ctr = 0; ctr < currentTableGridRows.length; ctr++){
		var compObj = currentTableGridRows[ctr];

		if (compObj.tranType == selectedRow.tranType &&
			compObj.issCd == pdcPremCollnObj.issCd &&
			parseInt(compObj.premSeqNo) == pdcPremCollnObj.premSeqNo &&
			parseInt(compObj.instNo) == pdcPremCollnObj.instNo &&
			compObj.divCtrId != selectedRow.divCtrId){
			showMessageBox('Row already exists with the same Transaction Type, Issuing Source, Bill No. and Installment No.', imgMessage.ERROR);
			exists = true;
		}
	}

	return exists;
}

function setEditables(){
	if ($F("selectedPDCIndex") != ""){
		var checkStat = postDatedChecksTableGrid.getValueAt(postDatedChecksTableGrid.getColumnIndex('checkStatus'), $F("selectedPDCIndex"));

		if ((checkStat != 'New' && checkStat != 'With Details') || $F("statusCd") == "C"){
			//postDatedChecksTableModel.columnModel[postDatedChecksTableGrid.getColumnIndex('bankBranch')].editable = false;
			postDatedCheckDetailsTableModel.columnModel[postDatedCheckDetailsTableGrid.getColumnIndex('tranType')].editable = false;
			postDatedCheckDetailsTableModel.columnModel[postDatedCheckDetailsTableGrid.getColumnIndex('issCd')].editable = false;
			postDatedCheckDetailsTableModel.columnModel[postDatedCheckDetailsTableGrid.getColumnIndex('premSeqNo')].editable = false;
			postDatedCheckDetailsTableModel.columnModel[postDatedCheckDetailsTableGrid.getColumnIndex('collnAmt')].editable = false;
		}
	}
}

function clearAllPostDatedChecksDtls(){
	selectedPremCollnIndex = "";
	$("detailsAssdName").value = "";
	$("detailsPolEndtNo").value = "";
}

function validateBill(value, issCd, pdcId, tranType){
	var valuesObj = new Object();
	var isValid = true;

	if (isNaN(value) || value == ""){
		showMessageBox('Invalid input.', imgMessage.ERROR);
		isValid = false;
	} else {
		new Ajax.Request(contextPath+"/GIACAcknowledgmentReceiptsController?action=validatePremSeqNo", {
			method: "POST",
			parameters: {
				issCd: issCd,
				premSeqNo: value,
				pdcId: pdcId,
				tranType: tranType
			},
			evalScripts: true,
			asynchronous: false,
			onCreate: function (){
	
			},
			onSuccess: function (response){
				if (checkErrorOnResponse(response)){
					valuesObj = JSON.parse(response.responseText);

					if (valuesObj.message != 'Valid'){
						isValid = false;
						showMessageBox(valuesObj.message, imgMessage.ERROR);
					} else if(valuesObj.instNoCount > 1){
						showInstListModal(1, issCd, value);
					} else {
						pdcPremCollnObj = valuesObj;
					}
				}
			}
		});
	}

	return isValid;
}

function setPremAndTaxAmount(collnAmt, y){
	var premiumAmount = postDatedCheckDetailsTableGrid.getValueAt(postDatedCheckDetailsTableGrid.getColumnIndex('premAmt'), y);
	var taxAmount = postDatedCheckDetailsTableGrid.getValueAt(postDatedCheckDetailsTableGrid.getColumnIndex('taxAmt'), y);
	var taxRate;
	var newPremAmt;
	var newTaxAmt;

	taxRate = parseFloat(taxAmount) / parseFloat(selectedRow.collnAmt);
	newTaxAmt = parseFloat(collnAmt) * taxRate;
	newPremAmt = formatCurrency(parseFloat(collnAmt) - parseFloat(newTaxAmt));

	if (typeof(breakdownDtlsTableGrid) != "undefined"){
		breakdownDtlsTableGrid.setValueAt(formatCurrency(newPremAmt),breakdownDtlsTableGrid.getIndexOf('premAmt'),y,true);
		breakdownDtlsTableGrid.setValueAt(formatCurrency(newTaxAmt),breakdownDtlsTableGrid.getIndexOf('taxAmt'),y,true);
	}

}

$("dtlsFcurrency").observe("change", function (){
	var code = $F("dtlsFcurrency");
	for (var i = 0; i < tempChkClassObj.currencyListingLOV.length; i++){
		if (tempChkClassObj.currencyListingLOV[i].code == code){
			$("dtlsRate").value = formatToNineDecimal(tempChkClassObj.currencyListingLOV[i].valueFloat);
			//$("dtlsAmount").value = formatCurrency($F("hidFCurrAmount") * unformatCurrency("dtlsRate"));
		}
	}

	postDatedCheckDetailsTableGrid.setValueAt(code,postDatedCheckDetailsTableGrid.getIndexOf('currCd'),selectedPDCDtlsIndex,true);
	postDatedCheckDetailsTableGrid.setValueAt(unformatCurrency("dtlsRate"),postDatedCheckDetailsTableGrid.getIndexOf('currRt'),selectedPDCDtlsIndex,true);
	postDatedCheckDetailsTableGrid.setValueAt(unformatCurrency("dtlsAmount"),postDatedCheckDetailsTableGrid.getIndexOf('fCurrAmt'),selectedPDCDtlsIndex,true);
});

$("btnForeignCurrency").observe("click", function (){
	$("btnBackToDtls").setStyle("margin-top: 50px;");
	$("btnBackToDtls").show();
	$("assuredDtlsContentDiv").hide();
	$("otherDtlsOtherContentsDiv").show();
	$("fcurrencyDtlsContentDiv").show();
	$("breakdownDtlsContentDiv").hide();

	if (postDatedChecksDtlsObj != null){
		for (var x = 0; x < $("dtlsFcurrency").length; x++){
			if ($("dtlsFcurrency").options[x].value == postDatedChecksDtlsObj.currencyCd){
				$("dtlsFcurrency").options.selectedIndex = x;
			}
		}
	}

	for (var i = 0; i < tempChkClassObj.currencyListingLOV.length; i++){
		if (tempChkClassObj.currencyListingLOV[i].code == $F("dtlsFcurrency")){
			$("dtlsRate").value = formatToNineDecimal(tempChkClassObj.currencyListingLOV[i].valueFloat);
		}
	}

	if (selectedPremCollnIndex != ""){
		var collectionAmount = postDatedCheckDetailsTableGrid.getValueAt(postDatedCheckDetailsTableGrid.getColumnIndex("collnAmt"), selectedPremCollnIndex);
		var foreignCurrencyRt = unformatCurrency("foreignCurrencyRt");
		var dtlsAmountValue = parseFloat(collectionAmount) / parseFloat(foreignCurrencyRt);
		//$("dtlsAmount").value = formatCurrency($F("hidFCurrAmount") * unformatCurrency("dtlsRate"));
		$("dtlsAmount").value = formatCurrency(dtlsAmountValue);
	}
});
</script>