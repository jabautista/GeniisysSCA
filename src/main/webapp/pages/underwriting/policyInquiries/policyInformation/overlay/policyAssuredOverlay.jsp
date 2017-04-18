<div style="text-align:right; margin-top: 5px;">
	Keyword&nbsp;&nbsp;<input type="text" id="txtKeyword" name="txtKeyword"/>
	<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchForAssuredByKeyword" name="searchForAssuredByKeyword" alt="Go" style="margin-top: 2px;" title="Search Assured"/>
</div>
<div id="policyAssuredDiv" style="margin-top: 5px;"></div>
<div style="text-align: center; padding-top: 15px; border: 0px;" class="sectionDiv">
	<input type="button" class="button" id="btnReturn" value="Return" style="width:100px;"/>
	<input type="button" class="button" id="btnOk" value="OK" style="width:100px;"/>
</div>
<script>
	getPolicyAssuredList($("txtKeyword").value);

	$("searchForAssuredByKeyword").observe("click", function () {		
		getPolicyAssuredList($("txtKeyword").value);	
	});
	
	$("txtKeyword").observe("keydown", function(event){
		if(event.keyCode == objKeyCode.ENTER){
			getPolicyAssuredList($("txtKeyword").value);
		}
	});

</script>
