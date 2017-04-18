<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDif">
		<label>Bond Basic Endorsement Information</label>
		<span class="refreshers" style="margin-top: 0;">
			<label name="gro" style="margin-left: 5px;">Hide</label>
			<label id="reloadForm" name="reloadForam">Reload Form</label>
		</span>
	</div>
</div>
<div id="bondEndtBasicInformationDivOuter" style="float:left;" changeTagAttr="true">
	<form id="endtBondBasicInfoForm" name="endtBondBasicInfoForm">
		<jsp:include page="/pages/underwriting/endt/bond/endtBondBasicInfoVariables.jsp" />
		<div class="sectionDiv">
			<div id="bondEndtBasicInformationDiv" style="float:left; width:50%; height:330px; margin-top:10px;">
				<table align="center" cellspacing="1" border="0" width="100%;">
					<tr>
						<td class="rightAligned" style="width: 108px;">PAR No. </td>
						<td class="leftAligned" style="width: 200px;"><input style="width: 220px; " id="parNo" name="parNo" type="text" readonly="readonly" class="required" readonly="readonly" value="${gipiParList.parNo }"/></td>	
					</tr>
					<tr>
						<td class="rightAligned" style="width: 108px;">Policy No. </td>
						<td class="leftAligned" style="width: 200px;">
							<span class="" style="">
								<input id="txtLineCd" class="leftAligned required" type="text" name="txtLineCd" style="width: 8%;" value="${gipiWPolbas.lineCd }" title="Line Code" maxlength="2" readonly="readonly"/>
								<input id="txtSublineCd" class="leftAligned" type="text" name="txtSublineCd" style="width: 15%;" value="${gipiWPolbas.sublineCd }" title="Subline Code"maxlength="7" readonly="readonly"/>
								<input id="txtIssCd" class="leftAligned" type="text" name="txtIssCd" style="width: 8%;" value="${gipiWPolbas.issCd }" title="Issource Code"maxlength="2" readonly="readonly"/>
								<input id="txtIssueYy" class="leftAligned" type="text" name="txtIssueYy" style="width: 8%;" value="${gipiWPolbas.issueYy }" title="Year" maxlength="2" readonly="readonly"/>
								<input id="txtPolSeqNo" class="leftAligned" type="text" name="txtPolSeqNo" style="width: 15%;" value="<fmt:formatNumber pattern="000000">${gipiWPolbas.polSeqNo }</fmt:formatNumber>" title="Policy Sequence Number" maxlength="6" readonly="readonly"/>
								<input id="txtRenewNo" class="leftAligned" type="text" name="txtRenewNo" style="width: 8%;" value="<fmt:formatNumber pattern="00">${gipiWPolbas.renewNo }</fmt:formatNumber>" title="Renew Number" maxlength="2" readonly="readonly"/>
								<input id="btnEditPolicyNo" name="btnEditPolicyNo" class="button" type="button" value="Edit" />
					 		</span>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 108px;">Bond Inception </td>
						<td class="leftAligned" style="width: 200px;">
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
						<td class="rightAligned" style="width: 108px;">Endt. Effectivity </td>
						<td class="leftAligned" style="width: 200px;">
					    	<div style="float:left; border: solid 1px gray; width: 226px; height: 21px; margin-right:3px;" class="required">
					    		<input style="width: 198px; border: none;" id="paramDoe" name="paramDoe" type="hidden" value="<fmt:formatDate value="${gipiWPolbas.effDate }" pattern="MM-dd-yyyy" />" readonly="readonly"/>
					    		<input style="width: 198px; border: none;" id="doe" name="doe" type="text" value="<fmt:formatDate value="${gipiWPolbas.effDate }" pattern="MM-dd-yyyy" />" readonly="readonly" class="required"/>
					    		<img id="hrefDoeDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('doe'),this, null);" alt="Inception Date" />
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 108px;">Issue Date </td>
						<td class="leftAligned" style="width: 200px;">
					    	<div style="float:left; border: solid 1px gray; width: 226px; height: 21px; margin-right:3px;" class="required">
					    		<input style="width: 198px; border: none;" id="issueDate" name="issueDate" type="hidden" value="<fmt:formatDate value="${gipiWPolbas.issueDate }" pattern="MM-dd-yyyy" />" readonly="readonly"/>
					    		<input style="width: 198px; border: none;" id="issDate" name="issDate" type="text" value="<fmt:formatDate value="${gipiWPolbas.issueDate }" pattern="MM-dd-yyyy" />" readonly="readonly" class="required"/>
					    		<img id="hrefIssueDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('issDate'),this, null);" alt="Inception Date" />
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 108px;">Type of Policy </td>
						<td class="leftAligned" style="width: 200px;">
							<select id="polType" name="polType" style="float:left; border: solid 1px gray; width: 228px; height: 21px; margin-right:3px;">
								<option value=""></option>
								<c:forEach var="polType" items="${policyTypeListing}">
									<option value="${polType.typeCd}" 
										<c:if test="${gipiWPolbas.typeCd == polType.typeCd}">
											selected="selected"
										</c:if>
									>${polType.typeDesc}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Address </td>
						<td class="leftAligned">
							<input style="width: 220px;" id="add1" name="add1" type="text" value="${gipiWPolbas.address1}" maxlength="50" />
						</td>	
					</tr>
					<tr>	
						<td>&nbsp;</td>
						<td class="leftAligned">
							<input style="width: 220px;" id="add2" name="add2" type="text" value="${gipiWPolbas.address2}" maxlength="50" />
						</td>	
					</tr>
					<tr>
						<td>&nbsp;</td>	
						<td class="leftAligned">
							<input style="width: 220px;" id="add3" name="add3" type="text" value="${gipiWPolbas.address3}" maxlength="50" />
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
							<option value=""></option>
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
				</table>
			</div>
			
			<div id="bondBasicInformation" style="float:left; width:50%; margin-top:10px; margin-bottom:15px;">
				<table align="left" cellspacing="1" border="0" width="100%">
					<tr>
						<td class="rightAligned" style="width: 33%;">Principal </td>
						<td class="leftAligned">
							<div style="border: 1px solid gray; width: 226px; height: 21px; float: left;" class="required">
								<!-- 
								<input type="hidden" id="txtAssdNo" name="txtAssdNo" value="${gipiWPolbas.assdNo }" />
								<input type="hidden" id="txtDrvAssuredName" name="txtDrvAssuredName" value="${gipiWPolbas.dspAssdName }"/>
								 -->
								<input type="hidden" id="address1" name="address1" />
								<input type="hidden" id="address2" name="address2" />
								<input type="hidden" id="address3" name="address3" />
								<input style="width: 200px; border: none; " id="assuredName" name="assuredName" type="text" value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.dspAssdName}</c:if>" readonly="readonly" class="required" />
								<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searhAssured" name="searchAssured" onclick="openSearchClientModal();" alt="Go" />
								<!--  <img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searhAssured" name="searchAssured" onclick="openSearchAssured();" alt="Go" /> -->
							</div>
							<input id="assuredNo" name="assuredNo" type="hidden" value="${gipiWPolbas.assdNo}" />
							<input id="paramAssuredNo" name="paramAssuredNo" type="hidden" value="${gipiWPolbas.assdNo}" />
							<input style="width: 200px;" id="paramAssuredName" name="paramAssuredName" type="hidden" value="${gipiWPolbas.dspAssdName}" readonly="readonly" />
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 33%;">Endorsement No. </td>
						<td class="leftAligned">
							<span class="" style="">
								<input id="txtLineCd" class="leftAligned required" type="text" name="capsField" style="width: 8%; margin-top: 6px;" value="${gipiWPolbas.lineCd }" title="Line Code" maxlength="2" readonly="readonly"/>
								<input id="txtSublineCd" class="leftAligned" type="text" name="capsField" style="width: 15%; margin-top: 6px;" value="${gipiWPolbas.sublineCd }" title="Subline Code"maxlength="7" readonly="readonly"/>
								<input id="txtEndtIssCd" class="leftAligned" type="text" name="capsField" style="width: 8%; margin-top: 6px;" value="${gipiWPolbas.endtIssCd }" title="Endt Issource Code"maxlength="2" readonly="readonly"/>
								<input id="txtEndtIssueYy" class="leftAligned" type="text" name="intField" style="width: 8%; margin-top: 6px;" value="${gipiWPolbas.endtYy }" title="Endt Year" maxlength="2" readonly="readonly"/>
					 		</span>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 33%;">Bond Expiry </td>
						<td class="leftAligned">
					    	<div style="float:left; border: solid 1px gray; width: 226px; height: 21px; margin-right:3px;" class="required">
					    		<input style="width: 198px; border: none;" id="paramBondExpiry" name="paramBondExpiry" type="hidden" value="<fmt:formatDate value="${gipiWPolbas.expiryDate }" pattern="MM-dd-yyyy" />" readonly="readonly"/>
					    		<input style="width: 198px; border: none;" id="bondExpiry" name="bondExpiry" type="text" value="<fmt:formatDate value="${gipiWPolbas.expiryDate }" pattern="MM-dd-yyyy" />" readonly="readonly" class="required"/>
					    		<img id="hrefBondExpiryDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('bondExpiry'),this, null);" alt="Inception Date" />
							</div>
					    	<input type="checkbox" id="expiryTag" name="expiryTag" value="Y" 
					    	<c:if test="${gipiWPolbas.expiryTag == 'Y' }">
									checked="checked"
							</c:if>/> TBA
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 33%;">Endt. Exp. Date </td>
						<td class="leftAligned">
					    	<div style="float:left; border: solid 1px gray; width: 226px; height: 21px; margin-right:3px;" class="required">
					    		<input style="width: 198px; border: none;" id="paramEed" name="paramEed" type="hidden" value="<fmt:formatDate value="${gipiWPolbas.endtExpiryDate }" pattern="MM-dd-yyyy" />" readonly="readonly"/>
					    		<input style="width: 198px; border: none;" id="eed" name="eed" type="text" value="<fmt:formatDate value="${gipiWPolbas.endtExpiryDate }" pattern="MM-dd-yyyy" />" readonly="readonly" class="required"/>
					    		<img id="hrefEedDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('eed'),this, null);" alt="Endt. Expiry Date" />
							</div>
					    	<input type="checkbox" id="endtExpiryTag" name="endtExpiryTag" value="Y" 
					    	<c:if test="${gipiWPolbas.endtExpiryTag == 'Y' }">
									checked="checked"
							</c:if>/> TBA
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 33%;">Ref. Bond No. </td>
						<td class="leftAligned">
							<input style="width: 220px;" id="refPolNo" name="refPolNo" type="text" value="<c:if test="${not empty gipiWPolbas}">${gipiWPolbas.refPolNo}</c:if>" />
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
					<tr>	
						<td class="rightAligned">Mortgagee </td>
					    <td class="leftAligned">
							<select id="mortgagee" name="mortgagee" style="width: 228px;">
								<option value=""></option>
								<c:forEach var="m" items="${mortgageeListing}">
									<option value="${m.mortgCd}"
									<c:if test="${gipiWPolbas.mortgName eq m.mortgCd}">
											selected="selected"
									</c:if>
									>${m.mortgName}</option>
								</c:forEach>
							</select>
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
						<td class="rightAligned">Crediting Branch </td>
					    <td class="leftAligned">
							<select id="creditedBranch" name="creditedBranch" style="width: 228px;">
								<c:forEach var="creditingBranchListing" items="${branchSourceListing}">
								<option value="${creditingBranchListing.issCd}"
								<c:if test="${gipiWPolbas.credBranch eq creditingBranchListing.issCd}">
									selected="selected"
								</c:if>>${creditingBranchListing.issName}</option>				
							</c:forEach>
							</select>
						</td>
					</tr>	
					<tr>
						<td class="rightAligned"> </td>
						<td class="leftAligned">
							<input type="checkbox" id="regPolSw" name="regPolSw" value="Y" 
							<c:if test="${gipiWPolbas.regPolicySw == 'Y' }">
									checked="checked"
							</c:if>
							/> Regular Bond
							<input type="button" class="button" id="btnBancaDtl" name="btnBancaDtl" style="margin-left: 15px;" value="Bancassurance Details" />
						</td>
					</tr>
				</table>
			</div>
		</div>
	
		<div class="sectionDiv" id="bondEndtBasicInformationDivOthers" style="float:left;">
			<div id="bondEndtBasicOtherDtlsDiv" style="float:left; width:100%; height:150px; margin-top:10px;">
				<div style="float:left; width:100%;">
					<label style="margin-left: 42px; margin-top: 3px;">Endorsement Text</label>
					<div style="border: 1px solid gray; width: 570px; margin-left: 8px; height: 21px; float: left;">
						<!--  <input style="width: 200px; border: none; " id="endtInformation" name="endtInformation" type="text" value="" readonly="readonly" class="required" /> -->
						<input type="hidden" id="endtText01" name="endtText01" />
						<input type="hidden" id="endtText02" name="endtText02" />
						<input type="hidden" id="endtText03" name="endtText03" />
						<input type="hidden" id="endtText04" name="endtText04" />
						<input type="hidden" id="endtText05" name="endtText05" />
						<input type="hidden" id="endtText06" name="endtText06" />
						<input type="hidden" id="endtText07" name="endtText07" />
						<input type="hidden" id="endtText08" name="endtText08" />
						<input type="hidden" id="endtText09" name="endtText09" />
						<input type="hidden" id="endtText10" name="endtText10" />
						<input type="hidden" id="endtText11" name="endtText11" />
						<input type="hidden" id="endtText12" name="endtText12" />
						<input type="hidden" id="endtText13" name="endtText13" />
						<input type="hidden" id="endtText14" name="endtText14" />
						<input type="hidden" id="endtText15" name="endtText15" />
						<input type="hidden" id="endtText16" name="endtText16" />
						<input type="hidden" id="endtText17" name="endtText17" />
						<textarea onKeyDown="limitText(this,32767);" onKeyUp="limitText(this,32767);" id="endtInformation" name="endtInformation" style="width: 92%; border: none; height: 13px;">${gipiWEndtText}</textarea>
						<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="findEndtTxt" name="findEndtTxt" alt="Go" />
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editEndtInfoText" />
					</div>
					<div style="float:left; border: 1px solid silver; margin-left: 10px; height: 21px; width: 156px;">
						<label style="margin-left: 44px; margin-top: 3px;">Cancellation</label>
					</div>
				</div>
				<div style="float:left; width:100%; margin-top: 10px;">
					<input type="hidden" id="genInfo01" name="genInfo01" />
					<input type="hidden" id="genInfo02" name="genInfo02" />
					<input type="hidden" id="genInfo03" name="genInfo03" />
					<input type="hidden" id="genInfo04" name="genInfo04" />
					<input type="hidden" id="genInfo05" name="genInfo05" />
					<input type="hidden" id="genInfo06" name="genInfo06" />
					<input type="hidden" id="genInfo07" name="genInfo07" />
					<input type="hidden" id="genInfo08" name="genInfo08" />
					<input type="hidden" id="genInfo09" name="genInfo09" />
					<input type="hidden" id="genInfo10" name="genInfo10" />
					<input type="hidden" id="genInfo11" name="genInfo11" />
					<input type="hidden" id="genInfo12" name="genInfo12" />
					<input type="hidden" id="genInfo13" name="genInfo13" />
					<input type="hidden" id="genInfo14" name="genInfo14" />
					<input type="hidden" id="genInfo15" name="genInfo15" />
					<input type="hidden" id="genInfo16" name="genInfo16" />
					<input type="hidden" id="genInfo17" name="genInfo17" />
					<label style="margin-left: 42px; margin-top: 3px;">General Info</label>
					<textarea style="width: 565px; margin-left: 39px; float: left; height: 76px;" id="generalInfo" name="generalInfo">${gipiWPolGenin.genInfo01}${gipiWPolGenin.genInfo02}${gipiWPolGenin.genInfo03}${gipiWPolGenin.genInfo04}
						${gipiWPolGenin.genInfo05}${gipiWPolGenin.genInfo06}${gipiWPolGenin.genInfo07}${gipiWPolGenin.genInfo08}
						${gipiWPolGenin.genInfo09}${gipiWPolGenin.genInfo10}${gipiWPolGenin.genInfo11}${gipiWPolGenin.genInfo12}
						${gipiWPolGenin.genInfo13}${gipiWPolGenin.genInfo14}${gipiWPolGenin.genInfo15}${gipiWPolGenin.genInfo16}
						${gipiWPolGenin.genInfo17}</textarea>
					<div style="margin-top: 3px; width 156px; height: 100px; float: left;">
						<input id="chkEndtCancellation" name="chkEndtCancellation" type="checkbox" style="margin-left: 35px;" 
							<c:if test="${gipiWPolbas.cancelType eq '3'}">
								checked="checked"
							</c:if>
						/>Endt Cancellation<br /><br />
						<input id="chkCoiCancellation" name="chkCoiCancellation" type="checkbox" style="margin-left: 35px;" 
							<c:if test="${gipiWPolbas.cancelType eq '4'}">
								checked="checked"
							</c:if>
						/>COI Cancellation<br /><br />
						<input id="btnCancelEndt" name="btnCancelEndt" type="button" class="button" style="width: 156px; margin-left: 11px;" value="Cancel Endt." />
					</div>
				</div>
			</div>
		</div>
	</form>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" name="btnCancel" value="Cancel" style="width: 60px;" />
	<input type="button" class="button" id="btnSave" name="btnSave" value="Save" style="width: 60px;" />
</div>
<script type="text/JavaScript">
	var gipis165Obj = new Object();
	gipis165Obj.varCancellationFlag = "N";	
	gipis165Obj.varCnclldFlatFlag = "N";
	gipis165Obj.varCanclledFlag = "N";
	gipis165Obj.endtCancellationFlag = "N";
	gipis165Obj.coiCancellationFlag = "N";
	gipis165Obj.varPolChangedSw = "N";
	gipis165Obj.globalCg$BackEndt = "N";
	gipis165Obj.polChangedSw = "N";
	gipis165Obj.expChgSw = "N";
	gipis165Obj.changeSw = "N";
	gipis165Obj.firstEndtSw = "N";
	gipis165Obj.confirmSw = "N";
	gipis165Obj.delBillTbls = "N";	
	
	var params = ""/*JSON.parse('${jsonParams}')*/;

	var endtCancellationTag = 0;
	var policyNoObj = new Object(); //this object to be used later
	var policyIdToBeCancelled = "";

	policyNoObj.lineCd = $F("txtLineCd");
	policyNoObj.issCd = $F("txtIssCd");
	policyNoObj.sublineCd = $F("txtSublineCd");
	policyNoObj.polSeqNo = $F("txtPolSeqNo");
	policyNoObj.issueYy = $F("txtIssueYy");
	policyNoObj.renewNo = $F("txtRenewNo");

	disableButton("btnCancelEndt");

	setModuleId("GIPIS165");
	setDocumentTitle("Bond Basic Endorsement Information");
	initializeAccordion();
	//addStyleToInputs();
	initializeAll();
	initializeChangeTagBehavior(saveEndtBondBasicInfo);
	observeReloadForm("reloadForm", showEndtBondBasicInfo);
	
	//functions goes here...
	function showEditPolicyNo() {
		try{
			$("b540EffDate").value = $F("doe");
			
			var controller = "GIPIWBondBasicController";
			var action = "showEditPolicyNo";

			var parId = $F("globalParId");
			var lineCd = $F("txtLineCd");
			var issCd = $F("txtIssCd");
			var sublineCd = $F("txtSublineCd");
			var polSeqNo = $F("txtPolSeqNo");
			var issueYy = $F("txtIssueYy");
			var renewNo = $F("txtRenewNo");

			showOverlayContent2(contextPath+"/"+controller+"?action="+action+"&parId="+parId+"&lineCd="
					+lineCd+"&issCd="+issCd+"&sublineCd="+sublineCd+"&polSeqNo="+polSeqNo+"&issueYy="+issueYy+"&renewNo="+renewNo,
						   "Policy No.", 490, overlayOnComplete);	
		}catch(e){
			showErrorMessage("showEditPolicyNo", e);
		}	
	}

	function saveEndtBondBasicInfo(){
		if ($F("doe") == ""){
			showMessageBox('Cannot proceed, endorsement effectivity date should not be null.', imgMessage.ERROR);
			return false;
		} else if ($F("eed") == "") {
			showMessageBox('Cannot proceed, endorsement expiry date should not be null.', imgMessage.ERROR);
			return false;
		} else {
			$("parId").value = $F("globalParId");
			//block for saving bond endt basic info
			prepareInfoParams("endtText");
			prepareInfoParams("genInfo");

			var saveParams = new Object();
			saveParams = getInfoParams();
			continueSaving(JSON.stringify(saveParams));
			//showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
		}
	}

	function continueSaving(params){
		new Ajax.Request(contextPath+"/GIPIWBondBasicController?action=saveEndtBondBasicInfo",{
			method : "POST",
			//postBody : Form.serialize("endtBondBasicInfoForm"),
			parameters: {
				parameters: params
			},
			evalScripts : true,
			asynchronous : false,
			onCreate : function (){
				showNotice("Saving endorsement bond basic information. Please wait...");
			},
			onComplete : function (response){
				if (checkErrorOnResponse(response)){
					//commented for now...
					//if (response.responseText == "SUCCESS"){
						hideNotice("");
						showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
						changeTag = 0;
						if ($F("polFlag") == "Y"){
							$("polFlag").value = "N";
						}
					//}
				}
			}
		});
	}

	function continueCancellation(){
		getCancellationLOV();
	}

	function getCancellationLOV(){
		var lovType;
		var titleText;
		if ($("chkEndtCancellation").checked){
			lovType = "endt";
			titleText = "Endorsement";		
		}
		if ($("chkCoiCancellation").checked){
			lovType = "coi";
			titleText = "COI";
		}

		overlayCancellationLOV = Overlay.show(contextPath+"/GIPIWBondBasicController",{
						urlContent: true,
						urlParameters: {
							action : "getCancellationLOV",
							lineCd : $F("txtLineCd"),
							issCd : $F("txtIssCd"),
							sublineCd : $F("txtSublineCd"),
							polSeqNo : $F("txtPolSeqNo"),
							issueYy : $F("txtIssueYy"),
							renewNo : $F("txtRenewNo"),
							lovType : lovType},
						title: "Cancel " + titleText,
						width: 250,
						height: 200,
						draggable: true
					});
	}

	function checkExistence(code){
		var existTag = false;
		new Ajax.Request(contextPath+"/GIPIWBondBasicController",{
			method: "POST",
			parameters: {
				action : "checkExistence",
				parId : $F("globalParId"),
				code : code
			},
			evalScripts : true,
			asynchronous: false,
			onComplete : function (response){
				if (checkErrorOnResponse(response)){
					if (response.responseText == "1"){
						existTag = true;
					}
				}
			}
		});
		return existTag;
	}

	function checkPerilExist(){
		var perilExist = false;
		new Ajax.Request(contextPath+"/GIPIWBondBasicController",{
			method: "POST",
			parameters: {
				action : "checkPerilExist",
				parId : $F("globalParId")
			},
			evalScripts : true,
			asynchronous: false,
			onComplete : function (response){
				if (checkErrorOnResponse(response)){
					if (response.responseText == "1"){
						perilExist = true;
					}
				}
			}
		});
		return perilExist;
	}

	function checkForAvailableEndt(){
		var hasAvailEndt = false;
		new Ajax.Request(contextPath+"/GIPIWBondBasicController",{
			method: "POST",
			parameters: {
				action: "checkForAvailableEndt",
				lineCd : $F("txtLineCd"),
				issCd : $F("txtIssCd"),
				sublineCd : $F("txtSublineCd"),
				polSeqNo : $F("txtPolSeqNo"),
				issueYy : $F("txtIssueYy"),
				renewNo : $F("txtRenewNo")
			},
			evalScripts: true,
			asynchronous: false,
			onCreate: function (){

			},
			onComplete: function (response){
				if (!checkErrorOnResponse(response)){
					var endt = response.responseText;
					if (endt == "1"){
						hasAvailEndt = true;
					}
				}
			}
		});

		return hasAvailEndt;
	}

	function continueRevertCancellation(){
		//function for reverting cancellation on endorsement; same as continueProcess2
		new Ajax.Request(contextPath + "/GIPIParInformationController?action=preGetAmounts", {
			method : "GET",
			parameters : {
				parId : $F("globalParId"),
				lineCd : $F("txtLineCd"),
				issCd : $F("txtIssCd"),
				sublineCd : $F("txtSublineCd"),
				polSeqNo : $F("txtPolSeqNo"),
				issueYy : $F("txtIssueYy"),
				renewNo : $F("txtRenewNo"),
				effDate : $F("doe")
			},
			aysnchronous : false,
			evalScripts : true,
			onCreate : showNotice("Checking records, please wait..."),
			onComplete : function(response){
				if (checkErrorOnResponse(response)){
					hideNotice("Done!");
					if (response.responseText == 'Empty'){
						$("doe").value = "";
						$("polFlag").value = "1";
						$("varCnclldFlatFlag").value = "N";
					} else {
						showMessageBox(response.responseText, imgMessage.ERROR);
					}				
					/*
					hideNotice("Done!");					
					if(response.responseText == 'Empty'){
						if($F("processStatus") == "revertFlatCancellation"){
							$("parStatus").value = "3";
							$("b240ParStatus").value = "3";
							$("prorateFlag").removeAttribute("disabled");
							$("compSw").removeAttribute("disabled");
							$("hrefDoiDate").show();
							$("hrefDoeDate").show();
							$("hrefEndtEffDate").show();
							$("hrefEndtExpDate").show();
							$("b540ProrateFlag").value = "2";
							$("b540CompSw").value = "";
							$("b540PolFlag").value = "1";
							$("endtEffDate").value = "";
							$("varCnclldFlatFlag").value = "N";
							$("b540CancelType").value = "";
						}else{
							createNegatedRecords();							
						}						
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);						
						stopProcess2();
					}*/
				}									
			}
		});
	}

	function confirmCancellation(checkbox){
		if (checkbox.checked){
			var checkPolicyObj = checkPolicy();
			if (varObj.resultCheckClaims == "The policy has claims pending."){
				showMessageBox("The policy has pending claims, cannot cancel policy.", imgMessage.ERROR);
				checkbox.checked = false;
			} else if (varObj.paidMsg == "N") {
				//showConfirmBox("", varObj.paidMsg + " Continue?", "Yes", "No", "", "");
				showConfirmBox("", "Payments have been made to the policy/endorsement to be cancelled. Continue?", "Accept", "Cancel", "", "");
			}
		} else {
			toggleCancelEndtBtn();
		}

		if ($F("bookingMonth") == ""){
			showMessageBox("Booking month and year is needed before performing cancellation.", imgMessage.ERROR);
			checkbox.checked = false;
			toggleCancelEndtBtn();
		}
	}

	function toggleCancelEndtBtn(){
		if ($("chkEndtCancellation").checked == true || $("chkCoiCancellation").checked == true){
			enableButton("btnCancelEndt");
		} else if ($("chkEndtCancellation").checked == false || $("chkCoiCancellation").checked == false){
			disableButton("btnCancelEndt");
		}
	}

	function checkPolicy(){
		new Ajax.Request(contextPath+"/GIPIWBondBasicController", {
			method: "POST",
			parameters: {
				action : "checkPolicy",
				lineCd : $F("txtLineCd"),
				sublineCd : $F("txtSublineCd"),
				issCd : $F("txtIssCd"),
				issueYy : $F("txtIssueYy"),
				polSeqNo : $F("txtPolSeqNo"),
				renewNo : $F("txtRenewNo")
			},
			evalScripts: true,
			asynchronous: false,
			onCreate: function (){
				
			},
			onComplete: function (response){
				varObj = JSON.parse(response.responseText);
			}
		});

		return varObj;
	}

	function getIssueYyBondBasic(){
		new Ajax.Updater("message", contextPath+'/GIPIParInformationController?action=getIssueYy', {
			method: "POST",
			postBody: Form.serialize("endtBondBasicInfoForm"),
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
	}

	function initBondBasic(){
		/*
		if ($F("updCredBranch") != "Y"){
			if ($("creditingBranch").value != ""){
				$("creditingBranch").disable();
			}
		}else if ($F("updCredBranch") == "Y"){
			$("creditingBranch").enable();
		}	

		if (($F("policyStatus") == "2") || ($F("policyStatus") == "3")){
			enablePolicyRenewalForm();
		} else {
			disablePolicyRenewalForm();
			clearPolicyRenewalForm();
		}
		if ($("policyStatus").value != 2){
			$("samePolnoSw").checked = false;
			$("samePolnoSw").disable();
		}else{
			$("samePolnoSw").enable();
		}*/

		//hides unnecessary menus for line SU -BRY 11/03/2010
		//$("bondPolicyData").show();
		$("itemInfo").hide();
		$("itemInfo").up("li",0).hide();
		$("clauses").hide();
		$("clauses").up("li",0).hide();
		$("coInsurance").hide(); //added by Nok 02.16.2011
		$("coInsurance").up("li",0).hide();
		$("basicInfo").hide();
		$("additionalEngineeringInfo").hide();
		$("lineSublineCoverages").hide();
		$("cargoLimitsOfLiability").hide();
		$("carrierInfo").hide();
		$("bankCollection").hide();
		$("limitsOfLiabilities").hide();
		$("discountSurcharge").hide();
		$("groupItemsPerBill").hide();
		$("groupPrelimDist").hide();
		$("groupPrelimDist").up("li",0).hide();
		$("prelimPerilDist").hide();
		$("prelimPerilDist").up("li",0).hide();
		$("prelimOneRiskDistTsiPrem").hide();
		$("prelimOneRiskDistTsiPrem").up("li",0).hide();
		$("prelimDistTsiPrem").hide();
		$("prelimDistTsiPrem").up("li",0).hide();
		$$("li[class='menuSeparator']").each(function(ms){
			if (ms.getAttribute("id") == "distributionMenuSeparator") ms.style.visibility = "hidden"; ms.style.display = "none";
		});
		$$("li[class='menuSeparator']").each(function(ms){
			ms.hide();
		});
		//end Bryan 
		
		/*
		if ($F("gipiWInvoiceExist") == "1"){
			enableMenu("enterBillPremiums");
			enableMenu("enterInvoiceCommission");
			enableMenu("distribution");
		}else{
			disableMenu("enterInvoiceCommission");
			disableMenu("distribution");
		}*/
		if ($F("txtSublineCd") != ""){
			$("bondPolicyData").show();
			enableMenu("bondPolicyData");
		}else{
			disableMenu("bondPolicyData");
		}
		var parStatus = $F("globalParStatus");
		parStatus > 4 ? enableMenu("bill") : disableMenu("bill");
		parStatus == 6 && checkUserModule("GIPIS165")? enableMenu("post") : disableMenu("post");
	}

	function prepareWPolbasParams() {
		try {
			var obj = new Object();

			obj.parId			= $F("globalParId");
			obj.assdNo			= $F("assuredNo");
			obj.lineCd			= $F("txtLineCd");
			obj.sublineCd		= $F("txtSublineCd");
			obj.issueCd			= $F("txtIssCd");
			obj.issueYy			= $F("txtIssueYy");
			obj.polSeqNo		= $F("txtPolSeqNo");
			obj.renewNo			= $F("txtRenewNo");
			obj.endtIssCd		= $F("txtEndtIssCd");
			obj.endtYy			= $F("txtEndtIssueYy");
			obj.inceptDate		= $F("paramDoi");
			obj.expiryDate		= $F("paramBondExpiry");
			obj.effDate			= $F("paramDoe");
			obj.endtExpiryDate	= $F("bondExpiry");
			obj.issueDate		= $F("issueDate");
			obj.refPolNo		= $F("refPolNo");
			obj.typeCd			= $F("polType");
			obj.regionCd		= $F("region");
			obj.address1		= $F("add1");
			obj.address2		= $F("add2");
			obj.address3		= $F("add3");
			obj.mortgName		= $F("mortgagee");
			obj.industryCd		= $F("industry");
			obj.credBranch		= $F("creditedBranch");
			obj.bookingMth		= $F("paramBookingMth");
			obj.bookingYear		= $F("paramBookingYear");
			obj.takeupTerm		= $F("paramTakeupTermType");
			obj.inceptTag		= $F("inceptTag");
			obj.expiryTag		= $F("expiryTag");
			obj.endtExpiryDate	= $F("paramEed");
			obj.regPolicySw		= $F("regPolSw");
			obj.foreignAccSw	= "N";
			obj.invoiceSw		= "N";		
			obj.autoRenewFlag	= "N";
			obj.provPremTag		= "N";
			obj.packPolFlag		= "N";
			obj.coInsuranceSw	= 1;
			return obj;			
		} catch(e) {
			showErrorMessage("prepareWPolbasParams", e);
		}
	}

	function getInfoParams() {
		try {
			var obj = new Object();

			obj.gipiWEndtTextObj = {};
			obj.gipiWGenInfoObj = {};
			obj.gipiWPolbas = {};
			obj.gipiWPolnrep = [];
			obj.variables = {};

			obj.gipiWPolbas = prepareWPolbasParams();
			
			obj.gipiWEndtTextObj.parId 	    = $F("globalParId");
			obj.gipiWEndtTextObj.endtCd		= "";
			obj.gipiWEndtTextObj.endtText	= escapeHTML2($F("endtInformation"));
			obj.gipiWEndtTextObj.endtTax	= "";
			
			obj.gipiWGenInfoObj.parId 		= $F("globalParId");
			obj.gipiWGenInfoObj.genInfo 	= escapeHTML2($F("generalInfo"));
			
			for(var i = 1; i<= 17; i++ ) {
				obj.gipiWEndtTextObj["endtText"+i.toPaddedString(2)] = escapeHTML2($("endtText"+i.toPaddedString(2)).value);
				obj.gipiWGenInfoObj["genInfo"+i.toPaddedString(2)] = escapeHTML2($("genInfo"+i.toPaddedString(2)).value);
			}
			
			return obj;
		} catch(e) {
			showErrorMessage("getInfoParams", e);
		}
	}

	function prepareInfoParams(param){
		var object = new Object();
		if (param == "endtText"){
			object.input = $("endtInformation").innerHTML;
		} else if (param == "genInfo"){
			object.input = $("generalInfo").innerHTML;
		}
		object.textInfo = param;

		if (object.input.length > 1){
			for (var i = 1; i <= 17; i++){
				var txtInput = String(object.textInfo) + i.toPaddedString(2);
				var base = 2000 * (i-1);
				$(txtInput).value = String(object.input).substring((base), (base+2000));
			}
		}
	}

	if ($F("txtIssCd") == $F("issCdRI") || $F("txtIssCd") == "RB"){
	//if ($F("textIssCd") == params.issCdRI || $F("txtIssCd") == "RB"){
		disableButton("btnCancelEndt");
	}

	if ($F("ora2010Sw") != "Y" ){
	//if (params.ora2010Sw != "Y"){
		$("btnBancaDtl").setStyle("display : none;");
	}

	$("btnEditPolicyNo").observe("click", function (){
		showEditPolicyNo();
	});

	$("generalInfo").innerHTML = ltrim(rtrim($F("generalInfo")));
	$("generalInfo").observe("change", function (){
		$("generalInfo").innerHTML = ltrim(rtrim($F("generalInfo")));
		prepareInfoParams("genInfo");
	});

	function validateEndtIssueDate(){
		new Ajax.Request(contextPath + "/GIPIParInformationController?action=validateEndtIssueDate",{
			method : "GET",
			parameters : {
				parId : $F("globalParId"),
				parVarVdate : $F("varVDate"),
				//parVarVdate : params.varVDate,
				issueDate : $F("issDate"),
				effDate : $F("doe")				
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : showNotice("Validating date, please wait..."),
			onComplete : function(response){
				if (checkErrorOnResponse(response)) {
					hideNotice("Done!");
					var result = response.responseText.toQueryParams();

					if(result.msgAlert != "" && result.msgAlert != undefined){
						showMessageBox(result.msgAlert, imgMessage.WARNING);						
					}else{
						$("varIDate").value = result.parVarIdate;						
						$("bookingMonth").selectedIndex = getIndexInSelectList("bookingMonth", result.bookingYear + " - " + result.bookingMonth);
					}
				}
			}
		});	
	}

	$("issDate").observe("blur", function (){
		validateEndtIssueDate();
	});

	var preDoi = $F("doi");
	$("doi").observe("blur", function (){
		if ($F("doi") != ""){
			if (Date.parse($F("doi")) > Date.parse($F("doe"))){
				showMessageBox("Inception date should not be later than the effectivity date of the Endorsement", imgMessage.ERROR);
				$("doi").value = preDoi;
				return false;
			} else if (Date.parse($F("doi")) > Date.parse($F("bondExpiry"))){
				showMessageBox("Inception date should not be later than Expiry date of the Bond", imgMessage.ERROR);
				$("doi").value = preDoi;
				return false;
			} else {
				validateEndtInceptExpiryDate();
			}
		}	
	});

	var preDoe = $F("doe");
	$("doe").observe("blur", function (){
		if ($F("doe") != ""){
			if (Date.parse($F("doe")) > Date.parse($F("bondExpiry"))){
				showMessageBox("Effectivity date should not be later than the Expiry date of the bond.", imgMessage.ERROR);
				$("doe").value = preDoe;
				return false;
			} else {
				validateEndtEffDate();
			}
		}
	});

	//to be modified...refer to poi.jsp
	function validateEndtEffDate(){
		if ($F("polFlag") != "4"){
			$("delBillTbls").value = "Y";
		}

		//aayusin pa ung mga parameters nit...
		new Ajax.Request(contextPath + "/GIPIParInformationController?action=validateEndtEffDate",{
			method : "GET",
			parameters : {
				varOldDateEff : $F("paramDoe"),
				parId : $F("globalParId"),
				lineCd : $F("globalLineCd"),
				sublineCd : $F("globalSublineCd"),
				issCd : $F("globalIssCd"),
				issueYy : $F("txtIssueYy"),
				polSeqNo : $F("txtPolSeqNo"),
				renewNo : $F("txtRenewNo"),
				prorateFlag : $F("prorateFlag"),
				endtExpiryDate : $F("eed"),
				compSw : $F("compSw"),
				polFlag : $F("polFlag"),
				expChgSw : $F("expChgSw"),
				varMaxEffDate : $F("varMaxEffDate"),
				parFirstEndtSw : "",
				varExpiryDate : $F("paramEed"),
				parVarVdate : $F("varVDate"),
				//parVarVdate : params.varVDate,
				issueDate : $F("issDate"),
				effDate : $F("doe"),
				inceptDate : $F("doi"),
				expiryDate : $F("bondExpiry"),
				endtYY : $F("txtEndtIssueYy"),
				sysdateSw : $F("parSysdateSw"),
				cgBackEndtSw : $F("globalCg$BackEndt"),
				parBackEndtSw : $F("parBackEndtSw")
			},
			asynchronous : true,
			evalScripts : true,
			onCreate : showNotice("Validating endt effitivity date, please wait..."),
			onComplete : function(response){
				if (checkErrorOnResponse(response)) {
					hideNotice("");
					//var result = response.responseText.toQueryParams();
					var result = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	

					if(nvl(result.msgAlert,null) != null && !(result.msgAlert.blank())){									
						showMessageBox(result.msgAlert, imgMessage.ERROR);
						$("endtEffDate").value ="";									
					}else{									
						$("endtEffDate").value = result.effDate.substr(0, 10);
						$("b540EffDate").value = result.effDate;
						$("varOldEffDate").value = result.effDate;
						$("varOldDateEff").value = $F("endtEffDate");
						$("doi").value = result.inceptDate.substr(0, 10);
						$("b540InceptDate").value = result.inceptDate;
						$("doe").value = result.expiryDate.substr(0, 10);
						$("b540ExpiryDate").value = result.expiryDate;
						$("b540EndtYy").value = result.endtYy;
						$("parSysdateSw").value = result.sysdateSw;
						$("globalCg$BackEndt").value = result.cgBackEndt;
						$("parBackEndtSw").value = result.parBackEndtSw;
						$("b540AnnTsiAmt").value = result.annTsiAmt;
						$("b540AnnPremAmt").value = result.annPremAmt;
						$("noOfDays").value = result.prorateDays;
						$("varMplSwitch").value = result.mplSwitch;
						$("bookingMonth").value = result.bookingMonth;
						//$("bookingMonth").selectedIndex = getIndexInSelectList("bookingMonth", result.bookingYear + " - " + result.bookingMonth);
						$("bookingYear").value = result.bookingYear;
						$("bookingMth").value = $("bookingMonth").options[$("bookingMonth").selectedIndex].getAttribute("bookingMth");									
					}											
				}
			}
		});
	}

	function validateEndtInceptExpiryDate(){
		//var paramFieldName = $F("isPack") == "Y" ? "PACK_INCEPT_DATE" : $F("fieldName");
		new Ajax.Request(contextPath + "/GIPIParInformationController?action=validateEndtInceptExpiryDate",{
			method : "GET",
			parameters : {					
				inceptDate : $F("doi"),
				effDate : $F("doe"),
				expiryDate : $F("eed"),
				parId : $F("globalParId"),
				lineCd : $F("txtLineCd"),
				sublineCd : $F("txtSublineCd"),
				issCd : $F("txtIssCd"),
				issueYy : $F("txtIssueYy"),
				polSeqNo : $F("txtPolSeqNo"),
				renewNo : $F("txtRenewNo"),
				fieldName : ""
			},
			asynchronous : true,
			evalScripts : true,
			onCreate : showNotice("Validating date, please wait..."),
			onComplete : function(response){
				hideNotice("");
				if (checkErrorOnResponse(response)) {
					hideNotice("");
					//var result = response.responseText.toQueryParams();
					var result = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
					
					if(nvl(result.msgAlert,null) != null){
						showMessageBox(result.msgAlert, imgMessage.WARNING);
					}

					if($F("fieldName") == "EXPIRY_DATE"){
						$("endtExpDate").value = $F("doe");
						$("b540EndtExpiryDate").value = $F("doe") + $F("b540EndtExpiryDate").substr(10);							
					}
				}
			}
		});
	}

	var preEed = $F("eed");
	$("eed").observe("blur", function (){
		if ($F("eed") != ""){
			if (Date.parse($F("eed")) > Date.parse($F("doe"))){
				showMessageBox("Expiry date should not be earlier than the effectivity date of the Endorsement.", imgMessage.ERROR);
				$("eed").value = preEed;
				return false;
			} else if (Date.parse($F("eed")) > Date.parse($F("doi"))){
				showMessageBox("Expiry date should not be earlier than the Inception date of the Bond.", imgMessage.ERROR);
				$("eed").value = preEed;
				return false;
			}
		}
	});

	$("btnCancel").observe("click", function (){
		if (changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", saveEndtBondBasicInfo, goBackToParListing, "");
		} else {
			goBackToParListing();
		}
	});

	$("btnSave").observe("click", function (){
		saveEndtBondBasicInfo();
	});

	$("btnCancelEndt").observe("click", function (){
		var endtSw = "N";

		//commented for lov testing
		if ($F("varCancellationFlag") == "Y"){
			showMessageBox('Only one endorsement record can be cancelled per endoresment PAR.', imgMessage.ERROR);
			return false;
		}

		if ($F("polFlag") == "4" && ($("chkEndtCancellation").checked == false && $("chkCoiCancellation").checked == false)){
			showMessageBox('Cancellation per endorsement is not allowed for PAR tagged for flat/pro-rate cancellation.', imgMessage.INFO);
			return false;
		}

		if (checkForAvailableEndt()){
			endtSw = "Y";
		} /* else if ($("chkCoiCancellation").checked){
			//endtSw = "Y";
		} */

		var existSw = "N";
		if (checkExistence("peril")){
			showConfirmBox("", "Existing details for this PAR would be deleted. Do you want to continue?", "Yes", "No", continueCancellation, "");
			existSw = "Y";
		} 

		if (checkExistence("item")){
			showConfirmBox("", "Existing item(s) for this PAR would be deleted. Do you want to continue?", "Yes", "No", continueCancellation, "");
			existSw = "Y";
		}

		if (endtSw == "N"){
	     	showMessageBox('There is no existing endorsement to be cancelled.', imgMessage.INFO);
		}
	});

	$("chkEndtCancellation").observe("change", function (){ //on checkbox change trigger
		if ($("chkEndtCancellation").checked){
			$("chkCoiCancellation").checked = false;
			//get booking date block
			if ($F("bookingMonth") == ""){
				showMessageBox('Booking month and year is needed before performing cancellation.', imgMessage.INFO);
				$("chkEndtCancellation").checked = false;
				return false;
			}
			confirmCancellation($("chkEndtCancellation"));
			$("endtCancellationFlag").value = "Y";
			//enableButton("btnCancelEndt");
		} else {
			//$("processStatus").value = "revertEndtCancellation";
			endtCancellationTag = "1";
			showConfirmBox("Endorsement", "All negated records for this policy will be deleted.", "Accept", "Cancel", continueRevertCancellation, "");
		}
		toggleCancelEndtBtn();
	});

	$("chkCoiCancellation").observe("change", function (){ 
		if ($("chkCoiCancellation").checked){
			$("chkEndtCancellation").checked = false;
			//get booking date block
			if ($F("bookingMonth") == ""){
				showMessageBox('Booking month and year is needed before performing cancellation.', imgMessage.INFO);
				$("chkCoiCancellation").checked = false;
				return false;
			}
			confirmCancellation($("chkCoiCancellation"));
			$("coiCancellationFlag").value = "Y";
			//enableButton("btnCancelEndt");
		} else {
			//$("processStatus").value = "revertEndtCancellation";
			endtCancellationTag = 2;
			showConfirmBox("Endorsement", "All negated records for this policy will be deleted.", "Accept", "Cancel", continueRevertCancellation, "");
		}
		toggleCancelEndtBtn();
	});

	$("findEndtTxt").observe("click", function (){
		objUW.hidObjGIPIS002 = {};
		openSearchEndtText();
	});

	$("editEndtInfoText").observe("click", function () {
		showEditor("endtInformation", 32767);
	});

	//this block is subject to testing
	var preBookingMonth;
	var preBookingYear;
	var preBookingMth;
	$("bookingMonth").observe("focus", function() {
		preBookingMonth = $("bookingMonth").value;
		preBookingYear = $("bookingYear").value;
		preBookingMth = $("bookingMth").value;
	});	
	
	//upon change of booking date
	$("bookingMonth").observe("change", function() {
		$("bookingYear").value = $("bookingMonth").options[$("bookingMonth").selectedIndex].getAttribute("bookingYear");
		$("bookingMth").value = $("bookingMonth").options[$("bookingMonth").selectedIndex].getAttribute("bookingMth");
		if ($F("bookingMonth") != "") {
			//$("validatedBookingDate").value = "Y";
			if (!validateBookingDate()){
				$("bookingMonth").value = preBookingMonth;
				$("bookingYear").value = preBookingYear;
				$("bookingMth").value = preBookingMth;
			}	
		} else {
			//$("validatedBookingDate").value = "N";
		}
		if ($F("doi") != "" && $F("bookingMonth") != ""){
			getIssueYyBondBasic();
		}	
	});	

	$("btnBancaDtl").observe("click", function(){
		overlayBancassuranceDtl = Overlay.show(contextPath+"/GIPIWBondBasicController", {
						urlContent: true,
						urlParameters: {
							action : "getBancassuranceDtl",
							parId : $F("globalParId")},
						title: "Bancassurance Details",
						width: 605,
						height: 200,
						draggable: true
					  });
	});
	var reqRefPolNo = = ('${reqRefPolNo}')
	//added by gab 10.07.2016
	if (reqRefPolNo == "Y"){
		$("refPolNo").addClassName("required");
	}

	observeChangeTagOnDate("hrefDoiDate", "doi");
	observeChangeTagOnDate("hrefDoeDate", "doe");
	observeChangeTagOnDate("hrefIssueDate", "issDate");
	observeChangeTagOnDate("hrefBondExpiryDate", "bondExpiry");
	observeChangeTagOnDate("hrefEedDate", "eed");
	initBondBasic();
</script>