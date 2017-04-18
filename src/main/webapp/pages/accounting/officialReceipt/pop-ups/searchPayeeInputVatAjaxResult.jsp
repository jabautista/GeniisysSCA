<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<input type="hidden" id="selectedClientId" value="0" readonly="readonly" />
<div class="tableContainer" style="font-size: 12px;">
	<div class="tableHeader">
		<label style="width: 32%; margin-right: 10px;">First Name</label>
		<label style="width: 32%; margin-right: 10px; ">Middle Name</label>
		<label style="width: 32%; ">Last Name</label>
	</div>
	<div style="height:270px; overflow:auto;">
		<c:if test="${empty searchResult}">
			<div id="rowPayeeInputVatList" name="rowPayeeInputVatList" class="tableRow">No records available</div>
		</c:if>
		<c:forEach var="payee" items="${searchResult}">
			<div id="rowPayeeInputVatList${payee.payeeClassCd}${payee.payeeNo}" name="rowPayeeInputVatList" class="tableRow" style="padding: 1px; padding-top: 5px;">
				<label name="payeeInputVatText" style="width: 32%; margin-right: 10px;">${empty payee.payeeFirstName ? '---' :payee.payeeFirstName }</label>
				<label name="payeeInputVatText" style="width: 32%; margin-right: 10px;">${empty payee.payeeMiddleName ? '---' :payee.payeeMiddleName }</label>
				<label name="payeeInputVatText" style="width: 32%; ">${empty payee.payeeLastName ? '---' :payee.payeeLastName}</label>
				
				<input type="hidden" id="payeeClassCdPayeeList" 	name="payeeClassCdPayeeList" 	value="${payee.payeeClassCd}"/>
				<input type="hidden" id="payeeNoPayeeList" 			name="payeeNoPayeeList" 		value="${payee.payeeNo}"/>
				<input type="hidden" id="payeeFirtsNamePayeeList" 	name="payeeFirtsNamePayeeList" 	value="${payee.payeeFirstName}"/>
				<input type="hidden" id="payeeMiddleNamePayeeList" 	name="payeeMiddleNamePayeeList" value="${payee.payeeMiddleName}"/>
				<input type="hidden" id="payeeLastNamePayeeList" 	name="payeeLastNamePayeeList" 	value="${payee.payeeLastName}"/>
			</div>			
		</c:forEach>
	</div>
</div>
<div align="right" style="margin-top:10px; display:${noOfPages gt 1 ? 'block' :'none'}">
	Page:
	<select id="payeeInputVatPage" name="payeeInputVatPage">
		<c:forEach var="i" begin="1" end="${noOfPages}" varStatus="status">
			<option value="${i}"
				<c:if test="${pageNo==i}">
					selected="selected"
				</c:if>
			>${i}</option>
		</c:forEach>
	</select> of ${noOfPages}
</div>
<script type="text/javascript">
	//when PAGE change
	$("payeeInputVatPage").observe("change",function(){
		searchPayeeInputVatModal($("payeeInputVatPage").value,$("keyword").value);
	});

	//observe for table list
	$$("div[name=rowPayeeInputVatList]").each(function(row){
		row.observe("mouseover",function(){
			row.addClassName("lightblue");
		});
		row.observe("mouseout",function(){
			row.removeClassName("lightblue");
		});
		row.observe("click",function(){
			row.toggleClassName("selectedRow");
			if (row.hasClassName("selectedRow")){
				$("selectedClientId").value = row.getAttribute("id");
				$$("div[name=rowPayeeInputVatList]").each(function(li){
					if (row.getAttribute("id") != li.getAttribute("id")){
						li.removeClassName("selectedRow");
					}	
				});
			}else{
				null;
			}		
		});
	});

	//truncate label text
	$$("label[name='payeeInputVatText']").each(function (lbl) {
		lbl.update((lbl.innerHTML).truncate(30, "..."));
	});
</script>