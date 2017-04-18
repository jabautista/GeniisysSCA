<div id="vatDtlDiv"  style="padding: 5px;  height: 220px; margin-top: 0; ">
	<div style="height: 190px;">
		<div id="depTgDiv" style="height: 190px; "></div>
	</div>
</div>
<script type="text/javascript">
	var giclEvalDepDtlTGObj =  JSON.parse('${evalDepTG}'.replace(/\\/g, '\\\\'));
	giclEvalDepDtlTGArrObj = JSON.parse('${evalDepTG}'.replace(/\\/g, '\\\\')).rows;
	try{
		var depDetailsTableModel= {
			id: 8,
			url: contextPath+"/GICLEvalDepDtlController?action=getEvalDepList&refresh=1&evalId="+nvl(selectedMcEvalObj.evalId,null),
			options: {
				newRowPosition: 'bottom',
				prePager: function(){
					if(changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
						return false;
					} else {
						populateDepreciationDtlFields(null);
						return true;
					}
				},beforeSort: function(){
					if(changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
						return false;
					} else {
						populateDepreciationDtlFields(null);
						return true;
					}
				},
				onCellFocus: function(element, value, x, y, id) {
					if (y >= 0){
						selectedDepIndex = y;
						populateDepreciationDtlFields(depreciationGrid.geniisysRows[y]);
					}						
					depreciationGrid.keys.releaseKeys();
				},onRemoveRowFocus : function(){
					selectedDepIndex = null;
					depreciationGrid.releaseKeys();
					populateDepreciationDtlFields(null);
				
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
					id: 'lossExpCd',
					width: '70',
					title: 'Parts',
				  	filterOption: true
				},
				{	
					id: 'partDesc',
					width: '240',
					title: 'Parts Description',
				  	filterOption: true
				},{	
					id: 'dedRt',
					width: '125',
					title: 'Rate',
					titleAlign: 'right',
					align: 'right',
					geniisysClass : 'money',
					filterOptionType: 'number',
				  	filterOption: true
				},{	
					id: 'partAmt',
					width: '170',
					title: 'Part Amount',
					titleAlign: 'right',
					align: 'right',
					geniisysClass : 'money',
					filterOptionType: 'number',
				  	filterOption: true
				},{	
					id: 'dedAmt',
					width: '170',
					title: 'Depreciation Amount',
					titleAlign: 'right',
					align: 'right',
					geniisysClass : 'money',
					filterOptionType: 'number',
				  	filterOption: true
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
					id: 'partType',
					width: '0',
					visible:false
				},{
					id: 'itemNo',
					width: '0',
					visible:false
				}
			],
			rows: giclEvalDepDtlTGObj.rows
		};
		
		depreciationGrid = new MyTableGrid(depDetailsTableModel);
		depreciationGrid.pager = giclEvalDepDtlTGObj;
		depreciationGrid.render('depTgDiv');
		depreciationGrid.afterRender = function(){ //added by robert 04.25.2013 sr 12860
			giclEvalDepDtlTGArrObj = depreciationGrid.geniisysRows;
		};
	}catch (e) {
		showErrorMessage("giclEvalDepDtlTGObj" , e);
	} 
	
</script>