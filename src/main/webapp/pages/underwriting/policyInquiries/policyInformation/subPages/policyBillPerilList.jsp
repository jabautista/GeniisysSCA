<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="policyBillPerilMainDiv">
	 <div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
				<label>Peril</label>
				<span class="refreshers" style="margin-top: 0;">
					<label id="showBillPremium" name="gro" style="margin-left: 5px">Hide</label>
				</span>
				<input type="hidden" id="policyId" name="policyId"/> 
			</div>
	</div> 
	<div id="policyBillPerilMainList"  class="sectionDiv" style="border: none;">
		<div id="policyBillPerilList" class="sectionDiv" style="border: none;">
		 	
	 <div id="policyBillPerilTableDetails" name="policyBillPerilTableDetails" class="sectionDiv" style="border: none; padding: 10px;">
		 
		<div id="policyPerilList" class="sectionDiv" style="height: 200px; border: none; margin: auto; margin-bottom: 15px;"></div> 
	</div>
		</div>
	</div>
</div>
<script type="text/javascript"> //Rey
	setModuleId("GIPIS100");
	setDocumentTitle("View Policy Information");
	 
	 try{
		var billPremiumMain= new Object();
		billPremiumMain.billPremiunMainTableGrid = JSON.parse('${billPremiumList}'.replace(/\\/g,'\\\\'));
		billPremiumMain.billPremiumMain = billPremiumMain.billPremiunMainTableGrid || [];
		
		var billPremiumTableModel={	//gzelle 06.27.2013 added url
				url: contextPath+"/GIPIPolbasicController?action=getBillPerilList&refresh=1&policyId="+encodeURIComponent($F("hidPolicyId"))
								+"&itemNo="+objItemBill.itemNo +"&itemGrp="+objItemBill.itemGrp,
				options: {
					hideColumnChildTitle: true,
					title: '',
					width: '900px',
					onCellFocus: function(element, value, x, y, id){
						var obj = policyBillList.geniisysRows[y];
					    
					},
				  	prePager: function(){
				  		//clearQuotationFields();
				  	},
					onRemoveRowFocus: function (element, value, x, y, id){
						
					},
					onRowDoubleClick: function(y){
						var row = policyBillList.geniisysRows[y];
						//quotationStatus.quoteId = row.quoteId;
						
						//isMakeQuotationInformationFormsHidden = 1;
						//$("quoteId").value = ($$("div#quotationTableGridListing .selectedRow"))[0].getAttribute("quoteId");
						//$("quoteId").value = quotationStatus.quoteId;
						//showQuotationInformation2();
					},
					onSort: function(){
						//clearQuotationFields();
					}	
				},		
				columnModel: [
				          	{   id: 'recordStatus',							    
							    width: '0',
							    visible: false,
							    editor: 'checkbox' 			
							},
							{	id: 'divCtrId',
								width: '0',
								visible: false
							},
							{	id: 'perilName',
								title: 'Peril Description',
								titleAlign: 'left',
								align: 'left',
								//sortable: false,
								width: '350px'
							},
							{	id: 'tsiAmt',
								title: 'TSI Amount',
								titleAlign: 'right',
								width: '268px',
								align: 'right',
								//sortable: false,
								geniisysClass : 'money',     
					            geniisysMinValue: '-999999999999.99',     
					            geniisysMaxValue: '999,999,999,999.99'
							},
							{	id: 'premAmt',
								title: 'Prem Amount',
								titleAlign: 'right',
								align: 'right',
								width: '270px',
								//sortable: false,
								geniisysClass : 'money',     
					            geniisysMinValue: '-999999999999.99',     
					            geniisysMaxValue: '999,999,999,999.99'
							},
				              ],
				rows: billPremiumMain.billPremiunMainTableGrid.rows //billPremiumMain.billPremiumMain          
		};
		
		policyBillList = new MyTableGrid(billPremiumTableModel);
		policyBillList.pager = billPremiumMain.billPremiunMainTableGrid;//billPremiumMain.policyBillList;
		policyBillList.render('policyPerilList');
	}catch(e){
		showErrormessage("policyBillPerilList.jsp",e);
	} 

</script>