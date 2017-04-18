<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="policyBillTaxMainDiv">
	 <div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
				<label>Tax</label>
				<span class="refreshers" style="margin-top: 0;">
					<label id="showBillTax" name="gro" style="margin-left: 5px">Hide</label>
				</span>
				<input type="hidden" id="policyId" name="policyId"/> 
			</div>
	</div> 
	<div id="policyBillMainTaxList" class="sectionDiv" style="border: none;">
		<div id="policyBillTaxList" style= "border: none;" class="sectiomDiv">
		 	
	 		<div id="policyBillTaxTableDetails" name="policyBillTaxTableDetails" class="sectionDiv" style="border: none; margin-top: 10px; margin-bottom: 10px; padding: 10px;">	 
				<div id="policyTaxList" class="sectionDiv" style="border: none; height: 200px; width: 900px; margin: auto; margin-bottom: 15px;"></div> 
				<div id="totalTaxDiv" style="border: none; float: right; margin: auto; margin-right: 30px;">
					Total Tax <input style="width: 210px; text-align: right; margin: auto; margin-top: 15px; margin-right: 30px;" type="text" id="taxSum" name="taxSum" value="" readonly="readonly"/>
				</div>
				
			</div>
		</div>
	</div>
</div>
<script type="text/javascript"> //Rey
	setModuleId("GIPIS100");
	setDocumentTitle("View Policy Information");
	 try{
		var billTaxList= new Object();
		billTaxList.billTaxTableGrid = JSON.parse('${billPremiumTaxList}'.replace(/\\/g,'\\\\'));
		billTaxList.billTaxList = billTaxList.billTaxTableGrid || [];
		
		var billTaxTableModel={		//gzelle 06.27.2013 added url
				url: contextPath+"/GIPIPolbasicController?action=getBillTaxList&refresh=1&policyId="+encodeURIComponent($F("hidPolicyId"))
								+"&itemNo="+objItemBill.itemNo +"&itemGrp="+objItemBill.itemGrp,
				options: {
					hideColumnChildTitle: true,
					title: '',
					width: '900px',
					onCellFocus: function(element, value, x, y, id){
						var obj = policyBillTaxList.geniisysRows[y];
					    //populateBillPremiumMain(obj);
					},
				  	prePager: function(){
				  		//clearQuotationFields();
				  	},
					onRemoveRowFocus: function (element, value, x, y, id){
						//populateBillPremiumMain(null);
					},
					onRowDoubleClick: function(y){
						//var row = policyBillList.geniisysRows[y];
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
							{	id: 'taxCd',
								title: 'Tax Cd',
								titleAlign: 'right',
								align: 'right',
								width: '200px', 
								//sortable: false,		comment out --gzelle 06.27.2013
								renderer: function(value){
									return lpad(value,2,"0");
								}
							},
							{	id: 'taxDesc',
								title: 'Description',
								titleAlign: 'left',
								//sortable: false,		comment out --gzelle 06.27.2013
								width: '400px'
							},
							{	id: 'taxAmt',
								title: 'Tax Amount',
								titleAlign: 'right',
								align: 'right',
								width: '287px',
								//sortable: false,		comment out --gzelle 06.27.2013
								geniisysClass : 'money',     
					            geniisysMinValue: '-999999999999.99',     
					            geniisysMaxValue: '999,999,999,999.99'
							},
				              ],
				rows: billTaxList.billTaxTableGrid.rows //billPremiumMain.billPremiumMain          
		};
		
		policyBillTaxList = new MyTableGrid(billTaxTableModel);
		policyBillTaxList.pager = billTaxList.billTaxTableGrid;//billPremiumMain.policyBillList;
		policyBillTaxList.render('policyTaxList');
		policyBillTaxList.afterRender = function (){
			//modified by gab 06.14.2016 SR 22310
			//$("taxSum").value = formatCurrency(nvl(billTaxList.billTaxTableGrid.rows[0].taxSum, ""));
			var val = 0;
			for(var i = 0; i<billTaxTableModel.rows.length; i++){
				var val = billTaxList.billTaxTableGrid.rows[i].taxSum;
				$("taxSum").value = formatCurrency(val);
			}
		};
	}catch(e){
		showErrormessage("policyBillTaxList.jsp",e);
	}
	
</script>