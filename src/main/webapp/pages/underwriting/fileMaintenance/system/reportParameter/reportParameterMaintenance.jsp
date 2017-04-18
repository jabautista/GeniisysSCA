<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="reportParameterMaintenance" name="reportParameterMaintenance" style="float: left; width: 100%;">
	<div id="reportParameterMaintenanceExitDiv">
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
			<label>Report Parameter Maintenance</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="showHideReportParameter" name="gro" style="margin-left: 5px;">Hide</label> 
			 	<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>
	<div id="showBody">	
		<div class="sectionDiv" id="showLineDiv">
			<div style="padding:10px;" align="center">
				<div id="reportParameterMainTableGrid" style="height: 331px;width:900px;"></div>
			</div>	
			<div>	
				<div align="center">
					<table>
						<tr>
							<td align="right">Parameter</td>
							<td><input class="required" id="txtParameter" type="text" style="width:300px"></td>
						</tr>	
						<tr>
							<td align="right">Text</td>
							<td colspan="3">
								<span class="lovSpan" style="width: 676px; margin: 0">
										<input
										style="width: 650px; float: left; height: 14px; border: none; margin:0"
										type="text" id="txtText" /> 
										<img
										src="${pageContext.request.contextPath}/images/misc/edit.png"
										id="imgEditText" alt="Go" style="float: right; margin-top: 2px;" />
								</span>
							</td>						
						</tr>
						<tr>
							<td align="right">Line</td>
							<td><span class="lovSpan" style="width: 306px; margin-top:2px">
									<input class="" id="txtLine" type="text" style="width:280px;margin: 0; height: 14px;border: 0"><img
									src="${pageContext.request.contextPath}/images/misc/searchIcon.png"
									id="imgSearchLine" alt="Go" style="float: right; margin-top: 2px;" />
								</span>	
							</td>
							<td style="width:100px" align="right">Report Id</td>
							<td><span class="lovSpan required" style="width: 260px; margin-top:2px">
									<input class="required" id="txtReportId" type="text" style="width:233px;margin: 0;height: 14px;border: 0"><img
									src="${pageContext.request.contextPath}/images/misc/searchIcon.png"
									id="imgSearchReportId" alt="Go" style="float: right; margin-top: 2px;" />
								</span>	
							</td>
						</tr>
						<tr>
							<td align="right">Remarks</td>
							<td colspan="3">
								<span class="lovSpan" style="width: 676px; margin: 0">
										<input
										style="width: 650px; float: left; height: 14px; border: none; margin:0"
										type="text" id="txtRemarks" /> 
										<img
										src="${pageContext.request.contextPath}/images/misc/edit.png"
										id="imgEditRemarks" alt="Go" style="float: right; margin-top: 2px;" />
								</span>
							</td>
						</tr>
						<tr>
							<td align="right">User ID</td>
							<td><input id="txtUserId" type="text" style="width:300px" readonly="readonly"></td>
							<td style="width:100px" align="right">Last Update</td>
							<td><input id="txtLastUpdate" type="text"  style="width:254px" readonly="readonly"></td>
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
	<div class="sectionDiv" style="border: 0; margin-bottom: 200px;margin-top: 15px" align="center">
		<div>
			<input type="button" id="btnCancel" value="Cancel">
			<input type="button" id="btnSave" value="Save">
		</div>
	</div>
</div>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/underwriting/underwriting.js">
try {
	setModuleId("GIISS119");
	setDocumentTitle("Report Parameter Maintenance");
	var row;
	var objReportParameterMain = [];
	var jsonReportParameter = JSON.parse('${jsonReportParameter}');
	reportParameterTableModel = {
		url : contextPath
				+ "/GIISReportParameterController?action=getReportParameterList&refresh=1",
		options : {
			width : '900px',
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
					tbgReportParameter.keys.removeFocus(
							tbgReportParameter.keys._nCurrentFocus, true);
					tbgReportParameter.keys.releaseKeys();	
					setReportParameterDtls(null);
					setBtnAndFields(null);
					setObjReportParam(null);
					fieldFocus(null);
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}								
			},
			onCellFocus : function(element, value, x, y, id) {						
				tbgReportParameter.keys.removeFocus(
						tbgReportParameter.keys._nCurrentFocus, true);
				tbgReportParameter.keys.releaseKeys();		
				setReportParameterDtls(tbgReportParameter.geniisysRows[y]);
				setBtnAndFields(tbgReportParameter.geniisysRows[y]);
				setObjReportParam(tbgReportParameter.geniisysRows[y]);
				fieldFocus(tbgReportParameter.geniisysRows[y]);
				row = y;
			},
			onRemoveRowFocus : function(element, value, x, y, id) {	
				tbgReportParameter.keys.removeFocus(
						tbgReportParameter.keys._nCurrentFocus, true);
				tbgReportParameter.keys.releaseKeys();	
				setReportParameterDtls(null);
				setBtnAndFields(null);
				setObjReportParam(null);
				fieldFocus(null);
			},
			beforeSort : function() {			
				if(changeTag==0){
					tbgReportParameter.keys.removeFocus(
							tbgReportParameter.keys._nCurrentFocus, true);
					tbgReportParameter.keys.releaseKeys();		
					setReportParameterDtls(null);
					setBtnAndFields(null);
					setObjReportParam(null);
					fieldFocus(null);
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}					
			},
			onSort : function() {				
				tbgReportParameter.keys.removeFocus(
						tbgReportParameter.keys._nCurrentFocus, true);
				tbgReportParameter.keys.releaseKeys();		
				setReportParameterDtls(null);
				setBtnAndFields(null);
				setObjReportParam(null);
				fieldFocus(null);
			},
			onRefresh : function() {				
				tbgReportParameter.keys.removeFocus(
						tbgReportParameter.keys._nCurrentFocus, true);
				tbgReportParameter.keys.releaseKeys();	
				setReportParameterDtls(null);
				setBtnAndFields(null);
				setObjReportParam(null);
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
			id : "title",
			title : "Parameter",
			width : '200px',
			align : "left",
			titleAlign : "left",
			filterOption : true,
			renderer: function(value){
				return unescapeHTML2(value);	
			}			
		},{
			id : "text",
			title : "Text",
			width : '468px',
			align : "left",
			titleAlign : "left",
			filterOption : true,
			renderer: function(value){
				return unescapeHTML2(value);	
			}
		},{
			id : "lineCd",
			title : "Line",
			width : '80px',
			align : "left",
			titleAlign : "left",
			filterOption : true,
			renderer: function(value){
				return unescapeHTML2(value);	
			}
		},{
			id : "reportId",
			title : "Report Id",
			width : '120px',
			align : "left",
			titleAlign : "left",
			filterOption : true,
			renderer: function(value){
				return unescapeHTML2(value);	
			}
		}],
		rows : jsonReportParameter.rows
	};

	tbgReportParameter = new MyTableGrid(reportParameterTableModel);
	tbgReportParameter.pager = jsonReportParameter;
	tbgReportParameter.render('reportParameterMainTableGrid');
	tbgReportParameter.afterRender = function(){
		objReportParameterMain = tbgReportParameter.geniisysRows;
		changeTag = 0;
	};
	
	function showLineLOV() {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getGIISS119LineLov",
				searchString : ($("txtLine").readAttribute("lastValidValue") != $F("txtLine") ? nvl($F("txtLine"),"%") : "%"),
				//searchString : $F("txtLine")==""?"%":$F("txtLine"),
				page : 1,				
			},
			title : "Line",
			width : 400,
			height : 386,
			columnModel : [ {
				id : "lineCd",
				title : "Line Cd",
				width : '374px',
			} ],
			draggable : true,
			autoSelectOneRecord : true,
			filterText :$("txtLine").value,
			onSelect : function(row) {
				$("txtLine").value = unescapeHTML2(row.lineCd);	
				objReportParam.lineCd = row.lineCd;					
				$("txtLine").setAttribute("lastValidValue", row.lineCd);
			},
			onCancel : function() {
				$("txtLine").value = $("txtLine").readAttribute("lastValidValue");
			},
			onUndefinedRow : function() {
				customShowMessageBox("No record selected.", imgMessage.INFO,
						"txtLine");
				$("txtLine").value = "";	
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();
			}
		});
	}	
	
	function showReportIdLOV() {
		LOV.show({
			controller : "UnderwritingLOVController",			
			urlParameters : {
				action : "getGIISSReportIdLOV",
				searchString : ($("txtReportId").readAttribute("lastValidValue") != $F("txtReportId") ? nvl($F("txtReportId"),"%") : "%"),
				//searchString : $F("txtReportId")==""?"%":$F("txtReportId"),				
				page : 1,				
			},
			title : "Report ID",
			width : 400,
			height : 386,
			columnModel : [ {
				id : "reportId",
				title : "Report Id",
				width : '374px',
			} ],
			draggable : true,
			autoSelectOneRecord : true,
			filterText : $("txtReportId").value,
			onSelect : function(row) {
				$("txtReportId").value = unescapeHTML2(row.reportId);	
				objReportParam.reportId = row.reportId;
				$("txtReportId").setAttribute("lastValidValue", row.reportId);
			},
			onCancel : function() {
				$("txtReportId").value = $("txtReportId").readAttribute("lastValidValue");
			},
			onUndefinedRow : function() {
				customShowMessageBox("No record selected.", imgMessage.INFO,
						"txtReportId");
				$("txtReportId").value = "";
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();
			}
		});
	}		
	
	function setObjReportParam(obj) {
		try {		
			objReportParam.title = obj == null ? "" : (obj.title==null?"":obj.title);
			objReportParam.text = obj == null ? "" : (obj.text==null?"":obj.text);
			objReportParam.lineCd = obj == null ? "" : (obj.lineCd==null?"":obj.lineCd);
			objReportParam.remarks = obj == null ? "" : (obj.remarks==null?"":obj.remarks);
			objReportParam.userId = obj == null ? "" : (obj.userId==null?"":obj.userId);
			objReportParam.lastUpdate = obj == null ? "" : (obj.lastUpdate==null?"":obj.lastUpdate);	
			objReportParam.reportId = obj == null ? "" : (obj.reportId==null?"":obj.reportId);
			objReportParam.cpiBranchCd = obj == null ? "" : (obj.cpiBranchCd==null?"":obj.cpiBranchCd);
			objReportParam.cpiRecNo = obj == null ? "" : (obj.cpiRecNo==null?"":obj.cpiRecNo);	
		} catch (e) {
			showErrorMessage("setObjReportParam", e);
		}
	}
	
	function setRowObjReportParam(func){
		try {					
			var rowObjReportParam = new Object();
			rowObjReportParam.title = $("txtParameter").value;	
			rowObjReportParam.text = $("txtText").value;		
			rowObjReportParam.lineCd =  $("txtLine").value;				
			rowObjReportParam.remarks = $("txtRemarks").value;
			rowObjReportParam.userId = $("txtUserId").value;
			rowObjReportParam.lastUpdate = $("txtLastUpdate").value;
			rowObjReportParam.reportId = $("txtReportId").value;		
			rowObjReportParam.cpiBranchCd = objReportParam.cpiBranchCd;	
			rowObjReportParam.cpiRecNo = objReportParam.cpiRecNo;	
			rowObjReportParam.recordStatus 	= func == "Delete" ? -1 : func == "Add" ? 0 : 1;
			return rowObjReportParam;
		} catch (e) {
			showErrorMessage("setRowObjReportParam", e);
		}
	}		
	
	function addUpdateReportParameter(){
		rowObj  = setRowObjReportParam($("btnAddUpdate").value);
		if(chkRequiredFields()){
			if($("btnAddUpdate").value=="Update"){
				objReportParameterMain.splice(row, 1, rowObj);
				tbgReportParameter.updateVisibleRowOnly(rowObj, row);
				tbgReportParameter.onRemoveRowFocus();
				changeTag=1;
			}else if ($("btnAddUpdate").value=="Add"){
				objReportParameterMain.push(rowObj);
				tbgReportParameter.addBottomRow(rowObj);
				tbgReportParameter.onRemoveRowFocus();
				changeTag = 1;		
			}
		}
	}
	
	function deleteReportParameter(){ 
		delObj = setRowObjReportParam($("btnDelete").value);
		objReportParameterMain.splice(row, 1, delObj);
		tbgReportParameter.deleteVisibleRowOnly(row);
		changeTag = 1;
		setReportParameterDtls(null);				
	}
	
	function chkRequiredFields(){	
		if($("txtParameter").value == ""){
			customShowMessageBox("Required fields must be entered.", imgMessage.ERROR,"txtParameter");
			objReportParam.saveResult = false;			
			return false;
		/*}else if($("txtLine").value == ""){	commented out by Gzelle 01212015 SR3869
			customShowMessageBox("Required fields must be entered.", imgMessage.ERROR,"txtLine");
			objReportParam.saveResult = false;		
			return false;*/
		}else if($("txtReportId").value == ""){
			customShowMessageBox("Required fields must be entered.", imgMessage.ERROR,"txtReportId");
			objReportParam.saveResult = false;		
			return false;
		}else{
			return true;
		}
	}
	
	function setReportParameterDtls(obj) {		
		try {
			$("txtParameter").value = obj == null ? "" : unescapeHTML2(obj.title);
			$("txtText").value = obj == null ? "" : unescapeHTML2(obj.text);
			$("txtLine").value = obj == null ? "" : unescapeHTML2(obj.lineCd);
			$("txtReportId").value = obj == null ? "" : unescapeHTML2(obj.reportId);
			$("txtRemarks").value = obj == null ? "" : unescapeHTML2(obj.remarks);	
			$("txtUserId").value = obj == null ? "" : obj.userId;
			$("txtLastUpdate").value = obj == null ? "" : obj.lastUpdate;
			$("txtLine").setAttribute("lastValidValue", obj == null ? "" : nvl(obj.lineCd,""));
			$("txtReportId").setAttribute("lastValidValue", obj == null ? "" : obj.reportId);
		} catch (e) {
			showErrorMessage("setPayeeDetails", e);
		}
	}	
	
	function setBtnAndFields(obj) {
		if (obj != null) {	
			enableButton("btnDelete");	
			$("btnAddUpdate").value = "Update";
			$("txtParameter").readOnly = "readonly"; 			
			$("txtReportId").readOnly = "readonly";
			disableSearch("imgSearchReportId");
		}else{
			disableButton("btnDelete");	
			$("btnAddUpdate").value = "Add";
			$("txtParameter").readOnly = false; 		
			$("txtReportId").readOnly = false;
			enableButton("btnAddUpdate");
			enableButton("btnCancel");
			enableButton("btnSave");
			enableSearch("imgSearchReportId");
		}
	}	
	
	function disableImg(imgId){
		try {
			if($(imgId).next("img",0) == undefined){
				var alt = new Element("img");
				alt.alt = 'Go';
				if(imgId=="imgSearchReportId"){
					alt.src = contextPath + "/images/misc/searchIcon.png";
					alt.setAttribute("style", "height:17px;width:18px;");
				}		
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
	
	function saveReportParameter(){
		try{	
			var objParams = new Object(); 
			objParams.setRows = getAddedAndModifiedJSONObjects(objReportParameterMain);
			objParams.delRows = getDeletedJSONObjects(objReportParameterMain);
			new Ajax.Request(contextPath + "/GIISReportParameterController", {
				method : "POST",
				parameters : {
					action : "saveReportParameter",
					parameters : JSON.stringify(objParams)				
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : function(){
					showNotice("Saving Report Parameter Maintenance, please wait ...");
				},
				onComplete : function(response) {
					hideNotice();
					var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
					if (checkErrorOnResponse(response)){
						if (res.message != "SUCCESS"){
							showMessageBox(res.message, imgMessage.ERROR);	
							objReportParam.saveResult = false;
						}else{
							showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);		
							objReportParam.saveResult = true;
							changeTag = 0;	
							changeTagFunc = "";	
						}
					}
				}
			});				
		}catch(e){
			showErrorMessage("saveReportParameter", e);
		}
	}
		
	function chkChangesBfrExit(func){	
		if(changeTag==0){
			func();
		}else{
			 showConfirmBox4("Confirmation",objCommonMessage.WITH_CHANGES ,"Yes","No","Cancel",
				function(){
				 	saveReportParameter();
					 if(objReportParam.saveResult){
						 func(); 						 
					 }					 	
				 },function(){
					 func();					
					 },"",1);
				 
		}
	}
	
	function actionOnCancel(){	
		if(changeTag==0){
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main" , null); 			
		}else{
			tbgReportParameter._refreshList();		
			tbgReportParameter.keys.removeFocus(
					tbgReportParameter.keys._nCurrentFocus, true);
			tbgReportParameter.keys.releaseKeys();
		}	
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
	
	function initializeGIISS119(){
		setBtnAndFields(null);		
		objReportParam = new Object();
		changeTag = 0;
		fieldFocus(null);
	}
	
	function fieldFocus(obj){
		if(obj==null){
			$("txtParameter").focus();			
		}else{
			$("txtText").focus();
		}
	}
	
	$("btnSave").observe("click", function() {
		if(changeTag==1){			
			saveReportParameter();
			if(objReportParam.saveResult){	
				tbgReportParameter._refreshList();	
				changeTag=0;				
				changeTagFunc = "";
			}			
		}else{
			showMessageBox(objCommonMessage.NO_CHANGES, imgMessage.INFO);
		}		
	});
	
	$("btnCancel").observe("click", function() {
		chkChangesBfrExit(function(){
			actionOnCancel();
			changeTag = 0;
			changeTagFunc = "";
			});	
	});
	
	$("btnAddUpdate").observe("click", function() {
		addUpdateReportParameter();
		changeTagFunc = saveReportParameter; // for logout confirmation
	});
	
	$("btnDelete").observe("click", function(){
		deleteReportParameter();
		changeTagFunc = saveReportParameter; // for logout confirmation
	});
	
	$("imgEditText").observe("click", function(){
		showOverlayEditor("txtText", 500);
	});	
	
	$("imgEditRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 500);
	});	
	
	$("imgSearchLine").observe("click", function() {
		showLineLOV();
	});
	
	$("imgSearchReportId").observe("click", function() {
		showReportIdLOV();
	});
	
	$("txtParameter").observe("keyup", function(){
		$("txtParameter").value = $F("txtParameter").toUpperCase();
	});
	
	$("txtLine").observe("keyup", function(){
		$("txtLine").value = $F("txtLine").toUpperCase();
	});
	
	$("txtReportId").observe("keyup", function(){
		$("txtReportId").value = $F("txtReportId").toUpperCase();
	});
	
	$("txtLine").observe("blur", function() {
		if($("txtLine").value!=""&& $("txtLine").value != $("txtLine").readAttribute("lastValidValue")){
			showLineLOV();
		}else if($F("txtLine").trim() == "") {
			$("txtLine").setAttribute("lastValidValue", "");
		}
	});
	
	$("txtReportId").observe("blur", function() {
		if($("txtReportId").value!=""&& $("txtReportId").value != $("txtReportId").readAttribute("lastValidValue")){
			showReportIdLOV();
		}else if($F("txtReportId").trim() == "") {
			$("txtReportId").setAttribute("lastValidValue", "");
		}		
	});
	
	observeReloadForm("reloadForm", showReportParameterMaintenance);
			
	$("showHideReportParameter").observe("click", function() {
		showHideDiv("showBody","showHideReportParameter");
	});
	
	$("underwritingExit").observe("click", function() {
		chkChangesBfrExit(function(){
			changeTag = 0;
			changeTagFunc = "";
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main" , null); 
			});			
	});
	
	initializeGIISS119();	
} catch (e) {
	showErrorMessage("Error : ", e.message);
}
	
</script>

