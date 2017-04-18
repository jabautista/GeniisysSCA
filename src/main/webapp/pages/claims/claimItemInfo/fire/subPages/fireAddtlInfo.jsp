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
<div id="fireAddtlInfoDiv" name="fireAddtlInfoDiv" class="sectionDiv" style="margin: 0px;">
	<div id="addtlInfoGrid" style="position: relative; height: 206px; margin: auto; margin-top: 10px; width: 800px;"> </div>
	<table border="0" style="margin: auto; margin-top: 10px; margin-bottom: 10px;">
		<tr>
			<td class="rightAligned" style="width: 120px;">Item</td>
			<td class="leftAligned">
				<div style="width: 90px;" class="required withIconDiv">
					<input type="text" id="txtItemNo" name="txtItemNo" value="" style="width: 65px;" class="required withIcon integerUnformatted" maxlength="9" ignoreDelKey="true">
					<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="itemNoDate" name="itemNoDate" alt="Go" />
				</div>
				<input type="text" id="txtItemTitle" name="txtItemTitle" value="" style="width: 154px;" readonly="readonly">
			</td>
			<td class="rightAligned" style="width: 120px;">Description</td>
			<td class="leftAligned">
				<!-- <input type="text" id="txtItemDesc" name="txtItemDesc" value="" style="width: 250px;" readonly="readonly"> -->
				<div style="border: 1px solid gray; height: 20px; width: 256px;">
					<textarea style="resize:none; width: 225px; border: none; height: 13px;" id="txtItemDesc" name="txtItemDesc" readonly="readonly" ignoreDelKey="true"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editTxtItemDesc" id="editTxtItemDesc" />
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >Currency</td>
			<td class="leftAligned"  >
				<input type="text" id="txtCurrencyCd" name="txtCurrencyCd" value="" style="width: 84px; text-align: right;" readonly="readonly">
				<input type="text" id="txtDspCurrencyDesc" name="txtDspCurrencyDesc" value="" style="width: 154px;" readonly="readonly">
			</td>
			<td class="rightAligned" ></td>
			<td class="leftAligned"  >
				<!-- <input type="text" id="txtItemDesc2" name="txtItemDesc2" value="" style="width: 250px;" readonly="readonly"> -->
				<div style="border: 1px solid gray; height: 20px; width: 256px;">
					<textarea style="resize:none; width: 225px; border: none; height: 13px;" id="txtItemDesc2" name="txtItemDesc2" readonly="readonly" ignoreDelKey="true"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editTxtItemDesc2" id="editTxtItemDesc2" />
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >Currency Rate</td>
			<td class="leftAligned"  >
				<input type="text" id="txtCurrencyRate" name="txtCurrencyRate" value="" style="width: 250px; text-align: right;" readonly="readonly">
			</td>
			<td class="rightAligned" >Tariff Zone</td>
			<td class="leftAligned"  >
				<input type="text" id="txtDspTariffZone" name="txtDspTariffZone" value="" style="width: 250px;" readonly="readonly">
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >Item Type</td>
			<td class="leftAligned"  >
				<input type="text" id="txtDspItemType" name="txtDspItemType" value="" style="width: 250px;" readonly="readonly">
			</td>
			<td class="rightAligned" >Tariff Code</td>
			<td class="leftAligned"  >
				<input type="text" id="txtTarfCd" name="txtTarfCd" value="" style="width: 250px;" readonly="readonly">
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >District</td>
			<td class="leftAligned"  >
				<input type="text" id="txtDistrictNo" name="txtDistrictNo" value="" style="width: 90px; float: left;" readonly="readonly">
				<label style="float: left; width: 62px; text-align: center; margin-top: 6px;">Block</label>
				<input type="text" id="txtBlockNo" name="txtBlockNo" value="" style="width: 90px; float: left;" readonly="readonly">
			</td>
			<td class="rightAligned" >Location</td>
			<td class="leftAligned"  >
				<input type="text" id="txtLocRisk1" name="txtLocRisk1" value="" style="width: 250px;" readonly="readonly">
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >EQ Zone</td>
			<td class="leftAligned"  >
				<input type="text" id="txtDspEqZone" name="txtDspEqZone" value="" style="width: 250px;" readonly="readonly">
			</td>
			<td class="rightAligned" ></td>
			<td class="leftAligned"  >
				<input type="text" id="txtLocRisk2" name="txtLocRisk2" value="" style="width: 250px;" readonly="readonly">
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >Risk</td>
			<td class="leftAligned"  >
				<input type="text" id="txtRiskDesc" name="txtRiskDesc" value="" style="width: 250px;" readonly="readonly" ignoreDelKey="true">
			</td>
			<td class="rightAligned" ></td>
			<td class="leftAligned"  >
				<input type="text" id="txtLocRisk3" name="txtLocRisk3" value="" style="width: 250px;" readonly="readonly">
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >Typhoon Zone</td>
			<td class="leftAligned"  >
				<input type="text" id="txtDspTyphoon" name="txtDspTyphoon" value="" style="width: 250px;" readonly="readonly">
			</td>
			<td class="rightAligned" >Boundary Front</td>
			<td class="leftAligned"  >
				<!-- <input type="text" id="txtFront" name="txtFront" value="" style="width: 250px;" readonly="readonly"> -->
				<div style="border: 1px solid gray; height: 20px; width: 256px;">
					<textarea style="resize:none; width: 225px; border: none; height: 13px;" id="txtFront" name="txtFront" readonly="readonly" ignoreDelKey="true"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editFront" id="editFront" />
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >Flood Zone</td>
			<td class="leftAligned"  >
				<input type="text" id="txtDspFloodZone" name="txtDspFloodZone" value="" style="width: 250px;" readonly="readonly">
			</td>
			<td class="rightAligned" >Right</td>
			<td class="leftAligned"  >
				<!-- <input type="text" id="txtRight" name="txtRight" value="" style="width: 250px;" readonly="readonly"> -->
				<div style="border: 1px solid gray; height: 20px; width: 256px;">
					<textarea style="resize:none; width: 225px; border: none; height: 13px;" id="txtRight" name="txtRight" readonly="readonly" ignoreDelKey="true"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editRight" id="editRight" />
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >Assignee</td>
			<td class="leftAligned"  >
				<input type="text" id="txtAssignee" name="txtAssignee" value="" style="width: 250px;" readonly="readonly" ignoreDelKey="true">
			</td>
			<td class="rightAligned" >Left</td>
			<td class="leftAligned"  >
				<!-- <input type="text" id="txtLeft" name="txtLeft" value="" style="width: 250px;" readonly="readonly"> -->
				<div style="border: 1px solid gray; height: 20px; width: 256px;">
					<textarea style="resize:none; width: 225px; border: none; height: 13px;" id="txtLeft" name="txtLeft" readonly="readonly" ignoreDelKey="true"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editLeft" id="editLeft" />
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >Occupancy</td>
			<td class="leftAligned"  >
				<input type="text" id="txtDspOccupancy" name="txtDspOccupancy" value="" style="width: 65px;" readonly="readonly">
				<input type="text" id="txtOccupancyRemarks" name="txtOccupancyRemarks" value="" style="width: 173px;" readonly="readonly">
			</td>
			<td class="rightAligned" >Rear</td>
			<td class="leftAligned"  >
				<!-- <input type="text" id="txtRear" name="txtRear" value="" style="width: 250px;" readonly="readonly"> -->
				<div style="border: 1px solid gray; height: 20px; width: 256px;">
					<textarea style="resize:none; width: 225px; border: none; height: 13px;" id="txtRear" name="txtRear" readonly="readonly" ignoreDelKey="true"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editRear" id="editRear" />
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >Construction</td>
			<td class="leftAligned"  >
				<input type="text" id="txtDspConstruction" name="txtDspConstruction" value="" style="width: 65px;" readonly="readonly">
				<input type="text" id="txtConstructionRemarks" name="txtConstructionRemarks" value="" style="width: 173px;" readonly="readonly">
			</td>
			<td class="rightAligned" ></td>
			<td class="leftAligned"  >
			</td>
		</tr>
	</table>
	<div class="buttonsDiv" style="margin-bottom: 10px">
		<input type="button" id="btnAddItem" 	name="btnAddItem" 		class="button"	value="Add" />
		<input type="button" id="btnDeleteItem" name="btnDeleteItem"	class="button"	value="Delete" />			
	</div>
</div>

<script type="text/javascript">
	// Added text editors - Nica 05.24.2013
	$("editTxtItemDesc").observe("click", function(){showEditor("txtItemDesc", 2000, 'true');});
	$("editTxtItemDesc2").observe("click", function(){showEditor("txtItemDesc2", 2000, 'true');});
	$("editFront").observe("click", function(){showEditor("txtFront", 2000, 'true');});
	$("editRight").observe("click", function(){showEditor("txtRight", 2000, 'true');});
	$("editLeft").observe("click", function(){showEditor("txtLeft", 2000, 'true');});
	$("editRear").observe("click", function(){showEditor("txtRear", 2000, 'true');});
</script>
