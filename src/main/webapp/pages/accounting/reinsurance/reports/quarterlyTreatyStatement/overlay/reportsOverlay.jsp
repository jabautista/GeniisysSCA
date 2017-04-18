<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div>
	<div class="sectionDiv" style="width: 440px; height: 100px; margin: 15px 10px 5px 5px;">
		<div id="reportTG" name="reportTG" style="width: 420px; height: 100px; margin: 10px 10px 10px 10px;">
			<select id="selReport" style="width: 420px; height: 80px;" multiple>
					<c:forEach var="r" items="${reportList}">
						<option value="${r.reportId}" title="${r.reportTitle}">${r.reportTitle}</option>
					</c:forEach>
			</select>
		</div>
	</div>
	<div id="printDiv" class="sectionDiv" style="width: 440px; margin: 0 10px 0 5px;">
		<table id="printDialogMainTab" name="printDialogMainTab" align="center" style="margin-top: 15px; margin-bottom: 10px;" border="0">
			<tr>
				<td class="rightAligned">Destination</td>
				<td class="leftAligned"><select id="selDestination" style="width: 200px;" tabindex="109">
						<option value="screen">Screen</option>
						<option value="printer">Printer</option>
						<option value="file">File</option>
						<option value="local">Local Printer</option>
				</select></td>
			</tr>
			<tr>
				<td></td>
				<td>
					<input value="PDF" title="PDF" type="radio" id="rdoPdf" name="fileType" style="margin: 2px 5px 4px 5px; float: left;" checked="checked" disabled="disabled" tabindex="110"/>
					<label for="rdoPdf" style="margin: 2px 0 4px 0">PDF</label> 
					<input value="EXCEL" title="Excel" type="radio" id="rdoExcel" name="fileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled" tabindex="111" />
					<label for="rdoExcel" style="margin: 2px 0 4px 0">Excel</label>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Printer</td>
				<td class="leftAligned"><select id="selPrinter" style="width: 200px;" class="required" tabindex="112">
						<option></option>
						<c:forEach var="p" items="${printers}">
							<option value="${p.name}">${p.name}</option>
						</c:forEach>
				</select></td>
			</tr>
			<tr>
				<td class="rightAligned">No. of Copies</td>
				<td class="leftAligned"><input type="text" id="txtNoOfCopies" maxlength="3" style="float: left; text-align: right; width: 175px;" class="integerNoNegativeUnformattedNoComma" tabindex="113">
					<div style="float: left; width: 15px;">
						<img id="imgSpinUp" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; cursor: pointer;" />
						<img id="imgSpinUpDisabled" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; display: none;"/>
						<img id="imgSpinDown" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; cursor: pointer;"/> 
						<img id="imgSpinDownDisabled" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; display: none;"/>
					</div>
				</td>
			</tr>
		</table>				
	</div><!-- end: printDiv -->
	<div class="buttonsDiv" style="width: 440px; margin: 20px 10px 10px 10px;">
		<input type="button" class="button" id="btnPrint" name="btnPrint" value="Print" style="width: 90px;" />
		<input type="button" class="button" id="btnCancel" name="btnCancel" value="Cancel" style="width: 90px;" />		
	</div>
</div>

<script type="text/javascript">

	var fromPage = ('${fromPage}');
	if($("selReport").options.length > 0){
		$("selReport").options[0].setAttribute('selected', 'selected');
	}
	
	function toggleRequiredFields(dest) {
		if (dest == "printer") {
			$("selPrinter").disabled = false;
			$("txtNoOfCopies").disabled = false;
			$("selPrinter").addClassName("required");
			$("txtNoOfCopies").addClassName("required");
			$("imgSpinUp").show();
			$("imgSpinDown").show();
			$("imgSpinUpDisabled").hide();
			$("imgSpinDownDisabled").hide();
			$("txtNoOfCopies").value = 1;
			$("rdoPdf").disable();
			$("rdoExcel").disable();
		} else {
			if (dest == "file") {
				$("rdoPdf").enable();
				$("rdoExcel").enable();
			} else {
				$("rdoPdf").disable();
				$("rdoExcel").disable();
			}
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
		}
	}
	
	//PRINTDIV
	$("imgSpinUp").observe("click", function() {
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		$("txtNoOfCopies").value = no + 1;
	});

	$("imgSpinDown").observe("click", function() {
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		if (no > 1) {
			$("txtNoOfCopies").value = no - 1;
		}
	});

	$("imgSpinUp").observe("mouseover", function() {
		$("imgSpinUp").src = contextPath + "/images/misc/spinupfocus.gif";
	});

	$("imgSpinDown").observe("mouseover", function() {
		$("imgSpinDown").src = contextPath + "/images/misc/spindownfocus.gif";
	});

	$("imgSpinUp").observe("mouseout", function() {
		$("imgSpinUp").src = contextPath + "/images/misc/spinup.gif";
	});

	$("imgSpinDown").observe("mouseout", function() {
		$("imgSpinDown").src = contextPath + "/images/misc/spindown.gif";
	});

	$("selDestination").observe("change", function() {
		var dest = $F("selDestination");
		toggleRequiredFields(dest);
	});
	
	$("btnPrint").observe("click", function(){
		try {
			if(checkAllRequiredFieldsInDiv("printDiv")){
				var fileType = "";
				if($("rdoPdf").disabled == false && $("rdoExcel").disabled == false){
					fileType = $("rdoPdf").checked ? "PDF" : "XLS"; 
				}
				
				var reports = $("selReport").options;
				var selectedReports = [];
				
				for(var i=0; i< reports.length; i++){
					if(reports[i].selected){
						selectedReports.push({reportId : reports[i].value, reportTitle : reports[i].title});
					}
				}
				
				if(selectedReports.length > 0){
					var reportsToPrint = [];
					for(var i=0; i<selectedReports.length; i++){
						var reportId = selectedReports[i].reportId;
						var reportTitle = selectedReports[i].reportTitle;
						
						var content = contextPath+"/ReinsuranceReportController?action=printReport"
									+ "&noOfCopies=" 	+ $F("txtNoOfCopies")
									+ "&printerName=" 	+ $F("selPrinter")
									+ "&destination=" 	+ $F("selDestination")
									+ "&reportId=" 		+ reportId
									+ "&reportTitle=" 	+ reportTitle
									+ "&fileType=" 		+ fileType
									+ "&lineCd=" 		+ nvl(objGtqs.lineCd, "")
									+ "&treatyYy=" 		+ nvl(objGtqs.treatyYy, "")
									+ "&shareCd=" 		+ nvl(objGtqs.shareCd, "")
									+ "&trtySeqNo="		+ nvl(objGtqs.trtySeqNo, "")
									+ "&riCd=" 			+ nvl(objGtqs.riCd, "")
									+ "&year=" 			+ nvl(objGtqs.year, "")
									+ "&qtr=" 			+ nvl(objGtqs.qtr, "");
						reportsToPrint.push({reportUrl : content, reportTitle : reportTitle});
						printGenericReport2(content, reportTitle); 
						
						if (i == selectedReports.length-1){
							if ("screen" == $F("selDestination")){
								showMultiPdfReport(reportsToPrint); 
							}
						}  
					}
				} else {
					showMessageBox("No reports selected.", "I");
				}
			}
		} catch(e){
			showErrorMessage("printReport", e);
		}
	});
	
	$("btnCancel").observe("click", function(){
		if(fromPage == "treatyStatement"){
			printTSReportsOverlay.close();	
		} else if(fromPage == "quarterlyTreatySummary"){
			printQTSReportsOverlay.close();
		}
	});
	
	$("txtNoOfCopies").observe("change", function(){
		if(parseInt($F("txtNoOfCopies")) > 100 || parseInt(nvl($F("txtNoOfCopies"), "0")) == 0 ){
			customShowMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "I", "txtNoOfCopies");
			$("txtNoOfCopies").value = "";
		}
	});
	
	initializeAll();
	toggleRequiredFields("screen");
</script>