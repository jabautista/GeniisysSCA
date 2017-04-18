<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
   		<label>Basic Information</label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label name="gro" style="margin-left: 5px;">Hide</label>
	   		<label id="reloadForm" name="reloadForm">Reload Form</label>
   		</span>
   	</div>
</div>
<div class="sectionDiv" id="endtBasicInfoDivOuter" style="float:left;" changeTagAttr="true">
	<div id="endtBasicInfoDiv" style="float:left; width: 81.5%; height: 320px;">
		<div id="endtBasicInfo" style="float:left; margin-top: 13px; width:47%;">
			<table align="center" cellspacing="1" border="0" width="100%">
	 			<tr>
					<td class="rightAligned" style="width: 108px;">PAR No. </td>
					<td class="leftAligned" style="width: 200px;"><input style="width: 220px; " id="parNo" name="parNo" type="text" value="${gipiParList.parNo }" readonly="readonly" class="required"/></td>	
				</tr>
				<tr id="rowSublineCd">	
					<td class="rightAligned">Subline</td>
				    <td class="leftAligned">
				    	<input type="hidden" id="paramSubline" name="paramSubline" value="${gipiWPolbas.sublineCd }" class="required"/>
						<select id="sublineCd" name="sublineCd" style="float:left; width: 228px; margin-right:5px;" class="required">
							<option value="" openPolicySw="" opFlag=""></option>
							<c:forEach var="s" items="${sublineListing}">
								<option openPolicySw="${s.openPolicySw }" opFlag="${s.opFlag }" value="${s.sublineCd}" 
								<c:if test="${gipiWPolbas.sublineCd eq s.sublineCd}">
										selected="selected"
								</c:if>
								>${s.sublineCd} - ${s.sublineName}</option>
							</c:forEach>
						</select>
						<c:if test="${parType eq 'P'}">
							<input style="float:left;" disabled="disabled" type="checkbox" id="surchargeSw" name="surchargeSw" value="Y" 
							<c:if test="${gipiWPolbas.surchargeSw eq 'Y' }">
									checked="checked"
							</c:if>/>
							<label style="float:left; margin-left:5px;" for="surchargeSw" title="W/ Surcharge">W/ Surcharge</label>
						</c:if>	
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Manual Renew No. </td>
					<td class="leftAligned">
						<input class="integerNoNegativeUnformattedNoComma required" style="float:left; width: 220px; text-align:center; margin-right:5px;" id="manualRenewNo" name="manualRenewNo" type="text" value="<fmt:formatNumber pattern="00">${gipiWPolbas.manualRenewNo}</fmt:formatNumber>" maxlength="2" errorMsg="Entered manual renew no. is invalid. Valid value is from 00 to 99."/>
						<input type="hidden" id="renewNo" name="renewNo" value="${gipiWPolbas.renewNo }<c:if test="${empty gipiWPolbas.renewNo}">0</c:if>" maxlength="2" />
						<!-- 
						<input type="hidden" id="paramRenewNo" name="paramRenewNo" value="${gipiWPolbas.renewNo }<c:if test="${empty gipiWPolbas.renewNo}">0</c:if>" maxlength="2" />
						 -->												
					</td>	
				</tr>				
				<tr>
					<td class="rightAligned" style="width: 108px;">Policy No. </td>
					<td class="leftAligned" style="width: 220px;">
						<input style="width: 175px; " id="policyNo" name="policyNo" type="text" value="${policyNo }" readonly="readonly" class="required"/>
						<input type="button" class="button" style="width: 40px; height: 20px; " id="btnEditPolicyNo" name="btnEditPolicyNo" value="Edit" />
					</td>
				</tr>				
				<tr>	
					<td class="rightAligned">Type of Policy </td>
				    <td class="leftAligned">
						<select id="typeOfPolicy" name="typeOfPolicy" style="width: 228px;">
							<option value=""></option>
							<c:forEach var="pt" items="${policyTypeListing}">
								<option value="${pt.typeCd}"
								<c:if test="${gipiWPolbas.typeCd eq pt.typeCd}">
										selected="selected"
								</c:if>
								>${pt.typeDesc}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Address </td>
					<td class="leftAligned">
						 <!--jmm SR-22834-->
						<c:choose>
							<c:when test="${confirmResult eq '1'}">
								<input style="width: 220px;" id="address1" name="address1"  value="${address1}" type="text" maxlength="100" class="required"/>
							</c:when>
							<c:otherwise>
								<input style="width: 220px;" id="address1" name="address1" type="text" maxlength="50" class="required"/> <!-- John Daniel SR-4745,4746,4665; removed value attribute -->
							</c:otherwise>
						</c:choose>
					</td>	
				</tr>
				<tr>	
					<td>&nbsp;</td>
					<td class="leftAligned">
					 	<!--jmm SR-22834-->
						<c:choose>
							<c:when test="${confirmResult eq '1'}">
								<input style="width: 220px;" id="address2" name="address2"  value="${address2}" type="text" maxlength="100""/>
							</c:when>
							<c:otherwise>
								<input style="width: 220px;" id="address2" name="address2" type="text" maxlength="50" /><!-- John Daniel SR-4745,4746,4665; removed value attribute -->
							</c:otherwise>
						</c:choose>
					</td>	
				</tr>
				<tr>
					<td>&nbsp;</td>	
					<td class="leftAligned">
						 <!--jmm SR-22834-->
						<c:choose>
							<c:when test="${confirmResult eq '1'}">
								<input style="width: 220px;" id="address3" name="address3"  value="${address3}" type="text" maxlength="100"/>
							</c:when>
							<c:otherwise>
								<input style="width: 220px;" id="address3" name="address3" type="text" maxlength="50" /><!-- John Daniel SR-4745,4746,4665; removed value attribute -->
							</c:otherwise>
						</c:choose>
					</td>	
				</tr>
				<tr>	
					<td class="rightAligned">Crediting Branch </td>
				    <td class="leftAligned">
						<select id="creditingBranch" name="creditingBranch" style="width: 228px;" >
							<option value=""></option><!-- blank option added by andrew - 06.02.2011 -->
							<c:forEach var="creditingBranchListing" items="${branchSourceListing}">
								<option regionCd="${creditingBranchListing.regionCd}" value="${creditingBranchListing.issCd}"
								<c:if test="${gipiWPolbas.credBranch eq creditingBranchListing.issCd}">
									selected="selected"
								</c:if>>${creditingBranchListing.issName}</option>				
							</c:forEach>
						</select>
					</td>
				</tr>				
				<tr>
					<td class="rightAligned" style="width: 108px;">Bank Ref No.</td>
					<td class="leftAligned"><input style="width: 220px; " id="bankRefNo" name="bankRefNo" type="text" value="${gipiWPolbas.bankRefNo }" readonly="readonly"/></td>	
				</tr>				
			</table>
		</div>
		<div id="endtBasicInfo" style="float:left; margin-top: 11px; margin-left: 10px; width:51%;">
			<table align="left" cellspacing="1" border="0" width="100%">
				<tr>
					<td class="rightAligned" style="width: 120px;">Assured Name </td>
					<td class="leftAligned">
						<!-- <input id="oscm" name="oscm" class="button" type="button" value="Search" />  -->
						<div style="width: 226px;" class="required withIconDiv">
							 <!--jmm SR-22834-->
							<c:choose>
								<c:when test="${confirmResult eq '1'}">
									<input style="width: 200px;" id="assuredName" name="assuredName" type="text" value="${newAssdName}" readonly="readonly" class="required withIcon" maxlength="100"/>
								</c:when>
								<c:otherwise>
									<input style="width: 200px;" id="assuredName" name="assuredName" type="text" value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.dspAssdName}</c:if>" readonly="readonly" class="required withIcon"/>
								</c:otherwise>
							</c:choose>
							<%-- <input style="width: 200px;" id="assuredName" name="assuredName" type="text" value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.dspAssdName}</c:if>" readonly="readonly" class="required withIcon"/> --%>
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmDate" name="oscmDate" alt="Go" />
						</div>	
						 <!--jmm SR-22834-->
						<c:choose>
							<c:when test="${confirmResult eq '1'}">
								<input id="assuredNo" name="assuredNo" type="hidden" value="${newAssdNo}" />
							</c:when>
							<c:otherwise>					
								<input id="assuredNo" name="assuredNo" type="hidden" value="${gipiParList.assdNo}" />
							</c:otherwise>
						</c:choose>	
						<!-- 
						<input id="paramAssuredNo" name="paramAssuredNo" type="hidden" value="${gipiParList.assdNo}" />										
						<input style="width: 200px;" id="paramAssuredName" name="paramAssuredName" type="hidden" value="${gipiWPolbas.dspAssdName}" readonly="readonly" />
						 -->												
					</td>
				</tr>
				<tr>
					<td class="rightAligned" id="rowInAccountOf">In Account Of </td>
				    <td class="leftAligned" style="width: 280px;">
				    	<div style="width: 226px;" class="withIconDiv">
					    	<input style="width: 200px;" id="inAccountOf" name="inAccountOf" type="text" value="${gipiWPolbas.acctOfName}" class="withIcon" readonly="readonly"/>
					    	<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osaoDate" name="osaoDate" alt="Go" />					    						    	
						</div>
				    	<!-- <input type="button" id="osao" name="osao" class="button" value="Search" /> -->				    	
			    		<input type="checkbox" id="deleteSw" name="deleteSw" value="Y" title="Delete Sw" />
			    		<input type="checkbox" id="labelTag" name="labelTag" value="Y" title="Leased To Tag" />			    	
				    	<input id="acctOfCd" name="acctOfCd" type="hidden" value="${gipiWPolbas.acctOfCd}" />				    					    	
				    </td>
				</tr>				
				<tr>
					<td class="rightAligned" style="width: 108px;">Endt No. </td>
					<td class="leftAligned">
						<input style="width: 220px;" id="endtNo" name="endtNo" type="text" value="<c:if test="${not empty gipiWPolbas }">${gipiWPolbas.lineCd } - ${gipiWPolbas.sublineCd } - ${gipiWPolbas.endtIssCd } - ${gipiWPolbas.endtYy }</c:if>" readonly="readonly" class="required" />
					</td>	
				</tr>				
				<tr>
					<td class="rightAligned">Issue Date </td>
				    <td class="leftAligned">
				    	<div style="width: 226px;" class="required withIconDiv">
				    		<input type="hidden" id="issueDateToday" name="issueDateToday" value="<fmt:formatDate pattern="MM-dd-yyyy" value="<%= new java.util.Date() %>" />" readonly="readonly"/>
				    		<input id="issueDate" name="issueDate" type="text" value="<fmt:formatDate value="${gipiWPolbas.issueDate}" pattern="MM-dd-yyyy" />" readonly="readonly" class="required withIcon" style="width: 202px;" />
				    		<c:choose>
				    			<c:when test="">
				    				<img id="hrefIssueDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Issue Date" />
				    			</c:when>
				    			<c:otherwise>
				    				<img id="hrefIssueDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Issue Date"
							    	<c:if test="${updIssueDate eq 'Y'}">
										 onClick="null<!-- scwShow($('issueDate'),this, null); commented out edgar 10/24/2014-->"
									</c:if>
									/>
				    			</c:otherwise>
				    		</c:choose>				    		
				    	</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Issue Place </td>
				    <td class="leftAligned">
				    	<input type="hidden" id="paramIssuePlace" name="paramIssuePlace" value="${gipiWPolbas.placeCd }" />
						<select id="issuePlace" name="issuePlace" style="width: 228px;">
							<option value=""></option>
							<c:forEach var="pl" items="${placeListing}">
								<option value="${pl.placeCd}"
								<c:if test="${gipiWPolbas.placeCd eq pl.placeCd}">
										selected="selected"
								</c:if>
								>${pl.place}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>	
					<td class="rightAligned">Risk Tag </td>
				    <td class="leftAligned">
						<select id="riskTag" name="riskTag" style="width: 228px;">
							<option value=""></option>
							<c:forEach var="rt" items="${riskTagListing}">
								<option value="${rt.rvLowValue}"
								<c:if test="${gipiWPolbas.riskTag eq rt.rvLowValue}">
										selected="selected"
								</c:if>
								>${rt.rvMeaning}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Reference Policy No. </td>
					<td class="leftAligned">
						<input style="width: 220px;" id="referencePolicyNo" name="referencePolicyNo" type="text" value="${gipiWPolbas.refPolNo }" maxlength="30" />
					</td>	
				</tr>
				<tr>	
					<td class="rightAligned">Industry </td>
				    <td class="leftAligned">
						<select id="industry" name="industry" style="width: 228px;">
							<option value=""></option>
							<c:forEach var="i" items="${industryListing}">
								<option value="${i.industryCd}"
								<c:if test="${gipiWPolbas.industryCd eq i.industryCd}">
										selected="selected"
								</c:if>
								>${i.industryName}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>	
					<td class="rightAligned">Region </td>
				    <td class="leftAligned">
						<select id="region" name="region" style="width: 228px;">
							<option value=""></option>
							<c:forEach var="r" items="${regionListing}">
								<option value="${r.regionCd}"
								<c:if test="${gipiWPolbas.regionCd eq r.regionCd}">
										selected="selected"
								</c:if>
								>${r.regionDesc}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<c:if test="${ora2010Sw eq 'Y'}">
					<tr>	
						<td class="rightAligned">Package Plan <input type="checkbox" id="packPLanTag" name="packPLanTag" value="Y" <c:if test="${gipiWPolbas.planSw eq 'Y'}">checked="checked"</c:if>/></td>
					    <td class="leftAligned">
							<select id="selPlanCd" name="selPlanCd" style="width: 228px;">
								<option value=""></option>
							</select>
						</td>
					</tr>
					<tr>	
						<td class="rightAligned">Bancassurance <input type="checkbox" id="bancaTag" name="bancaTag" value="Y" <c:if test="${gipiWPolbas.bancassuranceSw eq 'Y'}">checked="checked"</c:if> /></td>
					    <td class="leftAligned">
							<input type="button" class="button noChangeTagAttr" id="btnBancaDetails" name="btnBancaDetails" value="Bancassurance Details" />
						</td>
					</tr>
				</c:if>				
			</table>
		</div>
	</div>
	<div id="endtBasicInfoDivRightOuter" style="border-left:1px solid #E0E0E0; float:right; width: 18%; height: 320px;">
		<div id="endtBasicInfoDivR" style="border-top:1px solid #E0E0E0; float:left; width: 100%;">
			<label style="padding:2px; width: 100%; text-align: center; font-weight: bold;">Type</label>
		</div>
		<div id="endtBasicInfoDivR" style="border-top:1px solid #E0E0E0; float:left; width: 100%;">
			<table align="left">
				<tr>
					<td class="leftAligned"><input type="checkbox" id="packagePolicy" name="packagePolicy" value="Y"
						<c:if test="${gipiWPolbas.packPolFlag eq 'Y' }">checked="checked"</c:if>/>
					</td>
					<td class="leftAligned"><label for="packagePolicy">Package Policy</label></td>
				</tr>
				<tr>
					<td class="leftAligned"><input type="checkbox" id="regularPolicy" name="regularPolicy" value="Y" 
						<c:if test="${gipiWPolbas.regPolicySw eq 'Y' }">checked="checked"</c:if>/>
					</td>
					<td class="leftAligned"><label for="regularPolicy">Regular Policy</label></td>
				</tr>
				<tr>
					<td class="leftAligned"><input type="checkbox" id="premWarrTag" name="premWarrTag" value="Y" 
						<c:if test="${gipiWPolbas.premWarrTag eq 'Y' }">checked="checked"</c:if>/>
					</td>
					<td class="leftAligned"><label for="premWarrTag">W/ Prem Warranty</label></td>
				</tr>
				<tr>
					<td class="leftAligned"><input type="checkbox" id="fleetTag" name="fleetTag" value="Y" 
						<c:if test="${gipiWPolbas.fleetPrintTag eq 'Y' }">checked="checked"</c:if>/>
					</td>
					<td class="leftAligned"><label for="fleetTag">Fleet Tag</label></td>
				</tr>
				<tr>
					<td class="leftAligned"><input type="checkbox" id="wTariff" name="wTariff" value="Y" 
						<c:if test="${gipiWPolbas.withTariffSw eq 'Y' }">checked="checked"</c:if>/>
					</td>
					<td class="leftAligned"><label for="wTariff">W/ Tariff</label></td>
				</tr>
				<tr>
					<td class="leftAligned"><input type="checkbox" id="endorseTax" name="endorseTax" value="Y" 
						<c:if test="${gipiWEndtText.endtTax eq 'Y' }">checked="checked"</c:if>/>
					</td>
					<td class="leftAligned"><label for="endorseTax">Endorse Tax</label></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</div>
		<div id="endtBasicInfoDivR" style="border-top:1px solid #E0E0E0; float:left; width: 100%;">
			<label style="padding:2px; width: 100%; text-align: center; font-weight: bold;">Cancellation</label>
		</div>
		<div id="endtBasicInfoDivR" style="border-top:1px solid #E0E0E0; float:left; width: 100%;">
			<table align="left" style="width: 100%;">
				<tr>
					<td class="leftAligned"><input type="checkbox" id="nbtPolFlag" name="nbtPolFlag" 
						<%-- value="4" <c:if test="${gipiWPolbas.polFlag eq '4' }">checked="checked"</c:if>/> --%>
						<c:if test="${gipiWPolbas.cancelType eq '1' }">checked="checked" value="4"</c:if>/>  <!-- robert 9.28.2012 -->
					</td>
					<td class="leftAligned"><label for="nbtPolFlag">Cancelled (Flat)</label></td>
				</tr>
				<tr>
					<td class="leftAligned"><input type="checkbox" id="prorateSw" name="prorateSw"  
						<%-- value="1" <c:if test="${gipiWPolbas.prorateFlag eq '1' }">checked="checked"</c:if>/> --%>
						<c:if test="${gipiWPolbas.cancelType eq '2' }">checked="checked" value="1"</c:if>/>  <!-- robert 9.28.2012 -->				
					</td>
					<td class="leftAligned"><label for="prorateSw">Cancelled</label></td>
				</tr>
				<tr style="display: <c:if test="${isPack eq 'Y'}">none</c:if>">
					<td class="leftAligned"><input type="checkbox" id="endtCancellation" name="endtCancellation"  
						<%--  value="N"   --%>
						<c:if test="${gipiWPolbas.cancelType eq '3' }">checked="checked" value="Y"</c:if>/>  <!-- robert 9.28.2012 -->
					</td>
					<td class="leftAligned"><label for="endtCancellation">Endt Cancellation</label></td>
				</tr>
				<tr style="display: <c:if test="${isPack eq 'Y'}">none</c:if>">
					<td class="leftAligned"><input type="checkbox" id="coiCancellation" name="coiCancellation" 
						<%--  value="N"   --%>
						<c:if test="${gipiWPolbas.cancelType eq '4' }">checked="checked" value="Y"</c:if>/>  <!-- robert 9.28.2012 -->
					</td>
					<td class="leftAligned"><label for="coiCancellation">COI Cancellation</label></td>
				</tr>						
				<tr>
					<td colspan="2" align="center"><input type="button" id="btnCancelEndt" style="margin-top: 10px;" name="btnCancelEndt" class="
						<c:choose>
							<c:when test="${isPack eq 'Y' }">
								button
							</c:when>
							<c:otherwise>
								disabledButton
							</c:otherwise>
						</c:choose>
						" value="Cancel Endt" /></td>							
				</tr>
			</table>
		</div>
		<div id="endtBasicInfoDivR" style="border-top:1px solid #E0E0E0; float:left; width: 100%;">
			<table align="left">
				<tr>
					<td class="leftAligned">								
						<input type="checkbox" id="provisionalPremium" name="provisionalPremium" value="Y" 
							<c:if test="${gipiWPolbas.provPremTag eq 'Y' }">checked="checked"</c:if>/>
						</td>
					<td class="leftAligned"><label for="provisionalPremium">Provisional Premium</label></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td class="leftAligned">
						<span id="provPremRate" name="provPremRate"  
							<c:if test="${gipiWPolbas.provPremTag ne 'Y' }">style="display: none;"</c:if>>
							<input type="hidden" id="paramProvPremRatePercent" name="paramProvPremRatePercent" class="moneyRate" style="width: 90px;" maxlength="12" value="${gipiWPolbas.provPremPct }" />
							<input type="text" id="provPremRatePercent" name="provPremRatePercent" class="moneyRate required" style="width: 90px;" maxlength="12" value="${gipiWPolbas.provPremPct }" />
						</span>
					</td>
				</tr>
			</table>
		</div>
	</div>
</div>
<script type="text/javascript">
try{
 		if("${confirmResult}" != 1){ <!--jmm SR-22834-->
		$("address1").value = unescapeHTML2("${gipiWPolbas.address1}"); //added by John Daniel SR-4745,4746,4665
		$("address2").value = unescapeHTML2("${gipiWPolbas.address2}");
		$("address3").value = unescapeHTML2("${gipiWPolbas.address3}");
 	}else{
		$("address1").value = unescapeHTML2("${address1}");
		$("address2").value = unescapeHTML2("${address2}");
		$("address3").value = unescapeHTML2("${address3}");
	} 
	
	var cancelType = objUW.GIPIS031.gipiWPolbas.cancelType; //robert 11.16.2012
	var prevprovPremRate; //edgar 10/13/2014
	
	function commonCancellationProcedure(func){
		try{
			// check for existence of claims and if pending claim(s) is found
			// disallow cancellation process
			new Ajax.Request(contextPath + "/GIPIParInformationController?action=checkForPendingClaims", {
				method : "POST",
				parameters : {
					parId : objUW.GIPIS031.gipiParList.parId,
					lineCd : objUW.GIPIS031.gipiWPolbas.lineCd,
					sublineCd : objUW.GIPIS031.gipiWPolbas.sublineCd,
					issCd : objUW.GIPIS031.gipiWPolbas.issCd,
					issueYy : objUW.GIPIS031.gipiWPolbas.issueYy,
					polSeqNo : objUW.GIPIS031.gipiWPolbas.polSeqNo,
					renewNo : objUW.GIPIS031.gipiWPolbas.renewNo
				},			
				onComplete : function(response){
					if(checkErrorOnResponse(response)){
						if(response.responseText != "N"){
							showWaitingMessageBox("The policy has pending claims, cannot cancel policy.", imgMessage.INFO, function(){
								$("nbtPolFlag").checked = false;
								objUW.GIPIS031.gipiWPolbas.polFlag = "1";
							});
							return false;
						}else{
							// display a warning before cancelling a paid policy							
							new Ajax.Request(contextPath + "/GIPIParInformationController?action=checkPolicyPayment", {
								method : "POST",
								parameters : {
									parId : objUW.GIPIS031.gipiParList.parId,
									lineCd : objUW.GIPIS031.gipiWPolbas.lineCd,
									sublineCd : objUW.GIPIS031.gipiWPolbas.sublineCd,
									issCd : objUW.GIPIS031.gipiWPolbas.issCd,
									issueYy : objUW.GIPIS031.gipiWPolbas.issueYy,
									polSeqNo : objUW.GIPIS031.gipiWPolbas.polSeqNo,
									renewNo : objUW.GIPIS031.gipiWPolbas.renewNo
								},									
								onComplete : function(response){
									if(checkErrorOnResponse(response)){																	
										if(response.responseText != "0"){
											showConfirmBox("Cancellation", "Payments have been made to the policy/endorsement to be cancelled. Continue?",
												"Accept", "Cancel",	func,
												function(){
													$("nbtPolFlag").checked = false;
													return false;
												});	
										}else{
											func();
										}
									}											
								}
							});
						}
					}											
				}
			});
		}catch(e){
			showErrorMessage("commonCancellationProcedure", e);
		}
	}
	
	function cancellationCheckboxHandler(){
		try{
			objUW.GIPIS031.gipiWPolbas.cancelType = null;
			
			if($("nbtPolFlag").checked){
				$("prorateSw").checked = false;
				$("endtCancellation").checked = false;
				$("coiCancellation").checked = false;
				disableButton($("btnCancelEndt"));
				
				objUW.GIPIS031.gipiWPolbas.cancelType = "1";	
				objUWGlobal.cancelTag = "N"; // robert 10.09.2012 
				//$("conditionDiv").hide(); //commented out by christian 03/26/2013
				//$("conditionText").innerHTML = ""; 
			}else if($("prorateSw").checked){
				$("nbtPolFlag").checked = false;
				$("endtCancellation").checked = false;
				$("coiCancellation").checked = false;
				disableButton($("btnCancelEndt"));
				
				objUW.GIPIS031.gipiWPolbas.cancelType = "2";		
				objUWGlobal.cancelTag = "N"; // robert 10.09.2012 
			}else if($("endtCancellation").checked){
				$("nbtPolFlag").checked = false;
				$("prorateSw").checked = false;
				$("coiCancellation").checked = false;
				enableButton($("btnCancelEndt"));
				
				objUW.GIPIS031.gipiWPolbas.cancelType = "3";
				if (cancelType == objUW.GIPIS031.gipiWPolbas.cancelType){
					objUWGlobal.cancelTag = "Y"; // robert 10.09.2012 
				}
			}else if($("coiCancellation").checked){
				$("nbtPolFlag").checked = false;
				$("prorateSw").checked = false;
				$("endtCancellation").checked = false;
				enableButton($("btnCancelEndt"));

				objUW.GIPIS031.gipiWPolbas.cancelType = "4";	
				if (cancelType == objUW.GIPIS031.gipiWPolbas.cancelType){
					objUWGlobal.cancelTag = "Y"; // robert 10.09.2012 
				}
			}else{
				//$("conditionDiv").show(); //commented out by christian 03/26/2013
				//$("conditionText").innerHTML = "Condition";
				enableInputField("noOfDays");
			}
			if(!$("prorateSw").checked){ //added by christian
				$("prorateFlag").options[1].show();
				$("prorateFlag").options[1].disable = false;
			}
		}catch(e){
			showErrorMessage("cancellationCheckboxHandler", e);
		}
	}
	
	function revertFlatCancellation(flatType){
		try{
			showConfirmBox("Cancellation", "All negated records for this policy will be deleted.",
				"Accept", "Cancel",	
				function(){
					objUW.GIPIS031.parameters.paramRevertFlatCancellation = "Y";
					objUW.GIPIS031.parameters.paramDeleteOtherInfo = "Y"; // execute corresponding procedure upon saving in java
					objUW.GIPIS031.parameters.paramDeleteRecords = "Y"; // execute corresponding procedure upon saving in java
					
					objUW.GIPIS031.gipiWItem = [];	// set to empty records due to performing deleteOtherInfo
					objUW.GIPIS031.gipiWItmperl = [];	// set to empty records due to performing deleteOtherInfo
					
					objUW.GIPIS031.gipiParList.parStatus = 3;
					
					// comment muna. parang di applicable sa web
					//disableMenu("distribution");
					//disableMenu("bill");				
					//enableMenu("post");
					//enableMenu("itemInfo");
					
					$("prorateFlag").enable();
					$("compSw").disable();					
					
					enableDate("hrefDoiDate");
					enableDate("hrefDoeDate");
					enableDate("hrefEndtEffDate");
					enableDate("hrefEndtExpDate");
					
					$("prorateFlag").value = 2;
					$("prorateSw").checked = false;
					objUW.GIPIS031.gipiWPolbas.polFlag = "1";
					
					if(flatType){
						$("endtEffDate").value = "";						
						objUW.GIPIS031.variables.varVCnclldFlatFlag = "N";						
					}else{
						objUW.GIPIS031.variables.varVCnclldFlag = "N";
						$("prorateFlag").value = "2";
						fireEvent($("prorateFlag"),"change");
					}
					
					$("endtEffDate").focus();
					
					cancellationCheckboxHandler();
				},
				function(){
					objUW.GIPIS031.parameters.paramRevertFlatCancellation = "N";
					$("nbtPolFlag").checked = flatType ? true : false;
					
					if(!flatType){						
						$("prorateSw").checked = false;
					}
					
					objUW.GIPIS031.gipiWPolbas.polFlag = "4";
					
					cancellationCheckboxHandler();
				});	
		}catch(e){
			showErrorMessage("revertFlatCancellation", e);
		}
	}
	
	function polFlagProrateSwCancellation(flatType){
		try{
			// function added by Kris 04.15.2014 to get the endt policy dates
			function getEndtPolicyDatesAfterCancel(){
				new Ajax.Request(contextPath + "/GIPIPolbasicController?action=getEndtPolicyDatesAfterCancel", {
					method : "POST",
					parameters : {
						parId : objUW.GIPIS031.gipiParList.parId
					},
					asynchronous: false,
					onComplete : function(response){
						if(checkErrorOnResponse(response)){
							var endtPolicyDates = JSON.parse(response.responseText);
							$("doi").value = endtPolicyDates.inceptDate; 
							$("doe").value = endtPolicyDates.expiryDate;
						}											
					}
				});
			}
			
			function nextStep01(){
				try{
					objUW.GIPIS031.parameters.paramDeleteOtherInfo = "Y"; // execute corresponding procedure upon saving in java
					objUW.GIPIS031.parameters.paramDeleteRecords = "Y"; // execute corresponding procedure upon saving in java
					
					if($("nbtPolFlag").checked){
						objUW.GIPIS031.parameters.paramCreateNegatedRecordsFlat = "Y";
						objUW.GIPIS031.gipiParList.parStatus = 5;
						
						$("prorateFlag").disable();
						$("compSw").disable();
						$("noOfDays").disable();
						$("shortRatePercent").disable();
						$("prorateFlag").value = 2;
						$("prorateFlag").options[1].show();
						$("prorateFlag").options[1].disable = false;
						$("compSw").value = "";
						disableDate("hrefEndtEffDate");
						objUW.GIPIS031.variables.varVCnclldFlatFlag = "Y";
					}else{
						objUW.GIPIS031.parameters.paramCreateNegatedRecordsFlat = "N";
						
						$("prorateFlag").enable();
						$("compSw").enable();
						$("noOfDays").enable();
						$("shortRatePercent").enable();
						$("prorateFlag").value = 1;
						$("prorateFlag").options[1].hide();
						$("prorateFlag").options[1].disable = true;
						// fire change event for prorate flag
						$("shortRateSelected").hide();
						$("shortRatePercent").hide();
						$("prorateSelected").show();
						$("noOfDays").readOnly = true;
						$("noOfDays").show();
						$("noOfDays").value = objUWParList.parType == "P" ? computeNoOfDays($F("doi"),$F("doe"),$F("compSw")) : computeNoOfDays($F("endtEffDate"),$F("endtExpDate"),$F("compSw"));
						
						objUW.GIPIS031.parameters.paramProrateCancelSw = "Y";
						
						$("compSw").value = "N";
						objUW.GIPIS031.variables.varVCnclldFlag = "Y";
					}					
					
					disableDate("hrefDoiDate");
					disableDate("hrefDoeDate");
					disableInputField("noOfDays");
					//disableDate("hrefEndtEffDate"); Removed by Jomar Diago 01-02-2013
					disableDate("hrefEndtExpDate");
					
					objUW.GIPIS031.gipiWPolbas.polFlag = "4";
					
					cancellationCheckboxHandler();
					
					// apollo cruz - sr 20590 - 11.12.2015
					if($("prorateSw").checked) {
						$("endtExpDate").value = $F("doe");
						fireEvent($("endtExpDate"), "blur");
					}
					
					showMessageBox("Endorsement successfully cancelled.", imgMessage.INFO);
				}catch(e){
					showErrorMessage("nextStep01", e);
				}
			}
			
			function nextStep(){
				try{					
					if($F("bookingMth").empty() || $F("bookingYear").empty()){
						showMessageBox("Booking month and year is needed before performing cancellation.", imgMessage.INFO);
						$("nbtPolFlag").checked = false;
						return false;
					}
					
					var itemLength = 0;
					var perilLength = 0;
					var messageText = "";
					
					// for PAR that have peril or item warn the user that existing item and peril
				    // would be deleted , also warn the user of changes to take place in PAR's eff_date
				     
					itemLength = objUW.GIPIS031.gipiWItem.length;
					perilLength = objUW.GIPIS031.gipiWItmperl.length;
					var changeEndtEffDate = false; // andrew - 05.14.2012
					if($("nbtPolFlag").checked){
						if(itemLength > 0 || perilLength > 0 || $F("doi") != $F("doe")){
							if($F("doi") != $F("doe")){
								messageText = "Flat Cancellation requires an endorsement effectivity as of inception date. Changes are about to take place.";
								changeEndtEffDate = true;
							}else if(itemLength > 0 && perilLength > 0){
								messageText = "This endorsement have existing item(s) and peril(s), performing cancellation will cause all the records to be replaced.";
							}else if(itemLength > 0){
								messageText = "This endorsement have existing item(s), performing cancellation will cause all the records to be replaced.";
							}
						}
					}else if($("prorateSw").checked){
						if(itemLength > 0 || perilLength > 0){
							if(itemLength > 0 && perilLength > 0){
								messageText = "This endorsement have existing item(s) and peril(s), performing cancellation will cause all the records to be replaced.";
							}else if(itemLength > 0){
								messageText = "This endorsement have existing item(s), performing cancellation will cause all the records to be replaced.";
							}
						}
					}
					
					if(messageText != ""){
						showConfirmBox("Cancellation", messageText,	"Accept", "Cancel",	function(){
								nextStep01();
								getEndtPolicyDatesAfterCancel(); // kris 04.15.2014
								if(changeEndtEffDate){ // andrew - 05.14.2012
									$("endtEffDate").value = $F("doi");
									$("endtExpDate").value = $F("doe"); // andrew - 02.12.2013
								}
							},
							function(){
								if($("nbtPolFlag").checked){
									$("nbtPolFlag").checked = false;
								}else if($("prorateSw").checked){
									$("prorateSw").checked = false;
								}							
						});
					}else{
						nextStep01();
					}					
				}catch(e){
					showErrorMessage("nextStep", e);
				}
			}
			
			if($F("endtEffDate").empty()){
				$("nbtPolFlag").checked = false;
				$("prorateSw").checked = false;
				showMessageBox("Please enter endt effectivity date.", imgMessage.ERROR);
				return false;
			}		
			
			if($("nbtPolFlag").checked || $("prorateSw").checked){
				// step 1
				new Ajax.Request(contextPath + "/GIPIPolbasicController?action=checkNewRenewals", {
					method : "POST",
					parameters : {
						parId : objUW.GIPIS031.gipiParList.parId,
						lineCd : objUW.GIPIS031.gipiWPolbas.lineCd,
						sublineCd : objUW.GIPIS031.gipiWPolbas.sublineCd,
						issCd : objUW.GIPIS031.gipiWPolbas.issCd,
						issueYy : objUW.GIPIS031.gipiWPolbas.issueYy,
						polSeqNo : objUW.GIPIS031.gipiWPolbas.polSeqNo,
						renewNo : objUW.GIPIS031.gipiWPolbas.renewNo
					},
					onComplete : function(response){
						if(checkErrorOnResponse(response)){
							if(response.responseText == "N"){
								if($("nbtPolFlag").checked){
									$("nbtPolFlag").checked = false;
								}else if($("prorateSw").checked){
									$("prorateSw").checked = false;
								}
								
								showMessageBox("Renewed policy cannot be cancelled.", imgMessage.INFO);
								return false;
							}else{
								var cancellationType = "";

								if($("endorseTax").checked){
									if($("nbtPolFlag").checked){
										$("nbtPolFlag").checked = false;
										cancellationType = "Flat Cancellation";
									}else if($("prorateSw").checked){
										$("prorateSw").checked = false;
										cancellationType = "Prorate Cancellation";
									}

									showMessageBox(cancellationType + " is not allowed for endorsement of tax.", imgMessage.ERROR);
									return false;
								}else{
									commonCancellationProcedure(nextStep);							
								}
							}
						}
					}
				});
			}else{			
				revertFlatCancellation(flatType);
			}			
		}catch(e){
			showErrorMessage("polFlagProrateSwCancellation", e);
		}
	}
	// nbtPolFlag and prorateSw process flow
	// polFlagProrateSwCancellation (true) -> commonCancellationProcedure -> nextStep -> nextStep01 -> cancellationCheckboxHandler
	//			|
	//			-(false)-> revertFlatCancellation -> cancellationCheckboxHandler
	
	/* Apollo - 5.20.2014 - endorsement must be saved first */
	$("nbtPolFlag").observe("click", function(){
		if(checkPostedBinder()){ //added edgar 10/10/2014 to check for posted binder
			showWaitingMessageBox("You cannot Tag/Untag Flat Cancellation. PAR has posted binder.", imgMessage.ERROR, 
					function(){
								$("nbtPolFlag").checked = false;
								changeTag = 0;
							  });
			return false;
		}
		if(objUW.GIPIS031.gipiWPolbas.parId == null || objUW.GIPIS031.gipiWPolbas.parId == "") {
			showWaitingMessageBox("Please save before cancellation.", "I", function(){$("nbtPolFlag").checked = false;});
		} else
			polFlagProrateSwCancellation(true);
	});
	$("prorateSw").observe("click", function(){ 
		if(checkPostedBinder()){ //added edgar 10/10/2014 to check for posted binder
			showWaitingMessageBox("You cannot Tag/Untag Prorate Cancellation. PAR has posted binder.", imgMessage.ERROR, 
					function(){
								if ($("prorateSw").checked = false){
									$("prorateSw").checked = true;
								}else if ($("prorateSw").checked = true){
									$("prorateSw").checked = false;
								} 
								changeTag = 0;
							  });
			return false;
		}
		polFlagProrateSwCancellation(false);
	});		
	
	function endtCoiCancellation(){
		try{
			if($F("endtEffDate").empty()){
				$("endtCancellation").checked = false;
				$("coiCancellation").checked = false;
				showMessageBox("Please enter endt effectivity date.", imgMessage.ERROR);
				return false;
			}
			
			if($("endtCancellation").checked || $("coiCancellation").checked){
				function step3(){
					if($F("bookingMth").empty() || $F("bookingYear").empty()){
						showMessageBox("Booking month and year is needed before performing cancellation.", imgMessage.INFO);
						$("nbtPolFlag").checked = false;
						return false;
					}					
					
					if($("endtCancellation").checked){
						objUW.GIPIS031.parameters.paramCreateNegatedRecordsEndt = "Y";
						objUW.GIPIS031.parameters.paramCreateNegatedRecordsCoi = "N";
					}else if($("coiCancellation").checked){
						objUW.GIPIS031.parameters.paramCreateNegatedRecordsCoi = "Y";
						objUW.GIPIS031.parameters.paramCreateNegatedRecordsEndt = "N";
					}
					
					// magkakalaman dahil sa create negated records procedure
					objUW.GIPIS031.gipiWItem.push({"item" : 1});
					objUW.GIPIS031.gipiWItmperl.push({"item" : 1});
					
					objUW.GIPIS031.gipiParList.parStatus = 5;
					
					$("prorateFlag").disable();
					$("compSw").disable();
					$("noOfDays").disable();
					$("shortRatePercent").disable();
					
					disableDate("hrefDoiDate");
					disableDate("hrefDoeDate");
					disableDate("hrefEndtEffDate");
					disableDate("hrefEndtExpDate");
					
					$("prorateSw").checked = false;
					$("prorateFlag").value = 2;
					$("compSw").value = "N";
					objUW.GIPIS031.gipiWPolbas.polFlag = "1";
					objUW.GIPIS031.variables.varVCnclldFlatFlag = "Y";
					$("nbtPolFlag").checked = false;					
					
					cancellationCheckboxHandler();	
					
					 
					var objParams = new Object();					
								
					objParams.gipiWPolbas	= prepareJsonAsParameter(setEndtBasicObj());
					
					// execute procedure of negating to let us know if there added records
					new Ajax.Request(contextPath + "/GIPIParInformationController?action=endtCoiCancellationTagged",{
						method : "POST",
						parameters : {
							parId : objUW.GIPIS031.gipiParList.parId,
							parameters : JSON.stringify(objParams),
							cancelType : $("endtCancellation").checked ? "ENDT" : "COI"
						},
						onComplete : function(response){
							if(checkErrorOnResponse(response)){
								var obj = JSON.parse(response.responseText.replace(/\\g/, '\\\\'));
								
								if($("endtCancellation").checked){
									objUW.GIPIS031.parameters.paramCreateNegatedRecordsEndt = "Y";
									objUW.GIPIS031.parameters.paramCreateNegatedRecordsCoi = "N";
								}else if($("coiCancellation").checked){
									objUW.GIPIS031.parameters.paramCreateNegatedRecordsCoi = "Y";
									objUW.GIPIS031.parameters.paramCreateNegatedRecordsEndt = "N";
								}
								
								objUW.GIPIS031.gipiParList.parStatus = 5;
								
								$("prorateFlag").disable();
								$("compSw").disable();
								$("noOfDays").disable();
								$("shortRatePercent").disable();
								
								disableDate("hrefDoiDate");
								disableDate("hrefDoeDate");
								disableDate("hrefEndtEffDate");
								disableDate("hrefEndtExpDate");
								
								$("prorateSw").checked = false;
								$("prorateFlag").value = 2;
								$("compSw").value = "N";
								objUW.GIPIS031.gipiWPolbas.polFlag = "1";
								objUW.GIPIS031.variables.varVCnclldFlatFlag = "Y";
								$("nbtPolFlag").checked = false;					
								
								cancellationCheckboxHandler();	
							}
						}
					});	
					
				}
				
				enableButton($("btnCancelEndt"));

				objUW.GIPIS031.parameters.paramCancelPolId = null;

				commonCancellationProcedure(step3);
			}else{
				disableButton($("btnCancelEndt"));
				objUW.GIPIS031.parameters.paramCancelPolId = null;
				
				revertFlatCancellation(true);
			}			
		}catch(e){
			showErrorMessage("endtCoiCancellation", e);
		}
	}
	
	// endtCancellation and coiCancellation process flow
	// endtCoiCancellation (true) -> commonCancellationProcedure -> step3 -> cancellationCheckboxHandler
	//			|
	//		(false)-> revertFlatCancellation -> cancellationCheckboxHandler
	$("endtCancellation").observe("click", function(){
		if(checkPostedBinder()){ //added edgar 10/10/2014 to check for posted binder
			showWaitingMessageBox("You cannot Tag/Untag Endorsement Cancellation. PAR has posted binder.", imgMessage.ERROR, 
					function(){
								if ($("endtCancellation").checked = false){
									$("endtCancellation").checked = true;
								}else if ($("endtCancellation").checked = true){
									$("endtCancellation").checked = false;
								} 
								changeTag = 0;
							  });
			return false;
		}
		endtCoiCancellation();
	});
		
	$("coiCancellation").observe("click", function(){
		if(checkPostedBinder()){ //added edgar 10/10/2014 to check for posted binder
			showWaitingMessageBox("You cannot Tag/Untag COI Cancellation. PAR has posted binder.", imgMessage.ERROR, 
					function(){
								if ($("coiCancellation").checked = false){
									$("coiCancellation").checked = true;
								}else if ($("coiCancellation").checked = true){
									$("coiCancellation").checked = false;
								} 
								changeTag = 0;
							  });
			return false;
		}
		endtCoiCancellation();
	});
	
	
	//
	// cancelEndtNextStep01 -> cancelEndtNextStep02 -> cancelEndtNextStep03
	$("btnCancelEndt").observe("click", function(){
		if(checkPostedBinder()){ //added edgar 10/10/2014 to check for posted binder
			showWaitingMessageBox("You cannot change the policy or endorsement to cancel. PAR has posted binder.", imgMessage.ERROR, 
					function(){
								changeTag = 0;
							  });
			return false;
		}
		var endtSw = "N";
		var parId = objUW.GIPIS031.gipiParList.parId;
		var lineCd = objUW.GIPIS031.gipiWPolbas.lineCd;
		var sublineCd = objUW.GIPIS031.gipiWPolbas.sublineCd;
		var issCd = objUW.GIPIS031.gipiWPolbas.issCd;
		var issueYy = objUW.GIPIS031.gipiWPolbas.issueYy;
		var polSeqNo = objUW.GIPIS031.gipiWPolbas.polSeqNo;
		var renewNo = objUW.GIPIS031.gipiWPolbas.renewNo;
		
		if ($F("globalSublineCd") == "") {//added by John Daniel to prevent endorsement cancelling before saving; may 3, 2016
			showMessageBox("Please save first before cancelling.", imgMessage.WARNING);
		}
		
		function cancelEndtNextStep03(){
			try{				
				var flag = "";
				if($("endtCancellation").checked){
					flag = "endt";
				}else if($("coiCancellation").checked){
					flag = "coi";
				}
				
				/* overlayPolicyNumber = Overlay.show(contextPath+"/GIPIParInformationController", {
					urlContent: true,
					urlParameters: {action 		: "showRecordsForCancellation",
									parId 		: parId, 
									lineCd 		: lineCd,
									issCd		: issCd,
									sublineCd	: sublineCd,
									polSeqNo	: polSeqNo,
									issueYy		: issueYy,
									renewNo		: renewNo,
									flag		: flag},
				    title: "",
				    height: 200,
				    width: 440,
				    draggable: true
				}); */
				
				showOverlayContent(contextPath+"/GIPIParInformationController?action=showRecordsForCancellation&parId=" + parId +
						"&lineCd=" + lineCd + "&sublineCd=" + sublineCd + "&issCd=" + issCd + "&issueYy=" + 
						issueYy + "&polSeqNo=" + polSeqNo + "&renewNo=" + renewNo + "&flag=" + flag,
						   "", "", (screen.width) / 4, 100, 50);
			}catch(e){
				showErrorMessage("cancelEndtNextStep03", e);
			}
		}
		
		function cancelEndtNextStep02(bypassItem){
			try{
				if(!bypassItem){
					if(objUW.GIPIS031.gipiWItem.length > 0){
						showConfirmBox("Cancellation", "Existing item(s) for this PAR would be deleted. Do you want to continue? ",
								"Ok", "Cancel",	cancelEndtNextStep03, function(){ return false; });
					}else{
						cancelEndtNextStep03();
					}
				}else{
					cancelEndtNextStep03();
				}
			}catch(e){
				showErrorMessage("cancelEndtNextStep02", e);
			}
		}
		
		function cancelEndtNextStep01(){
			try{
				if(endtSw == "N"){
					showMessageBox("There is no existing endorsement to be cancelled.", imgMessage.INFO);
					return false;
				}
				
				if(objUW.GIPIS031.gipiWItmperl.length > 0){
					showConfirmBox("Cancellation", "Existing item and perils for this PAR would be deleted. Do you want to continue? ",
							"Ok", "Cancel",	function(){ cancelEndtNextStep02(true); }, function(){ return false; });	
				}else{
					cancelEndtNextStep02(false);
				}
				
			}catch(e){
				showErrorMessage("cancelEndtNextStep01", e);
			}	
		}
		
		if(objUW.GIPIS031.variables.varVCancellationFlag == "Y"){
			showMessageBox("Only one endorsement record can be cancelled per endoresment PAR.", imgMessage.ERROR);
			return false;
		}
		
		if(objUW.GIPIS031.gipiWPolbas.polFlag == "4" && ($("endtCancellation").checked && $("coiCancellation").checked)){
			showMessageBox("Cancellation per endorsement is not allowed for PAR tagged for flat/pro-rate cancellation.", imgMessage.INFO);
			return false;
		}
		
		if($("endtCancellation").checked){			
			new Ajax.Request(contextPath + "/GIPIParInformationController?action=checkPolicyForAffectingEndtToCancel", {
				method : "GET",
				parameters : {
					parId : objUW.GIPIS031.gipiParList.parId,
					lineCd : objUW.GIPIS031.gipiWPolbas.lineCd,
					sublineCd : objUW.GIPIS031.gipiWPolbas.sublineCd,
					issCd : objUW.GIPIS031.gipiWPolbas.issCd,
					issueYy : objUW.GIPIS031.gipiWPolbas.issueYy,
					polSeqNo : objUW.GIPIS031.gipiWPolbas.polSeqNo,
					renewNo : objUW.GIPIS031.gipiWPolbas.renewNo
				},
				aysnchronous : true,
				evalScripts : true,				
				onComplete : function(response){
					if (checkErrorOnResponse(response)){													
						endtSw = response.responseText;							
						cancelEndtNextStep01();
					}
				}			
			});
		}else if($("coiCancellation").checked){
			endtSw = "Y";
			cancelEndtNextStep01();
		}
	});
	
	$("issuePlace").observe("focus", function(){
		objUW.GIPIS031.variables.varOldIssuePlace = $F("issuePlace");
	});	
	
	$("endorseTax").observe("click", function(){
		if($("endorseTax").checked){
			if($("nbtPolFlag").checked || $("prorateSw").checked){
				$("endorseTax").checked = false;
				showMessageBox("Endorsement of tax is not available for cancelling endorsement.", imgMessage.ERROR);
				return false;
			}
			
			objUW.GIPIS031.parameters.paramEndtTaxSw = "Y";
			
			if(objUW.GIPIS031.gipiWItem.filter(function(o){ return o.recFlag == "A"; }).length > 0){
				objUW.GIPIS031.parameters.paramEndtTaxSw = "X";
			}
			
			if(objUW.GIPIS031.gipiWItmperl.length > 0){
				objUW.GIPIS031.parameters.paramEndtTaxSw = "N";
				$("endorseTax").checked = false;
				showMessageBox("Cannot be tagged as endorsement of tax if there are existing perils.", imgMessage.ERROR);
				return false;				
			}
			
			objUW.GIPIS031.parameters.paramVEndt = "Y";
		}else{
			objUW.GIPIS031.parameters.paramEndtTaxSw = "X";
		}
	});
	
	//==============================================================
		
	//upon change of Provisional Premium checkbox
	$("provisionalPremium").observe("click", function(){
		if(checkPostedBinder()){ //added edgar 10/10/2014 to check for posted binder
			showWaitingMessageBox("You cannot Tag/Untag Provisional Premium. PAR has posted binder.", imgMessage.ERROR, 
					function(){
								if ($("provisionalPremium").checked = false){
									$("provisionalPremium").checked = true;
								}else if ($("provisionalPremium").checked = true){
									$("provisionalPremium").checked = false;
								} 
								changeTag = 0;
							  });
			return false;
		}
		if ($F("provisionalPremium") == 'Y') {
			$("provPremRate").show();	
			$("provPremRatePercent").focus();
				/*$("provPremRatePercent").observe("blur", function () {
					if ($F("provPremRatePercent") == ""){
						$("provPremRatePercent").focus();
						showMessageBox("Provisional Premium percent is required.", imgMessage.ERROR);
					}else if (parseFloat($F("provPremRatePercent")) < 0 || parseFloat($F('provPremRatePercent')) >  100.000000000 || isNaN(parseFloat($F('provPremRatePercent')))) {
						$("provPremRatePercent").clear();
						showMessageBox("Entered provisional premium percent is invalid. Valid value is from 0.000000000 to 100.000000000.", imgMessage.ERROR);
					}	
				});*/
		} else {
			$("provPremRate").hide();
			$("provPremRatePercent").blur();
		}
	});
	
	$("provPremRatePercent").observe("blur", function () {
		if ($F("provPremRatePercent") == ""){
			$("provPremRatePercent").focus();
			showMessageBox("Provisional Premium percent is required.", imgMessage.ERROR);
		}else if (parseFloat($F("provPremRatePercent")) < 0 || parseFloat($F('provPremRatePercent')) >  100.000000000 || isNaN(parseFloat($F('provPremRatePercent')))) {
			$("provPremRatePercent").clear();
			showMessageBox("Entered provisional premium percent is invalid. Valid value is from 0.000000000 to 100.000000000.", imgMessage.ERROR);
		}	
	});
	
	//added edgar 10/13/2014
	$("provPremRatePercent").observe("change", function () {
		if(checkPostedBinder()){ // to check for posted binder
			showWaitingMessageBox("You cannot change Provisional Premium Percentage. PAR has posted binder.", imgMessage.ERROR, 
					function(){
								$("provPremRatePercent").value = prevprovPremRate;
								changeTag = 0;
							  });
			return false;
		}
	});
	
	$("provPremRatePercent").observe("focus", function () {
		prevprovPremRate = $("provPremRatePercent").value;
	});
	//ended edgar 10/13/2014
	
	//for search button in In Account Of
	$("osaoDate").observe("click", function()	{
		showInAccountOf(); //robert
		//openSearchAccountOf();
		//var assdNo = $("assuredNo").value;
		//var keyword = $("inAccountOf").value;
		//openSearchAccountOf2(assdNo,keyword);
	});

	//for search button in Assured Name
	$("oscmDate").observe("click", function ()	{
		if(checkPostedBinder()){ // to check for posted binder edgar 10/13/2014
			showWaitingMessageBox("You cannot change the Assured. PAR has posted binder.", imgMessage.ERROR, 
					function(){
								changeTag = 0;
							  });
			return false;
		}
		//openSearchClientModal();
		showValidAssuredListingTG($F("assuredNo"));  // robert 
	});	
	
	$("inAccountOf").observe("blur", function () {
		if ($("inAccountOf").value == "") {
			$("acctOfCd").value = "";
		}	
	});		

	$("inAccountOf").observe("keyup", function (event) {
		if(event.keyCode == 46){
			$("inAccountOf").clear();
			$("acctOfCd").clear();
		}
	});	
	
	if(objUW.hidObjGIPIS002.updCredBranch != "Y"){
		if ($("creditingBranch").value != ""){
			$("creditingBranch").disable();
		}
	}
	
	if(objUW.hidObjGIPIS002.reqCredBranch == "Y"){
		/* Apollo 07.24.2015 SR# 2749
		Crediting Branch must be required regardless of the value of DEFAULT_CRED_BRANCH when MANDATORY_CRED_BRANCH = Y */
		//if (objUW.hidObjGIPIS002.defCredBranch == "ISS_CD"){
			$("creditingBranch").addClassName("required");
		//}	
	}
	
	if(objUW.hidObjGIPIS002.reqRefPolNo == "Y"){
		$("referencePolicyNo").addClassName("required");
	}
	
	//added by gab 11.17.2016 SR 3147,3027,2645,2681,3148,3206,3264,3010
	if(objUW.hidObjGIPIS002.reqRefNo == "Y"){
		$("nbtAcctIssCd").addClassName("required");
		$("nbtBranchCd").addClassName("required");
		$("dspRefNo").addClassName("required");
		$("dspModNo").addClassName("required");
	}

	function showEditPolicyNo() {
		try{			
			
			objUW.GIPIS031.variables.varOldLineCd = objUW.GIPIS031.gipiWPolbas.lineCd;
			objUW.GIPIS031.variables.varOldSublineCd = objUW.GIPIS031.gipiWPolbas.sublineCd;
			objUW.GIPIS031.variables.varOldIssCd = objUW.GIPIS031.gipiWPolbas.issCd;
			objUW.GIPIS031.variables.varOldIssueYy = objUW.GIPIS031.gipiWPolbas.issueYy;
			objUW.GIPIS031.variables.varOldPolSeqNo = objUW.GIPIS031.gipiWPolbas.polSeqNo;
			objUW.GIPIS031.variables.varOldRenewNo = objUW.GIPIS031.gipiWPolbas.renewNo;
			
			//var controller = "GIPIParInformationController";
			//var action = "showEditPolicyNo";

			//var parId 		= objUW.GIPIS031.gipiWPolbas.parId;
			//var lineCd 		= objUW.GIPIS031.gipiWPolbas.lineCd;
			//var sublineCd 	= objUW.GIPIS031.gipiWPolbas.sublineCd;
			//var issCd 		= objUW.GIPIS031.gipiWPolbas.issCd;
			//var issueYy 	= objUW.GIPIS031.gipiWPolbas.issueYy;
			//var polSeqNo 	= objUW.GIPIS031.gipiWPolbas.polSeqNo;			
			//var renewNo 	= objUW.GIPIS031.gipiWPolbas.renewNo;			
			
			//showOverlayContent2(contextPath+"/"+controller+"?action="+action+"&parId="+parId+"&lineCd="
			//		+lineCd+"&issCd="+issCd+"&sublineCd="+sublineCd+"&polSeqNo="+polSeqNo+"&issueYy="+issueYy+"&renewNo="+renewNo,
			//			   "Policy No.", 490, overlayOnComplete);
			overlayPolicyNumber = Overlay.show(contextPath+"/GIPIParInformationController", {
				urlContent: true,
				urlParameters: {action : "showPolicyNo",
								parId : objUW.GIPIS031.gipiParList.parId,
								lineCd : objUW.GIPIS031.gipiWPolbas.lineCd,
								sublineCd : objUW.GIPIS031.gipiWPolbas.sublineCd,
								issCd : objUW.GIPIS031.gipiWPolbas.issCd,
								issueYy : objUW.GIPIS031.gipiWPolbas.issueYy,
								polSeqNo : objUW.GIPIS031.gipiWPolbas.polSeqNo,
								renewNo : objUW.GIPIS031.gipiWPolbas.renewNo,
								oldPolicyNo : objUW.GIPIS031.gipiParList.parStatus > 2 ? $("policyNo").value : ""
				},
			    title: "Policy Number",
			    height: 100,
			    width: 440,
			    draggable: true
			});
		}catch(e){
			showErrorMessage("showEditPolicyNo", e);
		}	
	}
	
	$("btnEditPolicyNo").observe("click",function(){
		if(checkPostedBinder()){ //added edgar 10/10/2014 to check for posted binder
			showWaitingMessageBox("You cannot change the policy to endorse. PAR has posted binder.", imgMessage.ERROR, 
					function(){
								changeTag = 0;
							  });
			return false;
		}
		showEditPolicyNo();
	});

	$("endorseTax").checked = (nvl($("isPack"), "N") == "N") ? (objUW.GIPIS031.gipiWEndtText.endtTax == "Y" ? true : false) : (nvl($F("b360EndtTax"), "N") == "Y") ? true : false;
	
	//for Leased tag label
	$("labelTag").observe("click", function() {
		if ($("labelTag").checked) {
			$("rowInAccountOf").innerHTML = "Leased to";
		} else {
			$("rowInAccountOf").innerHTML = "In Account Of";
		}
	});
	
	// andrew - 05.14.2012 - based on B540 - POST-QUERY trigger
	if("${gipiWPolbas.cancelType}" == 1){
		$("nbtPolFlag").checked = true;
	} else if("${gipiWPolbas.cancelType}" == 2){
		$("prorateSw").checked = true;
	} 
	
	if("${gipiWPolbas.polFlag}" == 4){
		if("${gipiWPolbas.prorateFlag}" == 2){
			$("prorateSw").checked = false;
			$("nbtPolFlag").checked = true;
		} else {
			$("prorateSw").checked = true;
			$("nbtPolFlag").checked = false;
		}
	} else {
		$("nbtPolFlag").checked = false;
		$("prorateSw").checked = false;
		if("${gipiWPolbas.cancelType}" == 1){
			$("nbtPolFlag").checked = true;
		} else if("${gipiWPolbas.cancelType}" == 2){
			$("prorateSw").checked = true;
		}
	}
	// end andrew
	
	if("${updIssueDate}" != "Y"){
		disableDate("hrefIssueDate");
	}
	
	//robert 06-13-2012
	function showValidAssuredListingTG(assuredNo){
		try{
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGIISAssuredLOVTG",
					page : 1
				},
				title: "Valid Names of Assured",
				width : 600,
				height : 404,
				columnModel : [
				               {
				            	   id : "assdName",
				            	   title : "Assured Names",
				            	   width : '350px'
				               },
								{
								   id : "assdNo",
								   title : "Assured No.",
								   width : '120px',
								   titleAlign: 'right',
								   align : 'right'
								},
				               {
				            	   id : "mailAddress1",
				            	   title : "Mail Address1",
				            	   width : '300px'
				               },
				               {
				            	   id : "mailAddress2",
				            	   title : "Mail Address2",
				            	   width : '300px',
					           	   sortable: false
				               },
				               {
				            	   id : "mailAddress3",
				            	   title : "Mail Address3",
				            	   width : '300px',
					           	   sortable: false
				               }
				               
				              ],
				draggable : true,
				onSelect : function(row){
					if(row != undefined){
						function onOk(){
							$("assuredNo").value = row.assdNo;
							$("assuredName").value = unescapeHTML2(row.assdName);
							$("address1").value = unescapeHTML2(row.mailAddress1);
							$("address2").value = unescapeHTML2(row.mailAddress2);
							$("address3").value =unescapeHTML2(row. mailAddress3);
							if ($("industry")) $("industry").value = nvl(row.industryCd,"");
							changeTag = "1"; 
							$("assuredName").focus();
						}
						if(row.assdNo != assuredNo){
							if (objUW.hidObjGIPIS002.gipiWInvoiceExist == "1" || objUW.GIPIS031.gipiWItmperl.size() > 0){ //added condition by June Mark SR5809 [11.11.16]
								showConfirmBox("Confirmation", "Change of Assured will automatically recreate invoice and delete corresponding data on group information both ITEM and GROUP level. Do you wish to continue?",
										"Yes", "No", onOk, "");
								objUW.GIPIS031.parameters.assuredChange = "Y";
							}else{
								onOk();
							} //end SR5809
						}else{
							onOk();
						}
					}				
				}
			});
		}catch(e){
			showErrorMessage("showValidAssuredListingTG", e);
		}
	}

	function showInAccountOf(){
		try{
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGIISAssuredLOVTG",
					page : 1
				},
				title: "In Account Of",
				width : 539,
				height : 386,
				columnModel : [
				               {
				            	   id : "assdName",
				            	   title : "Assured Names",
				            	   width : '404px'
				               },
								{
								   id : "assdNo",
								   title : "Assured No.",
								   width : '120px',
								   titleAlign: 'right',
								   align : 'right'
								}
				              ],
				draggable : true,
				onSelect : function(row){
					if(row != undefined){
						$("acctOfCd").value = row.assdNo;
						$('inAccountOf').value = unescapeHTML2(row.assdName);
						changeTag = 1;
						$("inAccountOf").focus();
					}				
				}
			});
		}catch(e){
			showErrorMessage("showInAccountOf", e);
		}
	} //end robert
	
	cancellationCheckboxHandler(); //robert 9.28.2012
	
	// bonok :: 12.18.2012 
	if(objUW.GIPIS031.gipiWPolbas.labelTag == "Y"){
		$("labelTag").checked = true;	
		$("rowInAccountOf").innerHTML = "Leased to"; // added by Kris 04.11.2014
	}else if(objUW.GIPIS031.gipiWPolbas.labelTag == "N"){
		$("deleteSw").checked = true;
	}else if(objUW.GIPIS031.gipiWPolbas.labelTag == "N" || objUW.GIPIS031.gipiWPolbas.labelTag == null){
		$("deleteSw").checked = false;
		$("labelTag").checked = false;
	}
	// christian 03/9/2013
	if($("prorateSw").checked){
		$("prorateFlag").options[1].hide();
		$("prorateFlag").options[1].disable = true;
	}
	
	// Kris 07.04.2013 for UW-SPECS-2013-091
	// to display the default crediting branch if the current crediting branch is inactive. if the default is also inactive, crediting branch is null.
	if($("creditingBranch").value == "" && objUW.hidObjGIPIS002.dispDefaultCredBranch == "Y"){
		if(objUW.hidObjGIPIS002.defaultCredBranch == "ISS_CD"){
			$("creditingBranch").value = objUW.GIPIS031.gipiWPolbas.issCd;	
		}
	}
	
	//added edgar 10/10/2014 to check for posted binders
	function checkPostedBinder(){ 
		var vExists = false;	
		new Ajax.Request(contextPath+"/GIPIWinvoiceController",{
				parameters:{
					action: "checkForPostedBinders",
					parId : objUW.GIPIS031.gipiParList.parId
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if (checkErrorOnResponse(response)){
						if(response.responseText == 'Y'){
							vExists = true;
						}else {
							vExists = false;
						}
					}
				}
			});
		return vExists;
	}
}catch(e){
	showErrorMessage("Endt Basic Info Page", e);
}
</script>