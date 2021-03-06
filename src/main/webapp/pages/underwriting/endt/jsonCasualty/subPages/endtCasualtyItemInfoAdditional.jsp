<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<jsp:include page="/pages/underwriting/subPages/additionalItemInfoHeader.jsp"></jsp:include>
<div id="additionalItemInformationDiv" name="additionalItemInformationDiv">
	<div class="sectionDiv" id="additionalItemInformation" style="margin: 0px;">
		<table id="casualtyTable" width="920px" cellspacing="1" border="0">
			<tr><td colspan="3"><br /></td></tr>
			<tr id="rowLocationCd">
				<td class="rightAligned" style="width : 100px;">Location</td>
				<td class="leftAligned">					
					<select id="locationCd" name="locationCd" style="width : 365px;">
						<option value=""></option>
						<c:forEach var="location" items="${locationListing}">
							<option value="${location.locationCd}">${location.locationDesc}</option>
						</c:forEach>
					</select>					
				</td>										
			</tr>		
			<tr>
				<td class="rightAligned" style="width : 100px;">Location of Risk</td>
				<td class="leftAligned">
					<input type="text" id="txtLocation" name="txtLocation" maxlength="150" style="width : 357px;" />					
				</td>										
			</tr>
			<tr>
				<td class="rightAligned" style="width: 100px;">Section/Hazard</td>
				<td class="leftAligned">
					<select id="selSectionOrHazardCd" name="selSectionOrHazardCd" style="width : 365px;">
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
					<select id="selCapacityCd" name="selCapacityCd" style="width : 365px;">
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
						<textarea onKeyDown="limitText(this, 500);" onKeyUp="limitText(this, 500);" id="txtLimitOfLiability" name="txtLimitOfLiability" style="width: 335px; border: none; height: 13px;"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" class="hover" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="edit" id="editLimitOfLiability" />
					</div>
					<!-- <input type="text" id="txtLimitOfLiability" name="txtLimitOfLiability" style="width : 357px;" maxlength="500" />  -->
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width:163px;">Interest </td>
				<td class="leftAligned" style="width: 357px;">
					<div style="border: 1px solid gray; height: 20px; width: 362px;">
						<textarea onKeyDown="limitText(this, 500);" onKeyUp="limitText(this, 500);" id="txtInterestOnPremises" name="txtInterestOnPremises" style="width: 335px; border: none; height: 13px;"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" class="hover" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="edit" id="editInterestOnPremises" />
					</div>
					<!-- <input id="txtInterestOnPremises" name="txtInterestOnPremises" type="text" style="width: 357px;" maxlength="500"/>  -->
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 163px;">Section/Hazard Info </td>
				<td class="leftAligned" style="width: 357px;">
					<div style="border: 1px solid gray; height: 20px; width: 362px;">
						<textarea onKeyDown="limitText(this, 2000);" onKeyUp="limitText(this, 2000);" id="txtSectionOrHazardInfo" name="txtSectionOrHazardInfo" style="width: 335px; border: none; height: 13px;"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" class="hover" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="edit" id="editSectionOrHazardInfo" />
					</div>
					<!-- <input id="txtSectionOrHazardInfo" name="txtSectionOrHazardInfo" type="text" style="width: 357px;" maxlength="2000"/>  -->
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Conveyance </td>
				<td class="leftAligned" >
					<input id="txtConveyanceInfo" name="txtConveyanceInfo" type="text" style="width: 357px;" maxlength="60"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Property No. </td>
				<td class="leftAligned">					
						<input id="txtPropertyNo" name="txtPropertyNo" type="text" style="width: 157px;" maxlength="30"/>
					
						<select id="selPropertyNoType" name="selPropertyNoType" style="width: 190px; margin-left: 6px;">
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
					<input type="button" id="btnAddItem" 	class="button" value="Add" />
					<input type="button" id="btnDeleteItem"	class="disabledButton" value="Delete" />
				</td>
			</tr>
		</table>
	</div>
</div>
<script type="text/javascript">
	$("editLimitOfLiability").observe("click", function(){
		showEditor("txtLimitOfLiability", 500);
	});
	
	$("editInterestOnPremises").observe("click", function(){
		showEditor("txtInterestOnPremises", 500);
	});
	
	$("editSectionOrHazardInfo").observe("click", function(){
		showEditor("txtSectionOrHazardInfo", 2000);
	});
</script>