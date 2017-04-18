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
					<input type="text" id="txtBankCd" name="txtBankCd" ignoreDelKey="1" style="width: 43px; float: left; border: none; height: 13px;" class="disableDelKey allCaps required rightAligned" maxlength="3" tabindex="101" />
					<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBankCd" name="searchBankCd" alt="Go" style="float: right;">
				</span> 
				<span class="lovSpan" style="border: none; height: 21px; margin: 0 2px 0 2px; float: left;">
					<input type="text" id="txtBankDesc" name="txtBankDesc" ignoreDelKey="1" style="width: 250px; float: left; height: 15px;" class="allCaps" readonly="readonly" tabindex="102" />
				</span>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width:100px;">Bank Account&nbsp;&nbsp;</td>
			<td class="leftAligned" style="width:350px;">
				<span class="lovSpan required" style="width: 70px; height: 21px; margin: 2px 2px 0 0; float: left;">
					<input type="text" id="txtBankAcctCd" name="txtBankAcctCd" ignoreDelKey="1" style="width: 43px; float: left; border: none; height: 13px;" class="disableDelKey allCaps required rightAligned" maxlength="4" tabindex="103" />
					<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBankAcctNo" name="searchBankAcctNo" alt="Go" style="float: right;">
				</span> 
				<span class="lovSpan" style="border: none; height: 21px; margin: 0 2px 0 2px; float: left;">
					<input type="text" id="txtBankAcctNo" name="txtBankAcctNo" ignoreDelKey="1" style="width: 250px; float: left; height: 15px;" class="allCaps" readonly="readonly" tabindex="104" />
				</span>
			</td>
		</tr>
	</table>
</div>
<div align="center">
	<input type="button" class="button" value="Ok" id="btnOk" style="margin-top: 10px; width: 100px;" />
	<input type="button" class="button" value="Cancel" id="btnCancel" style="margin-top: 10px; width: 100px;" />
</div>
<script type="text/javascript">
	$("btnCancel").observe("click", closeOverlay);
	objectOr = JSON.parse('${object}'); //nieko Accounting Uploading, replace object to objectOr, to avoid conflict on previous module
	hasCCFunction = '${hasCCFunction}';
	hasAUFunction = '${hasAUFunction}';
	
	$("txtBankCd").value = unescapeHTML2(objectOr.dcbBankCd);
	$("txtBankDesc").value = unescapeHTML2(objectOr.dcbBankName);
	$("txtBankAcctCd").value = unescapeHTML2(objectOr.dcbBankAcctCd);
	$("txtBankAcctNo").value = unescapeHTML2(objectOr.dcbBankAcctNo);
	
	
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
		if(checkAllRequiredFieldsInDiv("applyBankDiv")){
			checkDcbNo();
		}
	});
	
	function checkDcbNo() {
		try {
			new Ajax.Request(
					contextPath + "/GIACUploadingController",
					{
						method : "POST",
						parameters : {
							action : "checkDcbNoGiacs604",
							branchCd : objGIACS604.branchCd,
							orDate : $F("txtOrDate")
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
	
	function checkClaim(){
		new Ajax.Request(contextPath+"/GIACUploadingController", {
			method: "POST",
			parameters : {action : "checkForClaim",
						sourceCd : $F("txtSourceCdGiacs604"),
						fileNo : $F("txtFileNoGiacs604"),
						moduleId : "GIACS604"
					 	  },
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				 if(checkErrorOnResponse(response)){
					 if (response.responseText.include("Geniisys Exception")){
						var message = response.responseText.split("#"); 
						showConfirmBox2("Confirmation",message[2], "Yes", "No",
							function(){
								if(hasCCFunction == "Y"){
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
							},
							""
						);
					} else {
						checkOverride();
					}
				 } 
			}
		});
	}
	
	function checkOverride(){
		new Ajax.Request(contextPath+"/GIACUploadingController", {
			method: "POST",
			parameters : {action : "checkForOverride",
						sourceCd : $F("txtSourceCdGiacs604"),
						fileNo : $F("txtFileNoGiacs604"),
						moduleId : "GIACS604"
					 	  },
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					 if (response.responseText.include("Geniisys Exception")){
						var message = response.responseText.split("#");
						showConfirmBox2("Confirmation",message[2], "Yes", "No",
							function(){
								showGenericOverride("GIACS604", "UA",
									function(ovr, userId, res){
										if(res == "FALSE"){
											showMessageBox(userId + " does not have an overriding function for this module.", imgMessage.ERROR);
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
							},
							""
						);
					 } else {
						 uploadPayments();
					 }
				}
			}
		});
	}
	
	function uploadPayments(){
		new Ajax.Request(contextPath+"/GIACUploadingController", {
			method: "GET",
			parameters : {action : "giacs604UploadPayments",
						branchCd : objectOr.branchCd,
						sourceCd : $F("txtSourceCdGiacs604"),
						fileNo : $F("txtFileNoGiacs604"),
						orDate : $F("txtOrDate"),
						paymentDate: objectOr.paymentDate,
						tranClass : "COL",
						dcbBankCd : $F("txtBankCd"),
						dcbBankAcctCd : $F("txtBankAcctCd"),
					 	  },
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					//showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS); // nieko --nieko Accounting Uploading GIACS604
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						showGiacs604();
						closeOverlay();
					});
				}
			}
		});
	}
	
	//nieko Accounting Uploading GIACS604, added reload form
	function showGiacs604(){
		new Ajax.Updater("process", contextPath+"/GIACUploadingController",{
			parameters:{
				action: "showGiacs604",
				sourceCd: $("txtSourceCdGiacs604").value,
				fileNo: $("txtFileNoGiacs604").value
			},
			asynchronous: false,
			evalScripts: true, 
			onCreate: showNotice("Loading, please wait..."),
			onComplete: function(response){
				hideNotice();
				if (checkErrorOnResponse(response)) {
					$("convertFileMainDiv").hide();
					$("process").show();
				}	
			}
		});
	}
</script>