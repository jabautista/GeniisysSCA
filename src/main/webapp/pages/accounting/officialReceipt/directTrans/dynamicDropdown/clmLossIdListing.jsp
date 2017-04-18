<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<select style="width: ${width}px;" tabindex="${tabIndex }" id="${listId }" name="${listName }" class="${className }">
	<option value="" claimId="" adviceId=""></option>
	<c:forEach var="clmLossId" items="${listValues}">
		<option value="${clmLossId.dspPayeeDesc}" 
				payeeType="${clmLossId.payeeType }"
				clmLossId="${clmLossId.clmLossId }"
				payeeClassCd="${clmLossId.payeeClassCd }"
				payeeCd="${clmLossId.payeeCd }"
				dspPayeeName="${clmLossId.dspPayeeName }"
				perilCd="${clmLossId.perilCd }"
				dspPerilName="${clmLossId.dspPerilName }"
				dspPerilSname="${clmLossId.dspPerilSname }"
				netAmt="${clmLossId.netAmt }"
				paidAmt="${clmLossId.paidAmt }"
				adviseAmt="${clmLossId.adviseAmt }">${clmLossId.dspPayeeDesc } - ${clmLossId.payeeClassCd}</option>
	</c:forEach>
</select>