<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss216MainDiv" name="giiss216MainDiv" style="">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="btnExit">Exit</a></li>
			</ul>
		</div>
	</div>

	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Branch Code Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss216" name="giiss216">		
		<div class="sectionDiv">
			<div id="bancBranchTableDiv" style="padding-top: 10px;">
				<div id="bancBranchTable" style="height: 331px; margin-left: 65px;"></div>
			</div>
			<div align="center" id="bancBranchFormDiv">
				<table style="margin-top: 15px;" border="0">
					<tr>
						<td class="rightAligned">Branch Code</td>
						<td class="leftAligned">
							<input type="hidden" id="hidStatus" />
							<input id="txtBranchCd" type="text" class="integerNoNegativeUnformatted required" style="width: 200px; text-align: right; margin: 0;"  maxlength="4">
						</td>
						<td class="rightAligned" width="120px;">Branch Eff. Date</td>
						<td class="leftAligned">
							<div style="float: left; width: 206px; height: 21px; margin: 0;" class="withIconDiv required">
								<input type="text" id="txtEffDate" class="withIcon required" readonly="readonly" style="width: 181px;"/>
								<img id="imgEffDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Effectivity Date" style="margin-top: 1px; cursor: pointer;" />
							</div>
						</td>
						<td rowspan="7">
							<img style="margin: 0; margin-left: 30px; cursor: pointer;" id="imgHistory" src="${pageContext.request.contextPath}/images/misc/history.PNG" alt="History"  />
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Description</td>
						<td class="leftAligned" colspan="3">
							<input id="txtBranchDesc" type="text" class="required" style="width: 540px;"  maxlength="100" lastValidValue="">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Area</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan required" style="width: 100px; margin: 0; height: 21px;">
								<input type="text" id="txtAreaCd" class="required integerNoNegativeUnformatted" maxlength="4" ignoreDelKey="true" style="width: 75px; float: left; border: none; height: 14px; margin: 0; text-align: right;" lastValidValue=""/> 
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgAreaCd" alt="Go" style="float: right;"/>
							</span>
							<input id="txtAreaDesc" type="text" style="width: 434px; margin: 0; margin-left: 4px;" readonly="readonly" lastValidValue="">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Manager</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan" style="width: 100px; margin: 0; height: 21px;">
								<input type="text" id="txtManagerCd" class="integerNoNegativeUnformatted" ignoreDelKey="true" maxlength="12" style="width: 75px; float: left; border: none; height: 14px; margin: 0; text-align: right;" lastValidValue=""/> 
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgManager" alt="Go" style="float: right;"/>
							</span>
							<input id="txtManagerName" type="text" style="width: 434px; margin: 0; margin-left: 4px;" readonly="readonly" lastValidValue="">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Bank Account No.</td>
						<td class="leftAligned">
							<input type="text" id="txtBankAcctCd" maxlength="12" style="width: 200px;"/>
						</td>
						<td class="rightAligned">Manager Eff. Date</td>
						<td class="leftAligned">
							<div style="float: left; width: 206px; height: 21px; margin: 0;" class="withIconDiv">
								<input type="text" id="txtMgrEffDate" class="withIcon" readonly="readonly" style="width: 181px;"/>
								<img id="imgMgrEffDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Manager Effectivity Date" style="margin-top: 1px; cursor: pointer;" />
							</div>
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 546px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="2000"  onkeyup="limitText(this,4000);" ></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" />
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" ></td>
						<td class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px; float: right;" readonly="readonly" ></td>
					</tr>
				</table>
			</div>
			<div style="margin: 10px; text-align: center;">
				<input type="button" class="button" id="btnAdd" value="Add" >
				<input type="button" class="button" id="btnDelete" value="Delete" >
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" >
	<input type="button" class="button" id="btnSave" value="Save" >
</div>
<script type="text/javascript">	
	setModuleId("GIISS216");
	setDocumentTitle("Branch Code Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiiss216(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgBancBranch.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgBancBranch.geniisysRows);
		new Ajax.Request(contextPath+"/GIISBancBranchController", {
			method: "POST",
			parameters : {action : "saveGiiss216",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGiiss216.exitPage != null) {
							objGiiss216.exitPage();
						} else {
							tbgBancBranch._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss216);
	
	//var objGiiss216 = {};
	objGiiss216 = new Object();
	var objBancBranch = null;
	objGiiss216.bancBranchList = JSON.parse('${jsonBancBranch}');
	objGiiss216.exitPage = null;
	
	var bancBranchTable = {
			url : contextPath + "/GIISBancBranchController?action=showGiiss216&refresh=1",
			options : {
				width : 800,
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objBancBranch = tbgBancBranch.geniisysRows[y];
					setFieldValues(objBancBranch);
					tbgBancBranch.keys.removeFocus(tbgBancBranch.keys._nCurrentFocus, true);
					tbgBancBranch.keys.releaseKeys();
					$("txtBranchDesc").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgBancBranch.keys.removeFocus(tbgBancBranch.keys._nCurrentFocus, true);
					tbgBancBranch.keys.releaseKeys();
					$("txtBranchCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgBancBranch.keys.removeFocus(tbgBancBranch.keys._nCurrentFocus, true);
						tbgBancBranch.keys.releaseKeys();
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
					tbgBancBranch.keys.removeFocus(tbgBancBranch.keys._nCurrentFocus, true);
					tbgBancBranch.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgBancBranch.keys.removeFocus(tbgBancBranch.keys._nCurrentFocus, true);
					tbgBancBranch.keys.releaseKeys();
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
					tbgBancBranch.keys.removeFocus(tbgBancBranch.keys._nCurrentFocus, true);
					tbgBancBranch.keys.releaseKeys();
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
					id : "branchCd",
					title : "Branch Code",
					titleAlign: "right",
					filterOption : true,
					filterOptionType : "integerNoNegative",
					width : 90,
					align: "right",
					renderer: function(val){
						return val == "" ? "" : formatNumberDigits(val, 4);
					}
				},
				{
					id : 'branchDesc',
					filterOption : true,
					title : "Description",
					width : 360/* ,
					renderer: function(val){
						return unescapeHTML2(val);
					} */
				},
				{
					id : "areaDesc",
					filterOption : true,
					title : "Area",
					width : 200,
					renderer: function(val){
						return unescapeHTML2(val);
					}
				},
				{
					id : "effDate",
					filterOption : true,
					filterOptionType : "formattedDate",
					title : 'Effectivity Date',
					width : 120,
					align: "center",
					titleAlign: "center",
					renderer: function(val){
						return val == "" ? "" : dateFormat(val, "mm-dd-yyyy");
					}
				}
			],
			rows : objGiiss216.bancBranchList.rows
		};

		tbgBancBranch = new MyTableGrid(bancBranchTable);
		tbgBancBranch.pager = objGiiss216.bancBranchList;
		tbgBancBranch.render("bancBranchTable");
	
	function setFieldValues(rec){
		try{
			objGiiss216.branchCd = (rec == null ? "" : rec.branchCd);
			$("txtBranchCd").value = (rec == null ? "" : rec.branchCd != "" ? formatNumberDigits(rec.branchCd, 4) : "");
			$("txtBranchCd").setAttribute("lastValidValue", $("txtBranchCd").value);
			$("txtBranchDesc").value = (rec == null ? "" : unescapeHTML2(rec.branchDesc));
			$("txtBranchDesc").setAttribute("lastValidValue", (rec == null ? "" : $("txtBranchDesc").value));
			
			$("txtAreaCd").value = (rec == null ? "" : rec.areaCd != "" ? formatNumberDigits(rec.areaCd, 4) : "");
			$("txtAreaDesc").value = (rec == null ? "" : unescapeHTML2(rec.areaDesc));
			$("txtAreaCd").setAttribute("lastValidValue", $F("txtAreaCd"));
			$("txtAreaDesc").setAttribute("lastValidValue", $F("txtAreaDesc"));
			
			$("txtManagerCd").value = (rec == null ? "" : (rec.managerCd != null && rec.managerCd != "") ? formatNumberDigits(rec.managerCd, 4) : "");
			$("txtManagerName").value = (rec == null ? "" : unescapeHTML2(rec.managerName));
			$("txtManagerCd").setAttribute("lastValidValue", $F("txtManagerCd"));
			$("txtManagerName").setAttribute("lastValidValue", $F("txtManagerName"));
			
			$("txtBankAcctCd").value = (rec == null ? "" : unescapeHTML2(rec.bankAcctCd));
			$("txtMgrEffDate").value = (rec == null ? "" : rec.mgrEffDate != null ? dateFormat(rec.mgrEffDate, "mm-dd-yyyy") : "");
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("txtEffDate").value = (rec == null ? "" : dateFormat(rec.effDate, "mm-dd-yyyy"));
			
			$("hidStatus").value = (rec == null ? "" : rec.status);
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtBranchCd").readOnly = false : $("txtBranchCd").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objBancBranch = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.oldBranchCd = $("txtBranchCd").readAttribute("lastValidValue");
			obj.oldBranchDesc = escapeHTML2($("txtBranchDesc").readAttribute("lastValidValue"));
			obj.branchCd = $F("txtBranchCd");
			obj.branchDesc = escapeHTML2($F("txtBranchDesc"));
			obj.effDate = $F("txtEffDate");
			obj.areaCd = removeLeadingZero($F("txtAreaCd"));
			obj.areaDesc = escapeHTML2($F("txtAreaDesc"));
			obj.managerCd = removeLeadingZero($F("txtManagerCd"));
			obj.managerName = removeLeadingZero($F("txtManagerName"));
			obj.bankAcctCd = escapeHTML2($F("txtBankAcctCd"));
			obj.mgrEffDate = $F("txtMgrEffDate");
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			if($F("hidStatus") != "new")
				obj.status = $F("btnAdd") == "Add" ? "new" : "updated";			
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGiiss216;
			var dept = setRec(objBancBranch);
			if($F("btnAdd") == "Add"){
				tbgBancBranch.addBottomRow(dept);
			} else {
				tbgBancBranch.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgBancBranch.keys.removeFocus(tbgBancBranch.keys._nCurrentFocus, true);
			tbgBancBranch.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("bancBranchFormDiv")){
				
				var addedSameExists = false;
				var deletedSameExists = false;
				
				var addedSameExists2 = false;
				var deletedSameExists2 = false;
				
				if($F("btnAdd") == "Add") {
					
					for(var i=0; i<tbgBancBranch.geniisysRows.length; i++){
						
						if(tbgBancBranch.geniisysRows[i].recordStatus == 0 || tbgBancBranch.geniisysRows[i].recordStatus == 1){
							
							if(tbgBancBranch.geniisysRows[i].branchCd == $F("txtBranchCd")){
								addedSameExists = true;	
							}	
							
						} else if(tbgBancBranch.geniisysRows[i].recordStatus == -1){
							
							if(tbgBancBranch.geniisysRows[i].branchCd == $F("txtBranchCd")){
								deletedSameExists = true;
							}
						}
						
						//checking of combination of branch_desc and area_cd
						if(tbgBancBranch.geniisysRows[i].recordStatus == 0 || tbgBancBranch.geniisysRows[i].recordStatus == 1){
							if(tbgBancBranch.geniisysRows[i].branchDesc == $F("txtBranchDesc")
									&& tbgBancBranch.geniisysRows[i].areaCd == removeLeadingZero($F("txtAreaCd"))){
								addedSameExists2 = true;	
							}
						} else if(tbgBancBranch.geniisysRows[i].recordStatus == -1){
							
							if(tbgBancBranch.geniisysRows[i].branchDesc == $F("txtBranchDesc")
									&& tbgBancBranch.geniisysRows[i].areaCd == removeLeadingZero($F("txtAreaCd"))){
								deletedSameExists2 = true;
							}
						}
						
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same branch_cd.", "E");
						return;
					} else if ((addedSameExists2 && !deletedSameExists2) || (deletedSameExists2 && addedSameExists2)){
						showMessageBox("Record already exists with the same branch_desc and area_cd.", "E");
						return;
					} else if((deletedSameExists && !addedSameExists) && (deletedSameExists2 && !addedSameExists2)){
						addRec();
						return;
					}					
					
					new Ajax.Request(contextPath + "/GIISBancBranchController", {
						parameters : {action : "valAddRecGiiss216",
									  branchCd : $F("txtBranchCd"),
									  branchDesc : unescapeHTML2($F("txtBranchDesc")),
									  areaCd : removeLeadingZero($F("txtAreaCd")),
									  stat : "add"
						},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								addRec();
							}
						}
					});
					
				} else {
					for(var i=0; i<tbgBancBranch.geniisysRows.length; i++){
						
						//checking of combination of branch_desc and area_cd
						if(tbgBancBranch.geniisysRows[i].recordStatus == 0 || tbgBancBranch.geniisysRows[i].recordStatus == 1){
							if(tbgBancBranch.geniisysRows[i].branchDesc == $F("txtBranchDesc")
									&& tbgBancBranch.geniisysRows[i].areaCd == removeLeadingZero($F("txtAreaCd"))
									&& tbgBancBranch.geniisysRows[i].branchCd != removeLeadingZero($F("txtBranchCd"))){
								addedSameExists2 = true;	
							}
						} else if(tbgBancBranch.geniisysRows[i].recordStatus == -1){
							
							if(tbgBancBranch.geniisysRows[i].branchDesc == $F("txtBranchDesc")
									&& tbgBancBranch.geniisysRows[i].areaCd == removeLeadingZero($F("txtAreaCd"))){
								deletedSameExists2 = true;
							}
						}
						
						 if ((addedSameExists2 && !deletedSameExists2) || (deletedSameExists2 && addedSameExists2)){
							showMessageBox("Record already exists with the same branch_desc and area_cd.", "E");
							return;
						} else if(deletedSameExists2 && !addedSameExists2){
							addRec();
							return;
						} 
					}	
					
					new Ajax.Request(contextPath + "/GIISBancBranchController", {
						parameters : {action : "valAddRecGiiss216",
									  branchCd : $F("txtBranchCd"),
									  branchDesc : unescapeHTML2($F("txtBranchDesc")),
									  areaCd : removeLeadingZero($F("txtAreaCd")),
									  stat : "edit"
						},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								addRec();
							}
						}
					}); 
				}
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}	
	
	function deleteRec(){
		changeTagFunc = saveGiiss216;
		objBancBranch.recordStatus = -1;
		tbgBancBranch.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		if($F("hidStatus") != "new")
			showMessageBox("You cannot delete this record.");
		else
			deleteRec();
	}
	
	function exitPage(){
		delete objGiiss216;
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}	
	
	function cancelGiiss216(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGiiss216.exitPage = exitPage;
						saveGiiss216();
					}, function(){
						goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 2000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("txtBranchDesc").observe("keyup", function(){
		$("txtBranchDesc").value = $F("txtBranchDesc").toUpperCase();
	});
	
	$("txtBranchCd").observe("keyup", function(){
		$("txtBranchCd").value = $F("txtBranchCd").toUpperCase();
	});
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGiiss216);
	$("btnCancel").observe("click", cancelGiiss216);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);
	
	$("btnExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	$("txtBranchCd").focus();
	
	$("imgEffDate").observe("click", function(){
		if ($("imgEffDate").disabled == true)
			return;
		scwShow($("txtEffDate"), this, null);
	});
	
	$("imgMgrEffDate").observe("click", function(){
		if ($("imgMgrEffDate").disabled == true)
			return;
		scwShow($("txtMgrEffDate"), this, null);
	});
	
	$("imgHistory").observe("click", function(){
		if(rowIndex < 0) return;
		try {
			overlayHistory  = 
				Overlay.show(contextPath+"/GIISBancBranchController", {
					urlContent: true,
					urlParameters: {action : "showGiiss216History",
									branchCd : removeLeadingZero($F("txtBranchCd")),
									ajax : "1"
					},
				    title: "History",
				    height: 390,
				    width: 800,
				    draggable: true
				});
			} catch (e) {
				showErrorMessage("imgHistory" , e);
			}		
	});
	
	function getAreaLov() {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getGiiss216AreaLov",
				filterText : ($F("txtAreaCd") == $("txtAreaCd").readAttribute("lastValidValue") ? "" : $F("txtAreaCd")),
				page : 1
			},
			title : "List of Areas",
			width : 480,
			height : 386,
			columnModel : [ {
				id : "areaCd",
				title : "Code",
				width : 120,
				align: "right",
				titleAlign: "right",
				renderer: function(val){
					return formatNumberDigits(val, 4);
				}
			}, {
				id : "areaDesc",
				title : "Description",
				width : '345px',
				renderer: function(value) {
					return unescapeHTML2(value);
				}
			} ],
			draggable : true,
			autoSelectOneRecord: true,
			filterText:  ($F("txtAreaCd") == $("txtAreaCd").readAttribute("lastValidValue") ? "" : $F("txtAreaCd")),
			onSelect : function(row) {
				$("txtAreaCd").value = formatNumberDigits(row.areaCd, 4);
				$("txtAreaDesc").value = unescapeHTML2(row.areaDesc);
				$("txtAreaCd").setAttribute("lastValidValue", $("txtAreaCd").value);
				$("txtAreaDesc").setAttribute("lastValidValue", $("txtAreaDesc").value);
			},
			onCancel : function () {
				$("txtAreaCd").value = $("txtAreaCd").readAttribute("lastValidValue");
				$("txtAreaDesc").value = $("txtAreaDesc").readAttribute("lastValidValue");
				$("txtAreaCd").focus();
			},
			onUndefinedRow : function(){
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtAreaCd");
				$("txtAreaCd").value = $("txtAreaCd").readAttribute("lastValidValue");
				$("txtAreaDesc").value = $("txtAreaDesc").readAttribute("lastValidValue");
				$("txtAreaCd").focus();				
			}
		});
	}
	
	$("imgAreaCd").observe("click", getAreaLov);
	
	function getManagerLov() {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getGiiss216ManagerLov",
				filterText : ($F("txtManagerCd") == $("txtManagerCd").readAttribute("lastValidValue") ? "" : $F("txtManagerCd")),
				page : 1
			},
			title : "List of Managers",
			width : 480,
			height : 386,
			columnModel : [ {
				id : "managerCd",
				title : "Code",
				width : 120,
				align: "right",
				titleAlign: "right",
				renderer : function(val){
					return formatNumberDigits(val, 4);
				}
			}, {
				id : "managerName",
				title : "Name",
				width : '345px',
				renderer: function(value) {
					return unescapeHTML2(value);
				}
			} ],
			draggable : true,
			autoSelectOneRecord: true,
			filterText:  ($F("txtManagerCd") == $("txtManagerCd").readAttribute("lastValidValue") ? "" : $F("txtManagerCd")),
			onSelect : function(row) {
				$("txtManagerCd").value = formatNumberDigits(row.managerCd, 4);
				$("txtManagerName").value = unescapeHTML2(row.managerName);
				$("txtManagerCd").setAttribute("lastValidValue", $("txtManagerCd").value);
				$("txtManagerName").setAttribute("lastValidValue", $("txtManagerName").value);
			},
			onCancel : function () {
				$("txtManagerCd").value = $("txtManagerCd").readAttribute("lastValidValue");
				$("txtManagerName").value = $("txtManagerName").readAttribute("lastValidValue");
				$("txtManagerCd").focus();
			},
			onUndefinedRow : function(){
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtManagerCd");
				$("txtManagerCd").value = $("txtManagerCd").readAttribute("lastValidValue");
				$("txtManagerName").value = $("txtManagerName").readAttribute("lastValidValue");
				$("txtManagerCd").focus();				
			}
		});
	}
	
	$("imgManager").observe("click", getManagerLov);
	
	observeBackSpaceOnDate("txtEffDate");
	observeBackSpaceOnDate("txtMgrEffDate");
	
	//$("txtAreaCd").observe("change", getAreaLov);
	//$("txtManagerCd").observe("change", getManagerLov);
	
	$("txtAreaCd").observe("change", function(){
		if($F("txtAreaCd").trim() == ""){
			$("txtAreaCd").clear();
			$("txtAreaDesc").clear();
			$("txtAreaCd").setAttribute("lastValidValue", "");
			$("txtAreaDesc").setAttribute("lastValidValue", "");
			return;
		}
		getAreaLov();
	});
	
	$("txtManagerCd").observe("change", function(){
		if($F("txtManagerCd").trim() == ""){
			$("txtManagerCd").clear();
			$("txtManagerName").clear();
			$("txtManagerCd").setAttribute("lastValidValue", "");
			$("txtManagerName").setAttribute("lastValidValue", "");
			return;
		}
		getManagerLov();
	});
</script>