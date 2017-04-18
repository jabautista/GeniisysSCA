    
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<div id="additionalInformationDiv" name="additionalInformationDiv" style="display: none;">
	<input type="hidden" id="aiItemNo" name="aiItemNo" value=""/>
	<div class="sectionDiv" id="additionalInformationSectionDiv" name="additionalInformationSectionDiv" style="overflow: visible; display:none;">
		<form id="marineHullAdditionalInformationForm" name="marineHullAdditionalInformationForm">
			<input type="hidden" id="quoteId" name="quoteId" value="${gipiQuote.quoteId}" />
			<input type="hidden" id="aiItemNo" name="aiItemNo" value="${aiItemNo}" />
			<table align="center" style="width: 80%; margin-top: 10px; margin-bottom: 10px;" cellpadding="0">
				<tr>
					<td class="rightAligned" style="width: 130px;">Vessel Name</td>
					<td class="leftAligned" colspan="3">
						<select id="vessel" name="vessel" style="width: 348px;" class="aiInput">
							<option value=""></option>
							<c:forEach var="m" items="${marineHulls}">
								<option value="${m.vesselCd}" vesselCd="${m.vesselCd}" dryPlace="${m.dryPlace}" dryDate="${m.dryDate}" vesselOldName="${m.vesselOldName}" vesTypeDesc="${m.vesTypeDesc}" vessClassCd="${m.vessClassCd}" vessClassDesc="${m.vessClassDesc}" propelSw="${m.propelSw}" hullTypeCd="${m.hullTypeCd}" hullDesc="${m.hullDesc}" grossTon="${m.grossTon}" yearBuilt="${m.yearBuilt}" regOwner="${m.regOwner}" regPlace="${m.regPlace}" noCrew="${m.noCrew}" netTon="${m.netTon}" deadWeight="${m.deadWeight}" crewNat="${m.crewNat}" vesselLength="${m.vesselLength}" vesselBreadth="${m.vesselBreadth}" vesselDepth="${m.vesselDepth}" endorsedTag="${m.endorsedTag}">
									${m.vesselName}
								</option>
							</c:forEach>
						</select>
						<div style="display: none;" id="marineHulls" name="marineHulls">
						</div>
					</td>
					<td class="rightAligned" style="width: 80px;">Old Name</td>
					<td class="leftAligned"><input type="text" id="vesselOldName" name="vesselOldName" style="width: 100px;" value="" maxlength="30" readonly="readonly" /></td>
				</tr>
				<tr>
					<td class="rightAligned">Vessel Type</td>
					<td class="leftAligned" colspan="3"><input type="text" id="vesselType" name="vesselType" style="width: 340px;" value="" maxlength="30" readonly="readonly" /></td>
					<td class="rightAligned">Propeller Type</td>
					<td class="leftAligned"><input type="text" id="propellerType" name="propellerType" style="width: 100px;" value="" maxlength="30" readonly="readonly" /></td>
				</tr>
				<tr>
					<td class="rightAligned">Vessel Class</td>
					<td class="leftAligned" colspan="3"><input type="text" id="vesselClass" name="vesselClass" style="width: 340px;" value="" maxlength="30" readonly="readonly" /></td>
					<td class="rightAligned">Hull Type</td>
					<td class="leftAligned"><input type="text" id="hullType" name="hullType" style="width: 100px;" value="" maxlength="30" readonly="readonly" /></td>
				</tr>
				<tr>
					<td class="rightAligned">Registered Owner</td>
					<td class="leftAligned" colspan="3"><input type="text" id="registeredOwner" name="registeredOwner" style="width: 340px;" value="" maxlength="30" readonly="readonly" /></td>
					<td class="rightAligned">Place</td>
					<td class="leftAligned"><input type="text" id="place" name="place" style="width: 100px;" value="" maxlength="30" readonly="readonly" /></td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 100px;">Gross Tonnage</td>
					<td class="leftAligned" style="width: 80px;"><input type="text" id="grossTonnage" name="grossTonnage" style="width: 100px;" value="" maxlength="30" readonly="readonly" /></td>
					<td class="rightAligned" style="width: 77px;">Vessel Length</td>
					<td class="leftAligned" style="width: 80px;"><input type="text" id="vesselLength" name="vesselLength" style="width: 100px;" value="" maxlength="30" readonly="readonly" /></td>
					<td class="rightAligned">Year Built</td>
					<td class="leftAligned" style="width: 80px;"><input type="text" id="yearBuilt" name="yearBuilt" style="width: 100px;" value="" maxlength="30" readonly="readonly" /></td>
				</tr>
				<tr>
					<td class="rightAligned">Net Tonnage</td>
					<td class="leftAligned"><input type="text" id="netTonnage" name="netTonnage" style="width: 100px;" value="" maxlength="30" readonly="readonly" /></td>
					<td class="rightAligned">Vessel Breadth</td>
					<td class="leftAligned"><input type="text" id="vesselBreadth" name="vesselBreadth" style="width: 100px;" value="" maxlength="30" readonly="readonly" /></td>
					<td class="rightAligned">No Of Crew</td>
					<td class="leftAligned"><input type="text" id="noOfCrew" name="noOfCrew" style="width: 100px;" value="" maxlength="30" readonly="readonly" /></td>
				</tr>
				<tr>
					<td class="rightAligned">Deadweight Tonnage</td>
					<td class="leftAligned"><input type="text" id="deadweightTonnage" name="deadweightTonnage" style="width: 100px;" value="" maxlength="30" readonly="readonly" /></td>
					<td class="rightAligned">Vessel Depth</td>
					<td class="leftAligned"><input type="text" id="vesselDepth" name="vesselDepth" style="width: 100px;" value="" maxlength="30" readonly="readonly" /></td>
					<td class="rightAligned">Nationality</td>
					<td class="leftAligned"><input type="text" id="nationality" name="nationality" style="width: 100px;" value="" maxlength="30" readonly="readonly" /></td>
				</tr>
				<tr>
					<td colspan="6"><div style="border-top: 1px solid #c0c0c0; margin: 10px 0;"></div></td>
				</tr>
				<tr>
					<td class="rightAligned">Drydock Place</td>
					<td class="leftAligned" colspan="3">
						<input type="text" id="drydockPlace" name="drydockPlace" style="width: 340px;" value="" maxlength="30" class="aiInput"/>
					</td>
					<td class="rightAligned">Drydock Date</td>
					<td class="leftAligned">
						<span style="width: 98px;">
							<input type="text" id="drydockDate" name="drydockDate" style="width: 78px;" value="" readonly="readonly" />
							<img id="imgDrydockDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="$('drydockDate').focus(); scwShow($('drydockDate'),this, null); " style="margin: 0;" class="aiInput"/>
						</span>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Geography Limit</td>
					<td class="leftAligned" colspan="5">
						<input type="text" id="geogLimit" name="geogLimit" style="width: 571px;" value="" maxlength="200" class="aiInput"/>
					</td>
				</tr>
			</table>
			<div style="margin-left: auto; margin-right: auto; margin-bottom: 20px;">
				<input type="button" id="aiMHUpdateBtn" name="aiMHUpdateBtn" value="Apply Changes" class="disabledButton"/>  <!-- edited by steven 11/7/2012 binago ko ung id niya kasi parehas siya sa ibang jsp na tinatawag dito kaya nag-eerror ung function --> 
			</div>
		</form>
	</div>
</div>
<script type="text/javascript">
//objGIPIQuoteItemList
	var currItemNo = $F("txtItemNo");;
	
	function setFormValues(){
		var drydockDate = $("vessel").options[$("vessel").selectedIndex].getAttribute("dryDate").replace("SGT","");
		if(drydockDate==""){
			$("drydockDate").value = "";
		} else {
			$("drydockDate").value = dateFormat(drydockDate, "mm-dd-yyyy");				
		}
		$("vesselType").value = $("vessel").options[$("vessel").selectedIndex].getAttribute("vesTypeDesc");
		$("vesselOldName").value = $("vessel").options[$("vessel").selectedIndex].getAttribute("vesselOldName");
		$("vesselClass").value =$("vessel").options[$("vessel").selectedIndex].getAttribute("vessClassDesc");
		$("registeredOwner").value = $("vessel").options[$("vessel").selectedIndex].getAttribute("regOwner");
		$("propellerType").value = $("vessel").options[$("vessel").selectedIndex].getAttribute("propelSw");
		$("hullType").value = $("vessel").options[$("vessel").selectedIndex].getAttribute("hullDesc");
		$("place").value = $("vessel").options[$("vessel").selectedIndex].getAttribute("regPlace");
		$("grossTonnage").value =$("vessel").options[$("vessel").selectedIndex].getAttribute("grossTon");
		$("vesselLength").value = $("vessel").options[$("vessel").selectedIndex].getAttribute("vesselLength");
		$("yearBuilt").value = $("vessel").options[$("vessel").selectedIndex].getAttribute("yearBuilt");
		$("netTonnage").value = $("vessel").options[$("vessel").selectedIndex].getAttribute("netTon");
		$("vesselBreadth").value = $("vessel").options[$("vessel").selectedIndex].getAttribute("vesselBreadth");
		$("noOfCrew").value = $("vessel").options[$("vessel").selectedIndex].getAttribute("noCrew");
		$("deadweightTonnage").value = $("vessel").options[$("vessel").selectedIndex].getAttribute("deadWeight");
		$("vesselDepth").value = $("vessel").options[$("vessel").selectedIndex].getAttribute("vesselDepth");
		$("nationality").value = $("vessel").options[$("vessel").selectedIndex].getAttribute("crewNat");
		$("drydockPlace").value = $("vessel").options[$("vessel").selectedIndex].getAttribute("dryPlace");
		//$("drydockDate").value = dateFormat($("vessel").options[$("vessel").selectedIndex].getAttribute("dryDate"),"mm-dd-yyyy");
		$("geogLimit").value = $("vessel").options[$("vessel").selectedIndex].getAttribute("geogLimit");
	}

	$("vessel").observe("change", function(){
		setFormValues();
	});
	
	//getMarineHulls();
	initializeAiType("aiMHUpdateBtn");
	
	$("aiMHUpdateBtn").observe("click", function(){
		fireEvent($("btnAddItem"), "click");
	});
</script>