<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="gicls171MainDiv" name="gicls171MainDiv" style="">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="btnExit">Exit</a></li>
			</ul>
		</div>
	</div>

	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Motor Car Labor Point System Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="gicls171" name="gicls171">		
		<div class="sectionDiv">
			<div id="mcLaborPointSystemTableDiv" style="padding-top: 10px;">
				<div id="mcLaborPointSystemTable" style="height: 331px; margin-left: 11px;"></div>
			</div>
			<div style="margin-top: 10px; text-align: center;">
				<input type="button" class="button" id="btnPartMaintenance" value="Part Maintenance" style="width: 120px;"/>
				<input type="button" class="button" id="btnLpsHistory" value="LPS History" style="width: 120px;"/>
			</div>
			<div align="center" id="mcLaborPointSystemFormDiv">
				<table style="margin-top: 5px;" border="0">
					<tr>
						<td><label for="txtLossExpCd" style="float: right; margin-right: 5px;">Vehicle Part</label></td>
						<td colspan="3">
							<input type="text" id="txtLossExpCd" style="width: 70px;" readonly="readonly"/>
							<input type="text" id="txtLossExpDesc" style="width: 447px;" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<td><label for="txtTinsmithLight" style="float: right; margin-right: 5px;">Tinsmith Light</label></td>
						<td>
							<input type="text" id="txtTinsmithLight" class="money4" maxlength="13" lastValidValue="" style="width: 200px; text-align: right;"/>
						</td>
						<td><label for="txtTinsmithMedium" style="float: right; margin-right: 5px;">Tinsmith Medium</label></td>
						<td>
							<input type="text" id="txtTinsmithMedium" class="money4" maxlength="13" lastValidValue="" style="width: 200px; text-align: right;"/>
						</td>
					</tr>
					<tr>
						<td><label for="txtTinsmithHeavy" style="float: right; margin-right: 5px;">Tinsmith Heavy</label></td>
						<td>
							<input type="text" id="txtTinsmithHeavy" class="money4" maxlength="13" lastValidValue="" style="width: 200px; text-align: right;"/>
						</td>
						<td><label for="txtPainting" style="float: right; margin-right: 5px;">Painting</label></td>
						<td>
							<input type="text" id="txtPainting" class="money4" maxlength="13" lastValidValue="" style="width: 200px; text-align: right;"/>
						</td>
					</tr>
					<tr>
						<td><label style="float: right; margin-right: 5px;">Remarks</label></td>
						<td colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 535px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 509px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="204"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="205"/>
							</div>
						</td>
					</tr>
					<tr>
						<td><label style="float: right; margin-right: 5px;">User ID</label></td>
						<td><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="206"></td>
						<td width="113px"><label style="float: right; margin-right: 5px;">Last Update</label></td>
						<td><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="207"></td>
					</tr>
				</table>
			</div>
			<div style="margin: 10px; text-align: center;">
				<input type="button" class="button" id="btnUpdate" value="Update" tabindex="208" style="width: 100px;">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="208" style="display: none;">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="210">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="211">
</div>
<script type="text/javascript">	
	setModuleId("GICLS171");
	setDocumentTitle("Motor Car Labor Point System Maintenance");
	initializeAll();
	initializeAccordion();
	initializeAllMoneyFields();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGicls171(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		
		var setRows = getAddedAndModifiedJSONObjects(tbgMCLaborPointSystem.geniisysRows);
		
		new Ajax.Request(contextPath+"/GICLMcLpsController", {
			method: "POST",
			parameters : {action : "saveGicls171",
						setRows : prepareJsonAsParameter(setRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGicls171.exitPage != null) {
							objGicls171.exitPage();
						} else if(objGicls171.partMaintenance != null) {
							objGicls171.partMaintenance();
						} else {
							tbgMCLaborPointSystem._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGICLS171);
	
	var objGicls171 = new Object();
	var objMCLaborPointSystem = null;
	objGicls171.mcLaborPointSystemList = JSON.parse('${jsonLossExp}');
	objGicls171.exitPage = null;
	
	var mcLaborPointSystemTable = {
			url : contextPath + "/GICLMcLpsController?action=showGicls171&refresh=1",
			options : {
				width : '900px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objMCLaborPointSystem = tbgMCLaborPointSystem.geniisysRows[y];
					setFieldValues(objMCLaborPointSystem);
					tbgMCLaborPointSystem.keys.removeFocus(tbgMCLaborPointSystem.keys._nCurrentFocus, true);
					tbgMCLaborPointSystem.keys.releaseKeys();
					$("txtLossExpDesc").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgMCLaborPointSystem.keys.removeFocus(tbgMCLaborPointSystem.keys._nCurrentFocus, true);
					tbgMCLaborPointSystem.keys.releaseKeys();
					$("txtLossExpCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgMCLaborPointSystem.keys.removeFocus(tbgMCLaborPointSystem.keys._nCurrentFocus, true);
						tbgMCLaborPointSystem.keys.releaseKeys();
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
					tbgMCLaborPointSystem.keys.removeFocus(tbgMCLaborPointSystem.keys._nCurrentFocus, true);
					tbgMCLaborPointSystem.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgMCLaborPointSystem.keys.removeFocus(tbgMCLaborPointSystem.keys._nCurrentFocus, true);
					tbgMCLaborPointSystem.keys.releaseKeys();
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
					tbgMCLaborPointSystem.keys.removeFocus(tbgMCLaborPointSystem.keys._nCurrentFocus, true);
					tbgMCLaborPointSystem.keys.releaseKeys();
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
					id : "lossExpCd lossExpDesc",
					title: "Vehicle Part",
					children: [
						{
							id : "lossExpCd",
							title: "Code",
							width: 70,
							filterOption : true,
						},
						{
							id : "lossExpDesc",
							title: "Vehicle Part",
							width: 252,
							filterOption : true
						}
		            ]
				},
				{
					id : "tinsmithLight",
					title: "Tinsmith Light",
					width: 140,
					align : "right",
					titleAlign : "right",
					filterOption : true,
					geniisysClass : 'money',
					filterOptionType : 'number'
				},
				{
					id : "tinsmithMedium",
					title: "Tinsmith Medium",
					width: 140,
					align : "right",
					titleAlign : "right",
					filterOption : true,
					geniisysClass : 'money',
					filterOptionType : 'number'
				},
				{
					id : "tinsmithHeavy",
					title: "Tinsmith Heavy",
					width: 140,
					align : "right",
					titleAlign : "right",
					filterOption : true,
					geniisysClass : 'money',
					filterOptionType : 'number'
				},
				{
					id : "painting",
					title: "Painting",
					width: 140,
					align : "right",
					titleAlign : "right",
					filterOption : true,
					geniisysClass : 'money',
					filterOptionType : 'number'
				}
			],
			rows : objGicls171.mcLaborPointSystemList.rows
		};

		tbgMCLaborPointSystem = new MyTableGrid(mcLaborPointSystemTable);
		tbgMCLaborPointSystem.pager = objGicls171.mcLaborPointSystemList;
		tbgMCLaborPointSystem.render("mcLaborPointSystemTable");
	
	function setFieldValues(rec){
		try{
			$("txtLossExpCd").value = (rec == null ? "" : unescapeHTML2(rec.lossExpCd));
			$("txtLossExpCd").setAttribute("lastValidValue", $F("txtLossExpCd"));
			$("txtLossExpDesc").value = (rec == null ? "" : unescapeHTML2(rec.lossExpDesc));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("txtTinsmithLight").value = (rec == null ? "" : formatCurrency(rec.tinsmithLight));
			$("txtTinsmithMedium").value = (rec == null ? "" : formatCurrency(rec.tinsmithMedium));
			$("txtTinsmithHeavy").value = (rec == null ? "" : formatCurrency(rec.tinsmithHeavy));
			$("txtPainting").value = (rec == null ? "" : formatCurrency(rec.painting));
			
			$("txtTinsmithLight").setAttribute("lastValidValue", (rec == null ? "" : formatCurrency(rec.tinsmithLight)));
			$("txtTinsmithMedium").setAttribute("lastValidValue", (rec == null ? "" : formatCurrency(rec.tinsmithMedium)));
			$("txtTinsmithHeavy").setAttribute("lastValidValue", (rec == null ? "" : formatCurrency(rec.tinsmithHeavy)));
			$("txtPainting").setAttribute("lastValidValue", (rec == null ? "" : formatCurrency(rec.painting)));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			objMCLaborPointSystem = rec;
			
			if(rec == null) {
				$("txtTinsmithLight").readOnly = true;
				$("txtTinsmithMedium").readOnly = true;
				$("txtTinsmithHeavy").readOnly = true;
				$("txtPainting").readOnly = true;
				$("txtRemarks").readOnly = true;
				disableButton("btnLpsHistory");
				disableButton("btnUpdate");
			} else {
				$("txtTinsmithLight").readOnly = false;
				$("txtTinsmithMedium").readOnly = false;
				$("txtTinsmithHeavy").readOnly = false;
				$("txtPainting").readOnly = false;
				$("txtRemarks").readOnly = false;
				enableButton("btnUpdate");
				
				if(rec.histTag == "Y")
					enableButton("btnLpsHistory");
				else
					disableButton("btnLpsHistory");
			}
			
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.lossExpCd = escapeHTML2($F("txtLossExpCd"));
			obj.lossExpDesc = escapeHTML2($F("txtLossExpDesc"));
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			obj.tinsmithLight = unformatCurrencyValue($F("txtTinsmithLight"));
			obj.tinsmithMedium = unformatCurrencyValue($F("txtTinsmithMedium"));
			obj.tinsmithHeavy = unformatCurrencyValue($F("txtTinsmithHeavy"));
			obj.painting = unformatCurrencyValue($F("txtPainting"));
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function updateRec() {
		try {
			changeTagFunc = saveGicls171;
			var dept = setRec(objMCLaborPointSystem);
			tbgMCLaborPointSystem.updateVisibleRowOnly(dept, rowIndex, false);
			changeTag = 1;
			setFieldValues(null);
			tbgMCLaborPointSystem.keys.removeFocus(tbgMCLaborPointSystem.keys._nCurrentFocus, true);
			tbgMCLaborPointSystem.keys.releaseKeys();
		} catch(e){
			showErrorMessage("updateRec", e);
		}
	}
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
	}	
	
	function cancelGiiss118(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGicls171.exitPage = exitPage;
						saveGicls171();
					}, function(){
						goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
		}
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	observeSaveForm("btnSave", saveGicls171);
	$("btnCancel").observe("click", cancelGiiss118);
	$("btnUpdate").observe("click", updateRec);
	
	$("btnExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	setFieldValues(null);
	
	$("txtLossExpCd").focus();
	
	function validateValue(obj){
		
		var temp = obj.value.replace(/,/g, "");
		
		var fieldName;
		
		if(obj.id == "txtTinsmithLight")
			fieldName = "Light";
		else if(obj.id == "txtTinsmithMedium")
			fieldName = "Medium";
		else if(obj.id == "txtTinsmithHeavy")
			fieldName = "Heavy";
		else
			fieldName = "Painting";
		
		if(obj.value == ""){
			obj.setAttribute("lastValidValue", "");
			return;
		}
		
		if(isNaN(temp)){
			customShowMessageBox("Invalid " + fieldName + ". Valid value should be from -999,999,999.99 to 999,999,999.99", "I", obj.getAttribute("id"));
			obj.value = obj.getAttribute("lastValidValue");
		} else if(parseFloat(Math.abs(unformatCurrencyValue(temp))) > 999999999.99){
			customShowMessageBox("Invalid " + fieldName + ". Valid value should be from -999,999,999.99 to 999,999,999.99", "I", obj.getAttribute("id"));
			obj.value = obj.getAttribute("lastValidValue");
		} else {
			obj.value = formatCurrency(obj.value);
			obj.setAttribute("lastValidValue", obj.value);				
		}
	}
	
	$("txtTinsmithLight").observe("change", function(){
		validateValue(this);
	});
	
	$("txtTinsmithMedium").observe("change", function(){
		validateValue(this);
	});
	
	$("txtTinsmithHeavy").observe("change", function(){
		validateValue(this);
	});
	
	$("txtPainting").observe("change", function(){
		validateValue(this);
	});
	
	function showLpsHistory(){
		try {
			overlayLpsHistory = 
				Overlay.show(contextPath+"/GICLMcLpsController", {
					urlContent: true,
					urlParameters: {action : "showGicls171LpsHistory",																
									ajax : "1",
									lossExpCd : removeLeadingZero($F("txtLossExpCd"))
					},
				    title: "LPS History",
				    height: 345,
				    width: 800,
				    draggable: true
				});
			} catch (e) {
				showErrorMessage("showLpsHistory" , e);
			}
	}
	
	$("btnLpsHistory").observe("click", function(){
		if(changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			return;
		}
			
		showLpsHistory();
	});
	
	/* Apollo 04.03.2014, changed back to normal observe, 
	/ to handle going to gicls104 with changes and the user pressed <Yes> */
	$("btnPartMaintenance").observe("click", function(){    
	//observeAccessibleModule(accessType.BUTTON, "GICLS104", "btnPartMaintenance", function(){ // Kris 03.10.2014:
		
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objCLMGlobal.previousModule = "GICLS171";
						objCLMGlobal.lineCd = "MC";
						objCLMGlobal.partSw = "Y";
						objCLMGlobal.fromItem = "Y";
						objGicls171.partMaintenance = showGicls104;
						saveGicls171();
					}, function(){
						objCLMGlobal.previousModule = "GICLS171";
						objCLMGlobal.lineCd = "MC";
						objCLMGlobal.partSw = "Y";
						objCLMGlobal.fromItem = "Y";
						showGicls104();
					}, "");
		} else {
			objCLMGlobal.previousModule = "GICLS171";
			objCLMGlobal.lineCd = "MC";
			objCLMGlobal.partSw = "Y";
			objCLMGlobal.fromItem = "Y";
			showGicls104();
		}
	});
	
	if(checkUserModule("GICLS104"))
		enableButton("btnPartMaintenance");
	else
		disableButton("btnPartMaintenance");
	
</script>