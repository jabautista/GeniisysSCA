<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="gisms010MainDiv" name="gisms010MainDiv" style="">
	<div id="userRouteExitDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="smsExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>SMS Keyword Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="gisms010" name="gisms010">		
		<div class="sectionDiv">
			<div id="userRouteTableDiv" style="padding-top: 10px;">
				<div id="userRouteTable" style="height: 340px; margin-left: 115px;"></div>
			</div>
			<div align="center" id="userRouteFormDiv">
				<table style="margin-top: 5px;">				
					<tr>
						<td></td>
						<td class="leftAligned">
							<input type="checkbox" id="chkValidatePin"/><label for="chkValidatePin" style="float:right;margin-right:91px;" tabindex="204">Validate Pin</label>
						</td>
						<td class="leftAligned">
							<input type="checkbox" id="chkRestrictNumber"/><label for="chkRestrictNumber" style="float:right;margin-right:52px;" tabindex="204">Restrict Number</label>							
						</td>						
						<td class="leftAligned">
							<input type="checkbox" id="chkValidSw"/><label for="chkValidSw" style="float:right;margin-right: 76px;" tabindex="204">Valid Keyword</label>	
						</td>
					</tr>		
					<tr>
						<td width="" class="rightAligned">Keyword</td>
						<td class="leftAligned" colspan="3"><input id="txtKeyword" type="text" style="width: 530px;" readonly="readonly"></td>
					</tr>						
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 536px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 510px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="206"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="207"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 170px;" readonly="readonly"></td>
						<td width="170px" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 170px;" readonly="readonly"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;" align="center">
				<input type="button" class="button" id="btnUpdate" value="Update" tabindex="208">				
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="210">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="211">
</div>
<script type="text/javascript">	
	$("mainNav").hide();
	setModuleId("GISMS010");
	setDocumentTitle("SMS Keyword Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGisms010(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgUserRoute.geniisysRows);
		new Ajax.Request(contextPath+"/GISMUserRouteController", {
			method: "POST",
			parameters : {action : "saveGisms010",
					 	  setRows : prepareJsonAsParameter(setRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGISMS010.exitPage != null) {
							objGISMS010.exitPage();
						} else {
							tbgUserRoute._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}

	var objGISMS010 = {};
	var objCurrUserRoute = null;
	objGISMS010.userRouteList = JSON.parse('${jsonUserRouteList}');
	objGISMS010.exitPage = null;
	var userRouteTable = {
			url : contextPath + "/GISMUserRouteController?action=showGisms010&refresh=1",
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrUserRoute = tbgUserRoute.geniisysRows[y];
					setFieldValues(objCurrUserRoute);
					tbgUserRoute.keys.removeFocus(tbgUserRoute.keys._nCurrentFocus, true);
					tbgUserRoute.keys.releaseKeys();					
					$("txtRemarks").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgUserRoute.keys.removeFocus(tbgUserRoute.keys._nCurrentFocus, true);
					tbgUserRoute.keys.releaseKeys();
					$("txtRemarks").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgUserRoute.keys.removeFocus(tbgUserRoute.keys._nCurrentFocus, true);
						tbgUserRoute.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
					tbgUserRoute.keys.removeFocus(tbgUserRoute.keys._nCurrentFocus, true);
					tbgUserRoute.keys.releaseKeys();
				},
				onSort: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgUserRoute.keys.removeFocus(tbgUserRoute.keys._nCurrentFocus, true);
					tbgUserRoute.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgUserRoute.keys.removeFocus(tbgUserRoute.keys._nCurrentFocus, true);
					tbgUserRoute.keys.releaseKeys();
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
					tbgUserRoute.keys.removeFocus(tbgUserRoute.keys._nCurrentFocus, true);
					tbgUserRoute.keys.releaseKeys();
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
					id : "validatePin",
					title : "&nbsp;&nbsp;&nbsp;P",
					width : '33px',
					align : "center",
					titleAlign : "right",
					filterOption : true,
					altTitle : 'Validate Pin',
					editable : false,
					visible : true,
					defaultValue : true,
					otherValue : false,
					filterOptionType : 'checkbox',
					editor : new MyTableGrid.CellCheckbox({
						getValueOf : function(value) {
							if (value) {
								return "Y";
							} else {
								return "";
							}
						}
					})
				},{
					id : "restrictNumber",
					title : "&nbsp;&nbsp;&nbsp;N",
					width : '33px',
					align : "center",
					titleAlign : "right",
					filterOption : true,
					altTitle : 'Restrict Number',
					editable : false,
					visible : true,
					defaultValue : true,
					otherValue : false,
					filterOptionType : 'checkbox',
					editor : new MyTableGrid.CellCheckbox({
						getValueOf : function(value) {
							if (value) {
								return "Y";
							} else {
								return "";
							}
						}
					})
				},{
					id : "validSw",
					title : "&nbsp;&nbsp;&nbsp;V",
					width : '33px',
					align : "center",
					titleAlign : "right",
					filterOption : true,
					altTitle : 'Valid Keyword',
					editable : false,
					visible : true,
					defaultValue : true,
					otherValue : false,
					filterOptionType : 'checkbox',
					editor : new MyTableGrid.CellCheckbox({
						getValueOf : function(value) {
							if (value) {
								return "Y";
							} else {
								return "";
							}
						}
					})
				},
				{
					id : "keyword",
					title : "Keyword",
					filterOption : true,
					width : '170px'
				},
				{
					id : 'remarks',
					title : 'Remarks',
					filterOption : true,
					width : '390px'				
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
			rows : objGISMS010.userRouteList.rows
		};

		tbgUserRoute = new MyTableGrid(userRouteTable);
		tbgUserRoute.pager = objGISMS010.userRouteList;
		tbgUserRoute.render("userRouteTable");

	function setFieldValues(rec){
		try{
			$("txtKeyword").value = (rec == null ? "" : unescapeHTML2(rec.keyword));
			$("chkValidSw").checked = rec == null ? false
					: (rec.validSw == "Y" ? true : false);		
			$("chkValidatePin").checked = rec == null ? false
					: (rec.validatePin == "Y" ? true : false);
			$("chkRestrictNumber").checked = rec == null ? false
					: (rec.restrictNumber == "Y" ? true : false);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);			
			
			rec == null ? disableButton("btnUpdate") : enableButton("btnUpdate");
			objCurrUserRoute = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.keyword = $F("txtKeyword");
			obj.validSw = $("chkValidSw").checked ? "Y":"";	
			obj.validatePin = $("chkValidatePin").checked ? "Y":"";	
			obj.restrictNumber = $("chkRestrictNumber").checked ? "Y":"";		
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function exitPage() {
		goToModule("/GIISUserController?action=goToSMS", "SMS Main", null);
	}

	function cancelGisms010() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						objGISMS010.exitPage = exitPage;
						saveGisms010();
					}, function() {
						goToModule("/GIISUserController?action=goToSMS", "SMS Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToSMS", "SMS Main", null);
		}
	}

	function showGisms010(){
		try{ 
			new Ajax.Request(contextPath+"/GISMUserRouteController", {
				method: "GET",
				parameters: {
					action : "showGisms010"
				},
				evalScripts:true,
				asynchronous: true,
				onCreate: function (){
					showNotice("Loading, please wait...");
				},
				onComplete: function (response)	{
					hideNotice("");
					$("mainContents").update(response.responseText);
					Effect.Appear($("mainContents").down("div", 0), {
						duration: .001
					});
				}
			});		
		}catch(e){
			showErrorMessage("showGisms010",e);
		}	
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGisms010;
			var dept = setRec(objCurrUserRoute);	
			tbgUserRoute.updateVisibleRowOnly(dept, rowIndex, false);
			changeTag = 1;
			setFieldValues(null);
			tbgUserRoute.keys.removeFocus(tbgUserRoute.keys._nCurrentFocus, true);
			tbgUserRoute.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}	
	
	$("editRemarks").observe("click", function() {
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});	
	
	$("chkValidatePin").observe("click", function() {
		if($("chkValidatePin").checked==true&&(objCurrUserRoute.pinSw!="Y"||objCurrUserRoute.pinSw =="")){
			showWaitingMessageBox("Validation of PIN code is not valid for this keyword.", "I", function(){
				$("chkValidatePin").checked = false;
			});
		}	
	});	
	
	$("chkRestrictNumber").observe("click", function() {
		if($("chkRestrictNumber").checked==true&&(objCurrUserRoute.numberSw!="Y"||objCurrUserRoute.numberSw =="")){
			showWaitingMessageBox("Restriction of number is not valid for this keyword.", "I", function(){
				$("chkRestrictNumber").checked = false;
			});
		}			
	});	
	disableButton("btnUpdate");
	observeSaveForm("btnSave", saveGisms010);
	$("btnCancel").observe("click", cancelGisms010);
	$("btnUpdate").observe("click", addRec);
	
	observeReloadForm("reloadForm", showGisms010);
	$("smsExit").stopObserving("click");
	$("smsExit").observe("click", function() {
		fireEvent($("btnCancel"), "click");
	});
	$("txtRemarks").focus();
</script>