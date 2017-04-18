<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="lpCommInvDiv" class="sectionDiv" style="border:none; margin: 10px 0;" >
	<div class="sectionDiv" style="width: 580px; border: none;">
		<table cellspacing="1" cellpadding="1">
			<tr>
				<td colspan="2" align="center" style="font-weight: bolder;">Your Share ${dspRate}</td>
			</tr>
			<tr>
				<td>
					<div id="lpCommInvPerilDiv" class="sectionDiv" style="border: none; padding: 10px; padding-left: 20px;">
						<div id="lpCommInvPerilTableGridDiv" style="height: 130px; width: 550px;"></div>
					</div>
				</td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv" style="width: 280px; float: left; border: none;" align="right">
		<table>
			<tr>
				<td class="rightAligned">Share %</td>
				<td class="leftAligned"><input type="text" id="invCommSharePct" readonly="readonly" class="money"/></td>
				
			</tr>
			<tr>
				<td class="rightAligned">Share of Premium</td>
				<td class="leftAligned"><input type="text" id="invCommPrem" readonly="readonly" class="money"/></td>
			</tr>
			<tr>
				<td class="rightAligned">Total Commission</td>
				<td class="leftAligned"><input type="text" id="invCommTotalComm" readonly="readonly" class="money"/></td>
			</tr>
			<tr>
				<td class="rightAligned">Total Tax Withheld</td>
				<td class="leftAligned"><input type="text" id="invCommWholdTax" readonly="readonly" class="money"/></td>
			</tr>
			<tr>
				<td class="rightAligned">Net Commission</td>
				<td class="leftAligned"><input type="text" id="invCommNetComm" readonly="readonly" class="money"/></td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv" style="border: none;">
		<div style="padding-left: 20px;">
			<table>
			<tr>
				<td class="rightAligned">Peril Description:</td>
				<td class="leftAligned"><input type="text" id="invCommPerilDesc" readonly="readonly" style="width:300px;"/></td>
			</tr>
		</table>
		</div>
	</div>
</div>
<div id="lpCommInvDiv2" class="sectionDiv" style="border: none; margin: 10px 0;">
	<div class="sectionDiv" style="width: 580px; border: none;">
		<table cellspacing="1" cellpadding="1">
			<tr>
				<td colspan="2" align="center" style="font-weight: bolder;">Full Share (100%)</td>
			</tr>
			<tr>
				<td>
					<div id="lpCommInvPerilDiv2" class="sectionDiv" style="border: none; padding: 10px; padding-left: 20px;">
						<div id="lpCommInvPerilTableGridDiv2" style="height: 130px; width: 550px;"></div>
					</div>
				</td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv" style="width: 280px; float: left; border: none;" align="right">
		<table>
			<tr>
				<td class="rightAligned">Share %</td>
				<td class="leftAligned"><input type="text" id="invCommCompSharePct" readonly="readonly" class="money"/></td>
				
			</tr>
			<tr>
				<td class="rightAligned">Share of Premium</td>
				<td class="leftAligned"><input type="text" id="invCommCompPrem" readonly="readonly" class="money"/></td>
			</tr>
			<tr>
				<td class="rightAligned">Total Commission</td>
				<td class="leftAligned"><input type="text" id="invCommCompTotalComm" readonly="readonly" class="money"/></td>
			</tr>
			<tr>
				<td class="rightAligned">Total Tax Withheld</td>
				<td class="leftAligned"><input type="text" id="invCommCompWholdTax" readonly="readonly" class="money"/></td>
			</tr>
			<tr>
				<td class="rightAligned">Net Commission</td>
				<td class="leftAligned"><input type="text" id="invCommCompNetComm" readonly="readonly" class="money"/></td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv" style="border: none;">
		<div style="padding-left: 20px;">
			<table>
			<tr>
				<td class="rightAligned">Peril Description:</td>
				<td class="leftAligned"><input type="text" id="invCommPerilDesc2" readonly="readonly" style="width:300px;"/></td>
			</tr>
		</table>
		</div>
	</div>
</div>
<div class="sectionDiv" align="center" style="margin: 10px 0; border: none">
	<input type="button" class="button" id="lpIntrmdryReturnBtn" value="Return"></input>
</div>

<script>
	
	$("lpIntrmdryReturnBtn").observe("click", function(){
		$("lpInvoiceInfoMainSectionDiv").show();
		$("lpInvButtonsDiv").show();
		$("lpInvCommDiv").hide();
	});

	var objLpCommInvPeril = new Object();
	objLpCommInvPeril.objLpCommInvPerilTableGrid = JSON.parse('${leadPolicyCommInvPerilTableGrid}'.replace(/\\/g, '\\\\'));
	objLpCommInvPeril.objLpCommInvPerilListing = objLpCommInvPeril.objLpCommInvPerilTableGrid.rows || null;
	
	var lpCommInvPerilTableModel = {
		url: contextPath+"/GIPILeadPolicyController?action=refreshLeadPolicyCommInvPerilListing&parId="+encodeURIComponent($F("globalParId"))+"&lineCd="+encodeURIComponent($F("globalLineCd")),
		options:{
			title: '',
			width: '550px',
			onCellFocus: function (element, value, x, y, id) {
				var obj = objLpCommInvPeril.objLpCommInvPerilListing;
				addTableGridRowClassSelectedRow(lpCommInvPerilTableGrid2, x, y);
				$('mtgRow'+lpCommInvPerilTableGrid._mtgId+'_'+y).scrollIntoView();
				populateLeadPolicyCommInvPerilNameFields(obj[y]);
			},
			onRemoveRowFocus: function (element, value, x, y, id) {
				removeTableGridRowClassSelectedRow(lpCommInvPerilTableGrid2, x,y);
				populateLeadPolicyCommInvPerilNameFields(null);
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
			{ 	id: 'intrmdryNo',
			  	width: '0',
			  	visible: false
			},
			{	id: 'perilCd',
			    title: 'Peril',
			    sortable: false,
				width: '40px',
				visible: true
			},
			{	id: 'sharePremiumAmt',
			    title: 'Premium Amount',
			    geniisysClass: 'money',
			    align: 'right',
			    titleAlign: 'right',
			    sortable: false,
				width: '110px',
				visible: true
			},
			{	id: 'shareCommissionRt',
			    title: 'Rate',
			    geniisysClass: 'rate',
			    align: 'right',
			    titleAlign: 'right',
			    sortable: false,
				width: '90px',
				visible: true
			},
			{	id: 'shareCommissionAmt',
			    title: 'Comm Amount',
			    geniisysClass: 'money',
			    align: 'right',
			    titleAlign: 'right',
			    sortable: false,
				width: '100px',
				visible: true
			},
			{	id: 'shareWholdingTax',
			    title: 'Withholding Tax',
			    geniisysClass: 'money',
			    align: 'right',
			    titleAlign: 'right',
			    sortable: false,
				width: '100px',
				visible: true
			},
			{	id: 'shareNetCommission',
			    title: 'Net Commission',
			    geniisysClass: 'money',
			    align: 'right',
			    titleAlign: 'right',
			    sortable: false,
				width: '100px',
				visible: true
			},
		],
		requiredColumns: 'itemGrp',
		rows: objLpCommInvPeril.objLpCommInvPerilListing,
		hideRowsOnLoad: true
	};

	var lpCommInvPerilTableModel2 = {
			url: contextPath+"/GIPILeadPolicyController?action=refreshLeadPolicyCommInvPerilListing&parId="+encodeURIComponent($F("globalParId"))+"&lineCd="+encodeURIComponent($F("globalLineCd")),
			options:{
				title: '',
				width: '550px',
				onCellFocus: function (element, value, x, y, id) {
					var obj = objLpCommInvPeril.objLpCommInvPerilListing;
					addTableGridRowClassSelectedRow(lpCommInvPerilTableGrid, x, y);
					$('mtgRow'+lpCommInvPerilTableGrid2._mtgId+'_'+y).scrollIntoView();
					populateLeadPolicyCommInvPerilNameFields(obj[y]);
				},
				onRemoveRowFocus: function (element, value, x, y, id) {
					removeTableGridRowClassSelectedRow(lpCommInvPerilTableGrid, x,y);
					populateLeadPolicyCommInvPerilNameFields(null);
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
				{ 	id: 'intrmdryNo',
				  	width: '0',
				  	visible: false
				},
				{	id: 'perilCd',
				    title: 'Peril',
				    sortable: false,
					width: '40px',
					visible: true
				},
				{	id: 'premiumAmt',
				    title: 'Premium Amount',
				    geniisysClass: 'money',
				    align: 'right',
				    titleAlign: 'right',
				    sortable: false,
					width: '110px',
					visible: true
				},
				{	id: 'commissionRt',
				    title: 'Rate',
				    geniisysClass: 'rate',
				    align: 'right',
				    titleAlign: 'right',
				    sortable: false,
					width: '90px',
					visible: true
				},
				{	id: 'commissionAmt',
				    title: 'Comm Amount',
				    geniisysClass: 'money',
				    align: 'right',
				    titleAlign: 'right',
				    sortable: false,
					width: '100px',
					visible: true
				},
				{	id: 'wholdingTax',
				    title: 'Withholding Tax',
				    geniisysClass: 'money',
				    align: 'right',
				    titleAlign: 'right',
				    sortable: false,
					width: '100px',
					visible: true
				},
				{	id: 'netCommission',
				    title: 'Net Commission',
				    geniisysClass: 'money',
				    align: 'right',
				    titleAlign: 'right',
				    sortable: false,
					width: '100px',
					visible: true
				},
			],
			requiredColumns: 'itemGrp',
			rows: objLpCommInvPeril.objLpCommInvPerilListing,
			hideRowsOnLoad: true
		};
	
	lpCommInvPerilTableGrid = new MyTableGrid(lpCommInvPerilTableModel);
	lpCommInvPerilTableGrid.pager = "";
	lpCommInvPerilTableGrid.render('lpCommInvPerilTableGridDiv');

	lpCommInvPerilTableGrid2 = new MyTableGrid(lpCommInvPerilTableModel2);
	lpCommInvPerilTableGrid2.pager = "";
	lpCommInvPerilTableGrid2.render('lpCommInvPerilTableGridDiv2');

	resetLeadPolicyItemGrpDependentRecords();

		
</script>