<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>

<div id="userGrpModulesDiv" name="userGrpModulesDiv">
	<div id="" class="sectionDiv" align="center" style="width:99%; margin-top: 5px;">
		<table style="margin: 10px auto;">
			<tr>
				<td class="rightAligned">
					<label style="padding-bottom: 3px;">User Group</label>
				</td>
				<td>
					<input readonly="readonly" type="text" id="modUserGrp" name="modUserGrp" style="width: 65px; float: left; height: 13px; margin-left: 2px; text-align: right;" tabindex="301"/>
				</td>
				<td>
					<input id="modUserGrpDesc" name="modUserGrpDesc" type="text" style="width: 325px; height: 13px;" readonly="readonly" tabindex="302"/>
				</td>
				<td>
					<input readonly="readonly" type="text" id="modGrpIssCd" name="modGrpIssCd" style="width: 65px; height: 13px;" tabindex="303"/>
				</td>
			</tr>
		</table>
	</div>
	
	<div class="sectionDiv" style="width: 99%;">
		<div id="userGrpModulesTableDiv" style="height: 270px; padding-top: 10px; width: 99%;">
			<div id="userGrpModulesTable" style="float: left; height: 245px; margin-left: 10px;"></div>		
		</div>
		
		<div id="userGrpModulesFormDiv" style="margin: 2px 0 8px 25px; width: 95%;">
			<table>
				<tr>
					<td></td>
					<td colspan="3">
						<input id="modIncTag" type="checkbox" style="margin-left: 3px; float:left; margin-bottom: 2px;" disabled="disabled" tabindex="304">
						<label style="margin-left: 3px; float: left; margin-bottom: 2px;" for="modIncTag">Include Tag</label>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Module ID</td>
					<td class="leftAligned">
						<input id="modModuleId" type="text" style="width: 175px; float: left; margin-left: 3px;" readonly="readonly" tabindex="305">
					</td>
					<td class="rightAligned">Access Tag</td>
					<td class="leftAligned">
						<select id="modAccessTag" class="required" style="width: 182px; height: 22px; margin-left: 3px;" tabindex="306" disabled="disabled">
							<option value=""></option>
							<c:forEach var="accessTag" items="${accessTagList}">
								<option value="${accessTag.rvLowValue}">${accessTag.rvMeaning}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Description</td>
					<td class="leftAligned" colspan="3">
						<input id="modModuleDesc" type="text" style="width: 476px; margin-left: 3px;" readonly="readonly" tabindex="307">
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Remarks</td>
					<td class="leftAligned" colspan="3">
						<div id="modRemarksDiv" name="modRemarksDiv" style="float: left; width: 482px; border: 1px solid gray; height: 22px; margin-left: 3px;">
							<textarea style="float: left; height: 16px; width: 450px; margin-top: 0; border: none;" id="modRemarks" name="modRemarks" maxlength="4000" readonly="readonly" onkeyup="limitText(this,4000);" tabindex="308"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editModRemarks"  tabindex="220"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">User ID</td>
					<td class="leftAligned">
						<input id="modUserId" type="text" style="width: 175px; margin-left: 3px;" readonly="readonly" tabindex="309">
					</td>
					<td width="111px" class="rightAligned">Last Update</td>
					<td class="leftAligned">
						<input id="modLastUpdate" type="text" style="width: 175px; margin-left: 3px;" readonly="readonly" tabindex="310">
					</td>
				</tr>
			</table>			
		</div>
		
		<div style="margin: 8px;" align="center">
			<input type="button" class="disabledButton" id="btnModUpdate" value="Update" tabindex="311">
		</div>
	</div>
	
	<div align="center">
		<input type="button" class="button" id="btnModCheckAll" value="Check All" style="width: 100px; margin-top: 10px;" tabindex="312">
		<input type="button" class="button" id="btnModUncheckAll" value="Uncheck All" style="width: 100px; margin-top: 10px;" tabindex="313">
		<input type="button" class="button" id="btnModReturn" value="Return" style="width: 80px; margin-top: 10px;" tabindex="314">
		<input type="button" class="button" id="btnModSave" value="Save" style="width: 80px; margin-top: 10px;" tabindex="315">
	</div>
</div>

<script type="text/javascript">
	var objMod = {};
	objMod.modList = JSON.parse('${modulesJSON}');

	var userGrpModModel = {
		id: 415,
		url: contextPath + "/GIISUserGroupMaintenanceController?action=showModulesOverlay&refresh=1&userGrp="+$F("txtUserGrp")+"&tranCd="+$F("tranCd"),
		options: {
			width: '590px',
			height: '232px',
			onCellFocus: function(element, value, x, y, id){
				objMod.rowIndex = y;
				setModuleFieldValues(userGrpModTG.geniisysRows[y]);
				userGrpModTG.keys.removeFocus(userGrpModTG.keys._nCurrentFocus, true);
				userGrpModTG.keys.releaseKeys();
			},
			onRemoveRowFocus: function(){
				objMod.rowIndex = -1;
				setModuleFieldValues(null);
				userGrpModTG.keys.removeFocus(userGrpModTG.keys._nCurrentFocus, true);
				userGrpModTG.keys.releaseKeys();
			},
			toolbar: {
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
				onFilter: function(){
					userGrpModTG.onRemoveRowFocus();
				}
			},
			beforeSort : function(){
				if(changeTag == 1){
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
						$("btnModSave").focus();
					});
					return false;
				}
			},
			onSort: function(){
				userGrpModTG.onRemoveRowFocus();
			},
			onRefresh: function(){
				userGrpModTG.onRemoveRowFocus();
			},				
			prePager: function(){
				if(changeTag == 1){
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
						$("btnModSave").focus();
					});
					return false;
				}
				userGrpModTG.onRemoveRowFocus();
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
			{   id: 'recordStatus',
			    width: '0',				    
			    visible: false			
			},
			{	id: 'divCtrId',
				width: '0',
				visible: false
			},
			{ 	id: 'incTag',
				align: 'center',
				altTitle: 'Access Tag',
				width: '23px',
		   		editable: false,
			    editor: new MyTableGrid.CellCheckbox({
		            getValueOf: function(value){
		            	return value ? "Y" : "N";
	            	}
			    })
			},
			{	id: 'moduleId',
				title: 'Module ID',
				width: '82px',
				filterOption: true
			},
			{	id: 'moduleDesc',
				title: 'Description',
				width: '350px',
				filterOption: true
			},
			{	id: 'accessTagDesc',
				title: 'Access Tag',
				width: '100px'
			}
		],
		rows: objMod.modList.rows
	};
	userGrpModTG = new MyTableGrid(userGrpModModel);
	userGrpModTG.pager = objMod.modList;
	userGrpModTG.render("userGrpModulesTable");

	function onOverlayLoad(){
		$("modUserGrp").value = $F("txtUserGrp");
		$("modUserGrpDesc").value = $F("txtUserGrpDesc");
		$("modGrpIssCd").value = $F("txtGrpIssCd");
		$("modModuleId").focus();
		initializeAll();
	}
	
	function setModuleFieldValues(rec){
		try{
			$("modModuleId").value = (rec == null ? "" : unescapeHTML2(rec.moduleId));
			$("modModuleDesc").value = (rec == null ? "" : unescapeHTML2(rec.moduleDesc));
			$("modRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("modUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("modLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("modIncTag").checked = (rec == null ? false : (rec.incTag == "Y" ? true : false));
			$("modAccessTag").value = (rec == null ? "" : nvl(rec.accessTag, "2"));
			
			rec == null ? $("modIncTag").disable() : $("modIncTag").enable();
			rec == null ? $("modAccessTag").disable() : $("modAccessTag").enable();
			rec == null ? $("modRemarks").readOnly = true : $("modRemarks").readOnly = false;
			rec == null ? disableButton("btnModUpdate") : enableButton("btnModUpdate");
			
			objMod.selectedRow = rec;
		}catch(e){
			showErrorMessage("setModuleFieldValues", e);
		}
	}
	
	function setUserGrpModule(rec){
		try{
			var obj = (rec == null ? {} : rec);
			
			obj.userGrp = $F("txtUserGrp");
			obj.moduleId = escapeHTML2($F("modModuleId"));
			obj.tranCd = $F("tranCd");
			obj.incTag = $("modIncTag").checked ? "Y" : "N";
			obj.accessTag = $F("modAccessTag");
			obj.accessTagDesc = $("modAccessTag").options[$("modAccessTag").selectedIndex].text;
			obj.remarks = escapeHTML2($F("modRemarks"));
			obj.userId = userId;
			
			return obj;
		} catch(e){
			showErrorMessage("setUserGrpModule", e);
		}
	}
	
	function updateRec(){		
		try{
			if(checkAllRequiredFieldsInDiv("userGrpModulesFormDiv")){
				changeTagFunc = saveUserGrpModules;
				var row = setUserGrpModule(objMod.selectedRow);
				userGrpModTG.updateVisibleRowOnly(row, objMod.rowIndex, false);
				
				changeTag = 1;
				setModuleFieldValues(null);
				userGrpModTG.keys.removeFocus(userGrpModTG.keys._nCurrentFocus, true);
				userGrpModTG.keys.releaseKeys();
			}
		}catch(e){
			showErrorMessage("updateRec", e);
		}
	}
	
	function saveUserGrpModules(){
		var modRows = getAddedAndModifiedJSONObjects(userGrpModTG.geniisysRows);
		
		new Ajax.Request(contextPath+"/GIISUserGroupMaintenanceController", {
			method: "POST",
			parameters: {
				action: "saveUserGrpModules",
				modRows: prepareJsonAsParameter(modRows)
			},
			asynchronous: false,
			evalScripts: true,
			onCreate : showNotice("Saving, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objMod.exit != null) {
							objMod.exit();
						}else{
							userGrpModTG._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	function checkUncheckModules(check){
		if(changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		}else{
			var moduleId = nvl(userGrpModTG.objFilter.moduleId, "");
			var moduleDesc = nvl(userGrpModTG.objFilter.moduleDesc, "");
			
			new Ajax.Request(contextPath+"/GIISUserGroupMaintenanceController", {
				method: "POST",
				parameters: {
					action: "checkUncheckModules",
					userGrp: $F("txtUserGrp"),
					tranCd: $F("tranCd"),
					moduleId: moduleId,
					moduleDesc: moduleDesc,
					check: check
				},
				asynchronous: false,
				evalScripts: true,
				onCreate : showNotice("Processing, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
						showWaitingMessageBox(objCommonMessage.SUCCESS, "S", function(){
							userGrpModTG._refreshList();
						});
					}
				}
			});
		}
	}

	function exitModules(){
		changeTag = 0;
		moduleOverlay.close();
		delete moduleOverlay;
		userGrpTranTG._refreshList();
	}
	
	function cancelModules(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
				function(){
					objMod.exit = exitModules;
					saveUserGrpModules();
				}, exitModules, "");
		} else {
			exitModules();
		}
	}
	
	$("modIncTag").observe("change", function(){
		$("modAccessTag").value = $("modIncTag").checked ? 1 : 2;
	});
	
	$("modAccessTag").observe("change", function(){
		$("modIncTag").checked = $("modAccessTag").value == 1 ? true : false;
	});
	
	$("editModRemarks").observe("click", function(){
		showOverlayEditor("modRemarks", 4000, $("modRemarks").hasAttribute("readonly"));
	});
	
	$("btnModCheckAll").observe("click", function(){
		checkUncheckModules("Y");
	});
	
	$("btnModUncheckAll").observe("click", function(){
		checkUncheckModules("N");
	});
	
	$("btnModUpdate").observe("click", updateRec);
	$("btnModReturn").observe("click", cancelModules);
	observeSaveForm("btnModSave", saveUserGrpModules);
	
	onOverlayLoad();
</script>