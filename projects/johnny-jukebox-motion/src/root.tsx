import React from 'react';
import {AbsoluteFill, Composition, interpolate, useCurrentFrame, useVideoConfig} from 'remotion';

type PromoProps = {artist:string; headline:string; subtitle:string; accent:string; background:string};
const defaults: PromoProps = {
 artist:'JOHNNY JUKEBOX', headline:'THE NEXT CHAPTER', subtitle:'NEW MUSIC • COMING SOON',
 accent:'#a9b9ff', background:'#090b16'
};
const Promo: React.FC<PromoProps> = ({artist,headline,subtitle,accent,background}) => {
 const frame=useCurrentFrame();
 const {fps,durationInFrames}=useVideoConfig();
 const fade=interpolate(frame,[0,Math.round(fps*.6),durationInFrames-Math.round(fps*.6),durationInFrames],[0,1,1,0],{extrapolateLeft:'clamp',extrapolateRight:'clamp'});
 const rise=interpolate(frame,[0,Math.round(fps*1.1)],[90,0],{extrapolateLeft:'clamp',extrapolateRight:'clamp'});
 const rotation=interpolate(frame,[0,durationInFrames],[0,22]);
 return <AbsoluteFill style={{background, color:'#f5f5fa',fontFamily:'Arial, sans-serif',overflow:'hidden',display:'flex',justifyContent:'center',alignItems:'center'}}>
   <div style={{position:'absolute',width:'75%',aspectRatio:'1',border:'2px solid '+accent,borderRadius:'50%',opacity:.35,transform:`rotate(${rotation}deg) scale(1.1)`}} />
   <div style={{position:'absolute',width:'52%',aspectRatio:'1',border:'1px solid '+accent,borderRadius:'50%',opacity:.4}} />
   <div style={{zIndex:1,opacity:fade,transform:`translateY(${rise}px)`,textAlign:'center',padding:65}}>
     <div style={{fontSize:34,letterSpacing:12,color:accent,fontWeight:700}}>{artist}</div>
     <div style={{fontSize:100,fontWeight:900,lineHeight:1.02,margin:'60px 0',textTransform:'uppercase'}}>{headline}</div>
     <div style={{fontSize:31,letterSpacing:6}}>{subtitle}</div>
   </div>
   <div style={{position:'absolute',bottom:75,fontSize:20,letterSpacing:5,opacity:fade}}>JUKEBOXX • ORIGINAL PROMO TEMPLATE</div>
 </AbsoluteFill>;
};
export const Root:React.FC=()=> <>
 <Composition id="JohnnyLaunch" component={Promo} durationInFrames={300} fps={30} width={1920} height={1080} defaultProps={defaults}/>
 <Composition id="JohnnySingle" component={Promo} durationInFrames={240} fps={30} width={1080} height={1920} defaultProps={{...defaults,headline:'NEW SINGLE',subtitle:'STREAMING SOON'}}/>
</>;
