<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="bondBillMainDiv">
	 <div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
				<label>Bond Bill</label>
				<span class="refreshers" style="margin-top: 0;">
					<label id="showBillTax" name="gro" style="margin-left: 5px">Hide</label>
				</span>
				<input type="hidden" id="policyId" name="policyId"/> 
			</div>
	</div> 
		<div id="bondBillOuterDiv" class="sectionDiv" style="border: none;">
			<div id="bondBillInnerDiv" style= "border: none;" class="sectionDiv"> <!-- edited hdrtagudin 07222015 SR 19824 -->
				<div id="bondBillDetailDiv" name="bondBillDetailDiv" class="sectionDiv" style="border: none; margin-top: 10px; margin-bottom: 10px;">		
				</div>	 	
	 			<div id="bondBillTaxListDiv" name="bondBillTaxListDiv" class="sectionDiv" style="border: none; margin-top: 10px; margin-bottom: 10px; padding: 10px;">	 
					<div id="bondBillList" class="sectionDiv" style="border: none; height: 200px; width: 900px; margin: auto; margin-bottom: 15px;"></div> 		
					<div class="sectionDiv" style="border: 0;">
						<table border="0" style="margin: auto; margin-top: 10px; margin-bottom: 10px;">
							<tr>
								<td class="rightAligned" style="width: 120px;"></td>
								<td class="rightAligned" style="width: 120px;"></td>
								<td class="rightAligned" style="width: 120px;"></td>
								<td class="rightAligned" style="width: 120px;"></td>
								<td class="rightAligned" style="width: 120px;">Total :</td>
								<td class="leftAligned">
									<input type="text" id="totalTax" name="totalTax" value="" style="width: 230px; text-align: right;" readonly="readonly">
								</td>
							</tr>
						</table>
					</div>
				</div>
			</div>
		</div>
		<!--START hdrtagudin 07232015 SR 19824 -- Commission Details -->
		<div style="margin:0 auto 20px auto;" align="center">
			<input id="commissionBtn" name="commissionBtn" type="button" class="button" value="Commission" readonly="readonly"/>
		</div>
		<div id="policyInvoiceCommission" name="policyInvoiceCommission" style="border: none;"></div>
		<!--END hdrtagudin 07232015 SR 19824 -- Commission Details -->
</div>
<script type="text/javascript">
	//initializeAccordion();
	getBondDetails('${policyId}');		//hdrtagudin 07232015 SR 19824

//added by hdrtagudin 07232015 SR 19824			
function getBondDetails(policyId){
			new Ajax.Updater("bondBillDetailDiv","GIPIPolbasicController?action=getBondDetails",{
				method: "POST",
				evalScripts: true,
				parameters:{
					policyId: policyId
				}
			});
}
	try{
		var bondTaxlist = new Object();
		bondTaxlist.bondTaxlistTableGrid = JSON.parse('${bondBillTaxList}'.replace(/\\/g,'\\\\'));
		bondTaxlist.bondBillTaxlist = bondTaxlist.bondTaxlistTableGrid || [];
		
		var bondTaxlistTableModel = {
				url: contextPath+"/GIPIPolbasicController?action=getBondBill&refresh=1&policyId="+encodeURIComponent($F("policyId")),
				options: {
					title: '',
					width: '900px'
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
								{
									id: 'taxCd',
									title: 'Tax Code',
									width: '200px',
									align: 'right',
									titleAlign: 'right',
									renderer: function(value){
										return lpad(value,2,"0");
									}
								},
								{
									id: 'taxDesc',
									title: 'Tax Description',
									width: '460px'
								},
								{
									id: 'taxAmt',
									title: 'Tax Amount',
									width: '230px',
									titleAlign: 'right',
									align: 'right',
									sortable: false,
									geniisysClass : 'money',     
						            geniisysMinValue: '-999999999999.99',     
						            geniisysMaxValue: '999,999,999,999.99'
								}
				              ],
				        rows: bondTaxlist.bondTaxlistTableGrid.rows				
		};
		bondBillTaxlist = new MyTableGrid(bondTaxlistTableModel);	
		bondBillTaxlist.pager = bondTaxlist.bondTaxlistTableGrid;
		bondBillTaxlist.render('bondBillList');
	}
	catch(e){
		showErrorMessage("bondBillDetails.jsp",e);
	}
	getTotalTax();
function getTotalTax(){
	var totalTax = 0;
	for(var i = 0; i<bondTaxlistTableModel.rows.length; i++){
		var val = bondBillTaxlist.rows[i][bondBillTaxlist.getColumnIndex('taxAmt')] == null || bondBillTaxlist.rows[i][bondBillTaxlist.getColumnIndex('taxAmt')] == "" ? 0 : bondBillTaxlist.rows[i][bondBillTaxlist.getColumnIndex('taxAmt')];
		totalTax = parseFloat(totalTax) + parseFloat(val);
	}
	 var frmTotalTax = formatCurrency(totalTax);
	$("totalTax").value       = (nvl(frmTotalTax, ""));
}
</script>
