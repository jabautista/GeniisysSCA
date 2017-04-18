<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giacs313MainDiv" name="giacs313MainDiv" style="">
	<div id="giacs313Div">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="giacs313Exit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Accounting User Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giacs313" name="giacs313">		
		<div class="sectionDiv">
			<div id="accountingUserTableDiv" style="padding-top: 10px;">
				<div id="accountingUserTable" style="height: 340px; margin-left: 10px;"></div>
			</div>
			<div align="center" id="accountingUserTypeFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">User Id</td>
						<td class="leftAligned" >
							<span class="lovSpan required" style="float: left; width: 206px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required allCaps" type="text" id="txtUserId" name="txtUserId" style="width: 180px; float: left; border: none; height: 15px; margin: 0;" maxlength="8" tabindex="101" lastValidValue="" ignoreDelKey=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchUserId" name="imgSearchUserId" alt="Go" style="float: right;" tabindex="102"/>
							</span>
						</td>
						<td width="125px" class="rightAligned">User Name</td>
						<td class="leftAligned">
							<input id="txtUserName" class="required allCaps" type="text" style="width: 200px;" tabindex="106" maxlength="50"> <!-- edited by MarkS 04.08.2016 SR-22112 REMOVE READONLY AND SET AS REQUIRED -->
						</td>
					</tr>	
					<tr>
						<td class="rightAligned">Valid From</td>
						<td class="leftAligned">
							<div style="float: left; width: 206px;" class="withIconDiv required">
								<input type="text" id="txtFromDate" name="txtFromDate" class="withIcon required" readonly="readonly" style="width: 180px;" tabindex="103"/>
								<img id="hrefFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date" tabindex="104"/>
							</div>
						</td>
						<td class="rightAligned" width="68px">Valid To</td>
						<td class="leftAligned">
							<div style="float: left; width: 206px;" class="withIconDiv">
								<input type="text" id="txtToDate" name="txtToDate" class="withIcon" readonly="readonly" style="width: 180px;" tabindex="107"/>
								<img id="hrefToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date" tabindex="108"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Designation</td>
						<td class="leftAligned">
							<input id="txtDesignation" type="text" class="required allCaps" style="width: 200px;" tabindex="105" maxlength="30">
						</td>
						<td class="rightAligned">Active</td>
						<td class="leftAligned">
							<select class= "required" id= "optActiveTag" style="width: 208px;" tabindex="109">
								<option value = "Y">Yes</option>
								<option value = "N">No</option>
							</select>
						</td>
					</tr>				
					<tr>
						<td class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 556px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="110"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="111"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtTranUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="112"></td>
						<td class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="113"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;" align = "center">
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
	setModuleId("GIACS313");
	setDocumentTitle("Accounting User Maintenance");
	initializeAll();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiacs313(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgAccountingUser.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgAccountingUser.geniisysRows);
		new Ajax.Request(contextPath+"/GIACUsersController", {
			method: "POST",
			parameters : {action : "saveGiacs313",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIACS313.exitPage != null) {
							objGIACS313.exitPage();
						} else {
							tbgAccountingUser._refreshList();
							tbgAccountingUser.keys.releaseKeys();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiacs313);
	
	var objGIACS313 = {};
	var objCurrAccountingUser = null;
	objGIACS313.accountingUserList = JSON.parse('${jsonAccountingUser}');
	objGIACS313.exitPage = null;
	
	var accountingUserTable = {
			url : contextPath + "/GIACUsersController?action=showGiacs313&refresh=1",
			options : {
				width : '900px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrAccountingUser = tbgAccountingUser.geniisysRows[y];
					setFieldValues(objCurrAccountingUser);
					tbgAccountingUser.keys.removeFocus(tbgAccountingUser.keys._nCurrentFocus, true);
					tbgAccountingUser.keys.releaseKeys();
					$("txtUserName").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgAccountingUser.keys.removeFocus(tbgAccountingUser.keys._nCurrentFocus, true);
					tbgAccountingUser.keys.releaseKeys();
					$("txtUserId").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgAccountingUser.keys.removeFocus(tbgAccountingUser.keys._nCurrentFocus, true);
						tbgAccountingUser.keys.releaseKeys();
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
					tbgAccountingUser.keys.removeFocus(tbgAccountingUser.keys._nCurrentFocus, true);
					tbgAccountingUser.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgAccountingUser.keys.removeFocus(tbgAccountingUser.keys._nCurrentFocus, true);
					tbgAccountingUser.keys.releaseKeys();
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
					tbgAccountingUser.keys.removeFocus(tbgAccountingUser.keys._nCurrentFocus, true);
					tbgAccountingUser.keys.releaseKeys();
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
					id : "giacUserId",
					title : "User ID",
					filterOption : true,
					width : '120px'
				},
				{
					id : "userName",
					title : "User Name",
					filterOption : true,
					width : '230px'
				},
				{
					id : "designation",
					title : "Designation",
					filterOption : true,
					width : '200px'
				},
				{
					id : "activeDt",
					title : "Valid From",
					titleAlign: 'center',
					align : 'center',
					filterOption : true,
					filterOptionType: 'formattedDate',
					width : '100px'
				},
				{
					id : "inactiveDt",
					title : "Valid To",
					titleAlign: 'center',
					align : 'center',
					filterOption : true,
					filterOptionType: 'formattedDate',
					width : '100px'
				},
				{
					id : "activeTag",
					title : "Active",
					filterOption : true,
					width : '100px',
					renderer : function(value){
						return value == 'Y' ? 'Yes' : 'No';
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
				}
			],
			rows : objGIACS313.accountingUserList.rows
		};

		tbgAccountingUser = new MyTableGrid(accountingUserTable);
		tbgAccountingUser.pager = objGIACS313.accountingUserList;
		tbgAccountingUser.render("accountingUserTable");
		
		function showGIACS313GiisUsersLOV(){
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {action : "getGiacs313GiisUsersLOV",
								findText2 : ($("txtUserId").readAttribute("lastValidValue").trim() != $F("txtUserId").trim() ? $F("txtUserId").trim() : "%"),
								page : 1},
				title: "List of Users",
				width: 500,
				height: 400,
				columnModel : [
								{
									id : "giacUserId",
									title: "User ID",
									width: '100px',
									filterOption: true
								},
								{
									id : "userName",
									title: "User Name",
									width: '325px',
									renderer: function(value) {
										return unescapeHTML2(value);
									}
								}
							],
					autoSelectOneRecord: true,
					filterText : ($("txtUserId").readAttribute("lastValidValue").trim() != $F("txtUserId").trim() ? $F("txtUserId").trim() : ""),
					onSelect: function(row) {
						$("txtUserId").value = unescapeHTML2(row.giacUserId);
						$("txtUserName").value = unescapeHTML2(row.userName);
						$("txtUserId").setAttribute("lastValidValue",unescapeHTML2(row.giacUserId));	
						$("txtFromDate").focus();
					},
					onCancel: function (){
						$("txtUserId").value = $("txtUserId").readAttribute("lastValidValue");
					},
					onUndefinedRow : function(){
						showMessageBox("No record selected.", "I");
						$("txtUserId").value = $("txtUserId").readAttribute("lastValidValue");
					},
					onShow : function(){$(this.id+"_txtLOVFindText").focus();}
			  });
		}
	
	function setFieldValues(rec){
		try{
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.giacUserId));
			$("txtUserId").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.giacUserId)));
			$("txtUserName").value = (rec == null ? "" : unescapeHTML2(rec.userName));
			$("txtDesignation").value = (rec == null ? "" : unescapeHTML2(rec.designation));
			$("txtFromDate").value = (rec == null ? "" : rec.activeDt);
			$("txtToDate").value = (rec == null ? "" : rec.inactiveDt);
			$("optActiveTag").value = (rec == null ? "" : rec.activeTag);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("txtTranUserId").value = (rec == null ? "" : rec.userId);
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtUserId").readOnly = false : $("txtUserId").readOnly = true;
			rec == null ? enableSearch("imgSearchUserId") : disableSearch("imgSearchUserId");
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrAccountingUser = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.giacUserId = escapeHTML2($F("txtUserId"));
			obj.userName = escapeHTML2($F("txtUserName"));
			obj.designation = escapeHTML2($F("txtDesignation"));
			obj.activeDt = $F("txtFromDate");
			obj.inactiveDt = $F("txtToDate");
			obj.activeTag = $F("optActiveTag");
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
			changeTagFunc = saveGiacs313;
			var dept = setRec(objCurrAccountingUser);
			if($F("btnAdd") == "Add"){
				tbgAccountingUser.addBottomRow(dept);
			} else {
				tbgAccountingUser.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgAccountingUser.keys.removeFocus(tbgAccountingUser.keys._nCurrentFocus, true);
			tbgAccountingUser.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("accountingUserTypeFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;					
					
					for(var i=0; i<tbgAccountingUser.geniisysRows.length; i++){
						if(tbgAccountingUser.geniisysRows[i].recordStatus == 0 || tbgAccountingUser.geniisysRows[i].recordStatus == 1){								
							if(tbgAccountingUser.geniisysRows[i].giacUserId == $F("txtUserId")){
								addedSameExists = true;								
							}							
						} else if(tbgAccountingUser.geniisysRows[i].recordStatus == -1){
							if(tbgAccountingUser.geniisysRows[i].giacUserId == $F("txtUserId")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same user_id.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GIACUsersController", {
						parameters : {action : "valAddRec",
									  giacUserId : $F("txtUserId")},
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
		changeTagFunc = saveGiacs313;
		objCurrAccountingUser.recordStatus = -1;
		tbgAccountingUser.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIACUsersController", {
				parameters : {action : "valDeleteRec",
							  giacUserId : $F("txtUserId")},
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
	
	function cancelGiacs313(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIACS313.exitPage = exitPage;
						saveGiacs313();
					}, function(){
						goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");	
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");	
		}
	}
	
	$("imgSearchUserId").observe("click", showGIACS313GiisUsersLOV);
	
	$("txtUserId").observe("change", function() {		
		if($F("txtUserId").trim() == "") {
			$("txtUserId").value = "";
			$("txtUserId").setAttribute("lastValidValue", "");
			$("txtUserName").value = "";
		} else {
			if($F("txtUserId").trim() != "" && $F("txtUserId") != $("txtUserId").readAttribute("lastValidValue")) {
				showGIACS313GiisUsersLOV();
			}
		}
	});	 	
	
	$("hrefFromDate").observe("click", function(){
		scwShow($('txtFromDate'),this, null);
	});
	$("hrefToDate").observe("click", function(){
		scwShow($('txtToDate'),this, null);
	});
	
	$("txtFromDate").observe("focus", function(){
		if ($("txtToDate").value != "" && this.value != "") {
			if (compareDatesIgnoreTime(Date.parse($F("txtFromDate")),Date.parse($("txtToDate").value)) == -1) {
				customShowMessageBox("Valid From Date should not be later than Valid  To Date.","I","txtFromDate");
				this.clear();
			}
		}
	});
	
	$("txtToDate").observe("focus", function(){
		if ($("txtFromDate").value != ""&& this.value != "") {
			if (compareDatesIgnoreTime(Date.parse($F("txtFromDate")),Date.parse($("txtToDate").value)) == -1) {
				customShowMessageBox("Valid From Date should not be later than Valid To Date.","I","txtToDate");
				this.clear();
			}
		}
	});
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGiacs313);
	$("btnCancel").observe("click", cancelGiacs313);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("giacs313Exit").stopObserving("click");
	$("giacs313Exit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	observeBackSpaceOnDate("txtFromDate");
	observeBackSpaceOnDate("txtToDate");
	$("txtUserId").focus();	
	enableSearch("imgSearchUserId");
</script>