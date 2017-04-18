<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss016MainDiv" name="giiss016MainDiv" style="">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="btnExit">Exit</a></li>
			</ul>
		</div>
	</div>

	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Notary Public Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss016" name="giiss016">		
		<div class="sectionDiv">
			<div id="notaryPublicTableDiv" style="padding-top: 10px;">
				<div id="notaryPublicTable" style="height: 331px; margin-left: 40px;"></div>
			</div>
			<div align="center" id="notaryPublicFormDiv">
				<table style="margin-top: 5px;" border="0">
					<tr>
						<td class="rightAligned">Code</td>
						<td class="leftAligned">
							<input id="txtNpNo" type="text" class="integerNoNegativeUnformatted" style="width: 200px; margin: 0; text-align: right; margin: 0;" tabindex="201" maxlength="4" readonly="readonly">
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Notary Public</td>
						<td class="leftAligned" colspan="3">
							<input id="txtNpName" type="text" class="required" style="margin: 0; width: 533px;" tabindex="203" maxlength="50">
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">PTR No.</td>
						<td class="leftAligned">
							<input id="txtPtrNo" type="text" class="required" style="width: 200px; margin: 0;" tabindex="204" maxlength="15">
						</td>
						<td width="" class="rightAligned">Issued At</td>
						<td class="leftAligned">
							<input id="txtPlaceIssue" type="text" class="required" style="width: 200px; margin: 0;" tabindex="205" maxlength="25">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Issued On</td>
						<td class="leftAligned">
							<div style="float: left; width: 206px; height: 21px; margin: 0;" class="withIconDiv required">
								<input type="text" id="txtIssueDate" class="withIcon required" readonly="readonly" style="width: 181px;" tabindex="206"/>
								<img id="imgIssueDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Issue Date" style="margin-top: 1px; cursor: pointer;" />
							</div>
						</td>
						<td class="rightAligned">Until</td>
						<td class="leftAligned">
							<div style="float: left; width: 206px; height: 21px; margin: 0;" class="withIconDiv required">
								<input type="text" id="txtExpiryDate" class="withIcon required" readonly="readonly" style="width: 181px;" tabindex="207"/>
								<img id="imgExpiryDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Expiry Date" style="margin-top: 1px; cursor: pointer;" />
							</div>
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="208"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="209"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px; margin: 0;" readonly="readonly" tabindex="210"></td>
						<td width="113px" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px; margin: 0;" readonly="readonly" tabindex="211"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px; text-align: center;">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="212">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="213">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="210">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="211">
</div>
<script type="text/javascript">	
	setModuleId("GIISS016");
	setDocumentTitle("Notary Public Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiiss016(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgNotaryPublic.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgNotaryPublic.geniisysRows);
		new Ajax.Request(contextPath+"/GIISNotaryPublicController", {
			method: "POST",
			parameters : {action : "saveGiiss016",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGiiss016.exitPage != null) {
							objGiiss016.exitPage();
						} else {
							tbgNotaryPublic._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss016);
	
	var objGiiss016 = {};
	var objNotaryPublic = null;
	objGiiss016.notaryPublicList = JSON.parse('${jsonNotaryPublicList}');
	objGiiss016.exitPage = null;
	
	var notaryPublicTable = {
			url : contextPath + "/GIISNotaryPublicController?action=showGiiss016&refresh=1",
			options : {
				width : 845,
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objNotaryPublic = tbgNotaryPublic.geniisysRows[y];
					setFieldValues(objNotaryPublic);
					tbgNotaryPublic.keys.removeFocus(tbgNotaryPublic.keys._nCurrentFocus, true);
					tbgNotaryPublic.keys.releaseKeys();
					$("txtNpName").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgNotaryPublic.keys.removeFocus(tbgNotaryPublic.keys._nCurrentFocus, true);
					tbgNotaryPublic.keys.releaseKeys();
					$("txtNpNo").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgNotaryPublic.keys.removeFocus(tbgNotaryPublic.keys._nCurrentFocus, true);
						tbgNotaryPublic.keys.releaseKeys();
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
					tbgNotaryPublic.keys.removeFocus(tbgNotaryPublic.keys._nCurrentFocus, true);
					tbgNotaryPublic.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgNotaryPublic.keys.removeFocus(tbgNotaryPublic.keys._nCurrentFocus, true);
					tbgNotaryPublic.keys.releaseKeys();
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
					tbgNotaryPublic.keys.removeFocus(tbgNotaryPublic.keys._nCurrentFocus, true);
					tbgNotaryPublic.keys.releaseKeys();
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
					id : "npNo",
					title : "Code",
					titleAlign: "right",
					filterOption : true,
					filterOptionType : "integerNoNegative",
					width : 80,
					align: "right",
					renderer: function(val){
						if(val != "")
							return formatNumberDigits(val, 4);
						else
							return "";
					}
				},
				{
					id : "npName",
					filterOption : true,
					title : "Notary Public",
					width : 250
				},
				{
					id : "ptrNo",
					filterOption : true,
					title : "PTR No.",
					width : 100
				},
				{
					id : "placeIssue",
					filterOption : true,
					title : "Issued at",
					width : 180
				},
				{
					id : "issueDate",
					filterOption : true,
					filterOptionType : "formattedDate",
					title : "Issued On",
					width : 100,
					align : "center",
					titleAlign : "center",
					renderer: function(val){
						return dateFormat(val, "mm-dd-yyyy");
					}
				},
				{
					id : "expiryDate",
					filterOption : true,
					filterOptionType : "formattedDate",
					title : "Until",
					width : 100,
					align : "center",
					titleAlign : "center",
					renderer: function(val){
						return dateFormat(val, "mm-dd-yyyy");
					}
				}
			],
			rows : objGiiss016.notaryPublicList.rows
		};

		tbgNotaryPublic = new MyTableGrid(notaryPublicTable);
		tbgNotaryPublic.pager = objGiiss016.notaryPublicList;
		tbgNotaryPublic.render("notaryPublicTable");
	
	function setFieldValues(rec){
		try{
			$("txtNpNo").value = (rec == null ? "" : rec.npNo != "" ? formatNumberDigits(rec.npNo, 4) : "");
			$("txtNpName").value = (rec == null ? "" : unescapeHTML2(rec.npName));
			$("txtPtrNo").value = (rec == null ? "" : unescapeHTML2(rec.ptrNo));
			$("txtPlaceIssue").value = (rec == null ? "" : unescapeHTML2(rec.placeIssue));
			$("txtIssueDate").value = (rec == null ? "" : dateFormat(rec.issueDate, "mm-dd-yyyy"));
			$("txtExpiryDate").value = (rec == null ? "" : dateFormat(rec.expiryDate, "mm-dd-yyyy"));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			//rec == null ? $("txtNpNo").readOnly = false : $("txtNpNo").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objNotaryPublic = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.npNo = $F("txtNpNo");
			obj.npName = escapeHTML2($F("txtNpName"));
			obj.ptrNo = escapeHTML2($F("txtPtrNo"));
			obj.placeIssue = escapeHTML2($F("txtPlaceIssue"));
			obj.issueDate = $F("txtIssueDate");
			obj.expiryDate = $F("txtExpiryDate");
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
			changeTagFunc = saveGiiss016;
			var dept = setRec(objNotaryPublic);
			if($F("btnAdd") == "Add"){
				tbgNotaryPublic.addBottomRow(dept);
			} else {
				tbgNotaryPublic.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgNotaryPublic.keys.removeFocus(tbgNotaryPublic.keys._nCurrentFocus, true);
			tbgNotaryPublic.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("notaryPublicFormDiv")){
				if($F("btnAdd") == "Add") {
					
					var addedSameExists = false;
					var deletedSameExists = false;	
					
					for(var i=0; i<tbgNotaryPublic.geniisysRows.length; i++){
						
						if(tbgNotaryPublic.geniisysRows[i].recordStatus == 0 || tbgNotaryPublic.geniisysRows[i].recordStatus == 1){
							
							if(tbgNotaryPublic.geniisysRows[i].npNo == $F("txtNpNo")){
								addedSameExists = true;	
							}	
							
						} else if(tbgNotaryPublic.geniisysRows[i].recordStatus == -1){
							
							if(tbgNotaryPublic.geniisysRows[i].npNo == $F("txtNpNo")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same class_cd.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}					
					
					new Ajax.Request(contextPath + "/GIISNotaryPublicController", {
						parameters : {action : "valAddRec",
									  npNo : $F("txtNpNo")},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								addRec();
							}
						}
					});
					
				} else {
					addRec();
				}
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}	
	
	function deleteRec(){
		changeTagFunc = saveGiiss016;
		objNotaryPublic.recordStatus = -1;
		tbgNotaryPublic.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		/* if($F("txtNpNo").trim() == "")
			return; */
		
		try{
			new Ajax.Request(contextPath + "/GIISNotaryPublicController", {
				parameters : {action : "giiss016ValDelRec",
							  npNo : removeLeadingZero($F("txtNpNo"))},
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
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}	

	function cancelGiiss016(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						if(objUW.fromMenu == "bondPolicyData"){
							objGiiss016.exitPage = function() {
								showBondPolicyDataPage();
								$("parInfoMenu").show();
							};
						} else if (objUW.fromMenu == "notaryPublic") {
							objGiiss016.exitPage = exitPage;
						}
						//objGiiss016.exitPage = exitPage;
						saveGiiss016();
					}, function(){
						//goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
						changeTag = 0;
						if(objUW.fromMenu == "bondPolicyData"){
							showBondPolicyDataPage();
							$("parInfoMenu").show();
						} else if (objUW.fromMenu == "notaryPublic") {
							goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
						}
					}, "");
		} else {
			//goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
			if(objUW.fromMenu == "bondPolicyData"){
				showBondPolicyDataPage();
				$("parInfoMenu").show();
			} else if (objUW.fromMenu == "notaryPublic") {
				goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
			}
		}
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("txtNpName").observe("keyup", function(){
		$("txtNpName").value = $F("txtNpName").toUpperCase();
	});
	
	$("txtNpNo").observe("keyup", function(){
		$("txtNpNo").value = $F("txtNpNo").toUpperCase();
	});
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGiiss016);
	$("btnCancel").observe("click", cancelGiiss016);
	//$("btnAdd").observe("click", valAddRec);
	$("btnAdd").observe("click", function(){
		if(checkAllRequiredFieldsInDiv("notaryPublicFormDiv"))
			addRec();
	});
	$("btnDelete").observe("click", valDeleteRec);
	
	$("btnExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtNpNo").focus();
	
	$("imgIssueDate").observe("click", function(){
		if ($("imgIssueDate").disabled == true)
			return;
		scwShow($("txtIssueDate"), this, null);
	});
	
	$("imgExpiryDate").observe("click", function(){
		if ($("imgExpiryDate").disabled == true)
			return;
		scwShow($("txtExpiryDate"), this, null);
	});
	
	observeBackSpaceOnDate("txtIssueDate");
	observeBackSpaceOnDate("txtExpiryDate");
	
	$("txtIssueDate").observe("focus", function(){
		if ($("imgIssueDate").disabled == true) return;
		var issueDate = $F("txtIssueDate") != "" ? new Date($F("txtIssueDate").replace(/-/g,"/")) :"";
		var expiryDate = $F("txtExpiryDate") != "" ? new Date($F("txtExpiryDate").replace(/-/g,"/")) :"";
		
		if (expiryDate < issueDate && expiryDate != ""){
			customShowMessageBox("Issue Date should be earlier than Expiry Date.", "I", "txtIssueDate");
			$("txtIssueDate").clear();
			return false;
		}
	});
	
	$("txtExpiryDate").observe("focus", function(){
		if ($("imgExpiryDate").disabled == true) return;
		var issueDate = $F("txtIssueDate") != "" ? new Date($F("txtIssueDate").replace(/-/g,"/")) :"";
		var expiryDate = $F("txtExpiryDate") != "" ? new Date($F("txtExpiryDate").replace(/-/g,"/")) :"";
		
		if (expiryDate < issueDate && expiryDate != ""){
			customShowMessageBox("Issue Date should be earlier than Expiry Date.", "I", "txtExpiryDate");
			$("txtExpiryDate").clear();
			return false;
		}
	});
</script>