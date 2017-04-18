<div class="sectionDiv" style="width: 450px; margin: 10px; height:260px;">
	<div id="historyDiv" style="height: 200px; margin: 10px; width: 431px;"></div>
		<div style="margin-top: 10px;">
			<table width="431px">
				<td align="center"><input type="button" class="button" style="width: 100px;" id="btnReturn" name="btnReturn" value="Return" /></td>
			</table>
		</div>
</div>

<script type="text/javascript">
try {
		var jsonTranStatHist = JSON.parse('${jsonTranStatHist}');	
		tranStatHistTableModel = {
				url : contextPath+"/GIACInquiryController?action=showTranStatHist&refresh=1"+"&tranId="+$F("hidTranId"),
				options: {
					width: '431px',
					hideColumnChildTitle: true,
					pager: {
					},
					onSort : function(){
						tbgTransactionStatusHistory.keys.removeFocus(tbgTransactionStatusHistory.keys._nCurrentFocus, true);
						tbgTransactionStatusHistory.keys.releaseKeys();
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
						id : "histTranFlag histRvMeaning",
						title: "Status",
						sortable: true,
						width: '175px',
						children: [
							{
								id : "histTranFlag",
								title: "Tran Flag",
								altTitle: "Transaction Flag",
								width: 75,
								sortable : true,
								editable : false,
								filterOption: true,
								renderer : function(value){
									return unescapeHTML2(value);
								}
							},
							{
								id : "histRvMeaning",
								title: "RV Meaning",
								altTitle: "RV Meaning",
								width: 100,
								sortable : true,
								editable : false,
								filterOption: true,
								renderer : function(value){
									return unescapeHTML2(value);
								}
							},
						          ]
					},				
					{
						id : "histUserId",
						title: "User ID",
						width: '100px',
						sortable : true,
						filterOption: true
					},
					{
						id : "histLastUpdate",
						title: "Last Update",
						width: '125px',
						sortable : true,
						filterOption: true
					}
				],
				rows: jsonTranStatHist.rows
			};
		
		tbgTransactionStatusHistory = new MyTableGrid(tranStatHistTableModel);
		tbgTransactionStatusHistory.pager = jsonTranStatHist;
		tbgTransactionStatusHistory.render('historyDiv');
		
		$("btnReturn").observe("click", function(){
			overlayTranStatHist.close();
		});
		
} catch (e) {
	showErrorMessage("Transaction History", e);
}
</script>