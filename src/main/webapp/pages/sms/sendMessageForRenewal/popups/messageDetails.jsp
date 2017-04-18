<div id="messageDetailsMainDiv" name="messageDetailsMainDiv" style="width: 99%;">
	<div id="policyNoDiv" name="policyNoDiv" class="sectionDiv" style="float: left; width: 100%; height: 37px; margin-top: 3px; padding-top: 10px;" align="center"" align="center">
		Policy No
		<input id="policyNo" name="policyNo" type="text" style="width: 250px;" readonly="readonly" tabindex="301">
	</div>
		
	<div id="messageMainDiv" name="messageMainDiv" class="sectionDiv" style="height: 175px; width: 100%;">
		<label style="margin: 20px 0 0 25px; padding-right: 8px;">Message</label>
		<textarea id="messageArea" name="messageArea" style="width: 422px; height: 125px; margin-top: 20px;" readonly="readonly"></textarea>
	</div>
		
	<div id="messageDtlsTGMainDiv" name="messageDtlsTGMainDiv" class="sectionDiv" style="height: 200px; width: 100%;">
		<div id="messageDtlsTGDiv" name="messageDtlsTGDiv" style="height: 155px; padding: 10px 0 0 45px;">
		
		</div>
		<div id="messageInfoMainDiv" name="messageInfoMainDiv" style="width: 100%;" align="center">
			<table>
				<tr>
					<td>Date Created</td>
					<td><input id="dateCreated" name="dateCreated" type="text" style="width: 170px;" readonly="readonly" tabindex="302"></td>
					<td><label id="lblSentReceived" name="lblSentReceived" style="width: 100px; text-align: right;">Date Received<label></td>
					<td><input id="dateReceived" name="dateReceived" type="text" style="width: 170px;" readonly="readonly" tabindex="303"></td>
				</tr>
			</table>
		</div>
	</div>
	
	<div id="msgButtonDiv" name="msgButtonDiv" align="center" style="margin-top: 10px; float: left; width: 100%;">
		<input id="btnCloseMsgDtls" name="btnCloseMsgDtls" type="button" class="button" value="Close" style="width: 80px;" tabindex="304">
	</div>
</div>

<script type="text/javascript">
	objSMSRenewal.messageDtlsTableGrid = JSON.parse('${messageDtlsTableGrid}');
	objSMSRenewal.messageDtlsRows = objSMSRenewal.messageDtlsTableGrid.rows || [];
	
	try {
		var messageDtlsTableGridModel = {
			url: contextPath+"/GIEXSmsDtlController?action=showMessageDtlsOverlay&refresh=1"+
					"&policyId="+objSMSRenewal.selectedRow.policyId,
			options: {
				width: '500px',
				height: '125px',
				onCellFocus: function(element, value, x, y, id) {
					populateMessageDtls(y);
					messageDtlsTableGrid.keys.removeFocus(messageDtlsTableGrid.keys._nCurrentFocus, true);
					messageDtlsTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus : function(){
					populateMessageDtls(null);
					messageDtlsTableGrid.keys.removeFocus(messageDtlsTableGrid.keys._nCurrentFocus, true);
					messageDtlsTableGrid.keys.releaseKeys();	
			  	},
			  	onSort: function(){
			  		messageDtlsTableGrid.onRemoveRowFocus();
			  	}
			},
			columnModel: [
				{   
					id: 'recordStatus',
				    width: '0',
				    visible: false,
				    editor: 'checkbox' 	
				},
				{	
					id: 'divCtrId',
					width: '0',
					visible: false
				},
				{
					id: 'recipientSender',
					title: 'Send To/Received From',
					width: '240px'
				},
				{
					id: 'cellphoneNo',
					title: 'Cellphone No.',
					width: '96px'
				},
				{
					id: 'messageStatus',
					title: 'Status',
					width: '125px'
				},
				{
					id: 'dateReceived',
					title: '',
					width: '0px',
					visible: false
				}
			],
			rows: objSMSRenewal.messageDtlsRows
		};
		messageDtlsTableGrid = new MyTableGrid(messageDtlsTableGridModel);
		messageDtlsTableGrid.pager = objSMSRenewal.messageDtlsTableGrid;
		messageDtlsTableGrid.render('messageDtlsTGDiv');
	}catch(e) {
		showErrorMessage("messageDtlsTableGrid", e);
	}

	function populateMessageDtls(y){
		$("messageArea").value = y == null ? "" : messageDtlsTableGrid.geniisysRows[y].message;
		$("dateCreated").value = y == null ? "" : messageDtlsTableGrid.geniisysRows[y].dspDateCreated;
		
		if(y == null){
			$("dateReceived").value = "";
		}else{
			if(nvl(messageDtlsTableGrid.geniisysRows[y].dateSent, "") == ""){
				$("dateReceived").value = messageDtlsTableGrid.geniisysRows[y].dspDateReceived;
				$("lblSentReceived").innerHTML = "Date Received";
			}else{
				$("dateReceived").value = messageDtlsTableGrid.geniisysRows[y].dspDateSent;
				$("lblSentReceived").innerHTML = "Date Sent";
			}
		}
	}
	
	$("btnCloseMsgDtls").observe("click", function(){
		messageDtlsOverlay.close();
	});
	
	$("policyNo").focus();
	initializeAll();
	objSMSRenewal.populatePolicyNo();
</script>