<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss053MainDiv" name="giiss053MainDiv" style="">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="orPrefixMaintenance">Exit</a></li>
			</ul>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>OR Prefix Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giacs355" name="giacs355">		
		<div class="sectionDiv">
			<div id="orPrefixTableDiv" style="padding-top: 10px;">
				<div id="orPrefixTable" style="height: 340px;  margin-left: 145px;"></div>
			</div>
			<div align="center" id="orPrefixFormDiv">
				<table style="margin-top: 10px;">
					<tr>
						<td class="rightAligned">Branch Code</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan" style="float: left; width: 100px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input type="text" id="txtBranchCd" name="txtBranchCd" class="required" lastValidValue="" style="width: 75px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="101" />
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osBranchCd" name="osBranchCd" class="required" alt="Go" style="float: right;" />
							</span>
							<input id="txtBranchName" type="text" readonly="readonly" style="width: 422px;" tabindex="102" />
							<input type="hidden" id="txtFundCd" />
						</td>		
					</tr>	
					<tr>
						<td width="" class="rightAligned">OR Prefix</td>
						<td class="leftAligned"><input id="txtOrPrefSuf" type="text" class="required" style="width: 200px;" tabindex="103" maxlength="5"></td>
						<td class="rightAligned">OR Type</td>
						<td class="leftAligned">
							<span class="lovSpan required" style="float: left; width: 50px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input type="text" id="txtOrType" name="txtOrType" class="required" lastValidValue="" style="width: 25px; float: left; border: none; height: 15px; margin: 0;" maxlength="1" tabindex="104" />
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osOrType" name="osOrType" alt="Go" style="float: right;" />
							</span>
							<input id="txtOrTypeMean" type="text" readonly="readonly" style="width: 143px;" tabindex="105" />
						</td>			
					</tr>	
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 536px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 504px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="106"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="107"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="108" /></td>
						<td width="110px" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="109" /></td>
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
<div class="buttonsDiv" style="margin:10px 0 40px 10px;">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="203">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="204">
</div>
<script type="text/javascript">	
	setModuleId("GIACS355");
	setDocumentTitle("OR Prefix Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiacs355(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgOrPrefix.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgOrPrefix.geniisysRows);
		new Ajax.Request(contextPath+"/GIACOrPrefController", {
			method: "POST",
			parameters : {action : "saveGiacs355",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIACS355.exitPage != null) {
							objGIACS355.exitPage();
						} else {
							tbgOrPrefix._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiacs355);
	
	var objGIACS355 = {};
	var objCurrOrPrefix = null;
	objGIACS355.orPrefixList = JSON.parse('${jsonOrPrefList}') || [];
	objGIACS355.exitPage = null;
	
	var orPrefixTable = {
			url : contextPath + "/GIACOrPrefController?action=showGiacs355&refresh=1",
			options : {
				width : '630px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrOrPrefix = tbgOrPrefix.geniisysRows[y];
					setFieldValues(objCurrOrPrefix);
					tbgOrPrefix.keys.removeFocus(tbgOrPrefix.keys._nCurrentFocus, true);
					tbgOrPrefix.keys.releaseKeys();
					$("txtBranchCd").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgOrPrefix.keys.removeFocus(tbgOrPrefix.keys._nCurrentFocus, true);
					tbgOrPrefix.keys.releaseKeys();
					$("txtBranchCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgOrPrefix.keys.removeFocus(tbgOrPrefix.keys._nCurrentFocus, true);
						tbgOrPrefix.keys.releaseKeys();
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
					tbgOrPrefix.keys.removeFocus(tbgOrPrefix.keys._nCurrentFocus, true);
					tbgOrPrefix.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgOrPrefix.keys.removeFocus(tbgOrPrefix.keys._nCurrentFocus, true);
					tbgOrPrefix.keys.releaseKeys();
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
					tbgOrPrefix.keys.removeFocus(tbgOrPrefix.keys._nCurrentFocus, true);
					tbgOrPrefix.keys.releaseKeys();
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
					id : 'fundCd',
					width : '0',
					visible: false				
				},
				{
					id : "branchCd",
					title : "Branch Code",
					filterOption : true,
					width : '100px'
				},
				{
					id : 'orPrefSuf',
					title : 'OR Prefix',
					filterOption : true,
					width : '130px'				
				},
				{
					id : "orType orTypeMean",
					title : "OR Type",
					filterOption : true,
					width : '400px',
					children : [
						{
							id : 'orType',
							title: 'OR Type',
							width : 50,
							filterOption: true				
						},
						{
							id : 'orTypeMean',
							title: 'OR Type Mean',
							width : 300
						}    
					]
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
					id : 'branchName',
					width : '0',
					visible: false				
				}
			],
			rows : objGIACS355.orPrefixList.rows || []
		};

		tbgOrPrefix = new MyTableGrid(orPrefixTable);
		tbgOrPrefix.pager = objGIACS355.orPrefixList;
		tbgOrPrefix.render("orPrefixTable");
	
	function setFieldValues(rec){
		try{
			$("txtFundCd").value = (rec == null ? "" : unescapeHTML2(rec.fundCd));
			$("txtBranchCd").value = (rec == null ? "" : unescapeHTML2(rec.branchCd));
			$("txtBranchCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.branchCd)));
			$("txtBranchName").value = (rec == null ? "" : unescapeHTML2(rec.branchName));
			$("txtOrPrefSuf").value = (rec == null ? "" : unescapeHTML2(rec.orPrefSuf));
			$("txtOrType").value = (rec == null ? "" : unescapeHTML2(rec.orType));
			$("txtOrType").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.orType)));
			$("txtOrTypeMean").value = (rec == null ? "" : unescapeHTML2(rec.orTypeMean));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtBranchCd").readOnly = false : $("txtBranchCd").readOnly = true;
			rec == null ? $("txtOrPrefSuf").readOnly = false : $("txtOrPrefSuf").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			
			rec == null ? enableSearch("osBranchCd") : disableSearch("osBranchCd");
			objCurrOrPrefix = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.fundCd = escapeHTML2($F("txtFundCd"));
			obj.branchCd = escapeHTML2($F("txtBranchCd"));
			obj.branchName = escapeHTML2($F("txtBranchName"));
			obj.orPrefSuf = escapeHTML2($F("txtOrPrefSuf"));
			obj.orType = escapeHTML2($F("txtOrType"));
			obj.orTypeMean = escapeHTML2($F("txtOrTypeMean"));
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
			changeTagFunc = saveGiacs355;
			var orPref = setRec(objCurrOrPrefix);
			if($F("btnAdd") == "Add"){
				tbgOrPrefix.addBottomRow(orPref);
			} else {
				tbgOrPrefix.updateVisibleRowOnly(orPref, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgOrPrefix.keys.removeFocus(tbgOrPrefix.keys._nCurrentFocus, true);
			tbgOrPrefix.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("orPrefixFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;
					
					for(var i=0; i<tbgOrPrefix.geniisysRows.length; i++){
						if(tbgOrPrefix.geniisysRows[i].recordStatus == 0 || tbgOrPrefix.geniisysRows[i].recordStatus == 1){								
							if(tbgOrPrefix.geniisysRows[i].branchCd == $F("txtBranchCd") && tbgOrPrefix.geniisysRows[i].orPrefSuf == $F("txtOrPrefSuf")){
								addedSameExists = true;
							}
						} else if(tbgOrPrefix.geniisysRows[i].recordStatus == -1){
							if(tbgOrPrefix.geniisysRows[i].branchCd == $F("txtBranchCd") && tbgOrPrefix.geniisysRows[i].orPrefSuf == $F("txtOrPrefSuf")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same fund_cd, branch_cd, and or_pref_suf.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					
					new Ajax.Request(contextPath + "/GIACOrPrefController", {
						parameters : {action : "valAddRec",
									  fundCd : $F("txtFundCd"),
									  branchCd : $F("txtBranchCd"),
									  orPrefSuf: $F("txtOrPrefSuf")},
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
		changeTagFunc = saveGiacs355;
		objCurrOrPrefix.recordStatus = -1;
		tbgOrPrefix.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIACOrPrefController", {
				parameters : {action : "valDeleteRec",
							  fundCd : $F("txtFundCd"),
							  branchCd : $F("txtBranchCd"),
							  orPrefSuf : $F("txtOrPrefSuf")},
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
	
	function cancelGiacs355(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIACS355.exitPage = exitPage;
						saveGiacs355();
					}, function(){
						goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		}
	}
	
	function showGiacs355OrTypeLOV(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getCgRefCodeLOV4",
							domain: "GIAC_OR_PREF.OR_TYPE",
							filterText : ($("txtOrType").readAttribute("lastValidValue").trim() != $F("txtOrType").trim() ? $F("txtOrType").trim() : ""),
							page : 1},
			title: "OR Types",
			width: 500,
			height: 400,
			columnModel : [
							{
								id : "rvLowValue",
								title: "OR Type",
								width: '100px',
								filterOption: true
							},
							{
								id : "rvMeaning",
								title: "OR Type Meaning",
								width: '370px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("txtOrType").readAttribute("lastValidValue").trim() != $F("txtOrType").trim() ? $F("txtOrType").trim() : ""),
				onSelect: function(row) {
					$("txtOrType").value = unescapeHTML2(row.rvLowValue);
					$("txtOrType").setAttribute("lastValidValue", row.rvLowValue);
					$("txtOrTypeMean").value = unescapeHTML2(row.rvMeaning);
				},
				onCancel: function (){
					$("txtOrType").value = $("txtOrType").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtOrType").value = $("txtOrType").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	function showGiacs355BranchLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : "getGIACS118BranchLOV",
							moduleId: "GIACS355",
							searchString : ($("txtBranchCd").readAttribute("lastValidValue").trim() != $F("txtBranchCd").trim() ? $F("txtBranchCd").trim() : ""),
							page : 1},
			title: "List of Branch Code",
			width: 500,
			height: 400,
			columnModel : [
							{
								id : "branchCd",
								title: "Branch Code",
								width: '100px',
								filterOption: true
							},
							{
								id : "branchName",
								title: "Branch Name",
								width: '370px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				searchString : ($("txtBranchCd").readAttribute("lastValidValue").trim() != $F("txtBranchCd").trim() ? $F("txtBranchCd").trim() : ""),
				onSelect: function(row) {
					$("txtBranchCd").value = row.branchCd;
					$("txtBranchCd").setAttribute("lastValidValue", row.branchCd);
					$("txtBranchName").value = row.branchName;
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
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("txtBranchCd").observe("keyup", function(){
		$("txtBranchCd").value = $F("txtBranchCd").toUpperCase();
	});
	$("osBranchCd").observe("click", showGiacs355BranchLOV);
	
	$("txtBranchCd").observe("change", function() {		
		if($F("txtBranchCd").trim() == "") {
			$("txtBranchCd").value = "";
			$("txtBranchCd").setAttribute("lastValidValue", "");
			$("txtBranchName").value = "";
		} else {
			if($F("txtBranchCd").trim() != "" && $F("txtBranchCd") != $("txtBranchCd").readAttribute("lastValidValue")) {
				showGiacs355BranchLOV();
			}
		}
	});	
	
	$("txtOrPrefSuf").observe("keyup", function(){
		$("txtOrPrefSuf").value = $F("txtOrPrefSuf").toUpperCase();
	});
	
	$("txtOrType").observe("keyup", function(){
		$("txtOrType").value = $F("txtOrType").toUpperCase();
	});
	
	$("osOrType").observe("click", showGiacs355OrTypeLOV);
	
	$("txtOrType").observe("change", function() {		
		if($F("txtOrType").trim() == "") {
			$("txtOrType").value = "";
			$("txtOrType").setAttribute("lastValidValue", "");
			$("txtOrTypeMean").value = "";
		} else {
			if($F("txtOrType").trim() != "" && $F("txtOrType") != $("txtOrType").readAttribute("lastValidValue")) {
				showGiacs355OrTypeLOV();
			}
		}
	});	 	
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGiacs355);
	$("btnCancel").observe("click", cancelGiacs355);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("orPrefixMaintenance").stopObserving("click");
	$("orPrefixMaintenance").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtBranchCd").focus();	
</script>