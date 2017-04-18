<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    response.setHeader("Cache-control", "No-Cache");
    response.setHeader("Pragma", "No-Cache");
%>

<div id="itemInformation" name="itemInformationMainDiv" style="width: 100%;">   
    <div id="searchResultParItem" align="center" style="margin: 10px;">
        <div style="margin: 10px;" id="itemTable" name="itemTable">          
            <div class="tableHeader">
                <label style="width: 5%; text-align: right; margin-right: 10px;">No.</label>
                <label style="width: 20%; text-align: left;">Item Title</label>
                <label style="width: 20%; text-align: left;">Description 1</label>
                <label style="width: 20%; text-align: left;">Description 2</label>
                <label style="width: 10%; text-align: left;">Currency</label>
                <label style="width: 10%; text-align: right; margin-right: 10px;">Rate</label>
                <label style="text-align: left;">Coverage</label>
            </div>
            <div id="parItemTableContainer" class="tableContainer">
            	<input type="hidden" name="itemCount" id="itemCount" value="${itemCount}">
                <c:forEach var="item" items="${items}" varStatus="ctr">
                    <div id="row${item.itemNo}" name="row" class="tableRow" style="padding-left:1px;" /> <!-- style="height: 20px; border-bottom: 1px solid #E0E0E0; padding-top: 10px;"> -->
                    	<input type="hidden" name="parIds" 					value="${fn:escapeXml(item.parId)}" />
						<input type="hidden" name="masterItemNos" 			value="${fn:escapeXml(item.itemNo)}" />
						<input type="hidden" name="masterItemTitles" 		value="${fn:escapeXml(item.itemTitle)}" />
						<input type="hidden" name="masterItemGrps" 			value="${fn:escapeXml(item.itemGrp)}" />
						<input type="hidden" name="masterItemDescs" 		value="${fn:escapeXml(item.itemDesc)}" />
						<input type="hidden" name="masterItemDesc2s" 		value="${fn:escapeXml(item.itemDesc2)}" />
						<input type="hidden" name="masterTsiAmts" 			value="${fn:escapeXml(item.tsiAmt)}" />
						<input type="hidden" name="masterPremAmts" 			value="${fn:escapeXml(item.premAmt)}" />
						<input type="hidden" name="masterAnnPremAmts" 		value="${fn:escapeXml(item.annPremAmt)}" />
						<input type="hidden" name="masterAnnTsiAmts" 		value="${fn:escapeXml(item.annTsiAmt)}" />
						<input type="hidden" name="masterRecFlags" 			value="${fn:escapeXml(item.recFlag)}" />
						<input type="hidden" name="masterCurrencyCds" 		value="${fn:escapeXml(item.currencyCd)}" />
						<input type="hidden" name="masterCurrencyRts" 		value="${fn:escapeXml(item.currencyRt)}" />
						<input type="hidden" name="masterGroupCds" 			value="${fn:escapeXml(item.groupCd)}" />
						<input type="hidden" name="masterFromDates" 		value='<fmt:formatDate value='${item.fromDate}' pattern="MM-dd-yyyy" />' />
						<input type="hidden" name="masterToDates" 			value='<fmt:formatDate value='${item.toDate}' pattern="MM-dd-yyyy" />' />
						<input type="hidden" name="masterPackLineCds" 		value="${fn:escapeXml(item.packLineCd)}" />
						<input type="hidden" name="masterPackSublineCds" 	value="${fn:escapeXml(item.packSublineCd)}" />
						<input type="hidden" name="masterDiscountSws" 		value="${fn:escapeXml(item.discountSw)}" />
						<input type="hidden" name="masterCoverageCds" 		value="${fn:escapeXml(item.coverageCd)}" />
						<input type="hidden" name="masterOtherInfos" 		value="${fn:escapeXml(item.otherInfo)}" />
						<input type="hidden" name="masterSurchargeSws" 		value="${fn:escapeXml(item.surchargeSw)}" />
						<input type="hidden" name="masterRegionCds" 		value="${fn:escapeXml(item.regionCd)}" />
						<input type="hidden" name="masterChangedTags" 		value="${fn:escapeXml(item.changedTag)}" />
						<input type="hidden" name="masterProrateFlags" 		value="${fn:escapeXml(item.prorateFlag)}" />
						<input type="hidden" name="masterCompSws" 			value="${fn:escapeXml(item.compSw)}" />
						<input type="hidden" name="masterShortRtPercents" 	value="${fn:escapeXml(item.shortRtPercent)}" />
						<input type="hidden" name="masterPackBenCds" 		value="${fn:escapeXml(item.packBenCd)}" />
						<input type="hidden" name="masterPaytTermss" 		value="${fn:escapeXml(item.paytTerms)}" />
						<input type="hidden" name="masterRiskNos" 			value="${fn:escapeXml(item.riskNo)}" />
						<input type="hidden" name="masterRiskItemNos" 		value="${fn:escapeXml(item.riskItemNo)}" />                 
                       
						<c:choose>
							<c:when test="${lineCd == 'MC'}">
								<input type="hidden"    name="detailAssignees"			value="${item.assignee}" />
		                        <input type="hidden"    name="detailAcquiredFroms"		value="${item.acquiredFrom}" />
		                        <input type="hidden"    name="detailMotorNos"			value="${item.motorNo}" />
		                        <input type="hidden"    name="detailOrigins"			value="${item.origin}" />
		                        <input type="hidden"    name="detailDestinations"       value="${item.destination}" />
		                        <input type="hidden"    name="detailTypeOfBodyCds"		value="${item.typeOfBodyCd}" />
		                        <input type="hidden"    name="detailPlateNos"			value="${item.plateNo}" />
		                        <input type="hidden"    name="detailModelYears"			value="${item.modelYear}" />
		                        <input type="hidden"    name="detailCarCompanyCds"		value="${item.carCompanyCd}" />
		                        <input type="hidden"    name="detailMVFileNos"			value="${item.mvFileNo}" />
		                        <input type="hidden"    name="detailNoOfPass"			value="${item.noOfPass}" />
		                        <input type="hidden"    name="detailMakeCds"			value="${item.makeCd}" />
		                        <input type="hidden"    name="detailBasicColorCds"		value="${item.basicColorCd}" />
		                        <input type="hidden"    name="detailColors"				value="${item.color}" />
		                        <input type="hidden"    name="detailColorCds"			value="${item.colorCd}" />
		                        <input type="hidden"    name="detailSeriesCds"			value="${item.seriesCd}" />
		                        <input type="hidden"    name="detailMotorTypes"			value="${item.motType}" />
		                        <input type="hidden"    name="detailUnladenWts"			value="${item.unladenWt}" />
		                        <input type="hidden"    name="detailTowings"			value="${item.towing}" />
		                        <input type="hidden"    name="detailSerialNos"			value="${item.serialNo}" />
		                        <input type="hidden"    name="detailSublineTypeCds"		value="${item.sublineTypeCd}" />
		                        <input type="hidden"    name="detailDeductibleAmounts"	value="${item.deductibleAmount}" />
		                        <input type="hidden"    name="detailCOCTypes"			value="${item.cocType}" />
		                        <input type="hidden"    name="detailCOCSerialNos"		value="${item.cocSerialNo}" />
		                        <input type="hidden"    name="detailCOCYYs"				value="${item.cocYY}" />
		                        <input type="hidden"    name="detailCTVTags"			value="${item.ctvTag}" />
		                        <input type="hidden"    name="detailRepairLims"			value="${item.repairLim}" />
		                        <input type="hidden"	name="sublineCds"				value="${item.sublineCd}">
							</c:when>
							<c:when test="${lineCd == 'FI'}">
								<!-- <input type="hidden"	name="detailRiskNo"					value="${item.riskNo}" /> -->
								<!-- <input type="hidden"	name="detailRiskItemNo"				value="${item.riskItemNo}" /> -->
								<input type="hidden" 	name="detailEQZone" 				value="${item.eqZone}" />
								<input type="hidden"	name="detailFromDate"				value='<fmt:formatDate value='${item.fromDate}' pattern="MM-dd-yyyy" />' />
								<input type="hidden" 	name="detailAssignee" 				value="${item.assignee}" />
								<input type="hidden" 	name="detailTyphoonZone" 			value="${item.typhoonZone}" />
								<input type="hidden"	name="detailToDate"					value='<fmt:formatDate value='${item.toDate}' pattern="MM-dd-yyyy" />' />
								<input type="hidden" 	name="detailFRItemType" 			value="${item.frItemType}" />
								<input type="hidden" 	name="detailFloodZone" 				value="${item.floodZone}" />
								<input type="hidden" 	name="detailLocRisk1" 				value="${item.locRisk1}" />
								<input type="hidden"	name="detailRegionCd"				value="${item.regionCd}">
								<input type="hidden" 	name="detailTariffZone" 			value="${item.tariffZone}" />
								<input type="hidden" 	name="detailLocRisk2" 				value="${item.locRisk2}" />
								<input type="hidden" 	name="detailProvinceCd" 			value="${item.provinceCd}" />								
								<input type="hidden" 	name="detailTarfCd" 				value="${item.tarfCd}" />
								<input type="hidden" 	name="detailLocRisk3" 				value="${item.locRisk3}" />
								<input type="hidden" 	name="detailCity" 					value="${item.city}" />
								<input type="hidden" 	name="detailConstructionCd" 		value="${item.constructionCd}" />
								<input type="hidden" 	name="detailFront" 					value="${item.front}" />								
								<input type="hidden" 	name="detailDistrictNo" 			value="${item.districtNo}" />
								<input type="hidden" 	name="detailConstructionRemarks"	value="${item.constructionRemarks}" />
								<input type="hidden" 	name="detailRight" 					value="${item.right}" />								
								<input type="hidden" 	name="detailBlockNo" 				value="${item.blockNo}" />								
								<input type="hidden" 	name="detailOccupancyCd" 			value="${item.occupancyCd}" />
								<input type="hidden" 	name="detailLeft" 					value="${item.left}" />
								<input type="hidden" 	name="detailRiskCd" 				value="${item.riskCd}" />
								<input type="hidden" 	name="detailOccupancyRemarks" 		value="${item.occupancyRemarks}" />								
								<input type="hidden" 	name="detailRear" 					value="${item.rear}" />								
								<input type="hidden" 	name="detailBlockId" 				value="${item.blockId}" />
								<input type="hidden"	name="detailProvinceDesc"			value="${item.provinceDesc}" />								
							</c:when>
							<c:when test="${lineCd == 'MN'}">
								<input type="hidden" 	name="detailPackMethods" 			value="${item.packMethod}" />
								<input type="hidden" 	name="detailBlAwbs" 				value="${item.blAwb}" />
								<input type="hidden" 	name="detailTranshipOrigins" 		value="${item.transhipOrigin}" />
								<input type="hidden" 	name="detailTranshipDestination" 	value="${item.transhipDestination}" />
								<input type="hidden" 	name="detailVoyageNos" 				value="${item.voyageNo}" />
								<input type="hidden" 	name="detailLcNos" 					value="${item.lcNo}" />
								<input type="hidden" 	name="detailEtds" 					value="<fmt:formatDate value="${item.etd}" pattern="MM-dd-yyyy" />" />
								<input type="hidden" 	name="detailEtas" 					value="<fmt:formatDate value="${item.eta}" pattern="MM-dd-yyyy" />" />
								<input type="hidden" 	name="detailOrigins" 				value="${item.origin}" />
								<input type="hidden" 	name="detailDestns" 				value="${item.destn}" />
								<input type="hidden" 	name="detailInvCurrRts" 			value="${item.invCurrRt}" />
								<input type="hidden" 	name="detailInvoiceValues" 			value="${item.invoiceValue}" />
								<input type="hidden" 	name="detailMarkupRates" 			value="${item.markupRate}" />
								<input type="hidden" 	name="detailRecFlagWCargos" 		value="${item.recFlagWCargo}" />
								<input type="hidden" 	name="detailCpiRecNos" 				value="${item.cpiRecNo}" />
								<input type="hidden" 	name="detailCpiBranchCds" 			value="${item.cpiBranchCd}" />
								<input type="hidden" 	name="detailDeductTexts" 			value="${item.deductText}" />
								<input type="hidden" 	name="detailGeogCds" 				value="${item.geogCd}" />
								<input type="hidden" 	name="detailVesselCds" 				value="${item.vesselCd}" />
								<input type="hidden" 	name="detailCargoClassCds" 			value="${item.cargoClassCd}" />
								<input type="hidden" 	name="detailCargoTypes" 			value="${item.cargoType}" />
								<input type="hidden" 	name="detailPrintTags" 				value="${item.printTag}" />
								<input type="hidden" 	name="detailInvCurrCds" 			value="${item.invCurrCd}" />
								<input type="hidden" 	name="detailPerilExists" 			value="${item.perilExist}" />
							</c:when>
							<c:when test="${lineCd == 'AV'}">
								<input type="hidden" 	name="detailPurposes" 			value="${item.purpose}" />
								<input type="hidden" 	name="detailDeductTexts" 		value="${item.deductText}" />
								<input type="hidden" 	name="detailPrevUtilHrss" 		value="${item.prevUtilHrs}" />
								<input type="hidden" 	name="detailEstUtilHrss" 		value="${item.estUtilHrs}" />
								<input type="hidden" 	name="detailTotalFlyTime" 		value="${item.totalFlyTime}" />
								<input type="hidden" 	name="detailqualifications" 	value="${item.qualification}" />
								<input type="hidden" 	name="detailGeogLimits" 		value="${item.geogLimit}" />
							    <input type="hidden" 	name="detailVesselCds" 			value="${item.vesselCd}" />
							    <input type="hidden" 	name="detailRecFlagAvs" 		value="${item.recFlagAv}" />
							</c:when>
							<c:when test="${lineCd == 'CA'}">
								<input type="hidden" 	name="detailLocations" 			    value="${item.location}" />
								<input type="hidden" 	name="detailLimitOfLiabilitys" 		value="${item.limitOfLiability}" />
								<input type="hidden" 	name="detailSectionLineCds" 		value="${item.sectionLineCd}" />
								<input type="hidden" 	name="detailSectionSublineCds" 		value="${item.sectionSublineCd}" />
								<input type="hidden" 	name="detailInterestOnPremisess" 	value="${item.interestOnPremises}" />
								<input type="hidden" 	name="detailSectionOrHazardInfos" 	value="${item.sectionOrHazardInfo}" />
								<input type="hidden" 	name="detailConveyanceInfos" 		value="${item.conveyanceInfo}" />
								<input type="hidden" 	name="detailPropertyNos" 			value="${item.propertyNo}" />
								<input type="hidden" 	name="detailLocationCds" 			value="${item.locationCd}" />
								<input type="hidden" 	name="detailSectionOrHazardCds" 	value="${item.sectionOrHazardCd}" />
								<input type="hidden" 	name="detailCapacityCds" 			value="${item.capacityCd}" />
								<input type="hidden" 	name="detailPropertyNoTypes" 		value="${item.propertyNoType}" />
							</c:when>

							<c:when test="${lineCd == 'MH'}">
								<input type="hidden" 	name="detailVesselCd" 			value="${item.vesselCd}" />
								<input type="hidden"	name="detailVesselName"			value="${item.vesselName}" />
								<input type="hidden" 	name="detailVesselOldName" 		value="${item.vesselOldName}" />
								<input type="hidden" 	name="detailVesTypeDesc" 		value="${item.vesTypeDesc}" />
								<input type="hidden" 	name="detailPropelSw" 			value="${item.propelSw}" />
								<input type="hidden" 	name="detailVessClassDesc" 		value="${item.vessClassDesc}" />
								<input type="hidden" 	name="detailHullDesc" 			value="${item.hullDesc}" />
								<input type="hidden" 	name="detailRegOwner" 			value="${item.regOwner}" />
								<input type="hidden" 	name="detailRegPlace" 			value="${item.regPlace}" />
								<input type="hidden" 	name="detailGrossTon" 			value="${item.grossTon}" />
								<input type="hidden" 	name="detailVesselLength" 		value="${item.vesselLength}" />
								<input type="hidden" 	name="detailYearBuilt" 			value="${item.yearBuilt}" />
								<input type="hidden" 	name="detailNetTon" 			value="${item.netTon}" />
								<input type="hidden" 	name="detailVesselBreadth" 		value="${item.vesselBreadth}" />
								<input type="hidden" 	name="detailNoCrew" 			value="${item.noCrew}" />
								<input type="hidden" 	name="detailDeadWeight" 		value="${item.deadWeight}" />
								<input type="hidden" 	name="detailVesselDepth" 		value="${item.vesselDepth}" />
								<input type="hidden" 	name="detailCrewNat" 			value="${item.crewNat}" />
								<input type="hidden" 	name="detaildryPlace" 			value="${item.dryPlace}" />
								<input type="hidden" 	name="detaildryDate" 			value="${item.dryDate}" />
								<input type="hidden" 	name="detailGeogLimit" 			value="${item.geogLimit}" />
								<input type="hidden"	name="detailDeductText"			value="${item.deductText }"/>
								<input type="hidden"	name="detailNoOfItemperils"		value="${item.noOfItemperils}"/>
							</c:when>

							<c:when test="${lineCd == 'AH'}">
								<input type="hidden" 	name="detailNoOfPersons" 			value="${item.noOfPersons}" />
								<input type="hidden" 	name="detailDestinations" 			value="${item.destination}" />
								<input type="hidden" 	name="detailMonthlySarys" 			value="${item.monthlySalary}" />
								<input type="hidden" 	name="detailSalaryGrades" 			value="${item.salaryGrade}" />
								<input type="hidden" 	name="detailPositionCds" 			value="${item.positionCd}" />
								<input type="hidden" 	name="detailDelGroupedItems" 		value="" />
								<input type="hidden" 	name="detailDateOfBirth" 			value="<fmt:formatDate value='${item.dateOfBirth}' pattern="MM-dd-yyyy" />" />
								<input type="hidden" 	name="detailAge" 					value="${item.age }" />
								<input type="hidden" 	name="detailCivilStatus" 			value="${item.civilStatus }" />
								<input type="hidden" 	name="detailSex" 					value="${item.sex }" />
								<input type="hidden" 	name="detailHeight" 				value="${item.height }" />
								<input type="hidden" 	name="detailWeight" 				value="${item.weight }" />
								<input type="hidden" 	name="detailGroupPrintSw" 			value="${item.groupPrintSw }" />
								<input type="hidden" 	name="detailAcClassCd" 				value="${item.acClassCd }" />
								<input type="hidden" 	name="detailLevelCd" 				value="${item.levelCd }" />
								<input type="hidden" 	name="detailParentLevelCd" 			value="${item.parentLevelCd }" />
								<input type="hidden" 	name="detailItemWitmperlExist"  	   value="${item.itemWitmperlExist }" />
								<input type="hidden" 	name="detailItemWitmperlGroupedExist"  value="${item.itemWitmperlGroupedExist }" />
								<input type="hidden"	name="detailPopulatePerils"			value="" />
								<input type="hidden"    name="detailItemWgroupedItemsExist"    value="${item.itemWgroupedItemsExist }" />
								<input type="hidden"	name="detailAccidentDeleteBill"		value="" />
							</c:when>

						</c:choose>
					
                        <label style="width: 5%; text-align: right; margin-right: 10px;">${fn:escapeXml(item.itemNo)}</label>
                        <label name="textItem" style="width: 20%; text-align: left;">${fn:escapeXml(item.itemTitle)}<c:if test="${empty item.itemTitle}">---</c:if></label>
                        <label name="textItem" style="width: 20%; text-align: left;">${fn:escapeXml(item.itemDesc)}<c:if test="${empty item.itemDesc}">---</c:if></label>
                        <label name="textItem" style="width: 20%; text-align: left;">${fn:escapeXml(item.itemDesc2)}<c:if test="${empty item.itemDesc2}">---</c:if></label>
                        <label name="textItem" style="width: 10%; text-align: left;">${fn:escapeXml(item.currencyDesc)}<c:if test="${empty item.currencyDesc}">---</c:if></label>
                        <label name="textItem" style="width: 10%; text-align: right; margin-right: 10px;"><fmt:formatNumber value='${item.currencyRt}' pattern='##0.000000000'/><c:if test="${empty item.currencyRt}">-</c:if></label>
                        <label name="textItem" style="text-align: left;">${fn:escapeXml(item.coverageDesc)}<c:if test="${empty item.coverageDesc}">---</c:if></label>
                    </div>
                </c:forEach>               
            </div>                    
        </div>       
    </div>
</div>

<script type="text/javascript">
    $$("label[name='textItem']").each(function (label)    {
        if ((label.innerHTML).length > 12)    {
            label.update((label.innerHTML).truncate(12, "..."));
        }
    });

   
	/*
    $$("div[name='row']").each(function (div)    {        
        if ((div.down("label", 1).innerHTML).length > 30)    {
            div.down("label", 1).update((div.down("label", 1).innerHTML).truncate(30, "..."));
        }
    });
    */
	var lineName ="";	

	if ($F("globalLineCd") == "MN"){
		lineName = "Marine Cargo - ";
	} else if ($F("globalLineCd") == "AV"){
		lineName = "Aviation - ";
	} else if ($F("globalLineCd") == "CA"){
		lineName = "Casualty - ";
	} else if ($F("globalLineCd") == "AH"){
		lineName = "Accident - ";
	} else if ($F("globalLineCd") == "FI"){
		lineName = "Fire - ";
	} else if ($F("globalLineCd") == "MC"){
		lineName = "Motor Car - ";
	} else if($F("globalLineCd") == "MH"){
		lineName = "Marine Hull - ";
	}							
    setDocumentTitle(lineName+"Endt Item Information");
</script>