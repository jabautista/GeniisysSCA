<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="paidPremiumsPerIntermediaryMainDiv">
	<div id="mainNav" name="mainNav">
		<div id="smoothMenu1" name="smoothMenu1" class="ddsmoothmenu">
			<ul> 
				<li><a id="paidPremiumsPerIntermediaryExit">Exit</a></li>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Paid Premium per Intermediary/Assured </label>   <!--  jhing GENQA 5298,5299 added /Assured in module Title -->
		</div>
	</div>
	<div id="paidPremiumsPerIntermediaryInput" class="sectionDiv" style="width: 920px; height: 470px;">
		<div class="sectionDiv" style="width: 620px; height:385px; margin: 40px 20px 20px 150px;">
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
			
			<div id="fieldDiv" class="sectionDiv" style="width: 575px; height: 145px; margin: 2px 10px 0px 13px; padding: 10px 10px 25px 10px;">
				<table style="padding-left: 20px;">
					<tr>	
						<td style="padding-left: 72px; padding-top: 10px; padding-bottom: 10px;">
							<input type="radio" id="ALL INTERMEDIARIES" name="rdoPer" checked="checked" value="Intermediary" tabindex="213"/>
						</td>
						<td>
							<label for="A">Intermediary</label>
						</td>
						<td style="padding-left: 155px;">
							<input type="radio" id="ALL ASSURED" name="rdoPer" value="Assured" tabindex="214"/>
						</td>
						<td>
							<label for="B">Assured</label>
						</td>
					</tr>
				</table>
				<table align="left">
					<tr>
						<td class="rightAligned" style="padding-right: 10px; padding-left: 56px;">From</td>
						<td>
							<div id="fromDateDiv" style="float: left; border: 1px solid gray; width: 185px; height: 20px;">
								<input id="txtFromDate" name="From Date." readonly="readonly" type="text" class="required leftAligned date" maxlength="10" style="border: none; float: left; width: 160px; height: 13px; margin: 0px;" value="" tabindex="215"/>
								<img id="imgFromDate" alt="imgFromDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtFromDate'),this, null);" />
							</div>
						</td> 
						<td class="rightAligned" style="padding-left: 42px; padding-right: 10px;">To</td>
						<td>
							<div id="toDateDiv" style="float: left; border: 1px solid gray; width: 185px; height: 20px;">
								<input id="txtToDate" name="To Date." readonly="readonly" type="text" class="required leftAligned date" maxlength="10" style="border: none; float: left; width: 160px; height: 13px; margin: 0px;" value="" tabindex="216"/>
								<img id="imgToDate" alt="imgToDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtToDate'),this, null);" />
							</div>
						</td>
					</tr>
				</table>
				<table align="left">
					<tr>
						<td class="rightAligned" style="padding-right: 10px; padding-left: 45px;">Branch</td>
						<td style="padding-top: 0px;">
							<div style="height: 20px;">
								<div id="branchCdDiv" style="border: 1px solid gray; width: 90px; height: 20px; margin:0 5px 0 0;">
									<input id="txtBranchCd" name="txtBranchCd" type="text" maxlength="2" class="upper" style="border: none; float: left; width: 60px; height: 13px; margin: 0px;" value="" tabindex="217" lastValidValue=""/>
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranchCdLOV" name="searchBranchCdLOV" alt="Go" style="float: right;"/>
								</div>
								
							</div>						
						</td>	
						<td>
							<!-- <div id="branchNameDiv" style="border: 1px solid gray; width: 342px; height: 20px; margin:0 5px 0 0;"> -->
								<input id="txtBranchName" name="txtBranchName" readonly="readonly" type="text" maxlength="20" class="upper" style="float: left; width: 336px; height: 13px; margin: 0px;" value="" tabindex="218" lastValidValue=""/>
								<%-- <img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranchNameLOV" name="searchBranchNameLOV" alt="Go" style="float: right;"/> --%>
							<!-- </div> -->
						</td>
					</tr>
				</table>
				<table align="left">
					<tr>
						<td class="rightAligned" style="padding-right: 10px; padding-left: 62px;">Line</td>
						<td style="padding-top: 0px;">
							<div style="height: 20px;">
								<div id="lineCdDiv" style="border: 1px solid gray; width: 90px; height: 20px; margin:0 5px 0 0;">
									<input id="txtLineCd" name="txtLineCd" type="text" maxlength="2" class="upper" style="border: none; float: left; width: 60px; height: 13px; margin: 0px;" value="" tabindex="219" lastValidValue=""/>
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineCdLOV" name="searchLineCdLOV" alt="Go" style="float: right;"/>
								</div>
								
							</div>						
						</td>	
						<td>
							<!-- <div id="lineNameDiv" style="border: 1px solid gray; width: 342px; height: 20px; margin:0 5px 0 0;"> -->
								<input id="txtLineName" name="txtLineName" type="text" readonly="readonly" maxlength="20" class="upper" style="float: left; width: 336px; margin: 0px;" value="" tabindex="220" lastValidValue=""/>
								<%-- <img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineNameLOV" name="searchLineNameLOV" alt="Go" style="float: right;"/> --%>
							<!-- </div> -->
						</td>
					</tr>
				</table>
					<table align="left">
						<tr>
							<td class="rightAligned" style="width: 93px;"><label id="lblPer" name="lblPer" style="float: right; margin-right: 10px;"></label></td>
							<td style="padding-top: 0px;">
								<div style="height: 20px;">
									<div id="intmDiv" style="border: 1px solid gray; width: 90px; height: 20px; margin:0 5px 0 0;">
										<input id="txtIntm" name="txtIntm" type="text" maxlength="12" class="upper" style="border: none; float: left; width: 65px; height: 14px; margin: 0px;" value="" tabindex="221" lastValidValue=""/>
										<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIntmLOV" name="searchIntmLOV" alt="Go" style="float: right;"/>
									</div>
									
								</div>						
							</td>	
							<td>
								<!-- <div id="intmNameDiv" style="border: 1px solid gray; width: 342px; height: 20px; margin:0 5px 0 0;"> -->
									<input id="txtIntmName" name="txtIntmName" readonly="readonly" type="text" maxlength="20" class="upper" style="float: left; width: 336px; margin: 0px;" value="" tabindex="222" lastValidValue=""/>
									<%-- <img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIntmNameLOV" name="searchIntmNameLOV" alt="Go" style="float: right;"/> --%>
								<!-- </div> -->
							</td>
						</tr>
					</table>
				</div>
			
			<div id="printDialogFormDiv" class="sectionDiv" style="width: 96%; height: 135px; margin-top: 2px; margin-left: 13px;" align="center">
				<table style="padding: 15px 0px 0px 0px;">
					<tr>
						<td class="rightAligned">Destination</td>
						<td class="leftAligned">
							<select id="selDestination" style="width: 200px;" tabindex="223">
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
							<input value="PDF" title="PDF" type="radio" id="rdoPdf" name="rdoFileType" style="margin: 2px 5px 4px 15px; float: left;" checked="checked" disabled="disabled" tabindex="224"><label for="pdfRB" style="margin: 2px 0 4px 0">PDF</label>
							<input value="EXCEL" title="Excel" type="radio" id="rdoExcel" name="rdoFileType" style="margin: 2px 4px 4px 25px; float: left;display:none" disabled="disabled" tabindex="225"><label for="excelRB" style="margin: 2px 0 4px 0;display:none">Excel</label>   <!--  jhing GENQA 5299,5298  hide Excel Option-->
							<input value="CSV" title="CSV" type="radio" id="rdoCsv" name="rdoFileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled" tabindex="225"><label for="csvRB" style="margin: 2px 0 4px 0">CSV</label>   <!--  removed ; display: none; jhing GENQA 5299,5298 -->
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Printer</td>
						<td class="leftAligned">
							<select id="printerName" style="width: 200px;" tabindex="226">
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
							<input type="text" id="txtNoOfCopies" style="float: left; text-align: right; width: 175px;" maxlength="3" class="integerNoNegativeUnformattedNoComma" maxlength="30" tabindex="227"/>
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
			
			<div id="buttonsDiv" class="buttonsDiv" align="center" style="padding-top: 10px; bottom: 10px;">
				<input id="btnPrint" type="button" class="button" value="Print" style="width: 100px;" tabindex="228"/>
			</div>
		</div>	
	</div>
</div>

<script>
	setModuleId("GIACS286");
	setDocumentTitle("Paid Premium per Intermediary/Assured");
	observeBackSpaceOnDate("txtToDate");
	observeBackSpaceOnDate("txtFromDate");
	$("txtBranchName").value = "ALL BRANCHES";
	$("txtLineName").value = "ALL LINES";
	$("txtIntmName").value = "ALL INTERMEDIARIES";
	togglePrintFields("screen");
	$("chkTransactionDate").checked = true;
	$("lblPer").innerHTML = "Intermediary";
	$("chkTransactionDate").value = 1;
	var repTitle = null;
	var intmAssd = null;
	var cutOff = 1;
	$("txtBranchCd").focus();
	initializeAll();
	initializeAccordion();
	makeInputFieldUpperCase();
	
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
			$("rdoCsv").disable();
		} else {
			if (destination == "file") {
				$("rdoPdf").enable();
				$("rdoExcel").enable();
				$("rdoCsv").enable();
			} else {
				$("rdoPdf").disable();
				$("rdoExcel").disable();
				$("rdoCsv").disable();
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
	
	$("selDestination").observe("change", function() {
		var destination = $F("selDestination");
		togglePrintFields(destination);
	});
	
	$("txtNoOfCopies").observe("change", function() {
		if($F("txtNoOfCopies") == 0 || $F("txtNoOfCopies") > 100){
			customShowMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "I", "txtNoOfCopies");
			$("txtNoOfCopies").value = "";
		}
	});	
	
	$("imgSpinUp").observe("click", function() {
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		if(no < 100){ 
			$("txtNoOfCopies").value = no + 1;
		}
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
	
	$("paidPremiumsPerIntermediaryExit").observe("click", function() {
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	});

	//checbox and radio button
	function printBy(check1, check2){
		if ($(check1).checked) {
			$(check2).checked = false;
			$(check2).value = "0";
			$(check1).value = "1";
		} else {
			$(check2).checked = true;
			$(check2).value = "1";
			$(check1).value = "0";
		}
	}

	$("chkPostingDate").observe("click", function() {
		printBy("chkPostingDate", "chkTransactionDate");
	});

	$("chkTransactionDate").observe("click", function() {
		printBy("chkTransactionDate", "chkPostingDate");
	});

	$$("input[name='rdoPer']").each(function(btn) {
		btn.observe("click", function() {
			$("lblPer").innerHTML = $F(btn);
			$("txtIntmName").value = $(btn).id;
			$("txtIntm").clear();
		});
	});
	
	//date validation
	function validateFromAndTo(field) {
		var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g, "/")) : "";
		var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g, "/")) : "";
		
		if (fromDate > toDate && toDate != "") {
			customShowMessageBox("From date must not be later than to date.", "I", "txtFromDate");
			$(field).clear();
			return false;
		}
	}

	function checkAllDates() {
		check = true;
		$$("input[type='text'].date").each(function(m) {
			if (m.value == "") {
				check = false;
				customShowMessageBox("Please enter " + m.name, "I", m.id);
				return false;
			}
		});
		return check;
	}

	$("txtFromDate").observe("focus", function() {
		if ($("imgFromDate").disabled == true) return;
		validateFromAndTo("txtFromDate");
	});

	$("txtToDate").observe("focus", function() {
		if ($("imgToDate").disabled == true) return;
		validateFromAndTo("txtToDate");
	});

	//LOV validation
	function checkLov(action, cd, desc, message, func, search, primary) {
		var output = validateTextFieldLOV("/AccountingLOVController?action=" + action + "&search=" + $(cd).value, $(cd).value, "Searching, please wait...");
		if (output == 2) {
			func($(search).value);
		} else if (output == 0) {
			/* $(primary).clear();
			$(desc).value = message;
			customShowMessageBox("There is no record found.", "I", cd); */
			func($(search).value);	// Kenneth L. 10.22.2013 
		} else {
			func($(search).value);
		}
	}
	
	//branch LOV
	function showBranchLov(branchCd) {
		try {
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGiacs286IssLov",
					search : branchCd
				},
				width : 410,
				height : 386,
				autoSelectOneRecord : true,
				filterText : branchCd,
				columnModel : [ {
					id : "issCd",
					title : "Branch Code",
					width : '80px'
				}, {
					id : "issName",
					title : "Branch Name",
					width : '310px'
				} ],
				draggable : true,
				onSelect : function(row) {
					$("txtBranchCd").value = row.issCd;
					$("txtBranchName").value = unescapeHTML2(row.issName);
					$("txtBranchCd").setAttribute("lastValidValue", row.issCd);
					$("txtBranchName").setAttribute("lastValidValue", unescapeHTML2(row.issName));
				},
				onUndefinedRow : function() {
					showMessageBox("No record selected.", imgMessage.INFO);
					$("txtBranchCd").setAttribute("lastValidValue", "");
					$("txtBranchName").setAttribute("lastValidValue", "ALL BRANCHES");
					$("txtBranchCd").value = "";
					$("txtBranchName").value = "ALL BRANCHES";
				},
				onCancel : function() {
					$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
					$("txtBranchName").value = $("txtBranchName").readAttribute("lastValidValue");
				}
			});
		} catch (e) {
			showErrorMessage("showBranchLov", e);
		}
	}
	
	/* $("txtBranchName").observe("change", function() {
		checkLov("getGiacs286IssLov", "txtBranchName", "txtBranchName", "ALL BRANCHES", showBranchLov, "txtBranchName", "txtBranchCd");
	}); */

	$("searchBranchCdLOV").observe("click", function() {
		showBranchLov("%");
	});
	
	$("txtBranchCd").observe("change", function() {
		if($("txtBranchCd").value!="" && $("txtBranchCd").value != $("txtBranchCd").readAttribute("lastValidValue")){
			checkLov("getGiacs286IssLov", "txtBranchCd", "txtBranchName", "ALL BRANCHES", showBranchLov, "txtBranchCd", "txtBranchCd");
		}else if($("txtBranchCd").value == ""){
			$("txtBranchName").value="ALL BRANCHES";
			$("txtBranchCd").setAttribute("lastValidValue", "");
			$("txtBranchName").setAttribute("lastValidValue", "ALL BRANCHES");		
		}
	});	
	
	/* $("txtBranchCd").observe("change", function() {
		if ($("txtBranchCd").value == "") {
			$("txtBranchName").value = "ALL BRANCHES";
		}else{
			checkLov("getGiacs286IssLov", "txtBranchCd", "txtBranchName", "ALL BRANCHES", showBranchLov, "txtBranchCd", "txtBranchCd");
		}
	});  */

	/* $("searchBranchNameLOV").observe("click", function() {
		showBranchLov($("txtBranchCd").value);
	}); */
	
	//Line LOV
	function showLineLov(lineSearchCd) {
		try {
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGiacs286LineLov",
					search : lineSearchCd
				},
				width : 410,
				height : 386,
				autoSelectOneRecord : true,
				filterText : lineSearchCd,
				columnModel : [ {
					id : "lineCd",
					title : "Line Code",
					width : '80px'
				}, {
					id : "lineName",
					title : "Line Name",
					width : '310px'
				} ],
				draggable : true,
				onSelect : function(row) {
					$("txtLineCd").value = row.lineCd;
					$("txtLineName").value = unescapeHTML2(row.lineName);
					$("txtLineCd").setAttribute("lastValidValue", row.lineCd);
					$("txtLineName").setAttribute("lastValidValue", unescapeHTML2(row.lineName));
				},
				onUndefinedRow : function() {
					showMessageBox("No record selected.", imgMessage.INFO);
					$("txtLineCd").setAttribute("lastValidValue", "");
					$("txtLineName").setAttribute("lastValidValue", "ALL LINES");
					$("txtLineCd").value = "";
					$("txtLineName").value = "ALL LINES";
				},
				onCancel : function() {
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
					$("txtLineName").value = $("txtLineName").readAttribute("lastValidValue");
				}
			});
		} catch (e) {
			showErrorMessage("showLineLov", e);
		}
	}

	/* $("txtLineName").observe("change", function() {
		checkLov("getGiacs286LineLov", "txtLineName", "txtLineName", "ALL LINES", showLineLov, "txtLineName", "txtLineCd");
	}); */

/* 	$("txtLineCd").observe("change", function() {
		if ($("txtLineCd").value == "") {
			$("txtLineName").value = "ALL LINES";
		}else{
			checkLov("getGiacs286LineLov", "txtLineCd", "txtLineName", "ALL LINES", showLineLov, "txtLineCd", "txtLineCd");
		}
	});  */

	/* $("searchLineNameLOV").observe("click", function() {
		showLineLov($("txtLineCd").value);
	});  */
	
	$("searchLineCdLOV").observe("click", function() {
		showLineLov("%");
	});
	
	$("txtLineCd").observe("change", function() {
		if($("txtLineCd").value!="" && $("txtLineCd").value != $("txtLineCd").readAttribute("lastValidValue")){
			checkLov("getGiacs286LineLov", "txtLineCd", "txtLineName", "ALL LINES", showLineLov, "txtLineCd", "txtLineCd");
		}else if($("txtBranchCd").value == ""){
			$("txtLineName").value="ALL LINES";
			$("txtLineCd").setAttribute("lastValidValue", "");
			$("txtLineName").setAttribute("lastValidValue", "ALL LINES");		
		}
	});	
	
	//Intermediary and Assured LOV
	function showIntmLov(intmSeacrh) {
		try {
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGiacs286IntmLov",
					search : intmSeacrh
				},
				width : 505,
				height : 386,
				autoSelectOneRecord : true,
				filterText : intmSeacrh,
				columnModel : [ {
					id : "intmNo",
					title : "Intermediary No.",
					titleAlign : 'right',
					align : 'right',
					width : '95px'
				}, {
					id : "refIntmCd",
					title : "Ref Intm Cd",
					titleAlign : 'right',
					align : 'right',
					width : '80px'
				}, {
					id : "intmName",
					title : "Intermediary Name",
					width : '310px'
				} ],
				draggable : true,
				onSelect : function(row) {
					$("txtIntm").value = row.intmNo;
					$("txtIntmName").value = unescapeHTML2(row.intmName);
					$("txtIntm").setAttribute("lastValidValue", row.intmNo);
					$("txtIntmName").setAttribute("lastValidValue", unescapeHTML2(row.intmName));
				},
				onUndefinedRow : function() {
					showMessageBox("No record selected.", imgMessage.INFO);
					$("txtIntm").setAttribute("lastValidValue", "");
					$("txtIntmName").setAttribute("lastValidValue", "ALL INTERMEDIARIES");
					$("txtIntm").value = "";
					$("txtIntmName").value = "ALL INTERMEDIARIES";
				},
				onCancel : function() {
					$("txtIntm").value = $("txtIntm").readAttribute("lastValidValue");
					$("txtIntmName").value = $("txtIntmName").readAttribute("lastValidValue");
				}
			});
		} catch (e) {
			showErrorMessage("showIntmLov", e);
		}
	}

	function showAssdLov(assdSeacrh) {
		try {
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGiacs286AssdLov",
					search : assdSeacrh
				},
				width : 410,
				height : 386,
				autoSelectOneRecord : true,
				filterText : assdSeacrh,
				columnModel : [ {
					id : "assdNo",
					title : "Assured No.",
					titleAlign : 'right',
					align : 'right',
					width : '80px'
				}, {
					id : "assdName",
					title : "Assured Name",
					width : '310px'
				} ],
				draggable : true,
				onSelect : function(row) {
					$("txtIntm").value = row.assdNo;
					$("txtIntmName").value = unescapeHTML2(row.assdName);
					$("txtIntm").setAttribute("lastValidValue", row.intmNo);
					$("txtIntmName").setAttribute("lastValidValue", unescapeHTML2(row.intmName));
				},
				onUndefinedRow : function() {
					showMessageBox("No record selected.", imgMessage.INFO);
					$("txtIntm").setAttribute("lastValidValue", "");
					$("txtIntmName").setAttribute("lastValidValue", "ALL ASSURED");
					$("txtIntm").value = "";
					$("txtIntmName").value = "ALL ASSURED";
				},
				onCancel : function() {
					$("txtIntm").value = $("txtIntm").readAttribute("lastValidValue");
					$("txtIntmName").value = $("txtIntmName").readAttribute("lastValidValue");
				}
			});
		} catch (e) {
			showErrorMessage("showAssdLov", e);
		}
	}

	/* $("txtIntmName").observe("change", function() {
		if($("lblPer").innerHTML == "Intermediary"){
			checkLov("getGiacs286IntmLov", "txtIntmName", "txtIntmName", "ALL INTERMEDIARIES", showIntmLov, "txtIntmName", "txtIntm");
		}else{
			checkLov("getGiacs286AssdLov", "txtIntmName", "txtIntmName", "ALL ASSURED", showAssdLov, "txtIntmName", "txtIntm");
		}
	}); */
	
	/* $("txtIntm").observe("change", function() {
		if ($("txtIntm").value == "") {
			if($("lblPer").innerHTML == "Intermediary"){
				$("txtIntmName").value = "ALL INTERMEDIARIES";
			}else{
				$("txtIntmName").value = "ALL ASSURED";
			}
		}else{
			if($("lblPer").innerHTML == "Intermediary"){
				checkLov("getGiacs286IntmLov", "txtIntm", "txtIntmName", "ALL INTERMEDIARIES", showIntmLov, "txtIntm", "txtIntm");
			}else{
				checkLov("getGiacs286AssdLov", "txtIntm", "txtIntmName", "ALL ASSURED", showAssdLov, "txtIntm", "txtIntm");
			}
		}
	});  */

	$("txtIntm").observe("change", function() {
		if($("txtIntm").value!="" && $("txtIntm").value != $("txtIntm").readAttribute("lastValidValue")){
			if($("lblPer").innerHTML == "Intermediary"){
				checkLov("getGiacs286IntmLov", "txtIntm", "txtIntmName", "ALL INTERMEDIARIES", showIntmLov, "txtIntm", "txtIntm");
			}else{
				checkLov("getGiacs286AssdLov", "txtIntm", "txtIntmName", "ALL ASSURED", showAssdLov, "txtIntm", "txtIntm");
			}
		}else if($("txtIntm").value == ""){
			if($("lblPer").innerHTML == "Intermediary"){
				$("txtIntmName").value="ALL INTERMEDIARIES";
				$("txtIntm").setAttribute("lastValidValue", "");
				$("txtIntmName").setAttribute("lastValidValue", "ALL INTERMEDIARIES");	
			}else{
				$("txtIntmName").value="ALL ASSURED";
				$("txtIntm").setAttribute("lastValidValue", "");
				$("txtIntmName").setAttribute("lastValidValue", "ALL ASSURED");	
			}
		}
	});	
	
	/* $("searchIntmNameLOV").observe("click", function() {
		if($("lblPer").innerHTML == "Intermediary"){
			showIntmLov($("txtIntm").value);
		}else{
			showAssdLov($("txtIntm").value);
		}
	});  */

	$("searchIntmLOV").observe("click", function() {
		if($("lblPer").innerHTML == "Intermediary"){
			showIntmLov("%");
		}else{
			showAssdLov("%");
		}
	});
	
	$("btnPrint").observe("click", function() {
		if (checkAllRequiredFieldsInDiv("fieldDiv")) {
			if(checkAllRequiredFieldsInDiv("printDialogFormDiv")){
				if (checkAllDates()) {
					if($("lblPer").innerHTML == "Intermediary"){
						repTitle = "Paid Premiums per Intermediary";
						intmAssd = "GIACR286";
					}else{
						repTitle = "Paid Premiums per Assured";
						intmAssd = "GIACR287";
					}
					$F("chkTransactionDate") == 1 ? cutOff = 1 : cutOff = 2;
				}
				printReport();
			}
		}
	});
	
	function getParams() {
		var params = "&fromDate=" + $("txtFromDate").value
			+ "&toDate=" + $("txtToDate").value
			+ "&branchCd=" + $("txtBranchCd").value
			+ "&intmNo=" + $("txtIntm").value
			+ "&lineCd=" + $("txtLineCd").value
			+ "&assdNo=" + $("txtIntm").value
			+ "&cutOffParam=" + cutOff;
		return params;
	}
	
	//for printing
	function printReport() {
		try {
			var content = contextPath + "/CreditAndCollectionReportPrintController?action=printReport" + "&reportId=" + intmAssd + getParams();
			if ("screen" == $F("selDestination")) {
				showPdfReport(content, repTitle);
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
			} else if("file" == $F("selDestination")){
				var fileType = "PDF";
				
				if($("rdoPdf").checked)
					fileType = "PDF";
				else if ($("rdoExcel").checked)
					fileType = "XLS";
				else if ($("rdoCsv").checked)
					fileType = "CSV";
				
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
								deleteCSVFileFromServer(response.responseText);
							}else
								copyFileToLocal(response);
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
</script>