<div id="claimListingMainDiv" name="claimListingMainDiv">
	<div id="claimListingMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="recoveryInformation">Recovery Information</a></li>
					<li><a id="recoveryDistribution">Recovery Distribution</a></li>
					<li><a id="generateRecovery">Generate Recovery Acct. Entries</a></li>
					<li><a id="lossRecoveryExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="mainLossUpdateDiv">
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
				<label>Update Loss Recovery Tag</label>
				<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label>
			 		<input type="hidden" id="lineCd" name="lineCd" value="${lineCd}"> 
			 		<label id="reloadForm1" name="reloadForm1">Reload Form</label>
				</span>
			</div>
		</div>
		
		<div id="updateLossRecoveryTagTableGridSectionDiv" class="sectionDiv" style="height: 370px;" >
			<div id="updateLossRecoveryTagTableGridDiv" style="padding: 10px;">
				<div id="updateLossRecoveryTagTableGrid" style="height: 325px; width: 900px;"></div>
			</div>
		</div>
	</div>
	
</div>
<div id="recoveryInfoDiv" style="display: none;">
</div>
<script>
	disableMenu("recoveryInformation");
	disableMenu("recoveryDistribution");
	disableMenu("generateRecovery");
	
	try{
		var objUpdateLossRecoveryTagTG = JSON.parse('${updateLossRecoveryTagTG}'.replace(/\\/g, '\\\\'));
		var objUpdateLossRecoveryTag = objUpdateLossRecoveryTagTG.rows;
		var lossSelectedIndex = null;
		var mtgId = null;
		
		var lossTable = {
				url: contextPath+"/GICLClaimsController?action=showUpdateLossRecoveryTagListing&lineCd="+objCLMGlobal.lineCd+"&refresh=1",	
				options: {
					title: '',
					//width: '786px',
				//	height: '306px',
					onCellFocus: function(element, value, x, y, id) {
						mtgId = lossTagGrid._mtgId;
						lossSelectedIndex = y;
						if (y >= 0){
							var row =  lossTagGrid.getRow(y);
							objCLMGlobal.claimId = row.claimId;
							//objCLMGlobal.claimNo = row.claimNo;
						//	objCLMGlobal.policyNo = row.policyNo;
							if(row.recoverySw =="Y"){
								enableMenu("recoveryInformation");
							}else{
								disableMenu("recoveryInformation");
							}
							/* if(lossTagGrid.getValueAt(lossTagGrid.getColumnIndex('recoveryExist'), lossSelectedIndex) == "Y"  ){
								enableMenu("recoveryInformation");
							}else{
								disableMenu("recoveryInformation");
							} */
							if(lossTagGrid.getValueAt(lossTagGrid.getColumnIndex('statSw'), lossSelectedIndex) == "Y"  ){
								enableMenu("recoveryDistribution");
							}else{
								disableMenu("recoveryDistribution");
							}
							if(lossTagGrid.getValueAt(lossTagGrid.getColumnIndex('distSw'), lossSelectedIndex) == "Y"  &&
									lossTagGrid.getValueAt(lossTagGrid.getColumnIndex('entryTag'), lossSelectedIndex) == "N"	){
								enableMenu("generateRecovery");
							}else{
								disableMenu("generateRecovery");
							}
						}
						observeChangeTagInTableGrid(lossTagGrid);
						populateGlobalObj(row); //set Global variables to display Claim Basic Information by MAC 11/25/2013.
					},
					onRemoveRowFocus : function(){
						//lossSelectedIndex = -1;
						disableMenu("generateRecovery");
						disableMenu("recoveryDistribution");
						disableMenu("recoveryInformation");
						populateGlobalObj(null); //reset Global variables by MAC 11/25/2013.
				  	},
					onCellBlur: function(){
						observeChangeTagInTableGrid(lossTagGrid);
					}, 
				  	toolbar: {
						elements: [MyTableGrid.SAVE_BTN, ,MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
						onSave: function(){
							updateLossTagRecover();
						}
					}
				},
				columnModel: [
					{	id: 'recordStatus',
					    width: '0',
					    visible: false,
					    editor: 'checkbox' 			
					},
					{	
						id: 'divCtrId',
						width: '0',
						visible: false
					},
					{	
						id: 'claimId',
						width: '0',
						visible: false
					},
					{	id:'recoverySw',
						sortable:	false,
						align:		'center',
						title:		'&#160;LR',
						altTitle: 'Loss Recovery Tag',
						width:		'27px',
						editable:  true,
						hideSelectAllBox : true,
						editor: new MyTableGrid.CellCheckbox({
				            getValueOf: function(value){
			            		if (value){
									return "Y";
			            		}else{
									return "N";	
			            		}	
			            	},
			            	onClick: function(value, checked) {
			            		if(lossTagGrid.getValueAt(lossTagGrid.getColumnIndex('recoveryExist'), lossSelectedIndex) == "Y"  ){
									 showWaitingMessageBox("You cannot update this record. This claim's loss recovery is already in process.","I",function(){
		            					 $("mtgInput"+mtgId+"_3,"+lossSelectedIndex).checked = value;
									 });
								}
			            		
		 			    	}
			            })
					},{
						id: 'claimNo',
						title: 'Claim Number',
					  	width: '141',
					  	filterOption: false
				 	},{
						id: 'policyNo',
						title: 'Policy Number',
					  	width: '150',
					  	filterOption: false
				 	},{
						id: 'assuredName',
						title: 'Assured Name',
					  	width: '150',
					  	filterOption: true
				 	},{
						id: 'dspLossDate',
						title: 'Loss Date',
					  	width: '90',
					  	filterOption: true,
					  	filterOptionType: 'formattedDate'
				 	},{//retrieve Loss Category Code by MAC 11/25/2013.
						id: 'lossCatCd',
						title: '',
					  	width: 0,
					  	visible: false
				 	},{
						id: 'lossCatDes',
						title: 'Loss Description',
					  	width: '141',
					  	filterOption: true
				 	},{
						id: 'inHouseAdjustment',
						title: 'Processor',
					  	width: '70',
					  	filterOption: true
				 	},{
						id: 'claimStatDesc',
						title: 'Claim Status',
					  	width: '150',
					  	filterOption: true
				 	} ,{
						id: 'recoveryExist',
						title: '',
					  	width: '0',
					  	visible: false
				 	},{
				 		id: 'clmSeqNo',
			 			title: 'Claim Sequence No.',
					  	width: '0',
					  	visible: false,
					  	filterOption: true,
					  	filterOptionType: 'integerNoNegative'
				 	},{
						id: 'distSw',
						title: '',
					  	width: '0',
					  	visible: false
				 	},{
						id: 'entryTag',
						title: '',
					  	width: '0',
					  	visible: false
				 	},{
						id: 'statSw',
						title: '',
					  	width: '0',
					  	visible: false
				 	},
				 	{	id: 'renewNo',
						title: 'Renew No.',
					  	width: '0',
					  	visible: false,
					  	filterOption: true,
					  	filterOptionType: 'integerNoNegative'
				 	},
				 	{	id: 'policySequenceNo',
						title: 'Policy Sequence No.',
					  	width: '0',
					  	visible: false,
					  	filterOption: true,
					  	filterOptionType: 'integerNoNegative'
				 	},
				 	{	id: 'policyIssueCode',
						title: '',
					  	width: '0',
					  	visible: false
				 	},
				 	{	id: 'claimSequenceNo',
						title: '',
					  	width: '0',
					  	visible: false/*, 
					  	filterOption: true*/
				 	},
				 	{	id: 'claimYy',
						title: 'Claim Year',
					  	width: '0',
					  	visible: false,
					  	filterOption: true,
					  	filterOptionType: 'integerNoNegative'
				 	},
				 	{	id: 'lineCode',
						title: '',
					  	width: '0',
					  	visible: false
				 	},
				 	{	id: 'issueCode',
						title: 'Issue Code',
					  	width: '0',
					  	visible: false,
					  	filterOption: true
				 	},
				 	{	id: 'sublineCd',
						title: 'Subline Code',
					  	width: '0',
					  	visible: false,
					  	filterOption: true
				 	}
				],
				resetChangeTag: true,
				rows: objUpdateLossRecoveryTag
			};
			lossTagGrid = new MyTableGrid(lossTable);
			lossTagGrid.pager = objUpdateLossRecoveryTagTG;
			lossTagGrid.render('updateLossRecoveryTagTableGrid');
		
	}catch(e){
		showErrorMessage("updateLossRecoveryTagTG", e);
	}

	$("lossRecoveryExit").observe("click", function (){
		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						changeTagFunc();
					}, 
					function(){
						goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
					}, 
					"");
		}else{
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
		}
		
	});
	observeReloadForm("reloadForm1",function(){
		showUpdateLossRecoveryTagListing(objCLMGlobal.lineCd);
	});
	
	/**
	*	@author: Irwin Tabisora
	*/ 
	function updateLossTagRecover(){
		try{
			var objClaims = lossTagGrid.getModifiedRows();
			var strParams = prepareJsonAsParameter(objClaims);
			new Ajax.Request(contextPath+'/GICLClaimsController',{
				method: "POST",
				evalScripts: true,
				parameters: {
					action: "updateLossTagRecovery",
					claims: strParams	
				},
				onCreate: showNotice("Updating loss recovery tag, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
							showUpdateLossRecoveryTagListing(objCLMGlobal.lineCd);
						} );
					}
				}
			});
			
		}catch (e) {
			showErrorMessage("updateLossTagRecover",e);
		}
	}
	
	$("recoveryInformation").observe("click", function(){
		if(changeTag == 1){
			showMessageBox("Please save changes first.","I");
		}else{
			objCLMGlobal.callingForm == "GICLS053";
			updateClaimParameters(showRecoveryInformation);
			
			//showRecoveryInformation();
		}
	});
	
	//function to populate Global variables when a claim is selected by MAC 11/25/2013.
	function populateGlobalObj(param){
		objCLMGlobal.claimId = param.claimId;
		objCLMGlobal.claimNo = param.claimNo;
		objCLMGlobal.policyNo = param.policyNo;
		objCLMGlobal.assuredName = param.assuredName;
		objCLMGlobal.strDspLossDate2 = dateFormat(param.dspLossDate, 'mm-dd-yyyy');
		objCLMGlobal.lossCatCd = param.lossCatCd;
		objCLMGlobal.lossCatDes = param.lossCatDes;
		objCLMGlobal.claimStatDesc = param.claimStatDesc;
		objCLMGlobal.issueCode = param.issueCode;
		objCLMGlobal.callingForm = "GICLS053";
	}
	
	changeTagFunc = updateLossTagRecover; // for logout confirmation
	initializeAccordion();
	setDocumentTitle("Update Loss Recovery Tag");
	setModuleId("GICLS053");
</script>