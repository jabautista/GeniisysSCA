<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div style="margin-bottom: 50px;">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv">
		<div id="innerDiv">
			<label>Update Booking Month / Cred Branch / Regular Policy Tag</label>
			<span class="refreshers" style="margin-top: 0;">
	 			<label id="btnReloadForm" name="gro" style="margin-left: 5px;">Reload Form</label>
			</span>
		</div>
	</div>
	<div class="sectionDiv" id="policyDetailsDiv">
		<table align="center" border="0" style="margin: 20px auto;">
			<tr>
				<td style="padding-right: 5px;"><label for="txtLineCd" style="float: right;">Policy No.</label></td>
				<td>
					<input type="text" id="txtLineCd" class="allCaps required" style="width: 40px; margin: 0px; height: 14px;" />
				</td>
				<td>
					<input type="text" id="txtSublineCd" class="allCaps" style="width: 70px; margin: 0px; height: 14px;" />
				</td>
				<td>
					<input type="text" id="txtIssCd" class="allCaps" style="width: 40px; margin: 0px; height: 14px;" />
				</td>
				<td>
					<input type="text" id="txtIssueYy" class="integerNoNegativeUnformattedNoComma rightAligned" maxlength="2" style="width: 40px; margin: 0px; height: 14px; text-align: right;" />
				</td>
				<td>
					<input type="text" id="txtPolSeqNo" class="integerNoNegativeUnformattedNoComma rightAligned" maxlength="7" style="width: 70px; margin: 0px; height: 14px; text-align: right;" />
				</td>
				<td>
					<input type="text" id="txtRenewNo" class="integerNoNegativeUnformattedNoComma rightAligned" maxlength="2" style="width: 40px; margin: 0px; height: 14px; text-align: right;" />
				</td>
				<td>
					<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgPolNo" alt="Go" style="float: right;" />
				</td>
				<td style="padding-right: 5px;"><label for="txtEndtIssCd" style="margin-left: 20px; float: right;">Endorsement No.</label></td>
				<td>
					<input type="text" id="txtEndtIssCd" class="allCaps" style="width: 40px; margin: 0px; height: 14px;" />
				</td>
				<td>
					<input type="text" id="txtEndtYy" class="integerNoNegativeUnformattedNoComma rightAligned" style="width: 40px; margin: 0px; height: 14px;" />
				</td>
				<td>
					<input type="text" id="txtEndtSeqNo" class="integerNoNegativeUnformattedNoComma rightAligned" style="width: 70px; margin: 0px; height: 14px;" />
				</td>
			</tr>
			<tr>
				<td style="padding-right: 5px;"><label for="txtAssured" style="float: right;">Assured</label></td>
				<td colspan="11">
					<input type="text" id="txtAssured" class="" style="margin: 0; width: 695px; height: 14px;" />
				</td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv" style="clear: both;">
		<div style="text-align: center; ">
			<div style="margin: 10px auto;">
				<input type="button" id="btnBankPayment" class="button" value="Bank Payment Details" style="width: 160px;" />
				<input type="button" id="btnBancassurance" class="button" value="Bancassurance Details" style="width: 160px;" />
				<input type="button" id="btnHistory" class="button" value="History" style="width: 160px;" />
			</div>
			<div style="text-align: center;">				
				<fieldset style="width: 681px; height: 135px; margin: 0 auto;">
					<legend style="margin-left: 20px;"><b>Basic Info</b></legend>
					<table align="center" border="0">
						<tr>
							<td></td>
							<td>
								<input type="checkbox" id="chkRegPolicySw" style="float: left;" />
								<label for="chkRegPolicySw" style="float: left; margin-left: 5px;">Regular Policy</label>
							</td>
							<td style="padding-right: 5px;"><label for="txtEffDate" style="float: right;">Effectivity</label></td>
							<td width="100px;"><input type="text" id="txtEffDate" style="width: 115px; float: right; height: 14px; margin: 0;" readonly="readonly"/></td>
						</tr>
						<tr>
							<td style="padding-right: 5px;"><label for="txtIssueDate" style="float: right;">Issue Date</label></td>
							<td><input type="text" id="txtIssueDate" style="width: 115px; float: left; height: 14px; margin: 0;" readonly="readonly"/></td>
							<td style="padding-right: 5px;"><label for="txtAcctEntDate" style="float: right;">Acct. Date</label></td>
							<td><input type="text" id="txtAcctEntDate" style="width: 115px; float: right; height: 14px; margin: 0;" readonly="readonly"/></td>
						</tr>
						<tr>
							<td style="padding-right: 5px;"><label for="txtCredBranch" style="float: right;">Crediting Branch</label></td>
							<td colspan="3">
								<span class="lovSpan required" style="width: 350px; margin-bottom: 0;">
									<input type="text" id="txtCredBranch" ignoreDelKey="true" style="width: 325px; float: left;" class="withIcon allCaps required"   tabindex="201" />  
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgCreditingBranch" alt="Go" style="float: right;" />
								</span>
							</td>
						</tr>
						<tr>
							<td style="padding-right: 5px;"><label for="txtBookingYrMnth" style="float: right;">Booking Yr. /Mo.</label></td>	
							<td colspan="3"> 
								<span class="lovSpan" style="width: 350px; margin-bottom: 0;"> <!-- apollo 08.06.2015 sr#19928 --> 
									<input type="text" id="txtBookingYrMnth" ignoreDelKey="true" style="width: 325px; float: left;" class="withIcon allCaps"  tabindex="201" />  
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgBookingYrMnth" alt="Go" style="float: right;" />
								</span>
							</td>
						</tr>
					</table>
				</fieldset>
			</div>
			<div style="clear: both; margin: 10px auto; width: 700px;">
				<div id="tableGridDiv" style="height: 245px;"></div>
			</div>
			<div>
				<table align="center">
					<tr>
						<td style="padding-right: 5px;"><label for="txtTakeupSeqNo" style="float: right;">Takeup No.</label></td>
						<td>
							<input type="text" id="txtTakeupSeqNo" style="width: 115px; float: left; text-align: right;" readonly="readonly" tabindex="301"/>
						</td>
						<td style="padding-right: 5px;"><label for="txtAcctEntDate2" style="float: right;">Acct. Date</label></td>
						<td width="100px">
							<input type="text" id="txtAcctEntDate2" style="width: 115px;" readonly="readonly" tabindex="302"/>
						</td>
					</tr>
					<tr>
						<td style="padding-right: 5px;"><label for="txtBookingYrMnth2" style="float: right;">Booking Yr. /Mo.</label></td>	
						<td colspan="3"> 
							<span class="lovSpan required" style="width: 350px; margin-bottom: 0;"> 
								<input type="text" id="txtBookingYrMnth2" ignoreDelKey="true" style="width: 325px; float: left;" class="withIcon allCaps required"  tabindex="303" readonly="readonly" />  
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgBookingYrMnth2" alt="Go" style="float: right;" />
							</span>
						</td>
					</tr>
					<tr>
						<td colspan="4">
							<input type="button" class="button" id="btnUpdate" value="Update" style="width: 100px; margin: 10px auto;" />
						</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
	<div style="clear: both; text-align: center; padding-top: 10px;">
		<input type="button" class="button" id="btnCancel" value="Cancel" style="width: 100px;" />
		<input type="button" class="button" id="btnSave" value="Save" style="width: 100px;" />
	</div>
</div>
<script type="text/javascript"">
	try {
		
		setModuleId("GIPIS156");
		setDocumentTitle("Update Booking Month / Cred Branch / Regular Policy Tag");
		objGIPIS156Invoice = new Object();
		objGIPIS156InvoiceRow = new Object();
		
		var onLOV = false;
		var endtYy;
		var endtSeqNo;
		var onFocus;
		
		function initGIPIS156(){
			onFocus = false;
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
			onLOV = false;
			endtYy = null;
			endtSeqNo = null;
			objGIPIS156 = new Object();
			disableButton("btnBankPayment");
			disableButton("btnBancassurance");
			disableButton("btnHistory");
			disableButton("btnSave");
			disableButton("btnUpdate");
			disableSearch("imgCreditingBranch");
			disableSearch("imgBookingYrMnth");
			disableSearch("imgBookingYrMnth2");
			$("chkRegPolicySw").disable();
			$("txtCredBranch").readOnly = true;
			$("txtBookingYrMnth").readOnly = true;
			
			$("txtLineCd").focus();
			objGIPIS156Invoice = new Object();
			objGIPIS156InvoiceRow = new Object();
			
			changeTag = 0;
			changeTagFunc = "";
		}
		
		function resetForm(){
			
			$$("input[type='text']").each(
				function(obj){
					obj.clear();
				}
			);
			
			$$("#policyDetailsDiv input[type='text']").each(
				function(obj){
					obj.readOnly = false;
				}		
			);
			
			onFocus = false;
			enableSearch("imgPolNo");
			$("chkRegPolicySw").checked = false;
			invoiceTableGrid.url = contextPath+ "/UpdateUtilitiesController?action=showUpdatePolicyBookingDateEtc&refresh=1";
			invoiceTableGrid._refreshList();
			initGIPIS156();
			
			changeTag = 0;
			changeTagFunc = "";
		}
		
		var jsonGIPIS156Invoice = JSON.parse('${jsonGIPIS156Invoice}');
		tableModel = {
				url: contextPath+ "/UpdateUtilitiesController?action=showUpdatePolicyBookingDateEtc&refresh=1",
				id: 'tbgInvoice',		
				options: {
					/* toolbar: {
						elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
					}, */
					width: '700px',
					height: '220px',
					hideColumnChildTitle : true,
					onCellFocus : function(element, value, x, y, id) {
						invoiceClick(invoiceTableGrid.geniisysRows[y]);					
						invoiceTableGrid.keys.removeFocus(invoiceTableGrid.keys._nCurrentFocus, true);
						invoiceTableGrid.keys.releaseKeys();
						objGIPIS156.invoiceSelectedIndex = y;
					},
					onRemoveRowFocus : function(element, value, x, y, id){					
						invoiceClick(null);
						invoiceTableGrid.keys.removeFocus(invoiceTableGrid.keys._nCurrentFocus, true);
						invoiceTableGrid.keys.releaseKeys();
						objGIPIS156.invoiceSelectedIndex = -1;
					},
				},									
				columnModel: [
					{
					    id: 'recordStatus',
					    title: '',
					    width: '0',
					    visible: false
					},
					{
						id: 'divCtrId',
						width: '0',
						visible: false 
					},
					{
						id: 'takeupSeqNo',
						title: 'Takeup No.',
						width: '150px',
						align: 'right',
						titleAlign: 'right'
					},
					{
						id: 'multiBookingYy multiBookingMm',
						title: 'Booking Yr. / Mo',
						//width: '210px',
						children: [
							{
								id: 'multiBookingYy',
								title: 'Booking Year',
								width: 150
							},
							{
								id: 'multiBookingMm',
								title: 'Booking Month',
								width: 150
							}
						]
					},
					{
						id: 'acctEntDate',
						title: 'Acct. Date',
						width: '150px',
						align: 'center',
						titleAlign: 'center',
						renderer: function(val){
							if(val != null && val != "")
								return dateFormat(val, "mm-dd-yyyy");
							else
								return "";
						}
					},
					{
						id: "itemGrp",
						title : "Item Group",
						width: 84,
						align : "right",
						titleAlign : "right"
					}
				],
				rows: jsonGIPIS156Invoice.rows
			};
		
		invoiceTableGrid = new MyTableGrid(tableModel);
		invoiceTableGrid.pager = jsonGIPIS156Invoice;
		invoiceTableGrid.render('tableGridDiv');
		invoiceTableGrid.afterRender = function(){
			objGIPIS156Invoice = invoiceTableGrid.geniisysRows;
			invoiceClick(null);			
		};
		
		function invoiceClick(row){
			if(row != null){
				onFocus = true;
				objGIPIS156InvoiceRow = row;
				objGIPIS156.premSeqNo = row.premSeqNo;
				objGIPIS156.takeupSeqNo = row.takeupSeqNo;
				enableButton("btnHistory");
				//enableButton("btnUpdate"); //apollo 08.06.2015 SR#19928 - update button will be disable for single takeup
				
				$("txtTakeupSeqNo").value = row.takeupSeqNo == null ? "" : formatNumberDigits(row.takeupSeqNo, 3);
				$("txtAcctEntDate2").value = row.acctEntDate != null ? dateFormat(row.acctEntDate, "mm-dd-yyyy") : "";
				$("txtBookingYrMnth2").value = (row.multiBookingYy == null || row.multiBookingMm == null) ? "" : row.multiBookingYy + " - " + row.multiBookingMm;
				
				objGIPIS156.multiBookingYy = row.multiBookingYy;
				objGIPIS156.multiBookingMm = row.multiBookingMm;
				
				if(objGIPIS156.takeupTerm == "" || objGIPIS156.takeupTerm == null || objGIPIS156.takeupTerm != 'ST'){
					enableButton("btnUpdate");
					
					if($("txtAcctEntDate2").value != "")
						disableSearch("imgBookingYrMnth2");
					else 
						enableSearch("imgBookingYrMnth2");
					
				} else {
					disableSearch("imgBookingYrMnth2");
					disableButton("btnUpdate");
				}
				
				if(objGIPIS156.updateBookingSw == 'N')
					disableSearch("imgBookingYrMnth2");
				
			} else {
				objGIPIS156InvoiceRow = null;
				onFocus = false;
				objGIPIS156.premSeqNo = null;
				//objGIPIS156.takeupSeqNo = null;
				disableButton("btnHistory");
				disableButton("btnUpdate");
				
				$("txtTakeupSeqNo").clear();
				$("txtAcctEntDate2").clear();
				$("txtBookingYrMnth2").clear();
				
				disableSearch("imgBookingYrMnth2");
			}
		}
		
		function getGIPIS156PolNoLOV(){
			onLOV = true;
			LOV.show({
				id : "gipis156PolNoLOV",
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGIPIS156PolNoLOV",
					lineCd : $F('txtLineCd'),
					sublineCd : $F('txtSublineCd'),
					issCd : $F('txtIssCd'),
					issueYy : $F('txtIssueYy'),
					polSeqNo : $F('txtPolSeqNo'),
					renewNo : $F('txtRenewNo'),
					assdName : $F('txtAssured'),
					dspEndtIssCd : $F('txtEndtIssCd'),
					dspEndtSeqNo : $F('txtEndtSeqNo'),
					dspEndtYy : $F('txtEndtYy'),
					moduleId : 'GIPIS156',
					page : 1
				},
				hideColumnChildTitle : true,
				filterVersion: "2",
				title : "",
				width : 700,
				height : 403,
				columnModel : [
               		{
						id : "policyNo",
						title : "Policy No.",
						width: 303,
						children : [
							{
								id: 'lineCd',
								title: 'Line Cd',
								width: 40
							},
							{
								id: 'sublineCd',
								title: 'Subline Cd',
								width: 70,
								filterOption: true
							},
							{
								id: 'issCd',
								title: 'Iss Cd',
								width: 40,
								filterOption: true
							},
							{
								id: 'issueYy',
								title: 'Issue Yy',
								width: 40,
								filterOption: true,
								filterOptionType: 'number',
								align: 'right',		// shan 09.02.2014
								renderer: function(value){
									return lpad(value, 2, '0');
								}
							},
							{
								id: 'polSeqNo',
								title: 'Pol Seq No',
								width: 70,
								filterOption: true,
								filterOptionType: 'number',
								align: 'right',		// shan 09.02.2014
								renderer: function(value){
									return lpad(value, 7, '0');
								}
							},
							{
								id: 'renewNo',
								title: 'Renew No',
								width: 40,
								filterOption: true,
								filterOptionType: 'number',
								align: 'right',		// shan 09.02.2014
								renderer: function(value){
									return lpad(value, 2, '0');
								}
							}
						]
					},
					{
						id : 'endorsementNo',
						title : 'Endt No.',
						children : [
							{
								id: 'dspEndtIssCd',
								title : 'Endt Iss Cd',
								width: 40,
								filterOption: true
							},
							{
								id: 'dspEndtYy',
								title : 'Endt Yy',
								width: 40,
								filterOption: true,
								filterOptionType: 'number',
								align: 'right',		// shan 09.02.2014
								renderer: function(value){
									return value == "" ? "" : lpad(value, 2, '0');
								}
							},
							{
								id: 'dspEndtSeqNo',
								title : 'Endt Seq No',
								width: 70,
								filterOption: true,
								filterOptionType: 'number',
								align: 'right',		// shan 09.02.2014
								renderer: function(value){
									return value == "" ? "" : lpad(value, 6, '0');
								}
							}
						]
					},
					{
						id : 'assdName',
						title : 'Assured Name',
						width : 500,
						filterOption : true,
						renderer : function(val){
							return unescapeHTML2(val);
						}
					}
          		],
				draggable : true,
				autoSelectOneRecord: true,
				onSelect : function(row) {
					onLOV = false;
					populatePolicyInformation(row);
					enableButton("btnSave");
				},
				onCancel : function () {
					onLOV = false;
					$("txtLineCd").focus();
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtLineCd");
					$("txtLineCd").focus();
					onLOV = false;
				}
			});
		}
		
		function populatePolicyInformation(row){
			$("txtLineCd").value = row.lineCd;
			$("txtSublineCd").value = row.sublineCd;
			$("txtIssCd").value = row.issCd;
			$("txtIssueYy").value = lpad(row.issueYy, 2, '0');
			$("txtPolSeqNo").value = lpad(row.polSeqNo, 7, '0');
			$("txtRenewNo").value = lpad(row.renewNo, 2, '0');
			$("txtEndtIssCd").value = row.dspEndtIssCd;
			$("txtEndtYy").value = row.dspEndtYy == "" ? "" : lpad(row.dspEndtYy, 2, '0');
			$("txtEndtSeqNo").value = row.dspEndtSeqNo == "" ? "" : lpad(row.dspEndtSeqNo, 6, '0');
			$("txtAssured").value = unescapeHTML2(row.assdName);
			endtYy = row.endtYy;
			endtSeqNo = row.endtSeqNo;
			objGIPIS156.credBranch = row.credBranch;
			objGIPIS156.issueDate = row.issueDate;
			objGIPIS156.inceptDate = row.inceptDate;
			objGIPIS156.allowBookingInAdvTag = row.allowBookingInAdvTag;
			objGIPIS156.policyId = row.policyId;
			objGIPIS156.assdName2 = row.assdName2;
			objGIPIS156.policyEndtNo = row.policyEndtNo;
			objGIPIS156.endtType = row.endtType;
			objGIPIS156.ora2010Sw = row.ora2010Sw;
			objGIPIS156.bancassuranceSw = row.bancassuranceSw;
			enableToolbarButton("btnToolbarExecuteQuery");
		}
		
		function setDetails(status){
			if(status == "query"){
				$("txtLineCd").readOnly = true;
				$("txtSublineCd").readOnly = true;
				$("txtIssCd").readOnly = true;
				$("txtIssueYy").readOnly = true;
				$("txtPolSeqNo").readOnly = true;
				$("txtRenewNo").readOnly = true;
				$("txtEndtIssCd").readOnly = true;
				$("txtEndtYy").readOnly = true;
				$("txtEndtSeqNo").readOnly = true;
				$("txtAssured").readOnly = true;
				
				invoiceTableGrid.url = contextPath+ "/UpdateUtilitiesController?action=showUpdatePolicyBookingDateEtc&refresh=1&policyId=" + objGIPIS156.policyId;
				invoiceTableGrid._refreshList();
				
				disableToolbarButton("btnToolbarExecuteQuery");
				disableSearch("imgPolNo");
				
				invoiceTableGrid.selectRow(0);
				invoiceClick(invoiceTableGrid.geniisysRows[0]);
				objGIPIS156.invoiceSelectedIndex = 0; //added by robert 02.05.2015
			}
		}
		
		function populateBasicInfo(json){
			$("chkRegPolicySw").checked = json.REG_POLICY_SW == 'Y' ? true : false;
			$("txtEffDate").value = json.EFF_DATE != null ? dateFormat(json.EFF_DATE, "mm-dd-yyyy") : "";
			$("txtIssueDate").value = json.ISSUE_DATE != null ? dateFormat(json.ISSUE_DATE, "mm-dd-yyyy") : "";
			$("txtAcctEntDate").value = json.ACCT_ENT_DATE != null ? dateFormat(json.ACCT_ENT_DATE, "mm-dd-yyyy") : "";
			$("txtCredBranch").value = json.CRED_BRANCH;
			$("txtBookingYrMnth").value = json.BOOKING_MTH_YR;
			objGIPIS156.bookingYear = json.BOOKING_YEAR;
			objGIPIS156.bookingMth = json.BOOKING_MTH;
			objGIPIS156.credBranch = json.CRED_BRANCH_CD;
			objGIPIS156.takeupTerm = nvl(json.TAKEUP_TERM, "ST"); //apollo cruz 08.06.2015 - SR# 19928 - as per ma'am jhing, treat blank as single takeup
			objGIPIS156.updateBookingSw = json.UPDATE_BOOKING_SW;
			objGIPIS156.expiryDate = json.EXPIRY_DATE != null ? dateFormat(json.EXPIRY_DATE, "mm-dd-yyyy") : ""; //benjo 10.07.2015 GENQA-SR-4890
			
			enableButton("btnBankPayment");
			
			objGIPIS156.nbtAcctIssCd = json.NBT_ACCT_ISS_CD;
			objGIPIS156.nbtBranchCd = json.NBT_BRANCH_CD;
			objGIPIS156.dspRefNo = json.DSP_REF_NO;
			objGIPIS156.dspModNo = json.DSP_MOD_NO;
						
			if(objGIPIS156.ora2010Sw == "Y" && objGIPIS156.bancassuranceSw == "Y"){
				objGIPIS156.areaCd = json.AREA_CD;
				objGIPIS156.areaDesc = json.DSP_AREA_DESC;
				objGIPIS156.branchCd = json.BRANCH_CD;
				objGIPIS156.branchDesc = json.DSP_BRANCH_DESC;
				objGIPIS156.managerCd = json.MANAGER_CD;
				objGIPIS156.managerName = json.DSP_MANAGER_NAME;
				
				enableButton("btnBancassurance");
			} else {
				disableButton("btnBancassurance");
			}
			
			// apollo cruz 08.06.2015 - SR#19928 - if the policy is already taken up, all fields must be uneditable
			if($("txtAcctEntDate").value != ""){
				$("chkRegPolicySw").disable();
				disableSearch("imgCreditingBranch");
				disableSearch("imgBookingYrMnth");
				disableButton("btnUpdate");
			} else {
				$("chkRegPolicySw").enable();
				enableSearch("imgCreditingBranch");
				enableSearch("imgBookingYrMnth");
				enableButton("btnUpdate");
			}
			
			if(objGIPIS156.takeupTerm == "" 
					|| objGIPIS156.takeupTerm == null 
					|| objGIPIS156.takeupTerm != 'ST' 
					|| objGIPIS156.updateBookingSw == 'N')
				disableSearch("imgBookingYrMnth");
			
			objGIPIS156.varVDate = json.VAR_VDATE;
			
			if (objGIPIS156.varVDate == "1")
				objGIPIS156.varIDate =  $F("txtIssueDate"); //:b350.issue_date;
			else if (objGIPIS156.varVDate == "2")
				objGIPIS156.varIDate  = objGIPIS156.inceptDate; //:b250.incept_date;
			else if (objGIPIS156.varVDate == "3"){
				
				var issueDate = $F("txtIssueDate") != "" ? $F("txtIssueDate") :"";
				var inceptDate = objGIPIS156.inceptDate != "" ? objGIPIS156.inceptDate :"";
				
				if (issueDate > inceptDate) {
					objGIPIS156.varIDate = issueDate;
					objGIPIS156.varNDate = 'issue';
				} else {    
					objGIPIS156.varIDate = inceptDate;
					objGIPIS156.varNDate = 'effectivity';
				}       
			}
			
		}
		
		function executeQuery(){
			
			new Ajax.Request(contextPath+"/GIPIPolbasicController",{
				method: "POST",
				parameters: {
						     action: "getGIPIS156BasicInfo",
						     lineCd: $F("txtLineCd"),
							 sublineCd: $F("txtSublineCd"),
							 issCd: $F("txtIssCd"), 
							 issueYy: $F("txtIssueYy"),
						     polSeqNo: $F("txtPolSeqNo"),
							 renewNo:  $F("txtRenewNo"),
							 endtYy: endtYy,
							 endtSeqNo: endtSeqNo,
							 credBranch: objGIPIS156.credBranch
				},
				asynchronous: false,
				onCreate : function(){
					showNotice("Loading, please wait...");
				},
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						var json = JSON.parse(response.responseText);
						populateBasicInfo(json);
						setDetails("query");
					}
				}
			});
		}
		
		function validateDate(row){
			var month = "";
			
			switch (row.bookingMth){
			case "JANUARY":
				month = 1;
				break;
			case "FEBRUARY":
				month = 2;
				break;
			case "MARCH":
				month = 3;
				break;
			case "APRIL":
				month = 4;
				break;
			case "MAY":
				month = 5;
				break;
			case "JUNE":
				month = 6;
				break;
			case "JULY":
				month = 7;
				break;
			case "AUGUST":
				month = 8;
				break;
			case "SEPTEMBER":
				month = 9;
				break;
			case "OCTOBER":
				month = 10;
				break;
			case "NOVEMBER":
				month = 11;
				break;
			case "DECEMBER":
				month = 12;
				break;
			}
			
			var dateString = formatNumberDigits(month, 2) + "-01-" + row.bookingYear;
			var bookingDate = new Date(dateString.replace(/-/g,"/"));
			var iDate = new Date(objGIPIS156.varIDate.replace(/-/g,"/"));
			iDate = formatNumberDigits(iDate.getMonth() + 1, 2) + "-01-" + iDate.getFullYear();
			iDate = new Date(iDate.replace(/-/g,"/"));
			
			var iDateFormatted = new Date(objGIPIS156.varIDate.replace(/-/g,"/"));
			iDateFormatted = getMonthWordEquivalent(iDateFormatted.getMonth()) + " " + iDateFormatted.getDate() + ", " + iDateFormatted.getFullYear();

			if(row.bookingMth != null){
				if (bookingDate < iDate && objGIPIS156.allowBookingInAdvTag == "N"){
					
					if(objGIPIS156.varVDate == "1") {
						var msg = "You cannot book this policy to " + row.bookingMth + " " + row.bookingYear + ". ";
						msg += "The booking month is earlier than the issue date " + iDateFormatted + " of the policy.";
						customShowMessageBox(msg, "I", "txtBookingYrMnth");
					} else if(objGIPIS156.varVDate == "2") {
						var msg = "You cannot book this policy to " + row.bookingMth + " " + row.bookingYear + ". ";
						msg += "The booking month is earlier than the effectivity date " + iDateFormatted + " of the policy.";
						customShowMessageBox(msg, "I", "txtBookingYrMnth");
					} else if(objGIPIS156.varVDate == "3") {
						var msg = "You cannot book this policy to " + row.bookingMth + " " + row.bookingYear + ". ";
						msg += "The booking month is earlier than the " + objGIPIS156.varNDate + " date " + iDateFormatted + " of the policy.";
						customShowMessageBox(msg, "I", "txtBookingYrMnth");
					}
					
					$("txtBookingYrMnth").clear();
					return false;
				} else if (row.bookedTag == "Y") {
					var msg = "You cannot book this policy to " + row.bookingMth + " " + row.bookingYear + ". The booking month has already been booked.";
					customShowMessageBox(msg, "I", "txtBookingYrMnth");
					return false;
				} else if (row.bookedTag == null || row.bookedTag == ""){
					var msg = "You cannot book this policy to " + row.bookingMth + " " + row.bookingYear + ". The booking month is not existing in the maintenance for booking date.";
					customShowMessageBox(msg, "I", "txtBookingYrMnth");
					return false;
				}
			} else {
				if(parseFloat(iDate.getFullYear()) < parseFloat(row.bookingYear) && objGIPIS156.allowBookingInAdvTag == "N"){
					
					if(objGIPIS156.varVDate == "1") {
						var msg = "You cannot book this policy to " + row.bookingYear + ". The booking month is earlier than the issue date ";
						msg += iDateFormatted + " of the policy.";
						customShowMessageBox(msg, "I", "txtBookingYrMnth");
						return false;
					} else if(objGIPIS156.varVDate == "2") {
						var msg = "You cannot book this policy to " + row.bookingYear + ". The booking month is earlier than the effectivity date ";
						msg += iDateFormatted + " of the policy.";
						customShowMessageBox(msg, "I", "txtBookingYrMnth");
						return false;
					} else if(objGIPIS156.varVDate == "3") {
						var msg = "You cannot book this policy to " + row.bookingYear + ". The booking month is earlier than the " + objGIPIS156.varNDate + " date ";
						msg += iDateFormatted + " of the policy.";
						customShowMessageBox(msg, "I", "txtBookingYrMnth");
						return false;
					}
				}
			}
			
			return true;
		}
		
		function updateInvoiceRecords(rec){			
			for(var i = 0; i < invoiceTableGrid.geniisysRows.length; i++){
			    if(objGIPIS156.takeupSeqNo == invoiceTableGrid.geniisysRows[i].takeupSeqNo) {
					
					invoiceTableGrid.geniisysRows[i].recordStatus = 1;
					invoiceTableGrid.geniisysRows[i].multiBookingYy = rec.bookingYear;
					invoiceTableGrid.geniisysRows[i].multiBookingMm = rec.bookingMth;
					
					objGIPIS156Invoice.splice(i, 1, invoiceTableGrid.geniisysRows[i]);
					invoiceTableGrid.updateVisibleRowOnly(invoiceTableGrid.geniisysRows[i], i);
				}	
			}
		}
		
		function getBookingYrMnthLOV(action){
			onLOV = true;
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : action,
					inceptDate : objGIPIS156.inceptDate,
					issueDate : objGIPIS156.issueDate,
					allowBookingInAdvTag : objGIPIS156.allowBookingInAdvTag,
					//searchString : $("txtFreeText").value,
					page : 1
				},
				title : "Booking Date",
				width : 480,
				height : 386,
				columnModel : [
				    {
						id : "bookingMth",
						title : "Booking Month",
						width : '150px'
					},
					{
						id : "bookingYear",
						title : "Booking Year",
						width : '315px'
					} 
				],
				draggable : true,
				autoSelectOneRecord: true,
				//filterText:  $("txtFreeText").value,
				onSelect : function(row) {
					onLOV = false;
					
					if(validateDate(row)){ //benjo 10.07.2015 GENQA-SR-4890
						//added changeTag handling by jdiago 07.28.2014
						objGIPIS156.changeTag = true;
						changeTag = 1;
						changeTagFunc = updateGIPIS156;
						
						if(action == "getGIPIS156BookedLov"){
							$("txtBookingYrMnth").value = row.bookingYear + " - " + row.bookingMth;
							objGIPIS156.bookingMth = row.bookingMth;
							objGIPIS156.bookingYear = row.bookingYear;
							if(objGIPIS156.takeupTerm == 'ST' && $("txtAcctEntDate2").value == ""){ //added by robert 02.05.2015
								$("txtBookingYrMnth2").value = row.bookingYear + " - " + row.bookingMth;
								objGIPIS156.multiBookingYy = row.bookingYear;
								objGIPIS156.multiBookingMm = row.bookingMth;
							}
						} else if (action == "getGIPIS156BookedInvoiceLov"){
							$("txtBookingYrMnth2").value = row.bookingYear + " - " + row.bookingMth;
							objGIPIS156.multiBookingYy = row.bookingYear;
							objGIPIS156.multiBookingMm = row.bookingMth;
						}
						
						updateInvoiceRecords(row);
					}
					//validateDate(row); //benjo 10.07.2015 comment out
				},
				onCancel : function () {
					onLOV = false;
					if(action == "getGIPIS156BookedLov"){
						$("txtBookingYrMnth").focus();	
					} else if (action == "getGIPIS156BookedInvoiceLov"){
						$("txtBookingYrMnth2").focus();
					}
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, action == "getGIPIS156BookedLov" ? "txtBookingYrMnth" : "");
					onLOV = false;
				}
			});
		}
		
		function getGIPIS156IssLOV(){
			onLOV = true;
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGIPIS156IssLOV",
					lineCd : $F("txtLineCd"),
					//searchString : $F("txtCredBranch"),
					page : 1
				},
				title : "Crediting Branch",
				width : 480,
				height : 386,
				columnModel : [
				    {
						id : "issCd",
						title : "Code",
						width : '120px'
					},
					{
						id : "issName",
						title : "Issue Source",
						width : '345px'
					} 
				],
				draggable : true,
				autoSelectOneRecord: true,
				//filterText:  $F("txtCredBranch"),
				onSelect : function(row) {
					onLOV = false;
					objGIPIS156.credBranch = row.issCd;
					$("txtCredBranch").value = unescapeHTML2(row.issName);
					objGIPIS156.changeTag = true;
					changeTag = 1;
					changeTagFunc = updateGIPIS156;
				},
				onCancel : function () {
					onLOV = false;
					$("txtCredBranch").focus();
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtCredBranch");
					onLOV = false;
				}
			});
		}
		
		function showGIPIS156History() {
			try {
			overlayHistory = 
				Overlay.show(contextPath+"/UpdateUtilitiesController", {
					urlContent: true,
					urlParameters: {action : "showGIPIS156History",																
									ajax : "1",
									policyId : objGIPIS156.policyId,
									premSeqNo : objGIPIS156.premSeqNo,
									takeupSeqNo : objGIPIS156.takeupSeqNo
									
					},
				    title: "History",
				    height: 430,
				    width: 920,
				    draggable: true
				});
			} catch (e) {
				showErrorMessage("Overlay error: " , e);
			}
		}
		
		function showBancassuranceDetails(){
			try {
				overBancassuranceDetails = 
					Overlay.show(contextPath+"/UpdateUtilitiesController", {
						urlContent: true,
						urlParameters: {action : "showBancassuranceDetails",																
										ajax : "1"
										
						},
					    title: "Bancassurance Details",
					    height: 180,
					    width: 500,
					    draggable: true
					});
				} catch (e) {
					showErrorMessage("Overlay error: " , e);
				}
		}
		
		function showBankPaymentDetails(){
			try {
				overlayBankPaymentDetails = 
					Overlay.show(contextPath+"/UpdateUtilitiesController", {
						urlContent: true,
						urlParameters: {action : "showBankPaymentDetails",																
										ajax : "1"
										
						},
					    title: "Bank Payment Details",
					    height: 108,
					    width: 550,
					    draggable: true
					});
				} catch (e) {
					showErrorMessage("Overlay error: " , e);
				}
		}
		
		function updateGIPIS156(){
			
			// apollo 08.06.2015 - SR#19928 - booking date is not required.
			if($("txtCredBranch").value == "" /*|| $("txtBookingYrMnth").value == ""*/){
				showMessageBox(objCommonMessage.REQUIRED, "I");
				return;
			}
			
			if(!objGIPIS156.changeTag){
				showMessageBox(objCommonMessage.NO_CHANGES, "I");
				return;
			}
			
			// apollo 08.06.2015 - SR#19928 - to allow editing of basic info even w/o invoice
			/* if(!onFocus){
				showMessageBox("Please select a record.", "I");
				return;
			} */
			
			var objParams = new Object();
			objParams.setRows = getAddedAndModifiedJSONObjects(objGIPIS156Invoice);
			
			new Ajax.Request(contextPath+"/UpdateUtilitiesController",{
				method: "POST",
				parameters: {
						     action : "updateGIPIS156",
						     policyId : objGIPIS156.policyId,
						     credBranch : objGIPIS156.credBranch,
						     bookingMth : objGIPIS156.bookingMth,
						     bookingYear : objGIPIS156.bookingYear,
						     regPolicySw : $("chkRegPolicySw").checked ? 'Y' : 'N',
						     takeupSeqNo : objGIPIS156.takeupSeqNo,
						     areaCd : objGIPIS156.areaCd,
							 branchCd : objGIPIS156.branchCd,
							 managerCd : objGIPIS156.managerCd,
							 objInvoice : JSON.stringify(objParams)
						     
				},
				asynchronous: false,
				onCreate : function(){
					showNotice("Saving, please wait...");
				},
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						invoiceTableGrid._refreshList();
						objGIPIS156.changeTag = false;
						changeTag = 0;
						changeTagFunc = "";
						showWaitingMessageBox(objCommonMessage.SUCCESS, "S", function(){
							if(objGIPIS156.action == "exit")
								 $("btnToolbarExit").click();
							else if(objGIPIS156.action == "reset")
								resetForm();
							else if(objGIPIS156.action == "reload")
								showUpdatePolicyBookingDateEtc();
							else if(objGIPIS156.action == "update"){ //added by robert 02.05.2015
								/* invoiceTableGrid.selectRow(0);
								invoiceClick(invoiceTableGrid.geniisysRows[0]);
								objGIPIS156.invoiceSelectedIndex = 0; */
								executeQuery();
							}
						});
					}
				}
			});
		}
				
		$("imgPolNo").observe("click", function(){
			
			if($("txtLineCd").value == "")
				customShowMessageBox("Please enter Line Code first.", "I", "txtLineCd");
			else
				getGIPIS156PolNoLOV();
		});
		
		$$("#policyDetailsDiv input[type='text']").each(
			function(obj){
				obj.observe("keypress", function(event){
					if(event.keyCode == 0 || event.keyCode == 8 || event.keyCode == 46){
						if(this.readOnly)
							return;
						
						disableToolbarButton("btnToolbarExecuteQuery");
						enableToolbarButton("btnToolbarEnterQuery");
					}
				});
			}		
		);
		
		$("chkRegPolicySw").observe("click", function(){
			objGIPIS156.changeTag = true;
			changeTag = 1;
			changeTagFunc = updateGIPIS156;
		});
		
		$("txtBookingYrMnth").observe("keypress", function(event){
			
			if($("chkRegPolicySw").disabled)
				return;
			
			if(event.keyCode == 8 || event.keyCode == 46){
				this.clear();
				objGIPIS156.bookingYear = null;
				objGIPIS156.bookingMth = null;
			}
		});
		
		$("txtCredBranch").observe("keypress", function(event){
			
			if($("chkRegPolicySw").disabled)
					return;
			
			if(event.keyCode == 8 || event.keyCode == 46){
				this.clear();
				objGIPIS156.credBranch = null;
			}
		});
		
		$("btnToolbarEnterQuery").observe("click", function(){
			if(objGIPIS156.changeTag) {
				showConfirmBox4("", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
						function(){
							//yes
							updateGIPIS156();
							objGIPIS156.action = "reset";
						},
						function(){
							//no
							resetForm();
						},
						""
					);
			} else {
				resetForm();	
			}
		});
		$("btnBankPayment").observe("click", showBankPaymentDetails);
		$("btnSave").observe("click", function(){
			objGIPIS156.action = "update";
			updateGIPIS156();}
		);
		$("imgCreditingBranch").observe("click", getGIPIS156IssLOV);
		$("btnBancassurance").observe("click", showBancassuranceDetails);
		$("btnHistory").observe("click", showGIPIS156History);
		$("imgBookingYrMnth").observe("click", function(){
			getBookingYrMnthLOV("getGIPIS156BookedLov");
		});
		$("imgBookingYrMnth2").observe("click", function(){
			getBookingYrMnthLOV("getGIPIS156BookedInvoiceLov");
		});
		$("btnToolbarExecuteQuery").observe("click", executeQuery);
		$("btnReloadForm").observe("click", function(){
			if(objGIPIS156.changeTag) {
				showConfirmBox4("", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
						function(){
							//yes
							updateGIPIS156();
							objGIPIS156.action = "reset";
						},
						function(){
							//no
							//showUpdatePolicyBookingDateEtc();
							resetForm();
						},
						""
					);
			} else {
				//showUpdatePolicyBookingDateEtc();
				resetForm();
			}
		});
		$("btnToolbarPrint").hide();
		$("btnCancel").observe("click", function(){
			$("btnToolbarExit").click();
		});
		$("btnToolbarExit").observe("click", function(){
			if(objGIPIS156.changeTag) {
				showConfirmBox4("", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
						function(){
							//yes
							updateGIPIS156();
							objGIPIS156.action = "exit";
						},
						function(){
							//no
							goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
						},
						""
					);
			} else {
				delete objGIPIS156;
				goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);	
			}
		});
		
		$("txtIssueYy").observe("change", function(){
			if(this.value == "")
				return;
			
			this.value = formatNumberDigits(this.value, 2);
		});
		
		$("txtPolSeqNo").observe("change", function(){
			if(this.value == "")
				return;
			
			this.value = formatNumberDigits(this.value, 7);
		});
		
		$("txtRenewNo").observe("change", function(){
			if(this.value == "")
				return;
			
			this.value = formatNumberDigits(this.value, 2);
		});
		
		function setInvoice(){
			var i = new Object();
			i = objGIPIS156InvoiceRow;
			i.recordStatus = 1;
			i.multiBookingYy = objGIPIS156.multiBookingYy;
			i.multiBookingMm = objGIPIS156.multiBookingMm;
			return i;
		}
		
		function updateInvoice(){
			if(validateBookingDate()){ //benjo 10.07.2015 GENQA-SR-4890 added condition
				var rowObj = setInvoice();
			
				objGIPIS156Invoice.splice(objGIPIS156.invoiceSelectedIndex, 1, rowObj);
				invoiceTableGrid.updateVisibleRowOnly(rowObj, objGIPIS156.invoiceSelectedIndex);
				//invoiceTableGrid.selectRow(objGIPIS156.invoiceSelectedIndex);
			
				// for multiple takeup and bill - update records with the same takeup seq no
				for(var i = 0; i < invoiceTableGrid.geniisysRows.length; i++){
				    if(objGIPIS156.takeupSeqNo == invoiceTableGrid.geniisysRows[i].takeupSeqNo) {
						
						invoiceTableGrid.geniisysRows[i].recordStatus = 1;
						invoiceTableGrid.geniisysRows[i].multiBookingYy = objGIPIS156.multiBookingYy;
						invoiceTableGrid.geniisysRows[i].multiBookingMm = objGIPIS156.multiBookingMm;
						
						objGIPIS156Invoice.splice(i, 1, invoiceTableGrid.geniisysRows[i]);
						invoiceTableGrid.updateVisibleRowOnly(invoiceTableGrid.geniisysRows[i], i);
					}	
				}

				if(rowObj.takeupSeqNo == invoiceTableGrid.geniisysRows.first().takeupSeqNo){
					$("txtBookingYrMnth").value = rowObj.multiBookingYy + " - " + rowObj.multiBookingMm;
					objGIPIS156.bookingMth = rowObj.multiBookingMm;
					objGIPIS156.bookingYear = rowObj.multiBookingYy;
				}
				
				invoiceClick(null);
				objGIPIS156.changeTag = true;
				changeTag = 1;
				changeTagFunc = updateGIPIS156;
			}
		}
		
		//benjo 10.07.2015 GENQA-SR-4890
		function validateBookingDate(){
			var valid = true;
			for(var i = 0; i < invoiceTableGrid.geniisysRows.length; i++){
				if(parseInt(nvl(objGIPIS156.takeupSeqNo,0)) + 1 == invoiceTableGrid.geniisysRows[i].takeupSeqNo){
					if(dateFormat(invoiceTableGrid.geniisysRows[i].multiBookingYy+" - "+invoiceTableGrid.geniisysRows[i].multiBookingMm, "yyyy-mm") <=
					   dateFormat(objGIPIS156.multiBookingYy+" - "+objGIPIS156.multiBookingMm, "yyyy-mm")){
						showMessageBox("Booking date schedule must be in proper sequence.", "I");
						valid = false;
					}
				}else if(parseInt(nvl(objGIPIS156.takeupSeqNo,0)) - 1 == invoiceTableGrid.geniisysRows[i].takeupSeqNo){
					if(dateFormat(invoiceTableGrid.geniisysRows[i].multiBookingYy+" - "+invoiceTableGrid.geniisysRows[i].multiBookingMm, "yyyy-mm") >=
					   dateFormat(objGIPIS156.multiBookingYy+" - "+objGIPIS156.multiBookingMm, "yyyy-mm")){
						showMessageBox("Booking date schedule must be in proper sequence.", "I");
						valid = false;
					}
				}
			}
			return valid;
		}
		
		$("btnUpdate").observe("click", function(){
			objGIPIS156.action = "update"; //added by robert 02.05.2015
			updateInvoice();
		});
		
		initGIPIS156();
		initializeAll();
		
	} catch (e) {
		showErrorMessage("Error : ", e);
	}
</script>