<div id="leadInvoiceDiv" style="height:156px;width:810px;margin:10px auto 10px auto;">
	<input type="hidden" id="hidPolLeadInvoicePolicyId" name="hidPolLeadInvoicePolicyId"/>
	<input type="hidden" id="hidPolLeadInvoiceItemGrp" name="hidPolLeadInvoiceItemGrp"/>
	<div id="policyLeadInvoiceDiv" style="margin-bottom:10px;">
		<div id="policyLeadInvoiceListing" style="height:156px;"></div>
	</div>
	<div id="invoiceContentDiv">
		<div>
			<div id="youInvoiceDiv" class="sectionDiv" style="width:393px;height:220px;padding:5px;">
				<div id="" class="toolbar">
					<center id="" style="margin:2.5px auto auto auto;font-weight:bold;">Your Share</center>
				</div>
				<div>
					<table style="margin:10px auto 5px auto;">
					<tr>
						<td>Ref. Inv. No.</td>
						<td>
							<input type="text" id="txtYourRefInvNo" name="txtYourRefInvNo" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<div style="height:10px;"></div>
						</td>
					</tr>
					<tr>
						<td>Premium</td>
						<td>
							<input type="text" id="txtYourInvPremium" name="txtYourInvPremium" readonly="readonly" style="text-align: right;"/>
						</td>
					</tr>
					<tr>
						<td>Total Tax</td>
						<td>
							<input type="text" id="txtYourInvTotalTax" name="txtYourInvTotalTax" readonly="readonly" style="text-align: right;"/>
						</td>
					</tr>
					<tr>
						<td>Other Charges</td>
						<td>
							<input type="text" id="txtYourOtherCharges" name="txtYourOtherCharges" readonly="readonly" style="text-align: right;"/>
						</td>
					</tr>
					<tr>
						<td>Amount Due</td>
						<td>
							<input type="text" id="txtYourInvAmountDue" name="txtYourInvAmountDue" readonly="readonly" style="text-align: right;"/>
						</td>
					</tr>
					<tr>
						<td>Currency</td>
						<td>
							<input type="text" id="txtYourInvCurrency" name="txtYourInvCurrency" readonly="readonly"/>
						</td>
					</tr>
					</table>
				</div>
			</div>
			<div id="fullInvoiceDiv" class="sectionDiv" style="width:393px;height:220px;padding:5px;">
				<div id="" class="toolbar">
					<center id="" style="margin:2.5px auto auto auto;font-weight:bold;">Full Share</center>
				</div>
				<div>
					<table style="margin:10px auto 5px auto;">
					<tr>
						<td>Ref. Inv. No.</td>
						<td>
							<input type="text" id="txtFullRefInvNo" name="txtFullRefInvNo" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<div style="height:10px;"></div>
						</td>
					</tr>
					<tr>
						<td>Premium</td>
						<td>
							<input type="text" id="txtFullInvPremium" name="txtFullInvPremium" readonly="readonly" style="text-align: right;"/>
						</td>
					</tr>
					<tr>
						<td>Total Tax</td>
						<td>
							<input type="text" id="txtFullInvTotalTax" name="txtFullInvTotalTax" readonly="readonly" style="text-align: right;"/>
						</td>
					</tr>
					<tr>
						<td>Other Charges</td>
						<td>
							<input type="text" id="txtFullOtherCharges" name="txtFullOtherCharges" readonly="readonly" style="text-align: right;"/>
						</td>
					</tr>
					<tr>
						<td>Amount Due</td>
						<td>
							<input type="text" id="txtFullInvAmountDue" name="txtFullInvAmountDue" readonly="readonly" style="text-align: right;"/>
						</td>
					</tr>
					<tr>
						<td>Currency</td>
						<td>
							<input type="text" id="txtFullInvCurrency" name="txtFullInvCurrency" readonly="readonly"/>
						</td>
					</tr>
					</table>
				</div>
			</div>
		</div>
	
		<div style="float:left;width:810px;margin:20px auto 20px auto;">
			<div style="text-align:center;">
				<input type="button" id="btnReturnToLeadOverlay" name="btnReturnToLeadOverlay" class="button" value="Return" style="width:130px"/>
				<input type="button" id="btnTaxes" name="btnTaxes" class="button" value="Taxes" style="width:130px"/>
				<input type="button" id="btnPerilDistribution" name="btnPerilDistribution" class="button" value="Peril Distribution" style="width:130px"/>
				<input type="button" id="btnInvoiceCommission" name="btnInvoiceCommission" class="button" value="Invoice Commission" style="width:130px"/>
			</div>
		</div>
	</div>
	<div id="taxContentDiv" style="float:left;width:810px;"></div>
	<div id="perilContentDiv" style="float:left;width:810px;"></div>
	<div id="invCommContentDiv" style="float:left;width:810px;"></div>
</div>
<script>

	//initialization
	var objPolicyLeadInvoice = new Object();
	objPolicyLeadInvoice.objPolicyLeadInvoiceListTableGrid = JSON.parse('${leadInvoiceList}'.replace(/\\/g, '\\\\'));
	objPolicyLeadInvoice.objPolicyLeadInvoiceList = objPolicyLeadInvoice.objPolicyLeadInvoiceListTableGrid.rows || [];
	
	try{
		var policyLeadInvoiceTableModel = {
			url:contextPath+"/GIPIInvoiceController?action=showPremiumColl"+
			"&policyId="+$F("hidPolicyId")+
			"&refresh=1",
			options:{
					title: '',
					width: '810',
					onCellFocus: function(element, value, x, y, id){

						loadInvoiceInfo(policyLeadInvoiceTableGrid.geniisysRows[y]);
						
						loadInvTaxTableGrid(policyLeadInvoiceTableGrid.geniisysRows[y].policyId,
								policyLeadInvoiceTableGrid.geniisysRows[y].itemGrp);
						loadInvPerilsTableGrid(policyLeadInvoiceTableGrid.geniisysRows[y].policyId,
								policyLeadInvoiceTableGrid.geniisysRows[y].itemGrp);
						loadInvoiceCommissionsTableGrid(policyLeadInvoiceTableGrid.geniisysRows[y].policyId,
								policyLeadInvoiceTableGrid.geniisysRows[y].itemGrp);
						policyLeadInvoiceTableGrid.releaseKeys();
						
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						unloadInvoiceInfo();
						unloadAllInvoiceTableGrid();
						policyLeadInvoiceTableGrid.releaseKeys();
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
						id: 'policyId',
						title: 'Policy id',
						width: '0px',
						visible: false
					},
					{
						id: 'itemGrp',
						title: 'Item Group',
						width: '76%',
						visible: true
					},
					{
						id: 'insured',
						title: 'Insured',
						width: '360%',
						visible: true
					},
					{
						id: 'property',
						title: 'Property',
						width: '360%',
						visible: true
					},
					
			],
			rows:objPolicyLeadInvoice.objPolicyLeadInvoiceList
		};

		policyLeadInvoiceTableGrid = new MyTableGrid(policyLeadInvoiceTableModel);
		policyLeadInvoiceTableGrid.render('policyLeadInvoiceListing');
	}catch(e){
		showErrorMessage("Lead Policy Invoice", e);
	}

	if( policyLeadInvoiceTableGrid.geniisysRows.length > 0){
		$("hidPolLeadInvoicePolicyId").value = policyLeadInvoiceTableGrid.geniisysRows[0].policyId;
		$("hidPolLeadInvoiceItemGrp").value = policyLeadInvoiceTableGrid.geniisysRows[0].itemGrp;
	}
	
	//tablegrid-option functions definition
	function loadInvoiceInfo(invoice){
		
		try{
			$("txtYourRefInvNo").value		= invoice.refInvNo;
			$("txtYourInvPremium").value	= formatCurrency(invoice.premAmt);
			$("txtYourInvTotalTax").value	= formatCurrency(invoice.taxAmt);
			$("txtYourOtherCharges").value	= formatCurrency(invoice.otherCharges);
			$("txtYourInvCurrency").value	= unescapeHTML2(invoice.currencyDesc);

			$("txtFullRefInvNo").value		= invoice.origRefInvNo;
			$("txtFullInvPremium").value	= formatCurrency(invoice.origPremAmt);
			$("txtFullInvTotalTax").value	= formatCurrency(invoice.origTaxAmt);
			$("txtFullOtherCharges").value	= formatCurrency(invoice.origOtherCharges);
			$("txtFullInvCurrency").value	= unescapeHTML2(invoice.origCurrencyDesc);

			$("hidPolLeadInvoicePolicyId").value = policyLeadInvoiceTableGrid.geniisysRows[policyLeadInvoiceTableGrid.getCurrentPosition()[1]].policyId;
			$("hidPolLeadInvoiceItemGrp").value = policyLeadInvoiceTableGrid.geniisysRows[policyLeadInvoiceTableGrid.getCurrentPosition()[1]].itemGrp;
			
			$("txtYourInvAmountDue").value = formatCurrency(invoice.amountDue);
			$("txtFullInvAmountDue").value = formatCurrency(invoice.origAmountDue);
		}catch(e){
			showErrorMessage("loadInvoiceInfo", e);
		}
		
	}

	function unloadInvoiceInfo(){
		
		try{
			$("txtYourRefInvNo").value		= "";
			$("txtYourInvPremium").value	= "";
			$("txtYourInvTotalTax").value	= "";
			$("txtYourOtherCharges").value	= "";
			$("txtYourInvCurrency").value	= "";
	
			$("txtFullRefInvNo").value		= "";
			$("txtFullInvPremium").value	= "";
			$("txtFullInvTotalTax").value	= "";
			$("txtFullOtherCharges").value	= "";
			$("txtFullInvCurrency").value	= "";

			
			
		}catch(e){}
	}

	function unloadAllInvoiceTableGrid(){
		if($("invTaxTableDiv") != null){$("invTaxTableDiv").innerHTML	= "";}
		if($("invPerilsTableDiv") != null){$("invPerilsTableDiv").innerHTML	= "";}
		
	}
	
	//button actions
	$("btnReturnToLeadOverlay").observe("click", function(){
		$("leadPolicyDiv").show();
		$("leadPolicyInvoice").hide();
	});
	
	$("btnTaxes").observe("click", function(){
		
		if($("invTaxDiv") == null){
			new Ajax.Updater("taxContentDiv","GIPIOrigInvTaxController?action=showInvTaxes",{
				method:"get",
				evalScripts: true
						
			});

		}		
		$("taxContentDiv").show();
		$("invoiceContentDiv").hide();
		
	});

	$("btnPerilDistribution").observe("click", function(){
		
		if($("invPerilDiv") == null){
			new Ajax.Updater("perilContentDiv","GIPIOrigInvPerlController?action=showInvPerils",{
				method:"get",
				evalScripts: true
						
			});

		}		
		$("perilContentDiv").show();
		$("invoiceContentDiv").hide();
		
	});

	$("btnInvoiceCommission").observe("click", function(){
		
		if($("invCommDiv") == null){
			new Ajax.Updater("invCommContentDiv","GIPIOrigCommInvoiceController?action=showInvoiceCommissions",{
				method:"get",
				evalScripts: true
						
			});

		}		
		$("invCommContentDiv").show();
		$("invoiceContentDiv").hide();
		
	});
	
</script>