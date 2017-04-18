<div class="sectionDiv">
	<div id="invTaxListing" style="height:156px;width:100%;float:left;"></div>
</div>
<script>

	//initialization
	var objInvTax = new Object();
	objInvTax.objInvTaxListTableGrid = JSON.parse('${invTaxList}'.replace(/\\/g, '\\\\'));
	objInvTax.objInvTaxList = objInvTax.objInvTaxListTableGrid.rows || [];
	
	try{
		var invTaxTableModel = {
			url:contextPath+"/GIPIInvTaxMethodController?action=refreshRelatedInvTaxInfo&policyId="+$F("hidPolicyId")
				,
			options:{
					title: '',
					width: '810px',
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
						id: 'yourTaxCd',
						title: 'Tax Cd',
						width: '60%',
						visible: true
					},
					{
						id: 'yourTaxDesc',
						title: 'Tax Description',
						width: '236%',
						visible: true
					},
					{
						id: 'yourTaxAmt',
						title: 'Tax Amount',
						width: '100%',
						visible: true
					},
					{
						id: 'fullTaxCd',
						title: 'Tax Cd',
						width: '60%',
						visible: true
					},
					{
						id: 'fullTaxDesc',
						title: 'Tax Description',
						width: '236%',
						visible: true
					},
					{
						id: 'fullTaxAmt',
						title: 'TaxAmount',
						width: '100%',
						visible: true
					},
					
					
			],
			rows:objInvTax.objInvTaxList
		};
	
		invTaxTableGrid = new MyTableGrid(invTaxTableModel);
		invTaxTableGrid.render('invTaxListing');
	}catch(e){
		showErrorMessage("invTaxTableModel", e);
	}


	
</script>