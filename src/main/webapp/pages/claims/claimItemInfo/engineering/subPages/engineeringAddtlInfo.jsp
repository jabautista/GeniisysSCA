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
<div id="engineeringAddtlInfoDiv" name="engineeringAddtlInfoDiv" class="sectionDiv" style="margin: 0px;">
	<div id="addtlInfoGrid" style="position: relative; height: 206px; margin: auto; margin-top: 10px; width: 800px;"> </div>
	<table border="0" style="margin: auto; margin-top: 10px; margin-bottom: 10px;">
		<tr>
			<td class="rightAligned" >Item</td>
			<td class="leftAligned"   colspan="3">
				<div style="width: 90px;" class="required withIconDiv">
					<input type="text" id="txtItemNo" name="txtItemNo" value="" style="width: 65px;" class="required withIcon integerUnformatted" maxlength="9" ignoreDelKey="true">
					<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="itemNoDate" name="itemNoDate" alt="Go" />
				</div>
				<input type="text" id="txtItemTitle" name="txtItemTitle"  value="" style="width: 478px;" readonly="readonly">
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >Description</td>
			<td class="leftAligned"  colspan="3">
				<!-- <input type="text" id="txtItemDesc"	name="txtItemDesc"		value="" style="width: 577px;" readonly="readonly"/> -->
				<div style="border: 1px solid gray; height: 20px; width: 580px;">
					<textarea id="txtItemDesc" name="txtItemDesc" style="width: 95%; border: none; height: 13px;" readonly="readonly" ignoreDelKey="true"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editItemDesc" />
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >&nbsp;</td>
			<td class="leftAligned"  colspan="3">
				<!-- <input type="text" id="txtItemDesc2"	name="txtItemDesc2"		value="" style="width: 577px;" readonly="readonly"/> -->
				<div style="border: 1px solid gray; height: 20px; width: 580px;">
					<textarea id="txtItemDesc2" name="txtItemDesc2" style="width: 95%; border: none; height: 13px;" readonly="readonly" ignoreDelKey="true"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editItemDesc2" />
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned"">Currency</td>
			<td class="leftAligned" >
				<input type="text" id="txtCurrencyCd"	name="txtCurrencyCd"	value="" style="width: 84px; text-align: right;" readonly="readonly"/>
				<input type="text" id="txtDspCurrDesc"	name="txtDspCurrDesc"	value="" style="width: 170px;" readonly="readonly"/>
			</td>
			<td class="rightAligned" style="width: 65px;">Region</td>
			<td class="leftAligned" >
				<input type="text" id="txtDspRegion"	name="txtDspRegion"		value="" style="width: 223px;" readonly="readonly" ignoreDelKey="true"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >Currency Rate</td>
			<td class="leftAligned" >
				<input type="text" id="txtCurrencyRate"	name="txtCurrencyRate"	value="" style="width: 265px; text-align: right;" readonly="readonly"/>
			</td>
			<td class="rightAligned" >Province</td>
			<td class="leftAligned"  >
				<input type="text" id="txtDspProvince"	name="txtDspProvince"	value="" style="width: 223px;" readonly="readonly" ignoreDelKey="true"/>
			</td>
		</tr>
	</table>
	<div class="buttonsDiv" style="margin-bottom: 10px">
		<input type="button" id="btnAddItem" 	name="btnAddItem" 		class="button"	value="Add" />
		<input type="button" id="btnDeleteItem" name="btnDeleteItem"	class="button"	value="Delete" />			
	</div>
</div>
<script type="text/javascript">
	$("editItemDesc").observe("click", function(){
		showEditor("txtItemDesc", 2000, "true");
	});
	
	$("editItemDesc2").observe("click", function(){
		showEditor("txtItemDesc2", 2000, "true");
	});
</script>