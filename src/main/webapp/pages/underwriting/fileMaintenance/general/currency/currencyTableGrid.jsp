<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="currencyMaintenanceDiv">
	<div id="currencyMaintenanceTable">
	<H1>Currency Table Grid!</H1>
	</div>
</div>
<script type="text/javascript">
	setModuleId("GIISS009");
	initializeAll();
	setDocumentTitle("Workflow - Currency Maintenance");
	initializeAccordion();
	var selectedIndex = null;
	var objCurrEvent;

	var objTGCurrency = JSON.parse('${currencyTableGrid}'
			.replace(/\\/g, "\\\\"));
	
	var currencyMaintenanceTable = {
		url : contextPath + "/GIISController?action=getCurrencyList&refresh=1",
		options : {
			width : '900px',
			pager : {},
			toolbar : {
				elements : [ MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN ],
				onRefresh : function() {
					setEventForm(null);
				},
				onFilter : function() {
					setEventForm(null);
				},
				onCellFocus : function(element, value, x, y, id) {
					var mtgId = tbgCurrencyMaintenance._mtgId;
					if ($('mtgRow' + mtgId + '_' + y).hasClassName(
							"selectedRow")) {
						selectedIndex = y;
						objCurrEvent = tbgEventMaintenance.geniisysRows[y];
						setEventForm(objCurrEvent);
					}
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					selectedIndex = null;
					setEventForm(null);
				},
				prePager : function() {
					setEventForm(null);
				},
				onKeyDelete : function() {
					deleteEvent();
				},
				onSort : function() {
					setEventForm(null);
				}
			},
			columnModel : [ {
				id : 'recordStatus',
				title : '',
				width : '0',
				visible : false
			}, {
				id : 'divCtrId',
				width : '0',
				visible : false
			}, {
				id : "mainCurrencyCd",
				title : "Code",
				width : '100px',
				align : 'right',
				filterOption : true
			}, {
				id : "shortName",
				title : "Short Name",
				width : '100px',
				align : 'right',
				filterOption : true
			}, {
				id : "currencyDesc",
				title : "Currency Desc",
				width : '100px',
				align : 'right',
				filterOption : true
			}, {
				id : "currencyRt",
				title : "Rate",
				width : '100px',
				align : 'right',
				filterOption : true
			}, {
				id : "remarks",
				title : "Remarks",
				width : '100px',
				align : 'right',
				filterOption : true
			} ],
			rows : objTGCurrency.rows
		}
	};
	
	tbgCurrencyMaintenance = new MyTableGrid(currencyMaintenanceTable);
	tbgCurrencyMaintenance.pager = objTGCurrency;
	tbgCurrencyMaintenance.render('currencyMaintenanceTable');
	changeTag = 0;
</script>