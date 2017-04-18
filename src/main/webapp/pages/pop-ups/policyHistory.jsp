<div id="policyHistoryMainDiv">
	<div id="policyHistoryDiv" name="policyHistoryDiv" class="sectionDiv" style="height: 350px; width: 98%;">
		<div id="divPolicyHistoryTG">
		</div>
	</div>
	<div class="buttonsDiv" style="margin-bottom: 10px; margin-top: 5px;">
		<input type="button" class="button" id="btnOk" value="Ok" style="width: 80px;">
		<input type="hidden" id="txtParId" name="txtParId" value="${parId}"/>
	</div>
</div>
<script type="text/javascript">
try{
	
	var jsonViewHistory = JSON.parse('${viewHistory}');
	
	viewPolicyHistoryTableModel = {
			url : contextPath + "/GIPIPolbasicController?action=viewHistory&refresh=1&parId=" + $F("txtParId"),
			options : {
				width : '480px',
				height : '300px',
				onCellFocus : function(element, value, x, y, id) {
					tbgViewPolicyHistory.keys.removeFocus(tbgViewPolicyHistory.keys._nCurrentFocus, true);
					tbgViewPolicyHistory.keys.releaseKeys();
				}, 
				onRemoveRowFocus : function(element, value, x, y, id) {
					tbgViewPolicyHistory.keys.removeFocus(tbgViewPolicyHistory.keys._nCurrentFocus, true);
					tbgViewPolicyHistory.keys.releaseKeys();
				}
			},
			columnModel : [ {
				id : 'recordStatus',
				title : '',
				width : '0',
				visible : false
			}, {
				id : 'divCtrId',
				width : '0',
				visible : false
			},
			{
				id : 'parStat',
				title : 'Status',
				width : '125px',
			},
			{
				id : 'parStatDate',
				title : 'Date',
				width : '172px'
			},{
				id : 'userId2',
				title : 'User Id',
				width : '169px'
				
			}],
			rows : jsonViewHistory.rows
	};
	
	tbgViewPolicyHistory = new MyTableGrid(viewPolicyHistoryTableModel);
	tbgViewPolicyHistory.pager = jsonViewHistory;
	tbgViewPolicyHistory.render('divPolicyHistoryTG');

	$("btnOk").observe("click", function() {
		viewHistoryOverlay.close();
		delete viewHistoryOverlay;
	});

} catch (e) {
	showErrorMessage("Policy History Overlay.", e);
}
</script>