<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id ="gipis130TempDiv"></div>
<div id="viewDistributionStatusMainDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>View Distribution Status</label>
	   	</div>
	</div>
	<div class="sectionDiv" id="gipis130HeaderDiv" style="padding-top: 10px; padding-bottom: 10px;">
		<div style="width: 600px; float: left;">
			<table border="0" style="float: right;">
				<tbody>
					<tr>
						<!-- <td class="rightAligned">Line Cd</td> replaced by robert SR 20756 01.27.16-->
						<td class="rightAligned">Policy No.</td>
						<td class="leftAligned" colspan="3" >
						<%-- <span class="lovSpan required" style="width: 100px;"> rplaced by codes below robert SR 4887 09.18.15
							<input type="text" id="txtLineCd" name="txtLineCd" style="width: 100px; float: left; border: none; height: 14px; margin: 0;" class="required"/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineCd" name="searchLineCd" alt="Go" class="required" style="float: right;"/>
						</span> --%>
						<div style="width: 140px; float: left; height: 20px;" class="withIconDiv"> <%-- removed required by robert SR 20756 01.27.16 --%>
							<input type="text" name="txtLineCd" id="txtLineCd" style="width: 115px;" class="withIcon upper"  title="Line Code" maxlength="2" value="${lineCd}"/>
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineCd" name="searchLineCd" alt="Go" />
						</div>
						<input type="text" name="txtSublineCd" id="txtSublineCd" class="upper" style="width: 81px; height: 14px;" title="Subline" maxlength="7" value="${sublineCd}"/>
						<input type="text" name="txtIssCd" id="txtIssCd" class="upper" style="width: 31px; height: 14px;" title="Issue Code" maxlength="2" value="${issCd}"/>
						<input type="text" name="txtIssueYy" id="txtIssueYy" style="width: 31px; height: 14px; text-align: right;" title="Issue Year" maxlength="2" class="integerNoNegativeUnformatted" value="${issueYy}"/>
						<input type="text" name="txtPolSeqNo" id="txtPolSeqNo" style="width: 81px;  height: 14px;text-align: right;" title="Sequence No" maxlength="6" class="integerNoNegativeUnformatted" value="${polSeqNo}"/>
						<input type="text" name="txtRenewNo" id="txtRenewNo" style="width: 31px; height: 14px; text-align: right;" title="Renew No" maxlength="2" class="integerNoNegativeUnformatted" value="${renewNo}"/>	
						<!-- end robert SR 4887 09.18.15 -->
					</tr>
					<tr>
					<td class="rightAligned">Endorsement No.</td> <!-- added by robert SR 20756 01.27.16 -->
					<td class="leftAligned">
						<input class="allCaps" type="text" id="txtEndtIssCd" name="txtEndtIssCd" style="width: 50px; float: left; margin: 2px 4px 0 0" maxlength="2" tabindex="120" />
						<input class="integerNoNegativeUnformattedNoComma" lpad="2" type="text" id="txtEndtYy" name="txtEndtYy" style="width: 50px; float: left; margin: 2px 4px 0 0" maxlength="3" tabindex="121"/>
						<input class="integerNoNegativeUnformattedNoComma" lpad="7" type="text" id="txtEndtSeqNo" name="txtEndtSeqNo" style="width: 103px; float: left; margin: 2px 4px 0 0" maxlength="8" tabindex="122" />
					</td>
					<td class="rightAligned">Dist No</td>
						<td class="leftAligned">
							<input class="integerNoNegativeUnformattedNoComma" lpad="8" type="text" id="txtDistNo" name="txtDistNo" style="width: 157px; float: left; margin: 2px 4px 0 0" maxlength="8" tabindex="122"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Crediting Branch</td>
						<td class="leftAligned" colspan="3">
							<div style="width: 454px; float: left; height: 20px;" class="withIconDiv">
								<input type="text" name="txtCredBranch" id="txtCredBranch" style="width: 425px;" class="withIcon upper allCaps" tabindex="109" />
								<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchCredBranch" name="searchCredBranch" alt="Go" />
							</div>
						</td>
					</tr>
				</tbody>
			</table>
			<div>
				<fieldset style="width: 441px; float: right;">
					<legend>Search By</legend>
					<table border="0">
						<tr>
							<td>
								<input type="radio" id="rdoInceptDate" name="rdoSearchBy" tabindex="101" checked="checked"/>
							</td>
							<td>
								<label for="rdoInceptDate" style="width: 100px;">Incept Date</label>
							</td>
							<td>
								<input type="radio" id="rdoIssueDate" name="rdoSearchBy" tabindex="102" />
							</td>
							<td>
								<label for="rdoIssueDate" style="width: 100px;">Issue Date</label>
							</td>
							<td>
								<input type="radio" id="rdoEffDate" name="rdoSearchBy" tabindex="103" />
							</td>
							<td>
								<label for="rdoEffDate" style="width: 100px;">Effectivity Date</label>
							</td>
						</tr>
					</table>
				</fieldset>
			</div>
		</div>
		<div style="width: 300px; float: right;">
			<fieldset style="padding-top: 10px; width: 220px;">
				<table style="float: left;">
				<tr>
					<td class="rightAligned"><input type="radio" name="rdoSearchByDate" id="rdoAsOf" style="float: left;" tabindex="104" checked="checked"/><label for="rdoAsOf" style="float: left; height: 20px; padding-top: 3px;">As of</label></td>
					<td class="leftAligned">
						<div style="float: left; width: 140px;" class="withIconDiv" id="divAsOf">
							<input type="text" removeStyle="true" id="txtAsOf" class="withIcon" readonly="readonly" style="width: 115px;" tabindex="105"/>
							<img id="imgAsOf" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="As of Date" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned"><input type="radio" name="rdoSearchByDate" id="rdoFrom" style="float: left;" tabindex="106"/><label for="rdoFrom" style="float: left; height: 20px; padding-top: 3px;">From</label></td>
					<td class="leftAligned">
						<div style="float: left; width: 140px;" class="withIconDiv" id="divFrom">
							<input type="text" removeStyle="true" id="txtFrom" class="withIcon" readonly="readonly" style="width: 115px;" tabindex="107"/>
							<img id="imgFrom" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned"><label style="float: right; height: 20px; padding-top: 3px; margin-right: 2px;">To</label></td>
					<td class="leftAligned">
						<div style="float: left; width: 140px;" class="withIconDiv" id="divTo">
							<input type="text" removeStyle="true" id="txtTo" class="withIcon" readonly="readonly" style="width: 115px;" tabindex="108"/>
							<img id="imgTo" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To Date" />
						</div>
					</td>
				</tr>
			</table>
			</fieldset>
		</div>
	</div>
	<div class="sectionDiv" style="padding-bottom: 10px;">
			<div style="width: 600px; float: left; padding-left: 15px; padding-top: 10px;">
				<div id="distributionStatusDiv">
					<div id="distributionStatusTable" style="height: 280px;"></div>
				</div>
			</div>
			<div style="width: 190px; float: right; padding-left: 15px; padding-top: 10px;">
				<strong>Status</strong><br><br>
				<label style="padding-left: 10px;">Undistributed</label></td>
				<table style="margin: 10px 0 15px 15px;">
					<tr>
						<td><input type="radio" name="rdoDistributionStat" id="rdoUWOFacul" tabindex="110" name="status"/></td>
						<td><label for="rdoUWOFacul" >w/o Facultative</label></td>
					</tr>
					<tr>
						<td><input type="radio" name="rdoDistributionStat" id="rdoUWFacul" tabindex="111"name="status"/></td>
						<td><label for="rdoUWFacul" >w/ Facultative</label></td>
					</tr>
					<tr>
						<td><input type="radio" name="rdoDistributionStat" id="rdoUAll" tabindex="111" name="status"/></td>
						<td><label for="rdoUAll" >All Undistributed</label></td>
					</tr>
				</table>
				<label style="padding-left: 10px;">Posted Distribution</label></td>
				<table style="margin: 10px 0 15px 15px;">
					<tr>
						<td><input type="radio" name="rdoDistributionStat" id="rdoPDWOFacul" tabindex="110" name="status"/></td>
						<td><label for="rdoPDWOFacul" >w/o Facultative</label></td>
					</tr>
					<tr>
						<td><input type="radio" name="rdoDistributionStat" id="rdoPDWFacul" tabindex="111" name="status"/></td>
						<td><label for="rdoPDWFacul" >w/ Facultative</label></td>
					</tr>
					<tr>
						<td><input type="radio" name="rdoDistributionStat" id="rdoPDAll" tabindex="111" name="status"/></td>
						<td><label for="rdoPDAll" >All Posted</label></td>
					</tr>
				</table>
				<table>
					<tr>
						<td><input type="radio" name="rdoDistributionStat" id="rdoNegated" tabindex="110" name="status"/></td>
						<td><label for="rdoNegated" >Negated</label></td>
					</tr>
					<tr>
						<td><input type="radio" name="rdoDistributionStat" id="rdoRedistributed" tabindex="110" name="status"/></td>
						<td><label for="rdoRedistributed" >Redistributed</label></td>
					</tr>
					<tr>
						<td><input type="radio" name="rdoDistributionStat" id="rdoAllPolicies" tabindex="110" checked="checked" name="status"/></td>
						<td><label for="rdoAllPolicies" >All Policies</label></td>
					</tr>
				</table>
			</div>
		</div>
		<div style="padding-top: 20px; padding-left: 15px; padding-right: 15px; padding-bottom: 10px;">
		<fieldset style="height: 125px; padding-bottom: 20px;">
			<legend>Policy</legend>
				<div id="policyDiv">
					<table border="0">
						<tbody>
							<tr>
								<td class="rightAligned" style="width: 22%;">Assured</td>
								<td class="leftAligned" style="width: 17%;" colspan="3">
									<input id="txtAssured" type="text" name="txtAssured" style="width: 496px;" readonly="readonly"/>
								</td>
								<td class="rightAligned" style="width: 27%;">User ID</td>
								<td class="leftAligned" style="width: 17%;" >
									<input id="txtPUserId" type="text" name="txtPUserId" style="width: 180px;" readonly="readonly"/>
								</td>
							</tr>
							<tr>
								<td class="rightAligned" style="width: 27%;">Inception Date</td>
								<td class="leftAligned" style="width: 20%;" >
									<input id="txtInceptionDate" type="text" name="txtInceptionDate" style="width: 180px;" readonly="readonly"/>
								</td>
								<td class="rightAligned" style="width: 17%;">Expiry Date</td>
								<td class="leftAligned" style="width: 17%;" >
									<input id="txtExpiryDatePolbas" type="text" name="txtExpiryDatePolbas" style="width: 180px;" readonly="readonly"/>
								</td>
								<td class="rightAligned" style="width: 27%;">Status</td>
								<td class="leftAligned" style="width: 17%;" >
									<input id="txtStatus" type="text" name="txtStatus" style="width: 180px;" readonly="readonly"/>
								</td>
							</tr>
							<tr>
								<td class="rightAligned" style="width: 25%;">Acct. Ent Date</td>
								<td class="leftAligned" style="width: 20%;" >
									<input id="txtAcctEntDate" type="text" name="txtAcctEntDate" style="width: 180px;" readonly="readonly"/>
								</td>
								<td class="rightAligned" style="width: 17%;">Acct. Neg. Date</td>
								<td class="leftAligned" style="width: 17%;" >
									<input id="txtAcctNegDate" type="text" name="txtAcctNegDate" style="width: 180px;" readonly="readonly"/>
								</td>
								<td class="rightAligned" style="width: 27%;">As of</td>
								<td class="leftAligned" style="width: 17%;" >
									<input id="txtPAsOf" type="text" name="txtPAsOf" style="width: 180px;" readonly="readonly"/>
								</td>
							</tr>
							<tr>
								<td class="rightAligned" style="width: 22%;">Issue Date</td>
								<td class="leftAligned" style="width: 17%;" colspan="5">
									<input id="txtIssueDate" type="text" name="txtIssueDate" style="width: 180px;" readonly="readonly"/>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
		</fieldset>
		</div>
		<div style="float: right; padding-left: 15px; padding-right: 15px; padding-bottom: 40px;">
			<fieldset style="float: left; height: 100px; width: 635px; padding-bottom: 20px">
			<legend>Distribution</legend>
				<div id="distributionDiv">
					<table border="0" float: left;">
						<tbody>
							<tr>
								<td class="rightAligned" style="width: 6%;">Effectivity Date</td>
								<td class="leftAligned" style="width: 9%;" >
									<input id="txtEffDate" type="text" name="txtEffDate" style="width: 180px;" readonly="readonly"/>
								</td>
								<td class="rightAligned" style="width: 6%;">Expiry Date</td>
								<td class="leftAligned" style="width: 5%;" >
									<input id="txtExpiryDatePoldist" type="text" name="txtExpiryDatePoldist" style="width: 180px;" readonly="readonly"/>
								</td>
							</tr>
							<tr>
								<td class="rightAligned" style="width: 5%;">Negated Date</td>
								<td class="leftAligned" style="width: 9%;" >
									<input id="txtNegatedDate" type="text" name="txtNegatedDate" style="width: 180px;" readonly="readonly"/>
								</td>
								<td class="rightAligned" style="width: 6%;">Last Update</td>
								<td class="leftAligned" style="width: 5%;" >
									<input id="txtLastUpdate" type="text" name="txtLastUpdate" style="width: 180px;" readonly="readonly"/>
								</td>
							</tr>
							<tr>
								<td class="rightAligned" style="width: 5%;">User ID</td>
								<td class="leftAligned" style="width: 9%;" colspan="2">
									<input id="txtDUserID" type="text" name="txtDUserID" style="width: 180px;" readonly="readonly"/>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</fieldset>
			<fieldset style="float: right; height: 100px; width:212px; padding-bottom: 20px">
			<legend>Details</legend>
				<div id="detailsDiv">
					<table>
						<tbody>
							<tr>
								<td>
									<input type="button" class="button" id="btnViewHistory" value="View History" style="width: 205px;" />
								</td>
							</tr>
							<tr>
								<td>
									<input type="button" class="button" id="btnViewDistribution" value="View Distribution" style="width: 205px;" />
								</td>
							</tr>
							<tr>
								<td>
									<input type="button" class="button" id="btnSummarizedDist" value="Summarized Distribution" style="width: 205px; /* display: none; */" /> <!-- John Daniel SR-4946; added "display: none" to hide button--><!-- re added the button by gab 10.03.2016 SR 5603 --> 
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</fieldset>
		</div>
	</div>
</div>
<div id="hiddenDiv">
	<input type="hidden" id="hidLineCd"/>
	<input type="hidden" id="hidSublineCd"/>
	<input type="hidden" id="hidIssCd"/>
	<input type="hidden" id="hidIssueYy"/>
	<input type="hidden" id="hidPolSeqNo"/>
	<input type="hidden" id="hidRenewNo"/>
	<input type="hidden" id="hidDistNo"/>
	<input type="hidden" id="hidDistSeqNo"/>
	<input type="hidden" id="filterLineCd"/>
</div>

<script type="text/javascript">
	var callingModule = '${callingModule}';
	setModuleId("GIPIS130");
	setDocumentTitle("View Distribution Status");

	var dateToday = ignoreDateTime(new Date());
	var jsonViewDistributionStatus = JSON.parse('${showViewDistributionStatus}');
	var onSearch = false;
	var parId;
	var distNo;
	var distFlag;
	var policyNo;
	var status;
	var policyId;
	var policyInfoPolicyId = 0;
	
	if(callingModule == "GIPIS100"){
		$("gipis130HeaderDiv").hide();
		policyInfoPolicyId = '${policyId}';
		objGIPIS100.policyId = policyInfoPolicyId; //benjo 07.21.2015 UCPBGEN-SR-19626
		objGIPIS100.callSw = "Y"; //benjo 07.21.2015 UCPBGEN-SR-19626
		if(objGIPIS100.callingForm == "GIPIS132"){
			objGIPIS100.callingForm == "GIPIS132";
		}else{
			objGIPIS100.callingForm = "GIPIS130";
		}
		onSearch = true;
	}
	
	var pLineCd = objGIPIS130.details != null ? objGIPIS130.details.lineCd : ""; // bonok :: 9.3.2015 :: UCPB 20278 :: changed null to ""
	var pSublineCd = objGIPIS130.details != null ? objGIPIS130.details.sublineCd : "";
	var pIssCd = objGIPIS130.details != null ? objGIPIS130.details.issCd : "";
	var pIssueYy = objGIPIS130.details != null ? objGIPIS130.details.issueYy : "";
	var pPolSeqNo = objGIPIS130.details != null ? objGIPIS130.details.polSeqNo : "";
	var pRenewNo = objGIPIS130.details != null ? objGIPIS130.details.renewNo : "";	
	var additionalParam = "&lineCd="+pLineCd +"&sublineCd="+pSublineCd +"&issCd="+pIssCd+"&issueYy="+pIssueYy+"&polSeqNo="+pPolSeqNo+"&renewNo="+pRenewNo;

	viewDistributionStatusTableModel = {
			// added getAdditionalParam() by robert SR 4887 09.18.15
			url : contextPath + "/GIPIPolbasicController?action=showViewDistributionStatus&refresh=1"+"&policyId="+policyInfoPolicyId+"&callingModule="+callingModule+getAdditionalParam(), 
			options : {
				toolbar : {
					elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
					onFilter : function() {
						tbgViewDistStatus.keys.removeFocus(tbgViewDistStatus.keys._nCurrentFocus, true);
						tbgViewDistStatus.keys.releaseKeys();
						setDetailsForm(null);
					}
				},
				width : '700px',
				height : '280px',
				pager : {},
				onCellFocus : function(element, value, x, y, id) {
					tbgViewDistStatus.keys.removeFocus(tbgViewDistStatus.keys._nCurrentFocus, true);
					tbgViewDistStatus.keys.releaseKeys();
					enableButton("btnViewHistory");
					enableButton("btnViewDistribution");
					enableButton("btnSummarizedDist");
					setDetailsForm(tbgViewDistStatus.geniisysRows[y]);
					checkLineSU(tbgViewDistStatus.geniisysRows[y]);
					enableToolbarButton("btnToolbarPrint");
				},
				prePager : function() {
					tbgViewDistStatus.keys.removeFocus(tbgViewDistStatus.keys._nCurrentFocus, true);
					tbgViewDistStatus.keys.releaseKeys();
					disableButton("btnViewHistory");
					disableButton("btnViewDistribution");
					disableButton("btnSummarizedDist");
					setDetailsForm(null);
					disableFormButton();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					tbgViewDistStatus.keys.removeFocus(tbgViewDistStatus.keys._nCurrentFocus, true);
					tbgViewDistStatus.keys.releaseKeys();
					disableButton("btnViewHistory");
					disableButton("btnViewDistribution");
					disableButton("btnSummarizedDist");
					setDetailsForm(null);
					disableFormButton();
				},
				afterRender : function() {;
					tbgViewDistStatus.keys.removeFocus(tbgViewDistStatus.keys._nCurrentFocus, true);
					tbgViewDistStatus.keys.releaseKeys();
					disableButton("btnViewHistory");
					disableButton("btnViewDistribution");
					disableButton("btnSummarizedDist");
					setDetailsForm(null);
					if(tbgViewDistStatus.geniisysRows.length > 0 && objGipis130.withQuery == "Y"){ // added by robert SR 4887 09.18.15
						tbgViewDistStatus.keys.removeFocus(tbgViewDistStatus.keys._nCurrentFocus, true);
						tbgViewDistStatus.keys.releaseKeys();
						var rec = tbgViewDistStatus.geniisysRows[0];
						tbgViewDistStatus.selectRow('0');
 						enableButton("btnViewHistory");
						enableButton("btnViewDistribution");
						enableButton("btnSummarizedDist");
						setDetailsForm(rec);
						checkLineSU(rec);
						enableToolbarButton("btnToolbarPrint");
						viewDistribution();
						objGipis130.withQuery = "";
					}
				},
				onSort : function() {
					tbgViewDistStatus.keys.removeFocus(tbgViewDistStatus.keys._nCurrentFocus, true);
					tbgViewDistStatus.keys.releaseKeys();
					disableButton("btnViewHistory");
					disableButton("btnViewDistribution");
					disableButton("btnSummarizedDist");
					setDetailsForm(null);
					disableFormButton();
				}
			},
			columnModel : [ {
				id : 'recordStatus',
				title : '',
				width : '0',
				visible : false
			}, {
				id : 'divCtrId',
				width : '0',
				visible : false
			}, {
				id : "policyNo",
				title : "Policy Number",
				width : '200px',
				titleAlign : 'leftAligned',
				align : 'left',
			}, {
				id : "endtNo",
				title : "Endorsement No.",
				width : '168px',
				titleAlign : 'leftAligned',
				align : 'left'
			}, {
				id : "distNo",
				title : "Distribution No.",
				width : '135px',
				filterOption : true,
				titleAlign : 'leftAligned',
				align : 'left'
			}, {
				id : "status",
				title : "Status",
				width : '150px',
				titleAlign : 'leftAligned',
				align : 'left'
			}, {
				id : "lineCd",
				title : "Line Code",
				width : '0px',
				//filterOption : true,
				visible : false
			}, {
				id : "sublineCd",
				title : "Subline Code",
				width : '0px',
				filterOption : true,
				visible : false
			}, {
				id : "issCd",
				title : "Issue Code",
				width : '0px',
				filterOption : true,
				visible : false
			}, {
				id : "issueYy",
				title : "Issue Year",
				width : '0px',
				filterOption : true,
				visible : false
			}, {
				id : "polSeqNo",
				title : "Policy Sequence No.",
				width : '0px',
				filterOption : true,
				visible : false
			}, {
				id : "renewNo",
				title : "Renew No.",
				width : '0px',
				filterOption : true,
				visible : false
			}, { //added by robert SR 4887 10.05.15
				id : "postFlag",
				width : '0px',
				visible : false
			}
			],
			rows : jsonViewDistributionStatus.rows
	};
	
	tbgViewDistStatus = new MyTableGrid(viewDistributionStatusTableModel);
	tbgViewDistStatus.pager = jsonViewDistributionStatus;
	tbgViewDistStatus.render('distributionStatusTable');
	
	function setDetailsForm(rec) {
		try {
			$("txtAssured").value = rec == null ? "" : unescapeHTML2(rec.assdName);
			$("txtPUserId").value = rec == null ? "" : rec.pUserId;
			$("txtInceptionDate").value = rec == null ? "" : rec.inceptDate == null ? "" : dateFormat(rec.inceptDate, "mm-dd-yyyy");
			$("txtExpiryDatePolbas").value = rec == null ? "" : rec.expiryDatePolbas == null ? "" : dateFormat(rec.expiryDatePolbas, "mm-dd-yyyy");
			$("txtStatus").value = rec == null ? "" : rec.policyStatus;
			$("txtAcctEntDate").value = rec == null ? "" : rec.acctEntDate == null ? "" : dateFormat(rec.acctEntDate, "mm-dd-yyyy");
			$("txtAcctNegDate").value = rec == null ? "" : rec.acctNegDate == null ? "" : dateFormat(rec.acctNegDate, "mm-dd-yyyy");
			$("txtPAsOf").value = rec == null ? "" : dateFormat(dateToday, "mm-dd-yyyy");
			$("txtIssueDate").value = rec == null ? "" : rec.issueDate == null ? "" : dateFormat(rec.issueDate, "mm-dd-yyyy");
			$("txtEffDate").value = rec == null ? "" : rec.effDate == null ? "" : dateFormat(rec.effDate, "mm-dd-yyyy");
			$("txtExpiryDatePoldist").value = rec == null ? "" : rec.expiryDatePoldist == null ? "" : dateFormat(rec.expiryDatePoldist, "mm-dd-yyyy");
			$("txtNegatedDate").value = rec == null ? "" : rec.negateDate == null ? "" : dateFormat(rec.negateDate, "mm-dd-yyyy");
			$("txtLastUpdate").value = rec == null ? "" : rec.lastUpdDate == null ? "" : dateFormat(rec.lastUpdDate, "mm-dd-yyyy");
			$("txtDUserID").value = rec == null ? "" : rec.userId2;
			$("txtCredBranch").value = rec == null ? "" : unescapeHTML2(rec.issName);
			if($F("filterLineCd") == ""){
				$("txtLineCd").value = rec == null ? "" : unescapeHTML2(rec.lineCd);	
			} else{
				$("txtLineCd").value = $F("filterLineCd");
			}
			parId = rec == null? "" : rec.parId;
			distNo = rec == null? "" : rec.distNo;
			distFlag = rec == null? "" : rec.distFlag;
			policyNo = rec == null? "" : rec.policyNo;
			status = rec == null? "" : rec.status;
			policyId = rec == null ? "" : rec.policyId;
			$("hidLineCd").value = rec == null? "" : rec.lineCd;
			$("hidSublineCd").value = rec == null? "" : rec.sublineCd;
			$("hidIssCd").value = rec == null? "" : rec.issCd;
			$("hidIssueYy").value = rec == null? "" : rec.issueYy;
			$("hidPolSeqNo").value = rec == null? "" : rec.polSeqNo;
			$("hidRenewNo").value = rec == null? "" : rec.renewNo;
			$("hidDistNo").value = rec == null? "" : rec.distNo;
			objUW.callingForm = rec == null ? "" : "GIPIS130";
			objGipis130.lineCd = rec == null? "" : rec.lineCd;
			objGipis130.sublineCd = rec == null? "" : rec.sublineCd;
			objGipis130.issCd = rec == null? "" : rec.issCd;
			objGipis130.issueYy = rec == null? "" : rec.issueYy;
			objGipis130.polSeqNo = rec == null? "" : rec.polSeqNo;
			objGipis130.renewNo = rec == null? "" : rec.renewNo;
			objGipis130.callSw = rec == null ? "" : "Y";
			objGipis130.postFlag = rec == null ? "" : rec.postFlag; //added by robert SR 4887 10.05.15
		} catch (e) {
			showErrorMessage("setDetailsForm", e);
		}
	}
	
	function checkLineSU(rec){
		try{
			if (rec != null && rec.lineCd == "SU") {
				document.getElementById('mtgIHC'+tbgViewDistStatus._mtgId+'_2').innerHTML = 'Bond Number' + '<span id=' + '"mtgSortIcon'+tbgViewDistStatus._mtgId+'_2"' + 'style=' + '"width:8px;height:4px;visibility:hidden"' + '>   </span>';
			} else {
				document.getElementById('mtgIHC'+tbgViewDistStatus._mtgId+'_2').innerHTML = "Policy Number" + '<span id=' + '"mtgSortIcon'+tbgViewDistStatus._mtgId+'_2"' + 'style=' + '"width:8px;height:4px;visibility:hidden"' + '>   </span>';
			}
		} catch(e){
			showErrorMessage("checkLineSU", e);
		}
	}
	
	function disableFormButton(){
		disableToolbarButton("btnToolbarExecuteQuery");
		disableToolbarButton("btnToolbarPrint");
	}
	
	function execute(){
		objGipis130.credBranch = $F("txtCredBranch");
		objGipis130.filterLineCd = $F("filterLineCd");
		objGipis130.distFlag = getDistFlag();
		objGipis130.dateParams = getDateParams();
		objGipis130.dateOpt = getDateOpt();
		objGipis130.filterSublineCd = $F("txtSublineCd"); // added by robert SR 4887 09.18.15
		objGipis130.filterIssCd = $F("txtIssCd"); // added by robert SR 4887 09.18.15
		objGipis130.filterIssueYy = $F("txtIssueYy"); // added by robert SR 4887 09.18.15
		objGipis130.filterPolSeqNo = $F("txtPolSeqNo"); // added by robert SR 4887 09.18.15
		objGipis130.filterRenewNo = $F("txtRenewNo"); // added by robert SR 4887 09.18.15
		
		if($("rdoAsOf").checked){
			objGipis130.dateTag = "A";
			objGipis130.dateAsOf = $("txtAsOf").value;
			objGipis130.dateFrom = "";
			objGipis130.dateTo = "";
		} else {
			objGipis130.dateTag = "F";
			objGipis130.dateAsOf = "";
			objGipis130.dateFrom = $("txtFrom").value;
			objGipis130.dateTo = $("txtTo").value;
		}
		// added getAdditionalParam() by robert SR 4887 09.18.15
		tbgViewDistStatus.url = contextPath + "/GIPIPolbasicController?action=showViewDistributionStatus&refresh=1&branchCd=" + $F("txtCredBranch") + "&lineCd=" + $F("filterLineCd") + getDistFlag() + getDateParams() + getDateOpt() + "&policyId="+policyInfoPolicyId+"&callingModule="+callingModule+getAdditionalParam();
		tbgViewDistStatus._refreshList();
		if(callingModule == "GIPIS100"){
			disableToolbarButton("btnToolbarEnterQuery");
		} else {
			enableToolbarButton("btnToolbarEnterQuery");	
		}
		
		if (objUWGlobal.previousModule != null) disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
	}
	
	function resetForm(){
		$("txtCredBranch").value = "";
		$("txtLineCd").value = "";
		$("txtSublineCd").value = ""; // added by robert SR 4887 09.18.15
		$("txtIssCd").value = ""; // added by robert SR 4887 09.18.15
		$("txtIssueYy").value = ""; // added by robert SR 4887 09.18.15
		$("txtPolSeqNo").value = ""; // added by robert SR 4887 09.18.15
		$("txtRenewNo").value = ""; // added by robert SR 4887 09.18.15
		$("txtDistNo").value = ""; // added by robert SR 20756 01.27.16
		$("txtEndtIssCd").value = ""; // added by robert SR 20756 01.27.16
		$("txtEndtYy").value = ""; // added by robert SR 20756 01.27.16
		$("txtEndtSeqNo").value = ""; // added by robert SR 20756 01.27.16
		$("filterLineCd").value = "";
		enableSearch("searchLineCd");
		enableSearch("searchCredBranch"); // added by robert SR 20756 01.27.16
		tbgViewDistStatus.url = contextPath + "/GIPIPolbasicController?action=showViewDistributionStatus&refresh=1&clear=1";
		tbgViewDistStatus._refreshList();
		disableToolbarButton("btnToolbarExecuteQuery");
		disableToolbarButton("btnToolbarEnterQuery");
		$("rdoInceptDate").checked = true;
		$("rdoAsOf").checked = true;
		$("rdoAllPolicies").checked = true;
		$("rdoAsOf").disabled = false;
		$("rdoFrom").disabled = false;
		$("txtCredBranch").readOnly = false;
		$("searchLineCd").disabled = false;
		$("txtAsOf").value = dateFormat(dateToday, "mm-dd-yyyy");
		disableFromToFields();
		onSearch = false;
		objUW.callingForm = "";
		objGipis130.lineCd = "";
		objGipis130.sublineCd = "";
		objGipis130.issCd = "";
		objGipis130.issueYy = "";
		objGipis130.polSeqNo = ""; 
		objGipis130.renewNo = "";
		objGipis130.callSw = "";
		objGipis130.withQuery = "";
		objGipis130.credBranch = "";
		objGipis130.filterLineCd = "";
		objGipis130.distFlag = "";
		objGipis130.dateOpt = "";
		objGipis130.dateParams = "";
		objGipis130.dateTag = "";
		objGipis130.dateAsOf = "";
		objGipis130.dateFrom = "";
		objGipis130.dateTo = "";
		$("txtLineCd").readOnly = false; // added by robert SR 4887 09.18.15
		$("txtSublineCd").readOnly = false; // added by robert SR 4887 09.18.15
		$("txtIssCd").readOnly = false; // added by robert SR 4887 09.18.15
		$("txtIssueYy").readOnly = false; // added by robert SR 4887 09.18.15
		$("txtPolSeqNo").readOnly = false; // added by robert SR 4887 09.18.15
		$("txtRenewNo").readOnly = false; // added by robert SR 4887 09.18.15
		$("txtDistNo").readOnly = false; // added by robert SR 20756 01.27.16
		$("txtEndtIssCd").readOnly = false; // added by robert SR 20756 01.27.16
		$("txtEndtYy").readOnly = false; // added by robert SR 20756 01.27.16
		$("txtEndtSeqNo").readOnly = false; // added by robert SR 20756 01.27.16
	}
	
	function getDateOpt(){
		var dateOpt = "&dateOpt=";
		if($("rdoInceptDate").checked){
			dateOpt = dateOpt + "inceptDate";
		} else if ($("rdoIssueDate").checked){
			dateOpt = dateOpt + "issueDate";
		} else {
			dateOpt = dateOpt + "effDate";
		}
		return dateOpt;
	}
	
	function getDateParams(){
		var dateParams = "&dateAsOf=" + $("txtAsOf").value +
		 				 "&dateFrom=" + $("txtFrom").value +
						 "&dateTo=" + $("txtTo").value;
		return dateParams;
	}
	
	function getDistFlag(){
		var distTag = "&distTag=";
		if($("rdoUWOFacul").checked){
			return distTag + "1";
		} else if($("rdoUWFacul").checked) {
			return distTag + "2";
		} else if($("rdoUAll").checked) {
			return distTag + "6";
		} else if($("rdoNegated").checked) {
			return distTag + "4";
		} else if($("rdoRedistributed").checked) {
			return distTag + "5";
		} else if($("rdoPDWOFacul").checked) {
			return distTag + "7";
		} else if($("rdoPDWFacul").checked) {
			return distTag + "8";
		} else if($("rdoPDAll").checked) {
			return distTag + "3";
		} else {
			return distTag + "9";
		}
			
	}
	
	function disableFromToFields(){
		$("txtAsOf").disabled = false;
		$("imgAsOf").disabled = false;
		$("txtFrom").disabled = true;
		$("txtTo").disabled = true;
		$("imgFrom").disabled = true;
		$("imgTo").disabled = true;
		$("txtFrom").value = "";
		$("txtTo").value = "";
		$("rdoAsOf").checked = true;
		$("txtAsOf").value = getCurrentDate();
		disableDate("imgFrom");
		disableDate("imgTo");
		enableDate("imgAsOf");
		$("txtFrom").setStyle({backgroundColor: '#F0F0F0'});
		$("divFrom").setStyle({backgroundColor: '#F0F0F0'});
		$("txtTo").setStyle({backgroundColor: '#F0F0F0'});
		$("divTo").setStyle({backgroundColor: '#F0F0F0'});
		$("txtAsOf").setStyle({backgroundColor: 'white'});
		$("divAsOf").setStyle({backgroundColor: 'white'});
	}
	
	function disableAsOfFields() {
		$("txtFrom").disabled = false;
		$("imgFrom").disabled = false;
		$("imgTo").disabled = false;
		$("txtTo").disabled = false;
		$("txtAsOf").disabled = true;
		$("imgAsOf").disabled = true;
		$("txtAsOf").value = "";
		$("rdoFrom").checked = true;
		disableDate("imgAsOf");
		enableDate("imgFrom");
		enableDate("imgTo");
		$("txtFrom").setStyle({backgroundColor: '#FFFACD'});
		$("divFrom").setStyle({backgroundColor: '#FFFACD'});
		$("txtTo").setStyle({backgroundColor: '#FFFACD'});
		$("divTo").setStyle({backgroundColor: '#FFFACD'});
		$("txtAsOf").setStyle({backgroundColor: '#F0F0F0'});
		$("divAsOf").setStyle({backgroundColor: '#F0F0F0'});
	}
	
	function disableFields() {
		$("txtAsOf").disabled = true;
		$("imgAsOf").disabled = true;
		$("txtFrom").disabled = true;
		$("txtTo").disabled = true;
		$("imgFrom").disabled = true;
		$("imgTo").disabled = true;
		disableDate("imgFrom");
		disableDate("imgTo");
		disableDate("imgAsOf");
		disableSearch("searchLineCd");
		disableSearch("searchCredBranch"); //added by robert SR 20756 01.27.16
		$("txtFrom").setStyle({backgroundColor: '#F0F0F0'});
		$("divFrom").setStyle({backgroundColor: '#F0F0F0'});
		$("txtTo").setStyle({backgroundColor: '#F0F0F0'});
		$("divTo").setStyle({backgroundColor: '#F0F0F0'});
		$("txtAsOf").setStyle({backgroundColor: '#F0F0F0'});
		$("divAsOf").setStyle({backgroundColor: '#F0F0F0'});
		$("rdoAsOf").disabled = true;
		$("rdoFrom").disabled = true;
		$("txtCredBranch").readOnly = true;
		disableToolbarButton("btnToolbarExecuteQuery");
		enableToolbarButton("btnToolbarEnterQuery");
		onSearch = true;
		$("txtLineCd").readOnly = true; // added by robert SR 4887 09.18.15
		$("txtSublineCd").readOnly = true; // added by robert SR 4887 09.18.15
		$("txtIssCd").readOnly = true; // added by robert SR 4887 09.18.15
		$("txtIssueYy").readOnly = true; // added by robert SR 4887 09.18.15
		$("txtPolSeqNo").readOnly = true; // added by robert SR 4887 09.18.15
		$("txtRenewNo").readOnly = true; // added by robert SR 4887 09.18.15
		$("txtDistNo").readOnly = true; // added by robert SR 20756 01.27.16
		$("txtEndtIssCd").readOnly = true; // added by robert SR 20756 01.27.16
		$("txtEndtYy").readOnly = true; // added by robert SR 20756 01.27.16
		$("txtEndtSeqNo").readOnly = true; // added by robert SR 20756 01.27.16
	}
	
	function validateRequiredDates(){
		if($("rdoFrom").checked){
			if($("txtFrom").value == ""){
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.INFO, "txtFrom");
				return false;	
			}
			else if($("txtTo").value == ""){
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.INFO, "txtTo");
				return false;
			}
		}
		return true;
	}
	
	$("txtFrom").observe("focus", function(){
		if ($("imgFrom").disabled == true) return;
		var fromDate = $F("txtFrom") != "" ? new Date($F("txtFrom").replace(/-/g,"/")) :"";
		var sysdate = new Date();
		var toDate = $F("txtTo") != "" ? new Date($F("txtTo").replace(/-/g,"/")) :"";
		if (fromDate > sysdate && fromDate != ""){
			customShowMessageBox("Date should not be greater than the current date.", "I", "txtFrom");
			$("txtFrom").clear();
			$("txtTo").clear();
			return false;
		}
		if (toDate < fromDate && toDate != ""){
			customShowMessageBox("TO Date should not be less than the FROM date.", "I", "txtTo");
			$("txtFrom").clear();
			$("txtTo").clear();
			return false;
		}
	});
	
	$("txtTo").observe("focus", function(){
		if ($("imgTo").disabled == true) return;
		var toDate = $F("txtTo") != "" ? new Date($F("txtTo").replace(/-/g,"/")) :"";
		var fromDate = $F("txtFrom") != "" ? new Date($F("txtFrom").replace(/-/g,"/")) :"";
		var sysdate = new Date();
		if (toDate > sysdate && toDate != ""){
			customShowMessageBox("Date should not be greater than the current date.", "I", "txtTo");
			$("txtTo").clear();
			return false;
		}
		if (toDate < fromDate && toDate != ""){
			customShowMessageBox("TO Date should not be less than FROM date.", "I", "txtTo");
			$("txtTo").clear();
			return false;
		}
		if(fromDate=="" && toDate!=""){
			customShowMessageBox("Please enter FROM date first.", "I", "txtTo");
			$("txtTo").clear();
			$("txtFrom").clear();
			return false;
		}
	});
	
	$("imgAsOf").observe("click", function() {
		if ($("imgAsOf").disabled == true)
			return;
		scwShow($('txtAsOf'), this, null);
	});
	
	$("imgFrom").observe("click", function() {
		if ($("imgFrom").disabled == true)
			return;
		scwShow($('txtFrom'), this, null);
	});
	
	$("imgTo").observe("click", function() {
		if ($("imgTo").disabled == true)
			return;
		scwShow($('txtTo'), this, null);
	});
	
	$("rdoInceptDate").observe("click", function(){
		if(onSearch){
			execute();
		}
	});
	
	$("rdoIssueDate").observe("click", function(){
		if(onSearch){
			execute();
		}
	});
	
	$("rdoEffDate").observe("click", function(){
		if(onSearch){
			execute();
		}
	});
	
	$("txtLineCd").setAttribute("lastValidValue", "");
	$("searchLineCd").observe("click", function(){
		/* showLineCdLOV2("", "GIPIS130", function(row) {
			$("txtLineCd").value = unescapeHTML2(row.lineCd);
			$("filterLineCd").value = unescapeHTML2(row.lineCd);
			enableToolbarButton("btnToolbarExecuteQuery");
			
			if (row.lineCd == "SU") {
				document.getElementById('mtgIHC1_2').innerHTML = 'Bond Number' + '<span id=' + '"mtgSortIcon1_2"' + 'style=' + '"width:8px;height:4px;visibility:hidden"' + '>   </span>';
			} else {
				document.getElementById('mtgIHC1_2').innerHTML = "Policy Number" + '<span id=' + '"mtgSortIcon1_2"' + 'style=' + '"width:8px;height:4px;visibility:hidden"' + '>   </span>';
			}
		}); */
		showGipis130LineCd();
	});
	
	$("txtLineCd").observe("keyup", function(){
		$("txtLineCd").value = $F("txtLineCd").toUpperCase();
	});
	
	$("txtLineCd").observe("change", function() {		
		if($F("txtLineCd").trim() == "") {
			$("txtLineCd").value = "";
			$("txtLineCd").setAttribute("lastValidValue", "");
		} else {
			if($F("txtLineCd").trim() != "" && $F("txtLineCd") != $("txtLineCd").readAttribute("lastValidValue")) {
				//showGipis130LineCd(); replaced by codes below by robert SR 4887 10.05.15
				new Ajax.Request(contextPath+"/GICLClaimsController", {
				method: "POST",
				parameters: {action : "validateGICLS010Line",
				     		moduleId : "GIPIS130",
				     		lineCd : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : "")},
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var valid = response.responseText;
						if(valid=="N"){
							$("txtLineCd").value = "";
							$("txtLineCd").setAttribute("lastValidValue", "");
							showGipis130LineCd();
						}else{
							$("filterLineCd").value = $F("txtLineCd");
							enableToolbarButton("btnToolbarExecuteQuery");
							if ($("txtLineCd") == "SU") {
								document.getElementById('mtgIHC'+tbgViewDistStatus._mtgId+'_2').innerHTML = 'Bond Number' + '<span id=' + '"mtgSortIcon'+tbgViewDistStatus._mtgId+'_2"' + 'style=' + '"width:8px;height:4px;visibility:hidden"' + '>   </span>';
							} else {
								document.getElementById('mtgIHC'+tbgViewDistStatus._mtgId+'_2').innerHTML = "Policy Number" + '<span id=' + '"mtgSortIcon'+tbgViewDistStatus._mtgId+'_2"' + 'style=' + '"width:8px;height:4px;visibility:hidden"' + '>   </span>';
							}
						}
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			}); 
			}
		}
	});
	
	function showGipis130LineCd(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "showGipis130LineCd",
				moduleId :  "GIPIS130",
				filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
				page : 1
			},
			title: "Valid Values for Line Code.",
			width: 500,
			height: 400,
			columnModel : [
				{
					id : "lineCd",
					title: "Line Code",
					width: '100px',
					filterOption: true
				},
				{
					id : "lineName",
					title: "Line Name",
					width: '325px',
					renderer: function(value) {
						return unescapeHTML2(value);
					}
				}
			],
			autoSelectOneRecord: true,
			filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
			onSelect: function(row) {
				$("txtLineCd").value = unescapeHTML2(row.lineCd);
				$("filterLineCd").value = unescapeHTML2(row.lineCd);
				enableToolbarButton("btnToolbarExecuteQuery");
				$("txtLineCd").focus(); // added by robert SR 4887 09.18.15
				if (row.lineCd == "SU") {
					document.getElementById('mtgIHC'+tbgViewDistStatus._mtgId+'_2').innerHTML = 'Bond Number' + '<span id=' + '"mtgSortIcon'+tbgViewDistStatus._mtgId+'_2"' + 'style=' + '"width:8px;height:4px;visibility:hidden"' + '>   </span>';
				} else {
					document.getElementById('mtgIHC'+tbgViewDistStatus._mtgId+'_2').innerHTML = "Policy Number" + '<span id=' + '"mtgSortIcon'+tbgViewDistStatus._mtgId+'_2"' + 'style=' + '"width:8px;height:4px;visibility:hidden"' + '>   </span>';
				}								
			},
			onCancel: function (){
				$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				$("txtLineCd").focus(); // added by robert SR 4887 09.18.15
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
			},
			onShow : function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		});
	}
	
	$("btnToolbarEnterQuery").observe("click", resetForm);
	$("rdoAsOf").observe("click", disableFromToFields);
	$("rdoFrom").observe("click", disableAsOfFields);	
	$("btnViewHistory").observe("click", viewHistory);
	$("btnViewDistribution").observe("click", viewDistribution);
	$("btnSummarizedDist").observe("click", callExtractDistGipis130);
	
	function viewHistory(){
		viewHistoryOverlay = Overlay.show(contextPath + "/GIPIPolbasicController", {
			urlContent: true,
            draggable: true,
            urlParameters: {
                    action		: "viewHistory",
                    ajax        : "1",
                    parId       : parId,
            },
            title: "Policy History",
        	height: 400,
        	width: 500
		});
	}
	
	function viewDistribution(){
		viewDistributionOverlay = Overlay.show(contextPath + "/GIPIPolbasicController", {
			urlContent: true,
            draggable: true,
            urlParameters: {
                    action		 : "viewDistribution",
                    parId        : parId,
                    distNo       : distNo,
                    distFlag     : distFlag,
                    policyNo     : policyNo,
                    policyStatus : status,
                    lineCd       : $F("hidLineCd"),
                    sublineCd    : $F("hidSublineCd"),
                    issCd        : $F("hidIssCd"),
                    issueYy      : $F("hidIssueYy"),
                    polSeqNo     : $F("hidPolSeqNo"),
                    renewNo      : $F("hidRenewNo")
            },
            title: objGipis130.postFlag == 'O' ? "Policy Distribution" : "Peril Distribution", //added condition by robert to correct Label by robert SR 4887 10.05.15
        	height: 500,
        	width: 720
		});
	}
	
	function viewSummarizedDist(){
		viewSummarizedDistOverlay = Overlay.show(contextPath + "/GIPIPolbasicController", {
			urlContent: true,
            draggable: true,
            urlParameters: {
                    action : "viewSummarizedDist",
                    lineCd : $F("hidLineCd"),
                    sublineCd : $F("hidSublineCd"),
                    issCd : $F("hidIssCd"),
                    issueYy : $F("hidIssueYy"),
                    polSeqNo : $F("hidPolSeqNo"),
                    renewNo : $F("hidRenewNo")
            },
            title: "Summarized Distribution",
        	height: 358,
        	width: 748
		});
	}
	
	function callExtractDistGipis130(){
		new Ajax.Request(contextPath+"/GIPIPolbasicController?action=callExtractDistGipis130",{
			parameters: {
				lineCd : $F("hidLineCd"),
				sublineCd : $F("hidSublineCd"),
				issCd : $F("hidIssCd"),
				issueYy : $F("hidIssueYy"),
				polSeqNo : $F("hidPolSeqNo"),
				renewNo : $F("hidRenewNo"),
				extractDate : $F("txtPAsOf")
			},
			evalScripts: true,
			asynchronous: true,
			onComplete: function(response){
				if(response.responseText == "SUCCESS"){
					viewSummarizedDist();
				}else{
					showMessageBox(response.responseText, "I");
				}
			}
		});
	}
	
	$("btnToolbarExit").observe("click", function() {
		if(callingModule == "GIPIS100"){
			showViewPolicyInformationPage(policyInfoPolicyId);
			objGIPIS100.policyId = null; //benjo 07.21.2015 UCPBGEN-SR-19626
			objGIPIS100.callSw = null; //benjo 07.21.2015 UCPBGEN-SR-19626
		} else {
			objUW.callingForm = "";
			objGipis130.lineCd = "";
			objGipis130.sublineCd = "";
			objGipis130.issCd = "";
			objGipis130.issueYy = "";
			objGipis130.polSeqNo = ""; 
			objGipis130.renewNo = "";
			objGipis130.callSw = "";
			objGipis130.withQuery = "";
			objGipis130.credBranch = "";
			objGipis130.filterLineCd = "";
			objGipis130.distFlag = "";
			objGipis130.dateOpt = "";
			objGipis130.dateParams = "";
			objGipis130.dateTag = "";
			objGipis130.dateAsOf = "";
			objGipis130.dateFrom = "";
			objGipis130.dateTo = "";
			
			if (objUWGlobal.previousModule == null){
				goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
			}else{			
				setModuleId(objUWGlobal.previousModule);
				if (objUWGlobal.previousModule == "GIUWS005"){
					$("preliminaryOneRiskDistMainDiv").show();
					$("summarizedDistDiv").update();
					$("summarizedDistDiv").hide();
					objGIPIS130.details = null;
					objGIPIS130.distNo = null;
					objGIPIS130.distSeqNo = null;
				 }else if (objUWGlobal.previousModule == "GIUWS004"){//Added by Gzelle 06132014
					$("preliminaryOneRiskDistMainDiv").show();
					$("summarizedDistDiv").hide();
					objGIPIS130.details = null;
					objGIPIS130.distNo = null;
					objGIPIS130.distSeqNo = null;			
				} else if (objUWGlobal.previousModule == "GIUWS003"){//edgar 06/10/2014
					$("preliminayPerilDistMainDiv").show();
					$("summarizedDistDiv1").hide();
					objGIPIS130.details = null;
					objGIPIS130.distNo = null;
					objGIPIS130.distSeqNo = null;
					
				}else if(objUWGlobal.previousModule == "GIUWS012"){
					$("distributionByPerilMainDiv").show();
					$("summarizedDistDiv").update();
					$("summarizedDistDiv").hide();
					objGIPIS130.details = null;
					objGIPIS130.distNo = null;
					objGIPIS130.distSeqNo = null;
				}else if(objUWGlobal.previousModule == "GIUWS017"){
					$("distByTsiPremPerilMainDiv").show();
					$("summarizedDistDiv").update();
					$("summarizedDistDiv").hide();
					objGIPIS130.details = null;
					objGIPIS130.distNo = null;
					objGIPIS130.distSeqNo = null;
				}else if(objUWGlobal.previousModule == "GIUWS016"){
					$("distrByTsiPremGroupMainDiv").show();
					$("summarizedDistDiv").update();
					$("summarizedDistDiv").hide();
					objGIPIS130.details = null;
					objGIPIS130.distNo = null;
					objGIPIS130.distSeqNo = null;
				}else if(objUWGlobal.previousModule == "GIUWS013"){
					$("distributionByGroupMainDiv").show();
					$("summarizedDistDiv").update();
					$("summarizedDistDiv").hide();
					objGIPIS130.details = null;
					objGIPIS130.distNo = null;
					objGIPIS130.distSeqNo = null;
				}if (objUWGlobal.previousModule == "GIUWS006"){
					$("preliminayPerilDistMainDiv").show();
					$("summarizedDistDiv").update();
					$("summarizedDistDiv").hide();
					objGIPIS130.details = null;
					objGIPIS130.distNo = null;
					objGIPIS130.distSeqNo = null;
				}
				if(objUWGlobal.previousModule != "GIUWS017"){ //added by steven: di siya kailangan sa module ko.
					$("parInfoMenu").show();
				}
				objUWGlobal.previousModule = null;
			}	
		}
	});
	
	$("btnToolbarExecuteQuery").observe("click", function() {
		if($("txtLineCd").value == "" && $("txtDistNo").value == ""){ //modified condition and message by robert SR 20756 01.27.16
			//showMessageBox("Line Code is required.", imgMessage.INFO); 
			showMessageBox("Please enter a line code or a distribution no.", imgMessage.INFO);
			return false;
		} 
		
		if(validateRequiredDates()){
			disableFields();
			exec = true;
			execute();
		}
	});
	
	$("rdoUWOFacul").observe("click", function(){
		if(onSearch){
			execute();
		}
	});
	
	$("rdoUWFacul").observe("click", function(){
		if(onSearch){
			execute();
		}
	});
	
	$("rdoUAll").observe("click", function(){
		if(onSearch){
			execute();
		}
	});
	
	$("rdoPDWOFacul").observe("click", function(){
		if(onSearch){
			execute();
		}
	});
	
	$("rdoPDWFacul").observe("click", function(){
		if(onSearch){
			execute();
		}
	});
	
	$("rdoPDWFacul").observe("click", function(){
		if(onSearch){
			execute();
		}
	});
	
	$("rdoPDAll").observe("click", function(){
		if(onSearch){
			execute();
		}
	});
	
	$("rdoNegated").observe("click", function(){
		if(onSearch){
			execute();
		}
	});
	
	$("rdoRedistributed").observe("click", function(){
		if(onSearch){
			execute();
		}
	});
	
	$("rdoAllPolicies").observe("click", function(){
		if(onSearch){
			execute();
		}
	});
	
	$("txtAsOf").value = dateFormat(dateToday, "mm-dd-yyyy");
	//$("btnToolbarPrint").hide();
	
	$("btnToolbarPrint").observe("click", function(){
		showGenericPrintDialog("Print Distribution", onOkPrintGipis130, onLoadPrintGipis130, true);
	});
	
	var reports = [];
	function onOkPrintGipis130(){
		var reportId = 'GIUWR130';
		var reportTitle = 'VIEW POLICY DISTRIBUTION REPORT';
		
		if($("distributionSlip").checked){
			reportId = 'GIPIR130';
			reportTitle = 'DISTRIBUTION SLIP';
		}
		
		var content;
		
		content = contextPath+"/GIPIPolbasicPrintController?action=printGipis130&reportId="+reportId+"&printerName="+$F("selPrinter")					
		+"&distNo="+distNo+"&lineCd="+$F("hidLineCd")+getParamsGipis130();
		
		if($F("selDestination") == "screen"){
			reports.push({reportUrl : content, reportTitle : reportTitle});			
		}else if($F("selDestination") == "printer"){
			new Ajax.Request(content, {
				method: "GET",
				parameters : {noOfCopies : $F("txtNoOfCopies"),
						 	 printerName : $F("selPrinter")
						 	 },
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if (checkErrorOnResponse(response)){
					
					}
				}
			});
		}else if($F("selDestination") == "file"){
		    //added by robert SR 5290 01.29.2016
			var fileType = "";
			if($("rdoPdf").checked)
				fileType = "PDF";
			else if ($("rdoCsv").checked)
				fileType = "CSV";
			new Ajax.Request(content, {
				method: "POST",
				parameters : {destination : "file",
							  fileType    : /* $("rdoPdf").checked ? "PDF" : "XLS" */fileType}, //replaced by robert SR 5290 01.29.2016
				evalScripts: true,
				asynchronous: true,
				onCreate: showNotice("Generating report, please wait..."),
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
					    //added by robert SR 5290 01.29.2016
						if($("geniisysAppletUtil") == null || $("geniisysAppletUtil").copyFileToLocal == undefined){
							showMessageBox("Local printer applet is not configured properly. Please verify if you have accepted to run the Geniisys Utility Applet and if the java plugin in your browser is enabled.", imgMessage.ERROR);
						} else {
							var message = "";
							if ($("rdoCsv").checked){
								message = $("geniisysAppletUtil").copyFileToLocal(response.responseText, "csv");
								deleteCSVFileFromServer(response.responseText);
							}else{
								message = $("geniisysAppletUtil").copyFileToLocal(response.responseText, "reports");
							}
							if(message.include("SUCCESS")){
								showMessageBox("Report file generated to " + message.substring(9), "I");	
							} else {
								showMessageBox(message, "E");
							}
						}
					}
				}
			});
		}else if("local" == $F("selDestination")){
			new Ajax.Request(content, {
				method: "POST",
				parameters : {destination : "local"},
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						var message = printToLocalPrinter(response.responseText);
						if(message != "SUCCESS"){
							showMessageBox(message, imgMessage.ERROR);
						}
					}
				}
			});
		}
		if ("screen" == $F("selDestination")) {
			showMultiPdfReport(reports);
			reports = [];
		}
	}
	
	function getParamsGipis130(){
		var param;
		var statusId = ["undistWithoutFacul","undistWithFacul","allPosted","negated","redistributed","allUndist","distWithoutFacul","distWithFacul","allPolicies"]; // modify sequence to print correct record set : shan 05.19.2014
		param = getRdoParams(statusId, "distFlag");
		return param;
	}
	
	function getRdoParams(id, paramName){
		var params = "";
		var j = 1;
		for(var i = 0 ; i < id.length; i++){
			if($(id[i]).checked){		
				params = params + "&"+paramName+"="+j;
				return params;
			}	
			j++;
		}
	}
	
	function onLoadPrintGipis130(){
		var content = "<div class='sectionDiv' style='height: 124px; border: none;'>"+
			"<input type='radio' id='distributionSlip' name='distribution' checked='checked' style='margin-left: 10px; margin-top: 6px; float: left;'/>"+ 
			"<label for='distributionSlip' style='margin-top: 7px;'>Distribution Slip</label>"+
			"<input type='radio' id='policyListing' name='distribution' style='margin-top: 6px; margin-left: 60px; float: left;'/>"+ 
			"<label for='policyListing' style='margin-top: 7px;'>Policy Listing</label>"+
			"<div class='sectionDiv' style='margin-top: 11px; margin-left: 35px; width: 80%; border: none;'><label><b>Status</b></label></div>"+
			"<div class='sectionDiv' style='margin-top: 5px; margin-left: 10px; width: 80%; border: none;'><label>Undistributed</label><label style='margin-left: 44px;'>Distributed</label></div>"+
				"<div class='sectionDiv' style='border: none;'>"+
					"<input type='radio' id='undistWithoutFacul' name='status' checked='checked' style='margin-left: 18px; float: left;'/><label for='undistWithoutFacul' style='margin-top: 3px;'>w/o Facultative</label>"+
					"<input type='radio' id='distWithoutFacul' name='status' style='margin-left: 18px; float: left;'/><label for='distWithoutFacul' style='margin-top: 3px;'>w/o Facultative</label>"+
					"<input type='radio' id='negated' name='status' style='margin-left: 18px; float: left;'/><label for='negated' style='margin-top: 3px;'>Negated</label></div>"+
				"<div class='sectionDiv' style='border: none;'>"+
					"<input type='radio' id='undistWithFacul' name='status' style='margin-left: 18px; float: left;'/><label for='undistWithFacul' style='margin-top: 3px;'>w/ Facultative</label>"+
					"<input type='radio' id='distWithFacul' name='status' style='margin-left: 25px; float: left;'/><label for='distWithFacul' style='margin-top: 3px;'>w/ Facultative</label>"+
					"<input type='radio' id='redistributed' name='status' style='margin-left: 25px; float: left;'/><label for='redistributed' style='margin-top: 3px;'>Redistributed</label></div>"+
				"<div class='sectionDiv' style='border: none;'>"+
					"<input type='radio' id='allUndist' name='status' style='margin-left: 18px; float: left;'/><label for='allUndist' style='margin-top: 3px;'>All Undistributed</label>"+
					"<input type='radio' id='allPosted' name='status' style='margin-left: 11px; float: left;'/><label for='allPosted' style='margin-top: 3px;'>All Posted</label>"+
					"<input type='radio' id='allPolicies' name='status' style='margin-left: 48px; float: left;'/><label for='allPolicies' style='margin-top: 3px;'>All Policies</label></div>"+
			"</div>";
		$("printDialogFormDiv2").update(content); 
		$("printDialogFormDiv2").show();
		$("printDialogMainDiv").up("div",1).style.height = "310px";
		$($("printDialogMainDiv").up("div",1).id).up("div",0).style.height = "342px";
		
		$("distributionSlip").observe("click", function(){
			disableStatus(true);
		});
		$("policyListing").observe("click", function(){
			disableStatus(false);
		});
		
		disableStatus(true);
		$("csvOptionDiv").show(); //added by robert SR 5290 01.29.2016
	}
	
	function disableStatus(boolean){
		$("undistWithoutFacul").disabled = boolean;
		$("undistWithFacul").disabled = boolean;
		$("allUndist").disabled = boolean;
		$("distWithoutFacul").disabled = boolean;
		$("distWithFacul").disabled = boolean;
		$("allPosted").disabled = boolean;
		$("negated").disabled = boolean;
		$("redistributed").disabled = boolean;
		$("allPolicies").disabled = boolean;
	}
		
	if (objUWGlobal.previousModule != null){
		if (objUWGlobal.previousModule == "GIUWS005" ||
			objUWGlobal.previousModule == "GIUWS004" ||
		    objUWGlobal.previousModule == "GIUWS012" ||
		    objUWGlobal.previousModule == "GIUWS017" || 
		    objUWGlobal.previousModule == "GIUWS016" ||						
		    objUWGlobal.previousModule == "GIUWS017" ||
		    objUWGlobal.previousModule == "GIUWS013" ||
		    objUWGlobal.previousModule == "GIUWS006" ||
		    objUWGlobal.previousModule == "GIUWS003"){								
			$("filterLineCd").value = unescapeHTML2(objGIPIS130.details.lineCd);
		}
		
		disableFields();
		exec = true;
		disableToolbarButton("btnToolbarEnterQuery");
	}
	
	if(objGipis130.withQuery == "Y"){
		$("txtCredBranch").value = objGipis130.credBranch;
		$("filterLineCd").value = objGipis130.filterLineCd;
		$("txtLineCd").value = objGipis130.filterLineCd;
		$("txtSublineCd").value = objGipis130.filterSublineCd; // added by robert SR 4887 09.18.15
		$("txtIssCd").value = objGipis130.filterIssCd; // added by robert SR 4887 09.18.15
		$("txtIssueYy").value = objGipis130.filterIssueYy; // added by robert SR 4887 09.18.15
		$("txtPolSeqNo").value = objGipis130.filterPolSeqNo; // added by robert SR 4887 09.18.15
		$("txtRenewNo").value = objGipis130.filterRenewNo; // added by robert SR 4887 09.18.15
		
		if(objGipis130.dateTag == "A"){
			disableFromToFields();
		} else {
			disableAsOfFields();
		}
		$("txtAsOf").value = objGipis130.dateAsOf;
		$("txtFrom").value = objGipis130.dateFrom;
		$("txtTo").value = objGipis130.dateTo;
		
		if(objGipis130.dateOpt == "&dateOpt=inceptDate"){
			$("rdoInceptDate").checked = true;
		} else if(objGipis130.dateOpt == "&dateOpt=issueDate"){
			$("rdoIssueDate").checked = true;
		} else if(objGipis130.dateOpt == "&dateOpt=effDate"){
			$("rdoEffDate").checked = true;
		}
		
		if(objGipis130.distFlag == "&distTag=1"){
			$("rdoUWOFacul").checked = true;
		} else if(objGipis130.distFlag == "&distTag=2"){
			$("rdoUWFacul").checked = true;
		} else if(objGipis130.distFlag == "&distTag=6"){
			$("rdoUAll").checked = true;
		} else if(objGipis130.distFlag == "&distTag=4"){
			$("rdoNegated").checked = true;
		} else if(objGipis130.distFlag == "&distTag=5"){
			$("rdoRedistributed").checked = true;
		} else if(objGipis130.distFlag == "&distTag=7"){
			$("rdoPDWOFacul").checked = true;
		} else if(objGipis130.distFlag == "&distTag=8"){
			$("rdoPDWFacul").checked = true;
		} else if(objGipis130.distFlag == "&distTag=3"){
			$("rdoPDAll").checked = true;
		}
		
		disableFields();
		enableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
	} else {
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		disableButton("btnViewHistory");
		disableButton("btnViewDistribution");
		disableButton("btnSummarizedDist");
		disableToolbarButton("btnToolbarPrint");
		checkLineSU(null);
		
		disableFromToFields();
	}
	
	if(objUWGlobal.previousModule == "GIUWS017"){
		checkLineSU(objGIPIS130.details);
	}else{
		checkLineSU(null);
	}
	// added by robert SR 4887 09.18.15
	$("txtSublineCd").observe("keyup", function(){
		$("txtSublineCd").value = $F("txtSublineCd").toUpperCase();
	});
	
	$("txtIssCd").observe("keyup", function(){
		$("txtIssCd").value = $F("txtIssCd").toUpperCase();
	});
	
	$("txtIssueYy").observe("change", function(){
		if(isNaN($F("txtIssueYy"))){
			$("txtIssueYy").clear();
			customShowMessageBox("Field must be of form 09.", "E", "txtIssueYy");
		}else if($F("txtIssueYy") != ""){
			$("txtIssueYy").value = formatNumberDigits($F("txtIssueYy"),2);
			enableToolbarButton("btnToolbarExecuteQuery");	//added by robert SR 20756 01.27.16
		}
	});
	
	$("txtPolSeqNo").observe("change", function(){
		if(isNaN($F("txtPolSeqNo"))){
			$("txtPolSeqNo").clear();
			customShowMessageBox("Field must be of form 000009.", "E", "txtPolSeqNo");
		}else if($F("txtPolSeqNo") != ""){
			$("txtPolSeqNo").value = formatNumberDigits($F("txtPolSeqNo"),6);
			enableToolbarButton("btnToolbarExecuteQuery");	//added by robert SR 20756 01.27.16
		}
	});
	
	$("txtRenewNo").observe("change", function(){
		if(isNaN($F("txtRenewNo"))){
			$("txtRenewNo").clear();
			customShowMessageBox("Field must be of form 09.", "E", "txtRenewNo");
		}else if($F("txtRenewNo") != ""){
			$("txtRenewNo").value = formatNumberDigits($F("txtRenewNo"),2);
			enableToolbarButton("btnToolbarExecuteQuery");	//added by robert SR 20756 01.27.16
		}
	});
	
	function getAdditionalParam(){
		var paramLineCd = objGIPIS130.details != null ? objGIPIS130.details.lineCd : $F("txtLineCd");
		var paramSublineCd = objGIPIS130.details != null ? objGIPIS130.details.sublineCd : $F("txtSublineCd");
		var paramIssCd = objGIPIS130.details != null ? objGIPIS130.details.issCd : $F("txtIssCd");
		var paramIssueYy = objGIPIS130.details != null ? objGIPIS130.details.issueYy : $F("txtIssueYy");
		var paramPolSeqNo = objGIPIS130.details != null ? objGIPIS130.details.polSeqNo : $F("txtPolSeqNo");
		var paramRenewNo = objGIPIS130.details != null ? objGIPIS130.details.renewNo : $F("txtRenewNo");	
		//added by robert SR 20756 01.27.16
		var distNo = objGIPIS130.details != null ? objGIPIS130.details.distNo : $F("txtDistNo");	
		var endtIssCd = objGIPIS130.details != null ? objGIPIS130.details.endtIssCd : $F("txtEndtIssCd");	
		var endtYy = objGIPIS130.details != null ? objGIPIS130.details.endtYy : $F("txtEndtYy");	
		var endtSeqNo = objGIPIS130.details != null ? objGIPIS130.details.endtSeqNo : $F("txtEndtSeqNo");	
		//added encodeURIComponent to sublineCd by robert SR 21902 03.22.16
		return "&lineCd="+paramLineCd +"&sublineCd="+encodeURIComponent(paramSublineCd) +"&issCd="+paramIssCd+"&issueYy="+paramIssueYy+"&polSeqNo="+paramPolSeqNo+"&renewNo="+paramRenewNo+
					"&distNo="+distNo+"&endtIssCd="+endtIssCd+"&endtYy="+endtYy+"&endtSeqNo="+endtSeqNo;
	}
	// end robert SR 4887 09.18.15
	//added by robert SR 20756 01.27.16
	function showCredBranchLOV() {
		LOV.show({
			controller: "UWRenewalProcessingLOVController",
			urlParameters: {action : "getGiexs001CredBranchLOV",
							lineCd: $F("txtLineCd"),
							moduleId: "GIPIS130",
							filterText : $F("txtCredBranch").trim() != "" ? $F("txtCredBranch").trim() : "%",
							notIn: "",
							page : 1},
			title: "Branch Name",
			width: 380,
			height: 386,
			columnModel: [ {   id: 'recordStatus',
								    title: '',
								    width: '0',
								    visible: false,
								    editor: 'checkbox' 			
								},
								{	id: 'divCtrId',
									width: '0',
									visible: false
								},
								{
									id: 'issCd',
									title: 'Issue Code',
									titleAlign: 'left',
									width: '100px'
								},
								{
									id: 'issName',
									title: 'Issue Name',
									titleAlign: 'left',
									width: '261px'
								}
			              ],
			draggable: true,
			autoSelectOneRecord: true,
			filterText : $F("txtCredBranch").trim() != "" ? $F("txtCredBranch").trim() : "%",
	  		onSelect: function(row){
				 if(row != undefined) {
					$("txtCredBranch").value = unescapeHTML2(row.issCd);
					enableToolbarButton("btnToolbarExecuteQuery");	
				 }
	  		},
	  		onCancel: function (){
	  			$("txtCredBranch").focus();
				$("txtCredBranch").value = "";
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtCredBranch").focus();
				$("txtCredBranch").value = "";
			}
		});
	}
	
	$("searchCredBranch").observe("click", function(){
		showCredBranchLOV();
	});
	
	$("txtIssCd").observe("keyup", function(){
		enableToolbarButton("btnToolbarExecuteQuery");	
	});
	
	$("txtSublineCd").observe("keyup", function(){
		enableToolbarButton("btnToolbarExecuteQuery");	
	});
	
	$("txtDistNo").observe("keyup", function(){
		enableToolbarButton("btnToolbarExecuteQuery");	
	});
	
	$("txtEndtIssCd").observe("change", function(){
		enableToolbarButton("btnToolbarExecuteQuery");	
	});
	
	$("txtEndtYy").observe("change", function(){
		enableToolbarButton("btnToolbarExecuteQuery");	
	});
	
	$("txtEndtSeqNo").observe("change", function(){
		enableToolbarButton("btnToolbarExecuteQuery");	
	});
	
	$("txtCredBranch").observe("change", function () {
		if($F("txtCredBranch") != ""){
			showCredBranchLOV();
		} else {
			$("txtDspCredBranch").value = "";
		}
	});
	//end of codes by robert SR 20756 01.27.16
	initializeAll();
	initializeAccordion();
	initializeAllMoneyFields();	
</script>
