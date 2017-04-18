<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="typhoonZoneMaintenance" name="typhoonZoneMaintenance" style="float: left; width: 100%;">
	<div id="typhoonZoneMaintenanceExitDiv">
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
			<label>Typhoon Zone Maintenance</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="showHideTyphoonZone" name="gro" style="margin-left: 5px;">Hide</label> 
			 	<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>
	<div id="showBody">	
		<div class="sectionDiv">
			<div style="padding:10px;">
				<div id="typhoonZoneTableGrid" style="height: 331px;width:700px;margin-left: 100px"></div>
			</div>	
			<div>	
				<div style="margin-left: 70px">
					<table>					
						<tr>
							<td align="right">Typhoon Zone</td>
							<td><input class="required" id="txtTyphoonZone" maxlength="2" type="text" style="width:150px;"></td>
							<td align="right" style="width: 100px;">Zone Group</td>
							<td><span class="lovSpan" style="width: 80px; margin-top:2px">
									<input id="txtZoneGroup" maxlength="2" type="text" style="width:54px;margin: 0;height: 14px;border: 0"><img
									src="${pageContext.request.contextPath}/images/misc/searchIcon.png"
									id="imgSearchZoneGroup" alt="Go" style="float: right; margin-top: 2px;" />
								</span>	
							</td>
							<td><input id="txtZoneGroupDesc" readonly="readonly" type="text" style="width:200px;"></td>
						</tr>	
						<tr>
							<td align="right">Typhoon Zone Description</td>
							<td colspan="4">								
								<input class="required" maxlength="500" style="width: 552px;" type="text" id="txtTyphoonZoneDesc" /> 
							</td>
						</tr>										
						<tr>
							<td align="right">Remarks</td>
							<td colspan="4">
								<div style="border: 1px solid gray; height: 21px; width: 558px">
									<textarea id="txtRemarks" name="txtRemarks" style="border: none; height: 13px; resize: none; width: 532px" maxlength="4000"></textarea>
									<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; padding: 3px; float: right;" alt="EditRemark" id="imgEditRemarks"/>
								</div>
							</td>
						</tr>
						<tr>
							<td align="right">User ID</td>
							<td><input id="txtUserId" type="text" style="width:150px" readonly="readonly"></td>
							<td colspan="2" align="right" style="width: 120px;">Last Update</td>
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
	setModuleId("GIISS052");
	setDocumentTitle("Typhoon Zone Maintenance");
	var row;
	var columnIndex;
	var pageId;
	var objTyphoonZoneMain = [];
	var jsonTyphoonZone = JSON.parse('${jsonTyphoonZone}');
	typhoonZoneTableModel = {
		url : contextPath
				+ "/GIISTyphoonZoneController?action=showTyphoonZoneMaintenance&refresh=1",
		options : {
			hideColumnChildTitle: true,
			width : '700px',
			pager : {},
			toolbar : {
				elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
				onFilter: function(){						
					if(changeTag==0){
						tbgTyphoonZone.keys.removeFocus(
								tbgTyphoonZone.keys._nCurrentFocus, true);
						tbgTyphoonZone.keys.releaseKeys();	
						setTyphoonZoneDtls(null);
						setBtnAndFields(null);
						setObjTyphoonZone(null);
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
					tbgTyphoonZone.keys.removeFocus(
							tbgTyphoonZone.keys._nCurrentFocus, true);
					tbgTyphoonZone.keys.releaseKeys();	
					setTyphoonZoneDtls(null);
					setBtnAndFields(null);
					setObjTyphoonZone(null);
					fieldFocus(null);
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}								
			},
			onCellFocus : function(element, value, x, y, id) {						
				tbgTyphoonZone.keys.removeFocus(
						tbgTyphoonZone.keys._nCurrentFocus, true);
				tbgTyphoonZone.keys.releaseKeys();		
				setTyphoonZoneDtls(tbgTyphoonZone.geniisysRows[y]);
				setBtnAndFields(tbgTyphoonZone.geniisysRows[y]);
				setObjTyphoonZone(tbgTyphoonZone.geniisysRows[y]);
				fieldFocus(tbgTyphoonZone.geniisysRows[y]);
				row = y;
			},
			onRemoveRowFocus : function(element, value, x, y, id) {	
				tbgTyphoonZone.keys.removeFocus(
						tbgTyphoonZone.keys._nCurrentFocus, true);
				tbgTyphoonZone.keys.releaseKeys();	
				setTyphoonZoneDtls(null);
				setBtnAndFields(null);
				setObjTyphoonZone(null);
				fieldFocus(null);
			},	
			beforeSort : function(element, value, x, y, id) {
				if(changeTag==0){
					tbgTyphoonZone.keys.removeFocus(
							tbgTyphoonZone.keys._nCurrentFocus, true);
					tbgTyphoonZone.keys.releaseKeys();	
					setTyphoonZoneDtls(null);
					setBtnAndFields(null);
					setObjTyphoonZone(null);
					fieldFocus(null);
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}							
			},
			onSort : function() {	
				if(changeTag==0){
					tbgTyphoonZone.keys.removeFocus(
							tbgTyphoonZone.keys._nCurrentFocus, true);
					tbgTyphoonZone.keys.releaseKeys();		
					setTyphoonZoneDtls(null);
					setBtnAndFields(null);
					setObjTyphoonZone(null);
					fieldFocus(null);
				}
			},	
			onRefresh : function() {				
				if(changeTag==0){
					tbgTyphoonZone.keys.removeFocus(
							tbgTyphoonZone.keys._nCurrentFocus, true);
					tbgTyphoonZone.keys.releaseKeys();		
					setTyphoonZoneDtls(null);
					setBtnAndFields(null);
					setObjTyphoonZone(null);
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
			id : "typhoonZone",
			title : /*"Typhone Zone"*/ "Typhoon Zone",
			width : '100px',
			align : "right",
			titleAlign : "right",
			filterOption : true,
			filterOptionType : 'integerNoNegative'
		},{
			id : "typhoonZoneDesc",
			title : "Typhoon Zone Description",			
			width : '408px',
			align : "left",
			titleAlign : "left",
			filterOption : true			
		},{
			id : "zoneGrp zoneGrpDesc",
			title : "Zone Group",			
			width : '160px',			
			children : [{
                id : 'zoneGrp',
                title:'Zone Group',
                align : 'right',
                width: 60,
                filterOption: true,
                filterOptionType : 'integerNoNegative'
            },{
                id : 'zoneGrpDesc',
                title: 'Zone Group Description',
                align : "left",
                width: 100,
                filterOption: true
            }]
		}],
		rows : jsonTyphoonZone.rows
	};

	tbgTyphoonZone = new MyTableGrid(typhoonZoneTableModel);
	tbgTyphoonZone.pager = jsonTyphoonZone;
	tbgTyphoonZone.render('typhoonZoneTableGrid');
	tbgTyphoonZone.afterRender = function(){
		objTyphoonZoneMain = tbgTyphoonZone.geniisysRows;
		changeTag = 0;
	};
	
	function showZoneGroupLOV() {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "showZoneGroupLOV",
				searchString : ($("txtZoneGroup").readAttribute("lastValidValue") != $F("txtZoneGroup") ? nvl($F("txtZoneGroup"),"%") : "%"),
				page : 1,				
			},
			title : "Zone Group",
			width : 416,
			height : 386,
			columnModel : [ {
				id : "zoneGrp",
				title : "Zone Value",
				width : '135px',
				filterOptionType : 'integerNoNegative'
			},{
				id : "zoneGrpDesc",
				title : "Zone Meaning",
				width : '250px',
			}  ],
			draggable : true,
			autoSelectOneRecord : true,
			filterText :$("txtZoneGroup").value,
			onSelect : function(row) {
				$("txtZoneGroup").value = unescapeHTML2(row.zoneGrp);	
				$("txtZoneGroupDesc").value = unescapeHTML2(row.zoneGrpDesc);				
				$("txtZoneGroup").setAttribute("lastValidValue", row.zoneGrp);
				$("txtZoneGroupDesc").setAttribute("lastValidValue", row.zoneGrpDesc);
			},
			onCancel : function() {
				$("txtZoneGroup").value = $("txtZoneGroup").readAttribute("lastValidValue");
				$("txtZoneGroupDesc").value=$("txtZoneGroupDesc").readAttribute("lastValidValue");
			},
			onUndefinedRow : function() {
				customShowMessageBox("No record selected.", imgMessage.INFO,
						"txtZoneGroup");	
				$("txtZoneGroup").value = "";	
				$("txtZoneGroupDesc").value = "";	
				$("txtZoneGroup").setAttribute("lastValidValue", "");
				$("txtZoneGroupDesc").setAttribute("lastValidValue", "");
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();
			}
		});
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
	
	function setTyphoonZoneDtls(obj) {		
		try {
			$("txtTyphoonZone").value = obj == null ? "" : unescapeHTML2(obj.typhoonZone);
			$("txtZoneGroup").value = obj == null ? "" : unescapeHTML2(obj.zoneGrp);
			$("txtZoneGroupDesc").value = obj == null ? "" : unescapeHTML2(obj.zoneGrpDesc);
			$("txtTyphoonZoneDesc").value = obj == null ? "" : unescapeHTML2(obj.typhoonZoneDesc);
			$("txtRemarks").value = obj == null ? "" : unescapeHTML2(obj.remarks);	
			$("txtUserId").value = obj == null ? "" : obj.userId;
			$("txtLastUpdate").value = obj == null ? "" : obj.lastUpdate;
			$("txtZoneGroup").setAttribute("lastValidValue", obj == null ? "": (obj.zoneGrp==null? "":obj.zoneGrp));
			$("txtZoneGroupDesc").setAttribute("lastValidValue", obj == null ? "": (obj.zoneGrpDesc==null? "":obj.zoneGrpDesc));
		} catch (e) {
			showErrorMessage("setTyphoonZoneDtls", e);
		}
	}	
	
	function setBtnAndFields(obj) {
		if (obj != null) {				
			enableButton("btnDelete");	
			$("btnAddUpdate").value = "Update";		
			$("txtTyphoonZone").readOnly = "readonly"; 
		}else{
			$("btnAddUpdate").value = "Add";						
			enableButton("btnAddUpdate");
			enableButton("btnCancel");
			enableButton("btnSave");
			disableButton("btnDelete");
			$("txtTyphoonZone").readOnly = false; 
		}
	}
	
	function setObjTyphoonZone(obj) {
		try {		
			objTyphoonZone.typhoonZone = obj == null ? "" : (obj.typhoonZone==null?"":unescapeHTML2(obj.typhoonZone));
			objTyphoonZone.zoneGrp = obj == null ? "" : (obj.zoneGrp==null?"":obj.zoneGrp);
			objTyphoonZone.zoneGrpDesc = obj == null ? "" : (obj.zoneGrpDesc==null?"":unescapeHTML2(obj.zoneGrpDesc));
			objTyphoonZone.typhoonZoneDesc = obj == null ? "" : (obj.typhoonZoneDesc==null?"":unescapeHTML2(obj.typhoonZoneDesc));	
			objTyphoonZone.remarks = obj == null ? "" : (obj.remarks==null?"":unescapeHTML2(obj.remarks));
			objTyphoonZone.userId = obj == null ? "" : (obj.userId==null?"":obj.userId);
			objTyphoonZone.lastUpdate = obj == null ? "" : (obj.lastUpdate==null?"":obj.lastUpdate);			
		} catch (e) {
			showErrorMessage("setObjTyphoonZone", e);
		}
	}
	
	function setRowObjTyphoonZone(func){
		try {					
			var rowObjTyphoonZone = new Object();
			rowObjTyphoonZone.typhoonZone = escapeHTML2($("txtTyphoonZone").value);	
			rowObjTyphoonZone.zoneGrp = $("txtZoneGroup").value;	
			rowObjTyphoonZone.zoneGrpDesc = escapeHTML2($("txtZoneGroupDesc").value);	
			rowObjTyphoonZone.typhoonZoneDesc = escapeHTML2($("txtTyphoonZoneDesc").value);	
			rowObjTyphoonZone.remarks = escapeHTML2($("txtRemarks").value);
			rowObjTyphoonZone.userId = $("txtUserId").value;
			rowObjTyphoonZone.lastUpdate = $("txtLastUpdate").value;
			rowObjTyphoonZone.recordStatus 	= func == "Delete" ? -1 : func == "Add" ? 0 : 1;
			return rowObjTyphoonZone;
		} catch (e) {
			showErrorMessage("setRowObjTyphoonZone", e);
		}
	}	
	
	function chkRequiredFields(){	
		if($("txtTyphoonZone").value == ""){
			customShowMessageBox("Required fields must be entered.", imgMessage.INFO,"txtTyphoonZone");	
			objTyphoonZone.saveResult = false;			
			return false;
		}else if($("txtTyphoonZoneDesc").value == ""){
			customShowMessageBox("Required fields must be entered.", imgMessage.INFO,"txtTyphoonZoneDesc");	
			objTyphoonZone.saveResult = false;		
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
				 saveTyphoonZoneMaintenance(func);					
				 },function(){
					 func();					
					 },"",1);
				 
		}
	}
	
	function chkIfThereAreChanges(obj){			
		if (
			obj.typhoonZone == objTyphoonZone.typhoonZone&&
			obj.zoneGrp == objTyphoonZone.zoneGrp&&
			obj.typhoonZoneDesc == objTyphoonZone.typhoonZoneDesc&&
			obj.remarks == objTyphoonZone.remarks){
			return false;
		}else {
			return true;
		}
	}
	
	function addUpdateTyphoonZone(){
		rowObj  = setRowObjTyphoonZone($("btnAddUpdate").value);
		if(chkRequiredFields()){
			if($("btnAddUpdate").value=="Update"){
				if(chkIfThereAreChanges(rowObj)){
					changeTag=1;					
				}	
				objTyphoonZoneMain.splice(row, 1, rowObj);
				tbgTyphoonZone.updateVisibleRowOnly(rowObj, row);
				tbgTyphoonZone.onRemoveRowFocus();
			}else if ($("btnAddUpdate").value=="Add"){				
				objTyphoonZoneMain.push(rowObj);
				tbgTyphoonZone.addBottomRow(rowObj);
				tbgTyphoonZone.onRemoveRowFocus();
				changeTag = 1;		
			}
		}
	}
	
	function deleteInTyphoonZone(){ 
		delObj = setRowObjTyphoonZone($("btnDelete").value);
		objTyphoonZoneMain.splice(row, 1, delObj);
		tbgTyphoonZone.deleteVisibleRowOnly(row);
		changeTag = 1;
		setTyphoonZoneDtls(null);	
		setBtnAndFields(null);		
	}
	
	function saveTyphoonZoneMaintenance(func){
		try{	
			var objParams = new Object(); 
			objParams.setRows = getAddedAndModifiedJSONObjects(objTyphoonZoneMain);
			objParams.delRows = getDeletedJSONObjects(objTyphoonZoneMain);
			new Ajax.Request(contextPath + "/GIISTyphoonZoneController", {
				method : "POST",
				parameters : {
					action : "saveTyphoonZoneMaintenance",
					parameters : JSON.stringify(objParams)				
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : function(){
					showNotice("Saving Typhoon Zone Maintenance, please wait ...");
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
					    		tbgTyphoonZone._refreshList();		
					    		tbgTyphoonZone.keys.removeFocus(
					    				tbgTyphoonZone.keys._nCurrentFocus, true);
					    		tbgTyphoonZone.keys.releaseKeys();
								changeTag = 0;
								changeTagFunc = "";
							});							
						}
					}
				}
			});				
		}catch(e){
			showErrorMessage("saveTyphoonZoneMaintenance", e);
		}
	}
	
	function validateTyphoonZoneInput(txtField,inputString){
		try{
			var valid = true;
		 	new Ajax.Request(contextPath + "/GIISTyphoonZoneController", {
				method : "POST",
				parameters : {
					action : "validateTyphoonZoneInput",
					txtField : txtField,
					inputString : inputString				
				},	
				asynchronous : false,
				evalScripts : true,				
				onComplete : function(response) {
					hideNotice();
					var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));									
					if (res.txtField == "Typhoon Zone"){
						if (res.result != "TRUE"){	
							valid = false;
							showWaitingMessageBox(res.result, "I", function() {
								$("txtTyphoonZone").value = "";		
								$("txtTyphoonZone").focus();
							});						
						}
					}else if (res.txtField == "Typhoon Zone Description"){
						if (res.result != "TRUE"){
							valid = false;
							showWaitingMessageBox(res.result, "I", function() {
								$("txtTyphoonZoneDesc").value = "";		
								$("txtTyphoonZoneDesc").focus;	
							});	
						}
					}
				}
			}); 	
		 	return valid;
		}catch(e){
			showErrorMessage("validateTyphoonZoneInput", e);
		}
	}
	
	function validateDeleteTyphoonZone(){
		try{	
			var canDelete = true;
		 	new Ajax.Request(contextPath + "/GIISTyphoonZoneController", {
				method : "POST",
				parameters : {
					action : "validateDeleteTyphoonZone",
					typhoonZone : $("txtTyphoonZone").value								
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
			showErrorMessage("validateDeleteTyphoonZone", e);
		}
	}
	
	function fieldFocus(obj){
		if(obj!=null){
			$("txtZoneGroup").focus();	
		}else{
			$("txtTyphoonZone").focus();	
		}
	}
	
	function checkDecimalLovFilter(){
		for(var i = 0; i < $("txtZoneGroup").value.length; i++){
			if ($("txtZoneGroup").value.charAt(i)=='.'){
				  return true;
			}
		}
		return false;
	}
	
	function initializeGIISS052(){
		setBtnAndFields(null);		
		objTyphoonZone = new Object();
		changeTag = 0;
		fieldFocus(null);
	}	
	
	$("btnSave").observe("click", function() {
		if(changeTag==1){			
			saveTyphoonZoneMaintenance(function(){				
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
	
	$("btnAddUpdate").observe("click", function() {		
		addUpdateTyphoonZone();
		changeTagFunc = saveTyphoonZoneMaintenance; // for logout confirmation	
	});
	
	$("btnDelete").observe("click", function() {	
		if(validateDeleteTyphoonZone()){
			deleteInTyphoonZone();	
			changeTagFunc = saveTyphoonZoneMaintenance; // for logout confirmation	
		}			
	});	
	
	$("imgSearchZoneGroup").observe("click", function() {
		showZoneGroupLOV();
	});
	
	$("txtZoneGroup").observe("change", function() {		
		if($("txtZoneGroup").value!=""&& $("txtZoneGroup").value != $("txtZoneGroup").readAttribute("lastValidValue")){						
			showZoneGroupLOV();			
		}else if($("txtZoneGroup").value==""){
			$("txtZoneGroupDesc").value="";	
		}					
	});	
	
	$("txtTyphoonZone").observe("change", function() {
		if(!RegExWholeNumber.pWholeNumber.test($("txtTyphoonZone").value)){
			$("txtTyphoonZone").clear();
			customShowMessageBox("Typhoon Zone must be a non-negative integer.", "I", "txtTyphoonZone");
			return;
		}		
		if($("txtTyphoonZone").value!=""&&$("txtTyphoonZone").value!=objTyphoonZone.typhoonZone){
			if(validateTyphoonZoneInput("Typhoon Zone",$("txtTyphoonZone").value)){
				Object.keys(objTyphoonZoneMain).forEach(function(i) {
				    if(objTyphoonZoneMain[i].typhoonZone==$("txtTyphoonZone").value){
				    	showWaitingMessageBox("Typhoon zone already exists.", "I", function() {
				    		$("txtTyphoonZone").value ="";
				   			$("txtTyphoonZone").focus();
						});		
					}
				});
			}
		}	
	});
	
	$("txtTyphoonZoneDesc").observe("change", function() {
		if($("txtTyphoonZoneDesc").value!=""&&$("txtTyphoonZoneDesc").value!=objTyphoonZone.typhoonZoneDesc){
			if(validateTyphoonZoneInput("Typhoon Zone Description",$("txtTyphoonZoneDesc").value)){
				Object.keys(objTyphoonZoneMain).forEach(function(i) {
				    if(objTyphoonZoneMain[i].typhoonZoneDesc==$("txtTyphoonZoneDesc").value){
				    	showWaitingMessageBox("Typhoon Zone Description already exists.", "I", function() {
				    		$("txtTyphoonZoneDesc").value ="";
				   			$("txtTyphoonZoneDesc").focus();
						});		
					}
				});
			}
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
		showTyphoonZoneMaintenance();
		});
	
	$("showHideTyphoonZone").observe("click", function() {
		showHideDiv("showBody","showHideTyphoonZone");
	});
	
	$("underwritingExit").observe("click", function() {
		chkChangesBfrAction(function(){
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main" , null); 
			changeTag = 0;
			changeTagFunc = "";
			});			
	});
	
	initializeGIISS052();	
} catch (e) {
	showErrorMessage("Error : ", e.message);
}
	
</script>