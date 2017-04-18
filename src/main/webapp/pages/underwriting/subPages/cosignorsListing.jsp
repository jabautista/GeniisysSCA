<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>


<div id="signorsMainDiv" name="signorsMainDiv" class="sectionDiv" style="">
	<div id="coSignorsListingDiv" name="coSignorsListingDiv" style="margin: 10px;">
		<div id="searchResultSignors" align="center">
			<div style="width: 100%;" id="signorsTable" name="signorsTable">
				<div class="tableHeader">
					<label style="width: 30%; text-align: left; margin-left: 5px;">Co-Signatory</label>
					<label style="width: 15%; text-align: center">Bonds</label>
					<label style="width: 15%; text-align: center">Indemnity</label>
					<label style="width: 15%; text-align: center">RI Agreement</label>
				</div>
				<div id="signorsDiv" name="signorsDiv" class="tableContainer">
					<c:forEach var="cos" items="${cosignorsListing}" varStatus="ctr">
						<div id="row${cos.cosignId}" name="rowSignor" cosignId="${cos.cosignId}" class="tableRow" style="height: 20px; border-bottom: 1px solid #E0E0E0; padding-top: 10px;">
							<label style="width:  30%; text-align: left; margin-left: 5px;">${fn:escapeXml(cos.cosignName)}</label>
							<label style="width:  15%; text-align: center;">
								<c:choose>
									<c:when test="${'Y' eq cos.bondsFlag}">
										<img name="checkedImg" style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 49%; text-align: center;" />
									</c:when>
									<c:otherwise>
										<span style="text-align:center; width: 10px; height: 10px;">-</span>
									</c:otherwise>
								</c:choose>
							</label>
							<label style="width:  15%; text-align: center;">
								<c:choose>
									<c:when test="${'Y' eq cos.indemFlag}">
										<img name="checkedImg" style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 49%; text-align: center;" />
									</c:when>
									<c:otherwise>
										<span style="text-align:center; width: 10px; height: 10px;">-</span>
									</c:otherwise>
								</c:choose>
							</label>
							<label style="width:  15%; text-align: center;">
								<c:choose>
									<c:when test="${'Y' eq cos.bondsRiFlag}">
										<img name="checkedImg" style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 49%; text-align: center;" />
									</c:when>
									<c:otherwise>
										<span style="text-align:center; width: 10px; height: 10px;">-</span>
									</c:otherwise>
								</c:choose>
							</label>
							<input id="cosignId${cos.cosignId}" 	name="cosignId${cos.cosignId}" 		type="hidden" value="${cos.cosignId}"/>
							<input id="assdNo${cos.cosignId}" 		name="assdNo${cos.cosignId}" 		type="hidden" value="${cos.assdNo}"/>
							<input id="indemFlag${cos.cosignId}" 	name="indemFlag${cos.cosignId}" 	type="hidden" value="${cos.indemFlag}"/>
							<input id="bondsFlag${cos.cosignId}" 	name="bondsFlag${cos.cosignId}" 	type="hidden" value="${cos.bondsFlag}"/>
							<input id="bondsRiFlag${cos.cosignId}" 	name="bondsRiFlag${cos.cosignId}" 	type="hidden" value="${cos.bondsRiFlag}"/>
							<input id="cosignName${cos.cosignId}" 	name="cosignName${cos.cosignId}" 	type="hidden" value="${cos.cosignName}"/>
							<input id="designation${cos.cosignId}" 	name="designation${cos.cosignId}" 	type="hidden" value="${cos.designation}"/>
							<input id="cosignId" name="cosignId" type="hidden" value="${cos.cosignId}"/>
						</div>
					</c:forEach>
				</div>
			</div>
		</div>
	</div>
	<div id="addSignorDiv" name="addSignorDiv" align="center">
		<table align="center" style="margin-top: 10px; width: 80%;">
			<tr style="width: 98%;">
				<td class="rightAligned" style="width: 30%;">Co-Signatory</td>
				<td class="leftAligned" style="width: 70%;">
					<select id="dspPrinSignorList" name="dspPrinSignorList" style="width: 75%">
						<option value="" designation="" cosignName=""></option>
						<c:forEach var="cs" items="${cosignNames}" varStatus="ctr">
							<option value="${cs.cosignId}" designation="${cs.designation}" cosignName="${fn:escapeXml(cs.cosignName)}" assdNo="${cs.assdNo}">${fn:escapeXml(cs.cosignName)}</option>
						</c:forEach>
					</select>
					<input type="checkbox" id="bondsFlag" name="bondsFlag" style="margin-left: 3px;" title="Bonds"/>
					<input type="checkbox" id="indemFlag" name="indemFlag" style="margin-left: 3px;" title="Indemnity"/>
					<input type="checkbox" id="bondsRiFlag" name="bondsRiFlag" style="margin-left: 3px;" title="RI Agreement"/>
				</td>
			</tr>
			<tr>
				<td colspan="2" style="text-align: center;">
					<input type="button" id="btnAdd" name="btnAdd" class="button" value="Add" style="margin-top: 5px; width: 50px; margin-bottom: 10px;"/>
					<input type="button" id="btnDelete" name="btnDelete" class="button" value="Delete" style="margin-top: 5px; width: 50px; margin-bottom: 10px;"/>
					
				</td>
			</tr>
		</table>
	</div>
</div>
<div id="selectedDiv" name="selectedDiv">
	<input type="hidden" id="selectedCosignId" 		name="selectedCosignId"/>
	<input type="hidden" id="selectedAssdNo" 		name="selectedAssdNo"/>
	<input type="hidden" id="selectedIndemFlag" 	name="selectedIndemFlag"/>
	<input type="hidden" id="selectedBondsFlag" 	name="selectedBondsFlag"/>
	<input type="hidden" id="selectedBondsRiFlag" 	name="selectedBondsRiFlag"/>
	<input type="hidden" id="selectedCosignName" 	name="selectedCosignName"/>
	<input type="hidden" id="selectedDesignation" 	name="selectedDesignation"/>
</div>
<div id="hiddenDetailsDiv" name="hiddenDetailsDiv">
	<input type="hidden" id="cosignIds" 			name="cosignIds"/>
	<input type="hidden" id="cosignName" 			name="cosignName"/>
	<input type="hidden" id="assdNo" 				name="assdNo"/>
	<input type="hidden" id="cosignDesignation" 	name="cosignDesignation"/>
</div>
<script type="text/javaScript">
	initializeAccordion();
	changeCheckImageColor();
	disableButton("btnDelete");
	moderateCosignorsListOptions();
	
	$("dspPrinSignorList").observe("change", function(){
		$("cosignIds").value = $("dspPrinSignorList").value;
		$("cosignName").value = $("dspPrinSignorList").options[$("dspPrinSignorList").selectedIndex].getAttribute("cosignName");
		$("cosignDesignation").value = $("dspPrinSignorList").options[$("dspPrinSignorList").selectedIndex].getAttribute("designation");
		$("assdNo").value = $("dspPrinSignorList").options[$("dspPrinSignorList").selectedIndex].getAttribute("assdNo");
	});
	
	$$("div[name='rowSignor']").each(
		function (row)	{
			initializeCosignorRow(row);
		}
	);
	
	$("btnDelete").observe("click", function(){
		$$("div[name='rowSignor']").each(function (row)	{
			if (row.hasClassName("selectedRow"))	{
				Effect.Fade(row, {
					duration: .2,
					afterFinish: function ()	{
						row.remove();
						clearAddCosignorFields();
						clearSelected();
						$("cosignorsPageChangedSw").value = "Y";
						moderateCosignorsListOptions();
						changeTag = 1; //added by robert 12.05.2013
					}
				});
			}
		});
	});
	
	$("btnAdd").observe("click", function(){
		if (validateCosignorBeforeSave()){
			var signorExists	= false;
			var cosignId 		= $F("cosignIds");
			var cosignName 		= $F("cosignName");
			var assdNo 			= $F("assdNo");
			var designation 	= $F("cosignDesignation");
			var bondsFlag		= $("bondsFlag").checked? "Y": "N";
			var bondsRiFlag		= $("bondsRiFlag").checked? "Y": "N";
			var indemFlag		= $("indemFlag").checked? "Y": "N";
			$$("div[name='row']").each(function(a){
				if ((((a.getAttribute("id")).substring(3))== cosignId) && ($("btnAdd").value != "Update")) {
					showMessageBox("Cosignor must be unique", "error");
					signorExists = true;
					return false;
				}
			});
			if (!signorExists){
				if ($F("btnAdd") == "Update"){
					var oldCosignId = $F("selectedCosignId");
					$("row"+oldCosignId).writeAttribute("id", "row"+cosignId);
					$("row"+cosignId).writeAttribute("cosignId", cosignId);
					var content = "<label style='width:  30%; text-align: left; margin-left: 5px;'>"+cosignName+"</label>"
							+"<label style='width:  15%; text-align: center;'>";
					if ("Y" == bondsFlag){
						content += "<img name='checkedImg' style='width: 10px; height: 10px; text-align: left; display: block; margin-left: 49%; text-align: center;' />";
					} else {
						content += "<span style='text-align:center; width: 10px; height: 10px;'>-</span>";
					}
					content += "</label><label style='width:  15%; text-align: center;'>";
					if ("Y" == indemFlag){
						content += "<img name='checkedImg' style='width: 10px; height: 10px; text-align: left; display: block; margin-left: 49%; text-align: center;' />";
					} else {
						content += "<span style='text-align:center; width: 10px; height: 10px;'>-</span>";
					}
					content += "</label><label style='width:  15%; text-align: center;'>";
					if ("Y" == bondsRiFlag){
						content += "<img name='checkedImg' style='width: 10px; height: 10px; text-align: left; display: block; margin-left: 49%; text-align: center;' />";
					} else {
						content += "<span style='text-align:center; width: 10px; height: 10px;'>-</span>";
					}
					content += "</label><input id='cosignId"+cosignId+"' 	name='cosignId"+cosignId+"' 		type='hidden' value='"+cosignId+"'/>"
					+"<input id='assdNo"+cosignId+"' 		name='assdNo"+cosignId+"' 		type='hidden' value='"+assdNo+"'/>"
					+"<input id='indemFlag"+cosignId+"' 	name='indemFlag"+cosignId+"' 	type='hidden' value='"+indemFlag+"'/>"
					+"<input id='bondsFlag"+cosignId+"' 	name='bondsFlag"+cosignId+"' 	type='hidden' value='"+bondsFlag+"'/>"
					+"<input id='bondsRiFlag"+cosignId+"' 	name='bondsRiFlag"+cosignId+"' 	type='hidden' value='"+bondsRiFlag+"'/>"
					+"<input id='cosignName"+cosignId+"' 	name='cosignName"+cosignId+"' 	type='hidden' value='"+cosignName+"'/>"
					+"<input id='designation"+cosignId+"' 	name='designation"+cosignId+"' 	type='hidden' value='"+designation+"'/>"
					+"<input id='cosignId' name='cosignId' type='hidden' value='"+cosignId+"''/>";
					$("row"+cosignId).update(content);
				}
				else { //if add
					var newDiv = new Element("div");
					newDiv.setAttribute("id", "row"+cosignId);
					newDiv.setAttribute("name", "rowSignor");
					newDiv.setAttribute("cosignId", cosignId);
					newDiv.addClassName("tableRow");
					newDiv.setStyle("display: none;");
					var content = "<label style='width:  30%; text-align: left; margin-left: 5px;'>"+cosignName+"</label>"
					+"<label style='width:  15%; text-align: center;'>";
					if ("Y" == bondsFlag){
						content += "<img name='checkedImg' style='width: 10px; height: 10px; text-align: left; display: block; margin-left: 49%; text-align: center;' />";
					} else {
						content += "<span style='text-align:center; width: 10px; height: 10px;'>-</span>";
					}
					content += "</label><label style='width:  15%; text-align: center;'>";
					if ("Y" == indemFlag){
						content += "<img name='checkedImg' style='width: 10px; height: 10px; text-align: left; display: block; margin-left: 49%; text-align: center;' />";
					} else {
						content += "<span style='text-align:center; width: 10px; height: 10px;'>-</span>";
					}
					content += "</label><label style='width:  15%; text-align: center;'>";
					if ("Y" == bondsRiFlag){
						content += "<img name='checkedImg' style='width: 10px; height: 10px; text-align: left; display: block; margin-left: 49%; text-align: center;' />";
					} else {
						content += "<span style='text-align:center; width: 10px; height: 10px;'>-</span>";
					}
					content += "</label><input id='cosignId"+cosignId+"' 	name='cosignId"+cosignId+"' 		type='hidden' value='"+cosignId+"'/>"
					+"<input id='assdNo"+cosignId+"' 		name='assdNo"+cosignId+"' 		type='hidden' value='"+assdNo+"'/>"
					+"<input id='indemFlag"+cosignId+"' 	name='indemFlag"+cosignId+"' 	type='hidden' value='"+indemFlag+"'/>"
					+"<input id='bondsFlag"+cosignId+"' 	name='bondsFlag"+cosignId+"' 	type='hidden' value='"+bondsFlag+"'/>"
					+"<input id='bondsRiFlag"+cosignId+"' 	name='bondsRiFlag"+cosignId+"' 	type='hidden' value='"+bondsRiFlag+"'/>"
					+"<input id='cosignName"+cosignId+"' 	name='cosignName"+cosignId+"' 	type='hidden' value='"+cosignName+"'/>"
					+"<input id='designation"+cosignId+"' 	name='designation"+cosignId+"' 	type='hidden' value='"+designation+"'/>"
					+"<input id='cosignId' name='cosignId' type='hidden' value='"+cosignId+"''/>";
	
					newDiv.update(content);
					$("signorsDiv").insert({bottom: newDiv});
					
					initializeCosignorRow(newDiv);
				}
				changeCheckImageColor();
				$("cosignorsPageChangedSw").value = "Y";
				Effect.Appear("row"+cosignId, {
					duration: .2,
					afterFinish: function () {
					clearAddCosignorFields();
					moderateCosignorsListOptions();
					}
				});
				changeTag = 1; //added by robert 12.05.2013
			}
		}
	});
	
	function validateCosignorBeforeSave(){
		var result = true;
		var cosignIndex = $("dspPrinSignorList").selectedIndex;
		if (cosignIndex ==  0){
			showMessageBox("A Principal signor must be selected.", "error");
			result = false;
		}
		return result;
	}
	
	function clearSelected(){
		$("selectedCosignId").value 			= "";
		$("selectedAssdNo").value 				= "";
		$("selectedIndemFlag").value 			= "";
		$("selectedBondsFlag").value 			= "";
		$("selectedBondsRiFlag").value 			= "";
		$("selectedCosignName").value 			= "";
		$("selectedDesignation").value 			= "";
	}
	
	function clearAddCosignorFields(){
		$("dspPrinSignorList").selectedIndex	= 0;
		$("cosignName").value					= "";
		$("cosignIds").value					= "";
		$("assdNo").value						= "";
		$("bondsFlag").checked					= false;
		$("bondsRiFlag").checked				= false;
		$("indemFlag").checked					= false;
		$("btnAdd").value						= "Add";
	}
	
	function moderateCosignorsListOptions(){
		$("dspPrinSignorList").childElements().each(function (o) {
			o.show();
			o.disabled = false;
		});
	
		$("dspPrinSignorList").childElements().each(function (o) {
			$$("div[name='rowSignor']").each(function(c){
				if (c.getAttribute("cosignId") == o.value){
					o.hide();
					o.disabled = true;
				}
			});
		});
	}
	
	function initializeCosignorRow(row){
		row.observe("mouseover", function ()	{
			row.addClassName("lightblue");
		});
	
		row.observe("mouseout", function ()	{
			row.removeClassName("lightblue");
		});
	
		row.observe("click", function ()	{
			row.toggleClassName("selectedRow");
			if (row.hasClassName("selectedRow"))	{
				try {
					$$("div[name='rowSignor']").each(function (r)	{
						if (row.getAttribute("id") != r.getAttribute("id"))	{
							r.removeClassName("selectedRow");
						}
					});
	
					$("selectedCosignId").value 			= row.down("input", 0).value;
					$("selectedAssdNo").value 				= row.down("input", 1).value;
					$("selectedIndemFlag").value 			= row.down("input", 2).value;
					$("selectedBondsFlag").value 			= row.down("input", 3).value;
					$("selectedBondsRiFlag").value 			= row.down("input", 4).value;
					$("selectedCosignName").value 			= row.down("input", 5).value;
					$("selectedDesignation").value 			= row.down("input", 6).value;
					var s 								= $("dspPrinSignorList");
					for (var i=0; i<(s.length); i++)	{
						if (s.options[i].value==$("selectedCosignId").value)	{
							s.selectedIndex = i;
						}
					}
					$("cosignName").value				= $("dspPrinSignorList").options[$("dspPrinSignorList").selectedIndex].getAttribute("cosignName");
					$("cosignIds").value				= $("dspPrinSignorList").value;
					$("assdNo").value					= $("selectedAssdNo").value;
					$("bondsFlag").checked				= ("Y" == $F("selectedBondsFlag"))? true: false;
					$("bondsRiFlag").checked			= ("Y" == $F("selectedBondsRiFlag"))? true: false;
					$("indemFlag").checked				= ("Y" == $F("selectedIndemFlag"))? true: false;
	
					$("btnAdd").value			= "Update";
					enableButton("btnDelete");
				
				} catch (e){
					showErrorMessage("initializeCosignorRow", e);
				}
			} else {
				clearSelected();
				clearAddCosignorFields();
	
				$("btnAdd").value			= "Add";
				disableButton("btnDelete");
			}
		});
	}

</script>