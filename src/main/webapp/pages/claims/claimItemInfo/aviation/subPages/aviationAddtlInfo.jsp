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

<div id="aviationAddtlInfoDiv" name="aviationAddtlInfoDiv" class="sectionDiv" style="margin: 0px;">
	<div id="aviationItemInfogrid" style="position: relative; height: 206px; margin: auto; margin-top: 10px; width: 800px;"> </div>
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
				<td class="rightAligned" >Air Type</td>
				<td class="leftAligned" colspan="1" >
					<input type="text" id="txtDspAirType"  value="" style="width: 263px;" readonly="readonly">
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
				<td class="rightAligned" >RPC No.</td>
				<td class="leftAligned" colspan="1" >
					<input type="text" id="txtDspRcpNo"  value="" style="width: 263px;" readonly="readonly">
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
				<td class="rightAligned" >Fly Time</td>
				<td class="leftAligned" colspan="1" >
					<input type="text" id="txtTotalFlyTime"  value="" style="width: 263px;" readonly="readonly" ignoreDelKey="true">
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Currency</td>
				<td class="leftAligned"  >
					<input type="text" id="txtCurrencyCd" name="txtCurrencyCd" value="" style="width: 65px; text-align: right;" readonly="readonly">
					<input type="text" id="txtDspCurrencyDesc" name="txtDspCurrencyDesc" value="" style="width: 187px;" readonly="readonly">
				</td>
				<td class="rightAligned" >Prev. Utilization Hrs</td>
				<td class="leftAligned" colspan="1" >
					<input type="text" id="txtPrevUtilHrs"  value="" style="width: 263px;" readonly="readonly" ignoreDelKey="true">
				</td>
			</tr>	
			<tr>
				<td class="rightAligned">Currency Rate</td>
				<td class="leftAligned">
					<input type="text" id="txtCurrencyRate" name="txtCurrencyRate" value="" style="width: 263px; text-align: right;" readonly="readonly">
				</td>
				<td class="rightAligned" >Est. Utilization Hours</td>
				<td class="leftAligned" colspan="1" >
					<input type="text" id="txtEstUtilHrs"  value="" style="width: 263px;" readonly="readonly" ignoreDelKey="true">
				</td>
			</tr>	
			<tr>
				<td class="rightAligned" >Aircraft Name</td>
				<td class="leftAligned" colspan="1" >
					<input type="text" id="txtVesselName" name="txtVesselName" value="" style="width: 263px;" readonly="readonly">
				</td>
				<td class="rightAligned" >Qualification</td>
				<td class="leftAligned" colspan="1" >
					<!-- <input type="text" id="txtQualification"  value="" style="width: 263px;" readonly="readonly"> -->
					<div style="border: 1px solid gray; height: 20px; width: 270px;">
						<textarea style="resize:none; width: 240px; border: none; height: 13px;" id="txtQualification" name="txtQualification" readonly="readonly" ignoreDelKey="true"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editTxtQualification" id="editTxtQualification" />
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Purpose</td>
				<td class="leftAligned" colspan="1" >
					<!-- <input type="text" id="txtPurpose" value="" style="width: 263px;" readonly="readonly"> -->
					<div style="border: 1px solid gray; height: 20px; width: 270px;">
						<textarea style="resize:none; width: 240px; border: none; height: 13px;" id="txtPurpose" name="txtPurpose" readonly="readonly" ignoreDelKey="true"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editTxtPurpose" id="editTxtPurpose" />
					</div>
				</td>
				<td class="rightAligned" >Geography Limit</td>
				<td class="leftAligned" colspan="1" >
					<!-- <input type="text" id="txtGeogLimit"  value="" style="width: 263px;" readonly="readonly"> -->
					<div style="border: 1px solid gray; height: 20px; width: 270px;">
						<textarea style="resize:none; width: 240px; border: none; height: 13px;" id="txtGeogLimit" name="txtGeogLimit" readonly="readonly" ignoreDelKey="true"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editTxtGeogLimit" id="editTxtGeogLimit" />
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Excesses</td>
				<td class="leftAligned" colspan="1" >
					<!-- <input type="text" id="txtDeductText"  value="" style="width: 263px;" readonly="readonly"> -->
					<div style="border: 1px solid gray; height: 20px; width: 270px;">
						<textarea style="resize:none; width: 240px; border: none; height: 13px;" id="txtDeductText" name="txtDeductText" readonly="readonly" ignoreDelKey="true"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editTxtDeductText" id="editTxtDeductText" />
					</div>
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
	$("editTxtQualification").observe("click", function(){showEditor("txtQualification", 200, 'true');});
	$("editTxtPurpose").observe("click", function(){showEditor("txtPurpose", 200, 'true');});
	$("editTxtGeogLimit").observe("click", function(){showEditor("txtGeogLimit", 200, 'true');});
	$("editTxtDeductText").observe("click", function(){showEditor("txtDeductText", 200, 'true');});
	
</script>