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
<div id="marineCargoAddtlInfoDiv" name="marineCargoAddtlInfoDiv" class="sectionDiv" style="margin: 0px;">
	<div id="marineCargoItemInfogrid" style="position: relative; height: 206px; margin: auto; margin-top: 10px; width: 800px;"> </div>
	<div style="width: 100%;">
		<table border="0" style="margin-top: 50px; margin-bottom: 10px;" align="center">
			<tr>
				<td class="rightAligned" style="width: 120px;">Item</td>
				<td class="leftAligned"  style="width: 300px;">
					<div style="width: 70px;" class="required withIconDiv">
						<input type="text" id="txtItemNo" name="txtItemNo" value="" style="width: 45px;" class="required withIcon integerUnformatted" maxlength="9" ignoreDelKey="true">
						<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="itemNoDate" name="itemNoDate" alt="Go" />
					</div>
					<input type="text" id="txtItemTitle" name="txtItemTitle" value="" style="width: 187px;" readonly="readonly">
				</td>
				<td class="rightAligned" >Cargo Class</td>
				<td class="leftAligned" colspan="1" >
					<input type="text" id="txtCargoClassDesc" name="txtCargoClassDesc" value="" style="width: 263px;" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Description</td>
				<td class="leftAligned" colspan="1" >
					<!-- <input type="text" id="txtItemDesc" name="txtItemDesc" value="" style="width: 263px;" readonly="readonly"> -->
					<div style="border: 1px solid gray; height: 20px; width: 270px;">
						<textarea style="resize:none; width: 240px; border: none; height: 13px;" id="txtItemDesc" name="txtItemDesc" readonly="readonly" ignoreDelKey="true"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editTxtItemDesc" id="editTxtItemDesc" />
					</div>
				</td>
				<td class="rightAligned" >Voyage No.</td>
				<td class="leftAligned" colspan="1" >
					<input type="text" id="txtVoyageNo"  value="" style="width: 263px;" readonly="readonly" ignoreDelKey="true">
				</td>
			</tr>	
			<tr>
				<td class="rightAligned" ></td>
				<td class="leftAligned" colspan="1" >
					<!-- <input type="text" id="txtItemDesc2" name="txtItemDesc2" value="" style="width: 263px;" readonly="readonly"> -->
					<div style="border: 1px solid gray; height: 20px; width: 270px;">
						<textarea style="resize:none; width: 240px; border: none; height: 13px;" id="txtItemDesc2" name="txtItemDesc2" readonly="readonly" ignoreDelKey="true"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editTxtItemDesc2" id="editTxtItemDesc2" />
					</div>
				</td>
				<td class="rightAligned" >LC No.</td>
				<td class="leftAligned" colspan="1" >
					<input type="text" id="txtLcNo"  value="" style="width: 263px;" readonly="readonly" ignoreDelKey="true">
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Currency</td>
				<td class="leftAligned"  >
					<input type="text" id="txtCurrencyCd" name="txtCurrencyCd" value="" style="width: 65px; text-align: right;" readonly="readonly">
					<input type="text" id="txtDspCurrencyDesc" name="txtDspCurrencyDesc" value="" style="width: 187px;" readonly="readonly">
				</td>
				<td class="rightAligned" >BL/AWB</td>
				<td class="leftAligned" colspan="1" >
					<input type="text" id="txtBlAwb"  value="" style="width: 263px;" readonly="readonly" ignoreDelKey="true">
				</td>
			</tr>	
			<tr>
				<td class="rightAligned">Currency Rate</td>
				<td class="leftAligned">
					<input type="text" id="txtCurrencyRate" name="txtCurrencyRate" value="" style="width: 263px; text-align: right;" readonly="readonly">
				</td>
				<td class="rightAligned" >Cargo Type</td>
				<td class="leftAligned" colspan="1" >
					<input type="text" id="txtCargoTypeDesc"  value="" style="width: 263px;" readonly="readonly">
				</td>
			</tr>	
			<tr>
				<td class="rightAligned" >Carrier</td>
				<td class="leftAligned" colspan="1" >
					<input type="text" id="txtVesselName" name="txtVesselName" value="" style="width: 263px;" readonly="readonly">
				</td>
				<td class="rightAligned" >Origin</td>
				<td class="leftAligned" colspan="1" >
					<input type="text" id="txtOrigin"  value="" style="width: 263px;" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Geog. Description</td>
				<td class="leftAligned" colspan="1" >
					<input type="text" id="textGeogDesc" name="textGeogDesc" value="" style="width: 263px;" readonly="readonly">
				</td>
				<td class="rightAligned" >Destination</td>
				<td class="leftAligned" colspan="1" >
					<input type="text" id="txtDestn"  value="" style="width: 263px;" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Type of Packing</td>
				<td class="leftAligned" colspan="1" >
					<input type="text" id="txtPackMethod"  value="" style="width: 263px;" readonly="readonly" ignoreDelKey="true">
				</td>
				<td class="rightAligned" >ETD</td>
				<td class="leftAligned" colspan="1" >
					<input type="text" id="txtEtd"  value="" style="width: 263px;" readonly="readonly" ignoreDelKey="true">
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Transhipment Origin</td>
				<td class="leftAligned" colspan="1" >
					<input type="text" id="txtTranshipmentOrigin"  value="" style="width: 263px;" readonly="readonly" ignoreDelKey="true">
				</td>
				<td class="rightAligned" >ETA</td>
				<td class="leftAligned" colspan="1" >
					<input type="text" id="txtEta"  value="" style="width: 263px;" readonly="readonly" ignoreDelKey="true">
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Transhipment Destn</td>
				<td class="leftAligned" colspan="1" >
					<input type="text" id="txtTranshipmentDestination"  value="" style="width: 263px;" readonly="readonly" ignoreDelKey="true">
				</td>
				<td class="rightAligned" >Deductible/Remarks</td>
				<td class="leftAligned" colspan="1" >
					<input type="text" id="txtDeductText"  value="" style="width: 263px;" readonly="readonly" ignoreDelKey="true">
				</td>
			</tr>
		</table>
	</div>
	<div class="buttonsDiv" style="margin-bottom: 10px">
		<input type="button" id="btnAddItem" 	name="btnAddItem" 		class="button"	value="Add" />
		<input type="button" id="btnDeleteItem" name="btnDeleteItem"	class="button"	value="Delete" />			
	</div>
</div>

<script type="text/javascript">
	// Added text editor - Nica 05.24.2013
	$("editTxtItemDesc").observe("click", function(){showEditor("txtItemDesc", 2000, 'true');});
	$("editTxtItemDesc2").observe("click", function(){showEditor("txtItemDesc2", 2000, 'true');});
</script>