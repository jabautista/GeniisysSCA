<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="ajax" uri="http://ajaxtags.org/tags/ajax"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<jsp:include page="/pages/claims/claimBasicInformation/basicMenu.jsp"></jsp:include>

<div id="basicInformationMainDiv" name="basicInformationMainDiv">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Basic Information</label> 
			<span class="refreshers" style="margin-top: 0;">
				<label name="gro" style="margin-left: 5px;">Hide</label>
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
		</div>
	</div>
	<div class="sectionDiv" id="basicInformationDiv">
		<div id="basicInformation" changeTagAttr="true">
			<input type="hidden" id="userLevel" value="${userLevel}" />
			<input type="hidden" id="accessErrMessage" value="${accessErrorMessage}" />
			<input type="hidden" id="clmControl" />
			<input type="hidden" id="lineCd" name="lineCd" value="${lineCd}">
			<input type="hidden" id="refreshSw" />
			<input type="hidden" id="valPolIssueDateFlag" value="${valPolIssueDateFlag}" />
			<table border="0" style="margin-top: 10px; margin-bottom: 10px; width: 100%;">
				<tr>
					<td class="rightAligned" style="width: 100px;"></td>
					<td class="leftAligned"></td>
					<td style="width: 100px;"></td>
					<td class="leftAligned">
						<input type="checkbox" id="chkLossRecovery" style="float: left;" value=""><label style="float: left; width: 130px; text-align: left; margin-top: 0px; margin-left: 4px;">Loss Recovery</label></input>
						<input type="checkbox" id="chkPackPol" style="float: left;" disabled="disabled">
						<label style="float: left; width: 100px; text-align: left; margin-top: 0px; margin-left: 4px;">Package Policy</label></input>
					</td>
				</tr>
				<tr>
					<td class="rightAligned"><label id="packPolNoLbl" class="" style="width: 90px; text-align: right; margin-left: 10px;">Pack Policy No.</label></td>
					<td class="leftAligned">
						<input id="txtPackPolNo" name="txtPackPolNo" type="text" style="width: 334px;" value="" readonly="readonly"/>
					</td>
					<td class="leftAligned"></td>
					<td class="leftAligned">
						<input type="checkbox" id="chkOkProcessing" style="float: left;" updatable="N" value="Y">
							<label style="float: left; width: 130px; text-align: left; margin-top: 0px; margin-left: 4px;">Ok for Processing</label></input>
						<input type="checkbox" id="chkTotalLoss" style="float: left;" value="">
							<label style="float: left; width: 100px; text-align: left; margin-top: 0px; margin-left: 4px;">Total Loss</label> </input>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Claim No.</td>
					<td class="leftAligned">
						<input id="txtClmLineCd" name="txtClmLineCd" type="text" style="width: 42px;" value="" readonly="readonly" />
						<input id="txtClmSublineCd" name="txtClmSublineCd" type="text" style="width: 92px;" value="" readonly="readonly" /> 
						<input id="txtClmIssCd" name="txtClmIssCd" type="text" style="width: 42px;" value="" readonly="readonly" />
						<input id="txtClmYy" name="txtClmYy" type="text" style="width: 30px;" value="" readonly="readonly" />
						<input id="txtClmSeqNo" name="txtClmSeqNo" type="text" style="width: 80px;" value="" readonly="readonly" />
					</td>
					<td class="rightAligned"><label id="opNoLbl" class="" style="width: 90px; text-align: right; margin-left: 10px;">OP No.</label></td>
					<td class="leftAligned"><input id="txtOpNumber" name="txtOpNumber" type="text" style="width: 300px;" value="" />
					</td>
				</tr>
				<tr>
					<c:choose>
						<c:when test="${empty claimId}">
							<td class="leftAligned" colspan="2">
								<label style="float: left; text-align: right; margin-top: 6px; margin-right: 8px;">Policy No.</label>
								<div style="width: 43px; float: left;" class="withIconDiv">
									<input type="text" id="txtLineCd" name="txtLineCd" value="" style="width: 18px;" class="withIcon allCaps" maxlength="2">
									<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtLineCdIcon" name="txtLineCdIcon" alt="Go" />
								</div>

								<div style="width: 89px; float: left;" class="withIconDiv">
									<input type="text" id="txtSublineCd" name="txtSublineCd" value="" style="width: 64px;" class="withIcon allCaps" maxlength="7">
									<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtSublineCdIcon" name="txtSublineCdIcon" alt="Go" />
								</div>

								<div style="width: 43px; float: left;" class="withIconDiv">
									<input type="text" id="txtPolIssCd" name="txtPolIssCd" value="" style="width: 18px;" class="withIcon allCaps" maxlength="2">
									<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtPolIssCdIcon" name="txtPolIssCdIcon" alt="Go" />
								</div>

								<div style="width: 43px; float: left;" class="withIconDiv">
									<input type="text" id="txtIssueYy" name="txtIssueYy" value="" style="width: 18px;" class="withIcon integerNoNegativeUnformattedNoComma" maxlength="2">
									<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtIssueYyIcon" name="txtIssueYyIcon" alt="Go" />
								</div>

								<div style="width: 89px; float: left;" class="withIconDiv">
									<input type="text" id="txtPolSeqNo" name="txtPolSeqNo" value="" style="width: 64px;" class="withIcon integerNoNegativeUnformattedNoComma" maxlength="7"> 
									<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtPolSeqNoIcon" name="txtPolSeqNoIcon" alt="Go" />
								</div>

								<div style="width: 43px; float: left;" class="withIconDiv">
									<input type="text" id="txtRenewNo" name="txtRenewNo" value="" style="width: 18px;" class="withIcon integerNoNegativeUnformattedNoComma" maxlength="2">
									<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtRenewNoIcon" name="txtRenewNoIcon" alt="Go" />
								</div>
							</td>
						</c:when>
						<c:otherwise>
							<td class="rightAligned">Policy No.</td>
							<td class="leftAligned">
								<div style="width: 43px; float: left;" class="withIconDiv">
									<input type="text" id="txtLineCd" name="txtLineCd" value="" style="width: 18px;" class="withIcon allCaps" maxlength="2">
									<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtLineCdIcon" name="txtLineCdIcon" alt="Go" />
								</div>

								<div style="width: 89px; float: left;" class="withIconDiv">
									<input type="text" id="txtSublineCd" name="txtSublineCd" value="" style="width: 64px;" class="withIcon allCaps" maxlength="7">
									<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtSublineCdIcon" name="txtSublineCdIcon" alt="Go" />
								</div>

								<div style="width: 43px; float: left;" class="withIconDiv">
									<input type="text" id="txtPolIssCd" name="txtPolIssCd" value="" style="width: 18px;" class="withIcon allCaps" maxlength="2">
									<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtPolIssCdIcon" name="txtPolIssCdIcon" alt="Go" />
								</div>

								<div style="width: 43px; float: left;" class="withIconDiv">
									<input type="text" id="txtIssueYy" name="txtIssueYy" value="" style="width: 18px;" class="withIcon integerNoNegativeUnformattedNoComma" maxlength="2">
									<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtIssueYyIcon" name="txtIssueYyIcon" alt="Go" />
								</div>

								<div style="width: 89px; float: left;" class="withIconDiv">
									<input type="text" id="txtPolSeqNo" name="txtPolSeqNo" value="" style="width: 64px;" class="withIcon integerNoNegativeUnformattedNoComma" maxlength="7">
									<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtPolSeqNoIcon" name="txtPolSeqNoIcon" alt="Go" />
								</div>

								<div style="width: 43px; float: left;" class="withIconDiv">
									<input type="text" id="txtRenewNo" name="txtRenewNo" value="" style="width: 18px;" class="withIcon integerNoNegativeUnformattedNoComma" maxlength="2">
									<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtRenewNoIcon" name="txtRenewNoIcon" alt="Go" />
								</div>
							</td>
						</c:otherwise>
					</c:choose>
					<td class="rightAligned">Loss Description</td>
					<td class="leftAligned">
						<input style="width: 70px; float: left;" type="text" id="txtLossCatCd" name="txtLossCatCd" readonly="readonly" class="required"/>
						<div style="width: 224px; margin-left: 4px; float: left;" class="withIconDiv required">
							<input style="width: 196px;" id="txtLossDesc" name="txtLossDesc" type="text" value="" readOnly="readonly" class="required withIcon" />
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmLossDesc" name="oscmLossDesc" alt="Go" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">
						<label id="assdPrincipalLbl" class="" style="width: 83px; text-align: right; margin-left: 17px;">Assured Name</label></td>
					<td class="leftAligned">
						<input type="hidden" id="txtAssuredNo" />
						<input style="width: 334px;" id="txtAssuredName" name="txtAssuredName" type="text" value="" readOnly="readonly" />
						<!-- <div style="width: 340px; float: left;" class="withIconDiv">
							<input type="hidden" id="txtAssuredNo" />
							<input style="width: 315px;" class="withIcon" id="txtAssuredName" name="txtAssuredName" type="text" value="" readOnly="readonly" />
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmClmAssured" name="oscmClmAssured" alt="Go" />
						</div> -->
					</td>
					<td class="rightAligned">Loss Details</td>
					<td class="leftAligned">
						<div style="float: left; width: 306px;" class="withIconDiv">
							<textarea onKeyDown="limitText(this,500);" onKeyUp="limitText(this,500);" id="txtLossDtls" name="txtLossDtls" style="width: 276px;" class="withIcon"> </textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editTxtLossDtls" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">
						<label id="LeasedToLbl" class="" style="width: 83px; text-align: right; margin-left: 17px;">Leased To/In Account Of</label>
					</td>
					<td class="leftAligned"><input type="hidden" id="txtAssuredNo">
						<input style="width: 334px;" id="txtLeasedTo" name="txtLeasedTo" type="text" value="" readOnly="readonly" />
					<td class="rightAligned">Location of Loss</td>
					<td class="leftAligned">
						<input id="txtLocOfLoss1" name="txtLocOfLoss1" type="text" style="width: 300px;" value="" maxlength="50" />
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Inception Date</td>
					<td class="leftAligned">
						<input style="float: left; width: 149px;" id="txtInceptionDate" name="txtInceptionDate" type="text" value="" readonly="readonly" />
						<!-- <div id="txtInceptionDateDiv" name="txtInceptionDateDiv" style="float: left; width: 155px;" class="withIconDiv">
							<input style="width: 130px;" id="txtInceptionDate" name="txtInceptionDate" type="text" value="" class="withIcon" readonly="readonly" />
							<img id="hrefExpiryDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Incept Date" onClick="scwShow($('txtInceptionDate'),this, null);" />
						</div> -->
						<label style="float: left; width: 58px; text-align: right; margin-top: 6px; margin-right: 8px;">Time</label>
						<input readonly="readonly" type="text" id="txtInceptionTime" name="txtInceptionTime" value="" style="width: 111px; float: left;" maxlength="11">
					</td>
					<td class="rightAligned"></td>
					<td class="leftAligned">
						<input id="txtLocOfLoss2" name="txtLocOfLoss2" type="text" style="width: 300px;" value="" maxlength="50" />
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Expiry Date</td>
					<td class="leftAligned">
						<input style="float: left; width: 149px;" id="txtExpiryDate" name="txtExpiryDate" type="text" value="" readonly="readonly" />
						<!--<div id="txtExpiryDateDiv" name="txtExpiryDateDiv" style="float: left; width: 155px;" class="withIconDiv">
							<input style="width: 130px;" id="txtExpiryDate" name="txtExpiryDate" type="text" value="" class="withIcon" readonly="readonly" />
							<img id="hrefExpiryDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Expiry Date" onClick="scwShow($('txtExpiryDate'),this, null);" /> 
						</div>-->
						<label style="float: left; width: 58px; text-align: right; margin-top: 6px; margin-right: 8px;">Time</label>
						<input readonly="readonly" type="text" id="txtExpiryTime" name="txtExpiryTime" value="" style="width: 111px; float: left;" maxlength="11">
					</td>
					<td class="rightAligned"></td>
					<td class="leftAligned">
						<input id="txtLocOfLoss3" name="txtLocOfLoss3" type="text" style="width: 300px;" value="" maxlength="50" />
					</td>

				</tr>
				<tr>
					<td class="rightAligned">Loss Date</td>
					<td class="leftAligned">
						<div id="txtLossDateDiv" name="txtLossDateDiv" style="float: left; width: 155px;" class="withIconDiv required">
							<input style="width: 130px;" id="txtLossDate" name="txtLossDate" type="text" value="" class="withIcon required" readonly="readonly" />
							<img id="hrefLossDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Loss Date" onClick="scwShow($('txtLossDate'),this, null);" />
						</div>
						<label style="float: left; width: 54px; text-align: right; margin-top: 6px; margin-right: 8px;">Time</label>
						<input type="text" id="txtLossTime" name="txtLossTime" value="" style="width: 111px; float: left;" maxlength="11">
					</td>
					<td class="rightAligned">Cedant</td>
					<td class="leftAligned">
						<input id="txtRiCd" name="txtRiCd" type="text" style="width: 70px;" value="" maxlength="6" class="integerNoNegativeUnformattedNoComma" readonly="readonly"/>
						<input id="txtCedant" name="txtCedant" type="text" style="width: 218px;" value="" readonly="readonly" />
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Claim Processor</td>
					<td class="leftAligned">
						<input id="txtInHouseAdjustment" name="txtInHouseAdjustment" type="text" style="float: left; width: 70px;" value="" readonly="readonly" />
						<div style="width: 258px; float: left; margin-left: 4px;" class="withIconDiv">
							<input style="width: 228px;" class="withIcon" id="txtClmProcessor" name="txtClmProcessor" type="text" value="" readOnly="readonly" />
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmClmProcessor" name="oscmClmProcessor" alt="Go" />
						</div>
					</td>
					<td class="rightAligned">CAT</td>
					<td class="leftAligned">
						<input style="text-align: right; float: left; width: 70px;" type="text" id="txtCatCd" name="txtCatCd" readonly="readonly">
						<div style="width: 224px; margin-left: 4px; float: left;" class="withIconDiv">
							<input style="width: 196px;" id="txtCat" name="txtCat" type="text" value="" readOnly="readonly" class="withIcon" />
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmCat" name="oscmCat" alt="Go" />
						</div>
					</td>
				</tr>
				<tr>
				</tr>
				<tr>
					<td class="rightAligned">Date Filed</td>
					<td class="leftAligned">
						<div id="txtDateFiledDiv" name="txtDateFiledDiv" style="float: left; width: 125px;" class="withIconDiv">
							<input style="width: 100px;" id="txtDateFiled" name="txtDateFiled" type="text" value="" class="withIcon" readonly="readonly" />
							<img id="hrefDateFiled" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date Filed" onClick="scwShow($('txtDateFiled'),this, null);" />
						</div>
						<label style="float: left; width: 84px; text-align: right; margin-top: 6px; margin-right: 8px;">Entry Date </label>
						<input type="text" id="txtClmEntryDate" name="txtClmEntryDate" value="" style="width: 111px; float: left;" readonly="readonly">
					</td>
					<td class="rightAligned">Crediting Branch</td>
					<td class="leftAligned">
						<input id="txtCreditBranch" name="txtCreditBranch" type="text" style="width: 70px;" value="" maxlength="2" class="allCaps" readonly="readonly"/>
						<input id="txtDspCredBrDesc" name="txtDspCredBrDesc" type="text" style="width: 218px;" value="" readonly="readonly" />
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Reported by</td>
					<td class="leftAligned">
						<input id="txtReportedBy" name="txtReportedBy" type="text" style="width: 334px;" value="" /></td>
					<td class="rightAligned">Zip Code</td>
					<td class="leftAligned">
						<input id="txtZipCode" name="txtZipCode" type="text" style="width: 300px;" value="" maxlength="6" />
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Remarks</td>
					<td class="leftAligned">
						<div style="float:left; width: 340px;" class="withIconDiv">
							<textarea class="withIcon" onKeyDown="limitText(this,4000);" onKeyUp="limitText(this,4000);" id="txtRemarks" name="txtRemarks" style="width: 311px;"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editTxtRemarks" />
						</div>
					</td>	
					<td class="rightAligned">Claim Status</td>
					<td class="leftAligned">
						<input style="float: left; width: 70px;" type="text" id="txtClmStatCd" name="txtClmStatCd" readonly="readonly"/>
						<div style="width: 224px; margin-left: 4px;" class="withIconDiv">
							<input style="width: 196px;" id="txtClmStat" name="txtClmStat" type="text" value="" readOnly="readonly" class="withIcon" />
							<img style="float: right; display: none;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmClmStat" name="oscmClmStat" alt="Go" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned"></td>
					<td class="leftAligned"><input id="txtUnpaid" name="txtUnpaid"
						type="text" style="width: 334px; text-align: center; color: red;"
						value="" readOnly="readonly" />
					</td>
					<td class="rightAligned"></td>
					<td class="leftAligned">
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div class="sectionDiv" id="motorCustomDiv" changeTagAttr="true">
		<div id="motorCustom" style="margin: 10px;">
			<table cellspacing="2" border="0" style="margin: 10px auto;">
				<tr>
					<td class="centerAligned">Plate Number</td>
					<td class="centerAligned">
						<div style="border: 1px solid gray; width: 306px; height: 21px; float: left;">
							<input type="hidden" id="txtLossId" />
							<input style="width: 281px; border: none; float: left;" id="txtPlateNumber" name="txtPlateNumber" type="text" value="" maxlength="20" />
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmPlateNumber" name="oscmPlateNumber" alt="Go" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="centerAligned">Motor Number</td>
					<td class="centerAligned">
						<div style="border: 1px solid gray; width: 306px; height: 21px; float: left;">
							<input type="hidden" id="txtLossId" />
							<input style="width: 281px; border: none; float: left;" id="txtMotorNumber" name="txtMotorNumber" type="text" value="" maxlength="20" />
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmMotorNumber" name="oscmMotorNumber" alt="Go" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="centerAligned">Serial Number</td>
					<td class="centerAligned">
						<div style="border: 1px solid gray; width: 306px; height: 21px; float: left;">
							<input type="hidden" id="txtLossId" />
							<input style="width: 281px; border: none; float: left;" id="txtSerialNumber" name="txtSerialNumber" type="text" value="" maxlength="25" />
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmSerialNumber" name="oscmSerialNumber" alt="Go" />
						</div>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div class="sectionDiv" id="customDiv">
		<div id="custom" style="margin: 10px;">
			<table cellspacing="2" border="0" style="margin: 10px auto;">
					<tr>
						<td class="centerAligned" id="provTD">Province</td>
						<td class="centerAligned">
							<div style="border: 1px solid gray; width: 306px; height: 21px; float: left;">
								<input style="width: 281px; border: none; float: left;" id="txtProvince" name="txtProvince" type="text" value="" readOnly="readonly" />
								<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmProvince" name="oscmProvince" alt="Go" />
							</div>
						</td>
					</tr>
					<tr>
						<td class="centerAligned" id="districtLblTD">City</td>
						<td class="centerAligned" id="districtTD">
							<div style="border: 1px solid gray; width: 306px; height: 21px; float: left;">
								<input type="hidden" id="txtCityCd" />
								<input type="hidden" id="txtlocationDesc" />
								<input type="hidden" id="txtlocationCd" />
								<input style="width: 281px; border: none; float: left;" id="txtCity" name="txtCity" type="text" value="" readOnly="readonly" />
								<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmCity" name="oscmCity" alt="Go" />
							</div>
						</td>
					</tr>
					<tr id="fireCustomRow">
						<td class="centerAligned" id="districtLblTD">District</td>
						<td class="centerAligned" id="districtTD">
							<div style="border: 1px solid gray; width: 306px; height: 21px; float: left;">
								<input style="width: 281px; border: none; float: left;" id="txtDistrictNo" name="txtDistrictNo" type="text" value="" readOnly="readonly" />
								<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmDistrict" name="oscmDistrict" alt="Go" />
							</div>
						</td>
					</tr>
					<tr id="fireCustomRow2">
						<td class="centerAligned">Block</td>
						<td class="centerAligned">
							<div style="border: 1px solid gray; width: 306px; height: 21px; float: left;">
								<input style="width: 281px; border: none; float: left;" id="txtBlockNo" name="txtBlockNo" type="text" value="" readOnly="readonly" />
								<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmBlock" name="oscmBlock" alt="Go" />
							</div>
						</td>
					</tr>
					<tr id="casualtyCustomRow">
						<td class="centerAligned" id="districtLblTD">Location</td>
						<td class="centerAligned" id="districtTD">
							<div style="border: 1px solid gray; width: 306px; height: 21px; float: left;">
								<input style="width: 281px; border: none; float: left;" id="txtLocation" name="txtLocation" type="text" value="" readOnly="readonly" />
								<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmLocation" name="oscmLocation" alt="Go" />
							</div>
								<input type="hidden" id="txtDistrictNo"/>
								<input type="hidden" id="txtBlockNo"/>
								<input type="hidden" id="txtlocationDesc"/>
								<input type="hidden" id="txtlocationCd"/>
						</td>
					</tr>
				</div>
			</table>
		</div>
	</div>
	<div class="sectionDiv" id="basicAddtlInformationDiv">
		<div id="basicAddtlInformation" style="margin: 10px;">
			<table cellspacing="2" border="0" style="margin: 10px auto;">
				<tr>
					<td class="rightAligned" style="width: 100px;">Loss Reserve</td>
					<td class="leftAligned" colspan="3">
					<input id="txtLossReserve" name="txtLossReserve" type="text" style="width: 278px;" value="" class="money" readonly="readonly" />
					</td>
					<td class="rightAligned" style="width: 120px;">Loss Paid</td>
					<td class="leftAligned" colspan="2">
						<input id="txtLossPaid" name="txtLossPaid" type="text" style="width: 300px;" value="" class="money" readonly="readonly" />
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 100px;">Expense Reserve</td>
					<td class="leftAligned" colspan="3">
						<input id="txtExpenseReserve" name="txtExpenseReserve" type="text" style="width: 278px;" value="" class="money" readonly="readonly" />
					</td>
					<td class="rightAligned" style="width: 120px;">Expense Paid</td>
					<td class="leftAligned" colspan="2">
						<input id="txtExpensePaid" name="txtExpensePaid" type="text" style="width: 300px;" value="" class="money" readonly="readonly" />
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 100px;">Entry Date</td>
					<td class="leftAligned" colspan="3">
						<input id="txtEntryDate" name="txtEntryDate" type="text" style="width: 278px;" value="" readonly="readonly" />
					</td>
					<td class="rightAligned" style="width: 120px;">Date Settled</td>
					<td class="leftAligned" colspan="2">
						<input id="txtDateSettled" name="txtDateSettled" type="text" style="width: 300px;" value="" readonly="readonly" />
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div class="buttonDiv" id="officialReceiptButtonDiv">
		<table align="left" border="0"
			style="margin-left: 100px; margin-bottom: 30px; margin-top: 10px;">
			<tr>
				<td><input type="button" class="button" id="processorHistBtn" name="processorHistBtn" value="Processor History" style="width: 120px;" /></td>
				<td><input type="button" class="button" id="clmStatHistBtn" name="clmStatHistBtn" value="Claim Status Hist" style="width: 120px;" /></td>
				<td><input type="button" class="button" id="adjusterBtn" name="adjusterBtn" value="Adjuster" style="width: 90px;" /></td>
				<td><input type="button" class="button" id="premWarrLetterBtn" name="premWarrLetterBtn" value="Premium Warranty Letter"style="width: 160px;" /></td>
				<td><input type="button" class="button" id="refreshBtn"name="refreshBtn" value="Refresh" style="width: 120px;" /></td>
				<td><input type="button" class="button" id="saveBtn"name="saveBtn" value="Save" style="width: 90px;" /></td>
			</tr>
			<tr>
				<td><input type="button" class="button" id="intermediaryBtn" name="intermediaryBtn" value="Intermediary" style="width: 120px;" /></td>
				<td><input type="button" class="button" id="bondPolBtn" name="bondPolBtn" value="Bond Policy Data" style="width: 120px;" /></td>
				<td><input type="button" class="button" id="mortgageeBtn" name="mortgageeBtn" value="Mortgagee" style="width: 90px;" /></td>
				<td><input type="button" class="button" id="settlingBtn" name="settlingBtn" value="Settling/Survey Agent" style="width: 160px;" /></td>
				<td><input type="button" class="button" id="recAmtsBtn" name="recAmtsBtn" value="Recovery Amounts" style="width: 120px;" /></td>
				<td><input type="button" class="button" id="cancelBtn" name="cancelBtn" value="Cancel" style="width: 90px;" /></td>
			</tr>
		</table>
	</div>
</div>

<script type="text/javascript">
try{ 
	//sa mag de-debug po nito 'GICLS010' gudluck :D Aja! /* niknok */
	//sa mga susunod pang mag de-debug po nito 'GICLS010' gudluck :D ! /* irwin*/
	//at sa susunod pang mag de-debug po nito 'GICLS010' may the force be with you! XD /* jeffdojello*/
	
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();

	initializeMenu();
	objCLM.basicInfo = JSON.parse('${basicInfoJSON}'.replace(/\\/g, '\\\\'));
	//start nok
	objCLM.basicInfo.plateSw 		= "N";		//will call showValidPlateNosLOV if value is Y
	objCLM.basicInfo.plateSw2		= "N";		//will call showClaimLOV if value is Y
	objCLM.basicInfo.packageSw 		= "N";	    //will display list of policies for Package
	
	//end nok
	populateGlobalsFromBasicInfo(objCLM.basicInfo);
	
	var ora2010Sw 				= '${ora2010Sw}';
	var allowExpiredPol 		= '${allowExpiredPol}';
	var currUser 				= '${currUser}';
	var currUserName			= '${currUserName}';
	var valPolIssueDateFlag 	= '${valPolIssueDateFlag}'; 
	var notOkStat 				= '${clmStatNotOk}';
	var clmFiledNotice 			= '${clmFiledNotice}';
	var updUserFlag 			= 'N';
	var overdueFlag 			= '${overdueFlag}';
	var StatusMsg 				= '${StatusMsg}';
	var riIssCd 				= '${riIssCd}';
	var lineCodeSU 				= '${lineCodeSU}';
	var bondCoverage 			= '${bondCoverage}';
	var motorCarLineCode		= '${motorCarLineCode}';
	var mandatoryClaimDocs		= '${mandatoryClaimDocs}'; 
	var checkClaimStatusMsg		= '${checkClaimStatusMsg}';
	var valLocOfLoss			= '${valLocOfLoss}';
	var lineCodeFI				= '${lineCodeFI}';
	var lineCodeCA				= '${lineCodeCA}';
	var caSublinePFL			= '${caSublinePFL}';
	var marineCargoLineCode 	= '${marineCargoLineCode}';
	var hasDocs 	= '${hasDocs}';
	var hasCompletedDates 	= '${hasCompletedDates}';
	var dcOverrideFlag = ""; // To prevent override notice again for duplicate claims if the override was already triggered. - irwin july 3, 2012
	var proShort = 'N';	//kenneth SR4855 100715
	
	changeTag = 0;
	objCLM.variables 						= new Object();
	objCLM.lovSelected 						= "";
	objCLM.variables.plate2 				= 'N';
	objCLM.variables.fromOnPopulate 		= 0;
	//start nok
	objCLM.variables.overFlag				= "N";		//is 'Y' if the user already override.
	objCLM.variables.override 				= "";
	objCLM.variables.timeFlag 				= true;
	objCLM.variables.param1 				= "";		//showPlateMotorSerialLOV parameter 1 for plate/motor/serial nos
	objCLM.variables.param2 				= "";		//showPlateMotorSerialLOV parameter 2 for plate/motor/serial nos
	objCLM.variables.fromPlateSw2 			= "N"; 		//if validation came from showPlateMotorSerialLOV function
	objCLM.variables.validClaim 			= true;		//is 'TRUE' if allowed to save claim
	objCLM.variables.tlFlag 				= false; 	//total loss flag - override
	objCLM.variables.expFlag 				= false;    //is true if loss time is not w/in the policy term.
	objCLM.variables.chkFlag 				= false;    //is true if user may continue filing claim for expired policy..
	objCLM.variables.clearItemPerilFunc 	= "N"; 		//call clear_item_peril procedure on saving
	objCLM.variables.sublineTime 			= "";		//subline time
	objCLM.variables.checkLoss				= false;    //is true if override for expired policy appears. CheckLossWithPlateNo will be done after override.
	objCLM.variables.oldTime				= "";
	objCLM.variables.oldDate				= "";
	objCLM.variables.checkLastEndtPlateNo	= false;
	objCLM.variables.albadFlag 				= "N";
	objCLM.variables.accptFlag 				= "N";		//is 'Y' if the user continue even if the loss occur before the accept date.
	objCLM.variables.comFlag 				= false;	//is true if override for expired and duplicate claim was called at key-commit.
	objCLM.variables.check 					= "N";
	objCLM.variables.bondFlag 				= false;	//is true if bond policy.	
	objCLM.variables.claimChecked			= false;
	objCLM.variables.dupFlag 				= false;
	objCLM.variables.skip 					= "N";
	objCLM.variables.createWorkflowRec 		= "N";		
	objCLM.variables.deleteWorkflowRec		= "N";		//is 'Y' if will call the delete_workflow_rec procedure in saving
	objCLM.variables.chkOverdue 			= "N";
	objCLM.variables.insClmItemAndItemPeril = "N";		//insert values in gicl_clm_item & gicl_item_peril from Ok for Processing click event
	objCLM.variables.insertClaimMortgagee 	= "N";		//is 'Y' if will call DELETE GICL_MORTGAGEE then INSERT_CLAIM_MORTGAGEE
	objCLM.variables.message 			 	= "N";  	//is 'Y' when user wants to continue
	objCLM.variables.locflag				= "N";
	objCLM.variables.updateFlag 			= false;	
	objCLM.variables.keyCommit 				= false;
	objCLM.variables.procs					= [];		//array of procedures to be called upon saving
	objCLM.variables.checkNoClaimSw			= "N";		//is 'Y' if check no claim procedure will skip upon saving
	//added by christian 09.07.2012
	objCLM.variables.checkObserveLineCd 	= 0;		
	objCLM.variables.checkObserveSublineCd 	= 0;
	objCLM.variables.checkObserveIssCd 		= 0;
	//added by adpascual 5.10.2013
	objCLM.variables.issDateOverFlag        = "N";	// is 'Y' if function ID for GICLS010 is already been override.
	objCLM.variables.expiredOverFlag		= "N";  // is 'Y' if function EP for GICLS010 is already been override.
	objCLM.variables.accDateOverFlag		= "N";  // is 'Y' if function AD for GICLS010 is already been override -- added by robert SR 18650 06.30.15
	//refresh parameters here 
	function refreshParameters(){
		//from basic info JSON
		objCLM.basicInfo.plateSw 				= "N";
		objCLM.basicInfo.plateSw2				= "N";
		//Variables
		objCLM.variables.overFlag				= "N";
		objCLM.variables.override 				= "";
		objCLM.variables.param1					= "";
		objCLM.variables.param2					= "";
		objCLM.variables.fromPlateSw2 			= "N"; 
		objCLM.variables.validClaim 			= true;
		objCLM.variables.expFlag 				= false;
		objCLM.variables.chkFlag 				= false;
		objCLM.variables.clearItemPerilFunc 	= "N";
		objCLM.variables.sublineTime			= "";
		objCLM.variables.checkLoss				= false;
		objCLM.variables.oldTime				= "";
		objCLM.variables.oldDate				= "";
		objCLM.variables.checkLastEndtPlateNo	= false;
		objCLM.variables.albadFlag 				= "N";
		objCLM.variables.accptFlag 				= "N";
		objCLM.variables.comFlag 				= false;	
		objCLM.variables.check 					= "N";
		objCLM.variables.bondFlag 				= false;
		objCLM.variables.claimChecked			= false;
		objCLM.variables.dupFlag 				= false;
		objCLM.variables.skip 					= "N";
		objCLM.variables.createWorkflowRec 		= "N";
		objCLM.variables.deleteWorkflowRec		= "N";
		objCLM.variables.chkOverdue 			= "N";
		objCLM.variables.insClmItemAndItemPeril = "N";
		objCLM.variables.insertClaimMortgagee 	= "N";
		objCLM.variables.message 			 	= "N";
		objCLM.variables.locflag				= "N";
		objCLM.variables.updateFlag 			= false;
		objCLM.variables.keyCommit 				= false;
		objCLM.variables.procs					= [];
		objCLM.variables.checkNoClaimSw			= "N";	
		objCLM.variables.checkObserveLineCd 	= 0;	
		objCLM.variables.checkObserveSublineCd 	= 0;
		objCLM.variables.checkObserveIssCd 		= 0;
		objCLM.variables.issDateOverFlag        = "N";		//adpascual 5.10.13
		objCLM.variables.expiredOverFlag		= "N";		//adpascual 5.10.13
		objCLM.variables.accDateOverFlag        = "N";      //added by robert SR 18650 06.30.15
		clearAllPreTextAttribute();
	}
	
	//emsy 4.20.2012 
	function checkLineCd() {
		$("customDiv").show();
		if ($F("lineCd") == "FI" || objCLMGlobal.lineCd == "FI") {
			if(ora2010Sw == "Y"){
				$("fireCustomRow").show();
				$("fireCustomRow2").show();
			}else{
				$("fireCustomRow").hide();
				$("fireCustomRow2").hide();
			}
		}else{
			$("fireCustomRow").hide();
			$("fireCustomRow2").hide();
		}
		if ($F("lineCd") == "CA" || objCLMGlobal.lineCd == "CA") {
			$("casualtyCustomRow").show();
		} else {
			$("casualtyCustomRow").hide();
		}
		if ($F("lineCd") != "MC" || objCLMGlobal.lineCd != "MC") {
			$("motorCustomDiv").hide();
		} else {
			$("motorCustomDiv").show();
		}
	}
	
	function exitCancelFunc(){
		if (objCLMGlobal.callingForm == "GICLS001"){
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
		/* }if (objCLMGlobal.callingForm == "GICLS052"){
			goToModule("/GICLClaimsController?action=showLossRecoveryListing", "Loss Recovery Listing", ""); */
		}else if(objGICLS051.previousModule == "GICLS051"){
			showGeneratePLAFLAPage(objGICLS051.currentView, objCLMGlobal.lineCd);
		}else{		
			objCLMGlobal.claimId = null;	// SR-19547 : shan 07.10.2015
			showClaimListing();
		}		
	}	
	
	function checkSaveGICLS010(){
		if (objCLM.variables.keyCommit == true){
			fireEvent($("saveBtn"), "click");
		}else{
			objCLM.variables.keyCommit = false;
		}	
	}	
	
	observeReloadForm("reloadForm", function(){
		objCLM.dcOverrideFlag = "N"; //marco - 07.23.2014
		showClaimBasicInformation();	
	});	
	
	$("cancelBtn").stopObserving("click");
	//$("cancelBtn").observe("click", exitCancelFunc); // andrew - 02.24.2012 - comment out, replaced with observeAccessibleModule to handle the changeTag
	observeAccessibleModule(accessType.MENU, "GICLS002", "cancelBtn", exitCancelFunc);
	
	$("clmExit").stopObserving("click");	
	//$("clmExit").observe("click", exitCancelFunc); // andrew - 02.24.2012 - comment out, replaced with observeAccessibleModule to handle the changeTag
	observeAccessibleModule(accessType.MENU, "GICLS002", "clmExit", exitCancelFunc);
 
	if (nvl(checkClaimStatusMsg,"")){ //check claims status
		showMessageBox(checkClaimStatusMsg, "E");
		fireEvent($("clmExit"), "click");
	} 
	
	//Plate Number CLICK LOV event
	$("oscmPlateNumber").observe("click", function () {
		if (nvl(objCLMGlobal.claimId,null) != null) return;
		$("txtPlateNumber").focus();
		if (nvl(objCLM.basicInfo.plateSw,"N") == "Y"){
			showValidPlateNosLOV($F("txtLineCd"), $F("txtSublineCd"), $F("txtPolIssCd"), $F("txtIssueYy"), $F("txtPolSeqNo"), $F("txtRenewNo"), "GICLS010");
		}else{
			/*setLovDtls("clmPlateNoLov", "Plate No.", "Assured", "Valid Plate Nos.");
			showClaimLOV();*/
			showPlateNoLOV("GICLS010");
		}
	});

	//Motor Number CLICK LOV event
	$("oscmMotorNumber").observe("click", function () {
		if (nvl(objCLMGlobal.claimId,null) != null) return;
		$("txtMotorNumber").focus();
		if (nvl(objCLM.basicInfo.plateSw,"N") == "Y"){
			showValidPlateNosLOV($F("txtLineCd"), $F("txtSublineCd"), $F("txtPolIssCd"), $F("txtIssueYy"), $F("txtPolSeqNo"), $F("txtRenewNo"), "GICLS010");
		}else{
			/*setLovDtls("clmMotorNoLov", "Motor No.", "Assured", "Valid Motor Nos.");
			showClaimLOV();*/
			showMotorNoLOV("GICLS010");
		}
	});

	//Serial Number CLICK LOV event
	$("oscmSerialNumber").observe("click", function () {
		if (nvl(objCLMGlobal.claimId,null) != null) return;
		$("txtSerialNumber").focus();
		if (nvl(objCLM.basicInfo.plateSw,"N") == "Y"){
			showValidPlateNosLOV($F("txtLineCd"), $F("txtSublineCd"), $F("txtPolIssCd"), $F("txtIssueYy"), $F("txtPolSeqNo"), $F("txtRenewNo"), "GICLS010");
		}else{
			/*setLovDtls("clmSerialNoLov", "Serial No.", "Assured", "Valid Serial Nos.");
			showClaimLOV();*/
			showSerialNoLOV("GICLS010");
		}
	});
	
	function showPopupGrid(path,title,width,height){
	    var contentDiv = new Element("div", {id : "modal_content_lov"});
	    var contentHTML = '<div id="modal_content_lov"></div>';
	    overlayPopupGrid = Overlay.show(contentHTML, {
							id: 'modal_dialog_lov',
							title: nvl(title,""),
							width: nvl(width,600),
							height: nvl(height,410),
							draggable: false,
							//closable: ((title=="Claim Adjuster") ? false :true)
							closable: false
						});
	    
	    new Ajax.Updater("modal_content_lov", contextPath+ path + objCLMGlobal.claimId, {
			evalScripts: true,
			asynchronous: false,
			onComplete: function (response) {			
				if (!checkErrorOnResponse(response)) {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	//Open Processor History view
	$("processorHistBtn").observe("click", function () {
		showPopupGrid("/GICLClaimsController?action=getProcessorHistory&claimId=", "Processor History");
	});

	//Open Claim Status History view
	$("clmStatHistBtn").observe("click", function () {
		showPopupGrid("/GICLClaimsController?action=getStatHist&claimId=", "Claim Status History");
	});

	//Open Intermediary view
	$("intermediaryBtn").observe("click", function () {
		showPopupGrid("/GICLClaimsController?action=getBasicIntmDtls&claimId=", "Intermediary");
	});

	function showRecoveryAmounts(){
		Effect.Appear("recoveryAmountsMainDiv", {
		duration: .001
		});		
	}
	
	//Open Recovery Amounts view
	$("recAmtsBtn").observe("click", function () {
		showOverlayContent2(contextPath+"/GICLClaimsController?action=showRecoveryAmounts&claimId="+objCLMGlobal.claimId, "Recovery Amounts",
				330, showRecoveryAmounts);
	});
	
	//Open Claim Adjuster view
	$("adjusterBtn").observe("click", function () {
		//showPopupGrid("/GICLClmAdjusterController?action=showAdjusterListing&claimId=", "Claim Adjuster", 790);
		//modified by christian 09.05.2012
		overlayGICLS010Adjuster = Overlay.show(contextPath+"/GICLClmAdjusterController", {
			urlContent: true,
			urlParameters: {action : "showAdjusterListing",
				claimId : objCLMGlobal.claimId},
		    title: "Claim Adjuster",
		    id: "claim_adjuster_view",
		    height: 410,
		    width: 790,
		    draggable: true
		});
	});
	
	//Open Premium Warranty Letter view
	$("premWarrLetterBtn").observe("click", function(){
		overlayPremWarr = Overlay.show(contextPath+"/GIISIntermediaryController", {
			urlContent: true,
			urlParameters: {action : "showPremWarrLetter",
							claimId : objCLMGlobal.claimId,
							assdName: $F("txtAssuredName"),
							reportId: "GICLS010"
							},
			title: "Premium Warranty Letter",	
			id: "prem_warr_letter_view",
			width: 625,
			height: 145,
		    draggable: false,
		    closable: true
		});		
	});
	
	//Open Bond Policy Data view
	$("bondPolBtn").observe("click", function(){
		overlayBondPol = Overlay.show(contextPath+"/GIPIBondBasicController", {
			urlContent: true,
			urlParameters: {action : 	"showBondPolicyData", 
							lineCd: 	$F("txtLineCd"),
							sublineCd: 	$F("txtSublineCd"),
							polIssCd: 	$F("txtPolIssCd"),
							issueYy: 	$F("txtIssueYy"),
							polSeqNo: 	$F("txtPolSeqNo"),
							renewNo: 	$F("txtRenewNo"),
							lossDate: 	setDfltSec(objCLM.basicInfo.strLossDate),
							expiryDate: $F("txtExpiryDate"),
							polEffDate: $F("txtInceptionDate")
							},
			title: "Bond Policy Data",	
			id: "bond_policy_data_view",
			width: 790,
			height: 345,
		    draggable: false,
		    closable: true
		});		
	});
	
	//Open Mortgagee Information view
	$("mortgageeBtn").observe("click", function () {
		showPopupGrid("/GICLMortgageeController?action=getMortgageeGrid2&itemNo=0&claimId=", "Mortgagee Information");
	});
	
	//Open Settling/Survey Agent view
	$("settlingBtn").observe("click", function () {
		showPopupGrid("/GICLClaimsController?action=showSettlingSurveyAgent&claimId=", "Settling/Survey Agent", 625, 145);
	});
	

	/**
	 * Populate Claim Basic Information 
	 * */
	function populateBasicInfoPage(param){
		try{
			var incDate 						= nvl(objCLM.basicInfo.strPolicyEffectivityDate,null) != null ? objCLM.basicInfo.strPolicyEffectivityDate.substr(0, objCLM.basicInfo.strPolicyEffectivityDate.indexOf(" ")) :null;
			var incTime 						= nvl(objCLM.basicInfo.strPolicyEffectivityDate,null) != null ? objCLM.basicInfo.strPolicyEffectivityDate.substr(objCLM.basicInfo.strPolicyEffectivityDate.indexOf(" ")+1, objCLM.basicInfo.strPolicyEffectivityDate.length) :null;
			var expDate 						= nvl(objCLM.basicInfo.strExpiryDate,null) != null ? objCLM.basicInfo.strExpiryDate.substr(0, objCLM.basicInfo.strExpiryDate.indexOf(" ")) :null;
			var expTime 						= nvl(objCLM.basicInfo.strExpiryDate,null) != null ? objCLM.basicInfo.strExpiryDate.substr(objCLM.basicInfo.strExpiryDate.indexOf(" ")+1, objCLM.basicInfo.strExpiryDate.length) :null;
			var lossDate 						= nvl(objCLM.basicInfo.strDspLossDate,null) != null ? objCLM.basicInfo.strDspLossDate.substr(0, objCLM.basicInfo.strDspLossDate.indexOf(" ")) :null;
			var lossTime 						= nvl(objCLM.basicInfo.strDspLossDate,null) != null ? objCLM.basicInfo.strLossDate.substr(objCLM.basicInfo.strDspLossDate.indexOf(" ")+1, objCLM.basicInfo.strDspLossDate.length) :null;
			$("txtClmLineCd").value 			= nvl(String(objCLM.basicInfo.claimId),null) != null ? objCLM.basicInfo.lineCode :null;
			$("txtLineCd").value 				= nvl(objCLM.basicInfo.lineCode,nvl(objCLMGlobal.lineCd,nvl($F("txtLineCd"),"")));
			$("txtClmSublineCd").value	 		= nvl(String(objCLM.basicInfo.claimId),null) != null ? unescapeHTML2(objCLM.basicInfo.sublineCd) :null; //added unescapeHTML2 function christian 10.03.2012
			$("txtSublineCd").value 			= unescapeHTML2(objCLM.basicInfo.sublineCd); //added unescapeHTML2 function christian 10.03.2012
			$("txtClmIssCd").value 				= objCLM.basicInfo.issueCode;
			$("txtPolIssCd").value 				= objCLM.basicInfo.policyIssueCode;
			$("txtClmYy").value 				= nvl(String(objCLM.basicInfo.claimYy),null) != null ? Number(objCLM.basicInfo.claimYy).toPaddedString(2) :null;
			$("txtIssueYy").value 				= nvl(String(objCLM.basicInfo.issueYy),null) != null ? Number(objCLM.basicInfo.issueYy).toPaddedString(2) :null;
			$("txtClmSeqNo").value 				= nvl(String(objCLM.basicInfo.claimSequenceNo),null) != null ? Number(objCLM.basicInfo.claimSequenceNo).toPaddedString(7) :null;
			$("txtPolSeqNo").value 				= nvl(String(objCLM.basicInfo.policySequenceNo),null) != null ? Number(objCLM.basicInfo.policySequenceNo).toPaddedString(7) :null;
			$("txtRenewNo").value 				= nvl(String(objCLM.basicInfo.renewNo),null) != null ? Number(objCLM.basicInfo.renewNo).toPaddedString(2) :null;
			$("txtAssuredName").value 			= unescapeHTML2((objCLM.basicInfo.assuredName == null ? "" : objCLM.basicInfo.assuredName) + (objCLM.basicInfo.assuredName2== null ? "" : objCLM.basicInfo.assuredName2));
			$("txtInceptionDate").value 		= incDate;
			$("txtInceptionTime").value 		= incTime;
			if (nvl($F("txtInceptionTime"),"") != "") isValidTime("txtInceptionTime", "AM", true, false);
			$("txtExpiryDate").value 			= expDate;
			$("txtExpiryTime").value 			= expTime;
			if (nvl($F("txtExpiryTime"),"") != "") isValidTime("txtExpiryTime", "AM", true, false);
			$("txtLossDate").value 				= lossDate;
			$("txtLossTime").value 				= lossTime;
			if (nvl($F("txtLossTime"),"") != "") isValidTime("txtLossTime", "AM", true, false);
			$("txtInHouseAdjustment").value 	= unescapeHTML2(objCLM.basicInfo.inHouseAdjustment);
			$("txtClmProcessor").value 			= unescapeHTML2(objCLM.basicInfo.dspInHouAdjName);
			$("txtDateFiled").value 			= objCLM.basicInfo.strClaimFileDate;
			$("txtClmEntryDate").value 			= nvl(objCLM.basicInfo.strEntryDate,null) != null ? dateFormat(objCLM.basicInfo.strEntryDate, "mm-dd-yyyy") :null;
			$("txtRiCd").value 					= nvl(objCLM.basicInfo.riCd,"");
			$("txtLeasedTo").value	 			= unescapeHTML2(objCLM.basicInfo.dspAcctOf); //emsy 3.22.2012
			$("txtCedant").value 				= unescapeHTML2(objCLM.basicInfo.dspRiName);
			$("txtCatCd").value 				= objCLM.basicInfo.catastrophicCode;
			$("txtCat").value 					= unescapeHTML2(objCLM.basicInfo.dspCatDesc);
			$("txtCreditBranch").value 			= unescapeHTML2(objCLM.basicInfo.creditBranch);
			$("txtDspCredBrDesc").value 		= unescapeHTML2(objCLM.basicInfo.dspCredBrDesc);
			$("txtRemarks").value 				= unescapeHTML2(objCLM.basicInfo.remarks);
			$("txtLossCatCd").value				= unescapeHTML2(objCLM.basicInfo.lossCatCd);
			$("txtLossDesc").value 				= unescapeHTML2(objCLM.basicInfo.dspLossCatDesc);
			$("txtLossDtls").value 				= unescapeHTML2(objCLM.basicInfo.lossDetails);
			$("txtLocOfLoss1").value 			= unescapeHTML2(objCLM.basicInfo.lossLocation1);
			$("txtLocOfLoss2").value 			= unescapeHTML2(objCLM.basicInfo.lossLocation2);
			$("txtLocOfLoss3").value 			= unescapeHTML2(objCLM.basicInfo.lossLocation3);
			$("txtCity").value 					= unescapeHTML2(objCLM.basicInfo.dspCityDesc);
			$("txtProvince").value 				= unescapeHTML2(objCLM.basicInfo.dspProvinceDesc);
			$("txtZipCode").value 				= unescapeHTML2(objCLM.basicInfo.zipCode);
			$("txtClmStat").value 				= unescapeHTML2(objCLM.basicInfo.clmStatDesc);
			$("txtLossReserve").value 			= nvl(objCLM.basicInfo.lossResAmount,null) != null ? formatCurrency(objCLM.basicInfo.lossResAmount) :null;
			$("txtLossPaid").value 				= nvl(objCLM.basicInfo.lossPaidAmount,null) != null ? formatCurrency(objCLM.basicInfo.lossPaidAmount) :null;
			$("txtExpenseReserve").value 		= nvl(objCLM.basicInfo.expenseResAmount,null) != null ? formatCurrency(objCLM.basicInfo.expenseResAmount) :null;
			$("txtExpensePaid").value 			= nvl(objCLM.basicInfo.expPaidAmount,null) != null ? formatCurrency(objCLM.basicInfo.expPaidAmount) :null;
			$("txtEntryDate").value 			= objCLM.basicInfo.strEntryDate;
			$("txtDateSettled").value 			= objCLM.basicInfo.strClaimSettlementDate;
			$("chkLossRecovery").checked 		= objCLM.basicInfo.recoverySw == "Y" ? true : false;
			$("txtDistrictNo").value 			= nvl(objCLM.basicInfo.districtNumber,null) == null ? "" : objCLM.basicInfo.districtNumber;
			$("txtBlockNo").value 				= objCLM.basicInfo.blockNo;
			$("txtlocationDesc").value 			= unescapeHTML2(objCLM.basicInfo.locationDesc);
			$("txtlocationCd").value   			= objCLM.basicInfo.locationCode;
			$("clmControl").value 				= unescapeHTML2(nvl(objCLM.basicInfo.claimControl,"N"));
			$("refreshSw").value 				= objCLM.basicInfo.refreshSw;
			$("txtClmStatCd").value 			= unescapeHTML2(objCLM.basicInfo.claimStatusCd);
			$("txtOpNumber").value 				= unescapeHTML2(objCLM.basicInfo.opNumber);
			$("txtPackPolNo").value 		 	= unescapeHTML2(objCLM.basicInfo.packPolNo);
			$("txtPlateNumber").value 		 	= unescapeHTML2(objCLM.basicInfo.plateNumber);
			$("txtMotorNumber").value 		 	= unescapeHTML2(objCLM.basicInfo.motorNumber);
			$("txtSerialNumber").value 		 	= unescapeHTML2(objCLM.basicInfo.serialNumber);
			$("txtLocation").value				= unescapeHTML2(objCLM.basicInfo.dspLocationDesc); //emsy 4.23.2012
			$("txtReportedBy").value			= unescapeHTML2(objCLM.basicInfo.reportedBy);

			if (nvl(param,true)){
				postQuery();
			}else{
				refreshParameters();
			} 
			
		}catch(e){
			showErrorMessage("populateBasicInfoPage", e);
		}
	}
	
	/**
	 * Post Query in Claim Basic Information 
	 * */
	function postQuery(){
		if (nvl(objCLM.basicInfo.packPolFlag,"N") == "Y"){
			$("chkPackPol").checked = true;
		}else{
			$("chkPackPol").checked = false;
		}
		
		if (objCLM.basicInfo.totalTag == "Y"){
			$("chkTotalLoss").checked = true;
		}

		if (objCLM.basicInfo.giclMortgageeExist == 'Y'){
			enableButton("mortgageeBtn");
		}else{
			disableButton("mortgageeBtn");
		}
		
		enableDisablePlate();
		
		if ($F("valPolIssueDateFlag") == 'Y') {
			objCLM.variables.issueDate = objCLM.basicInfo.strIssueDate;
		}else if ($F("valPolIssueDateFlag") == ""){
			showMessageBox("VALIDATE_POL_ISSUE_DATE does not exist in GIIS_PARAMETERS", imgMessage.INFO);
		}

		if (objCLMGlobal.claimId != null){
			var lineCd = objCLMGlobal.lineCd;
			var lineName = objCLMGlobal.lineName;
			var menuLineCd = objCLMGlobal.menuLineCd;
			insertClmStatValues();
			objCLMGlobal = new Object();
			objCLMGlobal = objCLM.basicInfo;
			objCLMGlobal.callingForm = "GICLS002";
			objCLMGlobal.lineCd = lineCd;
			objCLMGlobal.lineName = lineName;
			objCLMGlobal.menuLineCd = menuLineCd;

		}	
		
		if ($F("txtPolIssCd").toUpperCase() == "RI"){
			//$("txtRiCd").readOnly = false;
		}else{
			$("txtRiCd").readOnly = true;
		}
		
		whenNewRecordInstance();
	}

	function insertClmStatValues(){
		if(notOkStat != objCLM.basicInfo.claimStatusCd){
			$("chkOkProcessing").checked = true;
		}else{
			$("chkOkProcessing").checked = false;
		}
	}	
	
	function whenNewRecordInstance(){
		if (ora2010Sw == 'Y'){
			if ($F("txtLineCd") == objLineCds.FI){
				if ($F("txtDistrictNo") != "" || $F("txtBlockNo") != "" ||
					$F("txtProvince") != "" || $F("txtCity") != ""){
					objCLM.variables.origDstrct = escapeHTML2($F("txtDistrictNo"));
					objCLM.variables.origBlockNo = escapeHTML2($F("txtBlockNo"));
					objCLM.variables.origBlockId = objCLM.basicInfo.blockId;
					objCLM.variables.origCityDesc = escapeHTML2($F("txtCity"));
					objCLM.variables.origCityCd = objCLM.basicInfo.cityCode;
					objCLM.variables.origProvinceDesc = escapeHTML2($F("txtProvince"));
					objCLM.variables.origProvinceCd = escapeHTML2(objCLM.basicInfo.provinceCode);
				}
			}else if ($F("txtLineCd") == objLineCds.CA){
				if ($F("txtlocationCd") != "" || $F("txtProvince") != "" || 
					$F("txtCity") != ""){
					objCLM.variables.origLocationDesc = escapeHTML2($F("txtlocationDesc"));
					objCLM.variables.origLocationCd = objCLM.basicInfo.locationCode;
					objCLM.variables.origCityDesc = escapeHTML2($F("txtCity"));
					objCLM.variables.origCityCd = objCLM.basicInfo.cityCode;
					objCLM.variables.origProvinceDesc = escapeHTML2($F("txtProvince"));
					objCLM.variables.origProvinceCd = escapeHTML2(objCLM.basicInfo.provinceCode);
				}
			}
		}
		objCLMGlobal.inHouseAdjustment = currUser;
		
	    if ($F("txtLossDate") != ""){
	    	objCLM.variables.oldDate = $F("txtLossDate");
	    	objCLM.variables.oldTime = $F("txtLossTime");
	    	var oldDate = Date.parse(objCLM.variables.oldDate, 'mm-dd-yyyy');
	    	var expiryDate = Date.parse($F("txtExpiryDate").substr(0, $F("txtExpiryDate").indexOf(" ")));
			var inceptDate = Date.parse($F("txtInceptionDate").substr(0, $F("txtInceptionDate").indexOf(" ")));
	    	if ((oldDate > expiryDate ||
				oldDate < inceptDate) && allowExpiredPol == 'O'){
	    		objCLM.variables.chkFlag = true;
	    	}
	    }

	    if (objCLMGlobal.claimId != null &&
	    	objCLMGlobal.inHouseAdjustment == currUser){
			enableMenu("clmBasicInformation");
			enableMenu("clmRequiredDocs");
			if ($("chkOkProcessing").checked == true ) {
				getClaimsMenuProperties();
			}else{
				disableMenu("clmItemInformation");
				$("oscmClmProcessor").disabled = true;
				$("oscmClmStat").disabled = true;
				$("oscmClmStat").hide();
			}
	    }

	    if($F("txtClmIssCd") != "RI" && objCLMGlobal.callingForm == "GICLS002"){ //from txtSublineCd changed to txtClmIssCd - christian 09.04.2012
			enableButton("intermediaryBtn");
			enableButton("adjusterBtn");
		}else{
			disableButton("intermediaryBtn");
			disableButton("adjusterBtn");
			if (objCLMGlobal.callingForm == "GICLS002"){
				enableButton("processorHistBtn");
				enableButton("clmStatHistBtn");
				enableButton("adjusterBtn");
			}else{
				disableButton("processorHistBtn");
				disableButton("clmStatHistBtn");
				disableButton("adjusterBtn");
			}
		}

		if (objCLMGlobal.callingForm == "GICLS001"){
			//$("oscmClmAssured").show();
		}else {
			if ($F("txtLineCd") != "" && $F("clmControl") == "Y"){
				getUnpaidPremiums();
				$("chkLossRecovery").disabled = false;
			}
			//$("oscmClmAssured").hide();
		}

		if ($F("txtLineCd") == "SU"){
			$("assdPrincipalLbl").innerHTML = "Principal";
			if ($F("refreshSw") == "N" || $F("refreshSw") == ""){
				if (nvl(objCLMGlobal.claimId,null) != null) enableButton("bondPolBtn");
				disableButton("refreshBtn");
			}else {
				enableButton("bondPolBtn");
				enableButton("refreshBtn");
			}
		}else {
			$("assdPrincipalLbl").innerHTML = "Assured Name";
			if ($F("refreshSw") == "N" || $F("refreshSw") == ""){
				disableButton("bondPolBtn");
				disableButton("refreshBtn");
			}else {
				disableButton("bondPolBtn");
				enableButton("refreshBtn");
			}
		}

		if ($F("txtLineCd") != nvl(objLineCds.MN,marineCargoLineCode)){
			$("txtOpNumber").hide();
			$("opNoLbl").hide();
			disableButton("settlingBtn");
		}else{
			if (objCLMGlobal.claimId != null){
				enableButton("settlingBtn");
			}else{
				disableButton("settlingBtn");	
			}	
		}
	
		if ($F("txtDateFiled") == "" && $("chkOkProcessing").checked == false){
			$("chkOkProcessing").disabled = true;
		}else if($F("txtDateFiled") != "" && $("chkOkProcessing").checked == true){
			$("chkOkProcessing").disabled = false;
			$("chkOkProcessing").setAttribute("updatable", "N");
		}else if($F("txtDateFiled") != "" && $("chkOkProcessing").checked == false){
			$("chkOkProcessing").disabled = false;
			$("chkOkProcessing").setAttribute("updatable", "Y");
		}

		/* if ($F("txtClmStatCd") == "NO"){
			$("txtUnpaid").value = "W/ UNPAID PREMIUM";
		} commented out by christian 09.06.2012*/

		//check if w/ unpaid premium added by christian 09.06.2012
		function getBalanceAmtDue(){
			new Ajax.Request(contextPath + "/GICLClaimsController?action=getUnpaidPremiumDtls", {
				method: "GET",
				parameters: {
					lineCd: objCLM.basicInfo.lineCode,
					sublineCd: objCLM.basicInfo.sublineCd,
					polIssCd: objCLM.basicInfo.policyIssueCode,
					issueYy: objCLM.basicInfo.issueYy,
					polSeqNo: objCLM.basicInfo.policySequenceNo,
					renewNo: objCLM.basicInfo.renewNo,
					issCd: 	objCLM.basicInfo.issueCode,
					clmFileDate: objCLM.basicInfo.strClaimFileDate
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function (response){
					var result = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
					var balanceAmtDue = result.balanceAmtDue;
					objCLM.variables.balanceAmtDue = parseFloat(balanceAmtDue);	// added by shan 03.26.2014
					if (balanceAmtDue > 0){
						/** as per instruction of mam jen, the text "W/ UNPAID PREMIUM" will only be shown if the claims is tagged as "Ok for Processing"					
							- irwin 9.18.2012
						**/
						if($("chkOkProcessing").checked == true){ 
							$("txtUnpaid").value = "W/ UNPAID PREMIUM";						
						}
						
					} 
				}
			});
		}
		
		if (objCLMGlobal.claimId != null){
	   		getBalanceAmtDue();
		}
		
		if (nvl(objCLM.basicInfo.packPolFlag,"N") == "Y" || nvl(objCLM.basicInfo.packPolicyId,null) != null){
			$("txtPackPolNo").show();
			$("packPolNoLbl").show();
		}else {
			$("txtPackPolNo").hide();
			$("packPolNoLbl").hide();
		}
		
		if ($F("txtUnpaid") == "W/ UNPAID PREMIUM"){
			enableButton("premWarrLetterBtn");
		}else{
			disableButton("premWarrLetterBtn");
		}
		
		if ($F("txtClmSeqNo") != ""){
			enableButton("recAmtsBtn");
		}else{
			disableButton("recAmtsBtn");
		}

		if (objCLMGlobal.claimId == null){
			if (objCLM.basicInfo.redistSw == 'Y'){
				showMessageBox("Claim is tagged for redistribution, please redistribute claim reserve.", imgMessage.INFO);
				objCLMGlobal.redistSw = 'Y';
			}else{
				objCLMGlobal.redistSw = '';
			}
	
			if (objCLMGlobal.redistSw == ""){
				enableMenus('Y');
			}else{
				enableMenus('N');
			}
		}
	}
	
	function getUnpaidPremiums(param){
		new Ajax.Request(contextPath + "/GICLClaimsController?action=getUnpaidPremiumDtls", {
			method: "GET",
			parameters: {
				lineCd: objCLM.basicInfo.lineCode,
				sublineCd: objCLM.basicInfo.sublineCd,
				polIssCd: objCLM.basicInfo.policyIssueCode,
				issueYy: objCLM.basicInfo.issueYy,
				polSeqNo: objCLM.basicInfo.policySequenceNo,
				renewNo: objCLM.basicInfo.renewNo,
				//issCd: 	objCLM.basicInfo.issueCode,   //nante 11/20/2013
				issCd: 	objCLM.basicInfo.policyIssueCode,
				clmFileDate: objCLM.basicInfo.strClaimFileDate
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function (response){
				if(checkErrorOnResponse(response)) {
					var result = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
					if (nvl(result.message,null) != null){
						showMessageBox(result.message, "I");
					}
					checkUnpaidPremiums(result, param);
				}
			}
		});
	}
	
	function checkUnpaidPremiums(params, param2){
		/* var unpaidPremium = 'N';
		var vFlag = "FALSE"; removed, not used*/
		var validateUnpaidPremFlag = nvl(params.validateUnpaid,"N");

		objCLM.variables.unpaidFlag = 'Y';
		objCLM.variables.checkup = 0;
		if (parseFloat(params.balanceAmtDue) > 0){ //may overdue
			if (objCLM.variables.fromOnPopulate == 2){
				showConfirmBox("Confirmation", "This policy has an overdue premium of " + params.currType + " " + formatCurrency(params.balanceAmtDue) + ". Would you like to continue?", "Yes", "No", 
								function (){ //if gusto mag continue
									if (overdueFlag == 'Y' || validateUnpaidPremFlag == 'N'){ //if allowed c user
										$("txtUnpaid").value = "W/ UNPAID PREMIUM";
										//unpaidPremium = 'Y';
										if (nvl($F("clmControl"),"N") == 'N'){
											$("clmControl").value = 'Y';
											objCLM.basicInfo.claimCoop = 'Y';
											objCLM.variables.checkup = 1;
										}

								        $("chkOkProcessing").checked = true;  
								        objCLM.variables.deleteWorkflowRec = "Y";
										var proc = new Object(); 
										proc.name = "deleteWorkflowRec";
										objCLM.variables.procs.push(proc);
								        objCLM.variables.skip = 'Y';
								        $("txtClmStatCd").value = 'FN';
								        getClaimDesc();
								        var proc = new Object(); 
										proc.name = "createWorkflowRec";
										objCLM.variables.procs.push(proc);
								        if (param2 == "chkOkProcessing"){ 	//getUnpaidPremiums called from chkOkProcessing checkbox change event
											conOkProcessing(); 				//walang parameter para hindi nya tawagin ulet si getUnpaidPremiums
										}
									}else{ //if hindi allowed c user
										vFlag = "FALSE";
										showConfirmBox("Confirmation","User is not allowed to process overdue premium. Would you like to override?","Yes","No",
												function(){
													objCLM.variables.chkOverdue = "2";
													objCLM.variables.override = "O";
													//call override form
													objCLM.variables.checkLoss = false;
													objAC.funcName = "OVERDUE_PREMIUM_OVERRIDE";
													objACGlobal.calledForm = "GICLS010";
													commonOverrideOkFunc = function(){
														if (objCLM.variables.chkOverdue == "1"){
															$("chkOkProcessing").checked = true;  //is :c003.nbt_clm_stat_cd := 'N';
														}else{
															if ($("chkOkProcessing").checked == true || ($("chkOkProcessing").checked)){
																$("txtUnpaid").value = "W/ UNPAID PREMIUM";
															}
															objCLM.variables.createWorkflowRec = "Y";
															objCLM.variables.deleteWorkflowRec = "Y";
															var proc = new Object(); 
															proc.name = "createWorkflowRec";
															objCLM.variables.procs.push(proc);
															var proc = new Object(); 
															proc.name = "deleteWorkflowRec";
															objCLM.variables.procs.push(proc);
															$("chkOkProcessing").checked = true;
															objCLM.variables.skip = 'Y';
															$("txtClmStatCd").value = 'FN';
															//eto para mag create ulet ng workflow sa check_unpaid_premiums after mag override
															var proc = new Object(); 
															proc.name = "createWorkflowRec";
															objCLM.variables.procs.push(proc);
														}
														if (nvl(objCLM.basicInfo.claimControl,"N") == 'N'){
															objCLM.basicInfo.claimControl = 'Y';
															$("clmControl").value = 'Y';
															objCLM.basicInfo.claimCoop = 'Y';
															objCLM.variables.checkup = 1;
														}
														
														objCLM.variables.mortgFlag = 'TRUE';
														objCLM.variables.validClaim = true;
														getClaimDesc(); 
														if (param2 == "chkOkProcessing"){ 	//getUnpaidPremiums called from chkOkProcessing checkbox change event
															conOkProcessing(); 				//walang parameter para hindi nya tawagin ulet si getUnpaidPremiums
														}
													};
													commonOverrideNotOkFunc = function(){
														showWaitingMessageBox($("overideUserName").value + " is not allowed to process overdue premium.", "E",
																clearOverride);
														if (param2 == "chkOkProcessing"){ 	//getUnpaidPremiums called from chkOkProcessing checkbox change event
															conOkProcessing(); 				//walang parameter para hindi nya tawagin ulet si getUnpaidPremiums
														}
														objCLM.variables.validClaim = false;
														ok = false;
														return false;
													};
													commonOverrideCancelFunc = function(){
														if (param2 == "chkOkProcessing"){ 	//getUnpaidPremiums called from chkOkProcessing checkbox change event
															conOkProcessing(); 				//walang parameter para hindi nya tawagin ulet si getUnpaidPremiums
														}
														$("chkOkProcessing").checked = false;        //nante  11/20/2013 uncheck the ok for processing after cancelling override
														$("txtUnpaid").value = "W/ UNPAID PREMIUM";  //nante  11/20/2013 
														$("txtClmStatCd").value = notOkStat;         //nante  11/20/2013
														objCLM.basicInfo.claimStatusCd = notOkStat;  //nante  11/20/2013
														//objCLM.variables.validClaim = false; 		 //nante  to be able to save if override is cancelled  11/20/2013
														ok = false;
														return false;
														
													};
													getUserInfo2();
													$("overlayTitle").innerHTML = "Override User";
												},
												function(){
													$("chkOkProcessing").checked = false;
													objCLM.variables.skip = 'Y';
													$("txtClmStatCd").value = "NO";
													objCLM.basicInfo.claimStatusCd = "NO";
													getClaimDesc();
													if (param2 == "chkOkProcessing"){ 	//getUnpaidPremiums called from chkOkProcessing checkbox change event
														conOkProcessing(); 				//walang parameter para hindi nya tawagin ulet si getUnpaidPremiums
													}
												});
									}
								}, 
								function (){ //if ayaw mag continue
									$("chkOkProcessing").checked = false;
									objCLM.variables.skip = 'Y';
									$("txtClmStatCd").value = "NO";
									objCLM.basicInfo.claimStatusCd = "NO";
									objCLM.basicInfo.claimCoop = 'Y';
									//$("txtUnpaid").value = "W/ UNPAID PREMIUM";
									vFlag = "TRUE";
									getClaimDesc();
									if (param2 == "chkOkProcessing"){ 	//getUnpaidPremiums called from chkOkProcessing checkbox change event
										conOkProcessing(); 				//walang parameter para hindi nya tawagin ulet si getUnpaidPremiums
									}
								});
			}else{ //objCLM.variables.fromOnPopulate != 2
				if (nvl($F("txtClmStatCd"),objCLM.basicInfo.claimStatusCd) != "NO"){
					$("txtUnpaid").value = "W/ UNPAID PREMIUM";
					unpaidPremium = 'Y';
					objCLM.variables.createWorkflowRec = "Y";
					var proc = new Object(); 
					proc.name = "createWorkflowRec";
					objCLM.variables.procs.push(proc);	
				}else{     
					$("txtUnpaid").value = "";
				}

				if (nvl(objCLM.basicInfo.claimControl,"N") == 'N'){
					objCLM.basicInfo.claimControl = 'Y';
					$("clmControl").value = 'Y';
					objCLM.basicInfo.claimCoop = 'Y';
					objCLM.variables.checkup = 1;
				}
				if (param2 == "chkOkProcessing"){ 	//getUnpaidPremiums called from chkOkProcessing checkbox change event
					conOkProcessing(); 				//walang parameter para hindi nya tawagin ulet si getUnpaidPremiums
				}
			}
		}else{   //walang overdue
			$("txtUnpaid").value = "";
			if ($("chkOkProcessing").checked == true){
				objCLM.variables.skip = 'Y';
				$("txtClmStatCd").value = clmFiledNotice;
				objCLM.basicInfo.claimStatusCd = clmFiledNotice;
			}else{
				$("txtClmStatCd").value = notOkStat;
				objCLM.basicInfo.claimStatusCd = notOkStat;
			}

			if (nvl(objCLM.basicInfo.claimControl,"N") == 'Y'){
				objCLM.basicInfo.claimControl = 'N';
				$("clmControl").value = 'N';
				objCLM.basicInfo.claimCoop = 'N';
				objCLM.variables.checkup = 1;
			}

			objCLM.variables.mortgFlag = 'TRUE';
			getClaimDesc();
			if (param2 == "chkOkProcessing"){ 	//getUnpaidPremiums called from chkOkProcessing checkbox change event
				conOkProcessing(); 				//walang parameter para hindi nya tawagin ulet si getUnpaidPremiums
			}
		}
		
		//getClaimDesc();
		objCLM.variables.balanceAmtDue = parseFloat(params.balanceAmtDue);
		objCLM.variables.currType = params.currType;
	}

	function updateClaimsBasicInfo(unpaidPrem, updUserFlag){
		new Ajax.Request(contextPath + "/GICLClaimsController?action=updateClaimsBasicInfo", {
			method: "GET",
			parameters: {
				claimId: objCLMGlobal.claimId,
				clmStatCd: nvl($F("txtClmStatCd"),objCLM.basicInfo.claimStatusCd),
				clmControl: nvl($F("clmControl"),"N"),
				clmCoop: objCLM.basicInfo.claimCoop,
				unpaidPremium: unpaidPrem,
				updUserFlag: updUserFlag
			},
			asynchronous: false,
			onComplete: function (response){
				var result = response.responseText;
				
			}
		});
	}
	
	function getClaimDesc(){
		new Ajax.Request(contextPath + "/GICLClaimsController?action=getClmDesc", {
			method: "GET",
			parameters: {
				clmStatCd: nvl($F("txtClmStatCd"),objCLM.basicInfo.claimStatusCd)
			},
			asynchronous: false,
			onComplete: function (response) {
				var result = response.responseText;
				$("txtClmStat").value = result;
			}
		});
	}
	
	populateBasicInfoPage();
	
	//irwin-- moved sa baba, dahil may isa pang observe na blur si isscd
	/* $("txtPolIssCd").observe("blur", function(){
		if ($F("txtPolIssCd") == riIssCd){
			if ($F("txtClmIssCd") != riIssCd && $F("txtClmIssCd") != ""){
				showMessageBox("For an RI policy, claim issuing source code must also be RI.", "I");
				$("txtClmIssCd").value = $F("txtPolIssCd");
			}
		}else{
			if ($F("txtClmIssCd") == riIssCd && $F("txtClmIssCd") != ""){
				showMessageBox("Claim issuing source code for a non-RI policy must not be RI.", "I");
				$("txtClmIssCd").value = $F("txtPolIssCd");
			}
		}
		if ($F("txtPolIssCd").toUpperCase() == "RI"){
			//$("txtRiCd").readOnly = false;
		}else{
			$("txtRiCd").readOnly = true;
		}
	}); */
	
	var lineCdMsg		= "Please select Line Code first.";
	var sublineCdMsg 	= "Please select Subline Code first.";
	var polIssCdMsg 	= "Please select Issuing Source Code first.";
	var issueYyMsg 		= "Please select Issuing Year first.";
	var polSeqNoMsg 	= "Please select Policy Sequence No. first.";
	
	function whenClickPolNo(onOk){
		try{
			showConfirmBox("Refresh Form","This action will retrieve a new policy number and will clear out all unsaved information without saving. Do you wish to continue?",
					"Ok","Cancel", function(){
				$("chkOkProcessing").disabled = true;
				onOk();
			}, "");
			
		}catch(e){
			showErrorMessage("whenClickPolNo", e);
		}
	}
	
	//kenneth SR4855 100715
	function createRequestGICLS010() {
		new Ajax.Request(contextPath + "/GICLClaimReserveController", {
			method : "POST",
			parameters : {
				action : "createOverrideBasicInfo",
				lineCd : $F("txtLineCd"),
				issCd : $F("txtPolIssCd"),
				ovrRemarks : $F("txtOverrideRequestRemarks")
			},
			onComplete : function(response) {
				if (checkErrorOnResponse(response)) {
					if (response.responseText == "SUCCESS") {
						showWaitingMessageBox("Override Request was successfully created.", "S", function(){
							clearObjectValues(objCLM.basicInfo);
							$("txtLineCd").value = "";
							populateBasicInfoPage(false);
							overlayOverrideRequest.close();
							delete overlayOverrideRequest;
						});
					}
				}
			}
		});
	}
	
	//kenneth SR4855 100715
	function requestOverrideUser(res){
		if (!validateUserFunc2("CP", "GICLS010")){
			showConfirmBox4("Confirmation", "This policy is cancelled pro-rate/short-rate. What would you like to do?", "Override", "Request Override", "Cancel",
				function(){
					objAC.funcCode = "CP";
					objACGlobal.calledForm = "GICLS010";
					commonOverrideOkFunc = function(){
						conCreateClm(res);
					};
					commonOverrideNotOkFunc = function(){
						showWaitingMessageBox($("overideUserName").value + " is not allowed to Override.", "E", 
								clearOverride);
						clearObjectValues(objCLM.basicInfo);
						$("txtLineCd").value = "";
						populateBasicInfoPage(false);
					};
					commonOverrideCancelFunc = function(){
						clearObjectValues(objCLM.basicInfo);
						$("txtLineCd").value = "";
						populateBasicInfoPage(false);
					};
					getUserInfo();
					$("overlayTitle").innerHTML = "Override User";
				},
				function(){
					showGenericOverrideRequest(
							"GICLS010",
							"CP",
							createRequestGICLS010,
							function(){
								clearObjectValues(objCLM.basicInfo);
								$("txtLineCd").value = "";
								populateBasicInfoPage(false);
								overlayOverrideRequest.close();
							});
				},
				function(){
					clearObjectValues(objCLM.basicInfo);
					$("txtLineCd").value = "";
					populateBasicInfoPage(false);
				}
			);
		}else{
			conCreateClm(res);
		}
	}
	
	function validateClmPolicyNo(){
		try{
			if ($F("txtLineCd") != "" && $F("txtSublineCd") != "" && 
				$F("txtPolIssCd") != "" && $F("txtIssueYy") != "" && 
				$F("txtPolSeqNo") != "" && $F("txtRenewNo") != ""){
				new Ajax.Request(contextPath+"/GICLClaimsController",{
					parameters:{
						action: 	"validateClmPolicyNo",
						lineCd: 	$F("txtLineCd"),
						sublineCd: 	$F("txtSublineCd"),
						polIssCd: 	$F("txtPolIssCd"),
						issueYy: 	$F("txtIssueYy"),
						polSeqNo: 	$F("txtPolSeqNo"),
						renewNo: 	$F("txtRenewNo"),
						lossDate: 	setDfltSec(objCLM.basicInfo.strLossDate)
					},
					asynchronous: false,
					evalScripts: true,
					onCreate: showNotice("Validating Policy No., please wait..."),
					onComplete: function(response){
						if(checkErrorOnResponse(response)) {
							proShort = 'N';
							objCLM.variables.validClaim = true;
							objCLM.dcOverrideFlag = "N"; //marco - 07.23.2014
							var res = JSON.parse(response.responseText); //removed .replace(/\\/g, '\\\\') by robert 10.22.2013
							if (nvl(res.msgAlert,null) != null){
								//kenneth SR4855 100715
								if(res.msgAlert.contains("pro-rate/short-rate")){
									proShort = 'Y';
									requestOverrideUser(res);
								}else{
									clearObjectValues(objCLM.basicInfo);
									showMessageBox(res.msgAlert, "E");
									$("txtLineCd").value = "";
									populateBasicInfoPage(false);
									return false;	
								}
							}
							if (nvl(res.msgAlert2,null) != null){
								showWaitingMessageBox(res.msgAlert2, "I", function(){
									if (nvl(res.msgAlert3,null) != null){
										showWaitingMessageBox(res.msgAlert3, "I", function(){conCreateClm(res);});
									}else{
										conCreateClm(res);
									}
								});
							}else{
								if (nvl(res.msgAlert3,null) != null){
									showWaitingMessageBox(res.msgAlert3, "I", function(){conCreateClm(res);});
								}else{
									conCreateClm(res);
								}
							}
							hideNotice();
						}else{
							objCLM.variables.validClaim = false;
						}
					}
				});
			}
		}catch(e){
			showErrorMessage("validateClmPolicyNo", e);	
		}
	}	
	
	/* Observe function for Line code/name
	** @params lov - true if lov will show else not 
	*/
	objCLM.variables.prevLineCd = '${lineCd}';
	function observeLineCd(lov){
		try{
			if (nvl(objCLMGlobal.claimId,null) != null) return;
			if (nvl($F("txtLineCd"),null) != null){
				function onOk(){
					clearObjectValues(objCLM.basicInfo);
					var lineCd = $F("txtLineCd");
					if (nvl(lov,false)) showLineCdLOV($F("txtPolIssCd"), "GICLS010");
					populateBasicInfoPage(false);
					$("txtLineCd").value = lineCd;
					objCLM.variables.prevLineCd = "";
					objCLM.variables.prevSublineCd = "";
					objCLM.variables.prevPolIssCd = "";
					objCLM.variables.prevIssueYy = "";
					objCLM.variables.prevPolSeqNo = "";
					objCLM.variables.prevRenewNo = "";
					if (!nvl(lov,false)) $("txtLineCd").focus();
				}
				whenClickPolNo(onOk);
				$("txtLineCd").value = nvl(getPreTextValue("txtLineCd"),$F("txtLineCd"));
				$("txtLineCd").blur();
			}else{
				if (nvl(lov,false)) showLineCdLOV($F("txtPolIssCd"), "GICLS010");
			}
		}catch(e){
			showErrorMessage("observeLineCd", e);
		}
	}	

	//Line code/name FOCUS
	initPreTextOnField("txtLineCd");
	
	$("txtLineCd").observe("focus", function(){
		if (nvl(objCLMGlobal.claimId,null) != null) return;
		if (objCLM.variables.checkObserveLineCd == 0 && objCLM.variables.prevLineCd != ""){
			observeLineCd(false);
		}
		objCLM.variables.checkObserveLineCd = 0;
		//$("txtLineCd").select();
	});
	
	$("txtLineCd").observe("change", function(){
		validateLineCd($F("txtPolIssCd"), "GICLS010", $F("txtLineCd").toUpperCase());
	});
	//Line code/name BLUR
//	$("txtLineCd").observe("blur", function(){
		// move codes to polLineCdOnBlur on change
	//});
	
	//irwin
	function polLineCdOnBlur(){
		try{
			//moved blur to change - irwin
			if (nvl(objCLMGlobal.claimId,null) != null) return;
			/* if ($F("txtLineCd") != null || $F("txtLineCd") != ""){
				validateLineCd($F("txtPolIssCd"), "GICLS010", $F("txtLineCd"));
			} */
			objCLM.variables.prevLineCd = $F("txtLineCd");
			
			enableDisablePlate();
			if (objCLM.basicInfo.lineCode != $F("txtLineCd")){
				validateClmPolicyNo();
			}
			//Emsy 4.20.2012 ~ added this 
			if ($F("txtLineCd") == "FI") {
				//$("fireCustomRow").show();
				//$("fireCustomRow2").show();
				if(ora2010Sw == "Y"){
					$("fireCustomRow").show();
					$("fireCustomRow2").show();
				}else{
					$("fireCustomRow").hide();
					$("fireCustomRow2").hide();
				}
			}else{
				$("fireCustomRow").hide();
				$("fireCustomRow2").hide();
			}
			if ($F("txtLineCd") == "CA") {
				$("casualtyCustomRow").show();
			} else {
				$("casualtyCustomRow").hide();
			}
			if ($F("txtLineCd") != "MC") {
				$("motorCustomDiv").hide();
			} else {
				$("motorCustomDiv").show();
			}
		}catch(e){
			showErrorMessage("lineCdOnBlur", e);
		}
	}
	
	objClmBasicFuncs.polLineCdOnBlur = polLineCdOnBlur;
	
	//Line code/name LOV
	$("txtLineCdIcon").observe("click", function(){
		if (nvl(objCLMGlobal.claimId,null) != null) return;
		observeLineCd(true);
	});	
	
	/* Observe function for Subline code/name
	** @params lov - true if lov will show else not 
	*/
	objCLM.variables.prevSublineCd = "";
	function observeSublineCd(lov){
		try{
			if (nvl(objCLMGlobal.claimId,null) != null) return;
			if (nvl($F("txtLineCd"),null) != null){
				if ($F("txtSublineCd") != ""){
					function onOk(){
						clearObjectValues(objCLM.basicInfo);
						var sublineCd = $F("txtSublineCd");
						if (nvl(lov,false)) showSublineCdLOV($F("txtLineCd"), "GICLS010");
						populateBasicInfoPage(false);
						$("txtSublineCd").value = sublineCd;
						objCLM.variables.prevSublineCd = "";
						objCLM.variables.prevPolIssCd = "";
						objCLM.variables.prevIssueYy = "";
						objCLM.variables.prevPolSeqNo = "";
						objCLM.variables.prevRenewNo = "";
						if (!nvl(lov,false)) $("txtSublineCd").focus();
					}
					whenClickPolNo(onOk);
					$("txtSublineCd").value = nvl(getPreTextValue("txtSublineCd"),$F("txtSublineCd"));
					$("txtSublineCd").blur();
				}else{
					if (nvl(lov,false)) showSublineCdLOV($F("txtLineCd"), "GICLS010");
				}
			}else{
				customShowMessageBox(lineCdMsg, "I", "txtLineCd");
				return false;
			}
		}catch(e){
			showErrorMessage("observeSublineCd", e);
		}
	}
	
	//Subline code/name FOCUS
	initPreTextOnField("txtSublineCd");
	$("txtSublineCd").observe("focus", function(){
		if (nvl(objCLMGlobal.claimId,null) != null) return;
		if (objCLM.variables.checkObserveSublineCd == 0 && objCLM.variables.prevSublineCd != "") observeSublineCd(false);
		//$("txtSublineCd").select();
		objCLM.variables.checkObserveSublineCd = 0;
	});
	
	//added by kenneth : 05262015 : SR 18829
	function validateOpFlag(){
		var ret = false;
		try{
			new Ajax.Request(contextPath+"/GIUTS008CopyPolicyController",{
				parameters:{
					action: "validateOpFlag",
					lineCd: $F("txtLineCd"),
					sublineCd:	$F("txtSublineCd")
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: showNotice("Validating Op Flag, please wait..."),
				onComplete: function(response){
				hideNotice("");		
				if(nvl(response.responseText, "N") == "Y"){
					ret = true;
				}
			}
			});
			return ret;
		}catch(e){
			showErrorMessage("validateOpFlag",e);
		}
	}
	
	$("txtSublineCd").observe("change", function(){
		if(validateOpFlag()){
			showWaitingMessageBox("This subline is for Open Policies. Please enter the Declaration subline instead","E", function(){
				$("txtSublineCd").value = "";
				$("txtSublineCd").focus();
				});
		}else{
			validateSublineCd($F("txtLineCd"), "GICLS010", $F("txtSublineCd").toUpperCase());
		}
	});
	
	// irwin
	function polSublineCdOnBlur(){
		try{
			if (nvl(objCLMGlobal.claimId,null) != null) return;
			objCLM.variables.prevSublineCd = $F("txtSublineCd");
			if (objCLM.basicInfo.sublineCd != $F("txtSublineCd")){
				validateClmPolicyNo();
			}	
		}catch(e){
			showMessageBox("polSublineCdOnBlur",e);
		}
	}
	
	objClmBasicFuncs.polSublineCdOnBlur = polSublineCdOnBlur;
	//Subline code/name BLUR
	/* $("txtSublineCd").observe("blur", function(){
		if (nvl(objCLMGlobal.claimId,null) != null) return;
		objCLM.variables.prevSublineCd = $F("txtSublineCd");
		if (objCLM.basicInfo.sublineCd != $F("txtSublineCd")){
			validateClmPolicyNo();
		}	
	}); */
	
	//Subline code/name LOV
	$("txtSublineCdIcon").observe("click", function(){
		if (nvl(objCLMGlobal.claimId,null) != null) return;
		observeSublineCd(true);
	});
	
	/* Observe function for Policy Issue code/source
	** @params lov - true if lov will show else not 
	*/
	objCLM.variables.prevPolIssCd = "";
	function observePolIssCd(lov){
		try{
			if (nvl(objCLMGlobal.claimId,null) != null) return;
			if (nvl($F("txtLineCd"),null) != null){
				if ($F("txtSublineCd") != ""){
					if ($F("txtPolIssCd") != ""){
						function onOk(){
							clearObjectValues(objCLM.basicInfo);
							var sublineCd = $F("txtSublineCd");
							var polIssCd = $F("txtPolIssCd");
							if (nvl(lov,false)) showIssCdNameLOV($F("txtLineCd"), "GICLS010");
							populateBasicInfoPage(false);
							$("txtSublineCd").value = sublineCd;
							$("txtPolIssCd").value = polIssCd;
							objCLM.variables.prevPolIssCd = "";
							objCLM.variables.prevIssueYy = "";
							objCLM.variables.prevPolSeqNo = "";
							objCLM.variables.prevRenewNo = "";
							if (!nvl(lov,false)) $("txtPolIssCd").focus();
						}
						whenClickPolNo(onOk);
						$("txtPolIssCd").value = nvl(getPreTextValue("txtPolIssCd"),$F("txtPolIssCd"));
						$("txtPolIssCd").blur();
					}else{
						if (nvl(lov,false)) showIssCdNameLOV($F("txtLineCd"), "GICLS010");
					}
				}else{
					customShowMessageBox(sublineCdMsg, "I", "txtSublineCd");
					return false;
				}
			}else{
				customShowMessageBox(lineCdMsg, "I", "txtLineCd");
				return false;
			}
		}catch(e){
			showErrorMessage("observePolIssCd", e);
		}
	}
	
	//irwin
	function polIssCdOnBlur(){
		try{
			if ($F("txtPolIssCd") == riIssCd){
				if ($F("txtClmIssCd") != riIssCd && $F("txtClmIssCd") != ""){
					showMessageBox("For an RI policy, claim issuing source code must also be RI.", "I");
					$("txtClmIssCd").value = $F("txtPolIssCd");
				}
			}else{
				if ($F("txtClmIssCd") == riIssCd && $F("txtClmIssCd") != ""){
					showMessageBox("Claim issuing source code for a non-RI policy must not be RI.", "I");
					$("txtClmIssCd").value = $F("txtPolIssCd");
				}
			}
			if ($F("txtPolIssCd").toUpperCase() == "RI"){
				//$("txtRiCd").readOnly = false;
			}else{
				$("txtRiCd").readOnly = true;
			}
			
			// moved here from first blur observe 
			if (nvl(objCLMGlobal.claimId,null) != null) return;
			objCLM.variables.prevPolIssCd = $F("txtPolIssCd");
			if (objCLM.basicInfo.policyIssueCode != $F("txtPolIssCd")){
				validateClmPolicyNo();
			}	
		}catch(e){
			showErrorMessage("polIssCdOnBlur");
		}
	}
	objClmBasicFuncs.polIssCdOnBlur = polIssCdOnBlur;
	
	$("txtPolIssCd").observe("change", function(){
		validatePolIssCd("GICLS010", $F("txtLineCd"), $F("txtPolIssCd").toUpperCase()); 
	});
	//Issue code/source FOCUS
	initPreTextOnField("txtPolIssCd");
	$("txtPolIssCd").observe("focus", function(){
		if (nvl(objCLMGlobal.claimId,null) != null) return;
		if (objCLM.variables.checkObserveIssCd == 0 && objCLM.variables.prevPolIssCd != "") {
			observePolIssCd(false);
		}
		objCLM.variables.checkObserveIssCd = 0;
		//$("txtPolIssCd").select();
	});
	
	//Issue code/source BLUR
	/*$("txtPolIssCd").observe("blur", function(){
		if (nvl(objCLMGlobal.claimId,null) != null) return;
		objCLM.variables.prevPolIssCd = $F("txtPolIssCd");
		if (objCLM.basicInfo.policyIssueCode != $F("txtPolIssCd")){
			validateClmPolicyNo();
		}	
	});*/
	
	//Issue code/source LOV
	$("txtPolIssCdIcon").observe("click", function(){
		if (nvl(objCLMGlobal.claimId,null) != null) return;
		observePolIssCd(true);
	});
	
	/* Observe function for Issue Year
	** @params lov - true if lov will show else not 
	*/
	objCLM.variables.prevIssueYy = "";
	function observeIssueYy(lov){
		try{
			if (nvl(objCLMGlobal.claimId,null) != null) return;
			if (nvl($F("txtLineCd"),null) != null){
				if ($F("txtSublineCd") != ""){
					if ($F("txtPolIssCd") != ""){	
						if ($F("txtIssueYy") != ""){
							function onOk(){
								clearObjectValues(objCLM.basicInfo);
								var sublineCd = $F("txtSublineCd");
								var polIssCd = $F("txtPolIssCd");
								var issueYy = $F("txtIssueYy");
								if (nvl(lov,false)) showIssueYyLOV($F("txtLineCd"), $F("txtSublineCd"), $F("txtPolIssCd"), "GICLS010");
								populateBasicInfoPage(false);
								$("txtSublineCd").value = sublineCd;
								$("txtPolIssCd").value = polIssCd;
								$("txtIssueYy").value = issueYy;
								objCLM.variables.prevIssueYy = "";
								objCLM.variables.prevPolSeqNo = "";
								objCLM.variables.prevRenewNo = "";
								if (!nvl(lov,false)) $("txtIssueYy").focus();
							}
							whenClickPolNo(onOk);
							$("txtIssueYy").value = nvl(getPreTextValue("txtIssueYy"),$F("txtIssueYy"));
							$("txtIssueYy").blur();
						}else{
							if (nvl(lov,false)) showIssueYyLOV($F("txtLineCd"), $F("txtSublineCd"), $F("txtPolIssCd"), "GICLS010");
						}
					}else{
						customShowMessageBox(polIssCdMsg, "I", "txtPolIssCd");
						return false;
					}	
				}else{
					customShowMessageBox(sublineCdMsg, "I", "txtSublineCd");
					return false;
				}
			}else{
				customShowMessageBox(lineCdMsg, "I", "txtLineCd");
				return false;
			}
		}catch(e){
			showErrorMessage("observeIssueYy", e);
		}
	}
	
	//Issue Year FOCUS
	initPreTextOnField("txtIssueYy");
	$("txtIssueYy").observe("focus", function(){
		if (nvl(objCLMGlobal.claimId,null) != null) return;
		if (objCLM.variables.prevIssueYy != "") observeIssueYy(false);
	});
	
	function polIssueYyOnBlur(){
		try{
			if (nvl(objCLMGlobal.claimId,null) != null) return;
			$("txtIssueYy").value = $F("txtIssueYy") != "" ? Number($F("txtIssueYy")).toPaddedString(2) :"";
			objCLM.variables.prevIssueYy = $F("txtIssueYy");
			if ((nvl(objCLM.basicInfo.issueYy,"") != "" ? Number(objCLM.basicInfo.issueYy).toPaddedString(2) :null) != $F("txtIssueYy")){
				validateClmPolicyNo();
			}
		}catch(e){
			showErrorMessage("polIssueYyOnBlur",e);
		}
	}
	objClmBasicFuncs.polIssueYyOnBlur = polIssueYyOnBlur;
	// irwin
	//Issue Year BLUR // modified to change
	$("txtIssueYy").observe("change", function(){
		polIssueYyOnBlur();
	});
	
	//Issue year LOV
	$("txtIssueYyIcon").observe("click", function(){
		if (nvl(objCLMGlobal.claimId,null) != null) return;
		observeIssueYy(true);
	});
	
	/* Observe function for Policy Sequence No.
	** @params lov - true if lov will show else not 
	*/
	objCLM.variables.prevPolSeqNo = "";
	function observePolSeqNo(lov){
		try{
			if (nvl(objCLMGlobal.claimId,null) != null) return;
			if (nvl($F("txtLineCd"),null) != null){
				if ($F("txtSublineCd") != ""){
					if ($F("txtPolIssCd") != ""){			
						if ($F("txtIssueYy") != ""){
							if ($F("txtPolSeqNo") != ""){
								function onOk(){
									clearObjectValues(objCLM.basicInfo);
									var sublineCd = $F("txtSublineCd");
									var polIssCd = $F("txtPolIssCd");
									var issueYy = $F("txtIssueYy");
									var polSeqNo = $F("txtPolSeqNo");
									if (nvl(lov,false)) showPolSeqNoLOV($F("txtLineCd"), $F("txtSublineCd"), $F("txtPolIssCd"), $F("txtIssueYy"),"GICLS010");
									populateBasicInfoPage(false);
									$("txtSublineCd").value = sublineCd;
									$("txtPolIssCd").value = polIssCd;
									$("txtIssueYy").value = issueYy;
									$("txtPolSeqNo").value = polSeqNo;
									objCLM.variables.prevPolSeqNo = "";
									objCLM.variables.prevRenewNo = "";
									if (!nvl(lov,false)) $("txtPolSeqNo").focus();
								}
								whenClickPolNo(onOk);
								$("txtPolSeqNo").value = nvl(getPreTextValue("txtPolSeqNo"),$F("txtPolSeqNo"));
								$("txtPolSeqNo").blur();
							}else{
								if (nvl(lov,false)) showPolSeqNoLOV($F("txtLineCd"), $F("txtSublineCd"), $F("txtPolIssCd"), $F("txtIssueYy"),"GICLS010");
							}
						}else{
							customShowMessageBox(issueYyMsg, "I", "txtIssueYy");
							return false;
						}	
					}else{
						customShowMessageBox(polIssCdMsg, "I", "txtPolIssCd");
						return false;
					}	
				}else{
					customShowMessageBox(sublineCdMsg, "I", "txtSublineCd");
					return false;
				}
			}else{
				customShowMessageBox(lineCdMsg, "I", "txtLineCd");
				return false;
			}
		}catch(e){
			showErrorMessage("observePolSeqNo", e);
		}
	}
	
	//Policy Sequence No. FOCUS 
	initPreTextOnField("txtPolSeqNo");
	$("txtPolSeqNo").observe("focus", function(){
		if (nvl(objCLMGlobal.claimId,null) != null) return;
		if (objCLM.variables.prevPolSeqNo != "") observePolSeqNo(false);
	});
	
	
	//Policy Sequence No. BLUR // modified to change - irwin
	function polSeqNoOnBlur(){
		if (nvl(objCLMGlobal.claimId,null) != null) return;
		$("txtPolSeqNo").value = $F("txtPolSeqNo") != "" ? Number($F("txtPolSeqNo")).toPaddedString(7) :"";
		objCLM.variables.prevPolSeqNo = $F("txtPolSeqNo");
		if ((nvl(objCLM.basicInfo.policySequenceNo,"") != "" ? Number(objCLM.basicInfo.policySequenceNo).toPaddedString(7) :null) != $F("txtPolSeqNo")){
			validateClmPolicyNo();
		}
	}
	
	objClmBasicFuncs.polSeqNoOnBlur = polSeqNoOnBlur;
	$("txtPolSeqNo").observe("change", function(){
		polSeqNoOnBlur();
	});
	
	//Policy Sequence No. LOV
	$("txtPolSeqNoIcon").observe("click", function(){
		if (nvl(objCLMGlobal.claimId,null) != null) return;
		observePolSeqNo(true);
	});
	
	/* Observe function for Renew No.
	** @params lov - true if lov will show else not 
	*/
	objCLM.variables.prevRenewNo = "";
	function observeRenewNo(lov){
		try{
			objCLM.variables.prevRenewNo = $F("txtRenewNo");
			if (nvl(objCLMGlobal.claimId,null) != null) return;
			if (nvl($F("txtLineCd"),null) != null){
				if ($F("txtSublineCd") != ""){
					if ($F("txtPolIssCd") != ""){			
						if ($F("txtIssueYy") != ""){	
							if ($F("txtPolSeqNo") != ""){
								if ($F("txtRenewNo") != ""){
									function onOk(){
										clearObjectValues(objCLM.basicInfo);
										var sublineCd = $F("txtSublineCd");
										var polIssCd = $F("txtPolIssCd");
										var issueYy = $F("txtIssueYy");
										var polSeqNo = $F("txtPolSeqNo");
										var renewNo = $F("txtRenewNo");
										if (nvl(lov,false)) showRenewNoLOV($F("txtLineCd"), $F("txtSublineCd"), $F("txtPolIssCd"), $F("txtIssueYy"), $F("txtPolSeqNo"), "GICLS010");
										populateBasicInfoPage(false);
										$("txtSublineCd").value = sublineCd;
										$("txtPolIssCd").value = polIssCd;
										$("txtIssueYy").value = issueYy;
										$("txtPolSeqNo").value = polSeqNo;
										$("txtRenewNo").value = renewNo;
										objCLM.variables.prevRenewNo = "";
										if (!nvl(lov,false)) $("txtRenewNo").focus();
									}
									whenClickPolNo(onOk);
									$("txtRenewNo").value = nvl(getPreTextValue("txtRenewNo"),$F("txtRenewNo"));
									$("txtRenewNo").blur();
								}else{
									if (nvl(lov,false)) showRenewNoLOV($F("txtLineCd"), $F("txtSublineCd"), $F("txtPolIssCd"), $F("txtIssueYy"), $F("txtPolSeqNo"), "GICLS010");
								}
							}else{
								customShowMessageBox(polSeqNoMsg, "I", "txtPolSeqNo");
								return false;
							}
						}else{
							customShowMessageBox(issueYyMsg, "I", "txtIssueYy");
							return false;
						}	
					}else{
						customShowMessageBox(polIssCdMsg, "I", "txtPolIssCd");
						return false;
					}	
				}else{
					customShowMessageBox(sublineCdMsg, "I", "txtSublineCd");
					return false;
				}
			}else{
				customShowMessageBox(lineCdMsg, "I", "txtLineCd");
				return false;
			}
		}catch(e){
			showErrorMessage("observeRenewNo", e);
		}
	}
	
	//Renew No. FOCUS
	initPreTextOnField("txtRenewNo");
	$("txtRenewNo").observe("focus", function(){
		if (nvl(objCLMGlobal.claimId,null) != null) return;
		if (objCLM.variables.prevRenewNo != "") observeRenewNo(false);
	});
	
	function polRenewNoOnBlur(){
		try{
			if (nvl(objCLMGlobal.claimId,null) != null) return;
			if ($F("txtRenewNo") != nvl(objCLM.variables.prevRenewNo,"")){
				objCLM.variables.claimChecked = false;
				$("txtRenewNo").value = $F("txtRenewNo") != "" ? Number($F("txtRenewNo")).toPaddedString(2) :"";
				objCLM.variables.prevRenewNo = $F("txtRenewNo");
				validateClmPolicyNo();
			}
		}catch(e){
			showErrorMessage("polRenewNoOnBlur",e);
		}
	}
	
	objClmBasicFuncs.polRenewNoOnBlur = polRenewNoOnBlur;
	//Renew No. BLUR// modified to change - irwin
	$("txtRenewNo").observe("change", function(){
		polRenewNoOnBlur();
	});
	
	//Renew No. LOV
	$("txtRenewNoIcon").observe("click", function(){
		if (nvl(objCLMGlobal.claimId,null) != null) return;
		observeRenewNo(true);
	});
	
	//Policy No. Validation -added by christian
	function validateLineCd(polIssCd, moduleId, lineCd){
		new Ajax.Request(contextPath+"/GICLClaimsController", {
			method: "POST",
			parameters: {action : "validateGICLS010Line", //marco - 07.31.2014 - changed from validateLineCd
						polIssCd : polIssCd,
			     		moduleId : moduleId,
			     		lineCd : lineCd},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var valid = response.responseText;
					if(valid=="N"){
						showLineCdLOV($F("txtPolIssCd"), "GICLS010");
					}else{// irwin
						polLineCdOnBlur();
					}
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	function validateSublineCd(lineCd, moduleId, sublineCd){
		new Ajax.Request(contextPath+"/GICLClaimsController", {
			method: "POST",
			parameters: {action : "validateSublineCd",
						 sublineCd : sublineCd,
			     		 lineCd : lineCd},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var res = response.responseText;
					if(res == null || res == ""){
						showSublineCdLOV($F("txtLineCd"), "GICLS010");
					}else{
						polSublineCdOnBlur();							
					}
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	function validatePolIssCd(moduleId, lineCd, issCd){
		new Ajax.Request(contextPath+"/GICLClaimsController", {
			method: "POST",
			parameters: {action : "validatePolIssCd",
			     		moduleId : moduleId,
			     		lineCd : lineCd,
			     		polIssCd : issCd},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var valid = response.responseText;
					if(valid=="N"){
						showIssCdNameLOV($F("txtLineCd"), "GICLS010");
					}else{
						polIssCdOnBlur();
					}
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	//End Policy No. Validation
	
	function showPackPoliciesLOV(lineCd, sublineCd, issCd, issueYy, polSeqNo, renewNo, moduleId){
		hideNotice();  // Nante 9.3.2013
		try{
			LOV.show({
				controller: "ClaimsLOVController",
				urlParameters: {action : "getPackPoliciesLOV",
								lineCd: lineCd,
								sublineCd: sublineCd,
								issCd: issCd,
								issueYy: issueYy,
								polSeqNo: polSeqNo,
								renewNo: renewNo,
								page : 1},
				title: "List of Policy",
				width: 350,
				height: 386,
				columnModel: [ {
									id: 'nbtPackPol',
									title: 'Policy Number', 
									width: '323px'
							   },
							   {
									id: 'lineCd',
									title: "",
									width: '0px',
									visible: false
							   },
							   {
									id: 'sublineCd',
									title: "",
									width: '0px',
									visible: false
							   },
							   {
									id: 'issCd',
									title: "",
									width: '0px',
									visible: false
							   },
							   {
									id: 'issueYy',
									title: "",
									width: '0px',
									visible: false
							   },
							   {
									id: 'polSeqNo',
									title: "",
									width: '0px',
									visible: false
							   },
							   {
									id: 'renewNo',
									title: "",
									width: '0px',
									visible: false
							   },
							   {
									id: 'packPolicyId',
									title: "",
									width: '0px',
									visible: false
							   }
				             ],
				draggable: true,
		  		onSelect: function(row){
					if (moduleId == "GICLS010"){
						$("txtLineCd").value 	= row.lineCd;
						$("txtSublineCd").value = row.sublineCd;
						$("txtPolIssCd").value 	= row.issCd;
						$("txtIssueYy").value 	= row.issueYy;
						$("txtPolSeqNo").value 	= row.polSeqNo;
						$("txtRenewNo").value 	= row.renewNo;
						objCLM.variables.prevRenewNo = "";
						fireEvent($("txtRenewNo"), "blur");
						validateClmPolicyNo(); // added by: Nante 9.3.2013
					}
		  		},
		  		onCancel: function(){
		  			if (moduleId == "GICLS010"){
		  				$("txtRenewNo").value = "";
		  				objCLM.variables.prevRenewNo = "";
		  				$("txtRenewNo").focus();
		  			}
		  		}
			}); 
		}catch(e){
			showErrorMessage("showPackPolicyLOV", e);
		}
	}
	
	function cancelClaim(){
		try{
			clearObjectValues(objCLM.basicInfo);
			populateBasicInfoPage(false);
			objCLM.variables.prevLineCd = "";
			objCLM.variables.prevSublineCd = "";
			objCLM.variables.prevPolIssCd = "";
			objCLM.variables.prevIssueYy = "";
			objCLM.variables.prevPolSeqNo = "";
			objCLM.variables.prevRenewNo = "";
			$("txtLineCd").value = "";
			$("txtLineCd").focus();
			ok = false;
		}catch(e){
			showErrorMessage("cancelClaim", e);
		}	
	}
	
	function proceedClaim(){
		if ($F("txtLossTime") != ""){
			if (!claimCheck("checkTotalLossSettlement")){
				ok = false;
				return false;
			}
		}else{
			if (!checkTotalLossSettlement()){
				ok = false;
				return false;
			}
		}
		$("txtLossDate").focus();
	}
	
	function showAfterInquiry(){
		showConfirmBox("Confirmation", "Do you want to continue processing this claim?", 
				"Yes", "No", 
				proceedClaim,
				cancelClaim);	
	}	
	
	objCLM.showAfterInquiry = showAfterInquiry;
	
	function checkExistingClaims(lineCd, sublineCd, polIssCd, issueYy, polSeqNo, renewNo, plateNo){
		try{
			var ok = true;
			new Ajax.Request(contextPath+"/GICLClaimsController", {
				method: "POST",
				parameters: {
					action: 	"checkExistingClaims",
				 	lineCd:  	lineCd,
	                sublineCd:  sublineCd,
	                polIssCd:  	polIssCd,
	                issueYy:  	issueYy,
	                polSeqNo:  	polSeqNo,
	                renewNo:  	renewNo,
	                plateNo:    plateNo
				},
				asynchronous: false,
				evalScripts: true, 
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						objCLM.variables.validClaim = true;
						var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
						function showClmInq(){
							if (nvl(res.msgAlert,null) != null){
								showConfirmBox4("Confirmation", res.msgAlert, 
										"Yes", "No", "Show Inquiry",
										proceedClaim, 
										cancelClaim, 
										function(){
											showClmListingPerPolicy();
										});
							} 
						}
						if (nvl(objCLM.variables.fromPlateSw2,"N") == "Y"){ //validation from manual plate/motor/serial no.
							if (nvl(res.totalTag,"N") == "N" || (res.statusCd == "CC" || res.statusCd == "DN" || res.statusCd == "WD")){
								showClmInq();
							}else if(nvl(res.totalTag,"N") == "Y"){
								showMessageBox("Policy has an existing claim record that was tagged as total loss.", "E");
								objCLM.variables.validClaim = false;
								ok = false;
							} 
						}else{ //validation from renew no.
							showClmInq();
						}
					}else{
						ok = false;
						objCLM.variables.validClaim = false;
					}
				}					
			});
			return ok;	
		}catch(e){
			showErrorMessage("checkExistingClaims", e);
		}	
	}	
	
	function setCedantObligee(res){
		try{
			objCLM.basicInfo.assuredNo = res.assdNo;
			objCLM.basicInfo.assuredName = res.assdName;
			objCLM.basicInfo.accountOfCode = res.acctOfCd;
			objCLM.basicInfo.obligeeNo = res.obligeeNo;
			objCLM.basicInfo.riCd = res.riCd;
			objCLM.basicInfo.dspRiName = res.dspRiName;
			
			$("txtAssuredNo").value = nvl(objCLM.basicInfo.assuredNo,"");
			$("txtAssuredName").value = unescapeHTML2(objCLM.basicInfo.assuredName);
			$("txtRiCd").value = nvl(objCLM.basicInfo.riCd,"");
			$("txtCedant").value = unescapeHTML2(objCLM.basicInfo.dspRiName);
		}catch(e){
			showErrorMessage("setCedantObligee", e);
		}
	}
	
	function claimCheck(param){
		try{
			var ok = true;
			objCLM.variables.timeFlag = true;
			new Ajax.Request(contextPath+"/GICLClaimsController",{
				parameters: {
					action: 	"claimCheck",
					lineCd: 	$F("txtLineCd"),
					sublineCd: 	$F("txtSublineCd"),
					polIssCd: 	$F("txtPolIssCd"),
					issueYy: 	$F("txtIssueYy"),
					polSeqNo: 	$F("txtPolSeqNo"),
					renewNo: 	$F("txtRenewNo"),
					plateNo:	$F("txtPlateNumber"),
					claimId: 	nvl(objCLMGlobal.claimId,""),
					lossDate:	$F("txtLossDate"),
					lossTime:	$F("txtLossTime"),
					expiryDate: $F("txtExpiryDate")
				},
				asynchronous: false,
				evalSCripts: true,
				onComplete: function(response){
					objCLM.variables.validClaim = true;
					if(checkErrorOnResponse(response)){
						var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
						var msg = "";
						var claimExistOverrideOK = "";
						if (nvl(res.msgAlert,null) != null){
							showMessageBox("DUPLICATE_CLM_OVERRIDE parameter not found in giis_parameters.", "E");
							objCLM.variables.validClaim = false;
							ok = false;
							return false;
						}
						
						function onOkClaimCheck(){
							if (param == "checkTotalLossSettlement"){
								if (!checkTotalLossSettlement()){
									ok = false;
									return false;
								}
							}else if(param == "checkLossTime"){
								if (objCLM.variables.timeFlag){
									$("chkOkProcessing").disabled = false;
								}
								if (!objCLM.variables.expFlag){
									$("txtLossDesc").focus();
								}
								if ($F("txtLossDate") == ""){
									$("txtLossTime").value = "";
								}else{
									$("txtLossTime").value = nvl($F("txtLossTime"),nvl(objCLM.variables.sublineTime,""));
								}
							}else if(param == "postCheckLossDateTime"){
								checkLastEndtPlateNo("postCheckLossDateTime");
							}	
							if (claimExistOverrideOK == "Y"){
								$("chkOkProcessing").disabled = false;
							}
						}
						if (!objCLM.variables.claimChecked && $F("txtLossDate") != "" && $F("txtLossTime") != ""){
							objCLM.variables.timeFlag = (res.timeFlag == "FALSE" ? false :true);
							if (objCLM.variables.overFlag != "Y" && objCLM.variables.albadFlag != "Y"){
								function overrideEP(){
									if (objCLM.variables.expFlag && !objCLM.variables.dupFlag && objCLM.variables.expiredOverFlag == "N"){ //if not duplicate but policy is expired; added objCLM.variables.expiredOverFlag to determine if function is already been bypassed adpascual
										showConfirmBox("Confirmation","Loss date is not covered by the policy term. Would you like to override?", "Yes", "No",
													function(){
														objCLM.variables.override = "E";
														reqLossDesc(false);
														objAC.funcCode = "EP";
														objACGlobal.calledForm = "GICLS010";
														commonOverrideOkFunc = function(){
															objCLM.variables.expiredOverFlag = "Y"; //adpascual
															objCLM.variables.expFlag = false;
															objCLM.basicInfo.strLossDate = $F("txtInceptionDate") != "" ? ($F("txtInceptionDate")+" "+$F("txtInceptionTime")).strip() :"";
															objCLM.variables.check = "Y";
															objCLM.variables.chkFlag = true;
															setCedantObligee(res);
															objCLM.variables.comFlag = false;
															if ($F("txtLossTime") == "" || getPreTextValue("txtLossTime") == ""){
																$("txtLossTime").focus(); 
																setPreText("txtLossTime", "");
															}else{
																$("txtLossDesc").focus();
															}
															objCLM.variables.checkLoss = true;
															onOkClaimCheck();
														};
														commonOverrideNotOkFunc = function(){
															showWaitingMessageBox($("overideUserName").value + " is not allowed to process claim for expired policy.", "E",
																	clearOverride);
															objCLM.variables.checkLoss = false;
															ok = false;
															return false;
														};
														commonOverrideCancelFunc = function(){
															if (nvl(objCLMGlobal.claimId,null) == null){
																$("txtLossDate").value = "";
																$("txtLossDate").focus();
															}else{
																$("txtLossDate").value = objCLM.variables.oldDate;
																$("txtLossTime").value = objCLM.variables.oldTime;
																ok = false;
															}
															objCLM.variables.checkLoss = false;
															ok = false;
															return false;
														};
														getUserInfo();
														$("overlayTitle").innerHTML = "Override User";
													},
													function(){
														if (nvl(objCLMGlobal.claimId,null) == null){
															$("txtLossDate").value = "";
															$("txtLossTime").value = "";
															$("txtLossDate").focus();
														}else{
															$("txtLossDate").value = objCLM.variables.oldDate;
															$("txtLossTime").value = objCLM.variables.oldTime;
															ok = false;
														}
													});
										if (!ok) return false;
									}else{
										onOkClaimCheck();
									}
								}
								//if (!objCLM.variables.timeFlag  && nvl(dcOverrideFlag, "N") != "Y" ){// added dcOverrideFlag to bypass the override when the user already provided a override detail. - irwin
								if (!objCLM.variables.timeFlag  && nvl(objCLM.dcOverrideFlag, "N") != "Y" && objCLMGlobal.claimId == null){ //marco - 07.23.2014 - changed dcOverrideFlag, //objCLMGlobal.claimId - Added by Jerome Bautista 12.11.2015 SR 4446
									if (!objCLM.variables.expFlag){
										if (nvl(res.override) == "Y" && res.userFlag == "FALSE"){
											msg = "Claim already exists. Would you like to override?";
											objCLM.variables.dupFlag = true;
										}else if (nvl(res.override) == "N" || (nvl(res.override) == "Y" && res.userFlag == "TRUE")){
											objCLM.variables.dupFlag2 = true;
											msg = "Claim already exists. Do you want to continue?";
										}
									}else{ //kht allowed c user s duplicate claim, kng hndi xa allowed s expired, override prn.
										msg = "Loss date is not covered by the policy term and Claim already exists. Would you like to override?";
										objCLM.variables.dupFlag = true;
									}
									showConfirmBox("Confirmation",msg,"Yes","No",
											function(){
												objCLM.variables.override = "D";
												reqLossDesc(true);
												if (nvl(res.override) == "Y" && res.userFlag == "FALSE"){
													if (objCLM.variables.dupFlag && !objCLM.variables.expFlag){
														objAC.funcCode = "DC";
														objACGlobal.calledForm = "GICLS010";
														commonOverrideOkFunc = function(){
															if(objCLM.variables.dupFlag){ // irwin
																claimExistOverrideOK = "Y";
															}
															
															objCLM.variables.claimChecked = true;
															objCLM.variables.validClaim = true;
															objCLM.variables.dupFlag = false;
															$("txtLossDesc").focus();
															objCLM.variables.comFlag = false;
															reqLossDesc(true);
															objCLM.variables.checkLoss = true;
															overrideEP();
															objCLM.dcOverrideFlag = "Y"; //marco - 07.23.2014
														};
														commonOverrideNotOkFunc = function(){
															objCLM.variables.checkLoss = false;
															$("txtLossDate").value = nvl(objCLM.variables.oldDate,getPreTextValue("txtLossDate"));
															$("txtLossTime").value = nvl(objCLM.variables.oldTime,getPreTextValue("txtLossTime"));
															showWaitingMessageBox($("overideUserName").value + " is not allowed to file an existing claim.", "E", 
																	clearOverride); 
															ok = false;
															return false;
														};
													}else if (objCLM.variables.dupFlag && objCLM.variables.expFlag){
														objAC.funcCode = "EP";
														objACGlobal.calledForm = "GICLS010";
														commonOverrideOkFunc = function(){
															//if (validateUserFunc2("DC", $("overideUserName").value)){
															if (validateUserFunc3($("overideUserName").value, "DC", "GICLS010")){
																objCLM.variables.claimChecked = true;
																objCLM.variables.validClaim = true;
																objCLM.variables.dupFlag = false;
																objCLM.basicInfo.strLossDate = $F("txtInceptionDate") != "" ? ($F("txtInceptionDate")+" "+$F("txtInceptionTime")).strip() :"";
																objCLM.variables.check = "Y";
																objCLM.variables.expFlag = false;
																objCLM.variables.chkFlag = true;
																setCedantObligee(res);
																$("txtLossDesc").focus();
																objCLM.variables.comFlag = false;
																objCLM.variables.checkLoss = true;
																overrideEP();
																dcOverrideFlag = "Y";// added by irwin
															}else{
																objCLM.variables.checkLoss = false;
																$("txtLossDate").value = nvl(objCLM.variables.oldDate,getPreTextValue("txtLossDate"));
																$("txtLossTime").value = nvl(objCLM.variables.oldTime,getPreTextValue("txtLossTime"));
																showWaitingMessageBox($("overideUserName").value + " is not allowed to file an existing claim.", "E", 
																		clearOverride); 
																ok = false;
																return false;
															}
														};
														commonOverrideNotOkFunc = function(){
															objCLM.variables.checkLoss = false;
															$("txtLossDate").value = nvl(objCLM.variables.oldDate,getPreTextValue("txtLossDate"));
															$("txtLossTime").value = nvl(objCLM.variables.oldTime,getPreTextValue("txtLossTime"));
															//if (validateUserFunc2("DC", $("overideUserName").value)){
															if (validateUserFunc3($("overideUserName").value, "DC", "GICLS010")){
																showWaitingMessageBox($("overideUserName").value + " is not allowed to process claim for expired policy.", "E", 
																		clearOverride);
															}else{
																showWaitingMessageBox($("overideUserName").value + " is not allowed file an existing claim and to process claim for expired policy.", "E",
																		clearOverride);
															} 
															ok = false;
															return false;
														};
													}
													commonOverrideCancelFunc = function(){
														objCLM.variables.checkLoss = false;
														$("txtLossDate").value = nvl(objCLM.variables.oldDate,getPreTextValue("txtLossDate"));
														$("txtLossTime").value = nvl(objCLM.variables.oldTime,getPreTextValue("txtLossTime"));
														ok = false;
														return false;
														//cancelClaim();
													};
													getUserInfo();
													$("overlayTitle").innerHTML = "Override User";
												}else if (nvl(res.override) == "N" || (nvl(res.override) == "Y" && res.userFlag == "TRUE")){
													if(objCLM.variables.dupFlag2){ // irwin
														$("chkOkProcessing").disabled = false;
													}									
													objCLM.variables.claimChecked = true;
													objCLM.variables.validClaim = true;
													checkSaveGICLS010();
													objCLM.dcOverrideFlag = "Y"; //marco - 11.27.2014
												}
											},
											function(){
												if (nvl(objCLMGlobal.claimId,null) == null){
													cancelClaim();
												}else{
													$("txtLossDate").value = objCLM.variables.oldDate;
													$("txtLossTime").value = objCLM.variables.oldTime;
													ok = false;
												}
											});
									if (!ok) return false;
								}else{
									overrideEP();
								}	
							}
						}else if (!objCLM.variables.claimChecked && $F("txtLossDate") != "" && $F("txtLossTime") == ""){
							overrideEP();
						}else{
							onOkClaimCheck();	
						}	
					}else{
						objCLM.variables.validClaim = false;
						ok = false;
					}
				}
			});
			return ok;
		}catch(e){
			showErrorMessage("claimCheck", e);
		}	
	}
	
	function reqLossDesc(param){
		return; //no need na ata ng ganito return ko muna
		if (param == true){
			$("txtLossCatCd").addClassName("required");
			$("txtLossDesc").addClassName("required");
		}else if (param == false){
			$("txtLossCatCd").removeClassName("required");
			$("txtLossDesc").removeClassName("required");
		}
	}
	
	function checkTotalLossSettlement(param){
		try{
			var ok = true;
			new Ajax.Request(contextPath+"/GICLClaimsController",{
				parameters:{
					action: 	"checkTotalLossSettlement",
					lineCd: 	$F("txtLineCd"),
					sublineCd: 	$F("txtSublineCd"),
					polIssCd: 	$F("txtPolIssCd"),
					issueYy: 	$F("txtIssueYy"),
					polSeqNo: 	$F("txtPolSeqNo"),
					renewNo: 	$F("txtRenewNo"),
					polEffDate: $F("txtInceptionDate"),
					expiryDate: $F("txtExpiryDate"),
					lossDate: 	setDfltSec(objCLM.basicInfo.strLossDate), 
					itemNo: 	objCLM.basicInfo.itemNo 
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if (checkErrorOnResponse(response)) {
						objCLM.variables.validClaim = true;
						var totalLoss = response.responseText;
						if (nvl(totalLoss,"TRUE") == "FALSE" && !objCLM.variables.tlFlag){
							if (validateUserFunc2("TL", "GICLS010")){
								showConfirmBox("Confirm", "All items for this policy had been tagged as total loss. Do you want to continue?", 
										"Yes", "No", 
										"", cancelClaim);
							}else{
								showConfirmBox("Confirm", "Cannot create claim, all items for this policy had been tagged as total loss. Do you want to override?", 
										"Yes", "No", 
										function(){
											objCLM.variables.override = "T";
											reqLossDesc(true);
											objAC.funcCode = "TL";
											objACGlobal.calledForm = "GICLS010";
											commonOverrideOkFunc = function(){
												if(param == true){
													$("txtLossDate").focus();
												}else if(param == false){
													if ($F("txtLossTime") == "" || getPreTextValue("txtLossTime") == ""){
														$("txtLossTime").focus();
														setPreText("txtLossTime", "");
													}else{
														$("txtLossDesc").focus();
													}
												}else{
													$("txtLossDate").focus();
												}
												objCLM.variables.validClaim = true;
												objCLM.variables.tlFlag = true;
												//CheckLossDateWithPlateNo(); 
											};
											commonOverrideNotOkFunc = function(){
												showWaitingMessageBox($("overideUserName").value + " is not allowed to process claim with items for policy are tagged as total loss.", "E", 
														clearOverride);
												objCLM.variables.validClaim = false;
												ok = false;
												return false;
											};
											commonOverrideCancelFunc = function(){
												cancelClaim();
											};
											getUserInfo();
											$("overlayTitle").innerHTML = "Override User";
										}, cancelClaim);
							}
						}else{
							if(param == true){
								$("txtLossDate").focus();
							}else if(param == false){
								if ($F("txtLossTime") == "" || getPreTextValue("txtLossTime") == ""){
									$("txtLossTime").focus();
									setPreText("txtLossTime", "");
								}else{
									$("txtLossDesc").focus();
								}
							}else{
								$("txtLossDate").focus();
							}
							objCLM.variables.validClaim = true;
							objCLM.variables.tlFlag = true;
						}
					}else{
						ok = false;
						objCLM.variables.validClaim = false;
					}
				}
			});	
			return ok;
		}catch(e){
			showErrorMessage("checkTotalLossSettlement", e);
		}
	}
	
	function hideShowPlateMotorSerial(param){
		if (param == true){
			$("oscmPlateNumber").hide();
			$("oscmMotorNumber").hide();
			$("oscmSerialNumber").hide();
			$("txtPlateNumber").readOnly 	= true;
			$("txtMotorNumber").readOnly 	= true;
			$("txtSerialNumber").readOnly 	= true; 	
		}else{
			$("oscmPlateNumber").show();
			$("oscmMotorNumber").show();
			$("oscmSerialNumber").show();
			$("txtPlateNumber").readOnly 	= false;
			$("txtMotorNumber").readOnly 	= false;
			$("txtSerialNumber").readOnly 	= false; 	
		}	
	}	
	
	function conCreateClm(res){
		try{
			function onOk(){
				objCLM.basicInfo.lineCode = res.lineCd;
				objCLM.basicInfo.menuLineCd = res.menuLineCd; //added by jeffdojello 10.01.2013
				objCLM.basicInfo.sublineCd = res.sublineCd;
				objCLM.basicInfo.policyIssueCode = res.polIssCd;
				objCLM.basicInfo.issueYy = res.issueYy;
				objCLM.basicInfo.policySequenceNo = res.polSeqNo;
				objCLM.basicInfo.renewNo = res.renewNo;
				objCLM.basicInfo.strLossDate = res.lossDate;
				objCLM.basicInfo.polEffDate = res.polEffDate;
				objCLM.basicInfo.strPolicyEffectivityDate = res.polEffDate;
				objCLM.basicInfo.strExpiryDate = res.expiryDate;
				objCLM.basicInfo.strIssueDate = res.issueDate;
				objCLM.basicInfo.issueDate = res.issueDate;
				objCLM.basicInfo.assuredNo = res.assdNo;
				objCLM.basicInfo.assuredName = res.assdName;
				objCLM.basicInfo.accountOfCode = res.acctOfCd;
				objCLM.basicInfo.dspAcctOf = res.dspAcctOf; //added by christian
				objCLM.basicInfo.obligeeNo = res.obligeeNo;
				objCLM.basicInfo.packPolNo = nvl(res.nbtPkPol,null);
				objCLM.basicInfo.packPolFlag = nvl(res.nbtPackPol,null);
				objCLM.basicInfo.packPolicyId = nvl(res.nbtPackPolicyId,null);
				objCLM.variables.issueDate = res.issueDate;
				objCLM.basicInfo.itemNo = res.itemNo;
				objCLM.basicInfo.plateNumber = res.plateNo;
				objCLM.basicInfo.motorNumber = res.motorNo;
				objCLM.basicInfo.serialNumber = res.serialNo;
				objCLM.basicInfo.plateSw = nvl(res.plateSw,"N");
				objCLM.basicInfo.plateSw2 = nvl(res.plateSw2,"N");
				objCLM.basicInfo.packageSw = nvl(res.packageSw,"N");
				

			    objCLMGlobal.menuLineCd = res.menuLineCd; //added by jeffdojello 10.01.2013
				
				if (nvl(objCLM.basicInfo.plateSw,"N") == "Y" || nvl(objCLM.basicInfo.plateSw2,"N") == "Y"){
					hideShowPlateMotorSerial(false);
				}else{
					hideShowPlateMotorSerial(true);
				}
				
				if (nvl(objCLM.variables.fromPlateSw2,"N") == "Y"){
					objCLM.basicInfo.plateNumber = escapeHTML2($("txtPlateNumber").value);
					objCLM.basicInfo.motorNumber = escapeHTML2($("txtMotorNumber").value);
					objCLM.basicInfo.serialNumber = escapeHTML2($("txtSerialNumber").value);
				}
				
				//Will automatically display list of policies for Package
				if (nvl(objCLM.basicInfo.packageSw,"N") == "Y" && nvl(objCLM.variables.fromPlateSw2,"N") == "N"){
					showPackPoliciesLOV(res.lineCd, res.sublineCd, res.polIssCd, res.issueYy, res.polSeqNo, res.renewNo, "GICLS010");					
					return false;
				}
				
				if (nvl(objCLM.basicInfo.plateSw,"N") == "Y" && nvl(objCLM.variables.fromPlateSw2,"N") == "N"){ 			//if validation from renew number
					//Will automatically display list of valid Plate Nos
					if (!nvl(showValidPlateNosLOV(res.lineCd, res.sublineCd, res.polIssCd, res.issueYy, res.polSeqNo, res.renewNo, "GICLS010"),true)){
						return false;
					}
				}else if (nvl(objCLM.basicInfo.plateSw2,"N") == "Y"){ 	// if validation from plate/motor/serial number
					if (nvl(objCLM.variables.fromPlateSw2,"N") == "N"){
						var label = "";
						if (res.param1 == "PLATE_NO") label = "Plate No.";
						if (res.param1 == "MOTOR_NO") label = "Motor No.";
						if (res.param1 == "SERIAL_NO") label = "Serial No.";
						showConfirmBox("Confirmation",label+" entered exists in more than one policy. Do you wish to continue?",
									"Ok", "Cancel", 
									showPlateMotorSerialLOV, cancelClaim);
					} 
				}else{
					if (!checkExistingClaims(res.lineCd, res.sublineCd, res.polIssCd, res.issueYy, res.polSeqNo, res.renewNo, res.plateNo)){
						return false;
					}
				} 
				
				var incDate = nvl(objCLM.basicInfo.polEffDate,null) != null ? objCLM.basicInfo.polEffDate.substr(0, objCLM.basicInfo.polEffDate.indexOf(" ")) :null;
				var incTime = nvl(objCLM.basicInfo.polEffDate,null) != null ? objCLM.basicInfo.polEffDate.substr(objCLM.basicInfo.polEffDate.indexOf(" ")+1, objCLM.basicInfo.polEffDate.length) :null;
				var expDate = nvl(objCLM.basicInfo.strExpiryDate,null) != null ? objCLM.basicInfo.strExpiryDate.substr(0, objCLM.basicInfo.strExpiryDate.indexOf(" ")) :null;
				var expTime = nvl(objCLM.basicInfo.strExpiryDate,null) != null ? objCLM.basicInfo.strExpiryDate.substr(objCLM.basicInfo.strExpiryDate.indexOf(" ")+1, objCLM.basicInfo.strExpiryDate.length) :null;
				var lossDate = nvl(objCLM.basicInfo.strDspLossDate,null) != null ? objCLM.basicInfo.strDspLossDate.substr(0, objCLM.basicInfo.strDspLossDate.indexOf(" ")) :null;
				var lossTime = nvl(objCLM.basicInfo.strDspLossDate,null) != null ? objCLM.basicInfo.strLossDate.substr(objCLM.basicInfo.strDspLossDate.indexOf(" ")+1, objCLM.basicInfo.strDspLossDate.length) :null;
				$("txtLineCd").value = objCLM.basicInfo.lineCode;
				$("txtSublineCd").value = unescapeHTML2(objCLM.basicInfo.sublineCd); // added unescapeHTML2 function christian 10.03.2012
				$("txtPolIssCd").value = objCLM.basicInfo.policyIssueCode;
				$("txtIssueYy").value = nvl(String(objCLM.basicInfo.issueYy),null) != null ? Number(objCLM.basicInfo.issueYy).toPaddedString(2) :null;
				$("txtPolSeqNo").value = nvl(String(objCLM.basicInfo.policySequenceNo),null) != null ? Number(objCLM.basicInfo.policySequenceNo).toPaddedString(7) :null;
				$("txtRenewNo").value = nvl(String(objCLM.basicInfo.renewNo),null) != null ? Number(objCLM.basicInfo.renewNo).toPaddedString(2) :null;
				$("txtLossDate").value = nvl(lossDate,$F("txtLossDate"));
				$("txtInceptionDate").value = incDate;
				$("txtInceptionTime").value = incTime;
				$("txtExpiryDate").value = expDate;
				$("txtExpiryTime").value = expTime;
				$("txtAssuredNo").value = objCLM.basicInfo.assuredNo;
				$("txtAssuredName").value = unescapeHTML2(objCLM.basicInfo.assuredName); 
				$("txtLeasedTo").value = unescapeHTML2(objCLM.basicInfo.dspAcctOf); //added by christian
				$("txtPackPolNo").value = unescapeHTML2(objCLM.basicInfo.packPolNo);
				$("txtPlateNumber").value = unescapeHTML2(objCLM.basicInfo.plateNumber);
				$("txtMotorNumber").value = unescapeHTML2(objCLM.basicInfo.motorNumber);
				$("txtSerialNumber").value = unescapeHTML2(objCLM.basicInfo.serialNumber);
				if (nvl(objCLM.variables.fromPlateSw2,"N") == "Y") objCLM.variables.fromPlateSw2 = "N";
				postQuery();
				$("txtLossDate").focus();
				 
				if (nvl(objCLM.basicInfo.plateSw,"N") == "Y" || nvl(objCLM.basicInfo.plateSw2,"N") == "Y"){
					hideShowPlateMotorSerial(false);
				}else{
					hideShowPlateMotorSerial(true);
				}	
			}
			if (nvl(res.expDateSw,null) != null){
				showConfirmBox("Confirmation", "Policy is already expired. Do you still want to continue processing the claim?",
							"Ok", "Cancel",
							onOk, "");
			}else{
				onOk();
			}
		}catch(e){
			showErrorMessage("conCreateClm", e);
		}
	}
	
	/**
	 * To check if selected item has been tagged as total loss
	 * */
	function chkItemForTotalLoss(itemNo){
		try{
			var ok = true;
			new Ajax.Request(contextPath+"/GICLClaimsController",{
				parameters:{
					action: "chkItemForTotalLoss",
					lineCd: $F("txtLineCd"),
					sublineCd: $F("txtSublineCd"),
					polIssCd: $F("txtPolIssCd"),
					issueYy: $F("txtIssueYy"),
					polSeqNo: $F("txtPolSeqNo"),
					renewNo: $F("txtRenewNo"),
					itemNo: itemNo 
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)) {
						objCLM.variables.validClaim = true;
						var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
						if (nvl(res.msgAlert,null) != null){
							clearObjectValues(objCLM.basicInfo);
							showWaitingMessageBox(res.msgAlert, "E", function(){
								$("txtSublineCd").focus();
							});
							populateBasicInfoPage(false);
							ok = false;
						}else{
							if (!checkExistingClaims($F("txtLineCd"), $F("txtSublineCd"), $F("txtPolIssCd"), $F("txtIssueYy"), $F("txtPolSeqNo"), $F("txtRenewNo"), $F("txtPlateNumber"))){
								ok = false;
							}
						}
					}else{
						objCLM.variables.validClaim = false;
						ok = false;
					}
				}
			});
			return ok;
		}catch(e){
			showErrorMessage("chkItemForTotalLoss", e);
		}
	}
	
	/**
	 * Shows LOV for Plate/Motor/Serial No.'s 
	 * */
	function showValidPlateNosLOV(lineCd, sublineCd, issCd, issueYy, polSeqNo, renewNo, moduleId){
		var ok = true;
		//objCLM.basicInfo.plateSw = "N";
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getValidPlateNosLOV",
							lineCd: lineCd,
							sublineCd: sublineCd,
							issCd: issCd,
							issueYy: issueYy,
							polSeqNo: polSeqNo,
							renewNo: renewNo,
							page : 1},
			title: "Valid Plate Nos.",
			width: 419,
			height: 386,
			columnModel: [ {
								id: 'plateNo',
								title: 'Plate No.', 
								width: '100px'
						   },
						   {
								id: 'motorNo',
								title: 'Motor No.', 
								width: '100px'
						   },
						   {
								id: 'serialNo',
								title: 'Serial No.', 
								width: '100px'
						   },
						   {
								id: 'itemNo',
								title: 'Item No.', 
								width: '100px'
						   }
			             ],
			draggable: true,
	  		onSelect: function(row){
				if (moduleId == "GICLS010"){
					objCLM.basicInfo.itemNo		= row.itemNo;
					$("txtPlateNumber").value   = unescapeHTML2(row.plateNo);
					$("txtMotorNumber").value  	= unescapeHTML2(row.motorNo);
					$("txtSerialNumber").value  = unescapeHTML2(row.serialNo);
					$("txtLossDate").focus();
					if (!chkItemForTotalLoss(row.itemNo)){
						ok = false;
						return false;
					}
				}
	  		},
	  		onCancel: function(){
	  			if (moduleId == "GICLS010"){
	  				if (!checkExistingClaims(lineCd, sublineCd, issCd, issueYy, polSeqNo, renewNo, "")){
	  					ok = false;
						return false;
					}
	  				$("txtLossDate").focus();
	  			}
	  		}
		});
		return ok;
	}
	
	/*comment by nok 04.20.12 di daw updateable ito incept & exp date/time
	observeBackSpaceOnDate("txtInceptionDate");
	$("txtInceptionDate").observe("blur", function(){
		if (nvl($F("txtInceptionDate"),"") != ""){
			$("txtInceptionTime").focus();
		}else{
			$("txtInceptionTime").clear();
		}
	});
	
	$("txtInceptionTime").observe("blur", function(){
		if (nvl($F("txtInceptionTime"),"") == ""){
			if (nvl($F("txtInceptionDate"),"") != "") $("txtInceptionTime").value = "12:00 AM";
		}else{
			var time = isValidTime("txtInceptionTime", "AM", true, false);
			if (!time){
				$("txtInceptionTime").value = "12:00 AM";
			} 
		}
	});
	
	observeBackSpaceOnDate("txtExpiryDate");
	$("txtExpiryDate").observe("blur", function(){
		if (nvl($F("txtExpiryDate"),"") != ""){
			$("txtExpiryTime").focus();
		} else{
			$("txtExpiryTime").clear();
		}
	});
	
	$("txtExpiryTime").observe("blur", function(){
		if (nvl($F("txtExpiryTime"),"") == ""){
			if (nvl($F("txtExpiryDate"),"") != "") $("txtExpiryTime").value = "12:00 AM";
		}else{
			var time = isValidTime("txtExpiryTime", "AM", true, false);
			if (!time){
				$("txtExpiryTime").value = "12:00 AM";
			} 
		}
	});
	*/
	
	initPreTextOnField("txtLossTime");
	$("txtLossTime").observe("blur", function(){
		if ($F("txtExpiryDate") != "" && $F("txtInceptionDate") != ""){
			objCLM.variables.sublineTime = getSublineTime($F("txtLineCd"), $F("txtSublineCd"));
		}
		
		var time = isValidTime("txtLossTime", "AM", true, false);
		if (!time) return false;
		
 		if ($F("txtLossTime") == ""){
			if ($F("txtLossDate") == ""){
				$("txtLossTime").value = "";
			}else{
				$("txtLossTime").value = nvl(objCLM.variables.sublineTime,"");
			}
		}  
		
		if (nvl($F("txtLossTime"),"") != "" && checkIfValueChanged("txtLossTime")){
			if (nvl(objCLMGlobal.claimId,null) != null){
				conCheckLossDateTime(false);
			}else{
				checkLossDateTime("time");
			}
		}else{
			if (nvl($F("txtLossDate"),"") != ""){
				$("txtLossDate").focus();
			}else{
				$("txtLossDesc").focus();
			}
		}
	});
	
	//to avoid validation of loss time with null loss date - christian 04/06/2013
	$("txtLossTime").observe("focus", function(){
		if($F("txtLossDate") == ""){
			customShowMessageBox("Loss date should have a value.", "E", "txtLossDate");
		}
	});
	
	function checkLossTime(){
		try{  
			objCLM.variables.claimChecked = false;
			if ($F("txtLossDate") == ""){
				reqLossDesc(false);
		 	    if ($F("txtLossDate") == ""){
		 	    	$("txtLossDate").focus();                                    
		 	    }else{
		 	    	$("txtLossTime").focus();                  
		    		 $("txtLossTime").value = nvl(objCLM.variables.sublineTime,"");
		 	    }
				reqLossDesc(true);
			}
			claimCheck("checkLossTime");
		}catch(e){
			showErrorMessage("checkLossTime", e);
		}
	}
	
	function conTime(){
		try{
			if (objCLM.variables.check == "Y"){
				new Ajax.Request(contextPath+"/GICLClaimsController",{
					parameters:{
						action: "validateLossTime",
						lineCd: $F("txtLineCd"),
						sublineCd: $F("txtSublineCd"),
						polIssCd: $F("txtPolIssCd"),
						issueYy: $F("txtIssueYy"),
						polSeqNo: $F("txtPolSeqNo"),
						renewNo: $F("txtRenewNo"),
						lossDate: $F("txtLossDate"),
						expiryDate: $F("txtExpiryDate"),
						userLevel: $F("userLevel")
					},
					asynchronous: false,
					evalScripts: true,
					onComplete: function(response){
						if(checkErrorOnResponse(response)) {
							var res = JSON.parse(response.responseText); //removed .replace(/\\/g, '\\\\') by robert 10.22.2013
							
							setCedantObligee(res);
							objCLM.basicInfo.inHouseAdjustment = res.inHouAdj;
							objCLM.basicInfo.dspInHouAdjName = res.nbtInHouAdjName;
							objCLM.basicInfo.strClaimFileDate = res.clmFileDate;
							
							$("txtInHouseAdjustment").value = unescapeHTML2(objCLM.basicInfo.inHouseAdjustment);
							$("txtClmProcessor").value = unescapeHTML2(objCLM.basicInfo.dspInHouAdjName);
							$("txtDateFiled").value = objCLM.basicInfo.strClaimFileDate;
							$("txtLossDesc").focus();
							checkLossTime();
						}	
					}
				});
			}else{
				checkLossTime();
			}
		}catch(e){
			showErrorMessage("conTime", e);
		}
	}
	
	function postCheckLossDateTime(){
		try{
			if ($F("txtClmEntryDate") == ""){
				var date = new Date();
				$("txtClmEntryDate").value = dateFormat(date,"mm-dd-yyyy");
			}	
			if ($F("txtLossTime") == ""){
				if ($F("txtExpiryDate") != "" && $F("txtInceptionDate") != ""){
					objCLM.variables.sublineTime = getSublineTime($F("txtLineCd"), $F("txtSublineCd"));
					if ($F("txtLossDate") == ""){
						$("txtLossTime").value = "";
					}else{
						$("txtLossTime").value = nvl(objCLM.variables.sublineTime,"");
					}	
				}	
			}	
			claimCheck("postCheckLossDateTime");
		}catch(e){
			showErrorMessage("postCheckLossDateTime", e);
		}
	}	
	
	function checkLossDateTime(param){
		try{  
			ok = true;
			objCLM.variables.expFlag = false;
			objCLM.variables.validClaim = true;
			if (nvl(allowExpiredPol,"") == ""){
				prevValOfLossDateAndTime();
				showMessageBox("ALLOW_EXPIRED_POLICY does not exist in GIIS_PARAMETERS.", "E");
				objCLM.variables.validClaim = false;
				ok = false;
				return false;
			}
			if ($F("txtLineCd") == nvl(lineCodeSU,"") && nvl(bondCoverage,"") == ""){
				prevValOfLossDateAndTime();
				showMessageBox("BOND_COVERAGE does not exist in GIIS_PARAMETERS.", "E");
				objCLM.variables.validClaim = false;
				ok = false;
				return false;
			}
			new Ajax.Request(contextPath+"/GICLClaimsController",{
				parameters:{
					action: "checkLossDateTime",
					lineCd: $F("txtLineCd"),
					sublineCd: $F("txtSublineCd"),
					polIssCd: $F("txtPolIssCd"),
					issueYy: $F("txtIssueYy"),
					polSeqNo: $F("txtPolSeqNo"),
					renewNo: $F("txtRenewNo"),
					lossDate: $F("txtLossDate") 
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)) {
						var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
						function validateDate(){
							objCLM.variables.sublineTime = nvl(res.sublineTime,"");
							var dspLossDate = $F("txtLossDate") != "" ? new Date(($F("txtLossDate").replace(/-/g,"/")+" "+nvl($F("txtLossTime"),nvl(objCLM.variables.sublineTime,""))).strip()) :"";
							var polEffDate = $F("txtInceptionDate") != "" ? new Date(($F("txtInceptionDate").replace(/-/g,"/")+" "+$F("txtInceptionTime")).strip()) :"";
							var expiryDate = $F("txtExpiryDate") != "" ? new Date(($F("txtExpiryDate").replace(/-/g,"/")+" "+$F("txtExpiryTime")).strip()) :"";
							
							function onOkValidateDate(){
								if(param == true){
									conCheckLossDateTime();
								}else if(param == false){
									if (!objCLM.variables.checkLastEndtPlateNo) checkLastEndtPlateNo();
								}else if (param == "time"){
									conTime();
								}else if(param == "commit"){
									postCheckLossDateTime();  
								}else{
									conCheckLossDateTime();
								}
							}
							
							if (dspLossDate < polEffDate){
								if (nvl(allowExpiredPol,'N') == 'Y'){
									if (param == "time" && objCLM.variables.check == "Y"){ //nok 4.19.12
										objCLM.basicInfo.strLossDate = $F("txtInceptionDate") != "" ? $F("txtInceptionDate")+" "+nvl(objCLM.variables.sublineTime,"") :"";
										objCLM.variables.chkFlag = true;
										objCLM.variables.comFlag = false;
										objCLM.variables.check = "Y";
										onOkValidateDate();
									}else{	
										showConfirmBox("Confirmation", "Loss date is not covered by the policy term. Coverage for this policy is from "+
												$F("txtInceptionDate")+" "+nvl(objCLM.variables.sublineTime,"")+" to "+$F("txtExpiryDate")+" "+nvl(objCLM.variables.sublineTime,"")+". Do you wish to continue?", 
																	"Yes", "No", 
																	function(){
																		objCLM.basicInfo.strLossDate = $F("txtInceptionDate") != "" ? $F("txtInceptionDate")+" "+nvl(objCLM.variables.sublineTime,"") :"";
																		objCLM.variables.chkFlag = true;
																		objCLM.variables.comFlag = false;
																		objCLM.variables.check = "Y";
																		onOkValidateDate();
																	}, 
																	function(){
																		$("chkOkProcessing").disabled = true; 
																		if (param == "time"){
																			$("txtLossTime").value = "";
																			$("txtLossTime").focus();
																		}else{
																			$("txtLossDate").value = "";
																			$("txtLossDate").focus();
																		}
																		ok = false; 
																	});
									}
									if (!ok) return false;
								}else if (nvl(allowExpiredPol,'N') == 'N'){
									showMessageBox("Loss date is not covered by the policy term. Coverage for this policy is from "+
											$F("txtInceptionDate")+" "+nvl(objCLM.variables.sublineTime,"")+" to "+$F("txtExpiryDate")+" "+nvl(objCLM.variables.sublineTime,"")+".", "E");
									objCLM.variables.validClaim = false;
									ok = false;
									return false;
								}else if (nvl(allowExpiredPol,'N') == 'O'){
									if (res.allowed == "Y"){
										objCLM.variables.check = "Y";
										objCLM.basicInfo.strLossDate = $F("txtInceptionDate") != "" ? ($F("txtInceptionDate")+" "+nvl(objCLM.variables.sublineTime,"")).strip() :""; 
									}else{
										objCLM.variables.expFlag = true;
										objCLM.variables.bondFlag = false;
									}
									onOkValidateDate();
								}
								objCLM.variables.validClaim = true;
							}else if (dspLossDate > expiryDate){
								if (nvl(allowExpiredPol,'N') == 'Y'){
									if (param == "time" && objCLM.variables.check == "Y"){ //nok 4.19.12
										objCLM.basicInfo.strLossDate = $F("txtExpiryDate") != "" ? ($F("txtExpiryDate")+" "+nvl(objCLM.variables.sublineTime,"")).strip() :"";
										objCLM.variables.chkFlag = true;
										objCLM.variables.comFlag = false;
										objCLM.variables.check = "Y";
										onOkValidateDate();
									}else{	
										showConfirmBox("Confirmation", "Loss date is not covered by the policy term. Coverage for this policy is from "+
												$F("txtInceptionDate")+" "+nvl(objCLM.variables.sublineTime,"")+" to "+$F("txtExpiryDate")+" "+nvl(objCLM.variables.sublineTime,"")+". Do you wish to continue?", 
																	"Yes", "No", 
																	function(){
																		objCLM.basicInfo.strLossDate = $F("txtExpiryDate") != "" ? ($F("txtExpiryDate")+" "+nvl(objCLM.variables.sublineTime,"")).strip() :"";
																		objCLM.variables.chkFlag = true;
																		objCLM.variables.comFlag = false;
																		objCLM.variables.check = "Y";
																		onOkValidateDate();
																	}, 
																	function(){
																		$("chkOkProcessing").disabled = true; 
																		if (nvl(param,"") == "time"){
																			$("txtLossTime").value = "";
																			$("txtLossTime").focus();
																		}else{
																			$("txtLossDate").value = "";
																			$("txtLossDate").focus();
																		}
																		ok = false;
																	});
									}
									if (!ok) return false;
								}else if (nvl(allowExpiredPol,'N') == 'N'){
									showMessageBox("Loss date is not covered by the policy term. Coverage for this policy is from "+
											$F("txtInceptionDate")+" "+nvl(objCLM.variables.sublineTime,"")+" to "+$F("txtExpiryDate")+" "+nvl(objCLM.variables.sublineTime,"")+".", "E");
									objCLM.variables.validClaim = false;
									ok = false;
									return false;
								}else if (nvl(allowExpiredPol,'N') == 'O'){
									if (res.allowed == "Y"){
										objCLM.variables.check = "Y";
										objCLM.basicInfo.strLossDate = $F("txtExpiryDate") != "" ? ($F("txtExpiryDate")+" "+nvl(objCLM.variables.sublineTime,"")).strip() :""; 
									}else{
										objCLM.variables.expFlag = true;
										objCLM.variables.bondFlag = false;
									}
									onOkValidateDate();
								}
								objCLM.variables.validClaim = true;
							}else{
								objCLM.variables.comFlag = false;
								objCLM.variables.check = "Y";
								objCLM.basicInfo.strLossDate = $F("txtLossDate") != "" ? ($F("txtLossDate")+" "+nvl($F("txtLossTime"),nvl(objCLM.variables.sublineTime,""))).strip() :"";
								onOkValidateDate();
							}
						}	
						
						function alertOverride(){
							//if (!validateUserFunc2("AD", "GICLS010")){
								if (nvl(res.alertOverride,null) != null && objCLM.variables.accptFlag == "N" && objCLM.variables.accDateOverFlag == "N"){ // added objCLM.variables.accDateOverFlag by robert SR 18650 06.30.15
									if (objCLM.variables.albadFlag == "N"){
										showConfirmBox("Confirmation", res.alertOverride, "Yes", "No", 
											function(){ 
												objAC.funcCode = "AD";
												objACGlobal.calledForm = "GICLS010";
												commonOverrideOkFunc = function(){
													$("txtLossTime").focus(); 
													objCLM.variables.albadFlag = "Y";
													objCLM.variables.accptFlag = "Y";
													objCLM.variables.accDateOverFlag = "Y"; // added by robert SR 18650 06.30.15
													objCLM.variables.validClaim = true;
													validateDate();
												};
												commonOverrideNotOkFunc = function(){
													showWaitingMessageBox($("overideUserName").value + " is not allowed to Override.", "E", 
															clearOverride);
													objCLM.variables.validClaim = false;
													ok = false; 
													return false;
												};
												commonOverrideCancelFunc = function(){
													$("txtLossDate").value = ""; 
													$("txtLossDate").focus();
													ok = false; 
												};
												getUserInfo();
												$("overlayTitle").innerHTML = "Override User";
											}, 
											function(){
												$("txtLossDate").value = ""; 
												$("txtLossDate").focus();
												ok = false; 
											});
										if (!ok) return false;
									}else{
										$("txtLossTime").focus(); 
										objCLM.variables.albadFlag = "Y";
										objCLM.variables.accptFlag = "Y";
										validateDate();
									}
								}else{
									validateDate();
								}
							//}
						}
						
						if (nvl(res.msgAlert,null) != null){
							showWaitingMessageBox(res.msgAlert, "E", prevValOfLossDateAndTime);
							objCLM.variables.validClaim = false;
							ok = false;
							return false;
						}else{
							if (nvl(res.alertAcceptDate,null) != null && objCLM.variables.accptFlag == "N"){
								showConfirmBox("Confirmation", res.alertAcceptDate, "Yes", "No", 
										function(){
											objCLM.variables.accptFlag = "Y";
											alertOverride();
										},
										function(){
											$("txtLossDate").value = ""; 
											$("txtLossDate").focus();
											ok = false; 
										});
								if (!ok) return false;
							}else{
								alertOverride();
							}
						}
					}else{
						objCLM.variables.validClaim = false;
						ok = false;
					}
				}
			});
			return ok;
		}catch(e){
			showErrorMessage("checkLossDateTime", e);
		}
	}
	
	function checkNoClaim(){
		try{
			saveGICLS010();
		}catch(e){
			showErrorMessage("checkNoClaim", e);
		}	
	}	
	
	function postCheckLastEndtPlateNo(){
		try{
			//robert --03.07.2013 sr12375
			if ($F("txtLineCd") == lineCodeSU){
				objCLM.variables.insClmItemAndItemPeril = "Y";
				var proc = new Object(); 
				proc.name = "insClmItemAndItemPeril";
				objCLM.variables.procs.push(proc);
			}
			// --END robert
			if (nvl(objCLM.basicInfo.strLossDate,null) == null){
				var dspLossDate = $F("txtLossDate") != "" ? new Date(($F("txtLossDate").replace(/-/g,"/")+" "+nvl($F("txtLossTime"),nvl(objCLM.variables.sublineTime,""))).strip()) :"";
				var polEffDate = $F("txtInceptionDate") != "" ? new Date(($F("txtInceptionDate").replace(/-/g,"/")+" "+$F("txtInceptionTime")).strip()) :"";
				var expiryDate = $F("txtExpiryDate") != "" ? new Date(($F("txtExpiryDate").replace(/-/g,"/")+" "+$F("txtExpiryTime")).strip()) :"";
				
				if (dspLossDate > expiryDate){
		    		objCLM.basicInfo.strLossDate = ($F("txtExpiryDate")+" "+$F("txtExpiryTime")).strip();
		    	}else if(dspLossDate < polEffDate){
		    		objCLM.basicInfo.strLossDate = ($F("txtInceptionDate")+" "+$F("txtInceptionTime")).strip();
		    	}else{
		    		objCLM.basicInfo.strLossDate = ($F("txtLossDate")+" "+$F("txtLossTime")).strip();
		    	}	
			}	
			checkNoClaim();
		}catch(e){
			showErrorMessage("postCheckLastEndtPlateNo", e);
		}
	}	
	
	function checkLastEndtPlateNo(param){
		try{
			new Ajax.Request(contextPath+"/GICLClaimsController",{
				parameters:{
					action: "validateLossDatePlateNo",
					lineCd: $F("txtLineCd"),
					sublineCd: $F("txtSublineCd"),
					polIssCd: $F("txtPolIssCd"),
					issueYy: $F("txtIssueYy"),
					polSeqNo: $F("txtPolSeqNo"),
					renewNo: $F("txtRenewNo"),
					plateNo: $F("txtPlateNumber"),
					itemNo: objCLM.basicInfo.itemNo,
					lossDate: $F("txtLossDate"),
					polEffDate: $F("txtInceptionDate"),
					expiryDate: $F("txtExpiryDate"),
					time: nvl($F("txtLossTime"),"") 
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)) {
						var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
						function chkLossDateAlert(){
							if ($F("txtLossDate") != "" && $F("txtLossTime") != "" && $F("txtPlateNumber") != "" && motorCarLineCode == $F("txtLineCd") && !objCLM.variables.checkLoss){
								if (nvl(res.checkLossDate,"N") != "N"){
									objCLM.variables.checkLastEndtPlateNo = true;
									showConfirmBox("Confirmation","Loss Date is not within the item's policy term. Which one do you want to change?","Loss Date","Plate Number",
												function(){
													$("txtLossDate").clear();
													$("txtLossDate").focus();
												},
												function(){
													if (nvl(res.plateSw,"N") == "N"){
														hideShowPlateMotorSerial(true);
														objCLM.basicInfo.itemNo = nvl(res.itemNo,"");
														$("txtPlateNumber").value 	= unescapeHTML2(res.plateNo);
														$("txtMotorNumber").value 	= unescapeHTML2(res.motorNo);
														$("txtSerialNumber").value 	= unescapeHTML2(res.serialNo);
													}else{
														$("oscmPlateNumber").show();
														$("txtPlateNumber").readOnly 	= false;
														showValidPlateNosLOV($F("txtLineCd"), $F("txtSublineCd"), $F("txtPolIssCd"), $F("txtIssueYy"), $F("txtPolSeqNo"), $F("txtRenewNo"), "GICLS010");
													}
												});
								}else{ 
									if (param == "postCheckLossDateTime"){
										postCheckLastEndtPlateNo();
									}else{	
										checkTotalLossSettlement(false);
									}
								}
							}else{
								if (param == "postCheckLossDateTime"){
									postCheckLastEndtPlateNo();
								}else{	
									checkTotalLossSettlement(false);
								}
							}
						}
						if (nvl(res.msgAlert,null) != null){
							$("txtPlateNumber").value = unescapeHTML2(nvl(res.plateNo,""));
							showWaitingMessageBox(res.msgAlert, "E", chkLossDateAlert);
							
							if (objCLM.basicInfo.totalTag == "Y" || Number(nvl(res.count,0)) == 1 || $("chkTotalLoss").checked == true){
								hideShowPlateMotorSerial(true);
							}
							
							$("oscmMotorNumber").hide();
							$("oscmSerialNumber").hide();
							$("txtMotorNumber").readOnly 	= true;
							$("txtSerialNumber").readOnly 	= true; 	
						}else{
							chkLossDateAlert();
						}
					}
				}
			});	
		}catch(e){
			showErrorMessage("checkLastEndtPlateNo", e);
		}
	}
	
	function validatePolIssueDate(param){
		try{
			objCLM.variables.sublineTime = getSublineTime($F("txtLineCd"), $F("txtSublineCd"));
			var issueDate = nvl(objCLM.variables.issueDate,null) != null ? new Date((objCLM.variables.issueDate).replace(/-/g,"/")) :"";
			var dspLossDate = $F("txtLossDate") != "" ? new Date(($F("txtLossDate").replace(/-/g,"/")+" "+nvl($F("txtLossTime"),nvl(objCLM.variables.sublineTime,""))).strip()) :"";
			if(issueDate > dspLossDate){
				if (nvl(valPolIssueDateFlag,"N") == "Y"){
					showWaitingMessageBox("Loss Date should not be earlier than policy issue date: "+objCLM.variables.issueDate,"E", function(){$("txtLossDate").clear(); $("txtLossDate").focus();});
					return false;
				}else if(nvl(valPolIssueDateFlag,"N") == "O"){
						if (objCLM.variables.issDateOverFlag == "N" && !validateUserFunc2("ID", "GICLS010")){ //added objCLM.variables.issDateOverFlag to determine if function is already been bypassed. adpascual 
							showConfirmBox("Confirmation","Loss Date should not be earlier than policy issue date: "+objCLM.variables.issueDate+". Do you want an override?",
									"Yes","No", 
									function(){
										objCLM.variables.override = "I"; 
										objAC.funcCode = "ID";
										objACGlobal.calledForm = "GICLS010";
										commonOverrideOkFunc = function(){
											$("txtLossDate").focus();
											objCLM.variables.issDateOverFlag = "Y";
											objCLM.variables.checkLoss = true;
											if (objCLM.variables.chkFlag){
												$("txtLossTime").focus();
											}
											if(param == "commit"){
												checkLossDateTime("commit"); 
										 	}else{
												checkLossDateTime(false);
										 	}
										};
										commonOverrideNotOkFunc = function(){
											showWaitingMessageBox($("overideUserName").value + " is not allowed to process claim with items for policy are tagged as total loss.", "E", 
													clearOverride);
											$("txtLossDate").focus();
											$("txtLossDate").clear();
											return false;
										};
										commonOverrideCancelFunc = function(){
											$("txtLossDate").focus();
											$("txtLossDate").clear();
											return false;
										};
										getUserInfo();
										$("overlayTitle").innerHTML = "Override User";
									}, "");
						}else{
						 	if(param == "commit"){
								checkLossDateTime("commit"); 
						 	}else{	
								if (!objCLM.variables.checkLastEndtPlateNo) checkLastEndtPlateNo();
						 	}	
						}						
				}else if (nvl(valPolIssueDateFlag,"N") == "M" && nvl(objCLM.variables.lossDateOrigTemp ,"") != $F("txtLossDate")){
					showWaitingMessageBox("Loss Date is earlier than policy issue date: "+objCLM.variables.issueDate,"E",function(){
						//$("txtLossDate").clear(); claims should still be able to proceed. - irwin 8.9.2012
						$("txtLossDate").blur();
						$("txtLossTime").focus();
						
						objCLM.variables.lossDateOrigTemp = $F("txtLossDate");
						}
					);
					
					return false;
				}else if (nvl(valPolIssueDateFlag,null) == null){
					showMessageBox("VALIDATE_POL_ISSUE_DATE does not exists in GIIS_PARAMETERS.","E");
					$("txtLossDate").clear();
					$("txtLossDate").focus();
					return false;
				}else{
					if (param == "lossDate"){
						checkLossDateTime(false);
					}else if(param == "commit"){
						checkLossDateTime("commit"); 
					}else{
						if (!objCLM.variables.checkLastEndtPlateNo) checkLastEndtPlateNo();
					}
				}
			}else{
				if (param == "lossDate"){
					checkLossDateTime(false); 
				}else if(param == "commit"){
					checkLossDateTime("commit"); 
				}else{
					if (!objCLM.variables.checkLastEndtPlateNo) checkLastEndtPlateNo();
				}
			}
		}catch(e){
			showErrorMessage("validatePolIssueDate", e);
		}
	}
	
	function conValidate(param){
		if (!validatePolIssueDate(param)){
			return false;
		} 
		$("txtLossDate").setAttribute("pre-text", $("txtLossDate").value);
	}

	function conCheckLossDateTime(param){
		var existItemOrPeril = nvl(objCLM.basicInfo.giclItemPerilExist, nvl(objCLM.basicInfo.giclClmItemExist, "N"));
		var resExist = nvl(objCLM.basicInfo.giclClmReserveExist, "N");
		if (nvl(objCLM.variables.oldDate,"") != "" && existItemOrPeril != "N" && resExist == "N"){
			if (objCLM.variables.oldDate != $F("txtLossDate")){
				showConfirmBox("Confirmation","Changing the Loss Date will delete Item and Peril records for this claim. Would you like to continue?","Yes","No",
						function(){
							objCLM.variables.clearItemPerilFunc = "Y";
							var proc = new Object(); 
							proc.name = "clearItemPerilFunc";
							objCLM.variables.procs.push(proc);
							if(param == false){
								checkLossDateTime("time");
							}else if(param == true){
								$("txtLossTime").value = "";
								$("txtLossTime").focus();
								conValidate();
							}else{
								$("txtLossTime").value = "";
								$("txtLossTime").focus();
								conValidate();
							}
						},function(){
							if(param == true){
								$("txtLossDate").value = objCLM.variables.oldDate;
								$("txtLossDate").focus();
							}else if(param == false){
								$("txtLossTime").value = objCLM.variables.oldTime;
								$("txtLossTime").focus();
							}else{
								$("txtLossDate").value = objCLM.variables.oldDate;
								$("txtLossDate").focus();
							}
							ok = false;
							return false;
						});
				if (!ok) return false;
			}else{
				if(param == false){
					checkLossDateTime("time");
				}else if(param == true){
					conValidate();
				}else{
					conValidate();
				}
			}
		}else{
			if(param == false){
				if (nvl(resExist,"Y") == "Y"){
					$("txtLossTime").value = objCLM.variables.oldTime;
					$("txtLossTime").focus();
					customShowMessageBox("Cannot update loss date, reserve has been set-up.", "E", "txtLossTime");
					$("txtLossDate").value = objCLM.variables.oldDate;
					$("txtLossDate").focus();
					ok = false;
					return false;
				}
				checkLossDateTime("time");
			}else if(param == true){
				conValidate();
			}else{
				conValidate();
			}
		}
	}
	
	observeBackSpaceOnDate("txtLossDate");
	initPreTextOnFieldWithIcon("hrefLossDate", "txtLossDate");
	$("txtLossDate").observe("blur", function(){
		var dspLossDate = $F("txtLossDate") != "" ? new Date(($F("txtLossDate").replace(/-/g,"/")+" "+nvl($F("txtLossTime"),nvl(objCLM.variables.sublineTime,""))).strip()) :"";
		var polEffDate = $F("txtInceptionDate") != "" ? new Date(($F("txtInceptionDate").replace(/-/g,"/")+" "+$F("txtInceptionTime")).strip()) :"";
		var expiryDate = $F("txtExpiryDate") != "" ? new Date(($F("txtExpiryDate").replace(/-/g,"/")+" "+$F("txtExpiryTime")).strip()) :"";
			
		if (nvl($F("txtLossDate"),"") != "" && checkIfValueChanged("txtLossDate") && $F("txtRenewNo") != ""){
			if(proShort == "Y" && ((dspLossDate < polEffDate) || (dspLossDate > expiryDate))){
				showWaitingMessageBox("Loss date not within the earned period date.", "E", 
					function (){
						clearObjectValues(objCLM.basicInfo);
						$("txtLineCd").value = "";
						populateBasicInfoPage(false);
						return false;	
					}
				);
			}else{
				objCLM.variables.accptFlag = "N";
				objCLM.variables.albadFlag = "N";
				setPreText("txtLossTime", "");
				if (nvl(objCLMGlobal.claimId,null) != null){
					if (!checkLossDateTime()) return false;
				}else{
					conValidate("lossDate");
				}
				changeTag = 1;
			}
		}
	});
	
	function showPlateMotorSerialLOV(param1, param2){
		var ok = true;
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getPolicyNoLOVGICLS010",
							param1: objCLM.variables.param1,
							param2: objCLM.variables.param2,
							page : 1},
			title: "Valid Policies",
			width: 637,
			height: 386,
			columnModel: [ {
								id: 'policyNo',
								title: 'Policy Number', 
								width: '200px'
						   },
						   {
								id: 'assdName',
								title: 'Assured', 
								width: '200px'
						   },
						   {
								id: 'inceptDate',
								title: 'Incept Date', 
								width: '100px'
						   },
						   {
								id: 'expiryDate',
								title: 'ExpiryDate', 
								width: '100px' 
						   },
						   {
								id: 'lineCd',
								title: "",
								width: '0px',
								visible: false
						   },
						   {
								id: 'sublineCd',
								title: "",
								width: '0px',
								visible: false
						   },
						   {
								id: 'polIssCd',
								title: "",
								width: '0px',
								visible: false
						   },
						   {
								id: 'issueYy',
								title: "",
								width: '0px',
								visible: false
						   },
						   {
								id: 'polSeqNo',
								title: "",
								width: '0px',
								visible: false
						   },
						   {
								id: 'renewNo',
								title: "",
								width: '0px',
								visible: false
						   },
						   {
								id: 'plateNo',
								title: "",
								width: '0px',
								visible: false
						   },
						   {
								id: 'motorNo',
								title: "",
								width: '0px',
								visible: false
						   },
						   {
								id: 'serialNo',
								title: "",
								width: '0px',
								visible: false
						   } 
			             ],
			draggable: true,
	  		onSelect: function(row){
	  			$("txtLineCd").value   		= row.lineCd;
  				$("txtSublineCd").value   	= row.sublineCd;
  				$("txtPolIssCd").value   	= row.polIssCd;
  				$("txtIssueYy").value   	= row.issueYy;
  				$("txtPolSeqNo").value   	= row.polSeqNo;
  				$("txtRenewNo").value   	= row.renewNo;
				$("txtPlateNumber").value   = unescapeHTML2(row.plateNo);
				$("txtMotorNumber").value  	= unescapeHTML2(row.motorNo);
				$("txtSerialNumber").value  = unescapeHTML2(row.serialNo);
				
				objCLM.variables.fromPlateSw2 = "Y";
				objCLM.variables.prevRenewNo = "";
				fireEvent($("txtRenewNo"), "blur");
				if (objCLM.variables.param1 == "MOTOR_NO") $("txtMotorNumber").focus();
				if (objCLM.variables.param1 == "SERIAL_NO") $("txtSerialNumber").focus();
				validateClmPolicyNo(); //adpascual 05.24.2013
	  		},
	  		onCancel: function(){
	  			if (objCLM.variables.param1 == "PLATE_NO") $("txtPlateNumber").focus();
				if (objCLM.variables.param1 == "MOTOR_NO") $("txtMotorNumber").focus();
				if (objCLM.variables.param1 == "SERIAL_NO") $("txtSerialNumber").focus();
	  		}
		});
		return false;
	}
	
	function validatePlateMotorSerial(param){
		try{
			new Ajax.Request(contextPath+"/GICLClaimsController",{
				parameters:{
					action: 	"validatePlateMotorSerialNo",
					param1:		objCLM.variables.param1,
					lineCd: 	$F("txtLineCd"),
					sublineCd: 	$F("txtSublineCd"),
					polIssCd: 	$F("txtPolIssCd"), 
					issueYy: 	$F("txtIssueYy"),
					polSeqNo: 	$F("txtPolSeqNo"),
					renewNo: 	$F("txtRenewNo"),
					lossDate: 	setDfltSec(objCLM.basicInfo.strLossDate),
					itemNo:		objCLM.basicInfo.itemNo,
					plateNo: 	$F("txtPlateNumber"),
					motorNo:	$F("txtMotorNumber"),
					serialNo:	$F("txtSerialNumber"),
					validatePol: nvl(objCLM.variables.fromPlateSw2,"N") == "Y" ? "N" : "Y"
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: showNotice("Validating, please wait..."),
				onComplete: function(response){
					objCLM.variables.fromPlateSw2 = "N";
					hideNotice();
					if(checkErrorOnResponse(response)) {
						objCLM.variables.validClaim = true;
						var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
						if (nvl(res.msgAlert,null) != null){
							showWaitingMessageBox(res.msgAlert, "E", function(){
								$("txtAssuredName").value = nvl(getPreTextValue("txtAssuredName"),$F("txtAssuredName"));
								if (objCLM.variables.param1 == "PLATE_NO") {$("txtPlateNumber").value = unescapeHTML2(getPreTextValue("txtPlateNumber")); $("txtPlateNumber").focus();} 
								if (objCLM.variables.param1 == "MOTOR_NO") {$("txtMotorNumber").value = unescapeHTML2(getPreTextValue("txtMotorNumber")); $("txtMotorNumber").focus();} 
								if (objCLM.variables.param1 == "SERIAL_NO") {$("txtSerialNumber").value = unescapeHTML2(getPreTextValue("txtSerialNumber")); $("txtSerialNumber").focus();} 
							});
							return false;
						}
						if (nvl(res.msgAlert2,null) != null){
							showWaitingMessageBox(res.msgAlert2, "I", function(){
								if (nvl(res.msgAlert3,null) != null){
									showWaitingMessageBox(res.msgAlert3, "I", function(){
										if (nvl(param,"") == "valOnly"){
											$("txtLossDate").focus();
										}else{	
											conCreateClm(res);
										}
									});
								}else{
									if (nvl(param,"") == "valOnly"){
										$("txtLossDate").focus();
									}else{	
										conCreateClm(res);
									}
								}
							});
						}else{
							if (nvl(res.msgAlert3,null) != null){
								showWaitingMessageBox(res.msgAlert3, "I", function(){
									if (nvl(param,"") == "valOnly"){
										$("txtLossDate").focus();
									}else{	
										conCreateClm(res);
									}
								});
							}else{
								if (nvl(param,"") == "valOnly"){
									$("txtLossDate").focus();
								}else{	
									conCreateClm(res);
								}
							}	
						}
					}else{
						objCLM.variables.validClaim = false;
						return false;
					}
				}
			});
		}catch(e){
			showErrorMessage("validatePlateMotorSerial", e);
		}
	}
	
	//Plate Number BLUR event
	initPreTextOnField("txtPlateNumber");
	$("txtPlateNumber").observe("blur", function(){
		if (/*nvl(objCLM.basicInfo.plateSw,"N") == "N" &&*/ $F("txtPlateNumber") != "" && checkIfValueChanged("txtPlateNumber")){
			objCLM.variables.claimChecked = false;
			objCLM.variables.checkLastEndtPlateNo = false;
			objCLM.variables.param1 = "PLATE_NO";
			objCLM.variables.param2 = $F("txtPlateNumber");
			if (objCLM.variables.fromPlateSw2 == "Y" || objCLM.basicInfo.plateSw == "Y" || $F("txtRenewNo") != ""){
				validatePlateMotorSerial("valOnly");
				return false;
			}	
			validatePlateMotorSerial();
		}else{
			if ($F("txtPlateNumber") == ""){
				$("txtLossDate").focus();
			}else{	
				validatePlateMotorSerial("valOnly");
			}
		}
	});
	
	//Motor Number BLUR event
	initPreTextOnField("txtMotorNumber");
	$("txtMotorNumber").observe("blur", function(){
		if (/*nvl(objCLM.basicInfo.plateSw,"N") == "N" &&*/ $F("txtMotorNumber") != "" && checkIfValueChanged("txtMotorNumber")){
			objCLM.variables.claimChecked = false;
			objCLM.variables.checkLastEndtPlateNo = false;
			objCLM.variables.param1 = "MOTOR_NO";
			objCLM.variables.param2 = $F("txtMotorNumber");
			if (objCLM.variables.fromPlateSw2 == "Y" || objCLM.basicInfo.plateSw == "Y" || $F("txtRenewNo") != ""){
				validatePlateMotorSerial("valOnly");
				return false;
			}	
			validatePlateMotorSerial();
		}else{
			if ($F("txtMotorNumber") == ""){
				$("txtLossDate").focus();
			}else{	
				validatePlateMotorSerial("valOnly");
			}
		}
	});
	
	//Serial Number BLUR event
	initPreTextOnField("txtSerialNumber");
	$("txtSerialNumber").observe("blur", function(){
		if (/*nvl(objCLM.basicInfo.plateSw,"N") == "N" &&*/ $F("txtSerialNumber") != "" && checkIfValueChanged("txtSerialNumber")){
			objCLM.variables.claimChecked = false;
			objCLM.variables.checkLastEndtPlateNo = false;
			objCLM.variables.param1 = "SERIAL_NO";
			objCLM.variables.param2 = $F("txtSerialNumber");
			if (objCLM.variables.fromPlateSw2 == "Y" || objCLM.basicInfo.plateSw == "Y" || $F("txtRenewNo") != ""){
				validatePlateMotorSerial("valOnly");
				return false;
			}	
			validatePlateMotorSerial();
		}else{
			if ($F("txtSerialNumber") == ""){
				$("txtLossDate").focus();
			}else{	
				validatePlateMotorSerial("valOnly");
			}
		}
	});
	
	//Assured Name LOV CLICK event
	/*$("oscmClmAssured").observe("click", function () {
		if ($("oscmClmAssured").disabled != true){
			//setLovDtls("clmAssuredLov", "Assured No.", "Assured Name", "List of Assured");
			//showClaimLOV();
			showClmAssuredLOV($F("txtLineCd"), $F("txtSublineCd"), $F("txtPolIssCd"), $F("txtIssueYy"), $F("txtRenewNo"),"GICLS010");
		} 
	});*/
	
	//Claim Processor LOV CLICK event
	$("oscmClmProcessor").observe("click", function () {
		if ($("oscmClmProcessor").disabled != true){
			/*setLovDtls("clmProcessorLov", "ID", "Name", "Claim Processor");
			showClaimLOV();*/
			showUserListLOV($F("txtLineCd"), $F("txtPolIssCd"), "GICLS010");
		}
	});
	
	function getDfltClmProcessor(){
		objCLM.basicInfo.inHouseAdjustment = currUser;
		objCLM.basicInfo.dspInHouAdjName = currUserName;
		$("txtInHouseAdjustment").value = currUser;
		$("txtClmProcessor").value = currUserName;
		enableMenu("clmMainBasicInformation");
		enableMenu("clmBasicInformation");
		enableMenus('Y');
	}
	
	//Claim Processor FOCUS event
	$("txtClmProcessor").observe("focus", function(){
		objCLMGlobal.inHouseAdjustment = objCLM.basicInfo.inHouseAdjustment;
	});	
	
	//Claim Processor BLUR event
	$("txtClmProcessor").observe("blur", function(){
		if ($F("txtClmProcessor") == ""){
			getDfltClmProcessor();
		}
		if (objCLM.basicInfo.inHouseAdjustment != currUser){
			showConfirmBox("Confirmation","If you reassign this claim, you can no longer do any transaction to this claim. Do you want to reassign this claim?",
							"Yes", "No",
							function(){  
								disableMenu("clmLossRecovery");
								disableMenu("clmMainBasicInformation");
								disableMenu("clmItemInformation");
								disableMenu("clmReserveSetup");
								disableMenu("clmLossExpenseHist");
								disableMenu("clmGenAdvice");
								disableMenu("clmReports");
							}, getDfltClmProcessor);
		}else if(objCLM.basicInfo.inHouseAdjustment == currUser/* && objCLMGlobal.inHouseAdjustment != currUser*/){
			enableMenu("clmMainBasicInformation");
			enableMenu("clmBasicInformation");
			disableMenu("clmRequiredDocs");
			disableMenu("clmLossRecovery");
			disableMenu("clmItemInformation");
			disableMenu("clmReserveSetup");
			disableMenu("clmLossExpenseHist");
			disableMenu("clmGenAdvice");
			disableMenu("clmReports");
		}
		$("txtDateFiled").focus();
	});
	
	function validateDateFiled(){
		if ($F("txtDateFiled") != ""){
			setPreText("txtDateFiled", $F("txtDateFiled"));
			var dspLossDate = $F("txtLossDate") != "" ? new Date($F("txtLossDate").replace(/-/g,"/")) :"";
			var dateFiled = $F("txtDateFiled") != "" ? new Date($F("txtDateFiled").replace(/-/g,"/")) :"";
			var sysdate = new Date();
			if (dateFiled < dspLossDate){
				customShowMessageBox("A claim application can not be filed earlier than its loss date.", "E", "txtDateFiled");
				//$("txtDateFiled").clear();
				return false;
			}
			if (dateFiled > sysdate){
				customShowMessageBox("Filing date can not be later than the current date.", "E", "txtDateFiled");
				//$("txtDateFiled").clear();
				return false;
			}
		}	
		return true;
	}	
	
	//Date Filed BLUR event
	observeBackSpaceOnDate("txtDateFiled");
	initPreTextOnFieldWithIcon("hrefDateFiled", "txtDateFiled");
	$("txtDateFiled").observe("blur", function(){
		if (!checkIfValueChanged("txtDateFiled"))return;
		changeTag=1;//added by steven 2.6.2013
		if (validateDateFiled()) $("chkLossRecovery").focus();
	});
	
	//Catastrophic LOV CLICK event
	//observeBackSpaceOnDate("txtCat");
	deleteOnBackSpace("txtCatCd","txtCat","oscmCat");
	initPreTextOnFieldWithIcon("oscmCat", "txtCat");
	$("oscmCat").observe("click", function () {
		if ($("oscmCat").disabled != true){
			/*setLovDtls("clmCatLov", "CAT Code", "Catastrophic Desc", "Catastrophic Event");
			showClaimLOV();*/
			showAllCatastrophicLOV("GICLS010"); 
		}
	});
	
	//Catastrophic BLUR event
	$("txtCat").observe("blur", function(){
		if ($F("txtCat") != "" && checkIfValueChanged("txtCat") && nvl(objCLMGlobal.claimId,null) != null){
			new Ajax.Request(contextPath+"/GICLClaimsController",{
				parameters: {
					action: 	"validateCatastrophicCode",
					lineCd:		$F("txtClmLineCd"),
					sublineCd:	$F("txtClmSublineCd"),	
					issCd:		$F("txtClmIssCd"),
					clmYy:		Number($F("txtClmYy")),
					clmSeqNo:	Number($F("txtClmSeqNo")),
					claimId:	objCLMGlobal.claimId,
					catCd:		objCLM.basicInfo.catastrophicCode	
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)) {
						var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
						if (nvl(res.msgAlert,null) != null){
							showConfirmBox("Confirmation",res.msgAlert,"Ok","Cancel","",
									function(){
										objCLM.basicInfo.catastrophicCode = res.catCd;
										objCLM.basicInfo.dspCatDesc = res.catDesc;
										$("txtCatCd").value = unescapeHTML2(res.catCd);
										$("txtCat").value = unescapeHTML2(res.catDesc); 
										$("txtCat").focus();
									});
						}
						setPreText("txtCat", $F("txtCat"));
						setPreText("txtCatCd", $F("txtCatCd"));
					}	
				}
			});
		}
		
		if ($F("txtCat") == ""){
			objCLM.basicInfo.catastrophicCode = null;
			objCLM.basicInfo.dspCatDesc = null;
			$("txtCatCd").value = "";
		}
	});
	
	//create an observe func for Province
	function observeProvince(){
		try{
			//Province LOV CLICK event
			observeBackSpaceOnDate("txtProvince", function(){ //marco - 10.09.2014 - added onChangeFunc
				changeTag = 1;
				objCLM.basicInfo.cityCode		= null;
				objCLM.basicInfo.dspCityDesc	= null;
				objCLM.basicInfo.districtNumber	= null;
				objCLM.basicInfo.blockId		= null;
				objCLM.basicInfo.blockNo		= null;
				objCLM.basicInfo.locationCode	= null;
				objCLM.basicInfo.provinceCode = null;
				objCLM.basicInfo.dspProvinceDesc = null;
				if ($("txtCity")) $("txtCity").value = "";
				if ($("txtDistrictNo")) $("txtDistrictNo").value = "";
				if ($("txtBlockNo")) $("txtBlockNo").value = "";
				if ($("txtLocation")) $("txtLocation").value = "";
				setPreText("txtProvince", $F("txtProvince"));
			});
			initPreTextOnFieldWithIcon("oscmProvince", "txtProvince");
			$("oscmProvince").observe("click", function () {
				if ($("oscmProvince").disabled != true){
					/*setLovDtls("clmProvinceLov", "Province Code", "Province Description", "List of Province");
					showClaimLOV();*/
					showAllProvinceLOV("GICLS010");
				}
			});
			
			//Province BLUR event
			$("txtProvince").observe("blur", function () {
				if (nvl(ora2010Sw,"N") == "Y"){
					if (checkIfValueChanged("txtProvince")){
						objCLM.basicInfo.cityCode		= null;
						objCLM.basicInfo.dspCityDesc	= null;
						objCLM.basicInfo.districtNumber	= null;
						objCLM.basicInfo.blockId		= null;
						objCLM.basicInfo.blockNo		= null;
						objCLM.basicInfo.locationCode	= null;
						if ($("txtCity")) $("txtCity").value = "";
						if ($("txtDistrictNo")) $("txtDistrictNo").value = "";
						if ($("txtBlockNo")) $("txtBlockNo").value = "";
						if ($("txtLocation")) $("txtLocation").value = "";
					}
					$("txtCity").focus();
					setPreText("txtProvince", $F("txtProvince"));
				}
				
				if ($F("txtProvince") == ""){
					objCLM.basicInfo.provinceCode = null;
					objCLM.basicInfo.dspProvinceDesc = null;
		 		}
			});
		}catch(e){
			showErrorMessage("observeProvince", e);
		}
	}	
	
	function observeCity(){
		try{
			//City LOV CLICK event
			observeBackSpaceOnDate("txtCity", function(){ //marco - 10.09.2014 - added onChangeFunc
				changeTag = 1;
				objCLM.basicInfo.districtNumber	= null;
				objCLM.basicInfo.blockId		= null;
				objCLM.basicInfo.blockNo		= null;
				objCLM.basicInfo.locationCode	= null;
				if ($("txtDistrictNo")) $("txtDistrictNo").value = "";
				if ($("txtBlockNo")) $("txtBlockNo").value = "";
				if ($("txtLocation")) $("txtLocation").value = "";
				setPreText("txtCity", $F("txtCity"));
				objCLM.basicInfo.cityCode = null;
				objCLM.basicInfo.dspCityDesc = null;
			});
			initPreTextOnFieldWithIcon("oscmCity", "txtCity");
			$("oscmCity").observe("click", function () {
				if ($("oscmCity").disabled != true){
					/*setLovDtls("clmCityLov", "City Code", "City Description", "List of City");
					showClaimLOV();*/
					showCityDtlLOV(nvl(objCLM.basicInfo.provinceCode,""), "GICLS010");
				}
			});
			
			//City BLUR event
			$("txtCity").observe("blur", function () {
				if (nvl(ora2010Sw,"N") == "Y"){
					if (checkIfValueChanged("txtCity")){
						objCLM.basicInfo.districtNumber	= null;
						objCLM.basicInfo.blockId		= null;
						objCLM.basicInfo.blockNo		= null;
						objCLM.basicInfo.locationCode	= null;
						if ($("txtDistrictNo")) $("txtDistrictNo").value = "";
						if ($("txtBlockNo")) $("txtBlockNo").value = "";
						if ($("txtLocation")) $("txtLocation").value = "";
					}
				}
				if ($("txtLocation")) $("txtDistrictNo").focus();
				if ($("txtDistrictNo")) $("txtDistrictNo").focus();
				setPreText("txtCity", $F("txtCity"));
				
				if ($F("txtCity") == ""){
					objCLM.basicInfo.cityCode = null;
					objCLM.basicInfo.dspCityDesc = null;
		 		}
			});	
		}catch(e){
			showErrorMessage("observeCity", e);
		}
	}
	
	function observeDistrictBlock(){
		try{
			if ($("oscmDistrict")){
				//District LOV CLICK event
				observeBackSpaceOnDate("txtDistrictNo", function(){ //marco - 10.09.2014 - added onChangeFunc
					changeTag = 1;
				});
				initPreTextOnFieldWithIcon("oscmDistrict", "txtDistrictNo");
				$("oscmDistrict").observe("click", function(){
					if ($("oscmDistrict").disabled != true){
						/*setLovDtls("clmDistrictLov", "District No.", "District Description", "List of District");
						showClaimLOV();*/
						showDistrictDtlLOV(nvl(objCLM.basicInfo.provinceCode,""), nvl(objCLM.basicInfo.cityCode,""), "GICLS010");
					}
				});
				
				//District BLUR event
				$("txtDistrictNo").observe("blur", function () {
					if (checkIfValueChanged("txtDistrictNo")){
						objCLM.basicInfo.blockId = null;
						objCLM.basicInfo.blockNo = null;
						objCLM.basicInfo.locationCode = null;
						if ($("oscmBlock")) $("txtBlockNo").value = ""; 
						if ($("txtLocation")) $("txtLocation").value = "";
					}
					if ($("oscmBlock")) $("txtBlockNo").focus();
					setPreText("txtDistrictNo", $F("txtDistrictNo"));
					
					if ($F("txtDistrictNo") == ""){
						objCLM.basicInfo.districtNumber = null;
			 		}
				});	
			}
			
			if ($("oscmBlock")){
				//Block LOV CLICK event
				observeBackSpaceOnDate("txtBlockNo", function(){ //marco - 10.09.2014 - added onChangeFunc
					changeTag = 1;
					objCLM.basicInfo.blockNo = null;
				});
				$("oscmBlock").observe("click", function () {
					if ($("oscmBlock").disabled != true){
						/*setLovDtls("clmBlockLov", "Block No.", "Block Description", "List of Block");
						showClaimLOV();*/
						showBlockDtlLOV(nvl(objCLM.basicInfo.provinceCode,""), nvl(objCLM.basicInfo.cityCode,""), nvl(objCLM.basicInfo.districtNumber,""),"GICLS010");
					}
				});
				
				//Block BLUR event
				$("oscmBlock").observe("blur", function () {
					if ($F("txtBlockNo") == ""){
						objCLM.basicInfo.blockNo = null;
			 		}
				});
			}
		}catch(e){
			showErrorMessage("observeDistrictBlock", e);
		}
	}
	
	function observeLocation(){
		try{
			//Location LOV CLICK event
			observeBackSpaceOnDate("txtLocation");
			initPreTextOnFieldWithIcon("oscmLocation", "txtLocation");
			$("oscmLocation").observe("click", function () {
				if ($("oscmLocation").disabled != true){
					showLocationLOV(nvl(objCLM.basicInfo.locationCode,""),nvl(objCLM.basicInfo.locationDesc,""), "GICLS010");
				}
			});
			
			//Location BLUR event
			$("txtLocation").observe("blur", function () {
				if (nvl(ora2010Sw,"N") == "Y"){
					if (checkIfValueChanged("txtLocation")){
						objCLM.basicInfo.districtNumber	= null;
						objCLM.basicInfo.blockId		= null;
						objCLM.basicInfo.blockNo		= null;
						if ($("txtDistrictNo")) $("txtDistrictNo").value = "";
						if ($("txtBlockNo")) $("txtBlockNo").value = "";
					}
				}
				if ($("txtDistrictNo")) $("txtDistrictNo").focus();
				setPreText("txtLocation", $F("txtLocation"));
				
				if ($F("txtLocation") == ""){
					objCLM.basicInfo.locationCode = null;
					objCLM.basicInfo.locationDesc = null;
		 		}
			});	
		}catch(e){
			showErrorMessage("observeLocation", e);
		}
	}
	observeProvince();
	observeCity();
	observeDistrictBlock();
	observeLocation();
	
	$("txtLineCd").observe("blur", function(){
		if (nvl(objCLMGlobal.claimId,null) != null) return;
		if (nvl(ora2010Sw,"N") == "Y"){
			/* Emsy 4.20.2012 ~ commented this;
			if ($F("txtLineCd") == "FI" || $F("txtLineCd") == "CA"){
				$("provTD").innerHTML = '<div style="border: 1px solid gray; width: 135px; height: 21px; float: left;">'+
											'<input style="width: 110px; border: none; float: left;" id="txtProvince" name="txtProvince" type="text" value="" readOnly="readonly" />'+  
											'<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmProvince" name="oscmProvince" alt="Go" />'+	
										'</div>'+
										'<label class="rightAligned" style="margin-right: 4px; margin-top: 5px; float: left; width: 41px;"">City</label>'+
										'<div style="border: 1px solid gray; width: 124px; height: 21px; float: left;">'+
											'<input type="hidden" id="txtCityCd" />'+
											'<input type="hidden" id="txtlocationDesc" />'+
											'<input type="hidden" id="txtlocationCd" />'+
											'<input style="width: 99px; border: none; float: left;" id="txtCity" name="txtCity" type="text" value="" readOnly="readonly" />'+  
											'<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmCity" name="oscmCity" alt="Go" />'+	
										'</div>';
									
				if ($F("txtLineCd") == "FI"){
					$("districtLblTD").innerHTML = "District";
					$("districtTD").innerHTML = '<div style="border: 1px solid gray; width: 135px; height: 21px; float: left;">'+
													'<input style="width: 110px; border: none; float: left;" id="txtDistrictNo" name="txtDistrictNo" type="text" value="" readOnly="readonly" />'+  
													'<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmDistrict" name="oscmDistrict" alt="Go" />'+	
												'</div>'+
												'<label class="rightAligned" style="margin: 5px; float: left; width: 35px;">Block</label>'+
												'<div style="border: 1px solid gray; width: 124px; height: 21px; float: left;">'+
													'<input style="width: 99px; border: none; float: left;" id="txtBlockNo" name="txtBlockNo" type="text" value="" readOnly="readonly" />'+
													'<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmBlock" name="oscmBlock" alt="Go" />'+	
												'</div>';
					//observe LOV for District & Block							
					observeDistrictBlock();	
				}else if ($F("txtLineCd") == "CA"){
					$("districtLblTD").innerHTML = "Location";
					$("districtTD").innerHTML = '<input id="txtLocation" name="txtLocation" type="text" style="width: 300px;" value="" />'+
												'<input id="txtDistrictNo" type="hidden" />'+  
												'<input type="hidden" id="txtBlockNo" />'+
												'<input type="hidden" id="txtlocationDesc" />'+
												'<input type="hidden" id="txtlocationCd" />';
				}
			}else{ //line code not equal to FI & CA
				$("provTD").innerHTML = '<div style="border: 1px solid gray; width: 306px; height: 21px; float: left;">'+
											'<input style="width: 281px; border: none; float: left;" id="txtProvince" name="txtProvince" type="text" value="" readOnly="readonly" />'+  
											'<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmProvince" name="oscmProvince" alt="Go" />'+	
										'</div>';
				$("districtLblTD").innerHTML = "City";
				$("districtTD").innerHTML = '<div style="border: 1px solid gray; width: 306px; height: 21px; float: left;">'+							
												'<input type="hidden" id="txtCityCd" />'+
												'<input type="hidden" id="txtDistrictNo" />'+
												'<input type="hidden" id="txtBlockNo" />'+
												'<input type="hidden" id="txtlocationDesc" />'+
												'<input type="hidden" id="txtlocationCd" />'+
												'<input style="width: 281px; border: none; float: left;" id="txtCity" name="txtCity" type="text" value=""  readOnly="readonly" />'+ 
												'<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmCity" name="oscmCity" alt="Go" />'+
											'</div>';
			} */
		}else{ //ora2010Sw not equal to Y
			/* $("provTD").innerHTML = '<div style="border: 1px solid gray; width: 306px; height: 21px; float: left;">'+
										'<input style="width: 281px; border: none; float: left;" id="txtProvince" name="txtProvince" type="text" value="" readOnly="readonly" />'+  
										'<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmProvince" name="oscmProvince" alt="Go" />'+	
									'</div>';
			$("districtLblTD").innerHTML = "City";		
			$("districtTD").innerHTML = '<div style="border: 1px solid gray; width: 306px; height: 21px; float: left;">'+							
											'<input type="hidden" id="txtCityCd" />'+
											'<input type="hidden" id="txtDistrictNo" />'+
											'<input type="hidden" id="txtBlockNo" />'+
											'<input type="hidden" id="txtlocationDesc" />'+
											'<input type="hidden" id="txtlocationCd" />'+								
											'<input style="width: 281px; border: none; float: left;" id="txtCity" name="txtCity" type="text" value=""  readOnly="readonly" />'+ 
											'<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmCity" name="oscmCity" alt="Go" />'+
										'</div>'; */
		}
		
		//City LOV new Observe						
		//observeCity();	
		
		//Province new observe
		//observeProvince();
		
		//refresh object
		objCLM.basicInfo.provinceCode 	= null;
		objCLM.basicInfo.dspProvinceDesc = null;
		objCLM.basicInfo.cityCode		= null;
		objCLM.basicInfo.dspCityDesc	= null;
		objCLM.basicInfo.districtNumber	= null;
		objCLM.basicInfo.blockId		= null;
		objCLM.basicInfo.blockNo		= null;
		objCLM.basicInfo.locationCode	= null;
		
	});
	
	//Remarks editor
	$("editTxtRemarks").observe("click", function () {
		showEditor("txtRemarks", 4000);
	});
	
	//Loss Details editor
	$("editTxtLossDtls").observe("click", function () {
		showEditor("txtLossDtls", 500);
	});
	
	//Claim Status LOV CLICK event
	//observeBackSpaceOnDate("txtClmStat");
	deleteOnBackSpace("txtClmStatCd","txtClmStat","oscmClmStat");
	objCLM.variables.prevClmStatCd = nvl(objCLM.basicInfo.claimStatusCd,"");
	objCLM.variables.prevClmStatdesc = nvl(objCLM.basicInfo.clmStatDesc,"");
	$("oscmClmStat").observe("click", function () {
		if ($("oscmClmStat").disabled != true){
			/*setLovDtls("clmStatLov", "Code", "Description", "Claim Status");
			showClaimLOV();*/
			objCLM.variables.prevClmStatCd = nvl(objCLM.basicInfo.claimStatusCd,"");
			objCLM.variables.prevClmStatdesc = nvl(objCLM.basicInfo.clmStatDesc,"");
			showClmStatOV("GICLS010");
		}
	});
	
	//Claim Status FOCUS event
	$("txtClmStat").observe("focus", function () {
		if ($("oscmClmStat").getStyle('display') == "none"){
			$("txtClmStat").value = nvl(objCLM.variables.prevClmStatdesc,$F("txtClmStat"));
			$("txtClmStat").blur();
		}
	});
	
	//Claim Status BLUR event
	$("txtClmStat").observe("blur", function () {
		if (nvl(objCLM.variables.prevClmStatdesc,"") == nvl(objCLM.basicInfo.clmStatDesc,"")) return;
		var clmStat = false;
		if (objCLM.basicInfo.claimStatusCd == "NO" || 
				objCLM.basicInfo.claimStatusCd == "FN" || 
				objCLM.basicInfo.claimStatusCd == "CD" || 
				objCLM.basicInfo.claimStatusCd == "WD" || 
				objCLM.basicInfo.claimStatusCd == "CC" || 
				objCLM.basicInfo.claimStatusCd == "DN" || 
				objCLM.basicInfo.claimStatusCd == "OP"){
			clmStat = true;
		}
		if (nvl(objCLMGlobal.claimId,null) != null && !clmStat){
			null;
		}else if (objCLM.variables.skip != "Y" && $F("txtClmStat") != ""){
			showWaitingMessageBox($F("txtClmStat")+" is a system status. User is not allowed to use this status.", "I", 
					function(){
						objCLM.basicInfo.claimStatusCd = objCLM.variables.prevClmStatCd;
						objCLM.basicInfo.clmStatDesc = objCLM.variables.prevClmStatdesc;
						$("txtClmStatCd").value = objCLM.variables.prevClmStatCd;
						$("txtClmStat").value = objCLM.variables.prevClmStatdesc;
						$("txtClmStat").focus();
					});
		}
		objCLM.variables.skip = 'N';
 		//$("chkLossRecovery").focus(); removed as per mam april 
 		
 		if ($F("txtClmStat") == ""){
 			objCLM.variables.prevClmStatCd = "";
 			objCLM.variables.prevClmStatdesc = "";
 			objCLM.basicInfo.claimStatusCd = null;
 			objCLM.basicInfo.clmStatDesc = null;
 			$("txtClmStatCd").value = objCLM.variables.prevClmStatCd;
 		}
	});
	
	//Loss Description LOV CLICK event
	//observeBackSpaceOnDate("txtLossDesc");
	deleteOnBackSpace("txtLossCatCd","txtLossDesc","oscmLossDesc");
	$("oscmLossDesc").observe("click", function () {
		if ($("oscmLossDesc").disabled != true){
			/*setLovDtls("clmLossCatLov", "Code", "Description", "Loss Category");
			showClaimLOV();*/
			showLossCatLOV($F("txtLineCd"), "GICLS010");
		}
	});
	
	//Loss Description BLUR event
	$("txtLossDesc").observe("blur", function () {
		if ($F("txtLossDesc") == ""){
			objCLM.basicInfo.lossCatCd = null;
			objCLM.basicInfo.dspLossCatDesc = null;
		}
	});
	
	function conOkProcessing(param){
		if ($("chkOkProcessing").checked == false){
			$("chkOkProcessing").checked = true;
		}else{
			$("oscmClmStat").show();
			if (param == "chkOkProcessing"){
				objCLM.variables.fromOnPopulate = 2;
				getUnpaidPremiums(); //walang parameter para onSuccess ni function ay tawagin si conOkProcessing() para lang makabalik lol
				objCLM.variables.fromOnPopulate = 1;
			}
			//para pag galing sya kay getUnpaidPremiums i-set nalang sa 1
			objCLM.variables.fromOnPopulate = 1;
		}
		if ($F("txtLineCd") == lineCodeSU){
			objCLM.variables.insClmItemAndItemPeril = "Y";
			var proc = new Object(); 
			proc.name = "insClmItemAndItemPeril";
			objCLM.variables.procs.push(proc);
		}
		if ($("chkOkProcessing").checked == true && objCLM.variables.mortgFlag == 'TRUE'){
			objCLM.variables.insertClaimMortgagee = "Y";
			var proc = new Object(); 
			proc.name = "insertClaimMortgagee";
			objCLM.variables.procs.push(proc);
		}
	}
	
	//Ok for Processing checkbox CHANGE event
	$("chkOkProcessing").observe("change", function () {
		
		if(mandatoryClaimDocs == "Y"){
			new Ajax.Request(contextPath+"/GICLReqdDocsController",{
				parameters: {
					action: "validateClmReqDocs",
					claimId: nvl(objCLMGlobal.claimId,"")
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)) {
						var msg = response.responseText;
						if (nvl(msg,"") != ""){
							$("chkOkProcessing").checked = false;
							customShowMessageBox(msg, "E", "chkOkProcessing");
							objCLM.variables.validClaim = false;
							return false;
						}else{
							conOkProcessing("chkOkProcessing");
						}
					}
				}
			});
		}else if(mandatoryClaimDocs == "O"){
			var ok = true;
			if(objCLM.variables.overFlag == "N"){
				if (!validateUserFunc2("MD", "GICLS010")){
					if(hasDocs != "Y" || hasCompletedDates != "Y"){
					
						showConfirmBox("Confirmation","Required documents are not yet completed. Would you like to override?","Yes","No",
								function(){
									objAC.funcCode = "MD";
									objACGlobal.calledForm = "GICLS010";
									commonOverrideOkFunc = function(){
										objCLM.variables.validClaim = true;
										objCLM.variables.fromOnPopulate = 2;
										getUnpaidPremiums("chkOkProcessing");
										objCLM.variables.fromOnPopulate = 1;
									};
									commonOverrideNotOkFunc = function(){
										showWaitingMessageBox($("overideUserName").value + " is not allowed to Override.", "E",
												clearOverride);
										$("chkOkProcessing").checked = false;
										objCLM.variables.validClaim = false;
										ok = false;
										return false;
									};
									commonOverrideCancelFunc = function(){
										$("chkOkProcessing").checked = false;
										objCLM.variables.validClaim = false;
										ok = false;
										return false;
									};
									getUserInfo();
									$("overlayTitle").innerHTML = "Override User";
								},
								function(){
									$("chkOkProcessing").checked = false;
									$("txtLossDesc").focus();
									ok = false;
								});
						if (!ok) return false;
					}else{
						
						/* objCLM.variables.validClaim = true;
						objCLM.variables.fromOnPopulate = 2;
						getUnpaidPremiums("chkOkProcessing");
						objCLM.variables.fromOnPopulate = 1; */
						
						conOkProcessing("chkOkProcessing");
					}
					
				}else{
					conOkProcessing("chkOkProcessing"); // added 7.6.2012 - irwin
				}
			}
		}else{
			conOkProcessing("chkOkProcessing");
		}
		//$("txtDateFiled").focus(); // ito ang cause ng minsang need mag double click ng save button save
	});
	
	function getCheckLocationDtl(){
		try{
			var res = "";
			new Ajax.Request(contextPath+"/GICLClaimsController",{
				parameters: {
					action: "getCheckLocationDtl",
					claimId: objCLMGlobal.claimId,
					location: escapeHTML2($F("txtLocOfLoss1"))
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)) {
						res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
					}
				}
			});
			return res;
		}catch(e){
			showErrorMessage("getCheckLocationDtl", e);
		}
	}
	
	function getOrigFireDtls(){
		try{ 
			$("txtDistrictNo").value = unescapeHTML2(objCLM.variables.origDstrct);
			objCLM.basicInfo.districtNumber = objCLM.variables.origDstrct;
			$("txtBlockNo").value = unescapeHTML2(objCLM.variables.origBlockNo);
			objCLM.basicInfo.blockNo = objCLM.variables.origBlockNo;
			objCLM.basicInfo.blockId = objCLM.variables.origBlockId;
			$("txtCity").value = unescapeHTML2(objCLM.variables.origCityDesc);
			objCLM.basicInfo.dspCityDesc = objCLM.variables.origCityDesc;
			objCLM.basicInfo.cityCode = objCLM.variables.origCityCd;
			$("txtProvince").value = unescapeHTML2(objCLM.variables.origProvinceDesc);
			objCLM.basicInfo.dspProvinceDesc = objCLM.variables.origProvinceDesc;
			objCLM.basicInfo.provinceCode = objCLM.variables.origProvinceCd;
			$("txtProvince").focus();
		}catch(e){
			showErrorMessage("getOrigFireDtls", e);
		}
	}
	
	function getOrigCasDtls(){
		try{ 
			$("txtlocationDesc").value = unescapeHTML2(objCLM.variables.origLocationDesc);
			objCLM.basicInfo.locationDesc = objCLM.variables.origLocationDesc;
			$("txtLocation").value = unescapeHTML2(objCLM.variables.origLocationDesc); //emsy 4.23.2012
			objCLM.basicInfo.dspLocationDesc = objCLM.variables.origLocationDesc; //emsy 4.23.2012
			$("txtCity").value = unescapeHTML2(objCLM.variables.origCityDesc);
			objCLM.basicInfo.dspCityDesc = objCLM.variables.origCityDesc;
			objCLM.basicInfo.cityCode = objCLM.variables.origCityCd;
			$("txtProvince").value = unescapeHTML2(objCLM.variables.origProvinceDesc);
			objCLM.basicInfo.dspProvinceDesc = objCLM.variables.origProvinceDesc;
			objCLM.basicInfo.provinceCode = unescapeHTML2(objCLM.variables.origProvinceCd);
			$("txtLocOfLoss1").value = unescapeHTML2(objCLM.basicInfo.lossLocation1);
			$("txtlocationDesc").focus();
		}catch(e){
			showErrorMessage("getOrigCasDtls", e);
		}
	}
	
	function checkDateTimeOnCommit(){
		try{
			if ($F("txtLossTime") != "" && $F("txtLossTime") != objCLM.variables.oldTime){
				objCLM.variables.updateFlag = true;
			} 	
			if (objCLM.variables.updateFlag == true){
				if ($F("txtLossDate") != "" || $F("txtLossTime") != "" && objCLM.variables.chkFlag == false){
					objCLM.variables.comFlag = true;
					validatePolIssueDate("commit");
				}	
			}else{
				postCheckLossDateTime();	
			}	
		}catch(e){
			showErrorMessage("checkDateTimeOnCommit", e);
		}
	}
	
	function conSaving(){
		try{
			if ($F("txtLossDate") != ""){
				if (objCLM.variables.oldDate != $F("txtLossDate")){
					objCLM.variables.updateFlag = true;
					var existItemOrPeril = nvl(objCLM.basicInfo.giclItemPerilExist, nvl(objCLM.basicInfo.giclClmItemExist, "N"));
					var resExist = nvl(objCLM.basicInfo.giclClmReserveExist, "N");
					
					if (nvl(objCLM.variables.oldDate,"") != "" && existItemOrPeril != "N" && resExist == "N"){
						if (objCLM.variables.oldDate != $F("txtLossDate")){
							showConfirmBox("Confirmation","Changing the Loss Date will delete Item and Peril records for this claim. Would you like to continue?","Yes","No",
									function(){
										objCLM.variables.clearItemPerilFunc = "Y";
										var proc = new Object(); 
										proc.name = "clearItemPerilFunc";
										objCLM.variables.procs.push(proc);
										$("txtLossTime").value = "";
										$("txtLossTime").focus();
										checkDateTimeOnCommit();
									},function(){
										$("txtLossDate").value = objCLM.variables.oldDate;
										$("txtLossDate").focus();
										ok = false;
										return false;
									});
							if (!ok) return false;
						}else{
							checkDateTimeOnCommit();	
						}
					}else{ 
						if (nvl(resExist,"Y") == "Y"){
							$("txtLossDate").value = objCLM.variables.oldDate;
							$("txtLossDate").focus();
							customShowMessageBox("Cannot update loss date, reserve has been set-up.", "E", "txtLossDate");
							ok = false;
							return false;
						}else{
							checkDateTimeOnCommit();	
						}	
					}
				}else{
					checkDateTimeOnCommit();
				}	
			}else{
				checkDateTimeOnCommit();
			}	
		}catch(e){
			showErrorMessage("conSaving", e);
		}	
	}	
	
	function checkLocation(){ //modified function : kenneth L. 01.07.2014
		try{
			//if (ora2010Sw == "Y"){
				if (nvl(valLocOfLoss,"") == ""){
					showMessageBox("VALIDATE LOCATION OF LOSS does not exist in GIIS_PARAMETERS.", "E");
					return false;
				}

				if (nvl(objCLMGlobal.claimId,null) != null){
					var res = getCheckLocationDtl(); 
					if ($F("txtLineCd") == lineCodeFI){
						if (res.fireItemExist == "Y"){					
							if (nvl(objCLM.variables.origDstrct,'') != escapeHTML2($F("txtDistrictNo")) || nvl(objCLM.variables.origBlockNo,'') != escapeHTML2($F("txtBlockNo"))){
								if (res.blockId != objCLM.basicInfo.blockId || res.districtNo != escapeHTML2($F("txtDistrictNo")) || res.blockNo != escapeHTML2($F("txtBlockNo"))){
									if (valLocOfLoss == "Y"){
										showWaitingMessageBox("Block/District from Item information is not the same for the chosen Block/District.", "I", getOrigFireDtls);
										return false;
									}else if (valLocOfLoss == "N"){
										if (objCLM.variables.message == "N"){
											showConfirmBox("Confirmation","Block/District from Item information is not the same for the chosen Block/District. Do you wish to continue?", "Yes", "No", function(){objCLM.variables.message = "Y"; conSaving();}, getOrigFireDtls);
										}else{
											conSaving();
										}
									}else if (valLocOfLoss == "O"){
										if (objCLM.variables.locflag == "N"){
											if (!validateUserFunc2("VL", "GICLS010")){
												showConfirmBox("Confirmation","Block/District from Item information is not the same for the chosen Block/District. Would you like to override?", "Yes", "No",
														function(){
															objCLM.variables.validClaim = true;
															objAC.funcCode = "VL";
															objACGlobal.calledForm = "GICLS010";
															commonOverrideOkFunc = function(){
																objCLM.variables.locflag = "Y";
																conSaving();
															};
															commonOverrideNotOkFunc = function(){
																showWaitingMessageBox($("overideUserName").value + " is not allowed to Override.", "E", 
																		clearOverride);
																objCLM.variables.validClaim = false;
																ok = false;
																return false;
															};
															commonOverrideCancelFunc = function(){
																objCLM.variables.validClaim = false;
																ok = false;
																return false;
															};
															getUserInfo();
															$("overlayTitle").innerHTML = "Override User";
														}, 
														getOrigFireDtls);
											}else{
												conSaving();
											}
										}else{
											conSaving();
										}
									}else{
										conSaving();
									}
								}else{
									conSaving();
								}
							}else{
								conSaving();
							}
						}else{
							conSaving();
						}	
					}else if ($F("txtLineCd") == lineCodeCA && caSublinePFL == $F("txtSublineCd")){
						if (res.casItemExist == "Y"){
							//if (nvl(objCLM.variables.origLocationDesc,'') != escapeHTML2($F("txtlocationDesc"))){
								//if (res.locationCd != objCLM.basicInfo.locationCode){
								  if(res.valLoc == "N"){
									if (valLocOfLoss == "Y"){
										showWaitingMessageBox("Location from Item information is not the same for the chosen location.", "I", getOrigCasDtls);
										return false;
									}else if (valLocOfLoss == "N"){
										if (objCLM.variables.message == "N"){
											showConfirmBox("Confirmation","Location from Item information is not the same for the chosen location. Do you wish to continue?", "Yes", "No", function(){objCLM.variables.message = "Y"; conSaving();}, getOrigCasDtls);
										}else{
											conSaving();
										}
									}else if (valLocOfLoss == "O"){
										if (objCLM.variables.locflag == "N"){
											if (!validateUserFunc2("VL", "GICLS010")){
												showConfirmBox("Confirmation","Location from Item information is not the same for the chosen Location.  Would you like to override?", "Yes", "No",
														function(){
															objCLM.variables.validClaim = true;
															objAC.funcCode = "VL";
															objACGlobal.calledForm = "GICLS010";
															commonOverrideOkFunc = function(){
																objCLM.variables.locflag = "Y";
																conSaving();
															};
															commonOverrideNotOkFunc = function(){
																showWaitingMessageBox($("overideUserName").value + " is not allowed to Override.", "E", 
																		clearOverride);
																objCLM.variables.validClaim = false;
																ok = false;
																return false;
															};
															commonOverrideCancelFunc = function(){
																objCLM.variables.validClaim = false;
																ok = false;
																return false;
															};
															getUserInfo();
															$("overlayTitle").innerHTML = "Override User";
														}, 
														getOrigCasDtls);
											}else{
												conSaving();
											}
										}else{
											conSaving();
										}
									}else{
										showMessageBox("VALIDATE LOCATION OF LOSS does not exist in GIIS_PARAMETERS.", "E");
										return false;
										//conSaving();
									}	
								}else{
									conSaving();
								}
							//}else{
							//	conSaving();
							//}
						}else{
							conSaving();
						}
					}else{
						conSaving();	
					}	
				}else{
					conSaving();	
				}	
			//}else{
			//	conSaving();	
			//}
		}catch(e){
			showErrorMessage("checkLocation", e);
		}
	}
	
	function prepareBasicInfoOnCommit(){
		try{ 
			
			objCLM.basicInfo.nbtClmStatCd 				= ($("chkOkProcessing").checked == true ? "Y" :"N");
			objCLM.basicInfo.recoverySw 				= ($("chkLossRecovery").checked == true ? "Y" :"N");
			objCLM.basicInfo.totalTag 					= ($("chkTotalLoss").checked == true ? "Y" :"N");
			objCLM.basicInfo.claimControl 				= escapeHTML2(String(nvl(nvl($F("clmControl"),"N"),objCLM.basicInfo.claimControl)));
			objCLM.basicInfo.claimStatusCd 				= escapeHTML2(String(nvl($F("txtClmStatCd"),objCLM.basicInfo.claimStatusCd)));
			objCLM.basicInfo.assuredNo 					= escapeHTML2(String(nvl($F("txtAssuredNo"),objCLM.basicInfo.assuredNo)));
			objCLM.basicInfo.assuredName 				= escapeHTML2(String(nvl($F("txtAssuredName"),objCLM.basicInfo.assuredName)));
			objCLM.basicInfo.riCd 						= escapeHTML2(String(nvl($F("txtRiCd"),objCLM.basicInfo.riCd)));
			objCLM.basicInfo.plateNumber 				= escapeHTML2(String($F("txtPlateNumber")/*nvl($F("txtPlateNumber"),objCLM.basicInfo.plateNumber)*/)); //benjo 10.20.2016 SR-23261
			objCLM.basicInfo.motorNumber 				= escapeHTML2(String(nvl($F("txtMotorNumber"),objCLM.basicInfo.motorNumber)));
			objCLM.basicInfo.serialNumber 				= escapeHTML2(String(nvl($F("txtSerialNumber"),objCLM.basicInfo.serialNumber)));
			objCLM.basicInfo.lineCode 					= nvl($F("txtLineCd"),objCLM.basicInfo.lineCode);
			objCLM.basicInfo.sublineCd 					= nvl($F("txtSublineCd"),objCLM.basicInfo.sublineCd);
			objCLM.basicInfo.policyIssueCode 			= nvl($F("txtPolIssCd"),objCLM.basicInfo.policyIssueCode);
			objCLM.basicInfo.issueYy 					= nvl($F("txtIssueYy"),objCLM.basicInfo.issueYy);
			objCLM.basicInfo.policySequenceNo 			= nvl($F("txtPolSeqNo"),objCLM.basicInfo.policySequenceNo);
			objCLM.basicInfo.polSeqNo					= objCLM.basicInfo.policySequenceNo;
			objCLM.basicInfo.renewNo 					= nvl($F("txtRenewNo"),objCLM.basicInfo.renewNo);
			objCLM.basicInfo.strClaimFileDate 			= nvl($F("txtDateFiled"),objCLM.basicInfo.strClaimFileDate);
			objCLM.basicInfo.claimFileDate 				= nvl($F("txtDateFiled"),objCLM.basicInfo.strClaimFileDate); //objCLM.basicInfo.claimFileDate; adpascual 5.7.13 commented out by Gzelle 08042014
			objCLM.basicInfo.strEntryDate 				= nvl($F("txtClmEntryDate"),objCLM.basicInfo.strEntryDate);
			objCLM.basicInfo.entryDate 					= objCLM.basicInfo.strEntryDate;
			objCLM.basicInfo.districtNumber				= escapeHTML2(String(nvl($F("txtDistrictNo"),objCLM.basicInfo.districtNumber))); 
			objCLM.basicInfo.blockNo 					= escapeHTML2(String(nvl($F("txtBlockNo"),objCLM.basicInfo.blockNo))); 
			objCLM.basicInfo.polEffDate					= setDfltSec(($F("txtInceptionDate")+" "+$F("txtInceptionTime")).strip()); //nvl(($F("txtInceptionDate")+" "+$F("txtInceptionTime")).strip(),objCLM.basicInfo.strPolicyEffectivityDate);
			objCLM.basicInfo.strPolicyEffectivityDate 	= objCLM.basicInfo.polEffDate;
			objCLM.basicInfo.policyEffectivityDate 		= objCLM.basicInfo.polEffDate;
			objCLM.basicInfo.strExpiryDate 				= setDfltSec(($F("txtExpiryDate")+" "+$F("txtExpiryTime")).strip());
			objCLM.basicInfo.expiryDate 				= objCLM.basicInfo.strExpiryDate;
			objCLM.basicInfo.strLossDate 				= nvl(objCLM.basicInfo.strLossDate,($F("txtLossDate")+" "+$F("txtLossTime")).strip());
			objCLM.basicInfo.lossDate 					= setDfltSec(objCLM.basicInfo.strLossDate);
			objCLM.basicInfo.dspLossDate				= setDfltSec(nvl(($F("txtLossDate")+" "+nvl($F("txtLossTime"),objCLM.variables.sublineTime)).strip(),objCLM.basicInfo.strDspLossDate));
			objCLM.basicInfo.dspLossTime 				= nvl(objCLM.basicInfo.dspLossDate,objCLM.basicInfo.lossDate);
			objCLM.basicInfo.claimSettlementDate 		= nvl($("txtDateSettled").value,objCLM.basicInfo.strClaimSettlementDate);
			objCLM.basicInfo.issueDate 					= objCLM.basicInfo.strIssueDate;
			objCLM.basicInfo.creditBranch				= escapeHTML2(String($F("txtCreditBranch")));
			objCLM.basicInfo.remarks					= escapeHTML2(String($F("txtRemarks")));
			objCLM.basicInfo.lossDetails				= escapeHTML2(String($F("txtLossDtls")));
			objCLM.basicInfo.lossLocation1				= escapeHTML2(String($F("txtLocOfLoss1")));
			objCLM.basicInfo.lossLocation2				= escapeHTML2(String($F("txtLocOfLoss2")));
			objCLM.basicInfo.lossLocation3				= escapeHTML2(String($F("txtLocOfLoss3")));
			objCLM.basicInfo.zipCode					= escapeHTML2(String($F("txtZipCode")));
			objCLM.basicInfo.claimControl				= nvl(objCLM.basicInfo.claimControl,"N");
			objCLM.basicInfo.reportedBy					= escapeHTML2(String($F("txtReportedBy")));
			
			var date2 = new Date();
			if ((dateFormat(date2,"mm-dd-yyyy") == $F("txtDateFiled")) && objCLM.basicInfo.claimId == null){
				objCLM.basicInfo.claimFileDate = getCurrentDateTime(true);
			}else if($F("txtDateFiled") == ""){
				objCLM.basicInfo.claimFileDate = getCurrentDateTime(true);
			}	
		}catch(e){
			showErrorMessage("prepareBasicInfoOnCommit", e);
		}
	}	

	function saveGICLS010(){
		try{
			prepareBasicInfoOnCommit(); 
			new Ajax.Request(contextPath+"/GICLClaimsController",{
				parameters: {
					action: "saveGICLS010",
					lineCd: $F("txtLineCd"), //added by cherrie | 01.24.2014
					basicInfo: JSON.stringify(objCLM.basicInfo),
					procs: prepareJsonAsParameter(objCLM.variables.procs),
					checkNoClaimSw: objCLM.variables.checkNoClaimSw
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: showNotice("Saving, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						res = JSON.parse(response.responseText); //removed .replace(/\\/g, '\\\\') - christian 04/05/2013
						if (nvl(res.checkNoAlert,null) != null){
							showConfirmBox("Confirmation",res.checkNoAlert,"Yes","No", 
									function(){
										objCLM.variables.checkNoClaimSw = "Y";
										fireEvent($("saveBtn"), "click");
									}, 
									showClaimBasicInformation);
						}else{
							changeTag = 0;
							showMessageBox(objCommonMessage.SUCCESS, "S");
							objCLMGlobal = res.basicInfo;
							objCLMGlobal.claimId = res.basicInfo.claimId;
							objCLMGlobal.lineCd = res.basicInfo.lineCode;
							objCLMGlobal.menuLineCd = objCLM.basicInfo.menuLineCd; //added by jeffdojello 10.01.2013
							objCLMItem.objCALossLocation1       = objCLM.basicInfo.lossLocation1; // Added by J. Diago 10.17.2013
							objCLMItem.objCALossLocation2       = objCLM.basicInfo.lossLocation2; // Added by J. Diago 10.17.2013
							objCLMItem.objCALossLocation3       = objCLM.basicInfo.lossLocation3; // Added by J. Diago 10.17.2013
							objCLMGlobal.menuLineCd = res.menuLineCd; //added by cherrie | 01.24.2014
							showClaimBasicInformation();
						}
					} 	
				}	
			});
		}catch(e){   
			showErrorMessage("saveGICLS010", e);
		}
	}
	
	$("saveBtn").observe("focus", function(){
		objCLM.variables.keyCommit = true;
	});	
	
	$("saveBtn").observe("click", function(){
		if(changeTag ==1){
			var isComplete = checkAllRequiredFields();
			if (isComplete && objCLM.variables.validClaim == true && validateDateFiled()){
				if($F("txtLossTime") == "" && objCLM.variables.sublineTime == ""){ //added by christian 04/06/2013
					showMessageBox("There is no cut-off time found in subline maintenance. Please contact your MIS for proper set-up.","I");
				}else{
					checkLocation();
				}
			}			
		}else{
			showMessageBox(objCommonMessage.NO_CHANGES,"I");
			return false;
		}
		
	});
	
	function refreshClaims(){
		try{ 
			prepareBasicInfoOnCommit(); 
			new Ajax.Request(contextPath+"/GICLClaimsController",{
				parameters: {
					action: 		"refreshClaims",
					claimId:		objCLMGlobal.claimId,
					lineCd: 		$F("txtLineCd"),
					sublineCd: 		$F("txtSublineCd"),
					polIssCd: 		$F("txtPolIssCd"),
					issueYy: 		$F("txtIssueYy"),
					polSeqNo: 		$F("txtPolSeqNo"),
					renewNo: 		$F("txtRenewNo"),
					expiryDate: 	setDfltSec(nvl(($F("txtExpiryDate")+" "+$F("txtExpiryTime")).strip()),objCLM.basicInfo.strExpiryDate),
					polEffDate: 	setDfltSec(nvl(($F("txtInceptionDate")+" "+$F("txtInceptionTime")).strip()),objCLM.basicInfo.strPolicyEffectivityDate),
					dspLossDate:	setDfltSec(nvl(($F("txtLossDate")+" "+nvl($F("txtLossTime"),objCLM.variables.sublineTime)).strip(),objCLM.basicInfo.strDspLossDate))
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: showNotice("Updating, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						if (response.responseText == "SUCCESS"){
							showMessageBox("Update successful.", "S");
							showClaimBasicInformation();
						}	
					} 	
				}	
			});
		}catch(e){   
			showErrorMessage("refreshClaims", e);
		}	
	}
	
	$("refreshBtn").observe("click", function(){
		showConfirmBox("Confirmation","Continue Update?","Yes","No", 
				refreshClaims, "");
	});
	checkLineCd();
	window.scrollTo(0,0); 	
	hideNotice("");
	setModuleId("GICLS010");
	setDocumentTitle("Basic Information");
	initializeChangeTagBehavior(function(){
		fireEvent($("saveBtn"), "click");	
	});
	
	if (objCLM.basicInfo.recoverySw != 'Y'){
		disableButton("recAmtsBtn");
	} else {
		enableButton("recAmtsBtn");
	}
	
	if (objGICLS051.previousModule == "GICLS051") {
		if(objGICLS051.currentView == "P"){
			showPrelimLossAdvice();
		} else if(objGICLS051.currentView == "F"){
			showGenerateFLAPage();
		}
	}
	
}catch(e){
	showErrorMessage("GICLS010 Main Page", e);
}	
</script>
