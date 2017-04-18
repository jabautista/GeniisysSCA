<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss091MainDiv" name="giiss091MainDiv" style="">
	<div id="policyTypeTableGridDiv">
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
	   		<label>Policy Type Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss091" name="giiss091">
		<div class="sectionDiv">
			<div id="policyTypeTableDiv" style="padding-top: 10px;">
				<div id="policyTypeTable" style="height: 340px; margin-left: 115px;"></div>
			</div>
			<div align="center" id="policyTypeFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Line Code</td>
						<td class="leftAligned">
							<span class="lovSpan required" style="width: 207px; height: 22px; margin: 0px 0px 0 0; float: left;">
								<input id="txtLineCd" type="text" class="required" style="width: 180px; text-align: left; height: 13px; float: left; border: none;" tabindex="201" maxlength="2">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineCd" name="searchLineCd" alt="Go" style="float: right;">
							</span> 
						</td>
						<td class="rightAligned">Type Code</td>
						<td class="leftAligned">
							<input id="txtTypeCd" type="text" class="required" style="width: 200px; text-align: left: ;" tabindex="201" maxlength="5">
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Type Description</td>
						<td class="leftAligned" colspan="3">
							<input id="txtTypeDesc" type="text" class="required" style="width: 533px;" tabindex="203" maxlength="300">
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
						<td class="leftAligned" style="width: 254px;"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="206"></td>
						<td width="" class="rightAligned">Last Update</td>
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
	setModuleId("GIISS091");
	setDocumentTitle("Policy Type Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	var databaseLineCd;
	
	observeReloadForm("reloadForm", showGiiss091);
	
	var objGIISS091 = {};
	var objCurrPolicyType = null;
	objGIISS091.policyTypeList = JSON.parse('${jsonPolicyTypeList}');
	objGIISS091.exitPage = null;
	
	//added by jdiago 08.27.2014 : for unique validation
	objGIISS091.allLineCdTypeCd = JSON.parse('${allLineCdTypeCd}');
	objGIISS091.allTypeDesc = JSON.parse('${allTypeDesc}');	
	
	function saveGiiss091(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgPolicyType.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgPolicyType.geniisysRows);

		new Ajax.Request(contextPath+"/GIISPolicyTypeController", {
			method: "POST",
			parameters : {action : "saveGiiss091",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS091.exitPage != null) {
							objGIISS091.exitPage();
						} else {
							tbgPolicyType._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	var policyTypeTable = {
			url : contextPath + "/GIISPolicyTypeController?action=showGiiss091&refresh=1",
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrPolicyType = tbgPolicyType.geniisysRows[y];
					setFieldValues(objCurrPolicyType);
					tbgPolicyType.keys.removeFocus(tbgPolicyType.keys._nCurrentFocus, true);
					tbgPolicyType.keys.releaseKeys();
					$("txtTypeCd").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgPolicyType.keys.removeFocus(tbgPolicyType.keys._nCurrentFocus, true);
					tbgPolicyType.keys.releaseKeys();
					$("txtLineCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgPolicyType.keys.removeFocus(tbgPolicyType.keys._nCurrentFocus, true);
						tbgPolicyType.keys.releaseKeys();
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
					tbgPolicyType.keys.removeFocus(tbgPolicyType.keys._nCurrentFocus, true);
					tbgPolicyType.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgPolicyType.keys.removeFocus(tbgPolicyType.keys._nCurrentFocus, true);
					tbgPolicyType.keys.releaseKeys();
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
					tbgPolicyType.keys.removeFocus(tbgPolicyType.keys._nCurrentFocus, true);
					tbgPolicyType.keys.releaseKeys();
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
					id : "lineCd",
					title : "Line",
					filterOption : true,
					width : '80px'
				},
				{
					id : "typeCd",
					title : "Type",
					filterOption : true,
					width : '80px'
				},
				{
					id : 'typeDesc',
					filterOption : true,
					title : 'Description',
					width : '490px'				
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
				},
				{
					id : 'dummyLineCd',
					width : '0',
					visible: false				
				}
			],
			rows : objGIISS091.policyTypeList.rows
	};

	tbgPolicyType = new MyTableGrid(policyTypeTable);
	tbgPolicyType.pager = objGIISS091.policyTypeList;
	tbgPolicyType.render("policyTypeTable");
	
	function setFieldValues(rec){
		try{
			$("txtLineCd").value = (rec == null ? "" : unescapeHTML2(rec.lineCd));
			$("txtLineCd").setAttribute("lastValidValue", (rec == null ? "" : rec.lineCd));
			databaseLineCd = (rec == null ? "" : rec.lineCd);
			$("txtTypeCd").value = (rec == null ? "" : unescapeHTML2(rec.typeCd));
			$("txtTypeCd").setAttribute("lastValidValue", (rec == null ? "" : rec.typeCd));
			$("txtTypeDesc").value = (rec == null ? "" : unescapeHTML2(rec.typeDesc));
			$("txtTypeDesc").setAttribute("lastValidValue", (rec == null ? "" : rec.typeDesc));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtLineCd").readOnly = false : $("txtLineCd").readOnly = true;
			rec == null ? $("txtTypeCd").readOnly = false : $("txtTypeCd").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			rec == null ? enableSearch("searchLineCd") : disableSearch("searchLineCd");
			objCurrPolicyType = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.lineCd = escapeHTML2($F("txtLineCd"));
			obj.dummyLineCd = databaseLineCd;
			obj.typeCd = escapeHTML2($F("txtTypeCd"));
			obj.typeDesc = escapeHTML2($F("txtTypeDesc"));
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
			changeTagFunc = saveGiiss091;
			var dept = setRec(objCurrPolicyType);
			if($F("btnAdd") == "Add"){
				tbgPolicyType.addBottomRow(dept);
			} else {
				tbgPolicyType.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgPolicyType.keys.removeFocus(tbgPolicyType.keys._nCurrentFocus, true);
			tbgPolicyType.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("policyTypeFormDiv")){
				if(unescapeHTML2($F("txtTypeDesc")) != unescapeHTML2($("txtTypeDesc").readAttribute("lastValidValue"))){
					var addedSameExistsTD = false;
					var deletedSameExistsTD = false;
					
					for(var i=0; i<tbgPolicyType.geniisysRows.length; i++){
						if(tbgPolicyType.geniisysRows[i].recordStatus == 0 || tbgPolicyType.geniisysRows[i].recordStatus == 1){								
							if(tbgPolicyType.geniisysRows[i].typeDesc == escapeHTML2($F("txtTypeDesc"))){
								addedSameExistsTD = true;								
							}							
						} else if(tbgPolicyType.geniisysRows[i].recordStatus == -1){
							if(tbgPolicyType.geniisysRows[i].typeDesc == escapeHTML2($F("txtTypeDesc"))){
								deletedSameExistsTD = true;
							}
						}
					}
					
					if((addedSameExistsTD && !deletedSameExistsTD) || (deletedSameExistsTD && addedSameExistsTD)){
						showMessageBox("Type description entered must be unique.", "E");
						return;
					}	
				}
				
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;
					
					for(var i=0; i<tbgPolicyType.geniisysRows.length; i++){
						if(tbgPolicyType.geniisysRows[i].recordStatus == 0 || tbgPolicyType.geniisysRows[i].recordStatus == 1){								
							if(tbgPolicyType.geniisysRows[i].lineCd == $F("txtLineCd") && tbgPolicyType.geniisysRows[i].typeCd == $F("txtTypeCd")){
								addedSameExists = true;								
							}							
						} else if(tbgPolicyType.geniisysRows[i].recordStatus == -1){
							if(tbgPolicyType.geniisysRows[i].lineCd == $F("txtLineCd") && tbgPolicyType.geniisysRows[i].typeCd == $F("txtTypeCd")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same line_cd, type_cd.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					
					new Ajax.Request(contextPath + "/GIISPolicyTypeController", {
						parameters : {action : "valAddRec",
									  lineCd : $F("txtLineCd"),
									  typeCd : $F("txtTypeCd"),
									  typeDesc : $F("txtTypeDesc")
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
					new Ajax.Request(contextPath + "/GIISPolicyTypeController", {
						parameters : {action : "valAddRec",
									  lineCd : "",
									  typeCd : "",
									  typeDesc : $F("txtTypeDesc")
						},
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
		changeTagFunc = saveGiiss091;
		objCurrPolicyType.recordStatus = -1;
		tbgPolicyType.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISPolicyTypeController", {
				parameters : {action : "valDeleteRec",
							  lineCd : $F("txtLineCd"),
							  typeCd : $F("txtTypeCd"),
				},
				evalScripts: true,
				asynchronous: false,
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						for(var i = 0; i < objGIISS091.allLineCdTypeCd.rows.length; i++){ //added by jdiago 08.27.2014
							if(unescapeHTML2(objGIISS091.allLineCdTypeCd.rows[i].lineCd) == unescapeHTML2(objCurrPolicyType.lineCd) &&
							   unescapeHTML2(objGIISS091.allLineCdTypeCd.rows[i].typeCd) == unescapeHTML2(objCurrPolicyType.typeCd)){
								objGIISS091.allLineCdTypeCd.rows.splice(i, 1);
							}
						}
						
						for(var i = 0; i < objGIISS091.allTypeDesc.rows.length; i++){ //added by jdiago 08.27.2014
							if(unescapeHTML2(objGIISS091.allTypeDesc.rows[i].typeDesc) == unescapeHTML2(objCurrPolicyType.typeDesc)){
								objGIISS091.allTypeDesc.rows.splice(i, 1);
							}
						}
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
	
	function cancelGiiss091(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS091.exitPage = exitPage;
						saveGiiss091();
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
	
	$("txtLineCd").observe("keyup", function(){
		$("txtLineCd").value = $F("txtLineCd").toUpperCase();
	});
	
	$("txtTypeDesc").observe("keyup", function(){
		$("txtTypeDesc").value = $F("txtTypeDesc").toUpperCase();
	});
	
	$("txtLineCd").setAttribute("lastValidValue", "");
	$("searchLineCd").observe("click", showGIISS091LineCdLov);
	$("txtLineCd").observe("change", function() {		
		if($F("txtLineCd").trim() == "") {
			$("txtLineCd").value = "";
			$("txtLineCd").setAttribute("lastValidValue", "");
		} else {
			if($F("txtLineCd").trim() != "" && $F("txtLineCd") != $("txtLineCd").readAttribute("lastValidValue")) {
				showGIISS091LineCdLov();
			}
		}
	});
	
	function showGIISS091LineCdLov(){
		LOV.show({
			controller : "AccountingLOVController",
			urlParameters: {
				action : "getGiiss091LineCd",
				filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
				page : 1
			},
			title: "List of Lines",
			width: 450,
			height: 400,
			columnModel : [
					{
						id : "lineCd",
						title: "Line Code",
						width: '100px',
						filterOption: true
					},
					{
						id : "lineName",
						title: "Line Name",
						width: '325px',
						renderer: function(value) {
							return unescapeHTML2(value);
						}
					}
			],
			autoSelectOneRecord: true,
			filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
			onSelect: function(row) {
				$("txtLineCd").value = row.lineCd;
				$("txtLineCd").setAttribute("lastValidValue", row.lineCd);	
				validateLineCd();
			},
			onCancel: function (){
				$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
			},
			onShow : function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		  });
	}
	
	function validateLineCd(){
		if($F("btnAdd") == "Update") {
			new Ajax.Request(contextPath + "/GIISPolicyTypeController", {
				parameters : {action : "valAddRec",
							  lineCd : $F("txtLineCd"),
							  typeCd : $F("txtTypeCd")
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						
					} else {
						$("txtLineCd").value = databaseLineCd;
					}
				}
			});
		}
	}
	
	/* $("txtTypeDesc").observe("blur", function(){
		validateTypeDesc();
	});
	
	function validateTypeDesc(){
		if($F("txtTypeDesc") != $("txtTypeDesc").readAttribute("lastValidValue")){
			var addedSameExists = false;
			var deletedSameExists = false;					
			
			for(var i=0; i<tbgPolicyType.geniisysRows.length; i++){
				if(tbgPolicyType.geniisysRows[i].recordStatus == 0 || tbgPolicyType.geniisysRows[i].recordStatus == 1){								
					if(tbgPolicyType.geniisysRows[i].typeDesc == $F("txtTypeDesc")){
						addedSameExists = true;								
					}							
				} else if(tbgPolicyType.geniisysRows[i].recordStatus == -1){
					if(tbgPolicyType.geniisysRows[i].typeDesc == $F("txtTypeDesc")){
						deletedSameExists = true;
					}
				}
			}
			
			if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
				showMessageBox("Type description entered must be unique.", "E");
				return;
			}
			
			new Ajax.Request(contextPath + "/GIISPolicyTypeController", {
				parameters : {action : "valTypeDesc",
							  typeDesc : $F("txtTypeDesc")
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						
					} else {
						$("txtTypeDesc").value = $("txtTypeDesc").readAttribute("lastValidValue");
					}
				}
			});	
		}
	} */
	
	$("txtTypeCd").observe("keyup", function(){
		$("txtTypeCd").value = $F("txtTypeCd").toUpperCase();
	});
	
	function valUniqueTypeDesc(){ //created by jdiago 08.27.2014 : unique validation of type_desc
		var addUpdateRecord = true;
	
		for(var i = 0; i < objGIISS091.allTypeDesc.rows.length; i++){
			if(unescapeHTML2(objGIISS091.allTypeDesc.rows[i].typeDesc) == unescapeHTML2($F("txtTypeDesc"))){
				if(($F("btnAdd") == "Update" && unescapeHTML2(objCurrPolicyType.typeDesc) != unescapeHTML2($F("txtTypeDesc"))) || ($F("btnAdd") == "Add")){
					addUpdateRecord = false;
				}
			}
		}
		
		if(addUpdateRecord){
			if($F("btnAdd") == "Add"){
				var recLineCdTypeCd = {};
				var recTypeDesc = {};
				
				recLineCdTypeCd.lineCd = unescapeHTML2($F("txtLineCd"));
				recLineCdTypeCd.typeCd = unescapeHTML2($F("txtTypeCd"));
				recTypeDesc.typeDesc = unescapeHTML2($F("txtTypeDesc"));
				
				objGIISS091.allLineCdTypeCd.rows.push(recLineCdTypeCd);
				objGIISS091.allTypeDesc.rows.push(recTypeDesc);
			}else{
				for(var i = 0; i < objGIISS091.allLineCdTypeCd.rows.length; i++){
					if(unescapeHTML2(objGIISS091.allLineCdTypeCd.rows[i].lineCd) == unescapeHTML2(objCurrPolicyType.lineCd) &&
					   unescapeHTML2(objGIISS091.allLineCdTypeCd.rows[i].typeCd) == unescapeHTML2(objCurrPolicyType.typeCd)){
						var rec = objCurrPolicyType;
						rec.lineCd = unescapeHTML2($F("txtLineCd"));
						rec.typeCd = unescapeHTML2($F("txtTypeCd"));
						objGIISS091.allLineCdTypeCd.rows.splice(i, 1, rec);
					}
				}
				
				for(var i = 0; i < objGIISS091.allTypeDesc.rows.length; i++){
					if(unescapeHTML2(objGIISS091.allTypeDesc.rows[i].typeDesc) == unescapeHTML2(objCurrPolicyType.typeDesc)){
						var rec = objCurrPolicyType;
						rec.typeDesc = unescapeHTML2($F("txtTypeDesc"));
						objGIISS091.allTypeDesc.rows.splice(i, 1, rec);
					}
				}
			}
			
			addRec();
		}else{
			showMessageBox("Record already exists with the same type_desc.", "E");
		}
	}
	
	function valUniqueBeforeAdd(){ //created by jdiago 08.27.2014 : start of unique validation
		if(checkAllRequiredFieldsInDiv("policyTypeFormDiv")){
			var proceedToTypeDesc = true;
			
			for(var i=0; i<objGIISS091.allLineCdTypeCd.rows.length; i++){
				if(unescapeHTML2(objGIISS091.allLineCdTypeCd.rows[i].lineCd) == unescapeHTML2($F("txtLineCd")) && unescapeHTML2(objGIISS091.allLineCdTypeCd.rows[i].typeCd) == unescapeHTML2($F("txtTypeCd"))){
					if(($F("btnAdd") == "Update" && (unescapeHTML2(objCurrPolicyType.lineCd) != unescapeHTML2($F("txtLineCd")) && unescapeHTML2(objCurrPolicyType.typeCd) != unescapeHTML2($F("txtTypeCd"))) ) || ($F("btnAdd") == "Add")){
						proceedToTypeDesc = false;
					}
				}
			}
			
			if(proceedToTypeDesc){
				valUniqueTypeDesc();
			}else{
				showMessageBox("Record already exists with the same line_cd and type_cd.", "E");
			}
		}
	}
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGiiss091);
	$("btnCancel").observe("click", cancelGiiss091);
	//$("btnAdd").observe("click", valAddRec); removed by jdiago 08.27.2014
	$("btnAdd").observe("click", valUniqueBeforeAdd); //added by jdiago 08.27.2014
	$("btnDelete").observe("click", valDeleteRec);

	$("menuFileMaintenanceExit").stopObserving("click");
	$("menuFileMaintenanceExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	$("txtLineCd").focus();	
</script>