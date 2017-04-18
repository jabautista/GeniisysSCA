<div id="adjusterMainDiv" name="adjusterMainDiv">
	<div id="adjusterTableGridDiv" align="center">
		<div id="adjusterGridDiv" style="height: 230px; margin-top: 5px;">
			<div id="adjusterTableGrid" style="height: 206px; width: 760px;"></div>
		</div>
		<div class="buttonsDiv" align="center" style="margin-bottom: 5px;">
			<input type="button" id="btnExit" 		name="btnExit" 		 style="width: 120px;" class="button hover"  value="Return" />
			<input type="button" id="btnAdjHistory" name="btnAdjHistory" style="width: 120px;" class="button hover"  value="Adjuster History" />
		</div>
	</div>
</div>

<script type="text/javascript">

	try {
		var objAdjuster = JSON.parse('${jsonAdjuster}'.replace(/\\/g, '\\\\'));
		objAdjuster.adjusterList = objAdjuster.rows || [];
		var selectedRecord = null;

		var adjusterTableModel = {
				url: contextPath+"/GICLClaimsController?action=showGICLS260TableGridPopup&action1=getClmAdjusterListing&claimId="+objCLMGlobal.claimId,
				options:{
					hideColumnChildTitle: true,
					title: '',
					onCellFocus: function(element, value, x, y, id){
						selectedRecord = adjusterListTableGrid.geniisysRows[y];
						adjusterListTableGrid.keys.removeFocus(adjusterListTableGrid.keys._nCurrentFocus, true); 
						adjusterListTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus: function ( x, y, element) {
						selectedRecord = null;
						adjusterListTableGrid.keys.removeFocus(adjusterListTableGrid.keys._nCurrentFocus, true);
						adjusterListTableGrid.keys.releaseKeys();
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
					    id: 'adjCompanyCd dspAdjCoName',
					    title: 'Adjusting Company',
					    width : '250px',
					    children : [
				            {
				                id : 'adjCompanyCd',
				                width: 50
				            },
				            {
				                id : 'dspAdjCoName', 
				                width: 200
				            }
						]
					},
					
					{
					    id: 'privAdjCd dspPrivAdjName',
					    title: 'Adjuster',
					    width : '250px',
					    children : [
				            {
				                id : 'privAdjCd',
				                width: 50
				            },
				            {
				                id : 'dspPrivAdjName', 
				                width: 200
				            }
						]
					},
							
					{
						id: 'assignDate',
						title: 'Date Assigned',
						width: '120px',
						sortable: true,
						align: 'left',
						visible: true
					},
					
					{
						id: 'compltDate',
						title: 'Date Completed',
						width: '120px',
						sortable: true,
						align: 'left',
						visible: true
					}
				],
				resetChangeTag: true,
				rows: objAdjuster.adjusterList
		};
	
		adjusterListTableGrid = new MyTableGrid(adjusterTableModel);
		adjusterListTableGrid.pager = objAdjuster;
		adjusterListTableGrid.render('adjusterTableGrid');
	} catch(e){
		showErrorMessage("Claim Information - adjuster.jsp", e);
	}

	$("btnAdjHistory").observe("click", function(){
		if(selectedRecord == null){
			showMessageBox("Please select a record first.", "I");
		}else{
			overlayAdjHist = Overlay.show(contextPath+"/GICLClmAdjHistController", {
				urlContent: true,
				urlParameters: {action : "showGICLS260ClmAdjusterHistory",
								claimId : objCLMGlobal.claimId,
								adjCompanyCd : selectedRecord.adjCompanyCd,
								adjCompanyName : unescapeHTML2(selectedRecord.dspAdjCoName),
								privAdjCd : selectedRecord.privAdjCd,
								privAdjName: unescapeHTML2(selectedRecord.dspPrivAdjName),
								ajax: 1},
				title: "Claim Adjuster History",	
				id: "clm_adj_hist_canvas",
				width: 830,
				height: 330,
			    draggable: false,
			    closable: true
			});
		}
	});
	
	$("btnExit").observe("click", function(){
		Windows.close("modal_dialog_lov");
	});
</script>	