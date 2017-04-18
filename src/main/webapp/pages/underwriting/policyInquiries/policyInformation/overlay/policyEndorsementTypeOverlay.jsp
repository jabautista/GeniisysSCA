<div style="text-align:right">
	Keyword:<input type="text" id="txtKeyword" name="txtKeyword"/>
	<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchForEndorsementTypeByKeyword" name="searchForEndorsementTypeByKeyword" alt="Go" style="margin-top: 2px;" title="Search Endorsement"/>
</div>
<div id="policyEndorsementTypeDiv"></div>
<div>
	<input type="button" class="button" id="btnReturn" value="Return"/>
	<input type="button" class="button" id="btnOk" value="OK"/>
</div>
<script>
	getPolicyEndorsementTypeList($("txtKeyword").value);

	$("searchForEndorsementTypeByKeyword").observe("click", function () {		
		getPolicyEndorsementTypeList($("txtKeyword").value);	
	});

</script>
