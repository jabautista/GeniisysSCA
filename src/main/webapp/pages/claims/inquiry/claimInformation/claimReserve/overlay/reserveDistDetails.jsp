<div id="resDistDtlsMainDiv" name="resDistDtlsMainDiv">
	<div id="reserveDSTableGridDiv" style="margin: 10px 15px">
		<div id="reserveDSGridDiv" style="height: 180px; margin-top: 5px;">
			<div id="reserveDSTableGrid" style="height: 156px; width: 760px;"></div>
		</div>
	</div>
	<div id="reserveRiDSTableGridDiv" style="margin: 10px 15px">
		<div id="reserveRiDSGridDiv" style="height: 180px; margin-top: 5px;">
			<div id="reserveRiDSTableGrid" style="height: 156px; width: 760px;"></div>
		</div>
	</div>
	<div class="buttonsDiv" align="center" style="margin-bottom: 5px;">
		<input type="hidden" id="hidItemNo"  name="hidItemNo"  value="${itemNo}">
		<input type="hidden" id="hidPerilCd" name="hidPerilCd" value="${perilCd}">
		<input type="hidden" id="hidClmResHistId" name="hidClmResHistId" value="${clmResHistId}">
		<input type="button" id="btnOk" name="btnOk" style="width: 120px;" class="button hover"  value="Return" />
	</div>
</div>

<script type="text/javascript">
	try {
		var objReserveDS = JSON.parse('${jsonReserveDS}'.replace(/\\/g, '\\\\'));
		objReserveDS.reserveDSList = objReserveDS.rows || [];
		var objReserveRiDS = new Object; 
		
		var reserveDSTableModel = {
				url: contextPath
				+ "/GICLClaimReserveController?action=showGICLS260ClaimReserveOverlay&action1=getGiclReserveDsGrid3"
				+ "&claimId="+ objCLMGlobal.claimId+"&itemNo="+$("hidItemNo").value
				+"&perilCd="+ $("hidPerilCd").value+"&clmResHistId="+$("hidClmResHistId").value,
				options:{
					title: '',
					width: '760px',
					hideColumnChildTitle: true,
					onCellFocus: function(element, value, x, y, id){
						var reserveDS = reserveDSListTableGrid.geniisysRows[y];
						showReserveRiDSList(reserveDS);
						reserveDSListTableGrid.keys.removeFocus(reserveDSListTableGrid.keys._nCurrentFocus, true);
						reserveDSListTableGrid.keys.releaseKeys();	
					},
					onRemoveRowFocus: function ( x, y, element) {
						showReserveRiDSList(null);
						reserveDSListTableGrid.keys.removeFocus(reserveDSListTableGrid.keys._nCurrentFocus, true);
						reserveDSListTableGrid.keys.releaseKeys();
					},
					onSort: function(){
						showReserveRiDSList(null);
						reserveDSListTableGrid.keys.removeFocus(reserveDSListTableGrid.keys._nCurrentFocus, true);
						reserveDSListTableGrid.keys.releaseKeys();
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
						id: 'dspTrtyName',
						title: 'Treaty Name',
						titleAlign: 'center',
						align : 'left',
						width : '210px',
						editable : false,
						sortable : true
					},
					{
						id: 'shrPct',
						title: 'Share Pct.',
						titleAlign: 'center',
						align : 'right',
						width : '100px',
						geniisysClass: 'rate'
					},
					{
						id: 'distYear',
						title: 'Distribution Year',
						titleAlign: 'center',
						align : 'left',
						width : '100px'
					},
					{
						id: 'shrLossResAmt',
						title : 'Treaty Share Loss Res Amt.',
						titleAlign : 'center',
						align : 'right',
						width : '165px',
						editable : false,
						sortable : true,
						type: 'number',
						geniisysClass: 'money'
					},
					{
						id: 'shrExpResAmt',
						title : 'Treaty Share Exp Res Amt.',
						titleAlign : 'center',
						align : 'right',
						width : '165px',
						editable : false,
						sortable : true,
						type: 'number',
						geniisysClass: 'money'
					}		
				],
				resetChangeTag: true,
				rows: objReserveDS.reserveDSList
		};
	
		reserveDSListTableGrid = new MyTableGrid(reserveDSTableModel);
		reserveDSListTableGrid.pager = objReserveDS;
		reserveDSListTableGrid.render('reserveDSTableGrid');
		
		var reserveRiDSTableModel = {
				url: contextPath+"/GICLClaimReserveController?action=refreshReserveRidsTG&claimId="+objCLMGlobal.claimId,
				options:{
					title: '',
					width: '760px',
					hideColumnChildTitle: true,
					onCellFocus: function(element, value, x, y, id){
						reserveRiDSListTableGrid.keys.removeFocus(reserveRiDSListTableGrid.keys._nCurrentFocus, true);
						reserveRiDSListTableGrid.keys.releaseKeys();	
					},
					onRemoveRowFocus: function ( x, y, element) {
						reserveRiDSListTableGrid.keys.removeFocus(reserveRiDSListTableGrid.keys._nCurrentFocus, true);
						reserveRiDSListTableGrid.keys.releaseKeys();
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
						id : 'riCd riName',
						title : 'Reinsurer',
						width : '210px',
						sortable : false,					
						children : [
							{
								id : 'riCd',							
								width : 80,							
								sortable : false,
								editable : false,	
								align: 'right'
							},
							{
								id : 'riName',							
								width : 230,
								sortable : false,
								editable : false
							}
						]					
					},
					{
						id: 'shrRiPct',
						title: 'Share Pct.',
						titleAlign: 'center',
						align : 'right',
						width : '100px',
						geniisysClass: 'rate'
					},
					{
						id: 'shrLossRiResAmt',
						title : 'Share Loss Reserve Amt.',
						titleAlign : 'center',
						align : 'right',
						width : '165px',
						editable : false,
						sortable : true,
						type: 'number',
						geniisysClass: 'money'
					},
					{
						id: 'shrExpRiResAmt',
						title : 'Share Exp. Reserve Amt.',
						titleAlign : 'center',
						align : 'right',
						width : '165px',
						editable : false,
						sortable : true,
						type: 'number',
						geniisysClass: 'money'
					}		
				],
				resetChangeTag: true,
				rows: []
		};
	
		reserveRiDSListTableGrid = new MyTableGrid(reserveRiDSTableModel);
		reserveRiDSListTableGrid.pager = objReserveRiDS;
		reserveRiDSListTableGrid.render('reserveRiDSTableGrid');
		
		function showReserveRiDSList(obj){	
			try{	
				if(obj != null){
					var claimId = obj.claimId;
					var clmDistNo = obj.clmDistNo;
					var grpSeqNo = obj.grpSeqNo;
					var clmResHistId = obj.clmResHistId;
					reserveRiDSListTableGrid.url = contextPath+"/GICLClaimReserveController?action=refreshReserveRidsTG&claimId="+claimId+
							"&clmDistNo="+clmDistNo+"&grpSeqNo="+grpSeqNo+"&clmResHistId="+clmResHistId;
					reserveRiDSListTableGrid._refreshList();
				}else{
					if($("reserveRiDSTableGrid") != null){
						clearTableGridDetails(reserveRiDSListTableGrid);
						reserveRiDSListTableGrid.url = contextPath+"/GICLClaimReserveController?action=refreshReserveRidsTG&claimId="+objCLMGlobal.claimId;
					}
				}
			}catch(e){
				showErrorMessage("showReserveRiDSList",e);
			}
		}
			
	} catch(e){
		showErrorMessage("Claim Information - Reserve Distribution Details", e);
	}
	
	
	$("btnOk").observe("click", function(){
		Windows.close("modal_dialog_lov");
	});
		
</script>