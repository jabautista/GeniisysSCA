<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
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

<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" name="innerDiv">
		<label>SMS Renewal</label>
		<span class="refreshers" style="margin-top: 0;">
			<label id="reloadForm" name="reloadForm">Reload Form</label>
		</span>
	</div>
</div>

<div id="smsRenewalMainDiv" name="smsRenewalMainDiv" class="sectionDiv" style="height: 575px; width: 100%;">
	<div id="smsRenewalTGDiv" name="smsRenewalTGDiv" style="height: 340px; padding: 10px 0 0 36px;">
	
	</div>
	
	<div id="smsRenewalInfoDiv" name="smsRenewalInfoDiv" style="float: left; margin: 0 10px 0 10px; width: 580px;">
		<table>
			<tr>
				<td class="rightAligned">Assured</td>
				<td><input id="txtAssdName" name="txtAssdName" type="text" readonly="readonly" style="width: 475px;" tabindex="101"></td>
			</tr>
			<tr>
				<td class="rightAligned">Intermediary</td>
				<td><input id="txtIntmName" name="txtIntmName" type="text" readonly="readonly" style="width: 475px;" tabindex="102"></td>
			</tr>
		</table>
		
		<div id="userDiv" name="userDiv" style="width: 570px; height: 80px; border: 1px solid #E0E0E0; margin-top: 10px;">
			<table style="width: 570px; margin-top: 10px;">
				<tr>
					<td class="rightAligned">User ID</td>
					<td><input id="txtUserId" name="txtUserId" type="text" readonly="readonly" style="width: 95%;" tabindex="103"></td>
					<td><div align="right" style="text-align: right;">Last Update</div></td>
					<td><input id="txtLastUpdate" name="txtLastUpdate" type="text" readonly="readonly" style="width: 95%;" tabindex="104"></td>
				</tr>
				<tr>
					<td class="rightAligned">Remarks</td>
					<td colspan="3"><input id="txtRemarks" name="txtRemarks" type="text" readonly="readonly" style="width: 98%;" tabindex="105"></td>
				</tr>
			</table>
		</div>
	</div>
	
	<div id="smsRenewalControlDiv" name="smsRenewalControlDiv" class="sectionDiv" style="width: 295px; float: left; margin-top: 5px;">
		<table>
			<tr>
				<td colspan="2">
					<div style="float:left; padding-left: 8px;">
						<input id="tagAll" name="tagAll" type="checkbox" tabindex="106">
					</div>
					<div style="float: left; padding-left: 3px;">
						<label for="tagAll">Tag All</label>
					</div>
				</td>
				<td colspan="2">
					<div style="float:left; padding-left: 11px;">
						<input id="untagAll" name="untagAll" type="checkbox" tabindex="107">
					</div>
					<div style="float: left; padding-left: 3px;">
						<label for="untagAll">Untag All</label>
					</div>
				</td>
			</tr>
			<tr>
				<td colspan="4" style="border-top: 1px solid #E0E0E0"></td>
			</tr>
			<tr>
				<td colspan="2">
					<input id="renewAssd" name="radioGroup" title="Renewal-Assured" value="RA" type="radio" style="float: left; margin-left: 10px;" tabindex="108">
					<label for="renewAssd">Renewal-Assured</label>
				</td>
				<td colspan="2">
					<input id="nonRenewAssd" name="radioGroup" title="Renewal-Assured" value="NRA" type="radio" style="float: left; margin-left: 13px;">
					<label for="nonRenewAssd">Non Renewal-Assured</label>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<input id="renewIntm" name="radioGroup" title="Renewal-Intm" value="RI" type="radio" style="float: left; margin-left: 10px;">
					<label for="renewIntm">Renewal-Intm</label>
				</td>
				<td colspan="2">
					<input id="nonRenewIntm" name="radioGroup" title="Non Renewal-Intm" value="NRI" type="radio" style="float: left; margin-left: 13px;">
					<label for="nonRenewIntm">Non Renewal-Intm</label>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<input id="renewal" name="radioGroup" title="Renewal" value="R" type="radio" style="float: left; margin-left: 10px;">
					<label for="renewal">Renewal</label>
				</td>
				<td colspan="2">
					<input id="nonRenewal" name="radioGroup" title="Non Renewal" value="NR" type="radio" style="float: left; margin-left: 13px;">
					<label for="nonRenewal">Non Renewal</label>
				</td>
			</tr>
		</table>
	</div>
	
	<div id="smsRenewalButtonsDiv" name="smsRenewalButtonsDiv" style="width: 300px; float: left; margin-top: 5px;">
		<table style="width: 100%">
			<tr>
				<td colspan="2"><input id="btnSendSMS" name="btnSendSMS" type="button" class="button" value="Send SMS Renewal/Non Renewal Notice" style="width: 99%;" tabindex="109"></td>
			</tr>
			<tr>
				<td><input id="btnPolicyDtls" name="btnPolicyDtls" type="button" class="button" value="Policy Details" style="width: 100%; float: left;" tabindex="110"></td>
				<td><input id="btnMessageDtls" name="btnMessageDtls" type="button" class="button" value="Message Details" style="width: 100%; float: left;" tabindex="111"></td>
			</tr>
		</table>
	</div>
	
	<div id="buttonsDiv" name="buttonsDiv" style="width: 100%; margin-top: 10px; float: left;" align="center">
		<input id="btnUpdateSMS" name="btnUpdateSMS" type="button" class="disabledButton" value="Update" style="width: 70px;" tabindex="112"/>
		<input id="btnSaveSMS" name="btnSaveSMS" type="button" class="button" value="Save" style="width: 70px;" tabindex="113"/>
	</div>
	
	<div id="hiddenDiv" name="hiddenDiv">
		<input id="hidRenewFlag" name="hidRenewFlag" type="hidden"/>
	</div>
</div>

<script type="text/javascript">
	var callingForm = nvl('${callingForm}', 'GISMS007');
	objSMSRenewal = new Object();
	objSMSRenewal.selectedIndex = -1;
	objSMSRenewal.selectedRow = "";
	
	objSMSRenewal.objSMS = [];
	objSMSRenewal.smsRenewalTableGrid = JSON.parse('${smsRenewalTableGrid}');
	objSMSRenewal.smsRenewalRows = objSMSRenewal.smsRenewalTableGrid.rows || [];
	try {
		var smsRenewalTableGridModel = {
			url: contextPath+"/GIEXExpiryController?action=showSMSRenewal&refresh=1",
			options: {
				width: '845px',
				height: '306px',
				hideColumnChildTitle: true,
				onCellFocus: function(element, value, x, y, id) {
					objSMSRenewal.selectedIndex = y;
					objSMSRenewal.selectedRow = smsRenewalTableGrid.geniisysRows[y];
					populateFields(true);
				},
				onRemoveRowFocus : function(){
					objSMSRenewal.selectedIndex = -1;
					objSMSRenewal.selectedRow = "";
					smsRenewalTableGrid.keys.removeFocus(smsRenewalTableGrid.keys._nCurrentFocus, true);
					smsRenewalTableGrid.keys.releaseKeys();
					populateFields(false);	
			  	},
			  	beforeSort: function(){
			  		if(changeTag == 1){
			  			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			  			return false;
			  		}
				},
			  	onSort : function(){
			  		smsRenewalTableGrid.onRemoveRowFocus();
			  	},
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onRefresh: function(){
						smsRenewalTableGrid.onRemoveRowFocus();
	            	},
	            	onFilter: function(){
	            		smsRenewalTableGrid.onRemoveRowFocus();
	            	},
	            	onSave: function(){
	            		saveSMS();
	            	}
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
					id: 'assdSms',
					title: '&#160;A',
	            	width: '23px',
	            	altTitle: 'Send SMS to Assured',
	            	titleAlign: 'center',
	            	sortable: false,
	            	editable: true,
	            	hideSelectAllBox: true,
	            	editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
		            		return value ? "Y" : "N";
		            	},
		            	onClick: function(value) {
		            		if(value == "Y"){
		            			checkAssured();
		            		}else{
		            			updateSMSRows();
		            		}
	 			    	}
	            	})
				},
				{
					id: 'intmSms',
					title: '&#160;&#160;I',
	            	width: '23px',
	            	altTitle: 'Send SMS to Intermediary',
	            	titleAlign: 'center',
	            	sortable: false,
	            	editable: true,
	            	hideSelectAllBox: true,
	            	editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
			            	return value ? "Y" : "N";
		            	},
		            	onClick: function(value, checked, y) {
		            		if(value == "Y"){
		            			checkIntm();
		            		}else{
		            			updateSMSRows();
		            		}
	 			    	}
	            	})
				},
				{
					id:"renewFlag",
					sortable: false,
					editable: true,
					title: '&#160;NR',
					altTitle: 'Non Renewal',
					width: '25px',
					radioGroup: 'renewFlagGroup',
					editor: new MyTableGrid.CellRadioButton({
						getValueOf: function (value){
							if (value){
								return "1";
							}
						},
						onClick: function(){
							$("hidRenewFlag").value = "1";
							updateSMSRows();
						}
					})
				},
				{
					id:"renewFlag",
					sortable:false,
					editable:true,
					title: '&#160;&#160;R',
					altTitle: 'Renewal',
					width: '25px',
					radioGroup: 'renewFlagGroup',
					editor: new MyTableGrid.CellRadioButton({
						getValueOf: function (value){
							 if (value){
								return "2";
							}
						},
						onClick: function(){
							$("hidRenewFlag").value = "2";
							updateSMSRows();
						}
					})
				},
				{
					id:"renewFlag",
					sortable:false,
					editable:true,
					title: '&#160;AR',
					altTitle: 'Auto Renewal',
					width: '26px',
					radioGroup: 'renewFlagGroup',
					editor: new MyTableGrid.CellRadioButton({
						getValueOf: function(value){
							 if (value){
								return "3";
							}
						},
						onClick: function(){
							$("hidRenewFlag").value = "3";
							updateSMSRows();
						}
					})
				},
				{
					id: 'policyNo',
					title: 'Policy No.',
					width: '196px',
					filterOption: true
				},
				{
					id: 'tsiAmt',
					title: 'TSI Amount',
					width: '132px',
					align: 'right',
					geniisysClass: 'money',
					filterOption: true,
					filterOptionType: 'number'
				},
				{
					id: 'premAmt',
					title: 'Premium Amount',
					width: '132px',
					align: 'right',
					geniisysClass: 'money',
					filterOption: true,
					filterOptionType: 'number'
				},
				{
					id: 'expiryDate',
					title: 'Expiry Date',
					width: '96px',
					align: 'center',
					type: 'date',
					format: 'mm-dd-yyyy',
					filterOption: true,
					filterOptionType: 'formattedDate'
				},
				{	
					id: 'chkSent',
					title: '&#160;S',
	            	width: '23px',
	            	altTitle: 'SMS Sent',
	            	titleAlign: 'center',
	            	sortable: false,
	            	editable: false,
	            	editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
			            	return value ? "Y" : "N";
		            	}
	            	})
				},
				{	
					id: 'smsForRenew',
					title: '&#160;&#160;Y',
	            	width: '23px',
	            	altTitle: 'SMS for Renewal',
	            	titleAlign: 'center',
	            	sortable: false,
	            	editable: false,
	            	editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
			            	return value ? "Y" : "N";
		            	}
	            	})
				},
				{	
					id: 'smsForNonRenew',
					title: '&#160;&#160;N',
	            	width: '23px',
	            	altTitle: 'SMS for Non Renewal',
	            	titleAlign: 'center',
	            	sortable: false,
	            	editable: false,
	            	editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
			            	return value ? "Y" : "N";
		            	}
	            	})
				},
				{	
					id: 'balanceFlag',
					title: '&#160;&#160;B',
	            	width: '23px',
	            	altTitle: 'With Balance Premium',
	            	titleAlign: 'center',
	            	sortable: false,
	            	editable: false,
	            	editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
			            	return value ? "Y" : "N";
		            	}
	            	})
				},
				{	
					id: 'claimFlag',
					title: '&#160;C',
	            	width: '23px',
	            	altTitle: 'Claim(s)',
	            	titleAlign: 'center',
	            	sortable: false,
	            	editable: false,
	            	editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
			            	return value ? "Y" : "N";
		            	}
	            	})
				},
				{
					id: 'lineCd',
					title: 'Line Code',
					width: '0px',
					visible: false,
					filterOption: true
				},
				{
					id: 'sublineCd',
					title: 'Subline Code',
					width: '0px',
					visible: false,
					filterOption: true
				},
				{
					id: 'issCd',
					title: 'Issue Code',
					width: '0px',
					visible: false,
					filterOption: true
				},
				{
					id: 'issueYy',
					title: 'Issue Year',
					width: '0px',
					visible: false,
					filterOption: true
				},
				{
					id: 'polSeqNo',
					title: 'Policy Sequence No',
					width: '0px',
					visible: false,
					filterOption: true
				},
				{
					id: 'renewNo',
					title: 'Renew No',
					width: '0px',
					visible: false,
					filterOption: true
				},
				{
					id: 'assdName',
					title: 'Assured Name',
					width: '0px',
					visible: false,
					filterOption: true
				},
				{
					id: 'intmName',
					title: 'Intm Name',
					width: '0px',
					visible: false,
					filterOption: true
				},
				{
					id: 'renewFlag',
					title: 'Renew Flag',
					width: '0px',
					visible: false,
					filterOption: true
				}
			],
			rows: objSMSRenewal.smsRenewalRows
		};
		smsRenewalTableGrid = new MyTableGrid(smsRenewalTableGridModel);
		smsRenewalTableGrid.pager = objSMSRenewal.smsRenewalTableGrid;
		smsRenewalTableGrid.render('smsRenewalTGDiv');
		smsRenewalTableGrid.afterRender = function(){
			objSMSRenewal.objSMS = smsRenewalTableGrid.geniisysRows;
			smsRenewalTableGrid.keys.removeFocus(smsRenewalTableGrid.keys._nCurrentFocus, true);
			smsRenewalTableGrid.keys.releaseKeys();
		};
	}catch(e) {
		showErrorMessage("smsRenewalTableGrid", e);
	}

	function populateFields(pop){
		$("txtAssdName").value = pop ? unescapeHTML2(objSMSRenewal.selectedRow.assdName) : "";
		$("txtIntmName").value = pop ? unescapeHTML2(objSMSRenewal.selectedRow.intmName) : "";
		$("txtUserId").value = pop ? unescapeHTML2(objSMSRenewal.selectedRow.userId) : "";
		$("txtLastUpdate").value = pop ? dateFormat(objSMSRenewal.selectedRow.lastUpdate, 'mm-dd-yyyy') : "";
		$("txtRemarks").value = pop ? unescapeHTML2(objSMSRenewal.selectedRow.remarks) : "";
		$("hidRenewFlag").value = pop ? unescapeHTML2(objSMSRenewal.selectedRow.renewFlag) : "";
		
		if(pop){
			enableButton("btnUpdateSMS");
			enableInputField("txtRemarks");
		}else{
			disableButton("btnUpdateSMS");
			disableInputField("txtRemarks");
		}
	}
	
	function populatePolicyNo(){
		$("policyNo").value = objSMSRenewal.selectedRow.policyNo;
	}
	objSMSRenewal.populatePolicyNo = populatePolicyNo;
	
	function showPolicyDtlsOverlay(){
		policyDtlsOverlay = Overlay.show(contextPath+"/GIEXSmsDtlController", {
			urlContent : true,
			draggable: true,
			urlParameters: {
				action    : "showPolicyDtlsOverlay",
				lineCd	  : objSMSRenewal.selectedRow.lineCd,
				sublineCd : objSMSRenewal.selectedRow.sublineCd,
				issCd     : objSMSRenewal.selectedRow.issCd,
				issueYy   : objSMSRenewal.selectedRow.issueYy,
				polSeqNo  : objSMSRenewal.selectedRow.polSeqNo,
				renewNo   : objSMSRenewal.selectedRow.renewNo
			},
		    title: "Policy Details",
		    height: 495,
		    width: 600
		});
	}
	
	function showMessageDtlsOverlay(){
		messageDtlsOverlay = Overlay.show(contextPath+"/GIEXSmsDtlController", {
			urlContent : true,
			draggable: true,
			urlParameters: {
				action   : "showMessageDtlsOverlay",
				policyId : objSMSRenewal.selectedRow.policyId
			},
		    title: "Message Details",
		    height: 475,
		    width: 600
		});
	}
	
	function checkAssured(){
		new Ajax.Request(contextPath + "/GIEXSmsDtlController",{
			parameters : {
				action   : "checkSMSAssured",
				policyId : objSMSRenewal.selectedRow.policyId,
				assdNo   : objSMSRenewal.selectedRow.assdNo
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : showNotice("Processing, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					confirmAssured(JSON.parse(response.responseText));
				}
			}
		});
	}
	
	function confirmAssured(obj){
		if(nvl(obj.assdCpNo, "") == ""){
			showWaitingMessageBox("The cellphone number of the Assured of Policy No " + objSMSRenewal.selectedRow.policyNo +
				" does not exist.", "I", function(){
				$("mtgInput"+smsRenewalTableGrid._mtgId+"_2," + objSMSRenewal.selectedIndex).checked = false;
			});
		}else{
			if(parseInt(obj.msgCount) > 0 && $("mtgInput"+smsRenewalTableGrid._mtgId+"_2," + objSMSRenewal.selectedIndex).checked){
				showConfirmBox("Confirmation", "Policy No. " + objSMSRenewal.selectedRow.policyNo + " has an existing message. " +
					"Do you want to send another message?", "Yes", "No",
					function(){
						updateSMSRows();
					},
					function(){
						$("mtgInput"+smsRenewalTableGrid._mtgId+"_2," + objSMSRenewal.selectedIndex).checked = false;
						updateSMSRows();
					});
			}else if(parseInt(obj.msgCount) == 0 && $("mtgInput"+smsRenewalTableGrid._mtgId+"_2," + objSMSRenewal.selectedIndex).checked){
				updateSMSRows();
			}
		}
	}
	
	function checkIntm(){
		new Ajax.Request(contextPath + "/GIEXSmsDtlController",{
			parameters : {
				action : "checkSMSIntm",
				policyId : objSMSRenewal.selectedRow.policyId,
				intmNo : objSMSRenewal.selectedRow.intmNo
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : showNotice("Processing, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					confirmIntm(JSON.parse(response.responseText));
				}
			}
		});
	}
	
	function confirmIntm(obj){
		if(nvl(obj.intmCpNo, "") == ""){
			showWaitingMessageBox("The cellphone number of the Intermediary of Policy No " + objSMSRenewal.selectedRow.policyNo +
				" does not exist.", "I", function(){
				$("mtgInput"+smsRenewalTableGrid._mtgId+"_3," + objSMSRenewal.selectedIndex).checked = false;
			});
		}else{
			if(parseInt(obj.msgCount) > 0 && $("mtgInput"+smsRenewalTableGrid._mtgId+"_3," + objSMSRenewal.selectedIndex).checked){
				showConfirmBox("Confirmation", "Policy No. " + objSMSRenewal.selectedRow.policyNo + " has an existing message(s). " +
					"Do you want to send another message?", "Yes", "No",
					function(){
						updateSMSRows();
					},
					function(){
						$("mtgInput"+smsRenewalTableGrid._mtgId+"_3," + objSMSRenewal.selectedIndex).checked = false;
						updateSMSRows();
					});
			}else if(parseInt(obj.msgCount) == 0 && $("mtgInput"+smsRenewalTableGrid._mtgId+"_3," + objSMSRenewal.selectedIndex).checked){
				updateSMSRows();
			}
		}
	}
	
	function tagAll(){
		var func1;
		var func2;
		var param = "";
		
		$$("input[name='radioGroup']").each(function(radio) {
			radio.checked ? param = radio.value : null;  
		});
		
		if(param == "RA"){
			func1 = checkRenewAssd;
			func2 = checkRenewAssdNoMsg;
		}else if(param == "RI"){
			func1 = checkRenewIntm;
			func2 = checkRenewIntmNoMsg;
		}else if(param == "R"){
			func1 = function(){
						checkRenewAssd(true);
						checkRenewIntm(true);
					};
			func2 = function(){
						checkRenewAssdNoMsg(true);
						checkRenewIntmNoMsg(true);
					};
		}else if(param == "NRA"){
			func1 = checkNonRenewAssd;
			func2 = checkNonRenewAssdNoMsg;
		}else if(param == "NRI"){
			func1 = checkNonRenewIntm;
			func2 = checkNonRenewIntmNoMsg;
		}else if(param == "NR"){
			func1 = function(){
				checkNonRenewAssd(true);
				checkNonRenewIntm(true);
			};
			func2 = function(){
				checkNonRenewAssdNoMsg(true);
				checkNonRenewIntmNoMsg(true);
			};
		}
		
		if(param != ""){
			showConfirmBox("Confirmation", "Do you want to include Records with existing message(s)?", "Yes", "No",
				function(){
					func1(true);
					untag();
				},
				function(){
					func2(true);
					untag();
				}, "2");
		}else{
			untag();
		}
	}
	
	function untagAll(){
		var param = "";
		
		$$("input[name='radioGroup']").each(function(radio) {
			radio.checked ? param = radio.value : null;  
		});
		
		if(param == "RA"){
			checkRenewAssd(false);
		}else if(param == "RI"){
			checkRenewIntm(false);
		}else if(param == "R"){
			checkRenewAssd(false);
			checkRenewIntm(false);
		}else if(param == "NRA"){
			checkNonRenewAssd(false);
		}else if(param == "NRI"){
			checkNonRenewIntm(false);
		}else if(param == "NR"){
			checkNonRenewAssd(false);
			checkNonRenewIntm(false);
		}
		untag();
	}
	
	function untag(){
		setTimeout(function(){
			$("tagAll").checked = false;
			$("untagAll").checked = false;
			$$("input[name='radioGroup']").each(function(radio) {
				radio.checked = false;  
			});
		}, 200);
	}
	
	function checkRenewAssd(tag){
		for(var i=0; i < objSMSRenewal.objSMS.length;  i++){
			if(nvl(objSMSRenewal.objSMS[i].postFlag, "N") == "N" && nvl(objSMSRenewal.objSMS[i].cpNo, "") != "" &&
				(objSMSRenewal.objSMS[i].renewFlag == "2" || objSMSRenewal.objSMS[i].renewFlag == "3")){
				updateSMSTags(i, tag, "assd");
			}
		}
	}
	
	function checkRenewAssdNoMsg(tag){
		for(var i=0; i < objSMSRenewal.objSMS.length;  i++){
			if(nvl(objSMSRenewal.objSMS[i].postFlag, "N") == "N" && nvl(objSMSRenewal.objSMS[i].cpNo, "") != "" &&
				nvl(objSMSRenewal.objSMS[i].withMsg, "N") == "N" && (objSMSRenewal.objSMS[i].renewFlag == "2" || objSMSRenewal.objSMS[i].renewFlag == "3")){
				updateSMSTags(i, tag, "assd");				
			}
		}
	}
	
	function checkRenewIntm(tag){
		for(var i=0; i < objSMSRenewal.objSMS.length;  i++){
			if(nvl(objSMSRenewal.objSMS[i].postFlag, "N") == "N" && nvl(objSMSRenewal.objSMS[i].intmCpNo, "") != "" &&
				(objSMSRenewal.objSMS[i].renewFlag == "2" || objSMSRenewal.objSMS[i].renewFlag == "3")){
				updateSMSTags(i, tag, "intm");	
			}
		}
	}
	
	function checkRenewIntmNoMsg(tag){
		for(var i=0; i < objSMSRenewal.objSMS.length;  i++){
			if(nvl(objSMSRenewal.objSMS[i].postFlag, "N") == "N" && nvl(objSMSRenewal.objSMS[i].intmCpNo, "") != "" &&
				nvl(objSMSRenewal.objSMS[i].withMsg, "N") == "N" && (objSMSRenewal.objSMS[i].renewFlag == "2" || objSMSRenewal.objSMS[i].renewFlag == "3")){
				updateSMSTags(i, tag, "intm");				
			}
		}
	}
	
	function checkNonRenewAssd(tag){
		for(var i=0; i < objSMSRenewal.objSMS.length;  i++){
			if(nvl(objSMSRenewal.objSMS[i].postFlag, "N") == "N" && nvl(objSMSRenewal.objSMS[i].cpNo, "") != "" &&
				objSMSRenewal.objSMS[i].renewFlag == "1"){
				updateSMSTags(i, tag, "assd");
			}
		}
	}
	
	function checkNonRenewAssdNoMsg(tag){
		for(var i=0; i < objSMSRenewal.objSMS.length;  i++){
			if(nvl(objSMSRenewal.objSMS[i].postFlag, "N") == "N" && nvl(objSMSRenewal.objSMS[i].cpNo, "") != "" &&
				nvl(objSMSRenewal.objSMS[i].intmWithMsg, "N") == "N" && objSMSRenewal.objSMS[i].renewFlag == "1"){
				updateSMSTags(i, tag, "assd");
			}
		}
	}
	
	function checkNonRenewIntm(tag){
		for(var i=0; i < objSMSRenewal.objSMS.length;  i++){
			if(nvl(objSMSRenewal.objSMS[i].postFlag, "N") == "N" && nvl(objSMSRenewal.objSMS[i].intmCpNo, "") != "" &&
				objSMSRenewal.objSMS[i].renewFlag == "1"){
				updateSMSTags(i, tag, "intm");
			}
		}
	}
	
	function checkNonRenewIntmNoMsg(tag){
		for(var i=0; i < objSMSRenewal.objSMS.length;  i++){
			if(nvl(objSMSRenewal.objSMS[i].postFlag, "N") == "N" && nvl(objSMSRenewal.objSMS[i].intmCpNo, "") != "" &&
				nvl(objSMSRenewal.objSMS[i].intmWithMsg, "N") == "N" && objSMSRenewal.objSMS[i].renewFlag == "1"){
				updateSMSTags(i, tag, "intm");
			}
		}
	}
	
	function updateSMSRows(release){
		objSMSRenewal.objSMS[objSMSRenewal.selectedIndex].recordStatus = 1;
		objSMSRenewal.objSMS[objSMSRenewal.selectedIndex].assdSms = $("mtgInput"+smsRenewalTableGrid._mtgId+"_2," + objSMSRenewal.selectedIndex).checked ? "Y" : "N";
		objSMSRenewal.objSMS[objSMSRenewal.selectedIndex].intmSms = $("mtgInput"+smsRenewalTableGrid._mtgId+"_3," + objSMSRenewal.selectedIndex).checked ? "Y" : "N";
		objSMSRenewal.objSMS[objSMSRenewal.selectedIndex].remarks = $F("txtRemarks");
		objSMSRenewal.objSMS[objSMSRenewal.selectedIndex].renewFlag = $F("hidRenewFlag");
		objSMSRenewal.objSMS.splice(objSMSRenewal.selectedIndex, 1, objSMSRenewal.objSMS[objSMSRenewal.selectedIndex]);
		smsRenewalTableGrid.updateVisibleRowOnly(objSMSRenewal.objSMS[objSMSRenewal.selectedIndex], objSMSRenewal.selectedIndex, nvl(release, "Y") == "N" ? false : true);
		changeTag = 1;
	}
	
	function updateSMSTags(row, tag, column){
		objSMSRenewal.objSMS[row].recordStatus = 1;
		if(column == "assd"){
			objSMSRenewal.objSMS[row].assdSms = tag ? "Y" : "N";
			$("mtgInput"+smsRenewalTableGrid._mtgId+"_2,"+row).checked = tag;
		}else{
			objSMSRenewal.objSMS[row].intmSms = tag ? "Y" : "N";
			$("mtgInput"+smsRenewalTableGrid._mtgId+"_3,"+row).checked = tag;
		}
		objSMSRenewal.objSMS.splice(row, 1, objSMSRenewal.objSMS[row]);
		smsRenewalTableGrid.updateVisibleRowOnly(objSMSRenewal.objSMS[row], row);
	}
	
	function sendSMS(){
		var objParams = new Object();
		objParams.setRows = getAddedAndModifiedJSONObjects(objSMSRenewal.objSMS);
		
		new Ajax.Request(contextPath+"/GIEXSmsDtlController", {
			parameters: {
				action     : "sendSMS",
				parameters : JSON.stringify(objParams)
			},
			evalScripts: true,
			asynchronous: false,
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response) {
				hideNotice();
				if(checkErrorOnResponse(response)) {
					showWaitingMessageBox("SUCCESS", "S", showSMSRenewal);
				}
			}
		});
	}
	
	function saveSMS(send){
		var objParams = new Object();
		objParams.setRows = getAddedAndModifiedJSONObjects(objSMSRenewal.objSMS);
		
		new Ajax.Request(contextPath+"/GIEXSmsDtlController", {
			parameters: {
				action     : "saveSMS",
				parameters : JSON.stringify(objParams)
			},
			evalScripts: true,
			asynchronous: false,
			onCreate : showNotice("Saving, please wait..."),
			onComplete: function(response) {
				hideNotice();
				if(checkErrorOnResponse(response)){
					changeTag = 0;
					if(nvl(send, false)){
						sendSMS();
					}else{
						showWaitingMessageBox(objCommonMessage.SUCCESS, "S", showSMSRenewal);
					}
				}
			}
		});
	}
	
	function checkTaggedRecords(){
		for(var i = 0; i < objSMSRenewal.objSMS.length; i++){
			if(nvl(objSMSRenewal.objSMS[i].assdSms, "N") == "Y" || nvl(objSMSRenewal.objSMS[i].intmSms, "N") == "Y"){
				return true;
			}
		}
		return false;
	}
	
	function showSMSRenewal(){
		try{
			new Ajax.Updater("mainContents", contextPath+"/GIEXExpiryController",{
				method: "GET",
				parameters: {
					action: "showSMSRenewal",
					moduleId: callingForm
				},
				evalScripts: true,
				asynchronous: false,
				onCreate: showNotice("Loading SMS Renewal, please wait..."),
				onComplete: function(){
					hideNotice("");
					Effect.Appear($("mainContents").down("div", 0), {duration: .001});
				}
			});
		}catch(e){
			showErrorMessage("showSMSRenewal",e);
		}
	}
	
	function exitSMSRenewal(){
		delete objSMSRenewal;
		if(callingForm == "GISMS007"){
			goToModule("/GIISUserController?action=goToSMS", "SMS Main", null);
		}else{
			showProcessExpiringPoliciesPage();
		}
	}
	
	function saveAndExit(){
		var objParams = new Object();
		objParams.setRows = getAddedAndModifiedJSONObjects(objSMSRenewal.objSMS);
		
		new Ajax.Request(contextPath+"/GIEXSmsDtlController", {
			parameters: {
				action     : "saveSMS",
				parameters : JSON.stringify(objParams)
			},
			evalScripts: true,
			asynchronous: false,
			onCreate : showNotice("Saving, please wait..."),
			onComplete: function(response) {
				hideNotice();
				if(checkErrorOnResponse(response)){
					changeTag = 0;
					showMessageBox(objCommonMessage.SUCCESS, "S");
				}
			}
		});
	}
	
	$("tagAll").observe("change", function(){
		tagAll();
	});
	
	$("untagAll").observe("change", function(){
		untagAll();
	});
	
	$("btnSendSMS").observe("click", function(){
		if(checkTaggedRecords()){
			saveSMS(true);
		}else{
			showMessageBox("There are no checked SMS for sending.", "I");
		}
	});
	
	$("btnPolicyDtls").observe("click", function(){
		if(objSMSRenewal.selectedIndex == -1){
			showMessageBox("Please select a policy first.", "I");
		}else{
			smsRenewalTableGrid.keys.removeFocus(smsRenewalTableGrid.keys._nCurrentFocus, true);
			smsRenewalTableGrid.keys.releaseKeys();
			showPolicyDtlsOverlay();
		}
	});
	
	$("btnMessageDtls").observe("click", function(){
		if(objSMSRenewal.selectedIndex == -1){
			showMessageBox("Please select a policy first.", "I");
		}else{
			smsRenewalTableGrid.keys.removeFocus(smsRenewalTableGrid.keys._nCurrentFocus, true);
			smsRenewalTableGrid.keys.releaseKeys();
			showMessageDtlsOverlay();
		}
	});
	
	$("btnUpdateSMS").observe("click", function(){
		updateSMSRows("N");
		smsRenewalTableGrid.onRemoveRowFocus();
	});
	
	changeTag = 0;
	initializeAll();
	$("txtAssdName").focus();
	setModuleId("GISMS007");
	setDocumentTitle("SMS Renewal");
	observeSaveForm("btnSaveSMS", saveSMS);
	observeReloadForm("reloadForm", showSMSRenewal);
	observeCancelForm("btnExit", saveAndExit, exitSMSRenewal);
</script>