<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="jvRegisterMainDiv">
	<div id="outerDiv">
		<div id="innerDiv">
			<label>Journal Voucher Register</label>
			<span class="refreshers" style="margin-top: 0;">
	 			<label id="btnReloadForm" name="gro" style="margin-left: 5px;">Reload Form</label>
			</span>
		</div>
	</div>
	<div class="sectionDiv">
		<div style="margin: 30px auto; width: 600px; border: 1px solid #E0E0E0; padding: 3px;">
			<div style="border: 1px solid #E0E0E0; padding: 15px 0;">
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
						<td style="padding-left: 5px; width: 100px;">
							<div style="float: left; width: 140px; height: 20px; margin: 0;" class="withIconDiv required">
								<input type="text" id="txtToDate" class="withIcon required" readonly="readonly" style="width: 116px;" tabindex="202"/>
								<img id="imgToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="" style="margin : 1px 1px 0 0; cursor: pointer"/>
							</div>
						</td>
					</tr>
					<tr>
						<td><label for="txtBranchCd" style="float: right;">Branch</label></td>
						<td style="padding-left: 5px;" colspan="3">
							<span class="lovSpan" style="width: 70px; margin-bottom: 0;">
								<input type="text" id="txtBranchCd" style="width: 45px; float: left;" class="withIcon allCaps"  maxlength="2"  tabindex="204"/>  
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgBranchCd" alt="Go" style="float: right;" />
							</span>
							<input type="text" id="txtBranchName" readonly="readonly" style="margin: 0; height: 14px; width: 297px; margin-left: 2px;" tabindex="205"/>
						</td>
					</tr>
					<tr>
						<td><label for="txtTranClassCd" style="float: right;">Tran Class</label></td>
						<td style="padding-left: 5px;" colspan="3">
							<span class="lovSpan" style="width: 70px; margin-bottom: 0;">
								<input type="text" id="txtTranClassCd" style="width: 45px; float: left;" class="withIcon allCaps"  maxlength="3"  tabindex="206"/>  
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgTranClassCd" alt="Go" style="float: right;" />
							</span>
							<input type="text" id="txtTranClass" readonly="readonly" style="margin: 0; height: 14px; width: 297px; margin-left: 2px;" tabindex="207"/>
						</td>
						<td>
							<input type="checkbox" id="chkInclude" title="Include COL and DV"/>
						</td>
					</tr>
					<tr>
						<td><label for="txtJVTranTypeCd" style="float: right;">JV Tran Type</label></td>
						<td style="padding-left: 5px;" colspan="3">
							<span class="lovSpan" style="width: 70px; margin-bottom: 0;">
								<input type="text" id="txtJVTranTypeCd" style="width: 45px; float: left;" class="withIcon allCaps"  maxlength="3"  tabindex="208" rea/>  
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgJVTranTypeCd" alt="Go" style="float: right;" />
							</span>
							<input type="text" id="txtJVTranType" readonly="readonly" style="margin: 0; height: 14px; width: 297px; margin-left: 2px;" tabindex="209"/>
						</td>
					</tr>
				</table>
			</div>
			<div style="width: 100%; margin-top: 2px; float: left;">
				<div style="border: 1px solid #E0E0E0; width: 180px; height: 130px; float: left; margin-right: 2px;">
					<ul style="list-style: none; margin: 15px 10px; float: left;">
						<li>
							<input style="float: left;" type="radio" id="rdoDetail" name="opt1" tabindex="301" />
							<label style="margin-top: 4px;" for="rdoDetail">Detail</label>
							<ul style="clear: both; list-style: none; margin: 5px -15px; float: left; ">
								<li style="display: inline-block; margin-bottom: 10px; float: left;">
									<input style="float: left;" type="radio" id="rdoDate" name="opt2" tabindex="301" />
									<label style="margin-top: 4px;" for="rdoDate">Date</label>
								</li>
								<li>
									<input style="float: left;" type="radio" id="rdoRefNo" name="opt2" tabindex="301" />
									<label style="margin-top: 4px;" for="rdoRefNo">Ref No</label>
								</li>
							</ul>
						</li>
						<li>
							<input style="clear:both; float: left;" type="radio" id="rdoSummary" name="opt1" tabindex="302" />
							<label style="float: right; margin-top: 4px;" for="rdoSummary">Summary</label>
						</li>
					</ul>
				</div>
				<div id="printDiv" style="border: 1px solid #E0E0E0; height: 130px; width: 414px; float: left;">
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
								<!-- removed print to excel option by robert SR 5201 02.09.16
								<input value="EXCEL" title="Excel" type="radio" id="rdoExcel" name="fileType" tabindex="307" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="rdoExcel" style="margin: 2px 0 4px 0">Excel</label> -->
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
			</div>
			<div>
				<input type="button" class="button" value="Print" tabindex="401" id="btnPrint" style="width: 120px; margin: 10px auto;"/>
			</div>
		</div>
	</div>
</div>
<script>
	try {
		
		var onLOV = false;
		var checkBranch = "";
		var checkTranClass = "";
		var checkJVTran = "";
		
		function initGIACS127(){
			setModuleId("GIACS127");
			setDocumentTitle("Journal Voucher Register");
			$("chkTranDate").checked = true;
			$("txtBranchName").value = "ALL BRANCHES";
			$("txtTranClass").value = "ALL TRANSACTION CLASSES";
			$("txtJVTranType").value = "ALL TRANSACTION TYPES";
			$("rdoDetail").checked = true;
			$("rdoDate").checked = true;
			$("txtJVTranTypeCd").readOnly = true;
			$("txtJVTranType").readOnly = true;
			$("txtJVTranType").setStyle({color : "gray"});
			disableSearch("imgJVTranTypeCd");
		}
		
		function resetForm() {
			onLOV = false;
			
			$("chkTranDate").checked = true;
			$("chkPostingDate").checked = false;
			$("txtFromDate").clear();
			$("txtToDate").clear();
			$("txtBranchCd").clear();
			$("txtTranClassCd").clear();
			$("txtJVTranTypeCd").clear();
			$("txtBranchName").value = "ALL BRANCHES";
			$("txtTranClass").value = "ALL TRANSACTION CLASSES";
			$("txtJVTranType").value = "ALL TRANSACTION TYPES";
			$("selDestination").selectedIndex = 0;
			toggleRequiredFields("screen");
			checkBranch = "";
			checkTranClass = "";
			checkJVTran = "";
			$("rdoDetail").checked = true;
			$("rdoDate").enable();
			$("rdoRefNo").enable();
			$("rdoDate").checked = true;
			$("txtJVTranTypeCd").readOnly = true;
			$("txtJVTranType").readOnly = true;
			$("txtJVTranType").setStyle({color : "gray"});
			disableSearch("imgJVTranTypeCd");
			$("chkInclude").checked = false;
		}
		
		$("btnReloadForm").observe("click", resetForm);
		
		function getGIACS127BranchLOV() {
			if(onLOV) return;
			onLOV = true;
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGIACS127BranchLOV",
					searchString : checkBranch == "" ? $("txtBranchCd").value : "",
					moduleId: 'GIACS127',
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
				filterText:  checkBranch == "" ? $("txtBranchCd").value : "",
				onSelect : function(row) {
					onLOV = false;
					$("txtBranchCd").value = row.branchCd;
					$("txtBranchName").value = row.branchName;
					checkBranch = row.branchCd;
				},
				onCancel : function () {
					onLOV = false;
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtBranchCd");
					onLOV = false;
				}
			});
		}
		
		$("imgBranchCd").observe("click", getGIACS127BranchLOV);
		
		function getGIACS127TranClass() {
			if(onLOV) return;
			onLOV = true;
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGIACS127TranClass",
					searchString : checkTranClass == "" ? $("txtTranClassCd").value : "",
					chkInclude : $("chkInclude").checked ? true : false,
					page : 1
				},
				title : "Transaction Classes",
				width : 480,
				height : 386,
				columnModel : [ 
					{
						id : "rvLowValue",
						title : "Tran Class",
						width : '90px',
					},
					{
						id : "rvMeaning",
						title : "Description",
						width : '375px',
						renderer: function(value) {
							return unescapeHTML2(value);
						}
					}
				],
				draggable : true,
				autoSelectOneRecord: true,
				filterText:  checkTranClass == "" ? $("txtTranClassCd").value : "",
				onSelect : function(row) {
					onLOV = false;
					$("txtTranClassCd").value = row.rvLowValue;
					$("txtTranClass").value = row.rvMeaning;
					checkTranClass = row.rvLowValue;
					if(row.rvLowValue == "JV") {
						$("txtJVTranTypeCd").readOnly = false;
						$("txtJVTranType").setStyle({color : "black"});
						enableSearch("imgJVTranTypeCd");
						$("txtJVTranTypeCd").focus();
					} else {
						$("txtJVTranTypeCd").readOnly = true;
						$("txtJVTranType").readOnly = true;
						$("txtJVTranType").setStyle({color : "gray"});
						disableSearch("imgJVTranTypeCd");
						$("txtJVTranType").value = "ALL TRANSACTION TYPES";
						$("txtJVTranTypeCd").clear();
					}
				},
				onCancel : function () {
					onLOV = false;
					if($("txtTranClassCd").value == "")
						$("txtTranClass").value = "ALL TRANSACTION CLASSES";
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtTranClassCd");
					onLOV = false;
					if($("txtTranClassCd").value == "")
						$("txtTranClass").value = "ALL TRANSACTION CLASSES";
				}
			});
		}
		
		$("imgTranClassCd").observe("click", getGIACS127TranClass);
		
		function getGIACS127JVTran() {
			if(onLOV) return;
			onLOV = true;
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGIACS127JVTran",
					searchString : checkJVTran == "" ? $("txtJVTranTypeCd").value : "",
					page : 1
				},
				title : "JV Transaction Types",
				width : 480,
				height : 386,
				columnModel : [ 
					{
						id : "jvTranCd",
						title : "JV Tran",
						width : '90px',
					},
					{
						id : "jvTranDesc",
						title : "JV Description",
						width : '375px',
						renderer: function(value) {
							return unescapeHTML2(value);
						}
					}
				],
				draggable : true,
				autoSelectOneRecord: true,
				filterText:  checkJVTran == "" ? $("txtJVTranTypeCd").value : "",
				onSelect : function(row) {
					onLOV = false;
					$("txtJVTranTypeCd").value = row.jvTranCd;
					$("txtJVTranType").value = row.jvTranDesc;
					checkJVTran= row.jvTranCd;
				},
				onCancel : function () {
					onLOV = false;
					if($("txtJVTranTypeCd").value == "")
						$("txtJVTranType").value = "ALL TRANSACTION TYPES";
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtJVTranTypeCd");
					onLOV = false;
					if($("txtJVTranTypeCd").value == "")
						$("txtJVTranType").value = "ALL TRANSACTION TYPES";
				}
			});
		}
		
		$("imgJVTranTypeCd").observe("click", getGIACS127JVTran);
		
		$("txtBranchCd").observe("keypress", function(event){
			if(event.keyCode == objKeyCode.ENTER) {
				getGIACS127BranchLOV();	
			} else if(event.keyCode == 8 || event.keyCode == 46 || event.keyCode == 0) {
				$("txtBranchName").clear();
				checkBranch = ""; 
			}
		});
		
		$("txtBranchCd").observe("blur", function(){
			if(this.value == "")
				$("txtBranchName").value = "ALL BRANCHES";
		});
		
		$("txtTranClassCd").observe("keypress", function(event){
			if(event.keyCode == objKeyCode.ENTER) {
				getGIACS127TranClass();	
			} else if(event.keyCode == 8 || event.keyCode == 46 || event.keyCode == 0) {
				$("txtTranClass").clear();
				checkTranClass = "";
				$("txtJVTranTypeCd").readOnly = true;
				$("txtJVTranType").readOnly = true;
				$("txtJVTranType").setStyle({color : "gray"});
				disableSearch("imgJVTranTypeCd");
				$("txtJVTranType").value = "ALL TRANSACTION TYPES";
				$("txtJVTranTypeCd").clear();
			}
		});
		
		$("txtTranClassCd").observe("blur", function(){
			if(this.value == "")
				$("txtTranClass").value = "ALL TRANSACTION CLASSES";
		});
		
		$("txtJVTranTypeCd").observe("keypress", function(event){
			if($("txtJVTranTypeCd").readOnly)
				return;
			if(event.keyCode == objKeyCode.ENTER) {
				getGIACS127JVTran();	
			} else if(event.keyCode == 8 || event.keyCode == 46 || event.keyCode == 0) {
				$("txtJVTranType").clear();
				checkJVTran = ""; 
			}
		});
		
		$("txtJVTranTypeCd").observe("blur", function(){
			if(this.value == "")
				$("txtJVTranType").value = "ALL TRANSACTION TYPES"; 
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
			if ($("imgFromDate").disabled) return;
			
			var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g,"/")) :"";
			var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g,"/")) :"";
			
			if (toDate < fromDate && toDate != ""){
				showMessageBox("From Date should not be later than To Date.", "I");
				$("txtFromDate").clear();
				return false;
			}
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
		
		observeBackSpaceOnDate("txtFromDate");
		observeBackSpaceOnDate("txtToDate");
		
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
				//$("rdoExcel").disable();	removed print to excel option by robert SR 5201 02.09.16
				$("csvRB").disable();	
			} else {
				if(dest == "file"){
					$("rdoPdf").enable();
					//$("rdoExcel").enable(); removed print to excel option by robert SR 5201 02.09.16
					$("csvRB").enable();	
				} else {
					$("rdoPdf").disable();
					//$("rdoExcel").disable(); removed print to excel option by robert SR 5201 02.09.16
					$("csvRB").disable();	
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
		
		$("rdoDetail").observe("click", function() {
			$("rdoDate").enable();
			$("rdoRefNo").enable();
			$("rdoDate").checked = true;
		});
		
		$("rdoSummary").observe("click", function(){
			$("rdoDate").disable();
			$("rdoRefNo").disable();
			$("rdoDate").checked = false;
			$("rdoRefNo").checked = false;
		});
		
		$("txtBranchName").observe("focus", function(){
			if($("txtBranchCd").value != ""){
				var response = validateField("/GIACBranchController","validateGIACBranchCd");
				if(response == "ERROR") {
					customShowMessageBox("Invalid Branch Code", "E", "txtBranchCd");
					$("txtBranchCd").clear();
				} else {
					$("txtBranchName").value = response;
				}
			}
				
		});
		
		$("txtTranClass").observe("focus", function(){
			if($("txtTranClassCd").value != ""){
				var response = validateField("/CGRefCodesController","validateGIACS127TranClass");
				if(response == "ERROR") {
					customShowMessageBox("Invalid Transaction Class", "E", "txtTranClassCd");
					$("txtTranClassCd").clear();
				} else {
					$("txtTranClass").value = response;
					if(response == "Journal Voucher") {
						$("txtJVTranTypeCd").readOnly = false;
						$("txtJVTranType").setStyle({color : "black"});
						enableSearch("imgJVTranTypeCd");
						$("txtJVTranTypeCd").focus();
					} else {
						$("txtJVTranTypeCd").readOnly = true;
						$("txtJVTranType").readOnly = true;
						$("txtJVTranType").setStyle({color : "gray"});
						disableSearch("imgJVTranTypeCd");
						$("txtJVTranType").value = "ALL TRANSACTION TYPES";
						$("txtJVTranTypeCd").clear();
					}
				}
			}
				
		});
		
		$("txtJVTranType").observe("focus", function(){
			if($("txtJVTranTypeCd").value != "" && !$("txtJVTranTypeCd").readOnly){
				var response = validateField("/CGRefCodesController","validateGIACS127JVTran");
				if(response == "ERROR") {
					customShowMessageBox("Invalid Transaction Type", "E", "txtJVTranTypeCd");
					$("txtJVTranTypeCd").clear();
				} else {
					$("txtJVTranType").value = response;
				}
			}
				
		});
		
		function validateField(controller, action) {
			var ajaxResponse = "";
			var branchCd = $("txtBranchCd").value;
			var rvLowValue = $("txtTranClassCd").value;
			var jvTranCd = $("txtJVTranTypeCd").value;
			var chkInclude = $("chkInclude").checked ? true : false;
			
			new Ajax.Request(contextPath + controller,{
				method: "POST",
				parameters: {
						     action : action,
						     branchCd : branchCd,
						     rvLowValue : rvLowValue,
						     jvTranCd : jvTranCd,
						     chkInclude : chkInclude,
						     moduleId : "GIACS127"
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
			var orderBy = $("rdoDate").checked ? "4" : "7";
			var colDv = $("chkInclude").checked ? "Y" : "N";
			var params = "&branchCd=" + $("txtBranchCd").value
						+ "&tranClass=" + $("txtTranClassCd").value
						+ "&jvTranCd=" + $("txtJVTranTypeCd").value
						+ "&tranPost=" + dateOpt
						+ "&fromDate=" + $("txtFromDate").value
						+ "&toDate=" + $("txtToDate").value
						+ "&orderBy=" + orderBy
						+ "&colDv=" + colDv;
			return params;
		}
		
		function printReport(){
			try {
				var repId = $("rdoDetail").checked ? "GIACR138" : "GIACR138B";
				var fileType = "";
				if($("rdoPdf").checked){
					fileType = "PDF";
				//}else if ($("rdoExcel").checked){
				//	fileType = "XLS"; removed print to excel option by robert SR 5201 02.09.16
				}else if ($("csvRB").checked){
					fileType = "CSV";
				}
				
				var content = contextPath + "/GeneralLedgerPrintController?action=printReport"
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
									  fileType : fileType},
						onCreate: showNotice("Generating report, please wait..."),
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
// 								copyFileToLocal(response, "reports");
								if($("geniisysAppletUtil") == null || $("geniisysAppletUtil").copyFileToLocal == undefined){
									showMessageBox("Local printer applet is not configured properly. Please verify if you have accepted to run the Geniisys Utility Applet and if the java plugin in your browser is enabled.", imgMessage.ERROR);
								} else {
									var message = "";
									if ($("csvRB").checked){
										message = $("geniisysAppletUtil").copyFileToLocal(response.responseText, "csv");
										deleteCSVFileFromServer(response.responseText);
									}else{
										message = $("geniisysAppletUtil").copyFileToLocal(response.responseText, "reports");
									}
									if(message.include("SUCCESS")){
										showMessageBox("Report file generated to " + message.substring(9), "I");	
									} else {
										showMessageBox(message, "E");
									}
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
			if($("txtFromDate").value == "" && $("txtToDate").value == "")
				customShowMessageBox("Please enter From Date and To Date.", "E", "txtFromDate");
			else if($("txtFromDate").value == "")
				customShowMessageBox("Please enter From Date.", "E", "txtFromDate");
			else if ($("txtToDate").value == "")
				customShowMessageBox("Please enter To Date.", "E", "txtToDate");
			else {
			
				if($("txtBranchCd").value != ""){
					var response = validateField("/GIACBranchController","validateGIACBranchCd");
					if(response == "ERROR") {
						customShowMessageBox("Invalid Branch Code", "E", "txtBranchCd");
						$("txtBranchCd").clear();
						return;
					} else {
						$("txtBranchName").value = response;
					}
				}
				
				if($("txtTranClassCd").value != ""){
					var response = validateField("/CGRefCodesController","validateGIACS127TranClass");
					if(response == "ERROR") {
						customShowMessageBox("Invalid Transaction Class", "E", "txtTranClassCd");
						$("txtTranClassCd").clear();
						return;
					} else {
						$("txtTranClass").value = response;
						if(response == "Journal Voucher") {
							$("txtJVTranTypeCd").readOnly = false;
							$("txtJVTranType").setStyle({color : "black"});
							enableSearch("imgJVTranTypeCd");
							$("txtJVTranTypeCd").focus();
						} else {
							$("txtJVTranTypeCd").readOnly = true;
							$("txtJVTranType").readOnly = true;
							$("txtJVTranType").setStyle({color : "gray"});
							disableSearch("imgJVTranTypeCd");
							$("txtJVTranType").value = "ALL TRANSACTION TYPES";
							$("txtJVTranTypeCd").clear();
						}
					}
				}
				
				if($("txtJVTranTypeCd").value != "" && !$("txtJVTranTypeCd").readOnly){
					var response = validateField("/CGRefCodesController","validateGIACS127JVTran");
					if(response == "ERROR") {
						customShowMessageBox("Invalid Transaction Type", "E", "txtJVTranTypeCd");
						$("txtJVTranTypeCd").clear();
						return;
					} else {
						$("txtJVTranType").value = response;
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
		
		initGIACS127();
		initializeAll(); 
	} catch (e) {
		showErrorMessage("Journal Voucher Register", e);
	}
</script>