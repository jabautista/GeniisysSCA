<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div style="width: 655px;">
	<fieldset>
		<legend>Passing User</legend>
		<div id="passingUserDiv" class="">
			<div id="passingUserTableDiv" style="padding-top: 10px;">
				<div id="passingUserTable" style="margin-left: 10px; height: 131px;"></div>
			</div>
			<table align="center" style="margin: 10px auto;">
				<tr>
					<td class="rightAligned" style="padding-right: 5px;">Passing User</td>
					<td class="leftAligned">
						<span class="lovSpan required" style="width: 125px; margin: 0; height: 21px;">
							<input type="text" id="txtPassingUserid" class="required" ignoreDelKey="true" style="width: 100px; float: left; border: none; height: 14px; margin: 0;" lastValidValue=""/> 
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgPassingUser" alt="Go" style="float: right;"/>
						</span>
						<input id="txtPassingUserName" type="text" style="width: 350px; margin: 0; margin-left: 4px;" readonly="readonly" lastValidValue="">
					</td>
				</tr>
			</table>
			<div style="margin: 5px; text-align: center;">
				<input type="button" class="button" id="btnPassingAdd" value="Add" tabindex="208">
				<input type="button" class="button" id="btnPassingDelete" value="Delete" tabindex="209">
			</div>
		</div>
	</fieldset>
	<fieldset>
		<legend>Receiving User</legend>
		<div id="receivingUserDiv" class="">
			<div id="receivingUserTableDiv" style="padding-top: 10px;">
				<div id="receivingUserTable" style="height: 131px; margin-left: 10px;"></div>
			</div>
			<table align="center" style="margin: 10px auto;">
				<tr>
					<td class="rightAligned" style="padding-right: 5px;">Receiving User</td>
					<td class="leftAligned">
						<input type="hidden" id="hidEventUserMod" />
						<span class="lovSpan required" style="width: 125px; margin: 0; height: 21px;">
							<input type="text" id="txtReceivingUserid" class="required" ignoreDelKey="true" style="width: 100px; float: left; border: none; height: 14px; margin: 0;" lastValidValue=""/> 
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgReceivingUser" alt="Go" style="float: right;"/>
						</span>
						<input id="txtReceivingUserName" type="text" style="width: 350px; margin: 0; margin-left: 4px;" readonly="readonly" lastValidValue="">
					</td>
				</tr>
			</table>
			<div style="margin: 5px; text-align: center;">
				<input type="button" class="button" id="btnReceivingAdd" value="Add" tabindex="208">
				<input type="button" class="button" id="btnReceivingDelete" value="Delete" tabindex="209">
			</div>
		</div>
	</fieldset>
	

	<div style="float: none; text-align: center;">
		<input type="button" class="button" value="Return" id="btnExitUserList" style="width: 90px; margin-top: 7px;" />
		<input type="button" class="button" value="Save" id="btnSaveUserList" style="width: 90px; margin-top: 7px;" />
	</div>
</div>
<script type="text/javascript">
	try {
		//$("btnPassingDelete").hide();
		disableButton("btnPassingDelete");
		var objGiiss168PassingUser = {};
		objGiiss168PassingUser = JSON.parse('${jsonPassingUserList}');
		var objPassingUser = null;
		var objReceivingUser = null;
		var userListChangeTag = 0;
		var userListChangeTag2 = 0;
		var selectedPassingUsers;
		var selectedReceivingUsers;
		var rowIndexPassing;
		var rowIndexReceiving;
		
		disableSearch("imgReceivingUser");
		$("txtReceivingUserid").readOnly = true;
		disableButton("btnReceivingAdd");
		disableButton("btnReceivingDelete");
		
		function saveGiiss168UserList(){
			if(userListChangeTag == 0 && userListChangeTag2 == 0) {
				showMessageBox(objCommonMessage.NO_CHANGES, "I");
				return;
			}
			var objParams = new Object();
			objParams.setRowsPassingUser = getAddedAndModifiedJSONObjects(tbgPassingUser.geniisysRows);
			objParams.setRowsReceivingUser = getAddedAndModifiedJSONObjects(tbgReceivingUser.geniisysRows);
			objParams.delRowsReceivingUser = getDeletedJSONObjects(tbgReceivingUser.geniisysRows);
			
			new Ajax.Request(contextPath+"/GIISEventModuleController", {
				method: "POST",
				parameters : {
					action : "saveGiiss168UserList",
					objParams : JSON.stringify(objParams)
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
							if(objGiiss168.exitUserList != null) {
								overlayUserList.close();
								delete overlayUserList;
							} else {
								tbgPassingUser._refreshList();
							}
						});
						userListChangeTag = 0;
						userListChangeTag2 = 0;
					}
				}
			});
		}
		
		$("btnSaveUserList").observe("click", saveGiiss168UserList);
		
		var jsonPassingUserList = JSON.parse('${jsonPassingUserList}');	
		passingUserTable = {
			id  : "tbgPassingUser",	
			url : contextPath+"/GIISEventModuleController?action=showGiiss168UserList&refresh=1&eventModCd=" + objGiiss168.eventModCd,
			options: {
				width: 616,
				height: 131,
				pager : {},
				onCellFocus : function(element, value, x, y, id) {
					rowIndexPassing = y;
					objPassingUser = tbgPassingUser.geniisysRows[y];
					setPassingUserFields(objPassingUser);
					tbgPassingUser.keys.removeFocus(tbgPassingUser.keys._nCurrentFocus, true);
					tbgPassingUser.keys.releaseKeys();
					
				},
				onRemoveRowFocus : function(){
					rowIndexPassing = 1;
					setPassingUserFields(null);
					tbgPassingUser.keys.removeFocus(tbgPassingUser.keys._nCurrentFocus, true);
					tbgPassingUser.keys.releaseKeys();
				},
				beforeClick : function(element, value, x, y, id) {
					if(userListChangeTag2 == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSaveUserList").focus();
						});
						return false;
					}	
				},
				beforeSort : function(){
					if(userListChangeTag == 1 || userListChangeTag2 == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSaveUserList").focus();
						});
						return false;
					}					
				},
				onSort: function(){
					rowIndexPassing = 1;
					setPassingUserFields(null);
					tbgPassingUser.keys.removeFocus(tbgPassingUser.keys._nCurrentFocus, true);
					tbgPassingUser.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndexPassing = 1;
					setPassingUserFields(null);
					tbgPassingUser.keys.removeFocus(tbgPassingUser.keys._nCurrentFocus, true);
					tbgPassingUser.keys.releaseKeys();
				},				
				prePager: function(){
					if(userListChangeTag == 1 || userListChangeTag2 == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSaveUserList").focus();
						});
						return false;
					}
					rowIndexPassing = 1;
					setPassingUserFields(null);
					tbgPassingUser.keys.removeFocus(tbgPassingUser.keys._nCurrentFocus, true);
					tbgPassingUser.keys.releaseKeys();
				},
				checkChanges: function(){
					return (userListChangeTag == 1 || userListChangeTag2 == 1 ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (userListChangeTag == 1 || userListChangeTag2 == 1 ? true : false);
				},
				masterDetailValidation: function(){
					return (userListChangeTag == 1 || userListChangeTag2 == 1 ? true : false);
				},
				masterDetail: function(){
					return (userListChangeTag == 1 || userListChangeTag2 == 1? true : false);
				},
				masterDetailSaveFunc: function() {
					return (userListChangeTag == 1 || userListChangeTag2 == 1? true : false);
				},
				masterDetailNoFunc: function(){
					return (userListChangeTag == 1 || userListChangeTag2 == 1? true : false);
				}
			},									
			columnModel: [
				{
				    id: 'recordStatus',
				    title: '',
				    width: '0',
				    visible: false
				},
				{
					id: 'divCtrId',
					width: '0',
					visible: false 
				},	
				{
					id : "passingUserid",
					title : "User ID",
					filterOption : true,
					width : 180,
					renderer: function(val){
						return unescapeHTML2(val);
					}
				},
				{
					id : "userName",
					title : "User Name",
					filterOption : true,
					width : 410,
					renderer: function(val){
						return unescapeHTML2(val);
					}
				}
			],
			rows: jsonPassingUserList.rows
		};
	
		tbgPassingUser = new MyTableGrid(passingUserTable);
		tbgPassingUser.pager = jsonPassingUserList;
		tbgPassingUser.render("passingUserTable");
		tbgPassingUser.afterRender = function(){
			if(tbgPassingUser.geniisysRows.length > 0){
				selectedPassingUsers = getSelectedPassingUsers();
			} else {
				selectedPassingUsers = new Array();
			}
		};
		
		
		//var receivingUserList = JSON.parse('${jsonReceivingUserList}');
		var receivingUserTable = {
				url : contextPath+"/GIISEventModuleController?action=getGiiss168ReceivingUser&eventModCd=" + objGiiss168.eventModCd,
			id : "tbgReceivingUser",
			options : {
				width : 616,
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndexReceiving = y;
					objReceivingUser = tbgReceivingUser.geniisysRows[y];
					setReceivingUserFields(objReceivingUser);
					tbgReceivingUser.keys.removeFocus(tbgReceivingUser.keys._nCurrentFocus, true);
					tbgReceivingUser.keys.releaseKeys();
					
				},
				onRemoveRowFocus : function(){
					rowIndexReceiving = 1;
					setReceivingUserFields(null);
					tbgReceivingUser.keys.removeFocus(tbgReceivingUser.keys._nCurrentFocus, true);
					tbgReceivingUser.keys.releaseKeys();
				},
				beforeSort : function(){
					if(userListChangeTag2 == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSaveUserList").focus();
						});
						return false;
					}					
				},
				onSort: function(){
					rowIndexReceiving = 1;
					setReceivingUserFields(null);
					tbgReceivingUser.keys.removeFocus(tbgReceivingUser.keys._nCurrentFocus, true);
					tbgReceivingUser.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndexReceiving = 1;
					setReceivingUserFields(null);
					tbgReceivingUser.keys.removeFocus(tbgReceivingUser.keys._nCurrentFocus, true);
					tbgReceivingUser.keys.releaseKeys();
				},				
				prePager: function(){
					if(userListChangeTag2 == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSaveUserList").focus();
						});
						return false;
					}
					rowIndexReceiving = 1;
					setReceivingUserFields(null);
					tbgReceivingUser.keys.removeFocus(tbgReceivingUser.keys._nCurrentFocus, true);
					tbgReceivingUser.keys.releaseKeys();
				},
				checkChanges: function(){
					return (userListChangeTag2 == 1 ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (userListChangeTag2 == 1 ? true : false);
				},
				masterDetailValidation: function(){
					return (userListChangeTag2 == 1 ? true : false);
				},
				masterDetail: function(){
					return (userListChangeTag2 == 1 ? true : false);
				},
				masterDetailSaveFunc: function() {
					return (userListChangeTag2 == 1 ? true : false);
				},
				masterDetailNoFunc: function(){
					return (userListChangeTag2 == 1 ? true : false);
				}
			},
			columnModel : [
				{ 								
				    id: 'recordStatus', 		
				    width: '0',				    
				    visible : false			
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},	
				{
					id : "userid",
					title : "User ID",
					filterOption : true,
					width : 180,
					renderer: function(val){
						return unescapeHTML2(val);
					}
				},
				{
					id : "userName",
					title : "User Name",
					filterOption : true,
					width : 410,
					renderer: function(val){
						return unescapeHTML2(val);
					}
				}
			],
			rows : []//receivingUserList.rows
		};

	tbgReceivingUser = new MyTableGrid(receivingUserTable);
	tbgReceivingUser.pager = [];//receivingUserList.rows;
	tbgReceivingUser.render("receivingUserTable");
	tbgReceivingUser.afterRender = function(){
		if(tbgReceivingUser.geniisysRows.length > 0){
			selectedReceivingUsers = getSelectedReceivingUsers();
		} else {
			selectedReceivingUsers = new Array();
		}
	};
	
	function setPassingUserFields(rec){
		rec == null ? enableButton("btnPassingAdd") : disableButton("btnPassingAdd");
		rec == null ? disableButton("btnPassingDelete") : enableButton("btnPassingDelete");
		if(rec != null) {
			$("txtPassingUserid").value = unescapeHTML2(rec.passingUserid);
			$("txtPassingUserName").value = unescapeHTML2(rec.userName);
			$("txtPassingUserid").setAttribute("lastValidValue", $F("txtPassingUserid"));
			$("txtPassingUserName").setAttribute("lastValidValue", $F("txtPassingUserName"));
			
			enableSearch("imgReceivingUser");
			$("txtReceivingUserid").readOnly = false;
			
			tbgReceivingUser.url = contextPath+"/GIISEventModuleController?action=getGiiss168ReceivingUser&eventModCd=" + objGiiss168.eventModCd
					+ "&passingUserid=" + $F("txtPassingUserid");		
			tbgReceivingUser._refreshList();
		} else {
			$("txtPassingUserid").clear();
			$("txtPassingUserName").clear();
			
			$("txtPassingUserid").setAttribute("lastValidValue", "");
			$("txtPassingUserName").setAttribute("lastValidValue", "");
			
			disableSearch("imgReceivingUser");
			$("txtReceivingUserid").readOnly = true;
			disableButton("btnReceivingAdd");
			disableButton("btnReceivingDelete");
			
			tbgReceivingUser.url = contextPath+"/GIISEventModuleController?action=getGiiss168ReceivingUser";		
			tbgReceivingUser._refreshList();
		}
	}
	
	function setReceivingUserFields (rec){		
		if(rec != null) {
			$("hidEventUserMod").value = rec.eventUserMod;
			$("txtReceivingUserid").value = unescapeHTML2(rec.userid);
			$("txtReceivingUserName").value = unescapeHTML2(rec.userName);
			$("txtReceivingUserid").setAttribute("lastValidValue", $F("txtReceivingUserid"));
			$("txtReceivingUserName").setAttribute("lastValidValue", $F("txtReceivingUserName"));
			disableSearch("imgReceivingUser");
			$("txtReceivingUserid").readOnly = true;
		} else {
			enableSearch("imgReceivingUser");
			$("txtReceivingUserid").readOnly = false;
			$("hidEventUserMod").clear();
			$("txtReceivingUserid").clear();
			$("txtReceivingUserName").clear();
		}
		
		if($("txtPassingUserid").value == ""){
			disableButton("btnReceivingAdd");
			disableButton("btnReceivingDelete");
			disableSearch("imgReceivingUser");
			$("txtReceivingUserid").readOnly = true;
		} else {
			rec == null ? enableButton("btnReceivingAdd") : disableButton("btnReceivingAdd");
			rec == null ? disableButton("btnReceivingDelete") : enableButton("btnReceivingDelete");	
		}
	}
	
	function getPassingUserLov(strSelectedPassingUsers) {
		LOV.show({
			controller : "WorkflowLOVController",
			urlParameters : {
				action : "getGiiss168PassingUserLov",
				filterText : ($F("txtPassingUserid") == $("txtPassingUserid").readAttribute("lastValidValue") ? "" : $F("txtPassingUserid")),
				eventModCd : objGiiss168.eventModCd,
				passingUserid : $F("txtPassingUserid"),
				selectedPassingUsers : strSelectedPassingUsers,
				page : 1
			},
			title : "",
			width : 480,
			height : 386,
			columnModel : [ {
				id : "userId",
				title : "User ID",
				width : '120px',
			}, {
				id : "userName",
				title : "Username",
				width : '345px',
				renderer: function(value) {
					return unescapeHTML2(value);
				}
			} ],
			draggable : true,
			autoSelectOneRecord: true,
			filterText : ($F("txtPassingUserid") == $("txtPassingUserid").readAttribute("lastValidValue") ? "" : $F("txtPassingUserid")),
			onSelect : function(row) {
				$("txtPassingUserid").value = unescapeHTML2(row.userId);
				$("txtPassingUserName").value = unescapeHTML2(row.userName);
				$("txtPassingUserid").setAttribute("lastValidValue", $F("txtPassingUserid"));
				$("txtPassingUserName").setAttribute("lastValidValue", $F("txtPassingUserName"));
			},
			onCancel : function () {
				$("txtPassingUserid").value = $("txtPassingUserid").readAttribute("lastValidValue");
				$("txtPassingUserName").value = $("txtPassingUserName").readAttribute("lastValidValue");
				$("txtPassingUserid").focus();
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", imgMessage.INFO);
				$("txtPassingUserid").value = $("txtPassingUserid").readAttribute("lastValidValue");
				$("txtPassingUserName").value = $("txtPassingUserName").readAttribute("lastValidValue");
				$("txtPassingUserid").focus();			
			}
		});
	}
	
	$("imgPassingUser").observe("click", function(){
		var strSelectedPassingUsers = "";
		var temp = selectedPassingUsers;
		
		for(i = 0; i < temp.length; i++){
			strSelectedPassingUsers += "'" + temp[i] + "',";
		}
		
		strSelectedPassingUsers = "'XXXXXXXXXX'," + strSelectedPassingUsers;
		strSelectedPassingUsers = "(" + strSelectedPassingUsers.substr(0, strSelectedPassingUsers.length - 1) + ")";
		getPassingUserLov(strSelectedPassingUsers);
	});
	
	$("txtPassingUserid").observe("change", function(){
		if(this.value.trim() == "") {
			this.clear();
			$("txtPassingUserName").clear();
			$("txtPassingUserid").setAttribute("lastValidValue", "");
			$("txtPassingUserName").setAttribute("lastValidValue", "");
			return;
		}
		$("imgPassingUser").click();
	});
	
	function getReceivingUserLov(strSelectedReceivingUsers) {
		LOV.show({
			controller : "WorkflowLOVController",
			urlParameters : {
				action : "getGiiss168ReceivingUserLov",
				filterText : ($F("txtReceivingUserid") == $("txtReceivingUserid").readAttribute("lastValidValue") ? "" : $F("txtReceivingUserid")),
				eventModCd : objGiiss168.eventModCd,
				passingUserid : $F("txtPassingUserid"),
				selectedReceivingUsers : strSelectedReceivingUsers,
				page : 1
			},
			title : "",
			width : 480,
			height : 386,
			columnModel : [ {
				id : "userId",
				title : "User ID",
				width : '120px',
			}, {
				id : "userName",
				title : "Username",
				width : '345px',
				renderer: function(value) {
					return unescapeHTML2(value);
				}
			} ],
			draggable : true,
			autoSelectOneRecord: true,
			filterText : ($F("txtReceivingUserid") == $("txtReceivingUserid").readAttribute("lastValidValue") ? "" : $F("txtReceivingUserid")),
			onSelect : function(row) {
				$("txtReceivingUserid").value = unescapeHTML2(row.userId);
				$("txtReceivingUserName").value = unescapeHTML2(row.userName);
				$("txtReceivingUserid").setAttribute("lastValidValue", $F("txtReceivingUserid"));
				$("txtReceivingUserName").setAttribute("lastValidValue", $F("txtReceivingUserName"));
				
				var count = tbgReceivingUser.geniisysRows.length;
				
				if(objGiiss168.receiverTag == "Z"){
					$("txtReceivingUserid").clear();
					$("txtReceivingUserName").clear();
					$("txtReceivingUserid").setAttribute("lastValidValue", "");
					$("txtReceivingUserName").setAttribute("lastValidValue", "");
					showMessageBox("This event does automatically assigns the receiver for the processed record.", "I");
				} else if (objGiiss168.receiverTag == "O" && count >= 1){
					$("txtReceivingUserid").clear();
					$("txtReceivingUserName").clear();
					$("txtReceivingUserid").setAttribute("lastValidValue", "");
					$("txtReceivingUserName").setAttribute("lastValidValue", "");
					showMessageBox("Only one (1) receiver is allowed for the processed record.", "I");
				}
			},
			onCancel : function () {
				$("txtReceivingUserid").value = $("txtReceivingUserid").readAttribute("lastValidValue");
				$("txtReceivingUserName").value = $("txtReceivingUserName").readAttribute("lastValidValue");
				$("txtReceivingUserid").focus();
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", imgMessage.INFO);
				$("txtReceivingUserid").value = $("txtReceivingUserid").readAttribute("lastValidValue");
				$("txtReceivingUserName").value = $("txtReceivingUserName").readAttribute("lastValidValue");
				$("txtReceivingUserid").focus();			
			}
		});
	}
	
	$("imgReceivingUser").observe("click", function(){
		var strSelectedReceivingUsers = "";
		var temp = selectedReceivingUsers;  
		
		for(i = 0; i < temp.length; i++){
			strSelectedReceivingUsers += "'" + temp[i] + "',";
		}
		
		strSelectedReceivingUsers = "'XXXXXXXXXX'," + strSelectedReceivingUsers;
		strSelectedReceivingUsers = "(" + strSelectedReceivingUsers.substr(0, strSelectedReceivingUsers.length - 1) + ")";
		getReceivingUserLov(strSelectedReceivingUsers);
	});
	
	$("txtReceivingUserid").observe("change", function(){
		if(this.value.trim() == "") {
			this.clear();
			$("txtReceivingUserName").clear();
			$("txtReceivingUserid").setAttribute("lastValidValue", "");
			$("txtReceivingUserName").setAttribute("lastValidValue", "");
			return;
		}
		$("imgReceivingUser").click();
	});
	
	function getSelectedPassingUsers(){
		var selectedPassingUsers = new Array();
		new Ajax.Request(contextPath + "/GIISEventModuleController",{
			method: "POST",
			parameters: {
				action : "getGiiss168SelectedPassingUsers",
			    eventModCd : objGiiss168.eventModCd,
			    passingUserid : $F("txtPassingUserid")
			},
			asynchronous: false,
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					var temp = trim(response.responseText);
					temp = temp.substring(0, temp.length - 1);
					selectedPassingUsers = temp.split(",");
				}
			}
		});
		
		return selectedPassingUsers;
	}
	
	function getSelectedReceivingUsers(){
		var selectedReceivingUsers = new Array();
		new Ajax.Request(contextPath + "/GIISEventModuleController",{
			method: "POST",
			parameters: {
				action : "getGiiss168SelectedReceivingUsers",
			    eventModCd : objGiiss168.eventModCd,
			    passingUserid : $F("txtPassingUserid")
			},
			asynchronous: false,
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					var temp = trim(response.responseText);
					temp = temp.substring(0, temp.length - 1);
					selectedReceivingUsers = temp.split(",");
				}
			}
		});
		
		return selectedReceivingUsers;
	}
	
	$("btnExitUserList").observe("click", function(){		
		if(userListChangeTag != 0 || userListChangeTag2 != 0){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
				function(){
					objGiiss168.exitUserList = true;
					saveGiiss168UserList();
				}, function(){
					overlayUserList.close();
					delete overlayUserList;
				}, "");
		} else {
			overlayUserList.close();
			delete overlayUserList;
		}
	});
		
	function addPassingUser(){
		try {
			if($("txtPassingUserid").value.trim() == ""){
				showMessageBox(objCommonMessage.REQUIRED, "I");
				$("txtPassingUserid").focus();
				return;
			}				
			
			if($F("btnPassingAdd") == "Add")
				selectedPassingUsers.push($F("txtPassingUserid"));
			else {
				for (i = 0; i < selectedPassingUsers.length; i++){
					if(tbgPassingUser.geniisysRows[rowIndexPassing].passingUserid == selectedPassingUsers[i])
						selectedPassingUsers.splice(i, 1);
				}
				
				selectedPassingUsers.push($F("txtPassingUserid"));					
			}			
			
			var dept = setPassingUser(objPassingUser);
			if($F("btnPassingAdd") == "Add"){
				tbgPassingUser.addBottomRow(dept);
			} else {
				tbgPassingUser.updateVisibleRowOnly(dept, rowIndexPassing, false);
			}
			userListChangeTag = 1;
			tbgPassingUser.keys.removeFocus(tbgPassingUser.keys._nCurrentFocus, true);
			tbgPassingUser.keys.releaseKeys();
			setPassingUserFields(null);
			
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}
	
	function addReceivingUser(){
		try {
			if($("txtReceivingUserid").value.trim() == ""){
				showMessageBox(objCommonMessage.REQUIRED, "I");
				$("txtReceivingUserid").focus();
				return;
			}
			
			if($F("btnReceivingAdd") == "Add")
				selectedReceivingUsers.push($F("txtReceivingUserid"));
			else {
				for (i = 0; i < selectedReceivingUsers.length; i++){
					if(tbgReceivingUser.geniisysRows[rowIndexReceiving].userid == selectedReceivingUsers[i])
						selectedReceivingUsers.splice(i, 1);
				}
				
				selectedReceivingUsers.push($F("txtReceivingUserid"));					
			}			
			
			var dept = setReceivingUser(objReceivingUser);
			if($F("btnReceivingAdd") == "Add"){
				tbgReceivingUser.addBottomRow(dept);
			} else {
				tbgReceivingUser.updateVisibleRowOnly(dept, rowIndexReceiving, false);
			}
			userListChangeTag2 = 1;
			setReceivingUserFields(null);
			tbgReceivingUser.keys.removeFocus(tbgReceivingUser.keys._nCurrentFocus, true);
			tbgReceivingUser.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}
	
	function setPassingUser(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.eventModCd = objGiiss168.eventModCd;
			obj.passingUserid = $F("txtPassingUserid"); 
			obj.userName = $F("txtPassingUserName");
			obj.recordStatus = 0;
			
			return obj;
		} catch(e){
			showErrorMessage("setPassingUser", e);
		}
	}
	
	function setReceivingUser(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.eventUserMod = $F("hidEventUserMod");
			obj.eventModCd = objGiiss168.eventModCd;
			obj.userid = $F("txtReceivingUserid");			
			obj.passingUserid = $F("txtPassingUserid"); 
			obj.userName = $F("txtReceivingUserName");
			
			return obj;
		} catch(e){
			showErrorMessage("setPassingUser", e);
		}
	}
	
	$("btnPassingAdd").observe("click", addPassingUser);
	$("btnReceivingAdd").observe("click", addReceivingUser);
		
	function deleteReceivingUser(){
		for(var x = 0; x < selectedReceivingUsers.size(); x++){
			if(selectedReceivingUsers[x] == $F("txtReceivingUserid"))
				selectedReceivingUsers.splice(x, 1);
		}
		
		objReceivingUser.recordStatus = -1;
		tbgReceivingUser.deleteRow(rowIndexReceiving);
		userListChangeTag2 = 1;
		setReceivingUserFields(null);	
	}
	
	$("btnReceivingDelete").observe("click", deleteReceivingUser);
	
	
	
	function deletePassingUsers(){
		for(var x = 0; x < selectedPassingUsers.size(); x++){
			if(selectedPassingUsers[x] == $F("txtPassingUserid"))
				selectedPassingUsers.splice(x, 1);
		}
		
		objPassingUser.recordStatus = -1;
		tbgPassingUser.deleteRow(rowIndexPassing);
		userListChangeTag = 1;
		setPassingUserFields(null);
	}
	
	function valDeletePassingUsers(){
		if(tbgPassingUser.geniisysRows[rowIndexPassing].recordStatus == "0"){
			if(tbgReceivingUser.geniisysRows.length > 0){
				var temp = false;
				for(var x = 0; x < tbgReceivingUser.geniisysRows.length; x++){
					if(tbgReceivingUser.geniisysRows[x].recordStatus != -1)
					temp = true;
				}
				if(temp)
					showMessageBox("Cannot delete record while dependent record(s) exists.", "E");
				else {
					deletePassingUsers();
					userListChangeTag2 = 0;
				}
					
			} else {
				deletePassingUsers();
			}
		} else {
			try{
				new Ajax.Request(contextPath + "/GIISEventModuleController", {
					parameters : {action : "valDelGiiss168PassingUsers",
								  eventModCd : objGiiss168.eventModCd,
								  passingUserid : $F("txtPassingUserid")},
					onCreate : showNotice("Processing, please wait..."),
					onComplete : function(response){
						hideNotice();
						if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
							deletePassingUsers();
						}
					}
				});
			} catch(e){
				showErrorMessage("valDeleteRec", e);
			}
		}		
	}
	
	$("btnPassingDelete").observe("click", valDeletePassingUsers);
	/* $("btnPassingDelete").observe("click", function(){
		
	}); */
		
	} catch (e) {
		showErrorMessage("userList", e);
	}
</script>