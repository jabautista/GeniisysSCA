<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>

<div id="negPostedDistMainDiv" name="negPostedDistMainDiv" style="margin-top: 1px;">
	<div id="negPostedDistMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="negPostedDistQuery">Query</a></li>
					<li><a id="negPostedDistExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<form id="negPostedDistForm" name="negPostedDistForm">
		<jsp:include page="/pages/underwriting/distribution/distrCommon/distrPolicyInfoHeader.jsp"></jsp:include>
		<input type="button" id="dummyShowListing" value="hiddenTrigger" style="display: none;"/>
		<div id="distGroupMainDiv">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
			   		<label>Distribution Group</label>
			   		<span class="refreshers" style="margin-top: 0;">
			   			<label id="showDistGroup" name="gro" style="margin-left: 5px;">Hide</label>
			   		</span>
			   	</div>
			</div>
			<div id="distGroupMain" class="sectionDiv" style="border: 0px;">	
				<div id="distGroup1Div" class="sectionDiv" style="display: block;">
					<div id="distListingTableDiv" style="width: 800px; margin:auto; margin-top:10px; margin-bottom:10px;">
						<div class="tableHeader">
							<label style="width: 20%; text-align: right; margin-right: 15px;">Distribution No.</label>
							<label style="width: 35%; text-align: left; margin-right: 5px;">Distribution Status</label>
							<label style="width: 35%; text-align: left; ">Multi Booking Date</label>
						</div>
						<div id="distListingDiv" name="distListingDiv" class="tableContainer">
								
						</div>
					</div>	
				</div>
				<div id="distGroup2Div" class="sectionDiv" style="display: block;">
					<div id="distGroupListingTableDiv" style="width: 800px; margin:auto; margin-top:10px;">
						<div class="tableHeader">
							<label style="width: 12%; text-align: right; margin-right: 5px;">Group No.</label>
							<label style="width: 30%; text-align: right; margin-right: 5px;">Group TSI</label>
							<label style="width: 30%; text-align: right; margin-right: 10px;">Group Premium</label>
							<label style="width: 25%; text-align: left; ">Currency</label>
						</div>
						<div id="distGroupListingDiv" name="distGroupListingDiv" class="tableContainer">
								
						</div>
					</div>
					<table align="center" border="0" style="margin-top: 10px; margin-bottom: 10px;">
						<tr>
							<td class="rightAligned">Group No.</td>
							<td class="leftAligned">
								<input class="rightAligned" type="text" id="txtDistSeqNo" name="txtDistSeqNo" value="" style="width:90px;" readonly="readonly"/>
							</td>
							<td class="rightAligned" style="width: 85px;">Group TSI</td>
							<td class="leftAligned">
								<input type="text" id="txtTsiAmt" name="txtTsiAmt" value="" style="width:180px;" readonly="readonly" class="money"/>
							</td>
							<td class="rightAligned" style="width: 120px;">Group Premium</td>
							<td class="leftAligned">
								<input type="text" id="txtPremAmt" name="txtPremAmt" value="" style="width:180px;" readonly="readonly" class="money"/>
							</td>
						</tr>
						<tr>
							<td class="rightAligned" colspan="6">
								<label id="lblCurrency" style="float:right; font-weight:bolder; text-transform:uppercase;">
								</label>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</div>

		<div id="distShareMainDiv">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
			   		<label>Distribution Share</label>
			   		<span class="refreshers" style="margin-top: 0;">
			   			<label id="showDistShare" name="gro" style="margin-left: 5px;">Hide</label>
			   		</span>
			   	</div>
			</div>					
			<div id="distShareDiv" class="sectionDiv" style="display: block;">
				<div id="distShareListingTableDiv" style="width:100%; padding-bottom:5px;">
					<div class="tableHeader" style="margin:10px; margin-bottom:0px;">
						<label style="width: 25%; text-align: left; margin-right: 3px;">Share</label>
						<label style="width: 25%; text-align: right; margin-right: 5px;">% Share</label>
						<label style="width: 24%; text-align: right; margin-right: 5px;">Sum Insured</label>
						<label style="width: 24%; text-align: right; ">Premium</label>
					</div>
					<div id="distShareListingDiv" name="distShareListingDiv" style="margin:10px; margin-top:0px;" class="tableContainer">
							
					</div>
				</div>
				<div id="distShareTotalAmtMainDiv" class="tableHeader" style="margin:10px; margin-top:0px; display:block;">
					<div id="distShareTotalAmtDiv" style="width:100%;">
						<label style="text-align:left; width:25%; margin-right: 3px; float:left;">Total:</label>
						<label id="lblTotalShare" style="text-align:right; width:25%; margin-right: 5px; float:left;" class="money">&nbsp;</label>
						<label id="lblTotalTsiAmt" style="text-align:right; width:24%; margin-right: 5px; float:left;" class="money">&nbsp;</label>
						<label id="lblTotalPremAmt" style="text-align:right; width:24%; float:left;" class="money">&nbsp;</label>
					</div>
				</div>
			</div>
		</div>
		<div class="buttonsDiv">
			<input type="button" id="btnNegDist"		name="btnNegDist"		class="button"	value="Negate Distribution" />
			</div>
	</form>
</div>	

<script>
try{
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	disableButton("btnNegDist");

	function showGIUTS002PolbasicPolDistV1LOV(){
		if($F("txtPolLineCd").trim() == ""){
			showWaitingMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, function(){
				$("txtPolLineCd").focus();
			});
			return;
		}
		
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getGIUTS002PolicyListing",
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
								//filterOption: true,
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
									loadPostedDistribution();
							 }
				  		}
					});
	} 
	
	$("hrefPolicyNo").observe("click", function(){
		showGIUTS002PolbasicPolDistV1LOV(); // andrew - 11.29.2012 - changed the policy listing loading
		//showPolbasicPolDistV1Listing("getGIPIPolbasicPolDistV1ListForNegPostDist");
	});
	
	$("negPostedDistExit").observe("click", function(){
		checkChangeTagBeforeUWMain();
	});
	
	$("btnNegDist").observe("click", function(){
		var policyNo = $F("txtPolLineCd") +"-"+ $F("txtPolSublineCd") +"-"+ $F("txtPolIssCd") +"-"+ $F("txtPolIssueYy")+"-"+$F("txtPolPolSeqNo")+"-"+$F("txtPolRenewNo");
		showConfirmBox("Confirmation", 
			"Are you sure you want to negate the distribution record of Policy Number " + policyNo + " (Distribution No. " + $F("txtDistNo") +")?", 
			"Ok", "Cancel", /* checkExistingClaimGiuts002 */ preValidationNegDist, ""); //replaced by J. Diago 09.16.2014 : from checkExistingClaimGiuts002 to preValidation
	});
	
	function preValidationNegDist(){ //created by J. Diago 09.16.2014
		new Ajax.Request(contextPath + "/GIUWPolDistController", {
			parameters : {
				action : "preValidationNegDist",
				policyId : objGIPIPolbasicPolDistV1.policyId,
				distNo : $F("txtDistNo"),
			},
			onCreate : showNotice("Pre-Validation, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					checkExistingClaimGiuts002();
				}
			}
		});
	}

	// modified by J. Diago 09.15.2014 : Added options for override and others.
	function checkExistingClaimGiuts002(){
		try{
			new Ajax.Request(contextPath+"/GIUWPolDistController", {
				method: "POST",
				parameters: {action     	: "checkExistingClaimGiuts002",
										lineCd			:  objGIPIPolbasicPolDistV1.lineCd,
	                    				sublineCd		:  objGIPIPolbasicPolDistV1.sublineCd,
	                   				 	issCd         		:  objGIPIPolbasicPolDistV1.issCd,
	                    				issueYy      	:  objGIPIPolbasicPolDistV1.issueYy,
	                    				polSeqNo   	:  objGIPIPolbasicPolDistV1.polSeqNo,
	                    				renewNo    	:  objGIPIPolbasicPolDistV1.renewNo,
	                    				effDate      	:  dateFormat(objGIPIPolbasicPolDistV1.effDate, "MM-dd-yyyy"),
	                    				endtSeqNo 	:  objGIPIPolbasicPolDistV1.endtSeqNo},
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						if(response.responseText == ""){
							validateFaculPremPaytGIUTS002();
						}else {
							var message = "";
							/* showConfirmBox("Confirmation", response.responseText, 
									"Ok", "Cancel", negateDistribution, "");  Removed by J. Diago 09.15.2014 */
						    if(response.responseText.contains("Restrict")){
						    	showMessageBox("This policy has an existing claim(s), negation of distribution is not allowed.", imgMessage.ERROR);
						    } else if(response.responseText.contains("Override")){
						    	if(response.responseText.contains("W Endorsement")){
						    		message = "The policy for this endt. has an existing claim(s), please inform the Claims Department before negating this distribution. Do you want to continue?";
						    	} else {
						    		message = "This policy has an existing claim(s), please inform the Claims Department before negating this distribution. Do you want to continue?";
						    	}
						    	
						    	showConfirmBox("Confirmation", message, "Yes", "No", function(){askForOverride("claims","RB");},"");//enclosed askForOverride function inside anonymous function edgar 10/08/2014
						    } else {
						    	validateFaculPremPaytGIUTS002();
						    }
						}
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}					
			});
		}catch(e){
			showErrorMessage("checkExistingClaimGiuts002", e);
		}	
	}
	
	function askForOverride(fromValidation, funcCode){ //created by J. Diago 09.15.2014
		if (giacValidateUserFn(funcCode) == "FALSE") {
			var message = "";
			
			if(fromValidation == "claims"){
				message = "Cannot negate distribution of policy with claim(s).";	
			} else {
				message = "Cannot negate distribution of policy with FACULTATIVE PREMIUM PAYMENT(s).";
			}
			
			showConfirmBox("Confirmation", message + 
					" Would you like to override?","Yes","No", 
			   function(){
				override(funcCode, i, fromValidation);
			}, function(){
				return false;
			});
			
		} else {
			if(fromValidation == "claims"){
				validateFaculPremPaytGIUTS002();	
			} else{
				negateDistribution();
			}
		}
	}
	
	function giacValidateUserFn(funcCode){ //created by J. Diago 09.15.2014
		try{
			var isOk;
			new Ajax.Request(contextPath+"/SpoilageReinstatementController", {
				method: "POST",
				parameters: {action : "validateUserFunc",
					funcCode: funcCode,
					moduleName: "GIUTS002"},
				asynchronous: false,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						isOk = response.responseText;
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}					
			});
			return isOk;
		}catch(e){
			showErrorMessage("giacValidateUserFn", e);
		}
	}
	
	function override(funcCd,y,fromValidation){ //created by J. Diago 09.15.2014
		showGenericOverride(
				"GIUTS002",
				funcCd,
				function(ovr, userId, result){
					if(result == "FALSE"){
						showWaitingMessageBox("User " + userId + " is not allowed to process override.", imgMessage.ERROR, 
								function(){
									override(funcCd, i);
								}
						); 
					}else {
						if(result == "TRUE"){
							if(fromValidation == "claims"){
								validateFaculPremPaytGIUTS002();	
							}else {
								negateDistribution();
							}
						}
						ovr.close();
						delete ovr;
					}
				},
				""
		);
	}
	
	function validateFaculPremPaytGIUTS002(){ //created by J. Diago 09.15.2014
		try{
			new Ajax.Request(contextPath+"/GIUWPolDistController", {
				method: "POST",
				parameters: {
					action : "validateFaculPremPaytGIUTS002",
					distNo : $F("txtDistNo"),
               	    distSeqNo : $F("txtDistSeqNo"),
               	    lineCd : $F("txtPolDistV1LineCd"),
               	    endtSeqNo : objGIPIPolbasicPolDistV1.endtSeqNo,
				},
			    onComplete: function(response){
			    	if(checkErrorOnResponse(response)){
			    		if(response.responseText == ""){
			    			negateDistribution();
			    		} else {
			    			var message = "";
						    if(response.responseText.contains("Restrict")){
						    	showMessageBox("This policy has an existing FACULTATIVE PREMIUM  PAYMENT(s), negation of distribution is not allowed.", imgMessage.ERROR);
						    } else if(response.responseText.contains("Override")){
						    	if(response.responseText.contains("W Endorsement")){
						    		message = "The policy for this endt. has an existing FACULTATIVE PREMIUM PAYMENT(s), please inform the ACCOUNTING/FINANCE Department before negating this distribution. Do you want to continue?";
						    	} else {
						    		message = "This policy has an existing FACULTATIVE PREMIUM PAYMENT(s), please inform the ACCOUNTING/FINANCE Department before negating this distribution. Do you want to continue?";
						    	}
						    	
						    	showConfirmBox("Confirmation", message, "Yes", "No", function(){askForOverride("payment","RF");},"");//enclosed askForOverride function inside anonymous function edgar 10/08/2014
						    } else {
						    	negateDistribution();
						    }
			    		}
			    	} else {
			    		showMessageBox(response.responseText, imgMessage.ERROR);
			    	}
			    }
			});
		}catch(e){
			showErrorMessage("validateFaculPremPaytGIUTS002",e);
		}
	}
	
	function negateDistribution(){
		try{
			new Ajax.Request(contextPath+"/GIUWPolDistController", {
				method: "POST",
				parameters: {action 			 : "negDistGIUTS002",
										   policyId 			 : objGIPIPolbasicPolDistV1.policyId,
										   distNo 			 : $F("txtDistNo"),
										   lineCd 			 : $F("txtPolDistV1LineCd"),
										   parId 			     : objGIPIPolbasicPolDistV1.parId},
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var arr = response.responseText.split(",");
						var msg = arr[0];
						var workflowMsgr = arr[1];
						if(workflowMsgr != ""){
							showMessageBox(workflowMsgr, imgMessage.ERROR);
							return false;
						} else if(msg == ("Invalid user." || "Cannot generate a new distribution number, please contact your DBA.") ){
							showMessageBox(msg, imgMessage.ERROR);
							return false;
						} else {
							showWaitingMessageBox(msg, imgMessage.SUCCESS, function(){
								showConfirmBox("Distribution Negation","Would you like another transaction?","Ok","Cancel",showNegPostedDist,checkChangeTagBeforeUWMain);
							});
						}
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}					
			});
		}catch(e){
			showErrorMessage("negateDistribution", e);
		}	
	}
	
	$("dummyShowListing").observe("click", function(){	
		showList(objUW.hidObjGIUTS002.GIUWPolDist);
		loadMainListObserve();	
		enableButton("btnNegDist");
		disableEnableButtons();
		fireEvent($("distListingDiv").down("div", 0), "click");
		fireEvent($("distGroupListingDiv").down("div", 0), "click");
	});

	function showList(objArray){
		try{
			//Main
			for(var a=0; a<objArray.length; a++){
				var content = prepareList(objArray[a]);
				var newDiv = new Element("div");
				objArray[a].divCtrId = a;
				objArray[a].recordStatus = null;
				newDiv.setAttribute("id", "rowPrelimDist"+a);
				newDiv.setAttribute("name", "rowPrelimDist");
				newDiv.addClassName("tableRow");
				newDiv.update(content);
				$("distListingDiv").insert({bottom : newDiv});
				showListPerObj(objArray[a], a);
			}	
		}catch(e){
			showErrorMessage("showList", e);
		}	
	}

	function showListPerObj(obj,a){
		var tableContainer = $("distListingDiv");
		var tableGroupContainer = $("distGroupListingDiv");
		var tableShareContainer = $("distShareListingDiv");
		//Group
		for(var b=0; b<obj.giuwPolicyds.length; b++){
			var content = prepareList2(obj.giuwPolicyds[b]);
			var newDiv = new Element("div");
			//obj.giuwPolicyds[b].divCtrId = b;
			obj.giuwPolicyds[b].recordStatus = null;
			newDiv.setAttribute("id", "rowGroupDist"+obj.giuwPolicyds[b].distNo+""+obj.giuwPolicyds[b].distSeqNo);
			newDiv.setAttribute("name", "rowGroupDist");
			newDiv.setAttribute("distNo", obj.giuwPolicyds[b].distNo);
			newDiv.setAttribute("distSeqNo", obj.giuwPolicyds[b].distSeqNo);
			newDiv.addClassName("tableRow");
			newDiv.update(content);
			tableGroupContainer.insert({bottom : newDiv});
			//Share
			for(var c=0; c<obj.giuwPolicyds[b].giuwPolicydsDtl.length; c++){
				var content = prepareList3(obj.giuwPolicyds[b].giuwPolicydsDtl[c]);
				var newDiv = new Element("div");
				//obj.giuwPolicyds[b].giuwPolicydsDtl[c].divCtrId = c;
				obj.giuwPolicyds[b].giuwPolicydsDtl[c].recordStatus = null;
				newDiv.setAttribute("id", "rowShareDist"+obj.giuwPolicyds[b].giuwPolicydsDtl[c].distNo+""+obj.giuwPolicyds[b].giuwPolicydsDtl[c].distSeqNo+""+obj.giuwPolicyds[b].giuwPolicydsDtl[c].lineCd+""+obj.giuwPolicyds[b].giuwPolicydsDtl[c].shareCd);
				newDiv.setAttribute("name", "rowShareDist");
				newDiv.setAttribute("distNo", obj.giuwPolicyds[b].giuwPolicydsDtl[c].distNo);
				newDiv.setAttribute("distSeqNo", obj.giuwPolicyds[b].giuwPolicydsDtl[c].distSeqNo);
				newDiv.setAttribute("lineCd", obj.giuwPolicyds[b].giuwPolicydsDtl[c].lineCd);
				newDiv.setAttribute("shareCd", obj.giuwPolicyds[b].giuwPolicydsDtl[c].shareCd);
				newDiv.addClassName("tableRow");
				newDiv.update(content);
				tableShareContainer.insert({bottom : newDiv});
			}	
		}
	}	
	
	function loadMainListObserve(){
		$$("div#distListingDiv div[name=rowPrelimDist]").each(function(row){
			loadRowMouseOverMouseOutObserver(row);
			setClickObserverPerRow(row, 'distListingDiv', 'rowPrelimDist', 
					function(){
						var id = (row.readAttribute("id")).substring(row.readAttribute("name").length);
						for(var a=0; a<objUW.hidObjGIUTS002.GIUWPolDist.length; a++){
							if (objUW.hidObjGIUTS002.GIUWPolDist[a].divCtrId == id && objUW.hidObjGIUTS002.GIUWPolDist[a].recordStatus != -1){
								supplyDist(objUW.hidObjGIUTS002.GIUWPolDist[a]);
							}
						}
					}, 
					clearForm);
		});
		$$("div#distGroupListingDiv div[name=rowGroupDist]").each(function(row){
			loadRowMouseOverMouseOutObserver(row);
			setClickObserverPerRow(row, 'distGroupListingDiv', 'rowGroupDist', function(){supplyGroupDistPerRow(row);}, function(){supplyGroupDist(null);});
		});

		$$("div#distShareListingDiv div[name=rowShareDist]").each(function(row){
			loadRowMouseOverMouseOutObserver(row);
			setClickObserverPerRow(row, 'distShareListingDiv', 'rowShareDist', function(){supplyShareDistPerRow(row);}, clearShare);
		});
	}

	function supplyDist(obj){
		try{
			supplyGroupDist(null);
			objUW.hidObjGIUTS002.selectedGIUWPolDist 	= obj==null?{}:obj;
			//$("txtDistNo").value 					= nvl(obj==null?null:obj.distNo,'') == '' ? null :formatNumberDigits(obj.distNo,8);
			//$("txtDistFlag").value 				= nvl(obj==null?null:obj.distFlag,'');
			checkTableItemInfoAdditional("distGroupListingTableDiv","distGroupListingDiv","rowGroupDist","distNo",nvl(obj==null?null:obj.distNo,''));
			//checkTableItemInfoAdditional("distShareListingTableDiv","distShareListingDiv","rowShareDist","distNo",nvl(obj==null?null:obj.distNo,''),"distSeqNo",nvl(obj==null?null:obj.distSeqNo,'')); removed by jdiago 08.15.2014 : this causes the div to be hidden upon pressing okay button in lov.
		}catch(e){
			showErrorMessage("supplyDist", e);
		}
	}	
	
	function supplyGroupDist(obj){
		try{
			objUW.hidObjGIUTS002.selectedgiuwPolicyds	= obj==null?{}:obj;
			$("txtDistSeqNo").value 					= nvl(obj==null?null:obj.distSeqNo,'') == '' ? null :formatNumberDigits(obj.distSeqNo,5);
			$("txtTsiAmt").value 						= nvl(obj==null?null:obj.tsiAmt,'') == '' ? null :formatCurrency(obj.tsiAmt);
			$("txtPremAmt").value 						= nvl(obj==null?null:obj.premAmt,'') == '' ? null :formatCurrency(obj.premAmt);
			$("lblCurrency").innerHTML					= unescapeHTML2(nvl(obj==null?'&nbsp;':obj.currencyDesc,'&nbsp;'));
			supplyShareDist(null);
			computeTotalAmount($("txtDistSeqNo").value);
			checkTableItemInfoAdditional("distShareListingTableDiv","distShareListingDiv","rowShareDist","distNo",nvl(obj==null?null:obj.distNo,''),"distSeqNo",nvl(obj==null?null:obj.distSeqNo,''));
		}catch(e){
			showErrorMessage("supplyGroupDist", e);
		}
	}
	
	function supplyGroupDistPerRow(row){
		try{
			var id = (row.readAttribute("id")).substring(row.readAttribute("name").length);
			var distNo = row.readAttribute("distNo");
			var distSeqNo = row.readAttribute("distSeqNo");
			var objArray = objUW.hidObjGIUTS002.GIUWPolDist;
			for(var a=0; a<objArray.length; a++){
				if (objArray[a].recordStatus != -1){
					//Group
					for(var b=0; b<objArray[a].giuwPolicyds.length; b++){
						if (objArray[a].giuwPolicyds[b].distNo == distNo && objArray[a].giuwPolicyds[b].distSeqNo == distSeqNo && objArray[a].giuwPolicyds[b].recordStatus != -1){
							supplyGroupDist(objArray[a].giuwPolicyds[b]);
						}
					}
				}
			}
		}catch(e){
			showErrorMessage("supplyGroupDistPerRow", e);
		}	
	}
	
	function supplyShareDist(obj){
		try{
			objUW.hidObjGIUTS002.selectedgiuwPolicydsDtl	= obj==null?{}:obj;
			//$("txtDspTrtyName").value						= unescapeHTML2(nvl(obj==null?'':obj.dspTrtyName,''));
			//$("txtDistSpct").value							= nvl(obj==null?null:obj.distSpct,'') == '' ? null :formatToNthDecimal(obj.distSpct,14);
			//$("txtDistTsi").value							= nvl(obj==null?null:obj.distTsi,'') == '' ? null :formatCurrency(obj.distTsi);
			//$("txtDistPrem").value							= nvl(obj==null?null:obj.distPrem,'') == '' ? null :formatCurrency(obj.distPrem);
			if (obj != null){
				if (obj.recordStatus == 0){
				}
			}	
			computeTotalAmount($("txtDistSeqNo").value);
		}catch(e){
			showErrorMessage("supplyShareDist", e);
		}
	}
	
	function supplyShareDistPerRow(row){
		try{
			 var id = (row.readAttribute("id")).substring(row.readAttribute("name").length);
			var distNo = row.readAttribute("distNo");
			var distSeqNo = row.readAttribute("distSeqNo");
			var lineCd = row.readAttribute("lineCd");
			var shareCd = row.readAttribute("shareCd");
			var objArray = objUW.hidObjGIUTS002.GIUWPolDist;
			for(var a=0; a<objArray.length; a++){
				if (objArray[a].recordStatus != -1){
					//Group
					for(var b=0; b<objArray[a].giuwPolicyds.length; b++){
						if (objArray[a].giuwPolicyds[b].distNo == distNo && objArray[a].giuwPolicyds[b].distSeqNo == distSeqNo && objArray[a].giuwPolicyds[b].recordStatus != -1){
							//Share
							for(var c=0; c<objArray[a].giuwPolicyds[b].giuwPolicydsDtl.length; c++){
								if (objArray[a].giuwPolicyds[b].giuwPolicydsDtl[c].distNo == distNo 
										&& objArray[a].giuwPolicyds[b].giuwPolicydsDtl[c].distSeqNo == distSeqNo 
										&& objArray[a].giuwPolicyds[b].giuwPolicydsDtl[c].lineCd == lineCd 
										&& objArray[a].giuwPolicyds[b].giuwPolicydsDtl[c].shareCd == shareCd 
										&& objArray[a].giuwPolicyds[b].giuwPolicydsDtl[c].recordStatus != -1){
									supplyShareDist(objArray[a].giuwPolicyds[b].giuwPolicydsDtl[c]);
								}	
							}	
						}
					}
				}
			}
		}catch(e){
			showErrorMessage("supplyShareDistPerRow", e);
		}
	}	
	
	function clearShare(){
		try{
			supplyShareDist(null);
			deselectRows("distShareListingDiv", "rowShareDist");
			checkTableItemInfoAdditional("distShareListingTableDiv","distShareListingDiv","rowShareDist","distNo",Number($("txtDistNo").value),"distSeqNo",Number($("txtDistSeqNo").value));
		}catch(e){
			showErrorMessage("clearShare", e);
		}
	}
	
	function computeTotalAmount(distSeqNo){
		try{
			var sumDistSpct = 0;
			var sumDistTsi = 0;
			var sumDistPrem = 0;
			var distSeqNo = nvl(distSeqNo,'')==''?'':Number(distSeqNo);
			var ctr = 0;
			var objArray = objUW.hidObjGIUTS002.GIUWPolDist;
			var currGrp = {};
			for(var a=0; a<objArray.length; a++){
				if (objArray[a].recordStatus != -1 && objArray[a].distNo == Number($F("txtDistNo"))){
					//Group
					for(var b=0; b<objArray[a].giuwPolicyds.length; b++){
						if (objArray[a].giuwPolicyds[b].distSeqNo == distSeqNo && objArray[a].giuwPolicyds[b].recordStatus != -1){
							//Share
							currGrp = objArray[a].giuwPolicyds[b];
							currGrp.currDistNoIndex = a;
							for(var c=0; c<objArray[a].giuwPolicyds[b].giuwPolicydsDtl.length; c++){
								if (objArray[a].giuwPolicyds[b].giuwPolicydsDtl[c].recordStatus != -1){
									ctr++;
									sumDistSpct = parseFloat(sumDistSpct) + parseFloat(nvl(objArray[a].giuwPolicyds[b].giuwPolicydsDtl[c].distSpct,0));
									sumDistTsi = parseFloat(sumDistTsi) + parseFloat(nvl(objArray[a].giuwPolicyds[b].giuwPolicydsDtl[c].distTsi,0));
									sumDistPrem = parseFloat(sumDistPrem) + parseFloat(nvl(objArray[a].giuwPolicyds[b].giuwPolicydsDtl[c].distPrem,0));
								}
							}
						}	
					}
				}
			}
			objUW.hidObjGIUTS002.sumDistSpct = sumDistSpct;
			objUW.hidObjGIUTS002.sumDistTsi = sumDistTsi;
			objUW.hidObjGIUTS002.sumDistPrem = sumDistPrem;
			if (parseInt(ctr) <= 5){
				$("distShareTotalAmtMainDiv").setStyle("padding-right:2px");
			}else{
				$("distShareTotalAmtMainDiv").setStyle("padding-right:19px");
			}	
			if (parseInt(ctr) > 0){
				$("distShareTotalAmtMainDiv").show();
			}else{
				$("distShareTotalAmtMainDiv").hide();
			} 
			$("distShareTotalAmtMainDiv").down("label",1).update(formatToNthDecimal(sumDistSpct,14).truncate(30, "..."));
			$("distShareTotalAmtMainDiv").down("label",2).update(formatCurrency(sumDistTsi).truncate(30, "..."));
			$("distShareTotalAmtMainDiv").down("label",3).update(formatCurrency(sumDistPrem).truncate(30, "..."));
		}catch(e){
			showErrorMessage("computeTotalAmount", e);
		}
	}

	//prepare listing for Main distribution
	function prepareList(obj){
		try{
			var list = '<label style="width: 20%; text-align: right; margin-right: 15px;">'+(obj.distNo == null || obj.distNo == ''? '' :formatNumberDigits(obj.distNo,8))+'</label>'+
					  		  '<label style="width: 35%; text-align: left; margin-right: 5px;">'+nvl(obj.distFlag,'')+'-'+changeSingleAndDoubleQuotes(nvl(obj.meanDistFlag,'')).truncate(30, "...")+'</label>'+
					          '<label style="width: 35%; text-align: left; ">'+nvl(obj.multiBookingMm,'')+'-'+nvl(obj.multiBookingYy,'')+'</label>';
			return list;	
		}catch(e){
			showErrorMessage("prepareList", e);
		}	
	}

	//prepare listing for Group distribution
	function prepareList2(obj){
		try{
			var list = '<label style="width: 12%; text-align: right; margin-right: 5px;">'+(nvl(obj.distSeqNo,'') == '' ? '-' :formatNumberDigits(obj.distSeqNo,5))+'</label>'+
					   		  '<label style="width: 30%; text-align: right; margin-right: 5px;">'+(nvl(obj.tsiAmt,'') == '' ? '-' :formatCurrency(obj.tsiAmt))+'</label>'+
					          '<label style="width: 30%; text-align: right; margin-right: 11px;">'+(nvl(obj.premAmt,'') == '' ? '-' :formatCurrency(obj.premAmt))+'</label>'+
					          '<label style="width: 25%; text-align: left; ">'+nvl(obj.currencyDesc,'-')+'</label>';
			return list;	
		}catch(e){
			showErrorMessage("prepareList2", e);
		}	
	}

	//prepare listing for Group distribution
	function prepareList3(obj){
		try{
			var list = '<label style="width: 25%; text-align: left; margin-right: 3px;">'+unescapeHTML2(nvl(obj.dspTrtyName,'-'))+'</label>'+
					          '<label style="width: 25%; text-align: right; margin-right: 5px;">'+(nvl(obj.distSpct,'') == '' ? '-' :formatToNthDecimal(obj.distSpct,14))+'</label>'+
					          '<label style="width: 24%; text-align: right; margin-right: 5px;">'+(nvl(obj.distTsi,'') == '' ? '-' :formatCurrency(obj.distTsi))+'</label>'+
					          '<label style="width: 24%; text-align: right; ">'+(nvl(obj.distPrem,'') == '' ? '-' :formatCurrency(obj.distPrem))+'</label>';
			return list;	
		}catch(e){
			showErrorMessage("prepareList3", e);
		}	
	}
	
	function clearForm(){
		try{
			supplyDist(null);
			supplyGroupDist(null);
			deselectRows("distListingDiv", "rowPrelimDist");
			deselectRows("distGroupListingDiv", "rowGroupDist");
			checkTableItemInfoAdditional("distGroupListingTableDiv","distGroupListingDiv","rowGroupDist","distNo",Number($("txtDistNo").value));
			checkTableItemInfo("distListingTableDiv","distListingDiv","rowPrelimDist");
		}catch(e){
			showErrorMessage("clearForm", e);
		}
	}
	
	function disableEnableButtons(){
			if ($("showDistGroup").innerHTML == "Show") {
				fireEvent($("showDistGroup"), "click");
			}
			if ($("showDistShare").innerHTML == "Show") {
				fireEvent($("showDistShare"), "click");
			}
	}
	
	observeReloadForm("reloadForm", showNegPostedDist);
	observeReloadForm("negPostedDistQuery", showNegPostedDist); // andrew - 12.5.2012
	fireEvent($("showDistGroup"), "click");
	fireEvent($("showDistShare"), "click");
	hideNotice();
	$("txtPolLineCd").focus(); // andrew - 12.5.2012
}catch(e){
	showErrorMessage("GIUTS002 page", e);
}
</script>
