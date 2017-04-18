<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="gicls172MainDiv" name="gicls172MainDiv" style="">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="menuFileMaintenanceExit">Exit</a></li>
				</ul>
			</div>
		</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Repair Type Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="gicls172" name="gicls172">		
		<div class="sectionDiv">
			<div id="repairTypeDiv" style="padding-top: 10px;">
				<div id="repairTypeTable" style="height: 340px; margin-left: 115px;"></div>
			</div>
			<div align="center" id="repairTypeFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Repair Code</td>
						<td class="leftAligned">
							<input id="txtRepairCode" type="text" class="required" style="width: 200px; text-align: left;" tabindex="201" maxlength="2">
						</td>
						<td class="rightAligned">
							
						</td>
						<td class="leftAligned">
							<input id="chkRequired" type="checkbox" checked="checked" style="float: left; margin: 0 7px 5px 5px;">
							<label for="chkRequired" style="margin: 0 4px 7px 2px;">Required</label>
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Repair Description</td>
						<td class="leftAligned" colspan="3">
							<input id="txtRepairDesc" type="text" class="required" style="width: 533px;" tabindex="203" maxlength="30">
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
						<td width="113px;" class="rightAligned">Last Update</td>
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
	setModuleId("GICLS172");
	setDocumentTitle("Repair Type Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGicls172(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgRepairType.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgRepairType.geniisysRows);
		new Ajax.Request(contextPath+"/GICLRepairTypeController", {
			method: "POST",
			parameters : {action : "saveGicls172",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGICLS172.exitPage != null) {
							objGICLS172.exitPage();
						} else {
							tbgRepairType._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGICLS172);
	
	var objGICLS172 = {};
	var objCurrRepairType = null;
	objGICLS172.repairTypeList = JSON.parse('${jsonRepairTypeList}');
	objGICLS172.exitPage = null;
	
	var repairTypeTable = {
			url : contextPath + "/GICLRepairTypeController?action=showGicls172&refresh=1",
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrRepairType = tbgRepairType.geniisysRows[y];
					setFieldValues(objCurrRepairType);
					tbgRepairType.keys.removeFocus(tbgRepairType.keys._nCurrentFocus, true);
					tbgRepairType.keys.releaseKeys();
					$("txtRepairDesc").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgRepairType.keys.removeFocus(tbgRepairType.keys._nCurrentFocus, true);
					tbgRepairType.keys.releaseKeys();
					$("txtRepairCode").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgRepairType.keys.removeFocus(tbgRepairType.keys._nCurrentFocus, true);
						tbgRepairType.keys.releaseKeys();
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
					tbgRepairType.keys.removeFocus(tbgRepairType.keys._nCurrentFocus, true);
					tbgRepairType.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgRepairType.keys.removeFocus(tbgRepairType.keys._nCurrentFocus, true);
					tbgRepairType.keys.releaseKeys();
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
					tbgRepairType.keys.removeFocus(tbgRepairType.keys._nCurrentFocus, true);
					tbgRepairType.keys.releaseKeys();
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
				    id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
				    width: '0',				    
				    visible : false			
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},	
				{	id: 'required',
					title: "R",
					titleAlign: 'center',
					altTitle: 'Required',
					width: '30px',
					visible: true,
					sortable: false,
					defaultValue: false,
					editable: false,
					otherValue: false,
			    	editor: new MyTableGrid.CellCheckbox({
				        getValueOf: function(value){
				        	if (value){
								return "Y";
			            	}else{
								return "N";	
			            	}
				        }
			    	})
				},	
				{
					id : "repairCode",
					title : "Repair Code",
					filterOption : true,
					width : '180px'
				},
				{
					id : 'repairDesc',
					filterOption : true,
					title : 'Repair Description',
					width : '450px'				
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
			rows : objGICLS172.repairTypeList.rows
		};

		tbgRepairType = new MyTableGrid(repairTypeTable);
		tbgRepairType.pager = objGICLS172.repairTypeList;
		tbgRepairType.render("repairTypeTable");
	
	function setFieldValues(rec){
		try{
			$("txtRepairCode").value 	= (rec == null ? "" : unescapeHTML2(rec.repairCode));
			$("txtRepairCode").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.repairCode)));
			$("txtRepairDesc").value 	= (rec == null ? "" : unescapeHTML2(rec.repairDesc));
			$("txtUserId").value 		= (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value 	= (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value 		= (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("chkRequired").checked 	=  rec == null ? false : (rec.required == 'Y' ? true : false);
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtRepairCode").readOnly = false : $("txtRepairCode").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrRepairType = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.repairCode 	= escapeHTML2($F("txtRepairCode"));
			obj.repairDesc 	= escapeHTML2($F("txtRepairDesc"));
			obj.required 	= $("chkRequired").checked ? "Y" : "N";
			obj.remarks 	= escapeHTML2($F("txtRemarks"));
			obj.userId 		= userId;
			var lastUpdate 	= new Date();
			obj.lastUpdate 	= dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGicls172;
			var dept = setRec(objCurrRepairType);
			if($F("btnAdd") == "Add"){
				tbgRepairType.addBottomRow(dept);
			} else {
				tbgRepairType.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgRepairType.keys.removeFocus(tbgRepairType.keys._nCurrentFocus, true);
			tbgRepairType.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("repairTypeFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;					
					
					for(var i=0; i<tbgRepairType.geniisysRows.length; i++){
						if(tbgRepairType.geniisysRows[i].recordStatus == 0 || tbgRepairType.geniisysRows[i].recordStatus == 1){								
							if(tbgRepairType.geniisysRows[i].repairCode == $F("txtRepairCode")){
								addedSameExists = true;								
							}							
						} else if(tbgRepairType.geniisysRows[i].recordStatus == -1){
							if(tbgRepairType.geniisysRows[i].repairCode == $F("txtRepairCode")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same repair_cd.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GICLRepairTypeController", {
						parameters : {action : "valAddRec",
									  repairCode : $F("txtRepairCode")},
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
		changeTagFunc = saveGicls172;
		objCurrRepairType.recordStatus = -1;
		tbgRepairType.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GICLRepairTypeController", {
				parameters : {action : "valDeleteRec",
							  repairCode : $F("txtRepairCode")},
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
	
	function cancelGicls172(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGICLS172.exitPage = exitPage;
						saveGicls172();
					}, function(){
						goToModule("/GIISUserController?action=goToClaims", "Claims Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", null);
		}
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("txtRepairDesc").observe("keyup", function(){
		$("txtRepairDesc").value = $F("txtRepairDesc").toUpperCase();
	});
	
	$("txtRepairCode").observe("keyup", function(){
		$("txtRepairCode").value = $F("txtRepairCode").toUpperCase();
	});
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGicls172);
	$("btnCancel").observe("click", cancelGicls172);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("menuFileMaintenanceExit").stopObserving("click");
	$("menuFileMaintenanceExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtRepairCode").focus();	
</script>