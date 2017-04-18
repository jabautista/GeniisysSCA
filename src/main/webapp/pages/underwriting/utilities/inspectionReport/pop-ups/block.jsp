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
	<input type="hidden" id="columnName" name="columnName" value="${column}" />
	<div style="margin-bottom: 10px;">
		<div id="blockTable" style="width: 800px;">			
			<div id="filterLOV" style="margin-bottom: 10px;">
				<label style="width: 70px; line-height: 20px;">Filter List</label>
				<input type="text" id="filterContent" name="filterContent" style="width: 520px;" tabindex="1" />
				<select id="filterColumn" name="filterColumn" style="width : 150px;">
					<option value="district">Disctrict</option>
					<option value="block">Block</option>
				</select>
			</div>			
			<div class="tableHeader">
				<label style="width: 100px; margin-left: 5px;">District No.</label>
				<label style="width: 300px;">District Description</label>
				<label style="width: 100px;">Block No.</label>
				<label>Block Description</label>
			</div>			
			<div class="tableContainer" id="blockListing" name="blockListing" style="height: 310px; overflow: auto;">
				<c:forEach var="block" items="${blockListing}">
					<div id="${block.provinceCd}_${block.cityCd}_${block.districtNo}_${block.blockId}"  name="rowBlock" class="tableRow"
						regionCd="${block.regionCd}" provinceCd="${block.provinceCd}" province="${block.province}" cityCd="${block.cityCd}" city="${block.city}" 
						districtNo="${block.districtNo}" districtDesc="${fn:toUpperCase(block.districtDesc)}" 
						blockId="${block.blockId}" blockNo="${fn:toUpperCase(block.blockNo)}" blockDesc="${block.blockDesc}" 
						eqZone="${block.eqZone}" typhoonZone="${block.typhoonZone}" floodZone="${block.floodZone}">
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
			
			$("provinceCd").value	= row.getAttribute("provinceCd");	
			$("province").value		= row.getAttribute("province");
			$("cityCd").value		= row.getAttribute("cityCd");
			$("city").value			= row.getAttribute("city");
			$("district").value 	= row.getAttribute("districtNo");
			$("districtNo").value 	= row.getAttribute("districtNo");
			$("block").value 		= row.getAttribute("blockNo");
			$("eqZone").value 		= row.getAttribute("eqZone");
			$("typhoonZone").value 	= row.getAttribute("typhoonZone");
			$("floodZone").value 	= row.getAttribute("floodZone");

			fireEvent($("block"), "change");	
			
			hideOverlay();
		}else{
			showMessageBox("Please select record first.", imgMessage.ERROR);			
		}
	});

	$("filterColumn").value = $F("columnName");


	$("filterContent").observe("keyup", function(evt){
		if(evt.keyCode == objKeyCode.ESC){
			$("filterContent").value = "";
			$$("div#blockTable div[name='rowBlock']").invoke("show");
		}else{
			var text = replaceSpecialCharsInFilterText($("filterContent").value.strip());

			$$("div#blockTable div[name='rowBlock']").invoke("removeClassName", "selectedRow");
			$$("div#blockTable div[name='rowBlock']").invoke("show");
				
			if(text != ""){
				if($F("filterColumn") == "district"){					
					$$("div#blockListing div:not([districtDesc*='" + text.toUpperCase() + "'])").invoke("hide");
				}else{
					$$("div#blockListing div:not([blockDesc*='" + text.toUpperCase() + "'])").invoke("hide");
				}
			}
		}
	});
</script>
