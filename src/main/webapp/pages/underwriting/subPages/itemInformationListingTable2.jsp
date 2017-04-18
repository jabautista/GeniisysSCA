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
        <div style="width: 100%; " id="itemTable" name="itemTable">
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
                    <div id="row${item.itemNo}" name="rowItem" class="tableRow" style="padding-left:1px;" item="${item.itemNo}"/> <!-- style="height: 20px; border-bottom: 1px solid #E0E0E0; padding-top: 10px;"> -->
                    	<input type="hidden" id="masterParId${item.itemNo}" 			name="masterParIds" 			value="${item.parId}" cnt=0/>
						<input type="hidden" id="masterItemNo${item.itemNo}" 			name="masterItemNos" 			value="${item.itemNo}" cnt=1/>
						<input type="hidden" id="masterItemTitle${item.itemNo}" 		name="masterItemTitles" 		value="${fn:escapeXml(item.itemTitle)}" cnt=2/>
						<input type="hidden" id="masterItemGrp${item.itemNo}" 			name="masterItemGrps" 			value="${item.itemGrp}" cnt=3/>
						<input type="hidden" id="masterItemDesc${item.itemNo}" 			name="masterItemDescs" 			value="${fn:escapeXml(item.itemDesc)}"  cnt=4/>
						<input type="hidden" id="masterItemDesc2${item.itemNo}" 		name="masterItemDesc2s" 		value="${fn:escapeXml(item.itemDesc2)}" cnt=5/>
						<input type="hidden" id="masterTsiAmt${item.itemNo}" 			name="masterTsiAmts" 			value="${item.tsiAmt}"  cnt=6/>
						<input type="hidden" id="masterPremAmt${item.itemNo}"    		name="masterPremAmts" 			value="${item.premAmt}"  cnt=7/>
						<input type="hidden" id="masterAnnPremAmt${item.itemNo}" 		name="masterAnnPremAmts" 		value="${item.annPremAmt}" cnt=8/>
						<input type="hidden" id="masterAnnTsiAmt${item.itemNo}" 		name="masterAnnTsiAmts" 		value="${item.annTsiAmt}" cnt=9/>
						<input type="hidden" id="masterRecFlag${item.itemNo}" 			name="masterRecFlags" 			value="${item.recFlag}"  cnt=10/>
						<input type="hidden" id="masterCurrencyCd${item.itemNo}" 		name="masterCurrencyCds" 		value="${item.currencyCd}" cnt=11/>
						<input type="hidden" id="masterCurrencyRt${item.itemNo}" 		name="masterCurrencyRts" 		value="${item.currencyRt}"  cnt=12/>
						<input type="hidden" id="masterGroupCd${item.itemNo}" 			name="masterGroupCds" 			value="${item.groupCd}" cnt=13/>
						<input type="hidden" id="masterFromDate${item.itemNo}" 			name="masterFromDates" 		cnt=14	value='<fmt:formatDate value='${item.fromDate}' pattern="MM-dd-yyyy" />' />
						<input type="hidden" id="masterToDate${item.itemNo}" 			name="masterToDates" 		cnt=15	value='<fmt:formatDate value='${item.toDate}' pattern="MM-dd-yyyy" />' />
						<input type="hidden" id="masterPackLineCd${item.itemNo}" 		name="masterPackLineCds" 	cnt=16	value="${item.packLineCd}" />
						<input type="hidden" id="masterPackSublineCd${item.itemNo}" 	name="masterPackSublineCds"  cnt=17 	value="${item.packSublineCd}" />
						<input type="hidden" id="masterDiscountSw${item.itemNo}" 		name="masterDiscountSws" 	cnt=18	value="${item.discountSw}" />
						<input type="hidden" id="masterCoverageCd${item.itemNo}" 		name="masterCoverageCds" 	cnt=19	value="${item.coverageCd}" />
						<input type="hidden" id="masterOtherInfo${item.itemNo}" 		name="masterOtherInfos" 	cnt=20	value="${fn:escapeXml(item.otherInfo)}" />
						<input type="hidden" id="masterSurchargeSw${item.itemNo}" 		name="masterSurchargeSws" 	cnt=21	value="${item.surchargeSw}" />
						<input type="hidden" id="masterRegionCd${item.itemNo}" 			name="masterRegionCds" 		cnt=22	value="${item.regionCd}" />
						<input type="hidden" id="masterChangedTag${item.itemNo}" 		name="masterChangedTags" 	cnt=23	value="${item.changedTag}" />
						<input type="hidden" id="masterProrateFlag${item.itemNo}" 		name="masterProrateFlags" 	cnt=24	value="${item.prorateFlag}" />
						<input type="hidden" id="masterCompSw${item.itemNo}" 			name="masterCompSws" 		cnt=25	value="${item.compSw}" />
						<input type="hidden" id="masterShortRtPercent${item.itemNo}" 	name="masterShortRtPercents"   cnt=26 	value="${item.shortRtPercent}" />
						<input type="hidden" id="masterPackBenCd${item.itemNo}" 		name="masterPackBenCds" 	cnt=27	value="${item.packBenCd}" />
						<input type="hidden" id="masterPaytTerms${item.itemNo}" 		name="masterPaytTermss" 	cnt=28	value="${item.paytTerms}" />
						<input type="hidden" id="masterRiskNo${item.itemNo}" 			name="masterRiskNos" 		cnt=29	value="${item.riskNo}" />
						<input type="hidden" id="masterRiskItemNo${item.itemNo}" 		name="masterRiskItemNos" 	cnt=30	value="${item.riskItemNo}" />             
                       
						<c:choose>
							<c:when test="${lineCd == 'MC'}">
								<input type="hidden"    id="detailAssignees${item.itemNo}"			name="detailAssignees"			value="${fn:escapeXml(item.assignee)}" />
								<input type="hidden"    id="detailAcquiredFroms${item.itemNo}"		name="detailAcquiredFroms"		value="${fn:escapeXml(item.acquiredFrom)}" />
								<input type="hidden"    id="detailMotorNos${item.itemNo}"			name="detailMotorNos"			value="${fn:escapeXml(item.motorNo)}" />
								<input type="hidden"    id="detailOrigins${item.itemNo}"			name="detailOrigins"			value="${fn:escapeXml(item.origin)}" />
								<input type="hidden"    id="detailDestinations${item.itemNo}"       name="detailDestinations"       value="${fn:escapeXml(item.destination)}" />
								<input type="hidden"    id="detailTypeOfBodyCds${item.itemNo}"		name="detailTypeOfBodyCds"		value="${item.typeOfBodyCd}" />
								<input type="hidden"    id="detailPlateNos${item.itemNo}"			name="detailPlateNos"			value="${fn:escapeXml(item.plateNo)}" />
								<input type="hidden"    id="detailModelYears${item.itemNo}"			name="detailModelYears"			value="${item.modelYear}" />
								<input type="hidden"    id="detailCarCompanyCds${item.itemNo}"		name="detailCarCompanyCds"		value="${item.carCompanyCd}" />
								<input type="hidden"    id="detailMVFileNos${item.itemNo}"			name="detailMVFileNos"			value="${fn:escapeXml(item.mvFileNo)}" />
								<input type="hidden"    id="detailNoOfPasss${item.itemNo}"			name="detailNoOfPasss"			value="${item.noOfPass}" />
								<input type="hidden"    id="detailMakeCds${item.itemNo}"			name="detailMakeCds"			value="${item.makeCd}" />
								<input type="hidden"    id="detailBasicColorCds${item.itemNo}"		name="detailBasicColorCds"		value="${item.basicColorCd}" />
								<input type="hidden"    id="detailColors${item.itemNo}"				name="detailColors"				value="${fn:escapeXml(item.color)}" />
								<input type="hidden"    id="detailColorCds${item.itemNo}"			name="detailColorCds"			value="${item.colorCd}" />
								<input type="hidden"    id="detailEngineSeriess${item.itemNo}"		name="detailEngineSeriess"		value="${item.seriesCd}" />
								<input type="hidden"    id="detailMotorTypes${item.itemNo}"			name="detailMotorTypes"			value="${item.motType}" />
								<input type="hidden"    id="detailUnladenWts${item.itemNo}"			name="detailUnladenWts"			value="${fn:escapeXml(item.unladenWt)}" />
								<input type="hidden"    id="detailTowings${item.itemNo}"			name="detailTowings"			value="${item.towing}" />
								<input type="hidden"    id="detailSerialNos${item.itemNo}"			name="detailSerialNos"			value="${fn:escapeXml(item.serialNo)}" />
								<input type="hidden"    id="detailSublineTypeCds${item.itemNo}"		name="detailSublineTypeCds"		value="${item.sublineTypeCd}" />
								<input type="hidden"    id="detailDeductibleAmounts${item.itemNo}"	name="detailDeductibleAmounts"	value="${item.deductibleAmount}" />
								<input type="hidden"    id="detailCOCTypes${item.itemNo}"			name="detailCOCTypes"			value="${item.cocType}" />
								<input type="hidden"    id="detailCOCSerialNos${item.itemNo}"		name="detailCOCSerialNos"		value="${item.cocSerialNo}" />
								<input type="hidden"    id="detailCOCYys${item.itemNo}"				name="detailCOCYys"				value="${item.cocYY}" />
								<input type="hidden"    id="detailCTVs${item.itemNo}"				name="detailCTVs"				value="${item.ctvTag}" />
								<input type="hidden"    id="detailRepairLimits${item.itemNo}"		name="detailRepairLimits"		value="${item.repairLim}" />
								<input type="hidden"	id="detailMotorCoverages${item.itemNo}"		name="detailMotorCoverages"		value="${item.motorCoverage}" />
								<input type="hidden"	id="detailSublineCds${item.itemNo}"			name="detailSublineCds"			value="${item.sublineCd}" />
								<input type="hidden"	id="detailCOCSerialSws${item.itemNo}"		name="detailCOCSerialSws"		value="${item.cocSerialSw}" />
								<input type="hidden"	id="detailEstValues${item.itemNo}"			name="detailEstValues"			value="${item.estValue}" />
								<input type="hidden"	id="detailTariffZones${item.itemNo}"		name="detailTariffZones"		value="${item.tariffZone}" />
								<input type="hidden"	id="detailCOCIssueDates${item.itemNo}"		name="detailCOCIssueDates"		value="${item.cocIssueDate}" />
								<input type="hidden"	id="detailCOCSeqNos${item.itemNo}"			name="detailCOCSeqNos"			value="${item.cocSeqNo}" />
								<input type="hidden"	id="detailCOCAtcns${item.itemNo}"			name="detailCOCAtcns"			value="${item.cocAtcn}" />
								<input type="hidden"	id="detailMakes${item.itemNo}"				name="detailMakes"				value="${item.make}" />
								<input type="hidden"	id="detailItemNos${item.itemNo}"			name="detailItemNos"			value="${item.itemNo}" />
							</c:when>
							<c:when test="${lineCd == 'FI'}">
								<!-- <input type="hidden"	name="detailRiskNo"					value="${item.riskNo}" /> -->
								<!-- <input type="hidden"	name="detailRiskItemNo"				value="${item.riskItemNo}" /> -->
								<input type="hidden" 	id="detailEQZones${item.itemNo}"    			name="detailEQZones"				value="${item.eqZone}" />
								<input type="hidden"	id="detailFromDates${item.itemNo}"				name="detailFromDates"				value='<fmt:formatDate value='${item.fromDate}' pattern="MM-dd-yyyy" />' />
								<input type="hidden" 	id="detailAssignees${item.itemNo}" 				name="detailAssignees"				value="${fn:escapeXml(item.assignee)}" />
								<input type="hidden" 	id="detailTyphoonZones${item.itemNo}" 			name="detailTyphoonZones" 			value="${item.typhoonZone}" />
								<input type="hidden"	id="detailToDates${item.itemNo}"				name="detailToDates"				value='<fmt:formatDate value='${item.toDate}' pattern="MM-dd-yyyy" />' />
								<input type="hidden" 	id="detailFRItemTypes${item.itemNo}" 			name="detailFRItemTypes"			value="${item.frItemType}" />
								<input type="hidden" 	id="detailFloodZones${item.itemNo}" 			name="detailFloodZones"				value="${item.floodZone}" />
								<input type="hidden" 	id="detailLocRisk1s${item.itemNo}" 				name="detailLocRisk1s"				value="${fn:escapeXml(item.locRisk1)}" />
								<input type="hidden"	id="detailRegionCds${item.itemNo}"				name="detailRegionCds"				value="${item.regionCd}">
								<input type="hidden" 	id="detailTariffZones${item.itemNo}" 			name="detailTariffZones" 				value="${item.tariffZone}" />
								<input type="hidden" 	id="detailLocRisk2s${item.itemNo}" 				name="detailLocRisk2s" 				value="${fn:escapeXml(item.locRisk2)}" />
								<input type="hidden" 	id="detailProvinceCds${item.itemNo}" 			name="detailProvinceCds"			value="${item.provinceCd}" />								
								<input type="hidden" 	id="detailTarfCds${item.itemNo}" 				name="detailTarfCds" 				value="${item.tarfCd}" />
								<input type="hidden" 	id="detailLocRisk3s${item.itemNo}" 				name="detailLocRisk3s" 				value="${fn:escapeXml(item.locRisk3)}" />
								<input type="hidden" 	id="detailCitys${item.itemNo}" 					name="detailCitys"					value="${item.city}" />
								<input type="hidden" 	id="detailConstructionCds${item.itemNo}" 		name="detailConstructionCds"		value="${item.constructionCd}" />
								<input type="hidden" 	id="detailFronts${item.itemNo}" 				name="detailFronts"					value="${fn:escapeXml(item.front)}" />								
								<input type="hidden" 	id="detailDistrictNos${item.itemNo}" 			name="detailDistrictNos"			value="${item.districtNo}" />
								<input type="hidden" 	id="detailConstructionRemarkss${item.itemNo}" 	name="detailConstructionRemarkss"	value="${fn:escapeXml(item.constructionRemarks)}" />
								<input type="hidden" 	id="detailRights${item.itemNo}" 				name="detailRights"					value="${fn:escapeXml(item.right)}" />								
								<input type="hidden" 	id="detailBlockNos${item.itemNo}" 				name="detailBlockNos" 				value="${item.blockNo}" />								
								<input type="hidden" 	id="detailOccupancyCds${item.itemNo}" 			name="detailOccupancyCds"			value="${item.occupancyCd}" />
								<input type="hidden" 	id="detailLefts${item.itemNo}" 					name="detailLefts"					value="${fn:escapeXml(item.left)}" />
								<input type="hidden" 	id="detailRiskCds${item.itemNo}" 				name="detailRiskCds"				value="${item.riskCd}" />
								<input type="hidden" 	id="detailOccupancyRemarkss${item.itemNo}" 		name="detailOccupancyRemarkss"		value="${fn:escapeXml(item.occupancyRemarks)}" />								
								<input type="hidden" 	id="detailRears${item.itemNo}" 					name="detailRears" 					value="${fn:escapeXml(item.rear)}" />								
								<input type="hidden" 	id="detailBlockIds${item.itemNo}" 				name="detailBlockIds" 				value="${item.blockId}" />
								<input type="hidden"	id="detailProvinceDescs${item.itemNo}"			name="detailProvinceDescs"			value="${item.provinceDesc}" />								
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
						
                        <label style="width: 5%; text-align: right; margin-right: 10px;" labelName="itemNo">${fn:escapeXml(item.itemNo)}<!--<fmt:formatNumber value='${item.itemNo}' pattern='000' />--></label>
                        <label name="textItem" style="width: 20%; text-align: left;">${fn:escapeXml(item.itemTitle)}<c:if test="${empty item.itemTitle}">---</c:if></label>
                        <label name="textItem" style="width: 20%; text-align: left;">${fn:escapeXml(item.itemDesc)}<c:if test="${empty item.itemDesc}">---</c:if></label>
                        <label name="textItem" style="width: 20%; text-align: left;">${fn:escapeXml(item.itemDesc2)}<c:if test="${empty item.itemDesc2}">---</c:if></label>
                        <label name="textItem2" style="width: 10%; text-align: left;">${fn:escapeXml(item.currencyDesc)}<c:if test="${empty item.currencyDesc}">---</c:if></label>
                        <label name="textRate" style="width: 10%; text-align: right; margin-right: 10px;"><fmt:formatNumber value='${item.currencyRt}' pattern='##0.000000000'/><c:if test="${empty item.currencyRt}">---</c:if></label>
                        <label name="textItem" style="text-align: left;">${fn:escapeXml(item.coverageDesc)}<c:if test="${empty item.coverageDesc}">---</c:if></label>
                        <input type="hidden" id="discDeleted${item.itemNo}" 		name="discDeleted"  	 		value="N"/>
                       	<input type="hidden" id="itmperlGroupedExists${item.itemNo}" name="itmperlGroupedExists"  	value="${item.itmperlGroupedExists}"/>
                    </div>
                </c:forEach>               
            </div>                    
        </div>       
    </div>
</div>

<script type="text/javascript">

	$$("label[name='']").each(function (label) {
		if ((label.innerHTML).length > 4) {
			label.update((label.innerHTML).truncate(4, "..."));
		}
	});  

    $$("label[name='textItem']").each(function (label)    {
        if ((label.innerHTML).length > 15)    {
            label.update((label.innerHTML).truncate(15, "..."));
        }
    });
    $$("label[name='textItem2']").each(function (label)    {
        if ((label.innerHTML).length > 10)    {
            label.update((label.innerHTML).truncate(10, "..."));
        }
    });
    $$("label[name='textRate']").each(function (label)    {
        if ((label.innerHTML).length > 10)    {
            label.update((label.innerHTML).truncate(10, "..."));
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
	} else if ($F("globalLineCd") == "EN"){
		lineName = "Engineering - ";
	}							
    setDocumentTitle(lineName+"Item Information");
    
</script>