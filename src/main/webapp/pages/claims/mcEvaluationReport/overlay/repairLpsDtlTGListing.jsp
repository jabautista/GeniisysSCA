<div style="height: 135px;">
	<div id="repairLpsTgDiv" style="height: 135px; "></div>
</div>

<script type="text/javascript">
	
	var objRepairLpsDtl = JSON.parse('${repairLpsDetailsTg}'.replace(/\\/g, '\\\\'));
	objGICLReplaceLpsDtlArr = JSON.parse('${repairLpsDetailsTg}'.replace(/\\/g, '\\\\')).rows; // seperate array obj for manipulation and saving
	try{
		var repairLpsTableModel = {
				id: 6,
				width: '850px',
				url: contextPath+"/GICLRepairHdrController?action=getGicls070LpsDetailsList&refresh=1&evalId="+(giclRepairObj == null ? null :giclRepairObj.evalId),
				options: {
					newRowPosition: 'bottom',
					prePager: function(){
						if(changeTag == 1){
							showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
							return false;
						} else {
							populateRepairLpsDtlFields(null);
							return true;
						}
					},beforeSort: function(){
						if(changeTag == 1){
							showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
							return false;
						} else {
							populateRepairLpsDtlFields(null);
							return true;
						}
					},
					onCellFocus: function(element, value, x, y, id) {
						if (y >= 0){
							repairGridSelectedIndex = y;							
							populateRepairLpsDtlFields(repairGrid.geniisysRows[y]);
						}						
						//repairGrid.keys.removeFocus(repairGrid.keys._nCurrentFocus, true);
						repairGrid.keys.releaseKeys();
						//repairGrid.keys._nOldFocus = null;
					},onRemoveRowFocus : function(){
						repairGrid.releaseKeys();
						repairGridSelectedIndex = null;
						populateRepairLpsDtlFields(null);
						disableButton("btnDeleteRepairDet");
						$("btnAddRepairDet").value = "Add";
					
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
						id: 'itemNo',
						width: '20',
						title: 'No.',
					  	filterOption: true
					},
					{	
						id: 'dspLossDesc',
						width: '205',
						title: 'Vehicle Part',
					  	filterOption: true
					},{   
						id: 'tinsmithRepairCd',
						title: 'T',
					    width: '20',
					    editable: false,
						sortable: false,
						defaultValue: false,
						otherValue: false,
						altTitle: 'Add Tinsmith amount',
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
						id: 'tinsmithType',
						width: '0',
					  	visible:false
					},
					{	
						id: 'tinsmithTypeDesc',
						width: '100',
						title: 'Tinsmith Type',
					  	filterOption: true
					},{	
						id: 'tinsmithAmount',
						width: '125',
						title: 'Tinsmith',
						titleAlign: 'right',
						align: 'right',
						geniisysClass : 'money',
						filterOptionType: 'number',
					  	filterOption: true
					},{   
						id: 'paintingsRepairCd',
						title: 'P',
					    width: '20',
					    editable: false,
						sortable: false,
						defaultValue: false,
						otherValue: false,
						altTitle: 'Add Painting amount',
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
						id: 'paintingsAmount',
						width: '125',
						title: 'Paintings',
						titleAlign: 'right',
						align: 'right',
						geniisysClass : 'money',
						filterOptionType: 'number',
					  	filterOption: true
					},{
						id: 'updateSw',
						width: '0',
						visible:false
					},{
						id: 'evalId',
						width: '0',
						visible:false
					},{
						id: 'lossExpCd',
						width: '0',
						visible:false
					},{	
						id: 'totalAmount',
						width: '150',
						title: 'Total',
						titleAlign: 'right',
						align: 'right',
						geniisysClass : 'money',
						filterOptionType: 'number',
					  	filterOption: true
					}
				],
				rows: objRepairLpsDtl.rows
			};
			
			repairGrid = new MyTableGrid(repairLpsTableModel);
			repairGrid.pager = objRepairLpsDtl;
			repairGrid.render('repairLpsTgDiv');
	}catch(e){
		showErrorMessage("repairLpsDetailsTg", e);
	}
	
	//computeTotalFields(repairGrid);
</script>