<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="parListingMainDiv" name="parListingMainDiv" style="display:none;" module="parListing">
	<div id="parListingMenu">
	 	<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="parListingExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	

	<!-- <input type="hidden" id="lineCd" name="lineCd" value="${lineCd}" /> -->
	<input type="hidden" id="globalParId" 		name="globalParId" />
	<input type="hidden" id="globalIssCd" 		name="globalIssCd" />
	<input type="hidden" id="globalParStatus" 	name="globalParStatus" />
	<input type="hidden" id="globalParNo" 		name="globalParNo" />
	<input type="hidden" id="globalAssdNo" 		name="globalAssdNo" />
	<input type="hidden" id="globalAssdName" 	name="globalAssdName" />
	<input type="hidden" id="globalLineCd" 		name="globalLineCd" 	value="${lineCd}" />
	<input type="hidden" id="globalLineName" 	name="globalLineName" 	value="${lineName}" />
	<!-- input type="hidden" id="globalLineCd" 		name="globalLineCd" 	value="" />
	<input type="hidden" id="globalLineName" 	name="globalLineName" 	value="" /-->
	<input type="hidden" id="globalParType"     name="globalParType"  	value="P"/>
	
	<jsp:include page="/pages/common/utils/filter.jsp"></jsp:include>
	<jsp:include page="/pages/common/utils/search.jsp"></jsp:include>

	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	  		<label id="">List of Policy Action Records for ${lineName}</label>
	  		<!-- label id="">List of Policy Action Records</label-->
	  		<input type="hidden" id="menuLineCd" name="menuLineCd" value="${menuLineCd}" />
		</div>
	</div>
	
	<div id="parListingTable" align="center" class="sectionDiv tableContainer" style="border: 1px solid #E0E0E0; width: 100%; height: 410px; margin-top: 1px; margin-bottom: 20px; display: block;">
		<div id="dummyDiv"> <!-- dummy lang to para sa first load may fade effect pa rin - whofeih -->
		</div>
	</div>
</div>

<jsp:include page="/pages/underwriting/menus/basicInfoMenu.jsp"></jsp:include>
<div id="parInfoDiv" name="parInfoDiv" style="display: none;">
</div>

<script>
	//initializeMenuById("parInfoMenu");
	setModuleId("GIPIS001");
	initializePARBasicMenu();
	//added by Nok
	setDocumentTitle("PAR Listing");
	window.scrollTo(0,0); 	
	hideNotice("");
	
	$("keyword").observe("keypress", function (evt) {
		if (13 == evt.keyCode) {
			goToPageNo("parListingTable", "/GIPIPARListController?ajax=1&lineCd="+$F("globalLineCd"), "filterParListing", 1);
			//goToPageNo("parListingTable", "/GIPIPARListController?ajax=1&lineCd=", "filterParListing", 1);
		}
	});
	
	$("go").observe("click", function () {
		goToPageNo("parListingTable", "/GIPIPARListController?ajax=1&lineCd="+$F("globalLineCd"), "filterParListing", 1);
		//goToPageNo("parListingTable", "/GIPIPARListController?ajax=1&lineCd=", "filterParListing", 1);
	});

	// menus for par listing exit
	$("parListingExit").observe("click", function () {
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	
</script>