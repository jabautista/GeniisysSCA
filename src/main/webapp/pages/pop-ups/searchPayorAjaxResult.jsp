<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
    <%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<input type="hidden" id="selectedClientId" value="0" readonly="readonly" />
<div class="tableContainer" style="font-size: 12px;">
	<div class="tableHeader">
		<label style="width: 200px; margin-left: 15px;">Payor Name</label>
		<label style="width: 400px;">Address</label>
	</div>
	<div>
		<c:forEach var="payor" items="${searchResult}">
			<div id="row${payor.intmNo}" name="row" class="tableRow" style="padding: 3px 5px; padding-top: 5px;">
				<label style="width: 200px; margin-left: 10px;" id="${payor.intmNo}name" name="payorName" title="${payor.intmName}">${payor.intmName}</label>
				<label style="width: 500px;" id="${payor.intmNo}address" name="address" title="${payor.mailAddr1} ${payor.mailAddr2} ${payor.mailAddr3}">${payor.mailAddr1} ${payor.mailAddr2} ${payor.mailAddr3}</label>
				<input id="${payor.intmNo}address1" name="${payor.intmNo}address1" type="hidden" value="${payor.mailAddr1}"/>
				<input id="${payor.intmNo}address2" name="${payor.intmNo}address2" type="hidden" value="${payor.mailAddr2}"/>
				<input id="${payor.intmNo}address3" name="${payor.intmNo}address3" type="hidden" value="${payor.mailAddr3}"/>
				<input id="${payor.intmNo}tin" name="${payor.intmNo}tin" type="hidden" value="${payor.tin}"/>
			</div>
		</c:forEach>
	</div>
</div>
<div class="pager" id="pager">
	<c:if test="${noOfPages>1}">
		<div align="right">
		Page:
			<select onChange="searchPayorModal2(this);">
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
</div>
<script type="text/JavaScript">
	//position page div correctly
	var product = 288 - (parseInt($$("div[name='row']").size())*28);
	$("pager").setStyle("margin-top: "+product+"px;");

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
				}	
			});
		}
	);

	$$("label[name='address']").each(function (lbl) {
		lbl.update((lbl.innerHTML).truncate(65, "..."));
	});

	$$("label[name='payorName']").each(function (lbl) {
		lbl.update((lbl.innerHTML).truncate(23, "..."));
	});
</script>