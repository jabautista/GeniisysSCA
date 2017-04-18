<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss014MainDiv" name="giiss014MainDiv" style="">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>

	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Assured Type Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss014" name="giiss014">
		<div class="sectionDiv">
			<table align="center" style="margin: 15px auto;">
				<tr>
					<td><label for="txtIndGrpCd" style="float: right; margin: 0 5px 2px 0;">Industry Group</label></td>
					<td>
						<span class="lovSpan required" style="width: 91px; margin: 0px;">
							<input type="text" id="txtIndGrpCd" ignoreDelKey="true" style="text-align: right; width: 66px; float: left; border: none; height: 14px; margin: 0;" maxlength="3" class="required integerNoNegativeUnformatted" tabindex="101" lastValidValue=""/> 
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearch" alt="Go" style="float: right;" tabindex="102"/>
						</span>
					</td>
					<td>
						<input type="text" id="txtIndGrpNm" style="width: 400px; height: 14px;" readonly="readonly" lastValidValue=""/>
					</td>
				</tr>
			</table>
		</div>		
		<div class="sectionDiv">
			<div id="assuredTypeTableDiv" style="padding-top: 10px;">
				<div id="assuredTypeTable" style="height: 331px; margin-left: 115px;"></div>
			</div>
			<div align="center" id="assuredTypeFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Code</td>
						<td class="leftAligned">
							<input id="txtIndustryCd" type="text" class="integerNoNegativeUnformatted" style="width: 200px; text-align: right;" tabindex="201" maxlength="4" readonly="readonly">
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Assured Type</td>
						<td class="leftAligned" colspan="3">
							<input id="txtIndustryNm" type="text" class="required" style="width: 533px;" tabindex="203" maxlength="20">
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
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="206"></td>
						<td width="113px" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="207"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px; text-align: center;">
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
	setModuleId("GIISS014");
	setDocumentTitle("Assured Type Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	showToolbarButton("btnToolbarSave");
	hideToolbarButton("btnToolbarPrint");
	disableToolbarButton("btnToolbarEnterQuery");
	disableToolbarButton("btnToolbarExecuteQuery");
	
	$("txtIndGrpCd").focus();
	
	disableButton("btnAdd");	
	$("txtIndustryNm").readOnly = true;
	$("txtRemarks").readOnly = true;
	
	$("txtIndGrpCd").observe("keypress", function(event){
		if(this.readOnly)
			return;
		
		if(event.keyCode == 0 || event.keyCode == 46 || event.keyCode == 8){
			enableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
			$("txtIndGrpNm").clear();
		}
	});
	
	$("txtIndGrpCd").observe("change", function() {		
		if($F("txtIndGrpCd").trim() == "") {
			$("txtIndGrpCd").value = "";
			$("txtIndGrpCd").setAttribute("lastValidValue", "");
			$("txtIndGrpNm").setAttribute("lastValidValue", "");
			disableToolbarButton("btnToolbarExecuteQuery");
			$("txtIndGrpNm").clear();
		} else {
			getIndustryGroupLOV();
		}
	});
	
	function getIndustryGroupLOV() {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getIndustryGroupLOV",
				filterText : ($("txtIndGrpCd").readAttribute("lastValidValue").trim() != $F("txtIndGrpCd").trim() ? $F("txtIndGrpCd").trim() : ""),
				page : 1
			},
			title : "List of Industry Group",
			width : 480,
			height : 386,
			columnModel : [ 
            	{
					id : "indGrpCd",
					title : "Code",
					width : '120px',
					align: "right",
					titleAlign: "right",
					renderer: function(val){
						return formatNumberDigits(val, 3);
					}
				},
				{
					id : "indGrpNm",
					title : "Industry Group Name",
					width : '345px'
				}
			],
			draggable : true,
			autoSelectOneRecord: true,
			filterText : ($("txtIndGrpCd").readAttribute("lastValidValue").trim() != $F("txtIndGrpCd").trim() ? $F("txtIndGrpCd").trim() : ""),
			onSelect : function(row) {
				$("txtIndGrpCd").value = formatNumberDigits(row.indGrpCd, 3);
				$("txtIndGrpNm").value = unescapeHTML2(row.indGrpNm);
				enableToolbarButton("btnToolbarExecuteQuery");
				enableToolbarButton("btnToolbarEnterQuery");
				$("txtIndGrpCd").setAttribute("lastValidValue", $F("txtIndGrpCd"));
				$("txtIndGrpNm").setAttribute("lastValidValue", $F("txtIndGrpNm"));
			},
			onCancel : function () {
				$("txtIndGrpCd").value = $("txtIndGrpCd").readAttribute("lastValidValue");
				$("txtIndGrpNm").value = $("txtIndGrpNm").readAttribute("lastValidValue");
				$("txtIndGrpCd").focus();
			},
			onUndefinedRow : function(){
				$("txtIndGrpCd").value = $("txtIndGrpCd").readAttribute("lastValidValue");
				$("txtIndGrpNm").value = $("txtIndGrpNm").readAttribute("lastValidValue");
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtIndGrpCd");
			}
		});
	}
	
	$("imgSearch").observe("click", getIndustryGroupLOV);
	
	function executeQuery(){
		$("txtIndGrpCd").readOnly = true;
		disableSearch("imgSearch");
		disableToolbarButton("btnToolbarExecuteQuery");
		enableButton("btnAdd");	
		$("txtIndustryNm").readOnly = false;
		$("txtRemarks").readOnly = false;
		tbgAssuredType.url = contextPath+"/GIISIndustryController?action=getGIISS014IndustryList&refresh=1&indGrpCd=" + removeLeadingZero($F("txtIndGrpCd"));
		tbgAssuredType._refreshList();
	}
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		executeQuery();
	});
	
	function saveGiiss014(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgAssuredType.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgAssuredType.geniisysRows);
		new Ajax.Request(contextPath+"/GIISIndustryController", {
			method: "POST",
			parameters : {action : "saveGiiss014",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS014.exitPage != null) {
							objGIISS014.exitPage();
						} else {
							tbgAssuredType._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss014);
	observeReloadForm("btnToolbarEnterQuery", showGiiss014);
	
	var objGIISS014 = {};
	var objAssuredType = null;
	objGIISS014.assuredTypeList = [];//JSON.parse('${jsonAssuredGroup}');
	objGIISS014.exitPage = null;
	
	var assuredTypeTable = {
			url : contextPath + "/GIISIndustryController?action=showGiiss014&refresh=1",
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objAssuredType = tbgAssuredType.geniisysRows[y];
					setFieldValues(objAssuredType);
					tbgAssuredType.keys.removeFocus(tbgAssuredType.keys._nCurrentFocus, true);
					tbgAssuredType.keys.releaseKeys();
					$("txtIndustryNm").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgAssuredType.keys.removeFocus(tbgAssuredType.keys._nCurrentFocus, true);
					tbgAssuredType.keys.releaseKeys();
					$("txtIndustryNm").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgAssuredType.keys.removeFocus(tbgAssuredType.keys._nCurrentFocus, true);
						tbgAssuredType.keys.releaseKeys();
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
					tbgAssuredType.keys.removeFocus(tbgAssuredType.keys._nCurrentFocus, true);
					tbgAssuredType.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgAssuredType.keys.removeFocus(tbgAssuredType.keys._nCurrentFocus, true);
					tbgAssuredType.keys.releaseKeys();
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
					tbgAssuredType.keys.removeFocus(tbgAssuredType.keys._nCurrentFocus, true);
					tbgAssuredType.keys.releaseKeys();
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
					id : "industryCd",
					title : "Code",
					titleAlign: "right",
					filterOption : true,
					filterOptionType : "integerNoNegative",
					width : '80px',
					align: "right",
					renderer: function(val){
						return val != 0  ? formatNumberDigits(val, 4) : "";
					}
				},
				{
					id : 'industryName',
					filterOption : true,
					title : 'Assured Type',
					width : 610/* ,
					renderer: function(val){
						return unescapeHTML2(val);
					} */ 
				}
			],
			rows : []//objGIISS014.assuredTypeList.rows
		};

		tbgAssuredType = new MyTableGrid(assuredTypeTable);
		tbgAssuredType.pager = [];//objGIISS014.assuredTypeList;
		tbgAssuredType.render("assuredTypeTable");
	
	function setFieldValues(rec){
		try{
			$("txtIndustryCd").value = (rec == null ? "" : rec.industryCd != "" ? formatNumberDigits(rec.industryCd, 4) : "");
			$("txtIndustryCd").setAttribute("lastValidValue", (rec == null ? "" : rec.industryCd));
			$("txtIndustryNm").value = (rec == null ? "" : unescapeHTML2(rec.industryName));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : dateFormat(rec.lastUpdate, "mm-dd-yyyy h:MM:ss TT"));
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			//rec == null ? $("txtIndustryCd").readOnly = false : $("txtIndustryCd").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objAssuredType = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.industryCd = $("btnAdd").value == "Add" ? 0 : $F("txtIndustryCd");
			obj.industryName = escapeHTML2($F("txtIndustryNm"));
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.userId = userId;
			obj.industryGroupCd = removeLeadingZero($F("txtIndGrpCd"));
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGiiss014;
			var dept = setRec(objAssuredType);
			if($F("btnAdd") == "Add"){
				tbgAssuredType.addBottomRow(dept);
			} else {
				tbgAssuredType.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgAssuredType.keys.removeFocus(tbgAssuredType.keys._nCurrentFocus, true);
			tbgAssuredType.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("assuredTypeFormDiv")){
				if($F("btnAdd") == "Add") {
					
					var addedSameExists = false;
					var deletedSameExists = false;	
					
					for(var i=0; i<tbgAssuredType.geniisysRows.length; i++){
						
						if(tbgAssuredType.geniisysRows[i].recordStatus == 0 || tbgAssuredType.geniisysRows[i].recordStatus == 1){
							
							if(tbgAssuredType.geniisysRows[i].industryName == $F("txtIndustryNm")){
								addedSameExists = true;	
							}	
							
						} else if(tbgAssuredType.geniisysRows[i].recordStatus == -1){
							
							if(tbgAssuredType.geniisysRows[i].industryName == $F("txtIndustryNm")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same industry_nm.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}					
					
					new Ajax.Request(contextPath + "/GIISIndustryController", {
						parameters : {action : "valAddRec",
									  industryNm : $F("txtIndustryNm")},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								addRec();
							}
						}
					});
					
				} else {
					
					var updatedSameExists = false;
					var deletedSameExists = false;	
					
					for(var i=0; i<tbgAssuredType.geniisysRows.length; i++){
						
						if(tbgAssuredType.geniisysRows[i].recordStatus == 0 || tbgAssuredType.geniisysRows[i].recordStatus == 1){
							
							if(tbgAssuredType.geniisysRows[i].industryName == $F("txtIndustryNm")){								
									if( removeLeadingZero(tbgAssuredType.geniisysRows[i].industryCd) != removeLeadingZero($F("txtIndustryCd")))
										updatedSameExists = true;	
							}	
							
						} else if(tbgAssuredType.geniisysRows[i].recordStatus == -1){
							
							if(tbgAssuredType.geniisysRows[i].industryName == $F("txtIndustryNm")){
								deletedSameExists = true;
							}
						}
					}
					
					if((updatedSameExists && !deletedSameExists) || (deletedSameExists && updatedSameExists)){
						showMessageBox("Record already exists with the same industry_nm.", "E");
						return;
					} else if(deletedSameExists && !updatedSameExists){
						addRec();
						return;
					}
					
					new Ajax.Request(contextPath + "/GIISIndustryController", {
						parameters : {action : "valUpdateRec",
									  industryCd : $F("txtIndustryCd"),
									  industryNm : $F("txtIndustryNm")},
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
		changeTagFunc = saveGiiss014;
		objAssuredType.recordStatus = -1;
		tbgAssuredType.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISIndustryController", {
				parameters : {action : "valDeleteRec",
							  industryCd : $F("txtIndustryCd")},
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
	
	function cancelgiiss014(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS014.exitPage = exitPage;
						saveGiiss014();
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
	
	$("txtIndustryNm").observe("keyup", function(){
		$("txtIndustryNm").value = $F("txtIndustryNm").toUpperCase();
	});
	
	$("txtIndustryCd").observe("keyup", function(){
		$("txtIndustryCd").value = $F("txtIndustryCd").toUpperCase();
	});
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGiiss014);
	observeSaveForm("btnToolbarSave", saveGiiss014);
	$("btnCancel").observe("click", cancelgiiss014);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);
	
	$("btnToolbarExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
		
</script>