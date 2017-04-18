<div id="vatTgDiv" style="height: 180px; "></div>

<script type="text/javascript">
	giclEvalVatDtlTGArrObj = [];
	var giclEvalVatDtlTGObj =  JSON.parse('${evalVatTg}'.replace(/\\/g, '\\\\'));
	giclEvalVatDtlTGArrObj = JSON.parse('${evalVatTg}'.replace(/\\/g, '\\\\')).rows;
	try{
		var vatDetailsTableModel= {
				id: 8,
				url: contextPath+"/GICLEvalVatController?action=getMcEvalVatListing&refresh=1&evalId="+nvl(selectedMcEvalObj.evalId,null),
				options: {
					newRowPosition: 'bottom',
					prePager: function(){
						if(changeTag == 1){
							showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
							return false;
						} else {
							populateVatDetails(null);
							return true;
						}
					},beforeSort: function(){
						if(changeTag == 1){
							showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
							return false;
						} else {
							populateVatDetails(null);
							return true;
						}
					},
					onCellFocus: function(element, value, x, y, id) {
						if (y >= 0){
							selectedVatIndex = y;
							populateVatDetails(vatGrid.geniisysRows[y]);
						}						
						vatGrid.keys.releaseKeys();
					},onRemoveRowFocus : function(){
						selectedVatIndex = null;
						vatGrid.releaseKeys();
						populateVatDetails(null);
					
				  	},toolbar: {
						elements: [/* MyTableGrid.FILTER_BTN */, MyTableGrid.REFRESH_BTN],// removed filter for now
						onRefresh: function (){
					
						}
					}
				},columnModel : [
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
						id: 'dspCompany',
						width: '180',
						title: 'Company',
					  	filterOption: true
					},
					{	
						id: 'dspPartLabor',
						width: '250',
						title: 'Part/Labor',
					  	filterOption: true
					},{	
						id: 'baseAmt',
						width: '125',
						title: 'Taxable Amount',
						titleAlign: 'right',
						align: 'right',
						geniisysClass : 'money',
						filterOptionType: 'number',
					  	filterOption: true
					},{	
						id: 'vatRate',
						width: '125',
						title: 'Tax Pct.',
						titleAlign: 'right',
						align: 'right',
						geniisysClass : 'money',
						filterOptionType: 'number',
					  	filterOption: true
					},{	
						id: 'vatAmt',
						width: '125',
						title: 'Tax Amount',
						titleAlign: 'right',
						align: 'right',
						geniisysClass : 'money',
						filterOptionType: 'number',
					  	filterOption: true
					},{   
						id: 'lessDed',
						title: 'DD',
					    width: '20',
					    editable: false,
						sortable: false,
						defaultValue: false,
						otherValue: false,
						altTitle: 'Less Deductible',
						editor: new MyTableGrid.CellCheckbox({
					        getValueOf: function(value){
				            	if (value){
									return "Y";
				            	}else{
									return "N";	
				            	}
			            	}
			            })
					},{   
						id: 'lessDep',
						title: 'DP',
					    width: '20',
					    editable: false,
						sortable: false,
						defaultValue: false,
						otherValue: false,
						altTitle: 'Less Depreciation',
						editor: new MyTableGrid.CellCheckbox({
					        getValueOf: function(value){
				            	if (value){
									return "Y";
				            	}else{
									return "N";	
				            	}
			            	}
			            })
					},{
						id: 'evalId',
						width: '0',
						visible:false
					},{
						id: 'payeeTypeCd',
						width: '0',
						visible:false
					},{
						id: 'payeeCd',
						width: '0',
						visible:false
					},{
						id: 'applyTo',
						width: '0',
						visible:false
					},{
						id: 'paytPayeeTypeCd',
						width: '0',
						visible:false
					},{
						id: 'paytPayeeCd',
						width: '0',
						visible:false
					},{
						id: 'netTag',
						width: '0',
						visible:false
					},{
						id: 'withVat',
						width: '0',
						visible:false
					}
				],
				rows: giclEvalVatDtlTGObj.rows
			};
			
			vatGrid = new MyTableGrid(vatDetailsTableModel);
			vatGrid.pager = giclEvalVatDtlTGObj;
			vatGrid.render('vatTgDiv');
	}catch(e){
		showErrorMessage("evalVatTg",e);
	}
</script>