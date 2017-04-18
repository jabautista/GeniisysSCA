<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="uwReportsMainDiv" name="uwReportsMainDiv">			
	<div id="uwReportsSubDiv" name="uwReportsSubDiv">
		<div class="" style="float: left; padding:15px 0 15px 0;">
			<div id="txtFieldsDiv" name="txtFieldsDiv" class="sectionDiv" style="padding-top: 5px; width: 586px; height: 251px; margin-left: 15px;" align="left">
				<table align="center" style="margin-top: 15px;">
					<tr>
						<td class="rightAligned">Cedant :</td>
						<td>
							<span class="lovSpan" style="width: 120px;">
								<input id="riCd" name="riCd" class="leftAligned upper" type="text" style="border: none; float: left; width: 90px; height: 13px; margin: 0px;" value="" maxlength="12">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchCedant" name="searchCedant" alt="Go" style="float: right;"/>
							</span>
						</td>
						<td style="padding-bottom: 3px;"><input tabindex="-1" id="riName" name="riName" type="text" readonly="readonly" style="height: 14px; width: 325px;" value=""></td>
					</tr>
				</table>
				
				<table align="center" style="margin-top: 20px;">
					<tr>
						<td class="rightAligned" id="lblCreditingBranch" name="lblCreditingBranch">Crediting Branch :</td>
						<td>
							<span class="lovSpan" style="width: 90px;">
								<input id="issCd" name="issCd" class="leftAligned upper" type="text" style="border: none; float: left; width: 60px; height: 13px; margin: 0px;" value="">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIssCd" name="searchIssCd" alt="Go" style="float: right;"/>
							</span>
						</td>
						<td style="padding-bottom: 3px;"><input tabindex="-1" id="issName" name="issName" type="text" readonly="readonly" style="height: 14px; width: 225px;" value=""></td>
					</tr>
					<tr>
						<td class="rightAligned">Line :</td>
						<td>
							<span class="lovSpan" style="width: 90px;">
								<input id="lineCd" name="lineCd" class="leftAligned upper" type="text" style="border: none; float: left; width: 60px; height: 13px; margin: 0px;" value="">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineCd" name="searchLineCd" alt="Go" style="float: right;"/>
							</span>
						</td>
						<td style="padding-bottom: 3px;"><input tabindex="-1" id="lineName" name="lineName" type="text" readonly="readonly" style="height: 14px; width: 225px;" value=""></td>
					</tr>
					<tr>
						<td class="rightAligned">Subline :</td>
						<td>
							<span class="lovSpan" style="width: 90px;">
								<input id="sublineCd" name="sublineCd" class="leftAligned upper" type="text" style="border: none; float: left; width: 60px; height: 13px; margin: 0px;" value="">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchSublineCd" name="searchSublineCd" alt="Go" style="float: right;"/>
							</span>
						</td>
						<td style="padding-bottom: 3px;"><input tabindex="-1" id="sublineName" name="sublineName" type="text" readonly="readonly" style="height: 14px; width: 225px;" value=""></td>
					</tr>
				</table>
				<table align="center" style="margin-top: 20px; margin-left: 135px;">
					<tr>
						<td class="rightAligned">From :</td>
						<td>
							<div style="float: left; border: solid 1px gray; width: 148px; height: 20px; margin-right: 3px;">
								<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 81%; border: none;" name="fromDate" id="fromDate" readonly="readonly"/>
								<img id="imgFmDate" alt="goPolicyNo" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"  onClick="scwShow($('fromDate'),this, null);"/>						
							</div>
						</td>
						<td class="leftAligned"><label style="padding-top: 2px; margin-top: 2px;">To :</label>
							<div style="float: left; border: solid 1px gray; width: 148px; height: 20px; margin-right: 3px;">
								<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 81%; border: none;" name="toDate" id="toDate" readonly="readonly"/>
								<img id="imgToDate" alt="goPolicyNo" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"  onClick="scwShow($('toDate'),this, null);"/>						
							</div>
						</td>
					</tr>
				</table>
			</div>
			
			<div id="dateDiv" name="dateDiv" class="sectionDiv" style="width: 300px; float: right; margin-right: 15px;">
				<label style="padding-left: 9px; padding-top: 5px; padding-bottom: 2px; font-weight: bold; text-align: center; border-bottom: 1px solid #E0E0E0; width: 290px;">Date</label>
				<table align="left" style="margin: 3px;">
					<tr><td><input value="1" title="Issue Date" type="radio" id="issueDate" name="dateRG" style="margin: 0 5px 0 5px; float: left;"><label for="issueDate">Issue Date</label></td></tr>
					<tr><td><input value="2" title="Incept Date" type="radio" id="inceptDate" name="dateRG" style="margin: 0 5px 0 5px; float: left;"><label for="inceptDate">Incept Date</label></td></tr>
					<tr><td><input value="3" title="Booking Month/Year" type="radio" id="booking" name="dateRG" style="margin: 0 5px 0 5px; float: left;"><label for="booking">Booking Month/Year</label></td></tr>
					<tr><td><input value="4" title="Acctg Entry Date" type="radio" id="acctgEntry" name="dateRG" style="margin: 0 5px 0 5px; float: left;"><label for="acctgEntry">Acctg Entry Date</label></td></tr>
				</table>
			</div>
			<div id="scopeDiv" name="scopeDiv" class="sectionDiv" style="width: 300px; float: right; margin-right: 15px;">
				<label style="padding-left: 9px; padding-top: 5px; padding-bottom: 2px; font-weight: bold; text-align: center; border-bottom: 1px solid #E0E0E0; width: 290px;">Scope</label>
				<table align="left" style="margin: 3px;">
					<tr><td><input value="1" title="Policies Only" type="radio" id="policiesOnly" name="scopeRG" style="margin: 0 5px 0 5px; float: left;"><label for="policiesOnly">Policies Only</label></td></tr>
					<tr><td><input value="2" title="Endorsements Only" type="radio" id="endorsementsOnly" name="scopeRG" style="margin: 0 5px 0 5px; float: left;"><label for="endorsementsOnly">Endorsements Only</label></td></tr>
					<tr><td><input value="3" title="All" type="radio" id="all" name="scopeRG" style="margin: 0 5px 0 5px; float: left;"><label for="allExcSpoiled">All</label></td></tr>
				</table>
			</div>
			<div id="typeDiv" name="typeDiv" class="sectionDiv" style="width: 300px; float: right; margin-right: 15px; height: 71px;">
				<label style="padding-left: 9px; padding-top: 5px; padding-bottom: 2px; font-weight: bold;  text-align: center; border-bottom: 1px solid #E0E0E0; width: 290px;">Type</label>
				<table align="left" style="margin: 3px; margin-top: 6px;">
					<tr><td><input value="1" title="Summary" type="radio" id="summary" name="typeRG" style="margin: 0 5px 0 5px; float: left;"><label for="summary">Summary</label></td></tr>
					<tr><td><input value="2" title="Detail" type="radio" id="detail" name="typeRG" style="margin: 0 5px 0 5px; float: left;"><label for="detail">Detail</label></td></tr>
				</table>
			</div>
			
			<div class="sectionDiv" style="float: left; width: 586px; height: 181px; margin-left: 15px;" id="printDialogFormDiv">
				<table style="float: left; padding: 30px 0 0 80px;">
					<tr>
						<td class="rightAligned">Destination</td>
						<td class="leftAligned">
							<select id="selDestination" style="width: 200px;">
								<option value="SCREEN">Screen</option>
								<option value="PRINTER">Printer</option>
								<option value="FILE">File</option>
								<option value="LOCAL">Local Printer</option>
							</select>
						</td>
					</tr>
					<tr>
						<td></td>
						<td>
							<input value="PDF" title="PDF" type="radio" id="pdfRB" name="fileRG" style="margin: 2px 5px 4px 5px; float: left;" checked="checked" disabled="disabled"><label for="pdfRB" style="margin: 2px 0 4px 0">PDF</label>
							<input value="EXCEL" title="Excel" type="radio" id="excelRB" name="fileRG" style="margin: 2px 4px 4px 25px; float: left; display: none;" disabled="disabled"><label for="excelRB" style="margin: 2px 0 4px 0; display: none;">Excel</label> <!-- apollo cruz 05.06.2015 - hides excel option - GENQA SR# 4359 -->
								<input value="CSV" title="CSV" type="radio" id="csvRB" name="fileRG" style="margin: 2px 4px 4px 50px; float: left;" disabled="disabled"><label for="csvRB" style="margin: 2px 0 4px 0">CSV</label>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Printer</td>
						<td class="leftAligned">
							<select id="selPrinter" style="width: 200px;" class="required">
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
							<input type="text" id="txtNoOfCopies" style="float: left; text-align: right; width: 175px;" class="required">
							<div style="float: left; width: 15px;">
								<img id="imgSpinUp" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; cursor: pointer;">
								<img id="imgSpinUpDisabled" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; display: none;">
								<img id="imgSpinDown" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; cursor: pointer;">
								<img id="imgSpinDownDisabled" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; display: none;">
							</div>					
						</td>
					</tr>
				</table>
				<table style="float: left; padding-top: 40px;">
					<tr><td><input type="button" class="button" style="width: 120px; margin-left: 15px;" id="btnExtract" name="btnExtract" value="Extract"></td></tr>
					<tr><td><input type="button" class="button" style="width: 120px; margin-left: 15px;" id="btnPrint" name="btnPrint" value="Print"></td></tr>
					<tr><td><input type="button" class="button" style="width: 120px; margin-left: 15px;" id="btnCancel" name="btnCancel" value="Cancel"></td></tr>
				</table>
			</div>
			<div id="edstDiv" name="edstDiv"" class="sectionDiv" style="width: 300px; float: right; margin-right: 15px; height: 28px;">
				<table align="center" style="padding: 3px;">
					<tr><td><input title="Include Special Policies" type="checkbox" id="incSpecialPolicies" name="incSpecialPolicies" style="margin: 0 5px 0 5px; float: left;"><label for="incSpecialPolicies">Include Special Policies</label></td></tr>
				</table>
			</div>
			<div id="lastExtractDiv" name="lastExtractDiv">
				<input id="lastFromDate" name="lastFromDate" type="hidden">
				<input id="lastToDate" name="lastToDate" type="hidden">
				<input id="lastDateParam" name="lastDateParam" type="hidden">
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
	toggleRequiredFields("screen");
	makeInputFieldUpperCase();
	initializeDefaultParameters();
	
	var dateParam = 0;
	var branchParam = 0;
	var scopeParam = 0;
	
	objUW.lastExtractInfo = JSON.parse('${lastExtractInfo}'.replace(/\\/g, '\\\\'));
	initializeLastExtractInfo();
	
	function initializeDefaultParameters(){
		$("summary").checked = true;
		$("all").checked = true;
		$("incSpecialPolicies").checked = false;		
		$("issueDate").checked = true;
	}
	
	function initializeLastExtractInfo(){
		$("fromDate").value = objUW.lastExtractInfo.fromDate == null ? "" : dateFormat(unescapeHTML2(objUW.lastExtractInfo.fromDate), 'mm-dd-yyyy'); //change by steven 1/30/2013; dapat kapag null hindi sysdate ung lumabas
		$("toDate").value = objUW.lastExtractInfo.toDate == null ? "" : dateFormat(unescapeHTML2(objUW.lastExtractInfo.toDate), 'mm-dd-yyyy'); //change by steven 1/30/2013; dapat kapag null hindi sysdate ung lumabas
		$("issCd").value = unescapeHTML2(objUW.lastExtractInfo.issCd == null ? "" : objUW.lastExtractInfo.issCd);
		$("issName").value = unescapeHTML2(objUW.lastExtractInfo.issName == null ? "ALL ISSUE SOURCE" : objUW.lastExtractInfo.issName);
		$("lineCd").value = unescapeHTML2(objUW.lastExtractInfo.lineCd == null ? "" : objUW.lastExtractInfo.lineCd);
		$("lineName").value = unescapeHTML2(objUW.lastExtractInfo.lineName == null ? "ALL LINES" : objUW.lastExtractInfo.lineName);
		$("sublineCd").value = unescapeHTML2(objUW.lastExtractInfo.sublineCd == null ? "" : objUW.lastExtractInfo.sublineCd);
		$("sublineName").value = unescapeHTML2(objUW.lastExtractInfo.sublineName == null ? "ALL SUBLINES" : objUW.lastExtractInfo.sublineName);
		$("riCd").value = objUW.lastExtractInfo.riCd == null ? "" : Number(objUW.lastExtractInfo.riCd).toPaddedString(12);
		$("riName").value = unescapeHTML2(objUW.lastExtractInfo.riName == null ? "ALL REINSURERS" : objUW.lastExtractInfo.riName);
		objUW.lastExtractInfo.specialPol == 'Y' ? $("incSpecialPolicies").checked = true : $("incSpecialPolicies").checked = false;
		$$("input[name='dateRG']").each(function(checkbox) {
			if(objUW.lastExtractInfo.paramDate == checkbox.value){
				checkbox.checked = true;
				$("lastDateParam").value = checkbox.value;
			}
		});
		$("lastFromDate").value = $F("fromDate");
		$("lastToDate").value = $F("toDate");
	}
	
	function toggleRequiredFields(dest){
		if(dest == "PRINTER"){			
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
			$("excelRB").disabled = true;
			$("csvRB").disabled = true;
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
			if(dest == "FILE"){
				$("pdfRB").disabled = false;
				$("excelRB").disabled = false;
				$("csvRB").disabled = false;
			}else{
				$("pdfRB").disabled = true;
				$("excelRB").disabled = true;
				$("csvRB").disabled = true;
			}
		}
	}
	
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
	
	$("issCd").observe("blur", function(){
		if($("issCd").value != ""){
			validateUwReportsIssCd();
		}else{
			$("issName").value = "ALL ISSUE SOURCE";
		}
	});
	
	$("lineCd").observe("blur", function(){
		if($("lineCd").value != ""){
			validateUwReportsLineCd();
		}else{
			$("lineName").value = "ALL LINES";
		}
	});
	
	$('sublineCd').observe("blur", function(){
		if($("sublineCd").value != ""){
			if($("lineCd").value == null || $("lineCd").value == ""){
				clearFocusElementOnError("sublineCd", "Invalid value for field SUBLINE_CD.");
			}else{
				validateUwReportsSublineCd();
			}
		}else{
			$("sublineName").value = "ALL SUBLINES";
		}
	});
	
	$("searchIssCd").observe("click", function(){
		showUwReportsIssLOV();
	});
	
	$("searchLineCd").observe("click", function(){
		showUwReportsLineLOV();
	});
	
	$("searchSublineCd").observe("click", function(){
		$F("lineCd") == '' || $F("lineCd") == null ? showMessageBox("List Of Values contains no entries.", "I") : showUwReportsSublineLOV();
	});
	
	$("btnCancel").observe("click", function(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	
	$("btnPrint").observe("click", function(){
		if(extracted == "Y"){
			if(isLastExtract()){
				validateBeforePrint();
			}else{
				var dateTitle = "";
				$$("input[name='dateRG']").each(function(checkbox) {
					if(checkbox.checked){
						dateTitle = checkbox.title;
					}
				});
				showConfirmBox("", "Your last extract was based on " + dateTitle + " from " + dateFormat($F("lastFromDate"), 'mmmm dd, yyyy') +
						" to " + dateFormat($F("lastToDate"), 'mmmm dd, yyyy') + ". Click Ok to print a report based on your last extract " +
						"or press Cancel to abort.", "Ok", "Cancel", printUwReports, "", "");
			}
		}else{
			showMessageBox("No Data Extracted.", "I");
		}
	});
	
	function validateBeforePrint(){
		$$("input[name='parameterRG']").each(function(checkbox) {
			checkbox.checked == true ? branchParam = checkbox.value : null;  
		});
		$$("input[name='scopeRG']").each(function(checkbox) {
			checkbox.checked == true ? scopeParam = checkbox.value : null;  
		});
		new Ajax.Request(contextPath+"/GIPIUwreportsExtController", {
			parameters: {
						action      : "validatePrint",
						printTab    : "inwardRI",
						branchParam : branchParam,
						scope		: scopeParam,
						issCd		: $F("issCd"),
						lineCd		: $F("lineCd"),
						sublineCd	: $F("sublineCd"),
						riCd		: $F("riCd")
						},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				showNotice("Processing information, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					if(response.responseText == null || response.responseText == ""){
						showMessageBox("No Data Extracted.", "I");
					}else{
						proceedPrint();
					}
				}
			}
		});
	}
	
	function proceedPrint(){
		if(extracted == "Y"){
			if($F("selDestination") == "PRINTER" && ($("selPrinter").value == "" || $("txtNoOfCopies").value == "")){
				showMessageBox(objCommonMessage.REQUIRED, "I");
			}else if($F("selDestination") == "PRINTER" && (isNaN($F("txtNoOfCopies")) || $F("txtNoOfCopies") <= 0)){
				showMessageBox("Invalid number of copies.", "I");
			}else{
				printUwReports();
			}
		}else{
			showMessageBox("No Data Extracted.", "I");	
		}
	}
	
	var prodReport = '${prodReport}';
	function printUwReports(){
		if($("detail").checked){
			if ($("csvRB").checked && $F("selDestination") == "FILE"){
				printProdReport("printGIPIR929B_CSV");
			}else{
				printProdReport("printGIPIR929B");
			}
		}else if($("summary").checked){
			if(prodReport == 1){
				if ($("csvRB").checked && $F("selDestination") == "FILE"){
					printProdReport("printGIPIR929A_CSV");
				}else{
					printProdReport("printGIPIR929A");
				}
			}else if(prodReport == 2){
				showMessageBox("Report is not yet existing.", "I");
			}else{
				showMessageBox("Parameter 'PROD_REPORT_EXTRACT' does not exist in GIIS_PARAMETERS.", "E");
			}
		}
	}
	
	function printProdReport(action){
		$$("input[name='parameterRG']").each(function(checkbox) {
			checkbox.checked == true ? branchParam = checkbox.value : null;  
		});
		$$("input[name='scopeRG']").each(function(checkbox) {
			checkbox.checked == true ? scopeParam = checkbox.value : null;  
		});
		try {
			var content = contextPath+"/UWProductionReportPrintController?action="+action+"&issParam="+branchParam+
					"&scope="+scopeParam+"&issCd="+$F("issCd")+"&lineCd="+$F("lineCd")+"&sublineCd="+$F("sublineCd")+
					"&noOfCopies="+$F("txtNoOfCopies")+"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination")+
					"&reportId="+action.substring(5)+/*"&assdNo="+$F("assdNo")+"&intmNo="+$F("intmNo")+"&intmType="+$F("intmType")+*/
					"&riCd="+$("riCd").value;
			
			if($F("selDestination") == "SCREEN"){
				showPdfReport(content, getReportTitle(action));
			}else if($F("selDestination") == "PRINTER"){
				new Ajax.Request(content, {
					method: "POST",
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							showMessageBox("Printing Completed.", "I");
						}
					}
				});
			}else if("FILE" == $F("selDestination")){
				var fileType = "PDF";
				
				if($("pdfRB").checked){
					fileType = "PDF";
				}else if ($("excelRB").checked){
					fileType = "XLS";
				}else if ($("csvRB").checked && action.contains("_CSV")){
					fileType = "CSV2";
				}else if($("csvRB").checked){
					fileType = "CSV";
				}
				
				new Ajax.Request(content, {
					method: "POST",
					parameters : {
						destination : "FILE",
						fileType    : fileType
					},
					evalScripts: true,
					asynchronous: true,
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							if(fileType == "CSV2"){
								copyFileToLocal(response, "csv");
							}else if(fileType == "CSV"){
								copyFileToLocal(response, "csv");
								deleteCSVFileFromServer(response.responseText);
							}else{
								copyFileToLocal(response);
							}
						} 
					}
				});
			}else if("LOCAL" == $F("selDestination")){
				new Ajax.Request(content, {
					method: "POST",
					parameters : {destination : "LOCAL"},
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							printToLocalPrinter(response.responseText);
						}
					}
				});
			}
		}catch(e){
			showErrorMessage("printProdReport: " + action, e);
		}
	}
	
	function getReportTitle(action){
		var title = "";
		if(action == "printGIPIR929A"){
			title = "Summarized Inward RI Production Register";
		}else if(action == "printGIPIR929B"){
			title = "Detailed Inward RI Production Register";
		}
		
		return title;
	}
	
	function isLastExtract(){
		var checkDateParam = 0;
		var result = true;
		$$("input[name='dateRG']").each(function(checkbox) {
			if(checkbox.checked){
				checkDateParam = checkbox.value;
			}
		});
		if($F("fromDate") != $F("lastFromDate") || $F("toDate") != $F("lastToDate") || checkDateParam != $F("lastDateParam")){
			result = false;
		}
		return result;
	}
	
	$("btnExtract").observe("click", extract);
	
	function extract(){
		if($("fromDate").value == "" || $("fromDate").value == null){
			clearFocusElementOnError("fromDate", "Please enter a From Date");
		}else if($("toDate").value == "" || $("toDate").value == null){
			clearFocusElementOnError("toDate", "Please enter a To Date");
		}else if(Date.parse($("fromDate").value) > Date.parse($("toDate").value)){
			showMessageBox("From Date should be earlier than To Date.", "I");
		}else{
			getUwReportsParams();
		}
	}
	
	function getUwReportsParams(){
		$$("input[name='parameterRG']").each(function(checkbox) {
			checkbox.checked == true ? branchParam = checkbox.value : null;  
		});
		$$("input[name='dateRG']").each(function(checkbox) {
			checkbox.checked == true ? dateParam = checkbox.value : null;  
		});
		$$("input[name='scopeRG']").each(function(checkbox) {
			checkbox.checked == true ? scopeParam = checkbox.value : null;  
		});
		checkUwReports();
	}
	
	function checkUwReports(){
		new Ajax.Request(contextPath+"/GIPIUwreportsExtController", {
			parameters: {
						action          : "checkUwReports",
						tabCheck        : "inward",
						scopeParam      : scopeParam,
						dateParam       : dateParam,
						fromDate        : $F("fromDate"),
						toDate          : $F("toDate"),
						specialPolParam : $("incSpecialPolicies").checked ? 'Y' : 'N',
						lineCd 	    	: $F("lineCd"),
						sublineCd       : $F("sublineCd"),
						issCd           : $F("issCd"),
						branchParam		: "1"
						},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				showNotice("Processing information, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					if(response.responseText == 'Y'){
						showConfirmBox("", "Data based from the given parameters were already extracted. Do you still want to continue?", "Ok", "Cancel", extractUwReports, "", "");
					}else{
						extractUwReports();
					}
				}
			}
		});
	}
	
	var extracted = "Y";
	function extractUwReports(){
		new Ajax.Request(contextPath+"/GIPIUwreportsExtController", {
			parameters: {
						action      	: "extractUwReports",
						tabExtract		: "inward",
						dateParam   	: dateParam,
						fromDate    	: $F("fromDate"),
						toDate      	: $F("toDate"),
						scopeParam		: "3",
						issCd	    	: $F("issCd"),
						lineCd      	: $F("lineCd"),
						sublineCd   	: $F("sublineCd"),
						riCd			: $F("riCd"),
						specialPolParam : $("incSpecialPolicies").checked ? 'Y' : 'N',
						branchParam		: "1"
						},
			asynchronous: false,
			evalScripts: true,
			onCreate : function() {
				showNotice("Working, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					showMessageBox(response.responseText, "I");
					if(response.responseText == "Extraction Process Done."){
						extracted = "Y";
						$("lastFromDate").value = $F("fromDate");
						$("lastToDate").value = $F("toDate");
						$("lastDateParam").value = dateParam;
					}else{
						extracted = "N";
					}
				}
			}
		});
	}
	
	$("riCd").observe("blur", function(){
		if($F("riCd") == ""){
			$("riName").value = "ALL REINSURERS";
		}else if($F("riCd") != "" && isNaN(parseInt($F("riCd"))) || parseInt($F("riCd")) < 0){
			clearFocusElementOnError("riCd", "Field must be of form 099999999999.");
			$("riName").value = "ALL REINSURERS";
		}else if($F("riCd") != ""){
			validateCedant();
		}
	});
	
	function validateCedant(){
		new Ajax.Request(contextPath+"/GIPIUwreportsExtController", {
			method: "GET",
			parameters: {action   : "validateCedant",
						 cedantCd : $F("riCd")},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(obj.riName == "" || obj.riName == null){
						clearFocusElementOnError("riCd", "Invalid value for field RI_CD.");
						$("riName").value = "ALL REINSURERS";
					}else{
						$("riCd").value = $F("riCd") != "" ? Number($F("riCd")).toPaddedString(12) : "";
						$("riName").value = obj.riName;
					}
				}
			}
		});
	}
	
	$("searchCedant").observe("click", function(){
		showCedantLOV();
	});
	
	function showCedantLOV(){
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {action: "getCedantLOV"},
				title: "Valid values for Cedant",
				width: 405,
				height: 386,
				columnModel:[
				             	{	id : "riName",
									title: "Cedant Name",
									width: '308px'
								},
								{	id : "riCd",
									title: "Cedant Code",
									width: '82px'
								}
							],
				draggable: true,
				onSelect : function(row){
					if(row != undefined) {
						$("riCd").value = Number(row.riCd).toPaddedString(12);
						$("riName").value = row.riName;
					}
				}
			});
		}catch(e){
			showErrorMessage("showCedantLOV",e);
		}
	}
	
	observeReloadForm("reloadForm", function(){showUWProductionReportsPage("showInwardRiTab");});
	
</script>