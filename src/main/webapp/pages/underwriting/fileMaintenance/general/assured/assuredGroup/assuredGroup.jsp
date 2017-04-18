<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss118MainDiv" name="giiss118MainDiv" style="">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="btnExit">Exit</a></li>
			</ul>
		</div>
	</div>

	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Assured Group Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss118" name="giiss118">		
		<div class="sectionDiv">
			<div id="assuredGroupTableDiv" style="padding-top: 10px;">
				<div id="assuredGroupTable" style="height: 331px; margin-left: 115px;"></div>
			</div>
			<div align="center" id="assuredGroupFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Code</td>
						<td class="leftAligned">
							<input id="txtGroupCd" type="text" class="required integerNoNegativeUnformatted" style="width: 200px; text-align: right;" tabindex="201" maxlength="4">
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Group Description</td>
						<td class="leftAligned" colspan="3">
							<input id="txtGroupDesc" type="text" class="required" style="width: 533px;" tabindex="203" maxlength="50">
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
	setModuleId("GIISS118");
	setDocumentTitle("Assured Group Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiiss118(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgAssuredGroup.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgAssuredGroup.geniisysRows);
		new Ajax.Request(contextPath+"/GIISGroupController", {
			method: "POST",
			parameters : {action : "saveGiiss118",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGiiss118.exitPage != null) {
							objGiiss118.exitPage();
						} else {
							tbgAssuredGroup._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss118);
	
	var objGiiss118 = {};
	var objAssuredGroup = null;
	objGiiss118.assuredGroupList = JSON.parse('${jsonAssuredGroup}');
	objGiiss118.exitPage = null;
	
	var assuredGroupTable = {
			url : contextPath + "/GIISGroupController?action=showGiiss118&refresh=1",
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objAssuredGroup = tbgAssuredGroup.geniisysRows[y];
					setFieldValues(objAssuredGroup);
					tbgAssuredGroup.keys.removeFocus(tbgAssuredGroup.keys._nCurrentFocus, true);
					tbgAssuredGroup.keys.releaseKeys();
					$("txtGroupDesc").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgAssuredGroup.keys.removeFocus(tbgAssuredGroup.keys._nCurrentFocus, true);
					tbgAssuredGroup.keys.releaseKeys();
					$("txtGroupCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgAssuredGroup.keys.removeFocus(tbgAssuredGroup.keys._nCurrentFocus, true);
						tbgAssuredGroup.keys.releaseKeys();
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
					tbgAssuredGroup.keys.removeFocus(tbgAssuredGroup.keys._nCurrentFocus, true);
					tbgAssuredGroup.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgAssuredGroup.keys.removeFocus(tbgAssuredGroup.keys._nCurrentFocus, true);
					tbgAssuredGroup.keys.releaseKeys();
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
					tbgAssuredGroup.keys.removeFocus(tbgAssuredGroup.keys._nCurrentFocus, true);
					tbgAssuredGroup.keys.releaseKeys();
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
					id : "groupCd",
					title : "Code",
					titleAlign: "right",
					filterOption : true,
					filterOptionType : "integerNoNegative",
					width : '80px',
					align: "right",
					renderer: function(val){
						return formatNumberDigits(val, 4);
					}
				},
				{
					id : 'groupDesc',
					filterOption : true,
					title : 'Group Description',
					width : 610,
					renderer: function(val){
						return unescapeHTML2(val);
					}
				}
			],
			rows : objGiiss118.assuredGroupList.rows
		};

		tbgAssuredGroup = new MyTableGrid(assuredGroupTable);
		tbgAssuredGroup.pager = objGiiss118.assuredGroupList;
		tbgAssuredGroup.render("assuredGroupTable");
	
	function setFieldValues(rec){
		try{
			$("txtGroupCd").value = (rec == null ? "" : rec.groupCd);
			$("txtGroupCd").setAttribute("lastValidValue", (rec == null ? "" : rec.groupCd));
			$("txtGroupDesc").value = (rec == null ? "" : unescapeHTML2(rec.groupDesc));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtGroupCd").readOnly = false : $("txtGroupCd").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objAssuredGroup = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.groupCd = $F("txtGroupCd");
			obj.groupDesc = escapeHTML2($F("txtGroupDesc"));
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
			changeTagFunc = saveGiiss118;
			var dept = setRec(objAssuredGroup);
			if($F("btnAdd") == "Add"){
				tbgAssuredGroup.addBottomRow(dept);
			} else {
				tbgAssuredGroup.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgAssuredGroup.keys.removeFocus(tbgAssuredGroup.keys._nCurrentFocus, true);
			tbgAssuredGroup.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("assuredGroupFormDiv")){
				if($F("btnAdd") == "Add") {
					
					var addedSameExists = false;
					var deletedSameExists = false;	
					
					for(var i=0; i<tbgAssuredGroup.geniisysRows.length; i++){
						
						if(tbgAssuredGroup.geniisysRows[i].recordStatus == 0 || tbgAssuredGroup.geniisysRows[i].recordStatus == 1){
							
							if(tbgAssuredGroup.geniisysRows[i].groupCd == $F("txtGroupCd")){
								addedSameExists = true;	
							}	
							
						} else if(tbgAssuredGroup.geniisysRows[i].recordStatus == -1){
							
							if(tbgAssuredGroup.geniisysRows[i].groupCd == $F("txtGroupCd")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same class_cd.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}					
					
					new Ajax.Request(contextPath + "/GIISGroupController", {
						parameters : {action : "valAddRec",
									  groupCd : $F("txtGroupCd")},
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
		changeTagFunc = saveGiiss118;
		objAssuredGroup.recordStatus = -1;
		tbgAssuredGroup.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISGroupController", {
				parameters : {action : "valDeleteRec",
							  groupCd : $F("txtGroupCd")},
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
	
	function cancelGiiss118(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGiiss118.exitPage = exitPage;
						saveGiiss118();
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
	
	$("txtGroupDesc").observe("keyup", function(){
		$("txtGroupDesc").value = $F("txtGroupDesc").toUpperCase();
	});
	
	$("txtGroupCd").observe("keyup", function(){
		$("txtGroupCd").value = $F("txtGroupCd").toUpperCase();
	});
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGiiss118);
	$("btnCancel").observe("click", cancelGiiss118);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);
	
	$("btnExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtGroupCd").focus();	
</script>