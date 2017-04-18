<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<input type='hidden' id='pageNoItem' value='0' readonly="readonly" />
<c:forEach var="item" items="${listItem}">
	<div id="rowItem${item.sequenceNo}" name="rowItem" class="tableRow">
		<input type='hidden' name="itemSequenceNos" value="${item.sequenceNo}" />
		<input type='hidden' name="itemItemNos" value="${item.itemNo}" />
		<input type='hidden' name="itemItemTitles" value="${item.itemTitle}" />
		<input type='hidden' name="itemOrigPremAmts" value="${item.origPremAmt}" />
		<input type='hidden' name="itemDiscountAmts" value="${item.discountAmt}" />
		<input type='hidden' name="itemDiscountRts" value="${item.discountRt}" />
		<input type='hidden' name="itemSurchargeAmts" value="${item.surchargeAmt}" />
		<input type='hidden' name="itemSurchargeRts" value="${item.surchargeRt}" />
		<input type='hidden' name="itemNetGrossTags" value="${item.netGrossTag}" />
		<input type='hidden' name="itemRemarks" value="${item.remarks}" />		
		<input type='hidden' name="itemPremAmts" value="${item.netPremAmt}" />
		<label style="width: 120px; text-align: center;">${item.sequenceNo}
		<c:if test="${empty item.sequenceNo}">-</c:if></label>
		<label style="width: 100px; text-align: right;">
		<fmt:formatNumber pattern="#,###.####" minFractionDigits="2">${item.origPremAmt}</fmt:formatNumber>		
		<c:if test="${empty item.origPremAmt}">-</c:if></label>
		<label style="width: 100px; text-align: center;">
		${item.itemNo}
		</label>
		<label style="width: 100px; text-align: left;" name="itemTitle">
		${item.itemTitle}
		</label>
		<label style="width: 100px; text-align: right;">
		<fmt:formatNumber pattern="#,###.####" minFractionDigits="2">${item.discountAmt}</fmt:formatNumber>
		<c:if test="${empty item.discountAmt}">-</c:if></label>
		<label style="width: 100px; text-align: right;">
		<fmt:formatNumber pattern="#,###.####" minFractionDigits="4">${item.discountRt}</fmt:formatNumber>
		<c:if test="${empty item.discountRt}">-</c:if></label>
		<label style="width: 100px; text-align: right;">
		<fmt:formatNumber pattern="#,###.####" minFractionDigits="2">${item.surchargeAmt}</fmt:formatNumber>
		<c:if test="${empty item.surchargeAmt}">-</c:if></label>
		<label style="width: 100px; text-align: right;">
		<fmt:formatNumber pattern="#,###.####" minFractionDigits="4">${item.surchargeRt}</fmt:formatNumber>
		<c:if test="${empty item.surchargeRt}">-</c:if></label>
		<c:if test="${item.netGrossTag eq 'G'}">
			<label style="width: 50px; text-align: center;">
				<img style="width: 10px; height: 10px;" name="checkedImg" />
			</label>
		</c:if>		
	</div>
</c:forEach>
<!--  
<c:if test="${noOfPagesItem gt 1}">
<div style="height: 22px; " >
	<div style="float: right; margin-top: 2px; height: 20px;" >
		Page 
		<select id="pageItem" name="pageItem">
			<c:forEach var="i" begin="1" end="${noOfPagesItem}">
				<option value="${i}"
					<c:if test="${i eq pageNoItem}">
						selected="selected"
					</c:if>
				>${i}</option>
			</c:forEach>
		</select> of ${noOfPagesItem}
	</div>
</div>
</c:if>
-->
<script type="text/javascript">
	var selectedRowId = '';
	//added by robert to limit display of item title 10.09.2014
	$$("label[name='itemTitle']").each(function(lbl){ 
		lbl.update(lbl.innerHTML.truncate(16, "..."));
	});
	
	resetItemDiscountForm();
	$$("div[name='rowItem']").each(
		function (row)	{
			row.observe("mouseover", function ()	{
				row.addClassName("lightblue");
			});
			row.observe("mouseout", function ()	{
				row.removeClassName("lightblue");
			});
			row.observe("click", function ()	{
				selectedRowId = row.getAttribute("id");
				row.toggleClassName("selectedRow");
				if (row.hasClassName("selectedRow"))	{
					$$("div[name='rowItem']").each(function (r)	{
						if (row.getAttribute("id") != r.getAttribute("id"))	{
							r.removeClassName("selectedRow");
						}	
				     });
					$$("div[name='rowBasic']").each(function (r)	{
						r.removeClassName("selectedRow");
						enableButton("btnAddDiscount");
						disableButton("btnDelDiscount");
				     });
					$$("div[name='rowPeril']").each(function (r)	{
						r.removeClassName("selectedRow");
						enableButton("btnAddDiscountPeril");
						disableButton("btnDelDiscountPeril");
				     });
					$("sequenceNoItem").value = row.down("input", 0).value;
					$("itemNo").value = row.down("input", 1).value;
					$("itemTitle").value = row.down("input", 2).value;
					$("premAmtItem").value = formatCurrency(row.down("input", 3).value);
					$("discountAmtItem").value = formatCurrency(row.down("input", 4).value);
					$("discountRtItem").value = formatRate(row.down("input", 5).value);
					$("surchargeAmtItem").value = formatCurrency(row.down("input", 6).value);
					$("surchargeRtItem").value = formatRate(row.down("input", 7).value);
					var gtag = row.down("input", 8).value;
					if(gtag == 'G'){
						$("grossTagItem").checked = true;
					}  else {
						$("grossTagItem").checked = false;
					}
					$("remarkItem").value = row.down("input", 9).value;	
					showItemButton(true);				
				} else {
					resetItemDiscountForm();
					showItemButton(false);
				}	    
				$("origItemDiscountAmt").value = parseFloat($F("discountAmtItem").replace(/,/g, ""));
				$("origItemSurchargeAmt").value = parseFloat($F("surchargeAmtItem").replace(/,/g, ""));
			});			
		}	
	);

	$$("div[name='rowItem']").each(function (div)	{
		if ((div.down("label", 1).innerHTML).length > 30)	{
			div.down("label", 1).update((div.down("label", 1).innerHTML).truncate(30, "..."));
		}
	});

	if($("pageItem")){
	$("pageItem").observe("change", function () {
		loadItemDiscountList($F("pageItem"));
	});
	}


	if($('itemNo').length>1){
		$("btnDelDiscountItem").observe("click", function ()	{
			if ($F("sequenceNoItem") == parseInt($F("hiddenSequence")) - 1 ){
				var surchargeAmt = parseFloat($F("surchargeAmtItem").replace(/,/g, ""));
				var discountAmt = parseFloat($F("discountAmtItem").replace(/,/g, ""));
				var netItemPrem = parseFloat($("itemNo").options[$("itemNo").selectedIndex].getAttribute("netPrem"));
				//set item premium amount
				//$("itemNo").options[$("itemNo").selectedIndex].setAttribute("netPrem", (netItemPrem + parseFloat(discountAmt)) - parseFloat(surchargeAmt));
				//set peril premium amount
				deleteItemDiscountSurcharge(0,0);
				//set policy premium amount
				//$("quotePremAmt").value = (parseFloat($F("quotePremAmt")) + discountAmt) - surchargeAmt;
				
				$$("div[name='rowItem']").each(function (row)	{
					if (row.hasClassName("selectedRow"))	{
						Effect.Fade(row, {
							duration: .2,
							afterFinish: function ()	{
								$$("div[name='rowPerilHidden']").each(function (rowPeril) {
									if(rowPeril.down("input", 0).value == row.down("input", 0).value){
										rowPeril.remove();
										checkTableIfEmpty("rowPeril", "quotePerilDiscountTable");
									}
								}); 
								row.remove();		
								resetItemDiscountForm();
								checkTableIfEmpty("rowItem", "quoteItemDiscountTable");
								showItemButton(false);			
							}
						});
					}
				});
				resetGrossTags();	
			}else{
				showMessageBox("Discounts can be deleted from the last sequence to the discount to be deleted.", imgMessage.ERROR);
			}
		});
		$("btnAddDiscountItem").observe("click", function ()	{
			if (validateItemEntries()){
				//if(!checkForNegativePerils("item")){	
					var sequenceNo = $F("sequenceNoItem");
					var itemNo = $F("itemNo").blank()?'-':$F("itemNo");
					var itemTitle = $F("itemTitle").blank()?'-':$F("itemTitle");
					var premAmt = formatCurrency($F("premAmtItem"));
					var discountAmt = formatCurrency($F("discountAmtItem"));
					var discountRt = formatRate($F("discountRtItem"));
					var surchargeAmt = formatCurrency($F("surchargeAmtItem"));
					var surchargeRt = formatRate($F("surchargeRtItem"));
					var grossTag = $("grossTagItem").checked==true?'G':''; 
					var remark = $F("remarkItem");
					var itemTable = $("quoteItemDiscountTableList");
						
					var newDiv = new Element("div");
					newDiv.setAttribute("id", "rowItem"+sequenceNo);
					newDiv.setAttribute("name", "rowItem");
					newDiv.setStyle("height: 20px; border-bottom: 1px solid #E0E0E0; padding-top: 10px; display: none;");
					
					var strDiv = ''+
						'<input type="hidden" name="itemSequenceNos" value="'+sequenceNo+'" />'+
						'<input type="hidden" name="itemNos" value="'+itemNo+'" />'+
						'<input type="hidden" name="itemTitles" value="'+itemTitle+'" />'+
						'<input type="hidden" name="itemOrigPremAmts" value="'+premAmt+'" />'+
						'<input type="hidden" name="itemDiscountAmts" value="'+discountAmt+'" />'+
						'<input type="hidden" name="itemDiscountRts" value="'+discountRt+'" />'+
						'<input type="hidden" name="itemSurchargeAmts" value="'+surchargeAmt+'" />'+
						'<input type="hidden" name="itemSurchargeRts" value="'+surchargeRt+'" />'+
						'<input type="hidden" name="itemNetGrossTags" value="'+grossTag+'" />'+
						'<input type="hidden" name="itemRemarks" value="'+remark+'" />';	
					if(sequenceNo != '-'){
						strDiv += '<label style="width: 120px; text-align: center;">'+sequenceNo+'</label>';
					} else {
						strDiv += '<label style="width: 120px; text-align: center;">-</label>';
					}	
					if(premAmt != '-'){
						strDiv += '<label style="width: 100px; text-align: right;">'+
						formatCurrency(premAmt)+'</label>';
					} else {
						strDiv += '<label style="width: 100px; text-align: right;">0.00</label>';
					}
					strDiv += '<label style="width: 100px; text-align: center;">'+itemNo+'</label>';
					strDiv += '<label style="width: 100px; text-align: left;">'+itemTitle+'</label>';			 	
					if(discountAmt != '-'){
						strDiv += '<label style="width: 100px; text-align: right;">'+
						formatCurrency(discountAmt)+'</label>';
					} else {
						strDiv += '<label style="width: 100px; text-align: right;">0.00</label>';
					}			
					if(discountRt != '-'){
						strDiv += '<label style="width: 100px; text-align: right;">'+
						formatRate(discountRt)+'</label>';
					} else {
						strDiv += '<label style="width: 100px; text-align: right;">0.0000</label>';
					}	
					if(surchargeAmt != '-'){
						strDiv += '<label style="width: 100px; text-align: right;">'+
						formatCurrency(surchargeAmt)+'</label>';
					} else {
						strDiv += '<label style="width: 100px; text-align: right;">0.00</label>';
					}			
					if(surchargeRt != '-'){
						strDiv += '<label style="width: 100px; text-align: right;">'+
						formatRate(surchargeRt)+'</label>';
					} else {
						strDiv += '<label style="width: 100px; text-align: right;">0.0000</label>';
					}	
					strDiv += '<label style="width: 50px; text-align: center;"><img style="width: 10px; height: 10px;" ';
					if(grossTag == 'G'){
						strDiv += 'name="checkedImg" src="'+checkImgSrc+'"';
					}	
					strDiv += '></img></label>';
					if ("Update" == $F("btnAddDiscountItem")) {
						$$("div[name='rowItem']").each(function (div) {
							if (div.hasClassName("selectedRow")) {
								newDiv = div;
							}
						});
						newDiv.update(strDiv);
						deleteItemDiscountSurcharge($F("origItemDiscountAmt"), $F("origItemSurchargeAmt"));
						//distributeItemDiscountSurcharge();
					} else {
						newDiv.update(strDiv);
						itemTable.insert({bottom: newDiv});		

						setItemPerilValues();
						offsetOverUnderValues(sequenceNo, $F("itemNo"));

						newDiv.observe("mouseover", function ()	{
							newDiv.addClassName("lightblue");
						});
						
						newDiv.observe("mouseout", function ()	{
							newDiv.removeClassName("lightblue");
						});
			
						newDiv.observe("click", function ()	{
							selectedRowId = newDiv.getAttribute("id");
							newDiv.toggleClassName("selectedRow");
							if (newDiv.hasClassName("selectedRow"))	{
								$$("div[name='rowItem']").each(function (r)	{
									if (newDiv.getAttribute("id") != r.getAttribute("id"))	{
										r.removeClassName("selectedRow");
									}	
							     });
								$$("div[name='rowBasic']").each(function (r)	{
									r.removeClassName("selectedRow");
									enableButton("btnAddDiscount");
									disableButton("btnDelDiscount");
							     });
								$$("div[name='rowPeril']").each(function (r)	{
									r.removeClassName("selectedRow");
									enableButton("btnAddDiscountPeril");
									disableButton("btnDelDiscountPeril");
							     });
								$("sequenceNoItem").value = newDiv.down("input", 0).value;
								$("itemNo").value = newDiv.down("input", 1).value;
								$("itemTitle").value = newDiv.down("input", 2).value;
								$("premAmtItem").value = formatCurrency(newDiv.down("input", 3).value);
								$("discountAmtItem").value = formatCurrency(newDiv.down("input", 4).value);
								$("discountRtItem").value = formatRate(newDiv.down("input", 5).value);
								$("surchargeAmtItem").value = formatCurrency(newDiv.down("input", 6).value);
								$("surchargeRtItem").value = formatRate(newDiv.down("input", 7).value);
								var gtag = newDiv.down("input", 8).value;
								if(gtag == 'G'){
									$("grossTagItem").checked = true;
								} else {
									$("grossTagItem").checked = false;
								}		
								$("remarkItem").value = newDiv.down("input", 9).value;	
								showItemButton(true);				
							} else {
								showItemButton(false);
							}
							$("origItemDiscountAmt").value = parseFloat($F("discountAmtItem").replace(/,/g, ""));
							$("origItemSurchargeAmt").value = parseFloat($F("surchargeAmtItem").replace(/,/g, ""));
						});
			
						new Effect.Appear(newDiv, {
							duration: .2, 
							afterFinish: function () {
								checkTableIfEmpty("rowItem", "quoteItemDiscountTable");
							}
						});
					}
					resetGrossTags();	
					resetItemDiscountForm();
				//}else{
				//	showMessageBox("Cannot add discount. Adding of discount will result to negative Peril/s.", imgMessage.ERROR);
				//}		
			}
		});
	} else {
		$("btnDelDiscountItem").observe("click", function ()	{
			showMessageBox("Buttons for item discounts are disabled since no\nItems are included in the quotation...");
		});
		$("btnAddDiscountItem").observe("click", function ()	{
			showMessageBox("Buttons for item discounts are disabled since no\nItems are included in the quotation...");
		});
	}

	$("itemNo").observe("change", function ()	{
		$('itemTitle').value = $("itemTitleSelected").options[$("itemNo").selectedIndex].text;
	});

	function resetItemDiscountForm() {
		$("sequenceNoItem").value = "";
		$("itemNo").selectedIndex = 0;
		$("itemTitle").value = "";
		$("premAmtItem").value = formatCurrency("0");
		$("discountAmtItem").value = formatCurrency("0");
		$("discountRtItem").value = formatRate("0");
		$("surchargeAmtItem").value = formatCurrency("0");
		$("surchargeRtItem").value = formatRate("0");
		$("grossTagItem").checked = true;						
		$("remarkItem").value = "";

		$("btnAddDiscountItem").value = "Add";
		disableButton("btnDelDiscountItem");

		$$("div[name='rowItem']").each(function (div) {
			div.removeClassName("selectedRow");
		});
		generateSequenceFromLastValue2();
	}

	function showItemButton(param){
		if (param) {
			enableButton("btnDelDiscountItem");
			disableButton("btnAddDiscountItem");
		} else {
			resetItemDiscountForm();
			enableButton("btnAddDiscountItem");
		}
	}
	
	function deleteItemDiscountSurcharge(discount, surcharge){
		var grossTag = $("grossTagItem").checked==true?'G':'N';
		var discountParam = discount == "0" ? parseFloat($F("discountAmtItem").replace(/,/g, "")) : discount;
		var surchargeParam = surcharge == "0" ? parseFloat($F("surchargeAmtItem").replace(/,/g, "")) : surcharge;
		var sequenceNo = $F("sequenceNoItem");
		var ctr = 1;
		var currRt = parseFloat($("itemNo").options[$("itemNo").selectedIndex].getAttribute("currRt"));
		$$("div[name='rowPerilHidden']").each(function (row) {
			if (sequenceNo == row.down("input",0).value){
				var newPremAmt = Math.round(((parseFloat($("perilPremAmtSelect"+ $F("itemNo")).options[ctr].value) - parseFloat(row.down("input",6).value))+ parseFloat(row.down("input",4).value))*100)/100;
				$("perilPremAmtSelect"+ $F("itemNo")).options[ctr].value = newPremAmt;
				$("perilPremAmtSelect"+ $F("itemNo")).options[ctr].text = newPremAmt;

				$$("div[name='hiddenPerilDiv']").each(function(rowPeril){
					if (row.down("input",1).value == rowPeril.down("input",0).value && row.down("input",2).value == rowPeril.down("input",1).value){
						rowPeril.down("input",3).value = newPremAmt;
					}	
				});				
				ctr++;
			}
		});	
		$("itemNo").options[$("itemNo").selectedIndex].setAttribute("netPrem", (parseFloat($("itemNo").options[$("itemNo").selectedIndex].getAttribute("netPrem")) - unformatCurrency("surchargeAmtItem")) + unformatCurrency("discountAmtItem"));
		$("quotePremAmt").value = ( parseFloat($F("quotePremAmt")) - (Math.round((parseFloat(surchargeParam)* currRt)*100)/100) ) + (Math.round((parseFloat(discountParam) * currRt)*100)/100);
	}

	function validateItemEntries(){
		var isValid = true;
		if ($("itemNo").selectedIndex == 0){
			showMessageBox("Please select an Item first.", imgMessage.ERROR);
			isValid = false;
		}else if ( (unformatCurrency("discountAmtItem") > 0 && parseFloat($F("discountRtItem")) == 0) ) {
			showMessageBox("Invalid Discount Rate. Value should be from 0.0000 to 100.0000.", imgMessage.ERROR);  
			isValid = false;
		} else if ( (unformatCurrency("discountAmtItem") == 0 && parseFloat($F("discountRtItem")) > 0) || ((unformatCurrency("discountAmtItem") == 0 && parseFloat($F("discountRtItem")) == 0) && (unformatCurrency("surchargeAmtItem") == 0 && parseFloat($F("surchargeRtItem")) == 0)) ){
			showMessageBox("Invalid Discount Amount. Value should be greater than 0.00 but not greater than Net Premium Amount.", imgMessage.ERROR);  
			isValid = false;
		} else if ( (unformatCurrency("surchargeAmtItem") == 0 && parseFloat($F("surchargeRtItem")) > 0) ){
			showMessageBox("Invalid Surcharge Amount. Value should be greater than 0.00 but not greater than Net Premium Amount.", imgMessage.ERROR);  
			isValid = false;
		} else if ( (unformatCurrency("surchargeAmtItem") > 0 && parseFloat($F("surchargeRtItem")) == 0) ){
			showMessageBox("Invalid Discount Rate. Value should be from 0.0000 to 100.0000.", imgMessage.ERROR);  
			isValid = false;
			
		}	return isValid;
	}

	function offsetOverUnderValues(sequenceNo, itemNo){
		var premPerilTotal = 0;
		var premSurchPerilTotal = 0;
		var premQuotePerilTotal = 0;
		var origQuotePrem = 0;
		var ctr = 0;
		var origQuotePrem = parseFloat($("itemNo").options[$("itemNo").selectedIndex].getAttribute("netPrem"));
		//OFFSET QUOTE_ITMPERIL
		$$("div[name='hiddenPerilDiv']").each(function(row){
			if (itemNo == row.down("input", 0).value) {
				premQuotePerilTotal += parseFloat(row.down("input", 3).value);
			}
		});
		premQuotePerilTotal = Math.round((premQuotePerilTotal)*100)/100;
		if (premQuotePerilTotal > origQuotePrem){
			var premQuotePerilOverAmt = Math.round((premQuotePerilTotal - origQuotePrem)*100)/100;
			$$("div[name='hiddenPerilDiv']").each(function(row){
				if (itemNo == row.down("input", 0).value && ctr == 0) {
					row.down("input", 3).value = parseFloat(row.down("input", 3).value) - premQuotePerilOverAmt; 
					$("perilPremAmtSelect"+ itemNo).options[1].value = row.down("input", 3).value;
					$("perilPremAmtSelect"+ itemNo).options[1].text = row.down("input", 3).value;
					ctr++;
				}	
			});	
		}else if (premQuotePerilTotal < origQuotePrem){
			var premQuotePerilUnderAmt = Math.round((origQuotePrem - premQuotePerilTotal)*100)/100;
			$$("div[name='hiddenPerilDiv']").each(function(row){
				if (itemNo == row.down("input", 0).value && ctr == 0) {
					row.down("input", 3).value = parseFloat(row.down("input", 3).value) + premQuotePerilUnderAmt;
					$("perilPremAmtSelect"+ itemNo).options[1].value = row.down("input", 3).value;
					$("perilPremAmtSelect"+ itemNo).options[1].text = row.down("input", 3).value;
					ctr++;
				}	
			});	
		}
		ctr=0;
		//OFFSET PERIL DISCOUNTS
		$$("div[name='rowPerilHidden']").each(function(row){
			if (sequenceNo == row.down("input", 0).value) {
				premPerilTotal += parseFloat(row.down("input", 4).value);
			}
		});
		premPerilTotal = Math.round(premPerilTotal*100)/100;
		if (premPerilTotal > unformatCurrency("discountAmtItem")){
			var premOverAmt = Math.round((premPerilTotal - unformatCurrency("discountAmtItem"))*100)/100;
			$$("div[name='rowPerilHidden']").each(function(row){
				if (sequenceNo == row.down("input", 0).value && ctr == 0) {
					row.down("input", 4).value = parseFloat(row.down("input", 4).value) - premOverAmt;
					ctr++;
				}
			});
		}else if ((Math.round(premPerilTotal*100)/100) < unformatCurrency("discountAmtItem")){
			var premUnderAmt = Math.round((unformatCurrency("discountAmtItem") - premPerilTotal)*100)/100;
			$$("div[name='rowPerilHidden']").each(function(row){
				if (sequenceNo == row.down("input", 0).value && ctr == 0) {
					row.down("input", 4).value = parseFloat(row.down("input", 4).value) + premUnderAmt;
					ctr++;
				}
			});
		}
		//END OFFSET PERIL DISCOUNTS

		
		ctr=0;
		//OFFSET PERIL SURCHARGE DISCOUNTS
		$$("div[name='rowPerilHidden']").each(function(row){
			if (sequenceNo == row.down("input", 0).value) {
				premSurchPerilTotal += parseFloat(row.down("input", 6).value);
			}
		});
		premSurchPerilTotal = Math.round(premSurchPerilTotal*100)/100;
		if (premSurchPerilTotal > unformatCurrency("surchargeAmtItem")){
			var premSurchOverAmt = Math.round((premSurchPerilTotal - unformatCurrency("surchargeAmtItem"))*100)/100;
			$$("div[name='rowPerilHidden']").each(function(row){
				if (sequenceNo == row.down("input", 0).value && ctr == 0) {
					row.down("input", 6).value = parseFloat(row.down("input", 6).value) - premSurchOverAmt;
					ctr++;
				}
			});
		}else if ((Math.round(premSurchPerilTotal*100)/100) < unformatCurrency("surchargeAmtItem")){
			var premSurchUnderAmt = Math.round((unformatCurrency("surchargeAmtItem") - parseFloat(premSurchPerilTotal))*100)/100;
			$$("div[name='rowPerilHidden']").each(function(row){
				if (sequenceNo == row.down("input", 0).value && ctr == 0) {
					row.down("input", 6).value = parseFloat(row.down("input", 6).value) + premSurchUnderAmt;
					ctr++;
				}
			});
		}
		//END OFFSET PERIL SURCHARGE DISCOUNTS
	}

	function setItemPerilValues(){
		var ctr = 1;
		var itemPremAmt = 0;
		$$("div[name='hiddenPerilDiv']").each(function(row){
			var hiddenPerilTable = $("quotePerilDiscountTableList");
			var hiddenPerilDiv = new Element("div");
			var strPerilDiv;
			var sequenceNo = $F("sequenceNoItem");
			var grossTag = $("grossTagItem").checked == true ? "G" : "N";
			var itemListLength = $("itemNo").length;
			var surchargeAmt = 0;
			var rateTotal = 0;
			var discRt = 0;
			if (row.down("input", 0).value == $("itemNo").options[$("itemNo").selectedIndex].value){						
				if (grossTag == 'G'){
					discAmt = Math.round(((parseFloat(row.down("input", 2).value) * parseFloat($F("discountRtItem")))/100)*100)/100;
					surchargeAmt = Math.round(((parseFloat(row.down("input", 2).value) * parseFloat($F("surchargeRtItem")))/100)*100)/100;;

				}else{
					discAmt = Math.round(((parseFloat(row.down("input", 3).value) * parseFloat($F("discountRtItem")))/100)*100)/100;
					surchargeAmt = Math.round(((parseFloat(row.down("input", 3).value) * parseFloat($F("surchargeRtItem")))/100)*100)/100;;
				}
				netPremAmt = Math.round( ( (parseFloat(row.down("input", 3).value) + surchargeAmt) - discAmt)*100)/100;
				hiddenPerilDiv.setAttribute("id", "rowPerilHidden"+sequenceNo);
				hiddenPerilDiv.setAttribute("name", "rowPerilHidden");
				hiddenPerilDiv.setStyle("height: 20px; border-bottom: 1px solid #E0E0E0; padding-top: 10px; display: none;");
				strPerilDiv = ''+
				'<input type="text" name="perilSequenceNos" value="'+sequenceNo+'" />'+
				'<input type="text" name="perilItemNos" value="'+ row.down("input", 0).value +'" />'+
				'<input type="text" name="perilCodes" value="'+ row.down("input", 1).value +'" />'+
				'<input type="hidden" name="perilOrigPerilPremAmts" value="'+ row.down("input", 2).value +'" />'+
				'<input type="text" name="perilDiscountAmts" value="'+ discAmt +'" />'+
				'<input type="hidden" name="perilDiscountRts" value="'+$F("discountRtItem")+'" />'+
				'<input type="hidden" name="perilSurchargeAmts" value="'+ surchargeAmt +'" />'+
				'<input type="hidden" name="perilSurchargeRts" value="'+$F("surchargeRtItem")+'" />'+
				'<input type="hidden" name="perilNetGrossTags" value="'+grossTag+'" />'+
				'<input type="hidden" name="perilLevelTags" value="2" />'+
				'<input type="hidden" name="perilRemarks" value="'+$F("remarkItem")+'" />' +
				'<input type="text" name="perilNetPremAmts" value="'+ (grossTag=='G' ? row.down("input", 2).value : $("perilPremAmtSelect"+ $F("itemNo")).options[ctr].value) +'" />'; //(grossTag=='G' ? row.down("input", 2).value : row.down("input", 3).value)
				
				row.down("input", 3).value = netPremAmt;
				hiddenPerilDiv.update(strPerilDiv);
				hiddenPerilTable.insert({bottom: hiddenPerilDiv});
				$("perilPremAmtSelect"+ $F("itemNo")).options[ctr].value = Math.round(((parseFloat($("perilPremAmtSelect"+ $F("itemNo")).options[ctr].value) + surchargeAmt) - discAmt)*100)/100;
				$("perilPremAmtSelect"+ $F("itemNo")).options[ctr].text = $("perilPremAmtSelect"+ $F("itemNo")).options[ctr].value;
				//
				ctr++;
			}	
		});
		itemPremAmt = (Math.round(((parseFloat($("itemNo").options[$("itemNo").selectedIndex].getAttribute("netPrem")) + unformatCurrency("surchargeAmtItem")) - unformatCurrency("discountAmtItem"))*100)/100);
		$("itemNo").options[$("itemNo").selectedIndex].setAttribute("netPrem", itemPremAmt);
		var currRt = parseFloat($("itemNo").options[$("itemNo").selectedIndex].getAttribute("currRt"));
		$("quotePremAmt").value = (parseFloat($F("quotePremAmt")) + Math.round(((unformatCurrency("surchargeAmtItem") * currRt))*100)/100) - (Math.round((unformatCurrency("discountAmtItem") * currRt)*100)/100);
	}

	function checkForNegativePerils(level){
		var isNegativePeril = false;
		$$("div[name='hiddenPerilDiv']").each(function(row){
			var sequenceNo = $F("sequenceNo");
			var grossTag = $("grossTagItem").checked == true ? "G" : "N";
			var currRt = 0;
			var discAmt = 0;
			var ctr = 0;
			var itemListLength = $("itemNo").length;
			var surchargeAmt = 0;
			var itemNo = $("itemNo").options[$("itemNo").selectedIndex].value;

			$$("div[name='hiddenItemDiv']").each(function(rowItem){
				if (rowItem.down("input", 0).value == row.down("input", 0).value){
					currRt = parseFloat(rowItem.down("input", 1).value);
					origPremAmt = parseFloat(rowItem.down("input", 3).value);
					premAmt = parseFloat(rowItem.down("input", 2).value);
				}
			});
	
			if (grossTag == "G"){
				discAmt = (parseFloat(row.down("input", 2).value) / parseFloat(origPremAmt)) * unformatCurrency("discountAmtItem");			
				surchargeAmt = parseFloat((parseFloat(row.down("input", 2).value) / parseFloat(origPremAmt))) * unformatCurrency("surchargeAmtItem");
			}else{
				discAmt = (parseFloat(row.down("input", 3).value) / parseFloat(premAmt)) * unformatCurrency("discountAmtItem");
				surchargeAmt = (parseFloat(row.down("input", 3).value) / parseFloat(premAmt)) * unformatCurrency("surchargeAmtItem");
			}
			if (itemListLength == ctr){
				ctr = 0;
			}
			ctr++;
			if (itemNo == row.down("input", 0).value){
				if ((parseFloat(row.down("input", 3).value)- parseFloat(Math.round(discAmt*100)/100)) + parseFloat(Math.round(surchargeAmt*100)/100) < 0){
					isNegativePeril = true;
				}
			}	
		});

		return isNegativePeril;
	}
	
	generateSequenceFromLastValue2();
</script>
