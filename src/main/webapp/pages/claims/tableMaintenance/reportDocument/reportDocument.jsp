<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="gicls180MainDiv" name="gicls180MainDiv" style="">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="menuFileMaintenanceExit">Exit</a></li>
				</ul>
			</div>
		</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Report Document Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="gicls180" name="gicls180">		
		<div class="sectionDiv">
			<div id="reportDocumentDiv" style="padding-top: 10px;">
				<div id="reportDocumentTable" style="height: 331px; margin-left: 115px;"></div>
			</div>
			<div align="center" id="reportDocumentFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Report No.</td>
						<td class="leftAligned" colspan="3">
							<input id="txtReportNo" type="text" style="width: 200px; text-align: right;" maxlength="5" readonly="readonly" tabindex="201"/>
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Report ID</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan required" style="float: left; width: 100px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required allCaps" type="text" id="txtReportId" name="txtReportId" style="width: 75px; float: left; border: none; height: 15px; margin: 0;" maxlength="12" tabindex="202" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgReportId" name="imgReportId" alt="Go" style="float: right;" tabindex="203"/>
							</span>
							<input type="text" id="txtReportName" style="height: 15px; width: 426px;" readonly="readonly" tabindex="204"/>
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Line</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan" style="float: left; width: 100px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input type="text" id="txtLineCd" name="txtLineCd" class="allCaps" style="width: 75px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="205" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgLineCd" name="imgLineCd" alt="Go" style="float: right;" tabindex="206"/>
							</span>
							<input type="text" id="txtLineName" style="height: 15px; width: 426px;" readonly="readonly" tabindex="207"/>
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Document</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan" style="float: left; width: 100px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input type="text" id="txtDocumentCd" name="txtDocumentCd" class="allCaps" style="width: 75px; float: left; border: none; height: 15px; margin: 0;" maxlength="5" tabindex="208" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgDocumentCd" name="imgDocumentCd" alt="Go" style="float: right;" tabindex="209"/>
							</span>
							<input type="text" id="txtDocumentName" style="height: 15px; width: 426px;" readonly="readonly" tabindex="210"/>
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Branch</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan" style="float: left; width: 100px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input type="text" id="txtBranchCd" name="txtBranchCd" class="allCaps" style="width: 75px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="211" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgBranchCd" name="imgBranchCd" alt="Go" style="float: right;" tabindex="212"/>
							</span>
							<input type="text" id="txtBranchName" style="height: 15px; width: 426px;" readonly="readonly" tabindex="213"/>
						</td>
					</tr>				
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="214"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="215"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="216"></td>
						<td width="110px;" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 203px;" readonly="readonly" tabindex="217"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;" align="center">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="218">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="219">
			</div>
			<div style="margin: 10px; border-top: 1px solid #E0E0E0;" align="center">
				<input type="button" class="button" id="btnRepSignatory" value="Maintain Report Signatory" style="margin-top: 10px;" tabindex="220">
			</div>
		</div>
	</div>
	<div class="buttonsDiv">
		<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="221">
		<input type="button" class="button" id="btnSave" value="Save" tabindex="222">
	</div>
</div>
<div id="repSignatoryDiv">

</div>
<script type="text/javascript">	
	setModuleId("GICLS180");
	setDocumentTitle("Report Document Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGicls180(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgReportDocument.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgReportDocument.geniisysRows);
		new Ajax.Request(contextPath+"/GICLReportDocumentController", {
			method: "POST",
			parameters : {action : "saveGICLS180",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGicls180.exitPage != null) {
							objGicls180.exitPage();
						} else {
							tbgReportDocument._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGICLS180);
	
	var objGicls180 = {};
	var objCurrReportDocument = null;
	objGicls180.reportDocumentList = JSON.parse('${jsonReportDocumentList}');
	objGicls180.exitPage = null;
	
	var reportDocumentTable = {
			url : contextPath + "/GICLReportDocumentController?action=showGICLS180&refresh=1&moduleId=GICLS180",
			id : 'repD',
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrReportDocument = tbgReportDocument.geniisysRows[y];
					setFieldValues(objCurrReportDocument);
					tbgReportDocument.keys.removeFocus(tbgReportDocument.keys._nCurrentFocus, true);
					tbgReportDocument.keys.releaseKeys();
					$("txtReportId").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgReportDocument.keys.removeFocus(tbgReportDocument.keys._nCurrentFocus, true);
					tbgReportDocument.keys.releaseKeys();
					$("txtReportId").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgReportDocument.keys.removeFocus(tbgReportDocument.keys._nCurrentFocus, true);
						tbgReportDocument.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
				},
				onSort: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgReportDocument.keys.removeFocus(tbgReportDocument.keys._nCurrentFocus, true);
					tbgReportDocument.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgReportDocument.keys.removeFocus(tbgReportDocument.keys._nCurrentFocus, true);
					tbgReportDocument.keys.releaseKeys();
				},				
				prePager: function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
					rowIndex = -1;
					setFieldValues(null);
					tbgReportDocument.keys.removeFocus(tbgReportDocument.keys._nCurrentFocus, true);
					tbgReportDocument.keys.releaseKeys();
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
				}
			},
			columnModel : [
				{ 								// this column will only use for deletion
				    id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
				    width: '0',				    
				    visible : false			
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},	
				{	id : 'reportNo',
					title : "Report No",
					align : 'right',
					width : '70px',
					filterOption : true,
					filterOptionType : 'integerNoNegative',
				},	
				{
					id : "reportId",
					title : "Report ID",
					width : '90px',
					filterOption : true
				},
				{
					id : 'reportName',
					title : 'Report Name',
					width : '280px',
					filterOption : true
				},			
				{
					id : 'lineCd',
					title : 'Line',
					width : '75px',
					filterOption : true
				},
				{
					id : 'documentCd',
					title : 'Document',
					width : '75px',
					filterOption : true
				},
				{
					id : 'branchCd',
					title : 'Branch',
					width : '75px',
					filterOption : true			
				}
			],
			rows : objGicls180.reportDocumentList.rows
		};

		tbgReportDocument = new MyTableGrid(reportDocumentTable);
		tbgReportDocument.pager = objGicls180.reportDocumentList;
		tbgReportDocument.render("reportDocumentTable");
	
	function setFieldValues(rec){
		try{
			$("txtReportId").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.reportId)));
			$("txtReportId").value = (rec == null ? "" : unescapeHTML2(rec.reportId));
			$("txtReportNo").value = (rec == null ? "" : rec.reportNo);
			$("txtReportName").value = (rec == null ? "" : unescapeHTML2(rec.reportName));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("txtLineCd").value = (rec == null ? "" : unescapeHTML2(rec.lineCd));
			$("txtLineName").value = (rec == null ? "" : unescapeHTML2(rec.lineName));
			$("txtBranchCd").value = (rec == null ? "" : unescapeHTML2(rec.branchCd));
			$("txtBranchName").value = (rec == null ? "" : unescapeHTML2(rec.branchName));
			$("txtDocumentCd").value = (rec == null ? "" : unescapeHTML2(rec.documentCd));
			$("txtDocumentName").value = (rec == null ? "" : unescapeHTML2(rec.documentName));
			
			objCLMGlobal.gicls180ReportNo = (rec == null ? "" : rec.reportNo);
			objCLMGlobal.gicls180ReportId = (rec == null ? "" : rec.reportId);
			objCLMGlobal.gicls180ReportName = (rec == null ? "" : unescapeHTML2(rec.reportName));
			objCLMGlobal.gicls180LineName = (rec == null ? "" : unescapeHTML2(rec.lineName));
			objCLMGlobal.gicls180BranchName = (rec == null ? "" : unescapeHTML2(rec.branchName));
			objCLMGlobal.gicls180DocumentName = (rec == null ? "" : unescapeHTML2(rec.documentName));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtReportId").readOnly = false : $("txtReportId").readOnly = true;
			rec == null ? enableSearch("imgReportId") : disableSearch("imgReportId");
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			rec == null ? $("txtLineCd").setAttribute("lastValidValue", "") : $("txtLineCd").setAttribute("lastValidValue", $F("txtLineCd"));
			rec == null ? $("txtDocumentCd").setAttribute("lastValidValue", "") : $("txtDocumentCd").setAttribute("lastValidValue", $F("txtDocumentCd"));
			rec == null ? $("txtBranchCd").setAttribute("lastValidValue", "") : $("txtBranchCd").setAttribute("lastValidValue", $F("txtBranchCd"));
			if(rec == null){
				disableButton("btnRepSignatory");
			}else{
				if(checkUserModule("GICLS181")){
					if(rec.branchName == null){
						enableButton("btnRepSignatory");	
					}else{
						if(rec.gicls181Iss == "1"){
							enableButton("btnRepSignatory");
						}else{
							disableButton("btnRepSignatory");
						}				
					}
				};
			}
			objCurrReportDocument = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.reportId = escapeHTML2($F("txtReportId"));
			obj.reportNo = $F("txtReportNo");
			obj.reportName = escapeHTML2($F("txtReportName"));
			obj.userId = userId;
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.lineCd = escapeHTML2($F("txtLineCd"));
			obj.lineName = escapeHTML2($F("txtLineName"));
			obj.branchCd = escapeHTML2($F("txtBranchCd"));
			obj.branchName = escapeHTML2($F("txtBranchName"));
			obj.documentCd = escapeHTML2($F("txtDocumentCd"));
			obj.documentName = escapeHTML2($F("txtDocumentName"));
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			if(checkAllRequiredFieldsInDiv("reportDocumentFormDiv")){
				changeTagFunc = saveGicls180;
				var dept = setRec(objCurrReportDocument);
				if($F("btnAdd") == "Add"){
					tbgReportDocument.addBottomRow(dept);
				} else {
					tbgReportDocument.updateVisibleRowOnly(dept, rowIndex, false);
				}
				changeTag = 1;
				setFieldValues(null);
				tbgReportDocument.keys.removeFocus(tbgReportDocument.keys._nCurrentFocus, true);
				tbgReportDocument.keys.releaseKeys();	
			}
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function deleteRec(){
		changeTagFunc = saveGicls180;
		objCurrReportDocument.recordStatus = -1;
		tbgReportDocument.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GICLReportDocumentController", {
				parameters : {action : "valDeleteRec",
							  reportId : $F("txtReportId")},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						deleteRec();
					}
				}
			});
		} catch(e){
			showErrorMessage("valDeleteRecc", e);
		}
	}
	
	function exitPage(){
		if(nvl(objAC.fromACMenu, 'N') == 'N'){ // added condition by robert SR 4953 10.28.15
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", null);
		}else{
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		}
	}	
	
	function cancelGicls180(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGicls180.exitPage = exitPage;
						saveGicls180();
					}, function(){
						if(nvl(objAC.fromACMenu, 'N') == 'N'){ // added condition by robert SR 4953 10.28.15
							goToModule("/GIISUserController?action=goToClaims", "Claims Main", null);
						}else{
							goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
						}
					}, "");
		} else {
			if(nvl(objAC.fromACMenu, 'N') == 'N'){ // added condition by robert SR 4953 10.28.15
				goToModule("/GIISUserController?action=goToClaims", "Claims Main", null);
			}else{
				goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
			}
		}
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	function showGICLS180ReportLOV(){
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getGICLS180ReportLOV",
							filterText : ($("txtReportId").readAttribute("lastValidValue").trim() != $F("txtReportId").trim() ? $F("txtReportId").trim() : ""),
							page : 1},
			title: "List of Reports",
			width: 500,
			height: 400,
			columnModel : [ {
								id: "reportId",
								title: "Report ID",
								width : '100px',
							}, {
								id : "reportTitle",
								title : "Report Title",
								width : '360px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							} ],
				autoSelectOneRecord: true,
				filterText : ($("txtReportId").readAttribute("lastValidValue").trim() != $F("txtReportId").trim() ? $F("txtReportId").trim() : ""),
				onSelect: function(row) {
					$("txtReportId").value = unescapeHTML2(row.reportId);
					$("txtReportName").value = unescapeHTML2(row.reportTitle);
					$("txtReportId").setAttribute("lastValidValue", unescapeHTML2(row.reportId));
				},
				onCancel: function (){
					$("txtReportId").value = $("txtReportId").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtReportId").value = $("txtReportId").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	$("imgReportId").observe("click", showGICLS180ReportLOV);
	$("txtReportId").observe("change", function() {
		if($F("txtReportId").trim() == "") {
			$("txtReportId").value = "";
			$("txtReportId").setAttribute("lastValidValue", "");
			$("txtReportName").value = "";
		} else {
			if($F("txtReportId").trim() != "" && $F("txtReportId") != $("txtReportId").readAttribute("lastValidValue")) {
				showGICLS180ReportLOV();
			}
		}
	});
	
	function showGICLS180LineLOV(){
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getGICLS180LineLOV",
							moduleId : "GICLS180",
							filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
							page : 1},
			title: "List of Lines",
			width: 500,
			height: 400,
			columnModel : [ {
								id: "lineCd",
								title: "Line Code",
								width : '100px',
							}, {
								id : "lineName",
								title : "Line Name",
								width : '360px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							} ],
				autoSelectOneRecord: true,
				filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
				onSelect: function(row) {
					$("txtLineCd").value = row.lineCd;
					$("txtLineName").value = unescapeHTML2(row.lineName);
					$("txtLineCd").setAttribute("lastValidValue", row.lineCd);
				},
				onCancel: function (){
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	$("imgLineCd").observe("click", showGICLS180LineLOV);
	$("txtLineCd").observe("change", function() {
		if($F("txtLineCd").trim() == "") {
			$("txtLineCd").value = "";
			$("txtLineCd").setAttribute("lastValidValue", "");
			$("txtLineName").value = "";
		} else {
			if($F("txtLineCd").trim() != "" && $F("txtLineCd") != $("txtLineCd").readAttribute("lastValidValue")) {
				showGICLS180LineLOV();
			}
		}
	});
	
	function showGICLS180DocumentLOV(){
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getGICLS180DocumentLOV",
							filterText : ($("txtDocumentCd").readAttribute("lastValidValue").trim() != $F("txtDocumentCd").trim() ? $F("txtDocumentCd").trim() : ""),
							page : 1},
			title: "List of Documents",
			width: 500,
			height: 400,
			columnModel : [ {
								id: "documentCd",
								title: "Document Code",
								width : '100px',
							}, {
								id : "documentName",
								title : "Document Name",
								width : '360px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							} ],
				autoSelectOneRecord: true,
				filterText : ($("txtDocumentCd").readAttribute("lastValidValue").trim() != $F("txtDocumentCd").trim() ? $F("txtDocumentCd").trim() : ""),
				onSelect: function(row) {
					$("txtDocumentCd").value = unescapeHTML2(row.documentCd);
					$("txtDocumentName").value = unescapeHTML2(row.documentName);
					$("txtDocumentCd").setAttribute("lastValidValue", unescapeHTML2(row.documentCd));
				},
				onCancel: function (){
					$("txtDocumentCd").value = $("txtDocumentCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtDocumentCd").value = $("txtDocumentCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	$("imgDocumentCd").observe("click", showGICLS180DocumentLOV);
	$("txtDocumentCd").observe("change", function() {
		if($F("txtDocumentCd").trim() == "") {
			$("txtDocumentCd").value = "";
			$("txtDocumentCd").setAttribute("lastValidValue", "");
			$("txtDocumentName").value = "";
		} else {
			if($F("txtDocumentCd").trim() != "" && $F("txtDocumentCd") != $("txtDocumentCd").readAttribute("lastValidValue")) {
				showGICLS180DocumentLOV();
			}
		}
	});
	
	function showGICLS180BranchLOV(){
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getGICLS180BranchLOV",
							moduleId : "GICLS180",
							filterText : ($("txtBranchCd").readAttribute("lastValidValue").trim() != $F("txtBranchCd").trim() ? $F("txtBranchCd").trim() : ""),
							page : 1},
			title: "List of Branches",
			width: 500,
			height: 400,
			columnModel : [ {
								id: "branchCd",
								title: "Branch Code",
								width : '100px',
							}, {
								id : "branchName",
								title : "Branch Name",
								width : '360px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							} ],
				autoSelectOneRecord: true,
				filterText : ($("txtBranchCd").readAttribute("lastValidValue").trim() != $F("txtBranchCd").trim() ? $F("txtBranchCd").trim() : ""),
				onSelect: function(row) {
					$("txtBranchCd").value = row.branchCd;
					$("txtBranchName").value = unescapeHTML2(row.branchName);
					$("txtBranchCd").setAttribute("lastValidValue", row.branchCd);
				},
				onCancel: function (){
					$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	$("imgBranchCd").observe("click", showGICLS180BranchLOV);
	$("txtBranchCd").observe("change", function() {
		if($F("txtBranchCd").trim() == "") {
			$("txtBranchCd").value = "";
			$("txtBranchCd").setAttribute("lastValidValue", "");
			$("txtBranchName").value = "";
		} else {
			if($F("txtBranchCd").trim() != "" && $F("txtBranchCd") != $("txtBranchCd").readAttribute("lastValidValue")) {
				showGICLS180BranchLOV();
			}
		}
	});
	
	$("btnRepSignatory").observe("click", function(){
		if(changeTag == 1){
			customShowMessageBox(objCommonMessage.SAVE_CHANGES, "I", "btnSave");		
		}else{
			objCLMGlobal.callingForm = "GICLS180";
			$("repSignatoryDiv").show();
			$("gicls180MainDiv").hide();
			showGicls181();	
		}
	});
	
	disableButton("btnRepSignatory");
	disableButton("btnDelete");
	observeSaveForm("btnSave", saveGicls180);
	$("btnCancel").observe("click", cancelGicls180);
	$("btnAdd").observe("click", addRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("menuFileMaintenanceExit").stopObserving("click");
	$("menuFileMaintenanceExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtReportId").focus();	
</script>