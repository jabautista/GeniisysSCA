<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="printDialogMainDiv" style="width: 99.5%; padding-top: 5px; float: left;">
<input type="hidden" value="${adviceLength }" id="adviceLength"/>
<input type="hidden" value="${lineCd }" id="lineCd"/>
	<div class="sectionDiv" style="float: left;" id="printDialogFormDiv">
		<table align="center" style="padding: 10px;">
			<tr>
				<td class="rightAligned" style="width: 100px;">Destination</td>
				<td class="leftAligned">
					<select id="selDestination" style="width: 200px;">
						<option value="screen">Screen</option>
						<option value="printer">Printer</option>
						<option value="local">Local Printer</option> <!-- bonok :: 6.29.2015 :: SR 19535 - temp solution -->
					</select>
				</td>
				<td rowspan="6" style="text-align: center;">
					<input type="button" class="button" id="btnPrint" name="btnPrint" value="Print" style="width: 80px; margin-bottom: 5px;">
					<input type="button" class="button" id="btnCancel" name="btnCancel" value="Cancel">		
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 100px;">Printer</td>
				<td class="leftAligned">
					<select id="selPrinter" style="width: 200px;" class="required">
						<option></option>
					<%-- 	<c:forEach var="p" items="${printers}">
							<option printerNo="${p.printerNo}" value="${p.printerName}">${p.printerName}</option>
						</c:forEach> --%>
						<!-- installed printers ang gamitin - steven - 02.05.2013 -->
						<c:forEach var="p" items="${printers}">
							<option  value="${p.name}">${p.name}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 100px;">No. of Copies</td>
				<td class="leftAligned">
					<input type="text" id="txtNoOfCopies" style="float: left; text-align: right; width: 175px;" class="required wholeNumber">
					<div style="float: left; width: 15px;">
						<img id="imgSpinUp" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; cursor: pointer;">
						<img id="imgSpinUpDisabled" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; display: none;">
						<img id="imgSpinDown" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; cursor: pointer;">
						<img id="imgSpinDownDisabled" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; display: none;">
					</div>					
				</td>
			</tr>
		</table>
		<table style="padding-bottom: 10px;" cellpadding="3">
			<tr>
				<td class="rightAligned" style="width: 150px;">
					<input type="checkbox" id="chkRequestForPayment" name="chkRequestForPayment"/>
				</td>
				<td class="leftAligned">Request For Payment</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 150px;">
				<input type="checkbox" id="chkDetailsReport" name="chkDetailsReport"/>
			</td>
			<td class="leftAligned">Details</td>
			</tr>
		</table>
	</div>	
</div>
<script type="text/javascript">

	function toggleRequiredFields(dest){
		if(dest == "printer"){			
			$("selPrinter").disabled = false;
			$("txtNoOfCopies").disabled = false;
			$("selPrinter").addClassName("required"); // added by: Nica 12.07.2012
			$("txtNoOfCopies").addClassName("required");
			$("imgSpinUp").show();
			$("imgSpinDown").show();
			$("imgSpinUpDisabled").hide();
			$("imgSpinDownDisabled").hide();
			$("txtNoOfCopies").value = 1;
		} else {
			$("selPrinter").value = "";
			$("txtNoOfCopies").value = "";
			$("selPrinter").removeClassName("required"); // added by: Nica 12.07.2012
			$("txtNoOfCopies").removeClassName("required");
			$("selPrinter").disabled = true;
			$("txtNoOfCopies").disabled = true;
			$("imgSpinUp").hide();
			$("imgSpinDown").hide();
			$("imgSpinUpDisabled").show();
			$("imgSpinDownDisabled").show();			
		}
	}
	
	$("btnCancel").observe("click", function(){
		overlayGenericPrintDialog.close();
	});
	
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
	
	$("btnPrint").observe("click", function(){
		prepareToPrintSBCSR();
	});
	
	function prepareToPrintSBCSR(){
		try{
			var dest = $F("selDestination");
			var reportId = "";
			
			if($F("adviceLength") >1 ){
				reportId = "GIACR086";
			}else{
				reportId = "GIACR086C";
			}
			
			function printSBCSR(){
				if($("chkRequestForPayment").checked){
					printSBatchCsrReport(reportId);
					if($("chkDetailsReport").checked){
						setTimeout(function(){printSBatchCsrReport("GIACR086B");}, 1000);
					}
				}else if($("chkDetailsReport").checked){
					printSBatchCsrReport("GIACR086B");
				}else{
					showMessageBox("There is no report to print.", "I");
				}
			}
			
			if(dest == "printer"){
				if(checkAllRequiredFieldsInDiv("printDialogFormDiv")){
					printSBCSR();					
				}
			}else{
				printSBCSR();
			} 

		}catch(e){
			showErrorMessage("prepareToPrintSBCSR",e);
		}
	}
	function printSBatchCsrReport(reportId){
		try{
			var reportTitle = "";
			var outTitle = "";
			var destination	= $("selDestination").value;
			var printerName = $("selPrinter").value;
			var noOfCopies 	= $("txtNoOfCopies").value;
			
			if(reportId == "GIACR086B"){
				reportTitle = "Batch Special CSR Details";
				outTitle = "BSCSR_DETAILS";
			}else{
				reportTitle = "Batch Special CSR";
				outTitle = "BATCH_SCSR";
			}
			
			var content = contextPath+"/PrintBatchCsrReportsController?action=printBatchSCSR"
			+"&noOfCopies="+noOfCopies+"&printerName="+printerName+"&batchDvId="+nvl(objGICLBatchDv.batchDvId, 0)
			+"&tranId="+nvl(objGICLBatchDv.tranId, 0)+"&lineCd="+$F("lineCd")+"&branchCd="+nvl(objGICLBatchDv.branchCd, 0)
			+"&reportId="+reportId+"&reportTitle="+reportTitle+"&outTitle="+outTitle;
			
			if ("screen" == destination) {
				showPdfReport(content, reportTitle); 
				hideNotice("");
				
			}else if("local" == destination){ // bonok :: 6.29.2015 :: SR 19535 - temp solution
				new Ajax.Request(content, {
					method: "POST",
					parameters : {destination : "LOCAL"},
					evalScripts: true,
					asynchronous: true,
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
			} else { //PRINTER
				new Ajax.Request(content, {
					method: "POST",
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						if (checkErrorOnResponse(response)){
							hideNotice();
							showMessageBox("Printing Completed.", "I");
						}
					}
				});
			}
		}catch(e){
			showErrorMessage("printSBatchCsrReport",e);
		}
	}
	
	function setCheckboxesBehavior(clmDtlSw){
		if(nvl(clmDtlSw, "N") == "Y"){
			$("chkRequestForPayment").enable();
			$("chkDetailsReport").enable();
			$("chkRequestForPayment").checked = true;
			$("chkDetailsReport").checked = true;
		}else if(nvl(clmDtlSw, "N") == "N"){
			$("chkRequestForPayment").checked = true;
			$("chkDetailsReport").checked = false;
			$("chkDetailsReport").disable();
		}
	}

	
	initializeAll();
	setCheckboxesBehavior(objGICLBatchDv.printDetailsSw);
	toggleRequiredFields("screen");
</script>