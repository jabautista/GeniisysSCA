<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="printDialogMainDiv" style="width: 99.5%; padding-top: 10px; float: left;" align="center">
	<div class="sectionDiv" style="float: left; display: none;" id="printDialogFormDiv3"></div>
	<div class="sectionDiv" style="float: left;" id="printDialogFormDiv">
		<table id="printDialogMainTab" name="printDialogMainTab" align="center" style="padding: 10px;">
			<tr>
				<td class="rightAligned">Destination</td>
				<td class="leftAligned">
					<select id="selDestination" style="width: 200px;">
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
					<input value="PDF" title="PDF" type="radio" id="rdoPdf" name="fileType" style="margin: 2px 5px 4px 5px; float: left;" checked="checked" disabled="disabled"><label for="rdoPdf" style="margin: 2px 0 4px 0">PDF</label>
					<input value="CSV" title="CSV" type="radio" id="rdoExcel" name="fileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="rdoExcel" style="margin: 2px 0 4px 0">CSV</label><!-- modified to CSV instead of Excel -->
				</td>
			</tr>	
			<tr>
				<td class="rightAligned">Printer</td>
				<td class="leftAligned">
					<select id="selPrinter" style="width: 200px;" class="required">
						<option></option>
						<%-- <c:forEach var="p" items="${printers}">
							<option value="${p.printerNo}">${p.printerName}</option>
						</c:forEach> --%>
						<!-- installed printers muna gamitin - andrew - 02.27.2012 -->
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
	</div>
	<div id="buttonsDiv" style="float: left; width: 100%; margin-top: 10px; margin-bottom: 5px;">
		<input type="button" class="button" id="btnPrint" name="btnPrint" value="Print" style="width: 80px;">
		<input type="button" class="button" id="btnPrintCancel" name="btnPrintCancel" value="Cancel">		
	</div>	
</div>
   
<script type="text/javascript">
	initializeAll();

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
			$("rdoPdf").disable();
			$("rdoExcel").disable();
		} else {
			if(dest == "file"){
				$("rdoPdf").enable();
				$("rdoExcel").enable();
			} else {
				$("rdoPdf").disable();
				$("rdoExcel").disable();
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

	function getReportParams(){
		var reportId = "";
		var reportTitle = "";	
		var content = contextPath+"/UWPrintStatisticalReportsController?action=printReportsFireStatTab"+"&noOfCopies="
					  +$F("txtNoOfCopies")+"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination");
		
		if((objGIPIS901.commAccumSw != true && objGIPIS901.printSw == "T") || objGIPIS901.printSw == "Z"){
			if (objGIPIS901.printSw == "T"){
				reportId = "GIPIR037C";
				reportTitle = "FIRE STATISTICAL REPORT BY TARIFF";				
			}else{
				reportId = "GIPIR037B";
				reportTitle = "FIRE STATISTICAL REPORT BY ZONE";
			}
			content = content+"&reportId="+reportId+"&zone="+objGIPIS901.extractPrevParam[0].zone+"&pDate="+objGIPIS901.extractPrevParam[0].dateParam
					 +"&asOfDate="+objGIPIS901.extractPrevParam[0].asOfDate+"&asOfSw="+objGIPIS901.asOfSw+"&dateFrom="+objGIPIS901.extractPrevParam[0].dateFrom
					 +"&dateTo="+objGIPIS901.extractPrevParam[0].dateTo+"&businessCd="+objGIPIS901.extractPrevParam[0].busCd+"&zoneType="+
					  objGIPIS901.extractPrevParam[0].zoneType+"&lineCdFi="+objGIPIS901.lineCdFi;//added zone_type edgar 04/14/2015
			
			printReport(content, reportTitle);
		}else if(objGIPIS901.printSw == "R" || (objGIPIS901.commAccumSw == true && objGIPIS901.printSw == "T") || objGIPIS901.printSw == "F"){
			if (objGIPIS901.printSw == "R"){
				reportId = "GIPIR039E"; //modified to GIPIR039E : edgar 04/17/2015
				reportTitle = "COMMITMENT AND ACCUMULATION SUMMARY-TOTAL RETENTION";
			}else if(objGIPIS901.printSw == "T"){
				reportId = "GIPIR039E"; //modified to GIPIR039E : edgar 04/17/2015
				reportTitle = "COMMITMENT AND ACCUMULATION SUMMARY-TREATY";
			}else if(objGIPIS901.printSw == "F"){
				reportId = "GIPIR039E"; //modified to GIPIR039E : edgar 04/17/2015
				reportTitle = "COMMITMENT AND ACCUMULATION SUMMARY-TOTAL FACULTATIVE";
			}
			
			new Ajax.Request(contextPath+"/GIPIGenerateStatisticalReportsController", {
				parameters: {
					action:		"getTrtyTypeCd",
					distShare:	objGIPIS901.commitAccumDistShare
				},
				onComplete: function(response){
					if (checkErrorOnResponse(response)){
						content = content+"&reportId="+reportId+"&asOfDate="+objGIPIS901.extractPrevParam[0].asOfDate+"&asOfSw="+objGIPIS901.asOfSw+
								  "&dateFrom="+objGIPIS901.extractPrevParam[0].dateFrom+"&dateTo="+objGIPIS901.extractPrevParam[0].dateTo+
								  "&businessCd="+objGIPIS901.extractPrevParam[0].busCd+"&trtyTypeCd="+response.responseText+"&zoneType="+
								  objGIPIS901.extractPrevParam[0].zoneType+"&table="+objGIPIS901.tableName+"&column="+objGIPIS901.columnName
								  +"&pDate="+objGIPIS901.extractPrevParam[0].dateParam+"&shareType="+objGIPIS901.commitAccumShareType+
								  "&acctTrtyType="+objGIPIS901.commitAccumAcctTrtyType+"&consolSw="+objGIPIS901.consolSw+"&printSw="+objGIPIS901.printSw+"&riskCnt="+objGIPIS901.extractPrevParam[0].riskCnt; //added share_type and acct_trty_type : edgar 03/23/2015 // added parameters : edgar 05/08/2015 SR 4328
								  
						printReport(content, reportTitle);		  
					}
				}
			});
			
		}
	}
	
	function printReport(content, reportTitle){
		try{
			if($F("selDestination") == "screen"){
				showPdfReport(content, reportTitle);
			} else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					method: "POST",
					evalScripts: true,
					asynchronous: true,
					onCreate: showNotice("Processing, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							showMessageBox("Printing Completed.", "I");
						}
					}
				});
			}else if("file" == $F("selDestination")){
					//added validation for consolidate switch : edgar 04/15/2015
				    if($("rdoExcel").checked == false && objGIPIS901.consolSw == 'Y' && objGIPIS901.fromCommAccum == 'Y'){
						showMessageBox("Consolidate All Records is only available for Print to CSV.", "I");
						return false;
					}
					new Ajax.Request(content, {
						method: "POST",
						parameters : {destination : "FILE",
									  fileType    : $("rdoPdf").checked ? "PDF" : "CSV"}, //modified edgar 04/13/2015
						evalScripts: true,
						asynchronous: true,
						onCreate: showNotice("Generating report, please wait..."),
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								//copyFileToLocal(response); //commented out edgar 04/22/2015 
								if ($("rdoExcel").checked){ //added by edgar 04/22/2015
									copyFileToLocalFireStat(response, "csv"); 
									deleteCSVFileFromServer(response.responseText);
								} else 
									copyFileToLocalFireStat(response);
							}
						}
					});
			} else if("local" == $F("selDestination")){
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
			showErrorMessage("printReport", e);
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
	
	$("btnPrint").observe("click", function(){
		var dest = $F("selDestination");
		if(dest == "printer"){
			if(checkAllRequiredFieldsInDiv("printDialogFormDiv")){
				getReportParams();
			}
		}else{
			getReportParams();
		}	
	});

	$("btnPrintCancel").observe("click", function(){
		overlayFirePrintDialog.close();
	});
	
	//edgar 04/22/2015
	function copyFileToLocalFireStat(response, subFolder, onOkFunc){ 
		try {
			subFolder = (subFolder == null || subFolder == "" ? "reports" : subFolder);
			if($("geniisysAppletUtil") == null || $("geniisysAppletUtil").copyFileToLocal == undefined){
				showMessageBox("Local printer applet is not configured properly. Please verify if you have accepted to run the Geniisys Utility Applet and if the java plugin in your browser is enabled.", imgMessage.ERROR);
			} else {
				var message = $("geniisysAppletUtil").copyFileToLocal(response.responseText, subFolder);
				if(message.include("SUCCESS")){
					showWaitingMessageBox("Report file generated to " + message.substring(9), "I", function(){
						if(onOkFunc != null)
							onOkFunc();
					});
				} else {
					showMessageBox(message, "E");
				}			
			}
			new Ajax.Request(contextPath + "/GIISController", {
				parameters : {
					action : "deletePrintedReport",
					url : response.responseText
				}
			});
		} catch(e){
			showErrorMessage("copyFileToLocalFireStat", e);
		}
	}	
	toggleRequiredFields("screen");	
</script>
