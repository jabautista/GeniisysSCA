<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="gicls058MainDiv" name="gicls058MainDiv" style="">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Motor Car Replacement Part Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="gicls058" name="gicls058">		
		<div class="sectionDiv">
			<div style="" id="headerParamsDiv">
				<table cellspacing="2" border="0" style="margin: 10px; margin-left: 50px;">	 			
					<tr>
						<td class="rightAligned" style="width: 80px;">Car Company</td>
						<td class="leftAligned" colspan="">
							<span class="lovSpan required"  style="float: left; width: 115px; margin-right: 3px; margin-top: 2px; height: 21px;">
								<input class="rightAligned required integerNoNegativeUnformattedNoComma" type="text" id="txtCarCompanyCd" name="txtCarCompanyCd" style="width: 90px; float: left; border: none; height: 15px; margin: 0;" maxlength="6" tabindex="101" lastValidValue="" ignoreDelKey="1"/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgCarCompanyLOV" name="imgCarCompanyLOV" alt="Go" style="float: right;" tabindex="102"/>
							</span>
							<input id="txtCarCompany" name="txtCarCompany" type="text" style="width: 300px;" value="" readonly="readonly" tabindex="103"/>
						</td>
						<td class="rightAligned" style="width: 130px;">Model Year</td>
						<td class="leftAligned" colspan="">
							<span class="lovSpan" id="modelYearSpan" style="float: left; width: 125px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="" readonly="readonly" type="text" id="txtModelYearLov" name="txtModelYearLov" style="width: 100px; float: left; border: none; height: 15px; margin: 0;" maxlength="4" tabindex="107" lastValidValue="" ignoreDelKey="1"/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgModelYearLOV" name="imgModelYearLOV" alt="Go" style="float: right;" tabindex="108"/>
							</span>
						</td>						
					</tr>
					<tr>
						<td class="rightAligned" style="width: 0px;" id="">Make</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan required" style="float: left; width: 115px; margin-right: 3px; margin-top: 2px; height: 21px;">
								<input class="rightAligned required integerNoNegativeUnformattedNoComma" type="text" id="txtMakeCd" name="txtMakeCd" style="width: 90px; float: left; border: none; height: 15px; margin: 0;" maxlength="12" tabindex="104" lastValidValue="" ignoreDelKey="1"/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgMakeLOV" name="imgMakeLOV" alt="Go" style="float: right;" tabindex="105"/>
							</span>
							<input id="txtMake" name="txtMake" type="text" style="width: 300px;" value="" readonly="readonly" tabindex="106"/>
						</td>
					</tr>
				</table>			
			</div>			
		</div>
		<div id="gicls058SubDiv" name="gicls058SubDiv">		
			<div class="sectionDiv">
				<div id="motorPartCostDiv" style="padding-top: 10px;">
					<div id="motorPartCostTable" style="height: 340px; margin-left: 10px;"></div>
				</div>
				<div align="" id="motorPartCostFormDiv" style="margin-left: 75px;">
					<table style="margin-top: 5px;">
						<tr>
							<td width="146px;" class="rightAligned">Original Amount</td>
							<td class="leftAligned"><input id="txtOrigAmount" type="text" class="required rightAligned applyDecimalRegExp" customLabel="Original Amount" max="999999999999.99" min="0.00" regexppatt="pDeci1202" maxlength="17" style="width: 195px;" tabindex="201" readonly="readonly" ></td>
							<td width="" class="rightAligned">Original Effectivity Date</td>
							<td class="leftAligned">
								<div style="float: left; width: 205px; height: 21px;" class="withIconDiv required" id="asOfDiv">
									<input type="text" id="txtEffDateOrg" name="txtEffDateOrg" removeStyle="true" class="withIcon required" readonly="readonly" style="width: 180px;" tabindex="202" ignoreDelKey="1"/>
									<img id="imgEffDateOrg" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Original Effectivity Date" style="margin-top: 2px;" tabindex="203"/>
								</div>
							</td>
						</tr>
						<tr>	
							<td width="146px;" class="rightAligned">Surplus Amount</td>
							<td class="leftAligned"><input id="txtSurpAmount" type="text" class="required rightAligned applyDecimalRegExp" customLabel="Surplus Amount" max="999999999999.99" min="0.00" regexppatt="pDeci1202" maxlength="17" style="width: 195px;" tabindex="204" readonly="readonly"></td>
							<td class="rightAligned">Surplus Effectivity Date</td>
							<td class="leftAligned">
								<div style="float: left; width: 205px; height: 21px;" class="withIconDiv required" id="asOfDiv">
									<input type="text" id="txtEffDateSurp" name="txtEffDateSurp" removeStyle="true" class="withIcon required" readonly="readonly" style="width: 180px;" tabindex="205" ignoreDelKey="1"/>
									<img id="imgEffDateSurp" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Surplus Effectivity Date" style="margin-top: 2px;" tabindex="206"/>
								</div>
							</td>
						</tr>
						<tr>
							<td class="rightAligned">Loss Expense Code</td>
							<td class="leftAligned">
								<input id="txtLossExpCode" type="text" class="required" style="width: 195px; text-align: right;" tabindex="207" readonly="readonly" ignoreDelKey="1"/>
							</td>
							<td width="146px;" class="rightAligned">Model Year</td>
							<td class="leftAligned"><input id="txtModelYear" type="text" class="required" style="width: 200px;" readonly="readonly" tabindex="208" maxlength="4" ></td>
						</tr>	
						<tr>
							<td width="" class="rightAligned">Loss Expense Description</td>
							<td class="leftAligned" colspan="3">
								<input id="txtLossExpDesc" type="text" style="width: 560px;" tabindex="209" readonly="readonly">
							</td>
						</tr>		
						<tr>
							<td width="" class="rightAligned">Remarks</td>
							<td class="leftAligned" colspan="3">
								<div id="remarksDiv" name="remarksDiv" style="float: left; width: 565px; border: 1px solid gray; height: 22px;">
									<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="210"></textarea>
									<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="211"/>
								</div>
							</td>
						</tr>
						<tr>
							<td class="rightAligned">User ID</td>
							<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 195px;" readonly="readonly" tabindex="212"></td>
							<td width="146px;" class="rightAligned">Last Update</td>
							<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 198px;" readonly="readonly" tabindex="213"></td>
						</tr>			
					</table>
				</div>
				<div style="margin: 10px;" align="center">
					<table>
						<tr>
							<td>
								<input type="button" class="button" id="btnUpdate" value="Update" tabindex="301">
							</td>
							<td>
								<input type="button" class="button" id="btnDelete" value="Delete" tabindex="302">
							</td>
						</tr>
					</table>
				</div>
				<div style="margin: 10px; padding: 10px; border-top: 1px solid #E0E0E0; margin-bottom: 0;" align="center">
					<input type="button" class="button" id="btnViewHistory" value="View History" style="width: 150px;" tabindex="303">
				</div>
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="401">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="402">
</div>
<script type="text/javascript">
	setModuleId("GICLS058");
	setDocumentTitle("Motor Car Replacement Part Maintenance");
	initializeAll();
	initializeAccordion();
	initializeAllMoneyFields();
	makeInputFieldUpperCase();
	changeTag = 0;
	var rowIndex = -1;
	var sysDate = new Date();
	objCurrPartCostId = "";
	
	function saveGicls058() {
		if (changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgMcPartCost.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgMcPartCost.geniisysRows);
		new Ajax.Request(contextPath + "/GICLMcPartCostController", {
			method : "POST",
			parameters : {
				action : "saveGicls058",
				setRows : prepareJsonAsParameter(setRows),
				delRows : prepareJsonAsParameter(delRows)
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete : function(response) {
				hideNotice();
				if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)) {
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function() {
						if (objGICLS058.exitPage != null) {
							objGICLS058.exitPage();
							objGICLS058.exitPage = null;
						} else {
							tbgMcPartCost.url = contextPath + "/GICLMcPartCostController?action=showGicls058&refresh=1&carCompanyCd=" + $F("txtCarCompanyCd") + "&makeCd=" + $F("txtMakeCd") + "&modelYear=" + $F("txtModelYearLov");
							tbgMcPartCost._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}

	observeReloadForm("reloadForm", showGICLS058);

	objGICLS058 = {};
	var objMcPartCost = null;
	objGICLS058.mcPartCostList = JSON.parse('${jsonMcPartCostList}');
	objGICLS058.exitPage = null;

	var motorPartCostTable = {
			url : contextPath + "/GICLMcPartCostController?action=showGicls058&refresh=1",
			options : {
				width : '900px',
				hideColumnChildTitle : true,
				pager : {},
				onCellFocus : function(element, value, x, y, id) {
					rowIndex = y;
					objMcPartCost = tbgMcPartCost.geniisysRows[y];
					objCurrPartCostId = tbgMcPartCost.geniisysRows[y].partCostId;
					setFieldValues(objMcPartCost);
					$("txtOrigAmount").focus();
					if ($F("txtModelYearLov") != "") {
						disableInputField("txtModelYear");
					}else {
						enableInputField("txtModelYear");
					}
					if ($F("txtEffDateOrg") != "") {
						enableButton("btnDelete");
					}else{
						disableButton("btnDelete");
					}
					if (tbgMcPartCost.geniisysRows[y].partCostId != null) {
						enableButton("btnViewHistory");
					}else {
						disableButton("btnViewHistory");
					}
					if (tbgMcPartCost.geniisysRows[y].modelYear == null) {
						$("txtModelYear").value = $F("txtModelYearLov");
					}
					tbgMcPartCost.keys.removeFocus(tbgMcPartCost.keys._nCurrentFocus, true);
					tbgMcPartCost.keys.releaseKeys();
				},
				onRemoveRowFocus : function() {
					rowIndex = -1;
					setFieldValues(null);
					tbgMcPartCost.keys.removeFocus(tbgMcPartCost.keys._nCurrentFocus, true);
					tbgMcPartCost.keys.releaseKeys();
					$("txtOrigAmount").focus();
				},
				toolbar : {
					elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
					onFilter : function() {
						rowIndex = -1;
						setFieldValues(null);
						tbgMcPartCost.keys.removeFocus(tbgMcPartCost.keys._nCurrentFocus, true);
						tbgMcPartCost.keys.releaseKeys();
					}
				},
				beforeSort : function() {
					if (changeTag == 1) {
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function() {
							$("btnSave").focus();
						});
						return false;
					}
				},
				onSort : function() {
					rowIndex = -1;
					setFieldValues(null);
					tbgMcPartCost.keys.removeFocus(tbgMcPartCost.keys._nCurrentFocus, true);
					tbgMcPartCost.keys.releaseKeys();
				},
				onRefresh : function() {
					rowIndex = -1;
					setFieldValues(null);
					tbgMcPartCost.keys.removeFocus(tbgMcPartCost.keys._nCurrentFocus, true);
					tbgMcPartCost.keys.releaseKeys();
				},
				prePager : function() {
					if (changeTag == 1) {
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function() {
							$("btnSave").focus();
						});
						return false;
					}
					rowIndex = -1;
					setFieldValues(null);
					tbgMcPartCost.keys.removeFocus(tbgMcPartCost.keys._nCurrentFocus, true);
					tbgMcPartCost.keys.releaseKeys();
				},
				checkChanges : function() {
					return (changeTag == 1 ? true : false);
				},
				masterDetailRequireSaving : function() {
					return (changeTag == 1 ? true : false);
				},
				masterDetailValidation : function() {
					return (changeTag == 1 ? true : false);
				},
				masterDetail : function() {
					return (changeTag == 1 ? true : false);
				},
				masterDetailSaveFunc : function() {
					return (changeTag == 1 ? true : false);
				},
				masterDetailNoFunc : function() {
					return (changeTag == 1 ? true : false);
				}
			},
			columnModel : [ 
				{ 						 // this column will only use for deletion
					id : 'recordStatus', // 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
					width : '0',
					visible : false
				}, 
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},
				{
					id : "lossExpCd lossExpDesc",
					title : "Part",
					align : 'left',
					titleAlign : 'left',
					width : '270px',
					children :[
						{	id: 'lossExpCd',	
							title : 'Loss Exp Cd',
							filterOption : true,
							width: 100,							
							sortable: false
						},
						{	id: 'lossExpDesc',
							title : 'Loss Exp Desc',
							filterOption : true,
							width: 170,
							sortable: false
						}
					]
				},  
				{
					id : "effDateOrg",
					title : "Original Effectivity Date",
					filterOption : true,
					align : 'center',
					titleAlign : 'center',
					width : '150px',
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
					id : "origAmt",
					title : "Original Amount",
					filterOption : true,
					filterOptionType : 'numberNoNegative',
					geniisysClass : 'money',
					align : 'right',
					titleAlign : 'right',
					width : '145px'
				}, 
				{
					id : "effDateSurp",
					title : "Surplus Effectivity Date",
					filterOption : true,
					align : 'center',
					titleAlign : 'center',
					width : '150px',
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
					id : "surpAmt",
					title : "Surplus Amount",
					filterOption : true,
					filterOptionType : 'numberNoNegative',
					geniisysClass : 'money',
					align : 'right',
					titleAlign : 'right',
					width : '145px'
				}, 
				{
					id : 'userId',
					width : '0',
					visible : false
				}, 
				{
					id : 'lastUpdate',
					width : '0',
					visible : false
				} 
			],
			rows :objGICLS058.mcPartCostList.rows
		};
		
		tbgMcPartCost = new MyTableGrid(motorPartCostTable);
	 	tbgMcPartCost.pager = objGICLS058.mcPartCostList;
		tbgMcPartCost.render("motorPartCostTable");

	function setFieldValues(rec) {
		try {
			$("txtLossExpCode").value 	= (rec == null ? "" : unescapeHTML2(rec.lossExpCd));
			$("txtLossExpDesc").value 	= (rec == null ? "" : unescapeHTML2(rec.lossExpDesc));
			$("txtEffDateOrg").value 	= (rec == null ? "" : rec.effDateOrg);
			$("txtOrigAmount").value 	= (rec == null ? "" : formatCurrency(rec.origAmt));
			$("txtEffDateSurp").value 	= (rec == null ? "" : rec.effDateSurp);
			$("txtSurpAmount").value 	= (rec == null ? "" : formatCurrency(rec.surpAmt));
			$("txtUserId").value 		= (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value 	= (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value 		= (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("txtModelYear").value     = (rec == null ? "" : unescapeHTML2(rec.modelYear));
			
			rec == null ? disableButton("btnViewHistory") : disableButton("btnViewHistory");
			rec == null ? disableButton("btnUpdate") : enableButton("btnUpdate");
			rec == null ? disableButton("btnDelete") : disableButton("btnDelete");
			rec == null ? disableInputField("txtOrigAmount") : enableInputField("txtOrigAmount");
			rec == null ? disableInputField("txtSurpAmount") : enableInputField("txtSurpAmount");
			rec == null ? disableInputField("txtRemarks") : enableInputField("txtRemarks");
			rec == null ? $("editRemarks").disabled = false : $("editRemarks").disabled = true;
			objMcPartCost = rec;
		} catch (e) {
			showErrorMessage("setFieldValues", e);
		}
	}

	function setRec(rec) {
		try {
			var obj = (rec == null ? {} : rec);
			obj.partCostId   = objCurrPartCostId;
			obj.modelYear    = escapeHTML2($F("txtModelYearLov"));
			obj.carCompanyCd = $F("txtCarCompanyCd");
			obj.lossExpCd	 = escapeHTML2($F("txtLossExpCode"));
			obj.makeCd	     = $F("txtMakeCd");
			obj.effDateOrg   = $F("txtEffDateOrg");
			obj.effDateSurp  = $F("txtEffDateSurp");
			obj.origAmt		 = $F("txtOrigAmount");
			obj.surpAmt		 = $F("txtSurpAmount");
			obj.remarks 	 = escapeHTML2($F("txtRemarks"));
			obj.userId 		 = userId;
			var lastUpdate   = new Date();
			obj.lastUpdate 	 = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch (e) {
			showErrorMessage("setRec", e);
		}
	}
	
	function delRec(rec) {
		try {
			var obj = (rec == null ? {} : rec);
			obj.partCostId  = objCurrPartCostId;
			obj.modelYear   = $F("txtModelYearLov");
			obj.carCompanyCd = $F("txtCarCompanyCd");
			obj.lossExpCd	= $F("txtLossExpCode");
			obj.makeCd	    = $F("txtMakeCd");
			obj.effDateOrg  = "";
			obj.effDateSurp = "";
			obj.origAmt		= "";
			obj.surpAmt		= "";
			obj.remarks 	= "";
			obj.userId 		= userId;
			obj.lastUpdate 	= "";
			
			return obj;
		} catch (e) {
			showErrorMessage("setRec", e);
		}
	}

	function addRec() {
		try {
			if ($("txtModelYearLov").value == "") {
				$("txtModelYearLov").value = $("txtModelYear").value;
			}
			changeTagFunc = saveGicls058;
			var dept = setRec(objMcPartCost);
			tbgMcPartCost.updateVisibleRowOnly(dept, rowIndex, false);
			changeTag = 1;
			setFieldValues(null);
			tbgMcPartCost.keys.removeFocus(tbgMcPartCost.keys._nCurrentFocus, true);
			tbgMcPartCost.keys.releaseKeys();
		} catch (e) {
			showErrorMessage("addRec", e);
		}
	}

	function valAddRec() {
		try {
			if (checkAllRequiredFieldsInDiv("gicls058SubDiv")) {
				new Ajax.Request(contextPath + "/GICLMcPartCostController", {
					parameters : {
						action : "valAddRec",
						carCompanyCd : $("txtCarCompanyCd").value,
						makeCd : $("txtMakeCd").value,
						modelYear : $F("txtModelYear")
					},
					onCreate : showNotice("Processing, please wait..."),
					onComplete : function(response) {
						hideNotice();
						if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)) {
							addRec();
						}
					}
				});
			}
		} catch (e) {
			showErrorMessage("valAddRec", e);
		}
	}

	function deleteRec() {
		changeTagFunc = saveGicls058;
		var dept = delRec(objMcPartCost);
		tbgMcPartCost.updateVisibleRowOnly(dept, rowIndex, false);
		objMcPartCost.recordStatus = -1;
		changeTag = 1;
		setFieldValues(null);
	}

	function exitPage() {
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", null);
	}

	function cancelGicls058() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function() {
				objGICLS058.exitPage = exitPage;
				saveGicls058();
			}, function() {
				goToModule("/GIISUserController?action=goToClaims", "Claims Main", null);
			}, "");
		} else {
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", null);
		}
	}

	function showCarCompanyLOV(search) {
		try {
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getGicls058CarCompanyLOV",
					search : search,
					page: 1
				},
				title : "List of Car Companies",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "carCompanyCd",
					title : "Car Company Code",
					align : 'right',
					titleAlign : 'right',
					width : '120px'
				}, {
					id : "carCompany",
					title : "Car Company",
					width : '345px'
				} ],
				draggable : true,
				autoSelectOneRecord : true,
				filterText : search,
				onSelect : function(row) {
					if (row != null || row != undefined) {
						$("txtCarCompanyCd").value = row.carCompanyCd;
						$("txtCarCompanyCd").setAttribute("lastValidValue", row.carCompanyCd);
						$("txtCarCompany").value = unescapeHTML2(row.carCompany);
						$("txtCarCompany").setAttribute("lastValidValue", unescapeHTML2(row.carCompany));
						enableToolbarButton("btnToolbarExecuteQuery");
						enableToolbarButton("btnToolbarEnterQuery");
						if ($F("txtMakeCd") != "") {
							$("txtMakeCd").clear();
							$("txtMake").clear();
							$("txtMakeCd").setAttribute("lastValidValue", "");
							$("txtMake").setAttribute("lastValidValue", "");
						}
						if ($F("txtModelYearLov") != "") {
							$("txtModelYearLov").clear();
							$("txtModelYearLov").setAttribute("lastValidValue", "");
							disableInputField("txtModelYearLov");
							disableSearch("imgModelYearLOV");
						}
					}
				},
				onCancel : function() {
					$("txtCarCompanyCd").focus();
					$("txtCarCompanyCd").value = $("txtCarCompanyCd").readAttribute("lastValidValue");
					$("txtCarCompany").value = $("txtCarCompany").readAttribute("lastValidValue");
				},
				onUndefinedRow : function() {
					$("txtCarCompanyCd").value = $("txtCarCompanyCd").readAttribute("lastValidValue");
					$("txtCarCompany").value = $("txtCarCompany").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtCarCompanyCd");
				}
			});
		} catch (e) {
			showErrorMessage("showCarCompanyLOV", e);
		}
	}

	function showMakeLOV(search) {
		try {
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getGicls058MakeLOV",
					search : search,
					carCompanyCd : $F("txtCarCompanyCd"),
					page: 1
				},
				title : "List of Car Makes",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "makeCd",
					title : "Make Code",
					align : 'right',
					titleAlign : 'right',
					width : '120px'
				}, {
					id : "make",
					title : "Make",
					width : '345px'
				} ],
				draggable : true,
				autoSelectOneRecord : true,
				filterText : search,
				onSelect : function(row) {
					if (row != null || row != undefined) {
						$("txtMakeCd").value = row.makeCd;
						$("txtMakeCd").setAttribute("lastValidValue", row.makeCd);
						$("txtMake").value = unescapeHTML2(row.make);
						$("txtMake").setAttribute("lastValidValue", unescapeHTML2(row.make));
						enableToolbarButton("btnToolbarExecuteQuery");
						enableToolbarButton("btnToolbarEnterQuery");
						if ($F("txtCarCompanyCd") != "") {
							valModelYear();
							$("txtModelYearLov").focus();
						}
						if ($F("txtModelYearLov") != "") {
							$("txtModelYearLov").clear();
							$("txtModelYearLov").setAttribute("lastValidValue", "");
							disableInputField("txtModelYearLov");
							disableSearch("imgModelYearLOV");
						}
					}
				},
				onCancel : function() {
					$("txtMakeCd").focus();
					$("txtMakeCd").value = $("txtMakeCd").readAttribute("lastValidValue");
					$("txtMake").value = $("txtMake").readAttribute("lastValidValue");
				},
				onUndefinedRow : function() {
					$("txtMakeCd").value = $("txtMakeCd").readAttribute("lastValidValue");
					$("txtMake").value = $("txtMake").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtMakeCd");
				}
			});
		} catch (e) {
			showErrorMessage("showMakeLOV", e);
		}
	}
	
	function showModelYearLOV(search) {
		try {
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getGicls058ModelYearLOV",
					search : search,
					carCompanyCd : $("txtCarCompanyCd").value,
					makeCd : $("txtMakeCd").value,
					page: 1
				},
				title : "List of Model Years",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "modelYear",
					title : "Model Year",
					width : '465px'
				}],
				draggable : true,
				autoSelectOneRecord : true,
				filterText : search,
				onSelect : function(row) {
					if (row != null || row != undefined) {
						$("txtModelYearLov").value = row.modelYear;
						$("txtModelYearLov").setAttribute("lastValidValue", row.modelYear);
						enableToolbarButton("btnToolbarExecuteQuery");
						enableToolbarButton("btnToolbarEnterQuery");
					}
				},
				onCancel : function() {
					$("txtModelYearLov").focus();
					$("txtModelYearLov").value = $("txtModelYearLov").readAttribute("lastValidValue");
				},
				onUndefinedRow : function() {
					$("txtModelYearLov").value = $("txtModelYearLov").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtModelYearLov");
				}
			});
		} catch (e) {
			showErrorMessage("showModelYearLOV", e);
		}
	}
	
	function valModelYear() {
		try {
			new Ajax.Request(contextPath + "/GICLMcPartCostController", {
				parameters : {
					action : "valModelYear",
					carCompanyCd : $("txtCarCompanyCd").value,
					makeCd : $("txtMakeCd").value
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response) {
					hideNotice();
					if (checkErrorOnResponse(response)) {
						if (response.responseText == "Y") {
							enableSearch("imgModelYearLOV");
							enableInputField("txtModelYearLov");
							//$("txtModelYearLov").setAttribute("class","required");
							//$("modelYearSpan").setAttribute("class","lovSpan required");
						}else {
							$("txtModelYearLov").clear();
							$("txtModelYearLov").setAttribute("lastValidValue", "");
							disableInputField("txtModelYearLov");
							disableSearch("imgModelYearLOV");
						}
					}
				}
			});
		} catch (e) {
			showErrorMessage("valDeleteRec", e);
		}
	}

	function toggleMcPartCostFields(enable) {
		try {
			if (enable) {
				$("txtCarCompanyCd").readOnly = true;
				$("txtCarCompany").readOnly = true;
				$("txtMakeCd").readOnly = true;
				$("txtMake").readOnly = true;
				$("txtModelYearLov").readOnly = true;
				disableSearch("imgCarCompanyLOV");
				disableSearch("imgMakeLOV");
				disableSearch("imgModelYearLOV");
				disableButton("btnViewHistory");
			} else {
				$("txtCarCompanyCd").readOnly = false;
				$("txtMakeCd").readOnly = false;
				enableSearch("imgCarCompanyLOV");
				enableSearch("imgMakeLOV");
				disableButton("btnUpdate");
				disableButton("btnDelete");
				disableButton("btnViewHistory");
				disableSearch("imgModelYearLOV");
				disableInputField("txtModelYearLov");
			}
		} catch (e) {
			showErrorMessage("toggleMcPartCostFields", e);
		}
	}

	function enterQuery() {
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		tbgMcPartCost.url = contextPath + "/GICLMcPartCostController?action=showGicls058&refresh=1";
		tbgMcPartCost._refreshList();
		$("txtCarCompanyCd").clear();
		$("txtCarCompany").clear();
		$("txtMakeCd").clear();
		$("txtMake").clear();
		$("txtModelYear").clear();
		toggleMcPartCostFields(false);
		$("txtCarCompanyCd").focus();
		$("txtCarCompanyCd").setAttribute("lastValidValue", "");
		$("txtCarCompany").setAttribute("lastValidValue", "");
		$("txtMakeCd").setAttribute("lastValidValue", "");
		$("txtMake").setAttribute("lastValidValue", "");
		$("txtModelYearLov").setAttribute("class","");
		$("modelYearSpan").setAttribute("class","lovSpan");
		$("modelYearSpan").setStyle({backgroundColor: ''});
		$("txtModelYearLov").clear();
		$("txtModelYearLov").setAttribute("lastValidValue", "");
		$("txtModelYear").clear();
		changeTag = 0;
	}
	
	function showOverlay(action, title, error){
		try{
			overlayHistory = Overlay.show(contextPath+"/GICLMcPartCostController?", {
				urlContent: true,
				urlParameters: {
					action : action,
					partCostId : objCurrPartCostId
				},
			    title: title,
			    height : '420px',
				width : '805px',
			    draggable: true
			});
		}catch(e){
			showErrorMessage(error, e);
		}		
	}

	$("imgCarCompanyLOV").observe("click", function() {
		showCarCompanyLOV("%");
	});

	$("txtCarCompanyCd").observe("change", function() {
		if (this.value != "") {
			showCarCompanyLOV( $("txtCarCompanyCd").value);
		} else {
			$("txtCarCompanyCd").value = "";
			$("txtCarCompanyCd").setAttribute("lastValidValue", "");
			$("txtCarCompany").value = "";
			$("txtCarCompany").setAttribute("lastValidValue", "");
			$("txtMakeCd").value = "";
			$("txtMakeCd").setAttribute("lastValidValue", "");
			$("txtMake").value = "";
			$("txtMake").setAttribute("lastValidValue", "");
			$("txtModelYearLov").value = "";
			$("txtModelYearLov").setAttribute("lastValidValue", "");
			disableToolbarButton("btnToolbarExecuteQuery");
			disableSearch("imgModelYearLOV");
		}
	});

	$("imgMakeLOV").observe("click", function() {
		showMakeLOV("%");
	});

	$("txtMakeCd").observe("change", function() {
		if (this.value != "") {
			showMakeLOV($("txtMakeCd").value);
		} else {
			$("txtMakeCd").value = "";
			$("txtMakeCd").setAttribute("lastValidValue", "");
			$("txtMake").value = "";
			$("txtMake").setAttribute("lastValidValue", "");
			$("txtModelYearLov").value = "";
			$("txtModelYearLov").setAttribute("lastValidValue", "");
			disableToolbarButton("btnToolbarExecuteQuery");
			disableSearch("imgModelYearLOV");
		}
	});

	$("imgModelYearLOV").observe("click", function() {
		showModelYearLOV("%");
	});

	$("txtModelYearLov").observe("change", function() {
		if (this.value != "") {
			showModelYearLOV($("txtModelYearLov").value);
		} else {
			$("txtModelYearLov").value = "";
			$("txtModelYearLov").setAttribute("lastValidValue", "");
			//disableToolbarButton("btnToolbarExecuteQuery");
		}
	});

	$("editRemarks").observe("click", function() {
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("txtOrigAmount").observe("change", function() {
		if (this.value != "") {
			$("txtEffDateOrg").value = dateFormat(sysDate, 'mm-dd-yyyy');
		} else {
			$("txtEffDateOrg").clear();
		}
	}); 

	$("txtSurpAmount").observe("change", function() {
		if (this.value != "") {
			formatCurrency($("txtSurpAmount"));
			$("txtEffDateSurp").value = dateFormat(sysDate, 'mm-dd-yyyy');
		} else {
			$("txtEffDateSurp").clear();
		}
	}); 

	$("btnToolbarEnterQuery").observe("click", function() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function() {
				objGICLS058.exitPage = enterQuery;
				saveGicls058();
			}, function() {
				enterQuery();
			}, "");
		} else {
			enterQuery();
		}
	});

	$("btnToolbarExecuteQuery").observe("click", function() {
		if (checkAllRequiredFieldsInDiv("headerParamsDiv")) {
			disableToolbarButton(this.id);
			enableToolbarButton("btnToolbarEnterQuery");
			tbgMcPartCost.url = contextPath + "/GICLMcPartCostController?action=showGicls058&refresh=1&carCompanyCd=" + $F("txtCarCompanyCd") + "&makeCd=" + $F("txtMakeCd") + "&modelYear=" + $F("txtModelYearLov");
			tbgMcPartCost._refreshList();
			toggleMcPartCostFields(true);
			if ($F("txtModelYearLov") != "") {
				$("txtModelYear").setAttribute("class","");
				$("txtModelYear").value = $("txtModelYearLov").value;
			}else {
				$("txtModelYear").setAttribute("class","required");
			}
		}
	});
	
	$("editRemarks").disabled = true;
	disableInputField("txtRemarks");
	disableDate("imgEffDateOrg");
	disableDate("imgEffDateSurp");
	disableButton("btnDelete");
	disableButton("btnUpdate");
	showToolbarButton("btnToolbarSave");
	hideToolbarButton("btnToolbarPrint");
	disableToolbarButton("btnToolbarEnterQuery");
	disableToolbarButton("btnToolbarExecuteQuery");

	observeSaveForm("btnSave", saveGicls058);
	observeSaveForm("btnToolbarSave", saveGicls058);
	$("btnCancel").observe("click", cancelGicls058);
	$("btnUpdate").observe("click", valAddRec);
	$("btnDelete").observe("click", deleteRec);

	$("btnToolbarExit").stopObserving("click");
	$("btnToolbarExit").observe("click", function() {
		fireEvent($("btnCancel"), "click");
	});

	$("txtCarCompanyCd").focus();

	toggleMcPartCostFields(false);
	
	$("btnViewHistory").observe("click", function() {
		if (changeTag == 1){
    		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		}else{
			showOverlay("showMotorCarPartCostHistory", "Motor Car Part Cost History", "showMotorCarPartCostHistory");
		}
	});
	
</script>