<div id="giclItemPerilGrid" style="height: 185px; margin:15px; margin-bottom:0px; width: 890px;"></div>
<div style="float: right; margin-right: 15px; margin-bottom:5px; margin-top:5px; height: 15px;">
	<label id="giclItemPerilCurrencyDesc" style="font-weight: bolder;">&nbsp;</label>
</div>

<script type="text/javascript">
	try{
		objGICLItemPeril = JSON.parse('${giclItemPerilList}');
		var giclItemPerilTableModel = {
			id : 2,
			url : contextPath + "/GICLItemPerilController?action=getItemPerilGrid3&claimId="+ nvl(objCLMGlobal.claimId, 0),
			options:{
				title: '',
				pager: { },
				width: '890px',
				masterDetail : true,
				masterDetailRequireSaving : true,
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN/*, MyTableGrid.FILTER_BTN*/],
					onRefresh: function(){
						clearAllLossExpRelatedRecords();
					},
					onFilter: function(){
						clearAllLossExpRelatedRecords();
					}
				},
				onCellFocus: function(element, value, x, y, id){
					if(checkChangeOfRecordInTG(giclItemPerilTableGrid, objCurrGICLItemPeril)){
						clearAllLossExpRelatedRecords();
						var giclItemPeril = giclItemPerilTableGrid.geniisysRows[y]; 
						objCurrGICLItemPeril = giclItemPeril;
						objCurrGICLItemPeril.index = y;
						$("giclItemPerilCurrencyDesc").innerHTML = unescapeHTML2(giclItemPeril.dspCurrDesc);
						retrievePayeeDetails(giclItemPeril);
					}
				},
				onRemoveRowFocus: function() {
					if(checkChangeOfRecordInTG(giclItemPerilTableGrid, objCurrGICLItemPeril)){
						clearAllLossExpRelatedRecords();
					}
				},
				beforeSort: function(){
					if (changeTag == 1 && checkLossExpChildRecords()){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}
				},
				onSort: function(){
					clearAllLossExpRelatedRecords();
				},
				masterDetailValidation : function(){
					if(checkLossExpChildRecords()){
						return true;
					}else{
						return false;
					}
				},
				masterDetailSaveFunc : function(){					
					$("btnSave").click();
				},
				masterDetailNoFunc : function(){
					resetAllLossExpHistObjects();
					clearAllLossExpRelatedRecords();
					changeTag = 0;										
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
				{ 	id: 'groupedItemNo',
					width: '0',
				  	visible:false
				},
				{	id: 'itemNo',
					width: '0',
					title: 'Item No',
					visible: false,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{ 	id: 'dspItemNo',
				  	align: 'right',
				  	title: '',
				  	titleAlign: 'center',
				  	width: '25px',
				  	editable: false,
				  	sortable: true 
				},
				{	id: 'dspItemTitle',
					align: 'left',
				  	title: 'Item',
				  	titleAlign: 'center',
				  	width: '170px',
				  	editable: false,
				  	sortable: true,
				  	filterOption: true
				},
				{ 	id: 'dspPerilName',
					align : 'left',
					title : 'Peril',
					titleAlign : 'center',
					width : '170px',
					editable: false,
					sortable: true,
					filterOption: true
				},
				{ 	id: 'dspGroupedItemTitle',
					align : 'left',
					title : 'Grouped Item',
					titleAlign : 'center',
					width : '170px',
					editable: false,
					sortable: true,
					filterOption: true
				},
				{
				   	id: 'annTsiAmt',
				   	title: 'Total Sum Insured',
				   	titleAlign: 'center',
				   	type : 'number',
				  	width: '116px',
				  	geniisysClass : 'money',
				  	filterOption: true,
					filterOptionType: 'number'
				},
				{
				   	id: 'allowTsiAmt',
				   	title: 'Allowable TSI',
				   	titleAlign: 'center',
				   	type : 'number',
				  	width: '115px',
				  	geniisysClass : 'money',
				  	filterOption: true,
					filterOptionType: 'number'
				},
				{
				   	id: 'allowNoOfDays',
				   	title: 'Allowable Days',
				   	titleAlign: 'center',
				  	width: '100px',
				  	filterOption: true,
					filterOptionType: 'integerNoNegative'
				}
			],
			rows : objGICLItemPeril.rows,
			requiredColumns: ''
		};
		
		giclItemPerilTableGrid = new MyTableGrid(giclItemPerilTableModel);
		giclItemPerilTableGrid.pager = objGICLItemPeril;
		giclItemPerilTableGrid.render('giclItemPerilGrid');
		
	}catch(e){
		showErrorMessage("Loss Expense Hist - giclItemPeril", e);
	}
	
	function clearAllLossExpRelatedRecords(){
		objCurrGICLItemPeril = null;
		$("giclItemPerilCurrencyDesc").innerHTML = "";
		clearAllLossExpRelatedObjects();
		clearLossExpRelatedTableGrids();
		disableButton("btnViewHistory");
		disableButton("btnCopyClmLossExp");
		giclItemPerilTableGrid.releaseKeys();
	}
</script>