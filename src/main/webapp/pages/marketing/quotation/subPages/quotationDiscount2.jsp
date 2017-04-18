<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div id="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" >
   		<label>Policy Discount/Surcharge</label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label name="gro" style="margin-left: 5px;">Hide</label>	   		
   		</span>
   	</div>
</div>

<div class="sectionDiv" id="quotePolicyDiscountDiv">
	<div id="quotePolicyDiscount" style="margin: 10px;">
		<div id="quotePolicyBasicDiscountTable">
			<div style="width: 100%;" id="quotePolicyBasicDiscountTableHeader" style="margin-top: 10px;">
				<div style="background-color: #E0E0E0; color: #808080; font-weight: bold; height: 20px; padding-top: 5px;">
					<label style="width: 140px; text-align: center;">Sequence</label>
					<label style="width: 120px; text-align: right;">Premium Amount</label>
					<label style="width: 130px; text-align: right;">Discount Amount</label>
			   		<label style="width: 120px; text-align: right;">Discount Rate</label>
			   		<label style="width: 140px; text-align: right;">Surcharge Amount</label>
			   		<label style="width: 130px; text-align: right;">Surcharge Rate</label>
					<label style="width: 50px; text-align: center;">G</label>				
				</div>
			</div>
			<div style="width: 100%;" id="quotePolicyBasicDiscountTableList" class="tableContainer" style="margin-top: 10px;">
				<jsp:include page="../subPages/basicDiscountListing.jsp"></jsp:include>
			</div>
			<div style="width: 100%;" id="quoteHiddenPerilTableList" class="tableContainer" style="margin-top: 10px;">
				
			</div>
		</div>
		<div id="discountForm1">
			<table width="80%" align="center" cellspacing="1" border="0" style="margin-top: 10px;">
	 			<tr>
	 				<td class="rightAligned">Sequence </td>
					<td class="leftAligned">
						<input id="sequenceNo" style="width: 100px; margin-right: 20px;" type="text" value="" readonly="readonly"/>
						<input id="grossTag" type="checkbox" style="width: 10px;" value="" checked />
						<label class="rightAligned" style="float: none;">Gross</label>
					</td>			
				</tr>
				<tr>
					<td class="rightAligned">Premium Amount </td>
					<td class="leftAligned">
						<input id="premAmt" style="width: 210px;" type="text" value="<fmt:formatNumber pattern="#,###.####" minFractionDigits="2">${gipiQuote.annPremAmt}</fmt:formatNumber>" class="money" readonly="readonly" /></td>
				</tr>
				<tr>
					<td class="rightAligned">Discount Amount </td>
					<td class="leftAligned">
						<input id="discountAmt" style="width: 210px;" type="text" value="" class="money discountAmt" /></td>
					<td class="rightAligned">Surcharge Amount </td>
					<td class="leftAligned">
						<input id="surchargeAmt" style="width: 210px;" type="text" value="" class="money surchargeAmt" /></td>
				</tr>
				<tr>
					<td class="rightAligned">Discount Rate </td>
					<td class="leftAligned">
						<input id="discountRt" style="width: 210px;" type="text" value="" class="discountRt" /></td>
					<td class="rightAligned">Surcharge Rate </td>
					<td class="leftAligned">
						<input id="surchargeRt" style="width: 210px;" type="text" value="" class="surchargeRt" /></td>
				</tr>
				<tr>
					<td class="rightAligned">Remarks </td>
					<td class="leftAligned" colspan="3">
						<div style="border: 1px solid gray; height: 20px; width: 583px;">
							<textarea id="remark" style="width: 551px; border: none; height: 13px;"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" />
						</div>
					</td>				
				</tr>
			</table>
			<input type='hidden' id="origBasicDiscountAmt" name="origBasicDiscountAmt" value="" />
		    <input type='hidden' id="origBasicSurchargeAmt" name="origBasicSurchargeAmt" value="" />
		    <input type='hidden' name="origDiscountAmt" id="origDiscountAmt" />
			<div align="center" style="margin-top: 10px;">
				<table>
					<tr>
						<td><input type="button" class="button" id="btnAddDiscount" name="btnAddDiscount" value="Add" style="width: 60px;" /></td>					
						<!-- <td><input type="button" class="disabledButton" id="btnEditDiscount" name="btnEditDiscount" value="Edit" style="display: none; width: 60px;" /></td> -->
						<td><input type="button" class="disabledButton" id="btnDelDiscount" name="btnDelDiscount" value="Delete" style="width: 60px;" /></td>
					</tr>
				</table>
			</div>
		</div>
	</div>
</div>
<script>
	checkTableIfEmpty("rowBasic", "quotePolicyBasicDiscountTable");

	$("grossTag").observe("click", function () {
		if ($("grossTag").checked){
			$("premAmt").value = formatCurrency($("quoteAnnPremAmt").value);
			$("discountAmt").value = formatCurrency($F("origDiscountAmt"));
		} else{
			$("origDiscountAmt").value = $("discountAmt").value;
			$("premAmt").value = formatCurrency(getTotalPolicyDiscounts());//formatCurrency($("quotePremAmt").value);
			$("discountAmt").value = generateDiscountSurchargeAmount("discountRt", "premAmt");
			$("surchargeAmt").value = generateDiscountSurchargeAmount("surchargeRt", "premAmt");	
		}	
	});
	
	$("discountAmt").observe("keyup", function () {
		$("discountRt").value = generateDiscountSurchargeRate("discountAmt", "premAmt");
	});

	$("discountAmt").observe("blur", function () {
		if (unformatCurrency("discountAmt") > unformatCurrency("premAmt")){
			customShowMessageBox("Discount amount greater than the premium amount is not allowed.", imgMessage.INFO, "discountAmt");
		}else if (unformatCurrency("discountAmt") > (unformatCurrency("quotePremAmt") + unformatCurrency("surchargeAmt"))){
			customShowMessageBox("Invalid Discount Amount. Adding of Discount will result to negative Net Premium Amount.", imgMessage.INFO, "discountAmt");
		}	
	});

	$("surchargeAmt").observe("keyup", function () {
		$("surchargeRt").value = generateDiscountSurchargeRate("surchargeAmt", "premAmt");
	});
	
	$("surchargeAmt").observe("blur", function () {
		if (((getTotalPolicyDiscounts() + unformatCurrency("surchargeAmt")) - unformatCurrency("discountAmt")) > unformatCurrency("quoteTsiAmt")){
			customShowMessageBox("Invalid Surcharge Amount. Value should be greater than 0.00 but should not result to a Net Premium Amount greater than TSI Amount.", imgMessage.INFO, "surchargeAmt");
		}
	});
	

	$("discountRt").observe("keyup", function () {
		$("discountAmt").value = generateDiscountSurchargeAmount("discountRt", "premAmt");
	});

	$("surchargeRt").observe("keyup", function () {
		$("surchargeAmt").value = generateDiscountSurchargeAmount("surchargeRt", "premAmt");
	});

	 function getTotalPolicyDiscounts(){
	        var premPolicyTotal = 0;
	        var surcPolicyTotal = 0;
	    	$$("div[name='rowBasic']").each(function (div) {
	    		premPolicyTotal = Math.round((premPolicyTotal + parseFloat(div.down("input", 2).value.replace(/,/g, "")))*100)/100;
	    		surcPolicyTotal = Math.round((surcPolicyTotal + parseFloat(div.down("input", 4).value.replace(/,/g, "")))*100)/100;
	    	});

	    	$$("div[name='rowItem']").each(function (div) {
		    	var currRt = 0;
	    		$$("div[name='hiddenItemDiv']").each(function(rowItem){
		    		if (div.down("input", 1).value == rowItem.down("input", 0).value) {
		    			currRt = parseFloat(rowItem.down("input", 1).value);
		    		}
	    		});
	    		premPolicyTotal = premPolicyTotal + Math.round((parseFloat(div.down("input", 4).value.replace(/,/g, "")) * currRt)*100)/100;
	    		surcPolicyTotal = surcPolicyTotal + Math.round((parseFloat(div.down("input", 6).value.replace(/,/g, "")) * currRt)*100)/100;
	    	});

	    	
	    	$$("div[name='rowPeril']").each(function (div) {
	    		var currRt = 0;
	    		$$("div[name='hiddenItemDiv']").each(function(rowItem){
		    		if (div.down("input", 1).value == rowItem.down("input", 0).value) {
		    			currRt = parseFloat(rowItem.down("input", 1).value);
		    		}
	    		});
	    		premPolicyTotal = premPolicyTotal + Math.round((parseFloat(div.down("input", 4).value.replace(/,/g, "")) * currRt)*100)/100;
	    		surcPolicyTotal = surcPolicyTotal + Math.round((parseFloat(div.down("input", 6).value.replace(/,/g, "")) * currRt)*100)/100;
	    	});
	    	premPolicyTotal = (unformatCurrency("quoteAnnPremAmt") + surcPolicyTotal) - premPolicyTotal;
	    	
	    	return premPolicyTotal;
	  }
</script>