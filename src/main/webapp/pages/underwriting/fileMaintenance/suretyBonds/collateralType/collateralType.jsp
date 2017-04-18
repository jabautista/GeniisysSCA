<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss102MainDiv" name="giiss102MainDiv" style="">
	<div id="collateralTypeDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="collateralTypeExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Collateral Type Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss102" name="giiss102">		
		<div class="sectionDiv">
			<div id="collateralTypeTableDiv" style="padding-top: 10px;">
				<div id="collateralTypeTable" style="height: 340px; margin-left: 165px;"></div>
			</div>
			<div align="center" id="collateralTypeFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Collateral Type</td>
						<td class="leftAligned">
							<input id="txtCollType" type="text" class="required allCaps" style="width: 200px; " tabindex="201" maxlength="1">
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Collateral Name</td>
						<td class="leftAligned" colspan="3">
							<input id="txtCollName" type="text" class="required" style="width: 533px;" tabindex="203" maxlength="15">
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
						<td width="" class="rightAligned" style="padding-left: 48px;">Last Update</td>
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
	setModuleId("GIISS102");
	setDocumentTitle("Collateral Type Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
		
	function saveGiiss102(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgCollateralType.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgCollateralType.geniisysRows);
		new Ajax.Request(contextPath+"/GIISCollateralTypeController", {
			method: "POST",
			parameters : {action : "saveGiiss102",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS102.exitPage != null) {
							objGIISS102.exitPage();
						} else {
							tbgCollateralType._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss102);
	
	var objGIISS102 = {};
	var objCollateralType = null;
	objGIISS102.collateralTypeList = JSON.parse('${jsonCollateralList}');
	objGIISS102.exitPage = null;
	
	var collateralTypeTableModel = {
			url : contextPath + "/GIISCollateralTypeController?action=showGiiss102&refresh=1",
			options : {
				width : '593px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCollateralType = tbgCollateralType.geniisysRows[y];
					setFieldValues(objCollateralType);
					tbgCollateralType.keys.removeFocus(tbgCollateralType.keys._nCurrentFocus, true);
					tbgCollateralType.keys.releaseKeys();
					$("txtCollName").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgCollateralType.keys.removeFocus(tbgCollateralType.keys._nCurrentFocus, true);
					tbgCollateralType.keys.releaseKeys();
					$("txtCollType").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgCollateralType.keys.removeFocus(tbgCollateralType.keys._nCurrentFocus, true);
						tbgCollateralType.keys.releaseKeys();
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
					tbgCollateralType.keys.removeFocus(tbgCollateralType.keys._nCurrentFocus, true);
					tbgCollateralType.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgCollateralType.keys.removeFocus(tbgCollateralType.keys._nCurrentFocus, true);
					tbgCollateralType.keys.releaseKeys();
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
					tbgCollateralType.keys.removeFocus(tbgCollateralType.keys._nCurrentFocus, true);
					tbgCollateralType.keys.releaseKeys();
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
					id : "collType",
					title : "Type",
					filterOption : true,
					width : '80px'
				},
				{
					id : 'collName',
					filterOption : true,
					title : 'Collateral Name',
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
			rows : objGIISS102.collateralTypeList.rows
		};

		tbgCollateralType = new MyTableGrid(collateralTypeTableModel);
		tbgCollateralType.pager = objGIISS102.collateralTypeList;
		tbgCollateralType.render("collateralTypeTable");
	
	function setFieldValues(rec){
		try{
			$("txtCollType").value = (rec == null ? "" : unescapeHTML2(rec.collType));
			$("txtCollType").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.collType)));
			$("txtCollName").value = (rec == null ? "" : unescapeHTML2(rec.collName));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtCollType").readOnly = false : $("txtCollType").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCollateralType = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.collType = escapeHTML2($F("txtCollType"));
			obj.collName = escapeHTML2($F("txtCollName"));
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
			changeTagFunc = saveGiiss102;
			var dept = setRec(objCollateralType);
			if($F("btnAdd") == "Add"){
				tbgCollateralType.addBottomRow(dept);
			} else {
				tbgCollateralType.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgCollateralType.keys.removeFocus(tbgCollateralType.keys._nCurrentFocus, true);
			tbgCollateralType.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("collateralTypeFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;					
					
					for(var i=0; i<tbgCollateralType.geniisysRows.length; i++){
						if(tbgCollateralType.geniisysRows[i].recordStatus == 0 || tbgCollateralType.geniisysRows[i].recordStatus == 1){								
							if(tbgCollateralType.geniisysRows[i].collType == $F("txtCollType")){
								addedSameExists = true;								
							}							
						} else if(tbgCollateralType.geniisysRows[i].recordStatus == -1){
							if(tbgCollateralType.geniisysRows[i].collType == $F("txtCollType")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same coll_type.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					
					new Ajax.Request(contextPath + "/GIISCollateralTypeController", {
						parameters : {action : "valAddRec",
									  collType : $F("txtCollType")},
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
		changeTagFunc = saveGiiss102;
		objCollateralType.recordStatus = -1;
		tbgCollateralType.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISCollateralTypeController", {
				parameters : {action : "valDeleteRec",
							  collType : $F("txtCollType")},
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
	
	function cancelGiiss102(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS102.exitPage = exitPage;
						saveGiiss102();
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
	
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGiiss102);
	$("btnCancel").observe("click", cancelGiiss102);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("collateralTypeExit").stopObserving("click");
	$("collateralTypeExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	$("txtCollType").focus();	
</script>