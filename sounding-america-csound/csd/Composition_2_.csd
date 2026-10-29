<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>

<CsInstruments>
sr = 48000
ksmps = 64
nchnls = 2
0dbfs = 1

; ========================================================
; EXPOFORUM — QUANTUM DRIFT
; Unstable harmonic generative environment
; No external samples
; ========================================================

; Deep, slowly shifting harmonic field
instr 1
    kDrift lfo 1, 0.013, 1
    kBreath lfo 1, 0.031, 1
    kOrbit lfo 1, 0.019, 1

    kRoot = 51.9 * (1 + 0.018 * kDrift)
    kCutoff = 1000 + 950 * (kBreath + 1)

    a1 poscil 0.075, kRoot
    a2 poscil 0.037, kRoot * 1.414
    a3 poscil 0.023, kRoot * 2.013
    a4 poscil 0.014, kRoot * 3.997

    aField = a1 + a2 + a3 + a4
    aField tone aField, kCutoff

    aEnv linen 1, 12, p3, 15
    aOut = aField * aEnv

    aL, aR pan2 aOut, 0.5 + 0.2 * kOrbit
    outs aL, aR

    ; Irregular electronic events
    kDensity lfo 1, 0.16, 1
    kDensity = 1.6 + 2.0 * (kDensity + 1)
    kTrig metro kDensity

    if kTrig == 1 then
        kDegree random 0, 15
        kFreq = 155.56 * (2 ^ (int(kDegree) / 12))
        kFreq = kFreq * 1.006
        kDur random 0.12, 1.8
        kAmp random 0.018, 0.06
        kPan random 0.02, 0.98
        event "i", 2, 0, kDur, kFreq, kAmp, kPan
    endif

    ; Occasional unstable high-frequency flashes
    kFlash metro 0.23
    if kFlash == 1 then
        kFreq random 700, 1700
        kDur random 0.08, 0.45
        kAmp random 0.008, 0.028
        kPan random 0.03, 0.97
        event "i", 3, 0, kDur, kFreq, kAmp, kPan
    endif
endin

; Microtonal harmonic particles
instr 2
    iFreq = p4
    iAmp = p5
    iPan = p6

    iRatio random 1.98, 3.07
    iDetune random 0.992, 1.009

    aEnv transeg 0, 0.025, 1, 1, p3 * 0.35, -2, 0.001, p3 * 0.625, -3, 0

    kDrift lfo 0.012, 0.4, 1

    a1 poscil iAmp, iFreq * iDetune * (1 + kDrift)
    a2 poscil iAmp * 0.3, iFreq * iRatio
    a3 poscil iAmp * 0.1, iFreq * 4.03

    aSignal = (a1 + a2 + a3) * aEnv

    kPan lfo 0.25, 0.13, 1
    aL, aR pan2 aSignal, limit(iPan + kPan, 0.02, 0.98)
    outs aL, aR
endin

; Short, bright digital flashes
instr 3
    iFreq = p4
    iAmp = p5
    iPan = p6

    aEnv transeg 0, 0.008, 1, 1, p3 * 0.25, -3, 0.001, p3 * 0.72, -4, 0

    kPitch lfo 0.018, 4.1, 1

    a1 poscil iAmp, iFreq * (1 + kPitch)
    a2 poscil iAmp * 0.2, iFreq * 2.71

    aFlash = (a1 + a2) * aEnv

    aL, aR pan2 aFlash, iPan
    outs aL, aR
endin

</CsInstruments>

<CsScore>
; Long-form generative session: 24 hours
i 1 0 86400
e
</CsScore>
</CsoundSynthesizer>
