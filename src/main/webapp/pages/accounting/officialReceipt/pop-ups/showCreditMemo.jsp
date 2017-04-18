<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="contentsDiv">
	<div class="sectionDiv" id="creditMemoDiv" style="margin-top: -20px; border-top: none; border-right: none; border-left: none; border-bottom: none; height: 300px;">
		<div id="creditMemo" style="margin: 10px;">
			<div id="creditMemoTable" style="border-right: white; border-left: white;">
				<div style="width: 100%;" id="creditMemoTableHeader">
					<div class="tableHeader" style="font-size: 11px;">
					<label style="width: 70px; text-align: center;">CM No.</label>
					<label style="width: 100px; text-align: left; margin-left: 55px;">Tran Date</label>
					<label style="width: 160px; text-align: center">Local Amount</label>
			   		<label style="width: 90px; text-align: left;">Currency</label>
			   		<label style="width: 160px; text-align: center;">Rate</label>		
				</div>
			</div>
				<div style="width: 100%;" id="creditMemoList" class="tableContainer" style="margin-top: 10px;">
					<c:forEach var="creditMemo" items="${creditMemoDtls}">
						<div id="row${creditMemo.cmNo}" name="row" cmNo="${creditMemo.cmNo}" class="tableRow" style="padding: 3px 5px; padding-top: 5px;" cmTranId="${creditMemo.cmTranId}">
							<label style="width: 100px; margin-left: 10px;" id="${creditMemo.cmNo}" name="lblCmNo" title="${creditMemo.cmNo}">${creditMemo.cmNo}</label>
							<label style="width: 90px; margin-left: 10px;" id="${creditMemo.cmNo}memoDate" name="lblTranDate" title="<fmt:formatDate value="${creditMemo.memoDate}" pattern="MM-dd-yyyy" />"><fmt:formatDate value="${creditMemo.memoDate}" pattern="MM-dd-yyyy" /></label>
							<label style="width: 120px; margin-left: 12px; text-align: right;" id="${creditMemo.cmNo}localAmt" name="lblLocalAmt" title="${creditMemo.localAmt}">${creditMemo.localAmt}</label>
							<label style="width: 50px; margin-left: 41px;" id="${creditMemo.cmNo}currencyCd" name="lblCurrencyCd" currCd="${creditMemo.currencyCd}" title="${creditMemo.currencyCd}">${creditMemo.shortName}</label>
							<label style="width: 100px; margin-left: 104px;" id="${creditMemo.cmNo}currencyRt" name="lblCurrencyRt" title="${creditMemo.currencyRt}">${creditMemo.currencyRt}</label>
						</div>
					</c:forEach>
				</div>
			</div>
		</div>
	</div>
	
	<div id="divB" align="right" style="margin: 10px; margin-right: 10;">
		<input type="button" id="btnCreditMemoOk" class="button" value="Ok" style="width: 60px;" />
		<input type="button" class="button" value="Cancel" style="width: 60px;" onclick="Modalbox.hide();" />
	</div>
</div>

<script type="text/javascript">
var localAmt = 0;
var currencyCd = null;
var currencyRt = 1;
var checkDate = null;
var cmNo = null;
var cmTranId = null;

$$("div[name='row']").each(function (div)	{
	div.down("label", 2).update(formatCurrency(div.down("label", 2).innerHTML));
	div.down("label", 4).update(formatToNineDecimal(div.down("label", 4).innerHTML));
});

$$("div[name='row']").each(function (div) {
	divEvents(div);
});

function divEvents(div) {
	div.observe("mouseover", function () {
		div.addClassName("lightblue");
	});
	
	div.observe("mouseout", function ()	{
		div.removeClassName("lightblue");
	});

	div.observe("click", function () {
		selectedRowId = div.getAttribute("id");
		div.toggleClassName("selectedRow");
		if (div.hasClassName("selectedRow"))	{
			$$("div[name='row']").each(function (r)	{
				if (div.getAttribute("id") != r.getAttribute("id"))	{
					r.removeClassName("selectedRow");
				}else{
					
				}
		    });			    
			localAmt = $(div.getAttribute("cmNo") + "localAmt").innerHTML.replace(/,/g, "");
			currencyCd = $(div.getAttribute("cmNo") + "currencyCd").getAttribute("currCd");
			currencyRt = $(div.getAttribute("cmNo") + "currencyRt").innerHTML;
			checkDate = $(div.getAttribute("cmNo") + "memoDate").innerHTML;
		    cmNo = div.getAttribute("cmNo");
		    cmTranId = div.getAttribute("cmTranId");//marco - 09.15.2014
		}
	});
}

$("btnCreditMemoOk").observe("click", setSelValues);

function setSelValues(){
	//marco - 09.15.2014
	var selectedRow = -1;
	$$("div[name='row']").each(function (div){
		if(div.hasClassName("selectedRow")){
			selectedRow = 1;
		}
	});
	if(selectedRow == -1){
		showMessageBox("No record selected.", "I");
		return;
	} //end
	$("localCurrAmt").value = localAmt;
	$("currency").value = currencyCd;
	$("currRt").value = currencyRt;
	$("checkDateCalendar").value = checkDate;
	$("checkCreditCardNo").value = cmNo;
	$("hidCmTranId").value = cmTranId; //marco - 09.15.2014
	if (unformatCurrency("deductionComm") != 0 || unformatCurrency("vatAmount") != 0){
		$("origlocalCurrAmt").value = unformatCurrency("localCurrAmt") + (unformatCurrency("deductionComm") + unformatCurrency("vatAmount"));
		$("grossAmt").value = formatCurrency($F("origlocalCurrAmt"));
		$("fcGrossAmt").value = formatCurrency( Math.round((unformatCurrency("origlocalCurrAmt") / parseFloat($F("currRt")))*100)/100 );
		$("origFCGrossAmt").value  = unformatCurrency("fcGrossAmt");
	}else{
		$("origlocalCurrAmt").value = unformatCurrency("localCurrAmt");
		$("grossAmt").value = formatCurrency($F("localCurrAmt"));
		$("fcGrossAmt").value = formatCurrency( Math.round((unformatCurrency("localCurrAmt") / parseFloat($F("currRt"))) *100 ) /100);//formatCurrency($F("localCurrAmt"));
		$("origFCGrossAmt").value = unformatCurrency("fcGrossAmt");
		$("fcNetAmt").value = formatCurrency( Math.round((unformatCurrency("localCurrAmt") / parseFloat($F("currRt"))) *100 ) /100);
	}
	Modalbox.hide();
}

checkIfToResizeTable("creditMemoList", "row");
</script>