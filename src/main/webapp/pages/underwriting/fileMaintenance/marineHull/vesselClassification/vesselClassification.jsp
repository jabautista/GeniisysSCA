<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="vesselClassificationMaintenance" name="vesselClassificationMaintenance" style="float: left; width: 100%;">
	<div id="vesselClassificationMaintenanceExitDiv">
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
			<label>Vessel Classification Maintenance</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="showHideVessClass" name="gro" style="margin-left: 5px;">Hide</label> 
			 	<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>
	<div id="showBody">			
		<div class="sectionDiv">
			<div style="padding:10px; margin-left: 100px">
				<div id="vessClassTableGrid" style="height: 331px;width:700px;"></div>
			</div>	
			<div>	
				<div align="center">
					<table>
						<tr>
							<td align="right">Vessel Class</td>
							<td><input class="required integerNoNegativeUnformattedNoComma" id="txtVesselClass" maxlength="2" type="text" style="width:150px; text-align: right;"></td>
						</tr>
						<tr>
							<td align="right">Description</td>
							<td colspan="3"><input class="required" id="txtDescription" maxlength="20" type="text"  style="width:552px"></td>
						</tr>	
						<tr>
							<td align="right">Remarks</td>
							<td colspan="3">
								<span class="lovSpan" style="width: 558px; margin: 0">
										<input maxlength="4000"
										style="width: 532px; float: left; height: 14px; border: none; margin:0"
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
	setModuleId("GIISS047");
	setDocumentTitle("Vessel Classification Maintenance");
	var row;
	var objVessClassMain = [];	
	var jsonVessClass = JSON.parse('${jsonVessClass}');
	var changeCounter =0;
	vessClassTableModel = {
		url : contextPath
				+ "/GIISVessClassController?action=showVesselClassification&refresh=1",
		options : {
			width : '700px',
			pager : {},
			toolbar : {
				elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
				onFilter: function(){	
					if(changeTag==0){
						tbgVessClass.keys.removeFocus(
								tbgVessClass.keys._nCurrentFocus, true);
						tbgVessClass.keys.releaseKeys();
						setObjVessClass(null);		
						setBtnAndFields(null);	
						setVessClassDtls(null);	
						fieldFocus(null);								
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
					tbgVessClass.keys.removeFocus(
							tbgVessClass.keys._nCurrentFocus, true);
					tbgVessClass.keys.releaseKeys();
					setObjVessClass(null);		
					setBtnAndFields(null);	
					setVessClassDtls(null);	
					fieldFocus(null);	
								
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}								
			},
			onCellFocus : function(element, value, x, y, id) {						
				tbgVessClass.keys.removeFocus(
						tbgVessClass.keys._nCurrentFocus, true);
				tbgVessClass.keys.releaseKeys();	
				setObjVessClass(tbgVessClass.geniisysRows[y]);				
				setVessClassDtls(tbgVessClass.geniisysRows[y]);
				setBtnAndFields(tbgVessClass.geniisysRows[y]);				
				fieldFocus(tbgVessClass.geniisysRows[y]);		
					
				row = y;
			},
			onRemoveRowFocus : function(element, value, x, y, id) {				
				tbgVessClass.keys.removeFocus(
						tbgVessClass.keys._nCurrentFocus, true);
				tbgVessClass.keys.releaseKeys();
				setObjVessClass(null);	
				setBtnAndFields(null);	
				setVessClassDtls(null);	
				fieldFocus(null);	
								
			},
			beforeSort : function() {			
				if(changeTag==0){
					tbgVessClass.keys.removeFocus(
							tbgVessClass.keys._nCurrentFocus, true);
					tbgVessClass.keys.releaseKeys();
					setObjVessClass(null);	
					setBtnAndFields(null);	
					setVessClassDtls(null);	
					fieldFocus(null);		
								
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}					
			},
			onSort : function() {				
				if(changeTag==0){
					tbgVessClass.keys.removeFocus(
							tbgVessClass.keys._nCurrentFocus, true);
					tbgVessClass.keys.releaseKeys();
					setObjVessClass(null);	
					setBtnAndFields(null);	
					setVessClassDtls(null);	
					fieldFocus(null);										
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}			
			},
			onRefresh : function() {				
				if(changeTag==0){
					tbgVessClass.keys.removeFocus(
							tbgVessClass.keys._nCurrentFocus, true);
					tbgVessClass.keys.releaseKeys();
					setObjVessClass(null);		
					setBtnAndFields(null);	
					setVessClassDtls(null);	
					fieldFocus(null);									
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
		}, {
			id : "vessClassCd",
			title : "Vessel Class",
			width : '160px',
			align : "right",
			titleAlign : "right",
			filterOption : true,
			filterOptionType: 'integerNoNegative',
			renderer: function(value){
				return unescapeHTML2(value);	
			}			
		}, {
			id : "vessClassDesc",
			title : "Description",			
			width : '510px',
			align : "left",
			titleAlign : "left",
			filterOption : true,
			renderer: function(value){
				return unescapeHTML2(value);	
			}
		}],
		rows : jsonVessClass.rows
	};

	tbgVessClass = new MyTableGrid(vessClassTableModel);
	tbgVessClass.pager = jsonVessClass;
	tbgVessClass.render('vessClassTableGrid');
	tbgVessClass.afterRender = function(){
		objVessClassMain = tbgVessClass.geniisysRows;
		changeTag = 0;
	};		
		
	function setBtnAndFields(obj) {
		if (obj != null) {				
			enableButton("btnDelete");				
			$("btnAddUpdate").value = "Update";	
			if(obj.newRecord!="Yes"){
				$("txtVesselClass").disabled = true;
			}
		}else{			
			$("btnAddUpdate").value = "Add";	
			enableButton("btnCancel");
			enableButton("btnSave");
			disableButton("btnDelete");
			enableButton("btnAddUpdate");
			$("txtVesselClass").disabled = false;
		}
	}
	
	function setVessClassDtls(obj) {		
		try {			
			$("txtVesselClass").value = obj == null ? "" : (obj.vessClassCd == null ?"":unescapeHTML2(obj.vessClassCd));
			$("txtDescription").value = obj == null ? "" : (obj.vessClassDesc == null ?"":unescapeHTML2(obj.vessClassDesc));
			$("txtRemarks").value = obj == null ? "" : (obj.remarks == null ?"":unescapeHTML2(obj.remarks));
			$("txtUserId").value = obj == null ? "" : (obj.userId == null ?"":unescapeHTML2(obj.userId));
			$("txtLastUpdate").value = obj == null ? "" : (obj.lastUpdate == null ?"":unescapeHTML2(obj.lastUpdate));
		} catch (e) {
			showErrorMessage("setVessClassDtls", e);
		}
	}	
	
	function fieldFocus(obj){
		if(obj!=null){
			if(obj.newRecord!="Yes"){
				$("txtDescription").focus();
			}else{
				$("txtVesselClass").focus();	
			}
		}else{			
			$("txtVesselClass").focus();						
		}
	}
	
	function chkRequiredFields(){	
		if($("txtVesselClass").value == ""){
			customShowMessageBox("Required fields must be entered.", imgMessage.ERROR,"txtVesselClass");
			return false;
		}else if($("txtDescription").value == ""){
			customShowMessageBox("Required fields must be entered.", imgMessage.ERROR,"txtDescription");	
			return false;
		}else{
			return true;
		}
	}
	
	function chkChangesBfrExit(func, action){	
		if(changeTag==0){
			func();
		}else{
			 showConfirmBox4("Confirmation",objCommonMessage.WITH_CHANGES ,"Yes","No","Cancel",
				function(){
				 saveVessClass();
					 if(objVessClass.saveResult){						
						 if(action=="Cancel"){//added to avoid exit when btnCancel pressed.
							 changeTag = 1;
						 }
						 func();
					 }					 	
				 },function(){
					 func();					
					 },"",1);
				 
		}
	}
	
	function chkIfThereAreChanges(obj){		
		if (obj.vessClassCd == objVessClass.vessClassCd&&
			obj.vessClassDesc == objVessClass.vessClassDesc&&
			obj.remarks == objVessClass.remarks){
			return false;
		}else {
			return true;
		}
	}
	
	function setObjVessClass(obj) {
		try {					
			objVessClass.vessClassCd = obj == null ? "" : (obj.vessClassCd==null?"":obj.vessClassCd);
			objVessClass.vessClassDesc = obj == null ? "" : (obj.vessClassDesc==null?"":obj.vessClassDesc);	
			objVessClass.userId = obj == null ? "" : (obj.userId==null?"":obj.userId);		
			objVessClass.lastUpdate = obj == null ? "" : (obj.lastUpdate==null?"":obj.lastUpdate);				
			objVessClass.remarks = obj == null ? "" : (obj.remarks==null?"":obj.remarks);				
			objVessClass.cpiRecNo = obj == null ? "" : (obj.cpiRecNo==null?"":obj.cpiRecNo);				
			objVessClass.cpiBranchCd = obj == null ? "" : (obj.cpiBranchCd==null?"":obj.cpiBranchCd);	
			objVessClass.newRecord = obj == null ? "" : (obj.newRecord==null?"":obj.newRecord);	
		} catch (e) {
			showErrorMessage("setObjVessClass", e);
		}
	}
	
	function setRowObjVessClass(func){
		try {					
			var rowObjVessClass = new Object();		
			rowObjVessClass.vessClassCd = $("txtVesselClass").value;	
			rowObjVessClass.vessClassDesc = $("txtDescription").value;
			rowObjVessClass.userId = userId;
			rowObjVessClass.lastUpdate = $("txtLastUpdate").value;
			rowObjVessClass.remarks = $("txtRemarks").value;		
			rowObjVessClass.cpiRecNo = objVessClass.cpiRecNo;
			rowObjVessClass.cpiBranchCd = objVessClass.cpiBranchCd;				
			rowObjVessClass.recordStatus = func == "Delete" ? -1 : func == "Add" ? 0 : 1;
			rowObjVessClass.newRecord = func == "Add" ? "Yes" : objVessClass.newRecord;
			return rowObjVessClass;
		} catch (e) {
			showErrorMessage("setRowObjVessClass", e);
		}
	}	
	
	function addUpdateVessClass(){		
		if($("btnAddUpdate").value=="Update"){
			rowObj  = setRowObjVessClass($("btnAddUpdate").value);				
			if(chkIfThereAreChanges(rowObj)&&rowObj.newRecord!="Yes"){
				changeTag=1;	
				changeCounter++;					
			}	
			objVessClassMain.splice(row, 1, rowObj);
			tbgVessClass.updateVisibleRowOnly(rowObj, row);
			tbgVessClass.onRemoveRowFocus();
		}else if ($("btnAddUpdate").value=="Add"){	
			rowObj  = setRowObjVessClass($("btnAddUpdate").value);
			objVessClassMain.push(rowObj);
			tbgVessClass.addBottomRow(rowObj);
			tbgVessClass.onRemoveRowFocus();
			changeTag = 1;
			changeCounter++;
		}
		changeTagFunc = saveVessClass; // for logout confirmation		
	}
	
	//marco - 07.07.2014
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISVessClassController", {
				parameters: {
					action: "valDeleteRec",
					vessClassCd: objVessClass.vessClassCd
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						deleteInVessClassTableGrid();
					}
				}
			});
		} catch(e){
			showErrorMessage("valDeleteRec", e);
		}
	}
	
	function deleteInVessClassTableGrid(){ 
		changeTag = 1;
		delObj = setRowObjVessClass($("btnDelete").value);		
		objVessClassMain.splice(row, 1, delObj);
		tbgVessClass.deleteVisibleRowOnly(row);
		setVessClassDtls(null);	
		setBtnAndFields(null);		
		changeCounter--;
		if (changeCounter == 0){
			changeTag=0;
		}		
	}
	
	function saveVessClass(){
		try{	
			var objParams = new Object(); 
			objParams.setRows = getAddedAndModifiedJSONObjects(objVessClassMain);
			objParams.delRows = getDeletedJSONObjects(tbgVessClass.geniisysRows); //marco - 07.07.2014
			new Ajax.Request(contextPath + "/GIISVessClassController", {
				method : "POST",
				parameters : {
					action : "saveVessClass",
					parameters : JSON.stringify(objParams)				
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : function(){
					showNotice("Saving Vessel Classification Maintenance, please wait ...");
				},
				onComplete : function(response) {
					hideNotice();
					var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
					if (checkErrorOnResponse(response)){
						if (res.message != "SUCCESS"){
							showMessageBox(res.message, imgMessage.ERROR);	
							objVessClass.saveResult = false;
						}else{
							showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);		
							objVessClass.saveResult = true;
							changeTag = 0;		
							changeTagFunc = "";	
						}
					}
				}
			});				
		}catch(e){
			showErrorMessage("saveVessClass", e);
		}
	}
	
	function actionOnCancel(){	
		if(changeTag==0){
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main" , null); 
		}else{
			tbgVessClass._refreshList();		
			tbgVessClass.keys.removeFocus(
					tbgVessClass.keys._nCurrentFocus, true);
			tbgVessClass.keys.releaseKeys();
			changeTag = 0;
			changeTagFunc = "";
		}	
	}
	
	function initializeGIISS030(){
		setBtnAndFields(null);		
		objVessClass = new Object();
		changeTag = 0;		
	}	
	
	function showHideDiv(divId,labelId){
		if($(divId).getStyle('display') !='none'){
			Effect.toggle(divId, "blind", {duration: .3});
			$(labelId).innerHTML = "Show";
		}else if($(divId).getStyle('display') =='none'){
			Effect.toggle(divId, "blind", {duration: .3});
			$(labelId).innerHTML = "Hide";
		}		
	}
	
	function validateGIISS047VesselClass(){
		try{	
			var exist = false;
		 	new Ajax.Request(contextPath + "/GIISVessClassController", {
				method : "POST",
				parameters : {
					action : "validateGIISS047VesselClass",				
					vessClassCd: $("txtVesselClass").value					
				},	
				asynchronous : false,
				evalScripts : true,				
				onComplete : function(response) {
					hideNotice();
					var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));									
					if (res.result != "TRUE"){	
						exist = true;
						showWaitingMessageBox(res.result, "E", function() {
				    		$("txtVesselClass").value ="";		
				    		$("txtVesselClass").focus();
						});	
					}		
				}
			}); 
		 	return exist;
		}catch(e){
		}
	}	
	
	function validateVesselClass(){
		var valid = true;
		if(validateGIISS047VesselClass()){
			valid = false;
		}
		
		Object.keys(objVessClassMain).forEach(function(i) {
		    if(objVessClassMain[i].vessClassCd==$("txtVesselClass").value){
		    	showWaitingMessageBox("Vessel classification code must be unique.", "E", function() {
		    		$("txtVesselClass").value ="";
		   			$("txtVesselClass").focus();
				});		
		    	valid = false;
			}
		});
		if(isNaN($F("txtVesselClass"))){
			showWaitingMessageBox("Field Vessel Class must be of form 09.", "E", function() {
				$("txtVesselClass").value ="";
	    		$("txtVesselClass").focus();
			});
			valid = false;
		}else{
			if (parseInt($F("txtVesselClass")) < 1) {
				showWaitingMessageBox("Invalid value for Vessel Class.", "E", function() {
					$("txtVesselClass").value ="";
		   			$("txtVesselClass").focus();
				});
				valid = false;
			}
		}		
		return valid;
	}
	
	//marco - 07.07.2014
	function valAddRec(){
		try{
			if($F("btnAddUpdate") == "Add") {
				var addedSameExists = false;
				var deletedSameExists = false;
				
				for(var i=0; i<tbgVessClass.geniisysRows.length; i++){
					if(tbgVessClass.geniisysRows[i].recordStatus == 0 || tbgVessClass.geniisysRows[i].recordStatus == 1){	
						if(tbgVessClass.geniisysRows[i].vessClassCd == $F("txtVesselClass")){
							addedSameExists = true;	
						}
					}else if(tbgVessClass.geniisysRows[i].recordStatus == -1){
						if(tbgVessClass.geniisysRows[i].vessClassCd == $F("txtVesselClass")){
							deletedSameExists = true;
						}
					}							
				}
				
				if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
					showMessageBox("Record already exists with the same vess_class_cd.", "E");
					return;
				}else if(deletedSameExists && !addedSameExists){
					addUpdateVessClass();
					return;
				}
				
				new Ajax.Request(contextPath + "/GIISVessClassController", {
					parameters : {
						action : "validateGIISS047VesselClass",
						vessClassCd : $F("txtVesselClass")
					},
					onCreate : showNotice("Processing, please wait..."),
					onComplete : function(response){
						hideNotice();
						if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
							addUpdateVessClass();
						}
					}
				});
			} else {
				addUpdateVessClass();
			}
		}catch(e){
			showErrorMessage("valAddRec", e);
		}
	}
	
	$("btnAddUpdate").observe("click", function() {
		if(chkRequiredFields()){
			/* if(validateVesselClass()){		
				addUpdateVessClass();	
			} */
			valAddRec(); //marco - 07.07.2014
		}		
	});	
	
	$("btnDelete").observe("click", function(){		
		if(objVessClass.newRecord=="Yes"){
			deleteInVessClassTableGrid();				
		}else{
			valDeleteRec();	
		}
	});
	
	$("btnSave").observe("click", function() {
		if(changeTag==1){			
			saveVessClass();
			if(objVessClass.saveResult){	
				tbgVessClass._refreshList();		
				tbgVessClass.keys.removeFocus(
						tbgVessClass.keys._nCurrentFocus, true);
				tbgVessClass.keys.releaseKeys();				
			}			
		}else{
			showMessageBox(objCommonMessage.NO_CHANGES, imgMessage.INFO);
		}		
	});
	
	$("btnCancel").observe("click", function() {
		chkChangesBfrExit(function(){
			actionOnCancel();		
			},"Cancel");	
	});
	
	$("imgEditRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000);
	});	
	
	observeReloadForm("reloadForm", function(){
		showVesselClassification();
		});
	
	$("showHideVessClass").observe("click", function() {
		showHideDiv("showBody","showHideVessClass");
	});
	
	$("underwritingExit").observe("click", function() {
		chkChangesBfrExit(function(){
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main" , null); 
			changeTag = 0;
			changeTagFunc = "";
			});			
	});
	
	initializeAll();
	initializeGIISS030();	
} catch (e) {
	showErrorMessage("Error : ", e.message);
}
	
</script>