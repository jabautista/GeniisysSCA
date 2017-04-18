<div id="giclLossExpTaxTableGrid" style="height: 181px; margin:10px; width: 862px;"></div>

<script type="text/javascript">
	try{
		var objGICLLossExpTaxTG = JSON.parse('${jsonGiclLossExpTax}');
		objGICLLossExpTax = objGICLLossExpTaxTG.rows || [];
		
		var giclLossExpTaxTableModel = {
			id : 10,
			url : contextPath + "/GICLLossExpTaxController?action=getGiclLossExpTaxList"
					          + "&claimId="+ nvl(objCurrGICLClmLossExpense.claimId, 0)
					          + "&clmLossId="+objCurrGICLClmLossExpense.claimLossId
					          + "&issCd="+objCLMGlobal.issueCode,
			options:{
				title: '',
				pager: { },
				width: '862px',
				masterDetail : true,
				masterDetailRequireSaving : true,
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN/*, MyTableGrid.FILTER_BTN*/],
					onRefresh: function(){
						clearLossExpTaxForm();
					},
					onFilter: function(){
						clearLossExpTaxForm();
					}
				},
				onCellFocus: function(element, value, x, y, id){
					clearLossExpTaxForm();
					var lossExpTax = giclLossExpTaxTableGrid.geniisysRows[y];
					populateLossExpTaxForm(lossExpTax);
				},
				onRemoveRowFocus: function() {
					clearLossExpTaxForm();
				},
				beforeSort: function(){
					if (hasPendingLossExpTaxRecords()){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}
				},
				onSort: function(){
					clearLossExpTaxForm();
				},
				masterDetailValidation : function(){
					if (hasPendingLossExpTaxRecords()){
						return true;
					}else{
						return false;
					}
				},
				masterDetailSaveFunc : function(){					
					$("btnSaveTax").click();
				},
				masterDetailNoFunc : function(){
					clearLossExpTaxForm();										
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
				{	id: 'taxType',
					align: 'left',
				  	title: 'Type',
				  	titleAlign: 'center',
				  	width: '50px',
				  	editable: false,
				  	sortable: true,
				  	filterOption: true
				},
				{ 	id: 'taxCd',
				  	align: 'right',
				  	title: 'Code',
				  	titleAlign: 'center',
				  	width: '50px',
				  	editable: false,
				  	sortable: true,
				  	renderer : function(value){
						return lpad(value.toString(), 5, "0");					
					}
				},
				{	id: 'taxName',
					align: 'left',
				  	title: 'Tax Name',
				  	titleAlign: 'center',
				  	width: '265px',
				  	editable: false,
				  	sortable: true,
				  	filterOption: true
				},
				{ 	id: 'slCd',
				  	align: 'right',
				  	title: 'SL Code',
				  	titleAlign: 'center',
				  	width: '85px',
				  	editable: false,
				  	sortable: true,
				  	renderer : function(value){
						return lpad(value.toString(), 12, "0");					
					}
				},
				{ 	id: 'lossExpCd',
				  	title: 'LE',
				  	titleAlign: 'center',
				  	width: '50px',
				  	editable: false,
				  	sortable: true 
				},
				{
				   	id: 'baseAmt',
				   	title: 'Base Amount',
				   	titleAlign: 'center',
				   	type : 'number',
				  	width: '120px',
				  	geniisysClass : 'money',
				  	filterOption: true,
					filterOptionType: 'number'
				},
				{
				   	id: 'taxPct',
				   	title: 'Tax Pct.',
				   	titleAlign: 'center',
				   	type : 'number',
				  	width: '100px',
				  	geniisysClass : 'rate'
				},
				{
				   	id: 'taxAmt',
				   	title: 'Tax Amount',
				   	titleAlign: 'center',
				   	type : 'number',
				  	width: '120px',
				  	geniisysClass : 'money',
				  	filterOption: true,
					filterOptionType: 'number'
				}
			],
			rows : objGICLLossExpTax,
			requiredColumns: ''
		};
		
		giclLossExpTaxTableGrid = new MyTableGrid(giclLossExpTaxTableModel);
		giclLossExpTaxTableGrid.pager = objGICLLossExpTaxTG;
		giclLossExpTaxTableGrid.render('giclLossExpTaxTableGrid');
		computeTotalTaxAmount();
		
	}catch(e){
		showErrorMessage("Loss Expense Hist - Loss Tax", e);
	}
	
	function clearLossExpTaxForm(){
		giclLossExpTaxTableGrid.releaseKeys();
		populateLossExpTaxForm(null);
	}
</script>