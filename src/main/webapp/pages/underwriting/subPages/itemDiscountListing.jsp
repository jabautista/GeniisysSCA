<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<input type="hidden" id="origSeqNoItem" name="origSeqNoItem" value=""/>
<c:forEach var="item" items="${listItem}">
	<div id="rowItem${item.sequenceNo}" name="rowItem" class="tableRow">
		<input type='hidden' name="itemSequenceNos" value="${item.sequenceNo}" />
		<input type='hidden' name="itemItemNos" value="${item.itemNo}" />
		<input type='hidden' name="itemItemTitles" value="${item.itemTitle}" />
		<input type='hidden' name="itemNetPremAmts" value="${item.netPremAmt}" />
		<input type='hidden' name="itemDiscountAmts" value="${item.discountAmt}" />
		<input type='hidden' name="itemDiscountRts" value="${item.discountRt}" />
		<input type='hidden' name="itemSurchargeAmts" value="${item.surchargeAmt}" />
		<input type='hidden' name="itemSurchargeRts" value="${item.surchargeRt}" />
		<input type='hidden' name="itemNetGrossTags" value="${item.netGrossTag}" />
		<input type='hidden' name="itemRemarks" value="${item.remarks}" />	
		<input type='hidden' name="itemOrigPremAmts" value="${item.origPremAmt}" />	
		<label style="width: 120px; text-align: center;">${item.sequenceNo}
		<c:if test="${empty item.sequenceNo}">-</c:if></label>
		<label style="width: 100px; text-align: right;">
		<fmt:formatNumber pattern="#,###.####" minFractionDigits="2">${item.netPremAmt}</fmt:formatNumber>		
		<c:if test="${empty item.netPremAmt}">-</c:if></label>
		<label style="width: 100px; text-align: center;">
		${item.itemNo}
		</label>
		<label style="width: 100px; text-align: left;">
		${item.itemTitle}<c:if test="${empty item.itemTitle}">-</c:if>
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
			<label style="width: 47px; text-align: center;">
				<img style="width: 10px; height: 10px;" name="checkedImg" />
			</label>
		</c:if>		
	</div>
</c:forEach>

<script>
try{
	var billItemsJSON = JSON.parse('${billItemsJSON}'.replace(/\\/g, '\\\\')); //added by steven 10/01/2012
	var selectedRowId = '';
	objUW.hid2GIPIS143 = {}; //added by steven 10/01/2012
	objUW.hid2GIPIS143.perilSelected = false;
	$$("div[name='rowItem']").each(
		function (row)	{
			row.observe("mouseover", function ()	{
				row.addClassName("lightblue");
			});
			row.observe("mouseout", function ()	{
				row.removeClassName("lightblue");
			});
			row.observe("click", function ()	{
				resetBasicDiscountForm1();
				resetPerilDiscountForm();
				selectedRowId = row.getAttribute("id");
				row.toggleClassName("selectedRow");
				if (row.hasClassName("selectedRow"))	{
					$$("div[name='rowItem']").each(function (r)	{
						if (row.getAttribute("id") != r.getAttribute("id"))	{
							r.removeClassName("selectedRow");
						}	
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
					$("origPremAmtItem").value = row.down("input", 10).value;	
					showItemButton(true);
					isLastRecordItem(row.down("input", 0).value);				
				} else {
					resetItemDiscountForm();
					showItemButton(false);
					objUW.hid2GIPIS143.perilSelected = false;
				}	    
			});			
		}	
	);

	$$("div[name='rowItem']").each(function (div)	{
		if ((div.down("label", 3).innerHTML).length > 18)	{
			div.down("label", 3).update((div.down("label", 3).innerHTML).truncate(18, "..."));
		}
	});
	if(billItemsJSON.length > 0){ //change by steven 10/01/2012 from: $('itemNo').length>1
		$("btnDelDiscountItem").observe("click", function ()	{
			var seqNoForm = $("hiddenSequence").value; 
			if ($F("sequenceNoItem") != seqNoForm - 1){
				showMessageBox("Deleting of this record is not allowed. Last Sequence should be deleted first.", imgMessage.ERROR);
				return;
			}
			
			$$("div[name='rowItem']").each(function (row)	{
				if (row.hasClassName("selectedRow"))	{
					Effect.Fade(row, {
						duration: .2,
						afterFinish: function ()	{
							changeTag = 1;
							row.remove();		
							resetBasicDiscountForm1();
							resetItemDiscountForm();
							resetPerilDiscountForm();
							checkIfToResizeTable("billItemDiscountTableList", "rowItem");
							checkTableIfEmpty("rowItem", "billItemDiscountTable");
							showItemButton(false);			
						}
					});
				}
			});
		});
		
		$("btnAddDiscountItem").observe("click", function(){
			if (validateItemAdd()) {
				if ($$("div[name='rowItem']").size()>0){
					var seqNoLR = "Update" == $F("btnAddDiscountItem") ? $F("sequenceNoItem") :$$("div[name='rowItem']").last().id.substring(7);
					var divIdLR = $("rowItem"+seqNoLR);
					var itemNoLR = divIdLR.down("input", 1).value;
					var grossTagLR = divIdLR.down("input", 8).value;
					var itemNoSeL = $("itemNo").value;
					var grossTagSel = $("grossTagItem").checked;
					if (itemNoSeL == itemNoLR) {
						if ($F("btnAddDiscountItem") =="Update"){ //added by steven 10/03/2012 for update
							onUpdateFunc();								
						}else{
							if ((grossTagLR == "G") && (grossTagSel)){
								showConfirmBox4("Message", "Is this a new discount/surcharge or you want to add this to the previous discount/surcharge?",  
										"New", "Add", "Cancel", onNewFunc, onAddFunc,"");
							} else {
								onNewFunc();
							}	
						}
					} else {
						onNewFunc();
					}
				} else {
					onNewFunc();
				}
				changeTag = 1;	
			}

			function onAddFunc() {
				try{
					var sequenceNoAdd = divIdLR.down("input", 0).value;
					var itemNoAdd = $F("itemNo").blank()?'-':$F("itemNo");
					var itemTitleAdd = $F("itemTitle").blank()?'-':changeSingleAndDoubleQuotes2($F("itemTitle"));
					var premAmtAdd = formatCurrency($F("premAmtItem"));
					var origPremAmtAdd = formatCurrency($F("origPremAmtItem"));
					var discountAmtAdd = divIdLR.down("input", 4).value.replace(/,/g, "")=="" && $F("discountAmtItem").replace(/,/g, "")=="" ? "" :parseFloat(nvl(divIdLR.down("input", 4).value.replace(/,/g, ""),0)) + parseFloat(nvl($F("discountAmtItem").replace(/,/g, ""),0));
					var discountRtAdd = divIdLR.down("input", 5).value.replace(/,/g, "")=="" && $F("discountRtItem").replace(/,/g, "")=="" ? "" :parseFloat(nvl(divIdLR.down("input", 5).value.replace(/,/g, ""),0)) + parseFloat(nvl($F("discountRtItem").replace(/,/g, ""),0));
					var surchargeAmtAdd = divIdLR.down("input", 6).value.replace(/,/g, "")=="" && $F("surchargeAmtItem").replace(/,/g, "")=="" ? "" :parseFloat(nvl(divIdLR.down("input", 6).value.replace(/,/g, ""),0)) + parseFloat(nvl($F("surchargeAmtItem").replace(/,/g, ""),0));
					var surchargeRtAdd = divIdLR.down("input", 7).value.replace(/,/g, "")==""&& $F("surchargeRtItem").replace(/,/g, "")=="" ? "" :parseFloat(nvl(divIdLR.down("input", 7).value.replace(/,/g, ""),0)) + parseFloat(nvl($F("surchargeRtItem").replace(/,/g, ""),0));
					var grossTagAdd = $("grossTagItem").checked==true?'G':'';
					var remarkAdd = changeSingleAndDoubleQuotes2(divIdLR.down("input", 9).value);
	
					if (parseFloat(discountAmtAdd) > parseFloat($F("premAmtItem").replace(/,/g, ""))) {
						customShowMessageBox("Discount amount greater than the premium amount is not allowed.", imgMessage.ERROR, "discountAmtItem");
						return false;
					}
					if (parseFloat(surchargeAmtAdd) > parseFloat($F("premAmtItem").replace(/,/g, ""))) {
						customShowMessageBox("Surcharge amount greater than the premium amount is not allowed.", imgMessage.ERROR, "surchargeAmtItem");
						return false;
					}
					
					var strDiv = ''+
						'<input type="hidden" name="itemSequenceNos" value="'+sequenceNoAdd+'" />'+
						'<input type="hidden" name="itemItemNos" value="'+itemNoAdd+'" />'+
						'<input type="hidden" name="itemTitles" value="'+itemTitleAdd+'" />'+
						'<input type="hidden" name="itemNetPremAmts" value="'+premAmtAdd+'" />'+
						'<input type="hidden" name="itemDiscountAmts" value="'+discountAmtAdd+'" />'+
						'<input type="hidden" name="itemDiscountRts" value="'+discountRtAdd+'" />'+
						'<input type="hidden" name="itemSurchargeAmts" value="'+surchargeAmtAdd+'" />'+
						'<input type="hidden" name="itemSurchargeRts" value="'+surchargeRtAdd+'" />'+
						'<input type="hidden" name="itemNetGrossTags" value="'+grossTagAdd+'" />'+
						'<input type="hidden" name="itemRemarks" value="'+remarkAdd+'" />'+
						'<input type="hidden" name="itemOrigPremAmts" value="'+origPremAmtAdd+'" />';	
					if(nvl(sequenceNoAdd,'-') != '-'){
						strDiv += '<label style="width: 120px; text-align: center;">'+sequenceNoAdd+'</label>';
					} else {
						strDiv += '<label style="width: 120px; text-align: center;">-</label>';
					}	
					if(nvl(premAmtAdd,'-') != '-'){
						strDiv += '<label style="width: 100px; text-align: right;">'+
						formatCurrency(premAmtAdd)+'</label>';
					} else {
						strDiv += '<label style="width: 100px; text-align: right;">-</label>';
					}
					strDiv += '<label style="width: 100px; text-align: center;">'+itemNoAdd+'</label>';
					strDiv += '<label style="width: 100px; text-align: left;">'+itemTitleAdd.truncate(13, "...")+'</label>';			 	
					if(nvl(discountAmtAdd,'-') != '-'){
						strDiv += '<label style="width: 100px; text-align: right;">'+
						formatCurrency(discountAmtAdd)+'</label>';
					} else {
						strDiv += '<label style="width: 100px; text-align: right;">-</label>';
					}			
					if(nvl(discountRtAdd,'-') != '-'){
						strDiv += '<label style="width: 100px; text-align: right;">'+
						formatRate(discountRtAdd)+'</label>';
					} else {
						strDiv += '<label style="width: 100px; text-align: right;">-</label>';
					}	
					if(nvl(surchargeAmtAdd,'-') != '-'){
						strDiv += '<label style="width: 100px; text-align: right;">'+
						formatCurrency(surchargeAmtAdd)+'</label>';
					} else {
						strDiv += '<label style="width: 100px; text-align: right;">-</label>';
					}			
					if(nvl(surchargeRtAdd,'-') != '-'){
						strDiv += '<label style="width: 100px; text-align: right;">'+
						formatRate(surchargeRtAdd)+'</label>';
					} else {
						strDiv += '<label style="width: 100px; text-align: right;">-</label>';
					}	
					strDiv += '<label style="width: 50px; text-align: center;"><img style="width: 10px; height: 10px;" ';
					if(grossTagAdd == 'G'){
						strDiv += 'name="checkedImg" src="'+checkImgSrc+'"';
					}	
					strDiv += '></img></label>';
					divIdLR.update(strDiv);
					
					resetBasicDiscountForm1();
					resetItemDiscountForm();
					resetPerilDiscountForm();
					checkIfToResizeTable("billItemDiscountTableList", "rowItem"); 
				}catch (e) {
					showErrorMessage("onAddFunc", e);
				}
			}
			
			//added by steven 10/03/2012 for update
			function onUpdateFunc() {
				try{
					var sequenceNoAdd = divIdLR.down("input", 0).value;
					var itemNoAdd = $F("itemNo").blank()?'-':$F("itemNo");
					var itemTitleAdd = $F("itemTitle").blank()?'-':changeSingleAndDoubleQuotes2($F("itemTitle"));
					var premAmtAdd = formatCurrency($F("premAmtItem"));
					var origPremAmtAdd = formatCurrency($F("origPremAmtItem"));
					var discountAmtAdd = divIdLR.down("input", 4).value.replace(/,/g, "")=="" && $F("discountAmtItem").replace(/,/g, "")=="" ? "" :parseFloat(nvl($F("discountAmtItem").replace(/,/g, ""),0));
					var discountRtAdd = divIdLR.down("input", 5).value.replace(/,/g, "")=="" && $F("discountRtItem").replace(/,/g, "")=="" ? "" :parseFloat(nvl($F("discountRtItem").replace(/,/g, ""),0));
					var surchargeAmtAdd = divIdLR.down("input", 6).value.replace(/,/g, "")=="" && $F("surchargeAmtItem").replace(/,/g, "")=="" ? "" :parseFloat(nvl($F("surchargeAmtItem").replace(/,/g, ""),0));
					var surchargeRtAdd = divIdLR.down("input", 7).value.replace(/,/g, "")==""&& $F("surchargeRtItem").replace(/,/g, "")=="" ? "" :parseFloat(nvl($F("surchargeRtItem").replace(/,/g, ""),0));
					var grossTagAdd = $("grossTagItem").checked==true?'G':'';
					var remarkAdd = changeSingleAndDoubleQuotes2(divIdLR.down("input", 9).value);
	
					if (parseFloat(discountAmtAdd) > parseFloat($F("premAmtItem").replace(/,/g, ""))) {
						customShowMessageBox("Discount amount greater than the premium amount is not allowed.", imgMessage.ERROR, "discountAmtItem");
						return false;
					}
					if (parseFloat(surchargeAmtAdd) > parseFloat($F("premAmtItem").replace(/,/g, ""))) {
						customShowMessageBox("Surcharge amount greater than the premium amount is not allowed.", imgMessage.ERROR, "surchargeAmtItem");
						return false;
					}
					
					var strDiv = ''+
						'<input type="hidden" name="itemSequenceNos" value="'+sequenceNoAdd+'" />'+
						'<input type="hidden" name="itemItemNos" value="'+itemNoAdd+'" />'+
						'<input type="hidden" name="itemTitles" value="'+itemTitleAdd+'" />'+
						'<input type="hidden" name="itemNetPremAmts" value="'+premAmtAdd+'" />'+
						'<input type="hidden" name="itemDiscountAmts" value="'+discountAmtAdd+'" />'+
						'<input type="hidden" name="itemDiscountRts" value="'+discountRtAdd+'" />'+
						'<input type="hidden" name="itemSurchargeAmts" value="'+surchargeAmtAdd+'" />'+
						'<input type="hidden" name="itemSurchargeRts" value="'+surchargeRtAdd+'" />'+
						'<input type="hidden" name="itemNetGrossTags" value="'+grossTagAdd+'" />'+
						'<input type="hidden" name="itemRemarks" value="'+remarkAdd+'" />'+
						'<input type="hidden" name="itemOrigPremAmts" value="'+origPremAmtAdd+'" />';	
					if(nvl(sequenceNoAdd,'-') != '-'){
						strDiv += '<label style="width: 120px; text-align: center;">'+sequenceNoAdd+'</label>';
					} else {
						strDiv += '<label style="width: 120px; text-align: center;">-</label>';
					}	
					if(nvl(premAmtAdd,'-') != '-'){
						strDiv += '<label style="width: 100px; text-align: right;">'+
						formatCurrency(premAmtAdd)+'</label>';
					} else {
						strDiv += '<label style="width: 100px; text-align: right;">-</label>';
					}
					strDiv += '<label style="width: 100px; text-align: center;">'+itemNoAdd+'</label>';
					strDiv += '<label style="width: 100px; text-align: left;">'+itemTitleAdd.truncate(13, "...")+'</label>';			 	
					if(nvl(discountAmtAdd,'-') != '-'){
						strDiv += '<label style="width: 100px; text-align: right;">'+
						formatCurrency(discountAmtAdd)+'</label>';
					} else {
						strDiv += '<label style="width: 100px; text-align: right;">-</label>';
					}			
					if(nvl(discountRtAdd,'-') != '-'){
						strDiv += '<label style="width: 100px; text-align: right;">'+
						formatRate(discountRtAdd)+'</label>';
					} else {
						strDiv += '<label style="width: 100px; text-align: right;">-</label>';
					}	
					if(nvl(surchargeAmtAdd,'-') != '-'){
						strDiv += '<label style="width: 100px; text-align: right;">'+
						formatCurrency(surchargeAmtAdd)+'</label>';
					} else {
						strDiv += '<label style="width: 100px; text-align: right;">-</label>';
					}			
					if(nvl(surchargeRtAdd,'-') != '-'){
						strDiv += '<label style="width: 100px; text-align: right;">'+
						formatRate(surchargeRtAdd)+'</label>';
					} else {
						strDiv += '<label style="width: 100px; text-align: right;">-</label>';
					}	
					strDiv += '<label style="width: 50px; text-align: center;"><img style="width: 10px; height: 10px;" ';
					if(grossTagAdd == 'G'){
						strDiv += 'name="checkedImg" src="'+checkImgSrc+'"';
					}	
					strDiv += '></img></label>';
					divIdLR.update(strDiv);
					
					resetBasicDiscountForm1();
					resetItemDiscountForm();
					resetPerilDiscountForm();
					checkIfToResizeTable("billItemDiscountTableList", "rowItem"); 
				}catch (e) {
					showErrorMessage("onUpdateFunc", e);
				}
			}
			
			function onNewFunc(){
				try{
					var sequenceNo = $F("sequenceNoItem");
					var itemNo = $F("itemNo").blank()?'-':$F("itemNo");
					var itemTitle = $F("itemTitle").blank()?'-':changeSingleAndDoubleQuotes2($F("itemTitle"));
					var premAmt = formatCurrency($F("premAmtItem"));
					var origPremAmt = formatCurrency($F("origPremAmtItem"));
					var discountAmt = formatCurrency($F("discountAmtItem"));
					var discountRt = formatRate($F("discountRtItem"));
					var surchargeAmt = formatCurrency($F("surchargeAmtItem"));
					var surchargeRt = formatRate($F("surchargeRtItem"));
					var grossTag = $("grossTagItem").checked==true?'G':'';
					var remark = changeSingleAndDoubleQuotes2($F("remarkItem"));
					var itemTable = $("billItemDiscountTableList");
	
					var newDiv = new Element("div");
					newDiv.setAttribute("id", "rowItem"+sequenceNo);
					newDiv.setAttribute("name", "rowItem");
					newDiv.setStyle("height: 20px; border-bottom: 1px solid #E0E0E0; padding-top: 10px; display: none;");
				
					var strDiv = ''+
						'<input type="hidden" name="itemSequenceNos" value="'+sequenceNo+'" />'+
						'<input type="hidden" name="itemItemNos" value="'+itemNo+'" />'+
						'<input type="hidden" name="itemTitles" value="'+itemTitle+'" />'+
						'<input type="hidden" name="itemNetPremAmts" value="'+premAmt+'" />'+
						'<input type="hidden" name="itemDiscountAmts" value="'+discountAmt+'" />'+
						'<input type="hidden" name="itemDiscountRts" value="'+discountRt+'" />'+
						'<input type="hidden" name="itemSurchargeAmts" value="'+surchargeAmt+'" />'+
						'<input type="hidden" name="itemSurchargeRts" value="'+surchargeRt+'" />'+
						'<input type="hidden" name="itemNetGrossTags" value="'+grossTag+'" />'+
						'<input type="hidden" name="itemRemarks" value="'+remark+'" />'+
						'<input type="hidden" name="itemOrigPremAmts" value="'+origPremAmt+'" />';	
					if(nvl(sequenceNo,'-') != '-'){
						strDiv += '<label style="width: 120px; text-align: center;">'+sequenceNo+'</label>';
					} else {
						strDiv += '<label style="width: 120px; text-align: center;">-</label>';
					}	
					if(nvl(premAmt,'-') != '-'){
						strDiv += '<label style="width: 100px; text-align: right;">'+
						formatCurrency(premAmt)+'</label>';
					} else {
						strDiv += '<label style="width: 100px; text-align: right;">-</label>';
					}
					strDiv += '<label style="width: 100px; text-align: center;">'+itemNo+'</label>';
					strDiv += '<label style="width: 100px; text-align: left;">'+(itemTitle).truncate(13, "...")+'</label>';			 	
					if(nvl(discountAmt,'-') != '-'){
						strDiv += '<label style="width: 100px; text-align: right;">'+
						formatCurrency(discountAmt)+'</label>';
					} else {
						strDiv += '<label style="width: 100px; text-align: right;">-</label>';
					}			
					if(nvl(discountRt,'-') != '-'){
						strDiv += '<label style="width: 100px; text-align: right;">'+
						formatRate(discountRt)+'</label>';
					} else {
						strDiv += '<label style="width: 100px; text-align: right;">-</label>';
					}	
					if(nvl(surchargeAmt,'-') != '-'){
						strDiv += '<label style="width: 100px; text-align: right;">'+
						formatCurrency(surchargeAmt)+'</label>';
					} else {
						strDiv += '<label style="width: 100px; text-align: right;">-</label>';
					}			
					if(nvl(surchargeRt,'-') != '-'){
						strDiv += '<label style="width: 100px; text-align: right;">'+
						formatRate(surchargeRt)+'</label>';
					} else {
						strDiv += '<label style="width: 100px; text-align: right;">-</label>';
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
							resetBasicDiscountForm1();
							resetPerilDiscountForm();
							selectedRowId = newDiv.getAttribute("id");
							newDiv.toggleClassName("selectedRow");
							if (newDiv.hasClassName("selectedRow"))	{
								$$("div[name='rowItem']").each(function (r)	{
									if (newDiv.getAttribute("id") != r.getAttribute("id"))	{
										r.removeClassName("selectedRow");
									}	
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
								$("origPremAmtItem").value = newDiv.down("input", 10).value;
								showItemButton(true);	
								isLastRecordItem(newDiv.down("input", 0).value);
							} else {
								showItemButton(false);
							}
						});
	
						new Effect.Appear(newDiv, {
							duration: .2, 
							afterFinish: function () {
								checkTableIfEmpty("rowItem", "billItemDiscountTable");
							}
						});
					}
					resetBasicDiscountForm1();
					resetItemDiscountForm();
					resetPerilDiscountForm();
					checkIfToResizeTable("billItemDiscountTableList", "rowItem"); 
				}catch (e) {
					showErrorMessage("onNewFunc", e);
				}
			}	
		});
		
	} else {
		$("btnDelDiscountItem").observe("click", function ()	{
			showMessageBox("Buttons for item discounts are disabled since no\nItems are included in the policy/PAR...");
		});
		$("btnAddDiscountItem").observe("click", function ()	{
			showMessageBox("Buttons for item discounts are disabled since no\nItems are included in the policy/PAR...");
		});
		checkIfToResizeTable("billItemDiscountTableList", "rowItem"); 
	}

// 	$("itemNo").observe("change", function(){
	function checkItemNo() {	//change by steven to function
		try{
			$("grossTagItem").checked = true;
// 			$('itemTitle').value = $("itemNo").options[$("itemNo").selectedIndex].getAttribute("itemTitle");
			var rowItem = $$("div[name='rowItem']").size();
			var itemNo1 = $("itemNo").value;
			var origPremList = $("origPremAmtList");
			var exist = "N";
			if (rowItem>0){
				for(var i = 1; i < rowItem+1; i++) {			
		    		if($('rowItem'+i)){
		    			var row = $('rowItem'+i);		 
						itemNo2 = row.down("input", 1).value;
						if (itemNo2 == itemNo1){
							exist = "Y";
							break;
						}			
		    		}
		   	 	}
				if (exist == "Y"){
					$("premAmtItem").value = formatCurrency(row.down("input", 10).value);
					$("origPremAmtItem").value = formatCurrency(row.down("input", 10).value);	
				} else {
					updateItemNetPremAmt();	
				}
		    } else {
		    	updateItemNetPremAmt();
		    }   
		}catch (e) {
			showErrorMessage("itemNo change event", e);
		} 
	}

	function validateItemAdd() {
		try{
			var result = true;
			if($("itemNo").value == 0) {
				customShowMessageBox("Please select an item first.", imgMessage.ERROR, "itemNo");
				result = false;
				return false;
			}else if (($("discountAmtItem").value == "0.00" || $("discountAmtItem").value == "") && ($("surchargeAmtItem").value == "0.00" || $("surchargeAmtItem").value == "")){
				showMessageBox("Please enter complete information before proceeding to the next record.");
				result = false;
				return false;
			}else if (parseFloat($F("discountAmtItem").replace(/,/g, "")) > parseFloat($F("premAmtItem").replace(/,/g, ""))) {
				customShowMessageBox("Discount amount greater than the premium amount is not allowed.", imgMessage.ERROR, "discountAmtItem");
				result = false;
				return false;
			}else if (parseFloat($F("surchargeAmtItem").replace(/,/g, "")) > parseFloat($F("premAmtItem").replace(/,/g, ""))) {
				customShowMessageBox("Surcharge amount greater than the premium amount is not allowed.", imgMessage.ERROR, "surchargeAmtItem");
				result = false;
				return false;
			}else{
				if ($F("discountAmtItem").replace(/,/g, "") != "" && $F("itemNo") != "0"){
					function ok(){
						$("discountAmtItem").focus();
						clearPreTextValue("discountAmtItem");
					}	
					createTempItem();
					var validate = validateDiscSurcAmtItem();
					if (validate=="1"){
						showWaitingMessageBox("Invalid discount amount. Value should be greater than 0.00 but not greater than Premium Amount and should not result to a Net Premium Amount greater than TSI Amount.", imgMessage.ERROR, ok);
						result = false;
						return false;
					}else if (validate=="2"){
						showWaitingMessageBox("Cannot add discount. Adding of discount will result to a negative Peril/s.", imgMessage.ERROR, ok);
						result = false;
						return false;
					}		
					
					$$("div[name='rowItemTempOnly']").each(function(row){
						row.remove();		 
					});
				}	
				if ($F("surchargeAmtItem").replace(/,/g, "") != "" && $F("itemNo") != "0"){
					function ok(){
						$("surchargeAmtItem").focus();
						clearPreTextValue("surchargeAmtItem");
					}
					createTempItem();
					var validate = validateDiscSurcAmtItem();
					if (validate=="1"){
						showWaitingMessageBox("Invalid surcharge amount. Value should be greater than 0.00 but not greater than Premium Amount and should not result to a Net Premium Amount greater than TSI Amount.", imgMessage.ERROR, ok);
						result = false;
						return false;
					}else if (validate=="2"){
						showWaitingMessageBox("Cannot add surcharge. Adding of surcharge will result to a negative Peril/s.", imgMessage.ERROR, ok);
						result = false;
						return false;
					}		
					
					$$("div[name='rowItemTempOnly']").each(function(row){
						row.remove();		 
					});
				}
			}	
			return result;	
		}catch (e) {
			showErrorMessage("validateItemAdd", e);
		}
	}

	function updateItemNetPremAmt(){
		try{
			var itemNo1 = $("itemNo").value;
			if (itemNo1 != 0) {
				new Ajax.Updater("message", contextPath+"/GIPIParDiscountController",{
					parameters:{
						parId: $("parId").value,
						lineCd: $("lineCd").value,
						itemNo: itemNo1,
						action: "getOrigItemPremAmt"
						},
					asynchronous: false,
					evalScripts: true,
// 					onCreate: function () {
// 						$("premAmtItem").up("td", 0).update("<span id='refSpan' style='font-size: 9px;'>Refreshing...</span>");
// 						},
					onComplete: function (response)	{
						if (checkErrorOnResponse(response)) {
// 							$("refSpan").up("td", 0).update("<input id='premAmtItem' style='width: 210px;' type='text' value='' class='money' readonly='readonly'/></td>");
							var text = response.responseText;
							var arr = text.split(',');
							$("origPremAmtItem").value = formatCurrency(arr[0]);
							$("premAmtItem").value = formatCurrency(arr[1]);
						}else{
							showMessageBox(response.responseText, imgMessage.ERROR);
						}	
					}
				});
			} else {
				resetItemDiscountForm();
			}
		}catch (e) {
			showErrorMessage("updateItemNetPremAmt", e);
		}
	}	

	function isLastRecordItem(seqNoSelect) {
		try{
			var seqNoSelect = seqNoSelect;
			var seqNoForm = $("hiddenSequence").value; 
			if (seqNoSelect == seqNoForm - 1){
				$("sequenceNoItem").enable();
				$("grossTagItem").enable();
				$("discountAmtItem").enable();
				$("premAmtItem").enable();
				$("discountRtItem").enable();
				$("itemNo").enable();
				$("surchargeAmtItem").enable();
				$("itemTitle").enable();
				$("surchargeRtItem").enable();
				$("remarkItem").enable();
 				enableButton("btnAddDiscountItem");  //change by steven 10/02/2012 from disableButton
				enableButton("btnDelDiscountItem");
				objUW.hid2GIPIS143.perilSelected = false;
			} else {
				$("sequenceNoItem").disable();
				$("grossTagItem").disable();
				$("discountAmtItem").disable();
				$("premAmtItem").disable();
				$("discountRtItem").disable();
				$("itemNo").disable();
				$("surchargeAmtItem").disable();
				$("itemTitle").disable();
				$("surchargeRtItem").disable();
				$("remarkItem").disable();
				disableButton("btnAddDiscountItem"); 
				enableButton("btnDelDiscountItem");
				objUW.hid2GIPIS143.perilSelected = true;
			}
			disableSearch("searchItemImg");		//added by steven 10/01/2012
		}catch (e) {
			showErrorMessage("isLastRecordItem", e);
		}
	}	
	
	function showItemButton(param){
		try{
			if (param) {
				$("btnAddDiscountItem").value = "Update";	//change by steven 10/02/2012 from "Add" //$("btnAddDiscountItem").value = "Update";
				enableButton("btnAddDiscountItem");			//change by steven 10/02/2012 from disableButton
				enableButton("btnDelDiscountItem");
			} else {
				resetItemDiscountForm();
			}
		}catch (e) {
			showErrorMessage("showItemButton", e);
		}
	}
	objUW.hid2GIPIS143.checkItemNo = checkItemNo; //added by steven
	generateSequenceGIPIS143(); //generateSequence("rowItem", "sequenceNoItem");
}catch (e) {
	showErrorMessage("itemDiscountListing.jsp", e);
	//showMessageBox("Item discount listing - "+e.message, imgMessage.ERROR);
}	
</script>
