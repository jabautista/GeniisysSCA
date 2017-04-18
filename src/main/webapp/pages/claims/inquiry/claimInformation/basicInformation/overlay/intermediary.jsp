<div id="intermediaryMainDiv" name="intermediaryMainDiv">
	<div id="intermediaryTableGridDiv" align="center">
		<div id="intermediaryGridDiv" style="height: 230px; margin-top: 5px;">
			<div id="intermediaryTableGrid" style="height: 206px; width: 580px;"></div>
		</div>
		<div class="buttonsDiv" align="center" style="margin-bottom: 5px;">
			<input type="button" id="btnOk" name="btnOk" style="width: 120px;" class="button hover" value="Return" />
		</div>
	</div>
</div>

<script type="text/javascript">
	try{	
		var objClmIntermediary = JSON.parse('${jsonClaimIntermediary}'.replace(/\\/g, '\\\\'));
		objClmIntermediary.intermediaryList = objClmIntermediary.rows || [];
		
		var intermediaryTableModel = {
				url: contextPath+"/GICLClaimsController?action=showGICLS260TableGridPopup&action1=getBasicIntmDtls&claimId=" + objCLMGlobal.claimId,
				options:{
					title: '',
					width: '580px',
					onRowDoubleClick: function(y){
						intermediaryTableGrid.keys.removeFocus(intermediaryTableGrid.keys._nCurrentFocus, true);
						claimsListTableGrid.keys.releaseKeys();	
					},
					onCellFocus: function(element, value, x, y, id){
						intermediaryTableGrid.keys.removeFocus(intermediaryTableGrid.keys._nCurrentFocus, true); // andrew - 12.12.2012
						intermediaryTableGrid.keys.releaseKeys();	
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
						id: 'intmType',
						title: 'Intm Type',
						width: '120px',
						sortable: true,
						align: 'left',
						visible: true
					},	
	
					{
						id: 'intmNo',
						title: 'Intm No.',
						width: '120px',
						sortable: true,
						align: 'right',
						visible: true
					},	
							
					{
						id: 'intmName',
						title: 'Intermediary Name',
						width: '328px',
						sortable: true,
						align: 'left',
						visible: true
					},
				],
				resetChangeTag: true,
				rows: objClmIntermediary.intermediaryList
		};
	
		intermediaryTableGrid = new MyTableGrid(intermediaryTableModel);
		intermediaryTableGrid.pager = objClmIntermediary;
		intermediaryTableGrid.render('intermediaryTableGrid');
			
	} catch(e){
		showErrorMessage("Claim Information - intermediary.jsp", e);
	}

	$("btnOk").observe("click", function(){
		Windows.close("modal_dialog_lov");
	});
		
</script>