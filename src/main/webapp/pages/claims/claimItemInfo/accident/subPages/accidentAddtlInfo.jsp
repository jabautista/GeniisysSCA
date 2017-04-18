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

<div id="accidentAddtlInfoDiv" name="accidentAddtlInfoDiv" class="sectionDiv" style="margin: 0px;">
	<div id="accidentItemInfogrid" style="position: relative; height: 206px; margin: auto; margin-top: 10px; width: 800px;"> </div>
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
				<td class="rightAligned" >Description</td>
				<td class="leftAligned" colspan="3" >
					<!-- <input type="text" id="txtItemDesc"  value="" style="width: 263px;" readonly="readonly"> -->
					<div style="border: 1px solid gray; height: 20px; width: 270px;">
						<textarea style="resize:none; width: 240px; border: none; height: 13px;" id="txtItemDesc" name="txtItemDesc" readonly="readonly" ignoreDelKey="true"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editTxtItemDesc" id="editTxtItemDesc" />
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 120px;">Grouped Item</td>
				<td class="leftAligned"  style="width: 300px;">
					<div id="grpItemNoDiv" style="width: 70px;" class="required withIconDiv">
						<input type="text" id="txtGrpItemNo" name="txtGrpItemNo" value="" style="width: 45px;" class="required withIcon integerUnformatted" maxlength="9" ignoreDelKey="true">
						<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="grpItemNo" name="grpItemNo" alt="Go" />
					</div>
					<input type="text" id="txtGrpItemTitle" name="txtGrpItemTitle" value="" style="width: 187px;" readonly="readonly">
				</td>
				<td class="rightAligned" ></td>
				<td class="leftAligned" colspan="3" >
					<!-- <input type="text" id="txtItemDesc2"  value="" style="width: 263px;" readonly="readonly"> -->
					<div style="border: 1px solid gray; height: 20px; width: 270px;">
						<textarea style="resize:none; width: 240px; border: none; height: 13px;" id="txtItemDesc2" name="txtItemDesc2" readonly="readonly" ignoreDelKey="true"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editTxtItemDesc2" id="editTxtItemDesc2" />
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Currency</td>
				<td class="leftAligned"  >
					<input type="text" id="txtCurrencyCd" name="txtCurrencyCd" value="" style="width: 65px; text-align: right;" readonly="readonly">
					<input type="text" id="txtDspCurrencyDesc" name="txtDspCurrencyDesc" value="" style="width: 187px;" readonly="readonly">
				</td>
				<td class="rightAligned" >Level</td>
				<td class="leftAligned" colspan="3" >
					<input type="text" id="txtLevel"  value="" style="width: 263px;" readonly="readonly" ignoreDelKey="true">
				</td>
			</tr>	
			<tr>
				<td class="rightAligned">Currency Rate</td>
				<td class="leftAligned">
					<input type="text" id="txtCurrencyRate" name="txtCurrencyRate" value="" style="width: 263px; text-align: right;" readonly="readonly">
				</td>
				<td class="rightAligned" >Salary Grade</td>
				<td class="leftAligned" colspan="3" >
					<input type="text" id="txtSalGrade"  value="" style="width: 263px;" readonly="readonly" ignoreDelKey="true">
				</td>
			</tr>	
			<tr>
				<td class="rightAligned" >Position</td>
				<td class="leftAligned"  >
					<input type="text" id="txtPositionCd" name="txtPositionCd" value="" style="width: 65px; text-align: right;" readonly="readonly" ignoreDelKey="true">
					<input type="text" id="txtDspPosition" name="txtDspPosition" value="" style="width: 187px;" readonly="readonly" ignoreDelKey="true">
				</td>
				<td class="rightAligned" >Date of Birth</td>
				<td class="leftAligned" colspan="3" >
					<input type="text" id="txtDateOfBirth"  value="" style="width: 263px;" readonly="readonly" ignoreDelKey="true">
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Monthly Salary</td>
				<td class="leftAligned" colspan="1" >
					<input type="text" id="txtMonthlySal" name="txtMonthlySal" value="" style="width: 263px; text-align: right;" readonly="readonly" ignoreDelKey="true">
				</td>
				<td class="rightAligned" >Civil Status</td>
				<td class="leftAligned" colspan="3" >
					<input type="text" id="txtDspCivilStat"  value="" style="width: 263px;" readonly="readonly" ignoreDelKey="true">
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Control Code</td>
				<td class="leftAligned"  >
					<input type="text" id="txtDspControlType" name="txtDspControlType" value="" style="width: 65px; text-align: right;" readonly="readonly" ignoreDelKey="true">
					<input type="text" id="txtControlCd" name="txtControlCd" value="" style="width: 187px;" readonly="readonly" ignoreDelKey="true">
				</td>
				<td class="rightAligned" >Sex</td>
				<td class="leftAligned" >
					<input type="text" id="txtDspSex"  value="" style="width: 110px;" readonly="readonly" ignoreDelKey="true">
				<td class="rightAligned" >Age</td>
				<td class="leftAligned" >
					<input type="text" id="txtAge"  value="" style="width: 110px;" readonly="readonly" ignoreDelKey="true">
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Amount of Coverage</td>
				<td class="leftAligned" colspan="3" >
					<input type="text" id="txtAmtCoverage"  value="" style="width: 263px;" readonly="readonly" ignoreDelKey="true">
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