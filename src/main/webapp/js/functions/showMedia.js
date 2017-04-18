// used by attached media
function showMedia(obj) {
	try{
		document.getElementById("contentHolder").innerHTML = "";
		document.getElementById("opaqueOverlay").style.display = "block";
		$("contentHolder").setStyle("width: 550px;");
		$("contentHolder").insert('<span style="cursor: pointer; position: absolute; right: 0; padding: 3px; border: 1px solid #c0c0c0; background-color: #c0c0c0; font-size: 9px; z-index: 100; margin: 5px;" onclick="hideOverlay();">Close</span>'+
								  '<img src="'+obj.up("div", 0).down("a", 0).readAttribute("href")+'" style="height: 400px; width: 550px;" />');
		//var newImg = new Image();
		//newImg.src = obj.up("div", 0).down("a", 0).readAttribute("href");
		//curHeight = newImg.height;
		//curWidth = newImg.width;
		
		/*var x,y; 
		if (self.innerHeight) { // all except Explorer  
			x = self.innerWidth; y = self.innerHeight; 
		} else if (document.documentElement && document.documentElement.clientHeight) {// Explorer 6 Strict Mode 
			x = document.documentElement.clientWidth; 
			y = document.documentElement.clientHeight; 
		} else if (document.body) {// other Explorers  
			x = document.body.clientWidth; 
			y = document.body.clientHeight; 
		}*/
		
		/*
		document.getElementById("contentHolder").style.left = "223px";
		document.getElementById("contentHolder").style.top = "100px";
		document.getElementById("contentHolder").style.display = "block";
		*/
		Effect.ScrollTo("notice", {duration: .2});
		var m = ((screen.width / 2) - (550 / 2)) - (screen.width*.058);
		document.getElementById("contentHolder").style.marginLeft = m+"px";
		document.getElementById("contentHolder").style.marginRight = m+"px";
		document.getElementById("contentHolder").style.top = "100px";
		document.getElementById("contentHolder").style.display = "block";
	}catch(e){
		showErrorMessage("showMedia", e);
		document.getElementById("opaqueOverlay").style.display = "none";
	}
}