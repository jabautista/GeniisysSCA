<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
		<label id="">Other Details</label>
		<span class="refreshers" style="margin-top: 0;"> 
			<label name="gro">Hide</label>
		</span>
	</div>
</div>
<div class="sectionDiv" id="otherDetailsDiv">
	<div id="otherDetails" style="margin: 10px;">
		<table border="0" style="margin: 10px auto;">
			<tr>
				<td class="rightAligned" style="width: 130px;">Header </td>
				<td class="leftAligned">
					<div style="border: 1px solid gray; height: 20px; width: 516px;">
						<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" style="width: 490px; border: none; height: 13px;" id="header" name="header">${gipiQuote.header}${defaultHeader.lineName}</textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editHeader" />
					</div>
				</td>
				<td style="width: 45px;"></td>
			</tr>
			<tr>
				<td class="rightAligned">Footer </td>
				<td class="leftAligned">
					<div style="border: 1px solid gray; height: 20px; width: 516px;">
						<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" style="width: 490px; border: none; height: 13px;" id="footer" name="footer">${gipiQuote.footer}${footer.lineName}</textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editFooter" />
					</div>
				</td>		
			</tr>
			<tr>
				<td class="rightAligned">Remarks </td>
				<td class="leftAligned">
					<div style="border: 1px solid gray; height: 20px; width: 516px;">
						<textarea onKeyDown="limitText(this,4000);" onKeyUp="limitText(this,4000);" style="width: 490px; border: none; height: 13px;" id="remarks" name="remarks">${gipiQuote.remarks}</textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" />
					</div>
				</td>		
			</tr>
			<tr>
				<td class="rightAligned">Reference No. </td>
				<td class="leftAligned">
					<div changeTagAttr="false">
						<input style="text-align:right; width:60px;" type="hidden" id="otherChanges" name="otherChanges" value="0" readonly="readonly"/> 
						<input style="text-align:right; width:60px;" type="hidden" id="swBankRefNo" name="swBankRefNo" value="${empty gipiQuote.bankRefNo ? 'N' : 'Y'}" readonly="readonly"/> 
						<input style="text-align:right; width:60px;" type="hidden" id="bankRefNo" name="bankRefNo" value="${gipiQuote.bankRefNo}" readonly="readonly"/> 
						<input style="text-align:right; width:60px;" type="text" id="nbtAcctIssCd" name="nbtAcctIssCd" value="01" maxlength="2" class="integerUnformattedNoComma" errorMsg="Entered issue code is invalid. Valid value is from 01 to 99"/> 
						<input style="text-align:right; width:70px;" type="text" id="nbtBranchCd" name="nbtBranchCd" value="0000" maxlength="4" class="integerUnformattedNoComma" errorMsg="Entered branch code is invalid. Valid value is from 0000 to 9999"/>
						<input style="text-align:right; width:90px;" type="text" id="dspRefNo" name="dspRefNo" value="" maxlength="7" readonly="readonly"/>
						<input style="text-align:right; width:60px;" type="text" id="dspModNo" name="dspModNo" value="" maxlength="2" readonly="readonly"/>
						<img class="hover" id="hrefReference" style="height: 16px" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />
						<input type="button" id="btnGenerateBankDtls" name="btnGenerateBankDtls" class="disabledButton" value="Generate Ref. No." title="Generate Ref. No." disabled="disabled" style="width: 150px;" />
					</div> 
				</td>		
			</tr>
			<!--
			<tr>								
				<td class="rightAligned">Reason </td>
				<td class="leftAligned">
					<select style="width: 518px;" id="reason" name="reason">
						<option value=""></option>
						<c:forEach var="reasonListing" items="${reasonListing}">
							<option value="${reasonListing.reasonCd}"
								<c:if test="${gipiQuote.reasonCd == reasonListing.reasonCd}">
								selected="selected"
								</c:if>
							>${reasonListing.reasonDesc}</option>
						</c:forEach>
					</select>
				</td>	
			</tr>  -->
		</table>
	</div>
</div>
<script>
	enableButton("btnSubmitText");
	enableButton("btnCancelText");
	$("hrefReference").observe("click", showReferenceNoListing);
	objMKTG.giimm001QouteInfo.reqRefNo = '${requireRefNo}'; //Added by Jerome 12.12.2016 SR 5746
	
	if (objMKTG.giimm001QouteInfo.reqRefNo == 'Y'){ //Added by Jerome 12.12.2016 SR 5746
		$("nbtAcctIssCd").setAttribute("class","required");
		$("nbtBranchCd").setAttribute("class","required");
		$("dspRefNo").setAttribute("class","required");
		$("dspModNo").setAttribute("class","required");
	}else{
		$("nbtAcctIssCd").removeAttribute("class","required");
		$("nbtBranchCd").removeAttribute("class","required");
		$("dspRefNo").removeAttribute("class","required");
		$("dspModNo").removeAttribute("class","required");
	}
	
	/* $("header").observe("blur", function(){
		changeTag = 1;
	});
	
	$("footer").observe("blur", function(){
		changeTag = 1;
	});
	
	$("remarks").observe("blur", function(){
		changeTag = 1;
	}); */
	
	var genBtn=false;
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
				$("nbtAcctIssCd").value = "01";
				$("nbtAcctIssCd").focus();
				resetBankRefNo();	
			}
			
			if ($F("nbtAcctIssCd") != ""){
				if($F("nbtAcctIssCd")<1){
					showWaitingMessageBox("Invalid issue code selected! (Account issue cd should not be zero or less.)", imgMessage.ERROR, onOk);
				}else{
					new Ajax.Request(contextPath+"/GIPIPackQuoteController?action=validateAcctIssCd",{
						method: "POST",
						parameters:{
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
								showErrorMessage("nbtAcctIssCd observe",e);
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
						}/*else if($F("nbtBranchCd") != 0){
							showWaitingMessageBox("Please validate bank ref no using the LOV for branch cd. (reverting to initial values)", imgMessage.ERROR, onOk);
						}*/else{	
							new Ajax.Request(contextPath+"/GIPIPackQuoteController?action=validateBranchCd",{
								method: "POST",
								parameters:{
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
											/*function dis(){
												disableButton("btnGenerateBankDtls");
											}	
											setTimeout(dis, 100);*/
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
		$("btnGenerateBankDtls").observe("click", function(){
			genBtn=true;
			generateBankDtls();
		});
	}else{
		generateBankRefNo($F("bankRefNo"));
		$("hrefReference").disabled = true;
	}

	function generateBankDtls(){
		if ($F("swBankRefNo") == "Y") return false;
		genBtn=true;
		if ($F("nbtBranchCd") != 0){
			customShowMessageBox("This module does not generate bank reference numbers with branch code not equal to 0.", imgMessage.ERROR, "nbtBranchCd");
			genBtn=false;	
			return false;
		}
		showConfirmBox("Confirmation", "This would commit changes along with the generated bank reference number with acct. issue cd =  "+$F("nbtAcctIssCd")+".<br /> Do you wish to continue? (branch cd = 0000)",  
			"Yes", "No", onOkFunc, "");
		function onOkFunc(){
			new Ajax.Request(contextPath+"/GIPIQuotationController?action=generateQuoteBankRefNo",{
				method: "POST",
				parameters:{
					quoteId: $F("quoteId"),
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
						objMKTG.giimm001QouteInfo.genBankRefNoTag = $F("swBankRefNo"); //Added by Jerome 12.12.2016 SR 5746
						changeTag = $("otherChanges").value=="1" || changeTag==1 ? 1 : 0;
					}else{
						showMessageBox(res.vMsgAlert, imgMessage.ERROR);
						return false;
					}		
				}	
			});
		}
		genBtn=false;
	}	
	
	// bonok :: 09.27.2013 :: SR: 388 - GENQA
	var prevHeader = "";
	$("header").observe("keydown", function(){
		prevHeader = $F("header");
	});
	$("header").observe("keyup", function(){
		if($("header").value.length > 2000){
			$("header").value = prevHeader;
		}
	});
	
	var prevFooter = "";
	$("footer").observe("keydown", function(){
		prevFooter = $F("footer");
	});
	$("footer").observe("keyup", function(){
		if($("footer").value.length > 2000){
			$("footer").value = prevFooter;
		}
	});
	
	var prevRemarks = "";
	$("remarks").observe("keydown", function(){
		prevRemarks = $F("remarks");
	});
	$("remarks").observe("keyup", function(){
		if($("remarks").value.length > 4000){
			$("remarks").value = prevRemarks;
		}
	});
</script>