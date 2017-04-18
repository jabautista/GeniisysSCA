<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss117MainDiv" name="giiss117MainDiv" style="">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="acExit">Exit</a></li>
			</ul>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Body Type Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss117" name="giiss117">		
		<div class="sectionDiv">
			<div id="bodyTypeTableDiv" style="padding-top: 10px;">
				<div id="bodyTypeTable" style="height: 331px; padding-left: 165px;"></div>
			</div>
			<div align="center" id="bodyTypeFormDiv">
				<table style="margin-top: 5px;">
					<!-- <tr>
						<td class="rightAligned">Code</td>
						<td class="leftAligned">
							<input id="txtTypeOfBodyCd" type="text" class="required integerNoNegativeUnformattedNoComma" style="width: 200px; text-align: left;" tabindex="201" maxlength="2">
						</td>
					</tr> -->	
					<tr>
						<td width="" class="rightAligned">Type Of Body</td>
						<td class="leftAligned" colspan="3">
							<input id="txtTypeOfBody" type="text" class="required allCaps" style="width: 533px;" tabindex="203" maxlength="30">
						</td>
					</tr>				
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="204"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="205"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 223px;" readonly="readonly" tabindex="206"></td>
						<td width="" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 223px;" readonly="readonly" tabindex="207"></td>
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
	setModuleId("GIISS117");
	setDocumentTitle("Body Type Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiiss117(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgBodyType.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgBodyType.geniisysRows);
		new Ajax.Request(contextPath+"/GIISTypeOfBodyController", {
			method: "POST",
			parameters : {action : "saveGIISS117",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS117.exitPage != null) {
							objGIISS117.exitPage();
						} else {
							tbgBodyType._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGIISS117);
	
	var objGIISS117 = {};
	var objCurrBodyType = null;
	objGIISS117.bodyTypeList = JSON.parse('${jsonBodyType}');
	objGIISS117.exitPage = null;
	objGIISS117.typeOfBodyCd = "";
	
	var bodyTypeTable = {
			url : contextPath + "/GIISTypeOfBodyController?action=showGIISS117&refresh=1",
			options : {
				width : '600px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrBodyType = tbgBodyType.geniisysRows[y];
					setFieldValues(objCurrBodyType);
					tbgBodyType.keys.removeFocus(tbgBodyType.keys._nCurrentFocus, true);
					tbgBodyType.keys.releaseKeys();
					$("txtTypeOfBody").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgBodyType.keys.removeFocus(tbgBodyType.keys._nCurrentFocus, true);
					tbgBodyType.keys.releaseKeys();
					$("txtTypeOfBody").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgBodyType.keys.removeFocus(tbgBodyType.keys._nCurrentFocus, true);
						tbgBodyType.keys.releaseKeys();
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
					tbgBodyType.keys.removeFocus(tbgBodyType.keys._nCurrentFocus, true);
					tbgBodyType.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgBodyType.keys.removeFocus(tbgBodyType.keys._nCurrentFocus, true);
					tbgBodyType.keys.releaseKeys();
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
					tbgBodyType.keys.removeFocus(tbgBodyType.keys._nCurrentFocus, true);
					tbgBodyType.keys.releaseKeys();
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
					id : 'typeOfBodyCd',
					title : 'Code',
					filterOption : true,
					filterOptionType: 'integerNoNegative',
					width : '80px',
					align: 'right',
					titleAlign: 'right',
					renderer: function(value){
						return value == "" ? "" : lpad(value,6,0);
					}
				}, 
				{
					id : 'typeOfBody',
					filterOption : true,
					title : 'Type Of Body',
					width : '480px'				
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
			rows : objGIISS117.bodyTypeList.rows
		};

		tbgBodyType = new MyTableGrid(bodyTypeTable);
		tbgBodyType.pager = objGIISS117.bodyTypeList;
		tbgBodyType.render("bodyTypeTable");
	
	function setFieldValues(rec){
		try{
			objGIISS117.typeOfBodyCd = (rec == null ? "" : rec.typeOfBodyCd);
			$("txtTypeOfBody").setAttribute("lastValidValue", (rec == null ? "" : rec.typeOfBody));
			$("txtTypeOfBody").value = (rec == null ? "" : unescapeHTML2(rec.typeOfBody));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : dateFormat(rec.lastUpdate, 'mm-dd-yyyy hh:MM:ss TT'));
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrBodyType = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.typeOfBodyCd = objGIISS117.typeOfBodyCd;
			obj.typeOfBody = escapeHTML2($F("txtTypeOfBody"));
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGiiss117;
			var dept = setRec(objCurrBodyType);
			if($F("btnAdd") == "Add"){
				tbgBodyType.addBottomRow(dept);
			} else {
				tbgBodyType.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgBodyType.keys.removeFocus(tbgBodyType.keys._nCurrentFocus, true);
			tbgBodyType.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("bodyTypeFormDiv")){
				var addedSameExists = false;
				var deletedSameExists = false;	
				
				for ( var i = 0; i < tbgBodyType.geniisysRows.length; i++) {
					if ($F("btnAdd") == "Add"){	//added if else condition : shan 07.10.2014
						if (tbgBodyType.geniisysRows[i].recordStatus == 0 || tbgBodyType.geniisysRows[i].recordStatus == 1) {
							if (tbgBodyType.geniisysRows[i].typeOfBody == escapeHTML2($F("txtTypeOfBody"))) {
								addedSameExists = true;
							}
						} else if (tbgBodyType.geniisysRows[i].recordStatus == -1) {
							if (tbgBodyType.geniisysRows[i].typeOfBody == escapeHTML2($F("txtTypeOfBody"))) {
								deletedSameExists = true;
							}
						}
					}else{
						if (tbgBodyType.geniisysRows[i].recordStatus == 0 || tbgBodyType.geniisysRows[i].recordStatus == 1) {
							if (tbgBodyType.geniisysRows[i].typeOfBody == escapeHTML2($F("txtTypeOfBody")) &&
									unescapeHTML2(objCurrBodyType.typeOfBody) != $F("txtTypeOfBody")) {
								addedSameExists = true;
							}
						} else if (tbgBodyType.geniisysRows[i].recordStatus == -1) {
							if (tbgBodyType.geniisysRows[i].typeOfBody == escapeHTML2($F("txtTypeOfBody")) &&
									unescapeHTML2(objCurrBodyType.typeOfBody) != $F("txtTypeOfBody")) {
								deletedSameExists = true;
							}
						}
					}
				}
				if ((addedSameExists && !deletedSameExists)|| (deletedSameExists && addedSameExists)) {
					showMessageBox("Record already exists with the same type_of_body.", "E");
					$("txtTypeOfBody").value = $("txtTypeOfBody").readAttribute("lastValidValue");
					return;
				} else if (deletedSameExists && !addedSameExists) {
					addRec();
					return;
				}
				new Ajax.Request(contextPath + "/GIISTypeOfBodyController", {
					parameters : {
						action : "valAddRec",
						typeOfBodyCd : /*$F("txtTypeOfBody")*/ ($F("btnAdd") == "Add" ? $F("txtTypeOfBody") : // changed by shan 07.10.2014
										(unescapeHTML2(objCurrBodyType.typeOfBody) == $F("txtTypeOfBody") ? null : $F("txtTypeOfBody")))
					},
					onCreate : showNotice("Processing, please wait..."),
					onComplete : function(response) {
						hideNotice();
						if (checkErrorOnResponse(response)
								&& checkCustomErrorOnResponse(response)) {
							addRec();
						} else {
							$("txtTypeOfBody").value = $("txtTypeOfBody").readAttribute("lastValidValue");
						}
					}
				});
			}
		} catch (e) {
			showErrorMessage("valAddRec", e);
		}
	}

	function deleteRec() {
		changeTagFunc = saveGiiss117;
		objCurrBodyType.recordStatus = -1;
		tbgBodyType.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}

	function valDeleteRec() {
		try {
			new Ajax.Request(contextPath + "/GIISTypeOfBodyController", {
				parameters : {
					action : "valDeleteRec",
					typeOfBodyCd : objGIISS117.typeOfBodyCd
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response) {
					hideNotice();
					if(response.responseText != "N"){
						showMessageBox("Cannot delete record from GIIS_TYPE_OF_BODY while dependent record(s) in "+ response.responseText +" exists.", imgMessage.ERROR);
					} else{
						if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
							deleteRec();
						}
					}
				}
			});
		} catch (e) {
			showErrorMessage("valDeleteRec", e);
		}
	}

	function exitPage() {
		goToModule("/GIISUserController?action=goToUnderwriting",
				"Underwriting Main", null);
	}

	function cancelGiiss117() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						objGIISS117.exitPage = exitPage;
						saveGiiss117();
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

	$("editRemarks").observe(
			"click",
			function() {
				showOverlayEditor("txtRemarks", 4000, $("txtRemarks")
						.hasAttribute("readonly"));
			});

	disableButton("btnDelete");

	observeSaveForm("btnSave", saveGiiss117);
	$("btnCancel").observe("click", cancelGiiss117);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);
	$("acExit").stopObserving("click");
	$("acExit").observe("click", function() {
		fireEvent($("btnCancel"), "click");
	});
	$("txtTypeOfBody").focus();
</script>