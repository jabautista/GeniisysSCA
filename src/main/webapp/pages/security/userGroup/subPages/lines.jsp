<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div style="margin: 10px; margin-bottom: 20px; float: left; width: 98.3%;">
	<span class="spanHeader"><label style="margin-bottom: 5px;">Assign Line of Business</label></span>
	<div style="float: left; margin: 0 auto%; width: 100%;">
		<div style="float: left; margin: 0 auto; width: 100%;">
			<div style="margin: 0pt 2.5%; float: left; width: 95%;">
				<span style="width: 100%; margin-bottom: 3px; float: left;">
					<label style="margin-bottom: 5px; width: 53%;">Available Line of Business</label>
					<label style="margin-bottom: 5px; width: 47%;">Current Line of Business</label>
				</span>
				
				<div style="float: left; width: 47%;">
					<div id="lineSelect" name="lineSelect" class="lineDiv" style="border: 1px solid #E0E0E0; width: 100%; padding: 0; float: left; margin-bottom: 1px; width: 100%; height: 200px; overflow-y: auto;">
					</div>
				</div>
				<div style="float: left; width: 5%; margin: 35px .5%;" class="optionTransferButtonsDiv">
					<div style="float: left; width: 100%;"><input type="button" value="&gt;&gt;"  	id="allRight4" 	class="button" style="width: 40px; margin-bottom: 5px;" /></div>
					<div style="float: left; width: 100%;"><input type="button" value="&gt;" 		id="right4"    	class="button" style="width: 40px; margin-bottom: 5px;" /></div>
					<div style="float: left; width: 100%;"><input type="button" value="&lt;" 		id="left4"		class="button" style="width: 40px; margin-bottom: 5px;" /></div>
					<div style="float: left; width: 100%;"><input type="button" value="&lt;&lt;" 	id="allLeft4" 	class="button" style="width: 40px; margin-bottom: 5px;" /></div>
				</div>
				<div style="float: left; width: 47%;">
					<div id="lineSelect1" name="lineSelect1" class="lineDiv1" style="border: 1px solid #E0E0E0; width: 100%; padding: 0; float: left; margin-bottom: 1px; width: 100%; height: 200px; overflow-y: auto;">
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<div id="lines" name="lines" style="display: none;">
		<json:object>
			<json:array name="lines" var="l" items="${lines}">
				<json:object>
					<json:property name="lineCd" 		value="${l.lineCd}" />
					<json:property name="lineName" 		value="${l.lineName}" />
				</json:object>
			</json:array>
		</json:object>
	</div>
	
	<div id="curLines" name="curLines" style="display: none;">
		<json:object>
			<json:array name="curLines" var="l" items="${curLines}">
				<json:object>
					<json:property name="lineCd" 		value="${l.lineCd}" />
					<json:property name="lineName" 		value="${l.lineName}" />
					<json:property name="userGrp" 		value="${l.userGrp}" />
					<json:property name="tranCd" 		value="${l.tranCd}" />
					<json:property name="issCd" 		value="${l.issCd}" />
				</json:object>
			</json:array>
		</json:object>
	</div>
</div>

<script type="text/javascript">
	$("allRight4").observe("click", function () {
		transferAllRight("lineSelect", "lineSelect1", "lineDiv1", "lineCds", "");
		deselectRows("lineSelect1", "row");
	});
	$("right4").observe("click", function () {
		transferRight("lineSelect", "lineSelect1", "lineDiv1", "lineCds", "");
		deselectRows("lineSelect1", "row");
	});
	$("left4").observe("click", function () {
		transferLeft("lineSelect", "lineSelect1", "lineDiv", "lineCds");
	});
	$("allLeft4").observe("click", function () {
		transferAllLeft("lineSelect", "lineSelect1", "lineDiv", "lineCds");
	});

	//lines = $("lines").innerHTML.evalJSON();
	//curLines = $("curLines").innerHTML.evalJSON();

	lines = eval((((('(' + $("lines").innerHTML + ')').replace(/&amp;/g, '&')).replace(/&gt;/g, '>')).replace(/&lt;/g, '<')));
	curLines = eval((((('(' + $("curLines").innerHTML + ')').replace(/&amp;/g, '&')).replace(/&gt;/g, '>')).replace(/&lt;/g, '<')));
	
	createLinesTable();
</script>