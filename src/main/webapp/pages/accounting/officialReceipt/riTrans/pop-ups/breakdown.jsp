<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>
<div id="spinLoadingDiv"></div>
<div class="sectionDiv" id="breakdownDiv" style="width: 99%;">
	<table width="90%" align="center" cellspacing="1" border="0" style="margin-top: 10px;">
		<tr>
			<td class="rightAligned">Premium Amount</td>
			<td class="leftAligned"><input type="text" id="premAmt" value="${breakdownDtlsMap.premAmt}" style="text-align: right;" readonly="readonly" /></td>
		</tr>
		<tr>
			<td class="rightAligned">Premium VAT</td>
			<td class="leftAligned"><input type="text" id="premVat" value="${breakdownDtlsMap.premVat}" style="text-align: right;" readonly="readonly"  /></td>
		</tr>
		<tr>
			<td class="rightAligned">Comm Amount</td>
			<td class="leftAligned"><input type="text" id="commAmt" value="${breakdownDtlsMap.commAmt}" style="text-align: right;" readonly="readonly"  /></td>
		</tr>
		<tr>
			<td class="rightAligned">Comm VAT</td>
			<td class="leftAligned"><input type="text" id="commVat" value="${breakdownDtlsMap.commVat}" style="text-align: right;" readonly="readonly"  /></td>
		</tr>
		<tr>
			<td class="rightAligned">Wholding VAT</td>
			<td class="leftAligned"><input type="text" id="wholdingVat" value="${breakdownDtlsMap.wholdingTax}" style="text-align: right;" readonly="readonly"  /></td>
		</tr>
		<tr>
 			<td>		
 			</td>
		</tr>
	</table>
	<input type="button" class="button" id="btnOk" name="btnOk" value="Ok" style="margin-right: 1px; width: 60px; margin-left: 152px; margin-top: 5px; margin-bottom: 10px;"/>
</div>

<script>
	//var breakdownDtls = JSON.parse('${breakdownDtls}'.replace(/\\/g, '\\\\'));
	$("close").hide();//added by steven 10.30.2013
	$("btnOk").observe("click", hideOverlay);
	
	
	$("premAmt").value = formatCurrency($("premAmt").value);
	$("premVat").value = formatCurrency($("premVat").value);
	$("commAmt").value = formatCurrency($("commAmt").value);
	$("commVat").value = formatCurrency($("commVat").value);
	$("wholdingVat").value = formatCurrency($("wholdingVat").value);
</script>