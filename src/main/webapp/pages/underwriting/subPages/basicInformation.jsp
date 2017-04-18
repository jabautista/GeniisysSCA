<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
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
<div class="sectionDiv" id="basicInformationDivOuter" style="float:left;" changeTagAttr="true">		
	<div id="basicInformationDiv" style="float:left; width: 81.5%; height: 300px;">		
		<div id="basicInformation" style="float:left; margin-top: 13px; width:47%;">
			<table align="center" cellspacing="1" border="0" width="100%">
	 			<tr>
					<td class="rightAligned" style="width: 108px;">PAR No. </td>
					<td class="leftAligned" style="width: 200px;"><input style="width: 220px; " id="parNo" name="parNo" type="text" value="${gipiParList.parNo }" readonly="readonly" class="required"/></td>	
				</tr>
				<tr id="rowSublineCd">	
					<td class="rightAligned">Subline</td>
				    <td class="leftAligned">
				    <input type="hidden" id="paramSubline" name="paramSubline" value="${gipiWPolbas.sublineCd }" class="required"/>
						<select id="sublineCd" name="sublineCd" style="float:left; width: ${parType eq 'P' ? '128px' :'228px'}; margin-right:5px;" class="required">
							<option value="" openPolicySw="" opFlag=""></option>
							<c:forEach var="s" items="${sublineListing}">
								<!-- shan 07.08.2013, SR-13491: added replace function to unescape & -->													
								<option openPolicySw="${s.openPolicySw }" opFlag="${s.opFlag }" value="${fn:escapeXml(s.sublineCd)}"				 
								<c:if test="${fn:replace(fn:replace(fn:replace(gipiWPolbas.sublineCd, '&#38;', '&'), '&#60;', '<'), '&#62;', '>') eq s.sublineCd}">
										selected="selected"
								</c:if>
								>${fn:escapeXml(s.sublineCd)} - ${fn:escapeXml(s.sublineName)}</option>
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
						<input class="integerNoNegativeUnformattedNoComma required" style="float:left; width: ${parType eq 'P' ? '120px' :'220px'}; text-align:center; margin-right:5px;" id="manualRenewNo" name="manualRenewNo" type="text" value="<fmt:formatNumber pattern="00">${gipiWPolbas.manualRenewNo}</fmt:formatNumber>" maxlength="2" errorMsg="Entered manual renew no. is invalid. Valid value is from 00 to 99."/>
						<input type="hidden" id="renewNo" name="renewNo" value="${gipiWPolbas.renewNo }<c:if test="${empty gipiWPolbas.renewNo}">0</c:if>" maxlength="2" />
						<input type="hidden" id="paramRenewNo" name="paramRenewNo" value="${gipiWPolbas.renewNo }<c:if test="${empty gipiWPolbas.renewNo}">0</c:if>" maxlength="2" />
						<c:if test="${parType eq 'P'}">
							<input style="float:left;" disabled="disabled" type="checkbox" id="discountSw" name="discountSw" value="Y" 
							<c:if test="${gipiWPolbas.discountSw eq 'Y' }">
									checked="checked"
							</c:if>/>
							<label style="float:left; margin-left:5px;" for="discountSw" title="W/ Discount">W/ Discount</label>
						</c:if>	
					</td>	
				</tr>
				<c:if test="${parType eq 'P'}">
					<tr>	
						<td class="rightAligned">Policy Status </td>
					    <td class="leftAligned">
					    <input type="hidden" id="paramPolicyStatus" name="paramPolicyStatus" value="${gipiWPolbas.polFlag }" />
							<select id="policyStatus" name="policyStatus" style="width: 228px;" class="required">
								<c:forEach var="ps" items="${policyStatusListing}">
									<option value="${ps.rvLowValue}"
									<c:if test="${gipiWPolbas.polFlag eq ps.rvLowValue}">
											selected="selected"
									</c:if>
									>${ps.rvMeaning}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
				</c:if>
				<c:if test="${parType eq 'E'}">
					<tr>
						<td class="rightAligned" style="width: 108px;">Policy No. </td>
						<td class="leftAligned" style="width: 220px;">
							<input style="width: 175px; " id="policyNo" name="policyNo" type="text" value="${policyNo }" readonly="readonly" class="required"/>
							<input type="button" class="button" style="width: 40px; height: 20px; " id="btnEditPolicyNo" name="btnEditPolicyNo" value="Edit" />
						</td>
					</tr>
				</c:if>
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
						<%-- <input style="width: 220px;" id="address1" name="address1" type="text" value="${gipiWPolbas.address1}" maxlength="50" class="required"/> bonok :: 10.04.2012 para malagyan ng unescapeHTML2 yung mga address --%>
						<input style="width: 220px;" id="address1" name="address1" type="text" maxlength="50" class="required"/>
					</td>	
				</tr>
				<tr>	
					<td>&nbsp;</td>
					<td class="leftAligned">
						<%-- <input style="width: 220px;" id="address2" name="address2" type="text" value="${gipiWPolbas.address2}" maxlength="50" /> bonok :: 10.04.2012 --%>
						<input style="width: 220px;" id="address2" name="address2" type="text" maxlength="50" />
					</td>	
				</tr>
				<tr>
					<td>&nbsp;</td>	
					<td class="leftAligned">
						<%-- <input style="width: 220px;" id="address3" name="address3" type="text" value="${gipiWPolbas.address3}" maxlength="50" /> bonok :: 10.04.2012 --%>
						<input style="width: 220px;" id="address3" name="address3" type="text" maxlength="50" />
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
							
							<c:if test="${issCd eq 'RI'}"><!-- added by christian - 03.14.2013 -->
								<c:forEach var="creditingBranchListing" items="${branchSourceListing2}">
									<option regionCd="${creditingBranchListing.regionCd}" value="${creditingBranchListing.issCd}"
									<c:if test="${gipiWPolbas.issCd eq creditingBranchListing.issCd}">
										selected="selected"
									</c:if>>${creditingBranchListing.issName}</option>				
								</c:forEach>
							</c:if>
						</select>
					</td>
				</tr>
				<c:if test="${parType eq 'E'}">
					<tr>
						<td class="rightAligned" style="width: 108px;">Bank Ref No.</td>
						<td class="leftAligned"><input style="width: 220px; " id="bankRefNo" name="bankRefNo" type="text" value="${gipiWPolbas.bankRefNo }" readonly="readonly"/></td>	
					</tr>
				</c:if>
			</table>
		</div>
		
		<div id="basicInformation" style="float:left; margin-top: 11px; margin-left: 10px; width:51%;">
			<table align="left" cellspacing="1" border="0" width="100%">
				<tr>
					<td class="rightAligned" ${parType eq 'E' ? "style='width:120px;'" :"style='width:190px;'"}>Assured Name </td>
					<td class="leftAligned">
						<!-- <input id="oscm" name="oscm" class="button" type="button" value="Search" />  -->
						<div style="width: 226px;" class="required withIconDiv">
							<input style="width: 200px;" id="assuredName" name="assuredName" type="text" value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.dspAssdName}</c:if>" readonly="readonly" class="required withIcon" prevAssdNo=""/> <!-- modified by Daniel Marasigan SR 2169 -->
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmDate" name="oscmDate" alt="Go" />
						</div>
						<!-- <input id="assuredNo" name="assuredNo" type="hidden" value="${gipiWPolbas.assdNo}" />  -->
						<c:choose>
							<c:when test="${isPack eq 'Y'}">
								<c:choose>
									<c:when test="${gipiWPolbas.credBranch eq 'RI'}">
										<c:choose>
											<c:when test="${confirmResult eq '1'}">
												<input id="assuredNo" name="assuredNo" type="hidden" value="${newAssdNo}" />
												<input id="paramAssuredNo" name="paramAssuredNo" type="hidden" value="${newAssdNo}" />			
											</c:when>
											<c:otherwise>
												<c:choose>	
													<c:when test="${parType eq 'E'}">
														<input id="assuredNo" name="assuredNo" type="hidden" value="${gipiParList.assdNo}" />
														<input id="paramAssuredNo" name="paramAssuredNo" type="hidden" value="${gipiParList.assdNo}" />	
													</c:when>
													<c:otherwise>
														<input id="assuredNo" name="assuredNo" type="hidden" value="${gipiWPolbas.assdNo}" />
														<input id="paramAssuredNo" name="paramAssuredNo" type="hidden" value="${gipiWPolbas.assdNo}" />	
													</c:otherwise>
												</c:choose>
											</c:otherwise>
										</c:choose> 
									</c:when> 
									<c:otherwise>
										<c:choose>	
											<c:when test="${parType eq 'E'}">
												<input id="assuredNo" name="assuredNo" type="hidden" value="${gipiParList.assdNo}" />
												<input id="paramAssuredNo" name="paramAssuredNo" type="hidden" value="${gipiParList.assdNo}" />	
											</c:when>
											<c:otherwise>
												<input id="assuredNo" name="assuredNo" type="hidden" value="${gipiWPolbas.assdNo}" />
												<input id="paramAssuredNo" name="paramAssuredNo" type="hidden" value="${gipiWPolbas.assdNo}" />	
											</c:otherwise>
										</c:choose>
									</c:otherwise>
								</c:choose>
							</c:when>
							<c:otherwise>
								<c:choose>
									<c:when test="${gipiWPolbas.issCd eq 'RI'}">
										<c:choose>
											<c:when test="${confirmResult eq '1'}">
												<input id="assuredNo" name="assuredNo" type="hidden" value="${newAssdNo}" />
												<input id="paramAssuredNo" name="paramAssuredNo" type="hidden" value="${newAssdNo}" />			
											</c:when>
											<c:otherwise>
												<c:choose>	
													<c:when test="${parType eq 'E'}">
														<input id="assuredNo" name="assuredNo" type="hidden" value="${gipiParList.assdNo}" />
														<input id="paramAssuredNo" name="paramAssuredNo" type="hidden" value="${gipiParList.assdNo}" />	
													</c:when>
													<c:otherwise>
														<input id="assuredNo" name="assuredNo" type="hidden" value="${gipiWPolbas.assdNo}" />
														<input id="paramAssuredNo" name="paramAssuredNo" type="hidden" value="${gipiWPolbas.assdNo}" />	
													</c:otherwise>
												</c:choose>
											</c:otherwise>
										</c:choose> 
									</c:when> 
									<c:otherwise>
										<c:choose>	
											<c:when test="${parType eq 'E'}">
												<input id="assuredNo" name="assuredNo" type="hidden" value="${gipiParList.assdNo}" />
												<input id="paramAssuredNo" name="paramAssuredNo" type="hidden" value="${gipiParList.assdNo}" />	
											</c:when>
											<c:otherwise>
												<input id="assuredNo" name="assuredNo" type="hidden" value="${gipiWPolbas.assdNo}" />
												<input id="paramAssuredNo" name="paramAssuredNo" type="hidden" value="${gipiWPolbas.assdNo}" />	
											</c:otherwise>
										</c:choose>
									</c:otherwise>
								</c:choose>
							</c:otherwise>
						</c:choose>							
						<input style="width: 200px;" id="paramAssuredName" name="paramAssuredName" type="hidden" value="${gipiWPolbas.dspAssdName}" readonly="readonly" />						
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
				    	<c:if test="${parType eq 'E'}">
				    		<input type="checkbox" id="deleteSw" name="deleteSw" value="Y" title="Delete Sw" />
				    		<input type="checkbox" id="labelTag" name="labelTag" value="Y" title="Leased To Tag" />		    		
				    	</c:if>
				    	<c:if test="${parType eq 'P'}">
				    		<input type="checkbox" id="labelTag" name="labelTag" value="Y" title="Leased To Tag" <c:if test="${gipiWPolbas.labelTag eq 'Y' }">checked="checked"</c:if>/>
				    	</c:if>	
				    	<input id="acctOfCd" name="acctOfCd" type="hidden" value="${gipiWPolbas.acctOfCd}" />				    					    	
				    </td>
				</tr>
				<c:if test="${parType eq 'E'}">
					<tr>
						<td class="rightAligned" style="width: 108px;">Endt No. </td>
						<td class="leftAligned"><input style="width: 220px; " id="endtNo" name="endtNo" type="text" value="
							<c:if test="${not empty gipiWPolbas }">
								${gipiWPolbas.lineCd } - ${gipiWPolbas.sublineCd } - ${gipiWPolbas.endtIssCd } - ${gipiWPolbas.endtYy }
							</c:if>
							" readonly="readonly" class="required"/></td>	
					</tr>
				</c:if>
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
										onClick="null<!-- scwShow($('issueDate'),this, null); commented out edgar 01/29/2015-->"
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
						<input style="width: 220px;" id="referencePolicyNo" name="referencePolicyNo" type="text" value="${gipiWPolbas.refPolNo}" maxlength="30" />
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
							<!-- marco - 06.18.2014 - escape HTML tags -->
							<c:forEach var="r" items="${regionListing}">
								<option value="${r.regionCd}"
								<c:if test="${gipiWPolbas.regionCd eq r.regionCd}">
										selected="selected"
								</c:if>
								>${fn:escapeXml(r.regionDesc)}</option>
							</c:forEach>
						</select>
					</td>
				</tr>	
				<c:if test="${parType eq 'P' and ora2010Sw eq 'Y'}">
				<tr>	
					<td class="rightAligned">Package Plan <input type="checkbox" id="packPLanTag" name="packPLanTag" value="Y" <c:if test="${gipiWPolbas.planSw eq 'Y'}">checked="checked"</c:if>/></td>
				    <td class="leftAligned">
						<select id="selPlanCd" name="selPlanCd" style="width: 228px;">
							<option value=""></option>
						</select>
					</td>
				</tr>
				<tr>	
					<td class="rightAligned">Bancassurance <input type="checkbox" id="bancaTag" name="bancaTag" value="Y" <c:if test="${gipiWPolbas.bancassuranceSw eq 'Y'}">checked="checked"</c:if> originalValue="${gipiWPolbas.bancassuranceSw}" /></td>
				    <td class="leftAligned">
						<input type="button" class="button noChangeTagAttr" id="btnBancaDetails" name="btnBancaDetails" value="Bancassurance Details" />
					</td>
				</tr>
				</c:if>
			</table>
		</div>
	</div>
	
	<div id="basicInformationDivRightOuter" style="border-left:1px solid #E0E0E0; float:right; width: 18%; height: <c:if test="${parType ne 'E'}">300px;</c:if><c:if test="${parType eq 'E'}">300px;</c:if>">
		<c:if test="${parType ne 'E'}">
			<div id="basicInformationDivR" style="float:right; width: 100%;">
				<label style="padding:2px; width: 100%; text-align: center; font-weight: bold;">Status</label>
			</div>
			
			<div id="basicInformationDivR" style="border-top:1px solid #E0E0E0; float:left; width: 100%;">
				<table align="left" >
				<tr>
					<td class="leftAligned"><input type="checkbox" id="quotationPrinted" name="quotationPrinted" value="Y"
					<c:if test="${gipiWPolbas.quotationPrintedSw eq 'Y' }">
								checked="checked"
					</c:if>/></td>
					<td class="leftAligned"><label for="quotationPrinted">Quotation Printed</label></td>
				</tr>
				<tr>
					<td class="leftAligned"><input type="checkbox" id="covernotePrinted" name="covernotePrinted" value="Y" 
					<c:if test="${gipiWPolbas.covernotePrintedSw eq 'Y' }">
								checked="checked"
					</c:if>/></td>
					<td class="leftAligned"><label for="covernotePrinted">Covernote Printed</label></td>
				</tr>
				</table>
			</div>
		</c:if>		
		
		<div id="basicInformationDivR" style="border-top:1px solid #E0E0E0; float:left; width: 100%;">
			<label style="padding:2px; width: 100%; text-align: center; font-weight: bold;">Type</label>
		</div>
		<c:choose>
			<c:when test="${parType ne 'E'}">
				<div id="basicInformationDivR" style="border-top:1px solid #E0E0E0; float:left; width: 100%;">
					<table align="left" >
						<tr>
							<td class="leftAligned"><input type="checkbox" id="packagePolicy" name="packagePolicy" value="Y"
								<c:if test="${gipiWPolbas.packPolFlag eq 'Y' }">checked="checked"</c:if>/>
							</td>
							<td class="leftAligned"><label for="packagePolicy">Package Policy</label></td>
						</tr>
						<tr>
							<td class="leftAligned"><input type="checkbox" id="autoRenewal" name="autoRenewal" value="Y" 
								<c:if test="${gipiWPolbas.autoRenewFlag eq 'Y' }">checked="checked"</c:if>/>
							</td>
							<td class="leftAligned"><label for="autoRenewal">Auto Renewal</label></td>
						</tr>
						<tr>
							<td class="leftAligned"><input type="checkbox" id="foreignAccount" name="foreignAccount" value="Y" 
								<c:if test="${gipiWPolbas.foreignAccSw eq 'Y' }">checked="checked"</c:if>/>
							</td>
							<td class="leftAligned"><label for="foreignAccount">Foreign Account</label></td>
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
							<td class="leftAligned"><label for="premWarrTag">W/ Prem. Warranty</label></td>
						</tr>
						<tr style="display: <c:if test="${isPack eq 'Y'}">none;</c:if>">
							<td class="leftAligned">&nbsp;</td>
							<td class="leftAligned"><input style="width: 90px;" id="premWarrDays" name="premWarrDays" type="text" value="${gipiWPolbas.premWarrDays }" maxlength="3" disabled="disabled" class="integerNoNegativeUnformattedNoComma" errorMsg="Entered premium warranty days is invalid. Valid value is from 1 to 999"/></td>
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
						<c:if test="${isPack eq 'Y'}">
							<tr>
								<td class="leftAligned"><input type="checkbox" id="agreedTag" name="agreedTag" value="Y" 
									<c:if test="${gipiWPolGenin.agreedTag eq 'Y' }">checked="checked"</c:if>/>
								</td>
								<td class="leftAligned"><label for="agreedTag">Agreed Tag</label></td>
							</tr>
						</c:if>
					</table>
				</div>
				<div id="basicInformationDivR" style="border-top:1px solid #E0E0E0; float:left; width: 100%; height:61px;">
					<table align="left" >
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
			</c:when>
			<c:when test="${parType eq 'E'}">
				<div id="basicInformationDivR" style="border-top:1px solid #E0E0E0; float:left; width: 100%;">
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
				<div id="basicInformationDivR" style="border-top:1px solid #E0E0E0; float:left; width: 100%;">
					<label style="padding:2px; width: 100%; text-align: center; font-weight: bold;">Cancellation</label>
				</div>
				<div id="basicInformationDivR" style="border-top:1px solid #E0E0E0; float:left; width: 100%;">
					<table align="left">
						<tr>
							<td class="leftAligned"><input type="checkbox" id="nbtPolFlag" name="nbtPolFlag" value="4"
								<%-- <c:if test="${gipiWPolbas.polFlag eq '4' }">checked="checked"</c:if> --%>/>
							</td>
							<td class="leftAligned"><label for="nbtPolFlag">Cancelled (Flat)</label></td>
						</tr>
						<tr>
							<td class="leftAligned"><input type="checkbox" id="prorateSw" name="prorateSw" value="1" 
								<%-- <c:if test="${gipiWPolbas.prorateFlag eq '1' }">checked="checked"</c:if> --%>/>
							</td>
							<td class="leftAligned"><label for="prorateSw">Cancelled</label></td>
						</tr>
						<tr style="display: <c:if test="${isPack eq 'Y'}">none</c:if>">
							<td class="leftAligned"><input type="checkbox" id="endtCancellation" name="endtCancellation" value="N" /></td>
							<td class="leftAligned"><label for="endtCancellation">Endt Cancellation</label></td>
						</tr>
						<tr style="display: <c:if test="${isPack eq 'Y'}">none</c:if>">
							<td class="leftAligned"><input type="checkbox" id="coiCancellation" name="coiCancellation" value="N" /></td>
							<td class="leftAligned"><label for="coiCancellation">COI Cancellation</label></td>
						</tr>
						<br />
						<tr>
							<td colspan="2" align="center"><input type="button" id="btnCancelEndt" name="btnCancelEndt" class="
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
			</c:when>
		</c:choose>		
	</div>	
</div>

<script>
 	if('${confirmResult}' == 1){
 		$("address1").value = unescapeHTML2('${newAddress1}');
 		$("address2").value = unescapeHTML2('${newAddress2}');
 		$("address3").value = unescapeHTML2('${newAddress3}');
 	}else{
		$("address1").value = unescapeHTML2('${gipiWPolbas.address1}'); // bonok :: 10.04.2012
		$("address2").value = unescapeHTML2('${gipiWPolbas.address2}');
		$("address3").value = unescapeHTML2('${gipiWPolbas.address3}'); 
 	}
	var wpolbasPolFlag = '${gipiWPolbas.polFlag}';
	var wpolbasProrateSw = '${gipiWPolbas.prorateFlag}';
	var prevprovPremRate; //edgar 01/29/2015
	var prevIssueDate = $("issueDate").value; //edgar 01/29/2015
	var prevAssured = $("assuredName").value; //edgar 01/29/2015
	
	if(wpolbasPolFlag == '4' && wpolbasProrateSw != '1') {
		$("nbtPolFlag").checked = true;
		$("prorateSw").checked = false;
		if('${isPack}' == 'Y') $("clickCancelledFlat").value = "Y";
	}
	
	if(wpolbasProrateSw == '1' && wpolbasPolFlag != '4' && "${parType}" == 'E') { //"${parType}" added by jeffdojello 01.07.2014. Causes page to malfunction when par is prorated (not endt)
		$("nbtPolFlag").checked = false;
		$("prorateSw").checked = true;
	}

	objItemNoList = eval([{"0" : 0}]);
	if (objUWParList.assdName != null){ //added this condition by steven 1/9/2013 to solve the issue on SR 0011877
		$("assuredName").value = unescapeHTML2(objUWParList.assdName);
	}
	 
	//for search button in In Account Of
	//added showInAccountOf by reymon 04182013
	//if the policy type is package endorsement
	$("osaoDate").observe("click", function()	{
		/* commented out older lov for policy creation was slow reused lov used by Endt MarkS SR5684 10.12.2016 */
		/* if ("${parType}" == "P"){  
			openSearchAccountOf();
		}else if ("${parType}" == "E"){ 
			showInAccountOf();	
		}*/ 
		/* commented out older lov for policy creation was slow reused lov used by Endt MarkS SR5684 10.12.2016*/		
		showInAccountOf(); /* added by MarkS SR5677 10.12.2016 */
		//var assdNo = $("assuredNo").value;
		//var keyword = $("inAccountOf").value;
		//openSearchAccountOf2(assdNo,keyword);
	});
	
	// bonok :: 12.28.2016 :: SR 23622
	var issCd = nvl(objUWGlobal.issCd, "XX");
	
 	//if('${confirmResult}' == 1){
 	if('${confirmResult}' == 1 && issCd == "RI"){ // bonok :: 12.28.2016 :: SR 23622
		$("address1").value = unescapeHTML2('${newAddress1}');
		$("address2").value = unescapeHTML2('${newAddress2}');
		$("address3").value = unescapeHTML2('${newAddress3}');
	}else{
		$("address1").value = unescapeHTML2('${gipiWPolbas.address1}');
		$("address2").value = unescapeHTML2('${gipiWPolbas.address2}');
		$("address3").value = unescapeHTML2('${gipiWPolbas.address3}');
	}
	$("assuredName").value = unescapeHTML2($F("assuredName"));
	$("referencePolicyNo").value = unescapeHTML2('${gipiWPolbas.refPolNo}');

	//for search button in Assured Name
	//added showValidAssuredListingTG by reymon 04182013
	//if the policy type is package endorsement
	$("oscmDate").observe("click", function ()	{
		if (!objUWGlobal.packParId > 0) { // Dren 11.11.2015 SR-0020613 : Cannot change Assured in Pack Endt. 
			if(checkPostedBinder()){ // to check for posted binder edgar 01/29/2015
				$("assuredName").value = prevAssured;
				showWaitingMessageBox("You cannot change the Assured. PAR has posted binder.", imgMessage.ERROR, 
						function(){
									changeTag = 0;
								  });
				return false;
			}
		} // Dren 11.11.2015 SR-0020613 : Cannot change Assured in Pack Endt.
		// removed condition by robert 01.28.2015, same function will be called regardless of policy type
		//if ("${parType}" == "P"){ 
		//	openSearchClientModal();
		//}else if ("${parType}" == "E"){
			showValidAssuredListingTG($F("assuredNo"));	
		//}
	});	
	
	$("assuredName").observe("focus", function ()	{//edgar 01/30/2015
		prevAssured = $("assuredName").value;
	});
	
	$("inAccountOf").observe("blur", function () {
		if ($("inAccountOf").value == "") {
			$("acctOfCd").value = "";
		}	
	});		
	
	if(objUW.hidObjGIPIS002.updCredBranch != "Y") {
		if ($("creditingBranch").value != ""){
			$("creditingBranch").disable();
		}
	}
	
	if (objUW.hidObjGIPIS002.reqCredBranch == "Y"){
		/* Apollo 07.24.2015 SR# 2749
		Crediting Branch must be required regardless of the value of DEFAULT_CRED_BRANCH when MANDATORY_CRED_BRANCH = Y */
		//if (objUW.hidObjGIPIS002.defCredBranch == "ISS_CD"){
			$("creditingBranch").addClassName("required");
		//}	
	}	

	if($F("issCd") == "RI"){ //added by christian 03/08/2013
		$("creditingBranch").disable();
		$("creditingBranch").value = "RI";
	}
	
	// KRis 07.04.2013 for UW-SPECS-2013-091: 
	// to display the default crediting branch if parameter is set to Y. If default crediting branch is null, display blank.
	if($F("creditingBranch") == "" && objUW.hidObjGIPIS002.dispDefaultCredBranch == "Y"){
		if(objUW.hidObjGIPIS002.defCredBranch == "ISS_CD"){
			$("creditingBranch").value = objUW.hidObjGIPIS002.issCdB540; //objUW.GIPIS031.gipiWPolbas.issCd
		} else if(objUW.hidObjGIPIS002.defaultCredBranch == "ISS_CD"){
			$("creditingBranch").value = objUWGlobal.issCd;
		}
	}
	
	if($F("parType") != "E"){
		if (objUW.hidObjGIPIS002.reqRefPolNo == "Y"){
			$("referencePolicyNo").addClassName("required");
		}
		
		if(objUW.hidObjGIPIS002.reqRefNo == "Y" && objUW.hidObjGIPIS002.ora2010Sw == "Y"){ //added by Jdiago 09.09.2014 (06162015 - Gzelle - added ora2010sw SR3866)
			$("nbtAcctIssCd").addClassName("required");
			$("nbtBranchCd").addClassName("required");
			$("dspRefNo").addClassName("required");
			$("dspModNo").addClassName("required");
		}
		
		if ($F("premWarrTag") == 'Y') {
			$("premWarrDays").enable();
			$("premWarrDays").addClassName("required");
		}
		$("premWarrTag").observe("click", function(){
			if ($F("premWarrTag") == 'Y') {
				$("premWarrDays").enable();
				$("premWarrDays").focus();
				$("premWarrDays").addClassName("required");
			} else {
				$("premWarrDays").disable();
				$("premWarrDays").value = "";
				$("premWarrDays").removeClassName("required");
			}
		});
		
		//upon change of Provisional Premium checkbox
		$("provisionalPremium").observe("click", function(){
			if(checkPostedBinder()){ //added edgar 01/29/2015 to check for posted binder
				showWaitingMessageBox("You cannot Tag/Untag Provisional Premium. PAR has posted binder.", imgMessage.ERROR, 
						function(){
									if (!($("provisionalPremium").checked)){
										$("provisionalPremium").checked = true;
									}else if ($("provisionalPremium").checked){
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
			
		$("provPremRatePercent").observe("blur", function(){
			if ($F("provisionalPremium") == 'Y') {
				if ($F("provPremRatePercent") != ""){
					if (parseFloat($F("provPremRatePercent")) < 0 || parseFloat($F('provPremRatePercent')) >  100.000000000 || isNaN(parseFloat($F('provPremRatePercent')))) {
						$("provPremRatePercent").clear();
						showMessageBox("Entered provisional premium percent is invalid. Valid value is from 0.000000000 to 100.000000000.", imgMessage.ERROR);
					}	
				}
			}
		}); 
		
		$("provPremRatePercent").observe("focus", function () {
			prevprovPremRate = $("provPremRatePercent").value;
		});
		
		$("hrefIssueDate").observe("click", function(){
			prevIssueDate = $("issueDate").value; //edgar 02/04/2015
			if(checkPostedBinder()){ //added edgar 01/29/2015 to check for posted binder
				$("issueDate").value = prevIssueDate;
				showWaitingMessageBox("You cannot update Issue Date. PAR has posted binder.", imgMessage.ERROR, 
						function(){
									changeTag = 0;
								  });
				return false;
			}
			scwNextAction = validateIssueDate.runsAfterSCW(this, null); //edgar 02/04/2015
			scwShow($('issueDate'),this, null);
		});
		
		$("issueDate").observe("focus", function(){
			prevIssueDate = $("issueDate").value;
		});
		//ended edgar 01/29/2015
		
		//upon change of W/ Prem Warranty checkbox		
		$("premWarrDays").observe("blur", function(){
			if ($F("premWarrDays") != ""){
				if (parseInt($F("premWarrDays")) < 1 || parseInt($F("premWarrDays")) > 999){
					$("premWarrDays").clear();
					showMessageBox("Entered premium warranty days is invalid. Valid value is from 1 to 999.", imgMessage.ERROR);
				}	
			}	
		});	

		$("renewNo").observe("blur", function(){
			isNumber("renewNo","Please enter valid Renew no.","");
		});
	
		$("manualRenewNo").observe("blur", function(){
			$("manualRenewNo").value = $F("manualRenewNo") == "" ? "" :formatNumberDigits($F("manualRenewNo").replace(/,/g, ""),2);
		});

		if (objUW.hidObjGIPIS002.updIssueDate != "Y"){
			//$("hrefIssueDate").observe("click", function(){
			//	showMessageBox("Issue Date set-up is not updateable this time.",imgMessage.ERROR);
			//});
			disableDate("hrefIssueDate");
			
			//marco - 05.30.2013 - added condition
			if($F("globalIssCd") != objUW.hidObjGIPIS002.issCdRi){
				//added by jeffdojello 04.23.2013
				$("doe").observe("blur", function () {
					if ((makeDate($("doe").value) < makeDate($("issueDate").value)) && objUW.hidObjGIPIS002.allowExpiredPolicyIssuance == "N") { //added Kenneth L. 03.26.2014 condition for objUW.hidObjGIPIS002.allowExpiredPolicyIssuance
						showWaitingMessageBox("A policy cannot expire before the date of its issuance.", imgMessage.ERROR,
							function(){	
							      	$("doe").value ="";
									$("doe").focus();												  
							});
						return false;		
					}	
				});
				
				$("issueDate").observe("blur", function () {
					if ((makeDate($("doe").value) < makeDate($("issueDate").value)) && objUW.hidObjGIPIS002.allowExpiredPolicyIssuance == "N") { //added Kenneth L. 03.26.2014 condition for objUW.hidObjGIPIS002.allowExpiredPolicyIssuance
						showWaitingMessageBox("A policy cannot expire before the date of its issuance.", imgMessage.ERROR,
							function(){	
							    //added by jeffdojello 04.23.2013
							    //As per M' VJ, issue date field should be cleared out if date of expiration is less than issue date
							    var checkDate1 = $("issueDate").value == dateFormat(serverDate, "mm-dd-yyyy"); 
							    var checkDate2 = getPreTextValue("issueDate")== ""  || getPreTextValue("issueDate") == dateFormat(serverDate, "mm-dd-yyyy");
							    //if issue date is selected for the first time or equivalent to current date or previous expiry date is less than issue date
							    if(checkDate1 == checkDate2){
							    	$("issueDate").value ="";
									$("issueDate").focus();								
							    }
								else{
									$("issueDate").value = getPreTextValue("issueDate")== "" ? dateFormat(serverDate, "mm-dd-yyyy") :getPreTextValue("issueDate");
									$("issueDate").focus();
								}
							});
						return false;		
					}	
				});
			}
		}else{
			
			observeBackSpaceOnDate("issueDate");
			observeChangeTagOnDate("hrefIssueDate", "issueDate");
			
			//marco - 05.30.2013 - added condition
			if($F("globalIssCd") != objUW.hidObjGIPIS002.issCdRi){
				//added by jeffdojello 04.23.2013
				$("doe").observe("blur", function () {
					if ((makeDate($("doe").value) < makeDate($("issueDate").value)) && objUW.hidObjGIPIS002.allowExpiredPolicyIssuance == "N") { //added Kenneth L. 03.26.2014 condition for objUW.hidObjGIPIS002.allowExpiredPolicyIssuance
						showWaitingMessageBox("A policy cannot expire before the date of its issuance.", imgMessage.ERROR,
							function(){	
							      	$("doe").value ="";
									$("doe").focus();												  
							});
						return false;		
					}	
				});
				
				$("issueDate").observe("blur", function () {
					if ((makeDate($("doe").value) < makeDate($("issueDate").value)) && objUW.hidObjGIPIS002.allowExpiredPolicyIssuance == "N") { //added Kenneth L. 03.26.2014 condition for objUW.hidObjGIPIS002.allowExpiredPolicyIssuance
						showWaitingMessageBox("A policy cannot expire before the date of its issuance.", imgMessage.ERROR,
							function(){	
							    //added by jeffdojello 04.23.2013
							    //As per M' VJ, issue date field should be cleared out if date of expiration is less than issue date
							    var checkDate1 = $("issueDate").value == dateFormat(serverDate, "mm-dd-yyyy"); 
							    var checkDate2 = getPreTextValue("issueDate")== ""  || getPreTextValue("issueDate") == dateFormat(serverDate, "mm-dd-yyyy");
							    //if issue date is selected for the first time or equivalent to current date or previous expiry date is less than issue date
							    if(checkDate1 == checkDate2){
							    	$("issueDate").value ="";
									$("issueDate").focus();								
							    }
								else{
									$("issueDate").value = getPreTextValue("issueDate")== "" ? dateFormat(serverDate, "mm-dd-yyyy") :getPreTextValue("issueDate");
									$("issueDate").focus();
								}
							});
						return false;		
					}	
				});
			}
		}	
		observeBackSpaceOnDate("assuredName");
		observeChangeTagOnDate("oscmDate", "assuredName");
		observeBackSpaceOnDate("inAccountOf");
		observeChangeTagOnDate("osaoDate", "inAccountOf");
	}else if($F("parType") == "E"){
		/* the following lines are used for endorsement */	
		
		
		/* hide elements with regards to endorsement 
		$("rowEndtEffDate").setStyle("display : none;");
		$("rowEndtExpDate").setStyle("display : none;");
		*/
		
		//$("hrefIssueDate").observe("click", function(){
		//	scwShow($('issueDate'),this, null);
		//});

		if (objUW.hidObjGIPIS002.reqRefPolNo == "Y"){
			$("referencePolicyNo").addClassName("required");
		}
		
		if(objUW.hidObjGIPIS002.reqRefNo == "Y"  && objUW.hidObjGIPIS002.ora2010Sw == "Y"){ //added by Jdiago 09.09.2014 (06162015 - Gzelle - added ora2010sw SR3866)
			$("nbtAcctIssCd").addClassName("required");
			$("nbtBranchCd").addClassName("required");
			$("dspRefNo").addClassName("required");
			$("dspModNo").addClassName("required");
		}
		
		if (objUW.hidObjGIPIS002.updIssueDate != "Y"){
			disableDate("hrefIssueDate"); // added by: Nica 05.14.2012
		}
		
		//$("prorateSw").observe("click", function(){
		//	if($("prorateSw").checked){
		//		$("nbtPolFlag").checked = false;
		//	}else{
		//		//
		//	}
			
			/*
			if($("prorateSw").checked){
				var renewNo = $F("b540RenewNo").empty() ? "0" : $F("b540RenewNo");
				if( renewNo!= "0"){
					$("prorateSw").checked = false;
					showMessageBox("Renewed policy cannot be cancelled.");
					return false;
				}else{
					if($("endorseTax").checked){
						$("prorateSw").checked = false;
						showMessageBox("Prorate Cancellation is not allowed for endorsement of tax.");
						return false;
					}					
					checkForPolProrateFlagInterruption("ProrateFlag");
					if($F("stopper") > 0){						
						return false;
					}
				}
			}else{
				$("prorateSw").checked = false;
				new Ajax.Request(contextPath + "/GIPIParInformationController?action=testingProc", {
					method : "GET",
					parameters : {
						parId : $F("globalEndtParId")						
					},
					aysnchronous : false,
					evalScripts : true,
					onCreate : showNotice("Testing, please wait..."),
					onComplete : function(response){
						hideNotice("Done!");
						showMessageBox(response.responseText, imgMessage.INFO);
					}
				});		
			}
			*/		
		//});		
	
		function terminateExecution(paramValue){
			if(paramValue > 0){
				return false;
			}else{
				return true;
			}
		}
	
		/* mark jm 05.28.10
		** this function (checkForPolFlagInterruption) is used to check if there are alerts or confirmation to show
		** if true then show the alerts/confirmation
		*/
		function checkForPolProrateFlagInterruption(columnName){
			new Ajax.Request(contextPath + "/GIPIParInformationController?action=checkForPolProrateFlagInterruption", {
				method : "GET",
				parameters : {
					parId : $F("globalParId"),
					inceptDate : $F("doi"),
					effDate : $F("endtEffDate"),
					recordStatus : $F("recordStatus"),
					columnName : columnName == "PolFlag" ? "PolFlag" : "ProrateFlag"
				},
				asynchronous : false /*true*/,
				evalScripts : true,
				onCreate : showNotice("Validating item, please wait..."),
				onComplete :
					function(response){
						hideNotice("Done!");
						//var result = response.responseText.toQueryParams();
						var result = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
						
						if(result.compTrans == "FALSE"){
							showMessageBox(result.msgAlert, imgMessage.ERROR);						
							$("stopper").value = "1";
						}else{
							$("processStatus").value = (columnName == "PolFlag") ? "executeCheckPolFlagProcedures" : "executeCheckProrateFlagProcedures" ;
							if(nvl(result.msgAlert,null) != null && !(result.msgAlert.isUndefined())){								
								showConfirmBox("Endorsement",result.msgAlert, "Accept", "Cancel", continueProcess, stopProcess);							
							}else{
								continueProcess();
							}
						}					
					}
			});
		}

		function executeCheckPolFlagProcedures(){
			copyDateValues();				
			new Ajax.Request(contextPath + "/GIPIParInformationController?action=executeCheckPolFlagProcedures&endtEffDate="+$F("endtEffDate"), {
				method : "POST",
				postBody : Form.serialize("endtBasicInformationForm"),
				asynchronous : false /*true*/,
				evalScripts : true,
				onCreate : showNotice("Cancelling, please wait..."),
				onComplete :
					function(response){
						hideNotice("Done!");
						//var result = response.responseText.toQueryParams();
						var result = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
						
						if(nvl(result.msgAlert,null) != null){
							showMessageBox(result.msgAlert, imgMessage.ERROR);						
							$("stopper").value = "1";
						}else{							
							showMessageBox("Endorsement successfully cancelled.", imgMessage.INFO);	
							setShowHide("hrefDoiDate hrefDoeDate hrefEndtEffDate hrefEndtExpDate", "hide");
							setEnableDisable("prorateFlag", "disable");							
							$("endtEffDate").value = result.effDate.substr(0,result.effDate.indexOf(" ",0));
							$("b540EffDate").value = result.effDate;
							$("parStatus").value = result.parStatus;
							$("b240ParStatus").value = result.parStatus;
							$("b540TsiAmt").value = result.tsiAmt;
							$("b540PremAmt").value = result.premAmt;
							$("b540AnnTsiAmt").value = result.annTsiAmt;
							$("b540AnnPremAmt").value = result.annPremAmt;
							$("varExpiryDate").value = result.vExpiryDate;
							$("doi").value = result.inceptDate.substr(0,result.inceptDate.indexOf(" ",0));
							$("b540InceptDate").value = result.inceptDate;
							$("doe").value = result.expiryDate.substr(0,result.expiryDate.indexOf(" ",0));
							$("b540ExpiryDate").value = result.expiryDate;
							$("endtExpDate").value = result.endtExpiryDate.substr(0,result.endtExpiryDate.indexOf(" ",0));
							$("b540EndtExpiryDate").value = result.endtExpiryDate;
							$("prorateSw").checked = false;
							$("b540ProrateFlag").value = result.prorateFlag;
							switch(result.prorateFlag){
								case "1" : $("prorateFlag").selectedIndex = 0; break;
								case "2" : $("prorateFlag").selectedIndex = 1; break;
								case "3" : $("prorateFlag").selectedIndex = 2; break; 
							}
							$("b540CompSw").value = result.compSw;
							$("b540polFlag").value = result.polFlag;
							$("nbtPolFlag").checked = true;
							$("b540CoiCancellation").value = result.coiCancellation;
							$("b540EndtCancellation").value = result.endtCancellation;
							$("varCnclldFlatFlag").value = result.vCnclldFlatFlag;														
						}						
				}
			});
		}

		function executeUncheckPolFlagProcedures(){
			new Ajax.Request(contextPath + "/GIPIParInformationController?action=executeUncheckPolFlagProcedures&endtEffDate="+$F("endtEffDate"), {
				method : "POST",
				postBody : Form.serialize("endtBasicInformationForm"),
				asynchronous : false /*true*/,
				evalScripts : true,
				onCreate : showNotice("Reverting, please wait..."),
				onComplete :
					function(response){
						hideNotice("Done!");
						//var result = response.responseText.toQueryParams();
						var result = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
						
						if(nvl(result.msgAlert,null) != null){
							showMessageBox(result.msgAlert, imgMessage.ERROR);						
							$("stopper").value = "1";
						}else{							
							showMessageBox("Endorsement successfully reverted.", imgMessage.INFO);
							setShowHide("hrefDoiDate hrefDoeDate hrefEndtEffDate hrefEndtExpDate", "show");
							setEnableDisable("prorateFlag", "enable");							
							$("globalCancellationType").value = "";
							$("endtEffDate").value = result.effDate.substr(0,result.effDate.indexOf(" ",0));
							$("b540EffDate").value = result.effDate;
							$("parStatus").value = result.parStatus;
							$("b240ParStatus").value = result.parStatus;
							$("b540AnnTsiAmt").value = result.annTsiAmt;
							$("b540AnnPremAmt").value = result.annPremAmt;
							$("prorateSw").checked = false;
							$("b540ProrateFlag").value = result.prorateFlag;
							$("b540polFlag").value = result.polFlag;
							$("nbtPolFlag").checked = true;
							$("varCnclldFlatFlag").value = result.vCnclldFlatFlag;							
						}						
				}
			});	
		}

		function executeCheckProrateFlagProcedures(){
			copyDateValues();				
			new Ajax.Request(contextPath + "/GIPIParInformationController?action=executeCheckProrateFlagProcedures&endtEffDate="+$F("endtEffDate"), {
				method : "POST",
				postBody : Form.serialize("endtBasicInformationForm"),
				asynchronous : false /*true*/,
				evalScripts : true,
				onCreate : showNotice("Cancelling, please wait..."),
				onComplete :
					function(response){
						hideNotice("Done!");
						//var result = response.responseText.toQueryParams();
						var result = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
						
						if(nvl(result.msgAlert,null) != null){
							showMessageBox(result.msgAlert, imgMessage.ERROR);						
							$("stopper").value = "1";
						}else{							
							showMessageBox("Endorsement successfully cancelled.", imgMessage.INFO);
							setShowHide("hrefDoiDate hrefDoeDate hrefEndtExpDate", "show");							
							$("endtEffDate").value = result.effDate.substr(0,result.effDate.indexOf(" ",0));
							$("b540EffDate").value = result.effDate;							
							$("b540AnnTsiAmt").value = result.annTsiAmt;
							$("b540AnnPremAmt").value = result.annPremAmt;							
							$("prorateSw").checked = true;
							$("b540ProrateFlag").value = result.prorateFlag;
							$("b540CompSw").value = result.compSw;
							$("b540polFlag").value = result.polFlag;
							$("nbtPolFlag").checked = false;
							$("b540CoiCancellation").value = result.coiCancellation;
							$("b540EndtCancellation").value = result.endtCancellation;
							$("varCnclldFlag").value = result.vCnclldFlag;							
						}
				}
			});
		}

		function setShowHide(arrElement, showHide){
			// arrElement contains the name of the elements you want to hide/unhide
			// arrElement should be space separated in able to produce an array
			var elems = $w(arrElement);
			if(showHide == "hide"){
				for (var index=0, length=elems.length; index < length; index++){					
					$(elems[index]).hide();
				}
			}else if(showHide == "show"){
				for (var index=0, length=elems.length; index < length; index++){					
					$(elems[index]).show();
				}
			}			
		}

		function setEnableDisable(arrElement, enableDisable){
			// arrElement contains the name of the elements you want to enable/disable
			// arrElement should be space separated in able to produce an array
			var elems = $w(arrElement);
			if(enableDisable == "enable"){
				for (var index=0, length=elems.length; index < length; index++){					
					$(elems[index]).enable();
				}
			}else if(enableDisable == "disable"){
				for (var index=0, length=elems.length; index < length; index++){									
					$(elems[index]).disable();
				}
			}
		}

		function setElementsValues(arrElement, arrValue){
			// arrElement contains the name of the elements
			// arrElement should be space separated in able to produce an array
			// arrValue contains the values of the elements
			// arrValue should be space separated in able to produce an array
			var elems = $w(arrElement);
			var vals  = $w(arrValue);
			for (var index=0, length=elems.length; index < length; index++){
				if(elems[index] == "nbtPolFlag" || elems[index] == "prorateSw" ){
					$(elems[index]).checked = vals[index];
				}else{
					$(elems[index]).value = vals[index];
				}		
			}
		}

		function copyDateValues(){
			$("varEffOldDte").value = $F("doi");
			$("varExpOldDte").value = $F("doe");
			$("varOldDateEff").value = $F("endtEffDate");
			$("varOldDateExp").value = $F("endtExpDate");
		}


		function showEditPolicyNo() {
			try{
				$("varOldLineCd").value 	= $F("b540LineCd");
				$("varOldIssCd").value 		= $F("b540IssCd");
				$("varOldSublineCd").value 	= $F("b540SublineCd");
				$("varOldPolSeqNo").value 	= $F("b540PolSeqNo");
				$("varOldIssueYY").value 	= $F("b540IssueYY");
				$("varOldRenewNo").value 	= $F("b540RenewNo");
				
 				var controller = "GIPIParInformationController";
				var action = "showEditPolicyNo";

				var parId 		= $F("b240ParId");
				var lineCd 		= $F("b540LineCd");
				var issCd 		= $F("b540IssCd");
			    var sublineCd 	= $F("b540SublineCd");
				var polSeqNo 	= $F("b540PolSeqNo");
				var issueYy 	= $F("b540IssueYY");
				var renewNo 	= $F("b540RenewNo");
				
				
				showOverlayContent2(contextPath+"/"+controller+"?action="+action+"&parId="+parId+"&lineCd="
						+lineCd+"&issCd="+issCd+"&sublineCd="+sublineCd+"&polSeqNo="+polSeqNo+"&issueYy="+issueYy+"&renewNo="+renewNo,
							   "Policy No.", 490, overlayOnComplete);		
			}catch(e){
				showErrorMessage("showEditPolicyNo", e);
			}	
		}
		
		$("btnEditPolicyNo").observe("click",function(){
			showEditPolicyNo();
		});

		$("endorseTax").checked = (nvl($("isPack"), "N") == "N") ? (objUW.hidObjGIPIS031.gipiWEndtText.endtTax == "Y" ? true : false) : (nvl($F("b360EndtTax"), "N") == "Y") ? true : false;		
	}	
	//reymon 04182013
	//based on regular policy endorsement module
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
							$("paramAssuredNo").value = row.assdNo; //added by robert 01.28.2015
							changeTag = "1"; 
							$("assuredName").focus();
							
							//validate change of assured for Open Policy	gzelle 04222015//
							if (objUW.hidObjGIPIS002.isOpenPolicy == "Y") {
								isPolExist(row.assdNo);
							}
							
							//Daniel Marasigan SR 2169; set indicator for recreating invoice
							if(row.assdNo != assuredNo){
								$('assuredName').setAttribute('prevAssdNo', assuredNo);
							}
						}
						if(row.assdNo != assuredNo){
							if (objUW.hidObjGIPIS002.gipiWInvoiceExist == "1"){ //modified edgar 02/02/2015
								showConfirmBox("Confirmation", "Change of Assured will automatically recreate invoice and delete corresponding data on group information both ITEM and GROUP level. Do you wish to continue?",
										"Yes", "No", onOk, "");								
							}else{
								onOk();
							}
							//objUW.GIPIS031.parameters.assuredChange = "Y"; // bonok :: 05.19.2014
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

	//added edgar 01/29/2015 to check for posted binders
	function checkPostedBinder(){ 
		var vExists = false;	
		new Ajax.Request(contextPath+"/GIPIWinvoiceController",{
				parameters:{
					action: "checkForPostedBinders",
					parId : $F("globalParId")
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
	//added edgar 02/04/2015 to validate Issue Date
	function validateIssueDate(){
		if(nvl(prevIssueDate,$("issueDate").value) != $("issueDate").value){
			if (objUW.hidObjGIPIS002.gipiWinvTaxExist == "1") {
				showConfirmBox(
						"Message",
						"Some taxes may be dependent on date of issuance...changing date of issuance will automatically recreate invoice. Do you want to continue?",
						"Yes", "No", onOkFunc, onCancelFunc);
			}
		}
		function onOkFunc() {
			objUW.hidObjGIPIS002.deleteSw = "Y";
		}
		function onCancelFunc() {
			$("issueDate").value = prevIssueDate;
			objUW.hidObjGIPIS002.forSaving = false;
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
	} //end reymon
	/* endorsement ends here*/
	
	//From openpolicy.jsp - validate assured of open policy - gzelle 04222015
	function isPolExist(assdNo){
	try{
		function setOpenPolicyChanged(res){
			$("openPolicyChanged").value = "Y";
			if (res){
				objUW.hidObjGIPIS002.gipiWOpenPolicyExist = "1";
			}else{
				objUW.hidObjGIPIS002.gipiWOpenPolicyExist = "0";
			}	
		}
		
		var result = false;
		if (("" != $F("opSublineCd")) && ("" != $F("opIssCd")) && ("" != $F("opIssYear")) 
				&& ("" != $F("opPolSeqNo")) && ("" != $F("opRenewNo"))){
			new Ajax.Request(contextPath+"/GIPIWOpenPolicyController?action=isPolExist",{
				method:"POST",
				evalScripts:true,
				asynchronous: false,
				parameters: {
					globalLineCd: $F("globalLineCd"),
					opSublineCd: $F("opSublineCd"),
					opIssCd: $F("opIssCd"),
					opIssYear: $F("opIssYear"),
					opPolSeqNo: $F("opPolSeqNo"),
					opRenewNo: $F("opRenewNo")
				},
				onComplete: function (response) {
					if (checkErrorOnResponse(response)){
						if ("Y" == response.responseText){
							if($F("refOpenPolicyNo") == "") {
								if (($F("opSublineCd")!="")
										&&($F("opIssCd")!="")
										&&($F("opIssYear")!="")
										&&($F("opPolSeqNo")!="")
										&&($F("opRenewNo")!="")){
									new Ajax.Request(contextPath+"/GIPIWOpenPolicyController?action=validatePolExist", {
										method:"POST",
										evalScripts:true,
										asynchronous: false,
										parameters: {
											globalLineCd: $F("globalLineCd"),
											opSublineCd: $F("opSublineCd"),
											opIssCd: $F("opIssCd"),
											opIssYear: $F("opIssYear"),
											opPolSeqNo: $F("opPolSeqNo"),
											opRenewNo: $F("opRenewNo"),
											assdNo : assdNo
										},
										onComplete: function (response) {
											var paramMap2 = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
											if(paramMap2.exists == "Y" && (paramMap2.message == null || paramMap2.message == "")) {
												if($F("doi") != "" && makeDate($F("doi")) < makeDate(paramMap2.inceptDate)) {
													showMessageBox("Effectivity date "+$F("doi")+" must be within "+
															paramMap2.inceptDate+" and "+paramMap2.expiryDate+".", "e");
													result = false;
												} else if ($F("doe") != "" && makeDate($F("doe")) > makeDate(paramMap2.expiryDate)) {
													showMessageBox("Expiry date "+$F("doe")+" must be within "+
															paramMap2.inceptDate+" and "+paramMap2.expiryDate+".", "e");
													result = false;
												} else {
													result = true;
													setOpenPolicyChanged(result);
													$("globalEffDate").value	= dateFormat(paramMap2.inceptDate,'mm-dd-yyyy');	//added by steven 9/26/2012
											 		$("referencePolicyNo").value = paramMap2.refPolNo; //added by steven 9/26/2012
											 		$("refOpenPolicyNo").value = paramMap2.refPolNo;  // bonok :: 03.25.2014 :: to populate the Ref. Polocy No. on observe of change of open policy 
											 		fireEvent($("referencePolicyNo"), "blur");//added by steven 9/26/2012
												}
												setOpenPolicyChanged(result);
											} else if (paramMap2.message != null) {
												result = false;
												showMessageBox(paramMap2.message, imgMessage.ERROR);
											} else {
												result = false;
												showMessageBox("No such policy exist.", imgMessage.ERROR);
											}
											setOpenPolicyChanged(result);
										}
									});
								} else {
									result = true;
									setOpenPolicyChanged(result);
								}
							} else {
								result = true;
								setOpenPolicyChanged(result);
							}
						} else {
							result = false;
							showMessageBox("No such policy exist.", imgMessage.ERROR);
						} 
					}
				}
			});
		}
		return result;
	}catch(e){
		showErrorMessage("isPolExist", e);	
	}	
}
</script>
