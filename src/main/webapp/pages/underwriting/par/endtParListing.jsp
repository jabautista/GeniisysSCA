<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="parListingMainDiv" name="parListingMainDiv" style="display: none;">

 	<div id="parListingMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="endtParListingExit">Exit</a></li>
				</ul>
			</div>
		</div> 
	</div> 

	<input type="hidden" id="lineCd" 			name="lineCd" value="${lineCd}" />
	<input type="hidden" id="lineName" 			name="lineCd" value="${lineName}" />
	<input type="hidden" id="globalParId" 		name="globalParId" />
	<input type="hidden" id="globalIssCd" 		name="globalIssCd" />
	<input type="hidden" id="globalParStatus" 	name="globalParStatus" />
	<input type="hidden" id="globalParNo" 		name="globalParNo"/>
	<input type="hidden" id="globalParYy" 		name="globalParYy" />
	<input type="hidden" id="globalParType" 	name="globalParType" value="E"/>
	<input type="hidden" id="globalRemarks"		name="globalRemarks" />
	<input type="hidden" id="globalUnderwriter" name="globalUnderwriter" />
	<!-- <input type="hidden" id="globalEndtAssdNo" name="globalEndtAssdNo"/>
	<input type="hidden" id="globalEndtAssdName" name="globalEndtAssdName" />
	<input type="hidden" id="globalEndtPolFlag" name="globalEndtPolFlag" />
	<input type="hidden" id="globalEndtOpFlag" name="globalEndtOpFlag" />-->
	<input type="hidden" id="globalLineCd" 		name="globalLineCd" 	value="${lineCd}" />
	<input type="hidden" id="globalLineName" 	name="globalLineName" 	value="${lineName}" />
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	  		<label id="">List of Endorsement Policy Action Records for ${lineName}</label>
		</div>
	</div>
	
	<jsp:include page="/pages/common/utils/filter.jsp"></jsp:include>
	<jsp:include page="/pages/common/utils/search.jsp"></jsp:include>
	
	<div id="endtParListingTable" align="center" class="sectionDiv tableContainer" style="border: 1px solid #E0E0E0; width: 100%; height: 410px; margin-top: 1px; margin-bottom: 20px; display: block;">
		<div id="dummyDiv"> <!-- dummy lang to para sa first load may fade effect pa rin - whofeih -->
		</div>
	</div>
</div>
<jsp:include page="/pages/underwriting/menus/basicInfoMenu.jsp"></jsp:include>
<div id="parInfoDiv" name="parInfoDiv" style="display: none;">
</div>

<script type="text/javascript">
	setModuleId("GIPIS058");
	initializePARBasicMenu();
	
	$("keyword").observe("keypress", function (evt) {
		if (13 == evt.keyCode) {
			goToPageNo("endtParListingTable", "/GIPIPARListController?ajax=1&lineCd="+$F("lineCd"), "filterEndtParListing", 1);
		}
	});
	
	$("go").observe("click", function () {
		goToPageNo("endtParListingTable", "/GIPIPARListController?ajax=1&lineCd="+$F("lineCd"), "filterEndtParListing", 1);		
	});

	// menus for par listing
	$("endtParListingExit").observe("click", function () {
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
</script>