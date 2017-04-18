<div class="sectionDiv">
	<div id="commInvPerilListing" style="height:156px;width:100%;float:left;"></div>
</div>
<script>

	//initialization
	var objCommInvPeril = new Object();
	objCommInvPeril.objCommInvPerilListTableGrid = JSON.parse('${commInvPerilList}'.replace(/\\/g, '\\\\'));
	objCommInvPeril.objCommInvPerilList = objCommInvPeril.objCommInvPerilListTableGrid.rows || [];
	
	try{
		var commInvPerilTableModel = {
			url:contextPath+"/GIPICommInvPerilMethodController?action=refreshRelatedCommInvPerilInfo&policyId="+$F("hidPolicyId")
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
						id: 'yourIntmNo',
						title: 'Intm No.',
						width: '100%',
						visible: true
					},
					{
						id: 'yourIntmName',
						title: 'yourIntmName',
						width: '100%',
						visible: true
					},
					{
						id: 'yourPrntIntmNo',
						title: 'yourPrntIntmNo',
						width: '100%',
						visible: true
					},
					{
						id: 'yourPrntIntmName',
						title: 'yourPrntIntmName',
						width: '100%',
						visible: true
					},
					{
						id: 'yourSharePercentage',
						title: 'yourSharePercentage',
						width: '100%',
						visible: true
					},
					{
						id: 'yourPremiumAmt',
						title: 'yourPremiumAmt',
						width: '100%',
						visible: true
					},
					{
						id: 'yourCommissionAmt',
						title: 'yourCommissionAmt',
						width: '100%',
						visible: true
					},
					{
						id: 'yourWholdingTax',
						title: 'yourWholdingTax',
						width: '100%',
						visible: true
					},
					{
						id: 'yourNetPremium',
						title: 'yourNetPremium',
						width: '100%',
						visible: true
					},

					
					{
						id: 'fullIntmNo',
						title: 'fullIntmNo',
						width: '100%',
						visible: true
					},
					{
						id: 'fullIntmName',
						title: 'fullIntmName',
						width: '100%',
						visible: true
					},
					{
						id: 'fullPrntIntmNo',
						title: 'fullPrntIntmNo',
						width: '100%',
						visible: true
					},
					{
						id: 'fullPrntIntmName',
						title: 'fullPrntIntmName',
						width: '100%',
						visible: true
					},
					{
						id: 'fullSharePercentage',
						title: 'fullSharePercentage',
						width: '100%',
						visible: true
					},
					
					{
						id: 'fullPremiumAmt',
						title: 'fullPremiumAmt',
						width: '100%',
						visible: true
					},
					{
						id: 'fullCommissionAmt',
						title: 'fullCommissionAmt',
						width: '100%',
						visible: true
					},
					{
						id: 'fullWholdingTax',
						title: 'fullWholdingTax',
						width: '100%',
						visible: true
					},
					{
						id: 'fullNetCommission',
						title: 'fullNetCommission',
						width: '100%',
						visible: true
					}
					
					
				
					
					
			],
			rows:objCommInvPeril.objCommInvPerilList
		};
	
		commInvPerilTableGrid = new MyTableGrid(commInvPerilTableModel);
		commInvPerilTableGrid.render('commInvPerilListing');
	}catch(e){
		showErrorMessage("commInvPerilTableModel", e);
	}


	
</script>