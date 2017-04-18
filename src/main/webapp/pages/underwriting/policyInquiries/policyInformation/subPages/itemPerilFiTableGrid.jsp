<div id="itemPerilFiTableGridSectionDiv" class="sectionDiv" style="height:345px;width:100%;margin:0 auto 50px auto;">
		<div id="itemPerilFiTableGridDiv" style="height:305px;">
			<div id="itemPerilFiListing" style="height:281px;width:742px;margin:20px auto auto auto;"></div>
		</div>
</div>

<script type="text/javascript" src="underwriting.js">
	var moduleId = $F("hidModuleId");


	var objItemPerilFi = new Object();
	objItemPerilFi.objItemPerilFiListTableGrid = JSON.parse('${itemPerilList}'.replace(/\\/g, '\\\\'));
	objItemPerilFi.objItemPerilFiList = objItemPerilFi.objItemPerilFiListTableGrid.rows || [];

	moduleId == "GIPIS101" ? initializeGIPIS101() : initializeGIPIS100() ;
	
	function initializeGIPIS100(){
		try{
			var itemPerilFiTableModel = {
				url:contextPath+"/GIPIItemPerilController?action=getItemPerils"+
					"&policyId="+$F("hidItemPolicyId")+
					"&itemNo="+$F("hidItemNo")+
					"&perilViewType"+$F("hidPerilViewType")+
					"&refresh=1"
					,
				options:{
						title: '',
						width:'742px',
						onCellFocus: function(element, value, x, y, id){
							itemPerilFiTableGrid.keys.removeFocus(itemPerilFiTableGrid.keys._nCurrentFocus, true);
							itemPerilFiTableGrid.keys.releaseKeys();	
				
						},
						onRemoveRowFocus:function(element, value, x, y, id){
			
						},
						onRowDoubleClick: function(param){
						}
				},
				columnModel:[
				 		{   id: 'recordStatus',
						    title: '',
						    width: '0px',
						    visible: false,
						    editor: 'checkbox' 			
						},
						{	id: 'divCtrId',
							width: '0px',
							visible: false
						},
						{	id: 'rowNum',
							title: 'rowNum',
							width: '0px',
							visible: false
						},
						{	id: 'rowCount',
							title: 'rowCount',
							width: '0px',
							visible: false
						},
						{	id: 'perilName',
							title: 'Peril',
							width: '200%',
							visible: true
						},
						{	id: 'premiumRate',
							title: 'Rate',
							width: '75%',
							visible: true
						},
						{	id: 'tsiAmount',
							title: 'Sum Insured',
							width: '100%',
							visible: true
						},
						{	id: 'premiumAmount',
							title: 'Premium',
							width: '100%',
							visible: true
						},
						{	id: 'compRem',
							title: 'Comp Remarks',
							width: '175%',
							visible: true
						},
						{	id: 'surchargeSw',
							title: 'S',
							width: '22%',
							visible: true,
							defaultValue: false,
							otherValue: false,
							editor: new MyTableGrid.CellCheckbox({
							    getValueOf: function(value) {
							        var result = 'N';
							        if (value) result = 'Y';
							        return result;
							    }
							})
						},
						{	id: 'discountSw',
							title: 'D',
							width: '22%',
							visible: true,
							defaultValue: false,
							otherValue: false,
							editor: new MyTableGrid.CellCheckbox({
							    getValueOf: function(value) {
							        var result = 'N';
							        if (value) result = 'Y';
							        return result;
							    }
							})
						},
						{	id: 'aggregateSw',
							title: 'A',
							width: '22%',
							visible: true,
							defaultValue: false,
							otherValue: false,
							editor: new MyTableGrid.CellCheckbox({
							    getValueOf: function(value) {
							        var result = 'N';
							        if (value) result = 'Y';
							        return result;
							    }
							})
						},
						
				],
				rows:objItemPerilFi.objItemPerilFiList
			};
			itemPerilFiTableGrid = new MyTableGrid(itemPerilFiTableModel);
			itemPerilFiTableGrid.pager = objItemPerilFi.objItemPerilFiListTableGrid;
			itemPerilFiTableGrid.render('itemPerilFiListing');
		}catch(e){
			showErrorMessage("initializeGIPIS100", e);
		}
	}
	
	
	// function for GIPIS101
	function initializeGIPIS101(){
		try{
			var itemPerilFiTableModel = {
				url:contextPath+"/GIXXItemPerilController?action=getGIXXItemPeril"+
					"&extractId="+$F("hidItemExtractId")+
					"&itemNo="+$F("hidItemNo")+
					"&packPolFlag=" + $F("hidPackPolFlag") + "&lineCd=" + $F("hidLineCd") + "&packLineCd=" + $F("hidItemPackLineCd") +
					"&perilViewType"+$F("hidPerilViewType")+
					"&refresh=1"
					,
				options:{
						title: '',
						width:'742px',
						onCellFocus: function(element, value, x, y, id){
							itemPerilFiTableGrid.keys.removeFocus(itemPerilFiTableGrid.keys._nCurrentFocus, true);
							itemPerilFiTableGrid.keys.releaseKeys();	
				
						},
						onRemoveRowFocus:function(element, value, x, y, id){
			
						},
						onRowDoubleClick: function(param){
						}
				},
				columnModel:[
				 		{   id: 'recordStatus',
						    title: '',
						    width: '0px',
						    visible: false,
						    editor: 'checkbox' 			
						},
						{	id: 'divCtrId',
							width: '0px',
							visible: false
						},
						{	id: 'rowNum',
							title: 'rowNum',
							width: '0px',
							visible: false
						},
						{	id: 'rowCount',
							title: 'rowCount',
							width: '0px',
							visible: false
						},
						{	id: 'perilName',
							title: 'Peril',
							titleAlign: 'center',
							width: '243%',
							visible: true
						},
						{	id: 'premiumRate',
							title: 'Rate',
							titleAlign: 'center',
							align: 'right',
							width: '100%',		
							geniisysClass: 'rate',
							visible: true
						},
						{	id: 'tsiAmount',
							title: 'Sum Insured',
							titleAlign: 'right',
							align: 'right',
							width: '110%',
							geniisysClass: 'money',
							visible: true
						},
						{	id: 'premiumAmount',
							title: 'Premium',
							titleAlign: 'right',
							align: 'right',
							width: '110%',
							geniisysClass: 'money',
							visible: true
						},
						{	id: 'compRem',
							title: 'Comp Remarks',
							width: '135%',
							visible: true
						},
						{	id: 'discountSw',
							title: 'D',
							titleAlign: 'center',
							width: '22%',
							align: 'center',
							visible: true,
							defaultValue: false,
							otherValue: false,
							editor: new MyTableGrid.CellCheckbox({
							    getValueOf: function(value) {
							        var result = 'N';
							        if (value) result = 'Y';
							        return result;
							    }
							})
						}					
				],
				rows:objItemPerilFi.objItemPerilFiList
			};
			itemPerilFiTableGrid = new MyTableGrid(itemPerilFiTableModel);
			itemPerilFiTableGrid.pager = objItemPerilFi.objItemPerilFiListTableGrid;
			itemPerilFiTableGrid.render('itemPerilFiListing');
		}catch(e){
			showErrorMessage("initializeGIPIS101", e);
		}
	}
	



</script>