<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss180MainDiv" name="giiss180MainDiv" style="">
	<div id="geninInfoDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="geninInfoExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Initial and General Information</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss180" name="giiss180">		
		<div class="sectionDiv">
			<div id="geninInfoTableDiv" style="padding-top: 10px;">
				<div id="geninInfoTable" style="height: 332px; margin-left: 165px;"></div>
			</div>
			<div align="center" id="geninInfoFormDiv">
				<table style="margin-top: 20px;">
					<tr>
						<td></td>
						<td colspan="2">
							<input id="initialInfoRB" name="nbtInfoRG" type="radio" value="I" checked="checked" style="float: left; margin-bottom: 8px;"><label for="initialInfoRB" style="margin: 2px 4px 10px 2px;">Initial Information</label>
							<input id="genInfoRB" name="nbtInfoRG" type="radio" value="G" style="float: left; margin-bottom: 8px;"><label for="genInfoRB" style="margin: 2px 4px 10px 2px;">General Information</label><!-- moved by carlo -->
						</td>
						<td class="rightAligned"> <!-- added by carlo 01-23-2017 SR 5915-->
							<input type="checkbox" id="chkActiveTag" name="chkActiveTag" class="required" style="margin-right: 5px;"/><label for="chkActiveTag" style="float: right;">Active Tag</label>
						</td>
						<td></td>
						<!-- <td>
							<input id="genInfoRB" name="nbtInfoRG" type="radio" value="G" style="float: left; margin-bottom: 8px;"><label for="genInfoRB" style="margin: 2px 4px 10px 2px;">General Information</label>
						</td> comment out by carlo-->
					</tr>
					<tr>
						<td class="rightAligned">Code/Title</td>
						<td class="leftAligned" colspan="3">
							<input id="txtGeninInfoCd" type="text" class="required allCaps" style="width: 72px; " tabindex="201" maxlength="5">						
							<input id="txtGeninInfoTitle" type="text" class="required allCaps" style="width: 450px; " tabindex="202" maxlength="500">
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned" style="vertical-align: top;">General / Initial <br>Information Text</td>
						<td class="leftAligned" colspan="3">
							<textarea id="txtNbtInitialGenInfo" draggable="false" style="width: 533px; height: 150px;" tabindex="203" maxlength="32767" ></textarea>
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="204"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="205"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned" ><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="206"></td>
						<td width="" class="rightAligned" style="padding-left: 45px;">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="207"></td>
					</tr>	
				</table>
			</div>
			<div class="buttonsDiv" style="margin: 10px 0 10px 0;">
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
	setModuleId("GIISS180");
	setDocumentTitle("Initial and General Information");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	var nbtInfo = "I";
			
	function saveGiiss180(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgGeninInfo.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgGeninInfo.geniisysRows);
		new Ajax.Request(contextPath+"/GIISGeninInfoController", {
			method: "POST",
			parameters : {action : "saveGiiss180",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS180.exitPage != null) {
							objGIISS180.exitPage();
						} else {
							tbgGeninInfo._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss180);
	
	var objGIISS180 = {};
	var objGeninInfo = null;
	objGIISS180.geninInfoList = JSON.parse('${jsonGeninInfoList}');
	objGIISS180.exitPage = null;
	
	var geninInfoTableModel = {
			url : contextPath + "/GIISGeninInfoController?action=showGiiss180&refresh=1",
			options : {
				width : '622px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objGeninInfo = tbgGeninInfo.geniisysRows[y];
					setFieldValues(objGeninInfo);
					tbgGeninInfo.keys.removeFocus(tbgGeninInfo.keys._nCurrentFocus, true);
					tbgGeninInfo.keys.releaseKeys();
					$("txtGeninInfoTitle").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgGeninInfo.keys.removeFocus(tbgGeninInfo.keys._nCurrentFocus, true);
					tbgGeninInfo.keys.releaseKeys();
					$("txtGeninInfoCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgGeninInfo.keys.removeFocus(tbgGeninInfo.keys._nCurrentFocus, true);
						tbgGeninInfo.keys.releaseKeys();
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
					tbgGeninInfo.keys.removeFocus(tbgGeninInfo.keys._nCurrentFocus, true);
					tbgGeninInfo.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgGeninInfo.keys.removeFocus(tbgGeninInfo.keys._nCurrentFocus, true);
					tbgGeninInfo.keys.releaseKeys();
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
					tbgGeninInfo.keys.removeFocus(tbgGeninInfo.keys._nCurrentFocus, true);
					tbgGeninInfo.keys.releaseKeys();
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
					id : 'geninInfoCd',
					filterOption : true,
					title : 'Code',
					width : '130px'				
				},
				{
					id : 'geninInfoTitle',
					filterOption : true,
					title : 'Title',
					width : '385px'				
				},
				{	id: 'activeTag', //added by carlo
					title: 'A',
					altTitle: 'Active Tag',
					titleAlign: 'center',
					align :"center",
					width: '20px',
					visible: true,
					sortable: false,
					defaultValue: false,
					otherValue: false,
			    	editor: new MyTableGrid.CellCheckbox({
				        getValueOf: function(value){
				        	if (value){
								return "A";
			            	}else{
								return "I";	
			            	}
				        }
			    	})
				},
				{
					id : 'nbtInitialGenInfo',
					visible: false,
					width : '0px'			
				},	
				{
					id : 'nbtInfo',
					width : '0',
					visible: false				
				},
				{
					id : 'genInfo01',
					width : '0',
					visible: false				
				},
				{
					id : 'genInfo02',
					width : '0',
					visible: false
				},
				{
					id : 'genInfo03',
					width : '0',
					visible: false				
				},
				{
					id : 'genInfo04',
					width : '0',
					visible: false
				},
				{
					id : 'genInfo05',
					width : '0',
					visible: false				
				},
				{
					id : 'genInfo06',
					width : '0',
					visible: false
				},
				{
					id : 'genInfo07',
					width : '0',
					visible: false				
				},
				{
					id : 'genInfo08',
					width : '0',
					visible: false
				},
				{
					id : 'genInfo09',
					width : '0',
					visible: false				
				},
				{
					id : 'genInfo10',
					width : '0',
					visible: false
				},
				{
					id : 'genInfo11',
					width : '0',
					visible: false				
				},
				{
					id : 'genInfo12',
					width : '0',
					visible: false
				},
				{
					id : 'genInfo13',
					width : '0',
					visible: false				
				},
				{
					id : 'genInfo14',
					width : '0',
					visible: false
				},
				{
					id : 'genInfo15',
					width : '0',
					visible: false				
				},
				{
					id : 'genInfo16',
					width : '0',
					visible: false
				},
				{
					id : 'genInfo17',
					width : '0',
					visible: false				
				},
				{
					id : 'initialInfo01',
					width : '0',
					visible: false				
				},
				{
					id : 'initialInfo02',
					width : '0',
					visible: false
				},
				{
					id : 'initialInfo03',
					width : '0',
					visible: false				
				},
				{
					id : 'initialInfo04',
					width : '0',
					visible: false
				},
				{
					id : 'initialInfo05',
					width : '0',
					visible: false				
				},
				{
					id : 'initialInfo06',
					width : '0',
					visible: false
				},
				{
					id : 'initialInfo07',
					width : '0',
					visible: false				
				},
				{
					id : 'initialInfo08',
					width : '0',
					visible: false
				},
				{
					id : 'initialInfo09',
					width : '0',
					visible: false				
				},
				{
					id : 'initialInfo10',
					width : '0',
					visible: false
				},
				{
					id : 'initialInfo11',
					width : '0',
					visible: false				
				},
				{
					id : 'initialInfo12',
					width : '0',
					visible: false
				},
				{
					id : 'initialInfo13',
					width : '0',
					visible: false				
				},
				{
					id : 'initialInfo14',
					width : '0',
					visible: false
				},
				{
					id : 'initialInfo15',
					width : '0',
					visible: false				
				},
				{
					id : 'initialInfo16',
					width : '0',
					visible: false
				},
				{
					id : 'initialInfo17',
					width : '0',
					visible: false				
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
			rows : objGIISS180.geninInfoList.rows
		};

		tbgGeninInfo = new MyTableGrid(geninInfoTableModel);
		tbgGeninInfo.pager = objGIISS180.geninInfoList;
		tbgGeninInfo.render("geninInfoTable");
	
	function setFieldValues(rec){
		try{
			rec == null ? $("initialInfoRB").checked = true : (rec.nbtInfo == "I" ? $("initialInfoRB").checked = true : $("genInfoRB").checked = true);
			nbtInfo = (rec == null ? "I" : rec.nbtInfo);
			$("txtGeninInfoCd").value = (rec == null ? "" : unescapeHTML2(rec.geninInfoCd));
			$("txtGeninInfoCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.geninInfoCd)));
			$("txtGeninInfoTitle").value = (rec == null ? "" : unescapeHTML2(rec.geninInfoTitle));
			$("txtNbtInitialGenInfo").value = (rec == null ? "" : unescapeHTML2(rec.nbtInitialGenInfo));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("chkActiveTag").checked = (rec == null ? "" : rec.activeTag == 'A' ? true : false); //carlo 01-26-2017
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtGeninInfoCd").readOnly = false : $("txtGeninInfoCd").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objGeninInfo = rec;
			
			if (rec != null) {
				new Ajax.Request(contextPath + "/GIISGeninInfoController", {
					parameters : {action : "allowUpdateGiiss180",
								  geninInfoCd : $F("txtGeninInfoCd")},
					//onCreate : showNotice("Processing, please wait..."), //removed by jdiago 08.28.2014 to avoid repeating notice everytime a record is selected
					onComplete : function(response){
						hideNotice();
						if(checkErrorOnResponse(response)){
							var allow = response.responseText;
							
							if (allow == "Y"){
								$("initialInfoRB").disabled = false;
								$("genInfoRB").disabled = false;
								//$("txtGeninInfoCd").readOnly = false;
								$("txtRemarks").readOnly = false;
							}else{
								$("initialInfoRB").disabled = true;
								$("genInfoRB").disabled = true;
								//$("txtGeninInfoCd").readOnly = true;
								$("txtRemarks").readOnly = true;
							}
						}
					}
				});
			}
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.geninInfoCd = escapeHTML2($F("txtGeninInfoCd"));
			obj.nbtInfo = nbtInfo;
			obj.geninInfoTitle = escapeHTML2($F("txtGeninInfoTitle"));
			obj.nbtInitialGenInfo = escapeHTML2($F("txtNbtInitialGenInfo"));
			obj.activeTag = $("chkActiveTag").checked ? "A" : "I"; //carlo 01-26-2017
			if (obj.nbtInfo == "I"){
				obj.genInfo01 = null;
				obj.genInfo02 = null;
				obj.genInfo03 = null;
				obj.genInfo04 = null;
				obj.genInfo05 = null;
				obj.genInfo06 = null;
				obj.genInfo07 = null;
				obj.genInfo08 = null;
				obj.genInfo09 = null;
				obj.genInfo10 = null;
				obj.genInfo11 = null;
				obj.genInfo12 = null;
				obj.genInfo13 = null;
				obj.genInfo14 = null;
				obj.genInfo15 = null;
				obj.genInfo16 = null;
				obj.genInfo17 = null;
				
				obj.initialInfo01 = escapeHTML2($F("txtNbtInitialGenInfo").substr(0, 2000));
				obj.initialInfo02 = escapeHTML2($F("txtNbtInitialGenInfo").substr(2000, 2000));
				obj.initialInfo03 = escapeHTML2($F("txtNbtInitialGenInfo").substr(4000, 2000));
				obj.initialInfo04 = escapeHTML2($F("txtNbtInitialGenInfo").substr(6000, 2000));
				obj.initialInfo05 = escapeHTML2($F("txtNbtInitialGenInfo").substr(8000, 2000));
				obj.initialInfo06 = escapeHTML2($F("txtNbtInitialGenInfo").substr(10000, 2000));
				obj.initialInfo07 = escapeHTML2($F("txtNbtInitialGenInfo").substr(12000, 2000));
				obj.initialInfo08 = escapeHTML2($F("txtNbtInitialGenInfo").substr(14000, 2000));
				obj.initialInfo09 = escapeHTML2($F("txtNbtInitialGenInfo").substr(16000, 2000));
				obj.initialInfo10 = escapeHTML2($F("txtNbtInitialGenInfo").substr(18000, 2000));
				obj.initialInfo11 = escapeHTML2($F("txtNbtInitialGenInfo").substr(20000, 2000));
				obj.initialInfo12 = escapeHTML2($F("txtNbtInitialGenInfo").substr(22000, 2000));
				obj.initialInfo13 = escapeHTML2($F("txtNbtInitialGenInfo").substr(24000, 2000));
				obj.initialInfo14 = escapeHTML2($F("txtNbtInitialGenInfo").substr(26000, 2000));
				obj.initialInfo15 = escapeHTML2($F("txtNbtInitialGenInfo").substr(28000, 2000));
				obj.initialInfo16 = escapeHTML2($F("txtNbtInitialGenInfo").substr(30000, 2000));
				obj.initialInfo17 = escapeHTML2($F("txtNbtInitialGenInfo").substr(32000, 767));
				
			}else{
				obj.initialInfo01 = null;
				obj.initialInfo02 = null;
				obj.initialInfo03 = null;
				obj.initialInfo04 = null;
				obj.initialInfo05 = null;
				obj.initialInfo06 = null;
				obj.initialInfo07 = null;
				obj.initialInfo08 = null;
				obj.initialInfo09 = null;
				obj.initialInfo10 = null;
				obj.initialInfo11 = null;
				obj.initialInfo12 = null;
				obj.initialInfo13 = null;
				obj.initialInfo14 = null;
				obj.initialInfo15 = null;
				obj.initialInfo16 = null;
				obj.initialInfo17 = null;

				obj.genInfo01 = escapeHTML2($F("txtNbtInitialGenInfo").substr(0, 2000));
				obj.genInfo02 = escapeHTML2($F("txtNbtInitialGenInfo").substr(2000, 2000));
				obj.genInfo03 = escapeHTML2($F("txtNbtInitialGenInfo").substr(4000, 2000));
				obj.genInfo04 = escapeHTML2($F("txtNbtInitialGenInfo").substr(6000, 2000));
				obj.genInfo05 = escapeHTML2($F("txtNbtInitialGenInfo").substr(8000, 2000));
				obj.genInfo06 = escapeHTML2($F("txtNbtInitialGenInfo").substr(10000, 2000));
				obj.genInfo07 = escapeHTML2($F("txtNbtInitialGenInfo").substr(12000, 2000));
				obj.genInfo08 = escapeHTML2($F("txtNbtInitialGenInfo").substr(14000, 2000));
				obj.genInfo09 = escapeHTML2($F("txtNbtInitialGenInfo").substr(16000, 2000));
				obj.genInfo10 = escapeHTML2($F("txtNbtInitialGenInfo").substr(18000, 2000));
				obj.genInfo11 = escapeHTML2($F("txtNbtInitialGenInfo").substr(20000, 2000));
				obj.genInfo12 = escapeHTML2($F("txtNbtInitialGenInfo").substr(22000, 2000));
				obj.genInfo13 = escapeHTML2($F("txtNbtInitialGenInfo").substr(24000, 2000));
				obj.genInfo14 = escapeHTML2($F("txtNbtInitialGenInfo").substr(26000, 2000));
				obj.genInfo15 = escapeHTML2($F("txtNbtInitialGenInfo").substr(28000, 2000));
				obj.genInfo16 = escapeHTML2($F("txtNbtInitialGenInfo").substr(30000, 2000));
				obj.genInfo17 = escapeHTML2($F("txtNbtInitialGenInfo").substr(32000, 767));

			}

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
			changeTagFunc = saveGiiss180;
			var geninInfo = setRec(objGeninInfo);
			if($F("btnAdd") == "Add"){
				tbgGeninInfo.addBottomRow(geninInfo);
			} else {
				tbgGeninInfo.updateVisibleRowOnly(geninInfo, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgGeninInfo.keys.removeFocus(tbgGeninInfo.keys._nCurrentFocus, true);
			tbgGeninInfo.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("geninInfoFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;					
					
					for(var i=0; i<tbgGeninInfo.geniisysRows.length; i++){
						if(tbgGeninInfo.geniisysRows[i].recordStatus == 0 || tbgGeninInfo.geniisysRows[i].recordStatus == 1){								
							if(unescapeHTML2(tbgGeninInfo.geniisysRows[i].geninInfoCd) == $F("txtGeninInfoCd")){
								addedSameExists = true;								
							}							
						} else if(tbgGeninInfo.geniisysRows[i].recordStatus == -1){
							if(unescapeHTML2(tbgGeninInfo.geniisysRows[i].geninInfoCd)  == $F("txtGeninInfoCd")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same genin_info_cd.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					
					new Ajax.Request(contextPath + "/GIISGeninInfoController", {
						parameters : {action : "valAddRec",
									  geninInfoCd : $F("txtGeninInfoCd")},
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
		changeTagFunc = saveGiiss180;
		objGeninInfo.recordStatus = -1;
		tbgGeninInfo.deleteRow(rowIndex);
		tbgGeninInfo.geniisysRows[rowIndex].geninInfoCd = tbgGeninInfo.geniisysRows[rowIndex].geninInfoCd.replace(/\\/g,"&#92;");
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISGeninInfoController", {
				parameters : {action : "valDeleteRec",
							  geninInfoCd : $F("txtGeninInfoCd")},
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
	
	function cancelGiiss180(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS180.exitPage = exitPage;
						saveGiiss180();
					}, function(){
						goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
		
	$$("input[name='nbtInfoRG']").each(function(rb){
		rb.observe("click", function(){
			nbtInfo = rb.value;
		});
	});
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGiiss180);
	$("btnCancel").observe("click", cancelGiiss180);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("geninInfoExit").stopObserving("click");
	$("geninInfoExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	$("txtGeninInfoCd").focus();	
</script>