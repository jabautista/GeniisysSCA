<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>
<div style="margin: 10px; float: left;">
	<div style="margin-bottom: 10px;">
		<div id="cityTable" style="width: 600px;">
			<div class="tableHeader">
				<label style="width: 200px; margin-left: 5px;">Province</label>
				<label>City</label>
			</div>
			<div class="tableContainer" id="cityListing" name="cityListing" style="height: 310px; overflow: auto;">
				<c:forEach var="city" items="${cityListing}">
					<div id="${city.provinceCd}_${city.cityCd}" name="rowCity" regionCd="${city.regionCd}" provinceCd="${city.provinceCd}" provinceDesc="${city.provinceDesc}" cityCd="${city.cityCd}" city="${city.city}" class="tableRow">
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

	$("btnCityCancel").observe("click", hideOverlay);

	$("btnCityOk").observe("click", function(){
		if($$("div#cityTable .selectedRow").length > 0){
			var row = ($$("div#cityTable .selectedRow"))[0];

			$("regionCd${aiItemNo}").value		= row.getAttribute("regionCd");
			$("provinceCd${aiItemNo}").value	= row.getAttribute("provinceCd");
			$("province${aiItemNo}").value		= row.getAttribute("provinceDesc");
			$("cityCd${aiItemNo}").value 		= row.getAttribute("cityCd");
			$("city${aiItemNo}").value			= row.getAttribute("city");
			$("district${aiItemNo}").value 	= "";
			$("districtNo${aiItemNo}").value 	= "";
			
			$("blockNo${aiItemNo}").value 		= "";
			$("blockId${aiItemNo}").value 		= "";
			
			$("eqZone${aiItemNo}").value 		= "";
			$("typhoonZone${aiItemNo}").value 	= "";
			$("floodZone${aiItemNo}").value 	= "";
			
			fireEvent($("blockNo${aiItemNo}"), "change");

			hideOverlay();
		}else{
			showMessageBox("Please select record first.", imgMessage.ERROR);
		}
	});
</script>