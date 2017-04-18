<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
	response.setHeader("Content-Language", "es");
%>

<div id="printDiv" name="printDiv" style="">
	<form id="printOptionsForm" name="printOptionsForm" style="margin: auto;">
		<input type="hidden" id="quoteId" name="quoteId" value="${quoteId}" />
		<input type="hidden" id="isPreview" name="isPreview" value="${preview}" />
		<input type="hidden" id="vLineCd" name="vLineCd" value="${lineCd}" />
		<input type="hidden" id="printerNames" value="${printerNames}">
		<div id="outerDiv" name="outerDiv" style="">
			<div id="innerDiv" name="outerDiv">
				<label>Please fill out all details.</label>
			</div>
			<div>
		</div>
		<div>
				<table style="margin-top: 10px; width: 100%;">
					<tr>
						<td class="rightAligned" style="width: 35%;">Destination</td>
						<td class="leftAligned" style="width: 65%;">
							<select id="reportDestination" name="reportDestination" style="width: 93%;" class="required">
								<option value="PRINTER">PRINTER</option>
								<option value="SCREEN">SCREEN</option>
								<option value="LOCAL PRINTER">LOCAL PRINTER</option>
							</select>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 35%;">No. of Copies</td>
						<td class="leftAligned" style="width: 65%;">
							<select id="noOfCopies" name="noOfCopies" style="width: 93%;" class="required">
								<option value=""></option>
								<option value="1">1</option>
								<option value="2">2</option>
								<option value="3">3</option>
								<option value="4">4</option>
								<option value="5">5</option>
							</select>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 35%;">Printer Name</td>
						<td class="leftAligned" style="width: 65%;">
							<select id="printerName" name="printerName" style="width: 93%;" class="required">
								<option value=""></option>
							</select>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 35%;">Attention To</td>
						<td class="leftAligned" style="width: 65%;">
							<input type="text" id="attentionTo" name="attentionTo" onKeyDown="limitText(this,50);" onKeyUp="limitText(this,50);" style="width: 90%;" class="required"/> 
						</td> <!-- added txtlimit - christian 09.14.2012  -->
					</tr>
					<tr>
						<td class="rightAligned" style="width: 35%;">Attention Position</td>
						<td class="leftAligned" style="width: 65%;">
							<input type="text" id="attentionPosition" name="attentionPosition" style="width: 90%;" class="required"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 35%;">Closing Words</td>
						<td class="leftAligned" style="width: 65%;">
							<input type="text" id="closingWords" name="closingWords" style="width: 90%;" class="required"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 35%;">Signatory</td>
						<td class="leftAligned" style="width: 65%;">
							<input type="text" id="signatory" name="signatory" style="width: 90%;" class="required"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 35%;">Designation</td>
						<td class="leftAligned" style="width: 65%;">
							<input type="text" id="designation" name="designation" style="width: 90%;" class="required"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 35%;">Contact Nos.</td>
						<td class="leftAligned" style="width: 65%;">
							<input type="text" id="contactNo" name="contactNo" style="width: 90%;" class="required"/>
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
	addStyleToInputs();
	initializeAll();
	insertPrinterNames();
	var isPack = '${isPack}';

	function getReportId(lineCd, menuLineCd){		
		if(lineCd == "SU" || menuLineCd == "SU"){
			return "SU_QUOTE";
		} else if(lineCd == "MC" || menuLineCd == "MC"){
			return "MC_QUOTE";
		} else if (lineCd == "FI" || menuLineCd == "FI"){
			return "FI_QUOTE";
		} else if (lineCd == "AV" || menuLineCd == "AV"){
			return "AV_QUOTE";
		} else if (lineCd == "AC" || lineCd == "PA" || menuLineCd == "AC" || menuLineCd == "PA"){
			return "AC_QUOTE";
		} else if (lineCd == "MN" || menuLineCd == "MN"){
			return "MN_QUOTE";
		} else if (lineCd == "MH" || menuLineCd == "MH"){
			return "MH_QUOTE";
		} else if (lineCd == "EN" || menuLineCd == "EN"){
			return "EN_QUOTE";
		} else if (lineCd == "PK" || menuLineCd == "PK"){
			return "PK_QUOTE";
		} else if (lineCd == "CA" || menuLineCd == "CA"){
			return "CA_QUOTE";
		}
	}
	
	$("btnPrint").observe("click", function () {
		//if ($("reportDestination").value != "SCREEN" 
		if ($("reportDestination").value == "PRINTER" 
			&& "" == $("noOfCopies").value){
			showMessageBox("Please specify number of copies.", imgMessage.ERROR);
			return false;
		//} else if ($("reportDestination").value != "SCREEN" 
		}else if ($("reportDestination").value == "PRINTER" 
			&& "" == $("printerName").value){
			showMessageBox("Please select a printer.", imgMessage.ERROR);
			return false;
		}
		if ($("printOptionsForm").getInputs("text").any(function (input) {return input.value == "";})) {
			new Effect.Highlight("outerDiv", {duration: .5, startcolor: "#FF0000"});
		} else {
			var content = contextPath+"/MarketingPrintController?action=print&reportId="+getReportId($("vLineCd").value, objGIPIQuote.menuLineCd)+"&"+Form.serialize("printOptionsForm");
			if ($("reportDestination").value == "SCREEN"){
				//window.open(content+"&="+Math.random(), "haha", "location=no,toolbar=no,menubar=no");
				showPdfReport(content+"&="+Math.random(), ""); // andrew - 12.12.2011
			//} else {
			}else if ($("reportDestination").value == "PRINTER"){
				new Ajax.Request(content, {
					method: "GET",
					evalScripts: true,
					asynchronous: true,
					onCreate : function(){
						showNotice("Printing quotation...");
					},
					onComplete: function(response){
						hideNotice("");
						if (checkErrorOnResponse(response)){
							showMessageBox("Quotation printed successfully.", imgMessage.SUCCESS);
						}
					}
				});
			}else if("LOCAL PRINTER" == $F("reportDestination")){
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
			Modalbox.hide();
		}
	});
	
	$("btnCancelPrint").observe("click", function(){
		Modalbox.hide();
	});

	$("reportDestination").observe("change", function(){
		checkPrintDestinationFields();
	});
	//$("vLineCd").value = $F("lineCd");
	
	if(isPack == "Y"){
		$("vLineCd").value = "PK";
	}else{
		$("vLineCd").value = nvl(objGIPIQuote.menuLineCd, objGIPIQuote.lineCd);
	}
	$("reportDestination").value = "SCREEN"; // added by: Nica 06.28.2012 - to set default destination to screen
	checkPrintDestinationFields();
</script>