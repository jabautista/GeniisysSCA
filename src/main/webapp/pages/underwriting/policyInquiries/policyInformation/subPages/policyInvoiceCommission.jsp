<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="policyInvoiceCommission">
	 <div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
				<label>Invoice Commission</label>
				<span class="refreshers" style="margin-top: 0;">
					<label id="showBillTax" name="gro" style="margin-left: 5px">Hide</label>
				</span>
				<input type="hidden" id="policyId" name="policyId"/> 
			</div>
	</div> 
	<div id="policyBillInvoiceCommission" class="sectionDiv" style="border: none;">
		<div id="policyInvoiceCommission" style= "border: none; padding: 10px; padding-bottom: 0px;" class="sectionDiv">
	 		<div id="policyBillInvoiceDetails" name="policyBillInvoiceDetails" class="sectionDiv" style="border: none; margin-top: 10px;">
	 			<div id="intermediaryTGDiv" class="sectionDiv" style="border: none; height: 200px; width: 900px; margin: auto; margin-bottom: 15px;">
	 			
	 			</div>
	 			<div id="invoiceCommDtls" name="invoiceCommDtls">
	 				<input type="hidden" id="invPremSeqNo" name="invPremSeqNo"/> 
	 				<input type="hidden" id="invLineCd" name="invLineCd"/> 
	 				<input type="hidden" id="invIntmNo" name="invIntmNo"/> 
					<jsp:include page="/pages/underwriting/policyInquiries/policyInformation/subPages/policyInvoiceCommissionDtls.jsp"></jsp:include>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript"> 
	setModuleId("GIPIS100");
	setDocumentTitle("View Policy Information");
	
	var lineCd = '${lineCd}';
	var selectedIntmRow = "";
	
	var polIntm = new Object();
	polIntm.polIntmTableGrid = JSON.parse('${invoiceIntmTableGrid}');
	polIntm.polIntmRows = polIntm.polIntmTableGrid.rows || [];
	
	try{
		var polIntmModel={		// --gzelle 06.27.2013 - added parameters
			url: contextPath+"/GIPIPolbasicController?action=getInvoiceIntermediaries&refresh=1&policyId="+encodeURIComponent($F("hidPolicyId"))
							+"&premSeqNo="+objItemBill.premSeqNo +"&lineCd="+objItemBill.lineCd,				
			options: {
				title: '',
				width: '900px',
				onCellFocus: function(element, value, x, y, id){
					selectedIntmRow = polIntmTableGrid.geniisysRows[y];
					showIntmComm(selectedIntmRow.policyId, selectedIntmRow.premSeqNo, lineCd, selectedIntmRow.intmNo);
					prepareParams(selectedIntmRow);
					$("invLineCd").value = lineCd;
				},
				onRemoveRowFocus: function (){
					selectedIntmRow = "";
					showIntmComm(0, 0, null, 0);
					showCommissionDetails(null,null,null);
					prepareParams(null);
				},
				onSort: function() {
					selectedIntmRow = "";
					showIntmComm(0, 0, null, 0);
					showCommissionDetails(null,null,null);
					prepareParams(null);
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
							{	id: 'intmNo',
								title: 'Intm. No.',
								width: '75px'//,		comment out --gzelle 06.27.2013
								//sortable: false
							},
							{	id: 'intmName',
								title: 'Intm. Name',
								width: '200px'//,		comment out --gzelle 06.27.2013
								//sortable: false
							},
							{	id: 'refIntmCd',
								title: 'Ref. Intm. Code',
								width: '100px'//,		comment out --gzelle 06.27.2013
								//sortable: false
							},
							{	id: 'parentIntmNo',
								title: 'Prnt. Intm. No.',
								width: '100px'//,		comment out --gzelle 06.27.2013
								//sortable: false
							},
							{	id: 'sharePercentage',
								title: 'Share Percentage',
								titleAlign: 'center',
								geniisysClass: 'rate',
								align: 'right',
								width: '125px'//,		comment out --gzelle 06.27.2013
								//sortable: false
							},
							{	id: 'sharePrem',
								title: 'Share of Premium',
								titleAlign: 'center',
								geniisysClass: 'money',
								align: 'right',
								width: '125px'//,		comment out --gzelle 06.27.2013
								//sortable: false
							},
							{	id: 'totalCommission',
								title: 'Total Commission',
								titleAlign: 'center',
								geniisysClass: 'money',
								align: 'right',
								width: '125px'//,		comment out --gzelle 06.27.2013
								//sortable: false
							},
							{	id: 'totalTaxWholding',
								title: 'Total Tax Witheld',
								titleAlign: 'center',
								geniisysClass: 'money',
								align: 'right',
								width: '125px'//,		comment out --gzelle 06.27.2013
								//sortable: false
							},
							{	id: 'netComAmt',
								title: 'Net Commission',
								titleAlign: 'center',
								geniisysClass: 'money',
								align: 'right',
								width: '125px'//,		comment out --gzelle 06.27.2013
								//sortable: false
							},
							{	id: 'policyId',
								title: '',
								width: '0px',
								visible: false
							},
							{	id: 'premSeqNo',
								title: '',
								width: '0px',
								visible: false
							}
			             ],
						rows: polIntm.polIntmRows
			};	
		polIntmTableGrid = new MyTableGrid(polIntmModel);
		polIntmTableGrid.pager = polIntm.polIntmTableGrid;
		polIntmTableGrid.render('intermediaryTGDiv');
		
		function showIntmComm(policyId, premSeqNo, lineCd, intmNo){
			policyInvoiceCommission.url = contextPath+"/GIPIPolbasicController?action=getInvoiceCommission&refresh=1&policyId="+policyId+
											"&premSeqNo="+premSeqNo+"&lineCd="+lineCd+"&intmNo="+intmNo;
			policyInvoiceCommission._refreshList();
		}
		
		function prepareParams(obj) {	//gzelle 06.27.2013
			$("policyId").value 	= obj == null ? "" : selectedIntmRow.policyId;
			$("invPremSeqNo").value = obj == null ? "" : selectedIntmRow.premSeqNo;
			$("invIntmNo").value 	= obj == null ? "" : selectedIntmRow.intmNo;
		}
	}catch(e){
		showErrormessage("policyInvoiceCommission.jsp",e);
	}
</script>