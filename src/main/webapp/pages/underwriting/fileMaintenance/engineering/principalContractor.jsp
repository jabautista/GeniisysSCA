<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss068MainDiv" name="giiss068MainDiv" style="">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="engPrincipalMaintenance">Exit</a></li>
			</ul>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Principal/Contractor Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss068" name="giiss068">		
		<div class="sectionDiv">
			<div id="engPrincipalTableDiv" style="padding-top: 10px;">
				<div id="engPrincipalTable" style="height: 340px;  margin-left: 10px;"></div>
			</div>
			<div align="center" id="engPrincipalFormDiv">
				<table style="margin-top: 10px;">
					<tr>
						<td class="rightAligned">Principal ID</td>
						<td class="leftAligned" colspan="3"><input id="txtPrincipalID" type="text" class="integerNoNegativeUnformattedNoComma" readonly="readonly" style="width: 200px; text-align: right;" tabindex="101" maxlength="12">
						</td>		
					</tr>	
					<tr>
						<td width="" class="rightAligned">Principal</td>
						<td class="leftAligned" colspan="3">
							<input id="txtPrincipalCd" type="text" class="required integerNoNegativeUnformattedNoComma" style="width: 94px; text-align: right;" tabindex="102" maxlength="6">
							<input id="txtPrincipalName" type="text" class="required" style="width: 426px;" tabindex="103" maxlength="50">
						</td>	
					</tr>
					<tr>
						<td class="rightAligned">Principal Type</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan required" style="float: left; width: 100px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input type="text" id="txtPrincipalType" name="txtPrincipalType" class="required" lastValidValue="" style="width: 75px; float: left; border: none; height: 15px; margin: 0;" maxlength="1" tabindex="104" />
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osPrincipalType" name="osPrincipalType" class="required" alt="Go" style="float: right;" />
							</span>
							<input id="txtPrincipalTypeMean" type="text" readonly="readonly" style="width: 426px;" tabindex="105" />
						</td>						
					</tr>
					<tr>
						<td class="rightAligned">Subline</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan required" style="float: left; width: 100px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input type="text" id="txtSublineCd" name="txtSublineCd" class="required" lastValidValue="" style="width: 75px; float: left; border: none; height: 15px; margin: 0;" maxlength="7" tabindex="106" />
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osSublineCd" name="osSublineCd" class="required" alt="Go" style="float: right;" />
							</span>
							<input id="txtSublineName" type="text" readonly="readonly" style="width: 426px;" tabindex="107" />
						</td>						
					</tr>
					<tr>
						<td class="rightAligned">Address</td>
						<td class="leftAligned" colspan="3"><input id="txtAddress1" class="required" type="text" tabindex="108" maxlength="50" style="width: 533px;" tabindex="108" /></td>
					</tr>
					<tr>
						<td class="rightAligned">&nbsp;</td>
						<td class="leftAligned" colspan="3"><input id="txtAddress2" type="text" tabindex="109" maxlength="50" style="width: 533px;" tabindex="109" /></td>
					</tr>
					<tr>
						<td class="rightAligned">&nbsp;</td>
						<td class="leftAligned" colspan="3"><input id="txtAddress3" type="text" tabindex="110" maxlength="50" style="width: 533px;" tabindex="110" /></td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 538px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 504px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="106"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="111"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="112" /></td>
						<td width="110px" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="113" /></td>
					</tr>			
				</table>
			</div>
			<div class="buttonsDiv" style="margin: 10px;">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="201" />
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="202" />
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv" style="margin:10px 0 10px 10px;">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="203">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="204">
</div>
<script type="text/javascript">	
	setModuleId("GIISS068");
	setDocumentTitle("Principal/Contractor Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiiss068(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgEngPrincipal.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgEngPrincipal.geniisysRows);
		new Ajax.Request(contextPath+"/GIISEngPrincipalController", {
			method: "POST",
			parameters : {action : "saveGiiss068",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS068.exitPage != null) {
							objGIISS068.exitPage();
						} else {
							tbgEngPrincipal._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss068);
	
	var objGIISS068 = {};
	var objCurrEngPrincipal = null;
	objGIISS068.engPrincipalList = JSON.parse('${jsonEngPrincipalList}') || [];
	objGIISS068.exitPage = null;
	
	var engPrincipalTable = {
			url : contextPath + "/GIISEngPrincipalController?action=showGiiss068&refresh=1",
			options : {
				width : '900px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrEngPrincipal = tbgEngPrincipal.geniisysRows[y];
					setFieldValues(objCurrEngPrincipal);
					tbgEngPrincipal.keys.removeFocus(tbgEngPrincipal.keys._nCurrentFocus, true);
					tbgEngPrincipal.keys.releaseKeys();
					$("txtPrincipalCd").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgEngPrincipal.keys.removeFocus(tbgEngPrincipal.keys._nCurrentFocus, true);
					tbgEngPrincipal.keys.releaseKeys();
					$("txtPrincipalCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgEngPrincipal.keys.removeFocus(tbgEngPrincipal.keys._nCurrentFocus, true);
						tbgEngPrincipal.keys.releaseKeys();
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
					tbgEngPrincipal.keys.removeFocus(tbgEngPrincipal.keys._nCurrentFocus, true);
					tbgEngPrincipal.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgEngPrincipal.keys.removeFocus(tbgEngPrincipal.keys._nCurrentFocus, true);
					tbgEngPrincipal.keys.releaseKeys();
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
					tbgEngPrincipal.keys.removeFocus(tbgEngPrincipal.keys._nCurrentFocus, true);
					tbgEngPrincipal.keys.releaseKeys();
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
					id : 'principalId',
					width : '130px',
					title: 'Principal ID',
					align: 'right',
					titleAlign: 'right',
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{
					id : 'principalCd principalName',
					title : 'Principal',
					width : '530px',
					children: [
									{
										id : 'principalCd',
										width : 80,
										title: 'Principal Cd',
										align: 'right',
										titleAlign: 'right',
										filterOption: true,
										filterOptionType: 'integerNoNegative'
									},{
										id : 'principalName',
										width : 420,
										title: 'Principal Name',
										filterOption: true
									}
					           ]
				},
				{
					id : 'sublineCd',
					title : 'Subline',
					filterOption : true,
					width : '70px'				
				},
				{
					id : 'sublineName',
					width : '0',
					visible: false
				},
				{
					id : 'principalType principalTypeMean',
					title : 'Principal Type',
					filterOption : true,
					width : '150px',
					children: [
								{
									id : 'principalType',
									width : 40,
									title: 'Principal Type',
									filterOption: true
								},{
									id : 'principalTypeMean',
									width : 90,
									title: 'Principal Type Meaning',
									filterOption: true
								}
				           ]
				},
				{
					id : 'address1',
					width : '0',
					visible: false				
				},
				{
					id : 'address2',
					width : '0',
					visible: false				
				},
				{
					id : 'address3',
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
			rows : objGIISS068.engPrincipalList.rows || []
		};

		tbgEngPrincipal = new MyTableGrid(engPrincipalTable);
		tbgEngPrincipal.pager = objGIISS068.engPrincipalList;
		tbgEngPrincipal.render("engPrincipalTable");
	
	function setFieldValues(rec){
		try{
			$("txtPrincipalID").value = (rec == null ? "" : rec.principalId);
			$("txtPrincipalCd").value = (rec == null ? "" : rec.principalCd);
			$("txtPrincipalName").value = (rec == null ? "" : unescapeHTML2(rec.principalName));	
			$("txtSublineCd").value = (rec == null ? "" : unescapeHTML2(rec.sublineCd));
			$("txtSublineCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.sublineCd)));
			$("txtSublineName").value = (rec == null ? "" : unescapeHTML2(rec.sublineName));
			$("txtPrincipalType").value = (rec == null ? "" : unescapeHTML2(rec.principalType));
			$("txtPrincipalType").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.principalType)));
			$("txtPrincipalTypeMean").value = (rec == null ? "" : unescapeHTML2(rec.principalTypeMean));
			$("txtAddress1").value = (rec == null ? "" : unescapeHTML2(rec.address1));
			$("txtAddress2").value = (rec == null ? "" : unescapeHTML2(rec.address2));
			$("txtAddress3").value = (rec == null ? "" : unescapeHTML2(rec.address3));
			
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtPrincipalCd").readOnly = false : $("txtPrincipalCd").readOnly = true;
			rec == null ? $("txtSublineCd").readOnly = false : $("txtSublineCd").readOnly = true;
			rec == null ? $("txtPrincipalType").readOnly = false : $("txtPrincipalType").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			
			rec == null ? enableSearch("osPrincipalType") : disableSearch("osPrincipalType");
			rec == null ? enableSearch("osSublineCd") : disableSearch("osSublineCd");
			objCurrEngPrincipal = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.principalId = $F("txtPrincipalID");
			obj.principalCd = $F("txtPrincipalCd");
			obj.principalName = escapeHTML2($F("txtPrincipalName"));
			obj.principalType = escapeHTML2($F("txtPrincipalType"));
			obj.principalTypeMean = escapeHTML2($F("txtPrincipalTypeMean"));
			obj.sublineCd = escapeHTML2($F("txtSublineCd"));
			obj.sublineName = escapeHTML2($F("txtSublineName"));
			obj.address1 = escapeHTML2($F("txtAddress1"));
			obj.address2 = escapeHTML2($F("txtAddress2"));
			obj.address3 = escapeHTML2($F("txtAddress3"));
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
			changeTagFunc = saveGiiss068;
			var engPrincipal = setRec(objCurrEngPrincipal);
			if($F("btnAdd") == "Add"){
				tbgEngPrincipal.addBottomRow(engPrincipal);
			} else {
				tbgEngPrincipal.updateVisibleRowOnly(engPrincipal, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgEngPrincipal.keys.removeFocus(tbgEngPrincipal.keys._nCurrentFocus, true);
			tbgEngPrincipal.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("engPrincipalFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;
					
					for(var i=0; i<tbgEngPrincipal.geniisysRows.length; i++){
						if(tbgEngPrincipal.geniisysRows[i].recordStatus == 0 || tbgEngPrincipal.geniisysRows[i].recordStatus == 1){								
							if(tbgEngPrincipal.geniisysRows[i].principalCd == parseInt($F("txtPrincipalCd"))){
								addedSameExists = true;
							}
						} else if(tbgEngPrincipal.geniisysRows[i].recordStatus == -1){
							if(tbgEngPrincipal.geniisysRows[i].principalCd == parseInt($F("txtPrincipalCd"))){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same principal_cd.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					
					new Ajax.Request(contextPath + "/GIISEngPrincipalController", {
						parameters : {action : "valAddRec",
									  principalCd : $F("txtPrincipalCd")},
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
		changeTagFunc = saveGiiss068;
		objCurrEngPrincipal.recordStatus = -1;
		tbgEngPrincipal.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISEngPrincipalController", {
				parameters : {action : "valDeleteRec",
							  principalCd : $F("txtPrincipalCd")},
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
	
	function cancelGiiss068(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS068.exitPage = exitPage;
						saveGiiss068();
					}, function(){
						goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
	}
	
	function showGiiss068SublineLOV(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getGiiss068SublineLOV",
							filterText : ($("txtSublineCd").readAttribute("lastValidValue").trim() != $F("txtSublineCd").trim() ? $F("txtSublineCd").trim() : "%"),
							page : 1},
			title: "List of Sublines",
			width: 500,
			height: 400,
			columnModel : [
							{
								id : "sublineCd",
								title: "Subline Code",
								width: '100px',
								filterOption: true
							},
							{
								id : "sublineName",
								title: "Subline Name",
								width: '370px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("txtSublineCd").readAttribute("lastValidValue").trim() != $F("txtSublineCd").trim() ? $F("txtSublineCd").trim() : "%"),
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
	
	function showGiiss068PrincipalType(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getCgRefCodeLOV5",
							domain: "GIIS_ENG_PRINCIPAL.PRINCIPAL_TYPE",
							searchString : ($("txtPrincipalType").readAttribute("lastValidValue").trim() != $F("txtPrincipalType").trim() ? $F("txtPrincipalType").trim() : ""),
							filterText : ($("txtPrincipalType").readAttribute("lastValidValue").trim() != $F("txtPrincipalType").trim() ? $F("txtPrincipalType").trim() : ""),
							page : 1},
			title: "List of Principal Types",
			width: 500,
			height: 400,
			columnModel : [
							{
								id : "rvLowValue",
								title: "Value",
								width: '100px',
								filterOption: true
							},
							{
								id : "rvMeaning",
								title: "Meaning",
								width: '370px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				searchString : ($("txtPrincipalType").readAttribute("lastValidValue").trim() != $F("txtPrincipalType").trim() ? $F("txtPrincipalType").trim() : ""),
				filterText : ($("txtPrincipalType").readAttribute("lastValidValue").trim() != $F("txtPrincipalType").trim() ? $F("txtPrincipalType").trim() : ""),
				onSelect: function(row) {
					$("txtPrincipalType").value = unescapeHTML2(row.rvLowValue);
					$("txtPrincipalType").setAttribute("lastValidValue", unescapeHTML2(row.rvLowValue));
					$("txtPrincipalTypeMean").value = unescapeHTML2(row.rvMeaning).toUpperCase();
				},
				onCancel: function (){
					$("txtPrincipalType").value = $("txtPrincipalType").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtPrincipalType").value = $("txtPrincipalType").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("txtPrincipalName").observe("keyup", function(){
		$("txtPrincipalName").value = $F("txtPrincipalName").toUpperCase();
	});
	
	$("txtPrincipalType").observe("keyup", function(){
		$("txtPrincipalType").value = $F("txtPrincipalType").toUpperCase();
	});
	$("osPrincipalType").observe("click", showGiiss068PrincipalType);
	
	$("txtPrincipalType").observe("change", function() {		
		if($F("txtPrincipalType").trim() == "") {
			$("txtPrincipalType").value = "";
			$("txtPrincipalType").setAttribute("lastValidValue", "");
			$("txtPrincipalTypeMean").value = "";
		} else {
			if($F("txtPrincipalType").trim() != "" && $F("txtPrincipalType") != $("txtPrincipalType").readAttribute("lastValidValue")) {
				showGiiss068PrincipalType();
			}
		}
	});	
	
	$("txtPrincipalCd").observe("keyup", function(){
		$("txtPrincipalCd").value = $F("txtPrincipalCd").toUpperCase();
	});
	
	$("txtSublineCd").observe("keyup", function(){
		$("txtSublineCd").value = $F("txtSublineCd").toUpperCase();
	});
	
	$("osSublineCd").observe("click", showGiiss068SublineLOV);
	
	$("txtSublineCd").observe("change", function() {		
		if($F("txtSublineCd").trim() == "") {
			$("txtSublineCd").value = "";
			$("txtSublineCd").setAttribute("lastValidValue", "");
			$("txtSublineName").value = "";
		} else {
			if($F("txtSublineCd").trim() != "" && $F("txtSublineCd") != $("txtSublineCd").readAttribute("lastValidValue")) {
				showGiiss068SublineLOV();
			}
		}
	});
	
	$("txtAddress1").observe("keyup", function(){
		$("txtAddress1").value = $F("txtAddress1").toUpperCase();
	});
	$("txtAddress2").observe("keyup", function(){
		$("txtAddress2").value = $F("txtAddress2").toUpperCase();
	});
	$("txtAddress3").observe("keyup", function(){
		$("txtAddress3").value = $F("txtAddress3").toUpperCase();
	});
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGiiss068);
	$("btnCancel").observe("click", cancelGiiss068);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("engPrincipalMaintenance").stopObserving("click");
	$("engPrincipalMaintenance").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtPrincipalCd").focus();	
</script>