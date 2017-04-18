<div id="bankPaymentDetails">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Bank Payment Details</label>
				<span class="refreshers" style="margin-top: 0;">
					<label id="showBankPaymentDetails" name="gro" style="margin-left: 5px;">Show</label>
				</span>
		</div>
	</div>	
	<div id="bankPaymentDetailsInfo" style="display: none;">
		<div class="sectionDiv">
			<table width="100%" border="0" style="margin-top:10px; margin-bottom:10px;">
				<tr>
					<td class="rightAligned" width="30%">Company</td>
					<td class="leftAligned">
						<select id="companyCd" name="companyCd" style="width: 450px;" >
							<option value=""></option>
						</select>
					</td>
					</tr>
					<tr>
					<td class="rightAligned">Employee</td>
					<td class="leftAligned">
						<select id="employeeCd" name="employeeCd" style="width: 450px;" >
							<option value="" empNo="" masterEmpNo=""></option>	
						</select>
					</td>
				</tr>
			</table>	
		</div>	
		<div class="sectionDiv" changeTagAttr="true"> <!-- added  changeTagAttr="true" by gab 10.06.2016 SR 3147,3027,2645,2681,3148,3206,3264,3010 -->	
			<table width="100%" border="0" style="margin-top:10px; margin-bottom:10px;">	
				<tr>
					<td class="rightAligned" width="30%">Bank Reference Number</td>
					<td class="leftAligned" style="width:325px;">
						<input style="text-align:right; width:60px;" type="hidden" id="otherChanges" name="otherChanges" value="0" readonly="readonly"/> 
						<input style="text-align:right; width:60px;" type="hidden" id="swBankRefNo" name="swBankRefNo" value="${empty gipiWPolbas.bankRefNo ? 'N' : 'Y'}" readonly="readonly"/> 
						<input style="text-align:right; width:60px;" type="hidden" id="bankRefNo" name="bankRefNo" value="${gipiWPolbas.bankRefNo}" readonly="readonly"/> 
						<input style="text-align:right; width:60px;" type="text" id="nbtAcctIssCd" name="nbtAcctIssCd" value="01" maxlength="2" class="integerUnformattedNoComma" errorMsg="Entered issue code is invalid. Valid value is from 01 to 99"/> 
						<input style="text-align:right; width:70px;" type="text" id="nbtBranchCd" name="nbtBranchCd" value="0000" maxlength="4" class="integerUnformattedNoComma" errorMsg="Entered branch code is invalid. Valid value is from 0000 to 9999"/>
						<input style="text-align:right; width:90px;" type="text" id="dspRefNo" name="dspRefNo" value="" maxlength="7" readonly="readonly"/>
						<input style="text-align:right; width:60px;" type="text" id="dspModNo" name="dspModNo" value="" maxlength="2" readonly="readonly"/>
					</td>
					<td class="leftAligned">
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="bankRefNoLOVDate" name="bankRefNoLOVDate" alt="Go"/>
						<input type="button" class="button" id="btnGenerateBankDtls" name="btnGenerateBankDtls" value="Generate" style="width:95px;"/> <!-- removed noChangeTagAttr by gab 10.06.2016 SR 3147,3027,2645,2681,3148,3206,3264,3010 -->
					</td>
					</tr>
				<!-- <tr>
					<td class="rightAligned">&nbsp;</td>
					<td class="leftAligned">
						<input style="float: left;" type="checkbox" id="generateBankDtls" name="generateBankDtls" title="Generate" alt="Generate" value="Y">
						<label for="generateBankDtls">&nbsp;Generate</label>
					</td>
				</tr>-->
			</table>	
		</div>
	</div>			
</div>

<script type="text/JavaScript">
	//for Bank payment details
	var companyLOV = {};
	var employeeLOV = {};
	var reqRefNum = ('${reqRefNo}'); //added by gab 10.07.2016
	
	if ($F("globalLineCd") != "SU" && objUWGlobal.menuLineCd != "SU")
		objUW.hidObjGIPIS002.genBankRefNoTag = $F("swBankRefNo"); //added by Jdiago 09.09.2014
		
	if ($F("globalLineCd") != "SU" && objUWGlobal.menuLineCd != "SU"){
		companyLOV = objUW.hidObjGIPIS002.companyLOV;
		employeeLOV = objUW.hidObjGIPIS002.employeeLOV;
	}else{
		if (objUWParList.parType == "E") {	//added by Gzelle 12042014 SR3092
			companyLOV = '${companyListingJSON}';
			employeeLOV = '${employeeListingJSON}';
		}else {
			companyLOV = objUW.hidObjGIPIS017.companyLOV;
			employeeLOV = objUW.hidObjGIPIS017.employeeLOV;
		}
	}	
	
	updateCompanyLOV(companyLOV, ('${gipiWPolbas.companyCd}'));
	updateEmployeeLOV(true, employeeLOV, ('${gipiWPolbas.employeeCd}'));
	$("companyCd").observe("change", function(){
		updateEmployeeLOV(false , employeeLOV, "");
		checkCompanyEmployee();
	});	
	$("employeeCd").observe("change", function(){
		if ($("employeeCd").value == ""){
			updateEmployeeLOV(false , employeeLOV, "");	
		}else{	
			$("companyCd").value = getListAttributeValue("employeeCd","masterEmpNo");
			checkCompanyEmployee();
			updateEmployeeLOV(true , employeeLOV, $("employeeCd").value);	
		}
	});
	checkCompanyEmployee();

	var genBtn=false;
	function generateBankDtls(){
		if ($F("swBankRefNo") == "Y") return false;
		genBtn=true;
		if ($F("nbtBranchCd") != 0){
			customShowMessageBox("This module does not generate bank reference numbers with branch code not equal to 0.", imgMessage.ERROR, "nbtBranchCd");
			genBtn=false;	
			return false;
		}
		showConfirmBox("Confirmation", "This would commit changes along with the generated bank reference number with acct. issue cd =  "+$F("nbtAcctIssCd")+".<br /> Do you wish to continue? (branch cd = 0000)",  
			"Yes", "No", onOkFunc, onCancelFunc);
		function onOkFunc(){
			var url = "";
			if('${isPack}' == "Y"){ // condition added by: nica for Package PAR Bank Payment Details
				url = contextPath+"/GIPIPackParInformationController?action=generateBankRefNo";
			}else{
				url = contextPath+"/GIPIParInformationController?action=genBankDetails";
			}
			
			new Ajax.Request(url,{
				method: "POST",
				parameters:{
					parId: $F("globalParId"),
					lineCd: $F("globalLineCd"),
					issCd: $F("globalIssCd"),
					nbtAcctIssCd: $F("nbtAcctIssCd"),
					nbtBranchCd: $F("nbtBranchCd")	
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function(){
					showNotice("Generating bank details, please wait...");
				},	
				onComplete: function(response){
					hideNotice("");
					var res = response.responseText.evalJSON();
					if (res.vMsgAlert == null){
						showMessageBox("Bank reference number generated successfully!", imgMessage.SUCCESS);
						$("bankRefNo").value = res.bankRefNo;
						generateBankRefNo($F("bankRefNo"));
						$("swBankRefNo").value = "Y";
						changeTag = $("otherChanges").value=="1" || changeTag==1 ? 1 : 0;
						
						if ($F("globalLineCd") != "SU" && objUWGlobal.menuLineCd != "SU")
							objUW.hidObjGIPIS002.genBankRefNoTag = "Y";
					}else{
						showMessageBox(res.vMsgAlert, imgMessage.ERROR);
						return false;
					}		
				}	
			});
		}
		function onCancelFunc(){
			null;
		}
		genBtn=false;
	}	
	
	//for Bank Reference Number
	if ($F("swBankRefNo") == "N"){
		$("nbtAcctIssCd").value = "01";
		resetBankRefNo();
		
		var preNbtAcctIssCd;
		$("nbtAcctIssCd").observe("focus",function(){
			preNbtAcctIssCd = $F("nbtAcctIssCd");
		});	
		$("nbtAcctIssCd").observe("blur",function(){
			if ($F("swBankRefNo") == "Y") return false;
			if (preNbtAcctIssCd == $F("nbtAcctIssCd")) return false;
			function onOk(){
				if ($F("globalLineCd") != "SU" && objUWGlobal.menuLineCd != "SU"){
					if (objUW.hidObjGIPIS002.forSaving == true){
						showMessageBox("Please check your reference no. to be save. Commit cancelled!", imgMessage.ERROR);
						objUW.hidObjGIPIS002.forSaving = false;
					}else{
						if (genBtn){
							$("nbtAcctIssCd").value = "01";
							resetBankRefNo();
							generateBankDtls();
						}	
					}			
				}else{
					if (objUWParList.parType == "E") {	//Gzelle 12042014 3092
						if (genBtn){
							$("nbtAcctIssCd").value = "01";
							resetBankRefNo();
							generateBankDtls();
						}
					}else {
						if (objUW.hidObjGIPIS017.forSaving == true){
							showMessageBox("Please check your reference no. to be save. Commit cancelled!", imgMessage.ERROR);
							objUW.hidObjGIPIS017.forSaving = false;
						}else{
							if (genBtn){
								$("nbtAcctIssCd").value = "01";
								resetBankRefNo();
								generateBankDtls();
							}	
						}
					}
				}	
				$("nbtAcctIssCd").value = "01";
				$("nbtAcctIssCd").focus();
				resetBankRefNo();	
			}
			if ($F("nbtAcctIssCd") != ""){ 
				if($F("nbtAcctIssCd")<1){
					showWaitingMessageBox("Invalid issue code selected! (Account issue cd should not be zero or less.)", imgMessage.ERROR, onOk);
					return false;
				}else{
					new Ajax.Request(contextPath+"/GIPIParInformationController?action=validateAcctIssCd",{
						method: "POST",
						parameters:{
							parId: $F("globalParId"),
							lineCd: $F("globalLineCd"),
							issCd: $F("globalIssCd"),
							nbtAcctIssCd: $F("nbtAcctIssCd")
						},
						asynchronous: false,
						evalScripts: true,
						//onCreate: function(){
						//	showNotice("Validating issue code, please wait...");
						//},	
						onComplete: function(response){
							//hideNotice("");
							if (checkErrorOnResponse(response)){
								if (response.responseText != ""){
									showWaitingMessageBox(response.responseText, imgMessage.ERROR, onOk);
								}
								resetBankRefNo();		
							}else{
								showMessageBox(response.responseText, imgMessage.ERROR);
								return false;
							}		
						}	
					});
				}
			}
			$("nbtAcctIssCd").value = $F("nbtAcctIssCd")!="" ? formatNumberDigits($F("nbtAcctIssCd"),2) :"01";
		});
		
		var preNbtBranchCd;
		$("nbtBranchCd").observe("focus",function(){
			preNbtBranchCd = $F("nbtBranchCd");
			
		});
		$("nbtBranchCd").observe("blur",function(){
			function blur(){
			if ($F("swBankRefNo") == "Y") return false;
			if (preNbtBranchCd == formatNumberDigits($F("nbtBranchCd"),4)) {
				$("nbtBranchCd").value = formatNumberDigits($F("nbtBranchCd"),4);
				if ($F("bankRefNo") != "") {
					if (genBtn){
						generateBankDtls();
					}	
					function dis(){
						disableButton("btnGenerateBankDtls");
					}
					setTimeout(dis, 100);
				}	
				return false;
			}
			function onOk(){
				if ($F("globalLineCd") != "SU" && objUWGlobal.menuLineCd != "SU"){
					if (objUW.hidObjGIPIS002.forSaving == true){
						showMessageBox("Please check your reference no. to be save. Commit cancelled!", imgMessage.ERROR);
						objUW.hidObjGIPIS002.forSaving = false;
					}else{
						if (genBtn){
							resetBankRefNo();
							generateBankDtls();
						}		
					}			
				}else{
					if (objUWParList.parType == "E") {	//Gzelle 12042014 3092
						if (genBtn){
							resetBankRefNo();
							generateBankDtls();
						}
					} else {
						if (objUW.hidObjGIPIS017.forSaving == true){
							showMessageBox("Please check your reference no. to be save. Commit cancelled!", imgMessage.ERROR);
							objUW.hidObjGIPIS017.forSaving = false;
						}else{
							if (genBtn){
								resetBankRefNo();
								generateBankDtls();
							}		
						}
					}
				}	
				$("nbtBranchCd").focus();
				resetBankRefNo();	
			}			
			if ($F("nbtBranchCd") != ""){ 
				if ($F("nbtBranchCd")<0){
					showWaitingMessageBox("No such branch for branch code "+$F("nbtBranchCd"), imgMessage.ERROR, onOk);
					return false;
				}else{
					if ($F("nbtBranchCd") == 0){
						resetBankRefNo();
						return false;
					}else{	
						new Ajax.Request(contextPath+"/GIPIParInformationController?action=validateBranchCd",{
							method: "POST",
							parameters:{
								parId: $F("globalParId"),
								lineCd: $F("globalLineCd"),
								issCd: $F("globalIssCd"),
								nbtAcctIssCd: $F("nbtAcctIssCd"),
								nbtBranchCd: $F("nbtBranchCd")
							},
							asynchronous: false,
							evalScripts: true,
							//onCreate: function(){
							//	showNotice("Validating branch code, please wait...");
							//},	
							onComplete: function(response){
								//hideNotice("");
								if (checkErrorOnResponse(response)){
									if (response.responseText == "no_data_found"){
										showWaitingMessageBox("Please validate bank ref no using the LOV for branch cd. (reverting to initial values)", imgMessage.ERROR, onOk);
									}else{
										function dis(){
											disableButton("btnGenerateBankDtls");
										}	
										setTimeout(dis, 100);
									}		
								}else{
									showMessageBox(response.responseText, imgMessage.ERROR);
									return false;
								}		
							}	
						});
					}
				}
			}
			$("nbtBranchCd").value = $F("nbtBranchCd")!="" ? formatNumberDigits($F("nbtBranchCd"),4) :"0000";
			if ($F("dspRefNo") != 0 || $F("dspModNo") != 0)	$("bankRefNo").value = $F("nbtAcctIssCd")+"-"+$F("nbtBranchCd")+"-"+formatNumberDigits($F("dspRefNo"),7)+"-"+formatNumberDigits($F("dspModNo"),2);
			}
			setTimeout(blur, 200);
		});
		$("btnGenerateBankDtls").observe("focus", function(){
			genBtn=true;
		});
		$("btnGenerateBankDtls").observe("click", function(){
			genBtn=true;
			generateBankDtls();
		});
		$("bankRefNoLOVDate").observe("click", function(){
			if ($F("swBankRefNo") == "Y") return false;
			openSearchBankRefNo();
		});	
	}else{
		generateBankRefNo($F("bankRefNo"));
	}

	//added by gab 10.05.2016 SR 3147,3027,2645,2681,3148,3206,3264,3010
	if (reqRefNum == "Y"){
		$("nbtAcctIssCd").addClassName("required");
		$("nbtBranchCd").addClassName("required");
		$("dspRefNo").addClassName("required");
		$("dspModNo").addClassName("required");
	}
	
	initializeChangeTagBehavior(changeTagFunc);	
</script>