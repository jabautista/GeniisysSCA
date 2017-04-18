<div id="leViewHistMainDiv" name="leViewHistMainDiv">
	<div id="leViewHistTableGridDiv" style="margin: 10px 12px">
		<div id="leViewHistGridDiv" style="height: 225px; margin-top: 5px;">
			<div id="leViewHistTableGrid" style="height: 225px; width: 890px;"></div>
		</div>
		<div class="buttonsDiv" align="center" style="margin-bottom: 5px;">
			<input type="hidden" id="hidItemNo"  	   name="hidItemNo" 		value="${itemNo}">
			<input type="hidden" id="hidPerilCd"  	   name="hidPerilCd" 		value="${perilCd}">
			<input type="hidden" id="hidPayeeType"     name="hidPayeeType" 		value="${payeeType}">
			<input type="hidden" id="hidPayeeClassCd"  name="hidPayeeClassCd" 	value="${payeeClassCd}">
			<input type="hidden" id="hidPayeeCd"  	   name="hidPayeeCd" 		value="${payeeCd}">
			<input type="hidden" id="hidClmLossId"     name="hidClmLossId"  	value="${clmLossId}">
			<input type="button" id="btnLEDistribution" name="btnLEDistribution" style="width: 120px;" class="disabledButton hover"  value="Distribution" />
			<input type="button" id="btnOk" name="btnOk" style="width: 120px;" class="button hover"  value="Return" />
		</div>
	</div>
</div>

<script type="text/javascript">
	try{
		var objLEViewHist = JSON.parse('${jsonViewHist}');
		objLEViewHist.viewHistListing = objLEViewHist.rows || [];
		var selectedRecord = null;
		
		var viewHistTableModel = {
			url : contextPath + "/GICLClaimLossExpenseController?action=showGICLS260LossExpViewHist"+
				  "&claimId="+ nvl(objCLMGlobal.claimId, 0)+"&itemNo="+$("hidItemNo").value+
				  "&perilCd="+$("hidPerilCd").value+"&payeeType="+$("hidPayeeType").value+
				  "&payeeClassCd="+$("hidPayeeClassCd").value+"&payeeCd="+$("hidPayeeCd").value+
				  "&clmLossId="+$("hidClmLossId").value+"&lineCd="+objCLMGlobal.lineCode,
			options:{
				title: '',
				pager: { },
				width: '890px',
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onRefresh: function(){
						selectedRecord = null;
						disableButton("btnLEDistribution");
						viewHistTableGrid.keys.removeFocus(viewHistTableGrid.keys._nCurrentFocus, true);
						viewHistTableGrid.keys.releaseKeys();
					}
				},
				onCellFocus: function(element, value, x, y, id){
					selectedRecord = viewHistTableGrid.geniisysRows[y];
					selectedRecord.distSw == "Y" ? enableButton("btnLEDistribution") : disableButton("btnLEDistribution");
					viewHistTableGrid.keys.removeFocus(viewHistTableGrid.keys._nCurrentFocus, true);
					viewHistTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus: function() {
					selectedRecord = null;
					disableButton("btnLEDistribution");
					viewHistTableGrid.keys.removeFocus(viewHistTableGrid.keys._nCurrentFocus, true);
					viewHistTableGrid.keys.releaseKeys();
				},
				onSort: function() {
					selectedRecord = null;
					disableButton("btnLEDistribution");
					viewHistTableGrid.keys.removeFocus(viewHistTableGrid.keys._nCurrentFocus, true);
					viewHistTableGrid.keys.releaseKeys();
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
				{	id: 'historySequenceNumber',
					align: 'right',
				  	title: 'Hist.',
				  	titleAlign: 'center',
				  	width: '50px',
				  	editable: false,
				  	sortable: true,
				  	filterOption: true
				},
				{	id: 'clmLossExpStatDesc',
					align: 'left',
				  	title: 'History Status',
				  	titleAlign: 'center',
				  	width: '150px',
				  	editable: false,
				  	sortable: true,
				  	filterOption: true
				},
				{	id: 'distSw',
					align: 'left',
				  	title: 'D',
				  	altTitle: "Distribution Switch",
				  	titleAlign: 'center',
				  	width: '25px',
				  	editable: false,
				  	sortable: true,
				  	filterOption: true
				},
				{	id: 'itemNo',
					align: 'right',
				  	title: 'Item',
				  	titleAlign: 'center',
				  	width: '50px',
				  	editable: false,
				  	sortable: true,
				  	renderer : function(value){
						return lpad(value.toString(), 3, "0");					
					},
					filterOption: true
				},
				{	id: 'perilSname',
					align: 'left',
				  	title: 'Peril',
				  	titleAlign: 'center',
				  	width: '60px',
				  	editable: false,
				  	sortable: true,
				  	filterOption: true
				},
				{	id: 'payeeClassCode',
					align: 'right',
				  	title: 'Class',
				  	titleAlign: 'center',
				  	width: '50px',
				  	editable: false,
				  	sortable: true,
				  	filterOption: true
				},
				{	id: 'payee',
					align: 'left',
				  	title: 'Payee Name',
				  	titleAlign: 'center',
				  	width: '168px',
				  	editable: false,
				  	sortable: true,
				  	filterOption: true
				},
				{
				   	id: 'paidAmount',
				   	title: 'Paid Amount',
				   	titleAlign: 'center',
				   	type : 'number',
				  	width: '100px',
				  	geniisysClass : 'money',
				  	filterOption: true,
				  	filterOptionType: 'number'
				},
				{
				   	id: 'netAmount',
				   	title: 'Net Amount',
				   	titleAlign: 'center',
				   	type : 'number',
				  	width: '100px',
				  	geniisysClass : 'money',
				  	filterOption: true,
				  	filterOptionType: 'number'
				},
				{
				   	id: 'adviceAmount',
				   	title: 'Advice Amount',
				   	titleAlign: 'center',
				   	type : 'number',
				  	width: '110px',
				  	geniisysClass : 'money',
				  	filterOption: true,
				  	filterOptionType: 'number'
				}
				
			],
			rows : objLEViewHist.viewHistListing,
			requiredColumns: ''
		};
		
		viewHistTableGrid = new MyTableGrid(viewHistTableModel);
		viewHistTableGrid.pager = objLEViewHist;
		viewHistTableGrid.render('leViewHistTableGrid');
		
		$("btnOk").observe("click", function(){
			Windows.close("modal_dialog_lov");
		});
		
		$("btnLEDistribution").observe("click", function(){
			if(selectedRecord == null){
				showMessageBox("Please select record first.", "I");
				return false;
			}
			
			overlayDist = Overlay.show(contextPath+"/GICLLossExpDsController", {
				urlContent: true,
				urlParameters: {action : "showGICLS260LossExpDist",
								claimId : objCLMGlobal.claimId,
								clmLossId: selectedRecord.claimLossId, //$("hidClmLossId").value,
								calledFrom: "viewHistory",
								ajax: 1
				},
				title: "View Distribution Details",	
				id: "view_dist_canvas",
				width: 800,
				height: 450,
			    draggable: false,
			    closable: true
			});
		});
		
	}catch(e){
		showErrorMessage("Claim Information - Loss Expense Hist - View History Listing", e);
	}
</script>