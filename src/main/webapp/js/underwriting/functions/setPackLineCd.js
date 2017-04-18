//edited by d.alcantara, 11.08.2012
function setPackLineCd(obj){
	try{
		$("packLineCdOpt").update("");
		var filteredLine = getUniqueProperty(obj, 'packLineCd');
		var filteredLineName = getUniqueProperty(obj, 'packLineName');
		$("packLineCdOpt").insert({bottom : '<option value=""></option>'});
		
		for(var i = 0 ; i<filteredLine.length; i++){
			var opt = '<option value="'+filteredLine[i]+'" lineName="'+filteredLineName[i]+'">'+filteredLine[i]+'-'+filteredLineName[i]+'</option>';
			$("packLineCdOpt").insert({bottom : opt});
		}
		$("packLineCdOpt").selectedIndex = 0;
	}catch(e){
		showMessageBox("ERROR Occurred. setLineCd. "+e);
	}	
}