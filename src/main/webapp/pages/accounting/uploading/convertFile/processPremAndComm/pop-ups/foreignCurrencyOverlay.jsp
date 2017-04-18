<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="contentsDiv" >
		<div style="float: left; width: 100%; margin: 10px 0 10px 0;">
			<table align="center" style="float: left; width: 100%;">
				<tr>
					<td class="rightAligned" style="padding-left: 5px;">Currency</td>
					<td class="leftAligned" style="padding-left: 5px;" colspan="2">
						<input class="rightAligned" type="text" id="txtCurrencyCd" readonly="readonly" style="width: 50px; margin-right: 1px; float: left;"/>
						<input type="text" id="txtNbtCurrencyDesc" readonly="readonly" style="width: 230px; margin-left: 0px; float: left;"/>
					</td>
				</tr>			
				<tr>
					<td class="rightAligned" style="padding-left: 5px;">Convert Rate</td>
					<td class="leftAligned" style="padding-left: 5px;" colspan="2">
						<input class="rightAligned" type="text" id="txtConvertRate" readonly="readonly" style="width: 290px"/>
					</td>
				</tr>	
				<tr>
					<td class="rightAligned" style="padding: 25px 60px 0 0;" colspan="3">Difference</td>
				</tr>		
				<tr>
					<td class="rightAligned" style="padding-left: 5px;">Gross Premium</td>
					<td class="leftAligned" style="padding-left: 5px;">
						<input class="rightAligned" type="text" id="txtFGrossPrem" readonly="readonly" style="width: 140px"/>
					</td>
					<td class="leftAligned">
						<input class="rightAligned" type="text" id="txtFGrossPremDiff" readonly="readonly" style="width: 140px"/>
					</td>
				</tr>			
				<tr>
					<td class="rightAligned" style="padding-left: 5px;">Commission</td>
					<td class="leftAligned" style="padding-left: 5px;">
						<input class="rightAligned" type="text" id="txtFComm" readonly="readonly" style="width: 140px"/>
					</td>
					<td class="leftAligned">
						<input class="rightAligned" type="text" id="txtFCommDiff" readonly="readonly" style="width: 140px"/>
					</td>
				</tr>		
				<tr>
					<td class="rightAligned" style="padding-left: 5px;">Withholding Tax</td>
					<td class="leftAligned" style="padding-left: 5px;">
						<input class="rightAligned" type="text" id="txtFWhtax" readonly="readonly" style="width: 140px"/>
					</td>
					<td class="leftAligned">
						<input class="rightAligned" type="text" id="txtFWhtaxDiff" readonly="readonly" style="width: 140px"/>
					</td>
				</tr>		
				<tr>
					<td class="rightAligned" style="padding-left: 5px;">Input VAT</td>
					<td class="leftAligned" style="padding-left: 5px;">
						<input class="rightAligned" type="text" id="txtFInputVAT" readonly="readonly" style="width: 140px"/>
					</td>
					<td class="leftAligned">
						<input class="rightAligned" type="text" id="txtFInputVATDiff" readonly="readonly" style="width: 140px"/>
					</td>
				</tr>		
				<tr>
					<td class="rightAligned" style="padding-left: 5px;">Net Amount Due</td>
					<td class="leftAligned" style="padding-left: 5px;">
						<input class="rightAligned" type="text" id="txtFNetAmtDue" readonly="readonly" style="width: 140px"/>
					</td>
					<td class="leftAligned">
						<input class="rightAligned" type="text" id="txtFNetAmtDueDiff" readonly="readonly" style="width: 140px"/>
					</td>
				</tr>					
			</table>
		</div>
		<div align="center" style="padding: 35px 0 15px 0;">
			<input type="button" id="btnReturn" class="button" value="Return" style="width: 90px;"/>
		</div>
</div>

<script type="text/javascript">
try{
	var objFCurr = objGUPC;
	
	$("txtCurrencyCd").value = objFCurr.currencyCd;
	$("txtNbtCurrencyDesc").value = unescapeHTML2(objFCurr.nbtCurrencyDesc);
	$("txtConvertRate").value = formatToNineDecimal(nvl(objFCurr.convertRate, 0));
	$("txtFGrossPrem").value = formatCurrency(nvl(objFCurr.fgrossPremAmt, 0));
	$("txtFComm").value = formatCurrency(nvl(objFCurr.fcommAmt, 0));
	$("txtFWhtax").value = formatCurrency(nvl(objFCurr.fwhtaxAmt, 0));
	$("txtFInputVAT").value = formatCurrency(nvl(objFCurr.finputVATAmt, 0));
	$("txtFNetAmtDue").value = formatCurrency(nvl(objFCurr.fnetAmtDue, 0));
	$("txtFGrossPremDiff").value = formatCurrency(nvl(objFCurr.nbtFgpremAmtDiff, 0));
	$("txtFCommDiff").value = formatCurrency(nvl(objFCurr.nbtFommAmtDiff, 0));
	$("txtFWhtaxDiff").value = formatCurrency(nvl(objFCurr.nbtFwhtaxAmtDiff, 0));
	$("txtFInputVATDiff").value = formatCurrency(nvl(objFCurr.nbtFinputVATAmtDiff, 0));
	$("txtFNetAmtDueDiff").value = formatCurrency(nvl(objFCurr.nbtFnetDueDiff, 0));
	
	$("btnReturn").observe("click", function(){
		overlayFCurr.close();
	});
}catch(e){
	showErrorMessage("page error", e);
}
</script>