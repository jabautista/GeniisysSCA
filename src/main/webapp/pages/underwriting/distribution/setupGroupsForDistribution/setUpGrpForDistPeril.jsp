<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>

<div id="gipiPolbasicPolDistV1ListingMainDiv" name="gipiPolbasicPolDistV1ListingMainDiv">
	<div id="gipiPolbasicPolDistV1ListingMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="gipiPolbasicPolDistV1ListingQuery">Query</a></li>
					<li><a id="gipiPolbasicPolDistV1ListingExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="gipiPolbasicPolDistV1TableGridDiv">
		<jsp:include page="/pages/underwriting/distribution/distrCommon/distrPolicyInfoHeader.jsp"></jsp:include>
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
		   		<label>Distribution Group</label>
		   		<span class="refreshers" style="margin-top: 0;">
		   			<label name="gro" style="margin-left: 5px;">Hide</label>
		   		</span>
		   	</div>
		</div>
		<div id="giuwwPerildsTableGridSectionDiv" class="sectionDiv" style="height: 350px;" changeTagAttr="true">
			<div id="giuwwPerildsTableGridDiv" style="padding: 10px; height: 250px;"></div>
			<div class="buttonsDiv" align="center">
				<input type="button" id="btnCreateItems" name="btnCreateItems"  style="width: 115px;" class="button hover"   value="Create Items" />
				<input type="button" id="btnNewGrp"    	 name="btnNewGrp"    	style="width: 90px;" class="button hover"   value="New Group" />
				<input type="button" id="btnJoinGrp"     name="btnJoinGrp"    	style="width: 90px;" class="button hover"   value="Join Group" />
				<input type="button" id="btnSave"    	 name="btnSave"    		style="width: 90px;" class="button hover"   value="Save" />
				<input type="button" id="btnCancel"      name="btnCancel"    	style="width: 90px;" class="button hover"   value="Cancel" />
				<input type="hidden" id="btnSwitch"		 name ="btnSwitch"		value=""/> 
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
	initializeAccordion();
	changeTag = 0;
	objGIPIPolbasicPolDistV1 = null;
	loadGIUWWPerildsTableListing();
	observeReloadForm("reloadForm", showSetUpGroupsForDistPeril);
	observeReloadForm("gipiPolbasicPolDistV1ListingQuery", showSetUpGroupsForDistPeril);
	// added by jhing 12.05.2014
	newGroupTag = 0; 
	joinGroupTag = 0 ; 
	changedCheckedTag = 0 ; 
	function showGIPIPolbasicPolDistV1LOV(){
		if($F("txtPolLineCd").trim() == ""){
			showWaitingMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, function(){
				$("txtPolLineCd").focus();
			});
			return;
		}
		
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getGIPIPolbasicPolDistV1List2",
							moduleId : "GIUWS018",
							lineCd : $F("txtPolLineCd"),
							sublineCd : $F("txtPolSublineCd"),
							issCd : $F("txtPolIssCd"),
							issueYy : $F("txtPolIssueYy"),
							polSeqNo : $F("txtPolPolSeqNo"),
							renewNo : $F("txtPolRenewNo"),
  			                page : 1},
			title: "Policy Listing",
			width: 910,
			height: 400,
			hideColumnChildTitle: true,
			filterVersion: "2",
			columnModel: [
							{	id: 'lineCd',
								title: 'Line Code',
								width: '0',
								filterOption: true,
								visible: false
							},
							{	id: 'sublineCd',
								title: 'Subline Code',
								width: '0',
								filterOption: true,
								visible: false
							},
							{	id: 'issCd',
								title: 'Issue Code',
								width: '0',
								filterOption: true,
								visible: false
							},
							{	id: 'issueYy',
								width: '0',
								title: 'Issue Year',
								visible: false,
								filterOption: true,
								filterOptionType: 'integerNoNegative'
							},
							{	id: 'polSeqNo',
								width: '0',
								title: 'Pol. Seq No.',
								visible: false,
								filterOption: true,
								filterOptionType: 'integerNoNegative'
							},
							{	id: 'renewNo',
								width: '0',
								title: 'Renew No.',
								visible: false,
								filterOption: true,
								filterOptionType: 'integerNoNegative'
							},
							{	id: 'endtIssCd',
								width: '0',
								title: 'Endt Iss Code',
								visible: false,
								filterOption: true
							},
							{	id: 'endtYy',
								width: '0',
								title: 'Endt. Year',
								visible: false,
								filterOption: true,
								filterOptionType: 'integerNoNegative'
							},
							{	id: 'endtSeqNo',
								width: '0',
								title: 'Endt Seq No.',
								visible: false,
								filterOption: true,
								filterOptionType: 'integerNoNegative'
							},
							{	id: 'distNo',
								width: '0',
								title: 'Dist. No.',
								visible: false,
								filterOption: true,
								filterOptionType: 'integerNoNegative'
							},
							{ 	id: 'policyNo',
								title : 'Policy No.',
								width : '180px'
							},
							{	id: 'assdName',
								title: 'Assured Name',
								width: '280px',
								filterOption: true
							},
							{ 	id: 'endtNo',
								title : 'Endt No.',
								width : '180px'
							},
							{ 	id: 'distNo',
								title : 'Dist No.',
								width : '75px'
							},
							{ 	id: 'meanDistFlag',
								title : 'Dist. Status',
								width : '149px'
							},	
						],
						draggable: true,
				  		onSelect: function(row){
							 if(row != undefined) {
								 	objGIPIPolbasicPolDistV1 = row;
									populateDistrPolicyInfoFields(row);
									loadGIUWWPerildsTableListing();
							 }
				  		}
					});
	} 	
	
	$("gipiPolbasicPolDistV1ListingExit").observe("click", function(){
		giuwwPerildsTableGrid.keys.removeFocus(giuwwPerildsTableGrid.keys._nCurrentFocus, true);
		giuwwPerildsTableGrid.keys.releaseKeys();
		checkChangeTagBeforeUWMain();
	});
	
	$("btnCancel").observe("click", function(){ //added by steven 11/29/2012 base on SR 0011565
		giuwwPerildsTableGrid.keys.removeFocus(giuwwPerildsTableGrid.keys._nCurrentFocus, true);
		giuwwPerildsTableGrid.keys.releaseKeys();
		checkChangeTagBeforeUWMain();
	});
	
	$("hrefPolicyNo").observe("click", function(){
		//showPolbasicPolDistV1Listing();
		showGIPIPolbasicPolDistV1LOV(); // andrew - 12.5.2012
	});	
	
	$("btnCreateItems").observe("click", function(){	
		
		//added edgar 09/11/2014
		new Ajax.Request(contextPath+"/GIUWPolDistFinalController", {
			method: "POST",
			parameters: {
				action:			"checkPostedBinder",
				distNo : 		objGIPIPolbasicPolDistV1.distNo,
				policyId : 		objGIPIPolbasicPolDistV1.policyId
			},
			onCreate: function(){
				showNotice("Checking for posted binders...");
			},
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					var comp = JSON.parse(response.responseText);
					if (comp.vAlert != null){
						showMessageBox(comp.vAlert, imgMessage.ERROR);	
					}else{
						compareGIPIItemItmperilGIUWS018();
					}
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
		//compareGIPIItemItmperilGIUWS018();//edgar 09/11/2014
	});

	$("btnNewGrp").observe("click", function(){
		
		try {
			//added edgar 09/11/2014
			new Ajax.Request(contextPath+"/GIUWPolDistFinalController", {
				method: "POST",
				parameters: {
					// action:			"checkPostedBinder", // replaced by jhing 12.05.2014 for batch soln to FULLWEB SIT SR0003785, SR0003784, SR0003783, SR0003721, SR0003712, SR0003451, SR0003720, SR0002871
				    action :        "validateSetupDistPerAction" , // jhing 12.05.2014 this action does multiple validations on the backend
					distNo : 		objGIPIPolbasicPolDistV1.distNo,
					policyId : 		objGIPIPolbasicPolDistV1.policyId,
					selectedAction: "NEW_GROUP",
					moduleId:		"GIUWS018"
				},
				onCreate: function(){
					//showNotice("Checking for posted binders..."); // commented out by jhing 12.11.2014
					showNotice("Validating distribution record..."); // jhing 12.11.2014
				},
				onComplete: function(response){
					hideNotice();
					
					// jhing 12.11.2014 commented out 
					/* if(checkErrorOnResponse(response)){
						var comp = JSON.parse(response.responseText);
						if (comp.vAlert != null){
							showMessageBox(comp.vAlert, imgMessage.ERROR);	
						}else{
							$("btnSwitch").value = "N" ; // N for new group
							checkAttachedPeril(giuwwPerildsTableGrid);
						}
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
					} */
					
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response) ){ // jhing 12.05.2014 added checkCustomErrorOnResponse
						$("btnSwitch").value = "N" ; // N for new group
						checkAttachedPeril(giuwwPerildsTableGrid);					}
					
				}
			});
			//$("btnSwitch").value = "N" ; // N for new group //edgar 09/11/2014
			//checkAttachedPeril(giuwwPerildsTableGrid); //edgar 09/11/2014
			
		} catch (e) {
			showErrorMessage("valNewGroup", e);
		}		
		
	});

	$("btnJoinGrp").observe("click", function(){

		try {
			//added edgar 09/11/2014
			new Ajax.Request(contextPath+"/GIUWPolDistFinalController", {
				method: "POST",
				parameters: {
					//action:			"checkPostedBinder",  // jhing 12.11.2014 commented out
					action :        "validateSetupDistPerAction" , // jhing 12.11.2014 this action does multiple validations backend 
					distNo : 		objGIPIPolbasicPolDistV1.distNo,
					policyId : 		objGIPIPolbasicPolDistV1.policyId,
					selectedAction: "JOIN_GROUP",
					moduleId:		"GIUWS018" 
				},
				onCreate: function(){
					//showNotice("Checking for posted binders..."); // jhing 12.11.2014 commented out 
					showNotice("Validating distribution record..."); // jhing 12.11.2014
				},
				onComplete: function(response){
					hideNotice();
					
					// jhing 12.11.2014 commented out and replaced codes
					/* if(checkErrorOnResponse(response)){
						var comp = JSON.parse(response.responseText);
						if (comp.vAlert != null){
							showMessageBox(comp.vAlert, imgMessage.ERROR);	
						}else{
							$("btnSwitch").value = "J" ;// J for join group
							checkAttachedPeril(giuwwPerildsTableGrid);
						}
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
					} */ 
					
					// jhing 12.11.2014 added code
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						$("btnSwitch").value = "J" ;// J for join group
						checkAttachedPeril(giuwwPerildsTableGrid);
					}			
				}
			});
			//$("btnSwitch").value = "J" ;// J for join group //edgar 09/11/2014
			//checkAttachedPeril(giuwwPerildsTableGrid); //edgar 09/11/2014			
		} catch (e) {
			showErrorMessage("valJoinGroup", e);
		}		

	});

	$("btnSave").observe("click", function(){

		var obj = (giuwwPerildsTableGrid.geniisysRows).filter(function(obj){ return obj.distSeqNo != obj.origDistSeqNo;});
		if(changeTag == 0 || obj.length == 0){
			showMessageBox(objCommonMessage.NO_CHANGES, imgMessage.INFO);
		}else{
			showConfirmBox("Confirmation", "All data associated with this distribution record will be recreated. " +
				    "Are you sure you want to continue?", "Yes", "No", saveSetUpDistFinalPeril, "");
		}
	});


	function saveSetUpDistFinalPeril(){		
		try {
			var obj = (giuwwPerildsTableGrid.geniisysRows).filter(function(obj){ return obj.distSeqNo != obj.origDistSeqNo;});
			var modifiedRows = getModifiedJSONObjects(obj);
			var setRows 	 = giuwwPerildsTableGrid.geniisysRows;
			var distNo		 = objGIPIPolbasicPolDistV1.distNo;
			var policyId	 = objGIPIPolbasicPolDistV1.policyId;
			var lineCd	   	 = objGIPIPolbasicPolDistV1.lineCd == null ? "" : unescapeHTML2(objGIPIPolbasicPolDistV1.lineCd);
			var sublineCd	 = objGIPIPolbasicPolDistV1.sublineCd == null ? "" : unescapeHTML2(objGIPIPolbasicPolDistV1.sublineCd);
			var issCd		 = objGIPIPolbasicPolDistV1.issCd == null ? "" : unescapeHTML2(objGIPIPolbasicPolDistV1.issCd);
			var packPolFlag	 = objGIPIPolbasicPolDistV1.packPolFlag == null ? "" : unescapeHTML2(objGIPIPolbasicPolDistV1.packPolFlag);
			if(modifiedRows.length > 0){
				new Ajax.Request(contextPath+"/GIUWPolDistFinalController", {
					method: "POST",
					parameters: {
						action:			"saveSetUpPerilGrpDistFinal",
						distNo : 		distNo,
						policyId : 		policyId,
						lineCd:			lineCd,
						sublineCd:		sublineCd,
						issCd:			issCd,
						packPolFlag : 	packPolFlag,
						//setRows:		prepareJsonAsParameter(setRows) // commented out by jhing 12.05.2014
						setRows: prepareJsonAsParameter(modifiedRows) // jhing 12.05.2014
					},
					onCreate: function(){
						showNotice("Saving Set-up Peril Groups Distribution ...");
					},
					onComplete: function(response){
						hideNotice();
						if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response) ){
							if(response.responseText == "SUCCESS"){
								showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
								changeTag = 0;
								objGIPIPolbasicPolDistV1.distFlag = "1";
								objGIPIPolbasicPolDistV1.meanDistFlag = "Undistributed";
								populateDistrPolicyInfoFields(objGIPIPolbasicPolDistV1);
								// added by jhing 12.05.2014
								newGroupTag = 0 ; 
								joinGroupTag = 0 ; 
								changedCheckedTag = 0 ; 
							}
							loadGIUWWPerildsTableListing();
						}else{
							showMessageBox(response.responseText, imgMessage.ERROR);
						}
					}
				});
			}	
		} catch (e) {
			showErrorMessage("saveSetUpDistFinalPeril", e);
		}		
	}

	initializeChangeTagBehavior(saveSetUpDistFinalPeril);
	$("txtPolLineCd").focus(); // andrew - 12.5.2012
</script>