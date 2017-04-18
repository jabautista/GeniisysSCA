<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="viewByObligeeMainDiv" name="viewByObligeeMainDiv" style="">

	<div id="regeneratePolicyDocumentsMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="parExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	
	<div class="sectionDiv">
		<div style="margin:10px 5px 5px auto;">
			<div style="width:93%;margin-left:5%;">
				Obligee Name&nbsp;&nbsp;
				<input type="hidden" name="txtObligeeNo" id="txtObligeeNo">
				<input type="text" id="txtObligeeName" name="txtObligeeName" style="width:700px;" readonly="readonly"/>
				<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchForObligee" name="searchForObligee" alt="Go" style="margin-top: 2px;" title="Search Policy"/>
			</div>
		</div>
		
		<div id="policyByObligeeDiv"  style="height:305px;width:900px;margin:10px auto 10px auto;"></div>
		
		<div style="text-align:center;margin:10px auto 20px auto">
			<input type="button" class="button" id="btnSummarizedInfo" name="btnSummarizedInfo" value="Summarized Information"/>
			<input type="button" class="button" id="btnPolEndtDetails" name="btnPolEndtDetails" value="Policy/Endorsement Details"/>
		</div>
	</div>
	
</div>

<script>
		getPolicyByObligeeTable();
		$("parExit").observe("click", showViewPolicyInformationPage);
		
		/* commented out by shan 03.25.2014
		 $("searchForObligee").observe("click", function(){
			overlayObligeeList = Overlay.show(contextPath+"/GIISObligeeController", {
				urlContent: true,
				urlParameters: {action : "showPolicyObligeeOverLay"},
				title: "Obligee",
				width: 416,
				height: 400,
				draggable: true
			});
		});		*/
		
		
		$("searchForObligee").observe("click", 
				function(){showGIISObligeeLOV("getGIISObligeeLOV", 
						function(row){
							$("txtObligeeNo").value = row.obligeeNo;
							$("txtObligeeName").value = unescapeHTML2(row.obligeeName);
							getPolicyByObligeeTable(row.obligeeNo);}
						);}
		);
</script>