<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss046MainDiv" name="giiss046MainDiv" style="">
	<div id="giiss046ExitDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="hullTypeMaintenanceExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Hull Type Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss046" name="giiss046">		
		<div class="sectionDiv">
			<div id="hullTypeDiv" style="padding-top: 10px;">
				<div id="hullTypeTable" style="height: 340px; margin-left: 115px;"></div>
			</div>
			<div align="center" id="hullTypeFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Hull Type</td>
						<td class="leftAligned">
							<input id="txtHullTypeCd" type="text" class="required integerNoNegativeUnformattedNoComma" style="width: 200px; text-align: right;" tabindex="201" maxlength="2">
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Hull Description</td>
						<td class="leftAligned" colspan="3">
							<input id="txtHullDesc" type="text" class="required" style="width: 533px;" tabindex="203" maxlength="20">
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
						<td width="" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 245px;" readonly="readonly" tabindex="207"></td>
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
	setModuleId("GIISS046");
	setDocumentTitle("Hull Type Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiiss046(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgHullType.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgHullType.geniisysRows);
		new Ajax.Request(contextPath+"/GIISHullTypeController", {
			method: "POST",
			parameters : {action : "saveGiiss046",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS046.exitPage != null) {
							objGIISS046.exitPage();
						} else {
							tbgHullType._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss046);
	
	var objGIISS046 = {};
	var objCurrHullType = null;
	objGIISS046.hullList = JSON.parse('${jsonHullListList}');
	objGIISS046.exitPage = null;
	
	var hullTypeTable = {
			url : contextPath + "/GIISHullTypeController?action=showGiiss046&refresh=1",
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrHullType = tbgHullType.geniisysRows[y];
					setFieldValues(objCurrHullType);
					tbgHullType.keys.removeFocus(tbgHullType.keys._nCurrentFocus, true);
					tbgHullType.keys.releaseKeys();
					$("txtHullDesc").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgHullType.keys.removeFocus(tbgHullType.keys._nCurrentFocus, true);
					tbgHullType.keys.releaseKeys();
					$("txtHullTypeCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgHullType.keys.removeFocus(tbgHullType.keys._nCurrentFocus, true);
						tbgHullType.keys.releaseKeys();
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
					tbgHullType.keys.removeFocus(tbgHullType.keys._nCurrentFocus, true);
					tbgHullType.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgHullType.keys.removeFocus(tbgHullType.keys._nCurrentFocus, true);
					tbgHullType.keys.releaseKeys();
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
					tbgHullType.keys.removeFocus(tbgHullType.keys._nCurrentFocus, true);
					tbgHullType.keys.releaseKeys();
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
					id : "hullTypeCd",
					title : "Hull Type",
					titleAlign : "right",
					align : "right",
					filterOption : true,
					filterOptionType : 'integerNoNegative',
					width : '100px',
					renderer: function(value){
						return formatNumberDigits(value, 2);
					}
				},
				{
					id : 'hullDesc',
					filterOption : true,
					title : 'Description',
					filterOption : true,
					width : '565px'				
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
			rows : objGIISS046.hullList.rows
		};

		tbgHullType = new MyTableGrid(hullTypeTable);
		tbgHullType.pager = objGIISS046.hullList;
		tbgHullType.render("hullTypeTable");
	
	function setFieldValues(rec){
		try{
			$("txtHullTypeCd").value = (rec == null ? "" : rec.hullTypeCd);
			$("txtHullTypeCd").setAttribute("lastValidValue", (rec == null ? "" : rec.hullTypeCd));
			$("txtHullDesc").value = (rec == null ? "" : unescapeHTML2(rec.hullDesc));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtHullTypeCd").readOnly = false : $("txtHullTypeCd").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrHullType = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.hullTypeCd = formatNumberDigits($F("txtHullTypeCd"), 2);
			obj.hullDesc = escapeHTML2($F("txtHullDesc"));
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
			changeTagFunc = saveGiiss046;
			var dept = setRec(objCurrHullType);
			if($F("btnAdd") == "Add"){
				tbgHullType.addBottomRow(dept);
			} else {
				tbgHullType.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgHullType.keys.removeFocus(tbgHullType.keys._nCurrentFocus, true);
			tbgHullType.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("hullTypeFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;	
					for(var i=0; i<tbgHullType.geniisysRows.length; i++){
						if(tbgHullType.geniisysRows[i].recordStatus == 0 || tbgHullType.geniisysRows[i].recordStatus == 1){	
							if(tbgHullType.geniisysRows[i].hullTypeCd == formatNumberDigits($F("txtHullTypeCd"), 2)){
								addedSameExists = true;	
							}	
						} else if(tbgHullType.geniisysRows[i].recordStatus == -1){
							if(tbgHullType.geniisysRows[i].hullTypeCd == formatNumberDigits($F("txtHullTypeCd"), 2)){
								deletedSameExists = true;
							}
						}
					}
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same hull_type_cd.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					
					new Ajax.Request(contextPath + "/GIISHullTypeController", {
						parameters : {action : "valAddRec",
									  hullTypeCd : $F("txtHullTypeCd")},
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
		changeTagFunc = saveGiiss046;
		objCurrHullType.recordStatus = -1;
		tbgHullType.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISHullTypeController", {
				parameters : {action : "valDeleteRec",
							  hullTypeCd : $F("txtHullTypeCd")},
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
	
	function cancelGiiss046(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS046.exitPage = exitPage;
						saveGiiss046();
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
	
	$("txtHullDesc").observe("keyup", function(){
		$("txtHullDesc").value = $F("txtHullDesc").toUpperCase();
	});
	
	$("txtHullTypeCd").observe("keyup", function(){
		$("txtHullTypeCd").value = $F("txtHullTypeCd").toUpperCase();
	});
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGiiss046);
	$("btnCancel").observe("click", cancelGiiss046);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("hullTypeMaintenanceExit").stopObserving("click");
	$("hullTypeMaintenanceExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	}); 
	$("txtHullTypeCd").focus();	
</script>