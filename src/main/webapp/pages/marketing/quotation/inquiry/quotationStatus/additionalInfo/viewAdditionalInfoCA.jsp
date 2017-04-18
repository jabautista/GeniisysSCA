<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<div id="additionalInformationDiv" name="additionalInformationDiv" style="display: none;">
	<div class="sectionDiv" id="additionalInformationSectionDiv" name="additionalInformationSectionDiv" style="padding-bottom: 10px;">
		<form id="casualtyAdditionalInformationForm" name="casualtyAdditionalInformationForm" >
			<table align="center" style="width: 25%; margin-top: 10px;">
				<tr>
					<td class="rightAligned" style="width: 100px;">Location</td>
					<td class="leftAligned">
						<input type="text" id="txtLocation" name="txtLocation" style="width: 250px;" maxlength="150"  class="aiInput upper"  tabindex="301" readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Section/Hazard</td>
					<td class="leftAligned">
						<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 58px;" name="txtSectionOrHazardCd" id="txtSectionOrHazardCd" class="upper" maxlength="3"  tabindex="302" readonly="readonly"/>
						<div style="float: left; width: 181px;">
							<input id="txtSectionOrHazardTitle" class="leftAligned upper" type="text" name="txtSectionOrHazardTitle" style="float: left; margin-top: 0px; margin-right: 3px; border: solid 1px gray; height: 14px; width: 100%" value="" maxlength="2000" class="upper"  tabindex="304" readonly="readonly"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Capacity</td>
					<td class="leftAligned">
						<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 58px;" name="txtCapacityCd" id="txtCapacityCd"  class="integerNoNegativeUnformatted" maxlength="5" tabindex="305" readonly="readonly"/>	
						<div style="float: left; width: 181px;">
							<input id="txtPosition" class="leftAligned upper" type="text" name="txtPosition" style="float: left; margin-top: 0px; margin-right: 3px; border: solid 1px gray; height: 14px; width: 100%" value="" maxlength="40" class="upper" tabindex="307" readonly="readonly"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Liability</td>
					<td class="leftAligned">
						<input type="text" style="width: 250px;" id="txtLimitOfLiability" name="txtLimitOfLiability"  maxlength="500" class="aiInput upper" tabindex="308" readonly="readonly"/>
					</td>
				</tr>
			</table>
		</form>
	</div>
</div>