<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>
<div id="24thMethodExtractMainDiv" name="24thMethodExtractMainDiv">
  	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="24thMethodExtractExit">Exit</a></li>
			</ul>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
   			<label>Unearned Premiums</label>
   			<span class="refreshers" style="margin-top: 0;">
   				<label id="reloadForm" name="reloadForm">Reload Form</label>
   			</span>
	   	</div>
	</div>
	
	<div id="24thMethodExtractSectionDiv" class="sectionDiv" style="height: 400px;">
		<div style="padding-left: 180px;">
			<div id="24thMethodPeriodDiv" name="24thMethodPeriodDiv" class="sectionDiv" style="width: 550px; margin-top: 25px;">
				<table align="center" style="margin-top: 20px; margin-bottom: 20px;">
					<tr>
						<td class="rightAligned">Period</td>
						<td class="leftAligned">
							<select id="periodMm" name="periodMm" class="required" style="width: 188px; height: 23px;" tabindex="101">
								<option value="1">January</option>
								<option value="2">February</option>
								<option value="3">March</option>
								<option value="4">April</option>
								<option value="5">May</option>
								<option value="6">June</option>
								<option value="7">July</option>
								<option value="8">August</option>
								<option value="9">September</option>
								<option value="10">October</option>
								<option value="11">November</option>
								<option value="12">December</option>
<!-- 								<option></option> -->
							</select>
<!-- 							<select id="periodYear" name="periodYear" class="required" style="width: 160px; height: 23px;" tabindex="102"> -->
<!-- 							</select>		 -->
							
						</td>	
						<td>
							<input type="text" id="txtYear" style="float: left; text-align: right; width: 160px; margin-bottom: 3px;" class="required integerNoNegativeUnformattedNoComma" maxlength="4" tabindex="102"/>
							<input type="hidden" id="hidLastValidYear"/> <!--mikel 02.02.2017; UCPBGEN SR 23722-->
							<div style="float: left; width: 15px; margin-top: 1px;">
								<img id="imgYrSpinUp" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; cursor: pointer;"/>
								<img id="imgYrSpinUpDisabled" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; display: none;"/>
								<img id="imgYrSpinDown" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; cursor: pointer;"/>
								<img id="imgYrSpinDownDisabled" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; display: none;"/>
							</div>
						</td>		
					</tr>
				</table>
			</div>
			
			<div id="24thMethodMethodDiv" name="24thMethodMethodDiv" class="sectionDiv" style="width: 550px; margin-top: 10px;">
				<table align="center" style="margin-top: 20px; margin-bottom: 20px;">
					<tr>
						<td class="rightAligned">Method</td>
						<td class="leftAligned">
							<select id="procedureDesc" name="procedureDesc" class="required" style="width: 380px; height: 23px;" tabindex="103">
								<c:forEach var="method" items="${methodListing}">
									<option value="${method.procedureId}"
										<c:if test="${method.procedureId eq method.procedureId}">
											selected="selected"
										</c:if>										
									>${method.procedureDesc}</option>
								</c:forEach>
<!-- 								<option></option> -->
							</select>
						</td>			
					</tr>
				</table>		
			</div>
		
			<div id="24thMethodUserDiv" name="24thMethodUserDiv" class="sectionDiv" style="width: 550px; margin-top: 10px;">
				<table align="center" style="margin-top: 20px; margin-bottom: 20px; margin-right: 57px;">
					<tr>
						<td class="rightAligned">User</td>
						<td class="leftAligned">
							<input type="text" id="txtUserExtract" name="txtUserExtract" value="${userId}" style="width: 372px;" readonly="readonly" tabindex="104"/>
						</td>			
					</tr>
					<tr>
						<td class="rigthAligned">Extract Date</td>
						<td class="leftAligned">
							<input type="text" id="txtLastExtract" name="txtLastExtract" value="${lastExtract}" style="width: 372px;" readonly="readonly" tabindex="105"/>
						</td>
					</tr>
				</table>		
			</div>
		</div>
		
		<div id="extractButtonsDiv" name="extractButtonsDiv" style="margin-left: 285px; float: left; height: 50px;">
			<table align="center" border="0" style="margin-bottom: 10px; margin-top: 10px;">
				<tr>
					<td><input type="button" class="button" id="btnExtract" name="btnExtract" value="Extract" style="width: 100px;" tabindex="201"/></td>
					<td><input type="button" class="button" id="btnView" name="btnView" value="View" style="width: 100px;" tabindex="202"/></td>
					<td><input type="button" class="button" id="btnPrint" name="btnPrint" value="Print" style="width: 100px;" tabindex="203"/></td>
 					<td>
						<div style="" >
							<img style="margin: 0;" id="imgHistory" src="${pageContext.request.contextPath}/images/misc/history.PNG" alt="History"  tabindex="204"/>
						</div>
					</td>				
				</tr>
			</table>
		</div>
	</div>
</div>
<script type="text/javascript">
	initializeAccordion();
	initializeAll();
	setModuleId("GIACS044");
	setDocumentTitle("Unearned Premiums");
	var userIss = '${userIss}';
	var sysYear =  parseInt('${sysYear}');
	var sysMonth = parseInt('${sysMonth}');
	var exist = "";
	objGiacs044.posted = null;
	objGiacs044.rowCount = 0;
	objGiacs044.selectedBranches = new Array();
	objGiacs044.extractCount = 0;
	
	var unearnedCompMethodParam = '${unearnedCompMethod}'; //Added by Jerome 09.21.2016 SR 5655
	
	if(unearnedCompMethodParam == '24'){ //Added by Jerome 09.21.2016 SR 5655
		$("procedureDesc").value = 1;
	}else if(unearnedCompMethodParam == '1/365'){
		$("procedureDesc").value = 3;
	}else if(unearnedCompMethodParam == '40'){
		$("procedureDesc").value = 2;
	}else{
		$("procedureDesc").value = 1;
	}
	
	function setSysMonth() {	//to display current month
		sysMonth = sysMonth + 1;
		if (objGiacs044.fromMenu == true) {
			$("periodMm").value = sysMonth;
			$("txtYear").value = sysYear;
		}else {
			$("txtYear").value = objGiacs044.year;
			$("periodMm").value = objGiacs044.mM;
			$("procedureDesc").value = objGiacs044.procedureId;
		}
	}
	
	function populatePeriodYear(){	//populate period year option's list
		try{
			var startYear = parseInt(1900);
			var body = "";
			for ( var i = 0; i < (sysYear - startYear); i++) {
				body += "<option value="+(sysYear - i)+">"+ (sysYear - i) + "</option>"; 
			}
			if (userIss != 0) {
				$("txtYear").update(body);		
			}else {
				$("txtYear").update(null);
				$("periodMm").update(null);
				$("procedureDesc").update(null);
			}
		}catch(e){  
			showErrorMessage("populateYear");
		}
	}
	
	extracted = false;
	
	function checkIfDataExist() {	//checks if data have been extracted prior to the given parameter
		new Ajax.Request(contextPath+"/GIACDeferredController", {
			parameters: {
				action: "checkIfDataExists",
				year: $F("txtYear"),
				mM: $F("periodMm"),
				procedureId: $F("procedureDesc")
			},
			method: "POST",
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					exist = response.responseText;
					if (response.responseText == 'Y') {
						if (messageToggle == "View") {	//to determine if function was called onClick of <View> or <Extract>
							show24thMethodView();
						}else if(messageToggle == "Print"){
							showGenericPrintDialog("Print Unearned Premiums", checkReport, get24thMethodPrintForm, true);
							$(csvOptionDiv).show(); // added by carlo rubenecia 04.07.2016 SR-5490
						}else if (messageToggle == "Extract") {
							showConfirmBox("Unearned Premiums", "Data has been extracted within the specified parameter/s. Do you wish to continue extraction?", 
									"Yes", "No", checkGenTag, "","");		//if records are extracted, check accounting entries
						}
					}else {
						if (messageToggle == "View") {
							showMessageBox("You have not yet extracted records for this Year and Month.", imgMessage.INFO);
						}else if(messageToggle == "Print" && !extracted){
							showMessageBox("Please extract records first.", imgMessage.INFO);
						}else if (messageToggle == "Print" && extracted){
							showConfirmBox("Unearned Premiums", "The specified parameter/s has not been extracted. Do you want to extract the data using the specified parameter/s?", 
									"Yes", "No", extractMethod, "","");	
						}else if (messageToggle == "Extract") {
							extractMethod();	
						}
					}
				}
			}
		});
	}
	
	function checkGenTag() {	//checks if accounting entries have already been posted
		new Ajax.Request(contextPath+"/GIACDeferredController", {
			parameters: {
				action: "checkGenTag",
				year: $F("txtYear"),
				mM: $F("periodMm"),
				procedureId: $F("procedureDesc")
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					if (response.responseText == 'Y') {		//posted
						checkStatus();
					}else {
						extractMethod();
					}
				}
			}
		});
	}
	
	function checkStatus() {	//check status of 24th method transactions
		new Ajax.Request(contextPath+"/GIACDeferredController", {
			parameters: {
				action: "checkStatus",
				year: $F("txtYear"),
				mM: $F("periodMm")
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					if (response.responseText == 'C') {		//closed transactions
						showConfirmBox("Unearned Premiums", "The accounting entries have already been closed. Would you like to re-extract and regenerate the accounting entries?", 
								"Yes", "No", updateTranFlag,"");
					}else if (response.responseText == "P") {		//posted transactions
						showConfirmBox("Unearned Premiums", "The accounting entries have already been posted. Would you like to reverse the posted 24th method transactions and re-extract/regenerate the accounting entries?",
								"Yes", "No", extractMethod,"");
					}else {
						//showMessageBox("Extraction not allowed.", imgMessage.INFO); //comment out by mikel 02.29.2016 GENQA 5288; continue extraction of records
						extractMethod(); //mikel 02.29.2016 GENQA 5288
					}
				}
			}
		});
	}
	
	function updateTranFlag() {		//sets tran flag to D for current entries in giac acctrans
		new Ajax.Request(contextPath+"/GIACDeferredController", {
			parameters: {
				action: "setTranFlag",
				year: $F("txtYear"),
				mM: $F("periodMm")
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					if (response.responseText == 'UPDATED') {
						extractMethod();
					}
				}
			}
		});
	}
	
	function extractMethod() {	//calls deferredExtract procedures
		new Ajax.Request(contextPath+"/GIACDeferredController", {
			parameters: {
				action: "extractMethod",
				year: $F("txtYear"),
				mM: $F("periodMm"),
				procedureId: $F("procedureDesc")
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function() {
				showNotice("Please wait...processing extract.");
			},
			onComplete: function(response) {
				hideNotice();
				if (checkErrorOnResponse(response)) {
					extracted = true;
					showMessageBox(response.responseText, imgMessage.INFO);
					
				}
			}
		});
	}
	
	function verifyFieldsOnExtract() {
		messageToggle = $F("btnExtract");
		if ($F("txtYear") == "" || $F("periodMm") == "" || $F("procedureDesc") == "" ||
				$F("txtYear") == null || $F("periodMm") == null || $F("procedureDesc") == null) {
			customShowMessageBox("No Data Extracted",imgMessage.INFO, "btnExtract");
		}else {
			checkIfDataExist();
		}
	}
	
	function show24thMethodView(){	
		new Ajax.Request(contextPath + "/GIACDeferredController?action=show24thMethodView", {
			onComplete : function(response){
				try { 
					if(checkErrorOnResponse(response)){
						$("dynamicDiv").update(response.responseText);
					}
				} catch(e){
						showErrorMessage("show24thMethodView - onComplete : ", e);
				}								
			} 
		});			
	}
	
	function showExtractHistoryOverlay() {
		try {
			var fundCd = objACGlobal.fundCd == null ? "" : objACGlobal.fundCd;
			overlayExtractHistory = Overlay.show(contextPath + "/GIACDeferredController", {
				urlContent : true,
				urlParameters : {action : "getExtractHistory",
					fundCd : fundCd},
				title : "History of Extraction",
				height : '400px',
				width : '792px',
				draggable : true
			});
		} catch (e) {
			showErrorMessage("Error in showExtractHistoryOverlay ", e);
		}
	}
	
 	function get24thMethodPrintForm() {		
		var div = "<div style='margin-top:10px; margin-bottom:10px;'><table align='center'><tr>"
					+"<td class='rightAligned' style='padding-right:5px;'>Period</td>"
					+"<td class='leftAligned'><select id='selPeriodMmPrint' name='selPeriodMmPrint' style='width:150px; height:23px;'>"
					+"<option value='1' id='1'>January</option>"
					+"<option value='2' id='2'>February</option>"
					+"<option value='3' id='3'>March</option>"
					+"<option value='4' id='4'>April</option>"
					+"<option value='5' id='5'>May</option>"
					+"<option value='6' id='6'>June</option>"
					+"<option value='7' id='7'>July</option>"
					+"<option value='8' id='8'>August</option>"
					+"<option value='9' id='9'>September</option>"
					+"<option value='10' id='10'>October</option>"
					+"<option value='11' id='11'>November</option>"
					+"<option value='12' id='12'>December</option></select></td>"
					+"<td><input type='text' id='txtPrintYear' style='float: left; text-align: right; width: 60px; margin-bottom: 4px;' class='integerNoNegativeUnformattedNoComma' maxlength='4'/>"
					+"<div style='float: left; width: 15px; margin-top: 1px;'>"
					+"<img id='imgPrintYrSpinUp' alt='Up' src='${pageContext.request.contextPath}/images/misc/spinup.gif' style='margin-left: 1px; margin-bottom: 2px; margin-top: 2px; cursor: pointer;'/>"
					+"<img id='imgPrintYrSpinUpDisabled' alt='Up' src='${pageContext.request.contextPath}/images/misc/spinup.gif' style='margin-left: 1px; margin-bottom: 2px; margin-top: 2px; display: none;'/>"
					+"<img id='imgPrintYrSpinDown' alt='Down' src='${pageContext.request.contextPath}/images/misc/spindown.gif' style='margin-left: 1px; cursor: pointer;'/>"
					+"<img id='imgPrintYrSpinDownDisabled' alt='Down' src='${pageContext.request.contextPath}/images/misc/spindown.gif' style='margin-left: 1px; display: none;'/>"
				 	+"</td></div>"
					+"</td></tr></table></div><div style='margin-bottom:10px;'><table align='center'>"
					+"<tr><td><input type='checkbox' id='chkGenAcctgEntries' name='chkGenAcctgEntries' checked='checked'/></td>"
					+"<td style='width:150px;'><label for='chkGenAcctgEntries'>Generated Acctg Entries</label></td>"
					+"<td><input type='checkbox' id='chkRevEntries' name='chkRevEntries'/></td>"
					+"<td><label for='chkRevEntries'>Reversing Entries</label></td></tr></table><table style='margin-top:10px;'>"
					+"<tr><td class='rightAligned'><input type='checkbox' id='chkPerBranch' name='chkPerBranch'/></td>"
					+"<td><label for='chkPerBranch'><input type='button' class='button' id='btnPerBranch' name='btnPerBranch' value='Per Branch'></label></td>"
					+"<td><input type='hidden' id='txtMonth' name='txtMonth'></td></table>"
					+"<table align='center'><tr><td><input type='checkbox' id='chkDetailed' name='chkDetailed'/></td>"  //added by carlo rubenecia 04.05.2016 SR 5490 - START
					+"<td><label for='chkDetailed '>Detailed</label></td>"
					+"<td><select id='selDetailed' name='selDetailed' style='width:200px; height:23px;'>"
					+"<c:forEach var='code' items='${codeListing}'>"
					+"<option value='${code.rvMeaning}'>${code.rvMeaning}"
					+"</option></c:forEach></select></td>" //added by carlo rubenecia 04.05.2016 SR 5490 - END
					+"</table></div>";
					
		var div2 = $("printDialogFormDiv").down("table");
		$("printDialogFormDiv2").update(div2);
		$("printDialogFormDiv2").show();
		$("printDialogFormDiv").update(div);
		$("printDialogMainDiv").up("div",1).style.height = "320px"; //changed height by carlo rubenecia 04.07.2016 SR 5490
		$($("printDialogMainDiv").up("div",1).id).up("div",0).style.height = "350px"; //changed height by carlo rubenecia 04.07.2016 SR 5490
		
		var startYear = parseInt(1900);
		var body = "";
		for ( var i = 0; i < (sysYear - startYear); i++) {
			body += "<option value="+(sysYear - i)+">"+ (sysYear - i) + "</option>"; 
		}
		$("txtPrintYear").update(body);
		$("txtPrintYear").value = sysYear;
		disableButton("btnPerBranch");
		
		$("chkPerBranch").observe("click", function() {
			if ($("chkPerBranch").checked) {
				enableButton("btnPerBranch");
			}else {
				objGiacs044.rowCount = 0;
				objGiacs044.selectedBranches = [];
				disableButton("btnPerBranch");
			}
		});
		
		$("imgPrintYrSpinUp").observe("click", function() {
			var no = parseInt(nvl($F("txtPrintYear"), 0));
			$("txtPrintYear").value = no + 1;
			$("hidLastValidPrintYear").value = $F("txtPrintYear");
		});

		$("imgPrintYrSpinDown").observe("click", function() {
			var no = parseInt(nvl($F("txtPrintYear"), 0));
			if (no > 1) {
				$("txtPrintYear").value = no - 1;
			}
			$("hidLastValidPrintYear").value = $F("txtPrintYear");
		});

		$("imgPrintYrSpinUp").observe("mouseover", function() {
			$("imgPrintYrSpinUp").src = contextPath + "/images/misc/spinupfocus.gif";
		});

		$("imgPrintYrSpinDown").observe("mouseover", function() {
			$("imgPrintYrSpinDown").src = contextPath + "/images/misc/spindownfocus.gif";
		});
		
		$("btnPerBranch").observe("click", function() {
			if ($("chkPerBranch").checked) {
				try {
					overlayBranchList = Overlay.show(contextPath + "/GIACDeferredController", {
						urlContent : true,
						urlParameters : {action : "getBranchList",
							year: $("txtPrintYear").value,
							mM: $("selPeriodMmPrint").value},
						title : "List of Branches",
						height : '310px',
						width : '385',
						draggable : true
					});
				} catch (e) {
					showErrorMessage("Error in showBranchListOverlay ", e);
				}
				
				objGiacs044.printYear = $F("txtPrintYear");
				for (var i=0; i<=12; i++){
					if ($F("selPeriodMmPrint") == i) {
						$("txtMonth").value = i;
						objGiacs044.printMm = $($("txtMonth").value).innerHTML;
						break;
					}
				}
			}
		});
		$("chkDetailed").observe("click", function() { //added by carlo rubenecia 04.05.2016 -START
			if ($("chkDetailed").checked) {
				chkGenAcctgEntries.disable();
				chkPerBranch.disable();
				chkRevEntries.disable();
				disableButton("btnPerBranch");
			}else {
				chkGenAcctgEntries.enable();
				chkPerBranch.enable();
				chkRevEntries.enable();
				if($("chkPerBranch").checked == true){
					enableButton("btnPerBranch");
				}
			}
		});  //added by carlo rubenecia 04.05.2016 SR 5490 - END
	}
 	
 	var reports = [];
 	var content = "";
 	function checkReport() {
 		if($("chkDetailed").checked == false){ //added by carlo rubenecia 04.07.2016 SR 5490
			if ($("chkGenAcctgEntries").checked == false && $("chkRevEntries").checked == false) {
			showMessageBox("Please select type of report.", imgMessage.INFO);
			}else if ($("chkPerBranch").checked == true && objGiacs044.selectedBranches.length == 0) {
			showMessageBox("Please select branch(es) to print.", imgMessage.INFO);
			}else{
			getReports();
			}
 		}
 		else{	//added by carlo rubenecia 04.07.2016 SR 5490
 			getReports();
 		}
	}
 	
 	function getReports() {
 		var report = [];
 		if ($("chkDetailed").checked == true) { //added by Carlo Rubenecia 04.06.2016 -START
			content = contextPath+"/EndOfMonthPrintReportController?action=printReport&reportId=GIACR045"
									+ "&extractMm=" + $F("selPeriodMmPrint")
									+ "&extractYear=" + $F("txtPrintYear")
									+ "&reportType="+$F("selDetailed");
			report.push({reportId : "GIACR045", reportTitle : "Detailed 24th Method", content : content});
		}  //added by carlo rubenecia 04.06.2016 SR 5490 - END
 		else{
		if ($("chkPerBranch").checked == true) {
 			for ( var i = 0; i < objGiacs044.rowCount; i++) {
 		 		if ($("chkGenAcctgEntries").checked == true) {
 					content = contextPath+"/EndOfMonthPrintReportController?action=printReport&reportId=GIACR044"
											+ "&mm=" + $F("selPeriodMmPrint")
											+ "&year=" + $F("txtPrintYear")
											+ "&branchCd=" + objGiacs044.selectedBranches[i].branchCd;
 					report.push({reportId : "GIACR044", reportTitle : "Generated Accounting Entries(24th Method) - "+objGiacs044.selectedBranches[i].branchCd,
 						content : content});
 				}
 		 		if ($("chkRevEntries").checked == true) {
 					content = contextPath+"/EndOfMonthPrintReportController?action=printReport&reportId=GIACR044R"
											+ "&mm=" + $F("selPeriodMmPrint")
											+ "&year=" + $F("txtPrintYear")
											+ "&branchCd=" + objGiacs044.selectedBranches[i].branchCd;
 		 			report.push({reportId : "GIACR044R", reportTitle : "Reversing Entries(24th Method) - "+objGiacs044.selectedBranches[i].branchCd,
 		 				content : content});
 				}
 			}
		}else{
	 		
	 		if ($("chkGenAcctgEntries").checked == true) {
				content = contextPath+"/EndOfMonthPrintReportController?action=printReport&reportId=GIACR044"
										+ "&mm=" + $F("selPeriodMmPrint")
										+ "&year=" + $F("txtPrintYear")
										+ "&branchCd=";
				report.push({reportId : "GIACR044", reportTitle : "Generated Accounting Entries(24th Method)", content : content});
			}
	 		if ($("chkRevEntries").checked == true) {
				content = contextPath+"/EndOfMonthPrintReportController?action=printReport&reportId=GIACR044R"
										+ "&mm=" + $F("selPeriodMmPrint")
										+ "&year=" + $F("txtPrintYear")
										+ "&branchCd=";
	 			report.push({reportId : "GIACR044R", reportTitle : "Reversing Entries(24th Method)", content : content});
			}
			}
		} 	
		for ( var i = 0; i < report.length; i++) {
			print24thMethod(report[i].reportId, report[i].reportTitle, report[i].content);
		}
		if ("screen" == $F("selDestination")) {
			showMultiPdfReport(reports);
			reports = [];
		}
	}

 	function print24thMethod(reportId, reportTitle, content){
		try {
			if($F("selDestination") == "screen"){
				reports.push({reportUrl : content, reportTitle : reportTitle});			
			}else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					method: "GET",
					parameters : {noOfCopies : $F("txtNoOfCopies"),
							 	 printerName : $F("selPrinter")
							 	 },
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						if (checkErrorOnResponse(response)){
						
						}
					}
				});
			}else if($F("selDestination") == "file"){
				var fileType = "PDF"; //added by carlo rubenecia 04.07.2016 SR 5490
				
				if($("rdoPdf").checked)//added by carlo rubenecia 04.07.2016 SR 5490
					fileType = "PDF";
				
				else if ($("rdoCsv").checked)//added by carlo rubenecia 04.07.2016 SR 5490
					fileType = "CSV"; 
				new Ajax.Request(content, {
					method: "POST",
					parameters : {destination : "file",
								  fileType    : fileType}, //added by carlo rubenecia 04.07.2016 SR 5490
					evalScripts: true,
					asynchronous: true,
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							//copyFileToLocal(response, "reports"); removed by carlo rubenecia SR 5490
							if ($("rdoCsv").checked){ // added by carlo rubenecia - start SR 5490
								copyFileToLocal(response, "csv");
								deleteCSVFileFromServer(response.responseText);
							}else
								copyFileToLocal(response, "reports");
							// added by carlo rubenecia - end SR 5490
						}
					}
				});
			}else if("local" == $F("selDestination")){
				new Ajax.Request(content, {
					method: "POST",
					parameters : {destination : "local"},
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
			}
		} catch (e){
			showErrorMessage("print24thMethod", e);
		}
	}
 	
 	messageToggle = null;
	$("btnExtract").observe("click", verifyFieldsOnExtract);
	
	$("btnView").observe("click", function() {
		if ($F("txtYear") == "" || $F("periodMm") == "" || $F("procedureDesc") == "" ||
				$F("txtYear") == null || $F("periodMm") == null || $F("procedureDesc") == null) {
			customShowMessageBox("No Data Extracted",imgMessage.INFO, "btnExtract");
		}else {
			messageToggle = $F("btnView");
			objGiacs044.year = $F("txtYear");
			objGiacs044.mM = $F("periodMm");
			objGiacs044.procedureId = $F("procedureDesc");
			checkIfDataExist();
		}
	});
	$("imgHistory").observe("click", showExtractHistoryOverlay);
	
	$("btnPrint").observe("click", function(){
		messageToggle = $F("btnPrint");
		checkIfDataExist();
// 		showGenericPrintDialog("Print Unearned Premiums", checkReport, get24thMethodPrintForm, true);
	});
	
	$("imgYrSpinUp").observe("click", function() {
		var no = parseInt(nvl($F("txtYear"), 0));
		$("txtYear").value = no + 1;
		$("hidLastValidYear").value = $F("txtYear");
	});

	$("imgYrSpinDown").observe("click", function() {
		var no = parseInt(nvl($F("txtYear"), 0));
		if (no > 1) {
			$("txtYear").value = no - 1;
		}
		$("hidLastValidYear").value = $F("txtYear");
	});

	$("imgYrSpinUp").observe("mouseover", function() {
		$("imgYrSpinUp").src = contextPath + "/images/misc/spinupfocus.gif";
	});

	$("imgYrSpinDown").observe("mouseover", function() {
		$("imgYrSpinDown").src = contextPath + "/images/misc/spindownfocus.gif";
	});

	observeCancelForm("24thMethodExtractExit", "", function(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
	});

	populatePeriodYear();
	setSysMonth();
	
	observeReloadForm("reloadForm", function() {
		new Ajax.Request(contextPath + "/GIACDeferredController", {
			parameters : {
				action : "show24thMethod"
			},
			onCreate : function() {
				showNotice("Loading, please wait...");
			},
			onComplete : function(response) {
				try {
					hideNotice();
					if (checkErrorOnResponse(response)) {
						$("dynamicDiv").update(response.responseText);
						objGiacs044.fromMenu = true;
					}
				} catch (e) {
					showErrorMessage("show24thMethod - onComplete : ",
							e);
				}
			}
		});

	});
	
	objGiacs044.checkReport = checkReport;
	
	objGiacs044.get24thMethodPrintForm = get24thMethodPrintForm;
</script>