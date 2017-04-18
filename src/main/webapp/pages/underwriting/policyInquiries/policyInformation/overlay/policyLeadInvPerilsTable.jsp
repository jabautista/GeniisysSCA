<div class="sectionDiv">
	<div id="invPerilListing" style="height:156px;width:100%;float:left;"></div>
</div>
<script>

	//initialization
	var objInvPeril = new Object();
	objInvPeril.objInvPerilListTableGrid = JSON.parse('${invPerilList}'.replace(/\\/g, '\\\\'));
	objInvPeril.objInvPerilList = objInvPeril.objInvPerilListTableGrid.rows || [];
	
	try{
		var invPerilTableModel = {
			url:contextPath+"/GIPIInvPerilMethodController?action=refreshRelatedInvPerilInfo&policyId="+$F("hidPolicyId")
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
						id: 'yourPerilCode',
						title: 'Peril Code',
						width: '65%',
						visible: true
					},
					{
						id: 'yourPremAmt',
						title: 'Prem Amt',
						width: '230%',
						visible: true
					},
					{
						id: 'yourTsiAmt',
						title: 'TSI Amount',
						width: '100%',
						visible: true
					},
					{
						id: 'fullPerilCode',
						title: 'Peril Code',
						width: '65%',
						visible: true
					},
					{
						id: 'fullPremAmt',
						title: 'Prem Amount',
						width: '230%',
						visible: true
					},
					{
						id: 'fullTsiAmt',
						title: 'TSI Amount',
						width: '100%',
						visible: true
					},
					
					
			],
			rows:objInvPeril.objInvPerilList
		};
	
		invPerilTableGrid = new MyTableGrid(invPerilTableModel);
		invPerilTableGrid.render('invPerilListing');
	}catch(e){
		showErrorMessage("invPerilTableModel", e);
	}


	
</script>