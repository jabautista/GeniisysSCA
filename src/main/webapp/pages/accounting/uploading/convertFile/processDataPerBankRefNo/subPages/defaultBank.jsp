<div id="applyBankDiv" class="sectionDiv" style="padding-top:20px; padding-bottom: 20px; width: 450px;">
	<table cellspacing="0" style="width: 432px;">
		<tr>
			<th colspan="2">Enter the bank account in which the collection will be deposited.</th>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width:100px;">Bank&nbsp;&nbsp;</td>
			<td class="leftAligned" style="width:350px;">
				<span class="lovSpan required" style="width: 70px; height: 21px; margin: 2px 2px 0 0; float: left;">
					<input type="text" id="txtBankCd" name="txtBankCd" ignoreDelKey="1" style="width: 43px; float: left; border: none; height: 13px;" class="disableDelKey allCaps required rightAligned" maxlength="3" tabindex="3001" /> <!-- Deo [10.06.2016]: change tabindex from 101 to 3001 -->
					<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBankCd" name="searchBankCd" alt="Go" style="float: right;">
				</span> 
				<span class="lovSpan" style="border: none; height: 21px; margin: 0 2px 0 2px; float: left;">
					<input type="text" id="txtBankDesc" name="txtBankDesc" ignoreDelKey="1" style="width: 250px; float: left; height: 15px;" class="allCaps" readonly="readonly" tabindex="3002" /> <!-- Deo [10.06.2016]: change tabindex from 102 to 3002 -->
				</span>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width:100px;">Bank Account&nbsp;&nbsp;</td>
			<td class="leftAligned" style="width:350px;">
				<span class="lovSpan required" style="width: 70px; height: 21px; margin: 2px 2px 0 0; float: left;">
					<input type="text" id="txtBankAcctCd" name="txtBankAcctCd" ignoreDelKey="1" style="width: 43px; float: left; border: none; height: 13px;" class="disableDelKey allCaps required rightAligned" maxlength="4" tabindex="3003" /> <!-- Deo [10.06.2016]: change tabindex from 103 to 3003 -->
					<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBankAcctNo" name="searchBankAcctNo" alt="Go" style="float: right;">
				</span> 
				<span class="lovSpan" style="border: none; height: 21px; margin: 0 2px 0 2px; float: left;">
					<input type="text" id="txtBankAcctNo" name="txtBankAcctNo" ignoreDelKey="1" style="width: 250px; float: left; height: 15px;" class="allCaps" readonly="readonly" tabindex="3004" /> <!-- Deo [10.06.2016]: change tabindex from 104 to 3004 -->
				</span>
			</td>
		</tr>
	</table>
	<div align="center">
		<input type="button" class="button" value="Ok" id="btnOk" style="margin-top: 10px; width: 100px;" />
		<input type="button" class="button" value="Cancel" id="btnCancel" style="margin-top: 10px; width: 100px;" />
	</div>
</div>
<script type="text/javascript">
	$("btnCancel").observe("click", closeOverlay);
	object = JSON.parse('${object}');
	hasCCFunction = '${hasCCFunction}';
	hasAUFunction = '${hasAUFunction}';
	
	$("txtBankCd").value = unescapeHTML2(object.dcbBankCd);
	$("txtBankDesc").value = unescapeHTML2(object.dcbBankName);
	$("txtBankAcctCd").value = unescapeHTML2(object.dcbBankAcctCd);
	$("txtBankAcctNo").value = unescapeHTML2(object.dcbBankAcctNo);
	
	
	function closeOverlay(){
		overlayBank.close();
		delete overlayBank;
	}
	
	$("searchBankCd").observe("click",function(){
		showBankCdLOV("%");
	});
	
	$("txtBankCd").observe("change", function(){
		if($F("txtBankCd") != ""){
			showBankCdLOV($F("txtBankCd"));
		} else {
			$("txtBankDesc").value = "";
			$("txtBankAcctCd").value = "";
			$("txtBankAcctNo").value = "";
			$("txtBankAcctCd").setAttribute("lastValidValue", "");
			$("txtBankAcctNo").setAttribute("lastValidValue", "");
			$("txtBankCd").setAttribute("lastValidValue", "");
			$("txtBankDesc").setAttribute("lastValidValue", "");
		}
	});
	
	function showBankCdLOV(x){
		try{
			LOV.show({
				controller : "ACUploadingLOVController",
				urlParameters : {
					  action : "getGiacs603BankCdLOV",
					  search : x,
						page : 1
				},
				title: "List of Banks",
				width: 400,
				height: 400,
				columnModel: [
		 			{
						id : 'bankCd',
						title: 'Bank Cd',
						width : '90px',
						align: 'left'
					},
					{
						id : 'bankName',
						title: 'Bank Name',
					    width: '285px',
					    align: 'left'
					}
				],
				autoSelectOneRecord : true,
				filterText: nvl(escapeHTML2(x), "%"), 
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtBankCd").value = unescapeHTML2(row.bankCd);
						$("txtBankDesc").value = unescapeHTML2(row.bankName);
						$("txtBankCd").setAttribute("lastValidValue", unescapeHTML2(row.bankCd));
						$("txtBankDesc").setAttribute("lastValidValue", unescapeHTML2(row.bankName));
						
						$("txtBankAcctCd").clear();
						$("txtBankAcctNo").clear();
					}
				},
				onCancel: function(){
					$("txtBankCd").focus();
		  		},
		  		onUndefinedRow: function(){
		  			$("txtBankCd").value = $("txtBankCd").getAttribute("lastValidValue");
					$("txtBankDesc").value = $("txtBankDesc").getAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtBankCd");
		  		}
			});
		}catch(e){
			showErrorMessage("showBankCdLOV",e);
		}
	}
	
	$("searchBankAcctNo").observe("click",function(){
		showBankAcctLOV("%");
	});
	
	$("txtBankAcctCd").observe("change", function(){
		if($F("txtBankAcctCd") != ""){
			showBankAcctLOV($F("txtBankAcctCd"));
		} else {
			$("txtBankAcctNo").value = "";
			$("txtBankAcctCd").setAttribute("lastValidValue", "");
			$("txtBankAcctNo").setAttribute("lastValidValue", "");
		}
	});
	
	function showBankAcctLOV(x){
		try{
			LOV.show({
				controller : "ACUploadingLOVController",
				urlParameters : {
					  action : "getGiacs603BankAcctLOV",
					  search : x,
					  bankCd : $F("txtBankCd"),
						page : 1
				},
				title: "List of Bank Accounts",
				width: 400,
				height: 400,
				columnModel: [
		 			{
						id : 'bankAcctCd',
						title: 'Bank Acct Cd',
						width : '90px',
						align: 'left'
					},
					{
						id : 'bankAcctNo',
						title: 'Bank Acct No',
					    width: '285px',
					    align: 'left'
					}
				],
				autoSelectOneRecord : true,
				filterText: nvl(escapeHTML2(x), "%"), 
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtBankAcctCd").value = unescapeHTML2(row.bankAcctCd);
						$("txtBankAcctNo").value = unescapeHTML2(row.bankAcctNo);
						$("txtBankAcctCd").setAttribute("lastValidValue",unescapeHTML2(row.bankAcctCd));
						$("txtBankAcctNo").setAttribute("lastValidValue",unescapeHTML2(row.bankAcctNo));
					}
				},
				onCancel: function(){;
					$("txtBankAcctCd").focus();
		  		},
		  		onUndefinedRow: function(){
		  			$("txtBankAcctCd").value = $("txtBankAcctCd").getAttribute("lastValidValue");
					$("txtBankAcctNo").value = $("txtBankAcctNo").getAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtBankCd");
		  		}
			});
		}catch(e){
			showErrorMessage("showBankAcctLOV",e);
		}
	}
	
	$("btnOk").observe("click", function(){
		if ($F("txtBankCd") == ""){
			customShowMessageBox ('Please enter DCB bank code.', imgMessage.INFO, "txtBankCd");
		} else if ($F("txtBankAcctCd") == ""){
			customShowMessageBox("Please enter DCB bank code", imgMessage.INFO, "txtBankAcctCd");
		} else {
			//checkClaim(); //Deo [10.06.2016]: comment out
			checkDcbNo(); //Deo [10.06.2016]
		}
	});
	
	/* function checkDcbNo(){
		new Ajax.Request(contextPath+"/GIACUploadingController", {
			method: "POST",
			parameters : {action : "checkDcbNoGiacs610",
							branchCd : objGIACS610.branchCd, 
							fileNo: guf.fileNo,
							sourceCd: guf.sourceCd 
					 	  },
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if (response.responseText.include("Geniisys Exception")){
					if (response.responseText.include("There is no open DCB No. dated")){
						var message = response.responseText.split("#"); 
						showConfirmBox("Confirmation", message[2], "Yes", "No",
								function(){
									checkClaim();
								}, 
								showMessageBox("Cannot create an O.R. without a DCB No.",imgMessage.ERROR)
						);
					} else {
						var message = response.responseText.split("#"); 
						showMessageBox(message[2], message[1]);
					}
				} 
			}
		});
	} */
	
	/* function checkClaim(){
		for ( var i = 0; i < tbgGiacs610Table.geniisysRows.length; i++) {
			if (tbgGiacs610Table.geniisysRows[i].premChkFlag == "WC" ||
				tbgGiacs610Table.geniisysRows[i].premChkFlag == "PC" ||
				tbgGiacs610Table.geniisysRows[i].premChkFlag == "FC" ||
				tbgGiacs610Table.geniisysRows[i].premChkFlag == "OC" ||
				tbgGiacs610Table.geniisysRows[i].premChkFlag == "VC"){
				if (hasCCFunction == "Y"){
					checkOverride();
				} else {
					showGenericOverride("GIACS007", "CC",
							function(ovr, userId, res){
								if(res == "FALSE"){
									showMessageBox(userId + " is not allowed to process collections for policies with existing claim.", imgMessage.ERROR);
									$("txtOverrideUserName").clear();
									$("txtOverridePassword").clear();
									return false;
								} else if(res == "TRUE"){
									checkOverride();
									ovr.close();
									delete ovr;
								}
							},
							null
					);
				}
				break;
		}
	}
	
	function checkOverride(){
		for ( var i = 0; i < tbgGiacs610Table.geniisysRows.length; i++) {
			if (tbgGiacs610Table.geniisysRows[i].premChkFlag != "OK" ||
				tbgGiacs610Table.geniisysRows[i].premChkFlag != "VN" ||
				tbgGiacs610Table.geniisysRows[i].premChkFlag != "PT" ||
				tbgGiacs610Table.geniisysRows[i].premChkFlag != "OP" ){
				if (hasAUFunction == "Y"){
					uploadPayments();
				} else {
					showGenericOverride("GIACS610", "UA",
							function(ovr, userId, res){
								if(res == "FALSE"){
									showMessageBox(userId + " is not allowed to process collections for policies with existing claim.", imgMessage.ERROR);
									$("txtOverrideUserName").clear();
									$("txtOverridePassword").clear();
									return false;
								} else if(res == "TRUE"){
									uploadPayments();
									ovr.close();
									delete ovr;
								}
							},
							null
					);
				}
				break;
		}
	} */ //Deo [10.06.2016]: comment out
	
	function uploadPayments(){
		new Ajax.Request(contextPath+"/GIACUploadingController", {
			method: "POST",
			parameters : {action : "uploadPaymentsGiacs610",
							fileNo: guf.fileNo,
							sourceCd: guf.sourceCd,
							bankCd : $F("txtBankCd"),
							bankAcctCd :$F("txtBankAcctCd"),
							processAll : processAll, //Deo [10.06.2016]
							recId : recIdStr //Deo [10.06.2016]
					 	  },
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					//showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, closeOverlay); //Deo [10.06.2016]: comment out
					//Deo [10.06.2016]: add start
					showWaitingMessageBox("Uploading completed successfully.", imgMessage.SUCCESS, closeOverlay);
					if (processAll == "N") {
						fireEvent($("btnReturn"), "click");
					}
					fireEvent($("reloadForm"), "click");
					//Deo [10.06.2016]: add ends
				}
			}
		});
	}
	
	//Deo [10.06.2016]: add start
	var taggedRows = [];
	var processAll = '${processAll}';
	var objTaggedRows = "";
	var valid = true;
	var hasClaim = false;
	var recIdStr = "";
	
	if (processAll == "N") {
		objTaggedRows = JSON.parse('${taggedRows}');
		populateTaggedRows();
	}

	function populateTaggedRows() {
		for (var i = 0; i < objTaggedRows.rows.length; i++) {
	 		taggedRows.push(objTaggedRows.rows[i]);
	 		if (objTaggedRows.rows[i].validSw == "N"){
				valid = false;
			}
			if (objTaggedRows.rows[i].claimSw == "Y"){
				hasClaim = true;
			}
			if (i == 0){
				recIdStr = objTaggedRows.rows[i].recId;
			} else {
				recIdStr = recIdStr + "," +objTaggedRows.rows[i].recId;
			}
		}
 	}

	function checkDcbNo() {
		try {
			new Ajax.Request(
					contextPath + "/GIACUploadingController",
					{
						method : "POST",
						parameters : {
							action : "checkDcbNoGiacs610",
							branchCd : objGIACS610.branchCd,
							fileNo : guf.fileNo,
							sourceCd : guf.sourceCd
						},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response) {
							hideNotice();
							if (checkCustomErrorOnResponse(response)
									&& checkErrorOnResponse(response)) {
								if (response.responseText != "SUCCESS") {
									var arrMessage = response.responseText.split("#");
									var createDcb = "N";
									message = arrMessage[1] + " Create one?";
									showConfirmBox2("Create DCB No.", message, "Yes", "No",
											function() {
												message = arrMessage[1].replace("There is no open",
																"Before continuing, please make sure no one else is creating a")
														+ " Continue?";
												showConfirmBox2("Create DCB No.", message, "Yes", "No",
														function() {
															checkClaim();
														},
														function() {
															showMessageBox("Cannot create an O.R. without a DCB No.", imgMessage.INFO);
															closeOverlay();
														});
											},
											function() {
												showMessageBox("Cannot create an O.R. without a DCB No.", imgMessage.INFO);
												closeOverlay();
											});
								} else {
									checkClaim();
								}
							}
						}
					});
		} catch (e) {
			showErrorMessage("checkDcbNo", e);
		}
	}
	
	function checkClaim() {
		if (hasClaim) {
			showConfirmBox2("Confirmation",
					"Data to be processed contains at least one policy with existing claim. Would you like to continue with the processing?",
					"Yes", "No",
					function() {
						if (hasCCFunction == "N") {
							showConfirmBox2("Confirmation", "User is not allowed to process collections for policies with claim. Would you like to override?",
									"Yes", "No",
									function() {
										callOverride("GIACS007", "CC", "Override Claim",
												" is not allowed to process collections for policies with existing claim.");
									}, null);
						} else {
							checkInvalid();
						}
					}, null);
		} else {
			checkInvalid();
		}
	}

	function checkInvalid() {
		if (!valid && hasAUFunction == "N") {
			showConfirmBox2("Confirmation", "User is not allowed to process invalid records. Would you like to override?", "Yes", "No",
					function() {
						callOverride("GIACS610", "UA", "Override Upload All",
								" does not have an overriding function for this module.");
					}, null);
		} else {
			uploadPayments();
		}
	}

	function callOverride(moduleId, functionCd, title, message) {
		showGenericOverride(moduleId, functionCd,
				function(ovr, userId, res) {
					if (res == "FALSE") {
						showMessageBox(userId + message, imgMessage.INFORMATION);
						$("txtOverrideUserName").clear();
						$("txtOverridePassword").clear();
						return false;
					} else if (res == "TRUE") {
						if (moduleId == "GIACS007") {
							checkInvalid();
						} else {
							uploadPayments();
						}
						ovr.close();
						delete ovr;
					}
				}, null, title);
	}
	
	$("applyBankDiv").observe("keydown", function(event){
		var curEle = document.activeElement.id;
		if (event.keyCode == 9 && !event.shiftKey) {
			if (curEle == "btnCancel") {
				$("txtBankCd").focus();
				event.preventDefault();
			}
		} else if (event.keyCode == 9 && event.shiftKey) {
			if (curEle == "txtBankCd") {
				$("btnCancel").focus();
				event.preventDefault();
			}
		}
	});
	//Deo [10.06.2016]: add ends
</script>