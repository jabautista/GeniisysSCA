<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div class="sectionDiv" style="border-top: none;" id="inwardFaculPremCollnsDiv" name="inwardFaculPremCollnsDiv">
	<jsp:include page="subPages/inwFaculPremCollnsListingTable.jsp"></jsp:include>
	<div id="inwardFaculTop" name="inwardFaculTop" style="margin: 10px;">
		<input type="hidden" id="savedItemInw" 		name="savedItemInw" 		value="" />
		<input type="hidden" id="taxAllocation" 	name="taxAllocation" 		value="${empty taxAllocation ? 'Y' :taxAllocation}" />
		<input type="hidden" id="gaccTranIdInw"  	name="gaccTranIdInw" 		value="${gaccTranId }" />
		<input type="hidden" id="b140IssCdInw"  	name="b140IssCdInw" 		value="RI" />
		<input type="hidden" id="wholdingTaxInw"  	name="wholdingTaxInw" 		value="" />
		<input type="hidden" id="orPrintTagInw"  	name="orPrintTagInw" 		value="" />
		<input type="hidden" id="cpiRecNoInw"  		name="cpiRecNoInw" 			value="" />
		<input type="hidden" id="cpiBranchCdInw"  	name="cpiBranchCdInw" 		value="" />
		<input type="hidden" id="assdNoInw"  		name="assdNoInw" 			value="" />
		<input type="hidden" id="riPolicyNoInw"  	name="riPolicyNoInw" 		value="" />
		<input type="hidden" id="defCollnAmtInw"  	name="defCollnAmtInw" 		value="" />
		<input type="hidden" id="premiumTaxInw"  	name="premiumTaxInw" 		value="" />
		
		<input type="hidden" id="variableSoaCollectionAmtInw"  	name="variableSoaCollectionAmtInw"  	value="" />
		<input type="hidden" id="variableSoaPremiumAmtInw"  	name="variableSoaPremiumAmtInw" 		value="" />
		<input type="hidden" id="variableSoaPremiumTaxInw"  	name="variableSoaPremiumTaxInw" 		value="" />
		<input type="hidden" id="variableSoaWholdingTaxInw"  	name="variableSoaWholdingTaxInw" 		value="" />
		<input type="hidden" id="variableSoaCommAmtInw"  		name="variableSoaCommAmtInw" 			value="" />
		<input type="hidden" id="variableSoaTaxAmountInw"  		name="variableSoaTaxAmountInw" 			value="" />
		<input type="hidden" id="variableSoaCommVatInw"  		name="variableSoaCommVatInw" 			value="" />
		<input type="hidden" id="defForgnCurAmtInw"  			name="defForgnCurAmtInw" 					value="" />
		
		<table align="center" border="0" style="margin:40px; margin-top:10px; margin-bottom:10px;">
			<tr>
				<td class="rightAligned" style="width: 20%;">Transaction Type</td>
				<td class="leftAligned" style="width: 32%;">
					<select id="transactionTypeInw" name="transactionTypeInw" style="width: 198px;" class="required">
						<option value=""></option>
						<c:forEach var="transactionType" items="${transactionTypeList }" varStatus="ctr">
							<option value="${transactionType.rvLowValue }" typeDesc="${transactionType.rvMeaning }">${transactionType.rvLowValue } - ${transactionType.rvMeaning }</option>
						</c:forEach>
					</select>
					<input type="text" style="width: 190px;" id="transactionTypeInwReadOnly" name="transactionTypeInwReadOnly" class="required" value="" readonly="readonly" style="display:none;"/>
				</td>
				<td class="leftAligned" width="48%" style="font-size: 11px;">Assured Name</td>
			</tr>
			<tr>
				<td class="rightAligned">Cedant</td>
				<td class="leftAligned">
					<select id="a180RiCdInw" name="a180RiCdInw" style="width: 198px;" class="required">
						<option value=""></option>
					</select>
					<select id="a180RiCd2Inw" name="a180RiCd2Inw" style="width:198px;" class="required">
						<option value=""></option>
						<c:forEach var="reinsurerList2" items="${reinsurerList2 }" varStatus="ctr">
							<option value="${reinsurerList2.riCd }">${reinsurerList2.riName }</option>
						</c:forEach>
					</select>
					<input type="text" style="width: 190px;" id="cedantInwReadOnly" name="cedantInwReadOnly" class="required" value="" readonly="readonly" style="display:none;"/>
				</td>
				<td class="leftAligned"><input type="text" style="width:300px; margin-right:70px;" id="assuredNameInw" name="assuredNameInw" value="" readonly="readonly"/></td>
			</tr>
			<tr>
				<td class="rightAligned">Invoice No.</td>
				<td class="leftAligned">
					<div style="width: 196px;" class="required withIconDiv">
						<input type="text" style="width: 170px;" id="b140PremSeqNoInw" name="b140PremSeqNoInw" class="integerNoNegativeUnformattedNoComma required withIcon" value="" maxlength="8" errorMsg="Entered Invoice No. is invalid. Valid value is from 00000001 to 99999999."/>
						<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="invoiceInwDate" name="invoiceInwDate" alt="Go" />
					</div>
				</td>
				<td class="leftAligned" style="font-size: 11px;";>Policy No.</td>
			</tr>
			<tr>
				<td class="rightAligned">Installment No.</td>
				<td class="leftAligned">
					<div style="width: 196px;" class="required withIconDiv">
						<input style="width:170px;" type="text" id="instNoInw" name="instNoInw" class="integerNoNegativeUnformattedNoComma required withIcon" value="" maxlength="2" errorMsg="Entered Installment No. is invalid. Valid value is from 1 to 99." />
						<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="instNoInwDate" name="instNoInwDate" alt="Go" />
					</div>
				</td>
				<td class="leftAligned">
					<input type="text" style="width: 300px; margin-right: 70px;" id="policyNoInw" name="policyNoInw" value="" readonly="readonly" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Collection Amount</td>
				<td class="leftAligned"><input type="text" style="width: 190px;" id="collectionAmtInw" name="collectionAmtInw" class="required money" maxlength="14" value=""/></td>
				<td class="leftAligned" style="font-size: 11px;">Particulars</td>
			</tr>
			<tr>
				<td colspan="2" style="margin:auto;" align="center">
					<input type="button" style="width: 80px;" id="btnAddInw" 	class="button noChangeTagAttr" value="Add" />
					<input type="button" style="width: 80px;" id="btnDeleteInw" class="button noChangeTagAttr" value="Delete" />
				</td>
				<td class="leftAligned" width="50%"><input type="text" style="width: 300px; margin-right: 70px;" id="particularsInw" name="particularsInw" maxlength="500" value=""/></td>
			</tr>
			<tr>
				<td colspan="2"></td>
				<td colspan="2">
					<input type="button" style="width: 150px;" id="btnCurrencyInfoInw"  class="button noChangeTagAttr" value="Currency Information" />
					<input type="button" style="width: 80px;"  id="btnBreakDownInw" 	 class="button noChangeTagAttr" value="Breakdown" />
				</td>
			</tr>
		</table>
	</div>
	<div id="currencyInwDiv" style="display: none;">
		<table border="0" align="center" style="margin:10px auto;">
			<tr>
				<td class="rightAligned" style="width: 123px;">Currency Code</td>
				<td class="leftAligned"  ><input type="text" style="width: 50px; text-align: left" id="currencyCdInw" name="currencyCdInw" value="" readonly="readonly"/></td>
				<td class="rightAligned" style="width: 180px;">Currency Rate</td>
				<td class="leftAligned"  ><input type="text" style="width: 100px; text-align: right" class="moneyRate" id="convertRateInw" name="convertRateInw" value="" readonly="readonly"/></td>
			</tr>
			<tr>
				<td class="rightAligned" >Currency Description</td>
				<td class="leftAligned"  ><input type="text" style="width: 170px; text-align: left" id="currencyDescInw" name="currencyDescInw" value="" readonly="readonly"/></td>
				<td class="rightAligned" >Foreign Currency Amount</td>
				<td class="leftAligned"  ><input type="text" style="width: 170px; text-align: right" class="money required" id="foreignCurrAmtInw" name="foreignCurrAmtInw" value="" maxlength="14"/></td>
			</tr>
			<tr>
				<td width="100%" style="text-align: center;" colspan="4">
					<input type="button" style="width: 80px;" id="btnHideCurrInwDiv" 	   class="button noChangeTagAttr" value="Return"/>
				</td>
			</tr>
		</table>
	</div>	
	<div id="breakdownInwDiv" style="display: none;">
		<table border="0" align="center" style="margin:10px auto;">
			<tr>
				<td class="rightAligned" style="width: 123px;">Premium Amount</td>
				<td class="leftAligned"  ><input type="text" style="width:170px;" id="premiumAmtInw" name="premiumAmtInw" value="" class="money" readonly="readonly"/></td>
				<td class="rightAligned" style="width: 180px;">Tax Amount</td>
				<td class="leftAligned"  ><input type="text" style="width:170px;" id="taxAmountInw" name="taxAmountInw" value="" class="money" readonly="readonly"/></td>
			</tr>
			<tr>
				<td class="rightAligned" >Commission Amount</td>
				<td class="leftAligned"  ><input type="text" style="width:170px;" id="commAmtInw" name="commAmtInw" value="" class="money" readonly="readonly"/></td>
				<td class="rightAligned" >Commission VAT Amount</td>
				<td class="leftAligned"  ><input type="text" style="width:170px;" id="commVatInw" name="commVatInw" value="" class="money" readonly="readonly"/></td>
			</tr>
			<tr>
				<td width="100%" style="text-align: center;" colspan="4">
					<input type="button" style="width: 80px;" id="btnHideBreakdownInwDiv" 	   class="button noChangeTagAttr" value="Return"/>
				</td>
			</tr>
		</table>
	</div>
</div>
<div class="buttonsDiv" style="float:left; width: 100%;">			
	<input type="button" style="width: 80px;" id="btnCancelInwFacul" name="btnCancelInwFacul"	class="button" value="Cancel" />
	<input type="button" style="width: 80px;" id="btnSaveInwFacul" 	 name="btnSaveInwFacul"		class="button" value="Save" />
</div> 
<script type="text/javaScript">
	setModuleId("GIACS008");
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	initializeAccordion();
	hideNotice("");
	var a180RiCdInwObjLOV = JSON.parse('${reinsurerList}'.replace(/\\/g, '\\\\'));
	objAC.hidObjAC008 = {};
	
	//when transaction type click
	var transactionTypeInw;
	$("transactionTypeInw").observe("click",function(){
		transactionTypeInw = $F("transactionTypeInw");
	});	
	$("transactionTypeInw").observe("blur",function(){
		enableOrDisbleItem();
	});

	function clear(){
		$("a180RiCdInw").clear();
		$("a180RiCd2Inw").clear();
		$("b140PremSeqNoInw").clear();
		$("instNoInw").clear();
		$("collectionAmtInw").clear();
		$("assuredNameInw").clear();
		$("policyNoInw").clear();
		//$("particularsInw").clear();
	}
	
	//when transaction type change
	$("transactionTypeInw").observe("change",function(){	
		if (transactionTypeInw  == "2" || transactionTypeInw == "4"){
			if ($F("transactionTypeInw") == "2" || $F("transactionTypeInw") == "4"){
				null;
			}else{
				clear();
			}		
		}else{
			if ($F("transactionTypeInw") == "2" || $F("transactionTypeInw") == "4"){
				clear();
			}	
		}
		
		if ($F("transactionTypeInw") == "2" || $F("transactionTypeInw") == "4"){
			$("a180RiCdInw").show();
			$("a180RiCd2Inw").hide();
		}else{
			$("a180RiCdInw").hide();
			$("a180RiCd2Inw").show();
		}
		getReinsurerLOV("");		
		enableOrDisbleItem();
	});

	//cedant for transaction type in (2,4)
	$("a180RiCdInw").observe("change",function(){
		$("b140PremSeqNoInw").clear();
		$("instNoInw").clear();
		$("collectionAmtInw").clear();
		$("assuredNameInw").clear();
		$("policyNoInw").clear();
		//$("particularsInw").clear();	
		enableOrDisbleItem();	
	});
	
	//cedant for transaction type in (1,3)
	$("a180RiCd2Inw").observe("change",function(){
		$("b140PremSeqNoInw").clear();
		$("instNoInw").clear();
		$("collectionAmtInw").clear();
		$("assuredNameInw").clear();
		$("policyNoInw").clear();
		//$("particularsInw").clear();		
		enableOrDisbleItem();	
	});

	//invoice no
	initPreTextOnField("b140PremSeqNoInw");
	$("b140PremSeqNoInw").observe("blur",function(){
		if ($F("savedItemInw") != "Y"){
			if ($F("b140PremSeqNoInw") != "" && checkIfValueChanged("b140PremSeqNoInw")){
				if (formatNumberDigits($F("b140PremSeqNoInw"),8) == "00000000") {
					$("b140PremSeqNoInw").clear();
					customShowMessageBox("Entered Invoice No. is invalid. Valid value is from 00000001 to 99999999.", imgMessage.ERROR, "b140PremSeqNoInw");
					return;
				}	
				var vMsgAlert = validateInvoiceInwFacul($F("b140PremSeqNoInw"));
				hideNotice();
				if (vMsgAlert == ""){
					$("b140PremSeqNoInw").value = $F("b140PremSeqNoInw") == "" ? "" :formatNumberDigits($F("b140PremSeqNoInw"),8);
					$("instNoInw").enable();
					$("instNoInw").focus();
				}else{
					$("b140PremSeqNoInw").clear();
					customShowMessageBox(vMsgAlert, imgMessage.ERROR, "b140PremSeqNoInw");
					return false;
				}	
			}
		}
		enableOrDisbleItem();
	});

	//search icon invoice no
	$("invoiceInwDate").observe("click",function(){
		if ($F("savedItemInw") != "Y"){
			if ($F("transactionTypeInw") == ""){
				customShowMessageBox("Please select a transaction type first.", imgMessage.ERROR, "transactionTypeInw");
				return false;
			}else if ($F("b140IssCdInw") == ""){
				customShowMessageBox("Issue source is null.", imgMessage.ERROR, "b140IssCdInw");
				return false;	
			}else if ($F("transactionTypeInw") == "2" || $F("transactionTypeInw") == "4"){
				if ($F("a180RiCdInw") == ""){
					customShowMessageBox("Please select a cedant first.", imgMessage.ERROR, "a180RiCdInw");
					return false;
				}else{
					openSearchInvoiceInward();
				}	
			}else if ($F("transactionTypeInw") == "1" || $F("transactionTypeInw") == "3"){
				if ($F("a180RiCd2Inw") == ""){
					customShowMessageBox("Please select a cedant first.", imgMessage.ERROR, "a180RiCd2Inw");
					return false;
				}else{
					openSearchInvoiceInward();
				}
			}		
		}		
	});

	//call modal search invoice
	function openSearchInvoiceInward(){
		Modalbox.show(contextPath+"/GIACInwFaculPremCollnsController?action=openSearchInvoiceModal&ajaxModal=1",  
				  {title: "Search Invoice", 
				  width: 915,
				  height: 505,
				  asynchronous: false});
	}	

	//installment no
	$("instNoInw").observe("blur",function(){
		if ($F("savedItemInw") != "Y"){
			if ($F("instNoInw") != "" && $F("b140PremSeqNoInw") != ""){
				var vMsgAlert = validateInstNoInwFacul($F("instNoInw"),"Y");
				if (vMsgAlert == "" || vMsgAlert == null || vMsgAlert == "null"){
					null;
				}else{
					$("instNoInw").clear();
					customShowMessageBox(vMsgAlert, imgMessage.ERROR, "instNoInw");
					return false;
				}	
			}
		}
		enableOrDisbleItem();
	});

	//search icon installment no
	$("instNoInwDate").observe("click",function(){
		if ($F("savedItemInw") != "Y"){
			if ($F("transactionTypeInw") == ""){
				customShowMessageBox("Please select a transaction type first.", imgMessage.ERROR, "transactionTypeInw");
				return false;
			}else if ($F("b140IssCdInw") == ""){
				customShowMessageBox("Issue source is null.", imgMessage.ERROR, "b140IssCdInw");
				return false;	
			}else if ($F("transactionTypeInw") == "2" || $F("transactionTypeInw") == "4"){
				if ($F("a180RiCdInw") == ""){
					customShowMessageBox("Please select a cedant first.", imgMessage.ERROR, "a180RiCdInw");
					return false;
				}else if ($F("b140PremSeqNoInw") == ""){
					customShowMessageBox("Please select an invoice first.", imgMessage.ERROR, "b140PremSeqNoInw");
					return false;	
				}else{
					openSearchInstNoInward();
				}	
			}else if ($F("transactionTypeInw") == "1" || $F("transactionTypeInw") == "3"){
				if ($F("a180RiCd2Inw") == ""){
					customShowMessageBox("Please select a cedant first.", imgMessage.ERROR, "a180RiCd2Inw");
					return false;
				}else if ($F("b140PremSeqNoInw") == ""){
					customShowMessageBox("Please select an invoice first.", imgMessage.ERROR, "b140PremSeqNoInw");
					return false;
				}else{
					openSearchInstNoInward();
				}
			}		
		}			
	});	

	//call modal search installment no
	function openSearchInstNoInward(){
		Modalbox.show(contextPath+"/GIACInwFaculPremCollnsController?action=openSearchInstNoModal&ajaxModal=1",  
				  {title: "Search Installment No.", 
				  width: 400,
				  asynchronous: false});
	};	
	
	//collection amount
	var varCollecntionAmt = 0;
	$("collectionAmtInw").observe("focus", function () {
		varCollecntionAmt = formatCurrency($F("collectionAmtInw"));
	});	
	$("collectionAmtInw").observe("blur", function () {
		if ($F("instNoInw").blank() || $F("savedItemInw") == "Y"){
			return false;
		}	
		if (unformatCurrency("collectionAmtInw") == 0 || $F("collectionAmtInw") == ""){
			customShowMessageBox("Invalid value. Amount cannot be null or equal to zero(0).", imgMessage.ERROR, "collectionAmtInw");
			$("collectionAmtInw").value = varCollecntionAmt;
			return false;
		}else if (unformatCurrency("collectionAmtInw") > 9999999999.99 || unformatCurrency("collectionAmtInw") < -9999999999.99 || isNaN(parseFloat($F("collectionAmtInw").replace(/,/g, "")))){
			customShowMessageBox("Entered Collection Amount is invalid. Valid value is from 9,999,999,999.99 to -9,999,999,999.99.", imgMessage.ERROR, "collectionAmtInw");
			$("collectionAmtInw").value = varCollecntionAmt;
			return false;
		}else if ($F("transactionTypeInw") == "1" || $F("transactionTypeInw") == "4"){
			if (unformatCurrency("collectionAmtInw") < 0){
				customShowMessageBox("Please enter a positive amount for transaction type "+getListTextValue("transactionTypeInw")+".", imgMessage.ERROR, "collectionAmtInw");
				$("collectionAmtInw").value = varCollecntionAmt;
				return false;
			}	
		}else if ($F("transactionTypeInw") == "2" || $F("transactionTypeInw") == "3"){
			if (unformatCurrency("collectionAmtInw") > 0){
				customShowMessageBox("Please enter a negative amount for transaction type "+getListTextValue("transactionTypeInw")+".", imgMessage.ERROR, "collectionAmtInw");
				$("collectionAmtInw").value = varCollecntionAmt;
				return false;
			}
		}	

		/* check for collection amount greater than default value. */
		if (Math.abs(unformatCurrency("collectionAmtInw")) > Math.abs(unformatCurrency("defCollnAmtInw"))){
			$("collectionAmtInw").value = varCollecntionAmt; 
			if ($F("transactionTypeInw") == "1" || $F("transactionTypeInw") == "4"){
				customShowMessageBox("Collection amount cannot be more than "+formatCurrency($F("defCollnAmtInw"))+".",imgMessage.ERROR, "collectionAmtInw");
			}else if ($F("transactionTypeInw") == "2" || $F("transactionTypeInw") == "3"){
				customShowMessageBox("Collection amount cannot be less than "+formatCurrency($F("defCollnAmtInw"))+".", imgMessage.ERROR, "collectionAmtInw");
			}
		}
		
		var collectionAmt = unformatCurrency("collectionAmtInw");
		var convertRate = unformatCurrency("convertRateInw"); 
		collectionAmt = collectionAmt == "" ? 0 :collectionAmt;
		convertRate = convertRate == "" ? 1 :convertRate;
		$("foreignCurrAmtInw").value = formatCurrency(Math.round((collectionAmt/convertRate)*100)/100);
		
		if ($F("taxAllocation") == "Y"){
			var vCollnPct = 0;
			vCollnPct = collectionAmt/unformatCurrency("variableSoaCollectionAmtInw");
			$("premiumAmtInw").value = formatCurrency(Math.round((unformatCurrency("variableSoaPremiumAmtInw") * vCollnPct)*100)/100);
			$("taxAmountInw").value  = formatCurrency(Math.round((unformatCurrency("variableSoaTaxAmountInw") * vCollnPct)*100)/100);
			$("commAmtInw").value    = formatCurrency(Math.round((unformatCurrency("variableSoaCommAmtInw") * vCollnPct)*100)/100);
			$("commVatInw").value    = formatCurrency(Math.round((unformatCurrency("variableSoaCommVatInw") * vCollnPct)*100)/100);	
		}else if ($F("taxAllocation") == "N"){
			if (unformatCurrency($F("collectionAmtInw")) == unformatCurrency("variableSoaCollectionAmtInw")){
				$("premiumAmtInw").value = formatCurrency(unformatCurrency("variableSoaPremiumAmtInw"));
				$("taxAmountInw").value  = formatCurrency(unformatCurrency("variableSoaTaxAmountInw"));
				$("commAmtInw").value    = formatCurrency(unformatCurrency("variableSoaCommAmtInw"));
				$("commVatInw").value    = formatCurrency(unformatCurrency("variableSoaCommVatInw"));	
			}else if (Math.abs(unformatCurrency("collectionAmtInw")) <= Math.abs(unformatCurrency("variableSoaTaxAmountInw"))){
				$("premiumAmtInw").value = "0.00";
				$("taxAmountInw").value  = formatCurrency(unformatCurrency("collectionAmtInw"));
				$("commAmtInw").value    = "0.00";
				$("commVatInw").value    = "0.00";
			}else{
				var vCommRt = 0;
				var vCommVatRt = 0;
				if (unformatCurrency("variableSoaPremiumAmtInw") != 0){
					vCommRt	= unformatCurrency("variableSoaCommAmtInw")/unformatCurrency("variableSoaPremiumAmtInw");
					if (vCommRt != 0){
						vCommVatRt = unformatCurrency("variableSoaCommVatInw")/unformatCurrency("variableSoaCommAmtInw");
					}
				}	
				$("taxAmountInw").value  = formatCurrency(unformatCurrency("variableSoaTaxAmountInw"));
				$("premiumAmtInw").value = formatCurrency(Math.round(((unformatCurrency("collectionAmtInw") - unformatCurrency("taxAmountInw")) / (1-vCommRt-(vCommRt*vCommVatRt)))*100)/100);
				$("commAmtInw").value	 = formatCurrency(Math.round((unformatCurrency("premiumAmtInw") * vCommRt)*100)/100);					          
				$("commVatInw").value	 = formatCurrency(Math.round((unformatCurrency("premiumAmtInw") * vCommRt * vCommVatRt)*100)/100);
			}			
		}
		if ((unformatCurrency("premiumAmtInw") + unformatCurrency("taxAmountInw") - unformatCurrency("commAmtInw") - unformatCurrency("commVatInw")) != unformatCurrency("collectionAmtInw")){
			//If there is a difference of .01 then add or subtract it to the premium_amt
			if (roundNumber(Math.abs(unformatCurrency("collectionAmtInw") - unformatCurrency("premiumAmtInw") - unformatCurrency("taxAmountInw") + unformatCurrency("commAmtInw") + unformatCurrency("commVatInw")),2) == 0.01){
				$("premiumAmtInw").value = formatCurrency(unformatCurrency("premiumAmtInw") + (unformatCurrency("collectionAmtInw") - unformatCurrency("premiumAmtInw") - unformatCurrency("taxAmountInw") + unformatCurrency("commAmtInw") + unformatCurrency("commVatInw")));
			}
		}
		if ($F("collectionAmtInw") != "" && $F("savedItemInw") != "Y"){
			enableButton("btnAddInw");
			if (objACGlobal.tranFlagState != 'O'){
				disableButton("btnAddInw");
			}
		}else{
			disableButton("btnAddInw");
		}		
	});

	//foreign currency amount
	var varForeignCurrAmt = 0;
	$("foreignCurrAmtInw").observe("focus", function () {
		varForeignCurrAmt = formatCurrency($F("foreignCurrAmtInw"));
	});	
	$("foreignCurrAmtInw").observe("blur", function () {
		if ($F("instNoInw").blank() || $F("savedItemInw") == "Y"){
			return false;
		}
		if (unformatCurrency("foreignCurrAmtInw") == 0 || $F("foreignCurrAmtInw") == ""){
			customShowMessageBox("Invalid value. Amount cannot be null or equal to zero(0).", imgMessage.ERROR, "foreignCurrAmtInw");
			$("foreignCurrAmtInw").value = varForeignCurrAmt;
			return false;
		}else if (unformatCurrency("foreignCurrAmtInw") > 9999999999.99 || unformatCurrency("foreignCurrAmtInw") < -9999999999.99 || isNaN(parseFloat($F("foreignCurrAmtInw").replace(/,/g, "")))){
			customShowMessageBox("Entered Foreign Currency Amount is invalid. Valid value is from 9,999,999,999.99 to -9,999,999,999.99.", imgMessage.ERROR, "foreignCurrAmtInw");
			$("foreignCurrAmtInw").value = varForeignCurrAmt;
			return false;
		}else if ($F("transactionTypeInw") == "1" || $F("transactionTypeInw") == "4"){
			if (unformatCurrency("foreignCurrAmtInw") < 0){
				customShowMessageBox("Please enter a positive amount for transaction type "+getListTextValue("transactionTypeInw")+".", imgMessage.ERROR, "foreignCurrAmtInw");
				$("foreignCurrAmtInw").value = varForeignCurrAmt;
				return false;
			}	
		}else if ($F("transactionTypeInw") == "2" || $F("transactionTypeInw") == "3"){
			if (unformatCurrency("foreignCurrAmtInw") > 0){
				customShowMessageBox("Please enter a negative amount for transaction type "+getListTextValue("transactionTypeInw")+".", imgMessage.ERROR, "foreignCurrAmtInw");
				$("foreignCurrAmtInw").value = varForeignCurrAmt;
				return false;
			}
		}	

		/* check for collection amount greater than default value. */
		if (Math.abs(unformatCurrency("foreignCurrAmtInw")) > Math.abs(unformatCurrency("defForgnCurAmtInw"))){
			$("foreignCurrAmtInw").value = varForeignCurrAmt; 
			if ($F("transactionTypeInw") == "1" || $F("transactionTypeInw") == "4"){
				customShowMessageBox("Foreign currency amount cannot be more than "+formatCurrency($F("defForgnCurAmtInw"))+"." , imgMessage.ERROR, "foreignCurrAmtInw");
			}else if ($F("transactionTypeInw") == "2" || $F("transactionTypeInw") == "3"){
				customShowMessageBox("Foreign currency amount cannot be less than "+formatCurrency($F("defForgnCurAmtInw"))+"." , imgMessage.ERROR, "foreignCurrAmtInw");
			}
		}
		
		var foreignCurrAmt = unformatCurrency("foreignCurrAmtInw");
		var convertRate = unformatCurrency("convertRateInw"); 
		foreignCurrAmt = foreignCurrAmt == "" ? 0 :foreignCurrAmt;
		convertRate = convertRate == "" ? 1 :convertRate;
		$("collectionAmtInw").value = formatCurrency(Math.round((foreignCurrAmt*convertRate)*100)/100);

		if ($F("taxAllocation") == "Y"){
			var vCollnPct = 0;
			vCollnPct = unformatCurrency("collectionAmtInw")/unformatCurrency("variableSoaCollectionAmtInw");
			$("premiumAmtInw").value = formatCurrency(Math.round((unformatCurrency("variableSoaPremiumAmtInw") * vCollnPct)*100)/100);
			$("taxAmountInw").value  = formatCurrency(Math.round((unformatCurrency("variableSoaTaxAmountInw") * vCollnPct)*100)/100);
			$("commAmtInw").value    = formatCurrency(Math.round((unformatCurrency("variableSoaCommAmtInw") * vCollnPct)*100)/100);
			$("commVatInw").value    = formatCurrency(Math.round((unformatCurrency("variableSoaCommVatInw") * vCollnPct)*100)/100);	
		}else if ($F("taxAllocation") == "N"){
			if (unformatCurrency($F("collectionAmtInw")) == unformatCurrency("variableSoaCollectionAmtInw")){
				$("premiumAmtInw").value = formatCurrency(unformatCurrency("variableSoaPremiumAmtInw"));
				$("taxAmountInw").value  = formatCurrency(unformatCurrency("variableSoaTaxAmountInw"));
				$("commAmtInw").value    = formatCurrency(unformatCurrency("variableSoaCommAmtInw"));
				$("commVatInw").value    = formatCurrency(unformatCurrency("variableSoaCommVatInw"));	
			}else if (Math.abs(unformatCurrency("collectionAmtInw")) <= Math.abs(unformatCurrency("variableSoaTaxAmountInw"))){
				$("premiumAmtInw").value = "0.00";
				$("taxAmountInw").value  = formatCurrency(unformatCurrency("collectionAmtInw"));
				$("commAmtInw").value    = "0.00";
				$("commVatInw").value    = "0.00";
			}else{
				var vCommRt = 0;
				var vCommVatRt = 0;
				if (unformatCurrency("variableSoaPremiumAmtInw") != 0){
					vCommRt	= unformatCurrency("variableSoaCommAmtInw")/unformatCurrency("variableSoaPremiumAmtInw");
					if (vCommRt != 0){
						vCommVatRt = unformatCurrency("variableSoaCommVatInw")/unformatCurrency("variableSoaCommAmtInw");
					}
				}	
				$("taxAmountInw").value  = formatCurrency(unformatCurrency("variableSoaTaxAmountInw"));
				$("premiumAmtInw").value = formatCurrency(Math.round(((unformatCurrency("collectionAmtInw") - unformatCurrency("taxAmountInw")) / (1-vCommRt-(vCommRt*vCommVatRt)))*100)/100);
				$("commAmtInw").value	 = formatCurrency(Math.round((unformatCurrency("premiumAmtInw") * vCommRt)*100)/100);					          
				$("commVatInw").value	 = formatCurrency(Math.round((unformatCurrency("premiumAmtInw") * vCommRt * vCommVatRt)*100)/100);
			}			
		}
		if ((unformatCurrency("premiumAmtInw") + unformatCurrency("taxAmountInw") - unformatCurrency("commAmtInw") - unformatCurrency("commVatInw")) != unformatCurrency("collectionAmtInw")){
			//If there is a difference of .01 then add or subtract it to the premium_amt
			if (Math.abs(unformatCurrency("collectionAmtInw") - unformatCurrency("premiumAmtInw") - unformatCurrency("taxAmountInw") + unformatCurrency("commAmtInw") + unformatCurrency("commVatInw")) == 0.01){
				$("premiumAmtInw").value = formatCurrency(unformatCurrency("premiumAmtInw") + (unformatCurrency("collectionAmtInw") - unformatCurrency("premiumAmtInw") - unformatCurrency("taxAmountInw") + unformatCurrency("commAmtInw") + unformatCurrency("commVatInw")));
			}
		}
		if ($F("collectionAmtInw") != "" && $F("savedItemInw") != "Y"){
			enableButton("btnAddInw");
			if (objACGlobal.tranFlagState != 'O'){
				disableButton("btnAddInw");
			}
		}else{
			disableButton("btnAddInw");
		}		
	});

	//add record observe
	$("btnAddInw").observe("click", function() {
		addInwardFacul();
	});
	
	//onload observe virtual table
	$$("div[name='inwFacul']").each(
			function (row)	{
				loadRowMouseOverMouseOutObserver(row);
				row.observe("click", function ()	{
					row.toggleClassName("selectedRow");
					if (row.hasClassName("selectedRow"))	{
						$$("div[name='inwFacul']").each(function (li)	{
							if (row.getAttribute("id") != li.getAttribute("id"))	{
								li.removeClassName("selectedRow");
							}	
						});
						clearForm();
						getDefaults();
						$("transactionTypeInw").value = row.down("input",1).value;	
						$("transactionTypeInwReadOnly").value = getListTextValue("transactionTypeInw"); //for readonly
						getReinsurerLOV(row.down("input",2).value);
						$("b140IssCdInw").value =  row.down("input",3).value;	
						$("b140PremSeqNoInw").value = formatNumberDigits(row.down("input",4).value,8);
						$("instNoInw").value = row.down("input",5).value;
						$("premiumAmtInw").value = formatCurrency(row.down("input",6).value);
						$("commAmtInw").value = formatCurrency(row.down("input",7).value);
						$("wholdingTaxInw").value = row.down("input",8).value;
						$("particularsInw").value = row.down("input",9).value;
						$("currencyCdInw").value = row.down("input",10).value;
						$("convertRateInw").value = formatToNineDecimal(row.down("input",11).value);
						$("foreignCurrAmtInw").value = formatCurrency(row.down("input",12).value);
						$("collectionAmtInw").value = row.down("input",13).value == "" ? "" :formatCurrency(row.down("input",13).value);
						$("orPrintTagInw").value = row.down("input",14).value;
						$("cpiRecNoInw").value = row.down("input",17).value;	
						$("cpiBranchCdInw").value = row.down("input",18).value;				
						$("taxAmountInw").value = formatCurrency(row.down("input",19).value);
						$("commVatInw").value = formatCurrency(row.down("input",20).value);				
						$("assdNoInw").value = row.down("input",23).value;				
						$("assuredNameInw").value = row.down("input",24).value;
						$("riPolicyNoInw").value = row.down("input",25).value;
						$("policyNoInw").value = row.down("input",26).value;
						$("currencyDescInw").value = row.down("input",27).value; 
						$("defCollnAmtInw").value = row.down("input",28).value; 
						$("premiumTaxInw").value = row.down("input",29).value; 
						$("savedItemInw").value = row.down("input",30).value; 
						$("variableSoaCollectionAmtInw").value = row.down("input",31).value; 
						$("variableSoaPremiumAmtInw").value = row.down("input",32).value; 
						$("variableSoaPremiumTaxInw").value = row.down("input",33).value; 
						$("variableSoaWholdingTaxInw").value = row.down("input",34).value; 
						$("variableSoaCommAmtInw").value = row.down("input",35).value; 
						$("variableSoaTaxAmountInw").value = row.down("input",36).value; 
						$("variableSoaCommVatInw").value = row.down("input",37).value;
						$("defForgnCurAmtInw").value = row.down("input",38).value; 
					} else {
						clearForm();
					}
					enableOrDisbleItem();
				}); 
			}	
	);	

	//add record function
	function addInwardFacul() {	
		try	{
			if (objAC.hidObjAC008.hidUpdateable == "N"){
				return false;
			}
			var exists = false;
			if ($F("instNoInw") != "" && $F("b140PremSeqNoInw") != ""){
				var vMsgAlert = validateInstNoInwFacul($F("instNoInw"),"N");
				if (vMsgAlert == "" || vMsgAlert == null || vMsgAlert == "null"){
					null;
				}else{
					$("instNoInw").clear();
					customShowMessageBox(vMsgAlert, imgMessage.ERROR, "instNoInw");
					exists = true;
					return false;
				}	
			}
			
			var inwGaccTranId = $F("gaccTranIdInw");
			var inwTransactionType = $F("transactionTypeInw");
			if ($F("transactionTypeInw") == "2" || $F("transactionTypeInw") == "4"){
				var inwA180RiCd = $F("a180RiCdInw");
			}else{
				var inwA180RiCd = $F("a180RiCd2Inw");
			}	
			var inwB140IssCd = $F("b140IssCdInw");
			var inwB140PremSeqNo = $F("b140PremSeqNoInw")*1; 
			var inwInstNo = $F("instNoInw");
			var inwPremiumAmt = $F("premiumAmtInw");
			var inwCommAmt = $F("commAmtInw");
			var inwWholdingTax = $F("wholdingTaxInw");
			var inwparticulars = changeSingleAndDoubleQuotes2($F("particularsInw"));
			var inwCurrencyCd = $F("currencyCdInw");
			var inwConvertRate = $F("convertRateInw");
			var inwForeignCurrAmt = $F("foreignCurrAmtInw");
			var inwCollectionAmt = $F("collectionAmtInw"); 
			var inwOrPrintTag = ($F("orPrintTagInw") == "" ? "N" :$F("orPrintTagInw"));
			var inwUserId = "";
			var inwLastUpdate = "";
			var inwCpiRecNo = $F("cpiRecNoInw");
			var inwCpiBranchCd = $F("cpiBranchCdInw");
			var inwTaxAmount = $F("taxAmountInw");
			var inwCommVat = $F("commVatInw");
			//non-base table
			var inwTransactionTypeDesc = getListTextValue("transactionTypeInw");
			if ($F("transactionTypeInw") == "2" || $F("transactionTypeInw") == "4"){
				var inwRiName = changeSingleAndDoubleQuotes(getListTextValue("a180RiCdInw"));
			}else{
				var inwRiName = getListTextValue("a180RiCd2Inw");
			}
			var inwAssdNo = $F("assdNoInw");
			var inwAssdName = changeSingleAndDoubleQuotes2($F("assuredNameInw"));
			var inwRiPolicyNo = $F("riPolicyNoInw");
			var inwDrvPolicyNo = $F("policyNoInw");
			var inwCurrencyDesc = $F("currencyDescInw");
			var inwDefCollAmt = $F("defCollnAmtInw");
			var inwPremiumTax = $F("premiumTaxInw");
			var inwSavedItem = "N";
			var inwSoaCollectionAmt = $F("variableSoaCollectionAmtInw");
			var inwSoaPremiumAmt = $F("variableSoaPremiumAmtInw");
			var inwSoaPremiumTax = $F("variableSoaPremiumTaxInw");
			var inwSoaWholdingTax = $F("variableSoaWholdingTaxInw");
			var inwSoaCommAmt = $F("variableSoaCommAmtInw");
			var inwSoaTaxAmount = $F("variableSoaTaxAmountInw");
			var inwSoaCommVat = $F("variableSoaCommVatInw");
			var inwDefForgnCurAmt = $F("defForgnCurAmtInw");
				
			if (inwTransactionType == "") {
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR , "transactionTypeInw");
				exists = true;
			}else if (inwGaccTranId == "") {
				customShowMessageBox("Transaction Id is null.", imgMessage.ERROR , "transactionTypeInw");
				exists = true;
			}else if (inwA180RiCd == "") {
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "a180RiCdInw");
				exists = true;
			}else if (inwB140PremSeqNo == "") {
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "b140PremSeqNoInw");
				exists = true;
			}else if (inwInstNo == "") {
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "instNoInw");
				exists = true;
			}else if (inwCollectionAmt == "") {
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "collectionAmtInw");
				exists = true;
			}else if (inwCollectionAmt == "0.00") {
				customShowMessageBox("Collection Amount cannot be equal to zero(0).", imgMessage.ERROR, "collectionAmtInw");
				exists = true;
			}
			
			$$("div[name='inwFacul']").each( function(a)	{
				if (a.getAttribute("transactionType") == inwTransactionType 
						&& a.getAttribute("a180RiCd") == inwA180RiCd 
						&& a.getAttribute("b140IssCd") == inwB140IssCd 
						&& a.getAttribute("b140PremSeqNo") == inwB140PremSeqNo 
						&& a.getAttribute("instNo") == inwInstNo 
						&& $F("btnAddInw") != "Update")	{
					exists = true;
					showMessageBox("Record already exists!", imgMessage.ERROR);
					clearForm();
					enableOrDisbleItem();
					deselectRows("inwFaculTable","inwFacul");
				}	
			});

			if (!exists)	{
				var content = '<input type="hidden" id="inwFaculGaccTranId" 		name="inwFaculGaccTranId" 	   		value="'+inwGaccTranId+'" />'+
					 	  	  '<input type="hidden" id="inwFaculTransactionType" 	name="inwFaculTransactionType" 		value="'+inwTransactionType+'" />'+
							  '<input type="hidden" id="inwFaculA180RiCd" 			name="inwFaculA180RiCd" 			value="'+inwA180RiCd+'" />'+
							  '<input type="hidden" id="inwFaculB140IssCd" 			name="inwFaculB140IssCd"			value="'+inwB140IssCd+'" />'+
							  '<input type="hidden" id="inwFaculB140PremSeqNo" 		name="inwFaculB140PremSeqNo" 		value="'+inwB140PremSeqNo+'" />'+
							  '<input type="hidden" id="inwFaculInstNo" 			name="inwFaculInstNo" 				value="'+inwInstNo+'" />'+
							  '<input type="hidden" id="inwFaculPremiumAmt" 		name="inwFaculPremiumAmt"			value="'+inwPremiumAmt+'" />'+
							  '<input type="hidden" id="inwFaculCommAmt" 			name="inwFaculCommAmt" 				value="'+inwCommAmt+'" />'+
							  '<input type="hidden" id="inwFaculWholdingTax" 		name="inwFaculWholdingTax" 			value="'+inwWholdingTax+'" />'+
							  '<input type="hidden" id="inwFaculparticulars" 		name="inwFaculparticulars"			value="'+inwparticulars+'" />'+
							  '<input type="hidden" id="inwFaculCurrencyCd" 		name="inwFaculCurrencyCd" 			value="'+inwCurrencyCd+'" />'+
							  '<input type="hidden" id="inwFaculConvertRate" 		name="inwFaculConvertRate" 			value="'+inwConvertRate+'" />'+
							  '<input type="hidden" id="inwFaculForeignCurrAmt" 	name="inwFaculForeignCurrAmt" 		value="'+inwForeignCurrAmt+'" />'+
							  '<input type="hidden" id="inwFaculCollectionAmt" 		name="inwFaculCollectionAmt" 		value="'+inwCollectionAmt+'" />'+
							  '<input type="hidden" id="inwFaculOrPrintTag" 		name="inwFaculOrPrintTag" 			value="'+inwOrPrintTag+'" />'+
							  '<input type="hidden" id="inwFaculUserId" 			name="inwFaculUserId"				value="'+inwUserId+'" />'+
							  '<input type="hidden" id="inwFaculLastUpdate" 		name="inwFaculLastUpdate" 			value="'+inwLastUpdate+'" />'+
							  '<input type="hidden" id="inwFaculCpiRecNo" 			name="inwFaculCpiRecNo" 			value="'+inwCpiRecNo+'" />'+
							  '<input type="hidden" id="inwFaculCpiBranchCd" 		name="inwFaculCpiBranchCd"			value="'+inwCpiBranchCd+'" />'+
							  '<input type="hidden" id="inwFaculTaxAmount" 			name="inwFaculTaxAmount" 			value="'+inwTaxAmount+'" />'+
							  '<input type="hidden" id="inwFaculCommVat" 			name="inwFaculCommVat" 				value="'+inwCommVat+'" />'+
							  '<input type="hidden" id="inwFaculTransactionTypeDesc" name="inwFaculTransactionTypeDesc" value="'+inwTransactionTypeDesc+'" />'+
							  '<input type="hidden" id="inwFaculRiName" 			 name="inwFaculRiName" 				value="'+inwRiName+'" />'+
							  '<input type="hidden" id="inwFaculAssdNo" 			 name="inwFaculAssdNo" 				value="'+inwAssdNo+'" />'+
							  '<input type="hidden" id="inwFaculAssdName" 			 name="inwFaculAssdName" 			value="'+inwAssdName+'" />'+
							  '<input type="hidden" id="inwFaculRiPolicyNo" 		 name="inwFaculRiPolicyNo" 			value="'+inwRiPolicyNo+'" />'+
							  '<input type="hidden" id="inwFaculDrvPolicyNo" 		 name="inwFaculDrvPolicyNo" 		value="'+inwDrvPolicyNo+'" />'+
							  '<input type="hidden" id="inwFaculCurrencyDesc" 		 name="inwFaculCurrencyDesc" 		value="'+inwCurrencyDesc+'" />'+
							  '<input type="hidden" id="inwFaculDefCollAmt" 		 name="inwFaculDefCollAmt" 			value="'+inwDefCollAmt+'" />'+
							  '<input type="hidden" id="inwFaculPremiumTax" 		 name="inwFaculPremiumTax" 			value="'+inwPremiumTax+'" />'+
							  '<input type="hidden" id="inwFaculSavedItem" 		 	 name="inwFaculSavedItem" 			value="'+inwSavedItem+'" />'+
							  '<input type="hidden" id="inwFaculSoaCollectionAmt" 	 name="inwFaculSoaCollectionAmt" 	value="'+inwSoaCollectionAmt+'" />'+
							  '<input type="hidden" id="inwFaculSoaPremiumAmt" 		 name="inwFaculSoaPremiumAmt" 		value="'+inwSoaPremiumAmt+'" />'+
							  '<input type="hidden" id="inwFaculSoaPremiumTax" 		 name="inwFaculSoaPremiumTax" 		value="'+inwSoaPremiumTax+'" />'+
							  '<input type="hidden" id="inwFaculSoaWholdingTax" 	 name="inwFaculSoaWholdingTax" 		value="'+inwSoaWholdingTax+'" />'+
							  '<input type="hidden" id="inwFaculSoaCommAmt" 		 name="inwFaculSoaCommAmt" 			value="'+inwSoaCommAmt+'" />'+
							  '<input type="hidden" id="inwFaculSoaTaxAmount" 		 name="inwFaculSoaTaxAmount" 		value="'+inwSoaTaxAmount+'" />'+
							  '<input type="hidden" id="inwFaculSoaCommVat" 		 name="inwFaculSoaCommVat" 			value="'+inwSoaCommVat+'" />'+
							  '<input type="hidden" id="inwFaculDefForgnCurAmt" 	 name="inwFaculDefForgnCurAmt" 		value="'+inwDefForgnCurAmt+'" />'+
							   
							  '<label name="textInw" style="text-align: left; width: 10%; margin-right: 3px;">'+(inwTransactionTypeDesc == "" ? "---" :inwTransactionTypeDesc.truncate(12, "..."))+'</label>'+
							  '<label name="textInw" style="text-align: left; width: 10%; margin-right: 3px;">'+(inwRiName == "" ? "---" :inwRiName.truncate(12, "..."))+'</label>'+
							  '<label name="textInwNo" style="text-align: right; width: 9%; margin-right: 3px;">'+(inwB140PremSeqNo == "" ? "---" :formatNumberDigits(inwB140PremSeqNo,8).truncate(12, "..."))+'</label>'+
							  '<label name="textInwAmt" style="text-align: right; width: 7%; margin-right: 3px;">'+(inwInstNo == "" ? "---" :inwInstNo.truncate(12, "..."))+'</label>'+
							  '<label name="textInwAmt" style="text-align: right; width: 12%; margin-right: 3px;" class="money">'+(inwCollectionAmt == "" ? "---" :inwCollectionAmt.truncate(12, "..."))+'</label>'+
							  '<label name="textInwAmt" style="text-align: right; width: 12%; margin-right: 3px;" class="money">'+(inwPremiumAmt == "" ? "---" :formatCurrency(inwPremiumAmt).truncate(12, "..."))+'</label>'+
							  '<label name="textInwAmt" style="text-align: right; width: 12%; margin-right: 3px;" class="money">'+(inwTaxAmount == "" ? "---" :formatCurrency(inwTaxAmount).truncate(12, "..."))+'</label>'+
							  '<label name="textInwAmt" style="text-align: right; width: 12%; margin-right: 3px;" class="money">'+(inwCommAmt == "" ? "---" :formatCurrency(inwCommAmt).truncate(12, "..."))+'</label>'+
							  '<label name="textInwAmt" style="text-align: right; width: 12%;" class="money">'+(inwCommVat == "" ? "---" :formatCurrency(inwCommVat).truncate(12, "..."))+'</label>';
							  			   
				if ($F("btnAddInw") == "Update") {	
					var id = getSelectedRowIdInTable_noSubstring("inwFaculTable", "inwFacul"); 	
					$(id).update(content);			
					$(id).setAttribute("gaacTranId",inwGaccTranId);
					$(id).setAttribute("transactionType",inwTransactionType);
					$(id).setAttribute("a180RiCd",inwA180RiCd);
					$(id).setAttribute("b140IssCd",inwB140IssCd);
					$(id).setAttribute("b140PremSeqNo",inwB140PremSeqNo);
					$(id).setAttribute("instNo",inwInstNo);
					$(id).setAttribute("id","rowInwFacul"+inwGaccTranId+inwTransactionType+inwA180RiCd+inwB140IssCd+inwB140PremSeqNo+inwInstNo);	
				} else {
					var newDiv = new Element('div');
					newDiv.setAttribute("name","inwFacul");
					newDiv.setAttribute("id","rowInwFacul"+inwGaccTranId+inwTransactionType+inwA180RiCd+inwB140IssCd+inwB140PremSeqNo+inwInstNo);
					newDiv.setAttribute("gaacTranId",inwGaccTranId);
					newDiv.setAttribute("transactionType",inwTransactionType);
					newDiv.setAttribute("a180RiCd",inwA180RiCd);
					newDiv.setAttribute("b140IssCd",inwB140IssCd);
					newDiv.setAttribute("b140PremSeqNo",inwB140PremSeqNo);
					newDiv.setAttribute("instNo",inwInstNo);
					newDiv.addClassName("tableRow");
  
					newDiv.update(content);
					$('inwFaculListing').insert({bottom: newDiv});
							 
					loadRowMouseOverMouseOutObserver(newDiv);
					newDiv.observe("click", function ()	{	
						newDiv.toggleClassName("selectedRow");
						if (newDiv.hasClassName("selectedRow"))	{
							$$("div[name='inwFacul']").each(function (li)	{
									if (newDiv.getAttribute("id") != li.getAttribute("id"))	{
									li.removeClassName("selectedRow");
								}
							});
							clearForm();
							getDefaults();
							$("transactionTypeInw").value = newDiv.down("input",1).value;
							$("transactionTypeInwReadOnly").value = getListTextValue("transactionTypeInw"); //for readonly	
							getReinsurerLOV(newDiv.down("input",2).value);
							$("b140IssCdInw").value =  newDiv.down("input",3).value;	
							$("b140PremSeqNoInw").value = formatNumberDigits(newDiv.down("input",4).value,8);
							$("instNoInw").value = newDiv.down("input",5).value;
							$("premiumAmtInw").value = formatCurrency(newDiv.down("input",6).value);
							$("commAmtInw").value = formatCurrency(newDiv.down("input",7).value);
							$("wholdingTaxInw").value = newDiv.down("input",8).value;
							$("particularsInw").value = newDiv.down("input",9).value;
							$("currencyCdInw").value = newDiv.down("input",10).value;
							$("convertRateInw").value = formatToNineDecimal(newDiv.down("input",11).value);
							$("foreignCurrAmtInw").value = formatCurrency(newDiv.down("input",12).value);
							$("collectionAmtInw").value = newDiv.down("input",13).value == "" ? "" :formatCurrency(newDiv.down("input",13).value);
							$("orPrintTagInw").value = newDiv.down("input",14).value;
							$("cpiRecNoInw").value = newDiv.down("input",17).value;	
							$("cpiBranchCdInw").value = newDiv.down("input",18).value;				
							$("taxAmountInw").value = formatCurrency(newDiv.down("input",19).value);
							$("commVatInw").value = formatCurrency(newDiv.down("input",20).value);				
							$("assdNoInw").value = newDiv.down("input",23).value;				
							$("assuredNameInw").value = newDiv.down("input",24).value;
							$("riPolicyNoInw").value = newDiv.down("input",25).value;
							$("policyNoInw").value = newDiv.down("input",26).value;
							$("currencyDescInw").value = newDiv.down("input",27).value;
							$("defCollnAmtInw").value = newDiv.down("input",28).value; 
							$("premiumTaxInw").value = newDiv.down("input",29).value; 
							$("savedItemInw").value = newDiv.down("input",30).value; 
							$("variableSoaCollectionAmtInw").value = newDiv.down("input",31).value; 
							$("variableSoaPremiumAmtInw").value = newDiv.down("input",32).value; 
							$("variableSoaPremiumTaxInw").value = newDiv.down("input",33).value; 
							$("variableSoaWholdingTaxInw").value = newDiv.down("input",34).value; 
							$("variableSoaCommAmtInw").value = newDiv.down("input",35).value; 
							$("variableSoaTaxAmountInw").value = newDiv.down("input",36).value; 
							$("variableSoaCommVatInw").value = newDiv.down("input",37).value; 
							$("defForgnCurAmtInw").value = newDiv.down("input",38).value; 
						} else {
							clearForm();
							enableOrDisbleItem();
							deselectRows("inwFaculTable","inwFacul");
						} 
						enableOrDisbleItem();
					}); 
		
					Effect.Appear(newDiv, {
						duration: .5, 
						afterFinish: function ()	{
						checkTableItemInfo("inwFaculTable","inwFaculListing","inwFacul");
						}
					});
				}
				changeTag = 1;
				clearForm();
				enableOrDisbleItem();
				deselectRows("inwFaculTable","inwFacul");
			}
		} catch (e)	{
			showErrorMessage("addInwardFacul", e);
		}
	}
	objAC.hidObjAC008.addInwardFaculFunc = addInwardFacul;

	//delete record observe
	$("btnDeleteInw").observe("click", function() {
		deleteInwardFacul();
	});

	//delete record function
	function deleteInwardFacul(){
		$$("div[name='inwFacul']").each(function (acc)	{
			if (acc.hasClassName("selectedRow")){
				if (acc.down("input",14).value == "Y"){
					showMessageBox("Delete not allowed. This record was created before the OR was printed.", imgMessage.ERROR);
					return false;
				}else{	
					Effect.Fade(acc, {
						duration: .5,
						afterFinish: function ()	{
							var inwGaccTranId = $F("gaccTranIdInw");
							var inwTransactionType = $F("transactionTypeInw");
							if ($F("transactionTypeInw") == "2" || $F("transactionTypeInw") == "4"){
								var inwA180RiCd = $F("a180RiCdInw");
							}else{
								var inwA180RiCd = $F("a180RiCd2Inw");
							}	
							var inwB140IssCd 	 = $F("b140IssCdInw");
							var inwB140PremSeqNo = $F("b140PremSeqNoInw");
							var inwInstNo 		 = $F("instNoInw");
							var inwCollectionAmt = $F("collectionAmtInw"); 
							var inwPremiumAmt 	 = $F("premiumAmtInw");
							var inwCommAmt 		 = $F("commAmtInw");
							var inwWholdingTax 	 = $F("wholdingTaxInw");
							var inwTaxAmount 	 = $F("taxAmountInw");
							var inwCommVat 		 = $F("commVatInw");
							var inwSavedItem 	 = $F("savedItemInw");
							if (inwSavedItem == "Y"){
								var listingDiv 	     = $("inwFaculListing");
								var newDiv 		     = new Element("div");
								newDiv.setAttribute("id", "rowInwFaculDelete"+inwGaccTranId+inwTransactionType+inwA180RiCd+inwB140IssCd+inwB140PremSeqNo+inwInstNo); 
								newDiv.setAttribute("name", "rowInwFaculDelete"); 
								newDiv.addClassName("tableRow");
								newDiv.setStyle("display : none");
								newDiv.update(										
									'<input type="hidden" name="delInwGaccTranId" 		value="'+inwGaccTranId+'" />' +
									'<input type="hidden" name="delInwTransactionType" 	value="'+inwTransactionType+'" />'+
									'<input type="hidden" name="delInwA180RiCd" 		value="'+inwA180RiCd+'" />'+
									'<input type="hidden" name="delInwB140IssCd" 		value="'+inwB140IssCd+'" />'+
									'<input type="hidden" name="delInwB140PremSeqNo" 	value="'+inwB140PremSeqNo+'" />'+
									'<input type="hidden" name="delInwInstNo" 			value="'+inwInstNo+'" />'+
									'<input type="hidden" name="delInwCollectionAmt" 	value="'+inwCollectionAmt+'" />'+
									'<input type="hidden" name="delInwPremiumAmt" 		value="'+inwPremiumAmt+'" />'+
									'<input type="hidden" name="delInwCommAmt" 			value="'+inwCommAmt+'" />'+
									'<input type="hidden" name="delInwWholdingTax" 		value="'+inwWholdingTax+'" />'+
									'<input type="hidden" name="delInwTaxAmount" 		value="'+inwTaxAmount+'" />'+
									'<input type="hidden" name="delInwCommVat" 			value="'+inwCommVat+'" />');
								listingDiv.insert({bottom : newDiv});
							}
							changeTag = 1;
							acc.remove();
							clearForm();
							enableOrDisbleItem();
							checkTableItemInfo("inwFaculTable","inwFaculListing","inwFacul");
						} 
					});
				}		
			}
		});
	}	

	//get the default value
	function getDefaults()	{
		$("btnAddInw").value = "Update";
		enableButton("btnDeleteInw");
	}

	//clear all items
	function clearForm(){
		$("transactionTypeInw").clear();
		$("transactionTypeInwReadOnly").clear(); //for readonly
		$("a180RiCdInw").clear();
		$("a180RiCd2Inw").clear();
		$("cedantInwReadOnly").clear();
		$("b140PremSeqNoInw").clear();
		$("instNoInw").clear();
		$("collectionAmtInw").clear();
		$("assuredNameInw").clear();
		$("policyNoInw").clear();
		$("particularsInw").clear();
		$("b140IssCdInw").value == "RI";
		$("premiumAmtInw").clear();
		$("commAmtInw").clear();
		$("wholdingTaxInw").clear();
		$("currencyCdInw").clear();
		$("convertRateInw").clear();
		$("foreignCurrAmtInw").clear();
		$("orPrintTagInw").clear();
		$("cpiRecNoInw").clear();
		$("cpiBranchCdInw").clear();
		$("taxAmountInw").clear();
		$("commVatInw").clear();	
		$("assdNoInw").clear();
		$("riPolicyNoInw").clear();
		$("defCollnAmtInw").clear();
		$("premiumTaxInw").clear();
		$("currencyDescInw").clear();
		$("savedItemInw").clear();
		$("variableSoaCollectionAmtInw").clear();
		$("variableSoaPremiumAmtInw").clear();
		$("variableSoaPremiumTaxInw").clear();
		$("variableSoaWholdingTaxInw").clear();
		$("variableSoaCommAmtInw").clear();
		$("variableSoaTaxAmountInw").clear();
		$("variableSoaCommVatInw").clear();
		$("defForgnCurAmtInw").clear();

		objAC.hidObjAC008.hidUpdateable = "Y";
		$("btnAddInw").value = "Add";
		enableButton("btnAddInw");
		if (objACGlobal.tranFlagState != 'O'){
			disableButton("btnAddInw");
		}
		disableButton("btnDeleteInw");
		getReinsurerLOV("");
		computeTotalAmountInTable();
	}	

	//to get the correct reinsurer LOV based on the transaction type
	function getReinsurerLOV(riCd){
		if ($F("transactionTypeInw") == "2" || $F("transactionTypeInw") == "4"){
			$("a180RiCdInw").show();
			$("a180RiCd2Inw").hide();
			$("a180RiCdInw").selectedIndex = 0;
			filterReinsurerLOV(riCd);
			$("a180RiCdInw").enable();
			$("cedantInwReadOnly").value = getListTextValue("a180RiCdInw");
		}else{
			$("a180RiCdInw").hide();
			$("a180RiCd2Inw").show();
			$("a180RiCd2Inw").selectedIndex = 0;
			$("a180RiCd2Inw").value = riCd;
			$("a180RiCd2Inw").enable();	
			$("cedantInwReadOnly").value = getListTextValue("a180RiCd2Inw");
		}	
	}	

	//to filter the reinsurer LOV based on the transaction type
	function filterReinsurerLOV(riCd){
		removeAllOptions($("a180RiCdInw"));
		var opt = document.createElement("option");
		opt.value = "";
		opt.text = "";
		opt.setAttribute("transactiontype", ""); 
		$("a180RiCdInw").options.add(opt);
		for(var a=0; a<a180RiCdInwObjLOV.length; a++){
			var globalTrType = $F("transactionTypeInw");
			if ($F("transactionTypeInw") == "2"){
				globalTrType = "1";
			}else if ($F("transactionTypeInw") == "4"){
				globalTrType = "3";
			}		
			if (a180RiCdInwObjLOV[a].transactionType == globalTrType){
				var opt = document.createElement("option");
				opt.value = a180RiCdInwObjLOV[a].riCd;
				opt.text = a180RiCdInwObjLOV[a].riName;
				opt.setAttribute("transactiontype", a180RiCdInwObjLOV[a].transactionType); 
				$("a180RiCdInw").options.add(opt);
			}	
		}	
		$("a180RiCdInw").value = riCd;
	}	

	//enable or disble the item
	function enableOrDisbleItem(){
		if ($F("savedItemInw") == "Y"){
			$("transactionTypeInw").disable();
			$("a180RiCdInw").disable();
			$("a180RiCd2Inw").disable(); 
			$("b140PremSeqNoInw").readOnly = true;
			$("instNoInw").readOnly = true;
			$("collectionAmtInw").readOnly = true;
			$("foreignCurrAmtInw").readOnly = true;
			$("particularsInw").readOnly = true;
			disableButton("btnAddInw");
			$("transactionTypeInwReadOnly").show();
			$("transactionTypeInw").hide();
			$("cedantInwReadOnly").show();
			$("a180RiCdInw").hide();
			$("a180RiCd2Inw").hide(); 
			$("invoiceInwDate").hide();
			$("instNoInwDate").hide();
			objAC.hidObjAC008.hidUpdateable = "N";
		}else{
			$("transactionTypeInw").enable();
			$("transactionTypeInw").show();
			$("transactionTypeInwReadOnly").hide();
			$("cedantInwReadOnly").hide();
			$("invoiceInwDate").show();
			$("instNoInwDate").show();
			objAC.hidObjAC008.hidUpdateable = "Y";
			if ($F("transactionTypeInw").blank()){
				$("a180RiCdInw").disable();
				$("a180RiCd2Inw").disable();
				$("b140PremSeqNoInw").readOnly = true;
				$("instNoInw").readOnly = true;
				$("collectionAmtInw").readOnly = true;
				$("foreignCurrAmtInw").readOnly = true;
				$("particularsInw").readOnly = false;
			}else if ($F("transactionTypeInw") == "1" || $F("transactionTypeInw") == "2" || $F("transactionTypeInw") == "3" || $F("transactionTypeInw") == "4"){
				$("a180RiCdInw").enable();
				$("a180RiCd2Inw").enable(); 
				enableButton("btnAddInw");
				if ($F("transactionTypeInw") == "2" || $F("transactionTypeInw") == "4"){
					if ($F("a180RiCdInw").blank()){ 
						$("b140PremSeqNoInw").readOnly = true;
						$("instNoInw").readOnly = true;
						$("collectionAmtInw").readOnly = true;
						$("foreignCurrAmtInw").readOnly = true;
						$("particularsInw").readOnly = false;
					}else{
						$("b140PremSeqNoInw").readOnly = false;
					}
	
					if ($F("b140PremSeqNoInw").blank()){
						$("instNoInw").readOnly = true;
						$("collectionAmtInw").readOnly = true;
						$("foreignCurrAmtInw").readOnly = true;
						$("particularsInw").readOnly = false;
					}else{
						$("instNoInw").readOnly = false;
						$("collectionAmtInw").readOnly = false;
						$("foreignCurrAmtInw").readOnly = false;
						$("particularsInw").readOnly = false;
					}

					if ($F("instNoInw").blank()){
						$("collectionAmtInw").readOnly = true;
						$("foreignCurrAmtInw").readOnly = true;
					}else{
						$("collectionAmtInw").readOnly = false;
						$("foreignCurrAmtInw").readOnly = false;
					}
				}else{
					if ($F("a180RiCd2Inw").blank()){ 
						$("b140PremSeqNoInw").readOnly = true;
						$("instNoInw").readOnly = true;
						$("collectionAmtInw").readOnly = true;
						$("foreignCurrAmtInw").readOnly = true;
						$("particularsInw").readOnly = false;
					}else{
						$("b140PremSeqNoInw").readOnly = false;
					}
	
					if ($F("b140PremSeqNoInw").blank()){
						$("instNoInw").readOnly = true;
						$("collectionAmtInw").readOnly = true;
						$("foreignCurrAmtInw").readOnly = true;
						$("particularsInw").readOnly = false;
					}else{
						$("instNoInw").readOnly = false;
						$("collectionAmtInw").readOnly = false;
						$("foreignCurrAmtInw").readOnly = false;
						$("particularsInw").readOnly = false;
					}

					if ($F("instNoInw").blank()){
						$("collectionAmtInw").readOnly = true;
						$("foreignCurrAmtInw").readOnly = true;
					}else{
						$("collectionAmtInw").readOnly = false;
						$("foreignCurrAmtInw").readOnly = false;
					}		
				}			
			}
		}	
	}	

	//compute the total amount in table
	function computeTotalAmountInTable(){
		var total = 0;
		var total2 = 0;
		var total3 = 0;
		var total4 = 0;
		var total5 = 0;
		var ctr = 0;
		$$("div#inwFaculTable div[name='inwFacul']").each(function(row){
			if (row.getAttribute("gaacTranId") == $F("gaccTranIdInw")){
				ctr++;
				total = parseFloat(total) + parseFloat((row.down("input",13).value.replace(/,/g, "") == "" ? 0 :row.down("input",13).value.replace(/,/g, "")));
				total2 = parseFloat(total2) + parseFloat((row.down("input",6).value.replace(/,/g, "") == "" ? 0 :row.down("input",6).value.replace(/,/g, "")));
				total3 = parseFloat(total3) + parseFloat((row.down("input",19).value.replace(/,/g, "") == "" ? 0 :row.down("input",19).value.replace(/,/g, "")));
				total4 = parseFloat(total4) + parseFloat((row.down("input",7).value.replace(/,/g, "") == "" ? 0 :row.down("input",7).value.replace(/,/g, "")));
				total5 = parseFloat(total5) + parseFloat((row.down("input",20).value.replace(/,/g, "") == "" ? 0 :row.down("input",20).value.replace(/,/g, "")));
			}	
		});
		if (parseInt(ctr) <= 5){
			$("inwFaculTotalAmtMainDiv").setStyle("padding-right:0px");
		}else{
			$("inwFaculTotalAmtMainDiv").setStyle("padding-right:17px");
		}	
		if (parseInt(ctr) > 0){
			$("inwFaculTotalAmtMainDiv").show();
		}else{
			$("inwFaculTotalAmtMainDiv").hide();
		}
		$("inwFaculTotalAmtMainDiv").down("label",1).update(formatCurrency(total).truncate(13, "..."));
		$("inwFaculTotalAmtMainDiv").down("label",2).update(formatCurrency(total2).truncate(13, "..."));
		$("inwFaculTotalAmtMainDiv").down("label",3).update(formatCurrency(total3).truncate(13, "..."));
		$("inwFaculTotalAmtMainDiv").down("label",4).update(formatCurrency(total4).truncate(13, "..."));
		$("inwFaculTotalAmtMainDiv").down("label",5).update(formatCurrency(total5).truncate(13, "..."));
	}	

	//for currency DIV
	$("btnCurrencyInfoInw").observe("click", function() {
		$("breakdownInwDiv").hide();
		if ($("currencyInwDiv").getStyle("display") == "none"){
			Effect.Appear($("currencyInwDiv"), {
				duration: .2
			});
		}else{
			Effect.Fade($("currencyInwDiv"), {
				duration: .2
			});
		}	
	});
	$("btnHideCurrInwDiv").observe("click", function() {
		Effect.Fade($("currencyInwDiv"), {
			duration: .2
		});
	});

	//for breakdown DIV
	$("btnBreakDownInw").observe("click", function() {
		$("currencyInwDiv").hide();
		if ($("breakdownInwDiv").getStyle("display") == "none"){
			Effect.Appear($("breakdownInwDiv"), {
				duration: .2
			});
		}else{
			Effect.Fade($("breakdownInwDiv"), {
				duration: .2
			});
		}	
	});
	$("btnHideBreakdownInwDiv").observe("click", function() {
		Effect.Fade($("breakdownInwDiv"), {
			duration: .2
		});
	});

	function saveGIPIS008(){
		new Ajax.Request(contextPath + "/GIACInwFaculPremCollnsController?action=saveInwardFacul", {
			method: "POST",
			postBody: Form.serialize("itemInformationForm")+"&globalGaccTranId="+objACGlobal.gaccTranId+"&globalGaccBranchCd="+objACGlobal.branchCd+"&globalGaccFundCd="+objACGlobal.fundCd+"&globalTranSource="+objACGlobal.tranSource+"&globalOrFlag="+objACGlobal.orFlag,
			asynchronous : false,
			evalScripts : true,
			onCreate : function() {
				showNotice("Saving. Please wait...");
			},
			onComplete : function(response) {
				hideNotice("");
				if (checkErrorOnResponse(response)) {
					if (response.responseText == "SUCCESS"){
						showMessageBox(objCommonMessage.SUCCESS,imgMessage.SUCCESS);
						updateInwFaculTableRecords();
						clearForm();
						deselectRows("inwFaculTable","inwFacul");
						changeTag = 0;
					}else{
						showMessageBox(response.responseText.replace("Error occured. ",""),imgMessage.ERROR);
					}	
				}		
			}
		});
	}	

	observeCancelForm("btnCancelInwFacul", saveGIPIS008, editORInformation);
	
	//on SAVE button click
	observeSaveForm("btnSaveInwFacul", saveGIPIS008);

	//when save success update the saveitem variable in each record to Y then remove all deleted records
	function updateInwFaculTableRecords(){
		$$("div[name='inwFacul']").each(function(row) {
			row.down("input", 30).value = "Y";
		});
		$$("div[name='rowInwFaculDelete']").each(function (row)	{
			row.remove();
		});	
	}	
	
	clearForm();
	enableOrDisbleItem();
	checkTableItemInfo("inwFaculTable","inwFaculListing","inwFacul");
	$("b140PremSeqNoInw").setStyle("text-align:left;");
	$("instNoInw").setStyle("text-align:left;");
	changeTag = 0; 
	initializeChangeTagBehavior(saveGIPIS008);
	setDocumentTitle("Inward Facultative Premium Collections");
	window.scrollTo(0,0); 	
	hideNotice("");
</script>
