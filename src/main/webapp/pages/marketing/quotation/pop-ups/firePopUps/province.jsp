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
		<div id="provinceTable" style="width: 600px;">
			<div class="tableHeader">
				<label style="width: 200px; margin-left: 5px;">Province</label>
			</div>
			<div class="tableContainer" id="cityListing" name="cityListing" style="height: 310px; overflow: auto;">
				<c:forEach var="p" items="${provinceListing}">
					<div id="${p.provinceCd}" name="rowProvince" provinceCd="${p.provinceCd}" provinceDesc="${p.provinceDesc}" regionCd="${p.regionCd}" class="tableRow">
						<label style="width: 200px; margin-left: 5px;">${p.provinceDesc}</label>
						<!--<label>${city.city}</label>
					--></div>
				</c:forEach>
			</div>
		</div>
	</div>
	<div align="center">
		<input type="button" style="width: 80px;" id="btnProvinceOk" 		name="btnProvinceOk" 		value="Ok" 		class="button" />
		<input type="button" style="width: 80px;" id="btnProvinceCancel" 	name="btnProvinceCancel" 	value="Cancel" 	class="button" />
	</div>
</div>
<script>
	$$("div[name='rowProvince']").each(function(row){
		loadRowMouseOverMouseOutObserver(row);
	
		row.observe("click", function(){
			row.toggleClassName("selectedRow");
			if(row.hasClassName("selectedRow")){
				($$("div#provinceTable div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");				
			}
		});
	});
	
	$("btnProvinceCancel").observe("click", hideOverlay);

	$("btnProvinceOk").observe("click", function(){
		if($$("div#provinceTable .selectedRow").length > 0){
			var row = ($$("div#provinceTable .selectedRow"))[0];
			$("provinceCd${aiItemNo}").value	= row.getAttribute("provinceCd");
			$("province${aiItemNo}").value		= row.getAttribute("provinceDesc");
			$("regionCd${aiItemNo}").value		= row.getAttribute("regionCd");
			
			$("cityCd${aiItemNo}").value 		= "";
			$("city${aiItemNo}").value			= "";
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