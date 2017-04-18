<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<jsp:include page="/pages/underwriting/subPages/additionalItemInfoHeader.jsp"></jsp:include>
<div id="additionalItemInformationDiv" name="additionalItemInformationDiv">	
	<div id="message" style="display:none;">${message}</div>
	<div class="sectionDiv" id="additionalItemInformation" style="margin: 0px;" masterDetail="true">
		<table id="caMainTableForm" name="caMainTableForm" align="center" width="480px;" border="0">
			<tr>
				<td class="rightAligned" style="width:100px;">Location </td>
				<td class="leftAligned" >
					<select  id="locationCd" name="locationCd" style="width: 365px;">
						<option value=""></option>
						<c:forEach var="locationList" items="${locationListing}">
							<option value="${locationList.locationCd}">${locationList.locationDesc}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Location of Risk </td>
				<td class="leftAligned" >
					<input id="location" name="location" type="text" style="width: 357px;" maxlength="150"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Section/Hazard </td>
				<td class="leftAligned">
					<select  id="sectionOrHazardCd" name="sectionOrHazardCd" style="width: 365px;">
						<option value="" sectionLineCd="" sectionSublineCd=""></option>
						<c:forEach var="sectionOrHazardCdList" items="${sectionHazardListing}">
							<option value="${sectionOrHazardCdList.sectionOrHazardCd}" sectionLineCd="${sectionOrHazardCdList.sectionLineCd}" sectionSublineCd="${sectionOrHazardCdList.sectionSublineCd}">${sectionOrHazardCdList.sectionOrHazardTitle}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Capacity </td>
				<td class="leftAligned">
					<select  id="capacityCd" name="capacityCd" style="width: 365px;">
						<option value="" ></option>
						<c:forEach var="capacityCdList" items="${capacityListing}">
							<option value="${capacityCdList.positionCd}">${capacityCdList.position}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Liability </td>
				<td class="leftAligned" >
					<input id="limitOfLiability" name="limitOfLiability" type="text" style="width: 357px;" maxlength="500"/>
				</td>
			</tr>	
			<tr>
				<td>
					<input id="sectionLineCd" name="sectionLineCd" type="hidden" style="width: 357px;" maxlength="2" readonly="readonly"/>
					<input id="sectionSublineCd" name="sectionSublineCd" type="hidden" style="width: 357px;" maxlength="7" readonly="readonly"/>
					<input id="ora2010Sw" name="ora2010Sw" type="hidden" value="${ora2010Sw }" style="width: 357px;" readonly="readonly"/>
				</td>
			</tr>
		</table>
		<table style="margin: auto; width: 100%;" border="0">
			<tr>
				<td style="text-align:center;">
					<input type="button" id="btnAdd" 	class="button" 			value="Add" />
					<input type="button" id="btnDelete" class="disabledButton" 	value="Delete" />
				</td>
			</tr>
		</table>
	</div>
</div>
<script type="text/javaScript">
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();

	$("sectionOrHazardCd").observe("change", function ()	{
    	$("sectionLineCd").value = $("sectionOrHazardCd").options[$("sectionOrHazardCd").selectedIndex].getAttribute("sectionLineCd");
    	$("sectionSublineCd").value = $("sectionOrHazardCd").options[$("sectionOrHazardCd").selectedIndex].getAttribute("sectionSublineCd");
	});

	//eto kapag ayaw nila ilabas ung location sa additional info kasi enhancement eto tingin ko
	//sa forms meron ganito condition kapag ung giisp.v('ORA2010_SW') <> 'Y' hide dapat itong location at ibang enhancement
	if ($F("ora2010Sw") != "Y"){
		$("caMainTableForm").down("tr",0).hide();
		$("casualtyButtonsDiv").down("input",0).hide();
		$("casualtyButtonsDiv").down("input",1).hide();
	} else{
		$("caMainTableForm").down("tr",0).show();
		$("casualtyButtonsDiv").down("input",0).show();
		$("casualtyButtonsDiv").down("input",1).show();
	}	
		
</script>	