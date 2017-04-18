<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<script type="text/javascript">
try{
	objUW.hidObjGIPIS002 = {};
	objUW.hidObjGIPIS002.forSaving 		= false;
	objUW.hidObjGIPIS002.reqCredBranch 	= ('${reqCredBranch}');
	objUW.hidObjGIPIS002.defCredBranch 	= ('${defCredBranch}');
	objUW.hidObjGIPIS002.updCredBranch =  ('${updCredBranch}');
	objUW.hidObjGIPIS002.dispDefaultCredBranch = ('${dispDefaultCredBranch}'); // Kris 07.04.2013 for UW-SPECS-2013-091
	objUW.hidObjGIPIS002.reqRefPolNo 	= ('${reqRefPolNo}');
	objUW.hidObjGIPIS002.reqRefNo 		= ('${reqRefNo}'); //added by gab 11.15.2016 SR 3147,3027,2645,2681,3148,3206,3264,3010
	objUW.hidObjGIPIS002.updIssueDate	= ('${updIssueDate}');
	objUW.hidObjGIPIS002.issCdRi		= ('${issCdRi}');
	objUW.hidObjGIPIS002.typeCdStatus	= ('${typeCdStatus}');
	objUW.hidObjGIPIS002.ora2010Sw		= ('${ora2010Sw}');
	objUW.hidObjGIPIS002.incrRepl		= ('${incrRepl}');
	objUW.hidObjGIPIS002.gipiWPolbasExist	= ('${isExistGipiWPolbas}');
	objUW.hidObjGIPIS002.gipiWItmperlExist	= ('${isExistGipiWItmperl}');
	objUW.hidObjGIPIS002.gipiWinvTaxExist	= ('${isExistGipiWinvTax}');
	objUW.hidObjGIPIS002.gipiWPolnrepExist	= ('${isExistGipiWPolnrep}');
	//objUW.hidObjGIPIS002.gipiWOpenPolicyExist	= ('${isExistGipiWOpenPolicy}');
	objUW.hidObjGIPIS002.gipiWItemExist		= ('${isExistGipiWItem}');
	objUW.hidObjGIPIS002.gipiWInvoiceExist	= ('${isExistGipiWInvoice}');
	objUW.hidObjGIPIS002.lineCd				= ('${gipiParList.lineCd}');
	objUW.hidObjGIPIS002.paramSublineCdDesc = "";
	objUW.hidObjGIPIS002.paramSublineCd		= ('${gipiWPolbas.sublineCd }');
	objUW.hidObjGIPIS002.mnSublineMop		= ('${mnSublineMop}');
	objUW.hidObjGIPIS002.lcMN				= ('${lcMN}');	
	objUW.hidObjGIPIS002.lcMN2				= ('${lcMN2}');
	objUW.hidObjGIPIS002.reqSurveySettAgent = ('${reqSurveySettAgent}');
	objUW.hidObjGIPIS002.opFlag				= "N";
	objUW.hidObjGIPIS002.invoiceSwB540		= ('${gipiWPolbas.invoiceSw}');
	objUW.hidObjGIPIS002.designationB540	= ('${gipiWPolbas.designation}');
	objUW.hidObjGIPIS002.issCdB540			= ('${gipiWPolbas.issCd}');
	//objUW.hidObjGIPIS002.isOpenPolicy		= "N";
	objUW.hidObjGIPIS002.deleteAllTables	= "N";
	objUW.hidObjGIPIS002.deleteBillSw		= "N";	
	objUW.hidObjGIPIS002.deleteSwForAssdNo	= "N";	
	objUW.hidObjGIPIS002.deleteWPolnrep		= "N";	
	objUW.hidObjGIPIS002.deleteCoIns		= "";
	objUW.hidObjGIPIS002.validatedIssuePlace = "N";
	//objUW.hidObjGIPIS002.validatedBookingDate = "N";
	objUW.hidObjGIPIS002.issueYy			= ('${gipiWPolbas.issueYy }');
	objUW.hidObjGIPIS002.geninInfoCd 		= ('${gipiWPolGenin.geninInfoCd}');
	objUW.hidObjGIPIS002.paramCompSw 		= ('${gipiWPolbas.compSw}');
	objUW.hidObjGIPIS002.updateBooking 		= ('${updateBooking}');
	objUW.hidObjGIPIS002.precommitDelTab	= "N";
	if (objUW.hidObjGIPIS002.ora2010Sw == "Y"){
		objUW.hidObjGIPIS002.companyLOV			= JSON.parse('${companyListingJSON}'.replace(/\\/g, '\\\\'));
		objUW.hidObjGIPIS002.employeeLOV		= JSON.parse('${employeeListingJSON}'.replace(/\\/g, '\\\\'));
		objUW.hidObjGIPIS002.bancTypeCdLOV		= JSON.parse('${bancTypeCdListingJSON}'.replace(/\\/g, '\\\\'));	
		objUW.hidObjGIPIS002.bancAreaCdLOV		= JSON.parse('${bancAreaCdListingJSON}'.replace(/\\/g, '\\\\'));	
		objUW.hidObjGIPIS002.bancBranchCdLOV	= JSON.parse('${bancBranchCdListingJSON}'.replace(/\\/g, '\\\\'));	
		objUW.hidObjGIPIS002.managerCd			= ('${gipiWPolbas.managerCd}');;
		objUW.hidObjGIPIS002.planCdLOV			= JSON.parse('${planCdListingJSON}'.replace(/\\/g, '\\\\'));	
	}
}catch(e){
	showErrorMessage("packBasicMain", e);
}
</script>

<div id="basicInformationMainDiv" style="margin-top: 1px;" changeTagAttr="true">
	<div id="message" style="display:none;">${message}</div>
	<form id="basicInformationForm" name="basicInformationForm">
		<input type="hidden" name="globalParId"  id="globalParId"  value="<c:if test="${not empty gipiParList}">${gipiParList.packParId}</c:if>" />
		<input type="hidden" name="globalLineCd" id="globalLineCd" value="<c:if test="${not empty gipiParList}">${gipiParList.lineCd}</c:if>"></input>
		<input type="hidden" name="globalIssCd" id="globalIssCd" value="<c:if test="${not empty gipiParList}">${gipiParList.issCd}</c:if>" />
		<input type="hidden" name="parType" 	id="parType"  	value="${gipiParList.parType}" />
		<input type="hidden" name="parId" 		id="parId" 		value="<c:if test="${not empty gipiParList}">${gipiParList.packParId}</c:if>" />
		<input type="hidden" name="lineCd" 		id="lineCd" 	value="<c:if test="${not empty gipiParList}">${gipiParList.lineCd}</c:if>" />
		<input type="hidden" name="issCd" 		id="issCd" 		value="<c:if test="${not empty gipiParList}">${gipiParList.issCd}</c:if>" />
		<input type="hidden" name="parStatus" 	id="parStatus"  value="<c:if test="${not empty gipiParList}">${gipiParList.parStatus}</c:if>" />
		<input type="hidden" name="endtYy" 		id="endtYy" 	value="${gipiWPolbas.endtYy}<c:if test="${empty gipiWPolbas.endtYy}">0</c:if>" />
		<input type="hidden" name="endtSeqNo" 	id="endtSeqNo" 	value="${gipiWPolbas.endtSeqNo}<c:if test="${empty gipiWPolbas.endtSeqNo}">0</c:if>" />
		<input type="hidden" name="samePolnoSw" id="samePolnoSw" value="${gipiWPolbas.samePolnoSw}">
		<input type="hidden" name="varVdate" 	id="varVdate" 	value="${varVdate }" />
		<input type="hidden" name="updateIssueDate" id="updateIssueDate" value="N" />
		<input type="hidden" name="pageName" 	id="pageName" 	value="basicInformation" />
		
		<jsp:include page="../../subPages/basicInformation.jsp"></jsp:include>
		<jsp:include page="../../subPages/poi.jsp"></jsp:include>
		<div id="renewalDetail">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
			   		<label>Renewal / Replacement Detail</label>
			   		<span class="refreshers" style="margin-top: 0;">
			   			<label id="showRenewal" name="gro" style="margin-left: 5px;">Show</label>
			   		</span>
			   	</div>
			</div>
			<div id="policyRenewalDiv" align="center" class="sectionDiv" style="display: none;" >
			</div>
		</div>
		<c:if test="${ora2010Sw eq 'Y'}">
			<jsp:include page="../../subPages/bankPaymentDetails.jsp"></jsp:include>
			<jsp:include page="../../subPages/bancaDtls.jsp"></jsp:include>
		</c:if>
		<div id="mortgageePopups">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
			   		<label>Mortgagee Information</label>
			   		<span class="refreshers" style="margin-top: 0;">
			   			<label id="showMortgagee" name="gro" style="margin-left: 5px;">Show</label>
			   		</span>
			   	</div>
			</div>	
			<div id="mortgageeInfo" class="sectionDiv" style="display: none;"></div>
			<input type="hidden" id="mortgageeLevel" name="mortgageeLevel" value="0" />			
		</div>
		<jsp:include page="../../subPages/otherDetails.jsp"></jsp:include>
	</form>
	<div id="basicInfoDiv" name="basicInfoDiv" style="display: none;">
	</div>
	<form id="basicInformationFormButton" name="basicInformationFormButton">
		<div class="buttonsDiv" style="float:left; width: 100%;">
			<table align="center">
				<tr>
					<td>
						<input type="button" class="button" id="btnCancel" name="btnCancel" value="Cancel" style="width: 60px;" /></td>
					<td>
						<input type="button" class="button" id="btnSave" name="btnSave" value="Save" style="width: 60px;" /></td>
				</tr>
			</table>
		</div>
	</form>
</div>

<script type="text/JavaScript">
try{
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	
	function observeLabelTag(){
		if($("labelTag").checked){
			$("rowInAccountOf").innerHTML = "Leased to";
		}else{
			$("rowInAccountOf").innerHTML = "In Account Of";
		}
	}
	
	function initializePackBasicInfo() {
		try{
			if (($("policyStatus").value == 2) || ($("policyStatus").value == 3)){
				$("renewalDetail").setStyle({display : ""}); 
				objUW.hidObjGIPIS002.deleteWPolnrep = "N";
			} else {
				$("renewalDetail").setStyle({display : "none"});
				objUW.hidObjGIPIS002.deleteWPolnrep = "Y";
			}	
	
			if (objUW.hidObjGIPIS002.gipiWPolbasExist != "1") {
				$("mortgageeInfo").hide();
			}
	
			if ($("defaultDoe").value != $("doe").value){
				$("prorateFlag").enable();
			} else {
				$("prorateFlag").disable();
			}
	
			if (objUW.hidObjGIPIS002.issCdRi == $("issCd").value){
				$("coIns").disable();
			}

			if(objUW.hidObjGIPIS002.typeCdStatus == "N"){
				$("typeOfPolicy").disable();
			}
			$("uwParParametersDiv").update("");	
			observeLabelTag();
			objUW.hidObjGIPIS002.paramSublineCdDesc = getListTextValue("sublineCd");
			$("manualRenewNo").value = formatNumberDigits($F("manualRenewNo"),2);
		} catch (e) {
			showErrorMessage("initializePackBasicInfo", e);
		}
	}
	
	initializePackBasicInfo();
	setModuleId("GIPIS002A");

	$("packagePolicy").disable();
	$("quotationPrinted").disable();
	$("covernotePrinted").disable();
	$("fleetTag").disable();

	$("takeupTermType").hide();
	$("takeUpTermLabel").innerHTML = "";

	//for Leased tag label
	$("labelTag").observe("click", function(){
		observeLabelTag();
	});

	$("showMortgagee").observe("click", function(){
		if($("mortgageeInfo").empty()){
			if(objUW.hidObjGIPIS002.gipiWPolbasExist == "1"){
				showMortgageeInfoModalForPackage(objUWGlobal.packParId, "0");
			}else{
				showMessageBox("Mortgagee Entry is not available. Please save record first.", imgMessage.INFO);
				$("showMortgagee").innerHTML = "Show";
			}
		}		
	});

	$("showRenewal").observe("click", function() {
		if($("wpolnrepOldPolicyId") == null){
			openPackageRenewalReplacementDetailModal();
		}
	});

	$("sublineCd").observe("change", function(){
		var paramSubline = $("paramSubline").value;
		var sublineCd = $("sublineCd").value;
		if (sublineCd == "") {
			showMessageBox("Subline is required.", imgMessage.ERROR);
			$("sublineCd").value = $("paramSubline").value;
		}
		if ((paramSubline != sublineCd )&&(sublineCd != "")) {
			if((objUW.hidObjGIPIS002.gipiWPolbasExist == "1") && (objUW.hidObjGIPIS002.gipiWItmperlExist == "1")){
				showMessageBox("The subline code of this PAR cannot be updated, for detail records already" +
		                  	   " exist.  However, you may choose to delete this PAR and recreate it with the" +
		                  	   " necessary changes.", imgMessage.INFO);
				$("sublineCd").value = $("paramSubline").value;
           	   return false;
			}
			if ($F("policyStatus") == "2" || $F("policyStatus") == "3"){
				if($("wpolnrepSublineCd") != null){ 
					$("wpolnrepSublineCd").value = sublineCd;
				}
			}
		}
	});

	$("policyStatus").observe("change", function () {
		if (($("policyStatus").value == 1) || ($("policyStatus").value == 2) 
			|| ($("policyStatus").value == 3)|| ($("policyStatus").value == 4) 
			|| ($("policyStatus").value == 5) || ($("policyStatus").value == 'S')){
			null;
		} else if ($("policyStatus").value == ""){
			$("policyStatus").value = $("paramPolicyStatus").value;
			showMessageBox("Policy Status is required.", imgMessage.ERROR);	
		} else {
			$("policyStatus").value = $("paramPolicyStatus").value;
			showMessageBox("Invalid policy status.", imgMessage.ERROR);
		}	

		if (($("paramPolicyStatus").value == 2) || ($("paramPolicyStatus").value == 3)){
			if  ($("policyStatus").value == 1) {
				$("renewNo").value = 0; 
			} else if ($("policyStatus").value == $("paramPolicyStatus").value) {
				$("renewNo").value = $("paramRenewNo").value;
			}					
		}	

		if ($F("paramPolicyStatus") != $F("policyStatus")) {
			if (objUW.hidObjGIPIS002.gipiWPolbasExist == "1"){
				objUW.hidObjGIPIS002.deleteWPolnrep = "Y";	
			}	
		} else {
			objUW.hidObjGIPIS002.deleteWPolnrep = "N";
		}		

		if (($F("policyStatus") == "2") || ($F("policyStatus") == "3")){
			$("renewalDetail").setStyle({display : ""});  
			objUW.hidObjGIPIS002.deleteWPolnrep = "N";
		} else {
			$("renewalDetail").setStyle({display : "none"});  
			objUW.hidObjGIPIS002.deleteWPolnrep = "Y";
		}

		if ($("samePolicyNo") != null){ 
			($F("policyStatus") == 3 && objUW.hidObjGIPIS002.incrRepl == "N" ? $("samePolicyNo").disable() : $("samePolicyNo").enable()); 	
			//clearRenewalReplacementGIPIS002A();
		}
		
	});

	$("doe").observe("blur", function () {
		if ($F("doe") != $F("paramDoe") && $F("doe") != "") {
			if (($("paramProrateFlag").value == "1")&&(objUW.hidObjGIPIS002.deleteBillSw == "N")) {
				if ((objUW.hidObjGIPIS002.gipiWPolbasExist == "1") && (objUW.hidObjGIPIS002.gipiWItmperlExist == "1")){
					showConfirmBox("Message", "You have changed your policy's expiry date from "+$("paramDoe").value+" to "+$("doe").value+'. Will now do the necessary changes.',  
							"Ok", "Cancel", onOkFunc, onCancelFunc);
				}
			}		
		}
		function onOkFunc() {
			deleteBillFunc();	
		}	
		function onCancelFunc() {
			$("doe").value = $F("paramDoe");
			objUW.hidObjGIPIS002.deleteBillSw = "N";
			$("doe").focus();
			$("prorateFlag").value = $F("paramProrateFlag");
			showRelatedSpan();
			$("prorateFlag").enable();
			objUW.hidObjGIPIS002.forSaving = false;
		}	
	});

	$("doi").observe("blur", function() { 
		if ($F("paramDoi") != $F("doi")) {
			if (($("paramProrateFlag").value == "1")&&(objUW.hidObjGIPIS002.deleteBillSw == "N")) {
				if ((objUW.hidObjGIPIS002.gipiWPolbasExist == "1") && (objUW.hidObjGIPIS002.gipiWItmperlExist == "1")){
					showConfirmBox("Message", "You have changed your policy's inception date from "+$("paramDoi").value+" to "+$("doi").value+'. Will now do the necessary changes.',  
							"Ok", "Cancel", onOkFunc, onCancelFunc);
				}	
			}
		}	
		function onOkFunc() {
			deleteBillFunc();
		}	
		function onCancelFunc() {
			$("doi").value = $F("paramDoi");
			$("doe").value = $F("paramDoe");
			objUW.hidObjGIPIS002.deleteBillSw = "N";
			$("doi").focus();
			$("prorateFlag").value = $F("paramProrateFlag");
			showRelatedSpan();
			$("prorateFlag").enable();
			objUW.hidObjGIPIS002.forSaving = false;
		}	
		/*if ($F("doi") != ""){
			if ((objUW.hidObjGIPIS002.issueYy == null)||(objUW.hidObjGIPIS002.issueYy == "")) {
				getIssueYyGIPIS002();
			}
		}*/
	});

	$("assuredName").observe("focus", function () {
		if ($("assuredNo").value != $("paramAssuredNo").value) {
			showConfirmBox("Message", "Change of Assured will automatically recreate invoice and delete corresponding data on group information both ITEM and GROUP level. Do you wish to continue?", 
					"Yes", "No", onOkFunc, onCancelFunc);
		}else{
			objUW.hidObjGIPIS002.deleteSwForAssdNo	= "N";
		} 
		function onOkFunc(){
			objUW.hidObjGIPIS002.deleteSwForAssdNo	= "Y";
			disableMenu("post");
			disableMenu("enterInvoiceCommission");
		}	
		function onCancelFunc(){
			objUW.hidObjGIPIS002.deleteSwForAssdNo	= "N";
			$("assuredNo").value = $("paramAssuredNo").value;
			$("assuredName").value = $("paramAssuredName").value;
			objUW.hidObjGIPIS002.forSaving = false;
		}	
	});

	$("provisionalPremium").observe("change", function() {
		if (objUW.hidObjGIPIS002.deleteBillSw == "N") {
			if ((objUW.hidObjGIPIS002.gipiWPolbasExist == "1") && (objUW.hidObjGIPIS002.gipiWItmperlExist == "1")){
				if ($F("provisionalPremium") == "Y"){
					$("provPremRatePercent").blur();
					showConfirmBox("Message", "You have tagged your prov. prem. Will now do the necessary changes.",  
						"Ok", "Cancel", onOkFunc, onCancelFunc);
				} else {
					$("provPremRatePercent").blur();
					showConfirmBox("Message", "You have untagged your prov. prem. Will now do the necessary changes.",  
						"Ok", "Cancel", onOkFunc, onCancelFunc);
				}		
			}
		}
			
		function onOkFunc() {
			deleteBillFunc();
		}	
		function onCancelFunc() {
			if ($("provisionalPremium").checked) {
				$("provisionalPremium").checked = false;
				$("provPremRate").hide();
			} else {
				$("provisionalPremium").checked = true;
				$("provPremRate").show();
			}	
			objUW.hidObjGIPIS002.deleteBillSw = "N";
			objUW.hidObjGIPIS002.forSaving = false;
		}	
	});

	$("provPremRatePercent").observe("blur", function() {
		if (objUW.hidObjGIPIS002.deleteBillSw == "N") {
			if ((objUW.hidObjGIPIS002.gipiWPolbasExist == "1") && (objUW.hidObjGIPIS002.gipiWItmperlExist == "1")){
				if ($F("provPremRatePercent") != $F("paramProvPremRatePercent")){
					showConfirmBox("Message", "You have updated your option from "+$("paramProvPremRatePercent").value+" to "+$("provPremRatePercent").value+". Will now do the necessary changes.",  
						"Ok", "Cancel", onOkFunc, onCancelFunc);
				}		
			}
		}
		function onOkFunc() {
			deleteBillFunc();
		}	
		function onCancelFunc() {
			$("provPremRatePercent").value = $F("paramProvPremRatePercent");
			objUW.hidObjGIPIS002.deleteBillSw = "N";
			objUW.hidObjGIPIS002.forSaving = false;
		}	
	});		

	$("shortRatePercent").observe("blur", function() {
		if (objUW.hidObjGIPIS002.deleteBillSw == "N" && $F("shortRatePercent") != "") {
			if ((objUW.hidObjGIPIS002.gipiWPolbasExist == "1") && (objUW.hidObjGIPIS002.gipiWItmperlExist == "1")){
				if ($F("shortRatePercent") != $F("paramShortRatePercent")){
					showConfirmBox("Message", "You have updated short rate percent from "+$("paramShortRatePercent").value+" to "+$("shortRatePercent").value+". Will now do the necessary changes.",  
						"Ok", "Cancel", onOkFunc, onCancelFunc);
				}		
			}
		}
		function onOkFunc() {
			deleteBillFunc();
		}	
		function onCancelFunc() {
			$("shortRatePercent").value = $F("paramShortRatePercent");
			objUW.hidObjGIPIS002.deleteBillSw = "N";
			objUW.hidObjGIPIS002.forSaving = false;
		}	
	});

	$("compSw").observe("change", function(){
		if (objUW.hidObjGIPIS002.deleteBillSw == "N") {
			if ((objUW.hidObjGIPIS002.gipiWPolbasExist == "1") && (objUW.hidObjGIPIS002.gipiWItmperlExist == "1")){
				if ($F("noOfDays") != $F("paramNoOfDays")){
					showConfirmBox("Message", "You have changed the computation for the policy no of days. <br />Will now do the necessary changes.",  
						"Ok", "Cancel", onOkFunc, onCancelFunc);
				}		
			}
		}
		function onOkFunc() {
			deleteBillFunc();
		}
		function onCancelFunc() {
			$("compSw").value = objUW.hidObjGIPIS002.paramCompSw;
			$("noOfDays").value = computeNoOfDays($F("doi"),$F("doe"),$F("compSw"));
			objUW.hidObjGIPIS002.deleteBillSw = "N";
			objUW.hidObjGIPIS002.forSaving = false;
		}
	});

	$("noOfDays").observe("blur", function(){
		if (objUW.hidObjGIPIS002.deleteBillSw == "N") {
			if ((objUW.hidObjGIPIS002.gipiWPolbasExist == "1") && (objUW.hidObjGIPIS002.gipiWItmperlExist == "1")){
				if ($F("noOfDays") != $F("paramNoOfDays")){
					showConfirmBox("Message", "You have updated policy's no. of days from "+$("paramNoOfDays").value+" to "+$("noOfDays").value+". Will now do the necessary changes.",  
						"Ok", "Cancel", onOkFunc, onCancelFunc);
				}		
			}
		}
		function onOkFunc() {
			var addtl = 0;
			if ("Y" == $F("compSw")) {
				addtl = -1;
			} else if ("M" == $F("compSw")) {
				addtl = 1;
			}
			var newDate = Date.parse($F("doi"));
			var num = $("noOfDays").value;
			num = num*1+addtl;
			newDate.add(num).days();
			var month = newDate.getMonth()+1 < 10 ? "0" + (newDate.getMonth()+1) : newDate.getMonth()+1;
			$("doe").value =  month + "-" + ((newDate.getDate()< 10) ? "0"+newDate.getDate() :newDate.getDate()) + "-" + newDate.getFullYear();
			deleteBillFunc();
		}	
		function onCancelFunc() {
			$("doe").value = $F("paramDoe");
			$("noOfDays").value = $F("paramNoOfDays");
			objUW.hidObjGIPIS002.deleteBillSw = "N";
			objUW.hidObjGIPIS002.forSaving = false;
		}
		
		var compSwAddtl = $F("compSw");
		var addtl = 0;
		if ("Y" == compSwAddtl) {
			addtl = -1;
		} else if ("M" == compSwAddtl) {
			addtl = +1;
		}
		var newDate = Date.parse($F("doi"));
		var num = $("noOfDays").value;
		num = num*1;
		newDate.add(num+addtl).days();
		var month = newDate.getMonth()+1 < 10 ? "0" + (newDate.getMonth()+1) : newDate.getMonth()+1;
		$("doe").value =  month + "-" + ((newDate.getDate()< 10) ? "0"+newDate.getDate() :newDate.getDate()) + "-" + newDate.getFullYear();
	});

	$("issuePlace").observe("change", function() {
		if (objUW.hidObjGIPIS002.validatedIssuePlace != "Y") {
			if ($("issuePlace").value != $("paramIssuePlace").value) {
				if (objUW.hidObjGIPIS002.gipiWinvTaxExist == "1") {
					showConfirmBox("Message", "Some taxes are dependent to place of issuance... changing/removing place of issuance will automatically recreate invoice. Do you want to continue?",  
							"Yes", "No", onOkFunc, onCancelFunc);
				}
			}
		}
		function onOkFunc() {
			objUW.hidObjGIPIS002.validatedIssuePlace = "Y";
		}	
		function onCancelFunc() {
			$("issuePlace").value = $("paramIssuePlace").value;
			objUW.hidObjGIPIS002.forSaving = false;
		}	
	});

	$("prorateFlag").observe("change", function() {
		var tempProrateFlag = $("prorateFlag").options[($("paramProrateFlag").value - 1)].text;
		if (objUW.hidObjGIPIS002.deleteBillSw == "N") {
			if ((objUW.hidObjGIPIS002.gipiWPolbasExist == "1") && (objUW.hidObjGIPIS002.gipiWItmperlExist == "1")){
				if($("prorateFlag").value != $("paramProrateFlag").value){
					showConfirmBox("Message", "You have changed your policy term from "+tempProrateFlag+" to "+$("prorateFlag").options[$("prorateFlag").selectedIndex].text+". Will now do the necessary changes.",  
							"Ok", "Cancel", onOkFunc, onCancelFunc);
				}	
			}
		}
		function onOkFunc() {
			deleteBillFunc();
		}	
		function onCancelFunc() {
			objUW.hidObjGIPIS002.deleteBillSw = "N";
			$("prorateFlag").value = $("paramProrateFlag").value;
			$("prorateFlag").focus();
			showRelatedSpan();
			objUW.hidObjGIPIS002.forSaving = false;
		}		
	});

	$("referencePolicyNo").observe("blur", function(){
		try{
			if ($("referencePolicyNo").value != ""){
				$("referencePolicyNo").value = $("referencePolicyNo").value.toUpperCase();
				new Ajax.Request(contextPath+'/GIPIPackParInformationController?action=validatePackRefPolNo',{
					method: "POST",
					parameters: {
						packParId: objUWGlobal.packParId,
						refPolNo: $("referencePolicyNo").value
					},
					asynchronous: true,
					onCreate: function(){
						$("basicInformationFormButton").disable();
					},
					onComplete: function(response){
						if(checkErrorOnResponse(response)){
							$("basicInformationFormButton").enable();
							var text = response.responseText;
							var arr = text.split(resultMessageDelimiter);
							function show2(){
								if (arr[1] != ""){
									showMessageBox(arr[1], imgMessage.INFO);
								}
							}	
							if (arr[0] != ""){
								showWaitingMessageBox(arr[0], imgMessage.INFO, show2);
							}else{
								show2();
							}
						}else{
							showMessageBox(response.responseText, imgMessage.ERROR);
						}
					}
				});
			}
		}catch(e){
			showErrorMessage("validatePackReferencePolicyNo", e);
		}
	});		

	function validateBeforeSavePackBasicInfo(){
		try{
			var result = true;
			var today = new Date();
			var eff = makeDate($F("issueDate"));
			var incept = makeDate($F("doi"));
			var exp = makeDate($F("doe"));	
			
			if ($F("parNo")==""){
				result = false;
				customShowMessageBox("PAR No. is required.", imgMessage.ERROR, "parNo");
				return false;
			}
			if ($F('sublineCd')==''){
				result = false;
				customShowMessageBox("Subline is required.", imgMessage.ERROR, "sublineCd");
			}
			if ($F('policyStatus')==''){
				result = false;
				customShowMessageBox("Policy Status is required.", imgMessage.ERROR, "policyStatus");
				return false;	
			}
			if ($F("assuredName")==""){
				result = false;
				customShowMessageBox("Assured Name is required.", imgMessage.ERROR, "assuredName");	
				return false;
			}
			if ($F("doi")=="") {
				result = false;
				customShowMessageBox("Inception date is required.", imgMessage.ERROR, "doi");
				return false;
			}
			if ($F("doe")=="") {
				result = false;
				customShowMessageBox("Expiry date is required.", imgMessage.ERROR, "doe");
				return false;
			}
			if ($F("address1")=="") {
				result = false;
				customShowMessageBox("Address 1 is required.", imgMessage.ERROR, "address1");
				return false;
			}
			/*if($F("premWarrTag") == 'Y') {
				if ($F("premWarrDays") == '') {
					result = false;
					customShowMessageBox("Premium warranty days is required.", imgMessage.ERROR, "premWarrDays");
					return false;
				}
				if (parseInt($F("premWarrDays")) < 1 || parseInt($F("premWarrDays")) > 999){
					$("premWarrDays").clear();
					result = false;
					customShowMessageBox("Entered premium warranty days is invalid. Valid value is from 1 to 999.", imgMessage.ERROR, "premWarrDays");
					return false;
				}			
			}*/ // remove premWarrDays as required field for it is not existing on Package PAR Basic Info module - nica 09.02.2011
			
			if (($F("policyStatus") == "2") || ($F("policyStatus") == "3")){
				if (objUW.hidObjGIPIS002.gipiWPolnrepExist == "0") {
					result = false; 			
					showMessageBox("This type of policy requires an entry of a renewal  or a replacement policy.", imgMessage.ERROR);
					return false;
						
				} else if (objUW.hidObjGIPIS002.gipiWPolnrepExist == "1") { //added by d.alcantara, 09142012
					var incept = makeDate($F("doi"));
					$$("div[name='rowPolnrep']").each(function (row) {			
						//if(incept < new Date(row.down("input", 8).value)) { //condition replaced by: Nica 03.08.2013 to consider only renewing policy
						  if(($F("policyStatus") == "2") && incept < new Date(row.down("input", 8).value)) {	
							result = false;
							showMessageBox("Incept Date is within the duration of the policy to be renewed. \n"+
									"Either change the policy inception or change the policy to be renewed.", imgMessage.ERROR);
							return false;
						}
					});
				}
				
				
			}
			if ($F("prorateFlag")=="1" && parseInt($F("noOfDays")) < 0) {
				result = false;
				customShowMessageBox("Entered pro-rate number of days is invalid. Valid value is from 0 to 99999.", imgMessage.ERROR, "noOfDays");
				$("noOfDays").value = $("paramNoOfDays").value;
				return false; 
			}
			if ($F("prorateFlag")=="1" && $F("noOfDays") == "") {	
				result = false;
				customShowMessageBox("Pro-rate number of days is required.", imgMessage.ERROR, "noOfDays");
				return false;				
			}
			if ($F("prorateFlag")=="3"){ 
				if ($F("shortRatePercent")==""){
					result = false;
					customShowMessageBox("Short Rate percent is required.", imgMessage.ERROR, "shortRatePercent");
					return false;
				}
				if (parseFloat($F("shortRatePercent")) < 0.000000001 || parseFloat($F('shortRatePercent')) >  100.000000000 || isNaN(parseFloat($F('shortRatePercent')))) {
					result = false;
					customShowMessageBox("Entered short rate percent is invalid. Valid value is from 0.000000001 to 100.000000000.", imgMessage.ERROR, "shortRatePercent");
					return false;
				}
			}
			if ($F("provisionalPremium") == 'Y'){
				if ($F("provPremRatePercent") == ""){
					result = false;
					customShowMessageBox("Provisional Premium percent is required.", imgMessage.ERROR, "provPremRatePercent");
					return false;
				}
				if (parseFloat($F("provPremRatePercent")) < 0 || parseFloat($F('provPremRatePercent')) >  100.000000000 || isNaN(parseFloat($F('provPremRatePercent')))) {
					result = false;
					customShowMessageBox("Entered provisional premium percent is invalid. Valid value is from 0.000000000 to 100.000000000.", imgMessage.ERROR, "provPremRatePercent");
					return false;
				}
			}
			if ($F("issueDate") == "") {
				result = false;
				customShowMessageBox("Issue date is required.", imgMessage.ERROR, "issueDate");
				return false;
			}
			if ($F("bookingMonth") == "") {
				result = false; 
				customShowMessageBox("There is no value for booking date. Please enter the date.", imgMessage.INFO, "bookingMonth");
				return false;
			}
			if (($("generalInformation").value.length*1) > 34000)	{
				result = false;
				customShowMessageBox("You have exceeded the maximum number of allowed characters(34000) for General Information.", imgMessage.ERROR, "generalInformation");
				return false;
			}
			if (($("initialInformation").value.length*1) > 34000)	{
				result = false;
				customShowMessageBox("You have exceeded the maximum number of allowed characters(34000) for Initial Information.", imgMessage.ERROR, "initialInformation");
				return false;
			}
			if ($F("manualRenewNo") == ""){
				result = false;
				customShowMessageBox("Manual Renew No. is required.", imgMessage.ERROR, "manualRenewNo");
				return false;					
			}
			if ($F("creditingBranch") == "") {
				if (objUW.hidObjGIPIS002.reqCredBranch == "Y"){
					if (objUW.hidObjGIPIS002.defCredBranch == "ISS_CD"){
						result = false;
						customShowMessageBox("Crediting Branch is required.", imgMessage.ERROR, "creditingBranch");
						return false;
					}
				}
			}
			if ($F("referencePolicyNo") == "") {
				if (objUW.hidObjGIPIS002.reqRefPolNo == "Y"){
					("gab");
					result = false;
					customShowMessageBox("Reference Policy No. is required.", imgMessage.ERROR, "referencePolicyNo");
					return false;
				}
			}
			if ($F("bankRefNo") == "") { //added by gab 11.15.2016 SR 3147,3027,2645,2681,3148,3206,3264,3010
				if (objUW.hidObjGIPIS002.reqRefNo == "Y") {
					result = false;
					customShowMessageBox("Bank Reference Number is required.",imgMessage.ERROR, "nbtAcctIssCd");
					return false;
				}
			}
			/*if ($F("takeupTermType") == "") {
				result = false;
				customShowMessageBox("Take-up term is required. ", imgMessage.ERROR, "takeupTermType");
				$("takeupTermType").value = $("paramTakeupTermType").value;
				return false;
			}*/
			
			/*if (result){
				if (objUW.hidObjGIPIS002.lcMN == $F("lineCd") || objUW.hidObjGIPIS002.lcMN2 == "MN"){
					if (objUW.hidObjGIPIS002.reqSurveySettAgent == "Y"){
						if ($F("surveyAgentCd") == ""){
							result = false;
							customShowMessageBox("Survey Agent in marine details is required.", imgMessage.ERROR, "surveyAgentCd");
							return false;
						}
						if($F("settlingAgentCd") == ""){
							result = false;
							customShowMessageBox("Settling Agent in marine details is required.", imgMessage.ERROR, "settlingAgentCd");
							return false;
						}		
					}	
				}
			}*/
			
			if (objUW.hidObjGIPIS002.ora2010Sw == "Y"){
				if ($F("companyCd") != "" && $F("employeeCd") == ""){
					if (result){
						result = false;
						customShowMessageBox("Choose an employee first before proceeding.", imgMessage.INFO, "employeeCd");
						return false;
					}	
				}else if ($F("companyCd") == "" && $F("employeeCd") != ""){
					if (result){
						result = false;
						customShowMessageBox("Company is required.", imgMessage.ERROR, "companyCd");
						return false;
					}	
				}
				if ($("bancaTag").checked){
					if (result){
						if ($F("selBancTypeCd") == "" || $F("selAreaCd") == "" || $F("selBranchCd") == "" || objUW.hidObjGIPIS002.managerCd == ""){
							result = false;
							customShowMessageBox("Pls. be adviced that information for bank assurance should be complete.", imgMessage.ERROR, "selBancTypeCd");
							return false;
						}	
					}
				}
				if ($("packPLanTag").checked){
					if ($F("selPlanCd") == ""){
						result = false;
						customShowMessageBox("Please complete the Package Plan information.", imgMessage.INFO, "selPlanCd");
						return false;
					}	
				}
				/*if ($F("swBankRefNo") == "N"){
					if ($F("bankRefNo") != ""){	
						if (!validateBankRefNo()){
							result = false;
							return false;
						}else{
							result = true;
						}	
					}else{
						if ($F("nbtAcctIssCd") != "01" || $F("nbtBranchCd") != "0000"){
							$("bankRefNo").value = formatNumberDigits($F("nbtAcctIssCd"),2)+"-"+formatNumberDigits($F("nbtBranchCd"),4)+"-"+formatNumberDigits($F("dspRefNo"),7)+"-"+formatNumberDigits($F("dspModNo"),2);
							if (!validateBankRefNo()){
								result = false;
								return false;
							}else{
								result = true;
							}
						}
					}	
				}*/
			}
			
			if (result){
				if (exp<incept) {
					result = false;
					customShowMessageBox("Expiry date is invalid. Expiry date must be later than Inception date.", imgMessage.ERROR, "doe");
					return false;
				} 
			}	
			return result;
		} catch (e) {
			showErrorMessage("validateBeforeSavePackBasicInfo", e);
		}
	}
	
	function savePackBasicInfoMain(){
		if ($F("referencePolicyNo") == "") {
			if (objUW.hidObjGIPIS002.reqRefPolNo == "Y"){
				customShowMessageBox("Reference Policy No. is required.", imgMessage.ERROR, "referencePolicyNo");
				return false;
			}
		}
		if ($F("bankRefNo") == "") { //added by gab 11.15.2016 SR 3147,3027,2645,2681,3148,3206,3264,3010
			if (objUW.hidObjGIPIS002.reqRefNo == "Y") {
				customShowMessageBox("Bank Reference Number is required.",imgMessage.ERROR, "nbtAcctIssCd");
				return false;
			}
		}
		if (objUW.hidObjGIPIS002.gipiWInvoiceExist == "1" && $F("doi") != $F("paramDoi")){
			if (objUW.hidObjGIPIS002.deleteBillSw == "N"){
				showConfirmBox("Message", "You have changed the inception date of the policy from "+$F("paramDoi")+" to "+$F("doi")+" . This will delete the existing records in BILL PREMIUM / INVOICE COMMISSION. Do you want to continue ?",  
						"Ok", "Cancel",
				function(){
					objUW.hidObjGIPIS002.gipiWInvoiceExist = "0";
					if ($F("paramProrateFlag") != $F("prorateFlag")){
						objUW.hidObjGIPIS002.precommitDelTab = "Y";
					}
					savePackBasicInfo();
				}, "");
					
			}else{
				savePackBasicInfo();
			}
		}else{
			savePackBasicInfo();
		}
	}

	function savePackBasicInfo(){
		try{
			var objParameters = new Object();
			objParameters.setMortgagees = prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objMortgagees));
			objParameters.delMortgagees = prepareJsonAsParameter(getDelFilteredObjs(objMortgagees));
			$("basicInformationForm").enable();
			new Ajax.Request(contextPath+'/GIPIPackParInformationController?action=savePackPARBasicInfo&parameters=' + encodeURIComponent(JSON.stringify(objParameters)),{
				method: "POST",
				postBody: Form.serialize("basicInformationForm")+prepareParametersGIPIS002A(),
				asynchronous : false,
				evalScripts: true,
				onCreate: function(){
					$("basicInformationForm").disable();
					disableButton("btnCancel");
					disableButton("btnSave");
					showNotice("Saving, please wait...");
				},
				onComplete: function(response){
					var result = JSON.parse(response.responseText);
					enableButton("btnCancel");
					enableButton("btnSave");
					hideNotice("");
					if(checkErrorOnResponse(response)){
						if (result.message == "SUCCESS"){
							changeTag = 0;
							updatePackParParameters();
							postSavePackBasicInfo();
							updatePackBasicInfoParameters();
							showMessageBox(objCommonMessage.SUCCESS,imgMessage.SUCCESS);
						} else {
							showMessageBox(changeSingleAndDoubleQuotes(result.message),imgMessage.ERROR);
							postSavePackBasicInfo();
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("savePackBasicInfo", e);
		}
	}

	function postSavePackBasicInfo(){
		try{
			$("basicInformationForm").enable();
			$("basicInformationFormButton").enable();
			$("packagePolicy").disable();
			$("quotationPrinted").disable();
			$("covernotePrinted").disable();
			$("fleetTag").disable();
			
			if ($F("premWarrTag") != 'Y') {
				$("premWarrDays").disable();
			}
			if ($("defaultDoe").value != $("doe").value){
				$("prorateFlag").enable();
			} else {
				$("prorateFlag").disable();
			}
			if (objUW.hidObjGIPIS002.issCdRi == $("issCd").value){
				$("coIns").disable();
			}
			
			if(objUW.hidObjGIPIS002.typeCdStatus == "N"){
				$("typeOfPolicy").disable();
			}
			
			if(nvl(objUW.hidObjGIPIS002.updateBooking, "Y") == "N"){
				$("bookingMonth").disable(); // added bY: Nica 05.10.2012 - Per Ms VJ, booking month LOV should be disabled if UPDATE_BOOKING is equal to N.
			}
			
			if (objUW.hidObjGIPIS002.ora2010Sw == "Y"){
				/*if ($F("bankRefNo") != ""){
					generateBankRefNo($F("bankRefNo"));
					$("swBankRefNo").value = "Y";
				}*/
				if (!$("bancaTag").checked){
					$("selBancTypeCd").clear();
					$("selAreaCd").clear();
					$("selBranchCd").clear();
					objUW.hidObjGIPIS002.managerCd = "";
					$("dspManagerCd").clear();
					$("dspManagerName").value = "No managers for the given values.";
				}	
				checkPackPlanTag();
			}	
			//checkCoInsurance();
			initializePackPARBasicMenu();
		} catch (e) {
			showErrorMessage("postSavePackBasicInfo", e);
		}
	}

	function checkSublineIfChangeBeforeSave(){
		if (objUW.hidObjGIPIS002.gipiWItemExist == "Y" && objUW.hidObjGIPIS002.gipiWPolbasExist == "1" && $F("sublineCd") != objUW.hidObjGIPIS002.paramSublineCd){
			showConfirmBox("Message", "Updating subline from "+objUW.hidObjGIPIS002.paramSublineCdDesc+" to "+getListTextValue("sublineCd")+". Will delete records with to previous subline. Continue?",  
					"Ok", "Cancel", 
			function(){
				objUW.hidObjGIPIS002.deleteAllTables = "Y";
				savePackBasicInfoMain();
			}, "");
		}else{
			savePackBasicInfoMain();
		}
	}

	function prepareParametersGIPIS002A(){
		try{
			var params = "&deleteAllTables="+objUW.hidObjGIPIS002.deleteAllTables;
			//params = params+"&mnSublineMop="+objUW.hidObjGIPIS002.mnSublineMop;
			//params = params+"&lcMN="+objUW.hidObjGIPIS002.lcMN;
			//params = params+"&lcMN2="+objUW.hidObjGIPIS002.lcMN2;
			params = params+"&ora2010Sw="+objUW.hidObjGIPIS002.ora2010Sw;
			params = params+"&managerCd="+objUW.hidObjGIPIS002.managerCd;
			/*if ($F("doi") != nvl($F("paramDoi"),$F("doi")) || $F("doe") != nvl($F("paramDoe"),$F("doe"))){
				params = params+"&dateSw=Y";
				params = params+"&deleteSw=Y";
			}else{
				params = params+"&dateSw=N";
				params = params+"&deleteSw="+objUW.hidObjGIPIS002.deleteSw;
			}*/
			params = params+"&deleteSwForAssdNo="+objUW.hidObjGIPIS002.deleteSwForAssdNo;
			params = params+"&invoiceSwB540="+objUW.hidObjGIPIS002.invoiceSwB540;	
			params = params+"&designationB540="+objUW.hidObjGIPIS002.designationB540;	
			params = params+"&issCdB540="+objUW.hidObjGIPIS002.issCdB540; 
			//params = params+"&isOpenPolicy="+objUW.hidObjGIPIS002.isOpenPolicy;
			params = params+"&deleteBillSw="+objUW.hidObjGIPIS002.deleteBillSw;
			params = params+"&deleteWPolnrep="+objUW.hidObjGIPIS002.deleteWPolnrep;
			params = params+"&deleteCoIns="+objUW.hidObjGIPIS002.deleteCoIns;
			params = params+"&validatedIssuePlace="+objUW.hidObjGIPIS002.validatedIssuePlace;
			//params = params+"&validatedBookingDate="+objUW.hidObjGIPIS002.validatedBookingDate;
			params = params+"&issueYy="+objUW.hidObjGIPIS002.issueYy;
			params = params+"&geninInfoCd="+objUW.hidObjGIPIS002.geninInfoCd;
			params = params+"&precommitDelTab="+objUW.hidObjGIPIS002.precommitDelTab;
			return params;	
		} catch (e) {
			showErrorMessage("prepareParametersGIPIS002A", e);
		}
	}		

	function showRelatedSpan(){			
		if ($F("prorateFlag") == "1")	{
			$("shortRateSelected").hide();
			$("shortRatePercent").hide();
			$("prorateSelected").show();
			$("noOfDays").show();
			$("noOfDays").value = computeNoOfDays($F("doi"),$F("doe"),$F("compSw"));
		} else if ($F("prorateFlag") == "3") {	
			$("prorateSelected").hide();
			$("shortRateSelected").show();
			$("shortRatePercent").show();
			$("noOfDays").hide();
			$("noOfDays").value = "";					
		} else {		
			$("shortRateSelected").hide();
			$("shortRatePercent").hide();
			$("prorateSelected").hide();
			$("noOfDays").hide();
			$("noOfDays").value = "";
		}

		if($("bookingDateExist").value == 1){
			$("opt2").hide();
		} else if ($("opt2").value == "") {
			$("opt2").hide();
		}		
	}	

	function deleteBillFunc(){
		try{
			objUW.hidObjGIPIS002.deleteBillSw = "Y";
			disableMenu("post");
			disableMenu("coInsurance");
			disableMenu("bill");
			disableMenu("distribution");
			/*if (objUW.hidObjGIPIS002.gipiWItemExist == "Y"){
				enableMenu("itemInfo");
			}else{ 
				disableMenu("itemInfo");
			}*/
		} catch (e) {
			showErrorMessage("deleteBillFunc", e);
		}
	}

	//function to update all parameters needed in GIPIS002A
	function updatePackBasicInfoParameters() {
		try{
			objUW.hidObjGIPIS002.gipiWPolbasExist = "1";
			if (objUW.hidObjGIPIS002.deleteBillSw == "Y"){
				objUW.hidObjGIPIS002.gipiWItmperlExist 	= "0";
				objUW.hidObjGIPIS002.gipiWinvTaxExist 	= "0";
			}	
			objUW.hidObjGIPIS002.deleteBillSw = "N";
			objUW.hidObjGIPIS002.deleteSw = "N";
			objUW.hidObjGIPIS002.deleteWPolnrep = "N";
			//objUW.hidObjGIPIS002.validatedIssuePlace = "N";
			//objUW.hidObjGIPIS002.validatedBookingDate = "N";
			$("paramSubline").value = $("sublineCd").value;
			$("paramPolicyStatus").value = $("policyStatus").value;
			$("paramRenewNo").value = $("renewNo").value;
			$("paramAssuredNo").value = $("assuredNo").value;
			$("paramAssuredName").value = $("assuredName").value;
			$("paramIssuePlace").value = $("issuePlace").value;
			$("paramProvPremRatePercent").value = $("provPremRatePercent").value;
			$("paramDoi").value = $("doi").value;
			$("paramProrateFlag").value = $("prorateFlag").value;
			$("paramNoOfDays").value = $("noOfDays").value;
			$("paramShortRatePercent").value = $("shortRatePercent").value;
			$("paramBookingYear").value = $("bookingYear").value;
			$("paramBookingMth").value = $("bookingMth").value;
			$("paramDoe").value = $("doe").value;
			$("paramCoInsurance").value = $("coIns").value;
			$("paramTakeupTermType").value = $("takeupTermType").value;
			objUW.hidObjGIPIS002.deleteCoIns 		= "";	
			$("updateIssueDate").value = "N";
			objUW.hidObjGIPIS002.paramSublineCdDesc = getListTextValue("sublineCd");
			objUW.hidObjGIPIS002.deleteAllTables	= "N";
			objUW.hidObjGIPIS002.deleteSwForAssdNo	= "N";
			objUW.hidObjGIPIS002.forSaving			= false;
		} catch (e) {
			showErrorMessage("updatePackBasicInfoParameters", e);
		}
	}

	function clearRenewalReplacementGIPIS002A(){
		try{
			if (objUW.hidObjGIPIS002.gipiWPolnrepExist == "1" && $("policyRenewalDiv").innerHTML != ""){
				objUW.hidObjGIPIS002.deleteWPolnrep 	= "Y";
				objUW.hidObjGIPIS002.gipiWPolnrepExist 	= "0";
				$("wpolnrepIssCd").value 	= "";
				$("wpolnrepIssueYy").value 	= "";
				$("wpolnrepPolSeqNo").value = "";
				$("wpolnrepRenewNo").value 	= "";
				$("samePolicyNo").checked 	= false;
				$("samePolicyNo").disabled 	= false;
				$("btnAddRenewal").value = "Add";
				$$("div[name='rowPolnrep']").each(function (row) {
					Effect.Fade(row, {
						duration: .5,
						afterFinish: function ()	{
							row.remove();
							checkTableIfEmpty("rowPolnrep", "renewalTable");
							checkIfToResizeTable("policyNoListing", "rowPolnrep");
						} 
					});
				});		
			}
		} catch (e) {
			showErrorMessage("clearRenewalReplacementGIPIS002A", e);
		}
	}

	function checkPackPlanTag(){
		try{
			if (!$("packPLanTag").checked){
				removeAllOptions($("selPlanCd"));
				$("selPlanCd").disable();
				var opt = document.createElement("option");
				opt.value = "";
				opt.text = "";
				opt.setAttribute("sublineCd", "");
				$("selPlanCd").options.add(opt);
				$("selPlanCd").removeClassName("required");
			}else{
				$("selPlanCd").addClassName("required");
				$("selPlanCd").enable();
			}	
		} catch (e) {
			showErrorMessage("checkPackPlanTag", e);
		}
	}
	
	observeReloadForm("reloadForm", showPackParBasicInfo);
	observeCancelForm("btnCancel", savePackBasicInfoMain, showPackParListing);
	
	$("btnSave").observe("click", function (){
		if(changeTag == 0){		
			showMessageBox(objCommonMessage.NO_CHANGES ,imgMessage.INFO); 
			objUW.hidObjGIPIS002.forSaving = false; 
			return;
		}else{
			if(validateBeforeSavePackBasicInfo()){
				checkSublineIfChangeBeforeSave();
			}
		}
	});

	if (objUW.hidObjGIPIS002.ora2010Sw == "Y"){
		checkPackPlanTag();
		$("packPLanTag").observe("change", function() {
			checkPackPlanTag();
		});
	}

	initializeChangeTagBehavior(savePackBasicInfoMain);
	setDocumentTitle("Basic Information");
	window.scrollTo(0,0); 	
	hideNotice("");
	changeTag = 0;
}catch(e){
	showErrorMessage("packBasicMain2", e);
}
</script>