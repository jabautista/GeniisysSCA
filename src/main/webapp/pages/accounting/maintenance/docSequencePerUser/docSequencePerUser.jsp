<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giacs316MainDiv" name="giacs316MainDiv" style="">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Document Sequence per User Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>
	
	<div class="sectionDiv" id="searchDocBranchCd" style="height: 110px;">
		<table style="margin: 20px 0 20px 160px; width:800px;">
			<tr>
				<td class="rightAligned">Document</td>
				<td>
					<span class="lovSpan required" style="float: left; width: 130px; margin-right: 5px; margin-top: 2px; height: 21px;">
						<input type="text" id="txtDocumentCd" name="txtDocumentCd" ignoreDelKey="true" lastValidValue="" class="allCaps required" style="width: 105px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="101" />
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osDocumentCd" name="osDocumentCd" alt="Go" style="float: right;" />
					</span>
					<input type="text" id="txtDocumentName" name="txtDocumentName" style="width: 400px; float: left; height: 15px;" readonly="readonly" maxlength="20" tabindex="102" />
				</td>				
			</tr>
			<tr>
				<td class="rightAligned">Branch</td>
				<td>
					<span class="lovSpan required" style="float: left; width: 130px; margin-right: 5px; margin-top: 2px; height: 21px;">
						<input type="text" id="txtBranchCd" name="txtBranchCd" ignoreDelKey="true" lastValidValue="" class="allCaps required" style="width: 105px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="101" />
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osBranchCd" name="osBranchCd" alt="Go" style="float: right;" />
					</span>
					<input type="text" id="txtBranchName" name="txtBranchName" style="width: 400px; float: left; height: 15px;" readonly="readonly" maxlength="20" tabindex="102" />
				</td>				
			</tr>
		</table>
	</div>
	
	<div id="giacs316" name="giacs316">		
		<div class="sectionDiv">
			<div id="docSequenceUserTableDiv" style="padding-top: 5px;">
				<div id="docSequenceUserTable" style="height: 340px; margin: 10px;"></div>
			</div>
			<div align="center" id="docSequenceUserFormDiv">
				<table style="margin-top: 10px;">
					<tr>
						<td class="rightAligned">Code</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan required" style="float: left; width: 130px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input id="txtUserCd" type="text" lastValidValue="" class="required integerNoNegativeUnformattedNoComma" ignoreDelKey="true" style="width: 105px; float: left; border: none; height: 15px; margin: 0; text-align: right;" tabindex="201" maxlength="4" />
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osUserCd" name="osUserCd" alt="Go" style="float: right;" />
							</span>
							<input id="txtUserName" type="text" readonly="readonly" style="width: 463px; height: 15px;" tabindex="202" />
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Doc Prefix</td>
						<td class="leftAligned">
							<input id="txtDocPrefix" name="chng" lastValidValue="" class="required allCaps" type="text" style="width: 200px;" tabindex="203" maxlength="5">
							<input type="hidden" id="hidOldDocPrefix" />
						</td>
						<td class="rightAligned" style="width: 180px;">Valid</td>
						<td class="leftAligned">
							<select  id="selActiveTag" name="chng" lastValidValue="" style="width: 208px;" tabindex="204">
								<option value=""></option>
								<option value="Y">Yes</option>
								<option value="N">No</option>
							</select>
							<input type="hidden" id="hidOldActiveTag" />
						</td>					
					</tr>
					<tr>
						<td width="" class="rightAligned">Min Sequence No.</td>
						<td class="leftAligned">
							<input type="text" id="txtMinSeqNo" name="chng" lastValidValue="" class="required integerNoNegativeUnformattedNoComma" style="text-align: right; width: 200px;" tabindex="205" maxlength="10" />
							<input type="hidden" id="hidOldMinSeqNo" />
						</td>
						<td width="" class="rightAligned">Max Sequence No.</td>
						<td class="leftAligned">
							<input type="text" id="txtMaxSeqNo" name="chng" lastValidValue="" class="required integerNoNegativeUnformattedNoComma" style="text-align: right; width: 200px;" tabindex="206" maxlength="10" />
							<input type="hidden" id="hidOldMaxSeqNo" />
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div name="remarksDiv" style="float: left; width: 606px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 575px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="207"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="211"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="208"></td>
						<td width="110px" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="209"></td>
					</tr>			
				</table>
			</div>
			<div class="buttonsDiv" style="margin: 10px;">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="301">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="302">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv" style="margin:10px 0 30px 10px;">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="303">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="304">
</div>
<script type="text/javascript">	
	setModuleId("GIACS316");
	setDocumentTitle("Document Sequence per User Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	var isInvalidRecord = false;
	
	disableToolbarButton("btnToolbarEnterQuery");
	disableToolbarButton("btnToolbarExecuteQuery");
	showToolbarButton("btnToolbarSave");
	hideToolbarButton("btnToolbarPrint");
	setForm(false);
	
	function saveGiacs316(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgDocSequenceUser.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgDocSequenceUser.geniisysRows);
		new Ajax.Request(contextPath+"/GIACDocSequenceUserController", {
			method: "POST",
			parameters : {action : "saveGiacs316",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIACS316.exitPage != null) {
							objGIACS316.exitPage();
						} else {
							tbgDocSequenceUser._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiacs316);
	
	var objGIACS316 = {};
	var objCurrDocSequenceUser = null;
	objGIACS316.docSequenceUserList = [];
	objGIACS316.exitPage = null;
	
	var docSequenceUserTable = {
			url : contextPath + "/GIACDocSequenceUserController?action=showGiacs316&refresh=1&documentCd="+encodeURIComponent($F("txtDocumentCd"))+"&branchCd="+encodeURIComponent($F("txtBranchCd")),
			id : "tbl",
			options : {
				width : '900px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrDocSequenceUser = tbgDocSequenceUser.geniisysRows[y];
					setFieldValues(objCurrDocSequenceUser);
					tbgDocSequenceUser.keys.removeFocus(tbgDocSequenceUser.keys._nCurrentFocus, true);
					tbgDocSequenceUser.keys.releaseKeys();
					$("txtDocumentName").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgDocSequenceUser.keys.removeFocus(tbgDocSequenceUser.keys._nCurrentFocus, true);
					tbgDocSequenceUser.keys.releaseKeys();
					$("txtDocumentName").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgDocSequenceUser.keys.removeFocus(tbgDocSequenceUser.keys._nCurrentFocus, true);
						tbgDocSequenceUser.keys.releaseKeys();
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
					tbgDocSequenceUser.keys.removeFocus(tbgDocSequenceUser.keys._nCurrentFocus, true);
					tbgDocSequenceUser.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgDocSequenceUser.keys.removeFocus(tbgDocSequenceUser.keys._nCurrentFocus, true);
					tbgDocSequenceUser.keys.releaseKeys();
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
					tbgDocSequenceUser.keys.removeFocus(tbgDocSequenceUser.keys._nCurrentFocus, true);
					tbgDocSequenceUser.keys.releaseKeys();
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
					id: 'docCode',
					width: '0',
					visible: false
				},
				{
					id: 'branchCd',
					width: '0',
					visible: false
				},
				{
					id : "userCd",
					title : "Code",
					titleAlign: "right",
					align: "right",
					width : '80px',
					filterOption : true,
					filterOptionType: "integerNoNegative",
					renderer: function(value){
						return formatNumberDigits(value, 4);
					}
				},
				{
					id : 'userName',
					title : 'User Name',
					filterOption : true,
					width : '300px'				
				},
				{
					id : "docPref",
					title: "Doc Prefix",
					width : '120px',
					filterOption: true
				},
				{
					id : "minSeqNo",
					title: "Min. Sequence No.",
					titleAlign: "right",
					align: "right",
					width : '140px',
					filterOption: true,
					filterOptionType: "number"
				},
				{
					id : "maxSeqNo",
					title: "Max. Sequence No.",
					titleAlign: "right",
					align: "right",
					width : '140px',
					filterOption: true,
					filterOptionType: "number"
				},
				{
					id: 'activeTag',
              		title : 'Valid',
              		width: '55px',
              		filterOption: true,
	              	renderer: function(value){
	              		return (value == "Y" ? "Yes" : (value == "N" ? "No" : ""));
	              	}
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
				},
				{
					id : 'oldDocPref',
					width : '0',
					visible: false				
				},
				{
					id : 'oldMinSeqNo',
					width : '0',
					visible: false				
				},
				{
					id : 'oldMaxSeqNo',
					width : '0',
					visible: false				
				},
				{
					id : 'oldActiveTag',
					width : '0',
					visible: false				
				}
			],
			rows : objGIACS316.docSequenceUserList.rows || []
		};
	
	tbgDocSequenceUser = new MyTableGrid(docSequenceUserTable);
	tbgDocSequenceUser.pager = objGIACS316.docSequenceUserList;
	tbgDocSequenceUser.render("docSequenceUserTable");
	
	function setFieldValues(rec){
		try{
			$("txtUserCd").value = (rec == null ? "" : formatNumberDigits(rec.userCd, 4));
			$("txtUserCd").setAttribute("lastValidValue", (rec == null ? "" : formatNumberDigits(rec.userCd, 4)));
			$("txtUserName").value = (rec == null ? "" : unescapeHTML2(rec.userName));
			$("txtDocPrefix").value = (rec == null ? "" : unescapeHTML2(rec.docPref));
			$("hidOldDocPrefix").value = (rec == null ? "" : unescapeHTML2(rec.oldDocPref)); //rec.recordStatus == "" ? unescapeHTML2(rec.docPref) : unescapeHTML2(rec.oldDocPref));
			$("txtMinSeqNo").value = (rec == null ? "" : rec.minSeqNo);
			$("hidOldMinSeqNo").value = (rec == null ? "" : rec.oldMinSeqNo);
			$("txtMaxSeqNo").value = (rec == null ? "" : rec.maxSeqNo);
			$("hidOldMaxSeqNo").value = (rec == null ? "" : rec.oldMaxSeqNo);
			$("selActiveTag").value = (rec == null ? "Y" : rec.activeTag == null ? "" : rec.activeTag);
			$("hidOldActiveTag").value = (rec == null ? "" : rec.oldActiveTag);
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			$("txtDocPrefix").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.docPref)));
			$("txtMinSeqNo").setAttribute("lastValidValue", (rec == null ? "" : rec.minSeqNo));
			$("txtMaxSeqNo").setAttribute("lastValidValue", (rec == null ? "" : rec.maxSeqNo));
			$("selActiveTag").setAttribute("lastValidValue", (rec == null ? "Y" : rec.activeTag == null ? "" : rec.activeTag));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtUserCd").readOnly = false : $("txtUserCd").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			rec == null ? enableSearch("osUserCd") : disableSearch("osUserCd");
			
			objCurrDocSequenceUser = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.docCode = escapeHTML2($F("txtDocumentCd"));
			obj.branchCd = escapeHTML2($F("txtBranchCd"));
			obj.userCd = $F("txtUserCd");
			obj.userName = escapeHTML2($F("txtUserName"));
			obj.docPref = escapeHTML2($F("txtDocPrefix"));
			obj.oldDocPref = escapeHTML2($F("hidOldDocPrefix"));
			obj.minSeqNo = $F("txtMinSeqNo");
			obj.oldMinSeqNo = $F("hidOldMinSeqNo");
			obj.maxSeqNo = $F("txtMaxSeqNo");
			obj.oldMaxSeqNo = $F("hidOldMaxSeqNo");
			obj.activeTag = escapeHTML2($F("selActiveTag"));
			obj.oldActiveTag = escapeHTML2($F("hidOldActiveTag"));
			obj.remarks = escapeHTML2($F("txtRemarks"));
			
			obj.userId = escapeHTML2(userId);
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGiacs316;
			var dept = setRec(objCurrDocSequenceUser);
			
			if($F("btnAdd") == "Add"){
				tbgDocSequenceUser.addBottomRow(dept);
			} else {
				tbgDocSequenceUser.updateVisibleRowOnly(dept, rowIndex, false);
				rowIndex = -1;
			}
			changeTag = 1;
			setFieldValues(null);
			tbgDocSequenceUser.keys.removeFocus(tbgDocSequenceUser.keys._nCurrentFocus, true);
			tbgDocSequenceUser.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}
	
	function valAddRec(){
		isInvalidRecord = false;
		try{
			if(checkAllRequiredFieldsInDiv("docSequenceUserFormDiv")){
				validateMinSeqNo();
				validateMaxSeqNo();
				validateActiveTag(null);
				if(!isInvalidRecord){
					addRec();	
				}
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}
	
	function deleteRec(){
		changeTagFunc = saveGiacs316;
		objCurrDocSequenceUser.recordStatus = -1;
		tbgDocSequenceUser.geniisysRows[rowIndex].docCode = escapeHTML2(tbgDocSequenceUser.geniisysRows[rowIndex].docCode);
		tbgDocSequenceUser.geniisysRows[rowIndex].branchCd = escapeHTML2(tbgDocSequenceUser.geniisysRows[rowIndex].branchCd);
		tbgDocSequenceUser.geniisysRows[rowIndex].docPref = escapeHTML2(tbgDocSequenceUser.geniisysRows[rowIndex].docPref);
		tbgDocSequenceUser.deleteRow(rowIndex);	
		changeTag = 1;		
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIACDocSequenceUserController", {
				parameters : {action : "valDeleteRec",
							  docCode : $F("txtDocumentCd"),
					  		  branchCd: $F("txtBranchCd"),
							  userCd : $F("txtUserCd"),
							  docPref: $F("txtDocPrefix") != $F("hidOldDocPrefix") ? $F("hidOldDocPrefix") : $F("txtDocPrefix"),
							  minSeqNo : $F("txtMinSeqNo") != $F("hidOldMinSeqNo") ? $F("hidOldMinSeqNo") : $F("txtMinSeqNo"),
							  maxSeqNo : $F("txtMaxSeqNo") != $F("hidOldMaxSeqNo") ? $F("hidOldMaxSeqNo") : $F("txtMaxSeqNo")},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						deleteRec();
					}
				}
			});
		} catch(e){
			showErrorMessage("valDeleteRec", e);
		}
	}
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	}	
	
	function cancelGiacs316(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIACS316.exitPage = exitPage;
						saveGiacs316();
					}, function(){
						goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		}
	}
	
	function showGiacs316DocumentCdLOV(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getCgRefCodeLOV4",
							domain: "GIAC_DOC_SEQUENCE_USER.DOC_CODE",
							filterText : ($("txtDocumentCd").readAttribute("lastValidValue").trim() != $F("txtDocumentCd").trim() ? $F("txtDocumentCd").trim() : ""),
							page : 1},
			title: "List of Documents",
			width: 430,
			height: 400,
			columnModel : [
							{
								id : "rvLowValue",
								title: "Document Code",
								width: '100px',
								filterOption: true,
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							},
							{
								id : "rvMeaning",
								title: "Document Name",
								width: '300px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("txtDocumentCd").readAttribute("lastValidValue").trim() != $F("txtDocumentCd").trim() ? $F("txtDocumentCd").trim() : ""),
				onSelect: function(row) {
					$("txtDocumentCd").value = unescapeHTML2(row.rvLowValue);
					$("txtDocumentCd").setAttribute("lastValidValue", unescapeHTML2(row.rvLowValue));
					$("txtDocumentName").value = unescapeHTML2(row.rvMeaning).toUpperCase();
					$("txtBranchCd").readOnly = false;
					enableSearch("osBranchCd");
					enableToolbarButton("btnToolbarEnterQuery");
					$("txtBranchCd").focus();
				},
				onCancel: function (){
					$("txtDocumentCd").value = $("txtDocumentCd").readAttribute("lastValidValue");
					if($F("txtDocumentCd").trim() == ""){
						$("txtBranchCd").readOnly = true;
						disableSearch("osBranchCd");
					} else {
						$("txtBranchCd").readOnly = false;
						enableSearch("osBranchCd");
					}
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtDocumentCd").value = $("txtDocumentCd").readAttribute("lastValidValue");
					if($F("txtDocumentCd").trim() == ""){
						$("txtBranchCd").readOnly = true;
						disableSearch("osBranchCd");
					} else {
						$("txtBranchCd").readOnly = false;
						enableSearch("osBranchCd");
					}
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	function showGiacs316BranchCdLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : "getGiacs316BranchLOV",
							docCode : $F("txtDocumentCd"),
							filterText : ($("txtBranchCd").readAttribute("lastValidValue").trim() != $F("txtBranchCd").trim() ? $F("txtBranchCd").trim() : "%"),
							moduleId: "GIACS316",
							page : 1},
			title: "List of Branches",
			width: 440,
			height: 400,
			columnModel : [
							{
								id : "issCd",
								title: "Branch Code",
								width: '100px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							},
							{
								id : "issName",
								title: "Branch Name",
								width: '300px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							},
							{
								id: "docType",
								width: "0",
								visible: false
							},	
							{
								id: "docTypeMean",
								width: "0",
								visible: false
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("txtBranchCd").readAttribute("lastValidValue").trim() != $F("txtBranchCd").trim() ? $F("txtBranchCd").trim() : "%"),
				onSelect: function(row) {
					enableToolbarButton("btnToolbarExecuteQuery");
					$("txtBranchCd").value = unescapeHTML2(row.issCd);
					$("txtBranchCd").setAttribute("lastValidValue", unescapeHTML2(row.issCd));
					$("txtBranchName").value = unescapeHTML2(row.issName);
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
	
	function showGiacs316UserCdLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : "getGiacs316UserCdLOV",
							branchCd : $F("txtBranchCd"),
							filterText : ($("txtUserCd").readAttribute("lastValidValue").trim() != $F("txtUserCd").trim() ? $F("txtUserCd").trim() : "%"),
							page : 1},
			title: "List of Document Sequence Users",
			width: 440,
			height: 400,
			columnModel : [
							{
								id : "cashierCd",
								title: "Code",
								titleAlign: "right",
								align: "right",
								width: '100px'
							},
							{
								id : "dcbUserId",
								title: "User Name",
								width: '320px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("txtUserCd").readAttribute("lastValidValue").trim() != $F("txtUserCd").trim() ? $F("txtUserCd").trim() : "%"),
				onSelect: function(row) {
					$("txtUserCd").value = formatNumberDigits(row.cashierCd, 4);
					$("txtUserCd").setAttribute("lastValidValue", formatNumberDigits(row.cashierCd, 4));
					$("txtUserName").value = unescapeHTML2(row.dcbUserId).toUpperCase();	
					$("txtDocPrefix").focus();
				},
				onCancel: function (){
					$("txtUserCd").value = $("txtUserCd").readAttribute("lastValidValue") == "" ? "" : formatNumberDigits($("txtUserCd").readAttribute("lastValidValue"), 4);
					$("txtUserCd").focus();
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtUserCd").value = $("txtUserCd").readAttribute("lastValidValue") == "" ? "" : formatNumberDigits($("txtUserCd").readAttribute("lastValidValue"), 4);
					$("txtUserCd").focus();
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	function setForm(enable){
		if(enable){
			$("txtUserCd").readOnly = false;
			$("txtDocPrefix").readOnly = false;
			$("txtMinSeqNo").readOnly = false;
			$("txtMaxSeqNo").readOnly = false;
			$("selActiveTag").disabled = false;
			$("txtRemarks").readOnly = false;
			enableButton("btnAdd");
			enableSearch("osUserCd");
		} else {
			$("txtUserCd").readOnly = true;
			$("txtDocPrefix").readOnly = true;
			$("txtMinSeqNo").readOnly = true;
			$("txtMaxSeqNo").readOnly = true;
			$("selActiveTag").disabled = true;
			$("txtRemarks").readOnly = true;
			disableButton("btnAdd");
			disableButton("btnDelete");
			disableSearch("osUserCd");
		}
	}
	
	function executeQuery(){
		if(checkAllRequiredFieldsInDiv("searchDocBranchCd")) {
			tbgDocSequenceUser.url = contextPath + "/GIACDocSequenceUserController?action=showGiacs316&refresh=1&docCode="+encodeURIComponent($F("txtDocumentCd"))+"&branchCd="+encodeURIComponent($F("txtBranchCd"));
			tbgDocSequenceUser._refreshList();
			setForm(true);
			disableToolbarButton("btnToolbarExecuteQuery");
			$("txtDocumentCd").readOnly = true;
			$("txtBranchCd").readOnly = true;
			disableSearch("osDocumentCd");
			disableSearch("osBranchCd");
			$("txtUserCd").focus();
		}
	}
	
	function enterQuery(){
		function proceedEnterQuery(){
			if($F("txtDocumentCd").trim() != "" || $F("txtBranchCd").trim() != "") {
				disableToolbarButton("btnToolbarExecuteQuery");
				$("txtDocumentCd").value = "";
				$("txtDocumentCd").setAttribute("lastValidValue", "");
				$("txtDocumentCd").value = "";
				$("txtDocumentName").value = "";
				$("txtDocumentCd").readOnly = false;
				enableSearch("osDocumentCd");
				
				$("txtBranchCd").value = "";
				$("txtBranchCd").setAttribute("lastValidValue", "");
				$("txtBranchCd").value = "";
				$("txtBranchName").value = "";
				$("txtBranchCd").readOnly = true;
				disableSearch("osBranchCd");
				
				tbgDocSequenceUser.url = contextPath + "/GIACDocSequenceUserController?action=showGiacs316&refresh=1";
				tbgDocSequenceUser._refreshList();
				disableToolbarButton("btnToolbarEnterQuery");
				setFieldValues(null);
				$("txtDocumentCd").focus();
				setForm(false);
				changeTag = 0;
			}
		}
		
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveGiacs316();
						proceedEnterQuery();
					}, function(){
						proceedEnterQuery();
					}, "");
		} else {
			proceedEnterQuery();
		}		
	}
	
	function proceedToValidateMinSeqNo(mode){
		try {
			new Ajax.Request(contextPath + "/GIACDocSequenceUserController", {
				parameters : {action 	: "validateMinSeqNo",
							  docCode 	: $F("txtDocumentCd"),
					  		  branchCd	: $F("txtBranchCd"),
							  userCd 	: $F("txtUserCd"),
							  docPref	: $F("txtDocPrefix"),
							  minSeqNo 	: $F("txtMinSeqNo"),
							  maxSeqNo 	: $F("txtMaxSeqNo"),
							  oldMinSeqNo 	: $F("hidOldMinSeqNo")
						 	  /*docCode 	:  mode == "Add" ? $F("txtDocumentCd") : null,
					  		  branchCd	: mode == "Add" ? $F("txtBranchCd") : null,
							  userCd 	: mode == "Add" ? $F("txtUserCd") : null,
							  docPref	: mode == "Add" ? $F("txtDocPrefix") : null,
							  minSeqNo 	: mode == "Add" ? $F("txtMinSeqNo") : null,
						 	  maxSeqNo 	: mode == "Add" ? $F("txtMaxSeqNo") : null*/
							},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						//isInvalidRecord = true;
					} else {
						isInvalidRecord = true;
						$("txtMinSeqNo").value = $("txtMinSeqNo").readAttribute("lastValidValue");
						$("txtMinSeqNo").focus();
					}
				}
			});
		} catch(e){
			showErrorMessage("proceedToValidateMinSeqNo", e);
		}
	}
	
	function validateMinSeqNo(){
		function valFieldMinSeqNo(mode){
			var isValidMin = true;
			var oldMax = parseInt($F("hidOldMaxSeqNo"));
			var currMax = parseInt($F("txtMaxSeqNo"));
			var currMin	= parseInt($F("txtMinSeqNo"));
			var oldMin = parseInt($F("hidOldMinSeqNo"));
			var isDeleted = false;
			var noDBVal = false;
			
			for(var i=0; i<tbgDocSequenceUser.geniisysRows.length; i++){
				if(tbgDocSequenceUser.geniisysRows[i].recordStatus == 0 || tbgDocSequenceUser.geniisysRows[i].recordStatus == 1){
					if(unescapeHTML2(tbgDocSequenceUser.geniisysRows[i].docCode) == $F("txtDocumentCd") && unescapeHTML2(tbgDocSequenceUser.geniisysRows[i].branchCd) == $F("txtBranchCd")
							&& unescapeHTML2(tbgDocSequenceUser.geniisysRows[i].docPref) == $F("txtDocPrefix")){
						
						if(rowIndex != i){
							if((tbgDocSequenceUser.geniisysRows[i].minSeqNo >= currMin && tbgDocSequenceUser.geniisysRows[i].minSeqNo <= currMax) &&
									(tbgDocSequenceUser.geniisysRows[i].maxSeqNo >= currMin && tbgDocSequenceUser.geniisysRows[i].maxSeqNo <= currMax)){
					  		
					  			if(($F("hidOldMinSeqNo") == "" && currMin != tbgDocSequenceUser.geniisysRows[i].minSeqNo) || ($F("hidOldMinSeqNo") != "" && tbgDocSequenceUser.geniisysRows[i].oldMinSeqNo != oldMin)){ // minseqno != oldmin
					  					isValidMin = false;
					  					break;
					  			}
					  			
							} else if(currMin > oldMin && (currMin <= currMax || currMin <= oldMax)){
				  				noDBVal = true;
				  			} else if($F("txtMaxSeqNo") == "" && tbgDocSequenceUser.geniisysRows[i].minSeqNo <= currMin && currMin <= tbgDocSequenceUser.geniisysRows[i].maxSeqNo){
								isValidMin = false;
								break;
							}
					  		
					  		if(tbgDocSequenceUser.geniisysRows[i].oldMinSeqNo < tbgDocSequenceUser.geniisysRows[i].minSeqNo 
				  					&& currMin >= tbgDocSequenceUser.geniisysRows[i].oldMinSeqNo && currMin < tbgDocSequenceUser.geniisysRows[i].minSeqNo) { 
				  				noDBVal = true;
				  			}
					  		if(/*tbgDocSequenceUser.geniisysRows[i].oldMinSeqNo > tbgDocSequenceUser.geniisysRows[i].minSeqNo 
				  					&&*/ currMin <= tbgDocSequenceUser.geniisysRows[i].oldMinSeqNo && currMin < tbgDocSequenceUser.geniisysRows[i].minSeqNo) { 
				  				if($F("hidOldMinSeqNo") != "" && tbgDocSequenceUser.geniisysRows[i].recordStatus == 0) {
				  					noDBVal = true;
				  				}
				  			}
					  		if(tbgDocSequenceUser.geniisysRows[i].oldMaxSeqNo > tbgDocSequenceUser.geniisysRows[i].maxSeqNo 
				  					&& currMin <= tbgDocSequenceUser.geniisysRows[i].oldMaxSeqNo && currMin > tbgDocSequenceUser.geniisysRows[i].maxSeqNo) { 
				  				noDBVal = true;
				  			}	
						}
					}
					
				} else if(tbgDocSequenceUser.geniisysRows[i].recordStatus == -1){
					if(unescapeHTML2(tbgDocSequenceUser.geniisysRows[i].docCode) == $F("txtDocumentCd") && unescapeHTML2(tbgDocSequenceUser.geniisysRows[i].branchCd) == $F("txtBranchCd")
							&& unescapeHTML2(tbgDocSequenceUser.geniisysRows[i].docPref) == $F("txtDocPrefix") ){
							//isDeleted = true;
						if(tbgDocSequenceUser.geniisysRows[i].minSeqNo == currMin && tbgDocSequenceUser.geniisysRows[i].maxSeqNo >= currMax){
							isDeleted = true;
				  			//break;
						} else if((tbgDocSequenceUser.geniisysRows[i].minSeqNo >= currMin && tbgDocSequenceUser.geniisysRows[i].minSeqNo <= currMax) ||
								(tbgDocSequenceUser.geniisysRows[i].maxSeqNo >= currMin && tbgDocSequenceUser.geniisysRows[i].maxSeqNo <= currMax)){
				  			if(tbgDocSequenceUser.geniisysRows[i].minSeqNo != oldMin){
				  				isDeleted = true;
					  			//break;
				  			}
						} else if($F("txtMaxSeqNo") == "" && tbgDocSequenceUser.geniisysRows[i].minSeqNo <= currMin && currMin <= tbgDocSequenceUser.geniisysRows[i].maxSeqNo){
							isDeleted = true;
							//break;
						}
					}
				}
			}
			if(isValidMin){
				if(!isDeleted && !noDBVal){
					proceedToValidateMinSeqNo(mode);	
				}				
			} else {
				$("txtMinSeqNo").value = $("txtMinSeqNo").readAttribute("lastValidValue");
				customShowMessageBox("Sequence number is already used.", "E", "txtMinSeqNo");
				isInvalidRecord = true;
			}
		}

		// added only in web to inform user that Doc Prefix is needed before validating min_seq_no and max_seq_no
		if($F("txtDocPrefix").trim() == ""){
			$("txtMinSeqNo").clear();
			customShowMessageBox("Please enter Doc Prefix first.", "I", "txtDocPrefix");
			return;
		}
		if($F("txtMinSeqNo").trim() == ""){ return; }
		
		if($F("txtMaxSeqNo").trim() != "" && $F("txtMinSeqNo").trim() != ""){
			var min = parseInt($F("txtMinSeqNo"));
			var max = parseInt($F("txtMaxSeqNo"));
			
			if(min > max){
				$("txtMinSeqNo").value = $("txtMinSeqNo").readAttribute("lastValidValue");
				customShowMessageBox("Maximum Sequence Number should be greater than Minimum Sequence Number.", "E", "txtMinSeqNo");
				return;
			}
		}
		
		if($F("btnAdd") == "Update" && ($F("hidOldMinSeqNo") != $F("txtMinSeqNo") || $F("hidOldDocPrefix") != $F("txtDocPrefix"))){  // minSeqNo or docPref has changed
			valFieldMinSeqNo("Update");
		} else if($F("btnAdd") == "Add"){
			valFieldMinSeqNo("Add");
		}
	}	
	
	function proceedToValidateMaxSeqNo(mode){
		try {
			new Ajax.Request(contextPath + "/GIACDocSequenceUserController", {
				parameters : {action : "validateMaxSeqNo",
							  docCode 	: $F("txtDocumentCd"),
					  		  branchCd	: $F("txtBranchCd"),
							  userCd 	: $F("txtUserCd"),
							  docPref	: $F("txtDocPrefix"),
							  minSeqNo 	: $F("txtMinSeqNo"),
							  maxSeqNo 	: $F("txtMaxSeqNo"),
							  oldMaxSeqNo: $F("hidOldMaxSeqNo")
							/*  docCode 	: mode == "Add" ? $F("txtDocumentCd") : null,
					  		  branchCd	: mode == "Add" ? $F("txtBranchCd") : null,
							  userCd 	: mode == "Add" ? $F("txtUserCd") : null,
							  docPref	: mode == "Add" ? $F("txtDocPrefix") : null,
							  minSeqNo 	: mode == "Add" ? $F("txtMinSeqNo") : null,
							  maxSeqNo 	: $F("txtMaxSeqNo")	 */ 
						}, //mode == "Add" ? $F("txtMaxSeqNo") : null},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						//isInvalidRecord = true;
					} else {
						isInvalidRecord = true;
						$("txtMaxSeqNo").value = $("txtMaxSeqNo").readAttribute("lastValidValue");
						$("txtMaxSeqNo").focus();						
					}
				}
			});
		} catch(e){
			showErrorMessage("proceedToValidateMaxSeqNo", e);
		}
	}
	function validateMaxSeqNo(){
		function valFieldMaxSeqNo(){
			var mode = $F("btnAdd");
			var isValidMax = true;
			var noDBVal = false;
			var oldMax = parseInt($F("hidOldMaxSeqNo"));
			var currMax = parseInt($F("txtMaxSeqNo"));
			var currMin	= parseInt($F("txtMinSeqNo"));
			var oldMin = parseInt($F("hidOldMinSeqNo"));
			var isDeleted = false;
			for(var i=0; i<tbgDocSequenceUser.geniisysRows.length; i++){
				if(tbgDocSequenceUser.geniisysRows[i].recordStatus == 0 || tbgDocSequenceUser.geniisysRows[i].recordStatus == 1){
					if(unescapeHTML2(tbgDocSequenceUser.geniisysRows[i].docCode) == $F("txtDocumentCd") && unescapeHTML2(tbgDocSequenceUser.geniisysRows[i].branchCd) == $F("txtBranchCd")
							&& unescapeHTML2(tbgDocSequenceUser.geniisysRows[i].docPref) == $F("txtDocPrefix")){
						  		
						if(rowIndex != i){
							if((tbgDocSequenceUser.geniisysRows[i].minSeqNo >= currMin && tbgDocSequenceUser.geniisysRows[i].minSeqNo <= currMax) &&
									(tbgDocSequenceUser.geniisysRows[i].maxSeqNo >= currMin && tbgDocSequenceUser.geniisysRows[i].maxSeqNo <= currMax)){
					  		
								if(($F("hidOldMaxSeqNo") == "" && currMax != tbgDocSequenceUser.geniisysRows[i].maxSeqNo) || ($F("hidOldMaxSeqNo") != "" && tbgDocSequenceUser.geniisysRows[i].oldMaxSeqNo != oldMax)){ // maxseqno != oldMax
					  				isValidMax = false;
					  				break;
					  			}
							} else if(currMax < oldMax && (currMin <= currMax || currMin <= oldMax)){
				  				noDBVal = true;
				  			} else if($F("txtMinSeqNo") == "" && tbgDocSequenceUser.geniisysRows[i].minSeqNo <= currMax && currMax <= tbgDocSequenceUser.geniisysRows[i].maxSeqNo){
								isValidMax = false; //mode == "Update" ? true : false;
								break;
							}
							
					  		if(tbgDocSequenceUser.geniisysRows[i].oldMinSeqNo < tbgDocSequenceUser.geniisysRows[i].minSeqNo 
				  					&& currMax >= tbgDocSequenceUser.geniisysRows[i].oldMinSeqNo 
				  					&& currMax < tbgDocSequenceUser.geniisysRows[i].minSeqNo) { 
				  				noDBVal = true;
				  			}
					  		if(/*tbgDocSequenceUser.geniisysRows[i].oldMinSeqNo > tbgDocSequenceUser.geniisysRows[i].minSeqNo 
				  					&&*/ currMax <= tbgDocSequenceUser.geniisysRows[i].oldMinSeqNo && currMin < tbgDocSequenceUser.geniisysRows[i].minSeqNo) { 
				  				if($F("hidOldMinSeqNo") != "" && tbgDocSequenceUser.geniisysRows[i].recordStatus == 0) {noDBVal = true;}
				  			}
					  		if(tbgDocSequenceUser.geniisysRows[i].oldMaxSeqNo > tbgDocSequenceUser.geniisysRows[i].maxSeqNo 
				  					&& currMax >= tbgDocSequenceUser.geniisysRows[i].oldMaxSeqNo && currMax < tbgDocSequenceUser.geniisysRows[i].maxSeqNo) { 
				  				noDBVal = true;
				  			}
						}
														  		
					}
				}else if(tbgDocSequenceUser.geniisysRows[i].recordStatus == -1){
					if((tbgDocSequenceUser.geniisysRows[i].minSeqNo >= currMin && tbgDocSequenceUser.geniisysRows[i].minSeqNo <= currMax) ||
							(tbgDocSequenceUser.geniisysRows[i].maxSeqNo >= currMin && tbgDocSequenceUser.geniisysRows[i].maxSeqNo <= currMax)){
			  			if(tbgDocSequenceUser.geniisysRows[i].maxSeqNo != oldMax){
			  				isDeleted = true;
			  				//break;
			  			}
					} else if($F("txtMinSeqNo") == "" && tbgDocSequenceUser.geniisysRows[i].minSeqNo <= currMax && currMax <= tbgDocSequenceUser.geniisysRows[i].maxSeqNo){
						isDeleted = true;
						break;
					}
				}
			}
			if(isValidMax){
				if(!isDeleted && !noDBVal){
					proceedToValidateMaxSeqNo(mode);
				}
			} else {
	  			$("txtMaxSeqNo").value = $("txtMaxSeqNo").readAttribute("lastValidValue");
	  			isInvalidRecord = true;
				customShowMessageBox("Sequence number is already used.", "E", "txtMaxSeqNo");	
			}
		}
		
		// added only in web to inform user that Doc Prefix is needed before validating min_seq_no and max_seq_no
		if($F("txtDocPrefix").trim() == ""){
			$("txtMaxSeqNo").clear();
			customShowMessageBox("Please enter Doc Prefix first.", "I", "txtDocPrefix");
			return;
		}
		if($F("txtMaxSeqNo").trim() == ""){
			return;
		}
		
		var oldMax = parseInt($F("hidOldMaxSeqNo"));
		var currMax = parseInt($F("txtMaxSeqNo"));
		var currMin	= parseInt($F("txtMinSeqNo"));
		var oldMin = parseInt($F("hidOldMinSeqNo"));
		
		if($F("btnAdd") == "Update" && oldMax != currMax){
			if( currMax < currMin ){
				$("txtMaxSeqNo").value = $("txtMaxSeqNo").readAttribute("lastValidValue");
				customShowMessageBox("Maximum Sequence Number should be greater than Minimum Sequence Number.", "E", "txtMaxSeqNo");
				return;
			}
			if(		!(currMax >= oldMin && currMax <= oldMax)	){ //if((currMax < oldMin) || (currMax > oldMax)){	//
				valFieldMaxSeqNo();
			}
		} else if($F("btnAdd") == "Add"){
			if( currMax < currMin ){
				$("txtMaxSeqNo").value = $("txtMaxSeqNo").readAttribute("lastValidValue");
				customShowMessageBox("Maximum Sequence Number should be greater than Minimum Sequence Number.", "E", "txtMaxSeqNo");
				return;
			}
			valFieldMaxSeqNo();
		}
	}
	
	function proceedToValidateActiveTag(){
		var mode = $F("btnAdd");
		try {
			new Ajax.Request(contextPath + "/GIACDocSequenceUserController", {
				parameters : {action : "validateActiveTag",
							  /*docCode 	: mode == "Add" ? $F("txtDocumentCd") : null,
					  		  branchCd	: mode == "Add" ? $F("txtBranchCd") : null,
							  userCd 	: mode == "Add" ? $F("txtUserCd") : null,
							  docPref	: mode == "Add" ? $F("txtDocPrefix") : null, //$F("hidOldDocPrefix") != $F("txtDocPrefix") ? $F("txtDocPrefix") : null,
							  minSeqNo 	: mode == "Add" ? $F("txtMinSeqNo") : null, //$F("hidOldMinSeqNo") != $F("txtMinSeqNo") ? $F("txtMinSeqNo") : null,
							  maxSeqNo 	: mode == "Add" ? $F("txtMaxSeqNo") : null,*/ //$F("hidOldMaxSeqNo") != $F("txtMaxSeqNo") ? $F("txtMaxSeqNo") : null,
							  docCode 	: $F("txtDocumentCd"),
					  		  branchCd	: $F("txtBranchCd"),
							  userCd 	: $F("txtUserCd"),
							  docPref	: $F("txtDocPrefix"),
							  minSeqNo 	: $F("txtMinSeqNo"),
							  maxSeqNo 	: $F("txtMaxSeqNo"),
							  oldMinSeqNo: $F("hidOldMinSeqNo"),
							  oldMaxSeqNo: $F("hidOldMaxSeqNo"),
							  option 	: mode == "Add" ? 2 : 1},
				asynchronous: false,
				evalScripts: true,
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						
					} else {
						isInvalidRecord = true;
						$("selActiveTag").value = $("selActiveTag").readAttribute("lastValidValue");
						/*if($F("selActiveTag") == "Y"){
							$("selActiveTag").value = "N";	
						}*/
					}
				}
			});
		} catch(e){
			showErrorMessage("proceedToValidateActiveTag", e);
		}
	}
	
	function validateActiveTag(field){
		
		if(rowIndex != -1 && tbgDocSequenceUser.geniisysRows[rowIndex].activeTag == $F("selActiveTag"))
			return;
		
		function valFieldActiveTag(field){
			var hasActiveSeries = false;
			var changedYtoN = false;
			var isDeleted = false;
			var mode = $F("btnAdd");
			
			for(var i=0; i<tbgDocSequenceUser.geniisysRows.length; i++){
				if(tbgDocSequenceUser.geniisysRows[i].recordStatus == 0 || tbgDocSequenceUser.geniisysRows[i].recordStatus == 1){
					if(unescapeHTML2(tbgDocSequenceUser.geniisysRows[i].docCode) == $F("txtDocumentCd") && unescapeHTML2(tbgDocSequenceUser.geniisysRows[i].branchCd) == $F("txtBranchCd")					
							&& tbgDocSequenceUser.geniisysRows[i].userCd == parseInt($F("txtUserCd")) 
							&& unescapeHTML2(tbgDocSequenceUser.geniisysRows[i].docPref) == $F("txtDocPrefix") 
							/*&& unescapeHTML2(tbgDocSequenceUser.geniisysRows[i].activeTag) == "Y" */){
						
						if(unescapeHTML2(tbgDocSequenceUser.geniisysRows[i].activeTag) == "Y" ){
							if($F("selActiveTag") == "Y"){
								if($F("txtMinSeqNo").trim() == "" || $F("txtMaxSeqNo").trim() == ""){
									hasActiveSeries = true;
									break;
								}
								if(tbgDocSequenceUser.geniisysRows[i].minSeqNo != parseInt($F("txtMinSeqNo")) || tbgDocSequenceUser.geniisysRows[i].maxSeqNo != parseInt($F("txtMaxSeqNo"))){
									if(tbgDocSequenceUser.geniisysRows[i].oldMinSeqNo != parseInt($F("hidOldMinSeqNo")) // minseqno != hidoldminseqno
											&& tbgDocSequenceUser.geniisysRows[i].oldMaxSeqNo != parseInt($F("hidOldMaxSeqNo"))){ // maxseqno != hidoldmaxseqno
										hasActiveSeries = true;
										break;
									}
								}
							}
						} else {
							if(tbgDocSequenceUser.geniisysRows[i].oldActiveTag == "Y"){
								changedYtoN = true;
							}
						}						
					}					
				} else if(tbgDocSequenceUser.geniisysRows[i].recordStatus == -1){
					if(unescapeHTML2(tbgDocSequenceUser.geniisysRows[i].docCode) == $F("txtDocumentCd") && unescapeHTML2(tbgDocSequenceUser.geniisysRows[i].branchCd) == $F("txtBranchCd")					
							&& tbgDocSequenceUser.geniisysRows[i].userCd == parseInt($F("txtUserCd")) 
							&& unescapeHTML2(tbgDocSequenceUser.geniisysRows[i].docPref) == $F("txtDocPrefix") ){
						
						if(tbgDocSequenceUser.geniisysRows[i].activeTag == "Y" || tbgDocSequenceUser.geniisysRows[i].oldActiveTag == "Y"){
							isDeleted = true;
							break;
						}
					}
				}
			}
			
			if(hasActiveSeries){
				isInvalidRecord = true;
				$("selActiveTag").value = $("selActiveTag").readAttribute("lastValidValue");
				showMessageBox("User still has active sequence series.", "E");
				$(field).clear();
				return;
			}
			if(!hasActiveSeries && $F("selActiveTag") == "Y" && !changedYtoN && !isDeleted){
				proceedToValidateActiveTag();
			}
		}
		
		valFieldActiveTag(field);		
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("osDocumentCd").observe("click", showGiacs316DocumentCdLOV);
	$("txtDocumentCd").observe("change", function() {		
		if($F("txtDocumentCd").trim() == "") {
			$("txtDocumentCd").value = "";
			$("txtDocumentCd").setAttribute("lastValidValue", "");
			$("txtDocumentName").value = "";
			
			$("txtBranchCd").value = "";
			$("txtBranchCd").setAttribute("lastValidValue", "");
			$("txtBranchCd").readOnly = true;
			$("txtBranchName").value = "";
			disableSearch("osBranchCd");
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
		} else {
			if($F("txtDocumentCd").trim() != "" && $F("txtDocumentCd") != $("txtDocumentCd").readAttribute("lastValidValue")) {
				showGiacs316DocumentCdLOV();
			}
		}
	});
	
	$("osBranchCd").observe("click", showGiacs316BranchCdLOV);
	$("txtBranchCd").observe("change", function() {		
		if($F("txtBranchCd").trim() == "") {
			$("txtBranchCd").value = "";
			$("txtBranchCd").setAttribute("lastValidValue", "");
			$("txtBranchName").value = "";
			disableToolbarButton("btnToolbarExecuteQuery");
		} else {
			if($F("txtBranchCd").trim() != "" && $F("txtBranchCd") != $("txtBranchCd").readAttribute("lastValidValue")) {
				showGiacs316BranchCdLOV();
			}
		}
	});
	
	$("osUserCd").observe("click", showGiacs316UserCdLOV);
	$("txtUserCd").observe("change", function() {		
		if($F("txtUserCd").trim() == "") {
			$("txtUserCd").value = "";
			$("txtUserCd").setAttribute("lastValidValue", "");
			$("txtUserName").value = "";
		} else {
			if($F("txtUserCd").trim() != "" && $F("txtUserCd") != $("txtUserCd").readAttribute("lastValidValue")) {
				showGiacs316UserCdLOV();
			}
		}
	});
	
	// validation upon change of doc_pref is added in web.
	$("txtDocPrefix").observe("change", function(){
		/* if($F("txtDocPrefix") != ""){
			if($F("txtMinSeqNo") != "" && $F("txtMaxSeqNo").trim() != ""){
				validateMinSeqNo();
				validateMaxSeqNo();
				validateActiveTag("txtDocPrefix");
			} else {
				validateActiveTag("txtDocPrefix");
			} 
		} */
		
		$("txtMinSeqNo").clear();
		$("txtMaxSeqNo").clear();
		$("txtMinSeqNo").setAttribute("lastValidValue", "");
		$("txtMaxSeqNo").setAttribute("lastValidValue", "");
		validateActiveTag("txtDocPrefix");
	});
	
	$("txtMinSeqNo").observe("change", validateMinSeqNo);
	$("txtMaxSeqNo").observe("change", validateMaxSeqNo);
	
	$("selActiveTag").observe("change", function(){
		if($F("selActiveTag") == "Y" /*&& $F("txtMinSeqNo") != "" && $F("txtMaxSeqNo") != ""*/){
			validateActiveTag(null);
		}
	});
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGiacs316);
	observeSaveForm("btnToolbarSave", saveGiacs316);
	$("btnCancel").observe("click", cancelGiacs316);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);
	
	$("btnToolbarExecuteQuery").observe("click", executeQuery);
	$("btnToolbarEnterQuery").observe("click", enterQuery);	
	$("btnToolbarExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	$$("input[name='chng']").each(function(a) {
		a.observe("focus", function() {
			a.setAttribute("lastValidValue", unescapeHTML2($F(a)));
		});
	});
	
	$("txtDocumentCd").focus();	
	$("txtBranchCd").readOnly = true;
	disableSearch("osBranchCd");
	$("txtUserCd").readOnly = true;
	disableSearch("osUserCd");
</script>