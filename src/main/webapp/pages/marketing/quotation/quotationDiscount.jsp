<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<input type="hidden" name="hiddenSequence" id="hiddenSequence" value="">
<div id="quotationDiscountMainDiv" style="margin-top: 1px; display: none;">
	<form id="quotationDiscountForm" name="quotationDiscountForm">
		<input type="hidden" name="quoteId" 	id="quoteId" 	value="${gipiQuote.quoteId}" />
		<input type="hidden" name="lineCd" 		id="lineCd" 	value="${gipiQuote.lineCd}" />
		<input type="hidden" name="sublineCd" 		id="sublineCd" 	value="${gipiQuote.sublineCd}" />
		<input type="hidden" name="lineName" 	id="lineName" 	value="${gipiQuote.lineName}" />
		<input type='hidden' name="sequencePolicyArray" id="sequencePolicyArray"  value="" />	
		<input type='hidden' name="quoteAnnPremAmt"  id="quoteAnnPremAmt"  value="0" />
		<input type='hidden' name="quotePremAmt"     id="quotePremAmt" value="${gipiQuote.premAmt}" />	
		<input type='hidden' name="quoteTsiAmt"     id="quoteTsiAmt" value="${gipiQuote.tsiAmt}" />	
		<input type='hidden' name="origPolGrossPremAmt"  id="origPolGrossPremAmt" value="0" />	
		<jsp:include page="subPages/quotationDiscount1.jsp"></jsp:include>
		<jsp:include page="subPages/quotationDiscount2.jsp"></jsp:include>
		<jsp:include page="subPages/quotationDiscount3.jsp"></jsp:include>
		<jsp:include page="subPages/quotationDiscount4.jsp"></jsp:include>
	</form>
	<div class="buttonsDiv" id="discountsButtonDiv">
		<table align="center">
			<tr>
				<td><input type="button" class="button" id="btnEditQuotation" name="btnEditQuotation" value="Edit Quotation" style="width: 90px;" /></td>
				<td><input type="button" class="button" id="btnSave" name="btnSave" value="Save" style="width: 90px;" /></td>
				<!--  
				<td><input type="button" class="disabledButton" id="btnPrint" name="btnPrint" value="Print" style="width: 90px;" disabled="disabled" /></td>
				-->
			</tr>
		</table>
	</div>
</div>
<c:forEach var="quoteItem" items="${quoteItems}">
	<c:forEach var="quotePeril" items="${quotePerils}">
		<c:if test="${quotePeril.itemNo eq quoteItem.itemNo}">
			<div id="hidQuotePeril" name="hidQuotePeril" style="display: none;">
				<input type='hidden' name="hidtsiAmt" id="hidtsiAmt" value="${quotePeril.tsiAmount}" />	
				<input type='hidden' name="hidPremRt" id="hidPremRt" value="${quotePeril.premiumRate}" />		
				<input type='hidden' name="hidCurrRate" id="hidCurrRate" value="${quoteItem.currencyRate}" />		
				<input type='hidden' name="hidPremAmt" id="hidPremAmt" value="${quotePeril.premiumAmount}" />		
			</div>
		</c:if>	
	</c:forEach>	
</c:forEach>	
<script type="text/javascript">
	
	if (isMakeQuotationInformationFormsHidden == 1) {
		$("discountForm1").hide();
		$("discountForm2").hide();
		$("discountForm3").hide();
		$("discountsButtonDiv").hide();

		makeAllQuotationFormsHidden();
	}

	setModuleId("GIIMM012");
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	checkMoneyValues();
	
	$("reloadForm").observe("click", showDiscountPage);
	
	$("btnSave").observe("click", function ()	{
		new Ajax.Request("GIPIQuotationDiscountController?action=saveDiscounts", {
			method: "GET",
			parameters: {
				quoteId: $("quoteId").value,
				sequenceList: $("sequencePolicyArray").value == "" ? 0 : $("sequencePolicyArray").value,
				polQuotePremAmt: $F("quotePremAmt") == "" ? "0" : $F("quotePremAmt"),
				quoteItemPremAmts: quoteItemPremAmts(),	
				quotePerilPremAmts: quotePerilPremAmts(),	
				basicDiscounts: formBasic(),
				itemDiscounts: formItem(),
				perilDiscounts: formPeril(),
				ajax: "1"
			},
			evalScripts: true,
			asynchronous: true,
			onCreate: showNotice("Saving information, please wait..."),
			onComplete: function (response)	{
				if (checkErrorOnResponse(response)) {
					hideNotice(response.responseText);
					$("sequencePolicyArray").value = "";
					if(response.responseText == "SUCCESS"){
						//showMessageBox(response.responseText ,imgMessage.SUCCESS); removed by robert 10.09.2014
						showMessageBox(objCommonMessage.SUCCESS ,imgMessage.SUCCESS); //added by robert 10.09.2014
					}else{
						showMessageBox(response.responseText ,imgMessage.ERROR);	
					}
				}
			}
		});
	});

	function quoteItemPremAmts(){
		var str = '';
		var listLength = $("itemNo").length;
		var premAmt = 0;
		var itemNo = 0;
		for (var i=1; i<listLength; i++){
			premAmt = isNaN(parseFloat($("itemNo").options[i].getAttribute("netPrem"))) ? 0 : parseFloat($("itemNo").options[i].getAttribute("netPrem"));
			itemNo = parseFloat($("itemNo").options[i].getAttribute("itemNo"));
			str +=  itemNo+"|"+premAmt+"|";
		}
		return str;
	}
	
	function quotePerilPremAmts(){
		var str = '';
		var listLength = $("itemNo").length;
		var premAmt = 0;
		var itemNo = 0;
		var perilCd = '';
		var perilListLength = 0;
		for (var i=1; i<listLength; i++){
			perilListLength = $("perilPremAmtSelect"+ i).length;
			for(var j=1; j<perilListLength; j++){
				itemNo=$("perilPremAmtSelect"+ i).options[j].getAttribute("itemNo");
				perilCd=$("perilPremAmtSelect"+ i).options[j].getAttribute("perilCd");
				premAmt = isNaN($("perilPremAmtSelect"+ i).options[j].value) ? 0 : $("perilPremAmtSelect"+ i).options[j].value;
				str += itemNo+"|"+perilCd+"|"+premAmt+"|"; 
			}

		}
		return str;
	}
	
	function formBasic(){
		var str = '';
		$$("div[name='rowBasic']").each(function(row){
	    	var quoteId = $('quoteId').value; 
	    	var seqNo =	 row.down("input", 0).value;
			var premAmt = formatCurrency(row.down("input", 1).value);
			var discAmt = formatCurrency(row.down("input", 2).value);
			var discRt = formatRate(row.down("input", 3).value);
			var surcAmt = formatCurrency(row.down("input", 4).value);
			var surcRt = formatRate(row.down("input", 5).value);
			var gtag = row.down("input", 6).value;
			var remark = row.down("input", 7).value;
			var netPremAmt = row.down("input", 8).value;
			str += quoteId+"|"+seqNo+"|||"+discRt+"|"+discAmt+"|"+surcRt+"|"+surcAmt+"|"+premAmt+"|"+netPremAmt+"|"+gtag+"||"+remark+"|";
		});
		return str;
	}
	
	function formItem(){
		var str = '';
	    $$("div[name='rowItem']").each(function(row){
	    	var quoteId = $('quoteId').value; 
	    	var seqNo =	 row.down("input", 0).value;
	    	var itemNo =	 row.down("input", 1).value;
	    	var itemTitle =	 row.down("input", 2).value;
	    	var premAmt = row.down("input", 3).value;
			var discAmt = formatCurrency(row.down("input", 4).value);
			var discRt = formatRate(row.down("input", 5).value);
			var surcAmt = formatCurrency(row.down("input", 6).value);
			var surcRt = formatRate(row.down("input", 7).value);
			var gtag = row.down("input", 8).value;
			var remark = row.down("input", 9).value;
			var origPremAmt = formatCurrency($("itemNo").options[row.down("input", 1).value].getAttribute("annPremAmt"));
			// var premAmt = parseFloat($("itemNo").options[row.down("input", 1).value].getAttribute("netPrem")) - parseFloat(row.down("input", 4).value.replace(/,/g, ""));//formatCurrency(row.down("input", 3).value);
			str += quoteId+"|"+seqNo+"|||"+itemNo+"|"+discRt+"|"+discAmt+"|"+surcRt+"|"+surcAmt+"|"+origPremAmt+"|"+premAmt+"|"+gtag+"||"+remark+"|";
		});
		return str;
	}

	function formPeril(){
		var str = '';
		$$("div[name='rowPeril']").each(function(row){
			var quoteId = $('quoteId').value; 
	    	var seqNo =	 row.down("input", 0).value;
	    	var itemNo =	 row.down("input", 1).value;
	    	var perilCd =	 row.down("input", 2).value;
			var premAmt = formatCurrency(row.down("input", 3).value);
			var discAmt = formatCurrency(row.down("input", 4).value);
			var discRt = formatRate(row.down("input", 5).value);
			var surcAmt = formatCurrency(row.down("input", 6).value);
			var surcRt = formatRate(row.down("input", 7).value);
			var gtag = row.down("input", 8).value;
			var remark = row.down("input", 9).value;
			var netPremAmt = formatCurrency(row.down("input", 10).value);
			str += quoteId+"|"+seqNo+"|||"+itemNo+"|"+perilCd+"||3||"+discRt+"|"+discAmt+"|"+surcRt+"|"+surcAmt+"|"+premAmt+"|"+netPremAmt+"|"+netPremAmt+"|"+gtag+"||"+remark+"|";
		});	
		
		$$("div[name='rowPerilHidden']").each(function(row){
			var quoteId = $('quoteId').value; 
	    	var seqNo =	 row.down("input", 0).value;
	    	var itemNo =	 row.down("input", 1).value;
	    	var perilCd =	 row.down("input", 2).value;
			var premAmt = formatCurrency(row.down("input", 3).value);
			var discAmt = formatCurrency(row.down("input", 4).value);
			var discRt = formatRate(row.down("input", 5).value);
			var surcAmt = formatCurrency(row.down("input", 6).value);
			var surcRt = formatRate(row.down("input", 7).value);
			var gtag = row.down("input", 8).value;
			var levelTag = row.down("input", 9).value;
			var remark = row.down("input", 10).value;
			var netPremAmt = row.down("input", 11).value;
			str += quoteId+"|"+seqNo+"|||"+itemNo+"|"+perilCd+"||"+levelTag+"||"+discRt+"|"+discAmt+"|"+surcRt+"|"+surcAmt+"|"+premAmt+"|"+netPremAmt+"|"+netPremAmt+"|"+gtag+"||"+remark+"|";
		});	

		return str;
	}
	
	$("btnEditQuotation").observe("click", function () {
		editQuotation(contextPath+"/GIPIQuotationDiscountController?action=showDiscountPage&quoteId="+$F("quoteId")+"&ajax=1");
	});

	changeCheckImageColor();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();

	$("editRemarks").observe("click", function () {
		showEditor("remark", 4000);
	});
	$("editRemarks1").observe("click", function () {
		showEditor("remarkItem", 4000);
	});
	$("editRemarks2").observe("click", function () {
		showEditor("remarkPeril", 4000);
	});
	
	$("remark").observe("keyup", function () {
		limitText($("remark"), 4000);
	});
	$("remarkItem").observe("keyup", function () {
		limitText($("remarkItem"), 4000);
	});
	$("remarkPeril").observe("keyup", function () {
		limitText($("remarkPeril"), 4000);
	});

	function getTotalPremAmount(){
		var grossAmt = 0;
		var netAmt = 0;
		var origGrossAmt = 0;
		$$("div[name='hidQuotePeril']").each(function(item){
			grossAmt = grossAmt + (Math.round((parseFloat(item.down("input", 0).value) * ((parseFloat(item.down("input", 1).value)) / 100))*100)/100) * parseFloat(item.down("input", 2).value);
			netAmt += parseFloat(item.down("input", 3).value) * parseFloat(item.down("input", 2).value);
			origGrossAmt = origGrossAmt + (Math.round((parseFloat(item.down("input", 0).value) * ((parseFloat(item.down("input", 1).value)) / 100))*100)/100);
		});
		$("premAmt").value = formatCurrency(grossAmt);
		$("quoteAnnPremAmt").value = unformatCurrency("premAmt");
		//$("quotePremAmt").value = netAmt;
		$("origPolGrossPremAmt").value = origGrossAmt;
	}
	
	getTotalPremAmount();
	
	$("gimmExit").stopObserving("click"); // andrew - 02.09.2012
	$("gimmExit").observe("click", function(){
		showQuotationListing();
	});
</script>