    
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<div id="additionalInformationDiv" name="additionalInformationDiv"style="display: none;">
	<div class="sectionDiv" id="additionalInformationSectionDiv" name="additionalInformationSectionDiv" style="overflow: visible;">
		<form id="marineHullAdditionalInformationForm" name="marineHullAdditionalInformationForm">
			<table align="center" style="width: 80%; margin-top: 10px;" cellpadding="0">
				<tr>
					<td class="rightAligned" style="width: 130px;">Vessel Name</td>
					<td class="leftAligned" colspan="3">
						<div style="float: left; border: solid 1px gray; width: 346px; height: 21px; margin-right: 3px;">
							<input type="hidden" id = "txtVesselCd" name = "txtVesselCd">
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 318px; border: none;" name="txtVesselName" id="txtVesselName" readonly="readonly" value="" class="aiInput" tabindex="301"/>
							<img id="hrefVesselName" alt="Go" style="height: 18px;" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" tabindex="302"/>
						</div>
					</td>
					<td class="rightAligned" style="width: 80px;">Old Name</td>
					<td class="leftAligned"><input type="text" id="txtVesselOldName" name="txtVesselOldName" style="width: 100px;" value="" maxlength="30" readonly="readonly" tabindex="312"/></td>
				</tr>
				<tr>
					<td class="rightAligned">Vessel Type</td>
					<td class="leftAligned" colspan="3"><input type="text" id="txtVestypeDesc" name="txtVestypeDesc" style="width: 340px;" value="" maxlength="30" readonly="readonly" tabindex="303"/></td>
					<td class="rightAligned">Propeller Type</td>
					<td class="leftAligned"><input type="text" id="txtPropelSw" name="txtPropelSw" style="width: 100px;" value="" maxlength="30" readonly="readonly" tabindex="313"/></td>
				</tr>
				<tr>
					<td class="rightAligned">Vessel Class</td>
					<td class="leftAligned" colspan="3"><input type="text" id="txtVessClassDesc" name="txtVessClassDesc" style="width: 340px;" value="" maxlength="30" readonly="readonly" tabindex="304"/></td>
					<td class="rightAligned">Hull Type</td>
					<td class="leftAligned"><input type="text" id="txtHullDesc" name="txtHullDesc" style="width: 100px;" value="" maxlength="30" readonly="readonly" tabindex="314"/></td>
				</tr>
				<tr>
					<td class="rightAligned">Registered Owner</td>
					<td class="leftAligned" colspan="3"><input type="text" id="txtRegOwner" name="txtRegOwner" style="width: 340px;" value="" maxlength="30" readonly="readonly" tabindex="305"/></td>
					<td class="rightAligned">Place</td>
					<td class="leftAligned"><input type="text" id="txtRegPlace" name="txtRegPlace" style="width: 100px;" value="" maxlength="30" readonly="readonly"tabindex="315" /></td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 100px;">Gross Tonnage</td>
					<td class="leftAligned" style="width: 80px;"><input type="text" id="txtGrossTon" name="txtGrossTon" style="width: 100px;" value="" maxlength="30" readonly="readonly" class="rightAligned" tabindex="306"/></td>
					<td class="rightAligned" style="width: 77px;">Vessel Length</td>
					<td class="leftAligned" style="width: 80px;"><input type="text" id="txtVesselLength" name="txtVesselLength" style="width: 100px;" value="" maxlength="30" readonly="readonly" class="rightAligned" tabindex="307"/></td>
					<td class="rightAligned">Year Built</td>
					<td class="leftAligned" style="width: 80px;"><input type="text" id="txtYearBuilt" name="txtYearBuilt" style="width: 100px;" value="" maxlength="30" readonly="readonly"class="rightAligned" tabindex="316"/></td>
				</tr>
				<tr>
					<td class="rightAligned">Net Tonnage</td>
					<td class="leftAligned"><input type="text" id="txtNetTon" name="txtNetTon" style="width: 100px;" value="" maxlength="30" readonly="readonly" class="rightAligned" tabindex="308"/></td>
					<td class="rightAligned">Vessel Breadth</td>
					<td class="leftAligned"><input type="text" id="txtVesselBreadth" name="txtVesselBreadth" style="width: 100px;" value="" maxlength="30" readonly="readonly" class="rightAligned" tabindex="309"/></td>
					<td class="rightAligned">No Of Crew</td>
					<td class="leftAligned"><input type="text" id="txtNoCrew" name="txtNoCrew" style="width: 100px;" value="" maxlength="30" readonly="readonly" class="rightAligned" tabindex="317"/></td>
				</tr>
				<tr>
					<td class="rightAligned">Deadweight Tonnage</td>
					<td class="leftAligned"><input type="text" id="txtDeadweight" name="txtDeadweight" style="width: 100px;" value="" maxlength="30" readonly="readonly" class="rightAligned" tabindex="310"/></td>
					<td class="rightAligned">Vessel Depth</td>
					<td class="leftAligned"><input type="text" id="txtVesselDepth" name="txtVesselDepth" style="width: 100px;" value="" maxlength="30" readonly="readonly" class="rightAligned" tabindex="311"/></td>
					<td class="rightAligned">Nationality</td>
					<td class="leftAligned"><input type="text" id="txtCrewNat" name="txtCrewNat" style="width: 100px;" value="" maxlength="30" readonly="readonly" tabindex="318"/></td>
				</tr>
				<tr>
					<td colspan="6"><div style="border-top: 1px solid #c0c0c0; margin: 10px 0;"></div></td>
				</tr>
				<tr>
					<td class="rightAligned">Drydock Place</td>
					<td class="leftAligned" colspan="3">
						<input type="text" id="txtDryPlace" name="txtDryPlace" style="width: 340px;" value="" maxlength="30" class="aiInput upper" tabindex="319"/>
					</td>
					<td class="rightAligned">Drydock Date</td>
					<td class="leftAligned">
						<div style="float: left; border: solid 1px gray; width: 106px; height: 20px; margin-right: 3px;">
							<input type="text" style="width: 82px; border: none; margin-top: 0px; float: left;" name="txtDryDate" id="txtDryDate" readonly="readonly" tabindex="320"/>					
			    			<img id="hrefDryDate" alt="Fire From Date" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtDryDate'),this, null);" tabindex="321"/>
			    		</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Geography Limit</td>
					<td class="leftAligned" colspan="5">
						<input type="text" id="txtGeogLimit" name="txtGeogLimit" style="width: 573px;" value="" maxlength="200" class="aiInput upper" tabindex="322"/>
					</td>
				</tr>
			</table>
			<div class="buttonsDiv" style="margin-bottom: 10px;">
				<input type="button" id="aiUpdateBtn" name="aiUpdateBtn" value="Apply Changes" class="disabledButton" tabindex="323"/>
			</div>
		</form>
	</div>
</div>
<script type="text/javascript">
	initializeAiType("aiUpdateBtn");
	initializeChangeAttribute();
	makeInputFieldUpperCase();
	
	$("hrefVesselName").observe("click", getMarineHullLOV);
	
	$("hrefVesselName").observe("keypress", function (event) {
		if (event.keyCode == 13){
			getMarineHullLOV();
		}
	});
	
	$("hrefDryDate").observe("keypress", function (event) {
		if (event.keyCode == 13){
			scwShow($('txtDryDate'),this, null);
		}
	});
	
	$("aiUpdateBtn").observe("click", function(){
		objQuote.addtlInfo = 'Y'; //robert 9.28.2012
		fireEvent($("btnAddItem"), "click");
		clearChangeAttribute("additionalInformationSectionDiv"); // added by: Nica 06.13.2012
		disableButton("aiUpdateBtn");
	});
</script>