<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" >
   		<label>Peril Discount/Surcharge</label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label name="gro" style="margin-left: 5px;">Hide</label>	   		
   		</span>
   	</div>
</div>

<div class="sectionDiv" id="billPerilDiscountDiv">
	<div id="billPerilDiscount" style="margin: 10px;">
		<div id="billPerilDiscountTable">
			<div style="width: 100%;" id="billPerilDiscountTable" style="margin-top: 10px;">
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
			<div style="width: 100%;" class="tableContainer" id="billPerilDiscountTableList" style="margin-top: 10px;">
				<jsp:include page="perilDiscountListing.jsp"></jsp:include>
			</div>
		</div>
		<div id="discountForm3">
			<table width="80%" align="center" cellspacing="1" border="0" style="margin-top: 10px;">
	 			<tr>
	 				<td class="rightAligned">Sequence </td>
					<td class="leftAligned">
						<input id="sequenceNoPeril" style="width: 100px; margin-right: 20px;" type="text" value="" readonly="readonly" />
						<input id="grossTagPeril" type="checkbox" style="width: 10px;" value="" checked="checked"/>
						<label class="rightAligned" style="float:none;">Gross</label></td>
	 				<td class="rightAligned">Discount Amount </td>
					<td class="leftAligned">
						<input id="paramOrigPerilPremAmt" style="width: 210px;" type="hidden" value="" class="money"/>		
						<input id="origPerilAnnPremAmt" style="width: 210px;" type="hidden" value="" class="money"/>				
						<input id="origItemAnnPremAmt" style="width: 210px;" type="hidden" value="" class="money"/>				
						<input id="origPolAnnPremAmt" style="width: 210px;" type="hidden" value="" class="money"/>			
						<input id="paramDiscTotalPeril" style="width: 210px;" type="hidden" value="" class="money"/>	
						<input id="paramSurcTotalPeril" style="width: 210px;" type="hidden" value="" class="money"/>				
						<input id="discountAmtPeril" style="width: 210px;" type="text" value="" class="money2" maxlength="13" min="0.00" errorMsg="Invalid discount amount. Valid value should be greater than 0.00 and not greater than the Premium Amount."/></td> 
				</tr>
				<tr>
					<td class="rightAligned">Premium Amount </td>
					<td class="leftAligned">
						<input id="premAmtPeril" style="width: 210px;" type="text" value="" class="money" readonly="readonly" maxlength="14" /></td>
					<td class="rightAligned">Discount Rate </td>
					<td class="leftAligned">
						<input id="discountRtPeril" style="width: 210px;" type="text" value="0.0000" class="fourDeciRate2" min="0.0000" max="100.0000" errorMsg="Invalid Discount Rate. Valid value should be from 0.0000 to 100.0000"/></td>
				</tr>
				<tr>
					<td class="rightAligned">Item No. </td>
					<td class="leftAligned">
						<div style="float: left; border: solid 1px gray; width: 216px; height: 21px; margin-right: 3px;" class="required">
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 186px; border: none;" name="itemNoPeril" id="itemNoPeril" readonly="readonly" class="required" removeStyle="true" />
							<img id="searchItemImgPeril" alt="searchItemImgPeril" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
						</div> 
					<%-- 	<select id="itemNoPeril" name="itemNoPeril" style="width: 218px;" class="required">
							<option value="0"/>Select...</option>
							<c:forEach var="billItem" items="${billItems}">
								<option value="${billItem.itemNo}" itemTitle="${billItem.itemTitle}"/>${billItem.itemNo}</option> change by steven from:${billItem.itemTitle}	to:${billItem.itemNo}
							</c:forEach>
						</select> --%>
					</td>
<!-- 					 *note: have to revert this part because of the error in getting lov for peril code.
								this LOV is working.. just have to revert to complete getting lov for peril code.
-->
					            
					<%-- <td class="leftAligned" style="width: 180px;">						
						<div style="float: left; border: solid 1px gray; width: 216px; height: 21px; margin-right: 3px;" class="required">
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 186px; border: none;" name="itemNoPeril" id="itemNoPeril" readonly="readonly" class="required" />
							<img id="searchItemImgPeril" alt="searchItemImgPeril" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
						</div> 
					</td> --%>
					<td class="rightAligned">Surcharge Amount </td>
					<td class="leftAligned">
						<input id="surchargeAmtPeril" style="width: 210px;" type="text" value="" class="money2" maxlength="13" min="0.00" errorMsg="Invalid surcharge amount. Value should be greater than 0.00 but not greater than Premium Amount and should not result to a Net Premium Amount greater than TSI Amount."/></td>
				</tr>
				<tr>
					<td class="rightAligned">Peril Name </td>
					<td class="leftAligned">
						<div style="float: left; border: solid 1px gray; width: 216px; height: 21px; margin-right: 3px;" class="required">
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 186px; border: none;" name="itemPeril" id="itemPeril" readonly="readonly" class="required" perilCond="input" removeStyle="true" />
							<input type="hidden" id="itemPerilCd" name="itemPerilCd"/>
							<img id="searchItemImgPerilDisc" alt="searchItemImgPerilDisc" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
						</div>
						
						<%-- <span id='refSpanItemPeril' style='font-size:9px; display:none;'>Refreshing...</span>
						<select id="itemPeril" name="itemPeril" style="width: 218px;display:block;" class="required">
							<option value="0"/>Select...</option>
							<c:forEach var="perils" items="${perilListing}">
								<option itemNo="${perils.itemNo}" value="${perils.perilCd}" premAmt="${perils.premAmt}">${perils.perilName}</option>				
							</c:forEach>
						</select> --%>
					</td>
					<%--   *note: have to revert this part because of the error generated with perilDiscountListing.
					              the LOV is ok. but since the codes of the main page is for dropdown this code have issues.
					               
					<td class="leftAligned" style="width: 180px;">						
						<div style="float: left; border: solid 1px gray; width: 216px; height: 21px; margin-right: 3px;" class="required">
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 186px; border: none;" name="itemPeril" id="itemPeril" readonly="readonly" class="required" />
							<img id="searchItemImgPerilDisc" alt="searchItemImgPerilDisc" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
						</div> 
					</td> --%>
					<td class="rightAligned">Surcharge Rate </td>
					<td class="leftAligned">
						<input id="surchargeRtPeril" style="width: 210px;" type="text" value="" class="fourDeciRate2" min="0.0000" max="100.0000" errorMsg="Invalid Surcharge Rate. Valid value should be from 0.0000 to 100.0000"/></td>
				</tr>
				<tr>
					<td class="rightAligned">Remarks </td>
					<td class="leftAligned" colspan="3">
						<div style="border: 1px solid gray; height: 20px; width: 583px;">
							<textarea id="remarkPeril" name="remarkPeril" onKeyDown="limitText(this,4000);" onKeyUp="limitText(this,4000);" style="width: 551px; border: none; height: 13px;"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarksPeril" />
						</div>
					</td>				
				</tr>
			</table>
			<div align="center" style="margin-top: 10px;">
				<table>
					<tr>
						<td><input type="button" class="button" id="btnAddDiscountPeril" name="btnAddDiscountPeril" value="Add" style="width: 60px;"/></td>
						<td><input type="button" class="disabledButton" id="btnDelDiscountPeril" name="btnDelDiscountPeril" value="Delete" style="width: 60px;" /></td>
					</tr>
				</table>
			</div>
		</div>
	</div>	
</div>
<script>
	initializeAllMoneyFields();
	observeChangeTagOnDate("editRemarksPeril", "remarkPeril");
	$("editRemarksPeril").observe("click", function () {
		if (objUW.hidGIPIS143.perilSelected){
			showEditor("remarkPeril", 4000,"true");
		}else{
			showEditor("remarkPeril", 4000,"false");
		}
	});

	$("discountAmtPeril").observe("blur", function(){
		var premAmtPerilTemp = $("premAmtPeril").value == "" ? 0 : $F("premAmtPeril").replace(/,/g, "");
		if (parseFloat($F("discountAmtPeril").replace(/,/g, "")) > parseFloat(premAmtPerilTemp)) {
			backToPreTextValue("discountAmtPeril");
			customShowMessageBox("Discount amount greater than the premium amount is not allowed.", imgMessage.ERROR, "discountAmtPeril");
			return false;
		} else {	
			if (!checkIfValueChanged("discountAmtPeril")) return;	
			computePerilDiscRt();

			if ($F("discountAmtPeril").replace(/,/g, "") == "" || $F("itemNoPeril") == "0" || $F("itemPerilCd") == "0") return;
			createTempPeril();

			var validate = validateDiscSurcAmtPeril();
			if (validate=="1"){
				backToPreTextValue("discountAmtPeril");
				customShowMessageBox("Invalid discount amount. Value should be greater than 0.00 but not greater than Premium Amount and should not result to a Net Premium Amount greater than TSI Amount.", imgMessage.ERROR, "discountAmtPeril");
				computePerilDiscRt();
			}else if (validate=="2"){
				backToPreTextValue("discountAmtPeril");
				customShowMessageBox("Cannot add discount. Adding of discount will result to a negative Peril/s.", imgMessage.ERROR, "discountAmtPeril");
				computePerilDiscRt();
			}		
			$("discountAmtPeril").value = formatCurrency($("discountAmtPeril").value); //changed from Number to formatCurrency by robert 11.14.2013 //rdjmanalad 9/7/2012
			$$("div[name='rowPerilTempOnly']").each(function(row){
				row.remove();		 
			});
		}
	});

	$("discountRtPeril").observe("blur", function(){
		var premAmtPerilTemp = $("premAmtPeril").value == "" ? 0 : $F("premAmtPeril").replace(/,/g, "");
		if (!checkIfValueChanged("discountRtPeril")) return;	
		computePerilDiscAmt();
		if (parseFloat($F("discountAmtPeril").replace(/,/g, "")) > parseFloat(premAmtPerilTemp)) {
			backToPreTextValue("discountRtPeril");
			customShowMessageBox("Discount amount greater than the premium amount is not allowed.", imgMessage.ERROR, "discountRtPeril");
			return false;
		}else{
			if ($F("discountRtPeril").replace(/,/g, "") == "" || $F("itemNoPeril") == "0" || $F("itemPerilCd") == "0") return;
			createTempPeril();

			var validate = validateDiscSurcAmtPeril();
			if (validate=="1"){
				backToPreTextValue("discountRtPeril");
				customShowMessageBox("Invalid discount rate. Value should be from 0.0000 to 100.0000 and should not result to a Net  Premium  Amount greater than TSI Amount.", imgMessage.ERROR, "discountRtPeril");
				computePerilDiscAmt();
			}else if (validate=="2"){
				backToPreTextValue("discountRtPeril");
				customShowMessageBox("Cannot add discount. Adding of discount will result to a negative Peril/s.", imgMessage.ERROR, "discountRtPeril");
				computePerilDiscAmt();
			}		
			
			$$("div[name='rowPerilTempOnly']").each(function(row){
				row.remove();		 
			});
		}	
	});

	$("surchargeAmtPeril").observe("blur", function(){
		var premAmtPerilTemp = $("premAmtPeril").value == "" ? 0 : $F("premAmtPeril").replace(/,/g, "");
		if (parseFloat($F("surchargeAmtPeril").replace(/,/g, "")) > parseFloat(premAmtPerilTemp)) {
			backToPreTextValue("surchargeAmtPeril");
			customShowMessageBox("Surcharge amount greater than the premium amount is not allowed.", imgMessage.ERROR, "surchargeAmtPeril");
			return false;
		} else {	
			if (!checkIfValueChanged("surchargeAmtPeril")) return;	
			computePerilSurcRt();
			
			if ($F("surchargeAmtPeril").replace(/,/g, "") == "" || $F("itemNoPeril") == "0" || $F("itemPerilCd") == "0") return;
			createTempPeril();

			var validate = validateDiscSurcAmtPeril();
			if (validate=="1"){
				backToPreTextValue("surchargeAmtPeril");
				customShowMessageBox("Invalid surcharge amount. Value should be greater than 0.00 but not greater than Premium Amount and should not result to a Net Premium Amount greater than TSI Amount.", imgMessage.ERROR, "surchargeAmtPeril");
				computePerilSurcRt();
			}else if (validate=="2"){
				backToPreTextValue("surchargeAmtPeril");
				customShowMessageBox("Cannot add surcharge. Adding of surcharge will result to a negative Peril/s.", imgMessage.ERROR, "surchargeAmtPeril");
				computePerilSurcRt();
			}		
			$("surchargeAmtPeril").value = formatCurrency($("surchargeAmtPeril").value); //changed from Number to formatCurrency by robert 11.14.2013 //rdjmanalad 9/7/2012
			$$("div[name='rowPerilTempOnly']").each(function(row){
				row.remove();		 
			});
		}
	});

	$("surchargeRtPeril").observe("blur", function(){
		var premAmtPerilTemp = $("premAmtPeril").value == "" ? 0 : $F("premAmtPeril").replace(/,/g, "");
		if (!checkIfValueChanged("surchargeRtPeril")) return;	
		computePerilSurcAmt();
		if (parseFloat($F("surchargeAmtPeril").replace(/,/g, "")) > parseFloat(premAmtPerilTemp)) {
			backToPreTextValue("surchargeRtPeril");
			customShowMessageBox("Surcharge amount greater than the premium amount is not allowed.", imgMessage.ERROR, "surchargeRtPeril");
			return false;
		}else{
			if ($F("surchargeRtPeril").replace(/,/g, "") == "" || $F("itemNoPeril") == "0" || $F("itemPerilCd") == "0") return;
			createTempPeril();	

			var validate = validateDiscSurcAmtPeril();
			if (validate=="1"){
				backToPreTextValue("surchargeRtPeril");
				customShowMessageBox("Invalid surcharge rate. Value should be from 0.0000 to 100.0000 and should not result to a Net  Premium  Amount greater than TSI Amount.", imgMessage.ERROR, "surchargeRtPeril");
				computePerilSurcAmt();
			}else if (validate=="2"){
				backToPreTextValue("surchargeRtPeril");
				customShowMessageBox("Cannot add surcharge. Adding of surcharge will result to a negative Peril/s.", imgMessage.ERROR, "surchargeRtPeril");
				computePerilSurcAmt();
			}	
			
			$$("div[name='rowPerilTempOnly']").each(function(row){
				row.remove();		
			});	
		}
	});

	$("grossTagPeril").observe("change", function(){
		if (($("itemNoPeril").value > 0) && ($("itemPerilCd").value > 0)){
			if ($("grossTagPeril").checked){
				$("premAmtPeril").value = $("paramOrigPerilPremAmt").value;
				computePerilDiscAmt();
				computePerilSurcAmt();
			}else{
				new Ajax.Updater("message", contextPath+"/GIPIParDiscountController?parId="+$("parId").value+"&lineCd="+$("lineCd").value+"&itemNo="+$("itemNoPeril").value+"&perilCd="+$("itemPerilCd").value+"&action=getNetPerilPrem&sequenceNoPeril="
						+ $F("sequenceNoPeril"),{ //Modified by Apollo Cruz 09.17.2014
					method: "POST",
					postBody: Form.serialize("billDiscountForm"),
					asynchronous: false,
					evalScripts: true,
					onCreate: function(){
						showNotice("Please wait...");
// 						$("premAmtPeril").up("td", 0).update("<span id='refSpan' style='font-size: 9px;'>Refreshing...</span>");
						},
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
// 							$("refSpan").up("td", 0).update("<input id='premAmtPeril' style='width: 210px;' type='text' value='' class='money' readonly='readonly' />");
							var text = response.responseText;
							var arr = text.split(resultMessageDelimiter);
							$("paramDiscTotalPeril").value = formatCurrency(arr[0]);
							$("paramSurcTotalPeril").value = formatCurrency(arr[1]);
							computeNetPremPerilDisc();
						}
					}
				});
			}
		}
	});
	
	function computePerilDiscRt(){
		if (isNaN(parseFloat($F("discountAmtPeril").replace(/,/g, "") * 1)) || $F("discountAmtPeril")=="" || parseFloat($F("discountAmtPeril").replace(/,/g, "") * 1)<0) {$("discountRtPeril").clear(); return;}
		$("discountRtPeril").value = generateDiscountSurchargeRate("discountAmtPeril", "premAmtPeril");
	}

	function computePerilDiscAmt(){
		if (isNaN(parseFloat($F("discountRtPeril").replace(/,/g, "") * 1)) || $F("discountRtPeril")=="" || parseFloat($F("discountRtPeril").replace(/,/g, "") * 1)<0) {$("discountAmtPeril").clear(); return;}
		$("discountAmtPeril").value = generateDiscountSurchargeAmount("discountRtPeril", "premAmtPeril"); 
	}

	function computePerilSurcRt(){
		if (isNaN(parseFloat($F("surchargeAmtPeril").replace(/,/g, "") * 1)) || $F("surchargeAmtPeril")=="" || parseFloat($F("surchargeAmtPeril").replace(/,/g, "") * 1)<0) {$("surchargeRtPeril").clear(); return;}
		$("surchargeRtPeril").value = generateDiscountSurchargeRate("surchargeAmtPeril", "premAmtPeril");
	}
	
	function computePerilSurcAmt(){
		if (isNaN(parseFloat($F("surchargeRtPeril").replace(/,/g, "") * 1)) || $F("surchargeRtPeril")=="" || parseFloat($F("surchargeRtPeril").replace(/,/g, "") * 1)<0) {$("surchargeAmtPeril").clear(); return;}
		$("surchargeAmtPeril").value = generateDiscountSurchargeAmount("surchargeRtPeril", "premAmtPeril"); 
	}

	function computeNetPremPerilDisc(){
		var varDiscTotal = nvl(unformatCurrency("paramDiscTotalPeril"),0);
		var varSurcTotal = nvl(unformatCurrency("paramSurcTotalPeril"),0);
		var premAmt = 0;
		if (varDiscTotal > 0){
			premAmt = nvl(unformatCurrency("paramOrigPerilPremAmt"),0) - varDiscTotal;
		} else {
			premAmt = nvl(unformatCurrency("paramOrigPerilPremAmt"),0);
		}		
		$("premAmtPeril").value = formatCurrency(premAmt + varSurcTotal);
		computePerilDiscAmt();
		computePerilSurcAmt();
	}

	checkTableIfEmpty("rowPeril", "billPerilDiscountTable");
	checkIfToResizeTable("billPerilDiscountTableList", "rowPeril"); 
	
	function initializePerilDiscount() {
		$("discountAmtPeril").clear();
		//$("discountRtPeril").value = "0.0000" ;//$("discountRtPeril").clear();// replaced with code below : shan 11.27.2014
		$("lblModuleId").getAttribute("moduleId") == "GIPIS143" ? $("discountRtPeril").clear() : $("discountRtPeril").value = "0.0000";
		$("surchargeAmtPeril").clear();
		$("surchargeRtPeril").clear();
		$("itemPeril").clear();
		$("premAmtPeril").clear();
		enableSearch("searchItemImgPerilDisc");
	}
	
	$("searchItemImgPeril").observe("click", function() {
		showBillItemLOV($("parId").value, onOk);
	});
	
	function onOk(row){
		if(row != undefined){
			$("itemNoPeril").value      = row.itemNo;	
			initializePerilDiscount();
			if (!objUW.hidGIPIS143.showPerilsPerItem2($F("itemNoPeril"))){
				$("itemNoPeril").clear();
				disableSearch("searchItemImgPerilDisc");
			}
		}
	};
	
	$("searchItemImgPerilDisc").observe("click", function() {
		showBillItemPerilLOV($("parId").value, $("lineCd").value, $("itemNoPeril").value ,onOkPerilDisc);
	});
	
	function onOkPerilDisc(row){
		if(row != undefined){
			$("premAmtPeril").value     = formatCurrency(row.premAmt);
			$("itemPeril").value      = unescapeHTML2(row.perilName); //added unescapeHTML2 by robert 11.28.2013
			$("itemPerilCd").value      = row.perilCd;
			objUW.hidGIPIS143.checkItemPeril();
		}
	}; 
	
	$("discountRtPeril").clear(); // shan 11.27.2014
</script>