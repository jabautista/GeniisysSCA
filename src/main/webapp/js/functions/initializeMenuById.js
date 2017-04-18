function initializeMenuById(menuId) {
	ddsmoothmenu.init({
		mainmenuid: menuId, //menu DIV id - 
		orientation: 'h', //Horizontal or vertical menu: Set to "h" or "v"
		classname: 'ddsmoothmenu', //class added to menu's outer DIV
		contentsource: "markup" //"markup" or ["container_id", "path_to_menu_file"]
	});
}