<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<!-- div id="outerDiv" name="outerDiv" style="display: none;">
	<div id="innerDiv" name="outerDiv">				
		<label id="">Additional Item Information</label>
		<span class="refreshers" style="margin-top: 0;">
			<label name="gro" style="margin-left: 5px;">Hide</label>
		</span>									
	</div>
</div-->	
<div id="additionalItemInformationDiv" name="additionalItemInformationDiv">	
	<div id="message" style="display:none;">${message}</div>
	<div class="sectionDiv" id="additionalItemInformation" style="margin-bottom: 0;">
		<table id="marineHullMainTableForm" name="marineHullMainTableForm" align="center" width="90%;" border="0" style="margin-bottom: 10px">
			<tr>
				<td style="width: 15%" class="rightAligned">Vessel Name </td>
				<td class="leftAligned" colspan="3" >
					
					<input type="hidden" name="vesselName" id="vesselName" />
					
					<select id="vesselCd" name="vesselCd" style="width: 93%;" class="required">
						<option> </option>
				 		 <c:forEach var="mhList" items="${marineHullListing}">
				 		 	<c:if test="${not empty mhList.vesselCd}">
				 		 	selected="selected"
				 		 	<option 
				 		 			
				 		 			vesselName="${mhList.vesselName}"
				 		 			vesselOldName="${mhList.vesselOldName}" 
				 		 			vesTypeDesc="${mhList.vesTypeDesc}"
				 		 			propelSw="${mhList.propelSw}" 
				 		 			vessClassDesc="${mhList.vessClassDesc}"
				 		 			hullDesc="${mhList.hullDesc}" 
				 		 			regOwner="${mhList.regOwner}"
				 		 			regPlace="${mhList.regPlace}"
				 		 			grossTon="${mhList.grossTon}"
				 		 			vesselLength="${mhList.vesselLength}"
				 		 			yearBuilt="${mhList.yearBuilt}"
				 		 			netTon="${mhList.netTon}"
				 		 			vesselBreadth="${mhList.vesselBreadth}"
				 		 			noCrew="${mhList.noCrew}"
				 		 			deadWeight="${mhList.deadWeight}"
				 		 			vesselDepth="${mhList.vesselDepth}"
				 		 			crewNat="${mhList.crewNat}"
				 		 			endorsedTag="${mhList.endorsedTag}"
				 		 			dryDate="${mhList.dryDate}"
				 		 			dryPlace="${mhList.dryPlace}"
				 		 		 value="${mhList.vesselCd}" >${mhList.vesselName}</option>
				 		 	</c:if>
					     </c:forEach>
				   </select>
				</td>
				<td class="rightAligned"> Old Name </td>
				<td class="leftAligned">
					<input type="text" id="vesselOldName" name="vesselOldName"  readonly="readonly" />
				</td> 
			</tr>
			<tr>
				<td class="rightAligned">Vessel Type </td>
				<td class="leftAligned" colspan="3" >
					<input type="text" id="vesTypeDesc" name="vesTypeDesc" type="text" style="width: 90.5%;" maxlength="150" readonly="readonly"/>
				</td>
				<td class="rightAligned" style="width: 20%">Propeller Type </td>
				<td class="leftAligned">
					<input type="text" id="dspPropelSw" name="dspPropelSw" readonly="readonly">
					<input type="hidden" id="propelSw" name="propelSw">
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Vessel Class </td>
				<td class="leftAligned" colspan="3"> 
					<input type="text" style="width: 90.5%;" id="vessClassDesc" name="vessClassDesc"  readonly="readonly"/>				
				</td>
				<td class="rightAligned">Hull Type </td>
				<td class="leftAligned"> 
					<input type="text" id="hullDesc" name="hullDesc" readonly="readonly"/>				
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Registered Owner </td>
				<td class="leftAligned" colspan="3"> 
					<input type="text" style="width: 90.5%;" id="regOwner" name="regOwner" readonly="readonly"/>				
				</td>
				<td class="rightAligned">Place </td>
				<td class="leftAligned"> 
					<input type="text" id="regPlace" name="regPlace" readonly="readonly"/>				
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Gross Tonnage </td>
				<td class="leftAligned"  > 
					<input type="text" id="grossTon" name="grossTon" readonly="readonly"/>				
				</td>
				<td class="rightAligned" >Vessel Length </td>
				<td class="leftAligned"> 
						<input type="text" style="width:75%" id="vesselLength" name="vesselLength" readonly="readonly"/>				
				</td>
				<td class="rightAligned">Year Built </td>
				<td class="leftAligned">
					<input type="text" id="yearBuilt" name="yearBuilt" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Net Tonnage </td>
				<td class="leftAligned"> 
					<input type="text" id="netTon" name="netTon" readonly="readonly"/>				
				</td>
				<td class="rightAligned">Vessel Breadth </td>
					<td class="leftAligned"> 
						<input type="text" style="width:75%" id="vesselBreadth" name="vesselBreadth" readonly="readonly" />				
					</td>
				<td class="rightAligned">No. of Crew </td>
				<td class="leftAligned">
					<input type="text" id="noCrew" name="noCrew" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Deadweight Tonnage </td>
				<td class="leftAligned"> 
					<input type="text" id="deadWeight" name="deadWeight" readonly="readonly"/>				
				</td>
				<td class="rightAligned">Vessel Depth </td>
				<td class="leftAligned"> 
					<input type="text" style="width:75%" id="vesselDepth" name="vesselDepth" readonly="readonly"/>				
				</td>
				<td class="rightAligned">Nationality </td>
				<td class="leftAligned">
					<input type="text" id="crewNat" name="crewNat" readonly="readonly"/>
				</td>
			</tr>
			<tr> </tr>
		</table>
	</div>
	<div class="sectionDiv" id="marineHullAdditionalItemInformation">
			<table align="center" width="90%;" border="0" style="margin-top: 15px">
				<tr>
					<td class="rightAligned" style="width:15%">Drydock Place</td>
					<td class="leftAligned" >
						<input type="text" style="width:100%" id="dryPlace" name="dryPlace" maxlength="30"/>
					</td>
					<td class="rightAligned"  >Drydock Date</td>
						<td class="leftAligned" style="width:18%;">
							<div style="float:left; border: solid 1px gray; width: 98%; margin-right:3px;">
								<input style="border:none;width:80%;" type="text"  id="dryDate" name="dryDate" readonly="readonly"/>
								<img id="hrefDueDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('dryDate'),this, null);" alt="Dry Date" />
							</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Geographic Limit</td>
					<td class="leftAligned" colspan="3"">
						<div style="border: 1px solid gray; height: 20px; width: 99.6%;">
							<textarea id="geogLimit" class="leftAligned required" name="geogLimit" style="width: 95%; border: none; height: 13px;"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editGeogLimit" />
						</div>
						<input type="hidden" name="deductText" id="deductText" />
						<input type="hidden" name="endorsedTag" id="endorsedTag" />
					</td>
				</tr>
			</table>
	</div>
</div>
<script type="text/javaScript">
$("vesselCd").observe("change", function(){
	if (("" == $("vesselCd").value) && ("A" == $F("recFlag"))){
		$("vesselCd").focus();
		showMessageBox("Vessel name must not be null.", "info");
		return false;
	} else {
		if ("Y" == $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("endorsedTag")){
			populateVesselDetails();
		} else {
			//hideNotice("");
			//setCursor("default");
			$("vesselCd").focus();
			$("vesselCd").value = "";
			showMessageBox("Vessel has already been covered by a previous policy.  Vessel should be unique.", "info");
		}
	}
});

function populateVesselDetails(){
	var noCrew = $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("noCrew");
	var netTon = $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("netTon");
	var grossTon = $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("grossTon");
	var yearBuilt = $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("yearBuilt");
	var vesselBreadth = $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("vesselBreadth");
	var deadWeight = $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("deadWeight");
	var vesselDepth = $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("vesselDepth");
	var vesselLength =  $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("vesselLength");
	var dryDate = $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("dryDate");
	//var dryDate = $("vesselName").options[$("vesselName").selectedIndex].getAttribute("dryDate");
	
	$("vesselName").value = $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("vesselName");
	$("vesselOldName").value = $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("vesselOldName");
	$("vesTypeDesc").value = $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("vesTypeDesc");
	$("propelSw").value = $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("propelSw");
	$("vessClassDesc").value = $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("vessClassDesc");
	$("hullDesc").value = $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("hullDesc");
	$("regOwner").value = $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("regOwner");
	$("regPlace").value = $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("regPlace");
	$("crewNat").value = $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("crewNat");
	$("endorsedTag").value = $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("endorsedTag");
	//$("dryPlace").value = $("vesselName").options[$("vesselName").selectedIndex].getAttribute("dryPlace");
	$("grossTon").value = (grossTon==""?"-":grossTon);
	$("vesselLength").value = (vesselLength==""?"-":vesselLength);
	$("yearBuilt").value = (yearBuilt==""?"-":yearBuilt); 
	$("netTon").value = (netTon==""?"-":netTon);
	$("vesselBreadth").value = (vesselBreadth==""?"-":vesselBreadth);
	$("noCrew").value = (noCrew == ""? "-":noCrew);
	$("deadWeight").value = (deadWeight==""?"-":deadWeight);
	$("vesselDepth").value = (vesselDepth==""?"-":vesselDepth);
	$("dryPlace").value = nvl($("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("dryPlace"), "");
	$("dryDate").value = dryDate == "" ? "" : dateFormat(dryDate,"mm-dd-yyyy");
	
	hideNotice("");
}

$("geogLimit").observe("keyup", function () {
	limitText(this, 200);
});

$("editGeogLimit").observe("click", function () {
	showEditor("geogLimit", 200);
});
</script>