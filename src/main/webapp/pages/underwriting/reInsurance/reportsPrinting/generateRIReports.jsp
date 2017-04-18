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

<div id="generateRiReportsMainDiv" name="generateRiReportsMainDiv">
	<div id="uwReportsMenuDiv" name="uwReportsMenuDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="btnExit" name="btnExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Generate Reinsurance Reports</label>
			<span class="refreshers" style="margin-top: 0;">
				<label name="gro" style="margin-left: 5px;">Hide</label>
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
		</div>
	</div>
	<div id="groDiv" name="groDiv" class="sectionDiv" style="margin-bottom: 10px;">
		<input type="hidden">
		<div id="tabComponentsDiv1" class="tabComponents1" style="float: left;">
			<ul>
				<li class="tab1 selectedTab1"><a id="binder">Binder</a></li>
				<li class="tab1"><a id="outstanding">Outstanding</a></li>
				<li class="tab1"><a id="assumed">Assumed</a></li>
				<li class="tab1"><a id="expiryList">Expiry List</a></li>
				<li class="tab1"><a id="expiryPPW">Expiry PPW</a></li>
				<li class="tab1"><a id="facultativeRI">Facul RI</a></li>
				<li class="tab1"><a id="outwardRI">Outward RI</a></li>
				<li class="tab1"><a id="treaty">Treaty</a></li>
				<li class="tab1"><a id="riListing">RI Listing</a></li>
				<li class="tab1"><a id="renewal">Renewal</a></li>
				<li class="tab1"><a id="reciprocity">Reciprocity</a></li>
			</ul>
		</div>
		<div class="tabBorderBottom1"></div>
	
		<input id="defaultCurrencyGIRIS051" type="hidden" value="${defaultCurrency}">
		<input id="allowSetPerilAmtForPrnt" type="hidden" value="${allowSetPerilAmtForPrnt}">
			
		 <div id="riReportsSubDiv" name="riReportsSubDiv"> 
			<div class="" style="float: left; padding: 15px 0 15px 0">
				<div id="txtFieldsDiv" name="txtFieldsDiv" class="sectionDiv" style="margin-left: 15px; padding-top: 5px; width: 607px; height: 230px;" align="center">
					<input id="txtRemarksSw" name="txtRemarksSw" type="hidden">
					<table align="left" style="margin: 30px 0px 0px 40px;">
						<tr>
							<td class="rightAligned" id="lblBinderNo" name="lblBinderNo">Binder No.</td>
							<td>
								<div id="binderNoDiv" style="border: 1px solid gray; width: 60px; height: 20px; float: left; margin-right: 7px;">
									<input id="txtLineCd" name="txtLineCd" class="leftAligned upper" type="text" maxlength="2" style="border: none; float: left; width: 30px; height: 13px; margin: 0px;" value=""/>
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineCd" name="searchLineCd" alt="Go" style="float: right;"/>
								</div>
								<input id="txtBinderYy" name="txtBinderYy" type="text" style="width: 50px; height: 14px; margin: 0px; text-align: right;" value="" maxlength="2" class="integerNoNegativeUnformattedNoComma" errorMsg="Field must be of form 09."/>
								<input id="txtBinderSeqNo" name="txtBinderSeqNo" type="text" style=" width: 90px; height: 14px; margin: 0px; text-align: right;" value="" maxlength="5" class="integerNoNegativeUnformattedNoComma" errorMsg="Field must be of form 09999."/>
							</td>
						</tr>
						<tr>
							<td class="rightAligned" id="lblAttention" name="lblAttention">Attention</td>
							<td><input id="txtAttention" name="txtAttention" type="text" maxlength="50" style="float: left; width: 400px; height: 14px; margin: 0px;" value=""/></td>
						</tr>
						<tr>
							<td class="rightAligned" id="lblRemarks" name="lblRemarks">Remarks</td>
							<td><input id="txtRemarks" name="txtRemarks" type="text" maxlength="4000" style="float: left; width: 400px; height: 14px; margin: 0px;" value=""/></td>
						</tr>
						<tr>
							<td class="rightAligned" id="lblBinderRemarks1" name="lblBinderRemarks1">Binder Remarks</td>
							<td><input id="txtBinderRemarks1" name="txtBinderRemarks1" type="text" maxlength="100" style="float: left; width: 400px; height: 14px; margin: 0px;" value=""/></td>
						</tr>
						<tr>
							<td></td>
							<td><input id="txtBinderRemarks2" name="txtBinderRemarks2" type="text" maxlength="100" style="float: left; width: 400px; height: 14px; margin: 0px;" value=""/></td>
						</tr>
						<tr>
							<td></td>
							<td><input id="txtBinderRemarks3" name="txtBinderRemarks3" type="text" maxlength="100" style="float: left; width: 400px; height: 14px; margin: 0px;" value=""/></td>
						</tr>
					</table>			
				</div>
				<div id="checkBoxDiv" name="checkBoxDiv" class="sectionDiv" style="padding-top: 5px; width: 280px; height: 230px;" align="center">
					<table align="left" style="margin: 25px 0px 0px 35px;">
						<tr>
							<td style="padding-bottom: 8px;">
								<input id="chkNbtGrp" name="chkNbtGrp" type="checkbox" readonly="readonly" value="N" />&nbsp&nbsp Group Binder
								<select id="selPrintOption" name="selPrintOption" style="width: 90px; height: 22px;" hidden="hidden"> <!-- temp hide by robert SR 20380 09.21.15 -->
									<option value="summary">Summary</option>
									<option value="detailed">Detailed</option>
								</select>
							</td>
						</tr><tr>
							<td style="padding-bottom: 8px;"><input id="chkReversed" name="chkReversed" type="checkbox" readonly="readonly" value="N"/>&nbsp&nbsp Reversed</td>
						</tr><tr>
							<td style="padding-bottom: 8px;"><input id="chkReplaced" name="chkReplaced" type="checkbox" value="N"/>&nbsp&nbsp Replacement</td>
						</tr><tr>
							<td style="padding-bottom: 8px;"><input id="chkNegated" name="chkNegated" type="checkbox" value="N"/>&nbsp&nbsp Negated</td>
						</tr><tr>
							<td style="padding-bottom: 8px;"><input id="chkLocalCurrency" name="chkLocalCurrency" type="checkbox" value="N"/>&nbsp&nbsp In Local Currency</td>
						</tr><tr>
							<td style="padding-bottom: 8px;"><input id="chkPrintAgreement" name="chkPrintAgreement" type="checkbox" value="N"/>&nbsp&nbsp RI Agreement</td>
						</tr><tr>
							<td  id="chkPrNtcTD" style="padding-bottom: 8px;"><input id="chkPrRiBndRnwlNtc" name="chkPrRiBndRnwlNtc" type="checkbox" value="N"/>&nbsp&nbsp RI Bond Renewal Notice</td>
						</tr>
					</table>
				</div>
				<div class="sectionDiv" id="printDialogFormDiv" style="margin-left: 15px; margin-bottom: 5px; float: left; width: 890px; height: 191px;" >
					<table style="float: left; padding: 40px 0 0 220px;">
						<tr>
							<td class="rightAligned">Destination</td>
							<td class="leftAligned">
								<select id="selDestination" style="width: 200px;">
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
								<input value="EXCEL" title="Excel" type="radio" id="excelRB" name="fileRG" style="margin: 2px 4px 4px 50px; float: left;" disabled="disabled"><label for="excelRB" style="margin: 2px 0 4px 0">Excel</label>
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
					<table style="float: left; padding-top: 50px;">
						<tr><td><input type="button" class="button" style="width: 100px; margin-left: 15px; " id="btnPrint" name="btnPrint" value="Print"></td></tr>
						<tr><td><input type="button" class="button" style="width: 100px; margin-left: 15px; " id="btnCancel" name="btnCancel" value="Cancel"></td></tr>
					</table>
					<table id="perilDtlsTbl" style="float: left; padding: 50px 0px 0px 0px;">
						<tr><td><input id="btnTaxDtls" name="btnTaxDtls" class="button" type="button" style="height: 25px; width: 120px; margin-left: 15px; font-size: 12px;" value="Peril Details"></td></tr>
						<tr><td style="padding: 4px 0px 0px 2px;"><input id="chkPrntPerilDet" name="chkPrntPerilDet" type="checkbox" style="margin-left: 15px;">&nbsp Print Peril Details</td></tr>
						<tr><td><input id="txtFrame" name="txtFrame" type="text" maxlength="30" style="height: 20px; width: 113px; margin-left: 15px;" value=""></td></tr>
					</table>
				</div>
			</div>
		 </div> 
	</div>	
</div>


<script type="text/javascript">
	setDocumentTitle("Generate Reinsurance Reports");
	setModuleId("GIRIS051");
	initializeAccordion();
	initializeTabs();
	initializeAll();
	makeInputFieldUpperCase();
	var reports = [];
	
	//$("perilDtlsTbl").show();
	observeReloadForm("reloadForm", showGenerateRIReportsPage);
	
	observeAccessibleModule(accessType.MENU, "GIRIS051", "binder", function(){
		setCurrentTab("binder");
		showGenerateRIReportsPage();
	});	
	observeAccessibleModule(accessType.MENU, "GIRIS051", "outstanding", function(){
		setCurrentTab("outstanding");
		showGenerateRIReportsTabPage("outstandingTab");
	});
	observeAccessibleModule(accessType.MENU, "GIRIS051", "assumed", function(){
		setCurrentTab("assumed");
		showGenerateRIReportsTabPage("assumedTab");
	});
	observeAccessibleModule(accessType.MENU, "GIRIS051", "expiryList", function(){
		setCurrentTab("expiryList");
		showGenerateRIReportsTabPage("expiryListTab");
	});

	observeAccessibleModule(accessType.MENU, "GIRIS051", "expiryPPW", function(){
		setCurrentTab("expiryPPW");
		showGenerateRIReportsTabPage("expiryPPWTab");
	});
	observeAccessibleModule(accessType.MENU, "GIRIS051", "facultativeRI", function(){
		setCurrentTab("facultativeRI");
		showGenerateRIReportsTabPage("facultativeRITab");
	});
	
	observeAccessibleModule(accessType.MENU, "GIRIS051", "outwardRI", function(){
		setCurrentTab("outwardRI");
		showGenerateRIReportsTabPage("outwardRITab");
	});
	
	observeAccessibleModule(accessType.MENU, "GIRIS051", "treaty", function(){
		setCurrentTab("treaty");
		showGenerateRIReportsTabPage("treatyTab");
	});
	
	observeAccessibleModule(accessType.MENU, "GIRIS051", "riListing", function(){
		setCurrentTab("riListing");
		showGenerateRIReportsTabPage("riListingTab");
	});
	
	observeAccessibleModule(accessType.MENU, "GIRIS051", "renewal", function(){
		setCurrentTab("renewal");
		showGenerateRIReportsTabPage("renewalTab");
	});
	
	observeAccessibleModule(accessType.MENU, "GIRIS051", "reciprocity", function(){
		setCurrentTab("reciprocity");
		showGenerateRIReportsTabPage("reciprocityTab");
	});
	
	$("txtLineCd").observe("blur", function(){
		if($F("txtLineCd") != "") {
			validateRIReportsBinderLineCd();
		}else {
			$("chkPrNtcTD").hide();
			$("chkPrRiBndRnwlNtc").value = "N";
		}
		onBlurBinderNoFields('Y');
	});
	
	$("txtBinderYy").observe("blur", function(){
		if ($F("txtBinderYy") != ""){
			$("txtBinderYy").value = formatNumberDigits($F("txtBinderYy"), 2);
		}
		onBlurBinderNoFields('N');
	});
	
	$("txtBinderSeqNo").observe("blur", function(){
		if ($F("txtBinderSeqNo") != ""){
			$("txtBinderSeqNo").value = formatNumberDigits($F("txtBinderSeqNo"), 5);
		}
		onBlurBinderNoFields('N');
	});
	
	$("chkReplaced").observe("click", function(){
		if ($("chkReplaced").checked){
			$("chkReplaced").value = "Y";
		}else{
			$("chkReplaced").value = "N";
		}
		
		if($("chkReplaced").value == 'Y'){
			new Ajax.Request(contextPath + "/GIRIGenerateRIReportsController",{
				method: "GET",
				parameters: {
					action: 	 "checkRiBinderReplaced",
					lineCd: 	 $F("txtLineCd"),
					binderYy: 	 $F("txtBinderYy"),
					binderSeqNo: $F("txtBinderSeqNo")
				},
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if (checkErrorOnResponse(response)){
						if (response.responseText == null){
							$("chkReplaced").value = "N";
							$("chkReplaced").checked = false;
							showMessageBox("This binder has not been replaced.", imgMessage.INFO);
						}
					}
				}
			});
		}
	});
	
	$("chkNegated").observe("click", function(){
		if ($("chkNegated").checked){
			$("chkNegated").value = "Y";
		}else{
			$("chkNegated").value = "N";
		}
		
		if($("chkNegated").value == 'N'){
			checkRiBinderNegated();
		}
	});
	
	$("chkLocalCurrency").observe("click", function(){
		if ($("chkNegated").checked){
			$("chkNegated").value = "Y";
		}else{
			$("chkNegated").value = "N";
		}
		
		if($("chkNegated").value == 'N'){
			checkRiBinderNegated();
		}

		if($("chkLocalCurrency").checked){
			$("chkLocalCurrency").value = "Y";
		}else{
			$("chkLocalCurrency").value = "N";
		}
	});
		
	$("chkPrintAgreement").observe("click", function(){
		if($("chkPrintAgreement").checked){
			$("chkPrintAgreement").value = "Y";
		}else {
			$("chkPrintAgreement").value = "N";
			
		}
		
		if(objRiReports.riSignatory.nbtTag == 0){
			genericObjOverlay = Overlay.show(contextPath + "/GIRIGenerateRIReportsController", {
				urlContent: true,
				urlParameters: { action: "showRISignatoryPopup",
								 ajax: "1"},
				title: "Reinsurer Signatory",
				height: 170,
				width: 450,
				draggable: true
			});
		}else {
			objRiReports.riSignatory.nbtTag = 0;
		}
	});
	
	
	$("searchLineCd").observe("click", function(){
		showRiReportsBinderLineLOV();
	});
	
	$("btnCancel").observe("click", function(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
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
		if(objRiReports.giriGroupBinder == null && objRiReports.giriBinder == null){
			showMessageBox("Binder "+$F("txtLineCd")+"-"+$F("txtBinderYy")+"-"+$F("txtBinderSeqNo")+" does not exist.", imgMessage.INFO);
		}else if($F("selDestination") == "PRINTER" && ($("selPrinter").value == "" || $("txtNoOfCopies").value == "")){
			showMessageBox("Printer Name and No. of Copies are required.", "I");
		}else if($F("selDestination") == "PRINTER" && (isNaN($F("txtNoOfCopies")) || $F("txtNoOfCopies") <= 0)){
			showMessageBox("Invalid number of copies.", "I");
		}else{
			if($("chkPrintAgreement").value == "Y" && ($F("txtLineCd") == "SU" || getLineCd($F("txtLineCd")) == "SU")){
				getRIAgreement();
			}
			
			if (objRiReports.giriGroupBinder != null) { 
			   $("chkNbtGrp").value = "Y";
			   $("chkNbtGrp").checked = true;
			   getGiriGroupBinder();
			}else if (objRiReports.giriBinder != null){
				$("chkNbtGrp").value = "N";
				$("chkNbtGrp").checked = false;
			   getGiriBinder();
			}else {
				showMessageBox("Binder "+$F("txtLineCd")+"-"+$F("txtBinderYy")+"-"+$F("txtBinderSeqNo")+" does not exist.", imgMessage.INFO);
			}
							
			checkGIRIR123version();
		}
	});
		
	$("btnTaxDtls").observe("click", function(){
		if (objRiReports.giriBinder != null){
			genericObjOverlay = Overlay.show(contextPath + "/GIRIGenerateRIReportsController", {
				urlContent: true,
				urlParameters: { 
					action: 	 "getGIRIBinderPerilDtls",
					lineCd: 	 $F("txtLineCd"),
					binderYy:	 $F("txtBinderYy"),
					binderSeqNo: $F("txtBinderSeqNo")
				},
				title: "Peril Details",
				height: 350,
				width: 800,
				draggable: true
			});
		}else {
			showMessageBox("Binder "+$F("txtLineCd")+"-"+$F("txtBinderYy")+"-"+$F("txtBinderSeqNo")+" does not exist.", imgMessage.INFO);
		}
	});
	
	$("btnExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	
	
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
	
	function setCurrentTab(id){
		$$("div.tabComponents1 a").each(function(a){
			if(a.id == id) {
				$(id).up("li").addClassName("selectedTab1");					
			}else{
				a.up("li").removeClassName("selectedTab1");	
			}	
		});
	}
	
	function onBlurBinderNoFields(isLineCd){		
		if ($F("txtLineCd") != "" && $F("txtBinderYy") != "" &&  $F("txtBinderSeqNo") != "") {
			$("txtAttention").readonly = false;
			$("chkNbtGrp").disabled = true;    
			$("chkNegated").disabled = true; 
			$("chkReplaced").disabled = true;  
			checkRiBinderRecord(isLineCd);
		}
		
		if($F("txtBinderSeqNo") != ""){
			if($F("txtLineCd") != "" && $F("txtBinderYy") != ""){
				validateBndRnwl();
			}else {
				$("chkPrRiBndRnwlNtc").disabled = true;
				$("chkPrRiBndRnwlNtc").value = "N";
			}
		}else {
			$("chkPrRiBndRnwlNtc").disabled = true;
			$("chkPrRiBndRnwlNtc").value = "N";
		}		
		
	}
	
	function checkRiBinderNegated(){
		try{
			new Ajax.Request(contextPath + "/GIRIGenerateRIReportsController",{
				method: "GET",
				parameters: {
					action: 	 "checkRiBinderNegated",
					lineCd: 	 $F("txtLineCd"),
					binderYy: 	 $F("txtBinderYy"),
					binderSeqNo: $F("txtBinderSeqNo")
				},
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if (checkErrorOnResponse(response)){
						if (response.responseText == 1){
							$("chkNegated").value = "Y";
							$("chkNegated").checked = true;
							showMessageBox("This binder is already negated.", imgMessage.INFO);
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("checkRiBinderNegated", e);
		}
	}
	
	function validateBndRnwl(){
		try {
			new Ajax.Request(contextPath+"/GIRIGenerateRIReportsController", {
				method: "GET",
				parameters: {
					action: 	 "validateBndRnwl",
					lineCd: 	 $F("txtLineCd"),
					binderYy:	 $F("txtBinderYy"),
					binderSeqNo: $F("txtBinderSeqNo")
				},
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if (checkErrorOnResponse(response)){
						var obj = JSON.parse(response.responseText);
						
						if (obj.valid == 'Y'){
							$("chkPrTiBndRnwlNtc").disabled = false;
							$("chkPrTiBndRnwlNtc").value = 'Y';
							objRiReports.oldFnlBinderId = obj.oldFnlBinderId;
							objRiReports.fnlBinderId = obj.fnlBinderId;
						}else {
							$("chkPrTiBndRnwlNtc").disabled = true;
							$("chkPrTiBndRnwlNtc").value = 'N';
						}
					}
				}
			});	
		}catch (e){
			showErrorMessage("validateBndRnwl", e);
		}
	}
	
	function checkRiBinderRecord(isLineCd){
		try{
			new Ajax.Request(contextPath+"/GIRIGenerateRIReportsController",{
				method: "GET",
				parameters: {
					action: 	 "checkRiBinderRecord",
					lineCd: 	 $F("txtLineCd"),
					binderYy:	 $F("txtBinderYy"),
					binderSeqNo: $F("txtBinderSeqNo"),
					isLineCd:	 isLineCd,
					remarksSw:	 $F("txtRemarksSw"),
					localCurr:	 objRiReports.local_curr
				},
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var obj = JSON.parse(response.responseText); 
						$("chkReversed").value = obj.reversed;
						$("chkReplaced").value = obj.replaced;
						$("chkNbtGrp").value = obj.nbtGrp;
						$("chkNegated").value = obj.negated;
						$("txtAttention").value = unescapeHTML2(obj.attention); //added unescapeHTML2 to entry fields by carlo SR 23906 02-23-2017
						$("txtRemarks").value = unescapeHTML2(obj.remarks);
						$("txtBinderRemarks1").value = unescapeHTML2(obj.bndrRemarks1);
						$("txtBinderRemarks2").value = unescapeHTML2(obj.bndrRemarks2);
						$("txtBinderRemarks3").value = unescapeHTML2(obj.bndrRemarks3);
						objRiReports.giriBinder = obj.giriBinder;
						objRiReports.giriGroupBinder = obj.giriGroupBinder;
						
						//toggle checkboxes
						if ($("chkReversed").value == 'Y'){
							$("chkReversed").checked = true;
						}else {
							$("chkReversed").checked = false;	
						}
						
						if ($("chkReplaced").value == 'Y'){
							$("chkReplaced").checked = true;
						}else {
							$("chkReplaced").checked = false;	
						}
						
						if ($("chkNegated").value == 'Y'){
							$("chkNegated").checked = true;
						}else {
							$("chkNegated").checked = false;	
						}
						
						if ($("chkNbtGrp").value == 'Y'){
							$("chkNbtGrp").checked = true;
						}else {
							$("chkNbtGrp").checked = false;	
						}
						
						//toggle txtAttention read-only property
						/*if (obj.readOnlyAttn == 'Y'){
							$("txtAttention").readOnly = true;
						}else {
							$("txtAttention").readOnly = false;
						}*/
						
						//enable/disable checkbox
						if(obj.enableReplaced == 'Y'){
							$("chkReplaced").disabled = false;
						}else {
							$("chkReplaced").disabled = true;
						}
						
						if(obj.enableNegated == 'Y'){
							$("chkNegated").disabled = false;
						}else {
							$("chkNegated").disabled = true;
						}
						
						if(obj.enableLocalCurr == 'Y'){
							$("chkLocalCurrency").disabled = false;
						}else {
							$("chkLocalCurrency").disabled = true;
						}
						
						//show/hide print option
						if(obj.visiblePrntOpt == 'Y'){
							$("selPrintOption").show();
						}
					}
				}
			});
		}catch (e){
			showErrorMessage("checkRiBinderRecord", e);
		}
	}
	
	function getRIAgreement(){
		try{
			//print GIRIR121 Populate_RI_Agreement_<version> for lineCd SU 
			new Ajax.Request(contextPath+"/GIRIGenerateRIReportsController",{
				method: "GET",
				parameters: {
					action: 				"getGIRIR121FnlBinderId",
					lineCd:					$F("txtLineCd"),
					binderYy:				$F("txtBinderYy"),
					binderSeqNo:			$F("txtBinderSeqNo")
					
				},
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var obj = JSON.parse(response.responseText);
						
						var content = contextPath+"/UWReinsuranceReportPrintController?action=printUWRiBinderReport&reportId=GIRIR121&fnlBinderId="+obj.fnlBinderId+
									  "&riAgrmntBndName="+encodeURIComponent(objRiReports.riSignatory.name)+"&riAgrmntBndDesignation="+encodeURIComponent(objRiReports.riSignatory.designation)+
									  "&riAgrmntBndAttest="+encodeURIComponent(objRiReports.riSignatory.attest)+"&printOption="+$F("selPrintOption")+
						  			  "&noOfCopies="+$F("txtNoOfCopies")+"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination");
				
						//showPdfReport(content, "Reinsurance Agreement");
						reports.push({reportUrl: content, reportTitle: "Reinsurance Agreement"});
					}
				}
			});
		}catch(e){
			showErrorMessage("getRIAgreement", e);
		}
	}
	
	function checkGIRIR123version(){
		try{
			//get GIRIR123 version
			new Ajax.Request(contextPath+"/GIRIGenerateRIReportsController?action=getReportVersion&=GIRIR123",{
				method: "GET",
				asynchronous: true,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var obj = JSON.parse(response.responseText);
						
						//print GIRIR123 for TPISC
						if($("chkPrRiBndRnwlNtc").value == "Y" && obj.version == "TPISC"){
							//reports.push({reportUrl: content, reportTitle: ""});
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("checkGIRIR123version", e);
		}
	}	
	
	function printUWRiBinderReport(reportId, lineCd, binderYy, binderSeqNo){
		try{
			var url = contextPath+"/UWReinsuranceReportPrintController?action=printUWRiBinderReport&reportId="+reportId+
		      			  "&lineCd="+lineCd+"&binderYy="+binderYy+"&binderSeqNo="+binderSeqNo+"&printOption="+$F("selPrintOption")+
			  			  "&noOfCopies="+$F("txtNoOfCopies")+"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination");
			reports.push({reportUrl: url, reportTitle: "Reinsurance Binder Report"});
	
			if($F("selDestination") == "SCREEN"){
				showMultiPdfReport(reports);
			} else {
				for (var i=0; i < reports.length; i++){
					var content = reports[i].reportUrl;
					if("FILE" == $F("selDestination")){
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
				}
			}
		
			reports = [];
			
		}catch (e){
			showErrorMessage("printUWRiBinderReport", e);
		}
	}
	
	function getGiriBinder(){
		try{
			var reportId = "";
			
			$("chkReversed").value = ($F("chkReversed") == null) ? "N" : $F("chkReversed");
			$("chkReplaced").value = ($F("chkReplaced") == null) ? "N" : $F("chkReplaced");
			$("chkNegated").value = ($F("chkNegated") == null) ? "N" : $F("chkNegated");
			$("chkLocalCurrency").value = ($F("chkLocalCurrency") == null) ? "N" : $F("chkLocalCurrency");
			
			
			if (($("chkReversed").value == "N" && $("chkReplaced").value == "N" && $("chkNegated").value == "N") || 
				($("chkReversed").value == "Y" && $("chkReplaced").value == "N" && $("chkNegated").value == "N")){
				if ($("chkLocalCurrency").value == "N"){
					reportId = "GIRIR001";
				}else {
					reportId = "GIRIR001C";
				}
			}else if ($("chkReversed").value == "N" && $("chkReplaced").value == "N" && $("chkNegated").value == "Y"){
				reportId = "GIRIR001B";
			}else if (($("chkReversed").value == "N" && $("chkReplaced").value == "Y" && $("chkNegated").value == "N") || 
					($("chkReversed").value == "Y" && $("chkReplaced").value == "Y" && $("chkNegated").value == "N")){
				reportId = "GIRIR001";
			}else if (($("chkReversed").value == "N" && $("chkReplaced").value == "N" && $("chkNegated").value == "Y") || 
					($("chkReversed").value == "Y" && $("chkReplaced").value == "N" && $("chkNegated").value == "Y") || 
					($("chkReversed").value == "N" && $("chkReplaced").value == "Y" && $("chkNegated").value == "Y") || 
					($("chkReversed").value == "Y" && $("chkReplaced").value == "Y" && $("chkNegated").value == "Y")){
				reportId = "GIRIR001B";
			}

			//update GIRI Binder remarks, print_date_ printed_cnt
			new Ajax.Request(contextPath+"/GIRIGenerateRIReportsController",{
				method: "GET",
				parameters: {
					action: 		"updateGIRIBinder",
					lineCd:			$F("txtLineCd"),
					binderYy:		$F("txtBinderYy"),
					binderSeqNo:	$F("txtBinderSeqNo"),
					attention:		$F("txtAttention"),
					remarks:		$F("txtRemarks"),
					bndrRemarks1:	$F("txtBinderRemarks1"),
					bndrRemarks2:	$F("txtBinderRemarks2"),
					bndrRemarks3:	$F("txtBinderRemarks3"),
					reversed:		$("chkReversed").value,
					replaced:		$("chkReplaced").value,
					negated:		$("chkNegated").value
				},
				evalScripts: true,
				asynchrounous: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var obj = JSON.parse(response.responseText);
						printUWRiBinderReport(reportId, obj.lineCd, obj.binderYy, obj.binderSeqNo);						
					}
				}
			});
			
		}catch(e){
			showErrorMessage("getGiriBinder", e);
		}
	}
	
	function getGiriGroupBinder(){
		try{
			var reportId = "";
			
			$("chkReversed").value = ($F("chkReversed") == null) ? "N" : $F("chkReversed");
			$("chkReplaced").value = ($F("chkReplaced") == null) ? "N" : $F("chkReplaced");			
			
			if (($("chkReversed").value == "N" && $("chkReplaced").value == "N") || 
				($("chkReversed").value == "N" && $("chkReplaced").value == "Y")){
				reportId = "GIRIR035";
			}else if (($("chkReversed").value == "Y" && $("chkReplaced").value == "N") || 
					($("chkReversed").value == "Y" && $("chkReplaced").value == "Y")){
				reportId = "GIRIR038";
			}
			
			//update GIRI Group Binder remarks, print_date_ printed_cnt
			new Ajax.Request(contextPath+"/GIRIGenerateRIReportsController",{
				method: "GET",
				parameters: {
					action: 		"updateGIRIGroupBinder",
					lineCd:			$F("txtLineCd"),
					binderYy:		$F("txtBinderYy"),
					binderSeqNo:	$F("txtBinderSeqNo"),
					remarks:		$F("txtRemarks"),
					bndrRemarks1:	$F("txtBinderRemarks1"),
					bndrRemarks2:	$F("txtBinderRemarks2"),
					bndrRemarks3:	$F("txtBinderRemarks3"),
					reversed:		$("chkReversed").value,
					replaced:		$("chkReplaced").value
				},
				evalScripts: true,
				asynchrounous: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var obj = JSON.parse(response.responseText);
						
						/*=================================================================================================*/
						/***************** Just remove the condition if all the reports are converted already ***************/
						
						if(reportId == "GIRIR001" || reportId == "GIRIR001B" || reportId == "GIRIR035"){
							printUWRiBinderReport(reportId, obj.lineCd, obj.binderYy, obj.binderSeqNo);
						}else {
							showMessageBox("Report " + reportId + " is not yet existing.", "I");
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("getGiriGroupBinder", e);
		}
	}
	
	toggleRequiredFields("screen");
</script>