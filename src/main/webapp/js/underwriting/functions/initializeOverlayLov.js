/**
 * Initialize Overlay for LOV
 * @author Jerome Orio
 */
function initializeOverlayLov(id, title, width){
	try{
		$("contentHolder").setAttribute("src", id);
		$("contentHolder").setAttribute("lov", id);
		$("contentHolder").style.display = "block";
		$("contentHolder").style.position = "absolute";
		$("contentHolder").style.top = (document.documentElement.scrollTop+100) +"px";//(document.documentElement.scrollTop + (self.innerHeight - height) / 2) + 'px';
		$("contentHolder").style.left = ((self.innerWidth - width) / 2) + 'px';						
		$("contentHolder").style.width = width+"px";
		$("opaqueOverlay").style.display = "block";
		$("contentHolder").update(
			'<div style="width: 100%; float:left; height: 20px; background-color: #e8e8e8; " id="overlayTitleDiv">'+
				'<span style="width: 85%; float: left; height: 20px; line-height: 20px;">'+
					'<label style="width: 100%; float: left; margin-left: 5px; font-size: 11px; font-weight: bold;" id="overlayTitle"></label>'+
				'</span>'+
				'<span style="font-size: 10px; margin-right: 5px; width: 10%; float: right; height: 20px; line-height: 20px;"><label id="close" style="cursor: pointer; float: right;" onclick="hideOverlay();">Close</label></span>'+
			'</div>'+
			'<div id="filterLOVDiv" name="filterLOVDiv" style="float:left; width:'+(parseInt(width-20))+'px; margin:2px; margin-left:10px;">'+
				'<label style="float:left; width:60px; line-height: 20px;">Filter List</label> <input type="text" id="filterTextLOV" name="filterTextLOV" style="width:'+(parseInt(width-88))+'px;" />'+
			'</div>'+
			'<div id="lovListingMainDivHeader" style="float:left; border:1px solid #e8e8e8; background-color:#e8e8e8; display:none; width:'+(parseInt(width-20))+'px; height:20px; margin-left:10px;">'+
			'<div id="lovListingDivHeader" name="lovListingDivHeader" style="width:98%; margin:auto;"></div>'+
			'</div>'+
			'<div class="sectionDiv" id="lovListingDiv" name="lovListingDiv" style="padding-top:2px; float:left; display:block; width:'+(parseInt(width-20))+'px; height:253px; overflow:auto; margin-left:10px;">'+
			'</div>'+
			'<div style="width:'+(parseInt(width-20))+'px; margin-left:10px; float:left;">'+
				'<table align="center">'+
				'<tr><td><input type="button" class="button" style="width:60px;" id="btnOk'+id+'"  value="Ok"/>'+
				'<input type="button" class="button" style="width:60px; margin-left:2px;" id="btnCancel'+id+'"  value="Cancel"/></td></tr>'+
				'</table>'+
			'</div>');	
		$("overlayTitle").update(title.toUpperCase());
		$("filterTextLOV").observe("focus", function(){
			$("filterTextLOV").setStyle("border: 1px solid silver;");
		});
		$("filterTextLOV").observe("blur", function(){
			$("filterTextLOV").setStyle("border: 1px solid gray;");
		});
	}catch(e){
		showErrorMessage("initializeOverlayLov", e);
	}
}	