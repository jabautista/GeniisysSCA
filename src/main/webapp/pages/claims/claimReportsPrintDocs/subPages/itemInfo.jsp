<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>


<div class="sectionDiv" id="thirdPartyDiv" name="thirdPartyDiv" style="height: 290px; width:450px; float: left;">
	<table style="margin-top: 20px;">
		<tr>
			<td class="rightAligned" style="width: 60px;" >Item</td>
			<td class="leftAligned" colspan="4">
				<input type="text" id="txtItemNo" name="txtItemNo" style="width: 50px;"/>
				<input type="text" id="txtItemTitle" name="txtItemTitle" style="width: 305px;"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 60px;" >Model</td>
			<td class="leftAligned" colspan="2">
				<input type="text" id="txtModelYr" name="txtModelYr" style="width: 80px;"/>
			</td>
			<td class="rightAligned" >Serial No.</td>
			<td class="leftAligned">
				<input type="text" id="serialNo" name="serialNo" style="width: 150px;"/>
			</td>

		</tr>
		<tr>
			<td class="rightAligned" style="width: 60px;" >Make</td>
			<td class="leftAligned" colspan="2">
				<input type="text" id="dspMake" name="dspMake" style="width: 140px;"/>
			</td>
			<td class="rightAligned" >Motor No.</td>
			<td class="leftAligned">
				<input type="text" id="motorNo" name="motorNo" style="width: 150px;"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 60px;" >Type</td>
			<td class="leftAligned" colspan="2">
				<input type="text" id="dspSublineType" name="dspSublineType" style="width: 140px;" />
			</td>
			<td class="rightAligned" >Plate No.</td>
			<td class="leftAligned">
				<input type="text" id="plateNo" name="plateNo" style="width: 150px;"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 60px;" >Color</td>
			<td class="leftAligned"  colspan="2">
				<input type="text" id="color" name="color" style="width: 140px;"/>
			</td>
			<td class="rightAligned" >MV File No.</td>
			<td class="leftAligned" colspan="2">
				<input type="text" id="mvFileNo" name="mvFileNo" style="width: 150px;" />
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 60px;" >Driver</td>
			<td class="leftAligned"  colspan="4">
				<input type="text" id="drvrName" name="drvrName" style="width: 367px;"/>
			</td>
		</tr>
	</table>
</div>


	

