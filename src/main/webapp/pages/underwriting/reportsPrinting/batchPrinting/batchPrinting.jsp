 <%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="batchPrintingMainDiv" name="batchPrintingMainDiv" style="float: left; width: 100%;">
	<div id="batchPrintingGridDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="batchPrintingExit">Exit</a></li>
				</ul>
			</div>
		</div> 
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Batch Printing</label>
			<span class="refreshers" style="margin-top: 0;">
				<label name="gro" style="margin-left: 5px;">Hide</label>
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
		</div>
	</div>
	<div id="showDetails">	
		<div class="sectionDiv" style="height: 483px;">
			<div style="padding-left: 10px; vertical-align: top; float: left;">
				<table style="width: 250px;">
					<tr>
						<td align="center" style="height: 20px;">Document</td>
					</tr>
					<tr>
						<td>
							<div class="sectionDiv" id="batchPrintingDocType" align="left" style="padding: 5px; height: 390px; border-color: rgb(128,128,128);">
								<c:forEach var="d" items="${docTypeList}">
									<label id="${d.docType}_label" name="docDesc" style="float: left; font-size: 11px; text-transform: uppercase; width: 223px;" for="${d.docType}" onmouseover="this.setStyle({backgroundColor : '#8497bc', color : '#fff'})" onmouseout="this.setStyle({backgroundColor : '#FFFFFF', color : '#456179'})" onclick="this.setStyle({backgroundColor : '#4a6278', color : '#fff'})">${d.docType}</label>
									<input id="${d.docType}" name="docType" type="checkbox" value="${d.docType}" style="float: right; visibility: hidden;"/></br>
								</c:forEach>
							</div>
						</td>
					</tr>
				</table>
			</div>
			
			<div style="padding-right: 10px; vertical-align: top; float: right;">
				<table style="width: 635px;">
					<tr>
						<td colspan="2" align="center" style="height: 20px;">Parameters</td>
					</tr>
					<tr>
						<td colspan="2">
							<div class="sectionDiv" id="batchPrintingParameters" align="left" style="border-color: rgb(168,168,168); height: 243px; padding-top: 10px;">
								<table align="center">
									<tr>
										<td class="rightAligned">Assured</td>
										<td class="leftAligned">
											<div id="assuredDiv" style="border: 1px solid gray; width: 450px; height: 20px; margin:0 5px 0 0;">
												<input id="txtAssured" name="txtAssured" type="text" maxlength="500" class="upper" style="border: none; float: left; width: 425px; height: 14px; margin: 0px;" value="" lastValidValue="" tabindex="309"/>
												<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchAssuredLOV" name="searchAssuredLOV" alt="Go" style="float: right;" tabindex="310"/>
											</div>
										</td>
									</tr>
									<tr>
										<td class="rightAligned">RI / Cedant</td>
										<td class="leftAligned">
											<div id="cedantDiv" style="border: 1px solid gray; width: 450px; height: 20px; margin:0 5px 0 0;">
												<input id="txtCedant" name="txtCedant" type="text" maxlength="50" class="upper" style="border: none; float: left; width: 425px; height: 14px; margin: 0px;" value="" lastValidValue="" tabindex="309"/>
												<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchCedantLOV" name="searchCedantLOV" alt="Go" style="float: right;" tabindex="310"/>
											</div>
										</td>
									</tr>
									<tr>
										<td class="rightAligned">Line</td>
										<td class="leftAligned">
											<div id="lineDiv" style="border: 1px solid gray; width: 450px; height: 20px; margin:0 5px 0 0;">
												<input id="txtLine" name="txtLine" type="text" maxlength="20" class="upper" style="border: none; float: left; width: 425px; height: 14px; margin: 0px;" value="" lastValidValue="" tabindex="309"/>
												<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineLOV" name="searchLineLOV" alt="Go" style="float: right;" tabindex="310"/>
											</div>
										</td>
									</tr>
									<tr>
										<td class="rightAligned">Subline</td>
										<td class="leftAligned">
											<div class="required" id="sublineDiv" style="border: 1px solid gray; width: 450px; height: 20px; margin:0 5px 0 0;">
												<input id="txtSubline" name="txtSubline" type="text" maxlength="30" class="upper" style="border: none; float: left; width: 425px; height: 14px; margin: 0px;" value="" lastValidValue="" tabindex="309"/>
												<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchSublineLOV" name="searchSublineLOV" alt="Go" style="float: right;" tabindex="310"/>
											</div>
										</td>
									</tr>
									<tr>
										<td class="rightAligned">Issue Source</td>
										<td class="leftAligned">
											<div id="issueDiv" style="border: 1px solid gray; width: 450px; height: 20px; margin:0 5px 0 0;">
												<input id="txtIssue" name="txtIssue" type="text" maxlength="20" class="upper" style="border: none; float: left; width: 425px; height: 14px; margin: 0px;" value="" lastValidValue="" tabindex="309"/>
												<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIssueLOV" name="searchIssueLOV" alt="Go" style="float: right;" tabindex="310"/>
											</div>
										</td>
									</tr>
									<tr>
										<td class="rightAligned">User</td>
										<td class="leftAligned">
											<div id="userDiv" style="border: 1px solid gray; width: 450px; height: 20px; margin:0 5px 0 0;">
												<input id="txtUser" name="txtUser" type="text" maxlength="20" class="upper" style="border: none; float: left; width: 425px; height: 14px; margin: 0px;" value="" lastValidValue="" tabindex="309"/>
												<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchUserLOV" name="searchUserLOV" alt="Go" style="float: right;" tabindex="310"/>
											</div>
										</td>
									</tr>
								</table>
		
								<table align="right" style="padding-right: 47px; padding-top: 10px;">
									<tr>
										<td class="rightAligned">Sequence No.</td>
										<td class="leftAligned"><input type="text" name="txtSequence" id="txtStartSeq" value="" style="width: 160px; text-align: right;" class="integerNoNegativeUnformattedNoComma" maxlength="7"/></td>
										<td align="center" width="50px;">to</td>
										<td class="leftAligned"><input type="text" name="txtSequence" id="txtEndSeq" value="" style="width: 160px; text-align: right;" class="integerNoNegativeUnformattedNoComma" maxlength="7"/></td>
									</tr>
								</table>
			
								<table align="right" style="padding-right: 47px; padding-top: 5px;">	
									<tr>
						 				<td class="rightAligned" style="padding-top: 4px;">
											<select id="selCoverNote" style="width: 160px;">
												<option value="INCEPTION DATE">Inception Date</option>
												<option value="EFFECTIVITY DATE">Effectivity Date</option>
												<option value="EXPIRY DATE">Expiry Date</option>
												<option value="ISSUE DATE">Issue Date</option>
											</select>
											<select id="selEndt" style="width: 160px;">
												<option value="INCEPTION DATE">Inception Date</option>
												<option value="EFFECTIVITY DATE">Effectivity Date</option>
												<option value="EXPIRY DATE">Expiry Date</option>
												<option value="ISSUE DATE">Issue Date</option>
												<option value="ENDT EXPIRY DATE">Endt Expiry Date</option>
											</select>
											<select id="selCoc" style="width: 160px;">
												<option value="INCEPTION DATE">Inception Date</option>
												<option value="EFFECTIVITY DATE">Effectivity Date</option>
												<option value="EXPIRY DATE">Expiry Date</option>
												<option value="ISSUE DATE">Issue Date</option>
												<option value="COC ISSUE DATE">COC Issue Date</option>
											</select>
											<select id="selPreliminaryBinder" style="width: 160px;">
												<option value="BINDER DATE">Binder Date</option>
											</select>
											<select id="selBinder" style="width: 160px;">
												<option value="BINDER DATE">Binder Date</option>
												<option value="REVERSE DATE">Reverse Date</option>
											</select>
										</td>
										<td>
											<div id="fromDateDiv" style="float: left; border: 1px solid gray; width: 166px; height: 19px;">
												<input id="txtFromDate" name="fromTo" readonly="readonly" type="text" class="leftAligned date" maxlength="10" style="border: none; float: left; width: 141px; height: 13px; margin: 0px;" value="" tabindex="303"/>
												<img id="imgFromDate" alt="imgFromDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtFromDate'),this, null);" tabindex="304"/>
											</div>
										</td>			
										<td align="center" width="50px;">to</td>
										<td class="leftAligned">
											<div id="fromDateDiv" style="float: left; border: 1px solid gray; width: 166px; height: 19px;">
												<input id="txtToDate" name="fromTo" readonly="readonly" type="text" class="leftAligned date" maxlength="10" style="border: none; float: left; width: 141px; height: 13px; margin: 0px;" value="" tabindex="303"/>
												<img id="imgToDate" alt="imgToDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtToDate'),this, null);" tabindex="304"/>
											</div>
										</td>		
									</tr>
								</table>
							</div>
						</td>
					</tr>
				<tr>
					<td width="65%">
						<div class="sectionDiv" id="batchPrintingPrint" align="left" style="border-color: rgb(168,168,168); height: 140px; ">
							<table align="center" style="padding: 15px 0px 0px 0px; margin-top: 2px;">
								<tr>
									<td class="rightAligned">Destination</td>
									<td class="leftAligned">
										<select id="selDestination" style="width: 200px;" tabindex="215">
											<!-- <option value="screen">Screen</option> --> <!-- commented out by MarkS 11.4.2016 SR-5788 -->
											<option value="printer">Printer</option>
											<option value="file">File</option>
											<option value="local">Local Printer</option>
										</select>
									</td>
								</tr>
								<tr>
									<td></td>
									<td>
										<input value="PDF" title="PDF" type="radio" id="rdoPdf" name="rdoFileType" style="margin: 2px 5px 4px 40px; float: left;" checked="checked" disabled="disabled" tabindex="216"><label for="rdoPdf" style="margin: 2px 0 4px 0">PDF</label>
										<!-- <input value="EXCEL" title="Excel" type="radio" id="rdoExcel" name="rdoFileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled" tabindex="217"><label for="rdoExcel" style="margin: 2px 0 4px 0">Excel</label> --> <!-- commented out by MarkS 11.4.2016 SR-5788 --> 
									</td>
								</tr>
								<tr>
									<td class="rightAligned">Printer</td>
									<td class="leftAligned">
										<select id="selPrinter" style="width: 200px;" tabindex="218">
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
										<input type="text" id="txtNoOfCopies" maxlength="3" style="float: left; text-align: right; width: 175px;" class="integerNoNegativeUnformattedNoComma" lastValidValue="" tabindex="219"/>
										<div style="float: left; width: 15px;">
											<img id="imgSpinUp" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; cursor: pointer;"/>
											<img id="imgSpinUpDisabled" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; display: none;"/>
											<img id="imgSpinDown" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; cursor: pointer;"/>
											<img id="imgSpinDownDisabled" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; display: none;"/>
										</div>					
									</td>
								</tr>
							</table>
						</div>
					</td>
					<td style="padding-left: 4px;">
						<div class="sectionDiv" id="batchPrintingPrintOption" align="left" style="border-color: rgb(168,168,168);  height: 140px; ">
							<table align="center" cellspacing="10" style="padding-top: 10px;">
								<tr>
									<td>
										<div>
											<input id="rdoUnprinted" name="printOption" type="radio" style="float: left;" value="U" checked="checked" tabindex="202"/>
											<label style="margin-left: 7px;" for="rdoUnprinted">Unprinted</label>
										</div>
									</td>
								</tr>
								<tr>
									<td>
										<div>
											<input id="rdoPrinted" name="printOption" type="radio" style="float: left;" value="P" tabindex="202"/>
											<label style="margin-left: 7px;" for="rdoPrinted">Printed</label>
										</div>
									</td>
								</tr>
								<tr>
									<td>
										<div>
											<input id="rdoBoth" name="printOption" type="radio" style="float: left;" value="B" tabindex="202"/>
											<label style="margin-left: 7px;" for="rdoBoth">Both</label>
										</div>
									</td>
								</tr>
							</table>
						</div>
					</td>
				</tr>
			</table>
		</div>
			<div class="buttonsDiv" >
				<input type="button" class="button" id="btnPrint" name="btnPrint" value="Print" style="width: 125px;" tabindex="218"/>
			</div>
		</div>
	</div>
</div>
<input type="hidden" id="hidMsg" name="hidMsg"/>
<input type="hidden" id="hidLineCd" name="hidLineCd"/>
<input type="hidden" id="hidIssCd" name="hidIssCd"/>

<script type="text/javascript">
	initializeAll();
	initializeAccordion();
	makeInputFieldUpperCase();
	setModuleId("GIPIS170");
	setDocumentTitle("Batch Printing");
	var label = "";
	var docType = "";
	variablePRi = '${paramsOut.variableRi}';
	variableLcMc = '${paramsOut.variableLcMc}';
	variablevScLto = '${paramsOut.variableScLto}';
	variableLcSu = '${paramsOut.variableLcSu}';
	vBond = '${paramsOut.vBond}';
	vMotor = '${paramsOut.vMotor}';
	onPageLoad();
	var output = "";
	var printGroup = "U";
	reports = [];
	fileMessage = "";
	lineCd = "";
	issCd = "";
	okPrint = false;
	
	function onPageLoad(){
		$("txtAssured").focus();
		docType = "BINDER";
		label = docType;
		hideDateOptions();
		initializeGIPIS170Fields();
		toggleFormDefaultFields();
		$("BINDER_label").setStyle({backgroundColor : '#4a6278', color : '#fff'});
		$("BINDER_label").removeAttribute("onmouseover");
		$("BINDER_label").removeAttribute("onmouseout");
		togglePrintFields("screen");
	}
	
	function hideDateOptions(){
		$("selCoverNote").value = "INCEPTION DATE";
		$("selCoc").value = "INCEPTION DATE";
		$("selEndt").value = "INCEPTION DATE";
		$("selPreliminaryBinder").value = "BINDER DATE";
		$("selBinder").value = "BINDER DATE	";
		$("selCoverNote").hide();
		$("selCoc").hide();
		$("selPreliminaryBinder").hide();
		$("selEndt").hide();
		$("selBinder").hide();
	}
	
	function initializeGIPIS170Fields(){
		$("txtAssured").value = "";
		$("txtCedant").value = "";
		$("txtLine").value = "";
		$("txtSubline").value = "";
		$("txtIssue").value = "";
		$("txtUser").value = "";
		$("txtAssured").disabled = false;
		$("txtCedant").disabled = false;
		$("txtLine").disabled = false;
		$("txtSubline").disabled = false;
		$("txtIssue").disabled = false;
		$("txtUser").disabled = false;
		enableSearch("searchAssuredLOV");
		enableSearch("searchCedantLOV");
		enableSearch("searchLineLOV");
		enableSearch("searchSublineLOV");
		enableSearch("searchIssueLOV");
		enableSearch("searchUserLOV");
		$("txtStartSeq").value = "";
		$("txtEndSeq").value = "";
		$("txtFromDate").value = "";
		$("txtToDate").value = "";
	}
	
	function cedantNotApplicable(){
		$("txtCedant").value = "NOT APPLICABLE";
		$("txtCedant").disabled = true;
		disableSearch("searchCedantLOV");
	}
	
	function userNotApplicable(){
		$("txtUser").value = "NOT APPLICABLE";
		$("txtUser").disabled = true;
		disableSearch("searchUserLOV");
	}
	
	function sublineDisable(){
		$("txtSubline").value = "";
		$("txtSubline").disabled = true;
		disableSearch("searchSublineLOV");
	}
	
	function lineDisable(){
		$("txtLine").disabled = true;
		disableSearch("searchLineLOV");
	}
	
	function resetLastValidValues(){
		$("txtLine").setAttribute("lastValidValue", "");
		$("txtSubline").setAttribute("lastValidValue", "");
		$("txtUser").setAttribute("lastValidValue", "");
		$("txtCedant").setAttribute("lastValidValue", "");
		$("txtAssured").setAttribute("lastValidValue", "");
		$("txtIssue").setAttribute("lastValidValue", "");
	}
	
	function toggleFormDefaultFields(){
		resetLastValidValues();
		$("lineDiv").removeClassName("required");
		$("txtLine").removeClassName("required");
		$("sublineDiv").removeClassName("required");
		$("txtSubline").removeClassName("required");
		var allUserSw = '${allUserSw}';
		if(allUserSw != "Y"){
			$("txtUser").value = '${currentUser}';
			$("txtUser").disabled = true;
		}
		if(docType == "ONE-PAGE QUOTATION" || docType == "DETAILED QUOTATION"){
			cedantNotApplicable();
			userNotApplicable();
			$("selCoverNote").show();
		}else if(docType == "COVER NOTE"){
			cedantNotApplicable();
			userNotApplicable();
			$("selCoverNote").show();
		}else if (docType == "POLICY" || docType == "BOND POLICY" || docType == "RENEWAL CERTIFICATE" || docType == "BOND R.CERTIFICATE" || docType == "RENEWAL CERTIFICATE" || docType == "BOND R.CERTIFICATE" ){
			if(docType == "POLICY"){
				cedantNotApplicable();
				$("lineDiv").addClassName("required");//to make the line code required if document type is POLICY OR ENDORESEMENT
				$("txtLine").addClassName("required");	
			}else if(docType == "BOND POLICY" || docType == "BOND R.CERTIFICATE"){
				if(vBond != ""){
					$("txtLine").value = vBond;
					lineCd = variableLcSu;
				}
				if(docType == "BOND POLICY"){
					$("sublineDiv").addClassName("required");
					$("txtSubline").addClassName("required");
				}
				cedantNotApplicable();
				userNotApplicable();
				lineDisable();
			}else{
				userNotApplicable();
			}
			$("selCoverNote").show();
		}else if (docType == "ENDORSEMENT" || docType == "BOND ENDORSEMENT"){
			if(docType == "BOND ENDORSEMENT"){
				if(vBond != ""){
					$("txtLine").value = vBond;
					lineCd = variableLcSu;
				}
				userNotApplicable();
				lineDisable();
			}else{
				$("lineDiv").addClassName("required");//to make the line code required if document type is POLICY OR ENDORESEMENT
				$("txtLine").addClassName("required");	
			}
			cedantNotApplicable();
			$("selEndt").show();
		}else if (docType == "INVOICE" || docType == "BOND INVOICE"){
			cedantNotApplicable();
			if(docType == "BOND INVOICE"){
				if(vBond != ""){
					$("txtLine").value = vBond;
					lineCd = variableLcSu;
				}
				lineDisable();
			}
			$("selCoverNote").show();
		}else if (docType == "RI INVOICE"){
			$("txtIssue").disabled = true;
			disableSearch("searchIssueLOV");
			issCd = variablePRi;
			$("txtIssue").value = "REINSURANCE";
			$("selCoverNote").show();
		}else if (docType == "COC(LTO)" || docType == "COC(NON-LTO)"){
			if(vMotor != ""){
				$("txtLine").value = vMotor;
				lineCd = variableLcMc;
			}
			cedantNotApplicable();
			lineDisable();
			if(docType == "COC(LTO)"){
				$("txtSubline").value = "";
				$("txtSubline").disabled = true;
				disableSearch("searchSublineLOV");
			}
			$("selCoc").show();
		}else if (docType == "PRELIMINARY BINDER"){
			userNotApplicable();
			$("selPreliminaryBinder").show();
		}else if (docType == "BINDER" || docType == "REVERSAL BINDER"){
			userNotApplicable();
			$("selBinder").show();
		}
	}
	
	function togglePrintFields(destination) {
		if (destination == "printer") {
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
			/* $("rdoExcel").disable(); */ <!-- commented out by MarkS 11.4.2016 SR-5788 -->
		} else {
			if (destination == "file") {
				$("rdoPdf").enable();
				/* $("rdoExcel").enable(); */ <!-- commented out by MarkS 11.4.2016 SR-5788 -->
			} else {
				$("rdoPdf").disable();
				/* $("rdoExcel").disable(); */ <!-- commented out by MarkS 11.4.2016 SR-5788 -->
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
	
	$("selDestination").observe("change", function() {
		var destination = $F("selDestination");
		togglePrintFields(destination);
	});
	
	
	$("imgSpinUp").observe("click", function(){
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		if(no < 100){
			$("txtNoOfCopies").value = no + 1;
			$("txtNoOfCopies").setAttribute("lastValidValue", $F("txtNoOfCopies"));
		}
	});
	
	$("imgSpinDown").observe("click", function(){
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		if(no > 1){
			$("txtNoOfCopies").value = no - 1;
			$("txtNoOfCopies").setAttribute("lastValidValue", $F("txtNoOfCopies"));
		}
	});

	$("txtNoOfCopies").observe("change", function(){
		if(isNaN($F("txtNoOfCopies")) || $F("txtNoOfCopies") <= 0 || $F("txtNoOfCopies") > 100){
			showWaitingMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "I", function(){
				$("txtNoOfCopies").value = $("txtNoOfCopies").readAttribute("lastValidValue");
			});			
		}else{
			$("txtNoOfCopies").setAttribute("lastValidValue", $F("txtNoOfCopies"));
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
	
	$$("input[name='docType']").each(function(btn) {
		btn.observe("click", function() {
			if(output == "notValid"){
				output = "";
			}
			if(output == ""){
				if(btn.checked == true){
					label = btn.value + "_label";
					$$("input[name='docType']").each(function(chk) {
						chk.checked = false;
						$(chk.value + "_label").setStyle({backgroundColor : '#FFFFFF', color : '#456179'});
						$(chk.value + "_label").setAttribute("onmouseover", "this.setStyle({backgroundColor : '#8497bc', color : '#fff'})");
						$(chk.value + "_label").setAttribute("onmouseout", "this.setStyle({backgroundColor : '#FFFFFF', color : '#456179'})");
					}); 
					btn.checked = true;
					
					$(label).removeAttribute("onmouseover");
					$(label).removeAttribute("onmouseout");
					$(label).setStyle({backgroundColor : '#4a6278', color : '#fff'});
					docType = btn.value;
					 
					hideDateOptions();
					initializeGIPIS170Fields();
					toggleFormDefaultFields();
				}else{
					$("sublineDiv").removeClassName("required");
					$("txtSubline").removeClassName("required");
					$("lineDiv").removeClassName("required");
					$("txtLine").removeClassName("required");	
					$(label).setAttribute("onmouseover", "this.setStyle({backgroundColor : '#8497bc', color : '#fff'})");
					$(label).setAttribute("onmouseout", "this.setStyle({backgroundColor : '#FFFFFF', color : '#456179'})");
					$(label).setStyle({backgroundColor : '#FFFFFF', color : '#456179'});
					docType = "";
					initializeGIPIS170Fields();
				}
			}else{
				return false;
			}
		}); 
	}); 
	
	//User Lov
	function showUserLOV(isIconClicked) {
		try {
			var searchString = isIconClicked ? "%" : ($F("txtUser").trim() == "" ? "%" : $F("txtUser"));
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGipis170UserLov",
					search : searchString + "%"
				},
				title: "List of Users",
				width : 410,
				height : 386,
				autoSelectOneRecord : true,
				filterText : searchString,
				columnModel : [ {
					id : "userId",
					title : "User Id",
					width : '80px'
				},
				{
					id : "username",
					title : "User Name",
					width : '310px'
				}],
				draggable : true,
				onSelect : function(row) {
					$("txtUser").value = unescapeHTML2(row.userId);
					$("txtUser").setAttribute("lastValidValue", $F("txtUser"));
				},
				onUndefinedRow : function() {
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtUser");
					//$("txtUser").value = "";
					$("txtUser").value = $("txtUser").readAttribute("lastValidValue");
					output = "notValid";
				},
				onCancel : function() {
					//$("txtUser").value = "";
					$("txtUser").value = $("txtUser").readAttribute("lastValidValue");
					$("txtUser").focus();
					output = "notValid";
				}
			});
		} catch (e) {
			showErrorMessage("showUserLOV", e);
		}
	}
	 
	//Assd Lov
	function showAssdLOV(isIconClicked) {
		try {	
			var searchString = isIconClicked ? "%" : ($F("txtAssured").trim() == "" ? "%" : $F("txtAssured"));
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGipis170AssdLov",
					search : searchString + "%"
				},
				title: "List of Assured",
				width : 410,
				height : 386,
				autoSelectOneRecord : true,
				filterText : searchString,
				columnModel : [
				{
					id : "assdName",
					title : "Assured Name",
					width : '310px'
				},
				{
					id : "assdNo",
					title : "Assured No",
					width : '80px'
				}],
				draggable : true,
				onSelect : function(row) {
					$("txtAssured").value = unescapeHTML2(row.assdName);
					$("txtAssured").setAttribute("lastValidValue", $F("txtAssured"));
					output = "";
				},
				onUndefinedRow : function() {
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtAssured");
					//$("txtAssured").value = "";
					$("txtAssured").value = $("txtAssured").readAttribute("lastValidValue");
					output = "notValid";
				},
				onCancel : function() {
					//$("txtAssured").value = "";
					$("txtAssured").value = $("txtAssured").readAttribute("lastValidValue");
					$("txtAssured").focus();
					output = "notValid";
				}
			});
		} catch (e) {
			showErrorMessage("showAssdLOV", e);
		}
		
	}
	
	//Cedant Lov
	function showCedantLOV(isIconClicked) {
		try {
			var searchString = isIconClicked ? "%" : ($F("txtCedant").trim() == "" ? "%" : $F("txtCedant"));
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGipis170RiLov",
					search : searchString + "%"
				},
				title: "List of RI/ Cedant",
				width : 410,
				height : 386,
				autoSelectOneRecord : true,
				filterText : searchString,
				columnModel : [
				{
					id : "riName",
					title : "RI/ Cedant",
					width : '390px'
				},
				{
					id : "riCd",
					width : '0px',
					visible : false
				}],
				draggable : true,
				onSelect : function(row) {
					$("txtCedant").value = unescapeHTML2(row.riName);
					$("txtCedant").setAttribute("lastValidValue", $F("txtCedant"));
				},
				onUndefinedRow : function() {
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtCedant");
					//$("txtCedant").value = "";
					$("txtCedant").value = $("txtCedant").readAttribute("lastValidValue");
					output = "notValid";
				},
				onCancel : function() {
					//$("txtCedant").value = "";
					$("txtCedant").value = $("txtCedant").readAttribute("lastValidValue");
					$("txtCedant").focus();
					output = "notValid";
				}
			});
		} catch (e) {
			showErrorMessage("showCedantLOV", e);
		}
	}
	
	
	//Issue Lov
	function showIssLOV(isIconClicked) {
		try {
			var searchString = isIconClicked ? "%" : ($F("txtIssue").trim() == "" ? "%" : $F("txtIssue"));
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGipis170IssLov",
					search : searchString,
					lineCd : lineCd
				},
				title: "List of Issue Sources",
				width : 410,
				height : 386,
				autoSelectOneRecord : true,
				filterText : searchString,
				columnModel : [
				{
					id : "issName",
					title : "Issue Source",
					width : '310px'
				},
				{
					id : "issCd",
					title : "Issue Code",
					width : '80px'
				}],
				draggable : true,
				onSelect : function(row) {
					$("txtIssue").value = unescapeHTML2(row.issName);
					issCd = row.issCd;
					$("txtIssue").setAttribute("lastValidValue", $F("txtIssue"));
					$("hidIssCd").value = row.issCd;
				},
				onUndefinedRow : function() {
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtIssue");
					//$("txtIssue").value = "";
					//issCd = "";
					$("txtIssue").value = $("txtIssue").readAttribute("lastValidValue");
					issCd = $F("hidIssCd");
					output = "notValid";
				},
				onCancel : function() {
					//$("txtIssue").value = "";
					//issCd = "";
					$("txtIssue").value = $("txtIssue").readAttribute("lastValidValue");
					issCd = $F("hidIssCd");
					$("txtIssue").focus();
					output = "notValid";
				}
			});
		} catch (e) {
			showErrorMessage("showIssLOV", e);
		}
	}
	 
	//Line Lov
	function showLineLOV(isIconClicked) {
		try {
			var searchString = isIconClicked ? "%" : ($F("txtLine").trim() == "" ? "%" : $F("txtLine"));
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGipis170LineLov",
					search : searchString,
					issCd : issCd
				},
				title: "List of Lines",
				width : 410,
				height : 386,
				autoSelectOneRecord : true,
				filterText : searchString,
				columnModel : [
				{
					id : "lineName",
					title : "Line Name",
					width : '310px'
				},
				{
					id : "lineCd",
					title : "Line Code",
					width : '80px'
				}],
				draggable : true,
				onSelect : function(row) {
					$("txtLine").value = unescapeHTML2(row.lineName);
					lineCd = row.lineCd;
					$("txtLine").setAttribute("lastValidValue", $F("txtLine"));
					$("hidLineCd").value = row.lineCd;
					$("txtSubline").value = "";
					$("txtSubline").setAttribute("lastValidValue", "");
				},
				onUndefinedRow : function() {
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtLine");
					//$("txtLine").value = "";
					//lineCd = "";
					$("txtLine").value = $("txtLine").readAttribute("lastValidValue");
					lineCd = $F("hidLineCd");
					output = "notValid";
				},
				onCancel : function() {
					//$("txtLine").value = "";
					//lineCd = "";
					$("txtLine").value = $("txtLine").readAttribute("lastValidValue");
					lineCd = $F("hidLineCd");
					$("txtLine").focus();
					output = "notValid";
				}
			});
		} catch (e) {
			showErrorMessage("showLineLOV", e);
		}
	}
	 
	//Line Lov
	function showLineFilteredLOV(isIconClicked) {
		try {
			var searchString = isIconClicked ? "%" : ($F("txtLine").trim() == "" ? "%" : $F("txtLine"));
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGipis170LineFilteredLov",
					search : searchString,
					issCd : issCd,
					documentType : docType
				},
				title: "List of Lines", 
				width : 410,
				height : 386,
				autoSelectOneRecord : true,
				filterText : searchString,
				columnModel : [
				{
					id : "lineName",
					title : "Line Name",
					width : '310px'
				},
				{
					id : "lineCd",
					title : "Line Code",
					width : '80px'
				}],
				draggable : true,
				onSelect : function(row) {
					$("txtLine").value = unescapeHTML2(row.lineName);
					lineCd = row.lineCd;
					$("txtLine").setAttribute("lastValidValue", $F("txtLine"));
					$("hidLineCd").value = row.lineCd;
					$("txtSubline").value = "";
					$("txtSubline").setAttribute("lastValidValue", "");
				},
				onUndefinedRow : function() {
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtLine");
					//$("txtLine").value = "";
					//lineCd = "";
					$("txtLine").value = $("txtLine").readAttribute("lastValidValue");
					lineCd = $F("hidLineCd");
					output = "notValid";
				},
				onCancel : function() {
					//$("txtLine").value = "";
					//lineCd = "";
					$("txtLine").value = $("txtLine").readAttribute("lastValidValue");
					lineCd = $F("hidLineCd");
					$("txtLine").focus();
					output = "notValid";
				}
			});
		} catch (e) {
			showErrorMessage("showLineFilteredLOV", e);
		}
	}
	 
	//Line Lov
	function showLineSuLOV(isIconClicked) {
		try {
			var searchString = isIconClicked ? "%" : ($F("txtLine").trim() == "" ? "%" : $F("txtLine"));
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGipis170LineSuLov",
					search : searchString,
					issCd : issCd,
					documentType : docType
				},
				title: "List of Lines",
				width : 410,
				height : 386,
				autoSelectOneRecord : true,
				filterText : searchString,
				columnModel : [
				{
					id : "lineName",
					title : "Line Name",
					width : '310px'
				},
				{
					id : "lineCd",
					title : "Line Code",
					width : '80px'
				}],
				draggable : true,
				onSelect : function(row) {
					$("txtLine").value = unescapeHTML2(row.lineName);
					lineCd = row.lineCd;
					$("txtLine").setAttribute("lastValidValue", $F("txtLine"));
					$("hidLineCd").value = row.lineCd;
					$("txtSubline").value = "";
					$("txtSubline").setAttribute("lastValidValue", "");
				},
				onUndefinedRow : function() {
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtLine");
					//$("txtLine").value = "";
					//lineCd = "";
					$("txtLine").value = $("txtLine").readAttribute("lastValidValue");
					lineCd = $F("hidLineCd");
					output = "notValid";
				},
				onCancel : function() {
					//$("txtLine").value = "";
					//lineCd = "";
					$("txtLine").value = $("txtLine").readAttribute("lastValidValue");
					lineCd = $F("hidLineCd");
					$("txtLine").focus();
					output = "notValid";
				}
			});
		} catch (e) {
			showErrorMessage("showLineSuLOV", e);
		}
	}
	
	//Subline Lov
	function showSublineLOV(isIconClicked) {
		try {
			var searchString = isIconClicked ? "%" : ($F("txtSubline").trim() == "" ? "%" : $F("txtSubline"));
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGipis170SublineLov",
					search : searchString,
					lineCd : lineCd
				},
				title: "List of Sublines",
				width : 410,
				height : 386,
				autoSelectOneRecord : true,
				filterText : searchString,
				columnModel : [
				{
					id : "sublineName",
					title : "Subline Name",
					width : '310px'
				},
				{
					id : "sublineCd",
					title : "Subline Code",
					width : '80px'
				}],
				draggable : true,
				onSelect : function(row) {
					$("txtSubline").value = unescapeHTML2(row.sublineName);
					$("txtSubline").setAttribute("lastValidValue", $F("txtSubline"));
				},
				onUndefinedRow : function() {
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtSubline");
					//$("txtSubline").value = "";
					$("txtSubline").value = $("txtSubline").readAttribute("lastValidValue");
					output = "notValid";
				},
				onCancel : function() {
					//$("txtSubline").value = "";
					$("txtSubline").value = $("txtSubline").readAttribute("lastValidValue");
					$("txtSubline").focus();
					output = "notValid";
				}
			});
		} catch (e) {
			showErrorMessage("showSublineLOV", e);
		}
	}
	 
	function copyFileToLocal2(response, subFolder){
		try {
			subFolder = (subFolder == null || subFolder == "" ? "reports" : subFolder);
			if($("geniisysAppletUtil") == null || $("geniisysAppletUtil").copyFileToLocal == undefined){
				showMessageBox("Local printer applet is not configured properly. Please verify if you have accepted to run the Geniisys Utility Applet and if the java plugin in your browser is enabled.", imgMessage.ERROR);
			} else {
				var message = $("geniisysAppletUtil").copyFileToLocal(response.responseText, subFolder);
				if(message.include("SUCCESS")){
					fileMessage = "Report file generated to " + message.substring(9);
				} else {
					showMessageBox(message, "E");
				}			
			}
			new Ajax.Request(contextPath + "/GIISController", {
				parameters : {
					action : "deletePrintedReport",
					url : response.responseText
				}
			});
		} catch(e){
			showErrorMessage("copyFileToLocal", e);
		}
	}
	
	//Lov validation - prompts a message if the input value is not in the list
	/* function validateLov(lovId, func, focus) {
		if (lovId == "Assured"){
			 output = validateTextFieldLOV("/UnderwritingLOVController?action=getGipis170AssdLov&search=" + $F("txtAssured"), $F("txtAssured"), "Searching, please wait...");
		}else if(lovId == "User"){
			 output = validateTextFieldLOV("/UnderwritingLOVController?action=getGipis170UserLov&search=" + $F("txtUser"), $F("txtUser"), "Searching, please wait...");
		}else if(lovId == "Ri/ Cedant"){
			 output = validateTextFieldLOV("/UnderwritingLOVController?action=getGipis170RiLov&search=" + $F("txtCedant"), $F("txtCedant"), "Searching, please wait...");
		}else if(lovId == "Issue Source"){
			 output = validateTextFieldLOV("/UnderwritingLOVController?action=getGipis170IssLov&search=" + $F("txtIssue") + "&lineCd" + line, $F("txtIssue"), "Searching, please wait...");
		}else if(lovId == "Line"){
			if(docType == "COVER NOTE" || docType == "COVER NOTE" || docType == "POLICY" || docType == "ENDORSEMENT"){
				 output = validateTextFieldLOV("/UnderwritingLOVController?action=getGipis170LineFilteredLov&search=" + $F("txtLine")  + "&issCd" + issue + "&documentType=" + docType, $F("txtLine"), "Searching, please wait...");
			}else if(docType == "BOND POLICY" || docType == "BOND R.CERTIFICATE"  || docType == "RI INVOICE" || docType == "PRELIMINARY BINDER" || docType == "BINDER" || docType == "REVERSAL BINDER" || docType == "ONE-PAGE QUOTATION" || docType == "DETAILED QUOTATION"){
				 output = validateTextFieldLOV("/UnderwritingLOVController?action=getGipis170LineLov&search=" + $F("txtLine")  + "&issCd" + issue, $F("txtLine"), "Searching, please wait...");	
			}else if(docType == "INVOICE" || docType == "BOND INVOICE"){
				 output = validateTextFieldLOV("/UnderwritingLOVController?action=getGipis170LineSuLov&search=" + $F("txtLine")  + "&issCd" + issue + "&documentType=" + docType, $F("txtLine"), "Searching, please wait...");	
			}else{
				 output = validateTextFieldLOV("/UnderwritingLOVController?action=getGipis170LineLov&search=" + $F("txtLine")  + "&issCd" + issue, $F("txtLine"), "Searching, please wait...");	
			}
		}else if(lovId == "Subline"){
			 output = validateTextFieldLOV("/UnderwritingLOVController?action=getGipis170SublineLov&search=" + $F("txtSubline") + "&lineCd" + line, $F("txtSubline"), "Searching, please wait...");
		}
		if($(focus).value == ""){
			return false;
		}else{
			if (output == 2) {
				func($(focus).value);
			} else if (output == 0) {
				customShowMessageBox(lovId + " does not exist.", "I", focus);	
				$(focus).value = "";
			} else {
				func($(focus).value);
			}
		}
	} */

	//LOV observers
	/* $("searchUserLOV").observe("click", showUserLOV);
	$("txtUser").observe("change", function(){
		if($F("txtUser") != "")
			showUserLOV();
	}); */
	
	$("searchUserLOV").observe("click", function() {
		showUserLOV(true);
	});

	$("txtUser").observe("change", function() {
		if (this.value != "") {
			showUserLOV(false);
		} else {
			$("txtUser").value = "";
			$("txtUser").setAttribute("lastValidValue", "");
		}
	});
	
	/* $("searchAssuredLOV").observe("click", showAssdLOV);
	$("txtAssured").observe("change", function(){
		if($F("txtAssured") != "")
			showAssdLOV();
	}); */
	
	$("searchAssuredLOV").observe("click", function() {
		showAssdLOV(true);
	});

	$("txtAssured").observe("change", function() {
		if (this.value != "") {
			showAssdLOV(false);
		} else {
			$("txtAssured").value = "";
			$("txtAssured").setAttribute("lastValidValue", "");
		}
	});
	
	/* $("searchCedantLOV").observe("click", showCedantLOV);
	$("txtCedant").observe("change", function(){
		if($F("txtCedant") != "")
			showCedantLOV();
	}); */
	
	$("searchCedantLOV").observe("click", function() {
		showCedantLOV(true);
	});

	$("txtCedant").observe("change", function() {
		if (this.value != "") {
			showCedantLOV(false);
		} else {
			$("txtCedant").value = "";
			$("txtCedant").setAttribute("lastValidValue", "");
		}
	});
	
	/* $("searchIssueLOV").observe("click", showIssLOV);
	$("txtIssue").observe("change", function(){
		if($F("txtIssue") != "")
			showIssLOV();
	}); */
	
	$("searchIssueLOV").observe("click", function() {
		showIssLOV(true);
	});

	$("txtIssue").observe("change", function() {
		if (this.value != "") {
			showIssLOV(false);
		} else {
			$("txtIssue").value = "";
			issCd = "";
			$("txtIssue").setAttribute("lastValidValue", "");
			$("hidIssCd").value = "";
		}
	});
	
	/* $("searchSublineLOV").observe("click", showSublineLOV);
	$("txtSubline").observe("change", function(){
		if($F("txtSubline") != "")
			showSublineLOV();
	}); */
	
	$("searchSublineLOV").observe("click", function() {
		showSublineLOV(true);
	});

	$("txtSubline").observe("change", function() {
		if (this.value != "") {
			showSublineLOV(false);
		} else {
			$("txtSubline").value = "";
			$("txtSubline").setAttribute("lastValidValue", "");
		}
	});
	
	$("searchLineLOV").observe("click", function() {
		if(docType == "COVER NOTE" || docType == "POLICY" || docType == "ENDORSEMENT"){
			//showLineFilteredLOV();
			showLineFilteredLOV(true);
		}else if(docType == "BOND POLICY" || docType == "BOND R.CERTIFICATE" || docType == "RI INVOICE" || docType == "PRELIMINARY BINDER" || docType == "BINDER" || docType == "REVERSAL BINDER" || docType == "ONE-PAGE QUOTATION" || docType == "DETAILED QUOTATION"){
		 	//showLineLOV();
		 	showLineLOV(true);
		}else if(docType == "INVOICE" || docType == "BOND INVOICE"){
		 	//showLineSuLOV();
		 	showLineSuLOV(true);
		}else{
		 	//showLineLOV();
			showLineLOV(true);
		}
	});
	 
	$("txtLine").observe("change", function() {
		if($F("txtLine") != ""){
			if(docType == "COVER NOTE" || docType == "POLICY" || docType == "ENDORSEMENT"){
				//showLineFilteredLOV();
				showLineFilteredLOV(false);
			}else if(docType == "BOND POLICY" || docType == "BOND R.CERTIFICATE" || docType == "RI INVOICE" || docType == "PRELIMINARY BINDER" || docType == "BINDER" || docType == "REVERSAL BINDER" ||docType == "ONE-PAGE QUOTATION" || docType == "DETAILED QUOTATION"){
			 	//showLineLOV();
			 	showLineLOV(false);
			}else if(docType == "INVOICE" || docType == "BOND INVOICE"){	
			 	//showLineSuLOV();
			 	showLineSuLOV(false);
			}else{
			 	//showLineLOV();
			 	showLineLOV(false);
			}
		} else {
			$("txtLine").value = "";
			lineCd = "";
			$("txtLine").setAttribute("lastValidValue", "");
			$("hidLineCd").value = "";
		}
	});
	 
	observeCancelForm("batchPrintingExit", null, function() {
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	
	$$("input[name='printOption']").each(function(btn) {
		btn.observe("click", function() {
			printGroup = btn.value;
		});
	});
	
	//Print Button function
	$("btnPrint").observe("click", function() {
		if (checkAllRequiredFieldsInDiv("batchPrintingParameters")) {
			if (checkAllRequiredFieldsInDiv("batchPrintingPrint")) {
		        if(docType == "POLICY" || docType == "ENDORSEMENT" || docType == "BOND ENDORSEMENT"){
		        	//policy, endorsement and bond endorsement uses getPolicyPolicyId();
		        	//added temporary condition for bond endorsement(for specific client)
		        	if(docType == "BOND ENDORSEMENT"){
		        		 showMessageBox("Report not yet existing.", "I");
		        	}else{
		        		getPolicyPolicyId();
		        	}
		        }else if(docType == "BINDER" || docType == "REVERSE BINDER"){
		        	getBinderFnlBndrId();
		        }else if(docType == "COVER NOTE"){
		        	getBatchCoverNote();
		        }else if(docType == "COC(LTO)" || docType == "COC(NON-LTO)"){
		        	getBatchCoc();
		        } else if(docType == "BOND INVOICE" || docType == "INVOICE"){
		        	getBatchInvoice();
		        } else if(docType == "RI INVOICE"){
		        	getBatchRiInvoice();
		        }else if(docType == "RENEWAL CERTIFICATE"){
		        	//added temporary messsage box for renewal certificate(for specific client)
		        	showMessageBox("Report not yet existing.", "I");
		        	//getRenewalPolId();	
		        } else if(docType == "BOND R.CERTIFICATE"){
		        	//added temporary messsage box for bond renewal certificate(for specific client)
		        	showMessageBox("Report not yet existing.", "I");
		        	//getBondsRenewalPolId();
		        } else if(docType == "BOND POLICY"){
		        	getBondsPolicyPolId();
		        }else{
		        	showMessageBox("Please select a document.", "I");
		        }
			}
		} 
	});

	//for Policy, Endorsement and Bond Endorsement Printing
	function getPolicyPolicyId() {
		var policyEndt = "";
		var bondSw = "Y";
		if (docType == "POLICY") {
			policyEndt = "POL";
			bondSw = "N";
		} else if (docType == "ENDORSEMENT") {
			policyEndt = "ENDT";
			bondSw = "N";
		} else {
			bondSw = "Y";
		}
		new Ajax.Request(contextPath + "/BatchPrintingController", {
			parameters : {
				action : "getPolicyEndtId",
				printGroup : printGroup,
				docList : docType,
				pRi : variablePRi,
				assured : $F("txtAssured"),
				line : $F("txtLine") == "NOT APPLICABLE" ? "" : $F("txtLine"),
				subline : $F("txtSubline"),
				issue : $F("txtIssue"),
				startSeq : $F("txtStartSeq"),
				endSeq : $F("txtEndSeq"),
				startDate : $F("txtFromDate"),
				endDate : $F("txtToDate"),
				user : $F("txtUser") == "NOT APPLICABLE" ? "" : $F("txtUser"),
				dateList : docType == "POLICY" ? $F("selCoverNote") : $F("selEndt"),
				polEndt : policyEndt,
				bond : bondSw,
				pLcSu : variableLcSu
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function() {
				showNotice("Please wait...");
			},
			onComplete : function(response) {
				hideNotice("");
				if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
					if (response.responseText != null) {
						result = JSON.parse(response.responseText);
						for ( var i = 0; i < result.length; i++) {
							populateGixxTable(result[i].policyId, result[i].extractId, result[i].lineCd, result[i].reportId);
							getPolicyBatchReports(result[i].policyId, result[i].extractId, result[i].lineCd, result[i].reportId);
						}
						batchPrint();
						if (result.length != 0) {
							if ("file" == $F("selDestination")){
								for ( var i = 0; i < result.length; i++) {
									updatePolRec(result[i].policyId);
									deleteExtractTables(result[i].extractId);
								}
							}else{
								if(okPrint){
									showWaitingMessageBox("Report/s generation completed.", "I", function() {
										for ( var i = 0; i < result.length; i++) {
											updatePolRec(result[i].policyId);
											deleteExtractTables(result[i].extractId);
										}
										okPrint = false;
									});
								}
							}
							/* showWaitingMessageBox("Report/s generation completed.", "I", function() {
								for ( var i = 0; i < result.length; i++) {
									updatePolRec(result[i].policyId);
									deleteExtractTables(result[i].extractId);
								}
							}); */
						} else {
							showMessageBox("No records found for the entered parameters.");
						}
					}
				}
			}
		});
	}

	//Populates GIXX tables for policy, endorsement and bond endorsement printing
	function populateGixxTable(policy, extract, line, report) {
		new Ajax.Request(contextPath + "/BatchPrintingController", {
			parameters : {
				action : "extractPolDocRec",
				policyId : policy,
				extractId : extract
			},
			evalScripts : true,
			asynchronous : true,
			onComplete : function(response) {
				if (checkErrorOnResponse(response)) {
				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
	
			}
		});
	}

	//Prepares parameter for Policy, endorsement and Bond endorsement printing
	function getPolicyBatchReports(policy, extract, line, report) {
		content = contextPath
				+ "/PrintPolicyController?action=printPolicyReport&reportId=" + report 
				+ "&extractId=" + extract 
				+ "&policyId=" + policy
				+ "&isDraft=0" 
				+ "&lineCd=" + line 
				+ "&printPremium=Y";
		reports.push({reportUrl : content, reportTitle : report});
	}

	//updates table for print date and print count
	function updatePolRec(pol, ext) {
		new Ajax.Request(contextPath + "/BatchPrintingController", {
			parameters : {
				action : "updatePolRec",
				policyId : pol,
				extractId : ext
			},
			evalScripts : true,
			asynchronous : true,
			onComplete : function(response) {
				if (checkErrorOnResponse(response)) {

				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}

	//deletes the extracted details inserted in gixx tables
	function deleteExtractTables(ext) {
		new Ajax.Request(contextPath + "/BatchPrintingController", {
			parameters : {
				action : "deleteExtractTables",
				extractId : ext
			},
			evalScripts : true,
			asynchronous : true,
			onComplete : function(response) {
				if (checkErrorOnResponse(response)) {

				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}

	//For binder printing
	function getBinderFnlBndrId() {
		new Ajax.Request(contextPath + "/BatchPrintingController", {
			parameters : {
				action : "getBatchBinderId",
				printGroup : printGroup,
				docList : docType,
				assured : $F("txtAssured"),
				line : $F("txtLine"),
				subline : $F("txtSubline"),
				issue : $F("txtIssue"),
				cedant : $F("txtCedant"),
				startSeq : $F("txtStartSeq"),
				endSeq : $F("txtEndSeq"),
				startDate : $F("txtFromDate"),
				endDate : $F("txtToDate"),
				dateList : $F("selBinder")
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function() {
				showNotice("Please wait...");
			},
			onComplete : function(response) {
				hideNotice("");
				if (checkErrorOnResponse(response)) {
					if (response.responseText != null) {
						var result = JSON.parse(response.responseText);
						for ( var i = 0; i < result.length; i++) {
							getBinderBatchReports(result[i].reportId, result[i].lineCd, result[i].binderYy, result[i].binderSeqNo);
						}
						batchPrint();						
						if (result.length != 0) {
							if ("file" == $F("selDestination")){
								for ( var i = 0; i < result.length; i++) {
									updateBinderRec(result[i].fnlBinderId);
								}
							}else{
								if(okPrint){
									showWaitingMessageBox("Report/s generation completed.", "I", function() {
										for ( var i = 0; i < result.length; i++) {
											updateBinderRec(result[i].fnlBinderId);
										}
										okPrint = false;
									});
								}
							}
						} else {
							showMessageBox("No records found for the entered parameters.");
						}
					}
				}
			}
		});
	}

	//Binder printing parameters
	function getBinderBatchReports(report, line, binderYy, binderSeqNo) {
		content = contextPath
				+ "/UWReinsuranceReportPrintController?action=printUWRiBinderReport&reportId=" + report 
				+ "&lineCd=" + line 
				+ "&binderYy=" + binderYy
				+ "&binderSeqNo=" + binderSeqNo;
		reports.push({reportUrl : content, reportTitle : ""});
	}

	//update print date and print count
	function updateBinderRec(fnlBinderId) {
		new Ajax.Request(contextPath + "/BatchPrintingController", {
			parameters : {
				action : "updateBinderRec",
				binderId : fnlBinderId
			},
			evalScripts : true,
			asynchronous : true,
			onComplete : function(response) {
				if (checkErrorOnResponse(response)) {

				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}

	//for Covernote printing
	function getBatchCoverNote() {
		new Ajax.Request(contextPath + "/BatchPrintingController", {
			parameters : {
				action : "getBatchCoverNote",
				printGroup : printGroup,
				docList : docType,
				assured : $F("txtAssured"),
				line : $F("txtLine"),
				subline : $F("txtSubline"),
				issue : $F("txtIssue"),
				startSeq : $F("txtStartSeq"),
				endSeq : $F("txtEndSeq"),
				startDate : $F("txtFromDate"),
				endDate : $F("txtToDate"),
				dateList : $F("selCoverNote")
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function() {
				showNotice("Please wait...");
			},
			onComplete : function(response) {
				hideNotice("");
				if (checkErrorOnResponse(response)) {
					if (response.responseText != null) {
						var result = JSON.parse(response.responseText);
						for ( var i = 0; i < result.length; i++) {
							getCoverNoteatchReports(result[i].reportId, result[i].parId);
						}
						batchPrint();
						if (result.length != 0) {
							if ("file" == $F("selDestination")){
								for ( var i = 0; i < result.length; i++) {
									updateCoverNoteRec(result[i].parId);
								}
							}else{
								if(okPrint){
									showWaitingMessageBox("Report/s generation completed.", "I", function() {
										for ( var i = 0; i < result.length; i++) {
											updateCoverNoteRec(result[i].parId);
										}
										okPrint = false;
									});
								}
							}
							/* showWaitingMessageBox("Report/s generation completed.", "I", function() {
								for ( var i = 0; i < result.length; i++) {
									updateCoverNoteRec(result[i].parId);
								}
							}); */
						} else {
							showMessageBox("No records found for the entered parameters.");
						}
					}
				}
			}
		});
	}
	
	//Covernote printing parameter
	function getCoverNoteatchReports(report, parid) {
		content = contextPath 
				+ "/PrintPolicyController?action=printBatchCoverNote&reportId=" + report 
				+ "&parId=" + parid;
		reports.push({reportUrl : content, reportTitle : "Cover Note"});
	}

	//update cover note print date and print count
	function updateCoverNoteRec(parId) {
		new Ajax.Request(contextPath + "/BatchPrintingController", {
			parameters : {
				action : "updateCoverNoteRec",
				parId : parId
			},
			evalScripts : true,
			asynchronous : true,
			onComplete : function(response) {
				if (checkErrorOnResponse(response)) {

				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}

	//for COC - LTO and NON-LTO printing
	function getBatchCoc() {
		var vCoc = "";
		if (docType == "COC(LTO)") {
			vCoc = "LTO";
		} else {
			vCoc = "NON-LTO";
		}
		new Ajax.Request(contextPath + "/BatchPrintingController", {
			parameters : {
				action : "getBatchCoc",
				printGroup : printGroup,
				docList : docType,
				assured : $F("txtAssured"),
				subline : $F("txtSubline"),
				issue : $F("txtIssue"),
				startSeq : $F("txtStartSeq"),
				endSeq : $F("txtEndSeq"),
				startDate : $F("txtFromDate"),
				endDate : $F("txtToDate"),
				dateList : $F("selCoc"),
				pLcMc : variableLcMc,
				pScLto : variablevScLto,
				pLto : vCoc,
				user : $F("txtUser")
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function() {
				showNotice("Please wait...");
			},
			onComplete : function(response) {
				hideNotice("");
				if (checkErrorOnResponse(response)) {
					if (response.responseText != null) {
						var result = JSON.parse(response.responseText);
						for ( var i = 0; i < result.length; i++) {
							getCocBatchReports(result[i].reportId, result[i].policyId, result[i].itemNo);
						}
						batchPrint();
						if (result.length != 0) {
							if ("file" == $F("selDestination")){
								for ( var i = 0; i < result.length; i++) {
									updateCocRec(result[i].policyId);
								}
							}else{
								if(okPrint){
									showWaitingMessageBox("Report/s generation completed.", "I", function() {
										for ( var i = 0; i < result.length; i++) {
											updateCocRec(result[i].policyId);
										}
										okPrint = false;
									});
								}
							}
							/* showWaitingMessageBox("Report/s generation completed.", "I", function() {
								for ( var i = 0; i < result.length; i++) {
									updateCocRec(result[i].policyId);
								}
							}); */
						} else {
							showMessageBox("No records found for the entered parameters.");
						}
					}
				}
			}
		});
	}
	
	//COC printing parameters
	function getCocBatchReports(report, policy, item) {
		content = contextPath
				+ "/PrintPolicyController?action=printPolicyReport&reportId=" + report 
				+ "&policyId=" + policy 
				+ "&isDraft=0" 
				+ "&itemNo=" + item 
				+ "&extractId=" + policy ;
		reports.push({reportUrl : content, reportTitle : ""});
	}

	//update COC print date and print count
	function updateCocRec(policy) {
		new Ajax.Request(contextPath + "/BatchPrintingController", {
			parameters : {
				action : "updateCocRec",
				policyId : policy
			},
			evalScripts : true,
			asynchronous : true,
			onComplete : function(response) {
				if (checkErrorOnResponse(response)) {

				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}

	//for invoice printing
	function getBatchInvoice() {
		var invoice = "";
		if (docType == "INVOICE") {
			invoice = "POLICY";
		} else {
			invoice = "BOND";
		}
		new Ajax.Request(contextPath + "/BatchPrintingController", {
			parameters : {
				action : "getBatchInvoice",
				printGroup : printGroup,
				docList : docType,
				assured : $F("txtAssured"),
				line : $F("txtLine"),
				subline : $F("txtSubline"),
				issue : $F("txtIssue"),
				user : $F("txtUser"),
				startSeq : $F("txtStartSeq"),
				endSeq : $F("txtEndSeq"),
				startDate : $F("txtFromDate"),
				endDate : $F("txtToDate"),
				dateList : $F("selCoverNote"),
				pLcSu : variableLcSu,
				pBondPol : invoice
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function() {
				showNotice("Please wait...");
			},
			onComplete : function(response) {
				hideNotice("");
				if (checkErrorOnResponse(response)) {
					if (response.responseText != null) {
						var result = JSON.parse(response.responseText);
						for ( var i = 0; i < result.length; i++) {
							getInvoiceBatchReports(result[i].reportId, result[i].policyId, result[i].lineCd);
						}
						batchPrint();
						if (result.length != 0) {
							if ("file" == $F("selDestination")){
								for ( var i = 0; i < result.length; i++) {
									updateInvoiceRec(result[i].policyId);
								}
							}else{
								if(okPrint){
									showWaitingMessageBox("Report/s generation completed.", "I", function() {
										for ( var i = 0; i < result.length; i++) {
											updateInvoiceRec(result[i].policyId);
										}
										okPrint = false;
									});
								}
							}
							/* showWaitingMessageBox("Report/s generation completed.", "I", function() {
								for ( var i = 0; i < result.length; i++) {
									updateInvoiceRec(result[i].policyId);
								}
							}); */
						} else {
							showMessageBox("No records found for the entered parameters.");
						}
					}
				}
			}
		});
	}
	
	//Invoice printing parameters
	function getInvoiceBatchReports(report, policy, line) {
		content = contextPath
				+ "/PrintPolicyController?action=printPolicyReport&reportId=" + report 
				+ "&policyId=" + policy 
				+ "&lineCd=" + line
				+ "&isDraft=0" 
				+ "&extractId=" + policy;
		reports.push({reportUrl : content, reportTitle : policy});
	}

	//Update invoice print date and print count
	function updateInvoiceRec(policy) {
		new Ajax.Request(contextPath + "/BatchPrintingController", {
			parameters : {
				action : "updateInvoiceRec",
				policyId : policy
			},
			evalScripts : true,
			asynchronous : true,
			onComplete : function(response) {
				if (checkErrorOnResponse(response)) {

				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	//For RI invoice printing
	function getBatchRiInvoice() {
		new Ajax.Request(contextPath + "/BatchPrintingController", {
			parameters : {
				action : "getBatchRiInvoice",
				printGroup : printGroup,
				docList : docType,
				assured : $F("txtAssured"),
				line : $F("txtLine"),
				subline : $F("txtSubline"),
				issue : $F("txtIssue"),
				cedant : $F("txtCedant"),
				startSeq : $F("txtStartSeq"),
				endSeq : $F("txtEndSeq"),
				startDate : $F("txtFromDate"),
				endDate : $F("txtToDate"),
				dateList : $F("selCoverNote"),
				user : $F("txtUser")
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function() {
				showNotice("Please wait...");
			},
			onComplete : function(response) {
				hideNotice("");
				if (checkErrorOnResponse(response)) {
					if (response.responseText != null) {
						var result = JSON.parse(response.responseText);
						for ( var i = 0; i < result.length; i++) {
							getInvoiceBatchReports(result[i].reportId, result[i].policyId, result[i].lineCd);
						}
						batchPrint();
						if (result.length != 0) {
							if ("file" == $F("selDestination")){
								for ( var i = 0; i < result.length; i++) {
									updateInvoiceRec(result[i].policyId);
								}
							}else{
								if(okPrint){
									showWaitingMessageBox("Report/s generation completed.", "I", function() {
										for ( var i = 0; i < result.length; i++) {
											updateInvoiceRec(result[i].policyId);
										}
										okPrint = false;
									});
								}
							}
							/* showWaitingMessageBox("Report/s generation completed.", "I", function() {
								for ( var i = 0; i < result.length; i++) {
									updateInvoiceRec(result[i].policyId);
								}
							}); */
						} else {
							showMessageBox("No records found for the entered parameters.");
						}
					}
				}
			}
		});
	}

	//for BOND Renewal Certificate Printing(returns list to be printed based on given parameters)
	/* function getBondsRenewalPolId() {
		new Ajax.Request(contextPath + "/BatchPrintingController", {
			parameters : {
				action : "getBondsRenewalPolId",
				printGroup : printGroup,
				docList : docType,
				assured : $F("txtAssured"),
				subline : $F("txtSubline"),
				issue : $F("txtIssue"),
				startSeq : $F("txtStartSeq"),
				endSeq : $F("txtEndSeq"),
				startDate : $F("txtFromDate"),
				endDate : $F("txtToDate"),
				dateList : $F("selCoverNote"),
				pLcSu : variableLcSu
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function() {
				showNotice("Please wait...");
			},
			onComplete : function(response) {
				hideNotice("");
				if (checkErrorOnResponse(response)) {
					if (response.responseText != null) {
						//Report Param, Batch Print and update function	--use updatePolRec
					}
				}
			}
		});
	} */

	//for Renewal Certificate Printing(returns list to be printed based on given parameters)
	/* function getRenewalPolId() {
		new Ajax.Request(contextPath + "/BatchPrintingController", {
			parameters : {
				action : "getRenewalPolId",
				printGroup : printGroup,
				docList : docType,
				assured : $F("txtAssured"),
				line : $F("txtLine"),
				subline : $F("txtSubline"),
				issue : $F("txtIssue"),
				startSeq : $F("txtStartSeq"),
				endSeq : $F("txtEndSeq"),
				startDate : $F("txtFromDate"),
				endDate : $F("txtToDate"),
				dateList : $F("selCoverNote")
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function() {
				showNotice("Please wait...");
			},
			onComplete : function(response) {
				hideNotice("");
				if (checkErrorOnResponse(response)) {
					if (response.responseText != null) {
						//Report Param, Batch Print and update function	--use updatePolRec
					}
				}
			}
		});
	} */

	//for bond policy printing
	function getBondsPolicyPolId() {
		new Ajax.Request(contextPath + "/BatchPrintingController", {
			parameters : {
				action : "getBondsPolicyPolId",
				printGroup : printGroup,
				docList : docType,
				assured : $F("txtAssured"),
				subline : $F("txtSubline"),
				issue : $F("txtIssue"),
				startSeq : $F("txtStartSeq"),
				endSeq : $F("txtEndSeq"),
				startDate : $F("txtFromDate"),
				endDate : $F("txtToDate"),
				dateList : $F("selCoverNote"),
				pRi : variablePRi,
				pLcSu : variableLcSu
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function() {
				showNotice("Please wait...");
			},
			onComplete : function(response) {
				hideNotice("");
				if (checkErrorOnResponse(response)) {
					if (response.responseText != null) {
						var result = JSON.parse(response.responseText);
						for ( var i = 0; i < result.length; i++) {
							getBondsPolicyReport(result[i].reportId, result[i].policyId, result[i].sublineCd, result[i].parId, result[i].parType);
						} 
						batchPrint();
						if (result.length != 0) {
							if ("file" == $F("selDestination")){
								for ( var i = 0; i < result.length; i++) {
									updatePolRec(result[i].policyId);
								}
							}else{
								if(okPrint){
									showWaitingMessageBox("Report/s generation completed.", "I", function() {
										for ( var i = 0; i < result.length; i++) {
											updatePolRec(result[i].policyId);
										}
										okPrint = false;
									});
								}
							}
							/* showWaitingMessageBox("Report/s generation completed.", "I", function() {
								for ( var i = 0; i < result.length; i++) {
									updatePolRec(result[i].policyId);
								}
							}); */
						} else {
							showMessageBox("No records found for the entered parameters.");
						}
					}
				}
			}
		});
	}

	//bond policy printing parameters
	function getBondsPolicyReport(report, policy, subline, par, type) {
		content = contextPath
				+ "/PrintPolicyController?action=printPolicyReport&reportId=" + report 
				+ "&policyId=" + policy 
				+ "&sublineCd=" + subline
				+ "&parId=" + par 
				+ "&bondParType=" + type 
				+ "&isDraft=0"
				+ "&extractId=0";
		reports.push({reportUrl : content, reportTitle : ""});
	}

	//update bond policy print date and print count
	function updateInvoiceRec(policy) {
		new Ajax.Request(contextPath + "/BatchPrintingController", {
			parameters : {
				action : "updateInvoiceRec",
				policyId : policy
			},
			evalScripts : true,
			asynchronous : true,
			onComplete : function(response) {
				if (checkErrorOnResponse(response)) {

				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}

	//Print Function
	function batchPrint() {
		try {
			if ($F("selDestination") == "screen") {
				showMultiPdfReport(reports);
				reports = [];
				okPrint = true;
			} else if ($F("selDestination") == "printer") {
				for ( var i = 0; i < reports.length; i++) {
					new Ajax.Request(reports[i].reportUrl, {
						method : "GET",
						parameters : {
							noOfCopies : $F("txtNoOfCopies"),
							printerName : $F("selPrinter")
						},
						evalScripts : true,
						asynchronous : true,
						onComplete : function(response) {
							if (checkErrorOnResponse(response)) {
								okPrint = true;
							}
						}
					});
				}
				reports = [];
			} else if ("file" == $F("selDestination")) {
				var length = reports.length;
				for ( var i = 0; i < reports.length; i++) {
					new Ajax.Request(reports[i].reportUrl, {
						method : "GET",
						parameters : {
							destination : "file",
							fileType : $("rdoPdf").checked ? "PDF" : "XLS"
						},
						onCreate : showNotice("Generating report, please wait..."),
						onComplete : function(response) {
							hideNotice();
							if (checkErrorOnResponse(response)) {
								copyFileToLocal2(response, "reports");
								 if(i == length){
									showMessageBox(fileMessage, "I");
								} 
								 okPrint = true;
							}
						}
					});
				}
				reports = [];
			} else if ("local" == $F("selDestination")) {
				var printerName = null;
				
				if(nvl($("geniisysAppletUtil"), null) == null || nvl($("geniisysAppletUtil").selectPrinter, null) == null ||
					nvl($("geniisysAppletUtil").printBatchJRPrintFileToPrinter, null) == null){
					showWaitingMessageBox("Local printer applet is not configured properly. Please verify if you have accepted to run the Geniisys Utility Applet and if the java plugin in your browser is enabled.", "E", function(){
						toggleOnPrint(true);
					});
					return;
				}else{
					printerName = $("geniisysAppletUtil").selectPrinter();
				}
				
				if(printerName == "" || printerName == null){
					showWaitingMessageBox("No printer selected.", "I", function(){
						toggleOnPrint(true);
					});
					return;
				}
				var length = reports.length;
				for ( var i = 0; i < reports.length; i++) {
					new Ajax.Request(reports[i].reportUrl, {
						evalScripts: true,
						asynchronous: false,
						parameters: {
							destination: "local"
						},
						onComplete: function(response){
							if(checkErrorOnResponse(response)){
								printBatchToLocalPrinter(response.responseText, printerName);
								okPrint = true;
							}
						}
					});
					
				}
				reports = [];
			}
		} catch (e) {
			showErrorMessage("batchPrint", e);
		}
	}
	
	$("reloadForm").observe("click", function() {
		initializeGIPIS170Fields();
		toggleFormDefaultFields();
		$("rdoUnprinted").checked = true;
		printGroup = "U";
		issCd = "";
		lineCd = "";
	});

	$$("input[name='txtSequence']").each(function(btn) {
		btn.observe("change", function() {
			$(btn.id).value = $F(btn.id) != "" ? Number($F(btn.id)).toPaddedString(7) : "";
		});
	});

	$$("input[name='fromTo']").each(function(field) {
		field.observe("focus", function() {
			checkInputDates(field, "txtFromDate", "txtToDate");
		});
	});
	
	observeBackSpaceOnDate("txtFromDate");
	observeBackSpaceOnDate("txtToDate");
</script>
