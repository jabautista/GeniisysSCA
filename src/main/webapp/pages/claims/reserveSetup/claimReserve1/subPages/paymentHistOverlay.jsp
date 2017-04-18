<div id="reserveHistMainDiv">
	<div id="paymentHistoryDiv" name="paymentHistoryDiv" style="margin-top: 10px; width: 99.5%;" class="sectionDiv">
		<div id="paymentHistoryListTableGrid" style="height: 150px; width: 625px; margin: 10px; margin-top: 10px; margin-bottom: 10px;"></div>
		<div style="margin-top: 10px;  float: left;">
			<table style="margin: 10px" align="center">
				<tr>
					<td class="rightAligned" width="80px">Payee Class </td>
					<td class="leftAligned" width="220px">
						<input id="txtPayeeClassCd" name="txtPayeeClassCd" type="text" style="width: 30px; text-align: right;" value="" readonly="readonly" />
						<input id="txtPayeeClassDesc" name="txtPayeeClassDesc" type="text" style="width: 170px;" value="" readonly="readonly" />
					</td>
					<td class="rightAligned" width="50px">Payee </td>
					<td class="leftAligned">
						<input id="txtPayeeCd" name="txtPayeeCd" type="text" style="width: 40px; text-align: right;" value="" readonly="readonly" />
						<input id="txtPayee" name="txtPayee" type="text" style="width: 227px;" value="" readonly="readonly" />
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Remarks </td>
					<td class="leftAligned" colspan="3">
						<div style="float: left;" class="withIconDiv">
							<input id="txtRemarksHist" name="txtRemarksHist" type="text" style="width: 533px;" value="" readonly="readonly" class="withIcon"/>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="edittxtRemarksHist" />
						</div>
				</tr>
			</table>
		</div>
		<div align="center">
			<input type="button" class="button" id="btnUpdate" value="Update" style="width: 80px; margin-bottom: 10px;">
		</div>
	</div>
</div>
<div  class="buttonsDiv" style="margin-top: 10px; margin-bottom: 0px;">
	<input type="button" class="button" id="btnReturn" value="Return" style="width: 80px;">
	<input type="button" class="button" id="btnSave" value="Save" style="width: 80px;">
</div>

<script type="text/javascript">
try{
	initializeAll();
	
	var objPaymentHistory = JSON.parse('${jsonPaymentHistoryTableGrid}');
	
	var paymentHistoryTableModel = {
			url : contextPath
					+ "/GICLClaimReserveController?action=showPaymentHistOverlay&refresh=1"
					+ "&claimId=" + objCLMGlobal.claimId
					+ "&itemNo=" + objCurrGICLItemPeril.itemNo
					+ "&perilCd=" + objCurrGICLItemPeril.perilCd
					+ "&groupedItemNo=" + objCurrGICLItemPeril.groupedItemNo,
			options : {
				title : '',
				width : '655px',
				onCellFocus : function(element, value, x, y, id) {
					paymentHistoryTableGrid.keys.releaseKeys();
					objCurrPaytHistory = paymentHistoryTableGrid.geniisysRows[y];
					objCurrPaytHistory.rowIndex = y;
					$("txtPayeeClassCd").value = objCurrPaytHistory.payeeClassCd;
					$("txtPayeeClassDesc").value = objCurrPaytHistory.classDesc;
					$("txtPayeeCd").value = objCurrPaytHistory.payeeCd;
					$("txtPayee").value = unescapeHTML2(objCurrPaytHistory.payee);
					$("txtRemarksHist").value = unescapeHTML2(objCurrPaytHistory.remarks);
					enableInputField("txtRemarksHist");
					enableButton("btnUpdate");
				},
				onRemoveRowFocus : function() {
					paymentHistoryTableGrid.keys.releaseKeys();
					clearPaytHistorySelection();
					disableButton("btnUpdate");
					disableInputField("txtRemarksHist");
				},
				beforeSort : function(){
					clearPaytHistorySelection();
				},
				toolbar : {
					elements : [MyTableGrid.REFRESH_BTN],
					onRefresh: function(){
						clearPaytHistorySelection();
					}
				}
			},
			columnModel : [
			    {	id : 'recordStatus',
					title : '',
					width : '0',
					visible : false
				},
				{	id : 'divCtrId',
					width : '0',
					visible : false
				},
				{	id : 'histSeqNo',
					title : 'Hist No.',
					width : '55',
					titleAlign : 'right',
					align : 'right',
					sortable : true,
					renderer : function(value){
						return lpad(value.toString(), 3, "0");					
					}
				},
				{	id : 'lossesPaid',
					title : 'Losses Paid',
					width : '158',
					titleAlign: 'right',
					renderer : function(value){
						return formatCurrency(value);
					},
					align : 'right'
				},
				{	id : 'expensesPaid',
					title : 'Expenses Paid',
					width : '158',
					titleAlign: 'right',
					renderer : function(value){
						return formatCurrency(value);
					},
					align : 'right'
				},
				{	id : 'convertRate',
					title : 'Convert Rate',
					width : '128',
					titleAlign: 'right',
					renderer : function(value){
						return formatToNthDecimal(value, 9);
					},
					align : 'right'
				},
				{	id : 'datePaid',
					title : 'Date Paid',
					width : '103',
					renderer : function(value){
						return dateFormat(value, "mm-dd-yyyy");
					}
				},
				{	id: 'cancelTag',
					title: 'C',
					width : '25',
					altTitle: 'Cancel Tag',
					align: 'center',
					titleAlign: 'center',
					editable: false,
					filterOptionType: 'checkbox',
					editor : new MyTableGrid.CellCheckbox({getValueOf : function(value) { //Added by: Jerome Bautista 3.25.2015
						if (value) { 
						return "Y"; 
						} else { 
						return "N"; 
						} 
						} 
						})
				},
				/* {	id : 'cancelTag',
					width : '0',
					visible : false
				}, */ //Commented out by: Jerome Bautista 3.25.2015
				{	id : 'payeeClassCd',
					width : '0',
					visible : false
				},
				{	id : 'classDesc',
					width : '0',
					visible : false
				},
				{	id : 'payeeCd',
					width : '0',
					visible : false
				},
				{	id : 'payee',
					width : '0',
					visible : false
				}
			],
			rows : objPaymentHistory.rows
	};
	paymentHistoryTableGrid = new MyTableGrid(paymentHistoryTableModel);
	paymentHistoryTableGrid.pager = objPaymentHistory;
	paymentHistoryTableGrid.render('paymentHistoryListTableGrid');
	paymentHistoryTableGrid.afterRender = function(){
		changeTag = 0;
	};
	
	try{
		disableButton("btnUpdate");
	} catch (e){
		showErrorMessage("paymentHistory", e);
	}
	
	$("edittxtRemarksHist").observe("click", function(){
		if (typeof objCurrPaytHistory.rowIndex != "undefined"){
			showOverlayEditor("txtRemarksHist", 4000, false, function(){
				null;
			});
		}
	});
	
	$("btnUpdate").observe("click", function(){
		objCurrPaytHistory.remarks = escapeHTML2($("txtRemarksHist").value);
		paymentHistoryTableGrid.updateRowAt(objCurrPaytHistory, objCurrPaytHistory.rowIndex);
		changeTag = 1;
		clearPaytHistorySelection();
	});
	
	function savePaytHistory(){
		var objParams = new Object();
		objParams.parameters = getModifiedJSONObjects(paymentHistoryTableGrid.geniisysRows);
		try{
			new Ajax.Request(contextPath+"/GICLClaimReserveController?action=setPaytHistoryRemarks", {
				method: "POST",
				parameters: {
					parameters: JSON.stringify(objParams),
					claimId : objCLMGlobal.claimId
				},
				onCreate: function(){
					showNotice("Saving Payment History. Please Wait...");
				},
				onSuccess: function(response){
					hideNotice("");
					if (response.responseText == "SUCCESS"){
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
							paymentHistoryTableGrid.refresh();
							clearPaytHistorySelection();
						});
						pendingChanges = false;
						changeTag = 0;
					}
				}
			});
		} catch (e){
			showErrorMessage("savePaytHistory", e);
		}
	}
	
	function closePaytHistoryOverlay(){
		overlayGICLS024PaymentHistory.close();
		delete overlayGICLS024PaymentHistory;
	}
	
	observeSaveForm("btnSave", savePaytHistory);
	observeCancelForm("btnReturn", savePaytHistory, closePaytHistoryOverlay);
	
} catch (e){
	showErrorMessage("Payment History Overlay", e);
}
</script>