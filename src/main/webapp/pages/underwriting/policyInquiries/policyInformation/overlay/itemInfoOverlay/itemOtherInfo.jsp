<div style="text-align:center;margin:10px auto auto auto";>
	<textarea id="txtItemOtherInfo" rows="4" style="width:95%; resize:none;" readonly="readonly"></textarea>
	<input type="button" class="button" id="btnItemOtherInfoOk" value="OK" style="margin:10px auto 0px auto;width:50%"/>
</div>
<script>
	$("txtItemOtherInfo").value = $("hidItemOtherInfo").value;

	$("btnItemOtherInfoOk").observe("click", function(){
		overlayOtherInfo.close();
	});
</script>