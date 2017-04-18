<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>
<div id="moduleUsersListDiv" style="margin: 5px; display: none; width: 100%;">
	<div style="float: left; width: 98%; margin: 15px 0;">
		<div style="float: left; width: 100%;">
			<label class="rightAligned" style="line-height: 20px; margin-right: 5px; width: 80px;">Module ID: </label>
			<input type="text" readonly="readonly" value="${moduleId}" style="width: 150px; float: left;" />
			<input type="text" readonly="readonly" value="${moduleDesc}" style="margin-left: 2px; width: 320px; float: left;" />
		</div>
	</div>
	<div class="sectionDiv" style="float: left; width: 98%;">
		<div class="tableHeader">
			<label style="width: 20%; text-align: left; margin-left: 20px;">User ID</label>
			<label style="width: 42%; text-align: left;">Description</label>
			<label style="width: 20%; text-align: left;">Access Tag</label>
		</div>
		<div id="moduleUsersListTable" class="tableContainer" style="font-size: 12px;">
			<c:forEach var="m" items="${moduleUsers}">
				<div id="row${m.userID}" name="row" class="tableRow">
					<label style="width: 20%; text-align: left; margin-left: 20px;">${m.userID}</label>
					<label style="width: 42%; text-align: left;" title="${m.moduleDesc}" name="moduleDesc">${m.moduleDesc}</label>
					<label style="width: 20%; text-align: left; margin-left; 20px;">${m.accessTag}</label>
					<input type="hidden" value="${m.userId}" />
					<input type="hidden" value="<fmt:formatDate pattern="MM/dd/yyyy" value="${m.lastUpdate}"></fmt:formatDate>" />
				</div>
			</c:forEach>
		</div>
	</div>
	<div style="float: left; width: 98%; margin: 20px 0;">
		<div style="float: left; width: 100%; line-height: 20px;">
			<label class="rightAligned" style="float: left; margin-right: 5px; width: 80px;">User ID: </label><input type="text" readonly="readonly" id="modUserUserId" value="" style="float: left; width: 150px;" />
			<label class="rightAligned" style="float: left; margin-right: 5px; width: 100px;">Last Update: </label><input type="text" readonly="readonly" id="modUserLastUpdate" value="" style="float: left;" />
		</div>
	</div>
</div>

<script type="text/JavaScript">
	resizeTableToRowNum("moduleUsersListTable", "row", 5);

	$$("div#moduleUsersListTable div[name='row']").each(
		function (row){
			row.observe("mouseover", function ()	{
				row.addClassName("lightblue");
			});
			
			row.observe("mouseout", function ()	{
				row.removeClassName("lightblue");
			});
			
			row.observe("click", function ()	{
				row.toggleClassName("selectedRow");
				if (row.hasClassName("selectedRow"))	{
					$$("div#moduleUsersListTable div[name='row']").each(function (r)	{
						if (r.getStyle("display")!= "none")	{
							if (row.readAttribute("id") != r.readAttribute("id")) {
								r.removeClassName("selectedRow");
							}
						}
					});

					$("modUserUserId").value = row.down("input", 0).value;
					$("modUserLastUpdate").value = row.down("input", 1).value;
				} else {
					$("modUserUserId").value = "";
					$("modUserLastUpdate").value = "";
				}
			});
		}
	);
</script>