<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="float: left" id="btnEditRemarks" alt="Go" />
<label name="closer" style="margin: 2px; display: none;" id="btnOkRemarks">Ok</label>

<script>
	$("btnOkRemarks").observe("click", function () {
		hideWysiwyg();
	});
</script>