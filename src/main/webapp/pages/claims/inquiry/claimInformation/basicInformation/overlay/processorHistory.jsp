<div id="processorHistoryMainDiv" name="processorHistoryMainDiv">
	<div id="processorHistoryTableGridDiv" align="center">
		<div id="processorHistoryGridDiv" style="height: 230px; margin-top: 5px;">
			<div id="processorHistoryTableGrid" style="height: 206px; width: 580px;"></div>
		</div>
		<div class="buttonsDiv" align="center" style="margin-bottom: 5px;">
			<input type="button" id="btnOk" name="btnOk" style="width: 120px;" class="button hover"  value="Return" />
		</div>
	</div>
</div>

<script type="text/javascript">
	try {
		var objProcessorHist = JSON.parse('${jsonProcessorHist}'.replace(/\\/g, '\\\\'));
		objProcessorHist.processorHistList = objProcessorHist.rows || [];
		
		var procHistTableModel = {
				url: contextPath+"/GICLClaimsController?action=showGICLS260TableGridPopup&action1=getProcessorHistTableGridListing&claimId=" + objCLMGlobal.claimId,
				options:{
					title: '',
					width: '580px',
					onRowDoubleClick: function(y){
						procHistListTableGrid.keys.removeFocus(procHistListTableGrid.keys._nCurrentFocus, true); 
						procHistListTableGrid.keys.releaseKeys();	
					},
					onCellFocus: function(element, value, x, y, id){
						procHistListTableGrid.keys.removeFocus(procHistListTableGrid.keys._nCurrentFocus, true);
						procHistListTableGrid.keys.releaseKeys();	
					},
					onRemoveRowFocus: function ( x, y, element) {
						procHistListTableGrid.keys.removeFocus(procHistListTableGrid.keys._nCurrentFocus, true);
						procHistListTableGrid.keys.releaseKeys();
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
						id: 'inHouAdj',
						title: 'Claim Processor',
						width: '200px',
						sortable: true,
						align: 'left',
						visible: true
					},	
	
					{
						id: 'userId',
						title: 'User ID',
						width: '200px',
						sortable: true,
						align: 'left',
						visible: true
					},	
							
					{
						id: 'dspLastUpdate',
						title: 'Last Update',
						width: '168px',
						sortable: true,
						align: 'left',
						visible: true
					},
				],
				resetChangeTag: true,
				rows: objProcessorHist.processorHistList
		};
	
		procHistListTableGrid = new MyTableGrid(procHistTableModel);
		procHistListTableGrid.pager = objProcessorHist;
		procHistListTableGrid.render('processorHistoryTableGrid');
			
	} catch(e){
		showErrorMessage("claim Information - processorHistory.jsp", e);
	}

	$("btnOk").observe("click", function(){
		Windows.close("modal_dialog_lov");
	});
		
</script>