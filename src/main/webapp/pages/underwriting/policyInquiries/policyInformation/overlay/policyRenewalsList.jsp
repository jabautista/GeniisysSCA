<div id="polRenewalsInfoTableGridSectionDiv" style="margin:0px auto 0px auto;">
		<div id="polRenewalsInfoTableGridDiv" style="padding:10px;">
			<div id="polRenewalsInfoListing" style="height:156px;width:250px;margin:0px auto 0px auto;"></div>
		</div>
		<div style="text-align:center;">
			<input type="button" class="button" id="btnReturn" value="Return" style="width: 100px;"/>
		</div>
</div>
<script>
	
	try{
		var objRenewals = new Object();
		objRenewals.objRenewalsListTableGrid = JSON.parse('${policyRenewalsList}'.replace(/\\/g, '\\\\'));
		objRenewals.objRenewalsList = objRenewals.objRenewalsListTableGrid.rows || [];
	
	
		var renewalsTableModel = {
			url:contextPath+"/GIPIPolbasicController?action=getPolicyRenewals"+
			"&policyId="+$F("hidPolicyId")+
			"&refresh=1",
			options:{
					title: '',
					width: '250px',
					onCellFocus: function(element, value, x, y, id){
						renewalsTableGrid.releaseKeys();
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						renewalsTableGrid.releaseKeys();
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
						id: 'policyNo',
						title: 'Policy No.',
						width: '240%',
						visible: true
					},
					
			],
			rows:objRenewals.objRenewalsList
		};

		renewalsTableGrid = new MyTableGrid(renewalsTableModel);
		renewalsTableGrid.render('polRenewalsInfoListing');
	}catch(e){
		showErrorMessage("Policy Renewals", e);
	}


	$("btnReturn").observe("click", function(){
		overlayRenewals.close();
	});

</script>