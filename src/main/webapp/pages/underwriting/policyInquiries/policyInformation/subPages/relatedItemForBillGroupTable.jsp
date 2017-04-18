<div id="polItemForBillGroupTableGridSectionDiv" class="sectionDiv" style=" border: none; width: 900px; margin: auto; margin-bottom: 10px;">
		<div id="polItemForBillGroupTableGridDiv" class="sectionDiv" style="border: none; padding:10px;">
			<div id="polItemForBillGroupListing" class="sectionDiv" style="border: none; height: 250px; width: 900px; margin: auto; margin-bottom: 20px;"></div>
			<div id="billDetailDiv" style="border: none; width: 900px; margin: auto; margin-bottom: 10px;" class="sectionDiv">
			<table style="margin: auto; margin-top: 10px; margin-bottom: 10px;" border="0">
			<tr>
				<td class="rightAligned">Bill No.</td>
				<td class="leftAligned" colspan="2">
					<input style="width: 200px; text-align: left;" type="text" id="billNo" name="billNo" value="" readonly="readonly"/>
				</td>
				<td class="rightAligned">Invoice Ref. No.</td>
				<td class="leftAligned" colspan="2">
					<input style="width: 210px; text-align: left;" type="text" id="invRefNo" name="invRefNo" value="" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Pay Term</td>
				<td class="leftAligned" colspan="2">
					<input style="width: 200px; text-align: left;" type="text" id="paytTerms" name="paytTerms" value="" readonly="readonly"/>
				</td>
				<td class="rightAligned">Property</td>
				<td class="leftAligned" colspan="2">
					<input style="width: 210px; text-align: left;" type="text" id="property" name="property" value="" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Due Date</td>
				<td class="leftAligned" colspan="2">
					<input style="width: 200px; text-align: left;" type="text" id="dueDate" name="dueDate" value="" readonly="readonly"/>
				</td>
				<td class="rightAligned">Other Charges</td>
				<td class="leftAligned" colspan="2">
					<input style="width: 210px; text-align: right;" type="text" id="otherCharges" name="otherCharges" value="" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Currency</td>
				<td class="leftAligned" colspan="2">
					<input style="width: 180px; text-align: left;" type="text" id="currencyDesc" name="currencyDesc" value="" readonly="readonly"/>
					<input type="checkbox" style="width: 20px;" id="policyCurrency" name="policyCurrency" value="" disabled="disabled" readonly="readonly"/>
				</td>
				<td class="rightAligned">Multi-Booking Date</td>
				<td class="leftAligned" colspan="2">
					<input style="width: 210px; text-align: left;" type="text" id="multiBookingDt" name="multiBookingDt" value="" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Prem Amount</td>
				<td class="leftAligned" colspan="2">
					<input style="width: 200px; text-align: right;" type="text" id="annPremAmt" name="annPremAmt" value="" readonly="readonly"/>
				</td>
				<td class="rightAligned">Tax Amount</td>
				<td class="leftAligned" colspan="2">
					<input style="width: 210px; text-align: right;" type="text" id="taxAmt" name="taxAmt" value="" readonly="readonly"/>
				</td>
			</tr>
			<!-- nieko 07252016 SR 5463, KB 2990 --> 
			<tr>
				<td class="rightAligned">Comm. Amount</td>
				<td class="leftAligned" colspan="2">
					<input style="width: 200px; text-align: right;" type="text" id="riCommAmt" name="riCommAmt" value="" readonly="readonly"/>
				</td>
				<td class="rightAligned">RI Comm Vat</td>
				<td class="leftAligned" colspan="2">
					<input style="width: 210px; text-align: right;" type="text" id="riCommVat" name="riCommVat" value="" readonly="readonly"/>
				</td>
			</tr>
			<!-- nieko 07252016 end -->
			<tr>
				<td class="rightAligned">Amount Due</td>
				<td class="leftAligned" colspan="2">
					<input style="width: 200px; text-align: right;" type="text" id="amountDue" name="amountDue" value="" readonly="readonly"/>
				</td>
				<td class="rightAligned">Acct. Ent. Date</td>
					<td class="leftAligned" colspan="2">
					<input style="width: 210px; text-align: left;" type="text" id="acctEntDt" name="acctEntDt" value="" readonly="readonly"/>
				</td>
		   </tr>
		   <tr>
				<td class="rightAligned">Remarks</td>
				<td class="leftAligned" colspan="5">
					<!-- nieko 07252016 SR 5463, KB 2990 -->
					<!-- <input style="width: 549px;" type="text" id="remarks" name="remarks" value="" readonly="readonly"/>-->
					<textArea id="remarks" name="remarks" style="width:94%; height: 13px; resize: none;" readonly="readonly"/></textArea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" id="textBillRemarks" class="hover" />
					<!-- nieko 07252016 end -->
				</td>
			</tr>
		</table> 
		</div>
	</div>
</div>

<script>
	
	objItemBill = new Object();
	objItemBill.objItemBillListTableGrid = JSON.parse('${gipiRelatedItemBillTableGrid}'.replace(/\\/g, '\\\\'));
	objItemBill.objItemBillList = objItemBill.objItemBillListTableGrid.rows || [];
	
	var iss = "";
	try{
		var itemBillTableModel = {	// --gzelle 06.27.2013 added parameter pageCalling
			url:contextPath+"/GIPIItemMethodController?action=refreshRelatedItemInfo&refresh=1&pageCalling=policyBillGroup&policyId="+$F("hidPolicyId"),
			options:{
					title: '',
					width: '900px',
					onCellFocus: function(element, value, x, y, id){
						var obj = itemBillTableGrid.geniisysRows[y];
						populateBillPremiumMain(obj);
						showBillPerilPage(obj);
						showBillTaxPage(obj);						
						showPaymentSchedule(obj);
						iss = obj.issCd;
						if(iss == 'RI'){
							showMessageBox("Invoice Commission is not available for Reinsurance",imgMessage.INFO);
						}
						else{
							showInvoiceCommission(obj);
						}
						showDiscountSurcharge2(obj);
						setParameters(obj);
						itemBillTableGrid.keys.removeFocus(itemBillTableGrid.keys._nCurrentFocus, true);
						itemBillTableGrid.keys.releaseKeys();	
					},
					onRemoveRowFocus: function (element, value, x, y, id){
						populateBillPremiumMain(null);
						showBillPerilPage(null); // marco - 09.05.2012 - included functions to clear other details
						showBillTaxPage(null);						
						showPaymentSchedule(null);
						showDiscountSurcharge2(null);
						if(iss != "RI"){
							showInvoiceCommission(null);
						}
						setParameters(null);
					},
					onSort: function() {
						populateBillPremiumMain(null);
						showBillPerilPage(null); 
						showBillTaxPage(null);						
						showPaymentSchedule(null);
						showDiscountSurcharge2(null);
						if(iss != "RI"){
							showInvoiceCommission(null);
						}
						setParameters(null);
					}
			},
			columnModel:[
			 		{   id: 'recordStatus',
					    title: '',
					    width: '0px',
					    visible: false,
					    editor: 'checkbox' 			
					},
					{	id: 'divCtrId',
						width: '0px',
						visible: false
					},
					{
						id: 'itemGrp',
						title: 'Group',
						width: '80px',
						titleAlign: 'left',
						visible: true,
						align: 'left',
						//sortable: false,		comment out --gzelle 06.27.2013
						renderer: function(value){
							return lpad(value.toString(),5,"0");
						}
					},
					{	id: 'itemNo',
						title: 'Item No.',
						//sortable: false,		comment out --gzelle 06.27.2013
						width: '80px',
						renderer: function(value){
							return lpad(value.toString(),9,"0");
						}
					},
					{	id: 'itemTitle',
						title: 'Item Title',
						//sortable: false,		comment out --gzelle 06.27.2013
						width: '200px'
					},
					{	id: 'tsiAmt',
						title: 'TSI Amount',
						width: '150px',
						titleAlign: 'right',
						align: 'right',
						//sortable: false,		comment out --gzelle 06.27.2013
						geniisysClass : 'money',     
			            geniisysMinValue: '-999999999999.99',     
			            geniisysMaxValue: '999,999,999,999.99'
					},
					{	id: 'premAmt',
						title: 'Premium Amount',
						titleAlign: 'right',
						width: '150px',
						align: 'right',
						//sortable: false,		comment out --gzelle 06.27.2013
						geniisysClass : 'money',     
			            geniisysMinValue: '-999999999999.99',     
			            geniisysMaxValue: '999,999,999,999.99'
					},
					{	id: 'currencyDesc',
						title: 'Currency',
						//sortable: false,		comment out --gzelle 06.27.2013
						width: '220px'
					},
					{	id: 'premAmt',
						title: '',
						visible: false,
						width: '0px'
					},
					{	id: 'remarks', //nieko 07252016 SR 5463, KB 2990 
						title: '',
						visible: false,
						width: '0px'
					}
			],
			rows:objItemBill.objItemBillList
		};
	
		itemBillTableGrid = new MyTableGrid(itemBillTableModel);
		itemBillTableGrid.pager = objItemBill.objItemBillListTableGrid;
		itemBillTableGrid.render('polItemForBillGroupListing');
		
		function setParameters(obj) {		// --gzelle 06.27.2013
			objItemBill.itemNo  	= obj == null ? "" : obj.itemNo;
			objItemBill.itemGrp 	= obj == null ? "" : obj.itemGrp;
			objItemBill.premSeqNo 	= obj == null ? "" : obj.premSeqNo;
			objItemBill.lineCd 		= obj == null ? "" : obj.lineCd;
		}
	}catch(e){
		showMessageBox(e.message, "E");
	}
	
	//nieko 07252016 SR 5463, KB 2990
	$("textBillRemarks").observe("click", function () {
		showEditor5("remarks", 4000, 'true');
	});
</script>