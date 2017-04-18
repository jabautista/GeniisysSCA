<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="reportedClaimsMainDiv">
	<div id="mainNav" name="mainNav">
		<div id="smoothMenu1" name="smoothMenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="reportedClaimsExit">Exit</a></li>
			</ul>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Reported Claims</label>
		</div>
	</div>
	<div id="reportedClaimsSectionDiv" class="sectionDiv" style="width: 920px; height: 570px;">
		<div class="sectionDiv" style="width: 617px; height:470px; margin: 40px 20px 20px 150px;">
			<div id="fieldDiv" class="sectionDiv" style="width: 575px; height: 100px; margin: 10px 10px 2px 10px; padding: 10px 10px 20px 10px;">
				<table align="left" style="padding-left: 27px;">	
					<tr>
						<td class="rightAligned" style="width: 230px;">
							<input type="radio" name="reportOption" id="rdoByBranch" value="by Branch" title="By Branch" style="float: left; margin-right: 10px;"/>
							<label for="rdoByBranch" tabindex="101" style="float: left; height: 20px; padding-top: 3px; padding-right: 10px;">By Branch</label>
						</td>
						<td class="rightAligned" style="width: 190px;">
							<input type="radio" name="reportOption" id="rdoByEnrollee" value="by Enrollee" title="By Enrolle" style="float: left; margin-right: 10px;"/>
							<label for="rdoByEnrollee" tabindex="106" style="float: left; height: 20px; padding-top: 3px; padding-right: 10px;">By Enrollee</label>
						</td>						
						<td class="rightAligned">
							<input type="radio" name="lossExp" id="rdoLoss" value="L" title="Loss" style="float: left; margin-right: 10px;"/>
							<label for="rdoLoss" tabindex="110" style="float: left; height: 20px; padding-top: 3px; padding-right: 10px;">Loss</label>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">
							<input type="radio" name="reportOption" id="rdoByLine" value="by Line" title="By Line" style="float: left; margin-right: 10px;"/>
							<label for="rdoByLine" tabindex="102" style="float: left; height: 20px; padding-top: 3px; padding-right: 10px;">By Line</label>
						</td>
						<td class="rightAligned">
							<input type="radio" name="reportOption" id="rdoByIntermediary" value="by Intermediary" title="By Intermediary" style="float: left; margin-right: 10px;"/>
							<label for="rdoByIntermediary" tabindex="107" style="float: left; height: 20px; padding-top: 3px; padding-right: 10px;">By Intermediary</label>
						</td>
						<td class="rightAligned">
							<input type="radio" name="lossExp" id="rdoExpense" value="E" title="Expense" style="float: left; margin-right: 10px;"/>
							<label for="rdoExpense" tabindex="111" style="float: left; height: 20px; padding-top: 3px; padding-right: 10px;">Expense</label>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">
							<input type="radio" name="reportOption" id="rdoByAssured" value="by Assured" title="By Assured" style="float: left; margin-right: 10px;"/>
							<label for="rdoByAssured" tabindex="103" style="float: left; height: 20px; padding-top: 3px; padding-right: 10px;">By Assured</label>
						</td>	
						<td class="rightAligned">
							<input type="radio" name="reportOption" id="rdoByClaimStatus" value="by Claim Status" title="By Claim Status" style="float: left; margin-right: 10px;"/>
							<label for="rdoByClaimStatus" tabindex="108" style="float: left; height: 20px; padding-top: 3px; padding-right: 10px;">By Claim Status</label>
						</td>
						<td class="rightAligned">
							<input type="radio" name="lossExp" id="rdoBoth" value="LE" title="Both" style="float: left; margin-right: 10px;"/>
							<label for="rdoBoth" tabindex="112" style="float: left; height: 20px; padding-top: 3px; padding-right: 10px;">Both</label>
						</td>
					</tr>	
					<tr>
						<td class="rightAligned" style="padding-left: 30px;">
							<input type="checkbox" name="sumDet" id="chkSummary" title="Summary" style="float: left; margin-right: 10px;"/>
							<label for="chkSummary" tabindex="104" style="float: left; height: 20px; padding-top: 3px; padding-right: 10px;">Summary</label>
							<input type="checkbox" name="sumDet" id="chkDetail" title="Detail" style="float: left; margin-right: 10px;"/>
							<label for="chkDetail" tabindex="105" style="float: left; height: 20px; padding-top: 3px; padding-right: 10px;">Detail</label>
						</td> 	
						<td class="rightAligned">
							<input type="radio" name="reportOption" id="rdoByPolicyNumber" value="by Policy No" title="By Policy Number" style="float: left; margin-right: 10px;"/>
							<label for="rdoByPolicyNumber" tabindex="109" style="float: left; height: 20px; padding-top: 3px; padding-right: 10px;">By Policy Number</label>
						</td>
					</tr>				
				</table>
			</div>
			<div id="subSectionDiv" class="sectionDiv" style="width: 595px; height: 100px; margin: 0px 2px 2px 10px; padding: 8px 0 22px 0;">			
				<table align="left" style="padding-left: 60px;">	
					<tr>
						<td class="rightAligned" style="padding-right: 10px;">From</td>
						<td style="padding-left: 5px;">
							<div style="float: left; width: 165px; height: 19px;" class="withIconDiv">
								<input type="text" id="txtFromDate" name="txtFromDate" class="withIcon date" readonly="readonly" style="width: 140px; height: 13px;" tabindex="201"/>
								<img id="imgFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" class="hover" onClick="scwShow($('txtFromDate'),this, null);" tabindex="202"/>
							</div>
						</td> 
						<td class="rightAligned" style="padding-right: 10px; padding-left: 66px;">To</td>
						<td>
							<div style="float: left; width: 165px; height: 19px;" class="withIconDiv">
								<input type="text" id="txtToDate" name="txtToDate" class="withIcon date" readonly="readonly" style="width: 140px; height: 13px;" tabindex="203"/>
								<img id="imgToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To Date" class="hover" onClick="scwShow($('txtToDate'),this, null);" tabindex="204"/>
							</div>
						</td>
					</tr>
				</table>
				<div id="byBranchDiv" name="byDiv">
					<table align="left" style="padding-left: 50px; margin-top: 15px;">
						<tr>
							<td class="rightAligned" style="padding-right: 10px;">Branch</td>
							<td class="leftAligned" colspan="4">
								<span class="lovSpan" style="width: 85px; margin-right: 4px; height: 20px;">
									<input type="text" id="txtBranchCd" name="Branch" maxlength="2" style="width: 60px; float: left; border: none; height: 14px; margin: 0;" class="" tabindex="205"/>  
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchBranchCd" name="imgSearchBranch" alt="Go" style="float: right;" tabindex="206"/>
								</span>
								<input type="text" id="txtBranchName" name="Branch" maxlength="20" style="width: 314px; float: left; height: 14px;" class="" readonly="readonly" tabindex="207"/>  
							</td>
						</tr>
						<tr>
							<td class="rightAligned" style="padding-right: 10px;">Line</td>
							<td class="leftAligned" colspan="4">
								<span class="lovSpan" style="width: 85px; margin-right: 4px; height: 20px;">
									<input type="text" id="txtLineCd" name="Line" maxlength="2" style="width: 60px; float: left; border: none; height: 14px; margin: 0;" class="" tabindex="208"/>  
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchLineCd" name="imgSearchLine" alt="Go" style="float: right;" tabindex="209"/>
								</span>
								<input type="text" id="txtLineName" name="Line" maxlength="20" style="width: 314px; float: left; height: 14px; " class="" readonly="readonly" tabindex="210"/>  
							</td>
						</tr>					
					</table>
				</div>
				<div id="byAssuredDiv" name="byDiv">
					<table align="left" style="padding-left: 45px; margin-top: 25px;">
						<tr>
							<td class="rightAligned" style="padding-right: 10px;">Assured</td>
							<td class="leftAligned" colspan="4">
								<span class="lovSpan" style="width: 85px; margin-right: 4px; height: 20px;">
									<input type="text" id="txtAssuredNo" name="Assured" maxlength="12" style="width: 60px; float: left; border: none; height: 14px; margin: 0;" class="rightAligned" tabindex="205"/>  
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchAssuredNo" name="imgSearchAssured" alt="Go" style="float: right;" tabindex="206"/>
								</span>
								<input type="text" id="txtAssuredName" name="Assured" maxlength="500" style="width: 314px; float: left; height: 14px;" class="" readonly="readonly" tabindex="207"/>  
							</td>
						</tr>					
					</table>
				</div>
				<div id="byEnrolleeDiv" name="byDiv">
					<table style="margin-top: 3px; margin-bottom: 10px; margin-left: 33px; float: left;">
						<tr>
							<td align="right">Enrollee</td>
							<td class="leftAligned" style="padding-left: 10px;">
								<input type="text" id="txtEnrollee" name="txtEnrollee" maxlength="50" style="width: 410px; float: left; height: 15px; margin: 0;" tabindex="205"/>
							</td>
						</tr>
						<tr>
							<td align="right">Control Type</td>
							<td class="leftAligned" style="padding-left: 10px;">
								<input type="text" id="txtControlType" name="txtControlType" maxlength="5" style="width: 410px; float: left; height: 15px; margin: 0;" tabindex="206"/>
							</td>
						</tr>
						<tr>
							<td align="right">Control Code</td>
							<td class="leftAligned" style="padding-left: 10px;">
								<input type="text" id="txtControlCode" name="txtControlCode" maxlength="50" style="width: 410px; float: left; height: 15px; margin: 0;" tabindex="207"/>
							</td>
						</tr>
					</table>				
				</div>	
				<div id="byIntermediaryDiv" name="byDiv">
					<table align="left" style="padding-left: 15px; margin-top: 25px;">
						<tr>
							<td class="rightAligned" style="padding-right: 10px;">Intermediary</td>
							<td class="leftAligned" colspan="4">
								<span class="lovSpan" style="width: 85px; margin-right: 4px;">
									<input type="text" id="txtIntmNo" name="Intermediary" maxlength="12" style="width: 60px; float: left; border: none; height: 14px; margin: 0;" class="rightAligned" tabindex="205"/>  
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchIntmNo" name="imgSearchIntm" alt="Go" style="float: right;" tabindex="206"/>
								</span>
								<input type="text" id="txtIntmName" name="Intermediary" maxlength="240" style="width: 314px; float: left; height: 14px; margin: 0;" class="" readonly="readonly" tabindex="207"/>  
							</td>
						</tr>					
					</table>
				</div>
				<div id="byClaimStatusDiv" name="byDiv">
					<table align="left" style="padding-left: 18px; margin-top: 25px;">
						<tr>
							<td class="rightAligned" style="padding-right: 10px;">Claim Status</td>
							<td class="leftAligned" colspan="4">
								<span class="lovSpan" style="width: 85px; margin-right: 4px;">
									<input type="text" id="txtClmStatNo" name="Claim Status" maxlength="2" style="width: 60px; float: left; border: none; height: 14px; margin: 0;" class="" tabindex="205"/>  
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchClmStatNo" name="imgSearchClmStat" alt="Go" style="float: right;" tabindex="206"/>
								</span>
								<input type="text" id="txtClmStatName" name="Claim Status" maxlength="30" style="width: 314px; float: left; height: 14px; margin: 0;" class="" readonly="readonly" tabindex="207"/>
								<input type="hidden" id="txtClmStatType" name="txtClmStatType" maxlength="30" />  
							</td>
						</tr>					
					</table>
				</div>
				<div id="byPolicyDiv" name="byDiv">
					<table align="left" style="padding-left: 15px; margin-top: 25px;">
						<tr>
							<td class="rightAligned" style="">Policy Number</td>
							<td class="leftAligned" colspan="4">
								<span class="lovSpan" style="width: 65px; margin-right: 2px;">
									<input type="text" id="txtPolLineCd" name="Line Code" maxlength="2" style="width: 40px; float: left; border: none; height: 14px; margin: 0;" class="" tabindex="205"/>  
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchPolLineCd" name="imgSearchPolLineCd" alt="Go" style="float: right;" tabindex="206"/>
								</span>
								<span class="lovSpan" style="width: 85px; margin-right: 2px;">
									<input type="text" id="txtPolSublineCd" name="Subline Code" maxlength="7" style="width: 60px; float: left; border: none; height: 14px; margin: 0;" class="" tabindex="207"/>  
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchPolSublineCd" name="imgSearchPolSublineCd" alt="Go" style="float: right;" tabindex="208"/>
								</span>
								<span class="lovSpan" style="width: 65px; margin-right: 3px;">
									<input type="text" id="txtPolIssCd" name="Issue Code" maxlength="2" style="width: 40px; float: left; border: none; height: 14px; margin: 0;" class="" tabindex="209"/>  
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchPolIssCd" name="imgSearchPolIssCd" alt="Go" style="float: right;" tabindex="210"/>
								</span>
								<input type="text" id="txtPolIssueYy" name="txtPolIssueYy" maxlength="2" style="width: 60px; float: left; height: 15px; margin: 0; margin-bottom: 2px; margin-right: 2px;" class="rightAligned" tabindex="211"/>
								<input type="text" id="txtPolSeqNo" name="txtPolSeqNo" maxlength="7" style="width: 80px; float: left; height: 15px; margin: 0; margin-bottom: 2px; margin-right: 2px;" class="rightAligned" tabindex="212"/>
								<input type="text" id="txtPolRenewNo" name="txtPolRenewNo" maxlength="2" style="width: 40px; float: left; height: 15px; margin: 0; margin-bottom: 2px;" class="rightAligned" tabindex="213"/>
							</td>
						</tr>					
					</table>
				</div>
			</div>			
			<div id="printDialogFormDiv" class="sectionDiv" style="width: 91.8%; height: 110px; margin: 0px 2px 0px 10px; padding: 15px 22px 15px 8px;" align="center">
				<table style="float: left; padding: 1px 0px 0px 25.9%;">
					<tr>
						<td class="rightAligned">Destination</td>
						<td class="leftAligned">
							<select id="selDestination" style="width: 200px;" tabindex="301">
								<option value="screen">Screen</option>
								<option value="printer">Printer</option>
								<option value="file">File</option>
								<option value="local">Local Printer</option>
							</select>
						</td>
					</tr>
					<tr>
						<td></td>
						<td>
							<input value="PDF" title="PDF" type="radio" id="rdoPdf" name="rdoFileType" style="margin: 2px 5px 4px 15px; float: left;" checked="checked" disabled="disabled" tabindex="302"><label for="pdfRB" style="margin: 2px 0 4px 0">PDF</label>
							<!-- <input value="EXCEL" title="Excel" type="radio" id="rdoExcel" name="rdoFileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled" tabindex="303"><label for="excelRB" style="margin: 2px 0 4px 0">Excel</label> removed by carlo de guzman 3.28.2016 SR5402 -->
							<input value="CSV" title="CSV" type="radio" id="rdoCsv" name="rdoFileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled" tabindex="303"><label for="csvRB" style="margin: 2px 0 4px 0">CSV</label>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Printer</td>
						<td class="leftAligned">
							<select id="printerName" style="width: 200px;" tabindex="304">
								<option></option>
								<c:forEach var="p" items="${printers}">
									<option value="${p.name}">${p.name}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">No. of Copies</td>
						<td class="leftAligned">
							<input type="text" id="txtNoOfCopies" style="float: left; text-align: right; width: 175px;" class="integerNoNegativeUnformattedNoComma" tabindex="305"/>
							<div style="float: left; width: 15px;">
								<img id="imgSpinUp" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; cursor: pointer;"/>
								<img id="imgSpinUpDisabled" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; display: none;"/>
								<img id="imgSpinDown" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; cursor: pointer;"/>
								<img id="imgSpinDownDisabled" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; display: none;"/>
							</div>					
						</td>
					</tr>
				</table>
			</div> 
			
			<div id="buttonsDiv" class="buttonsDiv" align="center">
				<input id="btnPrint" type="button" class="button" value="Print" style="width: 100px;" tabindex="401"/>
			</div>
		</div>	
</div>
<script type="text/javascript">
	setModuleId("GICLS540");
	setDocumentTitle("Reported Claims");
	var lossExp = "";
	
	function initializeReportedClaims() {
		$("rdoByBranch").checked = true;
		$("chkSummary").checked = true;
		$("chkDetail").checked = true;
		$("rdoLoss").checked = true;
		$("byBranchDiv").show();
		$("byClaimStatusDiv").hide();
	 	$("byIntermediaryDiv").hide();
		$("byEnrolleeDiv").hide();
		$("byAssuredDiv").hide();
		$("byPolicyDiv").hide();
		$("txtFromDate").focus();
		togglePrintFields("screen");
		$("txtBranchName").value = "ALL BRANCHES";
		$("txtLineName").value = "ALL LINES";
		$("txtAssuredName").value = "ALL ASSURED";
		$("txtIntmName").value = "ALL INTERMEDIARIES";
		$("txtClmStatName").value = "ALL CLAIM STATUS";
		observeBackSpaceOnDate("txtFromDate");
		observeBackSpaceOnDate("txtToDate");
	}
	
	function showBranchLOV(text) {
		try {
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getReportedClmBranchLOV",
					lineCd  : $("txtLineCd").value,
					search : $(text).value == "ALL BRANCHES" ? $(text).value = "" : $(text).value
				},
				width : 370,
				height : 390,
				autoSelectOneRecord : true,
				filterText : $(text).value,
				title: "Branch",
				columnModel : [ 
				    {
						id : "issCd",
						title : "Branch Code",
						width : '100px'
					}, 
					{
						id : "issName",
						title : "Branch Name",
						width : '250px'
					}
				],
				draggable : true,
				onSelect : function(row) {
					$("txtBranchCd").value = row.issCd;
					$("txtBranchName").value = row.issName;
				},
				onUndefinedRow : function() {
					showMessageBox("No record selected.", imgMessage.INFO);
				}
			});
		} catch (e) {
			showErrorMessage("Branch LOV", e);
		}
	}
	
	function showLineLOV(text) {
		try {
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getReportedClmLineLOV",
					issCd  : $("txtBranchCd").value,
					search : $(text).value == "ALL LINES" ? $(text).value = "" : $(text).value
				},
				width : 370,
				height : 390,
				autoSelectOneRecord : true,
				filterText : $(text).value,
				title: "Line",
				columnModel : [ 
				    {
						id : "lineCd",
						title : "Line Cd",
						width : '100px'
					}, 
					{
						id : "lineName",
						title : "Line Name",
						width : '250px'
					}
				],
				draggable : true,
				onSelect : function(row) {
					$("txtLineCd").value = row.lineCd;
					$("txtLineName").value = row.lineName;
				},
				onUndefinedRow : function() {
					showMessageBox("No record selected.", imgMessage.INFO);
				}
			});
		} catch (e) {
			showErrorMessage("Line LOV", e);
		}
	}
	
	function showAssuredLOV(text) {
		try {
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getReportedClmAssuredLOV",
					search : $(text).value == "ALL ASSURED" ? $(text).value = "" : $(text).value
				},
				width : 370,
				height : 390,
				autoSelectOneRecord : true,
				filterText : $(text).value,
				title: "Assured",
				columnModel : [ 
				    {
						id : "assuredNo",
						title : "Assd No",
						width : '100px'
					}, 
					{
						id : "assuredName",
						title : "Assured Name",
						width : '250px'
					}
				],
				draggable : true,
				onSelect : function(row) {
					$("txtAssuredNo").value = row.assuredNo;
					$("txtAssuredName").value = unescapeHTML2(row.assuredName);	 //kenneth SR 17610 08122015
				},
				onUndefinedRow : function() {
					showMessageBox("No record selected.", imgMessage.INFO);
				}
			});
		} catch (e) {
			showErrorMessage("Assured LOV", e);
		}
	}

	function showIntermediaryLOV(text) {
		try {
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getReportedClmIntmLOV",
					search : $(text).value == "ALL INTERMEDIARIES" ? $(text).value = "" : $(text).value
				},
				width : 370,
				height : 390,
				autoSelectOneRecord : true,
				filterText : $(text).value,
				title: "Intermediary",
				columnModel : [ 
				    {
						id : "intmNo",
						title : "Intm No",
						width : '100px'
					}, 
					{
						id : "intmName",
						title : "Intermediary Name",
						width : '250px'
					}
				],
				draggable : true,
				onSelect : function(row) {
					$("txtIntmNo").value = row.intmNo;
					$("txtIntmName").value = row.intmName;
				},
				onUndefinedRow : function() {
					showMessageBox("No record selected.", imgMessage.INFO);
				}
			});
		} catch (e) {
			showErrorMessage("Intermediary LOV", e);
		}
	}

	function showClaimStatusLOV(text) {
		try {
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getReportedClmStatLOV",
					search : $(text).value == "ALL CLAIM STATUS" ? $(text).value = "" : $(text).value
				},
				width : 370,
				height : 390,
				autoSelectOneRecord : true,
				filterText : $(text).value,
				title: "Claim Status",
				columnModel : [ 
				    {
						id : "clmStatCd",
						title : "Code",
						width : '100px'
					}, 
					{
						id : "clmStatDesc",
						title : "Description",
						width : '250px'
					}
				],
				draggable : true,
				onSelect : function(row) {
					$("txtClmStatNo").value = row.clmStatCd;
					$("txtClmStatName").value = row.clmStatDesc;
					$("txtClmStatType").value = row.clmStatType;
				},
				onUndefinedRow : function() {
					showMessageBox("No record selected.", imgMessage.INFO);
				}
			});
		} catch (e) {
			showErrorMessage("Claim Status LOV", e);
		}
	}

	function showPolLineLOV() {
		try {
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getReportedClmPolLineLOV",
					polSublineCd : $("txtPolSublineCd").value,
					polIssCd : $("txtPolIssCd").value,
					search : $("txtPolLineCd").value
				},
				width : 370,
				height : 390,
				autoSelectOneRecord : true,
				filterText : $("txtPolLineCd").value,
				title: "Line Code",
				columnModel : [ 
				    {
						id : "polLineCd",
						title : "Line Code",
						width : '350px'
					}
				],
				draggable : true,
				onSelect : function(row) {
					$("txtPolLineCd").value = row.polLineCd;
					$("txtPolSublineCd").focus();
				},
				onUndefinedRow : function() {
					showMessageBox("No record selected.", imgMessage.INFO);
				}
			});
		} catch (e) {
			showErrorMessage("Policy - Line Code LOV", e);
		}
	}
	
	function showPolSublineLOV() {
		try {
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getReportedClmPolSublineLOV",
					polLineCd : $("txtPolLineCd").value,
					polIssCd : $("txtPolIssCd").value,
					search : $("txtPolSublineCd").value
				},
				width : 370,
				height : 390,
				autoSelectOneRecord : true,
				filterText : $("txtPolSublineCd").value,
				title: "Subline Code",
				columnModel : [ 
				    {
						id : "polSublineCd",
						title : "Subline Code",
						width : '350px'
					}
				],
				draggable : true,
				onSelect : function(row) {
					$("txtPolSublineCd").value = row.polSublineCd;
					$("txtPolIssCd").focus();
				},
				onUndefinedRow : function() {
					showMessageBox("No record selected.", imgMessage.INFO);
				}
			});
		} catch (e) {
			showErrorMessage("Policy - Subline Code LOV", e);
		}
	}	

	function showPolIssLOV() {
		try {
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getReportedClmPolIssCdLOV",
					polSublineCd : $("txtPolSublineCd").value,
					polLineCd : $("txtPolLineCd").value,
					search : $("txtPolIssCd").value
				},
				width : 370,
				height : 390,
				autoSelectOneRecord : true,
				filterText : $("txtPolIssCd").value,
				title: "Issue Code",
				columnModel : [ 
				    {
						id : "polIssCd",
						title : "Issue Code",
						width : '350px'
					}
				],
				draggable : true,
				onSelect : function(row) {
					$("txtPolIssCd").value = row.polIssCd;
					$("txtPolIssueYy").focus();
				},
				onUndefinedRow : function() {
					showMessageBox("No record selected.", imgMessage.INFO);
				}
			});
		} catch (e) {
			showErrorMessage("Policy - Issue Code LOV", e);
		}
	}

	function getParentIntmNo() {
		var parentIntmNo = "";
		new Ajax.Request(contextPath + "/GIISIntermediaryController", {
			method: "POST",
			parameters: {
				action : "getParentIntmNo",
				intmNo : $("txtIntmNo").value
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				parentIntmNo = response.responseText;
			}
		});		
		return parentIntmNo;
	}
	
	function togglePrintFields(dest) {
		if (dest == "printer") {
			$("printerName").disabled = false;
			$("txtNoOfCopies").disabled = false;
			$("printerName").addClassName("required");
			$("txtNoOfCopies").addClassName("required");
			$("imgSpinUp").show();
			$("imgSpinDown").show();
			$("imgSpinUpDisabled").hide();
			$("imgSpinDownDisabled").hide();
			$("txtNoOfCopies").value = 1;
			$("rdoPdf").disable();
			//$("rdoExcel").disable();  removed by carlo de guzman 3.28.2016 SR5402
			$("rdoCsv").disabled = true;
		} else {
			if (dest == "file") {
				$("rdoPdf").enable();
				//$("rdoExcel").enable(); removed by carlo de guzman 3.28.2016 SR5402
				$("rdoCsv").disabled = false;
			} else {
				$("rdoPdf").disable();
				//$("rdoExcel").disable(); removed by carlo de guzman 3.28.2016 SR5402
				$("rdoCsv").disabled = true;
			}
			$("printerName").value = "";
			$("txtNoOfCopies").value = "";
			$("printerName").disabled = true;
			$("txtNoOfCopies").disabled = true;
			$("printerName").removeClassName("required");
			$("txtNoOfCopies").removeClassName("required");
			$("imgSpinUp").hide();
			$("imgSpinDown").hide();
			$("imgSpinUpDisabled").show();
			$("imgSpinDownDisabled").show();
		}
	}
	
	function checkSumDet() {
		var sumDet = true;
		$$("input[name='reportOption']").each(function(click) {
			if ($(click).checked == true) {
				if ($("chkSummary").checked == false && $("chkDetail").checked == false) {
					customShowMessageBox("Please select type of report " + click.value + " (Summary or Detail).", imgMessage.INFO, "chkSummary");
					return false;
				}
			}
		});
		return sumDet;
	}
	
	function checkDateParams() {
		check = true;
		if ($("txtFromDate").value == "") {
			check = false;
			customShowMessageBox("Please specify a start date.","I", "txtFromDate");
			return false;
		}else if ($("txtToDate").value == "") {
			check = false;
			customShowMessageBox("Please specify an ending date.","I", "txtToDate");
			return false;
		}validateDate();
		return check;
	}
	
	function validateDate(field) {
		var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g, "/")) : "";
		var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g, "/")) : "";

		if (fromDate > toDate && toDate != "") {
			if (field == "txtFromDate") {
				customShowMessageBox("The ending date must be greater than or equal to the start date. Please change the date parameters.", imgMessage.INFO, "txtFromDate");
			} else {
				customShowMessageBox("The ending date must be greater than or equal to the start date. Please change the date parameters.", imgMessage.INFO, "txtToDate");
			}
			$(field).clear();
			return false;
		}
	}
	
	function getParams() {
		var param = "&lineCd=" + $("txtLineCd").value
				  + "&issCd=" + $("txtBranchCd").value
				  + "&polSublineCd=" + $("txtPolSublineCd").value
				  + "&polIssCd=" + $("txtPolIssCd").value
				  + "&polLineCd=" + $("txtPolLineCd").value;
		return param;
	}
	
	function checkLov(action, cd, desc, func, label) {
		if ($(cd).value == "") {
			$(desc).value = label;
		} else {
			var output = validateTextFieldLOV("/ClaimsLOVController?action=" + action + "&search=" + $(cd).value + getParams(), $(cd).value, "Searching, please wait...");
			if (output == 2) {
				func();
			} else if (output == 0) {
				$(cd).clear();
				$(desc).value = label;
				
				if ($(cd).value == "ALL BRANCHES") {
					$("txtBranchCd").clear();
				} else if ($(cd).value == "ALL LINES") {
					$("txtLineCd").clear();
				} else if ($(cd).value == "ALL ASSURED") {
					$("txtAssuredNo").clear();
				} else if ($(cd).value == "ALL INTERMEDIARIES") {
					$("txtIntmNo").clear();
				}
				
				customShowMessageBox($(cd).getAttribute("name") + " does not exist.", "I", cd);
			} else {
				func();
			}
		}
	}
	
	function defaultValues(check, field, label) {
		if ($(check).value == "") {
			$(field).value = label;
		}
		if ($(field).value == label) {
			$(check).clear();
		}
	}

	function getReportParam() {
		if ($("rdoLoss").checked == true) {
			lossExp = $("rdoLoss").value;
		}else if ($("rdoExpense").checked == true) {
			lossExp = $("rdoExpense").value;
		}else {
			lossExp = $("rdoBoth").value;
		}
		var params = "&fromDate=" 			+ $("txtFromDate").value
					 + "&toDate=" 			+ $("txtToDate").value
					 + "&lineCd=" 			+ $("txtLineCd").value
					 + "&lineName=" 		+ $("txtLineName").value
					 + "&branchCd="	 		+ $("txtBranchCd").value
					 + "&branchName="	 	+ $("txtBranchName").value
					 + "&assdNo=" 			+ $("txtAssuredNo").value
					 + "&assdName=" 		+ encodeURIComponent($("txtAssuredName").value) //kenneth SR 17610 08122015
					 + "&intmNo=" 			+ $("txtIntmNo").value
					 + "&intmName=" 		+ escape($("txtIntmName").value) //added escape function June Mark SR23389 [11.10.16]
// 					 + "&intmType=" 		+ $("txtIntmType").value
					 + "&subAgent=" 		+ getParentIntmNo()
 					 + "&clmStatCd=" 		+ $("txtClmStatNo").value
				     + "&clmStatType=" 		+ $("txtClmStatType").value
					 + "&polIssueYy=" 		+ $("txtPolIssueYy").value
					 + "&polIssCd="		 	+ $("txtPolIssCd").value
					 + "&polSeqNo=" 		+ $("txtPolSeqNo").value
					 + "&polRenewNo=" 		+ $("txtPolRenewNo").value
					 + "&polSublineCd="     + $("txtPolSublineCd").value
					 + "&polLineCd="     + $("txtPolLineCd").value
					 + "&controlCd=" 		+ $("txtControlCode").value
					 + "&controlTypeCd=" 	+ $("txtControlType").value
					 + "&groupedItemTitle=" + $("txtEnrollee").value
					 + "&lossExp=" + lossExp;
		return params;
	}
	
	var reports = [];
	function printReportedClaims() {
		var report = [];
		if ($("rdoByBranch").checked == true) {
			if ($("chkSummary").checked == true) {
				report.push({reportId:"GICLR544B", reportTitle:"Reported Claims Per Branch - Summary"});
			}
			if ($("chkDetail").checked == true) {
				report.push({reportId:"GICLR544", reportTitle:"Reported Claims Per Branch"});
			}
		}else if ($("rdoByLine").checked == true) {
			if ($("chkSummary").checked == true) {
				report.push({reportId:"GICLR541", reportTitle:"Reported Claims - Summary"});
			}
			if ($("chkDetail").checked == true) {
				report.push({reportId:"GICLR540", reportTitle:"Reported Claims - Detailed"});
			}
		}else if ($("rdoByAssured").checked == true) {
			if ($("chkSummary").checked == true) {
				report.push({reportId:"GICLR542B", reportTitle:"Reported Claims Per Assured - Summary"});
			}
			if ($("chkDetail").checked == true) {
				report.push({reportId:"GICLR542", reportTitle:"Reported Claims Per Assured"});
			}
		}else if ($("rdoByIntermediary").checked == true) {
			report.push({reportId:"GICLR543", reportTitle:"Reported Claims Per Intermediary"});
		}else if ($("rdoByClaimStatus").checked == true) {
			/* if ($("chkSummary").checked == true && $F("selDestination") == "file")  {//SR5400
				if($("rdoCsv").checked){//5400
					report.push({reportId:"GICLR545B_CSV", reportTitle:"Reported Claims Per Claim Status - Summary"}); //SR5400
				}else{
					report.push({reportId:"GICLR545B", reportTitle:"Reported Claims Per Claim Status - Summary"});
				}
			}else{
			report.push({reportId:"GICLR545B", reportTitle:"Reported Claims Per Claim Status - Summary"});
			} */ //Deo [01.11.2017]: comment out, prints summary report even when untagged
			if ($("chkSummary").checked == true) { //Deo [01.11.2017]: restore original code
				report.push({reportId:"GICLR545B", reportTitle:"Reported Claims Per Claim Status - Summary"});
			}
			if ($("chkDetail").checked == true) {
				report.push({reportId:"GICLR545", reportTitle:"Reported Claims Per Claim Status"});
			}
		}else if ($("rdoByEnrollee").checked == true) {
			if ($("chkSummary").checked == true) {
				report.push({reportId:"GICLR547B", reportTitle:"Reported Claims Per Enrollee - Summary"});
			}
			if ($("chkDetail").checked == true) {
				report.push({reportId:"GICLR547", reportTitle:"Reported Claims Per Enrollee - Detailed"});
			}
		}else if ($("rdoByPolicyNumber").checked == true) {
			if ($("chkSummary").checked == true) {
				report.push({reportId:"GICLR546B", reportTitle:"Reported Claims Per Policy - Summary"});
			}
			if ($("chkDetail").checked == true) {
				report.push({reportId:"GICLR546", reportTitle:"Reported Claims Per Policy - Detailed"});
			}			
		}
		for(var i=0; i < report.length; i++){
			printReport(report[i].reportId, report[i].reportTitle);	
		}
		if ("screen" == $F("selDestination")) {
			showMultiPdfReport(reports);
			reports = [];
		}
	}

	function printReport(reportId, reportTitle){
		try {
			if(reportId == "GICLR546B" || reportId == "GICLR547B" || reportId == "GICLR546" || reportId == "GICLR545" || reportId == "GICLR545B"){ //start: SR-5402 5-23-2016 //Deo [01.11.2017]: added GICLR545B
				if($F("selDestination") == "file") {
					if ($("rdoCsv").checked) {
						reportId = reportId+"_CSV";
					}
				}
			} 								 //end: SR-5402 5-23-2016
			var content = contextPath + "/PrintReportedClaimsController?action=printReport"
							+"&reportId="+ reportId
							+ getReportParam();
			
			if("screen" == $F("selDestination")){
				reports.push({reportUrl : content, reportTitle : reportTitle});
			}else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					parameters : {noOfCopies : $F("txtNoOfCopies"),
						  	      printerName : $F("printerName")},
					onCreate: showNotice("Processing, please wait..."),				
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							
						}
					}
				});
			} else if("file" == $F("selDestination")){
				var fileType = "PDF";
				
				if($("rdoPdf").checked){
					fileType = "PDF";
				}
				/*else if ($("rdoExcel").checked) removed by carlo de guzman 3.28.2016 SR5402
				fileType = "XLS"; */
				else if (reportId == "GICLR546B_CSV" || reportId == "GICLR546_CSV" || reportId == "GICLR547B_CSV" || reportId == "GICLR545B_CSV"){ //SR-5402, SR-5400
					fileType = "CSV2";
				}
				else if ($("rdoCsv").checked){
					fileType = "CSV";
				}
				
				new Ajax.Request(content, {
					method: "POST",
					parameters : {destination : "FILE",
				         	      fileType    : fileType},
					evalScripts: true,
					asynchronous: true,
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							if ($("rdoCsv").checked){
								copyFileToLocal(response, "csv");
								if(fileType == "CSV"){ //SR-5402
									deleteCSVFileFromServer(response.responseText);
								}
							}else
								copyFileToLocal(response);
						}
					}
				});
			}else if("local" == $F("selDestination")){
				new Ajax.Request(content, {
					parameters : {destination : "local"},
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
		} catch (e){
			showErrorMessage("printReport", e);
		}
	}
	
	function disableSumDet(disable) {
		if (disable) {
			$("chkSummary").disabled = true;
			$("chkDetail").disabled = true;
		}else {
			$("chkSummary").disabled = false;
			$("chkDetail").disabled = false;
		}
	}
	
	function hideDiv(rdo, id) {
		$$("div[name='byDiv']").each(function(div) {
			if ($(rdo).checked == true) {
				if (id == div.id) {
					$(div).show();
				}else {
					$(div).hide();
				}
			}
		});
	}
	
	$("rdoByBranch").observe("click", function() {
		disableSumDet(false);
		hideDiv("rdoByBranch", "byBranchDiv");
	});
	
	$("rdoByLine").observe("click", function() {
		disableSumDet(false);
		hideDiv("rdoByLine", "byBranchDiv");
	});
	
	$("rdoByAssured").observe("click", function() {
		disableSumDet(false);
		hideDiv("rdoByAssured", "byAssuredDiv");
	});
	
	$("rdoByEnrollee").observe("click", function() {
		disableSumDet(false);
		hideDiv("rdoByEnrollee", "byEnrolleeDiv");		
	});
	
	$("rdoByIntermediary").observe("click", function() {
		disableSumDet(true);
		hideDiv("rdoByIntermediary", "byIntermediaryDiv");	
	});
	
	$("rdoByClaimStatus").observe("click", function() {
		disableSumDet(false);
		hideDiv("rdoByClaimStatus", "byClaimStatusDiv");	
	});
	
	$("rdoByPolicyNumber").observe("click", function() {
		disableSumDet(false);
		hideDiv("rdoByPolicyNumber", "byPolicyDiv");	
	});
	
	$("txtFromDate").observe("focus", function() {
		if ($("imgFromDate").disabled == true) return;
		validateDate("txtFromDate");	
	});
	
	$("txtToDate").observe("focus", function() {
		if ($("imgToDate").disabled == true) return;
		validateDate("txtToDate");
	});
	
	$("imgSpinUp").observe("click", function(){
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		$("txtNoOfCopies").value = no + 1;
	});
	
	$("imgSpinDown").observe("click", function(){
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		if(no > 1){
			$("txtNoOfCopies").value = no - 1;
		}
	});
	
	$("imgSpinUp").observe("mouseover", function(){
		$("imgSpinUp").src = contextPath + "/images/misc/spinupfocus.gif";
	});
	
	$("imgSpinDown").observe("mouseover", function(){
		$("imgSpinDown").src = contextPath + "/images/misc/spindownfocus.gif";
	});
	
	$("imgSpinUp").observe("mouseout", function(){
		$("imgSpinUp").src = contextPath + "/images/misc/spinup.gif";
	});
	
	$("imgSpinDown").observe("mouseout", function(){
		$("imgSpinDown").src = contextPath + "/images/misc/spindown.gif";
	});
	
	$("selDestination").observe("change", function(){
		var dest = $F("selDestination");
		togglePrintFields(dest);
	});
	
	$$("input[name='Branch']").each(function(search) {
		search.observe("change", function() {
			if (search.id == "txtBranchCd") {
				checkLov("getReportedClmBranchLOV", "txtBranchCd", "txtBranchName", function() {
					showBranchLOV("txtBranchCd");
				}, "ALL BRANCHES");
			}
		});
	});
	
	$$("img[name='imgSearchBranch']").each(function(search) {
		search.observe("click", function() {
			if (search.id == "imgSearchBranchCd") {
				showBranchLOV("txtBranchCd");
				defaultValues("txtBranchCd", "txtBranchName", "ALL BRANCHES");
			}
		});
	});
	
	$$("input[name='Line']").each(function(search) {
		search.observe("change", function() {
			if (search.id == "txtLineCd") {
				checkLov("getReportedClmLineLOV", "txtLineCd", "txtLineName", function() {
					showLineLOV("txtLineCd");
				}, "ALL LINES");
			}
		});
	});
	
	$$("img[name='imgSearchLine']").each(function(search) {
		search.observe("click", function() {
			if (search.id == "imgSearchLineCd") {
				showLineLOV("txtLineCd");
				defaultValues("txtLineCd", "txtLineName", "ALL LINES");
			}
		});
	});

	$$("input[name='Assured']").each(function(search) {
		search.observe("change", function() {
			if (search.id == "txtAssuredNo") {
				if (isNaN($F("txtAssuredNo")) && $("txtAssuredNo").value != "") {
					showMessageBox("Assured No must be a number.", imgMessage.INFO);
					$(search).clear();
					defaultValues("txtAssuredNo", "txtAssuredName", "ALL ASSURED");
				}else {
					checkLov("getReportedClmAssuredLOV", "txtAssuredNo", "txtAssuredName", function() {
						showAssuredLOV("txtAssuredNo");
					}, "ALL ASSURED");	
				}
			}
		});
	});
	
	$$("img[name='imgSearchAssured']").each(function(search) {
		search.observe("click", function() {
			if (search.id == "imgSearchAssuredNo") {
				showAssuredLOV("txtAssuredNo");
				defaultValues("txtAssuredNo", "txtAssuredName", "ALL ASSURED");
			}
		});
	});
	
	$$("input[name='Intermediary']").each(function(search) {
		search.observe("change", function() {
			if (search.id == "txtIntmNo") {
				if (isNaN($F("txtIntmNo")) && $("txtIntmNo").value != "") {
					showMessageBox("Intm No must be a number.", imgMessage.INFO, "txtIntmNo");
					$(search).clear();
					defaultValues("txtIntmNo", "txtIntmName", "ALL INTERMEDIARIES");
				}else {
					checkLov("getReportedClmIntmLOV", "txtIntmNo", "txtIntmName", function() {
						showIntermediaryLOV("txtIntmNo");
					}, "ALL INTERMEDIARIES");	
				}
			}
		});
	});
	
	$$("img[name='imgSearchIntm']").each(function(search) {
		search.observe("click", function() {
			if (search.id == "imgSearchIntmNo") {
				showIntermediaryLOV("txtIntmNo");
				defaultValues("txtIntmNo", "txtIntmName", "ALL INTERMEDIARIES");
			}
		});
	});

	$$("input[name='Claim Status']").each(function(search) {
		search.observe("change", function() {
			if (search.id == "txtClmStatNo") {
				checkLov("getReportedClmStatLOV", "txtClmStatNo", "txtClmStatName", function() {
					showClaimStatusLOV("txtClmStatNo");
				}, "ALL CLAIM STATUS");
			}
		});
	});
	
	$$("img[name='imgSearchClmStat']").each(function(search) {
		search.observe("click", function() {
			if (search.id == "imgSearchClmStatNo") {
				showClaimStatusLOV("txtClmStatNo");
				defaultValues("txtClmStatNo", "txtClmStatName", "ALL CLAIM STATUS");
			}
		});
	});
	
	$("txtPolLineCd").observe("change", function() {
		checkLov("getReportedClmPolLineLOV", "txtPolLineCd", "txtPolLineCd", showPolLineLOV, "");
	});
	
	$("imgSearchPolLineCd").observe("click", function() {
		showPolLineLOV();
		defaultValues("txtPolLineCd", "txtPolLineCd", "");
	});	

	$("txtPolSublineCd").observe("change", function() {
		checkLov("getReportedClmPolSublineLOV", "txtPolSublineCd", "txtPolSublineCd", showPolSublineLOV, "");
	});
	
	$("imgSearchPolSublineCd").observe("click", function() {
		showPolSublineLOV();
		defaultValues("txtPolSublineCd", "txtPolSublineCd", "");
	});	

	$("txtPolIssCd").observe("change", function() {
		checkLov("getReportedClmPolIssCdLOV", "txtPolIssCd", "txtPolIssCd", showPolIssLOV, "");
	});
	
	$("imgSearchPolIssCd").observe("click", function() {
		showPolIssLOV();
		defaultValues("txtPolIssCd", "txtPolIssCd", "");
	});	
	
	$("txtPolIssueYy").observe("change", function() {
		if(isNaN($F("txtPolIssueYy"))){
			$("txtPolIssueYy").clear();
			customShowMessageBox("Valid value should be from 00 to 99.", imgMessage.INFO, "txtPolIssueYy");
		}else {
			$("txtPolIssueYy").value = formatNumberDigits($F("txtPolIssueYy"), 2);
		}
	});

	$("txtPolSeqNo").observe("change", function() {
		if(isNaN($F("txtPolSeqNo"))){
			$("txtPolSeqNo").clear();
			customShowMessageBox("Valid value should be from 0000000 to 9999999.", imgMessage.INFO, "txtPolSeqNo");
		}else {
			$("txtPolSeqNo").value = formatNumberDigits($F("txtPolSeqNo"), 7);
		}
	});

	$("txtPolRenewNo").observe("change", function() {
		if(isNaN($F("txtPolRenewNo"))){
			$("txtPolRenewNo").clear();
			customShowMessageBox("Valid value should be from 00 to 99.", imgMessage.INFO, "txtPolRenewNo");
		}else {
			$("txtPolRenewNo").value = formatNumberDigits($F("txtPolRenewNo"), 2);
		}
	});
	
	$("btnPrint").observe("click", function() {
		var dest = $F("selDestination");
		if(dest == "printer"){
			if(checkAllRequiredFieldsInDiv("printDialogFormDiv")){
				if (checkDateParams() && checkSumDet()) {
					printReportedClaims();
				}
			}
		}else{
			if (checkDateParams() && checkSumDet()) {
				printReportedClaims();
			}
		}
	});
	
	$("reportedClaimsExit").observe("click", function() {
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
	});
	
	initializeReportedClaims();
	initializeAll();
</script>