<div id="itemPerilMnTableGridSectionDiv" class="sectionDiv" style="height:345px;width:100%;margin:0 auto 50px auto;">
		<div id="itemPerilMnTableGridDiv" style="height:305px;">
			<div id="itemPerilMnListing" style="height:281px;width:565px;margin:20px auto auto auto;"></div>
		</div>
</div>

<script type="text/javascript" src="underwriting.js">
	var moduleId = $F("hidModuleId");
	
	var objItemPerilMn = new Object();
	objItemPerilMn.objItemPerilMnListTableGrid = JSON.parse('${itemPerilList}'.replace(/\\/g, '\\\\'));
	objItemPerilMn.objItemPerilMnList = objItemPerilMn.objItemPerilMnListTableGrid.rows || [];

	moduleId == "GIPIS101" ? initializeGIPIS101() : initializeGIPIS100() ;
	
	function initializeGIPIS100(){
		try{
			var itemPerilMnTableModel = {
				url:contextPath+"/GIPIItemPerilController?action=getItemPerils"+
					"&policyId="+$F("hidItemPolicyId")+
					"&itemNo="+$F("hidItemNo")+
					"&perilViewType"+$F("hidPerilViewType")+
					"&refresh=1"
					,
				options:{
						title: '',
						width:'565px',
						onCellFocus: function(element, value, x, y, id){
							itemPerilMnTableGrid.keys.removeFocus(itemPerilMnTableGrid.keys._nCurrentFocus, true);
							itemPerilMnTableGrid.keys.releaseKeys();
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
							align: 'right',
							geniisysClass: 'rate',
							visible: true
						},
						{	id: 'tsiAmount',
							title: 'Sum Insured',
							width: '100%',
							align: 'right',
							geniisysClass: 'money',
							visible: true
						},
						{	id: 'premiumAmount',
							title: 'Premium',
							width: '100%',
							align: 'right',
							geniisysClass: 'money',
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
				rows:objItemPerilMn.objItemPerilMnList
			};
			itemPerilMnTableGrid = new MyTableGrid(itemPerilMnTableModel);
			itemPerilMnTableGrid.pager = objItemPerilMn.objItemPerilMnListTableGrid;
			itemPerilMnTableGrid.render('itemPerilMnListing');
		}catch(e){
			showErrorMessage("initializeGIPIS100", e);
		}
	}
	

	function initializeGIPIS101(){
		try{
			var itemPerilMnTableModel = {
				url:contextPath+"/GIXXItemPerilController?action=getGIXXItemPeril"+
					"&extractId="+$F("hidItemExtractId")+
					"&itemNo="+$F("hidItemNo")+
					"&packPolFlag=" + $F("hidPackPolFlag") + "&lineCd=" + $F("hidLineCd") + "&packLineCd=" + $F("hidItemPackLineCd") +
					"&perilViewType"+$F("hidPerilViewType")+
					"&refresh=1"
					,
				options:{
						title: '',
						width:'565px',
						onCellFocus: function(element, value, x, y, id){
							itemPerilMnTableGrid.keys.removeFocus(itemPerilMnTableGrid.keys._nCurrentFocus, true);
							itemPerilMnTableGrid.keys.releaseKeys();
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
							width: '105%',
							align: 'right',
							geniisysClass: 'rate',
							visible: true
						},
						{	id: 'tsiAmount',
							title: 'Sum Insured',
							width: '121%',
							align: 'right',
							visible: true,
							geniisysClass: 'money'
						},
						{	id: 'premiumAmount',
							title: 'Premium',
							width: '121%',
							align: 'right',
							visible: true,
							geniisysClass: 'money'
						}						
				],
				rows:objItemPerilMn.objItemPerilMnList
			};
			itemPerilMnTableGrid = new MyTableGrid(itemPerilMnTableModel);
			itemPerilMnTableGrid.pager = objItemPerilMn.objItemPerilMnListTableGrid;
			itemPerilMnTableGrid.render('itemPerilMnListing');
		}catch(e){
			showErrorMessage("initializeGIPIS101", e);
		}
	}

</script>