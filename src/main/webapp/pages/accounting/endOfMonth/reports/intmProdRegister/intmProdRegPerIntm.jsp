<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div>
	<div id="outerDiv">
		<div id="innerDiv">
			<label>Intermediary Production Register</label>
			<span class="refreshers" style="margin-top: 0;">
	 			<label id="btnReloadForm" name="gro" style="margin-left: 5px;">Reload Form</label>
			</span>
		</div>
	</div>
	<div class="sectionDiv" style="clear: both; float: none; height: 400px;">
		<div class="sectionDiv" style="float:none; width: 600px; margin: 50px auto 1px;">
			<table align="center" style="margin: 20px auto;">
				<tr>
					<td><label for="txtFromDate" style="float: right;">From</label></td>
					<td style="	padding-left: 5px;">
						<div style="float: left; width: 140px; height: 20px; margin: 0;" class="withIconDiv required">
							<input type="text" id="txtFromDate" class="withIcon required" readonly="readonly" style="width: 116px;" tabindex="101"/>
							<img id="imgFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="" style="margin : 1px 1px 0 0; cursor: pointer"/>
						</div>
					</td>
					<td><label for="txtToDate" style="float: right; margin-left: 10px;">To</label></td>
					<td style="padding-left: 5px; width: 100px;">
						<div style="float: left; width: 140px; height: 20px; margin: 0;" class="withIconDiv required">
							<input type="text" id="txtToDate" class="withIcon required" readonly="readonly" style="width: 116px;" tabindex="102"/>
							<img id="imgToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="" style="margin : 1px 1px 0 0; cursor: pointer"/>
						</div>
					</td>
				</tr>
				<tr>
					<td><label for="txtBranchCd" style="float: right;">Branch</label></td>
					<td style="padding-left: 5px;" colspan="3">
						<span class="lovSpan" style="width: 70px; margin-bottom: 0;">
							<input type="text" id="txtBranchCd" style="width: 45px; float: left;" class="withIcon allCaps"  maxlength="2"  tabindex="201"/>  
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgBranchCd" alt="Go" style="float: right;" />
						</span>
						<input type="text" id="txtBranchName" class="allCaps" readonly="readonly" style="margin: 0; height: 14px; width: 297px; margin-left: 2px;" tabindex="202"/>
					</td>
				</tr>
				<tr>
					<td><label for="txtIntmType" style="float: right;">Intermediary Type</label></td>
					<td style="padding-left: 5px;" colspan="3">
						<span class="lovSpan" style="width: 70px; margin-bottom: 0;">
							<input type="text" id="txtIntmType" style="width: 45px; float: left;" class="withIcon allCaps"  maxlength="2"  tabindex="203"/>  
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgIntmType" alt="Go" style="float: right;" />
						</span>
						<input type="text" id="txtIntmDesc" class="allCaps" readonly="readonly" style="margin: 0; height: 14px; width: 297px; margin-left: 2px;" tabindex="204"/>
					</td>
				</tr>
				<tr>
					<td><label for="txtIntmNo" style="float: right;">Intermediary No</label></td>
					<td style="padding-left: 5px;" colspan="3">
						<span class="lovSpan" style="width: 70px; margin-bottom: 0;">
							<input type="text" id="txtIntmNo" style="width: 45px; float: left;" class="withIcon allCaps"  maxlength="12"  tabindex="205" rea/>  
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgIntmNo" alt="Go" style="float: right;" />
						</span>
						<input type="text" id="txtIntmName" readonly="readonly" class="allCaps" style="margin: 0; height: 14px; width: 297px; margin-left: 2px;" tabindex="206"/>
					</td>
				</tr>
			</table>
		</div>
		<div style="width: 602px; margin: auto;">
			<div class="sectionDiv" style="float: left; width: 150px; height: 130px;">
				<table align="center" style="margin-top: 20px;" border="0">
					<tr height="50px;">
						<td><input type="radio" id="rdoCreditingBranch" name="rdoGroup1" tabindex="301"/></td>
						<td><label for="rdoCreditingBranch">Crediting Branch</label></td>
					</tr>
					<tr>
						<td><input type="radio" id="rdoIssSource" name="rdoGroup1" tabindex="302"/></td>
						<td><label for="rdoIssSource">Issuing Source</label></td>
					</tr>
				</table>
			</div>
			<div class="sectionDiv" style="float: left; width: 130px; height: 130px; margin: auto 1px;">
				<table align="center" style="margin-top: 20px;" border="0">
					<tr height="50px;">
						<td><input type="radio" id="rdoSummary" name="rdoGroup2" tabindex="303"/></td>
						<td><label for="rdoSummary">Summary</label></td>
					</tr>
					<tr>
						<td><input type="radio" id="rdoDetails" name="rdoGroup2" tabindex="304"/></td>
						<td><label for="rdoDetails">Details</label></td>
					</tr>
				</table>
			</div>
			
			
			<div id="printDiv" class="sectionDiv" style="float: left; width: 314px; height: 130px;">
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
							<input type="text" id="txtNoOfCopies" tabindex="309" style="float: left; text-align: right; width: 175px;" class="required integerNoNegativeUnformattedNoComma" maxlength="3">
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
			
			
			
		</div>
		<div style="clear: both;">
			<input type="button" class="button" id="btnPrint" value="Print" style="width: 120px; margin-top: 20px;"/>
		</div>
	</div>
	
</div>
<script>
	try {
		var onLOV = false;
		var checkBranch = "";
		var checkIntmType = "";
		var checkIntmNo = "";
		var validated = false;
		
		//$("btnReloadForm").observe("click", showIntermediaryProdPerIntm);
		
		function initGIACS153(){
			setModuleId("GIACS153");
			setDocumentTitle("Intermediary Production Register");
			$("rdoCreditingBranch").checked = true;
			$("rdoSummary").checked = true;
			$("txtBranchName").value = "ALL BRANCHES";
			$("txtIntmDesc").value = "ALL INTERMEDIARY TYPES";
			$("txtIntmName").value = "ALL INTERMEDIARIES";
			$("txtBranchCd").focus();
		}
		
		function resetForm(){
			onLOV = false;
			checkBranch = "";
			checkIntmType = "";
			checkIntmNo = "";
			$("rdoCreditingBranch").checked = true;
			$("rdoSummary").checked = true;
			$("txtBranchCd").clear();
			$("txtIntmType").clear();
			$("txtIntmNo").clear();
			$("txtBranchName").value = "ALL BRANCHES";
			$("txtIntmDesc").value = "ALL INTERMEDIARY TYPES";
			$("txtIntmName").value = "ALL INTERMEDIARIES";
			toggleRequiredFields("screen");
			$("txtFromDate").clear();
			$("txtToDate").clear();
			$("txtBranchCd").focus();
			validated = false;
		}
		
		$("btnReloadForm").observe("click", resetForm);
		
		function getBranchLOVInAcctrans() {
			if(onLOV) return;
			onLOV = true;
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getBranchLOVInAcctrans",
					searchString : checkBranch == "" ? $("txtBranchCd").value : "",
					moduleId: 'GIACS153',
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
				filterText:  checkBranch == "" ? $("txtBranchCd").value : "",
				onSelect : function(row) {
					onLOV = false;
					$("txtBranchCd").value = row.branchCd.toUpperCase();
					$("txtBranchName").value = unescapeHTML2(row.branchName);
					checkBranch = row.branchCd;
				},
				onCancel : function () {
					$("txtBranchCd").clear();
					$("txtBranchName").value = "ALL BRANCHES";
					onLOV = false;
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtBranchCd");
					$("txtBranchCd").clear();
					$("txtBranchName").value = "ALL BRANCHES";
					onLOV = false;
				}
			});
		}
		
		$("imgBranchCd").observe("click", getBranchLOVInAcctrans);
		
		$("txtBranchCd").observe("keypress", function(event){
			if(event.keyCode == objKeyCode.ENTER) {
				getBranchLOVInAcctrans();	
			} else if(event.keyCode == 8 || event.keyCode == 46 || event.keyCode == 0) {
				$("txtBranchName").clear();
				checkBranch = ""; 
			}
		});
		
		function getIntmType3LOV() {
			if(onLOV) return;
			onLOV = true;
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getIntmType3LOV",
					searchString : checkIntmType == "" ? $("txtIntmType").value : "",
					page : 1
				},
				title : "List of Intermediary Types",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "intmType",
					title : "Intm Type",
					width : '120px',
				}, {
					id : "intmDesc",
					title : "Description",
					width : '345px',
					renderer: function(value) {
						return unescapeHTML2(value).toUpperCase();
					}
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText:  checkIntmType == "" ? $("txtIntmType").value : "",
				onSelect : function(row) {
					onLOV = false;
					$("txtIntmType").value = row.intmType;
					$("txtIntmDesc").value = unescapeHTML2(row.intmDesc).toUpperCase();
					checkIntmType = row.intmType;
				},
				onCancel : function () {
					onLOV = false;
					$("txtIntmType").clear();
					$("txtIntmDesc").value = "ALL INTERMEDIARY TYPES";
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtIntmType");
					$("txtIntmType").clear();
					$("txtIntmDesc").value = "ALL INTERMEDIARY TYPES";
					onLOV = false;
				}
			});
		}
		
		$("imgIntmType").observe("click", getIntmType3LOV);
		
		$("txtIntmType").observe("keypress", function(event){
			if(event.keyCode == objKeyCode.ENTER) {
				getIntmType3LOV();	
			} else if(event.keyCode == 8 || event.keyCode == 46 || event.keyCode == 0) {
				$("txtIntmDesc").clear();
				checkIntmType = ""; 
			}
		});
		
		function getIntmNoLov() {
			if(onLOV) return;
			onLOV = true;
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGIACS153IntmNoLOV",
					searchString : checkIntmNo == "" ? $("txtIntmNo").value : "",
					page : 1
				},
				title : "List of Intermediaries",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "intmNo",
					title : "Intm No.",
					width : '120px',
				}, {
					id : "intmName",
					title : "Intermediary Name",
					width : '345px',
					renderer: function(value) {
						return unescapeHTML2(value).toUpperCase();
					}
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText:  checkIntmNo == "" ? $("txtIntmNo").value : "",
				onSelect : function(row) {
					onLOV = false;
					$("txtIntmNo").value = row.intmNo;
					$("txtIntmName").value = unescapeHTML2(row.intmName).toUpperCase();
					checkIntmNo = row.intmNo;
				},
				onCancel : function () {
					onLOV = false;
					$("txtIntmNo").clear();
					$("txtIntmName").value = "ALL INTERMEDIARIES";
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtIntmNo");
					$("txtIntmNo").clear();
					$("txtIntmName").value = "ALL INTERMEDIARIES";
					onLOV = false;
				}
			});
		}
		
		$("imgIntmNo").observe("click", getIntmNoLov);
		
		$("txtIntmNo").observe("keypress", function(event){
			if(event.keyCode == objKeyCode.ENTER) {
				getIntmNoLov();	
			} else if(event.keyCode == 8 || event.keyCode == 46 || event.keyCode == 0) {
				$("txtIntmName").clear();
				checkIntmNo = ""; 
			}
		});
		
		$("imgFromDate").observe("click", function(){
			scwShow($("txtFromDate"), this, null);
		});
		
		$("imgToDate").observe("click", function(){
			scwShow($("txtToDate"), this, null);
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
			
			/* if(fromDate == "" && toDate != ""){
				showMessageBox("Please enter FROM date first.", "I");
				$("txtToDate").clear();
				$("txtFromDate").clear();
				return false;
			} */
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
			
			/* if(fromDate == "" && toDate != ""){
				showMessageBox("Please enter FROM date first.", "I");
				$("txtToDate").clear();
				$("txtFromDate").clear();
				return false;
			} */
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
					$("rdoExcel").disable();				
			} else {
				if(dest == "file"){
					$("rdoPdf").enable();
					$("rdoExcel").enable();
				} else {
					$("rdoPdf").disable();
					$("rdoExcel").disable();
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
		
		$("txtBranchCd").observe("change", function(){
			if(this.value.trim() == ""){
				$("txtBranchName").value = "ALL BRANCHES";
			} else {
				getBranchLOVInAcctrans();
			}
		});
		
		$("txtIntmType").observe("change", function(){
			if(this.value.trim() == ""){
				$("txtIntmDesc").value = "ALL INTERMEDIARY TYPES";
			} else {
				getIntmType3LOV();	
			}
		});
		
		$("txtIntmNo").observe("change", function(){
			if(this.value.trim() == ""){
				$("txtIntmName").value = "ALL INTERMEDIARIES";
			} else {
				getIntmNoLov();
			}
		});
		
		function getParams() {
			var params = "&fromDate=" + $("txtFromDate").value +
					 	 "&toDate=" + $("txtToDate").value +
					 	 "&intmNo=" + $("txtIntmNo").value +
					 	 "&intmType=" + $("txtIntmType").value +
					 	 "&issCd=" + $("txtBranchCd").value;
			
			var issCred = $("rdoCreditingBranch").checked ? "C" : "I";
			
			params += "&issCred=" + issCred;
					 	 
			return params;
		}
		
		function printReport(){
			try {
				var repId = $("rdoDetails").checked ? "GIACR217" : "GIACR219";
				
				var content = contextPath + "/EndOfMonthPrintReportController?action=printReport"
						                  + "&reportId=" + repId
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
								showMessageBox("Printing complete.", "S");
							}
						}
					});
				}else if("file" == $F("selDestination")){
					new Ajax.Request(content, {
						parameters : {destination : "file",
									  fileType : $("rdoPdf").checked ? "PDF" : "XLS"},
						onCreate: showNotice("Generating report, please wait..."),
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								copyFileToLocal(response, "reports");
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
		
		function validateField(controller, action) {
			var ajaxResponse = "";
			var branchCd = $("txtBranchCd").value;
			var intmType = $("txtIntmType").value;
			var intmNo = $("txtIntmNo").value;
			
			new Ajax.Request(contextPath + controller,{
				method: "POST",
				parameters: {
						     action : action,
						     branchCd : branchCd,
						     intmType : intmType,
						     intmNo : intmNo,
						     moduleId : "GIACS153"
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
				
		function validateBranchCd(){
			if($("txtBranchCd").value != "" && checkBranch == ""){
				var response = validateField("/GIACBranchController","validateBranchCdInAcctrans");
				if(response == "ERROR") {
					customShowMessageBox("Invalid Branch Code", "E", "txtBranchCd");
					/* $("txtBranchCd").clear();
					getBranchLOVInAcctrans(); */
					return false;
				} else {
					$("txtBranchName").value = unescapeHTML2(response);
					checkBranch = $("txtBranchCd").value;
				}
			}
			validated = true;
			return true;
		}
		
		function validateIntmType(){
			if($("txtIntmType").value != "" && checkIntmType == ""){
				var response = validateField("/GIPIUwreportsExtController","validateIntmType");
				var json = JSON.parse(response);
				if(json.intmDesc == null || json.intmDesc == "") {
					customShowMessageBox("Invalid Intermediary Type", "E", "txtIntmType");
					/* $("txtIntmType").clear();
					getIntmType3LOV(); */
					return false;
				} else {
					$("txtIntmDesc").value = unescapeHTML2(json.intmDesc);
					checkIntmType = $("txtIntmType").value;
				}
			}
			return true;
		}
		
		function validateIntmNo(){
			if($("txtIntmNo").value != "" && checkIntmNo == ""){
				var response = validateField("/GIPIUwreportsExtController","validateIntmNo");
				var json = JSON.parse(response);
				if(json.intmName == null || json.intmName == "") {
					customShowMessageBox("Invalid Intermediary No.", "E", "txtIntmNo");
					/* $("txtIntmName").clear();
					$("txtIntmNo").clear(); 
					getIntmNoLov();*/
					return false;
				} else {
					$("txtIntmName").value = unescapeHTML2(json.intmName);
					checkIntmNo = $("txtIntmNo").value;
				}
			}
			return true;
		}
		
		/* $("txtBranchName").observe("focus", validateBranchCd);
		$("txtIntmDesc").observe("focus", validateIntmType);
		$("txtIntmName").observe("focus", validateIntmNo); */
		
		$("btnPrint").observe("click", function(){
			if($("txtFromDate").value == "")
				customShowMessageBox(objCommonMessage.REQUIRED, "I", "txtFromDate");
			else if ($("txtToDate").value == "")
				customShowMessageBox(objCommonMessage.REQUIRED, "I", "txtToDate");
			else {
			
				if(!validateBranchCd())
					return;
				if(!validateIntmType())
					return;
				if(!validateIntmNo())
					return;
				
				var dest = $F("selDestination");
				
				if(dest == "printer"){
					if(checkAllRequiredFieldsInDiv("printDiv")){
						
						if($F("txtNoOfCopies") > 100 || $F("txtNoOfCopies") < 1){
							showMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "I");
							return;
						}
						
						printReport();
					}
				}else{
					printReport();
				}	
			}
				
		});
		
		
		
		initGIACS153();
		initializeAll();
		
	} catch (e) {
		showErrorMessage("Intermediary Production Register", e);
	}
</script>