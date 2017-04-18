<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="foreignCurrencyMainDiv" style="width: 99.5%; padding-top: 5px;">
	<div class="sectionDiv" style="margin-bottom: 15px;" id="foreignCurrencyFormDiv">
		<table align="center" style="padding: 10px;">
			<tr>
				<td class="rightAligned">Paid Amount&nbsp;</td>
				<td class="leftAligned">
					<input type="text" id="txtPaidFcurrAmt" style="width: 200px;" class="money" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Net Amount&nbsp;</td>
				<td class="leftAligned">					
					<input type="text" id="txtNetFcurrAmt" style="width: 200px;" class="money" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Advice Amount&nbsp;</td>
				<td class="leftAligned">
					<input type="text" id="txtAdvFcurrAmt" style="width: 200px;" class="money" readonly="readonly">
				</td>
			</tr>
		</table>
	</div>
	<div align="center">		
		<input type="button" class="button" id="btnReturn" name="btnReturn" value="Return" style="width: 100px;">		
	</div>
</div>
<script type="text/javascript">
	$("btnReturn").observe("click", function(){
		overlayForeignCurrency.close();
		delete overlayForeignCurrency;
	});
	
	$("txtPaidFcurrAmt").value = formatCurrency(objGICLS032.objCurrGICLAdvice.paidFcurrAmt);
	$("txtNetFcurrAmt").value = formatCurrency(objGICLS032.objCurrGICLAdvice.netFcurrAmt);
	$("txtAdvFcurrAmt").value = formatCurrency(objGICLS032.objCurrGICLAdvice.advFcurrAmt);
</script>