<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="geographyClassMaintenance" name="geographyClassMaintenance" style="float: left; width: 100%;">
	<div id="geographyClassMaintenanceExitDiv">
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
			<label>Geography Classification Maintenance</label>
			<span class="refreshers" style="margin-top: 0;">
			 	<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>
	<div id="showBody">			
		<div class="sectionDiv">
			<div style="padding:10px;">
				<div id="geogClassTableGrid" style="height: 331px;width:700px; margin-left: 100px"></div>
			</div>	
			<div>	
				<div align="center">
					<table>					
						<tr>
							<td align="right">Geography Code</td>
							<td><input class="required" id="txtGeogCd" maxlength="2" type="text" style="width:150px;"></td>
							<td align="right" style="width: 140px;">Geography Description</td>
							<td><input class="required" id="txtGeogDesc" maxlength="25" type="text" style="width:260px;"></td>
						</tr>
						<tr>
							<td align="right">Type</td>
							<td><span class="lovSpan" style="width: 156px; margin-top:2px;height:19px;">
									<input class="required" id="txtClassType" type="text" maxlength="1" style="width:130px;margin: 0;height:13px;border: 0"><img
									src="${pageContext.request.contextPath}/images/misc/searchIcon.png"
									id="imgSearchClassType" alt="Go" style="float: right; margin-top: 2px;" />
								</span>	
							</td>	
							<td align="right">Class Type</td>					
							<td><input id="txtMeanClassType" readonly="readonly" maxlength="8" type="text" style="width:260px;"></td>
						</tr>
						<tr>
							<td align="right">Remarks</td>
							<td colspan="3">
								<div style="border: 1px solid gray; height: 21px; width: 572px">
									<textarea id="txtRemarks" name="txtRemarks" style="border: none; height: 13px; resize: none; width: 542px" maxlength="4000"></textarea>
									<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; padding: 3px; float: right;" alt="EditRemark" id="imgEditRemarks"/>
								</div>
							</td>
						</tr>
						<tr>
							<td align="right">User ID</td>
							<td><input id="txtUserId" type="text" style="width:150px" readonly="readonly"></td>
							<td align="right" style="width: 70px;">Last Update</td>
							<td><input id="txtLastUpdate" type="text"  style="width:260px" readonly="readonly"></td>
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
	setModuleId("GIISS080");
	setDocumentTitle("Geography Classification Maintenance");
	var row;
	var objGeogClassMain = [];	
	var jsonGeogClass = JSON.parse('${jsonGeogClass}');
	geogClassTableModel = {
		url : contextPath
				+ "/GIISGeogClassController?action=showGeographyClass&refresh=1",
		options : {
			width : '700px',
			pager : {},
			toolbar : {
				elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
				onFilter: function(){	
					if(changeTag==0){
						tbgGeogClass.keys.removeFocus(
								tbgGeogClass.keys._nCurrentFocus, true);
						tbgGeogClass.keys.releaseKeys();
						setBtnAndFields(null);	
						setGeogClassDtls(null);	
						fieldFocus(null);	
						setObjGeogClass(null);			
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
					tbgGeogClass.keys.removeFocus(
							tbgGeogClass.keys._nCurrentFocus, true);
					tbgGeogClass.keys.releaseKeys();
					setBtnAndFields(null);	
					setGeogClassDtls(null);	
					fieldFocus(null);	
					setObjGeogClass(null);					
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}								
			},
			onCellFocus : function(element, value, x, y, id) {						
				tbgGeogClass.keys.removeFocus(
						tbgGeogClass.keys._nCurrentFocus, true);
				tbgGeogClass.keys.releaseKeys();	
				setGeogClassDtls(tbgGeogClass.geniisysRows[y]);
				setBtnAndFields(tbgGeogClass.geniisysRows[y]);				
				fieldFocus(tbgGeogClass.geniisysRows[y]);		
				setObjGeogClass(tbgGeogClass.geniisysRows[y]);					
				row = y;
			},
			onRemoveRowFocus : function(element, value, x, y, id) {				
				tbgGeogClass.keys.removeFocus(
						tbgGeogClass.keys._nCurrentFocus, true);
				tbgGeogClass.keys.releaseKeys();
				setBtnAndFields(null);	
				setGeogClassDtls(null);	
				fieldFocus(null);	
				setObjGeogClass(null);					
			},
			beforeSort : function() {			
				if(changeTag==0){
					tbgGeogClass.keys.removeFocus(
							tbgGeogClass.keys._nCurrentFocus, true);
					tbgGeogClass.keys.releaseKeys();
					setBtnAndFields(null);	
					setGeogClassDtls(null);	
					fieldFocus(null);		
					setObjGeogClass(null);				
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}					
			},
			onSort : function() {				
				if(changeTag==0){
					tbgGeogClass.keys.removeFocus(
							tbgGeogClass.keys._nCurrentFocus, true);
					tbgGeogClass.keys.releaseKeys();
					setBtnAndFields(null);	
					setGeogClassDtls(null);	
					fieldFocus(null);		
					setObjGeogClass(null);				
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}			
			},
			onRefresh : function() {				
				if(changeTag==0){
					tbgGeogClass.keys.removeFocus(
							tbgGeogClass.keys._nCurrentFocus, true);
					tbgGeogClass.keys.releaseKeys();
					setBtnAndFields(null);	
					setGeogClassDtls(null);	
					fieldFocus(null);	
					setObjGeogClass(null);					
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
			id : "geogCd",
			title : "Geography Code",
			width : '120px',
			align : "left",
			titleAlign : "left",
			filterOption : true,
			filterOptionType : 'integerNoNegative'
		}, {
			id : "geogDesc",
			title : "Geography Description",			
			width : '350px',
			align : "left",
			titleAlign : "left",
			filterOption : true			
		}, {
			id : "classType",
			title : "Type",
			width : '76px',
			align : "left",
			titleAlign : "left",
			filterOption : true					
		}, {
			id : "meanClassType",
			title : "Class Type",			
			width : '140px',
			align : "left",
			titleAlign : "left",
			filterOption : true			
		}],
		rows : jsonGeogClass.rows
	};

	tbgGeogClass = new MyTableGrid(geogClassTableModel);
	tbgGeogClass.pager = jsonGeogClass;
	tbgGeogClass.render('geogClassTableGrid');
	tbgGeogClass.afterRender = function(){
		objGeogClassMain = tbgGeogClass.geniisysRows;
		changeTag = 0;
	};	
	
	function getGIISS080ClassTypeLOV() {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getGIISS080ClassTypeLOV",
				searchString : ($("txtClassType").readAttribute("lastValidValue") != $F("txtClassType") ? nvl($F("txtClassType"),"%") : "%"),
				page : 1,				
			},
			title : "Valid Values for Type",
			width : 381,
			height : 386,
			columnModel : [{
				id : "rvMeaning",
				title : "Meaning",
				width : '270px',
			}],
			draggable : true,
			autoSelectOneRecord : true,
			filterText :$("txtClassType").value,
			onSelect : function(row) {
				$("txtClassType").value = unescapeHTML2(row.rvLowValue);	
				$("txtMeanClassType").value = unescapeHTML2(row.rvMeaning);				
				$("txtClassType").setAttribute("lastValidValue", row.rvLowValue);
				$("txtMeanClassType").setAttribute("lastValidValue", row.rvMeaning);			
			},
			onCancel : function() {
				$("txtClassType").value = $("txtClassType").readAttribute("lastValidValue");
				$("txtMeanClassType").value=$("txtMeanClassType").readAttribute("lastValidValue");
			},
			onUndefinedRow : function() {
				customShowMessageBox("No record selected.", imgMessage.INFO,
						"txtLineCd");		
				$("txtClassType").value = "";	
				$("txtMeanClassType").value = "";	
				$("txtClassType").setAttribute("lastValidValue", "");
				$("txtMeanClassType").setAttribute("lastValidValue", "");			
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();
			}
		});
	}	
	
	function validateGeogCdInput(){
		try{	
			var valid = true;
		 	new Ajax.Request(contextPath + "/GIISGeogClassController", {
				method : "POST",
				parameters : {
					action : "validateGeogCdInput",		
					inputString : $("txtGeogCd").value		
				},	
				asynchronous : false,
				evalScripts : true,				
				onComplete : function(response) {
					hideNotice();
					var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));									
					if (res.result != "TRUE"){		
						customShowMessageBox(res.result, "I", "txtGeogCd");
						$("txtGeogCd").value = "";	
						valid = false;
					}				
				}
			}); 
		 	return valid;
		}catch(e){
			showErrorMessage("validateGeogCdInput", e);
		}
	}
	
	function validateGeogDescInput(){
		try{			
			var valid = true;
		 	new Ajax.Request(contextPath + "/GIISGeogClassController", {
				method : "POST",
				parameters : {
					action : "validateGeogDescInput",		
					inputString : $("txtGeogDesc").value		
				},	
				asynchronous : false,
				evalScripts : true,				
				onComplete : function(response) {
					hideNotice();
					var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));									
					if (res.result != "TRUE"){		
						customShowMessageBox(res.result, "I", "txtGeogDesc");
						$("txtGeogDesc").value = "";	
						valid = false;
					}				
				}
			}); 	
		 	return valid;
		}catch(e){
			showErrorMessage("validateGeogDescInput", e);
		}
	}
	
	function setBtnAndFields(obj) {
		if (obj != null) {				
			enableButton("btnDelete");				
			$("btnAddUpdate").value = "Update";		
			$("txtGeogCd").readOnly = "readonly"; 
		}else{
			$("btnAddUpdate").value = "Add";	
			enableButton("btnCancel");
			enableButton("btnSave");
			enableButton("btnAddUpdate");
			disableButton("btnDelete");
			$("txtGeogCd").readOnly = false; 
		}
	}
	
	function setGeogClassDtls(obj) {		
		try {			
			$("txtGeogCd").value = obj == null ? "" : unescapeHTML2(obj.geogCd);
			$("txtGeogDesc").value = obj == null ? "" : unescapeHTML2(obj.geogDesc);
			$("txtClassType").value = obj == null ? "" : unescapeHTML2(obj.classType);
			$("txtMeanClassType").value = obj == null ? "" : unescapeHTML2(obj.meanClassType);
			$("txtRemarks").value = obj == null ? "" : unescapeHTML2(obj.remarks);	
			$("txtUserId").value = obj == null ? "" : obj.userId;
			$("txtLastUpdate").value = obj == null ? "" : obj.lastUpdate;
			$("txtClassType").setAttribute("lastValidValue", obj == null ? "": (obj.classType==null? "":obj.classType));
			$("txtMeanClassType").setAttribute("lastValidValue", obj == null ? "": (obj.meanClassType==null? "":obj.meanClassType));			
		} catch (e) {
			showErrorMessage("setGeogClassDtls", e);
		}
	}
	
	function setObjGeogClass(obj) {
		try {		
			objGeogClass.geogCd = obj == null ? "" : (obj.geogCd==null?"":unescapeHTML2(obj.geogCd));
			objGeogClass.geogDesc = obj == null ? "" : (obj.geogDesc==null?"":unescapeHTML2(obj.geogDesc));
			objGeogClass.classType = obj == null ? "" : (obj.classType==null?"":unescapeHTML2(obj.classType));
			objGeogClass.meanClassType = obj == null ? "" : (obj.meanClassType==null?"":unescapeHTML2(obj.meanClassType));
			objGeogClass.remarks = obj == null ? "" : (obj.remarks==null?"":unescapeHTML2(obj.remarks));
			objGeogClass.userId = obj == null ? "" : (obj.userId==null?"":obj.userId);
			objGeogClass.lastUpdate = obj == null ? "" : (obj.lastUpdate==null?"":obj.lastUpdate);			
		} catch (e) {
			showErrorMessage("setObjGeogClass", e);
		}
	}
	
	function fieldFocus(obj){
		if(obj!=null){
			$("txtGeogDesc").focus();	
		}else{			
			$("txtGeogCd").focus();	
				
		}
	}
	
	function initializeGIISS080(){
		setBtnAndFields(null);		
		objGeogClass = new Object();
		fieldFocus(null);
		changeTag = 0;
	}	
	
	function chkRequiredFields(){	
		if($("txtGeogCd").value == ""){
			customShowMessageBox("Required fields must be entered.", imgMessage.INFO,"txtGeogCd");			
			return false;
		}else if($("txtGeogDesc").value == ""){
			customShowMessageBox("Required fields must be entered.", imgMessage.INFO,"txtGeogDesc");	
			return false;
		}else if($("txtClassType").value == ""){
			customShowMessageBox("Required fields must be entered.", imgMessage.INFO,"txtClassType");	
			return false;
		}else{
			return true;
		}
	}
	
	function setRowObjGeogClass(func){
		try {					
			var rowObjGeogClass = new Object();
			rowObjGeogClass.geogCd = escapeHTML2($("txtGeogCd").value);	
			rowObjGeogClass.geogDesc = escapeHTML2($("txtGeogDesc").value);	
			rowObjGeogClass.classType = escapeHTML2($("txtClassType").value);	
			rowObjGeogClass.meanClassType = escapeHTML2($("txtMeanClassType").value);	
			rowObjGeogClass.remarks = escapeHTML2($("txtRemarks").value);
			rowObjGeogClass.userId = $("txtUserId").value;
			rowObjGeogClass.lastUpdate = $("txtLastUpdate").value;
			rowObjGeogClass.recordStatus 	= func == "Delete" ? -1 : func == "Add" ? 0 : 1;
			return rowObjGeogClass;
		} catch (e) {
			showErrorMessage("setRowObjGeogClass", e);
		}
	}	
	
	function chkIfThereAreChanges(obj){			
		if (
			obj.geogCd == objGeogClass.geogCd&&
			obj.geogDesc == objGeogClass.geogDesc&&
			obj.classType == objGeogClass.classType&&
			obj.remarks == objGeogClass.remarks){
			return false;
		}else {
			return true;
		}
	}

	function addUpdateGeogClass(){
		rowObj  = setRowObjGeogClass($("btnAddUpdate").value);
		if(chkRequiredFields()){
			if($("btnAddUpdate").value=="Update"){
				if(chkIfThereAreChanges(rowObj)){
					changeTag=1;					
				}	
				objGeogClassMain.splice(row, 1, rowObj);
				tbgGeogClass.updateVisibleRowOnly(rowObj, row);
				tbgGeogClass.onRemoveRowFocus();
			}else if ($("btnAddUpdate").value=="Add"){				
				objGeogClassMain.push(rowObj);
				tbgGeogClass.addBottomRow(rowObj);
				tbgGeogClass.onRemoveRowFocus();
				changeTag = 1;		
			}
		}
	}

	function deleteInGeogClass(){ 
		delObj = setRowObjGeogClass($("btnDelete").value);
		objGeogClassMain.splice(row, 1, delObj);
		tbgGeogClass.deleteVisibleRowOnly(row);
		changeTag = 1;
		setGeogClassDtls(null);	
		setBtnAndFields(null);			
	}

	function saveGeogClass(func){
		try{	
			var objParams = new Object(); 
			objParams.setRows = getAddedAndModifiedJSONObjects(objGeogClassMain);
			objParams.delRows = getDeletedJSONObjects(objGeogClassMain);
			new Ajax.Request(contextPath + "/GIISGeogClassController", {
				method : "POST",
				parameters : {
					action : "saveGeogClass",
					parameters : JSON.stringify(objParams)				
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : function(){
					showNotice("Saving Geography Classification Maintenance, please wait ...");
				},
				onComplete : function(response) {
					hideNotice();
					var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
					if (checkErrorOnResponse(response)){
						if (res.message != "SUCCESS"){
							showWaitingMessageBox(res.message, "E", function() {
					    		func();
							});							
						}else{
							showWaitingMessageBox(objCommonMessage.SUCCESS,imgMessage.SUCCESS, function() {
					    		func();
							});	
							changeTag = 0;
							changeTagFunc = "";
						}
					}
				}
			});				
		}catch(e){
			showErrorMessage("saveGeogClass", e);
		}
	}
	
	function validateBeforeDelete(){
		try{	
			var canDelete = true;
		 	new Ajax.Request(contextPath + "/GIISGeogClassController", {
				method : "POST",
				parameters : {
					action : "validateBeforeDelete",				
					geogCd: $("txtGeogCd").value					
				},	
				asynchronous : false,
				evalScripts : true,				
				onComplete : function(response) {
					hideNotice();
					var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));									
					if (res.result != "TRUE"){					
						showMessageBox(res.result, imgMessage.INFO);
						canDelete = false;											
					}					
				}
			}); 
		 	return canDelete;
		}catch(e){
			showErrorMessage("validateBeforeDelete", e);
		}
	}
	
	function chkChangesBfrAction(func, action){	
		if(changeTag==0){
			func();
		}else{
			 showConfirmBox4("Confirmation",objCommonMessage.WITH_CHANGES ,"Yes","No","Cancel",
				function(){
				 saveGeogClass(func);					
				 },function(){
					 func();					
					 },"",1);
				 
		}
	}
	
	$("btnAddUpdate").observe("click", function() {
		addUpdateGeogClass();	
		changeTagFunc = saveGeogClass; // for logout confirmation
		
	});

	$("btnDelete").observe("click", function(){
		if (validateBeforeDelete()){
			deleteInGeogClass();
			changeTagFunc = saveGeogClass; // for logout confirmation
		}
	});

	$("btnSave").observe("click", function() {
		if(changeTag==1){			
			saveGeogClass(function(){
				tbgGeogClass._refreshList();		
				tbgGeogClass.keys.removeFocus(
						tbgGeogClass.keys._nCurrentFocus, true);
				tbgGeogClass.keys.releaseKeys();
			});						
		}else{
			showMessageBox(objCommonMessage.NO_CHANGES, imgMessage.INFO);
		}		
	});

	$("btnCancel").observe("click", function() {
		chkChangesBfrAction(function(){
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main" , null); 
			changeTag = 0;
			changeTagFunc = "";
			});			
	});
	
	observeReloadForm("reloadForm", function(){
		showGeographyClass();
		});
	
	$("txtGeogCd").observe("change", function(){	
		if(isNaN($F("txtGeogCd"))){
			$("txtGeogCd").clear();
			customShowMessageBox("Field Geography Code must be of form 09.", "I", "txtGeogCd");
		}		
		if ($("txtGeogCd").value != "") {
			if(validateGeogCdInput()){
				Object.keys(objGeogClassMain).forEach(function(i) {
				    if(objGeogClassMain[i].geogCd==$("txtGeogCd").value){
				    	showWaitingMessageBox("Geography code must be unique.", "I", function() {
				    		$("txtGeogCd").value ="";
				   			$("txtGeogCd").focus();
						});		
					}
				});
			}
		}	
	});
	
	$("txtGeogDesc").observe("keyup", function(){
		$("txtGeogDesc").value = $F("txtGeogDesc").toUpperCase();
	});
	
	$("txtGeogDesc").observe("change", function(){
		if ($("txtGeogDesc").value != "") {
			if(validateGeogDescInput()){
				Object.keys(objGeogClassMain).forEach(function(i) {
				    if(objGeogClassMain[i].geogDesc==$("txtGeogDesc").value){
				    	showWaitingMessageBox("Geography Classification Description already exists.", "I", function() {
				    		$("txtGeogDesc").value ="";
				   			$("txtGeogDesc").focus();
						});		
					}
				});
			}
		}
	});
	
	$("txtClassType").observe("keyup", function(){
		$("txtClassType").value = $F("txtClassType").toUpperCase();
	});

	
	$("txtClassType").observe("change", function() {
		if($("txtClassType").value!=""&& $("txtClassType").value != $("txtClassType").readAttribute("lastValidValue")){
			getGIISS080ClassTypeLOV();
		}else if($F("txtClassType").trim() == "") {
			$("txtClassType").setAttribute("lastValidValue", "");
			$("txtMeanClassType").setAttribute("lastValidValue", "");
			$("txtMeanClassType").value="";			
		}
	});	
	
	$("imgSearchClassType").observe("click", function() {	
		getGIISS080ClassTypeLOV();
	});
	
	$("imgEditRemarks").observe("click", function() {
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"), function() {
			limitText($("txtRemarks"),4000);
		});
	});

	$("txtRemarks").observe("keyup", function() {
		limitText(this, 4000);
	});
		
	$("underwritingExit").observe("click", function() {
		chkChangesBfrAction(function(){
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main" , null); 
			changeTag = 0;
			changeTagFunc = "";
			});				
	});
	
	initializeGIISS080();	
} catch (e) {
	showErrorMessage("Error : ", e.message);
}
	
</script>