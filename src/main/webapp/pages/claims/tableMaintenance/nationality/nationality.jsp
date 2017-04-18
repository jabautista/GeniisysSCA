<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="gicls184MainDiv" name="gicls184MainDiv" style="">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="menuFileMaintenanceExit">Exit</a></li>
				</ul>
			</div>
		</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Nationality Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="gicls184" name="gicls184">		
		<div class="sectionDiv">
			<div id="nationalityeDiv" style="padding-top: 10px;">
				<div id="nationalityeTable" style="height: 340px; margin-left: 115px;"></div>
			</div>
			<div align="center" id="nationalityeFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Nationality Code</td>
						<td class="leftAligned">
							<input id="txtNationalityCode" type="text" class="required" style="width: 200px; text-align: left;" tabindex="201" maxlength="2">
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Nationality Description</td>
						<td class="leftAligned" colspan="3">
							<input id="txtNationalityDesc" type="text" class="required" style="width: 533px;" tabindex="203" maxlength="30">
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
						<td width="110px;" class="rightAligned">Last Update</td>
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
	setModuleId("GICLS184");
	setDocumentTitle("Nationality Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGicls184(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgNationality.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgNationality.geniisysRows);
		new Ajax.Request(contextPath+"/GIISNationalityController", {
			method: "POST",
			parameters : {action : "saveGicls184",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGICLS184.exitPage != null) {
							objGICLS184.exitPage();
						} else {
							tbgNationality._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGICLS184);
	
	var objGICLS184 = {};
	var objCurrNationality = null;
	objGICLS184.nationalityList = JSON.parse('${jsonNationalityList}');
	objGICLS184.exitPage = null;
	
	var nationalityeTable = {
			url : contextPath + "/GIISNationalityController?action=showGicls184&refresh=1",
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrNationality = tbgNationality.geniisysRows[y];
					setFieldValues(objCurrNationality);
					tbgNationality.keys.removeFocus(tbgNationality.keys._nCurrentFocus, true);
					tbgNationality.keys.releaseKeys();
					$("txtNationalityDesc").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgNationality.keys.removeFocus(tbgNationality.keys._nCurrentFocus, true);
					tbgNationality.keys.releaseKeys();
					$("txtNationalityCode").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgNationality.keys.removeFocus(tbgNationality.keys._nCurrentFocus, true);
						tbgNationality.keys.releaseKeys();
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
					tbgNationality.keys.removeFocus(tbgNationality.keys._nCurrentFocus, true);
					tbgNationality.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgNationality.keys.removeFocus(tbgNationality.keys._nCurrentFocus, true);
					tbgNationality.keys.releaseKeys();
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
					tbgNationality.keys.removeFocus(tbgNationality.keys._nCurrentFocus, true);
					tbgNationality.keys.releaseKeys();
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
				{
					id : "nationalityCd",
					title : "Nationality Code",
					filterOption : true,
					width : '180px'
				},
				{
					id : 'nationalityDesc',
					filterOption : true,
					title : 'Nationality Description',
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
			rows : objGICLS184.nationalityList.rows
		};

		tbgNationality = new MyTableGrid(nationalityeTable);
		tbgNationality.pager = objGICLS184.nationalityList;
		tbgNationality.render("nationalityeTable");
	
	function setFieldValues(rec){
		try{
			$("txtNationalityCode").value = (rec == null ? "" : unescapeHTML2(rec.nationalityCd));
			$("txtNationalityCode").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.nationalityCd)));
			$("txtNationalityDesc").value = (rec == null ? "" : unescapeHTML2(rec.nationalityDesc));
			$("txtUserId").value 		  = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value 	  = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value 		  = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtNationalityCode").readOnly = false : $("txtNationalityCode").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrNationality = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.nationalityCd 	= escapeHTML2($F("txtNationalityCode"));
			obj.nationalityDesc = escapeHTML2($F("txtNationalityDesc"));
			obj.remarks 		= escapeHTML2($F("txtRemarks"));
			obj.userId 			= userId;
			var lastUpdate 		= new Date();
			obj.lastUpdate 		= dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGicls184;
			var dept = setRec(objCurrNationality);
			if($F("btnAdd") == "Add"){
				tbgNationality.addBottomRow(dept);
			} else {
				tbgNationality.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgNationality.keys.removeFocus(tbgNationality.keys._nCurrentFocus, true);
			tbgNationality.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("nationalityeFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;					
					
					for(var i=0; i<tbgNationality.geniisysRows.length; i++){
						if(tbgNationality.geniisysRows[i].recordStatus == 0 || tbgNationality.geniisysRows[i].recordStatus == 1){								
							if(tbgNationality.geniisysRows[i].nationalityCd == $F("txtNationalityCode")){
								addedSameExists = true;								
							}							
						} else if(tbgNationality.geniisysRows[i].recordStatus == -1){
							if(tbgNationality.geniisysRows[i].nationalityCd == $F("txtNationalityCode")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same nationality_cd.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GIISNationalityController", {
						parameters : {action : "valAddRec",
									  nationalityCd : $F("txtNationalityCode")},
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
		changeTagFunc = saveGicls184;
		objCurrNationality.recordStatus = -1;
		tbgNationality.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISNationalityController", {
				parameters : {action : "valDeleteRec",
							  nationalityCd : $F("txtNationalityCode")},
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
	
	function cancelGicls184(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGICLS184.exitPage = exitPage;
						saveGicls184();
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
	
	$("txtNationalityDesc").observe("keyup", function(){
		$("txtNationalityDesc").value = $F("txtNationalityDesc").toUpperCase();
	});
	
	$("txtNationalityCode").observe("keyup", function(){
		$("txtNationalityCode").value = $F("txtNationalityCode").toUpperCase();
	});
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGicls184);
	$("btnCancel").observe("click", cancelGicls184);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("menuFileMaintenanceExit").stopObserving("click");
	$("menuFileMaintenanceExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtNationalityCode").focus();	
</script>