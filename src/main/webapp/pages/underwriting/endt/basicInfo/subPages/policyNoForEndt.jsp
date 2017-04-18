<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c"  uri="/WEB-INF/tld/c.tld" %>

<%
	request.setAttribute("contextPath", request.getContextPath());
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<%-- <jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include> --%>
<div style="float: left; width: 100%;">
	<div style="width: 100%;">
		<form id="policyNumberForm" name="policyNumberForm">
			<!-- <input type="hidden" id="action" name="action" value="forgotPassword" />  -->
			<input type="hidden" name="polParId"	id="polParId" value="${parId}">
			<input type="hidden" name="polNoForEndtStopper" id="polNoForEndtStopper" value="N" />
			<input type="hidden" name="oldPolicyNo"	id="oldPolicyNo" value="${oldPolicyNo}">
			<input type="hidden" name="globalAssdNo"	id="globalAssdNo" value="${globalAssdNo}"><!--jmm-->
			<input type="hidden" name="assdNo"	id="assdNo" value="${assdNo}"><!--jmm-->
			<%-- <input type="hidden" name="globalAssdName"	id="globalAssdName" value="${globalAssdName}"><!--jmm--> --%>
			<input type="hidden" name="isPack"	id="isPack" value="${isPack}<c:if test="${empty isPack }">N</c:if>">
			
			<label id="messagePolicyNo" style="padding-bottom: 10px; margin-bottom: 10px; width: 100%; text-align: center; color: red;"></label>
			<br /><br />
			
		<!--		<select id="policySublineCd" name="policySublineCd" style="width: 75px;">
					<option>x</option>
					<c:forEach var="policy" items="${policies}">
						<option value="${policy.sublineCd }">${policy.sublineCd} - ${policy.issCd} - ${policy.issueYy} - ${policy.polSeqNo} - ${policy.renewNo}</option>
					</c:forEach>
				</select>	
				<span style="border: 1px solid gray; width: 75px; height: 21px; float: left;" class="required"> 
					<input type="text" id="policySublineCd" name="policySublineCd" style="border: none; float: left; width: 50px;" class="required" readonly="readonly" /> 
					</span>
		-->	
			<div style="float: left;">
				<label style="width: 80px; text-align: right; height: 20px; padding-top: 4px; margin; margin-right: 3px;">Policy No: </label>		
				<input type="text" id="polLineCd" 		name="polLineCd" 	maxlength="2" style="width: 30px;" disabled="disabled" readonly="readonly" value="${lineCdPol}" class="text" />
			  	<input type="text" id="polSublineCd" 	name="polSublineCd" maxlength="7" style="width: 60px;" value="${sublineCdPol}" class="text" />  				
				<input type="text" id="polIssCd" 		name="polIssCd" 	maxlength="2" style="width: 30px;" disabled="disabled" readonly="readonly" value="${issCd}" class="text" />
				<!-- 
				<input type="text" id="polIssueYy" 		name="polIssueYy" 	maxlength="2" style="width: 30px; text-align: right;" value="${issueYy}" class="integerNoNegativeUnformatted" />
				<input type="text" id="polPolSeqNo" 	name="polPolSeqNo" 	maxlength="7" style="width: 50px; text-align: right;" value="${polSeqNo}" class="integerNoNegativeUnformatted" />
				<input type="text" id="polRenewNo" 		name="polRenewNo" 	maxlength="2" style="width: 30px; text-align: right;" value="${renewNo}" class="integerNoNegativeUnformatted" />
				 -->
				<input type="text" id="polIssueYy" 		name="polIssueYy" 	maxlength="2" style="width: 30px;" value="${issueYy}" class="applyWholeNosRegExp" regExpPatt="pDigit02" />
				<input type="text" id="polPolSeqNo" 	name="polPolSeqNo" 	maxlength="7" style="width: 50px;" value="${polSeqNo}" class="applyWholeNosRegExp" regExpPatt="pDigit07" />
				<input type="text" id="polRenewNo" 		name="polRenewNo" 	maxlength="2" style="width: 30px;" value="${renewNo}" class="applyWholeNosRegExp" regExpPatt="pDigit02" />		
			</div>		
			<div style="width: 20px; float: left; text-align: left; margin-left: 5px; margin-top: 2px;">
			 	<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchForPolicy" name="searchForPolicy" alt="Go" />
			</div>
		 	<br /> 	
	  	</form>  
	  	<div style="float: left; margin: 15px 0 5px 0; width: 100%" align="center">
			<input type="button" class="button" style="width:70px;" id="btnOkPolForEndt" name="btnOkPolForEndt" value="Ok" /> 	<!-- Gzelle 08102015 SR18508/2848 -->
		 	<input type="button" class="button" style="width:70px;" id="btnExit" name="btnExit" value="Cancel" />
	  	</div>
	</div>	
</div>
<script type="text/javascript">
	//validatePolNo2 = "";
	
	if ($F("isPack") == "Y") {
		var parId = objUWGlobal.packParId == null ? "" : objUWGlobal.packParId;
		var lineCd = objUWGlobal.lineCd == null ? "" : objUWGlobal.lineCd;
		var issCd = objUWGlobal.issCd == null ? "" : objUWGlobal.issCd;
		var sublineCd = objUWGlobal.sublineCd == null ? $F("polSublineCd") : objUWGlobal.sublineCd;
	} else {
		var parId = $F("globalParId");
		var lineCd = $F("globalLineCd");
		var issCd = $F("globalIssCd");
		var sublineCd = $F("polSublineCd");
	}
		
	$("searchForPolicy").observe("click", function() {
		//showOverlayContent(contextPath+"/GIPIPolbasicController?action=getPolicyNoForEndt&parId="+parId+"&lineCd="+lineCd+"&issCd="+issCd+"&sublineCd="+sublineCd,
		var controller = "";
		var action = "";
		var policyNo = new Object();
		
		if ($F("isPack") == "Y") {
			// andrew - 07.11.2011 - modified the action
			/* controller = "GIPIPackPolbasicController";
			action = "getPolicyNoForPackEndt"; */
			action = "getPackPolicyNoLOV";
		} else {
			/* controller = "GIPIPolbasicController";
			action = "getPolicyNoForEndt"; */
			// andrew - 07.11.2011 - modified the action
			action = "getPolicyNoLOV"; 
		}
		
		policyNo.action = action;
		policyNo.lineCd = $F("polLineCd");
		policyNo.sublineCd = $F("polSublineCd");
		policyNo.issCd = $F("polIssCd");
		policyNo.issueYy = $F("polIssueYy");
		policyNo.polSeqNo = $F("polPolSeqNo");
		policyNo.renewNo = $F("polRenewNo");
		
		showPolicyNoLOV(policyNo);
		/* showOverlayContent2(contextPath+"/"+controller+"?action="+action+"&parId="+parId+"&lineCd="+lineCd+"&issCd="+issCd+"&sublineCd="+sublineCd+"&"+Form.serialize("policyNumberForm"), 
						"Select Policy", 600, overlayOnComplete); */
	});
	
	initializeAll();

	$("polSublineCd").observe("keyup", function(){
		var polSublineCd = $F("polSublineCd").toUpperCase();
		$("polSublineCd").value = polSublineCd;
	});
	
	$("polSublineCd").observe("blur", function(){
		var polSublineCd = $F("polSublineCd").toUpperCase();
		$("polSublineCd").value = polSublineCd;
	});

	/*
	$("polIssueYy").observe("blur", function(){
		isNumber("polIssueYy", "Issue Year must be a number from 0 to 99", "popup");
	});

	$("polPolSeqNo").observe("blur", function(){
		isNumber("polPolSeqNo", "Policy Sequence must be a number from 0 to 9999999", "popup");
	});

	$("polRenewNo").observe("blur", function(){
		isNumber("polPolSeqNo", "Renew No must be a number from 0 to 99", "popup");
	});
	*/
	$("btnExit").observe("click", function() {
		//hideOverlay();
		//$("contentHolder").update(""); // andrew - 02.14.2011 - solution sa Null Pointer Error kapag nagselect ng endt na wala pang policy then nag select ng meron na.
		overlayPolicyNumber.close();
	});

	$("btnOkPolForEndt").observe("click", function(){	//Gzelle 08102015 SR18508/2848
		var lineCd = $F("polLineCd");
		var sublineCd = $F("polSublineCd");
		var issCd = $F("polIssCd");
		var issueYy = $F("polIssueYy");
		var polSeqNo = $F("polPolSeqNo");
		var renewNo = $F("polRenewNo");
		var globalLineCd = getLineCd();
		
		if(lineCd.blank() | sublineCd.blank() | issCd.blank() | issueYy.blank() | polSeqNo.blank() | renewNo.blank()){
			showMessageBox("Please complete the policy number to be endorsed.", imgMessage.ERROR);
			return false;
		}else{
			function continueProcess(errorRaised){
				try{					
					if(errorRaised){						
						$("polSublineCd").value = "";						
						$("polIssueYy").value = "";
						$("polPolSeqNo").value = "";
						$("polRenewNo").value = "";
						return false;
					}else{	
						if(nvl($F("oldPolicyNo"), "") != ""){ // added by: Nica 05.04.2013 - to confirm alteration of the policy no
							var oldPolicy = $("oldPolicyNo").value;
							var newPolicy = lineCd+"-"+sublineCd+"-"+issCd+"-"+parseInt(issueYy).toPaddedString(2)+"-"+parseInt(removeLeadingZero(polSeqNo)).toPaddedString(7)+"-"+parseInt(removeLeadingZero(renewNo)).toPaddedString(2);
							var width = 380;
							var content =  '<div class="sectionDiv" id="lovListingDiv" name="lovListingDiv" style="padding-top:2px; float:left; display:block; width:'+(parseInt(width-20))+'px; height:160px; overflow:auto; margin-left:9px; margin-top:10px; text-align:center; border:0">'+
												'<pre>\n\n<font style="line-height:1.5em; font-family:Verdana; font-weight:bolder; font-size:12px;">User has altered the Policy Number from :</font>\n'+	
												'<font style="line-height:1.5em; font-family:Verdana; font-weight:bolder; font-size:14px; text-decoration:blink; color:#FF0000; background-color:#E8E8E8;">&nbsp;&nbsp;&nbsp;&nbsp;<span>'+oldPolicy+'</span>&nbsp;&nbsp;&nbsp;&nbsp;</font>\n'+
												'<font style="line-height:1.5em; font-family:Verdana; font-weight:bolder; font-size:12px;">to</font>\n'+
												'<font style="line-height:1.5em; font-family:Verdana; font-weight:bolder; font-size:14px; text-decoration:blink; color:#0000FF; background-color:#E8E8E8;">&nbsp;&nbsp;&nbsp;&nbsp;<span>'+newPolicy+'</span>&nbsp;&nbsp;&nbsp;&nbsp;</font>\n'+
												'<font style="line-height:1.5em; font-family:Verdana; font-weight:bolder; font-size:12px;">All information related to the previous PAR</font>\n'+
												'<font style="line-height:1.5em; font-family:Verdana; font-weight:bolder; font-size:12px;">will be deleted. Continue anyway ?</font></pre>'+
											'</div>';
							
							Dialog.confirm(content, {
								title: "",
								okLabel: "Ok",
								cancelLabel: "Cancel",
								onOk: function(){
									if ($F("isPack") == "Y") {
										getPackBasicInfo();
									} else {
										if (lineCd == "SU" && $F("globalParType") == "E"){
											showEndtBondBasicInfo();
										} else {
											getBasicInfo();
										}
									}	
									overlayPolicyNumber.close();
									return true;
								},
								onCancel: function() {
									Dialog.closeInfo();
									overlayPolicyNumber.close();
									return false;
								},
								className: "alphacube",
								width: 380,
								buttonClass: "button",
								draggable: true
							});
						}else{
							if ($F("isPack") == "Y") {
								//jmm SR-22834
								new Ajax.Request(contextPath + "/GIPIParInformationController", {
									method : "POST",
									parameters : {
										action : "validatePackAssdNoRiCd",
										parId : $F("polParId"),
										lineCd : lineCd,
										sublineCd : sublineCd,
										issCd : issCd,
										issueYy : issueYy,
										polSeqNo : polSeqNo,
										renewNo : renewNo
									},
									asynchronous : false,
									evalScripts : true,
									onCreate : showNotice("Validating..."),
									onComplete : function(response){
										hideNotice("");
										if(checkErrorOnResponse(response)){
											var objPack = JSON.parse(response.responseText);
												objPackAssdNo = objPack.assdNo;
												objPackRiCd = objPack.riCd;
												if ((objPackAssdNo != globalAssdNo || objPackRiCd != globalRiCd) && issCd == 'RI'){
													validatePolNo2 = "Y";
													postValidate = "Y";
													if(objPackRiCd != globalRiCd){
														notEqualRiCd = true;
													}else{
														notEqualRiCd = false;
													}
												}else{
													validatePolNo2 = "";
												}
												getPackBasicInfo();
										}
									}
								});
							} else {
								//jmm SR-22834
								//if (lineCd == "SU" && $F("globalParType") == "E"){ robert 10.10.14
								if ((lineCd == "SU" || globalLineCd == "SU") && $F("globalParType") == "E"){
									new Ajax.Request(contextPath + "/GIPIParInformationController", {
										method : "POST",
										parameters : {
											action : "validateAssdNoRiCd",
											parId : $F("polParId"),
											lineCd : lineCd,
											sublineCd : sublineCd,
											issCd : issCd,
											issueYy : issueYy,
											polSeqNo : polSeqNo,
											renewNo : renewNo
										},
										asynchronous : false,
										evalScripts : true,
										onCreate : showNotice("Validating..."),
										onComplete : function(response){
											hideNotice("");
											if(checkErrorOnResponse(response)){
												var objPack = JSON.parse(response.responseText);
													objPackAssdNo = objPack.assdNo;
													objPackRiCd = objPack.riCd;
													if ((objPackAssdNo != globalAssdNo || objPackRiCd != globalRiCd) && issCd == 'RI'){
														globalPolNo = "(" + lineCd + "-" + sublineCd + "-" + issCd + "-" + issueYy + "-" + polSeqNo + "-" + renewNo + ")";
														validatePolNo2 = "Y";
														postValidate = "Y";
														if(objPackRiCd != globalRiCd){
															notEqualRiCd = true;
														}else{
															notEqualRiCd = false;
														}
													}else{
														validatePolNo2 = "";
													}
												showEndtBondBasicInfo();
											}
										}
									});
								} else {
									new Ajax.Request(contextPath+"/GIPIParInformationController",{
										method: "POST",
										parameters: {
											action: "validateAssdNoRiCd",
											parId: $F("polParId"),
											lineCd: lineCd,
											sublineCd: sublineCd,
											issCd: issCd,
											issueYy: issueYy,
											polSeqNo: polSeqNo,
											renewNo: renewNo
									},
									asynchronous : false,
									evalScripts : true,
									onCreate: showNotice("Validating..."),
									onComplete: function(response){
										hideNotice("");
										if(checkErrorOnResponse(response)){
											var obj = JSON.parse(response.responseText);
											objAssdNo = obj.assdNo;
											objAssdName = obj.assdName;
											var riCd_ = obj.riCd;
											if((objAssdNo != globalAssdNo || riCd_ != globalRiCd) && issCd == 'RI'){
												validatePolNo2 = "Y";
												postValidate = "Y";
												if(riCd_ != globalRiCd){
													notEqualRiCd = true;
												}else{
													notEqualRiCd = false;
												}
											}else{
												validatePolNo2 = "";
											}
											getBasicInfo();
										}
									}	
								 });
								}
							}	
							overlayPolicyNumber.close();
							return true;
							//End
						}
					}
				}catch(e){
					showErrorMessage("continueProcess", e);
				}							
			}
			
			/*
			if(isNaN(parseInt(issueYy))){
				showMessageBox("Issue Year must be a number from 0 to 99", imgMessage.ERROR);
				return false;
			}else if(isNaN(parseInt(polSeqNo))){
				showMessageBox("Policy Sequence must be a number from 0 to 9999999", imgMessage.ERROR);
				return false;
			}else if(isNaN(parseInt(renewNo))){
				showMessageBox("Renew No must be a number from 0 to 99", imgMessage.ERROR);
				return false;
			}
			*/
			
			var errorRaised = false;
			var controller = "";
			var action = "";

			if ($F("isPack") == "Y") {
				controller = "GIPIPackParInformationController";
				action = "checkPolicyNoForPackEndt";
			} else {
				controller = "GIPIParInformationController";
				action = "checkPolicyNoForEndt";
			}

			new Ajax.Request(contextPath + "/"+controller+"?action="+action, {
				method : "GET",
				parameters : {
					parId : parId,
					lineCd : lineCd,
					sublineCd : sublineCd,
					issCd : issCd,
					issueYy : issueYy,
					polSeqNo : polSeqNo,
					renewNo : renewNo
				},
				asynchronous : true,
				evalScripts : true,
				//onCreate : showNotice("Validating policy no., please wait..."),
				onComplete : 
					function(response){						
						hideOverlay();
						if (checkErrorOnResponse(response)) {
							//var result = response.responseText.toQueryParams();
							var result = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
							// mark jm 11.02.2011 added packPolFlag attribute for package (temporary storage)
							objUWGlobal.packPolFlag = result.packPolFlag;
							
							if(result.resultEnteredPolNo != "Policy specified has been renewed." &&
									result.resultEnteredPolNo != "Policy has already expired." &&
									nvl(result.resultEnteredPolNo,null) != null){
								showWaitingMessageBox(result.resultEnteredPolNo, imgMessage.ERROR, function(){
									continueProcess(true);
								});								
							}else if(nvl(result.resultPolicySpoilage,null) != null){
								showWaitingMessageBox(result.resultPolicySpoilage, imgMessage.ERROR, function(){
									continueProcess(true);
								});	
							}else if(result.resultEnteredPolNo == "Policy specified has been renewed."){								
								showWaitingMessageBox(result.resultEnteredPolNo, imgMessage.INFO, function(){
									if(nvl(result.resultCheckClaims,null) != null){
										showWaitingMessageBox(result.resultCheckClaims, imgMessage.ERROR, function(){
											continueProcess(false);
										});
									}else{
										continueProcess(false);	
									}									
								});	
							}else if(nvl(result.resultCheckClaims,null) != null){
								showWaitingMessageBox(result.resultCheckClaims, imgMessage.ERROR, function(){
									continueProcess(false);
								});																					
							}else{
								continueProcess(false);
							}
							
						}
					}
				});
		}										
	});
	function searchForPolicy(){
		new Ajax.Request(contextPath + "/GIPIParInformationController?action=searchForPolicy", {
			method : "GET",
			parameters : {
				parId : 1, 
				lineCd : $F("polLineCd"),
				sublineCd : $F("polSublineCd"),
				issCd : $F("polIssCd"),
				issueYy : $F("polIssueYy"),
				polSeqNo : $F("polPolSeqNo"),
				renewNo : $F("polRenewNo")
			},
			asynchronous : true,
			evalScripts : true,
			onCreate : showNotice("Searching for policy, please wait..."),
			onComplete : 
				
				function(response){
					if (checkErrorOnResponse(response)) {
						hideNotice();
					}
			}
		});
	}
	
	$("polSublineCd").focus();

</script>
