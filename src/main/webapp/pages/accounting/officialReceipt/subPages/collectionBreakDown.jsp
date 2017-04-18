<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<input type="hidden" id="paymentItemNo" name="paymentItemNo" value="0">
<div id="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" >
   		<label>Collection Breakdown</label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label name="gro" style="margin-left: 5px;">Hide</label>
   		</span>
   	</div>
</div>
<div class="sectionDiv" id="collectionBreakdownDiv" style="border-bottom: none;" changeTagAttr="true">
	<div id="collectionBreakdownHeader" style="margin: 10px;">
		<input type='hidden' id='disabledDummy' disabled="disabled">
		<table width="70%" align="left" cellspacing="1" border="0">
 			<tr>
				<td class="rightAligned" style="width: 25%;">DCB Bank Account</td>
				<td style="width: 44%;">
					<select id="dcbBankName" style="width: 100%;" class="required list dcbEvent">
						<option value="">Select..</option>
						<c:forEach var="dcbBankDetail" items="${dcbBankDetails}">
							<option bankCd="${dcbBankDetail.bankCd}" value="${fn:escapeXml(dcbBankDetail.bankName)}">${fn:escapeXml(dcbBankDetail.bankName)}</option>
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned" style="width: 1%;">/</td>
				<td class="leftAligned" style="width: 30%;">
					<select id="dcbBankAccountNo" name="dcbBankAccountNo" style="width: 100%;" class="list dcbEvent required">
						<option value="">Select...</option>
					</select>
					<c:forEach var="dcbBankDetail" items="${dcbBankDetails}">
						<select id="dcbBankAccountNo${dcbBankDetail.bankCd}" name="dcbBankAccountNo" style="width: 100%; display: none;" class="list dcbEvent required">
						<option value="">Select...</option>
						<c:forEach var="dcbBankAcctNoDetail" items="${dcbBankAcctNoDetails}">
							<c:if test="${dcbBankAcctNoDetail.bankCd eq dcbBankDetail.bankCd}">
								<option value="${dcbBankAcctNoDetail.bankAcctCd}">${dcbBankAcctNoDetail.bankAcctNo}</option>
							</c:if>
						</c:forEach>
						</select>
					</c:forEach>
				</td>
			</tr>
		</table>
	</div>

	<br />
	
	<div class="sectionDiv" id="collectionPaymentDiv" style="border-top: none; border-right: none; border-left: none; border-bottom: none;">
		<div id="collectionPayment" style="margin: 10px;">
			<div id="collectionPaymentTable" style="border-right: white; border-left: white;">
				<div style="width: 100%;" id="collectionPaymentTableHeader">
					<div class="tableHeader" style="font-size: 11px;">
						<label style="width: 70px; text-align: center;">Item No.</label>
						<label style="width: 100px; text-align: left;">Payment Mode</label>
						<label style="width: 160px; text-align: left;">Bank</label>
				   		<label style="width: 90px; text-align: left;">Check Class</label>
				   		<label style="width: 160px; text-align: center;">Check/Credit Card No.</label>
				   		<label style="width: 75px; text-align: center;">Check Date</label>
						<label style="width: 170px; text-align: right;">Local Currency Amount</label>	
						<label style="width: 70px; text-align: center;">Currency</label>				
					</div>
				</div>
				<div style="width: 100%;" id="collectionPaymentList" class="tableContainer" style="margin-top: 10px;">
					<jsp:include page="../subPages/collectionPaymentListing.jsp"></jsp:include>
				</div>	
				
				<div id="collnDtlTotalAmtMainDiv" class="tableHeader" style="width: 100%;">
					<div id="collnDtlTotalAmtDiv" style="width:100%;">
						<label style="text-align:left; width:37%; margin-left: 5px;">Total:</label>
						<label id="lblCollnsTotal" style="text-align:right; width:12%; margin-left: 371px;" class="money">&nbsp;</label>
					</div>
				</div>		
			</div>
		</div>
	</div>
	<div class="sectionDiv" id="collectionBreakdownDiv" style="margin-top: 2px; border-right: white; border-left: white;" changeTagAttr="true">
		<div id="collectionBreakdownBody" style="margin-top: 10px;">		
			<table width="85%" align="center" cellspacing="1" border="0">
				<tr>
					<td class="rightAlignedWidth">Payment Mode</td>
					<td class="leftAlignedWidth">
						<select id="paymentMode" style="width: 78.5%;" class="required list dcbEvent">
							<option value="">Select..</option>
								<c:forEach var="payModeCode" items="${payModeCodes}">
									<option value="${payModeCode.rvLowValue}">${payModeCode.rvMeaning}</option>
								</c:forEach>
						</select>
					</td>
					<td class="rightAlignedWidth">Gross Amount</td>
					<td class="leftAlignedWidth"><input id="grossAmt" type="text" style="width: 75%;" class="money" disabled="disabled" /></td> 
				</tr>
				<tr>
					<td class="rightAlignedWidth">Bank</td>
					<td class="leftAlignedWidth">
						<select id="bank" style="width: 78.5%;" class="list dcbEvent" disabled="disabled">
							<option value="">Select..</option>
								<c:forEach var="bankDetail" items="${bankDetails}">
									<option value="${bankDetail.bankCd}">${fn:escapeXml(bankDetail.bankName)}</option>
								</c:forEach>
						</select>
					</td>
					<td class="rightAlignedWidth">Deduction/Commission</td>
					<td class="leftAlignedWidth"><input id="deductionComm" type="text" style="width: 75%;" class="money dcbEvent" disabled="disabled"/></td>
				</tr>
				<tr>
					<td class="rightAlignedWidth">Check Class</td>
					<td class="leftAlignedWidth">
						<select id="checkClass" style="width: 78.5%;" class="list dcbEvent" disabled="disabled">
							<option value="">Select..</option>
								<c:forEach var="checkClassDetail" items="${checkClassDetails}">
									<option checkDesc="${checkClassDetail.rvMeaning}" value="${checkClassDetail.rvLowValue}">${checkClassDetail.rvMeaning}</option>
								</c:forEach>	
						</select>
					</td>
					<td class="rightAlignedWidth">VAT Amount</td>
					<td class="leftAlignedWidth"><input id="vatAmount" type="text" style="width: 75%;" class="money dcbEvent" disabled="disabled" /></td>
				</tr>
				<tr>
					<td class="rightAlignedWidth">Check/Credit Card No.</td>
					<td class="leftAlignedWidth">
						<div id="credCardDiv" style="border: 1px solid gray; width: 194px; height: 21px; float: left; background-color: #FFFACD;">
								<input style="width: 165px; border: none; height: 13px; float: left;" id="checkCreditCardNo" name="checkCreditCardNo" type="text" class="dcbEvent" ignoreDelKey="1" maxLength="25"/>  <!-- added value  --> 
								<img style="float: right; display: none;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmCheckCredit" name="oscmCheckCredit" alt="Go" />
								<input type="hidden" id="hidCmTranId" name="hidCmTranId" value=""/>
						</div>
					</td>
					
					<td class="rightAlignedWidth">FC Gross Amount</td>
					<td class="leftAlignedWidth"><input id="fcGrossAmt" type="text" style="width: 75%;" class="money" disabled="disabled" /></td>
				</tr>	
				<tr>
					<td class="rightAlignedWidth">Check Date</td>
					<td class="leftAlignedWidth">
						<span id="checkDateBack" style="float: left; height: 22px; border: 1px solid gray; background-color: cornsilk;">
					    	<input style="width: 168px; border: none; height: 13px;" id="checkDateCalendar" name="checkDateCalendar" type="text" class="dcbEvent formattedDate" ignoreDelKey="1"/>
					    	<img id="hrefCheckDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Check Date" />
					    </span>
					</td>
					<td class="rightAlignedWidth">FC Comm Amount</td>
					<td class="leftAlignedWidth"><input id="fcCommAmt" type="text" style="width: 75%;" class="money dcbEvent" disabled="disabled" /></td>
				</tr>
				<tr>
					<td class="rightAlignedWidth">Local Currency Amount</td>
					<td class="leftAlignedWidth"><input id="localCurrAmt" type="text" style="width: 75.5%;" class="money dcbEvent" value="" disabled="disabled" /></td>
					<td class="rightAlignedWidth">FC Tax Amount</td>
					<td class="leftAlignedWidth"><input id="fcTaxAmt" type="text" style="width: 75%;" class="money dcbEvent" disabled="disabled" /></td>
				</tr>
				<tr>
					<td class="rightAlignedWidth">Currency</td>
					<td class="leftAlignedWidth">
						<select id="currency" style="width: 78.5%;" class="list dcbEvent" disabled="disabled" >
							<option value=" ">Select..</option>
							<c:forEach var="currencyDetail" items="${currencyDetails}">
								<option shortName="${currencyDetail.shortName}" currRate="${currencyDetail.valueFloat}" value="${currencyDetail.code}">${fn:escapeXml(currencyDetail.desc)}</option>
							</c:forEach>
						</select>
					</td>
					<td class="rightAlignedWidth">FC Net Amount</td>
					<td class="leftAlignedWidth"><input id="fcNetAmt" type="text" style="width: 75%;" class="money dcbEvent" readonly="readonly" disabled="disabled" /></td>
				</tr>
				<tr>
					<td class="rightAlignedWidth">Currency Rate</td>
					<td class="leftAlignedWidth"><input id="currRt" type="text" style="width: 75.5%; text-align: right;"  value="" class="dcbEvent" disabled="disabled" /></td>
					<td class="rightAlignedWidth">Particulars</td>
					<td colspan=1 class="leftAlignedWidth" > 
						<div style="border: 1px solid gray; height: 20px; width: 77.7%; background-color: transparent">
							<textarea id="particular" style="width: 85%; border: none; height: 13px; float: left;" class="list dcbEvent" maxlength="500" onkeyup="limitText(this,500)">${particulars}</textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right; background-color: transparent; " alt="Edit" id="editCollnParticulars" />
						</div>
					</td>
				</tr>
				<!--  
				<tr>
					<td colspan=2 class="leftAligned" style="width: 18%;"><input type="radio" id="gross" name="grossNet" value="Gross" style="margin-left: 140px;"/> Gross <input type="radio" id="net" name="grossNet" value="Net" /> Net</td>
				</tr>
				-->
			</table>
			<div class="buttonDiv" id="collectionBreakdownButtonDiv">
				<table align="center" style="margin-top: 10px;">
					<tr>
						<td><input type="button" class="button" id="btnAdd" name="btnAdd" value="Add" style="width: 90px;" /></td>
						<td><input type="button" class="disabledButton" id="btnDelete" name="btnDelete" value="Delete" style="width: 90px;" /></td>
					</tr>
				</table>
			<br />
			</div>
		</div>
	</div>
</div>
<script type="text/JavaScript">
	objAC.defCurrency = '${defaultCurrency}';
	var oldValue = 0;
	var cmCreditMemoDtls = JSON.parse('${creditMemoDtlsJSON}'.replace(/\\/g, '\\\\'));	
	enableDisableCurrRt();
	var currSnameSw = 0;
	
	checkDefaultCurrency();
	
	$("hrefCheckDate").observe("click", function(){
		//if ($("hrefCheckDate").disabled == false){
			scwShow($('checkDateCalendar'),this, null);
		//}
	});
	
	
	// added by Kris 01.28.2013: updates the ff fields when switching between Net and Gross tags
	function toggleAmountFields(tag){
		$("grossAmt").disabled = tag;
		$("deductionComm").disabled= tag;
		$("vatAmount").disabled = tag;
	}
	
	/* added by Kris 01.28.2013 */
	function checkDefaultCurrency(){
		$("fcGrossAmt").disabled = ($F("currency") == objAC.defCurrency) ? true : false;
		$("fcCommAmt").disabled = ($F("currency") == objAC.defCurrency) ? true : false;
		$("fcTaxAmt").disabled = ($F("currency") == objAC.defCurrency) ? true : false;
		$("fcNetAmt").disabled = ($F("currency") == objAC.defCurrency) ? true : false;
	}
	
	function checkStaleDate() {
		try {
			if(isNaN(parseInt($F("staleMgrChk")))) {
				showMessageBox("No data found for parameter STALE_MGR_CHK in giac_parameters", imgMessage.ERROR);
				return;
			}
			
			var orDate = makeDate($F("orDate"));
			var checkDate = makeDate($F("checkDateCalendar"));
			var staleDate = orDate;
			var staleParam = $F("checkClass") == "M" ? parseInt($F("staleMgrChk")) : parseInt($F("staleCheck"));
			staleDate = new Date(staleDate.addMonths(staleParam*-1));
		
			if(checkDate <= staleDate) {
				$("checkDateCalendar").value = "";
				customShowMessageBox("This is a stale check.", imgMessage.ERROR, "checkDateCalendar");
				return;
			}
			
			var checkStDate = new Date(checkDate.addMonths(staleParam));
			var staleDaysNo = (checkStDate - makeDate($F("orDate")))/(1000*60*60*24);
			//var staleDaysNo = computeNoOfDays($F("checkDateCalendar"), dateFormat(new Date(), 'mm-dd-yyyy'), null);
			if(staleDaysNo <= parseInt($F("staleDays")) && staleDaysNo != 0) {
				if(staleDaysNo == 1) {
					showMessageBox("This check will be stale tomorrow.", imgMessage.ERROR);
					return false;
				}else {
					showMessageBox("This check will be stale within "+staleDaysNo+" days.", imgMessage.ERROR);
					return false;
				}
			}
		} catch(e) {
			showErrorMessage("checkStaleDate", e);
		}
	}
	
	
	$("checkDateCalendar").observe("blur", function() {  //modified observe function - christian 09182012
		if($F("checkDateCalendar")=="") return;
		if (checkDate2($F("checkDateCalendar"))){
			if($F("paymentMode") == "CHK") {
				if(makeDate($F("checkDateCalendar")) > makeDate($F("orDate")) && $F("acceptPDC") == "N") {
					showMessageBox("This check is post-dated.");
					$("checkDateCalendar").value = "";
				} else {
					checkStaleDate();
				}
				
			}
		}
	});
	
	/* $("checkDateCalendar").observe("blur", function() {   //commented out by christian 09182012
		var inputDate = Date.parse($F("checkDateCalendar"));
		if (inputDate != null){
			$("checkDateCalendar").value = inputDate.format("mm-dd-yyyy");
			
			if($F("paymentMode") == "CHK"/* && $F("checkClass") == "M"*//*) {
				if(makeDate($F("checkDateCalendar")) > makeDate($F("orDate")) && $F("acceptPDC") == "N") {
					showMessageBox("This check is post-dated.");
					$("checkDateCalendar").value = "";
				} else {
					checkStaleDate();
				}
				
			}
		}else{
			customShowMessageBox("Date must be entered in a format like MM-DD-RRRR.", imgMessage.INFO, "checkDateCalendar");
		}
	}); */
	
	/* $("checkDateCalendar").observe("change", function() {
		var inputDate = Date.parse($F("checkDateCalendar"));
		if (inputDate != null){
			$("checkDateCalendar").value = inputDate.format("mm-dd-yyyy");
			checkStaleDate();
		}else{
			customShowMessageBox("Date must be entered in a format like MM-DD-RRRR.", imgMessage.INFO, "checkDateCalendar");
		}
	}); */

	$("currency").observe("change", function () {
		checkDefaultCurrency(); // added by kris 01.29.2013
		
		currSnameSw = 1;
		$("currRt").value = formatToNineDecimal($("currency").options[$("currency").selectedIndex].getAttribute("currRate"));
		$("fcGrossAmt").value = formatCurrency(Math.round((unformatCurrency("grossAmt") / parseFloat($F("currRt")))*100)/100);
		$("fcCommAmt").value = formatCurrency(Math.round(( unformatCurrency("deductionComm") / parseFloat($F("currRt")))*100)/100);
		$("fcTaxAmt").value = formatCurrency(Math.round(( unformatCurrency("vatAmount") / parseFloat($F("currRt")))*100)/100);
		$("fcNetAmt").value = formatCurrency((Math.round(( unformatCurrency("grossAmt") / parseFloat($F("currRt")))*100)/100) - unformatCurrency("fcCommAmt") - unformatCurrency("fcTaxAmt"));
		
		// commented out by Kris 01.28.2013
		/*if ($("currency").selectedIndex == 0){
			enableDisableMoneyValues("disable");
		}else{
			enableDisableMoneyValues("enable");
		}*/
		
		enableDisableCurrRt();
	});

	$("currRt").observe("blur", function () {
		if (isNaN($F("currRt")) || $F("currRt") < 0 || $F("currRt") > 1000){
			customShowMessageBox("Field must be of form 990.999999999.", imgMessage.INFO, "currRt");
		}else {
			if (oldValue != parseFloat($F("currRt"))) {
				/* $("currRt").value = formatToNineDecimal($F("currRt"));
				$("localCurrAmt").value = parseFloat($F("currRt")) * unformatCurrency("fcNetAmt");
				fireEvent($("localCurrAmt"), "blur"); */
				$("fcGrossAmt").value = formatCurrency(Math.round((unformatCurrency("grossAmt") / parseFloat($F("currRt")))*100)/100);
				$("fcCommAmt").value = formatCurrency(Math.round(( unformatCurrency("deductionComm") / parseFloat($F("currRt")))*100)/100);
				$("fcTaxAmt").value = formatCurrency(Math.round(( unformatCurrency("vatAmount") / parseFloat($F("currRt")))*100)/100);
				$("fcNetAmt").value = formatCurrency((Math.round(( unformatCurrency("grossAmt") / parseFloat($F("currRt")))*100)/100) - unformatCurrency("fcCommAmt") - unformatCurrency("fcTaxAmt"));
			}
		}
	});

	$("currRt").observe("click", function () {
		oldValue = parseFloat($F("currRt"));
	});
	
	function enableDisableMoneyValues(action){
		if (action == "enable") {
			$("particular").disabled = false;
			$("grossAmt").disabled = false;
			$("deductionComm").disabled = false;
			$("vatAmount").disabled = false;
			$("fcGrossAmt").disabled = false;
			$("fcCommAmt").disabled = false;
			$("fcTaxAmt").disabled = false;
			$("fcNetAmt").disabled = false;
		}else{
			$("particular").disabled = true;
			$("grossAmt").disabled = true;
			$("deductionComm").disabled = true;
			$("vatAmount").disabled = true;
			$("fcGrossAmt").disabled = true;
			$("fcCommAmt").disabled = true;
			$("fcTaxAmt").disabled = true;
			$("fcNetAmt").disabled = true;
		}
	}
	
	function enableDisableCurrRt() {
		if($F("currency") == "1" || $("currency").getAttribute("shortName") == "PHP") {
			$("currRt").readOnly = true;
		} else {
			$("currRt").readOnly = false;
		}
	}

	$("editCollnParticulars").observe("click", function () {
		if ($("editCollnParticulars").disabled != true) {
			//showEditor("particular", 500);
			showOverlayEditor("particular", 500, ($("particular").hasAttribute("readonly") || $("particular").disabled)); // andrew - 08.14.2012
		}
	});

	$("oscmCheckCredit").observe("click", function () {
		if(($("paymentMode").value == "RCM") || ($("riCommTag").checked)){
			if(!($F("itemNoListToDelete").blank())){
				showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
				($$("div#collectionBreakdownDiv [changed=changed]")).invoke("removeAttribute", "changed");
				return false;
			}
			
			var withChanges = "N";
			$$("div[name='rowItem']").each(function(div) {
				var recordStat = div.down("input", 21).value;
				if(recordStat == "0" || recordStat == "-1" || recordStat == "1"){
					withChanges = "Y";
				}
			});
			if(withChanges == "Y" || !($F("itemNoListToDelete").blank())){
				showMessageBox("Please save collection breakdown.", "I");
				($$("div#collectionBreakdownDiv [changed=changed]")).invoke("removeAttribute", "changed");
			}else{
				showCreditMemoDtlsLOV(objACGlobal.fundCd, "RCM", "RCM");				
			}
		}else{
			Modalbox.show(contextPath+"/GIACOrderOfPaymentController?action=getCreditMemoDtls&ajaxModal=1&fundCd=" + objACGlobal.fundCd, 
					{	title: "Show Credit Memo Details", 
						width: 700
					});
		}
	});

	$("currency").value = objAC.defCurrency;
	$("currRt").value = formatToNineDecimal($("currency").options[$("currency").selectedIndex].getAttribute("currRate"));
	objAC.defaultRate = formatToNineDecimal($("currency").options[$("currency").selectedIndex].getAttribute("currRate"));
	if ((objACGlobal.orFlag == 'P' //Deo [01.12.2017]: add start (SR-22498)
			&& !(objACGlobal.orTag == "*" && objAC.tranFlagState == "O") //Deo [02.16.2017]: SR-5932
			) || objACGlobal.orFlag == 'C') {
		$("dcbBankName").value = "";
		$("dcbBankAccountNo" + '${bankCd}').value = "";
	} else { //Deo [01.12.2017]: add ends (SR-22498)
		$("dcbBankName").value = objAC.defBankName;
		$("dcbBankAccountNo" + '${bankCd}').value = objAC.defBankAccountNo;
	}
	disableDate("hrefCheckDate");
	
	if ($F("grossTag") == 'Y'){
		$("gross").checked = true;
		$("net").checked = false;
	}else if ($F("grossTag") == 'N') {
		$("gross").checked = false;
		$("net").checked = true;
	}else{
		//$("gross").click();
		if(nvl('${defaultOrGrossTag}', 'G') == "N"){
			$("net").checked = true;		
		} else {
			$("gross").checked = true;	
		}
	}

	$("gross").observe("change", function () {
		changeTag = 1;
	});

	$("net").observe("change", function () {
		changeTag = 1;
	});
	
	$("paymentMode").observe("change", function() { // added for initial value for checkClass when selecting check as payment mode - irwin 8.1.2012
		/* added by Kris 01.28.2013 */
		//$("editCollnParticulars").disabled = false;
		$("editCollnParticulars").disabled = $("particular").disabled == true ? true : false;
		
		/* 
		commented out by robert 10.16.2013
		$("grossAmt").disabled = $("net").checked == true ? false : true;
		$("deductionComm").disabled = $("net").checked == true ? false : true;
		$("vatAmount").disabled = $("net").checked == true ? false : true; 
		*/
		
		$("fcGrossAmt").disabled = $("net").checked == true ? true : true;
		$("fcCommAmt").disabled = $("net").checked == true ? true : true;
		$("fcTaxAmt").disabled = $("net").checked == true ? true : true;
		$("fcNetAmt").disabled = $("net").checked == true ? true : true;
		/* end */
		
		if(this.value == "CHK"){
			if($F("checkClass") == ""){
				$("checkClass").value = "L";
			}	
		} else if(this.value == "CA"){ // added by Kris 01.28.2013: Particulars should be enabled if paymentMode is not cash.
			 $("particular").value = "";
			 $("particular").disabled = true;
			 $("editCollnParticulars").disabled = true;			 
		}else if(this.value == "RCM" && !($("riCommTag").checked)){
			showWaitingMessageBox("RI Commissions should be tagged for RCM Pay Mode", "I", 
				function(){
					$("riCommTag").checked = true;
					$("riCommTag").focus();
				}
			);
		}
		//added by john dolon 09.15.2014 - clear values when paymode is changed
		$("checkCreditCardNo").value = "";
		$("checkDateCalendar").value = "";
		$("localCurrAmt").value = "0.00";
		$("grossAmt").value = "0.00";
		$("deductionComm").value = "0.00";
		$("vatAmount").value = "0.00";
		$("fcGrossAmt").value = "0.00";
		$("fcCommAmt").value = "0.00";
		$("fcTaxAmt").value = "0.00";
		$("fcNetAmt").value = "0.00";
		$("particular").value = "";
		$("currency").value = objAC.defCurrency;
		$("currRt").value = formatToNineDecimal($("currency").options[$("currency").selectedIndex].getAttribute("currRate"));
		objAC.defaultRate = formatToNineDecimal($("currency").options[$("currency").selectedIndex].getAttribute("currRate"));
		$("bank").value = "";
	});
	
	$("checkClass").observe("blur", function() {
		if($F("checkDateCalendar") != "") {
			fireEvent($("checkDateCalendar"),  "blur");
		}
	});
	
	// added by Kris 01.28.2013
	/* 
	commented out by robert 10.16.2013
	$("net").observe("click", function(){
		toggleAmountFields(false);
	});
	
	$("gross").observe("click", function(){
		toggleAmountFields(true);
	}); */
	
	function populatePayMode(){ // added by: Nica 06.14.2013 AC-SPECS-2012-155
		if($("riCommTag").value == "Y"){
			for(var i=0, length=$("paymentMode").options.length; i < length; i++){
				var option = $("paymentMode").options[i];
				if(option.value != "RCM"){
					hideOption(option);
				}else{
					showOption(option);
					option.selected = true;
					//fireEvent($("paymentMode"), "change");
					riCommTagPaymodeChange();
					$("paymentMode").removeAttribute("changed");
				}
			}
		}else{
			for(var i=0, length=$("paymentMode").options.length; i < length; i++){
				var option = $("paymentMode").options[i];
				if(option.value == "RCM"){
					hideOption(option);
				}else{
					showOption(option);
				}
			}
			$("paymentMode").value = "";
			//fireEvent($("paymentMode"), "change");
			riCommTagPaymodeChange();
			$("paymentMode").removeAttribute("changed");
		}
	}
	
	//added john 10.28.2014
	function riCommTagPaymodeChange(){
		$("editCollnParticulars").disabled = $("particular").disabled == true ? true : false;
		$("fcGrossAmt").disabled = $("net").checked == true ? true : true;
		$("fcCommAmt").disabled = $("net").checked == true ? true : true;
		$("fcTaxAmt").disabled = $("net").checked == true ? true : true;
		$("fcNetAmt").disabled = $("net").checked == true ? true : true;
		$("checkCreditCardNo").value = "";
		$("checkDateCalendar").value = "";
		$("localCurrAmt").value = "0.00";
		$("grossAmt").value = "0.00";
		$("deductionComm").value = "0.00";
		$("vatAmount").value = "0.00";
		$("fcGrossAmt").value = "0.00";
		$("fcCommAmt").value = "0.00";
		$("fcTaxAmt").value = "0.00";
		$("fcNetAmt").value = "0.00";
		$("particular").value = "";
		$("currency").value = objAC.defCurrency;
		$("currRt").value = formatToNineDecimal($("currency").options[$("currency").selectedIndex].getAttribute("currRate"));
		objAC.defaultRate = formatToNineDecimal($("currency").options[$("currency").selectedIndex].getAttribute("currRate"));
		$("bank").value = "";

		$("credCardDiv").style.backgroundColor = $("checkCreditCardNo").getStyle('background-color').toString();
		$("checkDateCalendar").style.backgroundColor = $("checkDateCalendar").getStyle('background-color').toString();
		$("currency").addClassName("required");
		$("localCurrAmt").addClassName("required");
		$("currRt").addClassName("required");
		$("currRt").disabled = false;
		$("localCurrAmt").disabled = false;
		$("currency").disabled = false;

		$("bank").disabled = true;
		$("checkClass").disabled = true;
		$("checkCreditCardNo").disabled = false;
		$("checkDateCalendar").disabled = false;
		disableDate("hrefCheckDate");
		$("checkClass").selectedIndex = 0;
		//$("bank").value = null; pjsantos 08/09/2016 to prevent ora-06512 when saving a RCM.
					
		$("bank").removeClassName("required");
		$("checkClass").removeClassName("required");
		$("checkCreditCardNo").addClassName("required");
		$("checkDateCalendar").addClassName("required");
		$("credCardDiv").style.backgroundColor = $("checkCreditCardNo").getStyle('background-color').toString();
		$("checkDateBack").style.backgroundColor = $("checkDateCalendar").getStyle('background-color').toString();

		$("checkDateCalendar").style.backgroundColor = $("paymentMode").getStyle('background-color').toString();
		$("checkDateBack").style.backgroundColor = $("paymentMode").getStyle('background-color').toString();
					
		$("oscmCheckCredit").show();
		$("dcbBankName").disabled = false;
		$$("select[name='dcbBankAccountNo']").each(function (r) {
			r.disabled = false;
		});
		enableDisableMoneyValues("enable");

		$("dcbBankName").removeClassName("required");
		$$("select[name='dcbBankAccountNo']").each(function (r) {
			r.removeClassName("required");
		});
		$("checkCreditCardNo").readOnly = true;
		$("checkDateCalendar").readOnly = true;
		$("currency").disabled = true;
		$("localCurrAmt").readOnly = true;
		$("grossAmt").readOnly = true;
		$("deductionComm").readOnly = true;
		$("vatAmount").readOnly = true;
		$("fcGrossAmt").readOnly = true;
		$("fcCommAmt").readOnly = true;
		$("fcTaxAmt").readOnly = true;
		$("fcNetAmt").readOnly = true;
	}
	
	// added by: Nica 06.14.2013 AC-SPECS-2012-155
	$("riCommTag").observe("click", function(){
		$("riCommTag").value = $("riCommTag").checked ? "Y" : "N"; 
		populatePayMode();
	});
	
	populatePayMode(); // added by: Nica 06.14.2013 AC-SPECS-2012-155
	changeBankDetails();
	checkTableIfEmpty("rowItem", "collectionPaymentTableHeader");
	addStyleToInputs();
	initializeAll();
	//$("gross").click(); // andrew - 05.10.2011 - to select the gross radio by default // Commented by tonio may 16, 2011 conflicts loading of tag value
</script>