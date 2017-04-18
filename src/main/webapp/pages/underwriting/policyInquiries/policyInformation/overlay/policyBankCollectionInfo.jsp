<div id="polBankCollInfoTableGridSectionDiv" style="margin:0px auto 0px auto;">
		<div id="polBankCollInfoTableGridDiv" style="padding:10px;">
			<div id="polBankCollInfoListing" style="height:156px;width:550px;margin:0px auto 0px auto;"></div>
		</div>
		<div style="text-align:center;">
			<input type="button" class="button" id="btnOk" value="Ok"/>
		</div>
</div>
<script>
	
	var objBankColl = new Object();
	objBankColl.objBankCollListTableGrid = JSON.parse('${policyBankCollections}'.replace(/\\/g, '\\\\'));
	objBankColl.objBankCollList = objBankColl.objBankCollListTableGrid.rows || [];
	
	try{
		var bankCollTableModel = {
			url:contextPath+"/GIPIBankScheduleController?action=getBankCollections"+
			"&policyId="+$F("hidPolicyId")+
			"&refresh=1",
			options:{
					title: '',
					width: '550px',
					onCellFocus: function(element, value, x, y, id){
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
						title: 'Policy id',
						width: '0px',
						visible: false
					},
					{
						id: 'bankItemNo',
						title: 'No.',
						width: '50%',
						visible: true
					},
					{
						id: 'bank',
						title: 'Bank',
						width: '265%',
						visible: true
					},
					{
						id: 'cashInVault',
						title: 'Cash In Vault',
						width: '100%',
						visible: true
					},
					{
						id: 'cashInTransit',
						title: 'Cash In Transit',
						width: '100%',
						visible: true
					},
					
			],
			rows:objBankColl.objBankCollList
		};

		bankCollTableGrid = new MyTableGrid(bankCollTableModel);
		bankCollTableGrid.render('polBankCollInfoListing');
	}catch(e){
		showErrorMessage("bankCollTableModel", e);
	}


	$("btnOk").observe("click", function(){
		overlayBankCollection.close();
	});

</script>