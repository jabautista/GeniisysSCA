<div id="commInvoiceDiv" class="" style="width: 785px; margin: 5px 0;">
	<div class="sectionDiv" style="padding: 10px;">
		<table align="center" border="0" style="border-spacing: 0; border-collapse: collapse;">
			<tr>
				<td class="rightAligned">
					<label for="txtInvoiceIssCd" style="float: none;">Invoice No.</label>
				</td>
				<td style="padding-left: 5px;" width="110px">
					<div>
						<input type="text" id="txtInvoiceIssCd" style="width: 30px; float: left;" readonly="readonly"/>
						<input type="text" id="txtInvoicePremSeqNo" style="width: 60px; margin-left: 3px; text-align: right;" readonly="readonly"/>
					</div>					
				</td>
				<td class="rightAligned" width="60px">
					<label for="txtAssured" style="float: none;">Assured</label>
				</td>
				<td style="padding-left: 5px;" colspan="3">
					<input type="text" id="txtAssured" style="width: 407px;" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">
					<label for="txtTotPremium" style="float: none; ">Total Premium</label>
				</td>
				<td style="padding-left: 5px;" colspan="3">
					<input type="text" id="txtTotPremium" readonly="readonly" style="width: 220px; text-align: right;"/>
				</td>
				<td class="rightAligned" width="100px">
					<label for="txtSharePercentage" style="float: none;">Share Percent</label>
				</td>
				<td style="padding-left: 5px;" width="220px">
					<input type="text" id="txtSharePercentage" readonly="readonly" style="width: 220px; text-align: right;"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">
					<label for="txtTotComm" style="float: none;">Total Commission</label>
				</td>
				<td style="padding-left: 5px;" colspan="3">
					<input type="text" id="txtTotComm" readonly="readonly" style="width: 220px; text-align: right;"/>
				</td>
				<td class="rightAligned">
					<label for="txtWholdingTax" style="float: none;">Wholding Tax</label>
				</td>
				<td style="padding-left: 5px;">
					<input type="text" id="txtWholdingTax" readonly="readonly" style="width: 220px; text-align: right;"/>
				</td>
			</tr>
			<tr>
				<td colspan="4"></td>
				<td class="rightAligned">
					<label for="txtInputVat" style="float: none;">Input VAT</label>
				</td>
				<td style="padding-left: 5px;">
					<input type="text" id="txtInputVat" readonly="readonly" style="width: 220px; text-align: right;"/>
				</td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv" style="padding: 10px;">
		<div id="commInvoiceTable" style="height: 243px;"></div>
	</div>
	<div style="float: left; width: 100%; text-align: center;">
		<input type="button" class="button" id="btnReturn" value="Return" style="float: none; margin-top: 10px; width: 120px;" />
	</div> 
</div>
<script>
	try {
		$("txtInvoiceIssCd").focus();
		var jsonCommInvoice = JSON.parse('${jsonCommInvoice}');
		var jsonCommInvoiceTG = JSON.parse('${jsonCommInvoiceTG}');
		
		if(jsonCommInvoice.nullCheck != 'Y'){
			$("txtInvoiceIssCd").value = jsonCommInvoice.issCd;
			$("txtInvoicePremSeqNo").value = formatNumberDigits(jsonCommInvoice.premSeqNo, 8);
			$("txtAssured").value = unescapeHTML2(jsonCommInvoice.assdName);
			$("txtTotPremium").value = formatCurrency(jsonCommInvoice.premiumAmt);
			$("txtTotComm").value = formatCurrency(jsonCommInvoice.commissionAmt);
			$("txtSharePercentage").value = formatToNineDecimal(jsonCommInvoice.sharePercentage);
			$("txtWholdingTax").value = formatCurrency(jsonCommInvoice.wholdingTax);
			$("txtInputVat").value = formatCurrency(jsonCommInvoice.inputVatRate);
		} else {
			$("txtInvoiceIssCd").value = objGIACS155.branchCd;
			$("txtInvoicePremSeqNo").value = formatNumberDigits(objGIACS155.premSeqNo, 8);
			$("txtAssured").value = "";
			$("txtTotPremium").value = "0.00";
			$("txtTotComm").value = "0.00";
			$("txtSharePercentage").value = "0.00";
			$("txtWholdingTax").value = "0.00";
			$("txtInputVat").value = "0.00";
		}
		
		
		function getParams() {
			var params = "&intmNo=" + objGIACS155.intmNo
						+ "&issCd=" + objGIACS155.branchCd
						+ "&premSeqNo=" + objGIACS155.premSeqNo
						+ "&policyId=" + objGIACS155.policyId;
			return params;
		}
		
		commInvoiceTableModel = {
				url: contextPath+"/GIACCommissionVoucherController?action=showCommInvoice&refresh=1" + getParams(),
				id : "commInvoice",
				options: {
					hideColumnChildTitle: true,
					/* toolbar: {
						elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
					}, */
					height: '220px',
					onCellFocus : function(element, value, x, y, id) {
						tbgCommInvoice.keys.removeFocus(tbgCommInvoice.keys._nCurrentFocus, true);
						tbgCommInvoice.keys.releaseKeys();
					},
					onRemoveRowFocus : function(element, value, x, y, id){
						tbgCommInvoice.keys.removeFocus(tbgCommInvoice.keys._nCurrentFocus, true);
						tbgCommInvoice.keys.releaseKeys();
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
						id : "perilName",
						title : "Peril",
						width: 250,
						renderer: function(val) {
							return unescapeHTML2(val);
						}
					},
					{
						id : "premiumAmt",
						title : "Premium Amt",
						width : 100,
						align : "right",
						titleAlign : "right",
						geniisysClass : "money"
					},
					{
						id : "commissionRt",
						title : "Comm Rate",
						width : 100,
						align : "right",
						titleAlign : "right",
						geniisysClass : "money"
					},
					{
						id : "commissionAmt",
						title : "Commission",
						width : 100,
						align : "right",
						titleAlign : "right",
						geniisysClass : "money"
					},
					{
						id : "wholdingTax",
						title : "Wholding Tax",
						width : 100,
						align : "right",
						titleAlign : "right",
						geniisysClass : "money"
					},
					{
						id : "inputVatRate",
						title : "Input VAT",
						width : 100,
						align : "right",
						titleAlign : "right",
						geniisysClass : "money"
					}
				],
				rows: jsonCommInvoiceTG.rows
			};
		
		tbgCommInvoice = new MyTableGrid(commInvoiceTableModel);
		tbgCommInvoice.pager = jsonCommInvoiceTG;
		tbgCommInvoice.render('commInvoiceTable');
		
		$("btnReturn").observe("click", function(){
			delete jsonCommInvoice;
			delete jsonCommInvoiceTG;
			overlayCommInvoice.close();
			delete overlayCommInvoice;
		});
		
		initializeAll();
		hideNotice();
		
	} catch (e) {
		showErrorMessage("Commission Voucher Overlay : ", e);
	}
</script>