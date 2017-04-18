<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<input type='hidden' id='pageNoBasic' value='0' readonly="readonly" />
<c:forEach var="basic" items="${listBasic}">
	<div id="rowBasic${basic.sequenceNo}" name="rowBasic" class="tableRow">
		<input type='hidden' name="sequenceNos" value="${basic.sequenceNo}" />
		<input type='hidden' name="origPremAmts" value="${basic.origPremAmt}" />
		<input type='hidden' name="discountAmts" value="${basic.discountAmt}" />
		<input type='hidden' name="discountRts" value="${basic.discountRt}" />
		<input type='hidden' name="surchargeAmts" value="${basic.surchargeAmt}" />
		<input type='hidden' name="surchargeRts" value="${basic.surchargeRt}" />
		<input type='hidden' name="netGrossTags" value="${basic.netGrossTag}" />
		<input type='hidden' name="remarks" value="${basic.remarks}" />	
		<input type='hidden' id="netPremAmts" name="netPremAmts" value="${basic.netPremAmt}" />
		<label style="width: 140px; text-align: center;">${basic.sequenceNo}
		<c:if test="${empty basic.sequenceNo}">-</c:if></label>
		<label style="width: 120px; text-align: right;">
		<fmt:formatNumber pattern="#,###.####" minFractionDigits="2">${basic.origPremAmt}</fmt:formatNumber>		
		<c:if test="${empty basic.origPremAmt}">0.00</c:if></label>
		<label style="width: 130px; text-align: right;">
		<fmt:formatNumber pattern="#,###.####" minFractionDigits="2">${basic.discountAmt}</fmt:formatNumber>
		<c:if test="${empty basic.discountAmt}">0.00</c:if></label>
		<label style="width: 120px; text-align: right;">
		<fmt:formatNumber pattern="#,###.####" minFractionDigits="4">${basic.discountRt}</fmt:formatNumber>
		<c:if test="${empty basic.discountRt}">0.0000</c:if></label>
		<label style="width: 140px; text-align: right;">
		<fmt:formatNumber pattern="#,###.####" minFractionDigits="2">${basic.surchargeAmt}</fmt:formatNumber>
		<c:if test="${empty basic.surchargeAmt}">0.00</c:if></label>
		<label style="width: 130px; text-align: right;">
		<fmt:formatNumber pattern="#,###.####" minFractionDigits="4">${basic.surchargeRt}</fmt:formatNumber>
		<c:if test="${empty basic.surchargeRt}">0.0000</c:if></label>
		<c:if test="${basic.netGrossTag eq 'G'}">
			<label style="width: 50px; text-align: center;">
				<img style="width: 10px; height: 10px;" name="checkedImg" />
			</label>
		</c:if>		
	</div>
</c:forEach>
<!--  
<c:if test="${noOfPagesBasic gt 1}">
<div style="height: 22px; " >
	<div style="float: right; margin-top: 2px; height: 20px;" >
		Page 
		<select id="pageBasic" name="pageBasic">
			<c:forEach var="i" begin="1" end="${noOfPagesBasic}">
				<option value="${i}"
					<c:if test="${i eq pageNoBasic}">
						selected="selected"
					</c:if>
				>${i}</option>
			</c:forEach>
		</select> of ${noOfPagesBasic}
	</div>
</div>
</c:if>
-->
<script>
	var selectedRowId = '';

	resetBasicDiscountForm1();
	$$("div[name='rowBasic']").each(
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
					$$("div[name='rowBasic']").each(function (r)	{
						if (row.getAttribute("id") != r.getAttribute("id"))	{
							r.removeClassName("selectedRow");
						}	
				     });
					$$("div[name='rowPeril']").each(function (r)	{
						r.removeClassName("selectedRow");
						enableButton("btnAddDiscountPeril");
						disableButton("btnDelDiscountPeril");
				     });
					$$("div[name='rowItem']").each(function (r)	{
						r.removeClassName("selectedRow");
						enableButton("btnAddDiscountItem");
						disableButton("btnDelDiscountItem");
				     });
					$("sequenceNo").value = row.down("input", 0).value;
					$("premAmt").value = formatCurrency(row.down("input", 1).value);
					$("discountAmt").value = formatCurrency(row.down("input", 2).value);
					$("discountRt").value = formatRate(row.down("input", 3).value);
					$("surchargeAmt").value = formatCurrency(row.down("input", 4).value);
					$("surchargeRt").value = formatRate(row.down("input", 5).value);
					var gtag = row.down("input", 6).value;
					if(gtag == 'G'){
						$("grossTag").checked = true;
					} else {
						$("grossTag").checked = false;
					}		
					$("remark").value = row.down("input", 7).value;	
					showBasicButton(true);
				} else {
					showBasicButton(false);
				}	  
				$("origBasicDiscountAmt").value = parseFloat($F("discountAmt").replace(/,/g, ""));
				$("origBasicSurchargeAmt").value = parseFloat($F("surchargeAmt").replace(/,/g, ""));
			});			
		}	
	);

	$$("div[name='rowBasic']").each(function (div)	{
		if ((div.down("label", 1).innerHTML).length > 30)	{
			div.down("label", 1).update((div.down("label", 1).innerHTML).truncate(30, "..."));
		}
	});

	$("btnDelDiscount").observe("click", function ()	{
		if ($F("sequenceNo") == parseInt($F("hiddenSequence")) - 1 ){
			//distribute policy discount
			var itemIndex = 1;
			var quoteTotal = 0;
			var sequenceNo = $F('sequenceNo');
			var policyPrem = 0;
			var objDiscSurchTotal = new Object();
			$$("div[name='hiddenItemDiv']").each(function(rowItem){
				deletePolicyDiscountSurcharge(parseInt(rowItem.down("input", 0).value), itemIndex);
				policyPrem = policyPrem + (Math.round((parseFloat($("itemNo").options[itemIndex].getAttribute("netPrem")) * parseFloat(rowItem.down("input", 1).value))*100)/100);
				itemIndex++;
			});	
			$("quotePremAmt").value = policyPrem;
			//end distribute policy discount
			$$("div[name='rowBasic']").each(function (row)	{
				if (row.hasClassName("selectedRow"))	{
					Effect.Fade(row, {
						duration: .2,
						afterFinish: function ()	{
						    $("sequencePolicyArray").value = $("sequenceNo").value + "," + $("sequencePolicyArray").value;
							$$("div[name='rowPerilHidden']").each(function (rowPeril) {
								if(rowPeril.down("input", 0).value == sequenceNo) {//row.down("input", 0).value){
									rowPeril.remove();
									checkTableIfEmpty("rowPeril", "quotePerilDiscountTable");
								}
							}); 
							row.remove();								
							resetBasicDiscountForm1();	
							checkTableIfEmpty("rowBasic", "quotePolicyBasicDiscountTable");
							showBasicButton(false);			
						}
					});
				}
			});
			resetGrossTags();	
		}else{
			showMessageBox("Discounts can be deleted from the last sequence to the discount to be deleted.", imgMessage.ERROR);
		}
	});

	
	$("btnAddDiscount").observe("click", function ()	{
		if (validateBasicEntries()){
			//if(!checkForNegativePerilsPolicy()){		
				//Policy Discount/Surcharge
				var sequenceNo = $F('sequenceNo');
				var premAmt = formatCurrency($F("premAmt"));
				var discountAmt = formatCurrency($F("discountAmt"));
				var discountRt = formatRate($F("discountRt"));
				var surchargeAmt = formatCurrency($F("surchargeAmt"));
				var surchargeRt = formatRate($F("surchargeRt"));
				var grossTag = $("grossTag").checked==true?'G':'N';
				var remark = $F("remark");
				var itemTable = $("quotePolicyBasicDiscountTableList");
				var newDiv = new Element("div");

				newDiv.setAttribute("id", "rowBasic"+sequenceNo);
				newDiv.setAttribute("name", "rowBasic");
				newDiv.setStyle("height: 20px; border-bottom: 1px solid #E0E0E0; padding-top: 10px; display: none;");		
	
				var strDiv = ''+
					'<input type="hidden" name="sequenceNos" value="'+sequenceNo+'" />'+
					'<input type="hidden" name="origPremAmts" value="'+premAmt+'" />'+
					'<input type="hidden" name="discountAmts" value="'+discountAmt+'" />'+
					'<input type="hidden" name="discountRts" value="'+discountRt+'" />'+
					'<input type="hidden" name="surchargeAmts" value="'+surchargeAmt+'" />'+
					'<input type="hidden" name="surchargeRts" value="'+surchargeRt+'" />'+
					'<input type="hidden" name="netGrossTags" value="'+grossTag+'" />'+
					'<input type="hidden" name="remarks" value="'+remark+'" />'+		
					'<input type="hidden" name="netPremAmts" value="'+$F("quotePremAmt")+'" />';
					
				if(sequenceNo != '-'){
					strDiv += '<label style="width: 140px; text-align: center;">'+sequenceNo+'</label>';
				} else {
					strDiv += '<label style="width: 140px; text-align: center;">-</label>';
				}	
				if(premAmt != '-'){
					strDiv += '<label style="width: 120px; text-align: right;">'+
					formatCurrency(premAmt)+'</label>';
				} else {
					strDiv += '<label style="width: 120px; text-align: right;">-</label>';
				}	 	
				if(discountAmt != '-'){
					strDiv += '<label style="width: 130px; text-align: right;">'+
					formatCurrency(discountAmt)+'</label>';
				} else {
					strDiv += '<label style="width: 130px; text-align: right;">-</label>';
				}			
				if(discountRt != '-'){
					strDiv += '<label style="width: 120px; text-align: right;">'+
					formatRate(discountRt)+'</label>';
				} else {
					strDiv += '<label style="width: 120px; text-align: right;">-</label>';
				}	
				if(surchargeAmt != '-'){
					strDiv += '<label style="width: 140px; text-align: right;">'+
					formatCurrency(surchargeAmt)+'</label>';
				} else {
					strDiv += '<label style="width: 140px; text-align: right;">-</label>';
				}			
				if(surchargeRt != '-'){
					strDiv += '<label style="width: 130px; text-align: right;">'+
					formatRate(surchargeRt)+'</label>';
				} else {
					strDiv += '<label style="width: 130px; text-align: right;">-</label>';
				}	
				strDiv += '<label style="text-align: center; width: 50px;"><img style="width: 10px; height: 10px;" ';
				if(grossTag == 'G'){
					strDiv += 'name="checkedImg" src="'+checkImgSrc+'"';
				}	
				strDiv += '></img></label>';
			
				if ("Update" == $F("btnAddDiscount")) {
					$$("div[name='rowBasic']").each(function (div) {
						if (div.hasClassName("selectedRow")) {
							newDiv = div;
						}
					});
					newDiv.update(strDiv);
					deletePolicyDiscountSurcharge($F("origBasicDiscountAmt"), $F("origBasicSurchargeAmt"));
					distributePolicyDiscountSurcharge();
				} else {
					var itemIndex = 1;
					$$("div[name='hiddenItemDiv']").each(function(rowItem){
						setItemPerilValues(parseInt(rowItem.down("input",0).value), itemIndex);
						itemIndex++;
					});	
					
					var perilPremTotal = 0; 
					var perilSurchTotal = 0;
					$$("div[name='hiddenItemDiv']").each(function(rowItem){
						perilPremTotal += Math.round((parseFloat(getTotalPerItem(sequenceNo, parseInt(rowItem.down("input",0).value), parseFloat(rowItem.down("input",1).value))))*100)/100;
						perilSurchTotal += Math.round((parseFloat(getTotalSurchPerItem(sequenceNo, parseInt(rowItem.down("input",0).value), parseFloat(rowItem.down("input",1).value))))*100)/100;	
					});	
					var ctrItem = 0;
					var ctrPrem = 1;
					var quotePrem = 0;
					$$("div[name='hiddenItemDiv']").each(function(rowItem){
						if (ctrItem == 0) {
							offsetOverUnderValues(sequenceNo, rowItem.down("input",0).value, perilPremTotal,  parseFloat(rowItem.down("input",1).value), perilSurchTotal);
							ctrItem++;
						}
						quotePrem = quotePrem + (parseFloat($("itemNo").options[ctrPrem].getAttribute("netPrem")) * parseFloat(rowItem.down("input", 1).value));
						ctrPrem++;
					});
					$("quotePremAmt").value = Math.round(quotePrem*100)/100;
								
					newDiv.update(strDiv);
					itemTable.insert({bottom: newDiv});
	
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
							$$("div[name='rowBasic']").each(function (r)	{
								if (newDiv.getAttribute("id") != r.getAttribute("id"))	{
									r.removeClassName("selectedRow");
								}
						    });
							$$("div[name='rowPeril']").each(function (r)	{
								r.removeClassName("selectedRow");
								enableButton("btnAddDiscountPeril");
								disableButton("btnDelDiscountPeril");
						     });
							$$("div[name='rowItem']").each(function (r)	{
								r.removeClassName("selectedRow");
								enableButton("btnAddDiscountItem");
								disableButton("btnDelDiscountItem");
						     });
							$("sequenceNo").value = newDiv.down("input", 0).value;
							$("premAmt").value = formatCurrency(newDiv.down("input", 1).value);
							$("discountAmt").value = formatCurrency(newDiv.down("input", 2).value);
							$("discountRt").value = formatRate(newDiv.down("input", 3).value);
							$("surchargeAmt").value = formatCurrency(newDiv.down("input", 4).value);
							$("surchargeRt").value = formatRate(newDiv.down("input", 5).value);
							var gtag = newDiv.down("input", 6).value;
							if(gtag == 'G'){
								$("grossTag").checked = true;
							} else {
								$("grossTag").checked = false;
							}	
							$("remark").value = newDiv.down("input", 7).value;	
							showBasicButton(true);				
						} else {
							showBasicButton(false);
						}
						$("origBasicDiscountAmt").value = parseFloat($F("discountAmt").replace(/,/g, ""));
						$("origBasicSurchargeAmt").value = parseFloat($F("surchargeAmt").replace(/,/g, ""));
					});
		
					new Effect.Appear(newDiv, {
						duration: .2, 
						afterFinish: function () {
							checkTableIfEmpty("rowBasic", "quotePolicyBasicDiscountTable");
						}
					});
				}
				resetGrossTags();	
				resetBasicDiscountForm1();
			}/*else{
				showMessageBox("Cannot add discount. Adding of discount will result to negative Peril/s.", imgMessage.ERROR);
			}	
		}	*/
	});

	function validateAddDiscount(){
		var proceed = true;
		
		return proceed;
	}

	function checkForNegativePerilsPolicy(){
		var isNegativePeril = false;
		$$("div[name='hiddenPerilDiv']").each(function(row){
			var sequenceNo = $F("sequenceNo");
			var grossTag = $("grossTag").checked == true ? "G" : "N";
			var currRt = 0;
			var discAmt = 0;
			var ctr = 0;
			var itemListLength = $("itemNo").length;
			var surchargeAmt = 0;
			var itemNo = 0;

			$$("div[name='hiddenItemDiv']").each(function(rowItem){
				if (rowItem.down("input", 0).value == row.down("input", 0).value){
					currRt = parseFloat(rowItem.down("input", 1).value);
					origPremAmt = parseFloat(rowItem.down("input", 3).value);
					premAmt = parseFloat(rowItem.down("input", 2).value);
				}
			});
				if (grossTag == "G"){
					discAmt = ((((parseFloat(row.down("input", 2).value) * currRt) / parseFloat($F("quoteAnnPremAmt"))) * unformatCurrency("discountAmt")) / currRt);
					surchargeAmt = ((((parseFloat(row.down("input", 2).value) * currRt) / parseFloat($F("quoteAnnPremAmt"))) * unformatCurrency("surchargeAmt")) / currRt);
				}else{
					discAmt = ((((parseFloat(row.down("input", 3).value) * currRt) / $F("quotePremAmt")) * unformatCurrency("discountAmt")) / currRt);
					surchargeAmt = ((((parseFloat(row.down("input", 3).value) * currRt) / parseFloat($F("quotePremAmt"))) * unformatCurrency("surchargeAmt")) / currRt);
				}
			if (itemListLength == ctr){
				ctr = 0;
			}
			ctr++;
			if ((parseFloat(row.down("input", 3).value)- parseFloat(Math.round(discAmt*100)/100)) + parseFloat(Math.round(surchargeAmt*100)/100) < 0){
				isNegativePeril = true;
			}	
		});

		return isNegativePeril;
	}
	
	function resetBasicDiscountForm1() {
		generateSequenceFromLastValue2();
		$("premAmt").value = formatCurrency($("quoteAnnPremAmt").value);
		$("discountAmt").value = formatCurrency("0");
		$("discountRt").value = formatRate("0");
		$("surchargeAmt").value = formatCurrency("0");
		$("surchargeRt").value = formatRate("0");
		$("grossTag").checked = true;						
		$("remark").value = "";

		$$("div[name='rowBasic']").each(function (div) {
			div.removeClassName("selectedRow");
		});

		$('btnAddDiscount').value = "Add";
		disableButton("btnDelDiscount");

		generateSequenceFromLastValue2();
	}

	function showBasicButton(param){
		if(param){			
			enableButton("btnDelDiscount");
			disableButton("btnAddDiscount");
		} else {
			resetBasicDiscountForm1();
			enableButton("btnAddDiscount");
		}
	}

	function deletePolicyDiscountSurcharge(itemNo, itemIndex){
		var sequenceNo = $F("sequenceNo");
		var ctr = 1;
		
		$$("div[name='rowPerilHidden']").each(function (row) {
			if (sequenceNo == row.down("input",0).value && itemIndex == parseFloat(row.down("input",1).value)){
				var perilLength = $("perilPremAmtSelect"+ itemNo).length - 1;
				var discAmt = parseFloat(row.down("input", 4).value);
				var surchargeAmt = parseFloat(row.down("input", 6).value);
				var newPremAmt = Math.round((((Math.round((parseFloat($("perilPremAmtSelect"+ itemNo).options[ctr].value))*100)/100) - surchargeAmt) + discAmt)*100)/100;

				$("perilPremAmtSelect"+ itemNo).options[ctr].value = newPremAmt;
				$("perilPremAmtSelect"+ itemNo).options[ctr].text = newPremAmt;
				$("itemNo").options[itemIndex].setAttribute("netPrem", Math.round((((Math.round((parseFloat($("itemNo").options[itemIndex].getAttribute("netPrem")))*100)/100) - surchargeAmt) + discAmt)*100)/100 );

				$$("div[name='hiddenPerilDiv']").each(function(rowPeril){
					if (row.down("input",1).value == rowPeril.down("input",0).value && row.down("input",2).value == rowPeril.down("input",1).value){
						rowPeril.down("input",3).value = newPremAmt;
					}	
				});	
				if (ctr != perilLength){			
					ctr++;
				}else {
					ctr = 1;
				}
			}
		});	
	}

	function validateBasicEntries(){
		var isValid = true;
		
		if ( (unformatCurrency("discountAmt") > 0 && parseFloat($F("discountRt")) == 0) ) {
			showMessageBox("Invalid Discount Rate. Value should be from 0.0000 to 100.0000.", imgMessage.ERROR);  
			isValid = false;
		} else if ( (unformatCurrency("discountAmt") == 0 && parseFloat($F("discountRt")) > 0) || ((unformatCurrency("discountAmt") == 0 && parseFloat($F("discountRt")) == 0)) && (unformatCurrency("surchargeAmt") == 0 && parseFloat($F("surchargeRt")) == 0)){
			showMessageBox("Invalid Discount Amount. Value should be greater than 0.00 but not greater than Net Premium Amount.", imgMessage.ERROR);  
			isValid = false;
		} else if ( (unformatCurrency("surchargeAmt") == 0 && parseFloat($F("surchargeRt")) > 0) ){
			showMessageBox("Invalid Surcharge Amount. Value should be greater than 0.00 but not greater than Net Premium Amount.", imgMessage.ERROR);  
			isValid = false;
		} else if ( (unformatCurrency("surchargeAmt") > 0 && parseFloat($F("surchargeRt")) == 0) ){
			showMessageBox("Invalid Discount Rate. Value should be from 0.0000 to 100.0000.", imgMessage.ERROR);  
			isValid = false;
		}
	
		return isValid;
	}

	function setItemPerilValues(itemNo, itemIndex){
		var ctr = 1;
		var itemPremAmt = 0;
		$$("div[name='hiddenPerilDiv']").each(function(row){
			var hiddenPerilTable = $("quotePerilDiscountTableList");
			var hiddenPerilDiv = new Element("div");
			var strPerilDiv;
			var sequenceNo = $F("sequenceNo");
			var grossTag = $("grossTag").checked == true ? "G" : "N";
			var itemListLength = $("itemNo").length;
			var surchargeAmt = 0;
			var rateTotal = 0;
			var discRt = 0;
			if (row.down("input", 0).value == itemNo){			
				if (grossTag == 'G'){
					discAmt = Math.round(((parseFloat(row.down("input", 2).value) * parseFloat($F("discountRt")))/100)*100)/100;
					surchargeAmt = Math.round(((parseFloat(row.down("input", 2).value) * parseFloat($F("surchargeRt")))/100)*100)/100;
				}else{
					discAmt = Math.round(((parseFloat(row.down("input", 3).value) * parseFloat($F("discountRt")))/100)*100)/100;
					surchargeAmt = Math.round(((parseFloat(row.down("input", 3).value) * parseFloat($F("surchargeRt")))/100)*100)/100;
				}
				netPremAmt = Math.round(((parseFloat(row.down("input", 3).value) + surchargeAmt) - discAmt)*100)/100; //Math.round((parseFloat(row.down("input", 3).value) - discAmt)*100)/100;
				hiddenPerilDiv.setAttribute("id", "rowPerilHidden"+sequenceNo);
				hiddenPerilDiv.setAttribute("name", "rowPerilHidden");
				hiddenPerilDiv.setStyle("height: 20px; border-bottom: 1px solid #E0E0E0; padding-top: 10px; display: none;");
				strPerilDiv = ''+
				'<input type="text" name="perilSequenceNos" value="'+sequenceNo+'" />'+
				'<input type="text" name="perilItemNos" value="'+ row.down("input", 0).value +'" />'+
				'<input type="text" name="perilCodes" value="'+ row.down("input", 1).value +'" />'+
				'<input type="hidden" name="perilOrigPerilPremAmts" value="'+ row.down("input", 2).value +'" />'+
				'<input type="text" name="perilDiscountAmts" value="'+ discAmt +'" />'+
				'<input type="hidden" name="perilDiscountRts" value="'+$F("discountRt")+'" />'+
				'<input type="hidden" name="perilSurchargeAmts" value="'+ surchargeAmt +'" />'+
				'<input type="hidden" name="perilSurchargeRts" value="'+$F("surchargeRt")+'" />'+
				'<input type="hidden" name="perilNetGrossTags" value="'+grossTag+'" />'+
				'<input type="hidden" name="perilLevelTags" value="1" />'+
				'<input type="hidden" name="perilRemarks" value="'+$F("remarkItem")+'" />' +
				'<input type="text" name="perilNetPremAmts" value="'+ (grossTag=='G' ? row.down("input", 2).value : $("perilPremAmtSelect"+ itemNo).options[ctr].value) +'" />'; //(grossTag=='G' ? row.down("input", 2).value : row.down("input", 3).value)
				
				row.down("input", 3).value = netPremAmt;
				hiddenPerilDiv.update(strPerilDiv);
				hiddenPerilTable.insert({bottom: hiddenPerilDiv});
				$("perilPremAmtSelect"+ itemNo).options[ctr].value = Math.round(((parseFloat($("perilPremAmtSelect"+ itemNo).options[ctr].value) + surchargeAmt) - discAmt)*100)/100; //Math.round(($("perilPremAmtSelect"+ itemNo).options[ctr].value - discAmt)*100)/100;
				$("perilPremAmtSelect"+ itemNo).options[ctr].text = $("perilPremAmtSelect"+ itemNo).options[ctr].value;
				itemPremAmt = Math.round(((parseFloat($("itemNo").options[itemIndex].getAttribute("netPrem")) + surchargeAmt) - discAmt)*100)/100;//(Math.round(($("itemNo").options[itemIndex].getAttribute("netPrem") - discAmt)*100)/100);
				$("itemNo").options[itemIndex].setAttribute("netPrem", itemPremAmt);
				$("quotePremAmt").value = (unformatCurrency("quotePremAmt") + (Math.round((surchargeAmt * parseFloat($("itemNo").options[itemIndex].getAttribute("currRt")))*100)/100) ) - (Math.round((discAmt * parseFloat($("itemNo").options[itemIndex].getAttribute("currRt"))*100)/100) );
				ctr++;
			}	
		});
	}
	
	function getTotalPerItem(sequenceNo, itemNo, currRt){
		var convPremQuotePerilTotal = 0;

		$$("div[name='rowPerilHidden']").each(function(row){;
			if (sequenceNo == row.down("input", 0).value && itemNo == row.down("input", 1).value) {
				convPremQuotePerilTotal = convPremQuotePerilTotal + (Math.round((parseFloat(row.down("input", 4).value)* currRt )*100)/100);
			}
		});	
		
		return convPremQuotePerilTotal;
	}
	
	function getTotalSurchPerItem(sequenceNo, itemNo, currRt){
		var convPremQuotePerilTotal = 0;

		$$("div[name='rowPerilHidden']").each(function(row){;
			if (sequenceNo == row.down("input", 0).value && itemNo == row.down("input", 1).value) {
				convPremQuotePerilTotal = convPremQuotePerilTotal + (Math.round((parseFloat(row.down("input", 6).value)* currRt )*100)/100);
			}
		});	
		
		return convPremQuotePerilTotal;
	}
	

    function offsetOverUnderValues(sequenceNo, itemNo, perilPremTotal, currRt, perilSurchTotal){
        var outerCtr = 0;
        var innerCtr = 0;
        // OFFSETTING FOR DISCOUNT AMOUNT
    	if (perilPremTotal > unformatCurrency("discountAmt")){
    		var premOverAmt = (Math.round((perilPremTotal - unformatCurrency("discountAmt"))*100)/100);
    		var localPremOverAmt = premOverAmt;
    		$$("div[name='rowPerilHidden']").each(function(row){
    			if (sequenceNo == row.down("input", 0).value && outerCtr == 0) {
    				premOverAmt = Math.round((premOverAmt / currRt)*100)/100;
    				row.down("input", 4).value = parseFloat(row.down("input", 4).value) - premOverAmt;
    				$("perilPremAmtSelect"+ itemNo).options[1].value = Math.round((parseFloat($("perilPremAmtSelect"+ itemNo).options[1].value) + premOverAmt)*100)/100;
    				$("perilPremAmtSelect"+ itemNo).options[1].text = $("perilPremAmtSelect"+ itemNo).options[1].value;
					
    				$$("div[name='hiddenPerilDiv']").each(function(row){
    					if (itemNo == row.down("input", 0).value && innerCtr == 0) {
    						row.down("input", 3).value = Math.round((parseFloat(row.down("input", 3).value) + premOverAmt)*100)/100; 
    						$("itemNo").options[1].setAttribute("netPrem", (Math.round((parseFloat($("itemNo").options[1].getAttribute("netPrem")) + premOverAmt)*100)/100) );
    						innerCtr++;
    					}	
    				});	
    				outerCtr++;
    			}
    		});		
		}else{
			var premUnderAmt = (Math.round((unformatCurrency("discountAmt") - perilPremTotal)*100)/100);
			var localPremUnderAmt = premUnderAmt;
			$$("div[name='rowPerilHidden']").each(function(row){
				if (sequenceNo == row.down("input", 0).value && outerCtr++ == 0) {
					premUnderAmt = Math.round((premUnderAmt / currRt)*100)/100;
					row.down("input", 4).value = parseFloat(row.down("input", 4).value) + premUnderAmt;
					$("perilPremAmtSelect"+ itemNo).options[1].value = Math.round((parseFloat($("perilPremAmtSelect"+ itemNo).options[1].value) - premUnderAmt)*100)/100;
    				$("perilPremAmtSelect"+ itemNo).options[1].text = $("perilPremAmtSelect"+ itemNo).options[1].value;

    				$$("div[name='hiddenPerilDiv']").each(function(row){
    					if (itemNo == row.down("input", 0).value && innerCtr == 0) {
    						row.down("input", 3).value = Math.round((parseFloat(row.down("input", 3).value) - premUnderAmt)*100)/100; 
    						$("itemNo").options[1].setAttribute("netPrem", (Math.round((parseFloat($("itemNo").options[1].getAttribute("netPrem")) - premUnderAmt)*100)/100) );
    						innerCtr++;
    					}	
    				});	
    				//$("quotePremAmt").value = Math.round((unformatCurrency("quotePremAmt") + localPremUnderAmt)*100)/100;
    				outerCtr++;
				}
			});
		}
    	// END OFFSETTING FOR DISCOUNT AMOUNT
    	
		outerCtr = 0;
        innerCtr = 0;
        
    	// OFFSETTING FOR SURCHARGE AMOUNT
    	if (perilSurchTotal > unformatCurrency("surchargeAmt")){
    		var surchOverAmt = (Math.round((perilSurchTotal - unformatCurrency("surchargeAmt"))*100)/100);
    		$$("div[name='rowPerilHidden']").each(function(row){
    			if (sequenceNo == row.down("input", 0).value && outerCtr == 0) {
    				surchOverAmt = Math.round((surchOverAmt / currRt)*100)/100;
    				row.down("input", 6).value = parseFloat(row.down("input", 6).value) - surchOverAmt;
    				$("perilPremAmtSelect"+ itemNo).options[1].value = Math.round((parseFloat($("perilPremAmtSelect"+ itemNo).options[1].value) - surchOverAmt)*100)/100;
    				$("perilPremAmtSelect"+ itemNo).options[1].text = $("perilPremAmtSelect"+ itemNo).options[1].value;
					
    				$$("div[name='hiddenPerilDiv']").each(function(row){
    					if (itemNo == row.down("input", 0).value && innerCtr == 0) {
    						row.down("input", 3).value = Math.round((parseFloat(row.down("input", 3).value) - surchOverAmt)*100)/100; 
    						$("itemNo").options[1].setAttribute("netPrem", (Math.round((parseFloat($("itemNo").options[1].getAttribute("netPrem")) - surchOverAmt)*100)/100) );
    						innerCtr++;
    					}	
    				});	
    				outerCtr++;
    			}
    		});		
		}else{
			var surchUnderAmt = (Math.round((unformatCurrency("surchargeAmt") - perilSurchTotal)*100)/100);
			$$("div[name='rowPerilHidden']").each(function(row){
				if (sequenceNo == row.down("input", 0).value && outerCtr++ == 0) {
					surchUnderAmt = Math.round((surchUnderAmt / currRt)*100)/100;
					row.down("input", 6).value = parseFloat(row.down("input", 6).value) + surchUnderAmt;
					$("perilPremAmtSelect"+ itemNo).options[1].value = Math.round((parseFloat($("perilPremAmtSelect"+ itemNo).options[1].value) + surchUnderAmt)*100)/100;
    				$("perilPremAmtSelect"+ itemNo).options[1].text = $("perilPremAmtSelect"+ itemNo).options[1].value;

    				$$("div[name='hiddenPerilDiv']").each(function(row){
    					if (itemNo == row.down("input", 0).value && innerCtr == 0) {
    						row.down("input", 3).value = Math.round((parseFloat(row.down("input", 3).value) + surchUnderAmt)*100)/100; 
    						$("itemNo").options[1].setAttribute("netPrem", (Math.round((parseFloat($("itemNo").options[1].getAttribute("netPrem")) + surchUnderAmt)*100)/100) );
    						innerCtr++;
    					}	
    				});	
    				//$("quotePremAmt").value = Math.round((unformatCurrency("quotePremAmt") + localPremUnderAmt)*100)/100;
    				outerCtr++;
				}
			});
		}
    	//END OFFSETTING FOR SURCHARGE AMOUNT
    }

</script>