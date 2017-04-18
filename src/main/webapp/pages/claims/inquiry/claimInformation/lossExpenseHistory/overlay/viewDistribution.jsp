<div id="lossExpDistDtlsMainDiv" name="lossExpDistDtlsMainDiv">
	<div id="lossExpDSTableGridDiv" style="margin: 10px 15px">
		<div id="lossExpDSGridDiv" style="height: 180px; margin-top: 5px;">
			<div id="lossExpDSTableGrid" style="height: 156px; width: 760px;"></div>
		</div>
	</div>
	<div id="lossExpRiDSTableGridDiv" style="margin: 10px 15px">
		<div id="lossExpRiDSGridDiv" style="height: 180px; margin-top: 5px;">
			<div id="lossExpRiDSTableGrid" style="height: 156px; width: 760px;"></div>
		</div>
	</div>
	<div class="buttonsDiv" align="center" style="margin-bottom: 5px;">
		<input type="hidden" id="hidClmLossId"  name="hidClmLossId"  value="${clmLossId}">
		<input type="hidden" id="hidClmResHistId" name="hidClmResHistId" value="${clmResHistId}">
		<input type="hidden" id="hidCalledFrom" name="hidCalledFrom" value="${calledFrom}">
		<input type="button" id="btnOk" name="btnOk" style="width: 120px;" class="button hover"  value="Return" />
	</div>
</div>

<script type="text/javascript">
	try {
		var objLossExpDS = JSON.parse('${jsonLossExpDS}'.replace(/\\/g, '\\\\'));
		objLossExpDS.lossExpDSList = objLossExpDS.rows || [];
		var objLossExpRiDS = new Object; 
		
		var lossExpDSTableModel = {
				url: contextPath + "/GICLLossExpDsController?action=showGICLS260LossExpDist"
		                         + "&claimId="+ nvl(objCLMGlobal.claimId, 0)+ "&clmLossId="+$("hidClmLossId").value,
				options:{
					title: '',
					width: '760px',
					toolbar: {
						elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
						onRefresh: function(){
							showLossExpRiDSList(null);
							lossExpDSListTableGrid.keys.removeFocus(lossExpDSListTableGrid.keys._nCurrentFocus, true);
							lossExpDSListTableGrid.keys.releaseKeys();
						}
					},
					onCellFocus: function(element, value, x, y, id){
						var lossExpDs = lossExpDSListTableGrid.geniisysRows[y];
						showLossExpRiDSList(lossExpDs);
						lossExpDSListTableGrid.keys.removeFocus(lossExpDSListTableGrid.keys._nCurrentFocus, true);
						lossExpDSListTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus: function ( x, y, element) {
						showLossExpRiDSList(null);
						lossExpDSListTableGrid.keys.removeFocus(lossExpDSListTableGrid.keys._nCurrentFocus, true);
						lossExpDSListTableGrid.keys.releaseKeys();
					},
					onSort: function(){
						showLossExpRiDSList(null);
						lossExpDSListTableGrid.keys.removeFocus(lossExpDSListTableGrid.keys._nCurrentFocus, true);
						lossExpDSListTableGrid.keys.releaseKeys();
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
					  	width: '170px',
					  	editable: false,
					  	sortable: true,
					  	filterOption: true
					},
					{
					   	id: 'shrLossExpPct',
					   	title: 'Share Pct.',
					   	titleAlign: 'center',
					   	type : 'number',
					  	width: '75px',
					  	geniisysClass: 'rate',
					  	deciRate: 2,
					  	filterOption: true,
					  	filterOptionType: 'number'
					},
					{	id: 'distYear',
					  	title: 'Dist. Yr.',
					  	titleAlign: 'center',
					  	type: 'number',
					  	width: '75px',
					  	editable: false,
					  	sortable: true,
					  	filterOption: true,
					  	filterOptionType: 'integerNoNegative'
					},
					{
					   	id: 'shrLePdAmt',
					   	title: 'Share Paid Amount',
					   	titleAlign: 'center',
					   	type : 'number',
					  	width: '140px',
					  	geniisysClass : 'money',
					  	filterOption: true,
					  	filterOptionType: 'number'
					},
					{
					   	id: 'shrLeAdvAmt',
					   	title: 'Share Advice Amount',
					   	titleAlign: 'center',
					   	type : 'number',
					  	width: '140px',
					  	geniisysClass : 'money',
					  	filterOption: true,
					  	filterOptionType: 'number'
					},
					{
					   	id: 'shrLeNetAmt',
					   	title: 'Share Net Amount',
					   	titleAlign: 'center',
					   	type : 'number',
					  	width: '140px',
					  	geniisysClass : 'money',
					  	filterOption: true,
					  	filterOptionType: 'number'
					}		
				],
				resetChangeTag: true,
				rows: objLossExpDS.lossExpDSList
		};
	
		lossExpDSListTableGrid = new MyTableGrid(lossExpDSTableModel);
		lossExpDSListTableGrid.pager = objLossExpDS;
		lossExpDSListTableGrid.render('lossExpDSTableGrid');
		
		var lossExpRiDSTableModel = {
				url: contextPath + "/GICLLossExpRidsController?action=getGiclLossExpRidsList&claimId="+objCLMGlobal.claimId,
				options:{
					title: '',
					width: '760px',
					hideColumnChildTitle: true,
					toolbar: {
						elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
						onRefresh: function(){
							lossExpRiDSListTableGrid.keys.removeFocus(lossExpRiDSListTableGrid.keys._nCurrentFocus, true);
							lossExpRiDSListTableGrid.keys.releaseKeys();
						}
					},
					onCellFocus: function(element, value, x, y, id){
						lossExpRiDSListTableGrid.keys.removeFocus(lossExpRiDSListTableGrid.keys._nCurrentFocus, true);
						lossExpRiDSListTableGrid.keys.releaseKeys();	
					},
					onRemoveRowFocus: function ( x, y, element) {
						lossExpRiDSListTableGrid.keys.removeFocus(lossExpRiDSListTableGrid.keys._nCurrentFocus, true);
						lossExpRiDSListTableGrid.keys.releaseKeys();
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
						id : 'riCd dspRiName',
						title : 'Reinsurer',
						width : '180px',
						sortable : false,					
						children : [
							{
								id : 'riCd',
								title : 'Reinsurer Code',
								width : 55,							
								sortable : false,
								editable : false,	
								align: 'right',
								filterOption : true,
								filterOptionType : 'integerNoNegative'
							},
							{
								id : 'dspRiName',
								title : 'Reinsurer Name',
								width : 190,
								sortable : false,
								editable : false,
								filterOption : true
							}
						]					
					},
					{
					   	id: 'shrLossExpRiPct',
					   	title: 'Share Pct.',
					   	titleAlign: 'center',
					   	type : 'number',
					  	width: '75px',
					  	geniisysClass: 'rate',
					  	deciRate: 2,
					  	filterOption : true,
						filterOptionType : 'number'
					},
					{
					   	id: 'shrLeRiPdAmt',
					   	title: 'Share Paid Amount',
					   	titleAlign: 'center',
					   	type : 'number',
					  	width: '140px',
					  	geniisysClass : 'money',
					  	filterOption : true,
						filterOptionType : 'number'
					},
					{
					   	id: 'shrLeRiAdvAmt',
					   	title: 'Share Advice Amount',
					   	titleAlign: 'center',
					   	type : 'number',
					  	width: '140px',
					  	geniisysClass : 'money',
					  	filterOption : true,
						filterOptionType : 'number'
					},
					{
					   	id: 'shrLeRiNetAmt',
					   	title: 'Share Net Amount',
					   	titleAlign: 'center',
					   	type : 'number',
					  	width: '140px',
					  	geniisysClass : 'money',
					  	filterOption : true,
						filterOptionType : 'number'
					}		
				],
				resetChangeTag: true,
				rows: []
		};
	
		lossExpRiDSListTableGrid = new MyTableGrid(lossExpRiDSTableModel);
		lossExpRiDSListTableGrid.pager = objLossExpRiDS;
		lossExpRiDSListTableGrid.render('lossExpRiDSTableGrid');
		
		function showLossExpRiDSList(obj){	
			try{	
				if(obj != null){
					lossExpRiDSListTableGrid.url = contextPath + "/GICLLossExpRidsController?action=getGiclLossExpRidsList&claimId="+ nvl(obj.claimId, 0)
			          							   + "&clmLossId="+obj.clmLossId+"&clmDistNo="+obj.clmDistNo+"&grpSeqNo="+obj.grpSeqNo;
					lossExpRiDSListTableGrid._refreshList();
				}else{
					if($("lossExpRiDSTableGrid") != null){
						clearTableGridDetails(lossExpRiDSListTableGrid);
						lossExpRiDSListTableGrid.url = contextPath + "/GICLLossExpRidsController?action=getGiclLossExpRidsList&claimId="+objCLMGlobal.claimId;
					}
				}
			}catch(e){
				showErrorMessage("showLossExpRiDSList",e);
			}
		}
			
	} catch(e){
		showErrorMessage("Claim Information - Loss Expense History - Distribution", e);
	}
	
	
	$("btnOk").observe("click", function(){
		if($("hidCalledFrom").value == "viewHistory"){
			Windows.close("view_dist_canvas");
		}else{
			Windows.close("modal_dialog_lov");			
		}
	});
		
</script>