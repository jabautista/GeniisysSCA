<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="checkDepositAnalysisDiv" name="checkDepositAnalysisDiv" class="sectionDiv" style="width: 94%; margin: 3px; font-size: 11px;">
	<form id="checkDepositAnalysisForm" name="checkDepositAnalysisForm" style="margin: 10px;">
		<!-- ERROR List -->
		
		<div class="sectionDiv" id="errorOuterDiv" style="border-bottom: none;" changeTagAttr="true">
			<!-- ERROR -->
			<div id="errorListTableGridSectionDiv" class="sectionDiv" style="height: 140px; border: none" align="center">
				<div id="errorListTableGridDiv" style="padding: 10px; border: none" align="center">
					<div id="errorListTableGrid" style="height: 100px; width: 624px; border: none" align="left"></div>
				</div>
			</div>
			
			<div class="sectionDiv" style="border-left: white; border-right: white; border-bottom: white;" id="errorDetailsDiv" style="margin-top: -2px;">
				<table width="900px" align="center" cellspacing="1" border="0">
					<tr>
						<td style="width: 70px;">&nbsp</td>
						<td class="rightAligned" style="width: 80px;">Remarks</td>
						<td class="leftAligned">
							<div style="border: 1px solid gray; width: 450px; height: 21px; float: left;">
								<input style="width: 400px; float: left; border: none;" id="errorRemarks" name="Remarks" type="text" value="" maxlength="4000"/>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editErrorRemarks" />
							</div>
						</td>
						<td style="width: 70px;">&nbsp</td>
					</tr>
				</table>
				<table align="center">
					<tr>
						<td class="leftAligned"  style="width: 62px"><input type="button" class="button" id="btnErrorReturn" name="btnErrorReturn" value="Return" style="width: 60px;" /></td>
					</tr>
				</table>
			</div>
		</div>
	</form>
</div>
<script type="text/JavaScript">
	var selectedErrorIndex	   = null;
	var itemNo				   = '${itemNo }';
	var dcbNo				   = '${dcbNo }';
	var gbdsdIndex			   = '${gbdsdIndex }';
	
	// ERROR Table Grid
	
	try {
		var objError = new Object();
		objError.objErrorListTableGrid = JSON.parse('${errorListTableGrid}'.replace(/\\/g, '\\\\'));
		objError.objErrorList = objError.objErrorListTableGrid.rows || [];
	
		var errorTableModel = {
				url: contextPath+"/GIACAccTransController?action=refreshGbdsdErrorListing&gaccTranId="+encodeURIComponent(objACGlobal.gaccTranId),
				options:{
					title: '',
					width: '624px',
					onCellFocus: function(element, value, x, y, id){
						var mtgId = errorListTableGrid._mtgId;
						selectedErrorIndex = y;
						$("errorRemarks").value = getErrorValue('remarks');
						observeChangeTagInTableGrid(errorListTableGrid);
					},
					onRemoveRowFocus: function(element, value, x, y, id) {
						$("errorRemarks").value = "";
					},
					onCellBlur: function(element, value, x, y, id){
						selectedErrorIndex = null;
						observeChangeTagInTableGrid(errorListTableGrid);
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
						titleAlign: 'center',
						geniisysClass: 'money'
					},
					{
						id: 'dspNetDeposit',
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
								setErrorValue(parseFloat(nvl(getErrorValue('amount'), "0")) - parseFloat(nvl(value, "0")), 'error');
								return true;
							}
						})
					},
					{
						id: 'error',
						title: 'Difference',
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
					},
					{
						id: 'bookTag',
						title: 'B',
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
				            	setErrorValue(value, 'bookTag');
			            	}
			            })
					},
					{
						id: 'remarks',
						width: '0',
						visible: false
					},
				],
				resetChangeTag: true,
				rows: objError.objErrorList
		};
	
		errorListTableGrid = new MyTableGrid(errorTableModel);
		errorListTableGrid.pager = objError.objErrorListTableGrid;
		errorListTableGrid.render('errorListTableGrid');
	} catch(e){
		showErrorMessage("Check Deposit Analysis", e);
	}

	/** page item triggers */
	
	$("editErrorRemarks").observe("click", function() {
		showEditor("errorRemarks", 4000);
	});

	$("btnErrorReturn").observe("click", function() {
		for (var i = 0; i < errorListTableGrid.rows.length; i++) {
			addOrUpdateErrorBlockRows(errorListTableGrid.getRow(i));
		}

		for (var i = 1; i <= errorListTableGrid.newRowsAdded.length; i++) {
			addOrUpdateErrorBlockRows(errorListTableGrid.getRow(-i));
		}
		
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

	$("errorRemarks").observe("blur", function() {
		if (selectedErrorIndex != null) {
			setErrorValue($F("errorRemarks"), 'remarks');
		}
	});

	$("errorRemarks").observe("change", function() {
		if (selectedErrorIndex != null) {
			if (objACModalboxParams.otcRows != null) {
				if (objACModalboxParams.otcRows.length > 1) {
					if (objACModalboxParams.otcRows[0]['currencyShortName'] != $F("varDefaultCurrency")) {
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

								objACModalboxParams.otcRows[0]['localSur'] = (vRate == null) ? null : parseFloat(nvl(objACModalboxParams.otcRows[0]['foreignSur'],"0")) * parseFloat(nvl(vRate, "0"));
								objACModalboxParams.otcRows[0]['netCollnAmt'] = parseFloat(nvl(objACModalboxParams.otcRows[0]['amount'],"0")) * parseFloat(nvl(objACModalboxParams.otcRows[0]['localSur'], "0"));
							}
						});
					}
				}
			}
		}
	});

	/** end of page item triggers */

	/** page functions */
	
	/*
	** Gets the value of ERROR record in specified column and selected row
	*/
	function getErrorValue(column) {
		return (selectedErrorIndex == null) ? "" : errorListTableGrid.getValueAt(errorListTableGrid.getColumnIndex(column), selectedErrorIndex);
	}

	/*
	** Sets the value of ERROR record in specified column and selected row
	*/
	function setErrorValue(value, column) {
		if (selectedErrorIndex != null) {
			errorListTableGrid.setValueAt(value, errorListTableGrid.getColumnIndex(column), selectedErrorIndex);
		}
	}

	/*
	** Checks if ERROR row is existing on the array to be used in saving
	** If existing, just update the array. Otherwise, add the non-existing row.
	*/
	function addOrUpdateErrorBlockRows(row) {
		var exists = false;
		var index = -1;

		if (objACModalboxParams.errorRows != null) {
			if (objACModalboxParams.errorRows.length > 0) {
				exists = true;
			}
		}

		if (exists) {
			objACModalboxParams.errorRows[0] = row;
		} else {
			objACModalboxParams.errorRows.push(row);
		}
	}

	/** end of page functions */
</script>