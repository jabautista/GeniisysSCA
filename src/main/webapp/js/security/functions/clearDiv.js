// clear content of a div
function clearDiv(divId) {
	$$("div#" + divId + " div[name='row']").invoke("remove");
}