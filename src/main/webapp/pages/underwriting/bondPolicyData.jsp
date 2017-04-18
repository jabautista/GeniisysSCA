<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="bondMainDiv" name="bondMainDiv" style="margin-top: 1px; display: none;" >
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
			<table align="center" style="margin-top: 10px;">
				<tr>
					<td class="rightAligned" style="width: 20%;">Obligee</td>
					<td class="leftAligned" colspan="3">
						<select id="obligee" name="obligee" style="width: 99.5%;" class="required">
							<option value=""></option>
							<c:forEach var="obl" items="${obligeeListing}" varStatus="ctr">
								<option value="${obl.obligeeNo}" address="${obl.address}">${fn:escapeXml(obl.obligeeName)}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 20%;">Principal Signatory</td>
					<td class="leftAligned" colspan="3">
						<select id="dspPrinSignor" name="dspPrinSignor" style="width: 99.5%;" class="required">
							<option></option>
							<c:forEach var="sig" items="${prinSigListing}" varStatus="ctr">
								<option value="${sig.prinId}" designation="${sig.designation}">${fn:escapeXml(sig.prinSignor)}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 20%;">Designation</td>
					<td class="leftAligned" colspan="3">
						<input id="designation" name="designation" class="leftAligned" type="text" maxlength="30" style="width: 98%;" value="${fn:escapeXml(bond.designation)}" readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 20%;">Bond Undertaking</td>
					<td class="leftAligned" colspan="3">
					    <div style="border: 1px solid gray; height: 20px; width: 99%;" class="required">
							<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" id="bondDtl" class="leftAligned" name="bondDtl" style="width: 90%; border: none; height: 13px; background-color: transparent;">${fn:escapeXml(bond.bondDtl)}</textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editBondDtl" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 20%;">Indemnity</td>
					<td class="leftAligned" colspan="3">
					    <div style="border: 1px solid gray; height: 20px; width: 99%;">
							<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" id="indemnityText" class="leftAligned" name="indemnityText" style="width: 90%; border: none; height: 13px;">${fn:escapeXml(bond.indemnityText)}</textarea>
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
								<option value="${np.npNo}">${fn:escapeXml(np.npName)}</option>
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
							<option value="N">NOT REQUIRED</option>
							<option value="R">REQUIRED</option>
							<option value="W">WAIVED</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 20%;">Waiver Limit</td>
					<td class="leftAligned" style="width: 30%;">
						<input id="dspWaiverLimit" type="text" name="dspWaiverLimit" class="money" style="width: 95%;" value="${bond.waiverLimit}<c:if test="${empty clause.waiverLimit}">0.00</c:if>" readonly="readonly"/>
					</td>
					<td class="rightAligned" style="width: 20%;">Contract Date</td>
					<td class="leftAligned" style="width: 30%;">
						<span style="float: left; width: 97.5%; border: 1px solid gray;">
							<input readonly="readonly" style="float: left; width: 85%; border: none;" id="contractDate" name="contractDate" type="text" value="<fmt:formatDate value="${bond.contractDate}" pattern="MM-dd-yyyy"/>"/>
							<img id="hrefContractDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('contractDate'),this, null);" style="margin: 0; display: none;" alt="Contract Date" />
						</span>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 20%;">Contract Details</td>
					<td class="leftAligned" colspan="3">
						<div style="border: 1px solid gray; height: 20px; width: 99%;">
							<textarea onKeyDown="limitText(this,75);" onKeyUp="limitText(this,75);" id="contractDtl" class="leftAligned" name="contractDtl" style="width: 90%; border: none; height: 13px;">${fn:escapeXml(bond.contractDtl)}</textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editContractDtl" />
						</div>
					</td>
				</tr>
				<tr id="trPlaintiffDtl" style="display: none">
					<td class="rightAligned" style="width: 20%;">Plaintiff Details</td>
					<td class="leftAligned" colspan="3">
						<div style="border: 1px solid gray; height: 20px; width: 99%;">
							<textarea onKeyDown="limitText(this,250);" onKeyUp="limitText(this,250);" id="plaintiffDtl" class="leftAligned" name="plaintiffDtl" style="width: 90%; border: none; height: 13px;">${fn:escapeXml(bond.plaintiffDtl)}</textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editPlaintiffDtl" />
						</div>
					</td>
				</tr>
				<tr id="trDefendantDtl" style="display: none">
					<td class="rightAligned" style="width: 20%;">Defendants Details</td>
					<td class="leftAligned" colspan="3">
						<div style="border: 1px solid gray; height: 20px; width: 99%;">
							<textarea onKeyDown="limitText(this,250);" onKeyUp="limitText(this,250);" id="defendantDtl" class="leftAligned" name="defendantDtl" style="width: 90%; border: none; height: 13px;">${fn:escapeXml(bond.defendantDtl)}</textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editDefendantDtl" />
						</div>
					</td>
				</tr>
				<tr id="trCivilCaseNo" style="display: none">
					<td class="rightAligned" style="width: 20%;">Civil Case Number</td>
					<td class="leftAligned" colspan="3">
						<input id="civilCaseNo" name="civilCaseNo" class="leftAligned" type="text" maxlength="50" style="width: 98%;" value="${fn:escapeXml(bond.civilCaseNo)}"/>
					</td>
				</tr>
			</table>
		</div>
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="outerDiv">
				<label id="">Co-Signors List</label>
				<span class="refreshers" style="margin-top: 0;">
		 			<label id="showCosignors" name="gro" style="margin-left: 5px;">Show</label>
				</span>
			</div>
		</div>
		<div id="cosignorsListingTableDiv" name="cosignorsListingTableDiv" style="display: none;">

		</div>
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
			<input type="button" id="btnLandCarrierDtls" name="btnLandCarrierDtls" class="button" value="Land Carrier Details" style="margin-top: 10px; width: 130px;"/>
			<input type="button" id="btnPrincipalSignatory" name="btnPrincipalSignatory" class="button" value="Principal Signatory" style="margin-top: 10px; width: 120px;"/>
			<input type="button" id="btnObligee" name="btnObligee" class="button" value="Obligee" style="margin-top: 10px; width: 100px;"/>
			<input type="button" id="btnNotaryPublic" name="btnNotaryPublic" class="button" value="Notary Public" style="margin-top: 10px; width: 100px;"/>
			<input type="button" id="btnCancel" name="btnCancel" class="button" value="Cancel" style="margin-top: 10px; width: 90px;"/>
			<input type="button" id="btnSave" name="btnSave" class="button" value="Save" style="margin-top: 10px; width: 90px;"/>
			<br/><br/><br/>
		</div>
	</form>
</div>
<div id="principalSignatoryDiv" name="principalSignatoryDiv" style="margin-top: 0px; display: none;">
	
</div>


<script type="text/javaScript">
//bondMainDiv
	setModuleId("GIPIS017A");
	observeAccessibleModule(accessType.BUTTON, "GIISS022", "btnPrincipalSignatory", function() {	
		maintainSignatory("bondMainDiv");
	});
	
	//loadCosignorsListingTable();
	initializeAccordion();
	initializeAll();
	$("assdTitle").innerHTML = "Principal";
	var inceptDate = $F("globalInceptDate");
	if ("" == $F("contractDate")){
		$("contractDate").value = dateFormat(Date.parse($F("globalInceptDate")), "mm-dd-yyyy");
	}
	setBondPolicyDataPageFields();
	initializeAllMoneyFields();
	setDefaultValues();
	
	hideNotice("");
	displayWaiverLimit();
	
	if (("${showJCLDetails}" == "Y" && objUWParList.sublineCd.substr(0, 3) == "JCL") || objUWParList.sublineCd.substr(0, 6) == "JCR(2)"){
		$("trPlaintiffDtl").show();
		$("trDefendantDtl").show();
		$("trCivilCaseNo").show();
	}
	
	initializeChangeTagBehavior(saveBondPolicyDataChanges); //uncommented by robert 11.14.2013
	observeReloadForm("reloadForm", showBondPolicyDataPage); //added by robert 11.14.2013
	changeTag = 0; //added by robert 11.14.2013
	
	$("obligee").observe("change", function(){
		$("obligeeNo").value = $("obligee").value;
		$("address").value = $("obligee").options[$("obligee").selectedIndex].getAttribute("address");
	});
	
	$("dspPrinSignor").observe("change", function(){
		$("prinId").value = $("dspPrinSignor").value;
		$("designation").value = $("dspPrinSignor").options[$("dspPrinSignor").selectedIndex].getAttribute("designation");
	});
	
	$("dspClauseType").observe("change", function(){
		if ("1" == $F("wInvoiceExists")){
			showConfirmBox("Delete Bill Information", "This will delete Bill information", "Continue", "Cancel", setDeleteBillsSwitch, "");
		}
		$("clauseType").value = $("dspClauseType").value;
		displayWaiverLimit();
	});
	
	$("dspCollFlag").observe("change", function(){
		$("collFlag").value = $("dspCollFlag").value;
		displayWaiverLimit();
	});
	
	$("dspNPName").observe("change", function(){
		$("npNo").value = $("dspNPName").value;
	});
	
	$("btnSave").observe("click", function(){
		if (changeTag == 0) { //added by robert 11.14.2013
			showMessageBox(objCommonMessage.NO_CHANGES, imgMessage.INFO);
		}else{
			saveBondPolicyDataChanges();
		}
	});
	
	$("btnCancel").observe("click", function(){
		//checkChangeTagBeforeCancel();
		goBackToParListing();
	});
	
	$("showCosignors").observe("click",function(){
		if($("cosignorsListingTableDiv").empty()){
			loadCosignorsListingTable();
		}
	});
	
	$("contractDtl").observe("keyup", function () {
		limitText(this, 75);
	});
	
	$("editContractDtl").observe("click", function () {
		showEditor("contractDtl", 75);
	});

	$("bondDtl").observe("keyup", function () {
		limitText(this, 2000);
	});
	
	$("editBondDtl").observe("click", function () {
		showEditor("bondDtl", 2000);
	});

	$("indemnityText").observe("keyup", function () {
		limitText(this, 2000);
	});
	
	$("editIndemnityText").observe("click", function () {
		showEditor("indemnityText", 2000);
	});
	
	$("editPlaintiffDtl").observe("click", function () {
		showEditor("plaintiffDtl", 250);
	});
	
	$("editDefendantDtl").observe("click", function () {
		showEditor("defendantDtl", 250);
	});
	

	function maintainSignatory(mainDiv) {
		try {//contextPath+"/GIISPrincipalSignatoryController?action=showPrincipalSignatory"
			var url = contextPath+"/GIISPrincipalSignatoryController?action=showPrincipalSignatoryFromBondPolicy&assdNo="+$F("globalAssdNo")+"&assdName="+escape($F("globalAssdName"))+"&divToShow="+mainDiv+"&callingForm=GIPIS017";  //added escape to assdName - Halley 10.04.2013
			
			if ($("principalSignatoryDiv").innerHTML.blank() || url != $("principalSignatoryDiv").readAttribute("src")) {  
				$("principalSignatoryDiv").writeAttribute("src", url);
				Effect.Fade(mainDiv, {
					duration: .001,
					beforeFinish: function () {
						Effect.Appear("principalSignatoryDiv", {duration: .001});
						new Ajax.Updater("principalSignatoryDiv", url, {
							method: "GET",
							evalScripts: true,
							asynchronous: true,
							onCreate: function () {
								showLoading("principalSignatoryDiv", "Getting principal signatory, please wait...", "150px");
							},
							onComplete: function (response)	{
								if(checkErrorOnResponse(response)){
									Effect.Appear($("principalSignatoryDiv").down("div", 0), {
										duration: .001,
										afterFinish: function () {
											initializeAccordion();
											addStyleToInputs();
											initializeAll();
										}
									});
								}
							}
						});
					}
				});
			} else {
				Effect.Fade(mainDiv, {duration: .001});
				Effect.Appear("principalSignatoryDiv", {duration: .001});
			}
		} catch (e) {
			showErrorMessage("maintainSignatory", e);
		}
	}

	function setDefaultValues(){
		if ("" == $F("collFlag")){
			$("collFlag").value = "N";
		}
		if ("" == $F("coPrinSw")){
			$("coPrinSw").value = "N";
		}	
		if ("" == $F("contractDtl")){
			$("contractDtl").value = "Agreement";
		}
		if ("" == $F("clauseType")){
			$("clauseType").value = $("dspClauseType").value;
		}
	}
	
	function displayWaiverLimit(){
		if ("W" == $F("collFlag")){
			var wl = $("dspClauseType").options[$("dspClauseType").selectedIndex].getAttribute("waiverLimit");
			$("dspWaiverLimit").value = formatCurrency(nvl(wl,"0"), 0);
		} else {
			$("dspWaiverLimit").value = "0.00";
		}
	}
	
	function saveBondPolicyDataChanges(){
		if (validateBondPolicyBeforeSave()){
			new Ajax.Request(contextPath+"/GIPIWBondBasicController?action=saveBondPolicyDataPageChanges&globalParId="+$F("globalParId")
											+"&valPeriod="+objUW.hidObjGIPIS017.valPeriod+"&valPeriodUnit="+objUW.hidObjGIPIS017.valPeriodUnit,{
				method: "POST",
				evalScripts: true,
				asynchronous: true,
				postBody: Form.serialize("bondForm"),
				onCreate: function () {			
					showNotice("Saving, please wait...");
				},
				onComplete: function (response)	{
					hideNotice("");
					if (checkErrorOnResponse(response)) {
						if ("SUCCESSFUL" == response.responseText){
							showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
							$("cosignorsPageChangedSw").value = "N";
							updateParParameters(); // andrew - 03.24.2011 - added this line to enable menu if saving is successful
							changeTag = 0; //added by robert 11.14.2013
						} else {
							showMessageBox(response.responseText, "error");
						}
					}		
				}
			});	
		}
	}
	
	function validateBondPolicyBeforeSave(){
		var result = true;
		if ("" == $("obligee").value){
			showMessageBox("Obligee name must be entered.", "error");
			result = false;
		} else if ( "" == $("bondDtl").value){
			showMessageBox("Bond Undertaking must be entered.", "error");
			result = false;
		} else if ( "" == $("prinId").value){
			showMessageBox("Principal Signatory must be entered.", "error");
			result = false;	
		} else if ("" == $("dspClauseType").value){
			showMessageBox("Please select a clause type.", "error");
			result = false;
		} 
		return result;
	}
	
	function setBondPolicyDataPageFields(){
		var obligeeNo = $F("obligeeNo");
		var prinId = $F("prinId");
		var clauseType = $F("clauseType");
		var collFlag = $F("collFlag");
		var npNo = $F("npNo");

		//setting obligee
		var o = $("obligee");
		for (var i=0; i<o.length; i++)	{
			if (o.options[i].value == obligeeNo)	{
				o.selectedIndex = i;
				$("address").value = $("obligee").options[i].getAttribute("address");
				$("initialObligeeNo").value = o.value;
			}
		}
	
		//setting principal signatory
		var ps = $("dspPrinSignor");
		for (var i=0; i<ps.length; i++)	{
			if (ps.options[i].value == prinId)	{
				ps.selectedIndex = i;
				//$("address").value = $("obligee").options[i].getAttribute("address");
			}
		}
	
		//setting clause desc
		var ct = $("dspClauseType");
		for (var i=0; i<ct.length; i++)	{
			if (ct.options[i].value == clauseType)	{
				ct.selectedIndex = i;
				//$("address").value = $("obligee").options[i].getAttribute("address");
			}
		}
	
		//setting collateral flag
		var cf = $("dspCollFlag");
		for (var i=0; i<cf.length; i++)	{
			if (cf.options[i].value == collFlag)	{
				cf.selectedIndex = i;
				//$("address").value = $("obligee").options[i].getAttribute("address");
			}
		}
	
		//setting notary public
		var np = $("dspNPName");
		for (var i=0; i<np.length; i++)	{
			if (np.options[i].value == npNo)	{
				np.selectedIndex = i;
				//$("address").value = $("obligee").options[i].getAttribute("address");
			}
		}

		$("designation").value = $("dspPrinSignor").options[$("dspPrinSignor").selectedIndex].getAttribute("designation");
	}

	/*$("btnObligee").observe("click", function(){
		objUW.fromMenu = "bondPolicyData";
		showObligeeMaintenance();
	});*/  // kris 02.19.2014: replaced with the function below:
	observeAccessibleModule(accessType.BUTTON, "GIISS017", "btnObligee", function(){
		objUW.fromMenu = "bondPolicyData";
		showObligeeMaintenance();
	});
	
	// shan 10.13.2014
	$("btnLandCarrierDtls").observe("click", function(){
		if (changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			return false;
		}
		
		landCarrierDtlOverlay = Overlay.show(contextPath+"/GIPIWBondBasicController",{
			urlContent: true,
			urlParameters: {
				action:		"showLandCarrierDtl",
				globalParId: $F("globalParId")
			},
			title: "Land Carrier Details",
			width: 750,
			height: 420,
			draggable: true
		});
	});
	
	function initializeLandCarrierButton(){
		if (objUWGlobal.menuLineCd == "SU" && ($F("globalSublineCd") == "C20" || $F("globalSublineCd") == "C(20)" 
												|| $F("globalSublineCd") == "C15" || $F("globalSublineCd") == "C(15)")){
			$("btnLandCarrierDtls").show();
		}else{
			$("btnLandCarrierDtls").hide();
		}
	}
	
	//added by Gzelle 10132014
	observeAccessibleModule(accessType.BUTTON, "GIISS016", "btnNotaryPublic", function(){
		objUW.fromMenu = "bondPolicyData";
		showGiiss016();
	});
	
	initializeLandCarrierButton();
</script>