<div id="reserveHistoryMainDiv" name="reserveHistoryMainDiv">
	<div id="reserveHistoryTableGridDiv" style="margin: 10px 12px">
		<div id="reserveGridDiv" style="height: 180px; margin-top: 5px;">
			<div id="reserveHistoryTableGrid" style="height: 156px; width: 670px;"></div>
		</div>
	</div>
	<div style="margin: 15px; margin-bottom: 10px; float: left; width: 650px;">
		<table align="center" border="0">
			<tr>
				<td style="width:70px; text-align: right;">Remarks</td>
				<td class="leftAligned" colspan="3"  width="600px" style="padding-left: 5px;">
					<div style="border: 1px solid gray; height: 20px; width: 99.5%">
						<textarea onKeyDown="limitText(this,4000);" onKeyUp="limitText(this,4000);" id="txtResHistRemarks" name="txtResHistRemarks" style="width: 95%; border: none; height: 13px; resize:none;" readonly="readonly"></textarea>
						<img class="hover" src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editResHistRemarks" />
					</div>
				</td>
			</tr>
			<tr>
				<td style="width:70px; text-align: right;">User Id</td>
				<td class="leftAligned" style="padding-left: 5px;"><input type="text" style="width: 125px;" id="txtResHistUserId" name="txtResHistUserId" readonly="readonly" value=""/></td>
				<td style="width:70px; text-align: right;">Last Update</td>
				<td class="leftAligned" style="width: 160px; padding-left: 5px;"><input type="text" style="width: 160px;" id="txtResHistLastUpdate" name="txtResHistLastUpdate" readonly="readonly" value=""/></td>					
			</tr>
		</table>
	</div>
	<div class="buttonsDiv" align="center" style="margin-bottom: 5px;">
		<input type="hidden" id="hidItemNo"  name="hidItemNo"  value="${itemNo}">
		<input type="hidden" id="hidPerilCd" name="hidPerilCd" value="${perilCd}">
		<input type="button" id="btnOk" name="btnOk" style="width: 120px;" class="button hover"  value="Return" />
	</div>
</div>

<script type="text/javascript">
	try {
		var objReserveHist = JSON.parse('${jsonReserveHistory}'.replace(/\\/g, '\\\\'));
		objReserveHist.reserveHistList = objReserveHist.rows || [];
		
		var reserveHistTableModel = {
				url: contextPath
				+ "/GICLClaimReserveController?action=showGICLS260ClaimReserveOverlay&action1=getResHistTranIdNull"
				+ "&claimId=" + objCLMGlobal.claimId+"&itemNo="+ $("hidItemNo").value+"&perilCd=" + $("hidPerilCd").value,
				options:{
					title: '',
					width: '670px',
					hideColumnChildTitle: true,
					onCellFocus: function(element, value, x, y, id){
						var obj = reserveHistListTableGrid.geniisysRows[y];
						setReserveHistInfo(obj);
						reserveHistListTableGrid.keys.removeFocus(reserveHistListTableGrid.keys._nCurrentFocus, true);
						reserveHistListTableGrid.keys.releaseKeys();	
					},
					onRemoveRowFocus: function ( x, y, element) {
						setReserveHistInfo(null);
						reserveHistListTableGrid.keys.removeFocus(reserveHistListTableGrid.keys._nCurrentFocus, true);
						reserveHistListTableGrid.keys.releaseKeys();
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
						width : '145px',
						geniisysClass : 'money',
						filterOption : true,
						filterOptionType : 'number'
					},
					{
						id : 'expenseReserve',
						title : 'Expense Reserve',
						titleAlign : 'right',
						type : 'number',
						width : '145px',
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
						title: '&#160;&#160;D',
						width: '30px',
						altTitle: 'Distribution Switch',
						align: 'center',
						titleAlign: 'center'
					}		
				],
				resetChangeTag: true,
				rows: objReserveHist.reserveHistList
		};
	
		reserveHistListTableGrid = new MyTableGrid(reserveHistTableModel);
		reserveHistListTableGrid.pager = objReserveHist;
		reserveHistListTableGrid.render('reserveHistoryTableGrid');
			
	} catch(e){
		showErrorMessage("Claim Information - reserveHistory.jsp", e);
	}
	
	function setReserveHistInfo(obj){
		$("txtResHistRemarks").value 	= nvl(obj, null) != null ? unescapeHTML2(obj.remarks): null;
		$("txtResHistUserId").value 	= nvl(obj, null) != null ? unescapeHTML2(obj.userId): null;
// 		$("txtResHistLastUpdate").value = nvl(obj, null) != null ? (nvl(obj.lastUpdate, null) != null ? dateFormat(obj.lastUpdate, "mm-dd-yyyy hh:MM:ss TT") : null): null;
		$("txtResHistLastUpdate").value = nvl(obj, null) != null ? (nvl(obj.lastUpdate, null) != null ? obj.sdfLastUpdate: null): null; //added by steven 06/03/2013;to handle the issue on formatting date.
	}
	
	$("editResHistRemarks").observe("click", function(){showEditor("txtResHistRemarks", 4000, 'true');});
	
	$("btnOk").observe("click", function(){
		Windows.close("modal_dialog_lov");
	});
		
</script>