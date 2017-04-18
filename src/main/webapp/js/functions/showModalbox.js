// show modalbox
// parameters: 
// url: url to call via ajax
// parameters: parameters to be appended to the url
// width: width of the modalbox
// title: title of the modalbox to be opened
function showModalbox(url, params, width, title) {
	Modalbox.show(url+params, {title: title, width: width});
}