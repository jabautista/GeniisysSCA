<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="updAddWarrAndClausesMainDiv" name="updAddWarrAndClausesMainDiv">
	<div id="updAddWarrAndClausesMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="btnExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<form id="updAddWarrAndClauses" name="updAddWarrAndClauses">
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
				<label>Policy Information</label>
				<span class="refreshers" style="margin-top: 0;">
					<label name="gro" id="gro" style="margin-left: 5px;">Hide</label> 
			 		<label id="reloadForm" name="reloadForm">Reload Form</label> 
				</span>
			</div>
		</div>
				
		<div class="sectionDiv" id="updAddWarrAndClausesFormDiv" name="updAddWarrAndClausesFormDiv" > 
			<div id="policyInformation" style="margin-top: 10px; margin-bottom: 10px; margin-left: 40px;">
				<div id="policyDiv">
					<table align="center">
						<tr>
							<td class="rightAligned">Policy No.</td>
							<td width="45%">
								<input class="upper required" type="text" name="txtPolLineCd" id="txtPolLineCd" style="width:8%;" title="Line Code" maxlength="2"/>
								<input class="upper" type="text" name="txtPolSublineCd" id="txtPolSublineCd" style="width:19%;" title="Subline Code" maxlength="6"/>
								<input class="upper" type="text" name="txtPolIssCd" id="txtPolIssCd" style="width:8%;" title="Issue Code" maxlength="2"/>
								<input class="upper integerUnformatted" type="text" name="txtPolIssueYy" id="txtPolIssueYy" style="width:8%;" title="Issue Year" maxlength="2" lpad="2" />
								<input class="upper integerUnformatted" type="text" name="txtPolSeqNo" id="txtPolSeqNo" style="width:19%;" title="Policy Sequence No" maxlength="7" lpad="7" />
								<input class="upper integerUnformatted" type="text" name="txtPolRenewNo" id="txtPolRenewNo" style="width:8%;" title="Renew No" maxlength="2" lpad="2" />
								<span>
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="hrefPolicyNo" name="hrefPolicyNo" alt="Go" style="margin-top: 2px; border: 0px;"/>
								</span>
							</td>
							<td class="rightAligned" style="width: 100px;">Endt No.</td>
							<td class="leftAligned">
								<input id="txtEndtNo" type="text" readonly="readonly" value="" style="width: 220px; border: 1px solid gray;" name="txtEndtNo">
							</td>
						</tr>
					</table>
				</div>
				<div id="parDiv" style="margin-left: 13px;">
					<table align="center">
						<tr>
							<td class="rightAligned">PAR No.</td>
							<td width="45%">
								<input class="upper required" type="text" name="txtParLineCd" id="txtParLineCd" style="width:8%;" title="PAR Line Code" maxlength="2"/>
								<input class="upper" type="text" name="txtParIssCd" id="txtParIssCd" style="width:8%;" title="PAR Issue Code" maxlength="2"/>
								<input class="upper integerUnformatted" type="text" name="txtParYy" id="txtParYy" style="width:8%;" title="PAR Year" maxlength="2" lpad="2" />
								<input class="upper integerUnformatted" type="text" name="txtParSeqNo" id="txtParSeqNo" style="width:31%;" title="PAR Sequence No" maxlength="6" lpad="6" />
								<input class="upper integerUnformatted" type="text" name="txtParQuoteSeqNo" id="txtParQuoteSeqNo" style="width:19%;" title="Quote Sequence No" maxlength="2" lpad="2" />
								<span>
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="hrefParNo" name="hrefParNo" alt="Go" style="margin-top: 2px;"/>
								</span>
							</td>
							<td class="rightAligned">Assured Name</td>
							<td class="leftAligned">
								<input id="txtAssdName" type="text" readonly="readonly" value="" style="width: 220px; border: 1px solid gray;" name="txtAssdName">
							</td>
						</tr>						
					</table>
				</div>
			</div>
		</div>
		
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
				<label title="Warranties And Clauses">Warranties And Clauses</label>
				<span class="refreshers" style="margin-top: 0;">
					<label name="gro" id="gro" style="margin-left: 5px;" name="gro">Hide</label>
				</span>
			</div>
		</div>
				
		<div id="warrantyAndClauseDiv" name="warrantyAndClauseDiv" class="sectionDiv">
			<jsp:include page="/pages/underwriting/utilities/updateInformation/updateAddWarrantiesAndClauses/warrantyAndClausesTable.jsp"></jsp:include>
			<div id="wcFormDiv" name="wcFormDiv" style="margin: 10px;" changeTagAttr="true">
				<table align="center">
					<tr style="display: none;" id="message" name="message">
						<td colspan="6" style="padding: 0;"><label style="margin: 0; float: right; text-align: left; font-size: 9px; padding: 2px; background-color: #98D0FF; width: 250px;">Adding, please wait...</label></td>
					</tr>
					<tr>
						<td class="rightAligned">Warranty Title</td>
						<td colspan="4" class="leftAligned">
							<span class="required lovSpan" style="width: 430px;">
								<input type="hidden" id="hidWcCd" name="hidWcCd"> 
								<input type="hidden" id="hidWcCd2" name="hidWcCd2">
								<input type="hidden" id="hidWcTitle" name="hidWcTitle">
								<input type="text" id="txtWarrantyTitle" name="txtWarrantyTitle" readonly="readonly" style="width: 405px; float: left; border: none; height: 13px; margin: 0;" class="required" max="100" ></input>								
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchWarrantyTitle" name="searchWarrantyTitle" alt="goWcTitle" style="height: 18px;" class="hover" />
							</span>
						</td>
						<td class="leftAligned" colspan="3">
							<div style="border: 1px solid gray; height: 20px; width: 200px;">
								<textarea id="inputWarrantyTitle2" maxlength="100" style="width: 171px; height: 13px; border: medium none; resize: none;" name="inputWarrantyTitle2" type="text"></textarea>
								<img id="editWarrantyTitle2" alt="Edit" style="width: 14px; height: 14px; margin: 3px; float: right;" src="/Geniisys/images/misc/edit.png"></td>
							</div>
					</tr>
					<tr>
						<td class="rightAligned">Type</td>
						<td class="leftAligned" width="120px;"><input type="text" id="inputWarrantyType" name="inputWarrantyType" style="width: 100px;" readonly="readonly"></input></td>
						<td class="rightAligned">Print Sequence No. </td>
						<td class="leftAligned"><input type="text" id="inputPrintSeqNo" class="required integerNoNegativeUnformatted" maxlength="2" style="width: 40px;" errorMsg="Invalid Print Sequence No. Value should be from 1 to 99."/></td>
						<td class="rigthAligned">Print Switch</td>
						<td class="leftAligned"><input type="checkbox" id="inputPrintSwitch" name="inputPrintSwitch" value="Y"></td>
						<td class="rightAligned">Change Tag</td>
						<td class="leftAligned" width="60px;"><input type="checkbox" id="inputChangeTag" name="inputChangeTag" value="Y"/></td>
					</tr>
					<tr>
						<td class="rightAligned">Warranty Text</td>
						<td colspan="7" class="leftAligned">
							<div style="border: 1px solid gray; width: 642px;">
								<input type="hidden" id="hidOrigWarrantyText" name="hidOrigWarrantyText"></input>
								<!-- <input type="text" id="inputWarrantyText" name="inputWarrantyText" style="width: 610px; border: none; height: 13px;"></input>  commented out by jeffdojello 04.30.2013-->
								<textarea id="inputWarrantyText" name="inputWarrantyText" style="width: 610px; border: none; height: 13px; resize: none;" tabindex=210 maxLength="32767" ></textarea> <!-- added by jeffdojello 04.30.2013 -->
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editWarrantyText" />
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Remarks</td>
						<td colspan="7" class="leftAligned">
							<div style="border: 1px solid gray; width: 642px;">
								<!-- <input type="text" id="inputWcRemarks" name="inputWcRemarks" style="width: 610px; border: none; height: 13px;"/> commented out by jeffdojello 05.07.2013-->
								<textarea id="inputWcRemarks" name="inputWcRemarks" style="width: 610px; border: none; height: 13px; resize: none;" tabindex=210 maxLength="2000"></textarea> <!-- added by jeffdojello 05.07.2013 -->
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editWcRemarks" />
							</div>
						</td>
					</tr>
					<tr style="visibility: hidden;">
						<input type="hidden" name="hidPolicyId" id="hidPolicyId" value=""/>
						<input type="hidden" name="hidLineCd" id="hidLineCd" value=""/>
						<input type="hidden" name="hidWcCd3" id="hidWcCd3" value=""/>
						<input type="hidden" name="hidWcText" id="hidWcText" value=""/>
						
						<input type="hidden" id="hidPolLineCd" name="hidPolLineCd"/>
						<input type="hidden" id="hidPolSublineCd" name="hidPolSublineCd"/>
						<input type="hidden" id="hidPolIssCd" name="hidPolIssCd"/>
						<input type="hidden" id="hidPolIssueYy" name="hidPolIssueYy"/>
						<input type="hidden" id="hidPolSeqNo" name="hidPolSeqNo"/>
						<input type="hidden" id="hidPolRenewNo" name="hidPolRenewNo"/>
						
						<input type="hidden" id="hidParLineCd" name="hidParLineCd"/>
						<input type="hidden" id="hidParIssCd" name="hidParIssCd"/>
						<input type="hidden" id="hidParYy" name="hidParYy"/>
						<input type="hidden" id="hidParSeqNo" name="hidParSeqNo"/>
						<input type="hidden" id="hidParQuoteSeqNo" name="hidParQuoteSeqNo"/>
						<input type="hidden" id="hidEndtNo" name="hidEndtNo"/> 
						<input type="hidden" id="hidAssdName" name="hidAssdName"/> 
						
						<input type="hidden" id="hidMaxPrintSeqno" name="hidMaxPrintSeqno">  								
								  
					</tr>
				</table>
				<div style="width: 100%; margin: 10px 0;" align="center" >
					<input type="button" class="button" style="width: 60px;" id="btnAdd" name="btnAdd" value="Add" />
					<input type="button" class="disabledButton" style="width: 60px;" id="btnDelete" name="btnDelete" value="Delete" disabled="disabled" />
				</div>
			</div>
		</div>
		
		<div class="buttonsDiv">
			<table align="center">
				<tr>
					<td>
						<input type="button" class="button" id="btnCancel" value="Cancel">
						<input type="button" class="button" id="btnSave" value="Save">
					</td>
				</tr>
			</table>		
		</div>
	</form>
</div>
<script> 
	makeInputFieldUpperCase();
	initializeAccordion();
	initializeAll();
	addStyleToInputs();
	hideNotice();
	
	//show LOV for Policy No.
	$("hrefPolicyNo").observe("click", function() {
		if (checkAllRequiredFieldsInDiv("policyDiv")) {
			if (changeTag == 1) {
				showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function() {
						objGipis171.saveGIPIPolWC();
					}, function() {
						//showPolicyListingForGIPIS171();
						showListing();
						changeTag = 0;
					}, "");
				return false;
			} else {
				//showPolicyListingForGIPIS171();
				showListing();
			}
		}
	});
	
	/**
	*show LOV for PAR no.
	*/
	$("hrefParNo").observe("click", function() {
		if (checkAllRequiredFieldsInDiv("parDiv")) {
			if (changeTag == 1) {
				showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function() {
						objGipis171.saveGIPIPolWC();
					}, function() {
						//showPolicyListingForGIPIS171();
						showListing();
						changeTag = 0;
					}, "");
				return false;
			} else {
				//showPolicyListingForGIPIS171();
				showListing();
			}
		}
	});
	
	/* [by Kris 06.03.2013 ] 
	 * This function has additional conditions before calling the function showPolicyListingForGIPIS171() 
	 * If no records retrieved, display messagebox instead of the empty LOV
	*/
	function showListing(){
		/* edited by MarkS 10.19.2016 SR5769 OPTIMIZATION */
		showPolicyListingForGIPIS171();
		/* commented out by MarkS 10.19.2016 SR5769 OPTIMIZATION  */
		/* var cond = validateTextFieldLOV("/UnderwritingLOVController?action=getGIPIS171LOV"
						+ "&lineCd=" + encodeURIComponent($F("txtPolLineCd")) + "&sublineCd=" + encodeURIComponent($F("txtPolSublineCd"))
						+ "&issCd=" + encodeURIComponent($F("txtPolIssCd")) + "&issueYy=" + $F("txtPolIssueYy")
						+ "&polSeqNo=" + $F("txtPolSeqNo") + "&renewNo=" + $F("txtPolRenewNo")
						+ "&parLineCd=" + encodeURIComponent($F("txtParLineCd")) + "&parIssCd=" + encodeURIComponent($F("txtParIssCd"))
						+ "&parYy=" + $F("txtParYy") + "&parSeqNo=" + $F("txtParSeqNo")
						+ "&parQuoteSeqNo=" + $F("txtParQuoteSeqNo") + "&page=1"
						,null
						,"Searching Policy Listing, please wait...");
		
		if (cond >= 1) {  
			showPolicyListingForGIPIS171();
		  } else if(cond == 0) {
			// clear fields and notify user
			var reqDivArray = ["policyDiv", "parDiv"];
			for(var i=0; i<reqDivArray.length; i++){
				$$("div#"+reqDivArray[i]+" input[type='text']").each(function (a) {
					$(a).clear();
				});
			}
			showMessageBox("Query caused no records to be retrieved. Re-enter.", imgMessage.INFO);
		}  */ /* commented out by MarkS 10.19.2016 SR5769 OPTIMIZATION  */
	}
	
	/**
	*loads policy no. par no. endt no. assured name
	*to textfields
	*gzelle 12.27.2012
	*/
	function loadSelectedRecord(row) {
			$("txtPolLineCd").value   	= unescapeHTML2(row.lineCd);
			$("txtPolSublineCd").value	= unescapeHTML2(row.sublineCd);
			$("txtPolIssCd").value   	= unescapeHTML2(row.issCd);
			$("txtPolIssueYy").value    = formatNumberDigits(row.issueYy,2);
			$("txtPolSeqNo").value     	= formatNumberDigits(row.polSeqNo,7);
			$("txtPolRenewNo").value   	= formatNumberDigits(row.renewNo,2);
			$("txtParLineCd").value		= unescapeHTML2(row.parLineCd);
			$("txtParIssCd").value   	= unescapeHTML2(row.parIssueCd);
			$("txtParYy").value    		= formatNumberDigits(row.parYy,2);
			$("txtParSeqNo").value     	= formatNumberDigits(row.parSeqNo,6);
			$("txtParQuoteSeqNo").value = formatNumberDigits(row.quoteSeqNo,2);
			$("txtEndtNo").value     	= row.endtNo;
			$("txtAssdName").value   	= unescapeHTML2(row.assdName); //unescapedHTML2 added by jeffdojello 04.30.2013
			
			//hidden last valid values
			$("hidPolLineCd").value   	= unescapeHTML2(row.lineCd);
			$("hidPolSublineCd").value	= unescapeHTML2(row.sublineCd);
			$("hidPolIssCd").value   	= unescapeHTML2(row.issCd);
			$("hidPolIssueYy").value    = formatNumberDigits(row.issueYy,2);
			$("hidPolSeqNo").value     	= formatNumberDigits(row.polSeqNo,6);
			$("hidPolRenewNo").value   	= formatNumberDigits(row.renewNo,2);
			$("hidParLineCd").value		= unescapeHTML2(row.parLineCd);
			$("hidParIssCd").value   	= unescapeHTML2(row.parIssueCd);
			$("hidParYy").value    		= formatNumberDigits(row.parYy,2);
			$("hidParSeqNo").value     	= formatNumberDigits(row.parSeqNo,6);
			$("hidParQuoteSeqNo").value = formatNumberDigits(row.quoteSeqNo,2);
			$("hidEndtNo").value     	= row.endtNo;
			$("hidAssdName").value   	= unescapeHTML2(row.assdName);
			$("hidLineCd").value     	= unescapeHTML2(row.lineCd);
			$("hidPolicyId").value   	= row.policyId;
			objGipis171.warrClaUtilTableGrid.url = contextPath+"/UpdateUtilitiesController?action=getWarrClaTableGrid&policyId="+row.policyId;
			objGipis171.warrClaUtilTableGrid._refreshList();
			
			disableInputField("txtPolLineCd");
			disableInputField("txtPolSublineCd");
			disableInputField("txtPolIssCd");
			disableInputField("txtPolIssueYy");
			disableInputField("txtPolSeqNo");
			disableInputField("txtPolRenewNo");
			disableInputField("txtParLineCd");
			disableInputField("txtParIssCd");
			disableInputField("txtParYy");
			disableInputField("txtParSeqNo");
			disableInputField("txtParQuoteSeqNo");
			disableInputField("txtEndtNo");
			disableInputField("txtAssdName");
			disableSearch("hrefPolicyNo");
			disableSearch("hrefParNo");
	}
	
	/*
	*resets to last valid value 
	*gzelle 12.27.2012
	*/
	function setToLastValidValue() {
		$("txtPolLineCd").value   	= $("hidPolLineCd").value;
		$("txtPolSublineCd").value	= $("hidPolSublineCd").value;
		$("txtPolIssCd").value   	= $("hidPolIssCd").value;
		$("txtPolIssueYy").value    = $("hidPolIssueYy").value;
		$("txtPolSeqNo").value     	= $("hidPolSeqNo").value;
		$("txtPolRenewNo").value   	= $("hidPolRenewNo").value;
		
		$("txtParLineCd").value		= $("hidParLineCd").value;
		$("txtParIssCd").value   	= $("hidParIssCd").value;
		$("txtParYy").value    		= $("hidParYy").value;
		$("txtParSeqNo").value     	= $("hidParSeqNo").value;
		$("txtParQuoteSeqNo").value = $("hidParQuoteSeqNo").value;
		
		$("txtEndtNo").value     	= $("hidEndtNo").value;
		$("txtAssdName").value   	= $("hidAssdName").value;
	}
	
	setModuleId("GIPIS171");
	setDocumentTitle("Update/Add Warranties and Clauses");
	objGipis171.loadSelectedRecord = loadSelectedRecord;
	objGipis171.setToLastValidValue = setToLastValidValue;
	observeReloadForm("reloadForm", showUpdateAddWarrantiesAndClauses);
	
	observeCancelForm("btnExit", function() {
		pAction = pageActions.save;
		saveGIPIPolWC();}, function(){
			changeTag = 0;
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main" , null);
	});
	
	/*
	*gzelle 12.14.2012 show confirmation if changes exist
	*$("btnExit").observe("click", function () {
	*	goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	*});
	*/
	initializeAll();
</script>