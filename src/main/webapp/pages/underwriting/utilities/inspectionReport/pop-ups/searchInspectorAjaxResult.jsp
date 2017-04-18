<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
    <%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<input type="hidden" id="selectedRow" value="" readonly="readonly" />
<div class="tableContainer" style="font-size: 12px;">
	<div class="tableHeader">
		<label style="width: 80px; margin-left: 15px;">Insp Cd</label>
		<label style="width: 500px;">Insp Name</label>
	</div>
	<div>
		<c:forEach var="insp" items="${inspDataListing}" varStatus="ctr">
			<div id="modalRow${ctr.index}" name="modalRow" class="tableRow" style="padding: 3px 5px; padding-top: 5px;">
				<label style="width: 80px; margin-left: 10px;" id="modalLblIntmNo${ctr.index}" name="modalInspCd" title="${insp.inspCd}">${insp.inspCd}</label>
				<label style="width: 500px;" id="modalLblIntmName${ctr.index }">${insp.inspName }</label>
				<input type="hidden" id="modalRowIntmNo${ctr.index }" 	name="modalRowInspCd" 	value="${insp.inspCd}"/>
				<input type="hidden" id="modalRowIntmName${ctr.index }" name="modalRowInspName" value="${insp.inspName}"/>
			</div>
		</c:forEach>
	</div>
</div>
<div class="pager" id="pager">
	<c:if test="${noOfPages>1}">
		<div align="right">
		Page:
			<select id="intmNoPage" name="intmNoPage">
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
<script type="text/javascript">
	$$("div[name='modalRow']").each(function (row){
		loadRowMouseOverMouseOutObserver(row);

		row.observe("click", function ()	{
			row.addClassName("selectedRow");
			if (row.hasClassName("selectedRow"))	{
				$("selectedRow").value = row.id;
				$$("div[name='modalRow']").each(function (r)	{
					if (row.getAttribute("id") != r.getAttribute("id"))	{
						r.removeClassName("selectedRow");
					}
				});
			} else {
				$("selectedRow").value = "";
			}
		});

		row.observe("dblclick", function (){
			
		});
	});
</script>