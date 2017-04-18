<div id="statusHistory" style="width: 99.5%; margin-top: 5px;">
	<div class="sectionDiv" style="padding: 10px 0 10px 10px; height: 190px; width: 97.6%">
		<div id="parStatusHistoryTable"></div>
	</div>
	<center><input type="button" class="button" value="Return" id="btnReturn" style="margin-top: 5px; width: 100px;" /></center>
</div>
<script type="text/javascript">
	
	var jsonParStatHistory = JSON.parse('${jsonParStatHistory}');
	parStatusHistoryTableModel = {
			url: contextPath+"/GIPIPolbasicController?action=showGipis131ParStatusHistory&refresh=1&parId=" + objGIPIS131.parId,
			options: {
				hideColumnChildTitle: true,
				width: '478px',
				height: '166px',
				onCellFocus : function(element, value, x, y, id) {
 					tbgParStatusHistory.keys.removeFocus(tbgParStatusHistory.keys._nCurrentFocus, true);
 					tbgParStatusHistory.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id){
					tbgParStatusHistory.keys.removeFocus(tbgParStatusHistory.keys._nCurrentFocus, true);
 					tbgParStatusHistory.keys.releaseKeys();
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
					id : 'parStat',
					title : 'Status',
					width : '125px',
					filterOption : true
				},
				{
					id : 'parStatDate',
					title : 'Date',
					width : '172px',
					filterOption : true,
					renderer : function(value){
						return dateFormat(value, 'mm-dd-yyyy HH:MM:ss TT');
					}
				},
				{
					id : 'userId2',
					title : 'User Id',
					width : '169px',
					filterOption : true
					
				}
			],
			rows: jsonParStatHistory.rows
		};
	
	tbgParStatusHistory = new MyTableGrid(parStatusHistoryTableModel);
	tbgParStatusHistory.pager = jsonParStatHistory;
	tbgParStatusHistory.render('parStatusHistoryTable'); 

	
	$("btnReturn").observe("click", function(){
		overlayParStatusHistory.close();
		delete overlayParStatusHistory;
	});
</script>