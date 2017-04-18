<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<!--<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>
<br/>
--><div id="hiddenDiv">
	<input type="hidden" id="printerNames" value="${printerNames}">
	<input type="hidden" id="reportType" value="${reportType}">
	<input type="hidden" id="extractId" value="0">
	<input type="hidden" id="policyId" value="${policyId}">
	<input type="hidden" id="bondParType" value="" />
	<input type="hidden" id="printPremiumHid" value="" />
</div>
<div id="reportGeneratorMainDiv" class="sectionDiv" style="text-align: center;">
	<table style="margin-top: 10px; width: 100%;">
		<tr>
			<td class="rightAligned" style="width: 35%;">Destination</td>
			<td class="leftAligned" style="width: 65%;">
				<select id="reportDestination" style="width: 60%;">
					<option value="SCREEN">Screen</option>
					<option value="PRINTER">Printer</option>
					<option value="file">File</option>
					<option value="local">Local Printer</option>
				</select>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 35%;">No. of Copies</td>
			<td class="leftAligned" style="width: 65%;">
				<select id="noOfCopies" style="width: 60%;">
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
				<select id="printerName" style="width: 60%;">
					<option value=""></option>
				</select>
			</td>
		</tr>
		<c:if test="${printWarcla eq 'Y'}">
			<tr>
				<td colspan="2" style="width: 100%; padding-bottom: 5px; padding-left: 40px;">				
					<input id="printWarcla" name="printWarcla" type="checkbox" style="float: left; margin: 0 3px 0 5px;" checked="checked">
					<label for="printWarcla">Print Warranties and Clauses Attachment?</label>
				</td>		
			</tr><!-- Dren 02.09.2016 SR-5266 -->
		</c:if>
		<c:if test="${reportType eq 'coverNote'}">
			<tr>
				<td class="rightAligned" style="width: 35%">Number Of Days</td>
				<td class="leftAligned" style="65%">
					<input type="text" id="noOfDays" name="noOfDays" value="" maxlength="2" style="width: 57%" class="integerUnformatted"/>
					<input type="hidden" id="cnDatePrinted" value="${cnDatePrinted}">
					<input type="hidden" id="coverNoteExpiry" value="${coverNoteExpiry}">
					<input type="hidden" id="cnNoOfDays" value="${cnNoOfDays}">
				</td>
			</tr>
		</c:if>
		<c:if test="${printPremDetails eq 'Y'}">
			<td colspan="2" style="padding-left: 30%; padding-bottom: 5px;">
				<label for="printPremDetails">Print Premium Details?</label>
				<input id="printPremDetails" name="printPremDetails" type="checkbox" style="float: left; margin: 0 3px 0 5px;" checked="checked">
			</td>
		</c:if>
	</table>
</div>
<div id="buttonsDiv" style="text-align: center;">
	<input type="button" class="button" id="btnPrint" value="Print" style=""/>
	<input type="button" class="button" id="btnReturn" value="Return"  style=""/>
</div>

<script>

initializeAll();
insertPrinterNames();
$("reportDestination").value = "SCREEN";
//$("printerName").disable();
//$("noOfCopies").disable();

$("reportDestination").observe("change", function(){
	checkPrintDestinationFields();
});

$("btnPrint").observe("click", function(){
	printPolicyDoc();
});

$("btnReturn").observe("click", /*hideOverlay*/function(){Modalbox.hide();});

function printPolicyDoc(){
	try {
		if (validateBeforePrint()){
			var reportType = $F("reportType");
			if ("policy" == reportType){
				new Ajax.Request(contextPath+"/GIPIPolbasicController?action=getExtractId", {
					method: "GET",
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						if(checkErrorOnResponse(response)) {
							$("extractId").value = response.responseText;
							if(nvl('${printPremDetails}', "N") == "Y"){ //marco - 11.20.2012
								$("printPremiumHid").value = $("printPremDetails").checked ? "Y" : "N";	
							}
							if(nvl('${printWarcla}', "N") == "Y"){
								$("printWarcla").value = $("printWarcla").checked ? "Y" : "N";	
							}//Dren 02.09.2016 SR-5266						
							var reportId = getPolicyDocReportId();	
							//populateGixxTables("MOTORCAR", $("reportDestination").value, $("printerName").value, $("noOfCopies").value);
							if (reportId == 'PACKAGE'){
								printPackPolDoc(reportId);
							}else{
								new Ajax.Request(contextPath+"/GIPIPolbasicController?action=populateGixxTableWPolDoc", {
									method: "GET",
									evalScripts: true,
									asynchronous: true,
									parameters: {
										globalParId: $("globalParId").value,
										extractId: $("extractId").value
									},
									onCreate: showNotice("Generating report, please wait..."),
									onComplete: function(response){
										if(checkErrorOnResponse(response)) {
											//var reportId = getPolicyDocReportId(); moved by Nica 04.20.2011
											printCurrentReport(reportId, $("reportDestination").value, $("printerName").value, $("noOfCopies").value, 0, $("globalLineCd").value, objUWParList.sublineCd);
											if ($("printWarcla").value == "Y"){
												printCurrentReport("GIPIR153", $("reportDestination").value, $("printerName").value, $("noOfCopies").value, 0, $("globalLineCd").value, objUWParList.sublineCd);
											} //Dren 02.09.2016 SR-5266											
											Modalbox.hide(); 
											//hideNotice("REPORT SENT TO "+destination+".");
										}
									}								
								});
							}
						}
					}
				});				
			}else if(reportType == "coverNote"){
				if($F("noOfDays").blank()){
					showConfirmBox("Confirmation", "Number of Days is null. Do you want to continue?", "Ok", "Cancel",
							       function(){
										checkIfCoverNotePrinted();
					               }, "");
				}else{
					checkIfCoverNotePrinted();
				}
			}
		}
	} catch(e){
		showErrorMessage("printPolicyDoc", e);
	}	
}

function validateBeforePrint(){
	var result = true;
	if (($("printerName").selectedIndex == 0) && ($("reportDestination").value == "PRINTER")){
		result = false;
		$("printerName").focus();
		showMessageBox("Printer Name is required.", "error");
	} else if (($("noOfCopies").selectedIndex == 0) && ($("reportDestination").value == "PRINTER")){
		result = false;
		$("noOfCopies").focus();
		showMessageBox("No. of Copies is required.", "error");
	}
	return result;
}

/**
 * @author andrew robes
 * @date 02.23.2011
 */
function getPolicyDocReportId(){
	if(objUWGlobal.lineCd == objLineCds.PK || objUWGlobal.menuLineCd == objLineCds.PK  || "0" != $F("globalPackParId") || objUWGlobal.packParId != null){ // andrew - 12.16.2011 - moved as the first condition
		return "PACKAGE";
	} else if(objUWGlobal.lineCd == objLineCds.MC || objUWGlobal.menuLineCd == objLineCds.MC){
		return "MOTORCAR";
	} else if(objUWGlobal.lineCd == objLineCds.FI || objUWGlobal.menuLineCd == objLineCds.FI){
		 return "FIRE";
	} else if(objUWGlobal.lineCd == objLineCds.MN || objUWGlobal.menuLineCd == objLineCds.MN){
		return "MARINE_CARGO";	
	} else if(objUWGlobal.lineCd == objLineCds.AV || objUWGlobal.menuLineCd == objLineCds.AV){
		return "AVIATION";		
	} else if(objUWGlobal.lineCd == objLineCds.CA || objUWGlobal.menuLineCd == objLineCds.CA){
		return "CASUALTY";		
	} else if(objUWGlobal.lineCd == objLineCds.MH || objUWGlobal.menuLineCd == objLineCds.MH){
		return "MARINE_HULL";	
	} else if(objUWGlobal.lineCd == objLineCds.AC || objUWGlobal.menuLineCd == objLineCds.AC || getLineCd(objUWGlobal.lineCd) == "AC"){ //added condition by robert 03.16.2015 
		return "ACCIDENT";	
	} else if(objUWGlobal.lineCd == objLineCds.EN || objUWGlobal.menuLineCd == objLineCds.EN) {	
		return "ENGINEERING";
	} else if(objUWGlobal.lineCd == objLineCds.SU || objUWGlobal.menuLineCd == objLineCds.SU){
		$("bondParType").value = $F("globalParType");
		return "BONDS";//change from SURETYSHIP to BONDS 03/11/2013_PJD
	} 
}

/**
 * @author Veronica V. Raymundo
 * @date   04.20.2011
 */
function printPackPolDoc(reportId){
	var packParId = (objUWGlobal.packParId != null ? objUWGlobal.packParId : $F("globalPackParId")); // andrew - 12.16.2011
	new Ajax.Request(contextPath+"/GIPIPolbasicController?action=populatePackGixxTableWPolDoc", {
		method: "GET",
		evalScripts: true,
		asynchronous: true,
		parameters: {
			globalPackParId: packParId, // andrew - 12.16.2011
			extractId: $("extractId").value
		},
		onCreate: showNotice("Generating report, please wait..."),
		onComplete: function(response){
			if(checkErrorOnResponse(response)) {
				printCurrentReport(reportId, $("reportDestination").value, $("printerName").value, $("noOfCopies").value);
				Modalbox.hide(); 
			}
		}								
	});
}

/**
 * @author Veronica V. Raymundo
 * @date   08.10.2011
 */
function checkIfCoverNotePrinted(){
	var reportId = "GIPIR919";
	var destination = $("reportDestination").value;
	var printerName = $("printerName").value;
	var noOfCopies = $("noOfCopies").value;
	var noOfDays = nvl($("noOfDays").value, 0);

	if($("coverNoteExpiry").value != "" || $("cnDatePrinted").value != ""){
		showConfirmBox("Confirmation", "Reprinting the Cover note will replace the existing CN Expiry & printed date. Would you like to continue?", "Ok", "Cancel",
			       function(){
					   printCoverNote(reportId, destination, printerName, noOfCopies, "Y", noOfDays);
	               },
	               function(){
	            	   printCoverNote(reportId, destination, printerName, noOfCopies, "N", noOfDays);
	               });
	}else{
		printCoverNote(reportId, destination, printerName, noOfCopies, "Y", noOfDays);
	}
}

checkPrintDestinationFields();
</script>