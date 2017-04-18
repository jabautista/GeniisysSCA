<div id="polTableGridSectionDiv" class="sectionDiv" style="height:395px; margin:0px auto 50px auto;">
	<div align="center" style="">
		<input id="btnSummaryInformation" class="button" type="button" value="Summary Details" name="btnSummaryInformation" style="width:200px; margin-top: 10px; margin-botton: 5px;"/>
	</div>
	<div id="polTableGridDiv" style="padding: 10px;">
		<div id="polTableGridListing" style="height: 305px; width: 900px;"></div>
	</div>
	<div align="center" style="">
		<input id="btnPolicyEndtDetails" class="disabledButton" type="button" value="Policy / Endorsement Details" name="btnPolicyEndtDetails" style="width:200px;"/>
		<input id="btnDistributionDetails" class="disabledButton" type="button" value="Policy Distribution" name="btnDistributionDetails" style="width:200px;"/>
	</div>
</div>

<script>
    objGIPIS100.extractId = null; // added by: Nica 05.02.2013
	var objPol = new Object();
	objPol.objPolListTableGrid = JSON.parse('${gipiRelatedPoliciesTableGrid}'.replace(/\\/g, '\\\\'));
	objPol.objPolList = objPol.objPolListTableGrid.rows || [];
	objGIPIS100.policyId = null;
	var selectedIndex = -1;
	var selectedPolicyId = null;	//hdrtagudin	07302015 SR 18751
	function onDoubleClick(param){
		polTableGrid.keys.removeFocus(polTableGrid.keys._nCurrentFocus, true);
		polTableGrid.keys.releaseKeys();
		var row = polTableGrid.geniisysRows[selectedIndex];
		var policyId = row.policyId;
		objGIPIS100.policyId = policyId;
		showPolicyMainInfoPage(policyId);
		$("polMainInfoDiv").show();
		$("viewPolInfoMainDiv").hide();
		//objGIPIS100.callingForm = "GIPIS000"; commented out by gab 08.17.2015 
		objGIPIS100.fromEndtType = "N";
	}
	
	try{
		var polTableModel = {
			url: contextPath+"/GIPIPolbasicController?action=refreshRelatedPoliciesTableGrid"
				+"&lineCd="		+$F("txtLineCd")
				+"&sublineCd="	+$F("txtSublineCd")
				+"&issCd="		+$F("txtIssCd")
				+"&issueYy="	+$F("txtIssueYy")
				+"&polSeqNo="	+$F("txtPolSeqNo")
				+"&renewNo="	+$F("txtRenewNo")
				+"&refPolNo="	+$F("txtRefPolNo")
				+"&refresh=1",
			options:{
				title: '',
				width: '900px',
				height: '280px',
				onCellFocus: function(element, value, x, y, id) {
					selectedIndex = y;
					disableButton("btnSummaryInformation");
					enableButton("btnPolicyEndtDetails");
					//hdrtagudin	07302015 SR 18751
					if ($F("txtIssCd") == '${issCdRI}')
						{
							enableButton("btnInitialAcceptance");
							var row = polTableGrid.geniisysRows[selectedIndex];
							selectedPolicyId = row.policyId;
							//console.log(selectedPolicyId);
						}
					else
						{
							disableButton("btnInitialAcceptance");
							selectedPolicyId = null;
						}
					if(polTableGrid.geniisysRows[y].endtNo == null || (polTableGrid.geniisysRows[y].endtNo != null && polTableGrid.geniisysRows[y].endtNo.substring(polTableGrid.geniisysRows[y].endtNo.length -1, polTableGrid.geniisysRows[y].endtNo.length) == "A")) {
						enableButton("btnDistributionDetails");
					} else {
						disableButton("btnDistributionDetails");
					}	
					
					polTableGrid.keys.removeFocus(polTableGrid.keys._nCurrentFocus, true);
					polTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus: function() {
					selectedIndex = -1;
					if(checkUserModule("GIPIS101")){ // added by: Nica 05.09.2013 - to check if user has access to GIPIS101 module
						enableButton("btnSummaryInformation");
					}else{
						disableButton("btnSummaryInformation");
					}
					polTableGrid.keys.removeFocus(polTableGrid.keys._nCurrentFocus, true);
					polTableGrid.keys.releaseKeys();
					disableButton("btnDistributionDetails");
					disableButton("btnPolicyEndtDetails");					
					//START hdrtagudin	07302015 SR 18751
					disableButton("btnInitialAcceptance");		
					selectedPolicyId = null;
					//END hdrtagudin	07302015 SR 18751
				},
				onRowDoubleClick: function(){
					onDoubleClick();
				},
				toolbar:{
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						selectedIndex = -1;
						disableButton("btnDistributionDetails");
						disableButton("btnPolicyEndtDetails");
						//START hdrtagudin	07302015 SR 18751
						disableButton("btnInitialAcceptance");		
						selectedPolicyId = null;
						//END hdrtagudin	07302015 SR 18751
					},
					onRefresh: function(){
						selectedIndex = -1;
						disableButton("btnDistributionDetails");
						disableButton("btnPolicyEndtDetails");
						//START hdrtagudin	07302015 SR 18751
						disableButton("btnInitialAcceptance");		
						selectedPolicyId = null;
						//END hdrtagudin	07302015 SR 18751
					}
				},
				onSort: function(){
					selectedIndex = -1;
					disableButton("btnDistributionDetails");
					disableButton("btnPolicyEndtDetails");
					//START hdrtagudin	07302015 SR 18751
					disableButton("btnInitialAcceptance");		
					selectedPolicyId = null;
					//END hdrtagudin	07302015 SR 18751
				}
			},
			columnModel: [
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
				{	id: 'policyId',
					width: '0px',
					visible: false
				},
				{	id: 'endtNo',
					title: 'Endorsement Nos.',
					width: '110%',
					filterOption: true
				},
				{	id: 'strEffDate',
					title: 'Effectivity',
					width: '100%',
					filterOption: true,
					type : 'date',
					format: 'mm-dd-yyyy',
					filterOptionType: 'formattedDate'
				},
				{	id: 'strIssueDate',
					title: 'Issue Date',
					width: '100%',
					filterOption: true,
					type : 'date',
					format: 'mm-dd-yyyy',
					filterOptionType: 'formattedDate'
				},
				{	id: 'strAcctEntDt',
					title: 'Acctg Date',
					width: '100%',
					type: 'date',
					filterOption: true,
					format: 'mm-dd-yyyy',
					filterOptionType: 'formattedDate'
				},
				{	id: 'parNo',
					title: 'PAR No.',
					width: '138.7%',
					filterOption: true
				},
				{	id: 'refPolNo',
					title: 'Ref. Pol. No.',
					width: '100%',
					filterOption: true
				},
				{	id: 'premAMt',
					title: 'Premium/Refund',
					width: '104%',
					titleAlign: 'right',
					align: 'right',
					geniisysClass : 'money',
		            geniisysMinValue: '-999999999999.99',     
		            geniisysMaxValue: '999,999,999,999.99'
				},
				{	id: 'meanPolFlag',
					title: 'Status',
					width: '100%',
					filterOption: true
				},
				{	id: 'reinstateTag',
					title: 'R',
					width: '22%',
				  	defaultValue: false,
				  	otherValue: false,
				  	editor: new MyTableGrid.CellCheckbox({
				  		getValueOf: function(value) {
				  			var result = 'N';
				  			if (value) result = 'Y';
				  			return result;
				  		}
				  	})
				}
			],
			rows: objPol.objPolList	
		};
		
		polTableGrid = new MyTableGrid(polTableModel);
		polTableGrid.pager = objPol.objPolListTableGrid;
		polTableGrid.render('polTableGridListing');
		
	}catch(e){
		showErrorMessage("Related Policies", e);
	}

	/*$("btnSummaryInformation").observe("click", function(){
		if(nvl(objGIPIS100.extractId, null) == null){
			extractSummaryGIPIS100();
		}else{
			showPolicySummaryPage();
			$("polMainInfoDiv").show();
			$("viewPolInfoMainDiv").hide();
		}
	});*/ // replaced by: Nica 05.09.2013 - to check user access on GIPIS101 module
	
	observeAccessibleModule(accessType.BUTTON, "GIPIS101", "btnSummaryInformation", 
			function(){
				if(nvl(objGIPIS100.extractId, null) == null){
					extractSummaryGIPIS100();
				}else{
					showPolicySummaryPage();
					$("polMainInfoDiv").show();
					$("viewPolInfoMainDiv").hide();
				}
			}
	);
	
	$("btnPolicyEndtDetails").observe("click", function(){
		onDoubleClick();
	});
	
	//START hdrtagudin 07302015 SR 18751
	$("btnInitialAcceptance").observe("click", function(){
		try {
			overlayInitialAcceptance = 
				Overlay.show(contextPath+"/GIPIPolbasicController", {
					urlContent: true,
					urlParameters: {action : "showInitialAcceptance",
									policyId : selectedPolicyId
					},
				    title: "Initial Acceptance",
				    height: 380,
				    width: 750,
				    draggable: true
				});
			} catch (e) {
				showErrorMessage("overlay error: " , e);
			}
	});
	//END hdrtagudin 07302015 SR 18751
	$("btnDistributionDetails").observe("click", function(){
		showViewDistributionStatus("GIPIS100", polTableGrid.geniisysRows[selectedIndex].policyId);
	});
</script>