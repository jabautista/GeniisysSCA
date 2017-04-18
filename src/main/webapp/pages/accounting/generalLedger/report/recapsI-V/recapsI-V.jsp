<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="recapsIToVMainDiv" name="recapsIToVMainDiv">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Recapitulation</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
		</div>
	</div>
	
	<div id="recapsIToVDiv" name="recapsIToVDiv" class="sectionDiv">
		<div class="sectionDiv"  style="width: 482px; margin: 40px 138px 40px 205px; height: 460px;">
			<div id="recapsDateDiv" class="sectionDiv" style="height: 248px; width: 465px; margin: 8px 4px 2px 8px;">
				<table style="margin: 15px 0 0 30px;">
					<tr>
						<td class="rightAligned">From</td>
						<td>
							<div style="float:left; border: solid 1px gray; width: 155px; height: 21px; margin-right:3px;" class="required">
					    		<input style="height: 13px; width: 131px; border: none; float: left;" id="fromDate" name="fromDate" type="text" readonly="readonly" class="required" tabindex="101"/>
					    		<img name="hrefFromDate" id="hrefFromDate" style="margin-top: 1px;" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" onClick="scwShow($('fromDate'),this, null);"/>
							</div>
						</td>
						<td class="rightAligned" style="padding-left: 30px;">To</td>
						<td>
							<div style="float:left; border: solid 1px gray; width: 155px; height: 21px; margin-right:3px;" class="required">
					    		<input style="height: 13px; width: 131px; border: none; float: left;" id="toDate" name="toDate" type="text" readonly="readonly" class="required" tabindex="102"/>
					    		<img name="hrefToDate" id="hrefToDate" style="margin-top: 1px;" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" onClick="scwShow($('toDate'),this, null);"/>
							</div>
						</td>
					</tr>
				</table>
				
				<fieldset style="height: 172px; width: 434px; margin: 8px 4px 2px 8px; float: left; border: 1px solid #E0E0E0;">
					<legend>Report Type</legend>
					<div style="padding: 10px 0 0 116px;">
						<table border="0" cellspacing="2" cellpadding="2">
							<tr>
								<td>
									<input value="Premium" title="Recap I - Premiums Written" type="radio" id="recapI" name="reportTypeRG" style="margin: 0 5px 2px 5px; float: left;" checked="checked"
										overlayTitle="View Recap I - Premiums Written and Premiums Earned" tabindex="103">
									<label for="recapI">Recap I - Premiums Written</label>
								</td>
							</tr>
							<tr>
								<td>
									<input value="LossPd" title="Recap II - Losses Incurred" type="radio" id="recapII" name="reportTypeRG" style="margin: 0 5px 2px 5px; float: left;"
										overlayTitle="View Recap II - Losses Paid and Incurred" tabindex="103">
									<label for="recapII">Recap II - Losses Incurred</label>
								</td>
							</tr>
							<tr>
								<td>
									<input value="Comm" title="Recap III - Commission" type="radio" id="recapIII" name="reportTypeRG" style="margin: 0 5px 2px 5px; float: left;"
										overlayTitle="View Recap III - Commissions" tabindex="103">
									<label for="recapIII">Recap III - Commission</label>
								</td>
							</tr>
							<tr>
								<td>
									<input value="Tsi" title="Recap IV - Risks In Force" type="radio" id="recapIV" name="reportTypeRG" style="margin: 0 5px 2px 5px; float: left;"
										overlayTitle="View Recap IV - Risks in Force" tabindex="103">
									<label for="recapIV">Recap IV - Risks In Force</label>
								</td>
							</tr>
							<tr>
								<td>
									<input value="OsLoss" title="Recap V - Losses and Claims" type="radio" id="recapV" name="reportTypeRG" style="margin: 0 5px 10px 5px; float: left;"
										overlayTitle="View Recap V - Losses and Claims Payable" tabindex="103">
									<label for="recapV">Recap V - Losses and Claims</label>
								</td>
							</tr>
							<tr>
								<td>
									<input id="btnViewDetails" type="button" class="button" value="View Details" style="width: 130px;" tabindex="104">
								</td>
							</tr>
						</table>
					</div>
				</fieldset>
			</div>
			
			<div id="printerDiv" class="sectionDiv" style="width: 395px; height: 120px; margin: 8px 4px 2px 8px; padding: 15px 0px 0px 70px; float: left;">
				<table>
					<tr>
						<td class="rightAligned">Destination</td>
						<td class="leftAligned">
							<select id="selDestination" style="width: 200px;" tabindex="105">
								<option value="screen">Screen</option>
								<option value="printer">Printer</option>
								<option value="file">File</option>
								<option value="local">Local Printer</option>
								<option value=""></option>
							</select>
						</td>
					</tr>
					<tr>
						<td></td>
						<td>
							<input value="PDF" title="PDF" type="radio" id="pdfRB" name="fileRG" style="margin: 2px 5px 4px 8px; float: left;" checked="checked" disabled="disabled"><label for="pdfRB" style="margin: 2px 0 4px 0" tabindex="106">PDF</label>
							<!-- <input value="EXCEL" title="Excel" type="radio" id="excelRB" name="fileRG" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="excelRB" style="margin: 2px 0 4px 0" tabindex="106">Excel</label> removed by carlo rubenecia 04.12.2016 SR: 5506-->
							<input value="CSV" title="CSV" type="radio" id="csvRB" name="fileRG" style="margin: 2px 5px 4px 8px; float: left;" disabled="disabled"><label for="csvRB" style="margin: 2px 0 4px 0" tabindex="106">CSV</label> <!-- added by carlo rubenecia 04.12.2016 SR: 5506-->
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Printer</td>
						<td class="leftAligned">
							<select id="selPrinter" style="width: 200px;" class="required" tabindex="107">
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
							<input type="text" id="txtNoOfCopies" style="float: left; text-align: right; width: 176px;" class="required integerNoNegativeUnformatted" maxlength="3" tabindex="108">
							<div style="float: left; width: 15px;">
								<img id="imgSpinUp" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; cursor: pointer;">
								<img id="imgSpinUpDisabled" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; display: none;">
								<img id="imgSpinDown" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; cursor: pointer;">
								<img id="imgSpinDownDisabled" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; display: none;">
							</div>					
						</td>
					</tr>
				</table>
			</div>
			
			<div style="margin: 12px 0 0 0; padding-left: 150px; float: left;">
				<input id="btnExtract" type="button" class="button" value="Extract" style="width: 90px;" tabindex="109">
				<input id="btnPrint" type="button" class="button" value="Print" style="width: 90px;" tabindex="110">
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
	objRecaps = new Object();
	
	function newFormInstance(){
		initializeAll();
		objRecaps.formVariables = JSON.parse('${formVariables}');
		$("fromDate").value = objRecaps.formVariables.recapFromDate;
		$("toDate").value = objRecaps.formVariables.recapToDate;
		$("fromDate").focus();
		observePrintFields();
		observeBackSpaceOnDate("fromDate");
		observeBackSpaceOnDate("toDate");
		toggleRequiredFields("screen");
		setModuleId("GIACS290");
		setDocumentTitle("Recapitulation");
	}

	function toggleRequiredFields(dest){
		if(dest == "printer"){			
			$("selPrinter").disabled = false;
			$("txtNoOfCopies").disabled = false;
			$("selPrinter").addClassName("required");
			$("txtNoOfCopies").addClassName("required");
			$("imgSpinUp").show();
			$("imgSpinDown").show();
			$("imgSpinUpDisabled").hide();
			$("imgSpinDownDisabled").hide();
			$("txtNoOfCopies").value = 1;
			$("pdfRB").disabled = true;
			//$("excelRB").disabled = true; removed by carlo rubenecia 04.12.2016 SR 5506
			$("csvRB").disabled = true; // added by carlo rubenecia 04.12.2016 SR 5506
		} else {
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
			if(dest == "file"){
				$("pdfRB").disabled = false;
				//$("excelRB").disabled = false; removed by carlo rubenecia 04.12.2016 SR 5506
				$("csvRB").disabled = false; //added by carlo rubenecia 04.12.2016 SR 5506
			}else{
				$("pdfRB").disabled = true;
				//$("excelRB").disabled = true; removed by carlo rubenecia 04.12.2016 SR 5506
				$("csvRB").disabled = true; //added by by carlo rubenecia 04.12.2016 SR 5506
			}
		}
	}
	
	function observePrintFields(){
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
			toggleRequiredFields(dest);
		});
	}
	
	function showRecapDetails(){
		$$("input[name='reportTypeRG']").each(function(c){
			if($(c).checked){
				objRecaps.title = $(c).getAttribute("overlayTitle");
				objRecaps.type = $(c).value;
			}
		});
		
		setDetailLabels();
		
		recapDetailsOverlay = Overlay.show(contextPath+"/GIACRecapDtlExtController", {
			urlParameters: {
				action: "showRecapDetails",
				type: objRecaps.type
			},
			title: objRecaps.title,
		    height: 480,
		    width: 840,
			urlContent : true,
			draggable: true,
			showNotice: true,
		    noticeMessage: "Loading, please wait..."
		});
	}
	
	function setDetailLabels(){
		if(objRecaps.type == "Premium"){
			objRecaps.rowTitle = "Policy No.";
			objRecaps.directAmtLbl = "Direct Business";
			objRecaps.directNetLbl = "NP on Direct Bus";
			objRecaps.netWrittenLbl = "Net Prem Written";
			objRecaps.cededLbl = "C E D E D &nbspP R E M I U M S";
			objRecaps.inwLbl = "A S S U M E D &nbspP R E M I U M S";
			objRecaps.retLbl = "R E T R O C E D E D";
		}else if(objRecaps.type == "LossPd"){
			objRecaps.rowTitle = "Claim No.";
			objRecaps.directAmtLbl = "LP On DBus";
			objRecaps.directNetLbl = "NLP on Direct Bus";
			objRecaps.netWrittenLbl = "NL Paid";
			objRecaps.cededLbl = "LOSSES RECOV. ON CEDED BUSINESS";
			objRecaps.inwLbl = "LOSSES ON ASSUMED BUSINESS";
			objRecaps.retLbl = "LOSS RECOV. ON RETROCED BUSINESS";
		}else if(objRecaps.type == "Comm"){
			objRecaps.rowTitle = "Policy No.";
			objRecaps.directAmtLbl = "ComExp On DBus";
			objRecaps.directNetLbl = "NCExp on DBus";
			objRecaps.netWrittenLbl = "Net Comm Exp";
			objRecaps.cededLbl = "COMM INCOME FROM CEDED BUSINESS";
			objRecaps.inwLbl = "COMM EXPENSES ON ASSUMED BUSINESS";
			objRecaps.retLbl = "COMM INCOME FROM RETCEDED BUSINESS";
		}else if(objRecaps.type == "Tsi"){
			objRecaps.rowTitle = "Policy No.";
			objRecaps.directAmtLbl = "Direct Business";
			objRecaps.directNetLbl = "NR on Direct Bus";
			objRecaps.netWrittenLbl = "Net Risks Written";
			objRecaps.cededLbl = "R I S K S &nbspC E D E D";
			objRecaps.inwLbl = "R I S K S &nbspA S S U M E D";
			objRecaps.retLbl = "RISKS RETROCEDED";
		}else if(objRecaps.type == "OsLoss"){
			objRecaps.rowTitle = "Claim No.";
			objRecaps.directAmtLbl = "LCP On DBus";
			objRecaps.directNetLbl = "NLP on Direct Bus";
			objRecaps.netWrittenLbl = "NL Payable";
			objRecaps.cededLbl = "LOSSES AND CLAIMS RECOV. ON CEDED BUS.";
			objRecaps.inwLbl = "LOSSES PAYABLE ON ASSUMED BUSINESS";
			objRecaps.retLbl = "LOSS AND CLAIMS RECOV. ON RETROCED BUS.";
		}
	}
	
	function checkDates(print){
		var fromDate = $F("fromDate");
		var toDate = $F("toDate");
		
		if(checkAllRequiredFieldsInDiv("recapsDateDiv")){
			if(Date.parse(fromDate) > Date.parse(toDate)){
				showMessageBox("The ending date must be greater than or equal to the start date. Please change the date parameters.", "I");
				$("fromDate").focus();
				return false;
			}else if(objRecaps.formVariables.recapFromDate == fromDate && objRecaps.formVariables.recapToDate == toDate){
				showConfirmBox("Confirmation", "You have already extracted data using the same date parameters. Extract again?(Doing so will erase your previous extract data and replace it with a new one)",
					"Yes", "No", function(){
						extractRecap(print);
					}, "", "2");
			}else{
				extractRecap(print);
			}
		}
	}
	
	function checkDatesOnPrint(){
		if(checkAllRequiredFieldsInDiv("recapsDateDiv")){
			if(objRecaps.formVariables.recapFromDate != $F("fromDate") || objRecaps.formVariables.recapToDate != $F("toDate")){
				showConfirmBox("Confirmation", "The specified period has not been extracted. Do you want to extract the data using the specified period?",
					"Yes", "No",function(){checkDates("Y");}, function(){checkDataFetched("Y");}, "1");
			}else{
				checkDataFetched("Y");
			}
		}
	}
	
	function extractRecap(print){
		try{
			new Ajax.Request(contextPath+"/GIACRecapDtlExtController",{
				method: "POST",
				parameters:{
					action: "extractRecap",
					fromDate: $F("fromDate"),
					toDate: $F("toDate")
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function(){
					showNotice("Processing, please wait...");
				},
				onComplete: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						updateFormVariables();
						showWaitingMessageBox("Extraction Complete.", "S", function(){
							checkDataFetched(print);
						});
					}
				}
			});
		}catch(e){
			showErrorMessage(action, e);
		}
	}
	
	function checkDataFetched(print){
		try{
			new Ajax.Request(contextPath+"/GIACRecapDtlExtController",{
				method: "POST",
				parameters:{
					action: "checkDataFetched"
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function(){
					showNotice("Checking extracted data, please wait...");
				},
				onComplete: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						if(parseInt(response.responseText) == 0){
							$("fromDate").focus();
							showMessageBox("No Data Found for the specified date.", "I");
						}else{
							if(nvl(print, "N") == "Y"){
								printReport();
							}
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("checkDataFetched", e);
		}
	}
	
	function updateFormVariables(){
		objRecaps.formVariables.recapFromDate = $F("fromDate");
		objRecaps.formVariables.recapToDate = $F("toDate");
	}
	
	function getReportType(){
		var reportType = "";
		$$("input[name='reportTypeRG']").each(function(c){
			if(c.checked){
				reportType = c.value;
			}
		});
		return reportType;
	}
	objRecaps.getReportType = getReportType;
	
	function printReport(){
		var fileType = "PDF";
		var withCSV = null;
		
		if($("pdfRB").checked){
			fileType = "PDF";
			withCSV = null;
		} else if($("csvRB").checked){
			fileType = "CSV";
			withCSV = "Y";
		}
		
		var content = contextPath+"/GeneralLedgerPrintController?action=printReport&reportType="+getReportType()+
						"&noOfCopies="+$F("txtNoOfCopies")+"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination")+
						"&fileType="+fileType+"&reportId=GIACR290";
		
		printGenericReport(content, "RECAPITULATION REPORTS", null, withCSV);
	}
	
	$("fromDate").observe("focus", function(){
		if($F("fromDate") != "" && $F("toDate") != ""){
			if(Date.parse($F("fromDate")) > Date.parse($F("toDate"))){
				showMessageBox("From Date should not be later than To Date.", "I");
				$("fromDate").value = "";
				$("fromDate").focus();
			}
		}
	});
	
	$("toDate").observe("focus", function(){
		if($F("toDate") != "" && $F("toDate") != ""){
			if(Date.parse($F("fromDate")) > Date.parse($F("toDate"))){
				showMessageBox("From Date should not be later than To Date.", "I");
				$("toDate").value = "";
				$("toDate").focus();
			}
		}
	});
	
	$("btnViewDetails").observe("click", function(){
		showRecapDetails();
	});
	
	$("btnExtract").observe("click", function(){
		checkDates("N");
	});
	
	$("btnPrint").observe("click", function(){
		if(checkAllRequiredFieldsInDiv("printerDiv")){
			if($F("selDestination") == "printer" && (isNaN($F("txtNoOfCopies")) || $F("txtNoOfCopies") <= 0)){
				showMessageBox("Invalid number of copies.", "E");
			}else{
				checkDatesOnPrint();
			}
		}
	});
	
	$("reloadForm").observe("click", function(){
		showRecapsIToV();
	});
	
	$("acExit").stopObserving();
	$("acExit").observe("click", function(){
		delete objRecaps;
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	});
	
	newFormInstance();
</script>
