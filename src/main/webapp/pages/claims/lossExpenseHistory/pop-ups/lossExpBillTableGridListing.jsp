<div id="giclLossExpBillTableGrid" style="height: 181px; margin:10px; width: 863px;"></div>

<script type="text/javascript">
	try{
		var objGICLLossExpBillTG = JSON.parse('${jsonGiclLossExpBill}');
		objGICLLossExpBill = objGICLLossExpBillTG.rows || []; 
		
		var url = objCurrGICLClmLossExpense == null ? "" : contextPath + "/GICLLossExpBillController?action=getGiclLossExpBillTableGrid&claimId="+ nvl(objCurrGICLClmLossExpense.claimId, 0)+"&clmLossId="+objCurrGICLClmLossExpense.claimLossId;
		
		var giclLossExpBillTableModel = {
			id : 11,
			url : url,
			options:{
				title: '',
				width: '863px',
				hideColumnChildTitle: true,
				pager: { },
				masterDetail : true,
				masterDetailRequireSaving : true,
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN/*, MyTableGrid.FILTER_BTN*/],
					onRefresh: function(){
						clearLossExpBillForm();
					},
					onFilter: function(){
						clearLossExpBillForm();
					}
				},
				onCellFocus: function(element, value, x, y, id){
					clearLossExpBillForm();
					var lossExpBill = giclLossExpBillTableGrid.geniisysRows[y];
					populateLossExpBillForm(lossExpBill);
				},
				onRemoveRowFocus: function() {
					clearLossExpBillForm();
				},
				beforeSort: function(){
					if (hasPendingLossExpBillRecords()){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}				
				},
				onSort: function(){
					clearLossExpBillForm();
				},
				masterDetailValidation : function(){
					if (hasPendingLossExpBillRecords()){
						return true;
					}else{
						return false;
					}
				},
				masterDetailSaveFunc : function(){					
					$("btnSaveBill").click();
				},
				masterDetailNoFunc : function(){
					clearLossExpBillForm();
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
				{	id: 'docTypeDesc',
					align: 'left',
				  	title: 'Type',
				  	titleAlign: 'center',
				  	width: '70px',
				  	editable: false,
				  	sortable: true,
				  	filterOption: true
				},
				{
					id : 'dspPayeeClass dspPayee',
					title : 'Company',
					width : '400px',
					sortable : false,					
					children : [
						{
							id : 'dspPayeeClass',							
							width : 100,
							title : 'Payee Class',
							filterOption: true,
							sortable : false,
							editable : false,
							renderer : function(value){
								return unescapeHTML2(value);
							}
						},
						{
							id : 'dspPayee',							
							width : 300,
							title : 'Payee',
							filterOption: true,
							sortable : false,
							editable : false,							
							renderer : function(value){
								return unescapeHTML2(value);
							}
						}
					]					
				},
				{	
					id: 'billDate',
					title: 'Bill Date',
					width: '100px',
					filterOption: true,
					filterOptionType: 'formattedDate',
					sortable: true,
					align: 'center',
					type: 'date',
					titleAlign: 'center'
				},
				{	id: 'docNumber',
					align: 'left',
				  	title: 'Number',
				  	titleAlign: 'center',
				  	width: '150px',
				  	editable: false,
				  	sortable: true,
				  	filterOption: true
				},
				{
				   	id: 'amount',
				   	title: 'Amount',
				   	titleAlign: 'center',
				   	type : 'number',
				  	width: '125px',
				  	geniisysClass : 'money',
				  	filterOption: true,
					filterOptionType: 'number'
				}
			],
			rows : objGICLLossExpBill,
			requiredColumns: ''
		};
		
		giclLossExpBillTableGrid = new MyTableGrid(giclLossExpBillTableModel);
		giclLossExpBillTableGrid.pager = objGICLLossExpBillTG;
		giclLossExpBillTableGrid.render('giclLossExpBillTableGrid');
		
	}catch(e){
		showErrorMessage("Loss Expense Hist - Bill Information", e);
	}
	
	function clearLossExpBillForm(){
		giclLossExpBillTableGrid.releaseKeys();
		populateLossExpBillForm(null);
	}

</script>