<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="motorTypeMaintenance" name="motorTypeMaintenance" style="float: left; width: 100%;">
	<div id="motorTypeMaintenanceExitDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="underwritingExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Motor Type Maintenance</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="showHideMotorType" name="gro" style="margin-left: 5px;">Hide</label> 
			 	<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>
	<div id="showBody">	
		<div class="sectionDiv">
			<div style="padding:10px;">
				<div id="sublineTableGrid" style="height: 260px;margin-left:200px;width:700px;"></div>
			</div>	
		</div>
		<div class="sectionDiv">
			<div style="padding:10px;">
				<div id="motorTypeTableGrid" style="height:331px; margin-left:75px; width:750px;"></div>
			</div>	
			<div id="motorTypeDiv">	
				<div style="margin-left: 150px">
					<table>
						<tr>
							<td align="right">Motor Type</td>
							<td><input id="txtMotorType" maxlength="2" type="text" style="width:150px;text-align: right" class="required"></td>
							<td align="right">Unladen Weight</td>
							<td><input id="txtUnladenWeight" maxlength="20" type="text" style="width:200px"></td>
						</tr>
						<tr>
							<td align="right">Description</td>
							<td colspan="3"><input id="txtDescription" maxlength="20" type="text"  style="width:553px" class="required"></td>
						</tr>	
						<tr>
							<td align="right">Remarks</td>
							<td colspan="3">
								<span class="lovSpan" style="width: 559px; margin: 0">
										<input maxlength="4000"
										style="width: 533px; float: left; height: 14px; border: none; margin:0"
										type="text" id="txtRemarks" /> 
										<img
										src="${pageContext.request.contextPath}/images/misc/edit.png"
										id="imgEditRemarks" alt="Go" style="float: right; margin-top: 2px;" />
								</span>
							</td>
						</tr>	
						<tr>
							<td align="right">User ID</td>
							<td><input id="txtUserId" type="text" style="width:150px" readonly="readonly"></td>
							<td align="right" style="width: 187px;">Last Update</td>
							<td><input id="txtLastUpdate" type="text"  style="width:200px" readonly="readonly"></td>
						</tr>																		
					</table>		
				</div>
				<div align="center" style="margin: 15px">
					<div>
						<input type="button" id="btnAddUpdate" value="Add">
						<input type="button" id="btnDelete" value="Delete">
					</div>
				</div>
			</div>
		</div>		
	</div>	
	<div class="sectionDiv" style="border: 0; margin-bottom: 50px;margin-top: 15px" align="center">
		<div>
			<input type="button" id="btnCancel" value="Cancel">
			<input type="button" id="btnSave" value="Save">
		</div>
	</div>
</div>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/underwriting/underwriting.js">
try {
	setModuleId("GIISS055");
	setDocumentTitle("Motor Type Maintenance");
	var row;
	var objMotorTypeMain = [];
	var jsonSubline = JSON.parse('${jsonSubline}');
	initializeAll();
	initializeAccordion();
	sublineTableModel = {
		url : contextPath
				+ "/GIISMotorTypeController?action=showSubline&refresh=1",
		options : {
			width : '500px',
			pager : {},
			toolbar : {
				elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
				onFilter: function(){	
					if(changeTag==0){
						disableButton("btnAddUpdate");
						setTbgMotorType(null);	
						disableFields();		
						tbgSubline.keys.removeFocus(
								tbgSubline.keys._nCurrentFocus, true);
						tbgSubline.keys.releaseKeys();																	
					}else{
						showMessageBox("Please save changes first.", imgMessage.INFO);	
						return false;
					}					
				}					
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
			},		
			prePager : function(element, value, x, y, id) {
				if(changeTag==0){
					disableButton("btnAddUpdate");
					setTbgMotorType(null);	
					disableFields();		
					tbgSubline.keys.removeFocus(
							tbgSubline.keys._nCurrentFocus, true);
					tbgSubline.keys.releaseKeys();						
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}								
			},
			beforeClick : function(element, value, x, y, id){				
				if(changeTag==1){
					showMessageBox("Please save changes first.", imgMessage.INFO);				
					return false;						
				}			
			},
			onCellFocus : function(element, value, x, y, id) {	
				if(changeTag==0){
					setTbgMotorType(tbgSubline.geniisysRows[y]);							
					enableFields();	
					enableButton("btnAddUpdate");
					$("txtMotorType").focus();	
					tbgSubline.keys.removeFocus(
							tbgSubline.keys._nCurrentFocus, true);
					tbgSubline.keys.releaseKeys();	
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);				
					return false;
				}					
			},
			onRemoveRowFocus : function(element, value, x, y, id) {	
				if(changeTag==0){
					disableButton("btnAddUpdate");
					setTbgMotorType(null);	
					disableFields();					
					tbgSubline.keys.removeFocus(
							tbgSubline.keys._nCurrentFocus, true);
					tbgSubline.keys.releaseKeys();														
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}					
			},
			beforeSort : function() {			
				if(changeTag==0){
					disableButton("btnAddUpdate");
					setTbgMotorType(null);	
					disableFields();		
					tbgSubline.keys.removeFocus(
							tbgSubline.keys._nCurrentFocus, true);
					tbgSubline.keys.releaseKeys();													
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}					
			},
			onSort : function() {				
				if(changeTag==0){
					disableButton("btnAddUpdate");
					setTbgMotorType(null);	
					disableFields();		
					tbgSubline.keys.removeFocus(
							tbgSubline.keys._nCurrentFocus, true);
					tbgSubline.keys.releaseKeys();												
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}				
			},
			onRefresh : function() {				
				if(changeTag==0){
					disableButton("btnAddUpdate");
					setTbgMotorType(null);	
					disableFields();		
					tbgSubline.keys.removeFocus(
							tbgSubline.keys._nCurrentFocus, true);
					tbgSubline.keys.releaseKeys();									
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}	
			}
		},
		columnModel : [ {
			id : 'recordStatus',
			title : '',
			width : '0',
			visible : false
		}, {
			id : 'divCtrId',
			width : '0',
			visible : false
		},  {
			id : "sublineCd",
			title : "Subline Code",
			width : '130px',
			align : "left",
			titleAlign : "left",
			filterOption : true,
			renderer: function(value){
				return unescapeHTML2(value);	
			}			
		}, {
			id : "sublineName",
			title : "Subline Description",
			
			width : '343px',
			align : "left",
			titleAlign : "left",
			filterOption : true,
			renderer: function(value){
				return unescapeHTML2(value);	
			}
		}],
		rows : jsonSubline.rows
	};

	tbgSubline = new MyTableGrid(sublineTableModel);
	tbgSubline.pager = jsonSubline;
	tbgSubline.render('sublineTableGrid');
	
	var jsonMotorType = JSON.parse('${jsonMotorType}');
	motorTypeTableModel = {
		url : contextPath
				+ "/GIISMotorTypeController?action=showMotorType&refresh=1",
		options : {
			width : '750px',
			pager : {},
			toolbar : {
				elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
				onFilter: function(){	
					if(changeTag==0){
						tbgMotorType.keys.removeFocus(
								tbgMotorType.keys._nCurrentFocus, true);
						tbgMotorType.keys.releaseKeys();
						setBtnAndFields(null);	
						setMotorTypeDtls(null);	
						fieldFocus(null);	
						setObjMotorType(null);			
					}else{
						showMessageBox("Please save changes first.", imgMessage.INFO);	
						return false;
					}		
				}					
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
			},		
			prePager : function(element, value, x, y, id) {
				if(changeTag==0){
					tbgMotorType.keys.removeFocus(
							tbgMotorType.keys._nCurrentFocus, true);
					tbgMotorType.keys.releaseKeys();
					setBtnAndFields(null);	
					setMotorTypeDtls(null);	
					fieldFocus(null);	
					setObjMotorType(null);					
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}								
			},			
			onCellFocus : function(element, value, x, y, id) {						
				tbgMotorType.keys.removeFocus(
						tbgMotorType.keys._nCurrentFocus, true);
				tbgMotorType.keys.releaseKeys();	
				setMotorTypeDtls(tbgMotorType.geniisysRows[y]);
				setBtnAndFields(tbgMotorType.geniisysRows[y]);				
				fieldFocus(tbgMotorType.geniisysRows[y]);		
				setObjMotorType(tbgMotorType.geniisysRows[y]);					
				row = y;
			},
			onRemoveRowFocus : function(element, value, x, y, id) {				
				tbgMotorType.keys.removeFocus(
						tbgMotorType.keys._nCurrentFocus, true);
				tbgMotorType.keys.releaseKeys();
				setBtnAndFields(null);	
				setMotorTypeDtls(null);	
				fieldFocus(null);	
				setObjMotorType(null);					
			},
			beforeSort : function() {			
				if(changeTag==0){
					tbgMotorType.keys.removeFocus(
							tbgMotorType.keys._nCurrentFocus, true);
					tbgMotorType.keys.releaseKeys();
					setBtnAndFields(null);	
					setMotorTypeDtls(null);	
					fieldFocus(null);		
					setObjMotorType(null);				
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}					
			},
			onSort : function() {				
				if(changeTag==0){
					tbgMotorType.keys.removeFocus(
							tbgMotorType.keys._nCurrentFocus, true);
					tbgMotorType.keys.releaseKeys();
					setBtnAndFields(null);	
					setMotorTypeDtls(null);	
					fieldFocus(null);		
					setObjMotorType(null);				
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}			
			},
			onRefresh : function() {				
				if(changeTag==0){
					tbgMotorType.keys.removeFocus(
							tbgMotorType.keys._nCurrentFocus, true);
					tbgMotorType.keys.releaseKeys();
					setBtnAndFields(null);	
					setMotorTypeDtls(null);	
					fieldFocus(null);	
					setObjMotorType(null);					
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}			
			}
		},
		columnModel : [ {
			id : 'recordStatus',
			title : '',
			width : '0',
			visible : false
		}, {
			id : 'divCtrId',
			width : '0',
			visible : false
		},{
			id : "typeCd",
			title : "Motor Type",			
			width : '170px',
			align : "right",
			titleAlign : "right",
			filterOption : true,
			filterOptionType : 'integerNoNegative'
		}, {
			id : "motorTypeDesc",
			title : "Description",			
			width : '378px',
			align : "left",
			titleAlign : "left",
			filterOption : true
		}, {
			id : "unladenWt",
			title : "Unladen Weight",
			width : '190px',
			align : "left",
			titleAlign : "left",
			filterOption : true		
		}],
		rows : jsonMotorType.rows
	};

	tbgMotorType = new MyTableGrid(motorTypeTableModel);
	tbgMotorType.pager = jsonMotorType;
	tbgMotorType.render('motorTypeTableGrid');
	tbgMotorType.afterRender = function(){
		objMotorTypeMain = tbgMotorType.geniisysRows;
		changeTag = 0;
	};
	
	function setBtnAndFields(obj) {
		if (obj != null) {				
			enableButton("btnDelete");				
			$("btnAddUpdate").value = "Update";		
			$("txtMotorType").readOnly = "readonly"; 			
		}else{
			$("btnAddUpdate").value = "Add";	
			enableButton("btnCancel");
			enableButton("btnSave");
			disableButton("btnDelete");
			$("txtMotorType").readOnly = false; 			
		}
	}
	
	function enableImg(imgId){
		try {		
			if($(imgId).next("img",0) != undefined){
				$(imgId).show();
				$(imgId).next("img",0).remove();
			}
		} catch(e){
			showErrorMessage("enableImg", e);
		}	
	}	

	function disableImg(imgId){
		try {
			if($(imgId).next("img",0) == undefined){
				var alt = new Element("img");
				alt.alt = 'Go';
				alt.src = contextPath + "/images/misc/edit.png";
				alt.setAttribute("style", "height:17px;width:18px;");							
				alt.setStyle({ 
					  float: 'right'
				});
				$(imgId).hide();
				$(imgId).insert({after : alt});	
			}
		}catch (e) {
			showErrorMessage("disableImg", e);			
		}
	};
	
	function showHideDiv(divId,labelId){
		if($(divId).getStyle('display') !='none'){
			Effect.toggle(divId, "blind", {duration: .3});
			$(labelId).innerHTML = "Show";
		}else if($(divId).getStyle('display') =='none'){
			Effect.toggle(divId, "blind", {duration: .3});
			$(labelId).innerHTML = "Hide";
		}		
	}

	
	function enableFields(){
		$("txtMotorType").disabled = false;
		$("txtUnladenWeight").disabled = false;
		$("txtDescription").disabled = false;	
		$("txtRemarks").disabled = false;	
		$("txtUserId").disabled = false;	
		$("txtLastUpdate").disabled = false;	
		enableImg("imgEditRemarks");		
		$("txtMotorType").setStyle({backgroundColor: '#FFFACD'});
		$("txtUnladenWeight").setStyle({backgroundColor: 'white'});
		$("txtDescription").setStyle({backgroundColor: '#FFFACD'});	
		$("txtRemarks").setStyle({backgroundColor: 'white'});		
		$("txtUserId").setStyle({backgroundColor: 'white'});		
		$("txtLastUpdate").setStyle({backgroundColor: 'white'});
	}
	
	function disableFields(){			
		$("txtMotorType").disabled = true;
		$("txtUnladenWeight").disabled = true;
		$("txtDescription").disabled = true;	
		$("txtRemarks").disabled = true;	
		$("txtUserId").disabled = true;	
		$("txtLastUpdate").disabled = true;	
		disableImg("imgEditRemarks");		
		$("txtMotorType").setStyle({backgroundColor: '#F0F0F0'});
		$("txtUnladenWeight").setStyle({backgroundColor: '#F0F0F0'});
		$("txtDescription").setStyle({backgroundColor: '#F0F0F0'});	
		$("txtRemarks").setStyle({backgroundColor: '#F0F0F0'});		
		$("txtUserId").setStyle({backgroundColor: '#F0F0F0'});		
		$("txtLastUpdate").setStyle({backgroundColor: '#F0F0F0'});
	}
	
	function setTbgMotorType(obj) {
		objSubline.sublineCd = obj == null? "": (obj.sublineCd==null? "":obj.sublineCd);			
		tbgMotorType.url = contextPath
				+ "/GIISMotorTypeController?action=showMotorType&refresh=1&sublineCd="
				+ objSubline.sublineCd;
		tbgMotorType._refreshList();				
	}
	
	function fieldFocus(obj){
		if(obj!=null){
			$("txtUnladenWeight").focus();				
		}else{			
			$("txtMotorType").focus();				
		}
	}
	
	function chkRequiredFields(){	
		if($("txtMotorType").value == ""){
			customShowMessageBox("Required fields must be entered.", imgMessage.ERROR,"txtMotorType");
			return false;
		}else if($("txtDescription").value == ""){
			customShowMessageBox("Required fields must be entered.", imgMessage.ERROR,"txtDescription");	
			return false;
		}else{
			return true;
		}
	}
	
	function setMotorTypeDtls(obj) {			
		try {			
			$("txtMotorType").value = obj == null ? "" : (obj.typeCd == null? "":obj.typeCd);
			$("txtUnladenWeight").value = obj == null ? "" : (obj.unladenWt == null? "":unescapeHTML2(obj.unladenWt));
			$("txtDescription").value = obj == null ? "" : (obj.motorTypeDesc == null? "":unescapeHTML2(obj.motorTypeDesc));
			$("txtRemarks").value = obj == null ? "" : (obj.remarks ==null ? "":unescapeHTML2(obj.remarks));
			$("txtUserId").value = obj == null ? "" : (obj.userId == null? "":unescapeHTML2(obj.userId));
			$("txtLastUpdate").value = obj == null ? "" : (obj.lastUpdate == null? "":unescapeHTML2(obj.lastUpdate));
		} catch (e) {
			showErrorMessage("setMotorTypeDtls", e);
		}
	}	
	
	function setObjMotorType(obj) {
		try {		
			objMotorType.sublineCd = obj == null ? "" : (obj.sublineCd==null?"":obj.sublineCd);
			objMotorType.typeCd = obj == null ? "" : (obj.typeCd==null?"":obj.typeCd);
			objMotorType.motorTypeDesc = obj == null ? "" : (obj.motorTypeDesc==null?"":obj.motorTypeDesc);	
			objMotorType.unladenWt = obj == null ? "" : (obj.unladenWt==null?"":obj.unladenWt);	
			objMotorType.remarks = obj == null ? "" : (obj.remarks==null?"":obj.remarks);
			objMotorType.userId = obj == null ? "" : (obj.userId==null?"":obj.userId);
			objMotorType.lastUpdate = obj == null ? "" : (obj.lastUpdate==null?"":obj.lastUpdate);		
		} catch (e) {
			showErrorMessage("setObjMotorType", e);
		}
	}
	
	function exitPage() {
		goToModule("/GIISUserController?action=goToUnderwriting",
				"Underwriting Main", null);
	}
	
	function cancelGiiss055() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						objMotorType.exitPage = exitPage;
						saveGiiss055();
					}, function() {
						goToModule(
								"/GIISUserController?action=goToUnderwriting",
								"Underwriting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting",
					"Underwriting Main", null);
		}
	}
		
	function validateGIISS055MotorType(){
		try{	
			var canAdd = true;
		 	new Ajax.Request(contextPath + "/GIISMotorTypeController", {
				method : "POST",
				parameters : {
					action : "validateGIISS055MotorType",				
					typeCd: $("txtMotorType").value,
					sublineCd: objSubline.sublineCd
				},	
				asynchronous : false,
				evalScripts : true,				
				onComplete : function(response) {
					hideNotice();
					var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));									
					if (res.result != "TRUE"){					
						showWaitingMessageBox(res.result, "E", function() {
				    		$("txtMotorType").value ="";		
				    		$("txtMotorType").focus();
						});	
						canAdd = false;
					}		
				}
			}); 
		 	return canAdd;
		}catch(e){
		}
	}	
	
	function chkDeleteGIISS055MotorType(){
		try{
			var canDelete = true;
		 	new Ajax.Request(contextPath + "/GIISMotorTypeController", {
				method : "POST",
				parameters : {
					action : "chkDeleteGIISS055MotorType",				
					typeCd: $("txtMotorType").value,
					sublineCd: objSubline.sublineCd
				},	
				asynchronous : false,
				evalScripts : true,				
				onComplete : function(response) {
					hideNotice();
					var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));									
					if (res.result != "TRUE"){					
						showMessageBox(res.result, imgMessage.ERROR);
						canDelete = false;	
					}	
				}
			}); 
		 	return canDelete;
		}catch(e){
			showErrorMessage("validateBeforeDelete", e);
		}
	}
	
	function setRowObjMotorType(func){
		try {					
			var rowObjMotorType = new Object();		
			rowObjMotorType.sublineCd = objSubline.sublineCd;	
			rowObjMotorType.typeCd = $("txtMotorType").value;	
			rowObjMotorType.unladenWt = escapeHTML2($("txtUnladenWeight").value);
			rowObjMotorType.motorTypeDesc = escapeHTML2($("txtDescription").value);
			rowObjMotorType.remarks = escapeHTML2($("txtRemarks").value);
			rowObjMotorType.userId = escapeHTML2(userId);
			var lastUpdate = new Date();
			rowObjMotorType.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');	
			rowObjMotorType.recordStatus = func == "Delete" ? -1 : func == "Add" ? 0 : 1;
			return rowObjMotorType;
		} catch (e) {
			showErrorMessage("setRowObjMotorType", e);
		}
	}	
	
	function valAddRec() {
		try {
			if (checkAllRequiredFieldsInDiv("motorTypeDiv")) {
				if ($F("btnAddUpdate") == "Add") {
					var addedSameExists = false;				
					for ( var i = 0; i < tbgMotorType.geniisysRows.length; i++) {
						if (tbgMotorType.geniisysRows[i].typeCd == $F("txtMotorType")&&tbgMotorType.geniisysRows[i].recordStatus != -1) {
							addedSameExists = true;
						}							
					}
					if ((addedSameExists)) {						
						showWaitingMessageBox("Record already exists with the same type_cd and subline_cd.", "E", function() {	
				    		$("txtMotorType").focus();
						});	
						return;
					} 			
					new Ajax.Request(contextPath + "/GIISMotorTypeController", {
						method : "POST",
						parameters : {
							action : "validateGIISS055MotorType",				
							typeCd: $("txtMotorType").value,
							sublineCd: objSubline.sublineCd
						},	
						asynchronous : false,
						evalScripts : true,				
						onComplete : function(response) {
							hideNotice();
							var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));									
							if (res.result != "TRUE"){					
								showWaitingMessageBox(res.result, "E", function() {	
						    		$("txtMotorType").focus();
								});	
							}else{
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
		
	function addRec(){
		if($("btnAddUpdate").value=="Update"){
			rowObj  = setRowObjMotorType($("btnAddUpdate").value);			
			changeTag=1;	
			objMotorTypeMain.splice(row, 1, rowObj);
			tbgMotorType.updateVisibleRowOnly(rowObj, row);
			tbgMotorType.onRemoveRowFocus();		
		}else if ($("btnAddUpdate").value=="Add"){
			rowObj  = setRowObjMotorType($("btnAddUpdate").value);
			objMotorTypeMain.push(rowObj);
			tbgMotorType.addBottomRow(rowObj);
			tbgMotorType.onRemoveRowFocus();
			changeTag = 1;
		}
		changeTagFunc = saveGiiss055; // for logout confirmation
	}
	
	function deleteInMotorType(){ 
		delObj = setRowObjMotorType($("btnDelete").value);
		objMotorTypeMain.splice(row, 1, delObj);				
		changeTag=1;
		tbgMotorType.deleteVisibleRowOnly(row);
		setMotorTypeDtls(null);	
		setBtnAndFields(null);	
		changeTagFunc = saveGiiss055; // for logout confirmation
	}
	
	function saveGiiss055(){
		try{	
			if(changeTag == 0) {
				showMessageBox(objCommonMessage.NO_CHANGES, "I");
				return;
			}
			var objParams = new Object(); 
			objParams.setRows = getAddedAndModifiedJSONObjects(objMotorTypeMain);
			objParams.delRows = getDeletedJSONObjects(objMotorTypeMain);
			new Ajax.Request(contextPath + "/GIISMotorTypeController", {
				method : "POST",
				parameters : {
					action : "saveGiiss055",
					parameters : JSON.stringify(objParams)				
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : function(){
					showNotice("Saving Motor Type Maintenance, please wait ...");
				},
				onComplete : function(response) {
					hideNotice();
					var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
					if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
						changeTagFunc = "";
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
							if(objMotorType.exitPage != null) {
								objMotorType.exitPage();
							} else {
								tbgMotorType._refreshList();
							}
						});
						changeTag = 0;
					}
				}
			});				
		}catch(e){
			showErrorMessage("saveGiiss055", e);
		}
	}	
	
	function initializeGIISS055(){
		setBtnAndFields(null);	
		objSubline = new Object();
		objMotorType = new Object();
		changeTag = 0;
		disableFields();
		disableButton("btnAddUpdate");	
	}	
	
	observeReloadForm("reloadForm", function(){
		showMotorType();
		});
	
	$("txtMotorType").observe("change", function(){	
		if(!RegExWholeNumber.pWholeNumber.test($("txtMotorType").value)){
			showWaitingMessageBox("Invalid motor type. Valid value should be from 1 to 99.", "I", function() {
				$("txtMotorType").value =$("txtMotorType").readAttribute("lastValidValue");
	    		$("txtMotorType").focus();	    		
			});
			return;
		}else if(parseInt($F("txtMotorType")) > 99|| parseInt($F("txtMotorType")) <= 0){
			showWaitingMessageBox("Invalid motor type. Valid value should be from 1 to 99.", "I", function() {
				$("txtMotorType").value =$("txtMotorType").readAttribute("lastValidValue");
	    		$("txtMotorType").focus();	    		
			});
			return;
		}	
		if($F("txtMotorType").trim()==""){
			$("txtMotorType").value="";
			$("txtMotorType").setAttribute("lastValidValue","");			
		}else{
			$("txtMotorType").setAttribute("lastValidValue",$F("txtMotorType"));
		}

	});
		
	$("txtUnladenWeight").observe("keyup", function(){
		$("txtUnladenWeight").value = $F("txtUnladenWeight").toUpperCase();
	});
	
	$("txtUnladenWeight").observe("change", function(){
		$("txtUnladenWeight").value = $F("txtUnladenWeight").toUpperCase();
	});
	
	$("txtDescription").observe("keyup", function(){
		$("txtDescription").value = $F("txtDescription").toUpperCase();
	});
	
	$("txtDescription").observe("change", function(){
		$("txtDescription").value = $F("txtDescription").toUpperCase();
	});
	
	$("txtRemarks").observe("dblclick", function(){
		showOverlayEditor("txtRemarks", 4000);
	});	
	
	$("imgEditRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000);
	});	
	
	$("btnAddUpdate").observe("click", function() {
		valAddRec();			
	});	
	
	$("btnDelete").observe("click", function(){	
		if (chkDeleteGIISS055MotorType()){
			deleteInMotorType();			
		}				
	});
	
	observeSaveForm("btnSave", saveGiiss055);
	
	$("btnCancel").observe("click", cancelGiiss055);
		
	$("showHideMotorType").observe("click", function() {
		showHideDiv("showBody","showHideMotorType");
	});
	
	$("underwritingExit").observe("click",cancelGiiss055);
	
	initializeGIISS055();	
} catch (e) {
	showErrorMessage("Error : ", e.message);
}
	
</script>