<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>
<div style="margin: 10px; float: left;">
	<div style="margin-bottom: 10px;">
		<div id="occupancyTable" name="occupancyTable" style="width: 800px;">
			<div id="filterLOV" style="margin-bottom: 10px;">
				<label style="width: 70px; line-height: 20px;">Filter List</label><input type="text" id="filterContent" name="filterContent" style="width: 720px;" tabindex="1" />
			</div>			
			<div class="tableHeader">
				<label style="margin-left: 5px;">Occupancy</label>
			</div>			
			<div class="tableContainer" id="occupancyListing" name="occupancyListing" style="height: 310px; overflow: auto; border: 1px solid rgb(224, 224, 224);">
				<c:forEach var="occupancy" items="${occupancyListing}">
					<div id="${occupancy.occupancyCd}" occupancyDesc="${fn:toUpperCase(occupancy.occupancyDesc)}" name="rowOccupancy" class="tableRow">
						<label style="margin-left: 5px;">${occupancy.occupancyDesc}</label>
					</div>
				</c:forEach>
			</div>
		</div>	
	</div>
	<div align="center">
		<input type="button" style="width: 80px;" id="btnOccupancyOk" 		name="btnOccupancyOk" 		value="Ok" 		class="button" />
		<input type="button" style="width: 80px;" id="btnOccupancyCancel" 	name=btnOccupancyCancel 	value="Cancel" 	class="button" />
	</div>
</div>

<script type="text/javascript">
	$$("div[name='rowOccupancy']").each(function(row){
		loadRowMouseOverMouseOutObserver(row);

		row.observe("click", function(){
			row.toggleClassName("selectedRow");
			if(row.hasClassName("selectedRow")){
				($$("div#occupancyTable div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");				
			}
		});
	});

	$("btnOccupancyCancel").observe("click", hideOverlay);

	$("btnOccupancyOk").observe("click", function(){
		if($$("div#occupancyListing .selectedRow").length > 0){
			var row = ($$("div#occupancyListing .selectedRow"))[0];

			$("occupancyCd").value 	= row.id;
			$("occupancy").value 	= row.getAttribute("occupancyDesc");

			hideOverlay();
		}else{
			showMessageBox("Please select record first.", imgMessage.ERROR);
		}
	});

	$("filterContent").observe("keyup", function(evt){
		if(evt.keyCode == objKeyCode.ESC){
			$("filterContent").value = "";
			$$("div#occupancyTable div[name='rowOccupancy']").invoke("show");
		}else{
			var text = replaceSpecialCharsInFilterText($("filterContent").value.strip());

			$$("div#occupancyTable div[name='rowOccupancy']").invoke("removeClassName", "selectedRow");
			$$("div#occupancyTable div[name='rowOccupancy']").invoke("show");
			
			if(text != ""){
				$$("div#occupancyListing div:not([occupancyDesc*='" + text.toUpperCase() + "'])").invoke("hide");
			}
		}
	});
</script>