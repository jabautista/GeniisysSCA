<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
		<label id="lblPkgParListSubPage">Package PAR Policy</label>
		<span class="refreshers" style="margin-top: 0;">
			<label name="gro" style="margin-left: 5px;">Hide</label>
		</span>
	</div>
</div>

<div class="sectionDiv"	id="packParPolicyListDiv">
	<div id="searchResultPackParPolicy"	align="center" style="margin: 10px;">
		<div style="width: 100%;">
			<input type="hidden" id="pageName" name="pageName" value="${pageName}"></input>
			<div id="polTableHeader" class="tableHeader">
				<label style="width: 25%; text-align: left; margin-left: 5px;">Par No.</label>
				<label style="width: 22%;">Line Name</label>
				<label style="width: 25%">Subline Name</label>
				<c:if test="${packParType eq 'E'}">
					<label style="width: 25%">Policy No.</label>
				</c:if>
			</div>
			<c:if test="${empty pol}">
				<div class="tableRow"></div>
			</c:if>
			<div id="packParPolicyContainer" class="tableContainer">
				<c:forEach var="pol" items="${pol}">
					<div id="polRow${pol.parId}" class="tableRow" name="polRow" parId="${pol.parId}" lineCd="${pol.lineCd}" 
						 sublineCd="${pol.sublineCd}" issCd="${pol.issCd}" issueYy ="${pol.issueYy}" polSeqNo="${pol.polSeqNo}">
						<label style="width: 25%; text-align: left; margin-left: 5px;">${pol.parNo}</label>
						<label style="width: 22%; text-align: left;">${pol.lineName}</label>
						<label style="width: 25%; text-align: left;">${pol.sublineName}</label>
						<c:if test="${packParType eq 'E'}">
							<label style="width: 25%; text-align: left;">${pol.policyNo}</label>
						</c:if>
					</div>
				</c:forEach>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	parType = '${packParType}';
	
	if(nvl(parType, "P") == "P"){
		$("polTableHeader").down("label", 0).setStyle("width: 35%;");
		$("polTableHeader").down("label", 1).setStyle("width: 25%;");
		$("polTableHeader").down("label", 2).setStyle("width: 35%;");
	
		$$("div[name='polRow']").each(function(row){
			row.down("label", 0).setStyle("width: 35%;");
			row.down("label", 1).setStyle("width: 25%;");
			row.down("label", 2).setStyle("width: 35%;");
		});
	}

	checkIfToResizeTable2("packParPolicyContainer", "polRow");
	
</script>
