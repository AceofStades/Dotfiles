"use strict";(("undefined"!=typeof self?self:global).webpackChunkopen=("undefined"!=typeof self?self:global).webpackChunkopen||[]).push([[7427],{23737:(t,e,a)=>{a.r(e),a.d(e,{OnTourPlaylistCard:()=>j,default:()=>j});var r=a(69736),n=a(3533),s=a(50959),i=a(36275),l=a(13734),c=a(2800),o=a(8570),u=a(11527);const d=(0,s.memo)((t=>{const{uri:e,pathname:a,onClick:r,...n}=t,d=(0,l.o)(),h=(0,o.g)(),m=(0,s.useContext)(c.DJ),f=(0,s.useCallback)((t=>{d({intent:"navigate",type:"click",targetUri:e}),r?.(t)}),[d,e,r]),x={referrer:m||h.getReferrer()};return(0,u.jsx)(i.rU,{...n,to:{pathname:a},state:x,onClick:f})})),h="OY58H9mX1WFQsW7RLQl0",m="tNh3W7imBCa8Yp0CS0rF",f="k30gFYUEDBj0Rs5Mqroo",x="BefqJa4WI690UuQdyvH4";const p=/^spotify:artist:([a-zA-Z0-9]+):concerts$/,v=/^spotify:concert:([a-zA-Z0-9]+)$/,j=t=>{const e=function(t){if(!t||"concerts-flp"!==t.type)return null;const{tour_title:e,tour_location:a,tour_artwork_url:r,tour_cta_text:n,tour_nav_uri:s,tour_subtitle:i,tour_date:l}=t.attributes;return e&&a&&r&&n&&s?{title:e,location:a,imageUrl:r,ctaText:n,navUri:s,subtitle:i,date:l}:null}(t.formatListData);if(!e)return null;const a=(t=>{const[,e]=t.match(p)||[];if(e)return`/artist/${e}/concerts`;const[,a]=t.match(v)||[];return a&&`/concert/${a}`})(e.navUri);return a?(0,u.jsx)("section",{children:(0,u.jsxs)(d,{uri:e.navUri,pathname:a,className:h,title:e.ctaText,children:[(0,u.jsx)("img",{className:f,src:e.imageUrl,alt:""}),e.date&&(0,u.jsx)("div",{className:m,children:(0,u.jsx)(r.x,{as:"h5",variant:"marginalBold",children:e.date})}),(0,u.jsxs)("div",{className:x,children:[(0,u.jsxs)("div",{children:[(0,u.jsx)(r.x,{as:"h2",variant:"bodyMedium",children:e.title}),(0,u.jsx)(r.x,{as:"div",variant:"bodySmall",children:e.location})]}),(0,u.jsx)("div",{children:(0,u.jsx)(n.D,{as:"span",size:"small",children:e.ctaText})})]})]})}):null}}}]);
//# sourceMappingURL=concerts-on-tour-playlist-card.js.map