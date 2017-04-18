<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="gicls106MainDiv" name="gicls106MainDiv" style="">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Loss/Expense Tax Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="gicls106" name="gicls106">	
		<div id="lossExpTaxDiv" align="center" class="sectionDiv" style="padding-top:20px; padding-bottom: 20px;">
			<table cellspacing="0" width: 900px;">
				<tr>
					<td class="rightAligned" style="width:60px;">Tax Type</td>
					<td class="leftAligned" style="width:350px;">
						<span class="lovSpan required" style="width: 70px; height: 21px; margin: 2px 2px 0 0; float: left;">
							<input type="text" id="txtTaxType" name="txtTaxType" ignoreDelKey="1" style="width: 43px; float: left; border: none; height: 13px;" class="disableDelKey allCaps required" maxlength="1" tabindex="101" />
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchTaxType" name="searchTaxType" alt="Go" style="float: right;">
						</span> 
						<span class="lovSpan" style="border: none; height: 21px; margin: 0 2px 0 2px; float: left;">
							<input type="text" id="txtTaxTypeDesc" name="txtTaxTypeDesc" ignoreDelKey="1" style="width: 250px; float: left; height: 15px;" class="allCaps" maxlength="30" readonly="readonly" tabindex="102" />
						</span>
					</td>
					<td class="rightAligned" style="width:60px;">Branch</td>
					<td class="leftAligned" style="width:350px;">
						<span class="lovSpan required" style="width: 70px; height: 21px; margin: 2px 2px 0 0; float: left;">
							<input type="text" id="txtBranch" name="txtBranch" ignoreDelKey="1" style="width: 43px; float: left; border: none; height: 13px;" class="disableDelKey allCaps required" maxlength="2" tabindex="103" />
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranch" name="searchBranch" alt="Go" style="float: right;">
						</span> 
						<span class="lovSpan" style="border: none; height: 21px; margin: 0 2px 0 2px; float: left;">
							<input type="text" id="txtBranchDesc" name="txtBranchDesc" ignoreDelKey="1" style="width: 250px; float: left; height: 15px;" class="allCaps" maxlength="30" readonly="readonly" tabindex="104" />
						</span>
					</td>
				</tr>
			</table>
		</div>	
		<div class="sectionDiv">
			<div id="lossExpenseTaxTableDiv" style="padding-top: 10px;">
				<div id="lossExpenseTaxTable" style="height: 331px; padding-left: 85px;"></div>
			</div>
			<div align="center">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">GL Acct. No.</td>
						<td class="leftAligned">
							<input id="txtGlAcctCategory" type="text" class="integerNoNegativeUnformattedNoComma" style="width: 18px; text-align: right;" maxlength="1" readonly="readonly" tabindex="201">
							<input id="txtGlControlAcct" type="text" class="integerNoNegativeUnformattedNoComma" style="width: 18px; text-align: right;" maxlength="2" readonly="readonly" tabindex="202">
							<input id="txtGlSubAcct1" type="text" class="integerNoNegativeUnformattedNoComma" style="width: 18px; text-align: right;" maxlength="2" readonly="readonly" tabindex="203" >
							<input id="txtGlSubAcct2" type="text" class="integerNoNegativeUnformattedNoComma" style="width: 18px; text-align: right;" maxlength="2" readonly="readonly" tabindex="204">
							<input id="txtGlSubAcct3" type="text" class="integerNoNegativeUnformattedNoComma" style="width: 18px; text-align: right;" maxlength="2" readonly="readonly" tabindex="205">
							<input id="txtGlSubAcct4" type="text" class="integerNoNegativeUnformattedNoComma" style="width: 18px; text-align: right;" maxlength="2" readonly="readonly" tabindex="206">
							<input id="txtGlSubAcct5" type="text" class="integerNoNegativeUnformattedNoComma" style="width: 18px; text-align: right;" maxlength="2" readonly="readonly" tabindex="207">
							<input id="txtGlSubAcct6" type="text" class="integerNoNegativeUnformattedNoComma" style="width: 18px; text-align: right;" maxlength="2" readonly="readonly" tabindex="208">
							<input id="txtGlSubAcct7" type="text" class="integerNoNegativeUnformattedNoComma" style="width: 18px; text-align: right;" maxlength="2" readonly="readonly" tabindex="209">
						</td>
						<td width="70px" class="rightAligned">SL Type</td>
						<td class="leftAligned">
							<input id="txtSlTypeCd" type="text" class="" style="width: 50px; text-align: left;" tabindex="210" maxlength="2" readonly="readonly">
							<input id="txtSlTypeName" type="text" class="" style="width: 200px; text-align: left;" tabindex="211" maxlength="100" readonly="readonly">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Account Name</td>
						<td class="leftAligned" colspan="3">
							<input id="txtAcctName" type="text" class="" style="width: 611px;" tabindex="212" maxlength="20" readonly="readonly">
						</td>
					</tr>
				</table>
			</div>
			<div align="center" id="lossExpenseFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Tax Code</td>
						<td class="leftAligned">
							<input id="txtTaxCd" type="text" class="required integerNoNegativeUnformattedNoComma rightAligned" style="width: 200px; margin-bottom:0px;" tabindex="301" maxlength="2" readonly="readonly">
						</td>
						<td class="rightAligned">Tax Rate</td>
						<td class="leftAligned">
							<input id="txtTaxRate" type="text" class="required applyDecimalRegExp2 rightAligned" regExpPatt="pDeci0309" min="0.000000000" max="100.000000000" customLabel="Tax Rate" style="width: 201px; margin-bottom:0px;" tabindex="302" maxlength="">
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Tax Name</td>
						<td class="leftAligned" colspan="3">
							<input id="txtTaxName" type="text" class="required allCaps" style="width: 533px; margin-bottom:0px; margin-top:0px;" tabindex="303" maxlength="20" readonly="readonly">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Start Date</td>
						<td class="leftAligned">
							<div id="startDateDiv" class="required" style="float: left; border: 1px solid gray; width: 205px; height: 20px;">
								<input id="txtStartDate" name="Start Date." readonly="readonly" type="text" class=" required date " maxlength="10" style="border: none; float: left; width: 180px; height: 13px; margin: 0px;" value="" tabindex="304"/>
								<img id="imgStartDate" alt="imgStartDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtStartDate'),this, null);" />
							</div>
						</td>
						<td class="rightAligned">End Date</td>
						<td class="leftAligned">
							<div id="endDateDiv" class="" style="float: left; border: 1px solid gray; width: 207px; height: 20px;">
								<input id="txtEndDate" name="End Date." readonly="readonly" type="text" class="date " maxlength="10" style="border: none; float: left; width: 182px; height: 13px; margin: 0px;" value="" tabindex="305"/>
								<img id="imgEndDate" alt="imgEndDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtEndDate'),this, null);" />
							</div>
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="306"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="307"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px; margin-top:0px;" readonly="readonly" tabindex="308"></td>
						<td width="112px" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px; margin-top:0px;" readonly="readonly" tabindex="309"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;" align="center">
				<input type="button" class="button" id="btnAdd" value="Update" tabindex="310">
			</div>
			<div align="center" style="padding: 10px 0 10px 0; border-top: 1px solid #E0E0E0;">
				<input type="button" class="button" id="btnLineLossExp" value="Line-Loss/Expense" tabindex="213" style="width: 150px; ">
				<input type="button" class="button" id="btnCopyTax" value="Copy Tax" tabindex="214" style="width: 150px;">
				<input type="button" class="button" id="btnCopyTaxLine" value="Copy Tax-Line" tabindex="215" style="width: 150px;">
				<input type="button" class="button" id="btnTaxRateHistory" value="Tax Rate History" tabindex="216" style="width: 150px;">
			</div>
		</div>
	</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="311">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="312">
</div>
<script type="text/javascript">	
	setModuleId("GICLS106");
	setDocumentTitle("Loss/Expense Tax Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	showToolbarButton("btnToolbarSave"); 
	hideToolbarButton("btnToolbarPrint"); 
	disableToolbarButton("btnToolbarEnterQuery");
	disableToolbarButton("btnToolbarExecuteQuery");
	observeBackSpaceOnDate("txtStartDate");
	observeBackSpaceOnDate("txtEndDate");
	disableButton("btnAdd");
	$("txtTaxType").focus();
	
	disableButton("btnLineLossExp");
	disableButton("btnCopyTax");
	disableButton("btnCopyTaxLine");
	disableButton("btnTaxRateHistory");
	disableDate("imgStartDate");
	disableDate("imgEndDate");
	$("txtTaxRate").readOnly = true;
	$("txtRemarks").readOnly = true;
	
	
	function saveGicls106(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgLossExpenseTax.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgLossExpenseTax.geniisysRows);
		new Ajax.Request(contextPath+"/GIISLossTaxesController", {
			method: "POST",
			parameters : {action : "saveGicls106",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGICLS106.exitPage != null) {
							objGICLS106.exitPage();
						} else {
							tbgLossExpenseTax._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGicls106);
	
	var objGICLS106 = {};
	objGICLS106.lossTaxId = "";
	var objCurrLossExpenseTax = null;
	objGICLS106.lossExpenseTaxList = JSON.parse('${jsonLossExpTax}');
	objGICLS106.exitPage = null;
	
	var lossExpenseTaxTable = {
			url : contextPath + "/GIISLossTaxesController?action=showGicls106&refresh=1&taxType="+$F("txtTaxType")+"&branchCd="+encodeURIComponent($F("txtBranch")),
			options : {
				width : '750px',
				hideColumnChildTitle: true,
				id : 1,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrLossExpenseTax = tbgLossExpenseTax.geniisysRows[y];
					setFieldValues(objCurrLossExpenseTax);
					tbgLossExpenseTax.keys.removeFocus(tbgLossExpenseTax.keys._nCurrentFocus, true);
					tbgLossExpenseTax.keys.releaseKeys();
					$("txtTaxRate").focus();
					enableButton("btnLineLossExp");
					enableButton("btnCopyTax");
					enableButton("btnTaxRateHistory");
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgLossExpenseTax.keys.removeFocus(tbgLossExpenseTax.keys._nCurrentFocus, true);
					tbgLossExpenseTax.keys.releaseKeys();
					$("txtTaxRate").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgLossExpenseTax.keys.removeFocus(tbgLossExpenseTax.keys._nCurrentFocus, true);
						tbgLossExpenseTax.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
				},
				onSort: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgLossExpenseTax.keys.removeFocus(tbgLossExpenseTax.keys._nCurrentFocus, true);
					tbgLossExpenseTax.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgLossExpenseTax.keys.removeFocus(tbgLossExpenseTax.keys._nCurrentFocus, true);
					tbgLossExpenseTax.keys.releaseKeys();
				},				
				prePager: function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
					rowIndex = -1;
					setFieldValues(null);
					tbgLossExpenseTax.keys.removeFocus(tbgLossExpenseTax.keys._nCurrentFocus, true);
					tbgLossExpenseTax.keys.releaseKeys();
				},
				checkChanges: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailValidation: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetail: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailSaveFunc: function() {
					return (changeTag == 1 ? true : false);
				},
				masterDetailNoFunc: function(){
					return (changeTag == 1 ? true : false);
				}
			},
			columnModel : [
				{ 								// this column will only use for deletion
				    id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
				    width: '0',				    
				    visible : false			
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},	
				{
					id : 'taxCd',
					title : "Tax Code",
					filterOption : true,
					width : '80px',
					align : "right",
					titleAlign : "right",
					filterOptionType: 'integerNoNegative',
					renderer : function(value){
						return lpad(value,5,0);
					}
				},
				{
					id : 'taxName',
					filterOption : true,
					title : 'Tax Name',
					width : '370px'				
				},
				{
					id : 'taxRate',
					filterOption : true,
					title : 'Tax Rate',
					width : '110px',
					align : "right",
					titleAlign : "right",
					filterOptionType: 'number',
					renderer : function(value) {
						return formatToNthDecimal(value,9);
					}
				},
				{
					id : 'startDate',
					filterOption : true,
					title : 'Start Date',
					width : '80px',
					align : "center",
					titleAlign : "center",
					filterOptionType : 'formattedDate',
					renderer: function (value){
						var dateTemp;
						if(value=="" || value==null){
							dateTemp = "";
						}else{
							dateTemp = dateFormat(value,"mm-dd-yyyy");
						}
						value = dateTemp;
						return value;
					}
				},
				{
					id : 'endDate',
					filterOption : true,
					title : 'End Date',
					width : '80px',
					align : "center",
					titleAlign : "center",
					filterOptionType : 'formattedDate',
					renderer: function (value){
						var dateTemp;
						if(value=="" || value==null){
							dateTemp = "";
						}else{
							dateTemp = dateFormat(value,"mm-dd-yyyy");
						}
						value = dateTemp;
						return value;
					}
				},
				{
					id : 'remarks',
					width : '0',
					visible: false				
				},
				{
					id : 'userId',
					width : '0',
					visible: false
				},
				{
					id : 'lastUpdate',
					width : '0',
					visible: false				
				}
			],
			rows : objGICLS106.lossExpenseTaxList.rows
		};

		tbgLossExpenseTax = new MyTableGrid(lossExpenseTaxTable);
		tbgLossExpenseTax.pager = objGICLS106.lossExpenseTaxList;
		tbgLossExpenseTax.render("lossExpenseTaxTable");
		
	
	function setFieldValues(rec){
		try{
			objGICLS106.lossTaxId = (rec == null ? "" : rec.lossTaxId);
			$("txtGlAcctCategory").value = (rec == null ? "" : rec.glAcctCategory);
			$("txtGlControlAcct").value = (rec == null ? "" : lpad(rec.glControlAcct,2,0));
			$("txtGlSubAcct1").value = (rec == null ? "" : lpad(rec.glSubAcct1,2,0));
			$("txtGlSubAcct2").value = (rec == null ? "" : lpad(rec.glSubAcct2,2,0));
			$("txtGlSubAcct3").value = (rec == null ? "" : lpad(rec.glSubAcct3,2,0));
			$("txtGlSubAcct4").value = (rec == null ? "" : lpad(rec.glSubAcct4,2,0));
			$("txtGlSubAcct5").value = (rec == null ? "" : lpad(rec.glSubAcct5,2,0));
			$("txtGlSubAcct6").value = (rec == null ? "" : lpad(rec.glSubAcct6,2,0));
			$("txtGlSubAcct7").value = (rec == null ? "" : lpad(rec.glSubAcct7,2,0));
			$("txtSlTypeCd").value = (rec == null ? "" : rec.slTypeCd);
			$("txtSlTypeName").value = (rec == null ? "" : unescapeHTML2(rec.slTypeName));
			$("txtAcctName").value = (rec == null ? "" : unescapeHTML2(rec.glAcctName));
			
			$("txtTaxCd").value = (rec == null ? "" : lpad(rec.taxCd,5,0));
			$("txtTaxRate").value = (rec == null ? "" : unescapeHTML2(formatToNthDecimal(rec.taxRate,9)));
			$("txtTaxName").value = (rec == null ? "" : unescapeHTML2(rec.taxName));
			$("txtStartDate").value = rec == null ? "" : (rec.startDate == null ? "" : dateFormat(rec.startDate, "mm-dd-yyyy"));
			$("txtEndDate").value = (rec == null ? "" : (rec.endDate == null ? "" : dateFormat(rec.endDate, "mm-dd-yyyy")));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? disableDate("imgStartDate") : enableDate("imgStartDate");
			rec == null ? disableDate("imgEndDate") : enableDate("imgEndDate");
			$("txtRemarks").readOnly = (rec == null ? true : false);
			$("txtTaxRate").readOnly = (rec == null ? true : false);
			
			rec == null ? disableButton("btnAdd") : enableButton("btnAdd");
			if(rec == null){
				disableButton("btnLineLossExp");
				disableButton("btnCopyTax");
				disableButton("btnCopyTaxLine");
				disableButton("btnTaxRateHistory");
			} else {
				enableButton("btnLineLossExp");
				enableButton("btnCopyTax");
				onCopyTaxLineBtn();
				enableButton("btnTaxRateHistory");
			}
			objCurrLossExpenseTax = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function onCopyTaxLineBtn(){
		if($F("txtTaxType") != "W"){
			new Ajax.Request(contextPath+"/GIISLossTaxesController", {
				method: "POST",
				parameters : {
								action : "checkCopyTaxLineBtn",
								lossTaxId : objGICLS106.lossTaxId,
								issCd	: unescapeHTML2($F("txtBranch"))
							},
				onCreate : showNotice("Processing, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						var obj = JSON.parse(response.responseText);
						if(obj.output == "exist"){
							enableButton("btnCopyTaxLine");
						} else {
							disableButton("btnCopyTaxLine");
						}
					}
				}
			});
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.taxCd = ($F("txtTaxCd"));
			obj.taxName = escapeHTML2($F("txtTaxName"));
			obj.taxRate = $F("txtTaxRate");
			obj.startDate = $F("txtStartDate");
			obj.endDate = $F("txtEndDate");
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.userId = escapeHTML2(userId);
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGicls106;
			var dept = setRec(objCurrLossExpenseTax);
			if($F("btnAdd") == "Add"){
				tbgLossExpenseTax.addBottomRow(dept);
			} else {
				tbgLossExpenseTax.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgLossExpenseTax.keys.removeFocus(tbgLossExpenseTax.keys._nCurrentFocus, true);
			tbgLossExpenseTax.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	

	function exitPage() {
		goToModule("/GIISUserController?action=goToClaims",
				"Claims Main", null);
	}

	function cancelGicls106() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						objGICLS106.exitPage = exitPage;
						saveGicls106();
					}, function() {
						goToModule(
								"/GIISUserController?action=goToClaims",
								"Claims Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToClaims",
					"Claims Main", null);
		}
	}

	$("editRemarks").observe(
			"click",
			function() {
				showOverlayEditor("txtRemarks", 4000, $("txtRemarks")
						.hasAttribute("readonly"));
			});

	observeSaveForm("btnSave", saveGicls106);
	$("btnCancel").observe("click", cancelGicls106);
	$("btnAdd").observe("click", function(){
		if(checkAllRequiredFieldsInDiv("lossExpenseFormDiv")){
			addRec();
		}
	});
	
	function showTaxTypeLOV(x){
		try{
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					  action : "getGicls106TaxTypeLOV",
					  search : x,
						page : 1
				},
				title: "List of Tax Types",
				width: 400,
				height: 400,
				columnModel: [
		 			{
						id : 'rvLowValue',
						title: 'Tax Type Code',
						width : '90px',
						align: 'left'
					},
					{
						id : 'rvMeaning',
						title: 'Tax Type Name',
					    width: '285px',
					    align: 'left'
					}
				],
				autoSelectOneRecord : true,
				filterText: nvl(escapeHTML2(x), "%"), 
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtTaxType").value = unescapeHTML2(row.rvLowValue);
						$("txtTaxTypeDesc").value = unescapeHTML2(row.rvMeaning);
						$("txtTaxType").setAttribute("lastValidValue",unescapeHTML2(row.rvLowValue));
						$("txtTaxTypeDesc").setAttribute("lastValidValue",unescapeHTML2(row.rvMeaning));
						enableToolbarButton("btnToolbarEnterQuery");
						enableToolbarButton("btnToolbarExecuteQuery");
					}
				},
				onCancel: function(){
					$("txtTaxType").focus();
					$("txtTaxType").value = $("txtTaxType").getAttribute("lastValidValue");
					$("txtTaxTypeDesc").value = $("txtTaxTypeDesc").getAttribute("lastValidValue");
		  		},
		  		onUndefinedRow: function(){
		  			$("txtTaxType").value = $("txtTaxType").getAttribute("lastValidValue");
		  			$("txtTaxTypeDesc").value = $("txtTaxTypeDesc").getAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtTaxType");
		  		}
			});
		}catch(e){
			showErrorMessage("showTaxTypeLOV",e);
		}
	}
	
	function showBranchLOV(x){
		try{
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					  action : "getGicls106BranchLOV",
					  search : x,
						page : 1
				},
				title: "List of Branches",
				width: 400,
				height: 400,
				columnModel: [
		 			{
						id : 'issCd',
						title: 'Iss Cd',
						width : '90px',
						align: 'left'
					},
					{
						id : 'issName',
						title: 'Iss Name',
					    width: '285px',
					    align: 'left'
					}
				],
				autoSelectOneRecord : true,
				filterText: nvl(escapeHTML2(x), "%"), 
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtBranch").value = unescapeHTML2(row.issCd);
						$("txtBranchDesc").value = unescapeHTML2(row.issName);
						enableToolbarButton("btnToolbarEnterQuery");
						enableToolbarButton("btnToolbarExecuteQuery");
						$("txtBranch").setAttribute("lastValidValue",unescapeHTML2(row.issCd));
						$("txtBranchDesc").setAttribute("lastValidValue",unescapeHTML2(row.issName));
					}
				},
				onCancel: function(){
					$("txtBranch").focus();
					$("txtBranch").value = $("txtBranch").getAttribute("lastValidValue");
					$("txtBranchDesc").value = $("txtBranchDesc").getAttribute("lastValidValue");
		  		},
		  		onUndefinedRow: function(){
		  			$("txtBranch").value = $("txtBranch").getAttribute("lastValidValue");
					$("txtBranchDesc").value = $("txtBranchDesc").getAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtBranch");
		  		}
			});
		}catch(e){
			showErrorMessage("showBranchLOV",e);
		}
	}
	
	$("searchTaxType").observe("click",function(){
		showTaxTypeLOV("%");
	});
	
	$("searchBranch").observe("click",function(){
		showBranchLOV("%");
	});
	
	function validateTax(){
		new Ajax.Request(contextPath+"/GIISLossTaxesController", {
			method: "POST",
			parameters: {
				action: "validateGicls106Tax",
				taxCd: $F("txtTaxType")
			},
			onCreate: showNotice("Please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(nvl(obj.taxCd, "") == ""){
						showTaxTypeLOV($("txtTaxType").value);
					} else if(obj.taxCd == "manyrows"){
						showTaxTypeLOV($("txtTaxType").value);
					}
					else{
						$("txtTaxType").value = obj.taxCd;
						$("txtTaxTypeDesc").value = obj.taxName;
						$("txtTaxType").setAttribute("lastValidValue",unescapeHTML2(obj.taxCd));
						$("txtTaxTypeDesc").setAttribute("lastValidValue",unescapeHTML2(obj.taxName));
						enableToolbarButton("btnToolbarEnterQuery");
						enableToolbarButton("btnToolbarExecuteQuery");
					}
				}
			}
		});
	}
	
	function validateBranch(){
		new Ajax.Request(contextPath+"/GIISLossTaxesController", {
			method: "POST",
			parameters: {
				action: "validateGicls106Branch",
				issCd: $F("txtBranch")
			},
			onCreate: showNotice("Please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(nvl(obj.issCd, "") == ""){
						showBranchLOV($("txtBranch").value);
					} else if(obj.issCd == "manyrows"){
						showBranchLOV($("txtBranch").value);
					} else{
						$("txtBranch").value = unescapeHTML2(obj.issCd);
						$("txtBranchDesc").value = unescapeHTML2(obj.issName);
						$("txtBranch").setAttribute("lastValidValue",unescapeHTML2(obj.issCd));
						$("txtBranchDesc").setAttribute("lastValidValue",unescapeHTML2(obj.issName));
						enableToolbarButton("btnToolbarEnterQuery");
						enableToolbarButton("btnToolbarExecuteQuery");
					}
				}
			}
		});
	}
	
	$("txtTaxType").observe("change", function(){
		if($("txtTaxType").value != ""){
			validateTax();
		} else {
			disableToolbarButton("btnToolbarExecuteQuery");
			$("txtTaxTypeDesc").value = "";
			$("txtTaxType").setAttribute("lastValidValue", "");
			$("txtTaxTypeDesc").setAttribute("lastValidValue", "");
			if($("txtBranch").value == ""){
				disableToolbarButton("btnToolbarEnterQuery");
			}
		}
	});
	
	$("txtBranch").observe("change", function(){
		if($("txtBranch").value != ""){
			validateBranch();
		} else {
			disableToolbarButton("btnToolbarExecuteQuery");
			$("txtBranchDesc").value = "";
			$("txtBranch").setAttribute("lastValidValue", "");
			$("txtBranchDesc").setAttribute("lastValidValue", "");
			if($("txtTaxType").value == ""){
				disableToolbarButton("btnToolbarEnterQuery");
			}
		}
	});
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		if(checkAllRequiredFieldsInDiv("lossExpTaxDiv")){
			tbgLossExpenseTax.url = contextPath + "/GIISLossTaxesController?action=showGicls106&refresh=1&taxType="+$F("txtTaxType")+"&branchCd="+encodeURIComponent($F("txtBranch"));
			tbgLossExpenseTax._refreshList();
			disableSearch("searchTaxType");
			disableSearch("searchBranch");
			$("txtTaxType").readOnly = true;
			$("txtBranch").readOnly = true;
			disableToolbarButton("btnToolbarExecuteQuery");
		}
	});
	
	
	$("btnTaxRateHistory").observe("click",function(){
		if (changeTag == 1) {
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		} else {
			showTaxRateHistory();
		} 
	});
	
	function showTaxRateHistory() {
		try {
			overlayTaxRateHistory = Overlay.show(contextPath
					+ "/GIISLossTaxesController", {
				urlContent : true,
				urlParameters : {
					action : "showTaxRateHistory",
					ajax : "1",
					lossTaxId : objGICLS106.lossTaxId,
					taxCd : $("txtTaxCd").value,
					taxDesc : $("txtTaxName").value
					//recoveryId : $("hidRecoveryId").value
					},
				title : "Tax Rate History",
				 height: 430,
				 width: 703,
				draggable : true
			});
		} catch (e) {
			showErrorMessage("showTaxRateHistory", e);
		}
	}

	$("btnCopyTax").observe("click",function(){
		if (changeTag == 1) {
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		} else {
			showCopyTax();
		} 
	});
	
	function showCopyTax() {
		try {
			overlayCopyTax = Overlay.show(contextPath
					+ "/GIISLossTaxesController", {
				urlContent : true,
				urlParameters : {
					action : "showCopyTax",
					ajax : "1",
					issCd : $("txtBranch").value,
					taxType : $("txtTaxType").value,
					taxCd : objCurrLossExpenseTax.taxCd,
					taxName: objCurrLossExpenseTax.taxName,
					taxRate: objCurrLossExpenseTax.taxRate,
					startDate: objCurrLossExpenseTax.startDate,
					endDate: objCurrLossExpenseTax.endDate,
					glAcctId: objCurrLossExpenseTax.glAcctId,
					slTypeCd: objCurrLossExpenseTax.slTypeCd,
				    remarks: objCurrLossExpenseTax.remarks,
					},
				title : "Copy Tax",
				 height: 380,
				 width: 383,
				draggable : true
			});
		} catch (e) {
			showErrorMessage("showCopyTax", e);
		}
	}
	$("btnLineLossExp").observe("click",function(){
		if (changeTag == 1) {
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		} else {
			showLineLossExp();
		} 
	});
	function showLineLossExp() {
		try {
			overlayLineLossExp = Overlay.show(contextPath
					+ "/GIISLossTaxesController", {
				urlContent : true,
				urlParameters : {
					action : "showLineLossExp",
					ajax : "1",
					lossTaxId : objCurrLossExpenseTax.lossTaxId,
					issCd : $("txtBranch").value
					},
				title : "Tax Rate per Line and Loss/Expense",
				 height: 550,
				 width: 467,
				draggable : true
			});
		} catch (e) {
			showErrorMessage("showLineLossExp", e);
		}
	}
	
	observeSaveForm("btnToolbarSave", saveGicls106);
	
	$("btnToolbarExit").observe("click", function(){
		cancelGicls106();
	});
	
	
	$("btnCopyTaxLine").observe("click",function(){
		if (changeTag == 1) {
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		} else {
			showCopyTaxLine();
		} 
	});
	
	function showCopyTaxLine() {
		try {
			overlayCopyTax = Overlay.show(contextPath
					+ "/GIISLossTaxesController", {
				urlContent : true,
				urlParameters : {
					action : "showCopyTaxLine",
					ajax : "1",
					issCd : $("txtBranch").value,
					taxType : $("txtTaxType").value,
					taxCd : objCurrLossExpenseTax.taxCd,
					taxName: objCurrLossExpenseTax.taxName,
					taxRate: objCurrLossExpenseTax.taxRate,
					startDate: objCurrLossExpenseTax.startDate,
					endDate: objCurrLossExpenseTax.endDate,
					glAcctId: objCurrLossExpenseTax.glAcctId,
					slTypeCd: objCurrLossExpenseTax.slTypeCd,
				    remarks: objCurrLossExpenseTax.remarks,
					},
				title : "Copy Tax and Line-Loss/Expense",
				 height: 380,
				 width: 383,
				draggable : true
			});
		} catch (e) {
			showErrorMessage("showCopyTaxLine", e);
		}
	}
	
	$("btnToolbarEnterQuery").observe("click", function() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						objGICLS106.exitPage = showGicls106;
						saveGicls106();
					}, function() {
						showGicls106();
					}, "");
		} else {
			showGicls106();
		}
	});
	
	$("txtEndDate").observe("focus", function(){
		var toDate = $F("txtEndDate") != "" ? new Date($F("txtEndDate").replace(/-/g,"/")) :"";
		var fromDate = $F("txtStartDate") != "" ? new Date($F("txtStartDate").replace(/-/g,"/")) :"";
		if (toDate < fromDate && toDate != ""){
			customShowMessageBox("Start Date should not be later than End Date.", "I", "txtEndDate");
			$("txtEndDate").clear();
			return false;
		}
	});
	
	$("txtStartDate").observe("focus", function(){
		var toDate = $F("txtEndDate") != "" ? new Date($F("txtEndDate").replace(/-/g,"/")) :"";
		var fromDate = $F("txtStartDate") != "" ? new Date($F("txtStartDate").replace(/-/g,"/")) :"";
		if (toDate < fromDate && toDate != ""){
			customShowMessageBox("Start Date should not be later than End Date.", "I", "txtStartDate");
			$("txtStartDate").clear();
			return false;
		}
	});
</script>