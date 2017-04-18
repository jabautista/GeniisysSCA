<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="otcDiv" name="otcDiv" class="sectionDiv" style="width: 94%; margin: 3px; font-size: 11px;">
	<form id="otcForm" name="otcForm" style="margin: 10px;">
		<!-- OTC List -->
		
		<div class="sectionDiv" id="otcOuterDiv" style="border-bottom: none;" changeTagAttr="true">
			<!-- OTC -->
			<div id="otcListTableGridSectionDiv" class="sectionDiv" style="height: 140px; border: none" align="center">
				<div id="otcListTableGridDiv" style="padding: 10px; border: none" align="center">
					<div id="otcListTableGrid" style="height: 100px; width: 624px; border: none" align="left"></div>
				</div>
			</div>
			
			<div class="sectionDiv" style="border-left: white; border-right: white; border-bottom: white;" id="otcDetailsDiv" style="margin-top: -2px;">
				<table align="center">
					<tr>
						<td class="leftAligned"  style="width: 62px"><input type="button" class="button" id="btnOtcReturn" name="btnOtcReturn" value="Return" style="width: 60px;" /></td>
					</tr>
				</table>
			</div>
		</div>
	</form>
</div>
<script type="text/JavaScript">
	var selectedOtcIndex   = null;

	var selectedOtcRow	   = null;
	var itemNo			   = '${itemNo }';
	var dcbNo			   = '${dcbNo }';
	var depId		   	   = '${depId }';
	
	// OTC Table Grid
	
	try {
		var objOtc = new Object();
		objOtc.objOtcListTableGrid = JSON.parse('${otcListTableGrid}'.replace(/\\/g, '\\\\'));
		objOtc.objOtcList = objOtc.objOtcListTableGrid.rows || [];
	
		var otcTableModel = {
				url: contextPath+"/GIACAccTransController?action=refreshOtcListing&gaccTranId="+encodeURIComponent(objACGlobal.gaccTranId),
				options:{
					title: '',
					width: '624px',
					onCellFocus: function(element, value, x, y, id){
						var mtgId = otcListTableGrid._mtgId;
						selectedOtcIndex = y;
						if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
							// set selected OTC row
							selectedOtcRow = otcListTableGrid.geniisysRows[y];
						}
						observeChangeTagInTableGrid(otcListTableGrid);
					},
					onRemoveRowFocus: function(element, value, x, y, id) {
						selectedOtcIndex = null;
					},
					onCellBlur: function(element, value, x, y, id){
						selectedOtcRow = null;
						observeChangeTagInTableGrid(otcListTableGrid);
					},
					onRowDoubleClick: function(y){
						// none
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
						id: 'checkNo',
						title: 'Check No',
						width: '110px',
						align: 'center',
						titleAlign: 'center'
					},
					{
						id: 'currencyShortName',
						title: 'Currency',
						width: '80px',
						align: 'center',
						titleAlign: 'center'
					},
					{
						id: 'currencyRt',
						title: 'Currency Rate',
						width: '100px',
						align: 'center',
						titleAlign: 'right',
						geniisysClass: 'integerNoNegativeUnformattedNoComma'
					},
					{
						id: 'amount',
						title: 'Local Currency Amt',
						width: '105px',
						align: 'right',
						geniisysClass: 'money',
						geniisysErrorMsg: 'Field must be of form 99,999,999,999,990.00.',
						titleAlign: 'center'
					},
					{
						id: 'localSur',
						title: 'Local Surcharge',
						width: '105px',
						align: 'right',
						titleAlign: 'center',
						editable: true,
						geniisysClass: 'money',
						geniisysErrorMsg: 'Field must be of form 99,999,999,999,990.00.',
						maxlength: 30,
						editor: new MyTableGrid.CellInput({
							validate: function(value, input) {
								if (getOtcValue('currencyShortName') == $F("varDefaultCurrency")) {
									setOtcValue(parseFloat(nvl(getOtcValue('amount'),"0")) - parseFloat(nvl(value,"0")) , 'netCollnAmt');
									setOtcValue(parseFloat(nvl(value,"0")) , 'foreignSur');
								}
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
						geniisysClass: 'money',
						geniisysErrorMsg: 'Field must be of form 99,999,999,999,990.00.'
					},
					{
						id: 'foreignSur',
						title: 'Foreign Surcharge',
						width: '105px',
						align: 'right',
						titleAlign: 'center',
						editable: true,
						geniisysClass: 'money',
						geniisysErrorMsg: 'Field must be of form 99,999,999,999,990.00.',
						maxlength: 30,
						editor: new MyTableGrid.CellInput({
							validate: function(value, input) {
								if (getOtcValue('currencyShortName') != $F("varDefaultCurrency")) {
									new Ajax.Request(contextPath+"/GIISCurrencyController?action=getCurrencyListByShortName", {
										method: "GET",
										evalScripts: true,
										asynchronous: false,
										parameters: {
											shortName: objACModalboxParams.otcRows[0]['currencyShortName']
										},
										onComplete: function(response) {
											var objCurrency = JSON.parse((response.responseText).replace(/\\/g, '\\\\'));
											var vRate = null;

											for (var i = 0; i < objCurrency.length; i++) {
												vRate = objCurrency[i].valueFloat;
												break;
											}

											setOtcValue(((vRate == null) ? null : parseFloat(nvl(value,"0")) * parseFloat(nvl(vRate, "0"))), 'localSur');
											setOtcValue(((vRate == null) ? null : parseFloat(nvl(getOtcValue('amount'),"0")) * parseFloat(nvl(getOtcValue('localSur'), "0"))), 'netCOllnAmt');
										}
									});
								}
								return true;
							}
						})
					},
					{
						id: 'netCollnAmt',
						title: 'Net Collection',
						width: '105px',
						align: 'right',
						titleAlign: 'center',
						editable: true,
						geniisysClass: 'money',
						geniisysErrorMsg: 'Field must be of form 99,999,999,999,990.00.',
						maxlength: 30,
						editor: new MyTableGrid.CellInput({
							validate: function(value, input) {
								return true;
							}
						})
					}
				],
				resetChangeTag: true,
				rows: objOtc.objOtcList
		};
	
		otcListTableGrid = new MyTableGrid(otcTableModel);
		otcListTableGrid.pager = objOtc.objOtcListTableGrid;
		otcListTableGrid.render('otcListTableGrid');

		if (otcListTableGrid.rows.length > 0) {
			if (otcListTableGrid.getValueAt(otcListTableGrid.getColumnIndex('currencyShortName'), 0) != $F("varDefaultCurrency")) {
				otcListTableGrid.columnModel[otcListTableGrid.getColumnIndex('localSur')].editable = false;
				otcListTableGrid.columnModel[otcListTableGrid.getColumnIndex('foreignSur')].editable = true;
			} else {
				otcListTableGrid.columnModel[otcListTableGrid.getColumnIndex('localSur')].editable = true;
			}
		}
	} catch(e){
		showErrorMessage("Out of Town Check Detail", e);
	}

	/** page item triggers */
	
	$("btnOtcReturn").observe("click", function() {
		for (var i = 0; i < otcListTableGrid.rows.length; i++) {
			addOrUpdateOtcBlockRows(otcListTableGrid.getRow(i));
		}

		for (var i = 1; i <= otcListTableGrid.newRowsAdded.length; i++) {
			addOrUpdateOtcBlockRows(otcListTableGrid.getRow(-i));
		}

		if ($F("varOTCSaved") == "Y") {
			if (objACModalboxParams.gbdsdRows != null && otcListTableGrid != null) {
				for (var i = 0; i < objACModalboxParams.gbdsdRows.length; i++) {
					if (objACModalboxParams.gbdsdRows[i]['depId'] == depId) {
						objACModalboxParams.gbdsdRows[i]['localSur'] = null;
						objACModalboxParams.gbdsdRows[i]['foreignSur'] = null;
						objACModalboxParams.gbdsdRows[i]['netCollnAmt'] = null;
						break;
					}
				}

				new Ajax.Request(contextPath+"/GIACAccTransController?action=updateGbdsdInOtc", {
					method: "GET",
					evalScripts: true,
					asynchronous: false,
					parameters: {
						depId: depId
					},
					onComplete: function(response) {
					}
				});
			}
		}

		setOtcValue(null, 'localSur');
		setOtcValue(null, 'netCollnAmt');
		$("varOTCSaved").value = "N";
		
		Modalbox.show(contextPath+"/GIACBankDepSlipsController?action=showBankDepositPage"
				+ "&gaccTranId="+encodeURIComponent(objACGlobal.gaccTranId)
				+ "&itemNo=" + itemNo
				+ "&dcbNo="  + dcbNo
				+ "&parameters=" + JSON.stringify(objACModalboxParams),
				{  title: "List of Check Deposit Slips",
				   width: 800,
				   headerClose: false,
				   overlayClose: false });
	});

	/** end of page item triggers */

	/** page functions */
	
	/*
	** Checks if OTC row is existing on the array to be used in saving
	** If existing, just update the array. Otherwise, add the non-existing row.
	*/
	function addOrUpdateOtcBlockRows(row) {
		var exists = false;
		var index = -1;

		if (objACModalboxParams.otcRows != null) {
			if (objACModalboxParams.otcRows.length > 0) {
				exists = true;
			}
		}

		if (exists) {
			objACModalboxParams.otcRows[0] = row;
		} else {
			objACModalboxParams.otcRows.push(row);
		}
	}

	/*
	** Gets the value of otc record in specified column and selected row
	*/
	function getOtcValue(column) {
		return (selectedOtcIndex == null) ? "" : otcListTableGrid.getValueAt(otcListTableGrid.getColumnIndex(column), selectedOtcIndex);
	}

	/*
	** Sets the value of otc record in specified column and selected row
	*/
	function setOtcValue(value, column) {
		if (selectedOtcIndex != null) {
			otcListTableGrid.setValueAt(value, otcListTableGrid.getColumnIndex(column), selectedOtcIndex);
		}
	}

	/** end of page functions */
</script>