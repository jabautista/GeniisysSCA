<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> <!-- Deo [01.03.2017]: (SR-23567) -->
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
   		<label>Bond Basic Information</label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label name="gro" style="margin-left: 5px;">Hide</label>
	   		<label id="reloadForm" name="reloadForm">Reload Form</label>
   		</span>
   	</div>
</div>
<div class="sectionDiv" id="bondBasicInformationDivOuter" style="float:left;">
	<div id="bondBasicInformationDiv" style="float:left; width: 50%; height: 300px; margin-top:10px;">
		<table align="center" cellspacing="1" border="0" width="100%">
 			<tr>
				<td class="rightAligned" style="width: 108px;">PAR No. </td>
				<td class="leftAligned" style="width: 200px;"><input style="width: 220px; " id="parNo" name="parNo" type="text" value="${gipiParList.parNo }" readonly="readonly" class="required"/></td>	
			</tr>
			<tr>
				<td class="rightAligned">Bond Type </td>
			    <td class="leftAligned">
			    	<input type="hidden" id="paramSubline" name="paramSubline" value="${gipiWPolbas.sublineCd }" />
					<select id="sublineCd" name="sublineCd" style="width: 228px;" class="required">
						<option value=""></option>
						<c:forEach var="s" items="${sublineListing}">
							<!-- Deo [01.03.2017]: added fn:replace (SR-23567) -->
							<option value="${s.sublineCd}"
							<c:if test="${fn:replace(gipiWPolbas.sublineCd, '&#38;', '&') eq s.sublineCd}">
									selected="selected"
							</c:if>
							>${s.sublineCd} - ${s.sublineName}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>	
				<td class="rightAligned">Bond Status</td>
			    <td class="leftAligned">
			    	<input type="hidden" id="paramPolicyStatus" name="paramPolicyStatus" value="${gipiWPolbas.polFlag }" class="required"/>
					<select id="policyStatus" name="policyStatus" style="width: 228px;" >
						<option value="1" >New policy</option>
						<option value="2" >Renewal policy</option>
						<option value="3" >Replaced policy</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Manual Renew No. </td>
				<td class="leftAligned">
					<div style="width: 229px">
						<input style="width: 220px; text-align:center;" id="manualRenewNo" name="manualRenewNo" type="text" value="${gipiWPolbas.manualRenewNo }" maxlength="2" class="required integerNoNegativeUnformattedNoComma" errorMsg="Entered manual renew no. is invalid. Valid value is from 00 to 99."/>
						<input type="hidden" id="renewNo" name="renewNo" value="${gipiWPolbas.renewNo }<c:if test="${empty gipiWPolbas.renewNo}">0</c:if>" maxlength="2" />
						<input type="hidden" id="paramRenewNo" name="paramRenewNo" value="${gipiWPolbas.renewNo }<c:if test="${empty gipiWPolbas.renewNo}">0</c:if>" maxlength="2" />
						
						<span class="rightAligned" id="lblBondSeqNo" style="display: none; width: 144px" >Bond No.</span>
						<select id="selBondSeqNo" name="selBondSeqNo" style="width: 84px; display: none" class="required">
							<option value=""></option>
						</select>
					</div>
				</td>	
			</tr>
			<tr>
				<td class="rightAligned">Reference Bond No. </td>
				<td class="leftAligned">
					<input style="width: 220px;" id="referencePolicyNo" name="referencePolicyNo" type="text" value="${gipiWPolbas.refPolNo }" maxlength="30" />
				</td>
			</tr>	
			<tr>
				<td class="rightAligned">Address </td>
				<td class="leftAligned">
					<input style="width: 220px;" id="address1" name="address1" type="text" value="${gipiWPolbas.address1}" maxlength="50" />
				</td>	
			</tr>
			<tr>	
				<td>&nbsp;</td>
				<td class="leftAligned">
					<input style="width: 220px;" id="address2" name="address2" type="text" value="${gipiWPolbas.address2}" maxlength="50" />
				</td>	
			</tr>
			<tr>
				<td>&nbsp;</td>	
				<td class="leftAligned">
					<input style="width: 220px;" id="address3" name="address3" type="text" value="${gipiWPolbas.address3}" maxlength="50" />
				</td>	
			</tr>
			<tr>	
				<td class="rightAligned">Booking Date </td>
				<td class="leftAligned">
					<div>
						<div style="float:left; margin-right:2px;">
							<input type="hidden" id="paramBookingYear" name="paramBookingYear" style="width:35px; height:15px;" value="${gipiWPolbas.bookingYear }" maxlength="4" />
							<input type="hidden" id="paramBookingMth" name="paramBookingYear" style="width:35px; height:15px;" value="${gipiWPolbas.bookingMth }" />
							<input type="hidden" id="bookingYear" name="bookingYear" style="width:35px; height:15px;" value="${gipiWPolbas.bookingYear }" maxlength="4" />
							<input type="hidden" id="bookingMth" name="bookingMth" style="width:35px; height:15px;" value="${gipiWPolbas.bookingMth }" />
						</div>
						<div style="float:left;">
							<input type="hidden" id="bookingDateExist" name="bookingDateExist" value="
							<c:forEach var="d" items="${bookingMonthListing}">
							<c:if test="${gipiWPolbas.bookingYear == d.bookingYear and gipiWPolbas.bookingMth == d.bookingMonth}">
										1
							</c:if>
							</c:forEach>
							" />
							<select id="bookingMonth" name="bookingMonth" style="width: 228px;" class="required">
							<option bookingYear="" bookingMth="" value=""></option>
							<option id="opt2" bookingYear="${gipiWPolbas.bookingYear }" bookingMth="${gipiWPolbas.bookingMth }" value="${gipiWPolbas.bookingMth }" selected="selected" ><c:if test="${!empty gipiWPolbas.bookingYear }">${gipiWPolbas.bookingYear } - ${gipiWPolbas.bookingMth }</c:if></option>
							<c:forEach var="d" items="${bookingMonthListing}">
								<option bookingYear="${d.bookingYear  }" bookingMth="${d.bookingMonth}" value="${d.bookingMonthNum}" 
								<c:if test="${gipiWPolbas.bookingYear == d.bookingYear and gipiWPolbas.bookingMth == d.bookingMonth}">
										selected="selected"
								</c:if>
								>${d.bookingYear  } - ${d.bookingMonth}</option>
							</c:forEach>
							</select>
						</div>
					</div>
				</td>
			</tr>
			<tr>	
				<td class="rightAligned">Take-up Term Type </td>
				<td class="leftAligned">
					<input type="hidden" id="paramTakeupTermType" name="paramTakeupTermType" value="${gipiWPolbas.takeupTerm }" />
					<select id="takeupTermType" name="takeupTermType" style="width: 228px;" >
					<c:forEach var="t" items="${takeupTermListing}">
							<option value="${t.takeupTerm}" 
							<c:if test="${gipiWPolbas.takeupTerm == t.takeupTerm}">
									selected="selected"
							</c:if>
							>${t.takeupTermDesc}</option>
					</c:forEach>
					</select>
				</td>
			</tr>
			<!-- added by robert GENQA SR 4825 08.03.15 -->
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
			<tr>	
				<td class="rightAligned">Crediting Branch </td>
			    <td class="leftAligned">
					<select id="creditingBranch" name="creditingBranch" style="width: 228px;" >
						<option value=""></option><!-- blank option added by: Nica 08.15.2012 -->
						<c:forEach var="creditingBranchListing" items="${branchSourceListing}">
							<option value="${creditingBranchListing.issCd}"
							<c:if test="${gipiWPolbas.credBranch eq creditingBranchListing.issCd}">
								selected="selected"
							</c:if>>${creditingBranchListing.issName}</option>				
						</c:forEach>
					</select>
				</td>
			</tr>
			<!-- end robert GENQA SR 4825 08.03.15 -->
		</table>
	</div>
	
	<div id="bondBasicInformation" style="float:left; width:50%; margin-top:10px; margin-bottom:15px;">
		<table align="left" cellspacing="1" border="0" width="100%">
			<tr>
				<td class="rightAligned" style="width: 33%;">Principal </td>
				<td class="leftAligned">
					<!-- <input id="oscm" name="oscm" class="button" type="button" value="Search" />  -->
					<div style="border: 1px solid gray; width: 226px; height: 21px; float: left;" class="required">
						<input style="width: 200px; border: none; " id="assuredName" name="assuredName" type="text" value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.dspAssdName}</c:if>" readonly="readonly" class="required" />
						<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmDate" name="oscmDate" alt="Go" />
					</div>
					<input id="assuredNo" name="assuredNo" type="hidden" value="${gipiWPolbas.assdNo}" />
					<input id="paramAssuredNo" name="paramAssuredNo" type="hidden" value="${gipiWPolbas.assdNo}" />
					<input style="width: 200px;" id="paramAssuredName" name="paramAssuredName" type="hidden" value="${gipiWPolbas.dspAssdName}" readonly="readonly" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 22%;">Inception Date </td>
			   	<td class="leftAligned">
			    	<div style="float:left; border: solid 1px gray; width: 226px; height: 21px; margin-right:3px;" class="required">
			    		<input style="width: 198px; border: none;" id="paramDoi" name="paramDoi" type="hidden" value="<fmt:formatDate value="${gipiWPolbas.inceptDate }" pattern="MM-dd-yyyy" />" readonly="readonly"/>
			    		<input style="width: 198px; border: none;" id="doi" name="doi" type="text" value="<fmt:formatDate value="${gipiWPolbas.inceptDate }" pattern="MM-dd-yyyy" />" readonly="readonly" class="required"/>
			    		<img id="hrefDoiDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('doi'),this, null);" alt="Inception Date" />
					</div>
			    	<input type="checkbox" id="inceptTag" name="inceptTag" value="Y" 
			    	<c:if test="${gipiWPolbas.inceptTag == 'Y' }">
							checked="checked"
					</c:if>/> TBA
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 30%;">Expiry Date </td>
				<td class="leftAligned">
			    	<div style="float:left; border: solid 1px gray; width: 226px; height: 21px; margin-right:3px;" class="required">
			    	    <input style="width: 198px; border: none;" id="defaultDoe" name="defaultDoe" type="hidden" value="<fmt:formatDate value="${gipiWPolbas.expiryDate }" pattern="MM-dd-yyyy" />" readonly="readonly" class="required"/> <!-- added by robert GENQA SR 4825 08.03.15 -->
			    		<input style="width: 198px; border: none;" id="paramDoe" name="paramDoe" type="hidden" value="<fmt:formatDate value="${gipiWPolbas.expiryDate }" pattern="MM-dd-yyyy" />" readonly="readonly" class="required"/>
			    		<input style="width: 198px; border: none;" id="doe" name="doe" type="text" value="<fmt:formatDate value="${gipiWPolbas.expiryDate }" pattern="MM-dd-yyyy" />" readonly="readonly" triggerChange="Y" class="required"/>
			    		<img id="hrefDoeDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('doe'),this, null);" alt="Expiry Date" />
			    	</div>
		    		<input type="checkbox" id="expiryTag" name="expiryTag" value="Y"
		    		<c:if test="${gipiWPolbas.expiryTag == 'Y' }">
							checked="checked"
					</c:if>/> TBA
		    	</td>
			</tr>
			<tr>
				<td class="rightAligned">Issue Date </td>
			    <td class="leftAligned">
			    	<div style="border: solid 1px gray; width: 226px; height: 21px; " class="required">
			    		<input style="width: 198px; border: none;" id="issueDate" name="issueDate" type="text" value="<fmt:formatDate value="${gipiWPolbas.issueDate}" pattern="MM-dd-yyyy" />" readonly="readonly" class="required"/>
			    		<img id="hrefIssueDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Issue Date"
				    	<c:if test="${updIssueDate eq 'Y'}">
							onClick="scwShow($('issueDate'),this, null);"
						</c:if>
						/>
			    	</div>
				</td>
			</tr>
			<!-- <tr>
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
			 -->
			<tr>	
				<td class="rightAligned">Mortgagee </td>
			    <td class="leftAligned">
					<div><input style="width: 220px; float:left;" id="mortgCd" name="mortgCd" type="hidden" value="" maxlength="50" readonly="readonly"/>
					<input style="width: 220px; float:left;" id="mortG" name="mortG" type="text" value="${gipiWPolbas.mortgName}" maxlength="50" readonly="readonly"/></div>
					<img style="float:left; margin-left:2px;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="mortgDate" name="mortgDate" alt="Go" />
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
			<!-- added by robert GENQA SR 4825 08.03.15 -->
			<tr>	
				<td class="rightAligned">Condition </td>
				<td class="leftAligned">
					<input type="hidden" id="paramProrateFlag" name="paramProrateFlag" value="${gipiWPolbas.prorateFlag }" />
					<select id="prorateFlag" name="prorateFlag" style="width: 228px; float: left;" class="required">
							<option value="1" <c:if test="${gipiWPolbas.prorateFlag eq 1}">selected="selected"</c:if> >Pro-rate</option>
							<option value="2" <c:if test="${gipiWPolbas.prorateFlag eq 2 or empty gipiWPolbas.prorateFlag}">selected="selected"</c:if> >Straight</option>
							<option value="3" <c:if test="${gipiWPolbas.prorateFlag eq 3}">selected="selected"</c:if> >Short Rate</option>
					</select>			
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="height: 23px;"> </td>
				<td class="leftAligned">
					<span id="prorateSelected" name="prorateSelected" style="display: none;  float: left;">
						<input type="hidden" style="width: 37px;" id="paramNoOfDays" name="paramNoOfDays" value="" />
						<input type="hidden" style="width: 37px;" id="paramNoOfDays2" name="paramNoOfDays2" value="" />
						<input class="required integerNoNegativeUnformattedNoComma" type="text" style="width: 37px;  float: left; margin-right:2px; margin-top: 0px;" id="noOfDays2" name="noOfDays2" value="" readonly="readonly"/> 
						<select class="required" id="compSw" name="compSw" style="width: 80px; float: left; margin-top: 0px;" >
							<option value="Y" <c:if test="${gipiWPolbas.compSw eq 'Y'}">selected="selected"</c:if> >+1 day</option>
							<option value="M" <c:if test="${gipiWPolbas.compSw eq 'M'}">selected="selected"</c:if> >-1 day</option>
							<option value="N" <c:if test="${gipiWPolbas.compSw eq 'N' or empty gipiWPolbas.compSw}">selected="selected"</c:if> >Ordinary</option>
						</select>
					</span>
					<span id="shortRateSelected" name="shortRateSelected" style="display: none;">
					    <input type="hidden" id="paramShortRatePercent" name="paramShortRatePercent" class="moneyRate" style="width: 90px;" maxlength="13" value="${gipiWPolbas.shortRtPercent }" />
						<input type="text" id="shortRatePercent" name="shortRatePercent" class="moneyRate required" style="width: 90px;  float: left; margin-top: 0px;" maxlength="13" value="${gipiWPolbas.shortRtPercent }" oldShortRatePercent="${gipiWPolbas.shortRtPercent}"/>
					</span>	
				</td>
			</tr>
			<%-- <tr>	
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
			<tr>	
				<td class="rightAligned">Crediting Branch </td>
			    <td class="leftAligned">
					<select id="creditingBranch" name="creditingBranch" style="width: 228px;" >
						<option value=""></option><!-- blank option added by: Nica 08.15.2012 -->
						<c:forEach var="creditingBranchListing" items="${branchSourceListing}">
							<option value="${creditingBranchListing.issCd}"
							<c:if test="${gipiWPolbas.credBranch eq creditingBranchListing.issCd}">
								selected="selected"
							</c:if>>${creditingBranchListing.issName}</option>				
						</c:forEach>
					</select>
				</td>
			</tr> 
			end robert GENQA SR 4825 08.03.15 -->--%>
			<tr>
				<td colspan="2">
				<div style="margin:10px;">
					<div id="validityPeriodDiv1" style="width:50%; float:left; margin-left:25%; margin-bottom:2px;">
						<font style="float:left;">Validity Period </font>
					</div>
					<div id="validityPeriodDiv" style="width:50%; float:left; margin-left:25%; border:1px solid grey; margin-bottom:4px;" >
						<div style="margin:12px;">
						<input type="text" style="width: 25%; float:left; " id="noOfDays" name="noOfDays" value="" maxlength="7" class="integerNoNegativeUnformattedNoComma" errorMsg="Entered validity period is invalid. Valid value is from 0 to 9999999."/>
						<input type="hidden" id="paramValidateTag" name="paramValidateTag" value="${gipiWPolbas.validateTag}" /> <!-- added by robert GENQA SR 4825 08.12.15 -->
						<select id="validateTag" name="validateTag" style="width:70%; height:21px; margin-top:2px;" >
							<option value="D">Days</option>
							<option value="M">Months</option>
							<option value="Y">Years</option>
						</select>
						</div>
					</div>
				</div>	
				</td>
			</tr>
		</table>
		<table align="left" cellspacing="1" border="0" >
			<tr>
				<td class="rightAligned" style="width:80px;"><input type="checkbox" id="autoRenewFlag" name="autoRenewFlag" value="Y" 
					<c:if test="${gipiWPolbas.autoRenewFlag eq 'Y' }">checked="checked"</c:if>/>
				</td>
				<td class="leftAligned" style="width:97px;">
					<label class="rightAligned">Continuing Bond</label>
				</td>
				<td class="rightAligned" style="width:80px;"><input type="checkbox" id="regPolicySw" name="regPolicySw" value="Y" 
					<c:if test="${gipiWPolbas.regPolicySw eq 'Y' }">checked="checked"</c:if>/>
				</td>
				<td class="rightAligned" style="width:80px;">
					Regular Bond
				</td>
			</tr>
			<c:if test="${ora2010Sw eq 'Y'}">
			<tr>	
				<td class="rightAligned" style="width:80px;"><input type="checkbox" id="bancaTag" name="bancaTag" value="Y" <c:if test="${gipiWPolbas.bancassuranceSw eq 'Y'}">checked="checked"</c:if> originalValue="${gipiWPolbas.bancassuranceSw}" /></td>
				<td class="leftAligned" style="width:97px;">
					<label class="rightAligned">Bancassurance</label>
				</td>
				<td class="rightAligned" style="width:80px;" colspan="2">
					<input type="button" class="button noChangeTagAttr" id="btnBancaDetails" name="btnBancaDetails" value="Bancassurance Details" />
				</td>
			</tr>
			</c:if>
		</table>
	</div>
</div>
<div class="sectionDiv" id="OldBondBasicInformationDivOuter" style="float:left;">
	<div id="oldBondBasicInformation" name="oldBondBasicInformation" style="width:50%; margin-left:25%; margin-top:10px; margin-bottom:15px;">
		<c:forEach var="wPolnrep" items="${gipiWPolnrep}" begin="0" end="0">
			<div id="rowOldBondNo${wPolnrep.oldPolicyId}" name="rowOldBondNo">
				<table width="100%" cellspacing="1" border="0" >
					<tr>
						<td class="rightAligned" width="20%">Old Bond No.</td>
						<td>
							<input type="hidden" name="renRepSw" 		id="renRepSw" 		value="${wPolnrep.renRepSw }" />
							<input type="hidden" name="oldPolicyId" 	id="oldPolicyId" 	value="${wPolnrep.oldPolicyId }" />
							<input type="hidden" name="recFlag" 		id="recFlag" 		value="${wPolnrep.recFlag }" />
							<input type="hidden" id="wpolnrepOldPolicyId" name="wpolnrepOldPolicyId" value="${wPolnrep.oldPolicyId }" />
							<input type="text" style="width: 84%;"   id="wpolnrepLineCd"   	name="wpolnrepLineCd"    readonly="readonly" value="${gipiParList.lineCd}" class="required"/>
						</td>
						<td><input type="text" style="width: 88%;" 	id="wpolnrepSublineCd" 	name="wpolnrepSublineCd" readonly="readonly" value="${wPolnrep.sublineCd}" class="required"/></td>
						<td><input type="text" style="width: 84%; text-transform: uppercase;" 	id="wpolnrepIssCd"		name="wpolnrepIssCd" maxlength="3" value="${wPolnrep.issCd}" class="required"/></td>
						<td><input type="text" style="width: 84%; text-align: right;"		id="wpolnrepIssueYy"	name="wpolnrepIssueYy"  maxlength="2" value="${wPolnrep.issueYy}" class="required integerNoNegativeUnformattedNoComma deleteInvalidInput" errorMsg="Invalid Issuing Year. Value should be from 0 to 99." /></td>
						<td><input type="text" style="width: 88%; text-align: right;"		id="wpolnrepPolSeqNo"	name="wpolnrepPolSeqNo" maxlength="7" value="${wPolnrep.polSeqNo}" class="required  integerNoNegativeUnformattedNoComma deleteInvalidInput" errorMsg="Invalid Policy Sequence No. Value should be from 0 to 9999999." /></td>
						<td><input type="text" style="width: 84%; text-align: right;"		id="wpolnrepRenewNo"	name="wpolnrepRenewNo"  maxlength="2" value="${wPolnrep.renewNo}" class="required  integerNoNegativeUnformattedNoComma deleteInvalidInput" errorMsg="Invalid Renew No. Value should be from 0 to 99." /></td>			
					</tr>
					<tr>
						<td></td>
						<td colspan="7">
							<label style="margin-right: 5px;"><input type="checkbox" id="samePolnoSw" name="samePolnoSw" value="Y" class="rightAligned" title="Same Bond No." 
								<c:if test="${gipiWPolbas.samePolnoSw eq 'Y' }">
									checked="checked"
								</c:if>/></label>
							<label class="rightAligned">Same Bond No.</label>
						</td>
					</tr>
				</table>
			</div>	
		</c:forEach>
	</div>	
</div>	
<c:if test="${ora2010Sw eq 'Y'}">
	<jsp:include page="bankPaymentDetails.jsp"></jsp:include>
	<jsp:include page="bancaDtls.jsp"></jsp:include>
</c:if>	
<script type="text/JavaScript">
	var today = dateFormat(serverDate, "mm-dd-yyyy");
	var paramForOldBond = "";
	var oldBondSeqNo = null;
	var oldBondType = "${gipiWPolbas.sublineCd}";
	var prevProrate; // added by robert GENQA SR 4825 08.03.15
	
	initializeBondSequence();
	
	// Kris 07.04.2013 for UW-SPECS-2013-091
	if($("creditingBranch").value == "" && objUW.hidObjGIPIS017.dispDefaultCredBranch == "Y" && nvl(objUWParList.polFlag,null) == null){ //added by steven 10.13.2014 "objUWParList.polFlag"
		if(objUW.hidObjGIPIS017.defaultCredBranch == "ISS_CD"){
			$("creditingBranch").value = "${gipiParList.issCd}"; //objUW.GIPIS031.gipiWPolbas.issCd;	
		}
	}
	
	$("oscmDate").observe("click", function ()	{
		//openSearchClientModal();
		showAssuredListingTG($F("lineCd"));
	});
	
	var doi = $("doi").value;
	$("hrefDoeDate").observe("click", function () {
		if ($("doi").value == ""){
			$("doi").focus();
		}	
	});

	observeChangeTagOnDate("hrefDoeDate", "doe");
	observeChangeTagOnDate("hrefDoiDate", "doi");
	
	$("hrefDoiDate").observe("click", function () {
		doi = $("doi").value;
	});

	$("manualRenewNo").observe("blur", function () {
		$("manualRenewNo").value = $F("manualRenewNo").replace(/,/g, "");
		if ($F("manualRenewNo") != ""){
			$("manualRenewNo").value = formatNumberDigits($F("manualRenewNo"),2);
			//getBookingDate(); commented by: Nica 05.09.2012 - no longer needed to refresh booking_month when manual_renew_no is changed
		}
	});

	function getIssueYyBondBasic(){
		try{
			new Ajax.Updater("message", contextPath+'/GIPIParInformationController?action=getIssueYy', {
				method: "POST",
				postBody: Form.serialize("bondBasicInformationForm"),
				asynchronous: true,
				evalScripts: true,
				onCreate: function() {
					$("bondBasicInformationFormButton").disable();
				},
				onComplete: function (response)	{
					$("bondBasicInformationFormButton").enable();
					if (checkErrorOnResponse(response)) {
						if (response.responseText == "Y"){
							showMessageBox("Invalid param_value_v for parameter name POL_ISSUE_YY. Please contact your DBA.", imgMessage.ERROR);
						} else {
							$("issueYy").value = response.responseText; 
						}			
						hideNotice("");
					}
				}
			});
		}catch(e){
			showErrorMessage("getIssueYyBondBasic",e);
		}	
	}	
	
	$("doi").observe("blur", function () {
		if ($("doi").value != $("paramDoi").value){
			if (!checkParPostedBinder("inception date")){	// shan 10.14.2014
				$("doi").value = $("paramDoi").value;
				return false;
			}
			if ($("doi").value != doi){
				defaultExpiryDate();
				defaultDOE(); // added by robert GENQA SR 4825 08.03.15
				computeNoOfDays();
				getBookingDate();
			}
			//getBookingDate();
			$("updateIssueDate").value = "Y"; 
		} 
		if ($F("doi") != ""){
			if (($F("issueYy") == null)||($F("issueYy") == "")) {
				getIssueYyBondBasic();
			}	
			$("noOfDays").focus();	
		}	
		// added by robert GENQA SR 4825 08.03.15
		if ($F("paramDoi") != $F("doi")) {
			if ($F("deleteBillSw") == "N") {
				if ($F("gipiWInvoiceExist") == "1"){
					showConfirmBox(
							"Message",
							"You have changed your policy's inception date from "
									+ $("paramDoi").value
									+ " to "
									+ $("doi").value
									+ '. Will now do the necessary changes.?',
							"Ok", "Cancel", onOkFunc,
							onCancelFunc);
				}
			}
		}
		function onOkFunc() {
			$("deleteBillSw").value = "Y";
			$("deleteWorkingDistSw").value = "Y";
		}
		function onCancelFunc() {
			$("doi").value = $F("paramDoi");
			$("doe").value = $F("paramDoe");
			$("deleteBillSw").value = "N";
			$("doi").focus();
			$("prorateFlag").value = $F("paramProrateFlag");
			showProrateRelatedSpan();
			$("prorateFlag").enable();
		}

		$("noOfDays2").value = computeNoOfDays2($F("doi"),$F("doe"),$F("compSw"));
		if ($("doi").value != ""){
			if ($("prorateFlag") != 2){
				if ($("defaultDoe").value == $("doe").value){
					$("prorateFlag").selectedIndex = 1;
					$("prorateFlag").value = "2";
					showProrateRelatedSpan();
					$("prorateFlag").disable();
				} else {
					$("prorateFlag").enable();
					showProrateRelatedSpan();
				}	
			}				
		} // end robert GENQA SR 4825 08.03.15
	});

	function checkParPostedBinder(label){
		var res = true;
		new Ajax.Request(contextPath+"/GIPIParBondInformationController", {	// added by shan 10.14.2014
			method: "GET",
			parameters: {action: 			"checkParPostedBinder",
			 			 parId:				$F("globalParId")
						 },
			asynchronous : false,
			evalScripts : true,			 
			onCreate: function(){
				showNotice("Checking posted binder, please wait...");
				},							 
			onComplete: function (response) {
					hideNotice("");
				if (response.responseText == "Y") {
					showMessageBox("The " + label + " of this PAR cannot be updated, for detail records already exist. However, you may choose to delete " + 
										"this PAR and recreate it with the necessary changes.", imgMessage.INFO);
					res = false;
					return false;
				}
			}
		});	
		
		return res;
	}
	//$("doe").observe("blur", function () {
	$("doe").observe("change", function () { //belle 11.19.2012
		if (!checkParPostedBinder("expiry date")){
			$("doe").value = $("paramDoe").value;
			return false;
		}
		if ($("doe").value != $("paramDoe").value && makeDate($("doe").value) > makeDate($("issueDate").value)){
			computeNoOfDays();
		}	
		//marco - 05.30.2013 - added condition
		if($F("globalIssCd") != $F("globalIssCdRI")){
			if ((makeDate($("doe").value) < makeDate($("issueDate").value)) && (nvl(objUW.hidObjGIPIS017.allowIssueExpiredBond, "N") != "Y") ) {
				showWaitingMessageBox("A policy cannot expire before the date of its issuance.", imgMessage.ERROR,
					function(){
						if (objUW.hidObjGIPIS017.isExistGipiWPolbas == "1"){
							backToPreTextValue("doe");
							computeNoOfDays();
						}else{
							defaultExpiryDate();
							computeNoOfDays();
						}	
					});
				return false;		
			}
		}else{
			computeNoOfDays();
		}
	});
    //added by robert GENQA SR 4825 08.03.15	
	$("doe").observe("blur", function () {
		if ($F("doe") != $F("paramDoe") && $F("doe") != "") {
			if ($F("deleteBillSw") == "N") {
				if ($F("gipiWInvoiceExist") == "1"){
					showConfirmBox(
							"Message",
							"You have changed your policy's expiry date from "
									+ $("paramDoe").value
									+ " to "
									+ $("doe").value
									+ '. Will now do the necessary changes.?',
							"Ok", "Cancel", onOkFunc,
							onCancelFunc);
				}
			}
		}
		function onOkFunc() {
			$("deleteBillSw").value = "Y";
			$("deleteWorkingDistSw").value = "Y";
		}
		function onCancelFunc() {
			$("validateTag").value = $F("paramValidateTag");
			$("doe").value = $F("paramDoe");
			$("deleteBillSw").value = "N";
			$("doe").focus();
			$("prorateFlag").value = $F("paramProrateFlag");
			showProrateRelatedSpan();
			$("prorateFlag").enable();
		}
		
		$("noOfDays2").value = computeNoOfDays2($F("doi"),$F("doe"),$F("compSw"));
		defaultDOE();
		if ($("defaultDoe").value != $("doe").value){
			$("prorateFlag").enable();
		}else{
			$("prorateFlag").value = "2";
			$("prorateFlag").disable();	
			showProrateRelatedSpan();
		}
	});
	//end robert GENQA SR 4825 08.03.15
	/*$("issueDate").observe("blur", function(){
		if (makeDate($("doe").value) < makeDate($("issueDate").value)) {
			$("issueDate").focus();
			$("issueDate").clear();
			showMessageBox("A policy cannot expire before the date of its issuance.", imgMessage.ERROR);
			return false;		
		}	
	});*/
	
	$("noOfDays").observe("blur", function () {
		$("noOfDays").value = $F("noOfDays").replace(/,/g, "");
		if ((parseInt($F("noOfDays")) < 0) || (parseInt($F("noOfDays")) > 9999999)){
			showMessageBox("Entered Validity Period is invalid. Valid value is from 0 to 9999999", imgMessage.ERROR);
			$("noOfDays").clear();
			return false;		
		}	
	});

	$("assuredName").observe("focus", function () {
		if ($("paramAssuredName").value != $("assuredName").value) {
			$("validateAssdName").value = "Y";
			disableMenu("bill");
		} else {
			$("validateAssdName").value = "N";
		}		
	});

					
	function getBookingDate(){
		new Ajax.Request(contextPath+"/GIPIParBondInformationController",{	// added retrieval of giacv.p('PROD_TAKE_UP') : shan 10.14.2014
			parameters:{
				action: "getProdTakeUp",
				parId: $F("parId")	
			},
			asynchronous: false,
			evalScripts: true,
			onComplete:function(response){
				if (checkErrorOnResponse(response)){
					$("varVdate").value = parseInt(response.responseText);
					
					var iiDateArray = $F("doi").split("-");
					var iiDate = new Date();
					var iidate = parseInt(iiDateArray[1], 10);
					var iimonth = parseInt(iiDateArray[0], 10);
					var iiyear = parseInt(iiDateArray[2], 10);
					iiDate.setFullYear(iiyear, iimonth-1, iidate);

					var isDateArray = $F("issueDate").split("-");
					var isDate = new Date();
					var isdate = parseInt(isDateArray[1], 10);
					var ismonth = parseInt(isDateArray[0], 10);
					var isyear = parseInt(isDateArray[2], 10);
					isDate.setFullYear(isyear, ismonth-1, isdate);

					var iDateArray = iiDateArray;
					//for issue date
					/*var newDate = new Date();
					if (iiyear <= 1996) {
						$("issueDate").value = $F("doi");
					} else {
						$("issueDate").value = (newDate.getMonth()+1 < 10 ? "0"+(newDate.getMonth()+1) : (newDate.getMonth()+1))+"-"+newDate.getDate()+"-"+newDate.getFullYear();
					}*/		
					
					 //moved declaration of iDateArray to top (d.alcantara, 01/27/2012)
					if (($("varVdate").value == "1") || ($("varVdate").value == "3" && isDate > iiDate)){ //|| (($("varVdate").value == "4") && (isDate < iiDate))){ //4 condition is for gipis02 lang pala..lol
						iDateArray = $F("issueDate").split("-");
					} else if (($("varVdate").value == "2") || ($("varVdate").value == "3" && isDate <= iiDate)){// || (($("varVdate").value == "4") && (isDate >= iiDate))) { //4 condition is for gipis02 lang pala..lol
						iDateArray = $F("doi").split("-");
					}		
					
					//Rey 11-11-2011 
					// copy from POI.jsp for the advance booking  
					var varIDate = "";
					if (($("varVdate").value == "1") || (($("varVdate").value == "3") && (isDate > iiDate)) || (($("varVdate").value == "4") && (isDate < iiDate))){
						iDateArray = $F("issueDate").split("-");
						varIDate = $F("issueDate");
					} else if (($("varVdate").value == "2") || (($("varVdate").value == "3") && (isDate <= iiDate)) || (($("varVdate").value == "4") && (isDate >= iiDate))) {
						iDateArray = $F("doi").split("-");
						varIDate = $F("doi");
					}		
					//Gzelle 10172014 from poi.jsp
					//if (nvl(objUW.hidObjGIPIS002.bookingAdv,"N") != "Y"){ 
					if (nvl(objUW.hidObjGIPIS017.bookingAdv,"N") != "Y"){ //robert 10.22.2014
						new Ajax.Request(contextPath+"/GIPIParInformationController",{
							parameters:{
								action: "getBookingListing",
								parId: $F("parId"),
								date: varIDate				
							},
							asynchronous: false,
							evalScripts: true,
							onComplete:function(response){
								var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
								updateBookingLOV(res);
							}	
						});	
					}
					
					new Ajax.Request(contextPath+"/GIPIParInformationController", {
						method: "GET",
						parameters:{
							action: "getBookingDateGIPIS002",
							parId: $F("parId"),
							varIDate: varIDate				
						},
						asynchronous: false,
						evalScripts: true,
						onComplete:function(response){
							var book = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
							for(var a=0; a<$("bookingMonth").options.length; a++){
								if ($("bookingMonth").options[a].getAttribute("bookingyear") == book.bookingYear
								    && $("bookingMonth").options[a].getAttribute("bookingMth") == book.bookingMth){
									$("bookingMonth").selectedIndex = a;
									$("bookingYear").value = $("bookingMonth").options[a].getAttribute("bookingYear");
								 	$("bookingMth").value = $("bookingMonth").options[a].getAttribute("bookingMth");
								}	
							}	
						}	
					});
					
					/*if (nvl(objUW.hidObjGIPIS017.bookingAdv,"N") != "Y"){
						new Ajax.Request(contextPath+"/GIPIParInformationController",{
							parameters:{
								action: "getBookingListing",
								parId: $F("parId"),
								date: varIDate				
							},
							asynchronous: false,
							evalScripts: true,
							onComplete:function(response){
								var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
								updateBookingLOV(res);
							}	
						});	

						if ($("bookingMonth").options.length > 1){
						 	$("bookingMonth").selectedIndex = 1;
							$("bookingYear").value = $("bookingMonth").options[1].getAttribute("bookingYear");
						 	$("bookingMth").value = $("bookingMonth").options[1].getAttribute("bookingMth");
						}
						
					}else{
						for(var a=0; a<$("bookingMonth").options.length; a++){
							if ($("bookingMonth").options[a].getAttribute("bookingyear") == iDateArray[2] 
							    && $("bookingMonth").options[a].value == iDateArray[0]){
								$("bookingMonth").selectedIndex = a;
								$("bookingYear").value = $("bookingMonth").options[a].getAttribute("bookingYear");
							 	$("bookingMth").value = $("bookingMonth").options[a].getAttribute("bookingMth");
							}	
						}	
					}*/
					
					/* var iDate = new Date();
					var date = parseInt(iDateArray[1], 10);
					var month = parseInt(iDateArray[0], 10);
					var year = parseInt(iDateArray[2], 10);
					var exist = 0;
					for (var i=1; i<$("bookingMonth").options.length; i++){
						if (year == $("bookingMonth").options[i].getAttribute("bookingYear")) {
							exist = 1;
							break;
						}
					}
					var ii = 1;
						if($("bookingDateExist").value == 0){
							ii = 2;
						}
					if (exist == 0) {
						for (var i=ii; i<$("bookingMonth").options.length; i++){
							if ($("bookingMonth").options[i].getAttribute("bookingYear") != ""){
								if (year > $("bookingMonth").options[i].getAttribute("bookingYear")) {
									exist = 2;
									break;
								}
							}		
						}		
					}
					for (var i=0; i<$("bookingMonth").options.length; i++){
						if (exist == 1) {
					   		if (($("bookingMonth").options[i].getAttribute("bookingYear") == year) && ($("bookingMonth").options[i].value == month)){
						   		$("bookingMonth").selectedIndex = i;
					       		$("bookingYear").value = $("bookingMonth").options[i].getAttribute("bookingYear");
						   		$("bookingMth").value = $("bookingMonth").options[i].getAttribute("bookingMth");
						   		break;
					   		}	  
						} else if (exist == 2) {
					   		if (($("bookingMonth").options[i].getAttribute("bookingYear") >= year) && ($("bookingMonth").options[i].value == "01")){
						   		$("bookingMonth").selectedIndex = i;
						   		$("bookingYear").value = $("bookingMonth").options[i].getAttribute("bookingYear");
						   		$("bookingMth").value = $("bookingMonth").options[i].getAttribute("bookingMth");
						   		break;
					   		}
				   	 	} else {
					    	$("bookingMonth").selectedIndex = 1;
					   	 	$("bookingYear").value = $("bookingMonth").options[1].getAttribute("bookingYear");
					  		$("bookingMth").value = $("bookingMonth").options[1].getAttribute("bookingMth");
				    	}	 
					} */
				}
			}	
		});
	}
		
	function updateBookingLOV(objArray){  // this function added by: Nica 05.09.2012
		try{
			removeAllOptions($("bookingMonth"));
			var opt = document.createElement("option");
			opt.value = "";
			opt.text = "";
			opt.setAttribute("bookingmth", "");
			opt.setAttribute("bookingyear", "");
			$("bookingMonth").options.add(opt);
			for(var a=0; a<objArray.length; a++){
				var opt = document.createElement("option");
				//opt.value = objArray[a].bookingMonthNum;
				//added by steven 10.16.2014
				opt.value = a;
				opt.setAttribute("bookingMonthNum", objArray[a].bookingMonthNum); 
				//end
				opt.text = objArray[a].bookingYear+" - "+changeSingleAndDoubleQuotes(objArray[a].bookingMonth);
				opt.setAttribute("bookingmth", objArray[a].bookingMonth); 
				opt.setAttribute("bookingyear", objArray[a].bookingYear); 
				$("bookingMonth").options.add(opt);
			}
		} catch (e) {
			showErrorMessage("updateBookingLOV", e);
		}
	}

	function defaultExpiryDate() {
		var iDateArray = $F("doi").split("-");
		if (iDateArray.length > 1)	{
			var iDate = new Date();
			var date = parseInt(iDateArray[1], 10);
			var month = parseInt(iDateArray[0], 10) + 12;
			var year = parseInt(iDateArray[2], 10);
			if (month > 12) {
				month -= 12;
				year += 1;
			}
			$("doe").value = (month < 10 ? "0"+month : month) +"-"+(date < 10 ? "0"+date : date)+"-"+year;
		}
	}	

	function showRelatedSpan() {
		if($("bookingDateExist").value == 1){
			$("opt2").hide();
		} else if ($("opt2").value == "") {
			$("opt2").hide();
		}
	}

	var preBookingMonth;
	var preBookingYear;
	var preBookingMth;
	$("bookingMonth").observe("focus", function() {
		preBookingMonth = $("bookingMonth").value;
		preBookingYear = $("bookingYear").value;
		preBookingMth = $("bookingMth").value;
	});	
	
	$("bookingMonth").observe("click", function(){
		if($F("doi") == "") {
			showMessageBox("Please enter an inception first.", "e");
			$("bookingMonth").selectedIndex = 0;
		}
	});
	
	
	//upon change of booking date
	$("bookingMonth").observe("change", function() { // debugging
		$("bookingYear").value = $("bookingMonth").options[$("bookingMonth").selectedIndex].getAttribute("bookingYear");
		$("bookingMth").value = $("bookingMonth").options[$("bookingMonth").selectedIndex].getAttribute("bookingMth");
		if($F("doi") == "") {
			showMessageBox("Please enter an Inception and Expiry Date first.", "e");
			$("bookingMonth").selectedIndex = 0;
		} else if ($F("bookingMonth") != "") {
			$("validatedBookingDate").value = "Y";
			if (!validateBookingDate()){
				$("bookingMonth").value = preBookingMonth;
				$("bookingYear").value = preBookingYear;
				$("bookingMth").value = preBookingMth;
			}	
		} else {
			$("validatedBookingDate").value = "N";
		}
		if ($F("doi") != "" && $F("bookingMonth") != ""){
			getIssueYyBondBasic();
		}	
	});	

	observeBackSpaceOnDate("mortG");
	observeChangeTagOnDate("mortgDate", "mortG");
	$("mortgDate").observe("click", function(){
		showMortgageeLOVGipis165($F("issCd"), "", "", function(row){
			 if(row != undefined){
				$("mortG").value = unescapeHTML2(row.mortgName);
				$("mortgCd").value = row.mortgCd;
				$("mortG").focus(); 
				changeTag = 1;
			}
		});
		
		/* var width = 540;
		var title = "Mortgagee";
		var id= "GIPIS002-Mortgagee";
		var objArray = objUW.hidObjGIPIS017.mortgageeListingJSON;
		if (nvl(objArray.length,0) <= 0){
			customShowMessageBox("List of Values contains no entries.", imgMessage.ERROR, "mortG");
			return false;
		}
		if (($("contentHolder").readAttribute("lov") != id)){
			initializeOverlayLov(id, title, width);
			generateOverlayLovRow(id, objArray, width);
			function onOk(){
				var mortgName = unescapeHTML2(getSelectedRowAttrValue(id+"LovRow", "val"));
				var mortgCd = unescapeHTML2(getSelectedRowAttrValue(id+"LovRow", "cd"));
				if (mortgName == ""){showMessageBox("Please select a mortgagee first.", imgMessage.ERROR); return;};
				$("mortG").value = mortgName;
				$("mortgCd").value = mortgCd;
				$("mortG").focus();
				hideOverlay();
			}
			observeOverlayLovRow(id);
			observeOverlayLovButton(id, onOk);
			observeOverlayLovFilter(id, objArray);
		}else{
			//to avoid re-query of LOV w/o any filter
			$("opaqueOverlay").style.display = "block";
			$("contentHolder").style.display = "block";
		}	 */
	});

	function generateOverlayLovRow(id, objArray, width){
		for(var a=0; a<objArray.length; a++){
			var newDiv = new Element("div");
			newDiv.setAttribute("id", a);
			newDiv.setAttribute("name", id+"LovRow");
			newDiv.setAttribute("val", objArray[a].mortgName);
			newDiv.setAttribute("cd", objArray[a].mortgCd);
			newDiv.setAttribute("title", objArray[a].mortgName,'');
			newDiv.setAttribute("class", "lovRow");
			newDiv.setStyle("width:98%; margin:auto;");
			strDiv = objArray[a].mortgName;
			newDiv.update(strDiv);
			$("lovListingDiv").insert({bottom: newDiv});
			var header1 = generateOverlayLovHeader('100%', 'MORTGAGEE');
			$("lovListingDivHeader").innerHTML = header1;
			$("lovListingMainDivHeader").show();
			$("filterTextLOV").focus();
		}
	}	
	
	function initializeBondSequence(){
		if ("${showBondSeqNo}" == "Y"){
			$("manualRenewNo").setStyle({
				width: "76px"
			});
			$("lblBondSeqNo").show();
			$("selBondSeqNo").show();
			oldBondSeqNo = $("selBondSeqNo").value;
		}
		getBondSeqNo(false);
		var o = document.getElementById("selBondSeqNo");
		for (var i = 0; i < o.length; i++){
			if (o.options[i].value == parseInt("${gipiWPolbas.bondSeqNo}")){
				o.options[i].selected = true;
				return;
			}
		}
		
	}
	
	$("sublineCd").observe("change", function() {
		var paramSubline = $("paramSubline").value;
		var sublineCd = $("sublineCd").value;
		
		if ((paramSubline != sublineCd )&&(sublineCd != "")) {
			if ($F("gipiWInvoiceExist") == "1"){
				if (!checkParPostedBinder("bond type")){	// shan 10.14.2014
					$("sublineCd").value = paramSubline;
					return false;
				}
				
				showConfirmBox("Message", "This will delete Bill information",  
						"Continue", "Cancel", onOkFunc, onCancelFunc);
			}	
		}	
		function onOkFunc(){
			$("deleteBillSw").value = "Y";
			$("deleteWorkingDistSw").value = "Y";	// shan 10.14.2014
		}	
		function onCancelFunc(){
			$("sublineCd").value = $("paramSubline").value;
		}
		if (($F("policyStatus") == "2") || ($F("policyStatus") == "3")){
			$("wpolnrepSublineCd").value = $("sublineCd").value;
			$("validateIfOldBondExist").value = "Y";
		}
		
		getBondSeqNo(true);
	});	
	
	$("selBondSeqNo").observe("change", function(){
		validateBondSeq();
	});
	
	function validateBondSeq(){
		try{
			new Ajax.Request(contextPath+"/GIPIParBondInformationController",{
				method: "GET",
				parameters:{
					action: "validateBondSeq",
					parId: $F("parId"),
					lineCd: $F("lineCd"),
					sublineCd: $("sublineCd").value,
					seqNo: $("selBondSeqNo").value
				},
				onComplete:function(response){
					if (response.responseText == "VALID"){
						updBondSeqHist();
					} else if (response.responseText == "INVALID"){
						showMessageBox("Please enter a valid bond sequence no.", imgMessage.ERROR);
						getBondSeqNo(true);
					} else {
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}	
			});
		} catch(e){
			showErrorMessage("updBondSeqHist",e);
		}
	}
	
	function getBondSeqNo(enableUpdate){
		try{
			new Ajax.Request(contextPath+"/GIPIParBondInformationController",{
				method: "GET",
				parameters:{
					action: "getBondSeqNoList",
					parId: $F("parId"),
					lineCd: $F("lineCd"),
					sublineCd: $("sublineCd").value
				},
				asynchronous: false,
				evalScripts: true,
				onComplete:function(response){
					var result = response.responseText;
					if (result.charAt(0) + result.charAt(result.length-1) == "[]"){
						var jsonBondSeqList = JSON.parse(response.responseText);
						
						var selBondSeqNo = document.getElementById("selBondSeqNo");
						for (var i = selBondSeqNo.length-1; i >= 0; i--){
							selBondSeqNo.remove(i);
						}
						jsonBondSeqList.each(function(item){
							addOption("selBondSeqNo", item);
						});
						if (enableUpdate){
							updBondSeqHist();
						}
					} else {
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}	
			});
		} catch(e){
			showErrorMessage("getBondSeqNo",e);
		}
	}
	
	function updBondSeqHist(){
		try{
			new Ajax.Request(contextPath+"/GIPIParBondInformationController",{
				method: "POST",
				parameters:{
					action: "updBondSeqHist",
					parId: $F("parId"),
					lineCd: $F("lineCd"),
					sublineCd: $("sublineCd").value,
					seqNo: $("selBondSeqNo").value,
					oldSeqNo: oldBondSeqNo,
					oldSublineCd: oldBondType
				},
				onComplete:function(response){
					if (response.responseText != "SUCCESS"){
						showMessageBox(response.responseText, imgMessage.ERROR);
					} else {
						oldBondSeqNo = $("selBondSeqNo").value;
						oldBondType = $("sublineCd").value;
					}
				}	
			});
		} catch(e){
			showErrorMessage("updBondSeqHist",e);
		}
	}
	
	function addOption(id, value){
		var newOpts = document.createElement('option');
		var selectElement = document.getElementById(id);
		newOpts.text = value;
		newOpts.value = value;
		try{
			selectElement.add(newOpts, null);
		} catch(e){
			selectElement.add(newOpts);
		}
	}
	$("policyStatus").observe("change", function () {
		if (($("policyStatus").value == 1) || ($("policyStatus").value == 2) 
			|| ($("policyStatus").value == 3)|| ($("policyStatus").value == 4) 
			|| ($("policyStatus").value == 5) || ($("policyStatus").value == "")){
			null;
		} else {
			$("policyStatus").value = $("paramPolicyStatus").value;
			showMessageBox("Bond Status is invalid.", imgMessage.ERROR);
			//initAllFirst();
		}
		if ($("policyStatus").value != 2){
			$("samePolnoSw").checked = false;
			$("samePolnoSw").disable();
		}else{
			$("samePolnoSw").enable();
		}		
		if (($F("policyStatus") == "2") || ($F("policyStatus") == "3")){
			if ($("deleteWPolnrep").value != "Y"){
				$("deleteWPolnrep").value = "N";
			}
			enablePolicyRenewalForm();
			$("validateIfOldBondExist").value = "Y";
		} else {
			$("deleteWPolnrep").value = "Y";
			clearPolicyRenewalForm();
			disablePolicyRenewalForm();
		}
	});		

	var takeupTermOverrideOk = "N"; //override was successful?
	$("takeupTermType").observe("focus", function () { 
		if (nvl(objUW.hidObjGIPIS017.overrideTakeupTerm,"N") == "Y" && takeupTermOverrideOk == "N"){ //if override is required
			objAC.funcCode = "OT";
			objACGlobal.calledForm = "GIPIS017";
			var ok = validateUserFunc2(objAC.funcCode, objACGlobal.calledForm);
			if (!ok){
				$("takeupTermType").blur();
				commonOverrideOkFunc = function(){
					takeupTermOverrideOk = "Y";
					$("takeupTermType").focus();
					$("takeupTermType").scrollTo();
				};
				commonOverrideNotOkFunc = function(){
					showWaitingMessageBox($("overideUserName").value+" does not have an overriding function for this module.", imgMessage.ERROR, 
							clearOverride);
					$("takeupTermType").value = $("paramTakeupTermType").value;
				};	
				getUserInfo();
				$("overlayTitle").update("Override default take-up term");
			}else if (ok){
				takeupTermOverrideOk = "Y";
			}			
		}
	});
	
	$("takeupTermType").observe("change", function () {
		if (nvl(objUW.hidObjGIPIS017.overrideTakeupTerm,"N") == "Y" && takeupTermOverrideOk == "N") $("takeupTermType").value = $("paramTakeupTermType").value;
		if ($F("takeupTermType") != $F("paramTakeupTermType")) {
			showConfirmBox("Message", "Changing the take-up term will recreate the records in the tables and thus records in Bill Premium / Invoice Commission would be deleted, if any. Continue?",  
					"Ok", "Cancel", onOkFunc, onCancelFunc);
		}	
		function onOkFunc(){
			$("deleteSw").value = "Y";
			$("deleteBillSw").value = "Y";	//added by Gzelle 10142014 to delete bill related tables first, before recreating invoice
		}	
		function onCancelFunc(){
			$("takeupTermType").value = $("paramTakeupTermType").value;
		}
	});	

	initForm();
	showRelatedSpan();
	newObserve();
	// added by robert GENQA SR 4825 08.03.15
	defaultDOE();
	showProrateRelatedSpan();
	if ($("defaultDoe").value != $("doe").value) {
		$("prorateFlag").enable();
	} else {
		$("prorateFlag").disable();
	}
	//end robert GENQA SR 4825 08.03.15
	
	function initForm() {
		if (getRowCount() == 0) {
			$("oldBondBasicInformation").update("<div id='rowOldBondNo' name='rowOldBondNo'>"+
											"<table width='100%' cellspacing='1' border='0' >"+
											"<tr><td class='rightAligned' width='20%'>Old Bond No.</td>"+
											"<td><input type='hidden' name='renRepSw' 	id='renRepSw' 	value='' />"+
											"<input type='hidden' name='oldPolicyId' 	id='oldPolicyId' 	value='' />"+
											"<input type='hidden' name='recFlag' 		id='recFlag' 		value='' />"+
											"<input type='hidden' id='wpolnrepOldPolicyId' name='wpolnrepOldPolicyId' value='' />"+
											"<input type='text' style='width: 84%;'   id='wpolnrepLineCd'   	name='wpolnrepLineCd'    readonly='readonly' value='' class='required'/>"+
											"</td><td><input type='text' style='width: 88%;' 	id='wpolnrepSublineCd' 	name='wpolnrepSublineCd' readonly='readonly' value='' class='required'/></td>"+
											"<td><input type='text' style='width: 84%; text-transform: uppercase;' 	id='wpolnrepIssCd'		name='wpolnrepIssCd' maxlength='3' value='' class='required'/></td>"+
											"<td><input type='text' style='width: 84%; text-align: right;'		id='wpolnrepIssueYy'	name='wpolnrepIssueYy'  maxlength='2' value='' class='required integerNoNegativeUnformattedNoComma deleteInvalidInput' errorMsg='Entered Issue Year is invalid. Valid value is from 00 to 99'/></td>"+
											"<td><input type='text' style='width: 88%; text-align: right;'		id='wpolnrepPolSeqNo'	name='wpolnrepPolSeqNo' maxlength='7' value='' class='required integerNoNegativeUnformattedNoComma deleteInvalidInput' errorMsg='Entered Policy Sequence No. is invalid. Valid value is from 0 to 9999999'/></td>"+
											"<td><input type='text' style='width: 84%; text-align: right;'		id='wpolnrepRenewNo'	name='wpolnrepRenewNo'  maxlength='2' value='' class='required integerNoNegativeUnformattedNoComma deleteInvalidInput' errorMsg='Entered Renew No. is invalid. Valid value is from 0 to 99'/></td>"+	 	
											"</tr><tr><td></td><td colspan='7'><label style='margin-right: 5px;'><input type='checkbox' id='samePolnoSw' name='samePolnoSw' value='Y' class='rightAligned' title='Same Bond No.'/></label>"+
											"<label class='rightAligned'>Same Bond No.</label></td></tr></table></div>");
		}	
	}	

	function getRowCount() {
		var rowCount = 0;
		$$("div#oldBondBasicInformation div[name='rowOldBondNo']").each(function(){
			rowCount++;
		});
		return rowCount;
	}

	function newObserve() {
		<c:if test="${gipiWPolbas.validateTag eq 'D'}">
			$("validateTag").selectedIndex = 0;
		</c:if>

		<c:if test="${gipiWPolbas.validateTag eq 'M'}">
			$("validateTag").selectedIndex = 1;
		</c:if>

		<c:if test="${gipiWPolbas.validateTag eq 'Y'}">
			$("validateTag").selectedIndex = 2;
		</c:if>

		<c:if test="${gipiWPolbas.polFlag eq '1'}">
			$("policyStatus").selectedIndex = 0;
		</c:if>

		<c:if test="${gipiWPolbas.polFlag eq '2'}">
			$("policyStatus").selectedIndex = 1;
		</c:if>

		<c:if test="${gipiWPolbas.polFlag eq '3'}">
			$("policyStatus").selectedIndex = 2;
		</c:if>
	
		if ($("validateTag").value != ""){
			computeNoOfDays();
		}	

		if (($F("policyStatus") == "2") || ($F("policyStatus") == "3")){
			enablePolicyRenewalForm();
		} else {
			disablePolicyRenewalForm();
		}
		
		$("noOfDays").observe("blur", function() {
			if ($F("noOfDays") != ""){
				getNewExpiry();		
			}
		});

		$("validateTag").observe("change", function() {
			getNewExpiry();		
			//added by robert GENQA 4825 08.12.15
			if ($F("doe") != $F("paramDoe") && $F("doe") != "") {
				if (($("paramProrateFlag").value == "1") && ($F("deleteBillSw") == "N")) {
					if ($F("gipiWInvoiceExist") == "1"){
						showConfirmBox(
								"Message",
								"You have changed your policy's expiry date from "
										+ $("paramDoe").value
										+ " to "
										+ $("doe").value
										+ '. Will now do the necessary changes.?',
								"Ok", "Cancel", onOkFunc,
								onCancelFunc);
					}
				}
			}
			function onOkFunc() {
				$("deleteBillSw").value = "Y";
				$("deleteWorkingDistSw").value = "Y";
			}
			function onCancelFunc() {
				$("validateTag").value = $F("paramValidateTag");
				$("doe").value = $F("paramDoe");
				$("deleteBillSw").value = "N";
				$("doe").focus();
				$("prorateFlag").value = $F("paramProrateFlag");
				showProrateRelatedSpan();
				$("prorateFlag").enable();
			}
			//end robert GENQA 4844 08.12.15
		});
		
		$("wpolnrepRenewNo").observe("blur", function() {
			if (($("wpolnrepIssueYy").value != "") && ($("wpolnrepPolSeqNo").value != "") && ($("wpolnrepIssCd").value != "") && ($("wpolnrepRenewNo").value != "") && ($("wpolnrepSublineCd").value != "") && (paramForOldBond != $("wpolnrepRenewNo").value)) {
				getOldPolicyId();
			}	
			if($F("wpolnrepRenewNo") != "") {
				$("wpolnrepRenewNo").value = formatNumberDigits($F("wpolnrepRenewNo"), 2);
			}
		});
		
		$("wpolnrepIssueYy").observe("blur", function() {
			if (($("wpolnrepIssueYy").value != "") && ($("wpolnrepPolSeqNo").value != "") && ($("wpolnrepIssCd").value != "") && ($("wpolnrepRenewNo").value != "") && ($("wpolnrepSublineCd").value != "") && (paramForOldBond != $("wpolnrepIssueYy").value)) {
				getOldPolicyId();
			}
			if($F("wpolnrepIssueYy") != "") {
				$("wpolnrepIssueYy").value = formatNumberDigits($F("wpolnrepIssueYy"), 2);
			}
		});

		$("wpolnrepPolSeqNo").observe("blur", function() {
			if (($("wpolnrepIssueYy").value != "") && ($("wpolnrepPolSeqNo").value != "") && ($("wpolnrepIssCd").value != "") && ($("wpolnrepRenewNo").value != "") && ($("wpolnrepSublineCd").value != "") && (paramForOldBond != $("wpolnrepPolSeqNo").value)) {
				getOldPolicyId();
			}
			if($F("wpolnrepPolSeqNo") != "") {
				$("wpolnrepPolSeqNo").value = formatNumberDigits($F("wpolnrepPolSeqNo"), 6);
			}
		});

		$("wpolnrepIssCd").observe("blur", function() {
			if (($("wpolnrepIssueYy").value != "") && ($("wpolnrepPolSeqNo").value != "") && ($("wpolnrepIssCd").value != "") && ($("wpolnrepRenewNo").value != "") && ($("wpolnrepSublineCd").value != "") && (paramForOldBond != $("wpolnrepIssCd").value)) {
				getOldPolicyId();
			}
		});
		
		if (($("sublineCd").value != "") && ($("wpolnrepSublineCd").value == "")) {
			if (($F("policyStatus") == "2") || ($F("policyStatus") == "3")){
				$("wpolnrepSublineCd").value = $("sublineCd").value;
			}
		}	

		if($F("wpolnrepPolSeqNo") != "") {
			$("wpolnrepPolSeqNo").value = formatNumberDigits($F("wpolnrepPolSeqNo"), 6);
		}
		if($F("wpolnrepRenewNo") != "") {
			$("wpolnrepRenewNo").value = formatNumberDigits($F("wpolnrepRenewNo"), 2);
		}
		if($F("wpolnrepIssueYy") != "") {
			$("wpolnrepIssueYy").value = formatNumberDigits($F("wpolnrepIssueYy"), 2);
		}
		$("wpolnrepIssueYy").observe("focus", function(){
			$("wpolnrepIssueYy").select();
			paramForOldBond = $("wpolnrepIssueYy").value;
		});
		
		$("wpolnrepPolSeqNo").observe("focus", function(){
			$("wpolnrepPolSeqNo").select();
			paramForOldBond = $("wpolnrepPolSeqNo").value;
		});

		$("wpolnrepRenewNo").observe("focus", function(){
			$("wpolnrepRenewNo").select();
			paramForOldBond = $("wpolnrepRenewNo").value;
		});
		$("wpolnrepIssCd").observe("focus", function(){
			$("wpolnrepIssCd").select();
			paramForOldBond = $("wpolnrepIssCd").value;
		});
		if ($("policyStatus").value != 2){
			$("samePolnoSw").checked = false;
			$("samePolnoSw").disable();
		}else{
			$("samePolnoSw").enable();
		}

		observeBackSpaceOnDate("doe");
		observeBackSpaceOnDate("doi");

		if ("${updIssueDate}" == "Y"){
			observeBackSpaceOnDate("issueDate");
			observeChangeTagOnDate("hrefIssueDate", "issueDate", getBookingDate);
			$("issueDate").observe("blur", function(){
				//marco - 05.30.2013 - added condition
				if($F("globalIssCd") != $F("globalIssCdRI")){
					if (makeDate($("doe").value) < makeDate($("issueDate").value)) {
						showWaitingMessageBox("A policy cannot expire before the date of its issuance1.", imgMessage.ERROR,
							function(){
								if (objUW.hidObjGIPIS017.isExistGipiWPolbas == "1"){
									//backToPreTextValue("issueDate"); //marco - 05.30.2013
									$("issueDate").value = "";
									$("issueDate").focus();
									getBookingDate();
								}else{	
									//$("issueDate").value = today; //marco - 05.30.2013
									$("issueDate").value = "";
									$("issueDate").focus();
									getBookingDate();
								}
							});
					}
				}
				getBookingDate();
			});
		}else{
			disableDate("hrefIssueDate"); // Nica 05.14.2012
		}
	}

	function getOldPolicyId() {	
		var issCd 		= $F("wpolnrepIssCd").replace(/,/g, "");
		var issueYy 	= $F("wpolnrepIssueYy").replace(/,/g, "");
		var polSeqNo 	= $F("wpolnrepPolSeqNo").replace(/,/g, "");
		var renewNo 	= $F("wpolnrepRenewNo").replace(/,/g, "");	
		
		if (issCd == "" || 
			issueYy == "" || 
			polSeqNo == "" ||
			renewNo == "") {

			showMessageBox("Please complete policy no.", imgMessage.ERROR);
			return false;
		}

		if (isNaN(parseFloat(issueYy * 1))) {
			showMessageBox("Invalid Issuing Year <br />Value should be from 1 to 99.", imgMessage.ERROR);
			$("wpolnrepIssueYy").focus();
			return false;
		}

		if (isNaN(parseFloat(polSeqNo  * 1))) {
			showMessageBox("Invalid Policy Sequence Number <br />Value must be integer.", imgMessage.ERROR);
			$("wpolnrepPolSeqNo").focus();
			return false;
		}

		if (isNaN(parseFloat(renewNo * 1))) {
			showMessageBox("Invalid Renewal Number <br />Value must be integer.", imgMessage.ERROR);
			$("wpolnrepRenewNo").focus();
			return false;
		}
		checkOldBondNoExist();
	}

	function computeNoOfDays()	{
		var validTag = $("validateTag").value;
		if ($F("doi") == "" || $F("doe") == "") {
			return false;
		} else {
			var iDateArray = $F("doi").split("-");
			var iDate = new Date();
			var date = parseInt(iDateArray[1], 10);
			var month = parseInt(iDateArray[0], 10);
			var year = parseInt(iDateArray[2], 10);
			iDate.setFullYear(year, month-1, date);

			var eDateArray = $F("doe").split("-");
			var eDate = new Date();
			var edate = parseInt(eDateArray[1], 10);
			var emonth = parseInt(eDateArray[0], 10);
			var eyear = parseInt(eDateArray[2], 10);
			eDate.setFullYear(eyear, emonth-1, edate);

			if (eDate < iDate)	{
				showMessageBox("A policy cannot expire  before the date of its inception.", imgMessage.ERROR);
				$("doe").clear();
				$("doi").focus();
				return false;
			} else if (validTag == "D"){
				var oneDay = 1000*60*60*24;
				$("noOfDays").value = Math.floor((parseInt(Math.floor(eDate.getTime() - iDate.getTime()))/oneDay));
			} else if (validTag == "M"){
				var year = parseInt((eyear - year)*12);
				$("noOfDays").value = parseInt((((emonth-1)*1) - ((month-1)*1))+year);
			} else if (validTag == "Y"){
				$("noOfDays").value = parseInt(eyear - year);
			}
			if ($F("prorateFlag") == "1" && $F("validateTag")=="D")	{ //added by robert GENQA SR 4825 08.03.15
				$("noOfDays").value = computeNoOfDays2($F("doi"),$F("doe"),$F("compSw"));
			} // end robert GENQA SR 4825 08.03.15
		}
	}

	function getNewExpiry() {
		var validTag = $("validateTag").value;
		var newDate = Date.parse($F("doi"));
		var num = $("noOfDays").value;
		if (validTag == "D") {
			num = num*1;
			//added by robert GENQA 4825 08.12.15
			if($F("compSw") == "Y"){
				num = num - 1;
			}else if($F("compSw") == "M"){
				num = num + 1;
			}
			//end robert GENQA 4825 08.12.15
			newDate.add(num).days();
			var month = newDate.getMonth()+1 < 10 ? "0" + (newDate.getMonth()+1) : newDate.getMonth()+1;
			$("doe").value =  month + "-" + ((newDate.getDate()< 10) ? "0"+newDate.getDate() :newDate.getDate()) + "-" + newDate.getFullYear();
			if (parseInt(newDate.getFullYear()) > 9999 || isNaN(newDate.getFullYear())){
				showMessageBox("Entered validity period is invalid. Entered value should not result to a year greater than 9999.", imgMessage.ERROR);
				$("doe").clear();
			}
		} else if (validTag == "M") {
			num = num*1;
			newDate.add(num).months();
			//added by robert GENQA 4825 08.12.15
			if($F("compSw") == "Y"){
				newDate.add(-1).days();
			}else if($F("compSw") == "M"){
				newDate.add(1).days();
			}
			//end robert GENQA 4825 08.12.15
			var month = newDate.getMonth()+1 < 10 ? "0" + (newDate.getMonth()+1) : newDate.getMonth()+1;
			$("doe").value =  month + "-" + ((newDate.getDate()< 10) ? "0"+newDate.getDate() :newDate.getDate()) + "-" + newDate.getFullYear();
			if (parseInt(newDate.getFullYear()) > 9999 || isNaN(newDate.getFullYear())){
				showMessageBox("Entered validity period is invalid. Entered value should not result to a year greater than 9999.", imgMessage.ERROR);
				$("doe").clear();
			}
		} else if (validTag == "Y") {
			num = num*1;
			newDate.add(num).years();
			//added by robert GENQA 4825 08.12.15
			if($F("compSw") == "Y"){
				newDate.add(-1).days();
			}else if($F("compSw") == "M"){
				newDate.add(1).days();
			}
			//end robert GENQA 4825 08.12.15
			var month = newDate.getMonth()+1 < 10 ? "0" + (newDate.getMonth()+1) : newDate.getMonth()+1;
			$("doe").value =  month + "-" + ((newDate.getDate()< 10) ? "0"+newDate.getDate() :newDate.getDate()) + "-" + newDate.getFullYear();
			if (parseInt(newDate.getFullYear()) > 9999 || isNaN(newDate.getFullYear())){
				showMessageBox("Entered validity period is invalid. Entered value should not result to a year greater than 9999.", imgMessage.ERROR);
				$("doe").clear();
			}	
		}
		$("doe").focus();
		$("noOfDays2").value = computeNoOfDays2($F("doi"),$F("doe"),$F("compSw")); //added by robert GENQA 4825 08.12.15
	}	
	
	function clearPolicyRenewalForm(){
		$("oldPolicyId").value = "";
		$("wpolnrepIssCd").value = "";
		$("wpolnrepIssueYy").value = "";
		$("wpolnrepPolSeqNo").value = "";
		$("wpolnrepRenewNo").value = "";
		$("samePolnoSw").checked = false;
	}

	function disablePolicyRenewalForm(){
		$("wpolnrepLineCd").disable();
		$("wpolnrepSublineCd").disable();
		$("wpolnrepIssCd").disable();
		$("wpolnrepIssueYy").disable();
		$("wpolnrepPolSeqNo").disable();
		$("wpolnrepRenewNo").disable();
		$("wpolnrepLineCd").removeClassName("required");
		$("wpolnrepSublineCd").removeClassName("required");
		$("wpolnrepIssCd").removeClassName("required");
		$("wpolnrepIssueYy").removeClassName("required");
		$("wpolnrepPolSeqNo").removeClassName("required");
		$("wpolnrepRenewNo").removeClassName("required");
		$("wpolnrepSublineCd").clear();
		$("wpolnrepLineCd").clear();
	}
	
	function enablePolicyRenewalForm(){
		$("wpolnrepLineCd").enable();
		$("wpolnrepSublineCd").enable();
		$("wpolnrepIssCd").enable();
		$("wpolnrepIssueYy").enable();
		$("wpolnrepPolSeqNo").enable();
		$("wpolnrepRenewNo").enable();
		$("wpolnrepLineCd").addClassName("required");
		$("wpolnrepSublineCd").addClassName("required");
		$("wpolnrepIssCd").addClassName("required");
		$("wpolnrepIssueYy").addClassName("required");
		$("wpolnrepPolSeqNo").addClassName("required");
		$("wpolnrepRenewNo").addClassName("required");
		$("wpolnrepSublineCd").value = $("sublineCd").value;
		$("wpolnrepLineCd").value = $("lineCd").value==""?"SU":$("lineCd").value;
	}
			
	$("manualRenewNo").value = formatNumberDigits($F("manualRenewNo"),2);
	if (parseInt($("varVdate").value) > 3) {
		$("bondBasicInformationForm").disable();
		$("bondBasicInformationFormButton").disable();
		showMessageBox("The parameter value "+$("varVdate").value+" for parameter name 'PROD_TAKE_UP' is invalid. Please do the necessary changes.", imgMessage.ERROR);
	}

	$("referencePolicyNo").observe("blur", function(){
		$("referencePolicyNo").value = $("referencePolicyNo").value.toUpperCase();
	});

	$("samePolnoSw").observe("change",function(){
		if ($F("issCd").toUpperCase() != $F("wpolnrepIssCd").toUpperCase()){
			if (($F("policyStatus") == 2) || ($F("policyStatus") == 3)) {
				if ($("samePolnoSw").checked){
					showMessageBox("Issuing source code must be the same with the policy to be renewed if the 'Same Bond No.' option will be used.", imgMessage.ERROR);
					$("samePolnoSw").checked = false;
				}
			}
		}	
	});

	observeBackSpaceOnDate("assuredName");
	observeChangeTagOnDate("oscmDate", "assuredName");
	
	//added by steven 10.15.2014 base in SR 3078
	if (nvl(objUWParList.polFlag,null) != null) {
		getBookingDate();
		for (var i=0; i<$("bookingMonth").options.length; i++){
			if ($F("paramBookingYear") == $("bookingMonth").options[i].getAttribute("bookingYear") && 
			    $F("paramBookingMth") == $("bookingMonth").options[i].getAttribute("bookingMth")) {
				$("bookingMonth").selectedIndex = i;
				$("bookingYear").value = $("bookingMonth").options[i].getAttribute("bookingYear");
			 	$("bookingMth").value = $("bookingMonth").options[i].getAttribute("bookingMth");
				break;
			}
		}
	}
	//getBookingDate();  // Rey 11-11-2011
					  // get advance booking date
	/*for (var i=1; i<$("bookingMonth").options.length; i++){
		if ($F("paramBookingYear") == $("bookingMonth").options[i].getAttribute("bookingYear") && 
		    $F("paramBookingMth") == $("bookingMonth").options[i].getAttribute("bookingMth")) {
			$("bookingMonth").selectedIndex = i;
			break;
		}
	}*/ //commented by: nica 05.09.2012 - no need to update booking month LOV upon loading
	//added by robert GENQA SR 4825 08.03.15
	function showProrateRelatedSpan(){			
		if ($F("prorateFlag") == "1")	{ //PRORATE
			$("shortRateSelected").hide();
			$("shortRatePercent").hide();
			$("prorateSelected").show();
			$("noOfDays2").show();
			$("noOfDays2").value = computeNoOfDays2($F("doi"),$F("doe"),$F("compSw"));
			if($F("validateTag")=="D"){
				$("noOfDays").value = computeNoOfDays2($F("doi"),$F("doe"),$F("compSw"));
			}
		} else if ($F("prorateFlag") == "3") {	//SHORT
			$("prorateSelected").hide();
			$("shortRateSelected").show();
			$("shortRatePercent").show();
			$("noOfDays2").hide();
			$("noOfDays2").value = "";
			computeNoOfDays();
		} else {		//STRAIGHT
			$("prorateFlag").value = "2";
			$("shortRateSelected").hide();
			$("shortRatePercent").hide();
			$("prorateSelected").hide();
			$("noOfDays2").hide();
			$("noOfDays2").value = "";
			computeNoOfDays();
		}
	}
	
	$("prorateFlag").observe("change", function () {
		showProrateRelatedSpan();
	});
	
	$("shortRatePercent").observe("blur", function() {
		if ($F("shortRatePercent") != "" ){
			if (parseFloat($F("shortRatePercent")) < 0.000000001 || parseFloat($F('shortRatePercent')) >  100.000000000 || isNaN(parseFloat($F('shortRatePercent')))) {
				$("shortRatePercent").clear();
				showMessageBox("Entered short rate percent is invalid. Valid value is from 0.000000001 to 100.000000000.", imgMessage.ERROR);
			}	
		}
	});	
	
	function computeNoOfDays2(startDate,endDate,compSwAddtl)	{
		var noOfDays = "";
		if (startDate == "" || endDate == "") {
			return noOfDays;
		} else {
			var addtl = 0;
			if ("Y" == compSwAddtl) {
				addtl = 1;
			} else if ("M" == compSwAddtl) {
				addtl = -1;
			}
			var iDateArray = startDate.split("-");
			var iDate = new Date();
			var date = parseInt(iDateArray[1], 10);
			var month = parseInt(iDateArray[0], 10);
			var year = parseInt(iDateArray[2], 10);
			iDate.setFullYear(year, month-1, date);

			var eDateArray = endDate.split("-");
			var eDate = new Date();
			var edate = parseInt(eDateArray[1], 10);
			var emonth = parseInt(eDateArray[0], 10);
			var eyear = parseInt(eDateArray[2], 10);
			eDate.setFullYear(eyear, emonth-1, edate);

			var oneDay = 1000*60*60*24;
			noOfDays = Math.floor((parseInt(Math.floor(eDate.getTime() - iDate.getTime()))/oneDay)) + addtl;
		}
		return (isNaN(noOfDays) ? "" : noOfDays);
	}
	
	function defaultDOE() {
		var iDateArray = $F("doi").split("-");
		if (iDateArray.length > 1)	{
			var iDate = new Date();
			var date = parseInt(iDateArray[1], 10);
			var month = parseInt(iDateArray[0], 10) + 12;
			var year = parseInt(iDateArray[2], 10);
			if (month > 12) {
				month -= 12;
				year += 1;
			}
			$("defaultDoe").value = (month < 10 ? "0"+month : month) +"-"+(date < 10 ? "0"+date : date)+"-"+year;
			$("defaultDoe").focus();
		}
	}
	
	var preCompSw;
	$("compSw").observe("click", function () {
		if(checkPostedBinder()){ 
			showWaitingMessageBox("You cannot update Prorate Condition. PAR has posted binder.", imgMessage.ERROR, 
					function(){
								changeTag = 0;
							  });
			return false;
		}
		preCompSw = $("compSw").value;
	});
	
	$("compSw").observe("focus", function () {
		preCompSw = $("compSw").value;
	});
	
	$("compSw").observe("change", function () {			
		if(checkPostedBinder()){
			showWaitingMessageBox("You cannot update Prorate Condition. PAR has posted binder.", imgMessage.ERROR, 
					function(){
								changeTag = 0;
								$("compSw").value = preCompSw;
							  });
			return false;
		}
		var noOfDays = $("noOfDays2").value;
		$("noOfDays2").value = computeNoOfDays2($F("doi"),$F("doe"),$F("compSw"));
		computeNoOfDays();
		//$("noOfDays").value = computeNoOfDays2($F("doi"),$F("doe"),$F("compSw"));
		//$("validateTag").selectedIndex = 0;
		if (parseInt($("noOfDays2").value) < 0 && $F("compSw") == "M"){
			showMessageBox("Tagging of -1 day will result to invalid no. of days. Changing is not allowed.", imgMessage.ERROR);
			$("noOfDays2").value = noOfDays ;
			$("compSw").value = preCompSw;
		}
		var preDoe = $("doe").value; 
		var incept = makeDate($F("doi"));
		var exp = makeDate($F("doe"));	
		if (exp<incept){
			$("doe").value = preDoe;
			customShowMessageBox("Expiry date is invalid. Expiry date must be later than Inception date.", imgMessage.ERROR, "compSw");
			return false;
		}		
	});	
	
	$("prorateFlag").observe("focus", function(){
		prevProrate = $F("prorateFlag");
	});
	
	function checkPostedBinder(){ 
		var vExists = false;	
		new Ajax.Request(contextPath+"/GIPIWinvoiceController",{
				parameters:{
					action: "checkForPostedBinders",
					parId : $F("parId")
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
	
	$("prorateFlag").observe("change",function() {
		var tempProrateFlag = $("prorateFlag").options[(nvl($("paramProrateFlag").value,2) - 1)].text;
		if ($("deleteBillSw").value == "N") {
			if ($F("gipiWInvoiceExist") == "1"){
				if ($("prorateFlag").value != $("paramProrateFlag").value) {
					if(checkPostedBinder()){
						showWaitingMessageBox("You cannot update Condition. PAR has posted binder.", imgMessage.ERROR, 
								function(){
											$("deleteBillSw").value = "N";
											$("prorateFlag").value = $("paramProrateFlag").value;
											$("prorateFlag").focus();
											showProrateRelatedSpan();
										  });
						return false;
					}
					showConfirmBox("Message", "You have changed your policy term from "
									+ tempProrateFlag
									+ " to "
									+ $("prorateFlag").options[$("prorateFlag").selectedIndex].text
									+ ". Will now do the necessary changes.",
									"Ok", "Cancel", onOkFunc,onCancelFunc);
				}
			}
		}
		function onOkFunc() {
			$("deleteBillSw").value = "Y";
			$("deleteWorkingDistSw").value = "Y";
		}
		function onCancelFunc() {
			$("deleteBillSw").value = "N";
			$("prorateFlag").value = $("paramProrateFlag").value;
			$("prorateFlag").focus();
			showProrateRelatedSpan();
		}
	});
	
	$("shortRatePercent").observe("blur", function() {
		if ($("deleteBillSw").value == "N" && $F("shortRatePercent") != "") {
			if ($F("gipiWInvoiceExist") == "1"){
				if ($F("shortRatePercent") != $F("paramShortRatePercent")) {
					if(checkPostedBinder()){ 
						showWaitingMessageBox("You cannot update Short Rate Percentage. PAR has posted binder.", imgMessage.ERROR, 
								function(){
											changeTag = 0;
											$("shortRatePercent").value = $F("paramShortRatePercent");
											$("deleteBillSw").value = "N";
										  });
						return false;
					}
					showConfirmBox(
							"Message",
							"You have updated short rate percent from "
									+ $("paramShortRatePercent").value
									+ " to "
									+ formatToNineDecimal($("shortRatePercent").value)
									+ ". Will now do the necessary changes.",
							"Ok", "Cancel", onOkFunc,
							onCancelFunc);
				}
			}
		}
		function onOkFunc() {
			$("deleteBillSw").value = "Y";
			$("deleteWorkingDistSw").value = "Y";
		}
		function onCancelFunc() {
			$("shortRatePercent").value = $F("paramShortRatePercent");
			$("deleteBillSw").value = "N";
		}
	});
	
	$("compSw").observe("focus", function(){
		$("paramNoOfDays2").value = $F("noOfDays2");
	});
	
	$("compSw").observe("change",function() {
		if(checkPostedBinder()){
			showWaitingMessageBox("You cannot update Prorate Condition. PAR has posted binder.", imgMessage.ERROR, 
					function(){
								changeTag = 0;
								$("compSw").value = ('${gipiWPolbas.compSw}');
								$("noOfDays2").value = computeNoOfDays2($F("doi"),$F("doe"), $F("compSw"));
								$("deleteBillSw").value = "N";
							  });
			return false;
		}
		if ($F("deleteBillSw") == "N") {
			if ($F("gipiWInvoiceExist") == "1"){
				if ($F("noOfDays2") != $F("paramNoOfDays2")) {
					showConfirmBox(
							"Message",
							"You have changed the computation for the policy no of days. Will now do the necessary changes.",
							"Ok", "Cancel", onOkFunc,
							onCancelFunc);
				}
			}
		}
		function onOkFunc() {
			$("deleteBillSw").value = "Y";
			$("deleteWorkingDistSw").value = "Y";
		}
		function onCancelFunc() {
			$("compSw").value = ('${gipiWPolbas.compSw}');
			$("noOfDays2").value = computeNoOfDays2($F("doi"),$F("doe"), $F("compSw"));
			$("deleteBillSw").value = "N";
		}
	});
	
	$("noOfDays").observe("focus", function(){
		$("paramNoOfDays").value = $F("noOfDays");
	});

	$("noOfDays").observe("blur", function() {
		if ($F("deleteBillSw") == "N") {
			if ($F("gipiWInvoiceExist") == "1"){
				if ($F("noOfDays") != $F("paramNoOfDays")) {
					if(checkPostedBinder()){ 
						showWaitingMessageBox("You cannot update Number of Days. PAR has posted binder.", imgMessage.ERROR, 
								function(){
											$("doe").value = $F("paramDoe");
											$("noOfDays").value = $F("paramNoOfDays");
											$("deleteBillSw").value = "N";
											changeTag = 0;
										  });
						return false;
					}
					showConfirmBox(
							"Message",
							"You have updated policy's no. of "
							        + ($("validateTag").value == "D" ? "days" : ($("validateTag").value == "M" ? "months" : "years"))
							        + " from "
									+ $("paramNoOfDays").value
									+ " to "
									+ $("noOfDays").value
									+ ". Will now do the necessary changes.",
							"Ok", "Cancel", onOkFunc,
							onCancelFunc);
				}
			}
		}
		function onOkFunc() {
			$("deleteBillSw").value = "Y";
			$("deleteWorkingDistSw").value = "Y";
			getNewExpiry();
		}
		function onCancelFunc() {
			$("doe").value = $F("paramDoe");
			$("noOfDays").value = $F("paramNoOfDays");
			$("noOfDays2").value = computeNoOfDays2($F("doi"),$F("doe"), $F("compSw"));
			$("deleteBillSw").value = "N";
		}
	});
	//end robert GENQA SR 4825 08.03.15
</script>