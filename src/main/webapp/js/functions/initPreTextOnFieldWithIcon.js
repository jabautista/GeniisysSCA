function initPreTextOnFieldWithIcon(imgId, id){
	var preText = "";
	$(id).setAttribute("pre-text", $(id).value);
	$(imgId).observe("click", function () {
		preText = $(id).value;
		$(id).setAttribute("pre-text", preText);
	});
}