<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="miniReminderMainDiv" name="miniReminderMainDiv" style="margin-top: 1px;">
	<div id="miniReminderDiv" name="miniReminderDiv" class="sectionDiv" style="width: 99%; margin-left: 4px; margin-top: 10px; height: 443px;">
		<div id="miniReminderMainTable">
			<div id="miniReminderTable" style="height: 230px; margin-left: 20px; margin-top: 10px;">
			</div>
		</div>
		<div id="miniReminderFieldDiv">
			<table style="padding-top: 5px; margin-left: 114px;">
				<tr>
					<td>
						<input type="radio" id="rdoReminder" name="noteTypeOption" value="Reminder" style="margin-left: 15px; float: left;" checked="checked"/>
						<label for="rdoReminder" style="margin-top: 3px;">Reminder</label>
					</td>
					<td>
						<input type="radio" id="rdoNote" name="noteTypeOption" value="Note" style="margin-left: 15px; float: left; margin-left: 15px;" checked=""/>
						<label for="rdoNote" style="margin-top: 3px;">Note</label>
					</td>
				</tr>
			</table>
			<table align="center" cellspacing="2" border="0" style="margin: 10px auto; margin-left: -11px;">
				<tr>
					<td class="rightAligned" style="padding-right: 5px;">Subject</td>
					<td colspan="3">
						<input type="text" id="txtNoteSubject" name="txtNoteSubject" style="width: 609px; float: left; height: 13px;" tabindex="1" class="required" maxlength="250"></input>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="padding-right: 5px;">Text</td>
					<td colspan="3">
						<div class="withIconDiv" style="float: left; width: 615px">
							<textarea id="txtNoteText" class="withIcon" style="width: 589px; resize:none;" name="txtNoteText" tabindex="2" onkeyup="limitText(this,4000);" onkeydown="limitText(this,4000);"></textarea>
							<img id="editNoteText" alt="edit" style="width: 14px; height: 14px; margin: 3px; float: right;" src="/Geniisys/images/misc/edit.png">
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="padding-right: 5px;">Alarm User / Date</td>
					<td class="leftAligned" style="width: 335px; padding-top: 5px;">
						<span id="alarmUserDiv" class="lovSpan required" style="width: 158px;"><!-- add id ::: SR-19555 : shan 07.07.2015 -->
							<input type="text" id="txtAlarmUser" name="txtAlarmUser" class="required" tabindex="3"  style="width: 130px; float: left; border: none; height: 14px; margin: 0;"/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchAlarmUser" name="searchAlarmUser" alt="Go" style="float: right;"/>
						</span>
						<label style="padding: 5px;"> / </label>
						<span class="lovSpan required" style="width: 143px;">
							<input type="text" id="txtAlarmDate" name="txtAlarmDate" class="required" tabindex="4" style="width: 135px; float: left; border: none; height: 14px; margin: 0;"/>
						</span>
					</td>
					<td class="rightAligned" style="padding-right: 5px; width: 135px;">Acknowledgement Date</td>
					<td style="padding-top: 5px;">
						<input type="text" id="txtAckDate" name="txtAckDate" tabindex="5" style="width: 130px; float: left; height: 13px;" readonly="readonly"></input>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="padding-right: 5px; width: 135px;">User ID</td>
					<td>
						<input type="text" id="txtUserId" name="txtUserId" tabindex="6" style="width: 152px; float: left; height: 13px;" readonly="readonly"></input>
					</td>
					<td class="rightAligned" style="padding-right: 5px; width: 135px;">Last Update</td>
					<td>
						<input type="text" id="txtLastUpdate" name="txtLastUpdate" tabindex="7" style="width: 130px; float: left; height: 13px;" readonly="readonly"></input>
					</td>
				</tr>
				<tr>
					<td colspan="4" style="padding-top: 1px;">
						<input type="checkbox" id="chkRenewFlag" style="margin-left: 142px; float: left; "/>
						<label for="chkRenewFlag">Include in Renewal</label> <!-- changed label from Renew ::: SR-19555 : shan 07.07.2015 -->
					</td>
				</tr>
			</table>
			<table align="center" style="padding-top: 0px;">
				<tbody>
					<tr>
						<td>
							<input id="btnInspection" class="button noChangeTagAttr" type="button" style="display: none; value="Select Inspection" name="btnInspection">
						</td>
						<td>
							<input id="btnAdd" class="button" type="button" style="width: 100px;" value="Add">
						</td>
						<td>
							<input id="btnDelete" class="disabledButton" type="button" style="width: 100px;" value="Delete" name="btnDelete">
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
	<div class="buttonDiv" style="float: left; width: 99%; padding-bottom: 5px; padding-top: 10px; margin-left: 4px;"> 
		<table align="center">
			<tbody>
				<tr>
					<td>
						<input id="btnInspection" class="button noChangeTagAttr" type="button" style="display: none; value="Select Inspection" name="btnInspection">
					</td>
					<td>
						<input id="btnCancel" class="button" type="button" style="width: 120px;" value="Cancel" name="btnCancel">
					</td>
					<td>
						<input id="btnSave" class="button" type="button" style="width: 120px;" value="Save" name="btnSave">
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</div>
<script type="text/javascript">
	var jsonMiniReminder = JSON.parse('${jsonMiniReminder}'.replace(/\\/g, '\\\\'));
	var objMiniReminder = [];
	var row = 0;
	var changeCounter = 0;
	var unsavedStatus;
	var dateToday = ignoreDateTime(new Date());
	var dbTag;
	var popupDir = "${popupDir}";
	var parId = "${parId}";
	var claimId = "${claimId}";
	var user = "${userId}";
	var objRowId = 0;
	var selectedObjRowId;
	var objRowIdIncrement = 0;
	var exitTag = 'N';
	
	miniReminderTableModel = {
			url : contextPath + "/GIPIReminderController?action=showMiniReminder&refresh=1&parId=" + parId
					+ "&claimId=" + claimId, //apollo cruz 08.04.2015 - SR#19923 - added parId and claimId in the url to navigate records properly
			options : {
				width : '750px',
				pager : {},
				onCellFocus : function(element, value, x, y, id) {
					row = y;
					tbgMiniReminder.keys.removeFocus(tbgMiniReminder.keys._nCurrentFocus, true);
					tbgMiniReminder.keys.releaseKeys();
					setDetailsForm(tbgMiniReminder.geniisysRows[y]);
				},
				prePager : function() {
					if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
            		} else {
            			setDetailsForm(null);	
           			}
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					tbgMiniReminder.keys.removeFocus(tbgMiniReminder.keys._nCurrentFocus, true);
					tbgMiniReminder.keys.releaseKeys();
					setDetailsForm(null);
				},
				onSort : function() {
					tbgMiniReminder.keys.removeFocus(tbgMiniReminder.keys._nCurrentFocus, true);
					tbgMiniReminder.keys.releaseKeys();
					setDetailsForm(null);
				}, 
				beforeSort: function(){
					if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
            		} else {
            			setDetailsForm(null);
           			}				
        		},
        		onRefresh: function(){
        			if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
            		} else {
            			setDetailsForm(null);
           			}
				},
				onRowDoubleClick: function() {
					if(dbTag == "Y"){
						showEditor("txtNoteText", 4000, "true");
					} else if (dbTag == "N"){
						showEditor("txtNoteText", 4000);
					}
				},
				checkChanges: function(){ // apollo 08.10.2015 - SR#19923 - prevents user to navigate in the tablegrid if changes were made.
					return (changeTag == 1 ? true : false);
				},
			},
			columnModel : [ {
				id : 'recordStatus',
				title : '',
				width : '0',
				visible : false
			}, {
				id : 'divCtrId',
				width : '0',
				visible : false
			}, { 
				id: 'tbgAlarmFlag',
				title: 'Ok?',
				width: '30px',
				tooltip: 'Alarm Flag',
				align: 'center',
				titleAlign: 'center',
				editable: false,
				editor:	 'checkbox',
				sortable: false
			}, { 
				id: 'tbgRenewFlag',
				title: 'R?',
				width: '30px',
				tooltip: 'Renew Flag',
				align: 'center',
				titleAlign: 'center',
				editable: false,
				editor:	 'checkbox',
				sortable: false,
				defaultValue: false,	//SR-19555 : shan 07.07.2015
				otherValue: false	//SR-19555 : shan 07.07.2015
			} , { 
				id: 'noteType',
				title: 'R',
				width: '30px',
				tooltip: 'Note Type',
				align: 'center',
				titleAlign: 'center',
				editable: false,
				radioGroup: 'noteTypeGroup',
				editor: new MyTableGrid.CellRadioButton({
			        getValueOf: function(value){
			        	if (value){
							return "R";
		            	}
			        }
		    	}),
				sortable: false
			},  { 
				id: 'noteType',
				title: 'N',
				width: '30px',
				tooltip: 'Note Type',
				align: 'center',
				titleAlign: 'center',
				editable: false,
				radioGroup: 'noteTypeGroup',
				editor: new MyTableGrid.CellRadioButton({
			        getValueOf: function(value){
			        	if (value){
							return "N";
		            	}
			        }
		    	}),
				sortable: false
			}, {
				id: 'noteSubject',
				title: 'Subject',
				width: '270px',
				visible: true,
				sortable: false
			}, {
				id: 'noteText',
				title: 'Text',
				width: '342px',
				visible: true,
				sortable: false
			} , {
				id: 'alarmUser',
				title: '',
				width: '0',
				visible: false,
			}, {
				id: 'alarmDate',
				title: '',
				width: '0',
				visible: false,
			}, {
				id: 'dbTag',
				title: '',
				width: '0',
				visible: false,
			}, {
				id: 'objRowId',
				title: '',
				width: '0',
				visible: false,
			}],
			rows : jsonMiniReminder.rows
		};
	
	tbgMiniReminder = new MyTableGrid(miniReminderTableModel);
	tbgMiniReminder.pager = jsonMiniReminder;
	tbgMiniReminder.render('miniReminderTable');
	
	function setDetailsForm(rec){
		$("txtNoteSubject").value = rec == null ? "" : unescapeHTML2(rec.noteSubject);
		$("txtNoteText").value = rec == null ? "" : unescapeHTML2(rec.noteText);
		$("txtAlarmUser").value = rec == null ? "" : unescapeHTML2(rec.alarmUser);
		$("txtAlarmDate").value = rec == null ? "" : rec.alarmDate == null ? "" : dateFormat(rec.alarmDate, "mm-dd-yyyy");
		$("txtAckDate").value = rec == null ? "" : rec.ackDate == null ? "" : dateFormat(rec.ackDate, "mm-dd-yyyy");
		$("txtUserId").value = rec == null ? "" : unescapeHTML2(rec.userId);
		$("txtLastUpdate").value = rec == null ? "" : rec.lastUpdate == null ? "" : rec.lastUpdate;
		$("chkRenewFlag").checked = rec == null ? false : rec.renewFlag == "Y" ? true : false;
		dbTag = rec == null ? "" : rec.dbTag == null ? "" : rec.dbTag;
		$("rdoReminder").checked = rec == null ? false : rec.noteType == "R" ? true : false;
		$("rdoNote").checked = rec == null ? false : rec.noteType == "N" ? true : false;
		objRowId = rec == null ? 99999 : rec.objRowId == null ? 99999 : rec.objRowId;
		
		if(dbTag == "Y"){
			forUpdate("N");
			selectObjRowId = 0;
		} else if (dbTag == "N"){
			forUpdate("Y");
			selectedObjRowId = objRowId;
		}
		
		if(rec == null){
			forUpdate("N");
		}
		
		if($("rdoReminder").checked == false && $("rdoNote").checked == false){
			$("rdoReminder").checked = true;
		}
	}
	
	$("btnAdd").observe("click", function(){
		if(dbTag != "Y"){
			addUpdateReminder();	
		}
	});
	
	function addUpdateReminder(){
		if($("rdoReminder").checked){
			if($F("txtAlarmUser") == "" || $F("txtAlarmDate") == ""){
				customShowMessageBox("Alarm User/Date are required fields.", imgMessage.INFO, "txtAlarmUser");
				return false;
			}
		}
		
		if($F("txtNoteSubject") == ""){
			customShowMessageBox("Required Fields must be entered.", imgMessage.INFO, "txtNoteSubject");
			return false;
		}
		
		rowObj = setReminderObj($("btnAdd").value);
		
		if ($F("btnAdd") != "Add") {
			objMiniReminder.splice(selectedObjRowId, 1, rowObj);
			tbgMiniReminder.updateVisibleRowOnly(rowObj, row);
			tbgMiniReminder.onRemoveRowFocus();
			setDetailsForm(null);
			changeTag = 1;
			changeCounter++;
		} else {
			unsavedStatus = 1;
			objMiniReminder.push(rowObj);
			tbgMiniReminder.addBottomRow(rowObj);
			tbgMiniReminder.onRemoveRowFocus();
			setDetailsForm(null);
			changeTag = 1;
			changeCounter++;
		}
	}
	
	$("btnDelete").observe("click", function(){
		deleteReminder();
	});
	
	function deleteReminder(){
		delObj = setReminderObj($("btnDelete").value);
		showConfirmBox("Confirm", "Do you really want to delete this record?", "Yes", "No",
			    function(){
					objMiniReminder.splice(row, 1, delObj);
					tbgMiniReminder.deleteVisibleRowOnly(row);
					tbgMiniReminder.onRemoveRowFocus();
					if(changeCounter == 1 && unsavedStatus == 1){
						changeTag = 0;
						changeCounter = 0;
					}else{
						changeCounter++;
						changeTag=1;
					}
				},
				function(){
					null;
				});
	}
	
	function setReminderObj(func){
		var setObjReminder = new Object();
		setObjReminder.noteType         =  $("rdoReminder").checked ? "R" : "N";
		setObjReminder.noteSubject      =  escapeHTML2($("txtNoteSubject").value);
		setObjReminder.noteText 	    =  escapeHTML2($("txtNoteText").value);
		setObjReminder.alarmUser 	    =  escapeHTML2($("txtAlarmUser").value);
		setObjReminder.alarmDate        =  $("txtAlarmDate").value;
		setObjReminder.dbTag            =  "N";
		setObjReminder.renewFlag        =  $("chkRenewFlag").checked ? "Y" : "N";
		setObjReminder.parId            =  parId;
		setObjReminder.claimId          =  claimId;
		setObjReminder.objRowId         =  objRowIdIncrement;
		setObjReminder.recordStatus     =  func == "Delete" ? -1 : func == "Add" ? 0 : 1;
		setObjReminder.tbgRenewFlag     =  $("chkRenewFlag").checked;	// SR-19555 : shan 07.07.2015
		objRowIdIncrement++;
		return setObjReminder;
	}
	
	$("btnSave").observe("click", function(){
		validateSaveReminder();
	});
	
	function validateSaveReminder(){
		if(changeTag == 0){
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
		}else{
			saveReminder();	
		}
	}
	
	function saveReminder(){
		var objParams = new Object();
		objParams.setRows = getAddedAndModifiedJSONObjects(/*objMiniReminder*/ tbgMiniReminder.geniisysRows);	// SR-19555 : shan 07.07.2015
		new Ajax.Request(contextPath+"/GIPIReminderController?action=saveReminder",{
			method: "POST",
			parameters:{
				parameters : JSON.stringify(objParams)
			},
			onCreate: function(){
				showNotice("Saving Reminder, please wait...");
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				hideNotice();
				changeTag = 0;
				changeCounter = 0;
				unsavedStatus = 0;
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response) ){
					if(exitTag == "Y"){
						showWaitingMessageBox(objCommonMessage.SUCCESS, "S", function(){
							exit();
						});						
					} else {
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, reloadTBG);
						$("geniisysAppletUtil").sendMessage(popupDir, $F("txtAlarmUser"), user + "assigned a new reminder - " + $F("txtNoteSubject") + ".");
					}
				}	
			}
		});
	}
	
	function reloadTBG(){
		overlayMiniReminder.close();
		delete overlayMiniReminder;
		
		try {
			overlayMiniReminder = 
				Overlay.show(contextPath+"/GIPIReminderController", {
					urlContent: true,
					urlParameters: {action    : "showMiniReminder",																
									parId     : parId,
									claimId   : claimId
					},
				    title: "Mini Reminder",
				    height: 500,
				    width: 800,
				    draggable: true
				});
		} catch (e) {
			showErrorMessage("Mini Reminder Error :" , e);
		}
	}
	
	function forUpdate(option){
		if (option == "Y") {
			$("btnAdd").value = "Update";
			enableButton("btnDelete");
		} else if(option == "N"){
			$("btnAdd").value = "Add";
			disableButton("btnDelete");
		}
		
		observeMainFields();
	}
	
	$("txtAlarmUser").observe("blur", function(){
		validateAlarmUser();
	});
	
	function validateAlarmUser(){
		new Ajax.Request(contextPath+"/GIPIReminderController?action=validateAlarmUser", {
			method: "GET",
			parameters: { 
					alarmUser : $F("txtAlarmUser")
				},
			asynchronous: true,
			evalScripts: true,
			onComplete: function(response) {
				if (checkErrorOnResponse(response)){
					var res = JSON.parse(response.responseText);
					if(res.count == "0"){
						getAlarmUserLOV();
					} else {
						$("txtAlarmUser").value = res.userId;
					}
				}
			}
		});
	}
	
	$("searchAlarmUser").observe("click", function(){
		if($("rdoReminder").checked){
			getAlarmUserLOV();	
		}
	});
	
	function getAlarmUserLOV(){
		LOV.show({
			controller: 'UnderwritingLOVController',
			urlParameters: {
				action:		"getAlarmUserLOV",
				alarmUser:  $F("txtAlarmUser")
			},
			title: "Valid Values for Alarm Users",
			width: 405,
			height: 386,
			draggable: true,
			columnModel: [
				{
					id: "userId",
					title: "User Id",
					width: "100px"
				},
				{
					id: "userName",
					title: "User Name",
					width: "290px"
				}
			],
			onSelect: function(row){
				if(row != undefined){
					$("txtAlarmUser").value = row.userId;
				}
			}
		});
	}
	
	$("editNoteText").observe("click", function (){
		if(dbTag == "Y"){
			showEditor("txtNoteText", 4000, "true");
		} else {
			showEditor("txtNoteText", 4000);
		}
	});
	
	$("txtAlarmDate").observe("blur", function(){
		if($F("txtAlarmDate") != "" && validateDateFormat($F("txtAlarmDate"), "txtAlarmDate")){
			if(Date.parse($F("txtAlarmDate"), "mm-dd-yyyy") < dateToday){
				customShowMessageBox("Alarm Date should be equal to or greater than the current date.", imgMessage.INFO, "txtAlarmDate");
				$("txtAlarmDate").value = dateFormat(dateToday, "mm-dd-yyyy");
			}
		}
	});
	
	function validateDateFormat(strValue, elemName){
		var text = strValue; 
		var comp = text.split('-');
		var m = parseInt(comp[0], 10);
		var d = parseInt(comp[1], 10);
		var y = parseInt(comp[2], 10);
		var status = true;
		var isMatch = text.match(/^(\d{1,2})-(\d{1,2})-(\d{4})$/);
		var date = new Date(y,m-1,d);
		
		if(isNaN(y) || isNaN(m) || isNaN(d) || y.toString().length < 4 || !isMatch ){
			customShowMessageBox("Date must be entered in a format like MM-DD-RRRR.", imgMessage.INFO, elemName);
			status = false;
		}
		if(0 >= m || 13 <= m){
			customShowMessageBox("Month must be between 1 and 12.", imgMessage.INFO, elemName);	
			status = false; 
		}
		if(date.getDate() != d){				
			customShowMessageBox("Day must be between 1 and the last of the month.", imgMessage.INFO, elemName);	
			status = false;
		}
		if(!status){
			$(elemName).value = "";
		}
		return status;
	}
	
	function initializeGIUTS034radio(){
		if(dbTag == "Y"){
			$("chkRenewFlag").disabled = true;
			$("txtNoteSubject").disabled = true;
			$("txtNoteText").disabled = true;
			$("txtAlarmUser").disabled = true;
			$("txtAlarmDate").disabled = true;
		} else {
			if($("rdoNote").checked){
				$("txtAlarmUser").disabled = true;
				$("txtAlarmDate").disabled = true;
				$("txtAlarmUser").clear();
				$("txtAlarmDate").clear();
				// start SR-19555 : shan 07.07.2015
				$("txtAlarmDate").removeClassName("required");
				$("txtAlarmUser").removeClassName("required");
				$("alarmUserDiv").removeClassName("required");
				disableSearch("searchAlarmUser");
				// end SR-19555 : shan 07.07.2015
			} else if($("rdoReminder").checked){
				$("txtAlarmUser").disabled = false;
				$("txtAlarmDate").disabled = false;
				// start SR-19555 : shan 07.07.2015
				$("txtAlarmDate").addClassName("required");
				$("txtAlarmUser").addClassName("required");
				$("alarmUserDiv").addClassName("required");
				enableSearch("searchAlarmUser");
				// end SR-19555 : shan 07.07.2015
			}	
		}
	}
	
	function observeMainFields(){
		if(dbTag == "Y"){
			$("chkRenewFlag").disabled = true;
			$("txtNoteSubject").disabled = true;
			$("txtNoteText").disabled = true;
			$("txtAlarmUser").disabled = true;
			$("txtAlarmDate").disabled = true;
		} else{
			$("chkRenewFlag").disabled = false;
			$("txtNoteSubject").disabled = false;
			$("txtNoteText").disabled = false;
			$("txtAlarmUser").disabled = false;
			$("txtAlarmDate").disabled = false;
			$("txtNoteSubject").focus();
		}
	}
	
	$$("input[name='noteTypeOption']").each(function(radio){
		radio.observe("click", function(){
			initializeGIUTS034radio();
		});
	});
	
	$("txtNoteSubject").focus();
	$("rdoReminder").checked = true;
	$("btnCancel").observe("click", function(){
		if(changeTag == 1) {
			exitTag = 'Y';
			showConfirmBox4("Confirm", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", saveReminder, exit, "");
		} else {
			exit();
		}
	});
	
	function exit(){
		overlayMiniReminder.close();
		delete overlayMiniReminder;
	}
	
	function checkUserAccess(){
		try{
			new Ajax.Request(contextPath+"/GIACAccTransController?action=checkUserAccess2", {
				method: "POST",
				parameters: {
					moduleName: "GIUTS034"
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(response.responseText == 0){
						showWaitingMessageBox('You are not allowed to access this module.', imgMessage.ERROR, 
						function(){
							overlayMiniReminder.close();
							delete overlayMiniReminder;
						});  
					}
				}
			});
		}catch(e){
			showErrorMessage('checkUserAccess', e);
		}
	}
	
	changeTag = 0;
	initializeAll();
	initializeGIUTS034radio();
	observeMainFields();
	checkUserAccess();
</script>