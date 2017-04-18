<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="perilInformation" class="sectionDiv" style="display: none; width:872px; background-color:white; ">
	<jsp:include page="/pages/underwriting/subPages/accidentBeneficiaryPerilListing.jsp"></jsp:include>
		<table align="center" border="0">
			<tr> 
				<td class="rightAligned" >Peril Name</td>
				<td class="leftAligned" >
					<select  id="bpPerilCd" name="bpPerilCd" style="width: 223px" class="required">
						<option value=""></option>
						<c:forEach var="bPerils" items="${beneficiaryPerils}">
							<option value="${bPerils.perilCd}">${bPerils.perilName}</option>
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned" style="width:105px;">TSI Amt. </td>
				<td class="leftAligned" >
					<input id="bpTsiAmt" name="bpTsiAmt" type="text" style="width: 215px;" value="" maxlength="18" class="money"/>
				</td>
			</tr>
			<tr>
				<td>
					<input id="bpGroupedItemNo" 	name="cGroupedItemNo" 	type="hidden" style="width: 215px;" value="" />
					<input id="bpBeneficiaryNo" 	name="bpBeneficiaryNo" 	type="hidden" style="width: 215px;" value="" />
					<input id="bpLineCd" 			name="bpLineCd" 		type="hidden" style="width: 215px;" value="" />
					<input id="bpRecFlag" 			name="bpRecFlag" 		type="hidden" style="width: 215px;" value="" />
					<input id="bpPremRt" 			name="bpPremRt" 		type="hidden" style="width: 215px;" value="" />
					<input id="bpPremAmt" 			name="bpPremAmt" 		type="hidden" style="width: 215px;" value="" />
					<input id="bpAnnTsiAmt" 		name="bpAnnTsiAmt" 		type="hidden" style="width: 215px;" value="" />
					<input id="bpAnnPremAmt" 		name="bpAnnPremAmt" 	type="hidden" style="width: 215px;" value="" />
					<input id="perilsItemSeqNo"		name="perilsItemSeqNo"  type="hidden"   style="width: 215px;" value="" />
					<input id="perilsItemSeqNo2"	name="perilsItemSeqNo2" type="hidden"   style="width: 215px;" value="" />
				</td>
			</tr>
		</table>
		<table align="center" border="0" style="margin-bottom:10px;">	
			<tr>
				<td class="rightAligned" style="text-align: left; padding-left: 5px;">
					<input type="button" class="button" 		id="btnAddBeneficiaryPerils" 	name="btnAddBeneficiaryPerils" 		value="Add Peril" 		style="width: 85px;" />
					<input type="button" class="disabledButton" id="btnDeleteBeneficiaryPerils" 	name="btnDeleteBeneficiaryPerils" 	value="Delete Peril" 		style="width: 85px;" />
				</td>
			</tr>
		</table>
</div>