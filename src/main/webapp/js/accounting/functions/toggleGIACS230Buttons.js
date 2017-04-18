function toggleGIACS230Buttons(enable) {
	if (nvl(enable, false) == true) {
		enableToolbarButton("btnToolbarEnterQuery");
		enableToolbarButton("btnToolbarExecuteQuery");
		enableToolbarButton("btnToolbarPrint");
		enableButton("btnMultiSort");
		enableButton("btnShowSl");
	} else {
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		disableToolbarButton("btnToolbarPrint");
		disableButton("btnMultiSort");
		disableButton("btnShowSl");
	}
}