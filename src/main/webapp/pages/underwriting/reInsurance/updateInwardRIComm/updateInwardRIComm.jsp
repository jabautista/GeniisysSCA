<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div>
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv">
		<div id="innerDiv">
			<label>Update RI Commission (Inward)</label>
			<span class="refreshers" style="margin-top: 0;">
	 			<label id="btnReloadForm" name="gro" style="margin-left: 5px;">Reload Form</label>
			</span>
		</div>
	</div>
	<div class="sectionDiv">
		<table align="center" border="0" style="margin: 10px auto;">
			<tr>
				<td style="padding-right: 5px;">
					<label for="txtLineCd" style="float: right;">Policy No.</label>
				</td>
				<td>
					<input type="text" id="txtLineCd" class="allCaps required" style="height: 14px; width: 40px; margin: 0px;" maxlength="2"/>
					<input type="text" id="txtSublineCd" class="allCaps required" style="height: 14px; width: 70px; margin: 0px;" maxlength="7"/>
					<input type="text" id="txtIssCd" class="allCaps required" style="height: 14px; width: 40px; margin: 0px;" maxlength="2"/>
					<input type="text" id="txtIssueYy" class="integerNoNegativeUnformattedNoComma required" style="height: 14px; width: 40px; margin: 0px; text-align: right;" maxlength="2"/>
					<input type="text" id="txtPolSeqNo" class="integerNoNegativeUnformattedNoComma required" style="height: 14px; width: 70px; margin: 0px; text-align: right;" maxlength="7"/>
					<input type="text" id="txtRenewNo" class="integerNoNegativeUnformattedNoComma required" style="height: 14px; width: 40px; margin: 0px; text-align: right; margin-right: 7px;" maxlength="2"/>
					<input type="hidden"/>
					<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgPolNo" alt="Go" style="float: right;" />
				</td>
				<td style="padding-right: 5px;">
					<label for="txtEndtIssCd" style="margin-left: 20px; float: right;">Endorsement No.</label>
				</td>
				<td>
					<input type="text" id="txtEndtIssCd" class="allCaps" style="width: 40px; margin: 0px; height: 14px;" maxlength="2"/>
					<input type="text" id="txtEndtYy" class="integerNoNegativeUnformattedNoComma" style="width: 40px; margin: 0px; height: 14px; text-align: right;" maxlength="2"/>
					<input type="text" id="txtEndtSeqNo" class="integerNoNegativeUnformattedNoComma" style="width: 71px; margin: 0px; height: 14px; text-align: right;" maxlength="6"/>
				</td>
			</tr>
			<tr>
				<td style="padding-right: 5px;">
					<label for="txtAssdName" style="float: right;">Assured Name</label>
				</td>
				<td colspan="3">
					<input type="text" id="txtAssdName" class="allCaps" style="width: 699px; margin: 0px; height: 14px;" maxlength="500"/>
				</td>
			</tr>
			<tr>
				<td style="padding-right: 5px;">
					<label for="txtInceptDate" style="float: right;">Incept Date</label>
				</td>
				<td colspan="3">
					<input type="text" id="txtInceptDate" class="" style="width: 120px; margin: 0px; height: 14px;" readonly="readonly"/>
					<label for="txtEffDate" style="float: none; margin: 0 5px 1px 58px;">Effectivity Date</label>
					<input type="text" id="txtEffDate" class="" style="width: 120px; margin: 0px; height: 14px;" readonly="readonly"/>
					<label for="txtAcctEntryDate" style="float: none; margin: 0 5px 1px 59px;">Acct. Entry Date</label>
					<input type="text" id="txtAcctEntryDate" class="" style="width: 120px; margin: 0px; height: 14px;" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td style="padding-right: 5px;">
					<label for="txtExpiryDate" style="float: right;">Expiry Date</label>
				</td>
				<td colspan="3">
					<input type="text" id="txtExpiryDate" class="" style="width: 120px; margin: 0px; height: 14px;" readonly="readonly"/>
					<label for="txtIssueDate" style="float: none; margin: 0 5px 1px 83px;">Issue Date</label>
					<input type="text" id="txtIssueDate" class="" style="width: 120px; margin: 0px; height: 14px;" readonly="readonly"/>
					<label for="txtBookingMonth" style="float: none; margin: 0 5px 1px 37px;">Booking Month/Year</label>
					<input type="text" id="txtBookingMth" class="" style="width: 70px; margin: 0px; height: 14px;" readonly="readonly"/>
					<input type="text" id="txtBookingYear" class="" style="width: 38px; margin: 0px; height: 14px;" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td style="padding-right: 5px;">
					<label for="txtCedingCompany" style="float: right;">Ceding Company</label>
				</td>
				<td colspan="3">
					<input type="text" id="txtCedingCompany" class="allCaps" style="width: 699px; margin: 0px; height: 14px;" readonly="readonly"/>
				</td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv">
		<div style="clear: both; margin: 10px auto; width: 900px;">
			<div id="itemTableGrid" style="height: 203px;"></div>
		</div>
	</div>
	<div class="sectionDiv">
		<div style="clear: both; margin: 10px auto; width: 900px;">
			<div id="perilTableGrid" style="height: 180px;"></div>
		</div>
		<table align="center">
			<tr>
				<td style="padding-right: 5px;">
					<label for="txtPerilName" style="float: right;">Peril Name</label>
				</td>
				<td colspan="3">
					<input type="text" id="txtPerilName" style="height: 14px; width: 500px;" readonly="readonly" />
				</td>
			</tr>
			<tr>
				<td style="padding-right: 5px;">
					<label for="txtPremAmt" style="float: right; ">Premium Ceded</label>
				</td>
				<td>
					<input type="text" id="txtPremAmt" style="height: 14px; width: 160px; text-align: right;" readonly="readonly" />
				</td>
				<td style="padding-right: 5px;">
					<label for="txtRiCommRate" style="float: right; margin-left: 60px;">Commission Rate</label>
				</td>
				<td>
					<input type="text" id="txtRiCommRate" class="money" style="height: 14px; width: 160px; text-align: right;" />
				</td>
			</tr>
			<tr>
				<td style="padding-right: 5px;">
					<label for="txtRiCommAmt" style="float: right;">Commission Amount</label>
				</td>
				<td colspan="3">
					<input type="text" id="txtRiCommAmt" class="money" style="height: 14px; width: 500px; text-align: right;" />
				</td>
			</tr>
		</table>
		<div style="float: none; text-align: center; padding: 10px 0;">
			<input type="button" class="button" id="btnUpdate" value="Update" style="width: 120px;"/>
		</div>
	</div>
	<div style="margin-bottom: 50px; clear: both; text-align: center; padding-top: 10px;">
		<input type="button" class="button" id="btnCancel" value="Cancel" style="width: 120px;" />
		<input type="button" class="button" id="btnSave" value="Save" style="width: 120px;" />
	</div>
</div>
<script>
	try {
		
		//$("btnReloadForm").hide();
		
		objGIPIS175 = new Object();
		objGIPIS175Items = new Object();
		objGIPIS175ItemRow = new Object();
		objGIPIS175Perils = new Object();
		objGIPIS175PerilRow = new Object();
		var oldCommRate;
		var oldCommAmt;
		var recordSelected = false;
		
		function initGIPIS175(){
			$("txtLineCd").focus();
			setModuleId("GIPIS175");
			setDocumentTitle("Update RI Commission (Inward)");
			hideToolbarButton("btnToolbarPrint");
			showToolbarButton("btnToolbarSave");
			disableToolbarButton("btnToolbarExecuteQuery");
			disableToolbarButton("btnToolbarEnterQuery");
			disableButton("btnUpdate");
			objGIPIS175.difference = 0;
		}
		
		function resetForm(){
			objGIPIS175 = new Object();
			objGIPIS175.difference = 0;
			objGIPIS175Items = new Object();
			objGIPIS175ItemRow = new Object();
			objGIPIS175Perils = new Object();
			objGIPIS175PerilRow = new Object();
			changeTag = 0;
			changeTagFunc = null;
			oldCommRate = 0;
			oldCommAmt = 0;
			recordSelected = false;
			disableToolbarButton("btnToolbarExecuteQuery");
			disableToolbarButton("btnToolbarEnterQuery");
			$("txtLineCd").focus();
			$("txtLineCd").clear();
			$("txtSublineCd").clear();
			$("txtIssCd").clear();
			$("txtIssueYy").clear();
			$("txtPolSeqNo").clear();
			$("txtRenewNo").clear();
			
			enableSearch("imgPolNo");
			
			$("txtEndtIssCd").clear();
			$("txtEndtYy").clear();
			$("txtEndtSeqNo").clear();
			$("txtAssdName").clear();
			$("txtInceptDate").clear();
			$("txtEffDate").clear();
			$("txtAcctEntryDate").clear();
			$("txtExpiryDate").clear();
			$("txtIssueDate").clear();
			$("txtBookingMth").clear();
			$("txtBookingYear").clear();
			$("txtCedingCompany").clear();
			
			$("txtLineCd").readOnly = false;
			$("txtSublineCd").readOnly = false;
			$("txtIssCd").readOnly = false;
			$("txtIssueYy").readOnly = false;
			$("txtPolSeqNo").readOnly = false;
			$("txtRenewNo").readOnly = false;
			$("txtEndtIssCd").readOnly = false;
			$("txtEndtYy").readOnly = false;
			$("txtEndtSeqNo").readOnly = false;
			$("txtAssdName").readOnly = false;
			
			itemTableGrid.url = contextPath+ "/GIPIItemPerilController?action=getGIPIS175Items&refresh=1";
			itemTableGrid._refreshList();
			
			populatePerilTG(null);
			populatePerilFields(null);
		}
		
		$("btnToolbarEnterQuery").observe("click", function(){
			if(changeTag == 1){
				showConfirmBox4('Confirmation', objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function(){
					objGIPIS175.nextMove = "reset";
					$("btnSave").click();
				}, resetForm, null);
			} else 
				resetForm();	
		});
		
		function populatePerilTG(row){
			if(row != null) {
				objGIPIS175ItemRow = row;
				objGIPIS175.itemNo = row.itemNo;
				objGIPIS175.itemGrp = row.itemGrp;
				objGIPIS175.sumCommAmt = row.sumCommAmt;
				objGIPIS175.premSeqNo = row.premSeqNo;
				perilTableGrid.url = contextPath+ "/GIPIItemPerilController?action=getGIPIS175Perils&refresh=1&policyId=" + objGIPIS175.policyId
				   + "&itemNo=" + row.itemNo;
				perilTableGrid._refreshList();	
			} else{
				objGIPIS175ItemRow = null;
				objGIPIS175.itemNo = null;
				objGIPIS175.itemGrp = null;
				objGIPIS175.sumCommAmt = null;
				objGIPIS175.premSeqNo = null;
				
				perilTableGrid.url = contextPath+ "/GIPIItemPerilController?action=getGIPIS175Perils&refresh=1";
				perilTableGrid._refreshList();
			}	
		}
		
		perilTableModel = {
				url: contextPath+ "/GIPIItemPerilController?action=getGIPIS175Perils&refresh=1",
				id: 'tbgPeril',		
				options: {
					/* toolbar: {
						elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
					}, */
					width: '900px',
					height: '156px',
					hideColumnChildTitle : true,
					onCellFocus : function(element, value, x, y, id) {
						populatePerilFields(perilTableGrid.geniisysRows[y]);
						objGIPIS175.perilSelectedIndex = y;
						perilTableGrid.keys.removeFocus(perilTableGrid.keys._nCurrentFocus, true);
						perilTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus : function(element, value, x, y, id){					
						populatePerilFields(null);
						perilTableGrid.keys.removeFocus(perilTableGrid.keys._nCurrentFocus, true);
						perilTableGrid.keys.releaseKeys();
						objGIPIS175.perilSelectedIndex = -1;
					},
					beforeSort : function(element, value, x, y, id) {
						return checkUnsavedChanges();
						perilTableGrid.keys.removeFocus(perilTableGrid.keys._nCurrentFocus, true);
						perilTableGrid.keys.releaseKeys();
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
						id: 'dspPerilName',
						title: 'Peril Name',
						width: '361px',
						rendere: function(val){
							return unescapeHTML2(val);
						}
					},
					{
						id: 'premAmt',
						title: 'Premium Ceded',
						width: '175px',
						align: 'right',
						titleAlign: 'right',
						geniisysClass: 'money',
						filterOption: true
					},
					{
						id: 'riCommRate',
						title: 'Commission Rate',
						width: '175px',
						align: 'right',
						titleAlign: 'right',
						geniisysClass: 'money',
						filterOption: true
					},
					{
						id: 'riCommAmt',
						title: 'Commission Amount',
						width: '175px',
						align: 'right',
						titleAlign: 'right',
						geniisysClass: 'money',
						filterOption: true
					}
				],
				rows: []//jsonGIPIS156Invoice.rows
			};
		
		perilTableGrid = new MyTableGrid(perilTableModel);
		perilTableGrid.pager = [];//jsonGIPIS156Invoice;
		perilTableGrid.render('perilTableGrid');
		perilTableGrid.afterRender = function(){
			populatePerilFields(null);
			objGIPIS175Perils = perilTableGrid.geniisysRows;
		};
		
		function checkUnsavedChanges() {
			if(changeTag == 1){
				showConfirmBox4('Confirmation', objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function(){$("btnSave").click();},
						function(){
							changeTag = 0;
							changeTagFunc = null;
							itemTableGrid.onRemoveRowFocus();
							itemTableGrid._refreshList();
						}, null);
				return false;
			} else {
				return true;
			}
		}
		//changeTag = true;
		//var jsonGIPIS156Invoice = JSON.parse('${jsonGIPIS156Invoice}');
		itemTableModel = {
				url: contextPath+ "/GIPIItemPerilController?action=getGIPIS175Items&refresh=1",
				id: 'tbgItem',		
				options: {
					toolbar: {
						elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
					},
					width: '900px',
					height: '181px',
					hideColumnChildTitle : true,
					onCellFocus : function(element, value, x, y, id) {
						objGIPIS175.itemSelectedIndex = y;
						populatePerilTG(itemTableGrid.geniisysRows[y]);					
						itemTableGrid.keys.removeFocus(itemTableGrid.keys._nCurrentFocus, true);
						itemTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus : function(element, value, x, y, id){
						objGIPIS175.itemSelectedIndex = -1;
						populatePerilTG(null);
						itemTableGrid.keys.removeFocus(itemTableGrid.keys._nCurrentFocus, true);
						itemTableGrid.keys.releaseKeys();
					},
					beforeClick : function(element, value, x, y, id) {
						return checkUnsavedChanges();
						itemTableGrid.keys.removeFocus(itemTableGrid.keys._nCurrentFocus, true);
						itemTableGrid.keys.releaseKeys();
					},
					beforeSort : function(element, value, x, y, id) {
						return checkUnsavedChanges();
						itemTableGrid.keys.removeFocus(itemTableGrid.keys._nCurrentFocus, true);
						itemTableGrid.keys.releaseKeys();
					},
					/* checkChanges: function(){
						return (changeTag == true ? true : false);
					},  */
					/* masterDetailRequireSaving: function(){
						return (changeTag == true ? true : false);
						//msg : please save changes first
					}, */
					 masterDetailValidation: function(){
						return (changeTag == 1 ? true : false);
					},
					masterDetail: function(){
						
					},
					masterDetailSaveFunc: function() {
						$("btnSave").click();
					},
					masterDetailNoFunc: function(){
						changeTag = 0;
						changeTagFunc = null;
						populatePerilTG(null);
					}
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
						id: 'itemNo',
						title: 'Item No.',
						width: '100px',
						align: 'right',
						titleAlign: 'right',
						filterOption: true,
						filterOptionType : 'integerNoNegative'
					},
					{
						id: 'itemTitle',
						title: 'Item Title',
						width: '280px',
						filterOption: true
					},
					{
						id: 'dspCurrencyDesc',
						title: 'Currency',
						width: '204px',
						filterOption: true
					},
					{
						id: 'sumCommAmt',
						title: 'Commission Amount',
						width: '150px',
						align: 'right',
						titleAlign: 'right',
						filterOption: true,
						filterOptionType : 'number',
						geniisysClass: 'money'
					},
					{
						id: 'riCommVat',
						title: 'RI Commission VAT',
						width: '150px',
						align: 'right',
						titleAlign: 'right',
						filterOption: true,
						filterOptionType : 'number',
						geniisysClass: 'money'
					}
				],
				rows: []//jsonGIPIS156Invoice.rows
			};
		
		itemTableGrid = new MyTableGrid(itemTableModel);
		itemTableGrid.pager = [];//jsonGIPIS156Invoice;
		itemTableGrid.render('itemTableGrid');
		itemTableGrid.afterRender = function(){
			try{
				objGIPIS175.itemSelectedIndex = -1;
				objGIPIS175Items = itemTableGrid.geniisysRows;
				populatePerilTG(null);	
			}catch(e){
				showErrorMessage("Error: ", e);
			}
		};
		
		
		
		function getGIPIS175PolicyLOV(){
			onLOV = true;
			LOV.show({
				id : "gipis175PolicyLOV",
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGIPIS175PolicyLOV",
					lineCd : $F('txtLineCd'),
					sublineCd : $F('txtSublineCd'),
					issCd : $F('txtIssCd'),
					issueYy : $F('txtIssueYy'),
					polSeqNo : $F('txtPolSeqNo'),
					renewNo : $F('txtRenewNo'),
					assdName : $F('txtAssdName'),
					endtIssCd : $F('txtEndtIssCd'),
					endtSeqNo : $F('txtEndtSeqNo'),
					endtYy : $F('txtEndtYy'),
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
								filterOptionType: 'number'
							},
							{
								id: 'polSeqNo',
								title: 'Pol Seq No',
								width: 70,
								align: "right",
								filterOption: true,
								filterOptionType: 'number',
								renderer: function(val){
									return formatNumberDigits(val, 7);
								}
							},
							{
								id: 'renewNo',
								title: 'Renew No',
								width: 40,
								align: "right",
								filterOption: true,
								filterOptionType: 'number',
								renderer: function(val){
									return formatNumberDigits(val, 2);
								}
							}
						]
					},
					{
						id : 'endorsementNo',
						title : 'Endt No.',
						children : [
							{
								id: 'endtIssCd',
								title : 'Endt Iss Cd',
								width: 40,
								filterOption: true
							},
							{
								id: 'endtYy',
								title : 'Endt Yy',
								width: 40,
								filterOption: true,
								filterOptionType: 'number'
							},
							{
								id: 'endtSeqNo',
								title : 'Endt Seq No',
								width: 70,
								align: "right",
								filterOption: true,
								filterOptionType: 'number',
								renderer: function(val){
									if(val != "")
										return formatNumberDigits(val, 6);
									else
										return null;
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
					populateBasicInfo(row);
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
		
		function populateBasicInfo(row){
			$("txtLineCd").value = row.lineCd;
			$("txtSublineCd").value = row.sublineCd;
			$("txtIssCd").value = row.issCd;
			$("txtIssueYy").value = row.issueYy;
			$("txtPolSeqNo").value = formatNumberDigits(row.polSeqNo, 7);
			$("txtRenewNo").value = formatNumberDigits(row.renewNo, 2);
			$("txtEndtIssCd").value = row.endtIssCd;
			$("txtEndtYy").value = row.endtYy;
			$("txtEndtSeqNo").value = row.endtSeqNo != null ? formatNumberDigits(row.endtSeqNo, 6) : null;
			$("txtAssdName").value = unescapeHTML2(row.assdName).toUpperCase();
			$("txtInceptDate").value = row.nbtInceptDate != null ? dateFormat(row.nbtInceptDate, "mm-dd-yyyy") : "";
			$("txtEffDate").value = row.nbtEffDate != null ? dateFormat(row.nbtEffDate, "mm-dd-yyyy") : "";
			$("txtAcctEntryDate").value = row.nbtAcctEntDate != null ? dateFormat(row.nbtAcctEntDate, "mm-dd-yyyy") : "";
			$("txtExpiryDate").value = row.nbtExpiryDate != null ? dateFormat(row.nbtExpiryDate, "mm-dd-yyyy") : "";
			$("txtIssueDate").value = row.nbtIssueDate != null ? dateFormat(row.nbtIssueDate, "mm-dd-yyyy") : "";
			$("txtBookingMth").value = row.nbtBookingMth;
			$("txtBookingYear").value = row.nbtBookingYear;
			$("txtCedingCompany").value = unescapeHTML2(row.nbtCedingCompany).toUpperCase();
			
			objGIPIS175.policyId = row.policyId;
			objGIPIS175.updatableSw = row.updatableSw;
			objGIPIS175.coInsuranceSw = row.coInsuranceSw;
			objGIPIS175.issCd = row.issCd;
			objGIPIS175.branchCd = row.branchCd;
			objGIPIS175.lineCd = row.lineCd;
			objGIPIS175.riCd = row.riCd;
			objGIPIS175.prevRiCommAmt = row.prevRiCommAmt;
			objGIPIS175.oldRiCommVat = row.oldRiCommVat;
			objGIPIS175.inputVatRate = row.inputVatRate;
			
			enableToolbarButton("btnToolbarExecuteQuery");
			recordSelected = true;
		}
		
		function populatePerilFields(row) {
			if(row != null) {
				objGIPIS175PerilRow = row;
				objGIPIS175.perilCd = row.perilCd;
				//objGIPIS175.lineCd = row.lineCd;
				objGIPIS175.riCommRate = row.riCommRate;
				
				$("txtPerilName").value = unescapeHTML2(row.dspPerilName);
				$("txtRiCommRate").value = formatCurrency(row.riCommRate);
				$("txtPremAmt").value = formatCurrency(row.premAmt);
				$("txtRiCommAmt").value = formatCurrency(row.riCommAmt);
				
				oldCommRate =$("txtRiCommRate").value;
				oldCommAmt = $("txtRiCommAmt").value;
				
				if(objGIPIS175.updatableSw == 'Y'){
					$("txtRiCommRate").readOnly = false;
					$("txtRiCommAmt").readOnly = false;
				} else {
					$("txtRiCommRate").readOnly = true;
					$("txtRiCommAmt").readOnly = true;
				}
				
				enableButton("btnUpdate");
				
			} else {
				objGIPIS175PerilRow = null;
				objGIPIS175.perilCd = null;
				//objGIPIS175.lineCd = null;
				objGIPIS175.riCommRate = null;
				
				$("txtPerilName").clear();
				$("txtRiCommRate").clear();
				$("txtPremAmt").clear();
				$("txtRiCommAmt").clear();
				
				$("txtRiCommRate").readOnly = true;
				$("txtRiCommAmt").readOnly = true;
				
				disableButton("btnUpdate");
			}
		}
		
		function executeQuery(){
			itemTableGrid.url = contextPath+ "/GIPIItemPerilController?action=getGIPIS175Items&refresh=1&policyId=" + objGIPIS175.policyId;
			itemTableGrid._refreshList();
			
			disableToolbarButton("btnToolbarExecuteQuery");
			
			$("txtLineCd").readOnly = true;
			$("txtSublineCd").readOnly = true;
			$("txtIssCd").readOnly = true;
			$("txtIssueYy").readOnly = true;
			$("txtPolSeqNo").readOnly = true;
			$("txtRenewNo").readOnly = true;
			$("txtEndtIssCd").readOnly = true;
			$("txtEndtYy").readOnly = true;
			$("txtEndtSeqNo").readOnly = true;
			$("txtAssdName").readOnly = true;
			
			disableSearch("imgPolNo");
		}
		
		function setItem(){
			
			var i = new Object();
			i = objGIPIS175ItemRow;
			i.sumCommAmt = parseFloat(i.sumCommAmt) + parseFloat(objGIPIS175.difference);
			i.riCommVat = (parseFloat(i.sumCommAmt) * (parseFloat(objGIPIS175.inputVatRate) / 100)).toFixed(2);
			objGIPIS175.difference = 0;
			return i;
		}
		
		function updateItem(){
			var rowObj = setItem();
			objGIPIS175Items.splice(objGIPIS175.itemSelectedIndex , 1, rowObj);
			itemTableGrid.updateVisibleRowOnly(rowObj, objGIPIS175.itemSelectedIndex);
			itemTableGrid.selectRow(objGIPIS175.itemSelectedIndex);
		}
		
		
		function setPeril(){
			var p = new Object();
			p = objGIPIS175PerilRow;
			p.recordStatus = 1;
			p.policyId = objGIPIS175.policyId;
			p.itemNo = objGIPIS175.itemNo;
			p.perilCd = objGIPIS175.perilCd;
			p.lineCd = objGIPIS175.lineCd;
			p.riCommRate = unformatCurrencyValue($F("txtRiCommRate"));
			p.riCommAmt = unformatCurrencyValue($F("txtRiCommAmt"));
			return p;
		}
		
		function updatePeril(){
			
			if(parseFloat(objGIPIS175.difference) != 0)
				updateItem();
			
			var rowObj = setPeril();
			
			objGIPIS175Perils.splice(objGIPIS175.perilSelectedIndex, 1, rowObj);
			perilTableGrid.updateVisibleRowOnly(rowObj, objGIPIS175.perilSelectedIndex);
			//perilTableGrid.selectRow(objGIPIS175.perilSelectedIndex);
			changeTag = 1;
			changeTagFunc = funcBeforeLogout;
			
			objGIPIS175.perilSelectedIndex = -1;
			populatePerilFields(null);			
		}
	
		
		$("txtRiCommRate").observe("keypress", function(event){
			if(this.readOnly){
				if(objGIPIS175.updatableSw == 'N')
					showMessageBox("This policy already has premium collections.", "I");
			}
		});
		
		$("txtRiCommAmt").observe("keypress", function(event){
			if(this.readOnly){
				if(objGIPIS175.updatableSw == 'N')
					showMessageBox("This policy already has premium collections.", "I");
			}
		});
		
		function validateRiCommAmt(){
			var riCommAmt = parseFloat(unformatCurrencyValue($F("txtRiCommAmt")));
			var premAmt = parseFloat(unformatCurrencyValue($F("txtPremAmt")));
			
			if(Math.abs(riCommAmt) > Math.abs(premAmt)){
				customShowMessageBox("Commission amount must not be greater than the Premium amount.", "I", "txtRiCommAmt");
				$("txtRiCommAmt").value = oldCommAmt;
			} else {
				
				var oldRiCommAmt = parseFloat(perilTableGrid.geniisysRows[objGIPIS175.perilSelectedIndex].riCommAmt);
				objGIPIS175.difference = riCommAmt - oldRiCommAmt;
				
				var riCommRate = (riCommAmt / premAmt) * 100;
				
				$("txtRiCommAmt").value = formatCurrency($("txtRiCommAmt").value);
				$("txtRiCommRate").value = formatCurrency(Math.round(riCommRate * 100) / 100);
				oldCommAmt = $("txtRiCommAmt").value;
				oldCommRate = $("txtRiCommRate").value;
			}
		}
		
		$("txtRiCommAmt").observe("change", function(){
			if(this.value.trim() == ""){
				this.value = "0.00";
				oldCommAmt = "0.00";
				return false;
			} else {
				validateRiCommAmt();
			}
		});
		
		function validateRiCommRate(){
			
			/* to prevent the user to enter null value in commission rate */
			
			if($F("txtRiCommRate").trim() == ""){
				customShowMessageBox("Invalid Commission Rate. Valid value should be from 0.00 to 100.00", "I", "txtRiCommRate");
				$("txtRiCommRate").value = oldCommRate;
				return false;
			}
			
			/*  */
			
			var riCommRate = parseFloat(unformatCurrencyValue($F("txtRiCommRate")));
			var premAmt = parseFloat(unformatCurrencyValue($F("txtPremAmt")));
			
			if(riCommRate > 100 || riCommRate < 0){
				customShowMessageBox("Invalid Commission Rate. Valid value should be from 0.00 to 100.00", "I", "txtRiCommRate");
				$("txtRiCommRate").value = oldCommRate;
				return false;
			}
			
			var oldRiCommAmt = parseFloat(unformatCurrencyValue($("txtRiCommAmt").value));
			var riCommAmt = riCommRate * premAmt / 100;
			
			objGIPIS175.difference = riCommAmt - oldRiCommAmt;
			
			$("txtRiCommRate").value = formatCurrency($("txtRiCommRate").value); 
			$("txtRiCommAmt").value = formatCurrency(Math.round(riCommAmt * 100) / 100);// formatCurrency(riCommAmt);
			oldCommAmt = $("txtRiCommAmt").value;
			oldCommRate = $("txtRiCommRate").value;
		}
		
		$("txtRiCommRate").observe("change", function(){
			
			validateRiCommRate();
			
			/* if(this.value.trim() == ""){
				this.clear();
				return false;
			} else {
				validateRiCommRate();
			} */
		});
		
		$("btnUpdate").observe("click", function(){
			
			if(parseFloat($("txtRiCommRate").value) > 100 || parseFloat($("txtRiCommRate").value) < 0){
				customShowMessageBox("Invalid Commission Rate. Valid value should be from 0.00 to 100.00", "I", "txtRiCommRate");
				return false;
			}
			
			if(objGIPIS175.updatableSw == 'N'){
				showMessageBox("This policy already has premium collections.", "I");
				return false;
			}
			updatePeril();
		});
		
		function save(){
			var objParams = new Object();
			objParams.setRows = getAddedAndModifiedJSONObjects(objGIPIS175Perils);
			
			new Ajax.Request(contextPath+"/GIPIPolbasicController",{
				method: "POST",
				parameters:{
					action     : "saveGIPIS175",
					policyId : objGIPIS175.policyId,
				    itemGrp : objGIPIS175.itemGrp,
					parameters : JSON.stringify(objParams),
					sumCommAmt : objGIPIS175.sumCommAmt,
					acctEntDate	:	$F("txtAcctEntryDate"),
					premSeqNo : objGIPIS175.premSeqNo,
					coInsuranceSw : objGIPIS175.coInsuranceSw,
					itemNo : objGIPIS175.itemNo,
					/* perilCd : objGIPIS175.perilCd,
					riCommRate : objGIPIS175.riCommRate,*/ 
					issCd : objGIPIS175.issCd,
					branchCd : objGIPIS175.branchCd,
					lineCd : objGIPIS175.lineCd,
					riCd : objGIPIS175.riCd,
					prevRiCommAmt : objGIPIS175.prevRiCommAmt,
					oldRiCommVat : objGIPIS175.oldRiCommVat 
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function(){
					showNotice("Saving, please wait...");
				},
				onComplete: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
						if($("txtAcctEntryDate").value != ""){
							showWaitingMessageBox("Accounting entries successfully generated.", "I", function(){
								showWaitingMessageBox(objCommonMessage.SUCCESS, "S", function(){
									if(objGIPIS175.nextMove == "exit"){
										exit();
									} else if (objGIPIS175.nextMove == "reset"){
										resetForm();
									} else {
										itemTableGrid.url = contextPath+ "/GIPIItemPerilController?action=getGIPIS175Items&refresh=1&policyId=" + objGIPIS175.policyId;
										itemTableGrid._refreshList();
										changeTag = 0;
										changeTagFunc = null;
									}	
								});
							});
						} else {
							showWaitingMessageBox(objCommonMessage.SUCCESS, "S", function(){
								if(objGIPIS175.nextMove == "exit"){
									exit();
								} else if (objGIPIS175.nextMove == "reset"){
									resetForm();
								} else {
									itemTableGrid.url = contextPath+ "/GIPIItemPerilController?action=getGIPIS175Items&refresh=1&policyId=" + objGIPIS175.policyId;
									itemTableGrid._refreshList();
									changeTag = 0;
									changeTagFunc = null;
								}	
							});
						}
							
					}
				}
			});
		}
		
		function funcBeforeLogout(){
			if($("btnUpdate").disabled){
				showMessageBox("Please select a peril before saving.", "I");
				objGIPIS175.nextMove = null;
				return false;
			}
			
			if($("txtAcctEntryDate").value != ""){
				showWaitingMessageBox("Policy has already been taken up. Accounting entries will be generated.", "I", save);	
			} else {
				save();
			}
		}
		
		$("btnSave").observe("click", function(){
			if(changeTag == 1){
				
				/* if($("btnUpdate").disabled){
					showMessageBox("Please select a peril before saving.", "I");
					objGIPIS175.nextMove = null;
					return false;
				} */
				
				if($("txtAcctEntryDate").value != ""){
					showWaitingMessageBox("Policy has already been taken up. Accounting entries will be generated.", "I", save);	
				} else {
					save();
				}
			} else {
				showMessageBox(objCommonMessage.NO_CHANGES, "I");
			}
		});
		
		$("btnToolbarSave").observe("click", function(){
			$("btnSave").click();
		});
		
		$("btnToolbarExecuteQuery").observe("click", function(){
			if(objGIPIS175.policyId == null){
				showMessageBox("Please enter required fields.", "I");
			}
			
			executeQuery();
		});
		
		$("imgPolNo").observe("click", function(){
			if($("txtLineCd").value.trim() == ""){
				$("txtLineCd").clear();
				customShowMessageBox("Please enter Line Code first.", "I", "txtLineCd");
				return false;
			}
			
			getGIPIS175PolicyLOV();
		});
		
		
		function exit(){
			delete objGIPIS175;
			delete objGIPIS175Items;
			delete objGIPIS175ItemRow;
			delete objGIPIS175Perils;
			delete objGIPIS175PerilRow;
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
		
		$("btnToolbarExit").observe("click", function(){
			if(changeTag == 1){
				showConfirmBox4('Confirmation', objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function(){
					objGIPIS175.nextMove = "exit";
					$("btnSave").click();
				}, exit, null);
			} else 
				exit();
		});
		
		//$("btnReloadForm").observe("click", showUpdateInwardRIComm);
		$("btnReloadForm").observe("click", function(){
			$("btnToolbarEnterQuery").click();
		});
		
		function observeOnKeypress(event, obj){
			enableToolbarButton("btnToolbarEnterQuery");
			
			if(obj.readOnly)
				return false;
			
			if(!recordSelected)
				return false;
			
			if(event.keyCode == 8 || event.keyCode == 46 || event.keyCode == 0){
				objGIPIS175.policyId = null;
				$("txtEndtIssCd").clear();
				$("txtEndtYy").clear();
				$("txtEndtSeqNo").clear();
				$("txtAssdName").clear();
				$("txtInceptDate").clear();
				$("txtEffDate").clear();
				$("txtAcctEntryDate").clear();
				$("txtExpiryDate").clear();
				$("txtIssueDate").clear();
				$("txtBookingMth").clear();
				$("txtBookingYear").clear();
				$("txtCedingCompany").clear();
				recordSelected = false;
			}
		}
		
		$("txtLineCd").observe("keypress", function(event){
			observeOnKeypress(event, this);
		});
		
		$("txtSublineCd").observe("keypress", function(event){
			observeOnKeypress(event, this);
		});
		
		$("txtIssCd").observe("keypress", function(event){
			observeOnKeypress(event, this);
		});
		
		$("txtIssueYy").observe("keypress", function(event){
			observeOnKeypress(event, this);
		});
		
		$("txtPolSeqNo").observe("keypress", function(event){
			observeOnKeypress(event, this);
		});
		
		$("txtRenewNo").observe("keypress", function(event){
			observeOnKeypress(event, this);
		});
		
		$("txtEndtIssCd").observe("keypress", function(event){
			observeOnKeypress(event, this);
		});
		
		$("txtEndtYy").observe("keypress", function(event){
			observeOnKeypress(event, this);
		});
		
		$("txtEndtSeqNo").observe("keypress", function(event){
			observeOnKeypress(event, this);
		});
		
		$("txtAssdName").observe("keypress", function(event){
			observeOnKeypress(event, this);
		});
		
		$("btnCancel").observe("click", function(){
			$("btnToolbarExit").click();
		});
		
		initGIPIS175();
		initializeAll();
	} catch (e) {
		showErrorMessage("Error: ", e);
	}
</script>