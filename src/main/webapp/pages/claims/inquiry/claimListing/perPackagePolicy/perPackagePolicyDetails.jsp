<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="perPackagePolicyMainDiv" name="perPackagePolicyMainDiv">
	<div class="sectionDiv">
		<div id="perPackagePolicyTableDiv" style="padding: 10px 0 10px 10px;">
			<div id="perPackagePolicyTable" style="height: 200px"></div>
		</div>
	</div>
</div>
<script type="text/javascript">
	//var jsonClaimAdvice = JSON.parse('${jsonClaimAdvice}');	
	perColorTableModel = {
			url : contextPath+"/GICLClaimInquiryListingController?action=showClmListingPerPackagePolicy",
			options: {
				toolbar: {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
				},
				width: '900px',
				pager: {
				},
				onCellFocus : function(element, value, x, y, id) {

				},
				prePager: function(){

				},
				onRemoveRowFocus : function(element, value, x, y, id){					

				},
				afterRender : function (){
					
				},
				onSort : function(){
							
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
					id : "r",
					title: "R",
					width: '20px'
				},				
				{
					id : "claimNo",
					title: "Claim Number",
					width: '320px'
				},
				{
					id : "lossReserve",
					title: "Loss Reserve",
					width: '140px'
				},
				{
					id : "expenseReserve",
					title: "Expense Reserve",
					width: '140px'
				},
				{
					id : "lossesPaid",
					title: "Losses Paid",
					width: '140px'
				},
				{
					id : "expensesPaid",
					title: "Expenses Paid",
					width: '140px'
				}
				
			],
			rows: []
		};
	
	tbgClaimsPerColor = new MyTableGrid(perColorTableModel);
	tbgClaimsPerColor.pager = null;
	tbgClaimsPerColor.render('perPackagePolicyTable');
</script>