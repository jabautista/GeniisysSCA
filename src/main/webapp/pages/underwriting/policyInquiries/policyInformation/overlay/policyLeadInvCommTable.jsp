<div class="sectionDiv">
	<div id="invCommListing" style="height:156px;width:100%;float:left;"></div>
</div>
<script>

	//initialization
	var objInvComm = new Object();
	objInvComm.objInvCommListTableGrid = JSON.parse('${invCommList}'.replace(/\\/g, '\\\\'));
	objInvComm.objInvCommList = objInvComm.objInvCommListTableGrid.rows || [];
	
	try{
		var invCommTableModel = {
			url:contextPath+"/?action=refreshRelatedInvCommInfo&policyId="+$F("hidPolicyId")
				,
			options:{
					title: '',
					width: '810px',
					onCellFocus: function(element, value, x, y, id){
						loadCommInvPerilsTableGrid(invCommTableGrid.geniisysRows[y].policyId,
								invCommTableGrid.geniisysRows[y].itemGrp,
								invCommTableGrid.geniisysRows[y].intrmdryIntmNo);
						
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						unloadCommInvPerilTable();
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
						id: 'yourPerilName',
						title: 'Peril Name',
						width: '0px',
						visible: false
					},
					{
						id: 'yourPerilSname',
						title: 'Peril',
						width: '50px',
						visible: true
					},
					{
						id: 'yourPremiumAmt',
						title: 'Prem. Amount',
						width: '100px',
						visible: true,
						geniisysClass: 'money',
						align: 'right'
					},
					{
						id: 'yourCommissionRt',
						title: 'Rate',
						width: '100px',
						visible: true,
						geniisysClass: 'rate'
					},
					{
						id: 'yourCommissionAmt',
						title: 'Comm. Amount',
						width: '100px',
						geniisysClass: 'money',
						align: 'right'
					},
					{
						id: 'yourWholdingTax',
						title: 'Withholding Tax',
						width: '100px',
						visible: true,
						geniisysClass: 'money',
						align: 'right'
					},
					
					{
						id: 'yourNetCommission',
						title: 'Net Commission',
						width: '100px',
						visible: true,
						geniisysClass: 'money',
						align: 'right'
					},
					{
						id: 'fullPerilName',
						title: 'Peril Name',
						width: '0px',
						visible: false
					},
					{
						id: 'fullPerilSname',
						title: 'Peril',
						width: '50px',
						visible: true
					},
					{
						id: 'fullPremiumAmt',
						title: 'Prem. Amount',
						width: '100px',
						visible: true,
						geniisysClass: 'money',
						align: 'right'
					},
					{
						id: 'fullCommissionRt',
						title: 'Rate',
						width: '100px',
						visible: true,
						geniisysClass: 'rate'
					},
					{
						id: 'fullCommissionAmt',
						title: 'Comm. Amount',
						width: '100px',
						geniisysClass: 'money',
						align: 'right'
					},
					{
						id: 'fullWholdingTax',
						title: 'Withholding Tax',
						width: '100px',
						visible: true,
						geniisysClass: 'money',
						align: 'right'
					},
					
					{
						id: 'fullNetCommission',
						title: 'Net Commission',
						width: '100px',
						visible: true,
						geniisysClass: 'money',
						align: 'right'
					},
					
			],
			rows:objInvComm.objInvCommList
		};
	
		invCommTableGrid = new MyTableGrid(invCommTableModel);
		invCommTableGrid.render('invCommListing');
	}catch(e){
		showErrorMessage("Lead Policy Invoice Comm", e);
	}

	function loadCommInvPerilsTableGrid(policyId,itemGrp,intrmdryIntmNo){
		
		new Ajax.Updater("commInvPerilTableDiv","GIPIOrigCommInvPerilController?action=getCommInvPerils",{
			method:"get",
			evalScripts: true,
			parameters: {
				policyId 		: nvl(policyId, 0),
				itemGrp			: nvl(itemGrp, 0),
				intrmdryIntmNo	: nvl(intrmdryIntmNo, 0)
			}
					
		});
		
	}

	function unloadCommInvPerilTable(){
		$("commInvPerilTableDiv").innerHTML = "";
	}
</script>