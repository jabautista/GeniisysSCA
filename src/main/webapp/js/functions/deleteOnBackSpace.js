//Function to delete value on pressing backspace
// added func parameter, modified changeTag - irwin
function deleteOnBackSpace(code,desc,imgId,func){
	if (nvl(code,null) != null){
		$(code).observe("keyup", function(e) {
			if (nvl(imgId,null) != null){
				if($(imgId).next("img",0) == undefined){ //delete only when updatable
					if (objKeyCode.BACKSPACE == e.keyCode){
						if (nvl(code,null) != null)$(code).clear();
						if (nvl(desc,null) != null) $(desc).clear();
						if(func != null ){
							func();
						}
						changeTag = 1;
					}	
				}
			}else{
				if (objKeyCode.BACKSPACE == e.keyCode){
					if (nvl(code,null) != null) $(code).clear();
					if (nvl(desc,null) != null) $(desc).clear();
					if(func != null ){
						func();
					}
					changeTag = 1;
				}	
			}	
			
		});
	}
	if (nvl(desc,null) != null){
		$(desc).observe("keyup", function(e) {
			if (nvl(imgId,null) != null){
				if($(imgId).next("img",0) == undefined){ //delete only when updatable
					if (objKeyCode.BACKSPACE == e.keyCode){
						if (nvl(code,null) != null)$(code).clear();
						if (nvl(desc,null) != null) $(desc).clear();
						if(func != null ){
							func();
						}
						changeTag = 1;
					}	
				}
			}else{
				if (objKeyCode.BACKSPACE == e.keyCode){
					if (nvl(code,null) != null) $(code).clear();
					if (nvl(desc,null) != null) $(desc).clear();
					if(func != null ){
						func();
					}
					changeTag = 1;
				}	
			}	
			
		});
	}
}