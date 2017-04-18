<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="locmDiv" name="locmDiv" class="sectionDiv" style="width: 94%; margin: 3px; font-size: 11px;">
	<form id="locmForm" name="locmForm" style="margin: 10px;">
		<div class="sectionDiv" id="locmOuterDiv" style="border-bottom: none;" changeTagAttr="true">
			<!-- locm -->
			<div id="locmListTableGridSectionDiv" class="sectionDiv" style="height: 140px; border: none" align="center">
				<div id="locmListTableGridDiv" style="padding: 10px; border: none" align="center">
					<div id="locmListTableGrid" style="height: 100px; width: 624px; border: none" align="left"></div>
				</div>
			</div>
			
			<div class="sectionDiv" style="border-left: white; border-right: white; border-bottom: white;" id="locmDetailsDiv" style="margin-top: -2px;">
				<table width="800px" align="center" cellspacing="1" border="0">
					<tr>
						<td style="width: 240px">&nbsp</td>
						<td class="rightAligned" style="width: 200px;">Local Currency Amount Total</td>
						<td class="leftAligned">
							<input type="text" id="locmDspTotLoc" name="locmDspTotLoc" style="width: 120px; text-align: right" readonly="readonly" value=""/>
						</td>
						<td style="width: 200px">&nbsp</td>
					</tr>
					<tr>
						<td style="width: 320px"></td>
						<td class="rightAligned" style="width: 200px;">Foreign Currency Amount Total</td>
						<td class="leftAligned">
							<input type="text" id="locmDspTotFor" name="locmDspTotFor" style="width: 120px; text-align: right" readonly="readonly" value=""/>
						</td>
						<td style="width: 200px">&nbsp</td>
					</tr>
				</table>
				<table align="center">
					<tr>
						<td class="leftAligned"  style="width: 62px"><input type="button" class="button" id="btnLocmReturn" name="btnLocmReturn" value="Return" style="width: 60px;" /></td>
					</tr>
				</table>
			</div>
		</div>
	</form>
</div>
<script type="text/JavaScript">
	var selectedLocmRow	   = null;
	
	// LOCM Table Grid
	
	try {
		var objLocm = new Object();
		objLocm.objLocmListTableGrid = JSON.parse('${locmListTableGrid}'.replace(/\\/g, '\\\\'));
		objLocm.objLocmList = objLocm.objLocmListTableGrid.rows || [];
	
		var locmTableModel = {
				url: contextPath+"/GIACAccTransController?action=refreshLocmListing&gaccTranId="+encodeURIComponent(objACGlobal.gaccTranId),
				options:{
					title: '',
					width: '624px',
					onCellFocus: function(element, value, x, y, id){
						var mtgId = locmListTableGrid._mtgId;
						if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
							// set selected LOCM row
							selectedLocmRow = locmListTableGrid.geniisysRows[y];
						}
						observeChangeTagInTableGrid(locmListTableGrid);
					},
					onCellBlur: function(element, value, x, y, id){
						selectedLocmRow = null;
						observeChangeTagInTableGrid(locmListTableGrid);
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
						id: 'dspOrPrefSuf',
						title: 'Or No.',
						width: '110px',
						align: 'center',
						titleAlign: 'center'
					},
					{
						id: 'payor',
						title: 'Payor',
						width: '110px',
						align: 'center',
						titleAlign: 'center'
					},
					{
						id: 'amount',
						title: 'Local Currency Amt',
						width: '105px',
						align: 'right',
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
						id: 'foreignCurrAmt',
						title: 'Foreign Currency Amt',
						width: '105px',
						align: 'right',
						titleAlign: 'center'
					},					
					{
						id: 'currencyRt',
						title: 'Currency Rate',
						width: '100px',
						align: 'center',
						titleAlign: 'right'
					},
					{
						id: 'validationDt',
						title: 'Validation Date',
						width: '105px',
						filterOption: true,
						sortable: true,
						align: 'center',
						type: 'date',
						titleAlign: 'center'
					},
				],
				resetChangeTag: true,
				rows: objLocm.objLocmList
		};
	
		locmListTableGrid = new MyTableGrid(locmTableModel);
		locmListTableGrid.pager = objLocm.objLocmListTableGrid;
		locmListTableGrid.render('locmListTableGrid');

		/* Set local and foreign currency amount total */
		var totalLocmLocalCurrAmt   = 0;
		var totalLocmForeignCurrAmt = 0;
		for (var i = 0; i < locmListTableGrid.geniisysRows.length; i++) {
			totalLocmLocalCurrAmt   = totalLocmLocalCurrAmt   + parseFloat(locmListTableGrid.geniisysRows[i].amount);
			totalLocmForeignCurrAmt = totalLocmForeignCurrAmt + parseFloat(locmListTableGrid.geniisysRows[i].foreignCurrAmt);
		}

		$("locmDspTotLoc").value = formatCurrency(parseFloat(nvl(totalLocmForeignCurrAmt, "0")));
		$("locmDspTotFor").value = formatCurrency(parseFloat(nvl(totalLocmLocalCurrAmt, "0")));
	} catch(e){
		showErrorMessage("List of Credit Memo", e);
	}

	/** page item triggers */
	
	$("btnLocmReturn").observe("click", function() {
		Modalbox.hide();
	});

	/** end of page item triggers */

	/** page functions */
	
	
	/** end of page functions */
</script>