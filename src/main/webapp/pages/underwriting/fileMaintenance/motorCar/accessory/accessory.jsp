<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss107MainDiv" name="giiss107MainDiv" style="">
	<div id="accessoryExitDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="uwExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Accessory Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss107" name="giiss107">		
		<div class="sectionDiv">
			<div id="accessoryTableDiv" style="padding-top: 10px;">
				<div id="accessoryTable" style="height: 340px; margin-left: 115px;"></div>
			</div>
			<div align="center" id="accessoryFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Code</td>
						<td class="rightAligned">
							<input id="txtAccessoryCd" type="text" class="rightAligned" disabled="disabled" style="width: 200px;margin-bottom:0" tabindex="201">
						</td>		
						<td class="rightAligned">Amount</td>
						<td class="rightAligned">
							<input id="txtAccAmt" class="rightAligned money4" type="text" style="width: 200px;margin-bottom:0" maxlength="13" tabindex="202">
						</td>			
					</tr>	
					<tr>
						<td width="" class="rightAligned">Description</td>
						<td class="leftAligned" colspan="3">
							<input id="txtAccessoryDesc" type="text" class="required" style="width: 533px;" maxlength="40" tabindex="203">
						</td>
					</tr>				
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="204"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" tabindex="205"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="206"></td>
						<td width="113px" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="207"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;" align="center">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="208">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="209">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="210">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="211">
</div>
<script type="text/javascript">	
	setModuleId("GIISS107");
	setDocumentTitle("Accessory Maintenance");
	initializeAll();
	initializeAccordion();
	initializeAllMoneyFields();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiiss107(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgAccessory.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgAccessory.geniisysRows);
		new Ajax.Request(contextPath+"/GIISAccessoryController", {
			method: "POST",
			parameters : {action : "saveGiiss107",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS107.exitPage != null) {
							objGIISS107.exitPage();
						} else {
							tbgAccessory._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss107);
	
	var objGIISS107 = {};
	var objCurrAccessory = null;
	objGIISS107.accessoryList = JSON.parse('${jsonAccessoryList}');
	objGIISS107.exitPage = null;
	
	var accessoryTable = {
			url : contextPath + "/GIISAccessoryController?action=showGiiss107&refresh=1",
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrAccessory = tbgAccessory.geniisysRows[y];
					setFieldValues(objCurrAccessory);
					tbgAccessory.keys.removeFocus(tbgAccessory.keys._nCurrentFocus, true);
					tbgAccessory.keys.releaseKeys();
					$("txtAccessoryDesc").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgAccessory.keys.removeFocus(tbgAccessory.keys._nCurrentFocus, true);
					tbgAccessory.keys.releaseKeys();
					$("txtAccessoryDesc").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgAccessory.keys.removeFocus(tbgAccessory.keys._nCurrentFocus, true);
						tbgAccessory.keys.releaseKeys();
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
					tbgAccessory.keys.removeFocus(tbgAccessory.keys._nCurrentFocus, true);
					tbgAccessory.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgAccessory.keys.removeFocus(tbgAccessory.keys._nCurrentFocus, true);
					tbgAccessory.keys.releaseKeys();
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
					tbgAccessory.keys.removeFocus(tbgAccessory.keys._nCurrentFocus, true);
					tbgAccessory.keys.releaseKeys();
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
					id : "accessoryCd",
					title : "Code",
					filterOption : true,
					width : '120px',
					filterOptionType : 'integerNoNegative',
					titleAlign : 'right',
					align : 'right'
				},
				{
					id : 'accessoryDesc',
					filterOption : true,
					title : 'Description',
					width : '370px'				
				},				
				{
					id : 'accAmt',
					filterOption : true,
					title : 'Amount',
					width : '170px',
					filterOptionType : 'numberNoNegative',
					titleAlign : 'right',
					align : 'right',
					renderer: function(value){
						return formatCurrency(value);	
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
			rows : objGIISS107.accessoryList.rows
		};

		tbgAccessory = new MyTableGrid(accessoryTable);
		tbgAccessory.pager = objGIISS107.accessoryList;
		tbgAccessory.render("accessoryTable");
	
	function setFieldValues(rec){
		try{
			$("txtAccessoryCd").value = (rec == null ? "" : rec.accessoryCd);
			$("txtAccessoryDesc").value = (rec == null ? "" : unescapeHTML2(rec.accessoryDesc));			
			$("txtAccAmt").value = (rec == null ? "" : formatCurrency(rec.accAmt));	
			$("txtAccAmt").setAttribute("lastValidValue",(rec == null ? "" : formatCurrency(rec.accAmt)));
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrAccessory = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.accessoryCd = $F("txtAccessoryCd");
			obj.accessoryDesc = escapeHTML2($F("txtAccessoryDesc"));
			obj.accAmt = $F("txtAccAmt").replace(/,/g, "");
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
			changeTagFunc = saveGiiss107;
			var dept = setRec(objCurrAccessory);
			if($F("btnAdd") == "Add"){
				tbgAccessory.addBottomRow(dept);
			} else {
				tbgAccessory.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgAccessory.keys.removeFocus(tbgAccessory.keys._nCurrentFocus, true);
			tbgAccessory.keys.releaseKeys();
			$("txtAccAmt").setAttribute("lastValidValue","");
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}				
	
	function valAddRec() {
		try {
			if (checkAllRequiredFieldsInDiv("accessoryFormDiv")) {
				if ($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;
					for ( var i = 0; i < tbgAccessory.geniisysRows.length; i++) {
						if (tbgAccessory.geniisysRows[i].recordStatus == 0
								|| tbgAccessory.geniisysRows[i].recordStatus == 1) {
							if (tbgAccessory.geniisysRows[i].accessoryDesc == escapeHTML2($F("txtAccessoryDesc"))) {
								addedSameExists = true;
							}
						} else if (tbgAccessory.geniisysRows[i].recordStatus == -1) {
							if (unescapeHTML2(tbgAccessory.geniisysRows[i].accessoryDesc) == $F("txtAccessoryDesc")) {
								deletedSameExists = true;
							}
						}
					}
					if ((addedSameExists && !deletedSameExists)
							|| (deletedSameExists && addedSameExists)) {
						showMessageBox(
								"Record already exists with the same accessory_desc.",
								"E");
						return;
					} else if (deletedSameExists && !addedSameExists) {
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GIISAccessoryController", {
						parameters : {
							action : "valAddRec",
							accessoryDesc : $F("txtAccessoryDesc")
						},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response) {
							hideNotice();
							if (checkErrorOnResponse(response)
									&& checkCustomErrorOnResponse(response)) {
								addRec();
							}
						}
					});					
				} else {
					var addedSameExists = false;
					var deletedSameExists = false;
					for ( var i = 0; i < tbgAccessory.geniisysRows.length; i++) {
						if (tbgAccessory.geniisysRows[i].recordStatus == 0
								|| tbgAccessory.geniisysRows[i].recordStatus == 1) {
							if (tbgAccessory.geniisysRows[i].accessoryDesc == escapeHTML2($F("txtAccessoryDesc")) && objCurrAccessory.accessoryDesc != tbgAccessory.geniisysRows[i].accessoryDesc) {
								addedSameExists = true;
							}
						} else if (tbgAccessory.geniisysRows[i].recordStatus == -1) {
							if (unescapeHTML2(tbgAccessory.geniisysRows[i].accessoryDesc) == $F("txtAccessoryDesc")) {
								deletedSameExists = true;
							}
						}
					}
					if ((addedSameExists && !deletedSameExists)
							|| (deletedSameExists && addedSameExists)) {
						showMessageBox(
								"Record already exists with the same accessory_desc.",
								"E");
						return;
					} else if (deletedSameExists && !addedSameExists) {
						addRec();
						return;
					}
					if(unescapeHTML2(objCurrAccessory.accessoryDesc) != $F("txtAccessoryDesc")){
						new Ajax.Request(contextPath + "/GIISAccessoryController", {
							parameters : {
								action : "valAddRec",
								accessoryDesc : $F("txtAccessoryDesc")
							},
							onCreate : showNotice("Processing, please wait..."),
							onComplete : function(response) {
								hideNotice();
								if (checkErrorOnResponse(response)
										&& checkCustomErrorOnResponse(response)) {
									addRec();
								}
							}
						});		
					}else{
						addRec();
					}										
				}
			}
		} catch (e) {
			showErrorMessage("valAddRec", e);
		}
	}

	function deleteRec() {
		changeTagFunc = saveGiiss107;
		objCurrAccessory.recordStatus = -1;
		tbgAccessory.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}

	function valDeleteRec() {
		try {
			if($F("txtAccessoryCd") != ""){
				new Ajax.Request(contextPath + "/GIISAccessoryController", {
					parameters : {
						action : "valDeleteRec",
						accessoryCd : $F("txtAccessoryCd")
					},
					onCreate : showNotice("Processing, please wait..."),
					onComplete : function(response) {
						hideNotice();
						if (checkErrorOnResponse(response)
								&& checkCustomErrorOnResponse(response)) {
							deleteRec();
						}
					}
				});
			}else{
				deleteRec();
			}
		} catch (e) {
			showErrorMessage("valDeleteRec", e);
		}
	}

	function exitPage() {
		goToModule("/GIISUserController?action=goToUnderwriting",
				"Underwriting Main", null);
	}

	function cancelGiiss107() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						objGIISS107.exitPage = exitPage;
						saveGiiss107();
					}, function() {
						goToModule(
								"/GIISUserController?action=goToUnderwriting",
								"Underwriting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting",
					"Underwriting Main", null);
		}
	}

	$("editRemarks").observe("click", function() {
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});	
	
	$("txtAccessoryDesc").observe("keyup", function() {
		$("txtAccessoryDesc").value = $F("txtAccessoryDesc").toUpperCase();
	});	
	
	$("txtAccessoryDesc").observe("change", function() {
		$("txtAccessoryDesc").value = $F("txtAccessoryDesc").toUpperCase();
	});	
	
	$("txtAccAmt").observe("change", function(){	
		if (parseFloat($F("txtAccAmt").replace(/,/g, "")) > 9999999999.99 || parseFloat($F("txtAccAmt").replace(/,/g, "")) < -9999999999.99) {
			showWaitingMessageBox("Invalid Amount. Valid value should be from 0.00 to 9,999,999,999.99.", "E",
					function() {
						$("txtAccAmt").value = $("txtAccAmt").readAttribute("lastValidValue");
					});
		}else{
			$("txtAccAmt").setAttribute("lastValidValue", formatCurrency($F("txtAccAmt")));
		}		
	});
	
	disableButton("btnDelete");
	observeSaveForm("btnSave", saveGiiss107);
	$("btnCancel").observe("click", cancelGiiss107);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);
	$("uwExit").stopObserving("click");
	$("uwExit").observe("click", function() {
		fireEvent($("btnCancel"), "click");
	});
	$("txtAccessoryDesc").focus();
</script>