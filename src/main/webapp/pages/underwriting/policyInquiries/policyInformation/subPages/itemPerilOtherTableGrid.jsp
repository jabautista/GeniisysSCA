<div id="itemPerilOtherTableGridSectionDiv" class="sectionDiv" style="height:345px;width:100%;margin:0 auto 50px auto;">
		<div id="itemPerilOtherTableGridDiv" style="height:305px;">
			<div id="itemPerilOtherListing" style="height:281px;width:742px;margin:20px auto auto auto;"></div>
		</div>
</div>

<script type="text/javascript" src="uderwriting.js">
	var objItemPerilOther = new Object();
	objItemPerilOther.objItemPerilOtherListTableGrid = JSON.parse('${itemPerilList}'.replace(/\\/g, '\\\\'));
	objItemPerilOther.objItemPerilOtherList = objItemPerilOther.objItemPerilOtherListTableGrid.rows || [];

	var moduleId = $F("hidModuleId");
	moduleId == "GIPIS101" ? getGIPIS101TblModel() : getGIPIS100TblModel();
	
	function getGIPIS100TblModel(){
		try{
			var itemPerilOtherTableModel = {
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
							itemPerilOtherTableGrid.keys.removeFocus(itemPerilOtherTableGrid.keys._nCurrentFocus, true);
							itemPerilOtherTableGrid.keys.releaseKeys();
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
							visible: true//,		Gzelle 06.14.2013
							//sortable: false
						},
						{	id: 'premiumRate',
							title: 'Rate',
							titleAlign: 'right',
							align:'right',
							width: '100%',
							visible: true,
							//sortable: false,		Gzelle 06.14.2013
							renderer: function(value){
								return formatToNineDecimal(value);
							}
						},
						{	id: 'tsiAmount',
							title: 'Sum Insured',
							width: '100%',
							titleAlign: 'right',
							align: 'right',
							visible: true,
							//sortable: false,		Gzelle 06.14.2013
							geniisysClass : 'money',     
				            geniisysMinValue: '-999999999999.99',     
				            geniisysMaxValue: '999,999,999,999.99'
						},
						{	id: 'premiumAmount',
							title: 'Premium',
							width: '100%',
							titleAlign: 'right',
							align: 'right',
							visible: true,
							//sortable: false,		Gzelle 06.14.2013
							geniisysClass : 'money',     
				            geniisysMinValue: '-999999999999.99',     
				            geniisysMaxValue: '999,999,999,999.99'
						},
						{	id: 'compRem',
							title: 'Comp Remarks',
							width: '150%',
							visible: true//,
							//sortable: false		Gzelle 06.14.2013
						},
						{	id: 'surchargeSw',
							title: 'S',
							width: '22%',
							visible: true,
							//sortable: false,		Gzelle 06.14.2013
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
				rows:objItemPerilOther.objItemPerilOtherList
			};
			itemPerilOtherTableGrid = new MyTableGrid(itemPerilOtherTableModel);
			itemPerilOtherTableGrid.pager = objItemPerilOther.objItemPerilOtherListTableGrid;
			itemPerilOtherTableGrid.render('itemPerilOtherListing');
		}catch(e){
			showErrorMessage("getGIPIS100TblModel", e);
		}
	}

	function getGIPIS101TblModel(){
		try{
			var itemPerilOtherTableModel = {
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
							itemPerilOtherTableGrid.keys.removeFocus(itemPerilOtherTableGrid.keys._nCurrentFocus, true);
							itemPerilOtherTableGrid.keys.releaseKeys();
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
							visible: true,
							sortable: false
						},
						
						{	id: 'tsiAmount',
							title: 'Sum Insured',
							width: '130%',
							titleAlign: 'right',
							align: 'right',
							visible: true,
							sortable: false,
							geniisysClass : 'money',     
				            geniisysMinValue: '-999999999999.99',     
				            geniisysMaxValue: '999,999,999,999.99'
						},
						{	id: 'premiumAmount',
							title: 'Premium',
							width: '130%',
							titleAlign: 'right',
							align: 'right',
							visible: true,
							sortable: false,
							geniisysClass : 'money',     
				            geniisysMinValue: '-999999999999.99',     
				            geniisysMaxValue: '999,999,999,999.99'
						},
						{	id: 'premiumRate',
							title: 'Rate',
							titleAlign: 'right',
							align:'right',
							width: '97%',
							visible: true,
							sortable: false,
							renderer: function(value){
								return formatToNineDecimal(value);
							}
						},
						{	id: 'compRem',
							title: 'Comp Remarks',
							width: '165%',
							visible: true,
							sortable: false
						}
				],
				rows:objItemPerilOther.objItemPerilOtherList
			};
			itemPerilOtherTableGrid = new MyTableGrid(itemPerilOtherTableModel);
			itemPerilOtherTableGrid.pager = objItemPerilOther.objItemPerilOtherListTableGrid;
			itemPerilOtherTableGrid.render('itemPerilOtherListing');
		}catch(e){
			showErrorMessage("getGIPIS101TblModel", e);
		}
	}
	


</script>