<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<jsp:include page="/pages/underwriting/subPages/additionalItemInfoHeader.jsp"></jsp:include>
<div id="additionalItemInformationDiv" name="additionalItemInformationDiv">
	<div class="sectionDiv" id="additionalItemInformation" style="margin: 0px;">
		<table id="casualtyTable" width="920px" cellspacing="1" border="0">
			<tr><td colspan="3"><br /></td></tr>
			<tr id="rowLocationCd">
				<td class="rightAligned" style="width : 100px;">Location</td>
				<td class="leftAligned">					
					<select tabindex="2001" id="locationCd" name="locationCd" style="width : 365px;">
						<option value=""></option>
						<!-- marco - 06.19.2014 - escape HTML tags -->
						<c:forEach var="location" items="${locationListing}">
							<option value="${location.locationCd}" >${fn:escapeXml(location.locationDesc)}</option>
						</c:forEach>
					</select>					
				</td>										
			</tr>		
			<tr>
				<td class="rightAligned" style="width : 100px;">Location of Risk</td>
				<td class="leftAligned">
					<input tabindex="2002" type="text" id="txtLocation" name="txtLocation" maxlength="150" style="width : 357px;" />					
				</td>										
			</tr>
			<tr>
				<td class="rightAligned" style="width: 100px;">Section/Hazard</td>
				<td class="leftAligned">
					<select tabindex="2003" id="selSectionOrHazardCd" name="selSectionOrHazardCd" style="width : 365px;">
						<option value=""></option>
						<c:forEach var="sectionOrHazard" items="${sectionHazardListing}">
							<option value="${sectionOrHazard.sectionOrHazardCd}" sectionLineCd="${sectionOrHazard.sectionLineCd}" sectionSublineCd="${sectionOrHazard.sectionSublineCd}">
								${sectionOrHazard.sectionOrHazardTitle}
							</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width : 100px;">Capacity</td>
				<td class="leftAligned">
					<select tabindex="2004" id="selCapacityCd" name="selCapacityCd" style="width : 365px;">
						<option value=""></option>
						<c:forEach var="capacity" items="${capacityListing}">
							<option value="${capacity.positionCd}">${capacity.position}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width : 100px;">Liability</td>
				<td class="leftAligned" style="width: 357px;">
					<div style="border: 1px solid gray; height: 20px; width: 362px;">
						<textarea tabindex="2005" onKeyDown="limitText(this, 500);" onKeyUp="limitText(this, 500);" id="txtLimitOfLiability" name="txtLimitOfLiability" style="width: 335px; border: none; height: 13px; resize: none;"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" class="hover" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="edit" id="editLimitOfLiability" />
					</div>
					<!-- <input type="text" id="txtLimitOfLiability" name="txtLimitOfLiability" style="width : 357px;" maxlength="500" />  -->
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width:163px;">Interest </td>
				<td class="leftAligned" style="width: 357px;">
					<div style="border: 1px solid gray; height: 20px; width: 362px;">
						<textarea tabindex="2006" onKeyDown="limitText(this, 500);" onKeyUp="limitText(this, 500);" id="txtInterestOnPremises" name="txtInterestOnPremises" style="width: 335px; border: none; height: 13px; resize: none;"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" class="hover" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="edit" id="editInterestOnPremises" />
					</div>
					<!-- <input id="txtInterestOnPremises" name="txtInterestOnPremises" type="text" style="width: 357px;" maxlength="500"/>  -->
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 163px;">Section/Hazard Info </td>
				<td class="leftAligned" style="width: 357px;">
					<div style="border: 1px solid gray; height: 20px; width: 362px;">
						<textarea tabindex="2007" onKeyDown="limitText(this, 2000);" onKeyUp="limitText(this, 2000);" id="txtSectionOrHazardInfo" name="txtSectionOrHazardInfo" style="width: 335px; border: none; height: 13px; resize: none;"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" class="hover" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="edit" id="editSectionOrHazardInfo" />
					</div>
					<!-- <input id="txtSectionOrHazardInfo" name="txtSectionOrHazardInfo" type="text" style="width: 357px;" maxlength="2000"/>  -->
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Conveyance </td>
				<td class="leftAligned" >
					<input tabindex="2008" id="txtConveyanceInfo" name="txtConveyanceInfo" type="text" style="width: 357px;" maxlength="60"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Property No. </td>
				<td class="leftAligned">					
						<input tabindex="2009" id="txtPropertyNo" name="txtPropertyNo" type="text" style="width: 157px;" maxlength="30"/>
											
						<select tabindex="2010" id="selPropertyNoType" name="selPropertyNoType" style="width: 190px; margin-left: 6px;">
							<option value="" ></option>
							<option value="M" >Motor Number</option>
							<option value="S" >Serial Number</option>
						</select>						
				</td>
			</tr>
		</table>
		<table style="margin: auto; width: 100%;" border="0">
			<tr>
				<td style="text-align: center;">
					<input type="button" tabindex="2011" id="btnAddItem" 	class="button" value="Add" />
					<input type="button" tabindex="2012" id="btnDeleteItem"	class="disabledButton" value="Delete" />
				</td>
			</tr>
		</table>
	</div>
</div>
<script type="text/javascript">
try{
	$("editLimitOfLiability").observe("click", function() {
		showOverlayEditor("txtLimitOfLiability", 500, $("txtLimitOfLiability").hasAttribute("readonly"));
	});
	
	$("editInterestOnPremises").observe("click", function() {
		showOverlayEditor("txtInterestOnPremises", 500, $("txtInterestOnPremises").hasAttribute("readonly"));
	});
	
	$("editSectionOrHazardInfo").observe("click", function() {
		showOverlayEditor("txtSectionOrHazardInfo", 2000, $("txtSectionOrHazardInfo").hasAttribute("readonly"));
	});
}catch(e){
	showErrorMessage("Item Info - " + objUWParList.lineCd + " Item Additional Page", e);
}	
</script>