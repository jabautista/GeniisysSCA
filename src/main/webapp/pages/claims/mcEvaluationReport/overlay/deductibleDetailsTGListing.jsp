<div style="height: 200px;">
	<div id="evalDeductibleTgDiv" style="height: 200px; "></div>
</div>

<script type="text/javascript">
	try{
		var objGICLEvalDeductiblesTG = JSON.parse('${jsonGiclEvalDeductibles}');
		objGICLEvalDeductiblesArr = JSON.parse('${jsonGiclEvalDeductibles}').rows || []; 
			
		var evalDeductiblesTableModel = {
			id : 9,
			url : contextPath+"/GICLEvalDeductiblesController?action=getGiclEvalDeductibles&refresh=1&evalId="+selectedMcEvalObj.evalId,
			options:{
				newRowPosition: 'bottom',
				title: '',
				pager: { },
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN],
					onRefresh: function(){
						clearEvalDeductibleDetails();
					}
				},
				prePager: function(){
					if(changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
						return false;
					}
				},
				onCellFocus: function(element, value, x, y, id){
					clearEvalDeductibleDetails();
					var ded = evalDeductiblesTableGrid.geniisysRows[y];
					populateEvalDeductible(ded);
					
				},
				onRemoveRowFocus: function() {
					clearEvalDeductibleDetails();
				},
				beforeSort: function(){
					if(changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
						return false;
					}
				},
				onSort: function(){
					clearEvalDeductibleDetails();
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
				  	title: 'Deductible',
				  	titleAlign: 'center',
				  	width: '200px',
				  	editable: false,
				  	sortable: true,
				  	filterOption: true
				},
				{	id: 'dspCompanyDesc',
					align: 'left',
				  	title: 'Company',
				  	titleAlign: 'center',
				  	width: '200px',
				  	editable: false,
				  	sortable: true,
				  	filterOption: true
				},
				{	id: 'noOfUnit',
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
				  	width: '136px',
				  	geniisysClass : 'money',
				  	filterOption: true,
					filterOptionType: 'number'
				},
				{
				   	id: 'dedAmt',
				   	title: 'Deductible Amount',
				   	titleAlign: 'center',
				   	type : 'number',
				  	width: '136px',
				  	geniisysClass : 'money',
				  	filterOption: true,
					filterOptionType: 'number'
				}
			],
			rows : objGICLEvalDeductiblesTG.rows,
			requiredColumns: ''
		};
		
		evalDeductiblesTableGrid = new MyTableGrid(evalDeductiblesTableModel);
		evalDeductiblesTableGrid.pager = objGICLEvalDeductiblesTG;
		evalDeductiblesTableGrid.render('evalDeductibleTgDiv');
		computeTotalEvalDedAmt();
		enableDisableApplyDeductible();
		
	}catch(e){
		showErrorMessage("MC Evaluation - Deductible Details", e);
	}
	
	function clearEvalDeductibleDetails(){
		evalDeductiblesTableGrid.releaseKeys();
		populateEvalDeductible(null);
	}
</script>