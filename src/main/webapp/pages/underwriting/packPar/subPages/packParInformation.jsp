<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" name="innerDiv">
		<label><c:if test="${not empty isPack}">Package </c:if>PAR Information</label>
		<span class="refreshers" style="margin-top: 0;">
			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
			<label id="reloadForm" name="reloadForm">Reload Form</label>
		</span>
	</div>
</div>

<div class="sectionDiv" id="parInfoMainDiv" name="parInfoMainDiv">
	<div id="parInfo" name="parInfoTop" style="margin: 10px;">
		<table align="center" border="0">
			<tr>
				<td class="rightAligned"><c:if test="${not empty isPack}">Pack </c:if>PAR No.</td>
				<td class="leftAligned"><input type="text" style="width: 250px;" id="parNo" name="parNo" readonly="readonly" value="${parNo}"/></td>
				<td id="assdTitle" name="assdTitle" class="rightAligned" width="100px">Assured Name</td>
				<td class="leftAligned"><input type="text" style="width: 250px;" id="assuredName" name="assuredName" readonly="readonly" value="${assdName}" /></td>					
				<td>				
					<input type="hidden" id="provPremTag" 		name="provPremTag" 		value="${wPolBasic.provPremTag}"/>
					<input type="hidden" id="prorateFlag" 		name="prorateFlag" 		value="${wPolBasic.prorateFlag}"/>
					<input type="hidden" id="endtExpiryDate" 	name="endtExpiryDate" 	value="${wPolBasic.endtExpiryDate}"/>
					<input type="hidden" id="effDate" 			name="effDate" 			value="${wPolBasic.effDate}"/>
					<input type="hidden" id="shortRtPercent" 	name="shortRtPercent" 	value="${wPolBasic.shortRtPercent}"/>
					<input type="hidden" id="provPremPct" 		name="provPremPct" 		value="${wPolBasic.provPremPct}"/>
					<input type="hidden" id="provPremTag" 		name="provPremTag" 		value="${wPolBasic.provPremTag}"/>
					<input type="hidden" id="expiryDate" 		name="expiryDate" 		value="${wPolBasic.expiryDate}"/>
					<input type="hidden" id="withTariffSw" 		name="withTariffSw" 	value="${wPolBasic.withTariffSw}"/>
					<input type="hidden" id="nbtSublineCd" 		name="nbtSublineCd" 	value="${wPolBasic.sublineCd}"/>
					<input type="hidden" id="nbtProrateFlag" 	name="nbtProrateFlag" 	value="${wPolBasic.prorateFlag}"/>
					<input type="hidden" id="compSw" 			name="compSw" 			value="${wPolBasic.compSw}"/>
					<input type="hidden" id="wItemParCount"		name="wItemParCount" 	value="${wItemParCount}"/>
					<input type="hidden" id="distNo"			name="distNo" 			value="${distNo}"/>
					
					<!-- EXISTENCE CHECK OF PAR ON VARIOUS TABLES -->
				</td>
			</tr>
			<tr>
				<td class="rightAligned">
					<c:if test="${parType eq 'E'}">
						Policy No.
					</c:if>	
				</td>
				<td class="leftAligned">
					<c:if test="${parType eq 'E'}">
						<input type="text" style="width: 250px;" id="policyNo" name="policyNo" readonly="readonly" value="${policyNo }"/>
					</c:if>		
				</td>
				<td class="rightAligned">
					<label id="lblAcctOf" style="float: right;">In Account Of</label>	
				</td>
				<td class="leftAligned">
					<input type="text" style="width: 250px;" id="acctOfName" name="acctOfName" readonly="readonly" value="${acctOfName}" />
				</td>
			</tr>
		</table>
	</div>
</div>

<script type="text/javaScript">
/*
	var acctOfCd = '${acctOfCd}';
	if ((acctOfCd == "" || acctOfCd == null) && ($("lblModuleId").getAttribute("moduleId") != "GIPIS026") ){
		$("lblAcctOf").innerHTML = "";
		$("acctOfName").hide();
	}*/
	$("parNo").value = objUWParList.parNo;
	$("assuredName").value = unescapeHTML2(objUWParList.assdName); //changed escape to unescpate; christian 12132012
	$("acctOfName").value = unescapeHTML2(objGIPIWPolbas.acctOfName);

	$("parNo").setAttribute("title", objUWParList.parNo);
	$("assuredName").setAttribute("title", unescapeHTML2(objUWParList.assdName));	
	$("acctOfName").setAttribute("title", unescapeHTML2(objGIPIWPolbas.acctOfName)); //changed element into acctOfName; christian 12132012
	
</script>
