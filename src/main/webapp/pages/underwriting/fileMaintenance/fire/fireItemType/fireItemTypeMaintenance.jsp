<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss012MainDiv" name="giiss012MainDiv" style="">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="btnExit">Exit</a></li>
			</ul>
		</div>
	</div>

	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Fire Item Type Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss012" name="giiss012">		
		<div class="sectionDiv">
			<div id="frItemTypeTableDiv" style="padding-top: 10px;">
				<div id="frItemTypeTable" style="height: 331px; margin-left: 115px;"></div>
			</div>
			<div align="center" id="frItemTypeFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Item Type</td>
						<td class="leftAligned">
							<input id="txtFrItemType" type="text" class="required" style="width: 200px; text-align: left; margin: 0;" tabindex="201" maxlength="3">
						</td>
						<td class="rightAligned">Item Group</td>
						<td class="leftAligned">
							<span class="lovSpan" style="width: 206px; margin: 0; height: 21px;">
								<input type="hidden" id="hidFiItemGrp" lastValidValue=""/>
								<input type="text" id="txtFiItmGrpDesc" class="" ignoreDelKey="true" style="width: 181px; float: left; border: none; height: 14px; margin: 0;" lastValidValue="" tabindex="202"/> 
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgFiItemGrpDesc" alt="Go" style="float: right;"/>
							</span>
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Description</td>
						<td class="leftAligned" colspan="3">
							<input id="txtFrItmTpDs" type="text" class="required" style="width: 533px;" tabindex="203" maxlength="30">
						</td>
					</tr>				
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="204"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"/>
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
			<div style="margin: 10px; text-align: center;">
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
	setModuleId("GIISS012");
	setDocumentTitle("Fire Item Type Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiiss012(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgFrItemType.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgFrItemType.geniisysRows);
		new Ajax.Request(contextPath+"/GIISFiItemTypeController", {
			method: "POST",
			parameters : {action : "saveGiiss012",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGiiss012.exitPage != null) {
							objGiiss012.exitPage();
						} else {
							tbgFrItemType._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss012);
	
	var objGiiss012 = {};
	var objFrItemType = null;
	objGiiss012.frItemTypeList = JSON.parse('${jsonFrItemType}');
	objGiiss012.exitPage = null;
	
	var frItemTypeTable = {
			url : contextPath + "/GIISFiItemTypeController?action=showGiiss012&refresh=1",
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objFrItemType = tbgFrItemType.geniisysRows[y];
					setFieldValues(objFrItemType);
					tbgFrItemType.keys.removeFocus(tbgFrItemType.keys._nCurrentFocus, true);
					tbgFrItemType.keys.releaseKeys();
					$("txtFrItmTpDs").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgFrItemType.keys.removeFocus(tbgFrItemType.keys._nCurrentFocus, true);
					tbgFrItemType.keys.releaseKeys();
					$("txtFrItemType").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgFrItemType.keys.removeFocus(tbgFrItemType.keys._nCurrentFocus, true);
						tbgFrItemType.keys.releaseKeys();
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
					tbgFrItemType.keys.removeFocus(tbgFrItemType.keys._nCurrentFocus, true);
					tbgFrItemType.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgFrItemType.keys.removeFocus(tbgFrItemType.keys._nCurrentFocus, true);
					tbgFrItemType.keys.releaseKeys();
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
					tbgFrItemType.keys.removeFocus(tbgFrItemType.keys._nCurrentFocus, true);
					tbgFrItemType.keys.releaseKeys();
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
					id : "frItemType",
					title : "Item Type",
					filterOption : true,
					width : '80px'
				},
				{
					id : 'frItemTypeDs',
					filterOption : true,
					title : 'Description',
					width : 394
				},
				{
					id : 'fiItmGrpDesc',
					filterOption : true,
					title : 'Item Group',
					width : 198
				}
			],
			rows : objGiiss012.frItemTypeList.rows
		};

		tbgFrItemType = new MyTableGrid(frItemTypeTable);
		tbgFrItemType.pager = objGiiss012.frItemTypeList;
		tbgFrItemType.render("frItemTypeTable");
	
	function setFieldValues(rec){
		try{
			$("txtFrItemType").value = (rec == null ? "" : unescapeHTML2(rec.frItemType));
			$("txtFrItemType").setAttribute("lastValidValue", $F("txtFrItemType"));
			$("txtFrItmTpDs").value = (rec == null ? "" : unescapeHTML2(rec.frItemTypeDs));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("txtFiItmGrpDesc").value = (rec == null ? "" : unescapeHTML2(rec.fiItmGrpDesc));
			$("hidFiItemGrp").value = (rec == null ? "" : unescapeHTML2(rec.fiItemGrp));
			$("txtFiItmGrpDesc").setAttribute("lastValidValue", $("txtFiItmGrpDesc").value);
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtFrItemType").readOnly = false : $("txtFrItemType").readOnly = true;
			rec == null ? $("txtFrItmTpDs").readOnly = false : $("txtFrItmTpDs").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objFrItemType = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.frItemType = escapeHTML2($F("txtFrItemType"));
			obj.frItemTypeDs = escapeHTML2($F("txtFrItmTpDs"));
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.fiItemGrp = escapeHTML2($F("hidFiItemGrp"));
			obj.fiItmGrpDesc = escapeHTML2($F("txtFiItmGrpDesc"));
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			obj.cpiRecNo = "0";
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGiiss012;
			var dept = setRec(objFrItemType);
			if($F("btnAdd") == "Add"){
				tbgFrItemType.addBottomRow(dept);
			} else {
				tbgFrItemType.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgFrItemType.keys.removeFocus(tbgFrItemType.keys._nCurrentFocus, true);
			tbgFrItemType.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("frItemTypeFormDiv")){
				if($F("btnAdd") == "Add") {
					
					var addedSameExists = false;
					var deletedSameExists = false;	
					
					for(var i=0; i<tbgFrItemType.geniisysRows.length; i++){
						
						if(tbgFrItemType.geniisysRows[i].recordStatus == 0 || tbgFrItemType.geniisysRows[i].recordStatus == 1){
							
							if(unescapeHTML2(tbgFrItemType.geniisysRows[i].frItemType) == unescapeHTML2($F("txtFrItemType"))){
								addedSameExists = true;	
							}	
							
						} else if(tbgFrItemType.geniisysRows[i].recordStatus == -1){
							
							if(unescapeHTML2(tbgFrItemType.geniisysRows[i].frItemType) == unescapeHTML2($F("txtFrItemType"))){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same fr_item_type.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}					
					
					new Ajax.Request(contextPath + "/GIISFiItemTypeController", {
						parameters : {action : "giiss012ValAddRec",
									  frItemType : escapeHTML2($F("txtFrItemType"))},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								addRec();
							}
						}
					});
					
				} else {
					addRec();
				}
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}	
	
	function deleteRec(){
		changeTagFunc = saveGiiss012;
		objFrItemType.recordStatus = -1;
		tbgFrItemType.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISFiItemTypeController", {
				parameters : {action : "giiss012ValDelRec",
							  frItemType : $F("txtFrItemType")},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						deleteRec();
					}
				}
			});
		} catch(e){
			showErrorMessage("valDeleteRec", e);
		}
	}
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}	
	
	function cancelGiiss012(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGiiss012.exitPage = exitPage;
						saveGiiss012();
					}, function(){
						goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("txtFrItmTpDs").observe("keyup", function(){
		$("txtFrItmTpDs").value = $F("txtFrItmTpDs").toUpperCase();
	});
	
	$("txtFrItemType").observe("keyup", function(){
		$("txtFrItemType").value = $F("txtFrItemType").toUpperCase();
	});
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGiiss012);
	$("btnCancel").observe("click", cancelGiiss012);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);
	
	$("btnExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtFrItemType").focus();
	
	function getFiItemGrpLov() {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getGiiss012FiItemGrpLov",
				filterText : ($F("txtFiItmGrpDesc") == $("txtFiItmGrpDesc").readAttribute("lastValidValue") ? "" : $F("txtFiItmGrpDesc")),
				page : 1
			},
			title : "List of Item Groups",
			width : 480,
			height : 386,
			columnModel : [ {
				id : "rvLowValue",
				title : "Code",
				width : '120px',
			}, {
				id : "rvMeaning",
				title : "Description",
				width : '345px',
				renderer: function(value) {
					return unescapeHTML2(value);
				}
			} ],
			draggable : true,
			autoSelectOneRecord: true,
			filterText:  ($F("txtFiItmGrpDesc") == $("txtFiItmGrpDesc").readAttribute("lastValidValue") ? "" : $F("txtFiItmGrpDesc")),
			onSelect : function(row) {
				$("txtFiItmGrpDesc").value = row.rvMeaning;
				$("txtFiItmGrpDesc").setAttribute("lastValidValue", $("txtFiItmGrpDesc").value);
				
				$("hidFiItemGrp").value = row.rvLowValue;
				$("hidFiItemGrp").setAttribute("lastValidValue", $("hidFiItemGrp").value);
			},
			onCancel : function () {
				$("txtFiItmGrpDesc").value = $("txtFiItmGrpDesc").readAttribute("lastValidValue");
				$("hidFiItemGrp").value = $("hidFiItemGrp").readAttribute("lastValidValue");
				$("txtFiItmGrpDesc").focus();
			},
			onUndefinedRow : function(){
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtFiItmGrpDesc");
				$("txtFiItmGrpDesc").value = $("txtFiItmGrpDesc").readAttribute("lastValidValue");
				$("hidFiItemGrp").value = $("hidFiItemGrp").readAttribute("lastValidValue");
				$("txtFiItmGrpDesc").focus();
			}
		});
	}
	
	$("imgFiItemGrpDesc").observe("click", getFiItemGrpLov);
	
	$("txtFiItmGrpDesc").observe("change", function(){
		if(this.value.trim() == ""){
			$("txtFiItmGrpDesc").setAttribute("lastValidValue", "");
			$("hidFiItemGrp").setAttribute("lastValidValue", "");
			this.value = "";
			return;
		}
		
		getFiItemGrpLov();
	});
</script>