<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss210MainDiv" name="giiss210MainDiv" style="">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="menuFileMaintenanceExit">Exit</a></li>
				</ul>
			</div>
		</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Non-Renewal Reason Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss210" name="giiss210">		
		<div class="sectionDiv">
			<div id="nonRenewReasonDiv" style="padding-top: 10px;">
				<div id="nonRenewReasonTable" style="height: 340px; margin-left: 115px;"></div>
			</div>
			<div align="" id="nonRenewReasonFormDiv" style="margin-left: 160px;">
				<table style="margin-top: 5px;">
					<tr></tr>
					<tr></tr>
					<tr><!-- added by carlo 10-24-2017 SR 5915 -->
						<td colspan="4" class="rightAligned">
						<input type="checkbox" id="chkActiveTag" name="chkActiveTag" class="required" style="margin-right: 5px;"/><label for="chkActiveTag" style="float: right;">Active Tag</label>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Code</td>
						<td class="leftAligned">
							<input id="txtNonRenReasonCd" type="text" class="required" style="width: 200px; text-align: left;" tabindex="201" maxlength="4">
						</td>
						<td class="rightAligned">Line Code</td>
						<td class="leftAligned" colspan="">
							<span class="lovSpan" id="lineSpan" style="float: left; width: 208px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="" type="text" id="txtLineCd" name="txtLineCd" style="width: 180px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="107" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgLineLOV" name="imgLineLOV" alt="Go" style="float: right;" tabindex="108"/>
							</span>
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Description</td>
						<td class="leftAligned" colspan="3">
							<input id="txtNonRenReasonDesc" type="text" class="required" style="width: 533px;" tabindex="203" maxlength="100" lastValidValue="">
							<input id="txtHidNonRenReasonDesc" type="hidden" class="required" style="width: 533px;" tabindex="203" maxlength="100">
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
						<td width="110px;" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 202px;" readonly="readonly" tabindex="207"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;" align="center">
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
	setModuleId("GIISS210");
	setDocumentTitle("Non-Renewal Reason Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	changed = false;
	
	function saveGiiss210(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgNonRenewReason.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgNonRenewReason.geniisysRows);
		new Ajax.Request(contextPath+"/GIISNonRenewReasonController", {
			method: "POST",
			parameters : {action : "saveGiiss210",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS210.exitPage != null) {
							objGIISS210.exitPage();
						} else {
							tbgNonRenewReason._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGIISS210);
	
	var objGIISS210 = {};
	var objCurrNonRenewReason = null;
	objGIISS210.nonRenewReasonList = JSON.parse('${jsonNonRenewReasonList}');
	objGIISS210.exitPage = null;
	
	var nonRenewReasonTable = {
			url : contextPath + "/GIISNonRenewReasonController?action=showGiiss210&refresh=1",
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrNonRenewReason = tbgNonRenewReason.geniisysRows[y];
					setFieldValues(objCurrNonRenewReason);
					tbgNonRenewReason.keys.removeFocus(tbgNonRenewReason.keys._nCurrentFocus, true);
					tbgNonRenewReason.keys.releaseKeys();
					$("txtNonRenReasonDesc").focus();
					changed = false;
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgNonRenewReason.keys.removeFocus(tbgNonRenewReason.keys._nCurrentFocus, true);
					tbgNonRenewReason.keys.releaseKeys();
					$("txtNonRenReasonCd").focus();
					changed = false;
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgNonRenewReason.keys.removeFocus(tbgNonRenewReason.keys._nCurrentFocus, true);
						tbgNonRenewReason.keys.releaseKeys();
						changed = false;
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
					tbgNonRenewReason.keys.removeFocus(tbgNonRenewReason.keys._nCurrentFocus, true);
					tbgNonRenewReason.keys.releaseKeys();
					changed = false;
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgNonRenewReason.keys.removeFocus(tbgNonRenewReason.keys._nCurrentFocus, true);
					tbgNonRenewReason.keys.releaseKeys();
					changed = false;
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
					tbgNonRenewReason.keys.removeFocus(tbgNonRenewReason.keys._nCurrentFocus, true);
					tbgNonRenewReason.keys.releaseKeys();
					changed = false;
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
				    id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
				    width: '0',				    
				    visible : false			
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},	
				{
					id : "nonRenReasonCd",
					title : "Code",
					filterOption : true,
					width : '120px'
				},
				{
					id : 'nonRenReasonDesc',
					filterOption : true,
					title : 'Description',
					width : '410px'				
				},		
				{
					id : 'lineCd',
					filterOption : true,
					title : 'Line Code',
					width : '130px'				
				},
				{	id: 'activeTag', //added by carlo
					title: 'A',
					altTitle: 'Active Tag',
					titleAlign: 'center',
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
			rows : objGIISS210.nonRenewReasonList.rows
		};

		tbgNonRenewReason = new MyTableGrid(nonRenewReasonTable);
		tbgNonRenewReason.pager = objGIISS210.nonRenewReasonList;
		tbgNonRenewReason.render("nonRenewReasonTable");
	
	function setFieldValues(rec){
		try{
			$("txtNonRenReasonCd").value 	= (rec == null ? "" : unescapeHTML2(rec.nonRenReasonCd));
			$("txtNonRenReasonCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.nonRenReasonCd)));
			$("txtNonRenReasonDesc").value 	= (rec == null ? "" : unescapeHTML2(rec.nonRenReasonDesc));
			$("txtNonRenReasonDesc").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.nonRenReasonDesc)));
			$("txtLineCd").value		 	= (rec == null ? "" : unescapeHTML2(rec.lineCd));
			$("txtUserId").value 			= (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value 		= (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value 			= (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("chkActiveTag").checked       = (rec == null ? "" : rec.activeTag == 'A' ? true : false); //carlo 01-26-2017
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtNonRenReasonCd").readOnly = false : $("txtNonRenReasonCd").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrNonRenewReason = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.nonRenReasonCd 	 = escapeHTML2($F("txtNonRenReasonCd"));
			obj.nonRenReasonDesc = escapeHTML2($F("txtNonRenReasonDesc"));
			obj.lineCd			 = escapeHTML2($F("txtLineCd"));
			obj.remarks 		 = escapeHTML2($F("txtRemarks"));
			obj.userId 			 = userId;
			var lastUpdate 		 = new Date();
			obj.lastUpdate 		 = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			obj.activeTag        = $("chkActiveTag").checked ? "A" : "I"; //carlo 01-26-2017
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGiiss210;
			var dept = setRec(objCurrNonRenewReason);
			if($F("btnAdd") == "Add"){
				tbgNonRenewReason.addBottomRow(dept);
			} else {
				tbgNonRenewReason.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgNonRenewReason.keys.removeFocus(tbgNonRenewReason.keys._nCurrentFocus, true);
			tbgNonRenewReason.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("nonRenewReasonFormDiv")){
				var addedSameExists = false;
				var deletedSameExists = false;					
				var column = "";
				if($F("btnAdd") == "Add") {
					for(var i=0; i<tbgNonRenewReason.geniisysRows.length; i++){
						if(tbgNonRenewReason.geniisysRows[i].recordStatus == 0 || tbgNonRenewReason.geniisysRows[i].recordStatus == 1){		
							$("txtHidNonRenReasonDesc").value = tbgNonRenewReason.geniisysRows[i].nonRenReasonDesc;
							if(tbgNonRenewReason.geniisysRows[i].nonRenReasonCd == $F("txtNonRenReasonCd")){
								addedSameExists = true;
								column = "non_ren_reason_cd";
							}else if ($F("txtHidNonRenReasonDesc").toUpperCase() == $F("txtNonRenReasonDesc").toUpperCase()) {
								addedSameExists = true;
								column = "non_ren_reason_desc";
							}							
						} else if(tbgNonRenewReason.geniisysRows[i].recordStatus == -1){
							if(tbgNonRenewReason.geniisysRows[i].nonRenReasonCd == $F("txtNonRenReasonCd")){
								deletedSameExists = true;
								column = "non_ren_reason_cd";
							}else if ($F("txtHidNonRenReasonDesc").toUpperCase() == $F("txtNonRenReasonDesc").toUpperCase()){
								deletedSameExists = true;
								column = "non_ren_reason_desc";
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same " + column + ".", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GIISNonRenewReasonController", {
						parameters : {action : "valAddRec",
									  recId : $F("txtNonRenReasonCd"),
									  redDesc : $F("txtNonRenReasonDesc")},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								addRec();
							}
						}
					});
				} else {
					if (changed) {
						for(var i=0; i<tbgNonRenewReason.geniisysRows.length; i++){
							if(tbgNonRenewReason.geniisysRows[i].recordStatus == 0 || tbgNonRenewReason.geniisysRows[i].recordStatus == 1){		
								$("txtHidNonRenReasonDesc").value = tbgNonRenewReason.geniisysRows[i].nonRenReasonDesc;
								if ($F("txtHidNonRenReasonDesc").toUpperCase() == $F("txtNonRenReasonDesc").toUpperCase()) {
									addedSameExists = true;
									column = "non_ren_reason_desc";
								}							
							} else if(tbgNonRenewReason.geniisysRows[i].recordStatus == -1){
								if ($F("txtHidNonRenReasonDesc").toUpperCase() == $F("txtNonRenReasonDesc").toUpperCase()){
									deletedSameExists = true;
									column = "non_ren_reason_desc";
								}
							}
						}
						
						if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
							showMessageBox("Record already exists with the same " + column + ".", "E");
							return;
						} else if(deletedSameExists && !addedSameExists){
							addRec();
							return;
						}
						new Ajax.Request(contextPath + "/GIISNonRenewReasonController", {
							parameters : {action : "valAddRec",
										  recId : $F("txtNonRenReasonCd"),
										  redDesc : $F("txtNonRenReasonDesc")},
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
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}	
	
	function deleteRec(){
		changeTagFunc = saveGiiss210;
		objCurrNonRenewReason.recordStatus = -1;
		tbgNonRenewReason.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISNonRenewReasonController", {
				parameters : {action : "valDeleteRec",
							  nonRenReasonCd : $F("txtNonRenReasonCd")},
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

	function showLineLOV(isIconClicked) {
		try {
			var search = isIconClicked ? "%" : ($F("txtLineCd").trim() == "" ? "%" : $F("txtLineCd"));

			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGiiss210LineRecList",
					search : search + "%",
					page : 1
				},
				title : "List of Line Codes",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "lineCd",
					title : "Line Code",
					width : '120px'
				}, {
					id : "lineName",
					title : "Line Name",
					width : '345px'
				} ],
				draggable : true,
				autoSelectOneRecord : true,
				filterText : escapeHTML2(search),
				onSelect : function(row) {
					if (row != null || row != undefined) {
						$("txtLineCd").value = unescapeHTML2(row.lineCd);
						$("txtLineCd").setAttribute("lastValidValue", unescapeHTML2(row.lineCd));
					}
				},
				onCancel : function() {
					$("txtLineCd").focus();
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function() {
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtLineCd");
				}
			});
		} catch (e) {
			showErrorMessage("showLineLOV", e);
		}
	}
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}	
	
	function cancelGiiss210(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS210.exitPage = exitPage;
						saveGiiss210();
					}, function(){
						goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
	}

	$("imgLineLOV").observe("click", function() {
		showLineLOV(true);
	});
	
	$("txtLineCd").observe("change", function() {
		if (this.value != "") {
			showLineLOV(false);
		} else {
			$("txtLineCd").value = "";
			$("txtLineCd").setAttribute("lastValidValue", "");
		}
	});
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("txtLineCd").observe("keyup", function(){
		$("txtLineCd").value = $F("txtLineCd").toUpperCase();
	});
	
	$("txtNonRenReasonCd").observe("keyup", function(){
		$("txtNonRenReasonCd").value = $F("txtNonRenReasonCd").toUpperCase();
	});
	
	$("txtNonRenReasonDesc").observe("change", function(){
		if ($F("txtNonRenReasonDesc") != $("txtNonRenReasonDesc").readAttribute("lastValidValue")) {
			changed = true;
		}else {
			changed = false;
		}
	});
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGiiss210);
	$("btnCancel").observe("click", cancelGiiss210);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("menuFileMaintenanceExit").stopObserving("click");
	$("menuFileMaintenanceExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtNonRenReasonCd").focus();	
</script>