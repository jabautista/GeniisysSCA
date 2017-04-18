<div id="payeeDetailsTableGrid" style="height: 181px; width: 650px;"></div>

<script type="text/javascript">
	try{
		$("hidDefaultPayeeType").value = "${dfltPayeeType}";
		$("hidLossReserve").value = "${lossReserve}";
		$("hidExpReserve").value = "${expReserve}";
		$("selPayeeType").value = $("hidDefaultPayeeType").value;
		$("hidMortgExist").value = "${isMortgExist}";
		isGiclMortgExist = $("hidMortgExist").value;
		payeeInsertSw = "N";
	
		var objGICLLossExpPayeesTG = JSON.parse('${jsonGiclLossExpPayees}');
		objGICLLossExpPayees = objGICLLossExpPayeesTG.rows || [];
		
		var url = objCurrGICLItemPeril == null ? "" : contextPath + "/GICLLossExpPayeesController?action=getGiclLossExpPayeesList&claimId="+ nvl(objCLMGlobal.claimId, 0)+
				 "&itemNo="+objCurrGICLItemPeril.itemNo+"&perilCd="+objCurrGICLItemPeril.perilCd+"&groupedItemNo="+objCurrGICLItemPeril.groupedItemNo+"&polIssCd="+objCLMGlobal.policyIssueCode;
		
		var giclLossExpPayeesTableModel = {
			id : 3,
			url : url,
			options:{
				title: '',
				pager: { },
				width: '650px',
				masterDetail : true,
				masterDetailRequireSaving : true,
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN/*, MyTableGrid.FILTER_BTN*/],
					onRefresh: function(){
						clearAllRelatedPayeeRecords();
					},
					onFilter: function(){
						clearAllRelatedPayeeRecords();
					}
				},
				onCellFocus: function(element, value, x, y, id){
					if(objCurrGICLLossExpPayees == null && nvl(payeeInsertSw, "N") == "Y"){
						var payee = giclLossExpPayeesTableGrid.geniisysRows[y];
						if(payee.recordStatus == "0"){
							selectPayeeRecord(y);
						}else{
							if(checkChangeOfRecordInTG(giclLossExpPayeesTableGrid, objCurrGICLLossExpPayees)){
								selectPayeeRecord(y);
								payeeInsertSw = "N";
							}
						}
					}else{
						if(checkChangeOfRecordInTG(giclLossExpPayeesTableGrid, objCurrGICLLossExpPayees)){
							selectPayeeRecord(y);
							payeeInsertSw = "N";
						}
					}
				},
				onRemoveRowFocus: function() {
					if(checkChangeOfRecordInTG(giclLossExpPayeesTableGrid, objCurrGICLLossExpPayees)){
						clearAllRelatedPayeeRecords();
					}
				},
				beforeSort: function(){
					if (changeTag == 1 || checkLossExpChildRecords()){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}
				},
				onSort: function(){
					clearAllRelatedPayeeRecords();
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
					clearAllRelatedPayeeRecords();
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
				{	id: 'payeeType',
					width: '0',
					visible: false
				},
				{	id: 'payeeTypeDesc',
					align: 'left',
				  	title: 'Payee Type',
				  	titleAlign: 'center',
				  	width: '130px',
				  	editable: false,
				  	sortable: true,
				  	filterOption: true
				},
				{	id: 'payeeClassCd',
					width: '0',
					visible: false
				},
				{ 	id: 'className',
					align : 'left',
					title : 'Payee Class',
					titleAlign : 'center',
					width : '150px',
					editable: false,
					sortable: true,
					filterOption: true
				},
				{	id: 'payeeCd',
					width: '0',
					visible: false
				},
				{ 	id: 'dspPayeeName',
					align : 'left',
					title : 'Payee',
					titleAlign : 'center',
					width : '350px',
					editable: false,
					sortable: true,
					filterOption: true
				}
			],
			rows : objGICLLossExpPayees,
			requiredColumns: ''
		};
		
		giclLossExpPayeesTableGrid = new MyTableGrid(giclLossExpPayeesTableModel);
		giclLossExpPayeesTableGrid.pager = objGICLLossExpPayeesTG;
		giclLossExpPayeesTableGrid.render('payeeDetailsTableGrid');
		
	}catch(e){
		showErrorMessage("Loss Expense Hist - giclLossExpPayees", e);
	}
	
	function selectPayeeRecord(y){
		try{
			clearAllRelatedPayeeRecords();
			var payee = giclLossExpPayeesTableGrid.geniisysRows[y];
			objCurrGICLLossExpPayees = payee;
			objCurrGICLLossExpPayees.index = y;
			populatePayeeForm(payee);
			
			if(nvl(payee.existClmLossExp, "N") == "Y"){
				enableButton("btnViewHistory");
			}else{
				disableButton("btnViewHistory");
			}
			retrieveClmLossExpense(payee);	
		}catch(e){
			showErrorMessage("selectPayeeRecord", e);
		}
	}
</script>