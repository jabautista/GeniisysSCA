<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="agingOfPremRecMainDiv" name="agingOfPremRecMainDiv">
	<div id="agingOfPremRecReportMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="btnExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Aging of Premiums Receivable</label>
		</div>
	</div>
	<div class="sectionDiv" id="agingOfPremRecReportBody" >
		<div class="sectionDiv" id="agingOfPremRecReport" style="width: 70%; margin: 40px 138px 40px 138px;">
			<div class="sectionDiv" id="agingOfPremReportInnerDiv" style="width: 97%; margin: 8px 8px 2px 8px;">
				<table align="center" style="padding: 20px;">
					<tr>
						<td class="rightAligned">As of</td>
						<td>
							<div style="float: left; width: 160px;" class="required withIconDiv">
								<input type="text" id="txtAsOfDate" name="txtAsOfDate" class="required withIcon" readonly="readonly" style="width: 135px;"/>
								<img id="imgAsOfDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Branch</td>
						<td colspan="5">
							<span class="lovSpan" style="width:66px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input  class="rightAligned"  type="text" id="branchCd" name="branchCd" style="width: 36px; float: left; margin-right: 4px; border: none; height: 13px;" maxlength="2"/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranchCd" name="searchBranchCd" alt="Go" style="float: right;"/>
							</span>
							<input  class="leftAligned"  type="text" id="branchName" name="branchName"  value="ALL BRANCHES" readonly="readonly" style="width: 325px; float: left; margin-right: 4px;"/>							
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Intermediary Type</td>
						<td colspan="5">
							<span class="lovSpan" style="width:66px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input  class="rightAligned"  type="text" id="intmType" name="intmType" style="width: 36px; float: left; margin-right: 4px; border: none; height: 13px;" maxlength="2"/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIntmType" name="searchIntmType" alt="Go" style="float: right;"/>
							</span>
							<input  class="leftAligned"  type="text" id="intmTypeDesc" name="intmTypeDesc"  value="ALL INTERMEDIARY TYPE" readonly="readonly" style="width: 325px; float: left; margin-right: 4px;"/>							
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Intermediary Name</td>
						<td colspan="5">
							<span class="lovSpan" style="width:66px; height: 21px; margin: 2px 4px 0 0; float: left;">
								<input  class="rightAligned"  type="text" id="intmNo" name="intmNo" style="width: 36px; float: left; margin-right: 4px; border: none; height: 13px;"/>	
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIntmNo" name="searchIntmNo" alt="Go" style="float: right;"/>
							</span>
							<input  class="leftAligned"  type="text" id="intmName" name="intmName"  value="ALL INTERMEDIARIES" readonly="readonly" style="width: 325px; float: left; margin-right: 4px;"/>								
						</td>
					</tr>
				</table>
			</div>
			<div class="sectionDiv" id="printDiv" style="width: 97%; margin: 8px 8px 2px 8px;">
				<table id="printDialogMainTab" name="printDialogMainTab" align="center" style="padding: 10px;">
					<tr>
						<td style="text-align:right; width: 27%;">Destination</td>
						<td style="width: 73%;">
							<select id="selDestination" style="margin-left:5px; width:73%;" >
								<option value="screen">Screen</option>
								<option value="printer">Printer</option>
								<option value="file">File</option>
								<option value="local">Local Printer</option>
							</select>
						</td>
					</tr>
					<tr id="trRdoFileType">
						<td style="width: 27%;">&nbsp;</td>
						<td style="width: 73%;">
							<table border="0">
								<tr>
									<td><input type="radio" style="margin-left:0px;" id="rdoPdf" name="rdoFileType" value="PDF" title="PDF" checked="checked" disabled="disabled" style="margin-left:10px;"/></td>
									<td><label for="rdoPdf"> PDF</label></td>
									<td style="width:30px;">&nbsp;</td>
									<!-- <td><input type="radio" id="rdoExcel" name="rdoFileType" value="XLS" title="Excel" disabled="disabled" /></td>
									<td><label for="rdoExcel"> Excel</label></td> Dren Niebres 05.20.2016 SR-5359--> 
									<td><input type="radio" id="rdoCsv" name="rdoFileType" value="CSV" title="Csv" disabled="disabled" /></td>
									<td><label for="rdoCsv"> CSV</label></td> <!-- Dren Niebres 05.20.2016 SR-5359 -->									
								</tr>									
							</table>
						</td>
					</tr>
					<tr>
						<td style="text-align:right; width: 27%;">Printer Name</td>
						<td style="width: 73%;">
							<select id="printerName" style="margin-left:5px; width:73%;">
								<option></option>
									<c:forEach var="p" items="${printers}">
										<option value="${p.name}">${p.name}</option>
									</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<td style="text-align:right; width: 27%;">No. of Copies</td>
						<td style="width: 73%;">
							<input type="text" id="txtNoOfCopies" style="margin-left:5px;float:left; text-align:right; width:179px;" class="integerNoNegativeUnformattedNoComma">
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
			<div id="ButtonsDiv" name="ButtonsDiv" class="buttonsDiv" style="">
				<input type="button" class="button" id="btnExtract" name="btnExtract" value="Extract" style="width:90px;" />
				<input type="button" class="button" id="btnPrint" name="btnPrint" value="Print" style="width:90px;" />
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
	setModuleId("GIACS329");
	setDocumentTitle("Aging of Premiums Receivables");
	initializeAll();
	checkUserAccess();
	togglePrintFields("screen");
	
	$("btnPrint").observe("click", function(){
		var result = validateExtract();
		if (result != 'Y') {
			//marco - 07.25.2014 - added condition
			if(result == "X"){
				showMessageBox("Please extract records first.", "I");
			}else{
				showConfirmBox("Confirmation", "The specified parameter/s has not been extracted. Do you want to extract the data using the specified parameter/s?", "Yes", "No",
						function() {
							extractGIACS329();
						}, "");
			}
		} else {
			printReport();
		}
	});
	
	function printReport(){
		try {
			
			var reportId; //Dren Niebres 05.20.2016 SR-5359
			
			if($F("selDestination") == "printer"){
				if($F("printerName") == "" || $F("txtNoOfCopies") == "" || $F("txtAsOfDate") == ""){
					showMessageBox("Required fields must be entered.", "I");
					return false;
				}
				
				if(isNaN($F("txtNoOfCopies")) || ($F("txtNoOfCopies") < 1 || $F("txtNoOfCopies") > 100)){
					showMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "I");
					$("txtNoOfCopies").value = "";
					return false;
				}
			}	
			
			if($F("selDestination") == "file") { //Dren Niebres 05.20.2016 SR-5359 - Start
				if ($("rdoPdf").checked) 
					reportId = "GIACR329";
				else 
					reportId = "GIACR329_CSV";		
			} else {
				reportId = "GIACR329";
			} //Dren Niebres 05.20.2016 SR-5359 - End
			
			var content = contextPath + "/CreditAndCollectionReportPrintController?action=printReport"
            + "&reportId=" + reportId //"GIACR329" //Dren Niebres 05.20.2016 SR-5359
            + getParams();
			
			if("screen" == $F("selDestination")){
				showPdfReport(content, "");
			} else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					parameters : {
						printerName : $F("printerName"),
						noOfCopies : $F("txtNoOfCopies")
					},
					onCreate: showNotice("Processing, please wait..."),				
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							showMessageBox("Printing Complete.", "I");
						}
					}
				});
			} else if("file" == $F("selDestination")){
				
				var fileType = "PDF"; //Dren Niebres 05.20.2016 SR-5359 - Start
				
				if ($("rdoPdf").checked)
					fileType = "PDF";
				else
					fileType = "CSV2"; //Dren Niebres 05.20.2016 SR-5359 - End				
				
				new Ajax.Request(content, {
					parameters : {destination : "file",
								  fileType : fileType},//$("rdoPdf").checked ? "PDF" : "XLS"}, //Dren Niebres 05.20.2016 SR-5359
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							if (fileType == "CSV2"){ //Dren Niebres 05.20.2016 SR-5359 - Start
								copyFileToLocal(response, "csv");
							} else 
								copyFileToLocal(response);
						} //Dren Niebres 05.20.2016 SR-5359 - End							
					}
				});
			} else if("local" == $F("selDestination")){
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
		} catch (e){
			showErrorMessage("printReport", e);
		}
	}
	
	function getParams(){
		var params = "&branchCd=" + $("branchCd").value
		+ "&intmType=" + $("intmType").value
		+ "&intmNo=" + $("intmNo").value
		+ "&asOfDate=" + $("txtAsOfDate").value;
		
		return params;
	}
	
	$("btnExtract").observe("click", function(){
		validateBeforeExtract();
	});
	
	function validateBeforeExtract() {
		try{
		 	if ($F("txtAsOfDate") == "") {
				showMessageBox("Required fields must be entered.","I");
				return; //marco - 07.25.2014
			}
		 	
		 	if (validateExtract() == 'Y') {
				showConfirmBox("Confirmation", "Data has been extracted within the specified parameter/s. Do you wish to continue extraction?", "Yes", "No",
						function() {
							extractGIACS329();
						}, "");
			} else {
				extractGIACS329();
			}
		}catch (e) {
			showErrorMessage("validateBeforeExtract",e);
		}
	}
	
	function validateExtract() {
		try {
			var result = 'N';
			new Ajax.Request(contextPath+"/GIACCreditAndCollectionReportsController",{
				method: "POST",
				parameters : {action : "giacs329ValidateDateParams",
							  asOfDate : $F("txtAsOfDate"),
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function (){
					showNotice("Loading, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						result = response.responseText;
					}
				}
			});
			return result;
		} catch (e) {
			showErrorMessage("validateExtract",e);
		}
	}
	
	function extractGIACS329(){
		try {
			new Ajax.Request(contextPath+"/GIACCreditAndCollectionReportsController",{
				method: "POST",
				parameters : {action : "extractGIACS329",
							  asOfDate : $F("txtAsOfDate"),
							  branchCd : $F("branchCd"),
							  intmType : $F("intmType"), //marco - 08.05.2014
							  intmNo   : $F("intmNo")	 //
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function (){
					showNotice("Extracting, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					var result = JSON.parse(response.responseText);
					if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						if (result.exist == "0") {
							showMessageBox("Extraction finished. No records extracted.","I");
						}else{
							showMessageBox("Extraction finished. " + result.exist + " records extracted.", "I");
						}
					}
				}
			});
		} catch (e) {
			showErrorMessage("extractGIACS329",e);
		}
	}
	
	$("imgAsOfDate").observe("click", function(){
		scwShow($('txtAsOfDate'),this, null);
	});
	
	$("selDestination").observe("change", function(){
		var destination = $F("selDestination");
		togglePrintFields(destination);
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
	
	function togglePrintFields(destination){
		if(destination == "printer"){
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
			//$("rdoExcel").disable(); //Dren Niebres 05.20.2016 SR-5359
			$("rdoCsv").disable();	   //Dren Niebres 05.20.2016 SR-5359
		} else {
			if(destination == "file"){
				$("rdoPdf").enable();
				//$("rdoExcel").enable(); //Dren Niebres 05.20.2016 SR-5359
				$("rdoCsv").enable();	   //Dren Niebres 05.20.2016 SR-5359
			} else {
				$("rdoPdf").disable();
				//$("rdoExcel").disable(); //Dren Niebres 05.20.2016 SR-5359
				$("rdoCsv").disable();	   //Dren Niebres 05.20.2016 SR-5359
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
	
	$("branchCd").setAttribute("lastValidValue", "");
	$("branchName").setAttribute("lastValidValue", "ALL BRANCHES");
	$("searchBranchCd").observe("click", showGiacs329BranchLov);
	$("branchCd").observe("change", function() {		
		if($F("branchCd").trim() == "") {
			$("branchCd").value = "";
			$("branchCd").setAttribute("lastValidValue", "");
			$("branchName").value = "ALL BRANCHES";
			$("branchName").setAttribute("lastValidValue", "ALL BRANCHES");
		} else {
			if($F("branchCd").trim() != "" && $F("branchCd") != $("branchCd").readAttribute("lastValidValue")) {
				showGiacs329BranchLov();
			}
		}
	});
	$("branchCd").observe("keyup", function(){
		$("branchCd").value = $F("branchCd").toUpperCase();
	});
	
	function showGiacs329BranchLov(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : "showGiacs329BranchLov",
							filterText : ($("branchCd").readAttribute("lastValidValue").trim() != $F("branchCd").trim() ? $F("branchCd").trim() : ""),
							page : 1},
			title: "List of Branches",
			width: 500,
			height: 400,
			columnModel : [
							{
								id : "branchCd",
								title: "Code",
								width: '100px',
								filterOption: true
							},
							{
								id : "branchName",
								title: "Branch",
								width: '325px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("branchCd").readAttribute("lastValidValue").trim() != $F("branchCd").trim() ? $F("branchCd").trim() : ""),
				onSelect: function(row) {
					$("branchCd").value = row.branchCd;
					$("branchName").value = unescapeHTML2(row.branchName);
					$("branchCd").setAttribute("lastValidValue", row.branchCd);	
					$("branchName").setAttribute("lastValidValue", unescapeHTML2(row.branchName));
				},
				onCancel: function (){
					$("branchCd").value = $("branchCd").readAttribute("lastValidValue");
					$("branchName").value = unescapeHTML2($("branchName").readAttribute("lastValidValue"));
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("branchCd").value = $("branchCd").readAttribute("lastValidValue");
					$("branchName").value = unescapeHTML2($("branchName").readAttribute("lastValidValue"));
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	$("intmType").setAttribute("lastValidValue", "");
	$("intmTypeDesc").setAttribute("lastValidValue", "ALL INTERMEDIARY TYPE");
	$("searchIntmType").observe("click", showGiacs329IntmTypeLov);
	$("intmType").observe("change", function() {		
		if($F("intmType").trim() == "") {
			$("intmType").value = "";
			$("intmType").setAttribute("lastValidValue", "");
			$("intmTypeDesc").value = "ALL INTERMEDIARY TYPE";
			$("intmTypeDesc").setAttribute("lastValidValue", "ALL INTERMEDIARY TYPE");
		} else {
			if($F("intmType").trim() != "" && $F("intmType") != $("intmType").readAttribute("lastValidValue")) {
				showGiacs329IntmTypeLov();
			}
		}
	});
	$("intmType").observe("keyup", function(){
		$("intmType").value = $F("intmType").toUpperCase();
	});
	
	function showGiacs329IntmTypeLov(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : "showGiacs329IntmTypeLov",
							filterText : ($("intmType").readAttribute("lastValidValue").trim() != $F("intmType").trim() ? $F("intmType").trim() : ""),
							page : 1},
			title: "List of Intermediary Type",
			width: 500,
			height: 400,
			columnModel : [
							{
								id : "intmType",
								title: "Intm. Type",
								width: '100px',
								renderer: function(value) {
									return unescapeHTML2(value);
								},
								filterOption: true
							},
							{
								id : "intmDesc",
								title: "Intm. Description",
								width: '325px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("intmType").readAttribute("lastValidValue").trim() != $F("intmType").trim() ? $F("intmType").trim() : ""),
				onSelect: function(row) {
					$("intmType").value = row.intmType;
					$("intmTypeDesc").value = unescapeHTML2(row.intmDesc);
					$("intmType").setAttribute("lastValidValue", unescapeHTML2(row.intmType));	
					$("intmTypeDesc").setAttribute("lastValidValue", unescapeHTML2(row.intmDesc));	
				},
				onCancel: function (){
					$("intmType").value = unescapeHTML2($("intmType").readAttribute("lastValidValue"));
					$("intmTypeDesc").value = unescapeHTML2($("intmTypeDesc").readAttribute("lastValidValue"));
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("intmType").value = unescapeHTML2($("intmType").readAttribute("lastValidValue"));
					$("intmTypeDesc").value = unescapeHTML2($("intmTypeDesc").readAttribute("lastValidValue"));
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	$("intmNo").setAttribute("lastValidValue", "");
	$("intmName").setAttribute("lastValidValue", "ALL INTERMEDIARIES");
	$("searchIntmNo").observe("click", showGiacs329IntmLov);
	$("intmNo").observe("change", function() {		
		if($F("intmNo").trim() == "") {
			$("intmNo").value = "";
			$("intmNo").setAttribute("lastValidValue", "");
			$("intmName").value = "ALL INTERMEDIARIES";
			$("intmName").setAttribute("lastValidValue", "ALL INTERMEDIARIES");
		} else {
			if($F("intmNo").trim() != "" && $F("intmNo") != $("intmNo").readAttribute("lastValidValue")) {
				showGiacs329IntmLov();
			}
		}
	});
	$("intmNo").observe("keyup", function(){
		$("intmNo").value = $F("intmNo").toUpperCase();
	});
	
	function showGiacs329IntmLov(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : "showGiacs329IntmLov",
				            intmType : $F("intmType"),
							filterText : ($("intmNo").readAttribute("lastValidValue").trim() != $F("intmNo").trim() ? $F("intmNo").trim() : ""),
							page : 1},
			title: "List of Intermediaries",
			width: 500,
			height: 400,
			columnModel : [
							{
								id : "intmNo",
								title: "Intm. No.",
								width: '100px',
								filterOption: true
							},
							{
								id : "intmName",
								title: "Intm. Name",
								width: '325px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("intmNo").readAttribute("lastValidValue").trim() != $F("intmNo").trim() ? $F("intmNo").trim() : ""),
				onSelect: function(row) {
					$("intmNo").value = row.intmNo;
					$("intmName").value = unescapeHTML2(row.intmName);
					$("intmNo").setAttribute("lastValidValue", row.intmNo);	
					$("intmName").setAttribute("lastValidValue", unescapeHTML2(row.intmName));
				},
				onCancel: function (){
					$("intmNo").value = $("intmNo").readAttribute("lastValidValue");
					$("intmName").value = unescapeHTML2($("intmName").readAttribute("lastValidValue"));
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("intmNo").value = $("intmNo").readAttribute("lastValidValue");
					$("intmName").value = unescapeHTML2($("intmName").readAttribute("lastValidValue"));
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	function checkUserAccess(){
		try{
			new Ajax.Request(contextPath+"/GIACAccTransController?action=checkUserAccess2", {
				method: "POST",
				parameters: {
					moduleName: "GIACS329"
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(response.responseText == 0){
						showWaitingMessageBox('You are not allowed to access this module.', imgMessage.ERROR, 
								function(){
							goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
						});  
						
					}
				}
			});
		}catch(e){
			showErrorMessage('checkUserAccess', e);
		}
	}
	
	$("btnExit").observe("click", function() {
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
	});
	
	whenNewFormInstanceGICLS220();
	
	function whenNewFormInstanceGICLS220(){
		new Ajax.Request(contextPath+"/GIACCreditAndCollectionReportsController?action=whenNewFormInstanceGIACS329",{
			evalScripts: true,
			asynchronous: true,
			onComplete: function(response){
				if (checkErrorOnResponse(response)){
					var res = JSON.parse(response.responseText);
					$("txtAsOfDate").value = nvl(res.vAsOfDate, ""); //marco - 07.25.2014 - added nvl
				}
			}
		});
	}
</script>