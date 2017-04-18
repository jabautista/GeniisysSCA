<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="packParListingMainDiv" name="packParListingMainDiv" style="display: none;" module="packParListing">
	<div id="packParListingMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="packParListingExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<input type="hidden" 	id="globalLineCd" 		name="globalLineCd" 	value="${lineCd}"/>
	<input type="hidden" 	id="globalLineName" 	name="globalLineName" 	value="${lineName}"/>
	<input type="hidden"	id="globalParType" 		name="globalParType" 	value="P">
	
	<jsp:include page="/pages/common/utils/filter.jsp"></jsp:include>
	<jsp:include page="/pages/common/utils/search.jsp"></jsp:include>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label id="">List of Package Policy Action Records for ${lineName }</label>
			<input type="hidden" id="menuLineCd" name="menuLineCd" value="${menuLineCd}">
		</div>
	</div>
	
	<div id="packParListingTable" align="center" class="sectionDiv tableContainer" style="border: 1px solid #E0E0E0; width: 100%; height: 410px; margin-top: 1px; margin-bottom: 20px; display: block;">
		<div id="dummyDiv">
		</div>
	</div>
</div>

<jsp:include page="/pages/underwriting/menus/basicInfoMenu.jsp"></jsp:include>
<div id="parInfoDiv" name="parInfoDiv" style="display: none;"></div>

<script>
	setModuleId("GIPIS001A");
	initializePackPARBasicMenu();

	$("keyword").observe("keypress", function (evt) {
		if (13 == evt.keyCode) {
			goToPageNo("packParListingTable", "/GIPIPackPARListController?ajax=1&lineCd="+objUWGlobal.lineCd+"&parType=P", "showPackParList", 1);
		}
	});
	
	$("go").observe("click", function () {
		goToPageNo("packParListingTable", "/GIPIPackPARListController?ajax=1&lineCd="+objUWGlobal.lineCd+"&parType=P", "showPackParList", 1);
	});

	$("packParListingExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});

</script>