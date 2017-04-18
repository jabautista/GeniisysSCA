<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" >
   			<label>Item Discount/Surcharge</label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label name="gro" style="margin-left: 5px;">Hide</label>	   		
   		</span>
   	</div>
</div>

<div class="sectionDiv" id="billItemDiscountDiv">
	<div id="billItemDiscount" style="margin: 10px;">
		<div id="billItemDiscountTable">
			<div style="width: 100%;" id="billItemDiscountTable" style="margin-top: 10px;">
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
			<div style="width: 100%;" class="tableContainer" id="billItemDiscountTableList" style="margin-top: 10px;">
				<jsp:include page="itemDiscountListing.jsp"></jsp:include>
			</div>
		</div>
		<div id="discountForm2">
			<table width="80%" align="center" cellspacing="1" border="0" style="margin-top: 10px;">
	 			<tr>
	 				<td class="rightAligned">Sequence </td>
					<td class="leftAligned">
						<input id="sequenceNoItem" style="width: 100px; margin-right: 20px;" type="text" value="" readonly="readonly" />
						<input id="grossTagItem" type="checkbox" style="width: 10px;" value="" checked="checked"/>
						<label class="rightAligned" style="float: none;">Gross</label> </td>
	 				<td class="rightAligned">Discount Amount </td>
					<td class="leftAligned">
						<input id="paramDiscTotalItem" style="width: 210px;" type="hidden" value="" class="money" />
						<input id="paramSurcTotalItem" style="width: 210px;" type="hidden" value="" class="money" />
						<input id="origPremAmtItem" style="width: 210px;" type="hidden" value="" class="money" />
						<input id="discountAmtItem" style="width: 210px;" type="text" value="" class="money2" maxlength="13" min="0.00" errorMsg="Invalid discount amount. Value should be greater than 0.00 and not greater than the Premium Amount."/></td> 				
				</tr>
				<tr>
					<td class="rightAligned">Premium Amount </td>
					<td class="leftAligned">
						<input id="premAmtItem" style="width: 210px;" type="text" value="" class="money" readonly="readonly" maxlength="14" /></td>
					<td class="rightAligned">Discount Rate </td>
					<td class="leftAligned">
						<input id="discountRtItem" style="width: 210px;" type="text" value="" class="fourDeciRate2" min="0.0000" max="100.0000" errorMsg="Invalid Discount Rate. Valid value should be from 0.0000 to 100.0000"/></td>
				</tr>
				<%-- <tr>
					<td class="rightAligned">Item No. </td>
					<td class="leftAligned">
						<select id="itemNo" name="itemNo" style="width: 218px;" class="required">				
							<option itemTitle="" value="0"/>Select...</option>
							<c:forEach var="billItem" items="${billItems}">
								<option itemTitle="${billItem.itemTitle}" value="${billItem.itemNo}"/>${billItem.itemNo}</option>
							</c:forEach>
						</select>
					</td>
					<td class="rightAligned">Surcharge Amount </td>
					<td class="leftAligned">
						<input id="surchargeAmtItem" style="width: 210px;" type="text" value="" class="money" maxlength="13" min="0.00" errorMsg="Invalid surcharge amount. Value should be greater than 0.00 but not greater than Premium Amount and should not result to a Net Premium Amount greater than TSI Amount."/></td>
				</tr> --%>
				<tr>
					<td class="rightAligned">Item No. </td>
					<td class="leftAligned" style="width: 180px;">						
						<div style="float: left; border: solid 1px gray; width: 216px; height: 21px; margin-right: 3px;" class="required">
							<!-- <input type="hidden" id="vesselCd" name="vesselCd" /> -->
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 186px; border: none;" name="itemNo" id="itemNo" readonly="readonly" class="required" removeStyle="true" />
							<img id="searchItemImg" alt="searchItemImg" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
						</div> 
					</td>
					<td class="rightAligned">Surcharge Amount </td>
					<td class="leftAligned">
						<input id="surchargeAmtItem" style="width: 210px;" type="text" value="" class="money2" maxlength="13" min="0.00" errorMsg="Invalid surcharge amount. Value should be greater than 0.00 but not greater than Premium Amount and should not result to a Net Premium Amount greater than TSI Amount."/></td>
				</tr>
				<tr>
					<td class="rightAligned">Item Title </td>
					<td class="leftAligned">
						<input id="itemTitle" style="width: 210px;" type="text" value="" readonly="readonly" /></td>
					<td class="rightAligned">Surcharge Rate</td>
					<td class="leftAligned">
						<input id="surchargeRtItem" style="width: 210px;" type="text" value="" class="fourDeciRate2" min="0.0000" max="100.0000" errorMsg="Invalid Surcharge Rate. Valid value should be from 0.0000 to 100.0000"/></td>
				</tr>
				<tr>
					<td class="rightAligned">Remarks </td>
					<td class="leftAligned" colspan="3">
						<div style="border: 1px solid gray; height: 20px; width: 583px;">
							<textarea id="remarkItem" name="remarkItem" onKeyDown="limitText(this,4000);" onKeyUp="limitText(this,4000);" style="width: 551px; border: none; height: 13px;"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarksItem" />
						</div>
					</td>				
				</tr>
			</table>
			<div align="center" style="margin-top: 10px;">
				<table>
					<tr>					
						<td><input type="button" class="button" id="btnAddDiscountItem" name="btnAddDiscountItem" value="Add" style="width: 60px;" /></td>
						<td><input type="button" class="disabledButton" id="btnDelDiscountItem" name="btnDelDiscountItem" value="Delete" style="width: 60px;" /></td>
					</tr>
				</table>
			</div>
		</div>
	</div>	
</div>
<script>
	initializeAllMoneyFields();
	observeChangeTagOnDate("editRemarksItem", "remarkItem");
	$("editRemarksItem").observe("click", function () {
		if (objUW.hid2GIPIS143.perilSelected){
			showEditor("remarkItem", 4000,"true");
		}else{
			showEditor("remarkItem", 4000,"false");
		}
	});

	$("itemNo").observe("change", function(){
		$("discountAmtItem").clear();
		$("discountRtItem").clear();
		$("surchargeAmtItem").clear();
		$("surchargeRtItem").clear();
	});	

	$("discountAmtItem").observe("blur", function(){
		var premAmtItemTemp = $("premAmtItem").value == "" ? 0 : $F("premAmtItem").replace(/,/g, "");
		if (parseFloat($F("discountAmtItem").replace(/,/g, "")) > parseFloat(premAmtItemTemp)) {
			backToPreTextValue("discountAmtItem");
			customShowMessageBox("Discount amount greater than the premium amount is not allowed.", imgMessage.ERROR, "discountAmtItem");
			return false;
		} else {
			if (!checkIfValueChanged("discountAmtItem")) return;	
			computeItemDiscRt();

			if ($F("discountAmtItem").replace(/,/g, "") == "" || $F("itemNo") == "0") return;
			createTempItem();

			var validate = validateDiscSurcAmtItem();
			if (validate=="1"){
				backToPreTextValue("discountAmtItem");
				customShowMessageBox("Invalid discount amount. Value should be greater than 0.00 but not greater than Premium Amount and should not result to a Net Premium Amount greater than TSI Amount.", imgMessage.ERROR, "discountAmtItem");
				computeItemDiscRt();
			}else if (validate=="2"){
				backToPreTextValue("discountAmtItem");
				customShowMessageBox("Cannot add discount. Adding of discount will result to a negative Peril/s.", imgMessage.ERROR, "discountAmtItem");
				computeItemDiscRt();
			}		
			$("discountAmtItem").value = formatCurrency($("discountAmtItem").value);  //changed from Number to formatCurrency by robert 11.14.2013 //rdjmanalad 9/7/2012
			$$("div[name='rowItemTempOnly']").each(function(row){
				row.remove();		 
			});
		}
	});

	$("discountRtItem").observe("blur", function(){
		var premAmtItemTemp = $("premAmtItem").value == "" ? 0 : $F("premAmtItem").replace(/,/g, "");
		if (!checkIfValueChanged("discountRtItem")) return;	
		computeItemDiscAmt();
		if (parseFloat($F("discountAmtItem").replace(/,/g, "")) > parseFloat(premAmtItemTemp)) {
			backToPreTextValue("discountRtItem");
			customShowMessageBox("Discount amount greater than the premium amount is not allowed.", imgMessage.ERROR, "discountRtItem");
			return false;
		}else{
			if ($F("discountRtItem").replace(/,/g, "") == "" || $F("itemNo") == "0") return;
			createTempItem();

			var validate = validateDiscSurcAmtItem();
			if (validate=="1"){
				backToPreTextValue("discountRtItem");
				customShowMessageBox("Invalid discount rate. Value should be from 0.0000 to 100.0000 and should not result to a Net  Premium  Amount greater than TSI Amount.", imgMessage.ERROR, "discountRtItem");
				computeItemDiscAmt();
			}else if (validate=="2"){
				backToPreTextValue("discountRtItem");
				customShowMessageBox("Cannot add discount. Adding of discount will result to a negative Peril/s.", imgMessage.ERROR, "discountRtItem");
				computeItemDiscAmt();
			}		
			
			$$("div[name='rowItemTempOnly']").each(function(row){
				row.remove();		 
			});
		}	
	});

	$("surchargeAmtItem").observe("blur", function(){
		var premAmtItemTemp = $("premAmtItem").value == "" ? 0 : $F("premAmtItem").replace(/,/g, "");
		if (parseFloat($F("surchargeAmtItem").replace(/,/g, "")) > parseFloat(premAmtItemTemp)) {
			backToPreTextValue("surchargeAmtItem");
			customShowMessageBox("Surcharge amount greater than the premium amount is not allowed.", imgMessage.ERROR, "surchargeAmtItem");
			return false;
		} else {	
			if (!checkIfValueChanged("surchargeAmtItem")) return;	
			computeItemSurcRt();
			
			if ($F("surchargeAmtItem").replace(/,/g, "") == "" || $F("itemNo") == "0") return;
			createTempItem();

			var validate = validateDiscSurcAmtItem();
			if (validate=="1"){
				backToPreTextValue("surchargeAmtItem");
				customShowMessageBox("Invalid surcharge amount. Value should be greater than 0.00 but not greater than Premium Amount and should not result to a Net Premium Amount greater than TSI Amount.", imgMessage.ERROR, "surchargeAmtItem");
				computeItemSurcRt();
			}else if (validate=="2"){
				backToPreTextValue("surchargeAmtItem");
				customShowMessageBox("Cannot add surcharge. Adding of surcharge will result to a negative Peril/s.", imgMessage.ERROR, "surchargeAmtItem");
				computeItemSurcRt();
			}		
			$("surchargeAmtItem").value = formatCurrency($("surchargeAmtItem").value);  //changed from Number to formatCurrency by robert 11.14.2013 //rdjmanalad 9/7/2012
			$$("div[name='rowItemTempOnly']").each(function(row){
				row.remove();		 
			});
		}
	});

	$("surchargeRtItem").observe("blur", function(){
		var premAmtItemTemp = $("premAmtItem").value == "" ? 0 : $F("premAmtItem").replace(/,/g, "");
		if (!checkIfValueChanged("surchargeRtItem")) return;	
		computeItemSurcAmt();
		
		if (parseFloat($F("surchargeAmtItem").replace(/,/g, "")) > parseFloat(premAmtItemTemp)) {
			backToPreTextValue("surchargeRtItem");
			customShowMessageBox("Surcharge amount greater than the premium amount is not allowed.", imgMessage.ERROR, "surchargeRtItem");
			return false;
		}else{
			if ($F("surchargeRtItem").replace(/,/g, "") == "" || $F("itemNo") == "0") return;
			createTempItem();	

			var validate = validateDiscSurcAmtItem();
			if (validate=="1"){
				backToPreTextValue("surchargeRtItem");
				customShowMessageBox("Invalid surcharge rate. Value should be from 0.0000 to 100.0000 and should not result to a Net  Premium  Amount greater than TSI Amount.", imgMessage.ERROR, "surchargeRtItem");
				computeItemSurcAmt();
			}else if (validate=="2"){
				backToPreTextValue("surchargeRtItem");
				customShowMessageBox("Cannot add surcharge. Adding of surcharge will result to a negative Peril/s.", imgMessage.ERROR, "surchargeRtItem");
				computeItemSurcAmt();
			}	
			
			$$("div[name='rowItemTempOnly']").each(function(row){
				row.remove();		
			});	
		}
	});

	$("grossTagItem").observe("change", function(){
		if ($("itemNo").value > 0) {
			if ($("grossTagItem").checked){
				$("premAmtItem").value = $("origPremAmtItem").value;
				computeItemDiscAmt();
				computeItemSurcAmt();
			}else{ 
				new Ajax.Updater("message", contextPath+"/GIPIParDiscountController?parId="+$("parId").value+"&lineCd="+$("lineCd").value+"&itemNo="+$("itemNo").value+"&action=getNetItemPrem",{
					method: "POST",
					postBody: Form.serialize("billDiscountForm"),
					asynchronous: false,
					evalScripts: true,
					onCreate: function(){
						$("premAmtItem").up("td", 0).update("<span id='refSpan' style='font-size: 9px;'>Refreshing...</span>");
						},
					onComplete: function(response){
						if (checkErrorOnResponse(response)){
							$("refSpan").up("td", 0).update("<input id='premAmtItem' style='width: 210px;' type='text' value='' class='money' readonly='readonly' />");
							var text = response.responseText;
							var arr = text.split(resultMessageDelimiter);
							$("paramDiscTotalItem").value = formatCurrency(arr[0]);
							$("paramSurcTotalItem").value = formatCurrency(arr[1]);
							computeNetPremItemDisc();
						}
					}
				});
			}
		}
	});
	
	function computeItemDiscRt(){
		if (isNaN(parseFloat($F("discountAmtItem").replace(/,/g, "") * 1)) || $F("discountAmtItem")=="" || parseFloat($F("discountAmtItem").replace(/,/g, "") * 1)<0) {$("discountRtItem").clear(); return;}
		$("discountRtItem").value = generateDiscountSurchargeRate("discountAmtItem", "premAmtItem");
	}
	
	function computeItemDiscAmt(){
		if (isNaN(parseFloat($F("discountRtItem").replace(/,/g, "") * 1)) || $F("discountRtItem")=="" || parseFloat($F("discountRtItem").replace(/,/g, "") * 1)<0) {$("discountAmtItem").clear(); return;}
		$("discountAmtItem").value = generateDiscountSurchargeAmount("discountRtItem", "premAmtItem"); 
	}

	function computeItemSurcRt(){
		if (isNaN(parseFloat($F("surchargeAmtItem").replace(/,/g, "") * 1)) || $F("surchargeAmtItem")=="" || parseFloat($F("surchargeAmtItem").replace(/,/g, "") * 1)<0) {$("surchargeRtItem").clear(); return;}
		$("surchargeRtItem").value = generateDiscountSurchargeRate("surchargeAmtItem", "premAmtItem");
	}
	
	function computeItemSurcAmt(){
		if (isNaN(parseFloat($F("surchargeRtItem").replace(/,/g, "") * 1)) || $F("surchargeRtItem")=="" || parseFloat($F("surchargeRtItem").replace(/,/g, "") * 1)<0) {$("surchargeAmtItem").clear(); return;}
		$("surchargeAmtItem").value = generateDiscountSurchargeAmount("surchargeRtItem", "premAmtItem"); 
	}

	function computeNetPremItemDisc(){
		var varDiscTotal = nvl(unformatCurrency("paramDiscTotalItem"),0);
		var varSurcTotal = nvl(unformatCurrency("paramSurcTotalItem"),0);
		var premAmt = 0;
		if (varDiscTotal > 0){
			premAmt = nvl(unformatCurrency("origPremAmtItem"),0) - varDiscTotal;
		} else {
			premAmt = nvl(unformatCurrency("origPremAmtItem"),0);
		}		
		$("premAmtItem").value = formatCurrency(premAmt + varSurcTotal);
		computeItemDiscAmt();
		computeItemSurcAmt();
	}
	
	checkTableIfEmpty("rowItem", "billItemDiscountTable");
	checkIfToResizeTable("billItemDiscountTableList", "rowItem"); 
	
	$("searchItemImg").observe("click", function() {
		showBillItemLOV($("parId").value, onOk);
	});
	
	function initializeItemDiscount() {
		$("discountAmtItem").clear();
		$("discountRtItem").clear();
		$("surchargeAmtItem").clear();
		$("surchargeRtItem").clear();
	}
	
	function onOk(row){
		if(row != undefined){
			$("itemNo").value      = row.itemNo;
			$("itemTitle").value   = row.itemTitle;
			$("premAmtItem").value = formatCurrency(row.premAmt);
			objUW.hid2GIPIS143.checkItemNo();
			initializeItemDiscount();
		}
	};
	
</script>