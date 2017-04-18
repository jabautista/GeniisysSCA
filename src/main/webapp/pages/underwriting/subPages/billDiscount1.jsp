<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" >
   		<label>Policy Discount/Surcharge</label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label name="gro" style="margin-left: 5px;">Hide</label>	   		
   		</span>
   	</div>
</div>

<div class="sectionDiv" id="billPolicyDiscountDiv">
	<div id="billPolicyDiscount" style="margin: 10px;">
		<div id="billPolicyBasicDiscountTable">
			<div style="width: 100%;" id="billPolicyBasicDiscountTableHeader" style="margin-top: 10px;">
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
			<div style="width: 100%;" id="billPolicyBasicDiscountTableList" class="tableContainer" style="margin-top: 10px;">
				<jsp:include page="basicDiscountListing.jsp"></jsp:include>
			</div>
		</div>
		<div id="discountForm1">
			<table width="80%" align="center" cellspacing="1" border="0" style="margin-top: 10px;">
	 			<tr>
	 				<td class="rightAligned">Sequence </td>
					<td class="leftAligned">
						<input id="sequenceNo" style="width: 100px; margin-right: 20px;" type="text" value="" readonly="readonly"/>
						<input id="grossTag" type="checkbox" style="width: 10px;" value="" checked="checked"/>
						<label class="rightAligned" style="float: none;">Gross</label>
					</td>			
				</tr>
				<tr>
					<td class="rightAligned">Premium Amount </td>
					<td class="leftAligned">
						<input id="paramPremAmt" 	 name="paramPremAmt" 	 type="hidden" value="${netPremAmt }"  style="width: 210px;" class="money" maxlength="14" />
						<input id="paramOrigPremAmt" name="paramOrigPremAmt" type="hidden" value="${origPremAmt }" style="width: 210px;" class="money" />
						<input id="paramDiscTotal" 	 name="paramDiscTotal" 	 type="hidden" value="${discTotal }" />
						<input id="paramSurcTotal" 	 name="paramSurcTotal" 	 type="hidden" value="${surcTotal }" />
						<input id="premAmt" style="width: 210px;" type="text" value="${netPremAmt }" class="money" readonly="readonly" maxlength="14"/></td>
				</tr>
				<tr>
					<td class="rightAligned">Discount Amount </td>
					<td class="leftAligned">
						<input id="discountAmt" style="width: 210px;" type="text" value="" class="money2" maxlength="13" min="0.00" errorMsg="Invalid discount amount. Value should be greater than 0.00 and not greater than the Premium Amount."/></td>
					<td class="rightAligned">Surcharge Amount </td>
					<td class="leftAligned">
						<input id="surchargeAmt" style="width: 210px;" type="text" value="" class="money2" maxlength="13" min="0.00" errorMsg="Invalid surcharge amount. Value should be greater than 0.00 but not greater than Premium Amount and should not result to a Net Premium Amount greater than TSI Amount."/></td>
				</tr>
				<tr>
					<td class="rightAligned">Discount Rate </td>
					<td class="leftAligned">
						<input id="discountRt" style="width: 210px;" type="text" value="" class="fourDeciRate2" min="0.0000" max="100.0000" errorMsg= "Invalid Discount Rate. Valid value should be from 0.0000 to 100.0000"/></td>
					<td class="rightAligned">Surcharge Rate </td>
					<td class="leftAligned">
						<input id="surchargeRt" style="width: 210px;" type="text" value="" class="fourDeciRate2" min="0.0000" max="100.0000" errorMsg="Invalid Surcharge Rate. Valid value should be from 0.0000 to 100.0000"/></td>
				</tr>
				<tr>
					<td class="rightAligned">Remarks </td>
					<td class="leftAligned" colspan="3">
						<div style="border: 1px solid gray; height: 20px; width: 583px;">
							<textarea id="remark" name="remark" onKeyDown="limitText(this,4000);" onKeyUp="limitText(this,4000);" style="width: 551px; border: none; height: 13px;"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" />
						</div>
				</tr>
			</table>
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
	initializeAllMoneyFields();
	observeChangeTagOnDate("editRemarks", "remark");
	$("editRemarks").observe("click", function () {
		if (objUW.hid3GIPIS143.perilSelected){
			showEditor("remark", 4000,"true");
		}else{
			showEditor("remark", 4000,"false");
		}
	});

	$("discountAmt").observe("blur", function(){
		if (unformatCurrency("discountAmt") > unformatCurrency("premAmt")) {
			backToPreTextValue("discountAmt");
			customShowMessageBox("Discount amount greater than the premium amount is not allowed.", imgMessage.ERROR, "discountAmt");
			return false;
		} else {
			if (!checkIfValueChanged("discountAmt")) return;	
			computeDiscRt();

			if ($F("discountAmt").replace(/,/g, "") == "") return;
			createTempBasic();

			var validate = validateSurchargeAmt();
			if (validate=="1"){
				backToPreTextValue("discountAmt");
				customShowMessageBox("Invalid discount amount. Value should be greater than 0.00 but not greater than Premium Amount and should not result to a Net Premium Amount greater than TSI Amount.", imgMessage.ERROR, "discountAmt");
				computeDiscRt();
			}else if (validate=="2"){
				backToPreTextValue("discountAmt");
				customShowMessageBox("Cannot add discount. Adding of discount will result to a negative Peril/s.", imgMessage.ERROR, "discountAmt");
				computeDiscRt();
			}		
			$("discountAmt").value = formatCurrency($("discountAmt").value); //changed from Number to formatCurrency by robert 11.14.2013
			$$("div[name='rowBasicTempOnly']").each(function(row){
				row.remove();
			});
		}
	});

	$("discountRt").observe("blur", function(){
		if (!checkIfValueChanged("discountRt")) return;
		computeDiscAmt();
		
		if (unformatCurrency("discountAmt") > unformatCurrency("premAmt")) {
			backToPreTextValue("discountRt");
			customShowMessageBox("Discount amount greater than the premium amount is not allowed.", imgMessage.ERROR, "discountRt");
			return false;
		}else{
			if ($F("discountRt").replace(/,/g, "") == "") return;
			createTempBasic();

			var validate = validateSurchargeAmt();
			if (validate=="1"){
				backToPreTextValue("discountRt");
				customShowMessageBox("Invalid discount rate. Value should be from 0.0000 to 100.0000 and should not result to a Net  Premium  Amount greater than TSI Amount.", imgMessage.ERROR, "discountRt");
				computeDiscAmt();
			}else if (validate=="2"){
				backToPreTextValue("discountRt");
				customShowMessageBox("Cannot add discount. Adding of discount will result to a negative Peril/s.", imgMessage.ERROR, "discountRt");
				computeDiscAmt();
			}		
			
			$$("div[name='rowBasicTempOnly']").each(function(row){
				row.remove();		 
			});
		}	
	});

	$("surchargeAmt").observe("blur", function(){
		if (parseFloat($F("surchargeAmt").replace(/,/g, "")) > parseFloat($F("premAmt").replace(/,/g, ""))) {
			backToPreTextValue("surchargeAmt");
			customShowMessageBox("Surcharge amount greater than the premium amount is not allowed.", imgMessage.ERROR, "surchargeAmt");
			return false;
		}else{
			if (!checkIfValueChanged("surchargeAmt")) return;
			computeSurcRt();
			
			if ($F("surchargeAmt").replace(/,/g, "") == "") return;
			createTempBasic();

			var validate = validateSurchargeAmt();
			if (validate=="1"){
				backToPreTextValue("surchargeAmt");
				customShowMessageBox("Invalid surcharge amount. Value should be greater than 0.00 but not greater than Premium Amount and should not result to a Net Premium Amount greater than TSI Amount.", imgMessage.ERROR, "surchargeAmt");
				computeSurcRt();
			}else if (validate=="2"){
				backToPreTextValue("surchargeAmt");
				customShowMessageBox("Cannot add surcharge. Adding of surcharge will result to a negative Peril/s.", imgMessage.ERROR, "surchargeAmt");
				computeSurcRt();
			}		
			$("surchargeAmt").value = formatCurrency($("surchargeAmt").value); //changed from Number to formatCurrency by robert 11.14.2013
			$$("div[name='rowBasicTempOnly']").each(function(row){
				row.remove();		
			});
		}	
	});

	$("surchargeRt").observe("blur", function(){
		if (!checkIfValueChanged("surchargeRt")) return;
		computeSurcAmt();
		
		if (parseFloat($F("surchargeAmt").replace(/,/g, "")) > parseFloat($F("premAmt").replace(/,/g, ""))) {
			backToPreTextValue("surchargeRt");
			customShowMessageBox("Surcharge amount greater than the premium amount is not allowed.", imgMessage.ERROR, "surchargeRt");
			return false;
		}else{
			if ($F("surchargeRt").replace(/,/g, "") == "") return;
			createTempBasic();	 

			var validate = validateSurchargeAmt();
			if (validate=="1"){
				backToPreTextValue("surchargeRt");
				customShowMessageBox("Invalid surcharge rate. Value should be from 0.0000 to 100.0000 and should not result to a Net  Premium  Amount greater than TSI Amount.", imgMessage.ERROR, "surchargeRt");
				computeSurcAmt();
			}else if (validate=="2"){
				backToPreTextValue("surchargeRt");
				customShowMessageBox("Cannot add surcharge. Adding of surcharge will result to a negative Peril/s.", imgMessage.ERROR, "surchargeRt");
				computeSurcAmt();
			}	
			
			$$("div[name='rowBasicTempOnly']").each(function(row){
				row.remove();		
			});	
		}
	});

	$("grossTag").observe("change", function(){
		if ($("grossTag").checked){
			$("premAmt").value = $("paramOrigPremAmt").value;
		} else {
			$("premAmt").value = formatCurrency(computeNetPremPolDisc());
		}
		computeDiscAmt();
		computeSurcAmt();
	});
	
	function computeDiscAmt(){
		if (isNaN(parseFloat($F("discountRt").replace(/,/g, "") * 1)) || $F("discountRt")=="" || parseFloat($F("discountRt").replace(/,/g, "") * 1)<0) {$("discountAmt").clear(); return;}
		$("discountAmt").value = generateDiscountSurchargeAmount("discountRt", "premAmt"); 
	}	

	function computeSurcAmt(){
		if (isNaN(parseFloat($F("surchargeRt").replace(/,/g, "") * 1)) || $F("surchargeRt")=="" || parseFloat($F("surchargeRt").replace(/,/g, "") * 1)<0) {$("surchargeAmt").clear(); return;}
		$("surchargeAmt").value = generateDiscountSurchargeAmount("surchargeRt", "premAmt"); 
	}	

	function computeDiscRt(){
		if (isNaN(parseFloat($F("discountAmt").replace(/,/g, "") * 1)) || $F("discountAmt")=="" || parseFloat($F("discountAmt").replace(/,/g, "") * 1)<0) {$("discountRt").clear(); return;}
		$("discountRt").value = generateDiscountSurchargeRate("discountAmt", "premAmt");
	}	

	function computeSurcRt(){
		if (isNaN(parseFloat($F("surchargeAmt").replace(/,/g, "") * 1)) || $F("surchargeAmt")=="" || parseFloat($F("surchargeAmt").replace(/,/g, "") * 1)<0) {$("surchargeRt").clear(); return;}
		$("surchargeRt").value = generateDiscountSurchargeRate("surchargeAmt", "premAmt");
	}

	changeCheckImageColor();
</script>