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
		<div id="cargoClassTable" style="width : 800px;">
			<div id="filterLOV" style="margin-bottom: 10px;">
				<label style="width: 70px; line-height: 20px;">Filter List</label><input type="text" id="filterContent" name="filterContent" style="width: 720px;" tabindex="1" />
			</div>			
			
			<div class="tableContainer" id="marineCargoListing" name="marineCargoListing" style="height: 310px; overflow: auto; border: 1px solid rgb(224, 224, 224);">
				<c:forEach var="cargo" items="${cargoClassListing}">
					<div id="${cargo.cargoClassCd}" title="${cargo.cargoClassDesc}" cargoClassDesc="${fn:toUpperCase(cargo.cargoClassDesc)}" name="rowCargoListing" class="tableRow">
						<label style="margin-left: 5px;" name="lblCargoDesc">${cargo.cargoClassDesc}</label>
					</div>
				</c:forEach>
			</div>
		</div>
	</div>
	<div align="center">
		<input type="button" style="width: 80px;" id="btnCargoClassOk" 		name="btnCargoClassOk" 		value="Ok" 		class="button" />
		<input type="button" style="width: 80px;" id="btnCargoClassCancel" 	name="btnOccupancyCancel" 	value="Cancel" 	class="button" />
	</div>
</div>

<script type="text/javascript">
	$$("div[name='rowCargoListing']").each(function(row){
		loadRowMouseOverMouseOutObserver(row);
	
		row.observe("click", function(){
			row.toggleClassName("selectedRow");
			if(row.hasClassName("selectedRow")){
				($$("div#cargoClassTable div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");				
			}
		});	
	});

	$$("div#cargoClassTable label[name='lblCargoDesc']").each(function(elem){
		if(elem.innerHTML.length > 105){
			elem.update(elem.innerHTML.truncate(105, "..."));
		}
	});

	$("btnCargoClassCancel").observe("click", hideOverlay);

	$("btnCargoClassOk").observe("click", function(){
		if($$("div#marineCargoListing .selectedRow").length > 0){
			var row = ($$("div#marineCargoListing .selectedRow"))[0];

			$("cargoClassCd").value = row.id;
			$("cargoClass").value 	= row.getAttribute("cargoClassDesc");

			hideOverlay();
		}else{
			showMessageBox("Please select record first.", imgMessage.ERROR);
		}
	});

	$("filterContent").observe("keyup", function(evt){
		if(evt.keyCode == objKeyCode.ESC){
			$("filterContent").value = "";
			$$("div#cargoClassTable div[name='rowCargoListing']").invoke("show");
		}else{
			var text = replaceSpecialCharsInFilterText($("filterContent").value.strip());

			$$("div#cargoClassTable div[name='rowCargoListing']").invoke("removeClassName", "selectedRow");
			$$("div#cargoClassTable div[name='rowCargoListing']").invoke("show");
			
			if(text != ""){
				$$("div#marineCargoListing div:not([cargoClassDesc*='" + text.toUpperCase() + "'])").invoke("hide");
			}
		}
	});
</script>