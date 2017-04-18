<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<input type="hidden" id="itemNoListToDelete" name="itemNoListToDelete" />
<input type="hidden" id="pdcItemIdToDelete" name="pdcItemIdToDelete" />

<div id="collnDtlInformation" style="width: 100%;">
	<div id="searchResultCollnItem" align="center">
		<div id="collnItemTable" style="width: 100%;" id="itemTable" name="dtlTable">
			<div id="collnItemTableContainer" class="tableContainer">
				<c:forEach var="collnDtl" items="${collnDtls}">
					<div id="rowItem${collnDtl.itemNo}" name="rowItem" class="tableRow" >
						<input type="hidden" name="itemNos" 			value="${collnDtl.itemNo}" />
						<input type="hidden" name="paymentModes" 		value="${collnDtl.payMode}" />
						<input type="hidden" name="bankNames" 			value="${collnDtl.dcbBankName}" />
						<input type="hidden" name="checkClasses"		value="${collnDtl.checkClass}" />
						<input type="hidden" name="checkCrediCardNos" 	value="${collnDtl.checkNo}" />
						<input type="hidden" name="checkDates"	 		value="<fmt:formatDate value="${collnDtl.checkDate}" pattern="MM-dd-yyyy" />" />
						<input type="hidden" name="localCurrAmts" 		value="<fmt:formatNumber value="${collnDtl.fCurrencyAmt * collnDtl.currencyRt}" pattern="#,###,##0.00" />" />
						<input type="hidden" name="currencys" 			value="${collnDtl.currencyCd}" />
						<input type="hidden" name="banks" 				value="<c:if test="${collnDtl.bankCd eq null}">-</c:if>${collnDtl.bankCd}" />
						<input type="hidden" name="particulars" 		value="${collnDtl.particulars}" />
						<input type="hidden" name="grossAmts" 			value="<fmt:formatNumber value="${collnDtl.grossAmt}" pattern="#,###,##0.00" />" />
						<input type="hidden" name="deductionComms" 		value="<fmt:formatNumber value="${collnDtl.commAmt}" pattern="#,###,##0.00" />" />
						<input type="hidden" name="vatAmounts" 			value="<fmt:formatNumber value="${collnDtl.vatAmt}" pattern="#,###,##0.00" />" />
						<input type="hidden" name="fcGrossAmts" 		value="<fmt:formatNumber value="${collnDtl.fcGrossAmt}" pattern="#,###,##0.00" />" />
						<input type="hidden" name="fcCommAmts"	 		value="<fmt:formatNumber value="${collnDtl.fcCommAmt}" pattern="#,###,##0.00" />" />
						<input type="hidden" name="fcTaxAmts"	 		value="<fmt:formatNumber value="${collnDtl.taxAmt}" pattern="#,###,##0.00" />" />
						<input type="hidden" name="fcNetAmts" 			value="<fmt:formatNumber value="${collnDtl.fCurrencyAmt}" pattern="#,###,##0.00" />" />
						<input type="hidden" name="currencyRts" 		value="${collnDtl.currencyRt}" />
						<input type="hidden" name="dcbBankCds" 			value="${collnDtl.dcbBankCd}" />
						<input type="hidden" name="dcbBankAcctCd" 		value="${collnDtl.dcbBankAcctCd}" />
						<input type="hidden" name="bankCds" 			value="${collnDtl.bankCd}" />
						<input type="hidden" name="recordStatus" 		value="3" />
						<input type="hidden" name="collnAmt" 			value="${collnDtl.amt}" />
						<input type="hidden" name="cmTranId" 			value="${collnDtl.cmTranId}" />
						<input type="hidden" name="itemId" 				value="${collnDtl.itemId}" />
						<input type="hidden" name="pdcId" 				value="${collnDtl.pdcId}" /> <!-- added john dolon; 6.4.2015; for disabling of collection breakdown for APDC -->
						<label style="width: 70px; text-align: center;">${collnDtl.itemNo}</label>
						<label style="width: 100px; text-align: left;">${collnDtl.payMode}</label>
						<label style="width: 160px; text-align: left;" name="dcbBankName"><c:if test="${collnDtl.bankName eq null}">-</c:if>${collnDtl.bankName}</label>
						<label style="width: 90px; text-align: left;"><c:if test="${collnDtl.checkClass eq null}">-</c:if>${collnDtl.checkClass}</label>
						<label style="width: 160px; text-align: center;"><c:if test="${collnDtl.checkNo eq null}">-</c:if>${collnDtl.checkNo}</label>
						<label style="width: 75px; text-align: center;"><c:if test="${collnDtl.checkDate eq null}">-</c:if><fmt:formatDate value="${collnDtl.checkDate}" pattern="MM-dd-yyyy" /></label>
						<label style="width: 160px; text-align: right;"><fmt:formatNumber value="${collnDtl.amt}" pattern="#,###,##0.00" /></label>
						<label style="width: 60px; text-align: center;">${collnDtl.currency}</label>
					</div>
				</c:forEach>
			</div>
		</div>
	</div>
</div>

<script type="text/javaScript">
	var selectedRowId = '';
	var recordStatus = 3;
	objAC.defBankName = unescapeHTML2('${bankName}');
	objAC.defBankAccountNo = '${bankAcctCd}';
	objAC.defBankAcctCd = '${bankCd}';
	resetCollectionDetails();
	checkPrintedOrCancelled();
	function checkCollectionList(){
		if ($$("div[name='rowItem']").size() > 0){
			$("collnDtlTotalAmtMainDiv").show();
			$("riCommTag").disable();
		}else {
			$("collnDtlTotalAmtMainDiv").hide();
			$("riCommTag").enable();
		}
	}

	function computeCollnTotal(){
		var totalCollnAmt = 0;
		$$("div[name='rowItem']").each(function (row){
			totalCollnAmt = totalCollnAmt + parseFloat(row.down("input", 22).value.replace(/,/g, ""));
		});
		$("lblCollnsTotal").innerHTML = formatCurrency(totalCollnAmt);
	}

	$$("label[name='dcbBankName']").each(function (lbl) {
		lbl.update((lbl.innerHTML).truncate(22, "...."));
	});
	
	$$("div[name='rowItem']").each(function (div) {
		divEvents(div);
	});
	
	$("paymentMode").observe("change", function() {
		setRequiredByPaymode();
		if($F("paymentMode") == "CHK"){
			$("checkClass").value = nvl('${defaultCheckClass}', "L");	
		}
	});
	
	$("btnDelete").observe("click", function(){
		$("itemNoListToDelete").value = $F("itemNoListToDelete") + "" + $F("itemNo")+ ",";
		if($F("pdcItemId") != ""){
			$("pdcItemIdToDelete").value = $F("pdcItemIdToDelete") + "" + $F("pdcItemId")+ ",";
		}
		$$("div[name='rowItem']").each(function (row) {
			if (row.hasClassName("selectedRow"))	{
				row.removeClassName("selectedRow");
				Effect.Fade(row, {
					duration: .2,
					afterFinish: function()	{
						row.remove();		
						recomputeTotal();
						resetCollectionDetails();
						checkTableIfEmpty("rowItem", "collectionPaymentTableHeader");
						showCollectionButton(false);
						setEnabledDisabledProperties("disable");
						checkIfToResizeTable("collectionPaymentList", "rowItem");
						checkCollectionList();
						computeCollnTotal();
					}
				});
			}
		});
	});
	
	function validateStaleCheck() {
		try {
			if($F("paymentMode") == "CHK") {
				if($F("checkDateCalendar") == "") {
					showMessageBox("Required fields must be entered", imgMessage.ERROR);
					return "N";
				} else if(isNaN($F("staleMgrChk"))) {
					showMessageBox("No data found for parameter STALE_MGR_CHK in giac_parameters", imgMessage.ERROR);
					return "N";
				} else {
					var orDate = makeDate($F("orDate"));
					var checkDate = makeDate($F("checkDateCalendar"));
					var staleDate = orDate;
					var staleParam = $F("checkClass") == "M" ? parseInt($F("staleMgrChk")) : parseInt($F("staleCheck"));
					staleDate = new Date(staleDate.addMonths(staleParam*-1));
				
					if(checkDate <= staleDate) {
						$("checkDateCalendar").value = "";
						customShowMessageBox("This is a stale check.", imgMessage.ERROR, "checkDateCalendar");
						return "N";
					}
					
					var checkStDate = new Date(checkDate.addMonths(staleParam));
					var staleDaysNo = (checkStDate - makeDate($F("orDate")))/(1000*60*60*24);
					//var staleDaysNo = computeNoOfDays($F("checkDateCalendar"), dateFormat(new Date(), 'mm-dd-yyyy'), null);
					if(staleDaysNo <= parseInt($F("staleDays")) && staleDaysNo != 0){
						return staleDaysNo;
						/* if(staleDaysNo == 1) {
							showMessageBox("This check will be stale tomorrow.", imgMessage.ERROR);
							return false;
						}else {
							showMessageBox("This check will be stale within "+staleDaysNo+" days.", imgMessage.ERROR);
							return false;
						} */
					}else{
						return "Y";
					}
				}
			}
			
			return "Y";
		} catch(e) {
			showErrorMessage("validateStaleCheck", e);
		}
	}
	
	$("btnAdd").observe("click", addCollnDtl);

	function continueAdd(){
		if (checkCurrency()){
			if (unformatCurrency("localCurrAmt")> 0){
				changeTag = 1;
				if ("Update" != $F("btnAdd")) {
					generateSequenceFromLastValue("rowItem", "itemNo");
				}
				var itemNo = $F("itemNo").blank()? '1' : $F("itemNo");
				var payMode = $F("paymentMode");
				var bankName = $F("dcbBankName");
				var checkClass = $("checkClass").selectedIndex == 0 ? "-" : $F("checkClass");
				var checkCreditCardNo = $F("checkCreditCardNo").blank() ? "-" : $F("checkCreditCardNo");
				var checkDate = $F("checkDateCalendar").blank() ? "-" : $F("checkDateCalendar");
				var localCurrAmt = $F("localCurrAmt");
				var currency = $F("currency");
				var bank = $F("bank") == "" || $F("bank") == null ? "-" : $("bank").options[$("bank").selectedIndex].innerHTML;// modified by pjsantos 08/09/2016, $F("bank") == "" || $F("bank") == null
				var particular = $F("particular");
				var grossAmt = $F("grossAmt");
				var deductionComm = $F("deductionComm");
				var vatAmount = $F("vatAmount");
				var currRt = $F("currRt");
				var fcGrossAmt = unformatCurrency("fcGrossAmt");
				var fcCommAmt = $F("fcCommAmt");
				var fcTaxAmt = $F("fcTaxAmt");
				var fcNetAmt = unformatCurrency("fcNetAmt");//unformatCurrency("fcNetAmt");unformatCurrency("localCurrAmt")
				var newDiv = new Element("div");
				var itemTable = $("collectionPaymentList");
				var dcbBankCd = nvl($("dcbBankName").options[$("dcbBankName").selectedIndex].getAttribute("bankCd"), "");
				var dcbBankAcctCd = $("dcbBankAccountNo" + $("dcbBankName").options[$("dcbBankName").selectedIndex].getAttribute("bankCd")) == null ? "" : $("dcbBankAccountNo" + $("dcbBankName").options[$("dcbBankName").selectedIndex].getAttribute("bankCd")).value;
				var dcbBankAcctNo = $("dcbBankAccountNo" + $("dcbBankName").options[$("dcbBankName").selectedIndex].getAttribute("bankCd")) == null ? "" : $("dcbBankAccountNo" + $("dcbBankName").options[$("dcbBankName").selectedIndex].getAttribute("bankCd")).options[$("dcbBankAccountNo" + $("dcbBankName").options[$("dcbBankName").selectedIndex].getAttribute("bankCd")).selectedIndex].innerHTML;
				var bankCd = $F("bank");
				var cmTranId = $("hidCmTranId").value;
				var pdcItemId = $("pdcItemId").value; //john 12.8.2014
				newDiv.setAttribute("id", "rowItem"+itemNo);
				newDiv.setAttribute("name", "rowItem");
				newDiv.writeAttribute("class", "tableRow");
				var strDiv = ''+
				'<input type="hidden" name="itemNos" value="'+itemNo+'" />'+
				'<input type="hidden" name="paymentModes" value="'+payMode+'" />'+
				'<input type="hidden" name="bankNames" value="'+bankName+'" />'+
				'<input type="hidden" name="checkClasses" value="'+checkClass+'" />'+
				'<input type="hidden" name="checkCreditCardNos" value="'+checkCreditCardNo+'" />'+
				'<input type="hidden" name="checkDates" value="'+checkDate+'" />'+
				'<input type="hidden" name="localCurrAmts" value="'+localCurrAmt+'" />'+
				'<input type="hidden" name="currencys" value="'+currency+'" />'+
				'<input type="hidden" name="banks" value="'+bank+'" />'+
				'<input type="hidden" name="particulars" value="'+escapeHTML2(particular)+'" />'+ //added escapeHTML2 by robert 10.09.2013
				'<input type="hidden" name="grossAmts" value="'+grossAmt+'" />'+
				'<input type="hidden" name="deductionComms" value="'+deductionComm+'" />'+
				'<input type="hidden" name="vatAmounts" value="'+vatAmount+'" />'+
				'<input type="hidden" name="fcGrossAmts" value="'+fcGrossAmt+'" />'+
				'<input type="hidden" name="fcCommAmts" value="'+fcCommAmt+'" />'+
				'<input type="hidden" name="fcTaxAmts" value="'+fcTaxAmt+'" />'+
				'<input type="hidden" name="fcNetAmts" value="'+fcNetAmt+'" />'+
				'<input type="hidden" name="currencyRts" value="'+currRt+'" />'+
				'<input type="hidden" name="dcbBankCds" value="'+dcbBankCd+'" />'+
				'<input type="hidden" name="dcbBankAcctCd" value="'+dcbBankAcctCd+'" />'+
				'<input type="hidden" name="bankCds" value="'+bankCd+'" />' +
				'<input type="hidden" name="recordStatus" value="0" />' +
				'<input type="hidden" name="collnAmt" value="'+localCurrAmt+'" />'+
				'<input type="hidden" name="cmTranId" value="'+cmTranId+'" />' +
				'<input type="hidden" name="pdcItemId" value="'+pdcItemId+'" />'; //john 12.8.2014

				strDiv += '<label style="width: 70px; text-align: center;">'+itemNo+'</label>';
				strDiv += '<label style="width: 100px; text-align: left;">'+payMode+'</label>';
				strDiv += '<label style="width: 160px; text-align: left;">'+bank.truncate(22,"....")+'</label>';
				strDiv += '<label style="width: 90px; text-align: left;">'+checkClass+'</label>';
				strDiv += '<label style="width: 160px; text-align: center;">'+checkCreditCardNo+'</label>';
				strDiv += '<label style="width: 75px; text-align: center;">'+checkDate+'</label>';
				strDiv += '<label style="width: 160px; text-align: right;">'+localCurrAmt+'</label>';
				strDiv += '<label style="width: 60px; text-align: center;">'+$("currency").options[$("currency").selectedIndex].getAttribute("shortName")+'</label>';
				if ("Update" == $F("btnAdd")) {
					$$("div[name='rowItem']").each(function (div) {
						if (div.hasClassName("selectedRow")) {
							newDiv = div;
						}
					});
					newDiv.update(strDiv);
				} else {
					newDiv.update(strDiv);
					itemTable.insert({bottom: newDiv});
					divEvents(newDiv);
				}
				new Effect.Appear(newDiv, {
					duration: .2,
					afterFinish: function () {
					checkTableIfEmpty("rowItem", "collectionPaymentTableHeader");
					checkIfToResizeTable("collectionPaymentList", "rowItem");
					}
				});
				resetCollectionDetails();
				recomputeTotal();
			
			} else {
				showMessageBox("Invalid Amount.", imgMessage.ERROR);
			}
		}
	}
	
	function addCollnDtl() {
		//if (checkRequiredDisabledFields() && $("dcbBankAccountNo" + $("dcbBankName").options[$("dcbBankName").selectedIndex].getAttribute("bankCd")).selectedIndex > 0){
		/*if (checkRequiredDisabledFields2() && ($("dcbBankName").options[$("dcbBankName").selectedIndex].value == "" ||
				$("dcbBankAccountNo" + $("dcbBankName").options[$("dcbBankName").selectedIndex].getAttribute("bankCd")).selectedIndex > 0)){*/ // replaced by: Nica 06.15.2013
		if (checkRequiredDisabledFields2()){
			
			if($F("paymentMode") != "RCM" && $F("paymentMode") != "CW" && $F("paymentMode") != "CMI"){ //added by: Nica 06.15.2013; Marco - 11.21.2014 - added CW; pjsantos - 12/12/2016 - added CMI GENQA 5877
				if($("dcbBankName").options[$("dcbBankName").selectedIndex].value == "" ||
				   $("dcbBankAccountNo" + $("dcbBankName").options[$("dcbBankName").selectedIndex].getAttribute("bankCd")).selectedIndex == 0){
					customShowMessageBox(objCommonMessage.REQUIRED, "I", "dcbBankName");
					return false;
				}
			}
		 
			//marco - 09.09.2014
			var proceed = true;
			$$("div[name='rowItem']").each(function (div) {
				if($F("paymentMode") == "CMI" && div.down("input", 1).value == "CMI" && $F("checkCreditCardNo") == div.down("input", 4).value && $F("btnAdd") != "Update"){
					showMessageBox("Selected Internal Credit Memo already exists.", "E");
					proceed = false;
				}
			});
			if(!proceed){
				return;
			}
			
			/* if(!(validateStaleCheck())) {
				return; 
			} */
			/* var staleDaysNo = validateStaleCheck();
			if(!(isNaN(staleDaysNo)) && $F("paymentMode") == "CHK"){
				if(staleDaysNo == 1) {
					showWaitingMessageBox("This check will be stale tomorrow.", imgMessage.ERROR, continueAdd);
				}else {
					showWaitingMessageBox("This check will be stale within "+staleDaysNo+" days.", imgMessage.ERROR, continueAdd);
				}
			}else if(staleDaysNo == "Y"){
				continueAdd();
			} */
			continueAdd();
		} else {
			showMessageBox("Please complete all required fields.", imgMessage.ERROR);
		}
		checkCollectionList();
		computeCollnTotal();
		clearChangeAttribute("collectionBreakdownDiv");
	}

	
	/*
		function to perform events in loaded and added rows.
	*/
	function divEvents(div) {
		div.observe("mouseover", function () {
			div.addClassName("lightblue");
		});
		
		div.observe("mouseout", function ()	{
			div.removeClassName("lightblue");
		});

		div.observe("click", function () {
			selectedRowId = div.getAttribute("id");
			div.toggleClassName("selectedRow");
			if (div.hasClassName("selectedRow"))	{
				$$("div[name='rowItem']").each(function (r)	{
					if (div.getAttribute("id") != r.getAttribute("id"))	{
						r.removeClassName("selectedRow");
					}
			    });
				$("itemNo").value = div.down("input", 0).value;
				$("paymentMode").value = div.down("input", 1).value;
				var a = div.down("input", 18).value;
				$$($("dcbBankName").options).each(function(e){
					if(e.getAttribute("bankCd") == a){
						e.selected = true;
					}
				});
				
				changeBankDetails();
				$("checkClass").value = div.down("input", 3).value;
				$("checkCreditCardNo").value = ($F("paymentMode") == "CA" || $F("paymentMode") == "" || div.down("input", 4).value == "-" ? null : div.down("input", 4).value);
				$("checkDateCalendar").value = ($F("paymentMode") == "CA" || $F("paymentMode") == "" || div.down("input", 5).value == "-" ? null : div.down("input", 5).value);
				$("localCurrAmt").value = formatCurrency(div.down("input", 22).value);//div.down("input", 6).value;//div.down("input", 10).value;div.down("input", 6).value;
				$("currency").value = div.down("input", 7).value;
				$("bank").value = div.down("input", 20).value;
				$("particular").value = unescapeHTML2(div.down("input", 9).value); //added unescapeHTML2 by robert 10.09.2013
				$("grossAmt").value = div.down("input", 10).value;
				$("deductionComm").value = div.down("input", 11).value == "" ? formatCurrency(0) : div.down("input", 11).value;
				$("vatAmount").value = div.down("input", 12).value == "" ? formatCurrency(0) : div.down("input", 12).value;
				$("fcGrossAmt").value = div.down("input", 13).value == "" ? formatCurrency(0) : formatCurrency(div.down("input", 13).value);
				$("fcCommAmt").value = div.down("input", 14).value == "" ? formatCurrency(0) : div.down("input", 14).value;
				$("fcTaxAmt").value = div.down("input", 15).value == "" ? formatCurrency(0) : div.down("input", 15).value;
				//$("fcNetAmt").value = div.down("input", 16).value;
				$("currRt").value = formatToNineDecimal(div.down("input", 17).value);
				$("origlocalCurrAmt").value = /*$F("fcGrossAmt")*/div.down("input", 22).value;
				$("dcbBankAccountNo"+div.down("input", 18).value).value = div.down("input", 19).value;
				$("fcNetAmt").value = formatCurrency((Math.round(( unformatCurrency("grossAmt") / parseFloat($F("currRt")))*100)/100) - unformatCurrency("fcCommAmt") - unformatCurrency("fcTaxAmt"));
				$("origFCGrossAmt").value = $F("fcGrossAmt");  //added by d.alcantara, 11-04-2011, to assign the fc_gross_amt of the selected payment 
				$("hidCmTranId").value = div.down("input", 23).value;
				$("pdcItemId").value = div.down("input", 24).value; //added by john 12.8.2014
				recordStatus = div.down("input", 21).value;
				
				// to compute fcNetAmt - dencal25 - 2010-09-20
				$("localCurrAmt").focus();
				$("itemNo").focus();
				if((objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR") && objAC.tranFlagState != "C"/* && nvl('${withAPDC}', 'N') == 'N'*/){ // andrew - 08.14.2012 - SR 0010292 //john dolon 6.4.2015; For disabling of fields for APDC
					showCollectionButton(true);
					setRequiredByPaymode();
					if (recordStatus == 3 && (objACGlobal.orFlag != 'N'
						&& !(objACGlobal.orTag == "*" && objAC.tranFlagState == "O"))) { //Deo [02.16.2017]: SR-5932
						setEnabledDisabledProperties("disable");
					}
				}
				
				if(div.down("input", 25).value != ""){ //john dolon 6.4.2015; For disabling of fields for APDC
					$("paymentMode").disable();
					$("bank").disabled = true;
					$("checkClass").disabled = true;
					disableDate("hrefCheckDate");
					$("localCurrAmt").disabled = true;
					$("currency").disabled = true;
					$("currRt").disabled = true;
					$("grossAmt").disabled = true;
					$("deductionComm").disabled = true;
					$("vatAmount").disabled = true;
					$("fcGrossAmt").disabled = true;
					$("fcCommAmt").disabled = true;
					$("fcTaxAmt").disabled = true;
					$("fcNetAmt").disabled = true;
					$("particular").disabled = true;
					disableButton("btnAdd");
					disableButton("btnDelete");
				} 
	    	//$("dcbBankAccountNo").hide();
	    	checkPrintedOrCancelled(); //added by MarkS SR5570 7.19.2016 to disable fields if or is printed or cancelled
			} else {
				var bankDetails = document.getElementsByName('dcbBankAccountNo');
		    	for(i = 0; i < bankDetails.length; i++) {
		    		bankDetails[i].hide();
		    	}
		    	$("dcbBankAccountNo").show();
		    	$("currency").value = objAC.defCurrency;
		    	$("currRt").value = objAC.defaultRate;
		    	$("hidCmTranId").value = "";
		    	$("pdcItemId").value = ""; //john 12.8.2014
		    	showCollectionButton(false);
		    	setRequiredByPaymode(); //john dolon 6.4.2015; For disabling of fields for APDC
		    	if((objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR") && objAC.tranFlagState != "C" /*&& nvl('${withAPDC}', 'N') == 'N'*/){ // andrew - 08.14.2012 - SR 0010292 //john dolon 6.4.2015; For disabling of fields for APDC
		    		setEnabledDisabledProperties("disable");
		    		$("paymentMode").disabled = false;
		    	} else {
		    		$("paymentMode").disabled = true;
		    	}
		    	
		    	if($F("paymentMode") == "CHK"){
					$("checkClass").value = nvl('${defaultCheckClass}', "L");	
				}
		    	checkPrintedOrCancelled(); //added by MarkS SR5570 7.19.2016 to disable fields if or is printed or cancelled
			};
			
			if($F("currency") == "1" || $("currency").getAttribute("shortName") == "PHP") {
				$("currRt").readOnly = true;
			} else {
				$("currRt").readOnly = false;
			}
/* 
			if (objAC.tranFlagState != 'O'){
				$("paymentMode").disabled = true;
				disableButton("btnAdd");
				disableButton("btnDelete");
			}*/
			
			checkFlags();
		});
	}

	function checkFlags(){
		if (objACGlobal.orTag == "*") {
			if (objAC.tranFlagState != 'O'){
				$("paymentMode").disabled = true;
				disableButton("btnAdd");
				disableButton("btnDelete");
				disableButton("btnSave");
				$("payorName").readOnly = true;
				$("payorAddress1").readOnly = true; //adpascual - 03.26.2012 - 
				$("payorAddress2").readOnly = true; //adpascual - 03.26.2012 - 
				$("payorAddress3").readOnly = true; //adpascual - 03.26.2012 - 
				$("payorTinNo").readOnly = true;
				$("payorParticulars").readOnly = true;
				$("intermediary").disabled = true;
				$("oscmPayor").disabled = true;
				$("remittance").readOnly = true;
				$("gross").disabled = true;
				$("net").disabled = true;
				setEnabledDisabledProperties("disable");
			}
		}else if (objACGlobal.orTag == "" || objACGlobal.orTag == null){
			if (/*objACGlobal.orFlag != 'N' && objACGlobal.orFlag != null*/$F("orFlag") != 'N' && $F("orFlag") != ""){ //christian 08.30.2012 added condition for blank orFlag
				$("paymentMode").disabled = true;
				disableButton("btnAdd");
				disableButton("btnDelete");
				disableButton("btnSave");
				$("payorName").readOnly = true;
				$("payorAddress1").readOnly = true; //adpascual - 03.26.2012
				$("payorAddress2").readOnly = true; //adpascual - 03.26.2012
				$("payorAddress3").readOnly = true; //adpascual - 03.26.2012
				$("payorTinNo").readOnly = true;
				$("payorParticulars").readOnly = true;
				$("intermediary").disabled = true;
				$("oscmPayor").disabled = true;
				$("remittance").readOnly = true;
				$("gross").readOnly = true;
				$("net").disabled = true;
				setEnabledDisabledProperties("disable");
			}
		}
	}

	function setEnabledDisabledProperties(action){
		if (action == "disable"){
			if (objACGlobal.callingForm == "orListing"){
				//removed by robert 11.12.2013
				/* $("dcbBankName").disabled = true;
				$$("select[name='dcbBankAccountNo']").each(function (r) {
					r.disabled = true;
				}); */ 
				$("bank").disabled = true;
				$("checkClass").disabled = true;
				$("checkCreditCardNo").disabled = true;
				$("checkDateCalendar").disabled = true;
				$("localCurrAmt").disabled = true;
				$("currency").disabled = true;
				$("particular").disabled = true;
				$("grossAmt").disabled = true;
				$("deductionComm").disabled = true;
				$("vatAmount").disabled = true;
				$("fcGrossAmt").disabled = true;
				$("fcCommAmt").disabled = true;
				$("fcTaxAmt").disabled = true;
				$("fcNetAmt").disabled = true;
				$("currRt").disabled = true;
			}
		}else{
			$("dcbBankName").disabled = false;
			$("paymentMode").disabled = false;
			$("bank").disabled = false;
			$("checkClass").disabled = false;
			$("checkCreditCardNo").disabled = false;
			$("checkDateCalendar").disabled = false;
			$("localCurrAmt").disabled = false;
			$$("select[name='dcbBankAccountNo']").each(function (r) {
				r.disabled = false;
			});
		}
	}

	function enableDisableMoneyValues(action){
		if (action == "enable") {
			$("currency").disabled = false;
			$("particular").disabled = false;
			$("grossAmt").disabled = false;
			$("deductionComm").disabled = false;
			$("vatAmount").disabled = false;
			$("fcGrossAmt").disabled = false;
			$("fcCommAmt").disabled = false;
			$("fcTaxAmt").disabled = false;
			$("fcNetAmt").disabled = false;
		}else{
			$("currency").disabled = true;
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
	
	function setRequiredByPaymode(){
		$("credCardDiv").style.backgroundColor = $("checkCreditCardNo").getStyle('background-color').toString();
		$("checkDateCalendar").style.backgroundColor = $("checkDateCalendar").getStyle('background-color').toString();
		$("currency").addClassName("required");
		$("localCurrAmt").addClassName("required");
		$("currRt").addClassName("required");
		$("currRt").disabled = false;
		$("localCurrAmt").disabled = false;
		$("currency").disabled = false;
		if ($F("paymentMode") == "CA" || $F("paymentMode") == "CW"  || $F("paymentMode") == ""){
			$("bank").disabled = true;
			$("checkClass").disabled = true;
			$("checkCreditCardNo").disabled = true;
			$("checkDateCalendar").disabled = true;
			disableDate("hrefCheckDate");
			$("localCurrAmt").disabled = false;
			$("currRt").disabled = false;
			$("bank").value = null;
			$("checkClass").selectedIndex = 0;
			
			$("bank").removeClassName("required");
			$("checkClass").removeClassName("required");
			$("checkCreditCardNo").removeClassName("required");
			$("checkDateCalendar").removeClassName("required");
			$("hrefCheckDate").removeClassName("required");
			$("credCardDiv").style.backgroundColor = $("bank").getStyle('background-color').toString();
			$("checkDateBack").style.backgroundColor = $("bank").getStyle('background-color').toString();
			$("checkDateCalendar").disabled = true;
			$("oscmCheckCredit").hide();
			
			$("bank").selectedIndex = 0; //marco - 09.10.2014
			$("checkDateCalendar").style.backgroundColor = $("bank").getStyle('background-color').toString();
			
			enableDisableMoneyValues("enable");
			$("dcbBankName").disabled = false; // dren 08.27.2015 - SR 0004621: Enable DCB Bank Acct.
			if ($F("paymentMode") == "CW") {  // dren 08.27.2015 - SR 0004621: Disable DCB Bank Acct if CW. - Start
				$("dcbBankName").value = "";
				changeBankDetails();
				$("dcbBankName").disabled = true; 
				
				// apollo cruz 10.12.2015 sr 20528 - start
				$("checkCreditCardNo").disabled = false;
				$("checkDateCalendar").disabled = false;
				enableDate("hrefCheckDate");			
				$("checkCreditCardNo").removeClassName("required");
				$("checkDateCalendar").removeClassName("required");
				$("hrefCheckDate").removeClassName("required");
				$("credCardDiv").style.backgroundColor = $("checkCreditCardNo").getStyle('background-color').toString();
				$("checkDateBack").style.backgroundColor = $("checkCreditCardNo").getStyle('background-color').toString();
				$("checkDateCalendar").disabled = false;			
				$("checkDateCalendar").style.backgroundColor = $("checkCreditCardNo").getStyle('background-color').toString();
				// apollo cruz 10.12.2015 sr 20528 - end
				
			}  // dren 08.27.2015 - SR 0004621: Disable DCB Bank Acct if CW. - End
		}else if ($F("paymentMode") == "CC"){
			$("bank").disabled = false;
			$("checkClass").disabled = true;
			$("checkCreditCardNo").disabled = false;
			$("checkDateCalendar").disabled = true;
			disableDate("hrefCheckDate");
			$("checkClass").selectedIndex = 0;
			$("checkDateCalendar").value = null;
			
			$("bank").addClassName("required");
			$("checkClass").removeClassName("required");
			$("checkCreditCardNo").addClassName("required");
			$("checkDateCalendar").removeClassName("required");
			$("hrefCheckDate").removeClassName("required");
			$("credCardDiv").style.backgroundColor = $("checkCreditCardNo").getStyle('background-color').toString();
			$("checkDateBack").style.backgroundColor = $("checkDateCalendar").getStyle('background-color').toString();

			$("checkDateCalendar").style.backgroundColor = $("checkClass").getStyle('background-color').toString();
			$("checkDateBack").style.backgroundColor = $("checkClass").getStyle('background-color').toString();
			
			$("oscmCheckCredit").hide();
			enableDisableMoneyValues("enable");
			$("dcbBankName").disabled = false; // dren 08.27.2015 - SR 0004621: Enable DCB Bank Acct.
		}/* else if ($F("paymentMode") == "CM" || $F("paymentMode") == "WT"){
			$("bank").disabled = false;
			$("checkClass").disabled = true;
			$("checkCreditCardNo").disabled = false;
			$("checkCreditCardNo").removeClassName("required");
			$("credCardDiv").style.backgroundColor = "white";
			$("checkDateCalendar").disabled = false;
			$("checkDateCalendar").removeClassName("required");
			$("checkDateCalendar").style.backgroundColor = "white";
			$("checkDateBack").style.backgroundColor = "white";
			enableDate("hrefCheckDate");
			$("checkClass").selectedIndex = 0;
			
			$("bank").addClassName("required");
			$("checkClass").removeClassName("required");
			
			$("oscmCheckCredit").hide();
			enableDisableMoneyValues("enable"); */
		else if ($F("paymentMode") == "WT"){ // dren 08.18.2015 - SR 0004621: Separate conditions for paymentMode CM & WT - Start
			$("bank").disabled = false;
			$("checkClass").disabled = true;
			$("checkCreditCardNo").disabled = false;
			$("checkCreditCardNo").removeClassName("required");
			$("credCardDiv").style.backgroundColor = "white";
			$("checkDateCalendar").disabled = false;
			$("checkDateCalendar").removeClassName("required");
			$("checkDateCalendar").style.backgroundColor = "white";
			$("checkDateBack").style.backgroundColor = "white";
			enableDate("hrefCheckDate");
			$("checkClass").selectedIndex = 0;			
			$("bank").addClassName("required");
			$("checkClass").removeClassName("required");		
			$("oscmCheckCredit").hide();
			enableDisableMoneyValues("enable");
			$("dcbBankName").disabled = false;
		}else if ($F("paymentMode") == "CM"){ 
			$("checkClass").disabled = true;
			$("checkClass").removeClassName("required");
			// apollo cruz 10.12.2015 sr 20528 - start
			$("checkCreditCardNo").disabled = false;
			$("checkDateCalendar").disabled = false;
			enableDate("hrefCheckDate");
			$("checkCreditCardNo").removeClassName("required");
			$("checkDateCalendar").removeClassName("required");
			$("hrefCheckDate").removeClassName("required");
			$("checkDateCalendar").disabled = false;
			$("credCardDiv").style.backgroundColor = $("checkCreditCardNo").getStyle('background-color').toString();
			$("checkDateBack").style.backgroundColor = $("checkCreditCardNo").getStyle('background-color').toString();				
			$("checkDateCalendar").style.backgroundColor = $("checkCreditCardNo").getStyle('background-color').toString();
			// apollo cruz 10.12.2015 sr 20528 - end
			$("oscmCheckCredit").hide();
			enableDisableMoneyValues("enable");			
			$("bank").addClassName("required");
			$("bank").disabled = false;	
			changeBankDetails();
			$("dcbBankName").disabled = false; // dren 08.18.2015 - SR 0004621: Separate conditions for paymentMode CM & WT - End	
		}else if ($F("paymentMode") == "CMI"){
			$("bank").disabled = true;
			$("checkClass").disabled = true;
			$("checkCreditCardNo").disabled = false;
			$("checkDateCalendar").disabled = false;
			disableDate("hrefCheckDate");
			$("checkClass").selectedIndex = 0;
			$("bank").value = null;
			
			$("bank").removeClassName("required");
			$("checkClass").removeClassName("required");
			$("checkCreditCardNo").addClassName("required");
			$("checkDateCalendar").addClassName("required");
			$("credCardDiv").style.backgroundColor = $("checkCreditCardNo").getStyle('background-color').toString();
			$("checkDateBack").style.backgroundColor = $("checkDateCalendar").getStyle('background-color').toString();
			
			$("checkCreditCardNo").readOnly = true;
			$("checkDateCalendar").readOnly = true;

			$("bank").selectedIndex = 0; //marco - 09.10.2014
			$("checkDateCalendar").style.backgroundColor = $("paymentMode").getStyle('background-color').toString();
			$("checkDateBack").style.backgroundColor = $("paymentMode").getStyle('background-color').toString();
			
			$("oscmCheckCredit").show();
			enableDisableMoneyValues("enable");
			$("dcbBankName").value = ""; // dren 08.27.2015 - SR 0004621: Disable DCB Bank Acct. - Start
			changeBankDetails();
			$("dcbBankName").disabled = true; // dren 08.27.2015 - SR 0004621: Disable DCB Bank Acct. - End			
		}else if ($F("paymentMode") == "RCM" || $("riCommTag").value == "Y"){ // added by: Nica 06.14.2013 - AC-SPECS-2012-155
			$("bank").disabled = true;
			$("checkClass").disabled = true;
			$("checkCreditCardNo").disabled = false;
			$("checkDateCalendar").disabled = false;
			disableDate("hrefCheckDate");
			$("checkClass").selectedIndex = 0;
			$("bank").value = null;
			
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
		}else{
			$("bank").disabled = false;
			$("checkClass").disabled = false;
			$("checkCreditCardNo").disabled = false;
			$("checkDateCalendar").disabled = false;
			enableDate("hrefCheckDate");
			
			$("bank").addClassName("required");
			$("checkClass").addClassName("required");
			$("checkCreditCardNo").addClassName("required");
			$("checkDateCalendar").addClassName("required");
			$("credCardDiv").style.backgroundColor = $("bank").getStyle('background-color').toString();
			$("checkDateBack").style.backgroundColor = $("bank").getStyle('background-color').toString();

			$("checkDateCalendar").style.backgroundColor = '#FFFACD';
			$("oscmCheckCredit").hide();
			enableDisableMoneyValues("enable");
			$("dcbBankName").disabled = false; // dren 08.27.2015 - SR 0004621: Enable DCB Bank Acct.
			
			/* if($F("paymentMode") == "CHK"){
				$("checkClass").value = nvl('${defaultCheckClass}', "L");	
			} */
		}
		
		validatePayMode($F("paymentMode")); // added by: Nica 06.14.2013 - AC-SPECS-2012-155
	}
	
	function validatePayMode(payMode){
		if (payMode == "RCM" || $("riCommTag").value == "Y"){
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
		}else{
/* 			if(nvl(payMode, "") != "CW"){ //marco - 11.21.2014 - added conditions
				$("dcbBankName").addClassName("required");
				$$("select[name='dcbBankAccountNo']").each(function (r) {
					r.addClassName("required");
				});
			}else{
				$("dcbBankName").removeClassName("required");
				$$("select[name='dcbBankAccountNo']").each(function (r) {
					r.removeClassName("required");
				}); */ // dren 08.18.2015 - SR 0004621 : Comment out to Separate conditions for paymentMode "CW" and "CMI".
			if(nvl(payMode, "") == "CW" || nvl(payMode, "") == "CMI"){ // dren 08.18.2015 - SR 0004621 : Added CMI- Start
				$("dcbBankName").removeClassName("required");
				$$("select[name='dcbBankAccountNo']").each(function (r) {
					r.removeClassName("required");
				});							
				}else{
				$("dcbBankName").addClassName("required");
				$$("select[name='dcbBankAccountNo']").each(function (r) {
					r.addClassName("required");
				}); // dren 08.18.2015 - SR 0004621 : Added CMI - End				
			}
			if(payMode != "CMI"){
				$("checkCreditCardNo").readOnly = false;
				$("checkDateCalendar").readOnly = false;
			}
			$("localCurrAmt").readOnly = false;
			$("grossAmt").readOnly = false;
			$("deductionComm").readOnly = false;
			$("vatAmount").readOnly = false;
			$("fcGrossAmt").readOnly = false;
			$("fcCommAmt").readOnly = false;
			$("fcTaxAmt").readOnly = false;
			$("fcNetAmt").readOnly = false;
		}
	}
	
	function resetCollectionDetails(){
		$("dcbBankName").selectedIndex = 0;
		$("paymentMode").selectedIndex = 0;
		$("grossAmt").value = formatCurrency(0);
		$("bank").selectedIndex = 0;
		$("deductionComm").value = formatCurrency(0);
		$("checkClass").selectedIndex = 0;
		$("vatAmount").value = formatCurrency(0);
		$("checkCreditCardNo").value = null;
		$("fcGrossAmt").value = formatCurrency(0);
		$("checkDateCalendar").value = null;
		$("fcCommAmt").value = formatCurrency(0);
		$("localCurrAmt").value = formatCurrency(0);
		$("fcTaxAmt").value = formatCurrency(0);
		$("fcNetAmt").value = formatCurrency(0);
		$("particular").value = null;
		$("origlocalCurrAmt").value = formatCurrency(0);
		$("origFCGrossAmt").value = formatCurrency(0);
		$("btnAdd").value = "Add";
		disableButton("btnDelete");
		if (objACGlobal.orFlag == 'P' //Deo [01.12.2017]: add start (SR-22498)
				&& !(objACGlobal.orTag == "*" && objAC.tranFlagState == "O") //Deo [02.16.2017]: SR-5932
				|| objACGlobal.orFlag == 'C') { 
			$("dcbBankName").value = "";
			$("dcbBankAccountNo" + objAC.defBankAcctCd.toString()).value = "";
		} else { //Deo [01.12.2017]: add ends (SR-22498)
			$("dcbBankName").value = objAC.defBankName;
			$("dcbBankAccountNo" + objAC.defBankAcctCd.toString()).value = objAC.defBankAccountNo;
		}
		changeBankDetails();
		$$("div[name='rowItem']").each(function (div) {
			div.removeClassName("selectedRow");
		});
		$("currency").value = objAC.defCurrency;
		$("currRt").value = objAC.defaultRate;
		
		$('bank').disabled = true;
		$('checkClass').disabled = true;
		$('credCardDiv').disabled = true;
		$('checkDateCalendar').disabled = true;
		$('checkCreditCardNo').disabled = true;
		$('localCurrAmt').disabled = true;
		$('currRt').disabled = true;
		$("hidCmTranId").value = "";
		$("pdcItemId").value = ""; //john 12.8.2014
		var objGiacOrRel = {};
	}

	function showCollectionButton(param){
		if (param) {
			if (recordStatus != "3" || objACGlobal.orFlag == 'N'
				|| (objAC.tranFlagState == "O" && objACGlobal.orTag == "*")){ //Deo [02.16.2017]: SR-5932
				$("btnAdd").value = "Update";
			}else{
				disableButton("btnAdd");
			}
			enableButton("btnDelete");
		} else {
			if((objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR") && objAC.tranFlagState != "C" /*&& nvl('${withAPDC}', 'N') == 'N'*/){ // andrew - 08.14.2012 - SR 0010292 //john dolon 6.4.2015; For disabling of fields for APDC
				setEnabledDisabledProperties("enable");			
				enableButton("btnAdd");
			}			
			resetCollectionDetails();
		}
	}

	function recomputeTotal(){
		$("netCollectionAmt").value = "0";
		$("totGrossAmt").value = "0";	
		$$("div[name='rowItem']").each(function (div) {
			$("netCollectionAmt").value = unformatCurrency("netCollectionAmt") + parseFloat((div.down("input", 6).value).replace(/,/g, ""));
			$("totGrossAmt").value  = unformatCurrency("totGrossAmt") + parseFloat((div.down("input", 10).value).replace(/,/g, ""));
		});
	}

	function checkCurrency(){
		var isSameCurrCode = true;
		var count = 0;
		$$("div[name='rowItem']").each(function (div) {
			if ($F("currency") != div.down("input", 7).value && $F("btnAdd") != "Update"){
				showMessageBox("Only one currency is allowed per O.R.", imgMessage.ERROR);
				isSameCurrCode = false;
			}else if ($F("currency") != div.down("input", 7).value && $F("btnAdd") == "Update" && $$("div[name='rowItem']").size() > 1) {
				$$("div[name='rowItem']").each(function (div) {
					if ($F("currency") != div.down("input", 7).value){
						showMessageBox("Only one currency is allowed per O.R.", imgMessage.ERROR);
						isSameCurrCode = false;
					}
				});
			}
		});
		return isSameCurrCode;
	}
	//added by MarkS SR5570 7.19.2016 to disable fields if or is printed or cancelled
	function checkPrintedOrCancelled(){
		if((objACGlobal.orFlag == 'P'
			&& !(objAC.tranFlagState == "O" && objACGlobal.orTag == "*")) //Deo [02.10.2017]: SR-5932
				|| objACGlobal.orFlag == 'C'){
			//setEnabledDisabledProperties("disable");
			$("dcbBankName").disabled = true;
    		$("dcbBankName").removeClassName("required");
			$$("select[name='dcbBankAccountNo']").each(function (r) {
				r.disabled = true;
				r.removeClassName("required");
			});
			$("remittance").disabled = true;
			disableDate("hrefRemitDate");
			$("provReceiptNo").disabled = true;		
			$("payorName").disabled = true;
			$("payorName").disabled = true;
			$("payorNameDiv").disabled = true;
			disableSearch("oscmPayor");
			$("orDate").disabled = true;
			$("payorName").removeClassName("required");
			$("payorNameDiv").removeClassName("required");
			$("orDate").removeClassName("required");
			$("payorParticulars").removeClassName("required");
			$("payorParticularsDiv").removeClassName("required");
			$("payorParticulars").disabled = true;
			$("payorParticularsDiv").disabled = true;
			$("gross").disable();
			$("net").disable();
			$("riCommTag").disable();
			$("intermediary").disable();
			$("payorTinNo").disabled = true;
			$("payorAddress1").disabled = true;
			$("payorAddress2").disabled = true;
			$("payorAddress3").disabled = true;
			$("particular").disabled = true;
			$("paymentMode").removeClassName("required");
			$("currRt").removeClassName("required");
			$("bank").removeClassName("required");
			$("checkClass").removeClassName("required");
			disableDate("hrefCheckDate");
			$("localCurrAmt").removeClassName("required");
			$("currency").removeClassName("required");
			disableSearch("oscmCheckCredit");
			$("grossAmt").removeClassName("required");
			$("deductionComm").removeClassName("required");
			$("vatAmount").removeClassName("required");
			$("fcGrossAmt").removeClassName("required");
			$("fcCommAmt").removeClassName("required");
			$("fcTaxAmt").removeClassName("required");
			$("fcNetAmt").removeClassName("required");
			$("particular").removeClassName("required");
			$("oscmPayor").disabled = true;
			$("bank").disabled = true;
			$("checkClass").disabled = true;
			$("checkCreditCardNo").disabled = true;
			$("checkDateCalendar").disabled = true;
			$("localCurrAmt").disabled = true;
			$("currency").disabled = true;
			$("particular").disabled = true;
			$("grossAmt").disabled = true;
			$("deductionComm").disabled = true;
			$("vatAmount").disabled = true;
			$("fcGrossAmt").disabled = true;
			$("fcCommAmt").disabled = true;
			$("fcTaxAmt").disabled = true;
			$("fcNetAmt").disabled = true;
			$("currRt").disabled = true;
    	}
	}
	//end SR5570
	
	$("credCardDiv").style.backgroundColor = $("bank").getStyle('background-color').toString();
	$("checkDateBack").style.backgroundColor = $("bank").getStyle('background-color').toString();

	checkFlags();
	checkCollectionList();
	computeCollnTotal();
	checkIfToResizeTable("collectionPaymentList", "rowItem");
	checkPrintedOrCancelled();
</script>