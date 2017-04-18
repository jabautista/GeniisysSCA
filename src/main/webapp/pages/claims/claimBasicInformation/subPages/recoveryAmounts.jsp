<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>
<div id="recoveryAmountsMainDiv" class="sectionDiv" style="width: 307px; margin: 5px 10px;" align="center">
	<table border="0" align="center" style="margin-top: 10px; width:100%;" >
		<tr>
			<td class="rightAligned" style="width:41%;">Recoverable Amount</td>
			<td class="leftAligned" style="width:59%;"><input type="text" id="recoverableAmount" tabindex="1" style="width: 150px; text-align: right;" value="<fmt:formatNumber pattern="###,###,###,###,##0.00" value="${recoverableAmt}" />" readOnly="readonly" /></td>
		</tr>	
		<tr>
			<td class="rightAligned" >Recovered Amount</td>
			<td class="leftAligned"><input type="text" id="recoveredAmount" style="width: 150px; text-align: right;" tabindex="2" value="<fmt:formatNumber pattern="###,###,###,###,##0.00" value="${recoveredAmt}" />" readOnly="readonly" /></td>	
		</tr>
	</table>
</div>
<div id="buttonsDiv" style="text-align: center; margin-bottom: 10px;">
	<input type="button" class="button" id="btnOk" value="Return" style="width: 120px;"/>
</div>
<script>
	$("btnOk").observe("click", hideOverlay);
</script>