<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="gicls101MainDiv" name="gicls101MainDiv" style="">
	<div id="gicls101Div">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="gicls101Exit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Recovery Type Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="gicls101" name="gicls101">		
		<div class="sectionDiv">
			<div id="recoveryTypeTableDiv" style="padding-top: 10px;">
				<div id="recoveryTypeTable" style="height: 340px; margin-left: 115px;"></div>
			</div>
			<div align="center" id="recoveryTypeTypeFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Recovery Type</td>
						<td class="leftAligned" colspan="3">
							<input id="txtRecoveryTypeCd" type="text" class="required" style="width: 200px;" tabindex="101" maxlength="5">
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Description</td>
						<td class="leftAligned" colspan="3">
							<input id="txtRecoveryTypeDesc" type="text" class="required" style="width: 533px;" tabindex="102" maxlength="50">
						</td>
					</tr>				
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="103"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="104"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="105"></td>
						<td width="" class="rightAligned" style="padding-left: 47px">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="106"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;" align = "center">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="107">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="108">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="109">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="110">
</div>
<script type="text/javascript">	
	setModuleId("GICLS101");
	setDocumentTitle("Recovery Type Maintenance");
	initializeAll();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGicls101(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgRecoveryType.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgRecoveryType.geniisysRows);
		new Ajax.Request(contextPath+"/GIISRecoveryTypeController", {
			method: "POST",
			parameters : {action : "saveGicls101",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGICLS101.exitPage != null) {
							objGICLS101.exitPage();
						} else {
							tbgRecoveryType._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showMenuRecoveryType);
	
	var objGICLS101 = {};
	var objCurrRecoveryType = null;
	objGICLS101.recoveryTypeList = JSON.parse('${jsonRecoveryType}');
	objGICLS101.exitPage = null;
	
	var recoveryTypeTable = {
			url : contextPath + "/GIISRecoveryTypeController?action=showMenuRecoveryType&refresh=1",
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrRecoveryType = tbgRecoveryType.geniisysRows[y];
					setFieldValues(objCurrRecoveryType);
					tbgRecoveryType.keys.removeFocus(tbgRecoveryType.keys._nCurrentFocus, true);
					tbgRecoveryType.keys.releaseKeys();
					$("txtRecoveryTypeDesc").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgRecoveryType.keys.removeFocus(tbgRecoveryType.keys._nCurrentFocus, true);
					tbgRecoveryType.keys.releaseKeys();
					$("txtRecoveryTypeCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgRecoveryType.keys.removeFocus(tbgRecoveryType.keys._nCurrentFocus, true);
						tbgRecoveryType.keys.releaseKeys();
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
					tbgRecoveryType.keys.removeFocus(tbgRecoveryType.keys._nCurrentFocus, true);
					tbgRecoveryType.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgRecoveryType.keys.removeFocus(tbgRecoveryType.keys._nCurrentFocus, true);
					tbgRecoveryType.keys.releaseKeys();
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
					tbgRecoveryType.keys.removeFocus(tbgRecoveryType.keys._nCurrentFocus, true);
					tbgRecoveryType.keys.releaseKeys();
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
					id : "recTypeCd",
					title : "Recovery Type",
					filterOption : true,
					width : '150px'
				},
				{
					id : 'recTypeDesc',
					title : 'Description',
					filterOption : true,
					width : '500px'				
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
			rows : objGICLS101.recoveryTypeList.rows
		};

		tbgRecoveryType = new MyTableGrid(recoveryTypeTable);
		tbgRecoveryType.pager = objGICLS101.recoveryTypeList;
		tbgRecoveryType.render("recoveryTypeTable");
	
	function setFieldValues(rec){
		try{
			$("txtRecoveryTypeCd").value = (rec == null ? "" : unescapeHTML2(rec.recTypeCd));
			$("txtRecoveryTypeCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.recTypeCd)));
			$("txtRecoveryTypeDesc").value = (rec == null ? "" : unescapeHTML2(rec.recTypeDesc));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtRecoveryTypeCd").readOnly = false : $("txtRecoveryTypeCd").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrRecoveryType = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.recTypeCd = escapeHTML2($F("txtRecoveryTypeCd"));
			obj.recTypeDesc = escapeHTML2($F("txtRecoveryTypeDesc"));
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
			changeTagFunc = saveGicls101;
			var dept = setRec(objCurrRecoveryType);
			if($F("btnAdd") == "Add"){
				tbgRecoveryType.addBottomRow(dept);
			} else {
				tbgRecoveryType.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgRecoveryType.keys.removeFocus(tbgRecoveryType.keys._nCurrentFocus, true);
			tbgRecoveryType.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("recoveryTypeTypeFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;					
					
					for(var i=0; i<tbgRecoveryType.geniisysRows.length; i++){
						if(tbgRecoveryType.geniisysRows[i].recordStatus == 0 || tbgRecoveryType.geniisysRows[i].recordStatus == 1){								
							if(tbgRecoveryType.geniisysRows[i].recTypeCd == $F("txtRecoveryTypeCd")){
								addedSameExists = true;								
							}							
						} else if(tbgRecoveryType.geniisysRows[i].recordStatus == -1){
							if(tbgRecoveryType.geniisysRows[i].recTypeCd == $F("txtRecoveryTypeCd")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same rec_type_cd.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GIISRecoveryTypeController", {
						parameters : {action : "valAddRec",
									  recTypeCd : $F("txtRecoveryTypeCd")},
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
		changeTagFunc = saveGicls101;
		objCurrRecoveryType.recordStatus = -1;
		tbgRecoveryType.deleteRow(rowIndex);
		tbgRecoveryType.geniisysRows[rowIndex].recTypeCd = escapeHTML2($F("txtRecoveryTypeCd"));
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISRecoveryTypeController", {
				parameters : {action : "valDeleteRec",
							  recTypeCd : $F("txtRecoveryTypeCd")},
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
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", null);
	}	
	
	function cancelGicls101(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGICLS101.exitPage = exitPage;
						saveGicls101();
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
	
	$("txtRecoveryTypeDesc").observe("keyup", function(){
		$("txtRecoveryTypeDesc").value = $F("txtRecoveryTypeDesc").toUpperCase();
	});
	
	$("txtRecoveryTypeCd").observe("keyup", function(){
		$("txtRecoveryTypeCd").value = $F("txtRecoveryTypeCd").toUpperCase();
	});
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGicls101);
	$("btnCancel").observe("click", cancelGicls101);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("gicls101Exit").stopObserving("click");
	$("gicls101Exit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtRecoveryTypeCd").focus();	
</script>