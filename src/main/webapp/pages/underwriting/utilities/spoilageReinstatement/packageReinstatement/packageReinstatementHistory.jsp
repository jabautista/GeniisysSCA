<div id="reinstatementHistory" style="width: 99.5%; margin-top: 5px;">
	<div class="sectionDiv" style="padding: 10px 0 10px 10px; height: 235px; width: 97.6%">
		<div id="reinstatementHistTG"></div>
	</div>
	<center><input type="button" class="button" value="Return" id="btnReturn" style="margin-top: 5px; width: 100px;" /></center>
	<div>
		<input id="packPolicyId"     type="hidden"  value="${packPolicyId}"/>
	</div>
</div>
<script type="text/javascript">
	var jsonReinstatementHistory = JSON.parse('${jsonReinstatementHistory}');
	reinstatementHistTableModel = {
			url: contextPath+"/GIPIPackPolbasicController?action=showReinstateHistory&refresh=1&policyId=" + $F("packPolicyId"),
			options: {
				hideColumnChildTitle: true,
				width: '445px',
				height: '220px',
				onCellFocus : function(element, value, x, y, id) {
					tbgReinstatementHistory.keys.removeFocus(tbgReinstatementHistory.keys._nCurrentFocus, true);
					tbgReinstatementHistory.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id){
					tbgReinstatementHistory.keys.removeFocus(tbgReinstatementHistory.keys._nCurrentFocus, true);
					tbgReinstatementHistory.keys.releaseKeys();
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
					id : 'histId',
					title : 'History ID',
					width : '100px',
					titleAlign : 'right',
					align : 'right',
					filterOption : true,
					renderer: function(value) {
					  	return formatNumberDigits(value, 6);
			   		}
				},
				{
					id : 'maxEndtSeqNo',
					title : 'Max Endt.',
					width : '100px',
					titleAlign : 'right',
					align : 'right',
					filterOption : true,
					renderer: function(value) {
					  	return formatNumberDigits(value, 6);
			   		}
					
				},
				{
					id : 'userId',
					title : 'User ID',
					width : '100px',
					titleAlign : 'left',
					filterOption : true
					
				},
				{
					id : 'lastUpdate',
					title : 'Last Update',
					width : '130px',
					titleAlign : 'left',
					filterOption : true,
					renderer : function(value){
						return dateFormat(value, 'mm-dd-yyyy');
					}
				}
			],
			rows: jsonReinstatementHistory.rows
		};
	
	tbgReinstatementHistory = new MyTableGrid(reinstatementHistTableModel);
	tbgReinstatementHistory.pager = jsonReinstatementHistory;
	tbgReinstatementHistory.render('reinstatementHistTG'); 

	
	$("btnReturn").observe("click", function(){
		overlayReinstatementHistory.close();
		delete overlayReinstatementHistory;
	});
</script>