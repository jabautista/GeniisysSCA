<div id="policyInvoiceCommission">
	<div id="policyBillInvoiceCommission" class="sectionDiv" style="border: none;">
		<div id="policyInvoiceCommission" style= "border: none; padding-top: 10px; " class="sectionDiv">
	 		<div id="policyBillInvoiceDetails" name="policyBillInvoiceDetails" class="sectionDiv" style="border: none; margin-top: 10px; margin-bottom: 10px; padding-bottom: 10px;">
				<div id="invoiceCommission" class="sectionDiv" style="border: none; height: 200px; width: 900px; margin: auto; margin-bottom: 15px; margin-right: 15px;">
				
				</div>
				<div id="commissionDetail" class="sectionDiv" style="border:none; margin-top: 15px;">
	 				<input type="hidden" id="invDtlPremSeqNo" name="invDtlPremSeqNo"/> 
	 				<input type="hidden" id="invDtlPerilCd" name="invDtlPerilCd"/> 
	 				<input type="hidden" id="invDtlIntmNo" name="invDtlIntmNo"/> 				
					<jsp:include page="/pages/underwriting/policyInquiries/policyInformation/subPages/commissionDetails.jsp"></jsp:include>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript"> 
	try{
		var polInvoice= new Object();
		polInvoice.polInvoiceTableGrid = {};
		
		var polInvoiceTableModel={		//gzelle 06.27.2013 added url
				url: contextPath+"/GIPIPolbasicController?action=getInvoiceCommission&refresh=1&policyId="+$F("policyId")
								+"&premSeqNo="+$F("invPremSeqNo")+"&lineCd="+$F("invLineCd")+"&intmNo="+$F("invIntmNo"),		
				options: {
					title: '',
					width: '900px',
					onCellFocus: function(element, value, x, y, id){
						var obj = policyInvoiceCommission.geniisysRows[y];
						//showCommissionDetails(obj,$F("txtLineCd"),$F("txtIssCd")); //Modified by Jerome Bautista SR 21374 01.15.2016
						showCommissionDetails(obj,objUW.lineCd,objUW.issCd);
						/* $("invDtlPerilCd").value = obj.perilCd; //Commented out by Jerome Bautista SR 21374 01.21.2016
						$("invDtlPremSeqNo").value = obj.premSeqNo;
						$("invDtlIntmNo").value = obj.intmNo; */
					},
					onRemoveRowFocus: function (element, value, x, y, id){
						showCommissionDetails(null,null,null);
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
									title: 'Peril Name',
									titleAlign: 'left',
									align: 'left',
									//sortable: false,		comment out --gzelle 06.27.2013
									width: '172px'
								},
								{	id: 'premiumAmt',
									title: 'Premium Amount',
									titleAlign: 'right',
									width: '150px',
									align: 'right',
									//sortable: false,		comment out --gzelle 06.27.2013
									geniisysClass : 'money',     
								    geniisysMinValue: '-999999999999.99',     
								    geniisysMaxValue: '999,999,999,999.99'
								},
								{	id: 'wholdingTax',
									title: 'Withholding Tax',
									titleAlign: 'right',
									align: 'right',
									width: '150px',
									//sortable: false,		comment out --gzelle 06.27.2013
									geniisysClass : 'money',     
								    geniisysMinValue: '-999999999999.99',     
								    geniisysMaxValue: '999,999,999,999.99'
								},
								{	id: 'commissionRt',
									title: 'Commission Rate',
									titleAlign: 'right',
									align: 'right',
									//sortable: false,		comment out --gzelle 06.27.2013
									width: '150px',
									//geniisysClass : 'money',     //Commented out by Jerome Bautista SR 21374 01.22.2016
								    //geniisysMinValue: '-999999999999.99',     
								    //geniisysMaxValue: '999,999,999,999.99',
								    renderer: function(value){
										return formatToNineDecimal(value);
									}
								},
								{	id: 'commissionAmt',
									title: 'Commission Amount',
									titleAlign: 'right',
									align: 'right',
									//sortable: false,		comment out --gzelle 06.27.2013
									width: '150px',
									geniisysClass : 'money',     
								    geniisysMinValue: '-999999999999.99',     
								    geniisysMaxValue: '999,999,999,999.99'
								},
								{	id: 'netComAmt',
									title: 'Net Commission',
									titleAlign: 'right',
									align: 'right',
									width: '110px',
									//sortable: false,		comment out --gzelle 06.27.2013
									geniisysClass : 'money',     
								    geniisysMinValue: '-999999999999.99',     
								    geniisysMaxValue: '999,999,999,999.99'
								},
				              ],
				rows: []       
		};
		policyInvoiceCommission = new MyTableGrid(polInvoiceTableModel);
		policyInvoiceCommission.pager = polInvoice.polInvoiceTableGrid;
		policyInvoiceCommission.render('invoiceCommission');
	}catch(e){
		showErrorMessage("policyInvoiceCommissionDtls.jsp", e);
	}
</script>