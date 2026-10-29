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
; Generative industrial-organic ambient
; Self-contained synthesis
; ========================================================

; Harmonic atmosphere
instr 1
    kDrift lfo 1, 0.014, 1
    kBreath lfo 1, 0.028, 1

    kRoot = 55 * (1 + 0.01 * kDrift)
    kCutoff = 1100 + 800 * (kBreath + 1)

    a1 poscil 0.075, kRoot
    a2 poscil 0.035, kRoot * 1.498
    a3 poscil 0.022, kRoot * 2.006
    a4 poscil 0.012, kRoot * 3.97

    aBed = a1 + a2 + a3 + a4
    aBed tone aBed, kCutoff

    aEnv linen 1, 10, p3, 12
    aOut = aBed * aEnv

    aL, aR pan2 aOut, 0.5 + 0.15 * kDrift
    outs aL, aR

    ; Metallic mechanisms
    kMetalRate lfo 1, 0.09, 1
    kMetalRate = 1.2 + 1.4 * (kMetalRate + 1)
    kMetal metro kMetalRate

    if kMetal == 1 then
        kStep random 0, 12
        kFreq = 220 * (2 ^ (int(kStep) / 12))
        kDur random 0.18, 1.1
        kAmp random 0.025, 0.065
        kPan random 0.03, 0.97
        event "i", 2, 0, kDur, kFreq, kAmp, kPan
    endif

    ; Low mechanical pulses
    kPulseRate lfo 1, 0.045, 1
    kPulseRate = 0.45 + 0.3 * (kPulseRate + 1)
    kPulse metro kPulseRate

    if kPulse == 1 then
        kFreq random 42, 68
        kAmp random 0.035, 0.07
        event "i", 3, 0, 0.45, kFreq, kAmp
    endif
endin

; Metallic resonant objects
instr 2
    iFreq = p4
    iAmp = p5
    iPan = p6

    iRatio random 2.01, 3.97

    aEnv transeg 0, 0.012, 1, 1, p3 * 0.35, -3, 0.001, p3 * 0.65, -4, 0

    kBend lfo 0.006, 0.2, 1

    a1 poscil iAmp, iFreq * (1 + kBend)
    a2 poscil iAmp * 0.4, iFreq * iRatio
    a3 poscil iAmp * 0.12, iFreq * 5.13

    aMetal = (a1 + a2 + a3) * aEnv

    aL, aR pan2 aMetal, iPan
    outs aL, aR
endin

; Springy low-frequency pulse
instr 3
    iFreq = p4
    iAmp = p5

    aEnv expseg 0.001, 0.025, 1, 0.425, 0.001
    kPitch expseg 1.8, 0.08, 1, 0.37, 0.78

    aBody poscil iAmp, iFreq * kPitch
    aHarm poscil iAmp * 0.22, iFreq * 2.03

    aPulse = (aBody + aHarm) * aEnv
    aL, aR pan2 aPulse, 0.5
    outs aL, aR
endin

</CsInstruments>

<CsScore>
; 24-hour generative session
i 1 0 86400
e
</CsScore>
</CsoundSynthesizer>
