let scorerattributes=document.getElementById("scoreritemlocator");
let playerbadgecolor=scorerattributes.dataset.color;
let playerbadgebgcolor=scorerattributes.dataset.colorBg;
let playerbadgejerseynumber=scorerattributes.dataset.jerseynumber;
let pitchcontainer=document.getElementById("pitcheventform");

pitchcontainer.addEventListener("click", (event) => {	
	pitchcontainer.innerHTML = "";
	let xcoordfordb=parseFloat((event.offsetX/event.target.clientWidth*100).toFixed(2));
	document.getElementById("xpitchcoord").value=xcoordfordb;
	let ycoordfordb=parseFloat((event.offsetY/event.target.clientHeight*100).toFixed(2));
	document.getElementById("ypitchcoord").value=ycoordfordb;
	pitchcontainer.innerHTML = "<div class='itemlocator player-number' style='color:"+playerbadgecolor+";background-color:"+playerbadgebgcolor+";top:"+(event.offsetY-10)+"px;left:"+(event.offsetX-10)+"px'>"+playerbadgejerseynumber+"</div>";
});

let cagecontainer=document.getElementById("cageeventform");

cagecontainer.addEventListener("click", (event) => {	
	cagecontainer.innerHTML = "";
	let xcoordfordb=parseFloat((event.offsetX/event.target.clientWidth*100).toFixed(2));
	document.getElementById("xcagecoord").value=xcoordfordb;
	let ycoordfordb=parseFloat((event.offsetY/event.target.clientHeight*100).toFixed(2));
	document.getElementById("ycagecoord").value=ycoordfordb;
	cagecontainer.innerHTML = "<div class='itemlocator goalpointer' style='top:"+(event.offsetY-12)+"px;left:"+(event.offsetX-10)+"px'>⚽️</div>";
});