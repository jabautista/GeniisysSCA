<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss056MainDiv" name="giiss056MainDiv" style="">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="btnExit">Exit</a></li>
			</ul>
		</div>
	</div>

	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Subline Type Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss056" name="giiss056">		
		<div class="sectionDiv">
			<div id="assuredGroupTableDiv" style="padding-top: 10px;">
				<div id="assuredGroupTable" style="height: 331px; margin-left: 115px;"></div>
			</div>
			<div align="center" id="mcSublineTypeFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Subline Code</td>
						<td class="leftAligned">
							<span class="lovSpan required" style="width: 206px; margin: 0; height: 21px;">
								<input type="text" id="txtSublineCd" class="required" ignoreDelKey="true" style="width: 181px; float: left; border: none; height: 14px; margin: 0;" lastValidValue="" tabindex="100" maxlength="7"/> 
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSublineCd" alt="Go" style="float: right;"/>
							</span>
						</td>
						<td class="rightAligned">CV Type</td>
						<td class="leftAligned">
							<input id="txtSublineTypeCd" type="text" class="required" style="margin: 0;width: 200px;" tabindex="102" maxlength="3">
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Description</td>
						<td class="leftAligned" colspan="3">
							<input id="txtSublineTypeDesc" type="text" class="required" style="width: 533px;" tabindex="103" maxlength="20">
						</td>
					</tr>				
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="104"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="105"></td>
						<td width="113px" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="106"></td>
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
	setModuleId("GIISS056");
	setDocumentTitle("Subline Type Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiiss056(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgMcSublineType.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgMcSublineType.geniisysRows);
		new Ajax.Request(contextPath+"/GIISMCSublineTypeController", {
			method: "POST",
			parameters : {action : "saveGiiss056",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGiiss056.exitPage != null) {
							objGiiss056.exitPage();
						} else {
							tbgMcSublineType._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss056);
	
	var objGiiss056 = {};
	var objMcSublineType = null;
	objGiiss056.mcSublineTypeList = JSON.parse('${jsonGiisMcSublineType}');
	objGiiss056.exitPage = null;
	
	var assuredGroupTable = {
			url : contextPath + "/GIISMCSublineTypeController?action=showGiiss056&refresh=1",
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objMcSublineType = tbgMcSublineType.geniisysRows[y];
					setFieldValues(objMcSublineType);
					tbgMcSublineType.keys.removeFocus(tbgMcSublineType.keys._nCurrentFocus, true);
					tbgMcSublineType.keys.releaseKeys();
					$("txtSublineTypeDesc").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgMcSublineType.keys.removeFocus(tbgMcSublineType.keys._nCurrentFocus, true);
					tbgMcSublineType.keys.releaseKeys();
					$("txtSublineCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgMcSublineType.keys.removeFocus(tbgMcSublineType.keys._nCurrentFocus, true);
						tbgMcSublineType.keys.releaseKeys();
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
					tbgMcSublineType.keys.removeFocus(tbgMcSublineType.keys._nCurrentFocus, true);
					tbgMcSublineType.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgMcSublineType.keys.removeFocus(tbgMcSublineType.keys._nCurrentFocus, true);
					tbgMcSublineType.keys.releaseKeys();
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
					tbgMcSublineType.keys.removeFocus(tbgMcSublineType.keys._nCurrentFocus, true);
					tbgMcSublineType.keys.releaseKeys();
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
					id : "sublineCd",
					title : "Subline Code",
					filterOption : true,
					width : 100
				},
				{
					id : "sublineTypeCd",
					title : "CV Type",
					filterOption : true,
					width : 100
				},
				{
					id : "sublineTypeDesc",
					title : "Description",
					filterOption : true,
					width : 472
				}
			],
			rows : objGiiss056.mcSublineTypeList.rows
		};

		tbgMcSublineType = new MyTableGrid(assuredGroupTable);
		tbgMcSublineType.pager = objGiiss056.mcSublineTypeList;
		tbgMcSublineType.render("assuredGroupTable");
	
	function setFieldValues(rec){
		try{
			$("txtSublineCd").value = (rec == null ? "" : unescapeHTML2(rec.sublineCd));
			$("txtSublineCd").setAttribute("lastValidValue", $F("txtSublineCd"));
			$("txtSublineTypeCd").value = (rec == null ? "" : unescapeHTML2(rec.sublineTypeCd));
			$("txtSublineTypeCd").setAttribute("lastValidValue", $F("txtSublineTypeCd"));
			$("txtSublineTypeDesc").value = (rec == null ? "" : unescapeHTML2(rec.sublineTypeDesc));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtSublineCd").readOnly = false : $("txtSublineCd").readOnly = true;
			rec == null ? enableSearch("imgSublineCd") : disableSearch("imgSublineCd");
			rec == null ? $("txtSublineTypeCd").readOnly = false : $("txtSublineTypeCd").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objMcSublineType = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.sublineCd = $F("txtSublineCd");
			obj.sublineTypeCd = escapeHTML2($F("txtSublineTypeCd"));
			obj.sublineTypeDesc = escapeHTML2($F("txtSublineTypeDesc"));
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
			changeTagFunc = saveGiiss056;
			var dept = setRec(objMcSublineType);
			if($F("btnAdd") == "Add"){
				tbgMcSublineType.addBottomRow(dept);
			} else {
				tbgMcSublineType.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgMcSublineType.keys.removeFocus(tbgMcSublineType.keys._nCurrentFocus, true);
			tbgMcSublineType.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}
	
	function valAddRec(){
		
		if(!checkAllRequiredFieldsInDiv("mcSublineTypeFormDiv"))
			return;
		
		var addedSameExists = false;
		var deletedSameExists = false;
		var errorType = "";
		
		for(var i=0; i<tbgMcSublineType.geniisysRows.length; i++){
			if($F("btnAdd") == "Add"){
				if(tbgMcSublineType.geniisysRows[i].recordStatus == 0 || tbgMcSublineType.geniisysRows[i].recordStatus == 1){
					
					if(tbgMcSublineType.geniisysRows[i].sublineCd == $F("txtSublineCd")){
						
						if(tbgMcSublineType.geniisysRows[i].sublineTypeCd == $F("txtSublineTypeCd")){
							addedSameExists = true;
							errorType = "type";
						} else if (tbgMcSublineType.geniisysRows[i].sublineTypeDesc == $F("txtSublineTypeDesc")){
							addedSameExists = true;
							errorType = "desc";
						}
					}
				} else if(tbgMcSublineType.geniisysRows[i].recordStatus == -1){
						if(tbgMcSublineType.geniisysRows[i].sublineCd == $F("txtSublineCd")){
						
						if(tbgMcSublineType.geniisysRows[i].sublineTypeCd == $F("txtSublineTypeCd")){
							deletedSameExists = true;
							errorType = "type";
						} else if (tbgMcSublineType.geniisysRows[i].sublineTypeDesc == $F("txtSublineTypeDesc")){
							deletedSameExists = true;
							errorType = "desc";
						}
					}
				}
			} else {
				if(tbgMcSublineType.geniisysRows[i].recordStatus == 0 || tbgMcSublineType.geniisysRows[i].recordStatus == 1){
					
					if(tbgMcSublineType.geniisysRows[i].sublineCd == $F("txtSublineCd")){
						
						if(rowIndex != i){
							if(tbgMcSublineType.geniisysRows[i].sublineTypeCd == $F("txtSublineTypeCd")){
								addedSameExists = true;
								errorType = "type";
							} else if (tbgMcSublineType.geniisysRows[i].sublineTypeDesc == $F("txtSublineTypeDesc")){
								addedSameExists = true;
								errorType = "desc";
							}	
						}
					}
				} else if(tbgMcSublineType.geniisysRows[i].recordStatus == -1){
					
					if(tbgMcSublineType.geniisysRows[i].sublineCd == $F("txtSublineCd")){
					
						if(rowIndex != i){
							if(tbgMcSublineType.geniisysRows[i].sublineTypeCd == $F("txtSublineTypeCd")){
								deletedSameExists = true;
								errorType = "type";
							} else if (tbgMcSublineType.geniisysRows[i].sublineTypeDesc == $F("txtSublineTypeDesc")){
								deletedSameExists = true;
								errorType = "desc";
							}	
						}
					}
				}
			}
		}
		
		if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
			if(errorType == "type")
				showMessageBox("Record already exists with the same subline_cd and subline_type_cd.", "E");
			else
				showMessageBox("Subline Description must be unique per subline.", "E");
			
			return;
		} else if(deletedSameExists && !addedSameExists){
			addRec();
			return;
		}
		
		new Ajax.Request(contextPath + "/GIISMCSublineTypeController", {
			parameters : {action : "giiss056ValSublineTypeCd",
						  sublineCd : $F("txtSublineCd"),
						  oldSublineTypeCd : rowIndex != -1 ? escapeHTML2(tbgMcSublineType.geniisysRows[rowIndex].sublineTypeCd) : "",
						  newSublineTypeCd : escapeHTML2($F("txtSublineTypeCd")),
						  oldSublineTypeDesc : rowIndex != -1 ? escapeHTML2(tbgMcSublineType.geniisysRows[rowIndex].sublineTypeDesc) : "",
						  newSublineTypeDesc : escapeHTML2($F("txtSublineTypeDesc")),
						  pAction : $F("btnAdd")
						  
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					addRec();
				}
			}
		});
	}
	
	function deleteRec(){
		changeTagFunc = saveGiiss056;
		objMcSublineType.recordStatus = -1;
		tbgMcSublineType.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISMCSublineTypeController", {
				parameters : {action : "giiss056ValDelRec",
							  sublineTypeCd : $F("txtSublineTypeCd")},
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
	
	function cancelGiiss056(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGiiss056.exitPage = exitPage;
						saveGiiss056();
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
	
	$("txtSublineTypeDesc").observe("keyup", function(){
		$("txtSublineTypeDesc").value = $F("txtSublineTypeDesc").toUpperCase();
	});
	
	$("txtSublineCd").observe("keyup", function(){
		$("txtSublineCd").value = $F("txtSublineCd").toUpperCase();
	});
	
	$("txtSublineTypeCd").observe("keyup", function(){
		$("txtSublineTypeCd").value = $F("txtSublineTypeCd").toUpperCase();
	});
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGiiss056);
	$("btnCancel").observe("click", cancelGiiss056);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);
	
	$("btnExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtSublineCd").focus();
	
	function getSublineLov() {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getGiiss056SublineCdLov",
				filterText : ($F("txtSublineCd") == $("txtSublineCd").readAttribute("lastValidValue") ? "" : $F("txtSublineCd")),
				page : 1
			},
			title : "List of Sublines",
			width : 480,
			height : 386,
			columnModel : [ {
				id : "sublineCd",
				title : "Code",
				width : '120px',
			}, {
				id : "sublineName",
				title : "Description",
				width : '345px',
				renderer: function(value) {
					return unescapeHTML2(value);
				}
			} ],
			draggable : true,
			autoSelectOneRecord: true,
			filterText:  ($F("txtSublineCd") == $("txtSublineCd").readAttribute("lastValidValue") ? "" : $F("txtSublineCd")),
			onSelect : function(row) {
				$("txtSublineCd").value = unescapeHTML2(row.sublineCd);
				$("txtSublineCd").setAttribute("lastValidValue", $F("txtSublineCd"));
			},
			onCancel : function () {
				$("txtSublineCd").value = $("txtSublineCd").readAttribute("lastValidValue");
				$("txtSublineCd").focus();
			},
			onUndefinedRow : function(){
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtSublineCd");
				$("txtSublineCd").value = $("txtSublineCd").readAttribute("lastValidValue");
				$("txtSublineCd").focus();				
			}
		});
	}
	
	$("imgSublineCd").observe("click", getSublineLov);
	
	$("txtSublineCd").observe("change", function(){
		if(this.value.trim() == ""){
			$("txtSublineCd").clear();
			$("txtSublineCd").setAttribute("lastValidValue", "");
			return;
		}
		
		getSublineLov();
	});
</script>