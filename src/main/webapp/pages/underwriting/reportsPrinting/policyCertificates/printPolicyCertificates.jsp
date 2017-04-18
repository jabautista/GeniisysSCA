<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="printPolicyCertMenu">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="query">Query</a></li>
				<li><a id="parExit">Exit</a></li>
			</ul>
		</div>
	</div>
</div>
<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
		<label id="printPolicyCertLbl">Generate Policy Certificates</label>
		<span class="refreshers" style="margin-top: 0;">
 			<label id="reloadForm" name="reloadForm" style="margin-left: 5px;">Reload Form</label>
		</span>
	</div>
</div>
<div id="policyCertDetailsDiv">
	<div id="policyCertDetailsSectionDiv" class="sectionDiv" style="margin-bottom: 10px;">
		<%-- <jsp:include page="/pages/underwriting/reportsPrinting/policyCertificates/policyCertDetails.jsp"></jsp:include> --%>
	<!-- added from policyCertDetails.jsp  -->
	<table style="margin-top: 10px; width: 100%;">
		<tr>
			<td class="rightAligned" style="width: 25%;">
				Policy No.
			</td>
			<td class="leftAligned">
				
					<input id="txtLineCd" 	 class="leftAligned required" type="text" name="capsField" style="width: 8%;" value="" title="Line Code" maxlength="2"/>
					<input id="txtSublineCd" class="leftAligned" type="text" name="capsField" style="width: 15%;" value="" title="Subline Code"maxlength="7"/>
					<input id="txtIssCd" 	 class="leftAligned" type="text" name="capsField" style="width: 8%;"  value="" title="Issue Source Code"maxlength="2"/>
					<input id="txtIssueYy"   class="leftAligned integerNoNegativeUnformattedNoComma" type="text" name="intField"  style="width: 8%;"  value="" title="Year" maxlength="2"/>
					<input id="txtPolSeqNo"  class="leftAligned integerNoNegativeUnformattedNoComma" type="text" name="intField"  style="width: 15%;" value="" title="Policy Sequence Number" maxlength="7"/>
					<input id="txtRenewNo"   class="leftAligned integerNoNegativeUnformattedNoComma" type="text" name="intField"  style="width: 8%;"  value="" title="Renew Number" maxlength="2"/>
					<span>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchForPolicy" name="searchForPolicy" alt="Go" style="margin-top: 2px;" title="Search Policy"/>
					</span>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 25%;">
				Endorsement No.
			</td>
			<td class="leftAligned" style="width: 75%;">
				<input id="txtCLineCd" 	  class="leftAligned" type="text" name="capsField" style="width: 8%;"  value="" title="Line Code" maxlength="2"/>
				<input id="txtCSublineCd" class="leftAligned" type="text" name="capsField" style="width: 15%;" value="" title="Subline Code" maxlength="7"/>
				<input id="txtCEndtIssCd" class="leftAligned" type="text" name="capsField" style="width: 8%;"  value="" title="Endorsement Issue Source Code" maxlength="2"/>
				<input id="txtEndtYy"     class="leftAligned integerNoNegativeUnformattedNoComma" type="text" name="intField"  style="width: 8%;"  value="" title="Endorsement Year" maxlength="2"/>
				<input id="txtEndtSeqNo"  class="leftAligned integerNoNegativeUnformattedNoComma" type="text" name="intField"  style="width: 15%;" value="" title="Endorsement Sequence Number" maxlength="6"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 25%;">
				PAR No.
			</td>
			<td class="leftAligned" style="width: 75%;">
				<input id="parNo" class="leftAligned" type="text" name="capsField" style="width: 80%;" readonly="readonly" value=""/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 25%;">
				Assured Name
			</td>
			<td class="leftAligned" style="width: 75%;">
				<input id="assdName" class="leftAligned" type="text" name="capsField" style="width: 80%;" readonly="readonly" value=""/>
			</td>
		</tr>
		<tr>
			<td colspan="2"></td>
		</tr>
	</table>
	<div>
		<%-- <input type="hidden" id="printerNames" value="${printerNames}"> --%>
		<input type="hidden" id="policyId" name="policyId" value="">
		<input type="hidden" id="lineCd" name="lineCd" value="">
		<input type="hidden" id="menulineCd" name="menulineCd" value="">
	</div>
	<!-- end ~added from policyCertDetails.jsp  -->
		<div align="center">
		<table id="printDialogMainTab" name="printDialogMainTab" align="center" style="padding: 10px;">
						<tr>
							<td style="text-align:right; width: 80px;">Destination</td>
							<td style="width: 150px;">
								<select id="selDestination" style="margin-left:5px; width:200px;" tabindex="301" >
									<option value="screen">Screen</option>
									<option value="printer">Printer</option>
									<option value="file">File</option>
									<option value="local">Local Printer</option>
								</select>
							</td>
						</tr>
						<tr id="trRdoFileType">
							<td style="width: 80px;">&nbsp;</td>
							<td style="width: 150px;">
								<table border="0">
									<tr>
										<td><input type="radio" style="margin-left:0px;" id="rdoPdf" name="rdoFileType" value="PDF" title="PDF" checked="checked" disabled="disabled" style="margin-left:10px;" tabindex="302"/></td>
										<td><label for="rdoPdf"> PDF</label></td>
										<td style="width:20px;">&nbsp;</td>
										<td><input type="radio" id="rdoExcel" name="rdoFileType" value="XLS" title="Excel" disabled="disabled" tabindex="303" /></td>
										<td><label for="rdoExcel"> Excel</label></td>
									</tr>									
								</table>
							</td>
						</tr>
						<tr>
							<td style="text-align:right; width: 80px;">Printer Name</td>
							<td style="width: 123px">
								<select id="printerName" style="margin-left:5px; width:200px;" tabindex="304">
									<option></option>
										<c:forEach var="p" items="${printers}">
											<option value="${p.name}">${p.name}</option>
										</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<td style="text-align:right; width: 80px;">No. of Copies</td>
							<td style="width: 150px;">
								<input type="text" id="txtNoOfCopies" maxlength="3" style="margin-left:5px;float:left; text-align:right; width:177px;" class="integerNoNegativeUnformattedNoComma" tabindex="305">
								<div style="float: left; width: 15px;">
									<img id="imgSpinUp" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; cursor: pointer;">
									<img id="imgSpinUpDisabled" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; display: none;">
									<img id="imgSpinDown" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; cursor: pointer;">
									<img id="imgSpinDownDisabled" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; display: none;">
								</div>		
							</td>
						</tr>
						<tr>
							<td style="text-align:right; width: 80px;">
								<input type="checkbox" id="printPOC"/>
							</td>
							<td class="leftAligned" style="width: 150px;">
								<label id="lblPrintPOC" for="printPOC">Print Other Certificate</label>
							</td>
						</tr>
					</table>
			<%-- <table style="margin: 10px 0; width: 100%;">
				<tr>
					<td class="rightAligned" style="width: 18%;">Destination</td>
					<td class="leftAligned" style="width: 30%;">
						<select id="selDestination" class="leftAligned required" style="width: 40%;">
							<option value="screen">Screen</option>
							<option value="printer">Printer</option>
							<option value="file">File</option>
							<option value="local">Local Printer</option>
							<option value="LOCAL PRINTER">LOCAL PRINTER</option> <!-- added by jeffdojello 01.22.2014 -->
						</select>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">
						<input type="radio" id="rdoPdf" name="rdoFileType" value="PDF" title="PDF" checked="checked" disabled="disabled" tabindex="302"/>
						<label for="rdoPdf"> PDF</label>
					</td>
					<td class="leftAligned">
						<input type="radio" id="rdoExcel" name="rdoFileType" value="XLS" title="Excel" disabled="disabled" tabindex="303" />
						<label for="rdoExcel"> Excel</label>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 18%;">Printer Name</td>
					<td class="leftAligned" style="width: 30%">
						<select id="printerName" class="leftAligned" style="width: 40%;">
						<option></option>
							<c:forEach var="p" items="${printers}">
								<option value="${p.name}">${p.name}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 18%;">No. of Copies</td>
					<td class="leftAligned" style="width: 30%;">
						<input type="text" id="txtNoOfCopies" maxlength="30" style="float:left; text-align:right; width:40%;" class="integerNoNegativeUnformattedNoComma" tabindex="305">
						<div style="float: left; width: 15px;">
							<img id="imgSpinUp" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; cursor: pointer;">
							<img id="imgSpinUpDisabled" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; display: none;">
							<img id="imgSpinDown" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; cursor: pointer;">
							<img id="imgSpinDownDisabled" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; display: none;">
						</div>	
					</td>
				</tr>
				<tr>
					<td colspan="2"></td>
				</tr>
			</table> --%>
		</div>
	</div>
	<div id="printPolicyCertButtonsDiv" align="center">
		<input type="button" class="button" style="width: 90px;" id="btnCancelCert" value="Cancel">
		<input type="button" class="button" style="width: 90px;" id="btnPrintCert" value="Print">
	</div>
</div>

<script type="text/javascript">
	initializeAll();
	initializeAccordion();
	
	var lov = 0;
	
	$("txtLineCd").focus();
	
	$("printPOC").hide();
	$("lblPrintPOC").hide();
	
	function togglePrintFields(destination) {
		if ($("selDestination").value == "printer") {
			$("printerName").disabled = false;
			$("txtNoOfCopies").disabled = false;
			$("printerName").addClassName("required");
			$("txtNoOfCopies").addClassName("required");
			$("imgSpinUp").show();
			$("imgSpinDown").show();
			$("imgSpinUpDisabled").hide();
			$("imgSpinDownDisabled").hide();
			$("txtNoOfCopies").value = 1;
			$("rdoPdf").disable();
			$("rdoExcel").disable();
		} else {
			if ($("selDestination").value == "file") {
				$("rdoPdf").enable();
				$("rdoExcel").enable();
			} else {	
				$("rdoPdf").disable();
				$("rdoExcel").disable();
			}
			$("printerName").value = "";
			$("txtNoOfCopies").value = "";
			$("printerName").disabled = true;
			$("txtNoOfCopies").disabled = true;
			$("printerName").removeClassName("required");
			$("txtNoOfCopies").removeClassName("required");
			$("imgSpinUp").hide();
			$("imgSpinDown").hide();
			$("imgSpinUpDisabled").show();
			$("imgSpinDownDisabled").show();
		}
	}

	//insertPrinterNames();
	$("printerName").selectedIndex = 0;
	$("printerName").disable();
	$("txtNoOfCopies").selectedIndex = 0;
	$("txtNoOfCopies").disable();
	$("selDestination").value = "screen"; // added by: Nica 08.17.2012 - set default destination

	$("selDestination").observe("change", function(){
		togglePrintFields($("selDestination").value);
	});

	$("query").observe("click", function(){
		$$("input[name='capsField']").each(function(field){
			field.readOnly = false;
			field.value = "";
		});
		$$("input[name='intField']").each(function(field){
			field.readOnly = false;
			field.value = "";
		});

		$("parNo").readOnly = true;
		$("assdName").readOnly = true;
		$("policyId").value	   = "";
		$("lineCd").value	   = "";
		$("menulineCd").value  = "";
		lov = 0;
		$("txtLineCd").focus();
		
		$("printPOC").hide();
		$("lblPrintPOC").hide();

		/* $("searchForPolicy").observe("click", function(){
			if ("" != $F("txtLineCd")){
				showPolicyNoLOV();
				//showPolicyListingForCertPrinting();
			} else {
				customShowMessageBox("Required fields must be entered.", "I", "txtLineCd");
			}
		}); */
	});
	
	$("reloadForm").observe("click", function(){
		$$("input[name='capsField']").each(function(field){
			field.readOnly = false;
			field.value = "";
		});
		$$("input[name='intField']").each(function(field){
			field.readOnly = false;
			field.value = "";
		});

		$("parNo").readOnly = true;
		$("assdName").readOnly = true;
		$("policyId").value	   = "";
		$("lineCd").value	   = "";
		$("menulineCd").value  = "";
		lov = 0;
		$("txtLineCd").focus();
		/* $("searchForPolicy").observe("click", function(){
			if ("" != $F("txtLineCd")){
				showPolicyNoLOV();
				//showPolicyListingForCertPrinting();
			} else {
				customShowMessageBox("Required fields must be entered.", "I", "txtLineCd");
			}
		}); */
	});
	
	$("parExit").observe("click", function () {
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});

	$("btnCancelCert").observe("click", function () {
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		/* $$("input[name='capsField']").each(function(field){
			field.readOnly = false;
			field.value = "";
		});
		$$("input[name='intField']").each(function(field){
			field.readOnly = false;
			field.value = "";
		});

		$("parNo").readOnly = true;
		$("assdName").readOnly = true;
		$("policyId").value	   = "";
		$("lineCd").value	   = "";
		$("menulineCd").value  = "";
		lov = 0; */
	});

	$("btnPrintCert").observe("click", function(){
		if(validateFieldsBeforePrint()){
			showNotice("Preparing to print certificates...");
			printCertificateReport();
		}
	});

	function validateFieldsBeforePrint(){
		var result = true;
		if($("txtLineCd").value == "" || $("txtSublineCd").value == "" || $("txtIssCd").value == "" ||
		   $("txtIssueYy").value == "" || $("txtPolSeqNo").value == "" || $("txtRenewNo").value == "" ||
		   $("lineCd").value == "" || $("parNo").value == "" || $("assdName").value == ""){
		 	result = false;
			showWaitingMessageBox("Enter query for policy certificate to be printed.", imgMessage.INFO, function(){
				//fireEvent($("searchForPolicy"), "click");
			});
		} else if (($("printerName").selectedIndex == 0) && ($("selDestination").value == "printer")){
			result = false;
			showWaitingMessageBox("Printer Name is required.", imgMessage.INFO, function(){
				$("printerName").focus();
			});
		}
		if(($("selDestination").value == "printer") && $("txtNoOfCopies").value == ""){
			result = false;
			showWaitingMessageBox("No. of Copies is required.", imgMessage.INFO, function(){
				$("txtNoOfCopies").focus();
			});
		}
		if(($("selDestination").value == "printer")&&($("txtNoOfCopies").value > 100 || $("txtNoOfCopies").value < 1)){
			result = false;
			showWaitingMessageBox("Invalid No. of Copies. Value should be in range 1-100.", imgMessage.INFO, function(){
				$("txtNoOfCopies").focus();
			});
		}
		return result;
	}

	function printCertificateReport(){
		try {
			//var reportId = getCertificateReportId($F("lineCd"), $F("menulineCd"));
			var reportId = getCertReportId($F("lineCd"), $F("menulineCd"));
			var destination	= $("selDestination").value;
			var printerName = $("printerName").value;
			var noOfCopies 	= $("txtNoOfCopies").value;
			if ($("printPOC").checked){
				reportId = reportId+"_OTH";
			}
			var content = contextPath+"/PrintPolicyCertificatesController?action=printPolicyCertificate"
				+"&noOfCopies="+noOfCopies+"&printerName="+printerName+"&policyId="+$F("policyId")
				+"&reportId="+reportId;
			
			if ("screen" == destination) {//if screen
				//window.open(content, "", "location=0, toolbar=0, menubar=0, fullscreen=1");
				showPdfReport(content, "Policy Certificate"); // andrew - 12.12.2011
				hideNotice("");
				
			} else if ($F("selDestination") == "printer") {
				new Ajax.Request(content, {
					parameters : {
						noOfCopies : $F("txtNoOfCopies"),
						printerName : $F("printerName")
					},
					onCreate : showNotice("Processing, please wait..."),
					onComplete : function(response) {
						hideNotice();
						if (checkErrorOnResponse(response)) {

						}
					}
				});
			}else if ("file" == $F("selDestination")) {
				new Ajax.Request(content, {
					parameters : {
						destination : "file",
						fileType : $("rdoPdf").checked ? "PDF" : "XLS"
					},
					onCreate : showNotice("Generating report, please wait..."),
					onComplete : function(response) {
						hideNotice();
						if (checkErrorOnResponse(response)) {
							copyFileToLocal(response);
						}
					}
				});
			}else if ("local" == $F("selDestination")) {
				new Ajax.Request(content, {
					parameters : {
						destination : "local"
					},
					onComplete : function(response) {
						hideNotice();
						if (checkErrorOnResponse(response)) {
							var message = printToLocalPrinter(response.responseText);
							if (message != "SUCCESS") {
								showMessageBox(message, imgMessage.ERROR);
							}
						}
					}
				});
			}
		} catch(e){
			showErrorMessage("printCertificateReport", e);
		}
	}

/* 	function getCertificateReportId(lineCd, menuLineCd){
		if(lineCd == "MC" || menuLineCd == "MC"){
			return "MOTORCAR";
		} else if(lineCd == "FI" || menuLineCd == "FI"){
			 return "FIRE";
		} else if(lineCd == "MN" || menuLineCd == "MN"){
			return "MARINE_CARGO";	
		} else if(lineCd == "AV" || menuLineCd == "AV"){
			return "AVIATION";		
		} else if(lineCd == "CA" || menuLineCd == "CA"){
			return "CASUALTY";		
		} else if(lineCd == "MH" || menuLineCd == "MH"){
			return "MARINE_HULL";	
		} else if(lineCd == "AC" || menuLineCd == "AC"){
			return "ACCIDENT";	
		} else if(lineCd == "EN" || menuLineCd == "EN") {	
			return "ENGINEERING";
		} else if(lineCd == "SU" || menuLineCd == "SU"){
			return "SURETYSHIP";
		} 
	} */
	
	function getCertReportId(lineCd, menuLineCd){
		if(lineCd == "MC" || menuLineCd == "MC"){
			return "MC_CERT";
		} else if(lineCd == "FI" || menuLineCd == "FI"){
			return "FI_CERT";
		} else if(lineCd == "MN" || menuLineCd == "MN"){
			return "MN_CERT";	
		} else if(lineCd == "AV" || menuLineCd == "AV"){
			return "AV_CERT";		
		} else if(lineCd == "CA" || menuLineCd == "CA"){
			return "CA_CERT";		
		} else if(lineCd == "MH" || menuLineCd == "MH"){
			return "MH_CERT";	
		} else if(lineCd == "AC" || menuLineCd == "AC"){
			return "AC_CERT";	
		} else if(lineCd == "EN" || menuLineCd == "EN") {	
			return "EN_CERT";
		} else if(lineCd == "SU" || menuLineCd == "SU"){
			return "SU_CERT";
		} 
	}
	
	
	
	//added from policyCertDetails.jsp
	$("searchForPolicy").observe("click", function(){
		if ("" != $F("txtLineCd")){
			if(lov == 0){
				showPolicyNoLOV();
			}
		} else {
			showWaitingMessageBox("Line code is required.", imgMessage.INFO, function(){
					$("txtLineCd").focus();
				});
		}
	});

	$$("input[name='capsField']").each(function(field){
		field.observe("keyup", function(){
			field.value = field.value.toUpperCase();
		});
	});

	$("txtPolSeqNo").observe("blur", function(){
		if ($F("txtPolSeqNo")!= ""){
			if (!(isNaN($F("txtPolSeqNo")))){
				$("txtPolSeqNo").value = parseInt($F("txtPolSeqNo")).toPaddedString(7);
			}
		}
	});

	$("txtRenewNo").observe("blur", function(){
		if ($F("txtRenewNo")!= ""){
			if (!(isNaN($F("txtRenewNo")))){
				$("txtRenewNo").value = parseInt($F("txtRenewNo")).toPaddedString(2);
			}
		}
	});
	
	$("txtEndtYy").observe("blur", function(){
		if ($F("txtEndtYy")!= ""){
			if (!(isNaN($F("txtEndtYy")))){
				$("txtEndtYy").value = parseInt($F("txtEndtYy")).toPaddedString(2);
			}
		}
	});
	
	$("txtEndtSeqNo").observe("blur", function(){
		if ($F("txtEndtSeqNo")!= ""){
			if (!(isNaN($F("txtEndtSeqNo")))){
				$("txtEndtSeqNo").value = parseInt($F("txtEndtSeqNo")).toPaddedString(6);
			}
		}
	});
	
	$("txtIssueYy").observe("blur", function(){
		if ($F("txtIssueYy")!= ""){
			if (!(isNaN($F("txtIssueYy")))){
				$("txtIssueYy").value = parseInt($F("txtIssueYy")).toPaddedString(2);
			}
		}
	});
	
	//txtNoOfCopies
	$("imgSpinUp").observe("click", function() {
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		if (no != 100){
			$("txtNoOfCopies").value = no + 1;
		}
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
	
	$("txtNoOfCopies").observe("change", function() {
	});
	
	function showOtherCert(lineCd){
		 new Ajax.Request(contextPath + "/GIUTS023BeneficiaryInfoController", {
			parameters : {
				action			: 'showOtherCert',
				lineCd			: lineCd
			},
			asynchronous : false,
			onComplete : function(response){
				if(checkErrorOnResponse(response)){
					otherCertTag = response.responseText; 
					if (otherCertTag == "Y"){
						$("printPOC").show();		
						$("lblPrintPOC").show();
					}else{
						$("printPOC").hide();
						$("lblPrintPOC").hide();
					}
	 			}
					
			}
		}); 
	}
	
	function showPolicyNoLOV(){
		try{
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getCertPolicyTableGridListing",
					lineCd : $F("txtLineCd"),
					sublineCd : $F("txtSublineCd"),
					issCd : $F("txtIssCd"),
					issueYy : $F("txtIssueYy"),
					polSeqNo : $F("txtPolSeqNo"),
					renewNo : $F("txtRenewNo"),
					endtLineCd : $F("txtCLineCd"),
					endtSublineCd : $F("txtCSublineCd"),
					endtIssCd : $F("txtCEndtIssCd"),
					endtYy : $F("txtEndtYy"),
					endtSeqNo : $F("txtEndtSeqNo"),
					assdName : $F("assdName"),
					ajax : "1"
				},
				title: "Policy Listing",
				height: 390,
				width: 850,
				columnModel: [
		 			{
						id : "policyNo",
						title: "Policy No.",
						width: '170px',
						filterOption: true					
					},
					{
						id : "endtNo",
						title: "Endt No.",
						width: '160px',
						filterOption: true					
					},				
					{
						id : "parNo",
						title: "Par No.",
						width: '150px',
						filterOption: true			
					},
					{
						id : "assdName",
						title: "Assured Name",
						width: '350px',
						filterOption: true
					}
				],
				autoSelectOneRecord : true, 
				draggable: true,
				onSelect: function(pol) {
					if(pol != undefined){
						$("txtLineCd").value 	= unescapeHTML2(pol.lineCd);
						$("txtSublineCd").value = unescapeHTML2(pol.sublineCd); 
						$("txtIssCd").value 	= unescapeHTML2(pol.issCd);
						$("txtIssueYy").value 	= formatNumberDigits(pol.issueYy, 2);
						$("txtPolSeqNo").value 	= formatNumberDigits(pol.polSeqNo, 7);
						$("txtRenewNo").value 	= formatNumberDigits(pol.renewNo, 2);
						if (nvl(pol.endtSeqNo, "0") != "0"){
							$("txtCLineCd").value 		= unescapeHTML2(pol.lineCd);
							$("txtCSublineCd").value 	= unescapeHTML2(pol.sublineCd);
							$("txtCEndtIssCd").value 	= unescapeHTML2(pol.endtIssCd);
							$("txtEndtYy").value 		= formatNumberDigits(pol.endtYy, 2);
							$("txtEndtSeqNo").value 	= formatNumberDigits(pol.endtSeqNo, 6);
						}
						$("assdName").value 	= unescapeHTML2(pol.assdName);
						$("parNo").value 		= unescapeHTML2(pol.parNo);
						$("policyId").value		= pol.policyId;
						$("lineCd").value 		= unescapeHTML2(pol.lineCd);
						$("menulineCd").value 	= unescapeHTML2(pol.menulineCd);
						
						$$("input[name='capsField']").each(function(field){
							field.readOnly = true;
						});
						$$("input[name='intField']").each(function(field){
							field.readOnly = true;
						});
						showOtherCert($F("txtLineCd"));
						lov = 1;
					}
				},
				onCancel: function(){
					$("txtLineCd").focus();
		  		}
			});
		}catch(e){
			showErrorMessage("showPolicyNoLOV",e);
		}
	}
</script>
