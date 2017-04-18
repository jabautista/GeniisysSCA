<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giacs335MainDiv" name="giacs335MainDiv" style="">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>SOA Title Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giacs335" name="giacs335">		
		<div class="sectionDiv">
			<div id="soaTitleTableDiv" style="padding-top: 10px;">
				<div id="soaTitleTable" style="height: 340px; margin-left: 115px;"></div>
			</div>
			<div align="center" id="soaTitleFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Rep Code</td>
						<td class="leftAligned">
							<span class="lovSpan" style="width: 200px; height: 21px; margin: 2px 2px 0 0; float: left;">
								<input type="text" id="txtRepCd" name="txtRepCd" style="width: 173px; float: left; border: none; height: 13px;" class="required integerNoNegativeUnformattedNoComma rightAligned" maxlength="2" tabindex="201" />
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchRepCd" name="searchRepCd" alt="Go" style="float: right;">
							</span> 
						</td>
						<td class="rightAligned" width="113px">Col No</td>
						<td class="leftAligned">
							<input id="txtColNo" type="text" class="required integerNoNegativeUnformattedNoComma" style="width: 200px; text-align: right;" tabindex="201" maxlength="2">
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Col Title</td>
						<td class="leftAligned" colspan="3">
							<input id="txtColTitle" type="text" class="required" style="width: 533px;" tabindex="203" maxlength="50">
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
						<td width="" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="207"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;">
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
	setModuleId("GIACS335");
	setDocumentTitle("SOA Title Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiacs335(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgSoaTitle.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgSoaTitle.geniisysRows);
		new Ajax.Request(contextPath+"/GIACSoaTitleController", {
			method: "POST",
			parameters : {action : "saveGiacs335",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIACS335.exitPage != null) {
							objGIACS335.exitPage();
						} else {
							tbgSoaTitle._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiacs335);
	
	var objGIACS335 = {};
	var objCurrSoaTitle = null;
	objGIACS335.soaTitle = JSON.parse('${jsonSoaTitle}');
	objGIACS335.exitPage = null;
	
	var soaTitleTable = {
			url : contextPath + "/GIACSoaTitleController?action=showGiacs335&refresh=1",
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrSoaTitle = tbgSoaTitle.geniisysRows[y];
					setFieldValues(objCurrSoaTitle);
					tbgSoaTitle.keys.removeFocus(tbgSoaTitle.keys._nCurrentFocus, true);
					tbgSoaTitle.keys.releaseKeys();
					$("txtColTitle").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgSoaTitle.keys.removeFocus(tbgSoaTitle.keys._nCurrentFocus, true);
					tbgSoaTitle.keys.releaseKeys();
					$("txtRepCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgSoaTitle.keys.removeFocus(tbgSoaTitle.keys._nCurrentFocus, true);
						tbgSoaTitle.keys.releaseKeys();
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
					tbgSoaTitle.keys.removeFocus(tbgSoaTitle.keys._nCurrentFocus, true);
					tbgSoaTitle.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgSoaTitle.keys.removeFocus(tbgSoaTitle.keys._nCurrentFocus, true);
					tbgSoaTitle.keys.releaseKeys();
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
					tbgSoaTitle.keys.removeFocus(tbgSoaTitle.keys._nCurrentFocus, true);
					tbgSoaTitle.keys.releaseKeys();
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
					id : "repCd",
					title : "Rep Code",
					filterOption : true,
					width : '80px',
					align : "right",
					titleAlign : "right",
					filterOptionType: 'integerNoNegative'
				},
				{
					id : 'colNo',
					filterOption : true,
					title : 'Column No',
					width : '100px',
					align : "right",
					titleAlign : "right",
					filterOptionType: 'integerNoNegative'
				},
				{
					id : 'colTitle',
					filterOption : true,
					title : 'Column Title',
					width : '480px'				
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
			rows : objGIACS335.soaTitle.rows
		};

		tbgSoaTitle = new MyTableGrid(soaTitleTable);
		tbgSoaTitle.pager = objGIACS335.soaTitle;
		tbgSoaTitle.render("soaTitleTable");
	
	function setFieldValues(rec){
		try{
			$("txtRepCd").value = (rec == null ? "" : rec.repCd);
			$("txtRepCd").setAttribute("lastValidValue", (rec == null ? "" : rec.repCd));
			$("txtColTitle").value = (rec == null ? "" : unescapeHTML2(rec.colTitle));
			$("txtColNo").value = (rec == null ? "" : rec.colNo);
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtRepCd").readOnly = false : $("txtRepCd").readOnly = true;
			rec == null ? $("txtColNo").readOnly = false : $("txtColNo").readOnly = true;
			rec == null ? enableSearch("searchRepCd") : disableSearch("searchRepCd");
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrSoaTitle = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.repCd = $F("txtRepCd");
			obj.colTitle = escapeHTML2($F("txtColTitle"));
			obj.colNo = $F("txtColNo");
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
			changeTagFunc = saveGiacs335;
			var dept = setRec(objCurrSoaTitle);
			if($F("btnAdd") == "Add"){
				tbgSoaTitle.addBottomRow(dept);
			} else {
				tbgSoaTitle.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgSoaTitle.keys.removeFocus(tbgSoaTitle.keys._nCurrentFocus, true);
			tbgSoaTitle.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("soaTitleFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;	
					
					for ( var i = 0; i < tbgSoaTitle.geniisysRows.length; i++) {
						if (tbgSoaTitle.geniisysRows[i].recordStatus == 0 || tbgSoaTitle.geniisysRows[i].recordStatus == 1) {
							if (tbgSoaTitle.geniisysRows[i].repCd == $F("txtRepCd") && tbgSoaTitle.geniisysRows[i].colNo == $F("txtColNo")) {
								addedSameExists = true;
							}
						} else if (tbgSoaTitle.geniisysRows[i].recordStatus == -1) {
							if (tbgSoaTitle.geniisysRows[i].repCd == $F("txtRepCd") && tbgSoaTitle.geniisysRows[i].colNo == $F("txtColNo")) {
								deletedSameExists = true;
							}
						}
					}
					if ((addedSameExists && !deletedSameExists)|| (deletedSameExists && addedSameExists)) {
						showMessageBox("Record already exists with the same rep_cd, col_no.", "E");
						return;
					} else if (deletedSameExists && !addedSameExists) {
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GIACSoaTitleController", {
						parameters : {action : "valAddRec",
									  repCd : $F("txtRepCd"),
									  colNo : $F("txtColNo") },
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(response.responseText == "Y"){
								showMessageBox("Record already exists with the same rep_cd, col_no.", imgMessage.ERROR);
							} else if(response.responseText != "Y"){
								addRec();
							} else {
								//if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
									addRec();
								//}
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
		changeTagFunc = saveGiacs335;
		objCurrSoaTitle.recordStatus = -1;
		tbgSoaTitle.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIACSoaTitleController", {
				parameters : {action : "valDeleteRec",
							  repCd : $F("txtRepCd"),
							  colNo : $F("txtColNo"),},
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
	
	function cancelGiacs335(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIACS335.exitPage = exitPage;
						saveGiacs335();
					}, function(){
						goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		}
	}
	
	$("searchRepCd").observe("click",showRepCdLOV);
	
	function showRepCdLOV(){
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					  action : "getGiacs335LOV",
				   filterText: $F("txtRepCd") != $("txtRepCd").getAttribute("lastValidValue") ? nvl($F("txtRepCd"), "%") : "%", 
						page : 1
				},
				title: "List of Rep Codes",
				width: 470,
				height: 400,
				columnModel: [
		 			{
						id : 'rvLowValue',
						title: 'Value',
						width : '100px',
						align: 'right',
						titleAlign : 'right'
					},
					{
						id : 'rvMeaning',
						title: 'Meaning',
					    width: '335px',
					    align: 'left'
					}
				],
				autoSelectOneRecord : true,
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtRepCd").setAttribute("lastValidValue", unescapeHTML2(row.rvLowValue));
						$("txtRepCd").value = unescapeHTML2(row.rvLowValue);
					}
				},
				onCancel: function(){
					$("txtRepCd").focus();
					$("txtRepCd").value = $("txtRepCd").readAttribute("lastValidValue");
		  		},
		  		onUndefinedRow: function(){
		  			showWaitingMessageBox("No record found.", "I", function(){
		  				$("txtRepCd").value = $("txtRepCd").readAttribute("lastValidValue");
					});
				},
				onShow: function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			});
		}catch(e){
			showErrorMessage("showRepCdLOV",e);
		}
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("txtColTitle").observe("keyup", function(){
		$("txtColTitle").value = $F("txtColTitle").toUpperCase();
	});
	
	$("txtRepCd").observe("keyup", function(){
		$("txtRepCd").value = $F("txtRepCd").toUpperCase();
	});
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGiacs335);
	$("btnCancel").observe("click", cancelGiacs335);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("acExit").stopObserving("click");
	$("acExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtRepCd").focus();	
	
	$("txtRepCd").observe("change",function(){
		if($("txtRepCd").value){
			validateRepCd();
		}
	});
	
	function validateRepCd(){
		new Ajax.Request(contextPath+"/GIACSoaTitleController", {
			method: "POST",
			parameters: {
				action: "validateRepCd",
				repCd: $F("txtRepCd")
			},
			onCreate: showNotice("Please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(nvl(obj.repCd, "") == ""){
						//showLineLOV($("txtLineCd").value, $("txtLineCd").value);
						/* showWaitingMessageBox("No record found.", "I", function(){
						$("txtRepCd").focus();
						$("txtRepCd").value = "";
						}); */
						showRepCdLOV();
					}
					else{
						$("txtRepCd").setAttribute("lastValidValue", unescapeHTML2(obj.repCd));
						$("txtRepCd").value = unescapeHTML2(obj.repCd);
					}
				}
			}
		});
	}
</script>