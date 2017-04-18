<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="printGLTransacionsMainDiv">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Print GL Transactions</label>
			<span class="refreshers" style="margin-top: 0;">
	 			<label id="btnReloadForm" name="gro" style="margin-left: 5px;">Reload Form</label>
			</span>
		</div>
	</div>
	<div class="sectionDiv">
		<table align="center" style="margin-top: 10px; margin-bottom: 10px;">
			<tr>
				<td>
					<label for="txtCompany">Company</label>
				</td>
				<td style="padding-left: 5px;">
					<span class="lovSpan required" style="width: 400px; margin-bottom: 0;">
						<input type="text" id="txtCompany" style="width: 375px; float: left;" class="withIcon allCaps required" tabindex="101"/>  
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgCompany" alt="Go" style="float: right;" />
					</span>
				</td>
				<td>
					<label for="txtBranch" style="margin-left: 20px;">Branch</label>
				</td>
				<td style="padding-left: 5px;">
					<span class="lovSpan required" style="width: 240px; margin-bottom: 0;">
						<input type="text" id="txtBranch" style="width: 215px; float: left;" class="withIcon allCaps required" tabindex="102"/>  
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgBranch" alt="Go" style="float: right;" />
					</span>
				</td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv" style="margin: 1px 0; padding: 20px 0;">
		<table align="center" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<label for="txtSub1" style="float: right;">GL Account Code</label>
				</td>
				<td style="padding-left: 5px;">
					<input type="text" id=txtCategory class="integerNoNegativeUnformattedNoComma" maxlength="1" style="width: 20px; height: 14px; float: left; margin-right: 2px; text-align: right;" tabindex="201" />
					<input type="text" id="txtControl" class="integerNoNegativeUnformattedNoComma" maxlength="2" style="width: 20px; height: 14px; float: left; margin-right: 2px; text-align: right;" tabindex="202"/>
					<input type="text" id="txtSub1" class="integerNoNegativeUnformattedNoComma" maxlength="2" style="width: 20px; height: 14px; float: left; margin-right: 2px; text-align: right;" tabindex="203"/>
					<input type="text" id="txtSub2" class="integerNoNegativeUnformattedNoComma" maxlength="2" style="width: 20px; height: 14px; float: left; margin-right: 2px; text-align: right;" tabindex="204"/>
					<input type="text" id="txtSub3" class="integerNoNegativeUnformattedNoComma" maxlength="2" style="width: 20px; height: 14px; float: left; margin-right: 2px; text-align: right;" tabindex="205"/>
					<input type="text" id="txtSub4" class="integerNoNegativeUnformattedNoComma" maxlength="2" style="width: 20px; height: 14px; float: left; margin-right: 2px; text-align: right;" tabindex="206"/>
					<input type="text" id="txtSub5" class="integerNoNegativeUnformattedNoComma" maxlength="2" style="width: 20px; height: 14px; float: left; margin-right: 2px; text-align: right;" tabindex="207"/>
					<input type="text" id="txtSub6" class="integerNoNegativeUnformattedNoComma" maxlength="2" style="width: 20px; height: 14px; float: left; margin-right: 2px; text-align: right;" tabindex="208"/>
					<input type="text" id="txtSub7" class="integerNoNegativeUnformattedNoComma" maxlength="2" style="width: 20px; height: 14px; float: left; text-align: right;" tabindex="209"/>
					<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgGLCode" style="float: left; margin: 4px 0 0 4px; cursor: pointer; height: 17px; width: 18px;" />
				</td>
			</tr>
			<tr>
				<td>
					<label for="txtGLAcctName" style="float: right;">GL Account Name</label>
				</td>
				<td style="padding-left: 5px;">
					<input type="text" id="txtGLAcctName" style="height: 14px; width: 404px; float: left;" readonly="readonly" tabindex="210"/>
				</td>
			</tr>
			<tr>
				<td>
					<label for="txtTransactionClass" style="float: right;">Transaction Class</label>
				</td>
				<td style="padding-left: 5px;">
					<span class="lovSpan" style="width: 410px; margin-bottom: 0; margin-top: 2px;">
						<input type="text" id="txtTranClass" style="width: 385px; float: left;" class="withIcon allCaps" tabindex="211"/>  
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgTranClass" alt="Go" style="float: right;" />
					</span>
				</td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv" style="margin: 1px 0;">
		<div style="width: 200px; height: 180px; float: left;">
			<table align="center" style="margin-top: 20px;">
				<tr>
					<td colspan="2"><label>Report Type</label></td>
				</tr>
				<tr>
					<td><input type="radio" id="rdoSummary" name="radioGroup1" style="margin: 10px 0 0 40px;" tabindex="301"/></td>
					<td><label for="rdoSummary" style="margin: 10px 0 0 5px;">Summary</label></td>
				</tr>
				<tr>
					<td><input type="radio" id="rdoDetailed1" name="radioGroup1" style="margin: 10px 0 0 40px;" tabindex="302"/></td>
					<td><label for="rdoDetailed1" style="margin: 10px 0 0 5px;">Detailed - Layout 1</label></td>
				</tr>
				<tr>
					<td><input type="radio" id="rdoDetailed2" name="radioGroup1" style="margin: 10px 0 0 40px;" tabindex="303"/></td>
					<td><label for="rdoDetailed2" style="margin: 10px 0 0 5px;">Detailed - Layout 2</label></td>
				</tr>
			</table>
		</div>
		<div style="width: 400px; height: 180px; float: left;">
			<table align="center" style="margin-top: 20px; margin-left: 20px;; width: 400px;" border="0">
				<tr>
					<td colspan="2"><label>Period Covered</label></td>
				</tr>
				<tr>
					<td><input type="radio" id="rdoTransactionDate" name="radioGroup2" style="margin: 10px 0 0 40px;" tabindex="304"/></td>
					<td><label for="rdoTransactionDate" style="margin: 10px 0 0 5px;">Based on Transaction Date</label></td>
				</tr>
				<tr>
					<td><input type="radio" id="rdoDatePosted" name="radioGroup2" style="margin: 10px 0 0 40px;" tabindex="305"/></td>
					<td><label for="rdoDatePosted" style="margin: 10px 0 0 5px;">Based on Date Posted</label></td>
				</tr>
				<tr>
					<td colspan="2">
						<label for="txtFromDate" style="margin-top: 18px; margin-right: 5px; margin-left: 50px;">From</label>
						<div style="float: left; width: 125px; height: 20px; margin: 15px 3px 0 5px;" class="withIconDiv required">
							<input type="text" id="txtFromDate" class="withIcon required" readonly="readonly" style="width: 100px;" tabindex="306"/>
							<img id="imgFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="" style="margin : 1px 1px 0 0; cursor: pointer"/>
						</div>
						<label for="txtToDate" style="margin-top: 18px; margin-right: 5px; margin-left: 20px;">To</label>
						<div style="float: left; width: 125px; height: 20px; margin: 15px 3px 0 5px;" class="withIconDiv required">
							<input type="text" id="txtToDate" class="withIcon required" readonly="readonly" style="width: 100px;" tabindex="307"/>
							<img id="imgToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="" style="margin : 1px 1px 0 0; cursor: pointer"/>
						</div>
					</td>
				</tr>
			</table>
		</div>
		<div style="width: 270px; height: 180px; float: right; padding-right: 30px;">
			<table align="center" style="margin-top: 20px;">
				<tr>
					<td colspan="2"><label>Other Options</label></td>
				</tr>
				<tr>
					<td><input type="checkbox" id="chkIncludeSubAccts" style="margin: 10px 0 0 40px;" tabindex="308"/></td>
					<td><label for="rdoSummary" style="margin: 10px 0 0 5px;">Include Sub Accounts</label></td>
				</tr>
				<tr>
					<td><input type="checkbox" id="chkSLTag" style="margin: 10px 0 0 40px;" tabindex="309"/></td>
					<td>
						<label for="chkSLTag" style="margin: 10px 0 0 5px;">With SL Code :</label>
						<span class="lovSpan" style="width: 85px; margin: 6px 0px 0px 5px;">
							<input type="text" id="txtSLCd" style="height: 14px; width: 55px; float: left; text-align: right;" class="withIcon integerNoNegativeUnformattedNoComma" tabindex="310" lastValidValue="" ignoreDelKey=""/>  
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSLCd" alt="Go" style="float: right;" />
						</span>
					</td>
				</tr>
				<tr>
					<td><input type="checkbox" id="chkOpenTransTag" style="margin: 4px 0 0 40px;" tabindex="311"/></td>
					<td><label for="chkOpenTransTag" style="margin: 4px 0 0 5px;">Exclude Open Transactions</label></td>
				</tr>
				<tr>
					<td><input type="checkbox" id="chkConsolidateAllBranches" style="margin: 10px 0 0 40px;" tabindex="312"/></td>
					<td><label for="chkConsolidateAllBranches" style="margin: 10px 0 0 5px;">Consolidate All Branches</label></td>
				</tr>
				<tr><!-- added by jhing 01.26.2016 from Temp Solution done by vondanix RSIC 20691 10.22.2015 -->
					<td><input type="checkbox" id="chkIncludeBeginBalance" style="margin: 10px 0 0 40px;" tabindex="313"/></td>
					<td><label for="chkIncludeBeginBalance" style="margin: 10px 0 0 5px;">Include Beginning Balance</label></td>
				</tr>
				
			</table>
		</div>
	</div>
	<div class="sectionDiv" style="margin: 1px 0 50px 0;">
		<div id="printDiv" style="border: 1px solid #E0E0E0; height: 150px; width: 370px; margin: 10px auto;">
			<table align="center" style="margin-top: 15px;">
				<tr>
					<td class="rightAligned">Destination</td>
					<td class="leftAligned">
						<select id="selDestination" style="width: 200px;" tabindex="401">
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
						<input value="PDF" title="PDF" type="radio" id="rdoPdf" name="fileType" tabindex="402" style="margin: 2px 5px 4px 5px; float: left;" checked="checked" disabled="disabled"><label for="rdoPdf" style="margin: 2px 0 4px 0">PDF</label>
						<input value="EXCEL" title="Excel" type="radio" id="rdoExcel" name="fileType" tabindex="403" style="margin: 2px 4px 4px 25px; float: left;;display:none" disabled="disabled"><label for="rdoExcel" style="margin: 2px 0 4px 0;display:none">Excel</label>   <!--  jhing GENQA 5080,5200 hide Excel -->
						<input value="CSV" title="CSV" type="radio" id="rdoCsv" name="fileType" tabindex="404" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="rdoCsv" style="margin: 2px 0 4px 0">CSV</label>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Printer</td>
					<td class="leftAligned">
						<select id="selPrinter" style="width: 200px;" class="required" tabindex="404">
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
						<input type="text" id="txtNoOfCopies" tabindex="405" style="float: left; text-align: right; width: 175px;" class="required integerNoNegativeUnformattedNoComma">
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
		<div style="margin: 0 auto;">
			<input type="button" id="btnPrint" class="button" value="Print" style="width: 120px; margin: 5px 0 15px 0;" tabindex="501"/>
		</div>
	</div>
</div>
<script type="text/javascript">
	try {
		
		setModuleId("GIACS060");
		setDocumentTitle("Print GL Transactions");
		var onLOV = false;
		var checkCompany = "";
		var checkBranch = "";
		var checkGLAcctCode = "";
		var checkTranClass = "";
		objGIACS060 = new Object();
		objGIACS060.tranClass = "";
		$("rdoSummary").checked = true;
		$("rdoTransactionDate").checked = true;
		$("txtCompany").focus();
		$("txtSLCd").disable();
		$("chkIncludeBeginBalance").disable(); //added by jhing 01.26.2016 from Temp Solution done by vondanix RSIC 20691 10.22.2015

		
		function resetForm(){
			onLOV = false;
			checkCompany = "";
			checkBranch = "";
			checkGLAcctCode = "";
			checkTranClass = "";
			objGIACS060 = new Object();
			$("txtCompany").focus();
			$("rdoSummary").checked = true;
			$("rdoTransactionDate").checked = true;
			$("chkSLTag").enable();
			$("txtSLCd").enable();
			$("chkIncludeSubAccts").checked = false;
			$("chkSLTag").checked = false;
			$("chkOpenTransTag").checked = false;
			$("chkConsolidateAllBranches").checked = false;
			$("chkIncludeBeginBalance").checked = false; //added by jhing 01.26.2016 from Temp Solution done by vondanix RSIC 20691 10.22.2015 
			$("chkIncludeBeginBalance").disable(); //added by jhing 01.26.2016 from Temp Solution done by vondanix RSIC 20691 10.22.2015

			$("txtSLCd").disable();
			$("txtCompany").clear();
			$("txtBranch").clear();
			$("txtTranClass").clear();
			$("txtFromDate").clear();
			$("txtToDate").clear();
			$("txtSLCd").clear();
			$("txtCategory").clear();
			$("txtControl").clear();
			$("txtSub1").clear();
			$("txtSub2").clear();
			$("txtSub3").clear();
			$("txtSub4").clear();
			$("txtSub5").clear();
			$("txtSub6").clear();
			$("txtSub7").clear();
			$("txtSLCd").setAttribute("lastValidValue", "");
			$("txtGLAcctName").clear();
			toggleRequiredFields("screen");
			objGIACS060.tranClass = "";
		}
		
		$("btnReloadForm").observe("click", resetForm);
		//$("btnReloadForm").observe("click", showGIACS060);
		
		function getCompanyLOV() {
			if(onLOV) return;
			onLOV = true;
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getCompanyLOV",
					searchString : checkCompany == "" ? $("txtCompany").value : "",
					page : 1
				},
				title : "Bank Accounts",
				width : 454,
				height : 386,
				columnModel : [ 
					{
						id : "fundCd",
						title : "Company Code",
						width : '90px',
					},
					{
						id : "fundDesc",
						title : "Name",
						width : '350px',
						renderer: function(value) {
							return unescapeHTML2(value);
						}
					}
				],
				draggable : true,
				autoSelectOneRecord: true,
				filterText:  checkCompany == "" ? $("txtCompany").value : "",
				onSelect : function(row) {
					onLOV = false;
					$("txtCompany").value = row.fundCd + " - " + unescapeHTML2(row.fundDesc);
					checkCompany = row.fundCd;
					objGIACS060.fundCd = row.fundCd;
					$("txtBranch").focus();
				},
				onCancel : function () {
					onLOV = false;
					$("txtCompany").focus();
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtCompany");
					onLOV = false;
				}
			});
		}
		
		function getBranchPerFundLOV() {
			if(onLOV) return;
			onLOV = true;
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getBranchPerFundLOV",
					searchString : checkBranch == "" ? $("txtBranch").value : "",
					moduleId : "GIACS060",
					fundCd : nvl(objGIACS060.fundCd, ""),
					page : 1
				},
				title : "Bank Accounts",
				width : 395,
				height : 386,
				columnModel : [ 
					{
						id : "branchCd",
						title : "Branch Code",
						width : '90px',
					},
					{
						id : "branchName",
						title : "Branch Name",
						width : '290px',
						renderer: function(value) {
							return unescapeHTML2(value);
						}
					}
				],
				draggable : true,
				autoSelectOneRecord: true,
				filterText:  checkBranch == "" ? $("txtBranch").value : "",
				onSelect : function(row) {
					onLOV = false;
					$("txtBranch").value = row.branchCd + " - " + unescapeHTML2(row.branchName);
					checkBranch = row.branchCd;
					objGIACS060.branchCd =  row.branchCd;
					$("txtCategory").focus();
				},
				onCancel : function () {
					onLOV = false;
					$("txtBranch").focus();
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtBranch");
					onLOV = false;
				}
			});
		}
		
		function getGIACS060GLAcctCdLOV() {
			if(onLOV) return;
			onLOV = true;
			LOV.show({
				controller : "AccountingLOVController",
				filterVersion: "2",
				urlParameters : {
					action : "getGIACS060GLAcctCdLOV",
					//searchString : checkBranch == "" ? $("txtBranch").value : "",
					moduleId : "GIACS060",
					//fundCd : objGIACS060.fundCd,
					glAcctCategory : $("txtCategory").value,
					glControlAcct : removeLeadingZero($("txtControl").value),
					glSubAcct1 : removeLeadingZero($("txtSub1").value),
					glSubAcct2 : removeLeadingZero($("txtSub2").value),
					glSubAcct3 : removeLeadingZero($("txtSub3").value),
					glSubAcct4 : removeLeadingZero($("txtSub4").value),
					glSubAcct5 : removeLeadingZero($("txtSub5").value),
					glSubAcct6 : removeLeadingZero($("txtSub6").value),
					glSubAcct7 : removeLeadingZero($("txtSub7").value),
					glAcctId : checkGLAcctCode,
					page : 1
				},
				title : "Valid Values for GL Account Code",
				width : 700,
				height : 403,
				columnModel : [ 
					{
						id : "glAcctCategory",
						title : "Category",
						width : '65px',
						align: 'right',
						titleAlign : 'right',
						filterOption: true,
						filterOptionType : "integerNoNegative"
					},
					{
						id : "glControlAcct",
						title : "Ctrl Acc",
						width : '65px',
						align: 'right',
						titleAlign : 'right',
						filterOption: true,
						filterOptionType : "integerNoNegative"
					},
					{
						id : "glSubAcct1",
						title : "Sub Acct 1",
						width : '65px',
						align: 'right',
						titleAlign : 'right',
						filterOption: true,
						filterOptionType : "integerNoNegative"
					},
					{
						id : "glSubAcct2",
						title : "Sub Acct 2",
						width : '65px',
						align: 'right',
						titleAlign : 'right',
						filterOption: true,
						filterOptionType : "integerNoNegative"
					},
					{
						id : "glSubAcct3",
						title : "Sub Acct 3",
						width : '65px',
						align: 'right',
						titleAlign : 'right',
						filterOption: true,
						filterOptionType : "integerNoNegative"
					},
					{
						id : "glSubAcct4",
						title : "Sub Acct 4",
						width : '65px',
						align: 'right',
						titleAlign : 'right',
						filterOption: true,
						filterOptionType : "integerNoNegative"
					},
					{
						id : "glSubAcct5",
						title : "Sub Acct 5",
						width : '65px',
						align: 'right',
						titleAlign : 'right',
						filterOption: true,
						filterOptionType : "integerNoNegative"
					},
					{
						id : "glSubAcct6",
						title : "Sub Acct 6",
						width : '65px',
						align: 'right',
						titleAlign : 'right',
						filterOption: true,
						filterOptionType : "integerNoNegative"
					},
					{
						id : "glSubAcct7",
						title : "Sub Acct 7",
						width : '65px',
						align: 'right',
						titleAlign : 'right',
						filterOption: true,
						filterOptionType : "integerNoNegative"
					},
					{
						id : "glAcctName",
						title : "GL Acct Name",
						width : '300px',
						filterOption: true,
						renderer : function (val) {
							return unescapeHTML2(val);
						}
					}
					
				],
				draggable : true,
				autoSelectOneRecord: true,
				//filterText:  checkBranch == "" ? $("txtBranch").value : "",
				onSelect : function(row) {
					onLOV = false;
					$("txtCategory").value = row.glAcctCategory;
					$("txtControl").value = formatNumberDigits(row.glControlAcct, 2);
					$("txtSub1").value = formatNumberDigits(row.glSubAcct1, 2);
					$("txtSub2").value = formatNumberDigits(row.glSubAcct2, 2);
					$("txtSub3").value = formatNumberDigits(row.glSubAcct3, 2);
					$("txtSub4").value = formatNumberDigits(row.glSubAcct4, 2);
					$("txtSub5").value = formatNumberDigits(row.glSubAcct5, 2);
					$("txtSub6").value = formatNumberDigits(row.glSubAcct6, 2);
					$("txtSub7").value = formatNumberDigits(row.glSubAcct7, 2);
					$("txtGLAcctName").value = unescapeHTML2(row.glAcctName);
					$("txtSLCd").value = "";
					
					checkGLAcctCode = row.glAcctId;
					checkBeginBalanceConditions();  //added by jhing 01.26.2016 from Temp Solution done by vondanix RSIC 20691 10.22.2015
					$("txtTranClass").focus();
				},
				onCancel : function () {
					onLOV = false;
					$("txtCategory").focus();
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtCategory");
					onLOV = false;
				}
			});
		}
		
		function getGIACS060TranClassLOV() {
			if(onLOV) return;
			onLOV = true;
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGIACS060TranClassLOV",
					searchString : checkTranClass == "" ? $("txtTranClass").value : "",
					//moduleId : "GIACS060",
					//fundCd : objGIACS060.fundCd,
					page : 1
				},
				title : "Transaction Class",
				width : 395,
				height : 386,
				columnModel : [ 
					{
						id : "tranClass",
						title : "Tran Class",
						width : '90px',
					},
					{
						id : "description",
						title : "Description",
						width : '290px',
						renderer: function(value) {
							return unescapeHTML2(value);
						}
					}
				],
				draggable : true,
				autoSelectOneRecord: true,
				filterText:  checkTranClass == "" ? $("txtTranClass").value : "",
				onSelect : function(row) {
					onLOV = false;
					$("txtTranClass").value = row.tranClass + " - " + unescapeHTML2(row.description);
					checkTranClass = row.tranClass;
					objGIACS060.tranClass =  row.tranClass;
				},
				onCancel : function () {
					onLOV = false;
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtTranClass");
					onLOV = false;
				}
			});
		}
		
		$$("input[type='text']").each(function(obj){
			if(obj.id == "txtCompany") {
				obj.observe("keypress", function(event){
					if(event.keyCode == 8 || event.keyCode == 46 || event.keyCode == 0){
						objGIACS060.fundCd = "";
						checkCompany = "";
					}else if ((event.keyCode == 13 || event.keyCode == 9) && obj.value.trim() != "") { //benjo 08.03.2015 UCPBGEN-SR-19710
						getCompanyLOV();
					}
				});
			} else if(obj.id == "txtBranch") {
				obj.observe("keypress", function(event){
					if(event.keyCode == 8 || event.keyCode == 46 || event.keyCode == 0){
						objGIACS060.branchCd = "";
						checkBranch = "";
					} else if ((event.keyCode == 13 || event.keyCode == 9) && obj.value.trim() != "") { //benjo 08.03.2015 UCPBGEN-SR-19710
						getBranchPerFundLOV();
					}
				});
			} else if(obj.id == "txtTranClass") {
				obj.observe("keypress", function(event){
					if(event.keyCode == 8 || event.keyCode == 46 || event.keyCode == 0){
						objGIACS060.tranClass = "";
						checkTranClass = "";
					} else if ((event.keyCode == 13 || event.keyCode == 9) && obj.value.trim() != "") { //benjo 08.03.2015 UCPBGEN-SR-19710
						getGIACS060TranClassLOV();
					}
				});
			}
			
			if(obj.id.indexOf("txtSub") != -1 || obj.id == "txtCategory" || obj.id == "txtControl"){
				obj.observe("keypress", function(event){
					if(event.keyCode == 8 || event.keyCode == 46 || event.keyCode == 0){
						checkGLAcctCode = "";
						$("txtGLAcctName").clear();
						
						if(obj.id == "txtCategory") {
							$("txtControl").clear();
							$("txtSub1").clear();
							$("txtSub2").clear();
							$("txtSub3").clear();
							$("txtSub4").clear();
							$("txtSub5").clear();
							$("txtSub6").clear();
							$("txtSub7").clear();
						} else if (obj.id == "txtControl") {
							$("txtSub1").clear();
							$("txtSub2").clear();
							$("txtSub3").clear();
							$("txtSub4").clear();
							$("txtSub5").clear();
							$("txtSub6").clear();
							$("txtSub7").clear();
						} else if (obj.id == "txtSub1") {
							$("txtSub2").clear();
							$("txtSub3").clear();
							$("txtSub4").clear();
							$("txtSub5").clear();
							$("txtSub6").clear();
							$("txtSub7").clear();
						} else if (obj.id == "txtSub2") {
							$("txtSub3").clear();
							$("txtSub4").clear();
							$("txtSub5").clear();
							$("txtSub6").clear();
							$("txtSub7").clear();
						} else if (obj.id == "txtSub3") {
							$("txtSub4").clear();
							$("txtSub5").clear();
							$("txtSub6").clear();
							$("txtSub7").clear();
						} else if (obj.id == "txtSub4") {
							$("txtSub5").clear();
							$("txtSub6").clear();
							$("txtSub7").clear();
						} else if (obj.id == "txtSub5") {
							$("txtSub6").clear();
							$("txtSub7").clear();
						} else if (obj.id == "txtSub6") {
							$("txtSub7").clear();
						} else if (obj.id == "txtSub7") { //added by jhing 01.26.2016 from Temp Solution done by vondanix RSIC 20691 10.26.2015
							$("txtSub7").clear();
						} 
					} else if ((event.keyCode == 13) || (event.keyCode == 9 && $("txtCategory").value.trim() != ""
				    	&& $("txtControl").value.trim() != "" && $("txtSub1").value.trim() != "" && $("txtSub2").value.trim() != ""
					    && $("txtSub3").value.trim() != "" && $("txtSub4").value.trim() != "" && $("txtSub5").value.trim() != ""
					    && $("txtSub6").value.trim() != "" && $("txtSub7").value.trim() != "")) { //benjo 08.03.2015 UCPBGEN-SR-19710
						getGIACS060GLAcctCdLOV();
					}
					checkBeginBalanceConditions(); //added by jhing 01.26.2016 from Temp Solution done by vondanix RSIC 20691 10.26.2015
				});
			}
		});
			
		$("imgCompany").observe("click", getCompanyLOV);
		$("imgBranch").observe("click", getBranchPerFundLOV);
		$("imgGLCode").observe("click", getGIACS060GLAcctCdLOV);
		$("imgTranClass").observe("click", getGIACS060TranClassLOV);
		
		//added by added by jhing 01.26.2016 from Temp Solution done by vondanix RSIC 20691 10.22.2015 
		function checkBeginBalanceConditions() {
			if ($("rdoDetailed1").checked == true 
			   && $("rdoDatePosted").checked == true
			   && $("chkSLTag").checked == false
			){
				$("chkIncludeBeginBalance").checked = false;
				$("chkIncludeBeginBalance").enable();
			}else{
				$("chkIncludeBeginBalance").checked = false;
				$("chkIncludeBeginBalance").disable();
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
				$("rdoCsv").disable();
			} else {
				if(dest == "file"){
					$("rdoPdf").enable();
					$("rdoExcel").enable();
					$("rdoCsv").enable();
				} else {
					$("rdoPdf").disable();
					$("rdoExcel").disable();
					$("rdoCsv").disable();
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
		
		$("imgFromDate").observe("click", function(){
			scwShow($("txtFromDate"), this, null);
		});
		
		$("imgToDate").observe("click", function(){
			scwShow($("txtToDate"), this, null);
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
		
		function getParams() {
			var params = "";
			var reportId = "";
			var tranPost = $("rdoTransactionDate").checked ? "T" : "P";
			var tranFlag = $("chkOpenTransTag").checked ? "O" : "D";
			var branchAll = $("chkConsolidateAllBranches").checked ? "Y" : "N";
			var slCd = $("txtSLCd").value;
			var includeSubAccts = $("chkIncludeSubAccts").checked ? "Y" : "N";
			var includeBegBal = $("chkIncludeBeginBalance").checked ? "Y" : "N"; //added by jhing 01.26.2016 from Temp Solution done by vondanix RSIC 20691 10.22.2015

			if($("rdoSummary").checked){
				if($("chkSLTag").checked)
					reportId = "GIACR061";
				else
					reportId = "GIACR060";
			} else if ($("rdoDetailed1").checked){
				if($("chkSLTag").checked)
					reportId = "GIACR202";
				else
					reportId = "GIACR201";
			} else {
				if($("chkSLTag").checked)
					reportId = null;
				else
					reportId = "GIACR062";
			}

			params = "&reportId=" + reportId
						+ "&moduleId=GIACS060"
						+ "&tranPost=" + tranPost
						+ "&fromDate=" + $("txtFromDate").value
						+ "&toDate=" + $("txtToDate").value
						+ "&tranFlag=" + tranFlag
						+ "&fundCd=" + objGIACS060.fundCd
						+ "&branchCd=" + objGIACS060.branchCd
						+ "&category=" + $("txtCategory").value
						+ "&control=" + $("txtControl").value
						+ "&tranClass=" + objGIACS060.tranClass
						+ "&sub1=" + $("txtSub1").value
						+ "&sub2=" + $("txtSub2").value
						+ "&sub3=" + $("txtSub3").value
						+ "&sub4=" + $("txtSub4").value
						+ "&sub5=" + $("txtSub5").value
						+ "&sub6=" + $("txtSub6").value
						+ "&sub7=" + $("txtSub7").value
						+ "&branchAll=" + branchAll
						+ "&slCd=" + slCd
						+ "&noOfCopies=" + $F("txtNoOfCopies")
		                + "&printerName=" + $F("selPrinter")
		                + "&destination=" + $F("selDestination")
		                + "&company=" + $("txtCompany").value //added by clperello | 06.05.2014
		                + "&includeSubAccts=" + includeSubAccts //added by john 10.16.2014
		                + "&includeBegBal=" + includeBegBal; //added by jhing 01.26.2016 from Temp Solution done by vondanix RSIC 20691 10.22.2015

			return params;
		}
		
		function printReport(){
			try {
				var content = contextPath + "/GeneralLedgerPrintController?action=printReport"
						                  + getParams();
				
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
					//added by clperello | 06.04.2014
					var fileType = "PDF";
				
					if($("rdoPdf").checked)
						fileType = "PDF";
					else if ($("rdoExcel").checked)
						fileType = "XLS";
					else if ($("rdoCsv").checked)
						fileType = "CSV";
					//end here clperello | 06.04.2014
					
					new Ajax.Request(content, {
						parameters : {destination : "file",
									  fileType : fileType}, //$("rdoPdf").checked ? "PDF" : "XLS"}, commented out by clperello | 06.04.2014
					  	evalScripts: true, //added by clperello | 06.04.2014
						asynchronous: true, //added by clperello | 06.04.2014
						onCreate: showNotice("Generating report, please wait..."),
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								if ($("rdoCsv").checked){ //added by clperello | 06.04.2014
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
				showErrorMessage("printReport", e);
			}
		}
		
		function checkGIACS060GLTrans() {
			var ajaxResponse = "";
			
			new Ajax.Request(contextPath + "/GIACAcctEntriesController?action=checkGIACS060GLTrans" + getParams(),{
				method: "POST",
				/* parameters: {
						     action : "checkGIACS060GLTrans"
				}, */
				asynchronous: false,
				onComplete : function(response){
					if(checkErrorOnResponse(response)){
						ajaxResponse = trim(response.responseText);
					}
				}
			});
			return ajaxResponse;
		}
		
		$("btnPrint").observe("click", function(){
			if($("txtCompany").value == ""){
				customShowMessageBox("Please enter a value for Company Code.", "I", "txtCompany");
			} else if ($("txtBranch").value == ""){
				customShowMessageBox("Please enter a value for Branch Code.", "I", "txtBranch");
			} else if ($("txtFromDate").value == ""){
				customShowMessageBox("Please enter a value for From Date.", "I", "txtFromDate");
			} else if ($("txtToDate").value == ""){
				customShowMessageBox("Please enter a value for To Date.", "I", "txtToDate");
			}
			
			if(checkGIACS060GLTrans() != "Y"){
				if($("chkSLTag").checked){
					showMessageBox("There is no transaction with this GL Account Code, SL Code and Period Covered.", "I");
				} else {
					showMessageBox("There is no transaction with this GL Account Code and Period Covered.", "I");
				}
			} else
				printReport();
		});
		
		$("rdoSummary").observe("click", function(){
			if(this.checked) {
				$("chkSLTag").enable();
			}
		});
		
		$("rdoDetailed1").observe("click", function(){
			if(this.checked) {
				$("chkSLTag").enable();
			}
		});
		
		$("rdoDetailed2").observe("click", function(){
			if(this.checked) {
				$("chkSLTag").checked = false;
				$("chkSLTag").disable();
				$("txtSLCd").clear();
				$("txtSLCd").disable();
			}
		});
		
		//added by jhing 01.26.2016 from Temp Solution done by vondanix RSIC 20691 10.22.2015
		$$("input[type='radio']").each(function(obj){
			if(obj.name == "radioGroup1" || obj.name == "radioGroup2") {
				obj.observe("change", function(event){
					checkBeginBalanceConditions(); 
				});
			   }
		});

		
		$("chkSLTag").observe("click", function(){
			if(this.checked){
				$("txtSLCd").enable();
				checkBeginBalanceConditions();  //added by jhing 01.26.2016 from Temp Solution done by vondanix RSIC 20691 10.22.2015
			} else {
				$("txtSLCd").disable();
				$("txtSLCd").clear();
				checkBeginBalanceConditions();  //added by jhing 01.26.2016 from Temp Solution done by vondanix RSIC 20691 10.22.2015
			}
		});
		
		initializeAll();
		
		//marco - 10.10.2014
		function showSLCodeLOV(){
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action: "getSLCodeLOV",
					glAcctId: checkGLAcctCode,
					filterText: $F("txtSLCd") != $("txtSLCd").getAttribute("lastValidValue") ? nvl($F("txtSLCd"), "%") : "%"
				},
				title : "List of SL Codes",
				width : 510,
				height : 386,
				columnModel : [ 
					{	id : "slCd",
						title : "SL Code",
						width : '75px',
						align: 'right',
						titleAlign: 'right'
					},
					{	id : "slName",
						title : "SL Name",
						width : '337px'
					},
					{	id : "slTypeCd",
						title : "Type/Class",
						width : '80px'
					}
				],
				draggable : true,
				filterText: $F("txtSLCd") != $("txtSLCd").getAttribute("lastValidValue") ? nvl($F("txtSLCd"), "%") : "%",
				onSelect : function(row) {
					$("txtSLCd").value = row.slCd;
					$("txtSLCd").setAttribute("lastValidValue", $F("txtSLCd"));
				},
				onCancel : function () {
					$("txtSLCd").value = $("txtSLCd").getAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtSLCd").value = $("txtSLCd").getAttribute("lastValidValue");
				},
				onShow: function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			});
		}
		
		$("txtSLCd").observe("change", function(){
			if($F("txtSLCd") == ""){
				$("txtSLCd").setAttribute("lastValidValue", "");
			}else{
				showSLCodeLOV();
			}
		});
		
		$("imgSLCd").observe("click", function(){
			if($("chkSLTag").checked){
				showSLCodeLOV();
			}
		});
		//end - 10.10.2014
	} catch (e) {
		showErrorMessage("Print GL Transactions", e);
	}
</script>