<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss035MainDiv" name="giiss035MainDiv" style="">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Required Policy Document Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss035" name="giiss035">	
		<div id="riFormDiv" align="center" class="sectionDiv" style="padding-top:20px; padding-bottom: 20px;">
			<table cellspacing="0" width: 900px;">
				<tr>
					<td class="rightAligned" style="width:60px;">Line</td>
					<td class="leftAligned" style="width:350px;">
						<span class="lovSpan required" style="width: 70px; height: 21px; margin: 2px 2px 0 0; float: left;">
							<input type="text" id="txtLineCd" name="txtLineCd" ignoreDelKey="1" style="width: 43px; float: left; border: none; height: 13px;" class="disableDelKey allCaps required" maxlength="2" tabindex="101" />
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLine" name="searchLine" alt="Go" style="float: right;">
						</span> 
						<span class="lovSpan " style="border: none; height: 21px; margin: 0 2px 0 2px; float: left;">
							<input type="text" id="txtLineName" name="txtLineName" ignoreDelKey="1" style="width: 250px; float: left; height: 15px;" class="allCaps required" maxlength="20" readonly="readonly" tabindex="102" />
						</span>
					</td>
					<td class="rightAligned" style="width:60px;">Subline</td>
					<td class="leftAligned" style="width:350px;">
						<span class="lovSpan required" style="width: 70px; height: 21px; margin: 2px 2px 0 0; float: left;">
							<input type="text" id="txtSublineCd" name="txtSublineCd" ignoreDelKey="1" style="width: 43px; float: left; border: none; height: 13px;" class="required disableDelKey allCaps" maxlength="7" tabindex="103" />
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchSubline" name="searchSubline" alt="Go" style="float: right;">
						</span> 
						<span class="lovSpan " style="border: none; height: 21px; margin: 0 2px 0 2px; float: left;">
							<input type="text" id="txtSublineName" name="txtSublineName" ignoreDelKey="1" style="width: 250px; float: left; height: 15px;" class="allCaps required" maxlength="30" readonly="readonly" tabindex="104" />
						</span>
					</td>
				</tr>
			</table>
		</div>		
		<div class="sectionDiv">
			<div id="requiredDocumentsTableDiv" style="padding-top: 10px;">
				<div id="requiredDocumentsTable" style="height: 331px; padding-left: 115px;"></div>
			</div>
			<div align="center" id="requiredDocsFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned"><input type="checkbox" name="chkValidTag" id="chkValidTag" value="" readonly="readonly" checked="checked"/></td>
						<td class="leftAligned"><label for="chkValidTag">Valid</label></td>
					</tr>
					<tr>
						<td class="rightAligned">Code</td>
						<td class="leftAligned">
							<input id="txtDocCd" type="text" class="required allCaps" style="width: 200px; text-align: left;" tabindex="201" maxlength="3" readonly="readonly">
						</td>
						<td class="rightAligned">Effectivity Date</td>
						<td class="leftAligned">
							<div id="effectivityDateDiv" class="required" style="float: left; border: 1px solid gray; width: 205px; height: 20px;">
								<input id="txtEffDate" name="Start Date." readonly="readonly" type="text" class=" required date " maxlength="10" style="border: none; float: left; width: 180px; height: 13px; margin: 0px;" value="" tabindex="304"/>
								<img id="imgEffDate" alt="imgEffDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtEffDate'),this, null);" />
							</div>
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Document Name</td>
						<td class="leftAligned" colspan="3">
							<input id="txtDocName" type="text" class="required allCaps" style="width: 533px;" tabindex="203" maxlength="100" readonly="readonly">
						</td>
					</tr>				
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="204" readonly="readonly"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="205"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="206"></td>
						<td width="" class="rightAligned" style="width: 113px;">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="207"></td>
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
	setModuleId("GIISS035");
	setDocumentTitle("Required Policy Document Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	showToolbarButton("btnToolbarSave"); 
	hideToolbarButton("btnToolbarPrint");
	disableToolbarButton("btnToolbarEnterQuery"); 
	disableToolbarButton("btnToolbarExecuteQuery"); 
	disableButton("btnAdd");
	disableDate("imgEffDate");
	$("chkValidTag").disabled = true;
	validateLine = 0;
	validateSubline = 0;
	
	function saveGiiss035(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgRequiredDocuments.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgRequiredDocuments.geniisysRows);
		new Ajax.Request(contextPath+"/GIISRequiredDocController", {
			method: "POST",
			parameters : {action : "saveGiiss035",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS035.exitPage != null) {
							objGIISS035.exitPage();
						} else {
							tbgRequiredDocuments._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss035);
	
	var objGIISS035 = {};
	var objCurrRequiredDocs = null;
	objGIISS035.requiredDocsList = JSON.parse('${jsonRequiredDocs}');
	objGIISS035.exitPage = null;
	
	var requiredDocumentsTable = {
			url : contextPath + "/GIISRequiredDocController?action=showGiiss035&refresh=1&lineCd="+encodeURIComponent($F("txtLineCd"))+"&sublineCd="+encodeURIComponent($F("txtSublineCd")),
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrRequiredDocs = tbgRequiredDocuments.geniisysRows[y];
					setFieldValues(objCurrRequiredDocs);
					tbgRequiredDocuments.keys.removeFocus(tbgRequiredDocuments.keys._nCurrentFocus, true);
					tbgRequiredDocuments.keys.releaseKeys();
					$("txtDocName").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgRequiredDocuments.keys.removeFocus(tbgRequiredDocuments.keys._nCurrentFocus, true);
					tbgRequiredDocuments.keys.releaseKeys();
					$("txtDocCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgRequiredDocuments.keys.removeFocus(tbgRequiredDocuments.keys._nCurrentFocus, true);
						tbgRequiredDocuments.keys.releaseKeys();
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
					tbgRequiredDocuments.keys.removeFocus(tbgRequiredDocuments.keys._nCurrentFocus, true);
					tbgRequiredDocuments.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgRequiredDocuments.keys.removeFocus(tbgRequiredDocuments.keys._nCurrentFocus, true);
					tbgRequiredDocuments.keys.releaseKeys();
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
					tbgRequiredDocuments.keys.removeFocus(tbgRequiredDocuments.keys._nCurrentFocus, true);
					tbgRequiredDocuments.keys.releaseKeys();
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
					id: 'validFlag',
	          		title : '&#160;V',
	          		altTitle: "Valid",
	              	width: '30px',
	              	filterOption : true,
	              	filterOptionType : 'checkbox',
	              	editable: false,
	              	editor: new MyTableGrid.CellCheckbox({
		            	getValueOf : function(value) {
							if (value) {
								return "Y";
							} else {
								return "N";
							}
						}
	              	})
              	},
				{
					id : 'docCd',
					title : "Code",
					filterOption : true,
					width : '80px'
				},
				{
					id : 'docName',
					filterOption : true,
					title : 'Document Name',
					width : '400px'				
				},
				{
					id : 'effectivityDate',
					filterOption : true,
					title : 'Effectivity Date',
					width : '150px',
					filterOptionType : 'formattedDate',
					renderer: function (value){
						var dateTemp;
						if(value=="" || value==null){
							dateTemp = "";
						}else{
							dateTemp = dateFormat(value,"mm-dd-yyyy");
						}
						return dateTemp;
					},
					align: "center",
					titleAlign: "center"
				},
				{
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
			rows : objGIISS035.requiredDocsList.rows || []
		};

		tbgRequiredDocuments = new MyTableGrid(requiredDocumentsTable);
		tbgRequiredDocuments.pager = objGIISS035.requiredDocsList;
		tbgRequiredDocuments.render("requiredDocumentsTable");
	
	function setFieldValues(rec){
		try{
			$("txtDocCd").value = (rec == null ? "" : unescapeHTML2(rec.docCd));
			$("txtDocCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.docCd)));
			$("txtDocName").value = (rec == null ? "" : unescapeHTML2(rec.docName));
			$("chkValidTag").checked = (rec == null ? true : (rec.validFlag == "Y" ? true : false));
			$("txtEffDate").value = (rec == null ? "" : dateFormat(rec.effectivityDate,'mm-dd-yyyy'));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtDocCd").readOnly = false : $("txtDocCd").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrRequiredDocs = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.lineCd = escapeHTML2($F("txtLineCd"));
			obj.sublineCd = escapeHTML2($F("txtSublineCd"));
			obj.validFlag = $("chkValidTag").checked ? "Y" : "N";
			obj.effectivityDate = $F("txtEffDate");
			obj.docCd = escapeHTML2($F("txtDocCd"));
			obj.docName = escapeHTML2($F("txtDocName"));
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
			changeTagFunc = saveGiiss035;
			var docs = setRec(objCurrRequiredDocs);
			if($F("btnAdd") == "Add"){
				tbgRequiredDocuments.addBottomRow(docs);
			} else {
				tbgRequiredDocuments.updateVisibleRowOnly(docs, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgRequiredDocuments.keys.removeFocus(tbgRequiredDocuments.keys._nCurrentFocus, true);
			tbgRequiredDocuments.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("requiredDocsFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;	
					
					for ( var i = 0; i < tbgRequiredDocuments.geniisysRows.length; i++) {
						if (tbgRequiredDocuments.geniisysRows[i].recordStatus == 0 || tbgRequiredDocuments.geniisysRows[i].recordStatus == 1) {
							if (tbgRequiredDocuments.geniisysRows[i].docCd == escapeHTML2($F("txtDocCd"))) {
								addedSameExists = true;
							}
						} else if (tbgRequiredDocuments.geniisysRows[i].recordStatus == -1) {
							if (tbgRequiredDocuments.geniisysRows[i].docCd == escapeHTML2($F("txtDocCd")) || unescapeHTML2(unescapeHTML2(tbgRequiredDocuments.geniisysRows[i].docCd)) == $F("txtDocCd")) {
								deletedSameExists = true;
							}
						}
					}
					if ((addedSameExists && !deletedSameExists)|| (deletedSameExists && addedSameExists)) {
						showMessageBox("Record already exists with the same doc_cd.", "E");
						return;
					} else if (deletedSameExists && !addedSameExists) {
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GIISRequiredDocController", {
						parameters : {
							action : "valAddRec",
							lineCd : $F("txtLineCd"),
							sublineCd : $F("txtSublineCd"),
							docCd : $F("txtDocCd")
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
		changeTagFunc = saveGiiss035;
		objCurrRequiredDocs.recordStatus = -1;
		tbgRequiredDocuments.geniisysRows[rowIndex].lineCd = escapeHTML2(tbgRequiredDocuments.geniisysRows[rowIndex].lineCd);
		tbgRequiredDocuments.geniisysRows[rowIndex].sublineCd = escapeHTML2(tbgRequiredDocuments.geniisysRows[rowIndex].sublineCd);
		tbgRequiredDocuments.geniisysRows[rowIndex].docCd = escapeHTML2(tbgRequiredDocuments.geniisysRows[rowIndex].docCd);
		tbgRequiredDocuments.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}

	function valDeleteRec() {
		try {
			new Ajax.Request(contextPath + "/GIISRequiredDocController", {
				parameters : {
					action : "valDeleteRec",
					lineCd : $F("txtLineCd"),
					sublineCd : $F("txtSublineCd"),
					docCd : $F("txtDocCd")
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response) {
					hideNotice();
					if(response.responseText != "N"){
						showMessageBox("Cannot delete record from GIIS_REQUIRED_DOCS while dependent record(s) in " + response.responseText + " exists.", imgMessage.ERROR);
					} else{
						if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
							deleteRec();
						}
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

	function cancelGiiss035() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						objGIISS035.exitPage = exitPage;
						saveGiiss035();
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

	$("editRemarks").observe(
			"click",
			function() {
				showOverlayEditor("txtRemarks", 4000, $("txtRemarks")
						.hasAttribute("readonly"));
			});

	disableButton("btnDelete");

	observeSaveForm("btnSave", saveGiiss035);
	observeSaveForm("btnToolbarSave", saveGiiss035);
	$("btnCancel").observe("click", cancelGiiss035);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);
	$("btnToolbarExit").observe("click", function() {
		fireEvent($("btnCancel"), "click");
	});
	$("txtLineCd").focus();
	
	$("btnToolbarEnterQuery").observe("click", function() {
			if (changeTag == 1) {
				showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
						"Yes", "No", "Cancel", function() {
							objGIISS035.exitPage = showGiiss035;
							saveGiiss035();
						}, function() {
							showGiiss035();
						}, "");
			} else {
				showGiiss035();
			}
	});
	
	$("btnToolbarExecuteQuery").observe("click", function() {
		if(checkAllRequiredFieldsInDiv("riFormDiv")){
			disableSearch("searchLine");
			disableSearch("searchSubline");
			enableButton("btnAdd");
			enableDate("imgEffDate");
			disableToolbarButton("btnToolbarExecuteQuery");
			$("txtLineCd").readOnly = true;
			$("txtSublineCd").readOnly = true;
			$("chkValidTag").readOnly = false;
			$("txtDocCd").readOnly = false;
			$("txtDocName").readOnly = false;
			$("txtRemarks").readOnly = false;
			$("chkValidTag").disabled = false;
			line = encodeURIComponent($F("txtLineCd"));
			subline = encodeURIComponent($F("txtSublineCd"));
			tbgRequiredDocuments.url = contextPath+"/GIISRequiredDocController?action=showGiiss035&refresh=1&lineCd="+line+"&sublineCd="+subline;
			tbgRequiredDocuments._refreshList();
			if(tbgRequiredDocuments.rows.length == 0){
				showWaitingMessageBox("Query caused no records to be retrieved.", "I", function(){
					$("txtDocCd").focus();
				});
			}
		}
	});
	
	$("searchLine").observe("click",function(){
		if(validateLine != 1){
			showLineLOV();
		}
		validateLine = 0;
	});
	
	$("searchSubline").observe("click",function(){
		if($F("txtLineCd") == ""){
			showWaitingMessageBox("Please enter Line Code.", "I", function(){
				$("txtLineCd").focus();
			});
		} else {
			if(validateSubline != 1){
				showSublineLOV("%");
			}
			validateSubline = 0;
		}
	});
	
	function showLineLOV(){
		try{
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					  action : "getGiiss035LineLOV",
					  filterText: $F("txtLineCd") != $("txtLineCd").getAttribute("lastValidValue") ? nvl(($F("txtLineCd")), "%") : "%",  
						page : 1
				},
				title: "List of Lines",
				width: 470,
				height: 400,
				columnModel: [
		 			{
						id : 'lineCd',
						title: 'Code',
						width : '100px',
						align: 'left'
					},
					{
						id : 'lineName',
						title: 'Line Name',
					    width: '335px',
					    align: 'left'
					}
				],
				autoSelectOneRecord : true,
				filterText: $F("txtLineCd") != $("txtLineCd").getAttribute("lastValidValue") ? nvl(($F("txtLineCd")), "%") : "%",  
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtLineCd").value = unescapeHTML2(row.lineCd);
						$("txtLineName").value = unescapeHTML2(row.lineName);
						enableToolbarButton("btnToolbarEnterQuery");
						enableToolbarButton("btnToolbarExecuteQuery");
						validateLine = 0;
						if($F("txtLineCd") != $("txtLineCd").getAttribute("lastValidValue")){
							$("txtLineCd").setAttribute("lastValidValue", unescapeHTML2(row.lineCd));
							$("txtLineName").setAttribute("lastValidValue", unescapeHTML2(row.lineName));
							$("txtSublineCd").setAttribute("lastValidValue", "");
							$("txtSublineName").setAttribute("lastValidValue", "");
							$("txtSublineCd").value = "";
							$("txtSublineName").value = "";
						}
					}
				},
				onCancel: function(){
					$("txtLineCd").value = $("txtLineCd").getAttribute("lastValidValue");
					$("txtLineName").value = $("txtLineName").getAttribute("lastValidValue");
					$("txtLineCd").focus();
		  		},
		  		onUndefinedRow: function(){
		  			$("txtLineCd").value = $("txtLineCd").getAttribute("lastValidValue");
					$("txtLineName").value = $("txtLineName").getAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtLineCd");
		  		}
			});
		}catch(e){
			showErrorMessage("showLineLOV",e);
		}
	}
	
	function showSublineLOV(x){
		try{
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					  action : "getGiiss035SublineLOV",
					  lineCd : $F("txtLineCd"),
					  //filterText: $F("txtSublineCd") != $("txtSublineCd").getAttribute("lastValidValue") ? nvl(($F("txtSublineCd")), "%") : "%", 
					  search : x,
						page : 1
				},
				title: "List of Sublines",
				width: 470,
				height: 400,
				columnModel: [
		 			{
						id : 'sublineCd',
						title: 'Code',
						width : '100px',
						align: 'left'
					},
					{
						id : 'sublineName',
						title: 'Subline Name',
					    width: '335px',
					    align: 'left'
					}
				],
				autoSelectOneRecord : true,
				//filterText: $F("txtSublineCd") != $("txtSublineCd").getAttribute("lastValidValue") ? nvl(escapeHTML2($F("txtSublineCd")), "%") : "%", 
				filterText: nvl(escapeHTML2(x), "%"), 
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtSublineCd").value = unescapeHTML2(row.sublineCd);
						$("txtSublineName").value = unescapeHTML2(row.sublineName);
						enableToolbarButton("btnToolbarEnterQuery");
						enableToolbarButton("btnToolbarExecuteQuery");
						$("txtSublineCd").setAttribute("lastValidValue", unescapeHTML2(row.sublineCd));
						$("txtSublineName").setAttribute("lastValidValue", unescapeHTML2(row.sublineName));
						validateSubline = 0;
					}
				},
				onCancel: function(){
					$("txtSublineCd").focus();
					$("txtSublineCd").value = $("txtSublineCd").getAttribute("lastValidValue");
					$("txtSublineName").value = $("txtSublineName").getAttribute("lastValidValue");
		  		},
		  		onUndefinedRow: function(){
		  			$("txtSublineCd").value = $("txtSublineCd").getAttribute("lastValidValue");
					$("txtSublineName").value = $("txtSublineName").getAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtSublineCd");
		  		}
			});
		}catch(e){
			showErrorMessage("showSublineLOV",e);
		}
	}
	
	$("txtLineCd").observe("change",function(){
		if($F("txtLineCd") == ""){
			$("txtLineCd").value = "";
			$("txtLineName").value = "";
			$("txtSublineCd").value = "";
			$("txtSublineName").value = "";
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
			$("txtLineCd").setAttribute("lastValidValue","");
			$("txtLineName").setAttribute("lastValidValue","");
			$("txtSublineCd").setAttribute("lastValidValue", "");
			$("txtSublineName").setAttribute("lastValidValue", "");
			validateLine = 0;
		} else {
			validateLineCd();
		}
	});
	
	$("txtSublineCd").observe("change",function(){
		if($F("txtLineCd") == ""){
			showWaitingMessageBox("Please enter Line Code.", "I", function(){
				$("txtSublineCd").value = "";
				$("txtLineCd").focus();
			});
		} else {
			if($F("txtSublineCd") == ""){
				validateSubline = 0;
				$("txtSublineCd").value = "";
				$("txtSublineName").value = "";
				$("txtSublineCd").setAttribute("lastValidValue", "");
				$("txtSublineName").setAttribute("lastValidValue", "");
			} else {
				validateSublineCd();
			}
		}
	});
	
	function validateLineCd(){
		new Ajax.Request(contextPath+"/GIISRequiredDocController", {
			method: "POST",
			parameters: {
				action: "validateGiiss035Line",
				lineCd: escapeHTML2($F("txtLineCd"))
			},
			onCreate: showNotice("Please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					validateLine = 1;
					showLineLOV();
				}
			}
		});
	}
	
	function validateSublineCd(){
		new Ajax.Request(contextPath+"/GIISRequiredDocController", {
			method: "POST",
			parameters: {
				action: "validateGiiss035Subline",
				lineCd: escapeHTML2($F("txtLineCd")),
				sublineCd : escapeHTML2($F("txtSublineCd"))
			},
			onCreate: showNotice("Please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					validateSubline = 1;
					showSublineLOV($F("txtSublineCd"));
				}
			}
		});
	}
	
</script>