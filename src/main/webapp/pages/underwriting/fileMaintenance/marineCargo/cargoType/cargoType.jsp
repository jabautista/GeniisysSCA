<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="cargoTypeMaintenance" name="cargoTypeMaintenance" style="float: left; width: 100%;">
	<div id="cargoTypeMaintenanceExitDiv">
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
			<label>Cargo Type Maintenance</label>
			<span class="refreshers" style="margin-top: 0;">
			 	<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>
	<div id="showBody">	
		<div class="sectionDiv">
			<div style="padding-top:10px;padding-bottom: 15px; margin-left: 160px">
				<div id="cargoClassTableGrid" style="height: 230px;width:600px;"></div>
			</div>	
		</div>
		<div class="sectionDiv">
			<div style="padding:10px; margin-left: 100px">
				<div id="cargoTypeTableGrid" style="height: 336px;width:700px;"></div>
			</div>	
			<div id="cargoTypeDiv">	
				<div align="center">
					<table>
						<tr>
							<td align="right">Type</td>
							<td><input class="required" id="txtType" maxlength="3" type="text" style="width:150px"></td>
						</tr>
						<tr>
							<td align="right">Description</td>
							<td colspan="3"><input class="required" id="txtDescription" maxlength="300" type="text"  style="width:552px"></td>
						</tr>	
						<tr>
							<td align="right">Remarks</td>
							<td colspan="3">
								<div style="border: 1px solid gray; height: 21px; width: 558px">
									<textarea id="txtRemarks" name="txtRemarks" style="border: none; height: 13px; resize: none; width: 532px" maxlength="4000"></textarea>
									<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; padding: 3px; float: right;" alt="EditRemark" id="imgEditRemarks"/>
								</div>
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
	setModuleId("GIISS008");
	setDocumentTitle("Cargo Type Maintenance");
	var row;
	var objCargoTypeMain = [];
	var jsonCargoClass = JSON.parse('${jsonCargoClass}');
	initializeAll();
	initializeAccordion();
	cargoClassTableModel = {
		url : contextPath
				+ "/GIISCargoTypeController?action=showCargoClass&refresh=1",
		options : {
			width : '600px',
			pager : {},
			toolbar : {
				elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
				onFilter: function(){	
					if(changeTag==0){
						disableButton("btnAddUpdate");
						setTbgCargoType(null);	
						disableFields();		
						tbgCargoClass.keys.removeFocus(
								tbgCargoClass.keys._nCurrentFocus, true);
						tbgCargoClass.keys.releaseKeys();																	
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
					setTbgCargoType(null);	
					disableFields();		
					tbgCargoClass.keys.removeFocus(
							tbgCargoClass.keys._nCurrentFocus, true);
					tbgCargoClass.keys.releaseKeys();						
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
					setTbgCargoType(tbgCargoClass.geniisysRows[y]);							
					enableFields();	
					enableButton("btnAddUpdate");
					$("txtType").focus();	
					tbgCargoClass.keys.removeFocus(
							tbgCargoClass.keys._nCurrentFocus, true);
					tbgCargoClass.keys.releaseKeys();								
	
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}				
			},
			onRemoveRowFocus : function(element, value, x, y, id) {	
				if(changeTag==0){
					disableButton("btnAddUpdate");
					setTbgCargoType(null);	
					disableFields();					
					tbgCargoClass.keys.removeFocus(
							tbgCargoClass.keys._nCurrentFocus, true);
					tbgCargoClass.keys.releaseKeys();														
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}						
			},
			beforeSort : function() {			
				if(changeTag==0){
					disableButton("btnAddUpdate");
					setTbgCargoType(null);	
					disableFields();		
					tbgCargoClass.keys.removeFocus(
							tbgCargoClass.keys._nCurrentFocus, true);
					tbgCargoClass.keys.releaseKeys();													
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}							
			},
			onSort : function() {				
				if(changeTag==0){
					disableButton("btnAddUpdate");
					setTbgCargoType(null);	
					disableFields();		
					tbgCargoClass.keys.removeFocus(
							tbgCargoClass.keys._nCurrentFocus, true);
					tbgCargoClass.keys.releaseKeys();												
				}		
			},
			onRefresh : function() {				
				if(changeTag==0){
					disableButton("btnAddUpdate");
					setTbgCargoType(null);	
					disableFields();		
					tbgCargoClass.keys.removeFocus(
							tbgCargoClass.keys._nCurrentFocus, true);
					tbgCargoClass.keys.releaseKeys();									
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
			id : "cargoClassCd",
			title : "Cargo Class Code",
			width : '130px',
			align : "left",
			titleAlign : "left",
			filterOption : true,	
			filterOptionType : 'integerNoNegative'
		}, {
			id : "cargoClassDesc",
			title : "Cargo Class Description",			
			width : '440px',
			align : "left",
			titleAlign : "left",
			filterOption : true,			
		}],
		rows : jsonCargoClass.rows
	};

	tbgCargoClass = new MyTableGrid(cargoClassTableModel);
	tbgCargoClass.pager = jsonCargoClass;
	tbgCargoClass.render('cargoClassTableGrid');
	
	var jsonCargoType = JSON.parse('${jsonCargoType}');
	cargoTypeTableModel = {
		url : contextPath
				+ "/GIISCargoTypeController?action=showCargoType&refresh=1",
		options : {
			width : '700px',
			pager : {},
			toolbar : {
				elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
				onFilter: function(){	
					if(changeTag==0){
						tbgCargoType.keys.removeFocus(
								tbgCargoType.keys._nCurrentFocus, true);
							tbgCargoType.keys.releaseKeys();
							setBtnAndFields(null);	
							setCargoTypeDtls(null);	
							fieldFocus(null);	
							setObjCargoType(null);	
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
					tbgCargoType.keys.removeFocus(
							tbgCargoType.keys._nCurrentFocus, true);
					tbgCargoType.keys.releaseKeys();
					setBtnAndFields(null);	
					setCargoTypeDtls(null);	
					fieldFocus(null);	
					setObjCargoType(null);					
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}									
			},
			onCellFocus : function(element, value, x, y, id) {						
				tbgCargoType.keys.removeFocus(
						tbgCargoType.keys._nCurrentFocus, true);
				tbgCargoType.keys.releaseKeys();	
				setCargoTypeDtls(tbgCargoType.geniisysRows[y]);
				setBtnAndFields(tbgCargoType.geniisysRows[y]);				
				fieldFocus(tbgCargoType.geniisysRows[y]);		
				setObjCargoType(tbgCargoType.geniisysRows[y]);					
				row = y;
			},
			onRemoveRowFocus : function(element, value, x, y, id) {				
				tbgCargoType.keys.removeFocus(
						tbgCargoType.keys._nCurrentFocus, true);
				tbgCargoType.keys.releaseKeys();
				setBtnAndFields(null);	
				setCargoTypeDtls(null);	
				fieldFocus(null);	
				setObjCargoType(null);					
			},
			beforeSort : function() {			
				if(changeTag==0){
					tbgCargoType.keys.removeFocus(
							tbgCargoType.keys._nCurrentFocus, true);
					tbgCargoType.keys.releaseKeys();
					setBtnAndFields(null);	
					setCargoTypeDtls(null);	
					fieldFocus(null);		
					setObjCargoType(null);		
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}									
			},
			onSort : function() {				
				if(changeTag==0){
					tbgCargoType.keys.removeFocus(
							tbgCargoType.keys._nCurrentFocus, true);
					tbgCargoType.keys.releaseKeys();
					setBtnAndFields(null);	
					setCargoTypeDtls(null);	
					fieldFocus(null);		
					setObjCargoType(null);				
				}		
			},
			onRefresh : function() {				
				if(changeTag==0){
					tbgCargoType.keys.removeFocus(
							tbgCargoType.keys._nCurrentFocus, true);
					tbgCargoType.keys.releaseKeys();
					setBtnAndFields(null);	
					setCargoTypeDtls(null);	
					fieldFocus(null);	
					setObjCargoType(null);					
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
		}, {
			id : "cargoType",
			title : "Type",
			width : '180px',
			align : "left",
			titleAlign : "left",
			filterOption : true,		
		}, {
			id : "cargoTypeDesc",
			title : "Description",			
			width : '490px',
			align : "left",
			titleAlign : "left",
			filterOption : true,			
		}],
		rows : jsonCargoType.rows
	};

	tbgCargoType = new MyTableGrid(cargoTypeTableModel);
	tbgCargoType.pager = jsonCargoType;
	tbgCargoType.render('cargoTypeTableGrid');
	tbgCargoType.afterRender = function(){
		objCargoTypeMain = tbgCargoType.geniisysRows;
		changeTag = 0;
	};		
	
	function setTbgCargoType(obj) {
		objCargoType.cargoClassCd = obj == null? "": (obj.cargoClassCd==null? "":obj.cargoClassCd);			
		tbgCargoType.url = contextPath
				+ "/GIISCargoTypeController?action=showCargoType&refresh=1&cargoClassCd="
				+ objCargoType.cargoClassCd;
		tbgCargoType._refreshList();				
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
	
	function enableFields(){		
		$("txtType").disabled = false;
		$("txtDescription").disabled = false;
		$("txtRemarks").disabled = false;		
		enableImg("imgEditRemarks");		
		$("txtType").setStyle({backgroundColor: '#FFFACD'});
		$("txtDescription").setStyle({backgroundColor: '#FFFACD'});		
		$("txtRemarks").setStyle({backgroundColor: 'white'});		
		$("txtUserId").setStyle({backgroundColor: 'white'});		
		$("txtLastUpdate").setStyle({backgroundColor: 'white'});
	}
	function disableFields(){				
		$("txtType").disabled = true;
		$("txtDescription").disabled = true;
		$("txtRemarks").disabled = true;			
		disableImg("imgEditRemarks");					
		$("txtType").setStyle({backgroundColor: '#F0F0F0'});
		$("txtDescription").setStyle({backgroundColor: '#F0F0F0'});		
		$("txtRemarks").setStyle({backgroundColor: '#F0F0F0'});		
		$("txtUserId").setStyle({backgroundColor: '#F0F0F0'});		
		$("txtLastUpdate").setStyle({backgroundColor: '#F0F0F0'});
	}
	
	function setBtnAndFields(obj) {
		if (obj != null) {				
			enableButton("btnDelete");				
			$("btnAddUpdate").value = "Update";		
			$("txtType").readOnly = "readonly"; 	
		}else{
			$("btnAddUpdate").value = "Add";	
			enableButton("btnCancel");
			enableButton("btnSave");
			disableButton("btnDelete");
			$("txtType").readOnly = false; 
		}
	}
	
	function setCargoTypeDtls(obj) {		
		try {			
			$("txtType").value = obj == null ? "" : (obj.cargoType == null ?"":unescapeHTML2(obj.cargoType));
			$("txtDescription").value = obj == null ? "" : (obj.cargoTypeDesc == null ?"":unescapeHTML2(obj.cargoTypeDesc));
			$("txtRemarks").value = obj == null ? "" : (obj.remarks == null ?"":unescapeHTML2(obj.remarks));
			$("txtUserId").value = obj == null ? "" : (obj.userId == null ?"":obj.userId);
			$("txtLastUpdate").value = obj == null ? "" : (obj.lastUpdate == null ?"":obj.lastUpdate);
		} catch (e) {
			showErrorMessage("setCargoTypeDtls", e);
		}
	}	
	
	function fieldFocus(obj){
		if(obj!=null){
			$("txtDescription").focus();	
		}else{
			if(!($("btnAddUpdate").disabled)){
				$("txtType").focus();	
			}			
		}
	}
	
	function setObjCargoType(obj) {
		try {					
			objCargoType.cargoType = obj == null ? "" : (obj.cargoType==null?"":unescapeHTML2(obj.cargoType));
			objCargoType.cargoTypeDesc = obj == null ? "" : (obj.cargoTypeDesc==null?"":unescapeHTML2(obj.cargoTypeDesc));	
			objCargoType.remarks = obj == null ? "" : (obj.remarks==null?"":unescapeHTML2(obj.remarks));
			objCargoType.userId = obj == null ? "" : (obj.userId==null?"":obj.userId);
			objCargoType.lastUpdate = obj == null ? "" : (obj.lastUpdate==null?"":obj.lastUpdate);		
			objCargoType.cpiRecNo = obj == null ? "" : (obj.cpiRecNo==null?"":obj.cpiRecNo);
			objCargoType.cpiBranchCd = obj == null ? "" : (obj.cpiBranchCd==null?"":obj.cpiBranchCd);			
		} catch (e) {
			showErrorMessage("setObjCargoType", e);
		}
	}

	function setRowObjCargoType(func){
		try {					
			var rowObjCargoType = new Object();
			rowObjCargoType.cargoClassCd = objCargoType.cargoClassCd;	
			rowObjCargoType.cargoType = escapeHTML2($("txtType").value);	
			rowObjCargoType.cargoTypeDesc = escapeHTML2($("txtDescription").value);	
			rowObjCargoType.remarks = escapeHTML2($("txtRemarks").value);
			rowObjCargoType.userId = escapeHTML2(userId);
			var lastUpdate = new Date();
			rowObjCargoType.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');	
			rowObjCargoType.cpiRecNo = objCargoType.cpiRecNo;
			rowObjCargoType.cpiBranchCd = objCargoType.cpiBranchCd;
			rowObjCargoType.recordStatus 	= func == "Delete" ? -1 : func == "Add" ? 0 : 1;
			return rowObjCargoType;
		} catch (e) {
			showErrorMessage("setRowObjCargoType", e);
		}
	}	
	
	function valAddRec() {
		try {
			if (checkAllRequiredFieldsInDiv("cargoTypeDiv")) {
				if ($F("btnAddUpdate") == "Add") {	
					var addedSameExists = false;
					var deletedSameExists = false;	
					
					for(var i=0; i<tbgCargoType.geniisysRows.length; i++){
						if(tbgCargoType.geniisysRows[i].recordStatus == 0 || tbgCargoType.geniisysRows[i].recordStatus == 1){								
							if(tbgCargoType.geniisysRows[i].cargoType == $F("txtType")){
								addedSameExists = true;								
							}							
						} else if(tbgCargoType.geniisysRows[i].recordStatus == -1){
							if(tbgCargoType.geniisysRows[i].cargoType == $F("txtType")){
								deletedSameExists = true;
							}
						}
					}			
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same cargo_type.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					
					new Ajax.Request(contextPath + "/GIISCargoTypeController", {
						method : "POST",
						parameters : {						
							action : "validateCargoType",				
							cargoType: $("txtType").value
						},	
						asynchronous : false,
						evalScripts : true,				
						onComplete : function(response) {
							hideNotice();							
							var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));									
							if (res.result != "TRUE"){					
								showWaitingMessageBox(res.result, "E", function() {	
						    		$("txtType").focus();
								});											
							}	
							else{
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
			rowObj  = setRowObjCargoType($("btnAddUpdate").value);		
			changeTag=1;	
			objCargoTypeMain.splice(row, 1, rowObj);
			tbgCargoType.updateVisibleRowOnly(rowObj, row);
			tbgCargoType.onRemoveRowFocus();
		}else if ($("btnAddUpdate").value=="Add"){	
			rowObj  = setRowObjCargoType($("btnAddUpdate").value);		
			objCargoTypeMain.push(rowObj);
			tbgCargoType.addBottomRow(rowObj);
			tbgCargoType.onRemoveRowFocus();
			changeTag = 1;		
		}		
		changeTagFunc = saveCargoType;
	}

	function deleteInCargoType(){ 
		delObj = setRowObjCargoType($("btnDelete").value);
		objCargoTypeMain.splice(row, 1, delObj);
		tbgCargoType.deleteVisibleRowOnly(row);
		changeTag = 1;
		setCargoTypeDtls(null);	
		setBtnAndFields(null);			
	}

	function saveCargoType(func){
		try{	
			var objParams = new Object(); 
			objParams.setRows = getAddedAndModifiedJSONObjects(objCargoTypeMain);
			objParams.delRows = getDeletedJSONObjects(objCargoTypeMain);
			new Ajax.Request(contextPath + "/GIISCargoTypeController", {
				method : "POST",
				parameters : {
					action : "saveCargoType",
					parameters : JSON.stringify(objParams)				
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : function(){
					showNotice("Saving Cargo Type Maintenance, please wait ...");
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
					    		tbgCargoType._refreshList();		
					    		tbgCargoType.keys.removeFocus(
					    				tbgCargoType.keys._nCurrentFocus, true);
					    		tbgCargoType.keys.releaseKeys();
								changeTag = 0;
								changeTagFunc = "";
							});							
						}
					}
				}
			});				
		}catch(e){
			showErrorMessage("saveCargoType", e);
		}
	}

	function chkChangesBfrAction(func, action){	
		if(changeTag==0){
			func();
		}else{
			 showConfirmBox4("Confirmation",objCommonMessage.WITH_CHANGES ,"Yes","No","Cancel",
				function(){
				 	saveCargoType(func);					
				 },function(){
					 func();					
					 },"",1);
				 
		}
	}	
	
	function chkDeleteGIISS008CargoType(){
		try{
			var canDelete = true;
		 	new Ajax.Request(contextPath + "/GIISCargoTypeController", {
				method : "POST",
				parameters : {
					action : "chkDeleteGIISS008CargoType",				
					cargoType: $("txtType").value,					
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
			showErrorMessage("chkDeleteGIISS008CargoType", e);
		}
	}
		
	function initializeGIISS008(){
		setBtnAndFields(null);		
		objCargoType = new Object();
		changeTag = 0;
		disableFields();
		disableButton("btnAddUpdate");	
	}	
	
	$("btnAddUpdate").observe("click",valAddRec);

	$("btnDelete").observe("click", function(){
		if(chkDeleteGIISS008CargoType()){
			deleteInCargoType();
			changeTagFunc = saveCargoType; // for logout confirmation
		}				
	});

	$("btnSave").observe("click", function() {
		if(changeTag==1){			
			saveCargoType(function(){
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
	
	$("txtType").observe("keyup", function(){
		$("txtType").value = $F("txtType").toUpperCase();
	});
	
	$("txtType").observe("change", function(){
		$("txtType").value = $F("txtType").toUpperCase();
	});

	$("txtDescription").observe("keyup", function(){
		$("txtDescription").value = $F("txtDescription").toUpperCase();
	});
	
	$("txtDescription").observe("change", function(){
		$("txtDescription").value = $F("txtDescription").toUpperCase();
	});
			
	$("imgEditRemarks").observe("click", function() {
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	observeReloadForm("reloadForm", function(){
		showCargoClass();
		});	
	
	$("underwritingExit").observe("click", function() {
		chkChangesBfrAction(function(){
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main" , null); 
			changeTag = 0;
			changeTagFunc = "";
			});			
	});
	
	initializeGIISS008();	
} catch (e) {
	showErrorMessage("Error : ", e.message);
}
	
</script>