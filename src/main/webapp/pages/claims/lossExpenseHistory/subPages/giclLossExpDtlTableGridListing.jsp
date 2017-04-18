<div id="giclLossExpDtlTableGrid" style="height: 181px; margin:15px; margin-bottom:0px; width: 890px;"></div>

<script type="text/javascript">
try{
	var objGICLLossExpDtlTG = JSON.parse('${jsonGiclLossExpDtl}');
	objGICLLossExpDtl = objGICLLossExpDtlTG.rows || []; 
	
	var url = objCurrGICLClmLossExpense == null ? "" : contextPath + "/GICLLossExpDtlController?action=getGiclLossExpDtlList&ajax=1&claimId="+ nvl(objCurrGICLClmLossExpense.claimId, 0)
	          +"&clmLossId="+objCurrGICLClmLossExpense.claimLossId+"&payeeType="+objCurrGICLLossExpPayees.payeeType+"&lineCd="+objCLMGlobal.lineCd;
	
	var giclLossExpDtlTableModel = {
		id : 5,
		url : url,
		options:{
			title: '',
			pager: { },
			width: '890px',
			masterDetail : true,
			masterDetailRequireSaving : true,
			toolbar: {
				elements: [MyTableGrid.REFRESH_BTN/*, MyTableGrid.FILTER_BTN*/],
				onRefresh: function(){
					clearLossExpDtlForm();
				},
				onFilter: function(){
					clearLossExpDtlForm();
				}
			},
			onCellFocus: function(element, value, x, y, id){
				clearLossExpDtlForm();
				var lossExpDtl = giclLossExpDtlTableGrid.geniisysRows[y];
				objCurrGICLLossExpDtl = lossExpDtl;
				populateLossExpDtlForm(lossExpDtl);
			},
			onRemoveRowFocus: function() {
				clearLossExpDtlForm();
			},
			onSort: function(){
				clearLossExpDtlForm();
			},
			beforeSort: function(){
				if (changeTag == 1 && hasPendingLossExpDtlRecords()){
					showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
					return false;
				}
			},
			masterDetailValidation : function(){
				if (changeTag == 1 && hasPendingLossExpDtlRecords()){
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
				clearLossExpDtlForm();
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
			{
				id: 'originalSw',
				title: '&#160;&#160;O',
				altTitle: 'Tag for Orig. Amount',
				width: '24px',
				align: 'center',
				titleAlign: 'center',
				editable: false,
				sortable: false,
				defaultValue: false,
				otherValue: false,
				editor: new MyTableGrid.CellCheckbox({
			        getValueOf: function(value){
		            	if (value){
							return "Y";
		            	}else{
							return "N";	
		            	}
	            	}
	            })
			},
			{
				id: 'withTax',
				title: 'WT',
				altTitle: 'With Tax',
				width: '24px',
				align: 'center',
				titleAlign: 'center',
				editable: false,
				sortable: false,
				defaultValue: false,
				otherValue: false,
				editor: new MyTableGrid.CellCheckbox({
			        getValueOf: function(value){
		            	if (value){
							return "Y";
		            	}else{
							return "N";	
		            	}
	            	}
	            })
			},
			{	id: 'lossExpCd',
				width: '0',
				visible: false
			},
			{	id: 'dspExpDesc',
				align: 'left',
			  	title: 'Loss',
			  	titleAlign: 'center',
			  	width: '250px',
			  	editable: false,
			  	sortable: true,
			  	filterOption: true
			},
			{	id: 'nbtNoOfUnits',
				align: 'right',
			  	title: 'Unit(s)',
			  	titleAlign: 'center',
			  	width: '90px',
			  	editable: false,
			  	sortable: true,
			  	filterOption: true,
			  	filterOptionType: 'integerNoNegative'
			},
			{
			   	id: 'dedBaseAmt',
			   	title: 'Base Amount',
			   	titleAlign: 'center',
			   	type : 'number',
			  	width: '160px',
			  	geniisysClass : 'money',
			  	filterOption: true,
				filterOptionType: 'number'
			},
			{
			   	id: 'dtlAmt',
			   	title: 'Loss Amount',
			   	titleAlign: 'center',
			   	type : 'number',
			  	width: '160px',
			  	geniisysClass : 'money',
			  	filterOption: true,
				filterOptionType: 'number'
			},
			{
			   	id: 'nbtNetAmt',
			   	title: 'Amount Less Deductibles',
			   	titleAlign: 'center',
			   	type : 'number',
			  	width: '160px',
			  	geniisysClass : 'money',
			  	filterOption: true,
				filterOptionType: 'number'
			}
			
		],
		rows : objGICLLossExpDtl,
		requiredColumns: ''
	};
	
	giclLossExpDtlTableGrid = new MyTableGrid(giclLossExpDtlTableModel);
	giclLossExpDtlTableGrid.pager = objGICLLossExpDtlTG;
	giclLossExpDtlTableGrid.render('giclLossExpDtlTableGrid');
	
}catch(e){
	showErrorMessage("Loss Expense Hist - giclLossExpDtl", e);
}

computeTotalsForLossExpDtl();

</script>