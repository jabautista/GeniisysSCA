<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="hiddenDiv">
	<input type="hidden" id="inspNo" value="${inspNo }" />
	<input type="hidden" id="printerNames" value="${printerNames}" />
</div>
<div id="printInspRepMainDiv" class="sectionDiv" style="text-align: center; width: 100%;">
	<table style="margin-top: 10px; width: 100%; margin-bottom: 10px;">
		<tr>
			<td class="leftAligned" style="width: 20%;">Destination :</td>
			<td class="rightAligned" style="width: 40%;">
				<select id="printDestination" style="width: 158px;">
					<option value="SCREEN">SCREEN</option>
					<option value="PRINTER">PRINTER</option>
					<option value="FILE">FILE</option>  <!-- added by carloR -->
					<option value="LOCAL">LOCAL PRINTER</option> <!-- added by carloR -->
				</select>
			</td>
			<td rowspan="6" style="text-align: center;">
				<input type="button" class="button" id="btnPrint" value="Print" style="float: left; width: 140px; margin-left: 30px; margin-top: 20px;" />
				<input type="button" class="button" id="btnCancel" value="Cancel" style="float: left; width: 140px; margin-left: 30px; margin-top: 4px;" />
			</td>
		</tr>
		<tr>
			<td class="leftAligned" style="width: 20%;">Printer :</td>
			<td class="rightAligned" style="width: 40%;">
				<select id="printerName" style="width: 158px;">
					<option value=""></option>
				</select>
			</td>
		</tr>
		<tr>
			<td class="leftAligned" style="width: 20%;">No of copies :</td>
			<td class="rightAligned" style="width: 40%;">
				<select id="noOfCopies" style="width: 158px;">
					<c:forEach var="count" begin="1" end="5" step="1">
						<option value="${count}">${count}</option>
					</c:forEach>
				</select>
			</td>
		</tr>
	</table>
</div>
<script>
	insertPrinterNames();

	function printInspectionReport(){
		var content = contextPath+"/GIPIInspectionReportController?action=printInspectionReport&inspNo="+$F("inspNo")+
			"&printerName="+$F("printerName");

		if ("SCREEN" == $F("printDestination")){
			//window.open(content, "name=Inspection Report", "location=no, toolbar=no, menubar=no, fullscreen=yes");
			showPdfReport(content, "Inspection Report"); // andrew - 12.12.2011
			if (!(Object.isUndefined("printInspRepMainDiv"))){
				hideOverlay();
			}
		} else if ("PRINTER" == $F("printDestination")){
			new Ajax.Request(content,{
				method: "POST",
				evalScripts: true,
				asynchronous: false
			});
		} else if ("FILE" == $F("printDestination")){ //carloR SR 5660 09.26.2016 START
			new Ajax.Request(content, {
				parameters : {
					destination : "file",
					fileType : "PDF"
				},
				onCreate : showNotice("Generating report, please wait..."),
				onComplete : function(response) {
					hideNotice();
					if (checkErrorOnResponse(response)) {
						copyFileToLocal(response);
					}
				}
			});	
		} else {
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
		} //end
	}
	
	$("printerName").disable();
	$("noOfCopies").disable();
	
	$("printDestination").observe("change", function (){
		var selectedIndex = $("printDestination").options.selectedIndex;
		if (selectedIndex == 0){
			$("printerName").disable();
			$("noOfCopies").disable();
			$("printerName").removeClassName("required");
			$("noOfCopies").removeClassName("required");
			$("printerName").value = ""; //added by carloR 
			$("noOfCopies").value = "1";  //end
		} else if (selectedIndex == 1){
			$("printerName").enable();
			$("noOfCopies").enable();
			$("printerName").addClassName("required");
			$("noOfCopies").addClassName("required");
		} else if (selectedIndex == 2){ //carloR start
			$("printerName").disable();
			$("noOfCopies").disable();
			$("printerName").removeClassName("required");
			$("noOfCopies").removeClassName("required");
			$("printerName").value = "";
			$("noOfCopies").value = "1"; 
		} else{
			$("printerName").disable();
			$("noOfCopies").disable();
			$("printerName").removeClassName("required");
			$("noOfCopies").removeClassName("required");
			$("printerName").value = "";
			$("noOfCopies").value = "1"; 
		} //end
	});
	
	$("btnPrint").observe("click", function (){
		var selectedIndex = $("printDestination").options.selectedIndex;
		if(selectedIndex == 0){
			printInspectionReport();
		}else{
			if(checkAllRequiredFieldsInDiv("printInspRepMainDiv")){
				printInspectionReport();
			}
		}	
		
	});
	
	$("btnCancel").observe("click", function (){
		changeTag = 0; //added by robert 01.22.2014
		Modalbox.hide();
	});
</script>