<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="claimStatusMaintenance" name="claimStatusMaintenance" style="float: left; width: 100%;">
	<div id="claimStatusMaintenanceExitDiv">
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
			<label>Claim Status Maintenance</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="showHideClaimStatus" name="gro" style="margin-left: 5px;">Hide</label> 
			 	<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>
	<div id="showBody">	
		<div class="sectionDiv">
			<div style="padding:10px;">
				<div id="claimStatusTableGrid" style="height: 331px;width:700px;margin-left: 100px"></div>
			</div>	
			<div>	
				<div align="center">
					<table>					
						<tr>
							<td align="right">Code</td>
							<td><input class="required" id="txtCode" maxlength="2" type="text" style="width:150px;"></td>
							<td align="right" style="width: 120px;">Status Description</td>
							<td><input class="required" id="txtStatusDesc" type="text" style="width:280px;">

							</td>
						</tr>
						<tr>
							<td align="right">Remarks</td>
							<td colspan="3">
								<span class="lovSpan" style="width: 572px; margin: 0">
										<input
										style="width: 546px; float: left; height: 14px; border: none; margin:0"
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
	setModuleId("GICLS160");
	setDocumentTitle("Claim Status Maintenance");
	var row;
	var objClaimStatusMain = [];
	var jsonClaimStatus = JSON.parse('${jsonClaimStatus}');
	claimStatusTableModel = {
		url : contextPath
				+ "/GIISClmStatController?action=showClaimStatusMaintenance&refresh=1",
		options : {
			width : '700px',
			pager : {},
			toolbar : {
				elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
				onFilter: function(){	
					if(changeTag==1){
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
					tbgClaimStatus.keys.removeFocus(
							tbgClaimStatus.keys._nCurrentFocus, true);
					tbgClaimStatus.keys.releaseKeys();	
					setClaimStatusDtls(null);
					setBtnAndFields(null);
					setObjClaimStatus(null);
					fieldFocus(null);
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}								
			},
			onCellFocus : function(element, value, x, y, id) {						
				tbgClaimStatus.keys.removeFocus(
						tbgClaimStatus.keys._nCurrentFocus, true);
				tbgClaimStatus.keys.releaseKeys();		
				setClaimStatusDtls(tbgClaimStatus.geniisysRows[y]);
				setBtnAndFields(tbgClaimStatus.geniisysRows[y]);
				setObjClaimStatus(tbgClaimStatus.geniisysRows[y]);
				fieldFocus(tbgClaimStatus.geniisysRows[y]);
				row = y;
			},
			onRemoveRowFocus : function(element, value, x, y, id) {	
				tbgClaimStatus.keys.removeFocus(
						tbgClaimStatus.keys._nCurrentFocus, true);
				tbgClaimStatus.keys.releaseKeys();	
				setClaimStatusDtls(null);
				setBtnAndFields(null);
				setObjClaimStatus(null);
				fieldFocus(null);
			},
			beforeSort : function() {			
				if(changeTag==0){
					tbgClaimStatus.keys.removeFocus(
							tbgClaimStatus.keys._nCurrentFocus, true);
					tbgClaimStatus.keys.releaseKeys();		
					setClaimStatusDtls(null);
					setBtnAndFields(null);
					setObjClaimStatus(null);
					fieldFocus(null);
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}					
			},
			onSort : function() {				
				tbgClaimStatus.keys.removeFocus(
						tbgClaimStatus.keys._nCurrentFocus, true);
				tbgClaimStatus.keys.releaseKeys();		
				setClaimStatusDtls(null);
				setBtnAndFields(null);
				setObjClaimStatus(null);
				fieldFocus(null);
			},
			onRefresh : function() {				
				tbgClaimStatus.keys.removeFocus(
						tbgClaimStatus.keys._nCurrentFocus, true);
				tbgClaimStatus.keys.releaseKeys();	
				setClaimStatusDtls(null);
				setBtnAndFields(null);
				setObjClaimStatus(null);
				fieldFocus(null);
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
			id : "clmStatCd",
			title : "Code",
			width : '230px',
			align : "left",
			titleAlign : "left",
			filterOption : true,
			renderer: function(value){
				return unescapeHTML2(value);	
			}			
		},{
			id : "clmStatDesc",
			title : "Status Description",
			width : '448px',
			align : "left",
			titleAlign : "left",
			filterOption : true,
			renderer: function(value){
				return unescapeHTML2(value);	
			}
		}],
		rows : jsonClaimStatus.rows
	};

	tbgClaimStatus = new MyTableGrid(claimStatusTableModel);
	tbgClaimStatus.pager = jsonClaimStatus;
	tbgClaimStatus.render('claimStatusTableGrid');
	tbgClaimStatus.afterRender = function(){
		objClaimStatusMain = tbgClaimStatus.geniisysRows;
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
	
	function setClaimStatusDtls(obj) {		
		try {
			$("txtCode").value = obj == null ? "" : unescapeHTML2(obj.clmStatCd);
			$("txtStatusDesc").value = obj == null ? "" : unescapeHTML2(obj.clmStatDesc);			
			$("txtRemarks").value = obj == null ? "" : unescapeHTML2(obj.remarks);	
			$("txtUserId").value = obj == null ? "" : obj.userId;
			$("txtLastUpdate").value = obj == null ? "" : obj.lastUpdate;			
		} catch (e) {
			showErrorMessage("setClaimStatusDtls", e);
		}
	}	
	
	function setBtnAndFields(obj) {
		if (obj != null) {				
			enableButton("btnDelete");	
			$("btnAddUpdate").value = "Update";
			$("txtCode").readOnly = "readonly"; 				
		}else{
			$("btnAddUpdate").value = "Add";
			$("txtCode").readOnly = false; 				
			enableButton("btnAddUpdate");
			enableButton("btnCancel");
			enableButton("btnSave");
			disableButton("btnDelete");
		}
	}	
	
	function setObjClaimStatus(obj) {
		try {		
			objClaimStatus.clmStatCd = obj == null ? "" : (obj.clmStatCd==null?"":obj.clmStatCd);
			objClaimStatus.clmStatDesc = obj == null ? "" : (obj.clmStatDesc==null?"":obj.clmStatDesc);
			objClaimStatus.clmStatType = obj == null ? "" : (obj.clmStatType==null?"":obj.clmStatType);
			objClaimStatus.remarks = obj == null ? "" : (obj.remarks==null?"":obj.remarks);
			objClaimStatus.userId = obj == null ? "" : (obj.userId==null?"":obj.userId);
			objClaimStatus.lastUpdate = obj == null ? "" : (obj.lastUpdate==null?"":obj.lastUpdate);	
		} catch (e) {
			showErrorMessage("setObjClaimStatus", e);
		}
	}
	
	function setRowObjClaimStatus(func){
		try {					
			var rowObjClaimStatus = new Object();
			rowObjClaimStatus.clmStatCd = $("txtCode").value;	
			rowObjClaimStatus.clmStatDesc = $("txtStatusDesc").value;	
			rowObjClaimStatus.clmStatType = objClaimStatus.clmStatType;
			rowObjClaimStatus.remarks = $("txtRemarks").value;
			rowObjClaimStatus.userId = $("txtUserId").value;
			rowObjClaimStatus.lastUpdate = $("txtLastUpdate").value;	
			rowObjClaimStatus.recordStatus 	= func == "Delete" ? -1 : func == "Add" ? 0 : 1;
			return rowObjClaimStatus;
		} catch (e) {
			showErrorMessage("setRowObjClaimStatus", e);
		}
	}	
	
	function chkRequiredFields(){	
		if($("txtCode").value == ""){
			showMessageBox("Required fields must be entered.", imgMessage.ERROR);
			objClaimStatus.saveResult = false;			
			return false;
		}else if($("txtStatusDesc").value == ""){
			showMessageBox("Required fields must be entered.", imgMessage.ERROR);
			objClaimStatus.saveResult = false;		
			return false;
		}else{
			return true;
		}
	}
	
	function addUpdateClaimStatus(){
		rowObj  = setRowObjClaimStatus($("btnAddUpdate").value);
		if(chkRequiredFields()){
			if($("btnAddUpdate").value=="Update"){
				objClaimStatusMain.splice(row, 1, rowObj);
				tbgClaimStatus.updateVisibleRowOnly(rowObj, row);
				tbgClaimStatus.onRemoveRowFocus();
				changeTag=1;
			}else if ($("btnAddUpdate").value=="Add"){
				objClaimStatusMain.push(rowObj);
				tbgClaimStatus.addBottomRow(rowObj);
				tbgClaimStatus.onRemoveRowFocus();
				changeTag = 1;		
			}
		}
	}
	
	function deleteInClaimStatus(){ 
		delObj = setRowObjClaimStatus($("btnDelete").value);
		objClaimStatusMain.splice(row, 1, delObj);
		tbgClaimStatus.deleteVisibleRowOnly(row);
		changeTag = 1;
		setClaimStatusDtls(null);				
	}
	
	function saveClaimStatusMaintenance(){
		try{	
			var objParams = new Object(); 
			objParams.setRows = getAddedAndModifiedJSONObjects(objClaimStatusMain);
			objParams.delRows = getDeletedJSONObjects(objClaimStatusMain);
			new Ajax.Request(contextPath + "/GIISClmStatController", {
				method : "POST",
				parameters : {
					action : "saveClaimStatusMaintenance",
					parameters : JSON.stringify(objParams)				
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : function(){
					showNotice("Saving Claim Status Maintenance, please wait ...");
				},
				onComplete : function(response) {
					hideNotice();
					var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
					if (checkErrorOnResponse(response)){
						if (res.message != "SUCCESS"){
							showMessageBox(res.message, imgMessage.ERROR);	
							objClaimStatus.saveResult = false;
						}else{
							showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);		
							objClaimStatus.saveResult = true;							
						}
					}
				}
			});				
		}catch(e){
			showErrorMessage("saveClaimStatusMaintenance", e);
		}
	}
	
	function chkChangesBfrExit(func){	
		if(changeTag==0){
			func();
		}else{
			 showConfirmBox4("Confirmation",objCommonMessage.WITH_CHANGES ,"Yes","No","Cancel",
				function(){
				 saveClaimStatusMaintenance();
					 if(objClaimStatus.saveResult){
						 func(); 
						 changeTag = 0;
					 }					 	
				 },function(){
					 func();
					 changeTag = 0;
					 },"",1);
				 
		}
	}
	
	function actionOnCancel(){	
		if(changeTag==0){
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");	
		}else{
			tbgClaimStatus._refreshList();		
			tbgClaimStatus.keys.removeFocus(
					tbgClaimStatus.keys._nCurrentFocus, true);
			tbgClaimStatus.keys.releaseKeys();
		}	
	}
	
	function initializeGICLS160(){
		setBtnAndFields(null);		
		objClaimStatus = new Object();
		changeTag = 0;
		fieldFocus(null);
	}
	
	function chkIfValidInput(txtField, searchString){
		try{	
		 	new Ajax.Request(contextPath + "/GIISClmStatController", {
				method : "POST",
				parameters : {
					action : "chkIfValidInput",
					txtField : txtField,
					searchString : searchString				
				},
				asynchronous : false,
				evalScripts : true,				
				onComplete : function(response) {
					hideNotice();
					var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
					if (res.txtField == "Code"){					
						if (res.result != "TRUE"){								
							showMessageBox(res.result, imgMessage.INFO);
							$("txtCode").value = "";								
						}				
					}else if(res.txtField == "Status Description"){
						if (res.result != "TRUE"){								
							showMessageBox(res.result, imgMessage.INFO);	
							$("txtStatusDesc").value = "";
						}					
					}
				}
			}); 
		}catch(e){
			showErrorMessage("chkIfValidInput", e);
		}
	}
	
	function fieldFocus(obj){
		if(obj==null){
			$("txtCode").focus();			
		}else{
			$("txtStatusDesc").focus();
		}
	}
	
	$("txtCode").observe("blur", function() {
		if($("txtCode").value!=""&&$("txtCode").value!=objClaimStatus.clmStatCd){
			chkIfValidInput("Code",$("txtCode").value);
		}
	});
	
	$("txtStatusDesc").observe("blur", function() {
		if($("txtStatusDesc").value!=""&&$("txtStatusDesc").value!=objClaimStatus.clmStatDesc){
			chkIfValidInput("Status Description",$("txtStatusDesc").value);
		}
	});
	
	$("btnSave").observe("click", function() {
		if(changeTag==1){			
			saveClaimStatusMaintenance();
			if(objClaimStatus.saveResult){	
				tbgClaimStatus._refreshList();	
				changeTag=0;
			}			
		}else{
			showMessageBox(objCommonMessage.NO_CHANGES, imgMessage.INFO);
		}		
	});
	
	$("btnCancel").observe("click", function() {
		chkChangesBfrExit(function(){
			actionOnCancel();
			});	
	});
	
	$("btnAddUpdate").observe("click", function() {
		addUpdateClaimStatus();
	});
	
	$("btnDelete").observe("click", function() {
		deleteInClaimStatus();
	});
	
	$("txtCode").observe("keyup", function(){
		$("txtCode").value = $F("txtCode").toUpperCase();
	});
	
	$("txtStatusDesc").observe("keyup", function(){
		$("txtStatusDesc").value = $F("txtStatusDesc").toUpperCase();
	});
	
	$("imgEditRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 500);
	});	
	
	observeReloadForm("reloadForm", function(){
		showClaimStatusMaintenance();
		});
			
	$("showHideClaimStatus").observe("click", function() {
		showHideDiv("showBody","showHideClaimStatus");
	});
	
	$("claimsExit").observe("click", function() {
		chkChangesBfrExit(function(){
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");	
		});
	});
	
	initializeGICLS160();	
} catch (e) {
	showErrorMessage("Error : ", e.message);
}
	
</script>