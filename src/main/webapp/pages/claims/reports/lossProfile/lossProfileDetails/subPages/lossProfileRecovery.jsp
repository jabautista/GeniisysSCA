<div id="lossProfileRecoveryMainDiv" class="sectionDiv" style="height: 285px; width: 797px; margin-top: 10px;">
	<div id="recoveryDetailTGDiv" style="float: left; height: 245px; width: 96.4%; margin-top: 10px; margin-left: 10px;">
		
	</div>
	<div style="float: left; width: 100%;">
		<labels style="margin-left: 85px; margin-top: 3px;">Totals</label>
		<input type="text" id="txtSumGrossLossRec" style="margin-left: 5px; width: 150px; text-align: right;" readonly="readonly"/>
		<input type="text" id="txtSumNetRetRec" style="margin-left: 1px; width: 146px; text-align: right;" readonly="readonly"/>
		<input type="text" id="txtSumTreatyRec" style="margin-left: 1px; width: 144px; text-align: right;" readonly="readonly"/>
		<input type="text" id="txtSumFaculRec" style="margin-left: 1px; width: 145px; text-align: right;" readonly="readonly"/>
	</div>
</div>
<div style="float: left;">
	<input type="button" class="button" id="btnReturn" value="Return" style="width: 100px; margin-top: 10px; margin-left: 354px;"/>
</div>
<script type="text/JavaScript">
try{
	try{
		var objLPRec = new Object();
		objLPRec.objLossProfileRecoveryTableGrid = JSON.parse('${jsonRecoveryDtl}');
		objLPRec.objLossProfileRecovery = objLPRec.objLossProfileRecoveryTableGrid.rows || []; 
		
		var lossProfileRecoveryModel = {
			url:contextPath+"/GICLLossProfileController?action=showRecoveryListing&refresh=1&claimId="+$F("hidClaimId")+"&globalExtr="+$F("hidExtr"),
			options:{
				id: 7,
				width: '777px',
				height: '218px',
				onCellFocus: function(element, value, x, y, id){
					lossProfileRecoveryTableGrid.keys.removeFocus(lossProfileRecoveryTableGrid.keys._nCurrentFocus, true);
					lossProfileRecoveryTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus:function(element, value, x, y, id){
					lossProfileRecoveryTableGrid.keys.removeFocus(lossProfileRecoveryTableGrid.keys._nCurrentFocus, true);
					lossProfileRecoveryTableGrid.keys.releaseKeys();
				},
				toolbar:{
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onRefresh: function() {
						lossProfileRecoveryTableGrid.keys.removeFocus(lossProfileRecoveryTableGrid.keys._nCurrentFocus, true);
						lossProfileRecoveryTableGrid.keys.releaseKeys();
					}
				},
			},
			columnModel:[
		 		{   id: 'recordStatus',
				    title: '',
				    width: '0px',
				    visible: false,
				    editor: 'checkbox' 			
				},
				{	id: 'divCtrId',
					width: '0px',
					visible: false
				},
				{	id: 'nbtRecNo',
					title: 'Recovery No.',
					width: '115px',
					align: 'left',
					visible: true,
					sortable: true,
					filterOption: true
				},
				{	id: 'nbtGrossLoss',
					title: 'Gross Loss',
					width: '155px',
					align: 'right',
					geniisysClass: 'money',
					visible: true,
					sortable: true
					
				},
				{	id: 'nbtNetRet',
					title: 'Net Retention',
					width: '155px',
					align: 'right',
					geniisysClass: 'money',
					visible: true,
					sortable: true
				},
				{	id: 'nbtTreaty',
					title: 'Treaty',
					width: '155px',
					align: 'right',
					geniisysClass: 'money',
					visible: true,
					sortable: true
				},
				{	id: 'nbtFacul',
					title: 'Facultative',
					width: '155px',
					align: 'right',
					geniisysClass: 'money',
					visible: true,
					sortable: true
				},
			],
			rows: objLPRec.objLossProfileRecovery
		};
		lossProfileRecoveryTableGrid = new MyTableGrid(lossProfileRecoveryModel);
		lossProfileRecoveryTableGrid.pager = objLPRec.objLossProfileRecoveryTableGrid;
		lossProfileRecoveryTableGrid.render('recoveryDetailTGDiv');
		lossProfileRecoveryTableGrid.afterRender = function(){
			try{
				if(objLPRec.objLossProfileRecovery.length > 0){
					var i = objLPRec.objLossProfileRecovery.length - 1;
					$("txtSumGrossLossRec").value = formatCurrency(objLPRec.objLossProfileRecovery[i].sumNbtGrossLoss);
					$("txtSumNetRetRec").value = formatCurrency(objLPRec.objLossProfileRecovery[i].sumNbtNetRet);
					$("txtSumTreatyRec").value = formatCurrency(objLPRec.objLossProfileRecovery[i].sumNbtTreaty);
					$("txtSumFaculRec").value = formatCurrency(objLPRec.objLossProfileRecovery[i].sumNbtFacul);	
				}	
			}catch(e){
				showErrorMessage("lossProfileRecoveryTableGrid.afterRender", e);				
			}
		};
	}catch(e){
		showErrorMessage("lossProfileRecoveryTableGrid",e);
	}
	
	$("btnReturn").observe("click", function(){
		lossProfileRecoveryOverlay.close();
	});
}catch(e){
	showErrorMessage("lossProfileRecovery.jsp", e);
}
</script>