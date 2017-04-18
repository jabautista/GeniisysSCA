<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
    
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<div id="additionalInformationDiv${aiItemNo}" name="additionalInformationDiv" style="">
	<input type="hidden" id="aiItemNo${aiItemNo}" name="aiItemNo${aiItemNo}" value="${aiItemNo}"/>
	<div class="sectionDiv" id="additionalInformationSectionDiv${aiItemNo}" name="additionalInformationSectionDiv" style="overflow: visible;">
		<form id="marineHullAdditionalInformationForm${aiItemNo}" name="marineHullAdditionalInformationForm">
			<input type="hidden" id="quoteId${aiItemNo}" name="quoteId" value="${gipiQuote.quoteId}" />
			<input type="hidden" id="aiItemNo${aiItemNo}" name="aiItemNo" value="${aiItemNo}" />
			<table align="center" style="width: 80%; margin-top: 10px; margin-bottom: 10px;" cellpadding="0">
				<tr>
					<td class="rightAligned" style="width: 130px;">Vessel Name</td>
					<td class="leftAligned" colspan="3">
						<select id="vesselCd${aiItemNo}" name="vesselCd" style="width: 348px;">
							<option value=""></option>
							<c:forEach var="m" items="${marineHulls}">
								<option value="${m.vesselCd}"
									<c:if test="${quoteItemMh.vesselCd eq m.vesselCd}">selected="selected"</c:if>
									>${m.vesselName}
								</option>
							</c:forEach>
						</select>
						<div style="display: none;" id="marineHulls" name="marineHulls">
						</div>
					</td>
					<td class="rightAligned" style="width: 80px;">Old Name</td>
					<td class="leftAligned"><input type="text" id="vesselOldName${aiItemNo}" name="vesselOldName" style="width: 100px;" value="${quoteItemMh.vesselOldName}" maxlength="30" readonly="readonly" /></td>
				</tr>
				<tr>
					<td class="rightAligned">Vessel Type</td>
					<td class="leftAligned" colspan="3"><input type="text" id="vesselType${aiItemNo}" name="vesselType" style="width: 340px;" value="${quoteItemMh.vesTypeCd}" maxlength="30" readonly="readonly" /></td>
					<td class="rightAligned">Propeller Type</td>
					<td class="leftAligned"><input type="text" id="propellerType${aiItemNo}" name="propellerType" style="width: 100px;" value="${quoteItemMh.propelSw}" maxlength="30" readonly="readonly" /></td>
				</tr>
				<tr>
					<td class="rightAligned">Vessel Class</td>
					<td class="leftAligned" colspan="3"><input type="text" id="vesselClass${aiItemNo}" name="vesselClass" style="width: 340px;" value="${quoteItemMh.vessClassCd}" maxlength="30" readonly="readonly" /></td>
					<td class="rightAligned">Hull Type</td>
					<td class="leftAligned"><input type="text" id="hullType${aiItemNo}" name="hullType" style="width: 100px;" value="${quoteItemMh.hullTypeCd}" maxlength="30" readonly="readonly" /></td>
				</tr>
				<tr>
					<td class="rightAligned">Registered Owner</td>
					<td class="leftAligned" colspan="3"><input type="text" id="registeredOwner${aiItemNo}" name="registeredOwner" style="width: 340px;" value="${quoteItemMh.regOwner}" maxlength="30" readonly="readonly" /></td>
					<td class="rightAligned">Place</td>
					<td class="leftAligned"><input type="text" id="place${aiItemNo}" name="place" style="width: 100px;" value="${quoteItemMh.regPlace}" maxlength="30" readonly="readonly" /></td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 100px;">Gross Tonnage</td>
					<td class="leftAligned" style="width: 80px;"><input type="text" id="grossTonnage${aiItemNo}" name="grossTonnage" style="width: 100px;" value="${grossTon}" maxlength="30" readonly="readonly" /></td>
					<td class="rightAligned" style="width: 77px;">Vessel Length</td>
					<td class="leftAligned" style="width: 80px;"><input type="text" id="vesselLength${aiItemNo}" name="vesselLength" style="width: 100px;" value="${quoteItemMh.vesselLength}" maxlength="30" readonly="readonly" /></td>
					<td class="rightAligned">Year Built</td>
					<td class="leftAligned" style="width: 80px;"><input type="text" id="yearBuilt${aiItemNo}" name="yearBuilt" style="width: 100px;" value="${quoteItemMh.yearBuilt}" maxlength="30" readonly="readonly" /></td>
				</tr>
				<tr>
					<td class="rightAligned">Net Tonnage</td>
					<td class="leftAligned"><input type="text" id="netTonnage${aiItemNo}" name="netTonnage" style="width: 100px;" value="${quoteItemMh.netTon}" maxlength="30" readonly="readonly" /></td>
					<td class="rightAligned">Vessel Breadth</td>
					<td class="leftAligned"><input type="text" id="vesselBreadth${aiItemNo}" name="vesselBreadth" style="width: 100px;" value="${quoteItemMh.vesselBreadth}" maxlength="30" readonly="readonly" /></td>
					<td class="rightAligned">No Of Crew</td>
					<td class="leftAligned"><input type="text" id="noOfCrew${aiItemNo}" name="noOfCrew" style="width: 100px;" value="${quoteItemMh.noCrew}" maxlength="30" readonly="readonly" /></td>
				</tr>
				<tr>
					<td class="rightAligned">Deadweight Tonnage</td>
					<td class="leftAligned"><input type="text" id="deadweightTonnage${aiItemNo}" name="deadweightTonnage" style="width: 100px;" value="${quoteItemMh.deadWeight}" maxlength="30" readonly="readonly" /></td>
					<td class="rightAligned">Vessel Depth</td>
					<td class="leftAligned"><input type="text" id="vesselDepth${aiItemNo}" name="vesselDepth" style="width: 100px;" value="${quoteItemMh.vesselDepth}" maxlength="30" readonly="readonly" /></td>
					<td class="rightAligned">Nationality</td>
					<td class="leftAligned"><input type="text" id="nationality${aiItemNo}" name="nationality" style="width: 100px;" value="${quoteItemMh.crewNat}" maxlength="30" readonly="readonly" /></td>
				</tr>
				<tr>
					<td colspan="6"><div style="border-top: 1px solid #c0c0c0; margin: 10px 0;"></div></td>
				</tr>
				<tr>
					<td class="rightAligned">Drydock Place</td>
					<td class="leftAligned" colspan="3"><input type="text" id="drydockPlace${aiItemNo}" name="drydockPlace" style="width: 340px;" value="${quoteItemMh.dryPlace}" maxlength="30" /></td>
					<td class="rightAligned">Drydock Date</td>
					<td class="leftAligned">
						<span style="width: 98px;">
							<input type="text" id="drydockDate${aiItemNo}" name="drydockDate" style="width: 78px;" value="<fmt:formatDate pattern="MM-dd-yyyy" value="${quoteItemMh.dryDate}" />" readonly="readonly" />
							<img id="imgDrydockDate${aiItemNo}" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="$('drydockDate${aiItemNo}').focus(); scwShow($('drydockDate${aiItemNo}'),this, null); " style="margin: 0;" />
						</span>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Geography Limit</td>
					<td class="leftAligned" colspan="5">
						<input type="text" id="geogLimit${aiItemNo}" name="geogLimit" style="width: 571px;" value="${quoteItemMh.geogLimit}" maxlength="200" />
					</td>
				</tr>
			</table>
		</form>
	</div>
</div>
<script type="text/javascript" defer="defer">

	marineVessels = "";
	
	function getMarHulls(){
		new Ajax.Request(contextPath+"/GIPIQuotationMarineHullController?action=getMarineHulls", {
				evalScripts: true,
				asynchronous: true,
				onCreate: function () {
					$("marineHullAdditionalInformationForm${aiItemNo}").disable();
					entryPass = false;
				}, 
				onComplete: function(response) {
					if (checkErrorOnResponse(response)) {
						$("marineHullAdditionalInformationForm${aiItemNo}").enable();
						marineVessels = (response.responseText).evalJSON();
						if(marineVessels == undefined){ // for testing
						}else{ // for testing
							$("vesselType${aiItemNo}").value = marineVessels.mHulls[($("vesselCd${aiItemNo}").selectedIndex)-1].vesTypeDesc;
						}
	
						$("vesselType${aiItemNo}").value = marineVessels.mHulls[($("vesselCd${aiItemNo}").selectedIndex)-1].vesTypeDesc;
					}
					enableQuotationMainButtons();
					showAccordionLabelsOnQuotationMain();
					entryPass = true;
				}
			});
		//}
	}
	
	try{
		if(++counter%2 != 0){	
			//var marineVessels = "";
			<%	System.out.println("MARINE HULL CODE SCRIPTLET RUNNING...");
			%>
			
			initializeAll();
	
			$("vesselCd${aiItemNo}").observe("change", function(){
				showMarineHullDefaults();
			});
	
			function showMarineHullDefaults() {
				$("vesselOldName${aiItemNo}").value		= marineVessels.mHulls[($("vesselCd${aiItemNo}").selectedIndex)-1].vesselOldName;
				$("vesselType${aiItemNo}").value		= marineVessels.mHulls[($("vesselCd${aiItemNo}").selectedIndex)-1].vesTypeDesc;
				$("propellerType${aiItemNo}").value 	= marineVessels.mHulls[($("vesselCd${aiItemNo}").selectedIndex)-1].propelSw;
				$("vesselClass${aiItemNo}").value		= changeSingleAndDoubleQuotes(marineVessels.mHulls[($("vesselCd${aiItemNo}").selectedIndex)-1].vessClassDesc);
				$("hullType${aiItemNo}").value			= marineVessels.mHulls[($("vesselCd${aiItemNo}").selectedIndex)-1].hullDesc;
				$("registeredOwner${aiItemNo}").value	= marineVessels.mHulls[($("vesselCd${aiItemNo}").selectedIndex)-1].regOwner;
				$("place${aiItemNo}").value				= marineVessels.mHulls[($("vesselCd${aiItemNo}").selectedIndex)-1].regPlace;
				$("grossTonnage${aiItemNo}").value		= marineVessels.mHulls[($("vesselCd${aiItemNo}").selectedIndex)-1].grossTon;
				$("vesselLength${aiItemNo}").value		= marineVessels.mHulls[($("vesselCd${aiItemNo}").selectedIndex)-1].vesselLength;
				$("yearBuilt${aiItemNo}").value			= marineVessels.mHulls[($("vesselCd${aiItemNo}").selectedIndex)-1].yearBuilt;
				$("netTonnage${aiItemNo}").value		= marineVessels.mHulls[($("vesselCd${aiItemNo}").selectedIndex)-1].netTon;
				$("vesselBreadth${aiItemNo}").value		= marineVessels.mHulls[($("vesselCd${aiItemNo}").selectedIndex)-1].vesselBreadth;
				$("noOfCrew${aiItemNo}").value			= marineVessels.mHulls[($("vesselCd${aiItemNo}").selectedIndex)-1].noCrew;
				$("deadweightTonnage${aiItemNo}").value = marineVessels.mHulls[($("vesselCd${aiItemNo}").selectedIndex)-1].deadWeight;
				$("vesselDepth${aiItemNo}").value		= marineVessels.mHulls[($("vesselCd${aiItemNo}").selectedIndex)-1].vesselDepth;
				$("nationality${aiItemNo}").value		= marineVessels.mHulls[($("vesselCd${aiItemNo}").selectedIndex)-1].crewNat;
				$("drydockPlace${aiItemNo}").value		= changeSingleAndDoubleQuotes(marineVessels.mHulls[($("vesselCd${aiItemNo}").selectedIndex)-1].dryPlace);
				$("geogLimit${aiItemNo}").value			= changeSingleAndDoubleQuotes(marineVessels.mHulls[($("vesselCd${aiItemNo}").selectedIndex)-1].geogLimit);
				var inceptionDate	= makeDate($F("inceptDate"));
				var expirationDate	= makeDate($F("expiryDate"));
				var dryDate			= marineVessels.mHulls[($("vesselCd${aiItemNo}").selectedIndex)-1].dryDate;
				
				if(inceptionDate < dryDate && dryDate < expirationDate){
					$("drydockDate${aiItemNo}").value	= dateFormat(marineVessels.mHulls[($("vesselCd${aiItemNo}").selectedIndex)-1].dryDate, "mm-dd-yyyy");
				}else{
				}		
	//			$("drydockDate${aiItemNo}").value	= dateFormat(marineVessels.mHulls[($("vesselCd${aiItemNo}").selectedIndex)-1].dryDate, "mm-dd-yyyy");
			}
	
	/*
			function getMarHulls(){
				if(entryPass){ // prevents this js from executing twice
					new Ajax.Request(contextPath+"/GIPIQuotationMarineHullController?action=getMarineHulls", {
						evalScripts: true,
						asynchronous: true,
						onCreate: function () {
							$("marineHullAdditionalInformationForm${aiItemNo}").disable();
							entryPass = false;
						}, 
						onComplete: function(response) {
							if (checkErrorOnResponse(response)) {
								$("marineHullAdditionalInformationForm${aiItemNo}").enable();
								marineVessels = (response.responseText).evalJSON();
								
								if(marineVessels == undefined){ // for testing
								}else{ // for testing
									$("vesselType${aiItemNo}").value = marineVessels.mHulls[($("vesselCd${aiItemNo}").selectedIndex)-1].vesTypeDesc;
								}
	
								$("vesselType${aiItemNo}").value = marineVessels.mHulls[($("vesselCd${aiItemNo}").selectedIndex)-1].vesTypeDesc;
							}
							enableQuotationMainButtons();
							showAccordionLabelsOnQuotationMain();
							entryPass = true;
						}
					});
				}
			}
	*/
			getMarHulls(); //*/
			
			$("drydockDate${aiItemNo}").observe("blur", function(){		validateDryDate(); });
			$("imgDrydockDate${aiItemNo}").observe("blur", function(){ 	validateDryDate(); });
			
			function validateDryDate(){
				var dryDate = makeDate($F("drydockDate${aiItemNo}"));
				var inceptDate = makeDate($F("inceptDate"));
				var expiryDate = makeDate($F("expiryDate"));
	
				if(dryDate < inceptDate){
					showMessageBox("Drydock Date must not be earlier than Inception Date.", imgMessage.ERROR);
					$("drydockDate${aiItemNo}").value = "";
				}else if(dryDate > expiryDate){
					showMessageBox("Drydock Date must not be later than Expiry Date.", imgMessage.ERROR);
					$("drydockDate${aiItemNo}").value = "";
				}
			}
	
			enableQuotationMainButtons();
			showAccordionLabelsOnQuotationMain();
		}else{
			//getMarHulls();
			getMarineHulls("${aiItemNo}");
		}
	}catch(e){
		showErrorMessage("marineHullAdditionalInformation.jsp", e);
		//showMessageBox("" + e.message, imgMessage.ERROR);
	}
</script>