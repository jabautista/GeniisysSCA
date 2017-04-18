<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<div id="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" >
   		<label>Peril Discount/Surcharge</label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label name="gro" style="margin-left: 5px;">Hide</label>	   		
   		</span>
   	</div>
</div>

<div class="sectionDiv" id="quotePerilDiscountDiv">
	<div id="quotePerilDiscount" style="margin: 10px;">
		<div id="quotePerilDiscountTable1">
			<div style="width: 100%;" id="quotePerilDiscountTable" style="margin-top: 10px;">
				<div style="background-color: #E0E0E0; color: #808080; font-weight: bold; height: 20px; padding-top: 5px;">
					<label style="width: 120px; text-align: center;">Sequence</label>
					<label style="width: 100px; text-align: right;">Prem Amt</label>
					<label style="width: 100px; text-align: center;">Item No.</label>
					<label style="width: 100px; text-align: left;">Peril Name</label>
					<label style="width: 100px; text-align: right;">Disc Amt</label>
			   		<label style="width: 100px; text-align: right;">Disc Rate</label>
			   		<label style="width: 100px; text-align: right;">Surch Amt</label>
			   		<label style="width: 100px; text-align: right;">Surch Rate</label>
					<label style="width: 50px; text-align: center;">G</label>				
				</div>
			</div>
			<div style="width: 100%;" class="tableContainer" id="quotePerilDiscountTableList" style="margin-top: 10px;">
				<jsp:include page="../subPages/perilDiscountListing.jsp"></jsp:include>
			</div>
		</div>
		<div id="discountForm3">
			<table width="80%" align="center" cellspacing="1" border="0" style="margin-top: 10px;">
	 			<tr>
	 				<td class="rightAligned">Sequence </td>
					<td class="leftAligned">
						<input id="sequenceNoPeril" style="width: 100px; margin-right: 20px;" type="text" value="" readonly="readonly" />
						<input id="grossTagPeril" type="checkbox" style="width: 10px;" value="" />
						<label class="rightAligned" style="float:none;">Gross</label></td>
	 				<td class="rightAligned">Discount Amount </td>
					<td class="leftAligned">
						<input id="discountAmtPeril" style="width: 210px;" type="text" value="" class="money discountAmt" /></td> 				
				</tr>
				<tr>
					<td class="rightAligned">Premium Amount </td>
					<td class="leftAligned">
						<input id="premAmtPeril" style="width: 210px;" type="text" value="" class="money" readonly="readonly" /></td>
					<td class="rightAligned">Discount Rate </td>
					<td class="leftAligned">
						<input id="discountRtPeril" style="width: 210px;" type="text" value="" class="discountRt" /></td>
				</tr>
				<tr>
					<td class="rightAligned">Item No. </td>
					<td class="leftAligned">
						<select id="itemNoPeril" name="" style="width: 218px;">
							<option value=""/>Select...</option>
							<c:forEach var="quoteItem" items="${quoteItems}">
								<option currRt="${quoteItem.currencyRate}" value="${quoteItem.itemNo}"/>${quoteItem.itemNo}</option>
							</c:forEach>
						</select></td>
					<td class="rightAligned">Surcharge Amount </td>
					<td class="leftAligned">
						<input id="surchargeAmtPeril" style="width: 210px;" type="text" value="" class="money surchargeAmt" /></td>
				</tr>
				<tr>
					<td class="rightAligned">Peril Name </td>
					<td class="leftAligned">
						<select id="perilCodeSelect0" name="perilCodeSelect" style="width: 218px;">
							<option value="">Select...</option>
						</select>
						<c:forEach var="quoteItem" items="${quoteItems}">
							<select id="perilCodeSelect${quoteItem.itemNo}" name="perilCodeSelect" style="width: 218px;">
							<option value="">Select...</option>
							<c:forEach var="quotePeril" items="${quotePerils}">
								<c:if test="${quotePeril.itemNo eq quoteItem.itemNo}">
									<option value="${quotePeril.perilCd}" >${quotePeril.perilName}</option>
								</c:if>
							</c:forEach>
							</select>			
						</c:forEach>
					</td>
					<td class="rightAligned">Surcharge Rate </td>
					<td class="leftAligned">
						<input id="surchargeRtPeril" style="width: 210px;" type="text" value="" class="surchargeRt" /></td>
				</tr>
				<tr>
					<td class="rightAligned">Remarks </td>
					<td class="leftAligned" colspan="3">
						<div style="border: 1px solid gray; height: 20px; width: 583px;">
							<textarea id="remarkPeril" style="width: 551px; border: none; height: 13px;"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks2" />
						</div>
					</td>				
				</tr>
			</table>
			<c:forEach var="quoteItem" items="${quoteItems}">
				<select id="perilPremAmtSelect${quoteItem.itemNo}" name="perilPremAmtSelect" style="width: 218px; display: none;">
					<option value="">Select...</option>
				<c:forEach var="quotePeril" items="${quotePerils}">
					<c:if test="${quotePeril.itemNo eq quoteItem.itemNo}">
						<option annPremAmt="${quotePeril.annPremAmt}" netPrem="${quotePeril.premiumAmount}" itemNo="${quotePeril.itemNo}" perilCd="${quotePeril.perilCd}" tsiAmt="${quotePeril.tsiAmount}" value="${quotePeril.premiumAmount}" >${quotePeril.premiumAmount}</option>
					</c:if>
				</c:forEach>
				</select>			
			</c:forEach>
			<c:forEach var="quoteItem" items="${quoteItems}">
				<select id="perilAnnPremAmtSelect${quoteItem.itemNo}" name="perilAnnPremAmtSelect" style="width: 218px; display: none;">
					<option value="">Select...</option>
				<c:forEach var="quotePeril" items="${quotePerils}">
					<c:if test="${quotePeril.itemNo eq quoteItem.itemNo}">
						<option value="${quotePeril.annPremAmt}" >${quotePeril.annPremAmt}</option>
					</c:if>
				</c:forEach>
				</select>			
			</c:forEach>	
			<c:forEach var="quotePeril" items="${quotePerils}">
				<div id="hiddenPerilDiv${quotePeril.itemNo}${quotePeril.perilCd}" name="hiddenPerilDiv" style="display: none;">
					<input type="hidden" id="hiddenItemNo" name="hiddenPerilItemNo" value="${quotePeril.itemNo}">
					<input type="hidden" id="hiddenPerilCd" name="hiddenPerilCd" value="${quotePeril.perilCd}">
					<input type="hidden" id="hiddenOrigPremAmt" name="hiddenOrigPremAmt" value="${quotePeril.annPremAmt}">
					<input type="hidden" id="hiddenPremAmt" name="hiddenPremAmt" value="${quotePeril.premiumAmount}">
					<input type="hidden" id="hiddenPremRt" name="hiddenPremRt" value="${quotePeril.premiumRate}">
				</div>
		    </c:forEach>		
			<input type="hidden" id="origPerilDiscountAmt" name="origPerilDiscountAmt" value="">
			<input type="hidden" id="origPerilSurchargeAmt" name="origPerilDiscountAmt" value="">
			<div align="center" style="margin-top: 10px;">
				<table>
					<tr>
						<td><input type="button" class="button" id="btnAddDiscountPeril" name="btnAddDiscountPeril" value="Add" style="width: 60px;"/></td>
						<!-- <td><input type="button" class="button" id="btnEditDiscountPeril" name="btnEditDiscountPeril" value="Edit Discount/Surcharge" style="display:none"/></td> -->
						<td><input type="button" class="disabledButton" id="btnDelDiscountPeril" name="btnDelDiscountPeril" value="Delete" style="width: 60px;" /></td>
					</tr>
				</table>
			</div>
		</div>
	</div>	
</div>
<script>
	checkTableIfEmpty("rowPeril", "quotePerilDiscountTable");
/*
	$$("div[name='rowPeril']").each(function(bas){
		bas.observe("click", function(){
			showMessageBox("testasdfasf", imgMessage.ERROR);
			if(hasSelectedRow("rowPeril") == false){
				$("grossTagPeril").checked = true;
*/
	$("grossTagPeril").observe("click", function () {
		if ($("perilAnnPremAmtSelect"+ $("itemNoPeril").value) != null){
			if ($("grossTagPeril").checked){
				$("premAmtPeril").value = formatCurrency($("perilAnnPremAmtSelect"+ $("itemNoPeril").value).value);
				$("discountAmtPeril").value = formatCurrency($F("origPerilDiscountAmt"));
			} else{
				$("origPerilDiscountAmt").value = $("discountAmtPeril").value;
				$("premAmtPeril").value = formatCurrency($("perilPremAmtSelect"+ $("itemNoPeril").value).value);
				$("discountAmtPeril").value = generateDiscountSurchargeAmount("discountRtPeril", "premAmtPeril");
				$("surchargeAmtPeril").value = generateDiscountSurchargeAmount("surchargeRtPeril", "premAmtPeril");
			}
		}
	});
	
	$("discountAmtPeril").observe("keyup", function () {
		$("discountRtPeril").value = generateDiscountSurchargeRate("discountAmtPeril", "premAmtPeril");
	});

	$("discountAmtPeril").observe("click", function () {
		if ($("itemNoPeril").selectedIndex == 0 || $("perilPremAmtSelect"+ $("itemNoPeril").value).selectedIndex == 0){
			customShowMessageBox("Please select an Item and Peril Name first.", imgMessage.INFO, "itemNoPeril");
		}	
	});
	
	$("discountAmtPeril").observe("blur", function () {
		if (unformatCurrency("discountAmtPeril") > (parseFloat($("perilPremAmtSelect"+ $("itemNoPeril").value).value) + unformatCurrency("surchargeAmtPeril"))){
			customShowMessageBox("Invalid Discount Amount. Adding of Discount will result to negative Net Premium Amount.", imgMessage.INFO, "discountAmtPeril");
		}	
	});

	$("surchargeAmtPeril").observe("keyup", function () {
		$("surchargeRtPeril").value = generateDiscountSurchargeRate("surchargeAmtPeril", "premAmtPeril");
	});

	$("surchargeAmtPeril").observe("click", function () {
		if ($("itemNoPeril").selectedIndex == 0 || $("perilPremAmtSelect"+ $("itemNoPeril").value).selectedIndex == 0){
			customShowMessageBox("Please select an Item and Peril Name first.", imgMessage.INFO, "itemNoPeril");
		}
	});
	$("surchargeAmtPeril").observe("blur", function () {
		var surchTotal = 0;
		var tsiAmt = parseFloat($("perilPremAmtSelect"+ $("itemNoPeril").value).options[$("perilPremAmtSelect"+ $("itemNoPeril").value).selectedIndex].getAttribute("tsiAmt"));
		var perilCd = $("perilPremAmtSelect"+ $F("itemNoPeril")).options[$("perilPremAmtSelect"+ $("itemNoPeril").value).selectedIndex].getAttribute("perilCd");
		var netPrem = parseFloat($("perilPremAmtSelect"+ $F("itemNoPeril")).options[$("perilPremAmtSelect"+ $("itemNoPeril").value).selectedIndex].getAttribute("netPrem"));
		$$("div[name='rowPeril']").each(function (div) {
			if (perilCd == div.down("input", 2).value && $F("itemNoPeril") == div.down("input", 1).value){
				surchTotal += parseFloat(div.down("input", 6).value);
			}
		});
		surchTotal = surchTotal + ((netPrem + unformatCurrency("surchargeAmtPeril")) - unformatCurrency("discountAmtPeril"));
		if(surchTotal > tsiAmt){
			customShowMessageBox("Invalid Surcharge Amount. Value should be greater than 0.00 but should not result to a Net Premium Amount greater than TSI Amount.", imgMessage.INFO, "surchargeAmtPeril");
		}	
	});

	$("discountRtPeril").observe("keyup", function () {
		$("discountAmtPeril").value = generateDiscountSurchargeAmount("discountRtPeril", "premAmtPeril");
	});

	$("discountRtPeril").observe("click", function () {
		if ($("itemNoPeril").selectedIndex == 0 || $("perilPremAmtSelect"+ $("itemNoPeril").value).selectedIndex == 0){
			customShowMessageBox("Please select an Item and Peril Name first.", imgMessage.INFO, "itemNoPeril");
		}	
	});

	$("surchargeRtPeril").observe("keyup", function () {
		$("surchargeAmtPeril").value = generateDiscountSurchargeAmount("surchargeRtPeril", "premAmtPeril");
	});

	$("surchargeRtPeril").observe("click", function () {
		if ($("itemNoPeril").selectedIndex == 0 || $("perilPremAmtSelect"+ $("itemNoPeril").value).selectedIndex == 0){
			customShowMessageBox("Please select an Item and Peril Name first.", imgMessage.INFO, "itemNoPeril");
		}	
	});
	
	$("itemNoPeril").observe("click", function () {
		if ("" != $F("itemNoPeril")){
			$("perilPremAmtSelect"+ $("itemNoPeril").value).selectedIndex = 0;
			$("perilCodeSelect"+$("itemNoPeril").value).selectedIndex = 0;
			$("premAmtPeril").value = formatCurrency(0);
		}
	});

	$("itemNoPeril").observe("change", function () {
		resetFields();
		$("perilCodeSelect"+$("itemNoPeril").value).observe("change", function() {
			resetFields();
		});
	});
	

	function resetFields(){
		$("surchargeRtPeril").value = formatRate(0);
		$("surchargeAmtPeril").value = formatCurrency(0);
		$("discountAmtPeril").value = formatCurrency(0);
		$("discountRtPeril").value = formatRate(0);
		$("grossTagPeril").checked = true;
	}

</script>
