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

<div id="reciprocityTabMainDiv" style="float: left; padding: 15px 0 5px 0;">
	<div id="fieldsDiv" name="fieldsDiv" class="sectionDiv" style="margin-left: 15px; padding-top: 5px; width: 607px; height: 205px;" align="center">
		<table id="fieldsTbl" name="fieldsTbl" style="margin: 55px 0 0 80px;">
			<tr>
				<td style="text-align: right; padding-right: 10px;">Reinsurer</td>
				<td colspan="3">
					<input id="txtRiCdRecip" name="txtRiCdRecip" type="hidden">
					<div id="riSnameDiv" style="border: 1px solid gray; width: 370px; height: 20px; ">
						<input id="txtRiSnameRecip" name="txtRiSnameRecip" type="text" maxlength="30" class="upper" style="border: none; float: left; width: 340px; height: 13px; margin: 0px;" value="">
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchRiSnameRecip" name="searchRiSnameRecip" alt="Go" style="float: right;"/>
					</div>
				</td>
			</tr>
			<tr>
				<td style="text-align: right; padding-right: 10px;">From</td>
				<td style="padding-right: 73px;">
					<div id="fromDateDiv" style="float: left; border: 1px solid gray; width: 150px; height: 20px;">
						<input id="txtFromDate" name="txtFromDate" readonly="readonly" type="text" class="rightAligned" maxlength="10" style="border: none; float: left; width: 125px; height: 13px; margin: 0px;" value="" />
						<img id="imgFromDate" alt="imgFromDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtFromDate'),this, null);" />
					</div>
				</td>
				<td style="padding-right: 10px;">To</td>
				<td style="padding-right: 80px;">
					<div id="toDateDiv" style="float: left; border: 1px solid gray; width: 115px; height: 20px;">
						<input id="txtToDate" name="txtToDate" readonly="readonly" type="text" class="rightAligned" maxlength="10" style="border: none; float: left; width: 90px; height: 13px; margin: 0px;" value="" />
						<img id="imgToDate" alt="imgToDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtToDate'),this, null);" />
					</div>
				</td>
			</tr>
		</table>
		
		<input id="btnExtract" name="btnExtract" type="button" class="button" value="Extract" style="width: 100px; margin: 25px 0 0 20px;">
	</div>
	
	<div id="inwardRiDiv" name="inwardRiDiv" class="sectionDiv" style="float: right; padding-top: 5px; margin-right: 14px; width: 280px; height: 216px;">
		<table id="inwardRiTbl" style="margin: 15px 0 0 30px;">
			<tr>
				<td style="padding: 0 0 15px 32px;">Inward RI</td>
			</tr>
			<tr>
				<td><input id="effectivityDtInRB" name="inwardDateRG" type="radio" checked="checked" value="EFFECTIVITYDATE" style="float: left; margin: 0 0 10px 45px;"><label for="effectivityDtInRB" style="margin: 2px 0 4px 12px;">Effectivity Date</label></td>
			</tr>
			<tr>
				<td><input id="issueDtInRB" name="inwardDateRG" type="radio" value="ISSUEDATE" style="float: left; margin: 0 0 10px 45px;"><label for="issueDtInRB" style="margin: 2px 0 4px 12px;">Issue Date</label></td>
			</tr>
			<tr>
				<td><input id="acceptDtInRB" name="inwardDateRG" type="radio" value="ACCEPTDATE" style="float: left; margin: 0 0 10px 45px;"><label for="acceptDtInRB" style="margin: 2px 0 4px 12px;">Accept Date</label></td>
			</tr>
			<tr>
				<td><input id="acctEntDtInRB" name="inwardDateRG" type="radio" value="ACCTENTDATE" style="float: left; margin: 0 0 10px 45px;"><label for="acctEntDtInRB" style="margin: 2px 0 4px 12px;">Accounting Entry Date</label></td>
			</tr>
			<tr>
				<td><input id="bookingDtInRB" name="inwardDateRG" type="radio" value="BOOKINGDATE" style="float: left; margin: 0 0 10px 45px;"><label for="bookingDtInRB" style="margin: 2px 0 4px 12px;">Booking Date</label></td>
			</tr>
		</table>
	</div>	
	
	<div class="sectionDiv" id="printDialogFormDiv" style="margin-left: 15px; margin-bottom: 5px; float: left; width: 607px; height: 226px;" >
		<table style="float: left; padding: 35px 0 0 100px;">
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
		<table style="float: left; padding: 50px 0 0 30px;">
			<tr><td><input type="button" class="button" style="width: 100px; margin-left: 15px; " id="btnPrint" name="btnPrint" value="Print"></td></tr>
			<tr><td><input type="button" class="button" style="width: 100px; margin-left: 15px; " id="btnCancel" name="btnCancel" value="Cancel"></td></tr>
		</table>
	</div>
	
	<div id="outwardRiDiv" name="outwardRiTab" class="sectionDiv" style="float: right; margin: 0 14px 5px 0; width: 280px; height: 215px;">
		<table id="outwardRiTbl" style="margin: 35px 0 0 30px;">
			<tr>
				<td style="padding: 0 0 15px 32px;">Outward RI</td>
			</tr>
			<tr>
				<td><input id="inceptionDtOutRB" name="outwardDateRG" type="radio" checked="checked" value="INCEPTIONDATE" style="float: left; margin: 0 0 10px 45px;"><label for="inceptionDtOutRB" style="margin: 2px 0 4px 12px;">Inception Date</label></td>
			</tr>
			<tr>
				<td><input id="binderDtOutRB" name="outwardDateRG" type="radio" value="BINDERDATE" style="float: left; margin: 0 0 10px 45px;"><label for="binderDtOutRB" style="margin: 2px 0 4px 12px;">Binder Date</label></td>
			</tr>
			<tr>
				<td><input id="acctEntDtOutRB" name="outwardDateRG" type="radio" value="ACCTENTDATE" style="float: left; margin: 0 0 10px 45px;"><label for="acctEntDtOutRB" style="margin: 2px 0 4px 12px;">Accounting Entry Date</label></td>
			</tr>
		</table>
	</div>
	
	<div id="hiddenFieldsDiv">
		<input id="chkLocalCurrency" name="chkLocalCurrency" type="checkbox" value="" checked="checked" style="margin-right: 8px;">Local Currency
		<input id="facultativeRB" name="reciprocityRG" type="radio" value="FACULTATIVE" checked="checked" style="float: left; margin: 0 0 10px 45px;"><label for="facultativeRB" style="margin: 2px 0 4px 12px;">Facultative</label>
		<input id="treatyRB" name="reciprocityRG" type="radio" value="TREATY" style="float: left; margin: 0 0 10px 45px;"><label for="treatyRB" style="margin: 2px 0 4px 12px;">Treaty</label>		
	</div>
</div>

<script type="text/javascript">
	initializeAll();
	toggleRequiredFields("screen");
	makeInputFieldUpperCase();
	observeReloadForm("reloadForm", function(){showGenerateRIReportsTabPage("reciprocityTab");});
	
	$("hiddenFieldsDiv").hide();
	getReciprocityInitialValues();
	
	var inwardParam = "";
	var outwardParam = "";
	
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
	
	$("txtRiSnameRecip").observe("blur", function(){
		if ($F("txtRiSnameRecip") != ""){
			validateRiSname();
		}else{
			$("txtRiCdRecip").value = "";
		}
	});
	
	$("searchRiSnameRecip").observe("click", function(){
		showRiReportsRecipRiSnameLOV("txtRiSnameRecip", "txtRiCdRecip");
	});
	
	$("txtFromDate").observe("blur", function(){
		if ($F("txtFromDate") != "" && $F("txtToDate") == ""){
			var toDate = Date.parse($F("txtFromDate")).moveToLastDayOfMonth();
			$("txtToDate").value = dateFormat(toDate, 'mm-dd-yyyy');
		}
	});
	
	$("btnExtract").observe("click", function(){
		if ($F("txtRiSnameRecip") == ""){
			$("txtRiCdRecip").value = "";
		}
		if($F("txtFromDate") == "" || $F("txtToDate") == ""){
			showMessageBox("Please enter date parameters.", "E");
		}else if(Date.parse($F("txtFromDate")) > Date.parse($F("txtToDate"))){
			showMessageBox("Please check the dates.", "E");
		}else{
			getInwardOutwardValues();
			getReciprocityRiCd();
		}
	});
	
	$("btnPrint").observe("click", function(){
		if($F("txtRiSnameRecip") == ""){
			$("txtRiCdRecip").value = "";
		}
		
		getExtractedReciprocity();
	});
	
	$("btnCancel").observe("click", function(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	
	
	function validateRiSname(){
		try{
			new Ajax.Request(contextPath+"/GIRIGenerateRIReportsController",{
				method: "GET",
				parameters: {
					action: 	"validateRIReportsRiSname",
					riSname:	$F("txtRiSnameRecip")
				},
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					var obj = JSON.parse(response.responseText);
					if(obj.riCd == null){
						clearFocusElementOnError("txtRiSnameRecip", "Invalid value for field REINSURER");
					}else{
						$("txtRiCdRecip").value = obj.riCd;
					}
				}
			});
		}catch(e){
			showErrorMessage("validateRiSname", e);
		}
	}

	function getReciprocityInitialValues(){
		try{
			new Ajax.Request(contextPath+"/GIRIGenerateRIReportsController?action=getReciprocityInitialValues",{
				method: "GET",
				asynchronous: true,
				evalScripts: true,
				onComplete: function(response){
					var obj = JSON.parse(response.responseText);
					$("txtRiSnameRecip").value = obj.riSname;
					$("txtRiCdRecip").value = obj.riCd;
					$("txtFromDate").value = obj.fromDate == null ? "" : dateFormat(obj.fromDate, 'mm-dd-yyyy');
					$("txtToDate").value = obj.toDate == null ? "" : dateFormat(obj.toDate, 'mm-dd-yyyy');
					inwardParam = obj.inwardParam;
					outwardParam = obj.outwardParam;
					
					/*$$("input[name='inwardDateRG']").each(function(radio){
						if(radio.value == obj.inwardParam){
							radio.checked = true;
						}
					});
					$$("input[name='outwardDateRG']").each(function(radio){
						if(radio.value == obj.outwardParam){
							radio.checked = true;
						}
					});*/					
				}
			});
		}catch(e){
			showErrorMessage("getReciprocityInitialValues", e);
		}
	}
	
	function getInwardOutwardValues(){
		$$("input[name='inwardDateRG']").each(function(row){
			if(row.checked){
				inwardParam = row.value;
			}
		});
		
		$$("input[name='outwardDateRG']").each(function(row){
			if(row.checked){
				outwardParam = row.value;
			}
		});
	}
	
	function getReciprocityRiCd(){
		try{
			new Ajax.Request(contextPath+"/GIRIGenerateRIReportsController",{
				method: "GET",
				parameters:{
					action:		  	"getReciprocityRiCd",
					fromDate:	  	$F("txtFromDate"),
					toDate:		  	$F("txtToDate"),
					inwardParam:  	inwardParam,
					outwardParam: 	outwardParam
				},
				asynchronous: true,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						if ((response.responseText != "" && response.responseText == $F("txtRiCdRecip")) || 
								(response.responseText == "0" && $F("txtRiCdRecip") == "") /*0 return for too_many_rows or no_data_found*/ ){
							showConfirmBox("", "Records have been extracted using the given parameters. Do you wish to continue?", "OK", "Cancel",
											function(){
												if($("facultativeRB").checked){
													extractOne();	
												}											
											},
											function(){}
							);
						}else if(response.responseText == ""){
							extractOne();
						}
					}					
				}
			});
		}catch(e){
			showErrorMessage("getReciprocityRiCd", e);
		}
	}
	
	function extractOne(){
		try{
			new Ajax.Request(contextPath+"/GIRIGenerateRIReportsController",{
				method: "GET",
				parameters: {
					action:			"extractReciprocity",
					riCd:			$F("txtRiCdRecip"),
					fromDate:		$F("txtFromDate"),
					toDate:			$F("txtToDate"),
					inwardParam:	inwardParam,
					outwardParam:	outwardParam
				},
				asynchronous: true,
				evalScripts: true,
				onComplete: function(response){
					hideNotice();
					var obj = JSON.parse(response.responseText);
					if(obj.count1 == 0){
						if(obj.count2 == 0){
							showMessageBox("There were no CEDED or ASSUMED business.", "I");
						}else{
							updateFacAmts();
						}
					}else{
						updateFacAmts();
					}
				}
			});
		}catch(e){
			showErrorMessage("extractOne", e);
		}
	}
	
	function updateFacAmts(){
		try{
			if($("facultativeRB").checked){
				new Ajax.Request(contextPath+"/GIRIGenerateRIReportsController",{
					method: "GET",
					parameters: {
						action:			"updateFacAmts",
						riCd:			$F("txtRiCdRecip"),
						fromDate:		$F("txtFromDate"),
						toDate:			$F("txtToDate"),
						inwardParam:	inwardParam,
						outwardParam:	outwardParam,
						localCurr:		$("chkLocalCurrency").checked ? "LOCAL CURRENCY" : "FOREIGN CURRENCY"
					},
					asynchronous: true,
					evalScripts: true,
					onCreate: showNotice("Working, Please Wait..."),
					onComplete: function(response){
						hideNotice();
						showMessageBox(response.responseText, "I");
					}
				});
			}
		}catch(e){
			showErrorMessage("updateFacAmts", e);
		}
	}
	
	function getExtractedReciprocity(){
		try{
			new Ajax.Request(contextPath+"/GIRIGenerateRIReportsController",{
				method: "GET",
				parameters:{
					action:		  	"getExtractedReciprocity",
					fromDate:	  	$F("txtFromDate"),
					toDate:		  	$F("txtToDate"),
					inwardParam:  	inwardParam,
					outwardParam: 	outwardParam
				},
				asynchronous: true,
				evalScripts: true,
				onComplete: function(response){
					if (response.responseText == "" || response.responseText == "0" /*0 return for too_many_rows or no_data_found*/){
						showMessageBox("No records extracted.", "E");
					}else{
						if($("facultativeRB").checked){
							printRIReciprocityReport();
						}
					}	
				}
			});
		}catch(e){
			showErrorMessage("getExtractedReciprocity", e);
		}
	}
	
	function printRIReciprocityReport(){
		if ($F("selDestination") == "PRINTER" && ($("selPrinter").value == "" || $("txtNoOfCopies").value == "")){
			showMessageBox("Printer and No. of Copies are required.", "I");
		}else if($F("selDestination") == "PRINTER" && (isNaN($F("txtNoOfCopies")) || $F("txtNoOfCopies") <= 0)){
			showMessageBox("Invalid number of copies.", "I");
		}else{
			var reportId = "GIRIR029";

			var content = contextPath+"/UWReinsuranceReportPrintController?action=printUWRiReciprocityReport&reportId="+reportId+
						  "&riCd="+$F("txtRiCdRecip")+"&noOfCopies="+$F("txtNoOfCopies")+"&printerName="+$F("selPrinter")+
						  "&destination="+$F("selDestination");
			
			if($F("selDestination") == "SCREEN"){
				showPdfReport(content, "Reciprocity Report (Facultative)");
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
			
		}
	}
</script>