<div style="margin-top: 5px; padding-bottom: 15px; " class="sectionDiv">
	<div style="margin-top: 15px; margin-left: 1%;">This Policy No. :</div>
	<div style="margin-top: 5px; margin-left: 17%;"><label style="color: blue; ">${policy}</label></div>
	<div style="margin-top: 30px; margin-left: 1%;">Has Been Copied to PAR No. :</div>
	<div style="margin-top: 5px; margin-left: 23%;"><label style="color: red;">${par}</label></div>
</div>
<div class="buttonsDiv" style="margin-bottom: 0px;">
	<input type="button" class="button" id="btnOk" value="Ok" style="width: 50px;">
</div>

<script>
var isPack = '${isPack}';
$("btnOk").observe("click",function(){			
	summaryOverlay.close();
	if (isPack == 'N') { //steven - 5/9/2013
		showSummarizePolicy();
	}else{
		showCopyPackagePolicy(); //marco - 04.30.2013
	}
});
</script>