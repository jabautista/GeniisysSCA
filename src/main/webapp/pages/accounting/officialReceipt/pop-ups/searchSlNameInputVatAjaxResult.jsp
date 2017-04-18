<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<input type="hidden" id="selectedClientId" value="0" readonly="readonly" />
<div class="tableContainer" style="font-size: 12px;">
	<div class="tableHeader">
		<label style="width: 25%; margin-right: 10px;">SL Cd</label>
		<label style="width: 72%; ">SL Name</label>
	</div>
	<div style="height:270px; overflow:auto;">
		<c:if test="${empty searchResult}">
			<div id="rowSlNameInputVatList" name="rowSlNameInputVatList" class="tableRow">No records available</div>
		</c:if>
		<c:forEach var="sl" items="${searchResult}">
			<div id="rowSlNameInputVatList${sl.slCd}${sl.slTypeCd}" name="rowSlNameInputVatList" class="tableRow" style="padding: 1px; padding-top: 5px;">
				<label name="slNameInputVatText" style="width: 25%; margin-right: 10px;"><fmt:formatNumber pattern="000000000000">${empty sl.slCd ? '---' :sl.slCd }</fmt:formatNumber></label>
				<label name="slNameInputVatText" style="width: 72%; ">${empty sl.slName ? '---' :sl.slName}</label>
				
				<input type="hidden" id="slCdSlNameList" 		name="slCdSlNameList" 		value="${sl.slCd}"/>
				<input type="hidden" id="slNameSlNameList" 		name="slNameSlNameList" 	value="${sl.slName}"/>
				<input type="hidden" id="slTypeCdSlNameList" 	name="slTypeCdSlNameList" 	value="${sl.slTypeCd}"/>
			</div>			
		</c:forEach>
	</div>
</div>
<div align="right" style="margin-top:10px; display:${noOfPages gt 1 ? 'block' :'none'}">
	Page:
	<select id="slNameInputVatPage" name="slNameInputVatPage">
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
	$("slNameInputVatPage").observe("change",function(){
		searchSlNameInputVatModal($("slNameInputVatPage").value,$("keyword").value);
	});

	//observe for table list
	$$("div[name=rowSlNameInputVatList]").each(function(row){
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
				$$("div[name=rowSlNameInputVatList]").each(function(li){
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
	$$("label[name='slNameInputVatText']").each(function (lbl) {
		lbl.update((lbl.innerHTML).truncate(55, "..."));
	});	
</script>