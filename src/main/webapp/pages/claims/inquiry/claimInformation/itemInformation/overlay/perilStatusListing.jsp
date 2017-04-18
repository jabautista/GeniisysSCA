<div id="perilStatusMainDiv" name="perilStatusMainDiv">
	<div id="perilStatusTableGridDiv" style="margin: 10px 12px">
		<div id="perilStatusGridDiv" style="height: 225px; margin-top: 5px;">
			<div id="perilStatusTableGrid" style="height: 225px; width: 810px;"></div>
		</div>
		<div class="buttonsDiv" align="center" style="margin-bottom: 5px;">
			<input type="button" id="btnOk" name="btnOk" style="width: 120px;" class="button hover"  value="Return" />
		</div>
	</div>
</div>

<script type="text/javascript">
	try{
		var objPerilStatus = JSON.parse('${jsonPerilStatusList}');
		objPerilStatus.perilStatusListing = objPerilStatus.rows || [];
		
		var perilStatusTableModel = {
			url : contextPath + "/GICLItemPerilController?action=getGICLS260PerilStatus&claimId="+ nvl(objCLMGlobal.claimId, 0)
					          + "&lineCd="+(objCLMGlobal.callingForm == "GICLS271" ? objCLMGlobal.lineCode : $("lineCd").value)+"&itemNo="+$("txtItemNo").value,
			options : {
				title : '',
				width : '810px',
				pager: {}, 
				hideColumnChildTitle: true,
				toolbar : {
					elements : [ MyTableGrid.REFRESH_BTN],
					onRefresh : function() {
						perilStatusTableGrid.keys.removeFocus(perilStatusTableGrid.keys._nCurrentFocus, true);
						perilStatusTableGrid.keys.releaseKeys();
					}
				},
				onCellFocus : function(element, value, x, y, id) {
					perilStatusTableGrid.keys.removeFocus(perilStatusTableGrid.keys._nCurrentFocus, true);
					perilStatusTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus : function() {
					perilStatusTableGrid.keys.removeFocus(perilStatusTableGrid.keys._nCurrentFocus, true);
					perilStatusTableGrid.keys.releaseKeys();
				},
				onSort : function() {
					perilStatusTableGrid.keys.removeFocus(perilStatusTableGrid.keys._nCurrentFocus, true);
					perilStatusTableGrid.keys.releaseKeys();
				}
			},columnModel:[{
					id : 'recordStatus',
					title : '',
					width : '0',
					visible : false,
					editor : 'checkbox'
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},
			   	{
					id: 'perilCd dspPerilName',
					title: 'Peril',
					width : 250,
					children : [
			            {
			                id : 'perilCd',
			                width : 50,
			                editable: false 		
			            },
			            {
			                id : 'dspPerilName', 
			                width : 240,
			                editable: false
			            }
					]
				},
			   	{
					id: 'lossCatCd dspLossCatDes',
					title: 'Loss Category',
					width : 250,
					children : [
			            {
			                id : 'lossCatCd',
			                width : 50,
			                editable: false 		
			            },
			            {
			                id : 'dspLossCatDes', 
			                width : 240,
			                editable: false
			            }
					]
				},
				{  	id: 'nbtCloseFlag',
					title: 'Loss Status',
				   	width: 105
				},
				{  	id: 'nbtCloseFlag2',
					title: 'Expense Status',
				   	width: 105
				}
			],
			rows : objPerilStatus.perilStatusListing
		};
			
		perilStatusTableGrid = new MyTableGrid(perilStatusTableModel);
		perilStatusTableGrid.pager = objPerilStatus;
		perilStatusTableGrid.render('perilStatusTableGrid');
		
		$("btnOk").observe("click", function(){
			Windows.close("peril_stat_canvas");
		});
		
	}catch(e){
		showErrorMessage("Claims Information - Peril Status", e);
	}
	
</script>