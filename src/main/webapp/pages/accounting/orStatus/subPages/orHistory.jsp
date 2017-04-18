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
		var jsonOrHistory = JSON.parse('${jsonOrHistory}');	
		orHistoryTableModel = {
				url : contextPath+"/GIACInquiryController?action=showOrHistory&refresh=1" + "&tranId=" + $F("hidTranId"),
				options: {
					width: '431px',
					hideColumnChildTitle: true,
					pager: {
					},
					onCellFocus : function(element, value, x, y, id) {
						tbgAccOrHistory.keys.removeFocus(tbgAccOrHistory.keys._nCurrentFocus, true);
						tbgAccOrHistory.keys.releaseKeys();
					},
					prePager: function(){
						tbgAccOrHistory.keys.removeFocus(tbgAccOrHistory.keys._nCurrentFocus, true);
						tbgAccOrHistory.keys.releaseKeys();
					},
					onRemoveRowFocus : function(element, value, x, y, id){	
						tbgAccOrHistory.keys.removeFocus(tbgAccOrHistory.keys._nCurrentFocus, true);
						tbgAccOrHistory.keys.releaseKeys();
					},
					afterRender : function (){
						tbgAccOrHistory.keys.removeFocus(tbgAccOrHistory.keys._nCurrentFocus, true);
						tbgAccOrHistory.keys.releaseKeys();
					},
					onSort : function(){
						tbgAccOrHistory.keys.removeFocus(tbgAccOrHistory.keys._nCurrentFocus, true);
						tbgAccOrHistory.keys.releaseKeys();
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
						id : "orFlag rvMeaning",
						title: "Status",
						sortable: true,
						width: '175px',
						children: [
							{
								id : "orFlag",
								title: "Or Flag",
								width: '75',
								titleAlign: 'left',
								align: 'left',
								filterOption : true,
								renderer : function(value){
									return unescapeHTML2(value);
								}
							},
							{
								id : "rvMeaning",
								title: "Meaning",
								width: '100',
								titleAlign: 'left',
								align: 'left',
								filterOption : true,
								renderer : function(value){
									return unescapeHTML2(value);
								}
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
				rows: jsonOrHistory.rows
			};
		
		tbgAccOrHistory = new MyTableGrid(orHistoryTableModel);
		tbgAccOrHistory.pager = jsonOrHistory;
		tbgAccOrHistory.render('historyDiv');
	
		$("btnReturn").observe("click", function() {
			overlayOrHistory.close();
		});
		
</script>