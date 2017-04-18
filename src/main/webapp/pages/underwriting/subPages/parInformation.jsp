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
		<label id="lblParInfoTitle"><c:if test="${'Y' eq isPack}">Package </c:if>PAR Information</label>
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
				<td class="rightAligned" id="tdParNoLabel"><c:if test="${'Y' eq isPack}">Pack </c:if>PAR No.</td>
				<td class="leftAligned"><input type="text" style="width: 250px;" id="parNo" name="parNo" readonly="readonly" 
					<c:if test="${'Y' ne isPack }">
						value="${parNo}"
					</c:if>
				/></td>
				<td id="assdTitle" name="assdTitle" class="rightAligned" width="100px">Assured Name</td>
				<td class="leftAligned"><input type="text" style="width: 250px;" id="assuredName" name="assuredName" readonly="readonly"/> 
				<!-- commented out by reymon 03192013
				     since assured name handle on script
					<c:if test="${'Y' ne isPack }">
						value="${assdName}" 
					</c:if>
				/> -->
				</td>
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
						<c:if test="${'Y' eq isPack}">Pack </c:if>Policy No.
					</c:if>	
				</td>
				<td class="leftAligned">
					<c:if test="${parType eq 'E'}">
						<input type="text" style="width: 250px;" id="policyNo" name="policyNo" readonly="readonly" value="${policyNo }"/>
					</c:if>		
				</td>
				<td class="rightAligned">
					<!-- Tonio Jan 21, 2011 Removed not empty acctOfCd condition and moved to script for showing 
					in acct of details in Bill Premium module even if acctOfCd is null-->
					<label id="lblAcctOf" style="float: right;">In Account Of</label>	
				</td>
				<td class="leftAligned">
					<input type="text" style="width: 250px;" id="acctOfName" name="acctOfName" readonly="readonly" value="${acctOfName}" />
				</td>
			</tr>
			<c:if test="${!empty forDist}">
			<tr
				<c:if test="${'Y' eq isPack}">
					style="display: none"
				</c:if>
			>
				<td class="rightAligned">
					<label id="lblAcctOf" style="float: right;">Dist. No.</label>	
				</td>
				<td class="leftAligned">
					<input class="rightAligned" type="text" style="width: 90px;" id="txtC080DistNo" name="txtC080DistNo" readonly="readonly" value="" />
				</td>
				<td class="rightAligned">
					<label id="lblAcctOf" style="float: right;">Dist. Status</label>	
				</td>
				<td class="leftAligned">
					<input type="text" style="width: 40px;" id="txtC080DistFlag" name="txtC080DistFlag" readonly="readonly" value="" />
					<input type="text" style="width: 198px;" id="txtC080MeanDistFlag" name="txtC080MeanDistFlag" readonly="readonly" value="" />
				</td>
			</tr>
			<tr
				<c:if test="${'Y' eq isPack}">
					style="display: none"
				</c:if>
			>
				<td class="rightAligned">
					<label id="lblAcctOf" style="float: right;">Multi Booking Date</label>	
				</td>
				<td class="leftAligned">
					<input type="text" style="width: 120px;" id="txtC080MultiBookingMm" name="txtC080MultiBookingMm" readonly="readonly" value="" />
					<input type="text" style="width: 100px;" id="txtC080MultiBookingYy" name="txtC080MultiBookingYy" readonly="readonly" value="" />
				</td>
			</tr>	
			</c:if>
			<c:if test="${!empty forSetUpGroupsDist}">
			<tr
				<c:if test="${'Y' eq isPack}">
					style="display: none"
				</c:if>
			>
				<td class="rightAligned">
					<label id="lblAcctOf" style="float: right;">Dist. No.</label>	
				</td>
				<td class="leftAligned">
					<input class="rightAligned" type="text" style="width: 90px;" id="txtC080DistNo" name="txtC080DistNo" readonly="readonly" value="" />
				</td>
				<td class="rightAligned">
					<label id="lblAcctOf" style="float: right;">Dist. Status</label>	
				</td>
				<td class="leftAligned">
					<input type="text" style="width: 40px;" id="txtC080DistFlag" name="txtC080DistFlag" readonly="readonly" value="" />
					<input type="text" style="width: 198px;" id="txtC080MeanDistFlag" name="txtC080MeanDistFlag" readonly="readonly" value="" />
				</td>
			</tr>
			</c:if>
		</table>
	</div>
</div>

<script type="text/javaScript">
	var acctOfCd = '${acctOfCd}';
	if ((acctOfCd == "" || acctOfCd == null) && ($("lblModuleId").getAttribute("moduleId") != "GIPIS026") ){
		$("lblAcctOf").innerHTML = "";
		$("acctOfName").hide();
	}
	
	if(objUWGlobal.packParId == null || objUWGlobal.packParId == undefined){ // andrew - 07.18.2011 - added condition for package
		$("parNo").value = objUWParList.parNo;
		$("parNo").setAttribute("title", objUWParList.parNo); // changed by: Nica to unescapeHTML2 to handle all HTML escape characters
		$("assuredName").value = unescapeHTML2(nvl(objUWParList.assdName,"")); //changeSingleAndDoubleQuotes(nvl(objUWParList.assdName,""));
		$("assuredName").setAttribute("title", unescapeHTML2(nvl(objUWParList.assdName,"")));//changeSingleAndDoubleQuotes(nvl(objUWParList.assdName,"")));	

	} else {
		$("parNo").value = objUWGlobal.parNo;
		$("parNo").setAttribute("title", objUWGlobal.parNo);
		$("assuredName").value = unescapeHTML2(nvl(objUWParList.assdName,"")); //changeSingleAndDoubleQuotes(nvl(objUWGlobal.assdName,""));
		$("assuredName").setAttribute("title", unescapeHTML2(nvl(objUWParList.assdName,""))); //changeSingleAndDoubleQuotes(nvl(objUWGlobal.assdName,"")));	
	}
	if("${parType}" == "E") $("policyNo").value = unescapeHTML2(objUWParList.endtPolicyNo);
	if("${parType}" == "E") $("policyNo").setAttribute("title", objUWParList.endtPolicyNo);
	if(objUWGlobal.lineCd == "SU" || objUWGlobal.menuLineCd == "SU") $("assdTitle").innerHTML = "Principal";
</script>
