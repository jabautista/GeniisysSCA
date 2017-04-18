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
				<!-- <input style="width: 510px;" id="header" name="header" type="text" value="${gipiPackQuote.header}${defaultHeader.lineName}" /> -->
					<div style="border: 1px solid gray; height: 20px; width: 516px;">
						<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" style="width: 490px; border: none; height: 13px;" id="header" name="header" maxlength="2000">${gipiPackQuote.header}${defaultHeader.lineName}</textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editHeader" />
					</div>
				</td>
				<td style="width: 45px;"></td>
			</tr>
			<tr>
				<td class="rightAligned">Footer </td>
				<td class="leftAligned">
				<!-- <input style="width: 510px;" id="footer" name="footer" type="text" value="${gipiPackQuote.footer }${footer.lineName}" /> -->
					<div style="border: 1px solid gray; height: 20px; width: 516px;">
						<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" style="width: 490px; border: none; height: 13px;" id="footer" name="footer" maxlength="2000">${gipiPackQuote.footer}${footer.lineName}</textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editFooter" />
					</div>
				</td>		
			</tr>
			<tr>
				<td class="rightAligned">Remarks </td>
				<td class="leftAligned">
				<!-- <input style="width: 510px;" id="remarks" name="remarks" type="text" value="${gipiPackQuote.remarks }" /> -->
					<div style="border: 1px solid gray; height: 20px; width: 516px;">
						<textarea onKeyDown="limitText(this,4000);" onKeyUp="limitText(this,4000);" style="width: 490px; border: none; height: 13px;" id="remarks" name="remarks" maxlength="4000">${gipiPackQuote.remarks}</textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" />
					</div>
				</td>		
			</tr>
			<tr id="ref">
				<td class="rightAligned">Reference No. </td>
				<td class="leftAligned">
					<div changeTagAttr="false">
						<input style="text-align:right; width:60px;" type="hidden" id="otherChanges" name="otherChanges" value="0" readonly="readonly"/> 
						<input style="text-align:right; width:60px;" type="hidden" id="swBankRefNo" name="swBankRefNo" value="${empty gipiPackQuote.bankRefNo ? 'N' : 'Y'}" readonly="readonly"/> 
						<input style="text-align:right; width:60px;" type="hidden" id="bankRefNo" name="bankRefNo" value="${gipiPackQuote.bankRefNo}" readonly="readonly"/> 
						<input style="text-align:right; width:60px;" type="text" id="nbtAcctIssCd" name="nbtAcctIssCd" value="01" maxlength="2" class="integerUnformattedNoComma" errorMsg="Entered issue code is invalid. Valid value is from 01 to 99."/> 
						<input style="text-align:right; width:70px;" type="text" id="nbtBranchCd" name="nbtBranchCd" value="0000" maxlength="4" class="integerUnformattedNoComma" errorMsg="Entered branch code is invalid. Valid value is from 0000 to 9999."/>
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
								<c:if test="${gipiPackQuote.reasonCd == reasonListing.reasonCd}">
								selected="selected"
								</c:if>
							>${reasonListing.reasonDesc}</option>
						</c:forEach>
					</select>
				</td>	
			</tr> -->
		</table>
	</div>
</div>
<script>
	enableButton("btnSubmitText");
	enableButton("btnCancelText");
	
	if ($F("ora2010Sw") != "Y") {	//Gzelle - hide Reference No., Reference No. LOV, and <Generate Ref. No.> button if ORA2010SW <> Y
		$("ref").hide();
	}else {
		$("ref").show();
	}
	
	//$("hrefReference").observe("click", showReferenceNoListing); Gzelle 10.02.2013 - to disable search icon when bank reference number have been generated
	$("hrefReference").observe("click", function() {
		if ($F("swBankRefNo") == "Y") return false;
		//showReferenceNoListing();
		showReferenceLOV("%");
	});
	
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
				if($F("nbtAcctIssCd")<1){	//Gzell 10.02.2013 replaced cd with code
					//showWaitingMessageBox("Invalid issue code selected! (Account issue code should not be zero or less.)", imgMessage.ERROR, onOk);
					showWaitingMessageBox("Entered issue code is invalid. Valid value is from 01 to 99.", imgMessage.ERROR, onOk);	
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
						}else{	
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
										if (response.responseText == "no_data_found"){	//Gzelle 10.02.2013 - replaced cd with code
											showWaitingMessageBox("Please validate bank ref no using the LOV for branch code. (reverting to initial values)", imgMessage.ERROR, onOk);
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
			if ($F("quotationNo") == "") {	//Gzelle 10.02.2013 - validate if quotation have been created before generating a bank reference number
				showMessageBox("Please create quotation first before generating a bank reference number.", imgMessage.INFO);
			}else {
				genBtn=true;
				generateBankDtls();
			}
		});
	}else{
		generateBankRefNo($F("bankRefNo"));
		//$("hrefReference").disabled = true; Gzelle 12.17.2013
		disableReferenceNo();
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
			new Ajax.Request(contextPath+"/GIPIPackQuoteController?action=generatePackBankRefNo",{
				method: "POST",
				parameters:{
					packQuoteId: $F("packQuoteId"),
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
						disableReferenceNo();
					}else{
						showMessageBox(res.vMsgAlert, imgMessage.ERROR);
						return false;
					}		
				}	
			});
		}
		genBtn=false;
	}	

	/*Gzelle 12.17.2013 - added codes below*/
	function disableReferenceNo() {
		if($("hrefReference").next("img",0) == undefined){
			var alt = new Element("img");
			alt.alt = 'Go';
			alt.src = contextPath + "/images/misc/disabledSearchIcon.png";
			$("hrefReference").hide();
			$("hrefReference").insert({after : alt});			
		}
	}
	
	function showReferenceLOV(isIconClicked) {
		try {
			var search = isIconClicked ? "%" : ($F("nbtAcctIssCd").trim() == "" ? "%" : $F("nbtAcctIssCd"));
			
			LOV.show({
				controller : "MarketingLOVController",
				urlParameters : {
					action : "getBankRefNoListingForPackTG",
					nbtAcctIssCd : $F("nbtAcctIssCd"),
					nbtBranchCd : $F("nbtBranchCd"),
					keyword : search,
					page: 1
				},
				title : "Search Bank Reference Number",
				width : 480,
				height : 386,
				columnModel : [ 
				    {
						id : "acctIssCd",
						title : "Acct. Issue Cd",
						width : '120px'
				    },
				    {
						id : "branchCd",
						title : "Branch Cd",
						width : '110px'
				    },
				    {
						id : "refNo",
						title : "Reference No.",
						width : '120px'
				    },
				    {
						id : "modNo",
						title : "Mod 10",
						width : '110px'
				    }
				],
				draggable : true,
				autoSelectOneRecord : true,
				filterText : escapeHTML2(search),
				onSelect : function(row) {
					if (row != null || row != undefined) {
						$("nbtAcctIssCd").value = unescapeHTML2(row.acctIssCd);
						$("nbtBranchCd").value = unescapeHTML2(row.branchCd);
						$("dspRefNo").value = unescapeHTML2(row.refNo);
						$("dspModNo").value = unescapeHTML2(row.modNo);
					}
				},
				onCancel : function() {
					$("nbtAcctIssCd").focus();
					//$("inAccountOf").value = $("inAccountOf").readAttribute("lastValidValue");
				},
				onUndefinedRow : function() {
					customShowMessageBox("No record selected.", imgMessage.INFO, "nbtAcctIssCd");
				}
			});
		} catch (e) {
			showErrorMessage("showReferenceLOV", e);
		}
	}

	initializeChangeTagBehavior(changeTagFunc);	
</script>