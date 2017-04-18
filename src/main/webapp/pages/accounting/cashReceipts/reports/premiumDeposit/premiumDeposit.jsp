<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="premiumDepositMainDiv">
	<div id="mainNav" name="mainNav">
		<div id="smoothMenu1" name="smoothMenu1" class="ddsmoothmenu">
			<ul> 
				<li><a id="premiumDepositExit">Exit</a></li>
			</ul>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Print Premium Deposit</label>
		</div>
	</div>
	<div id="premiumDepositInput" class="sectionDiv" style="width: 920px; height: 580px;">
		<div class="sectionDiv" style="width: 620px; height:480px; margin: 40px 20px 20px 150px;">
			<div id="checkBoxDiv" class="sectionDiv" style="width: 535px; height: 10px; margin: 10px 0px 0px 13px; padding: 10px 30px 20px 30px;">
				<table align="center" style="height: 20px">
				<tr>
					<td> 
						<div>
							<input id="chkPostingDate" type="checkbox" value="" style="float: left;" tabindex="201"/>
							<label style="margin-left: 7px;" for="chkPostingDate" >Posting Date</label>
						</div>
					</td>
					<td>
						<div>
							<input id="chkTransactionDate" type="checkbox" style="margin-left: 160px; float: left;" value="" tabindex="202"/>
							<label style="margin-left: 7px;" for="chkTransactionDate">Transaction Date</label>
						</div>
					</td>
				</tr>
			</table>
			</div>
			
			<div id="fieldDiv" class="sectionDiv" style="width: 575px; height: 160px; margin: 2px 10px 0px 13px; padding: 10px 10px 25px 10px;">
				<table align="left" style="padding-left: 84px;">
					<tr>
						<td class="rightAligned" style="padding-right: 10px;">Cut Off</td>
						<td>
							<div id="fromDateDiv" style="float: left; border: 1px solid gray; width: 150px; height: 20px;">
								<input type="text" class="required leftAligned date" id="txtCutOff" removeStyle="true" name="cutoff date." readonly="readonly" maxlength="10" style="border: none; float: left; width: 125px; height: 13px; margin: 0px;" value="" tabindex="203"/>
								<img id="imgCutOff" alt="imgCutOff" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtCutOff'),this, null);"/>
							</div> 
						</td>
						<td colspan="2">
							<div style="padding-left: 59px;">
								<input id="chkIncludeCancelled" type="checkbox" style="float: left;" value="X" tabindex="204"/>
								<label id="lblIncludeCancelled" name="lblIncludeCancelled" style="margin-left: 7px;" for="chkIncludeCancelled">Include Cancelled</label>
							</div>
						</td>
					</tr>
				</table>	
				<table align="center" style="padding-left: 58px;">
					<tr>
						<td class="rightAligned" style="padding-right: 10px;">From</td>
						<td>
							<div id="fromDateDiv" style="float: left; border: 1px solid gray; width: 150px; height: 20px;">
								<input id="txtFromDate" name="from date." removeStyle="true" readonly="readonly" type="text" class="required leftAligned date" maxlength="10" style="border: none; float: left; width: 125px; height: 13px; margin: 0px;" value="" tabindex="205"/>
								<img id="imgFromDate" alt="imgFromDate" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtFromDate'),this, null);" />
							</div>
						</td> 
						<td class="rightAligned" style="padding-left: 60px; padding-right: 10px;">To</td>
						<td>
							<div id="toDateDiv" style="float: left; border: 1px solid gray; width: 150px; height: 20px;">
								<input id="txtToDate" name="to date." readonly="readonly" type="text" class="required leftAligned date" maxlength="10" style="border: none; float: left; width: 125px; height: 13px; margin: 0px;" value="" tabindex="206"/>
								<img id="imgToDate" alt="imgToDate" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtToDate'),this, null);" />
							</div>
						</td>
					</tr>
				</table>
				<table align="center">
					<tr height="15px"></tr>
					<tr>
						<td style="padding-right: 10px;">Print Report By:</td>
					</tr>
					<tr>
						<td class="rightAligned" style="padding-right: 10px;">Branch</td>
						<td style="padding-top: 0px;">
							<div style="height: 20px;">
								<div id="branchDiv" style="border: 1px solid gray; width: 90px; height: 20px; margin:0 5px 0 0;">
									<input id="txtBranchCd" name="txtBranchCd" type="text" maxlength="2" class="upper" style="border: none; float: left; width: 60px; height: 13px; margin: 0px;" value="" tabindex="207" lastValidValue=""/>
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranchCdLOV" name="searchBranchCdLOV" alt="Go" style="float: right;"/>
								</div>
								
							</div>						
						</td>	
						<td>
							<!-- <div id="branchNameDiv" style="border: 1px solid gray; width: 290px; height: 20px; margin:0 5px 0 0;"> -->
								<input id="txtBranchName" name="txtBranchName" type="text" maxlength="2" class="upper" style="float: left; width: 284px; height: 13px; margin: 0px;" value="" tabindex="208" lastValidValue="ALL BRANCHES" readonly="readonly"/>
								<%-- <img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranchNameLOV" name="searchBranchNameLOV" alt="Go" style="float: right;"/> --%>
							<!-- </div> -->
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="padding-right: 10px;">Assured</td>
						<td style="padding-top: 0px;">
							<div style="height: 20px;">
								<div id="assuredDiv" style="border: 1px solid gray; width: 90px; height: 20px; margin:0 5px 0 0;">
									<input id="txtAssdNo" name="txtAssdNo" type="text" maxlength="12" class="upper" style="border: none; float: left; width: 60px; height: 13px; margin: 0px;" value="" tabindex="209" lastValidValue=""/>
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchAssdNoLOV" name="searchAssdNoLOV" alt="Go" style="float: right;"/>
								</div>
								
							</div>						
						</td>	
						<td>
							<!-- <div id="assuredNameDiv" style="border: 1px solid gray; width: 290px; height: 20px; margin:0 5px 0 0;"> -->
								<input id="txtAssdName" name="txtAssdName" type="text" maxlength="2" class="upper" style="float: left; width: 284px; height: 13px; margin: 0px;" value="" tabindex="210" lastValidValue="ALL ASSURED" readonly="readonly"/>
								<%-- <img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchAssdNameLOV" name="searchAssdNameLOV" alt="Go" style="float: right;"/> --%>
							<!-- </div> -->
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="padding-right: 10px;">Deposit Flag</td>
						<td style="padding-top: 0px;">
							<div style="height: 20px;">
								<div id="depositFlagDiv" style="border: 1px solid gray; width: 90px; height: 20px; margin:0 5px 0 0;">
									<input id="txtDepositFlag" name="txtDepositFlag" type="text" maxlength="30" class="upper" style="border: none; float: left; width: 60px; height: 13px; margin: 0px;" value="" tabindex="211" lastValidValue=""/>
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchDepositFlagLOV" name="searchDepositFlagLOV" alt="Go" style="float: right;"/>
								</div>
								
							</div>						
						</td>	
						<td>
							<!-- <div id="depositDescDiv" style="border: 1px solid gray; width: 290px; height: 20px; margin:0 5px 0 0;"> -->
								<input id="txtDepositDesc" name="txtDepositDesc" type="text" maxlength="2" class="upper" style="float: left; width: 284px; height: 13px; margin: 0px;" value="" tabindex="212" lastValidValue="ALL DEPOSIT FLAGS" readonly="readonly"/>
								<%-- <img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchDepositDescLOV" name="searchDepositDescLOV" alt="Go" style="float: right;"/> --%>
							<!-- </div> -->
						</td>
					</tr>
				</table>
			</div>
			
			<div class="sectionDiv" style="width: 40%; height: 110px; margin: 2px 2px 10px 13px; padding: 15px 0 15px 0;">				
				<div>
					<table style="padding-left: 20px;">
						<tr>
							<td colspan="2">Show Deposits:</td>
						</tr>
						<tr>	
							<td style="padding-left: 30px; padding-top: 10px; padding-bottom: 10px;">
								<input type="radio" id="A" name="showDeposits" checked="checked" value="A" tabindex="213"/>
							</td>
							<td>
								<label for="A">All(including zero balance)</label>
							</td>
						</tr>
						<tr>
							<td style="padding-left: 30px;">
								<input type="radio" id="B" name="showDeposits" value="B" tabindex="214"/>
							</td>
							<td>
								<label for="B">with remaining balance</label>
							</td>
						</tr>
					</table>
				</div>
			</div>
			
			<div id="printDialogFormDiv" class="sectionDiv" style="width: 50.4%; height: 110px; margin: 2px 0 0 1px; padding: 15px 22px 15px 8px;" align="center">
				<table style="float: left; padding: 1px 0px 0px 15px;">
					<tr>
						<td class="rightAligned">Destination</td>
						<td class="leftAligned">
							<select id="selDestination" style="width: 200px;" tabindex="215">
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
							<input value="PDF" title="PDF" type="radio" id="rdoPdf" name="rdoFileType" style="margin: 2px 5px 4px 40px; float: left;" checked="checked" disabled="disabled" tabindex="216"><label for="pdfRB" style="margin: 2px 0 4px 0">PDF</label>
							<input value="EXCEL" title="Excel" type="radio" id="rdoExcel" name="rdoFileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled" tabindex="217"><label for="excelRB" style="margin: 2px 0 4px 0">Excel</label>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Printer</td>
						<td class="leftAligned">
							<select id="printerName" style="width: 200px;" tabindex="218">
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
							<input type="text" id="txtNoOfCopies" style="float: left; text-align: right; width: 175px;" class="integerNoNegativeUnformattedNoComma" maxlength="3" tabindex="219"/>
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
				<input id="btnExtract" type="button" class="button" value="Extract" style="width: 100px;" tabindex="220"/>
				<input id="btnPrint" type="button" class="button" value="Print" style="width: 100px;" tabindex="221"/>
				<div style="margin-top: 13px;">
					<label id="lblStatus" name="lblStatus" style="width: 100%; text-align: center;"></label>
				</div>
			</div>
		</div>	
	</div>
</div>

<script type="text/javascript">

	setModuleId("GIACS147");
	setDocumentTitle("Print Premium Deposit");
	togglePrintFields("screen");
	initializeAll();
	initializeAccordion();
	makeInputFieldUpperCase();
	var switchParam = "A";
	var okForProcess = null;
	$("txtBranchName").value = "ALL BRANCHES";
	$("txtAssdName").value = "ALL ASSURED";
	$("txtDepositDesc").value = "ALL DEPOSIT FLAGS";
	$("chkIncludeCancelled").hide();
	$("lblIncludeCancelled").innerHTML = "";
	observeBackSpaceOnDate("txtToDate");
	observeBackSpaceOnDate("txtFromDate");
	observeBackSpaceOnDate("txtCutOff");
	initializeLastExtract();
	
	function initializeLastExtract() {
		$("txtFromDate").value = dateFormat('${lastExtractInfo.fromDate}', 'mm-dd-yyyy');
		$("txtToDate").value = dateFormat('${lastExtractInfo.toDate}', 'mm-dd-yyyy');
		$("txtCutOff").value = dateFormat('${lastExtractInfo.toDate}', 'mm-dd-yyyy');
		$("chkTransactionDate").checked = '${lastExtractInfo.transaction}' == 'T' ? lastExtractFuncTran() : false;
		$("chkPostingDate").checked = nvl('${lastExtractInfo.posting}', 'P') == 'P' ? lastExtractFuncPost() : false;
		$("txtBranchCd").value = '${lastExtractInfo.branchCd}';
		$("txtBranchName").value = '${lastExtractInfo.branchName}' == "" ? "ALL BRANCHES" : '${lastExtractInfo.branchName}';
		$("txtAssdNo").value = '${lastExtractInfo.assdNo}';
		$("txtAssdName").value = '${lastExtractInfo.assdName}' == "" ? "ALL ASSURED" : '${lastExtractInfo.assdName}';
		$("txtDepositFlag").value = '${lastExtractInfo.depFlag}';
		$("txtDepositDesc").value = '${lastExtractInfo.depDesc}' == "" ? "ALL DEPOSIT FLAGS" : '${lastExtractInfo.depDesc}';
		'${lastExtractInfo.rdoDep}' == "A" ? $("A").checked = true : $("B").checked = true;
	}

	function lastExtractFuncPost() {
		var check = true;
		$("chkIncludeCancelled").show();
		$("chkPostingDate").value = "P";
		$("chkTransactionDate").value = "X";
		$("lblIncludeCancelled").innerHTML = "Include Cancelled";
		return check;
	}

	function lastExtractFuncTran() {
		var check = true;
		$("chkTransactionDate").value = "T";
		$("chkPostingDate").value = "X";
		return check;
	}

	function checkAllDates() {
		check = true;
		$$("input[type='text'].date").each(function(m) {
			if (m.value == "") {
				check = false;
				customShowMessageBox("Required fields must be entered.", "I",  m.id);
				return false;
			}
		});
		return check;
	}

	function checkLov(action, cd, desc, func, message) {
		if ($(cd).value == "") {
			$(desc).value = message;
		} else {
			var output = validateTextFieldLOV("/AccountingLOVController?action=" + action + "&search=" + $(cd).value, $(cd).value, "Searching, please wait...");
			if (output == 2) {
				func();
			} else if (output == 0) {
				$(cd).clear();
				$(desc).value = message;
				customShowMessageBox("There is no record found.", "I", cd);
			} else {
				func();
			}
		}
	}
	
	function showBranchLov() {
		try {
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGIACS147BranchLov",
					search : ($("txtBranchCd").readAttribute("lastValidValue") != $F("txtBranchCd") ? nvl($F("txtBranchCd"),"%") : "%")
				},
				width : 405,
				height : 386,
				autoSelectOneRecord : true,
				filterText : $("txtBranchCd").value,
				columnModel : [ {
					id : "branchCd",
					title : "Branch Code",
					width : '80px'
				}, {
					id : "branchName",
					title : "Branch Name",
					width : '310px'
				} ],
				draggable : true,
				onSelect : function(row) {
					$("txtBranchCd").value = row.branchCd;
					$("txtBranchName").value = row.branchName;
					$("txtBranchCd").setAttribute("lastValidValue", row.branchCd);
					$("txtBranchName").setAttribute("lastValidValue", row.branchName);
				},onCancel : function() {
					$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
					$("txtBranchName").value = $("txtBranchName").readAttribute("lastValidValue");
				},
				onUndefinedRow : function() {
					customShowMessageBox("No record selected.", "I", "txtBranchCd");	
					$("txtBranchCd").setAttribute("lastValidValue", "");
					$("txtBranchName").setAttribute("lastValidValue", "ALL BRANCHES");
					$("txtBranchCd").value = "";
					$("txtBranchName").value = "ALL BRANCHES";
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();
				}
			});
		} catch (e) {
			showErrorMessage("Branch LOV", e);
		}
	}

	function showAssuredLov() {
		try {
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGIACS147AssuredLov",
					search : ($("txtAssdNo").readAttribute("lastValidValue") != $F("txtAssdNo") ? nvl($F("txtAssdNo"),"%") : "%")
				},
				width : 805,
				height : 386,
				autoSelectOneRecord : true,
				filterText : $("txtAssdNo").value,
				columnModel : [ {
					id : "assdNo",
					title : "Assured No",
					width : '80px'
				}, {
					id : "assdName",
					title : "Assured Name",
					width : '710px'
				} ],
				draggable : true,
				onSelect : function(row) {
					$("txtAssdNo").value = row.assdNo;
					$("txtAssdName").value = unescapeHTML2(row.assdName);
					$("txtAssdNo").setAttribute("lastValidValue", row.assdNo);
					$("txtAssdName").setAttribute("lastValidValue", unescapeHTML2(row.assdName));
				},onCancel : function() {
					$("txtAssdNo").value = $("txtAssdNo").readAttribute("lastValidValue");
					$("txtAssdName").value = $("txtAssdName").readAttribute("lastValidValue");
				},
				onUndefinedRow : function() {
					customShowMessageBox("No record selected.", "I", "txtAssdNo");
					$("txtAssdNo").setAttribute("lastValidValue", "");
					$("txtAssdName").setAttribute("lastValidValue", "ALL ASSURED");
					$("txtAssdNo").value = "";
					$("txtAssdName").value = "ALL ASSURED";
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();
				}
			});
		} catch (e) {
			showErrorMessage("Assured LOV", e);
		}
	}

	function showDepFlagLov() {
		try {
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGIACS147DepFlagLov",
					search : ($("txtDepositFlag").readAttribute("lastValidValue") != $F("txtDepositFlag") ? nvl($F("txtDepositFlag"),"%") : "%")
				},
				width : 405,
				height : 386,
				columnModel : [ {
					id : "rvLowValue",
					title : "Deposit Flag",
					width : '80px'
				}, {
					id : "rvMeaning",
					title : "Meaning",
					width : '310px'
				} ],
				autoSelectOneRecord : true,
				draggable : true,
				filterText : $("txtDepositFlag").value,
				onSelect : function(row) {
					$("txtDepositFlag").value = row.rvLowValue;
					$("txtDepositDesc").value = row.rvMeaning;
					$("txtDepositFlag").setAttribute("lastValidValue", row.rvLowValue);
					$("txtDepositDesc").setAttribute("lastValidValue", row.rvMeaning);
				},onCancel : function() {
					$("txtDepositFlag").value = $("txtDepositFlag").readAttribute("lastValidValue");
					$("txtDepositDesc").value = $("txtDepositDesc").readAttribute("lastValidValue");
				},
				onUndefinedRow : function() {
					customShowMessageBox("No record selected.", "I", "txtDepositFlag");
					$("txtDepositFlag").setAttribute("lastValidValue", "");
					$("txtDepositDesc").setAttribute("lastValidValue", "ALL ASSURED");
					$("txtDepositFlag").value = "";
					$("txtDepositDesc").value = "ALL DEPOSIT FLAGS";
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();
				}
			});
		} catch (e) {
			showErrorMessage("Deposit Flag LOV", e);
		}
	}

	function extractPremiumDeposit(print) {
		try {
			new Ajax.Request(contextPath + "/GIACPremDepositController", {
				parameters : {
					action : "extractPremiumDeposit"
				},
				asynchronous : false,
				evalScripts : true,
				onComplete : function(response) {
					if (checkErrorOnResponse(response)) {
						$("lblStatus").innerHTML = response.responseText;
						if ($("chkTransactionDate").value == "T") {
							extractReversal("extractWidReversal", nvl(print, "N"));
						} else if ($("chkPostingDate").value == "P") {
							if ($("chkIncludeCancelled").value == "X") {
								extractReversal("extractWidReversal", nvl(print, "N"));
							} else if ($("chkIncludeCancelled").value == "E") {
								extractReversal("extractWidNoReversal", nvl(print, "N"));
							}
						}
					}
				}
			});
		} catch (e) {
			showErrorMessage("extractPremiumDeposit", e);
		}
	}

	function extractReversal(action, print) {
		try {
			new Ajax.Request(contextPath + "/GIACPremDepositController", {
				parameters : {
					action : action,
					posting : $("chkPostingDate").value,
					transaction : $("chkTransactionDate").value,
					fromDate : $("txtFromDate").value,
					toDate : $("txtToDate").value,
					branchCd : $("txtBranchCd").value,
					reversal : $("chkIncludeCancelled").value,
					cutOff : $("txtCutOff").value,
					depFlag : $("txtDepositFlag").value,
					assdNo : $("txtAssdNo").value,
					rdoDep : $("A").checked? "A" : "B",
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : showNotice("Extracting, please wait.."),
				onComplete : function(response) {
					hideNotice();
					if (checkErrorOnResponse(response)) {
						$("lblStatus").innerHTML = "Extracting.Checking for reversing transaction.";
						if (nvl(response.responseText, "0") == "0") {
							$("lblStatus").innerHTML = "0 rows inserted to the extract table.";
							showWaitingMessageBox("Extraction finished. No records extracted.", imgMessage.INFO, function() {
								$("lblStatus").innerHTML = "";
								if(print == "Y"){
									printReport();
								}
							});
						} else {
							for ( var i = 0; i < response.responseText; i++) {
								$("lblStatus").innerHTML = (i + 1) + " rows inserted to the extract table.";
							}
							showWaitingMessageBox("Extraction finished. "+response.responseText+" record(s) extracted." , imgMessage.INFO, function() {
								$("lblStatus").innerHTML = "";
								if(print == "Y"){
									printReport();
								}
							});
						}
					}
					okForProcess = 2;
				}
			});
		} catch (e) {
			showErrorMessage("extractReversal", e);
		}
	}

	function includeCancelled(check) {
		if (check) {
			$("chkIncludeCancelled").checked = false;
			$("chkIncludeCancelled").value = "X";
			$("chkIncludeCancelled").show();
			$("lblIncludeCancelled").innerHTML = "Include Cancelled";
		} else {
			$("chkIncludeCancelled").checked = false;
			$("chkIncludeCancelled").value = "X";
			$("chkIncludeCancelled").hide();
			$("lblIncludeCancelled").innerHTML = "";
		}
	}

	function getParams() {
		var params = "&branchCd=" + $("txtBranchCd").value 
			+ "&assdNo=" + $("txtAssdNo").value 
			+ "&fromDate=" + $("txtFromDate").value
			+ "&toDate=" + $("txtToDate").value 
			+ "&depFlag=" + $("txtDepositFlag").value 
			+ "&switch=" + switchParam;
		return params;
	}

	function printReport() {
		try {
			var content = contextPath + "/CashReceiptsReportPrintController?action=printReport" + "&reportId=" + "GIACR161" + getParams();
			if ("screen" == $F("selDestination")) {
				showPdfReport(content, "");
			} else if ($F("selDestination") == "printer") {
				new Ajax.Request(content, {
					parameters : {
						noOfCopies : $F("txtNoOfCopies"),
						printerName : $F("printerName")
					},
					onCreate : showNotice("Processing, please wait..."),
					onComplete : function(response) {
						hideNotice();
						if (checkErrorOnResponse(response)) {
							showWaitingMessageBox("Printing complete.", "S", function(){
								
							});
						}
					}
				});
			} else if ("file" == $F("selDestination")) {
				new Ajax.Request(content, {
					parameters : {
						destination : "file",
						fileType : $("rdoPdf").checked ? "PDF" : "XLS"
					},
					onCreate : showNotice("Generating report, please wait..."),
					onComplete : function(response) {
						hideNotice();
						if (checkErrorOnResponse(response)) {
							/* var message = $("fileUtil").copyFileToLocal(response.responseText);
							if (message != "SUCCESS") {
								showMessageBox(message, imgMessage.ERROR);
							} */
							copyFileToLocal(response, "reports");
						}
					}
				});
			} else if ("local" == $F("selDestination")) {
				new Ajax.Request(content, {
					parameters : {
						destination : "local"
					},
					onComplete : function(response) {
						hideNotice();
						if (checkErrorOnResponse(response)) {
							var message = printToLocalPrinter(response.responseText);
							if (message != "SUCCESS") {
								showMessageBox(message, imgMessage.ERROR);
							}
						}
					}
				});
			}
		} catch (e) {
			showErrorMessage("printReport", e);
		}
	}

	function validateFromAndTo(field) {
		var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g, "/")) : "";
		var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g, "/")) : "";
		var sysdate = new Date();

		if ((fromDate > toDate && toDate != "")) {
			customShowMessageBox("From date must not be later than to date.", "I", "txtToDate");
			$(field).clear();
			return false;
		}

	}

	function compareToLastExtract() {
		if (okForProcess == 2) {
			okForProcess = 2;
		} else {
			if ($("txtFromDate").value == dateFormat('${lastExtractInfo.fromDate}', 'mm-dd-yyyy') && 
			$("txtToDate").value == dateFormat('${lastExtractInfo.toDate}', 'mm-dd-yyyy') &&
			$("txtCutOff").value == dateFormat('${lastExtractInfo.toDate}', 'mm-dd-yyyy') &&
			$("chkTransactionDate").value == '${lastExtractInfo.transaction}' && 
			$("chkPostingDate").value == '${lastExtractInfo.posting}') {
				okForProcess = 1;
			} else {
				okForProcess = 0;
			}
		}
	}

	function checkLastExtract(print) {
		var checkLast = true;
		try {
			new Ajax.Request(contextPath + "/GIACPremDepositController", {
				parameters : {
					action : "checkLastExtract"
				},
				asynchronous : false,
				evalScripts : true,
				onComplete : function(response) {
					if (checkErrorOnResponse(response)) {
						var last = JSON.parse(response.responseText);
						
						if(nvl(print, "N") == "Y" && nvl(last.fromDate, "") == "" && nvl(last.toDate, "") == "" && nvl(last.cutOff, "") == ""){
							checkLast = false;
							showMessageBox("Please extract records first.", "I");
						}else if ($("txtFromDate").value == dateFormat(last.fromDate, 'mm-dd-yyyy') && 
					 		$("txtToDate").value == dateFormat(last.toDate, 'mm-dd-yyyy') &&
							$("txtCutOff").value == dateFormat(last.cutOff, 'mm-dd-yyyy') &&
							$("chkTransactionDate").value == last.transaction && 
							$("chkPostingDate").value == last.posting &&
							$("txtBranchCd").value == nvl(last.branchCd,"") &&
							$("txtAssdNo").value == nvl(last.assdNo, "") &&
							$("txtDepositFlag").value == nvl(last.depFlag,"") &&
							$(last.rdoDep).checked) {
							checkLast = true;
						} else {
							checkLast = false;
						} 
					}
				}
			});
		} catch (e) {
			showErrorMessage("checkLastExtract", e);
		}
		return checkLast;
	}
	
	function togglePrintFields(destination) {
		if (destination == "printer") {
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
			$("rdoExcel").disable();
		} else {
			if (destination == "file") {
				$("rdoPdf").enable();
				$("rdoExcel").enable();
			} else {
				$("rdoPdf").disable();
				$("rdoExcel").disable();
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

	$("imgSpinUp").observe("click", function() {
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		$("txtNoOfCopies").value = no + 1;
	});

	$("imgSpinDown").observe("click", function() {
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		if (no > 1) {
			$("txtNoOfCopies").value = no - 1;
		}
	});

	$("imgSpinUp").observe("mouseover", function() {
		$("imgSpinUp").src = contextPath + "/images/misc/spinupfocus.gif";
	});

	$("imgSpinDown").observe("mouseover", function() {
		$("imgSpinDown").src = contextPath + "/images/misc/spindownfocus.gif";
	});

	$("imgSpinUp").observe("mouseout", function() {
		$("imgSpinUp").src = contextPath + "/images/misc/spinup.gif";
	});

	$("imgSpinDown").observe("mouseout", function() {
		$("imgSpinDown").src = contextPath + "/images/misc/spindown.gif";
	});
	
	$("btnExtract").observe("click", function() {
		if (checkAllDates()) {
			if (checkLastExtract()) {
				showConfirmBox("Extract", "Data has been extracted within the specified parameter/s. Do you wish to continue extraction?", "Yes", "No", extractPremiumDeposit, null, null);
			} else {
				extractPremiumDeposit();
			}
		}
		
	});

	$("btnPrint").observe("click", function() {
		if(checkAllRequiredFieldsInDiv("fieldDiv")){
			if (checkLastExtract("Y")) {
				printReport();
			} else  {
				//showMessageBox("Please extract records first.", imgMessage.INFO);
				/* showConfirmBox("Extract", "The extract table has no data. Would you like to extract first?", "Extract", "Cancel", function() {
					extractPremiumDeposit();
					printReport();
				}, null, null); */
				showConfirmBox("Confirmation", "The specified parameter/s has not been extracted. Do you want to extract the data with the specified parameter/s?", "Yes", "No",
					function(){extractPremiumDeposit("Y");}, null, null);
			}
		}
	});

	$("premiumDepositExit").observe("click", function() {
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	});

	
	$("searchBranchCdLOV").observe("click", showBranchLov);
	
	$("txtBranchCd").observe("change", function() {
		if($("txtBranchCd").value!="" && $("txtBranchCd").value != $("txtBranchCd").readAttribute("lastValidValue")){
			showBranchLov();
		}else if($("txtBranchCd").value == ""){
			$("txtBranchName").value="ALL BRANCHES";
			$("txtBranchCd").setAttribute("lastValidValue", "");
			$("txtBranchName").setAttribute("lastValidValue", "ALL BRANCHES");		
		}
	});	
	
	$("searchAssdNoLOV").observe("click", showAssuredLov);
	
	$("txtAssdNo").observe("change", function() {
		if($("txtAssdNo").value!="" && $("txtAssdNo").value != $("txtAssdNo").readAttribute("lastValidValue")){
			showAssuredLov();
		}else if($("txtAssdNo").value == ""){
			$("txtAssdName").value="ALL ASSURED";
			$("txtAssdNo").setAttribute("lastValidValue", "");
			$("txtAssdName").setAttribute("lastValidValue", "ALL ASSURED");		
		}
	});	
	
	$("searchDepositFlagLOV").observe("click", showDepFlagLov);
	
	$("txtDepositFlag").observe("change", function() {
		if($("txtDepositFlag").value!="" && $("txtDepositFlag").value != $("txtDepositFlag").readAttribute("lastValidValue")){
			showDepFlagLov();
		}else if($("txtDepositFlag").value == ""){
			$("txtDepositDesc").value="ALL DEPOSIT FLAGS";
			$("txtDepositFlag").setAttribute("lastValidValue", "");
			$("txtDepositDesc").setAttribute("lastValidValue", "ALL DEPOSIT FLAGS");		
		}
	});	
	
	$("txtNoOfCopies").observe("change", function() {
		if($F("txtNoOfCopies") == 0 || $F("txtNoOfCopies") > 100){
			customShowMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "I", "txtNoOfCopies");
			$("txtNoOfCopies").value = "";
		}
	});	
	
	
// 	$("searchBranchCdLOV").observe("click", function() {
// 		showBranchLov();
// 	});

// 	$("searchAssdNoLOV").observe("click", function() {
// 		showAssuredLov();
// 	});

// 	$("searchDepositFlagLOV").observe("click", function() {
// 		showDepFlagLov();
// 	});

	$$("input[name='showDeposits']").each(function(btn) {
		btn.observe("click", function() {
			switchParam = $F(btn);
		});
	});

// 	$("txtBranchCd").observe("change", function() {
//		checkLov("getGIACS147BranchLov", "txtBranchCd", "txtBranchName", showBranchLov, "ALL BRANCHES");
// 		showBranchLov();
// 	});

// 	$("txtAssdNo").observe("change", function() {
//		checkLov("getGIACS147AssuredLov", "txtAssdNo", "txtAssdName", showAssuredLov, "ALL ASSURED");
// 		showAssuredLov();
// 	});

// 	$("txtDepositFlag").observe("change", function() {
//		checkLov("getGIACS147DepFlagLov", "txtDepositFlag", "txtDepositDesc", showDepFlagLov, "ALL DEPOSIT FLAGS");
// 		showDepFlagLov();
// 	});

	$("chkTransactionDate").observe("click", function() {
		if (this.checked) {
			$("chkPostingDate").checked = false;
			$("chkPostingDate").value = "X";
			$("chkTransactionDate").value = "T";
			includeCancelled(false);
		} else {
			$("chkPostingDate").checked = true;
			$("chkPostingDate").value = "P";
			$("chkTransactionDate").value = "X";
			includeCancelled(true);
		}
	});

	$("chkPostingDate").observe("click", function() {
		if (this.checked) {
			$("chkTransactionDate").checked = false;
			$("chkTransactionDate").value = "X";
			$("chkPostingDate").value = "P";
			includeCancelled(true);
		} else {
			$("chkTransactionDate").checked = true;
			$("chkTransactionDate").value = "T";
			$("chkPostingDate").value = "X";
			includeCancelled(false);
		}
	});

	$("chkIncludeCancelled").observe("click", function() {
		if (this.checked) {
			$("chkIncludeCancelled").value = "E";
		} else {
			$("chkIncludeCancelled").value = "X";
		}
	});

	$("selDestination").observe("change", function() {
		var destination = $F("selDestination");
		togglePrintFields(destination);
	});

	$("txtFromDate").observe("focus", function() {
		if ($("imgFromDate").disabled == true) return;
		validateFromAndTo("txtFromDate");
	});

	$("txtToDate").observe("focus", function() {
		if ($("imgToDate").disabled == true) return;
		validateFromAndTo("txtToDate");
	});
	
</script>