<div id="recoveryDistMainDiv" name="recoveryDistMainDiv">
	<div id="recoveryDSTableGridDiv" style="margin: 10px 15px">
		<div id="recoveryDSGridDiv" style="height: 180px; margin-top: 5px;">
			<div id="recoveryDSTableGrid" style="height: 156px; width: 770px;"></div>
		</div>
	</div>
	<div id="recoveryRiDSTableGridDiv" style="margin: 10px 15px">
		<div id="recoveryRiDSGridDiv" style="height: 180px; margin-top: 5px;">
			<div id="recoveryRiDSTableGrid" style="height: 156px; width: 770px;"></div>
		</div>
	</div>
	<div class="buttonsDiv" align="center" style="margin-bottom: 5px;">
		<input type="hidden" id="hidRecoveryId"  name="hidRecoveryId"  value="${recoveryId}">
		<input type="hidden" id="hidRecoveryPaytId" name="hidRecoveryPaytId" value="${recoveryPaytId}">
		<input type="button" id="btnOk" name="btnOk" style="width: 120px;" class="button hover"  value="Return" />
	</div>
</div>

<script type="text/javascript">
	try {
		var objRecoveryDS = JSON.parse('${jsonRecoveryDS}'.replace(/\\/g, '\\\\'));
		objRecoveryDS.recoveryDSList = objRecoveryDS.rows || [];
		var objRecoveryRiDS = new Object;
		var recoveryDs = null;
		
		var recoveryDSTableModel = {
				url: contextPath + "/GICLRecoveryPaytController?action=showGICLS260RecoveryDist"+
				     "&claimId="+ nvl(objCLMGlobal.claimId, 0)+"&recoveryId="+$("hidRecoveryId").value+"&recoveryPaytId="+$("hidRecoveryPaytId").value,
				options:{
					title: '',
					width: '770px',
					toolbar: {
						elements: [MyTableGrid.REFRESH_BTN],
						onRefresh: function(){
							recoveryDs = null;
							showRecoveryRiDSList(null);
							recoveryDSListTableGrid.keys.removeFocus(recoveryDSListTableGrid.keys._nCurrentFocus, true);
							recoveryDSListTableGrid.keys.releaseKeys();
						}
					},
					onCellFocus: function(element, value, x, y, id){
						recoveryDs = recoveryDSListTableGrid.geniisysRows[y];
						showRecoveryRiDSList(recoveryDs);
						recoveryDSListTableGrid.keys.removeFocus(recoveryDSListTableGrid.keys._nCurrentFocus, true);
						recoveryDSListTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus: function ( x, y, element) {
						recoveryDs = null;
						showRecoveryRiDSList(null);
						recoveryDSListTableGrid.keys.removeFocus(recoveryDSListTableGrid.keys._nCurrentFocus, true);
						recoveryDSListTableGrid.keys.releaseKeys();
					},
					onSort: function(){
						recoveryDs = null;
						showRecoveryRiDSList(null);
						recoveryDSListTableGrid.keys.removeFocus(recoveryDSListTableGrid.keys._nCurrentFocus, true);
						recoveryDSListTableGrid.keys.releaseKeys();
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
					{
		                id : 'dspShareName', 
		                title: 'Treaty Name',
		                width: 285,
		                filterOption: true
		            },
		            {
		                id : 'sharePct',
		                title: 'Share%',
		                type: 'number',
		                titleAlign: 'right',
		                align: 'right',
		                width: 120,
		                geniisysClass: 'rate',
			            deciRate: 2,
		                filterOption: true,
		                filterOptionType: 'number' 
		            },
		            {
		                id : 'distYear',
		                title: 'Dist. Year',
		                titleAlign: 'right',
		                align: 'right',
		                type: 'number',
		                width: 120,
		                filterOption: true,
		                filterOptionType: 'number' 
		            },
			        {
						id: 'shrRecoveryAmt',
						title: 'Share Recovery Amount',
						titleAlign: 'right',
						width: 230,
						maxlength: 19,
						editable: false,
						align: 'right',
						geniisysClass: 'money',
			            filterOption: true,
			            filterOptionType: 'number' 
			        }		
				],
				resetChangeTag: true,
				rows: objRecoveryDS.recoveryDSList
		};
	
		recoveryDSListTableGrid = new MyTableGrid(recoveryDSTableModel);
		recoveryDSListTableGrid.pager = objRecoveryDS;
		recoveryDSListTableGrid.render('recoveryDSTableGrid');
		
		var recoveryRiDSTableModel = {
				url: contextPath + "/GICLRecoveryPaytController?action=getGICLS260RecoveryRids"+
			         "&claimId="+ nvl(objCLMGlobal.claimId, 0)+"&recoveryId="+$("hidRecoveryId").value,
				options:{
					title: '',
					width: '770px',
					hideColumnChildTitle: true,
					toolbar: {
						elements: [MyTableGrid.REFRESH_BTN],
						onRefresh: function(){
							recoveryRiDSListTableGrid.keys.removeFocus(recoveryRiDSListTableGrid.keys._nCurrentFocus, true);
							recoveryRiDSListTableGrid.keys.releaseKeys();
						}
					},
					onCellFocus: function(element, value, x, y, id){
						recoveryRiDSListTableGrid.keys.removeFocus(recoveryRiDSListTableGrid.keys._nCurrentFocus, true);
						recoveryRiDSListTableGrid.keys.releaseKeys();	
					},
					onRemoveRowFocus: function ( x, y, element) {
						recoveryRiDSListTableGrid.keys.removeFocus(recoveryRiDSListTableGrid.keys._nCurrentFocus, true);
						recoveryRiDSListTableGrid.keys.releaseKeys();
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
					    id: 'riCd dspRiName',
					    title: 'Reinsurer',
					    width : '365px',
					    children : [
				            {
				                id : 'riCd',
				                title: 'RI Code',
				                type: 'number',
				                width: 80,
				                filterOption: true,
				                filterOptionType: 'integer' 
				            },
				            {
				                id : 'dspRiName', 
				                title: 'RI Name',
				                width: 325,
				                filterOption: true
				            }
						]
					}, 
		            {
		                id : 'shareRiPct',
		                title: 'Share%',
		                type: 'number',
		                titleAlign: 'right',
		                align: 'right',
		                width: 120,
		                geniisysClass: 'rate',
			            deciRate: 2,
		                filterOption: true,
		                filterOptionType: 'number' 
		            }, 
			        {
						id: 'shrRiRecoveryAmt',
						title: 'Share Recovery Amount',
						titleAlign: 'right',
						width: 230,
						maxlength: 19,
						editable: false,
						align: 'right',
						geniisysClass: 'money',
			            filterOption: true,
			            filterOptionType: 'number' 
			        }		
				],
				resetChangeTag: true,
				rows: []
		};
	
		recoveryRiDSListTableGrid = new MyTableGrid(recoveryRiDSTableModel);
		recoveryRiDSListTableGrid.pager = objRecoveryRiDS;
		recoveryRiDSListTableGrid.render('recoveryRiDSTableGrid');
		
		function showRecoveryRiDSList(obj){	
			try{	
				if(obj != null){
					recoveryRiDSListTableGrid.url = contextPath + "/GICLRecoveryPaytController?action=getGICLS260RecoveryRids&recoveryId="+ nvl(obj.recoveryId, 0)
			          							   + "&recoveryPaytId="+obj.recoveryPaytId+"&recDistNo="+obj.recDistNo+"&grpSeqNo="+obj.grpSeqNo;
					recoveryRiDSListTableGrid._refreshList();
				}else{
					if($("recoveryRiDSTableGrid") != null){
						clearTableGridDetails(recoveryRiDSListTableGrid);
						recoveryRiDSListTableGrid.url = contextPath + "/GICLRecoveryPaytController?action=getGICLS260RecoveryRids&recoveryId=0";
					}
				}
			}catch(e){
				showErrorMessage("showRecoveryRiDSList",e);
			}
		}
			
	} catch(e){
		showErrorMessage("Claim Information - Loss Recovery - Distribution", e);
	}
	
	
	$("btnOk").observe("click", function(){
		Windows.close("view_dist_canvas");
	});
		
</script>