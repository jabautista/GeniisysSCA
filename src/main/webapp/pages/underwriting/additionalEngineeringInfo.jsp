<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="additionalENInfoMainDiv" name="additionalENInfoMainDiv">
	<form id="additionalENInfoForm" name="additionalENInfoForm">
		<c:if test="${'Y' ne isPack}">
			<jsp:include page="/pages/underwriting/subPages/parInformation.jsp"></jsp:include>
		</c:if>
		<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
			<div id="innerDiv" name="innerDiv">
				<label>Additional Engineering Information</label>
				<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label>
				</span>
			</div>
		</div>
			
		<div id="additionalENInfoFormDiv" name="additionalENInfoFormDiv" class="sectionDiv" align="center" changeTagAttr="true" >
			<table align="center" width="75%" style="margin-left: 90px;"> <!-- originally width="55%" -->
				<tr>
 					<td class="rightAligned" width="26.5%">Subline</td> <!-- originally width="20%" -->
					<td class="leftAligned" width="73.5%" colspan="3">
						<input type="hidden" id="sublineCdParam" name="sublineCdParam" value="${engParamSublineCd}" />
						<input type="text" id="enSublineName" name="enSublineName" value="${enSublineName}" readonly="readonly" style="width: 94%;"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" width="26.5%">Inception Date</td>
					<td class="leftAligned" width="26%">
						<input type="text" id="enInceptDate" name="enInceptDate" readonly="readonly" value="${enInceptDate}" style="width: 82%"/>
					</td>
					<td class="rightAligned" width="21.5%">Expiry Date</td>
					<td class="leftAligned" width="26%">
						<input type="text" id="enExpiryDate" name="enExpiryDate" readonly="readonly" value="${enExpiryDate}" style="width: 82%"/>
					</td>
				</tr>
				<c:if test="${parType eq 'E'}">
					<tr>
						<td class="rightAligned" width="23%">Issue Date</td>
						<td class="leftAligned" width="27%">
							<input type="text" id="enIssueDate" name="enIssueDate" readonly="readonly" value="${enIssueDate}"/>
						</td>
						<td class="rightAligned" width="20%">Effectivity Date</td>
						<td class="leftAligned" width="30%">
							<input type="text" id="enEffectivityDate" name="enEffectivityDate" readonly="readonly" value="${enEffectivityDate}"/>
						</td>
					</tr>
				</c:if>
			</table>
			
			<input type="hidden" id="globalParId" name="globalParId" value="${enParId}" />
			<input type="hidden" id="enSubline" name="enSubline" value="${enSubline}" />
			<input type="hidden" id="enBasicInfoNum" name="enBasicInfoNum" value="${enBasicInfoNum}" />
			<table align="center" width="75%" style="margin-top: 30px; margin-left: 90px;">
				<tr>
					<td width="23%"><label class="rightAligned" id="titleLbl"  style="float: right;">Project</label></td>
					<td class="leftAligned" width="77%" colspan="3">
						<div name="projDivAdd" id="projDivAdd" style="width: 95%; border: 1px solid gray;">
							<!-- commented out by reymon 03052013 the field should be text area to accommodate next lines
							<input type="text" id="enProjectName" name="enProjectName" value="${enInfo.projTitle}" style="width: 93%; border: none;"/> -->
							<textarea onKeyDown="limitText(this,250);" onKeyUp="limitText(this,250);" id="enProjectName" class="leftAligned required" name="enProjectName" style="width: 90%; border: none; height: 13px;">${enInfo.projTitle}</textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="EditTitle" id="editProjText" />
						</div>
					</td>
				</tr>
				<tr>
					<td width="23%"><label class="rightAligned" id="siteLbl" style="float: right;">Site of Erection</label></td>
					<td class="leftAligned" width="77%" colspan="3">
						<div name="siteDivAdd" id="siteDivAdd" style="width: 95%; border: 1px solid gray;">
							<!-- commented out by reymon 03052013 the field should be text area to accommodate next lines
							<input type="text" id="enSiteLoc" name="enSiteLoc" value="${enInfo.siteLocation}" style="width: 93%; border: none;" /> -->
							<textarea onKeyDown="limitText(this,250);" onKeyUp="limitText(this,250);" id="enSiteLoc" class="leftAligned required" name="enSiteLoc" style="width: 90%; border: none; height: 13px;">${enInfo.siteLocation}</textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="EditSite" id="editSiteText" />
						</div>
					</td>
				</tr>
				<tr>
					<td width="23%"><label class="rightAligned" id="weeksLbl" style="float: right; display: none;">Weeks Testing/ Commissioning</label></td>
					<td class="leftAligned" width="25%">
						<div id="constructFromSpan" style="float: left; border: solid 1px gray; width: 201px; height: 20px; display: none;">
							<input type="text" style="float: left; margin-top: 0px; width: 175px; border: none; background-color: transparent;" name="constructFrom" id="constructFrom" value="<fmt:formatDate pattern="MM-dd-yyyy" value="${enInfo.consStartDate}" />" readonly="readonly"/>
							<img alt="From" id="imgConstFromDate" style="height: 18px;" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('constructFrom'),this, null);" />						
						</div>
						<!-- replaced by reymon 03052013
						 <input type="text" id="weeksTesting" name="weeksTesting" maxlength="3" class="required" value="<fmt:formatNumber pattern="####.##" value="${enInfo.weeksTest}"/>" style="width: 30%; display: none;"/> -->
						<input type="text" id="weeksTesting" name="weeksTesting" maxlength="3" class="rightAligned" value="<fmt:formatNumber pattern="####.##" value="${enInfo.weeksTest}"/>" style="width: 30%; display: none;"/>
						<input type="text" id="mbiPolNo" name="mbiPolNo" value="${enInfo.mbiPolicyNo}" style="width: 100%; display: none;" />
					</td>
					<td class="rightAligned" width="5%"><label id="consLbl" style="float: right; display: none;" >To</label></td>
					<td class="leftAligned" width="25%">
						<div id="constructToSpan" style="float: left; border: solid 1px gray; width: 201px; height: 20px; display: none;">
							<input type="text" style="float: left; margin-top: 0px; width: 175px; border: none; background-color: transparent;" name="constructTo" id="constructTo" value="<fmt:formatDate pattern="MM-dd-yyyy" value="${enInfo.consEndDate}" />" readonly="readonly"/>
							<img alt="To" id="imgConstToDate" style="height: 18px;" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('constructTo'),this, null);" />						
						</div>
					</td>
				</tr>
				<tr>
					<td width="23%"><label class="rightAligned" id="mainFromLbl" style="float: right; display: none;">Maintenance Period From</label></td>
					<td class="leftAligned" width="25%">
						<div id="mainFromSpan" style="float: left; border: solid 1px gray; width: 201px; height: 20px; display: none;">
							<input type="text" style="float: left; margin-top: 0px; width: 175px; border: none; background-color: transparent;" name="mainFrom" id="mainFrom" value="<fmt:formatDate pattern="MM-dd-yyyy" value="${enInfo.maintStartDate}"/>" readonly="readonly"/>
							<img alt="From" id="imgMainFromDate" style="height: 18px;" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('mainFrom'),this, null);" />						
						</div>	
						<input type="text" id="timeExcess" name="timeExcess" maxlength="3" value="${enInfo.timeExcess}" style="width: 40%; display: none;" />
					</td>
					<td class="rightAligned" width="5%"><label id="mainToLbl" style=" float: right; display: none;">To</label></td>
					<td class="leftAligned" width="25%">
						<div id="mainToSpan" style="float: left; border: solid 1px gray; width: 201px; height: 20px; display: none;">
							<input type="text" style="float: left; margin-top: 0px; width: 175px; border: none; background-color: transparent;" name="mainTo" id="mainTo" value="<fmt:formatDate pattern="MM-dd-yyyy" value="${enInfo.maintEndDate}"/>" readonly="readonly"/>
							<img alt="To" id="imgMainToDate" style="height: 18px;" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('mainTo'),this, null);" />						
						</div>
					</td>
				</tr>
			</table>
			<div id="principalInfoDiv" name="principalInfoDiv" style="display: none;" changeTagAttr="true">
				<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
					<div id="innerDiv" name="innerDiv">
						<label>Principal</label>
						<span class="refreshers" style="margin-top: 0;">
							<label id="togglePrincipal" name="gro" style="margin-left: 5px;">Show</label>
						</span>
					</div>
				</div>
				<div id="enPrincipalInfo" class="sectionDiv" style="display: none;"></div>
			</div>
			<div id="contractorInfoDiv" name="contractorInfoDiv" style="display: none;" changeTagAttr="true">
				<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
					<div id="innerDiv" name="innerDiv">
						<label>Contractor</label>
						<span class="refreshers" style="margin-top: 0;">
							<label id="toggleContractor" name="gro" style="margin-left: 5px;">Show</label>
						</span>
					</div>
				</div>
				<div id="enContractorInfo" class="sectionDiv" style="display: none;"></div>
			</div>
		</div>
		
		<div class="buttonsDiv" id="addENInfoButtonsDiv">
			<input type="button" class="button" style="width: 90px;" id="btnCancel" name="btnCancel" value="Cancel" />
			<input type="button" class="button" style="width: 90px;" id="btnSave" name="btnSave" value="Save" />
		</div>
	</form>
</div>

<script type="text/javascript">
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	
	changeTag = 0; //added by christian 04/19/2013
	var pageActions = {none: 0, save : 1, reload : 2, cancel : 3};
	var pAction = pageActions.none;
	if("Y" != "${isPack}") setDocumentTitle("Additional Engineering Information");
	setModuleId("GIPIS066");

	var objENPrincipals;
	//var subline = $("enSubline").value;
	var subline = $F("sublineCdParam");
	var inceptDate = $("enInceptDate").value;
	var expiryDate = $("enExpiryDate").value;

	
	var constFromPrev = "";
	var constToPrev = "";
	var mainFromPrev = "";
	var mainToPrev = "";

	/* == SUBLINE Names
		'CONTRACTOR_ALL_RISK'
        'ERECTION_ALL_RISK'
        'MACHINERY_BREAKDOWN_INSURANCE'
        'MACHINERY_LOSS_OF_PROFIT'
        'DETERIORATION_OF_STOCKS'
        'BOILER_AND_PRESSURE_VESSEL'
        'ELECTRONIC_EQUIPMENT'
        'PRINCIPAL_CONTROL_POLICY'
        'OPEN_POLICY';
	*/

	//if($F("sublineCdParam") == "EAR" || $F("sublineCdParam") == "CAR") { //subline == "CAR"
	if($F("sublineCdParam") == "CONTRACTOR_ALL_RISK" || $F("sublineCdParam") == "CONTRACTORS_ALL_RISK") {
		document.getElementById("titleLbl").innerHTML = 'Title of Contract';
		document.getElementById("siteLbl").innerHTML = 'Location of Contract Site';
		document.getElementById("weeksLbl").innerHTML = 'Construction Period From';
		$("weeksLbl").show();
		$("constructFromSpan").show();
		$("consLbl").show();
		$("constructToSpan").show();
		$("mainFromLbl").show();
		$("mainFromSpan").show();
		$("mainToLbl").show();
		$("mainToSpan").show();
		$("principalInfoDiv").show();
		$("contractorInfoDiv").show();
		//added this fields to be required reymon 03122013
		$("enProjectName").addClassName("required");
		$("projDivAdd").addClassName("required");
		$("enSiteLoc").addClassName("required");
		$("siteDivAdd").addClassName("required");
		if($("constructFrom").value == "") {
			$("constructFrom").value = inceptDate;
		}
		if($("constructTo").value == "") {
			$("constructTo").value = expiryDate;
		}

		constFromPrev = $F("constructFrom");
		constToPrev = $F("constructTo");
		mainFromPrev = $F("mainFrom");
		mainToPrev = $F("mainTo");
	//} else if ($F("sublineCdParam") == "EER") { // subline == "EAR"
	} else if ($F("sublineCdParam") == "ERECTION_ALL_RISK") {
		document.getElementById("titleLbl").innerHTML = 'Project';
		document.getElementById("siteLbl").innerHTML = 'Site of Erection';
		$("weeksLbl").show();
		$("weeksTesting").show();
		$("principalInfoDiv").show();
		$("contractorInfoDiv").show();
		$("enProjectName").addClassName("required");
		$("projDivAdd").addClassName("required");
		$("enSiteLoc").addClassName("required");
		$("siteDivAdd").addClassName("required");
		
		
	//} else if ($F("sublineCdParam") == "MLOP" || $F("sublineCdParam") == "LOP") { // subline == "MLOP"
	} else if ($F("sublineCdParam") == "MACHINERY_LOSS_OF_PROFIT") {
		document.getElementById("titleLbl").innerHTML = 'Nature of Business';
		document.getElementById("siteLbl").innerHTML = 'The Premises';
		document.getElementById("weeksLbl").innerHTML = 'MBI Policy No';
		document.getElementById("mainFromLbl").innerHTML = 'Time Excess';
		$("weeksLbl").show();
		$("mainFromLbl").show();
		$("mbiPolNo").show();
		$("timeExcess").show();
	//} else if ($F("sublineCdParam") == "MBI" || $F("sublineCdParam") == "MB") { // subline == "MBI" || subline == "MB"
	} else if ($F("sublineCdParam") == "MACHINERY_BREAKDOWN_INSURANCE") {
		document.getElementById("titleLbl").innerHTML = 'Nature of Business';
		document.getElementById("siteLbl").innerHTML = 'Work Site';
		$("enProjectName").addClassName("required");
		$("projDivAdd").addClassName("required");
		$("enSiteLoc").addClassName("required");
		$("siteDivAdd").addClassName("required");
	//} else if ($F("sublineCdParam") == "DOS") { // subline == "DOS"
	} else if ($F("sublineCdParam") == "DETERIORATION_OF_STOCKS") {
		document.getElementById("titleLbl").innerHTML = 'Description';
		document.getElementById("siteLbl").innerHTML = 'Location of Refrigeration Plant';
	//} else if ($F("sublineCdParam") == "BPV" || $F("sublineCdParam") == "ECP") { // subline == "BPV" || subline == "EEI"
	} else if ($F("sublineCdParam") == "BOILER_AND_PRESSURE_VESSEL" || $F("sublineCdParam") == "ELECTRONIC_EQUIPMENT") {
		document.getElementById("titleLbl").innerHTML = 'Description';
		document.getElementById("siteLbl").innerHTML = 'The Premises';
		$("enProjectName").addClassName("required");
		$("projDivAdd").addClassName("required");
		$("enSiteLoc").addClassName("required");
		$("siteDivAdd").addClassName("required");
	//} else if ($F("sublineCdParam") == "PCP") { // subline == "PCP"
	} else if ($F("sublineCdParam") == "PRINCIPAL_CONTROL_POLICY") {
		document.getElementById("titleLbl").innerHTML = 'Description';
		document.getElementById("siteLbl").innerHTML = 'Territorial Limits';
	} else {
		document.getElementById("titleLbl").innerHTML = 'Title';
		document.getElementById("siteLbl").innerHTML = 'Location';
		$("enProjectName").addClassName("required");
		$("projDivAdd").addClassName("required");
		$("enSiteLoc").addClassName("required");
		$("siteDivAdd").addClassName("required");
	}

	$("togglePrincipal").observe("click", function() {
		if($("enPrincipalInfo").empty()) {
			showENPrincipalModal("P");
		}
	});
	$("toggleContractor").observe("click", function() {
		if($("enContractorInfo").empty()) {
			showENPrincipalModal("C");
		}
	});
	
	$("btnSave").observe("click", function() {
		//if(changeTag == 0) {
		//	noChanges();
		//} else {
			checkDataInput();
		//}
	});
	
	$("btnCancel").observe("click", function() {
		if(changeTag == 1) {
			showConfirmBox4("Confirm", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", saveAndCancel, exitENAddtl, "");
		} else {
			//showBasicInfo();
			exitENAddtl();
		}
	});
	
	observeReloadForm("reloadForm", showAdditionalENInfoPage);
	
	//replaced by code above - christian 04/19/2013
	/*$("reloadForm").observe("click", function() {
		if(changeTag == 1) {
			//showConfirmBox4("Confirm", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", saveAndReload, showAdditionalENInfoPage, "");
			showConfirmBox("Confirmation", objCommonMessage.RELOAD_WCHANGES, "Yes", "No", 
					function(){
						showAdditionalENInfoPage();
						changeTag = 0;
					}, stopProcess);
		}else{  
			showAdditionalENInfoPage();
		}
	});*/
		
	function checkDataInput() {
		var valid = true;
		if($F("enSiteLoc") == "") {
			if($("titleLbl").innerHTML == trim("TitleofContract")){ //changed from Title of Contract to TitleofContract reymon 03122013
				
			}else{
			showMessageBox(document.getElementById("siteLbl").innerHTML + " is required.", imgMessage.ERROR);
			valid = false;
			}
		} else if($F("enProjectName") == "") {
			if($("titleLbl").innerHTML == trim("TitleofContract")){ //changed from Title of Contract to TitleofContract reymon 03122013
				
			}else{
			showMessageBox(document.getElementById("titleLbl").innerHTML + " is required.", imgMessage.ERROR);
			valid = false;
			}
		} //else if($("weeksTesting").value == "" && subline == /*"EAR"*/"ERECTION_ALL_RISK") {
			/*showMessageBox("Weeks Testing/Commisioning is required.", imgMessage.ERROR);
			valid = false;
		 ** commented out by reymon 03052013
		 ** as per ma'am vj, weektesting can be null
		}*/ else if($("weeksTesting").value != "" && isNaN($F("weeksTesting")) && subline == "ERECTION_ALL_RISK"/*"EAR"*/) { //removed parseFloat function -- angelo 03.20.2014
			showMessageBox("Weeks Testing/Commisioning legal characters are 0-9 - + E.", imgMessage.ERROR);
			valid = false;
		//changed -999 to 0 reymon 03052013
		} else if((parseFloat($F("weeksTesting").replace(/,/g, "")) > 999 || parseFloat($F("weeksTesting").replace(/,/g, "")) < 0) && subline == "ERECTION_ALL_RISK"/*"EAR"*/) {
			showMessageBox("Weeks Testing/Commisioning must be in range 0 to 999", imgMessage.ERROR);
			valid = false;
		} else if($("timeExcess").value == "" && subline == "MACHINERY_LOSS_OF_PROFIT") {
			showMessageBox("Time Excess is required.", imgMessage.ERROR);
			valid = false;
		} else if(isNaN(parseFloat($F("timeExcess"))) && subline == "MACHINERY_LOSS_OF_PROFIT") {
			showMessageBox("Time Excess legal characters are 0-9 - + E.", imgMessage.ERROR);
			valid = false;
		} else if((parseFloat($F("timeExcess").replace(/,/g, "")) > 999 || parseFloat($F("timeExcess").replace(/,/g, "")) < -999) && subline == "MACHINERY_LOSS_OF_PROFIT") {
			showMessageBox("Time Excess must be in range -999 to 999", imgMessage.ERROR);
			valid = false;
		} else if (subline == "CONTRACTOR_ALL_RISK" || subline == "CONTRACTORS_ALL_RISK") {
			if(!($F("mainFrom").empty()) && $F("mainTo").empty()) {
				showMessageBox("Maintenance End Date is required.", imgMessage.ERROR);	
				valid = false;
			} else if ($F("mainFrom").empty() && !($F("mainTo").empty())) {
				showMessageBox("Maintenance From Date is required.", imgMessage.ERROR);	
				valid = false;
			} else if ($F("constructFrom").empty() || $F("constructTo").empty()) {
				showMessageBox("Contruction Period is required.", imgMessage.ERROR);
				valid = false;
			}
		} else if (subline == "MACHINERY_LOSS_OF_PROFIT" && ($F("mbiPolNo") == "" || $F("mbiPolNo") == null)) {
			showMessageBox("MBI Policy No. is required.", imgMessage.ERROR);
			valid = false;
		} 

		if(valid) {
			if(changeTag == 0){
				noChanges();
			}else{
				saveENInfo();
			}
		} else {
			return false;
		}
	}
/*commented out by reymon 03112013
**handled during saving	
	$("enProjectName").observe("blur", function() {
		var proj = $F("enProjectName").trim();
		if(proj == "" || $F("enProjectName") == null) {
			if($("titleLbl").innerHTML == trim("Title of Contract")){
			}else{
			showMessageBox(document.getElementById("titleLbl").innerHTML + " is required.", imgMessage.ERROR);
			$("enProjectName").focus();
			return false;
			}
		}
		
	});

	$("enSiteLoc").observe("blur", function() {
		var site = $F("enSiteLoc").trim();
		if(site == "") {
			if($("titleLbl").innerHTML == trim("Title of Contract")){
			}else{
			showMessageBox(document.getElementById("siteLbl").innerHTML + " is required.", imgMessage.ERROR);
			$("enSiteLoc").focus();
			return false;
			}
		}
	});

	$("weeksTesting").observe("blur", function(){
		if (!isNaN(parseFloat($F("weeksTesting"))) && $F("weeksTesting") != ""){
			$("weeksTesting").value = formatNumber(parseFloat($F("weeksTesting")));
		}  else if(isNaN(parseFloat($F("weeksTesting"))) && subline == "EAR") {
			showMessageBox("Weeks Testing/Commisioning legal characters are 0-9 - + E.", imgMessage.ERROR);
			return false;
		}  else if((parseFloat($F("weeksTesting").replace(/,/g, "")) > 999 || parseFloat($F("weeksTesting").replace(/,/g, "")) < -999) && subline == "EAR") {
			showMessageBox("Weeks Testing/Commisioning must be in range -999 to 999", imgMessage.ERROR);
			return false;
		} 
	});

	$("timeExcess").observe("blur", function(){
		if (!isNaN(parseFloat($F("timeExcess"))) && $F("timeExcess") != ""){
			$("timeExcess").value = formatNumber(parseFloat($F("timeExcess")));
		} else if(isNaN(parseFloat($F("timeExcess"))) && subline == "MACHINERY_LOSS_OF_PROFIT") {
			showMessageBox("Time Excess legal characters are 0-9 - + E.", imgMessage.ERROR);
			return false;
		}  else if((parseFloat($F("timeExcess").replace(/,/g, "")) > 999 || parseFloat($F("timeExcess").replace(/,/g, "")) < -999) && 
				subline == "MACHINERY_LOSS_OF_PROFIT") {
			showMessageBox("Time Excess must be in range -999 to 999.", imgMessage.ERROR);
			return false;
		} 
	});
*/
	$("constructFrom").observe("blur", function() {	validateConstruction("from");	});
	$("constructTo").observe("blur", function() {	validateConstruction("to");		});
	$("mainFrom").observe("blur", function () {	validateMaintenance("from");	});
	$("mainTo").observe("blur", function() {	validateMaintenance("to");	});
	
	function validateConstruction(elem) {
		if(subline == "CONTRACTOR_ALL_RISK" || subline == "CONTRACTORS_ALL_RISK") {
			var constFrom = makeDate($F("constructFrom"));
			var constTo = makeDate($F("constructTo"));
			var maintFrom = makeDate($F("mainFrom"));
			var maintTo = makeDate($F("mainTo"));
			var incept = makeDate(inceptDate);
			var expiry = makeDate(expiryDate);
	
			if (constTo > expiry) {
				showMessageBox("Construction To Date should not be later than Expiry Date.", imgMessage.ERROR);
				$("constructTo").value = constToPrev;
				return false;
			} else if (constFrom > constTo && elem == "from") {
				showMessageBox("Construction Period From Date must be earlier than Construction Period To Date.", imgMessage.ERROR);
				$("constructFrom").value = constFromPrev;
				return false;
			} else if (constTo < constFrom && elem == "to") {
				//commented out by Rodel 04/19/2012
				//showMessageBox("Construction Period End Date must not be earlier than Construction Period From Date.", imgMessage.ERROR);
				
				//Added by Rodel 04/19/2012
				showMessageBox("Construction Period To Date must not be earlier than Construction Period From Date.", imgMessage.ERROR);
				$("constructTo").value = constToPrev;
				return false;
			} else if (elem == "to" && constTo > maintFrom || constTo > maintTo) {
				showMessageBox("Construction Period End Date must be earlier than Maintenance Period", imgMessage.ERROR);
				$("constructTo").value = constToPrev;
				return false;
			} else {
				constFromPrev = $F("constructFrom");
				constToPrev = $F("constructTo");
				hideNotice();
			}
		}
	}

	function validateMaintenance(elem) {
		if(subline == "CONTRACTOR_ALL_RISK" || subline == "CONTRACTORS_ALL_RISK") {
			var constFrom = makeDate($F("constructFrom"));
			var constTo = makeDate($F("constructTo"));
			var maintFrom = makeDate($F("mainFrom"));
			var maintTo = makeDate($F("mainTo"));
			var incept = makeDate(inceptDate);
			var expiry = makeDate(expiryDate);

			if (maintFrom < constTo) {
				showMessageBox("Maintenance Period From Date must not be earlier than Construction Period To Date.", imgMessage.ERROR);
				$("mainFrom").value = mainFromPrev;
				return false;
			} else if(!(maintTo == "" || maintTo == null) && maintFrom > maintTo && elem == "from") {
				showMessageBox("Maintenance Period From Date must be earlier than Maintenance Period To Date", imgMessage.ERROR);
				$("mainFrom").value = mainFromPrev;
				return false;
			} else if(!(maintFrom == "" || maintFrom == null) && maintFrom > maintTo && elem == "to") {
				showMessageBox("Maintenance Period End Date must not be earlier than Maintenance Period From Date", imgMessage.ERROR);
				$("mainTo").value = mainToPrev;
				return false;
			} else if(maintTo < constTo) {
				showMessageBox("Maintenance Period End Date must not be earlier than Construction Period To Date.", imgMessage.ERROR);
				$("mainTo").value = mainToPrev;
				return false;	
			} else {
				mainFromPrev = $F("mainFrom");
				mainToPrev = $F("mainTo");
				hideNotice();
			}	
		}
	}

	/* transferred to underwriting.js by andrew - 03.29.2011 - para matawag din sa ibang page, pwede na burahin pag ok na :)
	function prepareParams() {
		try {
			var prnParams = new Object();
			
			if(subline == "CAR" || subline == "EAR") {
				prnParams.savedPrincipals 	= addedENPrincipals;//getENItemJSON("P") == null ? "" : getENItemJSON("P");
				prnParams.delPrincipals 	= delENPrincipals;//getENItemJSON("D") == null ? "" : getENItemJSON("D");
								
				return JSON.stringify(prnParams);
			} else {
				return null;
			}						
		} catch(e) {
			showErrorMessage("prepareParams", e);
		}
	}*/

	/* transferred to underwriting.js by andrew - 03.29.2011 - para matawag din sa ibang page, pwede na burahin pag ok na :)
	function prepareENParams() {
		var enParams = JSON.parse('{' +
				'"parId" : '+ (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"))+',' + 
				'"projTitle" : "'+escapeHTML2($F("enProjectName"))+'",' +
				'"siteLocation" : "'+escapeHTML2($F("enSiteLoc"))+'",' +
				'"consStartDate" : "'+$F("constructFrom")+'",' +
				'"consEndDate" : "'+$F("constructTo")+'",' +
				'"maintStartDate" : "'+$F("mainFrom")+'",' +
				'"maintEndDate" : "'+$F("mainTo")+'",' + 
				'"weeksTest" : "'+$F("weeksTesting")+'"}');
		return enParams;
	}*/

	/* transferred to underwriting.js by andrew - 03.29.2011 - para matawag din sa ibang page, pwede na burahin pag ok na :)	
	function saveENInfo() {
		try {
			var enParam = JSON.stringify(prepareENParams());
			//var enParam = JSON.stringify(prepareENParams()).replace('"[', "[").replace(']"', "]").replace(/\\n/g, "&#10").replace(/\\/g, "").replace(/&#10/g,"\\\\n");
			var additionalParam = prepareParams();
			new Ajax.Request(contextPath+"/GIPIWENAdditionalInfoController?action=setENBasicInfo", {
				method: "POST",
				asynchronous: true,
				//postBody:   changeSingleAndDoubleQuotes(fixTildeProblem(Form.serialize("additionalENInfoForm"))),
				parameters: {additionalParam:  additionalParam,
							 enParam: enParam,
							 enSubline: subline,
							 globalParId: (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"))},			 				 
				onCreate: function() {
					$("btnSave").disable();
					$("btnCancel").disable();
					showNotice("Saving, please wait...");
				},
				onComplete: function() {
					changeTag = 0;
					hideNotice();
					$("btnSave").enable();
					$("btnCancel").enable();
					showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);					
				}
			});	
		} catch(e) {
			showErrorMessage("saveENInfo", e);
		}
	}*/

	function showENPrincipalModal(pType) {
		var changeDiv = "";
		if(pType == "P") {
			changeDiv = "enPrincipalInfo";
		} else if(pType == "C") {
			changeDiv = "enContractorInfo";
		}
		try {
			new Ajax.Updater(changeDiv, contextPath+"/GIPIWENAdditionalInfoController", {
				method: 		"GET",
				asynchronous: 	true,
				evalScripts: 	true,
				parameters: 	{
									action: "showPrincipalInfo",
									globalParId: (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId")),
									pType: pType	
								},
				onCreate: function() {
					setCursor("Please Wait");
				},
				onComplete: function() {
					setCursor("default");
				}
				
			});
		} catch(e) {
			showErrorMessage("showENPrincipalModal", e);
		}
	}

	function exitENAddtl(){
		try {
			Effect.Fade("parInfoDiv", {
				duration: .001,
				afterFinish: function () {
					if(objUWGlobal.packParId != null){
						showPackParListing();
						return;
					}
					if ($("parListingMainDiv").down("div", 0).next().innerHTML.blank()) {
						if($F("globalParType") == "E"){
							showEndtParListing();
						}else{							
							showParListing();
						}
					} else {
						$("parInfoMenu").hide();
						Effect.Appear("parListingMainDiv", {duration: .001});
					}
					$("parListingMenu").show();
				}
			});
			// Added by Rodel 04/24/2012
			// To avoid the confirmation box to appear in "List of Policy Action Records for ENGINEERING" page after not saving the changes
			changeTag = 0;
		} catch (e) {
			showErrorMessage("exitENAddtl", e);
		}
	}

	$("editProjText").observe("click", function () {
		showEditor("enProjectName", 250);
	});

	$("editSiteText").observe("click", function () {
		showEditor("enSiteLoc", 250);
	});

	$("enProjectName").observe("keyup", function () {
		limitText(this, 250);
	});

	$("enSiteLoc").observe("keyup", function () {
		limitText(this, 250);
	});

/*	$("weeksTesting").observe("keyup", function() {
		limitText(this, 4);
	});

	$("timeExcess").observe("keyup", function() {
		limitText(this, 4);
	});*/

	$("mbiPolNo").observe("keyup", function() {
		limitText(this, 30);
	});

	function saveAndReload() {
		saveENInfo();
		showAdditionalENInfoPage();
	}

	function saveAndCancel() {
		saveENInfo();
		//showBasicInfo();
		exitENAddtl();
	}

	$$("div#additionalENInfoFormDiv input[type='text']").each(function(text) {
		$(text.id).observe("change", function() {
			changeTag = 1;
		});
	});

	$$("div#additionalENInfoFormDiv img").each(function(imgs) {
		$(imgs.id).observe("click", function() {
			changeTag = 1;
		});
	});
	
	//Added by Rodel 04/20/2012
 	$("weeksTesting").observe("keyup", function(){
		if($("weeksTesting").value.charAt(0) == "-" || $("weeksTesting").value.charAt(0) == "+" ){
			$("weeksTesting").maxLength = "4";
		}else{
			$("weeksTesting").maxLength = "3";
		}
	});
	
 	//Added by Rodel 04/20/2012
 	$("timeExcess").observe("keyup", function(){
		if($("timeExcess").value.charAt(0) == "-" || $("timeExcess").value.charAt(0) == "+" ){
			$("timeExcess").maxLength = "4";
		}else{
			$("timeExcess").maxLength = "3";
		}
	});
	
	observeBackSpaceOnDate("mainFrom");
	observeBackSpaceOnDate("mainTo");

	changeTag = 0;
	initializeChangeTagBehavior(saveENInfo);
	initializeChangeAttribute();
	
	/* sampleToggleToggle();
	function sampleToggleToggle(){
		if(trim($("titleLbl").innerHTML) == trim("Title of Contract")){
			$("projDivAdd").removeClassName("required");
			$("siteDivAdd").removeClassName("required");
			$("enProjectName").removeClassName("required");
			$("enSiteLoc").removeClassName("required");
			$("constructFrom").removeClassName("required");
			$("constructFromSpan").removeClassName("required");
			$("constructTo").removeClassName("required");
			$("constructToSpan").removeClassName("required");
		}else if(trim($("titleLbl").innerHTML) == trim("Project")){
			$("projDivAdd").removeClassName("required");
			$("siteDivAdd").removeClassName("required");
			$("enProjectName").removeClassName("required");
			$("enSiteLoc").removeClassName("required");
		}else if(trim($("titleLbl").innerHTML) == trim("Nature of Business")){
			$("projDivAdd").removeClassName("required");
			$("siteDivAdd").removeClassName("required");
			$("enProjectName").removeClassName("required");
			$("enSiteLoc").removeClassName("required");
		}else{
			$("projDivAdd").addClassName("required");
			$("siteDivAdd").addClassName("required");
			$("enProjectName").addClassName("required");
			$("enSiteLoc").addClassName("required");
			$("constructFrom").addClassName("required");
			$("constructFromSpan").addClassName("required");
			$("constructTo").addClassName("required");
			$("constructToSpan").addClassName("required");
		} 
	} */
	
	$("constructFrom").observe("blur",function(){
		validateDate("constructFrom");
	});
	
	$("constructTo").observe("blur",function(){
		validateDate("constructTo");
	});
	
	function validateDate(date){
		var sysdate = new Date();
		if(makeDate($F(date)) > makeDate($F("enExpiryDate"))){
			showMessageBox("Date must not be later than the Expiry Date.", imgMessage.ERROR);
			$(date).value = dateFormat(sysdate,"mm-dd-yyyy");
		}else if(makeDate($F(date)) < makeDate($F("enInceptDate"))){
			showMessageBox("Date must not be beyond the Incept Date.", imgMessage.ERROR);
			$(date).value = dateFormat(sysdate,"mm-dd-yyyy");
		}else{
			
		}
	}
</script>