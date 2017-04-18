<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="giiss041MainDiv" name="giiss041MainDiv">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="btnExit">Exit</a></li>
			</ul>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Maintain User Groups</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>
	
	<div id="giiss041" name="giiss041">
		<div class="sectionDiv">
			<div style="padding-top: 10px;">
				<div id="userGrpTable" style="height: 340px; margin-left: 170px;"></div>
			</div>
			
			<div align="center" id="userGrpFormDiv" style="margin-right: 30px;">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">User Group</td>
						<td class="leftAligned" colspan="3"><input id="userGrp" type="text" class="required integerNoNegativeUnformattedNoComma" style="width: 200px; text-align: right;" lastValidValue="" maxlength="4" tabindex="101"></td>
					</tr>
					<tr>
						<td class="rightAligned">Description</td>
						<td class="leftAligned" colspan="3">
							<input id="userGrpDesc" type="text" class="required upper" style="width: 533px;" tabindex="102" maxlength="50">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Group Issue Source</td>
						<td class="leftAligned" colspan="3">
							<span class="required lovSpan" style="width: 100px; height: 21px; margin: 0; float: left;">
								<input id="grpIssCd" type="text" class="required upper" style="width: 70px; height: 13px; float: left; border: none;" lastValidValue="" maxlength="2" tabindex="103" ignoreDelKey="">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchGrpIssCd" name="searchGrpIssCd" alt="Go" style="float: right;">
							</span>
							<input id="issName" type="text" style="width: 428px; margin: 0 0 3px 3px; height: 15px;" tabindex="104" readonly="readonly">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="remarks" name="remarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="105"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="userId" type="text" class="" style="width: 200px; margin-right: 46px;" readonly="readonly" tabindex="106"></td>
						<td class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="lastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="107"></td>
					</tr>
				</table>
			</div>
			
			<div style="margin: 10px;" align="center">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="108">
				<input type="button" class="disabledButton" id="btnDelete" value="Delete" tabindex="109">
			</div>
			
			<div style="margin: 10px; padding: 10px; border-top: 1px solid #E0E0E0; margin-bottom: 0;" align="center">
				<input type="button" class="disabledButton" id="btnTransaction" value="Transaction" style="width: 150px;" tabindex="110">
			</div>
		</div>
	</div>
	<div class="buttonsDiv">
		<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="111">
		<input type="button" class="button" id="btnSave" value="Save" tabindex="112">
	</div>
</div>
<div id="userGrpTranDiv"></div>

<script type="text/javascript">
	var rowIndex = -1;
	var objGIISS041 = {};
	var selectedRow = null;
	objGIISS041.userGrpList = JSON.parse('${userGrpJSON}');
	objGIISS041.exitPage = null;
	
	var userGrpModel = {
		id: 411,
		url: contextPath + "/GIISUserGroupMaintenanceController?action=showGIISS041&refresh=1",
		options: {
			width: '610px',
			height: '332px',
			pager: {},
			onCellFocus: function(element, value, x, y, id){
				rowIndex = y;
				selectedRow = userGrpTG.geniisysRows[y];
				setFieldValues(selectedRow);
				userGrpTG.keys.removeFocus(userGrpTG.keys._nCurrentFocus, true);
				userGrpTG.keys.releaseKeys();
				$("userGrp").focus();
			},
			onRemoveRowFocus: function(){
				rowIndex = -1;
				setFieldValues(null);
				userGrpTG.keys.removeFocus(userGrpTG.keys._nCurrentFocus, true);
				userGrpTG.keys.releaseKeys();
				$("userGrp").focus();
			},
			toolbar: {
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
				onFilter: function(){
					userGrpTG.onRemoveRowFocus();
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
				userGrpTG.onRemoveRowFocus();
			},
			onRefresh: function(){
				userGrpTG.onRemoveRowFocus();
			},				
			prePager: function(){
				if(changeTag == 1){
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
						$("btnSave").focus();
					});
					return false;
				}
				userGrpTG.onRemoveRowFocus();
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
			{   id: 'recordStatus',
			    width: '0',				    
			    visible: false			
			},
			{	id: 'divCtrId',
				width: '0',
				visible: false
			},
			{	id: 'userGrp',
				title: 'User Group',
				width: '80px',
				align: 'right',
				titleAlign: 'right',
				filterOption: true,
				filterOptionType: 'integerNoNegative',
				renderer: function(value){
					return lpad(value, 4, "0");
				}
			},
			{	id: 'userGrpDesc',
				title: 'Description',
				width: '350px',
				filterOption: true
			},
			{	id: 'issName',
				title: 'Group Issue Source',
				width: '150px',
				filterOption: true
			}
		],
		rows : objGIISS041.userGrpList.rows
	};
	userGrpTG = new MyTableGrid(userGrpModel);
	userGrpTG.pager = objGIISS041.userGrpList;
	userGrpTG.render("userGrpTable");
	
	function showUserGrpLOV(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {
				action: "getGIISS041UserGrpLOV"
			},
			title: "List of User Groups",
			width: 365,
			height: 386,
			columnModel:[
							{	id: "userGrp",
								title: "User Group",
								width: "90px",
								align: 'right',
								titleAlign: 'right'
							},
							{	id: "userGrpDesc",
								title: "Group Description",
								width: "260px"
							}
						],
			draggable: true,
			showNotice: true,
			autoSelectOneRecord : true,
		    noticeMessage: "Getting list, please wait...",
			onSelect : function(row){
				if(row != undefined) {
					addRec(row.userGrp);
				}
			},
			onCancel: function(){
				addRec();
			},
			onUndefinedRow: function(){
				showMessageBox("No record selected.", "I");
				addRec();
			},
			onShow: function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		});
	}
	
	function showGrpIssCdLOV(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {
				action: "getGIISS041GrpIssCdLOV",
				filterText: $F("grpIssCd") != $("grpIssCd").getAttribute("lastValidValue") ? nvl($F("grpIssCd"), "%") : "%"
			},
			title: "List of Group Issue Sources",
			width: 365,
			height: 386,
			columnModel:[
							{	id: "issCd",
								title: "Issue Code",
								width: "100px"
							},
							{	id: "issName",
								title: "Name",
								width: "250px"
							}
						],
			draggable: true,
			showNotice: true,
			autoSelectOneRecord : true,
			filterText: $F("grpIssCd") != $("grpIssCd").getAttribute("lastValidValue") ? nvl($F("grpIssCd"), "%") : "%",
		    noticeMessage: "Getting list, please wait...",
			onSelect : function(row){
				if(row != undefined) {
					$("grpIssCd").value = unescapeHTML2(row.issCd);
					$("issName").value = unescapeHTML2(row.issName);
					$("grpIssCd").setAttribute("lastValidValue", unescapeHTML2(row.issCd));
				}
			},
			onCancel: function(){
				$("grpIssCd").value = $("grpIssCd").getAttribute("lastValidValue");
			},
			onUndefinedRow: function(){
				showMessageBox("No record selected.", "I");
				$("grpIssCd").value = $("grpIssCd").getAttribute("lastValidValue");
			},
			onShow: function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		});
	}
	
	function newFormInstance(){
		$("userGrp").focus();
		setModuleId("GIISS041");
		setDocumentTitle("Maintain User Groups");
		initializeAll();
		makeInputFieldUpperCase();
		changeTag = 0;
	}
	
	function setFieldValues(rec){
		try{
			$("userGrp").value = (rec == null ? "" : lpad(rec.userGrp, 4, "0"));
			$("userGrp").setAttribute("lastValidValue", (rec == null ? "" : $F("userGrp")));
			$("userGrpDesc").value = (rec == null ? "" : unescapeHTML2(rec.userGrpDesc));
			$("grpIssCd").value = (rec == null ? "" : unescapeHTML2(rec.grpIssCd));
			$("grpIssCd").setAttribute("lastValidValue", (rec == null ? "" : $F("grpIssCd")));
			$("issName").value = (rec == null ? "" : unescapeHTML2(rec.issName));
			$("remarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("userId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("lastUpdate").value = (rec == null ? "" : rec.dspLastUpdate);
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("userGrp").readOnly = false : $("userGrp").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			rec == null ? disableButton("btnTransaction") : enableButton("btnTransaction");
			
			selectedRow = rec;
		}catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISUserGroupMaintenanceController", {
				parameters: {
					action: "valDeleteRec",
					userGrp: $F("userGrp")
				},
				asynchronous: false,
				evalScripts: true,
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
	
	function deleteRec(){
		changeTagFunc = saveGIISS041;
		selectedRow.recordStatus = -1;
		userGrpTG.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function confirmCopy(){
		showConfirmBox("Confirmation", "Do you want to copy records from another user group?", "Ok", "Cancel",
			function(){
				showConfirmBox("Confirmation", "Transactions of the selected group will be saved on the newly " + 
					"created user group.  Do you want to continue?", "Ok", "Cancel",
					showUserGrpLOV,
					addRec, "1");
			}, addRec, "1");
	}
	
	function valAddRec(){
		try{
			var proceed = false;
			if(checkAllRequiredFieldsInDiv("userGrpFormDiv")){
				for(var i = 0; i < userGrpTG.geniisysRows.length; i++){
					var row = userGrpTG.geniisysRows[i];
					
					if(row.recordStatus != -1 && i != rowIndex){
						if(row.userGrp == $F("userGrp")){
							showMessageBox("Record already exists with the same user_grp.", "E");
							return;
						}
					}
					if(row.recordStatus == -1 && row.userGrp == $F("userGrp")){
						proceed = true;
					}
				}
				if(proceed){
					confirmCopy();
					return;
				}
				
				if($F("btnAdd") == "Add") {
					new Ajax.Request(contextPath + "/GIISUserGroupMaintenanceController", {
						parameters: {
							action: "valAddRec",
							userGrp: $F("userGrp")
						},
						asynchronous: false,
						evalScripts: true,
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								confirmCopy();
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
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			
			obj.userGrp = $F("userGrp");
			obj.userGrpDesc = escapeHTML2($F("userGrpDesc"));
			obj.grpIssCd = escapeHTML2($F("grpIssCd"));
			obj.issName = escapeHTML2($F("issName"));
			obj.remarks = escapeHTML2($F("remarks"));
			obj.userId = userId;
			obj.dspLastUpdate = dateFormat(new Date(), 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(copy){
		try{
			changeTagFunc = saveGIISS041;
			var row = setRec(selectedRow);
			
			if($F("btnAdd") == "Add"){
				row.copyTag = nvl(copy, 0);
				userGrpTG.addBottomRow(row);
			} else {
				userGrpTG.updateVisibleRowOnly(row, rowIndex, false);
			}
			
			changeTag = 1;
			setFieldValues(null);
			userGrpTG.keys.removeFocus(userGrpTG.keys._nCurrentFocus, true);
			userGrpTG.keys.releaseKeys();
		}catch(e){
			showErrorMessage("addRec", e);
		}
	}
	
	function saveGIISS041(){
		var setRows = getAddedAndModifiedJSONObjects(userGrpTG.geniisysRows);
		var delRows = getDeletedJSONObjects(userGrpTG.geniisysRows);
		
		new Ajax.Request(contextPath+"/GIISUserGroupMaintenanceController", {
			method: "POST",
			parameters: {
				action: "saveGIISS041",
				setRows: prepareJsonAsParameter(setRows),
				delRows: prepareJsonAsParameter(delRows)
			},
			asynchronous: false,
			evalScripts: true,
			onCreate : showNotice("Saving, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS041.exitPage != null) {
							objGIISS041.exitPage();
						} else {
							userGrpTG._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	function exitPage(){
		changeTag = 0;
		goToModule("/GIISUserController?action=goToSecurity", "Security Main", null);
	}
	
	function cancelGIISS041(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
				function(){
					objGIISS041.exitPage = exitPage;
					saveGIISS041();
				}, exitPage, "");
		} else {
			exitPage();
		}
	}
	
	function showUserGrpTransactions(){
		if(changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			return;
		}
		
		new Ajax.Request(contextPath + "/GIISUserGroupMaintenanceController", {
			parameters: {
				action: "showUserGrpTransactions",
				userGrp: $F("userGrp")
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: showNotice("Retrieving User Group Transactions, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("giiss041MainDiv").hide();
					$("userGrpTranDiv").update(response.responseText);
				}
			}
		});
	}
	
	$w("userGrp grpIssCd").each(function(e){
		$(e).observe("focus", function(){
			$(e).setAttribute("lastValidValue", $F(e));
		});
	});
	
	$("userGrp").observe("change", function(){
		if($F("userGrp") != "" && (isNaN($F("userGrp")) || parseInt($F("userGrp")) < 1  || $F("userGrp").include("."))){
			showWaitingMessageBox("Invalid User Group. Valid value should be from 1 to 9999.", "E", function(){
				$("userGrp").value = $("userGrp").getAttribute("lastValidValue");
			});
		}else if($F("userGrp") != ""){
			$("userGrp").value = lpad($F("userGrp"), 4, "0");
		}
	});
	
	$("grpIssCd").observe("change", function(){
		if($F("grpIssCd") == ""){
			$("grpIssCd").setAttribute("lastValidValue", "");
			$("issName").value = "";
		}else{
			showGrpIssCdLOV();
		}
	});
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("remarks", 4000, $("remarks").hasAttribute("readonly"));
	});
	
	$("btnExit").stopObserving("click");
	$("btnExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	$("searchGrpIssCd").observe("click", showGrpIssCdLOV);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);
	$("btnCancel").observe("click", cancelGIISS041);
	$("btnTransaction").observe("click", showUserGrpTransactions);
	
	observeSaveForm("btnSave", saveGIISS041);
	observeReloadForm("reloadForm", showGiiss041);
	newFormInstance();
</script>