<div id="commInvoiceDiv" class="" style="width: 685px; margin: 5px 0;">
	<div class="sectionDiv" style="padding: 10px;">
		<table align="center" border="0" style="border-spacing: 0; border-collapse: collapse;">
			<tr>
				<td class="rightAligned"><label for="txtInvoiceBranchCd" style="float: none;">Invoice No.</label></td>
				<td style="padding-left: 5px;">
					<input type="text" id="txtInvoiceBranchCd" readonly="readonly" style="width: 55px;" />
					<input type="text" id="txtInvoicePremSeqNo" readonly="readonly" style="width: 110px; text-align: right;" />
				</td>
				<td class="rightAligned"><label for="txtRefIntmNo" style="float: none; padding-left: 20px;">Agent No.</label></td>
				<td style="padding-left: 5px;">
					<input type="text" id="txtRefIntmNo" readonly="readonly" style="width: 165px;"/>
				</td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv" style="padding: 10px;">
		<div id="commPaymentsTable" style="height: 243px;"></div>
	</div>
	<div style="float: left; width: 100%; text-align: center;">
		<input type="button" class="button" id="btnReturn" value="Return" style="float: none; margin-top: 10px; width: 120px;" />
	</div> 
</div>
<script>
	try {
		
		$("txtInvoiceBranchCd").focus();
		$("txtInvoiceBranchCd").value = objGIACS155.branchCd;
		$("txtInvoicePremSeqNo").value = formatNumberDigits(objGIACS155.premSeqNo, 8);
		$("txtRefIntmNo").value = unescapeHTML2(objGIACS155.refIntmNo);
		
		function getParams() {
			var params = "&intmNo=" + objGIACS155.intmNo
						+ "&issCd=" + objGIACS155.branchCd
						+ "&premSeqNo=" + objGIACS155.premSeqNo;
			return params;
		}
		
		var jsonCommPayments = JSON.parse('${jsonCommPayments}');
		commPaymentsTableModel = {
				url: contextPath+"/GIACCommissionVoucherController?action=showCommPayments&refresh=1" + getParams(),
				id : "commPayments",
				options: {
					hideColumnChildTitle: true,
					/* toolbar: {
						elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
					}, */
					height: '220px',
					onCellFocus : function(element, value, x, y, id) {
						tbgCommPayments.keys.removeFocus(tbgCommPayments.keys._nCurrentFocus, true);
						tbgCommPayments.keys.releaseKeys();
					},
					onRemoveRowFocus : function(element, value, x, y, id){
						tbgCommPayments.keys.removeFocus(tbgCommPayments.keys._nCurrentFocus, true);
						tbgCommPayments.keys.releaseKeys();
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
						id : "orNo",
						title : "Ref No.",
						width: 190
					},
					{
						id : "tranDate",
						title : "Date",
						width : 100,
						align : "center",
						titleAlign : "center",
						filterOptionType : 'formattedDate',
						renderer : function(val) {
							if(val != "" || val != null) {
								return dateFormat(val, "mm-dd-yyyy");
							} else {
								return "";
							}
						}
					},
					{
						id : "commAmt",
						title : "Comm Paid",
						width : 120,
						align : "right",
						titleAlign : "right",
						geniisysClass : "money"
					},
					{
						id : "inputVatAmt",
						title : "Input VAT",
						width : 120,
						align : "right",
						titleAlign : "right",
						geniisysClass : "money"
					},
					{
						id : "wtaxAmt",
						title : "Tax Withheld",
						width : 120,
						align : "right",
						titleAlign : "right",
						geniisysClass : "money"
					}
				],
				rows: jsonCommPayments.rows
			};
		
		tbgCommPayments = new MyTableGrid(commPaymentsTableModel);
		tbgCommPayments.pager = jsonCommPayments;
		tbgCommPayments.render('commPaymentsTable');
		
		$("btnReturn").observe("click", function(){
			delete jsonCommPayments;
			overlayCommPayments.close();
			delete overlayCommPayments;
		});
		
		initializeAll();
		hideNotice();
		
	} catch (e) {
		showErrorMessage("Commission Payments Overlay : ", e);
	}
</script>