<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div id="printMainDiv" align="center">
 	<div id="printOcvDiv" class="sectionDiv" style="margin: 10px 0 0 13px; width: 500px; height: 95px;">
 		<table align="center" style="margin-top: 15px;">
 			<tr>
 				<td class="rightAligned" style="padding-right: 7px;">Voucher No.</td>
 				<td>
 					<input id="txtVoucherPrefSuf" type="text" readonly="readonly" style="float: left; width: 50px;">
 					<label style="padding: 5px 5px 0 5px;"> - </label>
 				</td>
 				<td><input id="txtVoucherNo" type="text" readonly="readonly" class="rightAligned" style="width: 70px;"></td>
 				<td>
 					<input id="chkDetails" type="checkbox" style="float: left; margin-left: 12px;">
 					<label for="chkDetails" style="margin-left: 5px;"> Details </label>
 				</td>
 			</tr>
 			<tr>
 				<td class="rightAligned" style="padding-right: 7px;">Voucher Date</td>
 				<td colspan="3"><input id="txtVoucherDate" type="text" readonly="readonly" style="width: 145px;"></td>
 			</tr>
 		</table>
 	</div>
 
 	<div id="printListDiv" class="sectionDiv" style="margin: 10px 0 0 13px; width: 500px; height: 95px;">
 		<table align="center" style="margin-top: 15px;">
 			<tr>
				<td class="rightAligned" style="padding-right: 7px;">From</td>
				<td colspan="3">
					<div id="fromDateDiv" style="float: left; width: 150px;" class="withIconDiv">
						<input type="text" id="txtFromDate" name="txtFromDate" class="withIcon" readonly="readonly" style="width: 125px;"tabindex="109"/>
						<img id="imgFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date" tabindex="110"/>
					</div>										
					<label style="padding: 5px 8px 0 20px; float:left;">To</label>
					<div id="toDateDiv" style="float: left; width: 150px;" class="withIconDiv">
						<input type="text" id="txtToDate" name="txtToDate" class="withIcon" readonly="readonly" style="width: 125px;"tabindex="111"/>
						<img id="imgToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date"  tabindex="112"/>
					</div>
				</td>
			</tr>
			<tr>
				<td></td>
				<td style="padding: 10px 25px 0 0;">
					<input id="rbAll" name="inclItemsRG" type="radio" value="3" style="float: left;" checked="checked" >
					<label for="rbAll" style="margin: 2px 0 0 7px;" >All</label>
				</td>
				<td style="padding-top: 15px;">
					<input id="rbWithoutOcv" name="inclItemsRG" type="radio" value="2" style="float: left;" >
					<label for="rbWithoutOcv" style="margin: 2px 0 0 7px;" >Without OCV's</label>
				</td>
				<td style="padding-top: 15px;">
					<input id="rbWithOcv" name="inclItemsRG" type="radio" value="1" style="float: left;" >
					<label for="rbWithOcv" style="margin: 2px 0 0 7px;" >With OCV's</label>
				</td>
			</tr>
 		</table>
 	</div>
 
	<div class="sectionDiv" id="printDialogFormDiv" style="margin: 2px 0 0 13px; width: 500px; height: 155px;" >
		<table style="float: left; padding: 25px 0 0 30px;">
			<tr>
				<td class="rightAligned">Destination</td>
				<td class="leftAligned">
					<select id="selDestination" style="width: 200px;" tabindex="113">
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
					<div id="fileDiv">
						<input value="PDF" title="PDF" type="radio" id="pdfRB" name="fileRG" style="margin: 2px 5px 4px 25px; float: left;" checked="checked" disabled="disabled"><label for="pdfRB" style="margin: 2px 0 4px 0">PDF</label>
						<input value="EXCEL" title="Excel" type="radio" id="excelRB" name="fileRG" style="margin: 2px 4px 4px 50px; float: left;" disabled="disabled"><label for="excelRB" style="margin: 2px 0 4px 0">Excel</label>
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Printer</td>
				<td class="leftAligned">
					<select id="selPrinter" style="width: 200px;" class="required" tabindex="114">
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
					<input type="text" id="txtNoOfCopies" style="float: left; text-align: right; width: 175px;" class="required integerNoNegativeUnformattedNoComma" maxlength="3" tabindex="115">
					<div style="float: left; width: 15px;">
						<img id="imgSpinUp" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; cursor: pointer;">
						<img id="imgSpinUpDisabled" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; display: none;">
						<img id="imgSpinDown" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; cursor: pointer;">
						<img id="imgSpinDownDisabled" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; display: none;">
					</div>					
				</td>
			</tr>
		</table>
		<table style="float: left; padding: 35px 0 0 30px;">
			<tr><td><input type="button" class="button" style="width: 80px; margin-left: 15px; " id="btnPrint" name="btnPrint" value="Print" tabindex="116"></td></tr>
			<tr><td><input type="button" class="button" style="width: 80px; margin-left: 15px; " id="btnCancel" name="btnCancel" value="Cancel" tabindex="117"></td></tr>
		</table>
	</div>
</div>
 
 
 <script type="text/javascript">
 try{
	initializeAll();
	$("printOcvDiv").hide();
	$("printListDiv").hide();
	var printOk = null;
	var restoreOCV = null;
		
	objGIACS149.url = contextPath+"/GIACGenearalDisbReportController?action=showGIACS149Page&refresh=1&intmNo="+objGIACS149.intmNo+"&gaccTranId="
			  +objGIACS149.gfunFundCd+"&gibrBranchCd="+objGIACS149.gibrBranchCd+"&fromDate="+objGIACS149.fromDate+"&toDate="+objGIACS149.toDate
			  +"&objFilter={\"printTag\":\"N\"}";
	
	
	if(objGIACS149.callingForm == "PRINT_OCV"){
		$("printOcvDiv").show();
		$("fromDateDiv").removeClassName("required");
		$("txtFromDate").removeClassName("required");
		$("toDateDiv").removeClassName("required");
		$("txtToDate").removeClassName("required");
		$("fileDiv").hide();
		
		$("txtVoucherPrefSuf").value = objGIACS149.ocvPrefSuf == null ? objGIACS149.voucherPrefSuf : objGIACS149.ocvPrefSuf;
		$("txtVoucherNo").value = objGIACS149.ocvNo == null ? objGIACS149.voucherNo : objGIACS149.ocvNo;
		$("txtVoucherDate").value = objGIACS149.voucherDate == null ? null : dateFormat(objGIACS149.voucherDate, 'mm-dd-yyyy');
	}else if(objGIACS149.callingForm == "PRINT_LIST"){
		$("printListDiv").show();
		$("fromDateDiv").addClassName("required");
		$("txtFromDate").addClassName("required");
		$("toDateDiv").addClassName("required");
		$("txtToDate").addClassName("required");
		$("fileDiv").show();
		$("txtFromDate").value = objGIACS149.reportFromDate;
		$("txtToDate").value = objGIACS149.reportToDate;
		$$("input[name='inclItemsRG']").each(function(rb){
			if (objGIACS149.reportInclItems != null){
				if (rb.value == objGIACS149.reportInclItems){
					rb.checked = true;
				}else{
					rb.checked = false;
				}
			}			
		});
	}
	
	function toggleRequiredFields(dest){
		if(dest == "printer"){			
			$("selPrinter").disabled = false;
			$("txtNoOfCopies").disabled = false;
			$("imgSpinUp").show();
			$("imgSpinDown").show();
			$("imgSpinUpDisabled").hide();
			$("imgSpinDownDisabled").hide();
			$("txtNoOfCopies").value = 1;
			$("selPrinter").addClassName("required");
			$("txtNoOfCopies").addClassName("required");
			$("pdfRB").disabled = true;
			$("excelRB").disabled = true;
		} else {
			$("selPrinter").value = "";
			$("txtNoOfCopies").value = "";
			$("selPrinter").disabled = true;
			$("txtNoOfCopies").disabled = true;
			$("imgSpinUp").hide();
			$("imgSpinDown").hide();
			$("imgSpinUpDisabled").show();
			$("imgSpinDownDisabled").show();	
			$("selPrinter").removeClassName("required");
			$("txtNoOfCopies").removeClassName("required");
			if(dest == "file"){
				$("pdfRB").disabled = false;
				$("excelRB").disabled = false;
			}else{
				$("pdfRB").disabled = true;
				$("excelRB").disabled = true;
			}		
		}
	}	
	
	
	function getCVPref(){
		try{
			new Ajax.Request(contextPath+"/GIACGenearalDisbReportController",{
				parameters: {
					action:		"getCvPrefGIACS149",
					gfunFundCd:	objGIACS149.gfunFundCd //objGIACS149.selectedRow == null ? null : objGIACS149.selectedRow.gfunFundCd
				},
				evalScripts: true,
				asynchronous: false,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var json = JSON.parse(response.responseText);
						
						if (json.length == 0 || json.DOC_PREF_SUF == ""){
							showMessageBox("No data in GIAC_DOC_SEQUENCE for overriding commission voucher.", "E");
							return false;
						}else{
							objGIACS149.ocvBranch = json.BRANCH_CD;
							if (objGIACS149.ocvNo == null && objGIACS149.ocvPrefSuf == null){
								populateCvSeq(json.DOC_PREF_SUF);
							}else{
								getGpcv(json.DOC_PREF_SUF);
							}
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("getCVPref",e);
		}
	}
	
	
	function getGpcv(cvPref){
		try{
			var printOcv = (objGIACS149.ocvNo == null && objGIACS149.ocvPrefSuf == null) ? "Y" : "N"; 
			
			new Ajax.Request(contextPath+"/GIACGenearalDisbReportController",{
				method: "POST",
				parameters: {
					action:			"getGpcvGIACS149",
					intmNo:			objGIACS149.intmNo,
					voucherNo:		$F("txtVoucherNo"),
					cvPref:			$F("txtVoucherPrefSuf"),
					printOCV:		printOcv
				},
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						objGIACS149.gpcvSelect = JSON.parse(response.responseText);
						
						var reportId = null;
						var reportTitle = null;
						
						if ($("chkDetails").checked){
							reportId = "GIACR163A";
							reportTitle = "Overriding Commission Voucher (Detail)";
						}else{
							reportId = "GIACR163";
							reportTitle = "Overriding Commission Voucher";
						}
						
						var reportParams = "action=print"+reportId+"&reportId="+reportId+"&intmNo="+objGIACS149.intmNo+"&cvDate="+$F("txtVoucherDate")+
											"&commvPref="+objGIACS149.docName+"&commVcrNo="+$F("txtVoucherNo");
						
						printReport(reportId, reportTitle, reportParams);
					}
				}
			});
		}catch(e){
			showErrorMessage("getGpcv", e);
		}
	}
		
	function populateCvSeq(cvPref){
		try{
			var strParams = prepareJsonAsParameter(objGIACS149.checkedVouchers);
			
			new Ajax.Request(contextPath+"/GIACGenearalDisbReportController",{
				method: "POST",
				parameters: {
					action:			"populateCvSeqGIACS149",
					/*gfunFundCd:		objGIACS149.selectedRow == null ? null : objGIACS149.selectedRow.gfunFundCd,
					gibrBranchCd:	objGIACS149.selectedRow == null ? null : objGIACS149.selectedRow.gibrBranchCd,
					gaccTranId:		objGIACS149.selectedRow == null ? null : objGIACS149.selectedRow.gaccTranId,
					transactionType:objGIACS149.selectedRow == null ? null : objGIACS149.selectedRow.transactionType,
					issCd:			objGIACS149.selectedRow == null ? null : objGIACS149.selectedRow.issCd,
					premSeqNo:		objGIACS149.selectedRow == null ? null : objGIACS149.selectedRow.premSeqNo,
					instNo:			objGIACS149.selectedRow == null ? null : objGIACS149.selectedRow.instNo,
					intmNo:			objGIACS149.selectedRow == null ? null : objGIACS149.selectedRow.intmNo,
					chldIntmNo:		objGIACS149.selectedRow == null ? null : objGIACS149.selectedRow.chldIntmNo,
					cvNo:			objGIACS149.selectedRow == null ? null : nvl(objGIACS149.selectedRow.ocvNo, 0),*/
					checkedVouchers: strParams,
					cvPref:			cvPref,
					docName:		objGIACS149.docName,
					voucherNo:		$F("txtVoucherNo")
				},
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var json = JSON.parse(response.responseText);
						
						objGIACS149.reprint = json.reprint;
						$("txtVoucherNo").value = json.voucherNo;
						$("txtVoucherDate").value = json.voucherDate == null ? null : dateFormat(json.voucherDate, 'mm-dd-yyyy');
						
						getGpcv(cvPref);
					}
				}
			});
		}catch(e){
			showErrorMessage("populateCvSeq", e);
		}
	}	
	
	function printReport(reportId, reportTitle, reportParams){
		try{
			/*if($F("selDestination") == "printer" && ($("selPrinter").value == "" || $("txtNoOfCopies").value == "")){
				showMessageBox("Printer Name and No. of Copies are required.", "I");
			}else if($F("selDestination") == "printer" && (isNaN($F("txtNoOfCopies")) || $F("txtNoOfCopies") <= 0)){
				showMessageBox("Invalid number of copies.", "I");
			}else{*/
				var content = contextPath+"/GeneralDisbursementPrintController?" + reportParams + "&noOfCopies="+$F("txtNoOfCopies")
				  			  +"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination");
				if($F("selDestination") == "screen"){
					showPdfReport(content, reportTitle);
					if (reportId != "GIACR162"){
						afterPrintingGiacs149();
					}else{
						/*commVoucherTG.url = objGIACS149.url;
						commVoucherTG._refreshList();*/
					}
					
				} else if($F("selDestination") == "printer"){
					new Ajax.Request(content, {
						method: "POST",
						evalScripts: true,
						asynchronous: true,
						onCreate: showNotice("Processing, please wait..."),
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								showWaitingMessageBox("Printing complete.", imgMessage.INFO, function(){
									if (reportId != "GIACR162"){
										afterPrintingGiacs149();
									}else{
										/*commVoucherTG.url = objGIACS149.url;
										commVoucherTG._refreshList();*/
									}
								});
							}
						}
					});
				}else if("file" == $F("selDestination")){
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
									//copyFileToLocal(response);
									try {
										var subFolder = "reports";
										if($("geniisysAppletUtil") == null || $("geniisysAppletUtil").copyFileToLocal == undefined){
											showWaitingMessageBox("Local printer applet is not configured properly. Please verify if you have accepted to run the Geniisys Utility Applet and if the java plugin in your browser is enabled.", imgMessage.ERROR, function(){
												afterPrintingGiacs149();
											});
										} else {
											var message = $("geniisysAppletUtil").copyFileToLocal(response.responseText, subFolder);
											if(message.include("SUCCESS")){
												showWaitingMessageBox("Report file generated to " + message.substring(9), imgMessage.INFO, function(){
													if (reportId != "GIACR162"){
														afterPrintingGiacs149();
													}else{
														/*commVoucherTG.url = objGIACS149.url;
														commVoucherTG._refreshList();*/
													}
												});
											} else {
												showWaitingMessageBox(message, imgMessage.ERROR, function(){
													if (reportId != "GIACR162"){
														afterPrintingGiacs149();
													}else{
														/*commVoucherTG.url = objGIACS149.url;
														commVoucherTG._refreshList();*/
													}
												});
											}			
										}
										new Ajax.Request(contextPath + "/GIISController", {
											parameters : {
												action : "deletePrintedReport",
												url : response.responseText
											}
										});
									} catch(e){
										showErrorMessage("copyFileToLocal", e);
									}
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
								if (reportId != "GIACR162"){
									afterPrintingGiacs149();
								}else{
									/*commVoucherTG.url = objGIACS149.url;
									commVoucherTG._refreshList();*/
								}
							}
						}
					});
				}	
			//}
		}catch(e){
			showErrorMessage("printReport", e);
		}
	}
	
	
	$("imgSpinUp").observe("click", function(){
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		if(no < 100){
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
	
	$("selDestination").observe("change", function(){
		var dest = $F("selDestination");
		toggleRequiredFields(dest);
	});	
		
	$("txtNoOfCopies").observe("change", function(){
		if($F("txtNoOfCopies") != ""){
			if(isNaN($F("txtNoOfCopies")) || $F("txtNoOfCopies") <= 0 || $F("txtNoOfCopies") > 100){
				showWaitingMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "I", function(){
					$("txtNoOfCopies").value = $("txtNoOfCopies").readAttribute("lastValidValue");
				});			
			}else{
				$("txtNoOfCopies").setAttribute("lastValidValue", $F("txtNoOfCopies"));
			}
		}
	});
	
	toggleRequiredFields("screen");
	
	$$("input[name='inclItemsRG']").each(function(rb){
		rb.observe("click", function(){
			objGIACS149.reportInclItems = rb.value;
		});
	});

	$("imgFromDate").observe("click", function(){
		scwNextAction = function(){
							checkInputDates("txtFromDate", "txtFromDate", "txtToDate");
						}.runsAfterSCW(this, null);
						
		scwShow($("txtFromDate"),this, null);
	});
	
	$("imgToDate").observe("click", function(){
		scwNextAction = function(){
							checkInputDates("txtToDate", "txtFromDate", "txtToDate");
						}.runsAfterSCW(this, null);
						
		scwShow($("txtToDate"),this, null);
	});
	
	$("btnCancel").observe("click", function(){
		printCommDialog.close();
	});
	
	$("btnPrint").observe("click", function(){
		if(objGIACS149.callingForm == "PRINT_OCV"){
			if (checkAllRequiredFieldsInDiv('printDialogFormDiv')){
				getCVPref();
			}			
		}else if(objGIACS149.callingForm == "PRINT_LIST"){
			/*if ($F("txtFromDate") == "" && $F("txtToDate") == ""){
				showMessageBox("Please enter inclusive dates for printing.", "E");
				return false;
			}*/
			if (checkAllRequiredFieldsInDiv('printListDiv') && checkAllRequiredFieldsInDiv('printDialogFormDiv')){
				objGIACS149.reportFromDate = $F("txtFromDate");
				objGIACS149.reportToDate = $F("txtToDate");
				
				var inclItems = null;
				if($("rbWithOcv").checked){
					inclItems = 'P';
				}else if($("rbWithoutOcv").checked){
					inclItems = 'U';
				}else if($("rbAll").checked){
					inclItems = 'A';
				}
				
				var reportParams = "action=printGIACR162&reportId=GIACR162&intmNo="+objGIACS149.intmNo+"&fromDate="+$F("txtFromDate")+
									"&toDate="+$F("txtToDate")+"&choice="+inclItems;
				
				printReport("GIACR162", "Overriding Commission Summary on Paid Premiums", reportParams);
				printCommDialog.close();
			}			
		}
	});
	
	$("txtFromDate").observe("focus", function(){
		if (objGIACS149.reportToDate != "" && this.value != "") {
			if (compareDatesIgnoreTime(Date.parse($F("txtFromDate")),Date.parse(objGIACS149.reportToDate)) == -1
			   || compareDatesIgnoreTime(Date.parse($F("txtFromDate")),Date.parse(objGIACS149.reportFromDate)) == 1) {
				customShowMessageBox("From Date should be within date parameters entered.","I","txtFromDate");
				this.clear();
			}
		}
	});
	
	$("txtToDate").observe("focus", function(){
		if (objGIACS149.reportFromDate != ""&& this.value != "") {
			if (compareDatesIgnoreTime(Date.parse($F("txtToDate")),Date.parse(objGIACS149.reportToDate)) == -1
			   || compareDatesIgnoreTime(Date.parse($F("txtToDate")),Date.parse(objGIACS149.reportFromDate)) == 1) {
				customShowMessageBox("To Date should be within date parameters entered.","I","txtToDate");
				this.clear();
			}
		}
	});
	
	$("txtFromDate").focus();
 }catch(e){
	 showErrorMessage("Page Error", e);
 }
 </script>
 