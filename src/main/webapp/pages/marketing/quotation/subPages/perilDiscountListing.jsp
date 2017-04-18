<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<input type='hidden' id='pageNoPeril' value='0' readonly="readonly" />
<c:forEach var="peril" items="${hiddenPerilList}"> <!-- listPeril-->
	<c:if test="${peril.levelTag eq '3'}"> 
		<div id="rowPeril${peril.sequenceNo}" name="rowPeril" class="tableRow" rowCd="${peril.perilCd }">
			<input type='hidden' name="perilSequenceNos" value="${peril.sequenceNo}" />
			<input type='hidden' name="perilItemNos" value="${peril.itemNo}" />
			<input type='hidden' name="perilCodes" value="${peril.perilCd}" />
			<input type='hidden' name="perilOrigPerilPremAmt" value="${peril.origPerilPremAmt}" />
			<input type='hidden' name="perilDiscountAmts" value="${peril.discountAmt}" />
			<input type='hidden' name="perilDiscountRts" value="${peril.discountRt}" />
			<input type='hidden' name="perilSurchargeAmts" value="${peril.surchargeAmt}" />
			<input type='hidden' name="perilSurchargeRts" value="${peril.surchargeRt}" />
			<input type='hidden' name="perilNetGrossTags" value="${peril.netGrossTag}" />
			<input type='hidden' name="perilRemarks" value="${peril.remarks}" />	
			<input type='hidden' name="perilNetPrem" value="${peril.netPremAmt}" />		
			<label style="width: 120px; text-align: center;">${peril.sequenceNo}
			<c:if test="${empty peril.sequenceNo}">-</c:if></label>
			<label style="width: 100px; text-align: right;">
			<fmt:formatNumber pattern="#,###.####" minFractionDigits="2">${peril.origPerilPremAmt}</fmt:formatNumber>		
			<c:if test="${empty peril.origPerilPremAmt}">-</c:if></label>
			<label style="width: 100px; text-align: center;">
			${peril.itemNo}
			</label>
			<label style="width: 100px; text-align: left;" name="perilName">
			${peril.perilName}
			</label>
			<label style="width: 100px; text-align: right;">
			<fmt:formatNumber pattern="#,###.####" minFractionDigits="2">${peril.discountAmt}</fmt:formatNumber>
			<c:if test="${empty peril.discountAmt}">-</c:if></label>
			<label style="width: 100px; text-align: right;;">
			<fmt:formatNumber pattern="#,###.####" minFractionDigits="4">${peril.discountRt}</fmt:formatNumber>
			<c:if test="${empty peril.discountRt}">-</c:if></label>
			<label style="width: 100px; text-align: right;">
			<fmt:formatNumber pattern="#,###.####" minFractionDigits="2">${peril.surchargeAmt}</fmt:formatNumber>
			<c:if test="${empty peril.surchargeAmt}">-</c:if></label>
			<label style="width: 100px; text-align: right;">
			<fmt:formatNumber pattern="#,###.####" minFractionDigits="4">${peril.surchargeRt}</fmt:formatNumber>
			<c:if test="${empty peril.surchargeRt}">-</c:if></label>
			<c:if test="${peril.netGrossTag eq 'G'}">
				<label style="width: 50px; text-align: center;">
					<img style="width: 10px; height: 10px;" name="checkedImg" />
				</label>
			</c:if>		
		</div>
	</c:if>	
</c:forEach>
 
<c:forEach var="peril" items="${hiddenPerilList}">
	<c:if test="${peril.levelTag eq '1' || peril.levelTag eq '2'}">
		<div id="rowPerilHidden${peril.sequenceNo}" name="rowPerilHidden" style="display: none;">
				<input type='hidden' name="perilSequenceNos" value="${peril.sequenceNo}" />
				<input type='hidden' name="perilItemNos" value="${peril.itemNo}" />
				<input type='hidden' name="perilCodes" value="${peril.perilCd}" />
				<input type='hidden' name="perilOrigPerilPremAmt" value="${peril.origPerilPremAmt}" />
				<input type='hidden' name="perilDiscountAmts" value="${peril.discountAmt}" />
				<input type='hidden' name="perilDiscountRts" value="${peril.discountRt}" />
				<input type='hidden' name="perilSurchargeAmts" value="${peril.surchargeAmt}" />
				<input type='hidden' name="perilSurchargeRts" value="${peril.surchargeRt}" />
				<input type='hidden' name="perilNetGrossTags" value="${peril.netGrossTag}" />
				<input type='hidden' name="perilLevelTags" value="${peril.levelTag}" />
				<input type='hidden' name="perilRemarks" value="${peril.remarks}" />	
				<input type='hidden' name="perilNetPremAmts" value="${peril.netPremAmt}" />	
		</div>	
	</c:if>
</c:forEach>	
<!-- 
<c:if test="${noOfPagesPeril gt 1}">
<div style="height: 22px; " >
	<div style="float: right; margin-top: 2px; height: 20px;" >
		Page 
		<select id="pagePeril" name="pagePeril">
			<c:forEach var="i" begin="1" end="${noOfPagesPeril}">
				<option value="${i}"
					<c:if test="${i eq pageNoPeril}">
						selected="selected"
					</c:if>
				>${i}</option>
			</c:forEach>
		</select> of ${noOfPagesPeril}
	</div>
</div>
</c:if>
-->
<script>
	var selectedRowId = '';
	resetPerilDiscountForm();
	
	$$("label[name='perilName']").each(function(lbl){
		lbl.update(lbl.innerHTML.truncate(14, "..."));
	});
	
	$$("div[name='rowPeril']").each(
		function (row)	{
			row.observe("mouseover", function ()	{
				row.addClassName("lightblue");
			});
			row.observe("mouseout", function ()	{
				row.removeClassName("lightblue");
			});
			row.observe("click", function ()	{
				try {
				selectedRowId = row.getAttribute("id");
				row.toggleClassName("selectedRow");
				
				if (row.hasClassName("selectedRow"))	{
					$$("div[name='rowPeril']").each(function (r)	{
						if (row.getAttribute("id") != r.getAttribute("id"))	{
							r.removeClassName("selectedRow");
						}	
				     });
					$$("div[name='rowBasic']").each(function (r)	{
						r.removeClassName("selectedRow");
						enableButton("btnAddDiscount");
						disableButton("btnDelDiscount");
				     });
					$$("div[name='rowItem']").each(function (r)	{
						r.removeClassName("selectedRow");
						enableButton("btnAddDiscountItem");
						disableButton("btnDelDiscountItem");
				     });
					$("sequenceNoPeril").value = row.down("input", 0).value;
					$("itemNoPeril").value = row.down("input", 1).value;
					changePeril();
					//changePerilCd(newDiv.down("input", 2).value);
					//$("perilPremAmtSelect"+ $("itemNoPeril").value).options[$("perilCodeSelect"+$F("itemNoPeril")).selectedIndex].value = 
					$("perilCodeSelect"+$("itemNoPeril").value).value = row.down("input", 2).value;
					$("perilPremAmtSelect"+$("itemNoPeril").value).selectedIndex = $("perilCodeSelect"+$("itemNoPeril").value).selectedIndex;
					$("perilAnnPremAmtSelect"+$("itemNoPeril").value).selectedIndex = $("perilPremAmtSelect"+$("itemNoPeril").value).selectedIndex;
					$("premAmtPeril").value = formatCurrency(row.down("input", 3).value);
					$("discountAmtPeril").value = formatCurrency(row.down("input", 4).value);
					$("discountRtPeril").value = formatRate(row.down("input", 5).value);
					$("surchargeAmtPeril").value = formatCurrency(row.down("input", 6).value);
					$("surchargeRtPeril").value = formatRate(row.down("input", 7).value);
					var gtag = row.down("input", 8).value;
					if(gtag == 'G'){
						$("grossTagPeril").checked = true;
					}  else {
						$("grossTagPeril").checked = false;
					}
					$("remarkPeril").value = row.down("input", 9).value;		
					showPerilButton(true);			
				} else {
					resetPerilDiscountForm();
					showPerilButton(false);
				}	    
				$("origPerilDiscountAmt").value = parseFloat($F("discountAmtPeril").replace(/,/g, ""));
				$("origPerilSurchargeAmt").value = parseFloat($F("surchargeAmtPeril").replace(/,/g, ""));
				} catch (e) {
					showErrorMessage("perilDiscountListing.jsp", e);
				}
			});		
		}	
	);

	$$("div[name='rowPeril']").each(function (div)	{
		if ((div.down("label", 1).innerHTML).length > 30)	{
			div.down("label", 1).update((div.down("label", 1).innerHTML).truncate(30, "..."));
		}
	});

	if($("pagePeril")){
		$("pagePeril").observe("change", function () {
			loadPerilDiscountList($F("pagePeril"));
		});
	}


	if($('itemNoPeril').length>1){
		$("btnDelDiscountPeril").observe("click", function ()	{
			if ($F("sequenceNoPeril") == parseInt($F("hiddenSequence")) - 1 ){
				deletePerilDiscountSurcharge(0,0);
				$$("div[name='rowPeril']").each(function (row)	{
					if (row.hasClassName("selectedRow"))	{
						Effect.Fade(row, {
							duration: .2,
							afterFinish: function ()	{
								row.remove();			
								resetPerilDiscountForm();
								checkTableIfEmpty("rowPeril", "quotePerilDiscountTable");
								showPerilButton(false);			
							}
						});
					}
				});
				resetGrossTags();
			}else{
				showMessageBox("Discounts can be deleted from the last sequence to the discount to be deleted.", imgMessage.ERROR);
			}
		});
		$("btnAddDiscountPeril").observe("click", function ()	{
			if (validatePerilEntries()){
				var sequenceNo = $F("sequenceNoPeril");
				var itemNo = $F("itemNoPeril").blank()?'-':$F("itemNoPeril");
				var perilCd = $F("perilCodeSelect"+$F("itemNoPeril")).blank()?'-': $F("perilCodeSelect"+$F("itemNoPeril"));
				var perilName = $("perilCodeSelect"+$F("itemNoPeril")).options[$("perilCodeSelect"+$F("itemNoPeril")).selectedIndex].text;
				var premAmt = formatCurrency($F("premAmtPeril"));
				var discountAmt = formatCurrency($F("discountAmtPeril"));
				var discountRt = formatRate($F("discountRtPeril"));
				var surchargeAmt = formatCurrency($F("surchargeAmtPeril"));
				var surchargeRt = formatRate($F("surchargeRtPeril"));
				var grossTag = $("grossTagPeril").checked==true?'G':'';
				var remark = $F("remarkPeril");
				var itemTable = $("quotePerilDiscountTableList");
				var newDiv = new Element("div");
				var netPrem = $("perilPremAmtSelect"+ $("itemNoPeril").value).options[$("perilCodeSelect"+$F("itemNoPeril")).selectedIndex].getAttribute("netPrem");
				distributePerilDiscountSurcharge($F("premAmtPeril"));
				var	annPremAmt = $("perilPremAmtSelect"+ $("itemNoPeril").value).options[$("perilCodeSelect"+$F("itemNoPeril")).selectedIndex].getAttribute("annPremAmt");

				newDiv.setAttribute("id", "rowPeril"+sequenceNo);
				newDiv.setAttribute("name", "rowPeril");
				newDiv.setStyle("height: 20px; border-bottom: 1px solid #E0E0E0; padding-top: 10px; display: none;");
				var strDiv = ''+
					'<input type="hidden" name="perilSequenceNos" value="'+sequenceNo+'" />'+
					'<input type="hidden" name="perilItemNos" value="'+itemNo+'" />'+
					'<input type="hidden" name="perilCodes" value="'+perilCd+'" />'+
					'<input type="hidden" name="perilOrigPerilPremAmt" value="'+annPremAmt+'" />'+
					'<input type="hidden" name="perilDiscountAmts" value="'+discountAmt+'" />'+
					'<input type="hidden" name="perilDiscountRts" value="'+discountRt+'" />'+
					'<input type="hidden" name="perilSurchargeAmts" value="'+surchargeAmt+'" />'+
					'<input type="hidden" name="perilSurchargeRts" value="'+surchargeRt+'" />'+
					'<input type="hidden" name="perilNetGrossTags" value="'+grossTag+'" />'+
					'<input type="hidden" name="perilRemarks" value="'+remark+'" />' +	
					'<input type="hidden" name="perilNetPrem" value="'+ $F("premAmtPeril")+'" />';	
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
				strDiv += '<label style="width: 100px; text-align: left;" title="'+perilName+'">'+perilName.truncate(14, "...")+'</label>';			 	
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
				if ("Update" == $F("btnAddDiscountPeril")) {
					$$("div[name='rowPeril']").each(function (div) {
						if (div.hasClassName("selectedRow")) {
							newDiv = div;
						}
					});
					newDiv.update(strDiv);
					deletePerilDiscountSurcharge($F("origPerilDiscountAmt"), $F("origPerilSurchargeAmt"));
					distributePerilDiscountSurcharge();
				} else {
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
							$$("div[name='rowPeril']").each(function (r)	{
								if (newDiv.getAttribute("id") != r.getAttribute("id"))	{
									r.removeClassName("selectedRow");
								}	
						     });
							$$("div[name='rowBasic']").each(function (r)	{
								r.removeClassName("selectedRow");
								enableButton("btnAddDiscount");
								disableButton("btnDelDiscount");
						     });
							$$("div[name='rowItem']").each(function (r)	{
								r.removeClassName("selectedRow");
								enableButton("btnAddDiscountItem");
								disableButton("btnDelDiscountItem");
						     });
							$("sequenceNoPeril").value = newDiv.down("input", 0).value;
							$("itemNoPeril").value = newDiv.down("input", 1).value;
							changePeril();
							changePerilCd(newDiv.down("input", 2).value);
							//$("perilCodeSelect"+$("itemNoPeril").value).selectedIndex = newDiv.down("input", 2).value;
							$("premAmtPeril").value = formatCurrency(newDiv.down("input", 3).value);
							$("discountAmtPeril").value = formatCurrency(newDiv.down("input", 4).value);
							$("discountRtPeril").value = formatRate(newDiv.down("input", 5).value);
							$("surchargeAmtPeril").value = formatCurrency(newDiv.down("input", 6).value);
							$("surchargeRtPeril").value = formatRate(newDiv.down("input", 7).value);
							var gtag = newDiv.down("input", 8).value;
							if(gtag == 'G'){
								$("grossTagPeril").checked = true;
							}  else {
								$("grossTagPeril").checked = false;
							}
							$("remarkPeril").value = newDiv.down("input", 9).value;		
							showPerilButton(true);			
						} else {
							showPerilButton(false);
						}
						$("origPerilDiscountAmt").value = parseFloat($F("discountAmtPeril").replace(/,/g, ""));
						$("origPerilSurchargeAmt").value = parseFloat($F("surchargeAmtPeril").replace(/,/g, ""));
					});
					new Effect.Appear(newDiv, {
						duration: .2,
						afterFinish: function () {
							checkTableIfEmpty("rowPeril", "quotePerilDiscountTable");
						}
					});
				}
				resetGrossTags();	
				resetPerilDiscountForm();
			}
		});
	} else {
		$("btnDelDiscountPeril").observe("click", function ()	{
			showMessageBox("Buttons for item peril discounts are disabled since no\nItems/Perils are included in the quotation...");
		});
		$("btnAddDiscountPeril").observe("click", function ()	{
			showMessageBox("Buttons for item peril discounts are disabled since no\nItems/Perils are included in the quotation...");
		});
		$("btnEditDiscountPeril").observe("click", function ()	{
			showMessageBox("Buttons for item peril discounts are disabled since no\nItems/Perils are included in the quotation...");
		});
	}	

	$("itemNoPeril").observe("change", function ()	{
		changePeril();
		if($("perilCodeSelect"+ $("itemNoPeril").value)!= null){
			$("perilCodeSelect"+ $("itemNoPeril").value).observe("change", function ()	{
				$("perilPremAmtSelect"+$("itemNoPeril").value).selectedIndex = $("perilCodeSelect"+ $("itemNoPeril").value).selectedIndex;
				$("perilAnnPremAmtSelect"+$("itemNoPeril").value).selectedIndex = $("perilCodeSelect"+ $("itemNoPeril").value).selectedIndex;
				if ($("grossTagPeril").checked){
					$("premAmtPeril").value = formatCurrency($("perilAnnPremAmtSelect"+ $("itemNoPeril").value).value);
				} else{
					$("premAmtPeril").value = formatCurrency($("perilPremAmtSelect"+ $("itemNoPeril").value).value);
				}
			});	
		}
	});

	function changePeril(){
		var val = $("itemNoPeril").value;
		var perils = document.getElementsByName('perilCodeSelect');
		for(i = 0; i < perils.length; i++) {	
			if(perils[i].id == 'perilCodeSelect'+val){
		   		perils[i].show();   	
		   	} else {
		   		perils[i].hide();	
		   	}
		}
		if ($F("itemNoPeril").blank()){
			perils[0].show();
		}
	}

	function changePerilCd(param){
		var val = $("itemNoPeril").value;	
		var perils = $('perilCodeSelect'+val);	
		for(i = 0; i < perils.length; i++) {
			if(perils.options[i].value == param){
				perils.selectedIndex = i;				   	
		   	}
		}
	}

	function resetPerilDiscountForm() {
		$("sequenceNoPeril").value = "";
		$("itemNoPeril").selectedIndex = 0;
		changePeril();
		//changePerilCd(0);
		$("premAmtPeril").value = formatCurrency("0");//formatCurrency($("quoteAnnPremAmt").value);
		$("discountAmtPeril").value = formatCurrency("0");
		$("discountRtPeril").value = formatRate("0");
		$("surchargeAmtPeril").value = formatCurrency("0");
		$("surchargeRtPeril").value = formatRate("0");
		$("grossTagPeril").checked = true;				
		$("remarkPeril").value = "";

		$("btnAddDiscountPeril").value = "Add";

		disableButton("btnDelDiscountPeril");

		$$("div[name='rowPeril']").each(function (div) {
			div.removeClassName("selectedRow");
		});

		generateSequenceFromLastValue2();
	}
	
	function showPerilButton(param){
		if(param){			
			enableButton("btnDelDiscountPeril");
			disableButton("btnAddDiscountPeril");
		} else {
			resetPerilDiscountForm();
			enableButton("btnAddDiscountPeril");
		}
	}

	function distributePerilDiscountSurcharge(premAmt){
		var grossTag = $("grossTagPeril").checked==true?'G':'';
		var netItemPrem = parseFloat($("itemNo").options[$("itemNoPeril").selectedIndex].getAttribute("netPrem"));
		var discountAmtPeril = parseFloat($F("discountAmtPeril").replace(/,/g, ""));
		var surchargeAmtPeril = parseFloat($F("surchargeAmtPeril").replace(/,/g, ""));
		var rate = parseFloat($("itemNoPeril").options[$("itemNoPeril").selectedIndex].getAttribute("currRt"));
		var netPrem = Math.round(((parseFloat($("perilPremAmtSelect"+ $("itemNoPeril").value).options[$("perilCodeSelect"+$F("itemNoPeril")).selectedIndex].value) + parseFloat(surchargeAmtPeril)) - parseFloat(discountAmtPeril))*100)/100;
		$("perilPremAmtSelect"+ $("itemNoPeril").value).options[$("perilCodeSelect"+$F("itemNoPeril")).selectedIndex].value = netPrem;
		$("perilPremAmtSelect"+ $("itemNoPeril").value).options[$("perilCodeSelect"+$F("itemNoPeril")).selectedIndex].text = netPrem;
		$("perilPremAmtSelect"+ $("itemNoPeril").value).options[$("perilCodeSelect"+$F("itemNoPeril")).selectedIndex].setAttribute("netPrem", netPrem);
			
		$$("div[name='hiddenPerilDiv']").each(function(row){
			if ((parseInt($F("itemNoPeril")) == parseInt(row.down("input", 0).value)) ) {
				if (parseInt($("perilPremAmtSelect"+ $("itemNoPeril").value).options[$("perilCodeSelect"+$F("itemNoPeril")).selectedIndex].getAttribute("perilCd")) == parseInt(row.down("input", 1).value)) {
					row.down("input", 3).value = netPrem;//unformatCurrency("premAmtPeril");//(grossTag == 'G' ? netItemPrem : premAmt);
				}
			}
		});
		//set item premium amount 
		$("itemNo").options[$("itemNoPeril").selectedIndex].setAttribute("netPrem", (parseFloat(netItemPrem) + parseFloat($F("surchargeAmtPeril").replace(/,/g, "")) - parseFloat($F("discountAmtPeril").replace(/,/g, ""))));
		//set policy premium amount */
		$("quotePremAmt").value = (parseFloat(nvl($F("quotePremAmt"),"0")) + (Math.round(((parseFloat($F("surchargeAmtPeril").replace(/,/g, "")) * parseFloat(rate)))*100)/100) ) -  (Math.round(((parseFloat($F("discountAmtPeril").replace(/,/g, "")) * parseFloat(rate)))*100)/100);
	}

	function deletePerilDiscountSurcharge(discount, surcharge){
		var netItemPrem = parseFloat($("itemNo").options[$("itemNoPeril").selectedIndex].getAttribute("netPrem"));
		var discountAmtPeril = parseFloat($F("discountAmtPeril").replace(/,/g, ""));
		var surchargeAmtPeril = parseFloat($F("surchargeAmtPeril").replace(/,/g, ""));
		var rate = $("itemNoPeril").options[$("itemNoPeril").selectedIndex].getAttribute("currRt");
		var netPrem = (parseFloat($("perilPremAmtSelect"+ $("itemNoPeril").value).options[$("perilCodeSelect"+$F("itemNoPeril")).selectedIndex].value) - parseFloat(surchargeAmtPeril)) + parseFloat(discountAmtPeril); 

		netPrem = Math.round(parseFloat(netPrem)*100)/100;
		$("perilPremAmtSelect"+ $("itemNoPeril").value).options[$("perilCodeSelect"+$F("itemNoPeril")).selectedIndex].value = netPrem;
		$("perilPremAmtSelect"+ $("itemNoPeril").value).options[$("perilCodeSelect"+$F("itemNoPeril")).selectedIndex].text = netPrem;
		$("perilPremAmtSelect"+ $("itemNoPeril").value).options[$("perilCodeSelect"+$F("itemNoPeril")).selectedIndex].setAttribute("netPrem", netPrem);

		$$("div[name='hiddenPerilDiv']").each(function(row){
			if ((parseInt($F("itemNoPeril")) == parseInt(row.down("input", 0).value)) ) {
				if (parseInt($("perilPremAmtSelect"+ $("itemNoPeril").value).options[$("perilCodeSelect"+$F("itemNoPeril")).selectedIndex].getAttribute("perilCd")) == parseInt(row.down("input", 1).value)) {
					row.down("input", 3).value = netPrem;
				}
			}
		});
		
		$("itemNo").options[$("itemNoPeril").selectedIndex].setAttribute("netPrem", (parseFloat(netItemPrem) - parseFloat($F("surchargeAmtPeril").replace(/,/g, ""))) + parseFloat($F("discountAmtPeril").replace(/,/g, ""))); 
		$("quotePremAmt").value = (parseFloat($F("quotePremAmt")) - (Math.round(((parseFloat($F("surchargeAmtPeril").replace(/,/g, "")) * parseFloat(rate)))*100)/100) ) + (Math.round(((parseFloat($F("discountAmtPeril").replace(/,/g, "")) * parseFloat(rate)))*100)/100);
	}	

	function validatePerilEntries(){
		var isValid = true;
		
		if ($("itemNoPeril").selectedIndex == 0 || $("perilPremAmtSelect"+ $("itemNoPeril").value).selectedIndex == 0){
			showMessageBox("Please select an Item and Peril Name first.", imgMessage.ERROR);
			isValid = false;
		}else if ( (unformatCurrency("discountAmtPeril") > 0 && parseFloat($F("discountRtPeril")) == 0) ) {
			showMessageBox("Invalid Discount Rate. Value should be from 0.0000 to 100.0000.", imgMessage.ERROR);  
			isValid = false;
		} else if ( (unformatCurrency("discountAmtPeril") == 0 && parseFloat($F("discountRtPeril")) > 0) || ( (unformatCurrency("discountAmtPeril") == 0 && parseFloat($F("discountRtPeril")) == 0) && (unformatCurrency("surchargeAmtPeril") == 0 && parseFloat($F("surchargeRtPeril")) == 0)) ){
			showMessageBox("Invalid Discount Amount. Value should be greater than 0.00 but not greater than Net Premium Amount.", imgMessage.ERROR);  
			isValid = false;
		} else if ( (unformatCurrency("surchargeAmtPeril") == 0 && parseFloat($F("surchargeRtPeril")) > 0) ){
			showMessageBox("Invalid Surcharge Amount. Value should be greater than 0.00 but not greater than Net Premium Amount.", imgMessage.ERROR);  
			isValid = false;
		} else if ( (unformatCurrency("surchargeAmtPeril") > 0 && parseFloat($F("surchargeRtPeril")) == 0) ){
			showMessageBox("Invalid Discount Rate. Value should be from 0.0000 to 100.0000.", imgMessage.ERROR);  
			isValid = false;
		}
		
		return isValid;
	}
	changePeril();
	generateSequenceFromLastValue2();

</script>