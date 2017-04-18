<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="creditDebitMemoReportDiv">
	<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
		<label>Credit/Debit Memo Report</label>
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
						<td><label for="txtCutOffDate" style="float: right;">Cut-off</label></td>
						<td style="padding-left: 5px;">
							<div style="float: left; width: 140px; height: 20px; margin: 0;" class="withIconDiv required">
								<input type="text" id="txtCutOffDate" class="withIcon required" readonly="readonly" style="width: 116px;" tabindex="203"/>
								<img id="imgCutOffDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="" style="margin : 1px 1px 0 0; cursor: pointer"/>
							</div>
						</td>
						<td></td><td></td>
					</tr>
					<tr>
						<td><label for="txtMemoType" style="float: right;">Memo Type</label></td>
						<td style="padding-left: 5px;" colspan="3">
							<span class="lovSpan" style="width: 70px; margin-bottom: 0;">
								<input type="text" id="txtMemoType" style="width: 45px; float: left;" class="withIcon allCaps"  maxlength="3"  tabindex="204" lastValidValue=""/>  
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgMemoType" alt="Go" style="float: right;" />
							</span>
							<input type="text" id="txtMemoName" readonly="readonly" style="margin: 0; height: 14px; width: 237px; margin-left: 2px;" tabindex="205" lastValidValue="ALL MEMO TYPES"/>
						</td>
					</tr>
					<tr>
						<td><label for="txtBranchCd" style="float: right;">Branch</label></td>
						<td style="padding-left: 5px;" colspan="3">
							<span class="lovSpan" style="width: 70px; margin-bottom: 0;">
								<input type="text" id="txtBranchCd" style="width: 45px; float: left;" class="withIcon allCaps"  maxlength="2"  tabindex="206" lastValidValue=""/>  
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgBranchCd" alt="Go" style="float: right;" />
							</span>
							<input type="text" id="txtBranchName" readonly="readonly" style="margin: 0; height: 14px; width: 237px; margin-left: 2px;" tabindex="207" lastValidValue="ALL BRANCHES"/>
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
							<!-- removed print to excel option by robert SR 5199 02.22.16
							<input value="EXCEL" title="Excel" type="radio" id="rdoExcel" name="fileType" tabindex="303" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="rdoExcel" style="margin: 2px 0 4px 0">Excel</label> -->
							<input value="CSV" title="CSV" type="radio" id="rdoCsv" name="fileType" tabindex="303" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="rdoCsv" style="margin: 2px 0 4px 0">CSV</label> <!-- Dren 03.04.2016 SR-5358 -->							
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
		
		function initGIACS072(){
			setModuleId("GIACS072");
			setDocumentTitle("Credit/Debit Memo Report");
			$("chkTranDate").checked = true;
			$("txtMemoName").value = "ALL MEMO TYPES";
			$("txtBranchName").value = "ALL BRANCHES";
		}
		
		function resetForm() {
			onLOV = false;
			
			$("chkTranDate").checked = true;
			$("chkPostingDate").checked = false;
			$("txtFromDate").clear();
			$("txtToDate").clear();
			$("txtCutOffDate").clear();
			$("txtMemoType").clear();
			$("txtMemoName").value = "ALL MEMO TYPES";
			$("txtBranchCd").clear();
			$("txtBranchName").value = "ALL BRANCHES";
			$("selDestination").selectedIndex = 0;
			toggleRequiredFields("screen");
			
		}
		
		$("btnReloadForm").observe("click", resetForm);
		
		function getGIACS072MemoTypeLOV() {
			if(onLOV) return;
			onLOV = true;
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGIACS072MemoTypeLOV",
					filterText : ($("txtMemoType").readAttribute("lastValidValue").trim() != $F("txtMemoType").trim() ? $F("txtMemoType").trim() : ""),
					page : 1
				},
				title : "List of Memo Types",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "rvLowValue",
					title : "Code",
					width : '120px',
				}, {
					id : "rvMeaning",
					title : "Memo Type",
					width : '345px',
					renderer: function(value) {
						return unescapeHTML2(value);
					}
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText : ($("txtMemoType").readAttribute("lastValidValue").trim() != $F("txtMemoType").trim() ? $F("txtMemoType").trim() : ""),
				onSelect : function(row) {
					onLOV = false;
					$("txtMemoType").value = row.rvLowValue;
					$("txtMemoName").value = row.rvMeaning;
					$("txtMemoType").setAttribute("lastValidValue", $F("txtMemoType"));
					$("txtMemoName").setAttribute("lastValidValue", $F("txtMemoName"));
					
					$("txtBranchCd").focus();
				},
				onCancel : function () {
					onLOV = false;
					$("txtMemoType").value = $("txtMemoType").readAttribute("lastValidValue");
					$("txtMemoName").value = $("txtMemoName").readAttribute("lastValidValue");
					$("txtMemoType").focus();
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtMemoType");
					onLOV = false;
					$("txtMemoType").value = $("txtMemoType").readAttribute("lastValidValue");
					$("txtMemoName").value = $("txtMemoName").readAttribute("lastValidValue");
				}
			});
		}
		
		function getGIACS072BranchLOV() {
			if(onLOV) return;
			onLOV = true;
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGIACS072BranchLOV",
					filterText : ($("txtBranchCd").readAttribute("lastValidValue").trim() != $F("txtBranchCd").trim() ? $F("txtBranchCd").trim() : ""),
					moduleId: 'GIACS072',
					page : 1
				},
				title : "List of Branches",
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
				filterText : ($("txtBranchCd").readAttribute("lastValidValue").trim() != $F("txtBranchCd").trim() ? $F("txtBranchCd").trim() : ""),
				onSelect : function(row) {
					onLOV = false;
					$("txtBranchCd").value = row.branchCd;
					$("txtBranchName").value = row.branchName;
					$("txtBranchCd").setAttribute("lastValidValue", $F("txtBranchCd"));
					$("txtBranchName").setAttribute("lastValidValue", $F("txtBranchName"));
					
				},
				onCancel : function () {
					onLOV = false;
					$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
					$("txtBranchName").value = $("txtBranchName").readAttribute("lastValidValue");
					$("txtBranchCd").focus();
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtBranchCd");
					onLOV = false;
					$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
					$("txtBranchName").value = $("txtBranchName").readAttribute("lastValidValue");
				}
			});
		}
		
		$("imgMemoType").observe("click", getGIACS072MemoTypeLOV);
		$("imgBranchCd").observe("click", getGIACS072BranchLOV);
		
		/* $("txtMemoType").observe("keypress", function(event){
			if(event.keyCode == objKeyCode.ENTER) {
				getGIACS072MemoTypeLOV();		
			} else if(event.keyCode == 8 || event.keyCode == 46 || event.keyCode == 0) {
				$("txtMemoName").clear();
			}
		});
		
		$("txtBranchCd").observe("keypress", function(event){
			if(event.keyCode == objKeyCode.ENTER) {
				getGIACS072BranchLOV();		
			} else if(event.keyCode == 8 || event.keyCode == 46 || event.keyCode == 0) {
				$("txtBranchName").clear();
			}
		}); */
		
		/* $("txtMemoType").observe("blur", function(){
			if(this.value == "")
				$("txtMemoName").value = "ALL MEMO TYPES";
		});
		
		$("txtBranchCd").observe("blur", function(){
			if(this.value == "")
				$("txtBranchName").value = "ALL BRANCHES";
		}); */

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
		
		$("imgCutOffDate").observe("click", function(){
			scwShow($("txtCutOffDate"), this, null);
		});
		
		$("txtToDate").observe("focus", function(){
			if ($("imgToDate").disabled) return;
			
			var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g,"/")) :"";
			var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g,"/")) :"";
			
			if (toDate < fromDate && toDate != ""){
				showMessageBox("From Date should not be later than To Date.", "I");
				$("txtToDate").clear();
				return false;
			}
		});
		
		$("txtFromDate").observe("focus", function(){
			if ($("imgFromDate").disabled) return;
			
			var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g,"/")) :"";
			var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g,"/")) :"";
			
			if (toDate < fromDate && toDate != ""){
				showMessageBox("From Date should not be later than To Date.", "I");
				$("txtFromDate").clear();
				return false;
			}
		});
		
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
					//$("rdoExcel").disable();	removed print to excel option by robert SR 5199 02.22.16	
					$("rdoCsv").disable();	//Dren 03.04.2016 SR-5358					
			} else {
				if(dest == "file"){
					$("rdoPdf").enable();
					//$("rdoExcel").enable(); removed print to excel option by robert SR 5199 02.22.16
					$("rdoCsv").enable();   //Dren 03.04.2016 SR-5358
				} else {
					$("rdoPdf").disable();
					//$("rdoExcel").disable(); removed print to excel option by robert SR 5199 02.22.16
					$("rdoCsv").disable();	//Dren 03.04.2016 SR-5358
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
		
		function validateField(controller, action) {
			var ajaxResponse = "";
			var memoType = $("txtMemoType").value;
			var branchCd = $("txtBranchCd").value;
			
			new Ajax.Request(contextPath + controller,{
				method: "POST",
				parameters: {
						     action : action,
						     memoType : memoType,
						     branchCd : branchCd,
						     moduleId : "GIACS072"
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
			var params = "&memoType=" + $("txtMemoType").value
						+ "&branchCd=" + $("txtBranchCd").value
						+ "&dateOpt=" + dateOpt
						+ "&fromDate=" + $("txtFromDate").value
						+ "&toDate=" + $("txtToDate").value
						+ "&cutOffDate=" + $("txtCutOffDate").value;
			return params;
		}
		
		function printReport(){
			try {
				var content = contextPath + "/GeneralLedgerPrintController?action=printReport"
						                  + "&reportId=" + "GIACR072"
						                  + getParams();
			
				if("screen" == $F("selDestination")){
					showPdfReport(content, "");
				}else if($F("selDestination") == "printer"){
					new Ajax.Request(content, {
						parameters : {noOfCopies : $F("txtNoOfCopies"),
							printerName : $F("selPrinter")},
						onCreate: showNotice("Processing, please wait..."),				
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								showWaitingMessageBox("Printing complete.", "S", function(){
									overlayGenericPrintDialog.close();
								});
							}
						}
					});
				}else if("file" == $F("selDestination")){

					var fileType = "PDF";               //Dren 03.04.2016 SR-5358 - Start
					if($("rdoPdf").checked)			
						fileType = "PDF";
					else if ($("rdoCsv").checked)
						fileType = "CSV";               				
					
					new Ajax.Request(content, {
						parameters : {destination : "file",
									  fileType : fileType},
						onCreate: showNotice("Generating report, please wait..."),
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								if (fileType == "CSV"){                 //Dren 03.04.2016 SR-5358 - Start
									copyFileToLocal(response, "csv");
									deleteCSVFileFromServer(response.responseText);
								} else {                                
									copyFileToLocal(response,"reports");
							    }										//Dren 03.04.2016 SR-5358 - End 
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
			else if ($("txtCutOffDate").value == "")
				customShowMessageBox("Required fields must be entered.", "I", "txtCutOffDate");
			else {
				
				var dest = $F("selDestination");
				
				if(dest == "printer"){
					if(checkAllRequiredFieldsInDiv("printDiv")){
						if($F("txtNoOfCopies") > 100 || $F("txtNoOfCopies") < 1){
							showMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "I");
						}
						printReport();
					}
				}else{
					printReport();
				}	
			}
				
		});
		
		$("txtMemoType").observe("change", function(){
			if($F("txtMemoType").trim() == ""){
				$("txtMemoType").clear();
				$("txtMemoName").value = "ALL MEMO TYPES";
				$("txtMemoType").setAttribute("lastValidValue", "");
				$("txtMemoName").setAttribute("lastValidValue", "ALL MEMO TYPES");
				return;
			} else
				getGIACS072MemoTypeLOV();
		});
		
		$("txtBranchCd").observe("change", function(){
			if($F("txtBranchCd").trim() == ""){
				$("txtBranchCd").clear();
				$("txtBranchName").value = "ALL BRANCHES";
				$("txtBranchCd").setAttribute("lastValidValue", "");
				$("txtBranchName").setAttribute("lastValidValue", "ALL BRANCHES");
				return;
			} else
				getGIACS072BranchLOV();
		});
		
		initGIACS072();
		initializeAll();
	} catch (e) {
		showErrorMessage("Credit/Debit Memo Report", e);
	}
</script>