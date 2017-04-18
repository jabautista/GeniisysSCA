<div id="clmLossExpTableGrid" style="height: 181px; margin:15px; width: 890px;"></div>

<script type="text/javascript">
	try{
		clmLossExpInsertSw = "N";
		var objGICLClmLossExpenseTG = JSON.parse('${jsonGiclClmLossExpense}');
		objGICLClmLossExpense = objGICLClmLossExpenseTG.rows || [];
		
		var url = objCurrGICLLossExpPayees == null ? "" : contextPath + "/GICLClaimLossExpenseController?action=getClmLossExpList&claimId="+ nvl(objCurrGICLLossExpPayees.claimId, 0) +
				  "&payeeType="+objCurrGICLLossExpPayees.payeeType+"&payeeClassCd="+objCurrGICLLossExpPayees.payeeClassCd+"&payeeCd="+objCurrGICLLossExpPayees.payeeCd+
				  "&itemNo="+objCurrGICLLossExpPayees.itemNo+"&perilCd="+objCurrGICLLossExpPayees.perilCd+"&clmClmntNo="+objCurrGICLLossExpPayees.clmClmntNo+"&groupedItemNo="+objCurrGICLLossExpPayees.groupedItemNo;
		
		var giclClmLossExpenseTableModel = {
			id : 4,
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
						clearAllRelatedClmLossExpRecords();
					},
					onFilter: function(){
						clearAllRelatedClmLossExpRecords();
					}
				},
				onCellFocus: function(element, value, x, y, id){
					if(objCurrGICLClmLossExpense == null && nvl(clmLossExpInsertSw, "N") == "Y"){
						var giclClmLossExpense = giclClmLossExpenseTableGrid.geniisysRows[y];
						if(giclClmLossExpense.recordStatus == "0"){
							selectClmLossExpRecord(y);
						}else{
							if(checkChangeOfRecordInTG(giclClmLossExpenseTableGrid, objCurrGICLClmLossExpense)){
								selectClmLossExpRecord(y);
								clmLossExpInsertSw = "N";
							}
						}
					}else{
						if(checkChangeOfRecordInTG(giclClmLossExpenseTableGrid, objCurrGICLClmLossExpense)){
							selectClmLossExpRecord(y);
							clmLossExpInsertSw = "N";
							disableButton("btnDeleteClmLossExp"); //Added by Jerome Bautista 08.27.2015 SR 12213 / 4651
						}
					}
					$("txtHistSeqNo").setAttribute("lastValidValue", giclClmLossExpenseTableGrid.geniisysRows[y].historySequenceNumber); //Kenneth 06162015 SR 3616
				},
				onRemoveRowFocus: function() {
					if(checkChangeOfRecordInTG(giclClmLossExpenseTableGrid, objCurrGICLClmLossExpense)){
						clearAllRelatedClmLossExpRecords();
						$("txtHistSeqNo").setAttribute("lastValidValue", $F("txtHistSeqNo"));//Kenneth 06162015 SR 3616
					}
				},
				beforeSort: function(){
					if (hasPendingClmLossExpRecords()){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}
				},
				onSort: function(){
					clearAllRelatedClmLossExpRecords();
				},
				masterDetailValidation : function(){
					if (hasPendingClmLossExpRecords()){
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
					clearAllRelatedClmLossExpRecords();
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
				{	id: 'historySequenceNumber',
					align: 'right',
				  	title: 'Hist. Seq. No.',
				  	titleAlign: 'center',
				  	width: '90px',
				  	editable: false,
				  	sortable: true,
				  	filterOption: true,
				  	filterOptionType: 'integerNoNegative',
				  	renderer : function(value){
						return lpad(value.toString(), 3, "0");					
					}
				},
				{	id: 'clmLossExpStatDesc',
					align: 'left',
				  	title: 'History Status',
				  	titleAlign: 'center',
				  	width: '170px',
				  	editable: false,
				  	sortable: true,
				  	filterOption: true
				},
				{
				   	id: 'paidAmount',
				   	title: 'Loss Paid Amount',
				   	titleAlign: 'center',
				   	type : 'number',
				  	width: '140px',
				  	geniisysClass : 'money',
				  	filterOption: true,
					filterOptionType: 'number'
				},
				{
				   	id: 'netAmount',
				   	title: 'Loss Net Amount',
				   	titleAlign: 'center',
				   	type : 'number',
				  	width: '140px',
				  	geniisysClass : 'money',
				  	filterOption: true,
					filterOptionType: 'number'
				},
				{
				   	id: 'adviceAmount',
				   	title: 'Loss Advice Amount',
				   	titleAlign: 'center',
				   	type : 'number',
				  	width: '140px',
				  	geniisysClass : 'money',
				  	filterOption: true,
					filterOptionType: 'number'
				},
				{	id: 'remarks',
					align: 'left',
				  	title: 'Remarks',
				  	titleAlign: 'center',
				  	width: '140px',
				  	editable: false,
				  	sortable: true,
				  	filterOption: true
				},
				{
					id: 'exGratiaSw',
					title: 'EG',
					altTitle: 'Ex-Gratia',
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
					id: 'finalTag',
					title: '&#160;&#160;F',
					altTitle: 'Final Tag',
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
				}
				
			],
			rows : objGICLClmLossExpense,
			requiredColumns: ''
		};
		
		giclClmLossExpenseTableGrid = new MyTableGrid(giclClmLossExpenseTableModel);
		giclClmLossExpenseTableGrid.pager = objGICLClmLossExpenseTG;
		giclClmLossExpenseTableGrid.render('clmLossExpTableGrid');
		giclClmLossExpenseTableGrid.afterRender = function(){ //Kenneth 06162015 SR 3616
			objGICLClmLossExpense = giclClmLossExpenseTableGrid.geniisysRows;
		};
		$("txtHistSeqNo").value = lpad(getNextHistSeqNo(), 3, "0");
		
	}catch(e){
		showErrorMessage("Loss Expense Hist - giclClmLossExpense", e);
	}
	
	function selectClmLossExpRecord(y){
		clearAllRelatedClmLossExpRecords();
		var giclClmLossExpense = giclClmLossExpenseTableGrid.geniisysRows[y]; 
		objCurrGICLClmLossExpense = giclClmLossExpense;
		objCurrGICLClmLossExpense.index = y;
		populateClmLossExpForm(giclClmLossExpense);
		retrieveLossExpDetail(giclClmLossExpense);
		retrieveLossExpDs(giclClmLossExpense);
		showDistributionDetails(giclClmLossExpense);
	}
	
	if(objGICLClmLossExpense.length == 0){
		disableButton("btnCopyClmLossExp");
	}else{
		enableButton("btnCopyClmLossExp");
	}

</script>