<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="recoveryAmountsMainDiv" class="sectionDiv" style="width: 315px; margin: 5px;" align="center">
	<table cellspacing="2" border="0" align="center" style="margin: 10px; width:100%;">
		<tr>
			<td class="rightAligned" style="width:40%;">Recoverable Amount</td>
			<td class="leftAligned" style="width:60%; padding-left: 5px;"><input type="text" id="recoverableAmount" tabindex="1" style="width: 150px; text-align: right;" value="<fmt:formatNumber pattern="###,###,###,###,##0.00" value="${recoverableAmt}" />" readOnly="readonly" /></td>
		</tr>	
		<tr>
			<td class="rightAligned" style="width:40%;">Recovered Amount</td>
			<td class="leftAligned" style="width:60%; padding-left: 5px;"><input type="text" id="recoveredAmount" style="width: 150px; text-align: right;" tabindex="2" value="<fmt:formatNumber pattern="###,###,###,###,##0.00" value="${recoveredAmt}" />" readOnly="readonly" /></td>	
		</tr>
	</table>
</div>
<div id="buttonsDiv" style="text-align: center;">
	<input type="button" class="button" id="btnOk" value="Return" style="width: 120px;"/>
</div>

<script type="text/javascript">
	$("btnOk").observe("click", function(){Windows.close("recovery_amts_canvas");});
</script>