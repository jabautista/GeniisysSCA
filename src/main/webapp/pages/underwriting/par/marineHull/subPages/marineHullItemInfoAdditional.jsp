<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-cache");
%>

<jsp:include page="/pages/underwriting/subPages/additionalItemInfoHeader.jsp"></jsp:include>
<div id="additionalItemInformationDiv" name="additionalItemInformationDiv">
	<div class="sectionDiv" id="additionalItemInformation" style="margin: 0px;">
		<table id="marineHullMainTableForm" name="marineHullMainTableForm" align="center" width="90%;" border="0" style="margin-bottom: 10px">
			<tr>
				<td style="width: 15%" class="rightAligned">Vessel Name </td>
				<td class="leftAligned" colspan="3" >
					
					<input type="hidden" name="vesselName" id="vesselName" />
					
					<select id="vesselCd" name="vesselCd" style="width: 93%;" class="required">
						<option> </option>
				 		 <c:forEach var="mhList" items="${marineHullList}">
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
				 		 			dryPlace="${mhList.dryPlace}"
				 		 			dryDate="${mhList.dryDate}"
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
					<input type="text" id="propelSw" name="propelSw" readonly="readonly">
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
		</table>
	</div>
	
	<div class="sectionDiv" id="marineHullAdditionalItemInformation">
		<table align="center" width="90%;" border="0" style="margin-top: 15px">
			<tr>
				<td class="rightAligned" style="width:15%">Drydock Place</td>
				<td class="leftAligned" >
					<div style="border: 1px solid gray; height: 20px; width: 99%;">
						<textarea onKeyDown="limitText(this, 30);" onKeyUp="limitText(this, 30);" id="dryPlace" name="dryPlace" style="width: 92%; border: none; height: 13px;"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="edit" id="editDryPlace" />
					</div>
				</td>
				<td class="rightAligned">Drydock Date</td>
				<td class="leftAligned" style="width:18%;">
					<div style="float:left; border: solid 1px gray; width: 98%; margin-right:3px;">
						<input style="border:none;width:80%;" type="text"  id="dryDate" name="dryDate" readonly="readonly" />
						<img id="hrefDueDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('dryDate'),this, null);" alt="Dry Date" />
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Geography Limit</td>
				<td class="leftAligned" colspan="3"  >
					<div class="required" style="border: 1px solid gray; height: 20px; width: 99.6%;">
						<textarea class="required" onKeyDown="limitText(this, 200);" onKeyUp="limitText(this, 200);" id="geogLimit" name="geogLimit" style="width: 95%; border: none; height: 13px;"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="edit" id="editGeogLimit" />
					</div>
					<input type="hidden" name="deductText" id="deductText" />
				</td>
			</tr>
		</table>
		
		<table style="margin: auto; width: 100%;" border="0">
			<tr>
				<td style="text-align:center;">
					<input type="button" id="btnAddItem" 	class="button" 			value="Add" />
					<input type="button" id="btnDeleteItem" class="disabledButton" 	value="Delete" />
				</td>
			</tr>
		</table>
	</div>
		
</div>

<script type="text/javascript">
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();

	var itemNo 			= 0;
	var itemTitle 		= "";
	var itemDesc 		= "";
	var itemDesc2 		= "";
	var currency		= "";
	var currencyText 	= "";
	var rate 			= "";
	var coverage 		= null;
	var coverageText 	= null;
	var region			= "";
	var regionText		= "";

	$("vesselCd").observe("change", function(){
		var noCrew = $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("noCrew");
		var netTon = $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("netTon");
		var grossTon = $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("grossTon");
		var yearBuilt = $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("yearBuilt");
		var vesselBreadth = $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("vesselBreadth");
		var deadWeight = $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("deadWeight");
		var vesselDepth = $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("vesselDepth");
		var vesselLength =  $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("vesselLength");
		var dryDate = $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("dryDate");
		
		$("vesselName").value = $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("vesselName");
		$("vesselOldName").value = $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("vesselOldName");
		$("vesTypeDesc").value = $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("vesTypeDesc");
		$("propelSw").value = $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("propelSw");
		$("vessClassDesc").value = $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("vessClassDesc");
		$("hullDesc").value = $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("hullDesc");
		$("regOwner").value = $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("regOwner");
		$("regPlace").value = $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("regPlace");
		$("crewNat").value = $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("crewNat");
		$("grossTon").value = grossTon;//(grossTon==""?"-":grossTon);
		$("vesselLength").value = vesselLength;//(vesselLength==""?"-":vesselLength);
		$("yearBuilt").value = yearBuilt;//(yearBuilt==""?"-":yearBuilt); 
		$("netTon").value = netTon;//(netTon==""?"-":netTon);
		$("vesselBreadth").value = vesselBreadth;//(vesselBreadth==""?"-":vesselBreadth);
		$("noCrew").value = noCrew;//(noCrew == ""? "-":noCrew);
		$("deadWeight").value = deadWeight;//(deadWeight==""?"-":deadWeight);
		$("vesselDepth").value = vesselDepth;//(vesselDepth==""?"-":vesselDepth);

		$("dryDate").value = dryDate;//(dryDate==""?"-":dateFormat(dryDate, "mm-dd-yyyy"));
		$("dryPlace").value = $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("dryPlace");
	});

	$("currency").observe("change", function(){		
		if(!($F("currency").empty())){				
			if(objFormVariables.varOldCurrencyCd != $F("currency")){
				objFormVariables.varGroupSw = "Y";				
			}				
			getRates();
			if ($("currency").value == "1"){
				$("rate").disable();
			}else{
				$("rate").enable();
			}
		}else{
			$("rate").value = "";
		}						
	});	

	$("editGeogLimit").observe("click", function(){
		showEditor("geogLimit", 200);
	});

	$("editDryPlace").observe("click", function(){
		showEditor("dryPlace", 30);
	});

	observeChangeTagOnDate("editGeogLimit", "geogLimit");
	observeChangeTagOnDate("editDryPlace", "dryPlace");

</script>