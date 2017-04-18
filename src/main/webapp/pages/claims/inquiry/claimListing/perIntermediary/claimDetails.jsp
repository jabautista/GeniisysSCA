<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="claimDetailsDiv" style="width: 99.5%; padding-top: 5px; margin-top: 5px;">
	<table border="0" align="center" style="margin-bottom: 0px;">
		<tr>
			<td>Claim Number</td>
			<td> : </td>
			<td><input type="text" readonly="readonly" id="txtClaimNo" value="${claimNo}" style="width: 180px;" /></td>
			<td width="50px"></td>
			<td>Loss Description</td>
			<td> : </td>
			<td><input type="text" readonly="readonly" id="txtLossDesc" value="${lossCatDesc}" style="width: 180px;" /></td>
		</tr>
		<tr>
			<td>Policy Number</td>
			<td> : </td>
			<td><input type="text" readonly="readonly" id="txtPolicyNo" value="${policyNo}" style="width: 180px;" /></td>
			<td></td>
			<td>Loss Date</td>
			<td> : </td>
			<td><input type="text" readonly="readonly" id="txtLossDate" value="${lossDate}" style="width: 180px;" /></td>
		</tr>
		<tr>
			<td>Assured</td>
			<td> : </td>
			<td colspan="3"><input type="text" readonly="readonly" id="txtAssured" value="${assuredName}" style="width: 300px;" /></td>
			<td></td>
			<td class="rightAligned"><h3>${clmStatDesc}</h3></td>
		</tr>
	</table>
	<div id="claimDetailsDiv" style="width: 99.5%; padding-top: 5px; margin-top: 5px;">
		<div id="claimTable" style="height: 140px; margin-left: auto;"></div>
	</div>
	<div style="text-align: right; margin: 30px 0 0 0;">
		<label style="margin-left: 270px; margin-top: 5px;">Totals</label>
		<input type="text" id="txtTotLossReserve" readonly="readonly" style="width: 110px; text-align: right;">
		<input type="text" id="txtTotExpenseReserve" readonly="readonly" style="width: 110px; text-align: right;">
		<input type="text" id="txtTotLossesPaid" readonly="readonly" style="width: 110px; text-align: right;">
		<input type="text" id="txtTotExpensesPaid" readonly="readonly" style="width: 110px; text-align: right;">
	</div>
	<center>
		<input type="button" class="button" value="Return" id="btnReturn" style="margin-top: 15px;" /> 
	</center>
</div>
<script>
try{
	var jsonClaimDetailsPerIntermediary = JSON.parse('${jsonClaimDetailsPerIntermediary}');
	claimTableModel = {
			url : contextPath+"/GICLClaimListingInquiryController?action=showClaimDetails&refresh=1&claimId=${claimId}&perilCd=${perilCd}&itemNo=${itemNo}&lineCd=${lineCd}",
			options: {
				hideColumnChildTitle: true,
				width: '796px',
				onCellFocus : function(element, value, x, y, id) {
					tbgClaim.keys.removeFocus(tbgClaim.keys._nCurrentFocus, true);
					tbgClaim.keys.releaseKeys();
					
				},
				onRemoveRowFocus : function(element, value, x, y, id){
					tbgClaim.keys.removeFocus(tbgClaim.keys._nCurrentFocus, true);
					tbgClaim.keys.releaseKeys();
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
			  				id: 'itemNo',
			  				title: 'Item No.',
			  				width: 60
			  			},
			  			{
			  				id: 'itemTitle',
			  				title: 'Item Title',
			  				width: 250,
			  				renderer: function(value){
			  					return unescapeHTML2(value);
			  				}
			  			},
			  			{
			  				id: 'perilCd perilName',
			  				title: 'Peril',
			  				children: [
			  				          	{
			  				          		id: "perilCd",
			  				          		width: 40,
			  				          		align: 'right'
			  				          	},
			  				          	{
			  				          		id: "perilName",
			  				          		width : 180,
				  				          	renderer: function(value){
							  					return unescapeHTML2(value);
							  				}
			  				          	}
			  				]
			  			},
			  			{
			  				id: 'shrIntmPct',
			  				title: 'Share %',
			  				width: 60,
			  				align: 'right',
			  				titleAlign: 'right',
			  				renderer: function(value){
			  					return formatCurrency(value);
			  				}
			  			},
			  			{
			  				id: 'lossReserve',
			  				title: 'Loss Reserve',
			  				width: 120,
			  				align: 'right',
			  				renderer: function(value) {
			  					return formatCurrency(value);
			  				}
			  			},
			  			{
			  				id: 'expenseReserve',
			  				title: 'Expense Reserve',
			  				width: 120,
			  				align: 'right',
			  				renderer: function(value) {
			  					return formatCurrency(value);
			  				}
			  			},
			  			{
			  				id: 'lossesPaid',
			  				title: 'Losses Paid',
			  				width: 120,
			  				align: 'right',
			  				renderer: function(value) {
			  					return formatCurrency(value);
			  				}
			  			},
			  			{
			  				id: 'expensesPaid',
			  				title: 'Expenses Paid',
			  				width: 120,
			  				align: 'right',
			  				renderer: function(value) {
			  					return formatCurrency(value);
			  				}
			  			}
			 ],
			 rows: jsonClaimDetailsPerIntermediary.rows
	};
	
	tbgClaim = new MyTableGrid(claimTableModel);
	tbgClaim.pager = jsonClaimDetailsPerIntermediary;
	tbgClaim.render('claimTable');
	tbgClaim.afterRender = function(){
		var rec = tbgClaim.geniisysRows[0];
		$("txtTotLossReserve").value = formatCurrency(rec.totLossReserve);
		$("txtTotExpenseReserve").value = formatCurrency(rec.totExpenseReserve);
		$("txtTotLossesPaid").value = formatCurrency(rec.totLossesPaid);
		$("txtTotExpensesPaid").value = formatCurrency(rec.totExpensesPaid);
	};
	
	$("btnReturn").observe("click", function(){
		overlayClaimDetails.close();
		delete overlayClaimDetails;
	});
} catch (e) {
	showErrorMessage("Error : " , e.message);
}
</script>