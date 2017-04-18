<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>
<div style="margin: 10px; float: left;">
	<input type="hidden" id="columnName" name="columnName" value="${column}" />
	<div style="margin-bottom: 10px;">
		<div id="cityTable" style="width: 600px;">
			<div id="filterLOV" style="margin-bottom: 10px;">
				<label style="width: 70px; line-height: 20px;">Filter List</label>
				<input type="text" id="filterContent" name="filterContent" style="width: 320px;" tabindex="1" />
				<select id="filterColumn" name="filterColumn" style="width : 150px;">
					<option value="province">Province</option>
					<option value="city">City</option>
				</select>
			</div>
			<div class="tableHeader">
				<label style="width: 200px; margin-left: 5px;">Province</label>
				<label>City</label>
			</div>
			<div class="tableContainer" id="cityListing" name="cityListing" style="height: 310px; overflow: auto;">
				<c:forEach var="city" items="${cityListing}">
					<div id="${city.provinceCd}_${city.cityCd}" name="rowCity" class="tableRow" regionCd="${city.regionCd}" 
						provinceCd="${city.provinceCd}" provinceDesc="${city.provinceDesc}" cityCd="${city.cityCd}" city="${city.city}">
						<label style="width: 200px; margin-left: 5px;">${city.provinceDesc}</label>
						<label>${city.city}</label>
					</div>
				</c:forEach>
			</div>
		</div>
	</div>
	<div align="center">
		<input type="button" style="width: 80px;" id="btnCityOk" 		name="btnCityOk" 		value="Ok" 		class="button" />
		<input type="button" style="width: 80px;" id="btnCityCancel" 	name="btnCityCancel" 	value="Cancel" 	class="button" />
	</div>
</div>
<script type="text/javascript">
	$$("div[name='rowCity']").each(function(row){
		loadRowMouseOverMouseOutObserver(row);
	
		row.observe("click", function(){
			row.toggleClassName("selectedRow");
			if(row.hasClassName("selectedRow")){
				($$("div#cityTable div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");				
			}
		});
	});

	$("btnCityOk").observe("click", function(){
		if($$("div#cityTable .selectedRow").length > 0){
			var row = ($$("div#cityTable .selectedRow"))[0];
			$("provinceCd").value	= row.getAttribute("provinceCd");
			$("province").value		= row.getAttribute("provinceDesc");
			$("cityCd").value 		= row.getAttribute("cityCd");
			$("city").value			= row.getAttribute("city");

			fireEvent($("block"), "change");

			hideOverlay();
		}else{
			showMessageBox("Please select record first.", imgMessage.ERROR);
		}
	});
	
	$("btnCityCancel").observe("click", hideOverlay);

	$("filterContent").observe("keyup", function(evt){
		if(evt.keyCode == objKeyCode.ESC){
			$("filterContent").value = "";
			$$("div#cityTable div[name='rowCity']").invoke("show");
		}else{
			var text = replaceSpecialCharsInFilterText($("filterContent").value.strip());

			$$("div#cityTable div[name='rowCity']").invoke("removeClassName", "selectedRow");
			$$("div#cityTable div[name='rowCity']").invoke("show");
				
			if(text != ""){
				if($F("filterColumn") == "province"){					
					$$("div#cityListing div:not([provinceDesc*='" + text.toUpperCase() + "'])").invoke("hide");
				}else{
					$$("div#cityListing div:not([city*='" + text.toUpperCase() + "'])").invoke("hide");
				}
			}
		}
	});
</script>