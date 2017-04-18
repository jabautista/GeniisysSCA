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
		<div id="makeTable" style="width : 800px;">
			<div id="filterLOV" style="margin-bottom: 10px;">
				<label style="width: 70px; line-height: 20px;">Filter List</label><input type="text" id="filterContent" name="filterContent" style="width: 720px;" tabindex="1" />
			</div>			
			<div class="tableHeader">
				<label style="margin-left: 5px;">Makes</label>
			</div>
			<div class="tableContainer" id="makeListing" name="makeListing" style="height: 310px; overflow: auto; border: 1px solid rgb(224, 224, 224);">
				<c:forEach var="make" items="${makes}">
					<div id="${make.makeCd}" title="${make.make}" name="rowMakeListing" class="tableRow"
						makeDesc="${fn:toUpperCase(make.make)}" carCompanyCd="${make.carCompanyCd}" carCompanyDesc="${make.carCompany}">
						<label style="margin-left: 5px;" name="lblMakeDesc">${make.make}</label>
					</div>
				</c:forEach>
			</div>
		</div>
	</div>
	<div align="center">
		<input type="button" style="width: 80px;" id="btnMakeOk" 		name="btnMakeOk" 		value="Ok" 		class="button" />
		<input type="button" style="width: 80px;" id="btnMakeCancel" 	name="btnMakeCancel" 	value="Cancel" 	class="button" />
	</div>
</div>

<script type="text/javascript">
	$$("div[name='rowMakeListing']").each(function(row){
		loadRowMouseOverMouseOutObserver(row);
	
		row.observe("click", function(){
			row.toggleClassName("selectedRow");
			if(row.hasClassName("selectedRow")){
				($$("div#makeTable div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");				
			}
		});	
	});

	$$("div#makeTable label[name='lblMakeDesc']").each(function(elem){
		if(elem.innerHTML.length > 105){
			elem.update(elem.innerHTML.truncate(105, "..."));
		}
	});

	$("btnMakeCancel").observe("click", hideOverlay);

	$("btnMakeOk").observe("click", function(){
		if($$("div#makeListing .selectedRow").length > 0){
			var row = ($$("div#makeListing .selectedRow"))[0];

			$("carCompanyCd").value	= row.getAttribute("carCompanyCd");
			$("carCompany").value	= row.getAttribute("carCompanyDesc");
			$("makeCd").value 		= row.id;
			$("make").value 		= row.getAttribute("makeDesc");

			hideOverlay();
		}else{
			showMessageBox("Please select record first.", imgMessage.ERROR);
		}
	});

	$("filterContent").observe("keyup", function(evt){
		if(evt.keyCode == objKeyCode.ESC){
			$("filterContent").value = "";
			$$("div#makeTable div[name='rowMakeListing']").invoke("show");
		}else{
			var text = replaceSpecialCharsInFilterText($("filterContent").value.strip());

			$$("div#makeTable div[name='rowMakeListing']").invoke("removeClassName", "selectedRow");
			$$("div#makeTable div[name='rowMakeListing']").invoke("show");
			
			if(text != ""){
				$$("div#makeListing div:not([makeDesc*='" + text.toUpperCase() + "'])").invoke("hide");
			}
		}
	});
</script>