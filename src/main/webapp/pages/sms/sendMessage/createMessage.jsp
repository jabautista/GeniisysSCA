<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="mainNav" name="mainNav">
	<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
		<ul>
			<li><a id="btnExit" name="btnExit">Exit</a></li>
		</ul>
	</div>
</div>

<div id="createdMessagesMainDiv" name="createdMessagesMainDiv">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Messages</label>
			<span class="refreshers" style="margin-top: 0;">
				<label name="gro" style="margin-left: 5px;">Hide</label>
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
		</div>
	</div>
	
	<div id="createdMessagesDiv" class="sectionDiv" style="margin-bottom: 1px;">
		<div id="createdMessagesTGDiv" name="createdMessagesTGDiv" style="height: 321px; width: 720px; margin: 12px 0 20px 16px;"></div>
		
		<div style="width: 775px; float: left; margin: 0 0 0 15px;">
			<table style="margin-top: 8px;">
				<tr>
					<td class="rightAligned" style="vertical-align: top;">Message</td>
					<td colspan="3">
						<textarea id="message" name="message" class="required" type="text" style="height: 60px; width: 650px;" maxlength="320" tabindex="101"></textarea>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Send Message On</td>
					<td>
						<div class="required" style="float:left; border: solid 1px gray; width: 210px; height: 21px;">
				    		<input id="setDate" name="setDate" class="required" type="text" style="height: 13px; width: 186px; border: none; float: left;" readonly="readonly" tabindex="102"/>
				    		<img name="hrefSetDate" id="hrefSetDate" style="margin-top: 2px;" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Set Date" onClick="scwShow($('setDate'),this, null);"/>
						</div>
					</td>
					<td class="rightAligned" style="width: 218px;">Time</td>
					<td class="rightAligned">
						<input id="setTime" name="setTime" class="required" type="text" style="height: 13px; width: 210px;" tabindex="103"/>
					</td>
				</tr>
				<tr>
					<td></td>
					<td colspan="3">
						<div style="float: left;">
							<input id="bdayMsg" name="bdayMsg" type="checkbox" tabindex="106" style="float: left; margin: 4px 3px 0 0;" tabindex="104">
							<label for="bdayMsg" style="float: left; padding-top: 4px; margin-right: 94px;">Birthday Message</label>
							
							<label style="padding-top: 4px; margin-right: 3px;">From</label>
							<div id="fromDateDiv" style="float:left; border: solid 1px gray; width: 160px; height: 21px; margin-right: 18px;">
					    		<input id="fromDate" name="fromDate" type="text" style="height: 13px; width: 136px; border: none; float: left;" readonly="readonly" tabindex="105"/>
					    		<img name="hrefFromDate" id="hrefFromDate" style="margin-top: 2px;" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" onClick="scwShow($('fromDate'),this, null);"/>
							</div>
							
							<label style="padding-top: 4px; margin-right: 3px;">To</label>
							<div id="toDateDiv" style="float:left; border: solid 1px gray; width: 216px; height: 21px;">
				    			<input id="toDate" name="toDate" type="text" style="height: 13px; width: 191px; border: none; float: left;" readonly="readonly" tabindex="106"/>
				    			<img name="hrefToDate" id="hrefToDate" style="margin-top: 2px;" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To Date" onClick="scwShow($('toDate'),this, null);"/>
							</div>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Remarks</td>
					<td colspan="3">
						<div style="border: 1px solid gray; height: 20px; width: 656px;">
							<textarea id="remarks" name="remarks" style="width: 626px; border: none; height: 13px; margin: 0px; resize: none;" maxlength="4000" tabindex="107"/></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">User Id</td>
					<td>
						<input id="userId" name="userId" type="text" style="height: 13px; width: 203px; float: left;" readonly="readonly" tabindex="108">
					</td>
					<td class="rightAligned">Last Update</td>
					<td class="rightAligned">
						<input id="lastUpdate" name="lastUpdate" type="text" style="height: 13px; width: 210px;" readonly="readonly" tabindex="109">
					</td>
				</tr>
			</table>
		</div>
		
		<div style="float: left; margin: 10px 0 0 10px;">
			<table>
				<tr>
					<td>
						<input id="chkDefault" name="chkDefault" type="checkbox" tabindex="110" style="margin: 0 4px 5px 0; float: left;" checked="checked">
						<label for="chkDefault">Default</label>
					</td>
				</tr>
				<tr>
					<td>
						<input id="chkGlobe" name="chkGlobe" type="checkbox" tabindex="110" style="margin: 0 4px 5px 0; float: left;" checked="checked">
						<label for="chkGlobe">Globe</label>
					</td>
				</tr>
				<tr>
					<td>
						<input id="chkSmart" name="chkSmart" type="checkbox" tabindex="110" style="margin: 0 4px 5px 0; float: left;" checked="checked">
						<label for="chkSmart">Smart</label>
					</td>
				</tr>
				<tr>
					<td>
						<input id="chkSun" name="chkSun" type="checkbox" tabindex="110" style="margin: 0 4px 5px 0; float: left;" checked="checked">
						<label for="chkSun">Sun</label>
					</td>
				</tr>
			</table>
		</div>
		
		<div style="width: 120px; float: left; margin: 10px 0 0 10px;">
			<fieldset style="width: 85px;">
				<legend style="font-weight: bold;">Priority</legend>
				<table>
					<tr>
						<td>
							<input id="high" name="priorityRG" type="radio" tabindex="111" style="float: left;" checked="checked">
							<label for="high">High</label>
						</td>
					</tr>
					<tr>
						<td>
							<input id="medium" name="priorityRG" type="radio" tabindex="111" style="float: left;">
							<label for="medium">Medium</label>
						</td>
					</tr>
					<tr>
						<td>
							<input id="low" name="priorityRG" type="radio" tabindex="111" style="float: left;">
							<label for="low">Low</label>
						</td>
					</tr>
				</table>
			</fieldset>
		</div>
		
		<div id="buttonsDiv" name="buttonsDiv" align="right" style="float: left; width: 64.5%; margin: 15px 0 15px 0;">
			<input id="btnAddMsg" type="button" class="button" value="Add" style="width: 80px; margin-left: 230px;" tabindex="112">
			<input id="btnDelMsg" type="button" class="disabledButton" value="Delete" style="width: 80px; margin-right: 50px;" tabindex="113">
		</div>
		
		<div id="buttonsDiv" name="buttonsDiv" align="right" style="width: 33.5%; float: left; margin: 15px 0 0 0;">
			<input id="btnCancelMsg" type="button" class="disabledButton" value="Cancel Message Sending" style="width: 180px;" tabindex="114">
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Send Message To</label>
			<span class="refreshers" style="margin-top: 0;">
				<label name="gro" style="margin-left: 5px;">Hide</label>
			</span>
		</div>
	</div>
	
	<div id="messageDtlDiv" class="sectionDiv" style="height: 491px;">
		<div id="messageDtlTGDiv" name="messageDtlTGDiv" style="height: 321px; width: 720px; margin: 12px 0 20px 16px;"></div>
		<div id="createdMessageDtlDiv" align="center" style="width: 100%;">
			<table>
				<tr>
					<td class="rightAligned">User Group</td>
					<td>
						<span class="required lovSpan" style="width: 200px;">
							<input id="groupCd" name="groupCd" type="hidden" lastValidValue="">
							<input id="groupName" name="groupName" class="required upper" type="text" style="float: left; margin-top: 0px; margin-right: 3px; height: 13px; width: 170px; border: none;" maxlength="50" lastValidValue="" tabindex="201"/>
							<img id="searchGroupName" alt="Go" style="height: 18px; margin-top: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png"/>
						</span>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Recipient Name</td>
					<td>
						<span class="required lovSpan" style="width: 550px;">
							<input id="pkColumnValue" name="pkColumnValue" type="hidden">
							<input id="recipientName" name="recipientName" class="required upper" type="text" style="float: left; margin-top: 0px; margin-right: 3px; height: 13px; width: 520px; border: none;" maxlength="240" tabindex="202"/>
							<img id="searchRecipient" alt="Go" style="height: 18px; margin-top: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png"/>
						</span>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Cellphone No</td>
					<td>
						<input id="cellphoneNo" name="cellphoneNo" class="required" type="text" style="height: 13px; width: 195px;" maxlength="40" tabindex="203"/>
					</td>
				</tr>
			</table>
		</div>
		
		<div id="buttonsDiv" name="buttonsDiv" align="center" style="float: left; width: 100%; margin: 15px 0 15px 0;">
			<input id="btnAddDtl" type="button" class="button" value="Add" style="width: 80px;" tabindex="204">
			<input id="btnDelDtl" type="button" class="disabledButton" value="Delete" style="width: 80px;" tabindex="205">
		</div>
	</div>
	
	<div align="center" style="float: left; width: 100%; margin: 10px 0 25px 0;">
		<input id="btnCancel" type="button" class="button" value="Cancel" style="width: 80px;" tabindex="301">
		<input id="btnSave" type="button" class="button" value="Save" style="width: 80px;" tabindex="302">
	</div>
</div>

<script type="text/javascript">
	var sysdate = dateFormat(new Date(), 'mm-dd-yyyy');
	objMsg = {};
	objMsg.msgTableGrid = JSON.parse('${messageJSON}');
	objMsg.msgRows = objMsg.msgTableGrid.rows || [];
	objMsg.selectedRow = null;
	objMsg.selectedDtlRow = null;
	objMsg.selectedIndex = -1;
	objMsg.selectedDtlIndex = -1;
	changeTag = 0;
	
	try{
		var messagesTableModel = {
			url: contextPath+"/GISMMessagesSentController?action=showCreateSendMessages&refresh=1",
			options: {
				id : 1,
	          	height: '306px',
	          	width: '890px',
	          	masterDetail: true,
	          	masterDetailRequireSaving: true,
	          	onCellFocus: function(element, value, x, y, id){
	          		if(hasPendingMsgChildRecords()){
	          			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
							saveMessages,
							function(){
	          					onMsgCellFocus(y);
          					},
          					function(){
          						onMsgCellFocus(y);
          					});	
	          		}else{
	          			onMsgCellFocus(y);
	          		}
	            },
	            onRemoveRowFocus: function(){
	          		if(hasPendingMsgChildRecords()){
	          			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
							saveMessages,
							function(){
	          					onMsgRemoveFocus();
          					},
          					function(){
          						onMsgRemoveFocus();
          					});
	          		}else{
	          			onMsgRemoveFocus();
	          		}
	            },
	            beforeSort: function(){
	            	if(changeTag == 1){
	            		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
	            		return false;
	            	}
	            },
	            onSort: function(){
	            	messageTG.onRemoveRowFocus();
	            },
	            prePager: function(){
	            	if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
	            	}
	            },
	            postPager: function(){
	            	messageTG.onRemoveRowFocus();
	            },
	            checkChanges: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailValidation: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailNoFunc: function(){
					return (changeTag == 1 ? true : false);
				},
	            toolbar: {
	            	elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
	            	onRefresh: function(){
	            		messageTG.onRemoveRowFocus();
	            	},
	            	onFilter: function(){
	            		messageTG.onRemoveRowFocus();
	            	}
	            }
			},
			columnModel:[
						{   id: 'recordStatus',
						    width: '0px',
						    visible: false,
						    editor: 'checkbox'
						},
						{	id: 'divCtrId',
							width: '0px',
							visible: false
						},
						{	id: 'message',
							title: 'Message',
							width: '610px',
							filterOption: true
						},
						{	id: 'schedDate',
							title: 'Send Message On',
							width: '175px',
							filterOption: true,
							filterOptionType: 'formattedDate'
						},
						{	id: 'priorityDesc',
							title: 'Priority',
							width: '75px',
							filterOption: true
						}
						],
			rows: objMsg.msgRows
		};
		messageTG = new MyTableGrid(messagesTableModel);
		messageTG.pager = objMsg.msgTableGrid;
		messageTG._mtgId = 1;
		messageTG.render('createdMessagesTGDiv');
		messageTG.afterRender = function(){
			changeTag = 0;
			objMsg.messages = messageTG.geniisysRows;
		};
	}catch(e){
		showMessageBox("Error in Messages Table Grid: " + e, imgMessage.ERROR);
	}
	
	try{
		var msgDetailTableModel = {
			options: {
				id : 2,
	          	height: '306px',
	          	width: '890px',
	          	masterDetail: true,
	          	masterDetailRequireSaving: true,
	          	onCellFocus: function(element, value, x, y, id){
	          		objMsg.selectedDtlRow = msgDetailTG.geniisysRows[y];
	          		objMsg.selectedDtlIndex = y;
	          		populateDetails(msgDetailTG.geniisysRows[y]);
	          		msgDetailTG.keys.removeFocus(msgDetailTG.keys._nCurrentFocus, true);
	          		msgDetailTG.keys.releaseKeys();
	            },
	            onRemoveRowFocus: function(){
	            	objMsg.selectedDtlRow = null;
	          		objMsg.selectedDtlIndex = -1;
	            	populateDetails(null);
	            	msgDetailTG.keys.removeFocus(msgDetailTG.keys._nCurrentFocus, true);
	          		msgDetailTG.keys.releaseKeys();
	            },
	            beforeSort: function(){
	            	if(changeTag == 1){
	            		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
	            		return false;
	            	}
	            },
	            onSort: function(){
	            	msgDetailTG.onRemoveRowFocus();
	            },
	            prePager: function(){
	            	if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
	            	}
	            },
	            checkChanges: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailValidation: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailNoFunc: function(){
					return (changeTag == 1 ? true : false);
				},
	            toolbar: {
	            	elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
	            	onRefresh: function(){
	            		msgDetailTG.onRemoveRowFocus();
	            	},
	            	onFilter: function(){
	            		msgDetailTG.onRemoveRowFocus();
	            	}
	            }
			},
			columnModel:[
						{   id: 'recordStatus',
						    width: '0px',
						    visible: false,
						    editor: 'checkbox'
						},
						{	id: 'divCtrId',
							width: '0px',
							visible: false
						},
						{	id: 'groupName',
							title: 'User Group',
							width: '175px',
							filterOption: true
						},
						{	id: 'recipientName',
							title: 'Recipient Name',
							width: '560px',
							filterOption: true
						},
						{	id: 'cellphoneNo',
							title: 'Cellphone no',
							width: '125px',
							filterOption: true
						}
						],
			rows: []
		};
		msgDetailTG = new MyTableGrid(msgDetailTableModel);
		msgDetailTG.pager = {};
		msgDetailTG._mtgId = 2;
		msgDetailTG.render('messageDtlTGDiv');
		msgDetailTG.afterRender = function(){
				objMsg.details = msgDetailTG.geniisysRows;
				if(objMsg.selectedIndex != -1){
					objMsg.messages[objMsg.selectedIndex].details = msgDetailTG.geniisysRows;
				}
				msgDetailTG.onRemoveRowFocus();
		};
	}catch(e){
		showMessageBox("Error in Message Detail Table Grid: " + e, imgMessage.ERROR);
	}
	
	function newFormInstance(){
		initializeAll();
		initializeAccordion();
		initializeChangeAttribute();
		makeInputFieldUpperCase();
		
		$("message").focus();
		setModuleId("GISMS004");
		setDocumentTitle("Create/Send Text Messages");
		
		observeBackSpaceOnDate("setDate");
		observeBackSpaceOnDate("fromDate");
		observeBackSpaceOnDate("toDate");
		
		changeTag = 0;
		toggleBirthdayFields(false);
		
		observeSaveForm("btnSave", saveMessages);
		observeCancelForm("btnExit", saveMessages, exitForm);
		observeCancelForm("btnCancel", saveMessages, exitForm);
		observeReloadForm("reloadForm", showCreateSendMessages);
	}
	
	function showCreateSendMessages(){
		try{
			new Ajax.Updater("mainContents", contextPath+"/GISMMessagesSentController?action=showCreateSendMessages",{
				method: "GET",
				evalScripts: true,
				asynchronous: false,
				onCreate: showNotice("Loading Page, please wait..."),
				onComplete: function() {
					hideNotice("");
					$("mainNav").hide();
					Effect.Appear($("mainContents").down("div", 0), {duration: .001});
				}
			});
		}catch(e){
			showErrorMessage("showCreateSendMessages",e);
		}
	}
	
	function exitForm(){
		delete objMsg;
		goToModule("/GIISUserController?action=goToSMS", "SMS Main", null);
	}
	
	function onMsgCellFocus(y){
		objMsg.selectedRow = messageTG.geniisysRows[y];
  		objMsg.selectedIndex = y;
  		populateMessage(objMsg.selectedRow);
  		getMessageDetails(objMsg.selectedRow.msgId);
  		messageTG.keys.removeFocus(messageTG.keys._nCurrentFocus, true);
  		messageTG.keys.releaseKeys();
	}
	
	function onMsgRemoveFocus(){
		objMsg.selectedRow = null;
    	objMsg.selectedIndex = -1;
    	populateMessage(null);
    	getMessageDetails(null);
    	messageTG.keys.removeFocus(messageTG.keys._nCurrentFocus, true);
  		messageTG.keys.releaseKeys();
	}
	
	function hasPendingMsgChildRecords(){
		try{
			return getDeletedJSONObjects(objMsg.details).length > 0 || 
				getAddedAndModifiedJSONObjects(objMsg.selectedIndex == -1 ? {} : objMsg.messages[objMsg.selectedIndex].details).length > 0 ? true : false;
		}catch(e){
			showErrorMessage("hasPendingMsgChildRecords", e);
		}
	}
	
	function populateMessage(row){
		$("message").value = row == null ? "" : unescapeHTML2(row.message);
		$("setDate").value = row == null ? "" : row.dspSetDate;
		$("setTime").value = row == null ? "" : row.dspSetTime;
		$("remarks").value = row == null ? "" : unescapeHTML2(row.remarks);
		$("userId").value = row == null ? "" : unescapeHTML2(row.userId);
		$("lastUpdate").value = row == null ? "" : row.lastUpdate;
		$("bdayMsg").checked = row == null ? false : row.bdaySw == "Y" ? true : false;
		
		if(row == null){
			$("fromDate").value = "";
			$("toDate").value = "";
			
			$("high").checked = true;
			disableButton("btnDelMsg");
			disableButton("btnCancelMsg");
			$("btnAddMsg").value = "Add";
		}else{
			if(nvl(row.bdaySw, "N") == "Y"){
				$("fromDate").value = sysdate;
				$("toDate").value = sysdate;
				toggleBirthdayFields(true);
			}else{
				$("fromDate").value = "";
				$("toDate").value = "";
				toggleBirthdayFields(false);
			}
			
			row.priority == "3" ? $("low").checked = true : (row.priority == "2" ? $("medium").checked = true : $("high").checked = true);
			
			enableButton("btnDelMsg");
			enableButton("btnCancelMsg");
			$("btnAddMsg").value = "Update";
		}
	}
	
	function populateDetails(row){
		$("groupCd").value = row == null ? "" : row.groupCd;
		$("groupName").value = row == null ? "" : unescapeHTML2(row.groupName);
		$("recipientName").value = row == null ? "" : unescapeHTML2(row.recipientName);
		$("cellphoneNo").value = row == null ? "" : unescapeHTML2(row.cellphoneNo);
		
		if(row == null){
			disableButton("btnDelDtl");
			$("btnAddDtl").value = "Add";
		}else{
			enableButton("btnDelDtl");
			$("btnAddDtl").value = "Update";
		}
	}
	
	function toggleBirthdayFields(toggle){
		if(toggle){
			$("fromDate").value = sysdate;
			$("toDate").value = sysdate;
			$("fromDate").enable();
			$("toDate").enable();
			enableDate("hrefFromDate");
			enableDate("hrefToDate");
			$("fromDateDiv").setStyle("background-color: white");
			$("toDateDiv").setStyle("background-color: white");
		}else{
			$("fromDate").value = "";
			$("toDate").value = "";
			$("fromDate").disable();
			$("toDate").disable();
			disableDate("hrefFromDate");
			disableDate("hrefToDate");
			$("fromDateDiv").setStyle("background-color: #F0F0F0");
			$("toDateDiv").setStyle("background-color: #F0F0F0");
			$("hrefFromDate").next().setStyle("margin-top: 2px");
			$("hrefToDate").next().setStyle("margin-top: 2px");
		}
	}
	
	function getMessageDetails(messageId){
		msgDetailTG.url = contextPath+"/GISMMessagesSentController?action=getCreatedMessageDetails&messageId="+nvl(messageId, 0);
		msgDetailTG._refreshList(); 
	}
	
	function promptInvalidNo(){
		var chkDefault = $("chkDefault").checked;
		var globe = $("chkGlobe").checked;
		var smart = $("chkSmart").checked;
		var sun = $("chkSun").checked;
		
		if(chkDefault){
			showMessageBox("Not a valid smart, sun or globe cell number.", "I");
		}else{
			if(globe && smart && sun){
				showMessageBox("Not a valid smart, sun or globe cell number.", "I");
			}else if(globe && sun){
				showMessageBox("Not a valid globe or sun cell number.", "I");
			}else if(smart && sun){
				showMessageBox("Not a valid smart or sun cell number.", "I");
			}else if(globe && smart){
				showMessageBox("Not a valid globe or smart cell number.", "I");
			}else if(globe){
				showMessageBox("Not a valid globe cell number.", "I");
			}else if(smart){
				showMessageBox("Not a valid smart cell number.", "I");
			}else if(sun){
				showMessageBox("Not a valid sun cell number.", "I");
			}
		}
		$("cellphoneNo").value = "";
	}
	
	function showGroupLOV(){
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {
					action: "getRecipientGroupLOV",
					filterText: $F("groupName") != $("groupName").getAttribute("lastValidValue") ? nvl($F("groupName"), "%") : "%"
				},
				title: "List of User Groups",
				width: 400,
				height: 386,
				columnModel:[
								{	id: "groupCd",
									title: "Group Code",
									width: "100px"
								},
								{	id: "groupName",
									title: "Group Name",
									width: "250px"
								}
							],
				draggable: true,
				showNotice: true,
				autoSelectOneRecord : true,
				filterText: $F("groupName") != $("groupName").getAttribute("lastValidValue") ? nvl($F("groupName"), "%") : "%",
			    noticeMessage: "Getting list, please wait...",
				onSelect : function(row){
					if(row != undefined) {
						$("groupCd").value = row.groupCd;
						$("groupName").value = unescapeHTML2(row.groupName);
						$("groupCd").setAttribute("lastValidValue", row.groupCd);
						$("groupName").setAttribute("lastValidValue", row.groupName);
					}
				},
				onCancel: function(){
					$("groupCd").value = $("groupCd").getAttribute("lastValidValue");
					$("groupName").value = $("groupName").getAttribute("lastValidValue");
				},
				onUndefinedRow: function(){
					showMessageBox("No record selected.", "I");
					$("groupCd").value = $("groupCd").getAttribute("lastValidValue");
					$("groupName").value = $("groupName").getAttribute("lastValidValue");
				},
				onShow: function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			});
		}catch(e){
			showErrorMessage("showGroupLOV", e);
		}
	}
	
	function showRecipientOverlay(){
		try{
			recipientOverlay = Overlay.show(contextPath+"/GISMMessagesSentController", {
				urlParameters: {
					action: "showRecipientOverlay",
					groupCd: $F("groupCd"),
					bdaySw: $("bdayMsg").checked ? "Y" : "N",
					fromDate: $F("fromDate"),
					toDate: $F("toDate"),
					chkDefault: $("chkDefault").checked ? "Y" : "N",
					chkGlobe: $("chkGlobe").checked ? "Y" : "N",
					chkSmart: $("chkSmart").checked ? "Y" : "N",
					chkSun: $("chkSun").checked ? "Y" : "N"
				},
				title: "List of Recipients",
			    height: 400,
			    width: 685,
				urlContent : true,
				draggable: true,
				showNotice: true,
			    noticeMessage: "Loading, please wait..."
			});
		}catch(e){
			showErrorMessage("showRecipientOverlay", e);
		}
	}
	
	function validateSchedule(){
		if($F("setDate") != "" && $F("setTime") != ""){
			if(new Date() > Date.parse($F("setDate") + " " + $F("setTime"))){
				showMessageBox("Please enter a date later than today.", "I");
				return false;
			}
		}
		return true;
	}
	
	function validateCellphoneNo(){
		new Ajax.Request(contextPath + "/GISMMessagesSentController",{
			parameters : {
				action: "validateCellphoneNo",
				cellphoneNo: $F("cellphoneNo"),
				chkDefault: $("chkDefault").checked ? "Y" : "N",
				chkGlobe: $("chkGlobe").checked ? "Y" : "N",
				chkSmart: $("chkSmart").checked ? "Y" : "N",
				chkSun: $("chkSun").checked ? "Y" : "N"
			},
			asynchronous : false,
			evalScripts : true,
			onCreate: function(){
				showNotice("Validating cellphone number, please wait...");
			},
			onComplete : function(response){
				hideNotice("");
				function clearCellNo(){
					$("cellphoneNo").value = "";
					$("cellphoneNo").focus();
				}
				
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, clearCellNo)){
					if(response.responseText != "SUCCESS"){
						promptInvalidNo();
					}
				}
			}
		});
	}
	
	function cancelMessage(){
		new Ajax.Request(contextPath + "/GISMMessagesSentController",{
			parameters : {
				action: "cancelMessage",
				messageId: objMsg.selectedRow.msgId
			},
			asynchronous : false,
			evalScripts : true,
			onCreate: function(){
				showNotice("Processing, please wait...");
			},
			onComplete : function(response){
				hideNotice("");
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					showWaitingMessageBox("Message successfully cancelled.", "S", showCreateSendMessages);
				}
			}
		});
	}
	
	function createMsgRow(){
		var row = {};
		row.message = $F("message");
		row.priority = $("low").checked ? "3" : ($("medium").checked ? "2" : "1");
		row.priorityDesc = $("low").checked ? "LOW" : ($("medium").checked ? "MEDIUM" : "HIGH");
		row.remarks = $F("remarks");
		row.dspSetDate = $F("setDate");
		row.dspSetTime = $F("setTime");
		row.schedDate = $F("setDate") + " " + $F("setTime");
		row.bdaySw = $("bdayMsg").checked ? "Y" : "N";
		row.lastUpdate = "";
		row.userId = "";
		row.recordStatus = 0;
		return row;
	};
	
	function updateMsgRow(){
		objMsg.selectedRow.message = $F("message");
		objMsg.selectedRow.priority = $("low").checked ? "3" : ($("medium").checked ? "2" : "1");
		objMsg.selectedRow.priorityDesc = $("low").checked ? "LOW" : ($("medium").checked ? "MEDIUM" : "HIGH");
		objMsg.selectedRow.remarks = $F("remarks");
		objMsg.selectedRow.dspSetDate = $F("setDate");
		objMsg.selectedRow.dspSetTime = $F("setTime");
		objMsg.selectedRow.schedDate = $F("setDate") + " " + $F("setTime");
		objMsg.selectedRow.bdaySw = $("bdayMsg").checked ? "Y" : "N";
		objMsg.selectedRow.recordStatus = 1;
	}
	
	function addMessage(){
		if($F("btnAddMsg") == "Add"){
			var row = createMsgRow();
			objMsg.messages.push(row);
			messageTG.addBottomRow(row);
		}else{
			updateMsgRow();
			objMsg.messages.splice(objMsg.selectedIndex, 1, objMsg.selectedRow);
			messageTG.updateVisibleRowOnly(objMsg.selectedRow, objMsg.selectedIndex);
		}
		messageTG.onRemoveRowFocus();
		changeTag = 1;
	}
	
	function deleteMessage(){
		objMsg.selectedRow.recordStatus = -1;
		objMsg.messages.splice(objMsg.selectedIndex, 1, objMsg.selectedRow);
		messageTG.deleteRow(objMsg.selectedIndex);
		messageTG.onRemoveRowFocus();
		changeTag = 1;
	}
	
	function createDtlRow(){
		var row = {};
		row.msgId = nvl(objMsg.selectedRow.msgId, "");
		row.dtlId = "";
		row.statusSw = 'Q';
		row.pkColumnValue = $F("pkColumnValue");
		row.groupCd = $F("groupCd");
		row.groupName = $F("groupName");
		row.recipientName = $F("recipientName");
		row.cellphoneNo = $F("cellphoneNo");
		row.recordStatus = 0;
		return row;
	}
	
	function updateDtlRow(){
		objMsg.messages[objMsg.selectedIndex].details[objMsg.selectedDtlIndex].recipientName = $F("recipientName");
		objMsg.messages[objMsg.selectedIndex].details[objMsg.selectedDtlIndex].cellphoneNo = $F("cellphoneNo");
		objMsg.messages[objMsg.selectedIndex].details[objMsg.selectedDtlIndex].recordStatus = 1;
	}
	
	function addDetail(){
		if($("btnAddDtl").value == "Add"){
			var row = createDtlRow();
			
			if(nvl(objMsg.messages[objMsg.selectedIndex].details, null) == null){
				objMsg.messages[objMsg.selectedIndex].details = [];
			}
			objMsg.messages[objMsg.selectedIndex].details.push(row);			
			msgDetailTG.addBottomRow(row);
		}else{
			updateDtlRow();
			objMsg.messages[objMsg.selectedIndex].details.splice(objMsg.selectedDtlIndex, 1, objMsg.messages[objMsg.selectedIndex].details[objMsg.selectedDtlIndex]);
			msgDetailTG.updateVisibleRowOnly(objMsg.messages[objMsg.selectedIndex].details[objMsg.selectedDtlIndex], objMsg.selectedDtlIndex);
		}
		objMsg.messages[objMsg.selectedIndex].recordStatus = 1;
		msgDetailTG.onRemoveRowFocus();
		changeTag = 1;
	}
	
	function deleteDetail(){
		objMsg.selectedDtlRow.recordStatus = -1;
		objMsg.details.splice(objMsg.selectedDtlIndex, 1, objMsg.selectedDtlRow);
		msgDetailTG.deleteRow(objMsg.selectedDtlIndex);
		msgDetailTG.onRemoveRowFocus();
		changeTag = 1;
	}
	
	function saveMessages(){
		var objParams = new Object();
		objParams.setRows = getAddedAndModifiedJSONObjects(objMsg.messages);
		objParams.delRows = getDeletedJSONObjects(objMsg.messages);
		objParams.delDtlRows = getDeletedJSONObjects(objMsg.details);
		
		new Ajax.Request(contextPath+"/GISMMessagesSentController",{
			method: "POST",
			parameters:{
				action: "saveMessages",
				parameters: JSON.stringify(objParams)
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				showNotice("Saving, please wait...");
			},
			onComplete: function(response){
				hideNotice("");
				changeTag = 0;
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
					showWaitingMessageBox(objCommonMessage.SUCCESS, "S", showCreateSendMessages);
				}
			}
		});
	}
	
	$("setDate").observe("focus", function(){
		if(!validateSchedule()){
			$("setDate").value = "";
			$("setDate").focus();
		}
	});
	
	$("setTime").observe("change", function(){
		if($F("setTime") != "" && isValidTime("setTime")){ //Added by Jerome Bautista 05.26.2015 SR 4236
			if(!validateSchedule()){
				$("setTime").value = "";
				$("setTime").focus();
			}
		}
	});
	
	$("bdayMsg").observe("change", function(){
		if($("bdayMsg").checked){
			toggleBirthdayFields(true);
		}else{
			toggleBirthdayFields(false);
		}
	});
	
	$("fromDate").observe("focus", function(){
		if(($F("fromDate") != "" && $F("toDate") != "") && (Date.parse($F("fromDate")) > Date.parse($F("toDate")))){
			showMessageBox("From Date should not be later than To Date.", "I");
			$("fromDate").value = "";
			$("fromDate").focus();
		}
	});
	
	$("toDate").observe("focus", function(){
		if(($F("fromDate") != "" && $F("toDate") != "") && (Date.parse($F("fromDate")) > Date.parse($F("toDate")))){
			showMessageBox("From Date should not be later than To Date.", "I");
			$("toDate").value = "";
			$("toDate").focus();
		}
	});
	
	$("editRemarks").observe("click", function(){
		showEditor("remarks", 4000, false);
	});
	
	$("btnAddMsg").observe("click", function(){
		if(checkAllRequiredFieldsInDiv("createdMessagesDiv")){
			addMessage();
		}
	});
	
	$("btnDelMsg").observe("click", function(){
		deleteMessage();
	});
	
	$("groupName").observe("change", function(){
		if($F("groupName") != ""){
			showGroupLOV();
		}else{
			$("groupCd").value = "";
			$("groupCd").setAttribute("lastValidValue", "");
			$("groupName").setAttribute("lastValidValue", "");
		}
	});
	
	$("searchGroupName").observe("click", function(){
		if(objMsg.selectedRow == null){
			showMessageBox("Please select message first.", "I");
		}else{
			showGroupLOV();
		}
	});
	
	$("searchRecipient").observe("click", function(){
		if($F("groupCd") == ""){
			showMessageBox("Please insert a user group first.", "I");
		}else{
			showRecipientOverlay();
		}
	});
	
	$("cellphoneNo").observe("change", function(){
		if($F("cellphoneNo") != ""){
			validateCellphoneNo();
		}
	});
	
	$("btnAddDtl").observe("click", function(){
		if(objMsg.selectedRow == null){
			showMessageBox("Please select message first.", "I");
		}else{
			if(checkAllRequiredFieldsInDiv("createdMessageDtlDiv")){
				addDetail();
			}
		}
	});
	
	$("btnDelDtl").observe("click", function(){
		deleteDetail();
	});
	
	$("btnCancelMsg").observe("click", function(){
		if(changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		}else{
			showConfirmBox("Confirmation", "Are you sure you want to cancel the message?", "Yes", "No", cancelMessage, null, "2");
		}
	});
	
	newFormInstance();
</script>