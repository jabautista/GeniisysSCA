<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div class="sectionDiv" style="margin: 15px 0; border: none;">
	<div id="lpIntrmdryListingDiv" style="border: none; padding-left: 40px;" >
		<div id="lpIntrmdryTableGridDiv" style="height: 105px; width: 740px;"></div>
	</div>
</div>
<div id="lpInvCommPerilDiv" class="sectionDiv"style="border: none;"></div>
<div id="lpCommInvDiv" class="sectionDiv" style="border:none; margin: 10px 0;" >
	<div class="sectionDiv" style="width: 500px; border: none;">
		<table cellspacing="1" cellpadding="1">
			<tr>
				<td colspan="2" align="center" style="font-weight: bolder;">YOUR SHARE ${dspRate}</td>
			</tr>
			<tr>
				<td>
					<div id="lpCommInvPerilDiv" class="sectionDiv" style="border: none;margin-top: 10px;">
						<div id="lpCommInvPerilTableGridDiv" style="height: 130px; width: 530px;"></div>
					</div>
				</td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv" style="width: 280px; float: left; border: none; padding:10px;" align="right">
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
				<td class="rightAligned">Peril Description</td>
				<td class="leftAligned"><input type="text" id="invCommPerilDesc" readonly="readonly" style="width:300px;"/></td>
			</tr>
		</table>
		</div>
	</div>
</div>
<div id="lpCommInvDiv2" class="sectionDiv" style="border: none; margin: 10px 0;">
	<div class="sectionDiv" style="width: 500px; border: none;">
		<table cellspacing="1" cellpadding="1">
			<tr>
				<td colspan="2" align="center" style="font-weight: bolder;">FULL SHARE (100%)</td>
			</tr>
			<tr>
				<td>
					<div id="lpCommInvPerilDiv2" class="sectionDiv" style="border: none; margin-top: 10px;">
						<div id="lpCommInvPerilTableGridDiv2" style="height: 130px; width: 500px;"></div>
					</div>
				</td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv" style="width: 280px; float: left; border: none; padding:10px;" align="right">
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
				<td class="rightAligned">Peril Description</td>
				<td class="leftAligned"><input type="text" id="invCommPerilDesc2" readonly="readonly" style="width:300px;"/></td>
			</tr>
		</table>
		</div>
	</div>
</div>

<script>
	try{
		var objLpIntrmdry = new Object();
		objLpIntrmdry.objLpIntrmdryTableGrid = JSON.parse('${invCommIntermediaryList}'.replace(/\\/g, '\\\\'));
		objLpIntrmdry.objLpIntrmdryListing = objLpIntrmdry.objLpIntrmdryTableGrid.rows || null;
		
		var lpIntrmdryTableModel = {
			url: contextPath+"/GIPIOrigCommInvoiceController?action=getInvoiceCommissions&refresh=1&policyId="+$F("hidPolicyId"),
			options:{
				title: '',
				width: '730px',
				onCellFocus: function (element, value, x, y, id) {
					var obj = lpIntrmdryTableGrid.geniisysRows[y];
					populateLeadInvCommFields(obj);
					lpIntrmdryTableGrid.releaseKeys();
				},
				onRemoveRowFocus: function (element, value, x, y, id) {
					populateLeadInvCommFields(null);
					lpIntrmdryTableGrid.releaseKeys();
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
				{	id: 'fullIntmNo',
				    title: 'Intm No.',
				    sortable: false,
					width: '100px',
					visible: true
				},
				{	id: 'fullIntmName',
				    title: 'Intermediary Name',
				    sortable: false,
					width: '257px',
					visible: true
				},
				{	id: 'fullPrntIntmNo',
				    title: 'Parent Intm No.',
				    sortable: false,
					width: '100px',
					visible: true
				},
				{	id: 'fullPrntIntmName',
				    title: 'Parent Intermediary Name',
				    sortable: false,
					width: '257px',
					visible: true
				},
			],
			requiredColumns: 'itemGrp',
			rows: objLpIntrmdry.objLpIntrmdryListing
		};
		
		lpIntrmdryTableGrid = new MyTableGrid(lpIntrmdryTableModel);
		lpIntrmdryTableGrid.pager = "";
		lpIntrmdryTableGrid.render('lpIntrmdryTableGridDiv');
		
		var lpCommInvPerilTableModel = {
			url: contextPath + "/GIPIOrigCommInvPerilController?action=getCommInvPerils&refresh=1&policyId="+ $F("hidPolicyId"),
			options:{
				title: '',
				width: '530px',
				onCellFocus: function (element, value, x, y, id) {
					var commInvPeril = lpCommInvPerilTableGrid.geniisysRows[y];
					$("invCommPerilDesc").value = unescapeHTML2(commInvPeril.yourPerilName);
					lpCommInvPerilTableGrid.releaseKeys();
				},
				onRemoveRowFocus: function (element, value, x, y, id) {
					$("invCommPerilDesc").value = "";
					lpCommInvPerilTableGrid.releaseKeys();
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
				{	id: 'yourPerilSname',
				    title: 'Peril',
				    sortable: false,
					width: '40px',
					visible: true
				},
				{	id: 'yourPremiumAmt',
				    title: 'Premium Amount',
				    geniisysClass: 'money',
				    align: 'right',
				    titleAlign: 'right',
				    sortable: false,
					width: '110px',
					visible: true
				},
				{	id: 'yourCommissionRt',
				    title: 'Rate',
				    geniisysClass: 'rate',
				    align: 'right',
				    titleAlign: 'right',
				    sortable: false,
					width: '80px',
					visible: true
				},
				{	id: 'yourCommissionAmt',
				    title: 'Comm Amount',
				    geniisysClass: 'money',
				    align: 'right',
				    titleAlign: 'right',
				    sortable: false,
					width: '100px',
					visible: true
				},
				{	id: 'yourWholdingTax',
				    title: 'Withholding Tax',
				    geniisysClass: 'money',
				    align: 'right',
				    titleAlign: 'right',
				    sortable: false,
					width: '100px',
					visible: true
				},
				{	id: 'yourNetCommission',
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
			rows: []
		};
		
		var lpCommInvPerilTableModel2 = {
				url: contextPath + "/GIPIOrigCommInvPerilController?action=getCommInvPerils&refresh=1&policyId="+ $F("hidPolicyId"),
				options:{
					title: '',
					width: '530px',
					onCellFocus: function (element, value, x, y, id) {
						var commInvPeril = lpCommInvPerilTableGrid2.geniisysRows[y];
						$("invCommPerilDesc2").value = unescapeHTML2(commInvPeril.fullPerilName);
						lpCommInvPerilTableGrid2.releaseKeys();
					},
					onRemoveRowFocus: function (element, value, x, y, id) {
						$("invCommPerilDesc2").value = "";
						lpCommInvPerilTableGrid2.releaseKeys();
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
					{	id: 'fullPerilSname',
					    title: 'Peril',
					    sortable: false,
						width: '40px',
						visible: true
					},
					{	id: 'fullPremiumAmt',
					    title: 'Premium Amount',
					    geniisysClass: 'money',
					    align: 'right',
					    titleAlign: 'right',
					    sortable: false,
						width: '110px',
						visible: true
					},
					{	id: 'fullCommissionRt',
					    title: 'Rate',
					    geniisysClass: 'rate',
					    align: 'right',
					    titleAlign: 'right',
					    sortable: false,
						width: '80px',
						visible: true
					},
					{	id: 'fullCommissionAmt',
					    title: 'Comm Amount',
					    geniisysClass: 'money',
					    align: 'right',
					    titleAlign: 'right',
					    sortable: false,
						width: '100px',
						visible: true
					},
					{	id: 'fullWholdingTax',
					    title: 'Withholding Tax',
					    geniisysClass: 'money',
					    align: 'right',
					    titleAlign: 'right',
					    sortable: false,
						width: '100px',
						visible: true
					},
					{	id: 'fullNetCommission',
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
				rows: []
			};
		
		lpCommInvPerilTableGrid = new MyTableGrid(lpCommInvPerilTableModel);
		lpCommInvPerilTableGrid.pager = "";
		lpCommInvPerilTableGrid.render('lpCommInvPerilTableGridDiv');

		lpCommInvPerilTableGrid2 = new MyTableGrid(lpCommInvPerilTableModel2);
		lpCommInvPerilTableGrid2.pager = "";
		lpCommInvPerilTableGrid2.render('lpCommInvPerilTableGridDiv2');
		
		function populateLeadInvCommFields(obj){
			$("invCommSharePct").value = obj == null ? "" : obj.yourSharePercentage;
			$("invCommPrem").value = obj == null ? "" : formatCurrency(obj.yourPremiumAmt);
			$("invCommTotalComm").value = obj == null ? "" : formatCurrency(obj.yourCommissionAmt);
			$("invCommWholdTax").value = obj == null ? "" : formatCurrency(obj.yourWholdingTax);
			$("invCommNetComm").value = obj == null ? "" : formatCurrency(obj.yourNetPremium);
			
			$("invCommCompSharePct").value = obj == null ? "" : obj.fullSharePercentage;
			$("invCommCompPrem").value = obj == null ? "" : formatCurrency(obj.fullPremiumAmt);
			$("invCommCompTotalComm").value = obj == null ? "" : formatCurrency(obj.fullCommissionAmt);
			$("invCommCompWholdTax").value = obj == null ? "" : formatCurrency(obj.fullWholdingTax);
			$("invCommCompNetComm").value = obj == null ? "" : formatCurrency(obj.fullNetCommission);
			
			lpCommInvPerilTableGrid.url = contextPath + "/GIPIOrigCommInvPerilController?action=getCommInvPerils&refresh=1&policyId="+ (obj == null ? 0 : nvl(obj.policyId, 0))
			  							  +"&itemGrp="+(obj == null ? 0 : nvl(obj.itemGrp, 0))+"&intrmdryIntmNo="+(obj == null ? 0 : nvl(obj.fullIntmNo, 0));
			lpCommInvPerilTableGrid._refreshList();
			lpCommInvPerilTableGrid2.url = contextPath + "/GIPIOrigCommInvPerilController?action=getCommInvPerils&refresh=1&policyId="+ (obj == null ? 0 : nvl(obj.policyId, 0))
					  					  +"&itemGrp="+(obj == null ? 0 : nvl(obj.itemGrp, 0))+"&intrmdryIntmNo="+(obj == null ? 0 : nvl(obj.fullIntmNo, 0));
			lpCommInvPerilTableGrid2._refreshList();
		}
		
	}catch(e){
		showErrorMessage("Lead Policy Invoice Commission", e);
	}

</script>