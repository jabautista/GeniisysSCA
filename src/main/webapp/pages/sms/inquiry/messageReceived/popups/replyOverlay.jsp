<div id="messageDetailsMainDiv" name="messageDetailsMainDiv">
	<div class="sectionDiv" style="width: 730px; margin: 10px 0 12px 0;">
		<table style="margin: 15px 0 15px 15px;">
			<tr>
				<td class="rightAligned" style="vertical-align: top;">Message</td>
				<td colspan="3">
					<textarea id="replyMessage" name="dtlMessage" style="width: 600px; height: 150px;" maxlength="320" tabindex="301"></textarea>
				</td>
			</tr>
		</table>
	</div>
	<div align="center">
		<input id="btnOk" name="btnOk" type="button" class="button" value="Ok" style="width: 80px;" tabindex="302"/>
		<input id="btnCancel" name="btnCancel" type="button" class="button" value="Cancel" style="width: 80px;" tabindex="303"/>
	</div>
</div>

<script type="text/javascript">
	initializeAll();
	$("replyMessage").focus();
	
	function replyToMessage(){
		new Ajax.Request(contextPath + "/GISMMessagesReceivedController",{
			parameters : {
				action: "replyToMessage",
				message: $F("replyMessage"),
				sender: objMessages.selectedRow.sender,
				cellphoneNo: objMessages.selectedRow.cellphoneNo,
				dateReceived: objMessages.selectedRow.dspDateReceived
			},
			asynchronous : false,
			evalScripts : true,
			onCreate: function(){
				showNotice("Saving, please wait...");
			},
			onComplete : function(response){
				hideNotice("");
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					showWaitingMessageBox(objCommonMessage.SUCCESS, "S", function(){
						replyOverlay.close();
						delete replyOverlay;
						messagesTG._refreshList();
					});
				}
			}
		});
	}
	
	$("btnOk").observe("click", function(){
		replyToMessage();
	});
	
	$("btnCancel").observe("click", function(){
		replyOverlay.close();
		delete replyOverlay;
	});
</script>