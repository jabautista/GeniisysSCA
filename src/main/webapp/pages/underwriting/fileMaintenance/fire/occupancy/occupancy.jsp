<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss097MainDiv" name="giiss097MainDiv" style="">
	<div id="fireOccupancyExitDiv">
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
	   		<label>Occupancy Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss097" name="giiss097">		
		<div class="sectionDiv">
			<div id="fireOccupancyTableDiv" style="padding-top: 10px;">
				<div id="fireOccupancyTable" style="height: 340px; margin-left: 115px;"></div>
			</div>
			<div align="center" id="fireOccupancyFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Occupancy Code</td>
						<td class="leftAligned">
							<input id="txtOccupancyCd" type="text" class="required" style="width: 200px" maxlength="3" tabindex="203">
						</td>		
						<td></td>
						<td class="leftAligned">
							<input type="checkbox" id="chkActiveTag" checked="checked"/><label for="chkActiveTag" style="float:right;margin-right: 145px;" tabindex="204">Active Tag</label>
						</td>				
					</tr>	
					<tr>
						<td width="" class="rightAligned">Occupancy Description</td>
						<td class="leftAligned" colspan="3">
							<div id="occupancyDescDiv" name="occupancyDescDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;" class="required">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtOccupancyDesc" name="txtOccupancyDesc" maxlength="2000"  onkeyup="limitText(this,2000);" tabindex="205" class="required"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editOccupancyDesc"  tabindex="206"/>
							</div>
							<input id="txtOrigOccupancyDesc" type="hidden">
						</td>
					</tr>				
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="207"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="208"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly"></td>
						<td width="113px" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;" align="center">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="209">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="210">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="211">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="212">
</div>
<script type="text/javascript">	
	setModuleId("GIISS097");
	setDocumentTitle("Occupancy Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	var allRecObj = {};
	
	function saveGiiss097(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgFireOccupancy.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgFireOccupancy.geniisysRows);
		new Ajax.Request(contextPath+"/GIISFireOccupancyController", {
			method: "POST",
			parameters : {action : "saveGiiss097",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS097.exitPage != null) {
							objGIISS097.exitPage();
						} else {
							tbgFireOccupancy._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss097);
	
	var objGIISS097 = {};
	var objCurrFireOccupancy = null;
	objGIISS097.fireOccupancyList = JSON.parse('${jsonFireOccupancyList}');
	objGIISS097.exitPage = null;
	
	var fireOccupancyTable = {
			url : contextPath + "/GIISFireOccupancyController?action=showGiiss097&refresh=1",
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrFireOccupancy = tbgFireOccupancy.geniisysRows[y];
					setFieldValues(objCurrFireOccupancy);
					tbgFireOccupancy.keys.removeFocus(tbgFireOccupancy.keys._nCurrentFocus, true);
					tbgFireOccupancy.keys.releaseKeys();
					$("txtOccupancyDesc").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgFireOccupancy.keys.removeFocus(tbgFireOccupancy.keys._nCurrentFocus, true);
					tbgFireOccupancy.keys.releaseKeys();
					$("txtOccupancyCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgFireOccupancy.keys.removeFocus(tbgFireOccupancy.keys._nCurrentFocus, true);
						tbgFireOccupancy.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
					tbgFireOccupancy.keys.removeFocus(tbgFireOccupancy.keys._nCurrentFocus, true);
					tbgFireOccupancy.keys.releaseKeys();
				},
				onSort: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgFireOccupancy.keys.removeFocus(tbgFireOccupancy.keys._nCurrentFocus, true);
					tbgFireOccupancy.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgFireOccupancy.keys.removeFocus(tbgFireOccupancy.keys._nCurrentFocus, true);
					tbgFireOccupancy.keys.releaseKeys();
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
					tbgFireOccupancy.keys.removeFocus(tbgFireOccupancy.keys._nCurrentFocus, true);
					tbgFireOccupancy.keys.releaseKeys();
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
					id : "activeTag",
					title : "&nbsp;&nbsp;A",
					width : '30px',
					align : "center",
					titleAlign : "right",
					filterOption : true,
					altTitle : 'Active Tag',
					editable : false,
					visible : true,
					defaultValue : true,
					otherValue : false,
					filterOptionType : 'checkbox',
					editor : new MyTableGrid.CellCheckbox({
						getValueOf : function(value) {
							if (value) {
								return "Y";
							} else {
								return "N";
							}
						}
					})
				},
				{
					id : "occupancyCd",
					title : "Occupancy Code",
					filterOption : true,
					width : '130px'
				},
				{
					id : 'occupancyDesc',
					filterOption : true,
					title : 'Occupancy Description',
					width : '500px'				
				},				
				{
					id : 'activeTag',
					width : '0',
					visible: false
					
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
			rows : objGIISS097.fireOccupancyList.rows
		};

		tbgFireOccupancy = new MyTableGrid(fireOccupancyTable);
		tbgFireOccupancy.pager = objGIISS097.fireOccupancyList;
		tbgFireOccupancy.render("fireOccupancyTable");
		tbgFireOccupancy.afterRender = function(){
     		allRecObj = getAllRecord();				
		};
	
	function setFieldValues(rec){
		try{
			$("txtOccupancyCd").value = (rec == null ? "" : unescapeHTML2(rec.occupancyCd));
			$("txtOccupancyDesc").value = (rec == null ? "" : unescapeHTML2(rec.occupancyDesc));	
			$("txtOrigOccupancyDesc").value = (rec == null ? "" : unescapeHTML2(rec.occupancyDesc));
			$("chkActiveTag").checked = rec == null ? true
					: (rec.activeTag == "Y" ? true : false);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtOccupancyCd").readOnly = false : $("txtOccupancyCd").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrFireOccupancy = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.occupancyCd = escapeHTML2($F("txtOccupancyCd"));
			obj.occupancyDesc = escapeHTML2($F("txtOccupancyDesc"));
			obj.activeTag = $("chkActiveTag").checked ? "Y":"N";		
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
			changeTagFunc = saveGiiss097;
			//alert(objCurrFireOccupancy);
			var dept = setRec(objCurrFireOccupancy);
			var newObj = setRec(null);
			if($F("btnAdd") == "Add"){
				tbgFireOccupancy.addBottomRow(dept);
				newObj.recordStatus = 0;
				allRecObj.push(newObj);
			} else {
				tbgFireOccupancy.updateVisibleRowOnly(dept, rowIndex, false);
				for(var i = 0; i<allRecObj.length; i++){
					if ((allRecObj[i].occupancyCd == newObj.occupancyCd)&&(allRecObj[i].recordStatus != -1)){
						newObj.recordStatus = 1;
						allRecObj.splice(i, 1, newObj);
					}
				}
			}
			changeTag = 1;
			setFieldValues(null);
			tbgFireOccupancy.keys.removeFocus(tbgFireOccupancy.keys._nCurrentFocus, true);
			tbgFireOccupancy.keys.releaseKeys();			
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}				
	
	function valAddRec() {
		try {
			if (checkAllRequiredFieldsInDiv("fireOccupancyFormDiv")) {
				/*for(var i=0; i<allRecObj.length; i++){
					if(allRecObj[i].recordStatus != -1 ){
						if ($F("btnAdd") == "Add") {
							if(unescapeHTML2(allRecObj[i].occupancyCd.toUpperCase()) == $F("txtOccupancyCd").toUpperCase()){
								showMessageBox("Record already exists with the same occupancy_cd.", "E");
								return;
							}else if(unescapeHTML2(allRecObj[i].occupancyDesc) == $F("txtOccupancyDesc")){
								showMessageBox("Record already exists with the same occupancy_desc.", "E");
								return;
							}
						} else{
							if($F("txtOrigOccupancyDesc") != $F("txtOccupancyDesc") && unescapeHTML2(allRecObj[i].occupancyDesc) == $F("txtOccupancyDesc")){
								showMessageBox("Record already exists with the same occupancy_desc.", "E");
								return;
							}
						}
					} 
				}
				addRec();*/
				
			if ($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;
					var addedSameExists2 = false;
					var deletedSameExists2 = false;
					for ( var i = 0; i < tbgFireOccupancy.geniisysRows.length; i++) {
						if (tbgFireOccupancy.geniisysRows[i].recordStatus == 0
								|| tbgFireOccupancy.geniisysRows[i].recordStatus == 1) {
							if (unescapeHTML2(tbgFireOccupancy.geniisysRows[i].occupancyCd.toUpperCase()) == $F("txtOccupancyCd").toUpperCase()) {
								addedSameExists = true;
							}							
							if (unescapeHTML2(tbgFireOccupancy.geniisysRows[i].occupancyDesc.toUpperCase()) == $F("txtOccupancyDesc").toUpperCase()) {
								addedSameExists2 = true;							
							}
						} else if (tbgFireOccupancy.geniisysRows[i].recordStatus == -1) {
							if (unescapeHTML2(tbgFireOccupancy.geniisysRows[i].occupancyCd.toUpperCase()) == $F("txtOccupancyCd").toUpperCase()) {
								deletedSameExists = true;
							}
							if (unescapeHTML2(tbgFireOccupancy.geniisysRows[i].occupancyDesc.toUpperCase()) == $F("txtOccupancyDesc").toUpperCase()) {
								deletedSameExists2 = true;								
							}
						}
					}
					if ((addedSameExists && !deletedSameExists)
							|| (deletedSameExists && addedSameExists)) {
						showMessageBox(
								"Record already exists with the same occupancy_cd.",
								"E");
						return;
					} else if ((addedSameExists2 && !deletedSameExists2)
							|| (deletedSameExists2 && addedSameExists2)) {
						showMessageBox(
								"Record already exists with the same occupancy_desc.",
								"E");
						return;
					} else if (deletedSameExists && !addedSameExists) {
						addRec();
						return;
					}else if (deletedSameExists2 && !addedSameExists2) {
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GIISFireOccupancyController", {
						parameters : {
							action : "valAddRec",
							occupancyCd : $F("txtOccupancyCd"),
							occupancyDesc : $F("txtOccupancyDesc")
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
					for ( var i = 0; i < tbgFireOccupancy.geniisysRows.length; i++) {
						if (tbgFireOccupancy.geniisysRows[i].recordStatus == 0
								|| tbgFireOccupancy.geniisysRows[i].recordStatus == 1) {												
							if ((tbgFireOccupancy.geniisysRows[i].occupancyDesc.toUpperCase() == escapeHTML2($F("txtOccupancyDesc").toUpperCase())) && (objCurrFireOccupancy.occupancyDesc != tbgFireOccupancy.geniisysRows[i].occupancyDesc)) {
								addedSameExists = true;							
							}
						} else if (tbgFireOccupancy.geniisysRows[i].recordStatus == -1) {							
							if (tbgFireOccupancy.geniisysRows[i].occupancyDesc.toUpperCase() == escapeHTML2($F("txtOccupancyDesc").toUpperCase())) {
								deletedSameExists = true;								
							}
						}
					}
					if ((addedSameExists && !deletedSameExists)
							|| (deletedSameExists && addedSameExists)) {
						showMessageBox(
								"Record already exists with the same occupancy_desc.",
								"E");
						return;
					} else if (deletedSameExists && !addedSameExists) {
						addRec();
						return;
					}
					if(objCurrFireOccupancy.occupancyDesc != escapeHTML2($F("txtOccupancyDesc"))){
						new Ajax.Request(contextPath + "/GIISFireOccupancyController", {
							parameters : {
								action : "valAddRec",
								occupancyDesc : $F("txtOccupancyDesc")
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
		changeTagFunc = saveGiiss097;
		var newObj = setRec(null);
		objCurrFireOccupancy.recordStatus = -1;
		tbgFireOccupancy.deleteRow(rowIndex);
		tbgFireOccupancy.geniisysRows[rowIndex].occupancyCd = escapeHTML2($F("txtOccupancyCd"));
		for(var i = 0; i<allRecObj.length; i++){
			if ((allRecObj[i].occupancyCd == unescapeHTML2(newObj.occupancyCd))&&(allRecObj[i].recordStatus != -1)){
				newObj.recordStatus = -1;
				allRecObj.splice(i, 1, newObj);
			}
		}
		changeTag = 1;
		setFieldValues(null);
	}

	function valDeleteRec() {
		try {
			new Ajax.Request(contextPath + "/GIISFireOccupancyController", {
				parameters : {
					action : "valDeleteRec",
					occupancyCd : $F("txtOccupancyCd")
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
		} catch (e) {
			showErrorMessage("valDeleteRec", e);
		}
	}

	function exitPage() {
		goToModule("/GIISUserController?action=goToUnderwriting",
				"Underwriting Main", null);
	}

	function cancelGiiss097() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						objGIISS097.exitPage = exitPage;
						saveGiiss097();
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
	
	function getAllRecord() {
		try {
			var objReturn = {};
			new Ajax.Request(contextPath + "/GIISFireOccupancyController", {
				parameters : {action : "showAllGiiss097"},
			    asynchronous: false,
				evalScripts: true,
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						var obj = {};
						obj = JSON.parse(response.responseText.replace(/\\\\/g, '\\'));
						objReturn = obj.rows;
					}
				}
			});
			return objReturn;
		} catch (e) {
			showErrorMessage("getAllRecord",e);
		}
	}
	

	$("editRemarks").observe(
			"click",
			function() {
				showOverlayEditor("txtRemarks", 4000, $("txtRemarks")
						.hasAttribute("readonly"));
			});	
	
	$("editOccupancyDesc").observe(
			"click",
			function() {
				showOverlayEditor("txtOccupancyDesc", 2000, $("txtOccupancyDesc")
						.hasAttribute("readonly"));
			});	
	
	$("txtOccupancyCd").observe("keyup", function() {
		$("txtOccupancyCd").value = $F("txtOccupancyCd").toUpperCase();
	});
	
	$("txtOccupancyCd").observe("change", function() {			
		if($F("txtOccupancyCd").trim()!=""){
			$("txtOccupancyCd").value = $F("txtOccupancyCd").toUpperCase();			
		}else{
			$("txtOccupancyCd").value = "";
		}	
	});	

	disableButton("btnDelete");
	observeSaveForm("btnSave", saveGiiss097);
	$("btnCancel").observe("click", cancelGiiss097);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("uwExit").stopObserving("click");
	$("uwExit").observe("click", function() {
		fireEvent($("btnCancel"), "click");
	});
	$("txtOccupancyCd").focus();
</script>