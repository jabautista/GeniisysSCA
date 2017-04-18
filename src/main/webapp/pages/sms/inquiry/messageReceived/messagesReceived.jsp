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

<div id="messagesReceivedMainDiv" name="messagesReceivedMainDiv">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Messages Received Inquiry</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
		</div>
	</div>
	
	<div class="sectionDiv" style="margin-bottom: 30px;">
		<div id="messagesTGDiv" name="messagesTGDiv" style="height: 320px; width: 720px; margin: 12px 0 20px 90px; float: left;"></div>
		
		<div style="float: left;">
			<table style="margin: 5px 0 10px 60px;">
				<tr>
					<td class="rightAligned" style="vertical-align: top;">Message</td>
					<td colspan="3">
						<textarea id="message" name="message" style="width: 700px; height: 100px;" readonly="readonly" tabindex="101"></textarea>
					</td>
				</tr>
				<tr>
					<td colspan="4">
						<div align="center" style="margin: 2px 0 4px 25px;">
							<input id="btnViewDetail" type="button" class="button" value="Details" style="width: 100px;" tabindex="102">
							<input id="btnReply" type="button" class="button" value="Reply" style="width: 100px;" tabindex="103">
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Remarks</td>
					<td colspan="3">
						<div style="border: 1px solid gray; height: 20px; width: 705px;">
							<textarea id="remarks" name="remarks" style="width: 665px; border: none; height: 13px; margin: 0px; resize: none;" readonly="readonly" tabindex="104"/></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">User Id</td>
					<td style="width: 200px;">
						<input id="userId" type="text" readonly="readonly" style="height: 13px; width: 200px;" tabindex="105">
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
	objMessages = {};
	objMessages.tableGrid = JSON.parse('${messagesReceivedJSON}');
	objMessages.rows = objMessages.tableGrid.rows || [];
	objMessages.selectedRow = null;
	
	try{
		messagesReceivedModel = {
			url: contextPath+"/GISMMessagesReceivedController?action=showMessagesReceived&refresh=1",
			options: {
	          	height: '306px',
	          	width: '750px',
	          	onCellFocus: function(element, value, x, y, id){
	          		objMessages.selectedRow = messagesTG.geniisysRows[y];
	          		populateFields(true);
	          		messagesTG.keys.removeFocus(messagesTG.keys._nCurrentFocus, true);
	          		messagesTG.keys.releaseKeys();
	            },
	            onRemoveRowFocus: function(){;
	            	objMessages.selectedRow = null;
	            	populateFields(false);
	            	messagesTG.keys.removeFocus(messagesTG.keys._nCurrentFocus, true);
	            	messagesTG.keys.releaseKeys();
	            },
	            onSort: function(){
	            	messagesTG.onRemoveRowFocus();
	            },
	            toolbar: {
	            	elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
	            	onRefresh: function(){
	            		messagesTG.onRemoveRowFocus();
	            	},
	            	onFilter: function(){
	            		messagesTG.onRemoveRowFocus();
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
						{	id: 'errorSw',
							title: '&nbsp;ER',
			            	width: '25px',
			            	altTitle: 'With Error',
			            	titleAlign: 'center',
			            	editable: false,
			            	hideSelectAllBox: true,
			            	editor: new MyTableGrid.CellCheckbox({
					            getValueOf: function(value){
				            		return value ? "Y" : "N";
				            	}
			            	})
						},
						{	id: 'sender',
							title: 'Sender',
							width: '430px',
							filterOption: true
						},
						{	id: 'cellphoneNo',
							title: 'Cellphone No',
							width: '120px',
							filterOption: true
						},
						{	id: 'dspDateReceived',
							title: 'Date Received',
							width: '140px',
							filterOption: true,
							filterOptionType: 'formattedDate'
						},
						{	id: 'message',
							title: 'Message',
							width: '0px',
							visible: false,
							filterOption: true
						},
						],
			rows: objMessages.rows
		};
		messagesTG = new MyTableGrid(messagesReceivedModel);
		messagesTG.pager = objMessages.tableGrid;
		messagesTG.render('messagesTGDiv');
		messagesTG.afterRender = function(){
			messagesTG.onRemoveRowFocus();
		};
	}catch(e){
		showMessageBox("Error in Messages Received Table Grid: " + e, imgMessage.ERROR);
	}

	function newFormInstance(){
		initializeAll();
		$("message").focus();
		setModuleId("GISMS009");
		setDocumentTitle("Messages Received Inquiry");
		observeReloadForm("reloadForm", showMessagesReceived);
	}
	
	function populateFields(set){
		$("message").value = set ? unescapeHTML2(objMessages.selectedRow.message) : "";
		$("remarks").value = set ? unescapeHTML2(objMessages.selectedRow.remarks) : "";
		$("userId").value = set ? unescapeHTML2(objMessages.selectedRow.userId) : "";
		$("lastUpdate").value = set ? objMessages.selectedRow.dspLastUpdate : "";
	}
	
	function showMessagesReceived(){
		try{
			new Ajax.Updater("mainContents", contextPath+"/GISMMessagesReceivedController?action=showMessagesReceived",{
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
			showErrorMessage("showMessagesReceived",e);
		}
	}
	
	function showDetailOverlay(){
		messageDetailOverlay = Overlay.show(contextPath+"/GISMMessagesReceivedController", {
			urlParameters: {
				action: "showMessageDetail",
				messageId: objMessages.selectedRow.errorMsgId
			},
			title: "Message Received Details",
		    height: 275,
		    width: 735,
			urlContent : true,
			draggable: true,
			showNotice: true,
		    noticeMessage: "Loading, please wait..."
		});
	}
	
	function showReplyOverlay(){
		replyOverlay = Overlay.show(contextPath+"/GISMMessagesReceivedController", {
			urlParameters: {
				action: "showReplyOverlay"
			},
			title: "Reply Message",
		    height: 250,
		    width: 735,
			urlContent : true,
			draggable: true,
			showNotice: true,
		    noticeMessage: "Loading, please wait..."
		});
	}
	
	$("editRemarks").observe("click", function(){
		showEditor("remarks", 1000, "true");
	});
	
	$("btnViewDetail").observe("click", function(){
		if(objMessages.selectedRow == null){
			showMessageBox("Please select message first.", "I");
		}else{
			showDetailOverlay();
		}
	});
	
	$("btnReply").observe("click", function(){
		if(objMessages.selectedRow == null){
			showMessageBox("Please select message first.", "I");
		}else{
			if(nvl(objMessages.selectedRow.errorMsgId, "") != ""){
				showMessageBox("You have already replied to this message.", "I");
			}else{
				showReplyOverlay();
			}
		}
	});
	
	$("btnExit").observe("click", function(){
		delete objMessages;
		goToModule("/GIISUserController?action=goToSMS", "SMS Main", null);
	});
	
	newFormInstance();
</script>