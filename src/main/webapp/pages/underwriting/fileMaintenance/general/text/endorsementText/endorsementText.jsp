<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss104MainDiv" name="giiss104MainDiv" style="">
	<div id="endtTextTableGridDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="menuFileMaintenanceExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Endorsement Text Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>
	<div id="giiss104" name="giiss104">
		<div class="sectionDiv">
			<div id="endtTextTableDiv" style="padding-top: 10px;">
				<div id="endtTextTable" style="height: 340px; margin-left: 10px;"></div>
			</div>
			<div align="center" id="endtTextFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<!-- <td class="rightAligned">Endt ID</td>
						<td class="leftAligned">
							<input id="txtEndtId" type="text" readonly="readonly" style="width: 200px; text-align: right;" tabindex="201" maxlength="12">
						</td> comment out by carlo-->
						<td class="rightAligned">Endt Code</td>
						<td class="leftAligned" colspan="2"><!-- added fields by carlo 01-24-2017 SR 5915  -->
							<input id="txtEndtCd" type="text" class="required" style="width: 200px; text-align: left;" tabindex="202" maxlength="4">
							<input type="checkbox" id="chkActiveTag" name="chkActiveTag" class="required" style="margin-left: 15px; margin-right: 5px;"/>
							<label for="chkActiveTag" style="float: right; margin-top: 4px; margin-right: 25px;">Active Tag</label>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Endt Title</td>
						<td class="leftAligned" colspan="3">
							<input id="txtEndtTitle" type="text" class="required" style="width: 533px; text-align: left;" tabindex="203" maxlength="100">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Endt Text</td>
						<td class="leftAligned" colspan="3">
							<div id="endtTextDiv" name="endtTextDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtEndtText" name="txtEndtText" maxlength="2000"  onkeyup="limitText(this,2000);" tabindex="204"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit Endt Text" id="editEndtText"/>
							</div>
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="205"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned" style="width: 254px;"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="206"></td>
						<td width="" class="rightAligned">Last Update</td>
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
	setModuleId("GIISS104");
	setDocumentTitle("Endorsement Text Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	observeReloadForm("reloadForm", showGiiss104);
	
	var objGIISS104 = {};
	var objCurrEndtText = null;
	objGIISS104.endtTextList = JSON.parse('${jsonEndtTextList}');
	objGIISS104.exitPage = null;
	
	var endtTextTable = {
			url : contextPath + "/GIISEndtTextController?action=showGiiss104&refresh=1",
			options : {
				width : '900px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrEndtText = tbgEndtText.geniisysRows[y];
					setFieldValues(objCurrEndtText);
					tbgEndtText.keys.removeFocus(tbgEndtText.keys._nCurrentFocus, true);
					tbgEndtText.keys.releaseKeys();
					$("txtEndtCd").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgEndtText.keys.removeFocus(tbgEndtText.keys._nCurrentFocus, true);
					tbgEndtText.keys.releaseKeys();
					$("txtEndtCd").focus();
				},
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgEndtText.keys.removeFocus(tbgEndtText.keys._nCurrentFocus, true);
						tbgEndtText.keys.releaseKeys();
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
					tbgEndtText.keys.removeFocus(tbgEndtText.keys._nCurrentFocus, true);
					tbgEndtText.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgEndtText.keys.removeFocus(tbgEndtText.keys._nCurrentFocus, true);
					tbgEndtText.keys.releaseKeys();
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
					tbgEndtText.keys.removeFocus(tbgEndtText.keys._nCurrentFocus, true);
					tbgEndtText.keys.releaseKeys();
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
					id : "endtId",
					title : "Endt ID",
					filterOption : true,
					filterOptionType : "integerNoNegative",
					titleAlign : 'right',
					align : 'right',
					width : '80px'
				},
				{
					id : "endtCd",
					title : "Endt Code",
					filterOption : true,
					width : '80px'
				},
				{
					id : 'endtTitle',
					filterOption : true,
					title : 'Endt Title',
					width : '280px',
					renderer: function(value) {		//added by Gzelle 02062015
						return unescapeHTML2(value);	
					}
				},
				{
					id : 'endtText',
					filterOption : true,
					title : 'Endt Text',
					width : '415px',
					renderer: function(value) {		//added by Gzelle 02062015
						return unescapeHTML2(value);	
					}
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
					visible: false,		
					renderer: function(value) {		//added by Gzelle 02062015
						return unescapeHTML2(value);	
					}
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
			rows : objGIISS104.endtTextList.rows
	};
	tbgEndtText = new MyTableGrid(endtTextTable);
	tbgEndtText.pager = objGIISS104.endtTextList;
	tbgEndtText.render("endtTextTable");
	
	function setFieldValues(rec){
		try{
			//$("txtEndtId").value = (rec == null ? "" : rec.endtId); comment out by carlo
			$("txtEndtCd").value = (rec == null ? "" : unescapeHTML2(rec.endtCd));
			$("txtEndtTitle").value = (rec == null ? "" : unescapeHTML2(rec.endtTitle));
			$("txtEndtText").value = (rec == null ? "" : unescapeHTML2(rec.endtText));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("chkActiveTag").checked = (rec == null ? "" : rec.activeTag == 'A' ? true : false); //carlo 01-26-2017
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			rec == null ? enableInputField("txtEndtCd") : disableInputField("txtEndtCd");
			objCurrEndtText = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}
	
	function cancelGiiss104(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS104.exitPage = exitPage;
						saveGiiss104();
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
	
	$("editEndtText").observe("click", function(){
		showOverlayEditor("txtEndtText", 2000, $("txtEndtText").hasAttribute("readonly"));
	});
	
	$("txtEndtCd").observe("keyup", function(){
		$("txtEndtCd").value = $F("txtEndtCd").toUpperCase();
	});
	
	$("txtEndtTitle").observe("keyup", function(){
		$("txtEndtTitle").value = $F("txtEndtTitle").toUpperCase();
	});
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("endtTextFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;					
					
					for(var i=0; i<tbgEndtText.geniisysRows.length; i++){
						if(tbgEndtText.geniisysRows[i].recordStatus == 0 || tbgEndtText.geniisysRows[i].recordStatus == 1){								
							if(unescapeHTML2(tbgEndtText.geniisysRows[i].endtCd) == unescapeHTML2($F("txtEndtCd"))){
								addedSameExists = true;								
							}							
						} else if(tbgEndtText.geniisysRows[i].recordStatus == -1){
							if(unescapeHTML2(tbgEndtText.geniisysRows[i].endtCd) == unescapeHTML2($F("txtEndtCd"))){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same endt_cd.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					
					new Ajax.Request(contextPath + "/GIISEndtTextController", {
						parameters : {action : "valAddRec",
									  endtCd : $F("txtEndtCd")
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
					addRec();
				}
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGiiss104;
			var endtText = setRec(objCurrEndtText);
			if($F("btnAdd") == "Add"){
				tbgEndtText.addBottomRow(endtText);
			} else {
				tbgEndtText.updateVisibleRowOnly(endtText, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgEndtText.keys.removeFocus(tbgEndtText.keys._nCurrentFocus, true);
			tbgEndtText.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			//obj.endtId = $F("txtEndtId"); comment out by carlo
			obj.endtCd = escapeHTML2($F("txtEndtCd"));
			obj.endtTitle = escapeHTML2($F("txtEndtTitle"));
			obj.endtText = escapeHTML2($F("txtEndtText"));
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
	
	function deleteRec(){
		changeTagFunc = saveGiiss104;
		objCurrEndtText.recordStatus = -1;
		tbgEndtText.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function saveGiiss104(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgEndtText.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgEndtText.geniisysRows);

		new Ajax.Request(contextPath+"/GIISEndtTextController", {
			method: "POST",
			parameters : {action : "saveGiiss104",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS104.exitPage != null) {
							objGIISS104.exitPage();
						} else {
							tbgEndtText._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	//Gzelle 02062015
	function valDelRec(){
		try{
			new Ajax.Request(contextPath + "/GIISEndtTextController", {
				parameters : {action : "valDelRec",
							  endtCd : $F("txtEndtCd")},
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
	
	$("btnCancel").observe("click", cancelGiiss104);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDelRec);	//changed deleteRec to valDelRec Gzelle 02062015
	observeSaveForm("btnSave", saveGiiss104);
	
	$("txtEndtCd").focus();	
	disableButton("btnDelete");
	
	$("menuFileMaintenanceExit").stopObserving("click");
	$("menuFileMaintenanceExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
</script>