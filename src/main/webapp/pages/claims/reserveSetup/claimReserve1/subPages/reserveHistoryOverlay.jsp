<div id="reserveHistMainDiv">
	<div id="reserveHistDiv" name="reserveDsDiv" style="margin-top: 10px; width: 99.5%;" class="sectionDiv">
		<div id="reserveHistGrid" style="height: 150px; width:625px; margin: 10px; margin-top: 10px; margin-bottom: 10px;"></div>
		<div style="  float: left;">
			<table style="margin: 5px" align="center">
				<tr>
					<td class="rightAligned" width="80px">Remarks </td>
					<td class="leftAligned">
						<div class="withIconDiv">
							<input id="txtRemarksHist" name="txtRemarksHist" type="text" style="width: 533px;" value="" class="withIcon"/>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="edittxtRemarksHist" />
						</div>
				</tr>
			</table>
		</div>
		<div class="buttonsDiv" style="margin-bottom: 10px; margin-top: 5px;">
			<input type="button" class="button" id="btnUpdate" value="Update" style="width: 80px;">
		</div>
	</div>
</div>
<div id="invoiceButtonsDiv" name="invoiceButtonsDiv" class="buttonsDiv" style="margin-top: 10px; margin-bottom: 0px;">
	<input type="button" class="button" id="btnResHistReturn" name="btnResHistReturn" value="Return" style="width: 80px;">
	<input type="button" class="button" id="btnSave" value="Save" style="width: 80px;">
</div>

<script type="text/javascript">
try{
	initializeAll();
	disableButton("btnUpdate");
	objGICLClmResHist = JSON.parse('${resHistTableGrid}');
	objCurrReserveDS = {};
	
	var giclReserveHistoryTableModel = {
			id: 3,
			url: contextPath
			+ "/GICLClaimReserveController?action=showResHistOverlay"
			+ "&claimId=" + objCLMGlobal.claimId
			+ "&itemNo=" + objCurrGICLItemPeril.itemNo
			+ "&perilCd=" + objCurrGICLItemPeril.perilCd
			+ "&ajax=1&refresh=1",
		options : {
			title: '',
			pager : {}, 
			width : '655px',
			hideColumnChildTitle: true,
			toolbar : {
				elements : [ MyTableGrid.REFRESH_BTN],
				onRefresh : function() {
					reserveHistoryTableGrid.keys.releaseKeys();
					$("txtRemarksHist").value = null;
				},
				onFilter : function() {
					reserveHistoryTableGrid.keys.releaseKeys();
				}
			},
			onCellFocus: function(element, value, x, y, id){
				objCurrReserveDS = reserveHistoryTableGrid.geniisysRows[y];
				objCurrReserveDS.rowIndex = y;
				reserveHistoryTableGrid.keys.releaseKeys();
				$("txtRemarksHist").value = unescapeHTML2(objCurrReserveDS.remarks);
				enableButton("btnUpdate");
			},
			onCellBlur: function(){
				reserveHistoryTableGrid.keys.removeFocus(reserveHistoryTableGrid.keys._nCurrentFocus, true);
				reserveHistoryTableGrid.keys.releaseKeys();
			},
			onRemoveRowFocus: function() {
				objCurrReserveDS = null;
				reserveHistoryTableGrid.keys.releaseKeys();
				$("txtRemarksHist").value = null;
				disableButton("btnUpdate");
			}
		},
		columnModel : [
		     {
				id : 'recordStatus',
				title : 'Record Status',
				width : '0',
				visible : false,
				editor : 'checkbox'
			},
			{
				id : 'divCtrId',
				width : '0',
				visible : false
			},
			{	id: 'histSeqNo',
				title: 'Hist No.',
				width: '70px',
				align: 'right',
				titleAlign: 'right',
				filterOption: true,
				type: 'number',
				renderer : function(value){
					return lpad(value.toString(), 3, "0");					
				}
			},
			{
				id : 'lossReserve',
				title : 'Loss Reserve',
				titleAlign : 'right',
				type : 'number',
				width : '130px',
				geniisysClass : 'money',
				filterOption : true,
				filterOptionType : 'number'
			},
			{
				id : 'expenseReserve',
				title : 'Expense Reserve',
				titleAlign : 'right',
				type : 'number',
				width : '130px',
				geniisysClass : 'money',
				filterOption : true,
				filterOptionType : 'number'
			},
			{	id: 'convertRate',
				title: 'Convert Rate',
				width: '100px',
				geniisysClass: 'rate',
				align: 'right',
				titleAlign: 'right',
				filterOption: true,
				filterOptionType: 'integerNoNegative'
			},
			{
				id : 'bookingMonth bookingYear',
				title : 'Booking Date',
				width : '160px',
				sortable : false,					
				children : [
					{
						id : 'bookingMonth',							
						width : 100,							
						sortable : false,
						editable : false
					},
					{
						id : 'bookingYear',							
						width : 60,
						sortable : false,
						editable : false,
						align: 'right'
					}
				]					
			},
			{	id: 'distSw',
				title: 'D',
				width: '25px',
				altTitle: 'Distribution Switch',
				align: 'center',
				titleAlign: 'center'
			},
			{
				id : 'setupDate',
				title : 'Setup Date',
				width : '130',
				editable : false,
				filterOption : true
			},
			{
				id : 'setupBy',
				title : 'Setup By',
				width : '100',
				editable : false,
				filterOption : true
			}
		],
		resetChangeTag: true,
		rows: objGICLClmResHist.rows,
		requiredColumns: ''
	};
	
	reserveHistoryTableGrid = new MyTableGrid(giclReserveHistoryTableModel);
	reserveHistoryTableGrid.pager = objGICLClmResHist;
	reserveHistoryTableGrid.mtgId = 3;
	reserveHistoryTableGrid.render('reserveHistGrid');
	reserveHistoryTableGrid.afterRender = function(){
		changeTag = 0;
	};
		
	function closeResHistoryOverlay(){
		distDtlsOverlay.close();
		delete distDtlsOverlay;
	}
	
	$("btnUpdate").observe("click", function(){
		objCurrReserveDS.remarks = escapeHTML2($("txtRemarksHist").value);
		reserveHistoryTableGrid.updateRowAt(objCurrReserveDS, objCurrReserveDS.rowIndex);
		$("txtRemarksHist").value = null;
		disableButton("btnUpdate");
		changeTag = 1;
	});
	
	function savePaytHistory(){
		var objParams = new Object();
		objParams.parameters = getModifiedJSONObjects(reserveHistoryTableGrid.geniisysRows);
		try{
			new Ajax.Request(contextPath+"/GICLClaimReserveController?action=setPaytHistoryRemarks", {
				method: "POST",
				parameters: {
					parameters: JSON.stringify(objParams),
					claimId : objCLMGlobal.claimId
				},
				onCreate: function(){
					showNotice("Saving Reserve History. Please Wait...");
				},
				onSuccess: function(response){
					hideNotice("");
					if (response.responseText == "SUCCESS"){
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
							reserveHistoryTableGrid.refresh();
						});
						disableButton("btnUpdate");
						$("txtRemarksHist").value = null;
						changeTag = 0;
					}
				}
			});
		} catch (e){
			showErrorMessage("savePaytHistory", e);
		}
	}
	
	observeSaveForm("btnSave", savePaytHistory);
	
	observeCancelForm("btnResHistReturn", savePaytHistory, closeResHistoryOverlay);
	
	$("edittxtRemarksHist").observe("click", function(){
		if (typeof objCurrReserveDS.rowIndex != "undefined"){
			showOverlayEditor("txtRemarksHist", 4000, false, function(){
				pendingChanges = true;
				//enableButton("btnUpdate");
			});
		}
	});
	
}catch(e){
	showErrorMessage("distribution details overlay.", e);
}
</script>