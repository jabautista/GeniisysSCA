<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="payeeDetailsDiv" name="payeeDetailsDiv" class="sectionDiv" style="height: 220px; padding: 15px 15px 15px 15px; width: 891px;">
	<div id="payeeDetailsTableGrid" name="payeeDetailsTableGrid" style="height: 220px;"></div>
</div>

<script type="text/javascript">
	var objTGPayeeInfoDetails = JSON.parse('${payeeDtlsTableGrid}'.replace(/\\/g,'\\\\'));
	var claimId = '${claimId}';
	var arrGICLS034Buttons = [MyTableGrid.REFRESH_BTN];
	try{
		var payeeInfoModel = {
			url: contextPath+"/GICLReserveSetupController?action=getPayeeDetails&refresh=1&claimId=${claimId}&adviceId=${adviceId}",
			options: {
				title: '',
	          	height: '200px',
	          	width: '888px',
	          	onCellFocus: function(element, value, x, y, id){
	          		var mtgId = payeeInfoTableGrid._mtgId;
	            	if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
	            		selectedIndex = y;
	            	}
	            	payeeInfoTableGrid.keys.releaseKeys(); // andrew - 12.14.2012
	            },
	            onRemoveRowFocus: function(){
	            	selectedIndex = -1;
	            	payeeInfoTableGrid.keys.releaseKeys();
	            },
	            onSort: function() {
	            	selectedIndex = -1;
	            },
	            onRefresh: function() {
	            	selectedIndex = -1;
	            },
	            toolbar: {
	            	elements:	(arrGICLS034Buttons)
	            }
			},
			columnModel:[
						{
							id: 'recordStatus',
						    width: '0px',
						    visible: false,
						    editor: 'checkbox' 			
						},
						{	
							id: 'divCtrId',
							width: '0px',
							visible: false
						},
						{
							id:	'payee',
							title: 'Payee',
							titleAlign: 'center',
							width: '272px'
						},
						{
							id:	'paidAmount',
							title: 'Paid Amount',
							titleAlign: 'right',
							geniisysClass: 'money',
							align: 'right',
							width: '150px'
						},
						{
							id:	'whTax',
							title: 'Witholding Tax',
							titleAlign: 'right',
							geniisysClass: 'money',
							align: 'right',
							width: '150px'
						},
						{
							id:	'evat',
							title: 'EVAT',
							titleAlign: 'right',
							geniisysClass: 'money',
							align: 'right',
							width: '150px'
						},
						{
							id:	'netAmount',
							title: 'Net Amount',
							titleAlign: 'right',
							geniisysClass: 'money',
							align: 'right',
							width: '150px'
						}
  					],
  				rows: objTGPayeeInfoDetails.rows,
  				id: 1115
		};
		payeeInfoTableGrid = new MyTableGrid(payeeInfoModel);
		payeeInfoTableGrid.pager = objTGPayeeInfoDetails;
		payeeInfoTableGrid.render('payeeDetailsTableGrid');
	}catch(e){
		showMessageBox("Error in Payee Details: " + e, imgMessage.ERROR);		
	}
</script>