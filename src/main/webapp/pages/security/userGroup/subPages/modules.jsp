<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div style="margin: 10px; margin-bottom: 20px; float: left; width: 98.3%;">
	<span class="spanHeader"><label style="margin-bottom: 5px;">Assign Modules</label></span>
	<div style="float: left; margin: 0 auto%; width: 100%;">
		<div style="float: left; margin: 0 auto; width: 100%;">
			<div style="margin: 0pt 2.5%; float: left; width: 95%;">
				<span style="width: 100%; margin-bottom: 3px; float: left;">
					<label style="margin-bottom: 5px; width: 53%;">Available Modules</label>
					<label style="margin-bottom: 5px; width: 47%;">Current Modules</label>
				</span>
				
				<div style="float: left; width: 47%;">
					<div id="moduleSelect" name="moduleSelect" class="moduleDiv" style="border: 1px solid #E0E0E0; width: 100%; padding: 0; float: left; margin-bottom: 1px; width: 100%; height: 200px; overflow-y: auto;">
					</div>
				</div>
				<div style="float: left; width: 5%; margin: 35px .5%;" class="optionTransferButtonsDiv">
					<div style="float: left; width: 100%;"><input type="button" value="&gt;&gt;"  	id="allRight2" 	class="button" style="width: 40px; margin-bottom: 5px;" /></div>
					<div style="float: left; width: 100%;"><input type="button" value="&gt;" 		id="right2"    	class="button" style="width: 40px; margin-bottom: 5px;" /></div>
					<div style="float: left; width: 100%;"><input type="button" value="&lt;" 		id="left2"		class="button" style="width: 40px; margin-bottom: 5px;" /></div>
					<div style="float: left; width: 100%;"><input type="button" value="&lt;&lt;" 	id="allLeft2" 	class="button" style="width: 40px; margin-bottom: 5px;" /></div>
				</div>
				<div style="float: left; width: 47%;">
					<div id="moduleSelect1" name="moduleSelect1" class="moduleDiv1" style="border: 1px solid #E0E0E0; width: 100%; padding: 0; float: left; margin-bottom: 1px; width: 100%; height: 200px; overflow-y: auto;">
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<div id="tModules" name="tModules" style="display: none;">
		<json:object>
			<json:array name="tModules" var="m" items="${modules}">
				<json:object>
					<json:property name="moduleId" 		value="${m.moduleId}" />
					<json:property name="moduleDesc" 	value="${m.moduleDesc}" />
					<json:property name="tranCd" 		value="${m.tranCd}" />
				</json:object>
			</json:array>
		</json:object>
	</div>
	
	<div id="grpModules" name="grpModules" style="display: none;">
		<json:object>
			<json:array name="grpModules" var="m" items="${grpModules}">
				<json:object>
					<json:property name="moduleId" 		value="${m.moduleId}" />
					<json:property name="moduleDesc" 	value="${m.moduleDesc}" />
					<json:property name="userGrp"	 	value="${m.userGroup}" />
					<json:property name="tranCd" 		value="${m.tranCd}" />
				</json:object>
			</json:array>
		</json:object>
	</div>
</div>
<script type="text/javascript">
	$("allRight2").observe("click", function () {
		transferAllRight("moduleSelect", "moduleSelect1", "moduleDiv1", "moduleIds", "");
	});
	$("right2").observe("click", function () {
		transferRight("moduleSelect", "moduleSelect1", "moduleDiv1", "moduleIds", "");
	});
	$("left2").observe("click", function () {
		transferLeft("moduleSelect", "moduleSelect1", "moduleDiv", "moduleIds");
	});
	$("allLeft2").observe("click", function () {
		transferAllLeft("moduleSelect", "moduleSelect1", "moduleDiv", "moduleIds");
	});

	//tModules = $("tModules").innerHTML.evalJSON();
	//grpModules = $("grpModules").innerHTML.evalJSON();
	
	grpModules = eval((((('(' + $("grpModules").innerHTML + ')').replace(/&amp;/g, '&')).replace(/&gt;/g, '>')).replace(/&lt;/g, '<')));
	tModules = eval((((('(' + $("tModules").innerHTML + ')').replace(/&amp;/g, '&')).replace(/&gt;/g, '>')).replace(/&lt;/g, '<')));

	createModulesTable();
	
	new Ajax.Updater("issueList", contextPath+"/GIISUserGroupMaintenanceController", {
		method: "GET",
		parameters: {
			action: "populateIssueSources",
			userGrp: $F("userGrpId")
		},
		evalScripts: true,
		asynchronous: false,
		onCreate: showNotice("Loading issue sources..."),
		onComplete: function () {
			// Populate line of business
		}
	});	
</script>