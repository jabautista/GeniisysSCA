<div id="clmStatHistoryMainDiv" name="clmStatHistoryMainDiv">
	<div id="clmStatHistoryTableGridDiv" align="center">
		<div id="clmStatHistoryGridDiv" style="height: 230px; margin-top: 5px;">
			<div id="clmStatHistoryTableGrid" style="height: 206px; width: 580px;"></div>
		</div>
		<div class="buttonsDiv" align="center" style="margin-bottom: 5px;">
			<input type="button" id="btnOk" name="btnOk" style="width: 120px;" class="button hover" value="Return" />
		</div>
	</div>
</div>

<script type="text/javascript">
	try {
		var objClmStatHist = JSON.parse('${jsonClaimStatHistory}'.replace(/\\/g, '\\\\'));
		objClmStatHist.claimStatHistList = objClmStatHist.rows || [];
		
		var claimStatHistTableModel = {
				url: contextPath+"/GICLClaimsController?action=showGICLS260TableGridPopup&action1=getStatHistTableGridListing&claimId=" + objCLMGlobal.claimId,
				options:{
					title: '',
					width: '580px',
					onRowDoubleClick: function(y){
						clmStatHistTableGrid.keys.removeFocus(clmStatHistTableGrid.keys._nCurrentFocus, true);
						clmStatHistTableGrid.keys.releaseKeys();	
					},
					onCellFocus: function(element, value, x, y, id){
						clmStatHistTableGrid.keys.removeFocus(clmStatHistTableGrid.keys._nCurrentFocus, true);
						clmStatHistTableGrid.keys.releaseKeys();	
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
						id: 'clmStatCd',
						title: 'Claim Status Code',
						width: '120px',
						sortable: true,
						align: 'left',
						visible: true
					},	
	
					{
						id: 'clmStatDesc',
						title: 'Description',
						width: '200px',
						sortable: true,
						align: 'left',
						visible: true
					},	
							
					{
						id: 'userId',
						title: 'User ID',
						width: '96px',
						sortable: true,
						align: 'left',
						visible: true
					},
					
					{
						id: 'dspClmStatDt',
						title: 'Date',
						width: '150px',
						sortable: true,
						align: 'left',
						visible: true
					},
				],
				resetChangeTag: true,
				rows: objClmStatHist.claimStatHistList
		};
	
		clmStatHistTableGrid = new MyTableGrid(claimStatHistTableModel);
		clmStatHistTableGrid.pager = objClmStatHist;
		clmStatHistTableGrid.render('clmStatHistoryTableGrid');
			
	} catch(e){
		showErrorMessage("Claim Information - claimStatHistory.jsp", e);
	}

	$("btnOk").observe("click", function(){
		Windows.close("modal_dialog_lov");
	});
		
</script>