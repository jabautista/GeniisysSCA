<div class="sectionDiv" style="width: 770px; margin: 10px; height:370px;">
	<div id="historyDiv" style="height: 310px; margin: 10px; width: 770px;"></div>
		<div style="margin-top: 10px;">
			<table width="770px;">
				<td align="center" width="770px;"><input type="button" class="button" style="width: 100px;" id="btnReturn" name="btnReturn" value="Return" tabindex="101"/></td>
			</table>
		</div>
</div>

<script type="text/JavaScript">
		var jsonExtractHistory = JSON.parse('${extractHistory}');	
		extractHistoryTableModel = {
				url : contextPath+"/GIACDeferredController?action=getExtractHistory&refresh=1",
				options: {
					width: '750px',
					height: '310px',
					pager: {
					},
					onCellFocus : function(element, value, x, y, id) {
						extractHistoryTableGrid.keys.releaseKeys();
					},
					prePager: function(){
						extractHistoryTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus : function(element, value, x, y, id){	
						extractHistoryTableGrid.keys.releaseKeys();
					},
					onSort : function(){
						extractHistoryTableGrid.keys.releaseKeys();
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
						id : "year",
						title: "Year",
						sortable: true,
						width: '60px'
					},		
					{
						id : "mM",
						title: "Month",
						width: '50px',
						titleAlign: 'left',
						align: 'left'
					},
					{
						id : "userId",
						title: "User Extract",
						width: '90px',
						titleAlign: 'left',
						align: 'left'
					},
					{
						id : "lastExtract",
						title: "Extract Date",
						width: '100px',
						titleAlign: 'left',
						align: 'left'
					},
					{
						id : "procedureDesc",
						title: "Method of Computation",
						width: '150px',
						titleAlign: 'left',
						align: 'left',
						renderer: function(value) {
							if (value == "" || value == null) {
								value = "Not Yet Computed";
							}
							return value;
						}
					},
					{
						id : "genUser",
						title: "User Gen.",
						width: '80px',
						titleAlign: 'left',
						align: 'left'
					},
					{
						id : "genDate",
						title: "Gen. Acct. Ent. Date",
						width: '120px',
						titleAlign: 'left',
						align: 'left'
					},
					{
						id : "genTag",
						title: "Gen. Tag",
						width: '60px',
						titleAlign: 'left',
						align: 'left'
					}
					
				],
				rows: jsonExtractHistory.rows
			};
		
		extractHistoryTableGrid = new MyTableGrid(extractHistoryTableModel);
		extractHistoryTableGrid.pager = jsonExtractHistory;
		extractHistoryTableGrid.render('historyDiv');
	
		$("btnReturn").observe("click", function() {
			overlayExtractHistory.close();
		});
		
</script>