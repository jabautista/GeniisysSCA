<div id="statusHistory" style="width: 99.5%; margin-top: 5px;">
	<div class="sectionDiv" style="padding: 10px 0 10px 10px; height: 190px; width: 97.6%">
		<div id="statusHistoryTable"></div>
	</div>
	<center><input type="button" class="button" value="Return" id="btnReturn" style="margin-top: 5px; width: 100px;" /></center>
</div>
<script type="text/javascript">
	
	var jsonStatusHistory = JSON.parse('${jsonStatusHistory}');
	statusHistoryTableModel = {
			url: contextPath+"/GIACInquiryController?action=showGIAC237StatusHistory&refresh=1&gaccTranId="+objGIACS237.gaccTranId,
			options: {
				hideColumnChildTitle: true,
				width: '478px',
				height: '166px',
				onCellFocus : function(element, value, x, y, id) {
 					tbgStatusHistory.keys.removeFocus(tbgStatusHistory.keys._nCurrentFocus, true);
 					tbgStatusHistory.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id){
					tbgStatusHistory.keys.removeFocus(tbgStatusHistory.keys._nCurrentFocus, true);
 					tbgStatusHistory.keys.releaseKeys();
				}
			},									
			columnModel : [
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
					id : 'dvFlag rvMeaning',
					title : 'Status',
					width : '125px',
					filterOption : true,
					children : [
						{
							id : 'dvFlag',
							title : 'DV Flag',
							width : 25
						},
						{
							id : 'rvMeaning',
							title : 'RV Meaning',
							width : 150
						}
					]
				},
				{
					id : 'userId',
					title : 'User ID',
					width : '120px',
					filterOption : true
				},
				{
					id : 'lastUpdate',
					title : 'Last Update',
					width : '169px',
					filterOption : true,
					renderer : function(value){
						return dateFormat(value, 'mm-dd-yyyy HH:MM:ss TT');
					}
				}
			],
			rows: jsonStatusHistory.rows
		};
	
	tbgStatusHistory = new MyTableGrid(statusHistoryTableModel);
	tbgStatusHistory.pager = jsonStatusHistory;
	tbgStatusHistory.render('statusHistoryTable'); 

	
	$("btnReturn").observe("click", function(){
		overlayStatusHistory.close();
		delete overlayStatusHistory;
	});
</script>