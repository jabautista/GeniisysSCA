<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>

<div id="foreignCurrMainDiv" class="sectionDiv" style="text-align: center; width: 99.6%;">
	<table border="0" align="center" style="margin-top: 10px; margin-bottom: 10px;">
		<tr>
			<td align="right">Currency :</td>
			<td><input type="text" id="fCurrCd" style="width: 50px; margin-left: 30px; margin-right: 2px;" value="" readOnly="readonly"></input><input type="text" id="fCurrCdDesc" style="width: 200px;" value="" readOnly="readonly" ></td>
		</tr>
		<tr>
			<td align="right">Rate :</td>
			<td><input class="rightAligned" style="margin-left: 30px; width: 260px;" type="text" id="fCurrRt" value="0.00" readOnly="readonly"></td>
		</tr>
		<tr>
			<td align="right">Foreign Curr. Amt. :</td>
			<td><input class="rightAligned" style="margin-left: 30px; width: 260px" type="text" id="fCurrAmt" value="0.00" readOnly="readonly"></td>
		</tr>
	</table>
</div>
<div id="buttonsDiv" style="text-align: center; padding: 10px;">
	<input type="button" class="button" id="btnBack" value="Back" style="margin-top: 10px; width: 100px;"/>
</div>

<script>
	$("btnBack").observe("click", hideOverlay);
</script>