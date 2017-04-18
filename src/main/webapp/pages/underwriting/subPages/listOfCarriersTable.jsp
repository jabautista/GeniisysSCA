<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="spinLoadingDiv"></div>
		<div style="margin:10px; margin-bottom:0px; margin-top:5px; padding-top:1px;" id="carrierTable" name="carrierTable">	
			<div class="tableHeader" style="margin-top: 5px;">
				<label style="text-align: left; width: 25%; margin-right:2px;">Vessel Name</label>
				<label style="text-align: left; width: 16%; margin-right:2px;">Plate No.</label>
				<label style="text-align: left; width: 16%; margin-right:2px;">Motor No.</label>
				<label style="text-align: left; width: 16%; margin-right:2px;">Serial No.</label>
				<label style="text-align: right; width: 25%;">Limit of Liability</label>
			</div>
			
			<div class="tableContainer" id="carrierListing" name="carrierListing" style="display: block;">
				<c:forEach var="carr" items="${gipiWCargoCarrier}">
					<div id="rowCarr${carr.itemNo}${carr.vesselCd}" item="${carr.itemNo}" carrCd="${carr.vesselCd}" carrName="${carr.vesselName}" carrPlate="${carr.plateNo}" carrMotor="${carr.motorNo}" carrSerial="${carr.serialNo}" carrLimit="${carr.vesselLimitOfLiab }" name="carr" class="tableRow" style="padding-left:1px;">
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
						
						<label name="textCarrier" style="width: 25%; margin-right:2px;" >${carr.vesselName}</label>
						<label name="textCarrier" style="width: 16%; margin-right:2px;" >${carr.plateNo}<c:if test="${empty carr.plateNo}">-</c:if></label>
						<label name="textCarrier" style="width: 16%; margin-right:2px;" >${carr.motorNo}<c:if test="${empty carr.motorNo}">-</c:if></label>
						<label name="textCarrier" style="width: 16%; margin-right:2px;" >${carr.serialNo}<c:if test="${empty carr.serialNo}">-</c:if></label>
						<label name="textCarrier" style="width: 25%; text-align: right;" <c:if test="${!empty carr.vesselLimitOfLiab}">class="money"</c:if> >${carr.vesselLimitOfLiab }<c:if test="${empty carr.vesselLimitOfLiab}">---</c:if></label>
					</div>
				</c:forEach>
			</div>
		</div>
		<div id="listOfCarrierTotalAmtDiv" style="display:none; margin:10px; margin-top:0px;">
			<div class="tableHeader" style="margin-top: 0px;">
				<label style="text-align: left; width: 25%;">Total:</label>
				<label style="text-align: right; width:70%; float:right; margin-right:10px;" class="money">&nbsp;</label>
			</div>
		</div>
		
<script type="text/javascript">
	$$("label[name='textCarrier']").each(function (label)    {
   		if ((label.innerHTML).length > 20)    {
        	label.update((label.innerHTML).truncate(20, "..."));
    	}
	});
</script>		