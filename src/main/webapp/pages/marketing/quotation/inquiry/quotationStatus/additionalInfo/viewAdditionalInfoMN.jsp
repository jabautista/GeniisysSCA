<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div id="additionalInformationDiv" name="additionalInformationDiv" style="display: none;">
	<div class="sectionDiv" id="additionalInformationSectionDiv" name="additionalInformationSectionDiv" style="overflow: visible;">
		<form id="marineCargoAdditionalInformationForm" name="marineCargoAdditionalInformationForm">
			<table id="additionalInformationTable" align="center" style="width: 80%; margin-top: 10px;">
				<tr>
					<td class="rightAligned" style="width: 150px;">Geography Description</td>
					<td class="leftAligned">
						<input type="text"style="float: left; margin-top: 0px; margin-right: 3px; width: 210px;" name="txtDspGeogDesc" id="txtDspGeogDesc" class="aiInput" value="" tabindex="301" readonly="readonly"/>
					</td>
					<td class="rightAligned" style="width: 80px;">Voyage No</td>
					<td class="leftAligned">
						<input type="text" id="txtVoyageNo" name="txtVoyageNo" style="width: 210px;"  maxlength="30" class="aiInput upper" tabindex="314" readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Carrier</td>
					<td class="leftAligned">
						<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 210px;" name="txtDspVesselName" id="txtDspVesselName" class="aiInput" value="" tabindex="303" readonly="readonly"/>						
					</td>
					<td class="rightAligned">LC No</td>
					<td class="leftAligned">
						<input type="text" id="txtLcNo" name="txtLcNo" style="width: 210px;" maxlength="30" class="aiInput upper" tabindex="315" readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Cargo Class</td>
					<td class="leftAligned" colspan="3">
							<input type="hidden" id="cargoClassCd" name="cargoClassCd" />
							<input type="text"  style="float: left; margin-top: 0px; margin-right: 3px; width: 544px;" name="cargoClass" id="cargoClass" class="aiInput" value="" tabindex="305" readonly="readonly"/>						
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Cargo Type</td>
					<td class="leftAligned">
							<input type="hidden" id="cargoType" name="cargoType" />
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 210px;"  name="cargoTypeDesc" id="cargoTypeDesc" readonly="readonly" class="aiInput" value="" tabindex="307"/>
					</td>
					<td class="rightAligned">Print?</td>
					<td class="leftAligned">
						<input type="hidden" id="txtPrintTag" name="txtPrintTag" />
						<input type="text"  style="float: left; margin-top: 0px; margin-right: 3px; width: 210px;"  name="txtDspPrintTagDesc" id="txtDspPrintTagDesc" readonly="readonly" class="aiInput" value="" tabindex="316"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">ETD</td>
					<td class="leftAligned">
						<input type="text" id="txtEtd" name="txtEtd" style="float: left; margin-top: 0px; margin-right: 3px; width: 210px;" readonly="readonly" tabindex="309"/>
					</td>
					<td class="rightAligned">ETA</td>
					<td class="leftAligned">
						<input type="text" id="txtEta" name="txtEta" style="float: left; margin-top: 0px; margin-right: 3px; width: 210px;" readonly="readonly" tabindex="318"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Type of Packing</td>
					<td class="leftAligned">
						<input type="text" id="txtPackMethod" name="txtPackMethod"  style="width: 210px;" maxlength="50" class="aiInput upper" tabindex="311" readonly="readonly"/>
					</td>
					<td class="rightAligned">BL/AWB</td>
					<td class="leftAligned">
						<input type="text" id="txtBlAwb" name="txtBlAwb"  style="width: 210px;" maxlength="30" class="aiInput upper" tabindex="320" readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Transhipment Origin</td>
					<td class="leftAligned">
						<input type="text" id="txtTranshipOrigin" name="txtTranshipOrigin" style="width: 210px;" maxlength="30" class="aiInput upper" tabindex="312" readonly="readonly"/>
					</td>
					<td class="rightAligned">Origin</td>
					<td class="leftAligned">
						<input type="text" id="txtOrigin" name="txtOrigin" style="width: 210px;" maxlength="50" class="aiInput upper" tabindex="321" readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Transhipment Destination</td>
					<td class="leftAligned">
						<input type="text" id="txtTranshipDestination" name="txtTranshipDestination" style="width: 210px;" maxlength="30" class="aiInput upper" tabindex="313" readonly="readonly"/>
					</td>
					<td class="rightAligned">Destination</td>
					<td class="leftAligned">
						<input type="text" id="txtDestn" name="txtDestn" style="width: 210px;" maxlength="50" class="aiInput upper" tabindex="322" readonly="readonly"/>
					</td>
				</tr>
			</table>
			<div class="buttonsDiv" style="margin-bottom: 5px;">
				<input type="hidden" id="txtVesselCd" name="txtVesselCd" />
				<input type="hidden" id="txtGeogCd" name="txtGeogCd" />
			</div>
		</form>
	</div>
</div>