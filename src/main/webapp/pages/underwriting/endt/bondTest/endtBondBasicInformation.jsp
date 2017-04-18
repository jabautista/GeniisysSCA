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
		<input type="hidden" id="polFlag"				name="polFlag" />
		<input type="hidden" id="foreignAccSw"			name="foreignAccSw"	/>
		<input type="hidden" id="invoiceSw"				name="invoiceSw" />
		<input type="hidden" id="autoRenewFlag"			name="autoRenewFlag" />
		<input type="hidden" id="provPremTag"			name="provPremTag" />
		<input type="hidden" id="packPolFlag"			name="packPolFlag" />
		<input type="hidden" id="coInsuranceSw"			name="coInsuranceSw" />
		<input type="hidden" id="endtSeqNo"				name="endtSeqNo" />
		<input type="hidden" id="expChgSw"				name="expChgSw"					value="N" />
		<input type="hidden" id="endtCancellationFlag"  name="endtCancellationFlag" 	value="N" />
		<input type="hidden" id="coiCancellationFlag" 	name="coiCancellationFlag" 		value="N" />
		<input type="hidden" id="varPolChangedSw"		name="varPolChangedSw"			value="N" />
		<input type="hidden" id="b540EffDate"			name="b540EffDate" />
		
		<input type="hidden" id="b240ParStatus"			name="b240ParStatus" />
		<input type="hidden" id="b240ParType" 			name="b240ParType" />
		<input type="hidden" id="b240IssCd" 			name="b240IssCd" />
		<input type="hidden" id="b240ParSeqNo" 			name="b240ParSeqNo" />
		<input type="hidden" id="b240ParYy" 			name="b240ParYy" />
		<input type="hidden" id="b240QuoteSeqNo" 		name="b240QuoteSeqNo" />
		<input type="hidden" id="b240Address1" 			name="b240Address1" />
		<input type="hidden" id="b240Address2" 			name="b240Address2" />
		<input type="hidden" id="b240Address3" 			name="b240Address3" />
		<input type="hidden" id="tsiAmt" 				name="tsiAmt" value="" />
		<input type="hidden" id="premAmt" 				name="premAmt" value="" />
		<input type="hidden" id="annTsiAmt" 			name="annTsiAmt" value="" />
		<input type="hidden" id="annPremAmt" 			name="annPremAmt" value="" />
		
		<input type="hidden" id="acctOfCd"				name="acctOfCd" />
		<input type="hidden" id="checkboxChgSw"			name="checkboxChgSw" 			value="N" />
		<input type="hidden" id="wInvoiceExists" 		name="wInvoiceExists"  			value="${wInvoiceExists}"/> <!-- added by robert GENQA SR 4825 08.04.15 -->
		<input type="hidden" id="deleteBillSw" 			name="deleteBillSw" 		 	value="N"/> <!-- added by robert GENQA SR 4825 08.04.15 -->
		<input type="hidden" id="bondAutoPrem" 			name="bondAutoPrem" /> <!-- added by robert GENQA SR 4828 08.25.15 -->
		<div class="sectionDiv">
			<div id="bondEndtBasicInformationDiv" style="float:left; width:50%; height:355px; margin-top:10px;"> <!-- modified height by robert GENQA SR 4825 08.03.15 -->
				<table align="center" cellspacing="1" border="0" width="100%;">
					<tr>
						<td class="rightAligned" style="width: 108px;">PAR No. </td>
						<td class="leftAligned" style="width: 200px;"><input style="width: 220px; " id="parNo" name="parNo" type="text" readonly="readonly" class="required" readonly="readonly"/></td>	
					</tr>
					<tr>
						<td class="rightAligned" style="width: 108px;">Policy No. </td>
						<td class="leftAligned" style="width: 200px;">
							<span class="" style="">
								<input type="hidden" id="varOldLineCd" name="varOldLineCd" />
								<input type="hidden" id="varOldIssCd"		name="varOldIssCd" />
								<input type="hidden" id="varOldSublineCd"	name="varOldSublineCd" />
								<input type="hidden" id="varOldPolSeqNo"	name="varOldPolSeqNo" />
								<input type="hidden" id="varOldIssueYY"		name="varOldIssueYY" />
								<input type="hidden" id="varOldRenewNo"		name="varOldRenewNo" />
							
								<input id="txtLineCd" class="leftAligned required" type="text" name="txtLineCd" style="width: 8%;" title="Line Code" maxlength="2" readonly="readonly"/>
								<input id="txtSublineCd" class="leftAligned required" type="text" name="txtSublineCd" style="width: 15%;" title="Subline Code"maxlength="7" readonly="readonly"/>
								<input id="txtIssCd" class="leftAligned required" type="text" name="txtIssCd" style="width: 8%;" title="Issource Code"maxlength="2" readonly="readonly"/>
								<input id="txtIssueYy" class="leftAligned required" type="text" name="txtIssueYy" style="width: 8%;" title="Year" maxlength="2" readonly="readonly"/>
								<input id="txtPolSeqNo" class="leftAligned required" type="text" name="txtPolSeqNo" style="width: 15%;" title="Policy Sequence Number" maxlength="6" readonly="readonly"/>
								<input id="txtRenewNo" class="leftAligned required" type="text" name="txtRenewNo" style="width: 8%;" title="Renew Number" maxlength="2" readonly="readonly"/>
								<input id="btnEditPolicyNo" name="btnEditPolicyNo" class="button" type="button" value="Edit" />
					 		</span>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 108px;">Bond Inception </td>
						<td class="leftAligned" style="width: 200px;">
					    	<div style="float:left; border: solid 1px gray; width: 226px; height: 21px; margin-right:3px;" class="required">
					    	<!-- <input style="width: 198px; border: none;" id="paramDoi" name="paramDoi" type="hidden" value="<fmt:formatDate value="${gipiWPolbas.inceptDate}" pattern="MM-dd-yyyy" />" readonly="readonly"/>  -->
					    		<input style="width: 198px; border: none;" id="paramDoi" name="paramDoi" type="hidden" value="${convInceptDate}" readonly="readonly"/>	
					    		<input style="width: 198px; border: none;" id="doi" name="doi" type="text" value="${convInceptDate}" readonly="readonly" class="required" triggerChange="Y"/>
					    		<img id="hrefDoiDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('doi'),this, null);" alt="Bond Inception" />
							</div>
					    	<label style="float: left;"><input type="checkbox" id="inceptTag" name="inceptTag" value="Y"/> TBA</label>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 108px;">Endt. Effectivity </td>
						<td class="leftAligned" style="width: 200px;">
					    	<div style="float:left; border: solid 1px gray; width: 226px; height: 21px; margin-right:3px;" class="required">
					    		<input style="width: 198px; border: none;" id="paramDoe" name="paramDoe" type="hidden" readonly="readonly" value="${convEffDate}"/>
					    		<input style="width: 198px; border: none;" id="doe" name="doe" type="text" readonly="readonly" value="${convEffDate}" class="required" triggerChange="Y"/>
					    		<img id="hrefDoeDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('doe'),this, null);" alt="Endt. Effectivity" />
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 108px;">Issue Date </td>
						<td class="leftAligned" style="width: 200px;">
					    	<div style="float:left; border: solid 1px gray; width: 226px; height: 21px; margin-right:3px;" class="required">
					    		<input style="width: 198px; border: none;" id="issDate" name="issDate" type="hidden" readonly="readonly" value="${convIssDate}"/>
					    		<input style="width: 198px; border: none;" id="issueDate" name="issueDate" type="text" readonly="readonly" value="${convIssDate}" class="required" triggerChange="Y"/>
					    		<img id="hrefIssueDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('issueDate'),this, null);" alt="Issue Date" />
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
									>${polType.typeDesc}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Address </td>
						<td class="leftAligned">
							<input style="width: 220px;" id="address1" name="address1" type="text" maxlength="50" class="required"/>
						</td>	
					</tr>
					<tr>	
						<td>&nbsp;</td>
						<td class="leftAligned">
							<input style="width: 220px;" id="address2" name="address2" type="text" maxlength="50" />
						</td>	
					</tr>
					<tr>
						<td>&nbsp;</td>	
						<td class="leftAligned">
							<input style="width: 220px;" id="address3" name="address3" type="text" maxlength="50" />
						</td>	
					</tr>
					<tr>	
						<td class="rightAligned">Booking Date </td>
						<td class="leftAligned">
							<div>
								<div style="float:left; margin-right:2px;">
									<input type="hidden" id="paramBookingYear" name="paramBookingYear" style="width:35px; height:15px;" maxlength="4" />
									<input type="hidden" id="paramBookingMth" name="paramBookingYear" style="width:35px; height:15px;" />
									<input type="hidden" id="bookingYear" name="bookingYear" style="width:35px; height:15px;" maxlength="4" />
									<input type="hidden" id="bookingMth" name="bookingMth" style="width:35px; height:15px;" />
								</div>
								<div style="float:left;">
									<input type="hidden" id="bookingDateExist" name="bookingDateExist" />
									<select id="bookingMonth" name="bookingMonth" style="width: 228px;" class="required">
									<option bookingYear="" bookingMth="" value=""></option>
									<c:forEach var="d" items="${bookingMonthListing}">
										<option bookingYear="${d.bookingYear  }" bookingMth="${d.bookingMonth}" value="${d.bookingMonthNum}">${d.bookingYear  } - ${d.bookingMonth}</option>
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
							<select id="takeupTermType" name="takeupTermType" style="width: 228px;" disabled="disabled">
							<option value=""></option>
							<c:forEach var="t" items="${takeupTermListing}">
								<option value="${t.takeupTerm}">${t.takeupTermDesc}</option>
							</c:forEach>
							</select>
						</td>
					</tr>
					<!-- added by robert GENQA SR 4825 08.03.15 -->
					<tr>	
						<td class="rightAligned">Industry </td>
					    <td class="leftAligned">
							<select id="industry" name="industry" style="width: 228px;">
								<option value=""></option>
								<c:forEach var="i" items="${industryListing}">
									<option value="${i.industryCd}">${i.industryName}</option>
								</c:forEach>
						</select>
						</td>
					</tr>		
					<tr>	
						<td class="rightAligned">Crediting Branch </td>
					    <td class="leftAligned">
							<select id="creditedBranch" name="creditedBranch" style="width: 228px;">
								<option value=""></option><!-- blank option added by KRIS - 07.04.2013 -->
								<c:forEach var="creditingBranchListing" items="${branchSourceListing}">
									<%-- <option value="${creditingBranchListing.issCd}">${creditingBranchListing.issName}</option> commented out by KRIS 07.04.2013 and added the following: --%>
									<option regionCd="${creditingBranchListing.regionCd}" value="${creditingBranchListing.issCd}"
										<c:if test="${polbasObj.credBranch eq creditingBranchListing.issCd}">
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
							<div style="border: 1px solid gray; width: 226px; height: 21px; float: left;" class="required">
								<!-- 
								<input type="hidden" id="txtAssdNo" name="txtAssdNo" value="${gipiWPolbas.assdNo }" />
								<input type="hidden" id="txtDrvAssuredName" name="txtDrvAssuredName" value="${gipiWPolbas.dspAssdName }"/>
								 -->
								<input type="hidden" id="address1" name="address1" />
								<input type="hidden" id="address2" name="address2" />
								<input type="hidden" id="address3" name="address3" />
								<input style="width: 200px; border: none; " id="assuredName" name="assuredName" type="text" readonly="readonly" class="required" />
								<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchAssured" name="searchAssured" alt="Go" />
								<!--  <img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searhAssured" name="searchAssured" onclick="openSearchAssured();" alt="Go" /> -->
							</div>
							<input id="assuredNo" name="assuredNo" type="hidden" />
							<input id="paramAssuredNo" name="paramAssuredNo" type="hidden" />
							<input style="width: 200px;" id="paramAssuredName" name="paramAssuredName" type="hidden" readonly="readonly" />
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 33%;">Endorsement No. </td>
						<td class="leftAligned">
							<span class="" style="">
								<input id="txtLineCd2" class="leftAligned required" type="text" name="capsField" style="width: 8%; margin-top: 6px;" title="Line Code" maxlength="2" readonly="readonly"/>
								<input id="txtSublineCd2" class="leftAligned required" type="text" name="capsField" style="width: 15%; margin-top: 6px;" title="Subline Code"maxlength="7" readonly="readonly"/>
								<input id="txtEndtIssCd" class="leftAligned required" type="text" name="capsField" style="width: 8%; margin-top: 6px;" title="Endt Issource Code"maxlength="2" readonly="readonly"/>
								<input id="txtEndtIssueYy" class="leftAligned required" type="text" name="intField" style="width: 8%; margin-top: 6px;" title="Endt Year" maxlength="2" readonly="readonly"/>
					 		</span>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 33%;">Bond Expiry </td>
						<td class="leftAligned">
					    	<div style="float:left; border: solid 1px gray; width: 226px; height: 21px; margin-right:3px;" class="required">
					    		<input style="width: 198px; border: none;" id="paramBondExpiry" name="paramBondExpiry" type="hidden" value="${convExpiry}" readonly="readonly"/>
					    		<input style="width: 198px; border: none;" id="bondExpiry" name="bondExpiry" type="text" value="${convExpiry}" readonly="readonly" class="required" triggerChange="Y"/>
					    		<img id="hrefBondExpiryDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('bondExpiry'),this, null);" alt="Bond Expiry" />
							</div>
					    	<label style="float: left;"><input type="checkbox" id="expiryTag" name="expiryTag" value="Y" /> TBA</label>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 33%;">Endt. Exp. Date </td>
						<td class="leftAligned">
					    	<div style="float:left; border: solid 1px gray; width: 226px; height: 21px; margin-right:3px;" class="required">
					    		<input style="width: 198px; border: none;" id="defaultEED" name="defaultEED" type="hidden" value="${convEndtExpiry }" readonly="readonly" /> <!-- added by robert GENQA SR 4825 08.04.15 -->
					    		<input style="width: 198px; border: none;" id="paramEed" name="paramEed" type="hidden" value="${convEndtExpiry }" readonly="readonly"/>
					    		<input style="width: 198px; border: none;" id="eed" name="eed" type="text" value="${convEndtExpiry }" readonly="readonly" class="required" triggerChange="Y"/>
					    		<img id="hrefEedDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('eed'),this, null);" alt="Endt. Expiry Date" />
							</div>
					    	<label style="float: left;"><input type="checkbox" id="endtExpiryTag" name="endtExpiryTag" value="Y" /> TBA</label>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 33%;">Ref. Bond No. </td>
						<td class="leftAligned">
							<input style="width: 220px;" id="refPolNo" name="refPolNo" type="text" />
							<span class="rightAligned" id="lblBondSeqNo" style="display: none; width: 144px" >Bond No.</span>
							<input type="text" id="txtBondSeqNo" name="txtBondSeqNo" style="width: 76px; display: none" class="rightAligned" readonly="readonly"/>
						</td>
					</tr>
					<tr>	
						<td class="rightAligned">Region </td>
					    <td class="leftAligned">
							<select id="region" name="region" style="width: 228px;">
								<option value=""></option>
								<c:forEach var="r" items="${regionListing}">
									<option value="${r.regionCd}">${r.regionDesc}</option>
								</c:forEach>
							</select>
						</td>
					</tr>	
					<tr>
						<td class="rightAligned">Mortgagee </td>
						<td>
							<div style="border: 1px solid gray; height: 21px; width: 226px; margin-left: 4px; margin-bottom: 2px;">
								<input type="text" id="mortgagee" name="mortgagee" style="border: none; width: 200px;"/>
								<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searhMortgagee" name="searhMortgagee" alt="Go" />
							</div>
						</td>
						<%-- <td class="rightAligned">Mortgagee </td> --by bonok :: 07.09.2012
					    <td class="leftAligned">
							<select id="mortgagee" name="mortgagee" style="width: 228px;">
								<option value=""></option>
								<c:forEach var="m" items="${mortgageeListing}">
									<option value="${m.mortgCd}">${m.mortgName}</option>
								</c:forEach>
							</select>
						</td> --%>
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
								<input class="required integerNoNegativeUnformattedNoComma" type="text" style="width: 37px;  float: left; margin-right:2px; margin-top: 0px;" id="noOfDays2" name="noOfDays2" value="" maxlength="5" errorMsg="Entered pro-rate number of days is invalid. Valid value is from 0 to 99999."/> 
								<select class="required" id="compSw" name="compSw" style="width: 80px; float: left; margin-top: 0px;" >
									<option value="Y" <c:if test="${gipiWPolbas.compSw eq 'Y'}">selected="selected"</c:if> >+1 day</option>
									<option value="M" <c:if test="${gipiWPolbas.compSw eq 'M'}">selected="selected"</c:if> >-1 day</option>
									<option value="N" <c:if test="${gipiWPolbas.compSw eq 'N' or empty gipiWPolbas.compSw}">selected="selected"</c:if> >Ordinary</option>
								</select>
							</span>
							<span id="shortRateSelected" name="shortRateSelected" style="display: none;">
							    <input type="hidden" id="paramShortRatePercent" name="paramShortRatePercent" class="moneyRate2" style="width: 90px;" maxlength="13" value="${gipiWPolbas.shortRtPercent }" />
								<input type="text" id="shortRatePercent" name="shortRatePercent" class="moneyRate2 required" style="width: 90px;  float: left; margin-top: 0px;" maxlength="13" value="${gipiWPolbas.shortRtPercent }" oldShortRatePercent="${gipiWPolbas.shortRtPercent}"/>
							</span>	
						</td>
					</tr>
					<%-- <tr>	
						<td class="rightAligned">Industry </td>
					    <td class="leftAligned">
							<select id="industry" name="industry" style="width: 228px;">
								<option value=""></option>
								<c:forEach var="i" items="${industryListing}">
									<option value="${i.industryCd}">${i.industryName}</option>
								</c:forEach>
						</select>
						</td>
					</tr>		
					<tr>	
						<td class="rightAligned">Crediting Branch </td>
					    <td class="leftAligned">
							<select id="creditedBranch" name="creditedBranch" style="width: 228px;">
								<option value=""></option><!-- blank option added by KRIS - 07.04.2013 -->
								<c:forEach var="creditingBranchListing" items="${branchSourceListing}">
									<option value="${creditingBranchListing.issCd}">${creditingBranchListing.issName}</option> commented out by KRIS 07.04.2013 and added the following:
									<option regionCd="${creditingBranchListing.regionCd}" value="${creditingBranchListing.issCd}"
										<c:if test="${polbasObj.credBranch eq creditingBranchListing.issCd}">
											selected="selected"
										</c:if>>${creditingBranchListing.issName}</option>				
								</c:forEach>
							</select>
						</td>
					</tr>	 
					end robert GENQA SR 4825 08.03.15 --%>
					<tr>
						<td class="rightAligned"> </td>
						<td class="leftAligned">
							<label style="float: left;"><input type="checkbox" id="regPolSw" name="regPolSw" value="Y"/> Regular Bond</label>
							<!-- by bonok :: 07.11.2012 :: para kagaya sa forms na IF giisp.v('ORA2010_SW') <> 'Y' THEN hidden ung button-->
							<!-- <input type="button" class="button" id="btnBancaDtl" name="btnBancaDtl" style="margin-left: 15px; visibility: hidden;"  value="Bancassurance Details" /> -->
							<input type="button" class="button" id="btnBancaDtl" name="btnBancaDtl" style="margin-left: 15px;"  value="Bancassurance Details" />
						</td>
					</tr>
				</table>
			</div>
		</div>
		
		<jsp:include page="/pages/underwriting/subPages/bankPaymentDetails.jsp"></jsp:include>
		
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
						<textarea onKeyDown="limitText(this,32767);" onKeyUp="limitText(this,32767);" id="endtInformation" name="endtInformation" style="width: 92%; border: none; height: 13px;" class="required"></textarea>
						<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="findEndtTxt" name="findEndtTxt" alt="Go" />
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editEndtInfoText" />
					</div>
					<!-- <div style="float:left; border: 1px solid silver; margin-left: 10px; height: 21px; width: 156px;"> -->
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
					<textarea style="width: 565px; margin-left: 39px; float: left; height: 76px;" id="generalInfo" name="generalInfo"></textarea>
					<!-- <div id="chkCancelDiv" style="margin-top: 3px; width 156px; height: 100px; float: left; display: none;"> -->
					<div id="chkCancelDiv" style="margin-top: 3px; width: 156px; height: 100px; float: left;">
						<label style="float:left;"><input id="chkEndtCancellation" name="chkEndtCancellation" type="checkbox" style="margin-left: 35px;"/>Endt Cancellation</label>
						<label style="float:left;"><input id="chkCoiCancellation" name="chkCoiCancellation" type="checkbox" style="margin-left: 35px; margin-top: 7px;"/>COI Cancellation</label>
						<label style="float:left;"><input id="btnCancelEndt" name="btnCancelEndt" type="button" class="button" style="width: 156px; margin-left: 11px; margin-top: 7px;" value="Cancel Endt." /></label>
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
<script type="text/javascript">
	setModuleId("GIPIS165");
	setDocumentTitle("Bond Basic Endorsement Information");
	initializeAccordion();
	//addStyleToInputs();
	initializeAll();
	initializeChangeTagBehavior(saveEndtBondBasicInfo);
	observeReloadForm("reloadForm", showEndtBondBasicInfo);
	var udel = {};
	var endtBondVar = new Object();
	endtBondVar.endtCancellationFlag = "N";
	endtBondVar.itemPerilCount = 0;
	endtBondVar.itemCount = 0;
	var defaultExpiryDate = ('${defaultExpiryDate}'); //added by robert SR 4828 08.27.15
	if(objGipis165.cancelled == "Y"){
		endtBondVar.cancelPolId = "Y";
	}else{
		endtBondVar.cancelPolId = "N";
	}
	endtBondVar.cancelledFlatFlag = "N";
	objGipis165.cancellationFlag = "N";
	var params = JSON.parse('${jsonParams}');
	//params = eval((('(' + '${jsonParams}' + ')').replace(/&#62;/g, ">")).replace(/&#60;/g, "<"));
	
	var updateBooking = ('${updateBooking}');
	var reqRefNo = ('${reqRefNo}');	//added by Gzelle 12042014 SR 3092
	
	//added by gab 02.17.2017
	var reqRefPolNo = ('${reqRefPolNo}'); 
	if (reqRefPolNo == "Y"){
		$("refPolNo").addClassName("required");
	}
	
	if(nvl(updateBooking, "Y") == "N"){
		$("bookingMonth").disable(); // added by: Nica 05.25.2012 - Per Ms VJ, booking month LOV should be disabled if UPDATE_BOOKING is equal to N.
	}

	if ("${showBondSeqNo}" == "Y"){
		$("refPolNo").setStyle({
			width: "76px"
		});
		$("lblBondSeqNo").show();
		$("txtBondSeqNo").show();
		showBondSeqNo = "Y";
	}
	
	setEndtBondValues();
 
	function setEndtBondValues(){
		var issCd = "";
		var endtYy = "";
		var renewNo = "";
		var polbasObj 					= params.gipiWPolbas;
		
		$("parNo").value				= params.gipiParList.parNo;
		$("globalParId").value 			= params.gipiParList.parId;
		if('${confirmResult}' == 1){
			$("assuredNo").value        = unescapeHTML2('${newAssdNo}');
			$("assuredName").value		= unescapeHTML2('${newAssdName}');
			$("paramAssuredNo").value	= unescapeHTML2('${newAssdNo}');
			$("paramAssuredName").value = unescapeHTML2('${newAssdName}');
		}else{
			$("assuredNo").value 			= params.gipiParList.assdNo;
			$("assuredName").value			= unescapeHTML2(polbasObj.dspAssdName);
			$("paramAssuredNo").value 		= polbasObj.assdNo;
			$("paramAssuredName").value		= unescapeHTML2(polbasObj.dspAssdName);
		}

		$("b240ParStatus").value		= params.gipiParList.parStatus;
		$("b240ParType").value			= params.gipiParList.parType;
		$("b240IssCd").value			= params.gipiParList.issCd;
		$("b240ParSeqNo").value			= params.gipiParList.parSeqNo;
		$("b240ParYy").value			= params.gipiParList.parYy;
		$("b240QuoteSeqNo").value		= params.gipiParList.quoteSeqNo;
		if('${confirmResult}' == 1){
			$("b240Address1").value			= unescapeHTML2('${newAddress1}');
			$("b240Address2").value			= unescapeHTML2('${newAddress2}');
			$("b240Address3").value			= unescapeHTML2('${newAddress3}');
		}else{
			$("b240Address1").value			= unescapeHTML2(params.gipiParList.address1);
			$("b240Address2").value			= unescapeHTML2(params.gipiParList.address2);
			$("b240Address3").value			= unescapeHTML2(params.gipiParList.address3);
		}
		
		
		
		$("varOldLineCd").value 		= polbasObj.lineCd;
		$("varOldSublineCd").value 		= polbasObj.sublineCd;
		$("varOldIssCd").value 			= polbasObj.issCd;
		$("varOldIssueYY").value 		= polbasObj.issueYy;
		$("varOldPolSeqNo").value		= nvl(polbasObj.polSeqNo, "");
		$("varOldRenewNo").value 		= polbasObj.renewNo;
		
		$("txtLineCd").value 			= polbasObj.lineCd;
		$("txtSublineCd").value 		= unescapeHTML2(polbasObj.sublineCd); //Deo [01.03.2017]: added unescapeHTML2 (SR-23567)
		$("txtIssCd").value 			= polbasObj.issCd;
		$("txtIssueYy").value 			= polbasObj.issueYy;
		$("txtPolSeqNo").value			= polbasObj.polSeqNo.toPaddedString(6);
		if (polbasObj.renewNo != null){
			renewNo = parseInt(polbasObj.renewNo).toPaddedString(2);
		}
		$("txtRenewNo").value 			= renewNo;
		if (polbasObj.endtIssCd != null){
			//issCd = polbasObj.endtIssCd.toPaddedString(2);
			issCd = polbasObj.endtIssCd;
		}
		if ($("txtBondSeqNo").getStyle("display") != "none"){
			$("txtBondSeqNo").value = polbasObj.bondSeqNo == "" ? null : polbasObj.bondSeqNo;
		}
		$("txtEndtIssCd").value			= issCd;
		$("txtLineCd2").value 			= polbasObj.lineCd;
		$("txtSublineCd2").value 		= unescapeHTML2(polbasObj.sublineCd); //Deo [01.03.2017]: added unescapeHTML2 (SR-23567)
		if (polbasObj.endtYy != null){
			endtYy = parseInt(polbasObj.endtYy).toPaddedString(2);
		}
		$("txtEndtIssueYy").value 		= endtYy;
		$("paramDoi").value				= polbasObj.inceptDate;
		//$("doi").value					= polbasObj.inceptDate == null ? "" : dateFormat(polbasObj.inceptDate, "mm-dd-yyyy");
		$("inceptTag").checked			= (polbasObj.inceptTag == "Y");
		$("paramBondExpiry").value		= polbasObj.expiryDate;
		//$("bondExpiry").value			= polbasObj.expiryDate == null ? "" : dateFormat(polbasObj.expiryDate, "mm-dd-yyyy");
		$("expiryTag").checked			= (polbasObj.expiryTag == "Y");
		$("paramDoe").value				= polbasObj.effDate;
		//$("doe").value					= polbasObj.effDate == null ? "" : dateFormat(polbasObj.effDate, "mm-dd-yyyy");
		$("paramEed").value				= polbasObj.endtExpiryDate;
		//$("eed").value					= polbasObj.endtExpiryDate == null ? "" : dateFormat(polbasObj.endtExpiryDate, "mm-dd-yyyy");
		$("endtExpiryTag").checked		= (polbasObj.endtExpiryTag == "Y");
		//$("issueDate").value				= polbasObj.issueDate == null ? "" : dateFormat(polbasObj.issueDate, "mm-dd-yyyy");	
		$("refPolNo").value				= unescapeHTML2(polbasObj.refPolNo);
		$("polType").value				= polbasObj.typeCd;
		$("region").value				= polbasObj.regionCd;
		if('${confirmResult}' == 1){
			$("address1").value			= unescapeHTML2('${newAddress1}');
			$("address2").value			= unescapeHTML2('${newAddress2}');
			$("address3").value			= unescapeHTML2('${newAddress3}');
		}else{
			$("address1").value			= unescapeHTML2(polbasObj.address1); // marco - 01.02.2013 - added unescapeHTML2 for address fields
			$("address2").value			= unescapeHTML2(polbasObj.address2);
			$("address3").value			= unescapeHTML2(polbasObj.address3);
		}
		
		
		$("mortgagee").value			= unescapeHTML2(polbasObj.mortgName);
		$("industry").value				= polbasObj.industryCd;
		$("creditedBranch").value		= polbasObj.credBranch;
		$("paramBookingYear").value		= polbasObj.bookingYear;
		$("paramBookingMth").value		= polbasObj.bookingMth;
		$("bookingYear").value			= polbasObj.bookingYear;
		$("bookingMth").value			= polbasObj.bookingMth;
		
		$("tsiAmt").value 				= polbasObj.tsiAmt;
		$("premAmt").value 				= polbasObj.premAmt;
		$("annTsiAmt").value 			= polbasObj.annTsiAmt;
		$("annPremAmt").value 			= polbasObj.annPremAmt;
		updateBookingMonthLOV();

		//added by steven 10.15.2014 base in SR 3078
		if (nvl(objUWParList.polFlag,null) != null) {
			for (var i=0; i<$("bookingMonth").options.length; i++){
				if ($F("paramBookingYear") == $("bookingMonth").options[i].getAttribute("bookingYear") && 
				    $F("paramBookingMth") == $("bookingMonth").options[i].getAttribute("bookingMth")) {
					$("bookingMonth").selectedIndex = i;
					$("bookingYear").value = $("bookingMonth").options[i].getAttribute("bookingYear");
				 	$("bookingMth").value = $("bookingMonth").options[i].getAttribute("bookingMth");
					break;
				}
			}
		}else{
			for (var i = 0; i < $("bookingMonth").length; i++) {
				var mth = $("bookingMonth").options[i].getAttribute("bookingMth");
				var year = $("bookingMonth").options[i].getAttribute("bookingyear");
				if (mth == polbasObj.bookingMth && year == polbasObj.bookingYear){
					$("bookingMonth").selectedIndex = i;
					$("bookingDateExist").value = 1;
				}
			}
		}
		
		$("takeupTermType").value		= polbasObj.takeupTerm;
		$("inceptTag").checked			= (polbasObj.inceptTag == "Y");
		$("expiryTag").checked			= (polbasObj.expiryTag == "Y");
		$("endtExpiryTag").checked		= (polbasObj.endtExpiryTag == "Y");
		$("regPolSw").checked 			= (polbasObj.regPolicySw == "Y");
		$("polFlag").value				= polbasObj.polFlag;
		$("foreignAccSw").value			= nvl(polbasObj.foreignAccSw, "N");
		$("invoiceSw").value			= nvl(polbasObj.invoiceSw, "N");
		$("autoRenewFlag").value		= nvl(polbasObj.autoRenewFlag, "N");
		$("provPremTag").value			= nvl(polbasObj.provPremTag, "N");
		$("packPolFlag").value			= nvl(polbasObj.packPolFlag, "N");
		$("coInsuranceSw").value		= nvl(polbasObj.coInsuranceSw, "N");
		$("endtSeqNo").value			= polbasObj.endtSeqNo;
		$("endtInformation").value  	= params.gipiWEndtText == null ? "" : getAllEndtText(params.gipiWEndtText);
		$("generalInfo").value			= params.gipiWPolGenin == null ? "" : getAllGenInfo(params.gipiWPolGenin);

		$("chkEndtCancellation").checked = (polbasObj.cancelType == "3");
		$("chkCoiCancellation").checked = (polbasObj.cancelType == "4");
		
		if ("${showBondSeqNo}" == "Y"){
			$("txtBondSeqNo").value = polbasObj.bondSeqNo == "" ? null : polbasObj.bondSeqNo;
		}
		objGIPIWPolbas.cancelType = polbasObj.cancelType;
		
		if(reqRefNo == "Y"){ //added by Gzelle 12042014 SR3092
			$("nbtAcctIssCd").addClassName("required");
			$("nbtBranchCd").addClassName("required");
			$("dspRefNo").addClassName("required");
			$("dspModNo").addClassName("required");
		}
		//added by robert GENQA SR 4825 08.04.15
		$("prorateFlag").value			= polbasObj.prorateFlag;
		$("compSw").value				= polbasObj.compSw;
		$("shortRatePercent").value		= polbasObj.shortRtPercent;
		showProrateRelatedSpan();
		//end robert GENQA SR 4825 08.04.15
	}
	
	function getAllGenInfo(object){
		var genInfo = "";
		if(nvl(object.genInfo01, "") == "" && nvl(object.genInfo02, "") == "") {
			genInfo = nvl(object.genInfo, "");
		} else {
			genInfo = nvl(object.genInfo01, "") + nvl(object.genInfo02, "") + nvl(object.genInfo03, "") + nvl(object.genInfo04, "") + 
			  nvl(object.genInfo05, "") + nvl(object.genInfo06, "") + nvl(object.genInfo07, "") + nvl(object.genInfo08, "") + 
			  nvl(object.genInfo09, "") + nvl(object.genInfo10, "") + nvl(object.genInfo11, "") + nvl(object.genInfo12, "") + 
			  nvl(object.genInfo13, "") + nvl(object.genInfo14, "") + nvl(object.genInfo15, "") + nvl(object.genInfo16, "") + 
			  nvl(object.genInfo17, "");	
		}
		
		return unescapeHTML2(genInfo.trim());
	}

	function getAllEndtText(obj) {
		var endtText = "";
		
		endtText = nvl(obj.endtText01, "") + nvl(obj.endtText02, "") + nvl(obj.endtText03, "") + nvl(obj.endtText04, "") + 
					nvl(obj.endtText05, "") + nvl(obj.endtText06, "") + nvl(obj.endtText07, "") + nvl(obj.endtText08, "") + 
					nvl(obj.endtText09, "") + nvl(obj.endtText10, "") + nvl(obj.endtText11, "") + nvl(obj.endtText12, "") + 
					nvl(obj.endtText13, "") + nvl(obj.endtText14, "") + nvl(obj.endtText15, "") + nvl(obj.endtText16, "") + 
					nvl(obj.endtText17, "");
		
		return unescapeHTML2(endtText);
	}

	if (params.ora2010Sw != "Y") {
		$("btnBancaDtl").setStyle("display : none;");
	}else {
		objGipis165.companyLOV		= JSON.parse('${companyListingJSON}'.replace(/\\/g, '\\\\'));
		objGipis165.employeeLOV		= JSON.parse('${employeeListingJSON}'.replace(/\\/g, '\\\\'));
	}

	var b240issCd = params.gipiParList.issCd; //ganito ung condition na nakalagay sa forms... ^^
	if (b240issCd == params.issCdRI || b240issCd == "RB"){
		//disableButton("btnCancelEndt");
		$("chkCoiCancellation").disabled = true;
	}
	
	if ($F("issueDate") == "") {
		var today = new Date();
		$("issueDate").value = dateFormat(today, "mm-dd-yyyy");
	}
	
	
	
	$("btnEditPolicyNo").observe("click", function (){
		showEditPolicyNo();
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

	$("editEndtInfoText").observe("click", function () {
		showEditor("endtInformation", 32767);
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

	$("issueDate").observe("change", function (){
		validateEndtIssueDate();
	});

	function validateEndtIssueDate(){
		new Ajax.Request(contextPath + "/GIPIParInformationController?action=validateEndtIssueDate",{
			method : "GET",
			parameters : {
				parId : $F("globalParId"),
				parVarVdate : params.varVDate,
				issueDate : $F("issueDate"),
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
	
	$("hrefDoeDate").observe("click", function () {	//added by Gzelle 12192014
		$("paramDoe").value = $("doe").value;		
	});
	
	$("doe").observe("change", function (){
		if ($F("doe") != ""){
			if (Date.parse($F("doe")) > Date.parse($F("bondExpiry"))){
				showMessageBox("Effectivity date should not be later than the Expiry date of the bond.", imgMessage.ERROR);
				//set Endorsement Effectivity to null if $F("paramDoe") is empty to prevent having an effectivity date equal to SYSDATE by MAC 04/30/2013. 
				if ($F("paramDoe") != ""){
					$("doe").value = dateFormat($F("paramDoe"), "mm-dd-yyyy");
				}else{
					$("doe").value = "";
				}
				return false;
			} else if (Date.parse($F("doe")) > Date.parse($F("eed"))){	//added by Gzelle 01062015
				showMessageBox("Effectivity date should not be later than Endorsement Expiry date.", imgMessage.ERROR);
				if ($F("paramDoe") != ""){
					$("doe").value = dateFormat($F("paramDoe"), "mm-dd-yyyy");
				}else{
					$("doe").value = "";
				}
				return false;
			}
/* 			else if ($F("paramDoe") != "" && $F("doe") != $F("paramDoe")) { //added by robert SR 4828 08.27.15
				if ($F("deleteBillSw") == "N") {
					showConfirmBox(
							"Confirmation",
							"User has altered the endorsement effectivity date of this PAR from "
									+ $("paramDoe").value
									+ " to "
									+ $("doe").value
									+ '. All information related to this PAR will be deleted. Continue anyway?',
							"Yes", "No", function(){
								$("deleteBillSw").value = "Y";
								//validateEndtEffDate();
							},
							"");
				} //end robert SR 4828 08.27.15
				validateEndtEffDate();
			} */  // Dren 11.12.2015 SR-0020642 : Moved condition to Save Button.
			else {
				validateEndtEffDate();
			}
		}
	});

	function validateEndtEffDate(){
		//block still for checking....
		new Ajax.Request(contextPath+"/GIPIWBondBasicController?action=validateEffDateB5401",{
			method : "GET",
			parameters : {
				parId : $F("globalParId"),
				lineCd : $F("globalLineCd"),
				sublineCd : nvl($F("globalSublineCd"), $F("txtSublineCd")), //marco - 05.21.2015 - GENQA SR 4456
				issCd : $F("globalIssCd"),
				issueYy : $F("txtIssueYy"),
				polSeqNo : $F("txtPolSeqNo"),
				renewNo : $F("txtRenewNo"),
				polFlag : $F("polFlag"),
				expiryDate : $F("bondExpiry"),
				inceptDate : $F("doi"),
				vOldDate : $F("paramDoi"),
				expChgSw : $F("expChgSw"),
				vMaxEffDate : $F("paramDoe"),
				endtYy : $F("txtEndtIssueYy"),
				effDate : $F("doe")
			},
			asynchronous : true,
			evalScripts : true,
			onCreate : showNotice("Validating endt effitivity date, please wait..."),
			onComplete : function(response){
				hideNotice("");
				var result = JSON.parse(response.responseText/*.replace(/\\/g, '\\\\')*/);
				if (result.message != null && !(result.message.blank())){
 					if(result.message.include("Backward Endorsement")){ // Dren 11.12.2015 SR-0020642 : Bond Backward Endt. - Start
						showWaitingMessageBox(result.message);	
						$("txtEndtIssueYy").value = nvl(result.endtYy, "");
						$("doe").value = nvl(result.effDate, "");
						endtBondVar.vAddTime = result.vAddTime;
						endtBondVar.vMplSwitch = result.vMplSwitch;
						updateBookingMonthLOV();
					} else {	
					showMessageBox(result.message, imgMessage.ERROR);
					$("doe").value = $("paramDoe").value == "" ? "" : dateFormat($("paramDoe").value,"mm-dd-yyyy");//preDoe;
					}  // Dren 11.12.2015 SR-0020642 : Bond Backward Endt. - End
				} else {
					$("txtEndtIssueYy").value = nvl(result.endtYy, "");
					$("doe").value = nvl(result.effDate, "");
					endtBondVar.vAddTime = result.vAddTime;
					endtBondVar.vMplSwitch = result.vMplSwitch;
					updateBookingMonthLOV();
				}
				$("noOfDays2").value = computeNoOfDays($F("doe"),$F("eed"),$F("compSw")); //added by robert GENQA SR 4825 08.04.15
			}
		});
	}
	
	function updateBookingMonthLOV(){
		/** Start here Nica 05.25.2012 Added the following lines to 
	    refresh booking month whenever endt effectivity date changes **/
	   
		new Ajax.Request(contextPath + "/GIPIParInformationController?action=getBookingDate", {
			method : "POST",
			parameters : {
				parId : $F("globalParId"),
				parVarVDate :  params.varVDate,
				issueDate : $F("issueDate"),
				effDate : $F("doe")
			},		
			asynchronous: false,
		    evalScripts: true,
			onComplete : function(response){
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText.replace(/\\/g,'\\\\'));
					
					function updateBookingLOV(objArray){
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
					
					obj.parVarIDate = dateFormat(obj.parVarIDate,"mm-dd-yyyy");
					
					// update booking listing
					new Ajax.Request(contextPath+"/GIPIParInformationController",{
						parameters:{
							action : "getBookingListing",
							parId : $F("globalParId"),
							date : obj.parVarIDate				
						},			
						asynchronous: false,
					    evalScripts: true,
						onComplete:function(response){
							var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
							updateBookingLOV(res);
							
							for(var i=0, length=$("bookingMonth").options.length; i < length; i++){														
								if ($("bookingMonth").options[i].getAttribute("bookingMth") == obj.bookingMth 
									&& $("bookingMonth").options[i].getAttribute("bookingYear") == obj.bookingYear){
									$("bookingMonth").selectedIndex = i;
									$("bookingYear").value = obj.bookingYear;
									$("bookingMth").value = obj.bookingMth;
									break;
								}	
							}
						}	
					});												
				}
			}
		});
		
		/** End here Nica 05.25.2012**/
	}
	
	$("hrefBondExpiryDate").observe("click", function () {	//added by Gzelle 12192014
		$("paramBondExpiry").value = $("bondExpiry").value;		
	});
	
	$("bondExpiry").observe("change", function (){
		if ($F("bondExpiry") != ""){
			if (makeDate($F("bondExpiry")) < makeDate($F("doe"))){
				showMessageBox("Expiry date should not be earlier than the effectivity date of the Endorsement.", imgMessage.ERROR);
				$("bondExpiry").value = dateFormat($F("paramBondExpiry"), "mm-dd-yyyy");
				return false;
			} else if (makeDate($F("bondExpiry")) < makeDate($F("doe"))){
				showMessageBox("Expiry date should not be earlier than the Inception date of the Bond.", imgMessage.INFO);
				$("bondExpiry").value = dateFormat($F("paramBondExpiry"), "mm-dd-yyyy");
				return false;
			} 
		}
	});

	$("hrefEedDate").observe("click", function () {	//added by Gzelle 01092015
		$("paramEed").value = $("eed").value;		
	});
	
	var preEed = $("eed").getAttribute("pre-text");
	$("eed").observe("change", function (){
		if ($F("eed") != ""){
			if (makeDate($F("eed")) < makeDate($F("doe"))){
				showMessageBox("Endorsement expiry date should not be earlier than the effectivity date of the Endorsement.", imgMessage.ERROR);
				$("eed").value = preEed;
				return false;
			} else if (makeDate($F("eed")) < makeDate($F("doi"))){
				showMessageBox("Endorsement expiry date should not be earlier than the Inception date of the Bond.", imgMessage.INFO);
				$("eed").value = preEed;
				return false;
			} else if (makeDate($F("eed")) > makeDate($F("bondExpiry"))){
				showMessageBox("The endorsement expiry date should not be later than the policy expiry date.", imgMessage.ERROR);
				$("eed").value = $F("paramEed");
				return false;				
			}
/* 			else if ($F("paramDoe") != "" && $F("eed") != '${convEndtExpiry }') { //added by robert SR 4828 08.27.15
				if ($F("deleteBillSw") == "N") {
					showConfirmBox(
							"Confirmation",
							"User has altered the endorsement expiry date of this PAR from "
									+ '${convEndtExpiry }'
									+ " to "
									+ $("eed").value
									+ '. All information related to this PAR will be deleted. Continue anyway?',
							"Yes", "No", function(){
								$("deleteBillSw").value = "Y";
							},
							"");
				} //end robert SR 4828 08.27.15
			} */
			//added by robert GENQA SR 4825 08.04.15
			// Dren 11.12.2015 SR-0020642 : Moved condition to Save Button.
			defaultEED();
			if ($("defaultEED").value != $("eed").value){
				$("prorateFlag").value = "1";
			}else{
				$("prorateFlag").value = "2";
			}
			showProrateRelatedSpan();
			//end robert GENQA SR 4825 08.04.15
		}
	});
	
	$("hrefDoiDate").observe("click", function () {	//added by Gzelle 12192014
		$("paramDoi").value = $("doi").value;		
	});
	
	$("doi").observe("change", function (){
		if ($F("doi") != ""){
			if (makeDate($F("doi")) > makeDate($F("doe"))){
				showMessageBox("Inception date should not be later than the effectivity date of the Endorsement", imgMessage.ERROR);
				$("doi").value = dateFormat($F("paramDoi"), "mm-dd-yyyy");
				return false;
			} else if (makeDate($F("doi")) > makeDate($F("bondExpiry"))){
				showMessageBox("Inception date should not be later than Expiry date of the Bond", imgMessage.ERROR);
				$("doi").value = dateFormat($F("paramDoi"), "mm-dd-yyyy");
				return false;
			} else {
				if($F("doe") == "" || $F("eed") == "" || $F("doi") == "") {
					
				} else {
					validateEndtInceptExpiryDate();
				}
				
			}
		}
	});

	function validateEndtInceptExpiryDate(){
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
				fieldName : "INCEPT_DATE"
			},
			asynchronous : true,
			evalScripts : true,
			onCreate : showNotice("Validating date, please wait..."),
			onComplete : function(response){
				hideNotice("");
				if (checkErrorOnResponse(response)) {
					hideNotice("");
					var result = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));

					if(nvl(result.msgAlert,null) != null){
						showMessageBox(result.msgAlert, imgMessage.WARNING);
					}
				}
			}
		});
	}

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

	function saveEndtBondBasicInfo(){
		if(!checkAllRequiredFieldsInDiv("bondEndtBasicInformationDivOthers")){ //Added by Jerome 08.10.2016 SR 5589
			return false;
		} else {
		//added by gab 02.21.2017 SR 3147,3027,2645,2681,3148,3206,3264,3010
		if ($F("refPolNo") == "") {
			if (reqRefPolNo == "Y"){
				customShowMessageBox("Reference Policy No. is required.", imgMessage.ERROR, "refPolNo");
				return false;
			}
		}
		if ($F("bankRefNo") == "") {
			if (reqRefNo == "Y") {
				customShowMessageBox("Bank Reference Number is required.",imgMessage.ERROR, "nbtAcctIssCd");
				return false;
			}
		}
		if ($F("doe") == ""){
			showMessageBox("Cannot proceed, endorsement effectivity date should not be null.", imgMessage.ERROR);
			return false;
		} else if ($F("eed") == ""){
			showMessageBox("Cannot proceed, endorsement expiry date should not be null.", imgMessage.ERROR);
			return false;
		} else if ($F("bookingMonth") == ""){
			showMessageBox("Cannot proceed, booking date should not be null", imgMessage.ERROR);
			return false;
		} else if (($("chkEndtCancellation").checked || $("chkCoiCancellation").checked) && endtBondVar.cancelPolId == "N") {
			showMessageBox("Please press Cancel Endt button to choose record for cancellation", imgMessage.INFO);
			return false;
		} else if(reqRefNo == "Y" && $F("dspModNo") == "00"){	//added by Gzelle 12042014 SR3092
				customShowMessageBox("Please provide a bank reference number for this PAR before saving the policy.",imgMessage.ERROR,"nbtAcctIssCd");
				return false;				
		} else if ($F("paramDoe") != "" && $F("doe") != $F("paramDoe")) { // Dren 11.12.2015 SR-0020642 : Moved condition to Save Button - Start
				if ($F("deleteBillSw") == "N") {
					showConfirmBox(
							"Confirmation",
							"User has altered the endorsement effectivity date of this PAR from "
									+ $("paramDoe").value
									+ " to "
									+ $("doe").value
									+ '. All information related to this PAR will be deleted. Continue anyway?',
							"Yes", "No", function(){
								$("deleteBillSw").value = "Y";
								continueSaving();
							},
							"");
				}
		  continueSaving(); // Dren 11.12.2015 SR-0020642 : Moved condition to Save Button - End	
		} else {
			if (checkAllRequiredFieldsInDiv("bondEndtBasicInformationDivOuter")) {	//added by Gzelle 12042014 SR2917/3066
				//added by robert GENQA 4828 08.25.15
				if(validateBondAutoPrem()){
					showConfirmBox("Confirmation", "This endorsement will extend the duration of the bond/policy. Would you like the system to compute the premium?", "Yes", "No", 
							function(){
								$("bondAutoPrem").value = "Y";
								continueSaving();
							}, 
							function(){
								$("bondAutoPrem").value = "N";
								continueSaving();
							}
					);
				}else{
					$("bondAutoPrem").value = "N";
					continueSaving();
				}
				//end robert GENQA 4828 08.25.15
			}
		}
	  }
	}
		
	function continueSaving(){
		var bondObj = prepareEndtBond();
		//bondObj.gipiWPolbas = prepareJsonAsParameter(bondObj.gipiWPolbas); // bonok :: 03.27.2014 :: for JSON Exception encountered in SR 14391
		//bondObj.gipiWEndtTextObj = prepareJsonAsParameter(bondObj.gipiWEndtTextObj);
		//bondObj.gipiWGenInfoObj = prepareJsonAsParameter(bondObj.gipiWGenInfoObj);
		bondObj.gipiParList = prepareParListParams();
		bondObj.variables = prepareJsonAsParameter(bondObj.variables);
		var bondBasicObj = JSON.stringify(bondObj);
	
		new Ajax.Request(contextPath+"/GIPIWBondBasicController?action=saveEndtBondBasicInfo"/* &parameters="+encodeURIComponent(bondBasicObj) */,{
			method : "POST",
			parameters: {
				parameters: bondBasicObj
			},
			//postBody : Form.serialize("endtBondBasicInfoForm"),
			evalScripts : true,
			asynchronous : false,
			onCreate : function (){
				showNotice("Saving endorsement bond basic information. Please wait...");
			},
			onComplete : function (response){
				hideNotice("");
				if (checkErrorOnResponse(response)){
					if (response.responseText == "SUCCESS"){
						hideNotice("");
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
							showEndtBondBasicInfo();
							enableMenu("bondPolicyData");
							enableMenu("post");
							enableMenu("bill");
						});
						changeTag = 0;
						if ($F("polFlag") == "Y"){
							$("polFlag").value = "N";
						}
						updateParParameters();
						//$("globalParStatus").value = "6";
					}else{
						showMessageBox(response.responseText, "E");
					}
				}else{
					showMessageBox(response.responseText, "E");
				}
			}
		});
		
		//showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
	}

	function prepareInfoParams(param){
		var object = new Object();
		var paramObject = new Object();
		if (param == "endtText"){
			object.input = ($F("endtInformation"));
		} else if (param == "genInfo"){
			object.input = ($F("generalInfo"));
		}
		
		object.textInfo = param;

		paramObject[param] = object.input;
		if (object.input.length > 1){
			for (var i = 1; i <= 17; i++){
				var txtInput = String(object.textInfo) + i.toPaddedString(2);
				var base = 2000 * (i-1);
				paramObject[txtInput] = (String(object.input).substring((base), (base+2000)));
				//paramObject[txtInput] = escapeHTML2(object.input.substr(base, base+2000));
			}
		}
		return paramObject;
	}

	function prepareParListParams() {
		try {
			var obj = new Object();
			obj.parId 			= $F("globalParId");
			obj.parType 		= nvl($F("b240ParType"), "E");
			obj.parStatus		= $F("b240ParStatus");
			obj.lineCd 			= $F("txtLineCd");
			obj.issCd			= $F("b240IssCd");
			obj.parYy			= $F("b240ParYy");
			obj.parSeqNo		= $F("b240ParSeqNo");
			obj.quoteSeqNo 		= $F("b240QuoteSeqNo");
			obj.assdNo 			= $F("assuredNo") == "" ? $F("paramAssuredNo") : $F("assuredNo");
			obj.address1		= unescapeHTML2($F("b240Address1")); // marco - 01.02.2013 - added unescapeHTML2 to address objects
			obj.address2		= unescapeHTML2($F("b240Address2"));
			obj.address3		= unescapeHTML2($F("b240Address3"));
			return obj;
		} catch(e) {
			showErrorMessage("prepareParListParams", e);
		}
	}
	
	function prepareEndtBond(){
		var endtBondObj = new Object();
		//for gipiWPolbas values...
		var gipiWPolBasObj = new Object();
		gipiWPolBasObj.parId = $F("globalParId");
		gipiWPolBasObj.assdNo = $F("assuredNo");
		gipiWPolBasObj.lineCd = $F("txtLineCd");
		gipiWPolBasObj.sublineCd = $F("txtSublineCd");
		gipiWPolBasObj.issCd = $F("txtIssCd");
		gipiWPolBasObj.issueYy = $F("txtIssueYy");
		gipiWPolBasObj.polSeqNo = $F("txtPolSeqNo");
		gipiWPolBasObj.renewNo = parseInt($F("txtRenewNo"));
		gipiWPolBasObj.endtIssCd = $F("txtEndtIssCd");
		gipiWPolBasObj.endtYy = $F("txtEndtIssueYy");
		gipiWPolBasObj.inceptDate = $F("doi");
		gipiWPolBasObj.inceptTag = $F("inceptTag");
		gipiWPolBasObj.expiryDate = $F("bondExpiry");
		gipiWPolBasObj.expiryTag = $F("expiryTag");
		gipiWPolBasObj.effDate = $F("doe");
		gipiWPolBasObj.endtExpiryDate = $F("eed");
		gipiWPolBasObj.endtExpiryTag = $F("endtExpiryTag");
		gipiWPolBasObj.issueDate = $F("issueDate");
		gipiWPolBasObj.refPolNo = $F("refPolNo");
		gipiWPolBasObj.typeCd = $F("polType");
		gipiWPolBasObj.regionCd = $F("region");
		gipiWPolBasObj.address1 = escapeHTML2($F("address1")); //escapeHTML2 christian 03/12/2013
		gipiWPolBasObj.address2 = escapeHTML2($F("address2")); //escapeHTML2 christian 03/12/2013
		gipiWPolBasObj.address3 = escapeHTML2($F("address3")); //escapeHTML2 christian 03/12/2013
		gipiWPolBasObj.mortgName = escapeHTML2($F("mortgagee")); //escapeHTML2 christian 03/12/2013
		gipiWPolBasObj.industryCd = $F("industry");
		gipiWPolBasObj.credBranch = $F("creditedBranch");
		gipiWPolBasObj.bookingMth = $("bookingMonth").options[$("bookingMonth").selectedIndex].getAttribute("bookingmth");
		gipiWPolBasObj.bookingYear = $("bookingMonth").options[$("bookingMonth").selectedIndex].getAttribute("bookingyear");
		gipiWPolBasObj.takeupTerm = $F("takeupTermType");
		gipiWPolBasObj.inceptTag = $("inceptTag").checked ? "Y" : "N";
		gipiWPolBasObj.expiryTag = $("expiryTag").checked ? "Y" : "N";
		gipiWPolBasObj.endtExpiryTag = $("endtExpiryTag").checked ? "Y" : "N";
		gipiWPolBasObj.regPolicySw = $("regPolSw").checked ? "Y" : "N";
		gipiWPolBasObj.foreignAccSw = $("foreignAccSw").value;
		gipiWPolBasObj.invoiceSw = $("invoiceSw").value;
		gipiWPolBasObj.autoRenewFlag = $("autoRenewFlag").value;
		gipiWPolBasObj.provPremTag = $("provPremTag").value;
		gipiWPolBasObj.packPolFlag = $("packPolFlag").value;
		gipiWPolBasObj.coInsuranceSw = $("coInsuranceSw").value;
		gipiWPolBasObj.polFlag = $F("polFlag");
		gipiWPolBasObj.endtSeqNo = $F("endtSeqNo");
		gipiWPolBasObj.tsiAmt = $F("tsiAmt");
		gipiWPolBasObj.premAmt = $F("premAmt");
		gipiWPolBasObj.annTsiAmt = $F("annTsiAmt");
		gipiWPolBasObj.annPremAmt = $F("annPremAmt");

		gipiWPolBasObj.oldAssdNo = params.gipiWPolbas.oldAssdNo;				//added by steven 8/31/2012
		//added unescapeHTML2 by robert for oldaddress 5/30/2013 
		gipiWPolBasObj.oldAddress1 =  unescapeHTML2(params.gipiWPolbas.oldAddress1);				//added by steven 8/31/2012
		gipiWPolBasObj.oldAddress2 =  unescapeHTML2(params.gipiWPolbas.oldAddress2);				//added by steven 8/31/2012
		gipiWPolBasObj.oldAddress3 =  unescapeHTML2(params.gipiWPolbas.oldAddress3);				//added by steven 8/31/2012
		//added by robert GENQA SR 4825 08.04.15		
		gipiWPolBasObj.prorateFlag = $F("prorateFlag");
		gipiWPolBasObj.compSw = $F("compSw");
		gipiWPolBasObj.shortRtPercent = $F("shortRatePercent");
		//end robert GENQA SR 4825 08.04.15
		gipiWPolBasObj.bondAutoPrem = $F("bondAutoPrem"); //added by robert GENQA SR 4828 08.25.15
		gipiWPolBasObj.cancelType = objGIPIWPolbas.cancelType == null ? "" : objGIPIWPolbas.cancelType;
		if ($("txtBondSeqNo").getStyle("display") != "none"){
			gipiWPolBasObj.bondSeqNo = $F("txtBondSeqNo") == "" ? null : $F("txtBondSeqNo");
		}

		endtBondObj.gipiWPolbas = gipiWPolBasObj;
		endtBondObj.gipiWEndtTextObj = prepareInfoParams("endtText");
		endtBondObj.gipiWGenInfoObj = prepareInfoParams("genInfo");

		endtBondVar.expChgSw = $F("expChgSw");
		endtBondVar.endtCancellationFlag = $F("endtCancellationFlag");
		endtBondVar.coiCancellationFlag = $F("coiCancellationFlag");
		endtBondVar.varPolChangedSw = $F("varPolChangedSw");
		endtBondVar.checkboxChgSw = $F("checkboxChgSw");
		endtBondVar.parStatus = $F("globalParStatus");
		endtBondVar.deleteBillSw = $F("deleteBillSw"); //added by robert GENQA SR 4825 08.04.15
		endtBondObj.variables = endtBondVar;

		endtBondObj.gipiWPolnrep = nvl(params.gipiWPolnrep, null) == null ? 
				new Array() : params.gipiWPolnrep;
		return endtBondObj;
	}

	$("chkCoiCancellation").observe("change", function (){
		$("checkboxChgSw").value = "Y";
		var checkbox = "chkCoiCancellation";
		if ($("bookingMonth").selectedIndex == 0){
			showMessageBox("Booking month and year is needed before performing cancellation.", imgMessage.INFO);
			$("chkCoiCancellation").checked = false;
			return false;
		} else {
			if ($("chkCoiCancellation").checked){
				enableButton("btnCancelEndt");
				disableDate("hrefDoiDate");
				disableDate("hrefDoeDate");
				disableDate("hrefBondExpiryDate");
				disableDate("hrefEedDate");
				$("chkEndtCancellation").checked = false;
				if ($F("bookingMonth") == ""){
					showMessageBox("Booking month and year is needed before performing cancellation.", imgMessage.INFO);
					return false;
				} else {
					objGipis165.bondSw = "Y";
					objGIPIWPolbas.cancelType = 4;
					confirmCancellation(checkbox);
				}
			} else {
				objGIPIWPolbas.cancelType = null;
				disableButton("btnCancelEndt");
				showConfirmBox("", "All negated records for this policy will be deleted.", "Accept", "Cancel", acceptFunc, cancelFunc);
			}
		}
	});
	
	$("chkEndtCancellation").observe("change", function (){
		$("checkboxChgSw").value = "Y";
		var checkbox = "chkEndtCancellation";
		if ($("bookingMonth").selectedIndex == 0){
			showMessageBox("Booking month and year is needed before performing cancellation.", imgMessage.INFO);
			$("chkEndtCancellation").checked = false;
			return false;
		} else {
			if ($("chkEndtCancellation").checked){
				enableButton("btnCancelEndt");
				disableDate("hrefDoiDate");
				disableDate("hrefDoeDate");
				disableDate("hrefBondExpiryDate");
				disableDate("hrefEedDate");
				$("chkCoiCancellation").checked = false;
				if ($F("bookingMonth") == ""){
					showMessageBox("Booking month and year is needed before performing cancellation.", imgMessage.INFO);
					return false;
				} else {
					objGipis165.bondSw = "Y";
					objGIPIWPolbas.cancelType = 3;
					confirmCancellation(checkbox);
				}
			} else {
				objGIPIWPolbas.cancelType = null;
				disableButton("btnCancelEndt");
				showConfirmBox("", "All negated records for this policy will be deleted.", "Accept", "Cancel", acceptFunc, cancelFunc);
			}
		}
	});

	$("btnCancelEndt").observe("click", function (){
		endtBondVar.cancelPolId = "Y";
		endtBondVar.endtSw = "N";
		//if (endtBondVar.endtCancellationFlag == "Y"){
		if (objGipis165.cancellationFlag == "Y"){
			showMessageBox("Only one endorsement record can be cancelled per endoresment PAR.", imgMessage.ERROR);
			return false;
		}
		
		if ($F("polFlag") == "4" && (!$("chkEndtCancellation").checked && !$("chkCoiCancellation").checked)){
			showMessageBox("Cancellation per endorsement is not allowed for PAR tagged for flat/pro-rate cancellation.", imgMessage.INFO);
			return false;
		} 
		
		if ($("chkEndtCancellation").checked){
			new Ajax.Request(contextPath + "/GIPIParInformationController?action=checkPolicyForAffectingEndtToCancel",{
				method : "GET",
				parameters : {
					parId : $F("globalParId"),
					lineCd : $F("txtLineCd"),
					sublineCd : $F("txtSublineCd"),
					issCd : $F("txtIssCd"),
					issueYy : $F("txtIssueYy"),
					polSeqNo : $F("txtPolSeqNo"),
					renewNo : $F("txtRenewNo")
				},
				aysnchronous : false,
				evalScripts : true,
				onCreate : showNotice("Checking policy, please wait..."),
				onComplete : function(response){
					if (checkErrorOnResponse(response)){
						hideNotice("");
						if(response.responseText == "Y"){
							endtBondVar.endtSw = "Y";
							checkEndtSw();
						}
						
					}
				}			
			});
		} else if ($("chkCoiCancellation").checked){
			endtBondVar.endtSw = "Y";
			checkEndtSw();
		}
		
		if(objGipis165.bondSw == "N"){
			var existSw = "N";
			if(checkExistence("peril")){
				showConfirmBox("", "Existing details for this PAR would be deleted. Do you want to continue?", "Yes", "No", continueCancellation, "");
				existSw = "Y";
			} else if(checkExistence("item")){
				showConfirmBox("", "Existing item(s) for this PAR would be deleted. Do you want to continue?",  "Yes", "No", continueCancellation, "");
				existSw = "Y";
			} else {
				if (existSw == "N"){
					showMessageBox("There is no existing endorsement to be cancelled.", imgMessage.INFO);
					$("chkCoiCancellation").checked = false;
					$("chkEndtCancellation").checked = false;
					disableButton("btnCancelEndt");
					return false;
				}else{
					continueCancellation();
				}

				//block after displaying of LOV -- dito muna toh sa ngayon....
				if (endtBondVar.itemPerilCount > 0 && endtBondVar.itemCount > 0){
					var messTxt = "";
					if (endtBondVar.itemPerilCount > 0 && endtBondVar.itemCount > 0){
						messTxt = "item(s) and peril(s)";
					} else if (endtBondVar.itemCount > 0){
						messTxt = "item(s)";
					}

					showConfirmBox("Confirm cancellation", "This endorsement have existing " + messTxt + 
									", performing cancellation will cause all the records to be replaced.", "Accept", "Cancel",
									"", stopProcess);
				}  
			}
		}else{
			continueCancellation();
		}
		
	});
	
	function checkEndtSw(){
		if (endtBondVar.endtSw == "N"){
			showMessageBox("There is no existing endorsement to be cancelled.", imgMessage.INFO);
		}
	}

	function stopProcess(){
		$("chkEndtCancellation").checked = false;
	}
	
	function continueCancellation(){
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
					if (response.responseText != "0"){
						existTag = true;
					} else {
						if (code == "peril"){
							endtBondVar.itemPerilCount = response.responseText; 
						} else if (code == "item"){
							endtBondVar.itemCount = response.responseText;
						}
					}
				}
			}
		});
		return existTag;
	}
	
	$("findEndtTxt").observe("click", function (){
		objUW.hidObjGIPIS002 = {};
		//openSearchEndtText();
		showGiisEndtTextLOV();
	});

	$("editEndtInfoText").observe("click", function () {
		showEditor("endtInformation", 32767);
	});

	function acceptFunc(){
		//delete_other_info
		//delete_records(par_id)
		endtBondVar.cancelledFlatFlag = "Y";
		$("globalParStatus").value = "3";
		$("polFlag").value = "1";
		$("doe").value = "";
		enableDate("hrefDoiDate");
		enableDate("hrefDoeDate");
		enableDate("hrefBondExpiryDate");
		enableDate("hrefEedDate");
	}

	function cancelFunc(){
		$("polFlag").value = "4";
		endtBondVar.cancelledFlatFlag = "N";
	}

	function confirmCancellation(checkbox){
		var claimMessage = checkForPendingClaims();
		var checkPolicyObj = checkPolicy();
		if (claimMessage != ""){
			showMessageBox("The policy has pending claims, cannot cancel policy.", imgMessage.INFO);
			$("polFlag").value = "1";
			return false;
		} else if (checkPolicyObj.paidMsg == "N"){
			showConfirmBox("", "Payments have been made to the policy/endorsement to be cancelled. Continue?", "Accept", "Cancel", "", "");
		} else {
			if (checkbox == "chkEndtCancellation"){
				$("endtCancellationFlag").value = "Y";
			} else if (checkbox == "chkCoiCancellation"){
				$("coiCancellationFlag").value = "Y";
			}
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

	function checkForPendingClaims(){
		var pendingClaimMsg = "";
		new Ajax.Request(contextPath + "/GIPIParInformationController?action=checkForPendingClaims", {
			method : "GET",
			parameters : {
				parId : $F("globalParId"),
				lineCd : $F("globalLineCd"),
				sublineCd : $F("globalSublineCd"),
				issCd : $F("globalIssCd"),
				issueYy : $F("txtIssueYy"),
				polSeqNo : $F("txtPolSeqNo"),
				renewNo : $F("txtRenewNo")
			},
			asynchronous : true,
			evalScripts : true,
			onCreate : showNotice("Checking for pending claims, please wait..."),
			onComplete : 
				function(response){
					if (checkErrorOnResponse(response)){
						hideNotice("Done!");							
						pendingClaimMsg = response.responseText;
					}											
				}
		});

		return pendingClaimMsg;
	}

	function showEditPolicyNo() {
		//replace this block with similar function
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
			//Deo [01.03.2017]: added encodeURIComponent in sublineCd (SR-23567)
			showOverlayContent2(contextPath+"/"+controller+"?action="+action+"&parId="+parId+"&lineCd="
					+lineCd+"&issCd="+issCd+"&sublineCd="+encodeURIComponent(sublineCd)+"&polSeqNo="+polSeqNo+"&issueYy="+issueYy+"&renewNo="+renewNo,
						   "Policy No.", 490, overlayOnComplete);	
		}catch(e){
			showErrorMessage("showEditPolicyNo", e);
		}
	}
	
	function initBondBasic(){ //some menus are commented since its not existing in the current page...
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
		//$("prelimOneRiskDistTsiPrem").hide(); //added by robert SR 5053 11.11.15
		//$("prelimOneRiskDistTsiPrem").up("li",0).hide();	 //added by robert SR 5053 11.11.15
		//$("prelimDistTsiPrem").hide();  //added by robert SR 5053 11.11.15
		//$("prelimDistTsiPrem").up("li",0).hide();  //added by robert SR 5053 11.11.15
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
		if (/*$F("txtSublineCd")*/ $F("doe") != ""){
			$("bondPolicyData").show();
			enableMenu("bondPolicyData");
		}else{
			disableMenu("bondPolicyData");
		}
		var parStatus = $F("globalParStatus");
		parStatus > 4 ? enableMenu("bill") : disableMenu("bill");
		//parStatus == 6 && checkUserModule("GIPIS165")? enableMenu("post") : disableMenu("post");
		(parStatus > 2 && parStatus < 10) && checkUserModule("GIPIS055")? enableMenu("post") : disableMenu("post");
		
		if("${updIssueDate}" != "Y"){
			disableDate("hrefIssueDate"); // added by: Nica 05.14.2012
		}
		
		if($F("txtIssCd") == "RI"){ //added by christian 03/14/2013
			$("creditedBranch").disable();
			$("creditedBranch").value = "RI";
		}
		
		// Kris 07.04.2013 for UW-SPECS-2013-091
		// to display the default crediting branch if the current crediting branch is inactive. if the default is also inactive, crediting branch is null.
		if($("creditedBranch").value == "" && "${dispDefaultCredBranch}" == "Y"){
			if("${defaultCredBranch}" == "ISS_CD"){
				$("creditedBranch").value = $F("txtIssCd");
			}
		}
		
		/* Apollo 07.24.2015 SR# 2749
		Crediting Branch must be required regardless of the value of DEFAULT_CRED_BRANCH when MANDATORY_CRED_BRANCH = Y */
		if('${reqCredBranch}' == "Y") {
			$("creditedBranch").addClassName("required");
		}
		
	}
	
	// by bonok :: 07.12.2012 :: new LOV
	$("searchAssured").observe("click", function(){
		showAssuredListingTG($F("txtLineCd"));
	});
	
	// by bonok :: 07.09.2012 :: new LOV
	$("mortgagee").observe("keyup", function(){
		$("mortgagee").value = $("mortgagee").value.toUpperCase();	
	});
	
	function getMortgageeLOVGipis165(){
		var notIn = $F("mortgagee") == "" ? "" : "(\'"+$F("mortgagee")+"\')";
		showMortgageeLOVGipis165($F("txtIssCd"),$F("mortgagee"),notIn,function(row){
			 if(row != undefined){
				$("mortgagee").value = unescapeHTML2(row.mortgName);
				$("mortgagee").focus(); 
				changeTag = 1;
			 }
		});
	}
	
	function getMortgageeLOVClickGipis165(){
		var notIn = $F("mortgagee") == "" ? "" : "(\'"+$F("mortgagee")+"\')";
		showMortgageeLOVGipis165($F("txtIssCd"),"",notIn,function(row){
			 if(row != undefined){
				$("mortgagee").value = unescapeHTML2(row.mortgName);
				$("mortgagee").focus(); 
				changeTag = 1;
			 }
		});
	}
	
	function mortgageeLOV(row){
		if(row != undefined){
			$("mortG").value = unescapeHTML2(row.mortgName);
			$("mortgCd").value = row.mortgCd;
			$("mortG").focus(); 
			changeTag = 1;
		}
	}
	
	$("searhMortgagee").observe("click", getMortgageeLOVClickGipis165);
	$("mortgagee").observe("change", getMortgageeLOVGipis165);
	// by bonok :: 07.09.2012 :: new LOV end :|

	/*if($F("polFlag") == "4"){
		disableDate("hrefDoeDate");
	}else{
		enableDate("hrefDoeDate");
	}*/
	
	$("bondExpiry").observe("change", function(){
		$("eed").value = this.value;
		fireEvent($("eed"), "change"); //added by robert SR 4828 08.27.15
	});
	//added by robert GENQA SR 4825 08.04.15	
	function showProrateRelatedSpan(){			
		if ($F("prorateFlag") == "1")	{ //PRORATE
			$("shortRateSelected").hide();
			$("shortRatePercent").removeClassName("moneyRate2 required");
			$("shortRatePercent").hide();
			$("prorateSelected").show();
			$("noOfDays2").writeAttribute("class","required integerNoNegativeUnformattedNoComma");
			$("noOfDays2").show();
			$("noOfDays2").value = computeNoOfDays($F("doe"),$F("eed"),$F("compSw"));
		} else if ($F("prorateFlag") == "3") {	//SHORT
			$("prorateSelected").hide();
			$("shortRateSelected").show();
			$("shortRatePercent").writeAttribute("class","moneyRate2 required");
			$("shortRatePercent").show();
			$("noOfDays2").removeClassName("required integerNoNegativeUnformattedNoComma");
			$("noOfDays2").hide();
			$("noOfDays2").value = "";					
		} else {		//STRAIGHT
			$("shortRateSelected").hide();
			$("shortRatePercent").removeClassName("moneyRate2 required");
			$("shortRatePercent").hide();
			$("prorateSelected").hide();
			$("noOfDays2").removeClassName("required integerNoNegativeUnformattedNoComma");
			$("noOfDays2").hide();
			$("noOfDays2").value = "";
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
			$("shortRatePercent").value = formatTo9DecimalNoParseFloat($F("shortRatePercent"));
		}
	});	
	
	function defaultEED() {
		var iDateArray = $F("doe").split("-");
		if (iDateArray.length > 1)	{
			var iDate = new Date();
			var date = parseInt(iDateArray[1], 10);
			var month = parseInt(iDateArray[0], 10) + 12;
			var year = parseInt(iDateArray[2], 10);
			if (month > 12) {
				month -= 12;
				year += 1;
			}
			$("defaultEED").value = (month < 10 ? "0"+month : month) +"-"+(date < 10 ? "0"+date : date)+"-"+year;
			$("defaultEED").focus();
		}
	}
	
	$("compSw").observe("change", function () {
		var noOfDays = $("noOfDays2").value;
		$("noOfDays2").value = computeNoOfDays($F("doe"),$F("eed"),$F("compSw"));
		if (parseInt($("noOfDays2").value) < 0 && $F("compSw") == "M"){
			showMessageBox("Tagging of -1 day will result to invalid no. of days. Changing is not allowed.", imgMessage.ERROR);
			$("noOfDays2").value = noOfDays ;
			$("compSw").value = preCompSw;
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
		var tempProrateFlag = $("prorateFlag").options[(nvl($("paramProrateFlag").value,2) - 1)].text; //robert SR 4828 08.27.15
		if ($("deleteBillSw").value == "N") {
			if ($F("wInvoiceExists") == "1"){
				if ($("prorateFlag").value != $("paramProrateFlag").value) {
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
		}
		function onCancelFunc() {
			$("deleteBillSw").value = "N";
			$("prorateFlag").value = $("paramProrateFlag").value;
			$("prorateFlag").focus();
			showProrateRelatedSpan();
		}
	});
 	initializeAllMoneyFields();
	showProrateRelatedSpan();
	defaultEED();
	//end robert GENQA SR 4825 08.04.15
	//added by robert GENQA SR 4828 08.25.15
	function validateBondAutoPrem(){
		var extend = false;	
		if(makeDate($F("doe")) >= makeDate(defaultExpiryDate) && makeDate($F("bondExpiry")) > makeDate(defaultExpiryDate)){
			extend = true;
		}
		return extend;
	}
	//end robert GENQA SR 4828 08.25.15
	objGipis165.prepareEndtBond = prepareEndtBond; //added by robert 11.22.2013 
	objGipis165.prepareParListParams = prepareParListParams; //added by robert 11.22.2013
	
	disableButton("btnCancelEndt");
	updateParParameters();
	observeChangeTagOnDate("hrefDoiDate", "doi");
	observeChangeTagOnDate("hrefDoeDate", "doe");
	observeChangeTagOnDate("hrefIssueDate", "issueDate");
	observeChangeTagOnDate("hrefBondExpiryDate", "bondExpiry");
	observeChangeTagOnDate("hrefEedDate", "eed");
	initBondBasic();
</script>