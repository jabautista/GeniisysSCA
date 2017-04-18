<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<div id="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" >
   		<label>Item Discount/Surcharge</label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label name="gro" style="margin-left: 5px;">Hide</label>	   		
   		</span>
   	</div>
</div>

<div class="sectionDiv" id="quoteItemDiscountDiv">
	<div id="quoteItemDiscount" style="margin: 10px;">
		<div id="quoteItemDiscountTable">
			<div style="width: 100%;" id="quoteItemDiscountTable" style="margin-top: 10px;">
				<div style="background-color: #E0E0E0; color: #808080; font-weight: bold; height: 20px; padding-top: 5px;">
					<label style="width: 120px; text-align: center;">Sequence</label>
					<label style="width: 100px; text-align: right;">Prem Amt</label>
					<label style="width: 100px; text-align: center;">Item</label>
					<label style="width: 100px; text-align: left;">Item Title</label>
					<label style="width: 100px; text-align: right;">Disc Amt</label>
			   		<label style="width: 100px; text-align: right;">Disc Rate</label>
			   		<label style="width: 100px; text-align: right;">Surch Amt</label>
			   		<label style="width: 100px; text-align: right;">Surch Rate</label>
					<label style="width: 50px; text-align: center;">G</label>
				</div>
			</div>
			<div style="width: 100%;" class="tableContainer" id="quoteItemDiscountTableList" style="margin-top: 10px;">
				<jsp:include page="../subPages/itemDiscountListing.jsp"></jsp:include>
			</div>
		</div>
		<div id="discountForm2">
			<table width="80%" align="center" cellspacing="1" border="0" style="margin-top: 10px;">
	 			<tr>
	 				<td class="rightAligned">Sequence </td>
					<td class="leftAligned">
						<input id="sequenceNoItem" style="width: 100px; margin-right: 20px;" type="text" value="" readonly="readonly" />
						<input id="grossTagItem" type="checkbox" style="width: 10px;" value="" checked />
						<label class="rightAligned" style="float: none;">Gross</label> </td>
	 				<td class="rightAligned">Discount Amount </td>
					<td class="leftAligned">
						<input id="discountAmtItem" style="width: 210px;" type="text" value="" class="money discountAmt" /></td> 				
				</tr>
				<tr>
					<td class="rightAligned">Premium Amount </td>
					<td class="leftAligned">
						<input id="premAmtItem" style="width: 210px;" type="text" value="" class="money" readonly="readonly" /></td>
					<td class="rightAligned">Discount Rate </td>
					<td class="leftAligned">
						<input id="discountRtItem" style="width: 210px;" type="text" value="" class="discountRt" /></td>
				</tr>
				<tr>
					<td class="rightAligned">Item No. </td>
					<td class="leftAligned">
						<select id="itemNo" name="" style="width: 218px;" >				
							<option value=""/>Select...</option>
							<c:forEach var="quoteItem" items="${quoteItems}">
								<option currRt="${quoteItem.currencyRate}" netPrem="${quoteItem.premAmt}" annPremAmt="${quoteItem.annPremAmt}" itemNo="${quoteItem.itemNo}" tsiAmt="${quoteItem.tsiAmt}" value="${quoteItem.itemNo}"/>${quoteItem.itemNo}</option>
							</c:forEach>
						</select>
						<select id="itemTitleSelected" name="" style="width: 218px; display:none;">		
							<option value=""/>Select...</option>
							<c:forEach var="quoteItem" items="${quoteItems}">
								<option value="${quoteItem.itemTitle}"/>${quoteItem.itemTitle}</option>
							</c:forEach>
						</select>
					</td>
					<td class="rightAligned">Surcharge Amount </td>
					<td class="leftAligned">
						<input id="surchargeAmtItem" style="width: 210px;" type="text" value="" class="money surchargeAmt" /></td>
				</tr>
				<tr>
					<td class="rightAligned">Item Title </td>
					<td class="leftAligned">
						<input id="itemTitle" style="width: 210px;" type="text" value="" readonly="readonly" /></td>
					<td class="rightAligned">Surcharge Rate </td>
					<td class="leftAligned">
						<input id="surchargeRtItem" style="width: 210px;" type="text" value="" class="surchargeRt" /></td>
				</tr>
				<tr>
					<td class="rightAligned">Remarks </td>
					<td class="leftAligned" colspan="3">
						<div style="border: 1px solid gray; height: 20px; width: 583px;">
							<textarea id="remarkItem" style="width: 551px; border: none; height: 13px;"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks1" />
						</div>
					</td>
				</tr>
			</table>
			<c:forEach var="quoteItem" items="${quoteItems}">
				<div id="hiddenItemDiv${quoteItem.itemNo}" name="hiddenItemDiv">
					<input type="hidden" id="hiddenItemNo" name="hiddenItemNo" value="${quoteItem.itemNo}">
					<input type="hidden" id="hiddenItemCurrRt" name="hiddenItemCurrRt" value="${quoteItem.currencyRate}">
					<input type="hidden" id="hiddenItemPremAmt" name="hiddenItemPremAmt" value="${quoteItem.premAmt}">
					<input type="hidden" id="hiddenItemOrigPremAmt" name="hiddenItemOrigPremAmt" value="${quoteItem.annPremAmt}">
				</div>				
			</c:forEach>
			<input type='hidden' name="origItemDiscountAmt" id="origItemDiscountAmt" value="" />	
			<input type='hidden' name="origItemSurchargeAmt" id="origItemSurchargeAmt" value="" />
			<input type='hidden' name="origItemDiscountAmt" id="origItemDiscountAmt" />	
			<div align="center" style="margin-top: 10px;">
				<table>
					<tr>					
						<td><input type="button" class="button" id="btnAddDiscountItem" name="btnAddDiscountItem" value="Add" style="width: 60px;" /></td>
						<!-- <td><input type="button" class="button" id="btnEditDiscountItem" name="btnEditDiscountItem" value="Edit Discount/Surcharge" style="display:none" /></td>-->
						<td><input type="button" class="disabledButton" id="btnDelDiscountItem" name="btnDelDiscountItem" value="Delete" style="width: 60px;" /></td>
					</tr>
				</table>
			</div>
		</div>
	</div>	
</div>
<script>
	checkTableIfEmpty("rowItem", "quoteItemDiscountTable");

	$("grossTagItem").observe("click", function () {
		if ($("perilAnnPremAmtSelect"+ $("itemNo").value) != null){
			if ($("grossTagItem").checked){
				$("premAmtItem").value = formatCurrency($("itemNo").options[$("itemNo").selectedIndex].getAttribute("annPremAmt"));
				$("discountAmtItem").value = formatCurrency($F("origItemDiscountAmt"));
			} else{
				$("origItemDiscountAmt").value = $("discountAmtItem").value;
				$("premAmtItem").value = formatCurrency($("itemNo").options[$("itemNo").selectedIndex].getAttribute("netPrem"));
				$("discountAmtItem").value = generateDiscountSurchargeAmount("discountRtItem", "premAmtItem");
				$("surchargeAmtItem").value = generateDiscountSurchargeAmount("surchargeRtItem", "premAmtItem");
			}
			
		}	
	});
	
	$("itemNo").observe("change", function () {
		$("premAmtItem").value = formatCurrency($("itemNo").options[$("itemNo").selectedIndex].getAttribute("annPremAmt"));
		$("grossTagItem").checked = true;
	});
	
	$("discountAmtItem").observe("keyup", function () {
		$("discountRtItem").value = generateDiscountSurchargeRate("discountAmtItem", "premAmtItem");
	});

	$("discountAmtItem").observe("click", function () {
		if ($("itemNo").selectedIndex == 0){
			customShowMessageBox("Please select an Item first.", imgMessage.INFO, "itemNo");
		}	
	});

	$("discountAmtItem").observe("blur", function () {
		if (unformatCurrency("discountAmtItem") > unformatCurrency("premAmtItem")) {
			customShowMessageBox("Discount amount greater than the premium amount is not allowed.", imgMessage.INFO, "discountAmtItem");
		}else if (unformatCurrency("discountAmtItem") > (parseFloat($("itemNo").options[$("itemNo").selectedIndex].getAttribute("netPrem")) + unformatCurrency("surchargeAmtItem"))){
			customShowMessageBox("Invalid Discount Amount. Adding of Discount will result to negative Net Premium Amount.", imgMessage.INFO, "discountAmtItem");
		}
	});

	$("surchargeAmtItem").observe("keyup", function () {
		$("surchargeRtItem").value = generateDiscountSurchargeRate("surchargeAmtItem", "premAmtItem");
	});

	$("surchargeAmtItem").observe("click", function () {
		if ($("itemNo").selectedIndex == 0){
			customShowMessageBox("Please select an Item first.", imgMessage.INFO, "itemNo");
		}	
	});

	$("surchargeAmtItem").observe("blur", function () {
		var surchTotal = 0;
		var tsiAmt = $("itemNo").options[$("itemNo").selectedIndex].getAttribute("tsiAmt");
		var netPrem = parseFloat($("itemNo").options[$("itemNo").selectedIndex].getAttribute("netPrem"));
		$$("div[name='rowItem']").each(function (div) {
			if ($F("itemNo") == div.down("input", 1).value){
				surchTotal += parseFloat(div.down("input", 6).value.replace(/,/g, ""));
			}
		});
		surchTotal = surchTotal + ((netPrem + unformatCurrency("surchargeAmtItem")) - unformatCurrency("discountAmtItem"));
		if (unformatCurrency("surchargeAmtItem") > unformatCurrency("premAmtItem")) {
			customShowMessageBox("Surcharge amount greater than the premium amount is not allowed.", imgMessage.INFO, "surchargeAmtItem");
		}else if(surchTotal > tsiAmt){
			customShowMessageBox("Invalid Surcharge Amount. Value should be greater than 0.00 but should not result to a Net Premium Amount greater than TSI Amount.", imgMessage.INFO, "surchargeAmtItem");
		}	
	});
	
	
	$("discountRtItem").observe("keyup", function () {
		$("discountAmtItem").value = generateDiscountSurchargeAmount("discountRtItem", "premAmtItem");
	});

	$("discountRtItem").observe("click", function () {
		if ($("itemNo").selectedIndex == 0){
			customShowMessageBox("Please select an Item first.", imgMessage.INFO, "itemNo");
		}	
	});

	$("surchargeRtItem").observe("keyup", function () {
		$("surchargeAmtItem").value = generateDiscountSurchargeAmount("surchargeRtItem", "premAmtItem");
	});
	
	$("surchargeRtItem").observe("click", function () {
		if ($("itemNo").selectedIndex == 0){
			customShowMessageBox("Please select an Item first.", imgMessage.INFO, "itemNo");
		}	
	});

</script>