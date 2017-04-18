<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

 
<div id="giacs049HistoryMainDiv">
	<div style="width: 700px; height: 280px; margin-left: 25px;">
		<div id="historyDiv" style="height: 200px; margin: 20px 10px 10px 15px;"></div>
		
		<div class="buttonsDiv" style="margin: 30px 0 5px 0;">
			<input id="btnReturn" type="button" class="button" value="Return" style="width: 100px; height: 22px; font-size: 12px;">
		</div>
	</div>
</div>


<script type="text/javascript">
try{
	var selectedIndex = -1;
	var selectedRowInfo = null;
	
	var objHistory = new Object();
	objHistory.historyTG = JSON.parse('${historyTableGrid}'.replace(/\\/g, '\\\\'));
	objHistory.historyObjRows = objHistory.historyTG.rows || [];
	objHistory.historyList = [];
	
	try{
		var historyTableModel = {
			url: contextPath+"/GIACUpdateCheckNumberController?action=showCheckNoHistory&gaccTranId="+objGIACS049.gaccTranId, 
			options: {
				width: '705px',
				height: '200px',
				hideColumnChildTitle: true,
				onCellFocus: function(element, value, x, y, id){
					selectedIndex = y;
					selectedRowInfo = historyTG.geniisysRows[y];
				},
				onRemoveRowFocus: function(){
					historyTG.keys.releaseKeys();
					selectedIndex = -1;
					selectedRowInfo = null;
				},
				onRefresh: function(){
					historyTG.onRemoveRowFocus();
				},
				toolbar: {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
		            onFilter: function(){
						historyTG.onRemoveRowFocus();
		            }
				}
			},
			columnModel: [
				{
					id: 'recordStatus',
					width: '0px',
					visible: false,
					editor: 'checkbox'
				},
				{
					id: 'divCtrId',
					width: '0px',
					visible: false
				},
				{
					id: 'gaccTranId',
					width: '0px',
					visible: false
				},
				{
					id: 'dvPref dvNo',
					title: 'DV No.',
					width: '220px',
					children: [
						{
							id: 'dvPref',
							title: 'DV Pref',
							width: 50,
							filterOption: true,
							sortable: false,
							editable: false
						},
						{
							id: 'dvNo',
							title: 'DV No',
							align: 'right',
							width: 70,
							filterOption: true,
						  	filterOptionType: 'integerNoNegative',
							sortable: false,
							editable: false
						}
					]
				},
				{
					id: 'oldCheckPref oldCheckNo',
					title: 'Old Check No.',
					width: '220px',
					children: [
								{
									id: 'oldCheckPref',
									title: 'Old Check Pref',
									width: 70,
					        	  	filterOption: true
								},
								{
									id: 'oldCheckNo',
									title: 'Old Check No',
									width: 90,
									align: 'right',
									geniisyClass: 'integerNoNegativeUnformattedNoComma',
					        	  	filterOption: true,
					        	  	filterOptionType: 'integerNoNegative'
								}
							  ]
				},
				{
					id: 'newCheckPref newCheckNo',
					title: 'New Check No.',
					width: '220px',
					children: [
								{
									id: 'newCheckPref',
									title: 'New Check Pref',
									width: 70,
									maxlength: 5,
					        	  	filterOption: true
								},
								{
									id: 'newCheckNo',
									title: 'New Check No',
									width: 90,
									align: 'right',
									geniisyClass: 'integerNoNegativeUnformattedNoComma',
					        	  	filterOption: true,
					        	  	filterOptionType: 'integerNoNegative'
								}
							  ]
				},
				{
					id: 'userId',
					title: 'User Id',
					width: '70px',
					filterOption: true,
					sortable: true
				},
				{
					id: 'dspLastUpdate',
					title: 'Last Update',
					width: '150px',
					filterOption: true,
					filterOptionType: 'formattedDate',
					format: 'mm-dd-yyyy hh:MM:ss TT',
					sortable: true,
					geniisysClass: 'date',
					renderer: function(value){
						return dateFormat(value, 'mm-dd-yyyy hh:MM:ss TT');
					}
					
				},
				{
					id: 'lastUpdate',
					width: '0px',
					visible: false
				}
			],
			rows: objHistory.historyObjRows
		};
		
		historyTG = new MyTableGrid(historyTableModel);
		historyTG.pager = objHistory.historyTG;
		historyTG.render('historyDiv');
		historyTG.afterRender = function(){
			objHistory.historyList = historyTG.geniisysRows;
		};
		
	}catch(e){
		showErrorMessage("Error in History table grid", e);
	}
	
	$("btnReturn").observe("click", function(){
		historyTG.keys.releaseKeys();
		objOverlay.close();
	});
	
}catch(e){
	showErrorMessage("Page Error: ", e);
}
</script>