<div id="itemPerilRiTableGridSectionDiv" class="sectionDiv" style="height:345px;width:100%;margin:0 auto 50px auto;">
		<div id="itemPerilRiTableGridDiv" style="height:305px;">
			<div id="itemPerilRiListing" style="height:281px;width:794px;margin:20px auto auto auto;"></div>
		</div>
</div>

<script type="text/javascript" src="underwriting.js">
	var objItemPerilRi = new Object();
	objItemPerilRi.objItemPerilRiListTableGrid = JSON.parse('${itemPerilList}'.replace(/\\/g, '\\\\'));
	objItemPerilRi.objItemPerilRiList = objItemPerilRi.objItemPerilRiListTableGrid.rows || [];

	
	try{
		var itemPerilRiTableModel = {
			url:contextPath+"/GIPIItemPerilController?action=getItemPerils"+
				"&policyId="+$F("hidItemPolicyId")+
				"&itemNo="+$F("hidItemNo")+
				"&perilViewType"+$F("hidPerilViewType")+
				"&refresh=1"
				,
			options:{
					title: '',
					width:'794px',
					onCellFocus: function(element, value, x, y, id){
						itemPerilRiTableGrid.keys.removeFocus(itemPerilRiTableGrid.keys._nCurrentFocus, true);
						itemPerilRiTableGrid.keys.releaseKeys();
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
						visible: true,
						titleAlign: 'right',//added by carloR SR 5460 07.12.2016
						align:'right', 
						renderer: function(value){
							return formatToNineDecimal(value);
						}//end
					},
					{	id: 'tsiAmount',
						title: 'Sum Insured',
						width: '100%',
						visible: true,
						titleAlign: 'right', //added by carloR SR 5460 07.12.2016
						align: 'right',
						geniisysClass : 'money',     
			            geniisysMinValue: '-999999999999.99',     
			            geniisysMaxValue: '999,999,999,999.99' //end
					},
					{	id: 'premiumAmount',
						title: 'Premium',
						width: '100%',
						visible: true,
						titleAlign: 'right', //added by carloR SR 5460 07.12.2016
						align: 'right',
						geniisysClass : 'money',     
			            geniisysMinValue: '-999999999999.99',     
			            geniisysMaxValue: '999,999,999,999.99' //end
					},
					{	id: 'riCommRate',
						title: 'RI Comm Rate',
						width: '100%',
						visible: true,
						titleAlign: 'right',//added by carloR SR 5460 07.12.2016
						align:'right', 
						renderer: function(value){
							return formatToNineDecimal(value);
						}//end
					},
					{	id: 'riCommAmount',
						title: 'RI Comm Amount',
						width: '125%',
						visible: true,
						titleAlign: 'right', //added by carloR SR 5460 07.12.2016
						align: 'right',
						geniisysClass : 'money',     
			            geniisysMinValue: '-999999999999.99',     
			            geniisysMaxValue: '999,999,999,999.99' //end
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
			rows:objItemPerilRi.objItemPerilRiList
		};
		itemPerilRiTableGrid = new MyTableGrid(itemPerilRiTableModel);
		itemPerilRiTableGrid.pager = objItemPerilRi.objItemPerilRiListTableGrid;
		itemPerilRiTableGrid.render('itemPerilRiListing');
	}catch(e){
		showErrorMessage("itemPerilRiTableModel", e);
	}


</script>