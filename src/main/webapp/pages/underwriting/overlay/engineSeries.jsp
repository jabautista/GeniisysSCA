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
		<div id="engineSeriesTable" style="width : 800px;">
			<div id="filterLOV" style="margin-bottom: 10px;">
				<label style="width: 70px; line-height: 20px;">Filter List</label><input type="text" id="filterContent" name="filterContent" style="width: 720px;" tabindex="1" />
			</div>			
			<div class="tableHeader">
				<label style="margin-left: 5px;">Engine Series</label>
			</div>
			<div class="tableContainer" id="engineSeriesListing" name="engineSeriesListing" style="height: 310px; overflow: auto; border: 1px solid rgb(224, 224, 224);">
				<c:forEach var="engSeries" items="${engineSeries}">
					<div id="${engSeries.seriesCd}" title="${engSeries.engineSeries}" name="rowEngineSeriesListing" class="tableRow" engineSeriesDesc="${fn:toUpperCase(engSeries.engineSeries)}" 
						carCompanyCd="${engSeries.carCompanyCd}" carCompanyDesc="${engSeries.carCompany}" makeCd="${engSeries.makeCd}" makeDesc="${engSeries.make}">
						<label style="margin-left: 5px;" name="lblEngineSeriesDesc">${engSeries.engineSeries}</label>
					</div>
				</c:forEach>
			</div>
		</div>
	</div>
	<div align="center">
		<input type="button" style="width: 80px;" id="btnEngineSeriesOk" 		name="btnEngineSeriesOk" 		value="Ok" 		class="button" />
		<input type="button" style="width: 80px;" id="btnEngineSeriesCancel" 	name="btnEngineSeriesCancel" 	value="Cancel" 	class="button" />
	</div>
</div>

<script type="text/javascript">
	$$("div[name='rowEngineSeriesListing']").each(function(row){
		loadRowMouseOverMouseOutObserver(row);
	
		row.observe("click", function(){
			row.toggleClassName("selectedRow");
			if(row.hasClassName("selectedRow")){
				($$("div#engineSeriesTable div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");				
			}
		});	
	});

	$$("div#engineSeriesTable label[name='lblEngineSeriesDesc']").each(function(elem){
		if(elem.innerHTML.length > 105){
			elem.update(elem.innerHTML.truncate(105, "..."));
		}
	});

	$("btnEngineSeriesCancel").observe("click", hideOverlay);

	$("btnEngineSeriesOk").observe("click", function(){
		if($$("div#engineSeriesListing .selectedRow").length > 0){
			var row = ($$("div#engineSeriesListing .selectedRow"))[0];

			$("carCompanyCd").value	= row.getAttribute("carCompanyCd");
			$("carCompany").value	= row.getAttribute("carCompanyDesc");
			$("makeCd").value		= row.getAttribute("makeCd");
			$("make").value			= row.getAttribute("makeDesc");
			$("seriesCd").value 	= row.id;
			$("engineSeries").value = row.getAttribute("engineSeriesDesc");

			hideOverlay();
		}else{
			showMessageBox("Please select record first.", imgMessage.ERROR);
		}
	});

	$("filterContent").observe("keyup", function(evt){
		if(evt.keyCode == objKeyCode.ESC){
			$("filterContent").value = "";
			$$("div#engineSeriesTable div[name='rowEngineSeriesListing']").invoke("show");
		}else{
			var text = replaceSpecialCharsInFilterText($("filterContent").value.strip());

			$$("div#engineSeriesTable div[name='rowEngineSeriesListing']").invoke("removeClassName", "selectedRow");
			$$("div#engineSeriesTable div[name='rowEngineSeriesListing']").invoke("show");
			
			if(text != ""){
				$$("div#engineSeriesListing div:not([engineSeriesDesc*='" + text.toUpperCase() + "'])").invoke("hide");
			}
		}
	});
</script>