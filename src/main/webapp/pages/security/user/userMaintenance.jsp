<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss040MainDiv" name="giiss040MainDiv" style="">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="menuSecurityMaintenanceExit">Exit</a></li>
			</ul>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Users Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss040" name="giiss040">		
		<div class="sectionDiv">
			<div id="userTableDiv" style="padding-top: 10px;">
				<div id="userTable" style="height: 340px; margin-left: 10px;"></div>
			</div>
			<div id="perilClassFormDiv" style="float: left;">
				<table style="margin-left: 60px; margin-top: 15px; width: 450px;">					
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned">
							<input id="txtGIISS040UserId" type="text" class="required" style="width: 200px; " tabindex="101" maxlength="8">
						</td>
						<td class="rightAligned" width="113px">User Name</td>
						<td class="leftAligned">
							<input id="txtUserName" type="text" class="required" style="width: 200px;" tabindex="102" maxlength="20">
						</td>
					</tr>	
					<tr>
						<td class="rightAligned">Group</td>
						<td class="leftAligned">
							<span class="lovSpan required" style="float: left; width: 206px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required integerNoNegativeUnformattedNoComma" type="text" id="txtUserGrp" style="width: 180px; float: left; border: none; height: 15px; margin: 0; text-align: right;" maxlength="4" tabindex="103" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchUserGrp" name="imgSearchUserGrp" alt="Go" style="float: right;" tabindex="104"/>
							</span>
						</td>
						<td class="rightAligned">Email</td>
						<td class="leftAligned">
							<input type="text" class="required" id="txtEmailAddress" name="txtEmailAddress" value="" style="width: 200px;" tabindex="105" maxlength="100" />
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Description</td>
						<td class="leftAligned" colspan="3">
							<input id="txtDspUserGrpDesc" type="text" class="" style="width:325px;" tabindex="106" maxlength="50" readonly="readonly">
							<span style="margin-left: 20px;">Grp Iss Cd</span>
							<input id="txtDspGrpIssCd" type="text" class="" style="width: 110px;" tabindex="107" maxlength="50" readonly="readonly">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="108"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="109"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtLastUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="110"></td>
						<td class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtStrLastUpdate2" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="111"></td>
					</tr>			
				</table>				
			</div>
			<div>
				<table style="margin-top: 5px;">
					<tr>
						<td>
							<input id="chkActiveFlag" type="checkbox" class="" style="margin-left: 30px; margin-top: 2px; float:left;" tabindex="114"><label style="margin-left: 5px; margin-top: 2px; float: left;" for="chkActiveFlag">Active Flag</label>
						</td>
					</tr>
					<tr>
						<td>
							<input id="chkCommUpdateTag" type="checkbox" class="" style="margin-left: 30px; margin-top: 2px; float:left;" tabindex="115"><label style="margin-left: 5px; margin-top: 2px; float: left;" for="chkCommUpdateTag">Commission Tag</label>
						</td>
					</tr>
					<tr>
						<td>
							<input id="chkAllUserSw" type="checkbox" class="" style="margin-left: 30px; margin-top: 2px; float:left;" tabindex="116"><label style="margin-left: 5px; margin-top: 2px; float: left;" for="chkAllUserSw">All User Switch</label>
						</td>
					</tr>
					<tr>
						<td>
							<input id="chkMgrSw" type="checkbox" class="" style="margin-left: 30px; margin-top: 2px; float:left;" tabindex="117"><label style="margin-left: 5px; margin-top: 2px; float: left;" for="chkMgrSw">Manager Switch</label>
						</td>
					</tr>
					<tr>
						<td>
							<input id="chkMktngSw" type="checkbox" class="" style="margin-left: 30px; margin-top: 2px; float:left;" tabindex="118"><label style="margin-left: 5px; margin-top: 2px; float: left;" for="chkMktngSw">Marketing Switch</label>
						</td>
					</tr>
					<tr>
						<td>
							<input id="chkMisSw" type="checkbox" class="" style="margin-left: 30px; margin-top: 2px; float:left;" tabindex="119"><label style="margin-left: 5px; margin-top: 2px; float: left;" for="chkMisSw">MIS Switch</label>
						</td>
					</tr>
					<tr>
						<td>
							<input id="chkWorkflowTag" type="checkbox" class="" style="margin-left: 30px; margin-top: 2px; float:left;" tabindex="120"><label style="margin-left: 5px; margin-top: 2px; float: left;" for="chkWorkflowTag">Workflow Tag</label>
						</td>
					</tr>	
					<tr>
						<td>
							<input id="chkTempAccessTag" type="checkbox" class="" style="margin-left: 30px; margin-top: 2px; float:left;" tabindex="121"><label style="margin-left: 5px; margin-top: 2px; float: left;" for="chkTempAccessTag">Temporary Access Tag</label>
						</td>
					</tr>
					<tr id="trAllowGenFileSw">
						<td>
							<input id="chkAllowGenFileSw" type="checkbox" class="" style="margin-left: 30px; margin-top: 2px; float:left;" tabindex="121"><label style="margin-left: 5px; margin-top: 2px; float: left;" for="chkAllowGenFileSw">Allow Generate to File</label>
						</td>
					</tr>		
				</table>
			</div>
			<div style="margin: 10px;" align="center">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="112">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="113">
			</div>
			<div style="margin: 10px; padding: 10px; border-top: 1px solid #E0E0E0; margin-bottom: 0;" align="center">
			    <input type="button" class="button" id="btnChangePassword" value="Change Password" tabindex="122" style="width: 150px;">
				<input type="button" class="button" id="btnResetPassword" value="Reset Password" tabindex="123" style="width: 150px;">
				<input type="button" class="button" id="btnTransaction" value="Transaction" tabindex="124" style="width: 150px;">
				<input type="button" class="button" id="btnUserGroupAccess" value="User Group Access" tabindex="125" style="width: 150px;">
				<input type="button" class="button" id="btnUserHistory" value="User History" tabindex="126" style="width: 150px;">
				<!-- <input type="button" class="button" id="btnUnlockAccount" value="Unlock Account" tabindex="126" style="width: 150px;"> -->
			</div>
		</div>
	</div>
	<div class="buttonsDiv">
		<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="127">
		<input type="button" class="button" id="btnSave" value="Save" tabindex="128">
	</div>
</div>
<div id="transactionsDiv">
</div>
<script type="text/javascript">	
	setModuleId("GIISS040");
	setDocumentTitle("Users Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiiss040(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgUsers.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgUsers.geniisysRows);
		new Ajax.Request(contextPath+"/GIISS040Controller", {
			method: "POST",
			parameters : {action : "saveGiiss040",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS040.exitPage != null) {
							objGIISS040.exitPage();
						} else {
							tbgUsers._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss040);
	
	objGIISS040 = {};
	var objCurrUser = null;
	objGIISS040.userList = JSON.parse('${jsonUserList}');
	objGIISS040.params = JSON.parse('${params}');
	objGIISS040.exitPage = null;
	
	if(objGIISS040.params.restrictGen2FileByuser != "Y"){
		$("trAllowGenFileSw").hide();
	}
	
	var userTable = {
			url : contextPath + "/GIISS040Controller?action=showGiiss040&refresh=1",
			options : {
				width : '900px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrUser = tbgUsers.geniisysRows[y];
					setFieldValues(objCurrUser);
					tbgUsers.keys.removeFocus(tbgUsers.keys._nCurrentFocus, true);
					tbgUsers.keys.releaseKeys();
					$("txtUserName").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgUsers.keys.removeFocus(tbgUsers.keys._nCurrentFocus, true);
					tbgUsers.keys.releaseKeys();
					$("txtGIISS040UserId").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgUsers.keys.removeFocus(tbgUsers.keys._nCurrentFocus, true);
						tbgUsers.keys.releaseKeys();
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
					tbgUsers.keys.removeFocus(tbgUsers.keys._nCurrentFocus, true);
					tbgUsers.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgUsers.keys.removeFocus(tbgUsers.keys._nCurrentFocus, true);
					tbgUsers.keys.releaseKeys();
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
					tbgUsers.keys.removeFocus(tbgUsers.keys._nCurrentFocus, true);
					tbgUsers.keys.releaseKeys();
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
				{ 	id:			'activeFlag',
					align:		'center',
					title:		'A',
					altTitle:   'Active Flag',
					titleAlign:	'center',
					width:		'23px',
			   		editable: false,
			   		filterOption: true,
			   		filterOptionType : 'checkbox',
				    editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
		            		if (value){
								return "Y";
		            		}else{
								return "N";
		            		}
		            	}
				    })
				},
				{ 	id:			'commUpdateTag',
					align:		'center',
					title:		'C',
					altTitle:   'Commission Tag',
					titleAlign:	'center',
					width:		'23px',
			   		editable: false,
			   		filterOption: true,
			   		filterOptionType : 'checkbox',
				    editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
		            		if (value){
								return "Y";
		            		}else{
								return "N";
		            		}
		            	}
				    })
				},
				{ 	id:			'allUserSw',
					align:		'center',
					title:		'U',
					altTitle:   'All Users Switch',
					titleAlign:	'center',
					width:		'23px',
			   		editable: false,
			   		filterOption: true,
			   		filterOptionType : 'checkbox',
				    editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
		            		if (value){
								return "Y";
		            		}else{
								return "N";
		            		}
		            	}
				    })
				},		
				{ 	id:			'mgrSw',
					align:		'center',
					title:		'M',
					altTitle:   'Manager Switch',
					titleAlign:	'center',
					width:		'23px',
			   		editable: false,
			   		filterOption: true,
			   		filterOptionType : 'checkbox',
				    editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
		            		if (value){
								return "Y";
		            		}else{
								return "N";
		            		}
		            	}
				    })
				},	
				{ 	id:			'mktngSw',
					align:		'center',
					title:		'K',
					altTitle:   'Marketing Switch',
					titleAlign:	'center',
					width:		'23px',
			   		editable: false,
			   		filterOption: true,
			   		filterOptionType : 'checkbox',
				    editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
		            		if (value){
								return "Y";
		            		}else{
								return "N";
		            		}
		            	}
				    })
				},		
				{ 	id:			'misSw',
					align:		'center',
					title:		'I',
					altTitle:   'MIS Switch',
					titleAlign:	'center',
					width:		'23px',
			   		editable: false,
			   		filterOption: true,
			   		filterOptionType : 'checkbox',
				    editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
		            		if (value){
								return "Y";
		            		}else{
								return "N";
		            		}
		            	}
				    })
				},		
				{ 	id:			'workflowTag',
					align:		'center',
					title:		'W',
					altTitle:   'Workflow Tag',
					titleAlign:	'center',
					width:		'23px',
			   		editable: false,
			   		filterOption: true,
			   		filterOptionType : 'checkbox',
				    editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
		            		if (value){
								return "Y";
		            		}else{
								return "N";
		            		}
		            	}
				    })
				},		
				{ 	id:			'tempAccessTag',
					align:		'center',
					title:		'T',
					altTitle:   'Temporary Access Tag',
					titleAlign:	'center',
					width:		'23px',
			   		editable: false,
			   		filterOption: true,
			   		filterOptionType : 'checkbox',
				    editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
		            		if (value){
								return "Y";
		            		}else{
								return "N";
		            		}
		            	}
				    })
				},		
				{ 	id:			'allowGenFileSw',
					align:		'center',
					title:		'P',
					altTitle:   'Allow Generate to File',
					titleAlign:	'center',
					width: (objGIISS040.params.restrictGen2FileByuser == "Y" ? '23px' : '0'),
			   		editable: false,
			   		filterOption: true,
			   		filterOptionType : 'checkbox',
			   		visible : (objGIISS040.params.restrictGen2FileByuser == "Y" ? true : false),
				    editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
		            		if (value){
								return "Y";
		            		}else{
								return "N";
		            		}
		            	}
				    })
				},					
				{
					id : "maintainUserId",
					title : "User ID",
					filterOption : true,
					width: (objGIISS040.params.restrictGen2FileByuser == "Y" ? '100px' : '120px')
				},
				{
					id : 'username',
					filterOption : true,
					title : 'User Name',
					width : '180px'				
				},	
				{
					id : 'userGrp',
					filterOption : true,
					title : 'Group',
					width : '70px',
					titleAlign : 'right',
					align : 'right',
					filterOptionType : 'integerNoNegative',
					renderer : function(value){
						return formatNumberDigits(value, 4);
					}
				},	
				{
					id : 'userGrpDesc',
					filterOption : true,
					title : 'Description',
					width : '210px'				
				},		
				{
					id : 'issCd',
					filterOption : true,
					title : 'Grp Iss Cd',
					width : '70px'				
				},					
				{
					id : 'remarks',
					width : '0',
					visible: false				
				},
				{
					id : 'lastUserId',
					width : '0',
					visible: false
				},
				{
					id : 'strLastUpdate2',
					width : '0',
					visible: false				
				},
				{
					id : 'decryptedEmailAdd',
					width : '0',
					visible: false				
				}
			],
			rows : objGIISS040.userList.rows
		};

		tbgUsers = new MyTableGrid(userTable);
		tbgUsers.pager = objGIISS040.userList;
		tbgUsers.render("userTable");
	
	function setFieldValues(rec){
		try{
			$("txtGIISS040UserId").value = (rec == null ? "" : unescapeHTML2(rec.maintainUserId));			
			$("txtUserName").value = (rec == null ? "" : unescapeHTML2(rec.username));
			$("txtUserGrp").value = (rec == null ? "" : formatNumberDigits(rec.userGrp, 4));
			$("txtUserGrp").setAttribute("lastValidValue", rec == null ? "" : formatNumberDigits(rec.userGrp, 4));
			$("txtEmailAddress").value = (rec == null ? "" : rec.decryptedEmailAdd);
			$("txtDspGrpIssCd").value = (rec == null ? "" : unescapeHTML2(rec.issCd));
			$("txtDspUserGrpDesc").value = (rec == null ? "" : unescapeHTML2(rec.userGrpDesc));
			$("txtLastUserId").value = (rec == null ? "" : unescapeHTML2(rec.lastUserId));
			$("txtStrLastUpdate2").value = (rec == null ? "" : rec.strLastUpdate2);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec != null && rec.activeFlag == "Y" ? $("chkActiveFlag").checked = true : $("chkActiveFlag").checked = false;
			rec != null && rec.commUpdateTag == "Y" ? $("chkCommUpdateTag").checked = true : $("chkCommUpdateTag").checked = false;
			rec != null && rec.allUserSw == "Y" ? $("chkAllUserSw").checked = true : $("chkAllUserSw").checked = false;
			rec != null && rec.mgrSw == "Y" ? $("chkMgrSw").checked = true : $("chkMgrSw").checked = false;
			rec != null && rec.mktngSw == "Y" ? $("chkMktngSw").checked = true : $("chkMktngSw").checked = false;
			rec != null && rec.misSw == "Y" ? $("chkMisSw").checked = true : $("chkMisSw").checked = false;
			rec != null && rec.workflowTag == "Y" ? $("chkWorkflowTag").checked = true : $("chkWorkflowTag").checked = false;
			rec != null && rec.tempAccessTag == "Y" ? $("chkTempAccessTag").checked = true : $("chkTempAccessTag").checked = false;
			rec != null && rec.allowGenFileSw == "Y" ? $("chkAllowGenFileSw").checked = true : $("chkAllowGenFileSw").checked = false;
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtGIISS040UserId").readOnly = false : $("txtGIISS040UserId").readOnly = true;
			//rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			rec == null ? disableButton("btnResetPassword") : enableButton("btnResetPassword");
			rec == null ? disableButton("btnTransaction") : enableButton("btnTransaction");
			rec == null ? disableButton("btnUserGroupAccess") : enableButton("btnUserGroupAccess");
			rec == null ? disableButton("btnUserHistory") : enableButton("btnUserHistory");
			rec == null ? disableButton("btnChangePassword") : enableButton("btnChangePassword");
			/* rec != null && rec.activeFlag == "L" ? enableButton("btnUnlockAccount") : disableButton("btnUnlockAccount"); */
			
			if (rec == null) {
				$("btnResetPassword").value = "Reset Password";
				disableButton("btnResetPassword");
			} else {
				if (rec.password == null || rec.password.trim() == "") {
					$("btnResetPassword").value = "Generate Password";
				} else {
					$("btnResetPassword").value = "Reset Password";
				}
				
				enableButton("btnResetPassword");
			}			
			
			if(rec != null && (rec.recordFlag == 0 || rec.recordFlag == -1)){
				enableButton("btnDelete");
			} else {
				disableButton("btnDelete");
			}

			objCurrUser = rec;
		} catch (e) {
			showErrorMessage("setFieldValues", e);
		}
	}

	setFieldValues(null);

	function setRec(rec) {
		try {
			var obj = (rec == null ? {} : rec);
			obj.maintainUserId = escapeHTML2($F("txtGIISS040UserId"));
			obj.username = escapeHTML2($F("txtUserName"));
			obj.emailAdd = $F("txtEmailAddress");
			obj.decryptedEmailAdd = $F("txtEmailAddress");
			obj.userGrp = $F("txtUserGrp");
			obj.issCd = escapeHTML2($F("txtDspGrpIssCd"));
			obj.userGrpDesc = escapeHTML2($F("txtDspUserGrpDesc"));
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.activeFlag = ($("chkActiveFlag").checked ? 'Y' : 'N');
			obj.commUpdateTag = ($("chkCommUpdateTag").checked ? 'Y' : 'N');
			obj.allUserSw = ($("chkAllUserSw").checked ? 'Y' : 'N');
			obj.mgrSw = ($("chkMgrSw").checked ? 'Y' : 'N');
			obj.mktngSw = ($("chkMktngSw").checked ? 'Y' : 'N');
			obj.misSw = ($("chkMisSw").checked ? 'Y' : 'N');
			obj.workflowTag = ($("chkWorkflowTag").checked ? 'Y' : 'N');
			obj.tempAccessTag = ($("chkTempAccessTag").checked ? 'Y' : null);
			obj.allowGenFileSw = ($("chkAllowGenFileSw").checked ? 'Y' : 'N');
			obj.lastUserId = userId;
			obj.userLevel = 1; // default value from CS
			var strLastUpdate2 = new Date();
			obj.strLastUpdate2 = dateFormat(strLastUpdate2,
					'mm-dd-yyyy hh:MM:ss TT');

			return obj;
		} catch (e) {
			showErrorMessage("setRec", e);
		}
	}

	function addRec() {
		try {
			changeTagFunc = saveGiiss040;
			var rec = setRec(objCurrUser);
			if ($F("btnAdd") == "Add") {
				rec.recordFlag = 0;
				tbgUsers.addBottomRow(rec);
			} else {
				tbgUsers.updateVisibleRowOnly(rec, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgUsers.keys.removeFocus(tbgUsers.keys._nCurrentFocus, true);
			tbgUsers.keys.releaseKeys();
		} catch (e) {
			showErrorMessage("addRec", e);
		}
	}

	function checkEmailIfValid2(emailAdd) { //alternate checking of email
		var isValid = true;
		//added hyphen in the domain by robert SR 21900 03.23.16
		var emailRegEx = /^([a-zA-Z0-9])+([\.a-zA-Z0-9_-])*@([a-zA-Z0-9-])+(\.[a-zA-Z0-9_-]+)+$/;

		isValid = emailRegEx.test(emailAdd);

		return isValid;
	}

	function valAddRec() {
		try {
			if (checkAllRequiredFieldsInDiv("perilClassFormDiv")) {
				if (!checkEmailIfValid2($F("txtEmailAddress"))) {
					showWaitingMessageBox("Invalid email address.",
							imgMessage.ERROR, function() {
								$("txtEmailAddress").focus();
							});
					return;
				}

				if ($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;

					for (var i = 0; i < tbgUsers.geniisysRows.length; i++) {
						if (tbgUsers.geniisysRows[i].recordStatus == 0
								|| tbgUsers.geniisysRows[i].recordStatus == 1) {
							if (tbgUsers.geniisysRows[i].maintainUserId == $F("txtGIISS040UserId")) {
								addedSameExists = true;
							}
						} else if (tbgUsers.geniisysRows[i].recordStatus == -1) {
							if (tbgUsers.geniisysRows[i].maintainUserId == $F("txtGIISS040UserId")) {
								deletedSameExists = true;
							}
						}
					}

					if ((addedSameExists && !deletedSameExists)
							|| (deletedSameExists && addedSameExists)) {
						showMessageBox(
								"Record already exists with the same user_id.",
								"E");
						return;
					} else if (deletedSameExists && !addedSameExists) {
						addRec();
						return;
					}

					new Ajax.Request(contextPath + "/GIISS040Controller", {
						parameters : {
							action : "valAddRec",
							maintainUserId : $F("txtGIISS040UserId")
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
		changeTagFunc = saveGiiss040;
		objCurrUser.recordStatus = -1;
		tbgUsers.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}

	function valDeleteRec() {
		try {
			new Ajax.Request(contextPath + "/GIISS040Controller", {
				parameters : {
					action : "valDeleteRec",
					maintainUserId : $F("txtGIISS040UserId")
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
		goToModule("/GIISUserController?action=goToSecurity", "Security Main",
				null);
	}

	function cancelGiiss040() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						objGIISS040.exitPage = exitPage;
						saveGiiss040();
					}, function() {
						goToModule("/GIISUserController?action=goToSecurity",
								"Security Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToSecurity",
					"Security Main", null);
		}
	}

	function showUserHistory() {
		overlayGIIS040UserHistory = Overlay.show(contextPath
				+ "/GIISS040Controller", {
			urlContent : true,
			urlParameters : {
				action : "showUserHistory",
				userId : $F("txtGIISS040UserId")
			},
			showNotice : true,
			title : "User History",
			height : 410,
			width : 700,
			draggable : true
		});
	}

	function showUserGroupAccess() {
		overlayGIIS040UserGroupAccess = Overlay.show(contextPath
				+ "/GIISS040Controller", {
			urlContent : true,
			urlParameters : {
				action : "showUserGroupAccess",
				userGrp : $F("txtUserGrp")
			},
			showNotice : true,
			title : "User Group Access",
			height : 560,
			width : 528,
			draggable : true,
			closable : true
		});
	}

	function resetPassword() {
		try {
			if ($F("txtEmailAddress") == "") {
				showWaitingMessageBox("Please enter email address first.", "I",
						function() {
							$("txtEmailAddress").focus();
						});
				return;
			} else if (changeTag == 1) {
				showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I",
						function() {
							$("btnSave").focus();
						});
			}

			new Ajax.Request(contextPath + "/GIISUserMaintenanceController", {
				method : "POST",
				parameters : {
					action : "resetPassword",
					mode: ($F("btnResetPassword") == "Reset Password" ? "reset" : "generate"),
					userId : $F("txtGIISS040UserId"),
					userName: $F("txtUserName"),
					lastUserId : "${PARAMETERS['USER'].userId}",					
					emailAddress : $F("txtEmailAddress")
				},
				onCreate : function() {
					showNotice("Processing request, please wait...");
				},
				onComplete : function(response) {
					hideNotice();
					if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)) {
						showMessageBox($F("txtGIISS040UserId") + "'s password has been " + ($F("btnResetPassword") == "Reset Password" ? "reset" : "generated") + ".", imgMessage.INFO);
						tbgUsers.geniisysRows[rowIndex].password = "X";
						$("btnResetPassword").value = "Reset Password";
					}
				}
			});
		} catch (e) {
			showErrorMessage("resetPassword", e);
		}
	}

	function showGIISS040UserGrpLOV() {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getGIISS040UserGrpLOV",
				filterText : ($("txtUserGrp").readAttribute("lastValidValue")
						.trim() != $F("txtUserGrp").trim() ? $F("txtUserGrp")
						.trim() : ""),
				page : 1
			},
			title : "List of User Groups",
			width : 510,
			height : 400,
			columnModel : [ {
				id : "userGrp",
				title : "Group",
				width : '70px',
				align : 'right',
				titleAlign : 'right'
			}, {
				id : "userGrpDesc",
				title : "Description",
				width : '340px',
				renderer : function(value) {
					return unescapeHTML2(value);
				}
			}, {
				id : "grpIssCd",
				title : "Grp Iss Cd",
				width : '80px'
			} ],
			autoSelectOneRecord : true,
			filterText : ($("txtUserGrp").readAttribute("lastValidValue")
					.trim() != $F("txtUserGrp").trim() ? $F("txtUserGrp")
					.trim() : ""),
			onSelect : function(row) {
				$("txtUserGrp").value = formatNumberDigits(row.userGrp, 4);
				$("txtDspUserGrpDesc").value = unescapeHTML2(row.userGrpDesc);
				$("txtDspGrpIssCd").value = unescapeHTML2(row.grpIssCd);
				$("txtUserGrp").setAttribute("lastValidValue",
						formatNumberDigits(row.userGrp, 4));
				$("txtUserGrp").focus();
			},
			onCancel : function() {
				if ($("txtUserGrp").value != "") {
					$("txtUserGrp").value = formatNumberDigits($("txtUserGrp")
							.readAttribute("lastValidValue"), 4);
					$("txtUserGrp").focus();
				}
			},
			onUndefinedRow : function() {
				showMessageBox("No record selected.", "I");
				if ($("txtUserGrp").value != "") {
					$("txtUserGrp").value = formatNumberDigits($("txtUserGrp")
							.readAttribute("lastValidValue"), 4);
					$("txtUserGrp").focus();
				}
			},
			onShow : function() {
				$(this.id + "_txtLOVFindText").focus();
			}
		});
	}

	function showTransactions() {
		if (changeTag != 0) {
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			return false;
		}

		new Ajax.Request(contextPath + "/GIISS040Controller", {
			method : "POST",
			parameters : {
				action : "showTransactions",
				userId : $F("txtGIISS040UserId")
			},
			onCreate : function() {
				showNotice("Processing request, please wait...");
			},
			onComplete : function(response) {
				hideNotice();
				if (checkErrorOnResponse(response)) {
					changeTag = 0;
					changeTagFunc = "";
					$("transactionsDiv").update(response.responseText);
					$("giiss040MainDiv").hide();
				}
			}
		});
	}

	objGIISS040.showTransactions = showTransactions;

	$("imgSearchUserGrp").observe("click", showGIISS040UserGrpLOV);

	$("txtUserGrp").observe(
			"change",
			function() {
				if ($F("txtUserGrp").trim() == "") {
					$("txtUserGrp").value = "";
					$("txtUserGrp").setAttribute("lastValidValue", "");
					$("txtDspUserGrpDesc").value = "";
					$("txtDspGrpIssCd").value = "";
				} else {
					if ($F("txtUserGrp").trim() != ""
							&& $F("txtUserGrp") != $("txtUserGrp")
									.readAttribute("lastValidValue")) {
						showGIISS040UserGrpLOV();
					}
				}
			});

	$("editRemarks").observe(
			"click",
			function() {
				showOverlayEditor("txtRemarks", 4000, $("txtRemarks")
						.hasAttribute("readonly"));
			});

	$("txtUserName").observe("keyup", function() {
		$("txtUserName").value = $F("txtUserName").toUpperCase();
	});

	$("txtGIISS040UserId").observe("keyup", function() {
		$("txtGIISS040UserId").value = $F("txtGIISS040UserId").toUpperCase();
	});

	disableButton("btnDelete");

	$("menuSecurityMaintenanceExit").stopObserving("click");
	$("menuSecurityMaintenanceExit").observe("click", function() {
		fireEvent($("btnCancel"), "click");
	});

	function changePassword() {
		if (changeTag == 1) {
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			return;
		}

		overlayChangePassword = Overlay.show(contextPath
				+ "/GIISUserMaintenanceController", {
			urlContent : true,
			urlParameters : {
				action : "changePasswordForm",
				userId : $F("txtGIISS040UserId")
			},
			showNotice : true,
			title : "Change Password",
			height : 200,
			width : 415,
			draggable : true
		});
	}

	observeSaveForm("btnSave", saveGiiss040);
	$("btnCancel").observe("click", cancelGiiss040);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);
	$("btnUserHistory").observe("click", showUserHistory);
	$("btnUserGroupAccess").observe("click", showUserGroupAccess);
	$("btnResetPassword").observe("click", resetPassword);
	$("btnTransaction").observe("click", showTransactions);
	$("btnChangePassword").observe("click", changePassword);

	$("txtGIISS040UserId").focus();
</script>