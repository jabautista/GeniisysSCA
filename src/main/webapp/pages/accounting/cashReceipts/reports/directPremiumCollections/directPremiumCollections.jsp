<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="directPremCollectionstDiv">
	<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
		<label>Direct Premium Collections</label>
		<span class="refreshers" style="margin-top: 0;">
 			<label id="btnReloadForm" name="gro" style="margin-left: 5px;">Reload Form</label>
		</span>
	</div>
</div>
	<div class="sectionDiv" style="padding-bottom: 20px;" >
		<div style="margin: 0 auto; width: 500px;">
			<div style="border: 1px solid #E0E0E0; margin-top: 30px; padding: 15px 0;">
				<table align="center">
					<tr>
						<td><label for="chkPostingDate" style="margin-left: 40px;">Posting Date</label></td>
						<td><input type="checkbox" id="chkPostingDate" style="margin-left: 40px; margin-right: 40px;" tabindex="101"/></td>
						<td><label for="chkTranDate">Transaction Date</label></td>
						<td><input type="checkbox" id="chkTranDate" style="margin-left: 40px; margin-right: 40px;" tabindex="102"/></td>
					</tr>
				</table>
			</div>
			<div style="border: 1px solid #E0E0E0; margin-top: 2px; padding: 15px 0;">
				<table align="center">
					<tr>
						<td><label for="txtFromDate" style="float: right;">From</label></td>
						<td style="padding-left: 5px;">
							<div style="float: left; width: 140px; height: 20px; margin: 0;" class="withIconDiv required">
								<input type="text" id="txtFromDate" class="withIcon required" readonly="readonly" style="width: 116px;" tabindex="201"/>
								<img id="imgFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="" style="margin : 1px 1px 0 0; cursor: pointer"/>
							</div>
						</td>
						<td><label for="txtToDate" style="float: right; margin-left: 10px;">To</label></td>
						<td style="padding-left: 5px;">
							<div style="float: left; width: 140px; height: 20px; margin: 0;" class="withIconDiv required">
								<input type="text" id="txtToDate" class="withIcon required" readonly="readonly" style="width: 116px;" tabindex="202"/>
								<img id="imgToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="" style="margin : 1px 1px 0 0; cursor: pointer"/>
							</div>
						</td>
					</tr>
					<tr>
						<td><label for="txtLineCd" style="float: right;">Line</label></td>
						<td style="padding-left: 5px;" colspan="3">
							<span class="lovSpan" style="width: 70px; margin-bottom: 0;">
								<input type="text" id="txtLineCd" style="width: 45px; float: left;" class="withIcon allCaps"  maxlength="3"  tabindex="204"/>  
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgLineCd" alt="Go" style="float: right;" />
							</span>
							<input type="text" id="txtLineName" readonly="readonly" style="margin: 0; height: 14px; width: 237px; margin-left: 2px;" tabindex="205"/>
						</td>
					</tr>
					<tr>
						<td><label for="txtBranchCd" style="float: right;">Branch</label></td>
						<td style="padding-left: 5px;" colspan="3">
							<span class="lovSpan" style="width: 70px; margin-bottom: 0;">
								<input type="text" id="txtBranchCd" style="width: 45px; float: left;" class="withIcon allCaps"  maxlength="2"  tabindex="206"/>  
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgBranchCd" alt="Go" style="float: right;" />
							</span>
							<input type="text" id="txtBranchName" readonly="readonly" style="margin: 0; height: 14px; width: 237px; margin-left: 2px;" tabindex="207"/>
						</td>
					</tr>
				</table>
			</div>
			<div id="printDiv" style="border: 1px solid #E0E0E0; margin-top: 2px; padding: 15px 0;">
				<table align="center">
					<tr>
						<td class="rightAligned">Destination</td>
						<td class="leftAligned">
							<select id="selDestination" style="width: 200px;" tabindex="301">
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
							<input value="PDF" title="PDF" type="radio" id="rdoPdf" name="fileType" tabindex="302" style="margin: 2px 5px 4px 5px; float: left;" checked="checked" disabled="disabled"><label for="rdoPdf" style="margin: 2px 0 4px 0">PDF</label>
							<!-- modified by gab 06.29.2016 SR 22493 -->
							<!-- <input value="EXCEL" title="Excel" type="radio" id="rdoExcel" name="fileType" tabindex="303" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="rdoExcel" style="margin: 2px 0 4px 0">Excel</label> -->
							<input value="CSV" title="CSV" type="radio" id="rdoCSV" name="fileType" tabindex="303" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="rdoCSV" style="margin: 2px 0 4px 0">CSV</label>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Printer</td>
						<td class="leftAligned">
							<select id="selPrinter" style="width: 200px;" class="required" tabindex="304">
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
							<input type="text" id="txtNoOfCopies" tabindex="305" style="float: left; text-align: right; width: 175px;" class="required integerNoNegativeUnformattedNoComma">
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
			<div>
				<input type="button" class="button" value="Print" tabindex="401" id="btnPrint" style="width: 120px; margin: 15px auto;"/>
			</div>
		</div>
	</div>
</div>
<script>
	try {
		
		
		var onLOV = false;
		var checkLine = "";
		var checkBranch = "";
		
		function initGIACS178(){
			setModuleId("GIACS178");
			setDocumentTitle("Direct Premium Collections");
			$("chkTranDate").checked = true;
			$("txtLineName").value = "ALL LINES";
			$("txtBranchName").value = "ALL BRANCHES";
		}
		
		function resetForm() {
			onLOV = false;
			
			$("chkTranDate").checked = true;
			$("chkPostingDate").checked = false;
			$("txtFromDate").clear();
			$("txtToDate").clear();
			$("txtLineCd").clear();
			$("txtLineName").value = "ALL LINES";
			$("txtBranchCd").clear();
			$("txtBranchName").value = "ALL BRANCHES";
			$("selDestination").selectedIndex = 0;
			toggleRequiredFields("screen");
			checkLine = "";
			checkBranch = "";
		}
		
		$("btnReloadForm").observe("click", resetForm);
		//$("btnReloadForm").observe("click", showGIACS178);
		
		function getGIACS178LineCdLOV() {
			if(onLOV) return;
			onLOV = true;
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getLineCdLOV",
					searchString : $F("txtLineCd") != checkLine ? $F("txtLineCd") : "",
					page : 1
				},
				title : "List of Line",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "lineCd",
					title : "Line Code",
					width : '120px',
				}, {
					id : "lineName",
					title : "Line Name",
					width : '345px',
					renderer: function(value) {
						return unescapeHTML2(value);
					}
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText:  $F("txtLineCd") != checkLine ? $F("txtLineCd") : "",
				onSelect : function(row) {
					onLOV = false;
					$("txtLineCd").value = row.lineCd;
					$("txtLineName").value = row.lineName;
					$("txtBranchCd").focus();
					checkLine = row.lineCd;
				},
				onCancel : function () {
					onLOV = false;
					$("txtLineCd").value = checkLine;
					$("txtLineCd").focus();
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtLineCd");
					onLOV = false;
					$("txtLineCd").value = checkLine;
				}
			});
		}
		
		function getGIACS178BranchLOV() {
			if(onLOV) return;
			onLOV = true;
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGIACS178BranchLOV",
					searchString : $F("txtBranchCd") != checkBranch ? $("txtBranchCd").value : "",
					moduleId: 'GIACS178',
					page : 1
				},
				title : "Valid Values for Branches",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "branchCd",
					title : "Code",
					width : '120px',
				}, {
					id : "branchName",
					title : "Branch Name",
					width : '345px',
					renderer: function(value) {
						return unescapeHTML2(value);
					}
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText:  $F("txtBranchCd") != checkBranch ? $("txtBranchCd").value : "",
				onSelect : function(row) {
					onLOV = false;
					$("txtBranchCd").value = row.branchCd;
					$("txtBranchName").value = row.branchName;
					checkBranch = row.branchCd;
				},
				onCancel : function () {
					onLOV = false;
					$("txtBranchCd").value = checkBranch;
					$("txtBranchCd").focus();
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtBranchCd");
					onLOV = false;
					$("txtBranchCd").value = checkBranch;
				}
			});
		}
		
		$("imgLineCd").observe("click", getGIACS178LineCdLOV);
		$("imgBranchCd").observe("click", getGIACS178BranchLOV);
		
		$("txtLineCd").observe("change", function(){
			if(this.value.trim() == ""){
				this.clear();
				checkLine = "";
				$("txtLineName").value = "ALL LINES";
			} else {
				getGIACS178LineCdLOV();	
			}
		});
		
		$("txtBranchCd").observe("change", function(){
			if(this.value.trim() == ""){
				this.clear();
				checkBranch = "";
				$("txtBranchName").value = "ALL BRANCHES";
			} else {
				getGIACS178BranchLOV();	
			}
		});

		$("chkTranDate").observe("click", function(){
			if(this.checked)
				$("chkPostingDate").checked = false;
			else
				$("chkPostingDate").checked = true;
		});
		
		$("chkPostingDate").observe("click", function(){
			if(this.checked)
				$("chkTranDate").checked = false;
			else
				$("chkTranDate").checked = true;
		});
		
		$("imgFromDate").observe("click", function(){
			scwShow($("txtFromDate"), this, null);
		});
		
		$("imgToDate").observe("click", function(){
			scwShow($("txtToDate"), this, null);
		});
		
		$("txtFromDate").observe("focus", function(){
			if ($("imgFromDate").disabled == true) return;
			
			var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g,"/")) :"";
			var sysdate = new Date();
			var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g,"/")) :"";
			
			if (fromDate > sysdate && fromDate != ""){
				customShowMessageBox("Date should not be greater than the current date.", "I", "txtFromDate");
				$("txtFromDate").clear();
				return false;
			}
			
			if (toDate < fromDate && toDate != ""){
				customShowMessageBox("From Date should be earlier than To Date.", "I", "txtFromDate");
				$("txtFromDate").clear();
				return false;
			}
		});
	 	
	 	$("txtToDate").observe("focus", function(){
			if ($("imgToDate").disabled == true) return;
			
			var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g,"/")) :"";
			var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g,"/")) :"";
			var sysdate = new Date();
			
			if (toDate > sysdate && toDate != ""){
				customShowMessageBox("Date should not be greater than the current date.", "I", "txtToDate");
				$("txtToDate").clear();
				return false;
			}
			
			if (toDate < fromDate && toDate != ""){
				customShowMessageBox("From Date should be earlier than To Date.", "I", "txtToDate");
				$("txtToDate").clear();
				return false;
			}
		});
		
		//modified by gab 06.29.2016 SR 22493
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
					//$("rdoExcel").disable();
					$("rdoCSV").disable();				
			} else {
				if(dest == "file"){
					$("rdoPdf").enable();
					//$("rdoExcel").enable();
					$("rdoCSV").enable();
				} else {
					$("rdoPdf").disable();
					//$("rdoExcel").disable();
					$("rdoCSV").disable();
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
		
		$("txtLineCd").observe("focus", function(){
			if($("txtBranchCd").value != ""){
				var response = validateField("/GIACBranchController","validateGIACS178BranchCd");
				if(response == "ERROR") {
					customShowMessageBox("Invalid Branch Code", "E", "txtBranchCd");
					$("txtBranchCd").clear();
				} else {
					$("txtBranchName").value = unescapeHTML2(response);
				}
			}
		});
		
		function validateField(controller, action) {
			var ajaxResponse = "";
			var lineCd = $("txtLineCd").value;
			var branchCd = $("txtBranchCd").value;
			
			new Ajax.Request(contextPath + controller,{
				method: "POST",
				parameters: {
						     action : action,
						     lineCd : lineCd,
						     branchCd : branchCd,
						     moduleId : "GIACS178"
				},
				asynchronous: false,
				onComplete : function(response){
					if(checkErrorOnResponse(response)){
						ajaxResponse = trim(response.responseText);
					}
				}
			});
			
			return ajaxResponse;
		}
		
		function getParams(){
			var dateOpt = $("chkTranDate").checked ? "T" : "P";
			var params = "&lineCd=" + $("txtLineCd").value
						+ "&branchCd=" + $("txtBranchCd").value
						+ "&tranPost=" + dateOpt
						+ "&fromDate=" + $("txtFromDate").value
						+ "&toDate=" + $("txtToDate").value;
			return params;
		}
		
		function printReport(){
			try {
				//added by gab 06.27.2016 SR 22493
				var reportParam = 'GIACR178';
				if ("file" == $F("selDestination")) {
					if($("rdoCSV").checked){
						reportParam = 'GIACR178_CSV';
					}
				}
				var content = contextPath + "/CashReceiptsReportPrintController?action=printReport"
						                  //+ "&reportId=" + "GIACR178"
						                  + "&reportId=" + reportParam //modified by gab 06.27.2016
						                  + getParams()
						                  + "&noOfCopies=" + $F("txtNoOfCopies")
						                  + "&printerName=" + $F("selPrinter")
						                  + "&destination=" + $F("selDestination");
			
				if("screen" == $F("selDestination")){
					showPdfReport(content, "");
				}else if($F("selDestination") == "printer"){
					new Ajax.Request(content, {
						parameters : {noOfCopies : $F("txtNoOfCopies")},
						onCreate: showNotice("Processing, please wait..."),				
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								
							}
						}
					});
				}else if("file" == $F("selDestination")){
					new Ajax.Request(content, {
						parameters : {destination : "file",
									  //edited by gab 06.16.2016 SR 22493
									  //fileType : $("rdoPdf").checked ? "PDF" : "XLS"},
									  fileType : $("rdoPdf").checked ? "PDF" : "CSV2"},
						onCreate: showNotice("Generating report, please wait..."),
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								//edited by gab 06.16.2016 SR 22493
								//copyFileToLocal(response);
								if (fileType = "CSV2"){
									copyFileToLocal(response, "csv");
									deleteCSVFileFromServer(response.responseText);
								}else{ 
									copyFileToLocal(response);
								}
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
				showErrorMessage("printReport", e);
			}
		}
		
		$("btnPrint").observe("click", function(){
			if($("txtFromDate").value == "")
				customShowMessageBox("Required fields must be entered.", "I", "txtFromDate");
			else if ($("txtToDate").value == "")
				customShowMessageBox("Required fields must be entered.", "I", "txtToDate");
			else {
				
				if($("txtLineCd").value != ""){
					var response = validateField("/GIISLineController", "validateLineCd2");
					if(response == "ERROR") {
						customShowMessageBox("Invalid Line Code", "E", "txtLineCd");
						$("txtLineCd").clear();
						return;
					} else {
						$("txtLineName").value = unescapeHTML2(response);
					}
				}
			
			
				if($("txtBranchCd").value != ""){
					var response = validateField("/GIACBranchController","validateGIACS178BranchCd");
					if(response == "ERROR") {
						customShowMessageBox("Invalid Branch Code", "E", "txtBranchCd");
						$("txtBranchCd").clear();
						return;
					} else {
						$("txtBranchName").value = unescapeHTML2(response);
					}
				}
				
				var dest = $F("selDestination");
				
				if(dest == "printer"){
					if(checkAllRequiredFieldsInDiv("printDiv")){
						printReport();
					}
				}else{
					printReport();
				}	
			}
				
		});
		
		initGIACS178();
		initializeAll();
	} catch (e) {
		showErrorMessage("Direct Premium Collections", e);
	}
</script>