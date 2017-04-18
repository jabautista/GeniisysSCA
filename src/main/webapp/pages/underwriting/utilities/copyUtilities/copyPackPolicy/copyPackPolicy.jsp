<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>
<div id="copyPackPolicyMainDiv" name="copyPackPolicyMainDiv">
	<div id="copyPackPolicyMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="btnExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Copy Package Policy to PAR</label>
			<span class="refreshers" style="margin-top: 0;">
				<label name="gro" style="margin-left: 5px;">Hide</label> 
		 		<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>
	<div id="groDiv" name="groDiv">
	<div class="sectionDiv" style="height: 150px;">
		<table align="center" style="width: 56%; margin-top: 40px;">
			<tr>
				<td class="rightAligned" width="">Policy No.</td>
				<td>
					<input id="polLineCd" type="text" title="Line Code" style="width: 50px; margin-left: 6px;" maxlength="2"/>
					<input id="polSublineCd" type="text" title="Subline Code" style="width: 80px;" maxlength="7"/>
					<input id="polIssCd" type="text" title="Issue Code" style="width: 50px;" maxlength="2"/>
					<input id="polIssueYy" type="text" title="Issue Year" style="width: 30px;" maxlength="2"/>
					<input id="polPolSeqNo" type="text" title="Policy Sequence Number" style="width: 80px;" maxlength="7"/>
					<input id="polRenewNo" type="text" title="Renew Number" style="width: 35px;" maxlength="2"/>
					<!-- <input id="polLineCd" type="text" style="width: 50px; margin-left: 6px;" value="P1"/>
					<input id="polSublineCd" type="text" style="width: 80px;" value="PK"/>
					<input id="polIssCd" type="text" style="width: 50px;" value="HO"/>
					<input id="polIssueYy" type="text" style="width: 30px; text-align: right;" value="11"/>
					<input id="polPolSeqNo" type="text" style="width: 80px; text-align: right;" value="1"/>
					<input id="polRenewNo" type="text" style="width: 35px; text-align: right;" value="0"/> -->
				</td>
				<td width="0" cellpadding="0" cellspacing="0" style="visibility: hidden;">/</td>
				<td width="0" cellpadding="0" cellspacing="0" style="visibility: hidden;">
					<input id="polEndtIssCd" type="text" style="width: 0;" maxlength="2"/>
					<input id="polEndtYy" type="text" style="width: 0; text-align: right;" maxlength="2"/>
					<input id="polEndtSeqNo" type="text" style="width: 0; text-align: right;" maxlength="7"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">PAR No.</td>
				<td>
					<input id="parLineCd" type="text" style="width: 50px; margin-left: 6px;" readonly="readonly"/>
					<input id="parIssCd" type="text" style="width: 50px;" maxlength="2"/>
					<input id="parParYy" type="text" style="width: 30px; text-align: right;" readonly="readonly"/>
					<input id="parParSeqNo" type="text" style="width: 80px; text-align: right;" readonly="readonly"/>
					<input id="parQuoteSeqNo" type="text" style="width: 30px; text-align: right;" maxlength="2"/>
				</td>
			</tr>
		</table>
	</div>
	</div>
	<div align="center" >
		<input id="btnCopy" type="button" class="button" value="Copy" style="margin-top: 10px;"/>
		<input id="btnCancel" type="button" class="button" value="Cancel"/>
	</div>
</div>

<script type="text/Javascript">
	initializeAccordion();
	setModuleId("GIUTS008A");
	setDocumentTitle("Copy Package Policy to PAR");
	disableButton("btnCopy");
	
	//POLICY:NBT_LINE_CD - WHEN-VALIDATE-ITEM
	function validateLineCd(){
		new Ajax.Request(contextPath+"/CopyUtilitiesController?action=validateLineCdGiuts008a",{
			parameters: {
				lineCd : $F("polLineCd"),
				issCd : $F("polIssCd"),
				userId: userId//added by reymon 05042013
			},
			evalScripts: true,
			asynchronous: true,
			onComplete: function(response){
				if(response.responseText != "SUCCESS"){
					$("polLineCd").clear();
					$("parLineCd").clear();
					customShowMessageBox(response.responseText, "E", "polLineCd");
				}else{
					$("parLineCd").value = $F("polLineCd");
				}
				validateFields();
			}
		});
	}
	
	$("polLineCd").observe("keyup", function(){
		$("polLineCd").value = $("polLineCd").value.toUpperCase();
	});
	$("polLineCd").observe("change", validateLineCd);
	
	//POLICY:NBT_ISS_CD - WHEN-VALIDATE-ITEM
	function validateIssCd(issCd, issSw){
		new Ajax.Request(contextPath+"/CopyUtilitiesController?action=validateIssCdGiuts008a",{
			parameters: {
				lineCd : $F("polLineCd"),
				issCd : issCd,
				userId: userId//added by reymon 05072013
			},
			evalScripts: true,
			asynchronous: true,
			onComplete: function(response){
				if(response.responseText == "SUCCESS"){
					if(issSw == "pol"){
						$("parIssCd").value = $F("polIssCd");
					}
				}else{
					if(issSw == "pol"){
						//customShowMessageBox("Issue Code entered is not allowed for the current user.", "E", "polIssCd"); commented and changed by reymon 05042013
						customShowMessageBox(response.responseText, "E", "polIssCd");
						$("polIssCd").clear();	
					}else if(issSw == "par"){
						//customShowMessageBox("Issue Code entered is not allowed for the current user.", "E", "parIssCd"); commented and changed by reymon 05042013
						customShowMessageBox(response.responseText, "E", "parIssCd");
						$("parIssCd").clear();
					}
				}
				validateFields();
			}
		});
	}
	
	$("polSublineCd").observe("keyup", function(){
		$("polSublineCd").value = $("polSublineCd").value.toUpperCase();
	});
	$("polSublineCd").observe("change", validateFields);
	
	$("polIssCd").observe("keyup", function(){
		$("polIssCd").value = $("polIssCd").value.toUpperCase();
	});
	$("polIssCd").observe("change", function(){
		if($F("polIssCd") != ""){
			validateIssCd($F("polIssCd"), "pol");	
		}else{
			$("parIssCd").clear();	
		}
	});
	$("parIssCd").observe("keyup", function(){
		$("parIssCd").value = $("parIssCd").value.toUpperCase();
	});
	$("parIssCd").observe("change", function(){
		validateIssCd($F("parIssCd"), "par");	
	});
	
	$("polIssueYy").observe("change", function(){
		if($F("polIssueYy") != ""){
			if(isNaN($F("polIssueYy"))){
				$("polIssueYy").clear();
				customShowMessageBox("Field must be of form 09.", "E", "polIssueYy");
			}else{
				$("polIssueYy").value = formatNumberDigits($F("polIssueYy"),2);
				$("parParYy").value = new Date().format("mm/dd/yy").substring(6);
			}	
		}
		validateFields();
	});
	
	$("polPolSeqNo").observe("change", function(){
		if($F("polPolSeqNo") != ""){
			if(isNaN($F("polPolSeqNo"))){
				$("polPolSeqNo").clear();
				customShowMessageBox("Field must be of form 0999999.", "E", "polPolSeqNo");
			}else{
				$("polPolSeqNo").value = formatNumberDigits($F("polPolSeqNo"),7);
				$("parQuoteSeqNo").value = "00";
			}	
		}
		validateFields();	
	});
	
	$("polRenewNo").observe("change", function(){
		if($F("polRenewNo") != ""){
			if(isNaN($F("polRenewNo"))){
				$("polRenewNo").clear();
				customShowMessageBox("Field must be of form 09.", "E", "polRenewNo");
			}else{
				$("polRenewNo").value = formatNumberDigits($F("polRenewNo"),2);		
			}	
		}
		validateFields();	
	});
	
	$("parQuoteSeqNo").observe("change", function(){
		if(isNaN($F("parQuoteSeqNo"))){
			$("parQuoteSeqNo").clear();
			customShowMessageBox("Field must be of form 09.", "E", "parQuoteSeqNo");
		}else{
			$("parQuoteSeqNo").value = formatNumberDigits($F("parQuoteSeqNo"),2);
		}
	});
	
	$("polEndtIssCd").observe("keyup", function(){
		$("polEndtIssCd").value = $("polEndtIssCd").value.toUpperCase();
	});
	
	$("polEndtYy").observe("change", function(){
		if($F("polEndtYy") != ""){
			if(isNaN($F("polEndtYy"))){
				$("polEndtYy").clear();
				customShowMessageBox("Legal characters are 0-9.", "E", "polEndtYy");
			}else{
				$("polEndtYy").value = formatNumberDigits($F("polEndtYy"),2);
			}	
		}
	});
	
	$("polEndtSeqNo").observe("change", function(){
		if($F("polEndtSeqNo") != ""){
			if(isNaN($F("polEndtSeqNo"))){
				$("polEndtSeqNo").clear();
				customShowMessageBox("Field must be of form 099999.", "E", "polEndtSeqNo");
			}else{
				$("polEndtSeqNo").value = formatNumberDigits($F("polEndtSeqNo"),6);
			}	
		}
	});

	function doCopy(){
		if($F("parIssCd") == ""){
			customShowMessageBox("Issuing Code for the new PAR to be created is required.", "E", "parIssCd");
		}else{
			copyGiuts008a();
		}
	}
	
	function validateFields(){
		if($F("polLineCd") == "" || $F("polSublineCd") == "" || $F("polIssCd") == "" || $F("polIssueYy") == "" || $F("polPolSeqNo") == "" || $F("polRenewNo") == ""){
			disableButton("btnCopy");
		}else{
			enableButton("btnCopy");
		}
	}
	
	function copyGiuts008a(){
		new Ajax.Request(contextPath+"/CopyUtilitiesController?action=copyPackPolicyGiuts008a",{
			parameters: {
				lineCd : $F("polLineCd"),
				sublineCd : $F("polSublineCd"),
				issCd : $F("polIssCd"),
				parIssCd : $F("parIssCd"),
				issueYy : $F("polIssueYy"),
				polSeqNo : $F("polPolSeqNo"),
				renewNo : $F("polRenewNo"),
				endtIssCd : $F("polEndtIssCd"),
				endtYy : $F("polEndtYy"),
				endtSeqNo : $F("polEndtSeqNo")
			},
			evalScripts: true,
			asynchronous: true,
			onCreate: function(){
				showNotice("Copying...");	
			},
			onComplete: function(response){
				hideNotice("");
				if(response.responseText.include("Exception occurred.")){
					//showMessageBox(response.responseText.substring(20), "E"); commented and changed by reymon 11132013
					showMessageBox(response.responseText.substring(30), "E");
				}else{
					var res = JSON.parse(response.responseText);
					var policy = $F("polLineCd") +"-"+$F("polSublineCd")+"-"+$F("polIssCd")+"-"+$F("polIssueYy")+"-"+$F("polPolSeqNo")+"-"+$F("polRenewNo");
					var par = $F("parLineCd")+"-"+$F("parIssCd")+"-"+$F("parParYy")+"-"+formatNumberDigits(res.parSeqNo,6)+"-"+formatNumberDigits(res.quoteSeqNo,2);
					$("parParSeqNo").value = formatNumberDigits(res.parSeqNo,6); //marco - 04.30.2013
					showConfirmationOverlay(policy, par);
				}
			}
		});
	}
	
	function showConfirmationOverlay(policy, par) {
		var contentHTML = '<div id="modal_content_summary"></div>';
		 
		summaryOverlay = Overlay.show(contentHTML, {
					id: 'modal_dialog_summary',
	 				title: "Message",
	 				width: 240,
	 				height: 180,
	 				draggable: true,
	 				closable: true
 				}); 
		
		new Ajax.Updater("modal_content_summary", 
				contextPath+"/CopyUtilitiesController?action=confirmPolicySummarized&policy="+policy+"&par="+par, {
			evalScripts: true,
			asynchronous: false,
			onComplete: function (response) {			
				if (!checkErrorOnResponse(response)) {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	$("btnCopy").observe("click", function(){
		doCopy();
	});
	$("btnCancel").observe("click", function(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	$("btnExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	observeReloadForm("reloadForm", showCopyPackagePolicy);
</script>