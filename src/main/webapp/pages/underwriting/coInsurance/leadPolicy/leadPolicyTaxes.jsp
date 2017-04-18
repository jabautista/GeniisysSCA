<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<table cellspacing="1" cellpadding="1">
	<tr>
		<td align="center" style="font-weight: bolder;">Your Share ${dspRate}</td>
		<td align="center" style="font-weight: bolder;">Full Share (100%)</td>
	</tr>
	<tr>
		<td>
			<div id="lpTaxesListingDiv" style="width: 49.7%; margin: 10px 15px;">
				<div id="lpTaxesTableGridDiv" style="height: 250px; width: 420px;"></div>
			</div>
		</td>
		<td>
			<div id="lpTaxesListingDiv2" style="width: 49.7%; float: left; margin: 10px;">
				<div id="lpTaxesTableGridDiv2" style="height: 250px; width: 420px;"></div>
			</div>
		</td>
	</tr>
	<tr>
		<td colspan="2" align="center">
			<div>
				<input type="button" class="button" id="lpTaxesReturnBtn" value="Return"></input>
			</div>
		</td>
	</tr>
</table>

<script>
	var objLpTaxes = new Object();
	objLpTaxes.objLpTaxesTableGrid = JSON.parse('${leadPolicyTaxesTableGrid}'.replace(/\\/g, '\\\\'));
	objLpTaxes.objLpTaxesListing = objLpTaxes.objLpTaxesTableGrid.rows || null;
	
	var lpTaxesTableModel = {
		url: contextPath+"/GIPILeadPolicyController?action=refreshLeadPolicyTaxesListing&parId="+encodeURIComponent($F("globalParId"))+"&lineCd="+encodeURIComponent($F("globalLineCd"))+"&issCd="+encodeURIComponent($F("globalIssCd")),
		options:{
			title: '',
			width: '420px',
			onCellFocus: function (element, value, x, y, id) {
				addTableGridRowClassSelectedRow(lpTaxesTableGrid2, x, y);
				$('mtgRow'+lpTaxesTableGrid._mtgId+'_'+y).scrollIntoView();
			},
			onRemoveRowFocus: function (element, value, x, y, id) {
				removeTableGridRowClassSelectedRow(lpTaxesTableGrid2, x ,y);
			}
		},
		columnModel: [
		    { 	id: 'recordStatus',
			  	title: '',
			  	width: '0',
			  	visible: false,
			  	editor: 'checkbox'
		    },
		    { 	id: 'divCtrId',
			  	width: '0',
			  	visible: false
		    },
		    { 	id: 'itemGrp',
			  	width: '0',
			  	visible: false
			},
			{	id: 'taxCd',
			    title: 'Tax Cd',
			    //align: 'center',
			    sortable: false,
				width: '46px',
				visible: true
			},
			{	id: 'taxDesc',
			    title: 'Tax Description',
			    sortable: false,
				width: '250px',
				visible: true
			},
			{	id: 'shareTaxAmt',
			    title: 'Tax Amount',
			    geniisysClass: 'money',
			    align: 'right',
			    titleAlign: 'right',
			    sortable: false,
				width: '110px',
				visible: true
			}
		],
		requiredColumns: 'itemGrp',
		rows: objLpTaxes.objLpTaxesListing,
		hideRowsOnLoad: true
	};

	var lpTaxesTableModel2 = {
			url: contextPath+"/GIPILeadPolicyController?action=refreshLeadPolicyTaxesListing&parId="+encodeURIComponent($F("globalParId"))+"&lineCd="+encodeURIComponent($F("globalLineCd"))+"&issCd="+encodeURIComponent($F("globalIssCd")),
			options:{
				title: '',
				width: '420px',
				onCellFocus: function (element, value, x, y, id) {
					addTableGridRowClassSelectedRow(lpTaxesTableGrid, x, y);
					$('mtgRow'+lpTaxesTableGrid2._mtgId+'_'+y).scrollIntoView();
				},
				onRemoveRowFocus: function (element, value, x, y, id) {
					removeTableGridRowClassSelectedRow(lpTaxesTableGrid, x,y);
				}
			},
			columnModel: [
			{ 	id: 'recordStatus',
			  	title: '',
			  	width: '0',
			  	visible: false,
			  	editor: 'checkbox'
		    },
		    { 	id: 'divCtrId',
			  	width: '0',
			  	visible: false
		    },
		    { 	id: 'itemGrp',
			  	width: '0',
			  	visible: false
			},
			{	id: 'taxCd',
			    title: 'Tax Cd',
			    //align: 'center',
			    sortable: false,
				width: '46px',
				visible: true
			},
			{	id: 'taxDesc',
			    title: 'Tax Description',
			    sortable: false,
				width: '250px',
				visible: true
			},
			{	id: 'taxAmt',
			    title: 'Tax Amount',
			    geniisysClass: 'money',
			    align: 'right',
			    titleAlign: 'right',
			    sortable: false,
				width: '110px',
				visible: true
			}
			],
			requiredColumns: 'itemGrp',
			rows: objLpTaxes.objLpTaxesListing,
			hideRowsOnLoad: true
		};

	lpTaxesTableGrid = new MyTableGrid(lpTaxesTableModel);
	lpTaxesTableGrid.pager = "";
	lpTaxesTableGrid.render('lpTaxesTableGridDiv');

	lpTaxesTableGrid2 = new MyTableGrid(lpTaxesTableModel2);
	lpTaxesTableGrid2.pager = "";
	lpTaxesTableGrid2.render('lpTaxesTableGridDiv2');

	$("lpTaxesReturnBtn").observe("click", function(){
		$("lpInvoiceInfoMainSectionDiv").show();
		$("lpInvButtonsDiv").show();
		$("lpTaxesDiv").hide();
	});

	resetLeadPolicyItemGrpDependentRecords();

</script>