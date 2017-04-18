<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="taxesWithheldFromPayeesMainDiv" class="sectionDiv" style="height: 460px;">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Print Taxes Withheld from Payees</label>
			<span class="refreshers" style="margin-top: 0;">
		 		<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>
	<div class="sectionDiv" style="width: 624px; margin-top: 30px; margin-left: 150px;">
		<div class="sectionDiv" style="height: 30px; width: 618px; margin-top: 2px; margin-left: 2px;">
			<input type="checkbox" id="chkCPostDate" style="float: left; margin-top: 8px; margin-left: 147px;" />
			<label for="chkCPostDate" style="margin-top: 8px; margin-left: 5px;">Posting Date</label>
			<input type="checkbox" id="chkCTranDate" style="float: left; margin-top: 8px; margin-left: 140px;" />
			<label for="chkCTranDate" style="margin-top: 8px; margin-left: 5px;">Tran Date</label>
		</div>
		<div class="sectionDiv" style="height: 145px; width: 618px; margin-top: 1px; margin-left: 2px;">
			<table width="100%" style="margin: 10px auto 0;">
				<tr>
					<td class="rightAligned" width="150px">
						<input type="radio" id="rdoAsOf" name="dateP" checked="checked" style="margin-top: 9px; margin-left: 100px; float: left;"/>
						<label for="rdoAsOf" style="margin-top: 8px; margin-left: 5px; ">As of</label>
					</td>
					<td>
						<div id="asOfDiv" style="float: left; border: solid 1px gray; width: 140px; height: 20px; margin-left: 5px; margin-top: 5px;">
							<input type="text" id="txtAsOfDate" style="float: left; margin-top: 0px; margin-right: 3px; height: 14px; width: 112px; border: none;" name="txtAsOfDate" readonly="readonly" />
							<img id="imgAsOfDate" alt="imgAsOfDate" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">
						<input type="radio" id="rdoFromTo" name="dateP" checked="checked" style="margin-top: 9px; margin-left: 100px; float: left;"/>
						<label for="rdoFromTo" style="margin-top: 8px; margin-left: 5px; ">From</label>
					</td>
					<td>
						<div id="fromDiv" style="float: left; border: solid 1px gray; width: 140px; height: 20px; margin-left: 5px; margin-top: 5px;">
							<input type="text" id="txtFromDate" style="float: left; margin-top: 0px; margin-right: 3px; height: 14px; width: 112px; border: none;" name="txtFromDate" readonly="readonly" />
							<img id="imgFromDate" alt="imgFromDate" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"/>
						</div>
						<label style="margin-top: 8px; margin-left: 50px; ">To</label>
						<div id="toDiv" style="float: left; border: solid 1px gray; width: 140px; height: 20px; margin-left: 10px; margin-top: 5px;">
							<input type="text" id="txtToDate" style="float: left; margin-top: 0px; margin-right: 3px; height: 14px; width: 112px; border: none;" name="txtToDate" readonly="readonly" />
							<img id="imgToDate" alt="imgToDate" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">
						<label style="float: right;">Payee Class</label>
					</td>
					<td>
						<div id="txtPayeeCdDiv" class="lovSpan" style="width: 84px; margin-top: 2px; margin-left: 5px;">
							<input id="txtPayeeCd" name="txtPayeeCd" type="text" style="border: none; float: left; width: 54px; height: 14px; margin: 0px;" value="" maxlength="2">
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchPayeeCdLOV" name="searchPayeeCdLOV" alt="Go" style="float: right;"/>
						</div>
						<input id="txtPayee" type="text" style="width: 263px; height: 14px; margin-bottom: 0px; margin-left: 1px; float: left;" readonly="readonly" value="">
					</td>
				</tr>
				<tr>
					<td class="rightAligned">
						<label id="lblTaxPayeeLabel" style="float: right;">Tax</label>
					</td>
					<td>
						<div id="divPayee" class="sectionDiv" style="border: none;">
							<div id="txtPayeeNoDiv" class="lovSpan" style="width: 84px; margin-top: 2px; margin-left: 5px;">
								<input id="txtPayeeNo" name="txtPayeeNo" type="text" style="border: none; float: left; width: 54px; height: 14px; margin: 0px;" value="" maxlength="2">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchPayeeNoLOV" name="searchPayeeNoLOV" alt="Go" style="float: right;"/>
							</div>
							<input id="txtPayeeName" type="text" style="width: 263px; height: 14px; margin-bottom: 0px; margin-left: 1px; float: left;" readonly="readonly" value="">
						</div>
						<div id="divTax" class="sectionDiv" style="border: none;">
							<div id="txtTaxCdDiv" class="lovSpan" style="width: 84px; margin-top: 2px; margin-left: 5px;">
								<input id="txtTaxCd" name="txtTaxCd" type="text" style="border: none; float: left; width: 54px; height: 14px; margin: 0px;" value="" maxlength="5">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchTaxCdLOV" name="searchTaxCdLOV" alt="Go" style="float: right;"/>
							</div>
							<input id="txtTaxName" type="text" style="width: 263px; height: 14px; margin-bottom: 0px; margin-left: 1px; float: left;" readonly="readonly" value="">
						</div>
					</td>
				</tr>
			</table>
		</div>
		<div class="sectionDiv" style="width: 120px; height: 160px; margin-left: 2px; margin-top: 1px;">
			<table style="width: 100%; margin-top: 14px; margin-left: 5px;">
				<tr>
					<td>
						<input type="radio" id="rdoWtaxAllPayees" name="wTax" checked="checked" style="float: left;" />
						<label for="rdoWtaxAllPayees" style="margin-top: 3px;">With TIN</label>
					</td>
				</tr>
				<tr>
					<td>
						<input type="radio" id="rdoWtaxPerPayee" name="wTax" style="float: left;" />
						<label for="rdoWtaxPerPayee" style="margin-top: 3px;">W/out TIN</label>
					</td>
				</tr>
				<tr>
					<td>
						<input type="radio" id="rdoByTax" name="wTax" style="float: left;" />
						<label for="rdoByTax" style="margin-top: 3px;">Break by Tax</label>
					</td>
				</tr>
				<tr>
					<td>
						<input type="radio" id="rdoCertificate" name="wTax" style="float: left;" />
						<label for="rdoCertificate" style="margin-top: 3px;">Certificate</label>
					</td>
				</tr>
				<tr>
					<td>
						<label for="rdoCertificate" style="margin-left: 28px;">(FORM 2307)</label>
					</td>
				</tr>
				<tr>
					<td>
						<input type="radio" id="rdoWithForm" name="form2307" checked="checked" style="float: left; margin-left: 14px;" />
						<label id="lblWithForm" for="rdoWithForm" style="margin-top: 3px;">With Form</label>
					</td>
				</tr>
				<tr>
					<td>
						<input type="radio" id="rdoWithoutForm" name="form2307" style="float: left; margin-left: 14px;" />
						<label id="lblWithoutForm" for="rdoWithoutForm" style="margin-top: 3px;">Without Form</label>
					</td>
				</tr>
			</table>
		</div>
		<div class="sectionDiv" style="width: 190px; height: 160px; margin-left: 2px; margin-top: 1px;">
			<div style="margin-top: 55px; margin-left: 5px; width: 180px; float: left;">
				<input type="checkbox" id="chkCDetailed" style="float:left; "/>
				<label for="chkCDetailed">Detailed</label>
			</div>
			<div id="divCExclude" style="margin-top: 20px; margin-left: 5px; width: 180px; float: left;">
				<input type="checkbox" id="chkCExclude" style="float:left; "/>
				<label for="chkCExclude">Exclude Open Transactions</label>
			</div>
		</div>
		<div id="printDiv" style="margin-top: 1px; margin-left: 2px; margin-bottom: 2px; border: 1px solid #E0E0E0; height: 160px; width: 300px; float: left;">
			<table align="center" style="margin-top: 25px;">
				<tr>
					<td class="rightAligned">Destination</td>
					<td class="leftAligned">
						<select id="selDestination" style="width: 200px;" tabindex="305">
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
						<input value="PDF" title="PDF" type="radio" id="rdoPdf" name="fileType" tabindex="306" style="margin: 2px 5px 4px 5px; float: left;" checked="checked" disabled="disabled"><label for="rdoPdf" style="margin: 2px 0 4px 0">PDF</label>
						<!-- nieko 06292016, SR 22531, KB 3574 
						<input value="EXCEL" title="Excel" type="radio" id="rdoExcel" name="fileType" tabindex="307" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="rdoExcel" style="margin: 2px 0 4px 0">Excel</label>
						-->
						<input value="CSV" title="CSV" type="radio" id="csvRB" name="fileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="csvRB" style="margin: 2px 0 4px 0">CSV</label>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Printer</td>
					<td class="leftAligned">
						<select id="selPrinter" style="width: 200px;" class="required" tabindex="308">
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
						<input type="text" id="txtNoOfCopies" tabindex="309" style="float: left; text-align: right; width: 175px;" class="required integerNoNegativeUnformattedNoComma">
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
		<div class="sectionDiv" id="buttonsDiv" style="width: 618px; height: 30px; margin-left: 2px; float: left; border: none;">
			<input type="button" id="btnPrint" class="button" value="Print" style="width: 130px; margin-top: 3px;" />
		</div>
	</div>
</div>
<script type="text/JavaScript">
try{
	setModuleId("GIACS110");
	setDocumentTitle("Print Taxes Withheld from Payees");
	$("txtFromDate").focus();
	
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
				//$("rdoExcel").disable(); nieko 06292016, SR 22531, KB 3574
				$("csvRB").disabled = true;
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
			if(dest == "file"){
				$("rdoPdf").enable();
				//$("rdoExcel").enable(); nieko 06292016, SR 22531, KB 3574
				$("csvRB").disabled = false;
			} else {
				$("rdoPdf").disable();
				//$("rdoExcel").disable(); nieko 06292016, SR 22531, KB 3574
				$("csvRB").disabled = true;
			}							
		}
	}
	
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
	
	toggleRequiredFields("screen");
	
	function showGiacs110PayeeLOV(){
		try {
			var lastPayeeCd = $F("txtPayeeCd");
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getPayeeGiacs110LOV"
				},
				title : "Payee Class",
				width : 370,
				height : 386,
				autoSelectOneRecord: true,
				columnModel : [ {
					id : "payeeClassCd",
					title : "Payee Class Code",
					width : '90px',
				}, 
				{
					id : "classDesc",
					title : "Payee Class Description",
					width : '265px'
				},
				],
				draggable : true,
				onSelect : function(row) {
					$("txtPayeeCd").value = row.payeeClassCd;
					$("txtPayee").value = unescapeHTML2(row.classDesc);
					if(lastPayeeCd != row.payeeClassCd){
						$("txtPayeeNo").clear();
						$("txtPayeeName").value = "ALL PAYEE NAMES"; // names
					}
				}
			});
		} catch (e) {
			showErrorMessage("showGiacs110PayeeLOV", e);
		}
	}
	
	$("searchPayeeCdLOV").observe("click", showGiacs110PayeeLOV);
	
	function showGiacs110TaxLOV(){
		try {
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getTaxGiacs110LOV"
				},
				title : "Tax",
				width : 425,
				height : 386,
				autoSelectOneRecord: true,
				columnModel : [ {
					id : "whtaxId",
					title : "",
					width : '70px',
				}, 
				{
					id : "birTaxCd",
					title : "Tax Code",
					width : '80px'
				},
				{
					id : "whtaxDesc",
					title : "Withholding Tax Description",
					width : '258px'
				}
				],
				draggable : true,
				onSelect : function(row) {
					$("txtTaxCd").value = row.whtaxId;
					$("txtTaxName").value = unescapeHTML2(row.whtaxDesc);
				}
			});
		} catch (e) {
			showErrorMessage("showGiacs110TaxLOV", e);
		}
	}
	
	$("searchTaxCdLOV").observe("click", showGiacs110TaxLOV);
	
	function showGiacs110PayeeNoLOV(){
		try {
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getPayeeNoGiacs110LOV",
					payeeClassCd : $F("txtPayeeCd")
				},
				title : "Payee",
				width : 370,
				height : 386,
				autoSelectOneRecord: true,
				columnModel : [ {
					id : "payeeNo",
					title : "Payee Number",
					width : '90px',
				}, 
				{
					id : "payeeName",
					title : "Payee Name",
					width : '265px'
				},
				],
				draggable : true,
				onSelect : function(row) {
					$("txtPayeeNo").value = row.payeeNo;
					$("txtPayeeName").value = unescapeHTML2(row.payeeName);
				}
			});
		} catch (e) {
			showErrorMessage("showGiacs110PayeeNoLOV", e);
		}
	}
	
	$("searchPayeeNoLOV").observe("click", function(){
		if($F("txtPayeeCd") == ""){
			customShowMessageBox("Please specify Payee Class.", "I", "txtPayeeCd");			
		}else{
			showGiacs110PayeeNoLOV();	
		}
	});
	
	var lastTaxCd = "";
	var lastTaxDesc = "";
	$("txtTaxCd").observe("focus", function(){
		lastTaxCd = $F("txtTaxCd");
		lastTaxDesc = $F("txtTaxName");
	});
	
	$("txtTaxCd").observe("change", function(){
		if($F("txtTaxCd") == ""){
			$("txtTaxName").value = "ALL WITHHOLDING TAXES";
		}else{
			if(isNaN($F("txtTaxCd"))){
				$("txtTaxCd").value = lastTaxCd;
				$("txtTaxName").value = lastTaxDesc;
				customShowMessageBox("Invalid Tax Code. Valid value should be from 1 to 99999.", "I", "txtTaxCd");
			}else{
				new Ajax.Request(contextPath+"/GIACGeneralLedgerReportsController?action=validateTaxCdGiacs110",{
					parameters: {
						whtaxId : $F("txtTaxCd")
					},
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						if(response.responseText == ""){
							$("txtTaxCd").value = lastTaxCd;
							$("txtTaxName").value = lastTaxDesc;
							showGiacs110TaxLOV();
						}else{
							$("txtTaxName").value = response.responseText;
						}
					}
				});	
			}
		}
	});
	
	var lastPayeeNo = "";
	var lastPayeeName = "";
	$("txtPayeeNo").observe("focus", function(){
		lastPayeeNo = $F("txtPayeeNo");
		lastPayeeName = $F("txtPayeeName");
	});
	
	$("txtPayeeNo").observe("change", function(){
		if($F("txtPayeeNo") == ""){
			$("txtPayeeName").value = "ALL PAYEE NAMES"; // names
		}else{
			if(isNaN($F("txtPayeeNo"))){
				$("txtPayeeNo").value = lastPayeeNo;
				$("txtPayeeName").value = lastPayeeName;
				customShowMessageBox("Invalid Payee Number. Valid value should be from 1 to 999999999999.", "I", "txtPayeeNo");
			}else{
				new Ajax.Request(contextPath+"/GIACGeneralLedgerReportsController?action=validatePayeeNoGiacs110",{
					parameters: {
						payeeClassCd : $F("txtPayeeCd"),
						payeeNo : $F("txtPayeeNo")
					},
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						if(response.responseText == ""){
							$("txtPayeeNo").value = lastPayeeNo;
							$("txtPayeeName").value = lastPayeeName;
							$("txtPayeeNo").focus();
							showGiacs110PayeeNoLOV();
						}else{
							$("txtPayeeName").value = response.responseText;
						}
					}
				});	
			}
		}
	});
	
	var lastPayeeCd = "";
	var lastPayee = "";
	$("txtPayeeCd").observe("focus", function(){
		lastPayeeCd = $F("txtPayeeCd");
		lastPayee = $F("txtPayee");
	});
	
	$("txtPayeeCd").observe("change", function(){
		if($F("txtPayeeCd") == ""){
			$("txtPayee").value = "ALL PAYEE CLASSES"; // xxx classes
			$("txtPayeeNo").clear();
			$("txtPayeeName").value = "ALL PAYEE NAMES"; // names
		}else{
			if(isNaN($F("txtPayeeCd"))){
				$("txtPayeeCd").value = lastPayeeCd;
				$("txtPayee").value = lastPayee;
				customShowMessageBox("Invalid Payee Code. Valid value should be from 1 to 99.", "I", "txtPayeeCd");
			}else{
				new Ajax.Request(contextPath+"/GIACGeneralLedgerReportsController?action=validatePayeeCdGiacs110",{
					parameters: {
						payeeCd : $F("txtPayeeCd")
					},
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						if(response.responseText == ""){
							$("txtPayeeCd").value = lastPayeeCd;
							$("txtPayee").value = lastPayee;
							$("txtPayeeCd").focus();
							showGiacs110PayeeLOV();
						}else{
							$("txtPayee").value = response.responseText;
							$("txtPayeeNo").clear();
							$("txtPayeeName").value = "ALL PAYEE NAMES"; // names
						}
					}
				});	
			}
		}
	});
	
	$("txtFromDate").observe("focus", function(){
		validateFromToDate("txtFromDate");	
	});
	$("txtToDate").observe("focus", function(){
		validateFromToDate("txtToDate");	
	});
	
	function validateFromToDate(date){
		if($("rdoFromTo").checked){
			if($F("txtFromDate") != "" && $F("txtToDate") != ""){
				if(Date.parse($F("txtToDate")) < Date.parse($F("txtFromDate"))){
					customShowMessageBox("From Date must not be later than To Date.", "I", date);
					$(date).clear();
					return false;
				}	
			}
		}
	} 
	
	function validatePrintGiacs110(){
		if($("rdoFromTo").checked){
			if($F("txtFromDate") == ""){
				customShowMessageBox(objCommonMessage.REQUIRED, "I", "txtFromDate");
				return false;
			}
			if($F("txtToDate") == ""){
				customShowMessageBox(objCommonMessage.REQUIRED, "I", "txtToDate");
				return false;
			}
		}
		
		if($("rdoAsOf").checked){
			if($F("txtAsOfDate") == ""){
				customShowMessageBox(objCommonMessage.REQUIRED, "I", "txtAsOfDate");
				return false;
			}else{
				printReport("GIACR111", "Withholding Tax Alphalist");	
			}
		}else if($("rdoCertificate").checked){
			if(chkQuartDate()){
				if($("rdoWithForm").checked){ // bonok :: 3.10.2016 :: GENQA SR 4073
					printReport("GIACR112A", "Form 2307 - Certificate of Creditable Tax Withheld at Source");
				}else{
					printReport("GIACR112", "Form 2307 - Certificate of Creditable Tax Withheld at Source");	
				}
			}
		}else{
			if($("chkCDetailed").checked){
				if($("rdoWtaxAllPayees").checked){
					printReport("GIACR256", "Tax Withheld from All Payees - Detailed");
				}else if($("rdoWtaxPerPayee").checked){
					printReport("GIACR255", "WITHHOLDING TAX REPORT BY TAX");
				}else if($("rdoByTax").checked){
					printReport("GIACR254", "WITHHOLDING TAX REPORT BY TAX");
				}
			}else{
				if($("rdoWtaxAllPayees").checked){
					printReport("GIACR110", "Withholding Tax for All Payees");
				}else if($("rdoWtaxPerPayee").checked){
					printReport("GIACR107", "Withholding Tax");
				}else if($("rdoByTax").checked){
					printReport("GIACR253", "WITHHOLDING TAX REPORT BY TAX SUMMARY");
				}
			}
		}
	}
	
	function printReport(reportId, reportTitle){
		try {
			var content = contextPath + "/GeneralLedgerPrintController?action=printReport&reportId="+reportId+getParams();
			if("screen" == $F("selDestination")){
				showPdfReport(content, reportTitle);
			}else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					parameters : {noOfCopies : $F("txtNoOfCopies"),
								  printerName : $F("selPrinter")
								 },
					evalScripts: true,
					asynchronous: true,
					onCreate: showNotice("Processing, please wait..."),				
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							showMessageBox("Printing Completed.", "S");
						}
					}
				});
			}else if("file" == $F("selDestination")){
				var fileType = "PDF";
				
				if($("rdoPdf").checked)
					fileType = "PDF";
				//else if ($("rdoExcel").checked)
				//	fileType = "XLS"; nieko 06292016, SR 22531, KB 3574
				else if ($("csvRB").checked)
					fileType = "CSV";
				
				new Ajax.Request(content, {
					method: "POST",
					parameters : {destination : "FILE",
				         	      fileType    : fileType},
					evalScripts: true,
					asynchronous: true,
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							if ($("csvRB").checked){
								copyFileToLocal(response, "csv");
								deleteCSVFileFromServer(response.responseText);
							}else
								copyFileToLocal(response);
						}
					}
				});
			}else if("local" == $F("selDestination")){
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
			showErrorMessage("GIACS108 printReport", e);
		}
	}
	
	function getParams(reportId){
		var params = "&moduleId=GIACS110" + "&asOfDate=" + $F("txtAsOfDate") + "&fromDate=" + $F("txtFromDate") + "&toDate=" + $F("txtToDate")
					 + "&postTran=" + ($("chkCPostDate").checked ? "P" : "T") + "&excludeTag=" + ($("chkCExclude").checked ? "O" : "")
					 + "&payeeClassCd=" + $F("txtPayeeCd") + "&payeeNo=" + $F("txtPayeeNo") + "&taxCd=" + $F("txtTaxCd");
		return params;
	}
	
	function chkQuartDate(){
		if($F("txtFromDate") == ""){
			customShowMessageBox("Fill-up From Date first.", "E", "txtFromDate");
			return false;
		}else if($F("txtToDate") == ""){
			customShowMessageBox("Fill-up To Date first.", "E", "txtToDate");
			return false;
		}
		
		var fromYear = $F("txtFromDate").substring(8,10);
		var toYear = $F("txtToDate").substring(8,10);
		
		if(fromYear != toYear){
			showMessageBox("From Date and To Date must belong to same year.", "I");
			return false;
		}
		
		var fromMonth = $F("txtFromDate").substring(0,2);
		var toMonth = $F("txtToDate").substring(0,2);
		
		var q1 = getQuarter(fromMonth);
		var q2 = getQuarter(toMonth);
		
		if(q1 != q2){
			showMessageBox("From Date and To Date must belong to same quarter of the year.", "I");
			return false;
		}
		
		return true;
	}
	
	function getQuarter(month){
		var quarter;
		if(month >= 1 && month <= 3){
			quarter = 1;
		}else if(month >= 4 && month <= 6){
			quarter = 2;
		}else if(month >= 7 && month <= 9){
			quarter = 3;
		}else if(month >= 10 && month <= 12){
			quarter = 4;
		}
		return quarter;
	}
	
	$("btnPrint").observe("click", validatePrintGiacs110);
	
	function disableAsOfDate(disabled){
		if(disabled){
			$("txtAsOfDate").removeClassName("required");
			$("txtAsOfDate").addClassName("disabled");
			disableDate("imgAsOfDate");
			$("asOfDiv").removeClassName("required");
			$("asOfDiv").addClassName("disabled");
		}else{
			$("txtAsOfDate").removeClassName("disabled");
			$("txtAsOfDate").addClassName("required");
			enableDate("imgAsOfDate");
			$("asOfDiv").removeClassName("disabled");
			$("asOfDiv").addClassName("required");
		}
	}
	
	function disableFromToDate(disabled){
		if(disabled){
			$("txtFromDate").removeClassName("required");
			$("txtToDate").removeClassName("required");
			$("txtFromDate").addClassName("disabled");
			$("txtToDate").addClassName("disabled");
			disableDate("imgFromDate");
			disableDate("imgToDate");
			$("fromDiv").removeClassName("required");
			$("toDiv").removeClassName("required");	
			$("fromDiv").addClassName("disabled");
			$("toDiv").addClassName("disabled");	
		}else{
			$("txtFromDate").removeClassName("disabled");
			$("txtToDate").removeClassName("disabled");
			$("txtFromDate").addClassName("required");
			$("txtToDate").addClassName("required");
			enableDate("imgFromDate");
			enableDate("imgToDate");
			$("fromDiv").removeClassName("disabled");
			$("toDiv").removeClassName("disabled");
			$("fromDiv").addClassName("required");
			$("toDiv").addClassName("required");
		}
	}
	
	function disablePayeeNo(disabled){
		if(disabled){
			$("txtPayeeNo").addClassName("disabled");
			$("txtPayeeNoDiv").addClassName("disabled");
			$("txtPayeeName").addClassName("disabled");	
			disableSearch("searchPayeeNoLOV");
		}else{
			$("txtPayeeNo").removeClassName("disabled");
			$("txtPayeeNoDiv").removeClassName("disabled");
			$("txtPayeeName").removeClassName("disabled");
			enableSearch("searchPayeeNoLOV");
		}
	}
	
	function disablePayeeCd(disabled){
		if(disabled){
			$("txtPayeeCd").addClassName("disabled");
			$("txtPayeeCdDiv").addClassName("disabled");
			$("txtPayee").addClassName("disabled");	
			disableSearch("searchPayeeCdLOV");
		}else{
			$("txtPayeeCd").removeClassName("disabled");
			$("txtPayeeCdDiv").removeClassName("disabled");
			$("txtPayee").removeClassName("disabled");
			enableSearch("searchPayeeCdLOV");
		}
	}
	
	function disableTax(disabled){
		if(disabled){
			$("txtTaxCd").addClassName("disabled");
			$("txtTaxName").addClassName("disabled");
			$("txtTaxCdDiv").addClassName("disabled");
			disableSearch("searchTaxCdLOV");		
		}else{
			$("txtTaxCd").removeClassName("disabled");
			$("txtTaxName").removeClassName("disabled");
			$("txtTaxCdDiv").removeClassName("disabled");
			enableSearch("searchTaxCdLOV");		
		}
	}
	
	function disableWtax(disabled){
		$("rdoWtaxAllPayees").disabled = disabled;
		$("rdoWtaxPerPayee").disabled = disabled;
		$("rdoByTax").disabled = disabled;
		$("rdoCertificate").disabled = disabled;
	}
	
	$("rdoAsOf").observe("click", function(){
		disableFromToDate(true);
		disablePayeeNo(true);
		disablePayeeCd(true);
		disableTax(true);
		disableWtax(true);
		$("chkCDetailed").disabled = true;
		disableAsOfDate(false);
		$("txtAsOfDate").focus();
	});
	
	$("rdoFromTo").observe("click", function(){
		if($("rdoByTax").checked){
			toggleMiscWtaxNot4();
			disableTax(false);
		}else if($("rdoCertificate").checked){
			toggleMiscWtax4();
		}else{
			toggleMiscWtaxNot4();
			disableTax(false); //Modified by Jerome 09.26.2016 SR 5671
		}
		disablePayeeCd(false);
		disableFromToDate(false);
		disableWtax(false);
		disableAsOfDate(true);
		$("txtFromDate").focus();
	});
	
	function toggleMiscWtaxNot4(){
		if($("chkCPostDate").checked){
			$("chkCDetailed").disabled = false;
			$("divCExclude").hide();
			$("divPayee").hide();
			$("divTax").show();
			$("lblTaxPayeeLabel").innerHTML = "Tax";
		}else if($("chkCTranDate").checked){
			$("chkCDetailed").disabled = false;
			$("chkCExclude").disabled = false;
			$("divCExclude").show();
			$("divPayee").hide();
			$("divTax").show();
			$("lblTaxPayeeLabel").innerHTML = "Tax";
		}
	}
	
	// bonok :: 3.18.2016 :: GENQA SR 4073
	function showForm2307(show){
		if(show){
			$("rdoWithForm").show();
			$("lblWithForm").show();
			$("rdoWithoutForm").show();
			$("lblWithoutForm").show();
		}else{
			$("rdoWithForm").hide();
			$("lblWithForm").hide();
			$("rdoWithoutForm").hide();
			$("lblWithoutForm").hide();
		}
	}
	
	$("rdoByTax").observe("click", function(){
		toggleMiscWtaxNot4();
		disableTax(false);
		enableSearch("searchTaxCdLOV");
		$("txtPayee").removeClassName("disabled");
		showForm2307(false); // bonok :: 3.18.2016 :: GENQA SR 4073
	});
	
	function toggleMiscWtax4(){
		$("chkCDetailed").disabled = true;
		$("chkCExclude").disabled = true;
		$("divTax").hide();
		$("divPayee").show();
		$("lblTaxPayeeLabel").innerHTML = "Payee";
		disablePayeeNo(false);
		if($("rdoCertificate").checked){ // bonok :: 3.10.2016 :: GENQA SR 4073
			showForm2307(true);
		}else{
			showForm2307(false);
		}
	}
	
	$("rdoCertificate").observe("click", toggleMiscWtax4);
	
	function toggleWtax(){
		toggleMiscWtaxNot4();
		disableTax(false); //Modified by Jerome 09.26.2016 SR 5671
		showForm2307(false); // bonok :: 3.10.2016 :: GENQA SR 4073
	}
	
	$("rdoWtaxAllPayees").observe("click", toggleWtax);
	$("rdoWtaxPerPayee").observe("click", toggleWtax);
	
	$("chkCPostDate").observe("click", function(){
		if($("chkCPostDate").checked){
			$("chkCTranDate").checked = false;
			$("chkCExclude").checked = false;
			$("divCExclude").hide();
			$("chkCExclude").disabled = true;
		}else{
			$("chkCTranDate").checked = true;
			if($("rdoCertificate").checked){
				$("divCExclude").show();
				$("chkCExclude").disabled = true;	
			}else{
				$("divCExclude").show();
				$("chkCExclude").disabled = false;
			}
		}
	});
	
	$("chkCTranDate").observe("click", function(){
		if($("chkCTranDate").checked){
			$("chkCPostDate").checked = false;
			if($("rdoCertificate").checked){
				$("divCExclude").show();
				$("chkCExclude").disabled = true;
			}else{
				$("divCExclude").show();
				$("chkCExclude").disabled = false;
			}
		}else{
			$("chkCPostDate").checked = true;
			$("divCExclude").hide();
			$("chkCExclude").disabled = true;
		}
	});
	
	$("imgAsOfDate").observe("click", function(){
		scwShow($("txtAsOfDate"),this, null);
	});
	
	$("imgFromDate").observe("click", function(){
		scwShow($("txtFromDate"),this, null);
	});
	
	$("imgToDate").observe("click", function(){
		scwShow($("txtToDate"),this, null);
	});
	
	$("txtPayee").value = "ALL PAYEE CLASSES";
	$("txtPayeeName").value = "ALL PAYEE NAMES";
	$("txtTaxName").value = "ALL WITHHOLDING TAXES";
	$("chkCTranDate").checked = true;
	$("chkCDetailed").checked = true;
	disablePayeeNo(true);
	disableAsOfDate(true);
	disableFromToDate(false);
	showForm2307(false); // bonok :: 3.10.2016 :: GENQA SR 4073
	$("divPayee").hide();
	$("txtFromDate").focus();
	observeReloadForm("reloadForm", showGIACS110);
}catch(e){
	showErrorMessage("Print Taxes Withheld from Payees page", e);
}
</script>