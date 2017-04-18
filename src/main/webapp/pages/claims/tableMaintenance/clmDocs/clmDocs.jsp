<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="gicls110MainDiv" name="gicls110MainDiv" style="">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Required Document Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="gicls110" name="gicls110">
		<div id="clmDocsParamsDiv" class="sectionDiv">
			<table style="margin: 10px 0px 10px 45px;">
				<tr>
					<td class="rightAligned">Line</td>
					<td>
						<span class="lovSpan required" style="float: left; width: 100px; margin-right: 5px; margin-top: 2px; height: 21px;">
							<input type="text" id="txtLineCd" name="txtLineCd" class="required allCaps" style="width: 75px; float: left; border: none; height: 15px; margin: 0; " maxlength="2" tabindex="101" lastValidValue="" ignoreDelKey=""/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgLineCd" name="imgLineCd" alt="Go" style="float: right;" tabindex="102"/>
						</span>
						<input type="text" id="txtLineName" style="height: 15px; width: 226px;" readonly="readonly" tabindex="103"/>
					</td>
					<td width="100px" class="rightAligned">Subline</td>
					<td>
						<span class="lovSpan required" style="float: left; width: 100px; margin-right: 5px; margin-top: 2px; height: 21px;">
							<input type="text" id="txtSublineCd" name="txtSublineCd" class="required allCaps" style="width: 75px; float: left; border: none; height: 15px; margin: 0; " maxlength="7" tabindex="104" lastValidValue="" ignoreDelKey=""/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSublineCd" name="imgSublineCd" alt="Go" style="float: right;" tabindex="105"/>
						</span>
						<input type="text" id="txtSublineName" style="margin-left: 5px; height: 15px; width: 226px;" readonly="readonly" tabindex="106"/>
					</td>
				</tr>
			</table>
		</div>
		<div class="sectionDiv">
			<div id="clmDocsDiv">
				<div id="clmDocsTableDiv" style="height: 331px; margin: 10px 0px 0px 182px;">
					
				</div>
			</div>
			<div align="center" id="clmDocsFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Code</td>
						<td>
							<input id="txtDspClmDocCd" type="text" style="width: 200px; text-align: right;" maxlength="3" readonly="readonly" tabindex="107"/>
						</td>
						<td class="rightAligned">Priority Code</td>
						<td>
							<input id="txtPriorityCd" type="text" style="width: 203px; text-align: right;" maxlength="3" lastValidValue="" tabindex="108"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Document Description</td>
						<td colspan="3">
							<input id="txtClmDocDesc" class="required" type="text" style="width: 525px; " maxlength="100" tabindex="109"/>
						</td> 
					</tr>	
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 531px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 505px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="2000"  onkeyup="limitText(this,4000);" tabindex="110"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="111"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="112"></td>
						<td width="105px;" class="rightAligned">Last Update</td>
						<td><input id="txtLastUpdate" type="text" class="" style="width: 203px;" readonly="readonly" tabindex="113"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;" align="center">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="114">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="115">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="116">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="117">
</div>
<script type="text/javascript">
try{
	setModuleId("GICLS110");
	setDocumentTitle("Required Document Maintenance");
	hideToolbarButton("btnToolbarPrint");
	showToolbarButton("btnToolbarSave");
	initializeAll();
	initializeAccordion();
	
	changeTag = 0;
	var rowIndex = -1;
	var objGicls110 = {};
	
	function showGicls110LineLOV(){
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getGicls110LineLOV",
							moduleId : "GICLS110",
							filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
							page : 1},
			title: "List of Lines",
			width: 407,
			height: 386,
			columnModel : [ {
								id: "lineCd",
								title: "Code",
								width : '80px',
							},{
								id : "lineName",
								title : "Line Name",
								width : '312px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							} ],
				autoSelectOneRecord: true,
				filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
				onSelect: function(row) {
					$("txtLineCd").value = unescapeHTML2(row.lineCd);
					$("txtLineCd").setAttribute("lastValidValue", unescapeHTML2(row.lineCd));
					$("txtLineName").value = unescapeHTML2(row.lineName);
					$("txtSublineCd").clear();
					$("txtSublineName").clear();
					enableToolbarButton("btnToolbarExecuteQuery");
					enableToolbarButton("btnToolbarEnterQuery");
					$("txtSublineCd").focus();
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
	
	function showGicls110SublineLOV(){
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getGicls110SublineLOV",
							moduleId : "GICLS110",
							lineCd : $F("txtLineCd"),
							filterText : ($("txtSublineCd").readAttribute("lastValidValue").trim() != $F("txtSublineCd").trim() ? $F("txtSublineCd").trim() : ""),
							page : 1},
			title: "List of Sublines",
			width: 407,
			height: 386,
			columnModel : [ {
								id: "sublineCd",
								title: "Code",
								width : '80px',
							},{
								id : "sublineName",
								title : "Subline Name",
								width : '312px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							} ],
				autoSelectOneRecord: true,
				filterText : ($("txtSublineCd").readAttribute("lastValidValue").trim() != $F("txtSublineCd").trim() ? $F("txtSublineCd").trim() : ""),
				onSelect: function(row) {
					$("txtSublineCd").value = unescapeHTML2(row.sublineCd);
					$("txtSublineCd").setAttribute("lastValidValue", unescapeHTML2(row.sublineCd));
					$("txtSublineName").value = unescapeHTML2(row.sublineName);
				},
				onCancel: function (){
					$("txtSublineCd").value = $("txtSublineCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtSublineCd").value = $("txtSublineCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	$("imgLineCd").observe("click", showGicls110LineLOV);
	$("txtLineCd").observe("change", function() {
		if($F("txtLineCd").trim() == "") {
			$("txtLineCd").value = "";
			$("txtLineCd").setAttribute("lastValidValue", "");
			$("txtLineName").value = "";
			$("txtSublineCd").value = "";
			$("txtSublineName").value = "";
			disableToolbarButton("btnToolbarExecuteQuery");
			disableToolbarButton("btnToolbarEnterQuery");
		} else {
			if($F("txtLineCd").trim() != "" && $F("txtLineCd") != $("txtLineCd").readAttribute("lastValidValue")) {
				showGicls110LineLOV();
			}
		}
	});
	
	$("imgSublineCd").observe("click", function(){
		if($F("txtLineCd").trim() == ""){
			customShowMessageBox("Please enter Line Code.", "I", "txtLineCd");
		}else{
			showGicls110SublineLOV();	
		}
	});
	$("txtSublineCd").observe("change", function() {
		if($F("txtLineCd").trim() == ""){
			customShowMessageBox("Please enter Line Code.", "I", "txtLineCd");
			$("txtSublineCd").clear();
		}else{
			if($F("txtSublineCd").trim() == "") {
				$("txtSublineCd").value = "";
				$("txtSublineCd").setAttribute("lastValidValue", "");
				$("txtSublineName").value = "";
			} else {
				if($F("txtSublineCd").trim() != "" && $F("txtSublineCd") != $("txtSublineCd").readAttribute("lastValidValue")) {
					showGicls110SublineLOV();
				}
			}	
		}
	});

	function executeQuery(){
		if(checkAllRequiredFieldsInDiv("clmDocsParamsDiv")) {			
			tbgClmDocs.url = contextPath+"/GICLClmDocsController?action=showGicls110&refresh=1&lineCd="+encodeURIComponent($F("txtLineCd"))+"&sublineCd="+encodeURIComponent($F("txtSublineCd"));
			tbgClmDocs._refreshList();
			setForm(true);
			$("txtLineCd").readOnly = true;
			$("txtSublineCd").readOnly = true;
			disableToolbarButton("btnToolbarExecuteQuery");
			enableToolbarButton("btnToolbarEnterQuery");
			disableSearch("imgLineCd");
			disableSearch("imgSublineCd");
		}
	}
		
	$("btnToolbarExecuteQuery").observe("click", executeQuery);
	
	function enterQuery(){
		function proceedEnterQuery(){
			disableToolbarButton("btnToolbarExecuteQuery");
			$("txtLineCd").value = "";
			$("txtLineCd").setAttribute("lastValidValue", "");
			$("txtLineName").value = "";
			$("txtSublineCd").value = "";
			$("txtSublineCd").setAttribute("lastValidValue", "");
			$("txtSublineName").value = "";
			$("txtDspClmDocCd").value = "";
			$("txtPriorityCd").value = "";
			$("txtClmDocDesc").value = "";
			$("txtRemarks").value = "";
			$("txtUserId").value = "";
			$("txtLastUpdate").value = "";
			$("txtLineCd").readOnly = false;
			$("txtSublineCd").readOnly = false;
			enableSearch("imgLineCd");
			enableSearch("imgSublineCd");
			tbgClmDocs.url = contextPath + "/GICLClmDocsController?action=showGicls110&refresh=1&lineCd="+encodeURIComponent($F("txtLineCd"))+"&sublineCd="+encodeURIComponent($F("txtSublineCd"));
			tbgClmDocs._refreshList();
			setFieldValues(null);
			$("txtLineCd").focus();
			disableToolbarButton("btnToolbarEnterQuery");
			setForm(false);
			changeTag = 0;
		}
		
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveGicls110();
						proceedEnterQuery();
					}, function(){
						proceedEnterQuery();
					}, "");
		} else {
			proceedEnterQuery();
		}		
	}
	
	$("btnToolbarEnterQuery").observe("click", enterQuery);
	
	function setForm(enable){
		if(enable){
			$("txtPriorityCd").readOnly = false;
			$("txtClmDocDesc").readOnly = false;
			$("txtRemarks").readOnly = false;
			enableButton("btnAdd");
		} else {
			$("txtPriorityCd").readOnly = true;
			$("txtClmDocDesc").readOnly = true;
			$("txtRemarks").readOnly = true;		
			disableButton("btnAdd");
			disableButton("btnDelete");
		}
	}
	
	function saveGicls110(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgClmDocs.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgClmDocs.geniisysRows);
		new Ajax.Request(contextPath+"/GICLClmDocsController", {
			method: "POST",
			parameters : {action : "saveGicls110",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGicls110.exitPage != null) {
							objGicls110.exitPage();
						} else {
							tbgClmDocs.url = contextPath + "/GICLClmDocsController?action=showGicls110&refresh=1&lineCd="+encodeURIComponent($F("txtLineCd"))+"&sublineCd="+encodeURIComponent($F("txtSublineCd"));
							tbgClmDocs._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGicls110);
	
	var objCurrClmDocs = null;
	objGicls110.clmDocsList = JSON.parse('${jsonClmDocsList}');
	objGicls110.exitPage = null;
	
	var clmDocsTableModel = {
			url : contextPath + "/GICLClmDocsController?action=showGicls110&refresh=1&lineCd="+encodeURIComponent($F("txtLineCd"))+"&sublineCd="+encodeURIComponent($F("txtSublineCd")),
			options : {
				width : '550px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrClmDocs = tbgClmDocs.geniisysRows[y];
					setFieldValues(objCurrClmDocs);
					tbgClmDocs.keys.removeFocus(tbgClmDocs.keys._nCurrentFocus, true);
					tbgClmDocs.keys.releaseKeys();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgClmDocs.keys.removeFocus(tbgClmDocs.keys._nCurrentFocus, true);
					tbgClmDocs.keys.releaseKeys();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgClmDocs.keys.removeFocus(tbgClmDocs.keys._nCurrentFocus, true);
						tbgClmDocs.keys.releaseKeys();
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
					tbgClmDocs.keys.removeFocus(tbgClmDocs.keys._nCurrentFocus, true);
					tbgClmDocs.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgClmDocs.keys.removeFocus(tbgClmDocs.keys._nCurrentFocus, true);
					tbgClmDocs.keys.releaseKeys();
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
					tbgClmDocs.keys.removeFocus(tbgClmDocs.keys._nCurrentFocus, true);
					tbgClmDocs.keys.releaseKeys();
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
				{
					id : "clmDocCd",
					title : "Code",
					align : 'right',
					width : '100px',
					filterOption : true,
					filterOptionType : 'integerNoNegative'
				},
				{
					id : "clmDocDesc",
					title : "Document Description",
					width : '311px',
					filterOption : true
				},
				{
					id : "priorityCd",
					title : "Priority Code",
					align : 'right',
					width : '110px',
					filterOption : true,
					filterOptionType : 'integerNoNegative',
					renderer: function(value) {
						if(value == ""){
							return value;
						}else{
							return formatNumberDigits(value, 3);	
						}
					} 
				},
			],
			rows : objGicls110.clmDocsList.rows
		};

		tbgClmDocs = new MyTableGrid(clmDocsTableModel);
		tbgClmDocs.pager = objGicls110.clmDocsList;
		tbgClmDocs.render("clmDocsTableDiv");
	
	function setFieldValues(rec){
		try{
			$("txtDspClmDocCd").value = (rec == null ? "" : rec.clmDocCd);
			$("txtPriorityCd").value = (rec == null ? "" : nvl(formatNumberDigits(rec.priorityCd, 3), ""));
			$("txtClmDocDesc").value = (rec == null ? "" : unescapeHTML2(rec.clmDocDesc));
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.clmDocRemark));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : unescapeHTML2(rec.lastUpdate));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrClmDocs = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.lineCd = escapeHTML2($F("txtLineCd"));
			obj.sublineCd = escapeHTML2($F("txtSublineCd"));
			obj.clmDocCd = $F("txtDspClmDocCd");
			obj.priorityCd = $F("txtPriorityCd");
			obj.clmDocDesc = escapeHTML2($F("txtClmDocDesc"));
			obj.userId = userId;
			obj.clmDocRemark = escapeHTML2($F("txtRemarks"));
			
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			if(checkAllRequiredFieldsInDiv("clmDocsFormDiv")){
				changeTagFunc = saveGicls110;
				var rec = setRec(objCurrClmDocs);
				if($F("btnAdd") == "Add"){
					tbgClmDocs.addBottomRow(rec);
				} else {
					tbgClmDocs.updateVisibleRowOnly(rec, rowIndex, false);
				}
				changeTag = 1;
				setFieldValues(null);
				tbgClmDocs.keys.removeFocus(tbgClmDocs.keys._nCurrentFocus, true);
				tbgClmDocs.keys.releaseKeys();	
			}
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}
	
	function valDeleteRec(){
		new Ajax.Request(contextPath+"/GICLClmDocsController", {
			method: "POST",
			parameters : {	action : "valDeleteRec",
					 	  	lineCd : $F("txtLineCd"),
					 	  	sublineCd : $F("txtSublineCd"),
					 	  	clmDocCd : $F("txtDspClmDocCd")
						 },
			onComplete: function(response){
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					deleteRec();
				}
			}
		});
	}
	
	function deleteRec(){
		changeTagFunc = saveGicls110;
		objCurrClmDocs.recordStatus = -1;
		tbgClmDocs.geniisysRows[rowIndex].lineCd = escapeHTML2(tbgClmDocs.geniisysRows[rowIndex].lineCd);
		tbgClmDocs.geniisysRows[rowIndex].sublineCd = escapeHTML2(tbgClmDocs.geniisysRows[rowIndex].sublineCd);
		tbgClmDocs.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", null);
	}	
	
	function cancelGicls110(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGicls110.exitPage = exitPage;
						saveGicls110();
					}, function(){
						goToModule("/GIISUserController?action=goToClaims", "Claims Main", null);
					}, "");
		} else {
			if(objCLMGlobal.callingForm == "GICLS180"){
				$("gicls180MainDiv").show();
				$("clmDocsDiv").hide();
			}else{
				goToModule("/GIISUserController?action=goToClaims", "Claims Main", null);	
			}
		}
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 2000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("txtPriorityCd").observe("focus", function(){
		$("txtPriorityCd").setAttribute("lastValidValue", $F("txtPriorityCd"));
	});
	$("txtPriorityCd").observe("change", function(){
		if((isNaN($F("txtPriorityCd"))) || (parseFloat($F("txtPriorityCd")) < 0)){
			customShowMessageBox("Invalid Priority Code. Valid value should be from 0 to 999.", "I", "txtPriorityCd");
			$("txtPriorityCd").value = formatNumberDigits($("txtPriorityCd").readAttribute("lastValidValue"), 3);
		}else{
			$("txtPriorityCd").value = formatNumberDigits($F("txtPriorityCd"), 3);
		}
	});
	
	setForm(false);
	disableButton("btnDelete");
	disableToolbarButton("btnToolbarExecuteQuery");
	disableToolbarButton("btnToolbarEnterQuery");
	observeSaveForm("btnSave", saveGicls110);
	observeSaveForm("btnToolbarSave", saveGicls110);
	$("btnCancel").observe("click", cancelGicls110);
	$("btnAdd").observe("click", addRec);
	$("btnDelete").observe("click", valDeleteRec);
	$("btnToolbarExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtLineCd").focus();
}catch(e){
	showErrorMessage("clmDocs.jsp", e);
}
</script>