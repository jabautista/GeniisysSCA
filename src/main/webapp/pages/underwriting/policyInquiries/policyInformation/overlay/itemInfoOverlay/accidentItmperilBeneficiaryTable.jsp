<div style="height:160px;width:516px;margin:0px auto 0px auto;">
		<div id="itmPerilBeneficiaryListing" style="height:156px;width:516px;float:left;"></div>
</div>

<script>
	//initialization
	var objItmPerilBeneficiary = new Object();
	objItmPerilBeneficiary.objItmPerilBeneficiaryListTableGrid = JSON.parse('${itmPerilBeneficiaryList}'.replace(/\\/g, '\\\\'));
	objItmPerilBeneficiary.objItmPerilBeneficiaryList = objItmPerilBeneficiary.objItmPerilBeneficiaryListTableGrid.rows || [];
	
	try{
		var itmPerilBeneficiaryTableModel = {
			url:contextPath+"/?action=getGrpItemBeneficiaries"+
			"&policyId="+nvl($("hidGroupedItemsPolicyId").value,0)+
			"&itemNo="+nvl($("hidGroupedItemsItemNo").value,0)+
			"&groupedItemNo="+nvl($("hidGroupedItemsGroupedItemNo").value,0)+
			"&refresh=1"
				,
			options:{
					title: '',
					width: '516px',
					onCellFocus: function(element, value, x, y, id){
						
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						
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
					
					{
						id: 'policyId',
						title: 'policyId',
						width: '0px',
						visible: false
					},
					{
						id: 'itemNo',
						title: 'itemNo',
						width: '0px',
						visible: false
					},
					{
						id: 'groupedItemNo',
						title: 'groupedItemNo',
						width: '0px',
						visible: false
					},
					
					{
						id: 'perilName',
						title: 'Peril Name',
						width: '250%',
						visible: true
					},
					{
						id: 'tsiAmt',
						title: 'TSI Amount',
						width: '250%',
						visible: true
					}
					
			],
			rows:objItmPerilBeneficiary.objItmPerilBeneficiaryList
		};
	
		itmPerilBeneficiaryTableGrid = new MyTableGrid(itmPerilBeneficiaryTableModel);
		itmPerilBeneficiaryTableGrid.render('itmPerilBeneficiaryListing');
	}catch(e){
		showErrorMessage("itmPerilBeneficiaryTableModel", e);
	}
</script>
