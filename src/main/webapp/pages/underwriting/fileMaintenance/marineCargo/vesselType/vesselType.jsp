<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss077MainDiv" name="giiss077MainDiv" style="">
	<div id="vesselTypeTableGridDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="menuFileMaintenanceExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Vessel Type Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss077" name="giiss077">		
		<div class="sectionDiv">
			<div id="vesselTypeTableDiv" style="padding-top: 10px;">
				<div id="vesselTypeTable" style="height: 340px; margin-left: 115px;"></div>
			</div>
			<div align="center" id="vesselTypeFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Vessel Type</td>
						<td class="leftAligned" colspan="3">
							<input id="txtVestypeCd" type="text" class="required" style="width: 200px;" tabindex="201" maxlength="2">
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Vessel Description</td>
						<td class="leftAligned" colspan="3">
							<input id="txtVestypeDesc" type="text" class="required" style="width: 533px;" tabindex="203" maxlength="30">
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
						<td class="leftAligned" style="width: 254px;"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="206"></td>
						<td width="" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="207"></td>
					</tr>			
				</table>
			</div>
			<div align="center" style="margin: 10px;">
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
	setModuleId("GIISS077");
	setDocumentTitle("Vessel Type Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiiss077(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgVesselType.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgVesselType.geniisysRows);
		new Ajax.Request(contextPath+"/GIISVesTypeController", {
			method: "POST",
			parameters : {action : "saveGiiss077",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS077.exitPage != null) {
							objGIISS077.exitPage();
						} else {
							tbgVesselType._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss077);
	
	var objGIISS077 = {};
	var objCurrVesselType = null;
	objGIISS077.vesselTypeList = JSON.parse('${jsonVesselTypeList}');
	objGIISS077.exitPage = null;
	
	var vesselTypeTable = {
			url : contextPath + "/GIISVesTypeController?action=showGiiss077&refresh=1",
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrVesselType = tbgVesselType.geniisysRows[y];
					setFieldValues(objCurrVesselType);
					tbgVesselType.keys.removeFocus(tbgVesselType.keys._nCurrentFocus, true);
					tbgVesselType.keys.releaseKeys();
					$("txtVestypeDesc").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgVesselType.keys.removeFocus(tbgVesselType.keys._nCurrentFocus, true);
					tbgVesselType.keys.releaseKeys();
					$("txtVestypeCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgVesselType.keys.removeFocus(tbgVesselType.keys._nCurrentFocus, true);
						tbgVesselType.keys.releaseKeys();
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
					tbgVesselType.keys.removeFocus(tbgVesselType.keys._nCurrentFocus, true);
					tbgVesselType.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgVesselType.keys.removeFocus(tbgVesselType.keys._nCurrentFocus, true);
					tbgVesselType.keys.releaseKeys();
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
					tbgVesselType.keys.removeFocus(tbgVesselType.keys._nCurrentFocus, true);
					tbgVesselType.keys.releaseKeys();
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
					id : "vestypeCd",
					title : "Vessel Type",
					filterOption : true,
					width : '80px'
				},
				{
					id : 'vestypeDesc',
					filterOption : true,
					title : 'Vessel Description',
					width : '585px'				
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
			rows : objGIISS077.vesselTypeList.rows
		};

		tbgVesselType = new MyTableGrid(vesselTypeTable);
		tbgVesselType.pager = objGIISS077.vesselTypeList;
		tbgVesselType.render("vesselTypeTable");
	
	function setFieldValues(rec){
		try{
			$("txtVestypeCd").value = (rec == null ? "" : unescapeHTML2(rec.vestypeCd));
			$("txtVestypeCd").setAttribute("lastValidValue", (rec == null ? "" : rec.vestypeCd));
			$("txtVestypeDesc").value = (rec == null ? "" : unescapeHTML2(rec.vestypeDesc));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtVestypeCd").readOnly = false : $("txtVestypeCd").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrVesselType = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.vestypeCd = escapeHTML2($F("txtVestypeCd"));
			obj.vestypeDesc = escapeHTML2($F("txtVestypeDesc"));
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
			changeTagFunc = saveGiiss077;
			var dept = setRec(objCurrVesselType);
			if($F("btnAdd") == "Add"){
				tbgVesselType.addBottomRow(dept);
			} else {
				tbgVesselType.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgVesselType.keys.removeFocus(tbgVesselType.keys._nCurrentFocus, true);
			tbgVesselType.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("vesselTypeFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;					
					
					for(var i=0; i<tbgVesselType.geniisysRows.length; i++){
						if(tbgVesselType.geniisysRows[i].recordStatus == 0 || tbgVesselType.geniisysRows[i].recordStatus == 1){								
							if(tbgVesselType.geniisysRows[i].vestypeCd == $F("txtVestypeCd")){
								addedSameExists = true;								
							}							
						} else if(tbgVesselType.geniisysRows[i].recordStatus == -1){
							if(tbgVesselType.geniisysRows[i].vestypeCd == $F("txtVestypeCd")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same vestype_cd.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					
					new Ajax.Request(contextPath + "/GIISVesTypeController", {
						parameters : {action : "valAddRec",
									  vestypeCd : $F("txtVestypeCd")},
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
		changeTagFunc = saveGiiss077;
		objCurrVesselType.recordStatus = -1;
		tbgVesselType.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISVesTypeController", {
				parameters : {action : "valDeleteRec",
							  vestypeCd : $F("txtVestypeCd")},
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
	
	function cancelGiiss077(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS077.exitPage = exitPage;
						saveGiiss077();
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
	
	$("txtVestypeDesc").observe("keyup", function(){
		$("txtVestypeDesc").value = $F("txtVestypeDesc").toUpperCase();
	});
	
	$("txtVestypeCd").observe("keyup", function(){
		$("txtVestypeCd").value = $F("txtVestypeCd").toUpperCase();
	});
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGiiss077);
	$("btnCancel").observe("click", cancelGiiss077);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("menuFileMaintenanceExit").stopObserving("click");
	$("menuFileMaintenanceExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtVestypeCd").focus();	
</script>