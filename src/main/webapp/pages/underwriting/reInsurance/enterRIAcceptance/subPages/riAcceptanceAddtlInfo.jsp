<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
  pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div id="addtlInfoDiv" changeTagAttr="true">
	<table align="center" style="margin-bottom: 5px; margin-top: 5px; margin-bottom: 7px;">
		<tr>
			<td class="rightAligned" width="120px;">Reinsurer</td>
			<td class="leftAligned" width="230px;">
				<input type="text" id="frpsReinsurer" name="frpsReinsurer" style="width: 180px;" readonly="readonly"  />
			</td>
			<td class="rightAligned" width="160px;">RI Commission %</td>
			<td class="leftAligned" width="230px;">
				<input type="text" id="frpsRiCommRate" name="frpsRiCommRate" class="moneyRate" style="width: 180px;" readonly="readonly"  />
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width="120px;">RI TSI Amount</td>
			<td class="leftAligned" width="230px;">
				<input type="text" id="frpsRiTsiAmt" name="frpstRiTsiAmt" class="money" style="width: 180px;" readonly="readonly"  />
			</td>
			<td class="rightAligned" width="160px;">RI Comm. Amt</td>
			<td class="leftAligned" width="230px;">
				<input type="text" id="frpsRiCommAmt" name="frpsRiCommAmt" class="money" style="width: 180px;" readonly="readonly"  />
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width="120px;">RI Share %</td>
			<td class="leftAligned" width="230px;">
				<input type="text" id="frpsRiSharePct" name="frpsRiSharePct" class="moneyRate" style="width: 180px;" readonly="readonly"  />
			</td>
			<td class="rightAligned" width="160px;">RI Commission Vat</td>
			<td class="leftAligned" width="230px;">
				<input type="text" id="frpsRiCommVat" name="frpsRiCommVat" class="money" style="width: 180px;" readonly="readonly"  />
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width="120px;">RI Prem. Amt</td>
			<td class="leftAligned" width="230px;">
				<input type="text" id="frpsRiPremAmt" name="frpsRiPremAmt" class="money" style="width: 180px;" readonly="readonly"  />
			</td>
			<td class="rightAligned" width="160px;">Premium Tax</td>
			<td class="leftAligned" width="230px;">
				<input type="text" id="frpsPremTax" name="frpsPremTax" class="money" style="width: 180px;" readonly="readonly"  />
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width="120px;">RI Premium VAT</td>
			<td class="leftAligned" width="230px;">
				<input type="text" id="frpsRiPremVat" name="frpsRiPremVat" class="money" style="width: 180px;" readonly="readonly"  />
			</td>
			<td class="rightAligned" width="160px;">Net Due</td>
			<td class="leftAligned" width="230px;">
				<input type="text" id="frpsNetDue" name="frpsNetDue" class="money" style="width: 180px;" readonly="readonly"  />
			</td>
		</tr>
	</table>
</div>

<script>
	initializeAllMoneyFields();
</script>