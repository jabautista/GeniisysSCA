<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div style="margin: 10px; margin-bottom: 20px; float: left; width: 98.3%;">
	<span class="spanHeader"><label style="margin-bottom: 5px;">Assign Issue Sources</label></span>
	<div style="float: left; margin: 0 auto%; width: 100%;">
		<div style="float: left; margin: 0 auto; width: 100%;">
			<div style="margin: 0pt 2.5%; float: left; width: 95%;">
				<span style="width: 100%; margin-bottom: 3px; float: left;">
					<label style="margin-bottom: 5px; width: 53%;">Available Issue Sources</label>
					<label style="margin-bottom: 5px; width: 47%;">Current Issue Sources</label>
				</span>
				
				<div style="float: left; width: 47%;">
					<div id="issSourcesSelect" name="issSourcesSelect" class="issSourcesDiv" style="border: 1px solid #E0E0E0; width: 100%; padding: 0; float: left; margin-bottom: 1px; width: 100%; height: 200px; overflow-y: auto;">
					</div>
				</div>
				<div style="float: left; width: 5%; margin: 35px .5%;" class="optionTransferButtonsDiv">
					<div style="float: left; width: 100%;"><input type="button" value="&gt;&gt;"  	id="allRight3" 	class="button" style="width: 40px; margin-bottom: 5px;" /></div>
					<div style="float: left; width: 100%;"><input type="button" value="&gt;" 		id="right3"    	class="button" style="width: 40px; margin-bottom: 5px;" /></div>
					<div style="float: left; width: 100%;"><input type="button" value="&lt;" 		id="left3"		class="button" style="width: 40px; margin-bottom: 5px;" /></div>
					<div style="float: left; width: 100%;"><input type="button" value="&lt;&lt;" 	id="allLeft3" 	class="button" style="width: 40px; margin-bottom: 5px;" /></div>
				</div>
				<div style="float: left; width: 47%;">
					<div id="issSourcesSelect1" name="issSourcesSelect1" class="issSourcesDiv1" style="border: 1px solid #E0E0E0; width: 100%; padding: 0; float: left; margin-bottom: 1px; width: 100%; height: 200px; overflow-y: auto;">
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<div id="issSources" name="issSources" style="display: none;">
		<json:object>
			<json:array name="issSources" var="i" items="${issSources}">
				<json:object>
					<json:property name="issCd" 		value="${i.issCd}" />
					<json:property name="issName" 		value="${i.issName}" />
				</json:object>
			</json:array>
		</json:object>
	</div>
	
	<div id="grpIssSources" name="grpIssSources" style="display: none;">
		<json:object>
			<json:array name="grpIssSources" var="i" items="${grpIssSources}">
				<json:object>
					<json:property name="issCd" 		value="${i.issCd}" />
					<json:property name="issName" 		value="${i.issName}" />
					<json:property name="tranCd" 		value="${i.tranCd}" />
					<json:property name="userGrp" 		value="${i.userGrp}" />
				</json:object>
			</json:array>
		</json:object>
	</div>
</div>

<script type="text/javascript">
	$("allRight3").observe("click", function () {
		transferAllRight("issSourcesSelect", "issSourcesSelect1", "issSourcesDiv1", "issCds", removeCurrentLinesFromAvailable);
		clearDiv("lineSelect1");
		deselectRows("issSourcesSelect1", "row");
	});
	$("right3").observe("click", function () {
		transferRight("issSourcesSelect", "issSourcesSelect1", "issSourcesDiv1", "issCds", removeCurrentLinesFromAvailable);
		clearDiv("lineSelect1");
		deselectRows("issSourcesSelect1", "row");
	});
	$("left3").observe("click", function () {
		transferLeft("issSourcesSelect", "issSourcesSelect1", "issSourcesDiv", "issCds");
	});
	$("allLeft3").observe("click", function () {
		transferAllLeft("issSourcesSelect", "issSourcesSelect1", "issSourcesDiv", "issCds");
	});

	//grpIssSources = $("grpIssSources").innerHTML.evalJSON();
	//issSources = $("issSources").innerHTML.evalJSON();
	
	grpIssSources = eval((((('(' + $("grpIssSources").innerHTML + ')').replace(/&amp;/g, '&')).replace(/&gt;/g, '>')).replace(/&lt;/g, '<')));
	issSources = eval((((('(' + $("issSources").innerHTML + ')').replace(/&amp;/g, '&')).replace(/&gt;/g, '>')).replace(/&lt;/g, '<')));

	createIssTable();
	
	new Ajax.Updater("lineList", contextPath+"/GIISUserGroupMaintenanceController", {
		method: "GET",
		parameters: {
			action: "populateLinesOfBusiness",
			userGrp: $F("userGrpId")
		},
		evalScripts: true,
		asynchronous: false,
		onCreate: showNotice("Loading lines of business..."),
		onComplete: function () {
			hideNotice();
			initializeAll();
			initializeTable("transactionDiv", "row", "", "");
			initializeTable("transactionDiv1", "row", "", filterModulesIssSourcesByTranCd);
		}
	});
</script>