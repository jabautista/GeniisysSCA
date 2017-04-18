<div id="batchCsrListingMainDiv" name="batchCsrListingMainDiv">
	<div id="batchCsrListingMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="batchCsrExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>List of Batch Claim Settlement Request</label>
		</div>
	</div>
	
	<div id="batchCsrTableGridSectionDiv" class="sectionDiv" style="height: 370px;">
		<div id="batchCsrTableGridDiv" style="padding: 10px;">
			<div id="batchCsrTableGrid" style="height: 325px; width: 900px;"></div>
		</div>
	</div>
</div>
<div id="batchCsrDiv" name="batchCsrDiv" style="display: none;"></div>

<script type="text/javascript">
	setModuleId("GICLS043");
	setDocumentTitle("Batch Claim Settlement Request");
	selectedIndex = -1;
	
	try{
		var objBatchCsrTbl = new Object();
		objBatchCsrTbl.objBatchCsrTableGrid = JSON.parse('${jsonBatchCsr}');
		objBatchCsrTbl.objBatchCsrList = objBatchCsrTbl.objBatchCsrTableGrid.rows || [];
		
		var batchCsrModel = {
			url: contextPath+"/GICLBatchCsrController?action=getGiclBatchCsrTableGrid&moduleId=GICLS043",
			options:{
				title: '',
				width: '900px',
				toolbar: {
					elements: [MyTableGrid.ADD_BTN, MyTableGrid.EDIT_BTN, MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onAdd: function(){
						batchCsrTableGrid.keys.releaseKeys();
						showBatchCsrPage(0);
					},
					onEdit: function(){
						if(selectedIndex >= 0){
							batchCsrTableGrid.keys.releaseKeys();
							var row = batchCsrTableGrid.geniisysRows[selectedIndex];
							showBatchCsrPage(1, row.batchCsrId);
						}else{
							showMessageBox("Please select a record first.", "E");
						}
					}
				},
				onCellFocus: function(element, value, x, y, id){
					var mtgId = batchCsrTableGrid._mtgId;
					selectedIndex = -1;
					if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
						selectedIndex = y;
					}
					batchCsrTableGrid.keys.releaseKeys();
				},
				onRowDoubleClick: function(y){
					var row = batchCsrTableGrid.geniisysRows[y];
					batchCsrTableGrid.keys.releaseKeys();
					showBatchCsrPage(1, row.batchCsrId);
				},
				onRemoveRowFocus: function(){
					selectedIndex = -1;
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
				{	id: 'batchCsrId',
					width: '0',
					visible: false
				},
				{	id: 'fundCd',
					title: 'Fund Code',
					width: '0',
					visible: false,
					filterOption: true
				},
				{	id: 'issueCode',
					title: 'Issue Code',
					width: '0',
					visible: false,
					filterOption: true
				},
				{	id: 'batchYear',
					title: 'Batch Year',
					width: '0',
					visible: false,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{	id: 'batchSequenceNumber',
					title: 'Batch Sequence Number',
					width: '0',
					visible: false,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{	id: 'batchCsrNo',
					title: 'Batch Number',
					width: '150px'
				},
				{	id: 'payeeClassDesc',
					title: 'Payee Class',
					width: '100px',
					filterOption: true,
					renderer : function(value){ // added by j.diago 04.15.2014
						return unescapeHTML2(value);
					}
				},
				{	id: 'payeeCode',
					title: 'Payee Code',
					width: '80px',
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{	id: 'payeeName',
					title: 'Payee Name',
					width: '180px',
					filterOption: true,
					renderer : function(value){ // added by j.diago 04.15.2014
						return unescapeHTML2(value);
					}
				},
				{	id: 'particulars',
					title: 'Particulars',
					width: '250px',
					filterOption: true,
					renderer : function(value){ // added by j.diago 04.15.2014
						return unescapeHTML2(value);
					}
				},
				{	id: 'paidAmount',
					title: 'Paid Amount',
					width: '100px',
					geniisysClass: 'money',
					align: 'right',
					titleAlign: 'right',
					filterOption: true,
					filterOptionType: 'number'
				},
				{	id: 'netAmount',
					title: 'Net Amount',
					width: '100px',
					geniisysClass: 'money',
					align: 'right',
					titleAlign: 'right',
					filterOption: true,
					filterOptionType: 'number'
				},
				{	id: 'adviceAmount',
					title: 'Advice Amount',
					width: '100px',
					geniisysClass: 'money',
					align: 'right',
					titleAlign: 'right',
					filterOption: true,
					filterOptionType: 'number'
				},
				{	id: 'currencyDesc',
					title: 'Currency',
					width: '150px',
					filterOption: true,
					renderer : function(value){ // added by j.diago 04.15.2014
						return unescapeHTML2(value);
					}
				},
				{	id: 'convertRate',
				    title: 'Convert Rate',
				    geniisysClass: 'rate',
				    align: 'right',
				    titleAlign: 'right',
					width: '90px',
					visible: true,
					filterOption: true,
					filterOptionType: 'numberNoNegative'
					
				},
				{	id: 'userId',
					title: 'User',
					width: '70px',
					filterOption: true
				},
				
			],
			requiredColumns: 'batchCsrId parNo payeeClassCode payeeCode',
			rows: objBatchCsrTbl.objBatchCsrList	
		};
	
		batchCsrTableGrid = new MyTableGrid(batchCsrModel);
		batchCsrTableGrid.pager = objBatchCsrTbl.objBatchCsrTableGrid;
		batchCsrTableGrid.render('batchCsrTableGrid');		
		
	}catch(e){
		showErrorMessage("batchCsrListing.jsp", e);
	}
	
	$("batchCsrExit").observe("click", function (){
		if(objGICLS051.previousModule != null && objGICLS051.previousModule == "GICLS051"){ // added by Kris 08.06.2013
			objGICLS051.previousModule = null;
			showGeneratePLAFLAPage(objGICLS051.currentView, objCLMGlobal.lineCd);
		} else if(objCLMGlobal.callingForm != "GICLS043"){
			showClaimListing();
		}else{
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
			setModuleId("");			
		}
	});

</script>