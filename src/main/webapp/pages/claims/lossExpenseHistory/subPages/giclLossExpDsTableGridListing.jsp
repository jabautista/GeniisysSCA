<div id="giclLossExpDsTableGrid" style="height: 181px; margin:15px; width: 890px;"></div>

<script type="text/javascript">
	try{
		var objGICLLossExpDs = JSON.parse('${jsonGiclLossExpDs}');
		
		var giclLossExpDsTableModel = {
			id : 6,
			url : contextPath + "/GICLLossExpDsController?action=getGiclLossExpDsList"
					          + "&claimId="+ nvl(objCurrGICLClmLossExpense.claimId, 0)
					          + "&clmLossId="+objCurrGICLClmLossExpense.claimLossId,
			options:{
				title: '',
				pager: { },
				width: '890px',
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN/*, MyTableGrid.FILTER_BTN*/],
					onRefresh: function(){
						clearAllRelatedLossExpDsRecords();
					},
					onFilter: function(){
						clearAllRelatedLossExpDsRecords();
					}
				},
				onCellFocus: function(element, value, x, y, id){
					clearAllRelatedLossExpDsRecords();
					var giclLossExpDs = giclLossExpDsTableGrid.geniisysRows[y];
					objCurrGICLLossExpDs = giclLossExpDs;
					retrieveLossExpRids(giclLossExpDs);
				},
				onRemoveRowFocus: function() {
					clearAllRelatedLossExpDsRecords();
				},
				onSort: function(){
					clearAllRelatedLossExpDsRecords();
				}
			},
			columnModel: [
				{   id: 'recordStatus',
				    title: '',
				    width: '0',
				    visible: false,
				    editor: 'checkbox' 			
				},
				{	id: 'divCtrId',
					width: '0',
					visible: false
				},
				{	id: 'treatyName',
					align: 'left',
				  	title: 'Treaty Name',
				  	titleAlign: 'center',
				  	width: '190px',
				  	editable: false,
				  	sortable: true,
				  	filterOption: true
				},
				{	id: 'distYear',
				  	title: 'Distribution Year',
				  	titleAlign: 'center',
				  	type: 'number',
				  	width: '110px',
				  	editable: false,
				  	sortable: true,
				  	filterOption: true,
				  	filterOptionType: 'integerNoNegative'
				},
				{
				   	id: 'shrLossExpPct',
				   	title: 'Share Percentage',
				   	titleAlign: 'center',
				   	type : 'number',
				  	width: '120px',
				  	geniisysClass: 'rate',
				  	deciRate: 2,
				  	filterOption: true,
					filterOptionType: 'number'
				},
				{
				   	id: 'shrLePdAmt',
				   	title: 'Share Paid Amount',
				   	titleAlign: 'center',
				   	type : 'number',
				  	width: '150px',
				  	geniisysClass : 'money',
				  	filterOption: true,
					filterOptionType: 'number'
				},
				{
				   	id: 'shrLeAdvAmt',
				   	title: 'Share Advice Amount',
				   	titleAlign: 'center',
				   	type : 'number',
				  	width: '150px',
				  	geniisysClass : 'money',
				  	filterOption: true,
					filterOptionType: 'number'
				},
				{
				   	id: 'shrLeNetAmt',
				   	title: 'Share Net Amount',
				   	titleAlign: 'center',
				   	type : 'number',
				  	width: '150px',
				  	geniisysClass : 'money',
				  	filterOption: true,
					filterOptionType: 'number'
				}
				
			],
			rows : objGICLLossExpDs.rows,
			requiredColumns: ''
		};
		
		giclLossExpDsTableGrid = new MyTableGrid(giclLossExpDsTableModel);
		giclLossExpDsTableGrid.pager = objGICLLossExpDs;
		giclLossExpDsTableGrid.render('giclLossExpDsTableGrid');
		
	}catch(e){
		showErrorMessage("Loss Expense Hist - giclLossExpDs", e);
	}
	
	function clearAllRelatedLossExpDsRecords(){
		objCurrGICLLossExpDs = null;
		giclLossExpDsTableGrid.releaseKeys();
		if($("giclLossExpRidsTableGrid") != null){
			clearTableGridDetails(giclLossExpRidsTableGrid);
		}
	}
	
	var dummy = new Object();
	retrieveLossExpRids(dummy);
</script>