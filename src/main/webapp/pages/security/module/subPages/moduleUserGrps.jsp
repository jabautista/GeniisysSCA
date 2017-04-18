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
<div id="moduleUserGrpsListDiv" style="float: left; margin: 5px; display: none; width: 100%;">
	<div style="float: left; width: 98%; margin: 15px 0;">
		<div style="float: left; width: 100%;">
			<label class="rightAligned" style="line-height: 20px; margin-right: 5px; width: 80px;">Module ID: </label>
			<input type="text" readonly="readonly" value="${moduleId}" style="width: 150px; float: left;" />
			<input type="text" readonly="readonly" value="${moduleDesc}" style="margin-left: 2px; width: 350px; float: left;" />
			<label class="rightAligned" style="line-height: 20px; margin-right: 5px; width: 80px;">Access Tag: </label>
			<input type="text" readonly="readonly" value="${accessTag}" style="width: 150px; float: left;" />
		</div>
	</div>
	<div class="sectionDiv" style="float: left; width: 98%;">
		<div class="tableHeader">
			<label style="width: 20%; text-align: left; margin-left: 20px;">User ID</label>
			<label style="width: 65%; text-align: left;">Description</label>
		</div>
		<div id="moduleUserGrpsListTable" class="tableContainer" style="font-size: 12px;">
			<c:forEach var="m" items="${moduleUserGrps}">
				<div id="row${m.userGroup}" name="row" class="tableRow">
					<label style="width: 20%; text-align: left; margin-left: 20px;">${m.userGroup}</label>
					<label style="width: 65%; text-align: left;" title="${m.moduleDesc}" name="moduleDesc">${m.moduleDesc}</label>
					<input type="hidden" value="${m.remarks}" />
					<input type="hidden" value="${m.userId}" />
					<input type="hidden" value="<fmt:formatDate pattern="MM/dd/yyyy" value="${m.lastUpdate}"></fmt:formatDate>" />
				</div>
			</c:forEach>
		</div>
	</div>
	<div style="float: left; width: 98%; margin: 20px 0;">
		<div style="float: left; width: 100%; line-height: 20px;">
			<label class="rightAligned" style="float: left; margin-right: 5px; width: 80px;">Remarks: </label>
			<input type="text" readonly="readonly" id="modUserGrpRemarks" value="" style="float: left; width: 510px;" />
		</div>
		<div style="float: left; width: 100%; line-height: 20px;">
			<label class="rightAligned" style="float: left; margin-right: 5px; width: 80px;">User ID: </label><input type="text" readonly="readonly" id="modUserGrpUserId" value="" style="float: left; width: 150px;" />
			<label class="rightAligned" style="float: left; margin-right: 5px; width: 100px;">Last Update: </label><input type="text" readonly="readonly" id="modUserGrpLastUpdate" value="" style="float: left;" />
		</div>
	</div>
</div>

<script type="text/JavaScript">
	resizeTableToRowNum("moduleUserGrpsListTable", "row", 5);

	$$("div#moduleUserGrpsListTable div[name='row']").each(
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
						$$("div#moduleUserGrpsListTable div[name='row']").each(function (r)	{
							if (r.getStyle("display")!= "none")	{
								if (row.readAttribute("id") != r.readAttribute("id")) {
									r.removeClassName("selectedRow");
								}
							}
						});

						$("modUserGrpRemarks").value = row.down("input", 0).value;
						$("modUserGrpUserId").value = row.down("input", 1).value;
						$("modUserGrpLastUpdate").value = row.down("input", 2).value;
					} else {
						$("modUserGrpRemarks").value = "";
						$("modUserGrpUserId").value = "";
						$("modUserGrpLastUpdate").value = "";
					}
				});
			}
		);
</script>