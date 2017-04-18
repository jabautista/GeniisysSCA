<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<%
	response.setHeader("Cache-control", "No-cache");
	response.setHeader("Pragma", "No-cache");
%>

<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>
<div style="margin: 10px; float: left;">
	<input type="hidden" id="columnName" name="columnName" value="${column}" />
	<div style="margin-bottom: 10px;">
		<div id="blockTable" style="width: 800px;">
			<div class="tableHeader">
				<label style="width: 100px; margin-left: 5px;">District No.</label>
				<label style="width: 300px;">District Description</label>
				<label style="width: 100px;">Block No.</label>
				<label>Block Description</label>
			</div>
			<div class="tableContainer" id="blockListing" name="blockListing" style="height: 310px; overflow: auto;">
				<c:forEach var="block" items="${blockListing}">
					<div id="${block.provinceCd}_${block.cityCd}_${block.districtNo}_${block.blockId}" regionCd="${block.regionCd}" provinceCd="${block.provinceCd}" province="${block.province}" cityCd="${block.cityCd}" city="${block.city}" districtNo="${block.districtNo}" districtDesc="${block.districtDesc}" blockId="${block.blockId}" blockNo="${block.blockNo}" eqZone="${block.eqZone}" typhoonZone="${block.typhoonZone}" floodZone="${block.floodZone}" name="rowBlock" class="tableRow">
						<label style="width: 100px; margin-left: 5px;">${block.districtNo}</label>
						<label style="width: 300px;"><c:if test="${empty block.districtDesc}">---</c:if> ${block.districtDesc}</label>
						<label style="width: 100px;">${block.blockNo}</label>
						<label>${block.blockDesc}</label>
					</div>
				</c:forEach>
			</div>
		</div>
	</div>
	<div align="center">
		<input type="button" style="width: 80px;" id="btnBlockOk" 		name="btnBlockOk" 		value="Ok" 		class="button" />
		<input type="button" style="width: 80px;" id="btnBlockCancel" 	name="btnBlockCancel" 	value="Cancel" 	class="button" />
	</div>
</div>

<script type="text/javascript">		
	$$("div[name='rowBlock']").each(function(row){
		loadRowMouseOverMouseOutObserver(row);

		row.observe("click", function(){
			row.toggleClassName("selectedRow");
			if(row.hasClassName("selectedRow")){
				($$("div#blockTable div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");				
			}
		});
	});

	$("btnBlockCancel").observe("click", hideOverlay);

	$("btnBlockOk").observe("click", function(){		
		if($$("div#blockListing .selectedRow").length > 0){
			var row = ($$("div#blockListing .selectedRow"))[0];
			var column = $F("columnName");
			
			//if(column == "district"){
			//	$("region").value		= row.getAttribute("regionCd");
			//	$("provinceCd").value	= row.getAttribute("provinceCd");	
			//	$("province").value		= row.getAttribute("province");
			//	$("cityCd").value		= row.getAttribute("cityCd");
			//	$("city").value			= row.getAttribute("city");
			//	$("district").value 	= row.getAttribute("districtNo");
			//	$("districtNo").value 	= row.getAttribute("districtNo");
			//}else if(column == "block"){
				$("regionCd${aiItemNo}").value		= row.getAttribute("regionCd");
				$("provinceCd${aiItemNo}").value	= row.getAttribute("provinceCd");	
				$("province${aiItemNo}").value		= row.getAttribute("province");
				$("cityCd${aiItemNo}").value		= row.getAttribute("cityCd");
				$("city${aiItemNo}").value			= row.getAttribute("city");
				$("district${aiItemNo}").value 	= row.getAttribute("districtNo");
				$("districtNo${aiItemNo}").value 	= row.getAttribute("districtNo");
				$("blockNo${aiItemNo}").value 		= row.getAttribute("blockNo");
				$("blockId${aiItemNo}").value 		= row.getAttribute("blockId");
				
				$("eqZone${aiItemNo}").value 		= row.getAttribute("eqZone");
				$("typhoonZone${aiItemNo}").value 	= row.getAttribute("typhoonZone");
				$("floodZone${aiItemNo}").value 	= row.getAttribute("floodZone");

				fireEvent($("blockNo${aiItemNo}"), "change");
			//}		
			
			hideOverlay();
		}else{
			showMessageBox("Please select record first.", imgMessage.ERROR);			
		}
	});
</script>
