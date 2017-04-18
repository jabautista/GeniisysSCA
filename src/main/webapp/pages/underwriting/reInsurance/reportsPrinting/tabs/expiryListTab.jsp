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

<div id="expiryListTabDiv" style="float: left; padding: 15px 0 5px 0;">
	<div id="fieldsDiv" name="fieldsDiv" class="sectionDiv" style="float: left; margin: 0 0 0 15px; width: 607px; height: 200px;">
		<table id="fieldsTbl" name="fieldsTbl" style="margin: 40px 0 0 70px; width: 500px;">
			<tr>
				<td class="rightAligned" style="padding-right: 10px;">Line</td>
				<td colspan="3">
					<input id="txtLineCdExp" name="txtLineCdExp" type="hidden">
					<div id="lineExpDiv" style="border: 1px solid gray; width: 400px; height: 20px; ">
						<input id="txtLineNameExp" name="txtLineNameExp" type="text" maxlength="30" class="upper" style="border: none; float: left; width: 370px; height: 13px; margin: 0px;" value="">
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineNameExp" name="searchLineNameExp" alt="Go" style="float: right;"/>
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 10px;">Reinsurer</td>
				<td colspan="3">
					<input id="txtRiCdExp" name="txtRiCdExp" type="hidden">
					<div id="riExpDiv" style="border: 1px solid gray; width: 400px; height: 20px; ">
						<input id="txtRiSnameExp" name="txtRiSnameExp" type="text" maxlength="30" class="upper" style="border: none; float: left; width: 370px; height: 13px; margin: 0px;" value="">
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchRiSnameExp" name="searchRiSnameExp" alt="Go" style="float: right;"/>
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 10px;">Expiry Month</td>
				<td style="padding-right: 50px;">
					<select id="selExpiryMonth" name="selExpiryMonth" style="width: 160px;">
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
				<td style="padding-right: 10px;">Expiry Year</td>
				<td>
					<input id="txtExpiryYear" name="txtExpiryYear" type="text" maxlength="4" class="integerNoNegativeUnformattedNoComma" value="" style="width: 90px; text-align: right;" errorMsg="Legal characters are 0-9.">
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding: 0 10px 0 0;">Accept Month</td>
				<td style="padding-right: 50px;">
					<select id="selAcceptMonth" name="selAcceptMonth" style="width: 160px;">
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
				<td style="padding-right: 10px;">Accept Year</td>
				<td>
					<input id="txtAcceptYear" name="txtAcceptYear" type="text" maxlength="4" class="integerNoNegativeUnformattedNoComma" value="" style="width: 90px; text-align: right;" errorMsg="Legal characters are 0-9.">
				</td>
			</tr>
		</table>
	</div>
	
	<div id="reportDiv" name="reportDiv" class="sectionDiv" style="float: left; width: 280px; height: 200px;">
		<table id="reportTbl" name="reportTbl" style="margin: 30px 0 0 50px; width: 180px;">
			<tr>
				<td style="padding: 0 0 20px 45px;">Report Layout</td>
			</tr>
			<tr>
				<td style="padding-bottom: 20px;">
					<input id="chkReport" name="chkReport" type="checkbox" value="" style="margin-right: 8px;">Report
					<input id="chkLetter" name="chkLetter" type="checkbox" value="" style="margin: 0 8px 0 50px;">Letter					
				</td>
			</tr>
			<tr>
				<td><input id="assumedRB" name="expListRG" type="radio" value="A" style="float: left; margin: 0 0 7px 45px;" checked="checked"><label for="assumedRB" style="margin: 2px 0 4px 12px;">Assumed</label></td>
			</tr>
			<tr>
				<td><input id="outwardRB" name="expListRG" type="radio" value="E" style="float: left; margin: 0 0 7px 45px;"><label for="outwardRB" style="margin: 2px 0 4px 12px;">Outward</label></td>
			</tr>
		</table>
	</div>
	
	<div class="sectionDiv" id="printDialogFormDiv" style="margin-left: 15px; margin-bottom: 5px; float: left; width: 890px; height: 235px;" >
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
	makeInputFieldUpperCase();
	toggleRequiredFields("screen");
	observeReloadForm("reloadForm", function(){showGenerateRIReportsTabPage("expiryListTab");});
	
	var reports = [];
	var extract_id = null;
	
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
	
	$("searchLineNameExp").observe("click", function(){
		showRiReportsOutAcceptLineLOV("txtLineNameExp", "txtLineCdExp");	
	});
	
	$("searchRiSnameExp").observe("click", function(){
		showRiReportsRiSnameLOV("txtRiSnameExp", "txtRiCdExp");	
	});
	
	$("txtLineNameExp").observe("blur", function(){
		if($F("txtLineNameExp") != ""){
			validateRIReportsLineName("txtLineNameExp", "txtLineCdExp");
		}else{
			$("txtLineCdExp").value = "";
		}	
	});
	
	$("txtRiSnameExp").observe("blur", function(){
		if($F("txtRiSnameExp") != ""){
			validateRIReportsReinsurerSname("txtRiSnameExp", "txtRiCdExp", "Invalid value for field REINSURER NAME.");
		}else{
			$("txtRiCdExp").value = "";
		}
	});
	
	$("selExpiryMonth").observe("blur", function(){
		if ($F("selExpiryMonth") == ""){
			$("txtExpiryYear").value = "";
		}else{
			$("txtExpiryYear").value = new Date().getFullYear();
		}
	});
	
	
	$$("input[name='expListRG']").each(function(radio){
		radio.observe("click", function(){
			if (radio.value == "A"){
				$("selAcceptMonth").disabled = false;
				$("txtAcceptYear").disabled = false;
			}else if (radio.value == "E"){
				$("selAcceptMonth").value = "";
				$("txtAcceptYear").value = "";
				$("selAcceptMonth").disabled = true;
				$("txtAcceptYear").disabled = true;
			}
		});
	});
	
	$("btnPrint").observe("click", function(){
		if ($F("selExpiryMonth") == "" && $F("txtExpiryYear") != ""){
			showMessageBox("Please enter Expiry Month or delete Expiry Year to have correct parameters.", "I");
		}else if ($F("selExpiryMonth") != "" && $F("txtExpiryYear") == ""){
			showMessageBox("Please enter Expiry Year or delete Expiry Month to have correct parameters.", "I");
		}else if ($F("selAcceptMonth") == "" && $F("txtAcceptYear") != ""){
			showMessageBox("Please enter Accept Month or delete Accept Year to have correct parameters.", "I");
		}else if ($F("selAcceptMonth") != "" && $F("txtAcceptYear") == ""){
			showMessageBox("Please enter Accept Year or delete Accept Month to have correct parameters.", "I");
		}else{
			if ($("chkReport").checked == false && $("chkLetter").checked == false){
				showMessageBox("Please select the report format to be used.", "I");
			}else if($F("selDestination") == "PRINTER" && ($("selPrinter").value == "" || $("txtNoOfCopies").value == "")){
				showMessageBox("Printer Name and No. of Copies are required.", "I");
			}else if($F("selDestination") == "PRINTER" && (isNaN($F("txtNoOfCopies")) || $F("txtNoOfCopies") <= 0)){
				showMessageBox("Invalid number of copies.", "I");
			}else{
				prepareExpListReport();				
			}
		}
	});
	
	$("btnCancel").observe("click", function(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	
	
	function prepareExpListReport(){
		var rep = [{content: contextPath+"/UWReinsuranceReportPrintController?action=printUWRiExpListReport"+"&reportId=GIRIR110&riSname="+
			  				 $F("txtRiSnameExp")+"&lineName="+$F("txtLineNameExp")+"&expiryMonth="+$F("selExpiryMonth")+"&expiryYear="+
			  				 $F("txtExpiryYear")+"&noOfCopies="+$F("txtNoOfCopies")+"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination"),
			  		title: 	"Facultative Reinsurance Renewal Request"},
			  	   {content: contextPath+"/UWReinsuranceReportPrintController?action=printUWRiExpListReport"+"&reportId=GIEXR107&printBy=&riSname="+
						     $F("txtRiSnameExp")+"&lineName="+$F("txtLineNameExp")+"&expiryMonth="+$F("selExpiryMonth")+"&expiryYear="+
						     $F("txtExpiryYear")+"&noOfCopies="+$F("txtNoOfCopies")+"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination"),
			  		title:	 "Expiry List of Outward Reinsurance"}];
		
		if($("outwardRB").checked){
			if($("chkLetter").checked && $("chkReport").checked){
				objRiReports.rep_type_sw = null;
				reports.push({reportUrl: rep[0].content, reportTitle: rep[0].title});
				reports.push({reportUrl: rep[1].content, reportTitle: rep[1].title});
				printExpList();	
			}else if($("chkLetter").checked && $("chkReport").checked == false){
				reports.push({reportUrl: rep[0].content, reportTitle: rep[0].title});
				printExpList();
			}else if($("chkLetter").checked == false && $("chkReport").checked){
				objRiReports.rep_type_sw = 6;
				reports.push({reportUrl: rep[1].content, reportTitle: rep[1].title});
				printExpList();
				objRiReports.rep_type_sw = null;
			}
		}else if($("assumedRB").checked){
			if($("chkLetter").checked){
				extractInwTran("letter");		
			}
			if($("chkReport").checked){
				objRiReports.rep_type_sw = 3;
				extractInwTran("report");
				objRiReports.rep_type_sw = null;
			}
		}
	}
	
	function extractInwTran(reportType){
		try{
			new Ajax.Request(contextPath+"/GIRIGenerateRIReportsController",{
				method: "GET",
				parameters: {
					action:			"extractInwTran",
					lineCd:			$F("txtLineCdExp"),
					riCd:			$F("txtRiCdExp"),
					expiryMonth:	$F("selExpiryMonth"),
					expiryYear:		$F("txtExpiryYear"),
					acceptMonth:	$F("selAcceptMonth"),
					acceptYear:		$F("txtAcceptYear")
				},
				asynchronous: true,
				evalScripts: true,
				onCreate: showNotice("Extracting data for printing..."),
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						var obj = JSON.parse(response.responseText);
						extract_id = obj.extractId;
						
						if(reportType == "report"){
							var content = contextPath+"/UWReinsuranceReportPrintController?action=printUWRiExpListReport"+"&reportId=GIEXR106&extractId="+
										  extract_id+"&expiryMonth="+$F("selExpiryMonth")+"&expiryYear="+$F("txtExpiryYear")+"&noOfCopies="+$F("txtNoOfCopies")+
										  "&printerName="+$F("selPrinter")+"&destination="+$F("selDestination");
							reports.push({reportUrl: content, reportTitle: "Expiry List of Assumed Business"});
							printExpList();
						}else if(reportType == "letter"){					
							var content = contextPath+"/UWReinsuranceReportPrintController?action=printUWRiExpListReport"+"&reportId=GIRIR114&extractId="+
										  extract_id+"&expiryMonth="+$F("selExpiryMonth")+"&expiryYear="+$F("txtExpiryYear")+"&noOfCopies="+$F("txtNoOfCopies")+
										  "&printerName="+$F("selPrinter")+"&destination="+$F("selDestination");
							reports.push({reportUrl: content, reportTitle: "Inward Reinsurance Expiry List"});
							printExpList();
						}
						//deleteGiixInwTran(extract_id); --bert
					}
				}
			});
		}catch(e){
			showErrorMessage("extractInwTran", e);
		}
	}
	
	function deleteGiixInwTran(extract_id){
		try{
			new Ajax.Request(contextPath+"/GIRIGenerateRIReportsController",{
				method: "GET",
				parameters: {
					action:		"deleteGiixInwTran",
					extractId:	extract_id
				},
				asynchronous: true,
				evalScripts: true 
			});
		}catch(e){
			showErrorMessage("deleteGiixInwTran", e);
		}
	}
	
	function printExpList(){		
		if($F("selDestination") == "SCREEN"){
			showMultiPdfReport(reports);
		}else {
			for(var i=0; i < reports.length; i++){
				var content = reports[i].reportUrl;
				if($F("selDestination") == "PRINTER"){
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
				}			
			}
		}
		
		reports = [];
	}
	
	
</script>