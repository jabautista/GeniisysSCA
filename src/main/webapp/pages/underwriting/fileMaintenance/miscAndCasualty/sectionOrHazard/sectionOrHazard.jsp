<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss020MainDiv" name="giiss020MainDiv" style="">
	<div id="sectionOrHazardExitDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="uwExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Casualty Section Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss020" name="giiss020">		
		<div class="sectionDiv">
			<div id="sectionOrHazardDiv">
				<div id="sectionOrHazardTableDiv" style="height: 331px; margin: 10px 0px 10px 137px;">
				
				</div>
			</div>
			<div align="center" id="sectionOrHazardFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Line</td>
						<td colspan="3">
							<span class="lovSpan required" style="float: left; width: 100px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input type="text" id="txtLineCd" name="txtLineCd" class="required upper" style="width: 75px; float: left; border: none; height: 15px; margin: 0; " maxlength="2" tabindex="101" lastValidValue="" ignoreDelKey="" />
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgLineCd" name="imgLineCd" alt="Go" style="float: right;" tabindex="102"/>
							</span>
							<input type="text" id="txtLineName" style="height: 15px; width: 426px;" readonly="readonly" tabindex="103"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Subline</td>
						<td colspan="3">
							<span class="lovSpan required" style="float: left; width: 100px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input type="text" id="txtSublineCd" name="txtSublineCd" class="required upper" style="width: 75px; float: left; border: none; height: 15px; margin: 0; " maxlength="7" tabindex="104" lastValidValue="" ignoreDelKey=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSublineCd" name="imgSublineCd" alt="Go" style="float: right;" tabindex="105"/>
							</span>
							<input type="text" id="txtSublineName" style="height: 15px; width: 426px;" readonly="readonly" tabindex="106"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Code/Title</td>
						<td colspan="3">
							<input id="txtSectionOrHazardCd" type="text" class="required upper" style="width: 94px; float: left;" maxlength="3" tabindex="107">
							<input id="txtSectionOrHazardTitle" type="text" class="required upper" style="width: 426px; float: left; margin-left: 5px;" maxlength="50" tabindex="108">
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="109"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="110"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td><input id="txtUserId" type="text" style="width: 200px;" readonly="readonly" tabindex="111"></td>
						<td width="117px" class="rightAligned">Last Update</td>
						<td><input id="txtLastUpdate" type="text" style="width: 200px;" readonly="readonly" tabindex="112"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;" align="center">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="113">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="114">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="115">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="116">
</div>
<script type="text/javascript">	
	setModuleId("GIISS020");
	setDocumentTitle("Casualty Section Maintenance");
	initializeAll();
	initializeAccordion();
	makeInputFieldUpperCase();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiiss020(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgSectionOrHazard.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgSectionOrHazard.geniisysRows);
		new Ajax.Request(contextPath+"/GIISSectionOrHazardController", {
			method: "POST",
			parameters : {action : "saveGiiss020",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGiiss020.exitPage != null) {
							objGiiss020.exitPage();
						} else {
							tbgSectionOrHazard._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss020);
	
	var objGiiss020 = {};
	var objCurrSectionOrHazard = null;
	objGiiss020.sectionOrHazardList = JSON.parse('${jsonSectionOrHazardList}');
	objGiiss020.exitPage = null;
	
	var sectionOrHazardTable = {
			url : contextPath + "/GIISSectionOrHazardController?action=showGiiss020&refresh=1&moduleId=GIISS020&fromMenu=N",
			options : {
				hideColumnChildTitle: true,
				width : '650px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrSectionOrHazard = tbgSectionOrHazard.geniisysRows[y];
					setFieldValues(objCurrSectionOrHazard);
					tbgSectionOrHazard.keys.removeFocus(tbgSectionOrHazard.keys._nCurrentFocus, true);
					tbgSectionOrHazard.keys.releaseKeys();
					$("txtLineCd").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgSectionOrHazard.keys.removeFocus(tbgSectionOrHazard.keys._nCurrentFocus, true);
					tbgSectionOrHazard.keys.releaseKeys();
					$("txtLineCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgSectionOrHazard.keys.removeFocus(tbgSectionOrHazard.keys._nCurrentFocus, true);
						tbgSectionOrHazard.keys.releaseKeys();
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
					tbgSectionOrHazard.keys.removeFocus(tbgSectionOrHazard.keys._nCurrentFocus, true);
					tbgSectionOrHazard.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgSectionOrHazard.keys.removeFocus(tbgSectionOrHazard.keys._nCurrentFocus, true);
					tbgSectionOrHazard.keys.releaseKeys();
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
					tbgSectionOrHazard.keys.removeFocus(tbgSectionOrHazard.keys._nCurrentFocus, true);
					tbgSectionOrHazard.keys.releaseKeys();
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
					id : 'sectionLineCd',
					title : 'Line',
					width : '80px',
					filterOption : true
				},
				{
					id : 'sectionSublineCd',
					title : 'Subline',
					width : '90px',
					filterOption : true
				},	
				{
					id : 'sectionOrHazardCd',
					title : 'Code',
					width : '80px',
					filterOption : true
				},
				{
					id : 'sectionOrHazardTitle',
					title : 'Title',
					width : '369px',
					filterOption : true
				}
			],
			rows : objGiiss020.sectionOrHazardList.rows
		};

		tbgSectionOrHazard = new MyTableGrid(sectionOrHazardTable);
		tbgSectionOrHazard.pager = objGiiss020.sectionOrHazardList;
		tbgSectionOrHazard.render("sectionOrHazardTableDiv");
	
	function setFieldValues(rec){
		try{
			$("txtLineCd").value = (rec == null ? "" : unescapeHTML2(rec.sectionLineCd));
			$("txtLineName").value = (rec == null ? "" : unescapeHTML2(rec.lineName));			
			$("txtSublineCd").value = (rec == null ? "" : unescapeHTML2(rec.sectionSublineCd));
			$("txtSublineName").value = (rec == null ? "" : unescapeHTML2(rec.sublineName));
			$("txtSectionOrHazardCd").value = (rec == null ? "" : unescapeHTML2(rec.sectionOrHazardCd));
			$("txtSectionOrHazardTitle").value = (rec == null ? "" : unescapeHTML2(rec.sectionOrHazardTitle));
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : unescapeHTML2(rec.lastUpdate));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			
			rec == null ? enableInputField("txtLineCd") : disableInputField("txtLineCd");
			rec == null ? enableSearch("imgLineCd") : disableSearch("imgLineCd");
			rec == null ? enableInputField("txtSublineCd") : disableInputField("txtSublineCd");
			rec == null ? enableSearch("imgSublineCd") : disableSearch("imgSublineCd");
			rec == null ? enableInputField("txtSectionOrHazardCd") : disableInputField("txtSectionOrHazardCd");
			
			objCurrSectionOrHazard = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.sectionLineCd = escapeHTML2($F("txtLineCd"));
			obj.lineName = escapeHTML2($F("txtLineName"));
			obj.sectionSublineCd = escapeHTML2($F("txtSublineCd"));
			obj.sublineName = escapeHTML2($F("txtSublineName"));
			obj.sectionOrHazardCd = escapeHTML2($F("txtSectionOrHazardCd"));
			obj.sectionOrHazardTitle = escapeHTML2($F("txtSectionOrHazardTitle"));
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
			changeTagFunc = saveGiiss020;
			var rec = setRec(objCurrSectionOrHazard);
			if($F("btnAdd") == "Add"){
				tbgSectionOrHazard.addBottomRow(rec);
			} else {
				tbgSectionOrHazard.updateVisibleRowOnly(rec, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			$("txtLineCd").setAttribute("lastValidValue", "");
			$("txtSublineCd").setAttribute("lastValidValue", "");
			tbgSectionOrHazard.keys.removeFocus(tbgSectionOrHazard.keys._nCurrentFocus, true);
			tbgSectionOrHazard.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}				
	
	function valAddRec() {
		try {
			if (checkAllRequiredFieldsInDiv("sectionOrHazardFormDiv")) {
				if ($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;
					for ( var i = 0; i < tbgSectionOrHazard.geniisysRows.length; i++) {
						if (tbgSectionOrHazard.geniisysRows[i].recordStatus == 0
								|| tbgSectionOrHazard.geniisysRows[i].recordStatus == 1) {
							if(tbgSectionOrHazard.geniisysRows[i].sectionLineCd == $F("txtLineCd") 
							   		&& tbgSectionOrHazard.geniisysRows[i].sectionSublineCd == $F("txtSublineCd")
							  		&& tbgSectionOrHazard.geniisysRows[i].sectionOrHazardCd == $F("txtSectionOrHazardCd")) {
								addedSameExists = true;
							}
						} else if (tbgSectionOrHazard.geniisysRows[i].recordStatus == -1) {
							if(tbgSectionOrHazard.geniisysRows[i].sectionLineCd == $F("txtLineCd") 
							   		&& tbgSectionOrHazard.geniisysRows[i].sectionSublineCd == $F("txtSublineCd")
							   		&& tbgSectionOrHazard.geniisysRows[i].sectionOrHazardCd == $F("txtSectionOrHazardCd")) {
								deletedSameExists = true;
							}
						}
					}
					if ((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)) {
						showMessageBox("Record already exists with the same section_line_cd, section_subline_cd, and section_or_hazard_cd.", "E");
						return;
					} else if (deletedSameExists && !addedSameExists) {
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GIISSectionOrHazardController", {
						parameters : {
							action : "valAddRec",
							lineCd : $F("txtLineCd"),
							sublineCd : $F("txtSublineCd"),
							sectionOrHazardCd : $F("txtSectionOrHazardCd")
						},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response) {
							hideNotice();
							if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
								addRec();
							}
						}
					});
				} else {
					addRec();
				}
			}
		} catch (e) {
			showErrorMessage("valAddRec", e);
		}
	}

	function deleteRec() {
		changeTagFunc = saveGiiss020;
		objCurrSectionOrHazard.recordStatus = -1;
		tbgSectionOrHazard.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISSectionOrHazardController", {
				parameters : {action : "valDeleteRec",
							  lineCd : $F("txtLineCd"),
							  sublineCd : $F("txtSublineCd"),
							  sectionOrHazardCd : $F("txtSectionOrHazardCd")},
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
	
	function showGiiss020LineLOV(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getGiiss020LineLOV",
							moduleId : "GIISS020",
							filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
							page : 1},
			title: "List of Lines",
			width: 477,
			height: 386,
			columnModel : [ {
								id: "lineCd",
								title: "Line Code",
								width : '100px',
							},{
								id : "lineName",
								title : "Line Name",
								width : '360px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							} ],
				autoSelectOneRecord: true,
				filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
				onSelect: function(row) {
					$("txtLineCd").value = unescapeHTML2(row.lineCd);
					$("txtLineName").value = unescapeHTML2(row.lineName);
					$("txtLineCd").setAttribute("lastValidValue", unescapeHTML2(row.lineCd));
					$("txtSublineCd").clear();
					$("txtSublineName").clear();
					$("txtSublineCd").setAttribute("lastValidValue", "");
					
				},
				onCancel: function (){
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	$("imgLineCd").observe("click", showGiiss020LineLOV);
	$("txtLineCd").observe("change", function() {
		if($F("txtLineCd").trim() == "") {
			$("txtLineCd").value = "";
			$("txtLineCd").setAttribute("lastValidValue", "");
			$("txtLineName").value = "";
			$("txtSublineCd").value = "";
			$("txtSublineCd").setAttribute("lastValidValue", "");
			$("txtSublineName").value = "";
		} else {
			if($F("txtLineCd").trim() != "" && $F("txtLineCd") != $("txtLineCd").readAttribute("lastValidValue")) {
				showGiiss020LineLOV();
			}
		}
	});
	
	function showGiiss020SublineLOV(withLine){
		var action = withLine ? "getGiiss020SublineLOV" : "getGiiss020LineSublineLOV";
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : action,
							lineCd : $F("txtLineCd"),
							moduleId : "GIISS020",
							filterText : ($("txtSublineCd").readAttribute("lastValidValue").trim() != $F("txtSublineCd").trim() ? $F("txtSublineCd").trim() : ""),
							page : 1},
			title: "List of Sublines",
			width: 477,
			height: 386,
			columnModel : [ {
								id : "lineCd",
								title : "Line Code",
								width : withLine ? '0px' : '90px',
								visible : !withLine
							},{
								id : "sublineCd",
								title : "Subline Code",
								width : '100px',
							},{
								id : "sublineName",
								title : "Subline Name",
								width : withLine ? '360px' : '270px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							} ],
				autoSelectOneRecord: true,
				filterText : ($("txtSublineCd").readAttribute("lastValidValue").trim() != $F("txtSublineCd").trim() ? $F("txtSublineCd").trim() : ""),
				onSelect: function(row) {
					$("txtSublineCd").value = unescapeHTML2(row.sublineCd);
					$("txtSublineName").value = unescapeHTML2(row.sublineName);
					$("txtSublineCd").setAttribute("lastValidValue", unescapeHTML2(row.sublineCd));
					if(!withLine){
						$("txtLineCd").value = unescapeHTML2(row.lineCd);
						$("txtLineName").value = unescapeHTML2(row.lineName);
						$("txtLineCd").setAttribute("lastValidValue", unescapeHTML2(row.lineCd));
					}
				},
				onCancel: function (){
					$("txtSublineCd").value = $("txtSublineCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtSublineCd").value = $("txtSublineCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	$("imgSublineCd").observe("click", function(){
		showGiiss020SublineLOV($F("txtLineCd") != "");
	});
	$("txtSublineCd").observe("change", function() {
		if($F("txtSublineCd").trim() == "") {
			$("txtSublineCd").value = "";
			$("txtSublineCd").setAttribute("lastValidValue", "");
			$("txtSublineName").value = "";
		} else {
			if($F("txtSublineCd").trim() != "" && $F("txtSublineCd") != $("txtSublineCd").readAttribute("lastValidValue")) {
				showGiiss020SublineLOV($F("txtLineCd") != "");
			}
		}
	});
	
	function exitPage() {
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}

	function cancelGiiss020() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						objGiiss020.exitPage = exitPage;
						saveGiiss020();
					}, function() {
						goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
	}

	$("editRemarks").observe("click", function() {
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	disableButton("btnDelete");
	observeSaveForm("btnSave", saveGiiss020);
	$("btnCancel").observe("click", cancelGiiss020);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("uwExit").stopObserving("click");
	$("uwExit").observe("click", function() {
		fireEvent($("btnCancel"), "click");
	});
	$("txtLineCd").focus();	
</script>