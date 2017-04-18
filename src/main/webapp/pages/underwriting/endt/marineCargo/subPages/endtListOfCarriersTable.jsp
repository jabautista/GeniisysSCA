<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="spinLoadingDiv"></div>
		<div style="margin: 10px;" id="carrierTable" name="carrierTable">	
			<div class="tableHeader" style="margin-top: 5px;">
				<label style="text-align: left; width: 240px; margin-left: 5px;">Vessel Name</label>
				<label style="text-align: left; width: 140px; margin-left: 5px;">Plate No.</label>
				<label style="text-align: left; width: 140px; margin-left: 5px;">Motor No.</label>
				<label style="text-align: left; width: 140px; margin-left: 5px;">Serial No.</label>
				<label style="text-align: right; width: 180px; margin-left: 5px;">Limit of Liability</label>
			</div>
			
			<div class="tableContainer" id="carrierListing" name="carrierListing" style="display: block;">
				<c:forEach var="carr" items="${gipiWCargoCarrier}">
					<div id="rowCarrier${carr.itemNo}${fn:trim(carr.vesselCd)}" item="${carr.itemNo}" carrCd="${carr.vesselCd}" carrName="${carr.vesselName}" carrPlate="${carr.plateNo}" carrMotor="${carr.motorNo}" carrSerial="${carr.serialNo}" carrLimit="${carr.vesselLimitOfLiab }" name="rowCarrier" class="tableRow" style="padding-left:1px;">
						<input type="hidden"	id="carrParIds"				name="carrParIds"		value="${carr.parId}" />
						<input type="hidden"	id="carrItemNos"			name="carrItemNos"		value="${carr.itemNo}" />
						<input type="hidden" 	id="carrVesselCds" 			name="carrVesselCds" 	value="${carr.vesselCd}" />
						<input type="hidden" 	id="carrVesselNames" 		name="carrVesselNames" 	value="${carr.vesselName}" />
						<input type="hidden" 	id="carrPlateNos" 			name="carrPlateNos"		value="${carr.plateNo}" />
						<input type="hidden" 	id="carrMotorNos"  			name="carrMotorNos" 	value="${carr.motorNo}" />
						<input type="hidden" 	id="carrSerialNos"  		name="carrSerialNos" 	value="${carr.serialNo}" />
						<input type="hidden" 	id="carrLimitOfLiabilitys"  name="carrLimitOfLiabilitys" value="${carr.vesselLimitOfLiab}" class="money"/>
						
						<input type="hidden" 	id="carrEtas"  		name="carrEtas" 		value="${carr.eta}" />
						<input type="hidden" 	id="carrEtds"  		name="carrEtds" 		value="${carr.etd}" />
						<input type="hidden" 	id="carrOrigins"  	name="carrOrigins" 		value="${carr.origin}" />
						<input type="hidden" 	id="carrDestns"  	name="carrDestns" 		value="${carr.destn}" />
						<input type="hidden" 	id="carrDeleteSws"  name="carrDeleteSws" 	value="${carr.deleteSw}" />
						<input type="hidden" 	id="carrVoyLimits"  name="carrVoyLimits" 	value="${carr.voyLimit}" />
						
						<label name="textCarrier" style="width: 240px; margin-left:5px;" >${carr.vesselName}</label>
						<label name="textCarrier" style="width: 140px; margin-left:5px;" >${carr.plateNo}<c:if test="${empty carr.plateNo}">-</c:if></label>
						<label name="textCarrier" style="width: 140px; margin-left:5px;" >${carr.motorNo}<c:if test="${empty carr.motorNo}">-</c:if></label>
						<label name="textCarrier" style="width: 140px; margin-left:5px;" >${carr.serialNo}<c:if test="${empty carr.serialNo}">-</c:if></label>
						<label name="textCarrier" style="width: 180px; text-align: right;  margin-left: 5px;" <c:if test="${!empty carr.vesselLimitOfLiab}">class="money"</c:if> >${carr.vesselLimitOfLiab }<c:if test="${empty carr.vesselLimitOfLiab}">---</c:if></label>
					</div>
				</c:forEach>
			</div>
			<div id="listOfCarrierTotalAmtDiv">
				<div class="tableHeader">
					<label style="text-align: left; width: 100px; margin-left: 5px;">Total:</label>
					<label id="lblTotalLimit" style="text-align: right; width: 180px; float: right; margin-right: 34px;" class="money">&nbsp;</label>
				</div>
			</div>
		</div>
	
<script type="text/javascript">
	$$("label[name='textCarrier']").each(function (label)    {
   		if ((label.innerHTML).length > 30)    {
        	label.update((label.innerHTML).truncate(30, "..."));
    	}
	});
</script>		