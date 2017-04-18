<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss063MainDiv" name="giiss063MainDiv" style="">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="menuFileMaintenanceExit">Exit</a></li>
			</ul>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Peril Class Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss063" name="giiss063">		
		<div class="sectionDiv">
			<div id="perilClassTableDiv" style="padding-top: 10px;">
				<div id="perilClassTable" style="height: 340px; margin-left: 115px;"></div>
			</div>
			<div align="center" id="perilClassFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Class Code</td>
						<td class="leftAligned">
							<input id="txtClassCd" type="text" class="required" style="width: 200px; " tabindex="201" maxlength="3">
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Class Description</td>
						<td class="leftAligned" colspan="3">
							<input id="txtClassDesc" type="text" class="required" style="width: 533px;" tabindex="203" maxlength="50">
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
						<td class="rightAligned" width="113px">Last Update</td>
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
	setModuleId("GIISS063");
	setDocumentTitle("Peril Class Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiiss063(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgPerilClass.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgPerilClass.geniisysRows);
		new Ajax.Request(contextPath+"/GIISClassController", {
			method: "POST",
			parameters : {action : "saveGiiss063",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS063.exitPage != null) {
							objGIISS063.exitPage();
						} else {
							tbgPerilClass._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss063);
	
	var objGIISS063 = {};
	var objCurrPerilClass = null;
	objGIISS063.classList = JSON.parse('${jsonClassList}');
	objGIISS063.exitPage = null;
	
	var perilClassTable = {
			url : contextPath + "/GIISClassController?action=showGiiss063&refresh=1",
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrPerilClass = tbgPerilClass.geniisysRows[y];
					setFieldValues(objCurrPerilClass);
					tbgPerilClass.keys.removeFocus(tbgPerilClass.keys._nCurrentFocus, true);
					tbgPerilClass.keys.releaseKeys();
					$("txtClassDesc").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgPerilClass.keys.removeFocus(tbgPerilClass.keys._nCurrentFocus, true);
					tbgPerilClass.keys.releaseKeys();
					$("txtClassCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgPerilClass.keys.removeFocus(tbgPerilClass.keys._nCurrentFocus, true);
						tbgPerilClass.keys.releaseKeys();
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
					tbgPerilClass.keys.removeFocus(tbgPerilClass.keys._nCurrentFocus, true);
					tbgPerilClass.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgPerilClass.keys.removeFocus(tbgPerilClass.keys._nCurrentFocus, true);
					tbgPerilClass.keys.releaseKeys();
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
					tbgPerilClass.keys.removeFocus(tbgPerilClass.keys._nCurrentFocus, true);
					tbgPerilClass.keys.releaseKeys();
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
					id : "classCd",
					title : "Class Code",
					filterOption : true,
					width : '100px'
				},
				{
					id : 'classDesc',
					filterOption : true,
					title : 'Class Description',
					width : '550px'				
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
			rows : objGIISS063.classList.rows
		};

		tbgPerilClass = new MyTableGrid(perilClassTable);
		tbgPerilClass.pager = objGIISS063.classList;
		tbgPerilClass.render("perilClassTable");
	
	function setFieldValues(rec){
		try{
			$("txtClassCd").value = (rec == null ? "" : unescapeHTML2(rec.classCd));
			$("txtClassCd").setAttribute("lastValidValue", (rec == null ? "" : rec.classCd));
			$("txtClassCd").setAttribute("originalValue", (rec == null ? "" : rec.classCd)); //added to track the original value
			$("txtClassDesc").value = (rec == null ? "" : unescapeHTML2(rec.classDesc));		
			$("txtClassDesc").setAttribute("originalValue", (rec == null ? "" : rec.classDesc)); //added to track the original value
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtClassCd").readOnly = false : $("txtClassCd").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrPerilClass = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.classCd = escapeHTML2($F("txtClassCd"));
			obj.classDesc = escapeHTML2($F("txtClassDesc"));
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
			changeTagFunc = saveGiiss063;
			var dept = setRec(objCurrPerilClass);
			if($F("btnAdd") == "Add"){
				tbgPerilClass.addBottomRow(dept);
			} else {
				tbgPerilClass.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgPerilClass.keys.removeFocus(tbgPerilClass.keys._nCurrentFocus, true);
			tbgPerilClass.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	/*******************************************************************************/
	/* NOTES (debug changes): 												       */
	/* 1. allowed adding of record if class_cd and class_desc is the same with a   */
    /*    deleted record when the table is not yet saved						   */
    /* 2. included validation when user is updating a record					   */
    /* 3. original valAddRec function commented below							   */
	/*******************************************************************************/
	function valAddRec(){
		try{			
			if(checkAllRequiredFieldsInDiv("perilClassFormDiv")){
				var secondDescCondition = true;
				var secondCodeCondition = true;
				var addedSameExists = false;
				var dupField = ""; 
				
				for(var i=0; i<tbgPerilClass.geniisysRows.length; i++){			
					if($F("btnAdd") == "Update") {
						secondDescCondition = (escapeHTML2($F("txtClassDesc")) != $("txtClassDesc").getAttribute("originalValue").replace(/\\/g, "&#92;")); 
					} 
					if((tbgPerilClass.geniisysRows[i].classDesc).replace(/\\/g, "&#92;") == escapeHTML2($F("txtClassDesc")) && secondDescCondition){ //added validation for peril description
						dupField = "class_desc";
						if (tbgPerilClass.geniisysRows[i].recordStatus == 0 || tbgPerilClass.geniisysRows[i].recordStatus == 1) {
							addedSameExists = true;	
						} else if (tbgPerilClass.geniisysRows[i].recordStatus == -1){
							addedSameExists = false;	
						}
					}
					
					if($F("btnAdd") == "Update") {
						secondCodeCondition = (escapeHTML2($F("txtClassCd")) != $("txtClassCd").getAttribute("originalValue").replace(/\\/g, "&#92;")); 
					}
					if((tbgPerilClass.geniisysRows[i].classCd).replace(/\\/g, "&#92;") == escapeHTML2($F("txtClassCd")) && secondCodeCondition){
						dupField = "class_cd";
						if (tbgPerilClass.geniisysRows[i].recordStatus == 0 || tbgPerilClass.geniisysRows[i].recordStatus == 1) {
							addedSameExists = true;	
						} else if (tbgPerilClass.geniisysRows[i].recordStatus == -1){
							addedSameExists = false;	
						}
					}		
				}
				
				if(dupField != "") {				
					if (addedSameExists){
						showMessageBox("Record already exist with the same " + dupField + ".", "E");
						return;
					} else {
						addRec();
					} 
				} else {
					if($F("btnAdd") == "Add") {
						new Ajax.Request(contextPath + "/GIISClassController", {
							parameters : {action : "valAddRec",
										  classCd : $F("txtClassCd")},
							onCreate : showNotice("Processing, please wait..."),
							onComplete : function(response){
								hideNotice();
								if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
									new Ajax.Request(contextPath + "/GIISClassController", {
										parameters : {action : "valAddRec2",
													  classDesc : $F("txtClassDesc")},
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
						});
					} else {
						new Ajax.Request(contextPath + "/GIISClassController", {
							parameters : {action : "valAddRec2",
										  classDesc : $F("txtClassDesc")},
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
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}	
	
	/*function valAddRec(){
		try{			
			if(checkAllRequiredFieldsInDiv("perilClassFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;					
					
					for(var i=0; i<tbgPerilClass.geniisysRows.length; i++){
						if(tbgPerilClass.geniisysRows[i].recordStatus == 0 || tbgPerilClass.geniisysRows[i].recordStatus == 1){								
							if(tbgPerilClass.geniisysRows[i].classCd == $F("txtClassCd")){
								addedSameExists = true;								
							}							
						} else if(tbgPerilClass.geniisysRows[i].recordStatus == -1){
							if(tbgPerilClass.geniisysRows[i].classCd == $F("txtClassCd")){
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
					
					new Ajax.Request(contextPath + "/GIISClassController", {
						parameters : {action : "valAddRec",
									  classCd : $F("txtClassCd")},
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
	}*/
	
	function deleteRec(){
		changeTagFunc = saveGiiss063;
		objCurrPerilClass.recordStatus = -1;
		tbgPerilClass.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISClassController", {
				parameters : {action : "valDeleteRec",
							  classCd : $F("txtClassCd")},
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
	
	function cancelGiiss063(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS063.exitPage = exitPage;
						saveGiiss063();
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
	
	$("txtClassDesc").observe("keyup", function(){
		$("txtClassDesc").value = $F("txtClassDesc").toUpperCase();
	});
	
	$("txtClassCd").observe("keyup", function(){
		$("txtClassCd").value = $F("txtClassCd").toUpperCase();
	});
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGiiss063);
	$("btnCancel").observe("click", cancelGiiss063);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("menuFileMaintenanceExit").stopObserving("click");
	$("menuFileMaintenanceExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtClassCd").focus();	
</script>