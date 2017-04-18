<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="drvrOccptnMaintenance" name="drvrOccptnMaintenance" style="float: left; width: 100%;">
	<div id="drvrOccptnMaintenanceExitDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="claimsExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Driver Occupation Maintenance</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="showHideDrvrOccptn" name="gro" style="margin-left: 5px;">Hide</label> 
			 	<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>
	<div id="showBody">	
		<div class="sectionDiv">
			<div style="padding:10px;">
				<div id="drvrOccptnTableGrid" style="height: 331px;width:700px;margin-left: 100px"></div>
			</div>	
			<div>	
				<div align="center">
					<table>					
						<tr>
							<td align="right">Code</td>
							<td><input class="required" id="txtCode" maxlength="6" type="text" style="width:150px;"></td>
							<td align="right" style="width: 50px;">Description</td>
							<td><input class="required" id="txtDescription" maxlength="50" type="text" style="width:280px;"></td>
						</tr>						
						<tr>
							<td align="right">Remarks</td>
							<td colspan="3">
								<div style="border: 1px solid gray; height: 21px; width: 572px">
									<textarea id="txtRemarks" name="txtRemarks" style="border: none; height: 13px; resize: none; width: 546px"></textarea>
									<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; padding: 3px; float: right;" alt="EditRemark" id="imgEditRemarks"/>
								</div>
							</td>
						</tr>
						<tr>
							<td align="right">User ID</td>
							<td><input id="txtUserId" type="text" style="width:150px" readonly="readonly"></td>
							<td align="right" style="width: 120px;">Last Update</td>
							<td><input id="txtLastUpdate" type="text"  style="width:280px" readonly="readonly"></td>
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
<script type="text/javascript" src="${pageContext.request.contextPath}/js/claims/claims.js">
try {
	setModuleId("GICLS511");
	setDocumentTitle("Driver Occupation Maintenance");
	var row;
	var objDrvrOccptnMain = [];
	var jsonDrvrOccptn = JSON.parse('${jsonDrvrOccptn}');
	drvrOccptnTableModel = {
		url : contextPath
				+ "/GICLDrvrOccptnController?action=showDrvrOccptnMaintenance&refresh=1",
		options : {
			width : '700px',
			pager : {},
			toolbar : {
				elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
				onFilter: function(){	
					if(changeTag==0){
						tbgDrvrOccptn.keys.removeFocus(
								tbgDrvrOccptn.keys._nCurrentFocus, true);
						tbgDrvrOccptn.keys.releaseKeys();	
						setDrvrOccptnDtls(null);
						setBtnAndFields(null);
						setObjDrvrOccptn(null);
						fieldFocus(null);
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
					tbgDrvrOccptn.keys.removeFocus(
							tbgDrvrOccptn.keys._nCurrentFocus, true);
					tbgDrvrOccptn.keys.releaseKeys();	
					setDrvrOccptnDtls(null);
					setBtnAndFields(null);
					setObjDrvrOccptn(null);
					fieldFocus(null);
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}									
			},
			onCellFocus : function(element, value, x, y, id) {						
				tbgDrvrOccptn.keys.removeFocus(
						tbgDrvrOccptn.keys._nCurrentFocus, true);
				tbgDrvrOccptn.keys.releaseKeys();		
				setDrvrOccptnDtls(tbgDrvrOccptn.geniisysRows[y]);
				setBtnAndFields(tbgDrvrOccptn.geniisysRows[y]);
				setObjDrvrOccptn(tbgDrvrOccptn.geniisysRows[y]);
				fieldFocus(tbgDrvrOccptn.geniisysRows[y]);
				row = y;
			},
			onRemoveRowFocus : function(element, value, x, y, id) {	
				tbgDrvrOccptn.keys.removeFocus(
						tbgDrvrOccptn.keys._nCurrentFocus, true);
				tbgDrvrOccptn.keys.releaseKeys();	
				setDrvrOccptnDtls(null);
				setBtnAndFields(null);
				setObjDrvrOccptn(null);
				fieldFocus(null);
			},
			beforeSort : function() {			
				if(changeTag==0){
					tbgDrvrOccptn.keys.removeFocus(
							tbgDrvrOccptn.keys._nCurrentFocus, true);
					tbgDrvrOccptn.keys.releaseKeys();		
					setDrvrOccptnDtls(null);
					setBtnAndFields(null);
					setObjDrvrOccptn(null);
					fieldFocus(null);
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}					
			},
			onSort : function() {	
				if(changeTag==0){
					tbgDrvrOccptn.keys.removeFocus(
							tbgDrvrOccptn.keys._nCurrentFocus, true);
					tbgDrvrOccptn.keys.releaseKeys();		
					setDrvrOccptnDtls(null);
					setBtnAndFields(null);
					setObjDrvrOccptn(null);
					fieldFocus(null);
				}
			},
			onRefresh : function() {
				if(changeTag==0){
					tbgDrvrOccptn.keys.removeFocus(
							tbgDrvrOccptn.keys._nCurrentFocus, true);
					tbgDrvrOccptn.keys.releaseKeys();	
					setDrvrOccptnDtls(null);
					setBtnAndFields(null);
					setObjDrvrOccptn(null);
					fieldFocus(null);
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
			id : "drvrOccCd",
			title : "Code",
			width : '120px',
			align : "left",
			titleAlign : "left",
			filterOption : true					
		},{
			id : "occDesc",
			title : "Description",
			
			width : '570px',
			align : "left",
			titleAlign : "left",
			filterOption : true,			
		}],
		rows : jsonDrvrOccptn.rows
	};

	tbgDrvrOccptn = new MyTableGrid(drvrOccptnTableModel);
	tbgDrvrOccptn.pager = jsonDrvrOccptn;
	tbgDrvrOccptn.render('drvrOccptnTableGrid');
	tbgDrvrOccptn.afterRender = function(){
		objDrvrOccptnMain = tbgDrvrOccptn.geniisysRows;
		changeTag = 0;
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
	
	function setDrvrOccptnDtls(obj) {		
		try {
			$("txtCode").value = obj == null ? "" : unescapeHTML2(obj.drvrOccCd);
			$("txtDescription").value = obj == null ? "" : unescapeHTML2(obj.occDesc);
			$("txtRemarks").value = obj == null ? "" : unescapeHTML2(obj.remarks);	
			$("txtUserId").value = obj == null ? "" : obj.userId;
			$("txtLastUpdate").value = obj == null ? "" : obj.lastUpdate;		
		} catch (e) {
			showErrorMessage("setDrvrOccptnDtls", e);
		}
	}	
	
	function setBtnAndFields(obj) {
		if (obj != null) {				
			enableButton("btnDelete");	
			$("btnAddUpdate").value = "Update";		
			$("txtCode").readOnly = "readonly"; 
		}else{
			$("btnAddUpdate").value = "Add";						
			enableButton("btnAddUpdate");
			enableButton("btnCancel");
			enableButton("btnSave");
			disableButton("btnDelete");
			$("txtCode").readOnly = false; 
		}
	}
	
	function setObjDrvrOccptn(obj) {
		try {		
			objDrvrOccptn.drvrOccCd = obj == null ? "" : (obj.drvrOccCd==null?"":unescapeHTML2(obj.drvrOccCd));
			objDrvrOccptn.occDesc = obj == null ? "" : (obj.occDesc==null?"":unescapeHTML2(obj.occDesc));	
			objDrvrOccptn.remarks = obj == null ? "" : (obj.remarks==null?"":unescapeHTML2(obj.remarks));
			objDrvrOccptn.userId = obj == null ? "" : (obj.userId==null?"":obj.userId);
			objDrvrOccptn.lastUpdate = obj == null ? "" : (obj.lastUpdate==null?"":obj.lastUpdate);	
		} catch (e) {
			showErrorMessage("setObjDrvrOccptn", e);
		}
	}
	
	function setRowObjDrvrOccptn(func){
		try {					
			var rowObjDrvrOccptn = new Object();
			rowObjDrvrOccptn.drvrOccCd = escapeHTML2($("txtCode").value);	
			rowObjDrvrOccptn.occDesc = escapeHTML2($("txtDescription").value);		
			rowObjDrvrOccptn.remarks = escapeHTML2($("txtRemarks").value);
			rowObjDrvrOccptn.userId = $("txtUserId").value;
			rowObjDrvrOccptn.lastUpdate = $("txtLastUpdate").value;
			rowObjDrvrOccptn.recordStatus 	= func == "Delete" ? -1 : func == "Add" ? 0 : 1;
			return rowObjDrvrOccptn;
		} catch (e) {
			showErrorMessage("setRowObjDrvrOccptn", e);
		}
	}	
	
	function chkRequiredFields(){	
		if($("txtCode").value == ""){
			showMessageBox("Required fields must be entered.", imgMessage.ERROR);
			objDrvrOccptn.saveResult = false;			
			return false;
		}else if($("txtDescription").value == ""){
			showMessageBox("Required fields must be entered.", imgMessage.ERROR);
			objDrvrOccptn.saveResult = false;		
			return false;
		}else{
			return true;
		}
	}
		
	function chkChangesBfrAction(func, action){	
		if(changeTag==0){
			func();
		}else{
			 showConfirmBox4("Confirmation",objCommonMessage.WITH_CHANGES ,"Yes","No","Cancel",
				function(){
				 saveDrvrOccptnMaintenance(func);					
				 },function(){
					 func();					
					 },"",1);
				 
		}
	}
	
	function actionOnCancel(){	
		if(changeTag==0){
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");	
		}else{
			tbgDrvrOccptn._refreshList();		
			tbgDrvrOccptn.keys.removeFocus(
					tbgDrvrOccptn.keys._nCurrentFocus, true);
			tbgDrvrOccptn.keys.releaseKeys();
		}	
	}
	
	function addUpdateDrvrOccptn(){
		rowObj  = setRowObjDrvrOccptn($("btnAddUpdate").value);
		if(chkRequiredFields()){
			if($("btnAddUpdate").value=="Update"){
				if(chkIfThereAreChanges(rowObj)){
					changeTag=1;					
				}	
				objDrvrOccptnMain.splice(row, 1, rowObj);
				tbgDrvrOccptn.updateVisibleRowOnly(rowObj, row);
				tbgDrvrOccptn.onRemoveRowFocus();
			}else if ($("btnAddUpdate").value=="Add"){				
				objDrvrOccptnMain.push(rowObj);
				tbgDrvrOccptn.addBottomRow(rowObj);
				tbgDrvrOccptn.onRemoveRowFocus();
				changeTag = 1;		
			}
		}
	}
	
	function deleteInDrvrOccptn(){ 
		delObj = setRowObjDrvrOccptn($("btnDelete").value);
		objDrvrOccptnMain.splice(row, 1, delObj);
		tbgDrvrOccptn.deleteVisibleRowOnly(row);
		changeTag = 1;
		setDrvrOccptnDtls(null);	
		setBtnAndFields(null);		
	}
	
	function saveDrvrOccptnMaintenance(func){
		try{	
			var objParams = new Object(); 
			objParams.setRows = getAddedAndModifiedJSONObjects(objDrvrOccptnMain);
			objParams.delRows = getDeletedJSONObjects(objDrvrOccptnMain);
			new Ajax.Request(contextPath + "/GICLDrvrOccptnController", {
				method : "POST",
				parameters : {
					action : "saveDrvrOccptnMaintenance",
					parameters : JSON.stringify(objParams)				
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : function(){
					showNotice("Saving Driver Occupation Maintenance, please wait ...");
				},
				onComplete : function(response) {
					hideNotice();
					var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
					if (checkErrorOnResponse(response)){
						if (res.message != "SUCCESS"){
							showWaitingMessageBox(res.message, "E", function() {
								if(func){
					    			func();
					    		}
							});							
						}else{
							showWaitingMessageBox(objCommonMessage.SUCCESS,imgMessage.SUCCESS, function() {
					    		if(func){
					    			func();
					    		}
					    		tbgDrvrOccptn._refreshList();		
								tbgDrvrOccptn.keys.removeFocus(
										tbgDrvrOccptn.keys._nCurrentFocus, true);
								tbgDrvrOccptn.keys.releaseKeys();
								changeTag = 0;
								changeTagFunc = "";
							});							
						}
					}
				}
			});				
		}catch(e){
			showErrorMessage("saveDrvrOccptnMaintenance", e);
		}
	}
	
	function validateDrvrOccptnInput(inputString){
		try{				
		 	new Ajax.Request(contextPath + "/GICLDrvrOccptnController", {
				method : "POST",
				parameters : {
					action : "validateDrvrOccptnInput",
					inputString : inputString				
				},	
				asynchronous : false,
				evalScripts : true,				
				onComplete : function(response) {
					hideNotice();
					var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));									
					if (res.result != "TRUE"){						
						showMessageBox(res.result, imgMessage.INFO);
						$("txtCode").value = "";													
					}									
				}
			}); 	
		}catch(e){
			showErrorMessage("validateDrvrOccptnInput", e);
		}
	}
	
	function chkIfThereAreChanges(obj){			
		if (
			obj.drvrOccCd == objDrvrOccptn.drvrOccCd&&
			obj.occDesc == objDrvrOccptn.occDesc&&
			obj.remarks == objDrvrOccptn.remarks){
			return false;
		}else {
			return true;
		}
	}
	
	function fieldFocus(obj){	
		$("txtCode").focus();		
	}
	
	function initializeGICLS511(){
		setBtnAndFields(null);		
		objDrvrOccptn = new Object();
		changeTag = 0;
		fieldFocus(null);
	}	
		
	$("btnSave").observe("click", function() {
		if(changeTag==1){			
			saveDrvrOccptnMaintenance();						
		}else{
			showMessageBox(objCommonMessage.NO_CHANGES, imgMessage.INFO);
		}		
	});
	
	$("btnCancel").observe("click", function() {
		chkChangesBfrAction(function(){
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");	
			changeTag = 0;
			changeTagFunc = "";
			});	
	});
	
	$("btnAddUpdate").observe("click", function() {		
		addUpdateDrvrOccptn();	
		changeTagFunc = saveDrvrOccptnMaintenance; // for logout confirmation	
	});
	
	$("btnDelete").observe("click", function() {	
		deleteInDrvrOccptn();	
		changeTagFunc = saveDrvrOccptnMaintenance; // for logout confirmation	
	});	
	
	$("txtCode").observe("change", function() {
		if($("txtCode").value!=""&&$("txtCode").value!=objDrvrOccptn.drvrOccCd){
			validateDrvrOccptnInput($("txtCode").value);
		}
	});
	
	$("imgEditRemarks").observe("click", function() {
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"), function() {
			limitText($("txtRemarks"),4000);
		});
	});

	$("txtRemarks").observe("keyup", function() {
		limitText(this, 4000);
	});
	
	observeReloadForm("reloadForm", function(){
		showDrvrOccptnMaintenance();
		});
	
	$("showHideDrvrOccptn").observe("click", function() {
		showHideDiv("showBody","showHideDrvrOccptn");
	});
	
	$("claimsExit").observe("click", function() {
		chkChangesBfrAction(function(){
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");	
			changeTag = 0;
			changeTagFunc = "";
		});
	});
	
	initializeGICLS511();	
} catch (e) {
	showErrorMessage("Error : ", e.message);
}
	
</script>