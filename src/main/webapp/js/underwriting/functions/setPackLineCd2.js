function setPackLineCd2(obj){ //added by steven for distinct lineCd.
	try{
		var lineCdTemp = "";
		$("packLineCdOpt").update("");
		//var filteredLine = getUniqueProperty(obj, 'packLineCd');
		//var filteredLineName = getUniqueProperty(obj, 'packLineName');
		$("packLineCdOpt").insert({bottom : '<option value=""></option>'});
		
		/*for(var i = 0 ; i<filteredLine.length; i++){
			var opt = '<option value="'+filteredLine[i]+'" lineName="'+filteredLineName[i]+'">'+filteredLine[i]+'-'+filteredLineName[i]+'</option>';
			$("packLineCdOpt").insert({bottom : opt});
		}*/
		if(obj != null) {
			for(var i = 0 ; i<obj.length; i++){
				if(lineCdTemp == "" || lineCdTemp != obj[i].packLineCd){
					var opt = '<option value="'+obj[i].packLineCd+'" lineName="'+obj[i].packLineName+'" subline="'+obj[i].packSublineCd+'">'+
					obj[i].packLineCd+'-'+obj[i].packLineName+'</option>';
					$("packLineCdOpt").insert({bottom : opt});
					lineCdTemp = obj[i].packLineCd;
				}
			}
		}
		$("packLineCdOpt").selectedIndex = 0;
		
	}catch(e){
		showMessageBox("ERROR Occurred. setLineCd2. "+e);
	}	
}