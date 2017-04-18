<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="printRecAEMainDiv" style="width: 99.5%; padding-top: 5px; float: left;">
	<input type="hidden" id="printerNames" name="printerNames" value="${printerNames}">
	<input type="hidden" id="reportId"     name="reportId" 	   value="${reportId}">
	<div class="sectionDiv" style="float: left;" id="printRecAEDiv">
		<table>
			<tr>
				<td class="rightAligned" style="width: 100px;">Destination</td>
				<td class="leftAligned">
					<select id="reportDestination" style="width: 200px;">
						<option value="screen">Screen</option>
						<option value="printer">Printer</option>
					</select>
				</td>
				<td rowspan="6" style="text-align: center;">
					<input type="button" class="button" id="btnPrint" name="btnPrint" value="Print" style="width: 80px; margin-bottom: 5px;">
					<input type="button" class="button" id="btnExitPrintAE" name="btnExitPrintAE" value="Cancel">		
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 100px;">Printer</td>
				<td class="leftAligned">
					<select id="printerName" style="width: 200px;" class="required">
						<option></option>
						<c:forEach var="p" items="${printers}">
							<option value="${p.printerNo}">${p.printerName}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 100px;">No. of Copies</td>
				<td class="leftAligned">
					<input type="text" id="noOfCopies" style="float: left; text-align: right; width: 175px;" class="required wholeNumber">
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
</div>
<script type="text/javascript">
	initializeAll();
	toggleDest();

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
	
	var reports = [];
	
	$("btnPrint").observe("click", function() {
		if(validateBeforePrint()) {
			printRecAE();
			/* if ("SCREEN" == $F("reportDestination")) {
				showMultiPdfReport(reports);
				reports = [];
			} */
		}
	});
	
	function printRecAE() {
		try {
			var tranId = $F("c042AcctTranId"); //306;  //for testing
			var tranNo = 0;
			var reportTitle = "GICLR055 - "+tranId;
			var content = contextPath+"/PrintDocumentsController?action=printRecAE&tranId="+tranId+"&tranNo="+tranNo+
					"&reportId=GICLR055&reportTitle="+reportTitle;
			if("screen" == $F("reportDestination")) {
				//reports.push({reportUrl : content, reportTitle: "GICLR077 - "+tranId});
				showPdfReport(content, reportTitle); 
				hideNotice("");
			} else if ("printer" == $F("reportDestination")) {
				new Ajax.Request(content, {
					method: "POST",
					parameters: {
						noOfCopies: $F("noOfCopies"),
						printerName: $F("printerName")
					},
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response) {
						hideNotice();
					}
				});
			} 
		} catch(e) {
			showErrorMessage("printRecAE", e);
		}
	}
	
	$("btnExitPrintAE").observe("click", function() {
		printRecAEOverlay.close();
	});
	
	function toggleDest(){
		if ($F("reportDestination") == "PRINTER"){
			$("printerName").enable();
			$("noOfCopies").enable();
			$("noOfCopies").value = "1";
			$("printerName").addClassName("required");
			$("noOfCopies").addClassName("required");
			$("imgSpinUp").show();
			$("imgSpinDown").show();
			$("imgSpinUpDisabled").hide();
			$("imgSpinDownDisabled").hide();
		} else {
			$("printerName").removeClassName("required");
			$("noOfCopies").removeClassName("required");
			$("printerName").selectedIndex = 0;
			$("printerName").value = "";
			$("noOfCopies").value = "";
			$("printerName").disable();
			$("noOfCopies").disable();	
			$("imgSpinUp").hide();
			$("imgSpinDown").hide();
			$("imgSpinUpDisabled").show();
			$("imgSpinDownDisabled").show();	
		}
	}

	function spinner(num) {
		var obj=document.getElementById('noOfCopies');
		var objNum = parseInt(obj.value);
		if(num < 0 && objNum == 1) {
			obj.value=objNum;
		} else {
			obj.value=parseInt(obj.value)+num;
		}
	}
	
	$("imgSpinUp").observe("click", function() {spinner(1);});
	$("imgSpinDown").observe("click", function() {spinner(-1);});
	
	
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
	
	$("reportDestination").observe("change", function(){
		var dest = $F("reportDestination");
		toggleRequiredFields(dest);
	});	
</script>