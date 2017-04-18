<!-- 
Remarks: For deletion
Date : 06-21-2012
Developer: Emsy
Replacement : showGIACPremDepAssdNameLOV function in accounting-lov.js
-->
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
    <%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<input type="hidden" id="selectedClientId" value="0" readonly="readonly" />
<div class="tableContainer" style="font-size: 12px; overflow: auto">
	<div class="tableHeader">
		<label style="width: 200px; margin-left: 15px;">Assured No</label>
		<label style="width: 500px;">Assured Name</label>
	</div>
	<div>
		<c:forEach var="assured" items="${searchResult}">
			<div id="row${assured.assdNo}" name="row" class="tableRow" style="padding: 3px 5px; padding-top: 5px;">
				<label style="width: 200px; margin-left: 10px;" id="${assured.assdNo}no" name="assdNo" title="${assured.assdNo}">${assured.assdNo}</label>
				<label style="width: 500px;" id="${assured.assdName}name" name="assdName" title="${assured.assdName}">${assured.assdName}</label>
				<input id="${assured.assdNo}assdName" name="${assured.assdNo}assdName" type="hidden" value="${assured.assdName}"/>
				<input id="${assured.assdNo}address1" name="${assured.assdNo}address1" type="hidden" value="${assured.mailAddress1}"/>
				<input id="${assured.assdNo}address2" name="${assured.assdNo}address2" type="hidden" value="${assured.mailAddress2}"/>
				<input id="${assured.assdNo}address3" name="${assured.assdNo}address3" type="hidden" value="${assured.mailAddress3}"/>
			</div>
		</c:forEach>
	</div>
</div>
<!-- <div class="pager" id="pager">  comment by Niknok and added style-->
	<c:if test="${noOfPages>1}">
		<div style="position:absolute; bottom:45px; right:20px;">
		Page:
			<select directory="accounting" onChange="goToPageSearchClientModal2(this);">
				<c:forEach var="i" begin="1" end="${noOfPages}" varStatus="status">
					<option value="${i}"
						<c:if test="${pageNo==i}">
							selected="selected"
						</c:if>
					>${i}</option>
				</c:forEach>
			</select> of ${noOfPages}
		</div>
	</c:if>
<!-- </div>  -->
<script type="text/JavaScript">
	//comment out by Nok
	//position page div correctly
	//var product = 288 - (parseInt($$("div[name='row']").size())*28);
	//$("pager").setStyle("margin-top: "+product+"px;");

	$$("div[name='row']").each(
		function (row)	{
			row.observe("mouseover", function ()	{
				row.addClassName("lightblue");
			});
			
			row.observe("mouseout", function ()	{
				row.removeClassName("lightblue");
			});
		
			row.observe("click", function ()	{
				row.toggleClassName("selectedRow");
				if (row.hasClassName("selectedRow"))	{
					$("selectedClientId").value = row.getAttribute("id").substring(3);
					$$("div[name='row']").each(function (r)	{
						if (row.getAttribute("id") != r.getAttribute("id"))	{
							r.removeClassName("selectedRow");
						}
					});
				}	else	{
					$("lineCd").value = "";
				}
			});
		}
	);

	$$("label[name='address']").each(function (lbl) {
		lbl.update((lbl.innerHTML).truncate(50, "..."));
	});

	$$("label[name='assdName']").each(function (lbl) {
		lbl.update((lbl.innerHTML).truncate(25, "..."));
	});
</script>