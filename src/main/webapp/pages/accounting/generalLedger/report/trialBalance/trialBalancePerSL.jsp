<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>

<div id="checkRegisterMainDiv" name="checkRegisterMainDiv">
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
   			<label>Trial Balance Per SL</label>
   			<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>
	
	<div id="moduleDiv" name="moduleDiv" class="sectionDiv" >
		
		<div id="paramsDiv" name="paramsDiv" class="sectionDiv" style="width:65%; margin: 40px 120px 40px 130px;">
			<div id="searchParamsDiv" name="searchParamsDiv" class="sectionDiv" align="center" style="width:96.7%; margin:10px 10px 10px 10px;">
				<table border="0" align="center" style="margin:20px 0 20px 0; width:500px;">
					<tr>
						<td class="rightAligned">Month & Year :</td>
						<!-- <td class="leftAligned"></td> -->
						<td class="leftAligned">
							<select id="selMonth" name="selMonth" class="required" style="width:120px; float:left; margin-left:5px;"></select>
							<input type="text" id="txtYear" name="txtYear" maxlength="4" class="required integerNoNegativeUnformattedNoComma" min="1990" max="9999" errorMsg="Year should be between 1990 and 9999." style="width:100px; float:left; height:14px; margin:0 0 0 10px; text-align:right;" readonly="readonly" />								
							<div style="float: left; width: 15px;">
								<img id="imgSpinUpYear" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 0px; cursor: pointer;">
								<img id="imgSpinUpDisabledYear" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 0px; display: none;">
								<img id="imgSpinDownYear" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; margin-bottom: 4px; cursor: pointer;">
								<img id="imgSpinDownDisabledYear" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; margin-bottom: 4px; display: none;">
							</div>	
						</td>
						<td><input type="button" class="button" id="btnPostSL" name="btnPostSL" value="Post" style="width:90px; float:left;" /></td>
					</tr>								
				</table>
			</div> <!-- end: searchParamsDiv -->
				
			<div id="printDiv" class="sectionDiv" style="width:375px; height:150px; margin:0 0 10px 10px;">
				<div style="float:left; margin-left:20px; margin-top:10px;" id="printDialogFormDiv">
					<table id="printDialogMainTab" name="printDialogMainTab" align="center" style="padding: 10px;">
						<tr>
							<td class="rightAligned">Destination</td>
							<td class="leftAligned">
								<select id="selDestination" style="width: 200px;">
									<option value="screen">Screen</option>
									<option value="printer">Printer</option>
									<option value="file">File</option>
									<option value="local">Local Printer</option>
								</select>
							</td>
						</tr>
						<tr>
							<td></td>
							<td>
								<input value="PDF" title="PDF" type="radio" id="rdoPdf" name="fileType" style="margin: 2px 5px 4px 5px; float: left;" checked="checked" disabled="disabled"><label for="rdoPdf" style="margin: 2px 0 4px 0">PDF</label>
								<!-- <input value="EXCEL" title="Excel" type="radio" id="rdoExcel" name="fileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="rdoExcel" style="margin: 2px 0 4px 0">Excel</label>  Dren Niebres SR-5345 05.02.2016 -->
								<input value="CSV2" title="CSV" type="radio" id="rdoCsv" name="fileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="rdoCsv" style="margin: 2px 0 4px 0">CSV</label> <!-- Dren Niebres SR-5345 05.02.2016 -->
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
				</div>
			</div> <!-- end: printDiv -->
			
			<div id="printBtnDiv" name="printButtonDiv" class="sectionDiv" style="margin: 0 10px 10px 0; width:199.5px; height:150px;">
				<input type="button" class="button" id="btnPrint" name="btnPrint" value="Print" style="width:90px; float:center; margin-top:60px; " />
			</div>
		</div> <!-- end: paramsDiv -->
	</div> <!-- end: moduleDiv -->

</div>

<script>

	var newInstanceParams = new Object(); 
	try {
		newInstanceParams = JSON.parse('${params}');
	} catch(e){
		showErrorMessage("trialBalancePerSL", e);
	}

	function toggleRequiredFields(dest){
		if(dest == "printer"){			
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
			//$("rdoExcel").disable(); Dren Niebres SR-5345 05.02.2016 
			$("rdoCsv").disable(); //Dren Niebres SR-5345 05.02.2016			
		} else {
			if(dest == "file"){
				$("rdoPdf").enable();
				//$("rdoExcel").enable(); Dren Niebres SR-5345 05.02.2016 
				$("rdoCsv").enable(); //Dren Niebres SR-5345 05.02.2016
			} else {
				$("rdoPdf").disable();
				//$("rdoExcel").disable(); Dren Niebres SR-5345 05.02.2016 
				$("rdoCsv").disable(); //Dren Niebres SR-5345 05.02.2016
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
	
	function initializeDefaultValues(){
		//var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
		$("selMonth").innerHTML = "<option value=''></option>";
		for(var i=0; i<12; i++){
			var opt = document.createElement("option");
			opt.value = i;
			opt.text = getMonthWordEquivalent(i);
			$("selMonth").options.add(opt);
		}
		
		$("selMonth").value = newInstanceParams != null ? (newInstanceParams.month-1 != null ? newInstanceParams.month-1 : "") : "";
		$("txtYear").value = newInstanceParams != null ? (newInstanceParams.year != null ? newInstanceParams.year : "") : "";
		$("txtYear").readOnly = $F("txtYear").trim() == "" ? false : true; 
	}
		
	function validateReportId(reportId, reportTitle){
		try {
			new Ajax.Request(contextPath+"/GIACGeneralDisbursementReportsController",{
				parameters: {
					action:		"validateReportId",
					reportId:	reportId
				},
				ashynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						if (response.responseText == "Y"){
							printReport(reportId, reportTitle);
						}else{
							showMessageBox("No existing records found in GIIS_REPORTS for report id " + reportId + ".", "E");
						}
					}
				}
			});
		} catch(e){
			showErrorMessage("validateReportId",e);
		}
	}
	
	function printReport(reportId, reportTitle){
		try {
			if(checkAllRequiredFieldsInDiv("printDiv")){
				var fileType = "";
				var month = parseInt(nvl($F("selMonth"), 0))+parseInt("1") ;
				var reportId; //Dren Niebres SR-5345 05.02.2016 - Start
				
				if($F("selDestination") == "file") { 
					if ($("rdoPdf").checked) 
						reportId = "GIACR503";
					else 
						reportId = "GIACR503_CSV";		
				} else {
					reportId = "GIACR503";
				}				
				
				//if($("rdoPdf").disabled == false && $("rdoExcel").disabled == false){ 
				if($("rdoPdf").disabled == false && $("rdoCsv").disabled == false){ 
					fileType = $("rdoPdf").checked ? "PDF" : "CSV2"; 
				}
				
				var content = contextPath+"/GeneralLedgerPrintController?action=printReport"
							+ "&noOfCopies=" + $F("txtNoOfCopies")
							+ "&printerName=" + $F("selPrinter")
							+ "&destination=" + $F("selDestination")
							+ "&reportId=" + reportId
							+ "&reportTitle=" + reportTitle
							+ "&fileType=" + fileType
							+ "&moduleId=" + "GIACS503"
							
							+ "&month=" + month //p_tran_mm
							+ "&year=" + $F("txtYear");		//p_tran_year							
				
				if (fileType == "CSV2"){
					printGenericReport(content, reportTitle, null,"csv");
				} else 
					printGenericReport(content, reportTitle); //Dren Niebres SR-5345 05.02.2016 - End							
			}
		} catch(e){
			showErrorMessage("printReport", e);
		}
	}
	
	function proceedToPostSL(){
		try {
			new Ajax.Request(contextPath+"/GIACGeneralLedgerReportsController",{
				parameters: {
					action: "postSLForGiacs503",
					year: $F("txtYear"),
					month: parseInt($F("selMonth"))+1,
					firstPostingDate: newInstanceParams.firstPostingDate
				},
				ashynchronous: false,
				evalScripts: true,
				onCreate: function(){
					showNotice("Posting per SL, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, null)){
						var reply = JSON.parse(response.responseText);
						if(reply.message == "SUCCESS"){
							showMessageBox("Process completed.", "I");
						}
					}
				}
			});
		} catch(e){
			showErrorMessage("proceedToPostSL", e);
		}
	}
	
	function validateBeforePrint(){
		try {
			new Ajax.Request(contextPath+"/GIACGeneralLedgerReportsController",{
				parameters: {
					action: "validateGiacs503BeforePrint",
					year: $F("txtYear"),
					month: parseInt($F("selMonth"))+1
				},
				ashynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						if (response.responseText != null && response.responseText != ""){
							validateReportId("GIACR503","Trial Balance per SL");
						}else{
							showMessageBox("Please post the transactions first.", "I");
						}
					}
				}
			});
		} catch(e){
			showErrorMessage("validateBeforePrint",e);
		}
	}
	
	$("btnPostSL").observe("click", function(){
		if($F("selMonth") == "" || $F("txtYear") == ""){
			showMessageBox("Please select a transaction month and year.");
			return;
		}
		$("txtYear").readOnly = true;
		proceedToPostSL();
	});
	
	$("btnPrint").observe("click", function(){		
		if($F("selMonth") == "" || $F("txtYear") == ""){
			showMessageBox("Please select a transaction month and year.");
			return;
		}
		
		validateBeforePrint();
	});
	
	// ARROWS FOR YEAR
	$("imgSpinUpYear").observe("click", function(){
		var no = parseInt(nvl($F("txtYear"), 0));
		$("txtYear").value = no + 1;
	});
	
	$("imgSpinDownYear").observe("click", function(){
		var no = parseInt(nvl($F("txtYear"), 0));
		if(no > 1){
			$("txtYear").value = no - 1;
		}
	});
	
	$("imgSpinUpYear").observe("mouseover", function(){
		$("imgSpinUpYear").src = contextPath + "/images/misc/spinupfocus.gif";
	});
	
	$("imgSpinDownYear").observe("mouseover", function(){
		$("imgSpinDownYear").src = contextPath + "/images/misc/spindownfocus.gif";
	});
	
	$("imgSpinUpYear").observe("mouseout", function(){
		$("imgSpinUpYear").src = contextPath + "/images/misc/spinup.gif";
	});
	
	$("imgSpinDownYear").observe("mouseout", function(){
		$("imgSpinDownYear").src = contextPath + "/images/misc/spindown.gif";
	});
	
	// PRINT
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
	
	observeReloadForm("reloadForm", showTrialBalancePerSL);
		
	setModuleId("GIACS503");
	setDocumentTitle("Trial Balance Per SL");
	initializeAll();
	makeInputFieldUpperCase();
	toggleRequiredFields("screen");
	initializeDefaultValues();
	
</script>