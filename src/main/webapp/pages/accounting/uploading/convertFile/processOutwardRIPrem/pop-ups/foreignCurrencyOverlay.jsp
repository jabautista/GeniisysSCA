<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="foreignCurrencyDiv">
	<div style="float: left; width: 100%; margin: 10px 0 10px 0;">
		<table align="center" style="float: left; width: 100%;">
			<tr>
				<td class="rightAligned" style="padding-left: 5px;">Currency</td>
				<td class="leftAligned" style="padding-left: 5px;" colspan="2">
					<input class="rightAligned" type="text" id="txtCurrencyCd" readonly="readonly" style="width: 50px; margin-right: 1px; float: left;" tabIndex="501" />
					<input type="text" id="txtCurrencyDesc" readonly="readonly" style="width: 230px; margin-left: 0px; float: left;" tabIndex="502" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-left: 5px;">Convert Rate</td>
				<td class="leftAligned" style="padding-left: 5px;" colspan="2">
					<input class="rightAligned" type="text" id="txtConvertRate" readonly="readonly" style="width: 290px" tabIndex="503" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding: 25px 75px 5px 0;" colspan="3">Difference</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-left: 5px;">Premium</td>
				<td class="leftAligned" style="padding-left: 5px;">
					<input class="rightAligned" type="text" id="txtFpremAmt" readonly="readonly" style="width: 140px" tabIndex="504" />
				</td>
				<td class="leftAligned">
					<input class="rightAligned" type="text" id="txtDspFpremDiff" readonly="readonly" style="width: 140px" tabIndex="505" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-left: 5px;">Tax</td>
				<td class="leftAligned" style="padding-left: 5px;">
					<input class="rightAligned" type="text" id="txtFpremVat" readonly="readonly" style="width: 140px" tabIndex="506" />
				</td>
				<td class="leftAligned">
					<input class="rightAligned" type="text" id="txtDspFpvatDiff" readonly="readonly" style="width: 140px" tabIndex="507" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-left: 5px;">Commission</td>
				<td class="leftAligned" style="padding-left: 5px;">
					<input class="rightAligned" type="text" id="txtFcommAmt" readonly="readonly" style="width: 140px" tabIndex="508" />
				</td>
				<td class="leftAligned">
					<input class="rightAligned" type="text" id="txtDspFcamtDiff" readonly="readonly" style="width: 140px" tabIndex="509" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-left: 5px;">VAT on Comm</td>
				<td class="leftAligned" style="padding-left: 5px;">
					<input class="rightAligned" type="text" id="txtFcommVat" readonly="readonly" style="width: 140px" tabIndex="510" />
				</td>
				<td class="leftAligned">
					<input class="rightAligned" type="text" id="txtDspFcvatDiff" readonly="readonly" style="width: 140px" tabIndex="511" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-left: 5px;">Withholding VAT</td>
				<td class="leftAligned" style="padding-left: 5px;">
					<input class="rightAligned" type="text" id="txtFwholdingVat" readonly="readonly" style="width: 140px" tabIndex="512" />
				</td>
				<td class="leftAligned">
					<input class="rightAligned" type="text" id="txtDspFwvatDiff" readonly="readonly" style="width: 140px" tabIndex="513" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-left: 5px;">Premium Due</td>
				<td class="leftAligned" style="padding-left: 5px;">
					<input class="rightAligned" type="text" id="txtFdisbAmt" readonly="readonly" style="width: 140px" tabIndex="514" />
				</td>
				<td class="leftAligned">
					<input class="rightAligned" type="text" id="txtDspFdisbDiff" readonly="readonly" style="width: 140px" tabIndex="515" />
				</td>
			</tr>
		</table>
	</div>
	<div align="center" style="padding: 35px 0 15px 0;">
		<input type="button" id="btnReturn" class="button" value="Return" style="width: 90px;" tabIndex="516" />
	</div>
</div>

<script type="text/javascript">
	try {
		var objFC = objGUOP;

		$("txtCurrencyCd").value = objFC.currencyCd;
		$("txtCurrencyDesc").value = unescapeHTML2(objFC.currencyDesc);
		$("txtConvertRate").value = formatToNineDecimal(nvl(objFC.convertRate, 1));
		$("txtFpremAmt").value = formatCurrency(nvl(objFC.fpremAmt, 0));
		$("txtFpremVat").value = formatCurrency(nvl(objFC.fpremVat, 0));
		$("txtFcommAmt").value = formatCurrency(nvl(objFC.fcommAmt, 0));
		$("txtFcommVat").value = formatCurrency(nvl(objFC.fcommVat, 0));
		$("txtFwholdingVat").value = formatCurrency(nvl(objFC.fwholdingVat, 0));
		$("txtFdisbAmt").value = formatCurrency(nvl(objFC.fdisbAmt, 0));
		$("txtDspFpremDiff").value = formatCurrency(nvl(objFC.dspFpremDiff, 0));
		$("txtDspFpvatDiff").value = formatCurrency(nvl(objFC.dspFpvatDiff, 0));
		$("txtDspFcamtDiff").value = formatCurrency(nvl(objFC.dspFcamtDiff, 0));
		$("txtDspFcvatDiff").value = formatCurrency(nvl(objFC.dspFcvatDiff, 0));
		$("txtDspFwvatDiff").value = formatCurrency(nvl(objFC.dspFwvatDiff, 0));
		$("txtDspFdisbDiff").value = formatCurrency(nvl(objFC.dspFdisbDiff, 0));
		
		$("btnReturn").focus();
		
		$("btnReturn").observe("keydown", function(event) {
			if (event.keyCode == 9 && !event.shiftKey) {
				$("txtCurrencyCd").focus();
				event.preventDefault();
			}
		});
		
		$("txtCurrencyCd").observe("keydown", function(event) {
			if (event.keyCode == 9 && event.shiftKey) {
				$("btnReturn").focus();
				event.preventDefault();
			}
		});
		
		$("btnReturn").observe("click", function() {
			overlayFC.close();
		});
	} catch (e) {
		showErrorMessage("showFC", e);
	}
</script>