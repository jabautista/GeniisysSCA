<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="clmStatReasonsMaintenance" name="clmStatReasonsMaintenance" style="float: left; width: 100%;">
	<div id="clmStatReasonsMaintenanceExitDiv">
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
			<label>Claim Status Reasons Maintenance</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="showHideClmStatReasons" name="gro" style="margin-left: 5px;">Hide</label> 
			 	<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>
	<div id="showBody">	
		<div class="sectionDiv">
			<div style="padding:10px;">
				<div id="clmStatReasonsTableGrid" style="height: 331px;width:700px;margin-left: 100px"></div>
			</div>	
			<div>	
				<div align="center">
					<table>					
						<tr>
							<td align="right">Code</td>
							<td><input class="required" id="txtCode" maxlength="5" type="text" style="width:150px;"></td>
							<td align="right" style="width: 120px;">Description</td>
							<td><input class="required" id="txtDescription" maxlength="500" type="text" style="width:280px;"></td>
						</tr>
						<tr>
							<td align="right">Claim Status</td>
							<td><span class="lovSpan" style="width: 156px; margin-top:2px;height:19px;">
									<input id="txtClmStatCd" type="text" maxlength="2" style="width:130px;margin: 0;height:13px;border: 0"><img
									src="${pageContext.request.contextPath}/images/misc/searchIcon.png"
									id="imgSearchClaimStatus" alt="Go" style="float: right; margin-top: 2px;" />
								</span>							
							<td colspan="2"><input id="txtClmStatDesc" readonly="readonly" type="text" style="width:404px;"></td>
						</tr>
						<tr>
							<td align="right">Remarks</td>
							<td colspan="3">
								<span class="lovSpan" style="width: 572px; margin: 0">
										<input maxlength="1000"
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
<script type="text/javascript">
try {
	setModuleId("GICLS170");
	setDocumentTitle("Claim Status Reasons Maintenance");
	var row;
	var objClmStatReasonsMain = [];
	var jsonClmStatReasons = JSON.parse('${jsonClmStatReasons}');
	clmStatReasonsTableModel = {
		url : contextPath
				+ "/GICLReasonsController?action=showClmStatReasonsMaintenance&refresh=1",
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
					tbgClmStatReasons.keys.removeFocus(
							tbgClmStatReasons.keys._nCurrentFocus, true);
					tbgClmStatReasons.keys.releaseKeys();	
					setClmStatReasonsDtls(null);
					setBtnAndFields(null);
					setobjClmStatReasons(null);
					fieldFocus(null);
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}								
			},
			onCellFocus : function(element, value, x, y, id) {						
				tbgClmStatReasons.keys.removeFocus(
						tbgClmStatReasons.keys._nCurrentFocus, true);
				tbgClmStatReasons.keys.releaseKeys();		
				setClmStatReasonsDtls(tbgClmStatReasons.geniisysRows[y]);
				setBtnAndFields(tbgClmStatReasons.geniisysRows[y]);
				setobjClmStatReasons(tbgClmStatReasons.geniisysRows[y]);
				fieldFocus(tbgClmStatReasons.geniisysRows[y]);
				row = y;
			},
			onRemoveRowFocus : function(element, value, x, y, id) {	
				tbgClmStatReasons.keys.removeFocus(
						tbgClmStatReasons.keys._nCurrentFocus, true);
				tbgClmStatReasons.keys.releaseKeys();	
				setClmStatReasonsDtls(null);
				setBtnAndFields(null);
				setobjClmStatReasons(null);
				fieldFocus(null);
			},
			beforeSort : function() {			
				if(changeTag==0){
					tbgClmStatReasons.keys.removeFocus(
							tbgClmStatReasons.keys._nCurrentFocus, true);
					tbgClmStatReasons.keys.releaseKeys();		
					setClmStatReasonsDtls(null);
					setBtnAndFields(null);
					setobjClmStatReasons(null);
					fieldFocus(null);
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}					
			},
			onSort : function() {				
				tbgClmStatReasons.keys.removeFocus(
						tbgClmStatReasons.keys._nCurrentFocus, true);
				tbgClmStatReasons.keys.releaseKeys();		
				setClmStatReasonsDtls(null);
				setBtnAndFields(null);
				setobjClmStatReasons(null);
				fieldFocus(null);
			},
			onRefresh : function() {				
				tbgClmStatReasons.keys.removeFocus(
						tbgClmStatReasons.keys._nCurrentFocus, true);
				tbgClmStatReasons.keys.releaseKeys();	
				setClmStatReasonsDtls(null);
				setBtnAndFields(null);
				setobjClmStatReasons(null);
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
			id : "reasonCd",
			title : "Code",
			width : '120px',
			align : "left",
			titleAlign : "left",
			filterOption : true,
			renderer: function(value){
				return unescapeHTML2(value);	
			}			
		},{
			id : "reasonDesc",
			title : "Description",
			
			width : '392px',
			align : "left",
			titleAlign : "left",
			filterOption : true,
			renderer: function(value){
				return unescapeHTML2(value);	
			}
		},{
			id : "clmStatDesc",
			title : "Claim Status",
			width : '180px',
			align : "left",
			titleAlign : "left",
			filterOption : true,
			renderer: function(value){
				return unescapeHTML2(value);	
			}
		}],
		rows : jsonClmStatReasons.rows
	};

	tbgClmStatReasons = new MyTableGrid(clmStatReasonsTableModel);
	tbgClmStatReasons.pager = jsonClmStatReasons;
	tbgClmStatReasons.render('clmStatReasonsTableGrid');
	tbgClmStatReasons.afterRender = function(){
		objClmStatReasonsMain = tbgClmStatReasons.geniisysRows;
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
	
	function setClmStatReasonsDtls(obj) {		
		try {
			$("txtCode").value = obj == null ? "" : unescapeHTML2(obj.reasonCd);
			$("txtDescription").value = obj == null ? "" : unescapeHTML2(obj.reasonDesc);
			$("txtClmStatCd").value = obj == null ? "" : unescapeHTML2(obj.clmStatCd);
			$("txtClmStatDesc").value = obj == null ? "" : unescapeHTML2(obj.clmStatDesc);
			$("txtRemarks").value = obj == null ? "" : unescapeHTML2(obj.remarks);	
			$("txtUserId").value = obj == null ? "" : obj.userId;
			$("txtLastUpdate").value = obj == null ? "" : obj.lastUpdate;	
			$("txtClmStatCd").setAttribute("lastValidValue", obj == null ? "": obj.clmStatCd);
			$("txtClmStatDesc").setAttribute("lastValidValue", obj == null ? "": obj.clmStatDesc);
		} catch (e) {
			showErrorMessage("setClmStatReasonsDtls", e);
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
	
	function setobjClmStatReasons(obj) {
		try {		
			objClmStatReasons.reasonCd = obj == null ? "" : (obj.reasonCd==null?"":obj.reasonCd);
			objClmStatReasons.reasonDesc = obj == null ? "" : (obj.reasonDesc==null?"":obj.reasonDesc);
			objClmStatReasons.clmStatCd = obj == null ? "" : (obj.clmStatCd==null?"":obj.clmStatCd);
			objClmStatReasons.clmStatDesc = obj == null ? "" : (obj.clmStatDesc==null?"":obj.clmStatDesc);
			objClmStatReasons.remarks = obj == null ? "" : (obj.remarks==null?"":obj.remarks);
			objClmStatReasons.userId = obj == null ? "" : (obj.userId==null?"":obj.userId);
			objClmStatReasons.lastUpdate = obj == null ? "" : (obj.lastUpdate==null?"":obj.lastUpdate);	
		} catch (e) {
			showErrorMessage("setobjClmStatReasons", e);
		}
	}
	
	function setRowobjClmStatReasons(func){
		try {					
			var rowobjClmStatReasons = new Object();
			rowobjClmStatReasons.reasonCd = $("txtCode").value;	
			rowobjClmStatReasons.reasonDesc = $("txtDescription").value;
			rowobjClmStatReasons.clmStatCd = $("txtClmStatCd").value;	
			rowobjClmStatReasons.clmStatDesc = $("txtClmStatDesc").value;
			rowobjClmStatReasons.remarks = $("txtRemarks").value;
			rowobjClmStatReasons.userId = $("txtUserId").value;
			rowobjClmStatReasons.lastUpdate = $("txtLastUpdate").value;
			rowobjClmStatReasons.recordStatus 	= func == "Delete" ? -1 : func == "Add" ? 0 : 1;
			return rowobjClmStatReasons;
		} catch (e) {
			showErrorMessage("setRowobjClmStatReasons", e);
		}
	}	
	
	function chkRequiredFields(){	
		if($("txtCode").value == ""){
			customShowMessageBox("Required fields must be entered.", imgMessage.ERROR,"txtCode");
			objClmStatReasons.saveResult = false;			
			return false;
		}else if($("txtDescription").value == ""){
			customShowMessageBox("Required fields must be entered.", imgMessage.ERROR,"txtDescription");
			objClmStatReasons.saveResult = false;		
			return false;
		}else{
			return true;
		}
	}
	
	function addUpdateClmStatReasons(){
		rowObj  = setRowobjClmStatReasons($("btnAddUpdate").value);
		if(chkRequiredFields()){
			if($("btnAddUpdate").value=="Update"){
				objClmStatReasonsMain.splice(row, 1, rowObj);
				tbgClmStatReasons.updateVisibleRowOnly(rowObj, row);
				tbgClmStatReasons.onRemoveRowFocus();
				changeTag=1;
			}else if ($("btnAddUpdate").value=="Add"){
				objClmStatReasonsMain.push(rowObj);
				tbgClmStatReasons.addBottomRow(rowObj);
				tbgClmStatReasons.onRemoveRowFocus();
				changeTag = 1;		
			}
		}
	}
	
	function deleteInClmStatReasons(){ 
		delObj = setRowobjClmStatReasons($("btnDelete").value);
		objClmStatReasonsMain.splice(row, 1, delObj);
		tbgClmStatReasons.deleteVisibleRowOnly(row);
		changeTag = 1;
		setClmStatReasonsDtls(null);				
	}
	
	function showClaimStatusLOV() {
		LOV.show({
			controller : "ClaimsLOVController",
			urlParameters : {
				action : "getClmStatReasonsLOV",
				searchString : ($("txtClmStatCd").readAttribute("lastValidValue") != $F("txtClmStatCd") ? nvl($F("txtClmStatCd"),"%") : "%"),
				page : 1,				
			},
			title : "Claim Status",
			width : 610,
			height : 386,
			columnModel : [ {
				id : "clmStatCd",
				title : "Claim Status Code",
				width : '130px',
			},{
				id : "clmStatDesc",
				title : "Claim Status Description",
				width : '350px',
			},{
				id : "clmStatType",
				title : "Claim Status Type",
				width : '110px',
			}  ],
			draggable : true,
			autoSelectOneRecord : true,
			filterText :$("txtClmStatCd").value,
			onSelect : function(row) {
				$("txtClmStatCd").value = unescapeHTML2(row.clmStatCd);	
				$("txtClmStatDesc").value = unescapeHTML2(row.clmStatDesc);				
				$("txtClmStatCd").setAttribute("lastValidValue", row.clmStatCd);
				$("txtClmStatDesc").setAttribute("lastValidValue", row.clmStatDesc);
			},
			onCancel : function() {
				$("txtClmStatCd").value = $("txtClmStatCd").readAttribute("lastValidValue");
				$("txtClmStatDesc").value=$("txtClmStatDesc").readAttribute("lastValidValue");
			},
			onUndefinedRow : function() {
				customShowMessageBox("No record selected.", imgMessage.INFO,
						"txtClmStatCd");	
				$("txtClmStatCd").value = "";
				$("txtClmStatDesc").value= "";
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();
			}
		});
	}	
	
	function saveClmStatReasonsMaintenance(){
		try{	
			var objParams = new Object(); 
			objParams.setRows = getAddedAndModifiedJSONObjects(objClmStatReasonsMain);
			objParams.delRows = getDeletedJSONObjects(objClmStatReasonsMain);
			new Ajax.Request(contextPath + "/GICLReasonsController", {
				method : "POST",
				parameters : {
					action : "saveClmStatReasonsMaintenance",
					parameters : JSON.stringify(objParams)				
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : function(){
					showNotice("Saving Claim Status Reasons Maintenance, please wait ...");
				},
				onComplete : function(response) {
					hideNotice();
					var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
					if (checkErrorOnResponse(response)){
						if (res.message != "SUCCESS"){
							showMessageBox(res.message, imgMessage.ERROR);
							objClmStatReasons.saveResult = false;											
						}else{
							showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);		
							objClmStatReasons.saveResult = true;
							changeTag = 0;
							changeTagFunc = "";	
						}
					}
				}
			});				
		}catch(e){
			showErrorMessage("saveClmStatReasonsMaintenance", e);
		}
	}
	
	function validateReasonsInput(txtField, inputString){
		try{	
			var ret = true;
		 	new Ajax.Request(contextPath + "/GICLReasonsController", {
				method : "POST",
				parameters : {
					action : "validateReasonsInput",
					txtField : txtField,
					inputString : inputString,
					reasonCd : objClmStatReasons.reasonCd,
					clmStatCd : objClmStatReasons.clmStatCd					
				},	
				asynchronous : false,
				evalScripts : true,				
				onComplete : function(response) {
					hideNotice();
					var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
					if (res.txtField == "Code"){					
						if (res.result != "TRUE"){	
							if(objClmStatReasons.reasonCd != $("txtCode").value){
								showMessageBox(res.result, imgMessage.INFO);
								$("txtCode").value = objClmStatReasons.reasonCd == null ? "":objClmStatReasons.reasonCd;								
								ret = false;
							}	
						}							
					}else if(res.txtField == "Description"){
						if (res.result != "TRUE"){	
							if(objClmStatReasons.reasonDesc != $("txtDescription").value){
								showMessageBox(res.result, imgMessage.INFO);
								$("txtDescription").value = objClmStatReasons.reasonDesc == null ? "":objClmStatReasons.reasonDesc;								
								ret = false;
							}							
						}				
					}else if(res.txtField == "Claim Status"){
						if (res.result != "TRUE"){	
							if(objClmStatReasons.clmStatCd != $("txtClmStatCd").value){
								showMessageBox(res.result, imgMessage.INFO);
								$("txtClmStatCd").value = objClmStatReasons.clmStatCd == null ? "":objClmStatReasons.clmStatCd;								
								$("txtClmStatDesc").value = objClmStatReasons.clmStatDesc == null ? "":objClmStatReasons.clmStatDesc;								
								ret = false;
							}							
						}				
					}else if(res.txtField == "Remarks"){
						if (res.result != "TRUE"){	
							if(objClmStatReasons.remarks != $("txtRemarks").value){
								showMessageBox(res.result, imgMessage.INFO);
								$("txtRemarks").value = objClmStatReasons.remarks == null ? "":objClmStatReasons.remarks;								
								ret = false;
							}							
						}				
					}else if(res.txtField == "Update"){
						if (res.result != "TRUE"){								
							showMessageBox(res.result, imgMessage.INFO);						
							ret = false;													
						}				
					}else if(res.txtField == "Delete"){
						if (res.result != "TRUE"){								
							showMessageBox(res.result, imgMessage.INFO);						
							ret = false;													
						}				
					}						
				}
			}); 
		 	return ret;
		}catch(e){
			showErrorMessage("chkIfValidInput", e);
		}
	}
	
	function chkChangesBfrExit(func){	
		if(changeTag==0){
			func();
		}else{
			 showConfirmBox4("Confirmation",objCommonMessage.WITH_CHANGES ,"Yes","No","Cancel",
				function(){
				 saveClmStatReasonsMaintenance();
					 if(objClmStatReasons.saveResult){
						 func(); 
						 changeTag = 0;
						 changeTagFunc = "";
					 }					 	
				 },function(){
					 func();
					 changeTag = 0;
					 changeTagFunc = "";
					 },"",1);
				 
		}
	}
	
	function actionOnCancel(){	
		if(changeTag==0){
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");	
		}else{
			tbgClmStatReasons._refreshList();		
			tbgClmStatReasons.keys.removeFocus(
					tbgClmStatReasons.keys._nCurrentFocus, true);
			tbgClmStatReasons.keys.releaseKeys();
		}	
	}
	
	function initializeGICLS170(){
		setBtnAndFields(null);		
		objClmStatReasons = new Object();
		changeTag = 0;
		fieldFocus(null);
	}	
	
	function fieldFocus(obj){	
		$("txtCode").focus();		
	}
	
	$("imgSearchClaimStatus").observe("click", function() {
		showClaimStatusLOV();
	});
		
	$("btnSave").observe("click", function() {
		if(changeTag==1){			
			saveClmStatReasonsMaintenance();
			if(objClmStatReasons.saveResult){	
				tbgClmStatReasons._refreshList();	
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
		if(validateReasonsInput("Update")){
			addUpdateClmStatReasons();	
			changeTagFunc = saveClmStatReasonsMaintenance; // for logout confirmation	
		}
	});
	
	$("btnDelete").observe("click", function() {
		if(validateReasonsInput("Delete")){
			deleteInClmStatReasons();
			changeTagFunc = saveClmStatReasonsMaintenance; // for logout confirmation	
		}
	});	
			
	$("txtCode").observe("blur", function(){
		validateReasonsInput("Code",$("txtCode").value);
	});
	
	$("txtDescription").observe("blur", function(){
		validateReasonsInput("Description",$("txtDescription").value);
	});
	
	$("txtClmStatCd").observe("blur", function() {
		if(validateReasonsInput("Claim Status",$("txtClmStatCd").value)){
			if($("txtClmStatCd").value!=""&& $("txtClmStatCd").value != $("txtClmStatCd").readAttribute("lastValidValue")){
				showClaimStatusLOV();
			}else if($("txtClmStatCd").value==""){
				$("txtClmStatDesc").value="";
				$("txtClmStatCd").setAttribute("lastValidValue", "");
				$("txtClmStatDesc").setAttribute("lastValidValue", "");		
			}
		}			
	});	
	
	$("txtRemarks").observe("blur", function(){
		validateReasonsInput("Remarks",$("txtRemarks").value);
	});
	
	$("txtCode").observe("keyup", function(){
		$("txtCode").value = $F("txtCode").toUpperCase();
	});
	
	$("txtDescription").observe("keyup", function(){
		$("txtDescription").value = $F("txtDescription").toUpperCase();
	});
	
	$("txtClmStatCd").observe("keyup", function(){
		$("txtClmStatCd").value = $F("txtClmStatCd").toUpperCase();
	});	
	
	$("txtRemarks").observe("keyup", function(){
		$("txtRemarks").value = $F("txtRemarks").toUpperCase();
	});
	
	$("imgEditRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 1000);
	});	
	
	observeReloadForm("reloadForm", function(){
		showClmStatReasonsMaintenance();
		});
			
	$("showHideClmStatReasons").observe("click", function() {
		showHideDiv("showBody","showHideClmStatReasons");
	});
	
	$("claimsExit").observe("click", function() {
		chkChangesBfrExit(function(){
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");	
		});
	});	
		
	initializeGICLS170();	
} catch (e) {
	showErrorMessage("Error : ", e.message);
}
	
</script>