<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
		<label>Copy Policy to PAR</label>
		<span class="refreshers" style="margin-top: 0;">
			<label name="gro" style="margin-left: 5px;">Hide</label> 
	 		<label id="reloadForm" name="reloadForm">Reload Form</label> 
		</span>
	</div>
</div>
<div class="sectionDiv" id="copyPolicyDiv" style="height: 150px">
	<table align="center" style="width: 58%; margin-top: 40px;">
		<tr>
			<td id="tdCopyPolicy" class="rightAligned" style="width:80px;">Policy No.</td>
			<td class="leftAligned">
				<div style="width: 50px; float: left; height: 20px;" class="withIconDiv">
					<input type="hidden" id="hidLineCd" name="hidLineCd" value="">	
					<input type="text" id="txtLineCd" name="txtLineCd" value="" style="width: 25px;" class="withIcon upper" maxlength="2">
					<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtLineCdIcon" name="txtLineCdIcon" alt="Go" />
				</div>
				<div style="width: 80px; float: left; height: 20px;" class="withIconDiv">
					<input type="text" id="txtSublineCd" name="txtSublineCd" value="" style="width: 50px;" class="withIcon upper" maxlength="7">
					<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtSublineCdIcon" name="txtSublineCdIcon" alt="Go"/>
				</div>
				<div style="width: 50px; float: left; height: 20px;" class="withIconDiv">
					<input type="text" id="txtIssCd" name="txtIssCd" value="" style="width: 25px;" class="withIcon upper" maxlength="2">
					<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtPolIssCdIcon" name="txtPolIssCdIcon" alt="Go" />
				</div>
				<div style="width: 50px; float: left; height: 20px;" class="withIconDiv">
					<input type="text" id="txtIssueYy" name="txtIssueYy" value="" style="width: 25px;" class="withIcon integerNoNegativeUnformattedNoComma" maxlength="2">
					<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtIssueYyIcon" name="txtIssueYyIcon" alt="Go" />
				</div>
				<div style="width: 80px; float: left; height: 20px;" class="withIconDiv">
					<input type="text" id="txtPolSeqNo" name="txtPolSeqNo" value="" style="width: 50px;" class="withIcon integerNoNegativeUnformattedNoComma" maxlength="7"> 
					<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtPolSeqNoIcon" name="txtPolSeqNoIcon" alt="Go" />
				</div>
				<div style="width: 50px; float: left; height: 20px;" class="withIconDiv">
					<input type="text" id="txtRenewNo" name="txtRenewNo" value="" style="width: 25px;" class="withIcon integerNoNegativeUnformattedNoComma" maxlength="2">
					<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtRenewNoIcon" name="txtRenewNoIcon" alt="Go" />
				</div>
			</td>
			<td width="0" style="visibility: hidden;" cellpadding="0" cellspacing="0">/</td>
			<td width="0" style="visibility: hidden;" cellpadding="0" cellspacing="0">
				<div style="width: 0; float: left; height: 20px;" class="withIconDiv">		
					<input type="text" id="txtEndtIssCd" name="txtEndtIssCd" value="" style="width: 0;" class="withIcon upper" maxlength="2" removeStyle="true">
					<%-- <img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtEndtIssCdIcon" name="txtEndtIssCdIcon" alt="Go" /> --%>
				</div>
				<div style="width: 0; float: left; height: 20px;" class="withIconDiv">		
					<input type="text" id="txtEndtYy" name="txtEndtYy" value="" style="width: 0;" class="withIcon integerNoNegativeUnformattedNoComma" maxlength="2" removeStyle="true">
					<%-- <img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtEndtYyIcon" name="txtEndtYyIcon" alt="Go" /> --%>
				</div>
				<div style="width: 0; float: left; height: 20px;" class="withIconDiv">
					<input type="text" id="txtEndtSeqNo" name="txtEndtSeqNo" value="" style="width: 0;" class="withIcon integerNoNegativeUnformattedNoComma" maxlength="7" removeStyle="true"> 
					<%-- <img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtEndtSeqNoIcon" name="txtEndtSeqNoIcon" alt="Go" /> --%>
				</div>
				<%-- <img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchForPolicy" name="searchForPolicy" alt="Go" style="margin-top: 2px;" title="Search Policy"/>/ --%>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">PAR No.</td>
			<td colspan="3" class="leftAligned">
				<div style="width: 56px; float: left; height: 20px;">
					<input type="text" name="txtNbtLineCd" id="txtNbtLineCd" style="width: 44px;" title="Par Line" maxlength="2"/>
				</div>
				<div style="width: 50px; float: left; height: 20px;" class="withIconDiv">
					<input type="text" name="txtNbtIssCd" id="txtNbtIssCd" style="width: 25px;" class="withIcon upper"  title="Par Issue Code" maxlength="2" value=""/>
					<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtNbtIssCdIcon" name="txtNbtIssCdIcon" alt="Go" />
				</div>
				<input type="text" name="txtNbtParYy" id="txtNbtParYy" style="width:45px;" title="Par Year" maxlength="2"/>
				<input type="text" name="txtNbtParSeqNo" id="txtNbtParSeqNo" style="width:73px;;" title="Par Sequence No" maxlength="7" class="rightAligned"/>
				<input type="text" name="txtNbtQuoteSeqNo" id="txtNbtQuoteSeqNo" style="width:45px;" title="Quote Sequence No" maxlength="2"/>
			</td>
			</tr>
	</table>
</div>
<div class="buttonsDiv">
		<input type="hidden" name="hidPolicyId" id="hidPolicyId"/>
		<input type="button" name="btnCopy" id="btnCopy" class="button" style="width: 80px;" value="Copy"/>
		<input type="button" name="btnCancel" id="btnCancel" class="button" style="width: 80px;" value="Cancel"/>
</div>

<script type="text/javascript">
	initializeAccordion();
	setModuleId("GIUTS008");
	setDocumentTitle("Copy Policy / Endorsement to PAR");
	initializeAll();
	makeInputFieldUpperCase();
	disableButton("btnCopy");
	observeReloadForm("reloadForm", showCopyPolicyEndt);
	
	$("btnCopy").observe("click",function(){
		//getPolicyId();
		//validateOpFlag();
		copyPolicyEndtToPAR();
	});
	
	function clearAllFields(includeLine) {
		/*$$("div#copySummarizePolicyDiv input[type='text']").each(function(row) {
			row.value == "";
		});*/
		if(includeLine){
			$("hidLineCd").value = "";
			$("txtLineCd").value = "";
		}
		$("txtSublineCd").value = "";
		$("txtIssCd").value = "";
		$("txtIssueYy").value = "";
		$("txtPolSeqNo").value = "";
		$("txtRenewNo").value = "";
		$("txtEndtIssCd").value = "";
		$("txtEndtYy").value = "";
		$("txtEndtSeqNo").value = "";
		$("txtNbtLineCd").value = "";
		$("txtNbtIssCd").value = "";
		$("txtNbtParYy").value = "";
		$("txtNbtParYy").value = "";
		$("txtNbtParSeqNo").value = "";
		$("txtNbtQuoteSeqNo").value = "";
		policyId = null;
	}
	$("txtLineCd").observe(/*"blur"*/ "change",function(){ // replaced blur to change - Nica 05.04.2013
		var oldLine = $F("hidLineCd");
		if(oldLine != $("txtLineCd").value) {
			clearAllFields(false);
			validateLineCd($F("txtLineCd"));
		}
	});
	
	/*$("txtIssCd").observe("blur",function(){		
		$("txtNbtIssCd").value = row.issCd;
		$("txtNbtIssCd").setAttribute("readOnly","readOnly");
	});*/
	
	
	$("txtLineCdIcon").observe("click", function() {
		//if(policyId == null) {
			/*showLineCdLOV2($F("hidLineCd"), "GIUTS008", function(row) {
				var oldLine = $F("hidLineCd");
				if(oldLine != unescapeHTML2(row.lineCd)) {
					clearAllFields();
					$("hidLineCd").value = unescapeHTML2(row.lineCd);
					$("txtLineCd").value = unescapeHTML2(row.lineCd);
					validateLineCd($F("txtLineCd"));
					/* $("txtNbtLineCd").value = unescapeHTML2(row.lineCd);
					$("txtNbtLineCd").setAttribute("readOnly","readOnly");
					$("txtLineCd").focus();
				}
			});*/
		//}
		showNonPackLineCdLOV($F("txtIssCd"), "GIUTS008", function(row) {
			var oldLine = $F("hidLineCd");
			if(oldLine != unescapeHTML2(row.lineCd)) {
				clearAllFields(true);
				$("hidLineCd").value = unescapeHTML2(row.lineCd);
				$("txtLineCd").value = unescapeHTML2(row.lineCd);
				validateLineCd($F("txtLineCd"));
				enableDisableCopyBtn();
			}
		});
	});
	
	$("txtSublineCdIcon").observe("click", function() {
		if($F("txtLineCd") != "") {
			showSublineCdLOV2($F("txtLineCd"), "GIUTS008", function(row) {
				$("txtSublineCd").value = unescapeHTML2(row.sublineCd);
				enableDisableCopyBtn();
				//$("txtIssueYy").value = "";
				//$("txtPolSeqNo").value = "";
				//$("txtRenewNo").value = "";
			});
		}
	});
	
	$("txtPolIssCdIcon").observe("click", function() {
		if($F("txtLineCd") != "" && $F("txtSublineCd") != "") { //added by robert 03.24.2014
			showIssCdNameLOV2($F("txtLineCd"), "GIUTS008", function(row) {
				$("txtIssCd").value = row.issCd;
				$("txtNbtIssCd").value = row.issCd;
				$("txtNbtIssCd").setAttribute("readOnly","readOnly");
				enableDisableCopyBtn();
				//$("txtParIssCd").value = row.issCd;
				//$("txtIssueYy").value = "";
				//$("txtPolSeqNo").value = "";
				//$("txtRenewNo").value = "";
			});
		}
	});
	 //added by robert 03.24.2014
	$("txtNbtIssCdIcon").observe("click", function() {
		if($F("txtLineCd") != "" && $F("txtSublineCd") != "" && $F("txtIssCd") != "") {
			showIssCdNameLOV2($F("txtLineCd"), "GIUTS008", function(row) {
				$("txtNbtIssCd").value = row.issCd;
				$("txtNbtIssCd").setAttribute("readOnly","readOnly");
				enableDisableCopyBtn();
				//$("txtParIssCd").value = row.issCd;
				//$("txtIssueYy").value = "";
				//$("txtPolSeqNo").value = "";
				//$("txtRenewNo").value = "";
			});
		}
	});

	$("txtIssueYyIcon").observe("click", function() {
		if($F("txtLineCd") != "" && $F("txtSublineCd") != "" && $F("txtIssCd") != "") {
			showIssueYyLOV($F("txtLineCd"), $F("txtSublineCd"), $F("txtIssCd"), "GIUTS008");			
		}
	});
	
	$("txtPolSeqNoIcon").observe("click", function() {
		if($F("txtLineCd") != "" && $F("txtSublineCd") != "" && $F("txtIssCd") != "" && $F("txtIssueYy") != "") {
			showPolSeqNoLOV($F("txtLineCd"), $F("txtSublineCd"), $F("txtIssCd"), $F("txtIssueYy"),"GIUTS008");
		}
	});
	
	$("txtRenewNoIcon").observe("click", function() {
		if($F("txtLineCd") != "" && $F("txtSublineCd") != "" && $F("txtIssCd") != "" && $F("txtIssueYy") != "" && $F("txtPolSeqNo") != "") {
			showRenewNoLOV($F("txtLineCd"), $F("txtSublineCd"), $F("txtIssCd"), $F("txtIssueYy"), $F("txtPolSeqNo"), "GIUTS008");
		}
	});
	
	$("copyPolExit").observe("click", function() {
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	
	$("btnCancel").observe("click", function() {
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	
	$("txtIssCd").observe(/*"blur"*/ "change",function(){ // replaced blur to change - Nica 05.04.2013
		checkUserPerIssCd();
		enableDisableCopyBtn();
	});
	
	$("txtPolSeqNo").observe(/*"blur"*/ "change",function(){ // replaced blur to change - Nica 05.04.2013
		if($F("txtPolSeqNo") != ""){
			$("txtPolSeqNo").value = formatNumberDigits($("txtPolSeqNo").value, 7);
			$("txtNbtQuoteSeqNo").value = "00";
		}else{
			$("txtNbtQuoteSeqNo").value = "";
		}
		enableDisableCopyBtn();
	});
	
	$("txtIssueYy").observe(/*"blur"*/ "change",function(){ // replaced blur to change - Nica 05.04.2013
		$("txtNbtParYy").value = dateFormat(new Date(), "yy");
		if($F("txtIssueYy") != ""){
			$("txtIssueYy").value = formatNumberDigits($("txtIssueYy").value, 2);
		}
		enableDisableCopyBtn();
	});
	
	$("txtRenewNo").observe(/*"blur"*/ "change",function(){ // replaced blur to change - Nica 05.04.2013
		//enableButton("btnCopy");
		if($F("txtRenewNo") != ""){
			$("txtRenewNo").value = formatNumberDigits($("txtRenewNo").value, 2);
		}
		enableDisableCopyBtn();
	});
	
	$("txtEndtYy").observe("change",function(){
		if($F("txtEndtYy") != ""){
			$("txtEndtYy").value = formatNumberDigits($("txtEndtYy").value, 2);
		}
	});
	
	$("txtEndtSeqNo").observe("change",function(){
		if($F("txtEndtSeqNo") != ""){
			$("txtEndtSeqNo").value = formatNumberDigits($("txtEndtSeqNo").value, 6);
		}
	});
	
	function enableDisableCopyBtn(){
		if($F("txtLineCd") != "" && $F("txtSublineCd") != "" && $F("txtIssCd") != "" && $F("txtIssueYy") != "" && $F("txtPolSeqNo") !=  "" & $F("txtRenewNo") != "") {
			enableButton("btnCopy");
		}else{
			disableButton("btnCopy");
		}
	}
	
	
	function validateLineCd(lineCd){
		try{
			new Ajax.Request(contextPath+"/GIUTS008CopyPolicyController",{
				parameters:{
					action: 	"validateCopyLineCd",
					lineCd:		$F("txtLineCd"),
					issCd:		$("txtIssCd").value, //added by: Nica 05.04.2013
					moduleId:   "GIUTS008"	//added by: Gzelle 01052015
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: showNotice("Validating Line Code, please wait..."),
				onComplete: function(response){
					hideNotice("");		
					/*if(response.responseText == "Y"){
						if($F("txtLineCd") == "SU"){
							$("txtNbtLineCd").value = $("txtLineCd").value;						
							$("txtNbtLineCd").setAttribute("readOnly","readOnly");
							
						}else{
							$("txtNbtLineCd").value = $("txtLineCd").value;
							$("txtNbtLineCd").setAttribute("readOnly","readOnly");
						}
					}else{
						$("txtNbtLineCd").value = "";
						$("txtLineCd").value = "";
						$("hidLineCd").value = "";
						$("txtLineCd").focus();
					}*/	// replaced by: Nica 05.04.2013
					if(checkErrorOnResponse(response)){
						if(nvl(response.responseText, "SUCCESS") == "SUCCESS"){
							$("txtNbtLineCd").value = $("txtLineCd").value;
							$("txtNbtLineCd").setAttribute("readOnly","readOnly");
						}else{
							showMessageBox(response.responseText, "I");
							$("txtNbtLineCd").value = "";
							$("txtLineCd").value = "";
							$("hidLineCd").value = "";
							$("txtLineCd").focus();
						}
					}else{
						showMessageBox(response.responseText, "E");
						$("txtNbtLineCd").value = "";
						$("txtLineCd").value = "";
						$("hidLineCd").value = "";
						$("txtLineCd").focus();
					}
				}
			});
		}catch(e){
			showErrorMessage("validateLineCd",e);
		}		
	}
	
	/*function validateOpFlag(){
		try{
			new Ajax.Request(contextPath+"/GIUTS008CopyPolicyController",{
				parameters:{
					action: "validateOpFlag",
					lineCd: $F("txtLineCd"),
					sublineCd:	$F("txtSublineCd")
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: showNotice("Validating Op Flag, please wait..."),
				onComplete: function(response){
				hideNotice("");		
				if(response.responseText == "Y"){
				}else if(response.responseText == "N"){
					copyPolicyMain();
				}
			}
			});
		}catch(e){
			showErrorMessage("validateOpFlag",e);
		}
	}*/// commented by: Nica 05.07.2013
	
	function checkUserPerIssCd(){
	try{
		new Ajax.Request(contextPath+"/GIUTS008CopyPolicyController",{
			parameters:{
				action: "checkUserPerIssCd",
				lineCd : $F("txtLineCd"),
				issCd: $F("txtIssCd"),
				moduleId: "GIUTS008"
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: showNotice("Validating Issue Code, please wait..."),
			onComplete: function(response){
			hideNotice("");		
			if(response.responseText == "1"){
				$("txtNbtIssCd").value = $("txtIssCd").value;
				$("txtNbtIssCd").setAttribute("readOnly","readOnly");
			}else{
				showMessageBox("Issue Code entered is not allowed for the current user.", "I");
				$("txtIssCd").value = "";
				$("txtNbtIssCd").value = "";
				$("txtIssCd").focus();
			}
			}
		});
	}catch(e){
		showErrorMessage("checkUserPerIssCd",e);
	}	
	}
	
	/*function getPolicyId(){
		try{
			new Ajax.Request(contextPath+"/GIUTS008CopyPolicyController",{
				parameters:{
					action: "getPolicyId",
					lineCd : $F("txtLineCd"),
					sublineCd : $F("txtSublineCd"),
					issCd: $F("txtIssCd"),
					issueYy: $F("txtIssueYy"),
					polSeqNo: $F("txtPolSeqNo"),
					renewNo: $F("txtRenewNo"),
					moduleId: "GIUTS008"
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: showNotice("Getting Policy ID, please wait..."),
				onComplete: function(response){
					hideNotice("");		
					$("hidPolicyId").value = response.responseText;				
				}
			});
		}
		catch(e){
			showErrorMessage("getPolicyId",e);
		}
	}*/ // commented by: Nica 05.07.2013
	
	/*function copyPolicyMain(){
		try{
			new Ajax.Request(contextPath+"/GIUTS008CopyPolicyController",{
				parameters:{
					action: "copyMainQuery",
					policyId: $F("hidPolicyId"),
					nbtLineCd: $F("txtLineCd"),
					nbtSublineCd : $F("txtSublineCd"),
					nbtIssCd: $F("txtIssCd"),
					nbtIssueYy: $F("txtIssueYy"),
					nbtPolSeqNo: $F("txtPolSeqNo"),
					nbtRenewNo: $F("txtRenewNo"),
					nbtEndtSeqNo: $F("txtEndtSeqNo"),
					nbtEndtIssCd: $F("txtEndtIssCd"),
					nbtEndtYy: $F("txtEndtYy"),
					lineCd: $F("txtNbtLineCd"),
					issCd: $F("txtNbtIssCd"),
					issueYy: $F("txtNbtParYy"),
					//polSeqNo: $F("txtNbtParSeqNo"),
					renewNo: $F("txtNbtQuoteSeqNo"),
					userId: userId		
				},asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
				hideNotice("");
				var res = response.responseText.toQueryParams();
				parSeqNo = res.parSeqNo; 
				$("txtNbtParSeqNo").value = parSeqNo;				
				 showOverlayContent(contextPath+"/GIUTS008CopyPolicyController?action=showCopyOverlay&oldPar="+res.oldPar+"&newPar="+res.newPar,
						"Copy Policy","",250,50,300); 
				 hideNotice("");
				}
			});			
		}
		catch(e){
			showErrorMessage("copyPolicyMain",e);
		}
	}*/ // commented by: Nica 05.07.2013
	
	function copyPolicyEndtToPAR(){
		try{
			new Ajax.Request(contextPath+"/GIUTS008CopyPolicyController",{
				parameters:{
					action: "copyPolicyEndtToPAR",
					nbtLineCd: $F("txtLineCd"),
					nbtSublineCd : $F("txtSublineCd"),
					nbtIssCd: $F("txtNbtIssCd"), //robert 03.24.2014
					nbtIssueYy: $F("txtIssueYy"),
					nbtPolSeqNo: $F("txtPolSeqNo"),
					nbtRenewNo: $F("txtRenewNo"),
					nbtEndtSeqNo: $F("txtEndtSeqNo"),
					nbtEndtIssCd: $F("txtEndtIssCd"),
					nbtEndtYy: $F("txtEndtYy"),
					lineCd: $F("txtNbtLineCd"),
					issCd: $F("txtIssCd")	//robert 03.24.2014
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function(){
					showNotice("Copying Policy/Endorsement to PAR, please wait...");
				},
				onComplete: function(response){
					hideNotice("");
					if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
						var res = JSON.parse(response.responseText);						
						var oldPolicyNo = unescapeHTML2(res.oldPolicyNo);
						var newPARNo = unescapeHTML2(res.newPARNo);
						var width = 320;
						var content =  '<div class="sectionDiv" id="lovListingDiv" name="lovListingDiv" style="float:left; display:block; width:'+(parseInt(width-20))+'px; height:150px; overflow:auto; margin-left:9px; text-align:center; border:0">'+
											'<pre>\n\n<font style="line-height:2em; font-family:Verdana; font-weight:bolder; font-size:12px;">This Policy  No. :</font>\n'+	
											'<font style="line-height:2em; font-family:Verdana; font-weight:bolder; font-size:14px; color:#0000FF;">&nbsp;&nbsp;&nbsp;&nbsp;<span>'+oldPolicyNo+'</span>&nbsp;&nbsp;&nbsp;&nbsp;</font>\n'+
											'<font style="line-height:2em; font-family:Verdana; font-weight:bolder; font-size:12px;">Had Been Copied To PAR No. :</font>\n'+
											'<font style="line-height:2em; font-family:Verdana; font-weight:bolder; font-size:14px; color:#FF0000;">&nbsp;&nbsp;&nbsp;&nbsp;<span>'+newPARNo+'</span>&nbsp;&nbsp;&nbsp;&nbsp;</font></pre>'+
										'</div>';
						
						function func(){
							showCustomDialogBox(content, width, "Ok");
							$("txtNbtParYy").value = formatNumberDigits(res.parYy, 2);
							$("txtNbtParSeqNo").value = formatNumberDigits(res.parSeqNo, 6);
							$("txtNbtQuoteSeqNo").value = formatNumberDigits(res.quoteSeqNo, 2);
							if(nvl($("txtEndtSeqNo").value,0) == 0){
								$("txtEndtIssCd").value = "";
								$("txtEndtYy").value = "";
								$("txtEndtSeqNo").value = "";
							}
							disableGiuts008Page();
						}
						
						if(res.mortgageeSuccess == "N"){
							showWaitingMessageBox("Record(s) in GIPI_MORTGAGEE were not copied because one or more mortgagee in " + $F("txtIssCd") + " were not maintained in " + $F("txtNbtIssCd") + ".", imgMessage.INFO, func);
						} else
							func();
					}else{
						showMessageBox(response.responseText, "E");
					}
				}
			});			
		}catch(e){
			showErrorMessage("copyPolicyEndtToPAR",e);
		}
	}
	
	function showCustomDialogBox(content,width,okLabel){
		Dialog.alert(content, {
			title: "",
			okLabel: okLabel,
			onOk: function(){
				clearGiuts008Page(); /* added by MarkS 05.10.2016 SR-5380 clear all fields */
				Dialog.closeInfo();
			},
			className: "alphacube",
			width: width,
			buttonClass: "button",
			draggable: true
		});
	}
	/* added by MarkS 05.10.2016 SR-5380 clear all fields */
	function clearGiuts008Page(){
		$("txtLineCd").readOnly = false;
		$("txtSublineCd").readOnly = false;
		$("txtIssCd").readOnly = false;
		$("txtIssueYy").readOnly = false;
		$("txtPolSeqNo").readOnly = false;
		$("txtRenewNo").readOnly = false;
		$("txtEndtIssCd").readOnly = false;
		$("txtEndtYy").readOnly = false;
		$("txtEndtSeqNo").readOnly = false;
		$("txtNbtLineCd").readOnly = false;
		$("txtNbtIssCd").readOnly = false;
		$("txtNbtParYy").readOnly = false;
		$("txtNbtParYy").readOnly = false;
		$("txtNbtParSeqNo").readOnly = false;
		$("txtNbtQuoteSeqNo").readOnly = false;
		$("txtLineCd").value = "";
		$("txtSublineCd").value = "";
		$("txtIssCd").value = "";
		$("txtIssueYy").value = "";
		$("txtPolSeqNo").value = "";
		$("txtRenewNo").value = "";
		$("txtEndtIssCd").value = "";
		$("txtEndtYy").value = "";
		$("txtEndtSeqNo").value = "";
		$("txtNbtLineCd").value = "";
		$("txtNbtIssCd").value = "";
		$("txtNbtParYy").value = "";
		$("txtNbtParYy").value = "";
		$("txtNbtParSeqNo").value = "";
		$("txtNbtQuoteSeqNo").value = "";
		disableButton("btnCopy");
		enableSearch("txtLineCdIcon");
		enableSearch("txtSublineCdIcon");
		enableSearch("txtPolIssCdIcon");
		enableSearch("txtNbtIssCdIcon"); 
		enableSearch("txtIssueYyIcon");
		enableSearch("txtPolSeqNoIcon");
		enableSearch("txtRenewNoIcon");
	}
	/* end SR-5380 */
	function disableGiuts008Page(){
		$("txtLineCd").readOnly = true;
		$("txtSublineCd").readOnly = true;
		$("txtIssCd").readOnly = true;
		$("txtIssueYy").readOnly = true;
		$("txtPolSeqNo").readOnly = true;
		$("txtRenewNo").readOnly = true;
		$("txtEndtIssCd").readOnly = true;
		$("txtEndtYy").readOnly = true;
		$("txtEndtSeqNo").readOnly = true;
		$("txtNbtLineCd").readOnly = true;
		$("txtNbtIssCd").readOnly = true;
		$("txtNbtParYy").readOnly = true;
		$("txtNbtParYy").readOnly = true;
		$("txtNbtParSeqNo").readOnly = true;
		$("txtNbtQuoteSeqNo").readOnly = true;
		disableButton("btnCopy");
		disableSearch("txtLineCdIcon");
		disableSearch("txtSublineCdIcon");
		disableSearch("txtPolIssCdIcon");
		disableSearch("txtNbtIssCdIcon"); //robert 03.24.2014
		disableSearch("txtIssueYyIcon");
		disableSearch("txtPolSeqNoIcon");
		disableSearch("txtRenewNoIcon");
	}
</script>