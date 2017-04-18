<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="ajax" uri="http://ajaxtags.org/tags/ajax" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="faculRiMainDiv" style="float: left; padding: 15px 0 5px 0;">
	<div id="reportDateDiv" name="reportDateDiv" class="sectionDiv" style="margin-left: 15px; padding-top: 5px; width: 607px; height: 180px;" align="center">
		<table id="reportDateTbl" align="center" style="margin: 65px 0 0 80px;">
			<tr>
				<td style="text-align: right; padding-right: 10px;">Report Month</td>
				<td>
					<select id="selReportMonth" style="width: 178px;">
						<option id=""></option>
						<option id="JAN">January</option>
						<option id="FEB">February</option>
						<option id="MAR">March</option>
						<option id="APR">April</option>
						<option id="MAY">May</option>
						<option id="JUN">June</option>
						<option id="JUL">July</option>
						<option id="AUG">August</option>
						<option id="SEP">September</option>
						<option id="OCT">October</option>
						<option id="NOV">November</option>
						<option id="DEC">December</option>						
					</select>
				</td>
			</tr>
			<tr>
				<td style="text-align: right; padding-right: 10px;">Report Year</td>
				<td><input id="txtReportYear" name="txtReportYear" type="text" class="integerNoNegativeUnformattedNoComma" maxlength="4" value="" style="width: 170px; text-align: right;" errorMsg="Legal characters are 0-9."></td>
			</tr>
		</table> 
	</div>
	
	<div id="rptLayoutDiv" name="rptLayoutDiv" class="sectionDiv" style="padding-top: 5px; width: 280px; height: 180px;" align="center">
		<table id="rptLayoutTbl" align="center" style="margin-top: 25px;">
			<tr>
				<td style="padding: 0 0 25px 25px;">Report Layout</td>
			</tr>
			<tr>
				<td>
					<input id="summaryRB" name="rptLayoutRG" type="radio" value="Summary" style="float: left; margin: 2px 5px 10px 0;"><label for="summaryRB" style="margin: 2px 0 4px 0;">Summary</label> 
				</td>
			</tr>
			<tr>
				<td>
					<input id="detailedRB" name="rptLayoutRG" type="radio" value="Detailed" checked="checked" style="float: left; margin: 2px 5px 10px 0;"><label for="detailedRB" style="margin: 2px 0 4px 0;">Detailed</label>
				</td>
			</tr>
		</table>
	</div>
	
	<div class="sectionDiv" id="printDialogFormDiv" style="margin-left: 15px; margin-bottom: 5px; float: left; width: 890px; height: 251px;" >
		<table style="float: left; padding: 55px 0 0 220px;">
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
					<input value="PDF" title="PDF" type="radio" id="pdfRB" name="fileRG" style="margin: 2px 5px 4px 25px; float: left;" checked="checked" disabled="disabled"><label for="pdfRB" style="margin: 2px 0 4px 0">PDF</label>
					<input value="EXCEL" title="Excel" type="radio" id="excelRB" name="fileRG" style="margin: 2px 4px 4px 50px; float: left;" disabled="disabled"><label for="excelRB" style="margin: 2px 0 4px 0">Excel</label>
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
					<input type="text" id="txtNoOfCopies" style="float: left; text-align: right; width: 175px;" class="required integerNoNegativeUnformattedNoComma">
					<div style="float: left; width: 15px;">
						<img id="imgSpinUp" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; cursor: pointer;">
						<img id="imgSpinUpDisabled" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; display: none;">
						<img id="imgSpinDown" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; cursor: pointer;">
						<img id="imgSpinDownDisabled" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; display: none;">
					</div>					
				</td>
			</tr>
		</table>
		<table style="float: left; padding: 65px 0 0 25px;">
			<tr><td><input type="button" class="button" style="width: 100px; margin-left: 15px;" id="btnPrint" name="btnPrint" value="Print"></td></tr>
			<tr><td><input type="button" class="button" style="width: 100px; margin-left: 15px;" id="btnCancel" name="btnCancel" value="Cancel"></td></tr>
		</table>
	</div>
</div>

<script type="text/javascript">
	initializeAll();
	toggleRequiredFields("screen");
	observeReloadForm("reloadForm", function(){showGenerateRIReportsTabPage("facultativeRITab");});
	
	var reportId = "";
	var reportTitle = "";
	
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
			}else{
				$("pdfRB").disabled = true;
				$("excelRB").disabled = true;
			}
		}
	}
	
	$("selReportMonth").observe("blur", function(){
		if ($F("selReportMonth") != ""){
			$("txtReportYear").value = new Date().getFullYear();
		}else{
			$("txtReportYear").value = "";
		}
	});
	
	$("btnPrint").observe("click", function(){
		if($F("selDestination") == "PRINTER" && ($("selPrinter").value == "" || $("txtNoOfCopies").value == "")){
			showMessageBox("Printer Name and No. of Copies are required.", "I");
		}else if($F("selDestination") == "PRINTER" && (isNaN($F("txtNoOfCopies")) || $F("txtNoOfCopies") <= 0)){
			showMessageBox("Invalid number of copies.", "I");
		}else{
			objRiReports.rep_type_sw = 5;
			
			if ($("summaryRB").checked){
				reportId = "GIRIR107";
				reportTitle = "Facultative Reinsurance Register (Summary)";
			}else if($("detailedRB").checked){
				reportId = "GIRIR106";
				reportTitle = "Facultative Reinsurance Register (Detailed)";
			}			
			printFaculRiReport();
		}
	});
	
	$("btnCancel").observe("click", function(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	
	
	function printFaculRiReport(){
		var content = contextPath+"/UWReinsuranceReportPrintController?action=printUWRiFacultativeReport&reportId="+reportId+
 			  			  "&reportMonth="+$F("selReportMonth")+"&reportYear="+$F("txtReportYear")+"&noOfCopies="+$F("txtNoOfCopies")+
 			  			  "&printerName="+$F("selPrinter")+"&destination="+$F("selDestination");

		if($F("selDestination") == "SCREEN"){
			showPdfReport(content, reportTitle);
		} else if($F("selDestination") == "PRINTER"){
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
				new Ajax.Request(content, {
					method: "POST",
					parameters : {destination : "FILE",
								  fileType    : $("pdfRB").checked ? "PDF" : "XLS"},
					evalScripts: true,
					asynchronous: true,
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							/*var message = $("fileUtil").copyFileToLocal(response.responseText);
							if(message != "SUCCESS"){
								showMessageBox(message, imgMessage.ERROR);
							}*/
							copyFileToLocal(response);
						}
					}
				});
		} else if("LOCAL" == $F("selDestination")){
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
		
		objRiReports.rep_type_sw = null;
	}
</script>