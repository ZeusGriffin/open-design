import React, { useEffect, useState } from "react";

/**
 * ZEUS Visual Launch Intro
 * Reusable opening layer for apps, dashboards, prototypes, and device UIs.
 *
 * Usage:
 * <ZeusVisualLaunchIntro
 *   projectName="HORSES"
 *   projectMark="Z"
 *   duration={3200}
 *   onComplete={() => setIntroDone(true)}
 * >
 *   <YourApp />
 * </ZeusVisualLaunchIntro>
 */
export default function ZeusVisualLaunchIntro({
  projectName = "ZEUS",
  projectMark = "Z",
  duration = 3200,
  onComplete,
  children,
}) {
  const [complete, setComplete] = useState(false);

  useEffect(() => {
    const reduceMotion = window.matchMedia?.(
      "(prefers-reduced-motion: reduce)"
    )?.matches;

    const effectiveDuration = reduceMotion ? 250 : duration;
    const timer = window.setTimeout(() => {
      setComplete(true);
      onComplete?.();
    }, effectiveDuration);

    return () => window.clearTimeout(timer);
  }, [duration, onComplete]);

  return (
    <div className={`zvli-root ${complete ? "is-complete" : ""}`}>
      <style>{styles}</style>

      <div className="zvli-app" aria-hidden={!complete}>
        {children}
      </div>

      <div className="zvli-intro" aria-hidden={complete}>
        <div className="zvli-glow" />
        <div className="zvli-axis zvli-axis-x" />
        <div className="zvli-axis zvli-axis-y" />

        <div className="zvli-corners" aria-hidden="true">
          <span className="tl" />
          <span className="tr" />
          <span className="bl" />
          <span className="br" />
        </div>

        <div className="zvli-core">
          <div className="zvli-signal" />
          <div className="zvli-mark">{projectMark}</div>
          <div className="zvli-name">{projectName}</div>
        </div>

        <div className="zvli-scan" />
      </div>
    </div>
  );
}

const styles = `
.zvli-root {
  position: relative;
  width: 100%;
  height: 100%;
  min-height: 100vh;
  overflow: hidden;
  background: #050505;
}

.zvli-app {
  position: absolute;
  inset: 0;
  opacity: 0;
  transform: scale(1.008);
  animation: zvli-app-in 900ms cubic-bezier(.2,.75,.2,1) 1850ms forwards;
}

.zvli-intro {
  position: absolute;
  inset: 0;
  display: grid;
  place-items: center;
  overflow: hidden;
  background: #050505;
  opacity: 1;
  pointer-events: none;
  animation: zvli-intro-out 620ms ease 2580ms forwards;
}

.zvli-glow {
  position: absolute;
  left: 50%;
  top: 50%;
  width: 22rem;
  height: 22rem;
  transform: translate(-50%, -50%) scale(.2);
  border-radius: 50%;
  background: radial-gradient(circle, rgba(255,255,255,.08), rgba(255,255,255,0) 68%);
  opacity: 0;
  animation: zvli-glow-in 1100ms ease 280ms forwards;
}

.zvli-axis {
  position: absolute;
  background: rgba(255,255,255,.16);
  opacity: 0;
  transform-origin: center;
}

.zvli-axis-x {
  left: 50%;
  top: 50%;
  width: min(68vw, 900px);
  height: 1px;
  transform: translate(-50%, -50%) scaleX(0);
  animation: zvli-line-x 650ms cubic-bezier(.2,.8,.2,1) 620ms forwards;
}

.zvli-axis-y {
  left: 50%;
  top: 50%;
  width: 1px;
  height: min(52vh, 560px);
  transform: translate(-50%, -50%) scaleY(0);
  animation: zvli-line-y 650ms cubic-bezier(.2,.8,.2,1) 760ms forwards;
}

.zvli-core {
  position: relative;
  z-index: 4;
  display: grid;
  justify-items: center;
  gap: 10px;
}

.zvli-signal {
  width: 4px;
  height: 4px;
  border-radius: 999px;
  background: #fff;
  box-shadow: 0 0 18px rgba(255,255,255,.5);
  opacity: 0;
  transform: scale(.2);
  animation: zvli-signal 480ms ease 330ms forwards;
}

.zvli-mark {
  margin-top: 2px;
  font: 600 clamp(38px, 7vw, 92px)/.9 ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
  letter-spacing: -.055em;
  color: #fff;
  opacity: 0;
  filter: blur(7px);
  transform: scale(.965);
  animation: zvli-mark 620ms cubic-bezier(.2,.8,.2,1) 1120ms forwards;
}

.zvli-name {
  font: 500 11px/1 ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
  letter-spacing: .32em;
  text-transform: uppercase;
  color: rgba(255,255,255,.66);
  opacity: 0;
  transform: translateY(4px);
  animation: zvli-name 420ms ease 1430ms forwards;
}

.zvli-corners span {
  position: absolute;
  width: 26px;
  height: 26px;
  opacity: 0;
  animation: zvli-corner-in 480ms ease 920ms forwards;
}

.zvli-corners .tl {
  left: 7vw;
  top: 7vh;
  border-left: 1px solid rgba(255,255,255,.2);
  border-top: 1px solid rgba(255,255,255,.2);
}
.zvli-corners .tr {
  right: 7vw;
  top: 7vh;
  border-right: 1px solid rgba(255,255,255,.2);
  border-top: 1px solid rgba(255,255,255,.2);
}
.zvli-corners .bl {
  left: 7vw;
  bottom: 7vh;
  border-left: 1px solid rgba(255,255,255,.2);
  border-bottom: 1px solid rgba(255,255,255,.2);
}
.zvli-corners .br {
  right: 7vw;
  bottom: 7vh;
  border-right: 1px solid rgba(255,255,255,.2);
  border-bottom: 1px solid rgba(255,255,255,.2);
}

.zvli-scan {
  position: absolute;
  left: 0;
  right: 0;
  top: 46%;
  height: 1px;
  background: linear-gradient(90deg, transparent, rgba(255,255,255,.2), transparent);
  opacity: 0;
  transform: translateY(-14vh);
  animation: zvli-scan 900ms ease 1050ms forwards;
}

.is-complete .zvli-intro {
  display: none;
}

.is-complete .zvli-app {
  opacity: 1;
  transform: none;
}

@keyframes zvli-signal {
  to { opacity: 1; transform: scale(1); }
}

@keyframes zvli-glow-in {
  0% { opacity: 0; transform: translate(-50%, -50%) scale(.2); }
  55% { opacity: 1; }
  100% { opacity: .7; transform: translate(-50%, -50%) scale(1); }
}

@keyframes zvli-line-x {
  0% { opacity: 0; transform: translate(-50%, -50%) scaleX(0); }
  100% { opacity: 1; transform: translate(-50%, -50%) scaleX(1); }
}

@keyframes zvli-line-y {
  0% { opacity: 0; transform: translate(-50%, -50%) scaleY(0); }
  100% { opacity: 1; transform: translate(-50%, -50%) scaleY(1); }
}

@keyframes zvli-mark {
  to {
    opacity: 1;
    filter: blur(0);
    transform: scale(1);
  }
}

@keyframes zvli-name {
  to { opacity: 1; transform: translateY(0); }
}

@keyframes zvli-corner-in {
  to { opacity: 1; }
}

@keyframes zvli-scan {
  0% { opacity: 0; transform: translateY(-14vh); }
  20% { opacity: 1; }
  100% { opacity: 0; transform: translateY(20vh); }
}

@keyframes zvli-app-in {
  0% { opacity: 0; transform: scale(1.008); filter: blur(8px); }
  100% { opacity: 1; transform: scale(1); filter: blur(0); }
}

@keyframes zvli-intro-out {
  0% { opacity: 1; }
  100% { opacity: 0; }
}

@media (prefers-reduced-motion: reduce) {
  .zvli-intro {
    animation-duration: 150ms;
    animation-delay: 0ms;
  }

  .zvli-app {
    animation-duration: 150ms;
    animation-delay: 0ms;
  }

  .zvli-glow,
  .zvli-axis,
  .zvli-signal,
  .zvli-mark,
  .zvli-name,
  .zvli-corners span,
  .zvli-scan {
    animation: none !important;
  }
}
`;
