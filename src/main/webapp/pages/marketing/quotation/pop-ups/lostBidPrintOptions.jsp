<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="printDiv" name="printDiv" style="margin-top: 5px;"><!-- added width and margin-top Kenneth 05.13.2014 -->
	<form id="lostBidPrintOptionsForm" name="lostBidPrintOptionsForm" style="margin: auto; width: 385px;"> 
		<input type="hidden" id="quoteId" name="quoteId" value="${quoteId}" />
		<input type="hidden" id="isPreview" name="isPreview" value="${preview}" />
		<input type="hidden" id="vLineCd" name="vLineCd" value="${lineCd}" />
		<input type="hidden" id="printerNames" value="${printerNames}">
		<div id="outerDiv" name="outerDiv" style="height: 290px;"><!-- added height Kenneth 05.13.2014 -->
			<div id="innerDiv" name="outerDiv">
				<label>Please fill out all details.</label>
			</div>
			<div>
		</div>
		<div id="policySelectionDiv" style="margin-left: 5px; margin-right: 5px;">
				<table style="margin-top: 10px; width: 100%;">
					<tr>
						<td class="rightAligned" style="width: 10%;">From:</td>
						<td class="leftAligned" style="width: 40%;">
							<span class="required" style="float: left; width: 100%; border: 1px solid gray;">
								<input style="float: left; width: 60%; border: none; background-color: transparent;" id="txtFromDate" name="txtFromDate" type="text" value="" readonly="readonly" tabindex="1"/>
								<img id="imgHrefFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtFromDate'),this, null);" style="margin-left: 20px; margin-top: 2px;" alt="From Date"  />
							</span>
						</td>
						<td class="rightAligned" style="width: 10%;">To:</td>
						<td class="leftAligned" style="width: 40%;">
							<span class="required" style="float: left; width: 100%; border: 1px solid gray;">
								<input style="float: left; width: 60%; border: none; background-color: transparent;" id="txtToDate" name="txtToDate" type="text" value="" readonly="readonly" tabindex="2"/>
								<img id="imgHrefToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtToDate'),this, null);" style="margin-left: 20px; margin-top: 2px;" alt="To Date"  />
							</span>
						</td>
						
					</tr>
					<tr>
						<td class="rightAligned" style="width: 10%;">Line:</td>
						<td class="leftAligned" style="width: 40%;" colspan="3">
							<select id="selLineCd" style="width: 100%;">
								<option value=""></option>
								<c:forEach var="line" items="${lineListing}">
									<option title="${fn:escapeXml(line.lineName)}" value="${line.lineCd}">${fn:escapeXml(line.lineName)}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 10%;">Intermediary:</td>
						<td class="leftAligned" style="width: 40%;" colspan="3">
							<select id="selIntmCd" style="width: 100%;">
								<option value=""></option>
								<c:forEach var="intm" items="${intmListing}">
									<option title="${fn:escapeXml(intm.intmName)}" value="${intm.intmNo}">${fn:escapeXml(intm.intmName)}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 10%;">
							<input type="radio" value="Q" id="rdoQuotation" name="rgReport"/>
						</td>
						<td class="leftAligned" style="width: 40%;"> 
							<label for="rdoQuotation" style="float: none; font-size: 11px;">Converted <br>Quotations to Policy</label><!-- modified label Kenneth 05.13.2014 -->
						</td>
						<td class="rightAligned" style="width: 10%;">
							<input type="radio" value="L" id="rdoLostBid" name="rgReport"/>
						</td>
						<td class="leftAligned" style="width: 40%;"> 
							<label for="rdoLostBid" style="float: none; font-size: 11px;">Lost Bid</label>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 10%;">
							<input type="checkbox" id="chkWithoutAgentIntmBreak" name="chkWithoutAgentIntmBreak"/>
						</td>
						<td class="leftAligned" style="width: 40%;  font-size: 11px;""> 
							Summary
						</td>
						<td class="rightAligned" style="width: 10%;">
						</td>
						<td class="leftAligned" style="width: 40%;"> 
						</td>
					</tr>
				</table>
			</div>
			
			<div id="printSettingsDiv" style="margin-left: 5px; margin-right: 5px;">
				<table style="margin-top: 10px; width: 100%;">
					<tr>
						<td class="rightAligned" style="width: 35%;">Destination</td>
						<td class="leftAligned" style="width: 65%;">
							<select id="reportDestination" name="reportDestination" style="width: 93%;">
								<option value="PRINTER">PRINTER</option>
								<option value="SCREEN">SCREEN</option>
								<option value="LOCAL PRINTER">LOCAL PRINTER</option>
							</select>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 35%;">Printer Name</td>
						<td class="leftAligned" style="width: 65%;">
							<select id="printerName" name="printerName" style="width: 93%;">
								<option value=""></option>
							</select>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 35%;">No. of Copies</td>
						<td class="leftAligned" style="width: 65%;">
							<select id="noOfCopies" name="noOfCopies" style="width: 93%;">
								<option value=""></option>
								<option value="1">1</option>
								<option value="2">2</option>
								<option value="3">3</option>
								<option value="4">4</option>
								<option value="5">5</option>
							</select>
						</td>
					</tr>
				</table>
			</div>
			
			<div align="center" style="margin-top: 10px;">
				<input type="button" class="button" style="width: 60px;" id="btnPrint" name="btnPrint" value="Print" />
				<input type="button" class="button" style="width: 60px;" id="btnCancelPrint" name="btnCancelPrint" value="Cancel" />
				<br/>
				<br/>
			</div>
		</div>
		</form>
</div>

<script>
 	$("rdoLostBid").observe("click", selectLostBid);
 	$("rdoQuotation").observe("click", selectQuotation);
 	$("btnPrint").observe("click", startPrinting);
 	$("btnCancelPrint").observe("click", function(){overlayLostBid.close();}); //changed to overlay Kenneth 05.13.2014
 	$("rdoQuotation").checked = true;
	$("reportDestination").value = "SCREEN";
	
	var reportHeader; //robert - 09.11.2013
 	
 	selectQuotation();
 	insertPrinterNames();
 	checkPrintDestinationFields();

 	$("reportDestination").observe("change", function(){
		checkPrintDestinationFields();
	});

 	function selectLostBid(){
 		$("chkWithoutAgentIntmBreak").checked = false;
 		$("chkWithoutAgentIntmBreak").disable();
 		reportHeader = "Lost Bid"; //robert - 09.11.2013
 	}

 	function selectQuotation(){
 		$("chkWithoutAgentIntmBreak").enable();
 	 	$("chkWithoutAgentIntmBreak").checked = true;
 	 	reportHeader = "Converted Quotations to Policy"; //robert - 09.11.2013
 	}

 	function startPrinting(){
 	 	var reportId = "";
 		if (("" == $F("txtFromDate")) || ("" == $F("txtToDate"))){
			showWaitingMessageBox("Date must be entered.", imgMessage.INFO, function(){
					$("txtFromDate").focus();
				});
			return false;
 		}
 		if (!validateBeforePrint()){
			return false;
 		}
  		reportId = getReportId();
  		//added by: Nica 06.08.2012
  		var fromDate = $("txtFromDate").value;
  		var toDate = $("txtToDate").value;
  		var lineCd = $("selLineCd").value;
  		var intmNo = $("selIntmCd").value;
  		var content = contextPath+"/MarketingPrintController?action=printMarketingReport&reportId="+reportId+"&"+Form.serialize("lostBidPrintOptionsForm")+
  				     "&fromDate="+fromDate+"&toDate="+toDate+"&lineCd="+lineCd+"&intmNo="+intmNo; // added by: Nica 06.08.2012
		if ($("reportDestination").value == "SCREEN"){
			//window.open(content+"&="+Math.random(), reportId, "location=no,toolbar=no,menubar=no");
			//showPdfReport(content+"&="+Math.random(), "Lost Bid"); // andrew - 12.12.2011
			showPdfReport(content+"&="+Math.random(), reportHeader); //robert - 09.11.2013
		} else if($("reportDestination").value == "PRINTER") { //modified by robert
			new Ajax.Request(content, {
				method: "GET",
				evalScripts: true,
				asynchronous: true,
				onCreate : function(){
					showNotice("Printing marketing report...");
				},
				onComplete: function(response){
					hideNotice("");
					if (checkErrorOnResponse(response)){
						showMessageBox("Report printed successfully.", imgMessage.SUCCESS);
					}
				}
			});
		}else if($F("reportDestination") == "LOCAL PRINTER"){ //added by robert
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
		//Modalbox.hide();
 	}

 	function getReportId(){
 	 	var result = "";
 		if ($("rdoQuotation").checked == true
  		  		&& $("chkWithoutAgentIntmBreak").checked == false){
 			result = "GIPIR909";
  		} else if ($("rdoQuotation").checked == true
  		  		&& $("chkWithoutAgentIntmBreak").checked == true){
  			result = "GIPIR909A";
  		} else {
  			result = "GIPIR910";
  		}
  		return result;
 	}

 	function validateBeforePrint(){
 		var result = true;
 		if (($("printerName").selectedIndex == 0) && ($("reportDestination").value == "PRINTER")){
 			result = false;
 			showWaitingMessageBox("Printer Name is required.", imgMessage.ERROR, function(){
 					$("printerName").focus();
	 			});
 		} else if (($("noOfCopies").selectedIndex == 0) && ($("reportDestination").value == "PRINTER")){
 			result = false;
 			showWaitingMessageBox("No. of Copies is required.", imgMessage.ERROR, function(){
 					$("noOfCopies").focus();
	 			});
 		}
 		return result;
 	}
 	
 	$("txtFromDate").observe("blur",function(){ //added by steven 9/19/2012
 		var fromDate = Date.parse(this.value); 
 		var toDate = Date.parse($("txtToDate").value);
 		if (fromDate != null && toDate != null && compareDatesIgnoreTime(fromDate,toDate) == -1){
 			showMessageBox("From_date must be earlier than to_date.",imgMessage.INFO);
			this.clear();
 		}
 	});
 	
 	$("txtToDate").observe("blur",function(){ //added by steven 9/19/2012
 		var fromDate = Date.parse($F("txtFromDate"));
 		var toDate = Date.parse(this.value);
 		if (fromDate != null && toDate != null && compareDatesIgnoreTime(toDate,fromDate) == 1){
 			showMessageBox("To_date must be later than from_date.",imgMessage.INFO);
			this.clear();
 		}
 	});
</script>