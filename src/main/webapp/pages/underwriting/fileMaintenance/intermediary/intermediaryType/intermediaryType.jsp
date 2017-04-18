<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="intmTypeMaintenance" name="intmTypeMaintenance" style="float: left; width: 100%;">
	<div id="intmTypeMaintenanceExitDiv">
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
			<label>Intermediary Type Maintenance</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>
	<div id="showBody">	
		<div class="sectionDiv">
			<div style="padding:10px;">
				<div id="intmTypeTableGrid" style="height: 340px;width:700px;margin-left: 100px"></div>
			</div>	
			<div>	
				<div style="margin-left: 145px" id="intmTypeFormDiv">
					<table>					
						<tr>
							<td align="right">Type</td>
							<td><input class="required" id="txtType" maxlength="2" type="text" style="width:150px;"></td>
							<td align="right" style="width: 186px;">Acct. Intm.</td>
							<td><input class="required rightAligned integerNoNegativeUnformattedNoComma" id="txtAcctIntm" maxlength="2" type="text" style="width:200px;"></td>
						</tr>	
						<tr>
							<td align="right">Description</td>
							<td colspan="4">								
								<input class="required" maxlength="20" style="width: 552px;" type="text" id="txtDescription" /> 
							</td>
						</tr>										
						<tr>
							<td align="right">Remarks</td>
							<td colspan="4">
								<div style="border: 1px solid gray; height: 21px; width: 558px">
									<textarea id="txtRemarks" name="txtRemarks" style="border: none; height: 13px; resize: none; width: 532px" maxlength="4000"  onkeyup="limitText(this,4000);"></textarea>
									<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; padding: 3px; float: right;" alt="EditRemark" id="imgEditRemarks"/>
								</div>
							</td>
						</tr>
						<tr>
							<td align="right">User ID</td>
							<td><input id="txtUserId" type="text" style="width:150px" readonly="readonly"></td>
							<td align="right" style="width: 186px;">Last Update</td>
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
	setModuleId("GIISS083");
	setDocumentTitle("Intermediary Type Maintenance");
	initializeAll();
	initializeAccordion();
	var row;
	var objIntmTypeMain = [];
	var jsonIntmType = JSON.parse('${jsonIntmType}');
	intmTypeTableModel = {
		url : contextPath
				+ "/GIISIntmTypeController?action=showIntmType&refresh=1",
		options : {
			width : '700px',
			pager : {},
			toolbar : {
				elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
				onFilter: function(){						
					if(changeTag==0){
						tbgIntmType.keys.removeFocus(
								tbgIntmType.keys._nCurrentFocus, true);
						tbgIntmType.keys.releaseKeys();	
						setIntmTypeDtls(null);
						setBtnAndFields(null);
						setObjIntmType(null);
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
					tbgIntmType.keys.removeFocus(
							tbgIntmType.keys._nCurrentFocus, true);
					tbgIntmType.keys.releaseKeys();	
					setIntmTypeDtls(null);
					setBtnAndFields(null);
					setObjIntmType(null);
					fieldFocus(null);
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}								
			},
			onCellFocus : function(element, value, x, y, id) {						
				tbgIntmType.keys.removeFocus(
						tbgIntmType.keys._nCurrentFocus, true);
				tbgIntmType.keys.releaseKeys();		
				setIntmTypeDtls(tbgIntmType.geniisysRows[y]);
				setBtnAndFields(tbgIntmType.geniisysRows[y]);
				setObjIntmType(tbgIntmType.geniisysRows[y]);
				fieldFocus(tbgIntmType.geniisysRows[y]);
				row = y;
			},
			onRemoveRowFocus : function(element, value, x, y, id) {	
				tbgIntmType.keys.removeFocus(
						tbgIntmType.keys._nCurrentFocus, true);
				tbgIntmType.keys.releaseKeys();	
				setIntmTypeDtls(null);
				setBtnAndFields(null);
				setObjIntmType(null);
				fieldFocus(null);
			},	
			beforeSort : function(element, value, x, y, id) {
				if(changeTag==0){
					tbgIntmType.keys.removeFocus(
							tbgIntmType.keys._nCurrentFocus, true);
					tbgIntmType.keys.releaseKeys();	
					setIntmTypeDtls(null);
					setBtnAndFields(null);
					setObjIntmType(null);
					fieldFocus(null);
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}							
			},
			onSort : function() {	
				if(changeTag==0){
					tbgIntmType.keys.removeFocus(
							tbgIntmType.keys._nCurrentFocus, true);
					tbgIntmType.keys.releaseKeys();		
					setIntmTypeDtls(null);
					setBtnAndFields(null);
					setObjIntmType(null);
					fieldFocus(null);
				}
			},	
			onRefresh : function() {				
				if(changeTag==0){
					tbgIntmType.keys.removeFocus(
							tbgIntmType.keys._nCurrentFocus, true);
					tbgIntmType.keys.releaseKeys();		
					setIntmTypeDtls(null);
					setBtnAndFields(null);
					setObjIntmType(null);
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
			id : "intmType",
			title : "Type",
			width : '100px',
			align : "left",
			titleAlign : "left",
			filterOption : true						
		},{
			id : "acctIntmCd",
			title : "Acct. Intm.",			
			width : '110px',
			align : "right",
			titleAlign : "right",
			filterOption : true,
			filterOptionType : 'integerNoNegative'
		},{
			id : "intmDesc",
			title : "Description",			
			width : '455px',
			align : "left",
			titleAlign : "left",
			filterOption : true
		}],
		rows : jsonIntmType.rows
	};

	tbgIntmType = new MyTableGrid(intmTypeTableModel);
	tbgIntmType.pager = jsonIntmType;
	tbgIntmType.render('intmTypeTableGrid');
	tbgIntmType.afterRender = function(){
		objIntmTypeMain = tbgIntmType.geniisysRows;
		changeTag = 0;
	};
	
	function setIntmTypeDtls(obj) {		
		try {
			$("txtType").value = obj == null ? "" : unescapeHTML2(obj.intmType);
			$("txtAcctIntm").value = obj == null ? "" : unescapeHTML2(obj.acctIntmCd);
			$("txtDescription").value = obj == null ? "" : unescapeHTML2(obj.intmDesc);			
			$("txtRemarks").value = obj == null ? "" : unescapeHTML2(obj.remarks);	
			$("txtUserId").value = obj == null ? "" : obj.userId;
			$("txtLastUpdate").value = obj == null ? "" : obj.lastUpdate;
			} catch (e) {
			showErrorMessage("setIntmTypeDtls", e);
		}
	}	
	
	function setBtnAndFields(obj) {
		if (obj != null) {				
			enableButton("btnDelete");
			$("btnAddUpdate").value = "Update";	
			$("txtType").readOnly = "readonly"; 
			$("txtAcctIntm").readOnly = "readonly"; 
			//$("txtDescription").readOnly = "readonly"; 			
		}else{
			$("btnAddUpdate").value = "Add";						
			enableButton("btnAddUpdate");
			enableButton("btnCancel");
			enableButton("btnSave");
			disableButton("btnDelete");
			$("txtType").readOnly = false; 
			$("txtAcctIntm").readOnly = false; 
			$("txtDescription").readOnly = false; 
		}
	}
	
	function setObjIntmType(obj) {
		try {		
			objIntmType.intmType = obj == null ? "" : (obj.intmType==null?"":unescapeHTML2(obj.intmType));
			objIntmType.acctIntmCd = obj == null ? "" : (obj.acctIntmCd==null?"":unescapeHTML2(obj.acctIntmCd));
			objIntmType.intmDesc = obj == null ? "" : (obj.intmDesc==null?"":unescapeHTML2(obj.intmDesc));			
			objIntmType.remarks = obj == null ? "" : (obj.remarks==null?"":unescapeHTML2(obj.remarks));
			objIntmType.userId = obj == null ? "" : (obj.userId==null?"":obj.userId);
			objIntmType.lastUpdate = obj == null ? "" : (obj.lastUpdate==null?"":obj.lastUpdate);			
		} catch (e) {
			showErrorMessage("setObjIntmType", e);
		}
	}
	
	function setRowObjIntmType(func){
		try {					
			var rowObjIntmType = new Object();
			rowObjIntmType.intmType = escapeHTML2($("txtType").value);	
			rowObjIntmType.acctIntmCd = escapeHTML2($("txtAcctIntm").value);	
			rowObjIntmType.intmDesc = escapeHTML2($("txtDescription").value);				
			rowObjIntmType.remarks = escapeHTML2($("txtRemarks").value);
			rowObjIntmType.userId = escapeHTML2(userId);
			var lastUpdate = new Date();
			rowObjIntmType.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			rowObjIntmType.recordStatus 	= func == "Delete" ? -1 : func == "Add" ? 0 : 1;
			return rowObjIntmType;
		} catch (e) {
			showErrorMessage("setRowObjIntmType", e);
		}
	}	
	
	function fieldFocus(obj){
		if(obj!=null){
			$("txtRemarks").focus();	
		}else{
			$("txtType").focus();			
		}
	}
	
	function chkChangesBfrAction(func){	
		if(changeTag==0){
			func();
		}else{
			 showConfirmBox4("Confirmation",objCommonMessage.WITH_CHANGES ,"Yes","No","Cancel",
				function(){
				 saveIntmType(func);					
				 },function(){
					 func();					
					 },"",1);
				 
		}
	}
	
	function addRec(){
		rowObj  = setRowObjIntmType($("btnAddUpdate").value);
		if($("btnAddUpdate").value=="Update"){
			changeTag=1;	
			objIntmTypeMain.splice(row, 1, rowObj);
			tbgIntmType.updateVisibleRowOnly(rowObj, row);
			tbgIntmType.onRemoveRowFocus();
		}else if ($("btnAddUpdate").value=="Add"){				
			objIntmTypeMain.push(rowObj);
			tbgIntmType.addBottomRow(rowObj);
			tbgIntmType.onRemoveRowFocus();
			changeTag = 1;		
		}
		changeTagFunc = saveIntmType; // for logout confirmation		
	}
	
	function deleteRec(){ 
		delObj = setRowObjIntmType($("btnDelete").value);
		objIntmTypeMain.splice(row, 1, delObj);			
		changeTag=1;
		tbgIntmType.deleteVisibleRowOnly(row);
		setIntmTypeDtls(null);	
		setBtnAndFields(null);	
		changeTagFunc = saveIntmType; // for logout confirmation
	}
	
	function saveIntmType(func){
		try{	
			var objParams = new Object(); 
			objParams.setRows = getAddedAndModifiedJSONObjects(objIntmTypeMain);
			objParams.delRows = getDeletedJSONObjects(objIntmTypeMain);
			new Ajax.Request(contextPath + "/GIISIntmTypeController", {
				method : "POST",
				parameters : {
					action : "saveIntmType",
					parameters : JSON.stringify(objParams)				
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : function(){
					showNotice("Saving Intermediary Type Maintenance, please wait ...");
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
					    		tbgIntmType._refreshList();		
					    		tbgIntmType.keys.removeFocus(
					    				tbgIntmType.keys._nCurrentFocus, true);
					    		tbgIntmType.keys.releaseKeys();
								changeTag = 0;
								changeTagFunc = "";
							});							
						}
					}
				}
			});				
		}catch(e){
			showErrorMessage("saveIntmType", e);
		}
	}
	
	function valDelGIISS083IntmType(){
		try{
			var canDelete = true;	
		 	new Ajax.Request(contextPath + "/GIISIntmTypeController", {
				method : "POST",
				parameters : {
					action : "valDelGIISS083IntmType",				
					intmType: $("txtType").value					
				},	
				asynchronous : false,
				evalScripts : true,				
				onComplete : function(response) {
					hideNotice();
					var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));									
					if (res.result != "TRUE"){	
						canDelete = false;
						showMessageBox(res.result, imgMessage.INFO);
					}		
				}
			}); 
		 	return canDelete;
		}catch(e){
		}
	}
	
	function validateUpdate(){ //Added by Jerome 08.11.2016 SR 5583
	try{		
		new Ajax.Request(contextPath+"/GIISIntmTypeController",{
			method: "POST",
			parameters:{
				action: "valUpdateIntmType",
				intmType: $F("txtType")
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				showNotice("Validating Intm Type, please wait...");
			},
			onComplete: function(response){
				hideNotice("");
				if(response.responseText.substr(0,1) == 'N'){
					addRec();
				}else if (response.responseText.substr(0,1) == 'Y' || response.responseText.substr(0,1) == 'X'){
					showMessageBox("Cannot update record from GIIS_INTM_TYPE while dependent record(s) in " + response.responseText.slice(1) + " exists.", "E");
					tbgIntmType.refresh();
				}
			}
		});
		return true;
	} catch (e) {
		showErrorMessage("validateUpdate", e);
	}
 }
	
	function valAddRec() {
		try {
			if (checkAllRequiredFieldsInDiv("intmTypeFormDiv")) {
				if ($F("btnAddUpdate") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;
					for ( var i = 0; i < tbgIntmType.geniisysRows.length; i++) {
						if (tbgIntmType.geniisysRows[i].recordStatus == 0
								|| tbgIntmType.geniisysRows[i].recordStatus == 1) {
							if (tbgIntmType.geniisysRows[i].intmType == escapeHTML2($F("txtType"))) {
								addedSameExists = true;
							}
						} else if (tbgIntmType.geniisysRows[i].recordStatus == -1) {
							if (unescapeHTML2(tbgIntmType.geniisysRows[i].intmType) == $F("txtType")) {
								deletedSameExists = true;
							}
						}
					}
					if ((addedSameExists && !deletedSameExists)
							|| (deletedSameExists && addedSameExists)) {
						showMessageBox(
								"Record already exists with the same intm_type.",
								"E");
						return;
					} else if (deletedSameExists && !addedSameExists) {
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GIISIntmTypeController", {
						parameters : {
							action : "valAddRec",
							intmType : $F("txtType")
						},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response) {
							hideNotice();
							if (checkCustomErrorOnResponse(response) &&
									checkErrorOnResponse(response)) {
								addRec();
							}
						}
					});					
				} else {		
					validateUpdate();
					//addRec(); //Commented out by Jerome 08.11.2016 SR 5583
				}
			}
		} catch (e) {
			showErrorMessage("valAddRec", e);
		}
	}
	
	function valDeleteRec() {
		try {
			new Ajax.Request(contextPath + "/GIISIntmTypeController", {
				parameters : {
					action : "valDeleteRec",
					intmType : $F("txtType")
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response) {
					hideNotice();
					if (checkCustomErrorOnResponse(response)
							&& checkErrorOnResponse(response)) {
						deleteRec();
					}
				}
			});
		} catch (e) {
			showErrorMessage("valDeleteRec", e);
		}
	}
	
	function initializeGIISS083(){
		setBtnAndFields(null);		
		objIntmType = new Object();
		changeTag = 0;
		fieldFocus(null);
	}	
	
	$("txtType").observe("keyup", function() {
		$("txtType").value = $F("txtType").toUpperCase();
	});
	
	$("txtDescription").observe("keyup", function() {
		$("txtDescription").value = $F("txtDescription").toUpperCase();
	});
	
	$("txtDescription").observe("change", function() {
		$("txtDescription").value = $F("txtDescription").toUpperCase();
	});
	
	$("txtType").observe("change", function() {
		$("txtType").value = $F("txtType").toUpperCase();	
	});
		
	$("imgEditRemarks").observe("click", function() {
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
			
	$("btnAddUpdate").observe("click", function() {
		valAddRec();			
	});	
	
	$("btnDelete").observe("click", function(){	
		valDeleteRec();		
	});
	
	$("btnSave").observe("click", function() {
		if(changeTag==1){			
			saveIntmType();		
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
		showIntermediaryTypeMaintenance();
		});
		
	$("underwritingExit").observe("click", function() {
		chkChangesBfrAction(function(){
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main" , null); 
			changeTag = 0;
			changeTagFunc = "";
			});			
	});
	
	initializeGIISS083();	
} catch (e) {
	showErrorMessage("Error : ", e.message);
}
	
</script>