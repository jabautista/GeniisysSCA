<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>

<div id="foreignCurrMainDiv" class="sectionDiv" style="text-align: center; width: 99%; margin-bottom: 5px;">
	<table border="0" align="center" style="margin-top: 10px;">
		<tr>
			<td class="rightAligned">Currency :</td>
			<td><input class="leftAligned" type="text" id="fCurrCd" style="width: 20px; margin-right: 2px;" value="${currCd}" readOnly="readonly"></input><input type="text" id="fCurrCdDesc" style="width: 102px;" value="${currDesc}" readOnly="readonly" ></td>
		</tr>
		<tr>
			<td class="rightAligned">Rate :</td>
			<td><input class="rightAligned" type="text" id="fCurrRt" value="${currRt}" readOnly="readonly"></td>
		</tr>
		<tr>
			<td class="rightAligned">Foreign Curr. Amt. :</td>
			<td><input class="rightAligned" type="text" id="fCurrAmt" value="${currAmt}" readOnly="readonly"></td>
		</tr>
	</table>
</div>
<div id="buttonsDiv" style="text-align: center; margin-bottom: 5px;">
	<input type="button" class="button" id="btnBack" value="Back" />
</div>

<script>
	$("close").hide();//added by steven 10.30.2013
	$("btnBack").observe("click", function(){
		hideOverlay();
	});
	$("fCurrRt").value = formatRate($F("fCurrRt"));
	$("fCurrAmt").value =  formatCurrency($F("fCurrAmt"));
</script>