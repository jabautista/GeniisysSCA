/**
 * @author rencela
 * @param kin
 * @param context
 * @param x
 * @param y
 * @param w
 * @param status
 * @param onclickfunction
 */
function makeSquareClickArea(kin, context, x, y, w, status, onclickfunction){
	kin.beginRegion();
	context.beginPath();
	context.moveTo(x, y);
	context.lineTo(x+w, y);          
	context.lineTo(x+w, y+w);
	context.lineTo(x, y+w);
	context.closePath();
	context.fill();
	context.stroke();
    
    if(status == "AVAILABLE"){
    	context.drawImage(objRoadmapImage.AVAILABLE_LOC_IMG,x,y);
    }else if(status == "CURRENT"){
    	context.drawImage(objRoadmapImage.CURRENT_LOC_IMG,x,y);
	}else if(status == "RESTRICTED" ){
		context.drawImage(objRoadmapImage.UNAVAILABLE_LOC_IMG,x,y);
	}else if(status == "INACCESSIBLE" ){
		context.drawImage(objRoadmapImage.INACCESSIBLE_LOC_IMG,x,y);
	}
    kin.closeRegion();
};