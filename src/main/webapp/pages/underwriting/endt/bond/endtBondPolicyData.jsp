<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="bondMainDiv" name="bondMainDiv" style="margin-top: 1px; display: none;">
	<form id="bondForm" name="bondForm">
		<jsp:include page="/pages/underwriting/subPages/parInformation.jsp"></jsp:include>
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="outerDiv">
				<label id="">Bond Basic Information</label>
				<span class="refreshers" style="margin-top: 0;">
		 			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
				</span>
			</div>
		</div>
		<div id="bondPolicyDataDiv" name="bondPolicyDataDiv" class="sectionDiv" style="width: 100%;" changeTagAttr="true">
			<table align="center" style="margin-top: 10px; margin-bottom: 10px;">
				<tr>
					<td class="rightAligned" style="width: 20%;">Obligee</td>
					<td class="leftAligned" colspan="3">
						<select id="obligee" name="obligee" style="width: 99.5%;" class="required">
							<option value=""></option>
							<c:forEach var="obl" items="${obligeeListing}" varStatus="ctr">
								<option value="${obl.obligeeNo}" <c:if test="${obl.obligeeNo eq bond.obligeeNo}"> selected="selected"</c:if> address="${obl.address}">${fn:escapeXml(obl.obligeeName)}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
					<td class="rightAligned" style="width: 20%;">Bond Undertaking</td>
					<td class="leftAligned" colspan="3">
					    <div style="border: 1px solid gray; height: 20px; width: 99%;" class="required">
							<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" id="bondDtl" class="leftAligned required" name="bondDtl" style="width: 90%; border: none; height: 13px;" ignoreDelKey="1">${fn:escapeXml(bond.bondDtl)}</textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editBondDtl" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 20%;">Indemnity</td>
					<td class="leftAligned" colspan="3">
					    <div style="border: 1px solid gray; height: 20px; width: 99%;">
							<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" id="indemnityText" class="leftAligned" name="indemnityText" style="width: 90%; border: none; height: 13px;" ignoreDelKey="1">${fn:escapeXml(bond.indemnityText)}</textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editIndemnityText" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 20%;">Notary</td>
					<td class="leftAligned" colspan="3">
						<select id="dspNPName" name="dspNPName" style="width: 99.5%;">
							<option></option>
							<c:forEach var="np" items="${notaryPublicListing}" varStatus="ctr">
								<option <c:if test="${np.npNo eq bond.npNo}">selected="selected"</c:if> value="${np.npNo}" >  ${fn:escapeXml(np.npName)}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 20%;">Clause Type</td>
					<td class="leftAligned" style="width: 30%;">
						<select id="dspClauseType" name="dspClauseType" style="width: 100%" class="required">
							<c:forEach var="clause" items="${bondClauseListing}" varStatus="ctr">
								<option value="${clause.clauseType}" waiverLimit="${clause.waiverLimit}">${fn:escapeXml(clause.clauseDesc)}</option>
							</c:forEach>
							<c:if test="${empty bondClauseListing}">
								<option value="" waiverLimit=""></option>
							</c:if>
						</select>
					</td>
					<td class="rightAligned" style="width: 20%;">Collateral Flag</td>
					<td class="leftAligned" style="width: 30%;">
						<select id="dspCollFlag" name="dspCollFlag" style="width: 99%;">
							<option value="Q">REQUIRED</option>
							<option value="S">SUBMITTED</option>
							<option value="W">WAIVED</option>
							<option value="C">CANCELLED</option>
							<option value="R">RELEASED</option>
							<option value="P">PAID</option>
							<option value="N">NOT REQUIRED</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 20%;">Waiver Limit</td>
					<td class="leftAligned" style="width: 30%;">
						<input id="dspWaiverLimit" type="text" name="dspWaiverLimit" class="money" style="width: 95%;" lastValidValue="" value="${bond.waiverLimit}<c:if test="${empty clause.waiverLimit}"></c:if>"/>
					</td>
					<td class="rightAligned" style="width: 20%;">Contract Date</td>
					<td class="leftAligned" style="width: 30%;">
						<span style="float: left; width: 97.5%; border: 1px solid gray;">
							<input readonly="readonly" style="float: left; width: 85%; border: none;" id="contractDate" name="contractDate" type="text" value="<fmt:formatDate value="${bond.contractDate}" pattern="MM-dd-yyyy"/>" ignoreDelKey="1"/>
							<img id="hrefContractDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('contractDate'),this, null);" style="margin-top: 2px;" alt="Contract Date" />
						</span>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 20%;">Contract Details</td>
					<td class="leftAligned" colspan="3">
						<div style="border: 1px solid gray; height: 20px; width: 99%;">
							<textarea onKeyDown="limitText(this,75);" onKeyUp="limitText(this,75);" id="contractDtl" class="leftAligned" name="contractDtl" style="width: 90%; border: none; height: 13px;" ignoreDelKey="1">${fn:escapeXml(bond.contractDtl)}</textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editContractDtl" />
						</div>
					</td>
				</tr>
				<tr id="trPlaintiffDtl" style="display: none">
					<td class="rightAligned" style="width: 20%;">Plaintiff Details</td>
					<td class="leftAligned" colspan="3">
						<div style="border: 1px solid gray; height: 20px; width: 99%;">
							<textarea onKeyDown="limitText(this,250);" onKeyUp="limitText(this,250);" id="plaintiffDtl" class="leftAligned" name="plaintiffDtl" style="width: 90%; border: none; height: 13px;" ignoreDelKey="1">${fn:escapeXml(bond.plaintiffDtl)}</textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editPlaintiffDtl" />
						</div>
					</td>
				</tr>
				<tr id="trDefendantDtl" style="display: none">
					<td class="rightAligned" style="width: 20%;">Defendants Details</td>
					<td class="leftAligned" colspan="3">
						<div style="border: 1px solid gray; height: 20px; width: 99%;">
							<textarea onKeyDown="limitText(this,250);" onKeyUp="limitText(this,250);" id="defendantDtl" class="leftAligned" name="defendantDtl" style="width: 90%; border: none; height: 13px;" ignoreDelKey="1">${fn:escapeXml(bond.defendantDtl)}</textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editDefendantDtl" />
						</div>
					</td>
				</tr>
				<tr id="trCivilCaseNo" style="display: none">
					<td class="rightAligned" style="width: 20%;">Civil Case Number</td>
					<td class="leftAligned" colspan="3">
						<input id="civilCaseNo" name="civilCaseNo" class="leftAligned" type="text" maxlength="50" style="width: 98%;" value="${fn:escapeXml(bond.civilCaseNo)}" ignoreDelKey="1"/>
					</td>
				</tr>
			</table>
		</div>
		<!--<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="outerDiv">
				<label id="">Co-Signors List</label>
				<span class="refreshers" style="margin-top: 0;">
		 			<label id="showCosignors" name="gro" style="margin-left: 5px;">Show</label>
				</span>
			</div>
		</div>
		<div id="cosignorsListingTableDiv" name="cosignorsListingTableDiv" style="display: none;">

		</div>-->
		<div id="hiddenDetailsDiv" name="hiddenDetailsDiv">
			<input id="obligeeNo" name="obligeeNo" type="hidden" value="${bond.obligeeNo}"/>
			<input id="initialObligeeNo" name="initialObligeeNo" type="hidden"/>
			<input id="address" name="address" type="hidden">
			<input id="prinId" name="prinId" type="hidden" value="${bond.prinId}"/>
			<input id="clauseType" name="clauseType" type="hidden" value="${empty bond.clauseType ? '1' :bond.clauseType}"/>
			<input id="collFlag" name="collFlag" type="hidden" value="${bond.collFlag}"/>
			<input id="npNo" name="npNo" type="hidden" value="${bond.npNo}"/>
			<input id="wInvoiceExists" name="wInvoiceExists" type="hidden" value="${wInvoiceExists}"/>
			<input id="deleteBillsSw" name="deleteBillsSw" type="hidden" value="N"/>
			<input id="coPrinSw" name="coPrinSw" type="hidden" value="${bond.coPrinSw}"/>
			<input id="cosignorsPageChangedSw" name="cosignorsPageChangedSw" type="hidden" value="N"/>
			<input id="cosignorIsLoaded" name="cosignorIsLoaded" type="hidden" value="N"/>
		</div>
		<div id="buttonsDiv" align="center">
			<!--<input type="button" id="btnPrincipalSignatory" name="btnPrincipalSignatory" class="button" value="Principal Signatory" style="margin-top: 10px; width: 120px;"/>
			<input type="button" id="btnObligee" name="btnObligee" class="button" value="Obligee" style="margin-top: 10px; width: 100px;"/>
			<input type="button" id="btnNotaryPublic" name="btnNotaryPublic" class="button" value="Notary Public" style="margin-top: 10px; width: 100px;"/>
			--><input type="button" id="btnCancel" name="btnCancel" class="button" value="Cancel" style="margin-top: 10px; width: 90px;"/>
			<input type="button" id="btnSave" name="btnSave" class="button" value="Save" style="margin-top: 10px; width: 90px;"/>
			<br/><br/><br/>
		</div>
	</form>
</div>
<script>
	/**
		Irwin Tabisora, 05.11.11
	*/
	var onExit = false;
	
	function saveEndtBondPolicyData(){
		new Ajax.Request(contextPath+"/GIPIWBondBasicController?action=saveEndtBondPolicyData&globalParId="+$F("globalParId"),{
			method: "POST",
			evalScripts: true,
			asynchronous: false,
			postBody: Form.serialize("bondForm"),
			onCreate: function () {			
				showNotice("Saving, please wait...");
			},
			onComplete: function (response)	{
				hideNotice();
				if (checkErrorOnResponse(response)) {
					if ("SUCCESSFUL" == response.responseText){
						updateParParameters(); // andrew - 03.24.2011 - added this line to enable menu if saving is successful
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
							if(onExit){ //marco - 10.09.2013 - show success message before redirecting to page
								exitForm();
							}else{
								if(nvl(lastAction, null) != null){
									lastAction();
									lastAction = "";
								}
								changeTag = 0;
							}
						});
					} else {
						showErrorMessage("saveEndtBondPolicyData", e);
					}
				}		
			}
		});	
	}
	
	//marco - lastValidValue for standard message - 10.09.2013
	$("dspWaiverLimit").observe("focus", function(){
		$("dspWaiverLimit").setAttribute("lastValidValue", $F("dspWaiverLimit"));
	});
	
	$("dspWaiverLimit").observe("change", function(){
		if(validateWaiverLimit("dspWaiverLimit")){
			$("dspWaiverLimit").value = formatCurrency($F("dspWaiverLimit"));
		}else{
			//customShowMessageBox("Field must be of form 99,999,999,999,990.99.", imgMessage.INFO, "dspWaiverLimit");
			showWaitingMessageBox("Invalid Waiver Limit. Valid value should be from -99,999,999,999,999.99 to 99,999,999,999,999.99", "I", 
				function(){
					$("dspWaiverLimit").value = $("dspWaiverLimit").getAttribute("lastValidValue");
					$("dspWaiverLimit").focus();
				});
		}
		
	});

	$("bondDtl").observe("keyup", function () {
		limitText(this, 2000);
	});
	
	$("editBondDtl").observe("click", function () {
		showOverlayEditor("bondDtl", 2000, $("bondDtl").hasAttribute("readonly"), function(){
			changeTag = 1;
		});
	});

	$("indemnityText").observe("keyup", function () {
		limitText(this, 2000);
	});
	
	$("editIndemnityText").observe("click", function () {
		showOverlayEditor("indemnityText", 2000, $("indemnityText").hasAttribute("readonly"), function(){
			changeTag = 1;
		});
	});

	$("contractDtl").observe("keyup", function () {
		limitText(this, 75);
	});
	
	$("editContractDtl").observe("click", function () {
		showOverlayEditor("contractDtl", 75, $("contractDtl").hasAttribute("readonly"), function(){
			changeTag = 1;
		});
	});
	
	function validateWaiverLimit(paramField){
		var isValid = true;
		var decimalLength = getDecimalLength($F(paramField));
		//var locCurrAmtLength = unformatCurrency(paramField).toString().length - (decimalLength + 1);//(Math.round((unformatCurrency(paramField))*100)/100).toString().length;
		if (decimalLength > 2) {
			isValid = false;
			return isValid;
		}
		/* if (locCurrAmtLength > 14 || isNaN($F(paramField))){ //|| unformatCurrency(paramField) < 0
			isValid = false;
		} */
		//marco - 10.09.2013
		if(parseFloat(unformatCurrencyValue($F(paramField))) > parseFloat(99999999999999.99)){
			isValid = false;
		}else if(parseFloat(unformatCurrencyValue($F(paramField))) < parseFloat(-99999999999999.99)){
			isValid = false;
		}else if(isNaN($F(paramField))){
			isValid = false;
		}
		return isValid;
	}

	/*
	$("dspClauseType").observe("change", function(){
		if(dspCollFlag == 'W'){
			$("dspWaiverLimit").disabled = false;
		}else{
			$("dspWaiverLimit").value = '';
			$("dspWaiverLimit").disabled = true;
		}
	});*/
	
	//marco - 12.10.2013
	$("dspClauseType").observe("focus", function(){
		$("dspClauseType").writeAttribute("lastValidValue", $F("dspClauseType"));
	});
	$("dspClauseType").observe("change", function(){
		if ("1" == $F("wInvoiceExists")){
			showConfirmBox("Delete Bill Information", "This will delete Bill information", "Continue", "Cancel", setDeleteBillsSwitch,
				function(){
					$("dspClauseType").value = $("dspClauseType").readAttribute("lastValidValue");
				});
		}
	});
	//end 12.10.2013
	
	$("dspCollFlag").observe("change", function(){
		if($F("dspCollFlag") == 'W'){
			$("dspWaiverLimit").removeAttribute("readonly");
			$("dspWaiverLimit").removeClassName("disabled");
		}else{
			$("dspWaiverLimit").setAttribute("readonly", "readonly");
			$("dspWaiverLimit").addClassName("disabled");
			$("dspWaiverLimit").value = "0.00";
			$("dspWaiverLimit").setAttribute("lastValidValue", "0.00");
		}
	});	

	function setFields(){
		try {
			var collFlag = $F("collFlag");
			var cf = $("dspCollFlag");
			for (var i=0; i<cf.length; i++)	{
				if (cf.options[i].value == collFlag)	{
					cf.selectedIndex = i;
				}
			}
			$("dspWaiverLimit").setAttribute("readonly", "readonly");
			$("dspWaiverLimit").addClassName("disabled");
			if ($F("contractDate") == '') {
				$("contractDate").value = dateFormat($F("globalInceptDate"),"mm-dd-yyyy"); //marco - 10.10.2013 changed from objGIPIWPolbas.inceptDate
			}else if($F("dspCollFlag") == 'W'){
				$("dspWaiverLimit").removeAttribute("readonly");
				$("dspWaiverLimit").removeClassName("disabled");
				//$("dspWaiverLimit").value = formatCurrency($("dspWaiverLimit").value);
			}
			var clauseType = $F("clauseType");
			var ct = $("dspClauseType");
			for (var i=0; i<ct.length; i++)	{
				if (ct.options[i].value == clauseType)	{
					ct.selectedIndex = i;
				}
			}
		} catch(e) {
			showErrorMessage("setFields", e);			
		}
		
	}
	
	//marco - 10.09.2013
	changeTag = 0;
	observeSaveForm("btnSave", function(){
		if(checkAllRequiredFieldsInDiv("bondPolicyDataDiv"))
			saveEndtBondPolicyData();
	});
	observeChangeTagOnDate("hrefContractDate", "contractDate", null);
	
	function exitForm(){
		changeTag = 0;
		goBackToParListing();
	}
	
	function confirmExit(){
		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
				function(){
					onExit = true;
					saveEndtBondPolicyData();
				}, exitForm, "");
		}else{
			exitForm();
		}
	}
	
	//observeCancelForm("btnCancel", saveEndtBondPolicyData, goBackToParListing);
	$("btnCancel").observe("click", confirmExit);
	//end of modifications
	
	setFields();
	setModuleId("GIPIS165A");
	setDocumentTitle("Enter Bond Policy Data Endorsement");
	initializeAccordion();
	initializeAll();
	initializeAllMoneyFields();
	//initializeChangeTagBehavior(saveEndtBondPolicyData); Gzelle 03052015 moved at the end
	observeReloadForm("reloadForm", showEndtBondPolicyDataPage);
	
	if ("${showJCLDetails}" == "Y" && objUWParList.sublineCd.substr(0, 3) == "JCL"){
		$("trPlaintiffDtl").show();
		$("trDefendantDtl").show();
		$("trCivilCaseNo").show();
	}
	
	$("editPlaintiffDtl").observe("click", function () {
		//showEditor("plaintiffDtl", 250);	Gzelle 03052015 replaced with showOverlayEditor
		showOverlayEditor("plaintiffDtl", 250, $("plaintiffDtl").hasAttribute("readonly"), function(){
			changeTag = 1;
		});
	});
	
	$("editDefendantDtl").observe("click", function () {
		//showEditor("defendantDtl", 250); Gzelle 03052015 replaced with showOverlayEditor
		showOverlayEditor("defendantDtl", 250, $("defendantDtl").hasAttribute("readonly"), function(){
			changeTag = 1;
		});
	});

	//Gzelle 03052015
	function cancellationEndt(){
		$$("input[type=text]").each(function(txt){
			txt.readOnly = true;
		});
		$$("textarea").each(function(area){
			area.readOnly = true;
		});
		$$("select").each(function(sel){
			sel.disable();
		});
		$$("img").each(function(img){
			var src = img.src;
			var id = img.id;
			if(nvl($(id), null) != null){
				if(src.include("but_calendar.gif")){
					img.src = contextPath + "/images/misc/disabledCalendarIcon.gif";
					$(id).stopObserving("click");
					disableDate(id);
				}
			}
		});
		disableButton("btnSave");
	}
	
	//Gzelle 03052015
	if(objGIPIWPolbas.cancelType == 1 || objGIPIWPolbas.cancelType == 2 || objGIPIWPolbas.cancelType == 3 || objGIPIWPolbas.cancelType == 4){
		showMessageBox("This is a cancellation type of endorsement, update/s of any details will not be allowed.", imgMessage.INFO);
		cancellationEndt();
	}
	
	initializeChangeTagBehavior(saveEndtBondPolicyData);
</script>