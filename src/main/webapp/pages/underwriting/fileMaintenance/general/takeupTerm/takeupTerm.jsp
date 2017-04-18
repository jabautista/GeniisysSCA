<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss211MainDiv" name="giiss211MainDiv" style="">
	<div id="takeupTermDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="takeupTermExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Take-Up Term Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss211" name="giiss211">		
		<div class="sectionDiv">
			<div id="takeupTermTableDiv" style="padding-top: 10px;">
				<div id="takeupTermTable" style="height: 332px; margin-left: 165px;"></div>
			</div>
			<div align="center" id="takeupTermFormDiv">
				<table style="margin-top: 20px;">
					<tr>						
						<td></td>
						<td class="leftAligned">
							<input id="chkYearlyTag" type="checkbox" style="float: left; margin: 0 7px 0 0px;"><label for="chkYearlyTag" style="margin: 0 4px 2px 2px;">Yearly Tag</label>
						</td>				
						<td colspan="2"></td>
					</tr>
					<tr>
						<td class="rightAligned">Take-Up Term</td>
						<td class="leftAligned">
							<input id="txtTakeupTerm" type="text" class="required" style="width: 200px;" tabindex="201" maxlength="3">
						</td>
						<td class="rightAligned" width="120px">No. of Take-Up</td>
						<td class="leftAligned">
							<input id="txtNoOfTakeup" type="text" class="required integerNoNegativeUnformattedNoComma rightAligned" style="width: 200px;" tabindex="202" maxlength="2">
						</td>
					</tr>	
					<tr>
						<td class="rightAligned">Description</td>
						<td class="leftAligned" colspan="3">
							<input id="txtTakeupTermDesc" type="text" class="required" style="width: 542px; " tabindex="203" maxlength="25">							
						</td>
					</tr>	
					<tr>
						<td class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 548px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 520px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="204"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="205"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="206"></td>
						<td width="" class="rightAligned"  width="120px">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="207"></td>
					</tr>	
				</table>
			</div>
			<div align="center" style="margin: 10px;">
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
	setModuleId("GIISS211");
	setDocumentTitle("Take-Up Term Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
		
	function saveGiiss211(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgTakeupTerm.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgTakeupTerm.geniisysRows);
		new Ajax.Request(contextPath+"/GIISTakeupTermController", {
			method: "POST",
			parameters : {action : "saveGiiss211",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS211.exitPage != null) {
							objGIISS211.exitPage();
						} else {
							tbgTakeupTerm._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss211);
	
	var objGIISS211 = {};
	var objTakeupTerm = null;
	objGIISS211.takeupTermList = JSON.parse('${jsonTakeupTermList}');
	objGIISS211.exitPage = null;
	
	var takeupTermTableModel = {
			url : contextPath + "/GIISTakeupTermController?action=showGiiss211&refresh=1",
			options : {
				width : '593px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objTakeupTerm = tbgTakeupTerm.geniisysRows[y];
					setFieldValues(objTakeupTerm);
					tbgTakeupTerm.keys.removeFocus(tbgTakeupTerm.keys._nCurrentFocus, true);
					tbgTakeupTerm.keys.releaseKeys();
					$("txtTakeupTermDesc").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgTakeupTerm.keys.removeFocus(tbgTakeupTerm.keys._nCurrentFocus, true);
					tbgTakeupTerm.keys.releaseKeys();
					$("txtTakeupTerm").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgTakeupTerm.keys.removeFocus(tbgTakeupTerm.keys._nCurrentFocus, true);
						tbgTakeupTerm.keys.releaseKeys();
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
					tbgTakeupTerm.keys.removeFocus(tbgTakeupTerm.keys._nCurrentFocus, true);
					tbgTakeupTerm.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgTakeupTerm.keys.removeFocus(tbgTakeupTerm.keys._nCurrentFocus, true);
					tbgTakeupTerm.keys.releaseKeys();
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
					tbgTakeupTerm.keys.removeFocus(tbgTakeupTerm.keys._nCurrentFocus, true);
					tbgTakeupTerm.keys.releaseKeys();
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
				{ 	id:			'yearlyTag',
					align:		'center',
					title:		'&#160;&#160;Y',
					altTitle:   'Yearly Tag',
					titleAlign:	'center',
					width:		'30px',
			   		editable: false,
			   		filterOption: true,
			   		filterOptionType : 'checkbox',
				    hideSelectAllBox: true,
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
					id : 'takeupTerm',
					filterOption : true,
					title : 'Take-Up Term',
					width : '125px'				
				},
				{
					id : 'takeupTermDesc',
					filterOption : true,
					title : 'Description',
					width : '280px'				
				},	
				{
					id : 'noOfTakeup',
					filterOption : true,
					filterOptionType: 'integerNoNegative',
					title : 'No. of Take-Up',
					titleAlign: 'right',
					align: 'right',
					width : '120px'				
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
			rows : objGIISS211.takeupTermList.rows
		};

		tbgTakeupTerm = new MyTableGrid(takeupTermTableModel);
		tbgTakeupTerm.pager = objGIISS211.takeupTermList;
		tbgTakeupTerm.render("takeupTermTable");
	
	function setFieldValues(rec){
		try{
			$("txtTakeupTerm").value = (rec == null ? "" : unescapeHTML2(rec.takeupTerm));
			$("txtTakeupTerm").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.takeupTerm)));
			$("txtTakeupTermDesc").value = (rec == null ? "" : unescapeHTML2(rec.takeupTermDesc));
			$("txtNoOfTakeup").value = (rec == null ? "" : rec.noOfTakeup);
			$("chkYearlyTag").checked = (rec == null ? false : rec.yearlyTag == "Y" ? true : false);
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtTakeupTerm").readOnly = false : $("txtTakeupTerm").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objTakeupTerm = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.takeupTerm = escapeHTML2($F("txtTakeupTerm"));
			obj.takeupTermDesc = escapeHTML2($F("txtTakeupTermDesc"));
			obj.noOfTakeup = $F("txtNoOfTakeup");
			obj.yearlyTag = $("chkYearlyTag").checked ? "Y" : "N";
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
			changeTagFunc = saveGiiss211;
			var dept = setRec(objTakeupTerm);
			if($F("btnAdd") == "Add"){
				tbgTakeupTerm.addBottomRow(dept);
			} else {
				tbgTakeupTerm.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgTakeupTerm.keys.removeFocus(tbgTakeupTerm.keys._nCurrentFocus, true);
			tbgTakeupTerm.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function checkAddRec(){
		var takeupTerm = ($F("btnAdd") == "Add" ? $F("txtTakeupTerm") : null);
		var takeupTermDesc = ($F("btnAdd") == "Add" ? $F("txtTakeupTermDesc") : 
										(unescapeHTML2(objTakeupTerm.takeupTermDesc) == $F("txtTakeupTermDesc") ? null : $F("txtTakeupTermDesc")));
		
		new Ajax.Request(contextPath + "/GIISTakeupTermController", {
			parameters : {action : "valAddRec",
						  takeupTerm : takeupTerm,
						  takeupTermDesc : takeupTermDesc},
			onCreate : showNotice("Processing, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					addRec();
				}
			}
		});
	}
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("takeupTermFormDiv")){
				var addedSameExists = false;
				var deletedSameExists = false;	
				var addedSameExists2 = false;
				var deletedSameExists2 = false;		
				
				if($F("btnAdd") == "Add") {	
					for(var i=0; i<tbgTakeupTerm.geniisysRows.length; i++){
						if(tbgTakeupTerm.geniisysRows[i].recordStatus == 0 || tbgTakeupTerm.geniisysRows[i].recordStatus == 1){								
							if(unescapeHTML2(tbgTakeupTerm.geniisysRows[i].takeupTerm) == $F("txtTakeupTerm")){
								addedSameExists = true;								
							}							
						} else if(tbgTakeupTerm.geniisysRows[i].recordStatus == -1){
							if(unescapeHTML2(tbgTakeupTerm.geniisysRows[i].takeupTerm) == $F("txtTakeupTerm")){
								deletedSameExists = true;
							}
						}
						
						if(tbgTakeupTerm.geniisysRows[i].recordStatus == 0 || tbgTakeupTerm.geniisysRows[i].recordStatus == 1){								
							if(unescapeHTML2(tbgTakeupTerm.geniisysRows[i].takeupTermDesc) == $F("txtTakeupTermDesc")){
								addedSameExists2 = true;								
							}							
						} else if(tbgTakeupTerm.geniisysRows[i].recordStatus == -1){
							if(unescapeHTML2(tbgTakeupTerm.geniisysRows[i].takeupTermDesc) == $F("txtTakeupTermDesc")){
								deletedSameExists2 = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same takeup_term.", "E");
						return;
					}else if((addedSameExists2 && !deletedSameExists2) || (deletedSameExists2 && addedSameExists2)){
						showMessageBox("Record already exists with the same takeup_term_desc.", "E");
						return;
					} else if((deletedSameExists && !addedSameExists) || (deletedSameExists2 && !addedSameExists2)){
						addRec();
						return;
					}
					
					checkAddRec();
				} else {
					for(var i=0; i<tbgTakeupTerm.geniisysRows.length; i++){
						if(tbgTakeupTerm.geniisysRows[i].recordStatus == 0 || tbgTakeupTerm.geniisysRows[i].recordStatus == 1){								
							if(unescapeHTML2(tbgTakeupTerm.geniisysRows[i].takeupTermDesc) == $F("txtTakeupTermDesc") 
									&& unescapeHTML2(objTakeupTerm.takeupTermDesc) != $F("txtTakeupTermDesc") ){
								addedSameExists2 = true;								
							}							
						} else if(tbgTakeupTerm.geniisysRows[i].recordStatus == -1){
							if(unescapeHTML2(tbgTakeupTerm.geniisysRows[i].takeupTermDesc) == $F("txtTakeupTermDesc") 
									&& unescapeHTML2(objTakeupTerm.takeupTermDesc) != $F("txtTakeupTermDesc") ){
								deletedSameExists2 = true;
							}
						}
					}
					
					if((addedSameExists2 && !deletedSameExists2) || (deletedSameExists2 && addedSameExists2)){
						showMessageBox("Record already exists with the same takeup_term_desc.", "E");
						return;
					} else if((deletedSameExists2 && !addedSameExists2)){
						addRec();
						return;
					}
					
					checkAddRec();					
				}
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}	
	
	function deleteRec(){
		changeTagFunc = saveGiiss211;
		objTakeupTerm.recordStatus = -1;
		tbgTakeupTerm.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISTakeupTermController", {
				parameters : {action : "valDeleteRec",
							  takeupTerm : $F("txtTakeupTerm")},
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
	
	function cancelGiiss211(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS211.exitPage = exitPage;
						saveGiiss211();
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
	
	$("txtTakeupTermDesc").observe("keyup", function(){
		$("txtTakeupTermDesc").value = $F("txtTakeupTermDesc").toUpperCase();
	});
	
	$("txtTakeupTerm").observe("keyup", function(){
		$("txtTakeupTerm").value = $F("txtTakeupTerm").toUpperCase();
	});
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGiiss211);
	$("btnCancel").observe("click", cancelGiiss211);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("takeupTermExit").stopObserving("click");
	$("takeupTermExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	$("txtTakeupTerm").focus();	
</script>