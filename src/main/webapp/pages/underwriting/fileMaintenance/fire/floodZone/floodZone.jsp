<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss053MainDiv" name="giiss053MainDiv" style="">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="floodZoneMaintenance">Exit</a></li>
			</ul>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Flood Zone Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss053" name="giiss053">		
		<div class="sectionDiv">
			<div id="floodZoneTableDiv" style="padding-top: 10px;">
				<div id="floodZoneTable" style="height: 340px; margin-left: 10px;"></div>
			</div>
			<div align="center" id="reinsurerStatusFormDiv">
				<table style="margin-top: 10px;">
					<tr>
						<td class="rightAligned">Flood Zone</td>
						<td class="leftAligned">
							<input id="txtFloodZone" type="text" class="required" style="width: 200px;" tabindex="201" maxlength="2">
						</td>
						<td class="rightAligned">Zone Group</td>
						<td>
							<!-- <input id="txtZoneGrp" type="text" style="width: 200px; text-align: right;" tabindex="202" maxlength="2"> -->
							<span class="lovSpan" style="float: left; width: 210px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input type="text" id="txtZoneGrp" name="txtZoneGrp" lastValidValue="" style="width: 175px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="202" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osZoneGrp" name="osZoneGrp" alt="Go" style="float: right;" />
							</span>
						</td>					
					</tr>	
					<tr>
						<td width="" class="rightAligned">Flood Zone Description</td>
						<td class="leftAligned" colspan="3">
							<!-- <input id="txtFloodZoneDesc" type="text" class="required" style="width: 533px;" tabindex="203" maxlength="500"> -->
							<div id="remarksDiv" name="remarksDiv" class="required" style="float: left; width: 536px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 504px; margin-top: 0; border: none;" id="txtFloodZoneDesc" name="txtFloodZoneDesc" maxlength="500"  class="required" onkeyup="limitText(this,500);" tabindex="203"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editFloodZoneDesc"  tabindex="204"/>
							</div>
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 536px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 504px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="205"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="206"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="207"></td>
						<td width="110px" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="208"></td>
					</tr>			
				</table>
			</div>
			<div class="buttonsDiv" style="margin: 10px;">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="209">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="210">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv" style="margin:10px 0 30px 10px;">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="211">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="212">
</div>
<script type="text/javascript">	
	setModuleId("GIISS053");
	setDocumentTitle("Flood Zone Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiiss053(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgFloodZone.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgFloodZone.geniisysRows);
		new Ajax.Request(contextPath+"/GIISFloodZoneController", {
			method: "POST",
			parameters : {action : "saveGiiss053",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS053.exitPage != null) {
							objGIISS053.exitPage();
						} else {
							tbgFloodZone._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss053);
	
	var objGIISS053 = {};
	var objCurrFloodZone = null;
	objGIISS053.floodZoneList = JSON.parse('${jsonFloodZoneList}') || [];
	objGIISS053.exitPage = null;
	
	var floodZoneTable = {
			url : contextPath + "/GIISFloodZoneController?action=showGiiss053&refresh=1",
			options : {
				width : '900px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrFloodZone = tbgFloodZone.geniisysRows[y];
					setFieldValues(objCurrFloodZone);
					tbgFloodZone.keys.removeFocus(tbgFloodZone.keys._nCurrentFocus, true);
					tbgFloodZone.keys.releaseKeys();
					$("txtFloodZoneDesc").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgFloodZone.keys.removeFocus(tbgFloodZone.keys._nCurrentFocus, true);
					tbgFloodZone.keys.releaseKeys();
					$("txtFloodZone").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgFloodZone.keys.removeFocus(tbgFloodZone.keys._nCurrentFocus, true);
						tbgFloodZone.keys.releaseKeys();
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
					tbgFloodZone.keys.removeFocus(tbgFloodZone.keys._nCurrentFocus, true);
					tbgFloodZone.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgFloodZone.keys.removeFocus(tbgFloodZone.keys._nCurrentFocus, true);
					tbgFloodZone.keys.releaseKeys();
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
					tbgFloodZone.keys.removeFocus(tbgFloodZone.keys._nCurrentFocus, true);
					tbgFloodZone.keys.releaseKeys();
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
					id : "floodZone",
					title : "Flood Zone",
					filterOption : true,
					width : '100px'
				},
				{
					id : 'floodZoneDesc',
					filterOption : true,
					title : 'Flood Zone Description',
					width : '660px'				
				},
				{
					id : "zoneGrp",
					title : "Zone Group",
					filterOption : true,
					width : '100px'
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
			rows : objGIISS053.floodZoneList.rows || []
		};

		tbgFloodZone = new MyTableGrid(floodZoneTable);
		tbgFloodZone.pager = objGIISS053.floodZoneList;
		tbgFloodZone.render("floodZoneTable");
	
	function setFieldValues(rec){
		try{
			$("txtFloodZone").value = (rec == null ? "" : unescapeHTML2(rec.floodZone));
			$("txtFloodZone").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.floodZone)));
			$("txtFloodZoneDesc").value = (rec == null ? "" : unescapeHTML2(rec.floodZoneDesc));
			$("txtZoneGrp").value = (rec == null ? "" : unescapeHTML2(rec.zoneGrp));
			$("txtZoneGrp").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.zoneGrp)));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtFloodZone").readOnly = false : $("txtFloodZone").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrFloodZone = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.floodZone = escapeHTML2($F("txtFloodZone"));
			obj.floodZoneDesc = escapeHTML2($F("txtFloodZoneDesc"));
			obj.zoneGrp = escapeHTML2($F("txtZoneGrp"));
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.userId = escapeHTML2(userId);
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGiiss053;
			var dept = setRec(objCurrFloodZone);
			if($F("btnAdd") == "Add"){
				tbgFloodZone.addBottomRow(dept);
			} else {
				tbgFloodZone.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgFloodZone.keys.removeFocus(tbgFloodZone.keys._nCurrentFocus, true);
			tbgFloodZone.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("reinsurerStatusFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;
					var fieldItem = null;
					
					for(var i=0; i<tbgFloodZone.geniisysRows.length; i++){
						if(tbgFloodZone.geniisysRows[i].recordStatus == 0 || tbgFloodZone.geniisysRows[i].recordStatus == 1){								
							if(unescapeHTML2(tbgFloodZone.geniisysRows[i].floodZone) == $F("txtFloodZone")){
								addedSameExists = true;
								fieldItem = "flood_zone";
								break;
							}// added for flood_zone_desc
							else if(unescapeHTML2(tbgFloodZone.geniisysRows[i].floodZoneDesc).toUpperCase() == $F("txtFloodZoneDesc").toUpperCase()){
								addedSameExists = true;
								fieldItem = "flood_zone_desc";
								break;
							}
						} else if(tbgFloodZone.geniisysRows[i].recordStatus == -1){
							if(unescapeHTML2(tbgFloodZone.geniisysRows[i].floodZone) == $F("txtFloodZone")){
								deletedSameExists = true;
								fieldItem = "flood_zone";
								break;
							}else if(unescapeHTML2(tbgFloodZone.geniisysRows[i].floodZoneDesc).toUpperCase() == $F("txtFloodZoneDesc").toUpperCase()){
								deletedSameExists = true;
								fieldItem = "flood_zone_desc";
								break;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same "+fieldItem+".", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					
					new Ajax.Request(contextPath + "/GIISFloodZoneController", {
						parameters : {action : "valAddRec",
									  floodZone : $F("txtFloodZone"),
									  floodZoneDesc: $F("txtFloodZoneDesc")},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								addRec();
							}
						}
					});
				} else {
					//addRec();
					
					var addedSameExists = false;
					var deletedSameExists = false;	
					var ignoreThis = false;
					var fieldItem = "";
					
					for(var i=0; i<tbgFloodZone.geniisysRows.length; i++){
						if(tbgFloodZone.geniisysRows[i].recordStatus == 0 || tbgFloodZone.geniisysRows[i].recordStatus == 1){		
							if(unescapeHTML2(tbgFloodZone.geniisysRows[i].floodZone) != $F("txtFloodZone") &&
									unescapeHTML2(tbgFloodZone.geniisysRows[i].floodZoneDesc).toUpperCase() == $F("txtFloodZoneDesc").toUpperCase()){
								addedSameExists = true;
								fieldItem = "flood_zone_desc";
								break;
							}
							if(unescapeHTML2(tbgFloodZone.geniisysRows[i].floodZone) == $F("txtFloodZone") &&
									unescapeHTML2(tbgFloodZone.geniisysRows[i].floodZoneDesc).toUpperCase() == $F("txtFloodZoneDesc").toUpperCase()){
								ignoreThis = true;
								break;
							}
						} else if(tbgFloodZone.geniisysRows[i].recordStatus == -1){
							if(unescapeHTML2(tbgFloodZone.geniisysRows[i].floodZone) != $F("txtFloodZone") &&
									unescapeHTML2(tbgFloodZone.geniisysRows[i].floodZoneDesc).toUpperCase() == $F("txtFloodZoneDesc").toUpperCase()){
								deletedSameExists = true;
								fieldItem = "flood_zone_desc";
								break;
							}
							if(unescapeHTML2(tbgFloodZone.geniisysRows[i].floodZone) == $F("txtFloodZone") &&
									unescapeHTML2(tbgFloodZone.geniisysRows[i].floodZoneDesc).toUpperCase() == $F("txtFloodZoneDesc").toUpperCase()){
								ignoreThis = true;
								break;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same "+fieldItem+".", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					
					if(!addedSameExists && !deletedSameExists && ignoreThis){
						addRec();
						return;
					}
					
					new Ajax.Request(contextPath + "/GIISFloodZoneController", {
						parameters : {action : "valAddRec",
									  floodZone : null,
									  floodZoneDesc: $F("txtFloodZoneDesc")},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								addRec();
							}
						}
					});
				}
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}	
	
	function deleteRec(){
		changeTagFunc = saveGiiss053;
		objCurrFloodZone.recordStatus = -1;
		tbgFloodZone.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISFloodZoneController", {
				parameters : {action : "valDeleteRec",
							  floodZone : $F("txtFloodZone")},
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
	
	function cancelGiiss053(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS053.exitPage = exitPage;
						saveGiiss053();
					}, function(){
						goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
	}
	
	function showGIISS053ZoneGrpLOV(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getGIISS053ZoneGrpLOV",
							filterText : ($("txtZoneGrp").readAttribute("lastValidValue").trim() != $F("txtZoneGrp").trim() ? $F("txtZoneGrp").trim() : ""),
							page : 1},
			title: "List of Zone Groups",
			width: 500,
			height: 400,
			columnModel : [
							{
								id : "rvLowValue",
								title: "Zone Value",
								width: '100px',
								filterOption: true
							},
							{
								id : "rvMeaning",
								title: "Zone Meaning",
								width: '370px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("txtZoneGrp").readAttribute("lastValidValue").trim() != $F("txtZoneGrp").trim() ? $F("txtZoneGrp").trim() : ""),
				onSelect: function(row) {
					$("txtZoneGrp").value = row.rvLowValue;
					$("txtZoneGrp").setAttribute("lastValidValue", row.rvLowValue);								
				},
				onCancel: function (){
					$("txtZoneGrp").value = $("txtZoneGrp").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtZoneGrp").value = $("txtZoneGrp").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("editFloodZoneDesc").observe("click", function(){
		showOverlayEditor("txtFloodZoneDesc", 500, $("txtFloodZoneDesc").hasAttribute("readonly"));
	});
	
	$("txtFloodZoneDesc").observe("keyup", function(){
		$("txtFloodZoneDesc").value = $F("txtFloodZoneDesc").toUpperCase();
	});
	
	$("txtFloodZone").observe("keyup", function(){
		$("txtFloodZone").value = $F("txtFloodZone").toUpperCase();
	});
	$("txtZoneGrp").observe("keyup", function(){
		$("txtZoneGrp").value = $F("txtZoneGrp").toUpperCase();
	});
	
	$("osZoneGrp").observe("click", showGIISS053ZoneGrpLOV);
	
	$("txtZoneGrp").observe("change", function() {		
		if($F("txtZoneGrp").trim() == "") {
			$("txtZoneGrp").value = "";
			$("txtZoneGrp").setAttribute("lastValidValue", "");
		} else {
			if($F("txtZoneGrp").trim() != "" && $F("txtZoneGrp") != $("txtZoneGrp").readAttribute("lastValidValue")) {
				showGIISS053ZoneGrpLOV();
			}
		}
	});	 	
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGiiss053);
	$("btnCancel").observe("click", cancelGiiss053);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("floodZoneMaintenance").stopObserving("click");
	$("floodZoneMaintenance").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtFloodZone").focus();	
</script>