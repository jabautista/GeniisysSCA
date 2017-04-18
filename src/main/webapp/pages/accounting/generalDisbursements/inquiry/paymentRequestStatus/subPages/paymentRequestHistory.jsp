<div class="sectionDiv" style="width: 450px; margin: 10px; height:260px;">
	<div id="historyDiv" style="height: 200px; margin: 10px; width: 431px;"></div>
		<div style="margin-top: 10px;">
			<table width="453px">
				<td align="center" width="431px"><input type="button" class="button" style="width: 100px;" id="btnReturn" name="btnReturn" value="Return" /></td>
			</table>
		</div>
</div>

<script type="text/JavaScript">
	initializeAll();
		var jsonPaymentRequestHistory = JSON.parse('${jsonPaymentRequestHistory}');	
		paymentRequestHistoryTableModel = {
				url : contextPath+"/GIACInquiryController?action=showPaymentRequestHistory&refresh=1" + "&tranId=" + $F("hidTranId"),
				options: {
					width: '431px',
					hideColumnChildTitle: true,
					pager: {
					},
					onCellFocus : function(element, value, x, y, id) {
						tbgPymntReqHistory.keys.removeFocus(tbgPymntReqHistory.keys._nCurrentFocus, true);
						tbgPymntReqHistory.keys.releaseKeys();
					},
					prePager: function(){
						tbgPymntReqHistory.keys.removeFocus(tbgPymntReqHistory.keys._nCurrentFocus, true);
						tbgPymntReqHistory.keys.releaseKeys();
					},
					onRemoveRowFocus : function(element, value, x, y, id){	
						tbgPymntReqHistory.keys.removeFocus(tbgPymntReqHistory.keys._nCurrentFocus, true);
						tbgPymntReqHistory.keys.releaseKeys();
					},
					afterRender : function (){
						tbgPymntReqHistory.keys.removeFocus(tbgPymntReqHistory.keys._nCurrentFocus, true);
						tbgPymntReqHistory.keys.releaseKeys();
					},
					onSort : function(){
						tbgPymntReqHistory.keys.removeFocus(tbgPymntReqHistory.keys._nCurrentFocus, true);
						tbgPymntReqHistory.keys.releaseKeys();
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
						id : "paytReqFlag rvMeaning",
						title: "Status",
						sortable: true,
						width: '175px',
						children: [
							{
								id : "paytReqFlag",
								width: '75',
								titleAlign: 'left',
								align: 'left'
							},
							{
								id : "rvMeaning",
								width: '100',
								titleAlign: 'left',
								align: 'left'
							},
						          ]
					},		
					{
						id : "userId",
						title: "User Id",
						width: '100px',
						titleAlign: 'left',
						align: 'left',
						filterOption : true
					}
					,
					{
						id : "lastUpdate",
						title: "Last Update",
						width: '125px',
						titleAlign: 'left',
						align: 'left',
						filterOption : true
					}
					
				],
				rows: jsonPaymentRequestHistory.rows
			};
		
		tbgPymntReqHistory = new MyTableGrid(paymentRequestHistoryTableModel);
		tbgPymntReqHistory.pager = jsonPaymentRequestHistory;
		tbgPymntReqHistory.render('historyDiv');
	
		$("btnReturn").observe("click", function() {
			overlayPaymentRequestHistory.close();
		});
		
</script>