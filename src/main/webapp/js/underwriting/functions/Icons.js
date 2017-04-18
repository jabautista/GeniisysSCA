/**
 * @returns {Icons}
 */
function Icons(){
	this.initializeStyles = function(context){
		context.fillStyle = "#000000";
		context.strokeStyle = "#000000";
	};
	
	this.available = function(context,x,y){
		this.initializeStyles(context);
		var fillStyleCache		= context.fillStyle;
		var strokeStyleCache	= context.strokeStyle;
		context.beginPath();
		context.moveTo(x, y);		context.lineTo(x+6, y);
		context.lineTo(x+6, y+2);	context.lineTo(x+13, y+2);
		context.lineTo(x+13, y+11);	context.lineTo(x, y+11);
		context.closePath();
		context.fillStyle = "#F3F781";	context.fill();
		strokeStyle = "#F3F781";
		context.stroke();
		
		var x1=x; var y1=y+12;
		context.beginPath();
		context.moveTo(x1, y1);
		context.lineTo(x1+5,  y1-5);	context.lineTo(x+9,  y1-5);
		context.lineTo(x1+10, y1-6);	context.lineTo(x+16, y1-6);
		context.lineTo(x1+16, y1-5);	context.lineTo(x+12, y1);
		context.closePath();
		context.fillStyle = "#AEB404";	context.fill();
		strokeStyle = "#FFFFFF";
		context.stroke();	context.fill();
		context.fillStyle = fillStyleCache; //reset style
		context.strokeStyle = strokeStyleCache;
	};
	this.restricted = function(context,x,y){
		this.initializeStyles(context);
		this.available(context, x, y);
		var fillStyleCache = context.fillStyle;
		var strokeStyleCache = context.strokeStyle;
		var x1 = x + 15; y1 = y;
		context.beginPath();
		context.moveTo(x1, y1);
		context.lineTo(x1 + 2, y1);		context.lineTo(x1 - 13, y1 + 15);
		context.lineTo(x1-15, y1+15);	context.closePath();
		context.fillStyle = "#FF0A0A";	context.strokeStyle = "#FF0A0A";
		context.fill();		context.stroke();
		context.fillStyle = fillStyleCache;
		context.strokeStyle = strokeStyleCache;
	};
	this.inaccessible = function(context,x,y){
		this.initializeStyles(context);
		var fillStyleCache = context.fillStyle;
		var strokeStyleCache = context.strokeStyle;
		y = y+7;	x = x+7;
		context.fillStyle="#FE1F01";	context.strokeStyle="FE1F01";
		context.beginPath();
		context.arc(x, y, 7.5, 0, Math.PI*2, true);
		context.closePath();	context.fill();
		context.stroke();
		context.fillStyle="#FFFFFF";	context.strokeStyle="#FFFFFF";
		var x1 = x - 4; y1 = y-1;
		context.beginPath();
		context.moveTo(x1,  y1);
		context.lineTo(x1 + 8, y1);	context.lineTo(x1 + 8, y1 + 3);
		context.lineTo(x1, y1 + 3);	context.closePath();
		context.fill();				context.stroke();
		context.fillStyle = fillStyleCache;
		context.strokeStyle = strokeStyleCache;
	};
	this.current = function(context,x,y){
		this.initializeStyles(context);
		var fillStyleCache = context.fillStyle;
		var strokeStyleCache = context.strokeStyle;
		y = y+7;	x = x+7;
		context.fillStyle="#FFFFFF";	context.strokeStyle="#000000";
		context.beginPath();	context.arc(x, y, 6, 0, Math.PI*2, true);
		context.closePath();
		context.fill();	context.stroke();
		context.fillStyle="#000000";	context.strokeStyle="#FFFFFF";		
		context.beginPath();
		context.arc(x, y, 3, 0, Math.PI*2, true);
		context.closePath();
		context.fill();	context.stroke();
		context.fillStyle="#FF0000";	context.strokeStyle="#000000";
		context.beginPath();
		context.arc(x+6, y-8, 3, 0, Math.PI*2, true);	context.closePath();
		context.fill();		context.stroke();
		context.fillStyle = fillStyleCache;
		context.strokeStyle = strokeStyleCache;
	};
};