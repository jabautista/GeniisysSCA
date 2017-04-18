<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss212MainDiv" name="giiss212MainDiv" style="">
	<div id="giiss212Div">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="giiss212Exit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Reason for Spoilage Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss212" name="giiss212">		
		<div class="sectionDiv">
			<div id="giisSpoilageReasonTableDiv" style="padding-top: 10px;">
				<div id="giisSpoilageReasonTable" style="height: 340px; margin-left: 115px;"></div>
			</div>
			<div align="center" id="giisSpoilageReasonFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Spoilage Code</td>
						<td class="leftAligned" colspan="2">
							<input id="txtSpoilCd" type="text" class="required" style="width: 200px;" tabindex="101" maxlength="4">
						</td>
						<td class="rightAligned"><!-- added by carlo 01-24-2017 SR 5915 -->
							<input type="checkbox" id="chkActiveTag" name="chkActiveTag" class="required" style="margin-right: 5px;"/><label for="chkActiveTag" style="float: right;">Active Tag</label>
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Spoilage Description</td>
						<td class="leftAligned" colspan="3">
							<input id="txtSpoilDesc" type="text" class="required" style="width: 533px;" tabindex="102" maxlength="100">
						</td>
					</tr>				
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="103"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="104"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="105"></td>
						<td width="" class="rightAligned" style="padding-left: 47px">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="106"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;" align = "center">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="107">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="108">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="109">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="110">
</div>
<script type="text/javascript">	
	setModuleId("GIISS212");
	setDocumentTitle("Reason for Spoilage Maintenance");
	initializeAll();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiiss212(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgGIISSpoilageReason.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgGIISSpoilageReason.geniisysRows);
		new Ajax.Request(contextPath+"/GIISSpoilageReasonController", {
			method: "POST",
			parameters : {action : "saveGiiss212",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS212.exitPage != null) {
							objGIISS212.exitPage();
						} else {
							tbgGIISSpoilageReason._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss212);
	
	var objGIISS212 = {};
	var objCurrGIISSpoilageReason = null;
	objGIISS212.giisSpoilageReasonList = JSON.parse('${jsonGIISSpoilageReason}');
	objGIISS212.exitPage = null;
	
	var giisSpoilageReasonTable = {
			url : contextPath + "/GIISSpoilageReasonController?action=showGiiss212&refresh=1",
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrGIISSpoilageReason = tbgGIISSpoilageReason.geniisysRows[y];
					setFieldValues(objCurrGIISSpoilageReason);
					tbgGIISSpoilageReason.keys.removeFocus(tbgGIISSpoilageReason.keys._nCurrentFocus, true);
					tbgGIISSpoilageReason.keys.releaseKeys();
					$("txtSpoilDesc").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgGIISSpoilageReason.keys.removeFocus(tbgGIISSpoilageReason.keys._nCurrentFocus, true);
					tbgGIISSpoilageReason.keys.releaseKeys();
					$("txtSpoilCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgGIISSpoilageReason.keys.removeFocus(tbgGIISSpoilageReason.keys._nCurrentFocus, true);
						tbgGIISSpoilageReason.keys.releaseKeys();
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
					tbgGIISSpoilageReason.keys.removeFocus(tbgGIISSpoilageReason.keys._nCurrentFocus, true);
					tbgGIISSpoilageReason.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgGIISSpoilageReason.keys.removeFocus(tbgGIISSpoilageReason.keys._nCurrentFocus, true);
					tbgGIISSpoilageReason.keys.releaseKeys();
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
					tbgGIISSpoilageReason.keys.removeFocus(tbgGIISSpoilageReason.keys._nCurrentFocus, true);
					tbgGIISSpoilageReason.keys.releaseKeys();
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
					id : "spoilCd",
					title : "Spoilage Code",
					filterOption : true,
					width : '150px'
				},
				{
					id : 'spoilDesc',
					title : 'Spoilage Description',
					filterOption : true,
					width : '500px'				
				},
				{	id: 'activeTag', //added by carlo
					title: 'A',
					altTitle: 'Active Tag',
					titleAlign: 'center',
					width: '32px',
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
			rows : objGIISS212.giisSpoilageReasonList.rows
		};

		tbgGIISSpoilageReason = new MyTableGrid(giisSpoilageReasonTable);
		tbgGIISSpoilageReason.pager = objGIISS212.giisSpoilageReasonList;
		tbgGIISSpoilageReason.render("giisSpoilageReasonTable");
	
	function setFieldValues(rec){
		try{
			$("txtSpoilCd").value = (rec == null ? "" : unescapeHTML2(rec.spoilCd));
			$("txtSpoilCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.spoilCd)));
			$("txtSpoilDesc").value = (rec == null ? "" : unescapeHTML2(rec.spoilDesc));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("chkActiveTag").checked = (rec == null ? "" : rec.activeTag == 'A' ? true : false); //carlo 01-26-2017
			
			rec != null && rec.exist == "Y" ? $("txtSpoilDesc").readOnly = true : $("txtSpoilDesc").readOnly = false;
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtSpoilCd").readOnly = false : $("txtSpoilCd").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrGIISSpoilageReason = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.spoilCd = escapeHTML2($F("txtSpoilCd"));
			obj.spoilDesc = escapeHTML2($F("txtSpoilDesc"));
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			obj.activeTag = $("chkActiveTag").checked ? "A" : "I"; //carlo 01-26-2017
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGiiss212;
			var dept = setRec(objCurrGIISSpoilageReason);
			if($F("btnAdd") == "Add"){
				tbgGIISSpoilageReason.addBottomRow(dept);
			} else {
				tbgGIISSpoilageReason.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgGIISSpoilageReason.keys.removeFocus(tbgGIISSpoilageReason.keys._nCurrentFocus, true);
			tbgGIISSpoilageReason.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("giisSpoilageReasonFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;					
					
					for(var i=0; i<tbgGIISSpoilageReason.geniisysRows.length; i++){
						if(tbgGIISSpoilageReason.geniisysRows[i].recordStatus == 0 || tbgGIISSpoilageReason.geniisysRows[i].recordStatus == 1){								
							if(unescapeHTML2(tbgGIISSpoilageReason.geniisysRows[i].spoilCd) == $F("txtSpoilCd")){
								addedSameExists = true;								
							}							
						} else if(tbgGIISSpoilageReason.geniisysRows[i].recordStatus == -1){
							if(unescapeHTML2(tbgGIISSpoilageReason.geniisysRows[i].spoilCd) == $F("txtSpoilCd")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same spoil_cd.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GIISSpoilageReasonController", {
						parameters : {action : "valAddRec",
									  spoilCd : $F("txtSpoilCd")},
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
		changeTagFunc = saveGiiss212;
		objCurrGIISSpoilageReason.recordStatus = -1;
		tbgGIISSpoilageReason.deleteRow(rowIndex);
		tbgGIISSpoilageReason.geniisysRows[rowIndex].spoilCd = escapeHTML2($F("txtSpoilCd"));
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISSpoilageReasonController", {
				parameters : {action : "valDeleteRec",
							  spoilCd : $F("txtSpoilCd")},
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
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", "");	
	}	
	
	function cancelGiiss212(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS212.exitPage = exitPage;
						saveGiiss212();
					}, function(){
						goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", "");	
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", "");	
		}
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	/* $("txtSpoilDesc").observe("keyup", function(){
		$("txtSpoilDesc").value = $F("txtSpoilDesc").toUpperCase();
	}); */
	
	$("txtSpoilCd").observe("keyup", function(){
		$("txtSpoilCd").value = $F("txtSpoilCd").toUpperCase();
	});
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGiiss212);
	$("btnCancel").observe("click", cancelGiiss212);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("giiss212Exit").stopObserving("click");
	$("giiss212Exit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtSpoilCd").focus();	
</script>