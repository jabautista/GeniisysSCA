<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="policyPaymentSchedule">
	 <div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
				<label>Payment Schedule</label>
				<span class="refreshers" style="margin-top: 0;">
					<label id="showBillTax" name="gro" style="margin-left: 5px">Hide</label>
				</span>
				<input type="hidden" id="policyId" name="policyId"/> 
			</div>
	</div> 
	<div id="policyBillPaymentSchedule" class="sectionDiv" style="border: none;">
		<div id="policyBillPayment" class="sectionDiv" style="border: none; padding: 10px;">
		 	
	 			<div id="policyBillPaymentDetails" name="policyBillPaymentDetails" class="sectionDiv" style="border: none; margin-top: 10px; margin-bottom: 10px;">	 
				<div id="paymentSchedule" class="sectionDiv" style="border: none; height: 200px; width: 900px; margin: auto; margin-bottom: 15px;"></div> 
				<div id="totalPaymentDiv" style="border: none; float: right; margin-right: 5px;">
			   Total :    <input style="width: 145px; text-align: right; margin-left: 1px; margin-top: 15px;" type="text" id="totalShr" name="totalShr" value="" readonly="readonly"/>
						  <input style="width: 145px; text-align: right; margin-left: 1px; margin-top: 15px;" type="text" id="totalPrem" name="totalPrem" value="" readonly="readonly"/>
						  <input style="width: 145px; text-align: right; margin-left: 1px; margin-top: 15px;" type="text" id="totalTax" name="totalTax" value="" readonly="readonly"/>
						  <input style="width: 145px; text-align: right; margin-top: 15px; margin-right: 25px;" type="text" id="totalTaxDue" name="totalTaxDue" value="" readonly="readonly"/>	
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript"> //Rey
	setModuleId("GIPIS100");
	setDocumentTitle("View Policy Information");
	
	try{
		var billPaymentSchedule= new Object();
		billPaymentSchedule.billPaymentScheduleTableGrid = JSON.parse('${billPaymentSchedule}'.replace(/\\/g,'\\\\'));
		billPaymentSchedule.billPaymentSchedule = billPaymentSchedule.billTaxTableGrid || [];
		
		
		var billPaymentScheduleTableModel={		//gzelle 06.27.2013 added url 
				url: contextPath+"/GIPIPolbasicController?action=getPaymentSchedule&refresh=1&policyId="+encodeURIComponent($F("hidPolicyId"))
								+"&itemNo="+objItemBill.itemNo +"&itemGrp="+objItemBill.itemGrp,
				options: {
					hideColumnChildTitle: true,
					title: '',
					width: '900px',
					onCellFocus: function(element, value, x, y, id){
						var obj = policybillPaymentSchedule.geniisysRows[y];
					    //populateBillPremiumMain(obj);
					},
				  	prePager: function(){
				  		//clearQuotationFields();
				  	},
					onRemoveRowFocus: function (element, value, x, y, id){
						//populateBillPremiumMain(null);
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
							{	id: 'instNo',
								title: 'Inst No.',
								titleAlign: 'right',
								align: 'right',
								//sortable: false,		comment out --gzelle 06.27.2013
								width: '100px'
							},
							{	id: 'strDueDate',
								title: 'Due Date',
								align: 'left',
								//sortable: false,		comment out --gzelle 06.27.2013
								//type: 'date',
								titleAlign: 'left',
								width: '150px'
							},
							{	id: 'sharePct',
								title: '% Share',
								titleAlign: 'right',
								align: 'right',
								width: '158px',
								//sortable: false,		comment out --gzelle 06.27.2013
								geniisysClass : 'money',     
					            geniisysMinValue: '-999999999999.99',     
					            geniisysMaxValue: '999,999,999,999.99',
					            renderer: function(value){
									return formatToNineDecimal(value);
								}
							},
							{	id: 'premAmt',
								title: 'Premium Amount',
								titleAlign: 'right',
								align: 'right',
								width: '158px',
								//sortable: false,		comment out --gzelle 06.27.2013
								geniisysClass : 'money',     
					            geniisysMinValue: '-999999999999.99',     
					            geniisysMaxValue: '999,999,999,999.99'
							},
							{	id: 'taxAmt',
								title: 'Tax Amount',
								titleAlign: 'right',
								align: 'right',
								width: '158px',
								//sortable: false,		comment out --gzelle 06.27.2013
								geniisysClass : 'money',     
					            geniisysMinValue: '-999999999999.99',     
					            geniisysMaxValue: '999,999,999,999.99'
							},
							{	id: 'totalDue',
								title: 'Total Due',
								titleAlign: 'right',
								align: 'right',
								width: '158px',
								//sortable: false,		comment out --gzelle 06.27.2013
								geniisysClass : 'money',     
					            geniisysMinValue: '-999999999999.99',     
					            geniisysMaxValue: '999,999,999,999.99'
							},
				              ],
				rows: billPaymentSchedule.billPaymentScheduleTableGrid.rows           
		};
		
		policybillPaymentSchedule = new MyTableGrid(billPaymentScheduleTableModel);
		policybillPaymentSchedule.pager = billPaymentSchedule.billPaymentScheduleTableGrid;
		policybillPaymentSchedule.render('paymentSchedule');
		
	}catch(e){
		showErrormessage("policyPaymentSchedule.jsp",e);
	}  
	getTotal();
	function getTotal(){
		var totalShare = 0;
		for(var i = 0; i<billPaymentScheduleTableModel.rows.length; i++){
			var val = policybillPaymentSchedule.rows[i][policybillPaymentSchedule.getColumnIndex('sharePct')] == null || policybillPaymentSchedule.rows[i][policybillPaymentSchedule.getColumnIndex('sharePct')] == "" ? 0 : policybillPaymentSchedule.rows[i][policybillPaymentSchedule.getColumnIndex('sharePct')];
			totalShare = parseFloat(totalShare) + parseFloat(val);
		}
		 var frmTotalShr = formatToNineDecimal(totalShare);
		$("totalShr").value       = (nvl(frmTotalShr, ""));
		var totalPremAmt = 0;
		for(var i = 0; i<billPaymentScheduleTableModel.rows.length; i++){
			var val = policybillPaymentSchedule.rows[i][policybillPaymentSchedule.getColumnIndex('premAmt')] ==  null || policybillPaymentSchedule.rows[i][policybillPaymentSchedule.getColumnIndex('premAmt')] == "" ? 0 : policybillPaymentSchedule.rows[i][policybillPaymentSchedule.getColumnIndex('premAmt')];
			totalPremAmt = parseFloat(totalPremAmt) + parseFloat(val);
		}
		var frmTotalPremAmt = formatCurrency(totalPremAmt);
		$("totalPrem").value   = (nvl(frmTotalPremAmt, ""));
		var totalTaxAmt = 0;
		for(var i = 0; i<billPaymentScheduleTableModel.rows.length; i++){
			var val = policybillPaymentSchedule.rows[i][policybillPaymentSchedule.getColumnIndex('taxAmt')] ==  null || policybillPaymentSchedule.rows[i][policybillPaymentSchedule.getColumnIndex('taxAmt')] == "" ? 0 : policybillPaymentSchedule.rows[i][policybillPaymentSchedule.getColumnIndex('taxAmt')];
			totalTaxAmt = parseFloat(totalTaxAmt) + parseFloat(val);
		}
		var frmTotalTaxAmt = formatCurrency(totalTaxAmt);
		$("totalTax").value   = (nvl(frmTotalTaxAmt, ""));
		var totalTaxDue = 0;
		for(var i = 0; i<billPaymentScheduleTableModel.rows.length; i++){
			var val = policybillPaymentSchedule.rows[i][policybillPaymentSchedule.getColumnIndex('totalDue')] ==  null || policybillPaymentSchedule.rows[i][policybillPaymentSchedule.getColumnIndex('totalDue')] == "" ? 0 : policybillPaymentSchedule.rows[i][policybillPaymentSchedule.getColumnIndex('totalDue')];
			totalTaxDue = parseFloat(totalTaxDue) + parseFloat(val);
		}
		var frmTotalTaxDue = formatCurrency(totalTaxDue);
		$("totalTaxDue").value   = (nvl(frmTotalTaxDue, ""));
	}		
</script>