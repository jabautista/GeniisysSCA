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
					<div style="float:left; border: solid 1px gray; width: 216px; height: 21px; margin-right:4px; " class="aiInput">
						<input type="text"style="float: left; margin-top: 0px; margin-right: 3px; width: 189px; border: none;" name="txtDspGeogDesc" id="txtDspGeogDesc" class="aiInput" value="" tabindex="301" />
						<img id="hrefGeogDesc" alt="goCargoClass" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" tabindex="302"/>
					</div>	
				</td>
				<td class="rightAligned" style="width: 80px;">Voyage No</td>
				<td class="leftAligned">
					<input type="text" id="txtVoyageNo" name="txtVoyageNo" style="width: 210px;"  maxlength="30" class="aiInput upper" tabindex="314"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Carrier</td>
				<td class="leftAligned">
					<div style="float:left; border: solid 1px gray; width: 216px; height: 21px; margin-right:4px; " class="aiInput">
						<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 189px; border: none;" name="txtDspVesselName" id="txtDspVesselName" class="aiInput" value="" tabindex="303" />
						<img id="hrefVesselDesc" alt="goCargoClass" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" tabindex="304"/>
					</div>	
				</td>
				<td class="rightAligned">LC No</td>
				<td class="leftAligned">
					<input type="text" id="txtLcNo" name="txtLcNo" style="width: 210px;" maxlength="30" class="aiInput upper" tabindex="315"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Cargo Class</td>
				<td class="leftAligned" colspan="3">
					<div style="float:left; border: solid 1px gray; width: 550px; height: 21px; margin-right:4px; " class="aiInput">
						<input type="hidden" id="cargoClassCd" name="cargoClassCd" />
						<input type="text"  style="float: left; margin-top: 0px; margin-right: 3px; width: 523px; border: none;" name="cargoClass" id="cargoClass" class="aiInput" value="" tabindex="305" />
						<img id="hrefCargoClass" alt="goCargoClass" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" tabindex="306"/>
					</div>	
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Cargo Type</td>
				<td class="leftAligned">
					<div style="float:left; border: solid 1px gray; width: 216px; height: 21px; margin-right:4px;" class="aiInput">
						<input type="hidden" id="cargoType" name="cargoType" />
						<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 189px; border: none;"  name="cargoTypeDesc" id="cargoTypeDesc" readonly="readonly" class="aiInput" value="" tabindex="307"/>
						<img id="hrefCargoType" alt="goCargoType" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" tabindex="308"/>
					</div>		
				</td>
				<td class="rightAligned">Print?</td>
				<td class="leftAligned">
					<div style="float:left; border: solid 1px gray; width: 216px; height: 21px; margin-right:4px;" class="aiInput">
						<input type="hidden" id="txtPrintTag" name="txtPrintTag" />
						<input type="text"  style="float: left; margin-top: 0px; margin-right: 3px; width: 189px; border: none;"  name="txtDspPrintTagDesc" id="txtDspPrintTagDesc" readonly="readonly" class="aiInput" value="" tabindex="316"/>
						<img id="hrefPrintTag" alt="goCargoType" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" tabindex="317"/>
					</div>	
				</td>
			</tr>
			<tr>
				<td class="rightAligned">ETD</td>
				<td class="leftAligned">
					<div style="float:left; border: solid 1px gray; width: 216px; height: 21px; margin-right:4px;" class="aiInput">
						<input type="text" id="txtEtd" name="txtEtd" style="float: left; margin-top: 0px; margin-right: 3px; width: 189px; border: none;"  readonly="readonly" tabindex="309"/>
						<img id="imgEtd" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtEtd'),this, null);" style="margin: 0;" alt="Go" class="hover" tabindex="310"/>
					</div>
				</td>
				<td class="rightAligned">ETA</td>
				<td class="leftAligned">
					<div style="float:left; border: solid 1px gray; width: 216px; height: 21px; margin-right:4px;" class="aiInput">
						<input type="text" id="txtEta" name="txtEta" style="float: left; margin-top: 0px; margin-right: 3px; width: 189px; border: none;"  readonly="readonly" tabindex="318"/>
						<img id="imgEta" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtEta'),this, null);" style="margin: 0;" alt="Go" class="hover" tabindex="319"/>
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Type of Packing</td>
				<td class="leftAligned">
					<input type="text" id="txtPackMethod" name="txtPackMethod"  style="width: 210px;" maxlength="50" class="aiInput upper" tabindex="311"/>
				</td>
				<td class="rightAligned">BL/AWB</td>
				<td class="leftAligned">
					<input type="text" id="txtBlAwb" name="txtBlAwb"  style="width: 210px;" maxlength="30" class="aiInput upper" tabindex="320"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Transhipment Origin</td>
				<td class="leftAligned">
					<input type="text" id="txtTranshipOrigin" name="txtTranshipOrigin" style="width: 210px;" maxlength="30" class="aiInput upper" tabindex="312"/>
				</td>
				<td class="rightAligned">Origin</td>
				<td class="leftAligned">
					<input type="text" id="txtOrigin" name="txtOrigin" style="width: 210px;" maxlength="50" class="aiInput upper" tabindex="321"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Transhipment Destination</td>
				<td class="leftAligned">
					<input type="text" id="txtTranshipDestination" name="txtTranshipDestination" style="width: 210px;" maxlength="30" class="aiInput upper" tabindex="313"/>
				</td>
				<td class="rightAligned">Destination</td>
				<td class="leftAligned">
					<input type="text" id="txtDestn" name="txtDestn" style="width: 210px;" maxlength="50" class="aiInput upper" tabindex="322"/>
				</td>
			</tr>
		</table>
		<div class="buttonsDiv" style="margin-bottom: 10px;">
			<input type="button" id="aiUpdateBtn" name="aiUpdateBtn" value="Apply Changes" class="disabledButton" tabindex="323"/>
			<input type="hidden" id="txtVesselCd" name="txtVesselCd" />
			<input type="hidden" id="txtGeogCd" name="txtGeogCd" />
		</div>
	</form>
</div>
</div>
<script>
	initializeAll();
	
	$("hrefCargoClass").observe("click", showCargoClassLOV);
	$("hrefCargoType").observe("click", function(){	showCargoTypeLOV($F("cargoClassCd"));	});
	$("hrefGeogDesc").observe("click", showGeogDescLOV);
	$("hrefVesselDesc").observe("click", showVesselDescLOV);
	$("hrefPrintTag").observe("click", showPrintTagLOV);
	
	$("hrefCargoClass").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showCargoClassLOV();
		}
	});
	
	$("hrefCargoType").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showCargoTypeLOV($F("cargoClassCd"));	
		}
	});
	
	$("hrefGeogDesc").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showGeogDescLOV();
		}
	});
	
	$("hrefVesselDesc").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showVesselDescLOV();
		}
	});
	
	$("hrefPrintTag").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showPrintTagLOV();
		}
	});
	
	$("imgEta").observe("keypress", function (event) {
		if (event.keyCode == 13){
			scwShow($('txtEta'),this, null);
		}
	});
	
	$("imgEtd").observe("keypress", function (event) {
		if (event.keyCode == 13){
			scwShow($('txtEtd'),this, null);
		}
	});
	
	$("txtEta").observe("blur", function(){
		if($F("txtEtd") != "" && $F("txtEta") != ""){
			var etd = makeDate($F("txtEtd"));
			var eta = makeDate($F("txtEta"));
			if (etd > eta) {
				function clearDates(){
					$("txtEta").clear();
					$("txtEtd").clear();
					$("txtEtd").focus();
				}
				showConfirmBox("Re-enter the dates", "ETD must be earlier than ETA, kindly re-enter the dates", "OK", "Cancel", clearDates, clearDates, 1);
			}
		}
	});
	
	makeInputFieldUpperCase();
	initializeAiType("aiUpdateBtn");
	initializeChangeAttribute();
	initializeAiType("aiUpdateBtn");
	$("aiUpdateBtn").observe("click", function(){
		objQuote.addtlInfo = 'Y'; //robert 9.28.2012
		fireEvent($("btnAddItem"), "click");
		clearChangeAttribute("additionalInformationSectionDiv");
		disableButton("aiUpdateBtn");
	});

</script>