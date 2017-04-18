<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c"  uri="/WEB-INF/tld/c.tld" %>

<%
	request.setAttribute("contextPath", request.getContextPath());
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>
<div id="editPolicyNoMainDiv" style="float: left; width: 100%;">
	<div style="width: 100%; margin-left: 2%;">
		<form id="policyNumberForm" name="policyNumberForm">
			<input type="hidden" name="polParId"			id="polParId" 				value="${parId}">
			<input type="hidden" name="polNoForEndtStopper" id="polNoForEndtStopper" 	value="N" />
			<input type="hidden" name="isPack"				id="isPack" 				value="${isPack}<c:if test="${empty isPack }">N</c:if>">
			<label id="messagePolicyNo" style="padding-bottom: 10px; margin-bottom: 10px; width: 100%; text-align: center; color: red;"></label>
			<br /><br />
			<div style="float: left;">
				<label style="width: 120px; text-align: right; height: 20px; padding-top: 4px; margin; margin-right: 3px;">Policy No: </label>		
				<input type="text" id="polLineCd" 		name="polLineCd" 	maxlength="2" style="width: 30px;" disabled="disabled" readonly="readonly" value="${lineCdPol}" class="text" />
			  	<input type="text" id="polSublineCd" 	name="polSublineCd" maxlength="7" style="width: 50px;" value="${sublineCdPol}" class="text" />  				
				<input type="text" id="polIssCd" 		name="polIssCd" 	maxlength="2" style="width: 30px;" disabled="disabled" readonly="readonly" value="${issCd}" class="text" />
				<input type="text" id="polIssueYy" 		name="polIssueYy" 	maxlength="2" style="width: 30px; text-align: right;" value="<fmt:formatNumber pattern="00" value="${issueYy}"/>" class="integerNoNegativeUnformattedNoComma" errorMsg="Issue Year must be a number from 0 to 99."/>
				<input type="text" id="polPolSeqNo" 	name="polPolSeqNo" 	maxlength="7" style="width: 50px; text-align: right;" value="<fmt:formatNumber pattern="0000000" value="${polSeqNo}"/>" class="integerNoNegativeUnformattedNoComma" errorMsg="Policy Sequence must be a number from 0 to 9999999."/>
				<input type="text" id="polRenewNo" 		name="polRenewNo" 	maxlength="2" style="width: 30px; text-align: right;" value="<fmt:formatNumber pattern="00" value="${renewNo}"/>" class="integerNoNegativeUnformattedNoComma" errorMsg="Renew No must be a number from 0 to 99."/>		
			</div>		
		 	<br /> 	
	  	</form>  
	  	<div style="float: left; margin: 15px; width: 100%" align="center">
			<input type="button" class="button" style="width:70px;" id="btnOkEdit" name="btnOkEdit" value="Ok" /> 
		 	<input type="button" class="button" style="width:70px;" id="btnExit" name="btnExit" value="Cancel" />
	  	</div>
	</div>	
</div>
<script type="text/javascript">
	$("btnExit").stopObserving("click");
	$("btnExit").observe("click", function() {
		hideOverlay();
		$("contentHolder").update(""); 
	});

	$("polIssueYy").observe("blur",function(){
		if(!isNaN(Number($F("polIssueYy")))){
			$("polIssueYy").value = formatNumberDigits($F("polIssueYy"),2);
		}	
	});
	$("polPolSeqNo").observe("blur",function(){
		if(!isNaN(Number($F("polPolSeqNo")))){
			$("polPolSeqNo").value = formatNumberDigits($F("polPolSeqNo"),7);
		}
	});
	$("polRenewNo").observe("blur",function(){
		if(!isNaN(Number($F("polRenewNo")))){
			$("polRenewNo").value = formatNumberDigits($F("polRenewNo"),2);
		}
	});
	
	function getEndtRiskTag(){
		try{
			var parId = $F("polParId");
			var lineCd = $F("polLineCd");
			var sublineCd = $F("polSublineCd");
			var issCd = $F("polIssCd");
			var issueYy = $F("polIssueYy");
			var polSeqNo = $F("polPolSeqNo");
			var renewNo = $F("polRenewNo");
			var controller = "GIPIParInformationController";
			var action = "getEndtRiskTag";
			
			new Ajax.Request(contextPath + "/"+controller+"?action="+action, {
				method: "GET",
				parameters:{
					parId: 		parId,
					lineCd: 	lineCd,
					sublineCd: 	sublineCd,
					issCd: 		issCd,
					issueYy: 	issueYy,
					polSeqNo: 	polSeqNo,
					renewNo: 	renewNo
				},
				asynchronous: false,
				evalScripts: true,
				//onCreate : showNotice("Validating policy no., please wait..."),
				onComplete: function(response){
					var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
					if (checkErrorOnResponse(response)){
						$("riskTag").value = nvl(res.riskTag,"");
					}		
				}
			});
		}catch (e) {
			showErrorMessage("getEndtRiskTag", e);
		}
	}	

	function searchForEditedPackPolicy(parId, lineCd, sublineCd, issCd, issueYy, polSeqNo, renewNo, newPolicy){
		try {
			$("varPolChangedSw").value 	= "Y";
			$("b240ParStatus").value 	= "2";
	
			var controller = "GIPIPackParInformationController";
			var action = "searchForEditedPackPolicy";
			new Ajax.Request(contextPath + "/"+controller+"?action="+action, {
				method : "GET",
				parameters : {
					packParId : parId,
					lineCd : lineCd,
					sublineCd : sublineCd,
					issCd : issCd,
					issueYy : issueYy,
					polSeqNo : polSeqNo,
					renewNo : renewNo,
					effDate: $("b540EffDate").value,
					acctOfCd: $("acctOfCd").value,
					bondSeqNo : showBondSeqNo == "N" ? $F("txtBondSeqNo") : null 
				},
				asynchronous : false,
				evalScripts : true,
				//onCreate : showNotice("Validating policy no., please wait..."),
				onComplete : function(response){
					try {
						hideNotice();
						var res = JSON.parse(response.responseText);
						if (checkErrorOnResponse(response)) {
							if (nvl(res.msgAlert,null) == null){
									$("inAccountOf").value = nvl(res.gipiPackWPolbas[0].acctOfName, "");
									$("acctOfCd").value = res.gipiPackWPolbas[0].acctOfCd;
									$("labelTag").checked = (res.labelTag == "Y" ? true :false);
									$("b540LabelTag").value = res.labelTag;
									$("parFirstEndtSw").value = res.parFirstEndtSw;
									$("b540AnnTsiAmt").value = res.gipiPackWPolbas[0].annTsiAmt;
									$("b540AnnPremAmt").value = res.gipiPackWPolbas[0].annPremAmt;
									$("assuredNo").value = res.gipiPackParlist[0].assdNo;
									$("assuredName").value = res.gipiPackParlist[0].assdName;
									$("address1").value = res.gipiPackWPolbas[0].address1;
									$("address2").value = res.gipiPackWPolbas[0].address2;
									$("address3").value = res.gipiPackWPolbas[0].address3;
									$("b240Address1").value = res.gipiPackWPolbas[0].address1;
									$("b240Address2").value = res.gipiPackWPolbas[0].address2;
									$("b240Address3").value = res.gipiPackWPolbas[0].address3;
									$("typeOfPolicy").value = res.gipiPackWPolbas[0].typeCd;
		
									$("b540LineCd").value = res.lineCd;
									$("b540SublineCd").value = res.sublineCd;
									$("sublineCd").value = res.sublineCd;
									$("b540IssCd").value = res.issCd;
									$("b540IssueYY").value = res.issueYy;
									$("b540PolSeqNo").value = res.polSeqNo;
									$("b540RenewNo").value = res.renewNo;
		
									$("b540EndtIssCd").value = res.issCd;
									$("b540EndtYy").value = res.issueYy;
		
									$("b540InceptDate").value = nvl(res.inceptDate,"");
									$("doi").value = nvl(res.inceptDate.substr(0,10),"");
									$("inceptTag").checked = (res.gipiPackWPolbas[0].inceptTag == "Y" ? true :false);
									$("b540InceptTag").value = nvl(res.gipiPackWPolbas[0].inceptTag,"N");
		
									$("b540ExpiryDate").value = nvl(res.expiryDate,"");
									$("doe").value = nvl(res.expiryDate.substr(0,10),"");
									$("expiryTag").checked = (res.gipiPackWPolbas[0].expiryTag == "Y" ? true :false);
									$("b540ExpiryTag").value = nvl(res.gipiPackWPolbas[0].expiryTag,"N");
		
									$("endtExpDateTag").checked = (res.gipiPackWPolbas[0].endtExpDateTag == "Y" ? true :false);
									$("b540EffDate").value = nvl(res.gipiPackWPolbas[0].effDate,"");
									$("endtEffDate").value = nvl(res.gipiPackWPolbas[0].effDate,"");
									$("endtExpDate").value = nvl(res.endtExpiryDate.substr(0,10),"");
									$("b540EndtExpiryDate").value = nvl(res.endtExpiryDate,"");
									
									$("typeOfPolicy").value = res.gipiPackWPolbas[0].typeCd;
									$("b540SamePolNoSw").value = res.gipiPackWPolbas[0].samePolnoSw;
									
									$("b540ForeignAccSw").value = res.gipiPackWPolbas[0].foreignAccSw;
									$("b540CompSw").value = res.gipiPackWPolbas[0].compSw;
									$("compSw").value = res.gipiPackWPolbas[0].compSw;
									$("b540PremWarrTag").value = res.gipiPackWPolbas[0].premWarrTag;
									$("premWarrTag").checked = (res.gipiPackWPolbas[0].premWarrTag == "Y" ? true :false);
									$("assuredNo").value = res.gipiPackParlist[0].assdNo;
									$("b540OldAssdNo").value = res.gipiPackWPolbas[0].oldAssdNo;
									$("b540OldAddress1").value = res.gipiPackWPolbas[0].oldAddress1;
									$("b540OldAddress2").value = res.gipiPackWPolbas[0].oldAddress2;
									$("b540OldAddress3").value = res.gipiPackWPolbas[0].oldAddress3;
									$("b540RegPolicySw").value = res.gipiPackWPolbas[0].regPolicySw;
									$("regularPolicy").checked = (res.gipiPackWPolbas[0].regPolicySw == "Y" ? true :false);
									$("b540CoInsuranceSw").value = res.gipiPackWPolbas[0].coInsuranceSw;
									$("b540ManualRenewNo").value = res.gipiPackWPolbas[0].manualRenewNo;
									$("manualRenewNo").value = res.gipiPackWPolbas[0].manualRenewNo;
									$("b540CredBranch").value = res.gipiPackWPolbas[0].credBranch;
									$("creditingBranch").value = res.gipiPackWPolbas[0].credBranch;
									$("b540RefPolNo").value = res.gipiPackWPolbas[0].refPolNo;
									$("referencePolicyNo").value = res.gipiPackWPolbas[0].refPolNo;
									$("b540TakeupTerm").value = res.gipiPackWPolbas[0].takeupTerm;
									$("takeupTermType").value = res.gipiPackWPolbas[0].takeupTerm;
									$("bankRefNo").value = res.gipiPackWPolbas[0].bankRefNo;
									$("b540BookingYear").value = res.gipiPackWPolbas[0].bookingYear;
									$("b540BookingMth").value = res.gipiPackWPolbas[0].bookingMth;
									$("bookingYear").value = res.gipiPackWPolbas[0].bookingYear;
									$("bookingMth").value = res.gipiPackWPolbas[0].bookingMth;
									var ind = 0;
									for(var i = 1; i < $("bookingMonth").options.length; i++){
										if ($("bookingYear").value == $("bookingMonth").options[i].getAttribute("bookingYear") && 
												$("bookingMth").value == $("bookingMonth").options[i].getAttribute("bookingMth")){
											ind = i;
											$break;
										}
									}
									$("bookingMonth").selectedIndex = ind;
									$("b540ProvPremTag").value = res.gipiPackWPolbas[0].provPremTag;
									$("b540ProvPremPct").value = res.gipiPackWPolbas[0].provPremPct;
									$("b540ProrateFlag").value = res.gipiPackWPolbas[0].prorateFlag;
									$("prorateFlag").value = res.gipiPackWPolbas[0].prorateFlag;
									$("b540ShortRtPercent").value = nvl(res.nbtShortRtPercent,"");
									$("shortRatePercent").value = nvl(res.nbtShortRtPercent,"");
									//objUW.hidObjGIPIS031.gipiPackWEndtText.endtTax = res.parVEndt; //$("b360EndtTax").value = res.parVEndt;
									$("parEndtTaxSw").value = res.parVEndt;
									$("endtInformation").clear();
									$("generalInformation").clear();
									$("parConfirmSw").value = res.parConfirmSw;
									$("varExpChgSw").value = res.varExpChgSw;
									$("varOldDateEff").value = ""; //res.varVOldDateEff;
									$("parSysdateSw").value = res.parSysdateSw;
									$("b540PackPolFlag").value = res.gipiPackWPolbas[0].packPolFlag;
									$("b240ParStatus").value = "2";
									$("parStatus").value = "2";
									$("policyNo").value = newPolicy; 
							}else{
								showMessageBox(res.msgAlert, imgMessage.ERROR);
							}							
						}
					} catch (e){
						showErrorMessage("searchForEditedPackPolicy", e);
					}
				}
			});		
			hideOverlay();
		} catch(e){
			showErrorMessage("searchForEditedPackPolicy", e);
		}		
	}
	
	function searchForEditedPolicy(parId, lineCd, sublineCd, issCd, issueYy, polSeqNo, renewNo, newPolicy){
		try {
			$("varPolChangedSw").value 	= "Y";
			$("b240ParStatus").value 	= "2";
	
			var controller = "GIPIParInformationController";
			var action = "searchForEditedPolicy";
			new Ajax.Request(contextPath + "/"+controller+"?action="+action, {
				method : "GET",
				parameters : {
					parId : parId,
					lineCd : lineCd,
					sublineCd : sublineCd,
					issCd : issCd,
					issueYy : issueYy,
					polSeqNo : polSeqNo,
					renewNo : renewNo,
					effDate: $("b540EffDate").value,
					acctOfCd: $("acctOfCd").value,
					bondSeqNo : showBondSeqNo == "N" ? $F("txtBondSeqNo") : null 
				},
				asynchronous : false,
				evalScripts : true,
				//onCreate : showNotice("Validating policy no., please wait..."),
				onComplete : function(response){
					hideNotice();
					var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
					if (checkErrorOnResponse(response)) {
						if (nvl(res.msgAlert,null) == null){
							if (getLineCd() == "SU"){//$F("globalLineCd") == "SU"){	modified by Gzelle 12042014 SR3065
								//block for surety line...
								$("txtLineCd").value = res.lineCd;
								$("txtSublineCd").value = res.sublineCd;
								$("txtIssCd").value = res.issCd;
								$("txtIssueYy").value = res.issueYy;
								$("txtPolSeqNo").value = formatNumberDigits(res.polSeqNo, 6); 
								$("txtRenewNo").value = formatNumberDigits(res.renewNo, 2);
								
								$("txtLineCd2").value = res.lineCd;	//added by Gzelle 12042014 SR3065
								$("txtSublineCd2").value = res.sublineCd;	//added by Gzelle 12042014 SR3065
								$("txtEndtIssCd").value = res.issCd;
								$("txtEndtIssueYy").value = res.issueYy;
								$("txtBondSeqNo").value = res.bondSeqNo;
	
								$("acctOfCd").value = res.gipiWPolbas[0].acctOfCd;
								$("assuredNo").value = res.gipiParlist[0].assdNo;
								$("assuredName").value = res.drvAssdname;
								$("address1").value = res.gipiWPolbas[0].address1;	//add1 modified by Gzelle 12032014
								$("address2").value = res.gipiWPolbas[0].address2;	//add2 SR 3065
								$("address3").value = res.gipiWPolbas[0].address3;	//add3
								$("polType").value = res.gipiWPolbas[0].typeCd;
	
								$("doi").value = nvl(res.inceptDate.substr(0, 10), "");
								$("inceptTag").checked = (res.gipiWPolbas[0].inceptTag == "Y" ? true :false);
								$("bondExpiry").value = nvl(res.expiryDate.substr(0,10),"");
								$("expiryTag").checked = (res.gipiWPolbas[0].expiryTag == "Y" ? true :false);
								$("endtExpiryTag").checked = (res.gipiWPolbas[0].endtExpDateTag == "Y" ? true :false);
								$("doe").value = nvl(res.gipiWPolbas[0].effDate,"");
								$("eed").value = nvl(res.endtExpiryDate.substr(0,10),"");
	
								$("regPolSw").checked = (res.gipiWPolbas[0].regPolicySw == "Y" ? true : false);
								
								$("issDate").value = nvl(dateFormat(res.gipiWPolbas[0].issueDate, "mm-dd-yyyy"),"");
								$("refPolNo").value = res.gipiWPolbas[0].refPolNo;
								$("region").value = res.gipiWPolbas[0].regionCd;
								$("mortgagee").value = res.gipiWPolbas[0].mortgName;
								$("industry").value = res.gipiWPolbas[0].industryCd;
								$("creditedBranch").value = res.gipiWPolbas[0].credBranch;
								var ind = 0;
								for(var i = 1; i < $("bookingMonth").options.length; i++){
									if ($("bookingYear").value == $("bookingMonth").options[i].getAttribute("bookingYear") && 
											$("bookingMth").value == $("bookingMonth").options[i].getAttribute("bookingMth")){
										ind = i;
										$break;
									}
								}
								$("bookingMonth").selectedIndex = ind;
								$("takeupTermType").value = res.gipiWPolbas[0].takeupTerm;
								$("b240ParStatus").value = "2";
								//$("parStatus").value = "2";
								//$("policyNo").value = newPolicy;
								$("endtInformation").clear();
								$("generalInfo").clear();
							} else {
								$("inAccountOf").value = res.drvAcctOfCd;
								$("acctOfCd").value = res.gipiWPolbas[0].acctOfCd;
								$("labelTag").checked = (res.labelTag == "Y" ? true :false);
								$("b540LabelTag").value = res.labelTag;
								$("parFirstEndtSw").value = res.parFirstEndtSw;
								$("b540AnnTsiAmt").value = res.gipiWPolbas[0].annTsiAmt;
								$("b540AnnPremAmt").value = res.gipiWPolbas[0].annPremAmt;
								$("assuredNo").value = res.gipiParlist[0].assdNo;
								$("assuredName").value = res.drvAssdname;
								$("address1").value = res.gipiWPolbas[0].address1;
								$("address2").value = res.gipiWPolbas[0].address2;
								$("address3").value = res.gipiWPolbas[0].address3;
								$("b240Address1").value = res.gipiWPolbas[0].address1;
								$("b240Address2").value = res.gipiWPolbas[0].address2;
								$("b240Address3").value = res.gipiWPolbas[0].address3;
								$("typeOfPolicy").value = res.gipiWPolbas[0].typeCd;
	
								$("b540LineCd").value = res.lineCd;
								$("b540SublineCd").value = res.sublineCd;
								$("b540IssCd").value = res.issCd;
								$("b540IssueYY").value = res.issueYy;
								$("b540PolSeqNo").value = res.polSeqNo;
								$("b540RenewNo").value = res.renewNo;
	
								$("b540EndtIssCd").value = res.issCd;
								$("b540EndtYy").value = res.issueYy;
	
								$("b540InceptDate").value = nvl(res.inceptDate,"");
								$("doi").value = nvl(res.inceptDate.substr(0,10),"");
								$("inceptTag").checked = (res.gipiWPolbas[0].inceptTag == "Y" ? true :false);
								$("b540InceptTag").value = nvl(res.gipiWPolbas[0].inceptTag,"N");
	
								$("b540ExpiryDate").value = nvl(res.expiryDate,"");
								$("doe").value = nvl(res.expiryDate.substr(0,10),"");
								$("expiryTag").checked = (res.gipiWPolbas[0].expiryTag == "Y" ? true :false);
								$("b540ExpiryTag").value = nvl(res.gipiWPolbas[0].expiryTag,"N");
	
								$("endtExpDateTag").checked = (res.gipiWPolbas[0].endtExpDateTag == "Y" ? true :false);
								$("b540EffDate").value = nvl(res.gipiWPolbas[0].effDate,"");
								$("endtEffDate").value = nvl(res.gipiWPolbas[0].effDate,"");
								$("endtExpDate").value = nvl(res.endtExpiryDate.substr(0,10),"");
								$("b540EndtExpiryDate").value = nvl(res.endtExpiryDate,"");
								
								$("typeOfPolicy").value = res.gipiWPolbas[0].typeCd;
								$("b540SamePolNoSw").value = res.gipiWPolbas[0].samePolnoSw;
								
								$("b540ForeignAccSw").value = res.gipiWPolbas[0].foreignAccSw;
								$("b540CompSw").value = res.gipiWPolbas[0].compSw;
								$("compSw").value = res.gipiWPolbas[0].compSw;
								$("b540PremWarrTag").value = res.gipiWPolbas[0].premWarrTag;
								$("premWarrTag").checked = (res.gipiWPolbas[0].premWarrTag == "Y" ? true :false);
								$("assuredNo").value = res.gipiParlist[0].assdNo;
								$("b540OldAssdNo").value = res.gipiWPolbas[0].oldAssdNo;
								$("b540OldAddress1").value = res.gipiWPolbas[0].oldAddress1;
								$("b540OldAddress2").value = res.gipiWPolbas[0].oldAddress2;
								$("b540OldAddress3").value = res.gipiWPolbas[0].oldAddress3;
								$("b540RegPolicySw").value = res.gipiWPolbas[0].regPolicySw;
								$("regularPolicy").checked = (res.gipiWPolbas[0].regPolicySw == "Y" ? true :false);
								$("b540CoInsuranceSw").value = res.gipiWPolbas[0].coInsuranceSw;
								$("b540ManualRenewNo").value = res.gipiWPolbas[0].manualRenewNo;
								$("manualRenewNo").value = res.gipiWPolbas[0].manualRenewNo;
								$("b540CredBranch").value = res.gipiWPolbas[0].credBranch;
								$("creditingBranch").value = res.gipiWPolbas[0].credBranch;
								$("b540RefPolNo").value = res.gipiWPolbas[0].refPolNo;
								$("referencePolicyNo").value = res.gipiWPolbas[0].refPolNo;
								$("b540TakeupTerm").value = res.gipiWPolbas[0].takeupTerm;
								$("takeupTermType").value = res.gipiWPolbas[0].takeupTerm;
								$("bankRefNo").value = res.gipiWPolbas[0].bankRefNo;
								$("b540BookingYear").value = res.gipiWPolbas[0].bookingYear;
								$("b540BookingMth").value = res.gipiWPolbas[0].bookingMth;
								$("bookingYear").value = res.gipiWPolbas[0].bookingYear;
								$("bookingMth").value = res.gipiWPolbas[0].bookingMth;
								var ind = 0;
								for(var i = 1; i < $("bookingMonth").options.length; i++){
									if ($("bookingYear").value == $("bookingMonth").options[i].getAttribute("bookingYear") && 
											$("bookingMth").value == $("bookingMonth").options[i].getAttribute("bookingMth")){
										ind = i;
										$break;
									}
								}
								$("bookingMonth").selectedIndex = ind;
								$("b540ProvPremTag").value = res.gipiWPolbas[0].provPremTag;
								$("b540ProvPremPct").value = res.gipiWPolbas[0].provPremPct;
								$("b540ProrateFlag").value = res.gipiWPolbas[0].prorateFlag;
								$("prorateFlag").value = res.gipiWPolbas[0].prorateFlag;
								$("b540ShortRtPercent").value = nvl(res.nbtShortRtPercent,"");
								$("shortRatePercent").value = nvl(res.nbtShortRtPercent,"");
								objUW.hidObjGIPIS031.gipiWEndtText.endtTax = res.parVEndt; //$("b360EndtTax").value = res.parVEndt;
								$("parEndtTaxSw").value = res.parVEndt;
								$("endtInformation").clear();
								$("generalInformation").clear();
								$("parConfirmSw").value = res.parConfirmSw;
								$("varExpChgSw").value = res.varExpChgSw;
								$("varOldDateEff").value = res.varVOldDateEff;
								$("parSysdateSw").value = res.parSysdateSw;
								$("b540PackPolFlag").value = res.gipiWPolbas[0].packPolFlag;
								$("b240ParStatus").value = "2";
								$("parStatus").value = "2";
								$("policyNo").value = newPolicy; 
							}
						}else{
							showMessageBox(res.msgAlert, imgMessage.ERROR);
						}	
					}
				}
			});		
			hideOverlay();
		} catch(e){
			showErrorMessage("searchForEditedPolicy", e);
		}		
	}
	
	$("btnOkEdit").stopObserving("click");
	$("btnOkEdit").observe("click", function(){
		showNotice("Validating policy no., please wait...");
		var parId = $F("polParId");
		var lineCd = $F("polLineCd");
		var sublineCd = $F("polSublineCd");
		var issCd = $F("polIssCd");
		var issueYy = $F("polIssueYy");
		var polSeqNo = $F("polPolSeqNo");
		var renewNo = $F("polRenewNo");
		var isPack = $F("isPack");	//added by Gzelle SR3065
		if(lineCd.blank() | sublineCd.blank() | issCd.blank() | issueYy.blank() | polSeqNo.blank() | renewNo.blank()){
			showMessageBox("Please complete the policy number to be endorsed.", imgMessage.ERROR);
			return false;
		}else{
			if(isNaN(parseInt(issueYy))){
				showMessageBox("Issue Year must be a number from 0 to 99.", imgMessage.ERROR);
				return false;
			}else if(isNaN(parseInt(polSeqNo))){
				showMessageBox("Policy Sequence must be a number from 0 to 9999999.", imgMessage.ERROR);
				return false;
			}else if(isNaN(parseInt(renewNo))){
				showMessageBox("Renew No must be a number from 0 to 99.", imgMessage.ERROR);
				return false;
			}
			
			getEndtRiskTag();
			if ($("varOldLineCd").value != $F("polLineCd") || 
				$("varOldIssCd").value 	!= $F("polIssCd") || 
				$("varOldSublineCd").value != $F("polSublineCd") || 
				Number($("varOldPolSeqNo").value) != Number($F("polPolSeqNo")) || 
				Number($("varOldIssueYY").value) != Number($F("polIssueYy")) || 
				Number($("varOldRenewNo").value) != Number($F("polRenewNo"))){

				var errorRaised = false;
				var controller = $F("isPack") == "Y" ? "GIPIPackParInformationController" : "GIPIParInformationController";
				var action =  $F("isPack") == "Y" ? "checkPolicyNoForPackEndt" :"checkPolicyNoForEndt";
				
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
					asynchronous : false,
					evalScripts : true,
					//onCreate : showNotice("Validating policy no., please wait..."),
					onComplete : 
						function(response){
						hideNotice();
							if (checkErrorOnResponse(response)) {
								//var result = response.responseText.toQueryParams();
								var result = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
								
								if(result.resultEnteredPolNo != "Policy specified has been renewed." &&
										result.resultEnteredPolNo != "Policy has already expired." &&
										nvl(result.resultEnteredPolNo,null) != null){
									showMessageBox(result.resultEnteredPolNo, imgMessage.ERROR);
									errorRaised = true;
								}else if(nvl(result.resultPolicySpoilage,null) != null){
									showMessageBox(result.resultPolicySpoilage, imgMessage.ERROR);
									errorRaised = true;
								}else if(nvl(result.resultCheckClaims,null) != null){
									showMessageBox(result.resultCheckClaims, imgMessage.ERROR);
									errorRaised = false;
								}
							}
						}
					});

				function syntheticAlert(id, title, width, oldPolicy, newPolicy){
					try{
						$("contentHolder").setAttribute("src", id);
						$("contentHolder").setAttribute("lov", id);
						$("contentHolder").style.display = "block";
						$("contentHolder").style.position = "absolute";
						$("contentHolder").style.top = (document.documentElement.scrollTop+100) +"px";
						$("contentHolder").style.left = ((self.innerWidth - width) / 2) + 'px';						
						$("contentHolder").style.width = width+"px";
						$("opaqueOverlay").style.display = "block";
						$("contentHolder").update(
								'<div style="width: 100%; float:left; height: 20px; background-color: #e8e8e8; " id="overlayTitleDiv">'+
								'<span style="width: 85%; float: left; height: 20px; line-height: 20px;">'+
									'<label style="width: 100%; float: left; margin-left: 5px; font-size: 11px; font-weight: bold;" id="overlayTitle"></label>'+
								'</span>'+
								'<span style="font-size: 10px; margin-right: 5px; width: 10%; float: right; height: 20px; line-height: 20px;"><label id="close" style="cursor: pointer; float: right;" onclick="hideOverlay();">Close</label></span>'+
								'</div>'+
								'<div class="sectionDiv" id="lovListingDiv" name="lovListingDiv" style="padding-top:2px; float:left; display:block; width:'+(parseInt(width-20))+'px; height:185px; overflow:auto; margin-left:9px; margin-top:10px; text-align:center;">'+
									'<pre>\n\n<font style="line-height:1.5em; font-family:Verdana; font-weight:bolder; font-size:14px;">User has altered the Policy Number from :</font>\n'+	
									'<font style="line-height:1.5em; font-family:Verdana; font-weight:bolder; font-size:14px; text-decoration:blink; color:#FF0000; background-color:#E8E8E8;">&nbsp;&nbsp;&nbsp;&nbsp;<span>'+oldPolicy+'</span>&nbsp;&nbsp;&nbsp;&nbsp;</font>\n'+
									'<font style="line-height:1.5em; font-family:Verdana; font-weight:bolder; font-size:14px;">to</font>\n'+
									'<font style="line-height:1.5em; font-family:Verdana; font-weight:bolder; font-size:14px; text-decoration:blink; color:#0000FF; background-color:#E8E8E8;">&nbsp;&nbsp;&nbsp;&nbsp;<span>'+newPolicy+'</span>&nbsp;&nbsp;&nbsp;&nbsp;</font>\n'+
									'<font style="line-height:1.5em; font-family:Verdana; font-weight:bolder; font-size:14px;">all information related to the previous PAR</font>\n'+
									'<font style="line-height:1.5em; font-family:Verdana; font-weight:bolder; font-size:14px;">will be deleted. Continue anyway ?</font></pre>'+
								'</div>'+
								'<div style="width:'+(parseInt(width-20))+'px; margin-left:10px; float:left;">'+
									'<table align="center">'+
									'<tr><td><input type="button" class="button" style="width:60px;" id="btnOkEdit2"  value="Ok"/>'+
									'<input type="button" class="button" style="width:60px; margin-left:2px;" id="btnCancelEdit"  value="Cancel"/></td></tr>'+
									'</table>'+
								'</div>');	
						$("overlayTitle").update(title.toUpperCase());

						$("btnCancelEdit").stopObserving("click");
						$("btnCancelEdit").observe("click", function(){
							hideOverlay();
							if (isPack == "Y" || getLineCd() != "SU") {	//modified by Gzelle 12042014 SR3065
								$("endtEffDate").focus();
							} else {
								$("eed").focus();
							}
						});

						$("btnOkEdit2").stopObserving("click");
						$("btnOkEdit2").observe("click", function(){
							if(isPack == "Y"){//$F("isPack") == "Y"){ modified by Gzelle 12032014 SR3065
								searchForEditedPackPolicy(parId, lineCd, sublineCd, issCd, issueYy, polSeqNo, renewNo, newPolicy);
							} else {
								searchForEditedPolicy(parId, lineCd, sublineCd, issCd, issueYy, polSeqNo, renewNo, newPolicy);
							}
						});
					}catch(e){
						showErrorMessage("syntheticAlert", e);
					}
				}	
				
				if(errorRaised){
					hideOverlay();
					return false;
				}else{
					hideNotice();
					var oldPolicy = $("varOldLineCd").value+"-"+$("varOldSublineCd").value+"-"+$("varOldIssCd").value+"-"+formatNumberDigits(Number($("varOldIssueYY").value),2)+"-"+formatNumberDigits(Number($("varOldPolSeqNo").value),7)+"-"+formatNumberDigits(Number($("varOldRenewNo").value),2);
					var newPolicy = lineCd+"-"+sublineCd+"-"+issCd+"-"+issueYy+"-"+polSeqNo+"-"+renewNo;
					syntheticAlert("syntheticAlert", "Confirmation", 400, oldPolicy, newPolicy);
				}	
			}	
		}
		hideNotice();
	});

	hideNotice();
	initializeAll();
</script>