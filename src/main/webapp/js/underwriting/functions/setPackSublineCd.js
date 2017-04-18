function setPackSublineCd(obj){
	var packLineCd = $("packLineCdOpt").value;
	$("packSublineCdOpt").update("");
	$("packSublineCdOpt").insert({bottom : '<option value="" packLineCd=""></option>'});
	/*for(var i=0;i<obj.length; i++){
		if(obj[i].packLineCd == packLineCd){
			var opt = '<option value="'+obj[i].packSublineCd+'" packLineCd="'+obj[i].packLineCd+'">'+obj[i].packSublineName+'</option>';
			$("packSublineCdOpt").insert({bottom : opt});
		}
	}*/
	for(var i=0;i<obj.length; i++){
		if(obj[i].packLineCd == packLineCd){
			var exists = false;
			$$("div#lineSublineList div[name='rowLineSubline']").each(function(row){
				var tempLineCd = nvl(row.getAttribute("packLineCd"),null)==null ? row.down("input", 0).value :
									row.getAttribute("packLineCd");  //edited by d.alcantara, 11.08.2012
				var tempSublineCd = row.down("input", 2).value;
				if(tempLineCd == packLineCd && tempSublineCd == obj[i].packSublineCd) {
					exists = true;
				} 
			});
			if(!exists) {
				if ($("packSublineCdOpt").getAttribute("moduleType") == "marketing"){ //added by steven 11/5/2012
					var opt = '<option value="'+obj[i].packSublineCd+'" packLineCd="'+obj[i].packLineCd+'" packSubLineName="'+obj[i].packSublineName+'" >'+obj[i].packSublineCd+'-'+obj[i].packSublineName+'</option>'; 
					$("packSublineCdOpt").insert({bottom : opt});
				}else{
					var opt = '<option value="'+obj[i].packSublineCd+'" packLineCd="'+obj[i].packLineCd+'">'+obj[i].packSublineName+'</option>'; 
					$("packSublineCdOpt").insert({bottom : opt});
				}
				
			}
		}
	}
	$("packSublineCdOpt").selectedIndex = 0;
}