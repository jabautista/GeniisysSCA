<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="hiddenDiv">
	<input type="hidden" id="printerNames" value="${printerNames}" />
</div>
<div id="printMainDiv" class="sectionDiv" style="text-align: center;">
	<table style="margin-top: 10px; margin-bottom:10px; width: 100%;">
		<tr>
			<td class="rightAligned" style="width: 35%;">Destination</td>
			<td class="leftAligned" style="width: 65%;">
				<select id="reportDestination" style="width: 60%;">
					<option value="SCREEN">SCREEN</option>
					<option value="PRINTER">PRINTER</option>
					<option value="FILE">FILE</option>
					<option value="LOCAL">LOCAL PRINTER</option>
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
		<tr>
			<td class="rightAligned" style="width: 35%;">No of Copies</td>
			<td class="leftAligned" style="width: 65%;">
				<input type="text" id="noOfCopies" style="width: 51.5%; text-align: right; float: left;" class="integerNoNegativeUnformatted" 
					errorMsg="Entered No. of Copies is invalid." value="1" />
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
<div id="buttonsDiv" style="text-align: center;">
	<input type="button" class="button" id="btnPrint" value="Print" style="width: 80px; margin-top: 10px;" />
	<input type="button" class="button" id="btnCancel" value="Cancel" style="width: 80px; margin-top: 10px;" />
</div>
<script>
	initializeAll();
	insertPrinterNames();
	toggleDest();

	var tranId = "";
	var tranDate = "";
	
	$("printerName").disable();
	$("noOfCopies").disable();
		
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
	
	function spinner(num) {
		var obj=document.getElementById('noOfCopies');
		var objNum = parseInt(obj.value);
		if(num < 0 && objNum == 1) {
			obj.value=objNum;
		} else {
			obj.value=parseInt(obj.value)+num;
		}
	}
	
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
	
	$("reportDestination").observe("change", function(){
		 toggleDest();
	});
	
	var reports = [];
	var arrTranId = [];
	$("btnPrint").observe("click", function(){
		if (validateBeforePrint()){
			tranDate = objCLM.batchOS.tranDate;
			var str = objCLM.batchOS.tranIds;
			var temp = new Array();
			temp = str.split(",");
			for (var i = 0; i<temp.length; i++) {
				tranId = temp[i];
				//printBatchOsAcctngEntries();//kenneth 12.17.2014
				arrTranId.push(tranId);
			}
			/* if ("SCREEN" == $F("reportDestination")) {//kenneth 12.17.2014
				showMultiPdfReport(reports);
				reports = [];
			} */
			printBatchOsAcctngEntries();
			$("btnCancel").value = "OK";
			arrTranId = [];
		}
	});
		
	function printBatchOsAcctngEntries(){
		try {
			var content = contextPath+"/PrintBatchOsAcctngEntriesController?action=printBatchOsAcctngEntries&tranId="+arrTranId+"&tranDate="+tranDate;
			
			if ("SCREEN" == $F("reportDestination")) {
				//reports.push({reportUrl : content, reportTitle : "GICLR207- "+tranId});
				showPdfReport(content, 	"GICLR207"); //kenneth 12.17.2014
				//showPdfReport(content, 	"GICLR207- "+tranId);
				//window.open(content, "", "location=0, toolbar=0, menubar=0, fullscreen=1");
				//hideNotice("");
			} else  if ("PRINTER" == $F("reportDestination")) {
				new Ajax.Request(content, {
					method: "POST",
					parameters : {noOfCopies : $F("noOfCopies"),
				         					  printerName : $F("printerName")},
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							
						}
					}
				});
			}  else  if("FILE" == $F("reportDestination")){
				new Ajax.Request(content, {
					method: "POST",
					parameters : {destination : "FILE"},
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							copyFileToLocal(response);
						}
					}
				});
			} else if("LOCAL" == $F("reportDestination")){ //added by gab 12.01.2016 SR 5871
				new Ajax.Request(content, {
					parameters : {destination : "local"},
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
		} catch(e){
			showErrorMessage("printBatchOsAcctngEntries", e);
		}
	}
	
    $("imgSpinUp").observe("click", function() {spinner(1);});
	$("imgSpinDown").observe("click", function() {spinner(-1);});
	
	$("btnCancel").observe("click", function (){
		arrTranId = [];
		Modalbox.hide();
	});
</script>