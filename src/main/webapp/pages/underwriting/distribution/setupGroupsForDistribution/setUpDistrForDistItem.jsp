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
		<div id="giuwWitemdsTableGridSectionDiv" class="sectionDiv" style="height: 350px;" changeTagAttr="true">
			<div id="giuwWItemdsTableGridDiv" style="padding: 20px 10px; height: 250px;">
				
			</div>
			<div class="buttonsDiv" align="center">
				<input type="button" id="btnCreateItems" name="btnCreateItems"  style="width: 100px;" class="disabledButton hover"   value="Recreate Items" enValue="Recreate Items"/>
				<input type="button" id="btnNewGrp"    	 name="btnNewGrp"    	style="width: 100px;" class="disabledButton hover"   value="New Group" 		enValue="New Group" />
				<input type="button" id="btnJoinGrp"     name="btnJoinGrp"    	style="width: 100px;" class="disabledButton hover"   value="Join Group" 	enValue="Join Group" />
				<input type="button" id="btnSave"    	 name="btnSave"    		style="width: 90px;" class="button hover"   value="Save"   enValue="Save"/>
				<input type="button" id="btnCancel"      name="btnCancel"    	style="width: 90px;" class="button hover"   value="Cancel" enValue="Cancel"/>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
	changeTag = 0;
	initializeAccordion();
	// added by jhing 12.05.2014
	newGroupTag = 0; 
	joinGroupTag = 0 ; 
	changedCheckedTag = 0 ; 

	objGIPIPolbasicPolDistV1 = null;
	loadGIUWWitemdsTableListing();

	observeReloadForm("reloadForm", showSetUpGroupsForDistPage);
	observeReloadForm("gipiPolbasicPolDistV1ListingQuery", showSetUpGroupsForDistPage); // andrew - 12.5.2012	
	observeCancelForm("btnCancel", saveSetUpDistrFinalItem, exitSetUpDistrFinalItem);

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
							moduleId : "GIUWS010",
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
									loadGIUWWitemdsTableListing();
							 }
				  		}
					});
	} 
	
	$("hrefPolicyNo").observe("click", function(){
		var obj = (giuwWitemdsTableGrid.geniisysRows).filter(function(obj){ return obj.distSeqNo != obj.origDistSeqNo;});
		if(changeTag == 1 && obj.length > 0){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No","Cancel", saveSetUpDistrFinalItem, 
				function(){
					changeTag = 0;
					showGIPIPolbasicPolDistV1LOV(); // andrew - 12.5.2012
					//showPolbasicPolDistV1Listing();
				},
				"");
		}else{
			showGIPIPolbasicPolDistV1LOV();  // andrew - 12.5.2012
			//showPolbasicPolDistV1Listing();
		}
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
						if(objGIPIPolbasicPolDistV1 != null){
							compareGIPIItemItmperilGIUWS010();
							// added by jhing 12.05.2014
							newGroupTag = 0; 
							joinGroupTag = 0 ; 
							changedCheckedTag = 0 ;
						}
					}
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
		//if(objGIPIPolbasicPolDistV1 != null){
		//	compareGIPIItemItmperilGIUWS010();
		//} //commented out edgar 09/11/2014
	});	

	$("btnNewGrp").observe("click", function(){		
		try {  // jhing 12.05.2014 added exception handling
			//added edgar 09/11/2014
			new Ajax.Request(contextPath+"/GIUWPolDistFinalController", {
				method: "POST",
				parameters: {
					//action:			"checkPostedBinder",  // replaced by jhing 12.05.2014 for batch soln to FULLWEB SIT SR0003785, SR0003784, SR0003783, SR0003721, SR0003712, SR0003451, SR0003720, SR0002871
				    action :        "validateSetupDistPerAction" , // jhing 12.05.2014 this action does multiple validations on the backend
					distNo : 		objGIPIPolbasicPolDistV1.distNo,
					policyId : 		objGIPIPolbasicPolDistV1.policyId,
					selectedAction: "NEW_GROUP",
					moduleId:		"GIUWS010"
				},
				onCreate: function(){
					//showNotice("Checking for posted binders..."); // commented out by jhing 12.05.2014
					showNotice("Validating distribution record..."); // jhing 12.05.2014
				},
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response) ){ // jhing 12.05.2014 added checkCustomErrorOnResponse
						//var comp = JSON.parse(response.responseText); // jhing 12.05.2014 commented out
						///if (comp.vAlert != null){
						//	showMessageBox(comp.vAlert, imgMessage.ERROR);	
						//}else{
							//includeToNewGrpDistr(giuwWitemdsTableGrid); // jhing 12.05.2014 replaced called function
							includeToNewGrpDistr2(giuwWitemdsTableGrid); // jhing 12.05.2014 new function
						//}
					//}else{
					//	showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		  } catch(e){
			showErrorMessage("valNewGroup", e);
		}

		//includeToNewGrpDistr(giuwWitemdsTableGrid); //ended edgar 09/11/2014
	});

	$("btnJoinGrp").observe("click", function(){
		try {
			// added by jhing 12.05.2014 
			if (giuwWitemdsTableGrid.geniisysRows.length > 0 ) {			
				var len = giuwWitemdsTableGrid.geniisysRows.length;
				fromNum = giuwWitemdsTableGrid.geniisysRows[0 ].rowNum;	
				toNum = giuwWitemdsTableGrid.geniisysRows[len - 1 ].rowNum;
			}	
			else{
				fromNum = fromRowNum ;
				toNum = toRowNum ; 
			}		
			//added edgar 09/11/2014
			new Ajax.Request(contextPath+"/GIUWPolDistFinalController", {
				method: "POST",
				parameters: {
					//action:			"checkPostedBinder", // commented out by jhing 12.05.2014 for batch soln to FULLWEB SIT SR0003785, SR0003784, SR0003783, SR0003721, SR0003712, SR0003451, SR0003720, SR0002871
					action :        "validateSetupDistPerAction" , // jhing 12.05.2014 this action does multiple validations backend 
					distNo : 		objGIPIPolbasicPolDistV1.distNo,
					policyId : 		objGIPIPolbasicPolDistV1.policyId,
					selectedAction: "JOIN_GROUP",
					moduleId:		"GIUWS010" 
				},
				evalscripts: true, 
				asynchronous: false,		// jhing 12.05.2014	
				onCreate: function(){
					//showNotice("Checking for posted binders..."); // commented out jhing 12.05.2014
					showNotice("Validating distribution record..."); // jhing 12.05.2014
				},
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						// jhing 12.05.2014 commented out codes related to use of checkPostedBinder
						//var comp = JSON.parse(response.responseText); 
						//if (comp.vAlert != null){
						//	showMessageBox(comp.vAlert, imgMessage.ERROR);	
						//}else{ //ended edgar 09/11/2014
							getDistGrpsOthPage ( fromNum, toNum ) ; // jhing 12.05.2014 new function to retrieve and populate distribution groups
							/* var objArray = [];
							var rows = giuwWitemdsTableGrid.geniisysRows;
							var checkedItem = giuwWitemdsTableGrid.getModifiedRows();	// shan 08.06.2014
							var groupItemGrp = checkedItem.filter(function(obj){return obj.groupTag == true;})[0].itemGrp;	// shan 08.06.2014
							
							for(var i=0; i<rows.length; i++){
								if (rows[i].itemGrp == groupItemGrp){	// added condition to show item groups with same bill group: shan 08.06.2014
									var distSeqNo = rows[i].distSeqNo;
									if (objArray.toString().indexOf(distSeqNo) == -1) objArray.push(distSeqNo);
								}
							} */
							showDistrGrpLOV("GIUWS010-Join", "Join Group?", objArray.sort(), 340, giuwWitemdsTableGrid); 
						//}
					//}else{//added edgar 09/11/2014
					//	showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});		//ended edgar 09/11/2014			
		} catch (e) {
			showErrorMessage("valJoinGroup", e);
		}
		
	});

	$("btnSave").observe("click", function(){
		var obj = (giuwWitemdsTableGrid.geniisysRows).filter(function(obj){ return obj.distSeqNo != obj.origDistSeqNo;});
		if(changeTag == 0 || obj.length == 0){
			showMessageBox(objCommonMessage.NO_CHANGES, imgMessage.INFO);
		}else{
			showConfirmBox("Confirmation", "All data associated with this distribution record will be recreated. " +
				    "Are you sure you want to continue?", "Yes", "No", saveSetUpDistrFinalItem, "");
		}
	});

	$("gipiPolbasicPolDistV1ListingExit").observe("click", function(){
		if(changeTag == 0){
			exitSetUpDistrFinalItem();
		}else{
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No","Cancel", saveSetUpDistrFinalItem, exitSetUpDistrFinalItem, "");
		}
	});

	function exitSetUpDistrFinalItem(){
		giuwWitemdsTableGrid.keys.removeFocus(giuwWitemdsTableGrid.keys._nCurrentFocus, true);
		giuwWitemdsTableGrid.keys.releaseKeys();
		objGIPIPolbasicPolDistV1 = null;
		changeTag = 0;
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}

	function saveSetUpDistrFinalItem(){
		
		try {
			var obj = (giuwWitemdsTableGrid.geniisysRows).filter(function(obj){ return obj.distSeqNo != obj.origDistSeqNo;});
			var modifiedRows = getModifiedJSONObjects(obj);
			var setRows = giuwWitemdsTableGrid.geniisysRows;
			var distNo = objGIPIPolbasicPolDistV1.distNo;
			var policyId = objGIPIPolbasicPolDistV1.policyId;
			var lineCd	= objGIPIPolbasicPolDistV1.lineCd == null ? "" : unescapeHTML2(objGIPIPolbasicPolDistV1.lineCd);
			var sublineCd	= objGIPIPolbasicPolDistV1.sublineCd == null ? "" : unescapeHTML2(objGIPIPolbasicPolDistV1.sublineCd);
			var issCd	= objGIPIPolbasicPolDistV1.issCd == null ? "" : unescapeHTML2(objGIPIPolbasicPolDistV1.issCd);
			var packPolFlag	= objGIPIPolbasicPolDistV1.packPolFlag == null ? "" : unescapeHTML2(objGIPIPolbasicPolDistV1.packPolFlag);

			if(modifiedRows.length > 0){
				new Ajax.Request(contextPath+"/GIUWPolDistFinalController", {
					method: "POST",
					parameters: {
						action:			"saveSetUpGroupsForDistrFinalItem",
						distNo : 		distNo,
						policyId : 		policyId,
						lineCd:			lineCd,
						sublineCd:		sublineCd,
						issCd:			issCd,
						packPolFlag : 	packPolFlag,
						//setRows:		prepareJsonAsParameter(setRows) // commented out by jhing 12.05.2014 original code
						setRows : 		prepareJsonAsParameter(modifiedRows) // jhing 12.05.2014
					},
					onCreate: function(){
						showNotice("Saving Set-up Groups Distribution (Item)...");
					},
					onComplete: function(response){
						hideNotice();
						if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
							if(response.responseText == "SUCCESS"){
								showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
								changeTag = 0;
								objGIPIPolbasicPolDistV1.distFlag = "1";
								objGIPIPolbasicPolDistV1.meanDistFlag = "Undistributed";
								populateDistrPolicyInfoFields(objGIPIPolbasicPolDistV1);
							}
							loadGIUWWitemdsTableListing();
							// added by jhing 12.05.2014 
							newGroupTag = 0; 
							joinGroupTag = 0 ;  
							changedCheckedTag = 0 ; 
						}else{
							showMessageBox(response.responseText, imgMessage.ERROR);
						}
					}
				});				
			}				
		} catch (e) {
			showErrorMessage("saveSetUpDistrFinalItem", e);
		}
	}

	// created by jhing 12.05.2014 for batch soln to FULLWEB SIT SR0003785, SR0003784, SR0003783, SR0003721, SR0003712, SR0003451, SR0003720, SR0002871
	function getDistGrpsOthPage (fromPage , toPage){     
		var distNo = objGIPIPolbasicPolDistV1.distNo;
		var policyId = objGIPIPolbasicPolDistV1.policyId;		
		new Ajax.Request(contextPath+"/GIUWWitemdsController", {
				method: "POST",
				parameters: {
					action:			"getGIUWWitemdsDistGrps",
					distNo : 		distNo,
					policyId : 		policyId,
					from	 :		fromPage,
					to		 :	    toPage
				},
				evalscripts: true,
				asynchronous: false,
				onCreate: function(){
					showNotice("Retrieving Item Distribution Groups...");
				},
				onComplete: function(response){
					hideNotice();

					 if(checkErrorOnResponse(response)){
						var distGrps = JSON.parse(response.responseText);
						var objArray = [];
						var rows = giuwWitemdsTableGrid.geniisysRows;
						var checkedItem = giuwWitemdsTableGrid.getModifiedRows();	
						var groupItemGrp = checkedItem.filter(function(obj){return obj.groupTag == true;})[0].itemGrp;	
						
						for(var i=0; i<rows.length; i++){
							if (rows[i].itemGrp == groupItemGrp){	
								var distSeqNo = rows[i].distSeqNo;
								if (objArray.toString().indexOf(distSeqNo) == -1) objArray.push(distSeqNo);
							}
						}
						
						//push the other groups from other page
						for(var i=0; i<distGrps.length; i++){
							if (distGrps[i].itemGrp == groupItemGrp){	
								var distSeqNo = distGrps[i].distSeqNo;
								if (objArray.toString().indexOf(distSeqNo) == -1) objArray.push(distSeqNo);
							}
						}
						showDistrGrpLOV("GIUWS010-Join", "Join Group?", objArray.sort(), 340, giuwWitemdsTableGrid);
						
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
					} 

				}
			});			

	}	

	
	
	initializeChangeTagBehavior(saveSetUpDistrFinalItem);
	$("txtPolLineCd").focus(); // andrew - 12.5.2012
</script>