<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="printDialogMainDiv" style="width: 99.5%; padding-top: 5px; float: left;">
	<input type="hidden" id="printerNames" name="printerNames" value="${printerNames}">
	<input type="hidden" id="reportId"     name="reportId" 	   value="${reportId}">
	<div class="sectionDiv" style="float: left;" id="printDialogFormDiv">
		<table align="center" style="padding: 10px;">
			<tr>
				<td class="rightAligned" style="width: 100px;">Destination</td>
				<td class="leftAligned">
					<select id="selDestination" style="width: 200px;">
						<option value="screen">Screen</option>
						<option value="printer">Printer</option>
						<option value="file">File</option>
						<option value="local">Local Printer</option>
					</select>
				</td>
				<td rowspan="6" style="text-align: center;">
					<input type="button" class="button" id="btnPrint" name="btnPrint" value="Print" style="width: 80px; margin-bottom: 5px;">
					<input type="button" class="button" id="btnCancel" name="btnCancel" value="Cancel">		
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 100px;">Printer</td>
				<td class="leftAligned">
					<select id="selPrinter" style="width: 200px;" class="required">
						<option></option>
						<c:forEach var="p" items="${printers}">
							<%-- <option value="${p.printerNo}">${p.printerName}</option> --%>
							<option value="${p.name}">${p.name}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 100px;">No. of Copies</td>
				<td class="leftAligned">
					<!-- <input type="text" id="txtNoOfCopies" style="float: left; text-align: right; width: 175px;" class="required wholeNumber"> -->
					<input type="text" id="txtNoOfCopies" maxlength="3" style="float: left; text-align: right; width: 175px;" class="required integerNoNegativeUnformattedNoComma" lastValidValue="">
					<div style="float: left; width: 15px;">
						<img id="imgSpinUp" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; cursor: pointer;">
						<img id="imgSpinUpDisabled" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; display: none;">
						<img id="imgSpinDown" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; cursor: pointer;">
						<img id="imgSpinDownDisabled" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; display: none;">
					</div>					
				</td>
			</tr>
		</table>
		<table style="padding-bottom: 10px;" cellpadding="3">
			<tr>
				<td class="rightAligned" style="width: 150px;">
					<input type="checkbox" id="chkBatchCsrReport" name="chkBatchCsrReport"/>
				</td>
				<td class="leftAligned">Batch CSR</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 150px;">
				<input type="checkbox" id="chkDetailsReport" name="chkDetailsReport"/>
			</td>
			<td class="leftAligned">Details</td>
			</tr>
		</table>
	</div>	
</div>
<script type="text/javascript">
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
		}
	}

	$("btnCancel").observe("click", function(){
		overlayGenericPrintDialog.close();
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
		toggleRequiredFields(dest);
	});	
	
	$("btnPrint").observe("click", function(){
		prepareToPrintBCSR();
	});
	
	function prepareToPrintBCSR(){
		var dest = $F("selDestination");
		var reportId = $F("reportId");
		var reportIdArray = [reportId,"GICLR044B"];
		
		function printBCSR(){
			if($("chkDetailsReport").checked && $("chkBatchCsrReport").checked){ //added by steven 08.08.2014
				for ( var i = 0; i < reportIdArray.length; i++) {
					setPrintReportArray(reportIdArray[i]);
				}
			}else if($("chkBatchCsrReport").checked){
				setPrintReportArray(reportId);
			}else if($("chkDetailsReport").checked){
				setPrintReportArray("GICLR044B");
			}else{
				showMessageBox("There is no report to print.", "I");
			}
		}
		
		if(dest == "printer"){
			if(checkAllRequiredFieldsInDiv("printDialogFormDiv")){
				printBCSR();
				overlayGenericPrintDialog.close();
			}
		}else if(dest == "screen"){
			printBCSR();
			showMultiPdfReport(reports);
			reports = [];
			overlayGenericPrintDialog.close();
		}else{
			printBCSR();
			overlayGenericPrintDialog.close();
		}
	}
	//added by steven 08.08.2014
	function setPrintReportArray(reportId) {
		try {
			var action = "printBCSRReport";
			var reportTitle = "";
			var outTitle = "";
			var destination	= $("selDestination").value;
			var printerName = $("selPrinter").value;
			var noOfCopies 	= $("txtNoOfCopies").value;
			
			if(reportId == "GICLR043"){
				action = "printBCSRReport";
				reportTitle = "Preliminary Batch CSR";
				outTitle = "PRELIM_BCSR";
			}else if(reportId == "GICLR044"){
				action = "printBCSRReport";
				reportTitle = "Final Batch CSR";
				outTitle = "FINAL_BCSR";
			}else if(reportId == "GICLR044B"){
				action = "printBCSRReport";
				reportTitle = "Batch CSR Details";
				outTitle = "BCSR_DTL";
			}
			
			var content = contextPath+"/PrintBatchCsrReportsController?action="+action
				+"&noOfCopies="+noOfCopies
				+"&printerName="+printerName
				+"&destination="+destination
				+"&fileType=PDF"
				+"&batchCsrId="+nvl(objBatchCsr.batchCsrId, 0)
				+"&reportId="+reportId
				+"&reportTitle="+reportTitle
				+"&outTitle="+outTitle;
			printReport(content, reportTitle);
		} catch (e) {
			showErrorMessage("printReport",e);
		}
	}
	
	function printReport(content, reportTitle){
		try{
			if("screen" == $F("selDestination")){
				reports.push({reportUrl : content, reportTitle : reportTitle});		
			}else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					parameters : {printerName : $F("selPrinter"),
								  noOfCopies : $F("txtNoOfCopies")},
					onCreate : showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if(checkErrorOnResponse(response)){
							showMessageBox("Printing complete.", "S");
						}
					}
				});
			}else if("file" == $F("selDestination")){
				new Ajax.Request(content, {
					parameters : {destination : "FILE"},
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							if($("geniisysAppletUtil") == null || $("geniisysAppletUtil").copyFileToLocal == undefined){
								showMessageBox("Local printer applet is not configured properly. Please verify if you have accepted to run the Geniisys Utility Applet and if the java plugin in your browser is enabled.", imgMessage.ERROR);
							} else {
								var message = $("geniisysAppletUtil").copyFileToLocal(response.responseText, "reports");
								if(message.include("SUCCESS")){
									showMessageBox("Report file generated to " + message.substring(9), "I");	
								} else {
									showMessageBox(message, "E");
								}
							}
						}
					}
				});
			}else if("local" == $F("selDestination")){
				new Ajax.Request(content, {
					parameters : {destination : "LOCAL"},
					onCreate : showNotice("Generating report, please wait..."),
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
		}catch(e){
			showErrorMessage("printGenericReport", e);
		}	
	}
	//end steven
	
	function setCheckboxesBehavior(clmDtlSw){
		if(nvl(clmDtlSw, "N") == "Y"){
			$("chkBatchCsrReport").enable();
			$("chkDetailsReport").enable();
			$("chkBatchCsrReport").checked = true;
			$("chkDetailsReport").checked = true;
		}else if(nvl(clmDtlSw, "N") == "N"){
			$("chkBatchCsrReport").disable();
			$("chkDetailsReport").disable();
			$("chkBatchCsrReport").checked = true;
			$("chkDetailsReport").checked = false;
		}
	}
	
	function setPrinterLOV(){
		var printerNames = $F("printerNames");
		var printers	 = printerNames.split(",");
		var selectContent = "<option value=''></option>";
		for (var i=0; i<printers.length; i++){
			selectContent = selectContent + "<option value='"+printers[i].toUpperCase()+"'>"+printers[i].toUpperCase()+"</option>";
		}
		$("selPrinter").update(selectContent);
	}
	
	$("txtNoOfCopies").observe("focus", function(){
		$("txtNoOfCopies").setAttribute("lastValidValue", $F("txtNoOfCopies"));
	});
	
	$("txtNoOfCopies").observe("change", function(){
		if($F("txtNoOfCopies").trim() != "" && (isNaN($F("txtNoOfCopies")) || parseInt($F("txtNoOfCopies")) <= 0 || parseInt($F("txtNoOfCopies")) > 100)){
			showWaitingMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "I", function(){
				$("txtNoOfCopies").value = $("txtNoOfCopies").readAttribute("lastValidValue");
			});			
		}
	});
	
	//setPrinterLOV();
	toggleRequiredFields("screen");
	initializeAll();
	setCheckboxesBehavior(objBatchCsr.claimDetailSwitch);
</script>