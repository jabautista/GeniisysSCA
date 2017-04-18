<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="printRecoveryRegisterDiv">
	<div class="sectionDiv" id="printDialogFormDiv" style="margin: 10px 0 3px 15px; float: left; width: 480px; height: 150px;" >
		<table style="float: left; padding: 25px 0 0 20px;">
			<tr>
				<td class="rightAligned">Destination</td>
				<td class="leftAligned">
					<select id="selDestination" style="width: 200px;">
						<option value="SCREEN">Screen</option>
						<option value="FILE">File</option>
						<option value="PRINTER">Printer</option>
						<option value="LOCAL">Local Printer</option>
					</select>
				</td>
			</tr>
			<tr>
				<td></td>
				<td>
					<input value="PDF" title="PDF" type="radio" id="pdfRB" name="fileRG" style="margin: 2px 5px 4px 5px; float: left;" checked="checked" disabled="disabled"><label for="pdfRB" style="margin: 2px 0 4px 0">PDF</label>
					<!-- <input value="EXCEL" title="Excel" type="radio" id="excelRB" name="fileRG" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="excelRB" style="margin: 2px 0 4px 0">Excel</label>-->
					<input value="CSV" title="CSV" type="radio" id="csvRB" name="fileRG" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="csvRB" style="margin: 2px 0 4px 0">CSV</label>
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
					<input type="text" id="txtNoOfCopies" style="float: left; text-align: right; width: 175px;" class="required integerNoNegativeUnformattedNoComma" maxlength="3">
					<div style="float: left; width: 15px;">
						<img id="imgSpinUp" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; cursor: pointer;">
						<img id="imgSpinUpDisabled" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; display: none;">
						<img id="imgSpinDown" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; cursor: pointer;">
						<img id="imgSpinDownDisabled" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; display: none;">
					</div>					
				</td>
			</tr>
		</table>
		<table style="float: right; padding: 35px 30px 0 0;">
			<tr><td><input type="button" class="button" style="width: 90px; margin-left: 15px;" id="btnPrint" name="btnPrint" value="Print"></td></tr>
			<tr><td><input type="button" class="button" style="width: 90px; margin-left: 15px;" id="btnCancel" name="btnCancel" value="Cancel"></td></tr>
		</table>
	</div>
	
	<div id="printCheckboxDiv" class="sectionDiv" style="float: left; width: 480px; height: 80px; margin-left: 15px;">
		<table id="printCheckboxTbl" align="center" style="margin-top: 20px;">
			<tr><td><input id="chkClmRecReg" type="checkbox" style="float: left; margin: 0 7px 7px 0;"><label for="chkClmRecReg">Claim Recovery Register</label></td></tr>
			<tr><td><input id="chkSalvageRec" type="checkbox" style="float: left; margin:0 7px 0 0;"><label for="chkSalvageRec">Schedule of Salvage Recoveries</label></td></tr>
		</table>
	</div>
</div>


<script type="text/javascript">
	var reports = [];
	var reportsList = JSON.parse('${reportsList}'.replace(/\\/g, '\\\\'));
	
	toggleRequiredFields("screen");
	
	
	if(objGICLS201.dateRG == 1){
		if (objGICLS201.recTypeCd == "" || objGICLS201.recTypeCd == "SP"){
			if(objGICLS201.regDateRG == 3){
				$("chkClmRecReg").checked = true;
				$("chkSalvageRec").checked = true;
				$("chkClmRecReg").disabled = false;
				$("chkSalvageRec").disabled = false;
			}else{
				$("chkClmRecReg").checked = true;
				$("chkSalvageRec").checked = false;
				$("chkClmRecReg").disabled = false;
				$("chkSalvageRec").disabled = true;				
			}
		}else{
			$("chkClmRecReg").checked = true;
			$("chkSalvageRec").checked = false;
			$("chkClmRecReg").disabled = false;
			$("chkSalvageRec").disabled = true;	
		}
	}else{
		$("chkClmRecReg").checked = true;
		$("chkSalvageRec").checked = true;
		$("chkClmRecReg").disabled = true;
		$("chkSalvageRec").disabled = true;
	}

	$("imgSpinUp").observe("click", function(){
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		if (no < 100){
			$("txtNoOfCopies").value = no + 1;
		}	
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
	
	$("txtNoOfCopies").observe("change", function() {
		if($F("txtNoOfCopies") == 0 || $F("txtNoOfCopies") > 100){
			customShowMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "I", "txtNoOfCopies");
			$("txtNoOfCopies").value = "";
		}
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
			//$("excelRB").disabled = true;
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
				//$("excelRB").disabled = false;
				$("csvRB").disabled = false;
			}else{
				$("pdfRB").disabled = true;
				//$("excelRB").disabled = true;
				$("csvRB").disabled = true;
			}
		}
	}
	
	
	$("btnCancel").observe("click", function(){
		genericObjOverlay.close();
	});
	
	$("btnPrint").observe("click", function(){
		/*  commented out by shan 10.21.2013
		if($F("selDestination") == "PRINTER" && ($F("selPrinter") == "" || $F("txtNoOfCopies") == "")){
			showMessageBox("Printer and No. of Copies are required.", "I");
		}else if($F("selDestination") == "PRINTER" && (isNaN($F("txtNoOfCopies")) || $F("txtNoOfCopies") <= 0)){
			showMessageBox("Invalid number of copies.", "I"); 
		} */if (checkAllRequiredFieldsInDiv('printDialogFormDiv')){
			var content = null;
			
			/* commented out/edited by shan 10.21.2013
			if(reportsList.length == 0){
				showMessageBox("No data found in GIIS_REPORTS.", "I");
			}else {
				for (var b=0; b < reportsList.length; b++){*/
					if(objGICLS201.dateRG == 1){
						if($("chkClmRecReg").checked /* && reportsList[b].REPORT_ID == "GICLR201" */){	// Claim Recovery Register
							content = contextPath+"/PrintClaimsRecoveryRegisterController?action=printCLRecRegReports&noOfCopies="+
							  		  $F("txtNoOfCopies")+"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination")
							  		  +"&reportId="+/*reportsList[b].REPORT_ID*/ "GICLR201"+"&fromDate="+objGICLS201.fromDate+"&toDate="+objGICLS201.toDate+
									  "&lineCd="+objGICLS201.lineCd+"&issCd="+objGICLS201.issCd+"&recTypeCd="+objGICLS201.recTypeCd+
									  "&dateSw="+objGICLS201.regDateRG;	
							reports.push({reportUrl: content, reportTitle: /* reportsList[b].REPORT_TITLE */ "Claim Recovery Register"});
						}
						
						if($("chkSalvageRec").checked /*  && reportsList[b].REPORT_ID == "GICLR201A" */ ){	// Schedule of Salvage Recoveries
							content = contextPath+"/PrintClaimsRecoveryRegisterController?action=printCLRecRegReports&noOfCopies="+
							  		  $F("txtNoOfCopies")+"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination")
							  		  +"&reportId="+/* reportsList[b].REPORT_ID */ "GICLR201A"+"&fromDate="+objGICLS201.fromDate+"&toDate="+objGICLS201.toDate+
							 		  "&lineCd="+objGICLS201.lineCd+"&issCd="+objGICLS201.issCd+"&recTypeCd="+objGICLS201.recTypeCd+
							  		  "&dateSw="+objGICLS201.regDateRG;
							reports.push({reportUrl: content, reportTitle: /* reportsList[b].REPORT_TITLE */ "Schedule of Salvage Recoveries"});
						}
						
					}
					if (objGICLS201.dateRG != 1 /*  && reportsList[b].REPORT_ID == "GICLR202"  */){	// Outstanding Claim Recoveries as of
						content = contextPath+"/PrintClaimsRecoveryRegisterController?action=printCLRecRegReports&noOfCopies="+
						  		  $F("txtNoOfCopies")+"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination")
						  		  +"&reportId="+/* reportsList[b].REPORT_ID */ "GICLR202"+"&asOfDate="+objGICLS201.asOfDate+"&lineCd="+objGICLS201.lineCd
						 		  +"&issCd="+objGICLS201.issCd+"&recTypeCd="+objGICLS201.recTypeCd;	
						reports.push({reportUrl: content, reportTitle: /* reportsList[b].REPORT_TITLE */ "Outstanding Claim Recoveries"});
					}
				/*}
			}*/
			
			printGICLS201Reports();
		}
	});
	
	function printGICLS201Reports(){
		try{
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
									showMessageBox("Printing complete.", "I");
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
						var fileType = "PDF";
						
						if($("pdfRB").checked)
							fileType = "PDF";
						/* else if ($("excelRB").checked)
							fileType = "XLS"; */
						else if ($("csvRB").checked)
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
								/*	if ($("csvRB").checked){
										copyFileToLocal(response, "csv");
										deleteCSVFileFromServer(response.responseText);
									}else */
										//copyFileToLocal(response);
									//start: Herbert  SR 5398
									var repType = fileType == "CSV" ? "csv" : "reports";
									if($("geniisysAppletUtil") == null || $("geniisysAppletUtil").copyFileToLocal == undefined){
										showMessageBox("Local printer applet is not configured properly. Please verify if you have accepted to run the Geniisys Utility Applet and if the java plugin in your browser is enabled.", imgMessage.ERROR);
									} else {
										var message = $("geniisysAppletUtil").copyFileToLocal(response.responseText, repType);
										if(fileType == "CSV"){
											deleteCSVFileFromServer(response.responseText);
										}
										if(message.include("SUCCESS")){
											showMessageBox("Report file generated to " + message.substring(9), "I");	
										} else {
											showMessageBox(message, "E");
										}
									}
								//end Herbert  SR 5398
								}
							}
						});
					}			
				}
			}
			
			reports = [];
			genericObjOverlay.close();
		}catch(e){
			showErrorMessage("printGICLS201Reports", e);
		}
	}
	
	initializeAll();
</script>