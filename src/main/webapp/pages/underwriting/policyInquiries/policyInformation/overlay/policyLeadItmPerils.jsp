<div id="leadPolicyItmPerilsTableGridSectionDiv" style="float:left;">
		<div id="leadPolicyItmPerilsTableGridDiv" style="">
			<div id="leadPolicyItmPerilsListing" style="height:156px;width:400px;margin:0px auto 0px auto;"></div>
		</div>
</div>
<script>
	var moduleId = $F("hidModuleId");
	
	var objLeadPolicyItmPerils = new Object();
	objLeadPolicyItmPerils.objLeadPolicyItmPerilsListTableGrid = JSON.parse('${leadPolicyItmPerilsList}'.replace(/\\/g, '\\\\'));
	objLeadPolicyItmPerils.objLeadPolicyItmPerilsList = objLeadPolicyItmPerils.objLeadPolicyItmPerilsListTableGrid.rows || [];
	
	try{
		/*var gipis100 = "/GIPIOrigItmPerilController?action=getItmPerils" + "&refresh=1";
		var gipis101 = "/GIXXOrigItmPerilController?action=getGIXXOrigItmPerilList" + "&refresh=1" + 
						"&extractId=" + $F("hidExtractId") + "&itemNo=" + $F("hidItemNo");*/ // replaced by: Nica 05.08.2013
		
		var url = contextPath+ "/GIPIOrigItmPerilController?action=getItmPerils" + "&refresh=1"+
					"&policyId=" + $F("hidPolicyId") + "&itemNo=" + $F("hidGIPIS100ItemNo"); //added by robert
		if(moduleId == "GIPIS101"){
			url = contextPath+ "/GIXXOrigItmPerilController?action=getGIXXOrigItmPerilList" + "&refresh=1" + 
			"&extractId=" + $F("hidExtractId") + "&itemNo=" + $F("hidItemNo");
		}
		
		var leadPolicyItmPerilsTableModel = {
			/*url: contextPath+"/GIPIOrigItmPerilController?action=getItmPerils"+
			"&refresh=1",*/
			//url: contextPath + (moduleId == "GIPIS101" ? gipis101 : gipis100)
			url: url	,
			options:{
					title: '',
					width: '824',
					onCellFocus: function(element, value, x, y, id){
			
						$("txtItemPerilRemarks").value 		= unescapeHTML2(leadPolicyItmPerilsTableGrid.geniisysRows[y].compRem);
						$("txtLeadPolicyPerilDesc").value 	= unescapeHTML2(leadPolicyItmPerilsTableGrid.geniisysRows[y].perilDesc);
						leadPolicyItmPerilsTableGrid.releaseKeys();
					},
					onRemoveRowFocus:function(element, value, x, y, id){						
						$("txtItemPerilRemarks").value 		= "";
						$("txtLeadPolicyPerilDesc").value 	= "";
						leadPolicyItmPerilsTableGrid.releaseKeys();
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
						id: 'dspFullPremAmt',
						title: 'dspFullPremAmt',
						width: '0%',
						visible: false
					},
					{
						id: 'dspFullTsiAmt',
						title: 'dspFullTsiAmt',
						width: '0%',
						visible: false
					},
					{
						id: 'yourPerilCode',
						title: 'Peril Code',
						width: '93%',
						visible: true
					},
					{
						id: 'yourPremRt',				
						title: 'Prem Rt',
						width: '80%',
						visible: true
					},
					{
						id: 'yourTsiAmt',
						title: 'TSI Amount',
						width: '100%',
						visible: true,
						geniisysClass: 'money',
						align: 'right'
					},
					{
						id: 'yourPremAmt',
						title: 'Prem Amount',
						width: '100%',
						visible: true,
						geniisysClass: 'money',
						align: 'right'
					},
					{
						id: 'yourDiscountSw',
						title: 'D',
						width: '25%',
						visible: true
						
					},					
					{
						id: 'fullPerilCode',
						title: 'Peril Code',
						width: '93%',
						visible: true
					},
					{
						id: 'fullPremRt',
						title: 'Prem Rt',
						width: '80%',
						visible: true
					},
					{
						id: 'fullTsiAmt',
						title: 'TSI Amount',
						width: '100%',
						visible: true,
						geniisysClass: 'money',
						align: 'right'
					},
					{
						id: 'fullPremAmt',
						title: 'Prem Amount',
						width: '100%',
						visible: true,
						geniisysClass: 'money',
						align: 'right'
					},
					{
						id: 'fullDiscountSw',
						title: 'D',
						width: '23%',
						visible: true
					}
			],
			rows:objLeadPolicyItmPerils.objLeadPolicyItmPerilsList
		};

		leadPolicyItmPerilsTableGrid = new MyTableGrid(leadPolicyItmPerilsTableModel);
		leadPolicyItmPerilsTableGrid.render('leadPolicyItmPerilsListing');

		
	}catch(e){
		showErrorMessage("Lead Policy Item Perils", e);
	}
	
	try{
		$("txtFullPremAmt").value = formatCurrency(leadPolicyItmPerilsTableGrid.getValueAt(2,0));
		$("txtFullTsiAmt").value = formatCurrency(leadPolicyItmPerilsTableGrid.getValueAt(3,0));
	}catch(e){}
	
</script>