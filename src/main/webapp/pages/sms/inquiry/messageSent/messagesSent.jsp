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

<div id="messagesSentMainDiv" name="messagesSentMainDiv">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Messages Sent Inquiry</label>
			<span class="refreshers" style="margin-top: 0;">
				<label name="gro" style="margin-left: 5px;">Hide</label>
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
		</div>
	</div>
	
	<div id="messagesSentDiv" class="sectionDiv" style="margin-bottom: 30px;">
		<div id="messagesSentTGDiv" name="messagesSentTGDiv" style="height: 295px; width: 720px; margin: 12px 0 20px 16px; float: left;"></div>
		
		<div class="sectionDiv" style="height: 240px; width: 153px; float: left; margin: 12px 0 0 15px;">
			<label style="width: 100%; text-align: center; font-weight: bold; margin: 10px 0 10px 0;">Status</label>
			<div class="sectionDiv" style="height: 188px; width: 140px; margin: 0 0 0 5px" align="center">
				<table style="margin-top: 8px;">
					<tr>
						<td>
							<input id="allMessages" name="statusRG" value="1" title="All Messages" type="radio" style="margin: 2px 5px 10px 3px; float: left;" checked="checked" tabindex="109">
							<label for="allMessages" style="margin: 2px 0 10px 0">All Messages</label>
						</td>
					</tr>
					<tr>
						<td>
							<input id="onQueue" name="statusRG" value="2" title="On Queue" type="radio" style="margin: 2px 5px 10px 3px; float: left;" tabindex="109">
							<label for="onQueue" style="margin: 2px 0 10px 0">On Queue</label>
						</td>
					</tr>
					<tr>
						<td>
							<input id="cancelled" name="statusRG" value="3" title="Cancelled" type="radio" style="margin: 2px 5px 10px 3px; float: left;" tabindex="109">
							<label for="cancelled" style="margin: 2px 0 10px 0">Cancelled</label>
						</td>
					</tr>
					<tr>
						<td>
							<input id="withError" name="statusRG" value="4" title="With Error" type="radio" style="margin: 2px 5px 10px 3px; float: left;" tabindex="109">
							<label for="withError" style="margin: 2px 0 10px 0">With Error</label>
						</td>
					</tr>
					<tr>
						<td>
							<input id="sent" name="statusRG" value="5" title="Successfully Sent" type="radio" style="margin: 2px 5px 10px 3px; float: left;" tabindex="109">
							<label for="sent" style="margin: 2px 0 10px 0">Successfully Sent</label>
						</td>
					</tr>
					<tr>
						<td>
							<input id="sentWithError" name="statusRG" value="6" title="Sent With Error" type="radio" style="margin: 2px 5px 10px 3px; float: left;" tabindex="109">
							<label for="sentWithError" style="margin: 2px 0 10px 0">Sent With Error</label>
						</td>
					</tr>
				</table>
			</div>
		</div>
		
		<div id="buttonsDiv" style="float: left; margin: 5px 0 0 10px;">
			<table>
				<tr>
					<td><input id="btnResend" type="button" class="disabledButton" value="Resend" style="width: 153px;" tabindex="117"></td>
				</tr>
				<tr>
					<td><input id="btnViewDetails" type="button" class="disabledButton" value="Details" style="width: 153px;" tabindex="118"></td>
				</tr>
			</table>
		</div>
		
		<div style="float: left;">
			<table style="margin: 5px 0 10px 50px;">
				<tr>
					<td class="rightAligned" style="vertical-align: top;">Message</td>
					<td colspan="3">
						<textarea id="message" name="message" style="width: 745px; height: 60px;" readonly="readonly"></textarea>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Remarks</td>
					<td colspan="3">
						<div style="border: 1px solid gray; height: 20px; width: 751px;">
							<textarea id="remarks" name="remarks" style="width: 724px; border: none; height: 13px; margin: 0px; resize: none;" readonly="readonly"/></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">User Id</td>
					<td style="width: 200px;">
						<input id="userId" type="text" readonly="readonly" style="height: 13px; width: 200px;" tabindex="106">
					</td>
					<td class="rightAligned">Last Update</td>
					<td style="width: 200px;">
						<input id="lastUpdate" type="text" readonly="readonly" style="height: 13px; width: 200px;" tabindex="106">
					</td>
				</tr>
			</table>
		</div>
		
		
	</div>
</div>

<script type="text/javascript">
	objMessagesSent = {};
	objMessagesSent.selectedMessage = "";
	objMessagesSent.messagesSentTableGrid = JSON.parse('${messagesSentJSON}');
	objMessagesSent.messagesSentRows = objMessagesSent.messagesSentTableGrid.rows || [];

	try{
		messagesSentModel = {
			url: contextPath+"/GISMMessagesSentController?action=showMessagesSent&refresh=1",
			options: {
	          	height: '280px',
	          	width: '720px',
	          	onCellFocus: function(element, value, x, y, id){
	          		populateFields(messagesSentTG.geniisysRows[y]);
	          		objMessagesSent.selectedMessage = messagesSentTG.geniisysRows[y].msgId;
	          		messagesSentTG.keys.removeFocus(messagesSentTG.keys._nCurrentFocus, true);
	            	messagesSentTG.keys.releaseKeys();
	            },
	            onRemoveRowFocus: function(){
	            	populateFields(null);
	            	objMessagesSent.selectedMessage = "";
	            	messagesSentTG.keys.removeFocus(messagesSentTG.keys._nCurrentFocus, true);
	            	messagesSentTG.keys.releaseKeys();
	            },
	            onSort: function(){
	            	messagesSentTG.onRemoveRowFocus();
	            },
	            toolbar: {
	            	elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
	            	onRefresh: function(){
	            		messagesSentTG.onRemoveRowFocus();
	            	},
	            	onFilter: function(){
	            		messagesSentTG.onRemoveRowFocus();
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
						{	id: 'msgId',
							title: 'Message ID',
							width: '85px',
							filterOption: true,
							filterOptionType: 'integerNoNegative'
						},
						{	id: 'dspSchedDate',
							title: 'Message Schedule',
							width: '175px',
							align: 'center',
							filterOption: true,
							filterOptionType: 'formattedDate'
						},
						{	id: 'dspSetDate',
							title: 'Message Sent On',
							width: '175px',
							align: 'center',
							filterOption: true,
							filterOptionType: 'formattedDate'
						},
						{	id: 'priorityDesc',
							title: 'Priority',
							width: '100px',
							filterOption: true
						},
						{	id: 'statusDesc',
							title: 'Status',
							width: '146px'
						},
						{	id: 'message',
							title: 'Message',
							width: '0',
							visible: false,
							filterOption: true
						},
						{	id: 'remarks',
							title: 'Remarks',
							width: '0',
							visible: false,
							filterOption: true
						}
						],
			rows: objMessagesSent.messagesSentRows
		};
		messagesSentTG = new MyTableGrid(messagesSentModel);
		messagesSentTG.pager = objMessagesSent.messagesSentTableGrid;
		messagesSentTG.render('messagesSentTGDiv');
		messagesSentTG.afterRender = function(){
			messagesSentTG.onRemoveRowFocus();
		};
	}catch(e){
		showMessageBox("Error in Messages Sent Table Grid: " + e, imgMessage.ERROR);
	}

	function newFormInstance(){
		initializeAll();
		initializeAccordion();
		$("allMessages").focus();
		setModuleId("GISMS005");
		setDocumentTitle("Messages Sent Inquiry");
		observeReloadForm("reloadForm", showMessagesSent);
	}
	
	function showMessagesSent(){
		try{
			new Ajax.Updater("mainContents", contextPath+"/GISMMessagesSentController?action=showMessagesSent",{
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
			showErrorMessage("showMessagesSent",e);
		}
	}
	
	function populateFields(row){
		$("message").value = row == null ? "" : unescapeHTML2(row.message);
		$("remarks").value = row == null ? "" : unescapeHTML2(row.remarks);
		$("userId").value = row == null ? "" : unescapeHTML2(row.userId);
		$("lastUpdate").value = row == null ? "" : row.dspLastUpdate;
		
		if(row != null){
			if(row.messageStatus == "E" || row.messageStatus == "A"){
				enableButton("btnResend");
			}
			enableButton("btnViewDetails");
			$("editRemarks").show();
		}else{
			disableButton("btnResend");
			disableButton("btnViewDetails");
			$("editRemarks").hide();
		}
	}
	
	function refreshMessagesSentTG(status){
		messagesSentTG.url = contextPath+"/GISMMessagesSentController?action=showMessagesSent&refresh=1&status="+status;
		messagesSentTG._refreshList();
	}
	
	function resendMessage(){
		new Ajax.Request(contextPath+"/GISMMessagesSentController",{
			method: "POST",
			parameters:{
				action: "resendMessage",
				messageId: objMessagesSent.selectedMessage
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				showNotice("Processing, please wait...");
			},
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
					showWaitingMessageBox(objCommonMessage.SUCCESS, "S", function(){
						messagesSentTG._refreshList();
					});
				}
			}
		});
	}
	
	function showMessageDetailsOverlay(){
		messageDetailsOverlay = Overlay.show(contextPath+"/GISMMessagesSentController", {
			urlParameters: {
				action: "showMessageDetails",
				messageId: objMessagesSent.selectedMessage
			},
			title: "Message Sent Details",
		    height: 385,
		    width: 740,
			urlContent : true,
			draggable: true,
			showNotice: true,
		    noticeMessage: "Loading, please wait..."
		});
	}

	$$("input[name='statusRG']").each(function(i){
		i.observe("click", function(){
			refreshMessagesSentTG(i.value);
		});
	});
	
	$("btnResend").observe("click", function(){
		resendMessage();
	});
	
	$("btnViewDetails").observe("click", function(){
		showMessageDetailsOverlay();
	});
	
	$("editRemarks").observe("click", function(){
		showEditor("remarks", 4000, "true");
	});
	
	$("btnExit").observe("click", function(){
		delete objMessagesSent;
		goToModule("/GIISUserController?action=goToSMS", "SMS Main", null);
	});
	
	newFormInstance();

</script>