<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss215MainDiv" name="giiss215MainDiv" style="">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="btnExit">Exit</a></li>
			</ul>
		</div>
	</div>

	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Area Code Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss215" name="giiss215">		
		<div class="sectionDiv">
			<div id="bancAreaTableDiv" style="padding-top: 10px;">
				<div id="bancAreaTable" style="height: 331px; margin-left: 110px;"></div>
			</div>
			<div align="center" id="bancAreaFormDiv">
				<table style="margin-top: 15px;">
					<tr>
						<td class="rightAligned">Area Code</td>
						<td class="leftAligned">
							<input id="txtAreaCd" type="text" class="integerNoNegativeUnformatted" style="width: 200px; text-align: right;" tabindex="201" maxlength="4" readonly="readonly">
						</td>
						<td class="rightAligned">Effectivity Date</td>
						<td class="leftAligned">
							<div style="float: left; width: 206px; height: 21px; margin: 0;" class="withIconDiv required">
								<input type="text" id="txtEffDate" class="withIcon required" readonly="readonly" style="width: 181px;" tabindex="202"/>
								<img id="imgEffDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Effectivity Date" style="margin-top: 1px; cursor: pointer;" />
							</div>
						</td>
						<td rowspan="4">
							<img style="margin: 0; margin-left: 30px; cursor: pointer;" id="imgHistory" src="${pageContext.request.contextPath}/images/misc/history.PNG" alt="History"  tabindex="208"/>
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Area Description</td>
						<td class="leftAligned" colspan="3">
							<input id="txtAreaDesc" type="text" class="required" style="width: 533px;" tabindex="203" maxlength="100" lastValue="">
						</td>
					</tr>				
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="2000"  onkeyup="limitText(this,2000);" tabindex="204"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="206"></td>
						<td width="113px" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="207"></td>
					</tr>
				</table>
			</div>
			<div style="margin: 10px; text-align: center;">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="209">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="210">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="211">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="212">
</div>
<script type="text/javascript">	
	setModuleId("GIISS215");
	setDocumentTitle("Area Code Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiiss215(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgBancArea.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgBancArea.geniisysRows);
		new Ajax.Request(contextPath+"/GIISBancAreaController", {
			method: "POST",
			parameters : {action : "saveGiiss215",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGiiss215.exitPage != null) {
							objGiiss215.exitPage();
						} else {
							tbgBancArea._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss215);
	
	//var objGiiss215 = {};
	objGiiss215 = new Object();
	var objBancArea = null;
	objGiiss215.bancAreaList = JSON.parse('${jsonBancArea}');
	objGiiss215.exitPage = null;
	
	var bancAreaTable = {
			url : contextPath + "/GIISBancAreaController?action=showGiiss215&refresh=1",
			options : {
				width : 716,
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objBancArea = tbgBancArea.geniisysRows[y];
					setFieldValues(objBancArea);
					tbgBancArea.keys.removeFocus(tbgBancArea.keys._nCurrentFocus, true);
					tbgBancArea.keys.releaseKeys();
					$("txtAreaDesc").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgBancArea.keys.removeFocus(tbgBancArea.keys._nCurrentFocus, true);
					tbgBancArea.keys.releaseKeys();
					$("txtAreaCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgBancArea.keys.removeFocus(tbgBancArea.keys._nCurrentFocus, true);
						tbgBancArea.keys.releaseKeys();
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
					tbgBancArea.keys.removeFocus(tbgBancArea.keys._nCurrentFocus, true);
					tbgBancArea.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgBancArea.keys.removeFocus(tbgBancArea.keys._nCurrentFocus, true);
					tbgBancArea.keys.releaseKeys();
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
					tbgBancArea.keys.removeFocus(tbgBancArea.keys._nCurrentFocus, true);
					tbgBancArea.keys.releaseKeys();
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
					id : "areaCd",
					title : "Area Code",
					titleAlign: "right",
					filterOption : true,
					filterOptionType : "integerNoNegative",
					width : '80px',
					align: "right",
					renderer: function(val){
						return val == "" ? "" : formatNumberDigits(val, 4);
					}
				},
				{
					id : 'areaDesc',
					filterOption : true,
					title : 'Area Description',
					width : 488
				},
				{
					id : "effDate",
					filterOption : true,
					filterOptionType : "formattedDate",
					title : 'Effectivity Date',
					width : 120,
					align: "center",
					titleAlign: "center",
					renderer: function(val){
						return val == "" ? "" : dateFormat(val, "mm-dd-yyyy");
					}
				}
			],
			rows : objGiiss215.bancAreaList.rows
		};

		tbgBancArea = new MyTableGrid(bancAreaTable);
		tbgBancArea.pager = objGiiss215.bancAreaList;
		tbgBancArea.render("bancAreaTable");
	
	function setFieldValues(rec){
		try{
			objGiiss215.areaCd = (rec == null ? "" : rec.areaCd);
			$("txtAreaCd").value = (rec == null ? "" : rec.areaCd != "" ? formatNumberDigits(rec.areaCd, 4) : "");
			$("txtAreaCd").setAttribute("lastValidValue", (rec == null ? "" : rec.areaCd));
			$("txtAreaDesc").value = (rec == null ? "" : unescapeHTML2(rec.areaDesc));
			$("txtAreaDesc").setAttribute("lastValue", (rec == null ? "" : unescapeHTML2(rec.areaDesc)));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("txtEffDate").value = (rec == null ? "" : dateFormat(rec.effDate, "mm-dd-yyyy"));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			//rec == null ? $("txtAreaCd").readOnly = false : $("txtAreaCd").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objBancArea = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.oldAreaDesc = escapeHTML2($("txtAreaDesc").readAttribute("lastValue"));
			obj.areaCd = $F("txtAreaCd");
			obj.areaDesc = escapeHTML2($F("txtAreaDesc"));
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.effDate = $F("txtEffDate");
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
			changeTagFunc = saveGiiss215;
			var dept = setRec(objBancArea);
			if($F("btnAdd") == "Add"){
				tbgBancArea.addBottomRow(dept);
			} else {
				tbgBancArea.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgBancArea.keys.removeFocus(tbgBancArea.keys._nCurrentFocus, true);
			tbgBancArea.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	/* function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("bancAreaFormDiv")){
				if($F("btnAdd") == "Add") {
					
					var addedSameExists = false;
					var deletedSameExists = false;	
					
					for(var i=0; i<tbgBancArea.geniisysRows.length; i++){
						
						if(tbgBancArea.geniisysRows[i].recordStatus == 0 || tbgBancArea.geniisysRows[i].recordStatus == 1){
							
							if(tbgBancArea.geniisysRows[i].areaDesc == $F("txtAreaDesc")){
								addedSameExists = true;	
							}	
							
						} else if(tbgBancArea.geniisysRows[i].recordStatus == -1){
							
							if(tbgBancArea.geniisysRows[i].areaDesc == $F("txtAreaDesc")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same area_desc.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}					
					
					new Ajax.Request(contextPath + "/GIISBancAreaController", {
						parameters : {action : "giiss215ValAddRec",
									  areaCd : removeLeadingZero($F("areaCd")),
									  areaDesc : $F("txtAreaDesc")},
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
	} */
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("bancAreaFormDiv")){
				
				var addedSameExists = false;
				var deletedSameExists = false;
				var updatedSameExists = false;
				
				for(var i=0; i<tbgBancArea.geniisysRows.length; i++){
					
					if(tbgBancArea.geniisysRows[i].recordStatus == 0 || tbgBancArea.geniisysRows[i].recordStatus == 1){
						
						
						if($F("btnAdd") == "Add") {
							if(escapeHTML2(tbgBancArea.geniisysRows[i].areaDesc) == escapeHTML2($F("txtAreaDesc"))){
								addedSameExists = true;
							} else if(escapeHTML2(tbgBancArea.geniisysRows[i].oldAreaDesc) == escapeHTML2($F("txtAreaDesc"))){
								updatedSameExists = true;	
							} 
						} else {						
							if(removeLeadingZero(tbgBancArea.geniisysRows[i].areaCd) != removeLeadingZero($F("txtAreaCd")) || tbgBancArea.geniisysRows[i].areaCd == ""){
								if(escapeHTML2(tbgBancArea.geniisysRows[i].areaDesc) == escapeHTML2($F("txtAreaDesc"))){
									addedSameExists = true;
								} else if(escapeHTML2(tbgBancArea.geniisysRows[i].oldAreaDesc) == escapeHTML2($F("txtAreaDesc"))){
									updatedSameExists = true;	
								}
							}
						}	
						
					} else if(tbgBancArea.geniisysRows[i].recordStatus == -1){
						
						if(escapeHTML2(tbgBancArea.geniisysRows[i].areaDesc) == escapeHTML2($F("txtAreaDesc"))){
							deletedSameExists = true;
						}
					}
				}
				
				if(addedSameExists){
					showMessageBox("Record already exists with the same area_desc.", "E");
					return;
				} else if(updatedSameExists && !addedSameExists){
					addRec();
					return;
				} else if(deletedSameExists && !addedSameExists){
					addRec();
					return;
				}
				
				new Ajax.Request(contextPath + "/GIISBancAreaController", {
					parameters : {action : "giiss215ValAddRec",
								  areaCd : removeLeadingZero($F("txtAreaCd")),
								  areaDesc : $F("txtAreaDesc")},
					onCreate : showNotice("Processing, please wait..."),
					onComplete : function(response){
						hideNotice();
						if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
							addRec();
						}
					}
				});
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}
	
	function deleteRec(){
		changeTagFunc = saveGiiss215;
		objBancArea.recordStatus = -1;
		tbgBancArea.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		if($F("txtAreaCd")!= "")
			showMessageBox("You cannot delete this record.");
		else
			deleteRec();
	}
	
	function exitPage(){
		delete objGiiss215;
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}	
	
	function cancelGiiss215(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGiiss215.exitPage = exitPage;
						saveGiiss215();
					}, function(){
						goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 2000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("txtAreaDesc").observe("keyup", function(){
		$("txtAreaDesc").value = $F("txtAreaDesc").toUpperCase();
	});
	
	$("txtAreaCd").observe("keyup", function(){
		$("txtAreaCd").value = $F("txtAreaCd").toUpperCase();
	});
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGiiss215);
	$("btnCancel").observe("click", cancelGiiss215);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);
	
	$("btnExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	$("txtAreaCd").focus();
	
	$("imgEffDate").observe("click", function(){
		if ($("imgEffDate").disabled == true)
			return;
		scwShow($("txtEffDate"), this, null);
	});
	
	$("imgHistory").observe("click", function(){
		if(rowIndex == -1)return;
		try {
			overlayHistory  = 
				Overlay.show(contextPath+"/GIISBancAreaController", {
					urlContent: true,
					urlParameters: {action : "showGiiss215History",
									areaCd : removeLeadingZero($F("txtAreaCd")),
									ajax : "1"
					},
				    title: "History",
				    height: 250,
				    width: 634,
				    draggable: true
				});
			} catch (e) {
				showErrorMessage("imgHistory" , e);
			}		
	});
	
	observeBackSpaceOnDate("txtEffDate");
</script>