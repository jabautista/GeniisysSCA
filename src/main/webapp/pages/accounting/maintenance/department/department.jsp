<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<script type="text/javascript">
	$("smoothmenu1").hide();
</script>
<jsp:include page="/pages/toolbar.jsp"></jsp:include>
<div id="giacs305MainDiv" name="giacs305MainDiv" style="">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Department Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giacs305" name="giacs305">
		<div class="sectionDiv" id="giacs305">
			<div style="" align="center" id="companyBranchDiv">
				<table cellspacing="2" border="0" style="margin: 10px auto;">	 			
					<tr>
						<td class="rightAligned" style="" id="">Company</td>
						<td class="leftAligned" colspan="3">
							<!-- <input id="txtFundCd" name="txtFundCd" type="text" style="width: 60px;" readonly="readonly" tabindex="101" value="PFM"/> -->
							<span class="lovSpan required" style="float: left; width: 65px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required" ignoreDelKey="" type="text" id="txtFundCd" name="txtFundCd" style="width: 40px; float: left; border: none; height: 15px; margin: 0;" maxlength="4" tabindex="101" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchFundCd" name="imgSearchFundCd" alt="Go" style="float: right;" tabindex="102"/>
							</span>
							<input id="txtFundDesc" name="txtFundDesc" type="text" style="width: 280px;" value="" readonly="readonly" tabindex="103"/>
						</td>
						<td class="rightAligned" style="width: 65px;" id="">Branch</td>
						<td class="leftAligned" colspan="3">
							<!-- <input id="txtBranchCd" name="txtBranchCd" type="text" style="width: 60px;" readonly="readonly" tabindex="103" value="HO"/> -->
							<span class="lovSpan required" style="float: left; width: 65px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required" ignoreDelKey="" type="text" id="txtBranchCd" name="txtBranchCd" style="width: 40px; float: left; border: none; height: 15px; margin: 0;" maxlength="4" tabindex="104" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchBranchCd" name="imgSearchBranchCd" alt="Go" style="float: right;" tabindex="105"/>
							</span>
							<input id="txtBranchName" name="txtBranchName" type="text" style="width: 280px;" value="" readonly="readonly" tabindex="106"/>
						</td>
					</tr>
				</table>			
			</div>		
		</div>
		<div class="sectionDiv">
			<div id="departmentTableDiv" style="padding-top: 10px;">
				<div id="departmentTable" style="height: 335px; margin-left: 115px;"></div>
			</div>
			<div align="center" id="departmentFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Dept Code</td>
						<td class="leftAligned">
							<input id="hidOucId" type="hidden" class="" style="width: 200px;">
							<input id="dummyOucId" type="hidden">
							<input id="txtOucCd" type="text" class="required" style="width: 200px; text-align: right;" tabindex="201" maxlength="2">
						</td>
						<td width="150" class="rightAligned"><input id="chkClaimTag" type="checkbox" class="" style="margin-left: 70px; float:left;" tabindex="202"><label style="margin-left: 5px; float: left;" for="chkClaimTag">Claim Tag</label></td>
						<td class="leftAligned"></td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Department Name</td>
						<td class="leftAligned" colspan="3">
							<input id="txtOucName" type="text" class="required" style="width: 570px;" tabindex="202" maxlength="100">
						</td>
					</tr>				
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 576px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 550px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="219"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="220"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="221"></td>
						<td width="" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="222"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="223">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="224">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="225">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="226">
</div>
<script type="text/javascript">	
	hideToolbarButton("btnToolbarPrint");
	showToolbarButton("btnToolbarSave");
	disableToolbarButton("btnToolbarExecuteQuery");
	disableToolbarButton("btnToolbarEnterQuery");
	setForm(false);
	setModuleId("GIACS305");
	setDocumentTitle("Department Maintenance");
	initializeAll();
	changeTag = 0;
	var rowIndex = -1;
	var allRec = null;
	
	function saveGiacs305(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var depts = getAddedAndModifiedJSONObjects(tbgDepartments.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgDepartments.geniisysRows);
		new Ajax.Request(contextPath+"/GIACOucsController", {
			method: "POST",
			parameters : {action : "saveGiacs305",
					 	  setRows : prepareJsonAsParameter(depts),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIACS305.exitPage != null) {
							objGIACS305.exitPage();
						} else {
							tbgDepartments._refreshList();
							allRec = getAllRecord();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiacs305);
	
	var objGIACS305 = {};
	var objCurrDept = null;
	objGIACS305.exitPage = null;
	
	var departmentTable = {
			url : contextPath + "/GIACOucsController?action=showGiacs305&refresh=1&fundCd=&branchCd=",
			options : {
				columnResizable : false,
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrDept = tbgDepartments.geniisysRows[y];
					setFieldValues(objCurrDept);
					tbgDepartments.keys.removeFocus(tbgDepartments.keys._nCurrentFocus, true);
					tbgDepartments.keys.releaseKeys();
					$("txtOucCd").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgDepartments.keys.removeFocus(tbgDepartments.keys._nCurrentFocus, true);
					tbgDepartments.keys.releaseKeys();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgDepartments.keys.removeFocus(tbgDepartments.keys._nCurrentFocus, true);
						tbgDepartments.keys.releaseKeys();
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
					tbgDepartments.keys.removeFocus(tbgDepartments.keys._nCurrentFocus, true);
					tbgDepartments.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgDepartments.keys.removeFocus(tbgDepartments.keys._nCurrentFocus, true);
					tbgDepartments.keys.releaseKeys();
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
					tbgDepartments.keys.removeFocus(tbgDepartments.keys._nCurrentFocus, true);
					tbgDepartments.keys.releaseKeys();
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
				{ 	id:			'claimTag',
					align:		'center',
					title:		'&#160;&#160;C',
					altTitle:   'Claim Tag',
					titleAlign:	'center',
					width:		'25px',
			   		editable: false,
			   		filterOption: true,
			   		filterOptionType : 'checkbox',
// 				    hideSelectAllBox: true,
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
					id : "oucCd",
					title : "Dept Code",
					filterOption : true,
					filterOptionType : 'integerNoNegative',
					width : '100px',
					align : 'right',
					titleAlign : 'right',
					renderer : function(value){
						return formatNumberDigits(value, 2);
					}
				},
				{
					id : 'oucName',
					filterOption : true,
					title : 'Department Name',
					width : '530px'				
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
					id : 'gibrGfunFundCd',
					width : '0',
					visible: false				
				},
				{
					id : 'gibrBranchCd',
					width : '0',
					visible: false				
				},
				{
					id : 'oucId',
					width : '0',
					visible: false				
				}
			],
			rows : []//objGIACS303.department.rows
		};

		tbgDepartments = new MyTableGrid(departmentTable);
		//tbgDepartments.pager = objGIACS305.department;
		tbgDepartments.render("departmentTable");
		
	function executeQuery(){
		if(checkAllRequiredFieldsInDiv("companyBranchDiv")) {			
			tbgDepartments.url = contextPath + "/GIACOucsController?action=showGiacs305&refresh=1&fundCd="+encodeURIComponent($F("txtFundCd"))+"&branchCd="+encodeURIComponent($F("txtBranchCd"));
			tbgDepartments._refreshList();
			setForm(true);
			disableToolbarButton("btnToolbarExecuteQuery");
			$("txtFundCd").readOnly = true;
			$("txtBranchCd").readOnly = true;
			disableSearch("imgSearchFundCd");
			disableSearch("imgSearchBranchCd");
			allRec = getAllRecord();
		}
	}
	
	function enterQuery(){
		function proceedEnterQuery(){
			if($F("txtFundCd").trim() != "" || $F("txtBranchCd").trim() != "") {
				disableToolbarButton("btnToolbarExecuteQuery");
				$("txtFundCd").value = "";
				$("txtFundCd").setAttribute("lastValidValue", "");
				$("txtBranchCd").value = "";
				$("txtBranchCd").setAttribute("lastValidValue", "");
				$("txtFundDesc").value = "";
				$("txtBranchName").value = "";
				$("txtFundCd").readOnly = false;
				$("txtBranchCd").readOnly = false;
				enableSearch("imgSearchFundCd");
				enableSearch("imgSearchBranchCd");
				tbgDepartments.url = contextPath + "/GIACOucsController?action=showGiacs305&refresh=1&fundCd="+$F("txtFundCd")+"&branchCd="+$F("txtBranchCd");
				tbgDepartments._refreshList();
				setFieldValues(null);
				$("txtFundCd").focus();
				disableToolbarButton("btnToolbarEnterQuery");
				setForm(false);
				allRec = null;
			}
		}
		
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
				        objGIACS305.exitPage = proceedEnterQuery;
						saveGiacs305();
					}, function(){
						proceedEnterQuery();
						changeTag = 0; //sets change tag if no changes are being saved
					}, "");
		} else {
			proceedEnterQuery();
		}		
	}
	
	function setForm(enable){
		if(enable){
			$("txtOucCd").readOnly = false;
			$("txtOucName").readOnly = false;
			$("txtRemarks").readOnly = false;
			$("chkClaimTag").disabled = false;
			enableButton("btnAdd");
		} else {
			$("txtOucCd").readOnly = true;
			$("txtOucName").readOnly = true;
			$("txtRemarks").readOnly = true;
			$("chkClaimTag").disabled = true;
			disableButton("btnAdd");
			disableButton("btnDelete");
		}
	}
	
	function setFieldValues(rec){
		
		try{
			$("hidOucId").value = (rec == null ? "" : rec.oucId);
			$("txtOucCd").value = (rec == null ? "" : formatNumberDigits(rec.oucCd, 2));
			$("txtOucCd").setAttribute("lastValidValue", (rec == null ? "" : rec.oucCd));
			$("txtOucCd").setAttribute("originalValue", (rec == null ? "" : rec.oucCd)); //added to track previous value
			$("txtOucName").value = (rec == null ? "" : unescapeHTML2(rec.oucName));
			$("txtOucName").setAttribute("originalValue", (rec == null ? "" : unescapeHTML2(rec.oucName))); //added to track previous value
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : unescapeHTML2(rec.lastUpdate));
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("dummyOucId").value = (rec == null ? "" : rec.dummyOucId);
			
			rec != null && rec.claimTag == "Y" ? $("chkClaimTag").checked = true : $("chkClaimTag").checked = false;			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrDept = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setDept(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.oucId = (rec == null ? null : $F("hidOucId"));
			obj.gibrGfunFundCd = escapeHTML2($F("txtFundCd"));
			obj.gibrBranchCd = escapeHTML2($F("txtBranchCd"));
			obj.oucCd = $F("txtOucCd");
			obj.oucName = escapeHTML2($F("txtOucName")); //added to continue saving special characters
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.claimTag = ($("chkClaimTag").checked ? 'Y' : 'N');
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			if($F("dummyOucId").trim() == ""){
				obj.dummyOucId = generateDummyId();
			}else{
				obj.dummyOucId = $F("hidOucId");
			}
			
			return obj;
		} catch(e){
			showErrorMessage("setDept", e);
		}
	}
	
	function generateDummyId() {
		try {
			var maxId = 0;
			for ( var i = 0; i < allRec.length; i++) {
				if (parseInt(allRec[i].oucId) > maxId) {
					maxId = allRec[i].oucId;
				}
			}
			return maxId + 1;
		} catch (e) {
			showErrorMessage("generateDummyId",e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGiacs305;
			var dept = setDept(objCurrDept);
			var newObj = setDept(null);
			if($F("btnAdd") == "Add"){
				tbgDepartments.addBottomRow(dept);
				newObj.recordStatus = 0;
				allRec.push(newObj);
			} else {
				tbgDepartments.updateVisibleRowOnly(dept, rowIndex, false); 
				for(var i = 0; i<allRec.length; i++){
					if ((allRec[i].dummyOucId == newObj.dummyOucId)&&(allRec[i].recordStatus != -1)){
						newObj.recordStatus = 1;
						allRec.splice(i, 1, newObj);
					}
				}
			}
			changeTag = 1;
			setFieldValues(null);
			tbgDepartments.keys.removeFocus(tbgDepartments.keys._nCurrentFocus, true);
			tbgDepartments.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddUpdateRec() {
		try {
			var origOucCd = $("txtOucCd").getAttribute("originalValue");
			var origOucName = $("txtOucName").getAttribute("originalValue");
			if(checkAllRequiredFieldsInDiv("departmentFormDiv")){
				for(var i=0; i<allRec.length; i++){
					if(allRec[i].recordStatus != -1 ){
						if ($F("btnAdd") == "Add") {
							if(allRec[i].oucCd == $F("txtOucCd")){
								customShowMessageBox("Record already exists with the same ouc_cd.", imgMessage.ERROR, "txtOucCd");
								return;
							}else if(unescapeHTML2(allRec[i].oucName).replace(/\\\\/g, "\\") == $F("txtOucName")){
								customShowMessageBox("Record already exists with the same ouc_name.", imgMessage.ERROR, "txtOucName");
								return;
							}
						} else{
							if(origOucCd != parseInt($F("txtOucCd")) && allRec[i].oucCd == $F("txtOucCd")){
								customShowMessageBox("Record already exists with the same ouc_cd.", imgMessage.ERROR, "txtOucCd");
								return;
							}else if(origOucName != $F("txtOucName") && unescapeHTML2(allRec[i].oucName).replace(/\\\\/g, "\\") == $F("txtOucName")){
								customShowMessageBox("Record already exists with the same ouc_name.", imgMessage.ERROR, "txtOucName");
								return;
							}
						}
					} 
				}
				addRec();
			}
		} catch (e) {
			showErrorMessage("valAddUpdateRec",e);
		}
	}
	
	function deleteOuc(){
		changeTagFunc = saveGiacs305;
		objCurrDept.recordStatus = -1;
		tbgDepartments.deleteRow(rowIndex);
		var newObj = setDept(null);
		for(var i = 0; i<allRec.length; i++){
			if ((allRec[i].dummyOucId == newObj.dummyOucId)&&(allRec[i].recordStatus != -1)){
				newObj.recordStatus = -1;
				allRec.splice(i, 1, newObj);
			}
		}
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteOuc(){
		try{
			if ($F("hidOucId") == "") {
				deleteOuc(); //added for deletion of added items in tablegrid
			} else {
				new Ajax.Request(contextPath + "/GIACOucsController", {
					parameters : {action : "valDeleteOuc",
								  oucId : $F("hidOucId")},
					onCreate : showNotice("Processing, please wait..."),
					onComplete : function(response){
						hideNotice();
						if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
							deleteOuc();
						}
					}
				});
			}
		} catch(e){
			showErrorMessage("valDeleteOuc", e);
		}
	}
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	}	
	
	function cancelGiacs305(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIACS305.exitPage = exitPage;
						saveGiacs305();						
					}, function(){
						goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		}
	}
	
	function showGIACS305FundLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : "getFundLOV",
							filterText : ($("txtFundCd").readAttribute("lastValidValue").trim() != $F("txtFundCd").trim() ? $F("txtFundCd").trim() : ""),
							page : 1},
			title: "List of Funds",
			width: 500,
			height: 400,
			columnModel : [ {
								id: "fundCd",
								title: "Code",
								width : '100px',
							}, {
								id : "fundDesc",
								title : "Description",
								width : '385px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							} ],
				autoSelectOneRecord: true,
				filterText : ($("txtFundCd").readAttribute("lastValidValue").trim() != $F("txtFundCd").trim() ? $F("txtFundCd").trim() : ""),
				onSelect: function(row) {
					enableToolbarButton("btnToolbarEnterQuery");
					if($F("txtBranchCd").trim() != ""){						
						enableToolbarButton("btnToolbarExecuteQuery");
					}
					$("txtFundCd").value = unescapeHTML2(row.fundCd);
					$("txtFundDesc").value = unescapeHTML2(row.fundDesc);
					$("txtFundCd").setAttribute("lastValidValue", unescapeHTML2(row.fundCd));
					
					//added to clear branch field upon selection of new company
					$("txtBranchCd").value = "";
					$("txtBranchCd").setAttribute("lastValidValue", "");
					$("txtBranchName").value = "";
				},
				onCancel: function (){
					$("txtFundCd").value = $("txtFundCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtFundCd").value = $("txtFundCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	function showGIACS305BranchLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : "getGIACBranchLOV",
							gfunFundCd : $F("txtFundCd"),
							moduleId :  "GIACS305",
							filterText : ($("txtBranchCd").readAttribute("lastValidValue").trim() != $F("txtBranchCd").trim() ? $F("txtBranchCd").trim() : ""),
							page : 1},
			title: "List of Branches",
			width: 500,
			height: 400,
			columnModel : [
							{
								id : "branchCd",
								title: "Code",
								width: '100px',
								filterOption: true
							},
							{
								id : "branchName",
								title: "Branch",
								width: '385px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("txtBranchCd").readAttribute("lastValidValue").trim() != $F("txtBranchCd").trim() ? $F("txtBranchCd").trim() : ""),
				onSelect: function(row) {
					if($F("txtFundCd").trim() != ""){
						enableToolbarButton("btnToolbarExecuteQuery");
					}
					$("txtBranchCd").value = unescapeHTML2(row.branchCd);
					$("txtBranchName").value = unescapeHTML2(row.branchName);
					$("txtBranchCd").setAttribute("lastValidValue", row.branchCd);								
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
	
	$("imgSearchFundCd").observe("click", showGIACS305FundLOV);
	$("imgSearchBranchCd").observe("click", showGIACS305BranchLOV);
	
	$("txtOucCd").observe("change", function() {		
		if($F("txtOucCd").trim() == "") {
			$("txtOucCd").value = "";
			$("txtOucCd").setAttribute("lastValidValue", "");
		} else {
			if(parseInt($F("txtOucCd")) < 0 || parseInt($F("txtOucCd")) > 99){
				showWaitingMessageBox("Invalid Dept Code. Valid value should be from 0 to 99.", "E", function(){
					$("txtOucCd").value = formatNumberDigits($("txtOucCd").readAttribute("lastValidValue"), 2);
					$("txtOucCd").focus();
				});
			} else {				
				$("txtOucCd").setAttribute("lastValidValue", $F("txtOucCd"));
				$("txtOucCd").value = formatNumberDigits($F("txtOucCd"), 2);
			}		
		}
	});
	
	$("txtOucCd").observe("keyup", function(e) {
		if(isNaN($F("txtOucCd"))) {
			$("txtOucCd").value = (nvl($("txtOucCd").readAttribute("lastValidValue"), "") == "" ? "" : formatNumberDigits($("txtOucCd").readAttribute("lastValidValue"), 2));
		}
	});	
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
 	
	$("txtFundCd").observe("change", function() {
		if($F("txtFundCd").trim() == "") {
			$("txtFundCd").value = "";
			$("txtFundCd").setAttribute("lastValidValue", "");
			$("txtFundDesc").value = "";
			$("txtBranchCd").value = "";
			$("txtBranchCd").setAttribute("lastValidValue", "");
			$("txtBranchName").value = "";
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
		} else {
			if($F("txtFundCd").trim() != "" && $F("txtFundCd") != $("txtFundCd").readAttribute("lastValidValue")) {
				showGIACS305FundLOV();
			}
		}
	});
	
 	$("txtBranchCd").observe("change", function() {		
		if($F("txtBranchCd").trim() == "") {
			$("txtBranchCd").value = "";
			$("txtBranchCd").setAttribute("lastValidValue", "");
			$("txtBranchName").value = "";
		} else {
			if($F("txtBranchCd").trim() != "" && $F("txtBranchCd") != $("txtBranchCd").readAttribute("lastValidValue")) {
				showGIACS305BranchLOV();
			}
		}
	});	 	
 	
	$("txtFundCd").observe("keyup", function(){
		$("txtFundCd").value = $F("txtFundCd").toUpperCase();
	});
	
	$("txtBranchCd").observe("keyup", function(){
		$("txtBranchCd").value = $F("txtBranchCd").toUpperCase();
	});
	
	observeSaveForm("btnSave", saveGiacs305);
	observeSaveForm("btnToolbarSave", saveGiacs305);
	$("btnCancel").observe("click", cancelGiacs305);
	$("btnAdd").observe("click", valAddUpdateRec);
	$("btnDelete").observe("click", valDeleteOuc);
		
	$("btnToolbarExecuteQuery").observe("click", executeQuery);
	$("btnToolbarEnterQuery").observe("click", enterQuery);	
	$("btnToolbarExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtFundCd").focus();
	
	//additional function to check inputted values
	function checkDeptIfExist(obj, field, mtd) {
		//get the current department codes in the table grid
		var divs = document.getElementsByClassName("mtgInnerCell");
		var tblDeptCodes = [];
		
		//initialize variables
		var id_pfx = field == "Code" ? "mtgIC1_3" : "mtgIC1_4";
		var input = field == "Code" ? obj.oucCd : obj.oucName;
		var orig_value = field == "Code" ? $("txtOucCd").getAttribute("originalValue") : $("txtOucName").getAttribute("originalValue");
		
		for (var i = 0; i < divs.length; i++) {
			if (divs[i].id.indexOf(id_pfx) == 0) {
				var element_display = $(divs[i].id).parentNode.parentNode.getStyle('display');
				if (element_display != "none") {
					tblDeptCodes.push(divs[i].innerHTML);
				}
			}
		}
		
		var recordExists = false;
		
		if (field == "Code") {
			orig_value = parseInt(orig_value);
			input = parseInt(input);
		}
		
		var sec_Cond = mtd == "A" ? true : (orig_value != input);
		
		input = field == "Code" ? input : input.trim().toUpperCase();
		for (var i = 0; i < tblDeptCodes.length; i++) {			
			if (input == tblDeptCodes[i].toUpperCase() && sec_Cond) {
				recordExists = true;
				break;
			}
		}	
		
		
		return recordExists;
	}
	
	function getAllRecord() {
		try {
			var objReturn = {};
			new Ajax.Request(contextPath + "/GIACOucsController", {
				parameters : {action : "showAllGiacs305",
							  branchCd : $F("txtBranchCd"),
							  fundCd : $F("txtFundCd")},
			    asynchronous: false,
				evalScripts: true,
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						var obj = {};
						obj = JSON.parse(response.responseText);
						objReturn = obj.rows;
					}
				}
			});
			return objReturn;
		} catch (e) {
			showErrorMessage("getAllRecord",e);
		}
	}
</script>