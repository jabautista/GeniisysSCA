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
					<td class="rightAligned" style="padding-left: 5px;">Premium</td>
					<td class="leftAligned" style="padding-left: 5px;">
						<input class="rightAligned" type="text" id="txtFpremAmt" readonly="readonly" style="width: 140px"/>
					</td>
					<td class="leftAligned">
						<input class="rightAligned" type="text" id="txtDspFpremDiff" readonly="readonly" style="width: 140px"/>
					</td>
				</tr>			
				<tr>
					<td class="rightAligned" style="padding-left: 5px;">Tax</td>
					<td class="leftAligned" style="padding-left: 5px;">
						<input class="rightAligned" type="text" id="txtFtaxAmt" readonly="readonly" style="width: 140px"/>
					</td>
					<td class="leftAligned">
						<input class="rightAligned" type="text" id="txtDspFtaxDiff" readonly="readonly" style="width: 140px"/>
					</td>
				</tr>		
				<tr>
					<td class="rightAligned" style="padding-left: 5px;">Commission</td>
					<td class="leftAligned" style="padding-left: 5px;">
						<input class="rightAligned" type="text" id="txtFcommAmt" readonly="readonly" style="width: 140px"/>
					</td>
					<td class="leftAligned">
						<input class="rightAligned" type="text" id="txtDspFcommDiff" readonly="readonly" style="width: 140px"/>
					</td>
				</tr>		
				<tr>
					<td class="rightAligned" style="padding-left: 5px;">VAT on Comm</td>
					<td class="leftAligned" style="padding-left: 5px;">
						<input class="rightAligned" type="text" id="txtFcommVat" readonly="readonly" style="width: 140px"/>
					</td>
					<td class="leftAligned">
						<input class="rightAligned" type="text" id="txtDspFvatDiff" readonly="readonly" style="width: 140px"/>
					</td>
				</tr>		
				<tr>
					<td class="rightAligned" style="padding-left: 5px;">Premium Due</td>
					<td class="leftAligned" style="padding-left: 5px;">
						<input class="rightAligned" type="text" id="txtFcollectionAmt" readonly="readonly" style="width: 140px"/>
					</td>
					<td class="leftAligned">
						<input class="rightAligned" type="text" id="txtFcollectDiff" readonly="readonly" style="width: 140px"/>
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
	var objFCurr = objGIUP;
	
	$("txtCurrencyCd").value = objFCurr.currencyCd;
	$("txtNbtCurrencyDesc").value = unescapeHTML2(objFCurr.dspCurrency);
	$("txtConvertRate").value = formatToNineDecimal(nvl(objFCurr.convertRate, 0));
	$("txtFpremAmt").value = formatCurrency(nvl(objFCurr.fpremAmt, 0));
	$("txtFtaxAmt").value = formatCurrency(nvl(objFCurr.ftaxAmt, 0));
	$("txtFcommAmt").value = formatCurrency(nvl(objFCurr.fcommAmt, 0));
	$("txtFcommVat").value = formatCurrency(nvl(objFCurr.fcommVat, 0));
	$("txtFcollectionAmt").value = formatCurrency(nvl(objFCurr.fcollectionAmt, 0));
	$("txtDspFpremDiff").value = formatCurrency(nvl(objFCurr.dspFpremDiff, 0));
	$("txtDspFtaxDiff").value = formatCurrency(nvl(objFCurr.dspFtaxDiff, 0));
	$("txtDspFcommDiff").value = formatCurrency(nvl(objFCurr.dspFtaxDiff, 0));
	$("txtDspFvatDiff").value = formatCurrency(nvl(objFCurr.dspFvatDiff, 0));
	$("txtFcollectDiff").value = formatCurrency(nvl(objFCurr.dspFcollectDiff, 0));
	
	$("btnReturn").observe("click", function(){
		overlayFCurr.close();
		delete overlayFCurr;
	});
}catch(e){
	showErrorMessage("page error", e);
}
</script>