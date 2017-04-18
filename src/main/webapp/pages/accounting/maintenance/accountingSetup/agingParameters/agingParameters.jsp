<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giacs310MainDiv" name="giacs310MainDiv" style="">
	<div id="giacs310Div">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="giacs310Exit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Aging Parameter Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>
	
	<div id="giacs310" name="giacs310">
		<div class="sectionDiv">
			<div id="agingParametersTableDiv" >
				<div id="agingParametersTable" style="height: 331px; margin: 10px;"></div>
			</div>
			<div id="agingParametersTypeFormDiv" style="margin-left: 120px; float: left; width: 830px;">
				<div style="float: left; margin-bottom: 10px;">
					<table style="margin-top: 5px;">
						<tr>
							<td class="rightAligned">Fund Code</td>
							<td colspan="3">
								<span class="lovSpan required" style="float: left; width: 100px; margin-right: 5px; margin-top: 2px; height: 21px;">
									<input class="required" type="text" id="txtGibrGfunFundCd" maxlength="3" style="width: 75px; float: left; border: none; height: 15px; margin: 0;" maxlength="10" tabindex="101" lastValidValue=""/>
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgGibrGFunFundCd" name="imgGibrGFunFundCd" alt="Go" style="float: right;" tabindex="102"/>
								</span>
								<input type="text" id="txtFundDesc" style="width: 411px; height: 15px;" tabindex="103"/>
							</td>
						</tr>	
						<tr>
							<td class="rightAligned">Branch Code</td>
							<td colspan="3">
								<span class="lovSpan required" style="float: left; width: 100px; margin-right: 5px; margin-top: 2px; height: 21px;">
									<input class="required" type="text" id="txtGibrBranchCd" maxlength="2" style="width: 75px; float: left; border: none; height: 15px; margin: 0;" maxlength="10" tabindex="104" lastValidValue=""/>
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgGibrBranchCd" name="imgGibrBranchCd" alt="Go" style="float: right;" tabindex="105"/>
								</span>
								<input type="text" id="txtBranchName" style="width: 411px; height: 15px;" tabindex="106"/>
							</td>
						</tr>
						<tr>
							<td class="rightAligned">Column No</td>
							<td>
								<input type="text" id="txtColumnNo" class="required" maxlength="2" style="width: 200px; text-align: right;" textValue="Column Number" tabindex="107" lastValidValue=""/>
							</td>
							<td class="rightAligned" width="109">Overdue Tag</td>
							<td>
								<select id="selOverDueTag" style="width: 201px;" tabindex="108">
									<option value="yes">Yes</option>
									<option value="no">No</option>
								</select>
							</td>
						</tr>
						<tr>
							<td class="rightAligned">Column Heading</td>
							<td colspan="3">
								<input type="text" id="txtColumnHeading" class="required" maxlength="50" style="width: 518px;" tabindex="109"/>
							</td>
						</tr>
						<tr>
							<td colspan="4">
								<label style="margin: 6px 0px 0px 14px; float: left;">Report Col No</label>
								<input type="text" id="txtRepColNo" maxlength="2" style="margin-left: 4px; width: 90px; text-align: right; float: left;" textValue="Report Column Number" tabindex="110" lastValidValue=""/>
								<label style="margin: 6px 0px 0px 34px; float: left;">Min No of Days</label>
								<input type="text" id="txtMinNoDays" class="required" maxlength="5" style="margin-left: 4px; width: 90px; text-align: right; float: left;" textValue="Min No of Days" tabindex="111" lastValidValue=""/>
								<label style="margin: 6px 0px 0px 14px; float: left;">Max No of Days</label>
								<input type="text" id="txtMaxNoDays" class="required" maxlength="5" style="margin-left: 4px; width: 90px; text-align: right; float: left;" textValue="Max No of Days" tabindex="112" lastValidValue=""/>
							</td>
						</tr>
						<tr>
							<td width="" class="rightAligned">Remarks</td>
							<td colspan="5">
								<div id="remarksDiv" name="remarksDiv" style="float: left; width: 524px; border: 1px solid gray; height: 22px;">
									<textarea style="float: left; height: 16px; width: 498px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="113"></textarea>
									<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" tabindex="114"/>
								</div>
							</td>
						</tr>
						<tr>
							<td class="rightAligned">User ID</td>
							<td>
								<input id="txtUserId" type="text" style="width: 200px;" readonly="readonly" tabindex="115"/>
							</td>
							<td class="rightAligned">Last Update</td>
							<td>
								<input id="txtLastUpdate" type="text" style="width: 193px;" readonly="readonly" tabindex="116"/>
							</td>
						</tr>
					</table>
				</div>
			</div>
			<div style="margin-top: 205px; margin-bottom: 10px;" align="center">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="117">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="118">
			</div>
			<div style="margin-bottom: 10px;" align="center">
				<input type="button" class="button" id="btnCreateRecords" value="Create Records" style="width: 150px;" tabindex="119">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="120">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="121">
</div>
<div id="hiddenDiv">
	<input type="hidden" id="hidAgingId" />
</div>
<script type="text/javascript">	
	setModuleId("GIACS310");
	setDocumentTitle("Aging Parameter Maintenance");
	initializeAll();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiacs310(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgAgingParameters.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgAgingParameters.geniisysRows);
		new Ajax.Request(contextPath+"/GIACAgingParametersController", {
			method: "POST",
			parameters : {action : "saveGiacs310",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGiacs310.exitPage != null) {
							objGiacs310.exitPage();
						} else {
							tbgAgingParameters._refreshList();
							tbgAgingParameters.keys.releaseKeys();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiacs310);
	
	var objGiacs310 = {};
	var objCurrAgingParameters = null;
	objGiacs310.agingParametersList = JSON.parse('${jsonAgingParameters}');
	objGiacs310.exitPage = null;
	
	var agingParametersModel = {
			url : contextPath + "/GIACAgingParametersController?action=showGiacs310&refresh=1&moduleId=GIACS310",
			options : {
				width : '900px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrAgingParameters = tbgAgingParameters.geniisysRows[y];
					setFieldValues(objCurrAgingParameters);
					tbgAgingParameters.keys.removeFocus(tbgAgingParameters.keys._nCurrentFocus, true);
					tbgAgingParameters.keys.releaseKeys();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgAgingParameters.keys.removeFocus(tbgAgingParameters.keys._nCurrentFocus, true);
					tbgAgingParameters.keys.releaseKeys();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgAgingParameters.keys.removeFocus(tbgAgingParameters.keys._nCurrentFocus, true);
						tbgAgingParameters.keys.releaseKeys();
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
					tbgAgingParameters.keys.removeFocus(tbgAgingParameters.keys._nCurrentFocus, true);
					tbgAgingParameters.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgAgingParameters.keys.removeFocus(tbgAgingParameters.keys._nCurrentFocus, true);
					tbgAgingParameters.keys.releaseKeys();
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
					tbgAgingParameters.keys.removeFocus(tbgAgingParameters.keys._nCurrentFocus, true);
					tbgAgingParameters.keys.releaseKeys();
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
				    id : 'recordStatus', 		// 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
				    width : '0',				    
				    visible : false			
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},
				{
					id : 'gibrGfunFundCd',
					title : 'Fund Code',
					width : '80px',
					filterOption : true
				},
				{
					id : 'gibrBranchCd',
					title : 'Branch Code',
					width : '90px',
					filterOption : true
				},
				{
					id : 'columnNo',
					title : 'Column No',
					width : '80px',
					align : 'right',
					filterOption : true,
					filterOptionType : 'integerNoNegative'
				},
				{
					id : 'columnHeading',
					title : 'Column Heading',
					width : '268px',
					filterOption : true
				},
				{
					id : 'repColNo',
					title : 'Report Col No',
					width : '90px',
					align : 'right',
					filterOption : true,
					filterOptionType : 'integerNoNegative'
				},
				{
					id : 'minNoDays',
					title : 'Min No of Days',
					width : '90px',
					align : 'right',
					filterOption : true,
					filterOptionType : 'integerNoNegative'
				},
				{
					id : 'maxNoDays',
					title : 'Max No of Days',
					width : '90px',
					align : 'right',
					filterOption : true,
					filterOptionType : 'integerNoNegative'
				},
				{
					id : 'overDueTag',
					title : 'Overdue Tag',
					width : '90px',
					filterOption : true,
					renderer : function(value){
						if(value == "Y"){
							return "Yes";
						}else{
							return "No";
						}
					}
				},
			],
			rows : objGiacs310.agingParametersList.rows
		};

		tbgAgingParameters = new MyTableGrid(agingParametersModel);
		tbgAgingParameters.pager = objGiacs310.agingParametersList;
		tbgAgingParameters.render("agingParametersTable");
		tbgAgingParameters.afterRender = function(){
			try{
				
			}catch(e){
				showErrorMessage("tbgAgingParameters.afterRender", e);
			}
		};
		
	function setFieldValues(rec){
		try{
			$("hidAgingId").value = (rec == null ? "" : rec.agingId);
			$("txtGibrGfunFundCd").value = (rec == null ? "" : rec.gibrGfunFundCd);
			$("txtFundDesc").value = (rec == null ? "" : unescapeHTML2(rec.fundDesc));
			$("txtGibrBranchCd").value = (rec == null ? "" : rec.gibrBranchCd);
			$("txtBranchName").value = (rec == null ? "" : unescapeHTML2(rec.branchName));
			$("txtColumnNo").value = (rec == null ? "" : rec.columnNo);
			$("selOverDueTag").selectedIndex = (rec == null ? 0 : rec.overDueTag == "Y" ? 0 : 1);
			$("txtColumnHeading").value = (rec == null ? "" : unescapeHTML2(rec.columnHeading));
			$("txtRepColNo").value = (rec == null ? "" : rec.repColNo);
			$("txtMinNoDays").value = (rec == null ? "" : rec.minNoDays);
			$("txtMaxNoDays").value = (rec == null ? "" : rec.maxNoDays);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("txtUserId").value = (rec == null ? "" : rec.userId);
			$("txtLastUpdate").value = (rec == null ? "" : unescapeHTML2(rec.lastUpdate));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrAgingParameters = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.agingId = $F("hidAgingId");
			obj.gibrGfunFundCd = $F("txtGibrGfunFundCd");
			obj.fundDesc = $F("txtFundDesc");
			obj.gibrBranchCd = $F("txtGibrBranchCd");
			obj.branchName = $F("txtBranchName");
			obj.columnNo = $F("txtColumnNo");
			obj.columnHeading = escapeHTML2($F("txtColumnHeading"));
			obj.minNoDays = $F("txtMinNoDays");
			obj.maxNoDays = $F("txtMaxNoDays");
			obj.overDueTag = $("selOverDueTag").selectedIndex == 0 ? "Y" : "N";
			obj.repColNo = $F("txtRepColNo");
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			obj.remarks = escapeHTML2($F("txtRemarks"));
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			if(checkAllRequiredFieldsInDiv("agingParametersTypeFormDiv")){
				changeTagFunc = saveGiacs310;
				var rec = setRec(objCurrAgingParameters);
				if($F("btnAdd") == "Add"){
					tbgAgingParameters.addBottomRow(rec);
				} else {
					tbgAgingParameters.updateVisibleRowOnly(rec, rowIndex, false);
				}
				changeTag = 1;
				setFieldValues(null);
				tbgAgingParameters.keys.removeFocus(tbgAgingParameters.keys._nCurrentFocus, true);
				tbgAgingParameters.keys.releaseKeys();
			}
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function deleteRec(){
		changeTagFunc = saveGiacs310;
		objCurrAgingParameters.recordStatus = -1;
		tbgAgingParameters.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	}	
	
	function cancelGiacs310(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGiacs310.exitPage = exitPage;
						saveGiacs310();
					}, function(){
						goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");	
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");	
		}
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	function showGiacs310FundCdLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : "getGiacs310FundCdLOV",
							filterText : ($("txtGibrGfunFundCd").readAttribute("lastValidValue").trim() != $F("txtGibrGfunFundCd").trim() ? $F("txtGibrGfunFundCd").trim() : "%"),
							page : 1},
			title: "List of Fund Codes",
			width: 440,
			height: 386,
			columnModel : [
							{
								id : "gibrGfunFundCd",
								title: "Fund Code",
								width: '100px',
								filterOption: true
							},
							{
								id : "fundDesc",
								title: "Fund Desc",
								width: '325px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("txtGibrGfunFundCd").readAttribute("lastValidValue").trim() != $F("txtGibrGfunFundCd").trim() ? $F("txtGibrGfunFundCd").trim() : ""),
				onSelect: function(row) {
					$("txtGibrGfunFundCd").value = row.gibrGfunFundCd;
					$("txtFundDesc").value = row.fundDesc;
					$("txtGibrGfunFundCd").setAttribute("lastValidValue", row.gibrGfunFundCd);	
					$("txtGibrBranchCd").focus();
				},
				onCancel: function (){
					$("txtGibrGfunFundCd").value = $("txtGibrGfunFundCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtGibrGfunFundCd").value = $("txtGibrGfunFundCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
		
	$("imgGibrGFunFundCd").observe("click", showGiacs310FundCdLOV);
	$("txtGibrGfunFundCd").observe("keyup", function(){
		$("txtGibrGfunFundCd").value = $F("txtGibrGfunFundCd").toUpperCase();
	});
	$("txtGibrGfunFundCd").observe("change", function() {
		if($F("txtGibrGfunFundCd").trim() == "") {
			$("txtGibrGfunFundCd").value = "";
			$("txtGibrGfunFundCd").setAttribute("lastValidValue", "");
			$("txtFundDesc").value = "";
		} else {
			if($F("txtGibrGfunFundCd").trim() != "" && $F("txtGibrGfunFundCd") != $("txtGibrGfunFundCd").readAttribute("lastValidValue")) {
				showGiacs310FundCdLOV();
			}
		}
	});
	
	function showGiacs310BranchCdLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : "getGiacs310BranchCdLOV",
							moduleId : "GIACS310",
							filterText : ($("txtGibrBranchCd").readAttribute("lastValidValue").trim() != $F("txtGibrBranchCd").trim() ? $F("txtGibrBranchCd").trim() : "%"),
							page : 1},
			title: "List of Branch Codes",
			width: 440,
			height: 386,
			columnModel : [
							{
								id : "gibrBranchCd",
								title: "Branch Code",
								width: '100px',
								filterOption: true
							},
							{
								id : "branchName",
								title: "Branch Name",
								width: '325px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("txtGibrBranchCd").readAttribute("lastValidValue").trim() != $F("txtGibrBranchCd").trim() ? $F("txtGibrBranchCd").trim() : ""),
				onSelect: function(row) {
					$("txtGibrBranchCd").value = row.gibrBranchCd;
					$("txtBranchName").value = row.branchName;
					$("txtGibrBranchCd").setAttribute("lastValidValue", row.gibrBranchCd);	
					$("txtGibrBranchCd").focus();
				},
				onCancel: function (){
					$("txtGibrBranchCd").value = $("txtGibrBranchCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtGibrBranchCd").value = $("txtGibrBranchCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
		
	$("imgGibrBranchCd").observe("click", showGiacs310BranchCdLOV);
	$("txtGibrBranchCd").observe("keyup", function(){
		$("txtGibrBranchCd").value = $F("txtGibrBranchCd").toUpperCase();
	});
	$("txtGibrBranchCd").observe("change", function() {
		if($F("txtGibrBranchCd").trim() == "") {
			$("txtGibrBranchCd").value = "";
			$("txtGibrBranchCd").setAttribute("lastValidValue", "");
			$("txtBranchName").value = "";
		} else {
			if($F("txtGibrBranchCd").trim() != "" && $F("txtGibrBranchCd") != $("txtGibrBranchCd").readAttribute("lastValidValue")) {
				showGiacs310BranchCdLOV();
			}
		}
	});
	
	function showCreateRecordsOverlay(){
		createRecordsOverlay = Overlay.show(contextPath+"/GIACAgingParametersController", {
			urlParameters: {
				action: "showCreateRecordsOverlay"
			},
			urlContent : true,
			draggable: true,
		    title: "Create Record",
		    height: 220,
		    width: 402
		});
	}
	
	$w("txtColumnNo txtRepColNo").each(function(i){
		$(i).observe("focus", function(){
			$(i).writeAttribute("lastValidValue", $F(i));
		});
	});
	
	$w("txtColumnNo txtRepColNo").each(function(i){
		$(i).observe("change", function(){
			if(isNaN($F(i)) || parseFloat($F(i)) < 1 || parseFloat($F(i)) > 99){
				customShowMessageBox("Invalid "+$(i).getAttribute("textValue")+".  Valid value should be from 1 to 99.", "I", i);
				$(i).value = $(i).readAttribute("lastValidValue");
			}
		});
	});
	
	$w("txtMinNoDays txtMaxNoDays").each(function(i){
		$(i).observe("focus", function(){
			$(i).writeAttribute("lastValidValue", $F(i));
		});
	});
	
	$w("txtMinNoDays txtMaxNoDays").each(function(i){
		$(i).observe("change", function(){
			if(isNaN($F(i)) || parseFloat($F(i)) < 1 || parseFloat($F(i)) > 99999){
				customShowMessageBox("Invalid "+$(i).getAttribute("textValue")+".  Valid value should be from 1 to 99999.", "I", i);
				$(i).value = $(i).readAttribute("lastValidValue");
			}
			
			if($F("txtMinNoDays") != "" && $F("txtMaxNoDays") != ""){ //added by jdiago 08.12.2014
				if(parseInt($F("txtMinNoDays")) > parseInt($F("txtMaxNoDays"))){
					showMessageBox("Min No of Days should not be greater than Max No of Days.","E");
					$(i).value = $(i).readAttribute("lastValidValue");
				}	
			}
		});
	});
	
	disableButton("btnDelete");
	observeSaveForm("btnSave", saveGiacs310);
	$("btnCreateRecords").observe("click", function(){
		if(changeTag == 1){
			showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
				$("btnSave").focus();
			});
		}else{
			showCreateRecordsOverlay();	
		}
	});
	$("btnCancel").observe("click", cancelGiacs310);
	$("btnAdd").observe("click", addRec);
	$("btnDelete").observe("click", deleteRec);
	$("giacs310Exit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtGibrGfunFundCd").focus();	
</script>