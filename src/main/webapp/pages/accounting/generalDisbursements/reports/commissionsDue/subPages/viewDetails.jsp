<div id="viewDetailsMainDiv" name="viewDetailsMainDiv" style="margin-top: 10px; margin-bottom: 5px; margin-left: 5px; margin-right: 5px;">
	<div id="tableDiv" class="sectionDiv" style="height: 450px;">
		<div id="viewDetailsTableGridDiv" name="viewDetailsTableGridDiv" style="margin-top: 10px; margin-left: 10px; height: 305px;"></div>
		<div id="formFields">
			<table style="margin-bottom: 10px;">
				<tr align="center">
					<td class="rightAligned" style="width:100px; padding-right: 5px;">Totals</td>
					<td class="leftAligned">
						<input type="text" id="txtTotalGrossPrem" name="txtTotalGrossPrem" class="text rightAligned" readonly="readonly" style="width: 90px;" tabindex="101"/>
						<input type="text" id="txtTotalPremPaid" name="txtTotalPremPaid" class="text rightAligned" readonly="readonly" style="width: 90px; margin-right: 178px;" tabindex="102"/>
						<input type="text" id="txtTotalComm" name="txtTotalComm" class="text rightAligned" style="width: 80px;" readonly="readonly" tabindex="103"/>
						<input type="text" id="txtTotalWhTax" name="txtTotalWhTax" class="text rightAligned" style="width: 80px;" readonly="readonly" tabindex="104"/>
						<input type="text" id="txtInputVat" name="txtInputVat" class="text rightAligned" style="width: 90px;" readonly="readonly" tabindex="105"/>
						<input type="text" id="txtNetComm" name="txtNetComm" class="text rightAligned" style="width: 85px;" readonly="readonly" tabindex="106"/>
					</td>
				</tr>
			</table>
			<table style="margin-bottom: 10px;">
				<tr align="center">
					<td class="rightAligned" style="width:100px; padding-right: 5px;">Policy No</td>
					<td class="leftAligned">
						<input type="text" id="txtPolicyNo" name="txtPolicyNo" class="text" readonly="readonly" style="width: 390px;" tabindex="107"/>
					</td>
					<td class="rightAligned" style="padding-right: 5px;">Bank Reference No.</td>
					<td class="leftAligned">
						<input type="text" id="txtBankRefNo" name="txtBankRefNo" class="text" readonly="readonly" style="width: 188px;" tabindex="108"/>
					</td>
				</tr>
				<tr align="center">
					<td class="rightAligned" style="width:100px; padding-right: 5px;">Assured</td>
					<td class="leftAligned">
						<input type="text" id="txtAssured" name="txtAssured" class="text" readonly="readonly" style="width: 390px;" tabindex="109"/>
					</td>
					<td class="rightAligned" style="width:160px; padding-right: 5px;">Premium Payment Ref. No.</td>
					<td class="leftAligned">
						<input type="text" id="txtOrNo" name="txtOrNo" class="text" readonly="readonly" style="width: 188px;" tabindex="110"/>
					</td>
				</tr>
				<tr align="center">
					<td class="rightAligned" style="width:100px; padding-right: 5px;">Intermediary</td>
					<td class="leftAligned" colspan="3">
						<input type="text" id="txtIntmNo" name="txtIntmNo" class="text rightAligned" readonly="readonly" style="width: 90px;" tabindex="111"/>
						<input type="text" id="txtIntmName" name="txtIntmName" class="text" readonly="readonly" style="width: 653px;" tabindex="112"/>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div id="viewButtonsDiv" style="float: left; width: 100px; padding-left: 350px; margin-top: 10px;">
		<table align="center">
			<tr>
				<td><input type="button" class="button" id="btnReturnViewDetails" name="btnReturnViewDetails" value="Return" style="width: 150px;" tabindex="201"/></td>
			</tr>
		</table>
	</div>
</div>
<script type="text/javascript">

	var action = '${action}';
	var jsonDetails = JSON.parse('${jsonDetailsList}');	
	detailsTableModel = {
			url : contextPath+"/GIACGeneralDisbursementReportsController?action="+action+"&refresh=1&parentIntmNo="+objCurrParentIntmNo+
							  "&parentIntmType="+objCurrParentIntmType+"&asOfDate="+$F("txtAsOfDate")+"&bankFileNo="+objCurrBankFileNo,
			options: {
				width: '880px',
				height: '300px',
				pager: {
				},
				onCellFocus : function(element, value, x, y, id) {
					setDetailsFields(tbgDetails.geniisysRows[y]);
					tbgDetails.keys.removeFocus(tbgDetails.keys._nCurrentFocus, true);
					tbgDetails.keys.releaseKeys();
				},
				prePager: function(){
					setDetailsFields(null);
					tbgDetails.keys.removeFocus(tbgDetails.keys._nCurrentFocus, true);
					tbgDetails.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id){	
					setDetailsFields(null);
					tbgDetails.keys.removeFocus(tbgDetails.keys._nCurrentFocus, true);
					tbgDetails.keys.releaseKeys();
				},
				onSort : function(){
					setDetailsFields(null);
					tbgDetails.keys.removeFocus(tbgDetails.keys._nCurrentFocus, true);
					tbgDetails.keys.releaseKeys();
				},
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onFilter: function(){
						setDetailsFields(null);
						tbgDetails.keys.removeFocus(tbgDetails.keys._nCurrentFocus, true);
						tbgDetails.keys.releaseKeys();
					},
					onRefresh: function(){
						setDetailsFields(null);
						tbgDetails.keys.removeFocus(tbgDetails.keys._nCurrentFocus, true);
						tbgDetails.keys.releaseKeys();
					}
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
					id : "billNo",
					title: "Bill No",
					width: '85px',
					sortable: true,
					filterOption: true
				},
				{
					id : "grossPremium",
					title: "Gross Prem",
					width: '100px',
					align : 'right',
					titleAlign : 'right',
					sortable: true,
					filterOption: true,
					filterOptionType: 'number',
					geniisysClass: 'money'
				},
				{
					id : "premiumPaid",
					title: "Prem Paid",
					width: '100px',
					align : 'right',
					titleAlign : 'right',
					sortable: true,
					filterOption: true,
					filterOptionType: 'number',
					geniisysClass: 'money'
				},
				{
					id : "peril",
					title: "Peril",
					width: '75px',
					sortable: true,
					filterOption: true
				},				
				{
					id : "commissionRt",
					title: "Comm Rate",
					width: '100px',
					align : 'right',
					titleAlign : 'right',
					sortable: true,
					filterOption: true,
					filterOptionType: 'number',
					geniisysClass: 'money'
				},
				{
					id : "commissionDue",
					title: "Comm",
					width: '90px',
					align : 'right',
					titleAlign : 'right',
					sortable: true,
					filterOption: true,
					filterOptionType: 'number',
					geniisysClass: 'money'
				},
				{
					id : "wholdingTaxDue",
					title: "WHTax",
					width: '90px',
					align : 'right',
					titleAlign : 'right',
					sortable: true,
					filterOption: true,
					filterOptionType: 'number',
					geniisysClass: 'money'
				},
				{
					id : "inputVatDue",
					title: "Input VAT",
					width: '100px',
					align : 'right',
					titleAlign : 'right',
					sortable: true,
					filterOption: true,
					filterOptionType: 'number',
					geniisysClass: 'money'
				},
				{
					id : "netCommDue",
					title: "Net Comm",
					width: '95px',
					align : 'right',
					titleAlign : 'right',
					sortable: true,
					filterOption: true,
					filterOptionType: 'number',
					geniisysClass: 'money'
				}
			],
			rows: jsonDetails.rows
		};
	
	tbgDetails = new MyTableGrid(detailsTableModel);
	tbgDetails.pager = jsonDetails;
	tbgDetails.render('viewDetailsTableGridDiv');
	tbgDetails.afterRender = function(y) {
		if (tbgDetails.geniisysRows.length != 0) {
			getTotalAmount();
		}
	};

	function getTotalAmount() {
		new Ajax.Request(contextPath+"/GIACGeneralDisbursementReportsController",{
			parameters: {
				action: "getDetailsTotalViaRecords",
				subAct: action,
				parentIntmNo: objCurrParentIntmNo,
				parentIntmType: objCurrParentIntmType,
				asOfDate: $F("txtAsOfDate"),
				bankFileNo: objCurrBankFileNo
			},
			method: "POST",
			onComplete : function (response){
				if(checkErrorOnResponse(response)){
					tempArray = [];
					tempArray = JSON.parse(response.responseText);
					for ( var b = 0; b < tempArray.rec.length; b++) {
						$("txtTotalGrossPrem").value  = formatCurrency(parseFloat(nvl(tempArray.rec[b]['grossPremiumTotal'], "0")));
						$("txtTotalPremPaid").value = formatCurrency(parseFloat(nvl(tempArray.rec[b]['premiumPaidTotal'], "0")));
						$("txtTotalComm").value  = formatCurrency(parseFloat(nvl(tempArray.rec[b]['commissionDueTotal'], "0")));
						$("txtTotalWhTax").value  = formatCurrency(parseFloat(nvl(tempArray.rec[b]['wholdingTaxDueTotal'], "0")));
						$("txtInputVat").value = formatCurrency(parseFloat(nvl(tempArray.rec[b]['inputVatDueTotal'], "0")));
						$("txtNetComm").value  = formatCurrency(parseFloat(nvl(tempArray.rec[b]['netCommDueTotal'], "0")));
					}
				}
			}							 
		});	
	}
	

	function setDetailsFields(obj) {
		try {
			$("txtPolicyNo").value  = obj == null ? "" : obj.policyNo;
			$("txtBankRefNo").value = obj == null ? "" : obj.bankRefNo;
			$("txtAssured").value 	= obj == null ? "" : unescapeHTML2(obj.assured);
			$("txtOrNo").value 	 	= obj == null ? "" : obj.orNo;
			$("txtIntmNo").value 	= obj == null ? "" : obj.intmNo;
			$("txtIntmName").value 	= obj == null ? "" : unescapeHTML2(obj.intmName);
		} catch (e) {
			showErrorMessage("setDetailsFields - setDetailsFields", e);
		}
	}
	
	$("btnReturnViewDetails").observe("click", function() {
		setDetailsFields(null);
		overlayViewDetails.close();
	});
	
</script>