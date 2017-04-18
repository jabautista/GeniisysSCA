<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
    <%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<input type="hidden" id="selectedClientId" value="0" readonly="readonly" />
<input type="hidden" id="assdNo" name="assdNo" value="${assdNo }" readonly="readonly" />
	<div class="tableContainer" style="font-size:12px;">
		<div class="tableHeader">
			<label style="width: 200px; margin-left: 15px;">Assured Name</label>
			<label style="width: 100px;">Birthday</label>
			<label style="width: 400px;">Address</label>
		</div>
		<div>	
			<c:forEach var="assured" items="${searchResult}">
				<div id="row${assured.assdNo}" name="row" class="tableRow" style="padding: 3px 5px; padding-top: 5px;">
					<label style="width: 200px; margin-left: 10px;" id="${assured.assdNo}name" name="assdName" title="${assured.assdName}">${assured.assdName}</label>
					<label style="width: 100px;" id="${assured.assdNo}birthDate">
						<fmt:formatDate value="${assured.birthdate}" pattern="dd/MM/yyyy" />
						<c:if test="${empty assured.birthdate}">
							-
						</c:if>
					</label>
					<label style="width: 400px;" id="${assured.assdNo}address" name="address" title="${assured.mailAddress1} ${assured.mailAddress2} ${assured.mailAddress3}">${assured.mailAddress1} ${assured.mailAddress2} ${assured.mailAddress3}</label>
					<input id="${assured.assdNo}address1" name="${assured.assdNo}address1" type="hidden" value="${assured.mailAddress1}"/>
					<input id="${assured.assdNo}address2" name="${assured.assdNo}address2" type="hidden" value="${assured.mailAddress2}"/>
					<input id="${assured.assdNo}address3" name="${assured.assdNo}address3" type="hidden" value="${assured.mailAddress3}"/>
				</div>
			</c:forEach>
		</div>	
	</div>	
	<div style="position:absolute; bottom:55px; right:20px; display:${noOfPages gt 1 ? 'block' :'none'}">
		Page:
		<select id="acctOfPage" name="acctOfPage">
			<c:forEach var="i" begin="1" end="${noOfPages}" varStatus="status">
				<option value="${i}"
					<c:if test="${pageNo==i}">
						selected="selected"
					</c:if>
				>${i}</option>
			</c:forEach>
		</select> of ${noOfPages}
	</div>
<script type="text/JavaScript">
	$("acctOfPage").observe("change",function(){
		goToPageSearchClientModal3($("acctOfPage").value,$('assdNo').value, $('keyword').value);
	});

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
		lbl.update((lbl.innerHTML).truncate(50, "..."));
	});

	$$("label[name='assdName']").each(function (lbl) {
		lbl.update((lbl.innerHTML).truncate(25, "..."));
	});

</script>