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
					<input type="text" id="txtBankCd" name="txtBankCd" ignoreDelKey="1" style="width: 43px; float: left; border: none; height: 13px;" class="disableDelKey allCaps required" maxlength="3" tabindex="101" />
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
					<input type="text" id="txtBankAcctCd" name="txtBankAcctCd" ignoreDelKey="1" style="width: 43px; float: left; border: none; height: 13px;" class="disableDelKey allCaps required" maxlength="4" tabindex="103" />
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
	var arrayPdcId = JSON.parse('${objectParams}');
	loop = arrayPdcId.group.length;
	index = 0;

	function closeOverlay(){
		overlayBank.close();
		delete overlayBank;
	}
	
	$("btnCancel").observe("click", function(){
		closeOverlay();
	});
	
	$("searchBankCd").observe("click",function(){
		showBankCdLOV("%");
	});
	
	$("txtBankCd").observe("change", function(){
		if($F("txtBankCd") != ""){
			showBankCdLOV($F("txtBankCd"));
		} else {
			$("txtBankDesc").value = "";
			$("txtBankCd").setAttribute("lastValidValue", "");
			$("txtBankDesc").setAttribute("lastValidValue", "");
		}
	});
	
	function showBankCdLOV(x){
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					  action : "getGiacs091BankCdLOV",
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
						$("txtBankCd").setAttribute("lastValidValue",unescapeHTML2(row.bankCd));
						$("txtBankDesc").setAttribute("lastValidValue",unescapeHTML2(row.bankName));
						
						$("txtBankAcctCd").clear(); //added by jdiago 07312014 : different bank cd means different bank acct cd. 
						$("txtBankAcctNo").clear(); //added by jdiago 07312014 : different bank cd means different bank acct cd.
					}
				},
				onCancel: function(){
					$("txtBankCd").focus();
					$("txtBankCd").value = $("txtBankCd").getAttribute("lastValidValue");
					$("txtBankDesc").value = $("txtBankDesc").getAttribute("lastValidValue");
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
				controller : "AccountingLOVController",
				urlParameters : {
					  action : "getGiacs091BankAcctLOV",
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
					$("txtBankAcctCd").value = $("txtBankAcctCd").getAttribute("lastValidValue");
					$("txtBankAcctNo").value = $("txtBankAcctNo").getAttribute("lastValidValue");
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
		if(checkAllRequiredFieldsInDiv("applyBankDiv")){//added by jdiago 07312014 : check empty required fields.
			getDcbNo();	
		}
	});
	
	
	function multipleOr(){
		if(loop == 0){
			closeOverlay();
			tbgChecksTable._refreshList();
		} else {
			processMultipleOr(arrayPdcId.group[index]);
		}
		
	}
	
	function processMultipleOr(pcdId){
		new Ajax.Request(contextPath+"/GIACApdcPaytDtlController", {
			method: "POST",
			parameters : {
							action : "multipleOR",
							bankCd: $F("txtBankCd"),
							bankAcctCd: $F("txtBankAcctCd"),
							checkDate: arrayPdcId.checkDate,
							pdcId: pcdId
						},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					showWaitingMessageBox(obj.message, imgMessage.INFO, function(){
						index = index + 1;
						loop = loop - 1;
						multipleOr();
					});
				}
			}
		});
	}
	
	function groupOr(){
		new Ajax.Request(contextPath+"/GIACApdcPaytDtlController", {
			method: "POST",
			parameters : {
							action : "groupOr",
							bankCd: $F("txtBankCd"),
							bankAcctCd: $F("txtBankAcctCd"),
							checkDate: arrayPdcId.checkDate,
							group: prepareJsonAsParameter(arrayPdcId.group)
						},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					showWaitingMessageBox(obj.message, imgMessage.INFO, function(){
						closeOverlay();
						tbgChecksTable._refreshList();
					});
				}
			}
		});
	}
	
	function getDcbNo(){
		new Ajax.Request(contextPath+"/GIACApdcPaytDtlController", {
			method: "POST",
			parameters : {
							action : "validateDcbNo",
							pdcId: arrayPdcId.group[0],
							checkDate: arrayPdcId.checkDate
						},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(obj.message != null){
						showConfirmBox("Confirmation",obj.message + " Create one?" , "Yes", "No",
								function(){
									createDbcNo();
								},
								function(){
									showWaitingMessageBox("Cannot create an O.R. without a DCB No.", imgMessage.INFO, function(){
										null;
									});
								}
						);
					} else {
						createOr();
					}
				}
			}
		});
	}
	
	function createDbcNo(){
		new Ajax.Request(contextPath+"/GIACApdcPaytDtlController", {
			method: "POST",
			parameters : {
							action : "createDbcNo",
							pdcId: arrayPdcId.group[0],
							checkDate: arrayPdcId.checkDate
						},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					createOr();
				}
			}
		});
	}
	
	function createOr(){
		if(arrayPdcId.applyMode == "M"){
			multipleOr();
		} else if (arrayPdcId.applyMode == "G"){
			groupOr();
		}
	}
	
	function getDefaultBank(){
		new Ajax.Request(contextPath+"/GIACApdcPaytDtlController", {
			method: "POST",
			parameters : {
							action : "giacs091DefaultBank",
							pdcId: arrayPdcId.group[0]
						},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					$("txtBankCd").value = unescapeHTML2(obj.bankCd);
					$("txtBankDesc").value = unescapeHTML2(obj.bankName);
					$("txtBankCd").setAttribute("lastValidValue",unescapeHTML2(obj.bankCd));
					$("txtBankDesc").setAttribute("lastValidValue",unescapeHTML2(obj.bankName));
					
					$("txtBankAcctCd").value = unescapeHTML2(obj.bankAcctCd);
					$("txtBankAcctNo").value = unescapeHTML2(obj.bankAcctNo);
					$("txtBankAcctCd").setAttribute("lastValidValue",unescapeHTML2(obj.bankAcctCd));
					$("txtBankAcctNo").setAttribute("lastValidValue",unescapeHTML2(obj.bankAcctNo));
				}
			}
		});
	}
	
	getDefaultBank();
</script>