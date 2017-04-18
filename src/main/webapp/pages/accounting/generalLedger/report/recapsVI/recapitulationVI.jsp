<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="recapsVIMainDiv" name="recapsVIMainDiv">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="menuRecapitulationExit" name="menuRecapitulationExit">Exit</a></li>
			</ul>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Extract / Print Policies per Region</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
		</div>
	</div>

	<div id="moduleDiv" name="moduleDiv" class="sectionDiv">

		<div id="moduleSubDiv" class="sectionDiv" style="width: 540px; margin: 40px 100px 50px 200px;">

			<div id="parametersDiv" name="parametersDiv" style="margin: 10px 10px 0 10px;">
				<fieldset>
					<legend>Parameters</legend>
					<table>
						<tr id="trFromToDate">
							<td id="tdFromDateLbl" class="rightAligned" style="width: 85px;">From</td>
							<td id="tdFromDate" class="leftAligned">
								<div id="fromDateDiv" style="float: left; width: 165px;" class="withIconDiv required">
									<input type="text" id="txtFromDate" name="txtFromDate" class="withIcon required" readonly="readonly" style="width: 140px;" tabindex="101" /> 
									<img id="hrefFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" tabindex="102" />
								</div>
							</td>
							<td id="tdToDateLbl" class="rightAligned" style="width: 63px;">To</td>
							<td id="tdToDate" class="leftAligned">
								<div id="toDateDiv" style="float: left; width: 165px;" class="withIconDiv required" changetagAttr="true">
									<input type="text" id="txtToDate" name="txtToDate" class="withIcon required" readonly="readonly" style="width: 140px;" tabindex="103" /> 
									<img id="hrefToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To Date" tabindex="104" />
								</div>
							</td>
						</tr>
					</table>
				</fieldset>
			</div><!-- end: parametersDiv -->

			<div id="typeDiv" name="typeDiv" style="margin: 10px 10px 0 10px; float: left; width: 170px;">
				<fieldset>
					<legend>Type</legend>
					<table cellpadding="2" cellspacing="2" style="margin: 5px 10px 5px 30px; height: 96px;" border="0">
						<tr style="height: 25px;">
							<td>
								<input type="radio" id="rdoSummary" name="typeRG" value="summary" title="Summary" tabindex="105" style="float: left; margin: 0 5px 2px 5px;" /> 
								<label id="lblRdoSummary" for="rdoSummary" style="float: left;">Summary</label>
							</td>
						</tr>
						<tr style="height: 25px;">
							<td>
								<input type="radio" id="rdoDetail" name="typeRG" value="detail" title="Detail" tabindex="106" style="float: left; margin: 0 5px 2px 5px;" /> 
								<label id="lblRdoDetail" for="rdoDetail" style="float: left;">Detail</label>
							</td>
						</tr>
					</table>
				</fieldset>
			</div><!-- end: typeDiv -->

			<div id="type2Div" name="type2Div" style="margin: 10px 10px 0 0; float: left; width: 275px;">
				<fieldset>
					<legend>Detail Type</legend>
					<table cellpadding="2" cellspacing="2" style="margin: 14px 5px 5px 5px; width: 308px; height: 87px;" border="0">
						<tr style="height: 25px;">
							<td height="25px" width="130px">
								<input type="radio" id="rdoPremium" name="type2RG" value="premium" title="Premium" tabindex="107" style="float: left; margin: 0 5px 2px 15px;" /> 
								<label id="lblRdoPremium" for="rdoPremium">Premium</label>
								<input type="radio" id="rdoSummarizedPol" name="rdoDetailType" style="float: left; margin: 0 5px 2px 30px;" checked=true/>
								<!-- <label alt="sumzzzz" altTitle="sumzzzz" for="rdoSummarizedPol" title="sumzzzz">Summarized Policyz</label> Dren Niebres 07.18.2016 SR-5336 -->								
								<td title="Premium amounts are net of endorsements" style="height: 25px;">Summarized Policy</td>
							</td>
						</tr>
						<tr style="height: 25px;">
							<td height="25px" width="130px">
								<input type="radio" id="rdoIncludeEndt" name="rdoDetailType" style="float: left; margin: 0 5px 2px 114px;"/>
								<!-- <label for="rdoIncludeEndt" title="incccllldd">With Endorsement Details</label> Dren Niebres 07.18.2016 SR-5336 -->
								<td title="Endorsements will also be printed with their corresponding premium amounts" style="height: 25px;">With Endorsement Details</td>
							</td>
						</tr>		
						<tr style="height: 25px;">
							<td>
								<input type="radio" id="rdoLosses" name="type2RG" value="losses" title="Losses" tabindex="108" style="float: left; margin: 0 5px 2px 15px;" /> 
								<label id="lblRdoLosses" for="rdoLosses">Losses</label>
							</td>
						</tr>
					</table>
				</fieldset>
			</div><!-- end: type2Div -->

			<div id="printDiv" class="sectionDiv" style="width: 514px; height: 150px; margin: 10px 10px 0 12px;">
				<table id="printDialogMainTab" name="printDialogMainTab" align="center" style="padding: 10px; margin-top: 10px; margin-bottom: 10px;" border="0">
					<tr>
						<td class="rightAligned">Destination</td>
						<td class="leftAligned"><select id="selDestination" style="width: 200px;" tabindex="109">
								<option value="screen">Screen</option>
								<option value="printer">Printer</option>
								<option value="file">File</option>
								<option value="local">Local Printer</option>
						</select></td>
					</tr>
					<tr>
						<td></td>
						<td>
							<input value="PDF" title="PDF" type="radio" id="rdoPdf" name="fileType" style="margin: 2px 5px 4px 5px; float: left;" checked="checked" disabled="disabled" tabindex="110"/>
							<label for="rdoPdf" style="margin: 2px 0 4px 0">PDF</label> 
							<!-- <input value="EXCEL" title="Excel" type="radio" id="rdoExcel" name="fileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled" tabindex="111" />
							<label for="rdoExcel" style="margin: 2px 0 4px 0">Excel</label> -->
							<!-- added by carlo de guzman 3.14.2016 -->
							<input value="CSV" title="CSV" type="radio" id="rdoCsv" name="fileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled" tabindex="111"/>
							<label for="rdoCsv" style="margin: 2px 0 4px 0">CSV</label> 
							<!-- end -->
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Printer</td>
						<td class="leftAligned"><select id="selPrinter" style="width: 200px;" class="required" tabindex="112">
								<option></option>
								<c:forEach var="p" items="${printers}">
									<option value="${p.name}">${p.name}</option>
								</c:forEach>
						</select></td>
					</tr>
					<tr>
						<td class="rightAligned">No. of Copies</td>
						<td class="leftAligned"><input type="text" id="txtNoOfCopies" maxlength="30" style="float: left; text-align: right; width: 175px;" class="required integerNoNegativeUnformattedNoComma" tabindex="113">
							<div style="float: left; width: 15px;">
								<img id="imgSpinUp" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; cursor: pointer;" />
								<img id="imgSpinUpDisabled" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; display: none;"/>
								<img id="imgSpinDown" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; cursor: pointer;"/> 
								<img id="imgSpinDownDisabled" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; display: none;"/>
							</div>
						</td>
					</tr>
				</table>				
			</div><!-- end: printDiv -->

			<div class="buttonsDiv" style="margin-top: 20px; margin-bottom: 20px;">
				<input type="button" class="button" id="btnExtract" name="btnExtract" value="Extract" tabindex="114" style="width: 90px;" /> 
				<input type="button" class="button" id="btnViewDetails" name="btnViewDetails" value="View Details" tabindex="115" style="width: 90px;" /> 
				<input type="button" class="button" id="btnPrint" name="btnPrint" value="Print" tabindex="116" style="width: 90px;" />
			</div>

		</div>	<!-- end: moduleSubDiv -->

	</div><!-- end: moduleDiv -->

</div><!-- end: recapsVIMainDiv -->

<script type="text/javascript">
	objRecapsVI = new Object();

	function toggleRequiredFields(dest) {
		if (dest == "printer") {
			$("selPrinter").disabled = false;
			$("txtNoOfCopies").disabled = false;
			$("selPrinter").addClassName("required");
			$("txtNoOfCopies").addClassName("required");
			$("imgSpinUp").show();
			$("imgSpinDown").show();
			$("imgSpinUpDisabled").hide();
			$("imgSpinDownDisabled").hide();
			$("txtNoOfCopies").value = 1;
			$("rdoPdf").disable();
			//$("rdoExcel").disable(); removed carlo de guzman 3.14.2016
			$("rdoCsv").disable(); // added by carlo de guzman 3.14.2016
		} else {
			if (dest == "file") {
				$("rdoPdf").enable();
				//$("rdoExcel").enable(); removed carlo de guzman 3.14.2016
				$("rdoCsv").enable(); // added by carlo de guzman 3.14.2016
			} else {
				$("rdoPdf").disable();
				//$("rdoExcel").disable(); removed carlo de guzman 3.14.2016
				$("rdoCsv").disable(); // added by carlo de guzman 3.14.2016
			}
			$("selPrinter").value = "";
			$("txtNoOfCopies").value = "";
			$("selPrinter").disabled = true;
			$("txtNoOfCopies").disabled = true;
			$("selPrinter").removeClassName("required");
			$("txtNoOfCopies").removeClassName("required");
			$("imgSpinUp").hide();
			$("imgSpinDown").hide();
			$("imgSpinUpDisabled").show();
			$("imgSpinDownDisabled").show();
		}
	}

	function validateDates(fieldName) {
		var elemDateFr = Date.parse($F("txtFromDate"), "mm-dd-yyyy");
		var elemDateTo = Date.parse($F("txtToDate"), "mm-dd-yyyy");
		var proceed = true;
		if ($F("txtToDate") != "" && $F("txtFromDate") != "") {
			var output = compareDatesIgnoreTime(elemDateFr, elemDateTo);
			if (output < 0) {
				$(fieldName).value = "";
				proceed = false;
				customShowMessageBox( "From Date should not be later than To Date.", "I", fieldName);
			}
		}
		return proceed;
	}

	function validateDateFrom() {
		validateDates('txtFromDate');
	}
	function validateDateTo() {
		validateDates('txtToDate');
	}

	function observeParamsRG() {
		var flag;
		//if ($("btnViewDetails").disabled) { //comment out by Dren SR SR-5336 04.13.2016
		flag = $("rdoSummary").checked ? true : false;
		$("rdoLosses").disabled = flag;
		$("rdoPremium").disabled = flag;
		$("rdoSummarizedPol").disabled = flag; //Dren Niebres 07.18.2016 SR-5336
		$("rdoIncludeEndt").disabled = flag; //Dren Niebres 07.18.2016 SR-5336
		//}
	}
	
	function observeParamsDT() {
		$("rdoPremium").disabled = false;
		$("rdoLosses").disabled = false;	
		
		if ($("rdoLosses").checked) {
			$("rdoSummarizedPol").disabled = true;
			$("rdoIncludeEndt").disabled = true;			
		} else {
			$("rdoSummarizedPol").disabled = false;
			$("rdoIncludeEndt").disabled = false;				
		}
	} //Dren Niebres 07.18.2016 SR-5336

	function initializeDefaultValues() {
		$("rdoSummary").checked = true;
		$("rdoPremium").checked = true;
		$("rdoPremium").disabled = true;
		$("rdoLosses").disabled = true;		
		$("rdoSummarizedPol").disabled = true; //Dren Niebres 07.18.2016 SR-5336
		$("rdoIncludeEndt").disabled = true; //Dren Niebres 07.18.2016 SR-5336
		//observeParamsRG(); //$("rdoSummary").click();

		disableButton("btnViewDetails");
		disableButton("btnPrint");
	}

	function getRdoValue(rdoGroupName) {
		var rdoValue = "";
		$$("input[name='" + rdoGroupName + "']").each(function(c) {
			if (c.checked) {
				rdoValue = c.value;
			}
		});
		return rdoValue;
	}

	function validateReportId(reportId, reportTitle) {
		try {
			new Ajax.Request(
					contextPath + "/GIACGeneralDisbursementReportsController",
					{
						parameters : {
							action : "validateReportId",
							reportId : reportId
						},
						ashynchronous : false,
						evalScripts : true,
						onComplete : function(response) {
							if (checkErrorOnResponse(response)) {
								if (response.responseText == "Y") {
									printReport(reportId, reportTitle);
								} else {
									showMessageBox("No existing records found in GIIS_REPORTS.", "E");
								}
							}
						}
					});
		} catch (e) {
			showErrorMessage("validateReportId", e);
		}
	}

	function printReport(reportId, reportTitle) {
		try {
			if (checkAllRequiredFieldsInDiv("printDiv")) {
				var noOfCopies = parseInt($F("txtNoOfCopies"));
				
				if(noOfCopies < 1){
					noOfCopies = 1;
					$("txtNoOfCopies").value = "1";
				}
				var fileType = "";
				var includeEndt = ""; //Dren Niebres 07.18.2016 SR-5336 - Start
				
				 if ($("rdoSummarizedPol").checked == true) {
					includeEndt = "N";
				} else {
					includeEndt = "Y";
				} //Dren Niebres 07.18.2016 SR-5336 - End
				
				if (reportId == "GIPIR203A") {
					if ($("rdoPdf").disabled == false && $("rdoCsv").disabled == false) {
						if ($("rdoPdf").checked == true || ($("rdoPdf").checked == false && $("rdoCsv").checked == false)) {
							fileType = "PDF";
						} else {
							fileType = "CSV2";
							reportId = "GIPIR203A_CSV"							
						}
					} 
				} else {
					if ($("rdoPdf").disabled == false && $("rdoCsv").disabled == false) {
						fileType = $("rdoCsv").checked ? "CSV" : "PDF";
					} 
				}

				/* if ($("rdoPdf").disabled == false
						//&& $("rdoExcel").disabled == false) { removed carlo de guzman 3.14.2016
						&& $("rdoCsv").disabled == false) { // added by carlo de guzman 3.14.2016
						//fileType = $("rdoPdf").checked ? "PDF" : "XLS"; removed by carlo de guzman 3.14.2016
					fileType = $("rdoPdf").checked ? "PDF" : "CSV";
				} */

				var content = contextPath
						+ "/GeneralLedgerPrintController?action=printReport"
						+ "&noOfCopies=" + noOfCopies //$F("txtNoOfCopies")
						+ "&printerName=" + $F("selPrinter") + "&destination="
						+ $F("selDestination") + "&reportId=" + reportId
						+ "&reportTitle=" + reportTitle + "&fileType="
						+ fileType
						+ "&includeEndt=" + includeEndt	//Dren Niebres 07.18.2016 SR-5336
				/* + "&moduleId=" + "GIPIS203"							
				+ "&fromDate=" + $F("txtFromDate")
				+ "&toDate=" + $F("txtToDate") */;

				// printGenericReport(content, reportTitle)	removed by carlo de guzman 3.14.2016		
				var withCsv = ""; // added by carlo de guzman 3.14.2016
				if(fileType ==  "CSV" || fileType ==  "CSV2"){withCsv = "Y"} //Dren Niebres 07.18.2016 SR-5336
				else{withCsv = ""}
				
				printGenericReport(content, reportTitle, null, withCsv);
			}
		} catch (e) {
			showErrorMessage("printReport", e);
		}
	}

	// executes the procedures in trigger when-button-pressed for extract_btn
	function extractRecaps() {
		var rg1 = getRdoValue("typeRG");
		var rg2 = getRdoValue("type2RG");
		
		try {
			new Ajax.Request(contextPath + "/GIPIPolbasicController", {
				method : "POST",
				parameters : {
					action : "extractRecapsVI",
					fromDate : $F("txtFromDate"),
					toDate : $F("txtToDate"),
					rdoGroup1 : rg1,
					rdoGroup2 : rg2,
					moduleId : "GIPIS203"
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : function() {
					showNotice("Extracting data, please wait...");
				},
				onComplete : function(response) {
					hideNotice("");
					if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
						if (response.responseText == "TRUE") {
							disableButton("btnViewDetails");
							disableButton("btnPrint");
							showMessageBox("No record extracted.", "I");
						} else {
							enableButton("btnViewDetails");
							enableButton("btnPrint");
							showMessageBox("Extraction process done.", "I");
						}
					}
				}
			});
		} catch (e) {
			showErrorMessage("extractRecaps: ", e);
		}
	}

	// Executes when-button-pressed trigger for btn_print: Checks if records exist before printing
	function checkGipis203ExtractedRecordsBeforePrint(rdoGroup1, rdoGroup2) {
		try {
			new Ajax.Request(
					contextPath + "/GIPIPolbasicController",
					{
						method : "POST",
						parameters : {
							action : "checkExtractedRecordsBeforePrint",
							rdoGroup1 : rdoGroup1,
							rdoGroup2 : rdoGroup2
						},
						asynchronous : false,
						evalScripts : true,
						onCreate : function() {
							showNotice("Checking extracted records, please wait...");
						},
						onComplete : function(response) {
							hideNotice("");
							if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
								if (response.responseText == "FALSE") {
									if (rdoGroup1 == "summary") {
										validateReportId("GIPIR203", "Recapitulation Report");
									} else {
										if (rdoGroup2 == "premium") {
											validateReportId("GIPIR203A", "Recapitulation Report Detail");
										} else {
											validateReportId("GIPIR203B", "Recapitulation Report Detail");
										}
									}
								} else {
									showMessageBox( "No records to print. Please extract the records first.", "I");
								}
							}
						}
					});
		} catch (e) {
			showErrorMessage("checkGipis203ExtractedRecordsBeforePrint: ", e);
		}
	}

	$("hrefFromDate").observe("click", function() {
		scwShow($('txtFromDate'), this, null);
	});

	$("hrefToDate").observe("click", function() {
		scwShow($('txtToDate'), this, null);
	});

	$("rdoSummary").observe("click", observeParamsRG);
	$("rdoDetail").observe("click", observeParamsDT); //Dren Niebres 07.18.2016 SR-5336
	
	$("rdoLosses").observe("click", function() {
		$("rdoSummarizedPol").disabled = true;
		$("rdoIncludeEndt").disabled = true;
	});	//Dren Niebres 07.18.2016 SR-5336
	
	$("rdoPremium").observe("click", function() {
		$("rdoSummarizedPol").disabled = false;
		$("rdoIncludeEndt").disabled = false;
	}); //Dren Niebres 07.18.2016 SR-5336

	$("btnExtract").observe("click", function() {
		if (checkAllRequiredFieldsInDiv("parametersDiv") && validateDates('txtFromDate') && validateDates('txtToDate')) {
			new Ajax.Request(contextPath + "/GIPIPolbasicController", { /* benjo 06.01.2015 GENQA AFPGEN_IMPLEM SR 4150 */
				method : "POST",
				parameters : {
					action : "checkRecapsVIBeforeExtract",
					fromDate : $F("txtFromDate"),
					toDate : $F("txtToDate")
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : function() {
					showNotice("Checking records...");
				},
				onComplete : function(response) {
					hideNotice("");
					var json = JSON.parse(response.responseText)
					if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
						if (json.error == "Y"){
					    	customShowMessageBox(json.msg, "I", 'txtFromDate');
						} else {
							extractRecaps();
						}
					}
				}
			});
		}
	});

	$("btnViewDetails").observe("click", function() {
		objRecapsVI.rdoGroup1 = getRdoValue("typeRG");
		objRecapsVI.rdoGroup2 = getRdoValue("type2RG");
		var newTitle = objRecapsVI.rdoGroup2 == "premium" ? "Recapitulation Premium Details" : "Recapitulation Losses Details";

		recapDetailsOverlay = Overlay.show(contextPath + "/GIPIPolbasicController", {
			urlParameters : {
				action : "showRecapDetails",
				type : objRecapsVI.rdoGroup2
			},
			title : newTitle,
			height : 600,
			width : 820,
			urlContent : true,
			draggable : true,
			showNotice : true,
			noticeMessage : "Loading, please wait..."
		});
	});

 	$("btnPrint").observe("click", function() {
		objRecapsVI.rdoGroup1 = getRdoValue("typeRG");
		objRecapsVI.rdoGroup2 = getRdoValue("type2RG");

		checkGipis203ExtractedRecordsBeforePrint(objRecapsVI.rdoGroup1,	objRecapsVI.rdoGroup2);			
	}); 
	//PRINTDIV
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

	$("selDestination").observe("change", function() {
		var dest = $F("selDestination");
		toggleRequiredFields(dest);
	});
	
	$("menuRecapitulationExit").stopObserving("click");
	$("menuRecapitulationExit").observe("click", function(){
		if(objGIPIS203.fromMenu == "UW"){
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);	
		} else if(objGIPIS203.fromMenu == "AC"){
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		}		
	});

	setModuleId("GIPIS203");
	setDocumentTitle("Recapitulation");
	initializeAll();
	makeInputFieldUpperCase();
	observeReloadForm("reloadForm", function(){
		if(objGIPIS203.fromMenu == "UW"){
			showUWRecapsVI();
		} else if(objGIPIS203.fromMenu == "AC"){
			showRecapsVI();
		}
	});
	toggleRequiredFields("screen");
	initializeDefaultValues();
	observeChangeTagOnDate("hrefFromDate", "txtFromDate", validateDateFrom);
	observeChangeTagOnDate("hrefToDate", "txtToDate", validateDateTo);
</script>