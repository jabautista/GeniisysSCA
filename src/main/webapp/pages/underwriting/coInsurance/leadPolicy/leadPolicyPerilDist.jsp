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
			<div id="lpInvPerlListingDiv" style="width: 49.7%; margin: 10px 15px;">
				<div id="lpInvPerlTableGridDiv" style="height: 250px; width: 420px;"></div>
			</div>
		</td>
		<td>
			<div id="lpInvPerlListingDiv2" style="width: 49.7%; float: left; margin: 10px;">
				<div id="lpInvPerlTableGridDiv2" style="height: 250px; width: 420px;"></div>
			</div>
		</td>
	</tr>
	<tr>
		<td colspan="2" align="center">
			<div>
				<input type="button" class="button" id="lpInvPerlReturnBtn" value="Return"></input>
			</div>
		</td>
	</tr>
</table>

<script>
	var objLpInvPerl = new Object();
	objLpInvPerl.objLpInvPerlTableGrid = JSON.parse('${leadPolicyInvPerlTableGrid}'.replace(/\\/g, '\\\\'));
	objLpInvPerl.objLpInvPerlListing = objLpInvPerl.objLpInvPerlTableGrid.rows || null;
	
	var lpInvPerlTableModel = {
		url: contextPath+"/GIPILeadPolicyController?action=refreshLeadPolicyInvPerlListing&parId="+encodeURIComponent($F("globalParId"))+"&lineCd="+encodeURIComponent($F("globalLineCd")),
		options:{
			title: '',
			width: '420px',
			onCellFocus: function (element, value, x, y, id) {
				addTableGridRowClassSelectedRow(lpInvPerlTableGrid2, x, y);
				$('mtgRow'+lpInvPerlTableGrid._mtgId+'_'+y).scrollIntoView();
			},
			onRemoveRowFocus: function (element, value, x, y, id) {
				removeTableGridRowClassSelectedRow(lpInvPerlTableGrid2, x ,y);
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
			{	id: 'perilName',
			    title: 'Peril Description',
			    sortable: false,
				width: '200px',
				visible: true
			},
			{	id: 'shareTsiAmt',
			    title: 'TSI Amount',
			    geniisysClass: 'money',
			    align: 'right',
			    titleAlign: 'right',
			    sortable: false,
				width: '103px',
				visible: true
			},
			{	id: 'sharePremAmt',
			    title: 'Premium Amount',
			    geniisysClass: 'money',
			    align: 'right',
			    titleAlign: 'right',
			    sortable: false,
				width: '103px',
				visible: true
			}
		],
		requiredColumns: 'itemGrp',
		rows: objLpInvPerl.objLpInvPerlListing,
		hideRowsOnLoad: true
	};

	var lpInvPerlTableModel2 = {
			url: contextPath+"/GIPILeadPolicyController?action=refreshLeadPolicyInvPerlListing&parId="+encodeURIComponent($F("globalParId"))+"&lineCd="+encodeURIComponent($F("globalLineCd")),
			options:{
				title: '',
				width: '420px',
				onCellFocus: function (element, value, x, y, id) {
					addTableGridRowClassSelectedRow(lpInvPerlTableGrid, x, y);
					$('mtgRow'+lpInvPerlTableGrid2._mtgId+'_'+y).scrollIntoView();
				},
				onRemoveRowFocus: function (element, value, x, y, id) {
					removeTableGridRowClassSelectedRow(lpInvPerlTableGrid, x,y);
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
			{	id: 'perilName',
			    title: 'Peril Description',
			    sortable: false,
				width: '200px',
				visible: true
			},
			{	id: 'tsiAmt',
			    title: 'TSI Amount',
			    geniisysClass: 'money',
			    align: 'right',
			    titleAlign: 'right',
			    sortable: false,
				width: '103px',
				visible: true
			},
			{	id: 'premAmt',
			    title: 'Premium Amount',
			    geniisysClass: 'money',
			    align: 'right',
			    titleAlign: 'right',
			    sortable: false,
				width: '103px',
				visible: true
			}
			],
			requiredColumns: 'itemGrp',
			rows: objLpInvPerl.objLpInvPerlListing,
			hideRowsOnLoad: true
		};

	lpInvPerlTableGrid = new MyTableGrid(lpInvPerlTableModel);
	lpInvPerlTableGrid.pager = "";
	lpInvPerlTableGrid.render('lpInvPerlTableGridDiv');

	lpInvPerlTableGrid2 = new MyTableGrid(lpInvPerlTableModel2);
	lpInvPerlTableGrid2.pager = "";
	lpInvPerlTableGrid2.render('lpInvPerlTableGridDiv2');

	$("lpInvPerlReturnBtn").observe("click", function(){
		$("lpInvoiceInfoMainSectionDiv").show();
		$("lpInvButtonsDiv").show();
		$("lpPerilDistDiv").hide();
	});

	resetLeadPolicyItemGrpDependentRecords();

</script>