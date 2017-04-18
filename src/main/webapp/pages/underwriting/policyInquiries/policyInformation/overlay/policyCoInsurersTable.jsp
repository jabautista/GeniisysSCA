<div id="coInsurersTableGridSectionDiv" style="margin:0px auto 0px auto;">
		<div id="coInsurersTableGridDiv" style="padding:10px;">
			<div id="coInsurersListing" style="height:156px;width:566px;margin:0px auto 0px auto;"></div>
		</div>
</div>
<script>
	var moduleId = $F("hidModuleId");
	
	var objCoInsurers = new Object();
	objCoInsurers.objCoInsurersListTableGrid = JSON.parse('${policyCoInsurers}'.replace(/\\/g, '\\\\'));
	objCoInsurers.objCoInsurersList = objCoInsurers.objCoInsurersListTableGrid.rows || [];
	
	moduleId == "GIPIS101" ? initializeGIPIS101() : initializeGIPIS100();
	
	// function for GIPIS100
	function initializeGIPIS100(){
		try{
			var deductiblesTableModel = {
				url:contextPath+"/GIPICoInsurerController?action=getCoInsurers"+
				"&policyId="+$F("hidPolicyId")+
				"&refresh=1",
				options:{
						title: '',
						width: '566',
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
							title: 'Policy id',
							width: '0px',
							visible: false
						},

						
						{
							id: 'riSname',
							title: 'Co-Insurer',
							titleAlign: 'center',
							width: '175%',
							visible: true
						},
						{
							id: 'coRiShrPct',
							title: 'Co-Insurer Share %',
							titleAlign: 'center',
							width: '123%',
							geniisysClass: 'rate',
							align: 'right',
							visible: true
						},
						{
							id: 'coRiPremAmt',
							title: 'Co-Insurer Share Amt',
							titleAlign: 'center',
							width: '127%',
							geniisysClass: 'money',
							align: 'right',
							visible: true
						},
						{
							id: 'coRiTsiAmt',
							title: 'Co-Insurer TSI Amt',
							titleAlign: 'center',
							width: '125%',
							geniisysClass: 'money',
							align: 'right',
							visible: true
						}
						
				],
				rows:objCoInsurers.objCoInsurersList
			};

			deductiblesTableGrid = new MyTableGrid(deductiblesTableModel);
			deductiblesTableGrid.render('coInsurersListing');
		}catch(e){
			showErrorMessage("initializeGIPIS100", e);
		}
	}
	
	//function for GIPIS101
	function initializeGIPIS101(){
		try{
			var deductiblesTableModel = {
				url: contextPath + "/GIXXCoInsurerController?action=getGIXXCoInsurers" +
								"&extractId=" + $F("hidExtractId") + "&refresh=1",
				options:{
						title: '',
						width: '566',
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
							id: 'extractId',
							title: 'Extract id',
							width: '0px',
							visible: false
						},						
						{
							id: 'riSname',
							title: 'Co-Insurer',
							width: '175%',
							visible: true
						},
						{
							id: 'coRiShrPct',
							title: 'Co-Insurer Share %',
							width: '125%',
							visible: true
						},
						{
							id: 'coRiPremAmt',
							title: 'Co-Insurer Share Amt',
							width: '125%',
							visible: true
						},
						{
							id: 'coRiTsiAmt',
							title: 'Co-Insurer TSI Amt',
							width: '125%',
							visible: true
						}						
				],
				rows:objCoInsurers.objCoInsurersList
			};
			deductiblesTableGrid = new MyTableGrid(deductiblesTableModel);
			deductiblesTableGrid.render('coInsurersListing');
		}catch(e){
			showErrorMessage("initializeGIPIS101", e);
		}
	}

</script>