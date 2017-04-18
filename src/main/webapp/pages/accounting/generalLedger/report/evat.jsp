<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="evatMainDiv" class="sectionDiv" style="height: 455px;">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>EVAT</label>
			<span class="refreshers" style="margin-top: 0;">
		 		<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>
	<div id="groDiv" name="groDiv" style="float: none; width: 100%;">	
		<div class="sectionDiv" style="width: 500px; margin-left: 205px; margin-top: 50px;">
			<div class="sectionDiv" style="margin-top: 2px; margin-left: 2px; height: 35px; width: 494px;">
				<table>
					<tr>
						<td>
							<label for="chkPosting" style="margin-top: 7px; margin-left: 95px;">Posting Date</label>
							<input type="checkbox" id="chkPosting" style="margin-top: 7px; margin-left: 10px; float: left;">	
							<label for="chkTransaction" style="margin-top: 7px; margin-left: 100px;">Tran Date</label>
							<input type="checkbox" id="chkTransaction" style="margin-top: 7px; margin-left: 10px; float: left;">
						</td>
					</tr>
				</table>
			</div>
			<div class="sectionDiv" style="margin-top: 2px; margin-left: 2px; height: 120px; width: 494px;">
				<table width="100%" style="margin-top: 10px;">
					<tr>
						<td>
							<label style="margin-top: 9px; margin-left: 70px;">From</label>	
							<div id="txtTranDate1Div" class="required" style="float: left; border: solid 1px gray; width: 140px; height: 20px; margin-left: 10px; margin-top: 5px;">
								<input type="text" id="txtTranDate1" class="required" style="float: left; margin-top: 0px; margin-right: 3px; width: 112px; border: none;" name="txtTranDate1" readonly="readonly" />
								<img id="imgTranDate1" alt="imgTranDate1" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"/>
							</div>
							<label style="margin-top: 9px; margin-left: 10px;">To</label>	
							<div id="txtTranDate2Div" class="required" style="float: left; border: solid 1px gray; width: 140px; height: 20px; margin-left: 10px; margin-top: 5px;">
								<input type="text" id="txtTranDate2" class="required" style="float: left; margin-top: 0px; margin-right: 3px; width: 112px; border: none;" name="txtTranDate1" readonly="readonly" />
								<img id="imgTranDate2" alt="imgTranDate2" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"/>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<label style="margin-left: 59px; margin-top: 6px;">Branch</label>
							<div id="txtIssCdDiv" class="lovSpan" style="width: 84px; margin-top: 2px; margin-left: 10px;">
								<input id="txtIssCd" name="txtDspIssCd" type="text" style="border: none; float: left; width: 54px; height: 14px; margin: 0px;" value="" maxlength="2">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranchLOV" name="searchBranchLOV" alt="Go" style="float: right;"/>
							</div>
							<input id="txtIssName" type="text" style="width: 223px; height: 14px; margin-bottom: 0px; margin-left: 1px; float: left;" readonly="readonly" value="">
						</td>
					</tr>
					<tr>
						<td>
							<label style="margin-left: 76px; margin-top: 6px;">Line</label>
							<div id="txtLineCdDiv" class="lovSpan" style="width: 84px; margin-top: 2px; margin-left: 10px;">
								<input id="txtLineCd" name="txtLineCd" type="text" style="border: none; float: left; width: 54px; height: 14px; margin: 0px;" value="" maxlength="2">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineLOV" name="searchLineLOV" alt="Go" style="float: right;"/>
							</div>
							<input id="txtLineName" type="text" style="width: 223px; height: 14px; margin-bottom: 0px; margin-left: 1px; float: left;" readonly="readonly" value="">
						</td>
					</tr>
				</table>
			</div>
			<div id="printDiv" style="margin-top: 2px; margin-left: 2px; margin-bottom: 2px; border: 1px solid #E0E0E0; height: 130px; width: 300px; float: left;">
				<table align="center" style="margin-top: 10px;">
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
							<input value="EXCEL" title="Excel" type="radio" id="rdoExcel" name="fileType" tabindex="307" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="rdoExcel" style="margin: 2px 0 4px 0">Excel</label>
							<input value="CSV" title="CSV" type="radio" id="rdoCsv" name="fileType" tabindex="307" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="rdoCsv" style="margin: 2px 0 4px 0">CSV</label>
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
			<div class="sectionDiv" style="margin-top: 2px; margin-left: 2px; height: 130px; width: 190px;">
				<input type="button" class="button" id="btnPrint" value="Print" style="margin-top: 50px; width: 130px;"/>	
			</div>
		</div>
	</div>
</div>
<script type="text/JavaScript">
try{
	initializeAll();
	initializeAccordion();
	setModuleId("GIACS108");
	setDocumentTitle("EVAT");
	
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
				$("rdoExcel").disable();
				$("rdoCsv").disabled = true;
		} else {
			if(dest == "file"){
				$("rdoPdf").enable();
				$("rdoExcel").enable();
				$("rdoCsv").disabled = false;
			} else {
				$("rdoPdf").disable();
				$("rdoExcel").disable();
				$("rdoCsv").disabled = true;
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
	
	$("imgSpinUp").observe("click", function(){
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		if(no < 100){
			$("txtNoOfCopies").value = no + 1;
		}
	});
	
	$("imgSpinDown").observe("click", function(){
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		if(no > 1){
			$("txtNoOfCopies").value = no - 1;
		}
	});
	
	$("txtNoOfCopies").observe("change", function(){
		if($F("txtNoOfCopies").trim() != "" && (isNaN($F("txtNoOfCopies")) || parseInt($F("txtNoOfCopies")) <= 0 || parseInt($F("txtNoOfCopies")) > 100)){
			showWaitingMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "I", function(){
				$("txtNoOfCopies").value = "";
			});			
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
	
	$("txtIssCd").observe("keyup", function(){
		$("txtIssCd").value = $("txtIssCd").value.toUpperCase();; 	
	});
	
	$("txtLineCd").observe("keyup", function(){
		$("txtLineCd").value = $("txtLineCd").value.toUpperCase();; 	
	});

	$("txtTranDate1").observe("focus", function(){
		validateTranDate("txtTranDate1");	
	});
	
	$("txtTranDate2").observe("focus", function(){
		validateTranDate("txtTranDate2");	
	});
	
	function validateTranDate(tranDate){
		if($F("txtTranDate1") != "" && $F("txtTranDate2") != ""){
			if(Date.parse($F("txtTranDate2")) < Date.parse($F("txtTranDate1"))){
				customShowMessageBox("From Date should be earlier than To Date.", "I", tranDate);
				$(tranDate).clear();
				return false;
			}
		}
	}
	
	function validatePrintGiacs108(){
		if($("chkPosting").checked == false && $("chkTransaction").checked == false){
			customShowMessageBox("Please specify if Posting or Transaction date will be used.", "I", "chkPosting");
			return false;
		}
		if($F("txtTranDate1") == "" && $F("txtTranDate2") == ""){
			customShowMessageBox("Please specify the period covered.", "I", "txtTranDate1");
			return false;
		}
		if($F("txtTranDate1") == ""){
			customShowMessageBox("Please enter From Date.", "I", "txtTranDate1");
			return false;
		}
		if($F("txtTranDate2") == ""){
			customShowMessageBox("Please enter To Date.", "I", "txtTranDate2");
			return false;
		}
		printReport();
	}
	
	function printReport(){
		try {
			var content = contextPath + "/GeneralLedgerPrintController?action=printReport" + getParams();
			if("screen" == $F("selDestination")){
				showPdfReport(content, "EVAT for other Lines");
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
							
						}
					}
				});
			}else if("file" == $F("selDestination")){
				var fileType = "PDF";
				
				if($("rdoPdf").checked)
					fileType = "PDF";
				else if ($("rdoExcel").checked)
					fileType = "XLS";
				else if ($("rdoCsv").checked)
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
							if ($("rdoCsv").checked){
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
	
	function getParams(){
		var params = "";
		params = params + "&reportId=GIACR109" + "&moduleId=GIACS108"
				        + "&tranDate1=" + $F("txtTranDate1") + "&tranDate2=" + $F("txtTranDate2")
				        + "&lineCd=" + $F("txtLineCd") + "&branchCd=" + $F("txtIssCd")
				        + "&postTran=" + ($("chkPosting").checked == true ? "P" : "T");
		return params;						        
	}
	
	$("btnPrint").observe("click", validatePrintGiacs108);
	
	$("chkPosting").observe("click", function(){
		if($("chkPosting").checked){
			$("chkTransaction").checked = false;		
		}
	});
	
	$("chkTransaction").observe("click", function(){
		if($("chkTransaction").checked){
			$("chkPosting").checked = false;		
		}
	});
	
	$("txtIssCd").observe("change", function(){
		if($F("txtIssCd") != ""){
			new Ajax.Request(contextPath+"/GICLBrdrxClmsRegisterController?action=validateIssCdGicls202",{
				parameters: {
					issCd : $F("txtIssCd")
				},
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if(response.responseText == ""){
						$("txtIssCd").clear();
						$("txtIssCd").focus();
						showGiacs108BranchLOV();
					}else{
						$("txtIssName").value = response.responseText;
					}
				}
			});
		}else{
			$("txtIssName").value = "ALL BRANCHES";
		}
	});
	
	$("txtLineCd").observe("change", function(){
		if($F("txtLineCd") != ""){
			new Ajax.Request(contextPath+"/GICLBrdrxClmsRegisterController?action=validateLineCdGicls202",{
				parameters: {
					lineCd : $F("txtLineCd")
				},
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if(response.responseText == ""){
						$("txtLineCd").clear();
						$("txtLineCd").focus();
						showGiacs108LineLOV();
					}else{
						$("txtLineName").value = response.responseText;
					}
				}
			});
		}else{
			$("txtLineName").value = "ALL LINES";
		}
	});
	
	function showGiacs108BranchLOV(){
		try {
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getBranchGiacs108LOV",
					moduleId : "GIACS108"
				},
				title : "Valid values for Branches",
				width : 370,
				height : 386,
				autoSelectOneRecord: true,
				columnModel : [ {
					id : "issCd",
					title : "Branch Code",
					width : '90px',
				}, 
				{
					id : "issName",
					title : "Branch Name",
					width : '265px'
				},
				],
				draggable : true,
				onSelect : function(row) {
					$("txtIssCd").value = row.issCd;
					$("txtIssName").value = unescapeHTML2(row.issName);
				}
			});
		} catch (e) {
			showErrorMessage("showGiacs108BranchLOV", e);
		}
	}
	
	$("searchBranchLOV").observe("click", showGiacs108BranchLOV);
	
	function showGiacs108LineLOV(){
		try {
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getLineGiacs108LOV"
				},
				title : "Valid values for Lines",
				width : 370,
				height : 386,
				autoSelectOneRecord: true,
				columnModel : [ {
					id : "lineCd",
					title : "Line Code",
					width : '90px',
				}, 
				{
					id : "lineName",
					title : "Line Name",
					width : '265px'
				},
				],
				draggable : true,
				onSelect : function(row) {
					$("txtLineCd").value = row.lineCd;
					$("txtLineName").value = unescapeHTML2(row.lineName);
				}
			});
		} catch (e) {
			showErrorMessage("showGiacs108LineLOV", e);
		}
	}
	
	$("searchLineLOV").observe("click", showGiacs108LineLOV);
	
	$("imgTranDate1").observe("click", function(){
		scwShow($("txtTranDate1"),this, null);
	});
	
	$("imgTranDate2").observe("click", function(){
		scwShow($("txtTranDate2"),this, null);
	});
	
	$("chkTransaction").checked = true;
	$("txtIssName").value = "ALL BRANCHES";
	$("txtLineName").value = "ALL LINES";
	
	observeReloadForm("reloadForm", showGIACS108);
}catch(e){
	showErrorMessage("GIACS108 - EVAT page", e);
}
</script>