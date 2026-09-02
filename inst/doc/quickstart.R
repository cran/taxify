## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = FALSE
)
library(taxify)

## ----va-engine, echo = FALSE, results = "asis", eval = TRUE-------------------
cat('
<style>
pre, pre.sourceCode, div.sourceCode { overflow-x: auto; max-width: 100%; }
canvas { display:block; margin: 6px auto; }
</style>
<script>
window.VA = {
  ease:function(t){return t<0.5?2*t*t:1-Math.pow(-2*t+2,2)/2;},
  easeOut:function(t){return 1-Math.pow(1-t,3);},
  lerp:function(a,b,t){return a+(b-a)*t;},
  clamp:function(v,a,b){return Math.max(a,Math.min(b,v));},
  C:{bg:"#0b0d17",grid:"#19203a",green:"#33ff8a",red:"#ff3b6b",cyan:"#3ad7ff",amber:"#ffc24b",purple:"#b388ff",ink:"#d7def7",mut:"#7f8bb5",off:"#1d2540"},
  F:function(sz,bold){return (bold?"bold ":"")+Math.round(sz*1.25)+"px monospace";},
  bg:function(c,w,h){c.fillStyle=this.C.bg;c.fillRect(0,0,w,h);c.strokeStyle=this.C.grid;c.lineWidth=1;for(var gx=26;gx<w;gx+=26){c.beginPath();c.moveTo(gx+0.5,0);c.lineTo(gx+0.5,h);c.stroke();}for(var gy=26;gy<h;gy+=26){c.beginPath();c.moveTo(0,gy+0.5);c.lineTo(w,gy+0.5);c.stroke();}},
  scan:function(c,w,h){c.save();c.globalAlpha=0.07;c.fillStyle="#000";for(var y=0;y<h;y+=3)c.fillRect(0,y,w,1);c.restore();},
  glow:function(c,col,b){c.shadowColor=col;c.shadowBlur=b;},
  noglow:function(c){c.shadowBlur=0;c.shadowColor="transparent";},
  setup:function(id){var cv=document.getElementById(id);if(!cv)return null;var ctx=cv.getContext("2d");var w=cv.width,h=cv.height,d=window.devicePixelRatio||1;cv.width=w*d;cv.height=h*d;cv.style.width=w+"px";cv.style.height="auto";ctx.scale(d,d);return {ctx:ctx,w:w,h:h};},
  run:function(drawAt,period,btnId,key,cvId){var fz=(window.__FREEZE&&(key in window.__FREEZE))?window.__FREEZE[key]:null;if(fz!=null){drawAt(((fz%period)+period)%period);return;}var start=performance.now();function loop(now){var e=(now-start)/1000;if(e<0)e=0;drawAt(e%period);requestAnimationFrame(loop);}requestAnimationFrame(loop);function restart(){start=performance.now();}if(btnId){var b=document.getElementById(btnId);if(b)b.onclick=restart;}if(cvId){var cv=document.getElementById(cvId);if(cv){cv.style.cursor="pointer";cv.title="click to replay";cv.onclick=restart;}}}
};
</script>
')

## -----------------------------------------------------------------------------
# field_names <- c(
#   "Quercus robur L.",        # authorship to strip
#   "Quercus robus",           # typo
#   "cf. Betula pendula",      # field qualifier
#   "FAGUS SYLVATICA",         # caps
#   "Quercus pedunculata",     # historical synonym of Q. robur
#   "Q. petraea",              # abbreviated genus
#   "Pinus abies",             # synonym of Picea abies (a different genus)
#   "Festuca rubrra",          # typo
#   "Fallopia japonica",       # synonym of Reynoutria japonica (invasive)
#   "Taraxacum officinale"
# )
# 
# res <- taxify(field_names)
# res[, c("input_name", "accepted_name", "family",
#         "is_synonym", "match_type", "fuzzy_dist")]

## ----pipe-anim, echo = FALSE, results = "asis", eval = TRUE-------------------
body <- "
var s=VA.setup('pp-cv'); if(!s)return; var x=s.ctx,W=s.w,H=s.h,C=VA.C;
var N=NM.length;
var labs=['input','clean','match','resolve','accepted'];
var SX=[64,232,420,602,786];
var yTrack=176;
var PER_NAME=4.2,PERIOD=N*PER_NAME;
function chip(cx,cy,txt,col,w){x.font=VA.F(12);var tw=x.measureText(txt).width;var hw=(w||Math.max(70,tw+16))/2;hw=Math.min(hw,(W-12)/2);cx=VA.clamp(cx,hw+6,W-hw-6);x.save();VA.glow(x,col,9);x.fillStyle=C.bg;x.strokeStyle=col;x.lineWidth=2;x.beginPath();x.rect(cx-hw,cy-15,hw*2,30);x.fill();x.stroke();VA.noglow(x);x.fillStyle=C.ink;x.textAlign='center';x.textBaseline='middle';x.fillText(txt,cx,cy);x.restore();x.textBaseline='alphabetic';}
function station(i,active,col,sub){var cx=SX[i];x.strokeStyle=active?col:C.off;x.lineWidth=active?2:1;if(active)VA.glow(x,col,8);x.beginPath();x.arc(cx,yTrack,11,0,6.2832);x.stroke();VA.noglow(x);if(active){x.fillStyle=col;x.beginPath();x.arc(cx,yTrack,4,0,6.2832);x.fill();}x.fillStyle=active?C.ink:C.mut;x.font=VA.F(12,active);x.textAlign='center';x.fillText(labs[i],cx,yTrack+34);if(sub){x.fillStyle=col;x.font=VA.F(11);x.fillText(sub,cx,yTrack+50);}}
function draw(tc){VA.bg(x,W,H);
  VA.glow(x,C.cyan,7);x.fillStyle=C.cyan;x.textAlign='left';x.font=VA.F(15,true);x.fillText('ONE NAME THROUGH THE PIPELINE',16,28);VA.noglow(x);
  var gi=Math.min(N-1,Math.floor(tc/PER_NAME));var lt=(tc-gi*PER_NAME)/PER_NAME;
  var isSyn=SYN[gi]===1;var isNone=MT[gi]==='none';
  x.strokeStyle=C.grid;x.lineWidth=2;x.beginPath();x.moveTo(SX[0],yTrack);x.lineTo(SX[4],yTrack);x.stroke();
  var seg=VA.clamp(lt/0.5,0,1)*4;var here=Math.floor(seg+0.0001);
  for(var i=0;i<5;i++){
    var reached=i<=here;
    var col=C.cyan;var sub=null;
    if(i===1){col=C.amber;sub=reached?CLN[gi]:null;}
    if(i===2){col=isNone?C.red:C.green;sub=reached?MAT[gi]:null;}
    if(i===3){col=C.purple;sub=reached?(isSyn?'synonym':'already accepted'):null;if(!isSyn)col=C.off;}
    if(i===4){col=isNone?C.red:C.green;}
    station(i,reached,col,sub);
  }
  var a=Math.min(3,Math.floor(seg)),f=VA.clamp(seg-a,0,1);
  var px=VA.lerp(SX[a],SX[a+1],VA.easeOut(f));
  if(lt<0.5) chip(px,yTrack-46,NM[gi],isNone?C.red:C.cyan);
  x.fillStyle=C.mut;x.font=VA.F(12);x.textAlign='center';x.fillText('input',SX[0],yTrack-86);
  x.fillStyle=isNone?C.red:C.green;x.font=VA.F(12,true);x.fillText(isNone?'unmatched':'accepted name',SX[4],yTrack-86);
  if(lt>=0.5){var aa=VA.clamp((lt-0.5)/0.2,0,1);x.globalAlpha=aa;chip(SX[4],yTrack-46,ACC[gi],isNone?C.red:C.green);x.globalAlpha=1;}
  var dotw=12;for(var k=0;k<N;k++){var dx=W/2-(N-1)*dotw/2+k*dotw;x.fillStyle=k===gi?C.cyan:C.off;x.beginPath();x.arc(dx,H-20,k===gi?4:3,0,6.2832);x.fill();}
  VA.scan(x,W,H);
}
VA.run(draw,PERIOD,null,'pp','pp-cv');
"
cat(paste0(
  "<canvas id='pp-cv' width='860' height='360' style='max-width:100%'></canvas>\n",
  "<script>\n(function(){\n",
  "var NM=[\"Quercus robur L.\",\"Quercus robus\",\"cf. Betula pendula\",\"FAGUS SYLVATICA\",\"Quercus pedunculata\",\"Q. petraea\",\"Pinus abies\",\"Festuca rubrra\",\"Fallopia japonica\",\"Taraxacum officinale\"];\n",
  "var ACC=[\"Quercus robur\",\"Quercus robur\",\"Betula pendula\",\"Fagus sylvatica\",\"Quercus robur\",\"Quercus petraea\",\"Picea abies\",\"Festuca rubra\",\"Reynoutria japonica\",\"Taraxacum officinale\"];\n",
  "var MT=[\"exact\",\"fuzzy\",\"exact\",\"exact_ci\",\"exact\",\"abbrev\",\"exact\",\"fuzzy\",\"exact\",\"exact\"];\n",
  "var CLN=[\"strip author\",\"normalize\",\"drop qualifier\",\"case-fold\",\"normalize\",\"expand genus\",\"normalize\",\"normalize\",\"normalize\",\"normalize\"];\n",
  "var MAT=[\"exact match\",\"fuzzy, dist 0.077\",\"exact match\",\"case-folded match\",\"exact match\",\"abbreviated genus\",\"exact match\",\"fuzzy, dist 0.071\",\"exact match\",\"exact match\"];\n",
  "var SYN=[0,0,0,0,1,0,1,0,1,0];\n",
  body, "\n})();\n</script>\n"))

## ----block-anim, echo = FALSE, results = "asis", eval = TRUE------------------
body <- "
var s=VA.setup('bl-cv'); if(!s)return; var x=s.ctx,W=s.w,H=s.h,C=VA.C;
var GX=16,GY=64,COLS=44,ROWS=22,TW=13,TH=15,GW=COLS*TW,GH=ROWS*TH;
var bc0=8,bc1=15,br0=7,br1=13;
var winC=12,winR=10;
var GGX=GX+GW+44,GGW=64,GGY=64,GGH=GH;
var T1=4.8,H1=2.0,T2=5.9,H2=3.4,CYCLE=T1+H1+T2+H2;
function inBlock(c,r){return c>=bc0&&c<=bc1&&r>=br0&&r<=br1;}
function tile(c,r,col,a){x.globalAlpha=a;x.fillStyle=col;x.fillRect(GX+c*TW,GY+r*TH,TW-1.4,TH-1.4);x.globalAlpha=1;}
function frame(){VA.glow(x,C.cyan,6);x.strokeStyle=C.cyan;x.strokeRect(GX,GY,GW,GH);VA.noglow(x);}
function blockOutline(){VA.glow(x,C.green,10);x.strokeStyle=C.green;x.lineWidth=2;x.strokeRect(GX+bc0*TW-1,GY+br0*TH-1,(bc1-bc0+1)*TW,(br1-br0+1)*TH);x.lineWidth=1;VA.noglow(x);}
function gauge(frac,col,ghost,pct){x.strokeStyle=C.mut;x.strokeRect(GGX,GGY,GGW,GGH);var h=Math.max(frac>0?2:0,frac*GGH);VA.glow(x,col,8);x.fillStyle=col;x.fillRect(GGX+1,GGY+GGH-h,GGW-2,h);VA.noglow(x);if(ghost){x.strokeStyle=C.red;x.setLineDash([5,4]);x.lineWidth=1.5;x.beginPath();x.moveTo(GGX-4,GGY+2);x.lineTo(GGX+GGW+4,GGY+2);x.stroke();x.setLineDash([]);x.lineWidth=1;x.fillStyle=C.red;x.font=VA.F(11);x.textAlign='left';x.fillText('whole backbone',GGX-6,GGY-10);}x.fillStyle=C.ink;x.font=VA.F(14,true);x.textAlign='center';x.fillText(pct,GGX+GGW/2,GGY+GGH+20);x.fillStyle=C.mut;x.font=VA.F(11);x.fillText('names scored',GGX+GGW/2,GGY+GGH+36);}
function header(t,col){x.textAlign='left';VA.glow(x,C.cyan,7);x.fillStyle=C.cyan;x.font=VA.F(15,true);x.fillText('FUZZY MATCH :: Quercus robus',16,26);VA.noglow(x);x.fillStyle=col;x.font=VA.F(13);x.fillText(t,16,46);}
function draw(tc){VA.bg(x,W,H);
  var c,r;
  if(tc<T1){var f=VA.ease(tc/T1);var lim=Math.floor(f*ROWS);
    for(r=0;r<ROWS;r++)for(c=0;c<COLS;c++){var on=r<lim;tile(c,r,on?C.red:C.off,on?0.85:0.5);}
    frame();gauge(f,C.red,false,Math.round(f*100)+'%');
    header('without blocking: every name on disk is a candidate',C.red);
  } else if(tc<T1+H1){
    for(r=0;r<ROWS;r++)for(c=0;c<COLS;c++)tile(c,r,C.red,0.85);
    frame();gauge(1,C.red,false,'100%');
    header('without blocking: every name on disk is a candidate',C.red);
  } else if(tc<T1+H1+T2){
    var ff=(tc-T1-H1)/T2;
    for(r=0;r<ROWS;r++)for(c=0;c<COLS;c++){var ib=inBlock(c,r);tile(c,r,ib?C.green:C.off,ib?0.85:0.34);}
    blockOutline();frame();
    var scanned=Math.floor(ff*(bc1-bc0+1));
    VA.glow(x,C.amber,7);x.strokeStyle=C.amber;x.lineWidth=2;var sc=Math.min(bc1,bc0+scanned);x.beginPath();x.moveTo(GX+sc*TW,GY+br0*TH);x.lineTo(GX+sc*TW,GY+(br1+1)*TH);x.stroke();x.lineWidth=1;VA.noglow(x);
    if(ff>0.7){VA.glow(x,'#fff',10);x.fillStyle='#fff';x.fillRect(GX+winC*TW,GY+winR*TH,TW-1.4,TH-1.4);VA.noglow(x);}
    gauge(0.06,C.green,true,'one genus');
    header('genus-blocked: scored only against other Quercus',C.green);
  } else {
    for(r=0;r<ROWS;r++)for(c=0;c<COLS;c++){var ib2=inBlock(c,r);tile(c,r,ib2?C.green:C.off,ib2?0.55:0.3);}
    blockOutline();frame();
    VA.glow(x,'#fff',12);x.fillStyle='#fff';x.fillRect(GX+winC*TW,GY+winR*TH,TW-1.4,TH-1.4);VA.noglow(x);
    x.fillStyle=C.green;x.font=VA.F(13,true);x.textAlign='left';x.fillText('-> '+QACC+'   (1 edit, dist '+QD+')',GX,GY+GH+24);
    gauge(0.06,C.green,true,'one genus');
    header('match found inside the block',C.green);
  }
  VA.scan(x,W,H);
}
VA.run(draw,CYCLE,null,'bl','bl-cv');
"
cat(paste0(
  "<canvas id='bl-cv' width='860' height='460' style='max-width:100%'></canvas>\n",
  "<script>\n(function(){\n",
  "var QACC=\"Quercus robur\",QD=0.077;\n",
  body, "\n})();\n</script>\n"))

## -----------------------------------------------------------------------------
# summary(res)

## ----benchmark-anim, echo = FALSE, results = "asis", eval = TRUE--------------
body <- "
var s=VA.setup('sp-cv'); if(!s)return; var x=s.ctx,W=s.w,H=s.h,C=VA.C;
var BX=150,BW=W-150-150,b1=96,b2=190,bh=46;
var PERIOD=17,HOLD=4;
function fmt(sec){if(sec<60)return sec.toFixed(1)+' s';var m=sec/60;return sec.toFixed(0)+' s ('+m.toFixed(0)+' min)';}
function bar(y,frac,col,name,done,lab){
  x.fillStyle=C.off;x.fillRect(BX,y,BW,bh);
  var w=Math.max(frac>0?3:0,frac*BW);
  if(done)VA.glow(x,col,10);x.fillStyle=col;x.fillRect(BX,y,w,bh);VA.noglow(x);
  x.strokeStyle=C.grid;x.strokeRect(BX,y,BW,bh);
  x.fillStyle=C.ink;x.font=VA.F(14,true);x.textAlign='right';x.fillText(name,BX-12,y+bh/2+5);
  x.fillStyle=done?col:C.mut;x.font=VA.F(13,true);x.textAlign='left';x.fillText(lab,BX+w+12,y+bh/2+5);
}
function draw(tc){VA.bg(x,W,H);
  VA.glow(x,C.cyan,7);x.fillStyle=C.cyan;x.textAlign='left';x.font=VA.F(15,true);x.fillText('FUZZY MATCH :: 1,000 NAMES',16,28);VA.noglow(x);
  var run=Math.min(tc,PERIOD-HOLD);var prog=run/(PERIOD-HOLD);
  var simSec=prog*WFO;
  var taxDone=simSec>=TAX;
  var taxFrac=taxDone?1:simSec/TAX;
  var wfoFrac=Math.min(1,simSec/WFO);
  bar(b1,taxFrac,C.green,'taxify',taxDone,taxDone?fmt(TAX):'');
  bar(b2,wfoFrac,C.red,'WorldFlora',wfoFrac>=1,wfoFrac>=1?fmt(WFO):fmt(simSec));
  x.fillStyle=C.mut;x.font=VA.F(12);x.textAlign='left';x.fillText('elapsed (simulated): '+fmt(simSec),BX,b2+bh+22);
  if(taxDone&&tc>PERIOD-HOLD-0.01){var aa=VA.clamp((tc-(PERIOD-HOLD))/1.0,0,1);x.globalAlpha=aa;VA.glow(x,C.green,8);x.fillStyle=C.green;x.font=VA.F(20,true);x.textAlign='center';x.fillText(Math.round(WFO/TAX)+'x faster',W/2,H-40);VA.noglow(x);x.globalAlpha=1;}
  VA.scan(x,W,H);
}
VA.run(draw,PERIOD,null,'sp','sp-cv');
"
cat(paste0(
  "<canvas id='sp-cv' width='760' height='330' style='max-width:100%'></canvas>\n",
  "<script>\n(function(){\n",
  "var TAX=18.8,WFO=4192.4;\n",
  body, "\n})();\n</script>\n"))

## -----------------------------------------------------------------------------
# my_traits <- data.frame(
#   species      = c("Quercus pedunculata",   # synonym of Q. robur
#                    "Pinus sylvestris",
#                    "Betula pendula"),
#   seed_mass_mg = c(3200, 7.5, 0.2)
# )
# 
# taxify(c("Quercus robur", "Pinus sylvestris", "Betula pendula")) |>
#   add_data(my_traits, species_col = "species")

## ----enrich-anim, echo = FALSE, results = "asis", eval = TRUE-----------------
con_data <- "var G=[
{n:'Plants',s:'Plants',c:'#6bcb77',L:[['add_zanne()','woody / herbaceous'],['add_eive()','EIVE indicator values'],['add_diaz_traits()','seed mass & height'],['add_leda()','LEDA life-history'],['add_wcvp()','native range'],['add_glonaf()','naturalized alien flora'],['add_baseflor()','ecological traits'],['add_ecoflora()','British flora'],['add_floraweb()','German flora'],['add_pignatti()','Italian indicator values'],['add_fungalroot()','mycorrhizal type']]},
{n:'Birds & mammals',s:'Birds/mammals',c:'#3ad7ff',L:[['add_avonet()','bird morphology'],['add_elton_traits()','diet & body mass'],['add_pantheria()','mammal life-history']]},
{n:'Amphibians & reptiles',s:'Amph & reptiles',c:'#b388ff',L:[['add_amphibio()','amphibian traits'],['add_repttraits()','reptile traits & range']]},
{n:'Fish',s:'Fish',c:'#4d96ff',L:[['add_fishmorph()','morphology'],['add_fishbase()','ecology']]},
{n:'Arthropods',s:'Arthropods',c:'#ff8fd0',L:[['add_arthropod_traits()','arthropod traits'],['add_leptraits()','butterfly traits']]},
{n:'Fungi',s:'Fungi',c:'#ffd93d',L:[['add_fungal_traits()','fungal traits'],['add_funguild()','trophic guild']]},
{n:'Algae',s:'Algae',c:'#33ffd0',L:[['add_algae_traits()','algal traits']]},
{n:'Cross-taxon animals',s:'Cross-taxon',c:'#ffc24b',L:[['add_animaltraits()','body mass & metabolism'],['add_anage()','longevity & ageing']]},
{n:'Status, alien & names',s:'Status & alien',c:'#ff3b6b',L:[['add_iucn()','IUCN Red List'],['add_griis()','GRIIS invasive'],['add_alien_first_records()','first-record years'],['add_common_names()','vernacular names']]}
];
"
body <- "
var s=VA.setup('en-cv'); if(!s)return; var x=s.ctx,W=s.w,H=s.h,C=VA.C;
var NG=G.length;
var cx=280,cy=298,R=192;
var px0=556,pw=W-556-12;
var nLayers=0;for(var gi=0;gi<NG;gi++)nLayers+=G[gi].L.length;
var FOC=3.1,PERIOD=NG*FOC;
function ang(i){return -Math.PI/2 + i*2*Math.PI/NG;}
function node(i){return {x:cx+R*Math.cos(ang(i)),y:cy+R*Math.sin(ang(i))};}
function hub(){var w=152,h=34;x.save();VA.glow(x,C.cyan,14);x.fillStyle=C.bg;x.strokeStyle=C.cyan;x.lineWidth=2;x.beginPath();x.rect(cx-w/2,cy-h/2,w,h);x.fill();x.stroke();VA.noglow(x);x.fillStyle=C.cyan;x.font=VA.F(13,true);x.textAlign='center';x.textBaseline='middle';x.fillText('accepted_name',cx,cy);x.restore();x.textBaseline='alphabetic';}
function spoke(i,foc){var n=node(i);x.strokeStyle=foc?G[i].c:C.off;x.lineWidth=foc?2:1;if(foc)VA.glow(x,G[i].c,6);x.beginPath();x.moveTo(cx,cy);x.lineTo(n.x,n.y);x.stroke();VA.noglow(x);}
function gnode(i,foc,pulse){var n=node(i);var rad=foc?13+2*pulse:8;if(foc)VA.glow(x,G[i].c,12);x.fillStyle=foc?G[i].c:C.off;x.beginPath();x.arc(n.x,n.y,rad,0,6.2832);x.fill();VA.noglow(x);x.fillStyle=foc?C.ink:C.mut;x.font=VA.F(11,foc);x.textAlign='center';var below=n.y>=cy;var ly=n.y+(below?rad+15:-rad-8);x.fillText(G[i].s,n.x,ly);x.fillStyle=foc?G[i].c:C.mut;x.font=VA.F(10);x.fillText('('+G[i].L.length+')',n.x,ly+(below?13:-13));}
function travel(i,t){var n=node(i);var u=t-Math.floor(t);var tx=VA.lerp(n.x,cx,VA.easeOut(u)),ty=VA.lerp(n.y,cy,VA.easeOut(u));VA.glow(x,G[i].c,8);x.fillStyle=G[i].c;x.beginPath();x.arc(tx,ty,3.6,0,6.2832);x.fill();VA.noglow(x);}
function panel(i,lt){var g=G[i];x.textAlign='left';VA.glow(x,g.c,8);x.fillStyle=g.c;x.font=VA.F(15,true);x.fillText(g.n,px0,92);VA.noglow(x);x.strokeStyle=g.c;x.lineWidth=2;x.beginPath();x.moveTo(px0,102);x.lineTo(px0+pw,102);x.stroke();x.lineWidth=1;for(var k=0;k<g.L.length;k++){var ry=132+k*42;var a=VA.clamp((lt-0.05-k*0.06)/0.3,0,1);if(a<=0)continue;x.globalAlpha=a;x.fillStyle=C.ink;x.font=VA.F(13,true);x.fillText(g.L[k][0],px0,ry);x.fillStyle=C.mut;x.font=VA.F(11);x.fillText(g.L[k][1],px0,ry+16);x.globalAlpha=1;}}
function draw(tc){VA.bg(x,W,H);
  VA.glow(x,C.cyan,7);x.fillStyle=C.cyan;x.textAlign='left';x.font=VA.F(15,true);x.fillText('ONE NAME, EVERY LAYER',16,28);VA.noglow(x);
  x.fillStyle=C.mut;x.font=VA.F(12);x.textAlign='left';x.fillText(nLayers+' layers across '+NG+' groups, all keyed on the accepted name',16,48);
  var foc=Math.min(NG-1,Math.floor(tc/FOC));var lt=(tc-foc*FOC)/FOC;
  for(var i=0;i<NG;i++)spoke(i,i===foc);
  var pulse=Math.sin(lt*Math.PI);
  for(i=0;i<NG;i++)gnode(i,i===foc,pulse);
  travel(foc,tc/FOC*1.7);
  hub();
  panel(foc,lt);
  VA.scan(x,W,H);
}
VA.run(draw,PERIOD,null,'en','en-cv');
"
cat(paste0(
  "<canvas id='en-cv' width='880' height='540' style='max-width:100%'></canvas>\n",
  "<script>\n(function(){\n", con_data, body, "\n})();\n</script>\n"))

## -----------------------------------------------------------------------------
# field <- c(
#   "Quercus petraea", "Pinus sylvestris", "Picea abies", "Betula pendula",
#   "Acer pseudoplatanus", "Acer platanoides", "Acer campestre", "Corylus avellana",
#   "Fraxinus excelsior", "Carpinus betulus", "Sorbus aucuparia", "Tilia cordata",
#   "Ulmus glabra", "Alnus glutinosa", "Salix caprea", "Populus tremula",
#   "Prunus avium", "Prunus spinosa", "Crataegus monogyna", "Sambucus nigra",
#   "Cornus sanguinea", "Viburnum opulus", "Euonymus europaeus", "Ligustrum vulgare",
#   "Frangula alnus", "Juniperus communis", "Taxus baccata", "Larix decidua",
#   "Abies alba", "Rosa canina", "Rubus idaeus", "Hedera helix",
#   "Clematis vitalba", "Berberis vulgaris", "Betula pubescens", "Prunus padus",
#   "Rhamnus cathartica", "Lonicera xylosteum", "Trifolium repens", "Trifolium pratense",
#   "Festuca ovina", "Dactylis glomerata", "Plantago lanceolata", "Plantago major",
#   "Plantago media", "Achillea millefolium", "Ranunculus acris", "Ranunculus repens",
#   "Urtica dioica", "Poa pratensis", "Poa annua", "Galium mollugo",
#   "Galium aparine", "Bellis perennis", "Cardamine pratensis", "Cirsium arvense",
#   "Cirsium vulgare", "Daucus carota", "Heracleum sphondylium", "Anthriscus sylvestris",
#   "Lotus corniculatus", "Medicago lupulina", "Vicia cracca", "Lathyrus pratensis",
#   "Stellaria media", "Silene dioica", "Silene vulgaris", "Geranium pratense",
#   "Geranium robertianum", "Glechoma hederacea", "Lamium album", "Prunella vulgaris",
#   "Ajuga reptans", "Veronica chamaedrys", "Rumex acetosa", "Rumex obtusifolius",
#   "Chenopodium album", "Capsella bursa-pastoris", "Senecio vulgaris", "Leucanthemum vulgare",
#   "Centaurea jacea", "Knautia arvensis", "Campanula rotundifolia", "Primula veris",
#   "Anemone nemorosa", "Filipendula ulmaria", "Lythrum salicaria", "Robinia pseudoacacia",
#   "Solidago canadensis", "Solidago gigantea", "Impatiens glandulifera",
#   "Heracleum mantegazzianum", "Prunus serotina", "Quercus rubra",
#   "Quercus robur L.", "FAGUS SYLVATICA", "Quercus robus",
#   "cf. Taraxacum officinale", "Quercus pedunculata", "Festuca rubrra"
# )
# 
# dat <- taxify(field) |>
#   add_zanne() |>
#   add_eive() |>
#   add_diaz_traits()
# 
# head(dat[, c("accepted_name", "woodiness", "eive_light",
#              "eive_reaction", "eive_nutrients", "plant_height_m")], 6)

## -----------------------------------------------------------------------------
# cor.test(dat$eive_reaction, dat$eive_nutrients)

