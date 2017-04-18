<div id="deductiblesTableGrid" style="height: 181px; width: 650px;"></div>

<script type="text/javascript">
	try{
		var objLossExpDeductiblesTG = JSON.parse('${jsonLossExpDeductibles}');
		objLossExpDeductibles = objLossExpDeductiblesTG.rows || []; 
		
		var url = objCurrGICLClmLossExpense == null ? "" : contextPath + "/GICLLossExpDtlController?action=getLossExpDeductiblesTableGrid&claimId="+ nvl(objCurrGICLClmLossExpense.claimId, 0)
		          +"&clmLossId="+objCurrGICLClmLossExpense.claimLossId+"&payeeType="+objCurrGICLLossExpPayees.payeeType+"&lineCd="+objCLMGlobal.lineCd;
		
		var lossExpDeductiblesTableModel = {
			id : 8,
			url : url,
			options:{
				title: '',
				pager: { },
				masterDetail : true,
				masterDetailRequireSaving : true,
				width: '890px',
				//masterDetail : true,
				//masterDetailRequireSaving : true,
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN/*, MyTableGrid.FILTER_BTN*/],
					onRefresh: function(){
						clearLossExpDeductibleDetails();
					},
					onFilter: function(){
						clearLossExpDeductibleDetails();
					}
				},
				onCellFocus: function(element, value, x, y, id){
					clearLossExpDeductibleDetails();
					var ded = lossExpDeductiblesTableGrid.geniisysRows[y];
					objCurrLossExpDeductibles = ded;
					populateLossExpDeductibleForm(ded);
					if(ded.lossExpCd == $F("hidDepreciationCd")){ //Added by Kenneth 06.03.2015 @lines 36-46 SR 3640
						$("txtDedUnits").readOnly = true; 		 
						$("txtDedRate").readOnly = true; 		 
						$("txtDedBaseAmt").readOnly = true;	 
						$("txtDeductibleAmt").readOnly = true;
						$("hrefLossExpCd").hide();
						$("hrefDedLossExpCd").hide();
						disableButton("btnAddLossExpDeductible");
					}else{
						enableButton("btnAddLossExpDeductible");
					}
				},
				onRemoveRowFocus: function() {
					clearLossExpDeductibleDetails();
				},
				beforeSort: function(){
					if (hasPendingLossExpDeductibleRecords()){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}
				},
				onSort: function(){
					clearLossExpDeductibleDetails();
				},
				masterDetailValidation : function(){
					if (hasPendingLossExpDeductibleRecords()){
						return true;
					}else{
						return false;
					}
				},
				masterDetailSaveFunc : function(){					
					$("btnSaveDeductibles").click();
				},
				masterDetailNoFunc : function(){
					clearLossExpDeductibleDetails();	
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
				{	id: 'dspExpDesc',
					align: 'left',
				  	title: 'Loss Expense',
				  	titleAlign: 'center',
				  	width: '200px',
				  	editable: false,
				  	sortable: true,
				  	filterOption: true
				},
				{	id: 'dspDedLeDesc',
					align: 'left',
				  	title: 'For Loss Expense',
				  	titleAlign: 'center',
				  	width: '120px',
				  	editable: false,
				  	sortable: true,
				  	filterOption: true
				},
				{	id: 'nbtDedType',
					align: 'left',
				  	title: 'Deductible Type',
				  	titleAlign: 'center',
				  	width: '120px',
				  	editable: false,
				  	sortable: true,
				  	filterOption: true
				},
				{	id: 'nbtNoOfUnits',
					align: 'right',
				  	title: 'Unit(s)',
				  	titleAlign: 'center',
				  	width: '70px',
				  	editable: false,
				  	sortable: true,
				  	filterOption: true,
				  	filterOptionType: 'integerNoNegative'
				},
				{
				   	id: 'dedRate',
				   	title: 'Ded. Rate',
				   	titleAlign: 'center',
				   	type : 'number',
				  	width: '100px',
				  	geniisysClass : 'rate'
				},
				{
				   	id: 'dedBaseAmt',
				   	title: 'Base Amount',
				   	titleAlign: 'center',
				   	type : 'number',
				  	width: '130px',
				  	geniisysClass : 'money',
				  	filterOption: true,
					filterOptionType: 'number'
				},
				{
				   	id: 'dtlAmt',
				   	title: 'Deductible Amount',
				   	titleAlign: 'center',
				   	type : 'number',
				  	width: '130px',
				  	geniisysClass : 'money',
				  	filterOption: true,
					filterOptionType: 'number'
				}
				
			],
			rows : objLossExpDeductibles,
			requiredColumns: ''
		};
		
		lossExpDeductiblesTableGrid = new MyTableGrid(lossExpDeductiblesTableModel);
		lossExpDeductiblesTableGrid.pager = objLossExpDeductiblesTG;
		lossExpDeductiblesTableGrid.render('deductiblesTableGrid');
		computeTotalDeductibleAmt();
		populateLossExpDeductibleForm(null);
		objCurrLossExpDeductibles = null;
		
		if(objLossExpDeductibles.length == 0){
			disableButton("btnClearDeductibles");
		}
		
	}catch(e){
		showErrorMessage("Loss Expense Hist - Deductibles", e);
	}
	
	function clearLossExpDeductibleDetails(){
		lossExpDeductiblesTableGrid.releaseKeys();
		enableButton("btnAddLossExpDeductible"); //Added by Kenneth 06.03.2015 SR 3640
		populateLossExpDeductibleForm(null);
		objCurrLossExpDeductibles = null;
	}
	
</script>