
<div id="polClaimsTableGridSectionDiv" class="sectionDiv" style="height:305px;width:700px;margin-left:auto;margin-right:auto;">
		<div id="polClaimsTableGridDiv" style="height:305px;width:700px;">
			<div id="polClaimListing" style="height:281px;width:700px;"></div>
		</div>
</div>

<br/><br/><br/><br/><br/><br/><br/><br/>
<br/><br/><br/><br/><br/><br/><br/><br/><br/>

<script>
	var moduleId = $F("hidModuleId");
	var objClaims = new Object();
	objClaims.objClaimsListTableGrid = JSON.parse('${giclRelatedClaimsTableGrid}'.replace(/\\/g, '\\\\'));
	objClaims.objClaimsList = objClaims.objClaimsListTableGrid.rows || [];
	var length = objClaims.objClaimsList.length;
	
	moduleId == "GIPIS101" ? initializeGIPIS101() : initializeGIPIS100();
	
	// table grid for GIPIS100
	function initializeGIPIS100(){
		try{
			var claimsTableModel = {
				url:contextPath+"/GICLClaimsController?action=refreshRelatedClaims&refresh=1&policyId="+$F("hidPolicyId")
					,
				options:{
						title: '',
						width: '700px',
						onCellFocus: function(element, value, x, y, id){
							claimsTableGrid.keys.removeFocus(claimsTableGrid.keys._nCurrentFocus, true);
							claimsTableGrid.keys.releaseKeys();
							if(checkUserModule("GICLS260")){
								objCLMGlobal.claimId = claimsTableGrid.geniisysRows[y].claimId;
								objCLMGlobal.callingForm = "GIPIS100";
								enableButton("btnClaimInfo");
							}else{
								disableButton("btnClaimInfo");
							}
						},
						onRemoveRowFocus:function(element, value, x, y, id){
							claimsTableGrid.keys.removeFocus(claimsTableGrid.keys._nCurrentFocus, true);
							claimsTableGrid.keys.releaseKeys();	
							objCLMGlobal.claimId = null;
							objCLMGlobal.callingForm = null;
						},
						onRowDoubleClick: function(y){
							claimsTableGrid.keys.removeFocus(claimsTableGrid.keys._nCurrentFocus, true);
							claimsTableGrid.keys.releaseKeys();
							if(checkUserModule("GICLS260")){ 
								objCLMGlobal.claimId = claimsTableGrid.geniisysRows[y].claimId;
								objCLMGlobal.callingForm = "GIPIS100";
								//showClaimInformationMain("polMainInfoDiv");
								showGIPIS100ClaimInfoListing(objCLMGlobal.claimId); //modified by gab 05.23.2016 SR 21694
							}else{
								
							}
							
						},
						onSort: function() {	//Gzelle 06.15.2013
							claimsTableGrid.keys.removeFocus(claimsTableGrid.keys._nCurrentFocus, true);
							claimsTableGrid.keys.releaseKeys();	
							objCLMGlobal.claimId = null;
							objCLMGlobal.callingForm = null;
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
							id: 'claimNumber',
							title: 'Claim No.',
							width: '150%',
							visible: true
			
						},
						{
							id: 'strClaimFileDate',
							title: 'Filing Date',
							//type: 'date',
							width: '100%x',
							visible: true
			
						},
						
						{	id: 'claimSettlementDate',
							title: 'Settle Date',
							type: 'date',
							width: '100%',
							filterOption: true
						},
						{	id: 'claimAmount',
							title: 'Claim Amount',
							width: '100%',
							align: 'right',
							titleAlign: 'right',
							filterOption: true,
							geniisysClass : 'money',     
				            geniisysMinValue: '-999999999999.99',     
				            geniisysMaxValue: '999,999,999,999.99'
						},
						{	id: 'paidAmount',
							title: 'Paid Amount',
							width: '100%',
							align: 'right',
							titleAlign: 'right',
							filterOption: true,
							geniisysClass : 'money',     
				            geniisysMinValue: '-999999999999.99',     
				            geniisysMaxValue: '999,999,999,999.99'
						},
						{	id: 'claimStatDesc',
							title: 'Status',
							width: '132%',
							filterOption: true
						},
						],
				rows:objClaims.objClaimsList
			};

			claimsTableGrid = new MyTableGrid(claimsTableModel);
			claimsTableGrid.pager = objClaims.objClaimsListTableGrid;
			claimsTableGrid.render('polClaimListing');
		}catch(e){
			showErrorMessage("initializeGIPIS100", e);
		}
	}
	
	
	// function for displaying tablegrid for GIPIS101
	function initializeGIPIS101(){
		try{
			var claimsTableModel = {
				url:contextPath+"/GIXXClaimsController?action=getGIXXRelatedClaims&refresh=1&extractId="+$F("hidExtractId")
					,
				options:{
						title: '',
						width: '700px',
						onCellFocus: function(element, value, x, y, id){
							claimsTableGrid.keys.removeFocus(claimsTableGrid.keys._nCurrentFocus, true);
							claimsTableGrid.keys.releaseKeys();	

						},
						onRowDoubleClick: function(param){
							var row = claimsTableGrid.geniisysRows[param];
							
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
							id: 'claimNumber',
							title: 'Claim No.',
							width: '200%',
							visible: true
			
						},
						{
							id: 'claimFileDate',
							title: 'Filing Date',
							type: 'date',
							width: '102%',
							visible: true
			
						},
						
						{	id: 'claimSettlementDate',
							title: 'Settle Date',
							type: 'date',
							width: '102%',
							filterOption: true
						},
						{	id: 'claimAmount',
							title: 'Claim Amount',
							width: '140%',
							align: 'right',
							titleAlign: 'right',
							filterOption: true,
							geniisysClass : 'money',     
				            geniisysMinValue: '-999999999999.99',     
				            geniisysMaxValue: '999,999,999,999.99'
						},
						{	id: 'paidAmount',
							title: 'Paid Amount',
							width: '140%',
							align: 'right',
							titleAlign: 'right',
							filterOption: true,
							geniisysClass : 'money',     
				            geniisysMinValue: '-999999999999.99',     
				            geniisysMaxValue: '999,999,999,999.99'
						}
						],
				rows:objClaims.objClaimsList
			};

			claimsTableGrid = new MyTableGrid(claimsTableModel);
			claimsTableGrid.pager = objClaims.objClaimsListTableGrid;
			claimsTableGrid.render('polClaimListing');
		}catch(e){
			showErrorMessage("initializeGIPIS101", e);
		}
	}
	
</script>