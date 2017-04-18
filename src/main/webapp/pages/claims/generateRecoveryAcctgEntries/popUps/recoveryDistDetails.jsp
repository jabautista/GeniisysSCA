<div id="recoveryDistDetailsMainDiv" class="sectionDiv">
	<div id="recoveryDistGridDiv" style="padding: 10px;">
		<div id="recoveryDistTableGrid" style="height: 130px; width: 620px;"></div>
	</div>
</div>
<div id="viewRecoveryRidsMainDiv" class="sectionDiv" style="height: 200px; margin-bottom: 5px;">
	<div id="recoveryRidsGridDiv" style="padding: 10px;">
		<div id="recoveryRidsTableGrid" style="height: 130px; width: 620px;"></div>
	</div>
	<div class="buttonsDiv">
		<input type="hidden" id="hidRecoveryId" name="hidRecoveryId" value="" />
		<input type="hidden" id="hidRecPaytId" name="hidRecPaytId" value="" />
		<input type="button" id="btnDSReturn" name="btnDSReturn" value="Return" style="width: 100px;" />
	</div>
</div>

<script type="text/javascript">
	$("hidRecoveryId").value = '${recoveryId}';
	$("hidRecPaytId").value = '${recPaytId}';
	
	var rowIndex = -1; 
	var objCurrRecDS = null; 
	var recDistNo = null;
	var grpSeqNo = null; 
	
	try {
		var objRecDS = JSON.parse('${recoveryDSTableGrid}'.replace(/\\/g, '\\\\'));
		var recDSTable = {
			url: contextPath+"/GICLRecoveryPaytController?action=showDistDetailsModal&loadTG=DS&recoveryId="+$F("hidRecoveryId")
			 +"&recoveryPaytId="+$F("hidRecPaytId"),
			 options: {
				 title: '',
				 height: '110',
				 width: '620',
				 onCellFocus: function(element, value, x, y, id) {
					rowIndex = y;
					objCurrRecDS = recDSGrid.geniisysRows[y];
					recDistNo = objCurrRecDS.recDistNo;
					grpSeqNo = objCurrRecDS.grpSeqNo; 
					loadRecRidsTable(recDistNo, grpSeqNo);
				 },
				 onRemoveRowFocus: function(){
					recRidsGrid.url = contextPath+"/GICLRecoveryPaytController?action=showDistDetailsModal&loadTG=riDS&recoveryId="+$F("hidRecoveryId")
						 						 +"&recoveryPaytId="+$F("hidRecPaytId")+"&recDistNo=&grpSeqNo=";
					recRidsGrid.refreshURL(recRidsGrid);
					recRidsGrid._refreshList();
					recRidsGrid.onRemoveRowFocus();
					recDSGrid.keys.removeFocus(recDSGrid.keys._nCurrentFocus, true);
					recDSGrid.keys.releaseKeys();
				 }
			 },
			 columnModel: [
				{   
					id: 'recordStatus',
				    width: '0',
				    visible: false,
				    editor: 'checkbox' 			
				},
				{	
					id: 'divCtrId',
					width: '0',
					visible: false
				},
				{
					id: 'dspShareName',
					title: 'Treaty Name',
				  	width: '300',
				  	titleAlign: 'center',
				  	editable: false
				},
				{
					id: 'sharePct',
					title: 'Share Pct',
				  	width: '70',
					titleAlign: 'center',
					align: 'right',
				  	editable: false
				},
				{
					id: 'distYear',
					title: 'Dist Year',
				  	width: '70',
					titleAlign: 'center',
					align: 'right',
				  	editable: false
				},
				{
					id: 'shrRecoveryAmt',
					title: 'Share Recovery Amount',
				  	width: '140',
				  	titleAlign: 'center',
					align: 'right',
				  	editable: false, 
				  	renderer: function(value){
						return formatCurrency(value);
					}
				}
			 ],
			 rows: objRecDS.rows
		};
		
		recDSGrid = new MyTableGrid(recDSTable);
		recDSGrid.pager = objRecDS;
		recDSGrid.render('recoveryDistTableGrid');
	} catch(e) {
		showErrorMessage("recDSTable", e);
	}
			
	try {
		var objRecRids = JSON.parse('${recoveryRidsTableGrid}'.replace(/\\/g, '\\\\'));
		var recRidsTable = {
				url: contextPath+"/GICLRecoveryPaytController?action=showDistDetailsModal&loadTG=riDS&recoveryId="+$F("hidRecoveryId")
				 +"&recoveryPaytId="+$F("hidRecPaytId")+"&recDistNo="+0+"&grpSeqNo="+0,			//added parameter Halley 01.14.2014
				 options: {
					 title: '',
					 height: '110',
					 width: '620',
					 onCellFocus: function() {
					 },
		 			 onRemoveRowFocus: function(){
			 			 rowIndex = -1;
			 			 recRidsGrid.keys.releaseKeys();
		 			 }
				 },
				 columnModel: [
					{   
						id: 'recordStatus',
					    width: '0',
					    visible: false,
					    editor: 'checkbox' 			
					},
					{	
						id: 'divCtrId',
						width: '0',
						visible: false
					},
					{
						id: 'riCd',
						title: 'RI Code',
					  	width: '70',
					  	titleAlign: 'center',
					  	editable: false
					},
					{
						id: 'dspRiName',
						title: 'Reinsurer',
					  	width: '300',
					  	titleAlign: 'center',
					  	editable: false
					},
					{
						id: 'sharePct',
						title: 'Share Pct',
					  	width: '70',
					  	titleAlign: 'center',
						align: 'right',
					  	editable: false
					},
					{
						id: 'shrRiRecoveryAmt',
						title: 'Share Recovery Amount',
					  	width: '140',
					  	titleAlign: 'center',
						align: 'right',
						editable: false,
					  	renderer: function(value){
							return formatCurrency(value);
						}
					}
				 ],
				 rows: objRecRids.rows
			};
			
			recRidsGrid = new MyTableGrid(recRidsTable);
			recRidsGrid.pager = objRecRids;
			recRidsGrid.render('recoveryRidsTableGrid');
	} catch(e) {
		showErrorMessage("recRidsTable", e);
	}
	
	//created by Halley 01.14.2014
	function loadRecRidsTable(recDistNo, grpSeqNo){ 
		recRidsGrid.url = contextPath+"/GICLRecoveryPaytController?action=showDistDetailsModal&loadTG=riDS&recoveryId="+$F("hidRecoveryId")
		 				  			 +"&recoveryPaytId="+$F("hidRecPaytId")+"&recDistNo="+recDistNo+"&grpSeqNo="+grpSeqNo;
		recRidsGrid.refreshURL(recRidsGrid);
		recRidsGrid._refreshList();	
	} 
	
	$("btnDSReturn").observe("click", function() {
		distOverlay.close();
	});
</script>