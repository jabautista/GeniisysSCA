<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<input type="hidden" id="origSeqNoPeril" name="origSeqNoPeril" value="" />
<c:forEach var="peril" items="${listPeril}">
	<div id="rowPeril${peril.sequenceNo}" name="rowPeril" class="tableRow">
	<input type='hidden' name="perilSequenceNos"
		value="${peril.sequenceNo}" /> <input type='hidden'
		name="perilItemNos" value="${peril.itemNo}" /> <input type='hidden'
		name="perilCodes" value="${peril.perilCd}" /> <input type='hidden'
		name="perilLevelTags" value="${peril.levelTag}" /> <input
		type='hidden' name="perilNetPremAmts" value="${peril.netPremAmt}" />
	<input type='hidden' name="perilDiscountAmts"
		value="${peril.discountAmt}" /> <input type='hidden'
		name="perilDiscountRts" value="${peril.discountRt}" /> <input
		type='hidden' name="perilSurchargeAmts" value="${peril.surchargeAmt}" />
	<input type='hidden' name="perilSurchargeRts"
		value="${peril.surchargeRt}" /> <input type='hidden'
		name="perilNetGrossTags" value="${peril.netGrossTag}" /> <input
		type='hidden' name="perilRemarks" value="${peril.remarks}" /> <input
		type='hidden' name="perilOrigPerilPremAmt"
		value="${peril.origPerilPremAmt}" /> <input type='hidden'
		name="perilOrigPerilAnnPremAmt" value="${peril.origPerilAnnPremAmt}" />
	<input type='hidden' name="perilOrigItemAnnPremAmt"
		value="${peril.origItemAnnPremAmt}" /> <input type='hidden'
		name="perilOrigPolAnnPremAmt" value="${peril.origPolAnnPremAmt}" /> <label
		style="width: 120px; text-align: center;">${peril.sequenceNo}
	<c:if test="${empty peril.sequenceNo}">-</c:if></label> <label
		style="width: 100px; text-align: right;"> <fmt:formatNumber
		pattern="#,###.####" minFractionDigits="2">${peril.netPremAmt}</fmt:formatNumber>
	<c:if test="${empty peril.netPremAmt}">-</c:if></label> <label
		style="width: 100px; text-align: center;"> ${peril.itemNo} </label> <label
		style="width: 100px; text-align: left;"> ${peril.perilName} </label> <label
		style="width: 100px; text-align: right;"> <fmt:formatNumber
		pattern="#,###.####" minFractionDigits="2">${peril.discountAmt}</fmt:formatNumber>
	<c:if test="${empty peril.discountAmt}">-</c:if></label> <label
		style="width: 100px; text-align: right;"> <fmt:formatNumber
		pattern="#,###.####" minFractionDigits="4">${peril.discountRt}</fmt:formatNumber>
	<c:if test="${empty peril.discountRt}">-</c:if></label> <label
		style="width: 100px; text-align: right;"> <fmt:formatNumber
		pattern="#,###.####" minFractionDigits="2">${peril.surchargeAmt}</fmt:formatNumber>
	<c:if test="${empty peril.surchargeAmt}">-</c:if></label> <label
		style="width: 100px; text-align: right;"> <fmt:formatNumber
		pattern="#,###.####" minFractionDigits="4">${peril.surchargeRt}</fmt:formatNumber>
	<c:if test="${empty peril.surchargeRt}">-</c:if></label> <c:if
		test="${peril.netGrossTag eq 'G'}">
		<label style="width: 50px; text-align: center;"> <img
			style="width: 10px; height: 10px;" name="checkedImg" /> </label>
	</c:if></div>
</c:forEach>
<script>
try{
	var perilListingJSON = JSON.parse('${perilListingJSON}'.replace(/\\/g, '\\\\'));
	var selectedRowId = '';
	objUW.hidGIPIS143 = {}; //added by steven 10/01/2012
	objUW.hidGIPIS143.perilSelected = false;
	disableSearch("searchItemImgPerilDisc");
	$$("div[name='rowPeril']").each(
		function (row)	{
			try{
				row.observe("mouseover", function ()	{
					row.addClassName("lightblue");
				});
				row.observe("mouseout", function ()	{
					row.removeClassName("lightblue");
				});
				row.observe("click", function ()	{
					resetBasicDiscountForm1();
					resetItemDiscountForm();
					selectedRowId = row.getAttribute("id");
					row.toggleClassName("selectedRow");
					if (row.hasClassName("selectedRow"))	{
						$$("div[name='rowPeril']").each(function (r)	{
							if (row.getAttribute("id") != r.getAttribute("id"))	{
								r.removeClassName("selectedRow");
							}	
					     });
						$("sequenceNoPeril").value = row.down("input", 0).value;
						$("itemNoPeril").value = row.down("input", 1).value;
						showPerilsPerItem(row.down("input", 1).value, row.down("input", 2).value);
						$("itemPerilCd").value = row.down("input", 2).value;
						$("premAmtPeril").value = formatCurrency(row.down("input", 4).value);
						$("discountAmtPeril").value = formatCurrency(row.down("input", 5).value);
						$("discountRtPeril").value = formatRate(row.down("input", 6).value);
						$("surchargeAmtPeril").value = formatCurrency(row.down("input", 7).value);
						$("surchargeRtPeril").value = formatRate(row.down("input", 8).value);
						var gtag = row.down("input", 9).value;
						if(gtag == 'G'){
							$("grossTagPeril").checked = true;
						}  else {
							$("grossTagPeril").checked = false;
						}
						$("remarkPeril").value = row.down("input", 10).value;
						$("paramOrigPerilPremAmt").value = formatCurrency(row.down("input", 11).value);
						$("origPerilAnnPremAmt").value = formatCurrency(row.down("input", 12).value);
						$("origItemAnnPremAmt").value = formatCurrency(row.down("input", 13).value);
						$("origPolAnnPremAmt").value = formatCurrency(row.down("input", 14).value);		
						showPerilButton(true);	
						isLastRecordPeril(row.down("input", 0).value);
					} else {
						resetPerilDiscountForm();
						showPerilButton(false);
						objUW.hidGIPIS143.perilSelected = false;
					}	    
				});	
			}catch (e) {
				showErrorMessage("Peril Row", e);
			}
		}	
	);

	$$("div[name='rowPeril']").each(function (div)	{
		if ((div.down("label", 3).innerHTML).length > 14){
			div.down("label", 3).update((div.down("label", 3).innerHTML).truncate(17, "..."));
		}
	});
	try{
		if(perilListingJSON.length > 0){	//change by steven 10/01/2012 from: $('itemNoPeril').length>1
			$("btnDelDiscountPeril").observe("click", function(){
				var seqNoForm = $("hiddenSequence").value; 
				if ($F("sequenceNoPeril") != seqNoForm - 1){
					showMessageBox("Deleting of this record is not allowed. Last Sequence should be deleted first.", imgMessage.ERROR);
					return;
				}
					
				$$("div[name='rowPeril']").each(function(row){
					if (row.hasClassName("selectedRow"))	{
						Effect.Fade(row,{
							duration: .2,
							afterFinish: function(){
								changeTag = 1;
								row.remove();			
								resetBasicDiscountForm1();
								resetItemDiscountForm();
								resetPerilDiscountForm();
								checkIfToResizeTable("billPerilDiscountTableList", "rowPeril");
								checkTableIfEmpty("rowPeril", "billPerilDiscountTable");
								showPerilButton(false);			
							}
						});
					}
				});
			});
			$("btnAddDiscountPeril").observe("click", function(){
				if (validatePerilAdd()) {
					if ($$("div[name='rowPeril']").size()>0){
						var seqNoLR = "Update" == $F("btnAddDiscountPeril") ? $F("sequenceNoPeril") : $$("div[name='rowPeril']").last().id.substring(8);
						var divIdLR = $("rowPeril"+seqNoLR);
						var itemNoLR = divIdLR.down("input", 1).value;
						var grossTagLR = divIdLR.down("input", 9).value;
						var itemNoSeL = $("itemNoPeril").value;
						var perilCdSel = $("itemPerilCd").value;
						var perilCdLR = divIdLR.down("input", 2).value;
						var grossTagSel = $("grossTagPeril").checked;
						if ((itemNoSeL == itemNoLR) && (perilCdSel == perilCdLR)){
							if ($F("btnAddDiscountPeril") =="Update"){	//added by steven 10/03/2012 for update
								onUpdateFuncPeril();								
							}else{
								if ((grossTagLR == "G") && (grossTagSel)){
									showConfirmBox4("Message", "Is this a new discount/surcharge or you want to add this to the previous discount/surcharge?",  
											"New", "Add", "Cancel", onNewFuncPeril, onAddFuncPeril, "");
								} else {
									onNewFuncPeril();
								}									
							}
						} else {
							onNewFuncPeril();
						}
					} else {
						onNewFuncPeril();
					}
					changeTag = 1;
				}
				
				function onNewFuncPeril() {
					var sequenceNo = $F("sequenceNoPeril");
					var itemNo = $("itemNoPeril").value == ""?'-':$("itemNoPeril").value;
					var perilCd = $("itemPerilCd").value == ""?'-':$("itemPerilCd").value;	//$("itemPeril").value == ""?'-':$("itemPeril").value; change by steve 10/01/2012
					var perilName = $("itemPeril").value;										//$("itemPeril").options[$("itemPeril").selectedIndex].text; change by steve 10/01/2012
					var premAmt = formatCurrency($F("premAmtPeril"));
					var origPerilPremAmt = formatCurrency($F("paramOrigPerilPremAmt"));
					var discountAmt = formatCurrency($F("discountAmtPeril"));
					var discountRt = formatRate(nvl($F("discountRtPeril"),0)); //with NVL dahil not nullable sa db
					var surchargeAmt = formatCurrency($F("surchargeAmtPeril"));
					var surchargeRt = formatRate($F("surchargeRtPeril"));
					var grossTag = $("grossTagPeril").checked==true?'G':'';
					var remark = changeSingleAndDoubleQuotes2($F("remarkPeril"));
					var itemTable = $("billPerilDiscountTableList");
					var origPerilAnnPremAmt = formatCurrency($F("origPerilAnnPremAmt"));
					var origItemAnnPremAmt = formatCurrency($F("origItemAnnPremAmt"));
					var origPolAnnPremAmt = formatCurrency($F("origPolAnnPremAmt"));
					var recordStatus = 0;
	
					var newDiv = new Element("div");
					newDiv.setAttribute("id", "rowPeril"+sequenceNo);
					newDiv.setAttribute("name", "rowPeril");
					newDiv.setStyle("height: 20px; border-bottom: 1px solid #E0E0E0; padding-top: 10px; display: none;");
					
					var strDiv = ''+
						'<input type="hidden" name="perilSequenceNos" value="'+sequenceNo+'" />'+
						'<input type="hidden" name="perilItemNos" value="'+itemNo+'" />'+
						'<input type="hidden" name="perilCodes" value="'+perilCd+'" />'+
						'<input type="hidden" name="perilLevelTags" value="1" />'+
						'<input type="hidden" name="perilNetPremAmts" value="'+premAmt+'" />'+
						'<input type="hidden" name="perilDiscountAmts" value="'+discountAmt+'" />'+
						'<input type="hidden" name="perilDiscountRts" value="'+discountRt+'" />'+
						'<input type="hidden" name="perilSurchargeAmts" value="'+surchargeAmt+'" />'+
						'<input type="hidden" name="perilSurchargeRts" value="'+surchargeRt+'" />'+
						'<input type="hidden" name="perilNetGrossTags" value="'+grossTag+'" />'+
						'<input type="hidden" name="perilRemarks" value="'+remark+'" />'+
						'<input type="hidden" name="perilOrigPerilPremAmt" value="'+origPerilPremAmt+'" />'+
						'<input type="hidden" name="perilOrigPerilAnnPremAmt" value="'+origPerilAnnPremAmt+'" />'+
						'<input type="hidden" name="perilOrigItemAnnPremAmt" value="'+origItemAnnPremAmt+'" />'+
						'<input type="hidden" name="perilOrigPolAnnPremAmt" value="'+origPolAnnPremAmt+'" />'+
						'<input type="hidden" name="recordStatus" value="'+recordStatus+'" />';	//added by steven 10/04/2012
							
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
					strDiv += '<label style="width: 100px; text-align: left;" title="'+perilName+'">'+perilName.truncate(14, "...")+'</label>';			 	
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
					
					if ("Update" == $F("btnAddDiscountPeril")) {
						$$("div[name='rowPeril']").each(function (div) {
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
							resetItemDiscountForm();
							selectedRowId = newDiv.getAttribute("id");
							newDiv.toggleClassName("selectedRow");
							if (newDiv.hasClassName("selectedRow"))	{
								$$("div[name='rowPeril']").each(function (r)	{
									if (newDiv.getAttribute("id") != r.getAttribute("id"))	{
										r.removeClassName("selectedRow");
									}	
							     });
								$("sequenceNoPeril").value = newDiv.down("input", 0).value;
								$("itemNoPeril").value = newDiv.down("input", 1).value;
								showPerilsPerItem(newDiv.down("input", 1).value, newDiv.down("input", 2).value);
								$("premAmtPeril").value = formatCurrency(newDiv.down("input", 4).value);
								$("discountAmtPeril").value = formatCurrency(newDiv.down("input", 5).value);
								$("discountRtPeril").value = formatRate(newDiv.down("input", 6).value);
								$("surchargeAmtPeril").value = formatCurrency(newDiv.down("input", 7).value);
								$("surchargeRtPeril").value = formatRate(newDiv.down("input", 8).value);
								var gtag = newDiv.down("input", 9).value;
								if(gtag == 'G'){
									$("grossTagPeril").checked = true;
								}  else {
									$("grossTagPeril").checked = false;
								}
								$("remarkPeril").value = newDiv.down("input", 10).value;
								$("paramOrigPerilPremAmt").value = formatCurrency(newDiv.down("input", 11).value);
								$("origPerilAnnPremAmt").value = formatCurrency(newDiv.down("input", 12).value);
								$("origItemAnnPremAmt").value = formatCurrency(newDiv.down("input", 13).value);
								$("origPolAnnPremAmt").value = formatCurrency(newDiv.down("input", 14).value);	
								showPerilButton(true);	
								isLastRecordPeril(newDiv.down("input", 0).value);		
							} else {
								resetPerilDiscountForm();
								showPerilButton(false);
							}
						});
			
						new Effect.Appear(newDiv, {
							duration: .2,
							afterFinish: function () {
								checkTableIfEmpty("rowPeril", "billPerilDiscountTable");
							}
						});
					}
					resetBasicDiscountForm1();
					resetItemDiscountForm();
					resetPerilDiscountForm();
					checkIfToResizeTable("billPerilDiscountTableList", "rowPeril");
				}
				
				function onAddFuncPeril() {
					var sequenceNoAdd = divIdLR.down("input", 0).value;
					var itemNoAdd = $F("itemNoPeril").blank()?'-':$F("itemNoPeril");
					var perilCdAdd = $("itemPerilCd").value == ""?'-':$("itemPerilCd").value;	//$("itemPeril").value == ""?'-':$("itemPeril").value; change by steve 10/01/2012
					var perilNameAdd = $("itemPeril").value;										//$("itemPeril").options[$("itemPeril").selectedIndex].text; change by steve 10/01/2012
					var premAmtAdd = formatCurrency($F("premAmtPeril"));
					var origPerilPremAmtAdd = formatCurrency($F("paramOrigPerilPremAmt"));
					var discountAmtAdd = divIdLR.down("input", 5).value.replace(/,/g, "")=="" && $F("discountAmtPeril").replace(/,/g, "")=="" ? "" :parseFloat(nvl(divIdLR.down("input", 5).value.replace(/,/g, ""),0)) + parseFloat(nvl($F("discountAmtPeril").replace(/,/g, ""),0));
					var discountRtAdd = divIdLR.down("input", 6).value.replace(/,/g, "")=="" && $F("discountRtPeril").replace(/,/g, "")=="" ? "" :parseFloat(nvl(divIdLR.down("input", 6).value.replace(/,/g, ""),0)) + parseFloat(nvl($F("discountRtPeril").replace(/,/g, ""),0));
					var surchargeAmtAdd = divIdLR.down("input", 7).value.replace(/,/g, "")=="" && $F("surchargeAmtPeril").replace(/,/g, "")=="" ? "" :parseFloat(nvl(divIdLR.down("input", 7).value.replace(/,/g, ""),0)) + parseFloat(nvl($F("surchargeAmtPeril").replace(/,/g, ""),0));
					var surchargeRtAdd = divIdLR.down("input", 8).value.replace(/,/g, "")=="" && $F("surchargeRtPeril").replace(/,/g, "")=="" ? "" :parseFloat(nvl(divIdLR.down("input", 8).value.replace(/,/g, ""),0)) + parseFloat(nvl($F("surchargeRtPeril").replace(/,/g, ""),0));
					var grossTagAdd = $("grossTagPeril").checked==true?'G':'';
					var remarkAdd = changeSingleAndDoubleQuotes2(divIdLR.down("input", 10).value);
					var origPerilAnnPremAmtAdd = formatCurrency($F("origPerilAnnPremAmt"));
					var origItemAnnPremAmtAdd = formatCurrency($F("origItemAnnPremAmt"));
					var origPolAnnPremAmtAdd = formatCurrency($F("origPolAnnPremAmt"));
					var recordStatus = 1;
					if (parseFloat(discountAmtAdd) > parseFloat($F("premAmtPeril").replace(/,/g, ""))) {
						customShowMessageBox("Discount amount greater than the premium amount is not allowed.", imgMessage.ERROR, "discountAmtPeril");
						return false;
					}
					if (parseFloat(surchargeAmtAdd) > parseFloat($F("premAmtPeril").replace(/,/g, ""))) {
						customShowMessageBox("Surcharge amount greater than the premium amount is not allowed.", imgMessage.ERROR, "surchargeAmtPeril");
						return false;
					}
					
					var strDiv = ''+
					'<input type="hidden" name="perilSequenceNos" value="'+sequenceNoAdd+'" />'+
					'<input type="hidden" name="perilItemNos" value="'+itemNoAdd+'" />'+
					'<input type="hidden" name="perilCodes" value="'+perilCdAdd+'" />'+
					'<input type="hidden" name="perilLevelTags" value="1" />'+
					'<input type="hidden" name="perilNetPremAmts" value="'+premAmtAdd+'" />'+
					'<input type="hidden" name="perilDiscountAmts" value="'+discountAmtAdd+'" />'+
					'<input type="hidden" name="perilDiscountRts" value="'+discountRtAdd+'" />'+
					'<input type="hidden" name="perilSurchargeAmts" value="'+surchargeAmtAdd+'" />'+
					'<input type="hidden" name="perilSurchargeRts" value="'+surchargeRtAdd+'" />'+
					'<input type="hidden" name="perilNetGrossTags" value="'+grossTagAdd+'" />'+
					'<input type="hidden" name="perilRemarks" value="'+remarkAdd+'" />'+
					'<input type="hidden" name="perilOrigPerilPremAmt" value="'+origPerilPremAmtAdd+'" />'+
					'<input type="hidden" name="perilOrigPerilAnnPremAmt" value="'+origPerilAnnPremAmtAdd+'" />'+
					'<input type="hidden" name="perilOrigItemAnnPremAmt" value="'+origItemAnnPremAmtAdd+'" />'+
					'<input type="hidden" name="perilOrigPolAnnPremAmt" value="'+origPolAnnPremAmtAdd+'" />'+
					'<input type="hidden" name="recordStatus" value="'+recordStatus+'" />';	//added by steven 10/04/2012;	
						
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
					strDiv += '<label style="width: 100px; text-align: left;" title="'+perilNameAdd+'">'+perilNameAdd.truncate(14, "...")+'</label>';			 	
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
					checkIfToResizeTable("billPerilDiscountTableList", "rowPeril");
				}
				
				
				//added by steven 10/03/2012 for update
				function onUpdateFuncPeril() {
					try{
						var sequenceNoAdd = divIdLR.down("input", 0).value;
						var itemNoAdd = $F("itemNoPeril").blank()?'-':$F("itemNoPeril");
						var perilCdAdd = $("itemPerilCd").value == ""?'-':$("itemPerilCd").value;	//$("itemPeril").value == ""?'-':$("itemPeril").value; change by steve 10/01/2012
						var perilNameAdd = $("itemPeril").value;										//$("itemPeril").options[$("itemPeril").selectedIndex].text; change by steve 10/01/2012
						var premAmtAdd = formatCurrency($F("premAmtPeril"));
						var origPerilPremAmtAdd = formatCurrency($F("paramOrigPerilPremAmt"));
						var discountAmtAdd = divIdLR.down("input", 5).value.replace(/,/g, "")=="" && $F("discountAmtPeril").replace(/,/g, "")=="" ? "" :parseFloat(nvl($F("discountAmtPeril").replace(/,/g, ""),0));
						var discountRtAdd = divIdLR.down("input", 6).value.replace(/,/g, "")=="" && $F("discountRtPeril").replace(/,/g, "")=="" ? "" :parseFloat(nvl($F("discountRtPeril").replace(/,/g, ""),0));
						var surchargeAmtAdd = divIdLR.down("input", 7).value.replace(/,/g, "")=="" && $F("surchargeAmtPeril").replace(/,/g, "")=="" ? "" :parseFloat(nvl($F("surchargeAmtPeril").replace(/,/g, ""),0));
						var surchargeRtAdd = divIdLR.down("input", 8).value.replace(/,/g, "")=="" && $F("surchargeRtPeril").replace(/,/g, "")=="" ? "" :parseFloat(nvl($F("surchargeRtPeril").replace(/,/g, ""),0));
						var grossTagAdd = $("grossTagPeril").checked==true?'G':'';
						//var remarkAdd = changeSingleAndDoubleQuotes2(divIdLR.down("input", 10).value); // removed by robert 11.19.2013
						var remarkAdd = changeSingleAndDoubleQuotes2($F("remarkPeril")); // added by robert 11.19.2013
						var origPerilAnnPremAmtAdd = formatCurrency($F("origPerilAnnPremAmt"));
						var origItemAnnPremAmtAdd = formatCurrency($F("origItemAnnPremAmt"));
						var origPolAnnPremAmtAdd = formatCurrency($F("origPolAnnPremAmt"));
						var recordStatus = 1;
						
						if (parseFloat(discountAmtAdd) > parseFloat($F("premAmtPeril").replace(/,/g, ""))) {
							customShowMessageBox("Discount amount greater than the premium amount is not allowed.", imgMessage.ERROR, "discountAmtPeril");
							return false;
						}
						if (parseFloat(surchargeAmtAdd) > parseFloat($F("premAmtPeril").replace(/,/g, ""))) {
							customShowMessageBox("Surcharge amount greater than the premium amount is not allowed.", imgMessage.ERROR, "surchargeAmtPeril");
							return false;
						}
						
						var strDiv = ''+
						'<input type="hidden" name="perilSequenceNos" value="'+sequenceNoAdd+'" />'+
						'<input type="hidden" name="perilItemNos" value="'+itemNoAdd+'" />'+
						'<input type="hidden" name="perilCodes" value="'+perilCdAdd+'" />'+
						'<input type="hidden" name="perilLevelTags" value="1" />'+
						'<input type="hidden" name="perilNetPremAmts" value="'+premAmtAdd+'" />'+
						'<input type="hidden" name="perilDiscountAmts" value="'+discountAmtAdd+'" />'+
						'<input type="hidden" name="perilDiscountRts" value="'+discountRtAdd+'" />'+
						'<input type="hidden" name="perilSurchargeAmts" value="'+surchargeAmtAdd+'" />'+
						'<input type="hidden" name="perilSurchargeRts" value="'+surchargeRtAdd+'" />'+
						'<input type="hidden" name="perilNetGrossTags" value="'+grossTagAdd+'" />'+
						'<input type="hidden" name="perilRemarks" value="'+remarkAdd+'" />'+
						'<input type="hidden" name="perilOrigPerilPremAmt" value="'+origPerilPremAmtAdd+'" />'+
						'<input type="hidden" name="perilOrigPerilAnnPremAmt" value="'+origPerilAnnPremAmtAdd+'" />'+
						'<input type="hidden" name="perilOrigItemAnnPremAmt" value="'+origItemAnnPremAmtAdd+'" />'+
						'<input type="hidden" name="perilOrigPolAnnPremAmt" value="'+origPolAnnPremAmtAdd+'" />'+
						'<input type="hidden" name="recordStatus" value="'+recordStatus+'" />';	//added by steven 10/04/2012;	
							
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
						strDiv += '<label style="width: 100px; text-align: left;" title="'+perilNameAdd+'">'+perilNameAdd.truncate(14, "...")+'</label>';			 	
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
						checkIfToResizeTable("billPerilDiscountTableList", "rowPeril");					
					}catch (e) {
						showErrorMessage("onUpdateFuncPeril", e);
					}
				}
				
			});
			
		} else {
			$("btnDelDiscountPeril").observe("click", function ()	{
				showMessageBox("Buttons for item peril discounts are disabled since no\nItems/Perils are included in the quotation...");
			});
			$("btnAddDiscountPeril").observe("click", function ()	{
				showMessageBox("Buttons for item peril discounts are disabled since no\nItems/Perils are included in the quotation...");
			});
			checkIfToResizeTable("billPerilDiscountTableList", "rowPeril"); 
		}	
	}catch (e) {
		showErrorMessage("Peril length condition", e);
	}
		
	function validatePerilAdd(){
		var result = true;
		if($("itemNoPeril").value == 0){
			customShowMessageBox("Please select an item first.", imgMessage.ERROR, "itemNoPeril");
			result = false;
			return false;
		}else if($("itemPerilCd").value == 0){
			customShowMessageBox("Please select peril first.", imgMessage.ERROR, "itemPeril");
			result = false;
			return false;
		}else if($("premAmtPeril").value < 0){
			customShowMessageBox("Peril with premium amount less than or equal to zero are not allowed to have discount(s).", imgMessage.ERROR, "itemPeril");
			result = false;
			return false;
		}else if (($("discountAmtPeril").value == "0.00" || $("discountAmtPeril").value == "") && ($("surchargeAmtPeril").value == "0.00" || $("surchargeAmtPeril").value == "")){
			showMessageBox("Please enter complete information before proceeding to the next record.");
			result = false;
		}else if (parseFloat($F("discountAmtPeril").replace(/,/g, "")) > parseFloat($F("premAmtPeril").replace(/,/g, ""))){
			customShowMessageBox("Discount amount greater than the premium amount is not allowed.", imgMessage.ERROR, "discountAmtPeril");
			result = false;
			return false;
		}else if (parseFloat($F("surchargeAmtPeril").replace(/,/g, "")) > parseFloat($F("premAmtPeril").replace(/,/g, ""))){
			customShowMessageBox("Surcharge amount greater than the premium amount is not allowed.", imgMessage.ERROR, "surchargeAmtPeril");
			result = false;
			return false;
		}else{
			if ($F("discountAmtPeril").replace(/,/g, "") != "" && $F("itemNoPeril") != "0" && $F("itemPerilCd") != "0"){
				function ok(){
					$("discountAmtPeril").focus();
					clearPreTextValue("discountAmtPeril");
				}	
				createTempPeril();
				var validate = validateDiscSurcAmtPeril();
				if (validate=="1"){
					showWaitingMessageBox("Invalid discount amount. Valid value should be greater than 0.00 but not greater than Premium Amount and should not result to a Net Premium Amount greater than TSI Amount.", imgMessage.ERROR, ok);
					result = false;
					return false;
				}else if (validate=="2"){
					showWaitingMessageBox("Cannot add discount. Adding of discount will result to a negative Peril/s.", imgMessage.ERROR, ok);
					result = false;
					return false;
				}		
				
				$$("div[name='rowPerilTempOnly']").each(function(row){
					row.remove();		 
				});
			}	
			if ($F("surchargeAmtPeril").replace(/,/g, "") != "" && $F("itemNoPeril") != "0" && $F("itemPerilCd") != "0"){
				function ok(){
					$("surchargeAmtPeril").focus();
					clearPreTextValue("surchargeAmtPeril");
				}
				createTempPeril();
				var validate = validateDiscSurcAmtPeril();
				if (validate=="1"){
					showWaitingMessageBox("Invalid surcharge amount. Value should be greater than 0.00 but not greater than Premium Amount and should not result to a Net Premium Amount greater than TSI Amount.", imgMessage.ERROR, ok);
					result = false;
					return false;
				}else if (validate=="2"){
					showWaitingMessageBox("Cannot add surcharge. Adding of surcharge will result to a negative Peril/s.", imgMessage.ERROR, ok);
					result = false;
					return false;
				}		
				
				$$("div[name='rowPerilTempOnly']").each(function(row){
					row.remove();		 
				});
			}
		}	
		return result;	
	}
	
/*	$("itemNoPeril").observe("change", function () {
		$("discountAmtPeril").clear();
		$("discountRtPeril").value = "0.0000" ;//$("discountRtPeril").clear();
		$("surchargeAmtPeril").clear();
		$("surchargeRtPeril").clear();
		$("itemPeril").selectedIndex = 0;
		$("premAmtPeril").clear();
		
		if ($("itemNoPeril").value != 0){
			$("itemPeril").selectedIndex = 0;
			showPerilsPerItem2($("itemNoPeril").value);
		} else {
			$("itemPeril").selectedIndex = 0;
			$("itemPeril").disable();
		}
	});

	$("itemNoPeril").observe("blur", function () {
		if ($("itemNoPeril").value != 0){
			$("itemPeril").selectedIndex = 0;
			showPerilsPerItem2($("itemNoPeril").value);
		} else {
			$("itemPeril").selectedIndex = 0;
			$("itemPeril").disable();
		}
	});	*/

// 	$("itemPeril").observe("change", function () {
	function checkItemPeril() {	//change by steven to function
		$("discountAmtPeril").clear();
		//$("discountRtPeril").value = "0.0000"; //$("discountRtPeril").clear();// replaced with code below : shan 11.27.2014
		$("lblModuleId").getAttribute("moduleId") == "GIPIS143" ? $("discountRtPeril").clear() : $("discountRtPeril").value = "0.0000";
		$("surchargeAmtPeril").clear();
		$("surchargeRtPeril").clear();
			
		var rowPeril = $$("div[name='rowPeril']").size();
		var itemNo1 = $("itemNoPeril").value;
		var perilCd1 = $("itemPerilCd").value;
		var exist = "N";
		if (rowPeril>0){
			for(var i = 1; i < rowPeril+1; i++) {	
				if($('rowPeril'+i)){
					var row = $('rowPeril'+i);		 
					itemNo2 = row.down("input", 1).value;
					perilCd2 = row.down("input", 2).value;
					if ((itemNo2 == itemNo1) && (perilCd1 == perilCd2)) { 
						exist = "Y";
						break;
					}			
				}	
			}
			if (exist == "Y"){
				$("premAmtPeril").value = formatCurrency(row.down("input", 11).value);
				$("paramOrigPerilPremAmt").value = formatCurrency(row.down("input", 11).value);
				$("origPerilAnnPremAmt").value = formatCurrency(row.down("input", 12).value);
				$("origItemAnnPremAmt").value = formatCurrency(row.down("input", 13).value);
				$("origPolAnnPremAmt").value = formatCurrency(row.down("input", 14).value);
				$("grossTagPeril").checked = true;
			} else {
				updatePerilNetPremAmt();	
			}		
		} else {
			updatePerilNetPremAmt();	
		}
	}

	function updatePerilNetPremAmt(){
		var itemNo1 = $("itemNoPeril").value;
		var perilCd = $("itemPerilCd").value;
		if ((itemNo1 != 0) && (perilCd != 0)) {
			new Ajax.Updater("message", contextPath+"/GIPIParDiscountController",{
				parameters:{
					parId: $("parId").value,
					lineCd: $("lineCd").value,
					itemNo: itemNo1,
					perilCd: perilCd,
					sequence: $("sequenceNoPeril").value,
					action: "getOrigPerilPremAmt"
					},
				asynchronous: false,
				evalScripts: true,
// 				onCreate: function () {
// 					$("premAmtPeril").up("td", 0).update("<span id='refSpan' style='font-size: 9px;'>Refreshing...</span>");
// 					},
				onComplete: function (response)	{
					if (checkErrorOnResponse(response)) {
// 						$("refSpan").up("td", 0).update("<input id='premAmtPeril' style='width: 210px;' type='text' value='' class='money' readonly='readonly'/></td>");
						var text = response.responseText;
						var arr = text.split(',');
						$("paramOrigPerilPremAmt").value = formatCurrency(arr[0]);
						$("premAmtPeril").value = formatCurrency(arr[1]);
						$("origPerilAnnPremAmt").value = formatCurrency(arr[2]);
						$("origItemAnnPremAmt").value = formatCurrency(arr[3]);
						$("origPolAnnPremAmt").value = formatCurrency(arr[4]);
					}
				}
			});
		} else if (itemNo1 == 0){
			resetPerilDiscountForm();
		}
		
		if($("premAmtPeril").value < 0) {
			showMessageBox("Peril with premium amount less than or equal to zero are not allowed to have discount(s).");
		}
		$("grossTagPeril").checked = true;
	}	

	function isLastRecordPeril(seqNoSelect) {
		var seqNoSelect = seqNoSelect;
		var seqNoForm = $("hiddenSequence").value; 
		if (seqNoSelect == seqNoForm - 1){
			$("sequenceNoPeril").enable();
			$("grossTagPeril").enable();
			$("discountAmtPeril").enable();
			$("premAmtPeril").enable();
			$("discountRtPeril").enable();
// 			$("itemNoPeril").enable();
			$("surchargeAmtPeril").enable();
// 			$("itemPeril").enable();
			$("surchargeRtPeril").enable();
			$("remarkPeril").enable();
			enableButton("btnAddDiscountPeril");	//change by steven 10/02/2012 from disableButton
			enableButton("btnDelDiscountPeril");
			objUW.hidGIPIS143.perilSelected = false;
		} else {
			$("sequenceNoPeril").disable();
			$("grossTagPeril").disable();
			$("discountAmtPeril").disable();
			$("premAmtPeril").disable();
			$("discountRtPeril").disable();
// 			$("itemNoPeril").disable();
			$("surchargeAmtPeril").disable();
// 			$("itemPeril").disable();
			$("surchargeRtPeril").disable();
			$("remarkPeril").disable();
			disableButton("btnAddDiscountPeril");		
			enableButton("btnDelDiscountPeril");
			objUW.hidGIPIS143.perilSelected = true;
		}
		disableSearch("searchItemImgPeril");		//added by steven 10/01/2012
		disableSearch("searchItemImgPerilDisc");	//added by steven 10/01/2012
	}	
	
	function showPerilButton(param){
		if(param){			
			$("btnAddDiscountPeril").value = "Update";	//change by steven 10/02/2012 from "Add"
			enableButton("btnAddDiscountPeril");		//change by steven 10/02/2012 from disableButton
			enableButton("btnDelDiscountPeril");
		} else {
			resetPerilDiscountForm();
		}
	}

	function showPerilsPerItem(itemNo,perilCd){ // added steven 10/01/2012
		if (itemNo != ""){
			for(var i = 0; i < perilListingJSON.length; i++){  
				if (perilListingJSON[i].itemNo == itemNo && perilListingJSON[i].perilCd == perilCd){
					$("itemPeril").value = unescapeHTML2(perilListingJSON[i].perilName); //added unescapeHTML2 by robert 11.28.2013
					enableSearch("searchItemImgPerilDisc");	//added by steven 10/01/2012
				}
			}
		}
	}
	
	/*function showPerilsPerItem(itemNo,perilCd){
		updateItemPerilLOV(perilListingJSON, "");
		var perilOption = $("itemPeril").options;		
		for(var i = 1; i < perilOption.length; i++){ 
			perilOption[i].hide();
			perilOption[i].disabled = true;
		}	
		
		if (itemNo != ""){
			for(var i = 1; i < perilOption.length; i++){  
				if (perilOption[i].getAttribute("itemNo") == itemNo){
					perilOption[i].show();
					perilOption[i].disabled = false;
					if (perilOption[i].value == perilCd){
						perilOption.selectedIndex = i;
					}
				}
			}
		}
	}

	function showPerilsPerItem2(itemNo){
		new Ajax.Request("GIPIParDiscountController?action=getItemPerilsPerItem&itemNo="+$F("itemNoPeril"), {
			method: "POST",
			postBody: Form.serialize("billDiscountForm"),
			evalScripts: true,
			asynchronous: false,
			onCreate: function(){
				hideLOV("itemPeril");
				$("refSpanItemPeril").show();
			},
			onComplete: function (response)	{
				$("refSpanItemPeril").hide();
				showLOV("itemPeril")
				if (checkErrorOnResponse(response)) {
					if (response.responseText != ""){
						result = response.responseText.evalJSON();
						updateItemPerilLOV(result, "0");
						return;
					}
				}	
			}
		});
		
		var perilCtr = 0;
		var perilOption = $("itemPeril").options;		
		for(var i = 1; i < perilOption.length; i++){ 
			perilOption[i].hide();
			perilOption[i].disabled = true;
		}	
		
		if (itemNo != 0){
			for(var i = 1; i < perilOption.length; i++){  
				if (perilOption[i].getAttribute("itemNo") == itemNo){
					perilOption[i].show();
					perilOption[i].disabled = false;
					perilCtr++;
				}
			}
			$("itemPeril").enable();
		}

		if ("Add" == $F("btnAddDiscountPeril")) {
			if (perilCtr == 0){
				customShowMessageBox("Item no. have no existing peril(s) with premium more than 0.", imgMessage.ERROR, "itemNoPeril");
			}	
		}	
	}*/

	function showPerilsPerItem2(itemNo){	//added by steven 10/01/2012
		var premAmt = 0;
		var exist = true;
		if (itemNo != 0){
			for(var i = 0; i < perilListingJSON.length; i++){  
				if (perilListingJSON[i].itemNo == itemNo){
					premAmt += parseFloat(perilListingJSON[i].premAmt);
				}
			}
		}
		if ("Add" == $F("btnAddDiscountPeril")) {
			if (premAmt == 0){
				customShowMessageBox("Item no. have no existing peril(s) with premium more than 0.", imgMessage.ERROR, "itemNoPeril");
				exist = false;
			}	
		}	
		return exist;
	}
	
	objUW.hidGIPIS143.showPerilsPerItem2 = showPerilsPerItem2;
	objUW.hidGIPIS143.checkItemPeril = checkItemPeril;
	
	/*for(var i = 1; i < $("itemPeril").options.length; i++){
		$("itemPeril").options[i].hide();
		$("itemPeril").options[i].disabled = true;
	}
	
	if ($("itemNoPeril").value == 0){
		$("itemPeril").disable();
	}

	function updateItemPerilLOV(objArray, initValue){
		$("itemPeril").enable();
		removeAllOptions($("itemPeril"));
		var opt = document.createElement("option");
		opt.value = "0";
		opt.text = "Select...";
		$("itemPeril").options.add(opt);
		for(var a=0; a<objArray.length; a++){
			var opt = document.createElement("option");
			opt.value = objArray[a].perilCd;
			opt.text = changeSingleAndDoubleQuotes(objArray[a].perilName);
			opt.setAttribute("itemNo", objArray[a].itemNo); 
			$("itemPeril").options.add(opt);
		}
		$("itemPeril").value = initValue;
	}*/
	
	generateSequenceGIPIS143();
}catch (e) {
	showErrorMessage("perilDiscountListing.jsp", e);
	//showMessageBox("Peril discount listing - "+e.message, imgMessage.ERROR);
}	
</script>