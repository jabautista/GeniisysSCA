<div style="height:160px;width:850px;margin:0px auto 0px auto;">
		<div id="grpItemsBeneficiaryListing" style="height:156px;width:850px;float:left;"></div>
</div>

<script>
	//initialization
	var objGrpItemsBeneficiary = new Object();
	objGrpItemsBeneficiary.objGrpItemsBeneficiaryListTableGrid = JSON.parse('${grpItemsBeneficiaryList}'.replace(/\\/g, '\\\\'));
	objGrpItemsBeneficiary.objGrpItemsBeneficiaryList = objGrpItemsBeneficiary.objGrpItemsBeneficiaryListTableGrid.rows || [];
	
	var moduleId = $F("hidModuleId");
	
	try{
		var path101 = "/GIXXGrpItemsBeneficiaryController?action=getGIXXAccidentGrpItemsBeneficiary"+
					  "&extractId="+nvl($("hidGroupedItemsExtractId").value,0)+
					  "&itemNo="+nvl($("hidGroupedItemsItemNo").value,0)+
					  "&groupedItemNo"+nvl($("hidGroupedItemsGroupedItemNo").value,0);
		
		var path100 = "/?action=getGrpItemBeneficiaries"+
					  "&policyId="+nvl($("hidGroupedItemsPolicyId").value,0)+
					  "&itemNo="+nvl($("hidGroupedItemsItemNo").value,0)+
					  "&groupedItemNo"+nvl($("hidGroupedItemsGroupedItemNo").value,0);
		
		var grpItemsBeneficiaryTableModel = {
			/*url:contextPath+"/?action=getGrpItemBeneficiaries"+
			"&policyId="+nvl($("hidGroupedItemsPolicyId").value,0)+
			"&itemNo="+nvl($("hidGroupedItemsItemNo").value,0)+
			"&groupedItemNo"+nvl($("hidGroupedItemsGroupedItemNo").value,0)*/ // commented out by Kris 02.28.2013 and replaced with the line below:
			url:contextPath+ ( moduleId == "GIPIS101" ? path101 : path100 )
				,
			options:{
					title: '',
					width: '850px',
					onCellFocus: function(element, value, x, y, id){
						grpItemsBeneficiaryTableGrid.releaseKeys();
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						grpItemsBeneficiaryTableGrid.releaseKeys();
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
						id: 'beneficiaryNo',
						title: 'No.',
						width: '50%',
						visible: true
					},
					{
						id: 'beneficiaryName',
						title: 'Name',
						width: '200%',
						visible: true
					},
					{
						id: 'sex',
						title: 'Sex',
						width: '30%',
						visible: true
					},
					{
						id: 'relation',
						title: 'Relation',
						width: '112%',
						visible: true
					},
					{
						id: 'civilStatus',
						title: 'Status',
						width: '50%',
						visible: true
					},
					{
						id: 'dateOfBirth',
						title: 'Birthday',
						width: '100%',
						type: 'date',
						visible: true
					},
					{
						id: 'age',
						title: 'Age',
						width: '30%',
						visible: true
					},
					{
						id: 'beneficiaryAddr',
						title: 'Address',
						width: '250%',
						visible: true
					} 					
			],
			rows:objGrpItemsBeneficiary.objGrpItemsBeneficiaryList
		};
	
		grpItemsBeneficiaryTableGrid = new MyTableGrid(grpItemsBeneficiaryTableModel);
		grpItemsBeneficiaryTableGrid.render('grpItemsBeneficiaryListing');
	}catch(e){
		showErrorMessage("grpItemsBeneficiary", e);
	}
</script>
