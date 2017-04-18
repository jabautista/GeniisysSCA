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
		<div id="risksTable" style="width : 800px;">
			<div id="filterLOV" style="margin-bottom: 10px;">
				<label style="width: 70px; line-height: 20px;">Filter List</label><input type="text" id="filterContent" name="filterContent" style="width: 720px;" tabindex="1" />
			</div>			
			
			<div class="tableContainer" id="riskListing" name="riskListing" style="height: 310px; overflow: auto; border: 1px solid rgb(224, 224, 224);">
				<c:forEach var="risk" items="${riskListing}">
					<div id="${risk.riskCd}" title="${risk.riskDesc}" riskDesc="${fn:toUpperCase(risk.riskDesc)}" name="rowRiskListing" class="tableRow">
						<label style="margin-left: 5px;" name="lblRiskDescDesc">${risk.riskDesc}</label>
					</div>
				</c:forEach>
			</div>
		</div>
	</div>
	<div align="center">
		<input type="button" style="width: 80px;" id="btnRiskOk" 		name="btnRiskOk" 		value="Ok" 		class="button" />
		<input type="button" style="width: 80px;" id="btnRiskCancel" 	name="btnRiskCancel" 	value="Cancel" 	class="button" />
	</div>
</div>
<script type="text/javascript">
	$$("div[name='rowRiskListing']").each(function(row){
		loadRowMouseOverMouseOutObserver(row);
	
		row.observe("click", function(){
			row.toggleClassName("selectedRow");
			if(row.hasClassName("selectedRow")){
				($$("div#risksTable div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");				
			}
		});	
	});

	$$("div#riskTable label[name='lblRiskDesc']").each(function(elem){
		if(elem.innerHTML.length > 105){
			elem.update(elem.innerHTML.truncate(105, "..."));
		}
	});

	$("btnRiskCancel").observe("click", hideOverlay);

	$("btnRiskOk").observe("click", function(){
		if($$("div#riskListing .selectedRow").length > 0){
			var row = ($$("div#riskListing .selectedRow"))[0];

			$("riskCd").value 	= row.id;
			$("risk").value 	= row.getAttribute("riskDesc");

			hideOverlay();
		}else{
			showMessageBox("Please select record first.", imgMessage.ERROR);
		}
	});

	$("filterContent").observe("keyup", function(evt){
		if(evt.keyCode == objKeyCode.ESC){
			$("filterContent").value = "";
			$$("div#riskTable div[name='rowRiskListing']").invoke("show");
		}else{
			var text = replaceSpecialCharsInFilterText($("filterContent").value.strip());

			$$("div#riskTable div[name='rowRiskListing']").invoke("removeClassName", "selectedRow");
			$$("div#riskTable div[name='rowRiskListing']").invoke("show");
			
			if(text != ""){
				$$("div#riskListing div:not([riskDesc*='" + text.toUpperCase() + "'])").invoke("hide");
			}
		}
	});
</script>