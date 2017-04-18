<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" name="innerDiv">
		<label>Item Information</label>
		<span class="refreshers" style="margin-top: 0;">
			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
		</span>
	</div>
</div>
<div id="marineHullAddtlInfoDiv" name="marineHullAddtlInfoDiv" class="sectionDiv" style="margin: 0px;" changeTagAttr="true">
	<div id="addtlMHInfoGrid" class="sectionDiv" style="border: none; position: relative; height: 206px; padding-left: 50px; padding-right: 50px; padding-top: 20px; padding-bottom: 20px; width: 800px;"></div> 
	<table border="0" style="margin: auto; margin-top: 10px; margin-bottom: 10px;">
		<tr>
			<td class="rightAligned" style="width: 120px;">Item</td>
			<td class="leftAligned" colspan="3">
				<div style="width: 70px;" class="required withIconDiv">
					<input type="text" id="txtItemNo" name="txtItemNo" value="" style="width: 45px;" class="required withIcon integerUnformatted" maxlength="9" ignoreDelKey="true">
					<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="itemNoDate" name="itemNoDate" alt="Go" />
				</div>
				<input type="text" id="txtItemTitle" name="txtItemTitle" value="" style="width: 173px;" readonly="readonly">
			</td>
			<td></td>
			<td></td>
			<td class="rightAligned" style="width: 120px;">Description</td>
			<td class="leftAligned" colspan="3">
				<!-- <input type="text" id="txtItemDesc" name="txtItemDesc" value="" style="width: 250px;" readonly="readonly"> -->
				<div style="border: 1px solid gray; height: 20px; width: 256px;">
					<textarea style="resize:none; width: 225px; border: none; height: 13px;" id="txtItemDesc" name="txtItemDesc" readonly="readonly" ignoreDelKey="true"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editTxtItemDesc" id="editTxtItemDesc" />
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >Currency</td>
			<td class="leftAligned"  colspan="3">
				<input type="text" id="txtCurrencyCd" name="txtCurrencyCd" value="" style="width: 65px; text-align: right;" readonly="readonly">
				<input type="text" id="txtDspCurrencyDesc" name="txtDspCurrencyDesc" value="" style="width: 173px;" readonly="readonly">
			</td> 
			<td></td>
			<td></td>
			<td class="rightAligned" ></td>
			<td class="leftAligned" colspan="3">
				<!-- <input type="text" id="txtItemDesc2" name="txtItemDesc2" value="" style="width: 250px;" readonly="readonly"> -->
				<div style="border: 1px solid gray; height: 20px; width: 256px;">
					<textarea style="resize:none; width: 225px; border: none; height: 13px;" id="txtItemDesc2" name="txtItemDesc2" readonly="readonly" ignoreDelKey="true"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editTxtItemDesc2" id="editTxtItemDesc2" />
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >Currency Rate</td>
			<td class="leftAligned"  colspan="3">
				<input type="text" id="txtCurencyRate" name="txtCurencyRate" value="" style="width: 250px; text-align: right;" readonly="readonly">
			</td>
			<td></td>
			<td></td>
			<td class="rightAligned" >Dry Place</td>
			<td class="leftAligned"  >
				<input type="text" id="txtDryPlace" name="txtDryPlace" value="" style="width: 80px; text-align: right;" readonly="readonly">
			</td>
			<td class="rightAligned">Dry Date</td>
			<td class="leftAligned"  >
				<input type="text" id="txtDryDate" name="txtDryDate" value="" style="width: 98px; text-align: right;" readonly="readonly">
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >Vessel</td>
			<td class="leftAligned" colspan="3">
				<input type="text" id="txtVesselCd" name="txtVesselCd" value="" style="width: 65px; text-align: right;" readonly="readonly">
				<input type="text" id="txtVesselName" name="txtVesselName" value="" style="width: 173px;" readonly="readonly">
			</td> 
			<td></td>
			<td></td>
			<td class="rightAligned" >Geographical Limit</td>
			<td class="leftAligned" colspan="3">
				<!-- <input type="text" id="txtGeoLimit" name="txtGeoLimit" value="" style="width: 250px;" readonly="readonly"> -->
				<div style="border: 1px solid gray; height: 20px; width: 256px;">
					<textarea style="resize:none; width: 225px; border: none; height: 13px;" id="txtGeoLimit" name="txtGeoLimit" readonly="readonly" ignoreDelKey="true"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editTxtGeoLimit" id="editTxtGeoLimit" />
				</div>	
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >Vessel Type</td>
			<td class="leftAligned" colspan="3">
				<input type="text" id="txtVesselType" name="txtVesselType" value="" style="width: 250px;" readonly="readonly">
			</td>
			<td></td>
			<td></td>
			<td class="rightAligned" >Old Name</td>
			<td class="leftAligned"  colspan="3">
				<input type="text" id="txtOldName" name="txtOldName" value="" style="width: 250px;" readonly="readonly" ignoreDelKey="true">
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >Vessel Class</td>
			<td class="leftAligned" colspan="3">
				<input type="text" id="txtVesselClass" name="txtVesselClass" value="" style="width: 250px;" readonly="readonly">
			</td>
			<td></td>
			<td></td>
			<td class="rightAligned" >Prop. Type</td>
			<td class="leftAligned"  colspan="3">
				<input type="text" id="txtPropType" name="txtPropType" value="" style="width: 250px;" readonly="readonly">
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >Registered Owner</td>
			<td class="leftAligned" colspan="3">
				<input type="text" id="txtRegOwner" name="txtRegOwner" value="" style="width: 250px;" readonly="readonly" ignoreDelKey="true">
			</td>
			<td></td>
			<td></td>
			<td class="rightAligned" >Hull Type</td>
			<td class="leftAligned"  colspan="3">
				<input type="text" id="txtHullType" name="txtHullType" value="" style="width: 250px;" readonly="readonly">
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >Registered Place</td>
			<td class="leftAligned" colspan="3">
				<input type="text" id="txtRegPlace" name="txtRegPlace" value="" style="width: 250px;" readonly="readonly" ignoreDelKey="true">
			</td>
			<td></td>
			<td></td>
			<td class="rightAligned" >Nationality</td>
			<td class="leftAligned"  colspan="3">
				<input type="text" id="txtCrewNat" name="txtCrewNat" value="" style="width: 250px;" readonly="readonly" ignoreDelKey="true">
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >Gross Tonnage</td>
			<td class="leftAligned" colspan="3">
				<input type="text" id="txtGrossTonnage" name="txtGrossTonnage" value="" style="width: 250px; text-align: right;" readonly="readonly">
			</td>
			<td></td>
			<td></td>
			<td class="rightAligned" >Vessel Length</td>
			<td class="leftAligned"  colspan="3">
				<input type="text" id="txtVesselLength" name="txtVesselLength" value="" style="width: 250px; text-align: right;" readonly="readonly" ignoreDelKey="true">
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >Net Tonnage</td>
			<td class="leftAligned" colspan="3">
				<input type="text" id="txtNetTonnage" name="txtNetTonnage" value="" style="width: 250px; text-align: right;" readonly="readonly" ignoreDelKey="true">
			</td>
			<td></td>
			<td></td>
			<td class="rightAligned" >Vessel Breadth</td>
			<td class="leftAligned"  colspan="3">
				<input type="text" id="txtVesselBreadth" name="txtVesselBreadth" value="" style="width: 250px; text-align: right;" readonly="readonly" ignoreDelKey="true">
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >Dead wt. Tonnage</td>
			<td class="leftAligned" colspan="3">
				<input type="text" id="txtDeadWeight" name="txtDeadWeight" value="" style="width: 250px; text-align: right;" readonly="readonly" ignoreDelKey="true">
			</td>
			<td></td>
			<td></td>
			<td class="rightAligned" >Vessel Depth</td>
			<td class="leftAligned"  colspan="3">
				<input type="text" id="txtVesselDepth" name="txtVesselDepth" value="" style="width: 250px; text-align: right;" readonly="readonly" ignoreDelKey="true">
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >No. of Crew</td>
			<td class="leftAligned"  >
				<input type="text" id="txtNoOfCrew" name="txtNoOfCrew" value="" style="width: 80px; text-align: right;" readonly="readonly" ignoreDelKey="true">
			</td>
			<td class="rightAligned" >Year Built</td>
			<td class="leftAligned">
				<input type="text" id="txtYrBuilt" name="txtYrBuilt" value="" style="width: 92px; text-align: right;" readonly="readonly">
			</td>
			<td></td>
			<td></td>
			<td class="rightAligned" >Deductible Text</td>
			<td class="leftAligned"  colspan="3">
				<!-- <input type="text" id="txtDeduct" name="txtDeduct" value="" style="width: 250px;" readonly="readonly"> -->
				<div style="border: 1px solid gray; height: 20px; width: 256px;">
					<textarea style="resize:none; width: 225px; border: none; height: 13px;" id="txtDeduct" name="txtDeduct" readonly="readonly" ignoreDelKey="true"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editTxtDeduct" id="editTxtDeduct" />
				</div>
			</td>
		</tr>
	</table>
	<center>
		<div class="buttonsCaDiv" style="margin-bottom: 10px">
			<input type="button" id="btnAddItem" 	name="btnAddItem" class="button"	value="Add" />
			<input type="button" id="btnDeleteItem" name="btnDeleteItem"	class="button"	value="Delete" /> 			
		</div> 
	</center>
</div>

<script type="text/javascript">
	// Added text editor - Nica 05.24.2013
	$("editTxtItemDesc").observe("click", function(){showEditor("txtItemDesc", 2000, 'true');});
	$("editTxtItemDesc2").observe("click", function(){showEditor("txtItemDesc2", 2000, 'true');});
	$("editTxtGeoLimit").observe("click", function(){showEditor("txtGeoLimit", 200, 'true');});
	$("editTxtDeduct").observe("click", function(){showEditor("txtDeduct", 200, 'true');});
</script>
