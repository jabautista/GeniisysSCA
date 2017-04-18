<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="agingOfCollectionsMainDiv">
	<div id="mainNav" name="mainNav">
		<div id="smoothMenu1" name="smoothMenu1" class="ddsmoothmenu">
			<ul> 
				<li><a id="agingOfCollectionsExit">Exit</a></li>
			</ul>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Aging of Collections</label>
		</div>
	</div>
	
	<div id="agingOfCollectionsInput" class="sectionDiv" style="width: 920px; height: 415px;">
		<div class="sectionDiv" style="width: 620px; height:320px; margin: 40px 20px 20px 150px;">
			<div id="checkBoxDiv" class="sectionDiv" style="width: 535px; height: 10px; margin: 10px 0px 0px 13px; padding: 10px 30px 20px 30px;">
				<table align="center" style="height: 20px">
				<tr>
					<td> 
						<div>
							<input id="chkEffDate" type="checkbox" value="" style="float: left;" tabindex="201"/>
							<label style="margin-left: 7px;" for="chkEffDate" >Extract by Effectivity Date</label>
						</div>
					</td>
					<td>
						<div>
							<input id="chkDueDate" type="checkbox" style="margin-left: 100px; float: left;" value="" tabindex="202"/>
							<label style="margin-left: 7px;" for="chkDueDate">Extract by Due Date</label>
						</div>
					</td>
				</tr>
			</table>
			</div>
			
			<div id="fieldDiv" class="sectionDiv" style="width: 575px; height: 45px; margin: 2px 10px 0px 13px; padding: 10px 10px 25px 10px;">
				<table align="left">
					<tr>
						<td class="rightAligned" style="padding-right: 10px; padding-left: 38px;">From</td>
						<td>
							<div id="fromDateDiv" class="required" style="float: left; border: 1px solid gray; width: 185px; height: 20px;">
								<input id="txtFromDate" name="From Date." readonly="readonly" type="text" class="required date" maxlength="10" style="border: none; float: left; width: 160px; height: 13px; margin: 0px;" value="" tabindex="205"/>
								<img id="imgFromDate" alt="imgFromDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtFromDate'),this, null);" />
							</div>
						</td> 
						<td class="rightAligned" style="padding-left: 60px; padding-right: 10px;">To</td>
						<td>
							<div id="toDateDiv" class="required" style="float: left; border: 1px solid gray; width: 185px; height: 20px;">
								<input id="txtToDate" name="To Date." readonly="readonly" type="text" class="required date" maxlength="10" style="border: none; float: left; width: 160px; height: 13px; margin: 0px;" value="" tabindex="206"/>
								<img id="imgToDate" alt="imgToDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtToDate'),this, null);" />
							</div>
						</td>
					</tr>
				</table>
				<table align="left">
					<tr>
						<td class="rightAligned" style="padding-right: 10px; padding-left: 27px;">Branch</td>
						<td style="padding-top: 0px;">
							<div style="height: 20px;">
								<div id="branchDiv" style="border: 1px solid gray; width: 90px; height: 20px; margin:0 5px 0 0;">
									<input id="txtBranchCd" name="txtBranchCd" type="text" maxlength="2" class="upper" style="border: none; float: left; width: 60px; height: 13px; margin: 0px;" value="" lastValidValue="" tabindex="207"/>
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranchCdLOV" name="searchBranchCdLOV" alt="Go" style="float: right;"/>
								</div>
								
							</div>						
						</td>	
						<td>
							<!-- <div id="branchNameDiv" style="border: 1px solid gray; width: 360px; height: 20px; margin:0 5px 0 0;"> -->
								<input id="txtBranchName" name="txtBranchName" type="text" maxlength="20" class="upper" style="float: left; width: 354px; height: 14px; margin: 0px; margin-top: 1px;" value="" readonly="readonly" lastValidValue="" tabindex="208"/>
								<%-- <img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranchNameLOV" name="searchBranchNameLOV" alt="Go" style="float: right;"/> --%> <!-- removed by kenneth L. 02.28.2014 -->
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
							<input type="text" id="txtNoOfCopies" maxlength="3" style="float: left; text-align: right; width: 175px;" class="integerNoNegativeUnformattedNoComma" lastValidValue="" tabindex="219"/>
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
	setModuleId("GIACS328");
	setDocumentTitle("Aging of Collections");
	initializeAll();
	observeBackSpaceOnDate("txtToDate");
	observeBackSpaceOnDate("txtFromDate");
	togglePrintFields("screen");
	//$("chkEffDate").checked = true;
	//$("chkEffDate").value = "Y";
	//$("chkDueDate").value = "N";
	//disableButton("btnPrint");
	var columnTitle = null;
	var reportAging = null;
	var extractExist = null;
	var extractOrig = null;
	//Added by pjsantos 12/13/2016, genqa 5856
	var prevBranchName = $("txtBranchName").value;
	var prevBranchCd   = $("txtBranchCd").value;
	var prevFromDate   = $("txtFromDate").value;
	var prevToDate     = $("txtToDate").value;
	var prevChkBox     = null;
	var currChkBox     = null; //pjsantos end
	getLastExtractedParams();
	var extractNew = null;
	
	
	function getLastExtractedParams(){
		//Modified by pjsantos 12/13/2016, GENQA 5856
		if ($("txtBranchName").value == null || $("txtBranchName").value == ""){
		$("txtBranchName").value = '${issName}';
		$("txtBranchName").setAttribute("lastValidValue", '${issName}');}
		if ($("txtBranchCd").value == null || $("txtBranchCd").value == ""){
		$("txtBranchCd").value = '${issCd}';
		$("txtBranchCd").setAttribute("lastValidValue", '${issCd}');}
		if($("txtFromDate").value == null || $("txtFromDate").value == ""){
		$("txtFromDate").value = '${fromDate}';}
		if ($("txtToDate").value == null || $("txtToDate").value == ""){
		$("txtToDate").value = '${toDate}';}
		prevBranchName = $("txtBranchName").value;
		prevBranchCd   = $("txtBranchCd").value;
		prevFromDate   = $("txtFromDate").value;
		prevToDate     = $("txtToDate").value;//pjsantos end
		extractExist = '${extractExist}';
		extractOrig = '${extractBy}';
		if('${extractBy}' == "D"){
			$("chkDueDate").checked = true;
			$("chkEffDate").checked = false;//Added by pjsantos 12/14/2016, GENQA 5856
			$("chkEffDate").value = "N";
			$("chkDueDate").value = "Y"; 
			columnTitle = "Due Date";
			reportAging = "GIACR328A";
		}else{
			$("chkEffDate").checked = true;
			$("chkDueDate").checked = false;//Added by pjsantos 12/14/2016, GENQA 5856
			$("chkEffDate").value = "Y";
			$("chkDueDate").value = "N"; 
			columnTitle = "Effectivity Date";
			reportAging = "GIACR328";
		}
	}
	//Added by pjsantos 12/14/2016, used to check last extracted parameters per transaction GENQA 5856
	function getLastExtractedParams2(){
		if ($("txtBranchName").value == null || $("txtBranchName").value == ""){
		$("txtBranchName").value = '${issName}';
		$("txtBranchName").setAttribute("lastValidValue", '${issName}');}
		if ($("txtBranchCd").value == null || $("txtBranchCd").value == ""){
		$("txtBranchCd").value = '${issCd}';
		$("txtBranchCd").setAttribute("lastValidValue", '${issCd}');}
		if($("txtFromDate").value == null || $("txtFromDate").value == ""){
		$("txtFromDate").value = '${fromDate}';}
		if ($("txtToDate").value == null || $("txtToDate").value == ""){
		$("txtToDate").value = '${toDate}';}
		prevBranchName = $("txtBranchName").value;
		prevBranchCd   = $("txtBranchCd").value;
		prevFromDate   = $("txtFromDate").value;
		prevToDate     = $("txtToDate").value;
		extractExist = '${extractExist}';
		extractOrig = $("chkDueDate").checked ? "D" : "E";
		if(extractOrig == "D"){
			$("chkDueDate").checked = true;
			$("chkEffDate").checked = false;
			$("chkEffDate").value = "N";
			$("chkDueDate").value = "Y"; 
			columnTitle = "Due Date";
			reportAging = "GIACR328A";
		}else{
			$("chkEffDate").checked = true;
			$("chkDueDate").checked = false;
			$("chkEffDate").value = "Y";
			$("chkDueDate").value = "N"; 
			columnTitle = "Effectivity Date";
			reportAging = "GIACR328";
		}
	}//pjsantos end
	
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
			$("txtNoOfCopies").setAttribute("lastValidValue", 1);
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
			$("txtNoOfCopies").setAttribute("lastValidValue", "");
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

	/* function showBranchLov(branchCd) {
		try {
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getBranchGiacs328Lov",
					search : branchCd
				},
				width : 405,
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
					$("txtBranchName").value = row.issName;
				},
				onUndefinedRow : function() {
					showMessageBox("No record selected.", imgMessage.INFO);
				}
			});
		} catch (e) {
			showErrorMessage("showBranchLov", e);
		}
	} */
	
	//replaced by kenneth L. 02.28.2014
	function showBranchLov(isIconClicked) {
		try {
			var searchString = isIconClicked ? "%" : ($F("txtBranchCd").trim() == "" ? "%" : $F("txtBranchCd"));

			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getBranchGiacs328Lov",
					search : searchString + "%",
					page : 1
				},
				title : "List of Branches",
				width : 425,
				height : 386,
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
				autoSelectOneRecord : true,
				filterText : escapeHTML2(searchString),
				onSelect : function(row) {
					if (row != null || row != undefined) {
						$("txtBranchCd").value = row.issCd;
						$("txtBranchCd").setAttribute("lastValidValue", row.issCd);
						$("txtBranchName").value = unescapeHTML2(row.issName);
						$("txtBranchName").setAttribute("lastValidValue", unescapeHTML2(row.issName));
					}
				},
				onCancel : function() {
					$("txtBranchCd").focus();
					$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
					$("txtBranchName").value = $("txtBranchName").readAttribute("lastValidValue");
				},
				onUndefinedRow : function() {
					$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
					$("txtBranchName").value = $("txtBranchName").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtBranchCd");
				}
			});
		} catch (e) {
			showErrorMessage("showBranchLov", e);
		}
	}
	
	/* function checkLov(action, cd, desc, message) {
		if ($(cd).value == "") {
			$(desc).value = message;
		} else {
			var output = validateTextFieldLOV("/AccountingLOVController?action=" + action + "&search=" + $(cd).value, $(cd).value, "Searching, please wait...");
			if (output == 2) {
				showBranchLov($("txtBranchCd").value);
			} else if (output == 0) {
				$(cd).clear();
				$(desc).value = message;
				customShowMessageBox("There is no record found.", "I", cd);
			} else {
				showBranchLov($("txtBranchCd").value);
			}
		}
	} */
	
	/* function extractAgingOfCollections() {
		try {
			new Ajax.Request(contextPath + "/GIACCreditAndCollectionReportsController", {
				parameters : {
					action : "extractAgingOfCollections"
				},
				asynchronous : false,
				evalScripts : true,
				onComplete : function(response) {
					if (checkErrorOnResponse(response)) {
						inserToAgingExt();
						enableButton("btnPrint");
					}
				}
			});
		} catch (e) {
			showErrorMessage("extractAgingOfCollections", e);
		}
	} */
	
	//function inserToAgingExt() {
	function extractAgingOfCollections() {
		try {
			new Ajax.Request(contextPath + "/GIACCreditAndCollectionReportsController", {
				parameters : {
					action : "inserToAgingExt",
					effDate : $("chkEffDate").value,
					dueDate : $("chkDueDate").value,
					fromDate : $("txtFromDate").value,
					toDate : $("txtToDate").value,
					branchCd : $("txtBranchCd").value
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : function() {
						showNotice("Extracting Aging of Collections, please wait...");
					},
				onComplete : function(response) {
					hideNotice();
					if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) { //benjo 11.13.2015 GENQA-SR-5125 added checkCustomErrorOnResponse
						extractExist = "Y";
						showWaitingMessageBox(response.responseText, imgMessage.INFO, function erase() {
							$("lblStatus").innerHTML = "";
						});
						
						if(response.responseText.contains("No")){
							extractExist = "N";
						}else{
							showAgingOfCollections();
						}
					}
				}
			});
		} catch (e) {
			showErrorMessage("inserToAgingExt", e);
		}
	}
	
	function validateFromAndTo(field) {
		var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g, "/")) : "";
		var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g, "/")) : "";
		
		if (fromDate > toDate && toDate != "") {
			if (field == "txtFromDate") {
				customShowMessageBox("From date must not be later than to date.", "I", "txtFromDate");
			} else {
				customShowMessageBox("To date must not be earlier than the from date.", "I", "txtToDate");
			}
			$(field).clear();
			return false;
		}
		disableButton("btnPrint");
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
	
	function extractBy(check1, check2){
		if ($(check1).checked) {
			$(check2).checked = false;
			$(check2).value = "N";
			$(check1).value = "Y";
		} else {
			$(check2).checked = true;
			$(check2).value = "Y";
			$(check1).value = "N";
		}
	}
	
	$("btnExtract").observe("click", function() {
		/* if($F("txtFromDate") == "" && $F("txtToDate") == ""){// replaced by Kenneth L. 02.28.2014
			customShowMessageBox("Please enter From Date and To Date.", "E", "txtFromDate");
		}else{
			if (checkAllDates()) {
				extractAgingOfCollections();
			}
		} */
		if(checkAllRequiredFieldsInDiv("fieldDiv")){
			if(!checkIfChanged()){
				showConfirmBox("Confirmation", "Data has been extracted within the specified parameter/s. Do you wish to continue extraction?", "Yes", "No",
						function() {
								extractAgingOfCollections();
								getLastExtractedParams2();//Added by pjsantos 12/14/2016, GENQA 5856
						}, ""); 
			}else{
				extractAgingOfCollections();
				getLastExtractedParams2();//Added by pjsantos 12/14/2016, GENQA 5856
			}
		}
	});
	
	$("txtFromDate").observe("focus", function() {
		//if ($("imgFromDate").disabled == true) return;
		//validateFromAndTo("txtFromDate");
		checkInputDates("txtFromDate", "txtFromDate", "txtToDate");
	});

	$("txtToDate").observe("focus", function() {
		//if ($("imgToDate").disabled == true) return;
		//validateFromAndTo("txtToDate");
		checkInputDates("txtToDate", "txtFromDate", "txtToDate");
	});
	
	$("chkEffDate").observe("click", function() {
		extractBy("chkEffDate", "chkDueDate");
		//disableButton("btnPrint");
	});

	$("chkDueDate").observe("click", function() {
		extractBy("chkDueDate", "chkEffDate");
		//disableButton("btnPrint");
	});
	
	$("selDestination").observe("change", function() {
		var destination = $F("selDestination");
		togglePrintFields(destination);
	});
	
	$("imgSpinUp").observe("click", function(){
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		if(no < 100){
			$("txtNoOfCopies").value = no + 1;
			$("txtNoOfCopies").setAttribute("lastValidValue", $F("txtNoOfCopies"));
		}
	});
	
	$("imgSpinDown").observe("click", function(){
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		if(no > 1){
			$("txtNoOfCopies").value = no - 1;
			$("txtNoOfCopies").setAttribute("lastValidValue", $F("txtNoOfCopies"));
		}
	});

	$("txtNoOfCopies").observe("change", function(){
		if($F("txtNoOfCopies").trim() != "" && (isNaN($F("txtNoOfCopies")) || $F("txtNoOfCopies") <= 0 || $F("txtNoOfCopies") > 100)){
			showWaitingMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "I", function(){
				$("txtNoOfCopies").value = $("txtNoOfCopies").readAttribute("lastValidValue");
			});			
		}else{
			$("txtNoOfCopies").setAttribute("lastValidValue", $F("txtNoOfCopies"));
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
	
	$("agingOfCollectionsExit").observe("click", function() {
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	});
	
	$("searchBranchCdLOV").observe("click", function() {
		showBranchLov(true);
	});

	$("txtBranchCd").observe("change", function() {
		if (this.value != "") {
			showBranchLov(false);
		} else {
			$("txtBranchCd").value = "";
			$("txtBranchCd").setAttribute("lastValidValue", "");
			$("txtBranchName").value = "ALL BRANCHES";
			$("txtBranchName").setAttribute("lastValidValue", "ALL BRANCHES");
		}
	});
	
	/* $("searchBranchCdLOV").observe("click", function() {
		showBranchLov($("txtBranchCd").value);
	});
	
	$("txtBranchCd").observe("change", function() {
		checkLov("getBranchGiacs328Lov", "txtBranchCd", "txtBranchName", "ALL BRANCHES");
	});  */
	
	/* $("searchBranchNameLOV").observe("click", function() {
		showBranchLov($("txtBranchCd").value);
	}); */
	
	/* $("txtBranchName").observe("change", function() {
			var output = validateTextFieldLOV("/AccountingLOVController?action=getBranchGiacs328Lov" 
							+ "&search=" + $("txtBranchName").value, $("txtBranchName").value, "Searching, please wait...");
			if (output == 2) {
				showBranchLov($("txtBranchName").value);
			} else if (output == 0) {
				$("txtBranchCd").clear();
				$("txtBranchName").value = "ALL BRANCHES";
				customShowMessageBox("Branch does not exist.", "I", "txtBranchName");
			} else {
				showBranchLov($("txtBranchName").value);
			}
		}
	); */
	
	$("btnPrint").observe("click", function() {
		if(extractExist == "N"){
			showMessageBox("Please extract records first.", "I");
		}else{
			if(checkAllRequiredFieldsInDiv("printDialogFormDiv") && checkAllRequiredFieldsInDiv("fieldDiv")){
				if(!checkIfChanged()){
					printReport();
				}else{
					showConfirmBox("Confirmation", "The specified parameter/s has not been extracted. Do you want to extract the data using the specified parameter/s?", "Yes", "No",
							function() {
									extractAgingOfCollections();
									getLastExtractedParams2();//Added by pjsantos 12/14/2016, GENQA 5856
							}, ""); 
				}
				
			}
		}
	});
	
	function getParams() {
		var params = "&fromDate=" + $("txtFromDate").value
			+ "&toDate=" + $("txtToDate").value
			+ "&issCd=" + $("txtBranchCd").value
			+ "&date=" + columnTitle;
		return params;
	}
	
	//for printing
	function printReport() {
		try {
			var content = contextPath + "/CreditAndCollectionReportPrintController?action=printReport" + "&reportId=" + reportAging + getParams();
			if ("screen" == $F("selDestination")) {
				showPdfReport(content, "Aging Of Collections");
			} else if ($F("selDestination") == "printer") {
				new Ajax.Request(content, {
					parameters : {
						noOfCopies : $F("txtNoOfCopies"),
						printerName : $F("printerName"),	// added by Kenneth L. 02.28.2014
						destination : $F("selDestination")
					},
					onCreate : showNotice("Processing, please wait..."),
					onComplete : function(response) {
						hideNotice();
						if (checkErrorOnResponse(response)) {
							showMessageBox("Printing complete.", "S");
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
	
	$$("input[type='checkbox']").each(function(btn) {
		btn.observe("click", function() {
			if($("chkEffDate").checked == true){
				columnTitle = "Effectivity Date";
				reportAging = "GIACR328";
				//extractOrig = "E"; Removed by pjsantos 12/14/2016, GENQA 5856
			}else{
				columnTitle = "Due Date";
				reportAging = "GIACR328A";
				//extractOrig = "D"; Removed by pjsantos 12/14/2016, GENQA 5856
			};
		});
	});
	
	function checkIfChanged(){
		changed = false; 
		var extractCurrent = $("chkDueDate").checked ? "D" : "E";	//Added by pjsantos 12/14/2016, GENQA 5856	
		if(/* $F("txtFromDate") != '${fromDate}' || $F("txtToDate") != '${toDate}' || extractOrig != '${extractBy}' || $F("txtBranchCd") !='${issCd}' */
			 $F("txtFromDate") != prevFromDate ||  $F("txtToDate") != prevToDate || extractOrig != extractCurrent || $F("txtBranchCd") != prevBranchCd ){   changed = true; //Modified by pjsantos 12/14/2016, GENQA 5856
		}
		return changed;
	}
</script>