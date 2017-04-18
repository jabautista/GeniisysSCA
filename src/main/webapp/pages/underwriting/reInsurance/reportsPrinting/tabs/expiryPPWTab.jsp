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
	<div id="fieldsDiv" name="fieldsDiv" class="sectionDiv" style="float: left; margin: 0 0 0 15px; width: 890px; height: 230px;">
		<table id="fieldsTbl" name="fieldsTbl" style="margin: 40px 0 0 220px; width: 403px;">
			<tr>
				<td class="rightAligned" style="padding-right: 10px;">As Of</td>
				<td>
					<div id="asOfDateDiv" name="asOfDateDiv" style="float: left; border: 1px solid gray; width: 353px; height: 20px; ">
						<input id="txtAsOfDate" name="txtAsOfDate" readonly="readonly" type="text" class="leftAligned" maxlength="10" style="border: none; float: left; width: 328px; height: 13px; margin: 0px;" value=""/>
						<img id="imgAsOfDate" alt="imgAsOfDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtAsOfDate'),this, null);" />
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 10px;">Line</td>
				<td>
					<input id="txtLineCd" name="txtLineCd" type="hidden">
					<div id="lineExpDiv" style="border: 1px solid gray; width: 353px; height: 20px; ">
						<input id="txtLineName" name="txtLineName" type="text" maxlength="30" class="upper" style="border: none; float: left; width: 303px; height: 13px; margin: 0px;" value="">
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineName" name="searchLineName" alt="Go" style="float: right;"/>
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 10px;">Reinsurer</td>
				<td>
					<input id="txtRiCd" name="txtRiCd" type="hidden">
					<div id="riExpDiv" style="border: 1px solid gray; width: 353px; height: 20px; ">
						<input id="txtRiName" name="txtRiName" type="text" maxlength="30" class="upper" style="border: none; float: left; width: 303px; height: 13px; margin: 0px;" value="">
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchRiName" name="searchRiName" alt="Go" style="float: right;"/>
					</div>
				</td>
			</tr>
		</table>
		<table style="margin: 20px 0 0 220px; width: 403px;">			
			<tr>
				<td> Report Date Parameter </td>
				<td><input id="inceptRB" name="repDateRG" type="radio" value="INCEPT_DATE" checked="checked" style="float: left; margin: 10px 0 7px 0;"><label for="inceptRB" style="margin: 10px 0 4px 12px;">Based on Incept Date</label> </td>
			</tr>
			<tr>
				<td></td>
				<td><input id="bookingRB" name="repDateRG" type="radio" value="BOOKING_MONTH" style="float: left; margin: 0 0 7px 0;"><label for="bookingRB" style="margin: 2px 0 4px 12px;">Based on Booking Month</label> </td>
			</tr>
		</table>
	</div>
		
	<div class="sectionDiv" id="printDialogFormDiv" style="margin-left: 15px; margin-bottom: 5px; float: left; width: 890px; height: 200px;" >
		<table style="float: left; padding: 35px 0 0 220px;">
			<tr>
				<td class="rightAligned">Destination</td>
				<td class="leftAligned">
					<select id="selDestination" style="width: 170px;">
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
					<input value="EXCEL" title="Excel" type="radio" id="excelRB" name="fileRG" style="margin: 2px 4px 4px 40px; float: left;" disabled="disabled"><label for="excelRB" style="margin: 2px 0 4px 0">Excel</label>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Printer</td>
				<td class="leftAligned">
					<select id="selPrinter" style="width: 170px;" class="required">
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
					<input type="text" id="txtNoOfCopies" style="float: left; text-align: right; width: 145px;" class="required integerNoNegativeUnformattedNoComma">
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
try{
	initializeAll();
	makeInputFieldUpperCase();
	$("txtAsOfDate").value = dateFormat(new Date(), "mm-dd-yyyy");
	var repDate = "INCEPT_DATE";
	
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
	
	function validateLinePPW(){
		try{
			new Ajax.Request(contextPath+"/GIRIGenerateRIReportsController", {
				method: "GET",
				parameters: {
					action: 	"validateGIRIS051LinePPW",
					lineName:	$F("txtLineName")
				},
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if (checkErrorOnResponse(response)){	
						if (response.responseText == null || response.responseText == ""){
							showMessageBox("Invalid value for field LINE NAME.", "E"); 
							$("txtLineName").value = "ALL LINES";
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("validateLinePPW", e);
		}
	}
	
	
	toggleRequiredFields("screen");
	
	
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
	

	$("txtAsOfDate").observe("blur", function(){
		if ($F("txtAsOfDate") == ""){
			$("txtAsOfDate").value = dateFormat(new Date(), "mm-dd-yyyy");
		}
	});
	
	$("txtRiName").observe("blur", function(){
		if($F("txtRiName") != ""){
			validateRIReportsReinsurerName("txtRiName", "txtRiCd", "Invalid value for field REINSURER.");
		}else{
			$("txtRiCd").value = "";
			$("txtRiName").value = "ALL REINSURERS";
		}
	});
	
	$("txtLineName").observe("blur", function(){
		if($F("txtLineName") != ""){
			validateLinePPW();
		}else{
			$("txtLineCd").value = "";
			$("txtLineName").value = "ALL LINES";
		}
	});
	
	//search buttons
	$("searchRiName").observe("click", function(){
		showRiReportsReinsurerLOV("txtRiName", "txtRiCd");
	});
	
	$("searchLineName").observe("click", function(){
		showGIRIS051LinePPWLOV("txtLineCd", "txtLineName");
	});
	
	$$("input[name='repDateRG']").each(function(rb){
		rb.observe("click", function(){
			repDate = rb.value;
		});
	});
	
	$("btnCancel").observe("click", function(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	
	$("btnPrint").observe("click", function(){
		if($F("txtLineName") == "ALL LINES"){
			$("txtLineName").value = "";
		}
		
		if ($F("txtRiName") == "ALL REINSURERS"){
			$("txtRiName").value = "";
		}
		
		
		var content = contextPath+"/UWReinsuranceReportPrintController?action=printUWRiExpPPWReport&reportId=GIRIR122&riName="+$F("txtRiName")+
					  "&lineName="+$F("txtLineName")+"&asOfDate="+$F("txtAsOfDate")+"&repDate="+repDate+"&noOfCopies="+$F("txtNoOfCopies")+
					  "&printerName="+$F("selPrinter")+"&destination="+$F("selDestination");
		
		if($F("selDestination") == "SCREEN"){
			showPdfReport(content, "List of Inward Policies with Expired PPW");
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
	});

	
} catch(e){
	showErrorMessage("Page Error: ", e);
}	
</script>