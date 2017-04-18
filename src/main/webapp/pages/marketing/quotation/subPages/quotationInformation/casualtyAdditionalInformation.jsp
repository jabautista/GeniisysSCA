<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<div id="additionalInformationDiv" name="additionalInformationDiv" style="display: none;" class="optionalInformation">
	<div class="sectionDiv" id="additionalInformationSectionDiv" name="additionalInformationSectionDiv" style="overflow: visible; display: none;">
		<form id="casualtyAdditionalInformationForm" name="casualtyAdditionalInformationForm">
			<table align="center" style="width: 25%; margin-top: 10px; margin-bottom:10px;">
				<tr>
					<td class="rightAligned" style="width: 100px;">Location</td>
					<td class="leftAligned">
						<input type="text" id="txtLocation" name="txtLocation" style="width: 210px;" maxlength="150" value="${casualty.location}" class="aiInput"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Section/Hazard</td>
					<td class="leftAligned">
						<select id="selSectionOrHazard" name="selSectionOrHazard" style="width: 218px;" class="aiInput">
							<option value=""></option>
							<c:forEach var="h" items="${hazardLov}">
								<option value="${h.sectionOrHazardCd}"
								<c:if test="${casualty.sectionOrHazardCd eq h.sectionOrHazardCd}">
									selected="selected"
								</c:if>
								>${h.sectionOrHazardTitle}</option>
							</c:forEach>
						</select>
						<select id="selSectionLineCd" name="selSectionLineCd" style="display: none;">
							<option value=""></option>
<!--							<rEach var="h" items="${hazards}">-->
<!--								<option value="h.selSectionLineCd}">h.selSectionLineCd}</option>-->
<!--							</orEach>-->
						</select>
						<select id="selSectionSublineLineCd" name="selSectionSublineLineCd" style="display: none;">
							<option value=""></option>
							<!--<c:forEach var="h" items="${hazards}">
								<option value="${h.sectionSublineCd}">${h.sectionSublineCd}</option>
							</c:forEach>-->
						</select>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Capacity</td>
					<td class="leftAligned">
						<select id="selCapacity" name="selCapacity" style="width: 218px;" class="aiInput">
							<option value=""></option>
							<c:forEach var="c" items="${positionLov}">
								<option value="${c.positionCd}"
								<c:if test="${casualty.capacityCd eq c.positionCd}">
									selected="selected"
								</c:if>
								>${c.position}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Liability</td>
					<td class="leftAligned">
						<input type="text" style="width: 210px;" id="txtLimitOfLiability" name="txtLimitOfLiability" value="${casualty.limitOfLiability}" maxlength="500" class="aiInput"/>
					</td>
				</tr>
			</table>
			<div style="margin-left: auto; margin-right: auto; margin-bottom: 20px;">
				<input type="button" id="aiCAUpdateBtn" name="aiCAUpdateBtn" value="Apply Changes" class="disabledButton"/> <!-- edited by steven 11/7/2012 binago ko ung id niya kasi parehas siya sa ibang jsp na tinatawag dito kaya nag-eerror ung function --> 
			</div>
		</form>
	</div>
</div>
<script>
	initializeAll();
	/*$("selSectionOrHazard").observe("change", getSections);

	function getSections() {
		$("selSectionLineCd").selectedIndex = $("selSectionOrHazard").selectedIndex;
		$("selSectionSublineLineCd").selectedIndex = $("selSectionOrHazard").selectedIndex;
	}*/

	initializeAiType("aiCAUpdateBtn");
	initializeChangeAttribute();
	$("aiCAUpdateBtn").stopObserving("click");
	$("aiCAUpdateBtn").observe("click", function(){
		fireEvent($("btnAddItem"), "click");
		clearChangeAttribute("additionalInformationSectionDiv");
	});
	
	//getSections();
</script>