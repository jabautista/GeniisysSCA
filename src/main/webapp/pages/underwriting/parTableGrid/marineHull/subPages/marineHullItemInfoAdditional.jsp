<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<jsp:include page="/pages/underwriting/subPages/additionalItemInfoHeader.jsp"></jsp:include>
<div id="additionalItemInformationDiv" name="additionalItemInformationDiv">
	<div class="sectionDiv" id="additionalItemInformation" style="margin: 0px;">
		<table id="marineHullMainTableForm" name="marineHullMainTableForm" width="920px" border="0" cellspacing="1" style="margin-bottom: 5px;">
			<tr><td colspan="6"><br /></td></tr>
			<tr>
				<td class="rightAligned">Vessel Name </td>
				<td class="leftAligned" colspan="3">
					<div style="float: left; border: solid 1px gray; width: 462px; height: 21px; margin-right: 3px;" class="required">						
						<input type="hidden" id="vesselCd" name="vesselCd" />
						<input type="text" tabindex="2001" style="float: left; margin-top: 0px; margin-right: 3px;width: 433px; border: none;" name="vesselName" id="vesselName" readonly="readonly" class="required" />
						<img id="hrefVessel" alt="goVessel" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />												
					</div>					
				</td>
				<td class="rightAligned"> Old Name </td>
				<td class="leftAligned">
					<input type="text" tabindex="2002" id="vesselOldName" name="vesselOldName" style="width: 170px; padding: 2px;" readonly="readonly" />
				</td> 
			</tr>
			<tr>
				<td class="rightAligned">Vessel Type </td>
				<td class="leftAligned" colspan="3">
					<input type="text" tabindex="2003" id="vesTypeDesc" name="vesTypeDesc" type="text" style="width: 458px; padding: 2px;" maxlength="150" readonly="readonly"/>
				</td>
				<td class="rightAligned">Propeller Type </td>
				<td class="leftAligned">
					<input type="text" tabindex="2004" id="propelSw" name="propelSw" style="width: 170px; padding: 2px;" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Vessel Class </td>
				<td class="leftAligned" colspan="3"> 
					<input type="text" tabindex="2005" style="width: 458px; padding: 2px;" id="vessClassDesc" name="vessClassDesc"  readonly="readonly"/>				
				</td>
				<td class="rightAligned">Hull Type </td>
				<td class="leftAligned"> 
					<input type="text" tabindex="2006" id="hullDesc" name="hullDesc" style="width: 170px; padding: 2px;" readonly="readonly"/>				
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Registered Owner </td>
				<td class="leftAligned" colspan="3"> 
					<input type="text" tabindex="2007" style="width: 458px; padding: 2px;" id="regOwner" name="regOwner" readonly="readonly"/>				
				</td>
				<td class="rightAligned">Place </td>
				<td class="leftAligned"> 
					<input type="text" tabindex="2008" id="regPlace" name="regPlace" style="width: 170px; padding: 2px;" readonly="readonly"/>				
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Gross Tonnage </td>
				<td class="leftAligned"> 
					<input type="text" tabindex="2009" id="grossTon" name="grossTon" class="rightAligned" style="width: 170px; padding: 2px;" readonly="readonly"/>				
				</td>
				<td class="rightAligned">Vessel Length </td>
				<td class="leftAligned"> 
					<input type="text" tabindex="2010" id="vesselLength" name="vesselLength" class="rightAligned" style="width: 170px; padding: 2px;" readonly="readonly"/>				
				</td>
				<td class="rightAligned">Year Built </td>
				<td class="leftAligned">
					<input type="text" tabindex="2011" id="yearBuilt" name="yearBuilt" class="rightAligned" style="width: 170px; padding: 2px;" readonly="readonly" regExpPatt="pDigit04" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Net Tonnage </td>
				<td class="leftAligned"> 
					<input type="text" tabindex="2012" id="netTon" name="netTon" class="rightAligned" style="width: 170px; padding: 2px;" readonly="readonly"/>				
				</td>
				<td class="rightAligned">Vessel Breadth </td>
				<td class="leftAligned"> 
					<input type="text" tabindex="2013" id="vesselBreadth" name="vesselBreadth" class="rightAligned" style="width: 170px; padding: 2px;" readonly="readonly" />				
				</td>
				<td class="rightAligned">No. of Crew </td>
				<td class="leftAligned">
					<input type="text" tabindex="2014" id="noCrew" name="noCrew" class="rightAligned" style="width: 170px; padding: 2px;" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 140px;">Deadweight Tonnage </td>
				<td class="leftAligned" style="width: 165px;">
					<input type="text" tabindex="2015" id="deadWeight" name="deadWeight" class="rightAligned" style="width: 170px; padding: 2px;" readonly="readonly"/>
				</td>
				<td class="rightAligned" style="width: 100px;">Vessel Depth </td>
				<td class="leftAligned" style="width: 165px;"> 
					<input type="text" tabindex="2016" id="vesselDepth" name="vesselDepth" class="rightAligned" style="width: 170px; padding: 2px;" readonly="readonly"/>				
				</td>
				<td class="rightAligned" style="width: 100px;">Nationality </td>
				<td class="leftAligned">
					<input type="text" tabindex="2017" id="crewNat" name="crewNat" style="width: 170px; padding: 2px;" readonly="readonly"/>
				</td>
			</tr>
		</table>
	</div>
	
	<div class="sectionDiv" id="marineHullAdditionalItemInformation">
		<table align="center" width="920px" border="0" cellspacing="1" style="margin-top: 5px">
			<tr>
				<td class="rightAligned" style="width: 140px;">Drydock Place</td>
				<td class="leftAligned" style="width: 466px;">
					<div style="float:left; width: 466px; margin: none;">
						<input type="text" tabindex="2018" id="dryPlace" name="dryPlace" style="width: 456px; height: 15px; margin-top: 0px;" maxlength="30"/>
					</div>					
				</td>
				<td class="rightAligned" style="width: 100px;">Drydock Date</td>
				<td class="leftAligned">
					<div style="float:left; border: solid 1px gray; width: 173px; margin-right:3px;">
						<input tabindex="2019" style="border:none; width: 146px;" type="text"  id="dryDate" name="dryDate" readonly="readonly" />
						<img id="hrefDueDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('dryDate'),this, null);" alt="Dry Date" />
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Geography Limit</td>
				<td class="leftAligned" colspan="3"  >
					<div class="required" style="border: 1px solid gray; height: 20px; width: 749px;">
						<textarea tabindex="2020" class="required" onKeyDown="limitText(this, 200);" onKeyUp="limitText(this, 200);" id="geogLimit" name="geogLimit" style="width: 723px; border: none; height: 13px;"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="edit" id="editGeogLimit" class="hover" />
					</div>
					<input type="hidden" name="deductText" id="deductText" />
				</td>
			</tr>
		</table>
		
		<table style="margin: auto; width: 100%;" border="0">
			<tr>
				<td style="text-align:center;">
					<input type="button" tabindex="2021" id="btnAddItem" 	class="button" 			value="Add" />
					<input type="button" tabindex="2022" id="btnDeleteItem" class="disabledButton" 	value="Delete" />
				</td>
			</tr>
		</table>
	</div>		
</div>
<script type="text/javascript">
try{	
	$("hrefVessel").observe("click", function(){
		showHullVesselLOV((objUWGlobal.packParId != null ? objCurrPackPar.parId : objUWParList.parId), $F("itemNo"), "");
	});
	
	$("editGeogLimit").observe("click", function() {
		showOverlayEditor("geogLimit", 200, $("geogLimit").hasAttribute("readonly"));
	});
	
	observeChangeTagOnDate("hrefDueDate", "dryDate");
	observeChangeTagOnDate("editGeogLimit", "geogLimit");
}catch(e){
	showErrorMessage("Item Info - " + objUWParList.lineCd + " Item Additional Page", e);
}
</script>