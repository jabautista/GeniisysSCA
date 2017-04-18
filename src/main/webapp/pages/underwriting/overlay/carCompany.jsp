<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	response.setHeader("Cache-control", "No-cache");
	response.setHeader("Pragma", "No-cache");
%>

<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>
<div style="margin: 10px; float: left;">
	<div style="margin-bottom : 10px;">
		<div id="carCompanyTable" style="width : 800px;">
			<div id="filterLOV" style="margin-bottom: 10px;">
				<label style="width: 70px; line-height: 20px;">Filter List</label><input type="text" id="filterContent" name="filterContent" style="width: 720px;" tabindex="1" />
			</div>			
			<div class="tableHeader">
				<label style="margin-left: 5px;">Car Company</label>
			</div>
			<div class="tableContainer" id="carCompanyListing" name="carCompanyListing" style="height: 310px; overflow: auto; border: 1px solid rgb(224, 224, 224);">
				<c:forEach var="carCompany" items="${carCompanies}">
					<div id="${carCompany.carCompanyCd}" title="${carCompany.carCompany}" carCompanyDesc="${fn:toUpperCase(carCompany.carCompany)}" name="rowCarCompanyListing" class="tableRow">
						<label style="margin-left: 5px;" name="lblCarCompanyDesc">${carCompany.carCompany}</label>
					</div>
				</c:forEach>
			</div>
		</div>
	</div>
	<div align="center">
		<input type="button" style="width: 80px;" id="btnCarCompanyOk" 		name="btnCarCompanyOk" 		value="Ok" 		class="button" />
		<input type="button" style="width: 80px;" id="btnCarCompanyCancel" 	name="btnCarCompanyCancel" 	value="Cancel" 	class="button" />
	</div>
</div>

<script type="text/javascript">
	$$("div[name='rowCarCompanyListing']").each(function(row){
		loadRowMouseOverMouseOutObserver(row);
	
		row.observe("click", function(){
			row.toggleClassName("selectedRow");
			if(row.hasClassName("selectedRow")){
				($$("div#carCompanyTable div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");				
			}
		});	
	});

	$$("div#carCompanyTable label[name='lblCarCompanyDesc']").each(function(elem){
		if(elem.innerHTML.length > 105){
			elem.update(elem.innerHTML.truncate(105, "..."));
		}
	});

	$("btnCarCompanyCancel").observe("click", hideOverlay);

	$("btnCarCompanyOk").observe("click", function(){
		if($$("div#carCompanyListing .selectedRow").length > 0){
			var row = ($$("div#carCompanyListing .selectedRow"))[0];

			$("carCompanyCd").value = row.id;
			$("carCompany").value 	= row.getAttribute("carCompanyDesc");
			$("makeCd").value		= "";
			$("make").value			= "";
			$("seriesCd").value 	= "";
			$("engineSeries").value = "";
			
			hideOverlay();
		}else{
			showMessageBox("Please select record first.", imgMessage.ERROR);
		}
	});

	$("filterContent").observe("keyup", function(evt){
		if(evt.keyCode == objKeyCode.ESC){
			$("filterContent").value = "";
			$$("div#carCompanyTable div[name='rowCarCompanyListing']").invoke("show");
		}else{
			var text = replaceSpecialCharsInFilterText($("filterContent").value.strip());

			$$("div#carCompanyTable div[name='rowCarCompanyListing']").invoke("removeClassName", "selectedRow");
			$$("div#carCompanyTable div[name='rowCarCompanyListing']").invoke("show");
			
			if(text != ""){
				$$("div#carCompanyListing div:not([carCompanyDesc*='" + text.toUpperCase() + "'])").invoke("hide");
			}
		}
	});
</script>