<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss205MainDiv" name="giiss205MainDiv">
	<div id="giiss205MenuDiv">
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
	   		<label>Industry Group Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>
	<div id="giiss205" name="giiss205">
		<div class="sectionDiv">
			<div id="industryGroupTableDiv" style="padding-top: 10px;">
				<div id="industryGroupTable" style="height: 340px; margin-left: 140px;"></div>
			</div>
			<div align="center" id="industryGroupFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Code</td>
						<td class="leftAligned" colspan="3">
							<input id="txtIndGrpCd" type="text" class="required integerNoNegativeUnformattedNoComma" style="width: 200px; text-align: right;" tabindex="201" maxlength="3">
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Description</td>
						<td class="leftAligned" colspan="3">
							<input id="txtIndGrpNm" type="text" class="required" style="width: 533px;" tabindex="202" maxlength="20">
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="203"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="204"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned" style="width: 254px;"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="205"></td>
						<td width="" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="206"></td>
					</tr>
				</table>
			</div>
			<div align="center" style="margin: 10px;">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="207">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="208">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="209">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="210">
</div>
<script type="text/javascript">
	setModuleId("GIISS205");
	setDocumentTitle("Industry Group Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	var objGIISS205 = {};
	var objCurrIndustryGroup = null;
	objGIISS205.industryGroupList = JSON.parse('${jsonIndustryGroupList}');
	objGIISS205.exitPage = null;
	
	var industryGroupTable = {
			url : contextPath + "/GIISIndustryGroupController?action=showGiiss205&refresh=1",
			options : {
				width : '650px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrIndustryGroup = tbgIndustryGroup.geniisysRows[y];
					setFieldValues(objCurrIndustryGroup);
					tbgIndustryGroup.keys.removeFocus(tbgIndustryGroup.keys._nCurrentFocus, true);
					tbgIndustryGroup.keys.releaseKeys();
					$("txtIndGrpCd").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgIndustryGroup.keys.removeFocus(tbgIndustryGroup.keys._nCurrentFocus, true);
					tbgIndustryGroup.keys.releaseKeys();
					$("txtIndGrpCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgIndustryGroup.keys.removeFocus(tbgIndustryGroup.keys._nCurrentFocus, true);
						tbgIndustryGroup.keys.releaseKeys();
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
					tbgIndustryGroup.keys.removeFocus(tbgIndustryGroup.keys._nCurrentFocus, true);
					tbgIndustryGroup.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgIndustryGroup.keys.removeFocus(tbgIndustryGroup.keys._nCurrentFocus, true);
					tbgIndustryGroup.keys.releaseKeys();
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
					tbgIndustryGroup.keys.removeFocus(tbgIndustryGroup.keys._nCurrentFocus, true);
					tbgIndustryGroup.keys.releaseKeys();
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
					id : "indGrpCd",
					title : "Code",
					titleAlign : "right",
					filterOption : true,
					filterOptionType : 'integerNoNegative',
					align: "right",
					width : '120px'
				},
				{
					id : "indGrpNm",
					title : "Description",
					filterOption : true,
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
			rows : objGIISS205.industryGroupList.rows
	};
	tbgIndustryGroup = new MyTableGrid(industryGroupTable);
	tbgIndustryGroup.pager = objGIISS205.industryGroupList;
	tbgIndustryGroup.render("industryGroupTable");
	
	function setFieldValues(rec){
		try{
			$("txtIndGrpCd").value = (rec == null ? "" : rec.indGrpCd);
			$("txtIndGrpNm").value = (rec == null ? "" : unescapeHTML2(rec.indGrpNm));
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtIndGrpCd").readOnly = false : $("txtIndGrpCd").readOnly = true;
			rec == null ? $("txtIndGrpNm").readOnly = false : $("txtIndGrpNm").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrIndustryGroup = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("industryGroupFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;	
					
					for(var i=0; i<tbgIndustryGroup.geniisysRows.length; i++){
						if(tbgIndustryGroup.geniisysRows[i].recordStatus == 0 || tbgIndustryGroup.geniisysRows[i].recordStatus == 1){								
							if(tbgIndustryGroup.geniisysRows[i].indGrpCd == $F("txtIndGrpCd")){
								addedSameExists = true;								
							}							
						} else if(tbgIndustryGroup.geniisysRows[i].recordStatus == -1){
							if(tbgIndustryGroup.geniisysRows[i].indGrpCd == $F("txtIndGrpCd")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same ind_grp_cd.", "E");
						return;
					}
					
					addedSameExists = false;
					deletedSameExists = false;	
					
					for(var i=0; i<tbgIndustryGroup.geniisysRows.length; i++){
						if(tbgIndustryGroup.geniisysRows[i].recordStatus == 0 || tbgIndustryGroup.geniisysRows[i].recordStatus == 1){								
							if(tbgIndustryGroup.geniisysRows[i].indGrpNm == $F("txtIndGrpNm")){
								addedSameExists = true;								
							}							
						} else if(tbgIndustryGroup.geniisysRows[i].recordStatus == -1){
							if(tbgIndustryGroup.geniisysRows[i].indGrpNm == $F("txtIndGrpNm")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same ind_grp_nm.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					
					new Ajax.Request(contextPath + "/GIISIndustryGroupController", {
						parameters : {
							action : "valAddRec",
							indGrpCd : $F("txtIndGrpCd"),
							indGrpNm : $F("txtIndGrpNm")
						},
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
	
	function addRec(){
		try {
			changeTagFunc = saveGiiss205;
			var industryGroup = setRec(objCurrIndustryGroup);
			if($F("btnAdd") == "Add"){
				tbgIndustryGroup.addBottomRow(industryGroup);
			} else {
				tbgIndustryGroup.updateVisibleRowOnly(industryGroup, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgIndustryGroup.keys.removeFocus(tbgIndustryGroup.keys._nCurrentFocus, true);
			tbgIndustryGroup.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.indGrpCd = escapeHTML2($F("txtIndGrpCd"));
			obj.indGrpNm = escapeHTML2($F("txtIndGrpNm"));
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISIndustryGroupController", {
				parameters : {
					action : "valDeleteRec",
					indGrpCd : $F("txtIndGrpCd")
				},
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
	
	function deleteRec(){
		changeTagFunc = saveGiiss205;
		objCurrIndustryGroup.recordStatus = -1;
		tbgIndustryGroup.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function saveGiiss205(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgIndustryGroup.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgIndustryGroup.geniisysRows);

		new Ajax.Request(contextPath+"/GIISIndustryGroupController", {
			method: "POST",
			parameters : {
				action : "saveGiiss205",
				setRows : prepareJsonAsParameter(setRows),
				delRows : prepareJsonAsParameter(delRows)
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS205.exitPage != null) {
							objGIISS205.exitPage();
						} else {
							tbgIndustryGroup._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}
	
	function cancelGiiss205(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS205.exitPage = exitPage;
						saveGiiss205();
					}, function(){
						goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
	}
	
	observeReloadForm("reloadForm", showGiiss205);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);
	observeSaveForm("btnSave", saveGiiss205);
	$("btnCancel").observe("click", cancelGiiss205);
	
	$("menuFileMaintenanceExit").stopObserving("click");
	$("menuFileMaintenanceExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	$("txtIndGrpNm").observe("keyup", function(){
		$("txtIndGrpNm").value = $F("txtIndGrpNm").toUpperCase();
	});
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	disableButton("btnDelete");
	$("txtIndGrpCd").focus();
</script>