<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss098MainDiv" name="giiss098MainDiv" style="">
	<div id="giiss098Div">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="giiss098Exit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Construction Type Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss098" name="giiss098">		
		<div class="sectionDiv">
			<div id="giisFireConstructionTableDiv" style="padding-top: 10px;">
				<div id="giisFireConstructionTable" style="height: 340px; margin-left: 115px;"></div>
			</div>
			<div align="center" id="giisFireConstructionFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Code</td>
						<td class="leftAligned" colspan="3">
							<input id="txtConstructionCd" type="text" class="required" style="width: 200px;" tabindex="101" maxlength="2">
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Construction Description</td>
						<td class="leftAligned" colspan="3">
							<div id="ConstructionDescDiv" class="required" name="ConstructionDescDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea class="required" style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtConstructionDesc" name="txtConstructionDesc" maxlength="2000"  onkeyup="limitText(this,4000);" tabindex="103"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editConstructionDesc"  tabindex="104"/>
							</div>
							<input id="txtOrigConstructionDesc" type="hidden">
						</td>
					</tr>				
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="103"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="104"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="105"></td>
						<td width="" class="rightAligned" style="padding-left: 47px">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="106"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;" align = "center">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="107">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="108">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="109">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="110">
</div>
<script type="text/javascript">	
	setModuleId("GIISS098");
	setDocumentTitle("Construction Type Maintenance");
	initializeAll();
	changeTag = 0;
	var allRecObj = {};
	var rowIndex = -1;
	
	function saveGiiss098(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgGIISFireConstruction.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgGIISFireConstruction.geniisysRows);
		new Ajax.Request(contextPath+"/GIISFireConstructionController", {
			method: "POST",
			parameters : {action : "saveGiiss098",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS098.exitPage != null) {
							objGIISS098.exitPage();
						} else {
							tbgGIISFireConstruction._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss098);
	
	var objGIISS098 = {};
	var objCurrGIISFireConstruction = null;
	objGIISS098.giisFireConstructionList = JSON.parse('${jsonGIISFireConstruction}');
	objGIISS098.exitPage = null;
	
	var giisFireConstructionTable = {
			url : contextPath + "/GIISFireConstructionController?action=showGiiss098&refresh=1",
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrGIISFireConstruction = tbgGIISFireConstruction.geniisysRows[y];
					setFieldValues(objCurrGIISFireConstruction);
					tbgGIISFireConstruction.keys.removeFocus(tbgGIISFireConstruction.keys._nCurrentFocus, true);
					tbgGIISFireConstruction.keys.releaseKeys();
					$("txtConstructionDesc").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgGIISFireConstruction.keys.removeFocus(tbgGIISFireConstruction.keys._nCurrentFocus, true);
					tbgGIISFireConstruction.keys.releaseKeys();
					$("txtConstructionCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgGIISFireConstruction.keys.removeFocus(tbgGIISFireConstruction.keys._nCurrentFocus, true);
						tbgGIISFireConstruction.keys.releaseKeys();
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
					tbgGIISFireConstruction.keys.removeFocus(tbgGIISFireConstruction.keys._nCurrentFocus, true);
					tbgGIISFireConstruction.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgGIISFireConstruction.keys.removeFocus(tbgGIISFireConstruction.keys._nCurrentFocus, true);
					tbgGIISFireConstruction.keys.releaseKeys();
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
					tbgGIISFireConstruction.keys.removeFocus(tbgGIISFireConstruction.keys._nCurrentFocus, true);
					tbgGIISFireConstruction.keys.releaseKeys();
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
					id : "constructionCd",
					title : "Code",
					filterOption : true,
					width : '150px'
				},
				{
					id : 'constructionDesc',
					title : 'Construction Description',
					filterOption : true,
					width : '500px'				
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
			rows : objGIISS098.giisFireConstructionList.rows
		};

		tbgGIISFireConstruction = new MyTableGrid(giisFireConstructionTable);
		tbgGIISFireConstruction.pager = objGIISS098.giisFireConstructionList;
		tbgGIISFireConstruction.render("giisFireConstructionTable");
		tbgGIISFireConstruction.afterRender = function(){
			                             		allRecObj = getAllRecord();				
											};
	
	function setFieldValues(rec){
		try{
			$("txtConstructionCd").value = (rec == null ? "" : unescapeHTML2(rec.constructionCd));
			$("txtConstructionCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.constructionCd)));
			$("txtConstructionDesc").value = (rec == null ? "" : unescapeHTML2(rec.constructionDesc));
			$("txtOrigConstructionDesc").value = (rec == null ? "" : unescapeHTML2(rec.constructionDesc));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtConstructionCd").readOnly = false : $("txtConstructionCd").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrGIISFireConstruction = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.constructionCd = escapeHTML2($F("txtConstructionCd"));
			obj.constructionDesc = escapeHTML2($F("txtConstructionDesc"));
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
			changeTagFunc = saveGiiss098;
			var dept = setRec(objCurrGIISFireConstruction);
			var newObj = setRec(null);
			if($F("btnAdd") == "Add"){
				tbgGIISFireConstruction.addBottomRow(dept);
				newObj.recordStatus = 0;
				allRecObj.push(newObj);
			} else {
				tbgGIISFireConstruction.updateVisibleRowOnly(dept, rowIndex, false);
				for(var i = 0; i<allRecObj.length; i++){
					if ((allRecObj[i].constructionCd == newObj.constructionCd)&&(allRecObj[i].recordStatus != -1)){
						newObj.recordStatus = 1;
						allRecObj.splice(i, 1, newObj);
					}
				}
			}
			changeTag = 1;
			setFieldValues(null);
			tbgGIISFireConstruction.keys.removeFocus(tbgGIISFireConstruction.keys._nCurrentFocus, true);
			tbgGIISFireConstruction.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("giisFireConstructionFormDiv")){
				for(var i=0; i<allRecObj.length; i++){
					if(allRecObj[i].recordStatus != -1 ){
						if ($F("btnAdd") == "Add") {
							if(unescapeHTML2(allRecObj[i].constructionCd) == $F("txtConstructionCd")){
								showMessageBox("Record already exists with the same construction_cd.", "E");
								return;
							}else if(unescapeHTML2(allRecObj[i].constructionDesc).toUpperCase() == $F("txtConstructionDesc").toUpperCase()){
								showMessageBox("Record already exists with the same construction_desc.", "E");
								return;
							}
						} else{
							if($F("txtOrigConstructionDesc").toUpperCase() != $F("txtConstructionDesc").toUpperCase() && unescapeHTML2(allRecObj[i].constructionDesc).toUpperCase() == $F("txtConstructionDesc").toUpperCase()){
								showMessageBox("Record already exists with the same construction_desc.", "E");
								return;
							}
						}
					} 
				}
				addRec();
				/* if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;					
					
					for(var i=0; i<tbgGIISFireConstruction.geniisysRows.length; i++){
						if(tbgGIISFireConstruction.geniisysRows[i].recordStatus == 0 || tbgGIISFireConstruction.geniisysRows[i].recordStatus == 1){								
							if(tbgGIISFireConstruction.geniisysRows[i].constructionCd == $F("txtConstructionCd")){
								addedSameExists = true;								
							}							
						} else if(tbgGIISFireConstruction.geniisysRows[i].recordStatus == -1){
							if(tbgGIISFireConstruction.geniisysRows[i].constructionCd == $F("txtConstructionCd")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same construction_cd.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GIISFireConstructionController", {
						parameters : {action : "valAddRec",
									  constructionCd : $F("txtConstructionCd")},
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
				} */
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}	
	
	function deleteRec(){
		changeTagFunc = saveGiiss098;
		var newObj = setRec(null);
		objCurrGIISFireConstruction.recordStatus = -1;
		tbgGIISFireConstruction.deleteRow(rowIndex);
		tbgGIISFireConstruction.geniisysRows[rowIndex].constructionCd = escapeHTML2($F("txtConstructionCd"));
		for(var i = 0; i<allRecObj.length; i++){
			if ((allRecObj[i].constructionCd == unescapeHTML2(newObj.constructionCd))&&(allRecObj[i].recordStatus != -1)){
				newObj.recordStatus = -1;
				allRecObj.splice(i, 1, newObj);
			}
		}
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISFireConstructionController", {
				parameters : {action : "valDeleteRec",
							  constructionCd : $F("txtConstructionCd")},
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
	
	function getAllRecord() {
		try {
			var objReturn = {};
			new Ajax.Request(contextPath + "/GIISFireConstructionController", {
				parameters : {action : "showAllGiiss098"},
			    asynchronous: false,
				evalScripts: true,
// 				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						var obj = {};
						obj = JSON.parse(response.responseText.replace(/\\\\/g, '\\'));
						objReturn = obj.rows;
					}
				}
			});
			return objReturn;
		} catch (e) {
			showErrorMessage("getAllRecord",e);
		}
	}
	
	function exitPage(){ 
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", "");
	}	
	
	function cancelGiiss098(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS098.exitPage = exitPage;
						saveGiiss098();
					}, function(){
						goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", "");
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", "");
		}
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("editConstructionDesc").observe("click", function(){
		showOverlayEditor("txtConstructionDesc", 2000, $("txtConstructionDesc").hasAttribute("readonly"));
	});
	
	$("txtConstructionCd").observe("keyup", function(){
		$("txtConstructionCd").value = $F("txtConstructionCd").toUpperCase();
	});
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGiiss098);
	$("btnCancel").observe("click", cancelGiiss098);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("giiss098Exit").stopObserving("click");
	$("giiss098Exit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtConstructionCd").focus();	
</script>