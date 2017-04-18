<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="quotationBondPolicyMainDiv" name="quotationBondPolicyMainDiv" style="margin-top: 1px; display: none;">
	<form id="bondForm" name="bondForm">
		<input type="hidden" name="quoteId" 	id="quoteId" 	value="${gipiQuote.quoteId }" />
		<input type="hidden" name="lineCd" 		id="lineCd" 	value="${gipiQuote.lineCd}" />
		<input type="hidden" name="sublineCd" 	id="sublineCd" 	value="${gipiQuote.sublineCd}" />
		<input type="hidden" name="lineName" 	id="lineName" 	value="${gipiQuote.lineName}" />
		
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
				<label id="">Quotation Information</label>  
				<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label>
					<label id="reloadForm" name="reloadForm">Reload Form</label>
				</span>
			</div>
		</div>
		
		<div id="clausesDiv" name="clausesDiv" class="sectionDiv">
			<div id="quoteInfo" name="quoteInfo" style="margin: 10px;">
				<table align="center">
					<tr>
						<td class="rightAligned">Quotation No. </td>
						<td class="leftAligned"><input type="text" style="width: 250px;" id="quoteNo" name="quoteNo" readonly="readonly" value="${gipiQuote.quoteNo}" /></td>
						<td class="rightAligned">Principal </td>
						<td class="leftAligned">
							<input type="text" style="width: 250px;" id="assuredName" name="assuredName" readonly="readonly" value="${gipiQuote.assdName}" />
							<input type="hidden" id="assuredNo" name="assuredNo" value="${gipiQuote.assdNo}" />
							<input type="hidden" id="assdNo" name="assdNo" value="${gipiQuote.assdNo}" />
							<input type="hidden" id="assdName" name="assdName" value="${gipiQuote.assdName}" />
						</td>	
					</tr>
				</table>
			</div>
		</div>
		
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
						<select id="obligee" name="obligee" style="width: 99.4%;" class="required">
							<option value="" address=""></option>
							<c:forEach var="obl" items="${obligeeListing}" varStatus="ctr">
								<option value="${obl.obligeeNo}" address="${obl.address}">${fn:escapeXml(obl.obligeeName)}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 20%;">Principal Signatory</td>
					<td class="leftAligned" colspan="3">
						<select id="dspPrinSignor" name="dspPrinSignor" style="width: 99.4%;">
							<option value="" designation=""></option>
							<c:forEach var="sig" items="${prinSigListing}" varStatus="ctr">
								<option value="${sig.prinId}" designation="${sig.designation}">${fn:escapeXml(sig.prinSignor)}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 20%;">Designation</td>
					<td class="leftAligned" colspan="3">
						<input id="designation" name="designation" class="leftAligned" type="text" maxlength="30" style="width: 97.8%;" value="" readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<%-- <td class="rightAligned" style="width: 20%;">Bond Undertaking</td>
					<td class="leftAligned" colspan="3">
						<input id="bondDtl" name="bondDtl" class="leftAligned required" type="text" maxlength="2000" style="width: 97.8%;" value="${fn:escapeXml(bond.bondDtl)}"/>
					</td> --%>
					<td class="rightAligned" style="width: 20%;">Bond Undertaking</td>
					<td class="leftAligned" colspan="3">
						<%-- <div style="border: 1px solid gray; height: 20px; width: 99%;" class="required">
							<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" id="bondDtl" class="leftAligned required" name="bondDtl" style="width: 94%; border: none; height: 13px;">${fn:escapeXml(bond.bondDtl)}</textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editBondDtl" />
						</div>
						 --%>
						<span id="particularsSpan" style="border: 1px solid gray; width: 99%; height: 21px; float: left;" class="required"> 
							<%-- commented out and replace by reymon 03012013
							field must be text area to accommodate nextline
							<input type="text" id="bondDtl" name="bondDtl" style="border: none; float: left; width: 90%; background: transparent;" onKeyDown="limitText(this, 2000);" onKeyUp="limitText(this, 2000);" value="${fn:escapeXml(bond.bondDtl)};"/>--%>
							<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" id="bondDtl" class="leftAligned required" name="bondDtl" style="width: 90%; border: none; height: 13px;">${fn:escapeXml(bond.bondDtl)}</textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right; background: transparent;" alt="Edit" id="editBondDtl" /> 
						</span>
					</td>	
				</tr>
				<tr>
					<%-- <td class="rightAligned" style="width: 20%;">Indemnity</td>
					<td class="leftAligned" colspan="3">
						<input id="indemnityText" name="indemnityText" class="leftAligned" type="text" maxlength="2000" style="width: 97.8%;" value="${fn:escapeXml(bond.indemnityText)}"/>
					</td> --%>
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
						<select id="dspNPName" name="dspNPName" style="width: 99.3%;">
							<option value=""></option>
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
						<select id="dspCollFlag" name="dspCollFlag" style="width: 98%;">
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
						<input readonly="readonly" style="width: 94%;" id="contractDate" name="contractDate" type="text" value="${gipiQuote.inceptDate}"/>
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
			</table>
		</div>
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="outerDiv">
				<label id="">Co-Signors List</label>
				<span class="refreshers" style="margin-top: 0;">
		 			<label id="showCosignors" name="gro" style="margin-left: 5px;">Show </label>
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
			<input id="valPeriodUnit" name="valPeriodUnit" type="hidden" value="${bond.valPeriodUnit}"/>
			<input id="valPeriod" name="valPeriod" type="hidden" value="${bond.valPeriod}"/>
			<input id="endtEffDate" name="endtEffDate" type="hidden" value="${bond.endtEffDate}"/>
			<input id="remarks" name="remarks" type="hidden" value="${bond.remarks}"/>
			<input id="coPrinSw" name="coPrinSw" type="hidden" value="${bond.coPrinSw}"/>
			<input id="cosignorsPageChangedSw" name="cosignorsPageChangedSw" type="hidden" value="N"/>
			<input id="cosignorIsLoaded" name="cosignorIsLoaded" type="hidden" value="N"/>
		</div>
		<div id="buttonsDiv" align="center">
			<input type="button" id="btnPrincipalSignatory" name="btnPrincipalSignatory" class="button" value="Principal Signatory" style="margin-top: 10px; width: 120px;"/>
			<input type="button" id="btnObligee" name="btnObligee" class="button" value="Obligee" style="margin-top: 10px; width: 100px;"/>
			<input type="button" id="btnNotaryPublic" name="btnNotaryPublic" class="button" value="Notary Public" style="margin-top: 10px; width: 100px;"/>
			<input type="button" id="btnCancel" name="btnCancel" class="button" value="Cancel" style="margin-top: 10px; width: 90px;"/>
			<input type="button" id="btnSave" name="btnSave" class="button" value="Save" style="margin-top: 10px; width: 90px;"/>
			<br/><br/><br/>
		</div>		
	</form>
	<!-- <input id="lineCdHidden" name="lineCdHidden" type="hidden" value=""> -->
</div>
<script type="text/javaScript">
	/* $("lineCdHidden").value = '${lineCd}'; */
	//$("quoteId").value = '${quoteId}';
	//initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	setModuleId("GIIMM011");
	setDocumentTitle("Bond Policy Data");
	window.scrollTo(0,0); 	
	hideNotice("");
	objGIPIQuote = JSON.parse('${gipiQuoteJSON}'.replace(/\\/g, '\\\\'));
	
	observeChangeTagOnDate("editContractDtl", "contractDtl");
	$("editContractDtl").observe("click", function () {
		showEditor("contractDtl", 75);
	});
	
	observeChangeTagOnDate("editBondDtl", "bondDtl");
	$("editBondDtl").observe("click", function () {
		showEditor("bondDtl", 2000);
	});
	
	observeChangeTagOnDate("editIndemnityText", "indemnityText");
	$("editIndemnityText").observe("click", function () {
		showEditor("indemnityText", 2000);
	});

	function loadCosignorsGIIMM011(){
		if ("N" == $F("cosignorIsLoaded")){
			new Ajax.Updater("cosignorsListingTableDiv", contextPath+"/GIPIQuoteCosignController?action=loadCosignorsListingTable",{
				method:"POST",
				postBody: Form.serialize("bondForm"),
				evalScripts: true,
				asynchronous: true,
				onComplete: function  () {
					$("cosignorsListingTableDiv").show();
					$("cosignorIsLoaded").value = "Y";
					$("showCosignors").innerHTML = "Hide";
			}
			});
		}else{
			$("cosignorIsLoaded").value = "N";
			$("showCosignors").innerHTML = "Show";
		}
	}
	
	$("showCosignors").observe("click",function(){
		if($("cosignorsListingTableDiv").empty()){
			loadCosignorsGIIMM011();
		}
	});

	$("obligee").observe("change", function(){
		$("obligeeNo").value = $("obligee").value;
		$("address").value = $("obligee").options[$("obligee").selectedIndex].getAttribute("address");
	});
	
	$("dspPrinSignor").observe("change", function(){
		$("prinId").value = $("dspPrinSignor").value;
		$("designation").value = $("dspPrinSignor").options[$("dspPrinSignor").selectedIndex].getAttribute("designation");
	});

	$("dspNPName").observe("change", function(){
		$("npNo").value = $("dspNPName").value;
	});

	$("dspClauseType").observe("change", function(){
		$("clauseType").value = $("dspClauseType").value;
		displayWaiverLimit();
	});

	$("dspCollFlag").observe("change", function(){
		$("collFlag").value = $("dspCollFlag").value;
		displayWaiverLimit();
	});
	
	$("btnNotaryPublic").observe("click", function(){
		showMessageBox("Notary Public Maintenance Page is not yet existing.");
	});
	
	$("btnObligee").observe("click", function(){
		showMessageBox("Obligee Information Maintenance Page is not yet existing.");
	});
	
	function displayWaiverLimit(){
		if ("W" == $F("collFlag")){
			var wl = $("dspClauseType").options[$("dspClauseType").selectedIndex].getAttribute("waiverLimit");
			$("dspWaiverLimit").value = formatCurrency(nvl(wl,"0"), 0);
		} else {
			$("dspWaiverLimit").value = "0.00";
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
	
	function setBondPolicyDataPageFields(){
		var obligeeNo = $F("obligeeNo");
		var prinId = $F("prinId");
		var clauseType = nvl($F("clauseType"),"1");
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
			}
		}

		//setting notary public
		var np = $("dspNPName");
		for (var i=0; i<np.length; i++)	{
			if (np.options[i].value == npNo)	{
				np.selectedIndex = i;
			}
		}
		
		//setting clause desc
		var ct = $("dspClauseType");
		for (var i=0; i<ct.length; i++)	{
			if (ct.options[i].value == clauseType)	{
				ct.selectedIndex = i;
			}
		}

		//setting collateral flag
		var cf = $("dspCollFlag");
		for (var i=0; i<cf.length; i++)	{
			if (cf.options[i].value == collFlag)	{
				cf.selectedIndex = i;
			}
		}

		$("designation").value = $("dspPrinSignor").options[$("dspPrinSignor").selectedIndex].getAttribute("designation");
	}

	function saveBondPolicyDataChanges(){
		if (validateBondPolicyBeforeSave()){
			var delRows = [];
			var setRows = [];
			if(!$("cosignorsListingTableDiv").empty()){
				var addedRows 	 = getAddedJSONObjects(objMKTG.cosignsJSON);
				var modifiedRows = getModifiedJSONObjects(objMKTG.cosignsJSON);
				delRows 	 = getDeletedJSONObjects(objMKTG.cosignsJSON);
				setRows		 = addedRows.concat(modifiedRows);
				
				//added by jeffdojello 04.26.2013
				//Remove consignee name value to avoid error when the value contains special characters
				var tempArr = new Array();
				for(var i=0; i<setRows.length; i++ ){
					setRows[i].cosignName = "";
					tempArr.push(setRows[i]);
				}				
				setRows = tempArr;
				
				var tempArr2 = new Array();
				for(var i=0; i<delRows.length; i++ ){
					delRows[i].cosignName = "";
					tempArr2.push(delRows[i]);
				}				
				delRows = tempArr2;				
			}
			
			new Ajax.Request(contextPath+"/GIPIQuotationBondBasicController?action=saveBondPolicyData",{
				method: "POST",
				asynchronous: false,
				evalScripts: true,
				postBody: Form.serialize("bondForm")+"&setRows="+prepareJsonAsParameter(setRows) +"&delRows="+prepareJsonAsParameter(delRows),
				onCreate: function () {			
					showNotice("Saving, please wait...");
				},
				onComplete: function (response)	{
					hideNotice("");
					if (checkErrorOnResponse(response)) {
						if ("SUCCESS" == response.responseText){
							showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
							setRows.length > 0 || delRows.length > 0 ? clearObjectRecordStatus(objMKTG.cosignsJSON) :null;
							$F("cosignorsPageChangedSw") == "Y" ? objMKTG.cosigns.clearForm() :null;
							$("cosignorsPageChangedSw").value = "N";
							changeTag = 0;
							lastAction();
							lastAction = "";
						} else {
							showMessageBox(response.responseText, imgMessage.ERROR);
						}
					}		
				}
			});	
		}
	}
	
	function validateBondPolicyBeforeSave(){
		var result = true;
		if ("" == $("obligee").value){
			customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "obligee");
			return false;
		} 
		if ( "" == $("bondDtl").value){
			customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "bondDtl");
			return false;
		} 
		if ("" == $("dspClauseType").value){
			customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "dspClauseType");
			return false;
		} 
		return true;
	}
	
	function onCancel(){
		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
							function(){	saveBondPolicyDataChanges();
										createQuotationFromLineListing();},
							function(){	createQuotationFromLineListing();
										changeTag = 0;},"");
		}else{
			createQuotationFromLineListing();
			changeTag = 0;
		}
	}
	/* $("btnPrincipalSignatory").observe("click", function () {
		goToModule("/GIISPrincipalSignatoryController?action=showPrincipalSignatoryFromBondPolicy&assdNo="+$("assdNo").value+"&assdName="+$("assdName").value, "sample title", null);
	}); */

	/*observeGoToModule("btnPrincipalSignatory", function(){goToModule("/GIISPrincipalSignatoryController?action=showPrincipalSignatoryFromBondPolicy&assdNo="+$("assdNo").value+"&assdName="+$("assdName").value+"&callingForm=GIIMM011"
			,"Principal Signatory"
			, null);});*/
		
	observeAccessibleModule(accessType.BUTTON, "GIISS022", "btnPrincipalSignatory", function(){
		showPrincipalSignatory("GIIMM011", $("assdNo").value, $("assdName").value);
	});
	
	observeReloadForm("reloadForm", showBondPolicyData);
	//observeCancelForm("btnCancel", saveBondPolicyDataChanges, function(){changeTag = 0; createQuotationFromLineListing();});
	observeSaveForm("btnSave", saveBondPolicyDataChanges);
	//observeGoToModule("gimmExit", createQuotationFromLineListing);
	
	$("btnCancel").observe("click", function (){
		onCancel();
		bondPolicyDataCtr = 1;
	});
	
	/* $("gimmExit").observe("click", function (){
		onCancel();
		bondPolicyDataCtr = 1;
	}); */
	
	setDefaultValues();
	setBondPolicyDataPageFields();
	displayWaiverLimit();
	changeTag = 0;
	initializeChangeTagBehavior(saveBondPolicyDataChanges); 
	
	$("gimmExit").stopObserving("click"); // andrew - 02.09.2012
	$("gimmExit").observe("click", function(){
		//showQuotationListing();
		onCancel();
		bondPolicyDataCtr = 1;
	});
</script>