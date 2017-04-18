<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    response.setHeader("Cache-control", "No-Cache");
    response.setHeader("Pragma", "No-Cache");
%>

<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
		<label>Collection Breakdown</label>
		<span class="refreshers" style="margin-top: 0;">
   			<label name="gro" style="margin-left: 5px;">Hide</label>
   		</span>
	</div>
</div>

<div class="sectionDiv" id="collectionBreakdownOuterDiv" style="border-bottom: none;" changeTagAttr="true">
	<div id="gicdSumListTableGridSectionDiv" class="sectionDiv" style="height: 140px; border: none" align="center">
		<div id="gicdSumListTableGridDiv" style="padding: 10px; border: none" align="center">
			<div id="gicdSumListTableGrid" style="height: 100px; width: 685px; border: none" align="left"></div>
		</div>
	</div>
	
	<div class="sectionDiv" style="border-left: white; border-right: white; border-bottom: white;" id="collectionBreakdownDiv" style="margin-top: -2px;">
		<table width="900px" align="center" cellspacing="1" border="0">
			<tr>
				<td style="width: 360px">&nbsp</td>
				<td class="rightAligned" style="width: 200px;">Local Currency Amount Total</td>
				<td class="leftAligned">
					<input type="text" id="controlDspGicdSumAmt" name="controlDspGicdSumAmt" style="width: 130px; text-align: right" readonly="readonly" value=""/>
				</td>
				<td style="width: 230px">&nbsp</td>
			</tr>
			<tr>
				<td style="width: 360px"></td>
				<td class="rightAligned" style="width: 200px;">Foreign Currency Amount Total</td>
				<td class="leftAligned">
					<input type="text" id="gicdSumDspFcSumAmt" name="gicdSumDspFcSumAmt" style="width: 130px; text-align: right" readonly="readonly" value=""/>
				</td>
				<td style="width: 230px">&nbsp</td>
			</tr>
		</table>
	</div>
</div>