<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div align="center">
	<div align="center" style="width: 90%; height: 80%; float: left; font-size: 11px; margin: 20px;" id="currInfoDiv">
		<div align="center" class="sectionDiv" style="margin-bottom: 7px;">
			<table align="center">
				<tr>
					<td style="width: 100px;" class="rightAligned">Currency</td>
					<td><input readonly="readonly" type="text"
						id="txtcurrencyDesc2" name="txtcurrencyDesc2"
						style="width: 180px;" /></td>
				</tr>
				<tr>
					<td class="rightAligned">Conversion Rate</td>
					<td><input readonly="readonly" class="rightAligned"
						type="text" id="txtCurrencyRt2" name="txtCurrencyRt2"
						style="width: 180px;" /></td>
				</tr>
				<tr>
					<td style="width: 100px;" class="rightAligned">Premium Amount</td>
					<td><input readonly="readonly" class="rightAligned"
						type="text" id="txtForeignPrem2" name="txtForeignPrem2"
						style="width: 180px;" /></td>
				</tr>
				<tr>
					<td class="rightAligned">Commission Amount</td>
					<td><input readonly="readonly" class="rightAligned"
						type="text" id="txtForeignComm2" name="txtForeignComm2"
						style="width: 180px;" /></td>
				</tr>
				<tr>
					<td style="width: 100px;" class="rightAligned">Vat on Comm</td>
					<td><input readonly="readonly" class="rightAligned"
						type="text" id="txtForeignCommVat2" name="txtForeignCommVat2"
						style="width: 180px;" /></td>
				</tr>
				<tr>
					<td class="rightAligned">Total Amount Due</td>
					<td><input readonly="readonly" class="rightAligned"
						type="text" id="txtForeignTotalAmountDue2"
						name="txtForeignTotalAmountDue2" style="width: 180px;" /></td>
				</tr>
			</table>
		</div>
		<form>
			<input class="button" type="button" id="btnReturn" name="btnReturn"
				value="Return" ;/>
		</form>
	</div>
</div>

<script>
	function populateCurrencyInfo(obj) {
		try {
			$("txtcurrencyDesc2").value = obj == null ? "0.00"
					: unescapeHTML2(nvl(obj.currDesc, ""));
			$("txtCurrencyRt2").value = obj == null ? "" : /*formatCurrency(nvl(
					obj.currencyRt, ""))*/ obj.currencyRt;
			$("txtForeignPrem2").value = obj == null ? "" : formatCurrency(nvl(
					obj.foreignPrem, ""));
			$("txtForeignComm2").value = obj == null ? "" : formatCurrency(nvl(
					obj.foreignComm, ""));
			$("txtForeignCommVat2").value = obj == null ? ""
					: formatCurrency(nvl(obj.foreignCommVat, ""));
			$("txtForeignTotalAmountDue2").value = obj == null ? ""
					: formatCurrency(nvl(obj.foreignTotAmtDue, ""));

		} catch (e) {
			showErrorMessage("populateCurrencyInfo", e);
		}
	}
	$("btnReturn").observe("click", function() {
		currencyInfoOvlerlay.close();
		delete currencyInfoOvlerlay;
	});
	populateCurrencyInfo(giacs270GipiInvoice);
</script>