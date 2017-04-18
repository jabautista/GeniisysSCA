// change the color of the check image depending on the color theme
function changeCheckImageColor() {
	$$("img[name='checkedImg']").each(function (img) {
		img.writeAttribute("src", checkImgSrc);
	});
}