<div style="text-align:right">
	Keyword&nbsp;&nbsp;<input type="text" id="txtKeyword" name="txtKeyword"/>
	<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchForObligeeByKeyword" name="searchForObligeeByKeyword" alt="Go" style="margin-top: 2px;" title="Search Obligee"/>
</div>
<div id="policyObligeeDiv" style="width:400px;margin:10px auto 10px auto;" ></div>
<div style="text-align:center;margin:5px auto auto auto;">
	<input type="button" class="button" id="btnReturn" value="Return" style="width:100px;"/>
	<input type="button" class="button" id="btnOk" value="OK" style="width:100px;"/>
</div>

<script>
	getPolicyObligeeList($("txtKeyword").value);

	$("searchForObligeeByKeyword").observe("click", function () {		
		getPolicyObligeeList($("txtKeyword").value);	
	});
	
	$("txtKeyword").observe("keydown", function(event){
		if(event.keyCode == objKeyCode.ENTER){
			getPolicyObligeeList($("txtKeyword").value);
		}
	});
</script>