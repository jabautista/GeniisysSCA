<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="giiss054MainDiv" name="typhoonZoneMaintenance" style="float: left; width: 100%;">
	<div id="tariffZoneExitDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="uwExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Tariff Zone Maintenance</label>
			<span class="refreshers" style="margin-top: 0;">
			 	<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>
	<div id="giiss054" name="giiss054">		
		<div class="sectionDiv">
			<div id="tariffZoneTableDiv" style="padding-top: 10px;">
				<div id="tariffZoneTable" style="height: 340px; margin-left: 10px;"></div>
			</div>
			<div style="margin: 10px 0 0 70px" id="tariffZoneFormDiv">
				<table>	
					<tr>
						<td align="right">Tariff Zone</td>						
						<td style="width:150px">
							<input id="txtTariffZone" maxlength="2" type="text" style="width:150px;margin-top:0" class="required rightAligned">
						</td>
						<td></td>
					</tr>
					<tr>
						<td align="right">Tariff Zone Description</td>
						<td colspan="3">								
							<input id="txtTariffZoneDesc" maxlength="500" type="text" style="width:552px;margin-top:0" class="required"/> 
						</td>
					</tr>
					<tr>
						<td align="right">Line</td>						
						<td style="width:150px"><span class="lovSpan" style="width: 156px; height:19px;margin-top:0">
								<input id="txtLineCd" maxlength="2" type="text" style="width:131px;margin: 0;height: 13px;border: 0" class="required"><img
								src="${pageContext.request.contextPath}/images/misc/searchIcon.png"
								id="imgSearchLine" alt="Go" style="float: right; margin-top: 2px;" class="required"/>
							</span>	
						</td>
						<td colspan="2">
							<input id="txtLineName" readonly="readonly" type="text" style="width:390px;margin-top:0">
						</td>
					</tr>	
					<tr>
						<td align="right">Subline</td>						
						<td style="width:150px"><span class="lovSpan" style="width: 156px; height:19px;margin-top:0">
								<input id="txtSublineCd" maxlength="7" type="text" style="width:129px;margin: 0;height: 13px;border: 0"><img
								src="${pageContext.request.contextPath}/images/misc/searchIcon.png"
								id="imgSearchSubline" alt="Go" style="float: right; margin-top: 2px;" />
							</span>	
						</td>
						<td colspan="2"><input id="txtSublineName" readonly="readonly" type="text" style="width:390px;margin-top:0"></td>
					</tr>					
					<tr>
						<td align="right">Tariff Code and Description</td>						
						<td style="width:150px"><span class="lovSpan" style="width: 156px;height:19px;margin-top:0">
								<input id="txtTarfCd" maxlength="12" type="text" style="width:129px;margin: 0;height: 13px;border: 0"><img
								src="${pageContext.request.contextPath}/images/misc/searchIcon.png"
								id="imgSearchTarf" alt="Go" style="float: right; margin-top: 2px;" />
							</span>	
						</td>
						<td colspan="2"><input id="txtTarfDesc" readonly="readonly" type="text" style="width:390px;margin-top:0"></td>
					</tr>														
					<tr>
						<td align="right">Remarks</td>
						<td colspan="3">
							<div style="border: 1px solid gray; height: 21px; width: 558px">
								<textarea id="txtRemarks" name="txtRemarks" style="border: none; height: 13px; resize: none; width: 532px" maxlength="4000"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; padding: 3px; float: right;" alt="EditRemark" id="editRemarks"/>
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
			<div style="margin: 10px;" align="center">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="208">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="209">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="210">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="211">
</div>
<script type="text/javascript">	
	setModuleId("GIISS054");
	setDocumentTitle("Tariff Zone Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiiss054(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgTariffZone.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgTariffZone.geniisysRows);
		new Ajax.Request(contextPath+"/GIISTariffZoneController", {
			method: "POST",
			parameters : {action : "saveGiiss054",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS054.exitPage != null) {
							objGIISS054.exitPage();
						} else {
							tbgTariffZone._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss054);
	
	var objGIISS054 = {};
	var objCurrTariffZone = null;
	objGIISS054.tariffZoneList = JSON.parse('${jsonTariffZoneList}');
	objGIISS054.checkGiiss054UserAccess = '${checkGiiss054UserAccess}';
	objGIISS054.exitPage = null;
	
	var tariffZoneTable = {
			url : contextPath + "/GIISTariffZoneController?action=showGiiss054&refresh=1",
			options : {
				width : '900px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrTariffZone = tbgTariffZone.geniisysRows[y];
					setFieldValues(objCurrTariffZone);
					tbgTariffZone.keys.removeFocus(tbgTariffZone.keys._nCurrentFocus, true);
					tbgTariffZone.keys.releaseKeys();					
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgTariffZone.keys.removeFocus(tbgTariffZone.keys._nCurrentFocus, true);
					tbgTariffZone.keys.releaseKeys();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgTariffZone.keys.removeFocus(tbgTariffZone.keys._nCurrentFocus, true);
						tbgTariffZone.keys.releaseKeys();
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
					tbgTariffZone.keys.removeFocus(tbgTariffZone.keys._nCurrentFocus, true);
					tbgTariffZone.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgTariffZone.keys.removeFocus(tbgTariffZone.keys._nCurrentFocus, true);
					tbgTariffZone.keys.releaseKeys();
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
					tbgTariffZone.keys.removeFocus(tbgTariffZone.keys._nCurrentFocus, true);
					tbgTariffZone.keys.releaseKeys();
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
				    id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
				    width: '0',				    
				    visible : false			
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},	
				{
					id : "lineCd",
					title : "Line Code",
					width : '120px',
					align : "left",
					titleAlign : "left",
					filterOption : true,
				},{
					id : "sublineCd",
					title : "Subline Code",			
					width : '120px',
					align : "left",
					titleAlign : "left",
					filterOption : true			
				},{
					id : "tariffZone",
					title : "Tariff Zone",			
					width : '120px',
					align : "right",
					titleAlign : "right",
					filterOption : true,
					filterOptionType : 'integerNoNegative'
				},{
					id : "tariffZoneDesc",
					title : "Tariff Zone Description",			
					width : '500px',
					align : "left",
					titleAlign : "left",
					filterOption : true			
				},{
					id : 'remarks',
					width : '0',
					visible: false				
				},
				{
					id : 'userId',
					width : '0',
					visible: false
				},
				{
					id : 'lastUpdate',
					width : '0',
					visible: false				
				}
			],
			rows : objGIISS054.tariffZoneList.rows
		};

		tbgTariffZone = new MyTableGrid(tariffZoneTable);
		tbgTariffZone.pager = objGIISS054.tariffZoneList;
		tbgTariffZone.render("tariffZoneTable");
	
	function setFieldValues(rec){
		try{
			$("txtTariffZone").value = (rec == null ? "" : unescapeHTML2(rec.tariffZone));
			$("txtTariffZoneDesc").value = (rec == null ? "" : unescapeHTML2(rec.tariffZoneDesc));		
			$("txtLineCd").value = (rec == null ? "" : unescapeHTML2(rec.lineCd));		
			$("txtLineName").value = (rec == null ? "" : unescapeHTML2(rec.lineName));		
			$("txtSublineCd").value = (rec == null ? "" : unescapeHTML2(rec.sublineCd));
			$("txtSublineName").value = (rec == null ? "" : unescapeHTML2(rec.sublineName));
			$("txtTarfCd").value = (rec == null ? "" : unescapeHTML2(rec.tariffCd));
			$("txtTarfDesc").value = (rec == null ? "" : unescapeHTML2(rec.tarfDesc));
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtLineCd").setAttribute("lastValidValue", (rec == null ? "" : rec.lineCd));
			$("txtLineName").setAttribute("lastValidValue", (rec == null ? "" : rec.lineName));
			$("txtSublineCd").setAttribute("lastValidValue", (rec == null ? "" : nvl(rec.sublineCd, "")));
			$("txtSublineName").setAttribute("lastValidValue", (rec == null ? "" : nvl(rec.sublineName, "")));
			$("txtTarfCd").setAttribute("lastValidValue", (rec == null ? "" : nvl(rec.tariffCd, "")));
			$("txtTarfDesc").setAttribute("lastValidValue", (rec == null ? "" : nvl(rec.tarfDesc, "")));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtTariffZone").readOnly = false : $("txtTariffZone").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			rec == null ? $("txtTariffZone").focus() : $("txtTariffZoneDesc").focus();
			objCurrTariffZone = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.tariffZone = escapeHTML2($F("txtTariffZone"));
			obj.tariffZoneDesc = escapeHTML2($F("txtTariffZoneDesc"));
			obj.lineCd = escapeHTML2($F("txtLineCd"));
			obj.lineName = escapeHTML2($F("txtLineName"));
			obj.sublineCd = escapeHTML2($F("txtSublineCd"));
			obj.sublineName = escapeHTML2($F("txtSublineName"));
			obj.tariffCd = escapeHTML2($F("txtTarfCd"));
			obj.tarfDesc = escapeHTML2($F("txtTarfDesc"));
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGiiss054;
			var dept = setRec(objCurrTariffZone);
			if($F("btnAdd") == "Add"){
				tbgTariffZone.addBottomRow(dept);
			} else {
				tbgTariffZone.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgTariffZone.keys.removeFocus(tbgTariffZone.keys._nCurrentFocus, true);
			tbgTariffZone.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}				
	
	function valAddRec() {
		try {
			if (checkAllRequiredFieldsInDiv("tariffZoneFormDiv")) {
				if ($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;
					for ( var i = 0; i < tbgTariffZone.geniisysRows.length; i++) {
						if (tbgTariffZone.geniisysRows[i].recordStatus == 0
								|| tbgTariffZone.geniisysRows[i].recordStatus == 1) {
							if (tbgTariffZone.geniisysRows[i].tariffZone == $F("txtTariffZone")) {
								addedSameExists = true;
							}					
						} else if (tbgTariffZone.geniisysRows[i].recordStatus == -1) {
							if (tbgTariffZone.geniisysRows[i].tariffZone == $F("txtTariffZone")) {
								deletedSameExists = true;
							}
						}
					}
					if ((addedSameExists && !deletedSameExists)
							|| (deletedSameExists && addedSameExists)) {
						showMessageBox(
								"Record already exists with the same tariff_zone.",
								"E");
						return;
					} else if (deletedSameExists && !addedSameExists) {
						addRec();
						return;
					}
					 new Ajax.Request(contextPath + "/GIISTariffZoneController", {
						parameters : {
							action : "valAddRec",
							tariffZone : $F("txtTariffZone"),
						},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response) {
							hideNotice();
							if (checkErrorOnResponse(response)
									&& checkCustomErrorOnResponse(response)) {
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

	function deleteRec() {
		changeTagFunc = saveGiiss054;
		objCurrTariffZone.recordStatus = -1;
		tbgTariffZone.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}

	function valDeleteRec() {
		try {
			new Ajax.Request(contextPath + "/GIISTariffZoneController", {
				parameters : {
					action : "valDeleteRec",
					tariffZone : $F("txtTariffZone")
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response) {
					hideNotice();
					if (checkErrorOnResponse(response)
							&& checkCustomErrorOnResponse(response)) {
						deleteRec();
					}
				}
			});
		} catch (e) {
			showErrorMessage("valDeleteRec", e);
		}
	}

	function exitPage() {
		goToModule("/GIISUserController?action=goToUnderwriting",
				"Underwriting Main", null);
	}

	function cancelGiiss054() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						objGIISS054.exitPage = exitPage;
						saveGiiss054();
					}, function() {
						goToModule(
								"/GIISUserController?action=goToUnderwriting",
								"Underwriting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting",
					"Underwriting Main", null);
		}
	}
	
	function getGiiss054LineLOV() {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getGiiss054LineLOV",
				searchString : ($("txtLineCd").readAttribute("lastValidValue") != $F("txtLineCd") ? nvl($F("txtLineCd"),"%") : "%"),
				page : 1,				
			},
			title : "Line",
			width : 416,
			height : 386,
			columnModel : [ {
				id : "lineCd",
				title : "Line Code",
				width : '135px',
			},{
				id : "lineName",
				title : "Line Name",
				width : '250px',
			}  ],
			draggable : true,
			autoSelectOneRecord : true,
			filterText :$("txtLineCd").value,
			onSelect : function(row) {
				$("txtLineCd").value = unescapeHTML2(row.lineCd);	
				$("txtLineName").value = unescapeHTML2(row.lineName);				
				$("txtLineCd").setAttribute("lastValidValue", row.lineCd);
				$("txtLineName").setAttribute("lastValidValue", row.lineName);
			},
			onCancel : function() {
				$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				$("txtLineName").value=$("txtLineName").readAttribute("lastValidValue");
			},
			onUndefinedRow : function() {
				customShowMessageBox("No record selected.", imgMessage.INFO,
						"txtLineCd");	
				$("txtLineCd").value = "";	
				$("txtLineName").value = "";	
				$("txtLineCd").setAttribute("lastValidValue", "");
				$("txtLineName").setAttribute("lastValidValue", "");
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();
			}
		});
	}	
	
	function getGiiss054SublineLOV() {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getGiiss054SublineLOV",
				searchString : ($("txtSublineCd").readAttribute("lastValidValue") != $F("txtSublineCd") ? nvl($F("txtSublineCd"),"%") : "%"),
				lineCd : $F("txtLineCd"),
				page : 1,				
			},
			title : "Subline",
			width : 416,
			height : 386,
			columnModel : [ {
				id : "sublineCd",
				title : "Subline Code",
				width : '135px',
			},{
				id : "sublineName",
				title : "Subline Name",
				width : '250px',
			}  ],
			draggable : true,
			autoSelectOneRecord : true,
			filterText :$("txtSublineCd").value,
			onSelect : function(row) {
				$("txtSublineCd").value = unescapeHTML2(row.sublineCd);	
				$("txtSublineName").value = unescapeHTML2(row.sublineName);				
				$("txtSublineCd").setAttribute("lastValidValue", row.sublineCd);
				$("txtSublineName").setAttribute("lastValidValue", row.sublineName);
			},
			onCancel : function() {
				$("txtSublineCd").value = $("txtSublineCd").readAttribute("lastValidValue");
				$("txtSublineName").value=$("txtSublineName").readAttribute("lastValidValue");
			},
			onUndefinedRow : function() {
				customShowMessageBox("No record selected.", imgMessage.INFO,
						"txtSublineCd");	
				$("txtSublineCd").value = "";	
				$("txtSublineName").value = "";	
				$("txtSublineCd").setAttribute("lastValidValue", "");
				$("txtSublineName").setAttribute("lastValidValue", "");
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();
			}
		});
	}	
	
	function getGiiss054TarfLOV() {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getGiiss054TarfLOV",
				searchString : ($("txtTarfCd").readAttribute("lastValidValue") != $F("txtTarfCd") ? nvl($F("txtTarfCd"),"%") : "%"),
				page : 1,				
			},
			title : "Tariff Code And Description",
			width : 416,
			height : 386,
			columnModel : [ {
				id : "tariffCd",
				title : "Tariff Code",
				width : '135px',
			},{
				id : "tarfDesc",
				title : "Tariff Description",
				width : '250px',
			}  ],
			draggable : true,
			autoSelectOneRecord : true,
			filterText :$("txtTarfCd").value,
			onSelect : function(row) {
				$("txtTarfCd").value = unescapeHTML2(row.tariffCd);	
				$("txtTarfDesc").value = unescapeHTML2(row.tarfDesc);				
				$("txtTarfCd").setAttribute("lastValidValue", row.tariffCd);
				$("txtTarfDesc").setAttribute("lastValidValue", row.tarfDesc);
			},
			onCancel : function() {
				$("txtTarfCd").value = $("txtTarfCd").readAttribute("lastValidValue");
				$("txtTarfDesc").value=$("txtTarfDesc").readAttribute("lastValidValue");
			},
			onUndefinedRow : function() {
				customShowMessageBox("No record selected.", imgMessage.INFO,
						"txtTarfCd");	
				$("txtTarfCd").value = "";	
				$("txtTarfDesc").value = "";	
				$("txtTarfCd").setAttribute("lastValidValue", "");
				$("txtTarfDesc").setAttribute("lastValidValue", "");
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();
			}
		});
	}	
	
	$("txtTariffZone").observe("change", function() {		
		if(!RegExWholeNumber.pWholeNumber.test($("txtTariffZone").value)){
			$("txtTariffZone").clear();
			customShowMessageBox("Tariff Zone must be a non-negative integer.", "I", "txtTariffZone");
			return;
		}	
	});	
	
	$("imgSearchLine").observe("click", function() {
		getGiiss054LineLOV();
	});
	
	$("txtLineCd").observe("change", function() {		
		if($F("txtLineCd").trim()!=""&& $("txtLineCd").value != $("txtLineCd").readAttribute("lastValidValue")){						
			getGiiss054LineLOV();			
		}else if($F("txtLineCd").trim()==""){
			$("txtLineCd").value="";	
			$("txtLineName").value="";	
			$("txtLineCd").setAttribute("lastValidValue","");
			$("txtLineName").setAttribute("lastValidValue","");
		}					
	});	
	
	$("imgSearchSubline").observe("click", function() {
		getGiiss054SublineLOV();
	});
	
	$("txtSublineCd").observe("change", function() {		
		if($F("txtSublineCd").trim()!=""&& $("txtSublineCd").value != $("txtSublineCd").readAttribute("lastValidValue")){						
			getGiiss054SublineLOV();			
		}else if($F("txtSublineCd").trim()==""){
			$("txtSublineCd").value="";	
			$("txtSublineName").value="";	
			$("txtSublineCd").setAttribute("lastValidValue","");
			$("txtSublineName").setAttribute("lastValidValue","");
		}					
	});	

	$("imgSearchTarf").observe("click", function() {
		getGiiss054TarfLOV();
	});
	
	$("txtTarfCd").observe("change", function() {		
		if($F("txtTarfCd").trim()!=""&& $("txtTarfCd").value != $("txtTarfCd").readAttribute("lastValidValue")){						
			getGiiss054TarfLOV();			
		}else if($F("txtTarfCd").trim()==""){
			$("txtTarfCd").value="";	
			$("txtTarfDesc").value="";	
			$("txtTarfCd").setAttribute("lastValidValue","");
			$("txtTarfDesc").setAttribute("lastValidValue","");
		}					
	});	
	
	$("editRemarks").observe(
			"click",
			function() {
				showOverlayEditor("txtRemarks", 4000, $("txtRemarks")
						.hasAttribute("readonly"));
			});

	disableButton("btnDelete");
	observeSaveForm("btnSave", saveGiiss054);
	$("btnCancel").observe("click", cancelGiiss054);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("uwExit").stopObserving("click");
	$("uwExit").observe("click", function() {
		fireEvent($("btnCancel"), "click");
	});
	$("txtTariffZone").focus();
	if(objGIISS054.checkGiiss054UserAccess==0){
		showWaitingMessageBox("You have no access to any Fire line.", imgMessage.ERROR, function(){
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		});  
	}
</script>