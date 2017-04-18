<div id="cancelledAdviceMainDiv" name="cancelledAdviceMainDiv" class="sectionDiv" style="border: none;">
	<div id="cancelledAdviceTableGridDiv" style="margin: 10px;">
		<div id="cancelledAdviceTableGrid" style="height: 210px; width: 500px;"></div>
	</div>
	<div align="center">
		<input type="button" class="button" id="cancelledAdviceReturn" name="cancelledAdviceReturn" value="Return" style="width:90px;">
	</div>
</div>

<script type="text/javascript">
	try{
		var objCancelledAdvice = JSON.parse('${jsonCancelledAdviceList}');
		objCancelledAdvice.cancelledAdviceList = objCancelledAdvice.rows || []; 
		
		var cancelledAdviceTableModel = {
			url : contextPath+"/GICLAdviceController?action=showGICLS260CancelledAdvice&claimId="+nvl(objCLMGlobal.claimId, 0),
			options:{
				title: '',
				pager: { },
				width: '510px',
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN]
				},
				onCellFocus: function(element, value, x, y, id){
					cancelledAdviceTableGrid.releaseKeys();
				},
				onRemoveRowFocus: function() {
					cancelledAdviceTableGrid.releaseKeys();
				},
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
				{	id: 'adviceNo',
					align: 'left',
				  	title: 'Advice Number',
				  	titleAlign: 'left',
				  	width: '178px',
				  	editable: false,
				  	sortable: true,
				  	filterOption: true
				},
				{	id: 'userId',
					align: 'left',
				  	title: 'User ID',
				  	titleAlign: 'left',
				  	width: '120px',
				  	editable: false,
				  	sortable: true,
				  	filterOption: true
				},
				{	id: 'lastUpdate',
					align: 'left',
				  	title: 'Last Update',
				  	titleAlign: 'left',
				  	type: 'date',
				  	format: 'mm-dd-yyyy hh:MM:ss TT',
				  	width: '200px',
				  	editable: false,
				  	sortable: true,
				  	filterOption: true,
					filterOptionType: 'formattedDate'
				}
				
			],
			rows : objCancelledAdvice.cancelledAdviceList,
			requiredColumns: ''
		};
		cancelledAdviceTableGrid = new MyTableGrid(cancelledAdviceTableModel);
		cancelledAdviceTableGrid.pager = objCancelledAdvice;
		cancelledAdviceTableGrid.render('cancelledAdviceTableGrid');
		
		$("cancelledAdviceReturn").observe("click", function(){
			Windows.close("cancelled_advice_canvas");
		});
		
	}catch(e){
		showErrorMessage("Claim Information - Loss Expense Hist - List of Cancelled Advice", e);
	}

</script>