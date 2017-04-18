<div id="deductibleInfoSectionDiv" name="deductibleInfoSectionDiv" class="sectionDiv">
here
	<div id="testDeductibleTG"  style="height: 185px; margin: 15px; width: 890px; "></div>

</div>

<script> 
	try{
		objQuote.objDeductibleInfo = [];
		objQuote.selectedDeductibleIndex = -1;
		var mtgId = null;
		var objDeductibleInfo = new Object(); 
		objDeductibleInfo.objDeductibleInfoTableGrid = JSON.parse('${deductibleInfoList}'.replace(/\\/g, '\\\\'));
		objDeductibleInfo.objDeductibleInfoRows = objDeductibleInfo.objDeductibleInfoTableGrid.rows || [];
		
		var deductibleInfoTableModel = {
			url: contextPath+"/GIPIQuoteDeductiblesController?action=getDeductibleInfoTG&refresh=1&quoteId="+objGIPIQuote.quoteId+"&itemNo="+objQuote.selectedItemInfoRow.itemNo
							+"&perilCd="+objQuote.selectedPerilInfoRow.perilCd+"&lineCd="+objGIPIQuote.lineCd+"&sublineCd="+objGIPIQuote.sublineCd,
			options: {
				id : 66,
				title: "",
				onCellFocus: function(element, value, x, y, id){
					
					
				},
				onRemoveRowFocus: function(){
					
				},
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN]	
				}
			},
			columnModel: [
							{   
								id: 'recordStatus',
							    width: '0',
							    visible: false,
							    editor: 'checkbox' 			
							},
							{	
								id: 'divCtrId',
								width: '0',
								visible: false
							},
							{	
								id: 'quoteId',
								width: '0',
								visible: false
							},
							{	
								id: 'itemNo',
								width: '0',
								visible: false
							},
							{	
								id: 'perilCd',
								width: '0',
								visible: false
							},
							{	
								id : 'deductibleCd',
								title: 'Code',
								titleAlign: 'center',
								width: '80px'
							},
							{	
								id : 'deductibleTitle',
								title: 'Deductible Title',
								titleAlign: 'center',
								width: '180px'
							},
							{	
								id : 'deductibleText',
								title: 'Deductible Text',
								titleAlign: 'center',
								width: '380px'
							},
							{	
								id : 'deductibleRt',
								title: 'Rate',
								titleAlign: 'center',
								width: '100px',
								align: 'right',
								geniisysClass: 'rate'
							},
							{	
								id : 'deductibleAmt',
								title: 'Amount',
								titleAlign: 'center',
								align: 'right',
								width: '140px',
								geniisysClass: 'money'
							},	
						],
						rows: objDeductibleInfo.objDeductibleInfoRows
		};
		deductibleInfoGrid = new MyTableGrid(deductibleInfoTableModel);
		deductibleInfoGrid.pager = objDeductibleInfo.objDeductibleInfoTableGrid;
		deductibleInfoGrid.render("testDeductibleTG");
		/*deductibleInfoGrid.afterRender = function (){
			objQuote.objDeductibleInfo = deductibleInfoGrid.geniisysRows;
			computeTotalDeductibleAmount();
		};*/
	
	}catch(e){
		
	}
		
	
</script>