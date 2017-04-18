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
			<label>Agent Production</label>
			<span class="refreshers" style="margin-top: 0;">
	 			<label id="btnReloadForm" name="gro" style="margin-left: 5px;">Reload Form</label>
			</span>
		</div>
	</div>
	<div class="sectionDiv" style="clear: both; float: none; height: 530px; margin-bottom: 50px; ">
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
					<td><label for="txtIssCd" style="float: right;">Branch</label></td>
					<td style="padding-left: 5px;" colspan="3">
						<span class="lovSpan" style="width: 70px; margin-bottom: 0;">
							<input type="text" id="txtIssCd" style="width: 45px; float: left;" class="withIcon allCaps"  maxlength="2"  tabindex="201"/>  
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgIssCd" alt="Go" style="float: right;" />
						</span>
						<input type="text" id="txtIssName" readonly="readonly" style="margin: 0; height: 14px; width: 297px; margin-left: 2px;" tabindex="202"/>
					</td>
				</tr>
				<tr>
					<td><label for="txtLineCd" style="float: right;">Line</label></td>
					<td style="padding-left: 5px;" colspan="3">
						<span class="lovSpan" style="width: 70px; margin-bottom: 0;">
							<input type="text" id="txtLineCd" style="width: 45px; float: left;" class="withIcon allCaps"  maxlength=""  tabindex="203"/>  
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgLineCd" alt="Go" style="float: right;" />
						</span>
						<input type="text" id="txtLineName" readonly="readonly" style="margin: 0; height: 14px; width: 297px; margin-left: 2px;" tabindex="204"/>
					</td>
				</tr>
				<tr>
					<td><label for="txtIntmNo" style="float: right;">Intermediary</label></td>
					<td style="padding-left: 5px;" colspan="3">
						<span class="lovSpan" style="width: 70px; margin-bottom: 0;">
							<input type="text" id="txtIntmNo" style="width: 45px; float: left;" class="withIcon allCaps integerNoNegativeUnformattedNoComma"  maxlength="12"  tabindex="205" rea/>  
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgIntmNo" alt="Go" style="float: right;" />
						</span>
						<input type="text" id="txtIntmName" readonly="readonly" style="margin: 0; height: 14px; width: 297px; margin-left: 2px;" tabindex="206"/>
					</td>
				</tr>
			</table>
		</div>
		<div style="width: 606px; margin: auto;">
			<fieldset class="sectionDiv" style="float: left; width: 170px; height: 130px;">
				<legend style="margin-left: 10px;"><b>Branch Parameter</b></legend>
				<table align="center" style="margin-top: 32px;" border="0">
					<tr height="20px;">
						<td><input type="radio" id="rdoCreditingBranch" name="rdoGroup1" tabindex="301"/></td>
						<td><label for="rdoCreditingBranch">Crediting Branch</label></td>
					</tr>
					<tr height="20px;">
						<td><input type="radio" id="rdoIssSource" name="rdoGroup1" tabindex="302"/></td>
						<td><label for="rdoIssSource">Issuing Source</label></td>
					</tr>
				</table>
			</fieldset>
			
			<fieldset class="sectionDiv" style="float: left; width: 170px; height: 130px; margin: auto 1px;">
				<legend style="margin-left: 10px;"><b>Date Parameter</b></legend>
				<table align="center" style="margin-top: 10px;" border="0">
					<tr height="20px;">
						<td><input type="radio" id="rdoIssueDate" name="rdoGroup2" tabindex="303"/></td>
						<td><label for="rdoIssueDate">Issue Date</label></td>
					</tr>
					<tr height="20px;">
						<td><input type="radio" id="rdoInceptDate" name="rdoGroup2" tabindex="304"/></td>
						<td><label for="rdoInceptDate">Incept Date</label></td>
					</tr>
					<tr height="20px;">
						<td><input type="radio" id="rdoBookingDate" name="rdoGroup2" tabindex="305"/></td>
						<td><label for="rdoBookingDate">Booking Date</label></td>
					</tr>
					<tr height="20px;">
						<td><input type="radio" id="rdoEntryDate" name="rdoGroup2" tabindex="306"/></td>
						<td><label for="rdoEntryDate">Acctg Entry Date</label></td>
					</tr>
				</table>
			</fieldset>
			
			<fieldset class="sectionDiv" style="float: left; width: 250px; height: 130px;">
				<legend style="margin-left: 10px;"><b>Collection Date Parameter</b></legend>
				<table style="margin-top: 10px; margin-left: 10px;" border="0">
					<tr height="20px;">
						<td>
							<input type="checkbox" id="checkWithCollection" tabindex="303" style="float: left;"/>
							<label for="checkWithCollection" style="float: left; margin-left: 5px;">With Collections</label>	
						</td>
					</tr>
					<tr height="20px;">
						<td>
							<label for="txtCutOffDate" style="margin: 9px 5px 0 14px;">Cut-Off</label>
							<div id="divCutOffDate" style="float: left; width: 140px; height: 20px; margin-top: 5px;" class="withIconDiv">
								<input type="text" id="txtCutOffDate" class="withIcon" readonly="readonly" style="width: 116px;" tabindex="101"/>
								<img id="imgCutOffDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="" style="margin : 1px 1px 0 0; cursor: pointer"/>
							</div>
						</td>
					</tr>
					<tr height="20px;">
						<td>
							<input type="radio" id="rdoTranDate" name="rdoGroup3" style="float: left; margin: 0 5px 0 14px;"/>
							<label for="rdoTranDate">Transaction Date</label>
						</td>
					</tr>
					<tr height="20px;">
						<td>
							<input type="radio" id="rdoPostingDate" name="rdoGroup3" style="float: left; margin: 0 5px 0 14px;"/>
							<label for="rdoPostingDate">Posting Date</label>
						</td>
					</tr>
				</table>
			</fieldset>
			
			<div id="printDiv" class="sectionDiv" style="float: left; width: 600px; height: 140px; margin: 2px 0 0 2px;">
				<table align="center" style="margin-top: 15px;">
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
		</div>
		<div style="clear: both;">
			<input type="button" class="button" id="btnExtract" value="Extract" style="width: 120px; margin-top: 15px;"/>
			<input type="button" class="button" id="btnPrint" value="Print" style="width: 120px; margin-top: 15px;"/>
		</div>
	</div>
</div>
<script type="text/javascript">
	try {
		
		var moduleId = "GIACS275";
		var onLOV = false;
		var checkIss = "";
		var checkLine = "";
		var checkIntm = "";
		
		var tempFromDate = null;
		var tempToDate = null;
		var tempIssCd = null;
		var tempLineCd = null;
		var tempIntmNo = null;
		var tempDateParam = null;
		var tempIssParam = null;
		
		//$("btnReloadForm").observe("click", showIntermediaryProdPerLine);
		
		
		function getBasicIsSourceLOV() {
			if(onLOV) return;
			onLOV = true;
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getBasicIsSourceLOV",
					searchString : checkIss == "" ? $("txtIssCd").value : "",
					moduleId: moduleId,
					page : 1
				},
				title : "Valid Values for Branches",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "issCd",
					title : "Code",
					width : '120px',
				}, {
					id : "issName",
					title : "Branch Name",
					width : '345px',
					renderer: function(value) {
						return unescapeHTML2(value);
					}
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText:  checkIss == "" ? $("txtIssCd").value : "",
				onSelect : function(row) {
					onLOV = false;
					$("txtIssCd").value = row.issCd;
					$("txtIssName").value = unescapeHTML2(row.issName);
					checkIss = row.issCd;
				},
				onCancel : function () {
					$("txtIssCd").clear();
					checkIss = "";
					$("txtIssName").value = "ALL BRANCHES";
					onLOV = false;
					$("txtIssCd").focus();
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtIssCd");
					$("txtIssCd").clear();
					checkIss = "";
					$("txtIssName").value = "ALL BRANCHES";
					onLOV = false;
					$("txtIssCd").focus();
				}
			});
		}
		
		function getGiisLineLOV() {
			if(onLOV) return;
			onLOV = true;
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGiisLineLOV",
					searchString : checkLine == "" ? $("txtLineCd").value : "",
					page : 1
				},
				title : "List of Line Codes",
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
				filterText:  checkLine == "" ? $("txtLineCd").value : "",
				onSelect : function(row) {
					onLOV = false;
					$("txtLineCd").value = row.lineCd;
					$("txtLineName").value = unescapeHTML2(row.lineName);
					checkLine = row.lineCd;
				},
				onCancel : function () {
					$("txtLineCd").clear();
					checkLine = "";
					$("txtLineName").value = "ALL LINES";
					onLOV = false;
					$("txtLineCd").focus();
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtLineCd");
					$("txtLineCd").clear();
					checkLine = "";
					$("txtLineName").value = "ALL LINES";
					onLOV = false;
					$("txtLineCd").focus();
				}
			});
		}
		
		function getIntmNoLOV() {
			if(onLOV) return;
			onLOV = true;
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGIACS512IntmNoLOV",
					searchString : checkIntm == "" ? $("txtIntmNo").value : "",
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
						return unescapeHTML2(value);
					}
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText:  checkIntm == "" ? $("txtIntmNo").value : "",
				onSelect : function(row) {
					onLOV = false;
					$("txtIntmNo").value = row.intmNo;
					$("txtIntmName").value = unescapeHTML2(row.intmName);
					checkIntm = row.intmNo;
				},
				onCancel : function () {
					$("txtIntmNo").clear();
					checkIntm = "";
					$("txtIntmName").value = "ALL INTERMEDIARIES";
					onLOV = false;
					$("txtIntmNo").focus();
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtIntmNo");
					$("txtIntmNo").clear();
					checkIntm = "";
					$("txtIntmName").value = "ALL INTERMEDIARIES";
					onLOV = false;
					$("txtIntmNo").focus();
				}
			});
		}
		
		$("imgIssCd").observe("click", getBasicIsSourceLOV);
		$("imgLineCd").observe("click", getGiisLineLOV);
		$("imgIntmNo").observe("click", getIntmNoLOV);
		
		$("txtIssCd").observe("change", function(){
			if(this.value == "") {
				$("txtIssName").value = "ALL BRANCHES";
				return;
			}
			getBasicIsSourceLOV();
		});
		
		$("txtIssCd").observe("keypress", function(event){
			if(event.keyCode == 8 || event.keyCode == 46 || event.keyCode == 0) {
				$("txtIssName").clear();
				checkIss = ""; 
			}
		});
		
		$("txtLineCd").observe("change", function(){
			if(this.value == "") {
				$("txtLineName").value = "ALL LINES";
				return;
			}
			getGiisLineLOV();
		});
		
		$("txtLineCd").observe("keypress", function(event){
			if(event.keyCode == 8 || event.keyCode == 46 || event.keyCode == 0) {
				$("txtLineName").clear();
				checkLine = ""; 
			}
		});
		
		$("txtIntmNo").observe("change", function(){
			if(this.value == "") {
				$("txtIntmName").value = "ALL INTERMEDIARIES";
				return;
			}
			getIntmNoLOV();
		});
		
		$("txtIntmNo").observe("keypress", function(event){
			if(event.keyCode == 8 || event.keyCode == 46 || event.keyCode == 0) {
				$("txtIntmName").clear();
				checkIntm = ""; 
			}
		});
		
		$("imgFromDate").observe("click", function(){
			scwShow($("txtFromDate"), this, null);
		});
		
		$("imgToDate").observe("click", function(){
			scwShow($("txtToDate"), this, null);
		});
		
		$("imgFromDate").observe("click", function(){
			scwShow($("txtFromDate"), this, null);
		});
		
		$("imgCutOffDate").observe("click", function(){
			scwShow($("txtCutOffDate"), this, null);
		});
		
		$("txtFromDate").observe("focus", function(){
			if ($("imgFromDate").disabled) return;
			if($F("txtToDate") == "") return;
			
			var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g,"/")) :"";
			var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g,"/")) :"";
			
			if (toDate < fromDate && toDate != ""){
				showMessageBox("From Date should be earlier than To Date.", "I");
				$("txtFromDate").clear();
				return false;
			}
		});
		
		$("txtToDate").observe("focus", function(){
			if ($("imgToDate").disabled) return;
			if($F("txtFromDate") == "") return;
			
			var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g,"/")) :"";
			var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g,"/")) :"";
			
			if (toDate < fromDate && toDate != ""){
				showMessageBox("From Date should be earlier than To Date.", "I");
				$("txtToDate").clear();
				return false;
			}
		});
		
		function initGIACS275(){
			setModuleId("GIACS275");
			setDocumentTitle("Agent Production");
			$("rdoCreditingBranch").checked = true;
			$("rdoIssueDate").checked = true;
			disableDate("imgCutOffDate");
			$("txtCutOffDate").disable();
			$("divCutOffDate").setStyle({background: '#F0F0F0'});
			$("rdoTranDate").disable();
			$("rdoPostingDate").disable();
			$("txtIssName").value = "ALL BRANCHES";
			$("txtLineName").value = "ALL LINES";
			$("txtIntmName").value = "ALL INTERMEDIARIES";
		}
		
		function resetForm() {
			onLOV = false;
			checkIss = "";
			checkLine = "";
			checkIntm = "";
			
			tempFromDate = null;
			tempToDate = null;
			tempIssCd = null;
			tempLineCd = null;
			tempIntmNo = null;
			tempDateParam = null;
			tempIssParam = null;
			
			$("rdoCreditingBranch").checked = true;
			$("rdoIssueDate").checked = true;
			$("checkWithCollection").checked = false;
			setCollectionDateParam(false);
			toggleRequiredFields("screen");
			$("txtFromDate").clear();
			$("txtToDate").clear();
			$("txtIssCd").clear();
			$("txtLineCd").clear();
			$("txtIntmNo").clear();
			$("txtIssName").value = "ALL BRANCHES";
			$("txtLineName").value = "ALL LINES";
			$("txtIntmName").value = "ALL INTERMEDIARIES";
		}
		
		$("checkWithCollection").observe("click", function(){
			setCollectionDateParam(this.checked);
		});
		
		function setCollectionDateParam(check){
			if(check){
				enableDate("imgCutOffDate");
				$("txtCutOffDate").enable();
				$("divCutOffDate").setStyle({background: 'white'});
				$("rdoTranDate").enable();
				$("rdoPostingDate").enable();
				$("rdoTranDate").checked = true;
			} else {
				$("txtCutOffDate").clear();
				disableDate("imgCutOffDate");
				$("txtCutOffDate").disable();
				$("divCutOffDate").setStyle({background: '#F0F0F0'});
				$("rdoTranDate").checked = false;
				$("rdoPostingDate").checked = false;
				$("rdoTranDate").disable();
				$("rdoPostingDate").disable();
			}
		}
		
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
		
		function extractIntmProdColln(branchParam, paramDate){
					
					new Ajax.Request(contextPath + "/GIISIntermediaryController",{
						method: "POST",
						parameters: {
								     action : "extractIntmProdColln",
								     branchParam : branchParam,
								     branchCd : $("txtIssCd").value,
								     lineCd : $("txtLineCd").value,
								     intmNo : $("txtIntmNo").value,
								     paramDate : paramDate,
								     fromDate : $("txtFromDate").value,
								     toDate : $("txtToDate").value,
								     
						},
						asynchronous: false,
						onCreate: function(){
							showNotice("Extracting...please wait...");
						},
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response)){
								var noOfExtractedRecs = trim(response.responseText);
								if(noOfExtractedRecs != 0)
									showMessageBox("Extraction Complete.", "S");
								else
									showMessageBox("Extraction finished. No records extracted.", "I");
							}
						}
					});
						
				}
				
		function extractWeb(branchParam, paramDate){
			
			new Ajax.Request(contextPath + "/GIISIntermediaryController",{
				method: "POST",
				parameters: {
						     action : "extractWeb",
						     issParam : branchParam,
						     issCd : $("txtIssCd").value,
						     lineCd : $("txtLineCd").value,
						     intmNo : $("txtIntmNo").value,
						     dateParam : paramDate,
						     fromDate : $("txtFromDate").value,
						     toDate : $("txtToDate").value,
						     
				},
				asynchronous: false,
				onCreate: function(){
					showNotice("Extracting...please wait...");
				},
				onComplete : function(response){
					hideNotice();					
					if(checkErrorOnResponse(response)){
						var noOfExtractedRecs = trim(response.responseText);
						if(noOfExtractedRecs != 0)
							showMessageBox("Extraction Complete.", "S");
						else
							showMessageBox("Extraction finished. No records extracted.", "I");
					}
				}
			});
				
		}
		
		function getParams() {
			var params = "&fromDate=" + $("txtFromDate").value +
					 	 "&toDate=" + $("txtToDate").value +
					 	 "&intmNo=" + $("txtIntmNo").value +
					 	 "&issCd=" + $("txtIssCd").value +
					 	 "&lineCd=" + $("txtLineCd").value +
					 	 "&cutOffDate=" + $("txtCutOffDate").value;
			
			var dateParam = "";
			
			if($("rdoIssueDate").checked)	
				dateParam = "1";
			else if ($("rdoInceptDate").checked)
				dateParam = "2";
			else if ($("rdoBookingDate").checked)
				dateParam = "3";
			else
				dateParam = "4";
			
			params += "&dateParam=" + dateParam;
			
			var cutOffParam = "";
			
			if($("rdoTranDate").checked)
				cutOffParam = "1";
			else
				cutOffParam = "2";
			
			params += "&cutOffParam=" + cutOffParam;
			
			var issParam = "";
			
			if($("rdoCreditingBranch").checked)
				issParam = "1";
			else
				issParam = "2";
			
			params += "&issParam=" + issParam;
					 	 
			return params;
		}
		
		function printReport(){
			try {
				var repId = $("checkWithCollection").checked ? "GIACR275A" : "GIACR275";
				
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
		
		$("btnPrint").observe("click", function(){
			if($("txtFromDate").value == "")
				customShowMessageBox("Please enter From Date.", "E", "txtFromDate");
			else if ($("txtToDate").value == "")
				customShowMessageBox("Please enter To Date.", "E", "txtToDate");
			else {
				
				if($("checkWithCollection").checked && $("txtCutOffDate").value == ""){
					customShowMessageBox("Please enter Cut-Off Date.", "E", "txtCutOffDate");
				} else {
					var dest = $F("selDestination");
					
					if(dest == "printer"){
						if(checkAllRequiredFieldsInDiv("printDiv")){
							printReport();
						}
					}else{
						printReport();
					}	
				}
			}
				
		});
		
		function checkWithCollParams (issParam, dateParam) {
			if(tempFromDate == $("txtFromDate").value && tempToDate == $("txtToDate").value &&
			   tempIssCd == $("txtIssCd").value && tempLineCd  == $("txtLineCd").value &&
			   tempIntmNo == $("txtIntmNo").value && tempIssParam == issParam && tempDateParam  == dateParam)
				return false;
			
			tempFromDate = $("txtFromDate").value;
			tempToDate = $("txtToDate").value;
			tempIssCd = $("txtIssCd").value;
			tempLineCd  = $("txtLineCd").value;
			tempIntmNo = $("txtIntmNo").value;
			tempIssParam = issParam;
			tempDateParam  = dateParam;
			
			return true;
		}
		
		$("btnExtract").observe("click", function(){
			
			if($("txtFromDate").value == "")
				customShowMessageBox("Please enter From Date.", "E", "txtFromDate");
			else if ($("txtToDate").value == "")
				customShowMessageBox("Please enter To Date.", "E", "txtToDate");
			else {
				
				var branchParam = $("rdoCreditingBranch").checked ? "1" : "2";
				var paramDate = "";
					
				if($("rdoIssueDate").checked)	
					paramDate = "1";
				else if ($("rdoInceptDate").checked)
					paramDate = "2";
				else if ($("rdoBookingDate").checked)
					paramDate = "3";
				else
					paramDate = "4";			
				
				if($("checkWithCollection").checked){
					var temp = checkWithCollParams(branchParam, paramDate);
					
					if(!temp) {
						showConfirmBox("", "Data based from the given parameters were already extracted.<br/>Do you still want to continue?", "OK", "Cancel", function(){
							extractIntmProdColln(branchParam, paramDate);
						}, null);
					} else
						extractIntmProdColln(branchParam, paramDate);
				} else {
					extractWeb(branchParam, paramDate);
				}
				
			}
		});
		
		$("btnReloadForm").observe("click", resetForm);
		
		initGIACS275();
		initializeAll();
		
	} catch (e) {
		showErrorMessage("Agent Production", e);
	}
</script>